# ============================================================================
# app_tsp_01_diagnostics.R
#
# Section 6, stage 1: the design diagnostics that have to be read BEFORE any
# structural estimate is believed.
#
#   D0  sample construction, the DiffTSP identity, descriptive statistics
#   D1  first stage  W -> Delta X, robust and state-clustered
#   D2  reduced form W -> Delta Y, and the linear (Wald) IV benchmark
#   D3  balance of the 22 differenced covariates on W
#   D4  overlap: varrho(Delta Z) = P(W = 1 | Delta Z) at every ladder rung,
#       which is A4(i) and which the data assessment never checked
#   D5  the feasibility frontier evaluated at n = 983
#   D6  differential-misclassification probes (three of them)
#   D7  a validation that this project's driver reproduces orthogonal_theta()
#
# Outputs
#   paper/tables/app_tsp_sample.tex
#   paper/tables/app_tsp_sumstats.tex
#   paper/tables/app_tsp_firststage.tex
#   paper/tables/app_tsp_balance.tex
#   paper/tables/app_tsp_overlap.tex
#   paper/tables/app_tsp_feasibility.tex
#   paper/tables/app_tsp_misclass.tex
#   quality_reports/application/app_tsp_diagnostics.rds
# ============================================================================

library(here)
library(fixest)

source(here::here("scripts", "R", "lf_panel.R"))
source(here::here("scripts", "R", "orthogonal_theta.R"))
source(here::here("scripts", "application", "app_tsp_common.R"))

RNGkind("L'Ecuyer-CMRG")
set.seed(SEED_DIAG)                                                  # INV-14

TAB <- here::here("paper", "tables")
dir.create(TAB, showWarnings = FALSE, recursive = TRUE)

# ---- D0: sample -------------------------------------------------------------

pan <- load_tsp_panel()
dt  <- pan$dt
n   <- nrow(dt)

message(sprintf("DiffTSP == (MTSP1980 - MTSP1970)/100 to %.2e",
                pan$difftsp_max_dev))
stopifnot(pan$difftsp_max_dev < 1e-10)

write_tabular(
  "lrr",
  "Step & Dropped & Remaining \\\\",
  sprintf("%s & %s & %s \\\\", tex_escape(pan$drops$step),
          ifelse(is.na(pan$drops$n_dropped), "--",
                 formatC(pan$drops$n_dropped, format = "d")),
          formatC(pan$drops$n_left, format = "d")),
  file.path(TAB, "app_tsp_sample.tex"))

sum_vars <- c("dy", "x1_raw", "x2_raw", "dx_ugm3", "w", CTRL_CORE)
sum_lab  <- c("$\\Delta Y$: change in log property value",
              "$X_1$: mean TSP 1970 ($\\mu$g/m$^3$)",
              "$X_2$: mean TSP 1980 ($\\mu$g/m$^3$)",
              "$\\Delta X$: change in TSP ($\\mu$g/m$^3$)",
              "$W$: 1975 nonattainment (imputed)",
              "$\\Delta Z_1$: per capita income",
              "$\\Delta Z_2$: population",
              "$\\Delta Z_3$: unemployment rate",
              "$\\Delta Z_4$: manufacturing employment",
              "$\\Delta Z_5$: high school")
sst <- vapply(sum_vars, \(v) {
  x <- dt[[v]]
  c(mean(x), stats::sd(x), stats::quantile(x, 0.10, names = FALSE),
    stats::median(x), stats::quantile(x, 0.90, names = FALSE))
}, numeric(5))
write_tabular(
  "lrrrrr",
  "Variable & Mean & SD & p10 & Median & p90 \\\\",
  sprintf("%s & %s & %s & %s & %s & %s \\\\", sum_lab,
          fmt(sst[1, ], 3), fmt(sst[2, ], 3), fmt(sst[3, ], 3),
          fmt(sst[4, ], 3), fmt(sst[5, ], 3)),
  file.path(TAB, "app_tsp_sumstats.tex"))

