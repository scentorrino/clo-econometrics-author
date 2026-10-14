# ============================================================================
# sim_multinomial_phiplugin.R
#
# KNOWN-TRUTH VERIFICATION OF THE PLUG-IN phi-STEP AT L = 2, 3, 4.
#
# ---------------------------------------------------------------------------
# WHAT THIS FILE IS FOR, AND WHY IT IS NOT sim_multinomial_phistep.R
#
# sim_multinomial_phistep.R established that phi-hat recovers varphi at L = 3
# and L = 4 on a correctly-specified design: projection on the truth
# b = <phi-hat, varphi> / ||varphi||^2 = 0.809 / 0.784 / 0.700 at the oracle
# stop, `balanced`, n = 1600.  IT REACHED THE ENGINE THROUGH crossfit_once()'s
# ROUTE -- an lf_path() copy of lf_solve()'s loop, handed a propensity the
# script fitted itself with fit_propensity_multi(), with theta updated by OLS at
# every step (theta_mode = "alternate").
#
# THE PLUG-IN SECOND STAGE IS A DIFFERENT ENTRY POINT AND IT WAS BINARY-ONLY
# UNTIL 2026-08-12.  phi_second_stage() reaches the nuisance through
# conditional_parts(), which called the BINARY fit_propensity() at every
# cardinality, so both full-sample entry points -- phi_second_stage() and
# alternating_theta() -- died at L >= 3 with "y values must be 0 <= y <= 1".
# Section 6's phi-hat and its bootstrap band are produced by phi_second_stage(),
# so no evidence collected through the other route says anything about them.
# This file collects it through THIS route.
#
# ---------------------------------------------------------------------------
# WHAT IS HELD DIFFERENT FROM sim_multinomial_phistep.R, AND WHY
#
# (P1) THETA IS HELD AT THE TRUTH, not updated by OLS along the path.  That is
#      what phi_second_stage() does -- it is the plug-in stage of prp:plugin
#      GIVEN theta-hat, and it calls lf_solve(theta_mode = "fixed").  Holding it
#      at the TRUE theta isolates the phi-step: a failure here cannot be blamed
#      on the theta step, which is the point of the exercise.
#
# (P2) THE PROPENSITY IS FITTED AND EVALUATED ON THE WHOLE SAMPLE, because
#      conditional_parts() does exactly that (idx <- seq_along(w) for both).
#      phistep's path_once() fitted on a random half.  No sample splitting is
#      needed once theta is fixed: cross-fitting exists in crossfit_once() to
#      keep the nuisance out of the theta moment's influence function, and it
#      has no role here.  The consequence is that varrho-hat is slightly
#      over-fitted relative to phistep's, which if anything FLATTERS the
#      estimator, and is stated rather than hidden.
#
# Everything else is held identical to phistep so the numbers are comparable:
# same DGPs (sim_multinomial_dgp.R), same varphi, same b and ISE definitions,
# same B = 24, same three coarsenings of one draw on one RNG anchor.
#
# ---------------------------------------------------------------------------
# HOW THE PATH IS OBTAINED WITHOUT REIMPLEMENTING THE ESTIMATOR
#
# phi_second_stage() returns ONE iterate.  Under TAU_DP = 0 with patience tied
# to the cap -- the shipped configuration (app_tsp_common.R C26, C5) -- neither
# stopping test can fire, so eq:lfsched(c)'s emptiness convention applies and
# THE RETURNED ITERATE IS THE ITERATE AT m-bar.  Hence
#
#     phi_second_stage(lf_imax = m)  ==  the m-th iterate,
#
# and the whole path could be had by calling it at m = 1..100.  That costs
# sum(m) = 5050 iterations where the path costs 100, so the loop is recorded
# once instead -- and check_plugin_fidelity() PROVES the recorder is
# phi_second_stage() by running the real entry point at several m at every
# cardinality and requiring EXACT equality.  It runs on every invocation and
# stops the script on any difference, so no number below can be a statement
# about a different estimator.
#
# ---------------------------------------------------------------------------
# WHAT WOULD COUNT AS A FAILURE
#
# A generalized phi-step that runs but returns a curve uncorrelated with the
# truth.  The pass condition is therefore stated on b, not on the absence of an
# error: b must be positive and of the same order at L = 4 as at L = 2 on the
# correctly-specified designs.  `misspec` is the CONTRAST -- its propensity is
# outside the family the estimator fits, which is a documented violation of
# thm:rootn's own (T-4), and b there is expected to be negative at L >= 3.
#
# Outputs
#   quality_reports/sim/sim_multinomial_phiplugin.rds
#   paper/tables/sim/sim_multinomial_phiplugin.tex   (bare tabular, INV-13)
# ============================================================================

