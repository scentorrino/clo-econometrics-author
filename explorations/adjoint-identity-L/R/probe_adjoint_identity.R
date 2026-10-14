## ---------------------------------------------------------------------------
## probe_adjoint_identity.R -- IS THE LANDWEBER STEP CONTRACTING A SELF-ADJOINT
## MAP AT sans-L >= 3?
##
## DIAGNOSTIC ONLY.  Writes nothing into paper/, scripts/ or
## quality_reports/theory/.  Reads the shipped engine and measures it.
##
## THE QUESTION.  A Landweber-Fridman iteration converges to the minimum-norm
## solution only if the operator it contracts is A*A with A* the genuine adjoint
## of A.  If the sans-L >= 3 insertion of Wtilde in the adjoint breaks that, the
## iteration contracts a non-self-adjoint map and can settle anywhere.
##
## WHAT IS TESTED, AND IN WHICH INNER PRODUCTS.
##
##   range   L2(Pi):  <a,b> = sum_{l,m} varpi_w(l) pi_t(m) (1/n) sum_i a b
##   sample  E_n   :  <x,y> = (1/n) sum_j x_j y_j
##   domain  L2(pi):  <q,d> = int q d pi dx   (trapezoid on the xeval grid)
##
## The chain factors into an x-side and a u-side, tested SEPARATELY because only
## the u-side carries sans-L:
##
##   q  --P-->  Delta h  --A_u-->  That            (forward)
##   q <--P*--  comperr  <--Astar-- ell            (adjoint, as shipped)
##
## P  is grid -> Delta h (smoothed antiderivative, difference, locate-centring)
## P* is apply_adjoint()'s `dev` block
## A_u is the linearisation of operator_residual()'s `err` in Delta varphi
##     (eq:Adef discretised)
## Astar is operator_residual()'s `comperr` expression, RECONSTRUCTED and then
##     validated against the shipped output before any cell uses it.
##
## Four cells: sans-L in {2,4} x adj_wtil in {TRUE, FALSE}.  Every cell also
## carries an EXACT-adjoint arm, which is that cell's floating-point floor.
## ---------------------------------------------------------------------------

suppressMessages({
  library(here)
})

source(here::here("scripts", "R", "lf_panel.R"))
source(here::here("scripts", "R", "orthogonal_theta.R"))

set.seed(20260811L)

# ---- design constants (mirroring sim_multinomial_onestep.R) ----------------

THETA      <- c(1.0, -0.5)
PHI_TRUE   <- function(x) sin(2 * pi * x) / 2
GAMMA      <- 1.2
CELL_SHIFT <- c(0, 0.6, 0.9, 1.2)
N_T        <- 16L
T_SCALE    <- 0.25
BIER_SEED  <- 20260805L
EPS_RHO    <- 0.03
N_GRID_X   <- 100L
N_PAIR     <- 300L
KORD       <- 8L
N_VERIFY   <- 6L

#' One draw of the four-cell design (verbatim from sim_multinomial_onestep.R).
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
       w2 = as.numeric(w4 > 0L), du = du, P = P)
}

# ---- shared machinery ------------------------------------------------------
#
# Inner products, the forward and adjoint maps, the validation gates, the random
# probes, the cell measurement and the closed-form normal operators all live in
# adjoint_kit.R, so that this file and probe_s63_reach.R measure the SAME
# objects.  The derivations the closed forms rest on are documented there.

source(here::here("explorations", "adjoint-identity-L", "R",
                  "adjoint_kit.R"))

#' Assemble the pieces for one draw and one instrument.
#'
#' The residual is taken AT THE TRUTH: the adjoint identity is an operator
#' property and is cleanest evaluated where the theory evaluates it, at
#' varphi = varphi_dagger.
build_pieces <- function(d, w, xev) {
  u <- as.vector(d$y - d$Z %*% c(0, THETA)) - (PHI_TRUE(d$x2) - PHI_TRUE(d$x1))
  build_pieces_at(d, w, xev, u, eps_rho = EPS_RHO, n_t = N_T,
                  t_scale = T_SCALE, bier_seed = BIER_SEED)
}

