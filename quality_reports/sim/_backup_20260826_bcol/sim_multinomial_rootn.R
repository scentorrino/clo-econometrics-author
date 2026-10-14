# ============================================================================
# sim_multinomial_rootn.R
#
# thm:rootn AT L = 2, 3 AND 4, ON THE SHIPPED ESTIMATOR.
#
#   Rscript scripts/simulations/sim_multinomial_rootn.R
#
# ---------------------------------------------------------------------------
# THE CLAIM UNDER TEST
#
# thm:rootn: sqrt(n) (theta-hat - theta) -> N(0, Sigma), for the orthogonal
# one-step of eq:onestep run on the cross-fitted moment of def:crossfit, with an
# L-VALUED discrete instrument.  The theory is written at general L throughout --
# eq:contrast's Wtilde is a column of L - 1 contrasts, B1(iv.d)'s Pi_w is a
# probability measure on {1,...,L-1}, A4(i)'s eq:trunset is a simplex in
# R^{L-1} -- while the paper's Monte Carlo section is BINARY on both designs:
# sim_thm_rootn_dgp.R:469 and sim_thm_rootn_headroom_dgp.R:341 are each
# `pw <- cbind(1 - rr, rr)`.  Section 6 estimates on a four-category trigger.
# This file is the general-L verification the section was missing.
#
# ---------------------------------------------------------------------------
# WHAT IS VERIFIED, IN ORDER
#
#   R1  CONSISTENCY.  Bias by coordinate against n, with Monte Carlo standard
#       errors, at L = 2, 3, 4.
#   R2  THE RATE.  sqrt(n) x sd(theta-hat) is a CONSTANT under thm:rootn.  It is
#       reported across the grid; a trend in it is a rate that is not sqrt(n).
#   R3  THE LIMIT LAW, through its most demanding observable: COVERAGE of the
#       nominal 95% interval built from the sandwich the shipped estimator
#       already returns, V = J^{-1} (Psi'Psi/n) J^{-T}/n.  Coverage is reported
#       with the Wald interval for a proportion, so a reader can see whether a
#       departure from 0.95 is larger than Monte Carlo error.
#   R4  DOES THE SURPLUS BUY PRECISION?  PAIRED across cardinalities: the arms
#       share the draw AND the cross-fitting partition, so the standard error is
#       on the within-draw difference and the claim can fail.
#   R5  WHAT PROPENSITY MISSPECIFICATION COSTS, by coordinate.  The `misspec`
#       design violates thm:rootn's nuisance-rate hypothesis ((T-4),
#       eq:foldrates) on purpose and is labelled as a violation, not as a
#       failure of the theorem.
#
# ---------------------------------------------------------------------------
# DESIGN DECISIONS
#
# S1. ARMS ARE PAIRED ON THE PARTITION STREAM.  crossfit_once() consumes the RNG
#     at four places -- the fold assignment, the operator/solve split,
#     balance_gram()'s median-heuristic subsample and operator_norm2()'s start
#     vector -- so running L = 2 and then L = 4 in sequence gives them different
#     partitions and confounds every arm-to-arm difference with a partition
#     difference.  The RNG state is captured after the draw and RESTORED before
#     each arm.  Device: app_tsp_08_localise.R's ANCHOR.
#
# S2. EVERY ARM IS SUMMARISED ON THE COMMON SUBSET OF DRAWS.  Filtering each arm
#     on its own complete.cases would compare arms on different draws, and the
#     draws an arm fails on are the extreme-propensity draws the question is
#     about.
#
# S3. ONE NEWTON STEP FROM THE PLUG-IN OLS START, at a SINGLE partition, which is
#     eq:onestep and is what app_tsp_common.R's fit_one_partition() does.  The
#     variance is orthogonal_theta()'s own:
#     V = J1^{-1} (Psi1'Psi1/n) J1^{-T} / n evaluated at the one-step iterate.
#
# S4. lf_imax IS SET FROM THE phi-STEP ARM'S MEASURED STOPPING INDICES, not
#     guessed.  sim_multinomial_phistep.R reports where the discrepancy rule
#     fires; the cap is set well above it so that it binds on essentially no
#     replication, and the realised share of cap hits is REPORTED so a reader can
#     check that.
#
# ---------------------------------------------------------------------------
# RUNTIME, AND WHY B = 120 AND NOT 200.  Measured reference:
# sim_multinomial_onestep.R takes 50 minutes at B = 80, n in {400, 800, 1600},
# 4 arms, 8 cores -- 75 core-seconds per (draw, arm) summed over the grid, with
# cost scaling as n^2, so the three rows cost 3.6, 14.3 and 57.1 core-seconds.
# At 3 cardinalities and 3 designs that is 13 minutes, 54 minutes and 3.6 hours
# for the three rows: B = 200 is 4.4 hours and B = 120 is 2.7.
#
# B = 120 IS CHOSEN AND THE COST IS STATED RATHER THAN HIDDEN.  At n = 1600 the
# slope coefficients have sampling standard deviation about 0.074, so the Monte
# Carlo standard error on a MARGINAL bias is 0.0068 at B = 120 against 0.0053 at
# B = 200 -- the difference between the two designs is not what any conclusion
# here turns on.  Coverage is the coarsest quantity: its standard error is 0.020
# at B = 120, so a departure from 0.95 is resolvable at about 0.04 and no finer,
# and the tables report that standard error next to every coverage figure.
# The COMPARATIVE claims -- does L = 4 beat L = 2, does the bias shrink -- are
# PAIRED, so their standard errors are on within-draw differences and are
# roughly an order of magnitude smaller; those are the claims B = 120 is chosen
# to support.  Raise it with SIM_B; the checkpoint discards cleanly.
#
# The run is CHECKPOINTED PER CELL and cells are ordered n ascending, so a run
# cut short still writes tables for the rows it reached.  SIM_B and SIM_NMAX
# override the grid for a short run.
# ============================================================================

