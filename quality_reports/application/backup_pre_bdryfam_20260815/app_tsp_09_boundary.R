## ---------------------------------------------------------------------------
## app_tsp_09_boundary.R -- C3(ii)'s BOUNDARY ADJUSTMENT, MEASURED.
##
## WHAT THIS STAGE IS FOR.  On 2026-08-14 the x-direction kernel of
## scripts/R/lf_panel.R gained the renormalisation of the Monte Carlo's design
## decision D11 (sim_thm_rootn_phistep.R:63-71),
##
##     C_{h_x}(x - X) / int_X C_{h_x}(y - X) dy,
##
## which enforces C3(ii)'s j = 0 truncated moment exactly.  Until then the
## application implemented NO boundary adjustment at all, while the simulation
## that verifies thm:rootn implemented this one -- so Section 5 verified one
## estimator and Section 6 shipped another.  This stage exists so that the claim
## "prp:hatAprop(iii) now holds" is a MEASUREMENT of the clause's own observable
## and not an assertion that a renormalisation was added.
##
## THE OBSERVABLE.  prp:hatAprop(iii) is
##     int_X nu-hat_{u,t,l}(x) dx = 0  for every (u,t,l),
## hence A-hat*_varphi Xi in cal-V for every Xi in L^2(Pi).  This engine works in
## the DERIVATIVE parameterisation, where apply_adjoint() forms
##     nu-hat^der(v) = (1/n) sum_i (g_i - gbar) { S(v; X_i2) - S(v; X_i1) }
## and eq:hatnu's level-space nu-hat is -d/dv of it, so
##     int_X nu-hat dx = nu-hat^der(lo) - nu-hat^der(hi),
## exactly computable from two extra survival rows.  `g` is the CONTRACTED
## residual comperr, i.e. Xi already paired against Pi, so what is reported is
## the cal-V-membership of the realised A-hat* Xi and not of a sufficient
## condition for it.
##
## WHAT IS NOT DONE, DELIBERATELY.  The HIGHER truncated moments (1 <= j <=
## p_K - 1) are NOT enforced, exactly as D11 records for the simulation: the
## boundary bias is therefore O(h_x) rather than O(h_x^{p_K}) within c_C h_x of
## an endpoint.  Enforcing them is a different estimator and is not this
## stage's, or this round's, to make.
##
## THE ABLATION.  Every curve at every cardinality moves under this change, which
## is expected and is what the theory says a boundary correction does.  What must
## NOT move is anything the x-kernel cannot reach, and that is checked rather
## than argued: the propensity is a function of (W, Delta Z, fold indices) alone
## and never sees C_{h_x}, so its cross-fitted binding rate, evaluation count and
## pre-projection minimum must be BIT-FOR-BIT identical across the two arms.
##
## ---------------------------------------------------------------------------
## PANEL E'S TWO PROPENSITY ROWS ARE DRAWS, AND UNTIL 2026-08-15 THE TABLE DID
## NOT SAY SO.  A writer-critic read Panel E's 0.7322% binding rate and 2.5e-05
## pre-projection minimum against the SAME TWO STATISTICS in the headline
## theta-hat table, which report 0.997% and 4.3e-05 at a configuration both
## tables label d_Z = 5, L = 4.  One design, described twice, two answers.
##
## MEASURED, NOT ARGUED (2026-08-15).  Calling fit_orthogonal() with ONE argument
## list and only the RNG anchor varied returns
##     set.seed(SEED_BOUNDARY)  -> 0.7322% (216/29500), min pre 2.5428e-05
##     set.seed(SEED_LOCALISE)  -> 0.9966% (294/29500), min pre 4.2929e-05
## and the second reproduces the shipped headline arm's theta-hat to the last
## printed digit.  So the two tables run the same estimator at the same eps, the
## same cap and the same instrument, on two different CROSS-FITTING FOLD DRAWS.
## Nothing disagrees; the fold draw was simply never named.
##
## WHY THIS IS LABELLED AND NOT RE-ANCHORED.  Forcing this ablation onto
## SEED_LOCALISE would make the two tables print one number, and would delete the
## fact that makes the number worth reading: over 200 independent redraws of the
## partition structure the POOLED binding rate has mean 1.00% and sd 0.19, and
## the pooled pre-projection minimum ranges over four and a half decades.  A
## single value of either is nearly uninformative without that scale, and two
## agreeing single values would be exactly as uninformative.  Panel E therefore
## names the draw and prints the law beneath each statistic, which resolves the
## reader's question -- "why two answers?" -- without a cross-reference, and
## incidentally sharpens the panel's own claim: the two engines agreeing
## BIT-FOR-BIT is a strong statement precisely because the statistic they agree
## on has an across-draw sd of 0.19 percentage points.
##
## Two further reasons the anchor stays where it is.  (i) app_tsp_run_all.R runs
## this stage BEFORE stage 8, deliberately, so that a regression in the
## adjustment reaches the log before four hours of bootstrap are spent; tying
## these arms to the later stage's seed would invert that, and the bit-for-bit
## assertion that would make re-anchoring worth its cost cannot be written here
## without the inversion.  (ii) The ablation is a PAIRED contrast -- two engines,
## one stream -- and its validity needs the two arms to share a draw, not to
## share any particular one.  That the pairing matters is itself measurable: the
## same theta-hat on the two anchors differs by up to 0.63 clustered standard
## errors, against the 0.115 that Panel D attributes to the engine change.
## ---------------------------------------------------------------------------
##
## Outputs
##   paper/tables/app_tsp_boundary.tex              (bare tabular, INV-13)
##   quality_reports/application/app_tsp_boundary.rds
## ---------------------------------------------------------------------------

