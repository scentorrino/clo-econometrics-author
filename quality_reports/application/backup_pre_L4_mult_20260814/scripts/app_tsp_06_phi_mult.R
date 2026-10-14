# ============================================================================
# app_tsp_06_phi_mult.R
#
# Section 6, stage 6: a MULTIPLIER BOOTSTRAP for phi-hat (design "M"), and the
# head-to-head against the pairs bootstrap of stage 5 (design "C0").
#
#   paper/tables/app_tsp_phi_boot_compare.tex   C0 vs M on five outcomes
#   paper/tables/app_tsp_phi_mult.tex           the M band, IF M wins (see below)
#   paper/figures/app_tsp_phi_mult.pdf          the M figure, IF M wins
#   quality_reports/application/app_tsp_phi_mult.rds
#
# THIS STAGE DOES NOT TOUCH DESIGN C0.  It reads C0's numbers from the object
# stage 5 already wrote (app_tsp_phi_band.rds) and never re-runs it.  Neither
# scripts/R/lf_panel.R nor scripts/R/orthogonal_theta.R is modified, so C0's
# cache fingerprint -- which is an md5 of those two files -- still matches and
# its 99 stored replications survive.  paper/tables/app_tsp_phi.tex and
# paper/figures/app_tsp_phi.pdf are not written here.
#
# ---------------------------------------------------------------------------
# WHAT THE BAND IS, AND WHAT IT IS NOT
#
# Exactly what stage 5 said, and for exactly the same reason.  It is an
# ILLUSTRATIVE VARIABILITY BAND.  It is not a confidence interval, it has no
# coverage claim, and no coverage is computed anywhere below.
#
# THE MULTIPLIER SCHEME INHERITS NO VALIDITY GUARANTEE HERE.  Chen and Pouzo's
# multiplier bootstrap for nonlinear, nonparametric conditional-moment models
# is indexed by a DETERMINISTIC sieve dimension.  The regularisation index of
# this estimator is the Landweber-Fridman discrepancy rule's argmin, a RANDOM
# STOPPING TIME.  Changing the resampling scheme from multinomial to Exp(1)
# weights does nothing whatsoever to that gap: the obstruction is the stopping
# rule, not the weights.  Nobody should read the switch to a multiplier scheme
# as importing Chen-Pouzo validity.  It does not.
#
# ---------------------------------------------------------------------------
# WHY THIS DESIGN EXISTS -- the hypothesis it settles
#
# Design C0 produced a band whose 5-95 envelope straddles zero at all eleven
# reported deciles, and 40 of its 99 replications did not produce an NPIV
# estimate at all: 28 stopped at m-phi-hat = 1, where phi-hat IS the initial
# condition and the LF step never fired, and 12 ran to the 2000-iteration cap.
#
# Stage 5's own ties diagnostic points at the cause.  Twenty-four subsamples
# drawn WITHOUT REPLACEMENT at size 621 -- the expected number of DISTINCT
# counties in a with-replacement resample of 983 -- gave only 3 of 24 at
# m-phi-hat = 1, with median 182 against the full sample's 188.  A strictly
# smaller sample with no duplicates converges like the full sample; a same-size
# resample with roughly 37 per cent duplicates does not.
#
# The mechanism is that duplicated counties put mass at coincident X values.
# build_int_matrix() gives a tied pair a zero-width trapezoid interval and the
# survival matrices give it a zero distance, so the operator the LF iteration
# inverts is not the operator the estimator was designed around.
#
# A multiplier bootstrap perturbs WEIGHTS instead of duplicating SUPPORT
# POINTS.  The design is unchanged: all 983 counties are present, all X values
# are distinct exactly as often as in the sample, and M1, M2 and the survival
# matrices are built on the same support.  So the prediction under test is:
#
#   THE STOPPING-INDEX DISTRIBUTION SHOULD BE FAR HEALTHIER THAN C0'S, close
#   to the without-replacement subsample diagnostic.
#
# If it is, the pairs scheme was contributing much of the band's width.  If it
# is not, the width is real and attributable to the estimator rather than the
# resampling scheme.  Both answers are reported; neither is preferred.
#
# ---------------------------------------------------------------------------
# THE VERDICT RULE, FIXED BEFORE THE RUN
#
# A NARROW BAND IS NOT ON ITS OWN GOOD NEWS.  The scale-sensitivity arm of
# app_tsp_robustness.tex is the cautionary case: its tightest bands, 0.025 and
# 0.038, came from configurations in which the LF step never fired at all.  A
# band can be narrow because the procedure is stable or because the procedure
# collapsed to its initial condition, and only the stopping-index distribution
# tells the two apart.
#
# So the verdict is decided on the STOPPING INDEX ALONE, and the rule is fixed
# here rather than chosen after seeing the width.  Design M is judged the
# better scheme if and only if all three hold:
#
#   (V1) the share at m-phi-hat = 1 is below half of C0's 28/99 = 28.3%,
#        i.e. below 14.1%; the without-replacement benchmark is 3/24 = 12.5%;
#   (V2) the share at the cap is no worse than C0's 12/99 = 12.1%;
#   (V3) the median m-phi-hat is within a factor of two of the full sample's
#        188, i.e. in [94, 376].
#
# Band width is deliberately NOT in the rule.  It is an OUTCOME reported
# against the rule, never an input to it.  The M table and figure are written
# only if the verdict passes; which band the paper ultimately reports is the
# author's decision, not this script's, so the C0 outputs are left in place
# either way and the two live side by side.
#
# ---------------------------------------------------------------------------
# BOOTSTRAP DESIGN -- every choice, stated, and matched to C0 except one
#
# (a) WHAT IS PERTURBED.  One weight per COUNTY, w_i i.i.d. Exp(1), i = 1..983,
#     normalised to mean one.  Both periods of a county share its weight: the
#     county is the unit A0 treats as i.i.d. and the unit the estimator's own
#     cross-fitting splits on, exactly the unit C0 resamples.  Exp(1) has mean
#     1 and variance 1, matching the first two moments of the multinomial
#     weights C0 induces, so the two schemes differ in WHAT they perturb
#     (mass vs. support) and not in how hard they perturb it.
#
#     NORMALISATION: the weights are divided by their mean, so they sum to n.
#     Both conventions are in use.  The choice is immaterial here in a stronger
#     sense than usual -- app_tsp_weighted.R's verification asserts that the
#     weighted estimator is EXACTLY invariant to rescaling all weights (the
#     realised deviation is 0), because every weighted average in the layer is
#     self-normalised and the discrepancy path is scaled by a constant, which
#     an argmin does not see.  It is normalised anyway so that the weighted
#     Horvitz-Thompson and Hajek forms coincide and the layer's internals are
#     easier to read.
#
# (b) THE COORDINATE MAP (C2) IS HELD AT ITS FULL-SAMPLE VALUE.  This is the
#     ONE place design M departs from C0, and it is a departure C0 could not
#     have made.
#
#     The argument.  C2 is not a normalisation, it is a REGULARISATION CHOICE:
#     in mu-g/m^3 the composite operator's squared norm is 5.8e3, so the
#     convergence bound is 2/||A||^2 = 3.4e-4 and lf_panel.R's default step of
#     0.5 exceeds it by a factor of 1.5e3, which drives max|d-phi-hat| to 1.3e3
#     log points against 0.21 in the coordinate used.  (Corrected 2026-08-05;
#     this comment previously said 3.3e4 and "diverges after one step", and the
#     discrepancy in fact falls on step one.  See app_tsp_07_opnorm.R.)
#     The map is chosen so the estimator runs at all, which
#     puts it in the same category as a bandwidth or a ridge -- and holding a
#     tuning constant fixed across bootstrap replications is the ordinary
#     thing to do.  Conditioning on it also buys something real: the
#     second-stage grid is then IDENTICAL in every replication, so differences
#     between curves are differences in the estimate and not in where it was
#     evaluated.  C0 could not have this, because a with-replacement resample
#     changes the support and therefore the empirical CDF whether one likes it
#     or not, which is precisely why stage 5 had to rebuild the map and
#     compare on a fixed physical grid instead.
#
#     The cost.  The band is then conditional on a full-sample quantity and
#     omits whatever variability the map itself contributes.  That cost is
#     MEASURED, not asserted: design "M2" repeats M with the map rebuilt from
#     the WEIGHTED empirical CDF (make_x_coord_wtd()), at N_MAP = 25
#     replications drawing the SAME WEIGHTS as M's first 25, so the comparison
#     is paired and the only thing differing is the map.  This is the same
#     device design F used to bound the theta channel in C0.
#
# (c) THE STOPPING INDEX IS RE-SELECTED IN EVERY REPLICATION, as in C0.  It is
#     part of the estimator, not a tuning constant, and it is the primary
#     outcome of this whole exercise, so freezing it would answer the question
#     by assumption.
#
# (d) THETA IS HELD AT ITS FULL-SAMPLE VALUE, as in C0, and the theta channel
#     is NOT re-run.  Stage 5's design F already measured it: re-estimating
#     theta gave a band of 0.309 against C0's 0.610 on the same draws, i.e.
#     the theta channel is not what limits phi-hat.  Re-running it under
#     multiplier weights would cost roughly a day of wall time to re-answer a
#     question already answered.  A consequence worth stating: because theta is
#     fixed, crossfit_once() is never called in a replication, so the
#     cross-fitting fold averages are not exercised and are NOT weighted by
#     app_tsp_weighted.R.  A multiplier bootstrap that re-estimated theta would
#     need that layer extended first.
#
# (e) FAILED REPLICATIONS ARE COUNTED, NOT DROPPED, with C0's five statuses:
#     ok / error / nonfinite, and among the ok, interior / start / cap.  Every
#     replication returning a finite curve is retained, including start and
#     cap.  Discarding them is the anti-conservative choice and would also
#     destroy the primary outcome.
#
# (f) THE BAND IS A POINTWISE PERCENTILE ENVELOPE (C15), the same one C0 uses.
#
# (g) NORMALISATION OF THE CURVE.  phi-hat(x) - phi-hat(median x), re-anchored
#     at EACH replication's own pooled median, as in C0.  Under weights that
#     median is the WEIGHTED pooled median (wmedian()), each county
#     contributing its weight to both period values.
#
# ---------------------------------------------------------------------------
# WHERE THE WEIGHTS ENTER
#
# In app_tsp_weighted.R, which replaces the empirical measure P-hat_n by
# P-hat_n^w inside a private copy of the estimator's environment.  Its header
# lists every average that is weighted, every average that is deliberately NOT
# weighted because it is grid quadrature rather than an expectation, and every
# average that is off this path.  Read it before changing anything here.
#
# The layer is verified against the untouched estimator on the FULL SAMPLE
# below, not just in the abstract: at w == 1 it must reproduce
# phi_second_stage() including its stopping index, and it must be exactly
# invariant to the weight scale.
#
# Wall time: roughly one to three hours on four physical cores.  Replication
# records are written one file per replication under
# quality_reports/application/app_tsp_phi_mult_parts/, keyed on a per-design
# configuration fingerprint, so an interrupted run resumes and a table edit
# costs nothing.
# ============================================================================

