# ============================================================================
# sim_thm_rootn_ablsplit.R   --   scope S2
#
# WHICH ONE NUISANCE BREAKS thm:rootn AT sans-L = 4?
#
# S1 (sim_thm_rootn_cardinality.R) established that the paper's own named design
# FAILS thm:rootn's limit law at sans-L = 4: the linearisation residual
# eq:rootn requires to be o_P(1) RISES in n, 0.856 -> 0.909 -> 1.230, 95%
# coverage falls 0.941 -> 0.925 -> 0.895, and the worst of five measures reaches
# 18.9 MC SE at n = 64,000 against 1.91 at sans-L = 2. S1 also localised the
# failure to a JOINT condition: it is absent when the nuisances are exact, absent
# when only the structural error h is injected, and present only when
# ell-hat != ell_star AND varrho-hat != varrho are BOTH switched on.
#
# Two assumptions are therefore still on the hook, and the theorist cannot act on
# a two-assumption finding. This arm splits that joint condition:
#
#   arm "ell"   c_delta = 0.25, c_eps = 1, c_r = 0   ->  A5(iv) alone
#   arm "rho"   c_delta = 0.25, c_eps = 0, c_r = 1   ->  A4(iii) alone
#
# at sans-L in {2, 4}. sans-L = 2 IS THE CONTROL AND IS NOT OPTIONAL: an arm that
# diverges at sans-L = 4 without its binary counterpart says "this nuisance error
# is expensive", not "this nuisance error is expensive AT sans-L = 4", and only
# the second is a finding about the cardinality.
#
# ---------------------------------------------------------------------------
# THE HYPOTHESIS THIS ARM TESTS -- AND IS ALLOWED TO REFUTE
#
# S1 closed with a hypothesis, offered as a hypothesis: A5(iv) prices
# ||ell-hat - ell_star|| in the FROBENIUS norm over (theta index, contrast
# index), while psi and J-hat consume the CONTRACTION sum_l ell_l Wtilde_l, and
# at sans-L >= 3 the conditional covariance Omega = diag(varrho) - varrho varrho'
# is not diagonal, so a Frobenius bound need not control the contraction
# uniformly in sans-L. If that is right, the "ell" arm carries the divergence and
# the "rho" arm does not.
#
# THE ARM IS BUILT SO THAT THE OTHER ANSWER IS EQUALLY REPORTABLE. Both arms run
# the same grid, the same B, the same five measures and the same channel
# decomposition below, and the verdict is read off the table rather than argued.
#
# ---------------------------------------------------------------------------
# THE CHANNEL DECOMPOSITION, WHICH IS WHAT MAKES THE TWO ARMS MECHANISTIC
#
# The estimating function's instrument block is L-hat Wtilde-hat, and since
# Wtilde-hat_l = 1{W = l} - varrho-hat_l = Wtilde_l - (varrho-hat_l - varrho_l),
#
#   L-hat Wtilde-hat - L_star Wtilde
#       = (L-hat - L_star) Wtilde          (T1)  mean zero given the fold
#       - L_star (varrho-hat - varrho)     (T2)  FIRST order in r_n
#       - (L-hat - L_star)(varrho-hat - varrho)  (T3)  the second-order product
#
# T2 is first order and survives only because Neyman orthogonality kills its
# expectation; it is multiplied by L_star itself, whose sup-norm S1 measured
# RISING 3.04 -> 7.56 with the cardinality. T3 is the product eq:foldrates
# prices. The arms separate the three exactly:
#
#   "ell" arm (c_r = 0):    varrho-hat = varrho, so T2 = T3 = 0; only T1 acts.
#   "rho" arm (c_eps = 0):  L-hat = L_star,      so T1 = T3 = 0; only T2 acts.
#
# so a divergence in the "rho" arm is a statement about T2 -- about orthogonality
# in the propensity direction at sans-L >= 3 -- and a divergence in the "ell" arm
# is a statement about T1. Each replication reports all three scaled to sqrt n,
# so the mechanism is measured and not inferred from the arm label.
#
# ALONGSIDE, the two norms of the S1 hypothesis, both in L2(P):
#   ||ell-hat - ell_star||_F           what A5(iv) PRICES
#   ||sum_l (ell-hat - ell_star)_l Wtilde_l||   what J-hat CONSUMES
# and the same pair for L-hat - L_star, which is what psi consumes. Their RATIO
# is the object of interest: under the injection design both are scaled to the
# same target, so a rate comparison is uninformative by construction and the
# CONSTANT is the whole content. Reported at both cardinalities.
#
# ---------------------------------------------------------------------------
# THE GRID, AND WHY n = 64,000 IS NOT ON IT
#
# S1's grid is n in {1000, 8000, 64000} at B = 5,000. MEASURED on this host,
# one replication at sans-L = 4, n = 64,000 costs 2.20 s, and B = 5,000 on
# SIM_CORES workers costs 45 min PER CELL -- 3 hours for the four (arm x
# cardinality) combinations this arm needs at that n alone. That is not
# affordable here, and the honest response is to say so rather than to thin B at
# the top of the grid and report a point whose verdict rests on its own noise
# floor -- which is the defect S1 was built to avoid.
#
# So the grid is n in {1000, 8000} at B = 5,000 AT EVERY CELL. Two points carry
# a trend here because the trend is well resolved between them: on S1's own full
# arm the linearisation residual moves 0.8556 (SE 0.0068) -> 0.9093 (SE 0.0080)
# across exactly this leg, a 5.1 MC SE separation, while at sans-L = 2 it moves
# 0.657 -> 0.474 in the other direction. The DIRECTION of the trend is what
# separates the arms, and it is legible at n = 8,000.
#
# WHAT THIS COSTS THE FINDING, SAID PLAINLY. S1's largest single jump is on the
# 8,000 -> 64,000 leg (residual +35%, coverage 0.925 -> 0.895). An arm that is
# flat here could still diverge above n = 8,000, so a NEGATIVE result on this
# grid is weaker than a positive one. The verdict below states which of the two
# it is for each arm.
#
# ---------------------------------------------------------------------------
# WHAT IS HELD FIXED
#
# Everything S1 held fixed, at the same values: DGP-A primitive for primitive,
# (mu, s, a, alpha) = (2, 3, 3/4, 0.32), c_delta = 0.25, smooth h with
# h_bias = 0, eps_varrho = 0.10, the 1e-10 ridge, injected nuisances at the
# theorem's own rates, B = 5,000 at every cell. ONE FACTOR VARIES WITHIN AN ARM
# (the cardinality) and one across arms (which nuisance is switched on).
#
# The cells are NOT paired on a shared draw. Nothing here is a paired difference:
# every statistic is compared to ITS OWN asymptotic target, which is the
# comparison thm:rootn makes and the one that needs no pairing.
#
# ---------------------------------------------------------------------------
# WHAT THIS ARM DOES NOT COVER
#
#   * It does not touch the phi-step, which is binary here as in S1.
#   * It does not run DGP-B, sans-L = 3, or any estimated-nuisance regime.
#   * It says nothing about whether the divergence would appear for a nuisance
#     ESTIMATOR that attains these rates; the errors are INJECTED, and their
#     direction is the injection basis's, not an estimator's.
#   * It does not modify scripts/R/lf_panel.R, orthogonal_theta.R or
#     sim_thm_rootn_{dgp,nuisance,cardinality}.R, so the sans-L = 2 binary
#     identity certificate is untouched by construction.
#
# Outputs
#   paper/tables/sim/sim_thm_rootn_ablsplit.tex          (bare tabular, INV-13)
#   paper/tables/sim/sim_thm_rootn_ablsplit_seunits.tex  (bare tabular)
#   paper/tables/sim/sim_thm_rootn_ablsplit_channel.tex  (bare tabular)
#   paper/figures/sim/sim_thm_rootn_ablsplit_resid.pdf   (no in-figure title, INV-12)
#   quality_reports/sim/sim_thm_rootn_ablsplit.rds
# ============================================================================

