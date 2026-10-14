# ============================================================================
# sim_thm_rootn_nuisance.R
#
# The estimated nuisances of def:crossfit, realised at CONTROLLED rates.
# Sourced by sim_thm_rootn_limitlaw.R and sim_thm_rootn_jacobian.R.
# Sets no seed and writes no output.
#
# ---------------------------------------------------------------------------
# WHY THE NUISANCES ARE INJECTED RATHER THAN ESTIMATED (design decision D3)
#
# thm:rootn's hypotheses on the three estimated nuisances are RATE conditions on
# objects the theorem does not construct:
#     eq:foldrates  max_k ||h_k||_{L2(pi)} = O_P(delta_n)
#                   max_k ||h_k||_{H^s}    = O_P(1)
#                   max_k ||ell-hat^(-k) - ell_star||_{L2(P)} = O_P(eps_n)
#     A4(iii)       ||varrho-hat - varrho||_{L2} = O_P(r_n)
#     (R-a)         ell-hat bounded, C^1 in u, with O_P(1) sup-norm budgets
# and rem:rootnscope(3) records that ell-hat "is constructed nowhere" and that
# the preliminary phi-hat^(0) that def:lfstep needs "has no supplier in this
# file (open item Q-1)". A Monte Carlo that invented constructions for these
# would test the inventions. What is done instead is to realise the hypotheses
# exactly: truth plus a random error of the prescribed size in the prescribed
# norm, drawn independently of the sample.
#
# D3b. INDEPENDENCE RATHER THAN COMPLEMENT-FOLD MEASURABILITY. In the theory
# zeta-hat^(-k) is sigma(I_{-k})-measurable and the proofs use exactly one
# consequence of that: independence from I_k, which A0 supplies (def:crossfit).
# Drawing the nuisance error independently of the whole sample delivers that
# same independence, so lem:biasexp's conditional bias decomposition and
# lem:epterm's conditional Chebyshev step apply verbatim. What is lost is the
# correlation between the error and the complement fold, which no step uses.
#
# D3c. WHAT INJECTION CANNOT SEE: ANISOTROPY. A real Landweber-Fridman error is
# not isotropic: it concentrates in the directions the operator damps. Two
# direction modes are therefore provided -- "smooth" (coefficients decaying like
# j^{-2}, the benign case) and "rough" (mass on the highest available
# frequencies, the ill-posed directions) -- and results are reported for both.
# This is a partial substitute for the real error geometry, not a replacement.
#
# D3d. WHAT INJECTION CANNOT SEE: BIAS. *** ADDED IN ROUND 2, critic finding on
# the undeclared idealisation. *** With bias_frac = 0 the coefficient vector is
# rnorm() renormalised, so the injected h is MEAN-ZERO IN DIRECTION. eq:biasb1's
# first-order bias is BILINEAR in (h, ell-hat - ell_star) with both factors
# independent and symmetric, so it averages to approximately zero ACROSS
# REPLICATIONS. A real Landweber-Fridman error does not have this property: it
# carries a deterministic regularisation bias -- the truth's own component in the
# damped directions, systematically under-shot -- which does NOT average away.
#
# The linearisation residual is immune to this (it is a per-replication vector
# norm, so nothing cancels across replications), but COVERAGE and the SD RATIO
# are not, and those are the headline numbers. The idealisation is therefore no
# longer merely declared: bias_frac in [0, 1] interpolates from the mean-zero
# draw (0) to a FULLY DETERMINISTIC error direction (1), holding ||h||_{L2(pi)}
# at exactly the priced size c_delta * delta_n so that only the MEAN of the
# error moves, not its size. The deterministic direction is the mode's own
# weight vector with a NEGATIVE sign, i.e. a shrinkage of phi_dagger towards
# zero, which is the sign a regularisation bias actually has.
#
# D4. THE RATE CONSTANT IS SWEPT, NOT SET TO ONE. A5(ii) is an O_P statement and
# fixes the exponent only. The injected size is c_delta * delta_n with c_delta a
# reported argument.
# ============================================================================

H_MODES <- 6L   # number of Fourier modes in the injected structural error

#' Orthonormal, mean-zero basis on [0,1] under pi = Uniform (so it lies in V).
h_basis <- function(x, n_modes = H_MODES) {
  out <- matrix(0, length(x), n_modes)
  for (j in seq_len(n_modes)) {
    out[, j] <- if (j %% 2 == 1) sqrt(2) * sin(pi * (j + 1) * x)
                else             sqrt(2) * cos(pi * j * x)
  }
  out
}