suppressMessages({                                                    # INV-15
  library(here)
  library(parallel)
})
source(here::here("scripts", "R", "lf_panel.R"))
source(here::here("scripts", "R", "orthogonal_theta.R"))
source(here::here("scripts", "simulations", "sim_multinomial_dgp.R"))

RNGkind("L'Ecuyer-CMRG")
set.seed(20260815L)                                                   # INV-14

## THE REPLICATION STREAMS ARE DRAWN FIRST, BEFORE ANYTHING ELSE CAN CONSUME THE
## GENERATOR, so they are a function of the declared seed and of nothing else.
## Built further down they would depend on how much randomness any diagnostic
## inserted above them happened to use.
N_STREAM <- 4096L
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

B_REP   <- as.integer(Sys.getenv("SIM_B", unset = "120"))
N_MAX   <- as.integer(Sys.getenv("SIM_NMAX", unset = "1600"))
N_GRID  <- c(400L, 800L, 1600L)
N_GRID  <- N_GRID[N_GRID <= N_MAX]
L_GRID  <- c(2L, 3L, 4L)
D_GRID  <- c("balanced", "skewed", "misspec")
## CORE COUNT DOES NOT AFFECT THE NUMBERS, unlike the Part I arms.  Those set
## mc.cores to a fixed SIM_CORES because they run mc.preschedule = TRUE, under
## which the replication -> L'Ecuyer substream map is a function of mc.cores and
## a host with a different core count produces different tables.  Here every
## replication is handed its stream EXPLICITLY by index (streams[[off + j]]) and
## mc.preschedule = FALSE, so the map is independent of the schedule and the
## core count buys wall time only.
N_CORES <- as.integer(Sys.getenv("SIM_CORES", unset = "8"))
K_FOLD  <- 5L
## LF_IMAX = 100 AND LF_PAT = 30, WHICH IS S4 HONOURED RATHER THAN ASSERTED.
## sim_multinomial_phistep.R measured where the oracle stop sits: median 19-28
## iterations at L = 2 but 68-100 at L = 4, and b_m is still rising at m = 100
## there.  A cap of 60 -- sim_multinomial_onestep.R's -- therefore TRUNCATES the
## L = 4 arm and would put a known-underconverged phi-hat into the theta step,
## making any L = 4 intercept a statement about the cap.  100 is the phi-step
## arm's own budget, so the two arms are on the same one and that arm's (tau,
## cap) sweep speaks directly to this one's configuration.  LF_PAT is
## crossfit_once()'s default.  The realised share of cap hits is REPORTED.
LF_IMAX <- 100L
LF_PAT  <- 30L
EPS_RHO <- 0.03
N_T     <- 16L
T_SCALE <- 0.25
ALPHA   <- 0.05
P_DIM   <- 3L
COEF_TEX <- c("Constant", "$z_1$", "$z_2$")

