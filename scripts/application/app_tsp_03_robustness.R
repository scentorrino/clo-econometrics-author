# ============================================================================
# app_tsp_03_robustness.R
#
# Section 6, stage 3: sensitivity of the headline rung to every tuning constant
# the application had to set, plus two comparison estimators.
#
# The point is NOT to find a configuration that looks good.  It is to show the
# whole sweep, including the arms where the estimator misbehaves, so that the
# headline number is read against its own dispersion.
#
# Arms
#   R1  coordinate for X          rank (baseline) against ONE non-rank arm at a
#                                 coordinate-matched h_x (C28).  ONE, not two:
#                                 see the collapse note above ARMS.
#   R2  Landweber step cste       operator norm (baseline) / 1.0 / 0.5 / 0.1
#   R3  initial condition         init_control (baseline) / robinson / poly
#   R4  cross-fitting folds K     5 (baseline) / 2 / 10
#   R5  RKHS ridge rho            1e-3 (baseline) / 1e-4 / 1e-2
#   R6  stopping rule / budget    tau_DP = 0 with m-bar = lf_mbar (baseline)
#                                 / the retired tau_DP = 0.7, m-bar = 2000
#                                 / m-bar in {8, 30, 60}
#   R7  sample                    983 complete cases (baseline) / all 989
#   R8  comparison estimators     linear IV; the draft's alternating estimator
#
# Also computed here (it needs raw lf_solve output, which crossfit_once does
# not surface): the discrepancy path of a set of fold solves, which is the
# evidence for whether the stopping rule fires on a semiconvergent path or on a
# monotonically rising one.
#
# Outputs
#   paper/tables/app_tsp_robustness.tex
#   quality_reports/application/app_tsp_robustness.rds
# ============================================================================

library(here)
library(parallel)

source(here::here("scripts", "R", "lf_panel.R"))
source(here::here("scripts", "R", "orthogonal_theta.R"))
source(here::here("scripts", "application", "app_tsp_common.R"))

RNGkind("L'Ecuyer-CMRG")
set.seed(SEED_ROBUST)                                                # INV-14

TAB <- here::here("paper", "tables")
OUT <- here::here("quality_reports", "application")

pan <- load_tsp_panel()
dt  <- pan$dt
n   <- nrow(dt)
HEADLINE_DZ <- 5L

# ---- Stage 11's feasibility ladder, which this table's one non-rank row cites -
#
# THE ROW HAS TO CITE AN ARTIFACT, NOT A COMMENT.  What the collapsed coordinate
# row prints is a C1(ii) statement about the COORDINATE -- pi-hat is not bounded
# away from zero in it at any usable h_x -- and that is a claim about a swept
# ladder, not about the single bandwidth this arm happens to run at.  Reading it
# off app_tsp_hxmatch.rds keeps the printed numbers traceable to a script line
# and an output file (INV-22) instead of being retyped from a header comment,
# which is how the 1.2756 / 1.1937 misreading in the supplement survived.
#
# ORDERING IS ALREADY RIGHT: app_tsp_run_all.R runs stage 11 before this stage
# and says so in its own STAGES comment.  Stage 11 depends on nothing but the
# panel, so this edge introduces no cycle.
HXM_PATH <- file.path(OUT, "app_tsp_hxmatch.rds")
if (!file.exists(HXM_PATH)) {
  stop("app_tsp_03_robustness: ", HXM_PATH, " is missing.  Stage 11 supplies ",
       "the pi-hat feasibility ladder the coordinate row prints; run ",
       "app_tsp_11_hxmatch.R first.")
}
hxm <- readRDS(HXM_PATH)
## The ladder must describe THIS panel and THIS kernel, or its rung counts are
## about some other design.  Checked, not assumed.
stopifnot(identical(as.integer(hxm$n), as.integer(n)),
          identical(as.integer(hxm$p_K), as.integer(P_K_X)),
          all(c("rank", "ugm3", "minmax") %in% names(hxm$feasibility)))

