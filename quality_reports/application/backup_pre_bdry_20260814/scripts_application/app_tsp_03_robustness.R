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
#   R1  coordinate for X          rank (baseline) / ug-m^3 / min-max
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

# ---- Arm definitions --------------------------------------------------------
#
# Each arm names the ONE constant it moves; everything else is the baseline.

ARMS <- list(
  list(id = "R0", label = "Baseline",                 coord = "rank"),
  list(id = "R1a", label = "$X$ in $\\mu$g/m$^3$",     coord = "ugm3"),
  list(id = "R1b", label = "$X$ min--max scaled",      coord = "minmax"),
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
)

init_map <- list(control = init_control, robinson = init_robinson,
                 poly = init_poly)

# PARALLELISM.  The arms are parallelised, not the partitions inside an arm.
# An arm's wall time is the slowest of its partitions, so parallelising within
# an arm leaves the cores idle whenever one fold solve runs to the cap while
# the rest stop early; parallelising across arms keeps them busy.  Each arm
# gets its own deterministic L'Ecuyer anchor, so the result does not depend on
# how many arms happen to run concurrently.
ARM_ANCHOR <- make_streams(length(ARMS) + 1L)

run_arm <- function(j) {
  a <- ARMS[[j]]
  d  <- if (isTRUE(a$full)) raw else dt
  Zj <- if (isTRUE(a$full)) Z_full else Z
  xc <- make_x_coord(d$x1_raw, d$x2_raw, mode = a$coord)
  assign(".Random.seed", ARM_ANCHOR[[j]], envir = globalenv())
  t0 <- Sys.time()
  f <- tryCatch(
    fit_orthogonal(d$dy, xc$x1, xc$x2, Zj, d$w, d$cluster,
                   K = a$K %||% N_FOLDS, n_part = a$n_part %||% N_PART_ROB,
                   cste = if (is.null(a$cste)) LF_CSTE else a$cste,
                   init_fn = init_map[[a$init %||% "control"]],
                   lf_imax = a$imax %||% lf_mbar(d$w),
                   lf_patience = a$patience %||% lf_patience_for(d$w),
                   tau_dp = a$tau_dp %||% TAU_DP,
                   rho = a$rho %||% RHO, xeval = grid_for(xc$x1, xc$x2),
                   n_cores = 1L),
    error = \(e) {
      message(sprintf("  arm %s FAILED: %s", a$id, conditionMessage(e)))
      NULL
    })
  if (!is.null(f)) {
    message(sprintf("%-4s %-28s %5.0fs  n=%d  LF: med %4.0f, %d/%d at 1, %d capped",
                    a$id, a$label,
                    as.numeric(difftime(Sys.time(), t0, units = "secs")),
                    f$n, f$lf_m_median, f$lf_at_one, nrow(f$lf),
                    f$lf_hit_cap))
  }
  # The heaviest field is the per-partition fit record, which the robustness
  # table does not read; dropping it keeps the serialised return small.
  if (!is.null(f)) f$fits <- NULL
  list(arm = a, fit = f)
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

assign(".Random.seed", ARM_ANCHOR[[length(ARM_ANCHOR)]], envir = globalenv())
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
ord <- order(abs(base_fit$theta / base_fit$se_cl), decreasing = TRUE)
show_idx <- unique(c(1L, ord[seq_len(min(2L, length(ord)))]))
show_nm <- base_fit$coef_names[show_idx]

rob_row <- function(r) {
  a <- r$arm
  f <- r$fit
  if (is.null(f)) {
    return(sprintf("%s & \\multicolumn{%d}{c}{did not run} & -- & -- & -- \\\\",
                   a$label, 2L * length(show_nm)))
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

write_tabular(
  paste0("l", paste(rep("rr", length(show_nm)), collapse = ""), "rrr"),
  c(hdr_top, paste(cmid, cmid2), hdr_mid),
  c(vapply(rob, rob_row, character(1)), cmp),
  file.path(TAB, "app_tsp_robustness.tex"))

saveRDS(list(arms = rob, tsls = tsls, alternating = alt, paths = path_dt,
             show_nm = show_nm, headline_dz = HEADLINE_DZ),
        file.path(OUT, "app_tsp_robustness.rds"))

message("done: app_tsp_03_robustness")