#' The orthogonal one-step on one draw, at one cardinality.
#'
#' Mirrors fit_one_partition() in scripts/application/app_tsp_common.R and
#' orthogonal_theta()'s inner loop: plug-in OLS start, ONE Newton step on the
#' orthogonal moment, sandwich variance at the one-step iterate.  `J` from
#' eval_moment() is the negative of eq:Jhat, so th0 - J^{-1} psibar is
#' eq:onestep's th0 + Jhat^{-1} psibar; the sandwich is invariant to the sign.
#'
#' @param d list from mdgp_draw().
#' @param L integer cardinality.
#' @return list: theta (p), se (p), bind_rate, cap_share, phi_b, disc.
one_step <- function(d, L) {
  w <- mdgp_inst(d, L)
  n <- length(w)
  cf <- crossfit_once(d$y, d$x1, d$x2, d$Z, w, K = K_FOLD, cste = NULL,
                      lf_imax = LF_IMAX, lf_patience = LF_PAT, n_t = N_T,
                      t_scale = T_SCALE, adj_wtil = TRUE, conditional = TRUE,
                      eps_rho = EPS_RHO, verbose = FALSE)
  th0 <- stats::lm.fit(d$Z, d$y - cf$dphi)$coefficients
  th0[!is.finite(th0)] <- 0
  m0 <- cf$eval_moment(th0)
  J0i <- tryCatch(solve(m0$J), error = function(e) MASS::ginv(m0$J))
  th1 <- as.vector(th0 - J0i %*% colMeans(m0$psi))
  m1 <- cf$eval_moment(th1)
  J1i <- tryCatch(solve(m1$J), error = function(e) MASS::ginv(m1$J))
  V <- J1i %*% (crossprod(m1$psi) / n) %*% t(J1i) / n
  stopifnot(length(th1) == P_DIM, all(is.finite(th1)))
  ## phi-hat's projection on the truth, on the SAME evaluation grid the
  ## cross-fit reports it on.  The intercept is where a shape error in phi-hat
  ## lands -- the plug-in regresses dY - d(phi-hat) on dZ and dZ's first column
  ## is the constant -- so the two have to be read together.
  phi0 <- MDGP_PHI(cf$xeval); phi0 <- phi0 - mean(phi0)
  ph <- cf$phi_grid - mean(cf$phi_grid)
  ## summarise_prop_diag() returns NULL when no propensity fit recorded a
  ## payload; assigning NULL into the record vector would error the whole
  ## replication over a diagnostic.  NA_real_ keeps the replication and makes
  ## the gap visible in the table.
  pd <- cf$prop_diag
  list(theta = th1, se = sqrt(pmax(diag(V), 0)),
       bind_rate = if (is.null(pd$bind_rate)) NA_real_ else pd$bind_rate,
       cap_share = mean(vapply(cf$lf_info, function(z) isTRUE(z$hit_cap),
                               logical(1))),
       stop_med = stats::median(vapply(cf$lf_info,
                                       function(z) as.integer(z$iter),
                                       integer(1))),
       phi_b = sum(ph * phi0) / sum(phi0^2),
       phi_ise = mean((ph - phi0)^2),
       disc = mean(cf$disc))
}

# ============================================================================
# the Monte Carlo
# ============================================================================

## Cells are ordered n ASCENDING, so a run cut short holds the whole
## design x cardinality grid at the sample sizes it reached rather than one
## design at every sample size.  Every summary below skips cells that have not
## been computed, so a partial run still writes usable tables and a resumed run
## fills them in.
CELLS <- expand.grid(dgp = D_GRID, n = N_GRID, stringsAsFactors = FALSE)
CELLS <- CELLS[order(CELLS$n, match(CELLS$dgp, D_GRID)), ]
rownames(CELLS) <- NULL

## Column layout of one replication's record.  Fixed here so the summariser and
## the estimator agree by construction rather than by matching integers.
KEYS <- sprintf("L%d", L_GRID)
COLS <- c(as.vector(outer(sprintf("th%d", seq_len(P_DIM)), KEYS, paste,
                          sep = "_")),
          as.vector(outer(sprintf("se%d", seq_len(P_DIM)), KEYS, paste,
                          sep = "_")),
          paste0("bind_", KEYS), paste0("cap_", KEYS), paste0("stop_", KEYS),
          paste0("phib_", KEYS), paste0("phiise_", KEYS),
          paste0("disc_", KEYS), paste0("ok_", KEYS))
TH_IDX <- lapply(KEYS, function(k)
  match(sprintf("th%d_%s", seq_len(P_DIM), k), COLS))
SE_IDX <- lapply(KEYS, function(k)
  match(sprintf("se%d_%s", seq_len(P_DIM), k), COLS))
names(TH_IDX) <- names(SE_IDX) <- KEYS

stopifnot(nrow(CELLS) * B_REP <= N_STREAM)

#' One replication: the SAME draw at every cardinality, from the SAME partition
#' stream (S1).
rep_one <- function(j, n, spec, off) {
  assign(".Random.seed", streams[[off + j]], envir = globalenv())
  d <- mdgp_draw(n, spec)
  anchor <- get(".Random.seed", envir = globalenv())
  out <- stats::setNames(rep(NA_real_, length(COLS)), COLS)
  for (i in seq_along(L_GRID)) {
    assign(".Random.seed", anchor, envir = globalenv())
    k <- KEYS[i]
    r <- tryCatch(one_step(d, L_GRID[i]), error = function(e) NULL)
    if (is.null(r)) { out[paste0("ok_", k)] <- 0; next }
    out[TH_IDX[[k]]] <- r$theta
    out[SE_IDX[[k]]] <- r$se
    out[paste0("bind_", k)]   <- r$bind_rate
    out[paste0("cap_", k)]    <- r$cap_share
    out[paste0("stop_", k)]   <- r$stop_med
    out[paste0("phib_", k)]   <- r$phi_b
    out[paste0("phiise_", k)] <- r$phi_ise
    out[paste0("disc_", k)]   <- r$disc
    out[paste0("ok_", k)]     <- 1
  }
  out
}