# ---- D1 / D2: first stage, reduced form, linear IV --------------------------
#
# Four control sets, matching the ladder rungs, so the first stage and the
# reduced form are read on the same axis as theta-hat.

ctl_sets <- list(
  `0`  = character(0),
  `5`  = CTRL_CORE,
  `10` = c(CTRL_CORE, CTRL_DEMO),
  `22` = CTRL_ALL
)

rhs <- function(v) if (length(v)) paste("+", paste(v, collapse = " + ")) else ""

fs_rows <- vector("list", length(ctl_sets))                          # INV-17
for (j in seq_along(ctl_sets)) {
  cs <- ctl_sets[[j]]
  f_fs <- feols(stats::as.formula(paste("dx_ugm3 ~ w", rhs(cs))), dt)
  f_rf <- feols(stats::as.formula(paste("dy ~ w", rhs(cs))), dt)
  f_iv <- feols(stats::as.formula(
    paste("dy ~ 1", rhs(cs), "| dx_ugm3 ~ w")), dt)
  fs_r <- coeftable(f_fs, vcov = "hetero")["w", ]
  fs_c <- coeftable(f_fs, cluster = ~cluster)["w", ]
  rf_r <- coeftable(f_rf, vcov = "hetero")["w", ]
  rf_c <- coeftable(f_rf, cluster = ~cluster)["w", ]
  iv_r <- coeftable(f_iv, vcov = "hetero")["fit_dx_ugm3", ]
  iv_c <- coeftable(f_iv, cluster = ~cluster)["fit_dx_ugm3", ]
  fs_rows[[j]] <- data.frame(
    d_z = as.integer(names(ctl_sets)[j]), n = f_fs$nobs,
    fs = fs_r[1], fs_se = fs_r[2], fs_se_cl = fs_c[2],
    fs_F = fs_r[3]^2, fs_F_cl = fs_c[3]^2,
    rf = rf_r[1], rf_se = rf_r[2], rf_se_cl = rf_c[2],
    iv = iv_r[1], iv_se = iv_r[2], iv_se_cl = iv_c[2],
    stringsAsFactors = FALSE)
}
fs_tab <- do.call(rbind, fs_rows)

write_tabular(
  "lrrrr",
  paste("& $d_Z=0$ & $d_Z=5$ & $d_Z=10$ & $d_Z=22$ \\\\"),
  c(paste0("\\multicolumn{5}{l}{\\textit{Panel A: first stage, dependent ",
           "variable $\\Delta X$ ($\\mu$g/m$^3$)}} \\\\"),
    "\\midrule",
    sprintf("$W$ & %s \\\\", paste(paste0(fmt(fs_tab$fs, 3),
                                          stars(fs_tab$fs, fs_tab$fs_se_cl)),
                                   collapse = " & ")),
    sprintf("\\quad robust SE & %s \\\\",
            paste(sprintf("(%s)", fmt(fs_tab$fs_se, 3)), collapse = " & ")),
    sprintf("\\quad clustered SE & %s \\\\",
            paste(sprintf("[%s]", fmt(fs_tab$fs_se_cl, 3)), collapse = " & ")),
    sprintf("$F$, robust & %s \\\\", paste(fmt(fs_tab$fs_F, 1), collapse = " & ")),
    sprintf("$F$, clustered & %s \\\\",
            paste(fmt(fs_tab$fs_F_cl, 1), collapse = " & ")),
    "\\addlinespace",
    paste0("\\multicolumn{5}{l}{\\textit{Panel B: reduced form, dependent ",
           "variable $\\Delta Y$}} \\\\"),
    "\\midrule",
    sprintf("$W$ & %s \\\\", paste(paste0(fmt(fs_tab$rf, 4),
                                          stars(fs_tab$rf, fs_tab$rf_se_cl)),
                                   collapse = " & ")),
    sprintf("\\quad robust SE & %s \\\\",
            paste(sprintf("(%s)", fmt(fs_tab$rf_se, 4)), collapse = " & ")),
    sprintf("\\quad clustered SE & %s \\\\",
            paste(sprintf("[%s]", fmt(fs_tab$rf_se_cl, 4)), collapse = " & ")),
    "\\addlinespace",
    paste0("\\multicolumn{5}{l}{\\textit{Panel C: linear IV, coefficient on ",
           "$\\Delta X$ ($\\times 10^{3}$)}} \\\\"),
    "\\midrule",
    sprintf("$\\Delta X$ & %s \\\\",
            paste(paste0(fmt(1e3 * fs_tab$iv, 3),
                         stars(fs_tab$iv, fs_tab$iv_se_cl)), collapse = " & ")),
    sprintf("\\quad robust SE & %s \\\\",
            paste(sprintf("(%s)", fmt(1e3 * fs_tab$iv_se, 3)), collapse = " & ")),
    sprintf("\\quad clustered SE & %s \\\\",
            paste(sprintf("[%s]", fmt(1e3 * fs_tab$iv_se_cl, 3)),
                  collapse = " & ")),
    "\\addlinespace",
    sprintf("Observations & %s \\\\",
            paste(formatC(fs_tab$n, format = "d", big.mark = ","),
                  collapse = " & "))),
  file.path(TAB, "app_tsp_firststage.tex"))

