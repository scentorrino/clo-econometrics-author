# ============================================================================
# app_tsp_05_phi_band.R
#
# Section 6, stage 5: the numerical table of phi-hat and the variability band
# on the phi-hat figure.
#
#   paper/tables/app_tsp_phi.tex          phi-hat at deciles of pooled X
#   paper/figures/app_tsp_phi.pdf         phi-hat with the variability band
#   quality_reports/application/app_tsp_phi_band.rds
#
# The figure used to be drawn in stage 4.  It is drawn here instead, because
# the band and the curve now come from the same object; stage 4 keeps the other
# two figures and points here.
#
# ---------------------------------------------------------------------------
# WHAT THE BAND IS, AND WHAT IT IS NOT
#
# It is an ILLUSTRATIVE VARIABILITY BAND.  It is not a confidence interval, it
# has no coverage claim, and no coverage is computed anywhere below.
#
# Valid uniform inference for phi in this model does not exist.  Babii's honest
# sets require a linear operator and completeness; Chen and Pouzo cover
# nonlinear problems but are indexed by a DETERMINISTIC sieve dimension,
# whereas the Landweber-Fridman discrepancy rule used here makes the
# regularisation index a RANDOM stopping time.  Nothing in the econometrics or
# inverse-problems literature closes that gap.
#
# The convention followed here is the one the author's own published paper set.
# Centorrino, Feve and Florens (2025, J. Econometrics) -- same equation, same
# binary instrument, same LF estimator -- report in the note to their Figure 4:
#
#   "The confidence intervals for the nonparametric estimator are presented
#    only to illustrate its variability but should not be considered valid."
#
# computed there as a bootstrap with 99 replications and plotted as a band
# around the point estimate.  This file reproduces that pattern: 99
# replications (C14), plotted as an envelope drawn grey, unmapped and beneath
# the point estimate so it cannot be read as a confidence region.
#
# ---------------------------------------------------------------------------
# BOOTSTRAP DESIGN -- every choice, stated
#
# (a) WHAT IS RESAMPLED.  Counties, with replacement, n = 983 draws from the
#     983 analysis counties.  The county is the unit A0 treats as i.i.d. and is
#     the unit the estimator's own cross-fitting splits on.  Both periods of a
#     drawn county travel together, so the panel structure is preserved.
#
#     NOT resampled: states.  Tuning constant C9 clusters theta-hat's standard
#     error on StateCode because designation was made at AQCR level, and a
#     state-level cluster bootstrap would be the matching choice for THAT
#     standard error.  It is not used here for two reasons: the object is
#     phi-hat, whose estimator is the whole-sample LF pass rather than the
#     clustered moment; and a cluster bootstrap over the state identifiers in
#     this file would resample whole states, which at this sample size deletes
#     large parts of the X support in a substantial share of replications and
#     makes the second-stage grid non-comparable across draws.  The consequence
#     is stated rather than hidden: if state-level dependence matters for
#     phi-hat, the band below is too narrow.
#
# (b) THE COORDINATE MAP IS REBUILT ON EACH RESAMPLE.  Tuning constant C2 maps
#     X to [0,1] by the pooled empirical CDF, which is a function of the data.
#     Each replication therefore rebuilds its own map T*.  Curves are compared
#     on a FIXED PHYSICAL GRID in mu-g/m^3 -- the same 60 points stage 2
#     reported -- by evaluating replication b at T*(x_grid).  Comparing on the
#     rank grid instead would compare different physical TSP levels.
#
# (c) THE STOPPING INDEX IS RE-SELECTED IN EVERY REPLICATION.  The discrepancy
#     rule is part of the estimator, not a fixed tuning constant, so holding
#     m-hat at its full-sample value would describe the sampling noise of a
#     procedure nobody ran.  It would also be the anti-conservative choice: the
#     realised stopping index ranges over the whole admissible interval
#     [1, 2000] within a single configuration (app_tsp_estimator_diag.tex,
#     Panel A), and that dispersion is a real source of variability in
#     phi-hat.  It is included.
#
# (d) THETA IS HELD AT ITS FULL-SAMPLE VALUE IN THE REPORTED BAND, and the
#     cost of that choice is measured rather than asserted.
#
#     phi-hat is a plug-in second stage in theta-hat (prp:plugin), so the ideal
#     replication re-runs both steps.  It is not affordable: the second stage
#     alone runs up to the 2000-iteration cap on all n = 983 observations, and
#     wrapping it in the cross-fitted theta step costs roughly a further factor
#     of twenty-five.  On four physical cores that is about a day of wall time
#     for 99 replications, against about three hours for the second stage
#     alone.
#
#     So the reported band is design "C0": counties resampled, coordinate map
#     rebuilt, stopping index re-selected, theta held at theta-hat.  Design "F"
#     re-estimates theta as well, at N_BOOT_F = 25 replications, and exists to
#     bound what C0 leaves out.  F deliberately uses ONE cross-fitting
#     partition rather than the headline's ten, which makes its theta-hat* the
#     NOISIEST admissible version of the theta step -- the cross-fitting
#     component of theta-hat's standard error is 0.415 of the total at B = 10
#     (app_tsp_estimator_diag.tex, Panel D), so B = 1 multiplies it by
#     sqrt(10).  F is therefore an UPPER BOUND on the theta channel: if the F
#     band is not materially wider than C0's, theta is not what limits
#     phi-hat, and the reported band loses nothing by conditioning on it.
#
#     Designs "C1a" and "C1b" repeat C0 in the two rescaled X coordinates and
#     answer the band half of the scale question in Panel C.
#
# (e) FAILED REPLICATIONS ARE COUNTED, NOT DROPPED SILENTLY.  A replication is
#     recorded with one of five statuses:
#       ok        -- returned a finite curve
#       error     -- the estimator raised a condition (fit_orthogonal() stops
#                    when any cross-fitting partition fails)
#       nonfinite -- returned a curve with a non-finite entry
#     and, among the "ok" replications, the convergence of the second-stage LF
#     pass is separately recorded as
#       interior  -- the discrepancy has an interior argmin, the intended case
#       start     -- argmin at iteration 1: phi-hat IS the initial condition
#                    and the LF step contributed nothing
#       cap       -- argmin at the cap m-bar = 2000: still improving when the
#                    iteration was stopped, i.e. under-regularised
#     Every replication returning a finite curve is RETAINED, including
#     "start" and "cap".  Discarding them would be the anti-conservative
#     choice: they are what the procedure produces on those resamples, and
#     they are where the width comes from.  All counts are printed in the
#     table's Panel B.
#
# (f) THE BAND IS A POINTWISE PERCENTILE ENVELOPE (C15), not mean +/- k SD.
#     A handful of replications are wild -- this is a sample where 10 of 50
#     fold solves already run to the iteration cap -- and a moment-based
#     envelope would be a report on those few.  The bootstrap standard
#     deviation is tabulated alongside so the reader can see the difference.
#
# (g) NORMALISATION.  The reported object is phi-hat(x) - phi-hat(median x),
#     the normalisation the existing figure uses; phi is identified only up to
#     an additive constant.  Each replication is re-anchored at ITS OWN pooled
#     median TSP, so the band reflects the procedure as run rather than the
#     procedure conditioned on a full-sample quantity.  The resampling
#     dispersion of that median is reported in Panel B; it is negligible.
#
# ---------------------------------------------------------------------------
# THE SCALE DIAGNOSTIC (Panel C)
#
# app_tsp_robustness.tex records the one serious open finding in this
# application: re-expressing X in mu-g/m^3 or min-max scaling inflates
# theta-hat's standard errors by two orders of magnitude and flips signs, while
# every other arm is stable.  Both of those maps are STRICTLY INCREASING
# reparameterisations of X, so the normalised structural function evaluated on
# the physical mu-g/m^3 axis is the SAME POPULATION OBJECT in all three
# coordinates.  Any difference between the three curves is therefore an
# estimator artefact and nothing else.  Panel C measures it.
#
# Wall time: 63 minutes, MEASURED on eight cores 2026-08-10 and recorded in
# app_tsp_run_all.R's timing block.  This line read "roughly four to six hours
# on four physical cores" until 2026-08-11, which app_tsp_run_all.R:23 had
# already flagged as false while the file itself went on printing it -- a
# correction recorded in one place and not applied in the other, which is how a
# stale number survives being caught.  Most of the cost is design C0, dominated
# by the replications whose second stage runs to the 2000-iteration cap.
# Replication records are written one file per
# replication under quality_reports/application/app_tsp_phi_band_parts/, keyed
# on a PER-DESIGN configuration fingerprint, so an interrupted run resumes,
# changing one design does not discard another's work, and a table edit costs
# nothing.
# ============================================================================

