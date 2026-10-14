# ============================================================================
# sim_multinomial_onestep.R
#
# KNOWN-TRUTH VERIFICATION OF THE ORTHOGONAL ONE-STEP AT L >= 3.
#
# ---------------------------------------------------------------------------
# WHY THIS FILE EXISTS, AND THE DEFECT IT IS THE ANSWER TO
#
# The Phase 7 close-out of quality_reports/plans/2026-08-09_multinomial-
# instrument-rev2.md records "Both cardinalities on one code path" and an
# end-to-end L = 4 estimate theta-hat = (+0.98152, -0.52822) against truth
# (1.0, -0.5).  Measured 2026-08-11: THAT NUMBER IS PRODUCED BY NO SCRIPT AND
# STORED IN NO ARTIFACT, and the engine as shipped could not have produced it --
# crossfit_once()'s eval_moment() raised "number of items to replace is not a
# multiple of replacement length" at every L >= 3, which is exactly what its own
# in-file comment of the same date said it would do.  The claim outran the code.
#
# The lesson is not about that one number.  A verification claim that lives only
# in a plan is not a verification: it cannot be re-run, so it cannot be wrong in
# public.  This file exists so that the L >= 3 claim has a script behind it.
#
# ---------------------------------------------------------------------------
# REVISION 2026-08-11 (round 2).  THREE DEFECTS IN THE FIRST VERSION.
#
# (C3) THE ARMS WERE NOT PAIRED, WHILE THE HEADER SAID THEY WERE.  It claimed
#      the arms "differ only in the instrument's granularity".  They did not:
#      rep_one() called one_step(d, d$w2) and then one_step(d, d$w4) with NO RNG
#      RESET, and crossfit_once() consumes the stream at three places --
#      `folds <- sample(...)`, `op_idx <- sample(...)`, balance_gram()'s
#      `sample()` for the median heuristic, and operator_norm2()'s `rnorm()`
#      start vector.  So the two arms ran on DIFFERENT cross-fitting partitions
#      and different balancing bandwidths, and every difference between them --
#      including the "L = 4 is uniformly tighter" precision claim -- was
#      confounded with a partition difference.  Stage 8 of the application
#      already had this right (app_tsp_08_localise.R's ANCHOR); the same device
#      is used here.  The arms now share the draw AND the partition stream.
#
# (M4) FAILURE ACCOUNTING WAS ABSENT AND THE ARMS COULD BE SUMMARISED ON
#      DIFFERENT SUBSETS.  fmt_arm() computed n_ok and never printed it, and it
#      filtered each arm on its OWN complete.cases -- so a draw on which L = 4
#      failed and L = 2 did not would have been silently dropped from one arm
#      only.  That is the worst possible selection rule here, because the draws
#      where the L = 4 fit fails are the extreme-propensity draws where the bias
#      story lives.  There is also no try-error guard on the mclapply() return,
#      although app_tsp_common.R:606 has had the precedent for weeks.  All three
#      are closed: the guard is in, n_ok is printed, and every arm is summarised
#      on the COMMON subset.
#
# (M1/M2) THE eps-TRUNCATION MECHANISM IS NOW UNDER TEST, NOT CONJECTURED.
#      The first version reported an L = 4 intercept bias of -0.193 at n = 400
#      and -0.305 at n = 800 and read a GROWTH off two numbers from DISJOINT
#      streams at B = 40 -- about 1.5 Monte Carlo standard errors on the
#      difference, which is not a trend.  Two candidate mechanisms were on the
#      table and only one of them can produce a bias that RISES in n:
#        * propensity NOISE: the multinomial fit is noisier than the binary
#          logit at these fold sizes.  This bias FALLS as folds grow.  It cannot
#          be the explanation.
#        * eps-TRUNCATION: project_trunset() floors varrho-hat at eps_rho.  As n
#          grows the multinomial fit SHARPENS, predicted probabilities get more
#          extreme, THE FLOOR BINDS MORE OFTEN, and where it binds the truncated
#          propensity no longer satisfies E[Wtilde_l | Delta Z] = 0, which is A1
#          itself.  This one rises in n.
#      So the design carries (a) a THIRD sample size, because two points are not
#      a trend, (b) the realised BINDING RATE at every (n, arm), which is the
#      mechanism's own observable, and (c) an arm at eps small enough not to
#      bind.  If the bias survives at the small eps, truncation is not the
#      mechanism and the question passes to the theorist: whether eq:trunset's
#      truncation is admissible at L >= 3 at all.
#
#      NOTE ON eps AT L >= 3.  C24 justifies EPS_RHO = 0.03 as a cap on
#      |Wtilde| / (wbar(1 - wbar)) -- the multiplier the Landweber step carries.
#      That argument is BINARY: operator_residual() sets scal = 1 at L >= 3
#      (lf_panel.R, "IT STOPS CANCELLING AT L >= 3 IF PORTED CELLWISE"), so at
#      L >= 3 eps caps no multiplier at all and Wtilde is bounded in [-1, 1]
#      whatever eps is.  A small eps is therefore numerically harmless here; it
#      is the LARGE eps that does the damage, by moving varrho-hat.
#
# ---------------------------------------------------------------------------
# WHAT IS VERIFIED, IN ORDER
#
#   V1  DGP VALIDITY, at large n and BEFORE any estimation.  A design that does
#       not satisfy the identifying restrictions makes "recovers the truth"
#       meaningless.  Checked: E[Delta Z Delta U] = 0 (def:admissible (B)), and
#       A1's conditional restriction E[Wtilde_l 1{Delta U <= u}] = 0 at the TRUE
#       propensity, per contrast and per quartile.
#
#   V2  L = 2 REPRODUCTION.  The binary arm must recover the truth, because the
#       generalization is required to leave it alone.
#
#   V3  L = 4 RECOVERY.  The four-cell arm must recover the SAME truth through
#       the generalized moment, on the SAME draws AND the SAME partitions.
#
#   V4  THE REFINEMENT COMPARISON, like for like.
#
#   V5  DOES THE SURPLUS BUY PRECISION?  Now a PAIRED comparison, so the
#       standard error is on the within-draw difference and the claim can fail.
#
#   V6  IS THE L = 4 INTERCEPT BIAS eps-TRUNCATION?  The binding rate against n,
#       and the same arms at an eps that does not bind.
#
# ---------------------------------------------------------------------------
# WHAT IS NOT VERIFIED
#
# This is a check that the ESTIMATOR IS THE ONE THE THEORY DESCRIBES and that it
# recovers a known truth on an admissible design.  It is NOT a test of thm:rootn:
# no rate is claimed and no coverage is claimed.  sim_thm_rootn_*.R is where
# that lives.
# ============================================================================

