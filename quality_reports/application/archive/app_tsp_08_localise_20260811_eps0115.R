## ---------------------------------------------------------------------------
## app_tsp_08_localise.R -- the four-category trigger instrument: the ESTIMATE
## and the LOCALISATION diagnostic of prp:localise.
##
## WHAT THIS IS.  With L = 4 cells the restriction A1 carries is not one moment
## but three, one per contrast Wtilde_l.  prp:localise says the L-1 cell-systems
## agree at a common phi under A1, so a PER-CELL decomposition of the moment
## localises a violation to the cells that carry it.  That decomposition is the
## deliverable the extra cells exist for.
##
## WHAT THIS IS NOT.  Consistency is NECESSARY, NOT SUFFICIENT, for A1.  A cell
## showing no conflict is NOT exonerated: some other phi in cal-V may reconcile
## the cells while A1 still fails there.  The procedure detects cal-V_CI = empty
## and nothing more (prp:localise(iii)'s own iff), and the false-negative rate of
## the attribution is unpriced.  That caveat is printed in assumptions_supp.tex
## and Section 6 must carry it, because Section 6 is attributing a NON-rejection.
##
## THE STATISTIC.  At the common fit (phi-hat, theta-hat) form, per cell l,
##     M_l(u, t) = E_n[ Wtilde_l 1{dU-hat <= u} w(t' Phi(dZ)) ]
## and report its L^2(Pi_u (x) Pi_t) norm.  Under A1 every M_l is zero up to
## sampling error.  The reference distribution redraws W from the FITTED
## multinomial varrho-hat(dZ), which imposes A1 by construction while preserving
## the propensity -- so the reference is the null the test is about, not a
## permutation that would also destroy the conditioning.
##
## ---------------------------------------------------------------------------
## REVISION 2026-08-11 (round 2).  FIVE DEFECTS, ONE OF THEM IN THE HEADLINE.
##
## (C1) THE REPORTED theta-hat RAN AT AN eps THE FILE SAID IT DID NOT.
##      `EPS <- EPS_LOCALISE` (0.0115) reached the propensity, the theory
##      diagnostics and the localisation cross-fit.  It did NOT reach the
##      estimate: fit_orthogonal() had no eps parameter and fit_one_partition()
##      hardcoded eps_rho = EPS_RHO = 0.03, so BOTH ARMS of the printed
##      theta-hat ran at 0.03 while the header printed "eps_rho = 0.0115"
##      directly above them.  The configuration was not merely unset -- it was
##      INEXPRESSIBLE.  eps_rho is now an argument of both functions, and
##      MEASURED, NOT ASSUMED: re-running the arms at 0.03 under the repaired
##      code reproduces the shipped theta_L4 and theta_L2 BIT-FOR-BIT
##      (max |new - shipped| = 0 exactly, all six coordinates, both arms, and
##      the clustered standard errors too).  That is what establishes which eps
##      the shipped number was; it is not inferred from reading the call graph.
##
##      NO eps IS CHOSEN HERE.  Both are run and both are reported, because the
##      tension is real and is the author's to resolve:
##        * 0.03 is EPS_RHO, so it is like-for-like against Section 6.2's ladder
##          and every other arm of the application;
##        * 0.0115 exists precisely because 0.03 BINDS on this design -- and the
##          binding rate is now printed next to each column rather than argued
##          for in a comment.
##
## (M5) THE LOCALISATION PROPENSITY IS FITTED IN SAMPLE, THE NULL IS NOT.
##      `Rho` is fitted on all n and the observed statistic is built against a
##      propensity fitted to the very W it centres, while draw_null_w() redraws
##      W WITHOUT refitting.  The observed statistic is therefore shrunk by
##      overfitting and the reference draws are not, which makes the test
##      CONSERVATIVE -- and Section 6.3's substantive reading is a NON-rejection
##      at cell 1.  That is the one bias direction that could manufacture that
##      reading.  BOTH are computed below and BOTH are reported; nothing is
##      changed.  Whether prp:localise's diagnostic should use a cross-fitted
##      propensity is a THEORIST call, not a coding one, and it is flagged as
##      such rather than settled by whoever edited this file last.
##
## (M3) THE STAGE EMITTED NO LATEX.  Every other stage writes
##      paper/tables/app_tsp_*.tex; this one wrote only .rds and .md, so its
##      numbers re-entered the manuscript BY HAND.  That is the transmission
##      path that produced the retracted "theta-hat[dTSP] = 0.6777".  Two bare
##      tabular fragments are written below (INV-13, INV-3).
##
## (--) THE GRID-SENSITIVITY TABLE MEASURED NOISE, NOT THE GRID.  Each grid drew
##      FRESH null instruments, so the reported spread (0.0080 on cell 1) was
##      smaller than one Monte Carlo standard error (~0.0059) and separated
##      nothing.  The B_REF null instruments are now drawn ONCE, from one
##      n x B_REF matrix of uniforms, and REUSED at every grid, so the spread
##      across grids is the grid's contribution and nothing else.
##
## (--) THE lambda_min(Omega-hat) ROW WAS OWED TO THE SUMMARY FILE.  Section 6.3
##      quotes 0.0113 against eps/L; it lived in the run log only.  It is in
##      localise_four_cell.md below.
##
## THE BIERENS SEED.  The registered constant BIER_SEED is used for the reported
## grid, and because the choice of grid is a free implementation constant under
## B1(iv), the p-values are recomputed across several grids and the spread is
## reported.  A conclusion that depended on the grid would not be a conclusion.
## ---------------------------------------------------------------------------

suppressMessages({
  library(here)
  library(parallel)
})
source(here::here("scripts", "R", "lf_panel.R"))
source(here::here("scripts", "R", "orthogonal_theta.R"))
source(here::here("scripts", "application", "app_tsp_common.R"))

RNGkind("L'Ecuyer-CMRG")
set.seed(SEED_LOCALISE)                                              # INV-14

