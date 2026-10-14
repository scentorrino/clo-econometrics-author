## ---------------------------------------------------------------------------
## adjoint_kit.R -- the shared machinery for the adjoint-identity diagnostic.
##
## DIAGNOSTIC ONLY.  Sourced by probe_adjoint_identity.R (simulation) and
## probe_s63_reach.R (the Section 6.3 configuration).  Modifies nothing shipped.
##
## Assumes scripts/R/lf_panel.R and scripts/R/orthogonal_theta.R are already
## sourced by the caller.
##
## INNER PRODUCTS
##   range   L2(Pi):  <a,b> = sum_{l,m} varpi_w(l) pi_t(m) (1/n) sum_i a b
##   sample  E_n   :  <x,y> = (1/n) sum_j x_j y_j
##   domain  L2(pi):  <q,d> = int q d pi dx  (trapezoid on the xeval grid)
## ---------------------------------------------------------------------------

KORD_KIT <- 8L
N_VERIFY <- 6L

`%||%` <- function(a, b) if (is.null(a)) b else a

trapz_w <- function(g) {
  n <- length(g)
  w <- numeric(n); d <- diff(g)
  w[seq_len(n - 1L)] <- w[seq_len(n - 1L)] + d / 2
  w[seq(2L, n)] <- w[seq(2L, n)] + d / 2
  w
}

ip_pi_range <- function(a, b, wlm) sum(colMeans(a * b) * wlm)
ip_en <- function(x, y) mean(x * y)

#' Assemble the operator pieces at a SUPPLIED residual.
#'
#' @param dat named list with x1, x2, Z (used only for the propensity and the
#'   Bierens family).
#' @param w numeric vector. The instrument.
#' @param xev numeric. Evaluation grid.
#' @param u numeric vector. The residual the operator is linearised at.
#' @param eps_rho,n_t,t_scale,bier_seed the shipped tuning constants.
#' @return named list of pieces, ready for forward_u / adjoint_u_* / summarise_map.
build_pieces_at <- function(dat, w, xev, u, eps_rho, n_t, t_scale, bier_seed) {
  n <- length(w)
  op <- make_operator(dat$x1, dat$x2, xev)
  fit_idx <- sample(seq_len(n), floor(n / 2))
  cells <- sort(unique(as.integer(w)))
  L <- length(cells)
  Rho <- fit_propensity_multi(w, dat$Z, fit_idx, seq_len(n), eps = eps_rho,
                              cells = cells)
  attr(Rho, "prop_diag") <- NULL
  rho <- if (L == 2L) as.vector(Rho) else Rho
  bier <- make_bierens(dat$Z, n_t = n_t, seed = bier_seed, scale = t_scale)
  hu <- bw_u(u)
  res <- operator_residual(u, w, rho = rho, bier = bier, adj_wtil = TRUE,
                           hu = hu, order = KORD_KIT)
  P <- list(op = op, u = u, hu = hu, rho = rho, bier = bier, res = res,
            L = L, n = n, w = w, wbar = mean(w), xev = xev,
            scal = if (L == 2L) mean(w) * (1 - mean(w)) else 1,
            nt = ncol(bier$Wt), n_grid = length(xev))
  P$Kap <- k_order(outer(u, u, "-") / hu, KORD_KIT) / hu
  P$wt_grid <- trapz_w(xev)
  ## x-side forward matrix: grid -> Delta h, including locate_dphi()'s centring.
  A1 <- stats::pnorm(outer(op$x1, xev, "-") / op$hx[1])
  A2 <- stats::pnorm(outer(op$x2, xev, "-") / op$hx[2])
  Pm <- sweep(A2 - A1, 2, P$wt_grid, "*")
  P$Pmat <- Pm - matrix(colMeans(Pm), n, length(xev), byrow = TRUE)
  ## x-side adjoint matrix, apply_adjoint()'s `dev` block in closed form.
  Dm <- op$Sev2 - op$Sev1
  P$Pstar <- (Dm - outer(rowSums(Dm), rep(1 / n, n))) / op$pi_ev
  P
}