library(here)
library(parallel)
library(ggplot2)

source(here::here("scripts", "R", "lf_panel.R"))
source(here::here("scripts", "R", "orthogonal_theta.R"))
source(here::here("scripts", "application", "app_tsp_common.R"))

RNGkind("L'Ecuyer-CMRG")
set.seed(SEED_PHIBAND)                                               # INV-14

# Deterministic L'Ecuyer anchors, drawn BEFORE anything else consumes the
# stream.  Replication b and full-sample arm j therefore receive the same
# anchor whether or not a cached checkpoint short-circuits the work that
# precedes them; without this, a cache hit and a cold run would produce
# different numbers from the same seed.
# The arms come first in the chain so that their anchors -- and therefore the
# full-sample theta-hat of each rescaled coordinate -- do not depend on N_BOOT;
# the ties diagnostic comes last so that adding it does not move any anchor
# a bootstrap replication had already used.
N_COORD    <- 3L
N_TIE_MAX  <- 64L
ANCHOR     <- make_streams(N_COORD + N_BOOT + N_TIE_MAX)
ARM_STREAM <- ANCHOR[seq_len(N_COORD)]
STREAMS    <- ANCHOR[N_COORD + seq_len(N_BOOT)]
TIE_STREAM <- ANCHOR[N_COORD + N_BOOT + seq_len(N_TIE_MAX)]

## Output root; INPUTS always from the repository tree.  See stage 2 and stage 8
## for the same block: a regeneration can be written to a scratch tree and
## DIFFED against the shipped artifacts before it replaces them.
OUT_ROOT <- Sys.getenv("APP_TSP_OUT_ROOT", unset = here::here())
TAB   <- file.path(OUT_ROOT, "paper", "tables")
FIG   <- file.path(OUT_ROOT, "paper", "figures")
OUT   <- file.path(OUT_ROOT, "quality_reports", "application")
IN    <- here::here("quality_reports", "application")
PARTS <- file.path(OUT, "app_tsp_phi_band_parts")
dir.create(TAB, showWarnings = FALSE, recursive = TRUE)
dir.create(FIG, showWarnings = FALSE, recursive = TRUE)
dir.create(OUT, showWarnings = FALSE, recursive = TRUE)

HEADLINE_DZ <- 5L

COORD_LABEL <- c(rank   = "Pooled empirical CDF (baseline)",
                 ugm3   = "$X$ in $\\mu$g/m$^3$",
                 minmax = "$X$ min--max scaled")
stopifnot(length(COORD_LABEL) == N_COORD)

# ---- Data and the full-sample point estimate --------------------------------

pan <- load_tsp_panel()
dt  <- pan$dt
n   <- nrow(dt)

# ---- THE INSTRUMENT.  MOVED TO THE FOUR-CATEGORY TRIGGER, 2026-08-12. -------
#
# WHY.  phi-hat and its band are what Section 6 reports for the ENDOGENOUS
# variable, and until 2026-08-12 they could only be binary -- not by choice but
# because conditional_parts() called the binary fit_propensity() at every
# cardinality, so phi_second_stage() raised "y values must be 0 <= y <= 1" at
# L >= 3.  `dt$w <- dt$CATT` in app_tsp_common.R was therefore never really a
# decision.  With the phi-step generalized it becomes one, and it is made here.
#
# WHAT MOVES AND WHAT DOES NOT.  This stage (the reported phi-hat and its band)
# moves to L = 4.  The d_Z ladder (stage 2) and the robustness sweep (stage 3)
# stay BINARY, deliberately: they are about theta-hat and the control set, the
# L = 4 / L = 2 comparison for theta-hat already exists in stage 8 on PAIRED
# partition streams -- which is a better-designed comparison than a re-run
# ladder would be -- and the ladder's d_Z = 0 rung runs init_poly(), which is
# binary-only (`w == 1`, `w == 0`) and would silently compare cell 1 against
# cell 0 while discarding cells 2 and 3.
#
# THE TRUNCATION LEVEL MOVES WITH THE CARDINALITY, not with the stage: eps_for()
# in app_tsp_common.R returns EPS_LOCALISE at L >= 3 and EPS_RHO at L = 2, on
# C24's own argument (the multiplier eps caps does not exist at L >= 3, where
# operator_residual() sets scal = 1).  The realised binding rate is reported
# beside the curve rather than argued for.
#
# THE ITERATION CAP MOVES TOO: lf_mbar() is 15 at L = 2 and 60 at L = 4 (C4).
# That, not the extra cells, is where the cost goes -- the per-ITERATION cost at
# L = 4 is 0.94x the binary one.

INST_COL  <- "w4"           # the column a resample carries the instrument in
iv        <- load_tsp_w4(dt)
dt$w4     <- iv$w4          # carried on `dt` so a resample transports it
W_INST    <- dt[[INST_COL]]
CELLS_INST <- iv$cells
EPS_INST  <- eps_for(W_INST)
MBAR_INST <- lf_mbar(W_INST)
stopifnot(length(CELLS_INST) == 4L, EPS_INST == EPS_LOCALISE,
          MBAR_INST == 60L)
message(sprintf(paste("phi band: instrument L = %d, cells %s, eps_varrho =",
                      "%.3f, m-bar = %d"),
                length(CELLS_INST), paste(iv$counts, collapse = "/"),
                EPS_INST, MBAR_INST))

lad <- readRDS(file.path(IN, "app_tsp_ladder.rds"))
stopifnot(identical(lad$headline_dz, HEADLINE_DZ), identical(lad$n, n),
          identical(lad$x_coord, "rank"))
# The BINARY theta-hat of stage 2, kept for the L = 2 comparison arm below.
theta_hat_L2 <- lad$fits[[as.character(HEADLINE_DZ)]]$theta

## theta-hat AT L = 4 COMES FROM STAGE 8, NOT FROM A FRESH FIT HERE.
##
## phi-hat is the plug-in second stage GIVEN theta-hat (prp:plugin), so the
## theta it is plugged in at must be the theta the paper REPORTS -- which for
## the four-category instrument is stage 8's, at d_Z = 5 and eps_varrho = 0.01.
## Re-estimating it here would put a SECOND four-category theta-hat at the same
## rung into the paper, differing from the first only by which partition streams
## it drew, and Section 6 would print both.
##
## THE DEPENDENCY IS 8 -> 5, AND IT IS NOT A CYCLE.  Stage 8 reads this stage's
## band, but only for a reporting scale and only `if (file.exists(band_path))`.
## So stage 8 runs first and this stage runs second; on a run where the band
## changes cardinality, stage 8 is re-run afterwards so its scale is taken from
## the band of the same cardinality.  app_tsp_run_all.R orders them that way.
loc_path <- file.path(IN, "app_tsp_localise.rds")
if (!file.exists(loc_path)) {
  stop("phi band: quality_reports/application/app_tsp_localise.rds is missing. ",
       "Stage 8 supplies the four-category theta-hat this stage plugs in; run ",
       "app_tsp_08_localise.R first.")
}
loc <- readRDS(loc_path)
stopifnot(identical(as.integer(loc$d_z), as.integer(HEADLINE_DZ)),
          identical(as.integer(loc$n), as.integer(n)),
          identical(as.integer(loc$cells), as.integer(CELLS_INST)),
          isTRUE(all.equal(loc$eps_main, EPS_INST)))
theta_hat <- loc$theta_L4
stopifnot(length(theta_hat) == HEADLINE_DZ + 1L, all(is.finite(theta_hat)))
message(sprintf("phi band: theta-hat (L = 4, stage 8) const = %.5f", theta_hat[1]))

xc     <- make_x_coord(dt$x1_raw, dt$x2_raw, mode = "rank")
xev    <- lad$xeval                       # the rank-space grid stage 2 used
x_grid <- lad$phi_x_ugm3                  # the same grid in mu-g/m^3
x_med  <- stats::median(c(dt$x1_raw, dt$x2_raw))
n_grid <- length(x_grid)
stopifnot(n_grid == N_XEVAL, all(diff(x_grid) > 0))

#' Normalise a curve to zero at a given point of the physical grid.
#'
#' @param phi numeric. Curve values on `grid`.
#' @param grid numeric. Strictly increasing physical grid, mu-g/m^3.
#' @param x0 numeric(1). Anchor point.
#' @return numeric, same length as `phi`.
normalise_at <- function(phi, grid, x0) {
  phi - stats::approx(grid, phi, xout = x0, rule = 2)$y
}

