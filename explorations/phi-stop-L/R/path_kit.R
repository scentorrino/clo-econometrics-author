## ---------------------------------------------------------------------------
## path_kit.R -- shared DGPs and a PATH-RECORDING Landweber-Fridman solve.
##
## SOURCED, NOT RUN.  Sets no seed, writes no output.
##
## WHY A LOCAL COPY OF THE LOOP.  lf_solve() keeps only the BEST iterate; the
## question here is what the WHOLE path looks like, so phi_m has to be recorded
## at every m.  Adding a tracking argument to lf_panel.R would change that file's
## md5 and invalidate every fingerprinted cache in paper/tables/sim and the
## application's *_parts/ directories, for a diagnostic.  So the loop is copied
## here, line for line, and cross-checked against lf_solve() in
## probe_00_loop_fidelity.R: the same draw through both must give the same
## discrepancy path and the same selected iterate.
## ---------------------------------------------------------------------------

## ---- DGPs ------------------------------------------------------------------
##
## D-A is sim_multinomial_onestep.R's design, unchanged, so the path study and
## the theta study are about the same object.  Its four cells are near balanced.
##
## D-B is the STRESS design: cell shares deliberately set near Section 6's
## realised (0.700, 0.115, 0.066, 0.119), which is the shape L = 4 is actually
## used on, and a first stage half as strong.  A rule calibrated on D-A alone
## would be a rule calibrated on one design.

THETA_TRUE <- c(1.0, -0.5)
THETA_FULL <- c(0.0, THETA_TRUE)
PHI_TRUE   <- function(x) sin(2 * pi * x) / 2

DGP_SPEC <- list(
  A = list(gamma = 1.2, shift = c(0, 0.6, 0.9, 1.2),
           intercept = c(0, 0.20, 0.10, -0.10), sd_e = 0.5,
           label = "balanced cells, strong first stage"),
  B = list(gamma = 0.8, shift = c(0, 0.30, 0.45, 0.60),
           intercept = c(0, -1.75, -2.35, -1.75), sd_e = 0.5,
           label = "skewed cells (Section 6 shape), weak first stage")
)

#' One draw of the four-cell design and its binary coarsening.
#'
#' Delta U depends on (Delta Z, v1, v2, e) only and W on (Delta Z, own uniform),
#' so Delta U _||_ W | Delta Z holds EXACTLY.  E[Delta Z Delta U] = 0 because
#' E[z_j z_1 z_2] = 0 at independent standard normals.
#'
#' @param n integer sample size.
#' @param spec one element of DGP_SPEC.
#' @return list: y, x1, x2, Z (n x 3, intercept first), w4, w3, w2, du, P.
dgp_draw <- function(n, spec) {
  g  <- spec$gamma
  z  <- matrix(stats::rnorm(n * 2L), n, 2L)
  zx <- z[, 1] * z[, 2]
  eta <- cbind(spec$intercept[1],
               spec$intercept[2] + g * z[, 1],
               spec$intercept[3] + 0.5 * g * z[, 2],
               spec$intercept[4] + g * zx)
  P <- exp(eta) / rowSums(exp(eta))
  cum <- P
  for (k in seq(2L, ncol(P))) cum[, k] <- cum[, k - 1L] + P[, k]
  w4 <- pmin(rowSums(stats::runif(n) > cum), ncol(P) - 1L)             # 0..3
  xi <- stats::rnorm(n); v1 <- stats::rnorm(n); v2 <- stats::rnorm(n)
  x1 <- stats::pnorm((xi + v1) / 1.5)
  x2 <- stats::pnorm((xi + spec$shift[w4 + 1L] + v2) / 1.5)
  du <- g * zx + 0.6 * (v2 - v1) + spec$sd_e * stats::rnorm(n)
  list(y  = PHI_TRUE(x2) - PHI_TRUE(x1) + as.vector(z %*% THETA_TRUE) + du,
       x1 = x1, x2 = x2, Z = cbind(const = 1, z),
       w4 = w4,
       ## The three-cell coarsening merges the two smallest cells, so the L = 3
       ## arm is the SAME draw seen at one less cell rather than a new design.
       w3 = pmin(w4, 2L),
       w2 = as.numeric(w4 > 0L), du = du, P = P)
}

#' Pick the instrument of a given cardinality off one draw.
inst_of <- function(d, L) switch(as.character(L), "2" = d$w2, "3" = d$w3,
                                "4" = d$w4, stop("L must be 2, 3 or 4"))

## ---- the path-recording solve ----------------------------------------------

