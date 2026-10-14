# ============================================================================
# app_tsp_weighted.R
#
# The WEIGHTED-EMPIRICAL-MEASURE layer for the multiplier bootstrap of
# phi-hat (design M, scripts/application/app_tsp_06_phi_mult.R).
#
# THIS FILE IS SOURCED, NOT RUN.  It sets no seed and writes no output.
#
# ---------------------------------------------------------------------------
# WHAT IT DOES
#
# The multiplier bootstrap replaces the empirical measure
#
#     P-hat_n = (1/n) sum_i delta_{Z_i}      by      P-hat_n^w = (1/n) sum_i w_i delta_{Z_i},
#
# with w_i i.i.d. Exp(1) normalised to mean one.  Every estimator that is a
# functional of P-hat_n therefore has a weighted analogue obtained by pushing
# w_i through EVERY EMPIRICAL AVERAGE and nothing else.  The design points are
# untouched: no observation is duplicated and none is deleted.
#
# ---------------------------------------------------------------------------
# WHY IT IS NOT A REIMPLEMENTATION, AND WHY IT DOES NOT TOUCH scripts/R/
#
# Two constraints pull in opposite directions.
#
#   (i)  The estimator must not be reimplemented.  The LF iteration, its
#        discrepancy stopping rule, and the plug-in second-stage driver are the
#        estimator; rewriting them to carry weights would fork the object under
#        study and the comparison with design C0 would no longer be clean.
#
#   (ii) scripts/R/lf_panel.R and scripts/R/orthogonal_theta.R must not be
#        edited.  Their md5 sums are part of design C0's cache fingerprint
#        (app_tsp_05_phi_band.R, FULL_CFG$src), so ANY edit -- even adding an
#        optional argument that defaults to the existing behaviour -- makes the
#        cached configuration mismatch and the script unlink()s all 99 stored
#        C0 replications.  That is roughly nine core-hours of the reported band
#        destroyed by a whitespace change.
#
# Both are satisfied by LEXICAL SCOPING.  The two estimator files are
# sys.source()d into a PRIVATE ENVIRONMENT, and inside that environment the
# handful of primitives that touch the empirical measure are replaced by
# weighted versions.  Because lf_solve() and phi_second_stage() are defined in
# that same environment, their calls to ker_dens(), apply_adjoint(),
# operator_residual() and the rest resolve to the weighted versions -- while
# their own bodies, the iteration and the stopping rule, are byte-for-byte the
# code in scripts/R/.  The files on disk are never modified, so C0's
# fingerprint and its cache are untouched.
#
# REUSED VERBATIM: lf_solve(), phi_second_stage(), make_operator(),
# build_int_matrix(), cumtrapz_centre(), k_order(), K_order(), k_gauss(),
# K_gauss().
#
# ---------------------------------------------------------------------------
# WHAT IS WEIGHTED, AND WHAT DELIBERATELY IS NOT
#
# WEIGHTED (an average with respect to P-hat_n):
#   bw_rot            the rule-of-thumb bandwidth's sd(.)
#   ker_dens          the kernel density  -- and hence pi_1, pi_2, pi_ev
#   ker_dist          the smoothed CDF    -- and hence F_0, F_1
#   ll_reg            local-linear regression on a scalar
#   ll_reg_multi      local-linear regression on a matrix
#   survival_matrix   the (1/n) sum_j in the adjoint's kernel
#   integrate_centre  the centring constant of the integrated derivative
#   apply_adjoint     the centring constant g-bar
#   operator_norm2    the L^2(P-hat_n) norms of the power iteration, which set
#                     the Landweber step
#   operator_residual h_u, f_u, F_0, F_1, and the discrepancy itself
#   init_control      the quantile regression, the two partialling-out steps,
#                     the OLS for the linear coefficient, and the intercept
#
# NOT WEIGHTED, BY DESIGN -- each is an integral against Lebesgue measure on a
# grid, not an expectation against the empirical measure:
#   build_int_matrix  trapezoid quadrature on the ORDER STATISTICS of X.  This
#                     is the whole point of the exercise.  Under the pairs
#                     bootstrap a duplicated county is an exact tie, the
#                     trapezoid interval has zero width, and the operator the
#                     LF iteration inverts is not the operator the estimator
#                     was designed around.  Under multiplier weights the design
#                     points are unchanged, so M1 and M2 are unchanged.
#   cumtrapz_centre   quadrature on the 60-point evaluation grid, then centring
#                     over that grid -- 60 grid points, not 983 counties.
#   Vhat in init_control:  rowMeans(pred <= dx) averages over the 100 QUANTILE
#                     LEVELS tau, not over observations.
#
# NOT ON THE PATH (stated rather than silently assumed):
#   indep_criterion   only evaluated when track_cfun = TRUE; phi_second_stage
#                     never sets it.  Replaced below by a stop() guard so that
#                     it cannot become a silently unweighted average later.
#   lm.fit inside lf_solve's theta_mode = "alternate" branch.  phi_second_stage
#                     always passes theta_mode = "fixed", and design M holds
#                     theta at theta-hat, so the branch is dead.  Guarded by an
#                     assertion in phi_second_stage_weighted().
#   init_robinson, init_poly.  init_fn is init_control throughout.
#   everything in orthogonal_theta.R -- crossfit_once(), the balancing solve,
#                     the moment and its Jacobian.  Design M holds theta at
#                     theta-hat exactly as C0 does, so the cross-fitting fold
#                     averages are never evaluated in a replication.  They are
#                     therefore NOT weighted here, and a multiplier bootstrap
#                     that re-estimated theta would need this file extended.
#
# ---------------------------------------------------------------------------
# THE ONE AVERAGE THAT CANNOT BE OVERRIDDEN, AND HOW IT IS HANDLED
#
# lf_solve() computes the discrepancy INSIDE its own body:
#
#     errn[it] <- sqrt(mean(res$err^2))                    (lf_panel.R:407)
#
# and the argmin of errn IS the stopping index m-phi-hat.  Overriding it would
# mean rewriting the iteration, which is exactly what (i) forbids.  So the
# weighted operator_residual() returns
#
#     err = sqrt(w) * (F_1 - F_0),
#
# for which the untouched line yields
#
#     sqrt( (1/n) sum_i w_i (F_1 - F_0)^2(u_i) ),
#
# the L^2(P-hat_n^w) discrepancy -- which is what the weighted estimator's
# stopping rule must minimise.  The unscaled residual is returned alongside as
# `err_raw`, and `comperr` is deliberately left UNSCALED, because comperr is
# fed to apply_adjoint(), where the weighting happens in the average rather
# than in the integrand.  grep confirms res$err has exactly one consumer
# (lf_panel.R:407) and that operator_residual is called in exactly two places
# (lf_panel.R:396 for $fu, 406 for the iteration).
#
# ---------------------------------------------------------------------------
# FAIL-FAST WEIGHT MATCHING
#
# An unweighted average left anywhere silently makes the band wrong.  So the
# weighted primitives do not fall back to unit weights: wt_n() ERRORS unless
# the weight vector's length matches the data being averaged over.  A primitive
# reached with a subsample -- the one real case is F_0 and F_1, which average
# within a W cell -- must therefore pass its sub-weights EXPLICITLY through the
# `wt` argument.  Anything overlooked stops the replication instead of quietly
# returning an unweighted number.
#
# Three assertions back this up, run by verify_weighted_layer():
#   1. at w == 1 the layer reproduces the untouched phi_second_stage();
#   2. the layer is EXACTLY invariant to rescaling all weights, which
#      demonstrates the normalisation convention is immaterial rather than
#      asserting it;
#   3. wsd() and wmedian() reduce to sd() and median() at unit weights.
# ============================================================================