## THE BINARY CURVE, kept for the comparison and for the stage-2 regression
## test.  `phi_point` -- the curve the figure draws and the table tabulates --
## is set BELOW, from the four-category full-sample arm, once the arms exist.
## It was this line until 2026-08-12, which was correct only while the reported
## instrument and stage 2's were the same one.
phi_point_L2 <- normalise_at(as.vector(lad$phi$phiev), x_grid, x_med)

# ---- Full-sample arms, one per X coordinate ---------------------------------
#
# The baseline arm reuses stage 2's theta-hat and is asserted to reproduce
# stage 2's curve, so the point estimate on the figure does not move.  The two
# rescaled arms re-estimate theta in their own coordinate at the same B = 10 so
# that the only thing differing across the three is the coordinate.

FULL_CKPT <- file.path(OUT, "app_tsp_phi_full_ckpt.rds")
FULL_CFG <- list(
  seed = SEED_PHIBAND, d_z = HEADLINE_DZ, K = N_FOLDS, n_part = N_PART,
  cste = LF_CSTE, imax = MBAR_INST, patience = MBAR_INST,
  tau_dp = TAU_DP, rho = RHO, x_grid = x_grid, n = n,
  ## THE INSTRUMENT IS IN THE FINGERPRINT.  Without it a cache built at L = 2
  ## would be reused at L = 4 -- the cardinality changes what every replication
  ## COMPUTES, which is exactly what this key is for.
  ## The instrument itself, not a summary of it: 983 integers cost nothing in
  ## an .rds and identical() on them is exact, where a hash would need a
  ## dependency and a count would collide.
  cells = CELLS_INST, eps_rho = EPS_INST, w = as.integer(W_INST),
  theta_L4 = theta_hat,
  src = unname(tools::md5sum(here::here(
    "scripts", "R", c("lf_panel.R", "orthogonal_theta.R")))),
  data = unname(tools::md5sum(here::here("data", "raw", "data_tsp.txt"))),
  driver = c(paste(deparse(fit_orthogonal), collapse = "\n"),
             paste(deparse(phi_second_stage), collapse = "\n"),
             paste(deparse(make_x_coord), collapse = "\n"))
)

#' Full-sample phi-hat in one X coordinate, at one cardinality.
#'
#' @param mode character(1). "rank", "ugm3" or "minmax".
#' @param stream integer vector. L'Ecuyer anchor for this arm.
#' @param theta numeric or NULL. NULL re-estimates theta in this coordinate.
#' @param w vector. The instrument. Defaults to the four-category trigger.
#' @param cells integer vector. Its declared cell set.
#' @param mbar integer or NULL. The Landweber cap; NULL reads it from the
#'   cardinality, which is the calibrated default (C4).  It is an ARGUMENT from
#'   2026-08-14 so that an L = 2 arm can be run at the L = 4 cap, which is the
#'   only way to compare the two curves at one regularisation level.
#' @return named list: theta, phi (normalised, on the physical grid), m_phi,
#'   and `feasible`.  An INFEASIBLE arm returns feasible = FALSE with the
#'   reason and NA curves rather than raising.
#'
#' ---------------------------------------------------------------------------
#' WHY THIS CAN NOW RETURN INSTEAD OF SUCCEEDING, 2026-08-15.  The x-direction
#' kernel is C3's family at p_K = 8, and a higher-order kernel density estimate
#' CAN GO NEGATIVE where the design is sparse.  make_operator() refuses to build
#' an operator whose pi-hat is not strictly positive, because the adjoint
#' divides by it -- so a coordinate in which pi-hat touches zero is not a
#' coordinate this estimator can run in, and that is a FINDING about the
#' coordinate, not an accident.
#'
#' On this design it is exactly the two RESCALED coordinates.  In mu-g/m^3 and
#' min--max the pooled TSP design is concentrated, |X|/h_x = 57.7 against 12.3
#' in the rank coordinate, and the renormalised order-2 kernel already put
#' min pi-hat at 4.9e-05 -- four orders below the mean density, i.e. the adjoint
#' was already dividing by a number indistinguishable from zero.  At p_K = 8 the
#' negative lobes turn that into -5.3e-05 at isolated design points on some fold
#' draws.  The rank coordinate, which is what the paper reports, sits at
#' min pi-hat = 0.538 over the same fold draws and is nowhere near the boundary
#' of feasibility.
#'
#' READ AS A STATEMENT ABOUT C1(ii), which is what it is: pi bounded away from
#' zero on X is an ASSUMPTION, and it is the rank coordinate that satisfies it
#' here.  The stage records the infeasible arms and continues; it does not
#' substitute a floor on pi-hat, which would be a different estimator, and it
#' does not silently drop the rows.
full_sample_arm <- function(mode, stream, theta = NULL, w = W_INST,
                            cells = CELLS_INST, mbar = NULL) {
  assign(".Random.seed", stream, envir = globalenv())
  xcm <- make_x_coord(dt$x1_raw, dt$x2_raw, mode = mode)
  # The baseline reuses stage 2's rank grid verbatim; the rescaled arms map the
  # same physical grid through their own coordinate.
  xevm <- if (mode == "rank") xev else xcm$fwd(x_grid)
  Zm <- make_design(dt, HEADLINE_DZ)
  eps <- eps_for(w)
  if (is.null(mbar)) mbar <- lf_mbar(w)
  infeasible <- function(msg) {
    list(theta = NULL, phi = rep(NA_real_, n_grid),
         phi_raw = rep(NA_real_, length(xevm)), m_phi = NA_integer_,
         argmin = NA_integer_, stop_rule = NA_character_, L = NA_integer_,
         eps_rho = eps, mbar = mbar, bind_rate = NA_real_,
         min_pre = NA_real_, route = NA_character_, mode = mode,
         feasible = FALSE, message = msg)
  }
  got <- tryCatch({
    if (is.null(theta)) {
      fit <- fit_orthogonal(dt$dy, xcm$x1, xcm$x2, Zm, w, dt$cluster,
                            K = N_FOLDS, n_part = N_PART, cste = LF_CSTE,
                            init_fn = init_control, lf_imax = mbar,
                            lf_patience = mbar, rho = RHO,
                            xeval = xevm, n_cores = N_CORES, eps_rho = eps)
      theta <- fit$theta
    }
    phi_second_stage(dt$dy, xcm$x1, xcm$x2, Zm, w, theta,
                     cste = LF_CSTE, init_fn = init_control,
                     xeval = xevm, lf_imax = mbar,
                     eps_rho = eps, n_t = N_T,
                     bier_seed = BIER_SEED, t_scale = T_SCALE,
                     adj_wtil = ADJ_WTIL, conditional = TRUE,
                     tau_dp = TAU_DP, cells = cells)
  }, error = \(e) structure(conditionMessage(e), class = "arm_error"))
  if (inherits(got, "arm_error")) return(infeasible(as.character(got)))
  ph <- got
  list(theta = theta, phi = normalise_at(as.vector(ph$phiev), x_grid, x_med),
       phi_raw = as.vector(ph$phiev), m_phi = as.integer(ph$iter),
       argmin = as.integer(ph$argmin), stop_rule = ph$stop_rule,
       L = ph$L, eps_rho = eps, mbar = mbar,
       bind_rate = ph$prop_diag$bind_rate, min_pre = ph$prop_diag$min_pre,
       route = ph$prop_diag$route, mode = mode, feasible = TRUE,
       message = "")
}

arms <- NULL
if (file.exists(FULL_CKPT)) {
  old <- readRDS(FULL_CKPT)
  if (identical(old$cfg, FULL_CFG)) {
    arms <- old$arms
    message("phi band: reusing cached full-sample arms")
  } else {
    message("phi band: full-sample cache discarded, configuration changed")
  }
}