library(here)                                                    # INV-15
library(data.table)
library(ggplot2)
library(parallel)

source(here::here("scripts", "simulations", "sim_thm_rootn_dgp.R"))
source(here::here("scripts", "simulations", "sim_thm_rootn_nuisance.R"))

RNGkind("L'Ecuyer-CMRG")
set.seed(20260815L)                                              # INV-14

N_CORES   <- SIM_CORES             # fixed constant, see sim_thm_rootn_dgp.R
L_GRID    <- c(2L, 4L)
# SIM_B / SIM_NMAX shorten the arm for a smoke run, the hooks the sibling arms
# carry. THE DEFAULTS ARE THE SHIPPED DESIGN: an environment that sets neither
# reproduces the tables, and one that sets either writes a checkpoint whose
# design does not match the shipped one and is discarded on the next full run.
B_ALL     <- as.integer(Sys.getenv("SIM_B", unset = "5000"))
N_MAX     <- as.integer(Sys.getenv("SIM_NMAX", unset = "8000"))
N_GRID    <- c(1000L, 8000L)
N_GRID    <- N_GRID[N_GRID <= N_MAX]
C_DELTA   <- 0.25
ALPHA_LV  <- c(0.10, 0.05)
Q_PROBS   <- c(0.025, 0.05, 0.25, 0.50, 0.75, 0.95, 0.975)
THETA_MIX <- c(0.5, 0.5, 0.5, 0.5)                               # ||.|| = 1

