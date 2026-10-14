## ---------------------------------------------------------------------------
## app_tsp_09_boundary.R -- C3's x-DIRECTION KERNEL, MEASURED.
##
## WHAT THIS STAGE IS FOR.  C3 closes "the same three conditions with the same
## p_K apply to the kernel C_{h_x} used in the x-direction", i.e. eq:truncmom at
## p_K = 8.  The application has held that at three different orders in as many
## days and this stage is where each is a MEASUREMENT rather than a claim:
##
##   (i)   NO ADJUSTMENT, until 2026-08-14.  The kernel was the untruncated
##         Gaussian, so even the j = 0 moment failed -- 0.5000 at the extreme
##         design points -- and prp:hatAprop(iii) failed with it.
##   (ii)  RENORMALISED, 2026-08-14 to 2026-08-15.  The Monte Carlo's design
##         decision D11 (sim_thm_rootn_phistep.R:63-71),
##         C_{h_x}(x - X) / int_X C_{h_x}(y - X) dy, which enforces j = 0
##         EXACTLY and no higher moment, at ORDER 2 -- and at order 2 by
##         accident: survival_matrix() had no `order` argument at all, and
##         make_operator() passed xsupp by NAME into ker_dens()'s fourth
##         POSITIONAL slot, which is `order`, leaving it at 2L.
##   (iii) C3'S FAMILY, from 2026-08-15.  lem:bdryfam's eq:gramfam member at
##         p_K = 8: one 8x8 Gram solve per design point, all eight truncated
##         moments exact at EVERY design point, interior and boundary.
##
## Panel A is the acceptance test and it is reported per j, over all 1,966
## design points, for all three kernels.  It is the table that says which
## moments each kernel actually kills, which is the question C3 asks.
##
## THE OBSERVABLE OF prp:hatAprop(iii).  The clause is
##     int_X nu-hat_{u,t,l}(x) dx = 0  for every (u,t,l),
## hence A-hat*_varphi Xi in cal-V for every Xi in L^2(Pi).  This engine works in
## the DERIVATIVE parameterisation, where apply_adjoint() forms
##     nu-hat^der(v) = (1/n) sum_i (g_i - gbar) { S(v; X_i2) - S(v; X_i1) }
## and eq:hatnu's level-space nu-hat is -d/dv of it, so
##     int_X nu-hat dx = nu-hat^der(lo) - nu-hat^der(hi),
## exactly computable from two extra survival rows.  `g` is the CONTRACTED
## residual comperr, i.e. Xi already paired against Pi, so what is reported is
## the cal-V-membership of the realised A-hat* Xi and not of a sufficient
## condition for it.  It is exactly zero under (ii) AND under (iii): both fix
## the j = 0 moment, which is the only moment that clause reads.
##
## WHAT THE FAMILY BUYS IS NOT THAT CLAUSE, THEN, AND THE TABLE SHOULD NOT BE
## READ AS IF IT WERE.  It is that the x-smoothing bias (P-g) charges,
## R h_x^{s-1/2}, now applies at every design point instead of only away from
## the boundary layer -- a layer this design puts 31% of its design points in.
## NOT h_x^{p_K}: p_K is the BUDGET LINE p_K >= s - 1/2 of lem:unifop Step 4,
## not the exponent (assumptions_supp.tex:2110ff).
##
## TWO NEW PANELS, AND THE FIRST IS THE ONE THAT COULD HAVE BROKEN SILENTLY.
## Panel F audits the SIGN: an order-8 Theta_I is sign-indefinite, so the
## survival S(v; X) is no longer monotone and no longer lies in [0, 1].  Panel G
## asserts the u-direction is bit-for-bit unchanged, which is the other half of
## "this edit is confined to the x-direction".
##
## THE ABLATION.  Every curve at every cardinality moves under this change, which
## is expected and is what the theory says a boundary correction does.  What must
## NOT move is anything the x-kernel cannot reach, and that is checked rather
## than argued: the propensity is a function of (W, Delta Z, fold indices) alone
## and never sees C_{h_x}, so its cross-fitted binding rate, evaluation count and
## pre-projection minimum must be BIT-FOR-BIT identical across the two arms.
##
## ---------------------------------------------------------------------------
## PANEL E'S TWO PROPENSITY ROWS ARE DRAWS, AND UNTIL 2026-08-15 THE TABLE DID
## NOT SAY SO.  A writer-critic read Panel E's 0.7322% binding rate and 2.5e-05
## pre-projection minimum against the SAME TWO STATISTICS in the headline
## theta-hat table, which report 0.997% and 4.3e-05 at a configuration both
## tables label d_Z = 5, L = 4.  One design, described twice, two answers.
##
## MEASURED, NOT ARGUED (2026-08-15).  Calling fit_orthogonal() with ONE argument
## list and only the RNG anchor varied returns
##     set.seed(SEED_BOUNDARY)  -> 0.7322% (216/29500), min pre 2.5428e-05
##     set.seed(SEED_LOCALISE)  -> 0.9966% (294/29500), min pre 4.2929e-05
## and the second reproduces the shipped headline arm's theta-hat to the last
## printed digit.  So the two tables run the same estimator at the same eps, the
## same cap and the same instrument, on two different CROSS-FITTING FOLD DRAWS.
## Nothing disagrees; the fold draw was simply never named.
##
## WHY THIS IS LABELLED AND NOT RE-ANCHORED.  Forcing this ablation onto
## SEED_LOCALISE would make the two tables print one number, and would delete the
## fact that makes the number worth reading: over 200 independent redraws of the
## partition structure the POOLED binding rate has mean 1.00% and sd 0.19, and
## the pooled pre-projection minimum ranges over four and a half decades.  A
## single value of either is nearly uninformative without that scale, and two
## agreeing single values would be exactly as uninformative.  Panel E therefore
## names the draw and prints the law beneath each statistic, which resolves the
## reader's question -- "why two answers?" -- without a cross-reference, and
## incidentally sharpens the panel's own claim: the two engines agreeing
## BIT-FOR-BIT is a strong statement precisely because the statistic they agree
## on has an across-draw sd of 0.19 percentage points.
##
## Two further reasons the anchor stays where it is.  (i) app_tsp_run_all.R runs
## this stage BEFORE stage 8, deliberately, so that a regression in the
## adjustment reaches the log before four hours of bootstrap are spent; tying
## these arms to the later stage's seed would invert that, and the bit-for-bit
## assertion that would make re-anchoring worth its cost cannot be written here
## without the inversion.  (ii) The ablation is a PAIRED contrast -- two engines,
## one stream -- and its validity needs the two arms to share a draw, not to
## share any particular one.  That the pairing matters is itself measurable: the
## same theta-hat on the two anchors differs by up to 0.63 clustered standard
## errors, against the 0.115 that Panel D attributes to the engine change.
## ---------------------------------------------------------------------------
##
## Outputs
##   paper/tables/app_tsp_boundary.tex              (bare tabular, INV-13)
##   paper/tables/app_tsp_bdrymom.tex               (bare tabular, INV-13)
##   quality_reports/application/app_tsp_boundary.rds
## ---------------------------------------------------------------------------

suppressMessages({
  library(here)
  library(parallel)
})
source(here::here("scripts", "R", "lf_panel.R"))
source(here::here("scripts", "R", "orthogonal_theta.R"))
source(here::here("scripts", "application", "app_tsp_common.R"))

RNGkind("L'Ecuyer-CMRG")
set.seed(SEED_BOUNDARY)                                              # INV-14

## THE ABLATION'S ANCHOR, CAPTURED BEFORE ANYTHING CONSUMES THE STREAM.
##
## It is taken HERE and not after the diagnostic solves, and the reason is
## app_tsp_08_localise.R's revision note (R2): under L'Ecuyer-CMRG the parent's
## state advances once per forked job, so a stream read after some variable
## number of solves is a function of HOW MANY SOLVES RAN.  Both ablation arms
## restore this one anchor, so they are identical to each other either way -- but
## anchoring it at the top makes the arms a function of SEED_BOUNDARY alone,
## which is what makes this stage's numbers reproducible when a solve is added.
ANCHOR <- get(".Random.seed", envir = globalenv())

D_Z <- 5L                          # the application's headline control set

## Independent redraws of the CROSS-FITTING PARTITION STRUCTURE used to price
## Panel E's two draw-dependent rows.  200 puts the Monte Carlo error on the mean
## binding rate at about 0.013 percentage points, an order below the 0.19 sd it
## is estimating, and costs about 75 s on 8 cores.
B_PDREF <- 200L