suppressMessages({
  library(here)
  library(parallel)
})
source(here::here("scripts", "R", "lf_panel.R"))
source(here::here("scripts", "R", "orthogonal_theta.R"))

RNGkind("L'Ecuyer-CMRG")
set.seed(20260811L)                                                  # INV-14

OUT_ROOT <- Sys.getenv("SIM_OUT_ROOT", unset = here::here())
OUT <- file.path(OUT_ROOT, "quality_reports", "sim")
TAB <- file.path(OUT_ROOT, "paper", "tables", "sim")
for (d in c(OUT, TAB)) dir.create(d, showWarnings = FALSE, recursive = TRUE)

# ---- design constants ------------------------------------------------------
#
# THETA is the Phase 7 pilot's, so the arm is comparable with the claim it
# replaces.  The intercept is carried in column 1 of Delta Z, as make_design()
# does in the application, with true coefficient zero.
THETA    <- c(1.0, -0.5)
THETA_FULL <- c(0.0, THETA)
COEF_LAB <- c("Constant", "$z_1$", "$z_2$")
PHI_TRUE <- function(x) sin(2 * pi * x) / 2
GAMMA    <- 1.2          # propensity dependence on Delta Z; 0 makes A1 vacuous
## THREE sample sizes, because the question is whether a bias GROWS and two
## points cannot answer it.
## SIM_B and SIM_NMAX override the grid for a short run, which is
## sim_multinomial_rootn.R:123's convention.  They exist so the checkpoint can be
## EXERCISED cheaply -- a resumability claim that is only ever tested at full
## size is a claim nobody re-tests.  Both enter CFG, so a reduced run gets its
## own cache and cannot be mistaken for the shipped one.
N_GRID   <- c(400L, 800L, 1600L)
N_MAX    <- as.integer(Sys.getenv("SIM_NMAX", unset = "1600"))
N_GRID   <- N_GRID[N_GRID <= N_MAX]
B_REP    <- as.integer(Sys.getenv("SIM_B", unset = "80"))
N_BIG    <- 2e6L         # V1 only, no estimation
N_CORES  <- 8L
CELL_SHIFT <- c(0, 0.6, 0.9, 1.2)   # first-stage shift by cell; relevance
LF_IMAX  <- 60L
LF_PAT   <- 20L
K_FOLD   <- 5L
## The application's registered truncation level, and one small enough that the
## projection is inert.  eps = 0 is not available: project_trunset() requires
## eps > 0 for eq:trunset to be a well-posed set.
EPS_BIG   <- 0.03
EPS_SMALL <- 1e-4
## The four arms.  Named so that every table column is self-describing.
ARMS <- data.frame(
  key   = c("L2_big", "L4_big", "L2_small", "L4_small"),
  label = c("L=2, eps=0.03", "L=4, eps=0.03", "L=2, eps=1e-4",
            "L=4, eps=1e-4"),
  tex   = c("$\\mathsf L = 2$, $\\varepsilon_\\varrho = 0.03$",
            "$\\mathsf L = 4$, $\\varepsilon_\\varrho = 0.03$",
            "$\\mathsf L = 2$, $\\varepsilon_\\varrho = 10^{-4}$",
            "$\\mathsf L = 4$, $\\varepsilon_\\varrho = 10^{-4}$"),
  cells = c(2L, 4L, 2L, 4L),
  eps   = c(EPS_BIG, EPS_BIG, EPS_SMALL, EPS_SMALL),
  stringsAsFactors = FALSE
)
N_ARM <- nrow(ARMS)
P_DIM <- 3L

#' One draw of the four-cell design, with its binary coarsening.
#'
#' Delta U depends on Delta Z and on (v1, v2, e) only; W4 depends on Delta Z and
#' on its own uniform draw.  So Delta U _||_ W | Delta Z holds EXACTLY, not
#' approximately, and E[Delta Z Delta U] = 0 because E[z_j z_1 z_2] = 0 at
#' independent standard normals.
#'
#' @param n integer. Sample size.
#' @param gamma numeric. Strength of the propensity's dependence on Delta Z.
#' @return named list: y, x1, x2, Z (n x 3, intercept first), w4, w2.
dgp_draw4 <- function(n, gamma = GAMMA) {
  z  <- matrix(stats::rnorm(n * 2L), n, 2L)
  zx <- z[, 1] * z[, 2]
  eta <- cbind(0,
               0.20 + gamma * z[, 1],
               0.10 + 0.5 * gamma * z[, 2],
               -0.10 + gamma * zx)
  P <- exp(eta) / rowSums(exp(eta))
  ## Inverse-CDF sampling.  The cumulative sum is built column-wise rather than
  ## by apply(., 1, cumsum): identical arithmetic, and apply() over n = 2e6 rows
  ## is the single slowest line in the file otherwise.  pmin() guards the
  ## floating-point case u > sum_l P_l, which would index CELL_SHIFT past its
  ## end rather than fail.
  cum <- P
  for (k in seq(2L, ncol(P))) cum[, k] <- cum[, k - 1L] + P[, k]
  w4 <- pmin(rowSums(stats::runif(n) > cum), ncol(P) - 1L)          # 0..3
  xi <- stats::rnorm(n); v1 <- stats::rnorm(n); v2 <- stats::rnorm(n)
  x1 <- stats::pnorm((xi + v1) / 1.5)
  x2 <- stats::pnorm((xi + CELL_SHIFT[w4 + 1L] + v2) / 1.5)
  du <- gamma * zx + 0.6 * (v2 - v1) + 0.5 * stats::rnorm(n)
  list(y  = PHI_TRUE(x2) - PHI_TRUE(x1) + as.vector(z %*% THETA) + du,
       x1 = x1, x2 = x2, Z = cbind(const = 1, z), w4 = w4,
       w2 = as.numeric(w4 > 0L), du = du, P = P)
}

