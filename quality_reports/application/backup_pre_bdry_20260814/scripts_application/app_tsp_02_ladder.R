# ============================================================================
# app_tsp_02_ladder.R
#
# Section 6, stage 2: the d_Z sensitivity ladder, which is the reported object
# (decision record section6-instrument-and-dz.md, item 2).
#
# The estimator is the cross-fitted orthogonal one-step of
# scripts/R/orthogonal_theta.R, applied unchanged.  Four rungs, ONE sample
# (n = 983) so that movement along the ladder is attributable to d_Z alone.
#
# Also produced here, because both need a fitted structural residual:
#   * the within-stratum residual-independence probe, which is the sharpest
#     differential-misclassification diagnostic this data admits;
#   * phi-hat at the headline rung, by the plug-in second stage (prp:plugin).
#
# Outputs
#   paper/tables/app_tsp_ladder.tex
#   paper/tables/app_tsp_estimator_diag.tex
#   paper/tables/app_tsp_misclass.tex
#   quality_reports/application/app_tsp_ladder.rds
# ============================================================================

library(here)
library(parallel)

source(here::here("scripts", "R", "lf_panel.R"))
source(here::here("scripts", "R", "orthogonal_theta.R"))
source(here::here("scripts", "application", "app_tsp_common.R"))

RNGkind("L'Ecuyer-CMRG")
set.seed(SEED_LADDER)                                                # INV-14

## Output root.  Defaults to the repository tree; the override exists so a
## regeneration can be written to a scratch tree and DIFFED against the shipped
## artifacts before it replaces them, which is this project's standing rule for
## cached output (app_tsp_08_localise.R carries the same block).  INPUTS are
## always read from the repository tree, so a scratch run reads the shipped
## upstream stages and cannot silently consume its own partial output.
OUT_ROOT <- Sys.getenv("APP_TSP_OUT_ROOT", unset = here::here())
TAB <- file.path(OUT_ROOT, "paper", "tables")
OUT <- file.path(OUT_ROOT, "quality_reports", "application")
IN  <- here::here("quality_reports", "application")
dir.create(TAB, showWarnings = FALSE, recursive = TRUE)
dir.create(OUT, showWarnings = FALSE, recursive = TRUE)

pan <- load_tsp_panel()
dt  <- pan$dt
n   <- nrow(dt)
xc  <- make_x_coord(dt$x1_raw, dt$x2_raw, mode = "rank")
xev <- seq(stats::quantile(c(xc$x1, xc$x2), XEVAL_LO),
           stats::quantile(c(xc$x1, xc$x2), XEVAL_HI), length.out = N_XEVAL)

HEADLINE_DZ <- 5L

# One deterministic L'Ecuyer anchor per rung, plus one for the permutation
# probe.  Every random object below therefore depends only on SEED_LADDER and
# on its own position, not on how much RNG the preceding blocks consumed --
# which is what makes the checkpoint below safe to reuse.
ANCHOR <- make_streams(length(LADDER_DZ) + 1L)

# ---- The ladder -------------------------------------------------------------
#
# CHECKPOINT.  The fits cost roughly a quarter of an hour and the tables below
# are edited far more often than the estimator is.  The cache is keyed on
# everything that determines a fit -- the estimator sources, the raw data, the
# tuning constants, and the deparsed bodies of the two driver functions -- and
# on nothing that determines only a table.  Editing a table therefore reuses
# the fits; editing fit_orthogonal(), lf_solve() or a tuning constant does not.

CKPT <- file.path(OUT, "app_tsp_ladder_ckpt.rds")
CFG <- list(
  seed = SEED_LADDER, rungs = LADDER_DZ, K = N_FOLDS, n_part = N_PART,
  cste = LF_CSTE, imax = lf_mbar(dt$w), patience = lf_patience_for(dt$w),
  rho = RHO,
  coord = xc$mode, xeval = xev, n = n,
  src = unname(tools::md5sum(here::here(
    "scripts", "R", c("lf_panel.R", "orthogonal_theta.R")))),
  data = unname(tools::md5sum(here::here("data", "raw", "data_tsp.txt"))),
  driver = c(paste(deparse(fit_orthogonal), collapse = "\n"),
             paste(deparse(fit_one_partition), collapse = "\n"),
             paste(deparse(make_design), collapse = "\n"),
             paste(deparse(init_for_rung), collapse = "\n"))
)