## The reference block's dedicated L'Ecuyer substream, counted in hops from this
## script's one anchor.  It runs AFTER the two forked ablation arms, and
## mclapply() advances the parent's stream once per forked job under
## L'Ecuyer-CMRG, so a draw taken from the ambient state there would be a
## function of the CORE COUNT.  300 is far past the 2 x N_PART = 20 the arms
## consume and substreams are 2^127 apart.  Same device as
## app_tsp_08_localise.R's NULL_STREAM_SKIP and app_tsp_10_n1_anchor.R's
## PROP_STREAM, for the same reason.
PD_STREAM_SKIP <- 300L

OUT_ROOT <- Sys.getenv("APP_TSP_OUT_ROOT", unset = here::here())
OUT <- file.path(OUT_ROOT, "quality_reports", "application")
TAB <- file.path(OUT_ROOT, "paper", "tables")
for (d in c(OUT, TAB)) dir.create(d, showWarnings = FALSE, recursive = TRUE)

# ---- the two superseded engines, in private environments -------------------
#
# The ablation needs ALL THREE engines in one process, and the two superseded
# ones are reached by ONE default each on make_operator():
#   `xsupp = NULL`  -- no boundary index at all, the pre-2026-08-14 engine;
#   `p_K   = NULL`  -- the 2026-08-14 renormalisation, j = 0 only, order 2.
# Rebinding either in the GLOBAL environment would leave the process in a state
# where "the estimator" means different things at different lines, which is the
# failure app_tsp_run_all.R's lock exists to prevent one process-level up.  So
# each superseded engine gets its own environment, exactly as the weighted layer
# does: the three source files are evaluated into it, one default is patched
# there, and nothing outside it can see the patch.
#
# WHY THREE ARMS AND NOT TWO.  The family-vs-renormalisation contrast is what
# 2026-08-15 moved; the renormalisation-vs-none contrast is what 2026-08-14
# moved, and re-running it here is a REGRESSION TEST -- those numbers are
# already in the shipped table and must reproduce.  A change that also perturbed
# the arms it was not supposed to touch would show up as a moved Panel D
# "renormalised vs none" column and nowhere else.
#' Build a private engine environment with one make_operator() default patched.
#'
#' @param arg character(1). "xsupp" or "p_K".
#' @return environment.
make_arm_env <- function(arg) {
  stopifnot(arg %in% c("xsupp", "p_K"))
  env <- new.env(parent = globalenv())
  sys.source(here::here("scripts", "R", "lf_panel.R"), envir = env)
  sys.source(here::here("scripts", "R", "orthogonal_theta.R"), envir = env)
  sys.source(here::here("scripts", "application", "app_tsp_common.R"),
             envir = env)
  mo <- get("make_operator", envir = env)
  ## `formals(mo)[arg] <- list(NULL)`, NOT `formals(mo)[[arg]] <- NULL`.
  ## The second DELETES the formal -- assigning NULL to a list element removes
  ## it -- and the body then fails with "object not found" rather than running
  ## the patched path.  Setting the DEFAULT to NULL is the intent.
  formals(mo)[arg] <- list(NULL)
  stopifnot(arg %in% names(formals(mo)))
  environment(mo) <- env
  assign("make_operator", mo, envir = env)
  ## Assert the patch took, and that it is the ONLY difference: everything else
  ## in the file must be the file.
  op_chk <- env$make_operator(c(0.2, 0.4, 0.6), c(0.3, 0.5, 0.7), c(0.3, 0.5))
  if (arg == "xsupp" && !is.null(op_chk$xsupp)) {
    stop("arm env: make_operator() still carries a support")
  }
  if (!is.null(op_chk$p_K)) {
    stop("arm env: make_operator() still carries a kernel order")
  }
  if (!identical(deparse(env$survival_matrix), deparse(survival_matrix))) {
    stop("arm env: survival_matrix() is not the shipped one")
  }
  env
}

LEG <- make_arm_env("xsupp")     # no adjustment       (pre-2026-08-14)
REN <- make_arm_env("p_K")       # j = 0 renormalised  (2026-08-14)
message("boundary: two superseded engines built (xsupp = NULL; p_K = NULL)")

# ---- data ------------------------------------------------------------------

P  <- load_tsp_panel()
dt <- P$dt
n  <- nrow(dt)
iv <- load_tsp_w4(dt)
dt$w4 <- iv$w4
W_INST <- dt$w4
CELLS_INST <- iv$cells
EPS_INST <- eps_for(W_INST)
MBAR_INST <- lf_mbar(W_INST)

xc <- make_x_coord(dt$x1_raw, dt$x2_raw, mode = "rank")
Z  <- make_design(dt, D_Z)
y  <- dt$dy
xev <- seq(stats::quantile(c(xc$x1, xc$x2), XEVAL_LO),
           stats::quantile(c(xc$x1, xc$x2), XEVAL_HI), length.out = N_XEVAL)

op_new <- make_operator(xc$x1, xc$x2, xev)                    # C3's family
op_ren <- make_operator(xc$x1, xc$x2, xev, p_K = NULL)        # renormalised
op_old <- make_operator(xc$x1, xc$x2, xev, xsupp = NULL)      # no adjustment
XS <- op_new$xsupp
stopifnot(length(XS) == 2L, XS[2] > XS[1], is.null(op_old$xsupp),
          identical(op_new$p_K, P_K_X), is.null(op_ren$p_K),
          identical(op_ren$xsupp, XS))
message(sprintf(paste("boundary: n = %d, L = %d, eps = %.3f, m-bar = %d;",
                      "X = [%.6f, %.6f], h_x = (%.5f, %.5f), p_K = %d"),
                n, length(CELLS_INST), EPS_INST, MBAR_INST, XS[1], XS[2],
                op_new$hx[1], op_new$hx[2], P_K_X))

## THE OPERATOR IS BUILT ON THE FULL SAMPLE HERE, AND THE ESTIMATOR BUILDS IT ON
## A 40% SOLVE FOLD (crossfit_once splits the 80% complement in half).  The
## bandwidth is bw_rot, which is proportional to n^{-1/5}, so the fold's h_x is
## about 1.20 times this one and the boundary region is correspondingly WIDER
## there.  The full-sample figures below are therefore the CONSERVATIVE end of
## the defect, not the typical one; the fold's own h_x is reported beside them.
h_fold <- c(bw_rot(xc$x1[seq_len(393L)]), bw_rot(xc$x2[seq_len(393L)]))

# ---- Panel A: eq:truncmom AT EVERY j, THE ACCEPTANCE TEST -------------------
#
# int_I varsigma^j Theta_I dvarsigma - delta_{j0}, at every design point, for
# each of the three kernels, j = 0..p_K-1.  The three are computed from ONE
# closed form so that the comparison is arithmetic and not three different
# quadratures:
#
#   none    Theta = phi                       moments  M_j(b) - M_j(a)
#   renorm  Theta = phi / m_0(I)              moments  (M_j(b) - M_j(a)) / m_0
#   family  Theta = eq:gramfam                moments  bdry_moments()
#
# with M_j the Gaussian partial moments gauss_partial_moments() supplies.  The
# first two are the SAME kernel up to a scalar, so they agree at every j >= 1 up
# to that scalar; what separates them is only j = 0.
#
# THE REGION BREAKDOWN IS NOT DECORATION.  The renormalised kernel's j = 1
# moment is zero in the INTERIOR by symmetry and fails only within a few h of an
# endpoint, so a worst-over-all-points number and an interior number say
# different things, and the layer is where 31% of this design's points sit.
# "Endpoint" is a real design point here: xsupp's lower end IS the smallest
# order statistic of the pooled x, so I(x*) = [0, |X|/h] is realised, not a
# limit.

REGION_W <- 3            # boundary layer half-width, in bandwidths

x_all <- c(xc$x1, xc$x2)
h_all <- c(rep(op_new$hx[1], n), rep(op_new$hx[2], n))
d_end <- pmin(x_all - XS[1], XS[2] - x_all) / h_all      # distance in h
is_layer <- d_end <= REGION_W
is_end <- d_end <= .Machine$double.eps^0.5