# ---- the u-side maps -------------------------------------------------------

#' Forward: eq:Adef discretised.  n x ((L-1) n_t), columns (l,m), m fastest.
forward_u <- function(P, dh) {
  out <- matrix(0, P$n, (P$L - 1L) * P$nt)
  for (l in seq_len(P$L - 1L)) {
    out[, (l - 1L) * P$nt + seq_len(P$nt)] <-
      (P$Kap %*% (P$res$wtil[, l] * dh * P$bier$Wt)) / (P$n * P$scal)
  }
  out
}

#' EXACT adjoint of forward_u().  `Kell` is Kap %*% ell (batched by the caller).
adjoint_u_exact <- function(P, Kell) {
  g <- numeric(P$n)
  for (l in seq_len(P$L - 1L)) {
    Sl <- Kell[, (l - 1L) * P$nt + seq_len(P$nt), drop = FALSE] / P$n
    g <- g + P$res$pi_w[l] * P$res$wtil[, l] *
      rowSums(sweep(Sl * P$bier$Wt, 2, P$bier$pi_t, "*"))
  }
  g / P$scal
}

#' The SHIPPED adjoint expression, reconstructed from lf_panel.R:517-521.
adjoint_u_code <- function(P, ell, adj_wtil) {
  ctr <- numeric(P$n)
  for (l in seq_len(P$L - 1L)) {
    g <- as.vector(rowSums(sweep(
      ell[, (l - 1L) * P$nt + seq_len(P$nt), drop = FALSE] * P$bier$Wt,
      2, P$bier$pi_t, "*")))
    ctr <- ctr + P$res$pi_w[l] * (if (adj_wtil) P$res$wtil[, l] * g else g)
  }
  P$res$fu * ctr / (if (adj_wtil) P$scal else 1)
}

#' The DIAGONAL operator C whose EXACT adjoint the shipped comperr is:
#'   (C dh)_{i,(l,m)} = f(u_i) Wtil_il Wt_im dh_i / scal   (adj_wtil = TRUE)
#'   (C dh)_{i,(l,m)} = f(u_i)            Wt_im dh_i       (adj_wtil = FALSE)
#' A_u smooths in u where C does not; that substitution is the entire gap.
forward_c <- function(P, dh, adj_wtil) {
  out <- matrix(0, P$n, (P$L - 1L) * P$nt)
  for (l in seq_len(P$L - 1L)) {
    a <- if (adj_wtil) P$res$wtil[, l] / P$scal else 1
    out[, (l - 1L) * P$nt + seq_len(P$nt)] <- P$res$fu * a * dh * P$bier$Wt
  }
  out
}

# ---- x-side maps -----------------------------------------------------------

forward_x <- function(P, q) as.vector(P$Pmat %*% q)
adjoint_x <- function(P, g) as.vector(P$Pstar %*% g)
ip_pi_domain <- function(P, q, dq) sum(P$wt_grid * q * dq * P$op$pi_ev)

# ---- validation gates ------------------------------------------------------

gate_reconstruction <- function(P) {
  got <- adjoint_u_code(P, P$res$err, adj_wtil = TRUE)
  want <- P$res$comperr
  max(abs(got - want)) / max(abs(want))
}

gate_xside <- function(P) {
  rel <- numeric(N_VERIFY)
  for (b in seq_len(N_VERIFY)) {
    q <- rand_smooth(P$xev); g <- stats::rnorm(P$n)
    lhs <- ip_en(forward_x(P, q), g)
    rhs <- ip_pi_domain(P, q, adjoint_x(P, g))
    rel[b] <- abs(lhs - rhs) / max(abs(lhs), .Machine$double.eps)
  }
  g <- stats::rnorm(P$n)
  ship <- apply_adjoint(P$op, g)$dev
  c(transpose = max(rel),
    matches_shipped = max(abs(adjoint_x(P, g) - ship)) / max(abs(ship)))
}