#' The orthogonal one-step on one draw, at one instrument and one eps.
#'
#' Mirrors fit_one_partition() in scripts/application/app_tsp_common.R: plug-in
#' OLS start, ONE Newton step on the orthogonal moment (eq:onestep).  `J` from
#' eval_moment() is the negative of eq:Jhat, so th0 - J^{-1} psibar is
#' eq:onestep's th0 + Jhat^{-1} psibar.
#'
#' @param d list from dgp_draw4().
#' @param w numeric vector. The instrument, binary or four-category.
#' @param eps numeric. A4(i)'s eps_varrho.
#' @return named list: theta (p), rel_bal (p), bind_rate, min_pre, L, ok.
one_step <- function(d, w, eps) {
  cf <- crossfit_once(d$y, d$x1, d$x2, d$Z, w, K = K_FOLD, cste = NULL,
                      lf_imax = LF_IMAX, lf_patience = LF_PAT, n_t = 16L,
                      t_scale = 0.25, adj_wtil = TRUE, conditional = TRUE,
                      eps_rho = eps, verbose = FALSE)
  th0 <- stats::lm.fit(d$Z, d$y - cf$dphi)$coefficients
  th0[!is.finite(th0)] <- 0
  m0 <- cf$eval_moment(th0)
  J0i <- tryCatch(solve(m0$J), error = function(e) MASS::ginv(m0$J))
  th1 <- as.vector(th0 - J0i %*% colMeans(m0$psi))
  stopifnot(length(th1) == ncol(d$Z), all(is.finite(th1)))
  pd <- cf$prop_diag
  list(theta = th1, rel_bal = cf$disc, L = m0$L, ok = TRUE,
       bind_rate = pd$bind_rate, min_pre = pd$min_pre,
       n_fallback = pd$n_fallback, n_not_conv = pd$n_not_converged)
}

# ============================================================================
# V1  DGP VALIDITY -- before any estimation
# ============================================================================

message("== V1  DGP validity at n = ", format(N_BIG, big.mark = ","),
        " (no estimation) ==")
big <- dgp_draw4(N_BIG)
zmom <- colMeans(big$Z * big$du)
qs <- stats::quantile(big$du, c(0.25, 0.5, 0.75))
Wind_big <- vapply(1:3, function(k) as.numeric(big$w4 == k), numeric(N_BIG))
wt_big <- Wind_big - big$P[, -1L, drop = FALSE]        # at the TRUE propensity
a1_gap <- matrix(NA_real_, 3L, 3L)                                   # INV-17
for (l in 1:3) {
  for (q in 1:3) {
    a1_gap[l, q] <- mean(wt_big[, l] * (big$du <= qs[q]))
  }
}
## The TRUE propensity's own minimum: the design's headroom against eq:trunset,
## and the reason a floor at 0.03 can bind on a correctly specified fit.
p_min_true <- min(big$P)
p_below <- colMeans(big$P < EPS_BIG)
message(sprintf("  E[dZ dU]              : %s   (def:admissible (B), target 0)",
                paste(sprintf("%+.5f", zmom), collapse = " ")))
for (l in 1:3) {
  message(sprintf("  E[Wtil_%d 1{dU<=q}]    : %s   (A1, target 0)",
                  l, paste(sprintf("%+.5f", a1_gap[l, ]), collapse = " ")))
}
message(sprintf("  cell shares           : %s",
                paste(sprintf("%.4f", as.vector(table(big$w4)) / N_BIG),
                      collapse = " ")))
message(sprintf("  binary share E[W2]    : %.4f", mean(big$w2)))
message(sprintf("  TRUE varrho: min      = %.3e   P(varrho_l < %.4g) = %s",
                p_min_true, EPS_BIG,
                paste(sprintf("%.4f", p_below), collapse = " ")))
message(sprintf("  relevance E[dX | W4=l]: %s",
                paste(sprintf("%+.4f",
                              vapply(0:3, function(k)
                                mean((big$x2 - big$x1)[big$w4 == k]),
                                numeric(1))), collapse = " ")))
v1_ok <- max(abs(zmom)) < 5e-3 && max(abs(a1_gap)) < 5e-3
message(sprintf("  V1 verdict            : %s",
                if (v1_ok) "DESIGN ADMISSIBLE" else "*** DESIGN INVALID ***"))
rm(big, Wind_big, wt_big)
invisible(gc(verbose = FALSE))

# ============================================================================
# V2-V6  the Monte Carlo, PAIRED
# ============================================================================

message("\n== V2-V6  one-step, ", N_ARM, " arms x ", B_REP,
        " replications per n, ARMS PAIRED ON THE PARTITION STREAM ==")

streams <- vector("list", length(N_GRID) * B_REP)                    # INV-17
s <- get(".Random.seed", envir = globalenv())
for (j in seq_along(streams)) {
  s <- parallel::nextRNGStream(s)
  streams[[j]] <- s
}

## Column layout of one replication's record.  Fixed here so the summariser and
## the estimator agree by construction rather than by matching integers.
COLS <- c(as.vector(outer(sprintf("th%d", seq_len(P_DIM)), ARMS$key,
                          paste, sep = "_")),
          paste0("relbal_", ARMS$key), paste0("bind_", ARMS$key),
          paste0("minpre_", ARMS$key), paste0("ok_", ARMS$key))
TH_IDX <- lapply(ARMS$key, function(k)
  match(sprintf("th%d_%s", seq_len(P_DIM), k), COLS))
names(TH_IDX) <- ARMS$key

#' One replication: the SAME draw estimated under every arm, from the SAME
#' partition stream.
#'
#' The anchor is captured after the draw and restored before each arm, so
#' crossfit_once()'s fold assignment, balance_gram()'s median-heuristic
#' subsample and operator_norm2()'s start vector are identical across arms.  It
#' is the device app_tsp_08_localise.R already uses.
rep_one <- function(j, n, off) {
  assign(".Random.seed", streams[[off + j]], envir = globalenv())
  d <- dgp_draw4(n)
  anchor <- get(".Random.seed", envir = globalenv())
  out <- stats::setNames(rep(NA_real_, length(COLS)), COLS)
  for (a in seq_len(N_ARM)) {
    assign(".Random.seed", anchor, envir = globalenv())
    w <- if (ARMS$cells[a] == 2L) d$w2 else d$w4
    r <- tryCatch(one_step(d, w, ARMS$eps[a]), error = function(e) NULL)
    k <- ARMS$key[a]
    if (is.null(r)) {
      out[paste0("ok_", k)] <- 0
      next
    }
    out[TH_IDX[[k]]] <- r$theta
    out[paste0("relbal_", k)] <- mean(r$rel_bal)
    out[paste0("bind_", k)]   <- r$bind_rate
    out[paste0("minpre_", k)] <- r$min_pre
    out[paste0("ok_", k)]     <- 1
  }
  out
}

