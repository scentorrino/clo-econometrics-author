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
#
# ---------------------------------------------------------------------------
# D3e. THE INJECTION STAYS AN INJECTION AT EVERY CARDINALITY (added 2026-08-14)
#
# The cardinality arm's whole value is that it holds the NUISANCE REGIME fixed
# while sans-L moves. Nothing below estimates anything: at every cardinality the
# three nuisances are still truth-plus-error at a prescribed size in the norm
# thm:rootn prices, and the sizes are the SAME functions of n. What sans-L
# changes is only the SHAPE of the objects the sizes are measured on:
#
#   ell-hat - ell_star   is R^{p x (Lc-1)}-valued, and eq:foldrates' L2(P) size
#                        is the FROBENIUS norm of that matrix -- the instrument
#                        block's type declaration says norms carried by these
#                        objects are Frobenius. draw_dell() normalises exactly
#                        that, so the priced size does not change with sans-L.
#   varrho-hat - varrho  is R^{Lc-1}-valued and A4(iii) measures it in the
#                        EUCLIDEAN norm on R^{Lc-1}, integrated over z. Same.
#   h = phi-hat - phi    is scalar-valued at every sans-L and is untouched.
#
# So an L2 target of c_delta * delta_n means the same thing at every
# cardinality, and any movement in the results is movement in the ESTIMATOR, not
# in what was injected into it. That is the one factor the arm varies.
#
# WHAT DOES CHANGE, AND IT IS FORCED BY A4(i). At sans-L = 2 the perturbed
# propensity is a scalar truncated to [eps, 1-eps]. At sans-L >= 3 it is a point
# of the simplex and the truncation set is eq:trunset, whose metric projection
# def:hatT names in terms; see draw_rhat() for the construction and for why the
# binary line IS that projection rather than an exception to it.
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
  eta <- cbind(1, as.matrix(varrho_fun(d$zc, spec)))
  nb  <- es$Q * es$n_modes
  nrm <- numeric(nb)
  for (ri in seq_len(es$n_modes)) {
    for (q in seq_len(es$Q)) {
      nrm[(ri - 1) * es$Q + q] <- sqrt(mean((Pu[, q] * eta[, ri])^2))
    }
  }
  nrm
}

#' Coerce a representer-error coefficient block to its 3-index shape.
#'
#' The coefficient block is (basis) x p x (Lc-1) and is stored with the contrast
#' slot DROPPED at Lc = 2, so that the binary path is the shipped matrix. The
#' evaluators restore the slot rather than branching on it.
dell_as_array <- function(cf) {
  if (length(dim(cf)) == 3L) cf else array(cf, c(dim(cf), 1L))
}

#' Draw one representer error d_k with prescribed L2(P) norm.
#'
#' The size is the FROBENIUS L2(P) norm of the R^{p x (Lc-1)}-valued error, per
#' the instrument block's type declaration, so the coefficient array is
#' normalised across BOTH the theta index and the contrast index. At Lc = 2 the
#' array has one contrast slot, the normalisation is the shipped one, and the
#' rnorm() draw is the shipped call of the shipped length.
#'
#' @return (Q n_modes) x p matrix at Lc = 2, (Q n_modes) x p x (Lc-1) array
#'   at Lc >= 3.
draw_dell <- function(target_l2, spec, es, pert_norms) {
  nb  <- es$Q * es$n_modes
  nL1 <- es_L(es) - 1L
  cf  <- array(rnorm(nb * spec$p * nL1), c(nb, spec$p, nL1))
  # Normalise so that the resulting perturbation has ||d||_{L2(P)} = target.
  sc <- sqrt(sum((cf^2) * pert_norms^2))
  cf <- cf / sc * target_l2
  if (nL1 == 1L) cf[, , 1L] else cf
}

#' Shared body of eval_dell() / eval_dL(): contract a coefficient block against
#' a u-factor and the z-modes. Written once so a cardinality fix cannot land in
#' one evaluator and not the other.
#'
#' @param Uf n x Q matrix, the u-factor (basis, or its antiderivative).
#' @return n x p matrix at Lc = 2, n x p x (Lc-1) array at Lc >= 3.
eval_dell_block <- function(cf, Uf, zc, spec, es) {
  cfa <- dell_as_array(cf)
  eta <- cbind(1, as.matrix(varrho_fun(zc, spec)))
  nL1 <- dim(cfa)[3L]
  out <- array(0, c(nrow(Uf), spec$p, nL1))
  for (l in seq_len(nL1)) {
    for (ri in seq_len(es$n_modes)) {
      cols <- ((ri - 1) * es$Q + 1):(ri * es$Q)
      out[, , l] <- out[, , l] + (Uf %*% cfa[cols, , l]) * eta[, ri]
    }
  }
  if (nL1 == 1L) out[, , 1L] else out
}

#' Evaluate an injected representer error.
eval_dell <- function(cf, u, zc, spec, es) {
  eval_dell_block(cf, ell_basis_u(u, es$Q, es$c_u), zc, spec, es)
}