#' The truncated moments of the three x-direction kernels at given centres.
#'
#' @param x numeric. Kernel centres (design points, or a synthetic ladder).
#' @param h numeric. Bandwidths, length 1 or length(x).
#' @return named list of length(x) x p_K matrices: none, renorm, family.
truncated_moments <- function(x, h) {
  p <- P_K_X
  hh <- if (length(h) == 1L) rep(h, length(x)) else h
  stopifnot(length(hh) == length(x))
  a <- (XS[1] - x) / hh
  b <- (XS[2] - x) / hh
  M <- gauss_partial_moments(b, p - 1L) - gauss_partial_moments(a, p - 1L)
  ## `none` and `renorm` share one bandwidth per point, so they are computed
  ## point-by-point only where the bandwidth changes; the family needs one call
  ## per distinct bandwidth because bdry_family() takes a scalar h.
  fam <- matrix(0, length(x), p)
  for (hv in unique(hh)) {
    k <- which(hh == hv)
    fam[k, ] <- bdry_moments(bdry_family(x[k], hv, XS, p))
  }
  list(none = M, renorm = M / M[, 1L], family = fam)
}

TM <- truncated_moments(x_all, h_all)
TGT <- c(1, rep(0, P_K_X - 1L))
dev_of <- function(M) abs(sweep(M, 2L, TGT, "-"))
DV <- lapply(TM, dev_of)

panelA <- list(
  p_K = P_K_X, region_w = REGION_W, n_points = length(x_all),
  n_layer = sum(is_layer), n_end = sum(is_end),
  worst = lapply(DV, \(D) apply(D, 2L, max)),
  worst_interior = lapply(DV,
                          \(D) apply(D[!is_layer, , drop = FALSE], 2L, max)),
  worst_layer = lapply(DV, \(D) apply(D[is_layer, , drop = FALSE], 2L, max)),
  worst_end = lapply(DV, \(D) apply(D[is_end, , drop = FALSE], 2L, max)),
  share_1pct = lapply(DV, \(D) colMeans(D > 0.01)),
  ## j = 2 gets a floor as well as a ceiling: an order-2 kernel's second moment
  ## is ONE in the interior, so the informative statement about the superseded
  ## kernels is not that the moment fails somewhere but that it fails
  ## EVERYWHERE, never coming below this number.
  min_j2 = vapply(DV, \(D) min(D[, 3L]), numeric(1)),
  h_full = op_new$hx, h_fold = h_fold)
dev_j2 <- lapply(DV, \(D) D[, 3L])
## The j = 0 column of the renormalised arm is an identity, and the family's
## whole row is a numerical residual: both are asserted so that a regression in
## the Gram solve stops the stage instead of printing a number.
stopifnot(panelA$worst$renorm[1L] < 1e-12,
          max(panelA$worst$family) < 1e-8,
          panelA$n_end >= 2L, panelA$n_layer > 0L)
message(sprintf(paste("  A. eq:truncmom over %d design points (%d in the",
                      "%d h layer, %d at an endpoint):"),
                panelA$n_points, panelA$n_layer, REGION_W, panelA$n_end))
for (j in seq_len(P_K_X)) {
  message(sprintf(paste("     j = %d  worst |dev|: none %.4g, renorm %.4g,",
                        "family %.3e   (family at the endpoint %.3e)"),
                  j - 1L, panelA$worst$none[j], panelA$worst$renorm[j],
                  panelA$worst$family[j], panelA$worst_end$family[j]))
}

## THE SYNTHETIC LADDER x_lo + k h, k = 0..3, WHICH THE DESIGN NEED NOT CONTAIN.
## The moments are a property of the INTERVAL, so they can be read at any centre
## in X whether or not a county sits there; the ladder is the clean statement of
## "how far in does the boundary layer reach", free of where the design happens
## to have put its points.
ladder_x <- XS[1] + (0:REGION_W) * op_new$hx[1]
TM_LAD <- truncated_moments(ladder_x, op_new$hx[1])
panelA$ladder <- list(k = 0:REGION_W, x = ladder_x,
                      none = dev_of(TM_LAD$none),
                      renorm = dev_of(TM_LAD$renorm),
                      family = dev_of(TM_LAD$family))

## The two exact identities of lem:intker(iv), asserted rather than described:
## S(lo; X) = 1 and S(hi; X) = 0 at EVERY design point, which is what makes
## int_X nu-hat dx vanish for EVERY residual and not merely for the realised one.
surv_ends <- function(pk) {
  lo <- n * c(survival_matrix(XS[1], xc$x1, op_new$hx[1], XS, pk),
              survival_matrix(XS[1], xc$x2, op_new$hx[2], XS, pk))
  hi <- n * c(survival_matrix(XS[2], xc$x1, op_new$hx[1], XS, pk),
              survival_matrix(XS[2], xc$x2, op_new$hx[2], XS, pk))
  c(max_dev_lo = max(abs(lo - 1)), max_dev_hi = max(abs(hi)))
}
s_fam <- surv_ends(P_K_X)
s_ren <- surv_ends(NULL)
s_none <- c(max_dev_lo = max(abs(n * c(
              survival_matrix(XS[1], xc$x1, op_old$hx[1], NULL),
              survival_matrix(XS[1], xc$x2, op_old$hx[2], NULL)) - 1)),
            max_dev_hi = max(abs(n * c(
              survival_matrix(XS[2], xc$x1, op_old$hx[1], NULL),
              survival_matrix(XS[2], xc$x2, op_old$hx[2], NULL)))))
stopifnot(s_fam[["max_dev_lo"]] < 1e-12, s_fam[["max_dev_hi"]] < 1e-12)
panelA$survival <- list(none = s_none, renorm = s_ren, family = s_fam)

# ---- Panel B: the reference density ----------------------------------------
#
# pi-hat DIVIDES in apply_adjoint(), so its positivity is not a quality
# question but an arithmetic one, and at p_K = 8 it is a real one: a
# higher-order kernel density estimate CAN go negative.  Reported on a fine
# grid, at every design point and at every evaluation point.

xg <- seq(XS[1], XS[2], length.out = 8001L)
tri <- function(g, v) sum(diff(g) * (v[-1] + v[-length(v)]) / 2)
pi_at <- function(ev, pk, sup) {
  ord <- if (is.null(pk)) 2L else pk
  0.5 * ker_dens(xc$x1, ev, op_new$bw1, ord, xsupp = sup, p_K = pk) +
    0.5 * ker_dens(xc$x2, ev, op_new$bw2, ord, xsupp = sup, p_K = pk)
}
pi_grid <- list(none = pi_at(xg, NULL, NULL), renorm = pi_at(xg, NULL, XS),
                family = pi_at(xg, P_K_X, XS))
pi_design <- list(none = pi_at(x_all, NULL, NULL),
                  renorm = pi_at(x_all, NULL, XS),
                  family = pi_at(x_all, P_K_X, XS))
pi_ev <- list(none = pi_at(xev, NULL, NULL), renorm = pi_at(xev, NULL, XS),
              family = pi_at(xev, P_K_X, XS))
panelB <- lapply(c("none", "renorm", "family"), function(k) {
  list(total = tri(xg, pi_grid[[k]]),
       min_grid = min(pi_grid[[k]]), max_grid = max(pi_grid[[k]]),
       min_design = min(pi_design[[k]]), min_xeval = min(pi_ev[[k]]),
       at_lo = pi_grid[[k]][1L], at_hi = pi_grid[[k]][length(xg)],
       at_q05 = stats::approx(xg, pi_grid[[k]], xout = xev[1])$y,
       at_q95 = stats::approx(xg, pi_grid[[k]],
                              xout = xev[length(xev)])$y)
})
names(panelB) <- c("none", "renorm", "family")
stopifnot(panelB$family$min_grid > 0, panelB$family$min_design > 0,
          panelB$family$min_xeval > 0)
message(sprintf(paste("  B. int_X pi-hat dx: %.6f / %.6f / %.6f (none /",
                      "renorm / family);  min pi-hat on the grid %.4f /",
                      "%.4f / %.4f"),
                panelB$none$total, panelB$renorm$total, panelB$family$total,
                panelB$none$min_grid, panelB$renorm$min_grid,
                panelB$family$min_grid))

# ---- Panel C: prp:hatAprop(iii)'s observable at a REALISED residual --------
#
# The residual has to be the one the estimator forms, not a synthetic vector, or
# the number is about an arbitrary direction in L^2(Pi).  So one full-sample
# second-stage solve is run under EACH engine at a common theta, and the
# contracted residual comperr is taken at the returned iterate.
#
# TWO COMPARISONS, AND THEY ANSWER DIFFERENT QUESTIONS.
#   "same g"  evaluates BOTH operators at the ADJUSTED engine's residual.  This
#             isolates the KERNEL: one vector, two operators.
#   "own g"   evaluates each engine at its own realised residual, which is what
#             each engine actually does.
# The first is the clean statement about C3(ii); the second is the statement
# about the shipped path.  Under the adjustment both are exactly zero, because
# the identity holds for every residual.