# ---- weighted scalar summaries ---------------------------------------------

#' Weighted mean (Hajek form).
#'
#' @param x numeric. Values.
#' @param wt numeric. Non-negative weights, same length as `x`.
#' @return numeric(1).
wmean <- function(x, wt) {
  stopifnot(length(x) == length(wt))
  sum(wt * x) / sum(wt)
}

#' Weighted standard deviation, reducing to stats::sd() at unit weights.
#'
#' The weights are rescaled to mean one internally, so the result does not
#' depend on the scale of `wt`, and the (n - 1) denominator is the same one
#' stats::sd() uses.
#'
#' @param x numeric. Values.
#' @param wt numeric. Non-negative weights, same length as `x`.
#' @return numeric(1).
wsd <- function(x, wt) {
  stopifnot(length(x) == length(wt))
  n <- length(x)
  wt <- wt * (n / sum(wt))
  m <- sum(wt * x) / n
  sqrt(sum(wt * (x - m)^2) / (n - 1))
}

#' Weighted median, reducing to stats::median() at unit weights.
#'
#' Uses the "average the two order statistics that straddle half the weight"
#' convention when the cumulative weight lands exactly on the halfway point,
#' which is what stats::median() does at unit weights and even length.  With
#' continuous weights an exact landing has probability zero.
#'
#' @param x numeric. Values.
#' @param wt numeric. Non-negative weights, same length as `x`.
#' @return numeric(1).
wmedian <- function(x, wt) {
  stopifnot(length(x) == length(wt))
  o <- order(x)
  xs <- x[o]
  cw <- cumsum(wt[o])
  half <- cw[length(cw)] / 2
  i <- which(cw >= half)[1L]
  if (i < length(xs) && abs(cw[i] - half) <= 1e-9 * half) {
    return(0.5 * (xs[i] + xs[i + 1L]))
  }
  xs[i]
}

#' Weighted empirical CDF coordinate map (the weighted analogue of C2).
#'
#' Used only by the side-arm that rebuilds the coordinate map under the
#' weights.  Each county contributes its weight to both period values, exactly
#' as make_x_coord() lets each county contribute two pooled observations.
#'
#' @param x1,x2 numeric. Period-1 and period-2 values in native units.
#' @param wt numeric. County weights, length equal to `x1`.
#' @return named list: x1, x2 (transformed), mode, fwd, inv.
make_x_coord_wtd <- function(x1, x2, wt) {
  stopifnot(length(x1) == length(x2), length(wt) == length(x1))
  pooled <- c(x1, x2)
  pw <- c(wt, wt)
  o <- order(pooled)
  xs <- pooled[o]
  cw <- cumsum(pw[o]) / sum(pw)
  # Right-continuous step function, evaluated by the last support point at or
  # below the query, exactly as stats::ecdf() does.
  sup <- !duplicated(xs, fromLast = TRUE)
  xu <- xs[sup]
  fu <- cw[sup]
  fwd <- function(x) {
    j <- findInterval(x, xu)
    out <- numeric(length(x))
    out[j > 0L] <- fu[j[j > 0L]]
    out
  }
  inv <- stats::approxfun(fu, xu, rule = 2)
  list(x1 = fwd(x1), x2 = fwd(x2), mode = "rank_wtd", fwd = fwd, inv = inv)
}

# ---- the weighted primitives ------------------------------------------------
#
# Each is assigned into the private environment below, where its closure is
# rebound so that `.wts` and the sibling primitives resolve there.  Signatures
# match the originals in scripts/R/lf_panel.R argument-for-argument, plus an
# optional `wt` where a subsample average is genuinely needed.

#' The weight vector for an average over `n` observations.
#'
#' Errors rather than defaulting, so that an average this layer failed to
#' reweight stops the replication instead of returning an unweighted number.
w_wt_n <- function(n) {
  wv <- .wts
  if (is.null(wv)) {
    stop("weighted layer: .wts is unset; call through ",
         "phi_second_stage_weighted()")
  }
  if (length(wv) != n) {
    stop(sprintf(paste("weighted layer: an average over %d observations was",
                       "reached with %d weights. Pass sub-weights explicitly",
                       "through the `wt` argument."), n, length(wv)))
  }
  wv
}

w_wt_for <- function(x) w_wt_n(length(x))

w_bw_rot <- function(x, power = -1 / 5, cst = 1.059) {
  cst * wsd(x, w_wt_for(x)) * length(x)^power
}

w_ker_dens <- function(x, xeval = x, h = bw_rot(x), order = 2L, wt = NULL) {
  wt <- if (is.null(wt)) w_wt_for(x) else wt
  d <- outer(xeval, x, "-") / h
  as.vector(k_order(d, order) %*% wt) / (sum(wt) * h)
}

w_ker_dist <- function(x, xeval = x, h = bw_rot(x), order = 2L, wt = NULL) {
  wt <- if (is.null(wt)) w_wt_for(x) else wt
  d <- outer(xeval, x, "-") / h
  as.vector(K_order(d, order) %*% wt) / sum(wt)
}

w_ll_reg <- function(x, y, xeval = x, h = bw_rot(x)) {
  wo <- w_wt_for(x)
  m <- length(xeval)
  fit <- numeric(m)
  der <- numeric(m)
  for (j in seq_len(m)) {
    dx <- x - xeval[j]
    wt <- wo * k_gauss(dx / h)
    s0 <- sum(wt)
    s1 <- sum(wt * dx)
    s2 <- sum(wt * dx^2)
    t0 <- sum(wt * y)
    t1 <- sum(wt * dx * y)
    det <- s0 * s2 - s1^2
    if (!is.finite(det) || abs(det) < .Machine$double.eps^0.75) {
      fit[j] <- if (s0 > 0) t0 / s0 else NA_real_
      der[j] <- 0
    } else {
      fit[j] <- (s2 * t0 - s1 * t1) / det
      der[j] <- (s0 * t1 - s1 * t0) / det
    }
  }
  list(fit = fit, der = der)
}