#' The feasibility window the coordinate row reports, read off stage 11.
#'
#' Every field is a quantity app_tsp_hxmatch.rds computed; nothing here is a
#' retyped constant.  `n_rungs` is shared between the two coordinates by
#' construction (both are swept on S_LADDER), which is what makes "2 of 31"
#' against "23 of 31" a comparison rather than two unrelated counts.
#'
#' @param z list. The stage-11 artifact.
#' @param md character(1). The non-rank coordinate the arm runs in.
#' @return named list; see the fields below.
coord_window <- function(z, md = "ugm3") {
  ld <- z$ladder
  arm <- ld[ld$mode == md & ld$trim == 0L, , drop = FALSE]
  ok  <- arm[arm$n_fail == 0L, , drop = FALSE]
  ref <- z$feasibility[[md]]
  rnk <- z$feasibility[["rank"]]
  ## The rule-of-thumb rung, s = 1, is the bandwidth every OTHER stage runs at.
  ## Compared with a float tolerance rather than ==, per the numerical rule.
  i_rot <- which(abs(arm$s - 1) < 1e-9)
  stopifnot(nrow(ok) == length(ref$s_ok), length(i_rot) == 1L)
  ## Panel D at the rule-of-thumb bandwidth: trimming the k largest counties.
  tr <- z$trim
  tr <- tr[tr$mode == md & abs(tr$s - 1) < 1e-9, , drop = FALSE]
  tr <- tr[order(tr$trim), , drop = FALSE]
  list(mode = md,
       n_ok = nrow(ok), n_rungs = ref$n_rungs,
       n_ok_rank = length(rnk$s_ok), n_rungs_rank = rnk$n_rungs,
       s_ok_rank_max = if (length(rnk$s_ok)) max(rnk$s_ok) else NA_real_,
       h_lo = min(ok$h_full), h_hi = max(ok$h_full),
       h_rot = arm$h_full[i_rot],
       ## The width of the window relative to its own midpoint, and how far
       ## below the rule of thumb it sits.  Both are ratios, so both are
       ## unit-free and transfer to the min--max coordinate unchanged.
       rel_width = (max(ok$h_full) - min(ok$h_full)) /
         (0.5 * (max(ok$h_full) + min(ok$h_full))),
       fold_below_rot = arm$h_full[i_rot] / max(ok$h_full),
       ## Even on the two feasible rungs the DENSE grid carries a negative
       ## pi-hat: the guard passes because make_operator() thresholds design and
       ## evaluation points only, not the whole support.
       n_grid_fail = ok$n_fail_grid, n_builds = ok$n_builds,
       ## WHERE the guard minimum sits, and it is the LOWER endpoint of X rather
       ## than the 428.1 outlier a reader will otherwise assume.
       ##
       ## READ OVER THE FAILING RUNGS ONLY, AND THE FIRST DRAFT DID NOT.
       ## rung()'s `q_at_min_med` is the median over the FAILING builds where any
       ## fail and over ALL builds otherwise, so it is two different statistics
       ## depending on the rung.  Averaging across both put the two feasible
       ## rungs' 0.98 -- a median over builds with no failure at all -- into a
       ## summary of where failures happen, and moved it from the 0.38th
       ## percentile to a number with no meaning.  `q_at_min_rot` is the single
       ## quotable value: the same quantity at the bandwidth every other stage
       ## runs at.
       q_at_min = stats::median(arm$q_at_min_med[arm$n_fail > 0L &
                                                   arm$s >= min(ok$s)]),
       q_at_min_rot = arm$q_at_min_med[i_rot],
       trim_k = tr$trim, trim_fail = tr$n_fail, trim_builds = tr$n_builds,
       x_min = min(c(dt$x1_raw, dt$x2_raw)),
       x_next = sort(unique(c(dt$x1_raw, dt$x2_raw)))[2L],
       x_max = max(c(dt$x1_raw, dt$x2_raw)),
       affine_rg = z$affine$rg, affine_rel = z$affine$max_rel_dev)
}
WIN <- coord_window(hxm, "ugm3")
message(sprintf(paste0("stage 11: %s feasible at %d of %d rungs, h_x in ",
                       "[%.3f, %.3f] (%.1f%% wide, %.1fx below the rule of ",
                       "thumb %.3f); dense grid negative on %s of %s builds ",
                       "even there; rank feasible at %d of %d rungs to s = %g"),
                WIN$mode, WIN$n_ok, WIN$n_rungs, WIN$h_lo, WIN$h_hi,
                100 * WIN$rel_width, WIN$fold_below_rot, WIN$h_rot,
                paste(WIN$n_grid_fail, collapse = "/"),
                paste(WIN$n_builds, collapse = "/"),
                WIN$n_ok_rank, WIN$n_rungs_rank, WIN$s_ok_rank_max))
message(sprintf(paste0("   guard minimum at the %.2f percentile of the fold's ",
                       "pooled X (%.2f at the rule-of-thumb h_x); smallest ",
                       "observation %.1f, next %.1f, largest %.1f"),
                100 * WIN$q_at_min, 100 * WIN$q_at_min_rot,
                WIN$x_min, WIN$x_next, WIN$x_max))
message(sprintf(paste0("   so it is the LOWER endpoint, not the %.0f outlier: ",
                       "trimming the %s largest counties leaves failures at ",
                       "%s of %s builds"),
                WIN$x_max, paste(WIN$trim_k, collapse = "/"),
                paste(WIN$trim_fail, collapse = "/"),
                paste(unique(WIN$trim_builds), collapse = "/")))
Z <- make_design(dt, HEADLINE_DZ)

# The full 989-county sample, available at rungs that exclude the fiscal block.
raw <- pan$raw
raw[["dy"]]      <- raw[["LogPropValue"]]
raw[["x1_raw"]]  <- raw[["MTSP1970"]]
raw[["x2_raw"]]  <- raw[["MTSP1980"]]
raw[["w"]]       <- raw[["CATT"]]
raw[["cluster"]] <- raw[["StateCode"]]
Z_full <- make_design(raw, HEADLINE_DZ)

grid_for <- function(x1, x2) {
  seq(stats::quantile(c(x1, x2), XEVAL_LO),
      stats::quantile(c(x1, x2), XEVAL_HI), length.out = N_XEVAL)
}

