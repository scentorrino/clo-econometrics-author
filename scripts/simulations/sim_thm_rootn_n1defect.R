# ============================================================================
# sim_thm_rootn_n1defect.R
#
# THE N1 DEFECT OF THE SHIPPED ZERO-ANCHORED L_star, AT sans-L IN {2, 4}.
#
# ---------------------------------------------------------------------------
# WHY THIS EXISTS: TWO RECORDS THAT CANNOT BOTH BE RIGHT
#
# N1 is  E[ L_star(dU, dZ) | dZ ] = 0  as a p x (sans-L - 1) matrix. prp:orthog
# (iii) makes it necessary AND sufficient for exact orthogonality in the
# propensity direction, and (T-2) assumes it. Under the ZERO anchor of design
# decision D2, L_star(u, z) = int_0^u ell_star(v, z) dv, and whether N1 holds is
# a FACT ABOUT THE DESIGN, not a modelling choice. Two shipped records disagree:
#
#   sim_thm_rootn_summary.md:202  -- lists, among the things the exercise does
#     NOT do, "detect anchor-sensitivity of V (the N1 anchor COINCIDES with the
#     zero anchor here)". That asserts the defect is ZERO.
#   sim_thm_rootn_cardinality_summary.md:110 -- "This design uses the ZERO
#     anchor ... which satisfies N1 at NEITHER cardinality." That asserts the
#     defect is NON-ZERO at sans-L = 2 and at sans-L = 4.
#
# A third record sits between them and is quoted by both: the Jacobian arm's
# Panel D reports ||b-hat|| / ||L_star|| = 0.0123 (DGP-A), 0.0116 (DGP-B) in rms
# -- small but non-zero. That number is a BINNED estimate (200 quantile cells of
# the propensity index on n = 1.5e6, i.e. 7,500 observations per cell), so its
# own noise floor is 1/sqrt(7500) = 0.0115. It therefore cannot distinguish a
# defect of 0.012 from a defect of 0. This script settles the question by NOT
# estimating it.
#
# ---------------------------------------------------------------------------
# WHY IT IS COMPUTED, NOT ESTIMATED
#
# Two structural facts about the design make the defect a closed-form quantity.
#
# (1) dU IS EXACTLY INDEPENDENT OF (dZ, W). In dgp_draw(),
#         du <- rho_uv * (v2 - v1) + sc * sigma_e * rnorm(n)
#     and v1, v2, sc and that rnorm() are drawn from streams that touch neither
#     zc nor the cell draw. So the conditional law of dU given dZ is its
#     marginal, and it is symmetric about zero.
#
# (2) L_star SEPARATES IN (u, z). ell_block_eval() builds
#         L_star_{ml}(u, z) = sum_{r, q} coef[m, (l, r, q)] A_q(u) eta_r(z),
#     A_q the zero-anchored antiderivative of the u-basis (es$anti_fun) and
#     eta = (1, varrho_1, ..., varrho_{L-1}) a function of z alone.
#
# Together:  b_{ml}(z) := E[L_star_{ml} | dZ = z] = sum_r beta_{ml,r} eta_r(z),
#            beta_{ml,r} = sum_q coef[m, (l, r, q)] Abar_q,  Abar_q = E[A_q(dU)],
# so  ||b_{ml}||^2_{L2} = beta' M beta  with  M = E[eta eta'].  Abar and M are
# one-dimensional and three-dimensional quadratures of smooth bounded
# integrands; there is NO sampling error anywhere in Panels A-C. The evaluation
# uses the SHIPPED spline antiderivatives and the SHIPPED clamp to es$u_range,
# so what is measured is the defect of the shipped L_star and not of an
# idealised one.
#
# Panel D confirms Panels A-B by an independent SAMPLED route (OLS of L_star on
# eta at n = 2e6, which is consistent for beta because L_star - b has zero
# conditional mean) and reproduces the Jacobian arm's binned statistic against
# its own noise floor.
#
# ---------------------------------------------------------------------------
# DESIGN DECISIONS
#
# D-N1a. The reported headline is the ENTRYWISE maximum over the p (sans-L - 1)
#   pairs, max_{j,l} || b_{jl} ||_{L2}, because N1 is a matrix identity and a
#   Frobenius aggregate can hide a single live entry. The Frobenius aggregate is
#   reported beside it, and so is || L_star || in both conventions, so that
#   every ratio in the table is like for like.
#
# D-N1b. The CONTRACTED counterpart is reported for the same reason the S2
#   consumed/priced diagnostic reported one: psi and J-hat never see b entrywise,
#   they see it contracted against the propensity error. Three contractions:
#     Gamma_op    sup over unit-L2 r of || E[b r] ||, = sqrt(lambda_max(E[b b'])),
#                 the sharp constant in || E T_2 || <= Gamma_op || r ||;
#     Gamma_real  the rms of || E[b r] || / || r || over the ARM'S OWN direction
#                 law (draw_rhat: one affine-in-z direction per non-base cell),
#                 with and without the eq:trunset projection, at the arm's own
#                 tau_n = c_r r_n;
#     Lambda      sqrt(E || L_star r ||^2) / || r ||, the CENTRED-piece constant,
#                 which is what Gamma has to be read against.
#
# D-N1c. DGP-B is included although the contradiction is about DGP-A, because
#   line 178's companion figure (0.0116) is quoted for DGP-B and the same
#   binning floor applies to it.
#
# D-N1d. This script SOURCES the shipped DGP and nuisance files and modifies
#   nothing in them. It adds no object to their namespaces. The sans-L = 2
#   bit-identity certificate (sim_thm_rootn_l2identity.R) is therefore expected
#   to pass unchanged, and is run as the gate.
#
# Outputs
#   paper/tables/sim/sim_thm_rootn_n1defect.tex   (bare tabular, INV-13)
#   quality_reports/sim/sim_thm_rootn_n1defect.rds
#
#   Rscript scripts/simulations/sim_thm_rootn_n1defect.R      (~2 min, 1 core)
# ============================================================================