suppressMessages({
  library(here)
  library(parallel)
})
source(here::here("scripts", "R", "lf_panel.R"))
source(here::here("scripts", "R", "orthogonal_theta.R"))
source(here::here("scripts", "simulations", "sim_multinomial_dgp.R"))

RNGkind("L'Ecuyer-CMRG")
set.seed(20260812L)                                                  # INV-14

# ---- constants -------------------------------------------------------------
#
# Held at the application's own values (app_tsp_common.R C21-C26) so that what
# is verified is the configuration Section 6 runs, not a neighbouring one.

N_T_SIM       <- 16L          # C21
T_SCALE_SIM   <- 0.25         # C22
ADJ_WTIL_SIM  <- TRUE         # C23
BIER_SEED_SIM <- 20260805L    # C25
TAU_DP_SIM    <- 0            # C26: the rule never fires; the cap regularises
EPS_MAIN      <- 0.03         # C24, and phistep's level, so b is comparable
EPS_ALT       <- 0.01         # C27, the level Section 6.3's L >= 3 path uses

# The shipped iteration cap, by cardinality (C4).  Reported alongside the
# oracle so the table says what the SHIPPED rule delivers, not only what the
# best iterate on the path would have delivered.
MBAR_SHIP <- c("2" = 15L, "3" = 30L, "4" = 60L)

M_MAX   <- 100L               # phistep's path length, so the oracles compare
B_REP   <- 24L                # phistep's replication count
B_EPS   <- 12L                # the eps side-arm is a contrast, not a headline
L_GRID  <- c(2L, 3L, 4L)
N_GRID  <- c(400L, 1600L)
D_GRID  <- c("balanced", "skewed", "misspec")
D_EPS   <- c("balanced", "skewed")
N_EPS   <- 1600L

## SIM_B and SIM_NMAX cut the grid for a short run, which is
## sim_multinomial_rootn.R:123's convention.  THIS ARM IS ALREADY RESUMABLE --
## `todo` below runs only the jobs whose part file is missing -- and these knobs
## exist so that the resumption can be EXERCISED at a size a person will
## actually re-run.  A resumability claim tested only at 7.3 core-hours is a
## claim nobody re-tests.  Both feed CFG, so a reduced run is a different
## configuration and clears the parts directory rather than mixing sizes into it;
## point SIM_OUT_ROOT at a scratch tree before using them.
B_REP   <- min(B_REP, as.integer(Sys.getenv("SIM_B",    unset = "24")))
B_EPS   <- min(B_EPS, as.integer(Sys.getenv("SIM_B",    unset = "12")))
N_MAX   <- as.integer(Sys.getenv("SIM_NMAX", unset = "1600"))
N_GRID  <- N_GRID[N_GRID <= N_MAX]
## The eps side-arm is pinned to the LARGEST sample size, so it has to follow the
## cut rather than ignore it -- otherwise SIM_NMAX = 400 would still pay for the
## n = 1,600 jobs, which are 94 per cent of this arm's cost.
N_EPS   <- min(N_EPS, max(N_GRID))
N_CORES_SIM <- 6L             # n = 1600 holds ~8 n-by-n matrices per worker

## Output root.  Defaults to the repository tree; the override lets a run be
## written to a scratch tree and diffed before it replaces anything, which is
## this project's standing rule for cached output.
OUT_ROOT <- Sys.getenv("SIM_OUT_ROOT", unset = here::here())         # INV-16
OUT <- file.path(OUT_ROOT, "quality_reports", "sim")
TAB <- file.path(OUT_ROOT, "paper", "tables", "sim")
PARTS <- file.path(OUT, "sim_multinomial_phiplugin_parts")
for (d in c(OUT, TAB, PARTS)) dir.create(d, showWarnings = FALSE,
                                         recursive = TRUE)