gate_uside <- function(P, adj_wtil) {
  nc <- (P$L - 1L) * P$nt
  r1 <- numeric(N_VERIFY); r2 <- numeric(N_VERIFY)
  for (b in seq_len(N_VERIFY)) {
    dh <- stats::rnorm(P$n)
    ell <- matrix(stats::rnorm(P$n * nc), P$n, nc)
    lhs <- ip_pi_range(forward_u(P, dh), ell, P$res$pi_t)
    r1[b] <- abs(lhs - ip_en(dh, adjoint_u_exact(P, P$Kap %*% ell))) / abs(lhs)
    lhs2 <- ip_pi_range(forward_c(P, dh, adj_wtil), ell, P$res$pi_t)
    r2[b] <- abs(lhs2 - ip_en(dh, adjoint_u_code(P, ell, adj_wtil))) / abs(lhs2)
  }
  c(exact_is_adjoint_of_A = max(r1), code_is_adjoint_of_C = max(r2))
}

# ---- random probes ---------------------------------------------------------

rand_smooth <- function(g, n_basis = 6L) {
  s <- (g - min(g)) / diff(range(g))
  out <- numeric(length(g))
  for (k in seq_len(n_basis)) {
    out <- out + stats::rnorm(1) * sin(pi * k * s) / k +
      stats::rnorm(1) * cos(pi * k * s) / k
  }
  out
}

smooth_basis <- function(P) {
  s <- (P$u - min(P$u)) / diff(range(P$u))
  cbind(1, s, s^2, sin(pi * s), cos(pi * s), sin(2 * pi * s))
}

# ---- the cell measurement --------------------------------------------------

run_cell <- function(P, adj_wtil, smooth, n_pair = 300L) {
  nc <- (P$L - 1L) * P$nt
  B <- smooth_basis(P)
  KB <- P$Kap %*% B
  rel_code <- numeric(n_pair); rel_exact <- numeric(n_pair)
  cs_code <- numeric(n_pair); cs_exact <- numeric(n_pair)
  for (b in seq_len(n_pair)) {
    q <- rand_smooth(P$xev)
    dh <- forward_x(P, q)
    if (smooth) {
      cf <- matrix(stats::rnorm(ncol(B) * nc), ncol(B), nc)
      ell <- B %*% cf; Kell <- KB %*% cf
    } else {
      ell <- matrix(stats::rnorm(P$n * nc), P$n, nc); Kell <- P$Kap %*% ell
    }
    Adh <- forward_u(P, dh)
    lhs <- ip_pi_range(Adh, ell, P$res$pi_t)
    rhs_code <- ip_pi_domain(P, q, adjoint_x(P, adjoint_u_code(P, ell,
                                                               adj_wtil)))
    rhs_exact <- ip_pi_domain(P, q, adjoint_x(P, adjoint_u_exact(P, Kell)))
    den <- sqrt(ip_pi_range(Adh, Adh, P$res$pi_t) *
                  ip_pi_range(ell, ell, P$res$pi_t))
    rel_code[b] <- abs(lhs - rhs_code) / abs(lhs)
    rel_exact[b] <- abs(lhs - rhs_exact) / abs(lhs)
    cs_code[b] <- abs(lhs - rhs_code) / den
    cs_exact[b] <- abs(lhs - rhs_exact) / den
  }
  list(rel_code = stats::median(rel_code),
       rel_code_lo = stats::quantile(rel_code, 0.1, names = FALSE),
       rel_code_hi = stats::quantile(rel_code, 0.9, names = FALSE),
       rel_exact = stats::median(rel_exact),
       cs_code = stats::median(cs_code), cs_exact = stats::median(cs_exact))
}

# ---- the contracted map, in closed form ------------------------------------
#
#   N_true = A_u* A_u = (1/(n^2 scal^2)) (kappa kappa) o Omega o Psi   -- PSD
#   N_code = C*  A_u  = (1/(n   scal^2)) D_f (kappa    o Omega o Psi)
#
# Omega = Wtil diag(varpi) Wtil', Psi = Wt diag(pi_t) Wt', D_f = diag(fu).
# N_true is symmetric PSD at every sans-L by the Schur product theorem.  N_code
# is symmetric only if fu is constant, and PSD only if kappa o Omega o Psi is --
# which an order-8 kernel, whose kappa is indefinite, does not deliver.