library(here)                                                    # INV-15
library(data.table)

source(here::here("scripts", "simulations", "sim_thm_rootn_dgp.R"))
source(here::here("scripts", "simulations", "sim_thm_rootn_nuisance.R"))

set.seed(20260815L)                                              # INV-14

# The two cells of the ablation arm whose T_2 exponent motivated this
# measurement, so that the truncation and the direction law are priced at the
# sample sizes they were realised at rather than at a round number.
N_ARM   <- c(1000L, 8000L)
C_R     <- 1                       # the ablsplit rho-arm's c_r
GH_M    <- 40L                     # Gauss-Hermite nodes per z coordinate
GH_M_LO <- 28L                     # stability comparison
N_DIR   <- 400L                    # direction draws, untruncated contraction
N_SAMP  <- 2e6L                    # sample size of the Panel-D confirmation
N_BIN   <- 1.5e6L                  # the Jacobian arm's own n, for its floor
N_CELL  <- 200L                    # the Jacobian arm's own cell count

# The truncated contraction is the one expensive quantity here, and the cost is
# named rather than hidden: project_trunset() sorts row-wise at sans-L >= 3 and
# runs 1.8 s per call on a 13,824-node rule, so a 400-direction rms at the fine
# rule would be 90 minutes for a refinement of a second-order number. It is run
# on a coarser rule and fewer directions, and its direction-MC SE is reported in
# the .rds beside it. The UNTRUNCATED contraction needs no projection and is
# scale-invariant in tau -- r = g/||g|| tau makes ||E[b r]||/||r|| free of tau --
# so it is computed once per design at the fine rule and is exact.
GH_M_TR  <- 24L
N_DIR_TR <- 60L

# Panel E. c_delta is the ablation arm's own; B is set so the MC SE of the mean
# of per-replication norms is ~0.007, against an h-on/h-off contrast the
# population arithmetic puts at ~0.10 -- a 15 SE bar, not a 2 SE one.
C_DELTA <- 0.25
B_PROBE <- 1500L

# ---- Exact quadrature machinery --------------------------------------------

#' Abar_q = E[A_q(dU)], with the SHIPPED clamp to es$u_range.
#'
#' dU is a (possibly two-point) Gaussian scale mixture with the variances
#' declared at the head of the population block of the DGP file, so the integral
#' is a mixture of one-dimensional integrals of a smooth bounded spline against
#' a normal density. rel.tol is set well below anything the answer is read at.
abar_vec <- function(es, spec) {
  s_pts <- if (spec$p_mix > 0) c(1, spec$s_mix) else 1
  s_prb <- if (spec$p_mix > 0) c(1 - spec$p_mix, spec$p_mix) else 1
  sdv   <- sqrt(2 * spec$rho_uv^2 * spec$sigma_v^2 + s_pts^2 * spec$sigma_e^2)
  vapply(seq_len(es$Q), function(q) {
    f <- es$anti_fun[[q]]
    sum(vapply(seq_along(s_pts), function(k)
      stats::integrate(function(u)
        f(pmin(pmax(u, es$u_range[1]), es$u_range[2])) * dnorm(u, sd = sdv[k]),
        -Inf, Inf, rel.tol = 1e-12, subdivisions = 2000L)$value * s_prb[k],
      numeric(1)))
  }, numeric(1))
}

#' N_{q q'} = E[A_q(dU) A_{q'}(dU)], same conventions.
nmat_u <- function(es, spec) {
  s_pts <- if (spec$p_mix > 0) c(1, spec$s_mix) else 1
  s_prb <- if (spec$p_mix > 0) c(1 - spec$p_mix, spec$p_mix) else 1
  sdv   <- sqrt(2 * spec$rho_uv^2 * spec$sigma_v^2 + s_pts^2 * spec$sigma_e^2)
  N <- matrix(0, es$Q, es$Q)
  for (q in seq_len(es$Q)) for (qq in q:es$Q) {
    f1 <- es$anti_fun[[q]]; f2 <- es$anti_fun[[qq]]
    v <- sum(vapply(seq_along(s_pts), function(k)
      stats::integrate(function(u) {
        uc <- pmin(pmax(u, es$u_range[1]), es$u_range[2])
        f1(uc) * f2(uc) * dnorm(u, sd = sdv[k])
      }, -Inf, Inf, rel.tol = 1e-11, subdivisions = 2000L)$value * s_prb[k],
      numeric(1)))
    N[q, qq] <- v; N[qq, q] <- v
  }
  N
}