fits <- NULL
if (file.exists(CKPT)) {
  old <- readRDS(CKPT)
  if (identical(old$cfg, CFG)) {
    fits <- old$fits
    message("ladder: reusing cached fits (configuration unchanged)")
  } else {
    message("ladder: cache discarded, configuration changed")
  }
}

if (is.null(fits)) {
  fits <- vector("list", length(LADDER_DZ))                          # INV-17
  names(fits) <- as.character(LADDER_DZ)
  for (j in seq_along(LADDER_DZ)) {
    dz <- LADDER_DZ[j]
    ic <- init_for_rung(dz)
    Z  <- make_design(dt, dz)
    assign(".Random.seed", ANCHOR[[j]], envir = globalenv())
    t0 <- Sys.time()
    fits[[j]] <- fit_orthogonal(dt$dy, xc$x1, xc$x2, Z, dt$w, dt$cluster,
                                K = N_FOLDS, n_part = N_PART, cste = LF_CSTE,
                                init_fn = ic$fn, lf_imax = lf_mbar(dt$w),
                                lf_patience = lf_patience_for(dt$w), rho = RHO,
                                xeval = xev, n_cores = N_CORES)
    fits[[j]]$d_z <- dz
    fits[[j]]$init_name <- ic$name
    fits[[j]]$init_substituted <- ic$substituted
    # sigma_min(J) against sigma_min(E_n[dZ dZ']) is the diagnostic kappa(J)
    # cannot supply: at p = 1 the condition number is 1 by construction, so a
    # Jacobian driven towards zero by the debiasing term is invisible in it.
    ZZ <- crossprod(Z) / n
    fits[[j]]$sv_min <- vapply(fits[[j]]$fits,
                               \(z) min(svd(z$J)$d), numeric(1))
    fits[[j]]$sv_min_zz <- min(svd(ZZ)$d)
    message(sprintf(
      paste("rung d_Z = %2d  (%s)  %5.0fs  theta[1] = %8.4f",
            " LF: median argmin %4.0f, %d/%d at 1, %d/%d capped"),
      dz, ic$name, as.numeric(difftime(Sys.time(), t0, units = "secs")),
      fits[[j]]$theta[1], fits[[j]]$lf_m_median,
      fits[[j]]$lf_at_one, nrow(fits[[j]]$lf),
      fits[[j]]$lf_hit_cap, nrow(fits[[j]]$lf)))
  }
  saveRDS(list(cfg = CFG, fits = fits), CKPT)
}

# ---- Ladder table -----------------------------------------------------------
#
# Rows are coefficients, columns are rungs.  A coefficient absent from a rung
# prints "--"; it is not zero and it is not omitted for space.

show_coefs <- names(COEF_LABELS)
cell <- function(f, nm, what) {
  i <- match(nm, f$coef_names)
  if (is.na(i)) return("--")
  switch(what,
         est = paste0(fmt(f$theta[i], 4), stars(f$theta[i], f$se_cl[i])),
         se_iid = sprintf("(%s)", fmt(f$se_iid[i], 4)),
         se_cl  = sprintf("[%s]", fmt(f$se_cl[i], 4)))
}
lad_body <- vector("list", length(show_coefs))                       # INV-17
for (j in seq_along(show_coefs)) {
  nm <- show_coefs[j]
  lad_body[[j]] <- c(
    sprintf("%s & %s \\\\", COEF_LABELS[[nm]],
            paste(vapply(fits, cell, character(1), nm, "est"), collapse = " & ")),
    sprintf(" & %s \\\\",
            paste(vapply(fits, cell, character(1), nm, "se_iid"), collapse = " & ")),
    sprintf(" & %s \\\\",
            paste(vapply(fits, cell, character(1), nm, "se_cl"), collapse = " & ")))
}
write_tabular(
  "lrrrr",
  c("& (1) & (2) & (3) & (4) \\\\",
    sprintf("& %s \\\\", paste(sprintf("$d_Z = %d$", LADDER_DZ),
                               collapse = " & "))),
  c(unlist(lad_body, use.names = FALSE), "\\midrule",
    sprintf("Controls in $\\Delta Z$ & %s \\\\",
            paste(c("none", "core", "core $+$ demographic",
                    "all usable"), collapse = " & ")),
    sprintf("Coefficients estimated ($p$) & %s \\\\",
            paste(vapply(fits, \(f) as.character(f$p), character(1)),
                  collapse = " & ")),
    sprintf("Observations & %s \\\\",
            paste(rep(formatC(n, format = "d", big.mark = ","),
                      length(fits)), collapse = " & "))),
  file.path(TAB, "app_tsp_ladder.tex"))

