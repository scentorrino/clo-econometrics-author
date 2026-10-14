# ============================================================================
# sim_bierens_validate.R
#
# Validation arm for the CONDITIONAL-INDEPENDENCE estimator, added 2026-08-05.
#
# WHY THIS ARM EXISTS.  scripts/R/lf_panel.R began as an R port of
# lfindfn_short_panel.m, whose model is Delta U _||_ W UNCONDITIONALLY.  This
# paper's A1 is the conditional form Delta U _||_ W | Delta Z, and until
# 2026-08-05 the engine had not followed: W was centred at mean(W) rather than
# at varrho(Delta Z); there was no Bierens family w(t' Phi(Delta Z)); and the
# adjoint omitted the Wtilde_j factor that lem:adjoint(i) places inside
# g_{u,t} = Wtilde w(t' Phi(Delta Z)) f(u).  All three are now implemented.
#
# WHAT IT MEASURES, AND ON WHAT CRITERION.  The criterion is FIDELITY, not
# smallest RMSE: the estimator must be the one the theory describes.  This arm
# therefore answers three questions in order.
#
#   Q1  CONSISTENCY.  Does theta-hat concentrate on theta as n grows, under a
#       DGP where A1 holds and varrho is genuinely non-constant?  A faithful
#       estimator must; an unfaithful one solving a different population
#       equation need not.
#   Q2  THE COMPARISON THAT MATTERS.  At the same n, does the faithful
#       configuration beat the ported one on BIAS?  Bias, not RMSE, because the
#       defect is that the unfaithful moment is centred at the wrong place --
#       a variance difference is a tuning question, a bias difference is not.
#   Q3  TUNING.  Pi_t's spread is a free choice under B1(iv) (it asks only for a
#       nonzero absolutely continuous part), so t_scale and n_t are
#       implementation constants.  Swept here so the shipped values are chosen
#       on evidence and registered, not inherited.
#
# The earlier scratchpad A/B could not answer any of these: 10 replications at
# n = 600 gave Monte Carlo error larger than every difference it reported.  The
# replication counts below are set so that a bias difference of 0.02 is
# resolvable at the largest n.
#
#   Rscript scripts/simulations/sim_bierens_validate.R
#
# Checkpoints after every cell to quality_reports/sim/sim_bierens_ckpt.rds and
# resumes from it, on the pattern of the other parallel arms.  The checkpoint
# carries an md5 of every source file that defines a replication and is
# DISCARDED if any has changed, so a resumed run cannot merge vintages.
# ============================================================================

library(here)
library(parallel)

source(here::here("scripts", "R", "lf_panel.R"))
source(here::here("scripts", "R", "orthogonal_theta.R"))

RNGkind("L'Ecuyer-CMRG")
set.seed(20260805L)                                                  # INV-14

OUT  <- here::here("quality_reports", "sim")
CKPT <- file.path(OUT, "sim_bierens_ckpt.rds")
dir.create(OUT, showWarnings = FALSE, recursive = TRUE)

SIM_CORES <- 8L            # fixed, not detectCores(), so the run is a
                           # declared cost rather than a host-dependent one.
                           # It does NOT affect the numbers: every replication
                           # draws from streams[[b]] and set.seed(7000L + b),
                           # both functions of b alone, so results are
                           # core-count invariant.  (This comment claimed the
                           # opposite until 2026-08-07.)

THETA <- c(1.0, -0.5)
## Measured cost of one cross-fit at these n, with lf_imax = 60 and K = 5:
##   n =  400   3.3s      n =  800   8.2s      n = 1600  32.3s
## so the grid below is about 4 hours on SIM_CORES = 8.  n = 3200 was measured
## at roughly 130s a fit, which would have taken the whole arm past 17 hours;
## it is dropped rather than run at a replication count too small to resolve
## anything, which is the mistake the scratchpad A/B made.
N_GRID <- c(400L, 800L, 1600L)
B_REP  <- 200L             # resolves a bias gap of ~0.02 at the largest n

