# ============================================================================
# app_tsp_run_all.R
#
# Master runner for Section 6, the hedonic TSP application.  Each stage is
# self-contained given that its predecessors have run; each sets exactly one
# seed at its own top (INV-14), so this file sets none.
#
#   Rscript scripts/application/app_tsp_run_all.R
#
# Stage 2 depends on stage 1's .rds (feasibility numbers, probes 1 and 3).
# Stage 4 depends on stages 2 and 3; stage 5 depends on stage 2; stage 6 reads
# stage 5's .rds and never re-runs it.  Stages 7 and 8 depend on nothing but the
# panel and the design.
#
# WALL TIME ON 8 CORES, MEASURED 2026-08-10/11 -- not estimated, and the figures
# this header used to carry were wrong by up to an order of magnitude:
#   01  ~1 min      03  ~10 min     05  ~63 min     07  ~1 min
#   02  ~3 min      04  ~10 s       06  ~16 min     08  ~5 min
# All are COLD-cache times except stage 5, which is warm.  Three corrections:
#   * stage 02 is 175 s cold, not the "~15 min" claimed here and at
#     app_tsp_02_ladder.R:55;
#   * stage 06 was 440 s cold (0.4 core-hours, 124 replications) at L = 2, not
#     "1-3 h"; it is 16 min (1.6 core-hours) since 2026-08-14, when it moved onto
#     the four-category instrument and the cap went 15 -> 60 with it;
#   * stage 05's "4-6 h" is false -- 63 min is the measured figure.  That claim
#     was still printed at app_tsp_05_phi_band.R:146 until 2026-08-11, when the
#     header there was corrected too; this line used to point at it.
# Stage 08 is 643 s (measured 2026-08-11, round 3), up from 470 s.  It reports
# ONE eps -- 0.01, the author's ruling -- but it MEASURES the move away from the
# two levels it used to report, and measuring costs more than reporting:
#   * SIX estimator arms (154 s): two at the ruled eps, which are the ones that
#     reach the tables, plus four at the retired 0.0300 and 0.0115 that exist
#     only to price the ruling.  The retired four double as a regression test --
#     they must reproduce the shipped arms BIT-FOR-BIT, and they do.
#   * SEVEN reference blocks of B = 2000 draws (457 s): four t-grids at the
#     ruled eps, one cross-fitted-propensity variant, and one registered grid at
#     each retired eps for the p-value movement.
# Dropping the movement measurement would return the stage to about 300 s.
# See that file's header (R1)-(R3) for what each block establishes.
#
# ---------------------------------------------------------------------------
# CACHES INVALIDATED 2026-08-11, AND THE FIRST RUN AFTER THIS DATE WILL BE SLOW.
#
# Stages 02, 05 and 06 fingerprint on md5(scripts/R/lf_panel.R),
# md5(scripts/R/orthogonal_theta.R) and deparse(fit_orthogonal).  All three
# changed when eps_rho was threaded through the driver and the propensity was
# instrumented, so:
#   * stage 02 discards app_tsp_ladder_ckpt.rds        (~3 min to rebuild)
#   * stage 05 UNLINKS app_tsp_phi_band_parts/ (252)   (~63 min to rebuild)
#   * stage 06 discards app_tsp_phi_mult_parts/ (126)  (~16 min to rebuild)
# scripts/simulations/sim_bierens_validate.R is on the same hook; the
# sim_thm_rootn_* family is NOT (it hashes only scripts/simulations/).
#
# THE RECOMPUTE IS INERT, AND THAT IS MEASURED RATHER THAN ASSERTED.  Re-running
# the estimator under the changed source reproduces the shipped numbers
# BIT-FOR-BIT: stage 01's driver-parity assertion still prints
# max |theta_driver - theta_reference| = 0.000e+00 and rewrites every one of its
# tables byte-for-byte; stage 02's d_Z = 0 and d_Z = 5 rungs reproduce theta and
# se_cl exactly; stage 08's four arms reproduce exactly.  Nothing on the
# estimator's arithmetic path was touched -- the instrumentation is an extra
# return field and an attribute the caller strips on receipt.
# ---------------------------------------------------------------------------
#
# Stage 5 is the expensive one: 99 bootstrap replications of the phi step, plus
# 25 that re-estimate theta as well, plus three full-sample coordinate arms.
# It writes one file per replication under
# quality_reports/application/app_tsp_phi_band_parts/ and resumes from them, so
# an interrupted run costs only the replications that had not finished.
#
# Stage 6 is the multiplier-bootstrap counterpart: the same phi step under
# i.i.d. Exp(1) weights instead of a with-replacement resample, run to settle
# whether the width of stage 5's band is a property of the estimator or of the
# resampling scheme.  It writes its own replication files under
# app_tsp_phi_mult_parts/ and its own tables, and it modifies nothing stage 5
# produced.
#
# Stage 7 measures the composite operator's squared norm in each of the three X
# coordinates and what the default Landweber step does in each.  It exists so
# that the coordinate defence in Section 6 rests on a shipped artifact rather
# than on a number quoted from a run nobody can repeat.
# ============================================================================