# ---- D3: balance ------------------------------------------------------------

bal <- vapply(CTRL_ALL, \(v) {
  f <- feols(stats::as.formula(paste(v, "~ w")), dt)
  r <- coeftable(f, vcov = "hetero")["w", ]
  cl <- coeftable(f, cluster = ~cluster)["w", ]
  c(diff = r[1], se = r[2], t = r[3], se_cl = cl[2], t_cl = cl[3],
    nd = r[1] / stats::sd(dt[[v]]))
}, numeric(6))
bal <- t(bal)
colnames(bal) <- c("diff", "se", "t", "se_cl", "t_cl", "nd")

# Joint test that W is mean-independent of all 22 differenced covariates:
# the F on the full covariate block in a linear probability model for W.
f_joint <- feols(stats::as.formula(paste("w ~", paste(CTRL_ALL, collapse = "+"))),
                 dt)
wald_r  <- wald(f_joint, keep = CTRL_ALL, vcov = "hetero", print = FALSE)
wald_c  <- wald(f_joint, keep = CTRL_ALL, cluster = ~cluster, print = FALSE)

blk <- c(rep("Core (rung 1)", length(CTRL_CORE)),
         rep("Demographic (rung 2)", length(CTRL_DEMO)),
         rep("Housing and fiscal (rung 3)", length(CTRL_WIDE)))
bal_body <- vector("list", length(unique(blk)))                      # INV-17
for (j in seq_along(unique(blk))) {
  b <- unique(blk)[j]
  idx <- which(blk == b)
  bal_body[[j]] <- c(
    sprintf("\\multicolumn{5}{l}{\\textit{%s}} \\\\", b),
    sprintf("\\quad %s & %s & %s & %s & %s \\\\",
            tex_escape(CTRL_ALL[idx]), fmt(bal[idx, "diff"], 4),
            sprintf("(%s)", fmt(bal[idx, "se"], 4)),
            sprintf("[%s]", fmt(bal[idx, "se_cl"], 4)),
            fmt(bal[idx, "nd"], 3)),
    if (j < length(unique(blk))) "\\addlinespace" else NULL)
}
write_tabular(
  "lrrrr",
  "Differenced covariate & Diff. & Robust SE & Clustered SE & Norm.\\ diff. \\\\",
  c(unlist(bal_body, use.names = FALSE), "\\midrule",
    sprintf("Imbalanced at 5\\%% (robust / clustered) & \\multicolumn{4}{r}{%d / %d of %d} \\\\",
            sum(abs(bal[, "t"]) > stats::qnorm(0.975)),
            sum(abs(bal[, "t_cl"]) > stats::qnorm(0.975)), nrow(bal)),
    sprintf("Joint $F$ (robust) & \\multicolumn{4}{r}{%s \\ [$p = %s$]} \\\\",
            fmt(wald_r$stat, 2), fmt(wald_r$p, 4)),
    sprintf("Joint $F$ (clustered) & \\multicolumn{4}{r}{%s \\ [$p = %s$]} \\\\",
            fmt(wald_c$stat, 2), fmt(wald_c$p, 4))),
  file.path(TAB, "app_tsp_balance.tex"))

