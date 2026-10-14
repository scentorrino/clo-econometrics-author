# ============================================================================
# sim_thm_rootn_headroom.R
#
# DOES thm:rootn's LIMIT LAW BIND AT A FEASIBLE SAMPLE SIZE WHEN THE STEP-4
# REMAINDER IS PRESENT BUT SMALL?
#
# The shipped limit-law arm (sim_thm_rootn_limitlaw.R) returns "matches at large
# n only" at the frontier-clearing configuration (mu, s, a, r, d_Z) =
# (2, 3, 3/4, 8/3, 3). At that configuration kappa alpha = 0.2560 against
# eq:frontier's 1/4 -- a margin of 0.006 -- so the leading Step-4 product
# sqrt(n) delta_n^2 = n^{-0.012} (ln n)^{1.6} RISES across the entire Monte Carlo
# grid (11.7 to 46.7) and does not turn over until n = 10^{57.9}. The shipped
# experiment never entered the regime the theorem describes; it measured the
# remainder. The shipped ablation shows the other end: with the nuisances exact
# the remainder is zero by construction and coverage is nominal. What neither
# settles is the case in between -- REMAINDER PRESENT BUT BELOW BUDGET -- which
# is a strictly stronger test than the ablation and is what this arm runs.
#
# THE DESIGN, AND WHAT IS AND IS NOT NEW HERE. The configuration is Design H of
# sim_thm_rootn_headroom_dgp.R: (mu, s, a, r, d_Z) = (5, 4, 2/5, 21/8, 1) at
# p_K = 8, p = 2, giving kappa alpha = 0.3818 -- a frontier margin of 0.132,
# twenty-two times the shipped one. THE ESTIMATOR IS NOT TOUCHED: one_rep_full()
# and run_cell() are LIFTED OUT OF THE SHIPPED ARM by parsing it (hr_lift_defs),
# so the replication path is the shipped path byte for byte. What this file
# supplies is a configuration, a d_Z-general DGP (proved equivalent to the
# shipped one at d_Z = 3) and the reporting the decision rule needs.
#
# THE DECISION RULE IS FIXED BEFORE THE RESULT AND IS NOT NEGOTIABLE AFTERWARD:
#   (1) nominal coverage, within two Monte Carlo standard errors, at cells whose
#       realised budget is below 1  ->  the theorem is confirmed at a feasible n
#       and the shipped verdict is about the shipped DESIGN, not the theorem;
#   (2) coverage off nominal where the budget is below 1  ->  the remainder
#       explanation is exhausted and the evidence implicates the theorem, the
#       variance estimator or the implementation; report which;
#   (3) no valid DGP with budget below 1 at feasible n  ->  report that, with
#       the binding constraint named.
#
# Outputs (all bare tabular, INV-13; every table prints B)
#   paper/tables/sim/sim_thm_rootn_headroom_design.tex
#   paper/tables/sim/sim_thm_rootn_headroom_budget.tex
#   paper/tables/sim/sim_thm_rootn_headroom_dgpvalid.tex
#   paper/tables/sim/sim_thm_rootn_headroom_spectrum.tex
#   paper/tables/sim/sim_thm_rootn_headroom_limitlaw.tex
#   paper/tables/sim/sim_thm_rootn_headroom_seunits.tex
#   paper/tables/sim/sim_thm_rootn_headroom_quantiles.tex
#   paper/tables/sim/sim_thm_rootn_headroom_verdict.tex
#   paper/figures/sim/sim_thm_rootn_headroom_qq.pdf
#   paper/figures/sim/sim_thm_rootn_headroom_budget.pdf
#   quality_reports/sim/sim_thm_rootn_headroom.rds
# ============================================================================

library(here)                                                   # INV-15
library(data.table)
library(ggplot2)
library(parallel)

source(here::here("scripts", "simulations", "sim_thm_rootn_dgp.R"))
source(here::here("scripts", "simulations", "sim_thm_rootn_nuisance.R"))

# The shipped d_Z = 3 / p = 4 versions, captured BEFORE they are replaced, so
# that hr_assert_dgp_equivalence() can compare against them.
SHIPPED_DGP_DRAW  <- dgp_draw
SHIPPED_SOLVE_ELL <- solve_ell_star
SHIPPED_DRAW_RHAT <- draw_rhat

source(here::here("scripts", "simulations", "sim_thm_rootn_headroom_dgp.R"))

RNGkind("L'Ecuyer-CMRG")
set.seed(20260802L)                                             # INV-14

