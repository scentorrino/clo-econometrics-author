# ============================================================================
# eqcap_instantiate.R
#
# INSTANTIATE eq:cap  --  m-bar_n >= omega_n^2 delta-hat_n^{-2}  --  AT THE
# APPLICATION'S n = 983 AND AT THE SIMULATION'S SAMPLE SIZES, PER CARDINALITY.
#
#   Rscript explorations/theory-cap-mbar/R/eqcap_instantiate.R
#
# READ-ONLY.  Writes one .rds under explorations/theory-cap-mbar/output/ and
# nothing else.  It touches no shipped constant, no application artefact and no
# file under quality_reports/theory/.
#
# ---------------------------------------------------------------------------
# WHAT eq:cap IS, AND THE TWO PLACES ITS NUMERICAL CONTENT COMES FROM
#
# results_s3_estimation.tex:97-99
#     m-bar_n  >=  omega_n^2 delta-hat_n^{-2}
# with, at eq:normconst (:77-79),
#     omega_n := 2 (2 c_C)^{1/2} c_2^2 c_Pi ||1/pi||_inf^{1/2} h_u^{-1} h_x^{-1/2}
# and, at A5(i) (assumptions_main.tex:2593-2597),
#     delta-hat_n := max{ n^{-1/2} sqrt(ln n),  r_n },   r_n = n^{-r/(2r+d_Z)}.
#
# omega_n is a SURE upper bound on ||A-hat_varphi restricted to S_n||: def:lfstep
# runs the iteration on omega_n^{-1} A-hat "so that ||omega_n^{-1} A-hat|| <= 1
# SURELY", citing prp:hatAprop(i), which is deterministic.  eq:cap then sizes the
# cap so that it never pre-empts the discrepancy stop: proofs.tex:8453-8455 reads
#     c ( omega_n^{2mu} R_* / (omega_n^{-1} delta-hat^eff) )^{2/(2mu+1)}
#       = c omega_n^2 ( R_* / delta-hat^eff )^{2/(2mu+1)}
#       <= omega_n^2 delta-hat_n^{-2}
#       <= m-bar_n .
#
# SO eq:cap IS A SUFFICIENCY BOUND, NOT A CALIBRATION, AND IT CARRIES FREE
# CONSTANTS IN TWO SEPARATE PLACES.  Both are recorded here rather than resolved:
#
#   (F1) INSIDE omega_n.  C3 fixes c_C only as "a finite c_C > 0" and c_2 only as
#        "< infinity".  Neither is a number the corpus supplies.  Worse for a
#        literal instantiation, C3 asks the kernel to be supported in [-c_C, c_C],
#        and lf_panel.R's k_order(., 8) is Gaussian-based, so NO finite c_C makes
#        C3 literally true.  c_C is therefore swept over an effective-support
#        range and omega_n reported as a range, per this script's mandate.
#
#   (F2) IN THE MAJORISATION.  The step "<= omega_n^2 delta-hat_n^{-2}" DROPS the
#        Landweber constant c and the spectral source radius R_*, and replaces the
#        exponent 2/(2mu+1) by 2.  At delta-hat_n < 1 that is a strict inflation.
#        So even at a pinned omega_n the right-hand side is an upper bound on a
#        bound, and no part of the corpus claims it is tight.
#
# WHAT IS PINNED, and it matters, because it is the one free scale the corpus
# closes by hand: lem:scaleinv's closing paragraph fixes Pi to a PROBABILITY
# measure, Pi_u(R) Pi_t(T) = 1, expressly so that eq:cap has numerical content
# ("the one display whose numerical content moves is eq:cap, and pinning it is
# what the convention is for").  operator_residual() realises exactly that:
# Pi_u is the empirical measure of u, pi_t is uniform on N_T draws, Pi_w is
# uniform on L-1 cells -- three probability measures.  So c_* = 1 here and no
# range is reported on that axis.
#
# ---------------------------------------------------------------------------
# THE SECOND READING, AND WHY IT IS REPORTED BESIDE THE FIRST
#
# lf_solve() does NOT run at relaxation omega_n^{-2}.  It sets
# cste = 1/||A-hat||^2 by power iteration on the realised operator (C3 of
# app_tsp_common.R), i.e. omega_* = ||A-hat|| EXACTLY -- the tightest admissible
# Landweber relaxation, where lem:scaleinv's ||L|| <= 1 holds with equality.
# lem:scaleinv(i) says a normalisation IS a relaxation parameter and nothing
# else, and (v) says the cap must absorb omega_*^2 for whichever omega_* is used.
# Read at the estimator's own omega_*, eq:cap is
#     m-bar_n >= ||A-hat||^2 delta-hat_n^{-2},
# which is the same display evaluated at the tight norm instead of the sure
# bound.  Both are printed.  Neither is adopted here; this script decides
# nothing.
# ============================================================================

