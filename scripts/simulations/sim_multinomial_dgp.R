# ============================================================================
# sim_multinomial_dgp.R
#
# Shared data-generating processes for the GENERAL-L arm of the Monte Carlo
# (panel-npiv-discrete). Companion to sim_thm_rootn_dgp.R, which serves the
# abstract-operator arms; this file serves the arms that run the SHIPPED engine
# (scripts/R/lf_panel.R, scripts/R/orthogonal_theta.R) at L = 2, 3 and 4.
#
# THIS FILE IS SOURCED, NOT RUN. It sets no seed and writes no output.
# The scripts that source it each set exactly one seed at their top (INV-14).
#
# ---------------------------------------------------------------------------
# WHY IT EXISTS
#
# sim_thm_rootn_dgp.R:469 and sim_thm_rootn_headroom_dgp.R:341 are each
# `pw <- cbind(1 - rr, rr)`: the paper's simulation section is BINARY, on both
# designs, while its theory is written for an L-valued discrete instrument and
# Section 6 estimates on a four-category trigger. This file is the general-L
# design the section was missing.
#
# ---------------------------------------------------------------------------
# THE MODEL (def:model, eq:levels / eq:diffs)
#
#   Y_ij = varphi(X_ij) + Z_ij' theta + eta_i + U_ij,   j in {1,2}
#   dY_i = varphi(X_i2) - varphi(X_i1) + dZ_i' theta + dU_i
#
# X scalar continuous on (0,1); W in {0,...,L-1}; eta_i differenced out.
# Identification (def:admissible): (A) dU _||_ W | dZ; (B) E[dZ dU] = 0.
# Both hold EXACTLY here, not approximately: W is drawn from varrho(dZ) with its
# own uniform, independent of the (v1, v2, e) shocks that build dU, which is (A);
# and every term of dU is orthogonal to (1, z1, z2) in population, which is (B).
#
# ---------------------------------------------------------------------------
# DESIGN DECISIONS (M1-M6) -- declared, not buried
#
# M1. THE PROPENSITY IS A MULTINOMIAL LOGIT LINEAR IN dZ, and the estimator
#     fits a multinomial logit linear in dZ. This is not a convenience: it is
#     what makes the exercise a test of the ESTIMATOR rather than of a
#     specification error. thm:rootn prices varrho-hat through a RATE ((T-4),
#     eq:foldrates); a design whose varrho is outside the family the estimator
#     fits gives varrho-hat a non-vanishing limit and violates that hypothesis,
#     so a failure there is not evidence about the theorem.
#
#     *** THIS IS THE DEFECT IN THE 2026-08-11 PROBE, AND IT IS WHY THAT PROBE
#     REPORTED phi-hat FAILING AT L = 4. *** Its DGP put a z1*z2 INTERACTION in
#     cell 3's linear index and handed the estimator a multinomial logit in
#     (1, z1, z2). Measured at n = 40,000, where sampling noise is negligible:
#     RMSE(varrho-hat_3 - varrho_3) = 0.147 against sd(varrho_3) = 0.184 -- the
#     fit recovers almost none of that cell's variation -- and the resulting
#     A1 residual E[Wtilde_3 1{dU <= q}] is -0.036 at the fitted propensity
#     against +0.0005 at the true one. That residual is a POPULATION quantity:
#     it does not shrink in n. So ||T-hat_m|| is bounded below by a constant
#     while delta-hat_n falls at n^{-1/2}, the discrepancy principle correctly
#     declines to certify any iterate, and the iteration walks phi-hat toward
#     whatever reduces a criterion whose zero is not varphi. The same design at
#     L = 2 has a violation of -0.010, BELOW delta-hat_n at these n, which is
#     why the binary arm looked healthy on it.
#
#     That design is retained here, as `misspec`, because it is a real and
#     reportable stress: at L >= 3 the propensity must get L - 1 index functions
#     right where the binary contrast needs one, and errors that partially
#     cancel in a pooled contrast do not cancel cellwise.
#
# M2. THE NON-BASE CELLS SHARE A SLOPE. With eta_l = a_l + b' dZ for every
#     l >= 1, sum_l exp(eta_l) = e^{b' dZ} sum_l e^{a_l}, so the coarsened
#     binary probability P(W > 0 | dZ) is EXACTLY logistic in b' dZ. Both the
#     L = 4 multinomial fit and the L = 2 binary fit are then correctly
#     specified, and the two arms differ ONLY in the granularity of the contrast
#     -- which is the comparison the surplus-contrasts reading of eq:contrast is
#     about. With free slopes the coarsening of a multinomial logit is NOT a
#     logit: measured, the binary arm's A1 residual rises to 0.0045 and
#     RMSE(varrho-hat_2 - varrho_2) to 0.029, so the L = 2 arm would carry a
#     specification error the L = 4 arm does not and the comparison would be
#     confounded. Under the common slope both sit at 0.0006-0.0014, which is the
#     Monte Carlo floor at the n the check was run at.
#
# M3. dU's CONDITIONAL SCALE MOVES WITH dZ. dU = gamma z1 z2 + 0.6 (v2 - v1) +
#     sigma(z1) e with sigma(z1) = 0.35 + 0.30 Phi(z1). Without a term of this
#     kind the conditional centring of A1 would be INERT on this design: varrho
#     is a function of the linear index b' dZ, and every even function of dZ is
#     uncorrelated with it, so the pooled contrast E[(W - wbar) 1{dU <= u}]
#     would vanish at first order and the unconditional engine would be right by
#     accident. sigma(.) monotone in z1 makes F(u | dZ) move with the same index
#     varrho moves with, so the unconditional contrast is genuinely biased and
#     the conditional device is doing work. E[z1 sigma(z1) e] = 0 keeps (B).
#
# M4. THREE CARDINALITIES OFF ONE DRAW. w4 is the design; w3 merges the two
#     smallest cells; w2 is 1{W > 0}. So L = 2, 3, 4 are COARSENINGS of one
#     instrument on one draw, and an arm-to-arm difference is a difference in
#     granularity and not in the data. Under M2 the L = 3 coarsening also has an
#     exactly-multinomial-logit propensity, for the same algebra.
#
# M5. THE FIRST STAGE IS CELLWISE. X_i2 is shifted by `shift[W_i + 1]`, so each
#     cell moves X by a different amount and the L - 1 contrasts are not
#     redundant. `balanced` uses (0, 0.6, 0.9, 1.2); `skewed` halves it.
#
# M6. varphi IS sin(2 pi x) / 2 ON (0, 1), as in the 2026-08-11 probe, so the
#     phi-side numbers are comparable with it. It integrates to zero on [0,1],
#     which is def:spaces's normalisation at pi = Uniform[0,1].
#
# ---------------------------------------------------------------------------
# THE THREE DESIGNS
#
#   balanced  cells near equal, strong first stage, propensity correctly
#             specified at every cardinality.  FAVOURABLE.
#   skewed    cell shares near Section 6's realised (0.700, 0.115, 0.066,
#             0.119) and a first stage half as strong.  Propensity still
#             correctly specified.  STRESS ON CELL SIZE -- the smallest cell
#             carries ~6.6% of the sample, so at n = 400 it holds ~26
#             observations.
#   misspec   a z1*z2 interaction in cell 3's index, outside the family the
#             estimator fits.  STRESS ON THE NUISANCE-RATE HYPOTHESIS, and a
#             documented VIOLATION of it -- the one design here on which
#             thm:rootn's (T-4) does not hold.
#
#             Its PROPENSITY is the 2026-08-11 probe's exactly: at gamma = 1.2
#             the three non-base indices are 0.20 + 1.2 z1, 0.10 + 0.6 z2 and
#             -0.10 + 1.2 z1 z2, which is that file's `eta` term for term.  What
#             it does NOT reproduce is that probe's homoskedastic dU: every
#             design here carries M3's sigma(z1), so the three are comparable to
#             each other.  The claim this arm supports is therefore about the
#             PROPENSITY's specification, which is what it holds fixed, and the
#             comparison that licenses it is misspec-against-balanced within
#             this file, not against a number from another one.
# ============================================================================