library(here)
library(parallel)
library(ggplot2)

source(here::here("scripts", "R", "lf_panel.R"))
source(here::here("scripts", "R", "orthogonal_theta.R"))
source(here::here("scripts", "application", "app_tsp_common.R"))
source(here::here("scripts", "application", "app_tsp_weighted.R"))

RNGkind("L'Ecuyer-CMRG")
set.seed(SEED_PHIMULT)                                               # INV-14

# Deterministic L'Ecuyer anchors, drawn BEFORE anything else consumes the
# stream, so a cached checkpoint and a cold run produce the same numbers.  The
# validation arm comes first so that its presence does not move any replication
# anchor.  Designs M and M2 SHARE the replication anchors and each draws its
# weights as the first thing it does, so replication b has identical weights in
# both and the map comparison is paired.
# The information-matched subsample arm's anchors come LAST in the chain, so
# that adding it does not move an anchor any replication had already used and
# the cached M and M2 replications stay valid.
N_VALID   <- 1L
N_SUB_MAX <- 64L
ANCHOR  <- make_streams(N_VALID + N_BOOT + N_SUB_MAX)
VALID_STREAM <- ANCHOR[[1L]]
STREAMS <- ANCHOR[N_VALID + seq_len(N_BOOT)]
SUB_STREAM <- ANCHOR[N_VALID + N_BOOT + seq_len(N_SUB_MAX)]

TAB   <- here::here("paper", "tables")
FIG   <- here::here("paper", "figures")
OUT   <- here::here("quality_reports", "application")
PARTS <- file.path(OUT, "app_tsp_phi_mult_parts")
dir.create(PARTS, showWarnings = FALSE, recursive = TRUE)

HEADLINE_DZ  <- 5L
N_CORES_BAND <- 4L      # memory-bound, see stage 5's note; a throughput knob
                        # only -- every replication has its own anchor

# Verdict thresholds, fixed here and evaluated after the run (see the header).
V1_START_MAX <- 0.5     # share at m = 1, as a fraction of C0's share
V3_FACTOR    <- 2       # median m-phi-hat within this factor of the full sample

# ---- Data, and everything stage 5 already computed --------------------------
#
# Read, never recompute.  Re-running stage 5's full-sample arms here would
# rewrite its checkpoint and put paper/tables/app_tsp_phi.tex at risk.

pan <- load_tsp_panel()
dt  <- pan$dt
n   <- nrow(dt)

band5 <- readRDS(file.path(OUT, "app_tsp_phi_band.rds"))
stopifnot(identical(band5$headline_dz, HEADLINE_DZ),
          identical(band5$reported_band, "C0"))