# ---- Switching the configuration -------------------------------------------
#
# Five bindings in the global environment are REPLACED. Nothing in any shipped
# file is edited; the shipped scripts continue to run at the shipped
# configuration because each of them sources sim_thm_rootn_dgp.R itself and
# never sources this file. The replacements are listed here rather than left to
# be discovered:
#
#   CFG             -> Design H (mu = 5, s = 4, a = 2/5, d_Z = 1, r = 21/8)
#   rate_delta_hat  -> A5(i) AS WRITTEN, the max of its two branches. The
#                      shipped implementation is the propensity branch alone,
#                      which is correct at alpha = 0.32 and wrong over the whole
#                      feasible grid at alpha = 0.42; see the header of
#                      sim_thm_rootn_headroom_dgp.R.
#   dgp_draw        -> d_Z-general, identical at d_Z = 3
#   solve_ell_star  -> d_Z-general, identical at d_Z = 3
#   draw_rhat       -> d_Z-general, identical at d_Z = 3
#
# rate_delta_n, rate_rn and rate_eps_n are NOT replaced: they read CFG and
# rate_delta_hat, so they follow automatically and eq:deltalog's single
# application of ln n inside the power is the shipped one.
hr_assert_dgp_equivalence(SHIPPED_DGP_DRAW, SHIPPED_SOLVE_ELL,
                          SHIPPED_DRAW_RHAT)
message("d_Z-general DGP verified identical to the shipped one at d_Z = 3.")

CFG            <- HR_CFG
rate_delta_hat <- function(n, cfg = CFG) pmax(hr_dhat_T(n), n^(-cfg$alpha))
dgp_draw       <- hr_dgp_draw
solve_ell_star <- hr_solve_ell_star
draw_rhat      <- hr_draw_rhat

stopifnot(
  abs(CFG$kappa * CFG$alpha - 0.381818181818) < 1e-9,
  abs(rate_delta_n(181019L) - (hr_dhat_max(181019L) * log(181019))^CFG$kappa) < 1e-12)

# ---- Constants the lifted estimator reads ----------------------------------

N_CORES  <- SIM_CORES                # fixed constant, host-independent streams
N_GRID   <- c(125L, 354L, 1000L, 2828L, 8000L, 22627L, 64000L, 181019L)
B_ALL    <- 5000L                    # coverage MC SE 0.0031 at 95 per cent
ALPHA_LV <- c(0.10, 0.05)
Q_PROBS  <- c(0.025, 0.05, 0.25, 0.50, 0.75, 0.95, 0.975)
THETA_MIX <- c(1, 1) / sqrt(2)       # p = 2, ||.|| = 1 as in the shipped arm

# c_delta, the free constant of A5(ii)'s O_P statement (design decision D4).
# 1.00 and 0.25 are the shipped arm's own two values, carried so the comparison
# is like for like. 0.35 is added because it is the constant at which the budget
# CROSSES ONE INSIDE THE GRID (1.245 at n = 125 down to 0.778 at n = 181,019,
# crossing between 22,627 and 64,000): a design in which every cell clears is
# less informative than one in which the transition is visible.
C_DELTA_GRID <- c(1.00, 0.35, 0.25)

# The estimator itself, lifted from the shipped arm rather than copied.
EST <- hr_lift_defs(
  here::here("scripts", "simulations", "sim_thm_rootn_limitlaw.R"),
  c("one_rep_full", "run_cell"), parent = globalenv())
one_rep_full <- EST$one_rep_full
run_cell     <- EST$run_cell

# ---- Population objects ----------------------------------------------------

message("Building population objects for Design H ...")
SPECS <- list(HA = hr_dgp_spec("HA"), HB = hr_dgp_spec("HB"))
ES    <- lapply(SPECS, solve_ell_star)
POP   <- Map(function(s, e) pop_J_Sigma(s, e, n_pilot = 4e6L), SPECS, ES)
PERT  <- Map(function(s, e) ell_pert_norms(s, e), SPECS, ES)
VAL   <- Map(function(s, e, p) dgp_validate(s, e, p), SPECS, ES, POP)
SPEC_SPECTRUM <- lapply(SPECS, hr_operator_spectrum)

# ---- Design matrix ---------------------------------------------------------

core <- CJ(dgp = c("HA", "HB"), n = N_GRID, c_delta = C_DELTA_GRID,
           sorted = FALSE)
core[, `:=`(c_eps = 1, c_r = 1, h_mode = "smooth", h_bias = 0, cell = "core")]

# Ablation: nuisances EXACT. The irreducible floor of the linearisation residual
# and of the coverage gap at this configuration, so that whatever the core cells
# show can be read against a cell in which the remainder is zero by
# construction rather than merely small.
abl <- data.table(dgp = "HA", n = c(1000L, 22627L, 181019L), c_delta = 0,
                  c_eps = 0, c_r = 0, h_mode = "smooth", h_bias = 0,
                  cell = "ablation")

DESIGN <- rbind(core, abl, fill = TRUE)
DESIGN <- unique(DESIGN,
                 by = c("dgp", "n", "c_delta", "c_eps", "c_r", "h_mode", "h_bias"))