suppressMessages({
  library(here)
  library(parallel)
})
source(here::here("scripts", "R", "lf_panel.R"))
source(here::here("scripts", "R", "orthogonal_theta.R"))
source(here::here("scripts", "application", "app_tsp_common.R"))

RNGkind("L'Ecuyer-CMRG")
set.seed(SEED_BOUNDARY)                                              # INV-14

## THE ABLATION'S ANCHOR, CAPTURED BEFORE ANYTHING CONSUMES THE STREAM.
##
## It is taken HERE and not after the diagnostic solves, and the reason is
## app_tsp_08_localise.R's revision note (R2): under L'Ecuyer-CMRG the parent's
## state advances once per forked job, so a stream read after some variable
## number of solves is a function of HOW MANY SOLVES RAN.  Both ablation arms
## restore this one anchor, so they are identical to each other either way -- but
## anchoring it at the top makes the arms a function of SEED_BOUNDARY alone,
## which is what makes this stage's numbers reproducible when a solve is added.
ANCHOR <- get(".Random.seed", envir = globalenv())

D_Z <- 5L                          # the application's headline control set

## Independent redraws of the CROSS-FITTING PARTITION STRUCTURE used to price
## Panel E's two draw-dependent rows.  200 puts the Monte Carlo error on the mean
## binding rate at about 0.013 percentage points, an order below the 0.19 sd it
## is estimating, and costs about 75 s on 8 cores.
B_PDREF <- 200L

## The reference block's dedicated L'Ecuyer substream, counted in hops from this
## script's one anchor.  It runs AFTER the two forked ablation arms, and
## mclapply() advances the parent's stream once per forked job under
## L'Ecuyer-CMRG, so a draw taken from the ambient state there would be a
## function of the CORE COUNT.  300 is far past the 2 x N_PART = 20 the arms
## consume and substreams are 2^127 apart.  Same device as
## app_tsp_08_localise.R's NULL_STREAM_SKIP and app_tsp_10_n1_anchor.R's
## PROP_STREAM, for the same reason.
PD_STREAM_SKIP <- 300L

OUT_ROOT <- Sys.getenv("APP_TSP_OUT_ROOT", unset = here::here())
OUT <- file.path(OUT_ROOT, "quality_reports", "application")
TAB <- file.path(OUT_ROOT, "paper", "tables")
for (d in c(OUT, TAB)) dir.create(d, showWarnings = FALSE, recursive = TRUE)

# ---- the superseded engine, in a private environment -----------------------
#
# The ablation needs BOTH engines in one process, and the legacy one is reached
# by a single default: make_operator()'s `xsupp`, which is the pooled empirical
# range and disables the adjustment at NULL.  Rebinding it in the GLOBAL
# environment would leave the process in a state where "the estimator" means
# different things at different lines, which is the failure app_tsp_run_all.R's
# lock exists to prevent one process-level up.  So the superseded engine gets
# its own environment, exactly as the weighted layer does: the three source
# files are evaluated into it, one default is patched there, and nothing outside
# it can see the patch.
make_legacy_env <- function() {
  env <- new.env(parent = globalenv())
  sys.source(here::here("scripts", "R", "lf_panel.R"), envir = env)
  sys.source(here::here("scripts", "R", "orthogonal_theta.R"), envir = env)
  sys.source(here::here("scripts", "application", "app_tsp_common.R"),
             envir = env)
  mo <- get("make_operator", envir = env)
  ## `formals(mo)["xsupp"] <- list(NULL)`, NOT `formals(mo)$xsupp <- NULL`.
  ## The second DELETES the formal -- assigning NULL to a list element removes
  ## it -- and the body then fails with "object 'xsupp' not found" rather than
  ## running the legacy path.  Setting the DEFAULT to NULL is the intent.
  formals(mo)["xsupp"] <- list(NULL)
  stopifnot("xsupp" %in% names(formals(mo)))
  environment(mo) <- env
  assign("make_operator", mo, envir = env)
  ## Assert the patch took, and that it is the ONLY difference: the legacy
  ## make_operator() must return an operator with no support, and everything
  ## else in the file must be the file.
  op_chk <- env$make_operator(c(0.2, 0.4, 0.6), c(0.3, 0.5, 0.7),
                              c(0.3, 0.5))
  if (!is.null(op_chk$xsupp)) {
    stop("legacy env: make_operator() still carries a support")
  }
  if (!identical(deparse(env$survival_matrix), deparse(survival_matrix))) {
    stop("legacy env: survival_matrix() is not the shipped one")
  }
  env
}

