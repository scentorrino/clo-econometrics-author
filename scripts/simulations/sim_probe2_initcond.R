## ---------------------------------------------------------------------------
## sim_probe2_initcond.R -- does probe 2 retain POWER once the propensity
## conditions on the initial condition X_1?
##
## WHY.  On the Section 6 data the probe rejects A1 at p = 0.0007 when varrho-hat
## conditions on Delta Z alone, and does not reject (p = 0.34, statistic at 1.3x
## its null median) once X_1 is added.  Read literally that says
##     Delta U _||_ W | Delta Z            FAILS
##     Delta U _||_ W | (Delta Z, X_1)     is not rejected.
## The reading is only worth anything if the second test can still DETECT a
## violation.  A test that has been rendered powerless also stops rejecting, and
## from one dataset the two look identical.  This file separates them.
##
## THE DGP MIRRORS THE APPLICATION'S OWN STRUCTURE, which is the point:
##   * X_1 is endogenous -- it shares the shock xi with Delta U, which is why an
##     instrument is needed at all;
##   * W is drawn with a probability that depends on Delta Z AND ON X_1, exactly
##     as nonattainment designation is a threshold rule on the pollution LEVEL;
##   * therefore Delta U is NOT independent of W given Delta Z alone (the path
##     runs W <- X_1 -> xi -> Delta U), but IS independent given (Delta Z, X_1),
##     since conditionally on those W's only remaining randomness is an
##     independent uniform.
## So `lam = 0` is a DGP where A1 fails and A1' holds -- the exact configuration
## the real data appears to be in.  `lam > 0` loads Delta U directly on
## (W - varrho), which breaks A1' too.
##
## Four cells:
##   A1' true , varrho-hat(Delta Z)        -> should REJECT (mirrors the data)
##   A1' true , varrho-hat(Delta Z, X_1)   -> SIZE   (must be near 5%)
##   A1' false, varrho-hat(Delta Z, X_1)   -> POWER  (must be well above 5%)
##   A1' false, varrho-hat(Delta Z)        -> reject, reported for completeness
##
## Writes quality_reports/sim/probe2_initcond_summary.md.
## ---------------------------------------------------------------------------

suppressMessages({library(here); library(parallel)})
source(here::here("scripts", "R", "lf_panel.R"))
source(here::here("scripts", "R", "orthogonal_theta.R"))

THETA <- c(1.0, -0.5)
phi_true <- function(x) sin(2 * pi * x) / 2
N_SIM <- 983L; B_REF <- 300L; N_REP <- 96L; GAM <- 1.0

dgp <- function(n, gamma, lam) {
  z  <- matrix(rnorm(n * 2), n, 2); zx <- z[, 1] * z[, 2]
  xi <- rnorm(n); v1 <- rnorm(n); v2 <- rnorm(n)
  x1 <- pnorm((xi + v1) / 1.5)                     # endogenous initial condition
  ## designation depends on Delta Z AND on the LEVEL x1, as the threshold rule does
  rr <- 0.05 + 0.9 * plogis(0.2 + gamma * z[, 1] + 0.5 * gamma * z[, 2] +
                            gamma * zx + 2.5 * (x1 - 0.5))
  w  <- as.numeric(runif(n) < rr)
  x2 <- pnorm((xi + 0.9 * w + v2) / 1.5)
  du <- gamma * zx + 0.8 * xi + 0.6 * (v2 - v1) + 0.5 * rnorm(n) + lam * (w - rr)
  list(y = phi_true(x2) - phi_true(x1) + as.vector(z %*% THETA) + du,
       x1 = x1, x2 = x2, Z = z, w = w)
}

qcut <- function(v, k = 4L) cut(v, stats::quantile(v, seq(0, 1, length.out = k + 1L)),
                                include.lowest = TRUE, labels = FALSE)