# EXECUTION ORDER IS A DESIGN DECISION HERE, not housekeeping. One cell at
# n = 181,019 costs about eighty minutes at B = 5,000 on this host, so the run
# is long enough that it may be read before it is finished. The order below is
# therefore by DECLARED PRIORITY, and within a tier by DESCENDING n, so that
# (a) the tier that carries the pre-committed test completes first and (b) its
# headline cell -- the largest n -- is the first cell computed in it. A
# checkpoint read at any moment then holds the most informative completed set
# rather than an arbitrary prefix, and a partial report is a report on whole
# tiers.
#
#   1  HA, c_delta = 0.25   budget < 1 at EVERY cell -- the pre-committed test
#   2  HA, c_delta = 1.00   budget > 1 at every cell -- the contrast, and the
#                           like-for-like counterpart of the shipped arm
#   3  HB, c_delta = 0.25   the stress law at budget < 1
#   4  HA, c_delta = 0.35   the constant at which the budget CROSSES 1 inside
#                           the grid: the transition, visible in one sweep
#   5  ablation             zero-remainder anchor
#   6  HB, c_delta = 1.00
#   7  HB, c_delta = 0.35
DESIGN[, tier := fifelse(cell == "ablation", 5L,
                  fifelse(dgp == "HA" & c_delta == 0.25, 1L,
                  fifelse(dgp == "HA" & c_delta == 1.00, 2L,
                  fifelse(dgp == "HB" & c_delta == 0.25, 3L,
                  fifelse(dgp == "HA" & c_delta == 0.35, 4L,
                  fifelse(dgp == "HB" & c_delta == 1.00, 6L, 7L)))))) ]
setorder(DESIGN, tier, -n)

message(sprintf("Running %d cells at B = %d on %d cores ...", nrow(DESIGN),
                B_ALL, N_CORES))
OUT <- vector("list", nrow(DESIGN))                              # INV-17

# CHECKPOINT GUARD. The shipped arms fingerprint every source file that defines
# a replication and discard the checkpoint when any of them changes. That guard
# is kept and SHARPENED, because this arm needs one thing the shipped arms do
# not: a long run must survive a fix to its own TABLE code. Hashing this file
# would tie hours of computation to the formatting of a caption. So the
# fingerprint covers (a) the four files that define a replication -- this file
# is NOT among them, since its contribution to a replication is entirely
# through the objects below -- and (b) those objects themselves, compared by
# identical(): the configuration, the rate function that switches A5(i), the
# mixing direction, B, the core count and the design matrix. Anything that can
# change a number invalidates the checkpoint; nothing else does.
SRC_FILES <- here::here("scripts", "simulations",
                        c("sim_thm_rootn_headroom_dgp.R",
                          "sim_thm_rootn_limitlaw.R",
                          "sim_thm_rootn_dgp.R",
                          "sim_thm_rootn_nuisance.R"))
REP_FINGERPRINT <- list(
  src_hash  = unname(tools::md5sum(SRC_FILES)),
  design    = copy(DESIGN),   # copy: DESIGN is augmented by reference below
  cfg       = CFG,
  delta_hat = deparse(rate_delta_hat),
  theta_mix = THETA_MIX,
  B         = B_ALL,
  cores     = N_CORES,
  eps_exp   = EPS_EXPONENT,
  specs     = SPECS)
#' Normalise a fingerprint before comparison.
#'
#' A data.table carries an .internal.selfref external pointer that is recreated
#' on every load, so identical() on two data.tables from different sessions is
#' ALWAYS FALSE even when every value agrees. Comparing the design as a plain
#' data.frame removes the pointer and compares what is meant: the cells.
#' (The same defect is present in the shipped arms, whose checkpoint guards read
#' identical(old$design, DESIGN) on data.tables and therefore discard every
#' checkpoint they are given -- verified on this project's own checkpoint file.)
fp_norm <- function(f) { f$design <- as.data.frame(f$design); f }

CKPT <- here::here("quality_reports", "sim", "sim_thm_rootn_headroom_ckpt.rds")
if (file.exists(CKPT)) {
  old <- readRDS(CKPT)
  if (identical(fp_norm(old$fingerprint), fp_norm(REP_FINGERPRINT))) {
    OUT <- old$out
    message(sprintf("  resuming: %d of %d cells already done",
                    sum(!vapply(OUT, is.null, logical(1))), nrow(DESIGN)))
  } else {
    message("  checkpoint discarded: the replication changed since it was written")
  }
}
# WALL-CLOCK BUDGET, and why the arm has one. A full pass is about thirteen
# hours on this host. The loop therefore stops STARTING new cells once the
# budget is spent and goes on to the tables, so that the arm always emits a
# report on the tiers it finished rather than nothing at all. A later
# invocation resumes from the checkpoint and continues where it stopped; an
# invocation at HR_TIME_BUDGET_MIN=0 computes nothing and re-emits the tables
# from the checkpoint alone. Every table records which cells are present.
TIME_BUDGET_MIN <- as.numeric(Sys.getenv("HR_TIME_BUDGET_MIN", "600"))
t_start <- Sys.time()