# ---------------------------------------------------------------------------
# CARDINALITY GUARD, 2026-08-12.  THIS STAGE IS BINARY-ONLY AND STAGE 5 IS NOT.
#
# What this stage produces is a COMPARISON: the multiplier band (design M)
# against stage 5's pairs band (design C0), to settle whether the width of the
# reported band is a property of the estimator or of the resampling scheme.
# That question is only answerable if the two arms estimate the SAME object.
# Stage 5 moved to the four-category instrument on 2026-08-12; this stage
# cannot follow, and the blocker is specific and named:
#
#   w_operator_residual() in app_tsp_weighted.R is BINARY-ONLY BY DECLARATION.
#   It stops at L >= 3 with "the weighted layer is BINARY-ONLY (L = 2) ...
#   Generalizing it is an estimator decision, not a typing fix. Author call."
#   `scal = wbar(1 - wbar)`, `wtil` a vector and `pi_w` unimplemented are all
#   binary there, where the base engine sets scal = 1 at L >= 3 (lf_panel.R:458)
#   and carries the l-weights of B1(iv.d).
#
# The generalization is mechanical GIVEN those base decisions -- it is the
# base's L-general branch written in the weighted metric, with `n` replaced by
# `sum(wt)` and the noise level by n_eff -- but it is guarded by an explicit
# deferral that a previous pass placed deliberately, so it is NOT taken here.
#
# Running anyway would compare an L = 2 multiplier band against an L = 4 pairs
# band and print the difference as a scheme effect.  That is the failure this
# guard exists to make impossible, so it STOPS rather than warns: a red
# pipeline on a named blocker is better than a green one on an incoherent
# comparison.
if (!is.null(band5$L) && !identical(as.integer(band5$L), 2L)) {
  stop(sprintf(paste0(
    "app_tsp_06_phi_mult.R is BINARY-ONLY but stage 5's band is at L = %d.\n",
    "  Blocker: w_operator_residual() in app_tsp_weighted.R refuses L >= 3 by\n",
    "  declaration ('Author call'), so the multiplier arm cannot be re-based\n",
    "  onto the four-category instrument without that ruling.\n",
    "  Until then the shipped app_tsp_phi_mult.tex and\n",
    "  app_tsp_phi_boot_compare.tex remain valid as L = 2 statements and must\n",
    "  be read as such; they are NOT about the reported band."),
    as.integer(band5$L)))
}

theta_hat <- band5$arms$rank$theta
x_grid    <- band5$x_grid
x_med     <- band5$x_med
phi_point <- band5$phi_point
n_grid    <- length(x_grid)
stopifnot(n_grid == N_XEVAL, all(diff(x_grid) > 0),
          length(phi_point) == n_grid)

# The FIXED coordinate map and the FIXED rank grid.  Every design-M replication
# evaluates here; C0's replications each evaluated at xcb$fwd(x_grid) in their
# own rebuilt map, so this is the same construction with the map held still.
xc      <- make_x_coord(dt$x1_raw, dt$x2_raw, mode = "rank")
xev_fix <- xc$fwd(x_grid)
Z_full  <- make_design(dt, HEADLINE_DZ)
stopifnot(all(diff(xev_fix) > 0))

#' Normalise a curve to zero at a given point of the physical grid.
#'
#' Identical to stage 5's; restated rather than imported so that this stage
#' does not depend on stage 5's script being sourced.
#'
#' @param phi numeric. Curve values on `grid`.
#' @param grid numeric. Strictly increasing physical grid, mu-g/m^3.
#' @param x0 numeric(1). Anchor point.
#' @return numeric, same length as `phi`.
normalise_at <- function(phi, grid, x0) {
  phi - stats::approx(grid, phi, xout = x0, rule = 2)$y
}

# ---- Verification of the weighted layer, on the full sample -----------------
#
# The single most important check in this file.  At w == 1 the weighted layer
# must reproduce the untouched phi_second_stage() -- same curve, same stopping
# index -- and it must be exactly invariant to the weight scale.  If either
# fails, every number below is meaningless, so this is an assertion and not a
# diagnostic.

WENV <- make_weighted_env()

VAL_CKPT <- file.path(OUT, "app_tsp_phi_mult_valid.rds")
VAL_CFG <- list(
  seed = SEED_PHIMULT, d_z = HEADLINE_DZ, imax = lf_mbar(dt$w),
  tau_dp = TAU_DP, cste = LF_CSTE,
  theta = theta_hat, xeval = xev_fix, n = n,
  src = unname(tools::md5sum(here::here(
    "scripts", "R", c("lf_panel.R", "orthogonal_theta.R")))),
  data = unname(tools::md5sum(here::here("data", "raw", "data_tsp.txt"))),
  layer = paste(vapply(c(WEIGHTED_OVERRIDES, "wsd", "wmean", "wmedian",
                         "make_x_coord_wtd", "phi_second_stage_weighted"),
                       \(f) paste(deparse(get(f)), collapse = "\n"),
                       character(1)), collapse = "\n")
)

val <- NULL
if (file.exists(VAL_CKPT)) {
  old <- readRDS(VAL_CKPT)
  if (identical(old$cfg, VAL_CFG)) {
    val <- old$val
    message("phi mult: reusing cached layer verification")
  } else {
    message("phi mult: verification cache discarded, configuration changed")
  }
}
if (is.null(val)) {
  message("phi mult: verifying the weighted layer on all n = ", n,
          " counties")
  t0 <- Sys.time()
  val <- verify_weighted_layer(WENV, dt$dy, xc$x1, xc$x2, Z_full, dt$w,
                               theta_hat, xev_fix, lf_mbar(dt$w),
                               stream = VALID_STREAM)
  message(sprintf("phi mult: verification done in %.0f min",
                  as.numeric(difftime(Sys.time(), t0, units = "mins"))))
  saveRDS(list(cfg = VAL_CFG, val = val), VAL_CKPT)
}
message(sprintf(paste("layer check: unit-weight dev = %.3e (m = %d vs %d),",
                      "scale dev = %.3e, weights bite by %.3e"),
                val$dev_unit, val$m_unit, val$m_ref, val$dev_scale,
                val$dev_bite))

# ---- Replication ------------------------------------------------------------

DESIGNS <- list(
  list(id = "M",  rebuild_map = FALSE, n_rep = N_BOOT),
  list(id = "M2", rebuild_map = TRUE,  n_rep = N_MAP)
)
stopifnot(N_MAP <= N_BOOT)