# ---- driver ----------------------------------------------------------------

main <- function(n_obs) {
  message("== n = ", n_obs, " ==")
  d <- dgp_draw4(n_obs)
  xev <- seq(stats::quantile(c(d$x1, d$x2), 0.05),
             stats::quantile(c(d$x1, d$x2), 0.95), length.out = N_GRID_X)
  out <- list(gates = list(), cells = list(), maps = list())
  for (Lk in c(2L, 4L)) {
    w <- if (Lk == 2L) d$w2 else d$w4
    P <- build_pieces(d, w, xev)
    g1 <- gate_reconstruction(P)
    g2 <- gate_xside(P)
    message(sprintf("  L=%d gates: comperr %.2e | x-transpose %.2e | shipped %.2e",
                    Lk, g1, g2[["transpose"]], g2[["matches_shipped"]]))
    for (aw in c(TRUE, FALSE)) {
      g3 <- gate_uside(P, aw)
      key <- sprintf("L%d_adj%s", Lk, if (aw) "T" else "F")
      out$gates[[key]] <- c(comperr = g1, g2, g3)
      message(sprintf("    adj_wtil=%-5s u-gates: A*/A %.2e | code/C %.2e",
                      aw, g3[["exact_is_adjoint_of_A"]],
                      g3[["code_is_adjoint_of_C"]]))
      for (sm in c(TRUE, FALSE)) {
        r <- run_cell(P, aw, sm, n_pair = N_PAIR)
        r$L <- Lk; r$adj_wtil <- aw; r$smooth <- sm; r$n <- n_obs
        out$cells[[sprintf("%s_%s", key, if (sm) "smooth" else "white")]] <- r
      }
      m <- summarise_map(P, aw)
      m$cos_step <- step_alignment(P, aw)
      m$L <- Lk; m$adj_wtil <- aw; m$n <- n_obs
      out$maps[[key]] <- m
    }
    ## scal ablation -- WEAK, AND KEPT ONLY SO THE TABLE IS NOT SILENTLY SHORT
    ## A ROW IT ONCE HAD.  summarise_map() recomputes cste by calling the
    ## SHIPPED operator_residual(), which derives scal from `w` internally, so
    ## this rescales N_code but NOT cste.  asym and neg_mass are invariant to a
    ## positive rescaling of N by construction, so these rows report an identity
    ## rather than a result.  THE DECISIVE CHECK IS probe_scal_cancellation.R,
    ## which re-evaluates err, comperr AND adjw at a modified scal and compares
    ## the full step vector; it finds the step exactly invariant at
    ## adj_wtil = TRUE and scaled by 1/scal with UNCHANGED DIRECTION at
    ## adj_wtil = FALSE.
    P2 <- P; P2$scal <- P$scal * 4
    m2 <- summarise_map(P2, TRUE)
    out$maps[[sprintf("L%d_scalx4", Lk)]] <- m2
  }
  out
}

RES <- list()
for (nn in c(400L, 1600L)) RES[[as.character(nn)]] <- main(nn)

saveRDS(RES, here::here("explorations", "adjoint-identity-L", "output",
                        "adjoint_identity.rds"))

# ---- report ----------------------------------------------------------------

fe <- function(x) formatC(x, format = "e", digits = 2)
ff <- function(x) formatC(x, format = "f", digits = 4)

cat("\n\n=============== GATES (all must be at machine precision) =========\n")
cat(sprintf("%-6s %-12s %-10s %-12s %-12s %-12s %-12s\n", "n", "cell",
            "comperr", "x-transpose", "x-shipped", "A*/A", "code/C"))