for (i in seq_len(nrow(DESIGN))) {
  assign(".Random.seed",
         parallel::nextRNGStream(get(".Random.seed", envir = globalenv())),
         envir = globalenv())
  if (!is.null(OUT[[i]])) next
  if (as.numeric(difftime(Sys.time(), t_start, units = "mins")) >
      TIME_BUDGET_MIN) {
    message(sprintf("  wall-clock budget of %.0f min spent; stopping at cell %d of %d",
                    TIME_BUDGET_MIN, i - 1L, nrow(DESIGN)))
    break
  }
  r <- DESIGN[i]
  t0 <- Sys.time()
  parallel::mc.reset.stream()
  OUT[[i]] <- run_cell(r$n, SPECS[[r$dgp]], ES[[r$dgp]], POP[[r$dgp]],
                       PERT[[r$dgp]], r$c_delta, r$c_eps, r$c_r, r$h_mode,
                       B_ALL, r$h_bias)
  OUT[[i]]$cell <- r$cell
  save_ckpt(list(fingerprint = REP_FINGERPRINT, out = OUT), CKPT)
  message(sprintf("  [%2d/%2d] tier %d  %s  n = %6d  c_delta = %.2f  budget = %6.3f  cov95 = %.3f  (%.0fs)",
                  i, nrow(DESIGN), r$tier, r$dgp, r$n, r$c_delta,
                  OUT[[i]]$rem_h2, OUT[[i]]$cover95,
                  as.numeric(difftime(Sys.time(), t0, units = "secs"))))
}

# Completed cells only, from here on. A partial run reports whole tiers.
DONE <- !vapply(OUT, is.null, logical(1))
DESIGN_DONE <- copy(DESIGN)[, done := DONE]
sel <- function(pred) which(DONE & vapply(seq_along(OUT), function(i)
  if (DONE[i]) isTRUE(pred(OUT[[i]])) else FALSE, logical(1)))
tiers_done <- DESIGN_DONE[, .(cells = .N, done = sum(done)),
                          by = .(tier, dgp, c_delta)][order(tier)]
message("\nTier completion:")
print(tiers_done)
if (!all(DONE))
  message(sprintf("PARTIAL RUN: %d of %d cells present. Tables below cover those cells only.",
                  sum(DONE), length(OUT)))

saveRDS(list(design = DESIGN, out = OUT, pop = POP, val = VAL,
             spectrum = SPEC_SPECTRUM, cfg = CFG, shipped_cfg = SHIPPED_CFG,
             B = B_ALL, done = DONE),
        here::here("quality_reports", "sim", "sim_thm_rootn_headroom.rds"))

# ---- Tables ----------------------------------------------------------------
#
# EVERY TABLE PRINTS B. None of the twelve tables of the shipped exercise does,
# and the arms there were separable only by back-solving standard errors.

fmt <- function(x, d = 3) formatC(x, format = "f", digits = d)
big <- function(x) formatC(x, big.mark = ",", format = "d")
tex <- function(lines, file)
  writeLines(lines, here::here("paper", "tables", "sim", file))

# ---- Table 1: the admissibility ledger -------------------------------------
adm <- hr_admissibility(CFG)
adm_ship <- hr_admissibility(SHIPPED_CFG, p = 4L, spline_degree = 4L)
tex(c(
  "\\begin{tabular}{llrrrrc}", "\\toprule",
  " & & \\multicolumn{2}{c}{Design H} & \\multicolumn{2}{c}{Shipped design} & \\\\",
  "\\cmidrule(lr){3-4}\\cmidrule(lr){5-6}",
  "Condition & Source & Threshold & Realised & Threshold & Realised & Both pass \\\\",
  "\\midrule",
  sprintf("%s & %s & %s & %s & %s & %s & %s \\\\",
          adm$condition, adm$source, fmt(adm$threshold, 3), fmt(adm$realised, 3),
          fmt(adm_ship$threshold, 3), fmt(adm_ship$realised, 3),
          ifelse(adm$pass & adm_ship$pass, "yes",
                 ifelse(adm$pass, "H only", "no"))),
  "\\midrule",
  sprintf("\\multicolumn{7}{l}{Design H: $(\\mu,s,a,r,d_Z,p_K)=(5,4,2/5,21/8,1,8)$, $p=2$; $\\kappa\\alpha=%s$, frontier margin $%s$.} \\\\",
          fmt(CFG$kappa * CFG$alpha, 4), fmt(CFG$kappa * CFG$alpha - 0.25, 4)),
  sprintf("\\multicolumn{7}{l}{Shipped: $(\\mu,s,a,r,d_Z,p_K)=(2,3,3/4,8/3,3,8)$, $p=4$; $\\kappa\\alpha=%s$, frontier margin $%s$.} \\\\",
          fmt(SHIPPED_CFG$kappa * SHIPPED_CFG$alpha, 4),
          fmt(SHIPPED_CFG$kappa * SHIPPED_CFG$alpha - 0.25, 4)),
  "\\bottomrule", "\\end{tabular}"),
  "sim_thm_rootn_headroom_design.tex")

# ---- Table 2: the budget, per cell, both readings of A5(i) ------------------
bud <- rbindlist(lapply(C_DELTA_GRID, function(cd)
  as.data.table(hr_budget(N_GRID, CFG, c_delta = cd))))