D_Z    <- 5L                       # the headline control set of Section 6.2
B_REF  <- B_LOCALISE
CELL   <- c("attainment", "bad-day only", "annual-mean only", "both")
CELLS  <- 0:3
SEED_GRID <- c(BIER_SEED, 1L, 20260901L, 4242L)   # Bierens t-grid sensitivity

## The two truncation levels, run side by side.  EPS_DIAG is the one the
## LOCALISATION diagnostic uses; it is EPS_LOCALISE because that is the level
## chosen not to bind, and the diagnostic is the part of this file whose
## validity turns on the propensity being the conditional one.
EPS_GRID <- c(EPS_RHO, EPS_LOCALISE)
EPS_DIAG <- EPS_LOCALISE

## Output root.  Defaults to the repository tree; the override exists so a
## regeneration can be written to a scratch tree and DIFFED against the shipped
## artifacts before it replaces them, which is this project's standing rule for
## cached output.  Inputs are always read from the repository tree.
OUT_ROOT <- Sys.getenv("APP_TSP_OUT_ROOT", unset = here::here())
OUT <- file.path(OUT_ROOT, "quality_reports", "application")
SIM <- file.path(OUT_ROOT, "quality_reports", "sim")
TAB <- file.path(OUT_ROOT, "paper", "tables")
IN  <- here::here("quality_reports", "application")
for (d in c(OUT, SIM, TAB)) {
  dir.create(d, showWarnings = FALSE, recursive = TRUE)
}

# ---- data, and the instrument's construction -------------------------------

P  <- load_tsp_panel()
dt <- P$dt
n  <- nrow(dt)
v  <- utils::read.csv(here::here("data", "raw", "tsp_iv_variants.csv"))

key_dt <- paste(dt$StateCode, dt$CountyCode)
key_v  <- paste(v$StateCode, v$CountyCode)
idx    <- match(key_dt, key_v)
## PRECONDITIONS.  The merge is by a pasted key and was unchecked; an unmatched
## county used to become a silent NA in the instrument, which fit_propensity_multi
## would then have carried into the propensity.
stopifnot(!anyNA(idx), !anyDuplicated(idx[!is.na(idx)]), length(idx) == n)
stopifnot(all(c("mean_viol", "badday_A") %in% names(v)))

vv <- v[idx, , drop = FALSE]
w4 <- with(vv, ifelse(mean_viol == 0 & badday_A == 0, 0L,
              ifelse(mean_viol == 0 & badday_A == 1, 1L,
              ifelse(mean_viol == 1 & badday_A == 0, 2L, 3L))))
w2 <- dt$w                                     # the binary CATT of Section 6.2

## The refinement claim Section 6.3 rests on, checked rather than asserted: the
## binary instrument is the coarsening 1{W4 > 0} at every observation.
stopifnot(!anyNA(w4), all(w4 %in% CELLS), setequal(sort(unique(w4)), CELLS))
stopifnot(identical(as.numeric(w4 > 0L), as.numeric(w2)))
stopifnot(all(table(factor(w4, levels = CELLS)) > 0L))

Z  <- make_design(dt, d_z = D_Z)
xc <- make_x_coord(dt$x1_raw, dt$x2_raw, mode = "rank")
y  <- dt$dy
stopifnot(nrow(Z) == n, length(y) == n, length(xc$x1) == n,
          !anyNA(Z), !anyNA(y), ncol(Z) == D_Z + 1L)
stopifnot(identical(colnames(Z)[1], "const"))

xev <- seq(stats::quantile(c(xc$x1, xc$x2), XEVAL_LO),
           stats::quantile(c(xc$x1, xc$x2), XEVAL_HI), length.out = N_XEVAL)

message(sprintf("localise: n = %d, d_Z = %d, cells %s", n, D_Z,
                paste(as.vector(table(factor(w4, levels = CELLS))),
                      collapse = " / ")))

# ---- the estimate, at both cardinalities and both eps, on the same design ---
#
# fit_orthogonal() is the estimator of Section 6.2 -- median over N_PART
# cross-fitting partitions of the ONE-STEP, with both the i.i.d. and the
# state-clustered sandwich.  The seed is restored before each arm so all four
# run on IDENTICAL partition streams: the instrument and eps_rho are then the
# only things that differ, which is what makes the comparison about them.

## The anchor is captured ONCE from the script's single set.seed() and RESTORED
## before each arm, rather than re-seeding.  Same numbers -- restoring the state
## set.seed(SEED_LOCALISE) produced is what a second set.seed(SEED_LOCALISE)
## would do -- but it keeps INV-14's "exactly one set.seed(), at the top" intact,
## and it is the device fit_orthogonal() already uses internally for its own
## partition streams.
ANCHOR <- get(".Random.seed", envir = globalenv())

fit_arm <- function(w, eps, label) {
  assign(".Random.seed", ANCHOR, envir = globalenv())
  t0 <- Sys.time()
  f <- fit_orthogonal(y, xc$x1, xc$x2, Z, w, dt$cluster,
                      K = N_FOLDS, n_part = N_PART, cste = LF_CSTE,
                      init_fn = init_control, lf_imax = LF_IMAX,
                      lf_patience = LF_PATIENCE, rho = RHO,
                      xeval = xev, n_cores = N_CORES, eps_rho = eps)
  pd <- f$prop_diag
  message(sprintf("  %-22s %4.0fs   L = %d  eps = %.4f  truncation binds %6.3f%% (%d/%d)  min pre-proj %.2e",
                  label, as.numeric(difftime(Sys.time(), t0, units = "secs")),
                  length(unique(as.integer(w))), eps,
                  100 * pd$bind_rate, pd$n_bind, pd$n_eval_total, pd$min_pre))
  if (pd$n_fallback > 0 || pd$n_not_converged > 0) {
    message(sprintf("     *** %d fallback entries, %d non-converged fits ***",
                    pd$n_fallback, pd$n_not_converged))
  }
  f
}

