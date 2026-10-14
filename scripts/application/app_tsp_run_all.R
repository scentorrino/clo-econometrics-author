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
# ---------------------------------------------------------------------------
# CACHES INVALIDATED AGAIN 2026-08-15 BY THE x-KERNEL ORDER, AND THE RECOMPUTE
# IS NOT INERT.  scripts/R/lf_panel.R now runs C3's OWN boundary family --
# lem:bdryfam's eq:gramfam member at p_K = 8, one Gram solve per design point --
# where from 2026-08-14 it ran the j = 0 renormalisation at ORDER 2.  C3 declares
# p_K = 8 in the x-direction, so what shipped between those two dates satisfied
# the assumption at p_K = 1.  EVERY number that passes through make_operator()
# moves: theta-hat, phi-hat, the band, the ladder, the operator norm.  Stages 02,
# 05 and 06 fingerprint on md5(lf_panel.R), so all three discard their caches on
# the first run after this date.  BACK UP quality_reports/application/ FIRST:
# stage 05 unlinks 252 replication files and stage 06 unlinks 126.
#
# WHAT MUST NOT MOVE, AND WHERE THAT IS CHECKED.  The x-kernel has no path to
# the sample, the propensity, the first stage or the RESIDUAL direction.
#   * Stage 09 Panel E asserts bit-for-bit equality of the cross-fitted
#     propensity diagnostics across all three engines and STOPS if they differ.
#   * Stage 09 Panel G asserts operator_residual() is bit-for-bit the
#     pre-change function at four configurations, and that 23 u-direction
#     primitives are textually unchanged.
#   * Stage 09 Panel D re-runs the 2026-08-14 contrast (renormalised vs none) as
#     a REGRESSION TEST: it must reproduce the shipped 0.0225 / 0.115 / 0.0070.
#   * app_tsp_sample.tex, app_tsp_sumstats.tex, app_tsp_balance.tex,
#     app_tsp_firststage.tex, app_tsp_misclass.tex and app_tsp_feasibility.tex
#     must be byte-identical to their pre-change versions (stage 01 runs no
#     estimator at all).
#
# COST OF THE CHANGE: about 1.17x on every stage that solves.  The Gram solves
# are batched (batch_spd_solve), so they are ~5% of it; the rest is that the
# survival matrix is now a polynomial-times-Gaussian evaluation instead of a
# single pnorm.
#
# THE MONTE CARLO DOES NOT INHERIT THIS, AND THAT IS A KNOWN DEBT, NOT AN
# OVERSIGHT.  scripts/simulations/sim_thm_rootn_*.R write the D11 renormalisation
# out BY HAND (sim_thm_rootn_phistep.R:281) rather than calling make_operator(),
# so Section 5's root-n suite still verifies the 2026-08-14 kernel while Section 6
# now ships C3's family -- the same Section-5-verifies-one-estimator gap that
# stage 09 exists to have closed, running in the other direction.  The two suites
# that DO call make_operator(), sim_multinomial_phistep.R and
# sim_multinomial_phiplugin.R, inherit the family automatically and their cached
# tables are stale from this date.  Both are the simulation-engineer's to re-run.
# ---------------------------------------------------------------------------
#
# WALL TIME ON 8 CORES, MEASURED 2026-08-10/11 -- not estimated, and the figures
# this header used to carry were wrong by up to an order of magnitude:
#   01  ~1 min      03  ~10 min     05  ~63 min     07  ~1 min
#   02  ~3 min      04  ~10 s       06  ~16 min     08  ~5 min
# Stage 09 is NEW on 2026-08-14 and costs ~3 min: two full-sample second-stage
# solves and two cross-fitted arms, one per engine.  Stage 08 gains ~2 min
# because its three L = 2 arms moved from m-bar = 15 to the common m-bar = 60
# (see MBAR_COMMON there), plus one L-tied arm.  Stage 05 gains ~30 s for one
# extra full-sample arm.  The 2026-08-14 end-to-end run took 3.9 h.
#
# 2026-08-15 REVISION.  Every solving stage is about 1.17x the above under C3's
# family, and stage 09 gains a third engine arm (~5.5 min, measured).  Stage 05
# at L = 4 was 2.9 h before this change, not the 63 min the line above records
# for the L = 2 configuration it was measured at.  Stage 06 is NOT expected to
# stop any more: the weighted layer was generalized to L >= 3 on 2026-08-14 and
# its shipped tables are already four-category.
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
# 25 that re-estimate theta as well, plus TWO full-sample coordinate arms and
# two binary comparison arms.  It was three coordinate arms until 2026-08-16,
# when min--max was retired: it is an exact affine image of mu-g/m^3 (stage 11
# Panel C, relative deviation 7e-14), so its arm and its bootstrap design were
# the mu-g/m^3 ones in different units.
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
# STAGE 6 WAS EXPECTED TO STOP while stage 5's band was at L = 4, the weighted
# layer then being binary by declaration.  THAT NOTE IS RETIRED 2026-08-15: the
# layer was generalized to L >= 3 on 2026-08-14 (w_operator_residual_multi), the
# stage has since run to completion at L = 4, and its shipped .rds records
# L = 4.  Only `alpha` remains refused there, and no caller passes one.
STAGES <- c("app_tsp_01_diagnostics.R",
            # Stage 9 measures C3(ii)'s boundary adjustment -- the j = 0
            # truncated moment, int_X nu-hat dx, and the ablation that says what
            # the adjustment moved and what it provably cannot reach.  It
            # depends on nothing but the panel and the instrument variants file,
            # so it runs EARLY: if the adjustment ever regresses, that fact is
            # on the log before four hours of bootstrap have been spent.
            "app_tsp_09_boundary.R",
            # Stage 11 (2026-08-16) sweeps the x-bandwidth over a factor of 120
            # in all three X coordinates and records where pi-hat stops being
            # positive.  It is what says that the two RE-MEASUREMENT arms of
            # stage 03 are infeasible at EVERY h_x swept rather than only at the
            # one they happen to run at -- a C1(ii) statement, not a tuning
            # accident -- and it fixes C28's matching constant.  It depends on
            # nothing but the panel, like stages 07 and 09, so it runs before
            # the stage whose rows it explains.  COST: ~20 min on 8 cores (63
            # rungs x 120 operator builds; pi-hat only, no estimator).
            "app_tsp_11_hxmatch.R",
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
            # Stage 10 was ABSENT FROM THIS LIST until 2026-08-15, on the same
            # footing stage 08 was absent until 2026-08-11: it ships a table
            # (app_tsp_n1_anchor.tex), it calls crossfit_once(), and it was
            # therefore outside the reproducible path while being inside the
            # paper.  It reads stage 08's and stage 02's .rds for a reporting
            # scale only, so it runs after both.
            "app_tsp_10_n1_anchor.R",
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