bud_ship <- as.data.table(hr_budget(N_GRID, SHIPPED_CFG, c_delta = 1))
setorder(bud, -c_delta, n)
bud_block <- function(cd) {
  s <- bud[c_delta == cd]
  c(sprintf("\\multicolumn{9}{l}{\\textit{$c_\\delta=%.2f$}} \\\\", cd),
    "\\midrule",
    sprintf("%s & %s & %s & %s & %s & %s & %s & %s & %s \\\\",
            big(s$n), fmt(s$ln_n, 2), s$dhat_branch, fmt(s$delta_n, 4),
            fmt(s$b_sq, 3), fmt(s$b_sq_rn_only, 3), fmt(s$b_rd, 3),
            fmt(s$ratio_quarter, 2),
            ifelse(s$b_sq < 1, "\\textbf{yes}", "no")),
    "\\addlinespace")
}
tex(c(
  "\\begin{tabular}{rrlrrrrrc}", "\\toprule",
  " & & A5(i) & & \\multicolumn{2}{c}{$\\sqrt n\\,\\delta_n^2$} & & & Budget \\\\",
  "\\cmidrule(lr){5-6}",
  "$n$ & $\\ln n$ & branch & $\\delta_n$ & A5(i) as written & $r_n$ only & $\\sqrt n r_n\\delta_n$ & $\\delta_n/n^{-1/4}$ & $<1$? \\\\",
  "\\midrule",
  unlist(lapply(C_DELTA_GRID, bud_block), use.names = FALSE),
  sprintf("\\multicolumn{9}{l}{\\textit{Shipped design at $c_\\delta=1$, for reference}} \\\\"),
  "\\midrule",
  sprintf("%s & %s & %s & %s & %s & %s & %s & %s & %s \\\\",
          big(bud_ship$n), fmt(bud_ship$ln_n, 2), bud_ship$dhat_branch,
          fmt(bud_ship$delta_n, 4), fmt(bud_ship$b_sq, 3),
          fmt(bud_ship$b_sq_rn_only, 3), fmt(bud_ship$b_rd, 3),
          fmt(bud_ship$ratio_quarter, 2),
          ifelse(bud_ship$b_sq < 1, "yes", "no")),
  "\\bottomrule", "\\end{tabular}"),
  "sim_thm_rootn_headroom_budget.tex")

# ---- Table 3: DGP validation, the shipped seven checks ---------------------
vtab <- rbindlist(lapply(names(VAL), function(nm) {
  v <- VAL[[nm]]
  data.table(dgp = nm, bal = v$balancing_rel_resid,
             psi_t = max(abs(v$mean_psi / v$mean_psi_se)),
             dzdu = max(abs(v$E_dz_du)), kj = v$kappa_J,
             rlo = v$min_varrho, rhi = v$max_varrho,
             u4 = v$E_du4, sdu = v$sd_du, ellsup = v$ell_sup)
}))
tex(c(
  "\\begin{tabular}{lrrrrrrr}", "\\toprule",
  "DGP & A2 rel.\\ resid. & $\\max|t|$, $E\\psi_\\star$ & $\\max|E[\\Delta Z\\Delta U]|$ & $\\kappa(J)$ & $\\varrho$ range & $E[\\Delta U^4]$ & $\\sup|\\ell_\\star|$ \\\\",
  "\\midrule",
  sprintf("%s & %s & %s & %s & %s & [%s, %s] & %s & %s \\\\",
          vtab$dgp, formatC(vtab$bal, format = "e", digits = 1),
          fmt(vtab$psi_t, 2), formatC(vtab$dzdu, format = "e", digits = 1),
          fmt(vtab$kj, 1), fmt(vtab$rlo, 3), fmt(vtab$rhi, 3),
          fmt(vtab$u4, 2), fmt(vtab$ellsup, 2)),
  "\\midrule",
  sprintf("\\multicolumn{8}{l}{Validation draw $4\\times10^5$; pilot for $J,\\Sigma$ $4\\times10^6$. Monte Carlo replications per cell $B=%s$.} \\\\",
          big(B_ALL)),
  "\\bottomrule", "\\end{tabular}"),
  "sim_thm_rootn_headroom_dgpvalid.tex")

# ---- Table 4: the source condition, measured -------------------------------
stab <- rbindlist(lapply(names(SPEC_SPECTRUM), function(nm) {
  s <- SPEC_SPECTRUM[[nm]]
  data.table(dgp = nm, nres = s$n_resolvable, a_pow = s$a_pow,
             r2_pow = s$r2_pow, a_exp = s$a_exp, r2_exp = s$r2_exp,
             cap = s$phi_captured, jen = s$j_energy_1e6,
             R2 = s$R_star[1], R5 = s$R_star[2])
}))
tex(c(
  "\\begin{tabular}{lrrrrrrrr}", "\\toprule",
  " & & \\multicolumn{2}{c}{Power law $\\sigma_j\\propto j^{-a}$} & \\multicolumn{2}{c}{Exponential} & $\\vdagger$ energy & \\multicolumn{2}{c}{$\\mathsf R_\\ast(\\mu)$} \\\\",
  "\\cmidrule(lr){3-4}\\cmidrule(lr){5-6}\\cmidrule(lr){8-9}",
  "DGP & Resolvable & $\\hat a$ & $R^2$ & rate & $R^2$ & index at $1-10^{-6}$ & $\\mu=2$ & $\\mu=5$ \\\\",
  "\\midrule",
  sprintf("%s & %d & %s & %s & %s & %s & %d & %s & %s \\\\",
          stab$dgp, stab$nres, fmt(stab$a_pow, 3), fmt(stab$r2_pow, 3),
          fmt(stab$a_exp, 3), fmt(stab$r2_exp, 3), stab$jen,
          formatC(stab$R2, format = "e", digits = 1),
          formatC(stab$R5, format = "e", digits = 1)),
  "\\midrule",
  "\\multicolumn{9}{l}{Population operator on the residual index, not the sieve compression of (P-a.3); $\\mathsf R_\\ast$ over the resolvable spectrum is a lower bound.} \\\\",
  "\\bottomrule", "\\end{tabular}"),
  "sim_thm_rootn_headroom_spectrum.tex")

