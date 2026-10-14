# ============================================================================
# app_tsp_common.R
#
# Shared configuration, data loader and estimation driver for Section 6, the
# hedonic TSP application of panel-npiv-discrete.
#
#   Delta Y = phi(X_2) - phi(X_1) + Delta Z' theta + Delta U,   Delta U _||_ W
#
# THIS FILE IS SOURCED, NOT RUN.  It sets no seed and writes no output.  The
# scripts that source it each set exactly one seed at their top (INV-14).  The
# module layout follows this repository's own precedent for a sourced driver
# library (scripts/simulations/sim_thm_rootn_dgp.R); the one-function-per-file
# rule of the coding standard is scoped to functions/ directories.
#
# ---------------------------------------------------------------------------
# WHAT THIS FILE DOES AND DOES NOT DO
#
# It APPLIES the estimator already implemented in scripts/R/lf_panel.R and
# scripts/R/orthogonal_theta.R.  It does not reimplement any part of it.  The
# one addition is a variance computation: orthogonal_theta() reports only the
# i.i.d. sandwich, and assignment here is cluster-level (see TUNING C9), so the
# driver below calls crossfit_once() -- the same function orthogonal_theta()
# calls, with the same arguments -- and accumulates a cluster-robust meat
# matrix alongside the i.i.d. one from the SAME psi and the SAME Jacobian.
# fit_orthogonal() reproduces orthogonal_theta()'s point estimate exactly when
# handed matching arguments; app_tsp_01_diagnostics.R asserts that it does.
# ============================================================================

# ---- Data mapping ----------------------------------------------------------

#' The 22 usable candidate controls, ordered by the ladder principle.
#'
#' Ordering principle (decision record section6-instrument-and-dz.md, item 2):
#' controls are ordered by how far they are from being OUTCOMES of house
#' prices, and rungs widen along that order.  The fiscal block is last because
#' per-capita property-tax revenue is mechanically a function of property
#' values, which is the object on the left-hand side.
#'
#' ExpPol is absent from every block: it is NaN in 989 of 989 rows.  The
#' candidate set is therefore 22, not the 23 columns the file carries.
CTRL_CORE <- c("PCIncome", "Population", "UnempRate", "EmpManufacturing",
               "HighSchool")
CTRL_DEMO <- c("College", "PopDens", "Urban", "Poverty", "White")
CTRL_WIDE <- c("Female", "Senior", "VacancyRate", "OwnerOccRate",
               "UnitsWOPlumbing", "PCGovRev", "PCPropTax", "PCGenExpLocalGov",
               "ExpEduc", "ExpHighways", "ExpWelf", "ExpHosp")
CTRL_ALL  <- c(CTRL_CORE, CTRL_DEMO, CTRL_WIDE)

#' The dead column: 989/989 missing, dropped rather than carried.
CTRL_DEAD <- "ExpPol"

#' The ladder rungs, by number of non-degenerate Delta Z coordinates.
LADDER_DZ <- c(0L, 5L, 10L, 22L)

#' Human-readable labels for the coefficients that appear in tables.
COEF_LABELS <- c(
  const            = "Constant",
  PCIncome         = "Per capita income",
  Population       = "Population",
  UnempRate        = "Unemployment rate",
  EmpManufacturing = "Manufacturing employment",
  HighSchool       = "High school",
  College          = "College",
  PopDens          = "Population density",
  Urban            = "Urban share",
  Poverty          = "Poverty rate",
  White            = "White share"
)