LEG <- make_legacy_env()
message("boundary: superseded engine built (make_operator xsupp = NULL)")

# ---- data ------------------------------------------------------------------

P  <- load_tsp_panel()
dt <- P$dt
n  <- nrow(dt)
iv <- load_tsp_w4(dt)
dt$w4 <- iv$w4
W_INST <- dt$w4
CELLS_INST <- iv$cells
EPS_INST <- eps_for(W_INST)
MBAR_INST <- lf_mbar(W_INST)

xc <- make_x_coord(dt$x1_raw, dt$x2_raw, mode = "rank")
Z  <- make_design(dt, D_Z)
y  <- dt$dy
xev <- seq(stats::quantile(c(xc$x1, xc$x2), XEVAL_LO),
           stats::quantile(c(xc$x1, xc$x2), XEVAL_HI), length.out = N_XEVAL)

op_new <- make_operator(xc$x1, xc$x2, xev)
op_old <- make_operator(xc$x1, xc$x2, xev, xsupp = NULL)
XS <- op_new$xsupp
stopifnot(length(XS) == 2L, XS[2] > XS[1], is.null(op_old$xsupp))
message(sprintf(paste("boundary: n = %d, L = %d, eps = %.3f, m-bar = %d;",
                      "X = [%.6f, %.6f], h_x = (%.5f, %.5f)"),
                n, length(CELLS_INST), EPS_INST, MBAR_INST, XS[1], XS[2],
                op_new$hx[1], op_new$hx[2]))

## THE OPERATOR IS BUILT ON THE FULL SAMPLE HERE, AND THE ESTIMATOR BUILDS IT ON
## A 40% SOLVE FOLD (crossfit_once splits the 80% complement in half).  The
## bandwidth is bw_rot, which is proportional to n^{-1/5}, so the fold's h_x is
## about 1.20 times this one and the boundary region is correspondingly WIDER
## there.  The full-sample figures below are therefore the CONSERVATIVE end of
## the defect, not the typical one; the fold's own h_x is reported beside them.
h_fold <- c(bw_rot(xc$x1[seq_len(393L)]), bw_rot(xc$x2[seq_len(393L)]))

# ---- Panel A: C3(ii)'s j = 0 truncated moment ------------------------------
#
# (1/h) int_X C((y - X)/h) dy at every design point.  Equals 1 in the interior
# and falls to 1/2 at an endpoint for a symmetric kernel.  Under the adjustment
# it is 1 at every point by construction, so what is reported after is a
# machine-precision residual and not an estimate.

m0_raw <- c(kernel_insupp_mass(xc$x1, op_new$hx[1], XS, 2L),
            kernel_insupp_mass(xc$x2, op_new$hx[2], XS, 2L))
m0_adj <- rep(1, length(m0_raw))         # exact, by construction
panelA <- list(
  before = list(min = min(m0_raw), median = stats::median(m0_raw),
                max = max(m0_raw), worst = max(abs(1 - m0_raw)),
                share_1pct = mean(abs(1 - m0_raw) > 0.01),
                share_10pct = mean(abs(1 - m0_raw) > 0.10)),
  after = list(min = 1, median = 1, max = 1, worst = 0,
               share_1pct = 0, share_10pct = 0),
  h_full = op_new$hx, h_fold = h_fold)
message(sprintf(paste("  A. j=0 truncated moment before: min %.4f, worst",
                      "defect %.4f, %.1f%% off by >1%%, %.1f%% by >10%%"),
                panelA$before$min, panelA$before$worst,
                100 * panelA$before$share_1pct,
                100 * panelA$before$share_10pct))

## The adjusted survival's two exact identities, asserted rather than described:
## S(lo; X) = 1 and S(hi; X) = 0 at EVERY design point, which is what makes
## int_X nu-hat dx vanish for EVERY residual and not merely for the realised one.
s_lo <- n * c(survival_matrix(XS[1], xc$x1, op_new$hx[1], XS),
              survival_matrix(XS[1], xc$x2, op_new$hx[2], XS))
s_hi <- n * c(survival_matrix(XS[2], xc$x1, op_new$hx[1], XS),
              survival_matrix(XS[2], xc$x2, op_new$hx[2], XS))
stopifnot(max(abs(s_lo - 1)) < 1e-12, max(abs(s_hi)) < 1e-12)
s_lo_old <- n * c(survival_matrix(XS[1], xc$x1, op_old$hx[1], NULL),
                  survival_matrix(XS[1], xc$x2, op_old$hx[2], NULL))
s_hi_old <- n * c(survival_matrix(XS[2], xc$x1, op_old$hx[1], NULL),
                  survival_matrix(XS[2], xc$x2, op_old$hx[2], NULL))
panelA$survival <- list(
  before = c(max_dev_lo = max(abs(s_lo_old - 1)), max_dev_hi = max(abs(s_hi_old))),
  after = c(max_dev_lo = max(abs(s_lo - 1)), max_dev_hi = max(abs(s_hi))))

# ---- Panel B: the reference density ----------------------------------------