theta0 <- stats::lm.fit(Z, y)$coefficients
theta0[!is.finite(theta0)] <- 0

#' The contracted residual at the returned iterate of one second-stage solve.
#'
#' BOTH SEEDED BLOCKS GO THROUGH with_fixed_seed(), the device app_tsp_common.R
#' registers for exactly this case and the one INV-14 exception this project
#' grants itself.  Two properties are wanted and a bare set.seed() delivers only
#' the first: the two engines must see the SAME stream (so the comparison is
#' about the kernel), and the ambient stream must be left where it was (so the
#' ablation below does not silently depend on how many solves ran above it).
#' The propensity fit is re-seeded separately rather than sharing the solve's
#' stream, because the two engines need not consume randomness identically
#' inside the solve and the propensity must not inherit that difference.
#'
#' @param env environment or NULL. NULL is the shipped engine; LEG / REN the
#'   two superseded ones.
#' @return named list: op, g (comperr), iter, u, phi.
solve_residual <- function(env = NULL) {
  ps <- if (is.null(env)) phi_second_stage else env$phi_second_stage
  mo <- if (is.null(env)) make_operator else env$make_operator
  cp <- if (is.null(env)) conditional_parts else env$conditional_parts
  orr <- if (is.null(env)) operator_residual else env$operator_residual
  fit <- with_fixed_seed(SEED_BOUNDARY,
    ps(y, xc$x1, xc$x2, Z, W_INST, theta0, cste = LF_CSTE,
       init_fn = init_control, xeval = xev, lf_imax = MBAR_INST,
       eps_rho = EPS_INST, n_t = N_T, bier_seed = BIER_SEED,
       t_scale = T_SCALE, adj_wtil = ADJ_WTIL, conditional = TRUE,
       tau_dp = TAU_DP, cells = CELLS_INST))
  parts <- with_fixed_seed(SEED_BOUNDARY,
    cp(Z, W_INST, TRUE, EPS_INST, N_T, BIER_SEED, T_SCALE, ADJ_WTIL,
       cells = CELLS_INST))
  res <- orr(fit$u, W_INST, rho = parts$rho, bier = parts$bier,
             adj_wtil = parts$adj_wtil)
  list(op = mo(xc$x1, xc$x2, xev), g = res$comperr, iter = fit$iter,
       u = fit$u, phi = as.vector(fit$phiev))
}

t0 <- Sys.time()
sr_new <- solve_residual(NULL)
sr_ren <- solve_residual(REN)
sr_old <- solve_residual(LEG)
message(sprintf("  C. three second-stage solves in %.0fs (m = %d, %d, %d)",
                as.numeric(difftime(Sys.time(), t0, units = "secs")),
                sr_new$iter, sr_ren$iter, sr_old$iter))

d_same_new <- adjoint_range_defect(op_new, sr_new$g)
d_same_ren <- adjoint_range_defect(op_ren, sr_new$g)
d_same_old <- adjoint_range_defect(op_old, sr_new$g)
d_own_new  <- d_same_new
d_own_ren  <- adjoint_range_defect(op_ren, sr_ren$g)
d_own_old  <- adjoint_range_defect(op_old, sr_old$g)
panelC <- list(
  same_g = list(none = d_same_old, renorm = d_same_ren, family = d_same_new),
  own_g  = list(none = d_own_old,  renorm = d_own_ren,  family = d_own_new))
## Both adjusted arms fix the j = 0 moment, so BOTH must return exactly zero
## here; that this clause does not separate them is the point Panel A makes.
stopifnot(abs(d_same_new$int_nu) < 1e-15 * max(1, d_same_new$scale),
          abs(d_same_ren$int_nu) < 1e-15 * max(1, d_same_ren$scale))
message(sprintf(paste("     int_X nu-hat dx, SAME residual: none %+.4e (%.2f%%",
                      "of sup|nu-hat|), renorm %+.4e, family %+.4e"),
                d_same_old$int_nu, 100 * d_same_old$rel,
                d_same_ren$int_nu, d_same_new$int_nu))
message(sprintf(paste("     phi-hat from the full-sample second stage:",
                      "sup|family - renorm| = %.5f, interior %.5f;",
                      "range of phi-hat %.4f"),
                max(abs(sr_new$phi - sr_ren$phi)),
                max(abs((sr_new$phi - sr_ren$phi)[
                  xev > XS[1] + REGION_W * op_new$hx[1] &
                    xev < XS[2] - REGION_W * op_new$hx[2]])),
                diff(range(sr_new$phi))))
panelC$phi_second <- list(
  none = sr_old$phi, renorm = sr_ren$phi, family = sr_new$phi, xeval = xev,
  sup_fam_ren = max(abs(sr_new$phi - sr_ren$phi)),
  sup_fam_none = max(abs(sr_new$phi - sr_old$phi)),
  range_family = diff(range(sr_new$phi)))

# ---- Panel D: the ablation -------------------------------------------------
#
# theta-hat and phi-hat at the headline configuration under both engines, on
# IDENTICAL partition streams.  This is what moved, and it is separated from the
# common-cap change of stage 8 by construction: both arms here run at MBAR_INST.
#
# ANCHOR is the one captured at the top of this file, before any solve consumed
# the stream; it is not re-read here.

#' phi-hat on the evaluation grid from a fit_orthogonal() return.
#'
#' @param f list. fit_orthogonal() output.
#' @return numeric, length(f$xeval), centred.
phi_of <- function(f) {
  M <- vapply(f$fits, function(b) {
    rowMeans(vapply(b$dev, function(pp) cumtrapz_centre(f$xeval, pp$dev),
                    numeric(length(f$xeval))))
  }, numeric(length(f$xeval)))
  p <- rowMeans(M)
  p - mean(p)
}

#' One ablation arm.
#'
#' @param env environment or NULL. NULL is the shipped engine.
#' @param label character. Printed tag.
#' @return named list: theta, se_cl, phi, prop_diag, lf_m_median, disc.
ablate <- function(env, label) {
  fo <- if (is.null(env)) fit_orthogonal else env$fit_orthogonal
  assign(".Random.seed", ANCHOR, envir = globalenv())
  tt <- Sys.time()
  f <- fo(y, xc$x1, xc$x2, Z, W_INST, dt$cluster, K = N_FOLDS,
          n_part = N_PART, cste = LF_CSTE, init_fn = init_control,
          lf_imax = MBAR_INST, lf_patience = MBAR_INST, rho = RHO,
          xeval = xev, n_cores = N_CORES, eps_rho = EPS_INST)
  message(sprintf("  D. %-22s %4.0fs   theta[2] = %+.5f   m-median %g",
                  label, as.numeric(difftime(Sys.time(), tt, units = "secs")),
                  f$theta[2], f$lf_m_median))
  list(theta = f$theta, se_cl = f$se_cl, se_iid = f$se_iid, phi = phi_of(f),
       prop_diag = f$prop_diag, lf_m_median = f$lf_m_median,
       lf_hit_cap = f$lf_hit_cap, disc = f$disc, coef_names = f$coef_names,
       xeval = f$xeval)
}

arm_old <- ablate(LEG, "none")
arm_ren <- ablate(REN, "renormalised (j=0)")
arm_new <- ablate(NULL, "C3 family (p_K=8)")
stopifnot(identical(arm_old$coef_names, arm_new$coef_names),
          identical(arm_ren$coef_names, arm_new$coef_names))