# ---- The coordinate arms' bandwidth, C28 ------------------------------------
#
# THE ARM WAS CONFOUNDED AS DESIGNED, AND THAT -- NOT THE MISSING ROW -- IS WHAT
# IS REPAIRED HERE ON 2026-08-16.
#
# R1a and R1b RE-MEASURE X.  Until this date they did so while holding h_x at
# bw_rot(), which is proportional to sd(X) and therefore holds h_x / sd(X) fixed
# across coordinates BY CONSTRUCTION -- it is 1.059 n^{-1/5} in every one of
# them -- and lets h_x / |X| move freely.  On this panel it moves a long way:
#
#     |X| / h_x  =  12.320  (rank)   vs   57.676  (mu-g/m^3 AND min-max)
#
# so whatever those two rows measured, it was not re-measurement alone.  It was
# re-measurement at a bandwidth that means something different in the new
# coordinate.  C28 (app_tsp_common.R) states the matching rule and hx_scale_for()
# computes it; the arms below run at the matched value.
#
# WHAT THE UNMATCHED ROWS USED TO PRINT, kept because a reader will otherwise
# expect them.  Before the x-kernel moved to C3's order-8 boundary family
# (2026-08-15) they printed High school at 1.2756 and 1.1937 against a baseline
# of 0.9072 -- the two most deviant entries in the whole table, a 41% and a 32%
# swing that reads as fragility.  They were computed dividing by a pi-hat whose
# full-sample minimum is 4.33e-05, four orders of magnitude below the mean
# density of 2.3e-03; the adjoint was already dividing by a number
# indistinguishable from zero.  Under the family the same configuration is not
# merely delicate but INFEASIBLE, and so is this one.
#
# *** THE MATCH DOES NOT RESCUE THE ARM, AND MAKING IT WORSE IS THE FINDING. ***
# app_tsp_11_hxmatch.R sweeps h_x over a factor of 120 in both coordinates, 120
# operator builds per rung, and the mu-g/m^3 failure count RISES with h above
# s ~ 1.1: 5/120 at the shipped bandwidth, 29/120 at s = 2.5, 114/120 at the
# matched s = 4.68, 116/120 at s = 6.  The rank coordinate is feasible at every
# rung from s = 0.25 to s = 6 -- a factor of 24 -- with min pi-hat 0.207 at the
# shipped bandwidth over the same fold draws.
#
# WHY MORE SMOOTHING HURTS HERE, which is what makes this a statement about the
# COORDINATE rather than about the tuning.  The rank map makes the pooled design
# uniform, so every point has ~n h neighbours inside the kernel's positive lobe.
# In mu-g/m^3 the pooled X runs from 0.0 to 428.1 with a median of 58.0, and the
# smallest observation sits 7.8 away from the next: at the lower endpoint the
# truncation interval I degenerates to a half-line, and raising h drags the bulk
# of the design into the order-8 kernel's NEGATIVE lobes at that point.  The
# ladder locates the guard minimum at the 0.3rd percentile of the fold's pooled
# X at every rung above s = 0.25.  Read as C1(ii): pi bounded away from zero on
# X is an ASSUMPTION, and it is the rank coordinate that satisfies it here.
#
# *** THE TWO COORDINATE ROWS ARE COLLAPSED TO ONE, 2026-08-16 (AUTHOR RULING),
# AND KEEPING BOTH WAS OVERSTATING THE CHECK'S COVERAGE. ***
#
# min-max is (X - lo) / rg, an AFFINE image of mu-g/m^3, and |X| / h_x is
# affine-invariant because bw_rot() scales with sd.  app_tsp_11_hxmatch.R
# Panel C measures the consequence rather than asserting it: pi-hat in the two
# coordinates differs by EXACTLY the factor rg, to a maximum relative deviation
# of 7.07e-14 -- i.e. to floating-point.  R1b therefore tested nothing R1a did
# not, and two rows told a reader that the coordinate had been probed twice.
#
# WHAT THE PAIR ACTUALLY MEASURED, WHICH IS WHY THIS IS A CORRECTION AND NOT A
# TIDY-UP.  The two arms drew from DIFFERENT L'Ecuyer streams (2 and 3), so they
# saw different cross-fitting partitions and the guard fired on a different fold
# in each.  Their printed minima were in the ratio 637, not the 428.1 the
# coordinates are apart, and before the x-kernel moved to C3's boundary family
# they printed High school at 1.2756 and 1.1937 -- a 6.4 per cent gap that
# Section 6's supplement reads TO THIS DAY as the two coordinates disagreeing.
# They do not disagree; they cannot.  That gap was cross-fitting noise, and a
# table that prints it twice invites exactly the misreading it received.
#
# ONE ROW, and it carries the ladder instead of the pair: app_tsp_11_hxmatch.R
# sweeps h_x over a factor of 120 in both coordinates at 120 operator builds per
# rung, which says the arm is infeasible at EVERY h_x rather than at the one it
# happens to run at.  That is strictly more than a second row could have said.
HX_UGM3   <- hx_scale_for(dt$x1_raw, dt$x2_raw, "ugm3")
HX_MINMAX <- hx_scale_for(dt$x1_raw, dt$x2_raw, "minmax")
## THE COLLAPSE'S OWN PRECONDITION, ASSERTED RATHER THAN ARGUED.  If the two
## matched constants were ever to differ, the two coordinates would not be the
## same arm and one row would be hiding a second test.  They are equal because
## |X| / h_x is affine-invariant; this line is what makes that a checked fact.
stopifnot(isTRUE(all.equal(HX_UGM3, HX_MINMAX, tolerance = 1e-12)),
          WIN$affine_rel < 1e-10)
message(sprintf(paste0("C28: hx_scale = %.4f (ug/m^3) = %.4f (min-max); ",
                       "rank = 1.  Collapsed to ONE arm: pi-hat differs by ",
                       "exactly rg = %.4f (rel. dev. %.3g)"),
                HX_UGM3, HX_MINMAX, WIN$affine_rg, WIN$affine_rel))

# ---- Arm definitions --------------------------------------------------------
#
# Each arm names the ONE constant it moves; everything else is the baseline.
# The coordinate arms move TWO -- the coordinate and, with it, h_x -- and that
# is the point: holding h_x fixed is what made the coordinate arm impure.