xg <- seq(XS[1], XS[2], length.out = 8001L)
tri <- function(g, v) sum(diff(g) * (v[-1] + v[-length(v)]) / 2)
pi_old <- 0.5 * ker_dens(xc$x1, xg, op_old$bw1) +
          0.5 * ker_dens(xc$x2, xg, op_old$bw2)
pi_new <- 0.5 * ker_dens(xc$x1, xg, op_new$bw1, xsupp = XS) +
          0.5 * ker_dens(xc$x2, xg, op_new$bw2, xsupp = XS)
panelB <- list(
  before = list(total = tri(xg, pi_old), at_lo = pi_old[1],
                at_hi = pi_old[length(pi_old)],
                at_q05 = stats::approx(xg, pi_old, xout = xev[1])$y,
                at_q95 = stats::approx(xg, pi_old,
                                       xout = xev[length(xev)])$y),
  after = list(total = tri(xg, pi_new), at_lo = pi_new[1],
               at_hi = pi_new[length(pi_new)],
               at_q05 = stats::approx(xg, pi_new, xout = xev[1])$y,
               at_q95 = stats::approx(xg, pi_new,
                                      xout = xev[length(xev)])$y))
message(sprintf(paste("  B. int_X pi-hat dx: %.6f -> %.6f;  pi-hat at the",
                      "reported grid's ends: (%.4f, %.4f) -> (%.4f, %.4f)"),
                panelB$before$total, panelB$after$total,
                panelB$before$at_q05, panelB$before$at_q95,
                panelB$after$at_q05, panelB$after$at_q95))

# ---- Panel C: prp:hatAprop(iii)'s observable at a REALISED residual --------
#
# The residual has to be the one the estimator forms, not a synthetic vector, or
# the number is about an arbitrary direction in L^2(Pi).  So one full-sample
# second-stage solve is run under EACH engine at a common theta, and the
# contracted residual comperr is taken at the returned iterate.
#
# TWO COMPARISONS, AND THEY ANSWER DIFFERENT QUESTIONS.
#   "same g"  evaluates BOTH operators at the ADJUSTED engine's residual.  This
#             isolates the KERNEL: one vector, two operators.
#   "own g"   evaluates each engine at its own realised residual, which is what
#             each engine actually does.
# The first is the clean statement about C3(ii); the second is the statement
# about the shipped path.  Under the adjustment both are exactly zero, because
# the identity holds for every residual.

theta0 <- stats::lm.fit(Z, y)$coefficients
theta0[!is.finite(theta0)] <- 0

#' The contracted residual at the returned iterate of one second-stage solve.
#'
#' BOTH SEEDED BLOCKS GO THROUGH with_fixed_seed(), the device app_tsp_common.R
#' registers for exactly this case and the one INV-14 exception this project
#' grants itself.  Two properties are wanted and a bare set.seed() delivers only
#' the first: the two engines must see the SAME stream (so the comparison is
#' about the kernel), and the ambient stream must be left where it was (so the
#' ablation below does not silently depend on how many solves ran above it).
#' The propensity fit is re-seeded separately rather than sharing the solve's
#' stream, because the two engines need not consume randomness identically
#' inside the solve and the propensity must not inherit that difference.
#'
#' @param env environment or NULL. NULL is the shipped engine; LEG the legacy.
#' @return named list: op, g (comperr), iter, u, phi.
solve_residual <- function(env = NULL) {
  ps <- if (is.null(env)) phi_second_stage else env$phi_second_stage
  mo <- if (is.null(env)) make_operator else env$make_operator
  cp <- if (is.null(env)) conditional_parts else env$conditional_parts
  orr <- if (is.null(env)) operator_residual else env$operator_residual
  fit <- with_fixed_seed(SEED_BOUNDARY,
    ps(y, xc$x1, xc$x2, Z, W_INST, theta0, cste = LF_CSTE,
       init_fn = init_control, xeval = xev, lf_imax = MBAR_INST,
       eps_rho = EPS_INST, n_t = N_T, bier_seed = BIER_SEED,
       t_scale = T_SCALE, adj_wtil = ADJ_WTIL, conditional = TRUE,
       tau_dp = TAU_DP, cells = CELLS_INST))
  parts <- with_fixed_seed(SEED_BOUNDARY,
    cp(Z, W_INST, TRUE, EPS_INST, N_T, BIER_SEED, T_SCALE, ADJ_WTIL,
       cells = CELLS_INST))
  res <- orr(fit$u, W_INST, rho = parts$rho, bier = parts$bier,
             adj_wtil = parts$adj_wtil)
  list(op = mo(xc$x1, xc$x2, xev), g = res$comperr, iter = fit$iter,
       u = fit$u, phi = as.vector(fit$phiev))
}

t0 <- Sys.time()
sr_new <- solve_residual(NULL)
sr_old <- solve_residual(LEG)
message(sprintf("  C. two second-stage solves in %.0fs (m = %d, %d)",
                as.numeric(difftime(Sys.time(), t0, units = "secs")),
                sr_new$iter, sr_old$iter))

d_same_new <- adjoint_range_defect(op_new, sr_new$g)
d_same_old <- adjoint_range_defect(op_old, sr_new$g)
d_own_new  <- d_same_new
d_own_old  <- adjoint_range_defect(op_old, sr_old$g)
panelC <- list(
  same_g = list(before = d_same_old, after = d_same_new),
  own_g  = list(before = d_own_old,  after = d_own_new))