## Four arms: (L, eps) for L in {4, 2} and eps in EPS_GRID.  Indexed [L, eps].
ARM_L <- c("L4", "L2")                                               # INV-17
fits <- vector("list", length(ARM_L) * length(EPS_GRID))
dim(fits) <- c(length(ARM_L), length(EPS_GRID))
dimnames(fits) <- list(ARM_L, sprintf("%.4f", EPS_GRID))
for (j in seq_along(EPS_GRID)) {
  fits[["L4", j]] <- fit_arm(w4, EPS_GRID[j], sprintf("four-category e=%.4f",
                                                      EPS_GRID[j]))
  fits[["L2", j]] <- fit_arm(w2, EPS_GRID[j], sprintf("binary       e=%.4f",
                                                      EPS_GRID[j]))
}
for (j in seq_along(EPS_GRID)) {
  stopifnot(identical(fits[["L4", j]]$coef_names, fits[["L2", j]]$coef_names))
}
## The reported pair: EPS_RHO, the application's own registered constant and the
## level Section 6.2's ladder runs at.  The second column is the alternative and
## is printed beside it, not instead of it.
J_MAIN <- which.min(abs(EPS_GRID - EPS_RHO))
fit4 <- fits[["L4", J_MAIN]]
fit2 <- fits[["L2", J_MAIN]]

# phi-hat on the common grid, per arm: the object Delta TSP actually enters
# through.  There is no scalar Delta TSP slope to compare, so the comparison
# that answers "does the refinement move the estimate" for the ENDOGENOUS
# variable is between the two phi-hat curves, not between two coefficients.
phi_of <- function(f) {
  M <- vapply(f$fits, function(b) {
    rowMeans(vapply(b$dev, function(pp) cumtrapz_centre(f$xeval, pp$dev),
                    numeric(length(f$xeval))))
  }, numeric(length(f$xeval)))
  p <- rowMeans(M)
  p - mean(p)
}
phi4 <- phi_of(fit4); phi2 <- phi_of(fit2)
phi_sup <- max(abs(phi4 - phi2))
phi_l2  <- sqrt(mean((phi4 - phi2)^2))

## THE GAP NEEDS A SCALE, AND THE RIGHT SCALE IS THE SAMPLING ONE.
##
## sd(phi-hat) ACROSS THE GRID measures how much the curve moves as X moves --
## the size of the signal -- and comparing a sampling difference to it answers no
## question anyone asked.  The scale the difference has to be read against is the
## SAMPLING variability of phi-hat, which stage 5 already estimated: the
## pointwise bootstrap sd of the reported band.  Stage 5's grid is in ug/m^3 and
## this script's is the rank coordinate, so the band is mapped through the same
## fwd() stage 5 used and interpolated onto xev before the ratio is taken.
##
## ONE MISMATCH, STATED RATHER THAN BURIED.  Stage 5's band prices the
## SECOND-STAGE phi-hat of prp:plugin -- one full-sample LF pass at a fixed
## theta-hat -- while the curves compared here are the CROSS-FITTED phi-hat,
## averaged over folds and partitions.  Those are two estimators of the same
## phi-dagger with different sampling variability, so the ratio below is an
## order-of-magnitude sampling scale and not a test.  It is reported because the
## alternative in use was sd across the grid, which is not a sampling scale at
## all; it should not be read as a p-value.
band_path <- file.path(IN, "app_tsp_phi_band.rds")
phi_band_sd <- NULL
if (file.exists(band_path)) {
  bnd <- readRDS(band_path)
  sd_grid <- bnd$bands[[bnd$reported_band]]$sd
  if (!is.null(sd_grid) && length(sd_grid) == length(bnd$x_grid)) {
    phi_band_sd <- stats::approx(xc$fwd(bnd$x_grid), sd_grid,
                                 xout = fit4$xeval, rule = 2)$y
  }
}
phi_scale <- if (is.null(phi_band_sd)) NA_real_ else stats::median(phi_band_sd)
phi_sup_in_sd <- if (is.null(phi_band_sd)) NA_real_ else
  max(abs(phi4 - phi2) / phi_band_sd)

# ---- theory diagnostics: A4(i), eq:omegafloor, c_Wtilde --------------------
#
# c_Wtilde = min{sqrt2, sqrt(L-1)} = sqrt2 at L = 4.  The engine must not print
# the binary constant on the multinomial instrument.
#
# The PRE-projection propensity is passed alongside the post-projection one, so
# theory_diagnostics() reports A4(i)'s binding rate rather than the identity
# min(post) >= eps that project_trunset() guarantees by construction.

Rho <- fit_propensity_multi(w4, Z, seq_len(n), seq_len(n), eps = EPS_DIAG,
                            cells = CELLS)
rho_pd <- attr(Rho, "prop_diag")
attr(Rho, "prop_diag") <- NULL
## The pre-projection fit, recovered by re-running the same call at eps -> 0.
## eq:trunset needs eps > 0 for project_trunset() to be well posed, so "off" is
## the smallest eps that leaves the projection inert rather than eps = 0.
Rho_raw <- fit_propensity_multi(w4, Z, seq_len(n), seq_len(n), eps = 1e-12,
                                cells = CELLS)
attr(Rho_raw, "prop_diag") <- NULL
stopifnot(nrow(Rho) == n, ncol(Rho) == length(CELLS) - 1L, all(is.finite(Rho)))
diag4 <- theory_diagnostics(w4, Rho, eps_rho = EPS_DIAG, n = n,
                            tau_dp = TAU_DP, rho_pre = Rho_raw)
message("\n-- theory diagnostics, four-category instrument --")
print_theory_diagnostics(diag4)
stopifnot(diag4$trunset_ok, diag4$floor_holds, !diag4$c_Wtilde_is_binary)

# ---- the localisation diagnostic -------------------------------------------

cf <- crossfit_once(y, xc$x1, xc$x2, Z, w4, K = N_FOLDS, cste = LF_CSTE,
                    lf_imax = LF_IMAX, lf_patience = LF_PATIENCE, n_t = N_T,
                    bier_seed = BIER_SEED, t_scale = T_SCALE,
                    adj_wtil = ADJ_WTIL, tau_dp = TAU_DP, conditional = TRUE,
                    eps_rho = EPS_DIAG, xeval = xev, verbose = FALSE)