#' Landweber-Fridman with the whole path kept.
#'
#' The loop is lf_solve()'s, with the stopping tests removed (it always runs to
#' `imax`) and phi_m, theta_m recorded at every m.  `err[m]` and `noise[m]` are
#' the discrepancy and delta-hat_n AT the iterate stored in `PHI[m, ]`, which is
#' the pairing lf_solve()'s discrepancy test uses.
#'
#' @param op operator from make_operator(); `init` from init_control() etc.
#' @param imax integer. Iterations to run.
#' @return list: err, noise (length imax), PHI (imax x |xeval|), TH (imax x p),
#'   cste.
lf_path <- function(y, x1, x2, Z, w, op, init, rho = NULL, bier = NULL,
                    adj_wtil = TRUE, cste = NULL, imax = 60L) {
  d1 <- init$d1; d2 <- init$d2; dev <- init$dev
  theta <- init$theta
  phi1 <- integrate_centre(d1, op$M1, op$ord1)
  phi2 <- integrate_centre(d2, op$M2, op$ord2)
  dphi <- locate_dphi(phi2 - phi1, y, Z, theta)

  if (is.null(cste)) {
    u0 <- as.vector(y - Z %*% theta) - dphi
    r0 <- operator_residual(u0, w, rho = rho, bier = bier, adj_wtil = adj_wtil)
    nrm <- operator_norm2(op, weight = r0$adjw)
    cste <- if (is.finite(nrm) && nrm > 0) 1 / nrm else 0.5
  }

  errn <- rep(NA_real_, imax); noisen <- rep(NA_real_, imax)         # INV-17
  PHI <- matrix(NA_real_, imax, length(op$xeval))
  TH  <- matrix(NA_real_, imax, ncol(Z))

  for (it in seq_len(imax)) {
    u <- as.vector(y - Z %*% theta) - dphi
    res <- operator_residual(u, w, rho = rho, bier = bier, adj_wtil = adj_wtil)
    errn[it]   <- residual_norm(res)
    noisen[it] <- res$noise
    PHI[it, ]  <- cumtrapz_centre(op$xeval, dev)
    TH[it, ]   <- theta

    step <- apply_adjoint(op, res$comperr)
    d1  <- d1  - cste * step$d1
    d2  <- d2  - cste * step$d2
    dev <- dev - cste * step$dev

    phi1 <- integrate_centre(d1, op$M1, op$ord1)
    phi2 <- integrate_centre(d2, op$M2, op$ord2)
    dphi <- locate_dphi(phi2 - phi1, y, Z, theta)

    theta <- stats::lm.fit(Z, as.vector(y - dphi))$coefficients
    theta[!is.finite(theta)] <- 0
    dphi <- locate_dphi(dphi, y, Z, theta)
  }
  list(err = errn, noise = noisen, PHI = PHI, TH = TH, cste = cste)
}

#' One full-sample LF path on a draw at cardinality L.
#'
#' Single solve, no cross-fitting: the propensity is fitted on a random half and
#' evaluated on the whole sample, which is the operator stage's own split read at
#' K = 1.  The cross-fitted pipeline is exercised separately.
#'
#' @return list with the path plus the truth on the evaluation grid.
path_once <- function(d, L, eps_rho = 0.03, imax = 60L, n_t = 16L,
                      t_scale = 0.25, n_grid = 60L) {
  w <- inst_of(d, L)
  n <- length(w)
  xev <- seq(stats::quantile(c(d$x1, d$x2), 0.05),
             stats::quantile(c(d$x1, d$x2), 0.95), length.out = n_grid)
  op <- make_operator(d$x1, d$x2, xev)
  cells <- sort(unique(as.integer(w)))
  fit_idx <- sample(seq_len(n), floor(n / 2))
  Rho <- fit_propensity_multi(w, d$Z, fit_idx, seq_len(n), eps = eps_rho,
                              cells = cells)
  attr(Rho, "prop_diag") <- NULL
  rho <- if (length(cells) == 2L) as.vector(Rho) else Rho
  bier <- make_bierens(d$Z, n_t = n_t, seed = 20260805L, scale = t_scale)
  init <- init_control(d$y, d$x1, d$x2, d$Z, w, op)
  pth <- lf_path(d$y, d$x1, d$x2, d$Z, w, op, init, rho = rho, bier = bier,
                 adj_wtil = TRUE, cste = NULL, imax = imax)
  phi0 <- PHI_TRUE(xev); phi0 <- phi0 - mean(phi0)
  c(pth, list(xeval = xev, phi0 = phi0, L = length(cells)))
}

#' Path summaries: projection on the truth, ISE, and the DP ratio.
#'
#' `b` is the coefficient of phi0 in the projection of phi-hat_m on it: b = 1 is
#' exact recovery of the shape, b = 0 no information, b < 0 anti-correlation.
#' ISE is the plain squared error on the grid, both series centred.
path_stats <- function(p) {
  phi0 <- p$phi0
  s0 <- sum(phi0^2)
  b   <- as.vector(p$PHI %*% phi0) / s0
  ise <- rowMeans(sweep(p$PHI, 2L, phi0, "-")^2)
  list(b = b, ise = ise, ratio = p$err / p$noise, err = p$err,
       noise = p$noise, cste = p$cste, L = p$L,
       nrm = sqrt(rowMeans(p$PHI^2)) / sqrt(mean(phi0^2)))
}