stopifnot(abs(d_same_new$int_nu) < 1e-15 * max(1, d_same_new$scale))
message(sprintf(paste("     int_X nu-hat dx, SAME residual: %+.6e (%.2f%% of",
                      "sup|nu-hat|) -> %+.6e (%.2e%%)"),
                d_same_old$int_nu, 100 * d_same_old$rel,
                d_same_new$int_nu, 100 * d_same_new$rel))
message(sprintf(paste("     int_X nu-hat dx, OWN residual:  %+.6e (%.2f%%)",
                      "-> %+.6e (%.2e%%)"),
                d_own_old$int_nu, 100 * d_own_old$rel,
                d_own_new$int_nu, 100 * d_own_new$rel))

# ---- Panel D: the ablation -------------------------------------------------
#
# theta-hat and phi-hat at the headline configuration under both engines, on
# IDENTICAL partition streams.  This is what moved, and it is separated from the
# common-cap change of stage 8 by construction: both arms here run at MBAR_INST.
#
# ANCHOR is the one captured at the top of this file, before any solve consumed
# the stream; it is not re-read here.

#' phi-hat on the evaluation grid from a fit_orthogonal() return.
#'
#' @param f list. fit_orthogonal() output.
#' @return numeric, length(f$xeval), centred.
phi_of <- function(f) {
  M <- vapply(f$fits, function(b) {
    rowMeans(vapply(b$dev, function(pp) cumtrapz_centre(f$xeval, pp$dev),
                    numeric(length(f$xeval))))
  }, numeric(length(f$xeval)))
  p <- rowMeans(M)
  p - mean(p)
}

#' One ablation arm.
#'
#' @param env environment or NULL. NULL is the shipped engine.
#' @param label character. Printed tag.
#' @return named list: theta, se_cl, phi, prop_diag, lf_m_median, disc.
ablate <- function(env, label) {
  fo <- if (is.null(env)) fit_orthogonal else env$fit_orthogonal
  assign(".Random.seed", ANCHOR, envir = globalenv())
  tt <- Sys.time()
  f <- fo(y, xc$x1, xc$x2, Z, W_INST, dt$cluster, K = N_FOLDS,
          n_part = N_PART, cste = LF_CSTE, init_fn = init_control,
          lf_imax = MBAR_INST, lf_patience = MBAR_INST, rho = RHO,
          xeval = xev, n_cores = N_CORES, eps_rho = EPS_INST)
  message(sprintf("  D. %-22s %4.0fs   theta[2] = %+.5f   m-median %g",
                  label, as.numeric(difftime(Sys.time(), tt, units = "secs")),
                  f$theta[2], f$lf_m_median))
  list(theta = f$theta, se_cl = f$se_cl, se_iid = f$se_iid, phi = phi_of(f),
       prop_diag = f$prop_diag, lf_m_median = f$lf_m_median,
       lf_hit_cap = f$lf_hit_cap, disc = f$disc, coef_names = f$coef_names,
       xeval = f$xeval)
}

arm_old <- ablate(LEG, "no adjustment")
arm_new <- ablate(NULL, "boundary-adjusted")
stopifnot(identical(arm_old$coef_names, arm_new$coef_names))

panelD <- list(
  theta_before = arm_old$theta, theta_after = arm_new$theta,
  se_cl_before = arm_old$se_cl, se_cl_after = arm_new$se_cl,
  phi_before = arm_old$phi, phi_after = arm_new$phi, xeval = xev,
  max_d_theta = max(abs(arm_new$theta - arm_old$theta)),
  max_d_theta_in_se = max(abs(arm_new$theta - arm_old$theta) /
                            pmax(arm_old$se_cl, .Machine$double.eps)),
  max_d_se = max(abs(arm_new$se_cl - arm_old$se_cl)),
  phi_sup = max(abs(arm_new$phi - arm_old$phi)),
  phi_l2 = sqrt(mean((arm_new$phi - arm_old$phi)^2)),
  disc_before = mean(arm_old$disc), disc_after = mean(arm_new$disc),
  coef_names = arm_new$coef_names)
message(sprintf(paste("     max|dtheta| = %.5f (%.3f clustered se);",
                      "sup|dphi| = %.5f, L2 %.5f"),
                panelD$max_d_theta, panelD$max_d_theta_in_se,
                panelD$phi_sup, panelD$phi_l2))

# ---- Panel E: the isolation check ------------------------------------------
#
# WHAT THE CHANGE CANNOT REACH.  The propensity varrho-hat is a function of
# (W, Delta Z, fold indices) and of eps alone: fit_propensity_multi() never sees
# C_{h_x}, and the fold indices come from the RNG stream, which both arms share
# by construction (ANCHOR is restored before each).  So every propensity
# diagnostic must be identical to the LAST BIT.  A nonzero difference here would
# mean the change reached something it has no path to, and that would be a
# defect in the change rather than a finding about the estimator.