# The two arms. `arm` is the key everywhere below; `lab` is what the tables
# print. c_delta is COMMON, so the structural error is not a third factor.
ARMS <- data.table(
  arm   = c("ell", "rho"),
  c_eps = c(1, 0),
  c_r   = c(0, 1),
  lab   = c("$\\hat\\ell$ only", "$\\hat\\varrho$ only"))

# ---- One replication -------------------------------------------------------

#' One replication of the cross-fitted one-step estimator, with the instrument
#' block's three terms measured separately.
#'
#' The estimator arithmetic is one_rep_card()'s in sim_thm_rootn_cardinality.R,
#' unchanged: same preliminary, same J-hat, same one-step, same variance
#' estimator, same oracle influence function. What is ADDED is the channel
#' decomposition (T1, T2, T3 of the header) and the two norms of the S1
#' hypothesis, all evaluated at theta_dagger and all read off objects the
#' replication has already materialised.
#'
#' @param n integer sample size.
#' @param spec,es,pop,pert_norms population objects for THIS cardinality.
#' @param c_delta,c_eps,c_r rate constants on ||h||, ||ell-hat - ell_star|| and
#'   ||varrho-hat - varrho||; the exponents are the theory's.
#' @return numeric vector of length 6p + 18.
one_rep_split <- function(n, spec, es, pop, pert_norms, c_delta, c_eps, c_r,
                          h_mode, h_bias = 0) {
  p   <- spec$p
  Lc  <- spec_L(spec)
  nL1 <- Lc - 1L
  d <- dgp_draw(n, spec)
  fold <- rep_len(1:2, n)

  tgt_h <- c_delta * rate_delta_n(n)
  tgt_e <- c_eps   * rate_eps_n(n)
  tgt_r <- c_r     * rate_rn(n)

  # 1{W = l} for the non-base cells, needed to rebuild Wtilde at varrho-hat.
  Wind <- if (Lc == 2L) d$w else
    vapply(seq_len(nL1), function(l) as.numeric(d$w == l), numeric(n))

  nz <- vector("list", 2)                                        # INV-17
  dphi_hat <- numeric(n)
  wt_hat   <- if (Lc == 2L) numeric(n) else matrix(0, n, nL1)
  h_hs <- numeric(2); d_l2 <- numeric(2); r_l2 <- numeric(2); D_l2 <- numeric(2)
  dcon <- numeric(2); Dcon <- numeric(2)
  # Sums over i of the three instrument-block terms, accumulated across folds.
  s_T1 <- numeric(p); s_T2 <- numeric(p); s_T3 <- numeric(p)

  for (k in 1:2) {
    idx <- which(fold == k)
    hh  <- draw_h(tgt_h, mode = h_mode, bias_frac = h_bias)
    dcf <- if (c_eps > 0) draw_dell(tgt_e, spec, es, pert_norms) else
           if (Lc == 2L) matrix(0, es$Q * es$n_modes, p) else
           array(0, c(es$Q * es$n_modes, p, nL1))
    zc_k <- d$zc[idx, , drop = FALSE]
    rr_k <- if (Lc == 2L) d$varrho[idx] else d$varrho[idx, , drop = FALSE]
    rh   <- if (c_r > 0) draw_rhat(tgt_r, zc_k, spec) else rr_k
    nz[[k]] <- list(idx = idx, hh = hh, dcf = dcf, rh = rh, zc = zc_k)
    h_hs[k] <- hh$hs_norm
    # A4(iii) measures the propensity error in the EUCLIDEAN norm on R^{Lc-1}.
    r_l2[k] <- sqrt(mean(row_sqnorm(as.matrix(rh) - as.matrix(rr_k))))
    dphi_hat[idx] <- phi_dagger(d$x2[idx], spec) - phi_dagger(d$x1[idx], spec) +
                     eval_h(hh, d$x2[idx]) - eval_h(hh, d$x1[idx])
    if (Lc == 2L) wt_hat[idx] <- Wind[idx] - rh
    else          wt_hat[idx, ] <- Wind[idx, , drop = FALSE] - rh
  }

  #' psi(theta, zeta-hat) and the ell-hat block, evaluated at an arbitrary theta.
  psi_at <- function(theta) {
    psi <- matrix(0, n, p)
    ell <- if (Lc == 2L) matrix(0, n, p) else array(0, c(n, p, nL1))
    for (k in 1:2) {
      z <- nz[[k]]; idx <- z$idx
      du <- d$dy[idx] - dphi_hat[idx] - as.vector(d$dz[idx, , drop = FALSE] %*% theta)
      e_k <- ell_star_eval(es, du, z$zc, spec) + eval_dell(z$dcf, du, z$zc, spec, es)
      L_k <- L_star_eval(es, du, z$zc, spec)   + eval_dL(z$dcf, du, z$zc, spec, es)
      wt_k <- if (Lc == 2L) wt_hat[idx] else wt_hat[idx, , drop = FALSE]
      psi[idx, ] <- d$dz[idx, , drop = FALSE] * du + contract_w(L_k, wt_k)
      if (Lc == 2L) ell[idx, ] <- e_k else ell[idx, , ] <- e_k
    }
    list(psi = psi, ell = ell)
  }

  # Preliminary (eq:prelimtheta) and its rate.
  Gzz <- crossprod(d$dz) / n
  th0 <- solve(Gzz, colMeans(d$dz * (d$dy - dphi_hat)))

  # J-hat at theta-hat^(0) (eq:Jhat) and the one-step (eq:onestep).
  A0   <- psi_at(th0)
  Jhat <- Gzz + crossprod(contract_w(A0$ell, wt_hat), d$dz) / n
  bpsi <- colMeans(A0$psi)
  Jinv_hat <- tryCatch(solve(Jhat), error = function(e) NULL)
  if (is.null(Jinv_hat)) return(rep(NA_real_, 6L * p + 18L))
  th1 <- th0 + as.vector(Jinv_hat %*% bpsi)                       # eq:onestep

  # Variance estimator (eq:Sighat) at theta-hat.
  A1  <- psi_at(th1)
  Sig <- crossprod(A1$psi) / n
  Vh  <- Jinv_hat %*% Sig %*% t(Jinv_hat)

  # Oracle influence function at the TRUE nuisances and the POPULATION J.
  L_t   <- L_star_eval(es, d$du, d$zc, spec)
  psi_t <- d$dz * d$du + contract_w(L_t, d$wt)
  if_n  <- as.vector(pop$Jinv %*% colMeans(psi_t)) * sqrt(n)

  # ---- Nuisance-error sizes AND the channel decomposition, at theta_dagger ---
  #
  # The sizes are FROBENIUS over (theta index, contrast index), per the
  # instrument block's type declaration, so they mean the same thing at every
  # cardinality -- and that is precisely the norm A5(iv) prices. The CONTRACTION
  # norms alongside them are what J-hat (through ell) and psi (through L)
  # actually consume, taken against the TRUE Wtilde so that the propensity error
  # does not leak into a diagnostic about the representer error.
  for (k in 1:2) {
    z <- nz[[k]]; idx <- z$idx
    du <- d$dy[idx] - dphi_hat[idx] - as.vector(d$dz[idx, , drop = FALSE] %*% spec$theta)
    wt_k  <- if (Lc == 2L) d$wt[idx] else d$wt[idx, , drop = FALSE]
    rr_k  <- if (Lc == 2L) d$varrho[idx] else d$varrho[idx, , drop = FALSE]
    drh   <- z$rh - rr_k                     # varrho-hat - varrho, same shape
    dL_k  <- if (c_eps > 0) eval_dL(z$dcf, du, z$zc, spec, es) else NULL
    if (c_eps > 0) {
      de_k    <- eval_dell(z$dcf, du, z$zc, spec, es)
      d_l2[k] <- sqrt(mean(row_sqnorm(de_k)))
      D_l2[k] <- sqrt(mean(row_sqnorm(dL_k)))
      dcon[k] <- sqrt(mean(rowSums(contract_w(de_k, wt_k)^2)))
      Dcon[k] <- sqrt(mean(rowSums(contract_w(dL_k, wt_k)^2)))
      # T1: (L-hat - L_star) Wtilde. Mean zero given the fold's nuisance.
      s_T1 <- s_T1 + colSums(contract_w(dL_k, wt_k))
    }
    if (c_r > 0) {
      # T2: L_star (varrho-hat - varrho). FIRST order in r_n; it is the term
      # Neyman orthogonality has to kill, and it carries L_star's own size.
      Lst_k <- L_star_eval(es, du, z$zc, spec)
      s_T2  <- s_T2 - colSums(contract_w(Lst_k, drh))
      # T3: the second-order product eq:foldrates prices.
      if (c_eps > 0) s_T3 <- s_T3 - colSums(contract_w(dL_k, drh))
    }
  }

  sqn_dev <- sqrt(n) * (th1 - spec$theta)
  c(sqn_dev,                                    # 1..p
    if_n,                                       # p+1..2p
    sqn_dev - if_n,                             # 2p+1..3p   linearisation resid
    sqrt(n) * (th0 - spec$theta),               # 3p+1..4p
    diag(Vh),                                   # 4p+1..5p
    diag(Jhat),                                 # 5p+1..6p
    sum(THETA_MIX * sqn_dev),                   # 6p+1  mixed direction, scaled
    as.numeric(t(THETA_MIX) %*% Vh %*% THETA_MIX),
    max(abs(Jhat - pop$J)),
    max(abs(Vh - pop$V)),
    tgt_h, max(h_hs), mean(d_l2), mean(r_l2), mean(D_l2),
    sqrt(n) * tgt_h^2,                          # the leading remainder
    sqrt(n) * tgt_h * mean(d_l2),
    sqrt(n) * mean(r_l2) * tgt_h,
    sqrt(n) * mean(r_l2) * mean(D_l2),
    mean(dcon), mean(Dcon),                     # 6p+14, 6p+15
    sqrt(sum((s_T1 / n)^2)) * sqrt(n),          # 6p+16  ||T1|| scaled
    sqrt(sum((s_T2 / n)^2)) * sqrt(n),          # 6p+17  ||T2|| scaled
    sqrt(sum((s_T3 / n)^2)) * sqrt(n))          # 6p+18  ||T3|| scaled
}