#' The move between two ablation arms, in the units the paper reports.
#'
#' @param a,b list. ablate() output; `b` is the newer arm.
#' @return named list of scalars.
arm_move <- function(a, b) {
  list(max_d_theta = max(abs(b$theta - a$theta)),
       max_d_theta_in_se = max(abs(b$theta - a$theta) /
                                 pmax(a$se_cl, .Machine$double.eps)),
       max_d_se = max(abs(b$se_cl - a$se_cl)),
       phi_sup = max(abs(b$phi - a$phi)),
       phi_l2 = sqrt(mean((b$phi - a$phi)^2)))
}
panelD <- list(
  theta = list(none = arm_old$theta, renorm = arm_ren$theta,
               family = arm_new$theta),
  se_cl = list(none = arm_old$se_cl, renorm = arm_ren$se_cl,
               family = arm_new$se_cl),
  phi = list(none = arm_old$phi, renorm = arm_ren$phi, family = arm_new$phi),
  xeval = xev,
  disc = list(none = mean(arm_old$disc), renorm = mean(arm_ren$disc),
              family = mean(arm_new$disc)),
  m_median = list(none = arm_old$lf_m_median, renorm = arm_ren$lf_m_median,
                  family = arm_new$lf_m_median),
  ## fam_ren is what 2026-08-15 moved; ren_none is what 2026-08-14 moved and is
  ## the regression test against the shipped table.
  fam_ren = arm_move(arm_ren, arm_new),
  ren_none = arm_move(arm_old, arm_ren),
  fam_none = arm_move(arm_old, arm_new),
  coef_names = arm_new$coef_names)
message(sprintf(paste("     family vs renormalised: max|dtheta| = %.5f (%.3f",
                      "clustered se); sup|dphi| = %.5f, L2 %.5f"),
                panelD$fam_ren$max_d_theta, panelD$fam_ren$max_d_theta_in_se,
                panelD$fam_ren$phi_sup, panelD$fam_ren$phi_l2))
message(sprintf(paste("     renormalised vs none (2026-08-14, regression",
                      "test): max|dtheta| = %.5f; sup|dphi| = %.5f"),
                panelD$ren_none$max_d_theta, panelD$ren_none$phi_sup))

# ---- Panel E: the isolation check ------------------------------------------
#
# WHAT THE CHANGE CANNOT REACH.  The propensity varrho-hat is a function of
# (W, Delta Z, fold indices) and of eps alone: fit_propensity_multi() never sees
# C_{h_x}, and the fold indices come from the RNG stream, which all three arms
# share by construction (ANCHOR is restored before each).  So every propensity
# diagnostic must be identical to the LAST BIT.  A nonzero difference here would
# mean the change reached something it has no path to, and that would be a
# defect in the change rather than a finding about the estimator.

pd_o <- arm_old$prop_diag; pd_r <- arm_ren$prop_diag; pd_n <- arm_new$prop_diag
panelE <- list(
  bind_rate = c(before = pd_o$bind_rate, after = pd_n$bind_rate),
  n_bind = c(before = pd_o$n_bind, after = pd_n$n_bind),
  n_eval_total = c(before = pd_o$n_eval_total, after = pd_n$n_eval_total),
  min_pre = c(before = pd_o$min_pre, after = pd_n$min_pre),
  max_move = c(before = pd_o$max_move, after = pd_n$max_move),
  n_not_converged = c(before = pd_o$n_not_converged,
                      after = pd_n$n_not_converged),
  identical = identical(pd_o, pd_n) && identical(pd_r, pd_n))
if (!panelE$identical) {
  stop(paste("boundary: the propensity diagnostics MOVED between the arms.",
             "The x-direction kernel has no path to the propensity, so this is",
             "a defect in the change, not a finding about the estimator."))
}
message("  E. isolation: propensity diagnostics bit-for-bit identical across",
        " all three arms (PASS)")

## ---------------------------------------------------------------------------
## THE SCALE THE TWO SURVIVING ROWS ARE READ AGAINST.
##
## `bind_rate` and `min_pre` are identical across the ENGINES, which is what the
## panel is for, and they are NOT identical across cross-fitting FOLD DRAWS,
## which is what a reader comparing this table with the headline theta-hat table
## discovers without being told.  See the header block: the gap between the two
## shipped values is one anchor, verified rather than assumed.
##
## THIS IS EXACT, NOT A SIMULATION OF THE ESTIMATOR.  The propensity never sees
## the Landweber solve: crossfit_once() draws `folds`, then `op_idx` per fold,
## and calls fit_propensity_multi() twice per fold -- operator stage, fitted on
## op_idx and evaluated on sol_idx; moment stage, fitted on the fold complement
## and evaluated on the fold.  Its diagnostics are a deterministic function of
## those index sets, of (W, Delta Z) and of eps.  So the law of the pooled
## statistic is generated by drawing the same index sets from the same laws and
## running the same 10 propensity fits per partition, with no solve at all --
## the same arithmetic the estimator does, at a hundredth of the cost.
##
## WHAT IT IS AND IS NOT.  It is the sampling law of the diagnostic over the
## ESTIMATOR'S OWN randomisation, holding the sample fixed.  It is not a
## confidence statement about a population binding rate, and no coverage is
## claimed for the reported interval; it is a spread, printed so that a single
## draw is not read as a property of the design.
## ---------------------------------------------------------------------------

#' The pooled propensity diagnostics of one redraw of the partition structure.
#'
#' Mirrors crossfit_once()'s index construction exactly and stops there.
#'
#' @param stream the L'Ecuyer stream this redraw runs on.
#' @return named numeric: n_eval, n_bind, bind_rate, min_pre.
pd_reference_draw <- function(stream) {
  assign(".Random.seed", stream, envir = globalenv())
  ne <- 0; nb <- 0; mp <- Inf
  for (b in seq_len(N_PART)) {
    folds <- sample(rep_len(seq_len(N_FOLDS), n))
    for (k in seq_len(N_FOLDS)) {
      hold <- which(folds == k)
      rest <- which(folds != k)
      op_idx <- sample(rest, floor(length(rest) / 2))
      sol_idx <- setdiff(rest, op_idx)
      dd <- list(
        attr(fit_propensity_multi(W_INST, Z, op_idx, sol_idx, eps = EPS_INST,
                                  cells = CELLS_INST), "prop_diag"),
        attr(fit_propensity_multi(W_INST, Z, rest, hold, eps = EPS_INST,
                                  cells = CELLS_INST), "prop_diag"))
      for (d in dd) {
        ne <- ne + d$n_eval
        nb <- nb + d$n_bind_rows
        mp <- min(mp, d$min_pre)
      }
    }
  }
  c(n_eval = ne, n_bind = nb, bind_rate = nb / ne, min_pre = mp)
}

PD_STREAM <- ANCHOR
for (hop in seq_len(PD_STREAM_SKIP)) {
  PD_STREAM <- parallel::nextRNGStream(PD_STREAM)
}
assign(".Random.seed", PD_STREAM, envir = globalenv())
pd_streams <- make_streams(B_PDREF)
t0 <- Sys.time()
pd_got <- parallel::mclapply(seq_len(B_PDREF),
                             \(b) pd_reference_draw(pd_streams[[b]]),
                             mc.cores = N_CORES, mc.preschedule = FALSE)
pd_bad <- vapply(pd_got, \(z) inherits(z, "try-error") || length(z) != 4L,
                 logical(1))
if (any(pd_bad)) {
  stop(sprintf("boundary: %d of %d reference redraws failed", sum(pd_bad),
               B_PDREF))
}
pd_ref <- do.call(rbind, pd_got)
stopifnot(nrow(pd_ref) == B_PDREF, !anyNA(pd_ref),
          all(pd_ref[, "n_eval"] == pd_n$n_eval_total),
          all(is.finite(pd_ref[, "min_pre"])), all(pd_ref[, "min_pre"] > 0))
br <- 100 * pd_ref[, "bind_rate"]
mp <- pd_ref[, "min_pre"]
panelE$reference <- list(
  b_draws = B_PDREF, n_eval = pd_n$n_eval_total,
  bind_pct = br, min_pre = mp,
  bind_mean = mean(br), bind_sd = stats::sd(br),
  bind_q = stats::quantile(br, c(0.10, 0.50, 0.90)),
  bind_range = range(br),
  min_pre_median = stats::median(mp),
  min_pre_q = stats::quantile(mp, c(0.10, 0.90)),
  min_pre_range = range(mp),
  ## Where the two arms' shipped value sits in its own reference law.  A value
  ## in the body of the law is the finding; a value in its extreme tail would
  ## say the arms' draw is not a typical one and would need reporting as such.
  bind_pctile = 100 * mean(br <= 100 * pd_n$bind_rate),
  min_pre_pctile = 100 * mean(mp <= pd_n$min_pre))
message(sprintf(paste("  E. reference law over %d redraws of the folds (%.0fs):",
                      "binds mean %.4f%% sd %.4f, this draw at pct %.0f"),
                B_PDREF, as.numeric(difftime(Sys.time(), t0, units = "secs")),
                panelE$reference$bind_mean, panelE$reference$bind_sd,
                panelE$reference$bind_pctile))