pd_o <- arm_old$prop_diag; pd_n <- arm_new$prop_diag
panelE <- list(
  bind_rate = c(before = pd_o$bind_rate, after = pd_n$bind_rate),
  n_bind = c(before = pd_o$n_bind, after = pd_n$n_bind),
  n_eval_total = c(before = pd_o$n_eval_total, after = pd_n$n_eval_total),
  min_pre = c(before = pd_o$min_pre, after = pd_n$min_pre),
  max_move = c(before = pd_o$max_move, after = pd_n$max_move),
  n_not_converged = c(before = pd_o$n_not_converged,
                      after = pd_n$n_not_converged),
  identical = identical(pd_o, pd_n))
if (!panelE$identical) {
  stop(paste("boundary: the propensity diagnostics MOVED between the two arms.",
             "The x-direction kernel has no path to the propensity, so this is",
             "a defect in the change, not a finding about the estimator."))
}
message("  E. isolation: propensity diagnostics bit-for-bit identical (PASS)")

## ---------------------------------------------------------------------------
## THE SCALE THE TWO SURVIVING ROWS ARE READ AGAINST.
##
## `bind_rate` and `min_pre` are identical across the ENGINES, which is what the
## panel is for, and they are NOT identical across cross-fitting FOLD DRAWS,
## which is what a reader comparing this table with the headline theta-hat table
## discovers without being told.  See the header block: the gap between the two
## shipped values is one anchor, verified rather than assumed.
##
## THIS IS EXACT, NOT A SIMULATION OF THE ESTIMATOR.  The propensity never sees
## the Landweber solve: crossfit_once() draws `folds`, then `op_idx` per fold,
## and calls fit_propensity_multi() twice per fold -- operator stage, fitted on
## op_idx and evaluated on sol_idx; moment stage, fitted on the fold complement
## and evaluated on the fold.  Its diagnostics are a deterministic function of
## those index sets, of (W, Delta Z) and of eps.  So the law of the pooled
## statistic is generated by drawing the same index sets from the same laws and
## running the same 10 propensity fits per partition, with no solve at all --
## the same arithmetic the estimator does, at a hundredth of the cost.
##
## WHAT IT IS AND IS NOT.  It is the sampling law of the diagnostic over the
## ESTIMATOR'S OWN randomisation, holding the sample fixed.  It is not a
## confidence statement about a population binding rate, and no coverage is
## claimed for the reported interval; it is a spread, printed so that a single
## draw is not read as a property of the design.
## ---------------------------------------------------------------------------

#' The pooled propensity diagnostics of one redraw of the partition structure.
#'
#' Mirrors crossfit_once()'s index construction exactly and stops there.
#'
#' @param stream the L'Ecuyer stream this redraw runs on.
#' @return named numeric: n_eval, n_bind, bind_rate, min_pre.
pd_reference_draw <- function(stream) {
  assign(".Random.seed", stream, envir = globalenv())
  ne <- 0; nb <- 0; mp <- Inf
  for (b in seq_len(N_PART)) {
    folds <- sample(rep_len(seq_len(N_FOLDS), n))
    for (k in seq_len(N_FOLDS)) {
      hold <- which(folds == k)
      rest <- which(folds != k)
      op_idx <- sample(rest, floor(length(rest) / 2))
      sol_idx <- setdiff(rest, op_idx)
      dd <- list(
        attr(fit_propensity_multi(W_INST, Z, op_idx, sol_idx, eps = EPS_INST,
                                  cells = CELLS_INST), "prop_diag"),
        attr(fit_propensity_multi(W_INST, Z, rest, hold, eps = EPS_INST,
                                  cells = CELLS_INST), "prop_diag"))
      for (d in dd) {
        ne <- ne + d$n_eval
        nb <- nb + d$n_bind_rows
        mp <- min(mp, d$min_pre)
      }
    }
  }
  c(n_eval = ne, n_bind = nb, bind_rate = nb / ne, min_pre = mp)
}

PD_STREAM <- ANCHOR
for (hop in seq_len(PD_STREAM_SKIP)) {
  PD_STREAM <- parallel::nextRNGStream(PD_STREAM)
}
assign(".Random.seed", PD_STREAM, envir = globalenv())
pd_streams <- make_streams(B_PDREF)
t0 <- Sys.time()
pd_got <- parallel::mclapply(seq_len(B_PDREF),
                             \(b) pd_reference_draw(pd_streams[[b]]),
                             mc.cores = N_CORES, mc.preschedule = FALSE)
pd_bad <- vapply(pd_got, \(z) inherits(z, "try-error") || length(z) != 4L,
                 logical(1))
if (any(pd_bad)) {
  stop(sprintf("boundary: %d of %d reference redraws failed", sum(pd_bad),
               B_PDREF))
}
pd_ref <- do.call(rbind, pd_got)
stopifnot(nrow(pd_ref) == B_PDREF, !anyNA(pd_ref),
          all(pd_ref[, "n_eval"] == pd_n$n_eval_total),
          all(is.finite(pd_ref[, "min_pre"])), all(pd_ref[, "min_pre"] > 0))