# ---- Estimator diagnostics table --------------------------------------------
#
# This is the table that says whether the numbers above should be believed.
# Nothing in it is tuned; every entry is what the run produced.

feas <- readRDS(file.path(IN, "app_tsp_diagnostics.rds"))$feasibility

#' Partition-stability diagnostics.
#'
#' orthogonal_theta()'s variance adds the raw across-partition variance of the
#' B partition estimates to the median sandwich.  That term is not robust to a
#' partition in which the phi step fails outright, and at d_Z = 0 it is what
#' the reported standard error consists of.  Three measures expose it:
#'   * the ratio of the partition SD to a robust scale (1.4826 x MAD), which is
#'     near 1 when the partitions are a clean sample and large when a few are
#'     not;
#'   * the count of partitions more than ten robust scales from the median in
#'     any coordinate;
#'   * sd(Delta phi-hat) / sd(Delta Y) and sd(u-hat) / sd(Delta Y), which say
#'     directly whether the fitted structural difference and the fitted
#'     residual are on the scale of the outcome they decompose.  A ratio well
#'     above one means the estimator is explaining an outcome with components
#'     several times larger than the outcome -- the signature of an
#'     under-regularised phi step, and the quantity the cap counts predict.
partition_stability <- function(f, dy) {
  th <- f$theta_partitions
  sdv <- apply(th, 2, stats::sd)
  mad <- apply(th, 2, stats::mad)
  med <- apply(th, 2, stats::median)
  ratio <- ifelse(mad > 0, sdv / mad, NA_real_)
  far <- vapply(seq_len(nrow(th)), \(b)
    any(abs(th[b, ] - med) > 10 * pmax(mad, .Machine$double.eps)), logical(1))
  sdy <- stats::sd(dy)
  dphi_rel <- vapply(f$fits, \(z) stats::sd(z$dphi), numeric(1)) / sdy
  u_rel <- vapply(f$fits, \(z) stats::sd(z$u), numeric(1)) / sdy
  list(sd_over_mad = stats::median(ratio, na.rm = TRUE),
       n_far = sum(far),
       dphi_rel_med = stats::median(dphi_rel), dphi_rel_max = max(dphi_rel),
       u_rel_med = stats::median(u_rel))
}

diag_rows <- vector("list", length(fits))                            # INV-17
for (j in seq_along(fits)) {
  f <- fits[[j]]
  k <- which(feas$d_z == f$d_z)
  ps <- partition_stability(f, dt$dy)
  diag_rows[[j]] <- data.frame(
    sd_over_mad = ps$sd_over_mad, n_far = ps$n_far,
    dphi_rel_med = ps$dphi_rel_med, dphi_rel_max = ps$dphi_rel_max,
    u_rel_med = ps$u_rel_med,
    d_z = f$d_z, init = f$init_name, n_solve = nrow(f$lf),
    # `lf$m` is eq:lfsched(c)'s m-hat, the iterate actually returned; `argmin`
    # is the discrepancy argmin, which is no longer the same number.  The table
    # row is labelled "stopping index", so it reads m.
    lf_med = stats::median(f$lf$m),
    lf_min = min(f$lf$m), lf_max = max(f$lf$m),
    lf_at_one = f$lf_at_one, lf_cap = f$lf_hit_cap,
    lf_argmin_at_one = f$lf_argmin_at_one,
    lf_rule_cap = as.integer(f$lf_stop_rule[["cap"]]),
    lf_rule_dp = as.integer(f$lf_stop_rule[["dp"]]),
    lf_rule_pat = as.integer(f$lf_stop_rule[["patience"]]),
    disc = mean(f$disc), kappa_med = stats::median(f$kappa_J),
    kappa_max = max(f$kappa_J),
    sv_ratio = stats::median(f$sv_min) / f$sv_min_zz,
    se_samp = stats::median(f$se_sampling_cl / f$se_cl),
    se_cf = stats::median(f$se_crossfit / f$se_cl),
    delta_n = feas$delta_n[k], budget = feas$budget[k],
    stringsAsFactors = FALSE)
}
dg <- do.call(rbind, diag_rows)