# ---- the job grid and its streams, BEFORE anything consumes the generator ---
#
# The grid is pure metadata -- no RNG -- so it can be built first, and it has to
# be: the streams are counted from this script's single seed, and if they were
# drawn after the design validation and the fidelity self-test then N_VALID and
# the fidelity grid, both REPORTING choices, would silently change every
# replication.  sim_multinomial_phistep.R documents the same hazard.
#
# `arm` separates the headline (eps = 0.03, every design and n) from the eps
# side-arm (eps = 0.01, the two correctly-specified designs at the largest n),
# which exists only to price C27's constant on the phi-step.

JOBS <- rbind(
  expand.grid(arm = "main", dgp = D_GRID, n = N_GRID, b = seq_len(B_REP),
              stringsAsFactors = FALSE),
  expand.grid(arm = "eps", dgp = D_EPS, n = N_EPS, b = seq_len(B_EPS),
              stringsAsFactors = FALSE))
JOBS$eps <- ifelse(JOBS$arm == "main", EPS_MAIN, EPS_ALT)

#' Deterministic L'Ecuyer streams, one per job, counted from the caller's seed.
#'
#' Core-count independent by construction: job j always receives the j-th
#' stream, whereas mclapply's own assignment depends on mc.cores when
#' mc.preschedule = TRUE, which would make every number here a function of the
#' host.  Written as a function returning a list rather than the `local()` plus
#' `<<-` idiom used elsewhere in scripts/simulations, because `<<-` is a
#' prohibited pattern in this project's R standard.
#'
#' @param n_jobs integer. Number of streams required.
#' @return list of L'Ecuyer seed vectors.
next_streams <- function(n_jobs) {
  out <- vector("list", n_jobs)                                      # INV-17
  s <- get(".Random.seed", envir = globalenv())
  for (j in seq_len(n_jobs)) {
    s <- parallel::nextRNGStream(s)
    out[[j]] <- s
  }
  out
}
STREAMS <- next_streams(nrow(JOBS))

# ---- the path recorder -----------------------------------------------------

#' phi_second_stage()'s Landweber path, with every iterate kept.
#'
#' lf_solve()'s theta_mode = "fixed" loop, with the stopping tests removed
#' because under TAU_DP = 0 and patience = cap neither can fire anyway.  The
#' nuisance comes from conditional_parts(), which is the function under test, so
#' the propensity here IS phi_second_stage()'s propensity rather than a
#' reconstruction of it.
#'
#' `PHI[m, ]` is the iterate AT m: the value of `dev` at the TOP of iteration m,
#' before that iteration's step.  That is the pairing lf_solve() uses when it
#' snapshots `cur`, and it makes PHI[1, ] the initial condition.
#'
#' @param y,x1,x2,Z,w model objects; Z has the intercept in column 1.
#' @param theta numeric. The value theta is held at.
#' @param cells integer vector. The instrument's declared cell set.
#' @param xeval numeric. Evaluation grid.
#' @param eps_rho numeric. eq:trunset truncation level.
#' @param imax integer. Path length.
#' @return list: PHI (imax x |xeval|), err, noise (length imax), cste, cells, L.
phi_plugin_path <- function(y, x1, x2, Z, w, theta, cells, xeval,
                            eps_rho = EPS_MAIN, imax = M_MAX) {
  op <- make_operator(x1, x2, xeval)
  init <- init_control(y, x1, x2, Z, w, op)
  cf <- conditional_parts(Z, w, conditional = TRUE, eps_rho = eps_rho,
                          n_t = N_T_SIM, bier_seed = BIER_SEED_SIM,
                          t_scale = T_SCALE_SIM, adj_wtil = ADJ_WTIL_SIM,
                          cells = cells)

  d1 <- init$d1; d2 <- init$d2; dev <- init$dev
  phi1 <- integrate_centre(d1, op$M1, op$ord1)
  phi2 <- integrate_centre(d2, op$M2, op$ord2)
  dphi <- locate_dphi(phi2 - phi1, y, Z, theta)

  ## The step, set exactly as lf_solve() sets it at cste = NULL (C3).  Copied
  ## rather than delegated because the caller has to be able to hand the SAME
  ## value to phi_second_stage() in the fidelity check, and lf_solve() computes
  ## it internally from an RNG draw inside operator_norm2().
  u0 <- as.vector(y - Z %*% theta) - dphi
  r0 <- operator_residual(u0, w, rho = cf$rho, bier = cf$bier,
                          adj_wtil = cf$adj_wtil)
  nrm <- operator_norm2(op, weight = r0$adjw)
  cste <- if (is.finite(nrm) && nrm > 0) 1 / nrm else 0.5

  errn <- rep(NA_real_, imax); noisen <- rep(NA_real_, imax)         # INV-17
  PHI <- matrix(NA_real_, imax, length(xeval))

  for (it in seq_len(imax)) {
    u <- as.vector(y - Z %*% theta) - dphi
    res <- operator_residual(u, w, rho = cf$rho, bier = cf$bier,
                             adj_wtil = cf$adj_wtil)
    errn[it] <- residual_norm(res)
    noisen[it] <- res$noise
    PHI[it, ] <- cumtrapz_centre(xeval, dev)

    step <- apply_adjoint(op, res$comperr)
    d1 <- d1 - cste * step$d1
    d2 <- d2 - cste * step$d2
    dev <- dev - cste * step$dev

    phi1 <- integrate_centre(d1, op$M1, op$ord1)
    phi2 <- integrate_centre(d2, op$M2, op$ord2)
    dphi <- locate_dphi(phi2 - phi1, y, Z, theta)
    ## theta_mode = "fixed": theta is NOT updated.  That is the whole difference
    ## from lf_path() in sim_multinomial_phistep.R.
  }
  list(PHI = PHI, err = errn, noise = noisen, cste = cste,
       cells = cf$cells, L = cf$L, prop_diag = cf$prop_diag)
}