## ---- DGP ------------------------------------------------------------------
## A1 holds by construction: Delta U is drawn independently of W GIVEN Delta Z.
## gamma controls how far varrho is from constant; at gamma = 0 the conditional
## and unconditional models coincide and every configuration must agree.
##
## REDESIGNED 2026-08-07.  The previous draw set du = 0.6(v2 - v1) + 0.5*eps, a
## function of (v1, v2, eps) alone, while w was a function of (z, unif) alone.
## Disjoint independent sets, so Delta U was independent of W UNCONDITIONALLY
## as well as conditionally, AT EVERY gamma.  The unconditional moment
## E[(W - E W) 1{Delta U <= u}] was therefore zero at the truth: the ported
## centring was not misspecified under that DGP, so the sweep could not exhibit
## the defect it was written to exhibit.  What it could show -- that the weaker
## restriction is less identifying -- is real and worth showing, but it is not
## the same claim, and three shipped documents called the ported arm
## "inconsistent" on the strength of it.
##
## The fix puts a z1*z2 term in BOTH the propensity index and Delta U:
##   * E[Delta Z * (z1 z2)] = (E[z1^2 z2], E[z1 z2^2]) = (0, 0), so the mean
##     restriction identifying theta is untouched and theta_dagger = THETA;
##   * Cov(W, Delta U) is now of order gamma^2 * Var(z1 z2) != 0, so W - E[W] is
##     the WRONG centring and the ported engine is genuinely misspecified;
##   * conditionally on Delta Z the added term is a constant shift, so
##     Delta U _||_ W | Delta Z -- A1 -- still holds exactly.
## A term linear in z cannot do this and neither can z1^2 - 1 reliably: for
## Gaussian z, E[z g(z)] = 0 forces Cov(a'z, g(z)) = 0, so any g orthogonal to
## Delta Z is uncorrelated with a LINEAR index and the contrast survives only
## through the link's curvature.  The interaction puts the contrast in the
## index itself.
## At gamma = 0 both new terms vanish, so the gamma = 0 column keeps its role
## as the check that every configuration must agree when the models coincide.
phi_true <- function(x) sin(2 * pi * x) / 2

dgp_draw <- function(n, gamma) {
  z   <- matrix(rnorm(n * 2), n, 2)
  zx  <- z[, 1] * z[, 2]                      # mean 0, orthogonal to z1 and z2
  rr  <- 0.05 + 0.9 / (1 + exp(-(0.2 + gamma * z[, 1] + 0.5 * gamma * z[, 2] +
                                 gamma * zx)))
  w   <- as.numeric(runif(n) < rr)
  xi <- rnorm(n); v1 <- rnorm(n); v2 <- rnorm(n)
  x1 <- pnorm((xi + v1) / 1.5)
  x2 <- pnorm((xi + 0.9 * w + v2) / 1.5)      # instrument moves X
  du <- gamma * zx + 0.6 * (v2 - v1) + 0.5 * rnorm(n)
  dy <- phi_true(x2) - phi_true(x1) + as.vector(z %*% THETA) + du
  list(y = dy, x1 = x1, x2 = x2, Z = z, w = w, varrho = rr)
}

## ---- one estimate ---------------------------------------------------------
## Returns theta-hat AND the integrated squared error of phi-hat.
##
## BOTH criteria are needed and they answer different questions.  theta is
## identified by the mean restriction E[Delta Z Delta U] = 0, so theta's bias
## reads on the CENTRING and the ADJOINT but cannot speak to the Bierens family,
## whose job is to identify PHI.  The first run of this arm scored theta only
## and therefore could not validate the family at all.
##
## `conditional` is passed INTO crossfit_once.  It used to be applied by
## patching the returned rho_hat, which does nothing, because eval_moment is a
## closure over that function's environment -- so the first run compared the
## conditional estimator with itself.
fit_one <- function(d, cfg, seed) {
  set.seed(seed)
  cf <- crossfit_once(d$y, d$x1, d$x2, d$Z, d$w, K = 5, cste = NULL,
                      lf_imax = 60, lf_patience = 20,
                      n_t = cfg$n_t, t_scale = cfg$t_scale,
                      adj_wtil = cfg$adj_wtil, conditional = cfg$conditional,
                      eps_rho = 0.03)
  t0 <- stats::lm.fit(d$Z, d$y - cf$dphi)$coefficients
  m  <- cf$eval_moment(t0)
  jj <- tryCatch(solve(m$J, colMeans(m$psi)), error = function(e) rep(NA_real_, 2))
  ## phi is identified only up to the centring def:spaces imposes, so compare
  ## the centred curves on the shared grid.
  pt <- phi_true(cf$xeval); pt <- pt - mean(pt)
  ph <- cf$phi_grid;        ph <- ph - mean(ph)
  ise <- mean((ph - pt)^2)
  c(as.vector(t0 - jj), ise)
}

