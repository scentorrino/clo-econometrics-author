# ============================================================================
# sim_multinomial_phistep.R
#
# THE phi-STEP AT L >= 3: DOES THE DISCREPANCY STOP SELECT A GOOD ITERATE?
#
#   Rscript scripts/simulations/sim_multinomial_phistep.R
#
# ---------------------------------------------------------------------------
# THE CLAIM UNDER TEST
#
# A7 and results_s3_estimation.tex eq:lfsched(c) specify a DISCREPANCY
# PRINCIPLE for the Landweber-Fridman step:
#
#   m-hat := min{ m <= m-bar : ||T-hat_m||_{L2(Pi)} <= tau_DP delta-hat^eff_{n,k} },
#
# with m-hat := m-bar when the set is empty.  eq:lfsched sets
# delta-hat^eff_{n,k} = c_14 (delta-hat_n ln n + h_u^{-2} eps-hat_{k-1}^2), and
# the corpus is explicit that c_14 "must be CHOSEN, because [it is] not
# identified by the data", subject to c_14 >= c_16, where c_16 is "built from the
# kernel constants and THE DESIGN" and is unknown to the analyst.
#
# lf_panel.R collapses tau_DP * c_14 * ln n into the single implementation
# constant `tau_dp = 0.7`, registered in theory_diagnostics() as `c14_realised`.
# Its calibration note is dated 2026-08-07 and reads: "Tracking ISE(phi_m) along
# the whole path over 10 replications, the oracle stop sits at m ~ 12 and the
# ratio ||T-hat_m|| / delta-hat_n there has median 0.63 at n = 400 (IQR
# 0.39-0.93) and 0.76 at n = 800 (IQR 0.57-1.14)."  The L >= 3 code path did not
# exist on 2026-08-07.  So the constant was calibrated at L = 2 and only there,
# and this file re-runs exactly that calibration at L = 2, 3 and 4.
#
# ---------------------------------------------------------------------------
# WHAT THIS FILE SETTLED, AND THE FINDING IT REPLACES
#
# A probe dated 2026-08-11 (scripts/simulations/sim_multinomial_onestep.R and
# explorations/adjoint-identity-L) reported that phi-hat at L = 4 is
# ANTI-CORRELATED with the truth and worsening in n -- projection coefficient
# b = -0.333 at n = 400 falling to -0.623 at n = 1600 -- and diagnosed a
# miscalibrated tau_dp, on the evidence that the discrepancy stop fired 0 of 8
# times at L = 4 against 7 of 8 at L = 2 and that capping the iteration removed
# the anti-correlation monotonically.
#
# *** THE STOPPING RULE IS NOT THE CAUSE, AND RECALIBRATING IT WOULD NOT HAVE
# FIXED ANYTHING. ***  That probe's DGP puts a z1*z2 INTERACTION in cell 3's
# propensity index and hands the estimator a multinomial logit in (1, z1, z2).
# The interaction is outside the fitted family, so varrho-hat has a NON-VANISHING
# limit and A1 fails at the propensity the estimator actually uses.  Measured by
# mdgp_validate() at n = 600,000, where sampling noise is negligible, the A1
# residual max_{l,q} |E[Wtilde_l 1{dU <= q}]| at the FITTED propensity is
#
#     L = 2: 0.0103 (t = 22.6)   L = 3: 0.0231 (t = 51.0)   L = 4: 0.0349 (t = 112.3)
#
# against 0.0005-0.0007 at the true propensity at every cardinality.  It is a
# population quantity and it GROWS WITH L, because a pooled binary contrast
# averages the specification error away and cellwise contrasts do not.
#
# Two consequences follow, and between them they account for every symptom the
# 2026-08-11 probe reported:
#
#   (1) ||T-hat_m|| is bounded below by a constant that does not shrink in n,
#       while delta-hat_n falls at n^{-1/2}.  So the ratio ||T-hat_m||/delta-hat_n
#       GROWS in n -- measured 1.58 at n = 400 and 2.60 at n = 1600 -- and the
#       discrepancy principle correctly declines to certify any iterate.  A rule
#       that refuses to stop when the residual genuinely exceeds the noise level
#       is a rule that is WORKING.  Raising tau_dp until it fires would have
#       manufactured a stop at an iterate that is not close to varphi.
#
#   (2) The iteration minimises a criterion whose zero is not varphi, so it moves
#       phi-hat away from varphi, further the longer it runs.  That is the
#       anti-correlation, its worsening in n, and the monotone effect of capping.
#
# This file therefore runs the calibration on designs where varrho IS in the
# family the estimator fits (`balanced`, `skewed`), and keeps the 2026-08-11
# design as the `misspec` arm so the contrast is measured rather than asserted.
#
# ---------------------------------------------------------------------------
# WHAT IS VERIFIED, IN ORDER
#
#   V1  DESIGN VALIDITY, at large n and BEFORE any estimation, at every
#       cardinality: E[dZ dU] = 0, A1 at the true varrho, A1 at the FITTED
#       varrho, and how much work the conditional centring is doing.
#   V2  THE PATH.  b_m = <phi-hat_m, varphi>/||varphi||^2 and ISE(phi_m) along
#       the whole Landweber path, at L = 2, 3, 4.  If b_m <= 0 at every m there
#       is nothing to stop at and no tau_dp helps; that outcome is reported and
#       not tuned away.
#   V3  THE ORACLE STOP and the ratio ||T-hat_m||/delta-hat_n there -- which IS
#       tau_dp -- with its median and interquartile range, the same statistic
#       the 2026-08-07 note calibrated 0.7 from.
#   V4  WHAT THE SHIPPED RULE COSTS: ISE at the shipped stop against ISE at the
#       oracle, in Monte Carlo standard errors.
#
# ---------------------------------------------------------------------------
# WHAT IS NOT VERIFIED
#
# This is a check on the REGULARISATION CHOICE in def:lfstep, not on thm:rootn.
# No rate and no coverage is claimed for phi-hat.  The theta side is
# sim_multinomial_rootn.R.
#
# DESIGN DECISION.  The path is run on a SINGLE full-sample solve, not on the
# cross-fitted average: a stopping rule is a statement about one operator and
# one path, and averaging five folds' paths would blur the very index being
# selected.  The cross-fitted pipeline is exercised in sim_multinomial_rootn.R.
#
# RUNTIME, MEASURED BEFORE LAUNCH: 0.042 / 0.18 / 0.62 seconds per Landweber
# iteration at n = 400 / 800 / 1600.  At IMAX = 100, B = 24, three cardinalities
# and three designs that is about 40 minutes on 8 cores.  Checkpointed.
# ============================================================================