library(here)

# ---- single-runner lock ------------------------------------------------------
#
# On 2026-08-07 two runs of this file overlapped: one on a superseded engine,
# one on the corrected one.  Both wrote the same tables and the same
# checkpoints, the slower and STALER of the two finished last, and the shipped
# artifacts were its.  Nothing failed and nothing warned -- the tables simply
# disagreed with the log of the run that was supposed to have produced them,
# which is the hardest kind of wrong to notice.
#
# The stages are individually idempotent and cache-fingerprinted, so the defect
# was never in a stage; it was that two of them ran at once.  One lock, taken
# for the whole run, removes the whole class.
LOCK <- here::here("quality_reports", "application", ".run_all.lock")
dir.create(dirname(LOCK), showWarnings = FALSE, recursive = TRUE)
if (file.exists(LOCK)) {
  stop(sprintf(paste0("app_tsp_run_all.R is already running (lock held since %s ",
                      "by pid %s).\nIf that is stale, delete %s."),
               format(file.info(LOCK)$mtime), readLines(LOCK)[1], LOCK))
}
writeLines(as.character(Sys.getpid()), LOCK)
## on.exit() at the TOP LEVEL of a script does not fire when a stage calls
## stop() -- the first version of this lock leaked on exactly that path and had
## to be cleared by hand.  reg.finalizer(onexit = TRUE) fires on any exit,
## error included.
.lock_guard <- new.env()
reg.finalizer(.lock_guard, function(e) unlink(LOCK), onexit = TRUE)

# ---------------------------------------------------------------------------
# ORDER CHANGED 2026-08-12: STAGE 8 NOW RUNS BEFORE STAGE 5.
#
# Stage 5's phi-hat moved onto the four-category instrument, and phi-hat is the
# plug-in second stage GIVEN theta-hat (prp:plugin), so it must be plugged in at
# the four-category theta-hat the paper reports -- which stage 8 produces.  A
# fresh fit in stage 5 would put a second four-category theta-hat at the same
# rung into Section 6.
#
# THE REVERSE EDGE IS SOFT, WHICH IS WHY THIS IS NOT A CYCLE.  Stage 8 reads
# stage 5's band, but only to put a sampling SCALE on a reported gap, and only
# `if (file.exists(band_path))`.  So on a run where the band changes
# cardinality, stage 8's scale is taken from the previous band; STAGE 8 IS
# THEREFORE LISTED TWICE, and the second pass is what ships.  It costs ~11 min
# and it is the only way the scale and the band describe the same estimator.
#
# STAGE 6 IS EXPECTED TO STOP while stage 5's band is at L = 4: the weighted
# layer is binary by declaration (w_operator_residual, "Author call").  Its
# shipped tables remain valid as L = 2 statements.  The stage is kept in the
# list rather than removed so the blocker is visible on every run.
STAGES <- c("app_tsp_01_diagnostics.R",
            "app_tsp_02_ladder.R",
            "app_tsp_03_robustness.R",
            "app_tsp_04_figures.R",
            # Stage 7 is a standalone diagnostic: it depends on no earlier
            # stage's output, only on the panel and the design, so it can run
            # anywhere in this list.
            "app_tsp_07_opnorm.R",
            # Stage 8 was ABSENT FROM THIS LIST until 2026-08-11, which put the
            # paper's declared evidence about A1 -- the per-cell attribution of
            # Section 6.3, and the four-category estimate beside it -- outside
            # the reproducible path entirely.  It depends only on the panel, the
            # design and the instrument variants file, like stage 7.
            "app_tsp_08_localise.R",
            "app_tsp_05_phi_band.R",
            "app_tsp_06_phi_mult.R",
            # Second pass: see the note above.  Stage 8 is idempotent given the
            # band, so this only refreshes the sampling scale.
            "app_tsp_08_localise.R")

for (s in STAGES) {
  message(sprintf("=== %s ===", s))
  t0 <- Sys.time()
  # Each stage runs in a fresh R process so that one stage's seed, RNG kind and
  # loaded objects cannot leak into the next.
  code <- system2("Rscript", here::here("scripts", "application", s))
  if (code != 0L) stop(sprintf("stage %s failed with status %d", s, code))
  message(sprintf("=== %s done in %.0fs ===", s,
                  as.numeric(difftime(Sys.time(), t0, units = "secs"))))
}

message("all stages complete")