#' Prove the recorder is phi_second_stage(), on this machine, on this run.
#'
#' Runs the REAL entry point at several caps at every cardinality and requires
#' the returned curve to equal the recorded iterate EXACTLY.  Any drift would
#' make every number in this file a statement about a different estimator, so
#' this is a stop and not a warning.
#'
#' The RNG state is restored before each call because lf_solve() draws inside
#' operator_norm2() when it sets the step itself; both sides must therefore see
#' the same stream.  It draws from the ambient stream and takes no seed of its
#' own -- a second set.seed() would violate INV-14, and if it ran before the
#' replication streams were built it would be the constant that actually
#' controlled the Monte Carlo.
#'
#' @param n integer. Sample size for the check.
#' @param m_check integer vector. The caps to compare at.
#' @return data.frame of the realised gaps, one row per (L, m).
check_plugin_fidelity <- function(n = 300L, m_check = c(1L, 2L, 7L, 20L)) {
  d <- mdgp_draw(n, MDGP_SPEC$balanced)
  xev <- seq(stats::quantile(c(d$x1, d$x2), 0.05),
             stats::quantile(c(d$x1, d$x2), 0.95), length.out = 60L)
  rows <- vector("list", length(L_GRID) * length(m_check))            # INV-17
  i <- 0L
  for (L in L_GRID) {
    w <- mdgp_inst(d, L)
    cells <- sort(unique(as.integer(w)))
    anchor <- get(".Random.seed", envir = globalenv())
    p <- phi_plugin_path(d$y, d$x1, d$x2, d$Z, w, MDGP_THETA_FULL, cells, xev,
                         imax = max(m_check))
    for (m in m_check) {
      assign(".Random.seed", anchor, envir = globalenv())
      ph <- phi_second_stage(d$y, d$x1, d$x2, d$Z, w, MDGP_THETA_FULL,
                             cste = NULL, init_fn = init_control, xeval = xev,
                             lf_imax = m, conditional = TRUE,
                             eps_rho = EPS_MAIN, n_t = N_T_SIM,
                             bier_seed = BIER_SEED_SIM, t_scale = T_SCALE_SIM,
                             adj_wtil = ADJ_WTIL_SIM, tau_dp = TAU_DP_SIM,
                             cells = cells)
      i <- i + 1L
      rows[[i]] <- data.frame(L = L, m = m, iter = ph$iter,
                              gap = max(abs(p$PHI[m, ] - as.vector(ph$phiev))),
                              cste_gap = abs(p$cste - ph$cste))
    }
    assign(".Random.seed", anchor, envir = globalenv())
  }
  fid <- do.call(rbind, rows)
  if (max(fid$gap, fid$cste_gap) > 0) {
    stop("phi_plugin_path() has drifted from phi_second_stage(): max gap ",
         sprintf("%.3e", max(fid$gap, fid$cste_gap)))
  }
  fid
}