ARMS <- list(
  list(id = "R0", label = "Baseline",                 coord = "rank"),
  ## ONE non-rank coordinate arm.  It RUNS in mu-g/m^3; the label names min--max
  ## too because the two are the same arm in different units (Panel C of stage
  ## 11, relative deviation 7e-14), and a label naming only one of them would
  ## leave a reader to infer that the other was never tried.  The row's
  ## \multicolumn cell carries the ladder, which is what says the infeasibility
  ## is a property of the COORDINATE and not of this bandwidth.
  list(id = "R1", label = "$X$ in $\\mu$g/m$^3$ or min--max",
       coord = "ugm3", hx_scale = HX_UGM3),
  list(id = "R2a", label = "Step $c = 1.0$",           coord = "rank", cste = 1.0),
  list(id = "R2b", label = "Step $c = 0.5$",           coord = "rank", cste = 0.5),
  list(id = "R2c", label = "Step $c = 0.1$",           coord = "rank", cste = 0.1),
  list(id = "R3a", label = "Start: Robinson",          coord = "rank", init = "robinson"),
  list(id = "R3b", label = "Start: cubic",             coord = "rank", init = "poly"),
  list(id = "R4a", label = "Folds $K = 2$",            coord = "rank", K = 2L),
  list(id = "R4b", label = "Folds $K = 10$",           coord = "rank", K = 10L),
  list(id = "R5a", label = "Ridge $\\rho = 10^{-4}$",  coord = "rank", rho = 1e-4),
  list(id = "R5b", label = "Ridge $\\rho = 10^{-2}$",  coord = "rank", rho = 1e-2),
  # R6a AND R6b REDEFINED 2026-08-12, because the 2026-08-12 recalibration
  # (TAU_DP 0.7 -> 0, cap 2000 -> lf_mbar) made BOTH OF THEM INERT and an inert
  # arm that still prints is worse than no arm: it reports agreement it never
  # tested.
  #   * "Patience = 30" was a live constraint when patience was 100 and the cap
  #     2000.  Patience is now tied to the cap by lf_patience_for(), so at
  #     L = 2 the cap is 15 and a patience of 30 CANNOT BIND -- the arm would
  #     have reproduced the baseline exactly, by construction.
  #   * "Cap = 6000" was the question "is the cap binding on theta-hat?".  The
  #     cap is now the REGULARISER (C4), not a safety net, so that question is
  #     answered by design -- yes, always -- and 6000 is 400x the calibrated
  #     budget, i.e. an arm that measures nothing but overfitting.
  # What replaces them is what the recalibration actually needs priced, IN THE
  # APPLICATION rather than only on the simulation designs it was chosen on:
  # the stopping rule itself, and the budget around its calibrated value.
  list(id = "R6a", label = "Rule: $\\tau_{\\mathrm{DP}} = 0.7$, $\\bar m = 2000$",
       coord = "rank", tau_dp = 0.7, imax = 2000L, patience = 100L,
       n_part = 4L),
  list(id = "R6b", label = "Budget $\\bar m = 30$",       coord = "rank",
       imax = 30L, patience = 30L),
  list(id = "R6c", label = "Budget $\\bar m = 60$",       coord = "rank",
       imax = 60L, patience = 60L),
  list(id = "R6d", label = "Budget $\\bar m = 8$",        coord = "rank",
       imax = 8L, patience = 8L),
  list(id = "R7",  label = "All 989 counties",         coord = "rank", full = TRUE)
  # ---------------------------------------------------------------------------
  # NO ROW IS ADDED HERE, AND THE ROW THE COLLAPSE FREED IS NOT SPENT EITHER.
  # Both are float-budget decisions rather than editorial ones.  A fourth
  # coordinate arm -- mu-g/m^3 at the SHIPPED h_x, so that the table carried its
  # own before/after -- was written, run and withdrawn for the same reason.
  #
  # THE BUDGET, MEASURED 2026-08-16 rather than quoted.  The fragment is set in
  # a rotated sidewaystable at \footnotesize with \tabcolsep 6pt.  Rotated, its
  # WIDTH runs along \textheight = 650.43pt and the whole threeparttable's
  # HEIGHT runs along the paper edge, 614.295pt = 612bp.  Measured naturally,
  # with setspace's float single-spacing and the note at \textheight (both of
  # which a naive \sbox gets wrong -- with \doublespacing live the same box
  # reports 964pt):
  #
  #     shipped, two coordinate rows      607.90pt wide    624.54pt high
  #     collapsed, this file              629.88pt wide    600.54pt high
  #
  # So the collapse RETURNS 24.0pt of the dimension that fails silently -- past
  # the paper edge there is no "Overfull \vbox", no "Float too large", exit code
  # 0 and a clean log (supplement.qmd's own note, which found it twice by
  # reading the PDF).  It spends 22.0pt of width, of which 42.5pt was free, and
  # spends it deliberately: threeparttable sets the note to the width of the
  # table, so width BUYS height, which is the trade the 4pt -> 6pt colsep change
  # already made.
  #
  # THE CAPTION COUNTS THE ARMS, AND THE COLLAPSE MAKES IT RIGHT FOR THE FIRST
  # TIME.  supplement.qmd captions this float "Fifteen tuning arms and two
  # comparison estimators".  ARMS held SEVENTEEN entries -- sixteen tuning arms
  # beside the baseline -- so the caption was already off by one before this
  # change, which is one more miscount the duplicated coordinate row produced.
  # It now holds sixteen, i.e. fifteen tuning arms, and the caption is correct
  # as written.  Anything added here breaks it again.
  #
  # *** supplement.qmd's 597.1pt / 622.0pt DO NOT DESCRIBE THIS FRAGMENT. ***
  # They were measured on the vintage in which this pair printed full numeric
  # rows (paper/qmd/_output/supplement.pdf p.34 still carries seventeen numeric
  # standard errors), not on one where they print a \multicolumn refusal.  The
  # figures above are of the shipped artifact and supersede them.
)

init_map <- list(control = init_control, robinson = init_robinson,
                 poly = init_poly)

# PARALLELISM.  The arms are parallelised, not the partitions inside an arm.
# An arm's wall time is the slowest of its partitions, so parallelising within
# an arm leaves the cores idle whenever one fold solve runs to the cap while
# the rest stop early; parallelising across arms keeps them busy.  Each arm
# gets its own deterministic L'Ecuyer anchor, so the result does not depend on
# how many arms happen to run concurrently.
#
# STREAMS ARE ADDRESSED BY ARM ID, NOT BY POSITION, FROM 2026-08-16.  They used
# to be ARM_ANCHOR[[j]] with the discrepancy-path block taking
# ARM_ANCHOR[[length(ARM_ANCHOR)]], so APPENDING ONE ARM WOULD HAVE MOVED THE
# PATH BLOCK'S STREAM -- and with it every number in
# paper/figures/app_tsp_lf_path.pdf -- for no reason connected to this change,
# while INSERTING one would have moved every arm after it.  Both would have made
# the table impossible to read: a row that moved because its fold split changed
# looks exactly like a row that moved because its constant changed.  The map
# below reproduces the historical positions exactly (R0..R7 = 1..17, paths = 18)
# and gives new arms unused indices, so arms 1-17 and the path figure are
# bit-for-bit what they were.
#
# A RETIRED INDEX IS RETIRED, NOT RECYCLED, from 2026-08-16.  Collapsing R1a and
# R1b (see the note above ARMS) frees index 3, and handing it to the next arm
# added would move that arm's fold split for a reason having nothing to do with
# the constant it varies -- the same defect addressing streams by POSITION had,
# arriving by a different route.  R1 keeps R1a's index 2, so the surviving
# coordinate arm reproduces R1a's guard report exactly and every rank arm is
# untouched.  RETIRED_STREAM is carried into the duplicate check and into
# make_streams()'s length so that the chain itself does not shorten.
ARM_STREAM <- c(R0 = 1L, R1 = 2L, R2a = 4L, R2b = 5L, R2c = 6L,
                R3a = 7L, R3b = 8L, R4a = 9L, R4b = 10L, R5a = 11L, R5b = 12L,
                R6a = 13L, R6b = 14L, R6c = 15L, R6d = 16L, R7 = 17L)