suppressMessages({                                                    # INV-15
  library(here)
  library(parallel)
})
source(here::here("scripts", "R", "lf_panel.R"))
source(here::here("scripts", "R", "orthogonal_theta.R"))
source(here::here("scripts", "simulations", "sim_multinomial_dgp.R"))

RNGkind("L'Ecuyer-CMRG")
set.seed(20260814L)                                                   # INV-14

## THE REPLICATION STREAMS ARE DRAWN FIRST, BEFORE ANYTHING ELSE CONSUMES THE
## GENERATOR.  Built later they would depend on how much randomness the design
## validation and the loop-fidelity self-test happened to use, so changing
## N_VALID -- a reporting choice -- would silently change every replication.
## Drawn here they are a function of the declared seed and of nothing else.
N_STREAM <- 512L
streams <- vector("list", N_STREAM)                                   # INV-17
local({
  s <- get(".Random.seed", envir = globalenv())
  for (j in seq_len(N_STREAM)) {
    s <- parallel::nextRNGStream(s)
    streams[[j]] <<- s
  }
})

OUT_ROOT <- Sys.getenv("SIM_OUT_ROOT", unset = here::here())          # INV-16
OUT <- file.path(OUT_ROOT, "quality_reports", "sim")
TAB <- file.path(OUT_ROOT, "paper", "tables", "sim")
for (d in c(OUT, TAB)) dir.create(d, showWarnings = FALSE, recursive = TRUE)

IMAX        <- 100L
B_REP       <- 24L
N_GRID      <- c(400L, 800L, 1600L)
L_GRID      <- c(2L, 3L, 4L)
D_GRID      <- c("balanced", "skewed", "misspec")
N_CORES     <- 8L
N_VALID     <- 6e5L
EPS_RHO     <- 0.03
N_T         <- 16L
T_SCALE     <- 0.25
TAU_SHIPPED <- 0.7        # lf_panel.R's registered value, NOT changed anywhere

# ---------------------------------------------------------------------------
# The path-recording solve.
#
# lf_solve() keeps only the selected iterate; the question here is what the WHOLE
# path looks like, so phi_m must be recorded at every m.  Adding a tracking
# argument to lf_panel.R would change that file's md5 and discard every
# fingerprinted cache in paper/tables/sim and the application's *_parts/
# directories, for a diagnostic.  So the loop is copied, and check_loop_fidelity()
# below PROVES the copy is lf_solve()'s -- it runs on every invocation of this
# script and stops it if the two paths differ at all.
# ---------------------------------------------------------------------------

#' Landweber-Fridman with the whole path kept.
#'
#' lf_solve()'s loop with the stopping tests removed, so it always runs to
#' `imax`.  `err[m]` and `noise[m]` are the discrepancy and delta-hat_n AT the
#' iterate stored in `PHI[m, ]`, which is the pairing lf_solve()'s discrepancy
#' test uses.
#'
#' @param op operator from make_operator(); `init` from init_control().
#' @param imax integer. Iterations to run.
#' @return list: err, noise (length imax), PHI (imax x |xeval|), TH (imax x p),
#'   cste.
lf_path <- function(y, x1, x2, Z, w, op, init, rho = NULL, bier = NULL,
                    adj_wtil = TRUE, cste = NULL, imax = 60L) {
  d1 <- init$d1; d2 <- init$d2; dev <- init$dev
  theta <- init$theta
  phi1 <- integrate_centre(d1, op$M1, op$ord1)
  phi2 <- integrate_centre(d2, op$M2, op$ord2)
  dphi <- locate_dphi(phi2 - phi1, y, Z, theta)

  if (is.null(cste)) {
    u0 <- as.vector(y - Z %*% theta) - dphi
    r0 <- operator_residual(u0, w, rho = rho, bier = bier, adj_wtil = adj_wtil)
    nrm <- operator_norm2(op, weight = r0$adjw)
    cste <- if (is.finite(nrm) && nrm > 0) 1 / nrm else 0.5
  }

  errn <- rep(NA_real_, imax); noisen <- rep(NA_real_, imax)          # INV-17
  PHI <- matrix(NA_real_, imax, length(op$xeval))
  TH  <- matrix(NA_real_, imax, ncol(Z))

  for (it in seq_len(imax)) {
    u <- as.vector(y - Z %*% theta) - dphi
    res <- operator_residual(u, w, rho = rho, bier = bier, adj_wtil = adj_wtil)
    errn[it]   <- residual_norm(res)
    noisen[it] <- res$noise
    PHI[it, ]  <- cumtrapz_centre(op$xeval, dev)
    TH[it, ]   <- theta

    step <- apply_adjoint(op, res$comperr)
    d1  <- d1  - cste * step$d1
    d2  <- d2  - cste * step$d2
    dev <- dev - cste * step$dev

    phi1 <- integrate_centre(d1, op$M1, op$ord1)
    phi2 <- integrate_centre(d2, op$M2, op$ord2)
    dphi <- locate_dphi(phi2 - phi1, y, Z, theta)

    theta <- stats::lm.fit(Z, as.vector(y - dphi))$coefficients
    theta[!is.finite(theta)] <- 0
    dphi <- locate_dphi(dphi, y, Z, theta)
  }
  list(err = errn, noise = noisen, PHI = PHI, TH = TH, cste = cste)
}