# ---- Table 5: the limit law -------------------------------------------------
core_idx <- sel(function(o) o$cell == "core")
if (!length(core_idx)) stop("no core cell completed; nothing to report")
tab <- rbindlist(lapply(OUT[core_idx], function(o) data.table(
  dgp = o$dgp, n = o$n, c_delta = o$c_delta, B = o$B,
  rem = o$rem_h2, sd_ratio = o$sd_ratio, sd_ratio_se = o$sd_ratio_se,
  sd_ratio_z = o$sd_ratio_z,
  cover90 = o$cover90, cover90_se = o$cover90_se, cover90_z = o$cover90_z,
  cover95 = o$cover95, cover95_se = o$cover95_se, cover95_z = o$cover95_z,
  mean_mixed_z = o$mean_mixed_z,
  q_worst_z = max(abs((o$q_emp - o$q_asy) / o$q_se)),
  lin = o$lin_mean, lin_se = o$lin_se, V_gap = o$V_gap)))
# THE WHOLE BATTERY, NOT ITS MOST FAVOURABLE MEMBER. The shipped arm's critic
# found that a verdict pronounced on the smallest available measure is not a
# verdict (finding B4). worst_z is the largest absolute deviation across ALL
# five measures the arm computes -- sd ratio, 90 and 95 per cent coverage, the
# worst studentised quantile and the centring of the limit -- so a cell can
# only pass by passing on every one of them.
tab[, worst_z := pmax(abs(sd_ratio_z), abs(cover90_z), abs(cover95_z),
                      abs(q_worst_z), abs(mean_mixed_z))]
setorder(tab, dgp, -c_delta, n)

tab[, panel := paste(dgp, c_delta)]
pkeys <- unique(tab$panel)
panel_block <- function(k) {
  s <- tab[panel == k]
  c(sprintf("\\multicolumn{7}{l}{\\textit{Panel %s: DGP-%s, $c_\\delta=%.2f$, $B=%s$}} \\\\",
            LETTERS[match(k, pkeys)], s$dgp[1], s$c_delta[1], big(s$B[1])),
    "\\midrule",
    sprintf("%s & %s & %s (%s) & %s (%s) & %s (%s) & %s & %s \\\\",
            big(s$n),
            ifelse(s$rem < 1, sprintf("\\textbf{%s}", fmt(s$rem, 3)),
                   fmt(s$rem, 3)),
            fmt(s$sd_ratio, 3), fmt(s$sd_ratio_se, 3),
            fmt(s$cover90, 3), fmt(s$cover90_se, 3),
            fmt(s$cover95, 3), fmt(s$cover95_se, 3),
            fmt(s$q_worst_z, 2), fmt(s$lin, 3)),
    "\\addlinespace")
}
body <- unlist(lapply(pkeys, panel_block), use.names = FALSE)
tex(c(
  "\\begin{tabular}{rrcccrr}", "\\toprule",
  " & $\\sqrt n\\delta_n^2$ & & \\multicolumn{2}{c}{Coverage (MC SE)} & Worst quantile & Lin.\\ resid. \\\\",
  "\\cmidrule(lr){4-5}",
  "$n$ & budget & $\\hat{\\mathrm{sd}}/\\mathrm{sd}_\\infty$ (MC SE) & 90\\% & 95\\% & (MC SE units) & mean \\\\",
  "\\midrule", body[-length(body)],
  "\\bottomrule", "\\end{tabular}"),
  "sim_thm_rootn_headroom_limitlaw.tex")

# ---- Table 6: everything in MC SE units ------------------------------------
tex(c(
  "\\begin{tabular}{lrrrrrrrr}", "\\toprule",
  " & & & & \\multicolumn{5}{c}{Deviation from the asymptotic value, in MC SE units} \\\\",
  "\\cmidrule(lr){5-9}",
  "DGP & $c_\\delta$ & $n$ & Budget & $\\hat{\\mathrm{sd}}/\\mathrm{sd}_\\infty$ & 90\\% cov. & 95\\% cov. & Worst quantile & Centring \\\\",
  "\\midrule",
  sprintf("%s & %s & %s & %s & %s & %s & %s & %s & %s \\\\",
          tab$dgp, fmt(tab$c_delta, 2), big(tab$n), fmt(tab$rem, 3),
          fmt(tab$sd_ratio_z, 2), fmt(tab$cover90_z, 2), fmt(tab$cover95_z, 2),
          fmt(tab$q_worst_z, 2), fmt(tab$mean_mixed_z, 2)),
  "\\midrule",
  sprintf("\\multicolumn{9}{l}{$B=%s$ at every cell. Positive means the empirical quantity exceeds its asymptotic target.} \\\\",
          big(B_ALL)),
  "\\bottomrule", "\\end{tabular}"),
  "sim_thm_rootn_headroom_seunits.tex")