# ---- Tuning constants ------------------------------------------------------
#
# EVERY constant the application sets is here, with its provenance.  None is
# chosen by looking at theta-hat.
#
# C1  SEED           -- arbitrary, fixed once per script (INV-14).
# C2  X coordinate   -- pooled empirical CDF of {x1, x2} onto [0,1].  In
#                       ug/m^3 the composite operator's SQUARED norm is 5.7e4
#                       (app_tsp_07_opnorm.R; app_tsp_opnorm.tex), so Landweber
#                       converges only below 2/||A||^2 = 3.5e-5 and lf_panel.R's
#                       default step 0.5 exceeds that by a factor of 1.4e4.
#                       In the rank coordinate the same norm is 2.48, the bound
#                       is 0.81, and the default step sits INSIDE it.
#                       RESTATED 2026-08-08 against the conditional operator,
#                       which is the one the estimator now iterates; the earlier
#                       figures normed the ported one and were therefore a norm
#                       for a strictly smaller map.  On the way this entry has
#                       been wrong twice and in opposite directions, so the
#                       history is kept rather than tidied: rounds 1-8 said the
#                       norm was 3.3e4 and the iteration "diverges after a single
#                       step", with no output file behind either number; the
#                       2026-08-05 correction measured 5.8e3 and a discrepancy
#                       that FELL on step one (0.0812 -> 0.0326).  Under the
#                       corrected engine the shipped path is 0.0791 -> 0.1991 ->
#                       0.1991: it RISES on step one and then flattens, so the
#                       original "diverges immediately" reading turns out to be
#                       the closer of the two -- for a reason neither version
#                       had, since neither was norming the right operator.
#                       What the forbidden step produces is max|d-phi-hat| =
#                       0.646 against 0.077 in the rank coordinate.  Every one
#                       of these numbers is now in app_tsp_opnorm.rds.
#                       The transform is strictly increasing, so phi o T^{-1}
#                       is the structural function in the new coordinate and
#                       theta_dagger is unchanged.  It also realises
#                       pi = Uniform[0,1], the reference measure of the
#                       theory's own design decision D7, by construction.
# C3  LF_CSTE        -- NULL, i.e. the step is set from the operator norm by
#                       power iteration inside lf_solve().  lf_panel.R:397-398
#                       recommends exactly this ("cste = NULL sets the step
#                       from the operator norm (recommended)").
# C4  LF_IMAX        -- 2000.  Cap hits are COUNTED AND REPORTED, not tuned
#                       away, and the count is the point: the pilot figure this
#                       entry used to quote ("longest argmin observed was 1089")
#                       was FALSIFIED by the 2026-08-06 regeneration, where the
#                       median stopping index was 2000 at every rung.  It is
#                       restated here as a diagnostic, not a justification: 2000
#                       is a budget, the estimator does not reliably semiconverge
#                       within it at this sample size, and app_tsp_estimator_diag
#                       .tex reports how often it fails to.
# C5  LF_PATIENCE    -- 100.  The discrepancy path is monotone down to its
#                       argmin in every pilot fold that semiconverged, so 100
#                       is well past any local flat stretch.  Note
#                       orthogonal_theta() does not expose this argument and
#                       leaves it at lf_solve()'s default of 30; the driver
#                       below exposes it, and 30 is run as a robustness arm.
# C6  N_FOLDS        -- 5, orthogonal_theta()'s default.  F = 2, the value
#                       def:crossfit names, is run as a robustness arm.
# C7  N_PART         -- 10 for the ladder, 6 for robustness.  Raised above
#                       orthogonal_theta()'s default of 5 because the pilot
#                       showed cross-fitting noise of the same order as the
#                       sampling standard error; the two components are
#                       reported separately rather than merged.
# C8  RHO            -- 1e-3, orthogonal_theta()'s default RKHS ridge.  Swept
#                       over {1e-4, 1e-3, 1e-2} as a robustness arm.
# C9  CLUSTER        -- StateCode.  A0 assumes i.i.d.; designation was made at
#                       AQCR level and AQCR is not a column of this file.
#                       State is the coarsest identifier available and most
#                       AQCRs are within-state.  Both i.i.d. and clustered
#                       standard errors are reported side by side.
# C10 XEVAL          -- 5th to 95th percentile of the pooled X, 60 points.
#                       This is crossfit_once()'s own default, restated so the
#                       grid is visible rather than implicit.
# C11 MU, R_SMOOTH   -- (2, 8/3), the "frontier-clearing configuration" named
#                       at proofs.tex rem:h6bandwidth(5) and used by the
#                       project's Monte Carlo.  Used ONLY to evaluate where
#                       this application sits relative to the frontier; it is
#                       not an input to any estimate.
# C12 N_PERM         -- 2000 permutation draws for the within-stratum
#                       independence probe.  Gives a Monte Carlo standard
#                       error of at most 0.011 on a p-value.
# C14 N_BOOT         -- 99 bootstrap replications for the phi-hat variability
#                       band.  This is the count Centorrino, Feve and Florens
#                       (2025, J. Econometrics, Figure 4) used for the same
#                       estimator on the same equation, and this application
#                       follows that paper's convention exactly: the band
#                       ILLUSTRATES variability and is NOT a confidence set.
#                       See the header of app_tsp_05_phi_band.R for why no
#                       valid uniform set exists for this estimator.
# C15 BAND_PROBS     -- (0.05, 0.25, 0.75, 0.95).  Two nested pointwise
#                       envelopes.  Percentiles rather than +/- k SD because a
#                       handful of replications are wild (see C4) and a moment
#                       based envelope would be driven by them.
# C16 TAB_PROBS      -- deciles of the POOLED X distribution, plus the 5th and
#                       95th percentiles which are the endpoints of the
#                       reported grid (C10).  Deciles rather than round
#                       mu-g/m^3 values because the estimator's working
#                       coordinate IS the pooled CDF (C2), so deciles are
#                       equally spaced in the coordinate the operator uses and
#                       in the theory's reference measure pi = Unif[0,1].
# C17 SUPPORT_WINDOW -- +/- 5 mu-g/m^3.  The window over which counties are
#                       counted at each tabulated level, so that the thinness
#                       of the tails is a number in the table rather than a
#                       visual impression from the rug.
# C18 SEED_PHIMULT   -- the multiplier-bootstrap stage's seed, DELIBERATELY
#                       DIFFERENT from SEED_PHIBAND so that design M and design
#                       C0 are independent draws rather than the same counties
#                       seen through two schemes.  The two designs are compared
#                       as whole distributions (99 replications each), not
#                       replication by replication, so nothing is lost by not
#                       pairing them and independence is the honest default.
# C19 MULT_RATE      -- 1.  The multiplier weights are i.i.d. Exp(1), the
#                       standard wild/Bayesian-bootstrap choice: mean 1,
#                       variance 1, so the weighted empirical measure has the
#                       same first two moments as the multinomial weights of a
#                       pairs bootstrap, and the schemes differ only in that
#                       Exp(1) perturbs MASS while the multinomial perturbs
#                       SUPPORT.  Weights are drawn once per COUNTY (both
#                       periods share one weight) because the county is the
#                       unit A0 treats as i.i.d.  Normalised to mean one; the
#                       weighted layer is exactly scale-invariant, which
#                       app_tsp_weighted.R's verification demonstrates rather
#                       than assumes.
# C20 N_MAP          -- 25 replications for the side-arm that rebuilds the
#                       coordinate map (C2) under the weights.  Bounds the cost
#                       of holding the map at its full-sample value in the
#                       reported multiplier band, exactly as design F bounds
#                       the cost of holding theta at theta-hat in C0.
#
# ---- the conditional model's five constants (registered 2026-08-07) --------
# These reached the application as crossfit_once() / phi_second_stage()
# DEFAULTS when the engine was corrected on 2026-08-05..07, so for two days the
# application set them without this file naming them.  They are set explicitly
# below so that the fingerprint sees them and so that C21-C25 is the only place
# they are chosen.
#
# C21 N_T            -- 16 points in the Bierens t-grid.  B1(iv) asks only that
#                       Pi_t have a nonzero absolutely continuous part, so the
#                       grid is a choice, not a derived quantity.  16 rather
#                       than 32 on evidence from sim_bierens_validate.R, where
#                       32 bought nothing (phi ISE 0.395 vs 0.409 at n = 1600).
# C22 T_SCALE        -- 0.25, the sd of the t-draws.  Chosen on the same sweep:
#                       phi ISE 0.346 at 0.25 against 0.409 at 0.50 and 2.08 at
#                       1.00.  NOTE THE EXTRAPOLATION: it was selected at
#                       d_Z = 2 and is applied here at d_Z up to 22, where
#                       |t' arctan(z)| has roughly three times the spread.
#                       app_tsp_07_opnorm.R reports the realised spread of
#                       w(t' Phi) so the extrapolation is visible.
# C23 ADJ_WTIL       -- TRUE.  Puts the Wtilde_j factor in the adjoint where
#                       lem:adjoint(i) puts it.  Not tunable: FALSE is the
#                       PORTED engine, which solves a different model.
# C24 EPS_RHO        -- 0.03.  varrho-hat is truncated into [0.03, 0.97].  This
#                       is substantive, not cosmetic: it caps |Wtilde|/(wbar
#                       (1-wbar)), which is the multiplier the Landweber step
#                       carries, and so it bounds the step the operator norm
#                       has to absorb.  A0's overlap condition is what makes
#                       truncation harmless; app_tsp_overlap.tex reports how
#                       often it binds.
# C25 BIER_SEED      -- 20260805.  The t-grid is drawn once and FIXED, so it is
#                       part of the specification rather than a source of
#                       run-to-run variation.  A deterministic lattice would be
#                       exponential in d_Z; a fresh draw per call would put
#                       randomness inside the estimator.
# C26 TAU_DP         -- 0.7, the discrepancy-principle constant.  The stopping
#                       rule is A7's: stop at the first m with
#                       ||T-hat_m||_{L^2(Pi)} <= TAU_DP * delta-hat_n, cap when
#                       that set is empty.  Until 2026-08-07 lf_solve() used
#                       argmin-plus-patience, which is a DIFFERENT rule; it only
#                       looked like a stopping rule because the step it was
#                       paired with was not a descent direction.  That is what
#                       pinned the median stopping index at LF_IMAX in every arm.
#                       delta-hat_n is computed (the L^2(Pi) sampling sd of
#                       T-hat); TAU_DP is CALIBRATED, like C22, and A7's ln n is
#                       not used as a numerical multiplier -- it is the device
#                       that buys "with probability approaching one", and taken
#                       literally it stops at m = 1 everywhere.  Evidence, from
#                       tracing ISE(phi_m) along the full path: the oracle stop
#                       sits at m ~ 12 and ||T-hat_m||/delta-hat_n there has
#                       median 0.63 at n = 400 and 0.76 at n = 800.  At n = 400
#                       phi ISE is 0.023 at the oracle, 0.069 at the cap and
#                       0.134 at m = 1.