#' One multiplier-bootstrap replication of the phi-hat curve.
#'
#' Draws one Exp(1) weight per county, normalises to mean one, optionally
#' rebuilds the coordinate map from the weighted empirical CDF, runs the
#' plug-in second stage under the weighted empirical measure with the stopping
#' index re-selected, and returns the curve on the FIXED physical grid,
#' re-anchored at the replication's own WEIGHTED pooled median.
#'
#' The weights are drawn FIRST, so designs M and M2 see identical weights at
#' the same replication index.
#'
#' @param b integer(1). Replication index; selects the L'Ecuyer stream.
#' @param streams list. Output of make_streams().
#' @param design list. One element of DESIGNS.
#' @param env environment. Output of make_weighted_env().
#' @return named list: rep, design, status, conv, phi, m_phi, x_med, w_cv,
#'   w_max, n_eff, secs, message.
mult_replicate <- function(b, streams, design, env) {
  assign(".Random.seed", streams[[b]], envir = globalenv())
  t0 <- Sys.time()
  out <- list(rep = b, design = design$id, rebuild_map = design$rebuild_map,
              status = "ok", conv = NA_character_,
              phi = rep(NA_real_, n_grid), m_phi = NA_integer_,
              x_med = NA_real_, w_cv = NA_real_, w_max = NA_real_,
              n_eff = NA_real_, secs = NA_real_, message = "")

  wts <- stats::rexp(n, rate = MULT_RATE)
  wts <- wts / mean(wts)
  out$w_cv  <- stats::sd(wts)
  out$w_max <- max(wts)
  # Kish effective sample size, reported so the reader can see how much of the
  # sample a replication is effectively using.  It is NOT used anywhere in the
  # estimator: the bandwidths keep n = 983, which is the direct analogue of
  # C0's resample, whose row count is also n.
  out$n_eff <- sum(wts)^2 / sum(wts^2)

  got <- tryCatch({
    if (isTRUE(design$rebuild_map)) {
      xcb  <- make_x_coord_wtd(dt$x1_raw, dt$x2_raw, wts)
      xevb <- xcb$fwd(x_grid)
      xb1  <- xcb$x1
      xb2  <- xcb$x2
    } else {
      xevb <- xev_fix
      xb1  <- xc$x1
      xb2  <- xc$x2
    }
    ph <- phi_second_stage_weighted(env, dt$dy, xb1, xb2, Z_full, dt$w,
                                    theta_hat, wts = wts, cste = LF_CSTE,
                                    xeval = xevb, lf_imax = lf_mbar(dt$w))
    xm <- wmedian(c(dt$x1_raw, dt$x2_raw), c(wts, wts))
    list(phi = normalise_at(as.vector(ph$phiev), x_grid, xm),
         m_phi = as.integer(ph$iter), x_med = xm)
  }, error = \(e) structure(conditionMessage(e), class = "mult_error"))

  out$secs <- as.numeric(difftime(Sys.time(), t0, units = "secs"))
  if (inherits(got, "mult_error")) {
    out$status <- "error"
    out$message <- as.character(got)
    return(out)
  }
  out[names(got)] <- got
  if (!all(is.finite(got$phi))) {
    out$status <- "nonfinite"
    return(out)
  }
  out$conv <- if (got$m_phi <= 1L) "start" else
    if (got$m_phi >= lf_mbar(dt$w)) "cap" else "interior"
  out
}

SHARED_CFG <- list(
  seed = SEED_PHIMULT, d_z = HEADLINE_DZ, cste = LF_CSTE,
  imax = lf_mbar(dt$w), tau_dp = TAU_DP,
  rho = RHO, rate = MULT_RATE, x_grid = x_grid, xev_fix = xev_fix, n = n,
  theta = theta_hat, src = VAL_CFG$src, data = VAL_CFG$data,
  layer = VAL_CFG$layer,
  driver = c(paste(deparse(mult_replicate), collapse = "\n"),
             paste(deparse(normalise_at), collapse = "\n"))
)

part_path <- function(id, b) {
  file.path(PARTS, sprintf("part_%s_%03d.rds", id, b))
}

for (dg in DESIGNS) {
  cfg_file <- file.path(PARTS, sprintf("cfg_%s.rds", dg$id))
  cfg <- c(SHARED_CFG, list(rebuild_map = dg$rebuild_map))
  if (file.exists(cfg_file) && !identical(readRDS(cfg_file), cfg)) {
    message(sprintf("design %-2s: cache discarded, configuration changed",
                    dg$id))
    unlink(list.files(PARTS, pattern = sprintf("^part_%s_", dg$id),
                      full.names = TRUE))
  }
  saveRDS(cfg, cfg_file)

  todo <- which(!file.exists(vapply(seq_len(dg$n_rep),
                                    \(b) part_path(dg$id, b), character(1))))
  if (!length(todo)) {
    message(sprintf("design %-2s: all %d replications cached", dg$id,
                    dg$n_rep))
    next
  }
  message(sprintf("design %-2s (map %s): %d of %d replications to run", dg$id,
                  if (dg$rebuild_map) "rebuilt" else "fixed", length(todo),
                  dg$n_rep))
  t0 <- Sys.time()
  invisible(parallel::mclapply(todo, \(b) {
    r <- mult_replicate(b, STREAMS, dg, WENV)
    saveRDS(r, part_path(dg$id, b))
    NULL
  }, mc.cores = N_CORES_BAND, mc.preschedule = FALSE))
  message(sprintf("design %-2s done in %.0f min", dg$id,
                  as.numeric(difftime(Sys.time(), t0, units = "mins"))))
}

# ---- Assembly ---------------------------------------------------------------

#' Read one design's replication records and assemble its band.
#'
#' Mirrors stage 5's collect_design() field for field, so the two objects can
#' be put side by side in the comparison table without translation.
#'
#' @param dg list. One element of DESIGNS.
#' @return named list; see the field names below.
collect_design <- function(dg) {
  recs <- lapply(seq_len(dg$n_rep), \(b) readRDS(part_path(dg$id, b)))
  ok <- vapply(recs, \(z) identical(z$status, "ok"), logical(1))
  stopifnot(sum(ok) >= 2L)
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
  list(id = dg$id, recs = recs, phi = P, q = q, n_rep = dg$n_rep,
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
       n_eff = vapply(recs, \(z) z$n_eff %||% NA_real_, numeric(1)),
       secs = vapply(recs, \(z) z$secs, numeric(1)),
       messages = unique(vapply(recs[status == "error"],
                                \(z) z$message, character(1))))
}

bands <- lapply(DESIGNS, collect_design)
names(bands) <- vapply(DESIGNS, \(d) d$id, character(1))
bm <- bands[["M"]]
c0 <- band5$bands[["C0"]]

for (bd in bands) {
  message(sprintf(paste("design %-2s: %d/%d finite; %d error, %d non-finite;",
                        "conv %d interior / %d start / %d cap"),
                  bd$id, bd$n_ok, bd$n_rep, bd$n_error, bd$n_nonfinite,
                  bd$n_interior, bd$n_start, bd$n_cap))
}

# ---- The five reported outcomes ---------------------------------------------

#' Median width of a design's outer (5th to 95th percentile) envelope.
#'
#' @param bd list. One element of `bands`, or stage 5's C0 record.
#' @param k integer or NULL. Use only replications with index <= k. NULL uses
#'   all of them.
#' @return numeric(1).
width_of <- function(bd, k = NULL) {
  keep <- if (is.null(k)) rep(TRUE, nrow(bd$phi)) else bd$rep_id <= k
  stopifnot(sum(keep) >= 2L)
  P <- bd$phi[keep, , drop = FALSE]
  lo <- apply(P, 2, stats::quantile, probs = BAND_PROBS[1], names = FALSE)
  hi <- apply(P, 2, stats::quantile,
              probs = BAND_PROBS[length(BAND_PROBS)], names = FALSE)
  stats::median(hi - lo)
}