## ---- configurations -------------------------------------------------------
## PORTED is the pre-2026-08-05 engine: the predecessor's estimator.
## FAITHFUL is what lem:adjoint and def:hatT specify.
## The t_scale / n_t rows exist to choose those constants on evidence.
CFGS <- list(
  ## conditional = FALSE now gates the Bierens family and the adjoint Wtilde
  ## as well as the centring (orthogonal_theta.R, 2026-08-07), so this arm is
  ## the ported engine exactly.  Before that it still ran a one-column family:
  ## make_bierens(n_t = 1L) returns exp(t1' atan(Z)), which is NOT constant
  ## across observations, so the "ported" arm was not the ported engine.
  ported   = list(label = "ported (uncond, no t, no Wtil)",
                  conditional = FALSE, n_t = 1L,  t_scale = 0.5, adj_wtil = FALSE),
  ## n_t = 0L, NOT 1L.  These two arms exist to isolate the CENTRING and the
  ## ADJOINT from the Bierens family, and n_t = 1 leaves a one-column family in
  ## place (see make_bierens).  Corrected 2026-08-07; the earlier rows measured
  ## centring-plus-one-random-direction and attributed all of it to centring.
  cond     = list(label = "conditional only",
                  conditional = TRUE,  n_t = 0L,  t_scale = 0.5, adj_wtil = FALSE),
  cond_adj = list(label = "conditional + adjoint Wtil",
                  conditional = TRUE,  n_t = 0L,  t_scale = 0.5, adj_wtil = TRUE),
  faith_s25 = list(label = "FAITHFUL n_t=16 t_scale=0.25",
                  conditional = TRUE,  n_t = 16L, t_scale = 0.25, adj_wtil = TRUE),
  faith_s50 = list(label = "FAITHFUL n_t=16 t_scale=0.50",
                  conditional = TRUE,  n_t = 16L, t_scale = 0.50, adj_wtil = TRUE),
  faith_s100 = list(label = "FAITHFUL n_t=16 t_scale=1.00",
                  conditional = TRUE,  n_t = 16L, t_scale = 1.00, adj_wtil = TRUE),
  faith_t32 = list(label = "FAITHFUL n_t=32 t_scale=0.50",
                  conditional = TRUE,  n_t = 32L, t_scale = 0.50, adj_wtil = TRUE)
)
GAMMAS <- c(0, 2.0)

## ---- checkpoint -----------------------------------------------------------
src_md5 <- function() {
  f <- c(here::here("scripts", "R", "lf_panel.R"),
         here::here("scripts", "R", "orthogonal_theta.R"),
         here::here("scripts", "simulations", "sim_bierens_validate.R"))
  paste(tools::md5sum(f), collapse = "-")
}
cells <- expand.grid(cfg = names(CFGS), gamma = GAMMAS, n = N_GRID,
                     stringsAsFactors = FALSE)
done <- list()
if (file.exists(CKPT)) {
  old <- readRDS(CKPT)
  if (identical(old$src, src_md5())) {
    done <- old$done
    message(sprintf("resuming: %d of %d cells already done", length(done), nrow(cells)))
  } else {
    message("checkpoint discarded: a source file that defines a replication changed")
  }
}