write_tabular(
  "lrrrr",
  sprintf("& %s \\\\", paste(sprintf("$d_Z = %d$", LADDER_DZ), collapse = " & ")),
  c(paste0("\\multicolumn{5}{l}{\\textit{Panel A: Landweber--Fridman step, ",
           "over $K\\times B$ fold solves}} \\\\"),
    "\\midrule",
    sprintf("Fold solves & %s \\\\", paste(dg$n_solve, collapse = " & ")),
    sprintf("Median stopping index $\\hat m$ & %s \\\\",
            paste(fmt(dg$lf_med, 0), collapse = " & ")),
    sprintf("Range of $\\hat m$ & %s \\\\",
            paste(sprintf("[%d, %d]", dg$lf_min, dg$lf_max), collapse = " & ")),
    sprintf("Solves stopping at $\\hat m = 1$ & %s \\\\",
            paste(dg$lf_at_one, collapse = " & ")),
    sprintf("Solves on a discrepancy path that rises throughout & %s \\\\",
            paste(dg$lf_argmin_at_one, collapse = " & ")),
    sprintf("Solves reaching the cap $\\bar m = %d$ & %s \\\\", lf_mbar(dt$w),
            paste(dg$lf_cap, collapse = " & ")),
    "\\addlinespace",
    "\\multicolumn{5}{l}{\\textit{Panel B: moment and Jacobian}} \\\\",
    "\\midrule",
    sprintf("Relative balancing residual & %s \\\\",
            paste(formatC(dg$disc, format = "e", digits = 1), collapse = " & ")),
    sprintf("Median $\\kappa(\\hat J)$ & %s \\\\",
            paste(fmt(dg$kappa_med, 0), collapse = " & ")),
    sprintf("Max $\\kappa(\\hat J)$ & %s \\\\",
            paste(fmt(dg$kappa_max, 0), collapse = " & ")),
    sprintf("$\\sigma_{\\min}(\\hat J)\\,/\\,\\sigma_{\\min}(E_n[\\Delta Z\\Delta Z'])$ & %s \\\\",
            paste(fmt(dg$sv_ratio, 3), collapse = " & ")),
    "\\addlinespace",
    paste0("\\multicolumn{5}{l}{\\textit{Panel C: scale of the fitted ",
           "components, and stability across the $B$ partitions}} \\\\"),
    "\\midrule",
    sprintf(paste("Median $\\mathrm{sd}(\\Delta\\hat\\varphi)",
                  "/\\,\\mathrm{sd}(\\Delta Y)$ & %s \\\\"),
            paste(fmt(dg$dphi_rel_med, 2), collapse = " & ")),
    sprintf(paste("Median $\\mathrm{sd}(\\Delta\\hat U)",
                  "/\\,\\mathrm{sd}(\\Delta Y)$ & %s \\\\"),
            paste(fmt(dg$u_rel_med, 2), collapse = " & ")),
    sprintf(paste("Max $\\mathrm{sd}(\\Delta\\hat\\varphi)",
                  "/\\,\\mathrm{sd}(\\Delta Y)$ & %s \\\\"),
            paste(fmt(dg$dphi_rel_max, 1), collapse = " & ")),
    sprintf("$\\mathrm{sd}$ / $1.4826\\times$MAD of $\\hat\\theta_b$ & %s \\\\",
            paste(fmt(dg$sd_over_mad, 2), collapse = " & ")),
    sprintf("Partitions $>10$ robust scales from the median & %s \\\\",
            paste(dg$n_far, collapse = " & ")),
    "\\addlinespace",
    paste0("\\multicolumn{5}{l}{\\textit{Panel D: variance decomposition and ",
           "rate budget}} \\\\"),
    "\\midrule",
    sprintf("Sampling share of SE (median) & %s \\\\",
            paste(fmt(dg$se_samp, 3), collapse = " & ")),
    sprintf("Cross-fitting share of SE (median) & %s \\\\",
            paste(fmt(dg$se_cf, 3), collapse = " & ")),
    sprintf("$\\delta_n$ at $(\\mu,r)=(2,8/3)$ & %s \\\\",
            paste(fmt(dg$delta_n, 3), collapse = " & ")),
    sprintf("$\\sqrt n\\,\\delta_n^2$ & %s \\\\",
            paste(fmt(dg$budget, 1), collapse = " & "))),
  file.path(TAB, "app_tsp_estimator_diag.tex"))