#' Gauss-Hermite nodes and weights by Golub-Welsch, for int f(x) exp(-x^2) dx.
#' Implemented here rather than taken from a package so the script has no
#' dependency the five shipped arms do not already have.
gauss_hermite <- function(m) {
  k <- seq_len(m - 1L)
  J <- matrix(0, m, m)
  J[cbind(k, k + 1L)] <- sqrt(k / 2)
  J[cbind(k + 1L, k)] <- sqrt(k / 2)
  e <- eigen(J, symmetric = TRUE)
  o <- order(e$values)
  list(x = e$values[o], w = sqrt(pi) * (e$vectors[1L, o])^2)
}

#' Tensor Gauss-Hermite rule for dZ's three non-degenerate coordinates.
#' dgp_draw() builds zc as N(z_mean, sigma_z) exactly, so this integrates any
#' bounded smooth function of z against its true law.
z_rule <- function(spec, m) {
  q <- gauss_hermite(m)
  g <- as.matrix(expand.grid(q$x, q$x, q$x))
  list(z = sweep(sqrt(2) * g %*% chol(spec$sigma_z), 2, spec$z_mean, "+"),
       w = as.vector(outer(outer(q$w, q$w), q$w)) / pi^(3 / 2))
}

#' Pull the (n_modes x Q) coefficient slab of entry (m, l) out of es$coef.
#' The column layout is fixed by solve_ell_star(): ((l-1) n_r + (r-1)) Q + q.
coef_slab <- function(es, mm, l) {
  nr <- es$n_modes; Q <- es$Q
  out <- matrix(0, nr, Q)
  for (r in seq_len(nr)) {
    b0 <- ((l - 1L) * nr + (r - 1L)) * Q
    out[r, ] <- es$coef[mm, (b0 + 1L):(b0 + Q)]
  }
  out
}

# ---- Panels A-C for one design ---------------------------------------------

n1_defect <- function(spec, m = GH_M) {
  es  <- solve_ell_star(spec)
  Lc  <- spec_L(spec); nL1 <- Lc - 1L; p <- spec$p
  Ab  <- abar_vec(es, spec)
  Nu  <- nmat_u(es, spec)
  G   <- z_rule(spec, m)
  eta <- cbind(1, as.matrix(varrho_fun(G$z, spec)))
  M   <- t(eta) %*% (eta * G$w)
  stopifnot(all(is.finite(M)), all(is.finite(Ab)), all(is.finite(Nu)))

  b_l2 <- L_l2 <- matrix(0, p, nL1)
  Beta <- array(0, c(p, nL1, es$n_modes))
  for (mm in seq_len(p)) for (l in seq_len(nL1)) {
    C  <- coef_slab(es, mm, l)
    be <- as.vector(C %*% Ab)
    Beta[mm, l, ] <- be
    b_l2[mm, l] <- sqrt(max(as.numeric(t(be) %*% M %*% be), 0))
    L_l2[mm, l] <- sqrt(max(sum(M * (C %*% Nu %*% t(C))), 0))
  }

  # E[b b'], p x p: the object whose top eigenvalue is the sharp contraction
  # constant Gamma_op of design decision D-N1b.
  Ebb <- matrix(0, p, p)
  for (l in seq_len(nL1))
    Ebb <- Ebb + Beta[, l, , drop = FALSE][, 1L, ] %*% M %*%
                 t(Beta[, l, , drop = FALSE][, 1L, ])
  gamma_op <- sqrt(max(eigen(Ebb, symmetric = TRUE, only.values = TRUE)$values, 0))

  # u-mode energy split. A_q is ODD in u exactly when q is odd, so a coefficient
  # block supported on odd q gives an L_star odd in u and, dU being symmetric,
  # N1 holds as an IDENTITY rather than as a small number.
  q_energy <- vapply(seq_len(es$Q), function(q) {
    sel <- which(((seq_len(ncol(es$coef)) - 1L) %% es$Q) + 1L == q)
    sqrt(sum(es$coef[, sel]^2))
  }, numeric(1))

  list(spec = spec$name, L = Lc, es = es, M = M, Nu = Nu, Ab = Ab, Beta = Beta,
       b_l2 = b_l2, L_l2 = L_l2, Ebb = Ebb, gamma_op = gamma_op,
       b_max = max(b_l2), L_max = max(L_l2),
       b_fro = sqrt(sum(b_l2^2)), L_fro = sqrt(sum(L_l2^2)),
       q_energy = q_energy,
       odd_share = sum(q_energy[seq(1L, es$Q, by = 2L)]^2) / sum(q_energy^2),
       bal_resid = max(es$rel_resid))
}

# ---- Panel B: the contraction against the arm's own direction law -----------
#
# draw_rhat() draws one affine-in-z direction per non-base cell, scales the whole
# field to the A4(iii) target in the L2 norm, and projects onto eq:trunset. The
# population counterpart replaces the sample normalisation by the exact one and
# evaluates on the quadrature grid, so the only Monte Carlo left is over the
# DIRECTION, which is what the rms is taken over.