streams <- vector("list", B_REP + 1L)
streams[[1]] <- .Random.seed
for (b in seq_len(B_REP)) streams[[b + 1L]] <- parallel::nextRNGStream(streams[[b]])

for (i in seq_len(nrow(cells))) {
  key <- paste(cells$cfg[i], cells$gamma[i], cells$n[i], sep = "|")
  if (!is.null(done[[key]])) next
  cfg <- CFGS[[cells$cfg[i]]]; gam <- cells$gamma[i]; nn <- cells$n[i]
  t0 <- Sys.time()
  est <- parallel::mclapply(seq_len(B_REP), function(b) {
    assign(".Random.seed", streams[[b]], envir = globalenv())
    d <- dgp_draw(nn, gam)
    tryCatch(fit_one(d, cfg, 7000L + b), error = function(e) rep(NA_real_, 3))
  }, mc.cores = SIM_CORES, mc.preschedule = TRUE)
  E <- do.call(rbind, est)
  ok <- stats::complete.cases(E)
  Th <- E[ok, 1:2, drop = FALSE]; Is <- E[ok, 3]
  done[[key]] <- list(cfg = cells$cfg[i], gamma = gam, n = nn,
                      bias = colMeans(Th) - THETA,
                      mcse = apply(Th, 2, stats::sd) / sqrt(sum(ok)),
                      ise = mean(Is), ise_se = stats::sd(Is) / sqrt(sum(ok)),
                      n_ok = sum(ok), B = B_REP)
  saveRDS(list(src = src_md5(), done = done), CKPT)
  message(sprintf("%-32s gamma=%.1f n=%5d  %3.0fs  bias %7.4f %7.4f  (%d/%d ok)",
                  cfg$label, gam, nn,
                  as.numeric(difftime(Sys.time(), t0, units = "secs")),
                  done[[key]]$bias[1], done[[key]]$bias[2], sum(ok), B_REP))
}

## ---- report ---------------------------------------------------------------
message("\n== bias (MC se in brackets), by configuration ==")
for (gam in GAMMAS) {
  message(sprintf("\n-- gamma = %.1f %s", gam,
                  if (gam == 0) "(models coincide: all configs must agree)" else
                    "(models differ: only a faithful estimator is centred)"))
  for (cn in names(CFGS)) {
    row <- vapply(N_GRID, function(nn) {
      r <- done[[paste(cn, gam, nn, sep = "|")]]
      if (is.null(r)) NA_real_ else r$bias[1]
    }, numeric(1))
    se <- vapply(N_GRID, function(nn) {
      r <- done[[paste(cn, gam, nn, sep = "|")]]
      if (is.null(r)) NA_real_ else r$mcse[1]
    }, numeric(1))
    message(sprintf("  %-32s %s", CFGS[[cn]]$label,
                    paste(sprintf("%7.4f(%.3f)", row, se), collapse = "  ")))
  }
  message(sprintf("  %-32s %s", "n =",
                  paste(sprintf("%14d", N_GRID), collapse = "")))
}
message("\n== phi ISE (MC se), the criterion the Bierens family is about ==")
for (gam in GAMMAS) {
  message(sprintf("\n-- gamma = %.1f", gam))
  for (cn in names(CFGS)) {
    row <- vapply(N_GRID, function(nn) {
      r <- done[[paste(cn, gam, nn, sep = "|")]]
      if (is.null(r)) NA_real_ else r$ise
    }, numeric(1))
    se <- vapply(N_GRID, function(nn) {
      r <- done[[paste(cn, gam, nn, sep = "|")]]
      if (is.null(r)) NA_real_ else r$ise_se
    }, numeric(1))
    message(sprintf("  %-32s %s", CFGS[[cn]]$label,
                    paste(sprintf("%7.4f(%.4f)", row, se), collapse = "  ")))
  }
  message(sprintf("  %-32s %s", "n =", paste(sprintf("%15d", N_GRID), collapse = "")))
}
message("\ncheckpoint: ", CKPT)