#' Prove lf_path() is lf_solve()'s loop, on this machine, on this run.
#'
#' Both engines are handed the SAME operator, propensity, Bierens family, init
#' and step, and lf_solve()'s stopping tests are disabled (tau_dp = 0, patience
#' = imax) so it too runs the full path.  Requires exact equality: any drift in
#' the copy would make every number below a statement about a different
#' estimator, so this is a stop and not a warning.
#' It draws from the ambient stream and takes no seed of its own: a second
#' set.seed() would violate INV-14, and -- worse -- if it ran before the
#' replication streams were built it would be the constant that actually
#' controlled the Monte Carlo, with the script's declared seed controlling
#' nothing but the validation. The streams are built at the top for that reason,
#' so nothing here can reach them.
check_loop_fidelity <- function(n = 400L, L = 4L, imax = 25L) {
  d <- mdgp_draw(n, MDGP_SPEC$balanced)
  w <- mdgp_inst(d, L)
  xev <- seq(stats::quantile(c(d$x1, d$x2), 0.05),
             stats::quantile(c(d$x1, d$x2), 0.95), length.out = 60L)
  op <- make_operator(d$x1, d$x2, xev)
  cells <- sort(unique(as.integer(w)))
  R <- fit_propensity_multi(w, d$Z, seq_len(n), seq_len(n), eps = EPS_RHO,
                            cells = cells)
  attr(R, "prop_diag") <- NULL
  rho <- if (L == 2L) as.vector(R) else R
  bier <- make_bierens(d$Z, n_t = N_T, seed = 20260805L, scale = T_SCALE)
  init <- init_control(d$y, d$x1, d$x2, d$Z, w, op)
  u0 <- as.vector(d$y - d$Z %*% init$theta) -
    locate_dphi(integrate_centre(init$d2, op$M2, op$ord2) -
                integrate_centre(init$d1, op$M1, op$ord1), d$y, d$Z, init$theta)
  r0 <- operator_residual(u0, w, rho = rho, bier = bier, adj_wtil = TRUE)
  cste <- 1 / operator_norm2(op, weight = r0$adjw)
  a <- lf_path(d$y, d$x1, d$x2, d$Z, w, op, init, rho = rho, bier = bier,
               adj_wtil = TRUE, cste = cste, imax = imax)
  b <- lf_solve(d$y, d$x1, d$x2, d$Z, w, op, init, rho = rho, bier = bier,
                adj_wtil = TRUE, cste = cste, imax = imax, patience = imax,
                tau_dp = 0)
  gaps <- c(err = max(abs(a$err - b$err_path)),
            noise = max(abs(a$noise - b$noise_path)),
            phi = max(abs(a$PHI[b$iter, ] - b$phiev)))
  if (max(gaps) > 0) {
    stop("lf_path() has drifted from lf_solve(): ",
         paste(sprintf("%s = %.3e", names(gaps), gaps), collapse = ", "))
  }
  gaps
}

#' One full-sample LF path on a draw at cardinality L.
#'
#' The propensity is fitted on a random half and evaluated on the whole sample,
#' which is the operator stage's own I_a / I_m split read at K = 1.
#'
#' @return list of path summaries: b, ise, ratio, err, noise, cste, L.
path_once <- function(d, L, imax = IMAX) {
  w <- mdgp_inst(d, L)
  n <- length(w)
  xev <- seq(stats::quantile(c(d$x1, d$x2), 0.05),
             stats::quantile(c(d$x1, d$x2), 0.95), length.out = 60L)
  op <- make_operator(d$x1, d$x2, xev)
  cells <- sort(unique(as.integer(w)))
  fit_idx <- sample(seq_len(n), floor(n / 2))
  R <- fit_propensity_multi(w, d$Z, fit_idx, seq_len(n), eps = EPS_RHO,
                            cells = cells)
  attr(R, "prop_diag") <- NULL
  rho <- if (length(cells) == 2L) as.vector(R) else R
  bier <- make_bierens(d$Z, n_t = N_T, seed = 20260805L, scale = T_SCALE)
  init <- init_control(d$y, d$x1, d$x2, d$Z, w, op)
  p <- lf_path(d$y, d$x1, d$x2, d$Z, w, op, init, rho = rho, bier = bier,
               adj_wtil = TRUE, cste = NULL, imax = imax)
  phi0 <- MDGP_PHI(xev); phi0 <- phi0 - mean(phi0)
  list(b     = as.vector(p$PHI %*% phi0) / sum(phi0^2),
       ise   = rowMeans(sweep(p$PHI, 2L, phi0, "-")^2),
       ratio = p$err / p$noise,
       err   = p$err, noise = p$noise, cste = p$cste, L = length(cells))
}

# ============================================================================
# V1  DESIGN VALIDITY -- before any estimation
# ============================================================================

message("== V1  design validity at n = ", format(N_VALID, big.mark = ","),
        " (no estimation) ==")
VAL <- vector("list", length(D_GRID) * length(L_GRID))                # INV-17
i <- 0L
for (dd in D_GRID) for (L in L_GRID) {
  v <- mdgp_validate(MDGP_SPEC[[dd]], n_check = N_VALID, L = L)
  i <- i + 1L
  VAL[[i]] <- data.frame(dgp = dd, L = L, zt = max(v$zmom_t),
                         a1_true = v$a1_true, a1_true_t = v$a1_true_t,
                         a1_fit = v$a1_fit, a1_fit_t = v$a1_fit_t,
                         uncond = v$uncond, rmse_rho = v$rmse_rho,
                         min_varrho = v$min_varrho, ok = v$ok,
                         share_min = min(v$shares),
                         relev = max(abs(v$relev)))
  message(sprintf("  %-9s L=%d | A1 true %.5f (t %.1f) | A1 FITTED %.5f (t %.1f)"
                  , dd, L, v$a1_true, v$a1_true_t, v$a1_fit, v$a1_fit_t))
}
VAL <- do.call(rbind, VAL)
message(sprintf("  V1 verdict: %s",
                if (all(VAL$ok)) "ALL DESIGNS ADMISSIBLE" else
                  "*** SOME DESIGN INVALID ***"))