# ---- D4: overlap, A4(i) -----------------------------------------------------
#
# A4(i) requires eps <= varrho(Delta Z) <= 1 - eps.  This is the check the
# explorer-critic recorded as never run (M-1).  It is run here at every rung
# and, separately, on baseline TSP, which is the fork M-1 identified: the
# designation is a threshold rule on pre-1975 TSP, so conditioning on a
# baseline TSP measure is exactly where overlap is at risk.

ov_rows <- vector("list", length(ctl_sets) + 2L)                     # INV-17
ov_spec <- c(as.list(ctl_sets), list(x1_raw = "x1_raw",
                                     x1_core = c("x1_raw", CTRL_CORE)))
ov_lab  <- c("$d_Z = 0$ (intercept only)", "$d_Z = 5$", "$d_Z = 10$",
             "$d_Z = 22$", "Baseline TSP only", "Baseline TSP $+$ rung 1")
for (j in seq_along(ov_spec)) {
  cs <- ov_spec[[j]]
  if (!length(cs)) {
    rh <- rep(mean(dt$w), n)
    pr2 <- 0
  } else {
    g <- stats::glm(stats::as.formula(paste("w ~", paste(cs, collapse = "+"))),
                    data = dt, family = stats::binomial())
    rh <- stats::fitted(g)
    pr2 <- 1 - g$deviance / g$null.deviance
  }
  rh <- pmin(pmax(rh, .Machine$double.eps), 1 - .Machine$double.eps)
  ov_rows[[j]] <- data.frame(
    label = ov_lab[j], min = min(rh), p01 = stats::quantile(rh, 0.01, names = FALSE),
    p99 = stats::quantile(rh, 0.99, names = FALSE), max = max(rh),
    out05 = mean(rh < 0.05 | rh > 0.95), out10 = mean(rh < 0.10 | rh > 0.90),
    pseudo_r2 = pr2, stringsAsFactors = FALSE)
}
ov <- do.call(rbind, ov_rows)
write_tabular(
  "lrrrrrrr",
  paste0("Conditioning set & Min & p1 & p99 & Max & ",
         "Share $\\notin[.05,.95]$ & Share $\\notin[.10,.90]$ & ",
         "Pseudo-$R^2$ \\\\"),
  sprintf("%s & %s & %s & %s & %s & %s & %s & %s \\\\", ov$label,
          fmt(ov$min, 3), fmt(ov$p01, 3), fmt(ov$p99, 3), fmt(ov$max, 3),
          fmt(ov$out05, 3), fmt(ov$out10, 3), fmt(ov$pseudo_r2, 3)),
  file.path(TAB, "app_tsp_overlap.tex"))

# ---- D5: the feasibility frontier at n = 983 --------------------------------
#
# The frontier is kappa(mu) * alpha(r, d_Z) > 1/4 with kappa = 2mu/(2mu+1) and
# alpha = r/(2r + d_Z) -- assumptions.tex, the A5(iii) block, whose printed
# table this reproduces at (mu, d_Z) = (1,3), (1,5), (2,3).  Evaluated at the
# configuration proofs.tex rem:h6bandwidth(5) names as the one a simulation
# should run, (mu, r) = (2, 8/3), which is what this project's Monte Carlo runs.