th_plug <- stats::lm.fit(Z, y - cf$dphi)$coefficients
th_plug[!is.finite(th_plug)] <- 0
m0 <- cf$eval_moment(th_plug)
J0i <- tryCatch(solve(m0$J), error = function(e) MASS::ginv(m0$J))
th_common <- as.vector(th_plug - J0i %*% colMeans(m0$psi))
stopifnot(all(is.finite(th_common)), length(th_common) == ncol(Z))
uh <- as.vector(y - cf$dphi - Z %*% th_common)

hu <- bw_u(uh)
Ku <- K_order(outer(uh, uh, "-") / hu, 8L)

## The CROSS-FITTED propensity, for the M5 comparison.  Same object the
## estimator itself uses: fitted on the complement of each fold and evaluated on
## the fold, so it is not fitted to the W it centres.
Rho_cf <- as.matrix(cf$rho_hat)
stopifnot(nrow(Rho_cf) == n, ncol(Rho_cf) == length(CELLS) - 1L)

#' L^2(Pi_u (x) Pi_t) norm of the per-cell moment, one entry per contrast.
#'
#' @param wvec numeric vector length n. An instrument realisation.
#' @param bier list from make_bierens().
#' @param rho_mat numeric matrix n x (L-1). The propensity the contrast is
#'   centred at.
#' @return numeric vector of length L-1.
cell_norms <- function(wvec, bier, rho_mat) {
  Wind <- vapply(CELLS[-1], function(k) as.numeric(as.integer(wvec) == k),
                 numeric(n))
  wt <- Wind - rho_mat
  wt <- sweep(wt, 2L, colMeans(wt), "-")
  vapply(seq_len(length(CELLS) - 1L), function(l) {
    M <- (Ku %*% (wt[, l] * bier$Wt)) / n                    # n x n_t
    sqrt(sum(colMeans(M^2) * bier$pi_t))
  }, numeric(1))
}

## Reference: redraw W from varrho-hat, which imposes A1 by construction and
## keeps the propensity.  This is the null of interest, not a permutation.
##
## THE DRAWS ARE FIXED ONCE AND REUSED AT EVERY t-GRID.  Redrawing per grid --
## what this file did until 2026-08-11 -- put a fresh Monte Carlo error into
## every column of the sensitivity table, and that error (~0.0059 at B = 2000)
## was LARGER than the spread being reported (0.0080), so the table measured its
## own noise.  One n x B_REF matrix of uniforms serves every grid AND both
## propensities, which also pairs the in-sample and cross-fitted variants of M5.
make_cumP <- function(R) {
  allp <- cbind(1 - rowSums(R), R)
  stopifnot(all(allp > -1e-12), max(abs(rowSums(allp) - 1)) < 1e-10)
  allp <- pmax(allp, 0)
  cumP <- allp
  for (k in seq(2L, ncol(allp))) cumP[, k] <- cumP[, k - 1L] + allp[, k]
  cumP
}
cumP_in <- make_cumP(Rho)
cumP_cf <- make_cumP(Rho_cf)
## Inverse-CDF sampling of the null instrument.  pmin() guards the
## floating-point case u > sum_l p_l.
U_NULL <- matrix(stats::runif(n * B_REF), n, B_REF)                   # INV-17
draw_null_w <- function(b, cumP) {
  pmin(rowSums(U_NULL[, b] > cumP), length(CELLS) - 1L)
}

#' The three p-values at one Bierens t-grid, under one propensity.
run_grid <- function(seed_t, rho_mat, cumP) {
  bier <- make_bierens(Z, n_t = N_T, seed = seed_t, scale = T_SCALE)
  stopifnot(nrow(bier$Wt) == n, abs(sum(bier$pi_t) - 1) < 1e-12)
  obs <- cell_norms(w4, bier, rho_mat)
  ref <- matrix(NA_real_, B_REF, length(CELLS) - 1L)                # INV-17
  for (b in seq_len(B_REF)) {
    ref[b, ] <- cell_norms(draw_null_w(b, cumP), bier, rho_mat)
  }
  stopifnot(!anyNA(ref))
  list(obs = obs, ref = ref,
       med = apply(ref, 2L, stats::median),
       p = vapply(seq_len(length(CELLS) - 1L),
                  function(l) (1 + sum(ref[, l] >= obs[l])) / (B_REF + 1),
                  numeric(1)))
}

grids <- vector("list", length(SEED_GRID))                           # INV-17
names(grids) <- as.character(SEED_GRID)
for (g in seq_along(SEED_GRID)) {
  t0 <- Sys.time()
  grids[[g]] <- run_grid(SEED_GRID[g], Rho, cumP_in)
  message(sprintf("  Bierens grid seed %-9d %4.0fs   p = %s",
                  SEED_GRID[g],
                  as.numeric(difftime(Sys.time(), t0, units = "secs")),
                  paste(sprintf("%.4f", grids[[g]]$p), collapse = " ")))
}
main <- grids[[1L]]                    # BIER_SEED, the registered constant

## M5.  The same statistic at the CROSS-FITTED propensity, on the SAME null
## draws and the registered grid.  Reported beside the in-sample one; NOTHING is
## switched.  See the header: which propensity prp:localise's diagnostic should
## use is a theorist call.
t0 <- Sys.time()
main_cf <- run_grid(BIER_SEED, Rho_cf, cumP_cf)
message(sprintf("  cross-fitted propensity  %4.0fs   p = %s",
                as.numeric(difftime(Sys.time(), t0, units = "secs")),
                paste(sprintf("%.4f", main_cf$p), collapse = " ")))

# ---- report -----------------------------------------------------------------

lab <- vapply(fit4$coef_names,
              function(nm) if (nm %in% names(COEF_LABELS)) COEF_LABELS[[nm]]
                           else nm, character(1))