for (nn in names(RES)) for (k in names(RES[[nn]]$gates)) {
  g <- RES[[nn]]$gates[[k]]
  cat(sprintf("%-6s %-12s %-10s %-12s %-12s %-12s %-12s\n", nn, k,
              fe(g[["comperr"]]), fe(g[["transpose"]]),
              fe(g[["matches_shipped"]]), fe(g[["exact_is_adjoint_of_A"]]),
              fe(g[["code_is_adjoint_of_C"]])))
}

cat("\n\n=============== FOUR-CELL ADJOINT DISCREPANCY ===================\n")
cat("rel  = |<Aq,g>_Pi - <q,A*g>_pi| / |<Aq,g>_Pi|, median over", N_PAIR,
    "pairs\n")
cat("cs   = same numerator / (||Aq||_Pi ||g||_Pi), i.e. sin of the angle\n")
cat("exact= the identity re-run with the EXACT adjoint (fp floor)\n\n")
cat(sprintf("%-6s %-3s %-9s %-8s %-11s %-11s %-11s %-11s\n", "n", "L",
            "adj_wtil", "g class", "rel(code)", "rel[10-90]", "cs(code)",
            "rel(exact)"))
for (nn in names(RES)) for (k in names(RES[[nn]]$cells)) {
  r <- RES[[nn]]$cells[[k]]
  cat(sprintf("%-6s %-3d %-9s %-8s %-11s %-11s %-11s %-11s\n", nn, r$L,
              if (r$adj_wtil) "TRUE" else "FALSE",
              if (r$smooth) "smooth" else "white",
              fe(r$rel_code),
              paste0(fe(r$rel_code_lo), "/", fe(r$rel_code_hi)),
              fe(r$cs_code), fe(r$rel_exact)))
}

cat("\n\n=========== CONTRACTED MAP ON q-SPACE: SYMMETRY & STABILITY ======\n")
cat("asym     = ||S - S'||_F / ||S + S'||_F, S = D_rho M (self-adjointness)\n")
cat("neg_mass = share of |eigenvalue| mass carried by NEGATIVE eigenvalues\n")
cat("rho      = spectral radius of (I - cste M): > 1 means Landweber AMPLIFIES\n")
cat("cos_step = cosine between the shipped step and the true gradient\n\n")
cat(sprintf("%-6s %-11s %-10s %-10s %-9s %-9s %-9s %-9s %-9s\n", "n", "cell",
            "asym_true", "asym_code", "neg_true", "neg_code", "rho_true",
            "rho_code", "cos_step"))
for (nn in names(RES)) for (k in names(RES[[nn]]$maps)) {
  m <- RES[[nn]]$maps[[k]]
  cat(sprintf("%-6s %-11s %-10s %-10s %-9s %-9s %-9s %-9s %-9s\n", nn, k,
              fe(m$asym_true), fe(m$asym_code),
              ff(m$ev_true[["neg_mass"]]), ff(m$ev_code[["neg_mass"]]),
              ff(m$rho_true), ff(m$rho_code),
              if (is.null(m$cos_step)) "--" else ff(m$cos_step)))
}

cat("\n\n=========== SHAPE OF THE DOMINANT LANDWEBER MODE =================\n")
cat("|corr| of the mode's ANTIDERIVATIVE (what phi-hat inherits) with a\n")
cat("monotone ramp and with the true sin(2 pi x)/2; monotone = share of\n")
cat("increasing steps\n\n")
cat(sprintf("%-6s %-11s %-10s %-10s %-10s %-10s\n", "n", "cell", "cste",
            "|r| ramp", "|r| sine", "monotone"))
for (nn in names(RES)) for (k in names(RES[[nn]]$maps)) {
  m <- RES[[nn]]$maps[[k]]
  cat(sprintf("%-6s %-11s %-10s %-10s %-10s %-10s\n", nn, k, fe(m$cste),
              ff(m$mode_ramp), ff(m$mode_sine), ff(m$mode_monotone)))
}
cat("\ndone\n")