suppressMessages({                                                    # INV-15
  library(here)
})
source(here::here("scripts", "R", "lf_panel.R"))
source(here::here("scripts", "R", "orthogonal_theta.R"))
source(here::here("scripts", "application", "app_tsp_common.R"))
source(here::here("scripts", "simulations", "sim_multinomial_dgp.R"))

RNGkind("L'Ecuyer-CMRG")
set.seed(20260813L)                                                   # INV-14

OUT <- here::here("explorations", "theory-cap-mbar", "output")        # INV-16
dir.create(OUT, showWarnings = FALSE, recursive = TRUE)

## The kernel-support half-width is not a number the corpus supplies (F1), and
## the shipped kernel has no compact support at all, so it is SWEPT.  3 / 4 / 5
## bracket the Gaussian effective support at the 3-, 4- and 5-sigma truncation
## points; omega_n is proportional to sqrt(c_C), so the sweep costs a factor
## sqrt(5/3) = 1.29 on omega_n and 5/3 on the cap.
C_C_GRID <- c(3, 4, 5)

## c_Phi = sup_z ||Phi(z)||_inf.  B1(i)'s maintained choice is arctan "rescaled
## so that c_Phi = 1"; make_bierens() applies RAW atan, whose sup-norm is pi/2.
## Both are carried: `corpus` is the assumption as written, `code` is the
## estimator as it runs.  c_Phi enters c_Pi through wbar(t) = exp(c_Phi ||t||_1),
## i.e. EXPONENTIALLY in the instrument dimension, so the gap is not cosmetic.
C_PHI_CORPUS <- 1
C_PHI_CODE   <- pi / 2

#' c_2 = sup over h > 0, s_0 in [0,1], |varsigma| <= c_C of |Theta_{s_0}|.
#'
#' The shipped kernel carries no boundary adjustment -- eq:hatT uses
#' C_{h_u}(.; 1) throughout and survival_matrix() likewise -- so Theta_{s_0} is
#' Theta_1 = k_order(., 8) at every s_0 and the sup is attained at 0.  A kernel
#' that DID implement C3(ii)'s boundary family would have a strictly larger sup,
#' and omega_n is proportional to c_2^2, so every cap below is a LOWER bound on
#' the literal reading in this respect too.
#'
#' @param p_k integer. Kernel order.
#' @return numeric(1).
kernel_sup <- function(p_k = 8L) {
  gr <- seq(-8, 8, length.out = 200001L)
  max(abs(k_order(gr, p_k)))
}

#' omega_n of eq:normconst.
#'
#' @param c_c numeric. Kernel support half-width.
#' @param c_2 numeric. sup |Theta_{s_0}|.
#' @param c_pi numeric. Range-measure constant of B1(iv.c).
#' @param inv_pi numeric. ||1/pi||_inf.
#' @param h_u,h_x numeric. The two bandwidths.
#' @return numeric.
omega_n_of <- function(c_c, c_2, c_pi, inv_pi, h_u, h_x) {
  2 * sqrt(2 * c_c) * c_2^2 * c_pi * sqrt(inv_pi) * h_u^(-1) * h_x^(-1 / 2)
}

#' c_Pi of B1(iv.c) at a realised Bierens grid, under Pi_u(R) Pi_t(T) = 1.
#'
#' c_Pi^2 = Pi_u(R) int wbar(t)^2 Pi_t(dt), wbar(t) = exp(c_Phi ||t||_1).
#' Pi_t is uniform on the rows of `t_mat` (make_bierens()'s pi_t), so the
#' integral is a plain mean.  A NULL grid means the family is off (d_Z = 0,
#' every column dropped), where wbar == 1 and c_Pi = 1.
#'
#' @param t_mat numeric matrix or NULL. The t-grid, n_t x p.
#' @param c_phi numeric. sup-norm of Phi.
#' @return numeric(1).
c_pi_of <- function(t_mat, c_phi) {
  if (is.null(t_mat)) return(1)
  sqrt(mean(exp(2 * c_phi * rowSums(abs(t_mat)))))
}