br <- 100 * pd_ref[, "bind_rate"]
mp <- pd_ref[, "min_pre"]
panelE$reference <- list(
  b_draws = B_PDREF, n_eval = pd_n$n_eval_total,
  bind_pct = br, min_pre = mp,
  bind_mean = mean(br), bind_sd = stats::sd(br),
  bind_q = stats::quantile(br, c(0.10, 0.50, 0.90)),
  bind_range = range(br),
  min_pre_median = stats::median(mp),
  min_pre_q = stats::quantile(mp, c(0.10, 0.90)),
  min_pre_range = range(mp),
  ## Where the two arms' shipped value sits in its own reference law.  A value
  ## in the body of the law is the finding; a value in its extreme tail would
  ## say the arms' draw is not a typical one and would need reporting as such.
  bind_pctile = 100 * mean(br <= 100 * pd_n$bind_rate),
  min_pre_pctile = 100 * mean(mp <= pd_n$min_pre))
message(sprintf(paste("  E. reference law over %d redraws of the folds (%.0fs):",
                      "binds mean %.4f%% sd %.4f, this draw at pct %.0f"),
                B_PDREF, as.numeric(difftime(Sys.time(), t0, units = "secs")),
                panelE$reference$bind_mean, panelE$reference$bind_sd,
                panelE$reference$bind_pctile))
message(sprintf(paste("     min pre-projection median %.3e, [10th, 90th]",
                      "%.3e -- %.3e, this draw at pct %.0f"),
                panelE$reference$min_pre_median,
                panelE$reference$min_pre_q[[1L]],
                panelE$reference$min_pre_q[[2L]],
                panelE$reference$min_pre_pctile))

# ---- LaTeX (INV-13: bare tabular, no float, no caption, no notes) ----------

pct <- function(x) fmt(100 * x, 2)
tex_body <- c(
    "\\multicolumn{3}{l}{\\textit{Panel A: the $j=0$ truncated moment of $C_{h_x}$ over $\\mathcal X$}} \\\\",
    sprintf("Minimum over design points & %s & %s \\\\",
            fmt(panelA$before$min, 4), fmt(panelA$after$min, 4)),
    sprintf("Worst departure from $1$ & %s & %s \\\\",
            fmt(panelA$before$worst, 4), fmt_sci(panelA$after$worst, 1L)),
    sprintf("Design points off by $>1\\%%$ (\\%%) & %s & %s \\\\",
            pct(panelA$before$share_1pct), pct(panelA$after$share_1pct)),
    sprintf("Design points off by $>10\\%%$ (\\%%) & %s & %s \\\\",
            pct(panelA$before$share_10pct), pct(panelA$after$share_10pct)),
    "\\\\[0.5em]",
    "\\multicolumn{3}{l}{\\textit{Panel B: the reference density}} \\\\",
    sprintf("$\\int_{\\mathcal X}\\hat\\pi\\,dx$ & %s & %s \\\\",
            fmt(panelB$before$total, 4), fmt(panelB$after$total, 4)),
    sprintf("$\\hat\\pi$ at the reported grid's ends & %s, %s & %s, %s \\\\",
            fmt(panelB$before$at_q05, 3), fmt(panelB$before$at_q95, 3),
            fmt(panelB$after$at_q05, 3), fmt(panelB$after$at_q95, 3)),
    "\\\\[0.5em]",
    ## NO \ref{} IN A FRAGMENT.  prp:hatAprop lives in the online supplement and
    ## this fragment is input by main.qmd, so a cross-reference here would
    ## compile to a bare "??" in the shipped paper.  The clause is named in
    ## words; the caption is the writer's place to cite it.
    "\\multicolumn{3}{l}{\\textit{Panel C: $\\int_{\\mathcal X}\\hat\\nu\\,dx$, the observable of ``the adjoint maps into $\\mathcal V$''}} \\\\",
    sprintf("At a common residual & %s & %s \\\\",
            fmt_sci(d_same_old$int_nu, 2L), fmt_sci(d_same_new$int_nu, 2L)),
    sprintf("\\quad as a share of $\\sup|\\hat\\nu|$ (\\%%) & %s & %s \\\\",
            pct(d_same_old$rel), fmt_sci(100 * d_same_new$rel, 1L)),
    sprintf("At each engine's own residual & %s & %s \\\\",
            fmt_sci(d_own_old$int_nu, 2L), fmt_sci(d_own_new$int_nu, 2L)),
    sprintf("\\quad as a share of $\\sup|\\hat\\nu|$ (\\%%) & %s & %s \\\\",
            pct(d_own_old$rel), fmt_sci(100 * d_own_new$rel, 1L)),
    "\\\\[0.5em]",
    ## THE PANEL D AND E HEADERS NAME THE PARTITION DRAW, and that is the repair
    ## of 2026-08-15.  "identical streams" said the two ARMS shared a draw, which
    ## is the pairing this ablation needs, and left unsaid the thing a reader
    ## comparing tables actually needs: WHOSE draw.  This ablation has its own,
    ## and the two rows of Panel E that depend on it now carry their own
    ## across-draw law directly beneath them.
    "\\multicolumn{3}{l}{\\textit{Panel D: what moves, at $d_Z=5$, $\\mathsf L=4$, both arms on one partition draw}} \\\\",
    sprintf("$\\max_j|\\hat\\theta_j|$ change & \\multicolumn{2}{c}{%s} \\\\",
            fmt(panelD$max_d_theta, 4)),
    sprintf("\\quad in clustered standard errors & \\multicolumn{2}{c}{%s} \\\\",
            fmt(panelD$max_d_theta_in_se, 3)),
    sprintf("$\\sup_x|\\hat\\varphi|$ change & \\multicolumn{2}{c}{%s} \\\\",
            fmt(panelD$phi_sup, 4)),
    sprintf("Mean relative balance & %s & %s \\\\",
            fmt_sci(panelD$disc_before, 2L), fmt_sci(panelD$disc_after, 2L)),
    "\\\\[0.5em]",
    "\\multicolumn{3}{l}{\\textit{Panel E: what cannot move, and does not, on this ablation's partition draw}} \\\\",
    sprintf("Truncation binds (\\%%) & %s & %s \\\\",
            fmt(100 * panelE$bind_rate[["before"]], 4),
            fmt(100 * panelE$bind_rate[["after"]], 4)),
    sprintf(paste("\\quad over $%d$ fold redraws: mean (sd) &",
                  "\\multicolumn{2}{c}{%s (%s)} \\\\"),
            panelE$reference$b_draws, fmt(panelE$reference$bind_mean, 4),
            fmt(panelE$reference$bind_sd, 4)),
    sprintf("Cross-fitted evaluations & %d & %d \\\\",
            as.integer(panelE$n_eval_total[["before"]]),
            as.integer(panelE$n_eval_total[["after"]])),
    sprintf("$\\min_l\\hat\\varrho_l$ pre-projection & %s & %s \\\\",
            fmt_sci(panelE$min_pre[["before"]], 1L),
            fmt_sci(panelE$min_pre[["after"]], 1L)),
    sprintf(paste("\\quad same redraws: median [10th, 90th] &",
                  "\\multicolumn{2}{c}{%s [%s, %s]} \\\\"),
            fmt_sci(panelE$reference$min_pre_median, 1L),
            fmt_sci(panelE$reference$min_pre_q[[1L]], 1L),
            fmt_sci(panelE$reference$min_pre_q[[2L]], 1L)))