contraction_law <- function(fit, spec, tau, n_dir, m, trunc) {
  es <- fit$es; Lc <- fit$L; nL1 <- Lc - 1L; p <- spec$p
  G  <- z_rule(spec, m)
  eta <- cbind(1, as.matrix(varrho_fun(G$z, spec)))
  rr  <- as.matrix(varrho_fun(G$z, spec))
  ng  <- nrow(G$z)

  # b(z) on the grid: ng x p x (Lc-1).
  bz <- array(0, c(ng, p, nL1))
  for (mm in seq_len(p)) for (l in seq_len(nL1))
    bz[, mm, l] <- as.vector(eta %*% fit$Beta[mm, l, ])

  # Xi(z)_{l l'} = sum_m E_u[ L_{ml}(u,z) L_{ml'}(u,z) ], the kernel of the
  # centred-piece constant Lambda.
  ctil <- array(0, c(ng, p, nL1, es$Q))
  for (mm in seq_len(p)) for (l in seq_len(nL1))
    ctil[, mm, l, ] <- eta %*% coef_slab(es, mm, l)
  Xi <- array(0, c(ng, nL1, nL1))
  for (l in seq_len(nL1)) for (l2 in l:nL1) {
    v <- numeric(ng)
    for (mm in seq_len(p))
      v <- v + rowSums((ctil[, mm, l, , drop = FALSE][, 1L, 1L, ] %*% fit$Nu) *
                        ctil[, mm, l2, , drop = FALSE][, 1L, 1L, ])
    Xi[, l, l2] <- v; Xi[, l2, l] <- v
  }

  gm <- lam <- rnm <- numeric(n_dir)                             # INV-17
  for (b in seq_len(n_dir)) {
    g <- matrix(0, ng, nL1)
    for (l in seq_len(nL1)) {
      cb <- rnorm(4)
      g[, l] <- cb[1L] + G$z %*% cb[2:4]
    }
    g <- g / sqrt(sum(G$w * rowSums(g^2))) * tau
    rv <- if (trunc) as.matrix(project_trunset(rr + g, spec$eps_varrho)) - rr else g
    mu <- numeric(p)
    for (l in seq_len(nL1)) mu <- mu + colSums(G$w * bz[, , l] * rv[, l])
    q2 <- numeric(ng)
    for (l in seq_len(nL1)) for (l2 in seq_len(nL1))
      q2 <- q2 + Xi[, l, l2] * rv[, l] * rv[, l2]
    rnm[b] <- sqrt(sum(G$w * rowSums(rv^2)))
    gm[b]  <- sqrt(sum(mu^2)) / rnm[b]
    lam[b] <- sqrt(sum(G$w * q2)) / rnm[b]
  }
  list(gamma = sqrt(mean(gm^2)),
       gamma_se = sd(gm^2) / sqrt(n_dir) / (2 * sqrt(mean(gm^2))),
       lambda = sqrt(mean(lam^2)), r_realised = mean(rnm),
       tau = tau, n_dir = n_dir, m = m, trunc = trunc)
}

# ---- Panel D: independent sampled confirmation ------------------------------

sampled_check <- function(fit, spec, n = N_SAMP) {
  es <- fit$es; Lc <- fit$L; nL1 <- Lc - 1L; p <- spec$p
  d  <- dgp_draw(n, spec)
  Ls <- L_star_eval(es, d$du, d$zc, spec)
  Ls <- if (length(dim(Ls)) == 2L) array(Ls, c(dim(Ls), 1L)) else Ls
  eta <- cbind(1, as.matrix(varrho_fun(d$zc, spec)))
  XtX <- crossprod(eta) / n
  b_l2 <- b_se <- matrix(0, p, nL1)
  for (mm in seq_len(p)) for (l in seq_len(nL1)) {
    y  <- Ls[, mm, l]
    be <- solve(XtX, crossprod(eta, y) / n)
    rs <- y - as.vector(eta %*% be)
    Vb <- solve(XtX, crossprod(eta * rs) / n) %*% solve(XtX) / n
    nb <- sqrt(max(as.numeric(t(be) %*% fit$M %*% be), 0))
    gr <- as.vector(fit$M %*% be) / max(nb, 1e-300)
    b_l2[mm, l] <- nb
    b_se[mm, l] <- sqrt(max(as.numeric(t(gr) %*% Vb %*% gr), 0))
  }
  list(b_l2 = b_l2, b_se = b_se, n = n)
}