# ---- Cell driver -----------------------------------------------------------
#
# Every gap the summary interprets is pre-converted to MC SE units HERE, so that
# no reader has to divide and no measure can be quietly dropped in favour of the
# smallest one. Sign convention: positive means the empirical quantity EXCEEDS
# its asymptotic target. This is S1's run_cell() with the channel fields added.

run_cell <- function(n, spec, es, pop, pert_norms, c_delta, c_eps, c_r, h_mode,
                     B, h_bias = 0) {
  p <- spec$p
  res <- parallel::mclapply(seq_len(B), function(b) {
    one_rep_split(n, spec, es, pop, pert_norms, c_delta, c_eps, c_r, h_mode,
                  h_bias)
  }, mc.cores = N_CORES, mc.preschedule = TRUE)
  M <- do.call(rbind, res)
  M <- M[stats::complete.cases(M), , drop = FALSE]

  sd_mix <- sqrt(as.numeric(t(THETA_MIX) %*% pop$V %*% THETA_MIX))
  mixed  <- M[, 6 * p + 1]
  t_mix  <- mixed / sqrt(pmax(M[, 6 * p + 2], .Machine$double.eps))
  Bn <- nrow(M)

  cover <- vapply(ALPHA_LV, function(al)
    mean(abs(t_mix) <= stats::qnorm(1 - al / 2)), numeric(1))

  q_emp <- stats::quantile(t_mix, Q_PROBS, names = FALSE, type = 7)
  # MC standard error of a sample quantile: sqrt(q(1-q)/B) / f(x_q), the density
  # taken from the ASYMPTOTIC law, which is the comparison target (Bahadur).
  q_se <- sqrt(Q_PROBS * (1 - Q_PROBS) / Bn) / stats::dnorm(stats::qnorm(Q_PROBS))

  lin <- sqrt(rowSums(M[, (2 * p + 1):(3 * p), drop = FALSE]^2))
  mse <- function(j) stats::sd(M[, j]) / sqrt(Bn)

  list(
    n = n, L_cells = spec_L(spec), dgp = spec$name, c_delta = c_delta,
    c_eps = c_eps, c_r = c_r, h_mode = h_mode, h_bias = h_bias, B = Bn,
    sd_ratio = stats::sd(mixed) / sd_mix,
    sd_ratio_se = stats::sd(mixed) * sqrt(1 / (2 * (Bn - 1))) / sd_mix,
    sd_ratio_z = (stats::sd(mixed) / sd_mix - 1) /
                 (stats::sd(mixed) * sqrt(1 / (2 * (Bn - 1))) / sd_mix),
    cover90_z = (cover[1] - 0.90) / sqrt(cover[1] * (1 - cover[1]) / Bn),
    cover95_z = (cover[2] - 0.95) / sqrt(cover[2] * (1 - cover[2]) / Bn),
    mean_mixed_z = mean(mixed) / (stats::sd(mixed) / sqrt(Bn)),
    cover90 = cover[1], cover95 = cover[2],
    cover90_se = sqrt(cover[1] * (1 - cover[1]) / Bn),
    cover95_se = sqrt(cover[2] * (1 - cover[2]) / Bn),
    mean_mixed = mean(mixed), sd_mixed = stats::sd(mixed),
    sd_mixed_se = stats::sd(mixed) * sqrt(1 / (2 * (Bn - 1))),
    sd_mixed_pop = sd_mix,
    q_emp = q_emp, q_se = q_se, q_asy = stats::qnorm(Q_PROBS),
    q_worst_z = max(abs((q_emp - stats::qnorm(Q_PROBS)) / q_se)),
    lin_mean = mean(lin), lin_se = stats::sd(lin) / sqrt(Bn),
    lin_med = stats::median(lin), lin_q90 = stats::quantile(lin, 0.90, names = FALSE),
    J_gap = mean(M[, 6 * p + 3]), J_gap_se = mse(6 * p + 3),
    V_gap = mean(M[, 6 * p + 4]), V_gap_se = mse(6 * p + 4),
    hnorm = M[1, 6 * p + 5], hs_max = mean(M[, 6 * p + 6]),
    dnorm_mean = mean(M[, 6 * p + 7]), rnorm_mean = mean(M[, 6 * p + 8]),
    Dnorm_mean = mean(M[, 6 * p + 9]),
    rem_h2 = M[1, 6 * p + 10], rem_he = mean(M[, 6 * p + 11]),
    rem_rh = mean(M[, 6 * p + 12]), rem_rD = mean(M[, 6 * p + 13]),
    # ---- the channel decomposition -----------------------------------------
    dcon_mean = mean(M[, 6 * p + 14]), Dcon_mean = mean(M[, 6 * p + 15]),
    T1 = mean(M[, 6 * p + 16]), T1_se = mse(6 * p + 16),
    T2 = mean(M[, 6 * p + 17]), T2_se = mse(6 * p + 17),
    T3 = mean(M[, 6 * p + 18]), T3_se = mse(6 * p + 18),
    t_mix = t_mix)
}