SEED_DIAG    <- 20260802L
SEED_LADDER  <- 20260803L
SEED_ROBUST  <- 20260804L
SEED_PHIBAND <- 20260806L
SEED_PHIMULT <- 20260807L
SEED_OPNORM  <- 20260808L
# Registered 2026-08-11 at the value app_tsp_08_localise.R already used inline,
# so nothing moves.  It was the one stage seed living outside this block, which
# is what the block's own opening sentence forbids.
SEED_LOCALISE <- 20260810L

# EPS_LOCALISE is NOT EPS_RHO, and the difference is a measured property of the
# four-category design rather than a taste.  A4(i) needs eps_varrho < 1/L and the
# multinomial propensity's realised minimum on this panel is 0.0115 (one county,
# in the 66-observation cell), so truncating at EPS_RHO = 0.03 would bind on real
# observations and move the fit; 0.0115 truncates at the realised floor.
# 1/L = 0.25 at L = 4, so the truncation set is non-empty with room.
#
# CORRECTED 2026-08-11, AND THE PREMISE WAS MEASURED ON THE WRONG OBJECT.  This
# entry used to close "and binds on none".  0.0115 is the minimum of the
# propensity fitted IN SAMPLE, on all n at once.  THE ESTIMATOR DOES NOT USE
# THAT OBJECT: def:crossfit(a) fits varrho-hat on the complement of each fold
# and evaluates it on the fold, and the CROSS-FITTED minimum over the ten
# partitions is 4.29e-05 -- two orders of magnitude lower.  Measured binding
# rates over the 29,500 cross-fitted propensity evaluations of one
# fit_orthogonal() run at d_Z = 5 (app_tsp_localise.rds, theta_by_eps):
#
#             eps = 0.03      eps = 0.0115
#   L = 4       12.49%           1.29%
#   L = 2        0.003%          0.000%
#
# So 0.0115 does NOT bind on none; it binds an order of magnitude less often
# than 0.03 does, and both bind roughly 400x and 3700x more often at L = 4 than
# at L = 2.  The asymmetry is the four-category design's, not the constant's.
#
# NOTE ALSO THAT C24's JUSTIFICATION FOR EPS_RHO DOES NOT TRANSFER TO L >= 3.
# C24 argues 0.03 caps |Wtilde| / (wbar(1 - wbar)), the multiplier the Landweber
# step carries.  operator_residual() sets scal = 1 at L >= 3 (see its own
# "IT STOPS CANCELLING AT L >= 3 IF PORTED CELLWISE" note), so at L >= 3 eps
# caps no multiplier: Wtilde is bounded in [-1, 1] whatever eps is.  What eps
# does at L >= 3 is move varrho-hat, which is a cost and not a benefit.
EPS_LOCALISE <- 0.0115
# Reference draws for the per-cell null.  The resolution floor of the resulting
# p-value is 1/(B_LOCALISE + 1) -- see fmt_p().
#
# RAISED FROM 400 TO 2000 ON 2026-08-11, matching N_PERM, because at 400 the
# statistic was FLOOR-CENSORED and the censoring was being read as a result.
# Both chronic cells returned exactly 1/401 = 0.00249 -- i.e. NO null draw
# reached the observed norm -- and Section 6.3 printed those as two distinct
# values, "p = 0.005" and "p = 0.003", and then read a monotone ordering off
# them.  There is no ordering to read at the floor.  At 2000 the floor is
# 0.0005 and the reference costs about a minute per t-grid.
B_LOCALISE   <- 2000L