if (is.null(arms)) {
  arms <- vector("list", length(COORD_LABEL) + 2L)                   # INV-17
  names(arms) <- c(names(COORD_LABEL), "rank_L2", "rank_L2_m60")
  for (j in seq_along(COORD_LABEL)) {
    md <- names(COORD_LABEL)[j]
    t0 <- Sys.time()
    arms[[md]] <- full_sample_arm(
      md, ARM_STREAM[[j]], theta = if (md == "rank") theta_hat else NULL)
    if (isTRUE(arms[[md]]$feasible)) {
      message(sprintf("full-sample arm %-7s %5.0fs  m_phi = %4d  th[1] = %8.4f",
                      md, as.numeric(difftime(Sys.time(), t0, units = "secs")),
                      arms[[md]]$m_phi, arms[[md]]$theta[1]))
    } else {
      message(sprintf("full-sample arm %-7s %5.0fs  INFEASIBLE: %s",
                      md, as.numeric(difftime(Sys.time(), t0, units = "secs")),
                      arms[[md]]$message))
    }
  }
  ## THE BINARY COMPARISON ARM, ADDED 2026-08-12 WITH THE INSTRUMENT SWITCH.
  ##
  ## It does two jobs and both are load-bearing.  (1) It is the CURVE the paper
  ## compares the four-category one against -- "what did moving to L = 4 do to
  ## phi-hat" needs both curves computed here, on one grid, at one anchor.
  ## (2) It KEEPS THE STAGE-2 REGRESSION TEST ALIVE.  That assertion below used
  ## to be made on the reported arm, and it cannot be any more: stage 2's
  ## phi-hat is binary and the reported arm is not.  Dropping the assertion
  ## would have removed the only check that this stage and stage 2 agree about
  ## the estimator; re-basing it onto this arm keeps it exactly as strong.
  ##
  ## It runs at the BINARY theta-hat, eps and cap -- eps_for() and lf_mbar()
  ## read them off `dt$w` -- so it is stage 2's second stage in every respect.
  ## It reuses the rank anchor: same coordinate, same grid, and no bootstrap
  ## replication's anchor moves.
  t0 <- Sys.time()
  arms[["rank_L2"]] <- full_sample_arm("rank", ARM_STREAM[[1L]],
                                       theta = theta_hat_L2, w = dt$w,
                                       cells = cells_of(dt$w))
  message(sprintf("full-sample arm %-7s %5.0fs  m_phi = %4d  th[1] = %8.4f",
                  "rank_L2", as.numeric(difftime(Sys.time(), t0, units = "secs")),
                  arms[["rank_L2"]]$m_phi, arms[["rank_L2"]]$theta[1]))
  ## THE ONE-FACTOR BINARY ARM, ADDED 2026-08-14.  DIAGNOSTIC ONLY: it changes
  ## no reported number and no band.
  ##
  ## `rank_L2` above runs at the CARDINALITY-TIED cap lf_mbar(dt$w) = 15 while
  ## the reported arm runs at 60, so the phi-hat comparison Section 6 draws
  ## between L = 4 and L = 2 varies TWO factors -- the instrument and the
  ## regularisation -- exactly as tab:app-theta did before stage 8 was put on a
  ## common cap.  This arm is the same binary second stage at m-bar = 60, so the
  ## difference between it and the reported curve is the CARDINALITY alone, and
  ## the difference between it and `rank_L2` is the CAP alone.  It costs one
  ## second-stage solve.  Which of the two the paper reports is the writer's
  ## call; both are in the artifact and the ruling scoped the table, not the
  ## curve, so nothing is switched here.
  t0 <- Sys.time()
  arms[["rank_L2_m60"]] <- full_sample_arm("rank", ARM_STREAM[[1L]],
                                           theta = theta_hat_L2, w = dt$w,
                                           cells = cells_of(dt$w),
                                           mbar = MBAR_INST)
  message(sprintf("full-sample arm %-11s %5.0fs  m_phi = %4d  th[1] = %8.4f",
                  "rank_L2_m60",
                  as.numeric(difftime(Sys.time(), t0, units = "secs")),
                  arms[["rank_L2_m60"]]$m_phi,
                  arms[["rank_L2_m60"]]$theta[1]))
  saveRDS(list(cfg = FULL_CFG, arms = arms), FULL_CKPT)
}

## THE THREE ARMS THE REPORTED CURVE DEPENDS ON MUST BE FEASIBLE; THE TWO
## RESCALED COORDINATES NEED NOT BE.  This is the asymmetry the stage now
## carries: `rank`, `rank_L2` and `rank_L2_m60` are the paper's curve and its two
## comparison curves, and a failure there is a defect that must stop the run.
## `ugm3` and `minmax` are a robustness comparison, and at p_K = 8 their pi-hat
## is not bounded away from zero on this design (see full_sample_arm()'s note),
## which is a property of the coordinate rather than of the code.
INFEASIBLE <- names(arms)[!vapply(arms, \(a) isTRUE(a$feasible), logical(1))]
if (length(intersect(INFEASIBLE, c("rank", "rank_L2", "rank_L2_m60")))) {
  stop(sprintf(paste("phi band: a REPORTED arm is infeasible (%s).  The",
                     "rank-coordinate curve is what Section 6 states, so this",
                     "is a stop, not a finding."),
               paste(intersect(INFEASIBLE, c("rank", "rank_L2",
                                             "rank_L2_m60")),
                     collapse = ", ")))
}
if (length(INFEASIBLE)) {
  message(sprintf(paste("phi band: %d coordinate arm(s) INFEASIBLE at p_K = %d",
                        "and reported as such: %s"),
                  length(INFEASIBLE), P_K_X, paste(INFEASIBLE, collapse = ", ")))
}

# VALIDATION.  The BINARY arm must reproduce stage 2's curve exactly; if it ever
# stops doing so, the estimator has moved under this stage and the pipeline must
# stop rather than quietly redraw the figure.  Re-based from the reported arm to
# the binary one on 2026-08-12, when the reported arm became four-category --
# stage 2 is binary, so only the binary arm can reproduce it.
dev_point <- max(abs(arms[["rank_L2"]]$phi_raw - as.vector(lad$phi$phiev)))
message(sprintf("stage-2 reproduction (BINARY arm): max |phi_new - phi_stage2| = %.3e",
                dev_point))
stopifnot(dev_point < 1e-6)

# THE REPORTED POINT ESTIMATE.  The four-category full-sample curve, already
# normalised at the pooled median by full_sample_arm().  Asserted to agree with
# the binary arm's own normalisation route so the two curves are comparable
# point by point.
phi_point <- arms$rank$phi
stopifnot(length(phi_point) == n_grid, all(is.finite(phi_point)))
stopifnot(max(abs(arms[["rank_L2"]]$phi - phi_point_L2)) < 1e-6)

# The movement the instrument switch produces in the full-sample curve, on the
# physical grid and after the common normalisation.  Reported, not asserted:
# this is one of the numbers Section 6 has to state.
phi_switch_sup <- max(abs(arms$rank$phi - arms[["rank_L2"]]$phi))
phi_switch_l2  <- sqrt(mean((arms$rank$phi - arms[["rank_L2"]]$phi)^2))
message(sprintf(paste("instrument switch L=2 -> L=4 [TWO FACTORS: cardinality",
                      "AND cap]: sup |dphi| = %.5f, L2 |dphi| = %.5f;",
                      "m_phi %d -> %d"),
                phi_switch_sup, phi_switch_l2,
                arms[["rank_L2"]]$m_phi, arms$rank$m_phi))
## THE SAME SWITCH AT A COMMON CAP, AND THE CAP'S OWN CONTRIBUTION.  The first
## number varies the cardinality alone; the second varies the cap alone; the
## two-factor number above is the composition of them, which is why it is
## labelled rather than reported bare.
phi_switch_sup_1f <- max(abs(arms$rank$phi - arms[["rank_L2_m60"]]$phi))
phi_switch_l2_1f  <- sqrt(mean((arms$rank$phi - arms[["rank_L2_m60"]]$phi)^2))
phi_cap_sup <- max(abs(arms[["rank_L2_m60"]]$phi - arms[["rank_L2"]]$phi))
message(sprintf(paste("  at a COMMON cap m-bar = %d [ONE FACTOR]: sup |dphi| =",
                      "%.5f, L2 |dphi| = %.5f"),
                MBAR_INST, phi_switch_sup_1f, phi_switch_l2_1f))
message(sprintf("  the cap's own contribution at L = 2 (%d vs %d): sup |dphi| = %.5f",
                MBAR_INST, lf_mbar(dt$w), phi_cap_sup))
message(sprintf("propensity truncation: L=4 bind rate %.4f (min pre %.5f); L=2 %.4f (min pre %.5f)",
                arms$rank$bind_rate, arms$rank$min_pre,
                arms[["rank_L2"]]$bind_rate, arms[["rank_L2"]]$min_pre))

# ---- Bootstrap --------------------------------------------------------------

# Design F's replication count and partition count.  Both are deliberate: 25
# replications because F costs roughly ten times a C replication, and ONE
# partition because F's job is to give an UPPER BOUND on the theta channel
# rather than to reproduce theta-hat (see design note (d) above).
N_BOOT_F    <- 25L
N_PART_BOOT <- 1L

# Panel C's band-width column compares the three coordinates on the FIRST
# N_SCALE replications of each, which are the same counties in all three
# because the L'Ecuyer anchors are shared.  A paired comparison on 25 draws is
# what that cell needs; the reported band still uses all N_BOOT.  C1b is run to
# N_SCALE only -- it is the slowest design per replication and contributes
# nothing but that one cell.
N_SCALE <- 25L