# ---- Population objects, one set per cardinality ----------------------------

message("Building population objects ...")
SPECS <- lapply(L_GRID, function(L) dgp_spec("A", L_cells = L))
names(SPECS) <- as.character(L_GRID)
ES   <- lapply(SPECS, solve_ell_star)
POP  <- Map(function(s, e) pop_J_Sigma(s, e, n_pilot = 4e6L), SPECS, ES)
PERT <- Map(function(s, e) ell_pert_norms(s, e), SPECS, ES)
VAL  <- Map(function(s, e, p) dgp_validate(s, e, p), SPECS, ES, POP)

# The sans-L = 2 population objects MUST be the ones the limit-law arm builds.
# This is the in-place half of the binary-identity certificate: if the shared
# DGP file ever drifts, this stops the arm here rather than letting a moved
# baseline be read as an ablation effect.
stopifnot(identical(SPECS[["2"]], dgp_spec("A")),
          identical(ES[["2"]]$coef, solve_ell_star(dgp_spec("A"))$coef))

DESIGN <- CJ(arm = ARMS$arm, L_cells = L_GRID, n = N_GRID, sorted = FALSE)
DESIGN[, `:=`(c_eps   = ARMS$c_eps[match(arm, ARMS$arm)],
              c_r     = ARMS$c_r[match(arm, ARMS$arm)],
              dgp     = "A", c_delta = C_DELTA,
              h_mode  = "smooth", h_bias = 0)]