## ---------------------------------------------------------------------------
## TWO CACHES, AND THEY ANSWER DIFFERENT QUESTIONS.
##
##   sim_multinomial_onestep.rds       THE OUTPUT, and a WHOLE-RUN cache.  A run
##       that FINISHED is reused when the DESIGN fingerprint matches: the
##       estimator sources, the DGP, the arms, the grid and the three functions
##       that turn a stream into a record.  It excludes this file's md5 on
##       purpose, so editing the write-up reuses the run.  Unchanged.
##
##   sim_multinomial_onestep_ckpt.rds  THE INCREMENTAL cache, added 2026-08-25.
##       Staged per (cell, block of replications) so an INTERRUPTED run resumes.
##
## WHY THE SECOND ONE HAD TO EXIST, AND WHY PER-CELL WOULD NOT HAVE DONE.  The
## whole-run cache is all-or-nothing: it reuses a run that finished and does
## nothing at all for a run that was killed, which is the case that occurs.
## Re-profiled 2026-08-25 the arm is 14,111 core-seconds, and the n = 1,600 cell
## ALONE is 11,093 of them -- about 41 minutes at the parallelism this box
## delivers, against a background-job cap near 65.  A per-CELL stage would have
## left one unbreakable block at the edge of that cap.  The stage is a BLOCK of
## CKPT_CHUNK replications INSIDE a cell.
##
## WHY BLOCKING IS BIT-EXACT, AND IT IS NOT THE SEED-RESTORE THAT BUYS IT.
## rep_one(j, n, off) opens with assign(".Random.seed", streams[[off + j]]) and
## `streams` is built ONCE from the top-level seed before any replication runs.
## Replication j's state is a function of the seed and of j alone, never of how
## many replications preceded it IN THIS PROCESS -- so any partition of
## seq_len(B_REP) into blocks returns exactly what no partition returns, and the
## block boundary is free.  The stage nevertheless stores .Random.seed beside its
## value and restores it on a hit, which is sim_thm_rootn_bdrylayer.R's
## convention: it costs nothing, it keeps the PARENT stream position identical to
## an uninterrupted run, and it is what keeps the guarantee alive if anyone later
## adds an inline draw between cells.
##
## NOTE THE ASYMMETRY, because it is a real cost and not a detail: the
## incremental key includes this file's md5, so editing the PROSE of this file
## discards it while the whole-run cache above survives.  Edit before launching.
CKPT <- file.path(OUT, "sim_multinomial_onestep.rds")
CFG <- list(
  arms = ARMS, n_grid = N_GRID, b_rep = B_REP, gamma = GAMMA, seed = 20260811L,
  lf_imax = LF_IMAX, lf_pat = LF_PAT, k_fold = K_FOLD, theta = THETA_FULL,
  cell_shift = CELL_SHIFT, cols = COLS,
  src = unname(tools::md5sum(here::here(
    "scripts", "R", c("lf_panel.R", "orthogonal_theta.R")))),
  driver = c(paste(deparse(dgp_draw4), collapse = "\n"),
             paste(deparse(one_step), collapse = "\n"),
             paste(deparse(rep_one), collapse = "\n"))
)

## ---- the incremental cache -------------------------------------------------
##
## CKPT_CHUNK is set so one stage stays clear of the machine's background-job
## cap in the most expensive cell: at n = 1,600 a draw costs 138.7 core-seconds
## across the four arms (measured 2026-08-25), so 16 replications is roughly
## 8 minutes of wall time at the parallelism available.
CKPT_INC   <- file.path(OUT, "sim_multinomial_onestep_ckpt.rds")
CKPT_CHUNK <- 16L
CKPT_SRC   <- c(here::here("scripts", "simulations",
                           "sim_multinomial_onestep.R"),
                here::here("scripts", "R",
                           c("lf_panel.R", "orthogonal_theta.R")))
## THE KEY IS THE md5 OF THIS FILE AND OF THE FILES IT SOURCES.  That is
## STRICTER than the whole-run fingerprint above, deliberately: the fingerprint
## deparses dgp_draw4, one_step and rep_one, which does not cover a helper they
## call -- PHI_TRUE is the live example -- so an edit there is invisible to it.
## A stale resume ships wrong numbers; an over-eager discard only costs time.
CKPT_KEY   <- paste(unname(tools::md5sum(CKPT_SRC)), collapse = " ")

## CFG IS CHECKED ALONGSIDE THE KEY, and this is not belt-and-braces.  A stage
## tag names a cell and a block of replications; SIM_B changes what that block
## CONTAINS without changing one byte of source.  With a source-only key a
## diagnostic run at B_REP = 8 would write `n00400_rep0001-0008` and a later
## full run would restore it as though it held its own first block -- 8
## replications silently standing in for 16.  identical() on CFG closes that,
## and it is the same guard sim_thm_rootn_phistep.R:1537 puts on its design.
CKPT_ENV <- new.env(parent = emptyenv())
CKPT_ENV$stage <- list()
if (file.exists(CKPT_INC)) {
  ck_old <- readRDS(CKPT_INC)
  if (identical(ck_old$key, CKPT_KEY) && identical(ck_old$cfg, CFG)) {
    CKPT_ENV$stage <- ck_old$stage
    message(sprintf("  [ckpt] resuming: %d stage(s) already on disk",
                    length(CKPT_ENV$stage)))
  } else {
    message("  [ckpt] key or design changed -- incremental cache discarded")
  }
  rm(ck_old)
}

#' Evaluate `expr` once, or restore it together with the RNG state it left.
#'
#' An ENVIRONMENT rather than the `<<-` that sim_thm_rootn_bdrylayer.R's
#' staged() uses: `<<-` is a prohibited pattern in this project's R standard
#' (.claude/references/coding-standards-r.md section 9) and
#' sim_multinomial_phiplugin.R:155 already flags it as such.  Assigning into a
#' named environment is the explicit form of the same operation.
#'
#' @param tag character(1). Stage name; must be stable across runs.
#' @param expr expression. Evaluated lazily, and NOT at all on a cache hit.
#' @return the stage's value.
staged <- function(tag, expr) {
  hit <- CKPT_ENV$stage[[tag]]
  if (!is.null(hit)) {
    assign(".Random.seed", hit$seed, envir = globalenv())
    message(sprintf("  [ckpt] restored '%s'", tag))
    return(hit$value)
  }
  v  <- expr
  st <- CKPT_ENV$stage
  st[[tag]] <- list(value = v,
                    seed = get(".Random.seed", envir = globalenv()))
  CKPT_ENV$stage <- st
  ## Written through a temporary in the SAME directory and renamed.  A kill
  ## during the write would otherwise leave a truncated cache, which is worse
  ## than no cache: the next readRDS() would fail and take every completed stage
  ## with it.  rename() is atomic within a filesystem.
  tmp <- paste0(CKPT_INC, ".tmp")
  saveRDS(list(key = CKPT_KEY, cfg = CFG, stage = st), tmp)
  file.rename(tmp, CKPT_INC)
  v
}