#' Evaluate the antiderivative of an injected representer error (zero anchor).
eval_dL <- function(cf, u, zc, spec, es) {
  uc <- pmin(pmax(u, es$u_range[1]), es$u_range[2])
  Au <- matrix(vapply(es$anti_fun, function(f) f(uc), numeric(length(uc))),
               nrow = length(uc))
  eval_dell_block(cf, Au, zc, spec, es)
}

#' Row-wise Euclidean projection onto the simplex {s >= 0, 1's = R}.
#'
#' The classical sort-and-threshold algorithm. Called at Lc >= 3, and only on
#' the rows whose truncation actually needs it -- but written to be correct at
#' ONE column too, because that is the case the identity harness runs it on to
#' show that the shipped binary clamp is this projection and not an exception to
#' it. t(apply(., 1, .)) would silently transpose at k = 1; matrix() with an
#' explicit shape does not.
proj_simplex_rows <- function(V, R) {
  k <- ncol(V)
  U  <- matrix(apply(V, 1, sort, decreasing = TRUE), nrow(V), k, byrow = TRUE)
  cs <- matrix(apply(U, 1, cumsum), nrow(V), k, byrow = TRUE)
  j  <- matrix(seq_len(k), nrow(V), k, byrow = TRUE)
  ok <- U - (cs - R) / j > 0
  rho <- max.col(ok * j, ties.method = "first")
  tau <- (cs[cbind(seq_len(nrow(V)), rho)] - R) / rho
  pmax(V - tau, 0)
}

#' Metric projection onto the truncation set eq:trunset.
#'
#' def:hatT fixes the construction: varrho-hat is taken in the eps_varrho-
#' interior of the simplex,
#'     {q in R^{Lc-1} : q_l >= eps for every l,  sum_l q_l <= 1 - eps},
#' and an estimator that is not is replaced by its METRIC PROJECTION onto that
#' set, which is well defined because the set is closed, convex and -- since
#' A4(i) requires eps < 1/Lc -- non-empty.
#'
#' AT Lc = 2 THE SET IS THE INTERVAL [eps, 1-eps] AND ITS METRIC PROJECTION IS
#' THE CLAMP. That is not an exception carved out to preserve the binary
#' numbers: it is the closed form of the projection in dimension one, and
#' def:hatT's own amendment note records that "[eps, 1-eps] becomes eq:trunset
#' ... at sans-L = 2 the two are the same set". The clamp is therefore evaluated
#' directly, which also keeps the binary arms bit-identical; the identity
#' harness checks the general branch against it to machine precision.
#'
#' At Lc >= 3 the projection is: floor at eps; if the resulting row already
#' satisfies the budget, that IS the projection (the halfspace is inactive);
#' otherwise the halfspace binds with equality and the problem is a projection
#' of q - eps onto the simplex of radius 1 - Lc eps, which A4(i) makes positive.
#'
#' @param q numeric matrix n x (Lc - 1).
#' @return numeric vector at Lc = 2 (R's drop convention, and what the binary
#'   arms consume), numeric matrix n x (Lc-1) at Lc >= 3.
project_trunset <- function(q, eps) {
  nL1 <- ncol(q)
  if (nL1 == 1L) return(as.vector(pmin(pmax(q, eps), 1 - eps)))
  a   <- pmax(q, eps)
  bad <- rowSums(a) > 1 - eps
  if (any(bad)) {
    a[bad, ] <- eps + proj_simplex_rows(q[bad, , drop = FALSE] - eps,
                                        1 - (nL1 + 1L) * eps)
  }
  a
}

#' Draw a propensity error direction and return varrho-hat, truncated as
#' def:crossfit(a) / def:hatT require, so that A4(i)'s overlap survives
#' estimation.
#'
#' One independent linear-in-z direction per non-base cell, then the WHOLE
#' (Lc-1)-vector field is scaled to the A4(iii) target -- which is the Euclidean
#' norm on R^{Lc-1} integrated over z, so the size means the same thing at every
#' cardinality (D3e) -- and the result is projected onto eq:trunset. The base
#' cell absorbs the rest by construction, varrho-hat_0 = 1 - sum_l varrho-hat_l,
#' so the perturbation is simplex-valued and every cell clears the A4(i) floor,
#' base cell included.
#'
#' At Lc = 2 the rnorm(4) draw, the scaling and the clamp are the shipped lines.
draw_rhat <- function(target_l2, zc, spec) {
  nL1 <- spec_L(spec) - 1L
  g   <- matrix(0, nrow(zc), nL1)
  for (l in seq_len(nL1)) {
    b <- rnorm(4)
    g[, l] <- b[1] + zc %*% b[2:4]
  }
  g  <- g / sqrt(mean(rowSums(g^2))) * target_l2
  rh <- as.matrix(varrho_fun(zc, spec)) + g
  project_trunset(rh, spec$eps_varrho)
}