normal_ops <- function(P, adj_wtil) {
  n <- P$n
  Omega <- P$res$wtil %*% (P$res$pi_w * t(P$res$wtil))
  Psi <- P$bier$Wt %*% (P$bier$pi_t * t(P$bier$Wt))
  base <- Omega * Psi
  N_true <- ((P$Kap %*% P$Kap) * base) / (n^2 * P$scal^2)
  if (adj_wtil) {
    N_code <- (P$res$fu * (P$Kap * base)) / (n * P$scal^2)
  } else {
    Om0 <- matrix(rowSums(sweep(P$res$wtil, 2, P$res$pi_w, "*")), n, n,
                  byrow = TRUE)
    N_code <- (P$res$fu * (P$Kap * Om0 * Psi)) / (n * P$scal)
  }
  list(N_true = N_true, N_code = N_code)
}

summarise_map <- function(P, adj_wtil) {
  no <- normal_ops(P, adj_wtil)
  M_true <- P$Pstar %*% no$N_true %*% P$Pmat
  M_code <- P$Pstar %*% no$N_code %*% P$Pmat
  drho <- P$wt_grid * P$op$pi_ev
  asym <- function(M) {
    S <- drho * M
    norm(S - t(S), "F") / norm(S + t(S), "F")
  }
  ev <- function(M) {
    S <- drho * M; S <- (S + t(S)) / 2
    e <- eigen(S, symmetric = TRUE, only.values = TRUE)$values
    c(neg_frac = mean(e < 0), neg_mass = sum(pmax(-e, 0)) / sum(abs(e)),
      lam_min = min(e), lam_max = max(e))
  }
  r0 <- operator_residual(P$u, P$w, rho = P$rho, bier = P$bier,
                          adj_wtil = adj_wtil, hu = P$hu, order = KORD_KIT)
  nrm <- operator_norm2(P$op, weight = r0$adjw)
  cste <- if (is.finite(nrm) && nrm > 0) 1 / nrm else 0.5
  ng <- P$n_grid
  eg <- eigen(diag(ng) - cste * M_code)
  rad <- Mod(eg$values)
  vtop <- Re(eg$vectors[, which.max(rad)])
  phi_mode <- cumtrapz_centre(P$xev, vtop)
  ramp <- P$xev - mean(P$xev)
  sine <- sin(2 * pi * P$xev) / 2
  sine <- sine - mean(sine)
  cc <- function(a, b) sum(a * b) / sqrt(sum(a^2) * sum(b^2))
  eg_t <- eigen(diag(ng) - cste * M_true)
  list(asym_true = asym(M_true), asym_code = asym(M_code),
       ev_true = ev(M_true), ev_code = ev(M_code), cste = cste,
       rho_code = max(rad), rho_true = max(Mod(eg_t$values)),
       mode_ramp = abs(cc(phi_mode, ramp)), mode_sine = abs(cc(phi_mode, sine)),
       mode_monotone = mean(diff(phi_mode) > 0))
}

#' Cosine between the shipped step and the true gradient, at the actual residual.
step_alignment <- function(P, adj_wtil) {
  r <- operator_residual(P$u, P$w, rho = P$rho, bier = P$bier,
                         adj_wtil = adj_wtil, hu = P$hu, order = KORD_KIT)
  ell <- r$err
  if (is.null(dim(ell))) ell <- matrix(ell, P$n, 1L)
  s_code <- adjoint_x(P, adjoint_u_code(P, ell, adj_wtil))
  s_true <- adjoint_x(P, adjoint_u_exact(P, P$Kap %*% ell))
  drho <- P$wt_grid * P$op$pi_ev
  ipd <- function(a, b) sum(drho * a * b)
  ipd(s_code, s_true) / sqrt(ipd(s_code, s_code) * ipd(s_true, s_true))
}