RETIRED_STREAM <- c(R1b = 3L)
PATH_STREAM <- 18L
stopifnot(setequal(names(ARM_STREAM), vapply(ARMS, \(a) a$id, character(1))),
          !anyDuplicated(c(ARM_STREAM, RETIRED_STREAM, PATH_STREAM)),
          !any(names(RETIRED_STREAM) %in% names(ARM_STREAM)))
ARM_ANCHOR <- make_streams(max(ARM_STREAM, RETIRED_STREAM, PATH_STREAM))

run_arm <- function(j) {
  a <- ARMS[[j]]
  d  <- if (isTRUE(a$full)) raw else dt
  Zj <- if (isTRUE(a$full)) Z_full else Z
  xc <- make_x_coord(d$x1_raw, d$x2_raw, mode = a$coord)
  assign(".Random.seed", ARM_ANCHOR[[ARM_STREAM[[a$id]]]], envir = globalenv())
  t0 <- Sys.time()
  ## THE FAILURE MESSAGE IS CARRIED, NOT DISCARDED.  It used to go to the log
  ## and nowhere else, so the table could say only "did not run" -- which reads
  ## as laziness rather than as the finding it is.  make_operator()'s refusal
  ## names the minimum of pi-hat, how many points it was non-positive at, and
  ## |X| / h_x; all three belong in the .rds, and the first belongs in the cell.
  ##
  ## The handler returns a CLASSED SENTINEL rather than assigning out of its own
  ## frame: `<<-` is on this project's prohibited list, and the sentinel is the
  ## idiom app_tsp_05_phi_band.R's full_sample_arm() already uses for the same
  ## job.
  got <- tryCatch(
    fit_orthogonal(d$dy, xc$x1, xc$x2, Zj, d$w, d$cluster,
                   K = a$K %||% N_FOLDS, n_part = a$n_part %||% N_PART_ROB,
                   cste = if (is.null(a$cste)) LF_CSTE else a$cste,
                   init_fn = init_map[[a$init %||% "control"]],
                   lf_imax = a$imax %||% lf_mbar(d$w),
                   lf_patience = a$patience %||% lf_patience_for(d$w),
                   tau_dp = a$tau_dp %||% TAU_DP,
                   rho = a$rho %||% RHO, xeval = grid_for(xc$x1, xc$x2),
                   hx_scale = a$hx_scale %||% 1,
                   n_cores = 1L),
    error = \(e) structure(conditionMessage(e), class = "arm_error"))
  ## `is_err`, not `failed`: the table block below has a top-level `failed` and
  ## two objects of the same name at two scopes is how a later edit picks up the
  ## wrong one.
  is_err <- inherits(got, "arm_error")
  msg <- if (is_err) as.character(got) else NA_character_
  f   <- if (is_err) NULL else got
  if (is_err) message(sprintf("  arm %s FAILED: %s", a$id, msg))
  if (!is.null(f)) {
    message(sprintf(paste0("%-4s %-38s %5.0fs  n=%d  h-scale %.3f  LF: med %4.0f",
                           ", %d/%d at 1, %d capped"),
                    a$id, a$label,
                    as.numeric(difftime(Sys.time(), t0, units = "secs")),
                    f$n, a$hx_scale %||% 1, f$lf_m_median, f$lf_at_one,
                    nrow(f$lf), f$lf_hit_cap))
  }
  # The heaviest field is the per-partition fit record, which the robustness
  # table does not read; dropping it keeps the serialised return small.
  if (!is.null(f)) f$fits <- NULL
  list(arm = a, fit = f, error = msg)
}

rob <- parallel::mclapply(seq_along(ARMS), run_arm, mc.cores = N_CORES,
                          mc.preschedule = FALSE)

# ---- R8: comparison estimators ---------------------------------------------

xc0 <- make_x_coord(dt$x1_raw, dt$x2_raw, mode = "rank")
tsls <- tsls_theta(dt$dy, xc0$x1, xc0$x2, Z, dt$w)
alt  <- alternating_theta(dt$dy, xc0$x1, xc0$x2, Z, dt$w, cste = LF_CSTE,
                          init_fn = init_control, xeval = grid_for(xc0$x1, xc0$x2),
                          lf_imax = lf_mbar(dt$w), tau_dp = TAU_DP)

# ---- Discrepancy paths ------------------------------------------------------
#
# crossfit_once() records only the argmin and the stop; the PATH is what shows
# whether the stopping rule fires on a semiconvergent curve (falls, then rises)
# or on a monotonically rising one (in which case phi-hat is the initial
# condition and the LF step contributed nothing).  Five fold solves are rerun
# here at the baseline configuration purely to recover their paths.

assign(".Random.seed", ARM_ANCHOR[[PATH_STREAM]], envir = globalenv())
folds <- sample(rep_len(seq_len(N_FOLDS), n))
paths <- vector("list", N_FOLDS)                                     # INV-17
for (k in seq_len(N_FOLDS)) {
  rest <- which(folds != k)
  op_idx <- sample(rest, floor(length(rest) / 2))
  sol <- setdiff(rest, op_idx)
  op <- make_operator(xc0$x1[sol], xc0$x2[sol], grid_for(xc0$x1, xc0$x2),
                      hx = c(bw_rot(xc0$x1[op_idx]), bw_rot(xc0$x2[op_idx])))
  ini <- init_control(dt$dy[sol], xc0$x1[sol], xc0$x2[sol],
                      Z[sol, , drop = FALSE], dt$w[sol], op)
  ft <- lf_solve(dt$dy[sol], xc0$x1[sol], xc0$x2[sol], Z[sol, , drop = FALSE],
                 dt$w[sol], op, ini, cste = LF_CSTE, imax = lf_mbar(dt$w),
                 patience = lf_patience_for(dt$w), tau_dp = TAU_DP)
  paths[[k]] <- data.frame(fold = k, iter = seq_along(ft$err_path),
                           err = ft$err_path, argmin = ft$iter,
                           cste = ft$cste, stringsAsFactors = FALSE)
  message(sprintf("path fold %d: cste = %.3f, argmin = %d of %d, cap = %s",
                  k, ft$cste, ft$iter, ft$stopped_at, ft$hit_cap))
}
path_dt <- do.call(rbind, paths)