message(sprintf(paste("     min pre-projection median %.3e, [10th, 90th]",
                      "%.3e -- %.3e, this draw at pct %.0f"),
                panelE$reference$min_pre_median,
                panelE$reference$min_pre_q[[1L]],
                panelE$reference$min_pre_q[[2L]],
                panelE$reference$min_pre_pctile))

# ---- Panel F: THE SIGN AUDIT -----------------------------------------------
#
# THE ONE THING THIS CHANGE COULD HAVE BROKEN WITHOUT SAYING SO.  Until
# 2026-08-15 survival_matrix()'s note ended "the map stays monotone from 1 to 0
# ... so nothing downstream sees a sign change", which was true of the
# renormalised order-2 kernel.  An order-8 Theta_I is SIGN-INDEFINITE, so its
# running integral is not monotone and does not lie in [0, 1], and no consumer
# checks.  This panel MEASURES the damage rather than arguing it away.
#
# THE CONSUMER AUDIT, which is what makes the measurement actionable.  Every
# reader of a survival matrix in this repository, and what it needs:
#   apply_adjoint(), w_apply_adjoint()  LINEAR in S, and in rowSums(S).  A sign
#       change is invisible to a linear map; it is the definition of the adjoint
#       under the kernel the estimator ships, whatever that kernel's sign.
#   adjoint_range_defect()              reads S at the TWO ENDPOINTS only, where
#       the identities are exact.
#   this stage's Panel A                the same two endpoints.
#   nu_noise_level() (orthogonal_theta.R)  DEAD -- reachable only through
#       solve_debias_weight(), which nothing calls (that file's own header
#       records it, and the RKHS route is what crossfit_once() uses).
#   make_operator()'s xsupp note        described an S < 0 hazard for an
#       evaluation point OUTSIDE X.  Under the family that hazard is GONE, not
#       worsened: Theta_I vanishes off I, so the clamped running integral gives
#       exactly 1 or exactly 0 there.
# No consumer clamps S to [0, 1], takes a monotone inverse of it, or reads it as
# a probability.  The two quantities that ARE read structurally are the
# endpoints, and Panel A asserts them at 1e-12.

sign_audit <- function(pk) {
  vg <- seq(XS[1], XS[2], length.out = 1201L)
  out <- list()
  for (k in 1:2) {
    xx <- if (k == 1L) xc$x1 else xc$x2
    hh <- op_new$hx[k]
    Sm <- n * survival_matrix(vg, xx, hh, XS, pk)
    dS <- diff(Sm)
    out[[k]] <- list(min = min(Sm), max = max(Sm),
                     n_col_nonmono = sum(apply(dS, 2L, \(z) any(z > 0))),
                     n_col = ncol(Sm),
                     share_steps_up = mean(dS > 0))
  }
  ## sup|Theta_I| and the Gram spectrum, the two numbers that say how much
  ## bigger the boundary kernel is than the interior one.
  sup_th <- NA_real_; lam <- NA_real_; kap <- NA_real_
  if (!is.null(pk)) {
    gs <- seq(-max(abs(c(XS - XS[1], XS - XS[2]))) / min(op_new$hx),
              max(abs(c(XS - XS[1], XS - XS[2]))) / min(op_new$hx),
              length.out = 2001L)
    sup_th <- 0
    for (k in 1:2) {
      xx <- if (k == 1L) xc$x1 else xc$x2
      fam <- bdry_family(xx, op_new$hx[k], XS, pk)
      sup_th <- max(sup_th, max(abs(bdry_theta(
        matrix(gs, length(gs), length(xx)), fam))))
      mm <- sqrt(2 * pi) *
        (gauss_partial_moments(fam$b, 2L * pk - 2L) -
           gauss_partial_moments(fam$a, 2L * pk - 2L))
      ev <- vapply(seq_along(fam$a), function(i) {
        G <- outer(seq_len(pk), seq_len(pk), \(u, v) mm[i, u + v - 1L])
        e <- eigen(G, symmetric = TRUE, only.values = TRUE)$values
        c(min(e), max(e) / min(e))
      }, numeric(2))
      lam <- min(c(lam, ev[1L, ]), na.rm = TRUE)
      kap <- max(c(kap, ev[2L, ]), na.rm = TRUE)
    }
  }
  list(x1 = out[[1L]], x2 = out[[2L]], sup_theta = sup_th,
       lambda_min_gram = lam, kappa_gram = kap)
}
panelF <- list(family = sign_audit(P_K_X), renorm = sign_audit(NULL),
               interior_sup_theta = max(abs(k_order(seq(-8, 8, by = 0.001),
                                                    P_K_X))))
message(sprintf(paste("  F. sign audit, family: S in [%.4f, %.4f] (renorm",
                      "[%.4f, %.4f]); non-monotone at %d + %d of %d + %d",
                      "design points"),
                min(panelF$family$x1$min, panelF$family$x2$min),
                max(panelF$family$x1$max, panelF$family$x2$max),
                min(panelF$renorm$x1$min, panelF$renorm$x2$min),
                max(panelF$renorm$x1$max, panelF$renorm$x2$max),
                panelF$family$x1$n_col_nonmono,
                panelF$family$x2$n_col_nonmono,
                panelF$family$x1$n_col, panelF$family$x2$n_col))
message(sprintf(paste("     sup|Theta_I| = %.3f against %.4f for the interior",
                      "member; lambda_min(G) = %.3e, kappa = %.2e"),
                panelF$family$sup_theta, panelF$interior_sup_theta,
                panelF$family$lambda_min_gram, panelF$family$kappa_gram))

# ---- Panel G: the u-direction is untouched, bit-for-bit --------------------
#
# The other half of "this edit is confined to the x-direction".  C3's boundary
# index is carried only in x (assumptions_main.tex:3074); operator_residual()
# smooths the RESIDUAL with the same ker_dens(), at xsupp = NULL, and that path
# must be the pre-change one to the last bit.  Checked against the engine as it
# stood before 2026-08-15, read from the backup this change was made against, at
# the four configurations the application realises.
U_REF <- here::here("quality_reports", "application",
                    "backup_pre_bdryfam_20260815", "lf_panel.R")
panelG <- list(ref = U_REF, ran = FALSE)
if (file.exists(U_REF)) {
  e_ref <- new.env(parent = globalenv())
  sys.source(U_REF, envir = e_ref)
  set.seed(SEED_BOUNDARY)
  uu <- stats::rnorm(400L)
  w4u <- sample(0:3, 400L, TRUE, prob = c(0.7, 0.11, 0.07, 0.12))
  Zu <- cbind(1, matrix(stats::rnorm(400L * 3L), 400L, 3L))
  bi <- make_bierens(Zu[, -1L], n_t = N_T, seed = BIER_SEED, scale = T_SCALE)
  cfgs <- list(
    list(w = as.integer(w4u > 0L), rho = NULL, bier = NULL, adj = FALSE),
    list(w = as.integer(w4u > 0L), rho = runif(400L, 0.2, 0.6), bier = bi,
         adj = TRUE),
    list(w = w4u, rho = NULL, bier = NULL, adj = FALSE),
    list(w = w4u, rho = matrix(runif(1200L, 0.05, 0.2), 400L, 3L), bier = bi,
         adj = TRUE))
  same <- vapply(cfgs, function(cc) {
    identical(e_ref$operator_residual(uu, cc$w, rho = cc$rho, bier = cc$bier,
                                      adj_wtil = cc$adj),
              operator_residual(uu, cc$w, rho = cc$rho, bier = cc$bier,
                                adj_wtil = cc$adj))
  }, logical(1))
  ## Every u-direction primitive, by source identity: a changed body is a
  ## changed u-side even where this sample happens not to exercise it.
  u_fns <- c("k_order", "K_order", "k_gauss", "K_gauss", "bw_u", "bw_rot",
             "ker_dist", "residual_norm", "indep_criterion", "make_bierens",
             "operator_residual", "apply_adjoint", "operator_norm2",
             "lf_solve", "locate_dphi", "integrate_centre", "cumtrapz_centre",
             "build_int_matrix", "project_trunset", "fit_propensity",
             "fit_propensity_multi", "ll_reg", "ll_reg_multi")
  moved <- u_fns[!vapply(u_fns, function(f) {
    identical(paste(deparse(get(f, envir = e_ref)), collapse = "\n"),
              paste(deparse(get(f, envir = globalenv())), collapse = "\n"))
  }, logical(1))]
  panelG <- list(ref = U_REF, ran = TRUE, n_cfg = length(cfgs),
                 all_identical = all(same), moved_fns = moved)
  if (!all(same) || length(moved)) {
    stop(sprintf(paste("boundary: the u-direction MOVED (%d of %d residual",
                       "configurations differ; changed: %s).  C3's boundary",
                       "index is carried only in x."),
                 sum(!same), length(same),
                 if (length(moved)) paste(moved, collapse = ", ") else "none"))
  }
  message(sprintf(paste("  G. u-direction bit-for-bit identical at %d",
                        "configurations; %d primitives unchanged (PASS)"),
                  length(cfgs), length(u_fns)))
} else {
  warning("boundary: no pre-change reference engine at ", U_REF,
          " -- Panel G not run.", call. = FALSE, immediate. = TRUE)
}

