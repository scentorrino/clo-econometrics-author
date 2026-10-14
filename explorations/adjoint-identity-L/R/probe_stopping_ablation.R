## ---------------------------------------------------------------------------
## probe_stopping_ablation.R -- if the adjoint is sound, what carries the
## sans-L = 4 anti-correlation?
##
## DIAGNOSTIC ONLY.  Changes nothing shipped; `lf_imax` is varied at the CALL
## SITE, in this file.
##
## WHAT THE ADJOINT TABLE ESTABLISHED.  At adj_wtil = TRUE the contracted map is
## positive semidefinite at both cardinalities (neg_mass = 0) and the spectral
## radius of I - cste M is 1.0000 exactly.  A spectral radius of exactly one
## means the map has a NULL SPACE: along those directions Landweber neither
## contracts nor amplifies, so the recursion there is
##     q_{m+1} = q_m + cste * (projection of the data term),
## which ACCUMULATES LINEARLY IN THE ITERATION COUNT m.  That is textbook
## semiconvergence, and it makes the estimate a function of where the iteration
## is stopped and of nothing else.
##
## THE ABLATION.  If the iteration count is what carries the artifact, capping it
## must move the artifact and capping it hard must remove it.  Four arms on the
## SAME draws:
##     L = 2, cap 60     (the reference)
##     L = 4, cap 60     (the shipped setting in sim_multinomial_onestep.R)
##     L = 4, cap 8
##     L = 4, cap 3
## reporting b from the projection of phi-hat on the truth, ||phi-hat||/||phi||,
## and the realised stopping behaviour.
## ---------------------------------------------------------------------------

suppressMessages({
  library(here)
  library(parallel)
})

source(here::here("scripts", "R", "lf_panel.R"))
source(here::here("scripts", "R", "orthogonal_theta.R"))

THETA      <- c(1.0, -0.5)
PHI_TRUE   <- function(x) sin(2 * pi * x) / 2
GAMMA      <- 1.2
CELL_SHIFT <- c(0, 0.6, 0.9, 1.2)
N_REP      <- 12L
N_CORES    <- 8L
K_FOLD     <- 5L
LF_PAT     <- 20L
N_T        <- 16L
T_SCALE    <- 0.25
EPS_RHO    <- 0.03

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

ARMS <- data.frame(
  key  = c("L2_cap60", "L4_cap60", "L4_cap8", "L4_cap3"),
  L    = c(2L, 4L, 4L, 4L),
  imax = c(60L, 60L, 8L, 3L),
  stringsAsFactors = FALSE
)

#' One draw, all arms, on a COMMON cross-fitting stream.
one_draw <- function(b, n) {
  set.seed(70000L + 13L * b + n)
  d <- dgp_draw4(n)
  xev <- seq(stats::quantile(c(d$x1, d$x2), 0.05),
             stats::quantile(c(d$x1, d$x2), 0.95), length.out = 60L)
  phi0 <- PHI_TRUE(xev); phi0 <- phi0 - mean(phi0)
  anchor <- NULL
  set.seed(80000L + b)
  anchor <- get(".Random.seed", envir = globalenv())
  out <- vector("list", nrow(ARMS))
  for (a in seq_len(nrow(ARMS))) {
    assign(".Random.seed", anchor, envir = globalenv())
    w <- if (ARMS$L[a] == 2L) d$w2 else d$w4
    cf <- try(crossfit_once(d$y, d$x1, d$x2, d$Z, w, K = K_FOLD, cste = NULL,
                            lf_imax = ARMS$imax[a], lf_patience = LF_PAT,
                            n_t = N_T, t_scale = T_SCALE, adj_wtil = TRUE,
                            conditional = TRUE, eps_rho = EPS_RHO,
                            xeval = xev, verbose = FALSE), silent = TRUE)
    if (inherits(cf, "try-error")) { out[[a]] <- NULL; next }
    ph <- cf$phi_grid; ph <- ph - mean(ph)
    st <- vapply(cf$lf_info, function(z) as.integer(z$iter), integer(1))
    out[[a]] <- c(b = sum(ph * phi0) / sum(phi0^2),
                  nrm = sqrt(sum(ph^2)) / sqrt(sum(phi0^2)),
                  corr_ramp = sum(ph * (xev - mean(xev))) /
                    sqrt(sum(ph^2) * sum((xev - mean(xev))^2)),
                  med_stop = stats::median(st), frac1 = mean(st == 1L),
                  frac_cap = mean(st >= ARMS$imax[a]))
  }
  names(out) <- ARMS$key
  out
}

RES <- list()
for (n in c(400L, 1600L)) {
  message("== n = ", n, " ==")
  RNGkind("L'Ecuyer-CMRG")
  r <- mclapply(seq_len(N_REP), one_draw, n = n, mc.cores = N_CORES)
  RES[[as.character(n)]] <- r
}
saveRDS(RES, here::here("explorations", "adjoint-identity-L", "output",
                        "stopping_ablation.rds"))

ff <- function(x) formatC(x, format = "f", digits = 4)
cat("\n\n===== STOPPING-RULE ABLATION ==============================\n")
cat("b   = slope of phi-hat projected on the true sin(2 pi x)/2\n")
cat("nrm = ||phi-hat|| / ||phi||;  ramp = corr(phi-hat, monotone ramp)\n")
cat("stop = median LF stop index across folds; frac1 = share stopping at 1\n\n")
cat(sprintf("%-6s %-10s %-9s %-9s %-9s %-9s %-9s %-9s\n", "n", "arm", "b",
            "nrm", "ramp", "med stop", "frac1", "frac cap"))
for (nn in names(RES)) {
  for (k in ARMS$key) {
    v <- do.call(rbind, lapply(RES[[nn]], function(z) z[[k]]))
    if (is.null(v)) next
    m <- colMeans(v, na.rm = TRUE)
    cat(sprintf("%-6s %-10s %-9s %-9s %-9s %-9s %-9s %-9s\n", nn, k,
                ff(m[["b"]]), ff(m[["nrm"]]), ff(m[["corr_ramp"]]),
                ff(m[["med_stop"]]), ff(m[["frac1"]]), ff(m[["frac_cap"]])))
  }
}
cat("\ndone\n")