# ---- Within-stratum residual independence -----------------------------------
#
# A1 is Delta U _||_ W | Delta Z.  The estimator drives the CONDITIONAL
# W-contrast of the residual CDF towards zero -- W is centred at varrho-hat
# (Delta Z) and the contrast is taken against the Bierens family
# w(t' Phi(Delta Z)), so the restriction it imposes is already a conditional
# one.  (Before 2026-08-07 the engine centred at mean(W) and this comment was
# right about what the code did and wrong about what the theory asks; the
# rejection this probe reported was an artefact of that gap.)  It still does
# not touch the contrast within an observable stratum, which is what the probe
# below cuts on and why the probe is not vacuous.  Under non-differential misclassification the imputed W
# remains independent of Delta U, so the within-stratum contrast should also be
# null.  Under DIFFERENTIAL misclassification the classification error is
# related to Delta U, and the contrast reappears once the sample is cut on the
# observables the error plausibly tracks.
#
# WHAT THIS TEST CANNOT SETTLE, stated here rather than in the summary alone:
# the reference distribution holds u-hat FIXED while permuting W, and u-hat was
# constructed using the realised W.  The observed statistic is therefore
# favoured relative to its own null, so a rejection is conservative evidence
# and a non-rejection is weak evidence.

hd <- fits[[match(HEADLINE_DZ, LADDER_DZ)]]
dphi_bar <- rowMeans(vapply(hd$fits, \(z) z$dphi, numeric(n)))
Zh <- make_design(dt, HEADLINE_DZ)
uhat <- as.vector(dt$dy - dphi_bar - Zh %*% hd$theta)

# Kernel matrix of the smoothed CDF, computed once; permutation then only
# re-labels columns (INV-17: no recomputation inside the loop).
hu <- 1.059 * stats::sd(uhat) * n^(-1 / 16)
Kcdf <- K_order(outer(uhat, uhat, "-") / hu, 8L)

## TWO NULLS, AND THE PROBE NOW TESTS BOTH.  Until 2026-08-08 this probe formed
## the UNCONDITIONAL contrast F_1 - F_0 within each stratum and drew its
## reference distribution by permuting W within stratum.  That is a test of
## Delta U _||_ W within stratum -- the PREDECESSOR's restriction -- and it is
## false under A1 whenever varrho(Delta Z) and the conditional law of Delta U
## both vary inside a stratum, which for a four-cell cut of a 6-dimensional
## Delta Z they certainly do.  So a rejection was never evidence against A1, and
## the header above claimed it was.
##
## Both hypotheses are now tested side by side, because they say different
## things and the paper needs both:
##
##   PREDECESSOR (cvm_stat, permutation null).  Contrast F_1 - F_0; W permuted
##   within stratum.  Rejecting says Delta U _||_ W fails on this data, which is
##   the PREMISE of the paper -- it is why the conditional form is needed at
##   all.  A rejection here is a result FOR the paper, not against it.
##
##   A1 (cvm_cond, parametric-bootstrap null).  Contrast built from
##   Wtilde = W - varrho-hat(Delta Z); the null draw is W* ~ Bern(varrho-hat),
##   independent of everything else, which IS the conditional law A1 asserts.
##   Under A1 this reference distribution is the right one and a rejection is
##   evidence against A1.
##
## The caveat below applies to both and is unchanged: u-hat is held fixed and
## was built using the realised W.

#' Weighted Cramer-von Mises statistic for the W-contrast within strata.
cvm_stat <- function(wv, strat) {
  lv <- unique(strat)
  tot <- 0
  for (s in lv) {
    idx <- which(strat == s)
    i1 <- idx[wv[idx] == 1L]
    i0 <- idx[wv[idx] == 0L]
    if (length(i1) < 5L || length(i0) < 5L) next
    d <- rowMeans(Kcdf[idx, i1, drop = FALSE]) -
         rowMeans(Kcdf[idx, i0, drop = FALSE])
    tot <- tot + (length(idx) / length(strat)) * mean(d^2)
  }
  tot
}