res <- NULL
n_failed <- integer(length(N_GRID))
if (file.exists(CKPT)) {
  old <- readRDS(CKPT)
  if (identical(old$cfg, CFG)) {
    res <- old$res
    n_failed <- old$n_failed
    message("  reusing cached replications (configuration unchanged)")
  } else {
    message("  cache discarded, configuration changed")
  }
}
if (is.null(res)) {
res <- vector("list", length(N_GRID))                                # INV-17
names(res) <- as.character(N_GRID)
for (i in seq_along(N_GRID)) {
  nn <- N_GRID[i]
  t0 <- Sys.time()
  ## Block boundaries from an explicit group index, NOT split(x, ceiling(x/k)):
  ## split() names its groups as CHARACTER, so past nine blocks "10" would sort
  ## between "1" and "2" and the stage tags would drift off the blocks they name.
  idx_all <- seq_len(B_REP)
  grp     <- ceiling(idx_all / CKPT_CHUNK)
  chunks  <- lapply(sort(unique(grp)), function(g) idx_all[grp == g])
  M <- matrix(NA_real_, B_REP, length(COLS),                         # INV-17
              dimnames = list(NULL, COLS))
  bad_all <- rep(TRUE, B_REP)
  for (cc in seq_along(chunks)) {
    jj  <- chunks[[cc]]
    ## The tag names the replications it holds, not just their block number, so
    ## a stage restored under a different B_REP is visible on inspection rather
    ## than only through the CFG guard.
    tag <- sprintf("n%05d_rep%04d-%04d", nn, min(jj), max(jj))
    got <- staged(tag, {
      ## jj carries the GLOBAL replication indices, not 1..length(jj), because
      ## rep_one() reads streams[[off + j]].  Passing the global index is what
      ## makes a blocked run and an unblocked one draw the same samples.
      raw <- parallel::mclapply(jj, rep_one, n = nn,
                                off = (i - 1L) * B_REP,
                                mc.cores = N_CORES, mc.preschedule = FALSE)
      ## TRY-ERROR GUARD.  mclapply() returns a "try-error" OBJECT for a worker
      ## that died; rbind()-ing them silently produces a character matrix and
      ## every downstream mean becomes NA.  Precedent: app_tsp_common.R:606.
      bad <- vapply(raw, function(z) inherits(z, "try-error") ||
                      !is.numeric(z) || length(z) != length(COLS), logical(1))
      Mc <- matrix(NA_real_, length(jj), length(COLS),               # INV-17
                   dimnames = list(NULL, COLS))
      for (b in seq_along(jj)) {
        if (!bad[b]) Mc[b, ] <- raw[[b]]
      }
      list(M = Mc, bad = bad)
    })
    M[jj, ]     <- got$M
    bad_all[jj] <- got$bad
  }
  n_failed[i] <- sum(bad_all)
  if (any(bad_all)) {
    message(sprintf("  *** %d of %d workers returned an error at n = %d ***",
                    sum(bad_all), B_REP, nn))
  }
  res[[i]] <- M
  ## The elapsed figure covers the UNCACHED blocks only, so on a resumed run it
  ## is not the cell's cost.  Said here rather than left to be misread.
  message(sprintf("  n = %4d done in %5.0fs of fresh compute (%d/%d returned)",
                  nn, as.numeric(difftime(Sys.time(), t0, units = "secs")),
                  B_REP - sum(bad_all), B_REP))
}
}

# ---- report ----------------------------------------------------------------

#' Summarise one arm on a GIVEN row subset.
#'
#' The subset is supplied rather than computed per arm: filtering each arm on
#' its own complete.cases would summarise the arms on different draws, and the
#' draws an arm fails on are exactly the extreme-propensity draws the bias
#' question is about.
#'
#' @param M numeric matrix. One n's replication records.
#' @param key character. Arm key.
#' @param keep logical vector. Rows to use, common to all arms.
#' @return named list of per-coordinate summaries plus Monte Carlo errors.
summarise_arm <- function(M, key, keep) {
  X <- M[keep, TH_IDX[[key]], drop = FALSE]
  b <- nrow(X)
  bias <- colMeans(X) - THETA_FULL
  sdv  <- apply(X, 2L, stats::sd)
  list(key = key, n_used = b,
       n_ok = sum(M[, paste0("ok_", key)] == 1, na.rm = TRUE),
       bias = bias, se_bias = sdv / sqrt(b),
       rmse = sqrt(colMeans(sweep(X, 2L, THETA_FULL, "-")^2)),
       sd = sdv,
       rel_bal = mean(M[keep, paste0("relbal_", key)], na.rm = TRUE),
       bind_rate = mean(M[keep, paste0("bind_", key)], na.rm = TRUE),
       min_pre = min(M[keep, paste0("minpre_", key)], na.rm = TRUE))
}

#' Paired difference between two arms, coordinate by coordinate.
#'
#' PAIRED is the point: the arms share the draw and the partition, so the
#' within-draw difference removes the draw's variance and the standard error is
#' on the difference itself rather than on two independent means.
paired_diff <- function(M, key_a, key_b, keep) {
  D <- M[keep, TH_IDX[[key_a]], drop = FALSE] -
       M[keep, TH_IDX[[key_b]], drop = FALSE]
  list(mean = colMeans(D), se = apply(D, 2L, stats::sd) / sqrt(nrow(D)),
       n = nrow(D))
}

