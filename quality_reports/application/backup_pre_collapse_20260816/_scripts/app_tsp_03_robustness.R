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
#   R1  coordinate for X          rank (baseline) / ug-m^3 / min-max, EACH AT A
#                                 COORDINATE-MATCHED h_x (C28), plus one arm at
#                                 the shipped h_x to price the match
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
# THE MATCHED CONSTANT IS THE SAME NUMBER FOR BOTH COORDINATES, and that is a
# fact about them, not a coincidence: min-max is (X - lo) / rg, an AFFINE image
# of mu-g/m^3, and |X| / h_x is affine-invariant because bw_rot() scales with
# sd.  app_tsp_11_hxmatch.R Panel C checks numerically that pi-hat in the two
# coordinates differs by exactly the factor rg (max relative deviation 7e-14),
# i.e. that R1b tests nothing R1a does not.  Both are kept: the pair is the
# check.
#
# THEIR TWO ROWS DO NOT PRINT THE SAME NUMBERS, AND THAT IS NOT A CONTRADICTION.
# The arms draw from DIFFERENT L'Ecuyer streams (2 and 3), so they see different
# cross-fitting partitions and the guard fires on a different fold in each; the
# printed minima are in the ratio 637, not the 428.1 the coordinates are apart.
# The equivalence is between the two coordinates AT A COMMON FOLD, which is what
# Panel C measures and what a table row cannot show.  The gap between the two
# rows is therefore a read on cross-fitting noise, not on the coordinate -- and
# the same caveat applies to the 1.2756 / 1.1937 pair the arms used to print,
# which differ by 6.4 per cent for the same reason and were read at the time as
# though the two coordinates disagreed.
HX_UGM3   <- hx_scale_for(dt$x1_raw, dt$x2_raw, "ugm3")
HX_MINMAX <- hx_scale_for(dt$x1_raw, dt$x2_raw, "minmax")
message(sprintf("C28: hx_scale = %.4f (ug/m^3), %.4f (min-max); rank = 1",
                HX_UGM3, HX_MINMAX))

# ---- Arm definitions --------------------------------------------------------
#
# Each arm names the ONE constant it moves; everything else is the baseline.
# The coordinate arms move TWO -- the coordinate and, with it, h_x -- and that
# is the point: holding h_x fixed is what made the coordinate arm impure.

ARMS <- list(
  list(id = "R0", label = "Baseline",                 coord = "rank"),
  list(id = "R1a", label = "$X$ in $\\mu$g/m$^3$ ($h_x$ matched)",
       coord = "ugm3", hx_scale = HX_UGM3),
  list(id = "R1b", label = "$X$ min--max scaled ($h_x$ matched)",
       coord = "minmax", hx_scale = HX_MINMAX),
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
  # NO ROW IS ADDED HERE, AND THAT IS A FLOAT-BUDGET DECISION RATHER THAN AN
  # EDITORIAL ONE.  A fourth coordinate arm -- mu-g/m^3 at the SHIPPED h_x, so
  # that the table carried its own before/after -- was written, run, and then
  # withdrawn: this fragment is set in a rotated sidewaystable at \footnotesize
  # whose measured natural height is 597.1pt against a 612pt wall
  # (supplement.qmd's own note), so one more body row spends most of the
  # remaining slack, and the caption counts the arms.  The measurement it would
  # have carried is not lost: app_tsp_11_hxmatch.R sweeps h_x over a factor of
  # 24 in BOTH coordinates and records the whole feasibility ladder, which is
  # strictly more than one row could have said.
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
ARM_STREAM <- c(R0 = 1L, R1a = 2L, R1b = 3L, R2a = 4L, R2b = 5L, R2c = 6L,
                R3a = 7L, R3b = 8L, R4a = 9L, R4b = 10L, R5a = 11L, R5b = 12L,
                R6a = 13L, R6b = 14L, R6c = 15L, R6d = 16L, R7 = 17L)
PATH_STREAM <- 18L
stopifnot(setequal(names(ARM_STREAM), vapply(ARMS, \(a) a$id, character(1))),
          !anyDuplicated(c(ARM_STREAM, PATH_STREAM)))
ARM_ANCHOR <- make_streams(max(ARM_STREAM, PATH_STREAM))

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
}
if (is.null(rob[[1]]$fit)) stop("baseline arm R0 produced no fit")