LF_CSTE     <- NULL
LF_IMAX     <- 2000L
N_T         <- 16L
T_SCALE     <- 0.25
ADJ_WTIL    <- TRUE
EPS_RHO     <- 0.03
BIER_SEED   <- 20260805L
TAU_DP      <- 0.7
LF_PATIENCE <- 100L
N_FOLDS     <- 5L
N_PART      <- 10L
N_PART_ROB  <- 6L
RHO         <- 1e-3
N_XEVAL     <- 60L
XEVAL_LO    <- 0.05
XEVAL_HI    <- 0.95
MU_FRONTIER <- 2
R_FRONTIER  <- 8 / 3
N_PERM      <- 2000L
N_CORES     <- 8L
N_BOOT      <- 99L
MULT_RATE   <- 1
N_MAP       <- 25L
BAND_PROBS  <- c(0.05, 0.25, 0.75, 0.95)
TAB_PROBS   <- c(0.05, seq(0.10, 0.90, by = 0.10), 0.95)
SUPPORT_WINDOW <- 5

# ---- Data ------------------------------------------------------------------

#' Load and prepare the Chay-Greenstone county panel.
#'
#' Every sample restriction is counted and returned so the drop table is a
#' computed object rather than a claim in prose.
#'
#' @param path character. Path to the whitespace-delimited raw file.
#' @return named list: dt (data.frame, analysis sample), raw (data.frame),
#'   drops (data.frame of restriction counts), difftsp_max_dev (numeric).
load_tsp_panel <- function(path = here::here("data", "raw", "data_tsp.txt")) {
  raw <- utils::read.table(path, header = TRUE)
  n_raw <- nrow(raw)

  # Verification, not assumption: establish what DiffTSP is before deciding
  # whether to use it.  It is (MTSP1980 - MTSP1970)/100 -- Delta X in units of
  # 100 ug/m^3 -- so it is redundant and is not used; Delta X is rebuilt from
  # the two level series instead, which keeps the units explicit.
  difftsp_max_dev <- max(abs(raw[["DiffTSP"]] -
                               (raw[["MTSP1980"]] - raw[["MTSP1970"]]) / 100))

  dead_na <- sum(is.na(raw[[CTRL_DEAD]]))
  keep <- stats::complete.cases(raw[, CTRL_ALL, drop = FALSE])
  dt <- raw[keep, , drop = FALSE]
  dt[[CTRL_DEAD]] <- NULL
  rownames(dt) <- NULL

  dt[["dy"]]      <- dt[["LogPropValue"]]
  dt[["x1_raw"]]  <- dt[["MTSP1970"]]
  dt[["x2_raw"]]  <- dt[["MTSP1980"]]
  dt[["dx_ugm3"]] <- dt[["MTSP1980"]] - dt[["MTSP1970"]]
  dt[["w"]]       <- dt[["CATT"]]
  dt[["cluster"]] <- dt[["StateCode"]]

  drops <- data.frame(
    step = c("Raw rows in data_tsp.txt",
             sprintf("Drop column %s (NaN in %d of %d rows)",
                     CTRL_DEAD, dead_na, n_raw),
             "Drop counties missing the local-fiscal block",
             "Analysis sample"),
    n_dropped = c(NA_integer_, 0L, n_raw - nrow(dt), NA_integer_),
    n_left = c(n_raw, n_raw, nrow(dt), nrow(dt)),
    stringsAsFactors = FALSE
  )

  list(dt = dt, raw = raw, drops = drops, difftsp_max_dev = difftsp_max_dev,
       n_raw = n_raw, dead_na = dead_na)
}