# ============================================================================
# PART A  --  THE APPLICATION, n = 983
# ============================================================================

dg <- readRDS(here::here("quality_reports", "application",
                         "app_tsp_diagnostics.rds"))
ld <- readRDS(here::here("quality_reports", "application",
                         "app_tsp_ladder.rds"))
dt <- dg$panel$dt
N_APP <- nrow(dt)
stopifnot(identical(N_APP, 983L), identical(ld$n, N_APP))

xc <- make_x_coord(dt$x1_raw, dt$x2_raw, mode = "rank")

## The bandwidths are formed on the FOLDS, not on n: crossfit_once() builds the
## operator from op_idx and solves on sol_idx, so bw_rot() sees n_op and bw_u()
## sees n_sol.  Using n would understate both and so overstate omega_n; the fold
## sizes are reconstructed from the same arithmetic crossfit_once() uses.
n_hold <- floor(N_APP / N_FOLDS)
n_rest <- N_APP - n_hold
N_OP   <- floor(n_rest / 2)
N_SOL  <- n_rest - N_OP

C_2 <- kernel_sup(8L)

## h_u = bw_u(u) at alpha = NULL: the application passes no alpha, so the legacy
## n^{-1/16} is what runs.  u is the realised residual of the headline solve.
H_U_APP <- 1.059 * stats::sd(ld$uhat) * N_SOL^(-1 / 16)
## h_x = bw_rot() on each period, at n_op.  The SMALLER of the two is carried,
## because omega_n is decreasing in h_x and the reported cap must not be
## understated.
H_X_APP <- min(1.059 * stats::sd(xc$x1) * N_OP^(-1 / 5),
               1.059 * stats::sd(xc$x2) * N_OP^(-1 / 5))

## ||1/pi||_inf.  C2 makes the estimator's working coordinate the pooled
## empirical CDF, which realises pi = Unif[0,1] -- the theory's own design
## decision D7 -- so the density is 1 and the sup of its reciprocal is 1.
INV_PI <- 1

app_rows <- vector("list", length(LADDER_DZ))                         # INV-17
for (i in seq_along(LADDER_DZ)) {
  dz <- LADDER_DZ[i]
  bier <- make_bierens(make_design(dt, dz), n_t = N_T, seed = BIER_SEED,
                       scale = T_SCALE)
  t_mat <- if (is.null(bier)) NULL else bier$Tm
  app_rows[[i]] <- data.frame(
    d_z        = dz,
    p_eff      = if (is.null(t_mat)) 0L else ncol(t_mat),
    c_pi_corpus = c_pi_of(t_mat, C_PHI_CORPUS),
    c_pi_code   = c_pi_of(t_mat, C_PHI_CODE),
    dhat_var    = N_APP^(-0.5) * sqrt(log(N_APP)),
    dhat_rho    = N_APP^(-frontier_alpha(R_FRONTIER, dz)),
    dhat        = rate_delta_hat(N_APP, R_FRONTIER, dz))
}
APP <- do.call(rbind, app_rows)
APP$dhat_m2 <- APP$dhat^(-2)

app_cap <- vector("list", length(C_C_GRID))                           # INV-17
for (j in seq_along(C_C_GRID)) {
  cc <- C_C_GRID[j]
  app_cap[[j]] <- data.frame(
    c_c   = cc,
    d_z   = APP$d_z,
    omega_corpus = omega_n_of(cc, C_2, APP$c_pi_corpus, INV_PI, H_U_APP, H_X_APP),
    omega_code   = omega_n_of(cc, C_2, APP$c_pi_code,   INV_PI, H_U_APP, H_X_APP),
    dhat_m2 = APP$dhat_m2)
}
app_cap <- do.call(rbind, app_cap)
app_cap$mbar_corpus <- app_cap$omega_corpus^2 * app_cap$dhat_m2
app_cap$mbar_code   <- app_cap$omega_code^2   * app_cap$dhat_m2