base_fit <- rob[[1]]$fit
tstat <- abs(base_fit$theta / base_fit$se_cl)
ord <- order(tstat, decreasing = TRUE)
show_idx <- unique(c(1L, ord[seq_len(min(2L, length(ord)))]))
show_nm <- base_fit$coef_names[show_idx]

## ---------------------------------------------------------------------------
## THE PRINTED COEFFICIENTS ARE A DATA-DEPENDENT SELECTION, AND SECTION 6 NAMES
## THEM IN PROSE.  The constant is PINNED; the other two are whichever controls
## have the largest baseline |t|.  So the selection can FLIP when the estimator
## changes, and if it does, every sentence in Section 6 that says "Population"
## or "High school" goes stale silently -- the table would simply have different
## columns.  The margin is therefore computed and printed on every run rather
## than checked by eye.  It survived the 2026-08-15 kernel change at a 0.23%
## margin, which is exactly why this is now instrumented.
SHOW_NM_SHIPPED <- c("const", "Population", "HighSchool")
sel_margin <- if (length(ord) >= 3L) {
  (tstat[ord[2L]] - tstat[ord[3L]]) / tstat[ord[2L]]
} else NA_real_
sel_flipped <- !identical(show_nm, SHOW_NM_SHIPPED)
message(sprintf("selection: %s  (shipped: %s) -- %s",
                paste(show_nm, collapse = ", "),
                paste(SHOW_NM_SHIPPED, collapse = ", "),
                if (sel_flipped) "*** FLIPPED ***" else "unchanged"))
message(sprintf(paste0("  |t| ordering: %s;  margin between the last printed ",
                       "and the first dropped = %.2f%% (%.4f vs %.4f)"),
                paste(sprintf("%s %.3f", base_fit$coef_names[ord[seq_len(min(5L, length(ord)))]],
                              tstat[ord[seq_len(min(5L, length(ord)))]]),
                      collapse = " > "),
                100 * sel_margin, tstat[ord[2L]], tstat[ord[3L]]))
if (sel_flipped) {
  message("  *** Section 6 prose naming the printed coefficients is now STALE.")
}

#' The printed reason an arm produced no estimate.
#'
#' "did not run" WAS THE CELL TEXT UNTIL 2026-08-16 and it was the wrong report
#' in two ways: the arm DID run -- it ran and the estimator refused -- and the
#' refusal is a finding about the configuration, not an absence of one.  What
#' goes in the cell now is the guard's own quantities.
#'
#' The message parsed here is make_operator()'s, two frames down, and its format
#' is fixed by that function's sprintf().  A message this does not recognise is
#' NOT swallowed: the first clause is escaped and printed, so a new failure mode
#' announces itself instead of masquerading as the known one.
#'
#' THE CELL IS WIDTH-CONSTRAINED, so the reason is short by necessity as well as
#' by taste.  The fragment is set rotated at \\footnotesize with a measured
#' natural width of 622pt against a 650.4pt budget (supplement.qmd's own note),
#' and this string spans the six estimate/SE columns, whose own natural width it
#' must not exceed.  The full guard message -- which also names |X|/h_x and the
#' split of the non-positive points across (pi_1, pi_2, pi_ev) -- is carried
#' verbatim in app_tsp_robustness.rds under arms[[j]]$error.
#'
#' @param msg character(1). conditionMessage() of the arm's error, or NA.
#' @return character(1), LaTeX-safe, for a \\multicolumn cell.
fail_reason <- function(msg) {
  if (is.na(msg) || !nzchar(msg)) return("not estimable (no message recorded)")
  if (grepl("pi-hat is not strictly positive", msg, fixed = TRUE)) {
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

rob_row <- function(r) {
  a <- r$arm
  f <- r$fit
  if (is.null(f)) {
    return(sprintf("%s & \\multicolumn{%d}{c}{%s} & -- & -- & -- \\\\",
                   a$label, 2L * length(show_nm), fail_reason(r$error)))
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
             sel_flipped = sel_flipped, sel_shipped = SHOW_NM_SHIPPED,
             hx_scale = c(rank = 1, ugm3 = HX_UGM3, minmax = HX_MINMAX),
             headline_dz = HEADLINE_DZ),
        file.path(OUT, "app_tsp_robustness.rds"))

message("done: app_tsp_03_robustness")