#' The printed reason an arm produced no estimate.
#'
#' "did not run" WAS THE CELL TEXT UNTIL 2026-08-16 and it was the wrong report
#' in two ways: the arm DID run -- it ran and the estimator refused -- and the
#' refusal is a finding about the configuration, not an absence of one.
#'
#' *** WHAT THE CELL SAYS CHANGED AGAIN ON 2026-08-16, AND THE SECOND CHANGE
#' MATTERS MORE THAN THE FIRST. ***  The guard's own quantities -- "pi-hat <= 0
#' at 11 of 846 points, min = -7.5e-04" -- are a report about ONE bandwidth, and
#' a reader who has just been told the bandwidth was matched will read them as
#' an invitation to match it differently.  There is no such bandwidth: stage 11
#' sweeps h_x over a factor of 120 at 120 operator builds per rung and finds two
#' feasible rungs out of thirty-one, a window 5 per cent wide sitting five times
#' below the rule of thumb, on which the DENSE grid still carries a negative
#' pi-hat on 120 of 120 builds.  The rank coordinate clears twenty-three of the
#' same thirty-one.  So the cell states the LADDER, which is a C1(ii) statement
#' about the coordinate, and not the point counts, which are a statement about a
#' tuning choice.  Both are kept in the .rds; only one fits in a table cell.
#'
#' The message parsed here is make_operator()'s, two frames down, and its format
#' is fixed by that function's sprintf().  It is still parsed -- the point counts
#' and the minimum go to the artifact and the log -- and a message this does not
#' recognise is NOT swallowed: the first clause is escaped and printed, so a new
#' failure mode announces itself instead of masquerading as the known one.
#'
#' THE CELL IS WIDTH-CONSTRAINED, and the constraint is measured rather than
#' quoted.  This string spans the six estimate/SE columns, whose own natural
#' width it must not exceed by more than the fragment's slack against the
#' rotated \\textheight budget of 650.43pt.  Measured 2026-08-16: the shipped
#' fragment is 607.90pt and this text takes it to 629.88pt, 20.55pt inside the
#' wall, while shortening the whole float by 24.0pt (see the note above ARMS).
#'
#' @param msg character(1). conditionMessage() of the arm's error, or NA.
#' @param win list or NULL. coord_window()'s return for the arm's coordinate.
#'   NULL prints the guard's point counts instead, which is the right fallback
#'   for any arm the ladder does not cover.
#' @return character(1), LaTeX-safe, for a \\multicolumn cell.
fail_reason <- function(msg, win = NULL) {
  if (is.na(msg) || !nzchar(msg)) return("not estimable (no message recorded)")
  if (grepl("pi-hat is not strictly positive", msg, fixed = TRUE)) {
    if (!is.null(win)) {
      ## The window's endpoints are in the arm's own units (mu-g/m^3); the row
      ## label names the coordinate, and the note carries the units.  Three
      ## decimals because that is the resolution at which the two endpoints
      ## differ in the third figure, and rounding them together would print a
      ## degenerate interval for a window that is 5 per cent wide.
      return(sprintf(paste0("$h_x$ matched; $\\hat\\pi \\leq 0$: %d of %d ",
                            "rungs feasible, $[%.3f, %.3f]$; rank %d of %d"),
                     win$n_ok, win$n_rungs, win$h_lo, win$h_hi,
                     win$n_ok_rank, win$n_rungs_rank))
    }
    ## The number pattern is anchored and complete rather than a character
    ## class: the guard's message ends in a full stop, and "[-+0-9.eE]+" is
    ## greedy enough to swallow it, which turns "8.8." into an NA on coercion.
    NUM <- "[-+]?[0-9]*\\.?[0-9]+([eE][-+]?[0-9]+)?"
    num <- function(lead) {
      m <- regmatches(msg, regexpr(paste0(lead, NUM), msg))
      if (!length(m)) return(NA_real_)
      as.numeric(sub(lead, "", m))
    }
    ints <- function(pat) {
      m <- regmatches(msg, regexpr(pat, msg))
      if (!length(m)) return(NA_integer_)
      sum(as.integer(regmatches(m, gregexpr("[0-9]+", m))[[1]]))
    }
    mn <- num("min = ")
    nb <- ints("non-positive at [0-9]+ \\+ [0-9]+ \\+ [0-9]+")
    np <- ints("of [0-9]+ \\+ [0-9]+ \\+ [0-9]+ points")
    if (is.finite(mn) && !is.na(nb) && !is.na(np)) {
      ## fmt_sci() returns its own math delimiters; strip them and open one
      ## math group, so the cell cannot end up with "$$" in the middle of it.
      return(sprintf("$\\hat\\pi \\leq 0$ at %d of %d points, $\\min = %s$",
                     nb, np, gsub("$", "", fmt_sci(mn, 1L), fixed = TRUE)))
    }
    return("$\\hat\\pi \\leq 0$: the adjoint would divide by it")
  }
  paste0("not estimable: ", tex_escape(sub("\\..*$", "", msg)))
}

#' The guard's own point counts, for the artifact and the log.
#'
#' Kept as a separate function from 2026-08-16: the cell no longer prints these,
#' and a quantity that stops being printed should not stop being recorded.
#'
#' @param msg character(1). conditionMessage() of the arm's error, or NA.
#' @return named list: n_bad, n_points, min_pi -- NA when unparsed.
guard_counts <- function(msg) {
  if (is.na(msg) || !nzchar(msg)) {
    return(list(n_bad = NA_integer_, n_points = NA_integer_,
                min_pi = NA_real_))
  }
  NUM <- "[-+]?[0-9]*\\.?[0-9]+([eE][-+]?[0-9]+)?"
  sum_ints <- function(pat) {
    m <- regmatches(msg, regexpr(pat, msg))
    if (!length(m)) return(NA_integer_)
    as.integer(sum(as.integer(regmatches(m, gregexpr("[0-9]+", m))[[1]])))
  }
  mm <- regmatches(msg, regexpr(paste0("min = ", NUM), msg))
  list(n_bad = sum_ints("non-positive at [0-9]+ \\+ [0-9]+ \\+ [0-9]+"),
       n_points = sum_ints("of [0-9]+ \\+ [0-9]+ \\+ [0-9]+ points"),
       min_pi = if (length(mm)) as.numeric(sub("min = ", "", mm)) else NA_real_)
}