setorder(DESIGN, arm, L_cells, n)

message(sprintf("Running %d cells (B = %d) on %d cores ...",
                nrow(DESIGN), B_ALL, N_CORES))
OUT <- vector("list", nrow(DESIGN))                              # INV-17

SRC_FILES <- here::here("scripts", "simulations",
                        c("sim_thm_rootn_ablsplit.R", "sim_thm_rootn_dgp.R",
                          "sim_thm_rootn_nuisance.R"))
SRC_HASH <- unname(tools::md5sum(SRC_FILES))
CKPT <- here::here("quality_reports", "sim", "sim_thm_rootn_ablsplit_ckpt.rds")
if (file.exists(CKPT)) {
  old <- readRDS(CKPT)
  if (same_design(old$design, DESIGN) && identical(old$src_hash, SRC_HASH)) {
    OUT <- old$out
    message(sprintf("  resuming: %d of %d cells already done",
                    sum(!vapply(OUT, is.null, logical(1))), nrow(DESIGN)))
  } else {
    message("  checkpoint discarded: source or design changed since it was written")
  }
}
for (i in seq_len(nrow(DESIGN))) {
  # Advance the parent L'Ecuyer stream so each cell gets independent child
  # streams; the stream is advanced for skipped cells too, so a resumed run
  # reproduces a fresh one exactly.
  assign(".Random.seed",
         parallel::nextRNGStream(get(".Random.seed", envir = globalenv())),
         envir = globalenv())
  if (!is.null(OUT[[i]])) next
  r <- DESIGN[i]
  t0 <- Sys.time()
  parallel::mc.reset.stream()
  key <- as.character(r$L_cells)
  OUT[[i]] <- run_cell(r$n, SPECS[[key]], ES[[key]], POP[[key]], PERT[[key]],
                       r$c_delta, r$c_eps, r$c_r, r$h_mode, B_ALL, r$h_bias)
  OUT[[i]]$arm <- r$arm
  save_ckpt(list(design = DESIGN, out = OUT, src_hash = SRC_HASH), CKPT)
  message(sprintf("  [%d/%d] arm = %-3s  L = %d  n = %5d  (%.0fs)", i,
                  nrow(DESIGN), r$arm, r$L_cells, r$n,
                  as.numeric(difftime(Sys.time(), t0, units = "secs"))))
}