# ---- one job: three coarsenings of one draw --------------------------------

#' Summaries of one path.
#'
#' `b` and `ise` are defined exactly as in sim_multinomial_phistep.R so the two
#' files' numbers are comparable without rescaling.
#'
#' @param PHI numeric matrix imax x |xeval|.
#' @param phi0 numeric. The truth on the grid, centred.
#' @return list: b, ise (length imax).
path_summary <- function(PHI, phi0) {
  list(b = as.vector(PHI %*% phi0) / sum(phi0^2),
       ise = rowMeans(sweep(PHI, 2L, phi0, "-")^2))
}

#' One replication: one draw, all three cardinalities, paired.
#'
#' Takes ONE stream rather than the whole list and an index: the worker would
#' otherwise hold a copy of every stream, so memory would scale with the job
#' count on each of the six workers for no purpose.
#'
#' @param stream integer vector. This replication's L'Ecuyer anchor.
#' @param dgp character. Name in MDGP_SPEC.
#' @param n integer. Sample size.
#' @param eps numeric. eq:trunset truncation level.
#' @return list keyed by L, each with b, ise, ratio, m_ship, bind_rate.
run_one <- function(stream, dgp, n, eps) {
  assign(".Random.seed", stream, envir = globalenv())
  d <- mdgp_draw(n, MDGP_SPEC[[dgp]])
  xev <- seq(stats::quantile(c(d$x1, d$x2), 0.05),
             stats::quantile(c(d$x1, d$x2), 0.95), length.out = 60L)
  phi0 <- MDGP_PHI(xev); phi0 <- phi0 - mean(phi0)
  out <- vector("list", length(L_GRID))                              # INV-17
  names(out) <- as.character(L_GRID)
  for (L in L_GRID) {
    w <- mdgp_inst(d, L)
    cells <- sort(unique(as.integer(w)))
    ## A draw that fails to realise every cell is a degenerate draw, not a
    ## silently smaller L.  Recorded and skipped rather than re-cardinalised.
    if (length(cells) != L) {
      out[[as.character(L)]] <- list(ok = FALSE, reason = "cell missing")
      next
    }
    p <- phi_plugin_path(d$y, d$x1, d$x2, d$Z, w, MDGP_THETA_FULL, cells, xev,
                         eps_rho = eps, imax = M_MAX)
    s <- path_summary(p$PHI, phi0)
    out[[as.character(L)]] <- list(
      ok = TRUE, b = s$b, ise = s$ise, ratio = p$err / p$noise,
      err = p$err, noise = p$noise, cste = p$cste,
      m_ship = MBAR_SHIP[[as.character(L)]],
      bind_rate = p$prop_diag$bind_rate, min_pre = p$prop_diag$min_pre,
      route = p$prop_diag$route, converged = p$prop_diag$converged)
  }
  out
}

# ---- V0  design validity, and the fidelity proof ---------------------------

message("== V0  design validity (sim_multinomial_dgp.R's own check) ==")
VAL <- vector("list", length(D_GRID) * length(L_GRID))               # INV-17
i <- 0L
for (dd in D_GRID) for (L in L_GRID) {
  v <- mdgp_validate(MDGP_SPEC[[dd]], n_check = 2e5L, L = L)
  i <- i + 1L
  VAL[[i]] <- data.frame(dgp = dd, L = L, a1_true = v$a1_true,
                         a1_true_t = v$a1_true_t, a1_fit = v$a1_fit,
                         a1_fit_t = v$a1_fit_t, zt = max(v$zmom_t), ok = v$ok)
  message(sprintf("  %-9s L=%d | A1 true %.5f (t %.1f) | A1 FITTED %.5f (t %.1f)",
                  dd, L, v$a1_true, v$a1_true_t, v$a1_fit, v$a1_fit_t))
}
VAL <- do.call(rbind, VAL)

message("\n== fidelity: phi_plugin_path() against phi_second_stage() ==")
FID <- check_plugin_fidelity()
message(sprintf("  max |phi_path[m] - phi_second_stage(imax = m)| = %.1e over %d (L, m) pairs",
                max(FID$gap), nrow(FID)))