w_ll_reg_multi <- function(X, y, Xeval = X, h = NULL) {
  X <- as.matrix(X)
  Xeval <- as.matrix(Xeval)
  d <- ncol(X)
  wo <- w_wt_for(X[, 1L])
  if (is.null(h)) h <- apply(X, 2, bw_rot, power = -1 / (4 + d))
  m <- nrow(Xeval)
  fit <- numeric(m)
  grad <- matrix(0, m, d)                                              # INV-17
  for (j in seq_len(m)) {
    dX <- sweep(X, 2, Xeval[j, ], "-")
    wt <- wo * exp(rowSums(dnorm(sweep(dX, 2, h, "/"), log = TRUE)))
    D <- cbind(1, dX)
    WD <- D * wt
    A <- crossprod(D, WD)
    b <- crossprod(WD, y)
    sol <- tryCatch(solve(A + diag(1e-10, d + 1), b),
                    error = \(e) rep(NA_real_, d + 1))
    fit[j] <- sol[1]
    grad[j, ] <- sol[-1]
  }
  list(fit = fit, grad = grad)
}

w_survival_matrix <- function(xrow, xcol, h) {
  wt <- w_wt_for(xcol)
  sweep(1 - K_gauss(outer(xrow, xcol, "-") / h), 2, wt / sum(wt), "*")
}

w_integrate_centre <- function(dphi, M, ord) {
  n <- length(dphi)
  wt <- w_wt_for(dphi)
  inv <- integer(n)
  inv[ord] <- seq_len(n)
  # Reindex BEFORE centring.  An unweighted mean is invariant to the sort, a
  # weighted one is not, so the original's centre-then-reindex order would pair
  # each weight with the wrong observation.
  phis <- as.vector(M %*% dphi[ord])[inv]
  phis - wmean(phis, wt)
}

w_apply_adjoint <- function(op, g) {
  gbar <- wmean(g, w_wt_for(g))
  d1 <- ((op$S12 %*% g - rowSums(op$S12) * gbar) -
         (op$S11 %*% g - rowSums(op$S11) * gbar)) / op$pi_1
  d2 <- ((op$S22 %*% g - rowSums(op$S22) * gbar) -
         (op$S21 %*% g - rowSums(op$S21) * gbar)) / op$pi_2
  dev <- ((op$Sev2 - op$Sev1) %*% g -
          rowSums(op$Sev2 - op$Sev1) * gbar) / op$pi_ev
  list(d1 = as.vector(d1), d2 = as.vector(d2), dev = as.vector(dev))
}

w_operator_norm2 <- function(op, weight = NULL, n_iter = 30L) {
  wt <- w_wt_n(op$n)
  if (is.null(weight)) weight <- rep(1, op$n)
  v <- stats::rnorm(op$n)
  v <- v / sqrt(wmean(v^2, wt))
  nrm <- NA_real_
  for (k in seq_len(n_iter)) {
    a <- apply_adjoint(op, weight * v)
    h1 <- integrate_centre(a$d1, op$M1, op$ord1)
    h2 <- integrate_centre(a$d2, op$M2, op$ord2)
    fw <- weight * (h2 - h1)
    nrm <- sqrt(wmean(fw^2, wt))
    if (!is.finite(nrm) || nrm <= 0) return(NA_real_)
    v <- fw / nrm
  }
  nrm
}