DESIGNS <- list(
  list(id = "C0",  coord = "rank",   refit = FALSE, n_part = NA_integer_,
       n_rep = N_BOOT),
  list(id = "C1a", coord = "ugm3",   refit = FALSE, n_part = NA_integer_,
       n_rep = N_BOOT),
  list(id = "C1b", coord = "minmax", refit = FALSE, n_part = NA_integer_,
       n_rep = N_SCALE),
  list(id = "F",   coord = "rank",   refit = TRUE,  n_part = N_PART_BOOT,
       n_rep = N_BOOT_F)
)
stopifnot(N_BOOT_F <= N_BOOT, N_SCALE <= N_BOOT)
## A DESIGN WHOSE FULL-SAMPLE COORDINATE ARM IS INFEASIBLE IS DROPPED, NOT RUN
## EMPTY.  Its replications are fixed at that arm's theta-hat, which does not
## exist; running them would be 99 draws of the same error, recorded as a
## bootstrap failure rate that is really a coordinate infeasibility.  Which
## designs were dropped, and why, is carried in the .rds and printed here.
DESIGNS_DROPPED <- Filter(\(dg) dg$coord %in% INFEASIBLE, DESIGNS)
DESIGNS <- Filter(\(dg) !(dg$coord %in% INFEASIBLE), DESIGNS)
stopifnot(any(vapply(DESIGNS, \(dg) identical(dg$id, "C0"), logical(1))),
          any(vapply(DESIGNS, \(dg) identical(dg$id, "F"), logical(1))))
if (length(DESIGNS_DROPPED)) {
  message(sprintf(paste("phi band: bootstrap designs %s dropped -- their",
                        "coordinate arm is infeasible at p_K = %d"),
                  paste(vapply(DESIGNS_DROPPED, \(dg) dg$id, character(1)),
                        collapse = ", "), P_K_X))
}

#' The value fingerprint of one design's replications.
#'
#' Everything that changes what a replication COMPUTES is in it; the number of
#' replications is not, because replication b is the same object whether 25 or
#' 99 of them are run.  Keyed per design so that changing one design does not
#' discard another's completed work.
design_cfg <- function(dg, shared) {
  c(shared, list(coord = dg$coord, refit = dg$refit, n_part = dg$n_part,
                 theta = arms[[dg$coord]]$theta))
}

#' One bootstrap replication of the phi-hat curve.
#'
#' Resamples counties with replacement, rebuilds the coordinate map on the
#' resample, optionally re-estimates theta by the cross-fitted orthogonal
#' one-step, runs the plug-in second stage with the stopping index re-selected,
#' and returns the curve on the FIXED physical grid, re-anchored at the
#' replication's own pooled median.
#'
#' @param b integer(1). Replication index; selects the L'Ecuyer stream.
#' @param streams list. Output of make_streams().
#' @param design list. One element of DESIGNS.
#' @param theta_fixed numeric. Full-sample theta for the design's coordinate,
#'   used when design$refit is FALSE.
#' @return named list: rep, design, status, conv, phi, theta, m_phi, x_med,
#'   m_theta_med, lf_cap, lf_at_one, secs, message.
boot_replicate <- function(b, streams, design, theta_fixed) {
  assign(".Random.seed", streams[[b]], envir = globalenv())
  t0 <- Sys.time()
  out <- list(rep = b, design = design$id, coord = design$coord,
              status = "ok", conv = NA_character_,
              phi = rep(NA_real_, n_grid), theta = rep(NA_real_,
                                                       length(theta_fixed)),
              m_phi = NA_integer_, x_med = NA_real_,
              m_theta_med = NA_real_, lf_cap = NA_integer_,
              lf_at_one = NA_integer_, secs = NA_real_, message = "")

  idx <- sample.int(n, n, replace = TRUE)
  db <- dt[idx, , drop = FALSE]

  got <- tryCatch({
    xcb <- make_x_coord(db$x1_raw, db$x2_raw, mode = design$coord)
    xevb <- xcb$fwd(x_grid)
    Zb <- make_design(db, HEADLINE_DZ)
    th <- theta_fixed
    lfc <- NA_integer_; lfo <- NA_integer_; mth <- NA_real_
    ## THE CELL SET AND THE CAP COME FROM THE FULL SAMPLE, NOT FROM `db`.
    ##
    ## `db` is a with-replacement resample, so its realised cell set is a random
    ## object.  Reading L off it would let a replication that misses the
    ## 66-county cell run a THREE-cell estimator and be recorded as a
    ## replication of the four-cell one -- with a different cap (lf_mbar is 30
    ## at L = 3, 60 at L = 4) and a different truncation.  Passing the declared
    ## set makes conditional_parts() raise on such a draw, which
    ## boot_replicate() then records as status "error" and Panel B counts.  That
    ## is the intended behaviour: a degenerate draw is a countable event, not a
    ## silently different estimator.
    if (isTRUE(design$refit)) {
      fb <- fit_orthogonal(db$dy, xcb$x1, xcb$x2, Zb, db[[INST_COL]],
                           db$cluster,
                           K = N_FOLDS, n_part = design$n_part, cste = LF_CSTE,
                           init_fn = init_control, lf_imax = MBAR_INST,
                           lf_patience = MBAR_INST, rho = RHO,
                           xeval = xevb, n_cores = 1L, eps_rho = EPS_INST)
      th <- fb$theta
      lfc <- fb$lf_hit_cap; lfo <- fb$lf_at_one; mth <- fb$lf_m_median
    }
    ph <- phi_second_stage(db$dy, xcb$x1, xcb$x2, Zb, db[[INST_COL]], th,
                           cste = LF_CSTE, init_fn = init_control,
                           xeval = xevb, lf_imax = MBAR_INST,
                           eps_rho = EPS_INST, n_t = N_T,
                           bier_seed = BIER_SEED, t_scale = T_SCALE,
                           adj_wtil = ADJ_WTIL, conditional = TRUE,
                           tau_dp = TAU_DP, cells = CELLS_INST)
    xm <- stats::median(c(db$x1_raw, db$x2_raw))
    list(phi = normalise_at(as.vector(ph$phiev), x_grid, xm), theta = th,
         m_phi = as.integer(ph$iter), x_med = xm,
         lf_cap = lfc, lf_at_one = lfo, m_theta_med = mth)
  }, error = \(e) structure(conditionMessage(e), class = "boot_error"))

  out$secs <- as.numeric(difftime(Sys.time(), t0, units = "secs"))
  if (inherits(got, "boot_error")) {
    out$status <- "error"
    out$message <- as.character(got)
    return(out)
  }
  out[names(got)] <- got
  if (!all(is.finite(got$phi))) {
    out$status <- "nonfinite"
    return(out)
  }
  # Convergence of the SECOND-STAGE LF pass.  phi_second_stage() surfaces only
  # the argmin, which is enough to separate the two pathologies: an argmin of 1
  # means phi-hat is the initial condition, an argmin at the cap means the
  # discrepancy was still falling when the iteration was stopped.
  out$conv <- if (got$m_phi <= 1L) "start" else
    if (got$m_phi >= MBAR_INST) "cap" else "interior"
  out
}

# WORKER COUNT.  Stage 5 uses fewer workers than the rest of the application.
# A second-stage solve on all n = 983 observations holds six n-by-n matrices
# from make_operator() plus the n-by-n temporaries of operator_residual(),
# which measures at roughly 0.9 GB resident per worker.  Eight of those on the
# four physical cores this was run on left the machine with tens of megabytes
# free and swapping, and each worker then ran at about two thirds of a core --
# fewer workers finish the same queue sooner.
#
# This is a THROUGHPUT knob and nothing else: every replication draws from its
# own L'Ecuyer anchor (STREAMS), so the numbers below are identical at any
# worker count.  That is the whole reason make_streams() exists.
## OVERRIDABLE FROM THE ENVIRONMENT, 2026-08-12.  The default stays 4 -- it was
## measured on a four-physical-core host and is right there -- but this stage
## became roughly four times as expensive when the instrument moved to L = 4
## (the cap goes 15 -> 60), and on a larger host the memory argument above binds
## at a higher worker count.  Raising it is SAFE IN THE STRONGEST SENSE: every
## replication draws from its own L'Ecuyer anchor, so the output is
## worker-count independent by construction, which is the whole reason
## make_streams() exists.  Nothing in any fingerprint depends on it.
N_CORES_BAND <- as.integer(Sys.getenv("APP_TSP_BAND_CORES", unset = "4"))
stopifnot(is.finite(N_CORES_BAND), N_CORES_BAND >= 1L)