# ---- the Monte Carlo -------------------------------------------------------

CFG <- list(
  m_max = M_MAX, b_rep = B_REP, b_eps = B_EPS, L = L_GRID, n = N_GRID,
  dgp = D_GRID, eps_main = EPS_MAIN, eps_alt = EPS_ALT,
  tau = TAU_DP_SIM, n_t = N_T_SIM, t_scale = T_SCALE_SIM,
  adj = ADJ_WTIL_SIM, bier = BIER_SEED_SIM,
  src = unname(tools::md5sum(here::here(
    "scripts", "R", c("lf_panel.R", "orthogonal_theta.R")))),
  dgp_src = unname(tools::md5sum(here::here(
    "scripts", "simulations", "sim_multinomial_dgp.R"))),
  driver = c(paste(deparse(phi_plugin_path), collapse = "\n"),
             paste(deparse(run_one), collapse = "\n"),
             paste(deparse(path_summary), collapse = "\n"))
)
CFG_FILE <- file.path(PARTS, "cfg.rds")
if (file.exists(CFG_FILE) && !identical(readRDS(CFG_FILE), CFG)) {
  message("phiplugin: cache discarded, configuration changed")
  unlink(list.files(PARTS, pattern = "^part_", full.names = TRUE))
}
saveRDS(CFG, CFG_FILE)

## Sweep any temporary left by a kill mid-write (see the atomic write below).
## A stray .tmp is inert -- `todo` tests for the FINAL name, which a .tmp is not
## -- but leaving them accumulates junk across interrupted runs.
unlink(list.files(PARTS, pattern = "\\.tmp$", full.names = TRUE))

job_path <- function(j) {
  file.path(PARTS, sprintf("part_%s_%s_%04d_%03d.rds", JOBS$arm[j],
                           JOBS$dgp[j], JOBS$n[j], JOBS$b[j]))
}

todo <- which(!file.exists(vapply(seq_len(nrow(JOBS)), job_path, character(1))))
message(sprintf("\n== Monte Carlo: %d of %d jobs to run on %d workers ==",
                length(todo), nrow(JOBS), N_CORES_SIM))

if (length(todo)) {
  t0 <- Sys.time()
  invisible(parallel::mclapply(todo, function(j) {
    r <- tryCatch(run_one(STREAMS[[j]], JOBS$dgp[j], JOBS$n[j], JOBS$eps[j]),
                  error = function(e) list(failed = conditionMessage(e)))
    ## ATOMIC WRITE.  This arm is ALREADY resumable -- `todo` above runs only the
    ## jobs whose part is missing, and each job's draws come from its own
    ## pre-computed L'Ecuyer stream, so a resumed run is bit-identical by
    ## construction.  The one hole was here: a kill BETWEEN saveRDS() creating
    ## the file and finishing it leaves a TRUNCATED part, `todo` then reads it as
    ## done because it tests only file.exists(), and the collect step's readRDS()
    ## dies -- taking every other completed part of the run with it.  Written to
    ## a temporary in the same directory and renamed, so a part on disk is either
    ## absent or complete and never half-written.
    tmp_j <- paste0(job_path(j), ".tmp")
    saveRDS(list(job = JOBS[j, ], res = r), tmp_j)
    file.rename(tmp_j, job_path(j))
    NULL
  }, mc.cores = N_CORES_SIM, mc.preschedule = FALSE))
  message(sprintf("  %.1f min", as.numeric(difftime(Sys.time(), t0,
                                                    units = "mins"))))
}

# ---- collect ---------------------------------------------------------------

parts <- lapply(seq_len(nrow(JOBS)), function(j) readRDS(job_path(j)))
n_failed <- sum(vapply(parts, function(z) !is.null(z$res$failed), logical(1)))
if (n_failed > 0L) {
  message(sprintf("*** %d of %d jobs FAILED ***", n_failed, length(parts)))
}