cat("\n======== FOUR-CATEGORY TRIGGER INSTRUMENT:",
    "ESTIMATE AND LOCALISATION ========\n")
cat(sprintf("n = %d, d_Z = %d, L = 4, %d null draws\n", n, D_Z, B_REF))
cat(sprintf("cells: %s\n\n",
            paste(sprintf("%s = %d", CELL,
                          as.vector(table(factor(w4, levels = CELLS)))),
                  collapse = ", ")))

cat("-- theta-hat, ORTHOGONAL ONE-STEP (eq:onestep), same design in all arms --\n")
cat("   Delta TSP is the ENDOGENOUS regressor and enters through phi only.\n")
cat("   There is NO Delta TSP coordinate in theta.\n")
cat("   NO eps IS CHOSEN HERE.  Both columns are the estimate; the truncation\n")
cat("   binding rate below each pair is what the choice trades off.\n\n")
cat(sprintf("   %-26s", "coefficient"))
for (j in seq_along(EPS_GRID)) {
  cat(sprintf(" | %10s %10s", sprintf("L=4 e%.4f", EPS_GRID[j]),
              sprintf("L=2 e%.4f", EPS_GRID[j])))
}
cat("\n")
for (i in seq_along(th_common)) {
  cat(sprintf("   %-26s", lab[i]))
  for (j in seq_along(EPS_GRID)) {
    cat(sprintf(" | %+10.5f %+10.5f", fits[["L4", j]]$theta[i],
                fits[["L2", j]]$theta[i]))
  }
  cat("\n")
  cat(sprintf("   %-26s", ""))
  for (j in seq_along(EPS_GRID)) {
    cat(sprintf(" | %10s %10s",
                sprintf("(%.5f)", fits[["L4", j]]$se_cl[i]),
                sprintf("(%.5f)", fits[["L2", j]]$se_cl[i])))
  }
  cat("\n")
}
cat("\n   -- what the eps buys, measured on the arms above --\n")
cat(sprintf("   %-26s", "truncation binds (%)"))
for (j in seq_along(EPS_GRID)) {
  cat(sprintf(" | %10.4f %10.4f", 100 * fits[["L4", j]]$prop_diag$bind_rate,
              100 * fits[["L2", j]]$prop_diag$bind_rate))
}
cat("\n")
cat(sprintf("   %-26s", "min pre-proj varrho-hat"))
for (j in seq_along(EPS_GRID)) {
  cat(sprintf(" | %10.2e %10.2e", fits[["L4", j]]$prop_diag$min_pre,
              fits[["L2", j]]$prop_diag$min_pre))
}
cat("\n")
cat(sprintf("   %-26s", "max projection move"))
for (j in seq_along(EPS_GRID)) {
  cat(sprintf(" | %10.2e %10.2e", fits[["L4", j]]$prop_diag$max_move,
              fits[["L2", j]]$prop_diag$max_move))
}
cat("\n")
cat(sprintf("   %-26s", "non-converged fits"))
for (j in seq_along(EPS_GRID)) {
  cat(sprintf(" | %10d %10d",
              as.integer(fits[["L4", j]]$prop_diag$n_not_converged),
              as.integer(fits[["L2", j]]$prop_diag$n_not_converged)))
}
cat("\n")
cat(sprintf("   %-26s", "share-fallback entries"))
for (j in seq_along(EPS_GRID)) {
  cat(sprintf(" | %10d %10d",
              as.integer(fits[["L4", j]]$prop_diag$n_fallback),
              as.integer(fits[["L2", j]]$prop_diag$n_fallback)))
}
cat("\n")

cat(sprintf("\n   At eps = %.4f (the column matching EPS_RHO):\n", EPS_GRID[J_MAIN]))
cat(sprintf("   phi-hat curves: sup |phi4 - phi2| = %.5f, L2 = %.5f\n",
            phi_sup, phi_l2))
if (is.finite(phi_sup_in_sd)) {
  cat(sprintf("   stage 5 pointwise bootstrap sd: median %.5f, range %.5f-%.5f\n",
              phi_scale, min(phi_band_sd), max(phi_band_sd)))
  cat(sprintf("   sup gap / median sd = %.2f;  max pointwise gap/sd = %.2f\n",
              phi_sup / phi_scale, phi_sup_in_sd))
  cat("   The scale is the SAMPLING sd of phi-hat, not its dispersion across the\n")
  cat("   grid.  CAVEAT: stage 5's band prices the SECOND-STAGE phi-hat and these\n")
  cat("   curves are the CROSS-FITTED one, so this is an order-of-magnitude scale\n")
  cat("   and not a test.\n")
} else {
  cat("   (stage 5's band not available; no sampling scale for the gap)\n")
}
cat(sprintf("   mean rel_bal: L=4 %.5f   L=2 %.5f   %s\n",
            mean(fit4$disc), mean(fit2$disc),
            if (mean(fit4$disc) < mean(fit2$disc))
              "<- four cells balance better" else
              "<- binary balances better"))
cat(sprintf("   mean se_cl:   L=4 %.5f   L=2 %.5f   %s\n",
            mean(fit4$se_cl), mean(fit2$se_cl),
            if (mean(fit4$se_cl) < mean(fit2$se_cl))
              "<- four cells more precise" else
              "<- binary more precise"))

cat("\n-- per-cell localisation, prp:localise --\n")
cat(sprintf("   common-fit one-step for the residual; eps_rho = %.4f;", EPS_DIAG))
cat(sprintf(" Bierens grid seed %d\n\n", BIER_SEED))
cat(sprintf("   %-4s %-18s %5s %12s %12s %8s %8s\n",
            "cell", "trigger", "n", "||M_l||", "null med", "p", "p (cf)"))
for (l in seq_len(length(CELLS) - 1L)) {
  cat(sprintf("   %-4d %-18s %5d %12.3e %12.3e %8.4f %8.4f\n", l, CELL[l + 1L],
              sum(w4 == l), main$obs[l], main$med[l], main$p[l], main_cf$p[l]))
}
cat(sprintf("\n   base cell (l=0, %s, n=%d) carries no contrast of its own:\n",
            CELL[1], sum(w4 == 0L)))