## MIRRORS THE BASE operator_residual(), AND MUST KEEP MIRRORING IT.
## make_weighted_env() rebinds `operator_residual` to this function, so lf_solve
## calls it with whatever signature the base one has.  When the base gained
## rho / bier / adj_wtil on 2026-08-05 and this did not, stage 6 died on
## "unused arguments" after stage 5 had already spent 4 hours -- the failure was
## loud, but it was loud in the wrong place.
##
## The conditional pieces are carried through in the weighted metric:
##   * rho:      Wtilde = W - varrho(Delta Z), weighted by wt exactly as the
##               cell CDFs were;
##   * bier:     the t-family multiplies observation j, so it commutes with the
##               weights;
##   * adj_wtil: the Wtilde_j factor of lem:adjoint(i), again per observation.
##
## *** DRIFTED AGAIN ON 2026-08-10, TAKING STAGE 6 DOWN.  SIGNATURE RESTORED
## 2026-08-11 AS AN INERT PASS-THROUGH -- and "inert" is the whole claim. ***
##
## The L-category generalization gave the base `pi_w` and `alpha`; this mirror
## did not follow.  make_weighted_env()'s contract check caught it and stopped:
##
##   weighted layer: operator_residual() has arguments (u, w, rho, bier,
##   adj_wtil, hu, order), which do not cover the base's (u, w, rho, bier,
##   adj_wtil, hu, order, pi_w, alpha) in order.  Update the mirror.
##
## So app_tsp_06_phi_mult.R was unrunnable from that date and died in 1.9
## seconds, which meant paper/tables/app_tsp_phi_boot_compare.tex could not be
## regenerated.  That was the THIRD recurrence of the drift the block above
## describes; the contract check, added after the second, did exactly its job --
## it failed at load rather than after stage 5's hour.
##
## Audited 2026-08-11: `operator_residual` is the ONLY one of the fourteen
## entries in WEIGHTED_OVERRIDES whose signature has drifted.
##
## WHAT THE REPAIR IS, AND WHAT IT DELIBERATELY IS NOT.  Both new formals are
## dead in every shipped path -- lf_panel.R's three internal call sites leave
## `pi_w` and `alpha` at NULL, and bw_u(u, alpha = NULL) is
## 1.059 sd(u) n^(-1/16), the rule hard-coded below -- so accepting them and
## acting on neither is BEHAVIOUR-PRESERVING TODAY, exactly.  It is not a
## decision about what the weighted layer should do with them, because that is
## an ESTIMATOR decision and belongs with the author:
##
##   * `pi_w` carries the l-weights of eq:psidef.  The weighted layer is binary
##     throughout -- `scal = wbar(1 - wbar)`, `wtil` a vector, the cell CDFs
##     pooled two ways -- so generalizing it is not a typing fix.
##   * `alpha` selects the A5(iii) bandwidth exponent h_u ~ n^{-alpha/8}.  Under
##     a weighted measure the relevant sample size is n_eff, not n, so even the
##     faithful reading is not the base's line with `wt` inserted.
##
## Rather than IGNORE either argument, the mirror STOPS if one arrives with a
## value that would change the answer.  Silently ignoring is how a future caller
## would get a weighted layer that quietly solves a different problem from the
## base -- which is the same species of defect as the drift itself, just later
## and harder to see.  Today no caller passes either, so neither branch fires.
w_operator_residual <- function(u, w, rho = NULL, bier = NULL, adj_wtil = FALSE,
                                hu = NULL, order = 8L, pi_w = NULL,
                                alpha = NULL) {
  if (!is.null(alpha)) {
    stop("w_operator_residual: `alpha` is accepted for signature parity with ",
         "operator_residual() and is NOT implemented in the weighted layer. ",
         "The A5(iii) bandwidth under a weighted measure runs on n_eff, not n, ",
         "so the rule is an estimator decision and not a port. Author call.")
  }
  if (!is.null(pi_w) && !isTRUE(all.equal(as.vector(pi_w), 1))) {
    stop("w_operator_residual: `pi_w` is accepted for signature parity with ",
         "operator_residual() and is NOT implemented in the weighted layer, ",
         "which is binary throughout. Author call.")
  }
  ncell <- length(unique(as.integer(w)))
  if (ncell != 2L) {
    stop("w_operator_residual: the weighted layer is BINARY-ONLY (L = 2); got ",
         ncell, " cells. Generalizing it is an estimator decision, not a ",
         "typing fix. Author call.")
  }
  wt <- w_wt_for(u)
  n  <- length(u)
  if (is.null(hu)) hu <- 1.059 * wsd(u, wt) * length(u)^(-1 / 16)
  fu <- ker_dens(u, u, hu, order, wt = wt)
  wbar <- wmean(w, wt)
  scal <- wbar * (1 - wbar)
  if (!is.finite(scal) || scal <= 0) {
    stop("w_operator_residual: W is degenerate under these weights.")
  }
  wtil <- if (is.null(rho)) w - wbar else w - rho
  wtil <- wtil - wmean(wtil, wt)     # see operator_residual(); weighted mean
  ## Weighted Wtilde-residual.  At unit weights and rho = NULL this reduces to
  ## the pooled cell contrast F1 - F0 exactly, which is what
  ## verify_weighted_layer() checks.
  Ku <- K_order(outer(u, u, "-") / hu, order)
  aw <- if (adj_wtil) wtil / scal else 1
  ## delta-hat_n under the weighted measure.  T-hat is now a WEIGHTED mean over
  ## j, so its sampling variance carries the effective sample size
  ## (sum wt)^2 / sum wt^2 rather than n, and the aggregation over i is the same
  ## weighted one residual_norm() applies to `err` -- the two have to be in one
  ## norm or the discrepancy stop compares unlike things.
  K2 <- Ku^2
  n_eff <- sum(wt)^2 / sum(wt^2)
  ## ------------------------------------------------------------------------
  ## abs(fu), NOT fu.  ALIGNED WITH THE BASE 2026-08-11.
  ##
  ## Both `adjw` lines below carried a BARE `fu` where the base engine writes
  ## `abs(fu)` (lf_panel.R, operator_residual(): `abs(fu) * ...`).  The order-8
  ## kernel is a HIGHER-ORDER kernel and takes negative values, so the density
  ## estimate can be negative and the two expressions are not the same function.
  ##
  ## LATENT ON THE FULL SAMPLE, LIVE UNDER THE WEIGHTS -- which is where this
  ## function runs.  Measured on the Section 6 residuals: at unit weights fu is
  ## strictly positive at every kernel order (min +1.38e-2 at order 8), but
  ## under design M's own Exp(1) multipliers it goes negative -- 19 negative
  ## values over 200 draws x 983 observations, worst -6.77e-3.
  ##
  ## AND THE FIX IS NUMERICALLY INERT, WHICH IS WHY IT IS SAFE TO APPLY RATHER
  ## THAN MERELY DOCUMENT.  `adjw` is consumed by exactly one caller,
  ## lf_solve()'s `operator_norm2(op, weight = r0$adjw)`.  That norm is the
  ## spectral norm of W A A* W with W = diag(adjw), and |W| = S W for the
  ## involution S = diag(sign(adjw)) gives S (W A A* W) S -- a similarity
  ## transform, hence the SAME spectrum.  Measured on the panel's own operator
  ## with 1, 5, 19 and 50 entries forced negative: the two norms agree to a
  ## relative 1e-15, and the induced Landweber step 1/||A||^2 agrees to twelve
  ## decimals.  So this closes an inconsistency between the mirror and the base
  ## without moving a number.
  ## ------------------------------------------------------------------------
  if (is.null(bier)) {
    err <- as.vector(Ku %*% (wt * wtil)) / (sum(wt) * scal)
    comperr <- aw * fu * err
    adjw <- abs(aw) * abs(fu)
    m2 <- as.vector(K2 %*% (wt * wtil^2)) / (sum(wt) * scal^2)
    noise <- sqrt(max(mean(wt * pmax(m2 - err^2, 0)), 0) / n_eff)
  } else {
    Wt <- bier$Wt; pit <- bier$pi_t
    stopifnot(nrow(Wt) == n, length(pit) == ncol(Wt))
    err_m <- (Ku %*% (wt * wtil * Wt)) / (sum(wt) * scal)
    comperr <- aw * fu * as.vector(rowSums(sweep(err_m * Wt, 2, pit, "*")))
    ## `err` STAYS THE n x n_t MATRIX, as in the base engine.  Contracting it
    ## over t here -- which this mirror did until 2026-08-07 -- silently
    ## switched residual_norm() from the L^2(Pi) norm to the norm of the
    ## Pi-AVERAGE of T-hat.  By Jensen that is strictly smaller, and it can be
    ## zero while T-hat(.,t) is nonzero at every t, positive and negative parts
    ## cancelling across the family.  Ruling that out is the entire reason the
    ## Bierens family is there.  Latent while phi_second_stage() passed no
    ## family; live the moment it does.
    err <- err_m
    ## abs(fu): see the note above the `if`.
    adjw <- abs(aw) * abs(fu) *
      sqrt(as.vector(rowSums(sweep(Wt^2, 2, pit, "*"))))
    m2 <- (K2 %*% (wt * wtil^2 * Wt^2)) / (sum(wt) * scal^2)
    noise <- sqrt(sum(colMeans(wt * pmax(m2 - err_m^2, 0)) * pit) / n_eff)
  }
  # `err` carries sqrt(w) so that lf_solve's discrepancy is the
  # L^2(P-hat_n^w) one; `comperr` does NOT, because its weighting
  # happens inside apply_adjoint's average.  See the header.
  ## `pi_w` and `L` are returned for RETURN-FIELD parity with the base, which
  ## make_weighted_env()'s contract check enforces separately from the argument
  ## check (`miss <- setdiff(names(a), names(b))`).  Both are facts about the
  ## instrument rather than choices: at L = 2 the base's Pi_w is the scalar 1,
  ## because rep(1/(L-1), L-1) is rep(1, 1) there.  Restoring the signature
  ## without these would have traded the argument error for a return error.
  ##
  ## `wtil` IS STILL A VECTOR HERE AND AN n x (L-1) MATRIX IN THE BASE.  Left
  ## alone deliberately: it is returned by both and consumed by neither (checked
  ## 2026-08-11 -- lf_solve() reads comperr, noise and adjw only, and no other
  ## caller reads the field at all), so aligning it is cosmetic, and the scope of
  ## this repair is signature parity with no behaviour change.  Recorded rather
  ## than fixed so the next reader does not have to re-derive that it is inert.
  list(err = sqrt(wt) * err, comperr = comperr, fu = fu, hu = hu,
       err_raw = err, wtil = wtil, adjw = adjw, noise = noise,
       pi_w = 1, L = 2L,
       pi_t = if (is.null(bier)) NULL else bier$pi_t)
}