message("\n== loop fidelity: lf_path() against lf_solve() ==")
fid <- check_loop_fidelity()
message(sprintf("  max |difference| on (err, noise, phi): %s",
                paste(sprintf("%.1e", fid), collapse = " ")))

# ============================================================================
# V2-V4  the paths
# ============================================================================

CELLS <- expand.grid(dgp = D_GRID, n = N_GRID, stringsAsFactors = FALSE)
stopifnot(nrow(CELLS) * B_REP <= N_STREAM)

#' One replication: one draw, all cardinalities, PAIRED.
#'
#' The anchor is restored before each L so the propensity's fit split and
#' operator_norm2()'s start vector are common across cardinalities, and the three
#' instruments are coarsenings of one W.  Without it every L-to-L difference
#' would be confounded with a different random split.
rep_one <- function(j, n, spec, off) {
  assign(".Random.seed", streams[[off + j]], envir = globalenv())
  d <- mdgp_draw(n, spec)
  anchor <- get(".Random.seed", envir = globalenv())
  out <- vector("list", length(L_GRID))
  names(out) <- as.character(L_GRID)
  for (i in seq_along(L_GRID)) {
    assign(".Random.seed", anchor, envir = globalenv())
    out[[i]] <- tryCatch(path_once(d, L_GRID[i]), error = function(e) NULL)
  }
  out
}

## CHECKPOINT.  The fingerprint covers the DESIGN -- the estimator sources, the
## DGP file, the grid and the three functions that turn a stream into a path --
## and NOT this file's md5, so editing the write-up reuses the run and editing
## the design does not.
CKPT <- file.path(OUT, "sim_multinomial_phistep_ckpt.rds")
CFG <- list(imax = IMAX, b = B_REP, n = N_GRID, L = L_GRID, d = D_GRID,
            eps = EPS_RHO, n_t = N_T, t_scale = T_SCALE, seed = 20260814L,
            stream_origin = "top-of-script, pre-validation",
            src = unname(tools::md5sum(here::here(
              "scripts", "R", c("lf_panel.R", "orthogonal_theta.R")))),
            dgp = unname(tools::md5sum(here::here(
              "scripts", "simulations", "sim_multinomial_dgp.R"))),
            driver = c(paste(deparse(lf_path), collapse = "\n"),
                       paste(deparse(path_once), collapse = "\n"),
                       paste(deparse(rep_one), collapse = "\n")))

RES <- vector("list", nrow(CELLS))                                    # INV-17
names(RES) <- sprintf("%s_n%d", CELLS$dgp, CELLS$n)
if (file.exists(CKPT)) {
  old <- readRDS(CKPT)
  if (identical(old$cfg, CFG)) {
    for (k in intersect(names(old$res), names(RES))) RES[[k]] <- old$res[[k]]
    message(sprintf("\n  reusing %d of %d cached cells (configuration unchanged)",
                    sum(!vapply(RES, is.null, logical(1))), length(RES)))
  } else {
    message("\n  cache discarded, configuration changed")
  }
}

## CHECKPOINTED PER CELL, not once at the end.  The n = 1,600 cells take about
## 37 minutes each, so a run interrupted in the last one used to lose the other
## eight.  Writes are atomic: to a temporary file, then renamed.
save_ckpt <- function() {
  tmp <- paste0(CKPT, ".tmp")
  saveRDS(list(cfg = CFG, res = RES, val = VAL), tmp)
  file.rename(tmp, CKPT)
}

if (any(vapply(RES, is.null, logical(1)))) {
  message("\n== V2-V4  ", B_REP, " paths per cell, ", length(L_GRID),
          " cardinalities, PAIRED ==")
  for (cc in seq_len(nrow(CELLS))) {
    if (!is.null(RES[[cc]])) next
    t0 <- Sys.time()
    raw <- parallel::mclapply(seq_len(B_REP), rep_one, n = CELLS$n[cc],
                              spec = MDGP_SPEC[[CELLS$dgp[cc]]],
                              off = (cc - 1L) * B_REP,
                              mc.cores = N_CORES, mc.preschedule = FALSE)
    ## TRY-ERROR GUARD.  mclapply() returns a "try-error" OBJECT for a worker
    ## that died; without this every downstream mean is silently NA.
    bad <- vapply(raw, function(z) inherits(z, "try-error") || !is.list(z),
                  logical(1))
    if (any(bad)) {
      message(sprintf("  *** %d of %d workers errored at %s ***", sum(bad),
                      B_REP, names(RES)[cc]))
      raw <- raw[!bad]
    }
    RES[[cc]] <- raw
    save_ckpt()
    message(sprintf("  %-16s %2d/%2d paths in %5.1f min", names(RES)[cc],
                    length(raw), B_REP,
                    as.numeric(difftime(Sys.time(), t0, units = "mins"))))
  }
}
DONE <- !vapply(RES, is.null, logical(1))
if (!all(DONE)) {
  message(sprintf("  PARTIAL RUN: %d of %d cells computed.", sum(DONE),
                  length(DONE)))
}

# ---- collapse --------------------------------------------------------------