#' The same statistic against A1's CONDITIONAL contrast.
#'
#' Within a stratum, (1/|s|) sum_j Wtilde_j K_ij, rescaled by wbar_s(1 - wbar_s)
#' so the two statistics are on one scale: the identity
#'   1{W=1}/wbar - 1{W=0}/(1-wbar) = (W - wbar)/(wbar(1-wbar))
#' makes F_1 - F_0 exactly the wbar-centred version of this object.
cvm_cond <- function(wv, strat, rho) {
  wtil <- wv - rho
  lv <- unique(strat)
  tot <- 0
  for (s in lv) {
    idx <- which(strat == s)
    if (length(idx) < 10L) next
    wb <- mean(wv[idx])
    if (!is.finite(wb) || wb <= 0 || wb >= 1) next
    d <- as.vector(Kcdf[idx, idx, drop = FALSE] %*% wtil[idx]) /
      (length(idx) * wb * (1 - wb))
    tot <- tot + (length(idx) / length(strat)) * mean(d^2)
  }
  tot
}

fips_region <- function(s) {
  ne <- c(9, 23, 25, 33, 44, 50, 34, 36, 42)
  mw <- c(17, 18, 26, 39, 55, 19, 20, 27, 29, 31, 38, 46)
  so <- c(10, 11, 12, 13, 24, 37, 45, 51, 54, 1, 21, 28, 47, 5, 22, 40, 48)
  ifelse(s %in% ne, "Northeast",
         ifelse(s %in% mw, "Midwest", ifelse(s %in% so, "South", "West")))
}
qcut <- function(x, k = 4L) {
  cut(x, stats::quantile(x, seq(0, 1, length.out = k + 1L)),
      include.lowest = TRUE, labels = FALSE)
}
strata_list <- list(
  `Unconditional` = rep(1L, n),
  `Baseline TSP quartile` = qcut(dt$x1_raw),
  `Census region` = fips_region(dt$StateCode),
  `Manufacturing quartile` = qcut(dt$EmpManufacturing),
  `Income growth quartile` = qcut(dt$PCIncome)
)

## WHICH ROWS ARE EVIDENCE ABOUT A1, AND WHICH ARE NOT.
##
## scripts/simulations/sim_probe2_size.R simulates this exact probe against a
## DGP where A1 holds by construction, at this n and this tuning.  At a nominal
## 5 per cent, over 96 replications:
##
##                                        HOMOGENEOUS      HETEROGENEOUS
##                                        first stage      first stage (M&T)
##                                        size   power     size   power
##   no stratification                    0.073  0.833      0.250  0.552
##   quartile of the endogenous regressor 0.042  0.438      0.052  0.312
##   quartile of a COMPONENT of Delta Z   0.698  0.865      0.708  0.677
##
## THE SECOND BLOCK IS THE ONE THAT APPLIES HERE.  Masten and Torgovitsky (2014
## WP, section 6.2) show that on essentially this dataset the nonattainment
## instrument's first stage is heterogeneous: strong at low quantiles, fading to
## insignificance above about the 0.75 quantile, roughly a quarter of counties
## where it does nothing -- all of this coexisting with F = 25.  Under that
## first stage the UNSTRATIFIED row rejects a TRUE A1 one time in four, so its
## p-value on the real data is not evidence and is no longer reported as such.
##
## Exactly one row survives both first-stage regimes: the quartile of the
## endogenous regressor, at size 0.042 and 0.052.  The reason is mechanical and
## worth stating -- stratifying on BASELINE pollution groups counties of similar
## instrument strength, because strength tracks baseline (M&T's own explanation:
## regulation only bites where there is a pollution problem), so within a
## stratum the first stage is close to homogeneous and the distortion does not
## arise.
##
## The mechanism is varrho-hat.  Under the null draw W* - varrho-hat is mean
## zero given Delta Z by construction; the observed W - varrho-hat is mean zero
## only where varrho-hat is right.  A stratification built from Delta Z lines up
## with the directions varrho-hat gets wrong, so the observed statistic is
## compared against a reference the observed W does not obey, and the test
## rejects a TRUE A1 seven times in ten.  Its power is then meaningless.
##
## So the CONDITIONAL (A1) reading is reported only for stratifications that are
## not functions of Delta Z.  Manufacturing employment and per capita income ARE
## in the core control set, so those two rows are marked; census region is not in
## Delta Z but correlates with it, so it is marked as well rather than defended.
## The UNCONDITIONAL (predecessor) reading is unaffected: its null is an exact
## permutation of W given u-hat, with no estimated propensity in it.
PROBE2_A1_VALID <- c(`Unconditional` = FALSE, `Baseline TSP quartile` = TRUE,
                     `Census region` = FALSE, `Manufacturing quartile` = FALSE,
                     `Income growth quartile` = FALSE)