cat("   it is recovered as 1 - sum_l varrho_l and is what the three\n")
cat("   contrasts are measured against.\n")

cat("\n   M5, FLAGGED NOT FIXED.  The `p` column centres the contrast at a\n")
cat("   propensity fitted IN SAMPLE, on the same W it centres, while the null\n")
cat("   draws are NOT refitted -- so the observed statistic is shrunk by\n")
cat("   overfitting and the reference is not, and the test is CONSERVATIVE in\n")
cat("   exactly the direction that could manufacture a non-rejection.  `p (cf)`\n")
cat("   is the same statistic at the CROSS-FITTED propensity.  Which one\n")
cat("   prp:localise's diagnostic should use is a THEORIST call.  Nothing is\n")
cat("   switched here.\n")

cat("\n-- sensitivity to the Bierens t-grid (a free constant under B1(iv)) --\n")
cat("   Null draws are HELD FIXED across grids, so the spread is the grid's.\n")
for (g in seq_along(SEED_GRID)) {
  cat(sprintf("   seed %-9d p = %s\n", SEED_GRID[g],
              paste(sprintf("%.4f", grids[[g]]$p), collapse = "  ")))
}
grid_p_mat <- do.call(rbind, lapply(grids, function(g) g$p))
grid_spread <- apply(grid_p_mat, 2L, function(z) diff(range(z)))
## Monte Carlo standard error of a single p-value at the reported level, the
## scale the spread has to clear before it is a grid effect at all.
mc_se <- sqrt(main$p * (1 - main$p) / B_REF)
cat(sprintf("   spread across grids  %s\n",
            paste(sprintf("%.4f", grid_spread), collapse = "  ")))
cat(sprintf("   one MC se at B = %-5d %s\n", B_REF,
            paste(sprintf("%.4f", mc_se), collapse = "  ")))

cat("\n   READING.  A small p localises a conflict TO that cell.  A large p\n")
cat("   does NOT exonerate it: consistency is necessary, not sufficient,\n")
cat("   for A1 (prp:localise(iii)), and the false-negative rate of this\n")
cat("   attribution is unpriced.\n")
cat("   No multiplicity adjustment is applied; three cells are tested at once.\n")

# ---- LaTeX (INV-13: bare tabular, no float, no caption, no notes) -----------

cell_n <- vapply(seq_len(length(CELLS) - 1L), function(l) sum(w4 == l),
                 numeric(1))
write_tabular(
  colspec = "llrrrrr",
  header = paste("Cell & Trigger & $n$ & $\\|\\hat M_l\\|$ & Null median &",
                 "$p$ & $p_{\\mathrm{cf}}$ \\\\"),
  body = c(
    sprintf("%d & %s & %d & %s & %s & %s & %s \\\\",
            seq_len(length(CELLS) - 1L), tex_escape(CELL[-1]),
            as.integer(cell_n), fmt_sci(main$obs), fmt_sci(main$med),
            fmt_p(main$p), fmt_p(main_cf$p)),
    "\\midrule",
    "\\multicolumn{7}{l}{\\textit{Sensitivity to the Bierens $t$-grid, null draws held fixed}} \\\\",
    sprintf("\\multicolumn{3}{l}{seed %d} & \\multicolumn{4}{l}{$p = %s$} \\\\",
            SEED_GRID,
            vapply(grids, function(g)
              paste(fmt(g$p, 4), collapse = ",\\ "), character(1)))),
  path = file.path(TAB, "app_tsp_localise.tex"))
message("wrote ", file.path(TAB, "app_tsp_localise.tex"))

theta_body <- vapply(seq_along(th_common), function(i) {
  paste0(tex_escape(lab[i]), " & ",
         paste(vapply(seq_along(EPS_GRID), function(j)
           sprintf("%s & %s", fmt(fits[["L4", j]]$theta[i], 4),
                   fmt(fits[["L2", j]]$theta[i], 4)),
           character(1)), collapse = " & "), " \\\\")
}, character(1))
se_body <- vapply(seq_along(th_common), function(i) {
  paste0(" & ",
         paste(vapply(seq_along(EPS_GRID), function(j)
           sprintf("(%s) & (%s)", fmt(fits[["L4", j]]$se_cl[i], 4),
                   fmt(fits[["L2", j]]$se_cl[i], 4)),
           character(1)), collapse = " & "), " \\\\")
}, character(1))
coef_block <- as.vector(rbind(theta_body, se_body))
diag_rows <- c(
  paste0("Truncation binds (\\%) & ",
         paste(vapply(seq_along(EPS_GRID), function(j)
           sprintf("%s & %s",
                   fmt(100 * fits[["L4", j]]$prop_diag$bind_rate, 3),
                   fmt(100 * fits[["L2", j]]$prop_diag$bind_rate, 3)),
           character(1)), collapse = " & "), " \\\\"),
  paste0("$\\min_l\\hat\\varrho_l$ pre-projection & ",
         paste(vapply(seq_along(EPS_GRID), function(j)
           sprintf("%s & %s",
                   fmt_sci(fits[["L4", j]]$prop_diag$min_pre, 1L),
                   fmt_sci(fits[["L2", j]]$prop_diag$min_pre, 1L)),
           character(1)), collapse = " & "), " \\\\"),
  paste0("Mean rel.\\ balance & ",
         paste(vapply(seq_along(EPS_GRID), function(j)
           sprintf("%s & %s", fmt(mean(fits[["L4", j]]$disc), 4),
                   fmt(mean(fits[["L2", j]]$disc), 4)),
           character(1)), collapse = " & "), " \\\\"))