#' Map X to [0,1] by the pooled empirical CDF (tuning constant C2).
#'
#' @param x1,x2 numeric. Period-1 and period-2 values in native units.
#' @return named list: x1, x2 (transformed), fwd (function), inv (function).
make_x_coord <- function(x1, x2, mode = c("rank", "ugm3", "minmax")) {
  mode <- match.arg(mode)
  pooled <- c(x1, x2)
  if (mode == "ugm3") {
    return(list(x1 = x1, x2 = x2, mode = mode,
                fwd = \(x) x, inv = \(u) u))
  }
  if (mode == "minmax") {
    lo <- min(pooled)
    rg <- diff(range(pooled))
    return(list(x1 = (x1 - lo) / rg, x2 = (x2 - lo) / rg, mode = mode,
                fwd = \(x) (x - lo) / rg, inv = \(u) lo + rg * u))
  }
  fwd <- stats::ecdf(pooled)
  # Inverse by linear interpolation on the sorted pooled support; used only to
  # put the phi-hat figure back on the ug/m^3 axis.  Ties in the pooled support
  # are collapsed first, because approxfun() would otherwise do it with a
  # warning and an unspecified tie rule.
  sup <- sort(unique(pooled))
  inv <- stats::approxfun(fwd(sup), sup, rule = 2)
  list(x1 = fwd(x1), x2 = fwd(x2), mode = mode, fwd = fwd, inv = inv)
}

#' Build the Delta Z design matrix for a ladder rung.
#'
#' @param dt data.frame. Analysis sample.
#' @param d_z integer. Number of non-degenerate Delta Z coordinates.
#' @return numeric matrix with an intercept in column 1 (p = d_z + 1).
make_design <- function(dt, d_z) {
  stopifnot(d_z >= 0L, d_z <= length(CTRL_ALL))
  if (d_z == 0L) {
    return(matrix(1, nrow(dt), 1L, dimnames = list(NULL, "const")))
  }
  cbind(const = 1, as.matrix(dt[, CTRL_ALL[seq_len(d_z)], drop = FALSE]))
}

#' The initial condition a rung admits.
#'
#' init_control() and init_robinson() partial Delta Z out of the outcome by
#' regressing on Z[, -1]; at d_Z = 0 that matrix has zero columns and lm.fit()
#' fails with "0 (non-NA) cases".  init_poly() does not touch Z[, -1] and is
#' the only one of the three defined there.  The substitution is returned so
#' that it is reported rather than silently applied.
init_for_rung <- function(d_z, preferred = init_control) {
  if (d_z == 0L) list(fn = init_poly, name = "init_poly", substituted = TRUE)
  else list(fn = preferred,
            name = deparse(substitute(preferred)), substituted = FALSE)
}

# ---- Feasibility frontier --------------------------------------------------

#' Source-condition factor kappa = 2 mu / (2 mu + 1).
frontier_kappa <- function(mu) 2 * mu / (2 * mu + 1)

#' Propensity rate exponent alpha = r / (2r + d_Z), A4(iii).
frontier_alpha <- function(r, d_z) r / (2 * r + d_z)

#' delta-hat_n, A5(i): the MAXIMUM of two branches, not the propensity one alone.
#'
#' A5(i) (assumptions.tex, A5(i)) reads
#'     delta-hat_n = max{ delta-hat_n^(T) , delta-hat_n^(rho) },
#'         delta-hat_n^(T)   = O_P( n^{-1/2} sqrt(log n) )   -- PARAMETRIC FLOOR
#'         delta-hat_n^(rho) = n^{-alpha}                    -- propensity branch
#' and closes "in every configuration of interest delta-hat_n = delta-hat_n^(rho)".
#'
#' THAT CLOSING SENTENCE IS ASYMPTOTIC, AND THIS FILE READ IT AS AN IDENTITY AT
#' EVERY n.  Corrected 2026-08-03.  It is not a harmless simplification here:
#' the branches cross at alpha = 0.397 at n = 181,019 and at alpha ~ 0.5 the
#' parametric branch dominates at ANY sample size, because sqrt(log n) > 1.
#'
#' WHAT IT CHANGED IN THE SHIPPED TABLE, stated because a printed number moved.
#' At n = 983 the ladder's d_Z = 0 rung has alpha = 1/2, so the floor binds:
#'     propensity branch 0.0319  vs  parametric branch 0.0837
#' and that row of app_tsp_feasibility.tex moves
#'     delta_n   0.298 -> 0.644        sqrt(n) delta_n^2   2.8 -> 13.0
#' The other three rungs (d_Z = 5, 10, 22) have alpha < 0.4 and DO NOT MOVE.
#' The correction makes the application sit FURTHER outside the frontier, which
#' is the direction Section 6 already argues.
#'
#' The same defect was fixed the same day at scripts/simulations/
#' sim_thm_rootn_dgp.R:178, where it provably changed nothing (138/138 rate
#' values bit-identical) because that design runs at alpha = 0.32.
rate_delta_hat <- function(n, r, d_z) {
  pmax(n^(-0.5) * sqrt(log(n)),          # parametric floor, delta-hat^(T)
       n^(-frontier_alpha(r, d_z)))      # propensity branch, delta-hat^(rho)
}

#' delta_n = (delta-hat_n ln n)^kappa, A5(ii) as amended (eq:deltalog).
rate_delta_n <- function(n, mu, r, d_z) {
  (rate_delta_hat(n, r, d_z) * log(n))^frontier_kappa(mu)
}

#' Leading remainder budget sqrt(n) delta_n^2.  The theorem needs this o(1).
budget_sqrtn_delta2 <- function(n, mu, r, d_z) {
  sqrt(n) * rate_delta_n(n, mu, r, d_z)^2
}