# ---- Panel E: what the shipped T_2 statistic actually measures ---------------
#
# WHY THIS PANEL EXISTS. If N1 holds at sans-L = 2 -- and Panel A says it does,
# to 3.3e-6 relative -- then the ablation arm's T_2 exponent of -0.108 against a
# reference of -alpha = -0.320 is NOT explained by the anchor, and the record
# that reads it as "leakage" needs a different mechanism. One candidate is
# visible in the shipped code and is sans-L-free:
#
#   sim_thm_rootn_ablsplit.R:272 forms  du = dY - dphi-hat - dZ' theta_dagger,
#   which is  dU - dh  with  dh = h(X_2) - h(X_1),  and line 289 evaluates
#   L_star AT THAT RESIDUAL. So the coded T_2 is
#       L_star(dU - dh, z) (varrho-hat - varrho),
#   not the L_star(dU, z)(varrho-hat - varrho) for which the two reference
#   exponents -alpha and 1/2 - alpha were derived. The h-carrying part is the
#   sqrt(n) ||h|| r_n cross-product the theorem prices SEPARATELY, and it is
#   inside the diagnostic rather than beside it.
#
# The probe switches h off and leaves everything else alone. It is NOT a re-run
# of the ablation: no preliminary, no one-step, no J-hat, no variance -- only
# the T_2 accumulation of ablsplit.R:286-290, at the same c_delta, c_r, fold
# rule and targets. That is what makes it a few minutes instead of hours.
#
# It is a SAMPLED panel and says so: Panels A-C carry no sampling error, this one
# carries an MC SE, reported with every number.

t2_probe <- function(spec, es, n, B, c_delta, c_r, h_on) {
  p <- spec$p; Lc <- spec_L(spec)
  tgt_h <- c_delta * rate_delta_n(n)
  tgt_r <- c_r * rate_rn(n)
  out <- numeric(B); rl2 <- numeric(B)                            # INV-17
  fold <- rep_len(1:2, n)
  for (b in seq_len(B)) {
    d <- dgp_draw(n, spec)
    s_T2 <- numeric(p); racc <- numeric(2)
    for (k in 1:2) {
      idx  <- which(fold == k)
      hh   <- draw_h(tgt_h, mode = "smooth", bias_frac = 0)
      zc_k <- d$zc[idx, , drop = FALSE]
      rr_k <- if (Lc == 2L) d$varrho[idx] else d$varrho[idx, , drop = FALSE]
      rh   <- draw_rhat(tgt_r, zc_k, spec)
      drh  <- if (Lc == 2L) as.vector(rh) - rr_k else
                as.matrix(rh) - as.matrix(rr_k)
      # dU - dh, which is what ablsplit.R:272 forms at theta_dagger. Written as
      # a subtraction from d$du rather than rebuilt from dY: identical in exact
      # arithmetic, and it keeps the probe's h-off arm exactly h-free.
      du <- d$du[idx]
      if (h_on) du <- du - (eval_h(hh, d$x2[idx]) - eval_h(hh, d$x1[idx]))
      Lst  <- L_star_eval(es, du, zc_k, spec)
      s_T2 <- s_T2 - colSums(contract_w(Lst, drh))
      racc[k] <- sqrt(mean(row_sqnorm(as.matrix(rh) - as.matrix(rr_k))))
    }
    out[b] <- sqrt(sum((s_T2 / n)^2)) * sqrt(n)
    rl2[b] <- mean(racc)
  }
  list(T2 = mean(out), T2_se = sd(out) / sqrt(B), r_realised = mean(rl2),
       tau = tgt_r, h_target = tgt_h, n = n, B = B, h_on = h_on, L = Lc)
}

#' Reproduce the Jacobian arm's binned b-hat statistic AND its own noise floor.
#' The floor is what a binned conditional mean returns when the truth is zero:
#' the within-cell average of n/N_CELL draws of a variable with the dispersion of
#' L_star. Reported so the 0.0123 in the round-3 summary can be read against it.
binned_floor <- function(fit, spec, n = N_BIN, cells = N_CELL) {
  es <- fit$es
  d  <- dgp_draw(n, spec)
  L0 <- L_star_eval(es, d$du, d$zc, spec)
  L0 <- if (length(dim(L0)) == 2L) L0 else matrix(L0, n)   # the arm is binary
  idx  <- as.matrix(varrho_fun(d$zc, spec))[, 1L]
  brk  <- stats::quantile(idx, seq(0, 1, length.out = cells + 1L))
  cell <- cut(idx, unique(brk), include.lowest = TRUE, labels = FALSE)
  bhat <- apply(L0, 2, function(cc) stats::ave(cc, cell, FUN = mean))
  list(b_rms = sqrt(mean(bhat^2)) / sqrt(mean(L0^2)),
       floor = 1 / sqrt(n / cells), per_cell = n / cells)
}

# ---- Run --------------------------------------------------------------------

DESIGNS <- list(list(nm = "A", L = 2L), list(nm = "A", L = 4L),
                list(nm = "B", L = 2L), list(nm = "B", L = 4L))

FIT <- lapply(DESIGNS, function(g) n1_defect(dgp_spec(g$nm, g$L)))
names(FIT) <- vapply(DESIGNS, function(g) sprintf("%s-L%d", g$nm, g$L), character(1))

# Quadrature stability: the same object at a coarser rule. Reported, not assumed.
FIT_LO <- lapply(DESIGNS, function(g) n1_defect(dgp_spec(g$nm, g$L), m = GH_M_LO))
quad_shift <- vapply(seq_along(FIT), function(i)
  abs(FIT[[i]]$b_max - FIT_LO[[i]]$b_max), numeric(1))