write_tabular(
  colspec = paste0("l", strrep("r", 2L * length(EPS_GRID))),
  header = c(
    paste0(" & ",
           paste(sprintf("\\multicolumn{2}{c}{$\\varepsilon_\\varrho = %s$}",
                         fmt(EPS_GRID, 4)), collapse = " & "), " \\\\"),
    paste(sprintf("\\cmidrule(lr){%d-%d}", 2L * seq_along(EPS_GRID),
                  2L * seq_along(EPS_GRID) + 1L), collapse = ""),
    paste0(" & ",
           paste(rep(c("$\\mathsf L = 4$", "$\\mathsf L = 2$"),
                     length(EPS_GRID)), collapse = " & "), " \\\\")),
  body = c(coef_block, "\\midrule", diag_rows),
  path = file.path(TAB, "app_tsp_localise_theta.tex"))
message("wrote ", file.path(TAB, "app_tsp_localise_theta.tex"))

# ---- artifacts --------------------------------------------------------------

saveRDS(list(
  n = n, d_z = D_Z, eps_grid = EPS_GRID, eps_main = EPS_GRID[J_MAIN],
  eps_diag = EPS_DIAG, b_ref = B_REF, seed = SEED_LOCALISE,
  cells = CELLS, cell_labels = CELL,
  cell_counts = as.vector(table(factor(w4, levels = CELLS))),
  coef_names = fit4$coef_names, coef_labels = unname(lab),
  theta_by_eps = lapply(seq_along(EPS_GRID), function(j)
    list(eps = EPS_GRID[j],
         theta_L4 = fits[["L4", j]]$theta, se_cl_L4 = fits[["L4", j]]$se_cl,
         se_iid_L4 = fits[["L4", j]]$se_iid,
         theta_L2 = fits[["L2", j]]$theta, se_cl_L2 = fits[["L2", j]]$se_cl,
         se_iid_L2 = fits[["L2", j]]$se_iid,
         disc_L4 = fits[["L4", j]]$disc, disc_L2 = fits[["L2", j]]$disc,
         prop_diag_L4 = fits[["L4", j]]$prop_diag,
         prop_diag_L2 = fits[["L2", j]]$prop_diag)),
  theta_L4 = fit4$theta, se_iid_L4 = fit4$se_iid, se_cl_L4 = fit4$se_cl,
  theta_L2 = fit2$theta, se_iid_L2 = fit2$se_iid, se_cl_L2 = fit2$se_cl,
  theta_common_onestep = th_common, theta_common_plugin = as.vector(th_plug),
  disc_L4 = fit4$disc, disc_L2 = fit2$disc,
  xeval = fit4$xeval, phi_L4 = phi4, phi_L2 = phi2,
  phi_sup = phi_sup, phi_l2 = phi_l2, phi_band_sd = phi_band_sd,
  phi_band_sd_median = phi_scale, phi_sup_in_sd = phi_sup_in_sd,
  diagnostics = diag4, rho_hat = Rho, rho_pre = Rho_raw, rho_cf = Rho_cf,
  rho_prop_diag = rho_pd,
  obs = main$obs, null_median = main$med, p = main$p, ref = main$ref,
  obs_cf = main_cf$obs, null_median_cf = main_cf$med, p_cf = main_cf$p,
  grid_seeds = SEED_GRID, grid_p = grid_p_mat, grid_spread = grid_spread,
  mc_se_p = mc_se,
  fit_L4 = fit4, fit_L2 = fit2, fits = fits),
  file.path(OUT, "app_tsp_localise.rds"))
message("wrote ", file.path(OUT, "app_tsp_localise.rds"))