# ---- truth -----------------------------------------------------------------

MDGP_THETA      <- c(1.0, -0.5)          # slopes on (z1, z2)
MDGP_THETA_FULL <- c(0.0, MDGP_THETA)    # with the differenced intercept
MDGP_PHI        <- function(x) sin(2 * pi * x) / 2

# ---- the designs -----------------------------------------------------------
#
# `slope` is the common b of M2, a 3 x 2 matrix so that `misspec` can break the
# commonality in one row without a second code path.  `inter` is the coefficient
# on z1*z2 in each non-base index: zero on the two clean designs, and that is
# the ONLY thing that distinguishes `misspec` from `balanced`.

MDGP_SPEC <- list(
  balanced = list(
    label  = "balanced cells",
    tex    = "Balanced",
    a      = c(0.20, 0.10, -0.10),
    slope  = rbind(c(0.90, 0.45), c(0.90, 0.45), c(0.90, 0.45)),
    inter  = c(0, 0, 0),
    shift  = c(0, 0.60, 0.90, 1.20),
    gamma  = 1.0,
    correct_spec = TRUE
  ),
  skewed = list(
    label  = "skewed cells (Section 6 shape), weak first stage",
    tex    = "Skewed",
    a      = c(-1.85, -2.45, -1.85),
    slope  = rbind(c(0.90, 0.45), c(0.90, 0.45), c(0.90, 0.45)),
    inter  = c(0, 0, 0),
    shift  = c(0, 0.30, 0.45, 0.60),
    gamma  = 1.0,
    correct_spec = TRUE
  ),
  misspec = list(
    label  = "propensity outside the fitted family (2026-08-11 probe design)",
    tex    = "Misspecified $\\hat\\varrho$",
    a      = c(0.20, 0.10, -0.10),
    slope  = rbind(c(1.20, 0.00), c(0.00, 0.60), c(0.00, 0.00)),
    inter  = c(0, 0, 1.20),
    shift  = c(0, 0.60, 0.90, 1.20),
    gamma  = 1.2,
    correct_spec = FALSE
  )
)