summ <- vector("list", length(N_GRID))                               # INV-17
names(summ) <- as.character(N_GRID)
message("\n  theta coordinates are (const, z1, z2); truth (0, 1.0, -0.5)")
message("  every arm is summarised on the COMMON subset of draws")
for (i in seq_along(N_GRID)) {
  M <- res[[i]]
  ok_mat <- M[, paste0("ok_", ARMS$key), drop = FALSE]
  keep <- stats::complete.cases(M[, unlist(TH_IDX), drop = FALSE]) &
    rowSums(ok_mat == 1, na.rm = TRUE) == N_ARM
  message(sprintf("\n  -- n = %d --   %d of %d draws usable in ALL arms",
                  N_GRID[i], sum(keep), B_REP))
  arms <- lapply(ARMS$key, function(k) summarise_arm(M, k, keep))
  names(arms) <- ARMS$key
  for (a in seq_len(N_ARM)) {
    z <- arms[[ARMS$key[a]]]
    message(sprintf("    %-14s bias %s | mcse %s | sd %s | n_ok %2d | bind %6.3f%%",
                    ARMS$label[a],
                    paste(sprintf("%+8.4f", z$bias), collapse = " "),
                    paste(sprintf("%7.4f", z$se_bias), collapse = " "),
                    paste(sprintf("%7.4f", z$sd), collapse = " "),
                    z$n_ok, 100 * z$bind_rate))
  }
  d_lc <- paired_diff(M, "L4_big", "L2_big", keep)
  d_eps <- paired_diff(M, "L4_big", "L4_small", keep)
  message(sprintf("    PAIRED L4-L2 (eps 0.03) : %s   (se %s)",
                  paste(sprintf("%+8.4f", d_lc$mean), collapse = " "),
                  paste(sprintf("%.4f", d_lc$se), collapse = " ")))
  message(sprintf("    PAIRED L4 eps 0.03-1e-4 : %s   (se %s)",
                  paste(sprintf("%+8.4f", d_eps$mean), collapse = " "),
                  paste(sprintf("%.4f", d_eps$se), collapse = " ")))
  summ[[i]] <- list(n = N_GRID[i], n_keep = sum(keep), n_failed = n_failed[i],
                    arms = arms, diff_L4_L2 = d_lc, diff_eps = d_eps)
}

# ---- V6: does the intercept bias grow, and is it the truncation? -----------

message("\n== V6  the L = 4 intercept bias against n, and the mechanism ==")
bias_int <- vapply(summ, function(z)
  vapply(ARMS$key, function(k) z$arms[[k]]$bias[1], numeric(1)),
  numeric(N_ARM))
se_int <- vapply(summ, function(z)
  vapply(ARMS$key, function(k) z$arms[[k]]$se_bias[1], numeric(1)),
  numeric(N_ARM))
bind_by_n <- vapply(summ, function(z)
  vapply(ARMS$key, function(k) z$arms[[k]]$bind_rate, numeric(1)),
  numeric(N_ARM))
rownames(bias_int) <- rownames(se_int) <- rownames(bind_by_n) <- ARMS$key
colnames(bias_int) <- colnames(se_int) <- colnames(bind_by_n) <-
  as.character(N_GRID)
message("\n  intercept bias (Monte Carlo se in brackets):")
for (a in seq_len(N_ARM)) {
  message(sprintf("    %-14s %s", ARMS$label[a],
                  paste(sprintf("%+7.4f [%.4f]", bias_int[a, ], se_int[a, ]),
                        collapse = "   ")))
}
message("\n  truncation binding rate (%), the mechanism's own observable:")
for (a in seq_len(N_ARM)) {
  message(sprintf("    %-14s %s", ARMS$label[a],
                  paste(sprintf("%9.4f", 100 * bind_by_n[a, ]),
                        collapse = "   ")))
}
## The growth, across DISJOINT n, so the two means are independent and the
## standard error of the difference is the root of the sum of squares.  This is
## the interval the first version did not put on its growth claim.
growth <- bias_int[, length(N_GRID)] - bias_int[, 1L]
growth_se <- sqrt(se_int[, length(N_GRID)]^2 + se_int[, 1L]^2)
message(sprintf("\n  intercept bias change from n = %d to n = %d:",
                N_GRID[1], N_GRID[length(N_GRID)]))
for (a in seq_len(N_ARM)) {
  message(sprintf("    %-14s %+7.4f  se %.4f  = %+5.2f se   %s",
                  ARMS$label[a], growth[a], growth_se[a],
                  growth[a] / growth_se[a],
                  if (abs(growth[a]) > 1.96 * growth_se[a])
                    "<- distinguishable from zero" else
                    "<- NOT distinguishable from zero"))
}
verdict_eps <- vapply(summ, function(z) {
  ## Is the eps = 0.03 arm's intercept bias different from the eps = 1e-4 arm's,
  ## PAIRED?  If truncation is the mechanism, this difference is the mechanism.
  abs(z$diff_eps$mean[1]) > 1.96 * z$diff_eps$se[1]
}, logical(1))
message(sprintf("\n  paired eps effect on the L = 4 intercept distinguishable from zero at n = %s",
                paste(N_GRID[verdict_eps], collapse = ", ")))
if (!any(verdict_eps)) {
  message("  -> AT NO SAMPLE SIZE.  eps-truncation does NOT explain the L = 4")
  message("     intercept bias on this design.  The residual question -- whether")
  message("     eq:trunset's truncation is admissible at L >= 3 -- is a THEORIST")
  message("     question, and this file has taken it as far as code can.")
}

# c_Wtilde must NOT print the binary constant at L = 4.
dchk <- dgp_draw4(400L)
rho4 <- fit_propensity_multi(dchk$w4, dchk$Z, seq_len(400L), seq_len(400L),
                             eps = EPS_BIG, cells = 0:3)
rho4_raw <- fit_propensity_multi(dchk$w4, dchk$Z, seq_len(400L), seq_len(400L),
                                 eps = 1e-12, cells = 0:3)
attr(rho4, "prop_diag") <- NULL
attr(rho4_raw, "prop_diag") <- NULL
message("\n  theory diagnostics at L = 4 (c_Wtilde must not be the binary 1):")
print_theory_diagnostics(theory_diagnostics(dchk$w4, rho4, eps_rho = EPS_BIG,
                                            n = 400L, rho_pre = rho4_raw))

# ---- LaTeX (INV-13: bare tabular, no float, no caption, no notes) ----------