#' Flatten one part into one row per cardinality.
#'
#' `b_ship` is the projection at the SHIPPED cap; `b_orc` at the oracle over the
#' recorded path.  `m_orc` is where that oracle sits, which is the number C4's
#' cap has to cover.
flatten_part <- function(z) {
  if (!is.null(z$res$failed)) return(NULL)
  rows <- vector("list", length(L_GRID))                             # INV-17
  for (k in seq_along(L_GRID)) {
    L <- L_GRID[k]
    r <- z$res[[as.character(L)]]
    if (is.null(r) || !isTRUE(r$ok)) next
    m_ship <- r$m_ship
    orc <- which.min(r$ise)
    rows[[k]] <- data.frame(
      arm = z$job$arm, dgp = z$job$dgp, n = z$job$n, b = z$job$b,
      eps = z$job$eps, L = L,
      b_ship = r$b[m_ship], ise_ship = r$ise[m_ship], m_ship = m_ship,
      b_orc = r$b[orc], ise_orc = r$ise[orc], m_orc = orc,
      b_1 = r$b[1L], ise_1 = r$ise[1L], b_max = r$b[M_MAX],
      ratio_ship = r$ratio[m_ship], ratio_orc = r$ratio[orc],
      bind_rate = r$bind_rate, min_pre = r$min_pre,
      converged = isTRUE(r$converged),
      rising = as.integer(r$b[M_MAX] > r$b[1L]),
      stringsAsFactors = FALSE)
  }
  do.call(rbind, rows)
}

DF <- do.call(rbind, lapply(parts, flatten_part))
stopifnot(nrow(DF) > 0L, all(is.finite(DF$b_ship)))

## The mean b path, kept so the monotonicity claim is a curve and not an
## assertion.  Averaged over replications within (arm, dgp, n, L).
acc <- new.env(parent = emptyenv())
for (z in parts) {
  if (!is.null(z$res$failed)) next
  for (L in L_GRID) {
    r <- z$res[[as.character(L)]]
    if (is.null(r) || !isTRUE(r$ok)) next
    kk <- paste(z$job$arm, z$job$dgp, z$job$n, L, sep = "|")
    prev <- if (exists(kk, envir = acc)) get(kk, envir = acc) else
      list(s = numeric(M_MAX), k = 0L)
    assign(kk, list(s = prev$s + r$b, k = prev$k + 1L), envir = acc)
  }
}
BPATH <- lapply(ls(acc), function(kk) {
  z <- get(kk, envir = acc)
  list(key = kk, b_mean = z$s / z$k, n_rep = z$k)
})
names(BPATH) <- ls(acc)

# ---- summaries -------------------------------------------------------------

#' Mean and Monte Carlo standard error of a column, by cell.
cell_stat <- function(df, col) {
  x <- df[[col]]
  c(mean = mean(x), se = stats::sd(x) / sqrt(length(x)), n = length(x))
}

SUMM <- do.call(rbind, lapply(split(DF, with(DF, paste(arm, dgp, n, L,
                                                       sep = "|"))),
  function(g) {
    bs <- cell_stat(g, "b_ship"); bo <- cell_stat(g, "b_orc")
    is <- cell_stat(g, "ise_ship"); io <- cell_stat(g, "ise_orc")
    data.frame(arm = g$arm[1], dgp = g$dgp[1], n = g$n[1], L = g$L[1],
               eps = g$eps[1], n_rep = bs[["n"]],
               b_ship = bs[["mean"]], b_ship_se = bs[["se"]],
               b_orc = bo[["mean"]], b_orc_se = bo[["se"]],
               ise_ship = is[["mean"]], ise_ship_se = is[["se"]],
               ise_orc = io[["mean"]], ise_orc_se = io[["se"]],
               b_1 = mean(g$b_1), b_max = mean(g$b_max),
               m_orc_med = stats::median(g$m_orc),
               m_orc_q1 = stats::quantile(g$m_orc, 0.25, names = FALSE),
               m_orc_q3 = stats::quantile(g$m_orc, 0.75, names = FALSE),
               ratio_orc = stats::median(g$ratio_orc),
               bind_rate = mean(g$bind_rate), min_pre = min(g$min_pre),
               n_rising = sum(g$rising),
               stringsAsFactors = FALSE)
  }))
rownames(SUMM) <- NULL
SUMM <- SUMM[order(SUMM$arm, SUMM$dgp, SUMM$n, SUMM$L), ]