## CHECKPOINT, PER CELL **AND PER BLOCK OF REPLICATIONS WITHIN A CELL**.
##
## THE PER-CELL STAGE WAS NOT ENOUGH, AND THE ARITHMETIC IS THE WHOLE ARGUMENT.
## Re-profiled 2026-08-25 at one draw per cell: 3.61 / 6.82 / 4.30 s at n = 400,
## 14.68 / 10.93 / 15.98 at n = 800 and 59.11 / 68.41 / 116.30 at n = 1,600, for
## 36,017 core-seconds over the grid at B = 120.  At the four-fold effective
## parallelism this box delivers on eight logical cores over four physical ones,
## the n = 1,600 `misspec` cell ALONE is 116.30 x 120 / 4 = 3,489 s -- 58 minutes
## of work that the per-cell stage could not break, against a background-job cap
## near 65.  A CELL THAT OVERRUNS THE CAP DOES NOT FAIL INTERMITTENTLY: it is
## killed at the same point on every retry and never completes, so the arm would
## have burned the whole grid and then still needed this edit.  The estimate
## rests on ONE draw per cell, so a 15 per cent mean overrun is enough to put it
## there; the stage is therefore a BLOCK of CKPT_CHUNK replications.
##
## WHY BLOCKING IS BIT-EXACT.  rep_one(j, n, spec, off) opens with
## assign(".Random.seed", streams[[off + j]]) and `streams` is built once from
## this script's single seed before anything is drawn, so replication j's state
## is a function of the seed and of j alone and never of how many replications
## preceded it in the process.  Any partition of seq_len(B_REP) into blocks
## returns exactly what no partition returns.  The block nevertheless stores
## .Random.seed beside its value and restores it on a hit -- the convention of
## sim_thm_rootn_bdrylayer.R -- which keeps the parent stream position identical
## to an uninterrupted run and keeps the guarantee alive if an inline draw is
## ever added between cells.
##
## THE KEY IS THE DESIGN **AND** THE SOURCES, WHICH TIGHTENS WHAT THIS FILE USED
## TO SAY.  The paragraph replaced here read "and NOT this file's md5, so editing
## the write-up reuses the run".  That trade is right for a whole cell and wrong
## for a block inside one: CFG deparses one_step and rep_one, which does not
## cover a helper they call, and a resume that mixes vintages WITHIN a cell is
## indistinguishable from a clean one downstream.  A stale resume ships wrong
## numbers; an over-eager discard only costs time.  Same stance as
## sim_multinomial_onestep.R, and the cost is the same asymmetry: edit before
## launching, not during.  Writes stay atomic (temporary, then rename).
CKPT <- file.path(OUT, "sim_multinomial_rootn_ckpt.rds")
## Sized so one block stays well clear of the cap in the worst cell: 24 draws of
## the n = 1,600 `misspec` cell is about 12 minutes at the parallelism measured
## above, and 24 divides B_REP = 120 exactly.  SIM_CHUNK overrides it so the
## resumption can be exercised at a size a person will actually re-run; it is
## deliberately NOT part of CFG, because the block size is an execution detail
## and changing it must not discard completed CELLS.
CKPT_CHUNK <- as.integer(Sys.getenv("SIM_CHUNK", unset = "24"))
CKPT_SRC   <- c(here::here("scripts", "simulations",
                           c("sim_multinomial_rootn.R",
                             "sim_multinomial_dgp.R")),
                here::here("scripts", "R",
                           c("lf_panel.R", "orthogonal_theta.R")))
CKPT_KEY   <- paste(unname(tools::md5sum(CKPT_SRC)), collapse = " ")
CFG <- list(b = B_REP, n = N_GRID, L = L_GRID, d = D_GRID, k = K_FOLD,
            lf_imax = LF_IMAX, lf_pat = LF_PAT, eps = EPS_RHO, n_t = N_T,
            t_scale = T_SCALE, seed = 20260815L, cols = COLS,
            src = unname(tools::md5sum(here::here(
              "scripts", "R", c("lf_panel.R", "orthogonal_theta.R")))),
            dgp = unname(tools::md5sum(here::here(
              "scripts", "simulations", "sim_multinomial_dgp.R"))),
            driver = c(paste(deparse(one_step), collapse = "\n"),
                       paste(deparse(rep_one), collapse = "\n")))