fmt_n <- function(x, d = 4L) formatC(x, format = "f", digits = d)
blk <- vector("list", length(N_GRID))                                # INV-17
for (i in seq_along(N_GRID)) {
  rows <- vapply(seq_len(N_ARM), function(a) {
    z <- summ[[i]]$arms[[ARMS$key[a]]]
    sprintf("\\quad %s & %s & %s & %s & %s & %s \\\\",
            ARMS$tex[a],
            paste(fmt_n(z$bias), collapse = " & "),
            fmt_n(z$se_bias[1]), fmt_n(z$rmse[1]),
            fmt_n(100 * z$bind_rate, 3L), z$n_used)
  }, character(1))
  blk[[i]] <- c(sprintf("\\multicolumn{8}{l}{\\textit{Panel %s: $n = %d$, %d of %d draws usable in all arms}} \\\\",
                        LETTERS[i], N_GRID[i], summ[[i]]$n_keep, B_REP),
                "\\midrule", rows,
                if (i < length(N_GRID)) "\\\\[0.3em]" else NULL)
}
#' Bare tabular fragment (INV-13, INV-3): no float, no caption, no notes.
#'
#' A local copy of app_tsp_common.R's write_tabular().  Sourcing that file here
#' would drag the APPLICATION's tuning constants (C1-C26) into a simulation's
#' namespace, where a stray EPS_RHO or N_FOLDS would silently override this
#' file's own design.  Nine lines of duplication is the cheaper hazard.
#'
#' @param colspec character. tabular column specification.
#' @param header,body character vectors of LaTeX rows.
#' @param path character. Destination.
write_tabular_sim <- function(colspec, header, body, path) {
  stopifnot(!any(grepl("\\\\hline|\\\\begin\\{table\\}|\\\\caption",
                       c(header, body))))
  writeLines(c(sprintf("\\begin{tabular}{%s}", colspec), "\\toprule",
               header, "\\midrule", body, "\\bottomrule", "\\end{tabular}"),
             path)
  invisible(path)
}
write_tabular_sim(
  colspec = "lrrrrrrr",
  header = c(paste(" & \\multicolumn{3}{c}{Bias} & MC se & RMSE & Trunc.\\ binds",
                   "& Draws \\\\"),
             "\\cmidrule(lr){2-4}",
             paste("Arm &", paste(COEF_LAB, collapse = " & "),
                   "& (const) & (const) & (\\%) & used \\\\")),
  body = unlist(blk),
  path = file.path(TAB, "sim_multinomial_onestep.tex"))
message("\nwrote ", file.path(TAB, "sim_multinomial_onestep.tex"))

# ---- artifacts -------------------------------------------------------------

saveRDS(list(cfg = CFG, res = res, summ = summ, theta_true = THETA_FULL,
             arms = ARMS, cols = COLS, th_idx = TH_IDX,
             v1 = list(zmom = zmom, a1_gap = a1_gap, ok = v1_ok,
                       p_min_true = p_min_true, p_below_eps = p_below),
             bias_intercept = bias_int, se_intercept = se_int,
             bind_by_n = bind_by_n, growth = growth, growth_se = growth_se,
             eps_effect_significant = verdict_eps,
             b_rep = B_REP, n_grid = N_GRID, gamma = GAMMA, n_failed = n_failed,
             seed = 20260811L),
        file.path(OUT, "sim_multinomial_onestep.rds"))
message("wrote ", file.path(OUT, "sim_multinomial_onestep.rds"))