# Untruncated: scale-free, fine rule, once per design. tau is passed at the
# smaller of the two arm cells only so that r_realised in the .rds is on a scale
# a reader can compare with r_l2 in the ablation output; gamma and lambda are
# invariant to it, which the stopifnot() below checks rather than asserts.
CONTR <- lapply(seq_along(DESIGNS), function(i) {
  spec <- dgp_spec(DESIGNS[[i]]$nm, DESIGNS[[i]]$L)
  contraction_law(FIT[[i]], spec, tau = C_R * rate_rn(N_ARM[1L]),
                  n_dir = N_DIR, m = GH_M, trunc = FALSE)
})
names(CONTR) <- names(FIT)

# Truncated: coarser rule, fewer directions, at each arm cell, because the
# eq:trunset projection is what makes it depend on n at all.
CONTR_TR <- lapply(seq_along(DESIGNS), function(i) {
  spec <- dgp_spec(DESIGNS[[i]]$nm, DESIGNS[[i]]$L)
  lapply(N_ARM, function(nn)
    contraction_law(FIT[[i]], spec, tau = C_R * rate_rn(nn),
                    n_dir = N_DIR_TR, m = GH_M_TR, trunc = TRUE))
})
names(CONTR_TR) <- names(FIT)

SAMP <- lapply(seq_along(DESIGNS), function(i)
  sampled_check(FIT[[i]], dgp_spec(DESIGNS[[i]]$nm, DESIGNS[[i]]$L)))
names(SAMP) <- names(FIT)

BINF <- lapply(which(vapply(DESIGNS, function(g) g$L, integer(1)) == 2L), function(i)
  binned_floor(FIT[[i]], dgp_spec(DESIGNS[[i]]$nm, 2L)))
names(BINF) <- names(FIT)[vapply(DESIGNS, function(g) g$L, integer(1)) == 2L]

# Panel E, DGP-A only: the contradiction and the ablation arm are both about it.
PROBE <- list()                                                  # INV-17
PROBE_GRID <- expand.grid(L = c(2L, 4L), n = N_ARM, h_on = c(TRUE, FALSE),
                          KEEP.OUT.ATTRS = FALSE)
for (i in seq_len(nrow(PROBE_GRID))) {
  g <- PROBE_GRID[i, ]
  sp <- dgp_spec("A", g$L)
  PROBE[[i]] <- t2_probe(sp, FIT[[sprintf("A-L%d", g$L)]]$es, n = g$n,
                         B = B_PROBE, c_delta = C_DELTA, c_r = C_R,
                         h_on = g$h_on)
}
PROBE_DT <- rbindlist(lapply(PROBE, function(o)
  data.table(L = o$L, n = o$n, h_on = o$h_on, T2 = o$T2, T2_se = o$T2_se,
             r_realised = o$r_realised, tau = o$tau)))
# The implied exponent over the 1,000 -> 8,000 leg, arm by arm.
PROBE_BETA <- PROBE_DT[, .(beta = log(T2[n == 8000L] / T2[n == 1000L]) / log(8),
                           T2_lo = T2[n == 1000L], T2_hi = T2[n == 8000L]),
                       by = .(L, h_on)]

# Blocking checks, ABOVE the writes: a violated invariant must not ship a table.
# Same directions, two targets: with_fixed_seed() reverts the stream, so the
# main Monte Carlo is untouched and the two calls differ ONLY in tau.
chk  <- with_fixed_seed(4242L, contraction_law(FIT[[1L]], dgp_spec("A", 2L),
                        tau = C_R * rate_rn(N_ARM[2L]), n_dir = 25L,
                        m = GH_M, trunc = FALSE))
chk0 <- with_fixed_seed(4242L, contraction_law(FIT[[1L]], dgp_spec("A", 2L),
                        tau = C_R * rate_rn(N_ARM[1L]), n_dir = 25L,
                        m = GH_M, trunc = FALSE))

stopifnot(
  # dU is symmetric, so the antiderivative of the CONSTANT u-mode integrates to
  # E[dU] = 0. Anything else means the u-quadrature is wrong.
  abs(FIT[["A-L2"]]$Ab[1L]) < 1e-12,
  # the quadrature rule has converged
  all(quad_shift < 1e-9),
  # the untruncated contraction really is free of tau (same RNG stream length,
  # two different targets), so reporting it once per design is not a shortcut
  abs(chk$gamma / chk0$gamma - 1) < 1e-10,
  abs(chk$lambda / chk0$lambda - 1) < 1e-10,
  # the sampled route agrees with the exact one wherever the exact one is
  # resolvable above the sampling noise
  abs(SAMP[["A-L4"]]$b_l2[1L, 2L] - FIT[["A-L4"]]$b_l2[1L, 2L]) <
    4 * SAMP[["A-L4"]]$b_se[1L, 2L],
  # THE MECHANISM, checked on the SHIPPED evaluator rather than inferred from the
  # coefficient block. A_q is odd in u exactly when q is odd; the sans-L = 2
  # coefficient block sits on odd q alone, so L_star is ODD IN u, and N1 then
  # follows from the symmetry of dU by parity -- an identity, not a small number.
  # The sans-L = 4 leg is the positive control: without it the assertion could
  # pass on an evaluator that returned zero, or on a tolerance set too loose.
  {
    zz <- matrix(c(0.2, -0.1, 0.4), 1L, 3L); uu <- 0.8
    odd_defect <- function(k) {
      sp <- dgp_spec("A", k); e <- FIT[[sprintf("A-L%d", k)]]$es
      ap <- L_star_eval(e, uu, zz, sp); am <- L_star_eval(e, -uu, zz, sp)
      max(abs(am + ap)) / max(abs(ap))
    }
    odd_defect(2L) < 1e-4 && odd_defect(4L) > 1e-1
  }
)