w_indep_criterion <- function(u, v, w) {
  stop("weighted layer: indep_criterion is not weighted. It is reached only ",
       "when lf_solve(track_cfun = TRUE), which is off the design-M path.")
}

w_init_control <- function(y, x1, x2, Z, w, op, nq = 100) {
  wt <- w_wt_for(y)
  dx <- x2 - x1
  Q <- cbind(w, Z)
  probs <- seq(0.05, 0.95, length.out = nq)
  fitq <- suppressWarnings(quantreg::rq(dx ~ Q - 1, tau = probs, weights = wt))
  pred <- Q %*% coef(fitq)
  # rowMeans here averages over the nq QUANTILE LEVELS, not over observations,
  # so it is correctly unweighted.
  Vhat <- min(probs) + (1 - 2 * min(probs)) * rowMeans(pred <= dx)
  X12V <- cbind(x1, x2, Vhat)
  hZ <- apply(X12V, 2, bw_rot, power = -1 / 7)
  resid_np <- function(v) v - ll_reg_multi(X12V, v, X12V, hZ)$fit
  Zt <- apply(Z[, -1, drop = FALSE], 2, resid_np)
  yt <- resid_np(y)
  g <- stats::lm.wfit(as.matrix(Zt), yt, wt)$coefficients
  g[!is.finite(g)] <- 0
  theta0 <- c(wmean(as.vector(y - Z[, -1, drop = FALSE] %*% g), wt), g)
  r <- as.vector(y - Z %*% theta0)
  d1 <- ll_reg(x1, r, x1, op$bw1)$der
  d2 <- ll_reg(x2, r, x2, op$bw2)$der
  dev <- 0.5 * ll_reg(x1, r, op$xeval, op$bw1)$der +
         0.5 * ll_reg(x2, r, op$xeval, op$bw2)$der
  list(d1 = d1, d2 = d2, dev = dev, theta = as.vector(theta0), V = Vhat)
}

# ---- the private environment ------------------------------------------------

#' The set of names replaced inside the private environment.
#'
#' Every entry must ALREADY EXIST in the sourced environment; a typo would
#' otherwise install a dead function and leave the original average unweighted.
#' varrho-hat under the weighted empirical measure.
#'
#' phi_second_stage() estimates the propensity on the whole sample (it is the
#' plug-in stage of prp:plugin, not the orthogonal moment).  Under a bootstrap
#' weight the nuisance has to be re-estimated in the SAME measure, or the band
#' holds varrho-hat fixed across replications and understates the spread by
#' exactly the nuisance's contribution.  For the pairs bootstrap the weights are
#' integer multiplicities, so glm(weights = wt) is the resampled fit exactly.
#'
#' Signature matches fit_propensity() in scripts/R/lf_panel.R.
#'
#' `with_diag` ADDED 2026-08-12, AND THIS MIRROR HAD BEEN BROKEN SINCE
#' 2026-08-11.  The base gained a `with_diag` argument when the propensity was
#' instrumented on 2026-08-11; this mirror was not updated, so
#' make_weighted_env()'s signature guard -- which exists precisely to catch
#' this -- raised on every call and STAGE 6 COULD NOT RUN AT ALL.  It went
#' unnoticed because stage 6's artifacts predate the instrumentation (their
#' checkpoint is 2026-08-08) and nothing re-ran it until the 2026-08-12
#' recalibration invalidated its cache.  The guard did its job; what was
#' missing was a run.
#'
#' The diagnostic is implemented rather than stubbed.  A stub returning no
#' attribute under `with_diag = TRUE` would satisfy the signature guard and
#' then hand summarise_prop_diag() an empty record -- the same class of silent
#' failure the base's own flat_exit() note describes.  Every mean here is the
#' WEIGHTED mean, because that is what this layer exists to substitute.
w_fit_propensity <- function(w, Z, idx_fit, idx_eval, eps = 0.03,
                             with_diag = FALSE) {
  wt <- w_wt_n(length(w))
  flat_exit <- function(route) {
    out <- rep(wmean(w[idx_fit], wt[idx_fit]), length(idx_eval))
    if (!with_diag) return(out)
    attr(out, "prop_diag") <- list(
      n_eval = length(out), L = 2L, eps = eps, route = route,
      converged = NA, n_fallback = length(out), fallback_all = TRUE,
      min_pre = min(c(out, 1 - out)), min_pre_stored = min(out),
      min_base_pre = min(1 - out), n_below_eps = sum(c(out, 1 - out) < eps),
      n_bind_rows = 0L, bind_rate = 0, max_move = 0)
    out
  }
  if (is.null(Z) || ncol(Z) == 0L) return(flat_exit("wmean-no-Z"))
  Zf <- as.matrix(Z)[idx_fit, , drop = FALSE]
  keep <- apply(Zf, 2, function(z) stats::sd(z) > 0)
  if (!any(keep)) return(flat_exit("wmean-no-variation"))
  Zf <- Zf[, keep, drop = FALSE]
  Ze <- as.matrix(Z)[idx_eval, keep, drop = FALSE]
  df <- data.frame(.w = w[idx_fit], Zf)
  g <- suppressWarnings(
    stats::glm(.w ~ ., data = df, family = stats::quasibinomial(),
               weights = wt[idx_fit]))
  p <- suppressWarnings(
    stats::predict(g, newdata = data.frame(Ze), type = "response"))
  p <- as.vector(p)
  bad <- !is.finite(p)
  if (any(bad)) p[bad] <- wmean(w[idx_fit], wt[idx_fit])
  out <- pmin(pmax(p, eps), 1 - eps)
  if (!with_diag) return(out)
  attr(out, "prop_diag") <- list(
    n_eval = length(p), L = 2L, eps = eps, route = "glm-weighted",
    converged = isTRUE(g$converged), n_fallback = sum(bad),
    fallback_all = FALSE,
    min_pre = min(c(p, 1 - p)), min_pre_stored = min(p),
    min_base_pre = min(1 - p),
    n_below_eps = sum(c(p, 1 - p) < eps),
    n_bind_rows = sum(abs(out - p) > 1e-12),
    bind_rate = mean(abs(out - p) > 1e-12),
    max_move = max(abs(out - p)))
  out
}