assign(".Random.seed", ANCHOR[[length(ANCHOR)]], envir = globalenv())
wv <- as.integer(dt$w)
## varrho-hat on the whole sample, the same object the estimator centres on.
rho_p2 <- fit_propensity(dt$w, Zh, seq_len(n), seq_len(n), eps = EPS_RHO)
p2_rows <- vector("list", 2L * length(strata_list))                  # INV-17
for (j in seq_along(strata_list)) {
  st <- strata_list[[j]]

  ## (a) the predecessor's restriction: F_1 - F_0, W permuted within stratum.
  obs <- cvm_stat(wv, st)
  perm <- numeric(N_PERM)
  for (b in seq_len(N_PERM)) {
    wp <- wv
    for (s in unique(st)) {
      idx <- which(st == s)
      wp[idx] <- wv[sample(idx)]
    }
    perm[b] <- cvm_stat(wp, st)
  }
  p2_rows[[2L * j - 1L]] <- data.frame(
    hypothesis = "Unconditional (predecessor)",
    a1_valid = NA,
    stratification = names(strata_list)[j],
    n_strata = length(unique(st)), stat = obs,
    perm_median = stats::median(perm),
    ratio = obs / stats::median(perm),
    p = (1 + sum(perm >= obs)) / (N_PERM + 1),
    stringsAsFactors = FALSE)

  ## (b) A1: Wtilde contrast, null drawn as W* ~ Bern(varrho-hat).
  obs_c <- cvm_cond(wv, st, rho_p2)
  ref <- numeric(N_PERM)
  for (b in seq_len(N_PERM)) {
    wstar <- stats::rbinom(n, 1L, rho_p2)
    ref[b] <- cvm_cond(wstar, st, rho_p2)
  }
  p2_rows[[2L * j]] <- data.frame(
    hypothesis = "Conditional (A1)",
    a1_valid = unname(PROBE2_A1_VALID[names(strata_list)[j]]),
    stratification = names(strata_list)[j],
    n_strata = length(unique(st)), stat = obs_c,
    perm_median = stats::median(ref),
    ratio = obs_c / stats::median(ref),
    p = (1 + sum(ref >= obs_c)) / (N_PERM + 1),
    stringsAsFactors = FALSE)
}
p2 <- do.call(rbind, p2_rows)
message("probe 2 (", nrow(p2), " rows):")
for (i in seq_len(nrow(p2))) {
  message(sprintf("  %-28s %-24s ratio %8.2f  p = %.4f%s",
                  p2$hypothesis[i], p2$stratification[i], p2$ratio[i], p2$p[i],
                  if (isTRUE(!p2$a1_valid[i]))
                    "   [SIZE-INVALID: stratum tracks Delta Z]" else ""))
}

# ---- Misclassification table ------------------------------------------------

dg1 <- readRDS(file.path(IN, "app_tsp_diagnostics.rds"))
p1 <- dg1$probe1
p3 <- dg1$probe3

p1_block <- function(nm, lab) {
  z <- p1[[nm]]
  c(sprintf("\\multicolumn{5}{l}{\\textit{%s}} \\\\", lab),
    sprintf("\\quad %s & %s & %s & %s & %s \\\\", tex_escape(z$levels),
            formatC(z$n, format = "d"), fmt(z$fs, 2), fmt(z$fs_F, 1),
            sprintf("%s (%s)", fmt(1e3 * z$b, 2), fmt(1e3 * z$se, 2))),
    sprintf("\\quad Homogeneity $\\chi^2_{%d} = %s$ & & & & $p = %s$ \\\\",
            z$df, fmt(z$Q, 2), fmt(z$p, 3)),
    "\\addlinespace")
}