tab_x <- as.vector(stats::quantile(c(dt$x1_raw, dt$x2_raw), TAB_PROBS))
tab_x <- pmin(pmax(tab_x, x_grid[1]), x_grid[n_grid])

#' Linear interpolation of a curve onto the tabulated levels.
at_levels <- function(v) stats::approx(x_grid, v, xout = tab_x, rule = 2)$y

#' How many of the tabulated levels have a 5-95 envelope excluding zero.
#'
#' @param bd list. A band record.
#' @return integer(1), out of length(TAB_PROBS).
n_excl_zero <- function(bd) {
  lo <- at_levels(bd$q[1, ])
  hi <- at_levels(bd$q[length(BAND_PROBS), ])
  sum(lo > 0 | hi < 0)
}

#' The five outcomes for one band record, as a named list.
#'
#' @param bd list. A band record from either stage.
#' @return named list of scalars.
outcomes_of <- function(bd) {
  mk <- bd$m_phi[vapply(bd$recs, \(z) identical(z$status, "ok"), logical(1))]
  list(n_rep = bd$n_rep, n_ok = bd$n_ok, n_error = bd$n_error,
       n_nonfinite = bd$n_nonfinite,
       m_med = stats::median(mk), m_min = min(mk), m_max = max(mk),
       n_start = bd$n_start, n_cap = bd$n_cap,
       share_nofit = (bd$n_start + bd$n_cap) / bd$n_ok,
       width_all = width_of(bd), width_25 = width_of(bd, N_MAP),
       n_excl = n_excl_zero(bd),
       med_range = diff(range(bd$med)),
       secs_med = stats::median(bd$secs, na.rm = TRUE))
}

out_m  <- outcomes_of(bm)
out_c0 <- outcomes_of(c0)

# The without-replacement subsample diagnostic stage 5 ran, which is the
# benchmark design M is predicted to approach.  Read, not re-run.
tie_m  <- vapply(band5$tie, \(z) z$m_phi %||% NA_integer_, integer(1))
tie_ok <- sum(vapply(band5$tie, \(z) identical(z$status, "ok"), logical(1)))
tie <- list(n = length(band5$tie), n_ok = tie_ok, n_sub = band5$n_sub,
            m_med = stats::median(tie_m, na.rm = TRUE),
            m_min = min(tie_m, na.rm = TRUE), m_max = max(tie_m, na.rm = TRUE),
            n_start = sum(tie_m <= 1L, na.rm = TRUE),
            n_cap = sum(tie_m >= lf_mbar(dt$w), na.rm = TRUE))

m_full <- band5$arms$rank$m_phi
point_range <- diff(range(phi_point))

# ---- The information-matched subsample: the control that disambiguates ------
#
# Stage 5's ties diagnostic compares a with-replacement resample of 983 against
# a WITHOUT-replacement subsample of 621, and reads the difference as evidence
# that TIES are what break the estimator.  That reading has a confound, and
# design M brings it into the open.
#
# Both resampling schemes lose about half the sample's information.  Kish's
# effective sample size is (sum w)^2 / sum w^2; for the multinomial weights a
# pairs bootstrap induces, and for i.i.d. Exp(1) weights alike, the weight
# variance is one, so n_eff -> n/2 = 492 in BOTH.  The 621-county subsample,
# by contrast, has n_eff = 621 exactly, because its weights are zeros and ones.
# So stage 5's diagnostic varied two things at once: whether points are
# duplicated, AND how much information survives.
#
# Design M holds information fixed at n_eff = 492 and removes duplication.  The
# arm below holds duplication fixed at none and matches information to 492.
# Together the four arms identify the mechanism:
#
#   scheme               duplicates?   n_eff     m-phi-hat = 1 rate
#   pairs, n = 983       yes           492       (C0)
#   Exp(1) weights       no            492       (M)
#   subsample of 492     no            492       (this arm)
#   subsample of 621     no            621       (stage 5)
#
# If M matches C0, duplication is NOT the driver and information loss is, in
# which case the 621 subsample looks healthy simply because it keeps more
# information -- and this arm, at 492, should look unhealthy too.  If instead M
# matches the 492 subsample and both beat C0, duplication IS the driver.
#
# It uses the UNTOUCHED, UNWEIGHTED estimator, exactly as stage 5's diagnostic
# does, and has its own checkpoint so that adding it invalidates nothing.

N_SUB_DRAW <- 24L                      # matches stage 5's N_TIE, so the two
                                       # subsample arms are directly comparable
# Exp(1) has E[w] = E[w^2]/2, so the Kish ratio tends to 1/2.  Deterministic by
# construction rather than read off the realised draws; the realised median is
# reported alongside as a check.
N_SUB_EFF <- as.integer(round(n / 2))
stopifnot(N_SUB_DRAW <= N_SUB_MAX, N_SUB_EFF > 1L, N_SUB_EFF < n)

#' One without-replacement subsample solve at the information-matched size.
#'
#' Mirrors stage 5's tie_replicate() argument for argument, with the subsample
#' size as the only difference: the coordinate map is rebuilt on the subsample
#' (its support really has changed), theta is held at theta-hat, and the
#' stopping index is re-selected.
#'
#' @param b integer(1). Draw index; selects a stream past the replication block.
#' @return named list: rep, n_sub, m_phi, status.
sub_replicate <- function(b) {
  assign(".Random.seed", SUB_STREAM[[b]], envir = globalenv())
  idx <- sample.int(n, N_SUB_EFF, replace = FALSE)
  ds <- dt[idx, , drop = FALSE]
  got <- tryCatch({
    xcs <- make_x_coord(ds$x1_raw, ds$x2_raw, mode = "rank")
    ph <- phi_second_stage(ds$dy, xcs$x1, xcs$x2, make_design(ds, HEADLINE_DZ),
                           ds$w, theta_hat, cste = LF_CSTE,
                           init_fn = init_control, xeval = xcs$fwd(x_grid),
                           lf_imax = lf_mbar(ds$w),
                           eps_rho = EPS_RHO, n_t = N_T,
                           bier_seed = BIER_SEED, t_scale = T_SCALE,
                           adj_wtil = ADJ_WTIL, conditional = TRUE,
                           tau_dp = TAU_DP)
    list(m_phi = as.integer(ph$iter), status = "ok")
  }, error = \(e) list(m_phi = NA_integer_, status = "error"))
  c(list(rep = b, n_sub = N_SUB_EFF), got)
}

SUB_CKPT <- file.path(OUT, "app_tsp_phi_mult_sub_ckpt.rds")
SUB_CFG <- list(seed = SEED_PHIMULT, n_draw = N_SUB_DRAW, n_sub = N_SUB_EFF,
                theta = theta_hat, x_grid = x_grid, imax = lf_mbar(dt$w),
                src = VAL_CFG$src, data = VAL_CFG$data,
                driver = paste(deparse(sub_replicate), collapse = "\n"))