RES <- vector("list", nrow(CELLS))                                    # INV-17
names(RES) <- sprintf("%s_n%d", CELLS$dgp, CELLS$n)
NFAIL <- integer(nrow(CELLS))
## An ENVIRONMENT rather than `<<-`, which is a prohibited pattern in this
## project's R standard (.claude/references/coding-standards-r.md section 9).
CK_ENV <- new.env(parent = emptyenv())
CK_ENV$part <- list()
if (file.exists(CKPT)) {
  old <- readRDS(CKPT)
  if (identical(old$cfg, CFG) && identical(old$key, CKPT_KEY)) {
    for (k in names(old$res)) {
      if (k %in% names(RES) && !is.null(old$res[[k]])) {
        RES[[k]] <- old$res[[k]]
        NFAIL[match(k, names(RES))] <- old$nfail[[k]]
      }
    }
    if (!is.null(old$part)) CK_ENV$part <- old$part
    message(sprintf("  resuming: %d of %d cells complete, %d part-block(s) held",
                    sum(!vapply(RES, is.null, logical(1))), length(RES),
                    length(CK_ENV$part)))
  } else if (identical(old$cfg, CFG)) {
    message("  cache discarded, a source file changed since it was written")
  } else {
    message("  cache discarded, configuration changed")
  }
}

save_ckpt <- function() {
  tmp <- paste0(CKPT, ".tmp")
  saveRDS(list(cfg = CFG, key = CKPT_KEY, res = RES, part = CK_ENV$part,
               nfail = stats::setNames(as.list(NFAIL), names(RES))), tmp)
  ## Atomic: a kill DURING the write would otherwise leave a truncated
  ## checkpoint, which is worse than none -- the next readRDS() would fail and
  ## take every completed cell with it.  rename() is atomic within a filesystem.
  file.rename(tmp, CKPT)
}

#' Evaluate `expr` once, or restore it together with the RNG state it left.
#'
#' @param tag character(1). Block name; must be stable across runs.
#' @param expr expression. Evaluated lazily, and NOT at all on a cache hit.
#' @return the block's value.
staged <- function(tag, expr) {
  hit <- CK_ENV$part[[tag]]
  if (!is.null(hit)) {
    assign(".Random.seed", hit$seed, envir = globalenv())
    message(sprintf("    [ckpt] restored block '%s'", tag))
    return(hit$value)
  }
  v  <- expr
  pt <- CK_ENV$part
  pt[[tag]] <- list(value = v,
                    seed = get(".Random.seed", envir = globalenv()))
  CK_ENV$part <- pt
  save_ckpt()
  v
}

## SIM_SUMMARISE_ONLY reads the checkpoint and writes the tables WITHOUT
## computing anything.  The n = 1,600 row costs about three hours; without this
## the only way to see the rows already finished is to wait for it, and the
## temptation is then to tabulate them by hand somewhere else, which is how a
## table stops being reproducible.  Table generation stays in exactly one place.
SUMMARISE_ONLY <- nzchar(Sys.getenv("SIM_SUMMARISE_ONLY"))

message("== thm:rootn at L = 2, 3, 4: ", B_REP, " replications per cell, ",
        nrow(CELLS), " cells, ARMS PAIRED ON THE PARTITION STREAM ==")
for (cc in seq_len(nrow(CELLS))) {
  if (!is.null(RES[[cc]]) || SUMMARISE_ONLY) next
  t0 <- Sys.time()
  ## Block boundaries from an explicit group index, NOT split(x, ceiling(x/k)):
  ## split() names its groups as CHARACTER, so past nine blocks "10" would sort
  ## between "1" and "2".  The tags below are built from the range rather than
  ## the group number, so they are immune to that -- but the ORDER of evaluation
  ## would still have moved, and with it which block a kill lands in.
  idx_all <- seq_len(B_REP)
  grp     <- ceiling(idx_all / CKPT_CHUNK)
  chunks  <- lapply(sort(unique(grp)), function(g) idx_all[grp == g])
  M <- matrix(NA_real_, B_REP, length(COLS),                          # INV-17
              dimnames = list(NULL, COLS))
  bad_all <- rep(TRUE, B_REP)
  for (ch in seq_along(chunks)) {
    jj  <- chunks[[ch]]
    ## The tag names the cell and the replications it holds, so a block written
    ## under one B_REP or one SIM_CHUNK cannot be restored as another's.
    tag <- sprintf("%s_rep%04d-%04d", names(RES)[cc], min(jj), max(jj))
    got <- staged(tag, {
      ## jj carries the GLOBAL replication indices within the cell, not
      ## 1..length(jj), because rep_one() reads streams[[off + j]].  Passing the
      ## global index is what makes a blocked run and an unblocked one draw the
      ## same samples.
      raw <- parallel::mclapply(jj, rep_one, n = CELLS$n[cc],
                                spec = MDGP_SPEC[[CELLS$dgp[cc]]],
                                off = (cc - 1L) * B_REP,
                                mc.cores = N_CORES, mc.preschedule = FALSE)
      ## TRY-ERROR GUARD.  mclapply() returns a "try-error" OBJECT for a worker
      ## that died; rbind()-ing them silently produces a character matrix and
      ## every downstream mean becomes NA.  Precedent: app_tsp_common.R:606.
      bad <- vapply(raw, function(z) inherits(z, "try-error") || !is.numeric(z) ||
                      length(z) != length(COLS), logical(1))
      Mc <- matrix(NA_real_, length(jj), length(COLS),                # INV-17
                   dimnames = list(NULL, COLS))
      for (b in seq_along(jj)) if (!bad[b]) Mc[b, ] <- raw[[b]]
      list(M = Mc, bad = bad)
    })
    M[jj, ]     <- got$M
    bad_all[jj] <- got$bad
  }
  NFAIL[cc] <- sum(bad_all)
  RES[[cc]] <- M
  ## The cell is complete, so its blocks are a second copy of it.  Dropped
  ## before the write, in the SAME atomic save that records the cell -- there is
  ## no window in which neither is on disk.
  CK_ENV$part <- CK_ENV$part[!grepl(sprintf("^%s_rep", names(RES)[cc]),
                                    names(CK_ENV$part))]
  if (!SUMMARISE_ONLY) save_ckpt()
  ## Elapsed covers the UNCACHED blocks only, so on a resumed run it is not the
  ## cell's cost.  Said here rather than left to be misread.
  message(sprintf("  %-16s %3d/%3d in %5.1f min of fresh compute",
                  names(RES)[cc], B_REP - sum(bad_all), B_REP,
                  as.numeric(difftime(Sys.time(), t0, units = "mins"))))
}

