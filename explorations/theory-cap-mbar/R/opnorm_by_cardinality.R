# ============================================================================
# opnorm_by_cardinality.R
#
# THE REALISED ||A-hat||^2 AT L = 2 AND L = 4, ON THE APPLICATION PANEL.
#
#   Rscript explorations/theory-cap-mbar/R/opnorm_by_cardinality.R
#
# WHY IT IS NEEDED.  eq:cap read at the estimator's OWN normalisation is
# m-bar_n >= ||A-hat||^2 delta-hat_n^{-2} (see eqcap_instantiate.R's header for
# the lem:scaleinv argument).  ||A-hat||^2 is stored for the binary ladder --
# app_tsp_opnorm.rds records A2 = 2.48 in the rank coordinate, stable to 8
# significant figures over four power-iteration seeds -- but NOT for the
# four-cell instrument Section 6.3 runs, because app_tsp_08_localise.R keeps the
# fit and not the step.  This file recomputes it, at the localise stage's own
# configuration, and touches nothing.
#
# READ-ONLY.  One .rds under explorations/theory-cap-mbar/output/.
# ============================================================================

suppressMessages({                                                    # INV-15
  library(here)
})
source(here::here("scripts", "R", "lf_panel.R"))
source(here::here("scripts", "R", "orthogonal_theta.R"))
source(here::here("scripts", "application", "app_tsp_common.R"))

RNGkind("L'Ecuyer-CMRG")
set.seed(SEED_OPNORM)                                                 # INV-14

OUT <- here::here("explorations", "theory-cap-mbar", "output")        # INV-16
dir.create(OUT, showWarnings = FALSE, recursive = TRUE)

D_Z <- 5L

dg <- readRDS(here::here("quality_reports", "application",
                         "app_tsp_diagnostics.rds"))
dt <- dg$panel$dt
n  <- nrow(dt)
xc <- make_x_coord(dt$x1_raw, dt$x2_raw, mode = "rank")
Z  <- make_design(dt, D_Z)
iv <- load_tsp_w4(dt)

## The two instruments Section 6 runs: the binary ladder's W and the four-cell
## trigger.  eps follows eps_for(), which is EPS_RHO at L = 2 and EPS_LOCALISE
## at L >= 3 (C24 / C27).
W_LIST <- list("2" = as.integer(dt$w), "4" = as.integer(iv$w4))

#' Realised ||A-hat||^2 for one instrument, at the full-sample operator.
#'
#' Reproduces the first four lines of lf_solve()'s step-size block: the residual
#' at the initial condition, then operator_norm2() on the weight that residual
#' carries.  Nothing downstream of the step is formed.
#'
#' @param w integer vector. The instrument.
#' @param eps numeric. Propensity truncation level.
#' @return list: L, a2, cste, eps, n_cells.
opnorm_once <- function(w, eps) {
  cells <- cells_of(w)
  xev <- seq(stats::quantile(c(xc$x1, xc$x2), 0.05),
             stats::quantile(c(xc$x1, xc$x2), 0.95), length.out = 60L)
  op <- make_operator(xc$x1, xc$x2, xev)
  R <- fit_propensity_multi(w, Z, seq_len(n), seq_len(n), eps = eps,
                            cells = cells)
  attr(R, "prop_diag") <- NULL
  rho <- if (length(cells) == 2L) as.vector(R) else R
  bier <- make_bierens(Z, n_t = N_T, seed = BIER_SEED, scale = T_SCALE)
  init <- init_control(dt$dy, xc$x1, xc$x2, Z, w, op)
  dphi0 <- locate_dphi(integrate_centre(init$d2, op$M2, op$ord2) -
                       integrate_centre(init$d1, op$M1, op$ord1),
                       dt$dy, Z, init$theta)
  u0 <- as.vector(dt$dy - Z %*% init$theta) - dphi0
  r0 <- operator_residual(u0, w, rho = rho, bier = bier, adj_wtil = ADJ_WTIL)
  a2 <- operator_norm2(op, weight = r0$adjw)
  list(L = length(cells), a2 = a2, cste = 1 / a2, eps = eps,
       n_cells = as.vector(table(factor(w, levels = cells))))
}

res <- vector("list", length(W_LIST))                                 # INV-17
names(res) <- names(W_LIST)
for (k in names(W_LIST)) {
  w <- W_LIST[[k]]
  res[[k]] <- opnorm_once(w, eps_for(w))
}

DHAT <- rate_delta_hat(n, R_FRONTIER, D_Z)
tab <- data.frame(
  L      = vapply(res, \(z) z$L, integer(1)),
  eps    = vapply(res, \(z) z$eps, numeric(1)),
  a2     = vapply(res, \(z) z$a2, numeric(1)),
  cste   = vapply(res, \(z) z$cste, numeric(1)))
tab$dhat <- DHAT
tab$mbar_tight <- tab$a2 * DHAT^(-2)
tab$mbar_current <- vapply(names(W_LIST), \(k) as.numeric(lf_mbar(W_LIST[[k]])),
                           numeric(1))

cat("\n=== realised operator norm and the scale-consistent cap, d_Z = 5 ===\n\n")
print(tab, row.names = FALSE, digits = 5)
cat(sprintf("\ndelta-hat_n at n = %d, d_Z = %d, r = %.4f: %.6f\n",
            n, D_Z, R_FRONTIER, DHAT))

saveRDS(list(res = res, tab = tab, d_z = D_Z, n = n, dhat = DHAT),
        file.path(OUT, "opnorm_by_cardinality.rds"))
cat("wrote ", file.path(OUT, "opnorm_by_cardinality.rds"), "\n", sep = "")