sub <- NULL
if (file.exists(SUB_CKPT)) {
  old_sub <- readRDS(SUB_CKPT)
  if (identical(old_sub$cfg, SUB_CFG)) sub <- old_sub$sub
}
if (is.null(sub)) {
  message(sprintf("information-matched arm: %d subsamples of %d counties",
                  N_SUB_DRAW, N_SUB_EFF))
  t0 <- Sys.time()
  sub <- parallel::mclapply(seq_len(N_SUB_DRAW), sub_replicate,
                            mc.cores = N_CORES_BAND, mc.preschedule = FALSE)
  saveRDS(list(cfg = SUB_CFG, sub = sub), SUB_CKPT)
  message(sprintf("information-matched arm done in %.0f min",
                  as.numeric(difftime(Sys.time(), t0, units = "mins"))))
}

sub_m <- vapply(sub, \(z) z$m_phi %||% NA_integer_, integer(1))
sub_ok <- sum(vapply(sub, \(z) identical(z$status, "ok"), logical(1)))
subeff <- list(n = N_SUB_DRAW, n_ok = sub_ok, n_sub = N_SUB_EFF,
               m_med = stats::median(sub_m, na.rm = TRUE),
               m_min = min(sub_m, na.rm = TRUE),
               m_max = max(sub_m, na.rm = TRUE),
               n_start = sum(sub_m <= 1L, na.rm = TRUE),
               n_cap = sum(sub_m >= lf_mbar(dt$w), na.rm = TRUE))
message(sprintf(paste("information-matched arm: %d/%d at m = 1, %d at the",
                      "cap, median m = %.0f (M's realised Kish n_eff median",
                      "= %.0f)"), subeff$n_start, subeff$n_ok, subeff$n_cap,
                subeff$m_med, stats::median(bm$n_eff, na.rm = TRUE)))

# ---- The verdict ------------------------------------------------------------

## V1 AT THE BOUNDARY, HANDLED EXPLICITLY 2026-08-12.  The rule as written is
## "M's share at m = 1 is below half of C0's", and it was fixed when C0's share
## was 28/99.  After the stopping-rule recalibration (app_tsp_common.R C26) C0's
## share is 0/99, and the rule then reads `0 < 0` -- UNPASSABLE BY CONSTRUCTION.
## An unpassable test that still prints is worse than no test: "V1 FAIL, 0.0% vs
## 0.0%" would be read as evidence against design M when it is a statement about
## arithmetic.
##
## THIS IS NOT A RE-TUNING, AND THE THRESHOLD IS UNTOUCHED.  V1_START_MAX is
## still 0.5 and the strict rule still applies whenever C0 collapses at all.
## What is added is the only defensible reading of "materially better than zero
## collapses": M must also not collapse.  The header's discipline -- the rule is
## fixed before the run, band width is never an input -- is preserved.
##
## FOR THE AUTHOR: the premise of the whole verdict has changed.  Its header
## reasons that "only the stopping-index distribution tells the two apart",
## which was true when both schemes collapsed to the initial condition on a
## sizeable share of replications.  Neither does now.  Whether the stopping
## index is still the right axis to decide M against C0 on is a judgement this
## script should not make silently.
v1 <- if (out_c0$n_start == 0L) {
  out_m$n_start == 0L
} else {
  (out_m$n_start / out_m$n_ok) < V1_START_MAX * (out_c0$n_start / out_c0$n_ok)
}
v2 <- (out_m$n_cap / out_m$n_ok) <= (out_c0$n_cap / out_c0$n_ok)
v3 <- out_m$m_med >= m_full / V3_FACTOR && out_m$m_med <= m_full * V3_FACTOR
verdict <- v1 && v2 && v3

message(sprintf(paste("verdict: V1 share at m=1 %.1f%% vs C0 %.1f%% -> %s;",
                      "V2 cap %.1f%% vs %.1f%% -> %s; V3 median m = %.0f vs",
                      "full-sample %d -> %s; OVERALL %s"),
                100 * out_m$n_start / out_m$n_ok,
                100 * out_c0$n_start / out_c0$n_ok, if (v1) "pass" else "FAIL",
                100 * out_m$n_cap / out_m$n_ok,
                100 * out_c0$n_cap / out_c0$n_ok, if (v2) "pass" else "FAIL",
                out_m$m_med, m_full, if (v3) "pass" else "FAIL",
                if (verdict) "M PREFERRED" else "M NOT PREFERRED"))

# ---- Comparison table -------------------------------------------------------
#
# INV-13: bare tabular, booktabs rules, no float, no caption, no notes.  What
# each row MEANS belongs in the manuscript's table note.

#' fmt() with signed zeros removed.
fmt0 <- function(x, d = 3) {
  fmt(ifelse(is.finite(x) & abs(x) < 0.5 * 10^(-d), abs(x), x), d)
}

#' A dash for a cell the design does not produce.
DASH <- "--"

pct <- function(x) sprintf("%.1f", 100 * x)
# Rounds rather than truncates: the median of an even number of stopping
# indices can land on a half.
int <- function(x) formatC(round(x), format = "d")

# A MEDIAN OF AN EVEN COUNT CAN BE A HALF, AND int() DESTROYS IT ASYMMETRICALLY.
# Added 2026-08-04 after the claim-source pass found the sixth INV-11 mismatch of
# this project: Section 6 reports a median stopping index of 182.5, this table
# printed 182, and the PROSE WAS THE ACCURATE SIDE -- the 24 subsample indices
# give (179+186)/2 = 182.5 exactly.  R rounds half to EVEN, so round(182.5)=182
# rounds DOWN while round(149.5)=150 rounds UP: the same rule, opposite
# directions, at two live cells of this very table.  A reader cannot tell a
# rounded half from an exact integer, and cannot predict which way it went.
# med() prints one decimal only when the value is a half, so integers are
# unchanged and no other cell in the table moves.
med <- function(x) if (isTRUE(all.equal(x %% 1, 0.5))) sprintf("%.1f", x) else int(x)

row5 <- function(label, a, b, c, d, e) {
  sprintf("%s & %s & %s & %s & %s & %s \\\\", label, a, b, c, d, e)
}