# ---- Table 7: the mandatory quantile comparison ----------------------------
qsel <- sel(function(o) o$cell == "core" && o$c_delta %in% c(0.25, 1.00) &&
              o$n %in% c(22627L, 181019L))
qblock <- function(j) {
  o <- OUT[[j]]
  z <- (o$q_emp - o$q_asy) / o$q_se
  c(sprintf("%s & %s & %s & %.3f & %s (%s) & %s & %s \\\\",
            c(o$dgp, rep("", length(Q_PROBS) - 1L)),
            c(fmt(o$c_delta, 2), rep("", length(Q_PROBS) - 1L)),
            c(big(o$n), rep("", length(Q_PROBS) - 1L)),
            Q_PROBS, fmt(o$q_emp, 3), fmt(o$q_se, 3), fmt(o$q_asy, 3),
            fmt(z, 2)),
    "\\addlinespace")
}
qbody <- unlist(lapply(qsel, qblock), use.names = FALSE)
tex(c(
  "\\begin{tabular}{lrrrrrr}", "\\toprule",
  "DGP & $c_\\delta$ & $n$ & Quantile & Empirical (MC SE) & Asymptotic & Diff.\\ (MC SE units) \\\\",
  "\\midrule", qbody[-length(qbody)], "\\midrule",
  sprintf("\\multicolumn{7}{l}{$B=%s$. Studentised statistic in the mixed direction; asymptotic law $N(0,1)$.} \\\\",
          big(B_ALL)),
  "\\bottomrule", "\\end{tabular}"),
  "sim_thm_rootn_headroom_quantiles.tex")

# ---- Table 8: the decision rule, applied ------------------------------------
#
# The rule was fixed before the run. This table applies it mechanically: every
# cell whose realised budget is below 1, its 95 per cent coverage, the gap in MC
# SE units, and the pre-committed two-SE verdict. The ablation rows are the
# zero-remainder anchor.
abl_idx <- sel(function(o) o$cell == "ablation")
atab <- data.table(dgp = character(0), n = integer(0), cover95 = numeric(0),
                   cover95_se = numeric(0), cover95_z = numeric(0),
                   sd_ratio_z = numeric(0))
if (length(abl_idx)) {
  atab <- rbindlist(lapply(OUT[abl_idx], function(o) data.table(
    dgp = o$dgp, n = o$n, c_delta = 0, B = o$B, rem = 0,
    cover95 = o$cover95, cover95_se = o$cover95_se, cover95_z = o$cover95_z,
    sd_ratio = o$sd_ratio, sd_ratio_z = o$sd_ratio_z, lin = o$lin_mean)))
}
und <- tab[rem < 1, .(dgp, n, c_delta, B, rem, cover95, cover95_se, cover95_z,
                      sd_ratio, sd_ratio_z, lin, worst_z)]
setorder(und, dgp, -c_delta, n)
verdict <- function(z) ifelse(abs(z) <= 2, "within 2 SE", "outside 2 SE")
# Panel bodies are built BEFORE the c() so that the empty-panel branch is an
# ordinary if/else statement. An `if (...) x` / newline / `else y` inside a call
# is a parse error in R, and a long arm must not fall over on its own report.
panelA <- if (nrow(und)) {
  sprintf("%s & %s & %s & %s & %s (%s) & %s & %s & %s & %s \\\\",
          und$dgp, fmt(und$c_delta, 2), big(und$n), fmt(und$rem, 3),
          fmt(und$cover95, 3), fmt(und$cover95_se, 3), fmt(und$cover95_z, 2),
          verdict(und$cover95_z), fmt(und$worst_z, 2), verdict(und$worst_z))
} else {
  "\\multicolumn{9}{l}{none} \\\\"
}
panelB <- if (nrow(atab)) {
  sprintf("%s & --- & %s & 0.000 & %s (%s) & %s & %s & --- & --- \\\\",
          atab$dgp, big(atab$n), fmt(atab$cover95, 3), fmt(atab$cover95_se, 3),
          fmt(atab$cover95_z, 2), verdict(atab$cover95_z))
} else {
  "\\multicolumn{9}{l}{not run in this pass} \\\\"
}
tex(c(
  "\\begin{tabular}{lrrrcrrcc}", "\\toprule",
  " & & & & \\multicolumn{3}{c}{Pre-committed criterion: 95\\% coverage} & Whole battery & \\\\",
  "\\cmidrule(lr){5-7}",
  "DGP & $c_\\delta$ & $n$ & Budget & Coverage (MC SE) & Gap (SE) & Verdict & Worst $|z|$ & Verdict \\\\",
  "\\midrule",
  "\\multicolumn{9}{l}{\\textit{Panel A: every core cell with realised budget below one}} \\\\",
  "\\midrule", panelA, "\\addlinespace",
  "\\multicolumn{9}{l}{\\textit{Panel B: zero-remainder anchor (nuisances exact)}} \\\\",
  "\\midrule", panelB,
  "\\midrule",
  sprintf("\\multicolumn{9}{l}{$B=%s$ at every cell; coverage MC SE $\\approx0.003$ at nominal 95\\%%. Bar fixed before the run. Worst $|z|$ is the largest of five measures. Cells: %d of %d.} \\\\",
          big(B_ALL), sum(DONE), length(OUT)),
  "\\bottomrule", "\\end{tabular}"),
  "sim_thm_rootn_headroom_verdict.tex")