#' One hypothesis block of probe 2.
#'
#' UNTIL 2026-08-10 THIS TABLE PRINTED TEN ROWS UNDER FIVE LABELS.  The probe
#' has tested two hypotheses per stratification since 2026-08-08 -- the
#' predecessor's unconditional contrast and A1's conditional one -- but the
#' emission printed p2$stratification alone, so each label appeared twice with
#' different numbers and nothing on the page said which row tested which
#' restriction.  p2$hypothesis and p2$a1_valid were computed and discarded.
#' Both now reach the page: the hypothesis as a sub-block, the size flag in the
#' fourth column, which probe 2 previously left empty at no cost in width.
#'
#' The flag is PROBE2_A1_VALID, i.e. the script's own judgement of whether the
#' A1 reading has nominal size at this stratification, and it is "--" on the
#' unconditional rows because nothing there is at stake: that null is an exact
#' permutation of W given u-hat, with no estimated propensity in it.
#'
#' @param hyp character. Value of p2$hypothesis to select.
#' @param lab character. Italic sub-block label.
#' @return character vector of LaTeX rows.
p2_block <- function(hyp, lab) {
  z <- p2[p2$hypothesis == hyp, , drop = FALSE]
  stopifnot(nrow(z) == length(strata_list))
  flag <- ifelse(is.na(z$a1_valid), "--", ifelse(z$a1_valid, "yes", "no"))
  c(sprintf("\\multicolumn{5}{l}{\\textit{%s}} \\\\", lab),
    sprintf("\\quad %s & %s & %s & %s & %s \\\\",
            tex_escape(z$stratification),
            formatC(z$n_strata, format = "d"), fmt(z$ratio, 2), flag,
            fmt_p(z$p, 3L)),
    "\\addlinespace")
}

write_tabular(
  "lrrrr",
  paste("& $n$ & First stage & $F$ &",
        "Wald ratio $\\times 10^{3}$ (SE) \\\\"),
  c("\\multicolumn{5}{l}{\\textit{Probe 1: constancy of the Wald ratio across strata}} \\\\",
    "\\midrule",
    unlist(list(p1_block("base", "By baseline TSP quartile"),
                p1_block("region", "By census region"),
                p1_block("manu", "By manufacturing-employment quartile")),
           use.names = FALSE),
    paste0("\\multicolumn{5}{l}{\\textit{Probe 2: $W$-contrast of the fitted ",
           "residual CDF within strata}} \\\\"),
    "\\midrule",
    paste("Stratification & Strata & Statistic / null median &",
          "Valid size & $p$ \\\\"),
    unlist(list(
      p2_block("Unconditional (predecessor)",
               paste("(a) Unconditional contrast $F_1 - F_0$, null by",
                     "permutation of $W$ within stratum")),
      p2_block("Conditional (A1)",
               paste("(b) Conditional contrast in $\\widetilde W$, null by",
                     "$W^{*}\\sim\\mathrm{Bern}(\\hat\\varrho(\\Delta Z))$"))),
      use.names = FALSE),
    paste0("\\multicolumn{5}{l}{\\textit{Probe 3: reduced form under flexible ",
           "control for baseline TSP}} \\\\"),
    "\\midrule",
    "Polynomial degree in $X_1$ & & Coefficient on $W$ & & Robust SE \\\\",
    sprintf("\\quad %s & & %s & & %s \\\\",
            c("0 (none)", "1", "2", "3"), fmt(p3$b, 4),
            sprintf("(%s)", fmt(p3$se, 4)))),
  file.path(TAB, "app_tsp_misclass.tex"))

# ---- phi-hat at the headline rung -------------------------------------------
#
# prp:plugin: one Landweber-Fridman pass on Delta Y - Delta Z' theta-hat with
# theta held fixed.  Reported on the mu-g/m^3 axis by inverting the coordinate
# transform of tuning constant C2.

phi <- phi_second_stage(dt$dy, xc$x1, xc$x2, Zh, dt$w, hd$theta,
                        cste = LF_CSTE, init_fn = init_control,
                        xeval = xev, lf_imax = lf_mbar(dt$w),
                           eps_rho = EPS_RHO, n_t = N_T,
                           bier_seed = BIER_SEED, t_scale = T_SCALE,
                           adj_wtil = ADJ_WTIL, conditional = TRUE,
                           tau_dp = TAU_DP)
phi_ugm3 <- xc$inv(xev)

saveRDS(list(fits = fits, ladder_diag = dg, probe2 = p2, phi = phi,
             phi_x_ugm3 = phi_ugm3, uhat = uhat, dphi_bar = dphi_bar,
             headline_dz = HEADLINE_DZ, xeval = xev, x_coord = xc$mode,
             n = n),
        file.path(OUT, "app_tsp_ladder.rds"))

message("done: app_tsp_02_ladder")
