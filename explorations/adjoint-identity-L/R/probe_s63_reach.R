## ---------------------------------------------------------------------------
## probe_s63_reach.R -- does the adjoint finding reach Section 6.3's
## four-category p-values?
##
## DIAGNOSTIC ONLY.  Writes nothing into paper/ or quality_reports/theory/.
##
## Section 6.3's localisation p-values are a randomisation test: the statistic is
## cell_norms(w4) = ||M_l||_{L2(Pi_u x Pi_t)} evaluated at
##     u-hat = Delta y - Delta phi-hat - Delta Z' theta-hat,
## and the reference redraws W from varrho-hat HOLDING u-hat FIXED.  So phi-hat
## enters the test ONLY through u-hat.  Two things follow and both are measured
## here rather than argued:
##
##   (A) the four-cell adjoint diagnostic, re-run at the REAL Section 6.3
##       configuration (n = 983, d_Z = 5, L = 4, the trigger instrument);
##   (B) the SENSITIVITY of the observed statistic and of the p-values to
##       phi-hat, by recomputing both at three different phi-hat:
##         * the shipped four-category crossfit fit (reproduces the table),
##         * phi-hat = 0 (no nonparametric correction at all),
##         * the BINARY crossfit fit (a phi-hat produced by the sans-L = 2 path,
##           which the four-cell table certifies separately).
##       If the p-values are stable across the three, they do not turn on which
##       phi-hat the machinery produced.  If they move, they do.
## ---------------------------------------------------------------------------

suppressMessages({
  library(here)
  library(MASS)
})

source(here::here("scripts", "R", "lf_panel.R"))
source(here::here("scripts", "R", "orthogonal_theta.R"))
source(here::here("scripts", "application", "app_tsp_common.R"))
source(here::here("explorations", "adjoint-identity-L", "R",
                  "adjoint_kit.R"))

set.seed(20260810L)          # SEED_LOCALISE, the shipped value

CELLS  <- 0:3
D_Z    <- 5L                 # app_tsp_08_localise.R:97, the Section 6.2 control set
B_REF  <- 400L               # smaller than the shipped 2000; floor is 1/(B+1)
EPS_DIAG <- EPS_LOCALISE

# ---- data and instrument, verbatim from app_tsp_08_localise.R --------------

PN <- load_tsp_panel()
dt <- PN$dt
n  <- nrow(dt)
v  <- utils::read.csv(here::here("data", "raw", "tsp_iv_variants.csv"))
key_dt <- paste(dt$StateCode, dt$CountyCode)
key_v  <- paste(v$StateCode, v$CountyCode)
idx    <- match(key_dt, key_v)
stopifnot(!anyNA(idx), length(idx) == n)
vv <- v[idx, , drop = FALSE]
w4 <- with(vv, ifelse(mean_viol == 0 & badday_A == 0, 0L,
             ifelse(mean_viol == 0 & badday_A == 1, 1L,
             ifelse(mean_viol == 1 & badday_A == 0, 2L, 3L))))
w2 <- dt$w
stopifnot(identical(as.numeric(w4 > 0L), as.numeric(w2)))

Z  <- make_design(dt, d_z = D_Z)
xc <- make_x_coord(dt$x1_raw, dt$x2_raw, mode = "rank")
y  <- dt$dy
xev <- seq(stats::quantile(c(xc$x1, xc$x2), XEVAL_LO),
           stats::quantile(c(xc$x1, xc$x2), XEVAL_HI), length.out = N_XEVAL)

message(sprintf("s6.3: n = %d, d_Z = %d, cells %s", n, D_Z,
                paste(as.vector(table(factor(w4, levels = CELLS))),
                      collapse = " / ")))

# ---- (A) the four-cell adjoint diagnostic at the real configuration --------

anchor <- .Random.seed
fit_cf <- function(wv, eps) {
  assign(".Random.seed", anchor, envir = globalenv())
  crossfit_once(y, xc$x1, xc$x2, Z, wv, K = N_FOLDS, cste = LF_CSTE,
                lf_imax = LF_IMAX, lf_patience = LF_PATIENCE, n_t = N_T,
                bier_seed = BIER_SEED, t_scale = T_SCALE, adj_wtil = ADJ_WTIL,
                tau_dp = TAU_DP, conditional = TRUE, eps_rho = eps,
                xeval = xev, verbose = FALSE)
}

cf4 <- fit_cf(w4, EPS_DIAG)
cf2 <- fit_cf(w2, EPS_DIAG)