# ---- Table (bare tabular, INV-13) ------------------------------------------

fmt <- function(x, d = 4) formatC(x, format = "f", digits = d)
sci <- function(x, d = 2) {
  ifelse(x == 0, "0",
         sprintf("$%s\\times10^{%d}$",
                 formatC(x / 10^floor(log10(abs(x))), format = "f", digits = d),
                 floor(log10(abs(x)))))
}
sig <- function(x) ifelse(abs(x) < 1e-3, sci(x), fmt(x, 4))

rows <- c(
  "\\toprule",
  paste("Design & $\\mathsf L$ & $\\max_{j,l}\\|b_{jl}\\|$ &",
        "$\\max_{j,l}\\|L_{\\star,jl}\\|$ & ratio & $\\|b\\|_F$ &",
        "$\\|L_\\star\\|_F$ & ratio \\\\"),
  "\\midrule",
  "\\multicolumn{8}{l}{\\textit{Panel A: the N1 defect, computed}} \\\\",
  "\\midrule")
for (k in names(FIT)) {
  f <- FIT[[k]]
  rows <- c(rows, paste(sprintf("DGP-%s", f$spec), f$L, sig(f$b_max),
                        fmt(f$L_max, 4), sig(f$b_max / f$L_max), sig(f$b_fro),
                        fmt(f$L_fro, 4), sig(f$b_fro / f$L_fro),
                        sep = " & "))
  rows[length(rows)] <- paste0(rows[length(rows)], " \\\\")
}
rows <- c(rows,
  "\\\\[0.5em]",
  "\\multicolumn{8}{l}{\\textit{Panel B: contracted, per unit $\\|\\hat\\varrho-\\varrho\\|_{L^2}$}} \\\\",
  "\\midrule",
  paste("Design & $\\mathsf L$ & $n$ & $\\Gamma_{\\mathrm{op}}$ &",
        "$\\Gamma_{\\mathrm{real}}$ & $\\Gamma$ trunc. & $\\Lambda$ &",
        "$\\Gamma_{\\mathrm{real}}/\\Lambda$ \\\\"),
  "\\midrule")
for (k in names(CONTR)) {
  f <- FIT[[k]]; cu <- CONTR[[k]]
  for (j in seq_along(N_ARM)) {
    rows <- c(rows, paste(sprintf("DGP-%s", f$spec), f$L,
                          format(N_ARM[j], big.mark = ","),
                          sig(f$gamma_op), sig(cu$gamma),
                          sig(CONTR_TR[[k]][[j]]$gamma), fmt(cu$lambda, 4),
                          sig(cu$gamma / cu$lambda), sep = " & "))
    rows[length(rows)] <- paste0(rows[length(rows)], " \\\\")
  }
}
rows <- c(rows,
  "\\\\[0.5em]",
  "\\multicolumn{8}{l}{\\textit{Panel C: mechanism and confirmation}} \\\\",
  "\\midrule",
  paste("Design & $\\mathsf L$ & odd-$q$ share & bal.\\ resid. &",
        "sampled $\\max\\|b_{jl}\\|$ & MC SE & binned $\\|\\hat b\\|/\\|L_\\star\\|$ &",
        "binned floor \\\\"),
  "\\midrule")
for (k in names(FIT)) {
  f <- FIT[[k]]; s <- SAMP[[k]]
  bf <- if (!is.null(BINF[[k]])) BINF[[k]] else NULL
  ij <- which(s$b_l2 == max(s$b_l2), arr.ind = TRUE)[1L, ]
  rows <- c(rows, paste(sprintf("DGP-%s", f$spec), f$L, fmt(f$odd_share, 6),
                        sci(f$bal_resid), sig(max(s$b_l2)),
                        sig(s$b_se[ij[1L], ij[2L]]),
                        if (is.null(bf)) "--" else fmt(bf$b_rms, 4),
                        if (is.null(bf)) "--" else fmt(bf$floor, 4), sep = " & "))
  rows[length(rows)] <- paste0(rows[length(rows)], " \\\\")
}
rows <- c(rows,
  "\\\\[0.5em]",
  paste("\\multicolumn{8}{l}{\\textit{Panel E: the shipped $T_2$ statistic,",
        "with and without the $\\varphi$-error (DGP-A, sampled)}} \\\\"),
  "\\midrule",
  paste("$\\mathsf L$ & $h$ & $n=1{,}000$ & (MC SE) & $n=8{,}000$ & (MC SE) &",
        "$\\beta$ & $\\Lambda\\tau_n$ at $8{,}000$ \\\\"),
  "\\midrule")
