## ---------------------------------------------------------------------------
## probe_01_oracle_stop.R -- WHERE DOES THE ORACLE STOP, AND WHAT RATIO SITS
## THERE, AT EACH CARDINALITY?
##
## DIAGNOSTIC ONLY.  Nothing shipped is touched; tau_dp is not changed anywhere.
##
## THE QUESTION.  lf_panel.R registers tau_dp = 0.7 with this calibration:
## "Tracking ISE(phi_m) along the whole path over 10 replications, the oracle
## stop sits at m ~ 12 and the ratio ||T-hat_m|| / delta-hat_n there has median
## 0.63 at n = 400 (IQR 0.39-0.93) and 0.76 at n = 800 (IQR 0.57-1.14)."  That
## was measured on 2026-08-07, four days before the L >= 3 path existed, so it
## was measured at L = 2 and only at L = 2.  This file re-runs exactly that
## calibration at L = 2, 3, 4 and on two designs.
##
## THREE OUTCOMES ARE POSSIBLE AND THE FILE MUST BE ABLE TO REPORT ANY OF THEM.
##   (i)  the oracle ratio is stable in L: then 0.7 is simply the L = 2 reading
##        of a constant and nothing needs changing;
##   (ii) the oracle ratio moves with L but is tight within L: then an L-aware
##        tau_dp is the fix and this file measures it;
##   (iii) at L >= 3 the whole path has b <= 0, i.e. there is no iterate worth
##        stopping at: then NO stopping rule recovers phi and the answer is a
##        property of the estimator, not of the constant.
## Outcome (iii) is the one that must not be tuned away, so `b` at the oracle is
## reported next to the ISE and never suppressed.
##
## RUNTIME, MEASURED BEFORE LAUNCH (probe_00): 0.042 / 0.18 / 0.62 seconds per
## iteration at n = 400 / 800 / 1600.  At imax = 100, B = 24, 3 cardinalities and
## 2 designs that is about 25 minutes on 8 cores.
## ---------------------------------------------------------------------------

suppressMessages({
  library(here)
  library(parallel)
})
source(here::here("scripts", "R", "lf_panel.R"))
source(here::here("scripts", "R", "orthogonal_theta.R"))
source(here::here("explorations", "phi-stop-L", "R", "path_kit.R"))

RNGkind("L'Ecuyer-CMRG")
set.seed(20260812L)

IMAX    <- 100L
B_REP   <- 24L
N_GRID  <- c(400L, 800L, 1600L)
L_GRID  <- c(2L, 3L, 4L)
D_GRID  <- c("A", "B")
N_CORES <- 8L
TAU_SHIPPED <- 0.7

CELLS <- expand.grid(dgp = D_GRID, n = N_GRID, stringsAsFactors = FALSE)

## Streams: one per (cell, replication), drawn up front so the draw a replication
## sees does not depend on how the work is scheduled.
streams <- vector("list", nrow(CELLS) * B_REP)                       # INV-17
s <- get(".Random.seed", envir = globalenv())
for (j in seq_along(streams)) {
  s <- parallel::nextRNGStream(s)
  streams[[j]] <- s
}

#' One replication: one draw, all cardinalities, PAIRED.
#'
#' The anchor is restored before each L so the propensity's fit split and the
#' operator-norm start vector are common across cardinalities; the instruments
#' are three coarsenings of the same W.
rep_one <- function(j, n, spec, off) {
  assign(".Random.seed", streams[[off + j]], envir = globalenv())
  d <- dgp_draw(n, spec)
  anchor <- get(".Random.seed", envir = globalenv())
  out <- vector("list", length(L_GRID))
  names(out) <- as.character(L_GRID)
  for (i in seq_along(L_GRID)) {
    assign(".Random.seed", anchor, envir = globalenv())
    p <- tryCatch(path_stats(path_once(d, L_GRID[i], imax = IMAX)),
                  error = function(e) NULL)
    out[[i]] <- p
  }
  out
}

CKPT <- here::here("explorations", "phi-stop-L", "output",
                   "probe_01_oracle_stop.rds")