# The part of the fingerprint every design shares.
SHARED_CFG <- list(
  seed = SEED_PHIBAND, d_z = HEADLINE_DZ, K = N_FOLDS, cste = LF_CSTE,
  imax = MBAR_INST, patience = MBAR_INST, tau_dp = TAU_DP,
  cells = CELLS_INST, eps_rho = EPS_INST, w = as.integer(W_INST),
  rho = RHO, x_grid = x_grid, n = n,
  src = FULL_CFG$src, data = FULL_CFG$data,
  driver = c(FULL_CFG$driver,
             paste(deparse(boot_replicate), collapse = "\n"),
             paste(deparse(normalise_at), collapse = "\n"))
)

dir.create(PARTS, showWarnings = FALSE, recursive = TRUE)

# STREAMS (set at the top of the script) gives one anchor per replication,
# SHARED ACROSS DESIGNS, so replication b draws the same counties in every
# design and the decomposition of the width is paired.  It is also core-count
# independent by construction: mclapply's own stream assignment depends on
# mc.cores, which would make every number here a function of the host.

part_path <- function(id, b) {
  file.path(PARTS, sprintf("part_%s_%03d.rds", id, b))
}

for (dg in DESIGNS) {
  cfg_file <- file.path(PARTS, sprintf("cfg_%s.rds", dg$id))
  cfg <- design_cfg(dg, SHARED_CFG)
  if (file.exists(cfg_file) && !identical(readRDS(cfg_file), cfg)) {
    message(sprintf("design %-3s: cache discarded, configuration changed",
                    dg$id))
    unlink(list.files(PARTS, pattern = sprintf("^part_%s_", dg$id),
                      full.names = TRUE))
  }
  saveRDS(cfg, cfg_file)

  todo <- which(!file.exists(vapply(seq_len(dg$n_rep),
                                    \(b) part_path(dg$id, b), character(1))))
  if (!length(todo)) {
    message(sprintf("design %-3s: all %d replications cached", dg$id,
                    dg$n_rep))
    next
  }
  message(sprintf("design %-3s (%s, theta %s): %d of %d replications to run",
                  dg$id, dg$coord, if (dg$refit) "re-estimated" else "fixed",
                  length(todo), dg$n_rep))
  t0 <- Sys.time()
  invisible(parallel::mclapply(todo, \(b) {
    r <- boot_replicate(b, STREAMS, dg, arms[[dg$coord]]$theta)
    saveRDS(r, part_path(dg$id, b))
    NULL
  }, mc.cores = N_CORES_BAND, mc.preschedule = FALSE))
  message(sprintf("design %-3s done in %.0f min", dg$id,
                  as.numeric(difftime(Sys.time(), t0, units = "mins"))))
}

#' Read one design's replication records and assemble its band.
#'
#' @param dg list. One element of DESIGNS.
#' @return named list: recs, phi (matrix n_ok x n_grid), q (4 x n_grid),
#'   sd, med, counts, n_ok.
collect_design <- function(dg) {
  id <- dg$id
  recs <- lapply(seq_len(dg$n_rep), \(b) readRDS(part_path(id, b)))
  ok <- vapply(recs, \(z) identical(z$status, "ok"), logical(1))
  P <- matrix(NA_real_, sum(ok), n_grid)                             # INV-17
  rep_id <- integer(sum(ok))
  j <- 0L
  for (r in recs[ok]) {
    j <- j + 1L
    P[j, ] <- r$phi
    rep_id[j] <- r$rep
  }
  q <- matrix(NA_real_, length(BAND_PROBS), n_grid)                  # INV-17
  for (g in seq_len(n_grid)) {
    q[, g] <- stats::quantile(P[, g], probs = BAND_PROBS, names = FALSE)
  }
  status <- vapply(recs, \(z) z$status, character(1))
  conv <- vapply(recs, \(z) z$conv %||% NA_character_, character(1))
  list(id = id, recs = recs, phi = P, q = q, n_rep = dg$n_rep,
       rep_id = rep_id,
       sd = apply(P, 2, stats::sd), med = apply(P, 2, stats::median),
       n_ok = sum(ok),
       n_error = sum(status == "error"),
       n_nonfinite = sum(status == "nonfinite"),
       n_start = sum(conv == "start", na.rm = TRUE),
       n_cap = sum(conv == "cap", na.rm = TRUE),
       n_interior = sum(conv == "interior", na.rm = TRUE),
       m_phi = vapply(recs, \(z) z$m_phi %||% NA_integer_, integer(1)),
       x_med = vapply(recs, \(z) z$x_med %||% NA_real_, numeric(1)),
       secs = vapply(recs, \(z) z$secs, numeric(1)),
       messages = unique(vapply(recs[status == "error"],
                                \(z) z$message, character(1))))
}

bands <- lapply(DESIGNS, collect_design)
names(bands) <- vapply(DESIGNS, \(d) d$id, character(1))

# The REPORTED band is C0: theta held at theta-hat.  Design F bounds what that
# leaves out; see design note (d) in the header.
bf <- bands[["C0"]]
stopifnot(bf$n_ok >= 2L, bands[["F"]]$n_ok >= 2L)

for (bd in bands) {
  message(sprintf(paste("design %-3s: %d/%d finite; %d error, %d non-finite;",
                        "conv %d interior / %d start / %d cap"),
                  bd$id, bd$n_ok, bd$n_rep, bd$n_error, bd$n_nonfinite,
                  bd$n_interior, bd$n_start, bd$n_cap))
}

# ---- Why so many replications stop at m = 1 ---------------------------------
#
# The full-sample second stage stops at an interior 188.  A large share of the
# bootstrap replications stop at 1 instead, which means the LF step never fired
# and phi-hat* is the initial condition.  Two explanations are available and
# they have opposite implications:
#
#   (i)  SAMPLE SIZE.  A resample simply carries less information than the
#        sample, and the discrepancy has no interior minimum at that
#        information level.  The band would then be reporting something real.
#   (ii) TIES.  Drawing n counties from n with replacement duplicates roughly
#        37 per cent of them, and every duplicate is an EXACT tie in X.  The
#        integration matrix build_int_matrix() gives a tied pair a zero-width
#        interval and the survival matrices give it a zero distance, so the
#        operator the LF iteration inverts is not the operator the estimator
#        was designed around.  The band would then be an artefact of the
#        resampling scheme.
#
# These are separated by drawing SUBSAMPLES WITHOUT REPLACEMENT of size
# n(1 - 1/e) = 621, the expected number of DISTINCT counties in a
# with-replacement resample of size n.  A subsample carries strictly less
# information than the resample it is matched to -- fewer rows, no duplicated
# rows -- so if the subsamples stop at an interior index while the resamples
# stop at 1, sample size is exonerated and ties are implicated.
#
# This block has its own checkpoint and is NOT part of BOOT_CFG, so adding it
# does not invalidate a single bootstrap replication.

N_TIE <- 24L
N_SUB <- as.integer(round(n * (1 - exp(-1))))
stopifnot(N_TIE <= N_TIE_MAX)

#' One without-replacement subsample solve, for the ties diagnostic.
#'
#' @param b integer(1). Draw index; selects a stream past the replication block.
#' @return named list: rep, n_sub, m_phi, status.
tie_replicate <- function(b) {
  assign(".Random.seed", TIE_STREAM[[b]], envir = globalenv())
  idx <- sample.int(n, N_SUB, replace = FALSE)
  ds <- dt[idx, , drop = FALSE]
  got <- tryCatch({
    xcs <- make_x_coord(ds$x1_raw, ds$x2_raw, mode = "rank")
    ph <- phi_second_stage(ds$dy, xcs$x1, xcs$x2, make_design(ds, HEADLINE_DZ),
                           ds[[INST_COL]], arms$rank$theta, cste = LF_CSTE,
                           init_fn = init_control, xeval = xcs$fwd(x_grid),
                           lf_imax = MBAR_INST,
                           eps_rho = EPS_INST, n_t = N_T,
                           bier_seed = BIER_SEED, t_scale = T_SCALE,
                           adj_wtil = ADJ_WTIL, conditional = TRUE,
                           tau_dp = TAU_DP, cells = CELLS_INST)
    list(m_phi = as.integer(ph$iter), status = "ok")
  }, error = \(e) list(m_phi = NA_integer_, status = "error"))
  c(list(rep = b, n_sub = N_SUB), got)
}

TIE_CKPT <- file.path(OUT, "app_tsp_phi_tie_ckpt.rds")
TIE_CFG <- list(seed = SEED_PHIBAND, n_tie = N_TIE, n_sub = N_SUB,
                theta = arms$rank$theta, x_grid = x_grid, imax = MBAR_INST,
                cells = CELLS_INST, eps_rho = EPS_INST,
                src = FULL_CFG$src, data = FULL_CFG$data,
                driver = paste(deparse(tie_replicate), collapse = "\n"))