# ---- summaries -------------------------------------------------------------

#' Summarise one arm on a GIVEN row subset (S2).
summarise_arm <- function(M, key, keep) {
  X <- M[keep, TH_IDX[[key]], drop = FALSE]
  S <- M[keep, SE_IDX[[key]], drop = FALSE]
  b <- nrow(X)
  bias <- colMeans(X) - MDGP_THETA_FULL
  sdv  <- apply(X, 2L, stats::sd)
  cov  <- colMeans(abs(sweep(X, 2L, MDGP_THETA_FULL, "-")) <=
                     stats::qnorm(1 - ALPHA / 2) * S)
  list(n_used = b, bias = bias, se_bias = sdv / sqrt(b), sd = sdv,
       rmse = sqrt(colMeans(sweep(X, 2L, MDGP_THETA_FULL, "-")^2)),
       se_ratio = colMeans(S) / sdv,
       cover = cov, se_cover = sqrt(cov * (1 - cov) / b),
       phi_b = mean(M[keep, paste0("phib_", key)], na.rm = TRUE),
       se_phi_b = stats::sd(M[keep, paste0("phib_", key)], na.rm = TRUE) /
         sqrt(b),
       phi_ise = mean(M[keep, paste0("phiise_", key)], na.rm = TRUE),
       bind = mean(M[keep, paste0("bind_", key)], na.rm = TRUE),
       cap = mean(M[keep, paste0("cap_", key)], na.rm = TRUE),
       stop_med = stats::median(M[keep, paste0("stop_", key)], na.rm = TRUE))
}

#' Paired difference between two arms, coordinate by coordinate.
paired_diff <- function(M, key_a, key_b, keep) {
  D <- M[keep, TH_IDX[[key_a]], drop = FALSE] -
       M[keep, TH_IDX[[key_b]], drop = FALSE]
  list(mean = colMeans(D), se = apply(D, 2L, stats::sd) / sqrt(nrow(D)))
}

SUM <- vector("list", nrow(CELLS) * length(KEYS))                     # INV-17
KEEPS <- vector("list", nrow(CELLS))
DONE <- !vapply(RES, is.null, logical(1))
if (!all(DONE)) {
  message(sprintf("  PARTIAL RUN: %d of %d cells computed; tables cover %s.",
                  sum(DONE), length(DONE),
                  paste(names(RES)[DONE], collapse = ", ")))
}
i <- 0L
for (cc in which(DONE)) {
  M <- RES[[cc]]
  ok <- M[, paste0("ok_", KEYS), drop = FALSE]
  keep <- stats::complete.cases(M[, unlist(TH_IDX), drop = FALSE]) &
    rowSums(ok == 1, na.rm = TRUE) == length(KEYS)
  KEEPS[[cc]] <- keep
  for (k in KEYS) {
    i <- i + 1L
    a <- summarise_arm(M, k, keep)
    SUM[[i]] <- data.frame(dgp = CELLS$dgp[cc], n = CELLS$n[cc],
                           L = as.integer(sub("^L", "", k)), coef = seq_len(P_DIM),
                           bias = a$bias, se_bias = a$se_bias, sd = a$sd,
                           rmse = a$rmse, se_ratio = a$se_ratio,
                           cover = a$cover, se_cover = a$se_cover,
                           n_used = a$n_used, phi_b = a$phi_b,
                           se_phi_b = a$se_phi_b, phi_ise = a$phi_ise,
                           bind = a$bind, cap = a$cap, stop_med = a$stop_med)
  }
}
SUM <- do.call(rbind, SUM)
saveRDS(list(sum = SUM, nfail = NFAIL, cells = CELLS),
        file.path(OUT, "sim_multinomial_rootn.rds"))