## The tight reading: omega_* = ||A-hat||, the norm lf_solve() actually divides
## by.  The headline solve stores cste = 1/||A-hat||^2.
A2_APP <- 1 / ld$phi$cste
APP$mbar_tight <- A2_APP * APP$dhat_m2

cat("\n===========================================================\n")
cat("PART A -- APPLICATION, n = 983\n")
cat("===========================================================\n\n")
cat(sprintf("folds: n_op = %d  n_sol = %d  (K = %d)\n", N_OP, N_SOL, N_FOLDS))
cat(sprintf("c_2 = %.6f   ||1/pi||_inf = %.1f\n", C_2, INV_PI))
cat(sprintf("h_u = %.6f (sd(u) = %.6f)   h_x = %.6f\n", H_U_APP,
            stats::sd(ld$uhat), H_X_APP))
cat(sprintf("realised ||A-hat||^2 = %.4f  (cste = %.6f, headline L = 2)\n\n",
            A2_APP, ld$phi$cste))
print(APP, row.names = FALSE, digits = 5)
cat("\n-- eq:cap, literal, by c_C and by which c_Phi is read --\n")
print(app_cap, row.names = FALSE, digits = 4)

# ============================================================================
# PART B  --  THE SIMULATION DESIGNS
# ============================================================================
#
# The Monte Carlo runs a FULL-SAMPLE solve (path_once() in
# sim_multinomial_phistep.R: K = 1, propensity fitted on a random half), so the
# bandwidths are formed at n, not at a fold size.  d_Z = 2: mdgp_draw() returns
# Z = (const, z1, z2) and make_bierens() drops the constant.

N_SIM_GRID <- c(400L, 800L, 1600L)
D_Z_SIM    <- 2L

sim_rows <- vector("list", length(N_SIM_GRID))                        # INV-17
for (i in seq_along(N_SIM_GRID)) {
  nn <- N_SIM_GRID[i]
  d <- mdgp_draw(nn, MDGP_SPEC$balanced)
  bier <- make_bierens(d$Z, n_t = 16L, seed = 20260805L, scale = 0.25)
  ## u at the truth: the residual the operator is formed from once phi and
  ## theta are right.  sd(u) is what h_u is proportional to.
  u_true <- d$du
  h_u <- 1.059 * stats::sd(u_true) * nn^(-1 / 16)
  h_x <- min(1.059 * stats::sd(d$x1) * nn^(-1 / 5),
             1.059 * stats::sd(d$x2) * nn^(-1 / 5))
  sim_rows[[i]] <- data.frame(
    n = nn, d_z = D_Z_SIM, h_u = h_u, h_x = h_x,
    c_pi_corpus = c_pi_of(bier$Tm, C_PHI_CORPUS),
    c_pi_code   = c_pi_of(bier$Tm, C_PHI_CODE),
    dhat = rate_delta_hat(nn, R_FRONTIER, D_Z_SIM))
}
SIM <- do.call(rbind, sim_rows)
SIM$dhat_m2 <- SIM$dhat^(-2)

sim_cap <- vector("list", length(C_C_GRID))                           # INV-17
for (j in seq_along(C_C_GRID)) {
  cc <- C_C_GRID[j]
  sim_cap[[j]] <- data.frame(
    c_c = cc, n = SIM$n,
    omega_corpus = omega_n_of(cc, C_2, SIM$c_pi_corpus, INV_PI, SIM$h_u, SIM$h_x),
    omega_code   = omega_n_of(cc, C_2, SIM$c_pi_code,   INV_PI, SIM$h_u, SIM$h_x),
    dhat_m2 = SIM$dhat_m2)
}
sim_cap <- do.call(rbind, sim_cap)
sim_cap$mbar_corpus <- sim_cap$omega_corpus^2 * sim_cap$dhat_m2
sim_cap$mbar_code   <- sim_cap$omega_code^2   * sim_cap$dhat_m2