tie <- NULL
if (file.exists(TIE_CKPT)) {
  old_tie <- readRDS(TIE_CKPT)
  if (identical(old_tie$cfg, TIE_CFG)) tie <- old_tie$tie
}
if (is.null(tie)) {
  message(sprintf("ties diagnostic: %d subsamples of %d counties", N_TIE,
                  N_SUB))
  t0 <- Sys.time()
  tie <- parallel::mclapply(seq_len(N_TIE), tie_replicate,
                            mc.cores = N_CORES_BAND, mc.preschedule = FALSE)
  saveRDS(list(cfg = TIE_CFG, tie = tie), TIE_CKPT)
  message(sprintf("ties diagnostic done in %.0f min",
                  as.numeric(difftime(Sys.time(), t0, units = "mins"))))
}

tie_m <- vapply(tie, \(z) z$m_phi, integer(1))
tie_ok <- sum(vapply(tie, \(z) identical(z$status, "ok"), logical(1)))
tie_at_one <- sum(tie_m <= 1L, na.rm = TRUE)
message(sprintf("ties diagnostic: %d/%d subsamples at m = 1 (median m = %s)",
                tie_at_one, tie_ok, fmt(stats::median(tie_m, na.rm = TRUE), 0)))

# ---- Table ------------------------------------------------------------------
#
# Panel A: the curve at deciles of the pooled X distribution (C16), plus the
# 5th and 95th percentiles, which are the endpoints of the reported grid.  The
# deciles are the natural grid here because the estimator's working coordinate
# IS the pooled CDF, so they are equally spaced in the coordinate the operator
# uses.  Levels are clamped into the grid range so that no row extrapolates.

tab_x <- as.vector(stats::quantile(c(dt$x1_raw, dt$x2_raw), TAB_PROBS))
message(sprintf(paste("grid endpoints: table [%.2f, %.2f] vs curve",
                      "[%.2f, %.2f] mu-g/m^3"),
                tab_x[1], tab_x[length(tab_x)], x_grid[1], x_grid[n_grid]))
stopifnot(abs(tab_x[1] - x_grid[1]) < 2,
          abs(tab_x[length(tab_x)] - x_grid[n_grid]) < 2)
tab_x <- pmin(pmax(tab_x, x_grid[1]), x_grid[n_grid])

#' Linear interpolation of a curve onto the tabulated levels.
at_levels <- function(v) stats::approx(x_grid, v, xout = tab_x, rule = 2)$y

tab <- data.frame(
  prob   = TAB_PROBS,
  tsp    = tab_x,
  phi    = at_levels(phi_point),
  bmed   = at_levels(bf$med),
  sd     = at_levels(bf$sd),
  lo     = at_levels(bf$q[1, ]),
  hi     = at_levels(bf$q[4, ]),
  n70    = vapply(tab_x, \(v) sum(abs(dt$x1_raw - v) <= SUPPORT_WINDOW),
                  integer(1)),
  n80    = vapply(tab_x, \(v) sum(abs(dt$x2_raw - v) <= SUPPORT_WINDOW),
                  integer(1)),
  stringsAsFactors = FALSE
)

prob_label <- function(p) {
  ifelse(abs(p - 0.5) < 1e-12, "50 (anchor)",
         formatC(100 * p, format = "g"))
}

#' fmt() with signed zeros removed.
#'
#' The anchor row is zero by construction, and floating-point cancellation
#' leaves it at -1e-17, which fmt() renders as "-0.0000".  Values that round to
#' zero at the requested precision are printed unsigned.
fmt0 <- function(x, d = 3) {
  fmt(ifelse(is.finite(x) & abs(x) < 0.5 * 10^(-d), abs(x), x), d)
}

panel_a <- sprintf("%s & %s & %s & %s & %s & %s & %s & %s & %s \\\\",
                   prob_label(tab$prob), fmt0(tab$tsp, 1), fmt0(tab$phi, 4),
                   fmt0(tab$bmed, 4), fmt0(tab$sd, 4), fmt0(tab$lo, 4),
                   fmt0(tab$hi, 4), formatC(tab$n70, format = "d"),
                   formatC(tab$n80, format = "d"))

#' Median width of a design's outer (5th to 95th percentile) envelope.
#'
#' @param bd list. One element of `bands`.
#' @param k integer or NULL. Use only replications with index <= k, so that
#'   designs run to different replication counts can be compared on the same
#'   draws (the anchors are shared, so replication b is the same counties in
#'   every design).  NULL uses all of them.
width_of <- function(bd, k = NULL) {
  keep <- if (is.null(k)) rep(TRUE, nrow(bd$phi)) else bd$rep_id <= k
  stopifnot(sum(keep) >= 2L)
  P <- bd$phi[keep, , drop = FALSE]
  lo <- apply(P, 2, stats::quantile, probs = BAND_PROBS[1], names = FALSE)
  hi <- apply(P, 2, stats::quantile,
              probs = BAND_PROBS[length(BAND_PROBS)], names = FALSE)
  stats::median(hi - lo)
}

# Panel B: the design, and what it produced.  Row labels are kept short so that
# the first column stays narrow enough for Panel A to fit the text width; what
# each row MEANS belongs in the manuscript's table note, not in the fragment
# (INV-13).
sec_tot <- sum(unlist(lapply(bands, \(b) b$secs)), na.rm = TRUE)
mphi_ok <- bf$m_phi[vapply(bf$recs, \(z) identical(z$status, "ok"), logical(1))]
panel_b <- c(
  sprintf("Replications drawn & \\multicolumn{8}{l}{%d} \\\\", N_BOOT),
  sprintf("Replications with a finite curve & \\multicolumn{8}{l}{%d} \\\\",
          bf$n_ok),
  sprintf("Failures: error / non-finite & \\multicolumn{8}{l}{%d / %d} \\\\",
          bf$n_error, bf$n_nonfinite),
  sprintf(paste("$\\hat m_\\varphi$: median [min, max]",
                "& \\multicolumn{8}{l}{%s [%s, %s]} \\\\"),
          fmt(stats::median(mphi_ok), 0), fmt(min(mphi_ok), 0),
          fmt(max(mphi_ok), 0)),
  sprintf(paste("Retained with $\\hat m_\\varphi = 1$",
                "& \\multicolumn{8}{l}{%d} \\\\"), bf$n_start),
  sprintf(paste("Retained with $\\hat m_\\varphi = \\bar m$",
                "& \\multicolumn{8}{l}{%d} \\\\"), bf$n_cap),
  sprintf(paste("S.d.\\ of the anchor across resamples",
                "& \\multicolumn{8}{l}{%s} \\\\"),
          fmt(stats::sd(bf$x_med, na.rm = TRUE), 2)),
  sprintf(paste("Share at $\\hat m_\\varphi = 1$: resample of $n$ /",
                "subsample of %d & \\multicolumn{8}{l}{%d of %d / %d of %d}",
                "\\\\"), N_SUB, bf$n_start, bf$n_ok, tie_at_one, tie_ok),
  "\\addlinespace",
  sprintf(paste("$\\theta$ re-estimated as well ($B=%d$): replications",
                "& \\multicolumn{8}{l}{%d, %d finite} \\\\"), N_PART_BOOT,
          bands[["F"]]$n_rep, bands[["F"]]$n_ok),
  sprintf(paste("$\\theta$ re-estimated: band width on the same draws",
                "& \\multicolumn{8}{l}{%s vs.\\ %s} \\\\"),
          fmt(width_of(bands[["F"]], N_BOOT_F), 4),
          fmt(width_of(bf, N_BOOT_F), 4)),
  sprintf(paste("$\\theta$-step fold solves at the cap (median of %d)",
                "& \\multicolumn{8}{l}{%s} \\\\"), N_FOLDS * N_PART_BOOT,
          fmt(stats::median(vapply(bands[["F"]]$recs,
                                   \(z) z$lf_cap %||% NA_integer_,
                                   integer(1)), na.rm = TRUE), 0)))