#' Draw one structural error h with a prescribed L2(pi) norm.
#'
#' @param target_l2 the value of ||h||_{L2(pi)} to realise (c_delta * delta_n).
#' @param mode "smooth" or "rough" (design decision D3c).
#' @param bias_frac in [0, 1] (design decision D3d). 0 = mean-zero direction;
#'   1 = deterministic direction, the same in every replication. Intermediate
#'   values mix the two at unit total weight, so ||h||_{L2(pi)} = target_l2 for
#'   EVERY value of bias_frac and only E[h] changes.
#' @return list(coef, hs_norm) -- hs_norm is the H^s seminorm, checked O_P(1).
draw_h <- function(target_l2, mode = c("smooth", "rough"), s = CFG$s,
                   n_modes = H_MODES, bias_frac = 0) {
  mode <- match.arg(mode)
  j <- seq_len(n_modes)
  wt <- if (mode == "smooth") j^(-2) else j^(1.0)
  # Random (mean-zero) component, unit norm.
  cr <- rnorm(n_modes) * wt
  cr <- cr / sqrt(sum(cr^2))
  if (bias_frac > 0) {
    # Deterministic component, unit norm, NEGATIVE: a shrinkage of phi_dagger.
    cd <- -wt / sqrt(sum(wt^2))
    cf <- bias_frac * cd + sqrt(1 - bias_frac^2) * cr
    cf <- cf / sqrt(sum(cf^2))                 # unit norm up to rounding
  } else {
    cf <- cr
  }
  cf <- cf * target_l2
  freq <- pi * ifelse(j %% 2 == 1, j + 1, j)
  list(coef = cf, hs_norm = sqrt(sum((1 + freq^(2 * s)) * cf^2)))
}

#' The injection basis's frequency content, reported rather than asserted.
#'
#' Critic finding: the injected structural error spans only THREE DISTINCT
#' FREQUENCIES, and phi_dagger = sin(2 pi x) is the first of them. That matters
#' because the phi-step arm measures the compression's singular values decaying
#' steeply, so the operator's damped directions lie beyond anything this basis
#' can reach: D3c's "rough" mode does not merely fail to achieve the intended
#' geometry, it is STRUCTURALLY INCAPABLE of reaching it. This function exports
#' the fact so the claim is machine-checked.
h_basis_freqs <- function(n_modes = H_MODES) {
  j <- seq_len(n_modes)
  freq <- pi * ifelse(j %% 2 == 1, j + 1, j)
  list(n_modes = n_modes, freqs = freq, n_distinct = length(unique(freq)),
       distinct = sort(unique(freq)), freq_max = max(freq))
}

#' Evaluate an injected h at a vector of x.
eval_h <- function(hh, x) as.vector(h_basis(x) %*% hh$coef)

#' Population L2(P) norms of the ell-perturbation basis, computed once.
#'
#' The perturbation basis is the same bounded, C^1 family the representer uses
#' (tanh-Chebyshev in u times {1, varrho} in z), so (R-a)'s requirements --
#' bounded, continuously differentiable in u, O_P(1) sup-norm budgets -- hold by
#' construction for every draw.
ell_pert_norms <- function(spec, es, n_draw = 2e5L, seed = 31337L) {
  d <- with_fixed_seed(seed, dgp_draw(n_draw, spec))
  Pu  <- ell_basis_u(d$du, es$Q, es$c_u)
  eta <- cbind(1, varrho_fun(d$zc, spec))
  nb  <- es$Q * es$n_modes
  nrm <- numeric(nb)
  for (ri in seq_len(es$n_modes)) {
    for (q in seq_len(es$Q)) {
      nrm[(ri - 1) * es$Q + q] <- sqrt(mean((Pu[, q] * eta[, ri])^2))
    }
  }
  nrm
}

#' Draw one representer error d_k with prescribed L2(P) norm.
draw_dell <- function(target_l2, spec, es, pert_norms) {
  nb <- es$Q * es$n_modes
  cf <- matrix(rnorm(nb * spec$p), nb, spec$p)
  # Normalise so that the resulting perturbation has ||d||_{L2(P)} = target.
  sc <- sqrt(sum((cf^2) * pert_norms^2))
  cf <- cf / sc * target_l2
  cf
}

#' Evaluate an injected representer error: n x p.
eval_dell <- function(cf, u, zc, spec, es) {
  Pu  <- ell_basis_u(u, es$Q, es$c_u)
  eta <- cbind(1, varrho_fun(zc, spec))
  out <- matrix(0, length(u), spec$p)
  for (ri in seq_len(es$n_modes)) {
    cols <- ((ri - 1) * es$Q + 1):(ri * es$Q)
    out <- out + (Pu %*% cf[cols, , drop = FALSE]) * eta[, ri]
  }
  out
}

#' Evaluate the antiderivative of an injected representer error (zero anchor).
eval_dL <- function(cf, u, zc, spec, es) {
  uc  <- pmin(pmax(u, es$u_range[1]), es$u_range[2])
  Au  <- vapply(es$anti_fun, function(f) f(uc), numeric(length(uc)))
  eta <- cbind(1, varrho_fun(zc, spec))
  out <- matrix(0, length(u), spec$p)
  for (ri in seq_len(es$n_modes)) {
    cols <- ((ri - 1) * es$Q + 1):(ri * es$Q)
    out <- out + (Au %*% cf[cols, , drop = FALSE]) * eta[, ri]
  }
  out
}

#' Draw a propensity error direction and return varrho-hat, truncated as
#' def:crossfit(a) requires, so that A4(i)'s overlap survives estimation.
draw_rhat <- function(target_l2, zc, spec) {
  b  <- rnorm(4)
  g  <- b[1] + zc %*% b[2:4]
  g  <- g / sqrt(mean(g^2)) * target_l2
  rh <- varrho_fun(zc, spec) + as.vector(g)
  pmin(pmax(rh, spec$eps_varrho), 1 - spec$eps_varrho)
}