#' varrho-hat under the weighted empirical measure, at L CATEGORIES.
#'
#' ---------------------------------------------------------------------------
#' ADDED 2026-08-12, AND ITS ABSENCE WOULD HAVE BEEN SILENT.
#'
#' WEIGHTED_OVERRIDES rebinds `fit_propensity`, the BINARY wrapper.  Until
#' 2026-08-12 that was the only propensity any full-sample entry point could
#' reach, because conditional_parts() called it at every cardinality -- so the
#' binary override was complete by accident.  Now that conditional_parts()
#' dispatches to fit_propensity_multi() at L >= 3, an un-overridden
#' fit_propensity_multi() would be reached through `env`'s parent, the GLOBAL
#' environment, and would fit the propensity on the UNWEIGHTED sample while
#' every other moment in the iteration is weighted.
#'
#' That failure has no symptom: no error, no warning, a curve that looks like a
#' curve.  It would understate the multiplier band by exactly the nuisance's
#' contribution -- which is the very quantity the base's own note says this
#' layer exists to avoid understating -- and stage 6's whole output is a
#' comparison of that band against the pairs band.
#'
#' nnet::multinom() takes `weights` and, like glm(), treats them as frequency
#' weights, which is what the pairs bootstrap's integer multiplicities are and
#' what the Exp(1) multiplier weights are the continuous analogue of.
#'
#' Signature matches fit_propensity_multi() in scripts/R/lf_panel.R; the
#' contract check in make_weighted_env() enforces that.
w_fit_propensity_multi <- function(w, Z, idx_fit, idx_eval, eps = 0.03,
                                   cells = NULL) {
  wt <- w_wt_n(length(w))
  if (is.null(cells)) cells <- sort(unique(as.integer(w)))
  L <- length(cells)
  if (L < 2L) stop("w_fit_propensity_multi: W is degenerate, one cell only.")
  wf <- as.integer(w)[idx_fit]
  wtf <- wt[idx_fit]
  ne <- length(idx_eval)
  ## The d_Z = 0 fallback is the WEIGHTED cell shares, which are varrho when
  ## there are no controls.
  shares <- vapply(cells[-1], function(k) wmean(as.numeric(wf == k), wtf),
                   numeric(1))
  flat <- matrix(rep(shares, each = ne), ne, L - 1L)
  if (is.null(Z) || ncol(as.matrix(Z)) == 0L) {
    return(with_prop_diag(project_trunset(flat, eps), flat, eps, L,
                          route = "wshares-no-Z", converged = NA,
                          n_fallback = ne * (L - 1L), fallback_all = TRUE))
  }
  Zf <- as.matrix(Z)[idx_fit, , drop = FALSE]
  keep <- apply(Zf, 2, function(z) stats::sd(z) > 0)
  if (!any(keep)) {
    return(with_prop_diag(project_trunset(flat, eps), flat, eps, L,
                          route = "wshares-no-variation", converged = NA,
                          n_fallback = ne * (L - 1L), fallback_all = TRUE))
  }
  Zf <- Zf[, keep, drop = FALSE]
  Ze <- as.matrix(Z)[idx_eval, keep, drop = FALSE]
  conv <- NA
  fit <- tryCatch({
    if (L == 2L) {
      ## Binary: quasibinomial, so this branch is w_fit_propensity()'s exactly.
      g <- suppressWarnings(stats::glm(
        .w ~ ., data = data.frame(.w = as.numeric(wf == cells[2]), Zf),
        family = stats::quasibinomial(), weights = wtf))
      list(P = matrix(as.vector(suppressWarnings(
             stats::predict(g, newdata = data.frame(Ze), type = "response"))),
             ne, 1L),
           converged = isTRUE(g$converged), route = "glm-weighted")
    } else {
      if (!requireNamespace("nnet", quietly = TRUE)) {
        stop("w_fit_propensity_multi: package 'nnet' is required at L >= 3.")
      }
      g <- nnet::multinom(.w ~ .,
                          data = data.frame(.w = factor(wf, levels = cells),
                                            Zf),
                          weights = wtf, trace = FALSE, maxit = 500L)
      pr <- stats::predict(g, newdata = data.frame(Ze), type = "probs")
      list(P = as.matrix(pr)[, -1L, drop = FALSE],
           converged = identical(as.integer(g$convergence), 0L),
           route = "multinom-weighted")
    }
  }, error = function(e) NULL)
  fallback_all <- is.null(fit) || !is.matrix(fit$P) || ncol(fit$P) != L - 1L
  if (fallback_all) {
    P <- flat
    route <- "wshares-fit-failed"
  } else {
    P <- fit$P
    conv <- fit$converged
    route <- fit$route
  }
  bad <- !is.finite(P)
  n_fallback <- sum(bad)
  if (n_fallback > 0L) P[bad] <- flat[bad]
  with_prop_diag(project_trunset(P, eps), P, eps, L, route = route,
                 converged = conv,
                 n_fallback = if (fallback_all) ne * (L - 1L) else n_fallback,
                 fallback_all = fallback_all)
}

#' Re-locate Delta phi under the weighted empirical measure.
#'
#' The mean that pins E[phi(X2)] - E[phi(X1)] is a mean under the SAME measure
#' the rest of the layer uses; taking it unweighted would locate the residual by
#' the unweighted sample while every other moment in the iteration is weighted.
#' Signature matches locate_dphi() in scripts/R/lf_panel.R.
w_locate_dphi <- function(dphi, y, Z, theta) {
  wt <- w_wt_for(dphi)
  dphi + wmean(as.vector(y - Z %*% theta) - dphi, wt)
}

#' Asserted in make_weighted_env().
WEIGHTED_OVERRIDES <- c(
  fit_propensity    = "w_fit_propensity",
  ## REGISTERED 2026-08-12 with the L >= 3 phi-step.  Omitting it would leave
  ## conditional_parts()'s L >= 3 branch resolving to the GLOBAL, unweighted
  ## fit_propensity_multi() -- silently, and understating the band by the
  ## nuisance's contribution.  See w_fit_propensity_multi().
  fit_propensity_multi = "w_fit_propensity_multi",
  locate_dphi       = "w_locate_dphi",
  bw_rot            = "w_bw_rot",
  ker_dens          = "w_ker_dens",
  ker_dist          = "w_ker_dist",
  ll_reg            = "w_ll_reg",
  ll_reg_multi      = "w_ll_reg_multi",
  survival_matrix   = "w_survival_matrix",
  integrate_centre  = "w_integrate_centre",
  apply_adjoint     = "w_apply_adjoint",
  operator_norm2    = "w_operator_norm2",
  operator_residual = "w_operator_residual",
  indep_criterion   = "w_indep_criterion",
  init_control      = "w_init_control"
)