# ---- LaTeX (INV-13: bare tabular, no float, no caption, no notes) ----------

pct <- function(x) fmt(100 * x, 2)
## Small numbers in scientific notation, ordinary ones as decimals: the moment
## table spans machine epsilon to unity in one column and a single format makes
## one end of it unreadable.
num <- function(x, d = 4L) {
  ifelse(is.finite(x) & abs(x) > 0 & abs(x) < 10^(-d), fmt_sci(x, 1L),
         fmt(x, d))
}
tex_body <- c(
    "\\multicolumn{4}{l}{\\textit{Panel A: $\\int_I\\varsigma^{\\,j}\\Theta_I$ over $\\mathcal X$, worst departure from $\\delta_{j0}$ over all design points}} \\\\",
    sprintf("$j=0$ & %s & %s & %s \\\\",
            num(panelA$worst$none[1L]), num(panelA$worst$renorm[1L]),
            num(panelA$worst$family[1L])),
    sprintf("\\quad design points off by $>0.01$ (\\%%) & %s & %s & %s \\\\",
            pct(panelA$share_1pct$none[1L]), pct(panelA$share_1pct$renorm[1L]),
            pct(panelA$share_1pct$family[1L])),
    sprintf("$j=1$ & %s & %s & %s \\\\",
            num(panelA$worst$none[2L]), num(panelA$worst$renorm[2L]),
            num(panelA$worst$family[2L])),
    sprintf("\\quad worst in the interior & %s & %s & %s \\\\",
            num(panelA$worst_interior$none[2L]),
            num(panelA$worst_interior$renorm[2L]),
            num(panelA$worst_interior$family[2L])),
    sprintf("\\quad design points off by $>0.01$ (\\%%) & %s & %s & %s \\\\",
            pct(panelA$share_1pct$none[2L]), pct(panelA$share_1pct$renorm[2L]),
            pct(panelA$share_1pct$family[2L])),
    sprintf("$j=2$ & %s & %s & %s \\\\",
            num(panelA$worst$none[3L]), num(panelA$worst$renorm[3L]),
            num(panelA$worst$family[3L])),
    sprintf("\\quad smallest over design points & %s & %s & %s \\\\",
            num(min(dev_j2$none)), num(min(dev_j2$renorm)),
            num(min(dev_j2$family))),
    sprintf("$\\max_{3\\le j\\le 7}$ & %s & %s & %s \\\\",
            num(max(panelA$worst$none[4:8])),
            num(max(panelA$worst$renorm[4:8])),
            num(max(panelA$worst$family[4:8]))),
    "\\\\[0.5em]",
    "\\multicolumn{4}{l}{\\textit{Panel B: the reference density $\\hat\\pi$, which the adjoint divides by}} \\\\",
    sprintf("$\\int_{\\mathcal X}\\hat\\pi\\,dx$ & %s & %s & %s \\\\",
            fmt(panelB$none$total, 4), fmt(panelB$renorm$total, 4),
            fmt(panelB$family$total, 4)),
    sprintf("$\\min_{\\mathcal X}\\hat\\pi$ & %s & %s & %s \\\\",
            fmt(panelB$none$min_grid, 4), fmt(panelB$renorm$min_grid, 4),
            fmt(panelB$family$min_grid, 4)),
    sprintf("$\\hat\\pi$ at the reported grid's ends & %s, %s & %s, %s & %s, %s \\\\",
            fmt(panelB$none$at_q05, 3), fmt(panelB$none$at_q95, 3),
            fmt(panelB$renorm$at_q05, 3), fmt(panelB$renorm$at_q95, 3),
            fmt(panelB$family$at_q05, 3), fmt(panelB$family$at_q95, 3)),
    "\\\\[0.5em]",
    ## NO \ref{} IN A FRAGMENT.  prp:hatAprop lives in the online supplement and
    ## this fragment is input by main.qmd, so a cross-reference here would
    ## compile to a bare "??" in the shipped paper.  The clause is named in
    ## words; the caption is the writer's place to cite it.
    "\\multicolumn{4}{l}{\\textit{Panel C: $\\int_{\\mathcal X}\\hat\\nu\\,dx$, the observable of ``the adjoint maps into $\\mathcal V$''}} \\\\",
    sprintf("At a common residual & %s & %s & %s \\\\",
            fmt_sci(d_same_old$int_nu, 2L), fmt_sci(d_same_ren$int_nu, 2L),
            fmt_sci(d_same_new$int_nu, 2L)),
    sprintf("\\quad as a share of $\\sup|\\hat\\nu|$ (\\%%) & %s & %s & %s \\\\",
            pct(d_same_old$rel), fmt_sci(100 * d_same_ren$rel, 1L),
            fmt_sci(100 * d_same_new$rel, 1L)),
    sprintf("At each engine's own residual & %s & %s & %s \\\\",
            fmt_sci(d_own_old$int_nu, 2L), fmt_sci(d_own_ren$int_nu, 2L),
            fmt_sci(d_own_new$int_nu, 2L)),
    "\\\\[0.5em]",
    ## THE PANEL D AND E HEADERS NAME THE PARTITION DRAW, and that is the repair
    ## of 2026-08-15.  "identical streams" said the ARMS shared a draw, which
    ## is the pairing this ablation needs, and left unsaid the thing a reader
    ## comparing tables actually needs: WHOSE draw.  This ablation has its own,
    ## and the two rows of Panel E that depend on it now carry their own
    ## across-draw law directly beneath them.
    "\\multicolumn{4}{l}{\\textit{Panel D: what moves, at $d_Z=5$, $\\mathsf L=4$, all three arms on one partition draw}} \\\\",
    sprintf("$\\hat\\theta$ on $\\mathbb 1\\{$nonattainment$\\}$ & %s & %s & %s \\\\",
            fmt(panelD$theta$none[2L], 4), fmt(panelD$theta$renorm[2L], 4),
            fmt(panelD$theta$family[2L], 4)),
    sprintf("\\quad clustered standard error & (%s) & (%s) & (%s) \\\\",
            fmt(panelD$se_cl$none[2L], 4), fmt(panelD$se_cl$renorm[2L], 4),
            fmt(panelD$se_cl$family[2L], 4)),
    sprintf("$\\max_j|\\hat\\theta_j|$ change from the column to its left & -- & %s & %s \\\\",
            fmt(panelD$ren_none$max_d_theta, 4),
            fmt(panelD$fam_ren$max_d_theta, 4)),
    sprintf("\\quad in clustered standard errors & -- & %s & %s \\\\",
            fmt(panelD$ren_none$max_d_theta_in_se, 3),
            fmt(panelD$fam_ren$max_d_theta_in_se, 3)),
    sprintf("$\\sup_x|\\hat\\varphi|$ change from the column to its left & -- & %s & %s \\\\",
            fmt(panelD$ren_none$phi_sup, 4), fmt(panelD$fam_ren$phi_sup, 4)),
    sprintf("Mean relative balance & %s & %s & %s \\\\",
            fmt_sci(panelD$disc$none, 2L), fmt_sci(panelD$disc$renorm, 2L),
            fmt_sci(panelD$disc$family, 2L)),
    "\\\\[0.5em]",
    "\\multicolumn{4}{l}{\\textit{Panel E: what cannot move, and does not, on this ablation's partition draw}} \\\\",
    sprintf("Truncation binds (\\%%) & %s & %s & %s \\\\",
            fmt(100 * panelE$bind_rate[["before"]], 4),
            fmt(100 * panelE$bind_rate[["after"]], 4),
            fmt(100 * panelE$bind_rate[["after"]], 4)),
    sprintf(paste("\\quad over $%d$ fold redraws: mean (sd) &",
                  "\\multicolumn{3}{c}{%s (%s)} \\\\"),
            panelE$reference$b_draws, fmt(panelE$reference$bind_mean, 4),
            fmt(panelE$reference$bind_sd, 4)),
    sprintf("Cross-fitted evaluations & %d & %d & %d \\\\",
            as.integer(panelE$n_eval_total[["before"]]),
            as.integer(panelE$n_eval_total[["after"]]),
            as.integer(panelE$n_eval_total[["after"]])),
    sprintf("$\\min_l\\hat\\varrho_l$ pre-projection & %s & %s & %s \\\\",
            fmt_sci(panelE$min_pre[["before"]], 1L),
            fmt_sci(panelE$min_pre[["after"]], 1L),
            fmt_sci(panelE$min_pre[["after"]], 1L)),
    sprintf(paste("\\quad same redraws: median [10th, 90th] &",
                  "\\multicolumn{3}{c}{%s [%s, %s]} \\\\"),
            fmt_sci(panelE$reference$min_pre_median, 1L),
            fmt_sci(panelE$reference$min_pre_q[[1L]], 1L),
            fmt_sci(panelE$reference$min_pre_q[[2L]], 1L)),
    "\\\\[0.5em]",
    "\\multicolumn{4}{l}{\\textit{Panel F: the sign of $S(v;X)$, the running integral the adjoint carries}} \\\\",
    sprintf("Range of $S$ over $\\mathcal X$ & \\multicolumn{1}{c}{--} & [%s, %s] & [%s, %s] \\\\",
            fmt(min(panelF$renorm$x1$min, panelF$renorm$x2$min), 3),
            fmt(max(panelF$renorm$x1$max, panelF$renorm$x2$max), 3),
            fmt(min(panelF$family$x1$min, panelF$family$x2$min), 3),
            fmt(max(panelF$family$x1$max, panelF$family$x2$max), 3)),
    sprintf("Design points at which $S$ is not monotone & \\multicolumn{1}{c}{--} & %d & %d \\\\",
            as.integer(panelF$renorm$x1$n_col_nonmono +
                         panelF$renorm$x2$n_col_nonmono),
            as.integer(panelF$family$x1$n_col_nonmono +
                         panelF$family$x2$n_col_nonmono)),
    sprintf("$\\sup_\\varsigma|\\Theta_I|$ (interior member: %s) & \\multicolumn{1}{c}{--} & \\multicolumn{1}{c}{--} & %s \\\\",
            fmt(panelF$interior_sup_theta, 3), fmt(panelF$family$sup_theta, 2)),
    sprintf("$\\lambda_{\\min}(\\mathsf G(I))$ over the realised $I$ & \\multicolumn{1}{c}{--} & \\multicolumn{1}{c}{--} & %s \\\\",
            fmt_sci(panelF$family$lambda_min_gram, 2L)))