# ---- console report --------------------------------------------------------

ff  <- function(x, d = 4) formatC(x, format = "f", digits = d)
pm  <- function(m, s, d = 4) sprintf("%s (%s)", ff(m, d), ff(s, d))

cat("\n\n===== R1/R3  BIAS, RATE AND COVERAGE ==============================\n")
cat("Truth (0, 1.0, -0.5).  Monte Carlo standard errors in parentheses.\n")
cat("sqrt(n) sd is CONSTANT under thm:rootn.  Coverage is nominal 0.95.\n\n")
cat(sprintf("%-10s %-5s %-2s %-10s %-16s %-9s %-9s %-16s\n", "design", "n", "L",
            "coef", "bias", "sd", "sqrt(n)sd", "coverage"))
for (dd in D_GRID) for (nn in N_GRID) for (L in L_GRID) {
  x <- SUM[SUM$dgp == dd & SUM$n == nn & SUM$L == L, ]
  if (!nrow(x)) next
  for (j in seq_len(P_DIM)) {
    cat(sprintf("%-10s %-5s %-2s %-10s %-16s %-9s %-9s %-16s\n",
                if (nn == N_GRID[1] && L == L_GRID[1] && j == 1) dd else "",
                if (L == L_GRID[1] && j == 1) nn else "",
                if (j == 1) L else "",
                c("const", "z1", "z2")[j],
                pm(x$bias[j], x$se_bias[j]), ff(x$sd[j]),
                ff(sqrt(nn) * x$sd[j], 3),
                pm(x$cover[j], x$se_cover[j], 3)))
  }
}

cat("\n\n===== R4  DOES THE SURPLUS BUY PRECISION?  PAIRED =================\n")
cat("sd ratio L=4 over L=2 below 1 means the four-cell contrast is tighter.\n")
cat("The bias difference is the WITHIN-DRAW mean, with its own s.e.\n\n")
cat(sprintf("%-10s %-5s %-22s %-22s %-22s\n", "design", "n",
            "sd ratio (z1, z2)", "paired bias diff z1", "paired bias diff z2"))
for (dd in D_GRID) for (nn in N_GRID) {
  cc <- which(CELLS$dgp == dd & CELLS$n == nn)
  if (!length(cc) || is.null(RES[[cc]])) next
  M <- RES[[cc]]; keep <- KEEPS[[cc]]
  s2 <- SUM[SUM$dgp == dd & SUM$n == nn & SUM$L == 2L, ]
  s4 <- SUM[SUM$dgp == dd & SUM$n == nn & SUM$L == 4L, ]
  pd <- paired_diff(M, "L4", "L2", keep)
  cat(sprintf("%-10s %-5d %-22s %-22s %-22s\n", dd, nn,
              sprintf("%s, %s", ff(s4$sd[2] / s2$sd[2], 3),
                      ff(s4$sd[3] / s2$sd[3], 3)),
              pm(pd$mean[2], pd$se[2]), pm(pd$mean[3], pd$se[3])))
}

cat("\n\n===== phi-hat THROUGH THE CROSS-FITTED PIPELINE ===================\n")
cat("b = <phi-hat, varphi>/||varphi||^2 on the reported grid; 1 is exact.\n\n")
cat(sprintf("%-10s %-5s %-2s %-16s %-9s %-9s %-9s %-9s\n", "design", "n", "L",
            "phi b", "phi ISE", "bind %", "cap %", "med stop"))
for (dd in D_GRID) for (nn in N_GRID) for (L in L_GRID) {
  x <- SUM[SUM$dgp == dd & SUM$n == nn & SUM$L == L & SUM$coef == 1, ]
  if (!nrow(x)) next
  cat(sprintf("%-10s %-5s %-2d %-16s %-9s %-9s %-9s %-9s\n",
              if (nn == N_GRID[1] && L == L_GRID[1]) dd else "",
              if (L == L_GRID[1]) nn else "", L,
              pm(x$phi_b, x$se_phi_b, 3), ff(x$phi_ise, 4),
              ff(100 * x$bind, 2), ff(100 * x$cap, 1), ff(x$stop_med, 1)))
}

cat("\n\n===== FAILURES ====================================================\n")
for (cc in seq_len(nrow(CELLS))) {
  cat(sprintf("  %-16s workers errored: %d/%d   draws usable in all arms: %d\n",
              names(RES)[cc], NFAIL[cc], B_REP, sum(KEEPS[[cc]])))
}

# ---- LaTeX tables (bare tabular, booktabs; INV-3, INV-13) ------------------

DTEX <- vapply(D_GRID, function(k) MDGP_SPEC[[k]]$tex, character(1))
write_tab <- function(lines, file) {
  writeLines(lines, file.path(TAB, file))
  message("  wrote ", file.path("paper", "tables", "sim", file))
}