one_step_theta <- function(cf) {
  th0 <- stats::lm.fit(Z, y - cf$dphi)$coefficients
  th0[!is.finite(th0)] <- 0
  m0 <- cf$eval_moment(th0)
  J0i <- tryCatch(solve(m0$J), error = function(e) MASS::ginv(m0$J))
  as.vector(th0 - J0i %*% colMeans(m0$psi))
}
th4 <- one_step_theta(cf4)
uh4 <- as.vector(y - cf4$dphi - Z %*% th4)

message("-- (A) adjoint diagnostic at the shipped Section 6.3 residual --")
DAT <- list(x1 = xc$x1, x2 = xc$x2, Z = Z, y = y)
tab_a <- list()
for (Lk in c(2L, 4L)) {
  wv <- if (Lk == 2L) w2 else w4
  P <- build_pieces_at(DAT, wv, xev, uh4, eps_rho = EPS_DIAG,
                       n_t = N_T, t_scale = T_SCALE, bier_seed = BIER_SEED)
  g1 <- gate_reconstruction(P)
  g2 <- gate_xside(P)
  for (aw in c(TRUE, FALSE)) {
    g3 <- gate_uside(P, aw)
    cell <- run_cell(P, aw, smooth = TRUE, n_pair = 200L)
    mp <- summarise_map(P, aw)
    tab_a[[sprintf("L%d_adj%s", Lk, if (aw) "T" else "F")]] <-
      c(cell, mp, list(L = Lk, adj = aw, gate_comperr = g1,
                       gate_x = g2[["transpose"]],
                       gate_A = g3[["exact_is_adjoint_of_A"]],
                       gate_C = g3[["code_is_adjoint_of_C"]],
                       cos_step = step_alignment(P, aw)))
  }
}

# ---- (B) sensitivity of the Section 6.3 statistic to phi-hat ---------------

#' Per-cell L2(Pi_u x Pi_t) norm of the moment (verbatim from
#' app_tsp_08_localise.R::cell_norms, with u supplied).
cell_norms_at <- function(uu, wvec, bier, rho_mat) {
  hu <- bw_u(uu)
  Ku <- K_order(outer(uu, uu, "-") / hu, 8L)
  Wind <- vapply(CELLS[-1], function(k) as.numeric(as.integer(wvec) == k),
                 numeric(n))
  wt <- Wind - rho_mat
  wt <- sweep(wt, 2L, colMeans(wt), "-")
  vapply(seq_len(length(CELLS) - 1L), function(l) {
    M <- (Ku %*% (wt[, l] * bier$Wt)) / n
    sqrt(sum(colMeans(M^2) * bier$pi_t))
  }, numeric(1))
}

Rho_cf <- as.matrix(cf4$rho_hat)
stopifnot(nrow(Rho_cf) == n, ncol(Rho_cf) == length(CELLS) - 1L)
bier <- make_bierens(Z, n_t = N_T, seed = BIER_SEED, scale = T_SCALE)

allp <- cbind(1 - rowSums(Rho_cf), Rho_cf)
allp <- pmax(allp, 0)
cumP <- allp
for (k in seq(2L, ncol(allp))) cumP[, k] <- cumP[, k - 1L] + allp[, k]
U_NULL <- matrix(stats::runif(n * B_REF), n, B_REF)

#' The three p-values at a given residual.
pvals_at <- function(uu) {
  obs <- cell_norms_at(uu, w4, bier, Rho_cf)
  ref <- matrix(NA_real_, B_REF, length(CELLS) - 1L)
  for (b in seq_len(B_REF)) {
    wb <- pmin(rowSums(U_NULL[, b] > cumP), length(CELLS) - 1L)
    ref[b, ] <- cell_norms_at(uu, wb, bier, Rho_cf)
  }
  list(obs = obs, med = apply(ref, 2L, stats::median),
       p = vapply(seq_along(obs), function(l)
         (1 + sum(ref[, l] >= obs[l])) / (B_REF + 1), numeric(1)))
}

message("-- (B) phi-hat sensitivity of the localisation statistic --")
th2 <- one_step_theta(cf2)
th0 <- stats::lm.fit(Z, y)$coefficients
variants <- list(
  `phi-hat: shipped L=4` = as.vector(y - cf4$dphi - Z %*% th4),
  `phi-hat: shipped L=2` = as.vector(y - cf2$dphi - Z %*% th2),
  `phi-hat: zero`        = as.vector(y - Z %*% th0)
)
tab_b <- lapply(variants, pvals_at)