feas_rows <- vector("list", length(LADDER_DZ))                       # INV-17
for (j in seq_along(LADDER_DZ)) {
  dz <- LADDER_DZ[j]
  al <- frontier_alpha(R_FRONTIER, dz)
  ka <- frontier_kappa(MU_FRONTIER)
  feas_rows[[j]] <- data.frame(
    d_z = dz,
    r_req_mu1 = frontier_r_required(1, dz),
    r_req_mu2 = frontier_r_required(2, dz),
    r_req_mu3 = frontier_r_required(3, dz),
    kappa_alpha = ka * al,
    delta_n = rate_delta_n(n, MU_FRONTIER, R_FRONTIER, dz),
    budget = budget_sqrtn_delta2(n, MU_FRONTIER, R_FRONTIER, dz),
    inside = ka * al > 0.25, stringsAsFactors = FALSE)
}
feas <- do.call(rbind, feas_rows)

# Sample size at which the budget would first fall below 1, at each rung.
n_needed <- vapply(LADDER_DZ, \(dz) {
  # A5(i) IS A MAXIMUM OVER TWO BRANCHES AND THIS SOLVER USED ONE. Corrected
  # 2026-08-03, with rate_delta_n in app_tsp_common.R, which had the same defect.
  #   log delta-hat_n = max( -ln/2 + log(ln)/2 ,  -alpha * ln )
  #                        parametric floor        propensity branch
  # and log( sqrt(n) delta_n^2 ) = ln/2 + 2 kappa ( log delta-hat_n + log(ln) ).
  # At d_Z = 0 the rung has alpha = 1/2, so the floor binds at EVERY n and the
  # old form understated the budget by a factor of about 4.6 there.
  kap <- frontier_kappa(MU_FRONTIER)
  alp <- frontier_alpha(R_FRONTIER, dz)
  g <- \(ln) ln / 2 + 2 * kap * (pmax(-ln / 2 + log(ln) / 2, -alp * ln) + log(ln))
  # TWO conditions now, because there are two branches and the budget vanishes
  # only if BOTH do. Propensity: kappa * alpha > 1/4, as before. Parametric:
  # sqrt(n) delta_n^2 >= n^{1/2 - kappa} (ln n)^{3 kappa}, which needs
  # kappa > 1/2, i.e. mu > 1/2 -- implied here by eq:muhalf's mu > 5/6, so it
  # never binds at an admissible mu, but it is checked rather than assumed.
  if (kap * alp <= 0.25 || kap <= 0.5) {
    return(Inf)
  }
  lo <- log(n); hi <- 1e5
  while (g(hi) > 0 && hi < 1e9) hi <- hi * 10
  if (g(hi) > 0) return(Inf)
  exp(stats::uniroot(g, c(lo, hi))$root)
}, numeric(1))
feas$n_needed <- n_needed

write_tabular(
  "rrrrrrrrl",
  c(paste("$d_Z$ & \\multicolumn{3}{c}{$r$ required to clear the frontier}",
          "& $\\kappa\\alpha$ & $\\delta_n$ & $\\sqrt n\\,\\delta_n^2$",
          "& $n$ for budget $<1$ & Verdict \\\\"),
    "\\cmidrule(lr){2-4}",
    "& $\\mu=1$ & $\\mu=2$ & $\\mu=3$ & & & & & \\\\"),
  sprintf("%d & %s & %s & %s & %s & %s & %s & %s & %s \\\\",
          feas$d_z, fmt(feas$r_req_mu1, 2), fmt(feas$r_req_mu2, 2),
          fmt(feas$r_req_mu3, 2), fmt(feas$kappa_alpha, 3),
          fmt(feas$delta_n, 3), fmt(feas$budget, 1),
          # ifelse() evaluates both branches, and formatC(Inf, format = "d")
          # overflows the integer range with a warning, so the finite entries
          # are formatted on their own and the infinite ones are filled in.
          local({
            out <- rep("never", length(feas$n_needed))
            fin <- is.finite(feas$n_needed)
            v <- feas$n_needed[fin]
            # formatC(format = "d") RETURNS NA ABOVE .Machine$integer.max
            # (2.15e9), silently. It did: correcting A5(i) on 2026-08-03 moved
            # the d_Z = 0 rung from 1.36e6 to 2.15e11, and the cell printed
            # "NA" in a table that had otherwise regenerated cleanly. Anything
            # past the integer range is written as a power of ten instead,
            # which is also more honest at that magnitude -- nobody needs the
            # units digit of 215,000,000,000.
            big <- v > 1e9
            out[fin][!big] <- formatC(round(v[!big]), format = "d",
                                      big.mark = ",")
            out[fin][big]  <- sprintf("$%.1f\\times10^{%d}$",
                                      v[big] / 10^floor(log10(v[big])),
                                      floor(log10(v[big])))
            out
          }),
          ifelse(feas$inside, "inside", "outside")),
  file.path(TAB, "app_tsp_feasibility.tex"))