## Table 1 -- bias, rate and coverage, on the CORRECTLY SPECIFIED designs.
mk_main <- function(designs, file) {
  l <- c("\\begin{tabular}{llccccc}", "\\toprule",
         paste("Design & $n$ & $\\mathsf L$ & Coefficient & Bias &",
               "$\\sqrt{n}\\,$s.d. & Coverage \\\\"),
         "\\midrule")
  for (dd in designs) {
    for (nn in N_GRID) for (L in L_GRID) {
      x <- SUM[SUM$dgp == dd & SUM$n == nn & SUM$L == L, ]
      if (!nrow(x)) next
      for (j in seq_len(P_DIM)) {
        l <- c(l, sprintf("%s & %s & %s & %s & %s & %s & %s \\\\",
                          if (nn == N_GRID[1] && L == L_GRID[1] && j == 1)
                            DTEX[[dd]] else "",
                          if (L == L_GRID[1] && j == 1)
                            format(nn, big.mark = ",") else "",
                          if (j == 1) L else "", COEF_TEX[j],
                          pm(x$bias[j], x$se_bias[j]),
                          ff(sqrt(nn) * x$sd[j], 3),
                          pm(x$cover[j], x$se_cover[j], 3)))
      }
      l <- c(l, "\\addlinespace")
    }
  }
  write_tab(c(l[-length(l)], "\\bottomrule", "\\end{tabular}"), file)
}
mk_main(c("balanced", "skewed"), "sim_multinomial_rootn.tex")
mk_main("misspec", "sim_multinomial_rootn_misspec.tex")

## Table 2 -- the paired precision comparison.
l <- c("\\begin{tabular}{llcccc}", "\\toprule",
       paste("Design & $n$ & \\multicolumn{2}{c}{s.d. ratio, $\\mathsf L$ vs 2}",
             "& \\multicolumn{2}{c}{Paired bias difference} \\\\"),
       "\\cmidrule(lr){3-4}\\cmidrule(lr){5-6}",
       " & & $\\mathsf L=3$ & $\\mathsf L=4$ & $z_1$ & $z_2$ \\\\",
       "\\midrule")
for (dd in D_GRID) {
  for (nn in N_GRID) {
    cc <- which(CELLS$dgp == dd & CELLS$n == nn)
    if (!length(cc) || is.null(RES[[cc]])) next
    M <- RES[[cc]]; keep <- KEEPS[[cc]]
    s2 <- SUM[SUM$dgp == dd & SUM$n == nn & SUM$L == 2L, ]
    s3 <- SUM[SUM$dgp == dd & SUM$n == nn & SUM$L == 3L, ]
    s4 <- SUM[SUM$dgp == dd & SUM$n == nn & SUM$L == 4L, ]
    pd <- paired_diff(M, "L4", "L2", keep)
    r <- function(a, b) sprintf("%s, %s", ff(a$sd[2] / b$sd[2], 3),
                                ff(a$sd[3] / b$sd[3], 3))
    l <- c(l, sprintf("%s & %s & %s & %s & %s & %s \\\\",
                      if (nn == N_GRID[1]) DTEX[[dd]] else "",
                      format(nn, big.mark = ","), r(s3, s2), r(s4, s2),
                      pm(pd$mean[2], pd$se[2]), pm(pd$mean[3], pd$se[3])))
  }
  if (dd != D_GRID[length(D_GRID)]) l <- c(l, "\\addlinespace")
}
write_tab(c(l, "\\bottomrule", "\\end{tabular}"),
          "sim_multinomial_precision.tex")

## Table 3 -- phi-hat through the cross-fitted pipeline.
l <- c("\\begin{tabular}{llccccc}", "\\toprule",
       paste("Design & $n$ & $\\mathsf L$ & $b$ & ISE & Floor binds (\\%) &",
             "Median $\\hat m$ \\\\"),
       "\\midrule")
for (dd in D_GRID) {
  for (nn in N_GRID) for (L in L_GRID) {
    x <- SUM[SUM$dgp == dd & SUM$n == nn & SUM$L == L & SUM$coef == 1, ]
    if (!nrow(x)) next
    l <- c(l, sprintf("%s & %s & %d & %s & %s & %s & %s \\\\",
                      if (nn == N_GRID[1] && L == L_GRID[1]) DTEX[[dd]] else "",
                      if (L == L_GRID[1]) format(nn, big.mark = ",") else "", L,
                      pm(x$phi_b, x$se_phi_b, 3), ff(x$phi_ise, 4),
                      ff(100 * x$bind, 2), ff(x$stop_med, 1)))
  }
  if (dd != D_GRID[length(D_GRID)]) l <- c(l, "\\addlinespace")
}
write_tab(c(l, "\\bottomrule", "\\end{tabular}"), "sim_multinomial_phifit.tex")

cat("\ndone\n")