# ---- Table ------------------------------------------------------------------
#
# One row per arm.  The reported coefficients are the intercept and the two
# controls with the largest baseline |t|, so the table stays readable; the full
# vector for every arm is in the .rds.

failed <- vapply(rob, \(r) is.null(r$fit), logical(1))
if (any(failed)) {
  message(sprintf("arms that produced no fit: %s",
                  paste(vapply(ARMS[failed], \(a) a$id, character(1)),
                        collapse = ", ")))
  ## THE GUARD'S POINT COUNTS ARE LOGGED EVEN THOUGH THE CELL NO LONGER PRINTS
  ## THEM.  The cell states the ladder now (see fail_reason()); these are the
  ## quantities it replaced, and a number that stops being printed should not
  ## stop being recorded -- the raw message is in the .rds, this is the parse.
  for (r in rob[failed]) {
    gc_i <- guard_counts(r$error)
    message(sprintf(paste0("  %-4s guard: pi-hat <= 0 at %s of %s points, ",
                           "min = %s"),
                    r$arm$id, format(gc_i$n_bad), format(gc_i$n_points),
                    format(gc_i$min_pi, digits = 4)))
  }
}
if (is.null(rob[[1]]$fit)) stop("baseline arm R0 produced no fit")

base_fit <- rob[[1]]$fit
tstat <- abs(base_fit$theta / base_fit$se_cl)
ord <- order(tstat, decreasing = TRUE)

## ---------------------------------------------------------------------------
## *** THE THREE PRINTED SLOTS ARE PINNED, 2026-08-16 (AUTHOR RULING).  THEY
## WERE A DATA-DEPENDENT SELECTION AND SECTION 6 NAMES THEM IN PROSE. ***
##
## The constant was already pinned; the other two were whichever controls had
## the largest baseline |t|.  That made the table's COLUMNS a random variable:
## re-run the estimator, and every sentence in Section 6 saying "Population" or
## "High school" goes stale silently, because the table would simply have
## different columns and nothing would announce it.
##
## THE MARGIN IS WHY THIS IS NOT HYPOTHETICAL.  It has halved twice under
## changes that had nothing to do with the control set: 0.23% after the
## 2026-08-15 kernel change, and 0.0917% now -- High school at |t| = 2.6667
## against per capita income at 2.6642, a gap of 0.0024 in |t| on an estimator
## whose own cross-fitting component is 0.230 of the standard error.  A
## selection that turns on a difference two orders of magnitude below the
## estimator's own noise is not a selection; it is a coin toss that renames the
## paper's columns.
##
## SO THE SELECTION IS FIXED AND THE INSTRUMENTATION STAYS.  What prints is
## SHOW_NM_SHIPPED, always.  `sel_flipped` now reports that the WOULD-BE
## selection changed -- a diagnostic about the data, no longer a description of
## the table -- so the author learns that the ordering moved without the columns
## moving under the prose.  Both objects are saved; only the first is printed.
SHOW_NM_SHIPPED <- c("const", "Population", "HighSchool")
show_nm  <- SHOW_NM_SHIPPED
show_idx <- match(show_nm, base_fit$coef_names)
if (anyNA(show_idx)) {
  stop(sprintf(paste("app_tsp_03_robustness: pinned coefficient(s) %s are not",
                     "in the baseline design (have: %s).  The pin is a",
                     "specification, so a missing name is a stop, not a",
                     "fallback to whatever is there."),
               paste(show_nm[is.na(show_idx)], collapse = ", "),
               paste(base_fit$coef_names, collapse = ", ")))
}
## The selection the free rule WOULD have made, reproduced exactly as it was
## computed before the pin so the two are comparable run to run.
free_idx <- unique(c(1L, ord[seq_len(min(2L, length(ord)))]))
show_nm_free <- base_fit$coef_names[free_idx]
sel_margin <- if (length(ord) >= 3L) {
  (tstat[ord[2L]] - tstat[ord[3L]]) / tstat[ord[2L]]
} else NA_real_
sel_flipped <- !identical(show_nm_free, SHOW_NM_SHIPPED)
message(sprintf("selection: %s (PINNED) -- free rule would print: %s -- %s",
                paste(show_nm, collapse = ", "),
                paste(show_nm_free, collapse = ", "),
                if (sel_flipped) "*** FLIPPED ***" else "unchanged"))
message(sprintf(paste0("  |t| ordering: %s;  margin between the last printed ",
                       "and the first dropped = %.4f%% (%.4f vs %.4f)"),
                paste(sprintf("%s %.3f", base_fit$coef_names[ord[seq_len(min(5L, length(ord)))]],
                              tstat[ord[seq_len(min(5L, length(ord)))]]),
                      collapse = " > "),
                100 * sel_margin, tstat[ord[2L]], tstat[ord[3L]]))
if (sel_flipped) {
  message("  *** the free rule's selection MOVED.  What prints did not: the ",
          "slots are pinned, so Section 6's prose is NOT stale.  Reported so ",
          "the ordering's instability is on the log rather than in the table.")
}

rob_row <- function(r) {
  a <- r$arm
  f <- r$fit
  if (is.null(f)) {
    ## The ladder is cited only for the coordinate it was swept in.  Any other
    ## refusal falls back to the guard's own point counts, which is what the
    ## `win = NULL` branch of fail_reason() is for.
    win <- if (identical(a$coord, WIN$mode)) WIN else NULL
    return(sprintf("%s & \\multicolumn{%d}{c}{%s} & -- & -- & -- \\\\",
                   a$label, 2L * length(show_nm), fail_reason(r$error, win)))
  }
  i <- match(show_nm, f$coef_names)
  cells <- unlist(Map(\(k) c(fmt(f$theta[k], 4),
                             sprintf("(%s)", fmt(f$se_cl[k], 4))), i),
                  use.names = FALSE)
  sprintf("%s & %s & %s & %s & %s \\\\", a$label, paste(cells, collapse = " & "),
          fmt(f$lf_m_median, 0),
          sprintf("%d/%d", f$lf_at_one, nrow(f$lf)),
          sprintf("%d/%d", f$lf_hit_cap, nrow(f$lf)))
}