#' Per-draw scalars for one (cell, L).
#'
#' oracle  argmin_m ISE(phi_m): the best iterate the path contains.
#' b_orc   the projection on the truth THERE.  Non-positive means there is
#'         nothing worth stopping at and no tau_dp can help.
#' rat_orc ||T-hat_m|| / delta-hat_n at the oracle.  THIS IS tau_dp.
#' m_dp    the index the shipped rule selects, NA when it never fires.
collapse <- function(cell, L) {
  key <- as.character(L)
  v <- lapply(cell, function(z) z[[key]])
  v <- v[!vapply(v, is.null, logical(1))]
  if (!length(v)) return(NULL)
  orc <- vapply(v, function(z) which.min(z$ise), integer(1))
  g <- function(f) vapply(seq_along(v), function(k) f(v[[k]], orc[k]),
                          numeric(1))
  data.frame(
    oracle  = orc,
    b_orc   = g(function(z, m) z$b[m]),
    ise_orc = g(function(z, m) z$ise[m]),
    rat_orc = g(function(z, m) z$ratio[m]),
    b_1     = g(function(z, m) z$b[1]),
    b_cap   = g(function(z, m) z$b[length(z$b)]),
    ise_1   = g(function(z, m) z$ise[1]),
    ise_cap = g(function(z, m) z$ise[length(z$ise)]),
    m_dp    = g(function(z, m) {
      h <- which(z$ratio <= TAU_SHIPPED); if (length(h)) h[1] else NA_real_ }),
    ise_dp  = g(function(z, m) {
      h <- which(z$ratio <= TAU_SHIPPED)
      z$ise[if (length(h)) h[1] else length(z$ise)] }),
    b_dp    = g(function(z, m) {
      h <- which(z$ratio <= TAU_SHIPPED)
      z$b[if (length(h)) h[1] else length(z$b)] }),
    rat_1   = g(function(z, m) z$ratio[1]),
    rat_cap = g(function(z, m) z$ratio[length(z$ratio)]),
    cste    = g(function(z, m) z$cste)
  )
}

TABL <- list()
for (cc in which(DONE)) for (L in L_GRID) {
  df <- collapse(RES[[cc]], L)
  if (is.null(df)) next
  TABL[[length(TABL) + 1L]] <- cbind(dgp = CELLS$dgp[cc], n = CELLS$n[cc],
                                     L = L, df)
}
TABL <- do.call(rbind, TABL)
saveRDS(list(paths = TABL, val = VAL),
        file.path(OUT, "sim_multinomial_phistep.rds"))

# ---- console report --------------------------------------------------------

ff  <- function(x, d = 3) formatC(x, format = "f", digits = d)
mse <- function(x) stats::sd(x, na.rm = TRUE) / sqrt(sum(!is.na(x)))
iqr <- function(x) sprintf("%s [%s, %s]", ff(stats::median(x, na.rm = TRUE), 2),
                           ff(stats::quantile(x, .25, na.rm = TRUE), 2),
                           ff(stats::quantile(x, .75, na.rm = TRUE), 2))

cat("\n\n===== V2/V3  ORACLE STOP AND THE RATIO THERE ======================\n")
cat("b   = <phi-hat, varphi>/||varphi||^2: 1 exact shape, 0 no information,\n")
cat("      < 0 ANTI-correlated.  Monte Carlo standard errors in parentheses.\n")
cat("rat = ||T-hat_m|| / delta-hat_n at the oracle stop; median [IQR].\n")
cat("      The shipped constant is tau_dp = ", TAU_SHIPPED, ".\n\n", sep = "")
cat(sprintf("%-10s %-5s %-2s %-16s %-16s %-18s %-8s\n", "design", "n", "L",
            "b at oracle", "oracle m", "ratio at oracle", "fired"))
for (dd in D_GRID) for (nn in N_GRID) for (L in L_GRID) {
  x <- TABL[TABL$dgp == dd & TABL$n == nn & TABL$L == L, ]
  if (!nrow(x)) next
  cat(sprintf("%-10s %-5d %-2d %-16s %-16s %-18s %-8s\n", dd, nn, L,
              sprintf("%s (%s)", ff(mean(x$b_orc)), ff(mse(x$b_orc))),
              iqr(x$oracle), iqr(x$rat_orc),
              sprintf("%d/%d", sum(!is.na(x$m_dp)), nrow(x))))
}

cat("\n\n===== V4  WHAT THE SHIPPED RULE COSTS =============================\n")
cat("ISE at the shipped stop against ISE at the oracle, and the paired gap in\n")
cat("Monte Carlo standard errors of the DIFFERENCE.\n\n")
cat(sprintf("%-10s %-5s %-2s %-10s %-10s %-10s %-12s %-10s\n", "design", "n",
            "L", "ISE m=1", "ISE orc", "ISE ship", "gap (se)", "b at ship"))
for (dd in D_GRID) for (nn in N_GRID) for (L in L_GRID) {
  x <- TABL[TABL$dgp == dd & TABL$n == nn & TABL$L == L, ]
  if (!nrow(x)) next
  dif <- x$ise_dp - x$ise_orc
  cat(sprintf("%-10s %-5d %-2d %-10s %-10s %-10s %-12s %-10s\n", dd, nn, L,
              ff(mean(x$ise_1), 4), ff(mean(x$ise_orc), 4),
              ff(mean(x$ise_dp), 4),
              sprintf("%s (%s)", ff(mean(dif), 4), ff(mse(dif), 4)),
              ff(mean(x$b_dp))))
}

cat("\n\n===== V2  THE PATH ITSELF: mean b_m at selected m =================\n")
cat("If b_m is non-positive at EVERY m the cell has nothing to stop at.\n\n")
MSHOW <- c(1L, 2L, 3L, 5L, 10L, 20L, 40L, 70L, 100L)
MSHOW <- MSHOW[MSHOW <= IMAX]
cat(sprintf("%-10s %-5s %-2s %s\n", "design", "n", "L",
            paste(sprintf("%8s", paste0("m=", MSHOW)), collapse = "")))
for (dd in D_GRID) for (nn in N_GRID) for (L in L_GRID) {
  cell <- RES[[sprintf("%s_n%d", dd, nn)]]
  if (is.null(cell)) next
  bb <- do.call(rbind, lapply(cell, function(z) z[[as.character(L)]]$b))
  if (is.null(bb)) next
  cat(sprintf("%-10s %-5d %-2d %s\n", dd, nn, L,
              paste(sprintf("%8s", ff(colMeans(bb)[MSHOW])), collapse = "")))
}

# ---- LaTeX tables (bare tabular, booktabs; INV-3, INV-13) ------------------

DTEX <- vapply(D_GRID, function(k) MDGP_SPEC[[k]]$tex, character(1))

write_tab <- function(lines, file) {
  writeLines(lines, file.path(TAB, file))
  message("  wrote ", file.path("paper", "tables", "sim", file))
}