#' Build the private environment holding the weighted estimator.
#'
#' scripts/R/lf_panel.R and scripts/R/orthogonal_theta.R are read from disk and
#' evaluated here; neither file is modified, so design C0's cache fingerprint
#' is untouched.
#'
#' @return an environment whose parent is the global environment.
make_weighted_env <- function() {
  env <- new.env(parent = globalenv())
  sys.source(here::here("scripts", "R", "lf_panel.R"), envir = env)
  sys.source(here::here("scripts", "R", "orthogonal_theta.R"), envir = env)

  missing <- setdiff(names(WEIGHTED_OVERRIDES), ls(env))
  if (length(missing)) {
    stop(sprintf("weighted layer: %s not found in the estimator source",
                 paste(missing, collapse = ", ")))
  }

  for (nm in names(WEIGHTED_OVERRIDES)) {
    fn <- get(WEIGHTED_OVERRIDES[[nm]], envir = environment())
    environment(fn) <- env
    assign(nm, fn, envir = env)
  }
  # The helpers the overrides call, rebound the same way.  w_wt_n() in
  # particular MUST live in `env`: it reads `.wts` by lexical scoping, so a
  # copy left in the global environment would look for the weights there, find
  # nothing, and take down the replication.
  for (nm in c("w_wt_n", "w_wt_for", "wmean", "wsd")) {
    fn <- get(nm, envir = environment())
    environment(fn) <- env
    assign(nm, fn, envir = env)
  }
  assign(".wts", NULL, envir = env)

  ## CONTRACT CHECK.  Twice now this mirror has drifted from the base engine and
  ## taken down a multi-hour run at the point of use rather than at load: once
  ## when the base gained rho / bier / adj_wtil ("unused arguments", after stage
  ## 5 had spent four hours), and once when it gained `noise` for the
  ## discrepancy stop ("replacement has length zero", after stage 5 had spent
  ## fifty minutes).  Both were the same defect, and both were detectable in a
  ## millisecond.  So the mirror's ARGUMENTS and RETURNED FIELDS are now checked
  ## against the base's, here, on a tiny synthetic input, every time the layer
  ## is built.
  for (nm in names(WEIGHTED_OVERRIDES)) {
    base <- get(nm, envir = globalenv())
    mirr <- get(nm, envir = env)
    ## The mirror may ADD arguments the base does not have -- w_ker_dens() takes
    ## a `wt` the base has no use for -- but it must accept every argument the
    ## base accepts, under the same name and in the same order.  Losing one is
    ## the failure this check exists for; gaining one is by design.
    fb <- names(formals(base)); fm <- names(formals(mirr))
    if (!all(fb %in% fm) || !identical(fb, fm[fm %in% fb])) {
      stop(sprintf(paste0("weighted layer: %s() has arguments (%s), which do not ",
                          "cover the base's (%s) in order.  Update the mirror."),
                   nm, paste(fm, collapse = ", "), paste(fb, collapse = ", ")))
    }
  }
  local({
    set.seed(1L); m <- 40L
    u <- stats::rnorm(m); ww <- as.numeric(seq_len(m) %% 2L)
    zz <- matrix(stats::rnorm(m * 2L), m, 2L)
    bb <- make_bierens(zz, n_t = 3L, seed = 1L, scale = 0.25)
    rr <- rep(0.5, m)
    assign(".wts", rep(1, m), envir = env)
    on.exit(assign(".wts", NULL, envir = env), add = TRUE)
    for (args in list(list(rho = NULL, bier = NULL,  adj_wtil = FALSE),
                      list(rho = rr,   bier = bb,    adj_wtil = TRUE))) {
      a <- do.call(operator_residual, c(list(u, ww), args))
      b <- do.call(env$operator_residual, c(list(u, ww), args))
      miss <- setdiff(names(a), names(b))
      if (length(miss)) {
        stop(sprintf(paste0("weighted layer: operator_residual() returns %s but ",
                            "the mirror does not.  Update the mirror."),
                     paste(miss, collapse = ", ")))
      }
      ## At unit weights the mirror must BE the base, not merely resemble it.
      for (f in c("err", "comperr", "adjw", "noise")) {
        if (!isTRUE(all.equal(a[[f]], b[[f]], tolerance = 1e-10))) {
          stop(sprintf(paste0("weighted layer: operator_residual()$%s differs ",
                              "from the mirror at UNIT weights."), f))
        }
      }
    }
  })
  env
}

# ---- public entry point -----------------------------------------------------

#' The plug-in second stage under the weighted empirical measure.
#'
#' Calls the UNMODIFIED phi_second_stage() from scripts/R/orthogonal_theta.R
#' inside `env`, where the empirical-average primitives have been replaced by
#' their weighted versions.
#'
#' @param env environment. Output of make_weighted_env().
#' @param y,x1,x2,Z,w model objects; Z has the intercept in column 1.
#' @param theta numeric. Held fixed (prp:plugin second stage).
#' @param wts numeric. Observation weights, length n. Normalised to mean one
#'   internally; the layer is exactly invariant to their scale.
#' @param cste numeric or NULL. Landweber step; NULL sets it from the weighted
#'   operator norm.
#' @param xeval numeric. Evaluation grid, required (the default in
#'   phi_second_stage() uses unweighted quantiles).
#' @param lf_imax integer. Iteration cap.
#' @return named list: dev, phiev, xeval, u, iter.
## `tau_dp` THREADED 2026-08-12.  This wrapper did not pass one, so it took
## phi_second_stage()'s default of 0.7 -- and after the application moved to
## TAU_DP = 0 (app_tsp_common.R C26) that made the MULTIPLIER arm run a
## different stopping rule from the PAIRS arm it exists to be compared against.
## Stage 6's whole output is that comparison, so the difference would have been
## read as a property of the resampling scheme when it was a property of the
## configuration: with the default still in force the multiplier band showed
## 7.1% of replications at m = 1 against C0's 0.0%, and V1 "failed" on it.
## `eps_rho` AND `cells` THREADED 2026-08-12 with the L >= 3 phi-step.
## eps_rho was hardcoded to EPS_RHO here, which is the BINARY level (C24); at
## L >= 3 the application's level is EPS_LOCALISE (C27, and eps_for() in
## app_tsp_common.R), so a hardcoded 0.03 would have made the multiplier arm run
## a different truncation from the pairs arm it exists to be compared against --
## the same defect class as the tau_dp note above, which is why both are now
## arguments with the application's own defaults.
## `cells` matters MORE here than anywhere else: the multiplier weights are
## continuous, so no observation is ever deleted and the realised cell set is
## always complete -- but the SUBSAMPLE arm and the pairs arm do delete
## observations, and passing the full-sample cell set is what makes all three
## arms the same estimator.
phi_second_stage_weighted <- function(env, y, x1, x2, Z, w, theta, wts,
                                      cste = NULL, xeval, lf_imax,
                                      tau_dp = TAU_DP, eps_rho = NULL,
                                      cells = NULL) {
  stopifnot(is.environment(env), length(wts) == length(y),
            all(is.finite(wts)), all(wts >= 0), sum(wts) > 0,
            !missing(xeval), length(xeval) > 1L)
  if (is.null(eps_rho)) eps_rho <- eps_for(w)
  assign(".wts", wts * (length(wts) / sum(wts)), envir = env)
  on.exit(assign(".wts", NULL, envir = env), add = TRUE)
  # phi_second_stage() always calls lf_solve(theta_mode = "fixed"), so the
  # unweighted lm.fit() in the "alternate" branch is unreachable.  Asserted
  # rather than assumed.
  stopifnot(any(grepl("theta_mode = \"fixed\"",
                      deparse(env$phi_second_stage))))
  env$phi_second_stage(y, x1, x2, Z, w, theta, cste = cste,
                       init_fn = env$init_control, xeval = xeval,
                       lf_imax = lf_imax, tau_dp = tau_dp,
                       eps_rho = eps_rho, n_t = N_T, bier_seed = BIER_SEED,
                       t_scale = T_SCALE, adj_wtil = ADJ_WTIL,
                       conditional = TRUE, cells = cells)
}