# ---- Figures (no in-figure titles, serif, PDF; INV-12) ---------------------

thm_sim <- theme_minimal(base_family = "serif", base_size = 10) +
  theme(panel.grid.minor = element_blank(),
        strip.text = element_text(face = "bold"))

qq_cells <- sel(function(o) o$cell == "core" && o$c_delta %in% c(0.25, 1.00) &&
                  o$n %in% c(1000L, 181019L))
if (length(qq_cells)) {
qq_dt <- rbindlist(lapply(OUT[qq_cells], function(o) {
  pr <- stats::ppoints(min(length(o$t_mix), 4000L))
  data.table(dgp = paste0("DGP-", o$dgp),
             n = factor(big(o$n), levels = c("1,000", "181,019")),
             c_delta = paste0("c[delta] == ", o$c_delta),
             theo = stats::qnorm(pr),
             emp = stats::quantile(o$t_mix, pr, names = FALSE))
}))
p_qq <- ggplot(qq_dt, aes(theo, emp, colour = n, shape = n, linetype = n)) +
  geom_abline(slope = 1, intercept = 0, colour = "grey45", linewidth = 0.35) +
  geom_line(linewidth = 0.5) +
  facet_grid(dgp ~ c_delta,
             labeller = labeller(dgp = label_value, c_delta = label_parsed)) +
  scale_colour_brewer(palette = "Set2") +
  labs(x = "Standard normal quantile",
       y = "Empirical quantile of the studentised statistic",
       colour = "Sample size", shape = "Sample size",
       linetype = "Sample size") +
  coord_cartesian(xlim = c(-3.2, 3.2), ylim = c(-4.2, 4.2)) +
  thm_sim + theme(legend.position = "bottom")
ggsave(here::here("paper", "figures", "sim", "sim_thm_rootn_headroom_qq.pdf"),
       p_qq, width = 6.5, height = 5.2, device = cairo_pdf)
}

bud_fig <- rbindlist(lapply(C_DELTA_GRID, function(cd) {
  d <- as.data.table(hr_budget(N_GRID, CFG, c_delta = cd))
  d[, .(n, c_delta = factor(cd), design = "Design H", b = b_sq)]
}))
bud_fig <- rbind(bud_fig, rbindlist(lapply(C_DELTA_GRID, function(cd) {
  d <- as.data.table(hr_budget(N_GRID, SHIPPED_CFG, c_delta = cd))
  d[, .(n, c_delta = factor(cd), design = "Shipped design", b = b_sq)]
})))
p_bud <- ggplot(bud_fig, aes(n, b, colour = c_delta, shape = c_delta,
                             linetype = c_delta)) +
  geom_hline(yintercept = 1, colour = "grey35", linewidth = 0.35) +
  geom_line(linewidth = 0.55) + geom_point(size = 1.6) +
  facet_wrap(~design) + scale_x_log10() + scale_y_log10() +
  scale_colour_brewer(palette = "Set2") +
  labs(x = "Sample size (log scale)",
       y = expression(paste(sqrt(n), " ", delta[n]^2, "  (log scale)")),
       colour = expression(c[delta]), shape = expression(c[delta]),
       linetype = expression(c[delta])) +
  thm_sim + theme(legend.position = "bottom")
ggsave(here::here("paper", "figures", "sim",
                  "sim_thm_rootn_headroom_budget.pdf"),
       p_bud, width = 6.5, height = 3.2, device = cairo_pdf)

# ---- Console verdict --------------------------------------------------------
message("\n==== DECISION RULE, APPLIED ====")
if (!nrow(und)) {
  message("No core cell reached a budget below one: branch (3).")
} else {
  worst <- und[which.max(abs(cover95_z))]
  wb <- und[which.max(worst_z)]
  message(sprintf("Cells with budget < 1: %d.  Worst 95%% coverage gap: %.3f (%.2f MC SE) at %s, n = %s, c_delta = %.2f.",
                  nrow(und), worst$cover95, worst$cover95_z, worst$dgp,
                  big(worst$n), worst$c_delta))
  message(sprintf("Worst deviation across the whole battery: %.2f MC SE at %s, n = %s, c_delta = %.2f.",
                  wb$worst_z, wb$dgp, big(wb$n), wb$c_delta))
  message(if (max(abs(und$cover95_z)) <= 2)
    "Pre-committed criterion (coverage): branch (1) -- the limit law binds at a feasible n."
    else "Pre-committed criterion (coverage): branch (2) -- report, do not explain away.")
  message(if (max(und$worst_z) <= 2)
    "Whole battery: also within two MC SE at every below-budget cell."
    else "Whole battery: at least one measure outside two MC SE -- see the SE-units table.")
}
message("done: headroom arm")