## Table 1 -- design validity.
l <- c("\\begin{tabular}{llcccccc}", "\\toprule",
       paste("Design & $\\mathsf L$ & $\\max_j|t|$ &",
             "\\multicolumn{2}{c}{A1 at $\\varrho$} &",
             "\\multicolumn{2}{c}{A1 at $\\hat\\varrho$} &",
             "$\\mathbb{E}[(W-\\bar W)\\mathbf 1]$ \\\\"),
       "\\cmidrule(lr){4-5}\\cmidrule(lr){6-7}",
       " & & $\\mathbb{E}[\\Delta Z\\Delta U]$ & gap & $t$ & gap & $t$ & \\\\",
       "\\midrule")
for (dd in D_GRID) {
  for (L in L_GRID) {
    x <- VAL[VAL$dgp == dd & VAL$L == L, ]
    l <- c(l, sprintf("%s & %d & %s & %s & %s & %s & %s & %s \\\\",
                      if (L == L_GRID[1]) DTEX[[dd]] else "", L,
                      ff(x$zt, 2), ff(x$a1_true, 5), ff(x$a1_true_t, 1),
                      ff(x$a1_fit, 5), ff(x$a1_fit_t, 1), ff(x$uncond, 4)))
  }
  if (dd != D_GRID[length(D_GRID)]) l <- c(l, "\\addlinespace")
}
write_tab(c(l, "\\bottomrule", "\\end{tabular}"),
          "sim_multinomial_dgpvalid.tex")

## Table 2 -- the oracle stop and the discrepancy ratio there.
l <- c("\\begin{tabular}{llcccccc}", "\\toprule",
       paste("Design & $n$ & $\\mathsf L$ & $b$ at oracle & oracle $\\hat m$ &",
             "$\\|\\hat T\\|/\\hat\\delta_n$ & rule fires & $b$ at cap \\\\"),
       "\\midrule")
for (dd in D_GRID) {
  for (nn in N_GRID) for (L in L_GRID) {
    x <- TABL[TABL$dgp == dd & TABL$n == nn & TABL$L == L, ]
    if (!nrow(x)) next
    l <- c(l, sprintf("%s & %s & %d & %s & %s & %s & %d/%d & %s \\\\",
                      if (nn == N_GRID[1] && L == L_GRID[1]) DTEX[[dd]] else "",
                      if (L == L_GRID[1]) format(nn, big.mark = ",") else "", L,
                      sprintf("%s (%s)", ff(mean(x$b_orc)), ff(mse(x$b_orc))),
                      iqr(x$oracle), iqr(x$rat_orc),
                      sum(!is.na(x$m_dp)), nrow(x), ff(mean(x$b_cap))))
  }
  if (dd != D_GRID[length(D_GRID)]) l <- c(l, "\\addlinespace")
}
write_tab(c(l, "\\bottomrule", "\\end{tabular}"),
          "sim_multinomial_phistop.tex")

## Table 3 -- what the shipped rule costs.
l <- c("\\begin{tabular}{llccccc}", "\\toprule",
       paste("Design & $n$ & $\\mathsf L$ & ISE at $m=1$ & ISE at oracle &",
             "ISE at $\\tau_{\\mathrm{DP}}=0.7$ & gap (s.e.) \\\\"),
       "\\midrule")
for (dd in D_GRID) {
  for (nn in N_GRID) for (L in L_GRID) {
    x <- TABL[TABL$dgp == dd & TABL$n == nn & TABL$L == L, ]
    if (!nrow(x)) next
    dif <- x$ise_dp - x$ise_orc
    l <- c(l, sprintf("%s & %s & %d & %s & %s & %s & %s (%s) \\\\",
                      if (nn == N_GRID[1] && L == L_GRID[1]) DTEX[[dd]] else "",
                      if (L == L_GRID[1]) format(nn, big.mark = ",") else "", L,
                      ff(mean(x$ise_1), 4), ff(mean(x$ise_orc), 4),
                      ff(mean(x$ise_dp), 4), ff(mean(dif), 4), ff(mse(dif), 4)))
  }
  if (dd != D_GRID[length(D_GRID)]) l <- c(l, "\\addlinespace")
}
write_tab(c(l, "\\bottomrule", "\\end{tabular}"),
          "sim_multinomial_phicost.tex")

# ---- verdict ---------------------------------------------------------------

# ============================================================================
# V5  THE RECALIBRATION QUESTION, ANSWERED ON THE CACHED PATHS
#
# The brief this file answers asked for an L-aware tau_dp, or a recalibrated
# constant, that leaves L = 2 numerically unchanged.  V3 has already shown that
# the ratio at the oracle stop is NOT materially L-dependent, which is evidence
# AGAINST an L-aware constant.  This section makes that a decision rather than
# an impression, by running the rule itself over a grid of (tau, cap) and
# reading off which pair minimises ISE at each cardinality.
#
# It is pure post-processing on the paths already stored, so it costs seconds
# and no design is re-run for it.  The two knobs are the two the rule has:
#
#   tau  the discrepancy constant.  SMALLER tau stops LATER, because the rule
#        takes the first m whose ratio has fallen to tau.  This is worth saying
#        because the intuition runs the other way: the 2026-08-11 diagnosis
#        proposed RAISING tau so the rule would fire at L = 4, which would have
#        stopped it EARLIER still.
#   cap  m-bar, the iteration budget.  eq:lfsched's emptiness convention makes
#        the cap the estimator when the level is never reached, so the cap is
#        part of the rule and not a computational detail.
#
# The correctly-specified designs are what the choice is read off; `misspec` is
# reported alongside and EXCLUDED from the choice, because a constant tuned on a
# design that violates the nuisance-rate hypothesis would be a constant tuned to
# hide that violation.
# ============================================================================