#' The true propensity varrho(dZ), cells 1..3, at given regressors.
#'
#' @param z numeric matrix n x 2, the non-degenerate coordinates of dZ.
#' @param spec one element of MDGP_SPEC.
#' @return numeric matrix n x 4: the full simplex, base cell in column 1.
mdgp_varrho <- function(z, spec) {
  zx <- z[, 1] * z[, 2]
  eta <- cbind(0,
               spec$a[1] + as.vector(z %*% spec$slope[1, ]) + spec$inter[1] * zx,
               spec$a[2] + as.vector(z %*% spec$slope[2, ]) + spec$inter[2] * zx,
               spec$a[3] + as.vector(z %*% spec$slope[3, ]) + spec$inter[3] * zx)
  exp(eta) / rowSums(exp(eta))
}

#' One draw of the four-cell panel design, with its 3- and 2-cell coarsenings.
#'
#' @param n integer. Sample size.
#' @param spec one element of MDGP_SPEC.
#' @return list: y, x1, x2, Z (n x 3, differenced intercept first), w4, w3, w2,
#'   du, P (n x 4 true propensity), sigma (conditional scale of dU).
mdgp_draw <- function(n, spec) {
  z  <- matrix(stats::rnorm(n * 2L), n, 2L)
  P  <- mdgp_varrho(z, spec)
  ## Inverse-CDF sampling; the cumulative sum is built column-wise because
  ## apply(., 1, cumsum) is the slowest line in the file at the validation n.
  ## pmin() guards the floating-point case u > sum_l P_l, which would index
  ## `shift` past its end rather than fail.
  cum <- P
  for (k in seq(2L, ncol(P))) cum[, k] <- cum[, k - 1L] + P[, k]
  w4 <- pmin(rowSums(stats::runif(n) > cum), ncol(P) - 1L)             # 0..3
  xi <- stats::rnorm(n); v1 <- stats::rnorm(n); v2 <- stats::rnorm(n)
  x1 <- stats::pnorm((xi + v1) / 1.5)
  x2 <- stats::pnorm((xi + spec$shift[w4 + 1L] + v2) / 1.5)
  sg <- 0.35 + 0.30 * stats::pnorm(z[, 1])                             # M3
  du <- spec$gamma * z[, 1] * z[, 2] + 0.6 * (v2 - v1) + sg * stats::rnorm(n)
  list(y  = MDGP_PHI(x2) - MDGP_PHI(x1) + as.vector(z %*% MDGP_THETA) + du,
       x1 = x1, x2 = x2, Z = cbind(const = 1, z),
       w4 = w4,
       w3 = pmin(w4, 2L),                                              # M4
       w2 = as.numeric(w4 > 0L),
       du = du, P = P, sigma = sg)
}

#' Pick the instrument of a given cardinality off one draw.
#'
#' @param d list from mdgp_draw().
#' @param L integer in {2, 3, 4}.
mdgp_inst <- function(d, L) {
  switch(as.character(L), "2" = d$w2, "3" = d$w3, "4" = d$w4,
         stop("mdgp_inst: L must be 2, 3 or 4"))
}