saveRDS(list(design = DESIGN, out = OUT, pop = POP, val = VAL, cfg = CFG,
             c_delta = C_DELTA, B = B_ALL, arms = ARMS),
        here::here("quality_reports", "sim", "sim_thm_rootn_ablsplit.rds"))

# ---- Tables ----------------------------------------------------------------

fmt <- function(x, d = 3) formatC(x, format = "f", digits = d)
big <- function(x) formatC(x, big.mark = ",", format = "d")

tab <- rbindlist(lapply(OUT, function(o) data.table(
  arm = o$arm, L = o$L_cells, n = o$n, B = o$B,
  cover90 = o$cover90, cover90_se = o$cover90_se,
  cover95 = o$cover95, cover95_se = o$cover95_se,
  sd_ratio = o$sd_ratio, sd_ratio_se = o$sd_ratio_se, sd_ratio_z = o$sd_ratio_z,
  cover90_z = o$cover90_z, cover95_z = o$cover95_z,
  mean_mixed_z = o$mean_mixed_z, q_worst_z = o$q_worst_z,
  lin = o$lin_mean, lin_se = o$lin_se,
  dfro = o$dnorm_mean, dcon = o$dcon_mean,
  Dfro = o$Dnorm_mean, Dcon = o$Dcon_mean, rn = o$rnorm_mean,
  T1 = o$T1, T1_se = o$T1_se, T2 = o$T2, T2_se = o$T2_se,
  T3 = o$T3, T3_se = o$T3_se)))
tab[, worst_z := pmax(abs(sd_ratio_z), abs(cover90_z), abs(cover95_z),
                      abs(q_worst_z), abs(mean_mixed_z))]
setorder(tab, arm, L, n)

# ---- T1: levels, one panel per arm -----------------------------------------
# INV-17: panel bodies built by vectorised sprintf and assembled ONCE.
panel_block <- function(a) {
  s <- tab[arm == a]
  lab <- ARMS[arm == a, lab]
  c(if (a != ARMS$arm[1L]) "\\addlinespace",
    sprintf("\\multicolumn{7}{l}{\\textit{Panel %s: %s ($c_\\epsilon=%d$, $c_r=%d$)}} \\\\",
            LETTERS[match(a, ARMS$arm)], lab,
            ARMS[arm == a, c_eps], ARMS[arm == a, c_r]),
    "\\midrule",
    sprintf("%d & %s & %s (%s) & %s (%s) & %s (%s) & %s (%s) & %s \\\\",
            s$L, big(s$n),
            fmt(s$sd_ratio, 3), fmt(s$sd_ratio_se, 3),
            fmt(s$cover90, 3), fmt(s$cover90_se, 3),
            fmt(s$cover95, 3), fmt(s$cover95_se, 3),
            fmt(s$lin, 3), fmt(s$lin_se, 3), fmt(s$worst_z, 2)))
}
writeLines(c(
  "\\begin{tabular}{rrccccc}", "\\toprule",
  " & & & \\multicolumn{2}{c}{Coverage (MC SE)} & Lin.\\ resid. & Worst of \\\\",
  "\\cmidrule(lr){4-5}",
  "$\\mathsf L$ & $n$ & $\\hat{\\mathrm{sd}}/\\mathrm{sd}_\\infty$ (MC SE) & 90\\% & 95\\% & mean (SE) & five (MC SE) \\\\",
  "\\midrule",
  unlist(lapply(ARMS$arm, panel_block), use.names = FALSE),
  "\\bottomrule", "\\end{tabular}"),
  here::here("paper", "tables", "sim", "sim_thm_rootn_ablsplit.tex"))

# ---- T2: EVERY measure in MC SE units, beside S1's Panel B -----------------
writeLines(c(
  "\\begin{tabular}{lrrrrrrr}", "\\toprule",
  " & & & \\multicolumn{5}{c}{Deviation from the asymptotic value, in MC SE units} \\\\",
  "\\cmidrule(lr){4-8}",
  "Arm & $\\mathsf L$ & $n$ & $\\hat{\\mathrm{sd}}/\\mathrm{sd}_\\infty$ & 90\\% cov. & 95\\% cov. & Worst quantile & Centring \\\\",
  "\\midrule",
  sprintf("%s & %d & %s & %s & %s & %s & %s & %s \\\\",
          ARMS$lab[match(tab$arm, ARMS$arm)], tab$L, big(tab$n),
          fmt(tab$sd_ratio_z, 2), fmt(tab$cover90_z, 2), fmt(tab$cover95_z, 2),
          fmt(tab$q_worst_z, 2), fmt(tab$mean_mixed_z, 2)),
  "\\bottomrule", "\\end{tabular}"),
  here::here("paper", "tables", "sim", "sim_thm_rootn_ablsplit_seunits.tex"))