for (i in seq_len(nrow(PROBE_BETA))) {
  bb <- PROBE_BETA[i]
  lo <- PROBE_DT[L == bb$L & h_on == bb$h_on & n == 1000L]
  hi <- PROBE_DT[L == bb$L & h_on == bb$h_on & n == 8000L]
  lam <- CONTR[[sprintf("A-L%d", bb$L)]]$lambda
  rows <- c(rows, paste(bb$L, if (bb$h_on) "on" else "off",
                        fmt(lo$T2, 4), fmt(lo$T2_se, 4),
                        fmt(hi$T2, 4), fmt(hi$T2_se, 4),
                        sprintf("$%+.3f$", bb$beta),
                        fmt(lam * hi$tau, 4), sep = " & "))
  rows[length(rows)] <- paste0(rows[length(rows)], " \\\\")
}
rows <- c(rows, "\\bottomrule")

dir.create(here::here("paper", "tables", "sim"), showWarnings = FALSE,
           recursive = TRUE)
writeLines(c("\\begin{tabular}{llcccccc}", rows, "\\end{tabular}"),
           here::here("paper", "tables", "sim", "sim_thm_rootn_n1defect.tex"))

saveRDS(list(fit = lapply(FIT, function(f) f[setdiff(names(f), "es")]),
             contraction = CONTR, contraction_trunc = CONTR_TR,
             sampled = SAMP, binned = BINF,
             probe = PROBE_DT, probe_beta = PROBE_BETA,
             c_delta = C_DELTA, b_probe = B_PROBE,
             quad_shift = quad_shift, n_arm = N_ARM, c_r = C_R,
             gh_m = GH_M, gh_m_tr = GH_M_TR, n_dir = N_DIR,
             n_dir_tr = N_DIR_TR, n_samp = N_SAMP),
        here::here("quality_reports", "sim", "sim_thm_rootn_n1defect.rds"))

# ---- Console report ---------------------------------------------------------

cat("\n=== N1 defect, computed (no sampling error) ===\n")
for (k in names(FIT)) {
  f <- FIT[[k]]
  cat(sprintf("%-6s L=%d  max_jl||b|| = %-12.6g  / max_jl||L*|| = %-9.4g -> %.4g\n",
              paste0("DGP-", f$spec), f$L, f$b_max, f$L_max, f$b_max / f$L_max))
  cat(sprintf("          ||b||_F   = %-12.6g  / ||L*||_F     = %-9.4g -> %.4g",
              f$b_fro, f$L_fro, f$b_fro / f$L_fro))
  cat(sprintf("   odd-q share %.6f\n", f$odd_share))
}
cat("\n=== contracted, per unit ||varrho-hat - varrho|| ===\n")
for (k in names(CONTR)) for (j in seq_along(N_ARM)) {
  cu <- CONTR[[k]]; ct <- CONTR_TR[[k]][[j]]
  cat(sprintf(paste("%-6s n=%6d  Gamma_op=%-11.5g Gamma_real=%-11.5g",
                    "(trunc %-11.5g +/- %-9.3g) Lambda=%.4g\n"),
              k, N_ARM[j], FIT[[k]]$gamma_op, cu$gamma,
              ct$gamma, ct$gamma_se, cu$lambda))
}
cat("\n=== independent sampled confirmation (n = 2e6) ===\n")
for (k in names(SAMP)) {
  s <- SAMP[[k]]
  cat(sprintf("%-6s max sampled ||b|| = %.5g   (largest entry MC SE %.3g)\n",
              k, max(s$b_l2), max(s$b_se)))
}
cat("\n=== Jacobian arm's binned statistic against its own floor ===\n")
for (k in names(BINF))
  cat(sprintf("%-6s binned ||b-hat||/||L*|| = %.4f   noise floor 1/sqrt(%d) = %.4f\n",
              k, BINF[[k]]$b_rms, BINF[[k]]$per_cell, BINF[[k]]$floor))
cat(sprintf("\nquadrature stability (m=%d vs m=%d), max shift in max||b||: %.3g\n",
            GH_M, GH_M_LO, max(quad_shift)))

cat("\n=== Panel E: the shipped T_2 statistic, h on vs h off (DGP-A) ===\n")
cat("   shipped ablsplit values for comparison: L=2  0.3374 -> 0.2696 (beta -0.108)\n")
cat("                                           L=4  0.5687 -> 0.8431 (beta +0.189)\n")
for (i in seq_len(nrow(PROBE_BETA))) {
  bb  <- PROBE_BETA[i]
  lo  <- PROBE_DT[L == bb$L & h_on == bb$h_on & n == 1000L]
  hi  <- PROBE_DT[L == bb$L & h_on == bb$h_on & n == 8000L]
  lam <- CONTR[[sprintf("A-L%d", bb$L)]]$lambda
  cat(sprintf(paste("L=%d h=%-3s  %.4f (%.4f) -> %.4f (%.4f)  beta = %+.3f",
                    "  [centred-only prediction %.4f -> %.4f]\n"),
              bb$L, if (bb$h_on) "on" else "off", lo$T2, lo$T2_se, hi$T2,
              hi$T2_se, bb$beta, lam * lo$tau, lam * hi$tau))
}