#' Smoothness of varrho required to clear the frontier kappa * alpha > 1/4.
#'
#' Solving (2 mu / (2 mu + 1)) * r / (2r + d_Z) > 1/4 for r gives
#' r > d_Z / (4 kappa - 2), finite only when kappa > 1/2, i.e. mu > 1/2.
#' Returns 0 at d_Z = 0 (the condition holds for every r) and Inf when the
#' source index is too small for any r to clear it.
frontier_r_required <- function(mu, d_z) {
  den <- 4 * frontier_kappa(mu) - 2
  if (den <= 0) return(Inf)
  d_z / den
}

# ---- Estimation driver -----------------------------------------------------

#' Evaluate an expression under a fixed seed, restoring the caller's RNG state.
#'
#' INV-14 EXCEPTION, and the same one this project already grants itself in
#' scripts/simulations/sim_thm_rootn_dgp.R.  Each script here calls set.seed()
#' exactly once, at its top.  The single exception is a validation call that
#' must reproduce a seed chosen inside orthogonal_theta(), which sets its own.
#' The caller's stream is saved and restored, so the script draws exactly what
#' it would have drawn had this helper never run.
with_fixed_seed <- function(seed, expr) {
  had <- exists(".Random.seed", envir = globalenv())
  old <- if (had) get(".Random.seed", envir = globalenv()) else NULL
  set.seed(seed)
  on.exit({
    if (had) assign(".Random.seed", old, envir = globalenv())
    else if (exists(".Random.seed", envir = globalenv()))
      rm(".Random.seed", envir = globalenv())
  }, add = TRUE)
  force(expr)
}

#' Deterministic L'Ecuyer streams, one per parallel job.
#'
#' Core-count independent by construction: job j always receives the j-th
#' stream in a chain started from the caller's single seed.  mclapply's own
#' stream assignment depends on mc.cores when mc.preschedule = TRUE, which
#' would make every number in every table a function of the host.
make_streams <- function(n_jobs) {
  out <- vector("list", n_jobs)
  s <- get(".Random.seed", envir = globalenv())
  for (j in seq_len(n_jobs)) {
    s <- parallel::nextRNGStream(s)
    out[[j]] <- s
  }
  out
}

#' Cluster-robust meat matrix for the orthogonal moment.
#'
#' @param psi numeric matrix n x p. Moment contributions.
#' @param g integer vector length n. Cluster identifier.
#' @return p x p matrix, the clustered meat with the usual G/(G-1) correction.
cluster_meat <- function(psi, g) {
  n <- nrow(psi)
  p <- ncol(psi)
  gl <- unique(g)
  ng <- length(gl)
  agg <- matrix(0, ng, p)                                            # INV-17
  for (j in seq_len(ng)) {
    agg[j, ] <- colSums(psi[g == gl[j], , drop = FALSE])
  }
  cf <- (ng / (ng - 1)) * ((n - 1) / (n - p))
  cf * crossprod(agg) / n
}

#' One cross-fitting partition: point estimate, both variances, diagnostics.
#'
#' Mirrors the body of orthogonal_theta()'s partition loop exactly -- plug-in
#' start, one Newton step on the orthogonal moment, sandwich at the updated
#' theta -- and adds the clustered meat and the per-fold LF record.
#'
#' @param y,x1,x2,Z,w model objects; Z has the intercept in column 1.
#' @param cluster integer vector. Cluster identifier, length n.
#' @param eps_rho numeric. A4(i)'s eps_varrho, the eq:trunset truncation level.
#'   DEFAULTS TO EPS_RHO, so every caller written before 2026-08-11 is unchanged.
#' @param ... tuning constants, see the block above.
#' @return named list with theta, V_iid, V_cl, J, kappa_J, disc, lf, prop_diag.
fit_one_partition <- function(y, x1, x2, Z, w, cluster, K, cste, init_fn,
                              lf_imax, lf_patience, rho, xeval,
                              eps_rho = EPS_RHO) {
  n <- length(y)
  ## ------------------------------------------------------------------------
  ## eps_rho IS AN ARGUMENT, AND IT WAS A HARDCODED CONSTANT UNTIL 2026-08-11.
  ##
  ## This line read `eps_rho = EPS_RHO`, i.e. 0.03, with no way for a caller to
  ## say otherwise -- fit_orthogonal() had no eps parameter to pass down even if
  ## it had wanted to.  app_tsp_08_localise.R set EPS <- EPS_LOCALISE = 0.0115,
  ## printed "eps_rho = 0.0115" directly above its theta-hat table, and used
  ## 0.0115 for the propensity, the theory diagnostics and the localisation
  ## cross-fit -- while BOTH ARMS OF THE PRINTED theta-hat RAN AT 0.03.  The
  ## configuration was not merely unset; it was INEXPRESSIBLE.
  ## ------------------------------------------------------------------------
  ## C21-C25 passed EXPLICITLY rather than inherited as engine defaults, so
  ## that the application's constants live in this file and the fingerprint
  ## sees them.
  cf <- crossfit_once(y, x1, x2, Z, w, K = K, cste = cste, xeval = xeval,
                      init_fn = init_fn, lf_imax = lf_imax,
                      lf_patience = lf_patience, rho = rho,
                      eps_rho = eps_rho, n_t = N_T, bier_seed = BIER_SEED,
                      t_scale = T_SCALE, adj_wtil = ADJ_WTIL, tau_dp = TAU_DP,
                      conditional = TRUE, verbose = FALSE)

  th0 <- stats::lm.fit(Z, y - cf$dphi)$coefficients
  th0[!is.finite(th0)] <- 0
  m0 <- cf$eval_moment(th0)
  J0i <- tryCatch(solve(m0$J), error = \(e) MASS::ginv(m0$J))
  th1 <- as.vector(th0 - J0i %*% colMeans(m0$psi))

  m1 <- cf$eval_moment(th1)
  J1i <- tryCatch(solve(m1$J), error = \(e) MASS::ginv(m1$J))
  V_iid <- J1i %*% (crossprod(m1$psi) / n) %*% t(J1i) / n
  V_cl  <- J1i %*% cluster_meat(m1$psi, cluster) %*% t(J1i) / n

  lf <- data.frame(
    fold    = seq_len(K),
    argmin  = vapply(cf$lf_info, \(z) as.integer(z$iter), integer(1)),
    stopped = vapply(cf$lf_info, \(z) as.integer(z$stopped), integer(1)),
    hit_cap = vapply(cf$lf_info, \(z) isTRUE(z$hit_cap), logical(1)),
    stringsAsFactors = FALSE
  )

  list(theta = th1, theta_plugin = as.vector(th0), V_iid = V_iid, V_cl = V_cl,
       J = m1$J, kappa_J = kappa(m1$J, exact = TRUE), disc = cf$disc,
       lf = lf, dphi = cf$dphi, u = m1$u, dev = cf$phi_paths, xeval = cf$xeval,
       eps_rho = eps_rho, prop_diag = cf$prop_diag)
}