panel_a <- c(
  # The first three rows ARE the design.  Reading across them separates the two
  # things stage 5's ties diagnostic varied together: whether a scheme
  # duplicates support points, and how much of the sample's information it
  # keeps.  n(1 - 1/e) = 621 is the expected number of distinct counties a
  # with-replacement resample leaves; n/2 = 492 is the Kish effective size of
  # both random-weight schemes.
  row5("Counties entering a replication", int(n), int(n), int(n),
       int(tie$n_sub), int(subeff$n_sub)),
  row5("Distinct counties, i.e.\\ distinct $X$ values", int(n),
       sprintf("%s (exp.)", int(tie$n_sub)), int(n), int(tie$n_sub),
       int(subeff$n_sub)),
  row5("Kish effective sample size", int(n), int(n / 2),
       int(stats::median(bm$n_eff, na.rm = TRUE)), int(tie$n_sub),
       int(subeff$n_sub)),
  "\\addlinespace",
  row5("Replications drawn", DASH, int(out_c0$n_rep), int(out_m$n_rep),
       int(tie$n), int(subeff$n)),
  row5("Replications with a finite curve", DASH, int(out_c0$n_ok),
       int(out_m$n_ok), int(tie$n_ok), int(subeff$n_ok)),
  row5("Failures: error / non-finite", DASH,
       sprintf("%s / %s", int(out_c0$n_error), int(out_c0$n_nonfinite)),
       sprintf("%s / %s", int(out_m$n_error), int(out_m$n_nonfinite)),
       sprintf("%s / %s", int(tie$n - tie$n_ok), int(0L)),
       sprintf("%s / %s", int(subeff$n - subeff$n_ok), int(0L))),
  "\\addlinespace",
  row5("$\\hat m_\\varphi$: median", med(m_full), med(out_c0$m_med),
       med(out_m$m_med), med(tie$m_med), med(subeff$m_med)),
  row5("$\\hat m_\\varphi$: [min, max]", DASH,
       sprintf("[%s, %s]", int(out_c0$m_min), int(out_c0$m_max)),
       sprintf("[%s, %s]", int(out_m$m_min), int(out_m$m_max)),
       sprintf("[%s, %s]", int(tie$m_min), int(tie$m_max)),
       sprintf("[%s, %s]", int(subeff$m_min), int(subeff$m_max))),
  row5("Retained with $\\hat m_\\varphi = 1$", DASH, int(out_c0$n_start),
       int(out_m$n_start), int(tie$n_start), int(subeff$n_start)),
  row5("Retained with $\\hat m_\\varphi = \\bar m$", DASH, int(out_c0$n_cap),
       int(out_m$n_cap), int(tie$n_cap), int(subeff$n_cap)),
  row5("No NPIV estimate produced (\\%)", DASH, pct(out_c0$share_nofit),
       pct(out_m$share_nofit),
       pct((tie$n_start + tie$n_cap) / tie$n_ok),
       pct((subeff$n_start + subeff$n_cap) / subeff$n_ok)))

panel_b <- c(
  row5("Band width, median over the grid", DASH, fmt0(out_c0$width_all, 3),
       fmt0(out_m$width_all, 3), DASH, DASH),
  row5(sprintf("Band width, first %d replications", N_MAP), DASH,
       fmt0(out_c0$width_25, 3), fmt0(out_m$width_25, 3), DASH, DASH),
  row5(sprintf("Deciles where 5--95 excludes zero (of %d)",
               length(TAB_PROBS)), DASH, int(out_c0$n_excl),
       int(out_m$n_excl), DASH, DASH),
  row5("Range of the curve", fmt0(point_range, 3), fmt0(out_c0$med_range, 3),
       fmt0(out_m$med_range, 3), DASH, DASH),
  row5("Range as a share of the point estimate (\\%)", pct(1),
       pct(out_c0$med_range / point_range),
       pct(out_m$med_range / point_range), DASH, DASH),
  row5("Median seconds per replication", DASH, fmt0(out_c0$secs_med, 0),
       fmt0(out_m$secs_med, 0), DASH, DASH))

panel_c <- c(
  row5("Coordinate map rebuilt: replications", DASH, DASH,
       int(bands[["M2"]]$n_rep), DASH, DASH),
  row5("Coordinate map rebuilt: at $\\hat m_\\varphi = 1$ / at $\\bar m$",
       DASH, DASH, sprintf("%s / %s", int(bands[["M2"]]$n_start),
                           int(bands[["M2"]]$n_cap)), DASH, DASH),
  row5(sprintf("Coordinate map rebuilt: band width, %d paired draws", N_MAP),
       DASH, DASH,
       sprintf("%s vs.\\ %s", fmt0(width_of(bands[["M2"]], N_MAP), 3),
               fmt0(width_of(bm, N_MAP), 3)), DASH, DASH),
  row5("Weight s.d.\\ (population value 1): median", DASH, DASH,
       fmt0(stats::median(vapply(bm$recs, \(z) z$w_cv %||% NA_real_,
                                 numeric(1)), na.rm = TRUE), 3), DASH, DASH))

# Wrapping columns, not `lrrrrr'.  At natural width this table ran 129pt past the
# text block, which put the whole n/2 subsample column off the page along with the
# right edge of every note line -- silently, since an overfull hbox does not touch
# the exit code.  The row labels and the column headings are both prose, so they
# wrap; the cells stay flush right.
write_tabular(
  paste0("@{}p{0.29\\textwidth}",
         paste(rep(">{\\raggedleft\\arraybackslash}p{0.105\\textwidth}", 5),
               collapse = ""), "@{}"),
  c(paste("& Full sample & Pairs (C0) & Multiplier (M) &",
          "\\multicolumn{2}{c}{Subsample, no replacement} \\\\"),
    "\\cmidrule(lr){5-6}",
    paste("& point estimate & with replacement & $\\mathrm{Exp}(1)$ weights &",
          "$n(1-e^{-1})$ & $n/2$ \\\\")),
  c(paste0("\\multicolumn{6}{l}{\\textit{Panel A: what each scheme perturbs, ",
           "and the stopping index it produces}} \\\\"),
    "\\midrule", panel_a, "\\addlinespace",
    paste0("\\multicolumn{6}{l}{\\textit{Panel B: the band}} \\\\"),
    "\\midrule", panel_b, "\\addlinespace",
    paste0("\\multicolumn{6}{l}{\\textit{Panel C: the multiplier design's own ",
           "side-arm}} \\\\"),
    "\\midrule", panel_c),
  file.path(TAB, "app_tsp_phi_boot_compare.tex"))

# ---- The M band's own table and figure --------------------------------------
#
# Written ONLY if the verdict passed, and written to SEPARATE FILES.  C0's
# app_tsp_phi.tex and app_tsp_phi.pdf are never touched: which band the paper
# reports is the author's decision, and both are on disk for that decision to
# be made from.