# ---- phi-hat shape and the LF stopping behaviour ---------------------------

shape <- function(cf) {
  pe <- cf$phi_grid
  ramp <- xev - mean(xev)
  cc <- function(a, b) sum(a * b) / sqrt(sum(a^2) * sum(b^2))
  stop_idx <- vapply(cf$lf_info, function(z) as.integer(z$iter), integer(1))
  cap <- vapply(cf$lf_info, function(z) isTRUE(z$hit_cap), logical(1))
  c(corr_ramp = cc(pe - mean(pe), ramp), monotone = mean(diff(pe) > 0),
    sup = max(abs(pe)), med_stop = stats::median(stop_idx),
    max_stop = max(stop_idx), frac_cap = mean(cap), frac_iter1 = mean(stop_idx == 1L))
}
sh4 <- shape(cf4); sh2 <- shape(cf2)

saveRDS(list(A = tab_a, B = tab_b, shape4 = sh4, shape2 = sh2,
             phi4 = cf4$phi_grid, phi2 = cf2$phi_grid, xev = xev),
        here::here("explorations", "adjoint-identity-L", "output",
                   "s63_reach.rds"))

# ---- report ---------------------------------------------------------------

fe <- function(x) formatC(x, format = "e", digits = 2)
ff <- function(x) formatC(x, format = "f", digits = 4)

cat("\n\n===== (A) FOUR-CELL ADJOINT DIAGNOSTIC AT THE SECTION 6.3 DESIGN ====\n")
cat("n = 983, d_Z = 5, trigger instrument, residual = the shipped L=4 u-hat\n\n")
cat(sprintf("%-11s %-11s %-11s %-11s %-10s %-10s %-10s\n", "cell",
            "rel(code)", "rel(exact)", "cs(code)", "asym_code", "neg_code",
            "cos_step"))
for (k in names(tab_a)) {
  r <- tab_a[[k]]
  cat(sprintf("%-11s %-11s %-11s %-11s %-10s %-10s %-10s\n", k,
              fe(r$rel_code), fe(r$rel_exact), fe(r$cs_code),
              fe(r$asym_code), ff(r$ev_code[["neg_mass"]]),
              ff(r$cos_step)))
}
cat("\ngates (must be at machine precision):\n")
for (k in names(tab_a)) {
  r <- tab_a[[k]]
  cat(sprintf("  %-11s comperr %s | x-transpose %s | A*/A %s | code/C %s\n",
              k, fe(r$gate_comperr), fe(r$gate_x), fe(r$gate_A),
              fe(r$gate_C)))
}

cat("\n\n===== (B) SENSITIVITY OF THE SECTION 6.3 P-VALUES TO phi-hat ========\n")
cat("B =", B_REF, "null draws; p floor is", ff(1 / (B_REF + 1)), "\n\n")
cat(sprintf("%-24s %-10s %-10s %-10s %-10s %-10s %-10s\n", "residual",
            "|M_1|", "|M_2|", "|M_3|", "p_1", "p_2", "p_3"))
for (k in names(tab_b)) {
  r <- tab_b[[k]]
  cat(sprintf("%-24s %-10s %-10s %-10s %-10s %-10s %-10s\n", k,
              fe(r$obs[1]), fe(r$obs[2]), fe(r$obs[3]),
              ff(r$p[1]), ff(r$p[2]), ff(r$p[3])))
}
cat("\nnull medians (same three cells), per residual:\n")
for (k in names(tab_b)) {
  r <- tab_b[[k]]
  cat(sprintf("  %-24s %s %s %s\n", k, fe(r$med[1]), fe(r$med[2]),
              fe(r$med[3])))
}

cat("\n\n===== phi-hat SHAPE AND LF STOPPING, SHIPPED SECTION 6.3 FITS =======\n")
cat(sprintf("%-8s %-11s %-10s %-9s %-10s %-10s %-10s %-11s\n", "arm",
            "corr(ramp)", "monotone", "sup|phi|", "med stop", "max stop",
            "frac cap", "frac iter1"))
for (nm in c("L=4", "L=2")) {
  s <- if (nm == "L=4") sh4 else sh2
  cat(sprintf("%-8s %-11s %-10s %-9s %-10s %-10s %-10s %-11s\n", nm,
              ff(s[["corr_ramp"]]), ff(s[["monotone"]]), fe(s[["sup"]]),
              ff(s[["med_stop"]]), ff(s[["max_stop"]]), ff(s[["frac_cap"]]),
              ff(s[["frac_iter1"]])))
}
cat("\ndone\n")