#' The estimator: median over independent cross-fitting partitions.
#'
#' Aggregation follows orthogonal_theta(): coordinatewise median of the
#' partition estimates, coordinatewise median of the sandwich, and an added
#' across-partition variance term spread/n_part.  The two components are
#' returned separately as well as combined, because at this sample size they
#' are of the same order and merging them hides that.
#'
#' @return named list; see the field names below.
fit_orthogonal <- function(y, x1, x2, Z, w, cluster,
                           K = N_FOLDS, n_part = N_PART, cste = LF_CSTE,
                           init_fn = init_control, lf_imax = LF_IMAX,
                           lf_patience = LF_PATIENCE, rho = RHO,
                           xeval = NULL, n_cores = 1L, eps_rho = EPS_RHO) {
  n <- length(y)
  p <- ncol(Z)
  if (is.null(xeval)) {
    xeval <- seq(stats::quantile(c(x1, x2), XEVAL_LO),
                 stats::quantile(c(x1, x2), XEVAL_HI), length.out = N_XEVAL)
  }
  streams <- make_streams(n_part)

  one <- function(b) {
    assign(".Random.seed", streams[[b]], envir = globalenv())
    fit_one_partition(y, x1, x2, Z, w, cluster, K, cste, init_fn,
                      lf_imax, lf_patience, rho, xeval, eps_rho = eps_rho)
  }
  res <- if (n_cores > 1L) {
    parallel::mclapply(seq_len(n_part), one, mc.cores = n_cores,
                       mc.preschedule = FALSE)
  } else {
    lapply(seq_len(n_part), one)
  }
  bad <- vapply(res, \(z) inherits(z, "try-error") || is.null(z$theta),
                logical(1))
  if (any(bad)) {
    stop(sprintf("fit_orthogonal: %d of %d partitions failed", sum(bad),
                 n_part))
  }

  th <- matrix(NA_real_, n_part, p)                                  # INV-17
  Vi <- array(NA_real_, c(n_part, p, p))
  Vc <- array(NA_real_, c(n_part, p, p))
  kap <- numeric(n_part)
  dsc <- matrix(NA_real_, n_part, p)
  for (b in seq_len(n_part)) {
    th[b, ] <- res[[b]]$theta
    Vi[b, , ] <- res[[b]]$V_iid
    Vc[b, , ] <- res[[b]]$V_cl
    kap[b] <- res[[b]]$kappa_J
    dsc[b, ] <- res[[b]]$disc
  }
  lf <- do.call(rbind, Map(\(z, b) cbind(partition = b, z$lf), res,
                           seq_len(n_part)))

  theta <- apply(th, 2, stats::median)
  Vi_bar <- apply(Vi, c(2, 3), stats::median)
  Vc_bar <- apply(Vc, c(2, 3), stats::median)
  spread <- if (n_part > 1L) apply(th, 2, stats::var) else rep(0, p)
  se_samp_iid <- sqrt(pmax(diag(Vi_bar), 0))
  se_samp_cl  <- sqrt(pmax(diag(Vc_bar), 0))
  se_cf <- sqrt(spread / n_part)

  list(theta = theta,
       se_iid = sqrt(se_samp_iid^2 + se_cf^2),
       se_cl  = sqrt(se_samp_cl^2 + se_cf^2),
       se_sampling_iid = se_samp_iid, se_sampling_cl = se_samp_cl,
       se_crossfit = se_cf,
       V_iid = Vi_bar, V_cl = Vc_bar,
       theta_partitions = th, disc = colMeans(dsc), kappa_J = kap,
       lf = lf, n = n, p = p, K = K, n_part = n_part,
       coef_names = colnames(Z),
       lf_hit_cap = sum(lf$hit_cap), lf_at_one = sum(lf$argmin == 1L),
       lf_argmin_median = stats::median(lf$argmin),
       eps_rho = eps_rho, prop_diag = pool_prop_diag(res),
       fits = res, xeval = xeval)
}