if (verdict) {
  tab <- data.frame(
    prob = TAB_PROBS, tsp = tab_x, phi = at_levels(phi_point),
    bmed = at_levels(bm$med), sd = at_levels(bm$sd),
    lo = at_levels(bm$q[1, ]), hi = at_levels(bm$q[4, ]),
    n70 = vapply(tab_x, \(v) sum(abs(dt$x1_raw - v) <= SUPPORT_WINDOW),
                 integer(1)),
    n80 = vapply(tab_x, \(v) sum(abs(dt$x2_raw - v) <= SUPPORT_WINDOW),
                 integer(1)),
    stringsAsFactors = FALSE
  )

  prob_label <- function(p) {
    ifelse(abs(p - 0.5) < 1e-12, "50 (anchor)", formatC(100 * p, format = "g"))
  }

  m_ok <- bm$m_phi[vapply(bm$recs, \(z) identical(z$status, "ok"),
                          logical(1))]
  mult_a <- sprintf("%s & %s & %s & %s & %s & %s & %s & %s & %s \\\\",
                    prob_label(tab$prob), fmt0(tab$tsp, 1), fmt0(tab$phi, 4),
                    fmt0(tab$bmed, 4), fmt0(tab$sd, 4), fmt0(tab$lo, 4),
                    fmt0(tab$hi, 4), formatC(tab$n70, format = "d"),
                    formatC(tab$n80, format = "d"))
  mult_b <- c(
    sprintf("Replications drawn & \\multicolumn{8}{l}{%d} \\\\", N_BOOT),
    sprintf("Replications with a finite curve & \\multicolumn{8}{l}{%d} \\\\",
            bm$n_ok),
    sprintf("Failures: error / non-finite & \\multicolumn{8}{l}{%d / %d} \\\\",
            bm$n_error, bm$n_nonfinite),
    sprintf(paste("$\\hat m_\\varphi$: median [min, max]",
                  "& \\multicolumn{8}{l}{%s [%s, %s]} \\\\"),
            int(stats::median(m_ok)), int(min(m_ok)), int(max(m_ok))),
    sprintf(paste("Retained with $\\hat m_\\varphi = 1$",
                  "& \\multicolumn{8}{l}{%d} \\\\"), bm$n_start),
    sprintf(paste("Retained with $\\hat m_\\varphi = \\bar m$",
                  "& \\multicolumn{8}{l}{%d} \\\\"), bm$n_cap),
    sprintf(paste("S.d.\\ of the anchor across replications",
                  "& \\multicolumn{8}{l}{%s} \\\\"),
            fmt(stats::sd(bm$x_med, na.rm = TRUE), 2)),
    sprintf(paste("Weight s.d.\\ (population value 1): median",
                  "& \\multicolumn{8}{l}{%s} \\\\"),
            fmt(stats::median(vapply(bm$recs, \(z) z$w_cv %||% NA_real_,
                                     numeric(1)), na.rm = TRUE), 3)),
    "\\addlinespace",
    sprintf(paste("Coordinate map rebuilt ($B=%d$): replications",
                  "& \\multicolumn{8}{l}{%d, %d finite} \\\\"), N_MAP,
            bands[["M2"]]$n_rep, bands[["M2"]]$n_ok),
    sprintf(paste("Coordinate map rebuilt: band width on the same draws",
                  "& \\multicolumn{8}{l}{%s vs.\\ %s} \\\\"),
            fmt(width_of(bands[["M2"]], N_MAP), 4), fmt(width_of(bm, N_MAP),
                                                        4)))

  write_tabular(
    "lrrrrrrrr",
    c(paste("& & & & & \\multicolumn{2}{c}{Bootstrap envelope} &",
            "\\multicolumn{2}{c}{Counties within $\\pm5\\,\\mu$g/m$^3$} \\\\"),
      "\\cmidrule(lr){6-7} \\cmidrule(lr){8-9}",
      paste("Pctile of $X$ & TSP & $\\hat\\varphi(x)-\\hat\\varphi(x_{0.5})$ &",
            "Bootstrap median & Bootstrap s.d. & 5th & 95th & 1970 & 1980",
            "\\\\")),
    c(paste0("\\multicolumn{9}{l}{\\textit{Panel A: $\\hat\\varphi$ at ",
             "deciles of the pooled $X$ distribution}} \\\\"),
      "\\midrule", mult_a, "\\addlinespace",
      paste0("\\multicolumn{9}{l}{\\textit{Panel B: multiplier design and ",
             "convergence}} \\\\"),
      "\\midrule", mult_b),
    file.path(TAB, "app_tsp_phi_mult.tex"))

  # INV-12: no title inside the panel; it belongs in the LaTeX caption.  The
  # band is drawn beneath the point estimate, unmapped grey with dotted edges,
  # so it cannot be read as a confidence region.
  thm <- theme_minimal(base_family = "serif", base_size = 10) +
    theme(panel.grid.minor = element_blank(),
          strip.text = element_text(face = "bold"),
          legend.position = "bottom")

  phi_dt <- data.frame(tsp = x_grid, phi = phi_point)
  band_dt <- data.frame(tsp = x_grid, lo95 = bm$q[1, ], lo50 = bm$q[2, ],
                        hi50 = bm$q[3, ], hi95 = bm$q[4, ], bmed = bm$med)
  rug_dt <- data.frame(tsp = c(dt$x1_raw, dt$x2_raw),
                       period = rep(c("1970", "1980"), each = n))
  rug_dt <- rug_dt[rug_dt$tsp >= min(x_grid) & rug_dt$tsp <= max(x_grid), ]

  p_mult <- ggplot(phi_dt, aes(tsp, phi)) +
    geom_ribbon(data = band_dt, aes(x = tsp, ymin = lo95, ymax = hi95),
                inherit.aes = FALSE, fill = "grey65", alpha = 0.18) +
    geom_ribbon(data = band_dt, aes(x = tsp, ymin = lo50, ymax = hi50),
                inherit.aes = FALSE, fill = "grey50", alpha = 0.22) +
    geom_line(data = band_dt, aes(x = tsp, y = lo95), inherit.aes = FALSE,
              linetype = "dotted", linewidth = 0.3, colour = "grey30") +
    geom_line(data = band_dt, aes(x = tsp, y = hi95), inherit.aes = FALSE,
              linetype = "dotted", linewidth = 0.3, colour = "grey30") +
    geom_hline(yintercept = 0, colour = "grey60", linewidth = 0.3) +
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
  ggsave(file.path(FIG, "app_tsp_phi_mult.pdf"), p_mult, width = 6.0,
         height = 3.6, device = grDevices::cairo_pdf)
  message("verdict passed: wrote app_tsp_phi_mult.tex and .pdf")
} else {
  tab <- NULL
  message("verdict failed: the M band is NOT written as a reportable ",
          "alternative; only the comparison table is produced")
}

# ---- Saved object -----------------------------------------------------------

sec_tot <- sum(unlist(lapply(bands, \(b) b$secs)), na.rm = TRUE)
saveRDS(list(x_grid = x_grid, x_med = x_med, phi_point = phi_point,
             theta_hat = theta_hat, bands = bands, band_probs = BAND_PROBS,
             tab = tab, n_boot = N_BOOT, n_map = N_MAP, rate = MULT_RATE,
             reported_band = "M", map_fixed = TRUE, verdict = verdict,
             verdict_parts = c(v1 = v1, v2 = v2, v3 = v3),
             outcomes = list(M = out_m, C0 = out_c0, subsample = tie,
                             subsample_eff = subeff),
             sub = sub, n_sub_eff = N_SUB_EFF,
             m_full = m_full, point_range = point_range,
             layer_check = val, headline_dz = HEADLINE_DZ,
             secs_total = sec_tot),
        file.path(OUT, "app_tsp_phi_mult.rds"))

message(sprintf("done: app_tsp_06_phi_mult (%.1f core-hours)",
                sec_tot / 3600))