## The tight reading at the simulation's realised operator norms, read off the
## cached paths of sim_multinomial_phistep.R (cste per path, per L).
CKPT <- here::here("quality_reports", "sim", "sim_multinomial_phistep_ckpt.rds")
tight_sim <- NULL
if (file.exists(CKPT)) {
  ck <- readRDS(CKPT)
  tr <- vector("list", 0L)
  for (nm in names(ck$res)) {
    cell <- ck$res[[nm]]
    if (is.null(cell)) next
    nn <- as.integer(sub(".*_n", "", nm))
    dd <- sub("_n.*", "", nm)
    for (lab in c("2", "3", "4")) {
      cst <- vapply(cell, function(z) {
        if (is.null(z) || is.null(z[[lab]])) NA_real_ else z[[lab]]$cste
      }, numeric(1))
      cst <- cst[is.finite(cst)]
      if (!length(cst)) next
      a2 <- 1 / cst
      tr[[length(tr) + 1L]] <- data.frame(
        dgp = dd, n = nn, L = as.integer(lab),
        a2_median = stats::median(a2),
        dhat_m2 = rate_delta_hat(nn, R_FRONTIER, D_Z_SIM)^(-2))
    }
  }
  tight_sim <- do.call(rbind, tr)
  tight_sim$mbar_tight <- tight_sim$a2_median * tight_sim$dhat_m2
}

cat("\n\n===========================================================\n")
cat("PART B -- SIMULATION DESIGNS, d_Z = 2\n")
cat("===========================================================\n\n")
print(SIM, row.names = FALSE, digits = 5)
cat("\n-- eq:cap, literal --\n")
print(sim_cap, row.names = FALSE, digits = 4)
if (!is.null(tight_sim)) {
  cat("\n-- eq:cap at the estimator's own omega_* = ||A-hat|| --\n")
  print(tight_sim[order(tight_sim$dgp, tight_sim$n, tight_sim$L), ],
        row.names = FALSE, digits = 4)
}

# ============================================================================
# PART C  --  COMPUTE, AT THE MEASURED REFERENCE
# ============================================================================
#
# Reference on record: stage 05 (app_tsp_05_phi_band.R) at L = 4, m-bar = 60,
# 5.1 core-hours / about 2.9 h wall.  Per-iteration cost is roughly linear in
# m-bar, so the unit cost is 5.1/60 core-hours per unit of m-bar.

CH_PER_MBAR <- 5.1 / 60
CORES <- 8L

cost <- data.frame(
  reading = c("current C4 (L = 4)",
              "eq:cap tight, d_Z = 5",
              "eq:cap literal, c_C = 3, c_Phi = 1, d_Z = 0 (most favourable)",
              "eq:cap literal, c_C = 3, c_Phi = 1, d_Z = 5",
              "eq:cap literal, c_C = 3, c_Phi = pi/2, d_Z = 5 (as stage 05 runs)",
              "eq:cap literal, c_C = 3, c_Phi = pi/2, d_Z = 22"),
  mbar = c(60,
           APP$mbar_tight[APP$d_z == 5L],
           app_cap$mbar_corpus[app_cap$c_c == 3 & app_cap$d_z == 0L],
           app_cap$mbar_corpus[app_cap$c_c == 3 & app_cap$d_z == 5L],
           app_cap$mbar_code[app_cap$c_c == 3 & app_cap$d_z == 5L],
           app_cap$mbar_code[app_cap$c_c == 3 & app_cap$d_z == 22L]))
cost$core_hours <- cost$mbar * CH_PER_MBAR
cost$wall_hours <- cost$core_hours / CORES
cost$wall_days  <- cost$wall_hours / 24
cost$wall_years <- cost$wall_days / 365.25

cat("\n\n===========================================================\n")
cat("PART C -- COMPUTE FOR STAGE 05 AT EACH READING\n")
cat("===========================================================\n\n")
cat(sprintf("unit cost: %.4f core-hours per unit of m-bar (5.1 ch at m-bar = 60)\n",
            CH_PER_MBAR))
cat(sprintf("assumed cores: %d\n\n", CORES))
print(cost, row.names = FALSE, digits = 4)

saveRDS(list(app = APP, app_cap = app_cap, sim = SIM, sim_cap = sim_cap,
             tight_sim = tight_sim, cost = cost,
             consts = list(c_2 = C_2, inv_pi = INV_PI, h_u_app = H_U_APP,
                           h_x_app = H_X_APP, n_op = N_OP, n_sol = N_SOL,
                           a2_app = A2_APP, c_c_grid = C_C_GRID,
                           c_phi = c(corpus = C_PHI_CORPUS, code = C_PHI_CODE))),
        file.path(OUT, "eqcap_instantiate.rds"))
cat("\nwrote ", file.path(OUT, "eqcap_instantiate.rds"), "\n", sep = "")
