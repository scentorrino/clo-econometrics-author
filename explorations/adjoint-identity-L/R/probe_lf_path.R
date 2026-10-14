## ---------------------------------------------------------------------------
## probe_lf_path.R -- how far does the LF iteration actually travel?
##
## DIAGNOSTIC ONLY.
##
## The adjoint table left one number needing a direct check.  On the q-space map
## the per-iteration contraction factor on the BEST-CONDITIONED direction is
##     1 - cste * lambda_max  =  0.9996 at sans-L = 2 and 0.9999 at sans-L = 4,
## i.e. cste sits about 2,500x (sans-L = 2) and 10,000x (sans-L = 4) below the
## Landweber-optimal step 1/lambda_max.  If that is right, the iteration removes
## a fraction of a percent of even the direction it sees best, and what it mostly
## does over m steps is ADD m * cste * A*(observed residual) -- an accumulation
## linear in m, and therefore a function of the stopping index alone.
##
## That reconstruction goes through a grid-coordinate stand-in for the shipped
## (d1, d2) state, so it is checked here against a DIRECT observable instead:
## the discrepancy path ||That_m|| that lf_solve() already records.  If cste is
## as conservative as the spectrum says, ||That_m|| must barely move over the
## whole run, and it must sit far above tau_dp * delta-hat_n throughout at
## sans-L = 4.
## ---------------------------------------------------------------------------

suppressMessages({
  library(here)
})

source(here::here("scripts", "R", "lf_panel.R"))
source(here::here("scripts", "R", "orthogonal_theta.R"))

set.seed(20260811L)

THETA      <- c(1.0, -0.5)
PHI_TRUE   <- function(x) sin(2 * pi * x) / 2
GAMMA      <- 1.2
CELL_SHIFT <- c(0, 0.6, 0.9, 1.2)
IMAX       <- 60L
N_REP      <- 8L

dgp_draw4 <- function(n, gamma = GAMMA) {
  z  <- matrix(stats::rnorm(n * 2L), n, 2L)
  zx <- z[, 1] * z[, 2]
  eta <- cbind(0, 0.20 + gamma * z[, 1], 0.10 + 0.5 * gamma * z[, 2],
               -0.10 + gamma * zx)
  P <- exp(eta) / rowSums(exp(eta))
  cum <- P
  for (k in seq(2L, ncol(P))) cum[, k] <- cum[, k - 1L] + P[, k]
  w4 <- pmin(rowSums(stats::runif(n) > cum), ncol(P) - 1L)
  xi <- stats::rnorm(n); v1 <- stats::rnorm(n); v2 <- stats::rnorm(n)
  x1 <- stats::pnorm((xi + v1) / 1.5)
  x2 <- stats::pnorm((xi + CELL_SHIFT[w4 + 1L] + v2) / 1.5)
  du <- gamma * zx + 0.6 * (v2 - v1) + 0.5 * stats::rnorm(n)
  list(y  = PHI_TRUE(x2) - PHI_TRUE(x1) + as.vector(z %*% THETA) + du,
       x1 = x1, x2 = x2, Z = cbind(const = 1, z), w4 = w4,
       w2 = as.numeric(w4 > 0L))
}

#' One LF solve on the full sample, run to the cap, with the whole path kept.
#'
#' tau_dp = 1e-12 makes the discrepancy stop unreachable, so the path is the
#' full one; the index at which the SHIPPED rule (tau_dp = 0.7) would have
#' stopped is recomputed from the returned err_path and noise_path.
one_path <- function(d, w) {
  n <- length(w)
  xev <- seq(stats::quantile(c(d$x1, d$x2), 0.05),
             stats::quantile(c(d$x1, d$x2), 0.95), length.out = 60L)
  op <- make_operator(d$x1, d$x2, xev)
  cells <- sort(unique(as.integer(w)))
  L <- length(cells)
  fit_idx <- sample(seq_len(n), floor(n / 2))
  Rho <- fit_propensity_multi(w, d$Z, fit_idx, seq_len(n), eps = 0.03,
                              cells = cells)
  attr(Rho, "prop_diag") <- NULL
  rho <- if (L == 2L) as.vector(Rho) else Rho
  bier <- make_bierens(d$Z, n_t = 16L, seed = 20260805L, scale = 0.25)
  init <- init_control(d$y, d$x1, d$x2, d$Z, w, op)
  fit <- lf_solve(d$y, d$x1, d$x2, d$Z, w, op, init, rho = rho, bier = bier,
                  adj_wtil = TRUE, cste = NULL, imax = IMAX, patience = IMAX,
                  tau_dp = 1e-12)
  e <- fit$err_path; nz <- fit$noise_path
  hit <- which(e <= 0.7 * nz)
  phi <- cumtrapz_centre(xev, fit$dev); phi <- phi - mean(phi)
  p0 <- PHI_TRUE(xev); p0 <- p0 - mean(p0)
  c(L = L, cste = fit$cste, e1 = e[1], eM = e[length(e)],
    drop = 1 - e[length(e)] / e[1],
    ratio1 = e[1] / (0.7 * nz[1]), ratioM = e[length(e)] / (0.7 * nz[length(e)]),
    dp_index = if (length(hit)) hit[1] else NA_real_,
    b = sum(phi * p0) / sum(p0^2),
    nrm = sqrt(sum(phi^2)) / sqrt(sum(p0^2)))
}

RES <- list()
for (n in c(400L, 1600L)) {
  message("== n = ", n, " ==")
  for (Lk in c(2L, 4L)) {
    M <- matrix(NA_real_, N_REP, 10L)
    for (b in seq_len(N_REP)) {
      set.seed(90000L + 17L * b + n)
      d <- dgp_draw4(n)
      w <- if (Lk == 2L) d$w2 else d$w4
      M[b, ] <- one_path(d, w)
    }
    colnames(M) <- c("L", "cste", "e1", "eM", "drop", "ratio1", "ratioM",
                     "dp_index", "b", "nrm")
    RES[[sprintf("n%d_L%d", n, Lk)]] <- M
  }
}
saveRDS(RES, here::here("explorations", "adjoint-identity-L", "output",
                        "lf_path.rds"))

ff <- function(x) formatC(x, format = "f", digits = 4)
fe <- function(x) formatC(x, format = "e", digits = 2)
cat("\n\n===== LF DISCREPANCY PATH, RUN TO THE CAP (imax =", IMAX, ") ======\n")
cat("drop   = 1 - ||That_60|| / ||That_1||, how much of the discrepancy the\n")
cat("         whole run removes\n")
cat("ratio  = ||That_m|| / (tau_dp delta-hat_n); the shipped rule stops at the\n")
cat("         first m where this is <= 1\n")
cat("dp_idx = that index, NA if the rule never fires inside the cap\n\n")
cat(sprintf("%-10s %-10s %-9s %-9s %-9s %-9s %-9s %-9s\n", "arm", "cste",
            "drop", "ratio@1", "ratio@60", "dp_idx", "b", "nrm"))
for (k in names(RES)) {
  M <- RES[[k]]
  m <- colMeans(M, na.rm = TRUE)
  n_fire <- sum(!is.na(M[, "dp_index"]))
  cat(sprintf("%-10s %-10s %-9s %-9s %-9s %-9s %-9s %-9s\n", k, fe(m[["cste"]]),
              ff(m[["drop"]]), ff(m[["ratio1"]]), ff(m[["ratioM"]]),
              sprintf("%d/%d", n_fire, nrow(M)), ff(m[["b"]]), ff(m[["nrm"]])))
}
cat("\ndone\n")