# ---- D6: differential-misclassification probes ------------------------------
#
# The decision record forbids asserting that non-differential misclassification
# holds.  These three probes are EVIDENCE, and each is reported with what it
# cannot settle.

fips_region <- function(s) {
  ne <- c(9, 23, 25, 33, 44, 50, 34, 36, 42)
  mw <- c(17, 18, 26, 39, 55, 19, 20, 27, 29, 31, 38, 46)
  so <- c(10, 11, 12, 13, 24, 37, 45, 51, 54, 1, 21, 28, 47, 5, 22, 40, 48)
  ifelse(s %in% ne, "Northeast",
         ifelse(s %in% mw, "Midwest",
                ifelse(s %in% so, "South", "West")))
}
qcut <- function(x, k = 4L) {
  cut(x, stats::quantile(x, seq(0, 1, length.out = k + 1L)),
      include.lowest = TRUE, labels = FALSE)
}

dt$region  <- fips_region(dt$StateCode)
dt$q_base  <- qcut(dt$x1_raw)
dt$q_manu  <- qcut(dt$EmpManufacturing)

#' Probe 1: stratum-by-stratum Wald ratio and a homogeneity chi-square.
#'
#' Strata partition the sample, so the stratum estimates are independent and
#' Q = sum (b_s - bbar)^2 / V_s is chi-square with S-1 degrees of freedom.
#'
#' The within-stratum first stage is returned alongside the ratio, because a
#' homogeneity test on ratios whose denominators are near zero has no power and
#' a non-rejection would otherwise be read as evidence of constancy.
wald_homogeneity <- function(strat) {
  lv <- sort(unique(strat))
  b <- numeric(length(lv)); v <- numeric(length(lv))                 # INV-17
  ns <- integer(length(lv)); fsr <- numeric(length(lv))
  fsf <- numeric(length(lv))
  for (j in seq_along(lv)) {
    s <- dt[strat == lv[j], , drop = FALSE]
    f <- feols(dy ~ 1 | dx_ugm3 ~ w, s)
    ct <- coeftable(f, vcov = "hetero")["fit_dx_ugm3", ]
    b[j] <- ct[1]; v[j] <- ct[2]^2; ns[j] <- nrow(s)
    fs <- coeftable(feols(dx_ugm3 ~ w, s), vcov = "hetero")["w", ]
    fsr[j] <- fs[1]
    fsf[j] <- fs[3]^2
  }
  ok <- is.finite(b) & is.finite(v) & v > 0
  bbar <- sum(b[ok] / v[ok]) / sum(1 / v[ok])
  Q <- sum((b[ok] - bbar)^2 / v[ok])
  df <- sum(ok) - 1L
  list(levels = as.character(lv), b = b, se = sqrt(v), n = ns, fs = fsr,
       fs_F = fsf, bbar = bbar, Q = Q, df = df,
       p = stats::pchisq(Q, df, lower.tail = FALSE))
}
p1 <- list(base = wald_homogeneity(dt$q_base),
           region = wald_homogeneity(dt$region),
           manu = wald_homogeneity(dt$q_manu))