writeLines(c(
  "# Localisation diagnostic - four-category trigger instrument",
  "",
  sprintf("n = %d, d_Z = %d, L = 4, %d null draws.", n, D_Z, B_REF),
  sprintf(paste("The estimate is reported at BOTH truncation levels,",
                "eps_rho = %s; the localisation diagnostic runs at %.4f."),
          paste(fmt(EPS_GRID, 4), collapse = " and "), EPS_DIAG),
  "",
  "## theta-hat, orthogonal one-step (eq:onestep)",
  "",
  paste("**Delta TSP is the endogenous regressor and enters through phi only.",
        "There is no Delta TSP coordinate in theta.**"),
  "",
  paste("**No eps is chosen here.** 0.03 is EPS_RHO and is like-for-like against",
        "Section 6.2's ladder; 0.0115 exists because 0.03 binds. The binding",
        "rate under each is in the table, so the trade-off is a number rather",
        "than an argument. Clustered standard errors in parentheses."),
  "",
  paste0("| coefficient | ",
         paste(vapply(EPS_GRID, function(e)
           sprintf("L = 4 (eps %.4f) | L = 2 (eps %.4f)", e, e),
           character(1)), collapse = " | "), " |"),
  paste0("|---|", strrep("---|", 2L * length(EPS_GRID))),
  vapply(seq_along(th_common), function(i) {
    paste0("| ", lab[i], " | ",
           paste(vapply(seq_along(EPS_GRID), function(j)
             sprintf("%+.5f (%.5f) | %+.5f (%.5f)",
                     fits[["L4", j]]$theta[i], fits[["L4", j]]$se_cl[i],
                     fits[["L2", j]]$theta[i], fits[["L2", j]]$se_cl[i]),
             character(1)), collapse = " | "), " |")
  }, character(1)),
  paste0("| **truncation binds (%)** | ",
         paste(vapply(seq_along(EPS_GRID), function(j)
           sprintf("%.4f | %.4f", 100 * fits[["L4", j]]$prop_diag$bind_rate,
                   100 * fits[["L2", j]]$prop_diag$bind_rate),
           character(1)), collapse = " | "), " |"),
  paste0("| **min pre-projection varrho-hat** | ",
         paste(vapply(seq_along(EPS_GRID), function(j)
           sprintf("%.2e | %.2e", fits[["L4", j]]$prop_diag$min_pre,
                   fits[["L2", j]]$prop_diag$min_pre),
           character(1)), collapse = " | "), " |"),
  "",
  sprintf(paste("At eps = %.4f: phi-hat curves have sup gap %.5f and L2 gap",
                "%.5f. Stage 5's pointwise bootstrap sd has median %.5f, so the",
                "sup gap is %.2f median sd (max pointwise ratio %.2f). Caveat:",
                "stage 5's band prices the second-stage phi-hat and these are",
                "the cross-fitted one, so this is an order-of-magnitude",
                "sampling scale, not a test."),
          EPS_GRID[J_MAIN], phi_sup, phi_l2, phi_scale,
          phi_sup / phi_scale, phi_sup_in_sd),
  sprintf("Mean rel_bal: L = 4 %.5f against L = 2 %.5f.",
          mean(fit4$disc), mean(fit2$disc)),
  sprintf("Mean clustered se: L = 4 %.5f against L = 2 %.5f.",
          mean(fit4$se_cl), mean(fit2$se_cl)),
  "",
  "## Theory diagnostics at the localisation propensity",
  "",
  "| quantity | value | reference | verdict |",
  "|---|---|---|---|",
  sprintf("| `lambda_min(Omega-hat)` | %.5f | `eps_rho / L` = %.5f | %s |",
          diag4$lam_min_Omega, diag4$omega_floor,
          if (diag4$floor_holds) "eq:omegafloor HOLDS" else "**VIOLATED**"),
  sprintf("| `min_l varrho-hat_l` (post-projection) | %.4f | `1/L` = %.2f | >= eps by construction |",
          diag4$min_rho, diag4$one_over_L),
  sprintf("| `min_l varrho-hat_l` (PRE-projection) | %.2e | `eps_rho` = %.4f | %s |",
          diag4$min_rho_pre, EPS_DIAG,
          if (diag4$n_bind == 0L) "truncation does not bind"
          else sprintf("**binds on %d of %d rows**", diag4$n_bind, n)),
  sprintf("| truncation binding rate, IN-SAMPLE fit | %.4f%% | -- | at eps = %.4f, all n used to fit and to evaluate |",
          100 * diag4$bind_rate, EPS_DIAG),
  sprintf("| truncation binding rate, CROSS-FITTED | %.4f%% | -- | at eps = %.4f, the propensity the ESTIMATOR uses |",
          100 * fits[["L4", which.min(abs(EPS_GRID - EPS_DIAG))]]$prop_diag$bind_rate,
          EPS_DIAG),
  sprintf("| `min_l varrho-hat_l`, CROSS-FITTED, pre-projection | %.2e | `eps_rho` = %.4f | %s |",
          fits[["L4", which.min(abs(EPS_GRID - EPS_DIAG))]]$prop_diag$min_pre,
          EPS_DIAG,
          paste("**two orders of magnitude below the in-sample minimum.**",
                "EPS_LOCALISE was calibrated on the in-sample fit; the",
                "estimator uses the cross-fitted one")),
  sprintf("| `c_Wtilde = min{sqrt2, sqrt(L-1)}` | %.6f | binary value 1 | %s |",
          diag4$c_Wtilde,
          if (diag4$c_Wtilde_is_binary) "**binary constant printed**"
          else "not the binary constant"),
  sprintf("| `delta-hat_n` (A5(i)) | %.6f | -- | binding branch %s |",
          diag4$delta_n, diag4$binding_branch),
  "",
  "## Per-cell localisation",
  "",
  "| cell | trigger | n | \\|\\|M_l\\|\\| | null median | p (in-sample varrho) | p (cross-fitted varrho) |",
  "|---|---|---|---|---|---|---|",
  sprintf("| %d | %s | %d | %.3e | %.3e | %.4f | %.4f |",
          seq_len(length(CELLS) - 1L), CELL[-1], as.integer(cell_n),
          main$obs, main$med, main$p, main_cf$p),
  "",
  paste("**M5, flagged not fixed.** The `p (in-sample)` column centres the",
        "contrast at a propensity fitted on all n -- on the same W it centres --",
        "while `draw_null_w()` redraws W without refitting. The observed",
        "statistic is shrunk by overfitting and the reference draws are not, so",
        "the test is CONSERVATIVE, which is the one bias direction that could",
        "manufacture a non-rejection. The cross-fitted column is the same",
        "statistic at the propensity the estimator itself uses. Whether",
        "prp:localise's diagnostic should use a cross-fitted propensity is a",
        "**theorist call**; nothing has been switched."),
  "",
  "Sensitivity to the Bierens t-grid, a free implementation constant under B1(iv).",
  "The null draws are HELD FIXED across grids, so the spread below is the grid's",
  "contribution and not a fresh Monte Carlo error per column:",
  "",
  "| grid seed | p (cell 1) | p (cell 2) | p (cell 3) |",
  "|---|---|---|---|",
  sprintf("| %d | %.4f | %.4f | %.4f |", SEED_GRID,
          vapply(grids, function(g) g$p[1], numeric(1)),
          vapply(grids, function(g) g$p[2], numeric(1)),
          vapply(grids, function(g) g$p[3], numeric(1))),
  sprintf("| **spread** | %.4f | %.4f | %.4f |", grid_spread[1],
          grid_spread[2], grid_spread[3]),
  sprintf("| **one MC se at B = %d** | %.4f | %.4f | %.4f |", B_REF,
          mc_se[1], mc_se[2], mc_se[3]),
  "",
  "The base cell (l=0, attainment) carries no contrast of its own; it is recovered",
  "as 1 - sum_l varrho_l and is what the three contrasts are measured against.",
  "",
  "**Consistency is NECESSARY, NOT SUFFICIENT, for A1.** A cell showing no conflict",
  "is not exonerated -- prp:localise(iii) detects cal-V_CI = empty and nothing more,",
  "so a violation reconciled by some other phi is invisible here, and the",
  "false-negative rate of the attribution is unpriced.  No multiplicity adjustment",
  "is applied; three cells are tested at once.",
  "",
  "Produced by scripts/application/app_tsp_08_localise.R."),
  file.path(SIM, "localise_four_cell.md"))
message("wrote ", file.path(SIM, "localise_four_cell.md"))
message("done: app_tsp_08_localise")