#' Design validity, at large n and BEFORE any estimation.
#'
#' A design that does not satisfy the identifying restrictions makes "recovers
#' the truth" meaningless, so this is run first and its verdict is reported.
#' Six quantities:
#'   zmom      E[dZ dU], def:admissible (B), target 0
#'   a1_true   max_l,q |E[Wtilde_l 1{dU <= q}]| at the TRUE varrho, A1, target 0
#'   a1_fit    the same at the FITTED varrho -- the quantity M1 is about.  It is
#'             a POPULATION diagnostic: run at large n it isolates the
#'             specification error from the sampling error.
#'   uncond    max_q |E[(W - wbar) 1{dU <= q}]| -- how much work the CONDITIONAL
#'             centring is doing.  Near zero would mean the design cannot tell a
#'             conditional engine from an unconditional one (M3).
#'   shares    realised cell shares
#'   relev     E[X2 - X1 | W = l], the first stage (M5)
#'
#' Every moment is reported IN ITS OWN MONTE CARLO STANDARD ERROR, not against a
#' fixed tolerance. A fixed tolerance is not a test: E[z2 dU] has a sampling
#' standard error of 0.0036 at n = 3e5 on this design, because dU carries a
#' z1 z2 term whose fourth moments are large, so a threshold of 5e-3 rejects a
#' correct design about a third of the time and would have been read as a design
#' fault. `ok` requires every studentised moment below 4.
#'
#' @param spec one element of MDGP_SPEC.
#' @param n_check integer. Sample size for the check.
#' @param L integer. Cardinality to check the A1 residuals at.
#' @return named list of the six, plus a logical `ok`.
mdgp_validate <- function(spec, n_check = 4e5L, L = 4L) {
  d <- mdgp_draw(n_check, spec)
  w <- mdgp_inst(d, L)
  cells <- sort(unique(as.integer(w)))
  qs <- stats::quantile(d$du, c(0.25, 0.50, 0.75))
  Wind <- vapply(cells[-1], function(k) as.numeric(as.integer(w) == k),
                 numeric(n_check))
  ## True varrho for THIS cardinality: the 4-cell simplex collapsed the same way
  ## the instrument is.
  Ptrue <- if (L == 4L) d$P[, -1L, drop = FALSE] else if (L == 3L)
    cbind(d$P[, 2], d$P[, 3] + d$P[, 4]) else
      matrix(rowSums(d$P[, -1L, drop = FALSE]), n_check, 1L)
  ## Studentised: |mean| / (sd / sqrt(n)), maximised over cells and quantiles.
  tmax <- function(M) {
    t <- vapply(qs, function(q) {
      A <- M * (d$du <= q)
      abs(colMeans(A)) / (apply(A, 2L, stats::sd) / sqrt(n_check))
    }, numeric(ncol(M)))
    max(t)
  }
  gap <- function(M) max(abs(vapply(qs, function(q) colMeans(M * (d$du <= q)),
                                    numeric(ncol(M)))))
  WT_true <- Wind - Ptrue
  a1_true <- gap(WT_true); a1_true_t <- tmax(WT_true)
  Pfit <- fit_propensity_multi(w, d$Z, seq_len(n_check), seq_len(n_check),
                               eps = 1e-6, cells = cells)
  attr(Pfit, "prop_diag") <- NULL
  WT_fit <- Wind - as.matrix(Pfit)
  a1_fit <- gap(WT_fit); a1_fit_t <- tmax(WT_fit)
  wbar <- mean(w)
  uncond <- max(abs(vapply(qs, function(q) mean((w - wbar) * (d$du <= q)),
                           numeric(1))))
  zt <- abs(colMeans(d$Z * d$du)) /
    (apply(d$Z * d$du, 2L, stats::sd) / sqrt(n_check))
  zt[1] <- abs(mean(d$du)) / (stats::sd(d$du) / sqrt(n_check))
  list(zmom = colMeans(d$Z * d$du), zmom_t = zt,
       a1_true = a1_true, a1_true_t = a1_true_t,
       a1_fit = a1_fit, a1_fit_t = a1_fit_t,
       uncond = uncond,
       shares = as.vector(table(d$w4)) / n_check,
       min_varrho = min(d$P),
       relev = vapply(0:3, function(k) mean((d$x2 - d$x1)[d$w4 == k]),
                      numeric(1)),
       rmse_rho = sqrt(mean((as.matrix(Pfit) - Ptrue)^2)),
       ok = max(zt) < 4 && a1_true_t < 4)
}