#' Probe 3: does the reduced form survive flexible control for baseline TSP?
#'
#' The mechanism Cropper et al. implicate is that designation tracks the
#' pre-period level and the level mean-reverts.  If the W-to-Delta-Y relation
#' is generated by that channel rather than by the policy, it collapses once
#' the baseline level is controlled flexibly.
p3_rows <- vector("list", 4L)                                        # INV-17
for (deg in 0:3) {
  trm <- if (deg == 0L) "" else sprintf("+ poly(x1_raw, %d, raw = TRUE)", deg)
  f <- feols(stats::as.formula(
    paste("dy ~ w", rhs(CTRL_CORE), trm)), dt)
  r <- coeftable(f, vcov = "hetero")["w", ]
  cl <- coeftable(f, cluster = ~cluster)["w", ]
  p3_rows[[deg + 1L]] <- data.frame(degree = deg, b = r[1], se = r[2],
                                    se_cl = cl[2], stringsAsFactors = FALSE)
}
p3 <- do.call(rbind, p3_rows)

saveRDS(list(panel = pan, fs_tab = fs_tab, balance = bal,
             wald_joint = list(robust = wald_r, clustered = wald_c),
             overlap = ov, feasibility = feas, probe1 = p1, probe3 = p3,
             n = n),
        here::here("quality_reports", "application",
                   "app_tsp_diagnostics.rds"))

# The within-stratum residual-independence probe needs a fitted residual, so it
# lives in app_tsp_02_ladder.R where the fit exists.  The misclassification
# table is written there too, from this file's probe 1 and 3 plus that probe.

# ---- D7: driver validation --------------------------------------------------
#
# fit_one_partition() must reproduce orthogonal_theta() exactly when handed
# matching arguments; the only thing this project's driver adds is a second
# variance.
#
# BOTH SIDES NOW RUN THE SHIPPED STOPPING RULE, tau_dp = TAU_DP.  Until
# 2026-08-12 orthogonal_theta() did not expose tau_dp or lf_patience and this
# test matched crossfit_once()'s defaults (0.7 and 30) on both sides -- fine
# while the application also ran 0.7, and silently wrong the moment it stopped:
# the reference would have kept the discrepancy rule while the driver ran the
# cap, and this assertion would have reported a REAL difference in stopping
# rules as a driver arithmetic defect.  The two arguments are exposed now, so
# the test certifies the driver at the configuration the application ships.
# lf_imax is 300 rather than lf_mbar() on purpose: parity is a statement about
# arithmetic and holds at any budget, and a longer one exercises more of it.

xc <- make_x_coord(dt$x1_raw, dt$x2_raw, mode = "rank")
Z5 <- make_design(dt, 5L)
xev <- seq(stats::quantile(c(xc$x1, xc$x2), XEVAL_LO),
           stats::quantile(c(xc$x1, xc$x2), XEVAL_HI), length.out = N_XEVAL)

VAL_SEED <- 4242L
mine <- with_fixed_seed(VAL_SEED,
  fit_one_partition(dt$dy, xc$x1, xc$x2, Z5, dt$w, dt$cluster,
                    K = 2L, cste = LF_CSTE, init_fn = init_control,
                    lf_imax = 300L, lf_patience = 30L, rho = RHO,
                    xeval = xev, tau_dp = TAU_DP))
theirs <- orthogonal_theta(dt$dy, xc$x1, xc$x2, Z5, dt$w, K = 2L, n_part = 1L,
                           cste = LF_CSTE, init_fn = init_control,
                           lf_imax = 300L, lf_patience = 30L, rho = RHO,
                           xeval = xev, seed = VAL_SEED, tau_dp = TAU_DP,
                           verbose = FALSE)
val_gap <- max(abs(mine$theta - theirs$theta))
message(sprintf("D7 driver validation: max |theta_driver - theta_reference| = %.3e",
                val_gap))
stopifnot(val_gap < 1e-10)

message("done: app_tsp_01_diagnostics")