# ---- verification -----------------------------------------------------------

#' Check the weighted layer against the untouched estimator.
#'
#' Three properties, each a hard assertion:
#'   1. UNIT WEIGHTS.  At w == 1 the layer must reproduce phi_second_stage()
#'      from the global environment.  Agreement is to numerical tolerance, not
#'      bit-for-bit: `A %*% w` accumulates in BLAS where rowMeans() accumulates
#'      in long double, and lm.wfit() differs from lm.fit() in the same way.
#'   2. SCALE INVARIANCE.  Multiplying every weight by a constant must leave
#'      the curve unchanged, which demonstrates that the normalisation
#'      convention is immaterial instead of asserting it.
#'   3. WEIGHTS BITE.  A non-degenerate weight vector must move the curve;
#'      otherwise the layer is silently ignoring `.wts`.
#'
#' @param env environment. Output of make_weighted_env().
#' @param y,x1,x2,Z,w,theta,xeval,lf_imax as in phi_second_stage_weighted().
#' @param stream integer vector or NULL. L'Ecuyer anchor; every arm is run from
#'   the same one so the single rnorm() draw inside operator_norm2() matches.
#' @param tol numeric(1). Tolerance for property 1.
#' @return named list: dev_unit, dev_scale, dev_bite, m_unit, m_ref.
verify_weighted_layer <- function(env, y, x1, x2, Z, w, theta, xeval, lf_imax,
                                  stream = NULL, tol = 1e-8,
                                  eps_rho = NULL, cells = NULL) {
  n <- length(y)
  ## The reference and every arm must run the SAME truncation and the SAME cell
  ## set, for the reason the tau_dp note gives: a reference configured
  ## differently from the arms it is compared against fails the comparison for a
  ## reason that has nothing to do with the weighting.
  if (is.null(eps_rho)) eps_rho <- eps_for(w)
  if (is.null(cells)) cells <- sort(unique(as.integer(w)))
  set_stream <- function() {
    if (!is.null(stream)) assign(".Random.seed", stream, envir = globalenv())
  }

  # Property 3 of the scalar helpers, checked first because it is instant.
  probe <- stats::rnorm(64L)
  stopifnot(abs(wsd(probe, rep(1, 64L)) - stats::sd(probe)) < 1e-12,
            abs(wmedian(probe, rep(1, 64L)) - stats::median(probe)) < 1e-12)

  set_stream()
  ## The reference runs the SAME conditional configuration the weighted arms
  ## do (C21-C25).  Until 2026-08-07 all four arms here ran bier = NULL,
  ## rho = NULL, adj_wtil = FALSE, so the layer's verification covered only the
  ## superseded path -- including the err-contraction bug below it.
  ## `tau_dp = TAU_DP` on the reference too, ADDED 2026-08-12.  The whole point
  ## of this function is that the weighted layer at unit weights reproduces the
  ## unweighted reference; a reference on a different stopping rule from the
  ## arms it is compared against would fail the comparison for a reason that
  ## has nothing to do with the weighting.
  ref <- phi_second_stage(y, x1, x2, Z, w, theta, cste = LF_CSTE,
                          init_fn = init_control, xeval = xeval,
                          lf_imax = lf_imax, tau_dp = TAU_DP,
                          eps_rho = eps_rho, n_t = N_T, bier_seed = BIER_SEED,
                          t_scale = T_SCALE, adj_wtil = ADJ_WTIL,
                          conditional = TRUE, cells = cells)
  set_stream()
  one <- phi_second_stage_weighted(env, y, x1, x2, Z, w, theta,
                                   wts = rep(1, n), cste = LF_CSTE,
                                   xeval = xeval, lf_imax = lf_imax,
                                   eps_rho = eps_rho, cells = cells)
  set_stream()
  two <- phi_second_stage_weighted(env, y, x1, x2, Z, w, theta,
                                   wts = rep(2, n), cste = LF_CSTE,
                                   xeval = xeval, lf_imax = lf_imax,
                                   eps_rho = eps_rho, cells = cells)
  wb <- rep(1, n)
  wb[seq_len(n %/% 2L)] <- 1.5
  wb[(n %/% 2L + 1L):n] <- 0.5
  set_stream()
  bite <- phi_second_stage_weighted(env, y, x1, x2, Z, w, theta, wts = wb,
                                    cste = LF_CSTE, xeval = xeval,
                                    lf_imax = lf_imax, eps_rho = eps_rho,
                                    cells = cells)

  dev_unit <- max(abs(as.vector(one$phiev) - as.vector(ref$phiev)))
  dev_scale <- max(abs(as.vector(two$phiev) - as.vector(one$phiev)))
  dev_bite <- max(abs(as.vector(bite$phiev) - as.vector(one$phiev)))

  stopifnot(dev_unit < tol, one$iter == ref$iter)
  stopifnot(dev_scale < 1e-12)
  stopifnot(dev_bite > 1e-6)

  list(dev_unit = dev_unit, dev_scale = dev_scale, dev_bite = dev_bite,
       m_unit = as.integer(one$iter), m_ref = as.integer(ref$iter))
}