## WRITE-TIME GUARDS.  The two reference rows exist to stop a single draw being
## read as a property of the design, so the fragment refuses to ship them empty,
## refuses to ship a reference law the arms' own draw falls outside, and refuses
## to ship the pair of engine columns unless they are still identical.
stopifnot(
  panelE$identical,
  identical(panelE$bind_rate[["before"]], panelE$bind_rate[["after"]]),
  identical(panelE$min_pre[["before"]], panelE$min_pre[["after"]]),
  panelE$reference$b_draws == B_PDREF,
  all(is.finite(c(panelE$reference$bind_mean, panelE$reference$bind_sd,
                  panelE$reference$min_pre_median, panelE$reference$min_pre_q))),
  panelE$reference$bind_sd > 0,
  sum(grepl("multicolumn\\{3\\}", tex_body)) == 5L,   # five panel headers
  !any(is.na(tex_body)), all(nzchar(tex_body)))

## WARNED, NOT ASSERTED.  An arms' draw outside the body of its own reference law
## is a FINDING about that draw, not a defect in this code, so it must be loud
## and it must not halt: at B_PDREF draws the extreme percentiles are estimated
## from a handful of them, and a stopifnot() here would be a run that fails a few
## times in a hundred thousand for a reason no reader could act on.
for (z in list(list(nm = "binding rate", p = panelE$reference$bind_pctile),
               list(nm = "min pre-projection",
                    p = panelE$reference$min_pre_pctile))) {
  if (z$p < 2.5 || z$p > 97.5) {
    warning(sprintf(paste("boundary: this ablation's %s sits at the %.1f",
                          "percentile of its own %d-redraw reference law --",
                          "an atypical partition draw, and the reported value",
                          "should be read as one."),
                    z$nm, z$p, B_PDREF), call. = FALSE, immediate. = TRUE)
  }
}
write_tabular(colspec = "lrr",
              header = c(" & No adjustment & Boundary-adjusted \\\\"),
              body = tex_body,
              path = file.path(TAB, "app_tsp_boundary.tex"))
message("wrote ", file.path(TAB, "app_tsp_boundary.tex"))

saveRDS(list(
  n = n, d_z = D_Z, L = length(CELLS_INST), eps = EPS_INST, mbar = MBAR_INST,
  seed = SEED_BOUNDARY, xsupp = XS, hx_full = op_new$hx, hx_fold = h_fold,
  panelA = panelA, panelB = panelB, panelC = panelC, panelD = panelD,
  panelE = panelE,
  solve_iter = c(before = sr_old$iter, after = sr_new$iter),
  phi_second_stage = list(before = sr_old$phi, after = sr_new$phi,
                          xeval = xev)),
  file.path(OUT, "app_tsp_boundary.rds"))
message("wrote ", file.path(OUT, "app_tsp_boundary.rds"))