CFG <- list(imax = IMAX, b = B_REP, n = N_GRID, L = L_GRID, d = D_GRID,
            seed = 20260812L,
            src = unname(tools::md5sum(here::here(
              "scripts", "R", c("lf_panel.R", "orthogonal_theta.R")))),
            kit = unname(tools::md5sum(here::here(
              "explorations", "phi-stop-L", "R", "path_kit.R"))))

RES <- NULL
if (file.exists(CKPT)) {
  old <- readRDS(CKPT)
  if (identical(old$cfg, CFG)) {
    RES <- old$res
    message("  reusing cached paths (configuration unchanged)")
  }
}
if (is.null(RES)) {
  RES <- vector("list", nrow(CELLS))                                 # INV-17
  names(RES) <- sprintf("%s_n%d", CELLS$dgp, CELLS$n)
  for (cc in seq_len(nrow(CELLS))) {
    t0 <- Sys.time()
    RES[[cc]] <- parallel::mclapply(seq_len(B_REP), rep_one,
                                    n = CELLS$n[cc],
                                    spec = DGP_SPEC[[CELLS$dgp[cc]]],
                                    off = (cc - 1L) * B_REP,
                                    mc.cores = N_CORES, mc.preschedule = FALSE)
    message(sprintf("  %s done in %.1f min", names(RES)[cc],
                    as.numeric(difftime(Sys.time(), t0, units = "mins"))))
  }
  saveRDS(list(cfg = CFG, res = RES), CKPT)
}

# ---- report ----------------------------------------------------------------

#' Collapse one (cell, L) to per-draw scalars.
#'
#' oracle  = argmin_m ISE(phi_m), the best iterate the path contains
#' b_orc   = projection on the truth THERE.  If this is not positive there is
#'           nothing to stop at and no tau_dp helps.
#' rat_orc = ||T_m|| / delta-hat_n at the oracle: the quantity tau_dp is.
#' m_dp    = the index the SHIPPED rule selects, NA when it never fires
#' ise_dp / ise_cap / ise_1 = ISE at the shipped stop, at the cap, at m = 1
collapse <- function(cell, L) {
  key <- as.character(L)
  ok <- vapply(cell, function(z) !is.null(z[[key]]), logical(1))
  v <- cell[ok]
  if (!length(v)) return(NULL)
  g <- function(f) vapply(v, f, numeric(1))
  orc <- vapply(v, function(z) which.min(z[[key]]$ise), integer(1))
  data.frame(
    oracle  = orc,
    b_orc   = g(function(z) z[[key]]$b[which.min(z[[key]]$ise)]),
    ise_orc = g(function(z) min(z[[key]]$ise)),
    rat_orc = g(function(z) z[[key]]$ratio[which.min(z[[key]]$ise)]),
    b_max   = g(function(z) max(z[[key]]$b)),
    b_1     = g(function(z) z[[key]]$b[1]),
    b_cap   = g(function(z) z[[key]]$b[length(z[[key]]$b)]),
    ise_1   = g(function(z) z[[key]]$ise[1]),
    ise_cap = g(function(z) z[[key]]$ise[length(z[[key]]$ise)]),
    m_dp    = g(function(z) {
      h <- which(z[[key]]$ratio <= TAU_SHIPPED); if (length(h)) h[1] else NA_real_
    }),
    ise_dp  = g(function(z) {
      h <- which(z[[key]]$ratio <= TAU_SHIPPED)
      z[[key]]$ise[if (length(h)) h[1] else length(z[[key]]$ise)]
    }),
    rat_1   = g(function(z) z[[key]]$ratio[1]),
    rat_cap = g(function(z) z[[key]]$ratio[length(z[[key]]$ratio)]),
    cste    = g(function(z) z[[key]]$cste)
  )
}

ff <- function(x, d = 4) formatC(x, format = "f", digits = d)
q3 <- function(x) sprintf("%s [%s, %s]", ff(stats::median(x, na.rm = TRUE), 2),
                          ff(stats::quantile(x, 0.25, na.rm = TRUE), 2),
                          ff(stats::quantile(x, 0.75, na.rm = TRUE), 2))