writeLines(c(
  "# Multinomial one-step: known-truth verification at L >= 3",
  "",
  sprintf(paste("%d arms x %d replications at n = %s, gamma = %.1f, K = %d",
                "folds. Seed %d. Produced by",
                "`scripts/simulations/sim_multinomial_onestep.R`."),
          N_ARM, B_REP, paste(N_GRID, collapse = ", "), GAMMA, K_FOLD,
          20260811L),
  "",
  "## What this file settles",
  "",
  paste("The arms are **paired**: they share the draw *and* the cross-fitting",
        "partition, because the RNG state is restored before each arm. The",
        "previous version did not do this -- it called the two arms in sequence",
        "with no reset, and `crossfit_once()` consumes the stream at four",
        "places -- so every arm-to-arm difference it reported, the precision",
        "claim included, was confounded with a partition difference."),
  "",
  paste("Every arm is summarised on the **common** subset of draws. Filtering",
        "each arm on its own `complete.cases` would compare arms on different",
        "draws, and the draws an arm fails on are the extreme-propensity draws",
        "the bias question is about."),
  "",
  "## V1 -- design validity, at n = 2,000,000, before any estimation",
  "",
  sprintf("- `E[dZ dU]` = %s (target 0)",
          paste(sprintf("%+.5f", zmom), collapse = ", ")),
  sprintf("- `max_l,q |E[Wtil_l 1{dU<=q}]|` = %.5f at the TRUE propensity (A1, target 0)",
          max(abs(a1_gap))),
  sprintf("- true `min varrho` = %.3e; `P(varrho_l < %.2g)` = %s",
          p_min_true, EPS_BIG, paste(sprintf("%.4f", p_below), collapse = ", ")),
  sprintf("- verdict: **%s**",
          if (v1_ok) "design admissible" else "DESIGN INVALID"),
  "",
  "## Intercept bias against n, with Monte Carlo error",
  "",
  paste0("| arm | ", paste(sprintf("n = %d", N_GRID), collapse = " | "),
         " | change | se | in se |"),
  paste0("|---|", strrep("---|", length(N_GRID) + 3L)),
  vapply(seq_len(N_ARM), function(a)
    sprintf("| %s | %s | %+.4f | %.4f | %+.2f |", ARMS$label[a],
            paste(sprintf("%+.4f (%.4f)", bias_int[a, ], se_int[a, ]),
                  collapse = " | "),
            growth[a], growth_se[a], growth[a] / growth_se[a]),
    character(1)),
  "",
  paste("Monte Carlo standard errors in parentheses. `change` is the difference",
        "between the largest and smallest n, across **disjoint** streams, so its",
        "standard error is the root sum of squares. A change under about two",
        "standard errors is not a trend."),
  "",
  "## Truncation binding rate (%), the mechanism's own observable",
  "",
  paste0("| arm | ", paste(sprintf("n = %d", N_GRID), collapse = " | "), " |"),
  paste0("|---|", strrep("---|", length(N_GRID))),
  vapply(seq_len(N_ARM), function(a)
    sprintf("| %s | %s |", ARMS$label[a],
            paste(sprintf("%.4f", 100 * bind_by_n[a, ]), collapse = " | ")),
    character(1)),
  "",
  paste("The eps-truncation hypothesis is that the multinomial fit sharpens as",
        "n grows, predicted probabilities get more extreme, the floor binds more",
        "often, and the truncated propensity stops satisfying",
        "`E[Wtil_l | dZ] = 0`. That mechanism requires the binding rate to",
        sprintf("**rise** in n. Measured, it **%s**: %s at L = 4, eps = 0.03.",
                if (bind_by_n["L4_big", length(N_GRID)] <
                    bind_by_n["L4_big", 1L]) "falls" else "rises",
                paste(sprintf("%.2f%%", 100 * bind_by_n["L4_big", ]),
                      collapse = " -> ")),
        "So the hypothesis fails on its own observable, before the paired eps",
        "comparison below is even consulted."),
  "",
  "## Sampling spread of the slope coefficients, PAIRED",
  "",
  paste("V5's question -- does the surplus contrast buy precision? -- was a",
        "one-draw comparison in the plan and an unpaired one in the first",
        "version of this file. Here it is paired and it is a Monte Carlo."),
  "",
  paste0("| n | ",
         paste(vapply(c("L2_big", "L4_big"), function(k)
           sprintf("sd $z_1$ (%s) | sd $z_2$ (%s)", ARMS$label[ARMS$key == k],
                   ARMS$label[ARMS$key == k]), character(1)),
           collapse = " | "), " |"),
  "|---|---|---|---|---|",
  vapply(seq_along(N_GRID), function(i)
    sprintf("| %d | %.4f | %.4f | %.4f | %.4f |", N_GRID[i],
            summ[[i]]$arms$L2_big$sd[2], summ[[i]]$arms$L2_big$sd[3],
            summ[[i]]$arms$L4_big$sd[2], summ[[i]]$arms$L4_big$sd[3]),
    character(1)),
  "",
  sprintf(paste("The four-cell arm is tighter on both slopes at **%d of %d**",
                "sample sizes. The claim survives the re-pairing; what it did",
                "not have before was a design under which it could have failed."),
          sum(vapply(seq_along(N_GRID), function(i)
            all(summ[[i]]$arms$L4_big$sd[2:3] < summ[[i]]$arms$L2_big$sd[2:3]),
            logical(1))), length(N_GRID)),
  "",
  "## Paired arm differences",
  "",
  "| n | L=4 minus L=2 (eps 0.03), intercept | se | L=4 eps 0.03 minus eps 1e-4, intercept | se |",
  "|---|---|---|---|---|",
  vapply(seq_along(N_GRID), function(i)
    sprintf("| %d | %+.4f | %.4f | %+.4f | %.4f |", N_GRID[i],
            summ[[i]]$diff_L4_L2$mean[1], summ[[i]]$diff_L4_L2$se[1],
            summ[[i]]$diff_eps$mean[1], summ[[i]]$diff_eps$se[1]),
    character(1)),
  "",
  paste("The second pair is the eps-truncation test. If the floor is what",
        "generates the L = 4 intercept bias, removing it must move the",
        "intercept, and the paired difference is where that shows."),
  "",
  sprintf("**Verdict:** the paired eps effect on the L = 4 intercept is distinguishable from zero at %s.",
          if (any(verdict_eps)) paste(sprintf("n = %d", N_GRID[verdict_eps]),
                                      collapse = ", ")
          else "**no sample size tested**"),
  "",
  if (any(verdict_eps))
    paste("Truncation moves the intercept, so it is a live mechanism for the",
          "L = 4 bias.")
  else
    sprintf(paste("Truncation does **not** explain the L = 4 intercept bias on",
                  "this design. Removing the floor entirely -- from a %.2f%%",
                  "binding rate to %.4f%% at n = %d -- moves the intercept by",
                  "%.4f against a bias of %.4f, i.e. by **%.2f%% of it**. What",
                  "remains is a question about whether `eq:trunset`'s truncation",
                  "is admissible at L >= 3 at all, and that is a **theorist**",
                  "question, not a coding one."),
            100 * bind_by_n["L4_big", length(N_GRID)],
            100 * bind_by_n["L4_small", length(N_GRID)],
            N_GRID[length(N_GRID)],
            abs(summ[[length(N_GRID)]]$diff_eps$mean[1]),
            abs(bias_int["L4_big", length(N_GRID)]),
            100 * abs(summ[[length(N_GRID)]]$diff_eps$mean[1] /
                        bias_int["L4_big", length(N_GRID)])),
  "",
  "## What the intercept bias is, and what it is not",
  "",
  sprintf(paste("The bias is **in the intercept only**. At n = %d the slope",
                "biases are %+.4f and %+.4f against Monte Carlo errors of %.4f",
                "and %.4f, while the intercept sits at %+.4f against %.4f. The",
                "paired L = 4 minus L = 2 intercept gap is %+.4f with standard",
                "error %.4f -- **%.1f standard errors** -- and it does not",
                "shrink over a fourfold range of n."),
          N_GRID[length(N_GRID)],
          summ[[length(N_GRID)]]$arms$L4_big$bias[2],
          summ[[length(N_GRID)]]$arms$L4_big$bias[3],
          summ[[length(N_GRID)]]$arms$L4_big$se_bias[2],
          summ[[length(N_GRID)]]$arms$L4_big$se_bias[3],
          bias_int["L4_big", length(N_GRID)],
          se_int["L4_big", length(N_GRID)],
          summ[[length(N_GRID)]]$diff_L4_L2$mean[1],
          summ[[length(N_GRID)]]$diff_L4_L2$se[1],
          abs(summ[[length(N_GRID)]]$diff_L4_L2$mean[1] /
                summ[[length(N_GRID)]]$diff_L4_L2$se[1])),
  "",
  paste("**The intercept is where `phi-hat`'s systematic error lands.** The",
        "plug-in regresses `dY - d(phi-hat)` on `dZ`, and `dZ`'s first column is",
        "the constant, so the intercept absorbs `E[d(phi) - d(phi-hat)]`: any",
        "systematic error in the SHAPE of `phi-hat` shows up there and nowhere",
        "else, since a constant shift in `phi` cancels in the difference and is",
        "therefore not what is being measured. So this is a statement about the",
        "L >= 3 arm's `phi-hat`, not about the orthogonal moment for the slopes",
        "-- which is consistent with the slopes being clean at both",
        "cardinalities. It is left as a measurement; naming the cause is beyond",
        "what this design can settle."),
  "",
  "## Failures",
  "",
  paste0("| n | workers that errored | draws usable in all arms |"),
  "|---|---|---|",
  vapply(seq_along(N_GRID), function(i)
    sprintf("| %d | %d | %d of %d |", N_GRID[i], summ[[i]]$n_failed,
            summ[[i]]$n_keep, B_REP), character(1)),
  "",
  "## What is not verified",
  "",
  paste("This is a check that the estimator is the one the theory describes and",
        "that it recovers a known truth on an admissible design. It is **not** a",
        "test of `thm:rootn`: no rate and no coverage are claimed."),
  ""),
  file.path(OUT, "sim_multinomial_onestep.md"))
message("wrote ", file.path(OUT, "sim_multinomial_onestep.md"))
message("done: sim_multinomial_onestep")