# ---- T3: the channel decomposition and the two norms -----------------------
#
# Structural zeros are printed as "---" rather than 0.000: at c_r = 0 the terms
# T2 and T3 do not exist, and printing a zero for them would invite a reader to
# treat an absent term as a measured one.
dash <- function(x, ok, d = 3) ifelse(ok, fmt(x, d), "---")
dashse <- function(x, se, ok, d = 3)
  ifelse(ok, sprintf("%s (%s)", fmt(x, d), fmt(se, 4)), "---")
ratio <- function(a, b) ifelse(b > 0, fmt(a / b, 3), "---")
writeLines(c(
  "\\begin{tabular}{lrrrrrrrr}", "\\toprule",
  " & & & \\multicolumn{3}{c}{Instrument-block terms, $\\times\\sqrt n$} & \\multicolumn{2}{c}{Norm ratio, consumed/priced} & \\\\",
  "\\cmidrule(lr){4-6}\\cmidrule(lr){7-8}",
  "Arm & $\\mathsf L$ & $n$ & $\\|T_1\\|$ (MC SE) & $\\|T_2\\|$ (MC SE) & $\\|T_3\\|$ & $\\hat\\ell-\\ell_\\star$ & $\\hat L-L_\\star$ & Lin.\\ resid. \\\\",
  "\\midrule",
  sprintf("%s & %d & %s & %s & %s & %s & %s & %s & %s \\\\",
          ARMS$lab[match(tab$arm, ARMS$arm)], tab$L, big(tab$n),
          dashse(tab$T1, tab$T1_se, tab$dfro > 0),
          dashse(tab$T2, tab$T2_se, tab$rn > 0),
          dash(tab$T3, tab$dfro > 0 & tab$rn > 0),
          ratio(tab$dcon, tab$dfro), ratio(tab$Dcon, tab$Dfro),
          fmt(tab$lin, 3)),
  "\\bottomrule", "\\end{tabular}"),
  here::here("paper", "tables", "sim", "sim_thm_rootn_ablsplit_channel.tex"))

# ---- Figure (no in-figure title, serif, PDF; INV-12) -----------------------

thm_sim <- theme_minimal(base_family = "serif", base_size = 10) +
  theme(panel.grid.minor = element_blank(),
        strip.text = element_text(face = "bold"))

fig_dt <- copy(tab)
# The facet label spells the cardinality out rather than printing a symbol: the
# theory's instrument block reserves sans-serif L for the number of instrument
# cells and italic L for the debiasing weight of def:weight, and plotmath has no
# sans-serif L, so an "L == 4" strip would print the wrong symbol (INV-7).
fig_dt[, panel := sprintf("Instrument cells: %d", L)]
fig_dt[, arm_lab := ifelse(arm == "ell", "ell-hat only", "varrho-hat only")]
p_lin <- ggplot(fig_dt, aes(n, lin, colour = arm_lab, shape = arm_lab,
                            linetype = arm_lab)) +
  geom_line(linewidth = 0.5) +
  geom_point(size = 1.8) +
  geom_errorbar(aes(ymin = lin - 1.96 * lin_se, ymax = lin + 1.96 * lin_se),
                width = 0.06, linewidth = 0.35) +
  facet_wrap(~panel) +
  scale_x_log10(breaks = N_GRID, labels = big(N_GRID)) +
  scale_colour_brewer(palette = "Set2") +
  labs(x = "Sample size (log scale)",
       y = "Linearisation residual, mean (95% MC interval)",
       colour = "Nuisance switched on", shape = "Nuisance switched on",
       linetype = "Nuisance switched on") +
  thm_sim + theme(legend.position = "bottom")
ggsave(here::here("paper", "figures", "sim", "sim_thm_rootn_ablsplit_resid.pdf"),
       p_lin, width = 6.5, height = 3.2, device = cairo_pdf)

# ---- Console verdict -------------------------------------------------------
print(tab[, .(arm, L, n, lin, lin_se, cover95, worst_z, T1, T2, T3)])
for (a in ARMS$arm) {
  s <- tab[arm == a & L == 4L]
  message(sprintf("arm %-3s  L = 4: resid %s ; worst-of-five %s",
                  a, paste(fmt(s$lin, 3), collapse = " -> "),
                  paste(fmt(s$worst_z, 2), collapse = " -> ")))
}
message("done: ablation-split arm")