#' Pool the per-partition propensity diagnostics of a fit_orthogonal() run.
#'
#' @param res list of fit_one_partition() returns.
#' @return named list with the pooled binding rate and failure counts, or NULL.
pool_prop_diag <- function(res) {
  pd <- lapply(res, \(z) z$prop_diag)
  ok <- !vapply(pd, is.null, logical(1))
  if (!any(ok)) return(NULL)
  pd <- pd[ok]
  ne <- vapply(pd, \(z) z$n_eval_total, numeric(1))
  nb <- vapply(pd, \(z) as.numeric(z$n_bind), numeric(1))
  list(n_partitions = length(pd),
       n_undocumented = sum(vapply(pd, \(z) as.numeric(z$n_undocumented),
                                   numeric(1))),
       n_eval_total = sum(ne), n_bind = sum(nb),
       bind_rate = if (sum(ne) > 0) sum(nb) / sum(ne) else NA_real_,
       min_pre = min(vapply(pd, \(z) z$min_pre, numeric(1))),
       max_move = max(vapply(pd, \(z) z$max_move, numeric(1))),
       n_fallback = sum(vapply(pd, \(z) as.numeric(z$n_fallback), numeric(1))),
       n_fallback_all = sum(vapply(pd, \(z) as.numeric(z$n_fallback_all),
                                   numeric(1))),
       n_not_converged = sum(vapply(pd, \(z) as.numeric(z$n_not_converged),
                                    numeric(1))),
       n_conv_unknown = sum(vapply(pd, \(z) as.numeric(z$n_conv_unknown),
                                   numeric(1))),
       bind_rate_by_partition = nb / ne)
}

# ---- LaTeX helpers ---------------------------------------------------------

#' Fixed-decimal formatting that never returns "NA" silently.
fmt <- function(x, d = 3) {
  out <- formatC(x, format = "f", digits = d)
  out[!is.finite(x)] <- "--"
  out
}

#' Fixed-decimal formatting for a MONTE CARLO p-value, with the resolution
#' floor printed as a floor rather than as zero.
#'
#' A permutation or parametric-bootstrap p-value computed as
#' (1 + #{ref >= obs}) / (B + 1) cannot go below 1/(B + 1).  At B = 2000 that
#' is 0.00049975, which formatC() renders at three decimals as "0.000" -- a
#' number that does not exist and that a reader, or a writer copying the table,
#' will quote as an exact zero.  Anything strictly below the display resolution
#' is therefore printed as "$<0.001$", which is what the run actually
#' establishes: no draw of the reference distribution reached the observed
#' statistic, at a resolution of B draws.
#'
#' @param p numeric. p-values in [0, 1].
#' @param d integer. Display decimals.
#' @return character vector.
fmt_p <- function(p, d = 3L) {
  out <- fmt(p, d)
  res <- 10^(-d)
  out[is.finite(p) & p < res] <- sprintf("$<%s$",
                                         formatC(res, format = "f", digits = d))
  out
}

#' Scientific notation as LaTeX math, not as the "1.23e-04" that formatC()
#' renders and that a reader sees literally in a typeset table.
#'
#' @param x numeric.
#' @param d integer. Mantissa decimals.
#' @return character vector of math-mode fragments.
fmt_sci <- function(x, d = 2L) {
  out <- character(length(x))
  ok <- is.finite(x) & x != 0
  out[!ok] <- "--"
  out[is.finite(x) & x == 0] <- "$0$"
  if (any(ok)) {
    e <- floor(log10(abs(x[ok])))
    m <- x[ok] / 10^e
    out[ok] <- sprintf("$%s \\times 10^{%d}$",
                       formatC(m, format = "f", digits = d), as.integer(e))
  }
  out
}

#' Significance stars.  OBES is not an AEA journal, so stars are standard
#' (content-standards.md, journal profile); the thresholds are defined in the
#' manuscript's table note, not here (INV-13: no notes in the fragment).
stars <- function(est, se) {
  z <- abs(est / se)
  ifelse(!is.finite(z), "",
         ifelse(z > stats::qnorm(0.995), "$^{***}$",
                ifelse(z > stats::qnorm(0.975), "$^{**}$",
                       ifelse(z > stats::qnorm(0.95), "$^{*}$", ""))))
}

#' Write a bare tabular fragment (INV-13): no table float, no caption, no
#' notes, booktabs rules only (INV-3).
write_tabular <- function(colspec, header, body, path) {
  stopifnot(!any(grepl("\\\\hline|\\\\begin\\{table\\}|\\\\caption",
                       c(header, body))))
  writeLines(c(sprintf("\\begin{tabular}{%s}", colspec), "\\toprule",
               header, "\\midrule", body, "\\bottomrule", "\\end{tabular}"),
             path)
  invisible(path)
}

#' Escape the LaTeX-active characters that appear in these variable labels.
#' Column names such as PCIncome are safe, but file names such as
#' data_tsp.txt are not, and an unescaped underscore is a compile error in the
#' manuscript rather than a visible defect here.
tex_escape <- function(x) {
  x <- gsub("\\", "\\textbackslash{}", x, fixed = TRUE)
  for (ch in c("&", "%", "$", "#", "_", "{", "}")) {
    x <- gsub(ch, paste0("\\", ch), x, fixed = TRUE)
  }
  x
}