one <- function(b, lam) {
  set.seed(20000L + b); d <- dgp(N_SIM, GAM, lam)
  set.seed(30000L + b)
  cf <- crossfit_once(d$y, d$x1, d$x2, d$Z, d$w, K = 5, cste = NULL,
                      lf_imax = 300L, lf_patience = 40L, n_t = 16L,
                      t_scale = 0.25, adj_wtil = TRUE, conditional = TRUE,
                      eps_rho = 0.03)
  th <- stats::lm.fit(d$Z, d$y - cf$dphi)$coefficients
  uh <- as.vector(d$y - cf$dphi - d$Z %*% th)
  n <- N_SIM
  hu <- 1.059 * stats::sd(uh) * n^(-1 / 16)
  K <- K_order(outer(uh, uh, "-") / hu, 8L)
  st <- qcut(d$x1)                       # the size-valid stratification
  stat <- function(wv, rho) {
    wt <- wv - rho; tot <- 0
    for (s in unique(st)) {
      idx <- which(st == s); wb <- mean(wv[idx])
      if (!is.finite(wb) || wb <= 0 || wb >= 1) next
      dd <- as.vector(K[idx, idx, drop = FALSE] %*% wt[idx]) /
        (length(idx) * wb * (1 - wb))
      tot <- tot + (length(idx) / n) * mean(dd^2)
    }
    tot
  }
  pval <- function(Zp) {
    rho <- fit_propensity(d$w, Zp, seq_len(n), seq_len(n), eps = 0.03)
    o <- stat(as.integer(d$w), rho)
    r <- vapply(seq_len(B_REF), function(k) stat(stats::rbinom(n, 1L, rho), rho),
                numeric(1))
    (1 + sum(r >= o)) / (B_REF + 1)
  }
  c(dz = pval(d$Z), dz_x1 = pval(cbind(d$Z, d$x1)))
}

RES <- list(); LAB <- character(0)
for (lam in c(0, 0.5)) {
  P <- do.call(rbind, mclapply(seq_len(N_REP), function(b)
    tryCatch(one(b, lam), error = function(e) rep(NA_real_, 2)), mc.cores = 8L))
  P <- P[complete.cases(P), , drop = FALSE]
  cat(sprintf("A1' %-5s (lam=%.1f), %d reps | reject at 5%%:  rho(dZ) %.3f   rho(dZ, X1) %.3f\n",
              if (lam == 0) "TRUE" else "FALSE", lam, nrow(P),
              mean(P[, 1] < 0.05), mean(P[, 2] < 0.05)))
  RES[[length(RES) + 1L]] <- c(mean(P[, 1] < 0.05), mean(P[, 2] < 0.05))
}

OUT <- here::here("quality_reports", "sim")
dir.create(OUT, showWarnings = FALSE, recursive = TRUE)
writeLines(c(
  "# Probe 2 with the initial condition in the propensity",
  "",
  sprintf("Nominal 5 per cent. n = %d, %d replications, %d null draws.", N_SIM, N_REP, B_REF),
  "DGP: W's probability depends on Delta Z AND on X_1, and X_1 shares a shock with",
  "Delta U.  So A1 (conditioning on Delta Z alone) fails by construction while",
  "A1' (conditioning on Delta Z and X_1) holds -- the configuration the Section 6",
  "data appears to be in.",
  "",
  "| | rho-hat(Delta Z) | rho-hat(Delta Z, X_1) |",
  "|---|---|---|",
  sprintf("| A1' TRUE  (size for the second column) | %.3f | **%.3f** |", RES[[1]][1], RES[[1]][2]),
  sprintf("| A1' FALSE (power) | %.3f | **%.3f** |", RES[[2]][1], RES[[2]][2]),
  "",
  "Read the second column. If size is near 0.05 and power is well above it, then",
  "the non-rejection on the real data once X_1 enters the propensity is evidence",
  "that A1' holds -- not evidence that the test has been disarmed.",
  "",
  "Produced by scripts/simulations/sim_probe2_initcond.R."),
  file.path(OUT, "probe2_initcond_summary.md"))
message("wrote ", file.path(OUT, "probe2_initcond_summary.md"))