# Panel C: the same normalised curve recomputed in two other X coordinates.
# Both maps are strictly increasing, so in population the three curves coincide
# on the mu-g/m^3 axis; the deviation is entirely estimator artefact.
scale_row <- function(md, band_id) {
  ## AN INFEASIBLE COORDINATE PRINTS ONE CELL, NOT SIX BLANKS.  The row has to
  ## stay -- deleting it would leave the reader to infer from a two-row table
  ## that only two coordinates were ever tried -- and it must not print a
  ## number, because none was computed.  See full_sample_arm()'s note for what
  ## infeasible means here: pi-hat is not bounded away from zero in that
  ## coordinate at p_K = 8, so the operator cannot be built.
  if (!isTRUE(arms[[md]]$feasible)) {
    return(sprintf(paste("%s & \\multicolumn{6}{l}{Infeasible: $\\hat\\pi$",
                         "not bounded away from zero} & & \\\\"),
                   COORD_LABEL[[md]]))
  }
  d <- arms[[md]]$phi - phi_point
  ratio <- d / pmax(bf$sd, .Machine$double.eps)
  sprintf("%s & %s & %s & %s & %s & %s & %s & & \\\\",
          COORD_LABEL[[md]], fmt0(max(abs(d)), 3),
          fmt0(sqrt(mean(d^2)), 3), fmt0(max(abs(ratio)), 2),
          fmt0(sqrt(mean(ratio^2)), 2),
          sprintf("%d/%d", sum(diff(arms[[md]]$phi) > 0), n_grid - 1L),
          fmt0(width_of(bands[[band_id]], N_SCALE), 3))
}
panel_c <- c(
  sprintf(paste("Coordinate & Max $|\\Delta|$ & RMS $\\Delta$ & Max/SD &",
                "RMS/SD & Steps up & Band width, %d paired draws & & \\\\"),
          N_SCALE),
  scale_row("rank", "C0"), scale_row("ugm3", "C1a"),
  scale_row("minmax", "C1b"))

write_tabular(
  "lrrrrrrrr",
  c(paste("& & & & & \\multicolumn{2}{c}{Bootstrap envelope} &",
          "\\multicolumn{2}{c}{Counties within $\\pm5\\,\\mu$g/m$^3$} \\\\"),
    "\\cmidrule(lr){6-7} \\cmidrule(lr){8-9}",
    paste("Pctile of $X$ & TSP & $\\hat\\varphi(x)-\\hat\\varphi(x_{0.5})$ &",
          "Bootstrap median & Bootstrap s.d. & 5th & 95th & 1970 & 1980 \\\\")),
  c(paste0("\\multicolumn{9}{l}{\\textit{Panel A: $\\hat\\varphi$ at deciles ",
           "of the pooled $X$ distribution}} \\\\"),
    "\\midrule", panel_a, "\\addlinespace",
    paste0("\\multicolumn{9}{l}{\\textit{Panel B: bootstrap design and ",
           "convergence}} \\\\"),
    "\\midrule", panel_b, "\\addlinespace",
    paste0("\\multicolumn{9}{l}{\\textit{Panel C: the same normalised curve ",
           "recomputed in two other $X$ coordinates}} \\\\"),
    "\\midrule", panel_c),
  file.path(TAB, "app_tsp_phi.tex"))

# ---- Figure -----------------------------------------------------------------
#
# Everything the previous version got right is kept: the point estimate, the
# two-period rug, the median normalisation, serif type, no title inside the
# panel (INV-12 -- the title belongs in the LaTeX caption).  The band is added
# BENEATH the point estimate, in unmapped grey with dotted edges, so it reads
# as an envelope and not as a confidence region: no colour, no legend entry,
# no fill scale.

thm <- theme_minimal(base_family = "serif", base_size = 10) +
  theme(panel.grid.minor = element_blank(),
        strip.text = element_text(face = "bold"),
        legend.position = "bottom")

phi_dt <- data.frame(tsp = x_grid, phi = phi_point)
band_dt <- data.frame(tsp = x_grid, lo95 = bf$q[1, ], lo50 = bf$q[2, ],
                      hi50 = bf$q[3, ], hi95 = bf$q[4, ], bmed = bf$med)
rug_dt <- data.frame(tsp = c(dt$x1_raw, dt$x2_raw),
                     period = rep(c("1970", "1980"), each = n))
rug_dt <- rug_dt[rug_dt$tsp >= min(x_grid) & rug_dt$tsp <= max(x_grid), ]

p_phi <- ggplot(phi_dt, aes(tsp, phi)) +
  geom_ribbon(data = band_dt, aes(x = tsp, ymin = lo95, ymax = hi95),
              inherit.aes = FALSE, fill = "grey65", alpha = 0.18) +
  geom_ribbon(data = band_dt, aes(x = tsp, ymin = lo50, ymax = hi50),
              inherit.aes = FALSE, fill = "grey50", alpha = 0.22) +
  geom_line(data = band_dt, aes(x = tsp, y = lo95), inherit.aes = FALSE,
            linetype = "dotted", linewidth = 0.3, colour = "grey30") +
  geom_line(data = band_dt, aes(x = tsp, y = hi95), inherit.aes = FALSE,
            linetype = "dotted", linewidth = 0.3, colour = "grey30") +
  geom_hline(yintercept = 0, colour = "grey60", linewidth = 0.3) +
  # The bootstrap MEDIAN curve.  It is drawn because the distance between it
  # and the point estimate is the finding: if the two coincide, the resampling
  # reproduces the estimator; if they do not, it does not, and no envelope
  # around either one should be read as sampling uncertainty.
  geom_line(data = band_dt, aes(x = tsp, y = bmed), inherit.aes = FALSE,
            linetype = "longdash", linewidth = 0.4, colour = "grey25") +
  geom_line(linewidth = 0.7) +
  geom_rug(data = rug_dt, aes(x = tsp, colour = period, linetype = period),
           inherit.aes = FALSE, sides = "b", alpha = 0.25,
           length = unit(2, "mm")) +
  scale_colour_brewer(palette = "Set2") +
  labs(x = expression(paste("Mean total suspended particulates (", mu,
                            "g/m"^3, ")")),
       y = expression(paste(hat(varphi), "(x) - ", hat(varphi),
                            "(median x)")),
       colour = "Period", linetype = "Period") +
  thm
ggsave(file.path(FIG, "app_tsp_phi.pdf"), p_phi, width = 6.0, height = 3.6,
       device = grDevices::cairo_pdf)

# ---- Saved object -----------------------------------------------------------

saveRDS(list(x_grid = x_grid, x_med = x_med, phi_point = phi_point,
             theta_hat = theta_hat, arms = arms, bands = bands,
             band_probs = BAND_PROBS, tab = tab, n_boot = N_BOOT,
             n_boot_f = N_BOOT_F, n_part_boot = N_PART_BOOT,
             reported_band = "C0", tie = tie, n_sub = N_SUB,
             headline_dz = HEADLINE_DZ, secs_total = sec_tot,
             ## THE CARDINALITY THIS BAND IS AT.  Recorded so a downstream
             ## consumer can CHECK it rather than assume it: stage 6 compares
             ## its multiplier band against this one, and comparing across
             ## cardinalities would be a scheme comparison confounded with an
             ## instrument comparison.  Stage 6 asserts on this field.
             L = length(CELLS_INST), cells = CELLS_INST, eps_rho = EPS_INST,
             mbar = MBAR_INST, w = as.integer(W_INST),
             inst_counts = iv$counts, inst_labels = iv$labels,
             ## The binary comparison: curve, theta, and the realised movement.
             phi_point_L2 = phi_point_L2, theta_hat_L2 = theta_hat_L2,
             ## TWO FACTORS: `rank_L2` runs at the cardinality-tied cap 15.
             phi_switch_sup = phi_switch_sup, phi_switch_l2 = phi_switch_l2,
             ## ONE FACTOR: the same switch with both arms at m-bar = MBAR_INST,
             ## plus the cap's own contribution at fixed cardinality.  Added
             ## 2026-08-14; nothing above it moved.
             phi_L2_m60 = arms[["rank_L2_m60"]]$phi,
             mbar_L2_tied = as.integer(lf_mbar(dt$w)),
             phi_switch_sup_1f = phi_switch_sup_1f,
             phi_switch_l2_1f = phi_switch_l2_1f,
             phi_cap_sup_L2 = phi_cap_sup,
             ## WHICH COORDINATE ARMS COULD NOT BE ESTIMATED AT p_K = 8, AND
             ## THE REASON EACH GAVE.  Recorded so the writer states the
             ## infeasibility from the artifact rather than from a log line.
             p_K = P_K_X, infeasible_arms = INFEASIBLE,
             infeasible_reason = vapply(arms[INFEASIBLE],
                                        \(a) a$message %||% "", character(1)),
             designs_dropped = vapply(DESIGNS_DROPPED, \(d) d$id,
                                      character(1))),
        file.path(OUT, "app_tsp_phi_band.rds"))

message(sprintf("done: app_tsp_05_phi_band (%.1f core-hours)",
                sec_tot / 3600))