message("\n===== b AT THE SHIPPED CAP AND AT THE ORACLE =====")
message(sprintf("%-5s %-9s %5s %2s %6s | %15s %15s | %6s %6s",
                "arm", "dgp", "n", "L", "eps", "b at cap (se)",
                "b at oracle (se)", "m_orc", "rise"))
for (i in seq_len(nrow(SUMM))) {
  s <- SUMM[i, ]
  message(sprintf("%-5s %-9s %5d %2d %6.3f | %8.3f (%.3f) %8.3f (%.3f) | %6.0f %2d/%d",
                  s$arm, s$dgp, s$n, s$L, s$eps, s$b_ship, s$b_ship_se,
                  s$b_orc, s$b_orc_se, s$m_orc_med, s$n_rising, s$n_rep))
}

# ---- the verdict, computed rather than declared ----------------------------
#
# PASS on the correctly-specified designs requires, at every n and every L:
#   (i)  b at the shipped cap positive by at least 5 Monte Carlo standard
#        errors -- "uncorrelated with the truth" is the failure mode named in
#        the brief, so the test is against zero;
#   (ii) b at L = 4 at least half of b at L = 2 at the same (dgp, n) -- the
#        degradation with cardinality that phistep measured (0.809 -> 0.700) is
#        expected and admissible; a collapse is not.

clean <- SUMM[SUMM$dgp != "misspec" & SUMM$arm == "main", ]
t_ship <- clean$b_ship / clean$b_ship_se
ref <- clean[clean$L == 2L, c("dgp", "n", "b_ship")]
names(ref)[3] <- "b_ship_L2"
clean <- merge(clean, ref, by = c("dgp", "n"))
clean$share_of_L2 <- clean$b_ship / clean$b_ship_L2
PASS <- all(t_ship > 5) && all(clean$share_of_L2 > 0.5)

message(sprintf("\nVERDICT on the correctly-specified designs: %s",
                if (PASS) "PASS" else "*** FAIL ***"))
message(sprintf("  min t(b at cap vs 0) = %.1f  (needs > 5)", min(t_ship)))
message(sprintf("  min b(L)/b(L=2)      = %.3f (needs > 0.5)",
                min(clean$share_of_L2)))

# ---- table (bare tabular, INV-13; booktabs only, INV-3) --------------------

fmt_n <- function(x, d = 3L) formatC(x, format = "f", digits = d)

tab_rows <- vector("list", nrow(SUMM))                               # INV-17
for (i in seq_len(nrow(SUMM))) {
  s <- SUMM[i, ]
  tab_rows[[i]] <- sprintf(
    "%s & %s & %d & %d & %s & %s (%s) & %s (%s) & %s & %s \\\\",
    if (s$arm == "main") "0.03" else "0.01",
    switch(s$dgp, balanced = "Balanced", skewed = "Skewed",
           misspec = "Misspecified $\\hat\\varrho$"),
    s$n, s$L, fmt_n(s$b_1),
    fmt_n(s$b_ship), fmt_n(s$b_ship_se),
    fmt_n(s$b_orc), fmt_n(s$b_orc_se),
    formatC(s$m_orc_med, format = "d"),
    fmt_n(s$ise_ship))
}

writeLines(
  c("\\begin{tabular}{llrrrrrrr}", "\\toprule",
    paste("$\\varepsilon_\\varrho$ & Design & $n$ & $\\mathsf L$ &",
          "$b$ at $m=1$ & $b$ at $\\bar m$ & $b$ at oracle &",
          "oracle $\\hat m$ & ISE at $\\bar m$ \\\\"),
    "\\midrule",
    unlist(tab_rows, use.names = FALSE),
    "\\bottomrule", "\\end{tabular}"),
  file.path(TAB, "sim_multinomial_phiplugin.tex"))

saveRDS(list(cfg = CFG, validity = VAL, fidelity = FID, df = DF,
             summary = SUMM, b_path = BPATH, pass = PASS,
             t_ship = t_ship, share_of_L2 = clean,
             n_failed = n_failed, mbar_ship = MBAR_SHIP),
        file.path(OUT, "sim_multinomial_phiplugin.rds"))

message(sprintf("\nwritten: %s", file.path(OUT, "sim_multinomial_phiplugin.rds")))
message(sprintf("written: %s", file.path(TAB, "sim_multinomial_phiplugin.tex")))