cat("\n\n===== ORACLE STOP AND THE DISCREPANCY RATIO THERE =================\n")
cat("oracle = argmin_m ISE(phi_m) over m = 1..", IMAX, "\n", sep = "")
cat("b      = <phi-hat, phi>/||phi||^2 : 1 = exact shape, 0 = no information,\n")
cat("         < 0 = ANTI-correlated.  b at the oracle is the number that says\n")
cat("         whether ANY stopping rule can work.\n")
cat("rat    = ||T-hat_m|| / delta-hat_n at the oracle: this IS tau_dp.\n")
cat("m_dp   = index the shipped rule (tau_dp = 0.7) selects; fired = how often\n\n")

TAB <- list()
for (cc in seq_len(nrow(CELLS))) {
  for (L in L_GRID) {
    df <- collapse(RES[[cc]], L)
    if (is.null(df)) next
    TAB[[length(TAB) + 1L]] <- cbind(dgp = CELLS$dgp[cc], n = CELLS$n[cc],
                                     L = L, df)
  }
}
TAB <- do.call(rbind, TAB)
saveRDS(TAB, here::here("explorations", "phi-stop-L", "output",
                        "probe_01_table.rds"))

cat(sprintf("%-4s %-6s %-3s %-16s %-16s %-16s %-9s %-9s\n",
            "dgp", "n", "L", "oracle m", "b at oracle", "ratio at oracle",
            "fired", "b at cap"))
for (dd in D_GRID) for (nn in N_GRID) for (L in L_GRID) {
  x <- TAB[TAB$dgp == dd & TAB$n == nn & TAB$L == L, ]
  if (!nrow(x)) next
  cat(sprintf("%-4s %-6d %-3d %-16s %-16s %-16s %-9s %-9s\n", dd, nn, L,
              q3(x$oracle), q3(x$b_orc), q3(x$rat_orc),
              sprintf("%d/%d", sum(!is.na(x$m_dp)), nrow(x)),
              ff(mean(x$b_cap), 3)))
}

cat("\n\n===== ISE AT EACH STOPPING CHOICE (mean over draws) ================\n")
cat(sprintf("%-4s %-6s %-3s %-11s %-11s %-11s %-11s %-11s\n", "dgp", "n", "L",
            "ISE m=1", "ISE oracle", "ISE shipped", "ISE cap", "max_m b"))
for (dd in D_GRID) for (nn in N_GRID) for (L in L_GRID) {
  x <- TAB[TAB$dgp == dd & TAB$n == nn & TAB$L == L, ]
  if (!nrow(x)) next
  cat(sprintf("%-4s %-6d %-3d %-11s %-11s %-11s %-11s %-11s\n", dd, nn, L,
              ff(mean(x$ise_1), 4), ff(mean(x$ise_orc), 4),
              ff(mean(x$ise_dp), 4), ff(mean(x$ise_cap), 4),
              ff(mean(x$b_max), 3)))
}

cat("\n\n===== THE PATH ITSELF: b_m and ratio_m at selected m ===============\n")
cat("If b_m is non-positive at EVERY m, outcome (iii) holds at that cell and\n")
cat("the recalibration question does not arise.\n\n")
MSHOW <- c(1L, 2L, 3L, 5L, 8L, 12L, 20L, 40L, 70L, 100L)
MSHOW <- MSHOW[MSHOW <= IMAX]
cat(sprintf("%-4s %-6s %-3s %s\n", "dgp", "n", "L",
            paste(sprintf("%8s", paste0("m=", MSHOW)), collapse = "")))
for (dd in D_GRID) for (nn in N_GRID) for (L in L_GRID) {
  cell <- RES[[sprintf("%s_n%d", dd, nn)]]
  key <- as.character(L)
  bb <- do.call(rbind, lapply(cell, function(z)
    if (is.null(z[[key]])) NULL else z[[key]]$b))
  if (is.null(bb)) next
  cat(sprintf("%-4s %-6d %-3d %s\n", dd, nn, L,
              paste(sprintf("%8s", ff(colMeans(bb)[MSHOW], 3)), collapse = "")))
}

cat("\ndone\n")