## tau = 0 is on the grid on purpose: the rule can then never fire and the
## estimator is "run to the cap", so the sweep contains the NULL against which
## the discrepancy principle has to earn its place.  If a cap alone matches the
## best (tau, cap), the rule is buying nothing at that cardinality and that is
## worth knowing.
TAU_GRID <- c(0.00, 0.10, 0.20, 0.30, 0.40, 0.50, 0.60, 0.70, 0.85, 1.00)
CAP_GRID <- c(15L, 30L, 45L, 60L, 100L)
CLEAN <- D_GRID[vapply(D_GRID, function(k) MDGP_SPEC[[k]]$correct_spec,
                       logical(1))]
## THE CHOICE IS MADE ON ONE DESIGN AND CHECKED ON THE OTHER.  Minimising ISE
## over a grid on the same designs the recommendation is then reported for is
## in-sample tuning, and a constant chosen that way has no claim on any design
## it has not seen.  `balanced` is the training design and `skewed` is held out;
## `misspec` is excluded from both roles, because a constant tuned on a design
## that violates the nuisance-rate hypothesis would be a constant tuned to hide
## that violation.
D_TRAIN <- "balanced"
D_HOLD  <- "skewed"

#' The realised rule at (tau, cap): ISE and b at the index it selects.
#'
#' eq:lfsched(c)'s emptiness convention -- m-hat := m-bar when the level is
#' never reached -- is honoured, so the cap is the estimator on paths where the
#' rule does not fire and the sweep prices the whole rule rather than its
#' firing branch only.
rule_at <- function(z, tau, cap) {
  h <- which(z$ratio[seq_len(cap)] <= tau)
  m <- if (length(h)) h[1] else cap
  c(ise = z$ise[m], b = z$b[m], m = m, fired = as.numeric(length(h) > 0))
}

SWEEP <- list()                                                       # INV-17
for (cc in which(DONE)) for (L in L_GRID) {
  v <- lapply(RES[[cc]], function(z) z[[as.character(L)]])
  v <- v[!vapply(v, is.null, logical(1))]
  if (!length(v)) next
  for (tau in TAU_GRID) for (cap in CAP_GRID) {
    M <- do.call(rbind, lapply(v, rule_at, tau = tau, cap = cap))
    SWEEP[[length(SWEEP) + 1L]] <- data.frame(
      dgp = CELLS$dgp[cc], n = CELLS$n[cc], L = L, tau = tau, cap = cap,
      ise = mean(M[, "ise"]), se_ise = stats::sd(M[, "ise"]) / sqrt(nrow(M)),
      b = mean(M[, "b"]), m = stats::median(M[, "m"]),
      fired = mean(M[, "fired"]))
  }
}
SWEEP <- do.call(rbind, SWEEP)
saveRDS(SWEEP, file.path(OUT, "sim_multinomial_phistep_sweep.rds"))

cat("\n\n===== V5  (tau, cap) SWEEP, CORRECTLY-SPECIFIED DESIGNS ===========\n")
cat("Mean ISE of phi-hat at the index the rule selects.  Lower is better.\n")
cat("The shipped pair is tau = 0.7 with a cap of 60 (lf_panel.R's callers).\n\n")
for (L in L_GRID) {
  cat(sprintf("-- L = %d, pooled over %s and the whole n grid --\n", L,
              paste(CLEAN, collapse = " / ")))
  cat(sprintf("%-8s %s\n", "cap",
              paste(sprintf("%9s", paste0("tau=", ff(TAU_GRID, 2))),
                    collapse = "")))
  for (cap in CAP_GRID) {
    v <- vapply(TAU_GRID, function(tau) {
      x <- SWEEP[SWEEP$dgp %in% CLEAN & SWEEP$L == L & SWEEP$tau == tau &
                   SWEEP$cap == cap, ]
      mean(x$ise)
    }, numeric(1))
    cat(sprintf("%-8d %s%s\n", cap,
                paste(sprintf("%9s", ff(v, 4)), collapse = ""),
                sprintf("   <- best tau = %s", ff(TAU_GRID[which.min(v)], 2))))
  }
  cat("\n")
}

cat("CHOSEN ON `", D_TRAIN, "`, REPORTED ON THE HELD-OUT `", D_HOLD, "`:\n",
    sep = "")
cat("A pair that wins on the training design and does not carry to the held-out\n")
cat("one is a pair fitted to a design, not a calibration.\n\n")
cat(sprintf("%-3s %-14s %-20s %-20s %-8s\n", "L", "chosen (tau, cap)",
            "ISE on held-out", "ISE held-out at 0.7/60", "change"))
BEST <- list()                                                        # INV-17
for (L in L_GRID) {
  g <- expand.grid(tau = TAU_GRID, cap = CAP_GRID)
  pick <- function(dgp, tau, cap) {
    x <- SWEEP[SWEEP$dgp == dgp & SWEEP$L == L & SWEEP$tau == tau &
                 SWEEP$cap == cap, ]
    c(ise = mean(x$ise), se = sqrt(mean(x$se_ise^2) / nrow(x)))
  }
  g$ise <- vapply(seq_len(nrow(g)),
                  function(i) pick(D_TRAIN, g$tau[i], g$cap[i])[["ise"]],
                  numeric(1))
  k <- which.min(g$ise)
  ho   <- pick(D_HOLD, g$tau[k], g$cap[k])
  ship <- pick(D_HOLD, 0.70, 60L)
  BEST[[length(BEST) + 1L]] <- data.frame(
    L = L, tau = g$tau[k], cap = g$cap[k], ise_train = g$ise[k],
    ise_hold = ho[["ise"]], se_hold = ho[["se"]],
    ise_hold_ship = ship[["ise"]], se_hold_ship = ship[["se"]])
  cat(sprintf("%-3d (%s, %3d)   %-20s %-20s %+7.1f%%\n", L, ff(g$tau[k], 2),
              g$cap[k], sprintf("%s (%s)", ff(ho[["ise"]], 4),
                                ff(ho[["se"]], 4)),
              sprintf("%s (%s)", ff(ship[["ise"]], 4), ff(ship[["se"]], 4)),
              100 * (ho[["ise"]] / ship[["ise"]] - 1)))
}
BEST <- do.call(rbind, BEST)
saveRDS(BEST, file.path(OUT, "sim_multinomial_phistep_best.rds"))