## WRITE-TIME GUARDS.  The two reference rows exist to stop a single draw being
## read as a property of the design, so the fragment refuses to ship them empty,
## refuses to ship a reference law the arms' own draw falls outside, and refuses
## to ship the engine columns unless they are still identical.
stopifnot(
  panelE$identical,
  identical(panelE$bind_rate[["before"]], panelE$bind_rate[["after"]]),
  identical(panelE$min_pre[["before"]], panelE$min_pre[["after"]]),
  panelE$reference$b_draws == B_PDREF,
  all(is.finite(c(panelE$reference$bind_mean, panelE$reference$bind_sd,
                  panelE$reference$min_pre_median, panelE$reference$min_pre_q))),
  panelE$reference$bind_sd > 0,
  sum(grepl("multicolumn\\{4\\}\\{l\\}", tex_body)) == 6L,  # six panel headers
  !any(is.na(tex_body)), all(nzchar(tex_body)))

## WARNED, NOT ASSERTED.  An arms' draw outside the body of its own reference law
## is a FINDING about that draw, not a defect in this code, so it must be loud
## and it must not halt: at B_PDREF draws the extreme percentiles are estimated
## from a handful of them, and a stopifnot() here would be a run that fails a few
## times in a hundred thousand for a reason no reader could act on.
for (z in list(list(nm = "binding rate", p = panelE$reference$bind_pctile),
               list(nm = "min pre-projection",
                    p = panelE$reference$min_pre_pctile))) {
  if (z$p < 2.5 || z$p > 97.5) {
    warning(sprintf(paste("boundary: this ablation's %s sits at the %.1f",
                          "percentile of its own %d-redraw reference law --",
                          "an atypical partition draw, and the reported value",
                          "should be read as one."),
                    z$nm, z$p, B_PDREF), call. = FALSE, immediate. = TRUE)
  }
}
write_tabular(colspec = "lrrr",
              header = c(paste(" & No adjustment & Renormalised ($j=0$)",
                               "& C3 family, $p_K=8$ \\\\")),
              body = tex_body,
              path = file.path(TAB, "app_tsp_boundary.tex"))
message("wrote ", file.path(TAB, "app_tsp_boundary.tex"))

# ---- the moment ladder, its own fragment -----------------------------------
#
# eq:truncmom at every j, in three regions, for the shipped kernel.  This is the
# acceptance test stated as a table: C3 asks for eight moments and the reader is
# owed all eight, at the endpoint as well as in the interior.  The two
# superseded kernels are in the first two columns of the fragment above at
# j = 0, 1, 2; here the columns are REGIONS and the kernel is the family.

lad_rows <- vapply(seq_len(P_K_X), function(j) {
  sprintf("$j=%d$ & %s & %s & %s & %s & %s \\\\", j - 1L,
          num(panelA$worst_interior$family[j]),
          num(panelA$worst_layer$family[j]),
          num(panelA$worst_end$family[j]),
          num(panelA$ladder$family[2L, j]),
          num(panelA$ladder$family[4L, j]))
}, character(1))
ren_rows <- vapply(seq_len(P_K_X), function(j) {
  sprintf("$j=%d$ & %s & %s & %s & %s & %s \\\\", j - 1L,
          num(panelA$worst_interior$renorm[j]),
          num(panelA$worst_layer$renorm[j]),
          num(panelA$worst_end$renorm[j]),
          num(panelA$ladder$renorm[2L, j]),
          num(panelA$ladder$renorm[4L, j]))
}, character(1))
mom_body <- c(
  sprintf(paste("\\multicolumn{6}{l}{\\textit{Panel A: C3's boundary",
                "family at $p_K=%d$, the shipped kernel}} \\\\"), P_K_X),
  lad_rows,
  "\\\\[0.5em]",
  paste("\\multicolumn{6}{l}{\\textit{Panel B: the renormalised kernel it",
        "replaces ($j=0$ enforced, order $2$)}} \\\\"),
  ren_rows)
stopifnot(!any(is.na(mom_body)), all(nzchar(mom_body)),
          length(lad_rows) == P_K_X, length(ren_rows) == P_K_X)
write_tabular(
  colspec = "lrrrrr",
  header = c(paste(" & \\multicolumn{3}{c}{Worst over design points}",
                   "& \\multicolumn{2}{c}{At $\\underline x + kh_x$} \\\\"),
             "\\cmidrule(lr){2-4}\\cmidrule(lr){5-6}",
             sprintf(paste(" & Interior & Within $%dh_x$ & At the endpoint",
                           "& $k=1$ & $k=3$ \\\\"), REGION_W)),
  body = mom_body,
  path = file.path(TAB, "app_tsp_bdrymom.tex"))
message("wrote ", file.path(TAB, "app_tsp_bdrymom.tex"))

saveRDS(list(
  n = n, d_z = D_Z, L = length(CELLS_INST), eps = EPS_INST, mbar = MBAR_INST,
  seed = SEED_BOUNDARY, xsupp = XS, hx_full = op_new$hx, hx_fold = h_fold,
  p_K = P_K_X, region_w = REGION_W,
  panelA = panelA, panelB = panelB, panelC = panelC, panelD = panelD,
  panelE = panelE, panelF = panelF, panelG = panelG,
  solve_iter = c(none = sr_old$iter, renorm = sr_ren$iter,
                 family = sr_new$iter),
  phi_second_stage = list(none = sr_old$phi, renorm = sr_ren$phi,
                          family = sr_new$phi, xeval = xev)),
  file.path(OUT, "app_tsp_boundary.rds"))
message("wrote ", file.path(OUT, "app_tsp_boundary.rds"))