hdr_top <- paste0("& ",
  paste(sprintf("\\multicolumn{2}{c}{%s}", COEF_LABELS[show_nm]),
        collapse = " & "),
  " & Median & \\multicolumn{2}{c}{Fold solves} \\\\")
cmid2 <- sprintf("\\cmidrule(lr){%d-%d}", 2L * length(show_nm) + 3L,
                 2L * length(show_nm) + 4L)
hdr_mid <- paste0("Arm & ",
  paste(rep("Estimate & (SE) ", length(show_nm)), collapse = "& "),
  "& $\\hat m$ & at $\\hat m = 1$ & at the cap \\\\")
cmid <- paste(vapply(seq_along(show_nm), \(k)
  sprintf("\\cmidrule(lr){%d-%d}", 2L * k, 2L * k + 1L), character(1)),
  collapse = " ")

cmp <- c(
  "\\addlinespace",
  sprintf("\\multicolumn{%d}{l}{\\textit{Comparison estimators}} \\\\",
          2L * length(show_nm) + 4L),
  sprintf("Linear IV (2SLS) & %s & -- & -- & -- \\\\",
          paste(unlist(Map(\(k) c(fmt(tsls$coef[k + 1L], 4),
                                  sprintf("(%s)", fmt(tsls$se[k + 1L], 4))),
                           show_idx), use.names = FALSE), collapse = " & ")),
  sprintf("Alternating LF (draft estimator) & %s & %s & -- & -- \\\\",
          paste(unlist(Map(\(k) c(fmt(alt$theta[k], 4), "--"), show_idx),
                       use.names = FALSE), collapse = " & "),
          formatC(alt$iter, format = "d")))

colspec <- paste0("l", paste(rep("rr", length(show_nm)), collapse = ""), "rrr")
header  <- c(hdr_top, paste(cmid, cmid2), hdr_mid)
body    <- c(vapply(rob, rob_row, character(1)), cmp)

## ---------------------------------------------------------------------------
## COLUMN-COUNT ASSERTION.  Any row that is not a plain estimate row -- the
## placeholder a refused arm leaves, the panel label, the comparison block --
## reaches the column count through a \multicolumn span, and a span that does not
## agree with the header is a silent LaTeX misalignment: the row still typesets,
## just in the wrong columns.  Checked here rather than trusted, because the
## refused arms are exactly the rows that use spans and they are the rows this
## revision touches.
tex_ncol <- function(line) {
  s <- sub("\\s*\\\\\\\\\\s*$", "", line)
  sp <- regmatches(s, gregexpr("(?<=\\\\multicolumn\\{)[0-9]+", s, perl = TRUE))[[1]]
  amp <- gregexpr("&", s, fixed = TRUE)[[1]]
  n_amp <- if (amp[1L] == -1L) 0L else length(amp)
  n_amp + 1L + sum(as.integer(sp) - 1L)
}
n_col <- nchar(gsub("[^lrc]", "", colspec))
rows <- grep("\\\\\\\\\\s*$", c(header, body), value = TRUE)
got <- vapply(rows, tex_ncol, integer(1), USE.NAMES = FALSE)
if (any(got != n_col)) {
  stop(sprintf(paste("app_tsp_03_robustness: %d table row(s) do not span the",
                     "%d declared columns: %s"),
               sum(got != n_col), n_col,
               paste(sprintf("[%d cols] %s", got[got != n_col],
                             substr(rows[got != n_col], 1L, 60L)),
                     collapse = " | ")))
}

write_tabular(colspec, header, body,
              file.path(TAB, "app_tsp_robustness.tex"))

saveRDS(list(arms = rob, tsls = tsls, alternating = alt, paths = path_dt,
             show_nm = show_nm, show_idx = show_idx, tstat = tstat,
             sel_order = base_fit$coef_names[ord], sel_margin = sel_margin,
             ## THE PIN, AND WHAT THE FREE RULE WOULD HAVE DONE.  `sel_pinned`
             ## is new on 2026-08-16 and is the field a reader should check
             ## before believing `sel_flipped` says anything about the table:
             ## since the pin, a flip moves the ORDERING and not the columns.
             sel_pinned = TRUE, sel_free = show_nm_free,
             sel_flipped = sel_flipped, sel_shipped = SHOW_NM_SHIPPED,
             hx_scale = c(rank = 1, ugm3 = HX_UGM3, minmax = HX_MINMAX),
             ## ---------------------------------------------------------------
             ## THE COLLAPSE, RECORDED SO THE WRITER SOURCES IT FROM HERE.
             ##
             ## The table prints ONE non-rank coordinate row and its cell holds
             ## four numbers.  Everything else the row rests on is below, in the
             ## form the table note (INV-1) needs, because a note that cannot be
             ## traced to an artifact is how "their standard errors inflate at
             ## every printed coordinate" -- a sentence about arms that no
             ## longer produce standard errors -- is still in the supplement.
             coord_collapsed = list(
               kept = "R1", retired = "R1b",
               reason = paste("min--max is an exact affine image of mu-g/m^3",
                              "(app_tsp_11_hxmatch.R Panel C: pi-hat differs",
                              "by exactly rg, max relative deviation",
                              "7.07e-14), so the two arms are one test in two",
                              "sets of units and cannot disagree about",
                              "feasibility.  The pair's old disagreement --",
                              "1.2756 against 1.1937 on High school -- was",
                              "L'Ecuyer stream noise: they drew streams 2 and",
                              "3 and so saw different cross-fitting",
                              "partitions."),
               window = WIN),
             headline_dz = HEADLINE_DZ),
        file.path(OUT, "app_tsp_robustness.rds"))

message("done: app_tsp_03_robustness")