## Table 4 -- the sweep, and what it says about the shipped pair.
l <- c(sprintf("\\begin{tabular}{%s}",
               paste0("lc", strrep("c", length(TAU_GRID)))), "\\toprule",
       paste("$\\mathsf L$ & $\\bar m$ &",
             paste(sprintf("$\\tau=%s$", ff(TAU_GRID, 2)), collapse = " & "),
             "\\\\"),
       "\\midrule")
for (L in L_GRID) {
  for (cap in CAP_GRID) {
    v <- vapply(TAU_GRID, function(tau) {
      x <- SWEEP[SWEEP$dgp %in% CLEAN & SWEEP$L == L & SWEEP$tau == tau &
                   SWEEP$cap == cap, ]
      mean(x$ise)
    }, numeric(1))
    cell <- ff(v, 4)
    cell[which.min(v)] <- sprintf("\\textbf{%s}", cell[which.min(v)])
    l <- c(l, sprintf("%s & %d & %s \\\\", if (cap == CAP_GRID[1]) L else "",
                      cap, paste(cell, collapse = " & ")))
  }
  if (L != L_GRID[length(L_GRID)]) l <- c(l, "\\addlinespace")
}
write_tab(c(l, "\\bottomrule", "\\end{tabular}"), "sim_multinomial_tau.tex")

# ---- figure: the path itself -----------------------------------------------
#
# The table reports the oracle and the shipped stop; what it cannot show is the
# SHAPE of the path, which is the whole argument.  On a design whose propensity
# is in the fitted family, b_m rises from the initial condition and plateaus; on
# `misspec` it falls through zero and keeps going, because the criterion's zero
# is not varphi.  No title inside the figure (INV-12); the caption carries it.

if (requireNamespace("ggplot2", quietly = TRUE)) {
  fig_dir <- file.path(OUT_ROOT, "paper", "figures", "sim")
  dir.create(fig_dir, showWarnings = FALSE, recursive = TRUE)
  fd <- list()                                                        # INV-17
  for (dd in D_GRID) for (nn in N_GRID) for (L in L_GRID) {
    cell <- RES[[sprintf("%s_n%d", dd, nn)]]
    if (is.null(cell)) next
    bb <- do.call(rbind, lapply(cell, function(z) z[[as.character(L)]]$b))
    if (is.null(bb)) next
    fd[[length(fd) + 1L]] <- data.frame(
      dgp = DTEX[[dd]], n = nn, L = factor(L), m = seq_len(ncol(bb)),
      b = colMeans(bb),
      lo = colMeans(bb) - 1.96 * apply(bb, 2L, stats::sd) / sqrt(nrow(bb)),
      hi = colMeans(bb) + 1.96 * apply(bb, 2L, stats::sd) / sqrt(nrow(bb)))
  }
  fd <- do.call(rbind, fd)
  fd$panel <- factor(sprintf("%s, $n$ = %s", fd$dgp,
                             format(fd$n, big.mark = ",")),
                     levels = unique(sprintf("%s, $n$ = %s", fd$dgp,
                                             format(fd$n, big.mark = ","))))
  ## Panel strips are drawn inside the figure where no LaTeX runs, so they must
  ## read as English.
  levels(fd$panel) <- gsub("\\$n\\$", "n", gsub("\\$\\\\hat\\\\varrho\\$",
                                                "rho-hat", levels(fd$panel)))
  p <- ggplot2::ggplot(fd[fd$n == max(N_GRID), ],
                       ggplot2::aes(m, b, colour = L, linetype = L,
                                    shape = L)) +
    ggplot2::geom_hline(yintercept = c(0, 1), colour = "grey60",
                        linewidth = 0.35) +
    ggplot2::geom_ribbon(ggplot2::aes(ymin = lo, ymax = hi, fill = L),
                         alpha = 0.15, colour = NA) +
    ggplot2::geom_line(linewidth = 0.5) +
    ggplot2::geom_point(data = function(z) z[z$m %% 20 == 0, ], size = 1.6) +
    ggplot2::facet_wrap(~panel) +
    ggplot2::scale_colour_brewer(palette = "Set2") +
    ggplot2::scale_fill_brewer(palette = "Set2") +
    ggplot2::labs(x = "Landweber iteration m",
                  y = expression(paste("Projection ", italic(b)[m],
                                       " on the truth")),
                  colour = "Cells", linetype = "Cells", shape = "Cells",
                  fill = "Cells") +
    ggplot2::theme_minimal(base_family = "serif", base_size = 10) +
    ggplot2::theme(panel.grid.minor = ggplot2::element_blank(),
                   strip.text = ggplot2::element_text(face = "bold"),
                   legend.position = "bottom")
  ggplot2::ggsave(file.path(fig_dir, "sim_multinomial_phipath.pdf"), p,
                  width = 6.5, height = 2.8, device = grDevices::cairo_pdf)
  message("  wrote paper/figures/sim/sim_multinomial_phipath.pdf")
}

cat("\n\n===== VERDICT =====================================================\n")
for (dd in D_GRID) {
  x4 <- TABL[TABL$dgp == dd & TABL$L == 4L & TABL$n == max(N_GRID), ]
  x2 <- TABL[TABL$dgp == dd & TABL$L == 2L & TABL$n == max(N_GRID), ]
  if (!nrow(x4)) next
  t4 <- mean(x4$b_dp) / mse(x4$b_dp)
  cat(sprintf("%-10s n = %d:  b at the shipped stop is %s (%s) at L = 4 and %s (%s) at L = 2;\n",
              dd, max(N_GRID), ff(mean(x4$b_dp)), ff(mse(x4$b_dp)),
              ff(mean(x2$b_dp)), ff(mse(x2$b_dp))))
  cat(sprintf("%-10s          that is %+.1f Monte Carlo standard errors from zero at L = 4;\n",
              "", t4))
  cat(sprintf("%-10s          the rule fires on %d of %d paths at L = 4.\n", "",
              sum(!is.na(x4$m_dp)), nrow(x4)))
}
cat("\ndone\n")
