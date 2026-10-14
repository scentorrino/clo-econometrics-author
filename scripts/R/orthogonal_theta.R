## ---------------------------------------------------------------------------
## orthogonal_theta.R -- cross-fitted orthogonal estimator of theta
##
## Implements Algorithm 1 of
##   quality_reports/plans/2026-07-28_panel-npiv-direct-theta.md
##
## Moment (prp:orthog):
##   psi_i(theta, phi, lambda) = DZ_i * DU_i + Wtil_i * lambda(DU_i),
##   DU_i = DY_i - {phi(X2_i) - phi(X1_i)} - DZ_i' theta,
##   Wtil_i = W_i - varrho(DZ_i),   varrho(dz) = P(W = 1 | DZ = dz).
##
## Wtil IS THE CONDITIONALLY CENTRED CONTRAST, not W - E[W].  A1 of this paper
## is DU _||_ W | DZ; the predecessor's DU _||_ W is what W - E[W] belongs to.
## This header said the latter until 2026-08-07.
##
## Neyman orthogonality in phi requires, for every direction h,
##   E[ (DZ + Wtil * ell(DU)) * {h(X2) - h(X1)} ] = 0,   ell = lambda',
## i.e. A* ell = -nu with nu = A* applied to DZ.  Note there is no f_U weight
## here: f_U enters the LF step for phi (through the derivative of the CDF),
## not the derivative of psi with respect to phi.
##
## In the derivative parameterisation the LF iteration uses, both A* and nu are
## computed by apply_adjoint() -- the same survival machinery, no extra
## smoothing and no regression on Delta Z anywhere.
##
## Requires lf_panel.R to be sourced first.
## ---------------------------------------------------------------------------

## ---- LEVEL-SPACE adjoint (the operator of prp:orthog) ---------------------
##
## The LF iteration for phi is parameterised by phi' (the MATLAB source
## estimates the derivative, because its initial conditions are derivative
## based).  The orthogonality condition of prp:orthog is NOT in that space: it
## is a statement about h in L^2_pi, i.e. about phi itself.
##
## Solving the adjoint equation in derivative space is valid but useless: the
## bias bound becomes  disc * ||phi-hat' - phi'||, and the derivative of an LF
## iterate is rough (||.|| of order 10^1-10^2 here), so the bound is vacuous.
## In level space the same bound reads  disc * ||phi-hat - phi||, which is of
## order 1.  Everything below therefore works in level space:
##
##   (A_L* g)(x) pi(x) = E[g | X2 = x] f_2(x) - E[g | X1 = x] f_1(x)
##   (A_L  q)_i        = Wtil_i * { q(X2_i) - q(X1_i) }
##
## Both are plain kernel averages -- no integration operator, no survival
## matrices, and still no conditioning on Delta Z anywhere.
##
## *** THIS BLOCK IS DEAD ON THE SHIPPED PATH, AND IT CARRIES NO BOUNDARY
## ADJUSTMENT.  BOTH FACTS ARE RECORDED HERE BECAUSE THEY ARE LOAD-BEARING
## TOGETHER, 2026-08-14. ***  adjoint_level(), build_adjoint_matrix(),
## operator_norm2_level() and nu_noise_level() reach a caller only through
## solve_debias_weight(), which nothing calls: crossfit_once() debiases through
## solve_balance_weight(), the RKHS kernel-balancing route, whose Gram is a
## Mercer kernel and not a smoothing kernel, so C3(ii) has nothing to say about
## it.  The two functions below, by contrast, write C_{h_x} out by hand as
## k_gauss(.)/bw rather than going through ker_dens() or survival_matrix(), so
## they did NOT inherit the boundary adjustment those two gained on 2026-08-14.
## Reviving this route means renormalising these kernels by their in-support
## mass first -- kernel_insupp_mass() in lf_panel.R is the divisor -- or
## prp:hatAprop(iii) fails for this A-hat* exactly as it did for the phi-step's.
## They are not adjusted now because a change to dead code cannot be verified by
## running it, and an unverified change is worse than a recorded debt.

## Adjoint in level space, returned at x1, at x2, and on the evaluation grid.
adjoint_level <- function(op, g) {
  n <- op$n
  num <- function(xout) {
    a2 <- rowMeans(k_gauss(outer(xout, op$x2, "-") / op$bw2) * rep(g, each = length(xout))) / op$bw2
    a1 <- rowMeans(k_gauss(outer(xout, op$x1, "-") / op$bw1) * rep(g, each = length(xout))) / op$bw1
    a2 - a1
  }
  list(d1 = num(op$x1) / op$pi_1,
       d2 = num(op$x2) / op$pi_2,
       dev = num(op$xeval) / op$pi_ev)
}

## Forward operator in level space: evaluate q at the two period values.
forward_level <- function(q1, q2, wtil) wtil * (q2 - q1)

## Squared operator norm of A_L, by power iteration, for the LF step size.
operator_norm2_level <- function(op, weight, n_iter = 30L) {
  v <- stats::rnorm(op$n); v <- v / sqrt(mean(v^2))
  nrm <- NA_real_
  for (k in seq_len(n_iter)) {
    a <- adjoint_level(op, weight * v)
    fw <- forward_level(a$d1, a$d2, weight)
    nrm <- sqrt(mean(fw^2))
    if (!is.finite(nrm) || nrm <= 0) return(NA_real_)
    v <- fw / nrm
  }
  nrm
}

## ---- inner products and the forward operator ------------------------------

## pi-weighted norm on the derivative space.  Evaluating at the pooled sample
## points {x1, x2} is a Monte Carlo average against pi = (f_1 + f_2)/2.
pi_norm2 <- function(v1, v2) mean(c(v1^2, v2^2))
pi_norm <- function(v1, v2) sqrt(pi_norm2(v1, v2))

## Forward operator A, adjoint to apply_adjoint():
##   <A* g, q>_pi = E[ g * {h_q(X2) - h_q(X1)} ]  with  h_q' = q,
## so (A q)_i = Wtil_i * {h_q(X2_i) - h_q(X1_i)}.
apply_forward <- function(op, q1, q2, wtil) {
  h1 <- integrate_centre(q1, op$M1, op$ord1)
  h2 <- integrate_centre(q2, op$M2, op$ord2)
  wtil * (h2 - h1)
}

## Sampling noise in nu-hat, for the discrepancy principle.
##   nu(v) = (1/pi(v)) * (1/n) sum_i dz_i * {1(X2_i >= v) - 1(X1_i >= v)}
## so sd(nu-hat(v)) = sd_i(contribution) / sqrt(n) / pi(v).
nu_noise_level <- function(op, dz) {
  n <- op$n
  c1 <- n * (sweep(op$S12, 2, dz, "*") - sweep(op$S11, 2, dz, "*"))
  c2 <- n * (sweep(op$S22, 2, dz, "*") - sweep(op$S21, 2, dz, "*"))
  v1 <- apply(c1, 1, stats::var) / n / (op$pi_1^2)
  v2 <- apply(c2, 1, stats::var) / n / (op$pi_2^2)
  sqrt(mean(c(v1, v2), na.rm = TRUE))
}

## ---- solve the adjoint equation A* ell = -nu -------------------------------

## Landweber-Fridman on the adjoint equation with early stopping by the
## discrepancy principle.  Returns ell on the sample residual grid and the
## achieved balancing residual
##   disc = || nu + A* ell ||_pi,
## which bounds the bias of theta-hat through
##   |bias| <= disc * || phi-hat' - phi' ||_pi.
## ---- WHY BALANCING IS NEEDED AT ALL ---------------------------------------
##
## The kernel representations above (apply_adjoint, adjoint_level) approximate
## the continuum adjoint.  They are not the *empirical* adjoint, so driving
## || nu + A* ell || to zero does not zero the finite-sample bias
##
##   (1/n) sum_i { DZ_ij + Wtil_i ell(u_i) } * { h(X2_i) - h(X1_i) },
##
## which is what actually has to vanish.  Verified numerically: with the
## kernel adjoint solved to rel_disc = 0, the bias was still uncancelled.
##
## So the orthogonality condition is imposed directly in sample.  A sieve
## version -- spline bases b_1..b_Lx for h and beta_1..beta_Lu for ell, giving
## the Lx-by-Lu system (D' diag(Wtil) B) beta = -D' DZ_j solved by truncated
## SVD -- was implemented first and is what the plan records as eq.
## (td-balancing).  It is superseded by the kernel/RKHS form below, which
## bounds the bias over a whole smoothness class instead of over a fixed
## finite-dimensional span, and needs one tuning parameter instead of two.

## ---- KERNEL (RKHS) BALANCING -- the estimator actually used ---------------
##
## The bias to be cancelled is the sample functional
##   Psi(h) = (1/n) sum_i g_i { h(X2_i) - h(X1_i) },   g = DZ_j + Wtil .* ell,
## which depends on h only through its 2n sample values.  It cannot vanish for
## every h (that would need g = 0), so h must be restricted to a class.  Taking
## that class to be an RKHS with kernel k, the reproducing property gives an
## EXACT representation -- no smoothing, no sieve approximation:
##
##   Psi(h) = < h, mu_g >_H,   mu_g = (1/n) sum_i g_i ( k_{X2_i} - k_{X1_i} ),
##   |Psi(h)| <= ||mu_g||_H * ||h||_H,
##   ||mu_g||_H^2 = g' Omega g,
##   Omega_ij = { k(X2i,X2j) - k(X2i,X1j) - k(X1i,X2j) + k(X1i,X1j) } / n^2.
##
## Minimising ||mu_g||^2 over ell with a ridge penalty is one linear solve:
##   ( D_W' Omega D_W + rho R ) ell = - D_W' Omega DZ_j,   D_W = diag(Wtil).
##
## This bounds the bias for EVERY h in the RKHS (a smoothness class), in the
## same currency as the source condition, with a single tuning parameter.

## Gaussian RKHS Gram matrix of the period-difference embedding.
balance_gram <- function(x1, x2, sigma = NULL) {
  n <- length(x1)
  if (is.null(sigma)) {
    ## median heuristic on the pooled X values
    xs <- c(x1, x2)
    sigma <- stats::median(stats::dist(sample(xs, min(400L, length(xs)))))
    if (!is.finite(sigma) || sigma <= 0) sigma <- stats::sd(xs)
  }
  kf <- function(a, b) exp(-outer(a, b, "-")^2 / (2 * sigma^2))
  (kf(x2, x2) - kf(x2, x1) - kf(x1, x2) + kf(x1, x1)) / n^2
}

## Solve for the debiasing weight by kernel balancing.
##
## ell must be a *function of the residual* -- both because the theory says so
## and because it has to be evaluated on the held-out fold.  So represent it in
## the RKHS over u (representer theorem):
##
##   ell(u) = sum_j alpha_j k_u(u, u_j),   ell = K_u alpha,
##
## and penalise the RKHS norm alpha' K_u alpha rather than ||ell||_2.  The
## first-order condition
##
##   ( D_W Omega D_W K_u + rho I ) alpha = - D_W Omega DZ_j
##
## then gives a smooth ell that extrapolates off-fold.  With a Gaussian k_u the
## primitive is analytic,
##   lambda(u) = sigma_u sqrt(2 pi) sum_j alpha_j Phi( (u - u_j)/sigma_u ),
## so no numerical integration is needed either.
solve_balance_weight <- function(u, w, x1, x2, DZ, rho = 1e-3, sigma = NULL,
                                 sigma_u = NULL, wcen = NULL, Omega = NULL,
                                 cells = NULL) {
  ## wcen is the centring of W: a VECTOR varrho-hat(Delta Z) under A1, or a
  ## scalar (default mean(w)) under the predecessor's unconditional model.
  ## Renamed from `wbar` 2026-08-05, when it stopped always being a mean.
  n <- length(u)
  ## ------------------------------------------------------------------------
  ## `cells` IS AN ARGUMENT, AND THE DEFAULT IS THE BUG IT REPLACES.
  ##
  ## Until 2026-08-11 the cell labels were read off THIS FOLD -- `sort(unique(
  ## as.integer(w)))` on the solve subsample -- while `wcen` arrives from the
  ## caller's propensity, which is fitted at the GLOBAL cardinality.  A solve
  ## fold that happens to contain no observation of some cell then produces a
  ## Wind with fewer columns than Wc: non-conformable if the missing cell is the
  ## last one, and SILENTLY MISALIGNED -- contrast l compared against propensity
  ## column l+1 -- if it is interior.  operator_residual() has carried a
  ## stopifnot for exactly this since the L-generalization; this function had
  ## none.  A0 makes L fixed and known, so the caller knows it and passes it.
  if (is.null(cells)) cells <- sort(unique(as.integer(w)))
  L <- length(cells)
  if (L < 2L) stop("solve_balance_weight: W is degenerate, one cell only.")
  L1 <- L - 1L
  ## ------------------------------------------------------------------------
  ## THE CONTRAST IS A MATRIX AT L CATEGORIES, AND SO IS ell.
  ##
  ## A2'(iii) types ell as p x (L-1)-valued: one row per theta-coordinate, ONE
  ## COLUMN PER CONTRAST.  The balancing system
  ##     ( D_W Omega D_W K_u + rho I ) alpha = - D_W Omega DZ_j
  ## has D_W = diag(Wtilde), which at L categories is one diagonal PER CELL.  So
  ## the solve runs over the p(L-1) pairs (j, l) rather than over p coordinates,
  ## and ell becomes n x p x (L-1).  THE THIRD EXTENT IS KEPT AT L = 2, where it
  ## is 1: one contract at every cardinality (see contract_cells()).
  Wind <- vapply(cells[-1], function(k) as.numeric(as.integer(w) == k),
                 numeric(n))
  Wc <- if (is.null(wcen)) matrix(rep(colMeans(Wind), each = n), n, L1)
        else if (is.null(dim(wcen))) matrix(wcen, n, 1L) else as.matrix(wcen)
  stopifnot(nrow(Wc) == n, ncol(Wc) == L1)
  wtil <- Wind - Wc
  DZ <- as.matrix(DZ)
  p <- ncol(DZ)

  if (is.null(Omega)) Omega <- balance_gram(x1, x2, sigma)
  if (is.null(sigma_u)) {
    sigma_u <- 1.06 * stats::sd(u) * n^(-1 / 5)
    if (!is.finite(sigma_u) || sigma_u <= 0) sigma_u <- 1
  }
  Ku <- exp(-outer(u, u, "-")^2 / (2 * sigma_u^2))

  ## Pi_w, uniform per B1(iv.d); the l-weights live here and nowhere else.
  piw <- rep(1 / L1, L1)
  alpha <- array(0, c(n, p, L1)); ell <- array(0, c(n, p, L1))
  for (l in seq_len(L1)) {
    wl <- wtil[, l]
    OW <- sweep(sweep(Omega, 1, wl, "*"), 2, wl, "*")     # D_{W,l} Omega D_{W,l}
    rhs <- -sweep(Omega %*% DZ, 1, wl, "*")               # -D_{W,l} Omega DZ
    scal <- mean(abs(diag(OW)))
    if (!is.finite(scal) || scal <= 0) scal <- 1
    A <- OW %*% Ku + diag(rho * scal, n)
    al <- tryCatch(solve(A, rhs), error = function(e) MASS::ginv(A) %*% rhs)
    alpha[, , l] <- as.matrix(al)
    ell[, , l] <- Ku %*% as.matrix(al)
  }

  ## The balance metric contracts over l with the Pi_w masses, matching
  ## eq:psidef's  psi = DZ dU + L(dU, dZ) Wtilde  -- the contrast on the RIGHT,
  ## which is the only order that multiplies at L >= 3.
  bal <- numeric(p); bal0 <- numeric(p)
  for (j in seq_len(p)) {
    g <- DZ[, j]
    for (l in seq_len(L1)) g <- g + piw[l] * wtil[, l] * ell[, j, l]
    bal[j] <- sqrt(max(drop(crossprod(g, Omega %*% g)), 0))
    bal0[j] <- sqrt(max(drop(crossprod(DZ[, j], Omega %*% DZ[, j])), 0))
  }

  list(alpha = alpha, ell = ell,
       bal = bal, bal0 = bal0,
       rel_bal = ifelse(bal0 > 0, bal / bal0, 0),
       u_ref = u, sigma_u = sigma_u, rho = rho, Omega = Omega,
       pi_w = piw, L1 = L1)
}

## Evaluate ell and its primitive lambda at new residual values, from the
## fitted kernel expansion.  Both are exact -- no interpolation.
##
## ONE CONTRACT AT EVERY CARDINALITY, 2026-08-11.  The result is ALWAYS
## m x p x (L-1), matching A2'(iii)'s typing of ell and lambda; at L = 2 the
## third extent is 1 rather than absent.  Before this date the return was
## m x p at L = 2 and m x p x (L-1) at L >= 3, and that split is what let
## eval_moment()'s two-dimensional containers look correct for a year: they
## matched one of the two contracts, so nothing errored until the other one
## arrived.  A 2-D alpha is still accepted and promoted, because that is the
## shape the legacy caller documented.
apply_alpha <- function(M, alpha) {
  if (is.null(dim(alpha)) || length(dim(alpha)) == 2L) {
    A <- as.matrix(alpha)
    alpha <- array(A, c(nrow(A), ncol(A), 1L))
  }
  d <- dim(alpha); out <- array(0, c(nrow(M), d[2], d[3]))
  for (l in seq_len(d[3])) {
    out[, , l] <- M %*% matrix(alpha[, , l], d[1], d[2])
  }
  out
}

eval_ell <- function(sw, unew) {
  Kn <- exp(-outer(unew, sw$u_ref, "-")^2 / (2 * sw$sigma_u^2))
  apply_alpha(Kn, sw$alpha)
}

eval_lambda <- function(sw, unew) {
  Pn <- stats::pnorm(outer(unew, sw$u_ref, "-") / sw$sigma_u)
  sw$sigma_u * sqrt(2 * pi) * apply_alpha(Pn, sw$alpha)
}

## The eq:psidef contraction:  sum_l varpi_w(l) Wtilde_l A_{.,.,l}, giving an
## n x p object from an n x p x (L-1) one.  Contrast on the RIGHT -- the only
## order that multiplies at L >= 3 (lem:nusigma(v)).  A no-op at L = 2.
##
## ONE CONTRACT, ADOPTED 2026-08-11, REPLACING THE 2026-08-10 GUARD.
##
## The guard this replaces read `if (is.matrix(wtil) && ncol(wtil) == 1L)
## wtil <- as.vector(wtil)` and was a correct local patch for a real outage:
## the L-generalization had retyped eval_moment()'s Wtilde to the uniform
## n x (L-1) matrix -- ONE COLUMN at L = 2 -- while this function's 2-D branch
## expected a VECTOR so that `wtil * A` recycles down the p columns of A.  An
## n x 1 matrix times an n x p matrix is not conformable, so every binary rung
## WITH CONTROLS died with "non-conformable arrays"; d_Z = 0 survived silently
## because p = 1 there makes the two shapes agree.
##
## IT WAS THE WRONG FIX, AND THE DIAGNOSIS IS THE ARGUMENT.  This function was
## polymorphic in its SECOND argument with no precondition, so `wtil` carried
## four incompatible contracts across the file at once (n x (L-1) in
## operator_residual and solve_balance_weight, n x 1 in eval_moment at L = 2,
## a plain vector in solve_debias_weight).  A coercion at the boundary makes
## the mismatch invisible again -- which is precisely how the original defect
## survived a year.  The contract is now SINGLE and CHECKED:
##
##     A     is n x p x (L-1)   ALWAYS   (apply_alpha, solve_balance_weight)
##     wtil  is n x (L-1)       ALWAYS   (eval_moment, operator_residual)
##     piw   has length (L-1)   ALWAYS   (B1(iv.d), a probability measure)
##
## and dispatch is on dim(A) alone.  A 2-D A is now an ERROR rather than a
## silent path that discards `piw` -- which the old 2-D branch did, and which
## was harmless only because piw == 1 whenever it fired.
##
## The eq:psidef contraction is sum_l varpi_w(l) Wtilde_l A_{.,.,l}, giving an
## n x p object from an n x p x (L-1) one.  CONTRAST ON THE RIGHT -- the only
## order that multiplies at L >= 3 (lem:nusigma(v)).
##
## VERIFIED NO-OP AT L = 2, rather than asserted: multiplication by piw = 1 and
## addition to a zero accumulator are exact in IEEE 754, so the arithmetic is
## the guard's.  The end-to-end evidence is the byte-identical ladder table.
contract_cells <- function(A, wtil, piw = NULL) {
  d <- dim(A)
  if (is.null(d) || length(d) != 3L) {
    stop("contract_cells: A must be n x p x (L-1); got ",
         if (is.null(d)) "a vector" else paste(d, collapse = " x "))
  }
  L1 <- d[3]
  if (is.null(piw)) piw <- rep(1 / L1, L1)
  wtil <- as.matrix(wtil)
  stopifnot(nrow(wtil) == d[1], ncol(wtil) == L1,
            length(piw) == L1, all(is.finite(piw)))
  out <- matrix(0, d[1], d[2])
  for (l in seq_len(L1)) {
    out <- out + piw[l] * (wtil[, l] * matrix(A[, , l], d[1], d[2]))
  }
  out
}

## Build A_L* explicitly as a (2n x n) matrix in the stacked (x1, x2) basis.
##
##   A_L*(Wtil e_i)(x) = Wtil_i { k_{h2}(x - X2_i)/h2 - k_{h1}(x - X1_i)/h1 }
##                        / (n pi(x))
##
## so the whole operator is two kernel matrices -- O(n^2), no loop.  The rows
## are scaled by 1/sqrt(2n) so that Euclidean inner products on the stacked
## vector reproduce the pi-weighted inner product mean(c(v1^2, v2^2)).
build_adjoint_matrix <- function(op, wtil) {
  n <- op$n
  xs <- c(op$x1, op$x2)
  pis <- c(op$pi_1, op$pi_2)
  K2 <- k_gauss(outer(xs, op$x2, "-") / op$bw2) / op$bw2
  K1 <- k_gauss(outer(xs, op$x1, "-") / op$bw1) / op$bw1
  A <- sweep(K2 - K1, 2, wtil, "*")
  A <- A / (n * pis)
  A / sqrt(2 * n)
}

## Solve A* (Wtil ell) = -nu by truncated SVD.
##
## Regularisation is the truncation level.  It is chosen by the relative
## spectral criterion: keep the leading directions until the residual stops
## improving materially, subject to `k_max`.  The achieved
##   disc = || nu + A* ell ||_pi
## bounds the bias of theta-hat through  |bias| <= disc * ||phi-hat - phi||.
solve_debias_weight <- function(op, u, w, dz, k_max = 40, tol = 1e-3,
                                wcen = NULL, svd_cache = NULL) {
  n <- op$n
  wtil <- w - (wcen %||% mean(w))
  A <- if (is.null(svd_cache)) build_adjoint_matrix(op, wtil) else NULL
  sv <- svd_cache %||% svd(A)

  nu <- adjoint_level(op, dz)
  b <- -c(nu$d1, nu$d2) / sqrt(2 * n)
  nu_norm <- sqrt(sum(b^2))

  co <- as.vector(crossprod(sv$u, b))
  kk <- min(k_max, length(sv$d))
  ## Drop directions whose singular value is numerically negligible.
  keep <- which(sv$d[seq_len(kk)] > sv$d[1] * 1e-8)
  if (!length(keep)) {
    return(list(ell = rep(0, n), disc = nu_norm, rel_disc = 1,
                nu_norm = nu_norm, k = 0L, svd = sv))
  }

  ## Residual after truncating at k: the part of b outside the leading k
  ## left-singular directions.
  resid_k <- sqrt(pmax(sum(b^2) - cumsum(co[keep]^2), 0))
  below <- which(resid_k <= tol * nu_norm)
  kbest <- if (length(below)) below[1] else length(keep)

  idx <- keep[seq_len(kbest)]
  ell <- as.vector(sv$v[, idx, drop = FALSE] %*% (co[idx] / sv$d[idx]))

  list(ell = ell, disc = resid_k[kbest], rel_disc = resid_k[kbest] / nu_norm,
       nu_norm = nu_norm, k = kbest, resid_path = resid_k, svd = sv)
}

`%||%` <- function(a, b) if (is.null(a)) b else a

## lambda from ell by integration on the sorted residual grid.  The constant of
## integration is irrelevant because Wtil is centred.
make_lambda_fun <- function(u, ell) {
  o <- order(u)
  us <- u[o]; es <- ell[o]
  lam <- c(0, cumsum(diff(us) * (es[-1] + es[-length(es)]) / 2))
  lam <- lam - mean(lam)
  function(unew) stats::approx(us, lam, xout = unew, rule = 2)$y
}

make_ell_fun <- function(u, ell) {
  o <- order(u)
  function(unew) stats::approx(u[o], ell[o], xout = unew, rule = 2)$y
}

## ---- one cross-fitting pass ----------------------------------------------

## Three-way split per fold: operator stage, solve stage, moment stage.
crossfit_once <- function(y, x1, x2, Z, w, K = 5, cste = NULL,
                          xeval = NULL, init_fn = init_control,
                          lf_imax = 150, lf_patience = 30,
                          rho = 1e-3, eps_rho = 0.03,
                          ## THEORY-FAITHFUL DEFAULTS, set 2026-08-05.
                          ## n_t > 1 turns on the Bierens family w(t'Phi(Delta Z))
                          ## of def:hatT, and adj_wtil = TRUE puts the Wtilde_j
                          ## factor in the adjoint where lem:adjoint(i) puts it:
                          ## A*l = nu_G/pi with G = Wtilde w(t'Phi) f(u) l.
                          ## Both are what THIS paper's theory specifies.  The
                          ## MATLAB source this engine was ported from omits
                          ## both, correctly, for the UNCONDITIONAL model it
                          ## implements -- see the header of lf_panel.R.
                          ##
                          ## t_scale is a genuine implementation constant, not a
                          ## derived quantity: B1(iv) asks only that Pi_t have a
                          ## nonzero absolutely continuous part, so the spread of
                          ## the t-grid is a choice and is registered as one.
                          ## sim_thm_rootn_bierens.R sweeps it.
                          ## t_scale = 0.25 CHOSEN ON EVIDENCE 2026-08-06 by
                          ## sim_bierens_validate.R: at n = 1600 it gives phi
                          ## ISE 0.346 against 0.409 at 0.50 and 2.08 at 1.00,
                          ## and it dominates 0.50 at gamma = 0 too (0.297 vs
                          ## 0.342).  n_t = 32 buys nothing over 16 (0.395 vs
                          ## 0.409).  These are implementation constants, not
                          ## derived quantities: B1(iv) fixes only that Pi_t
                          ## have a nonzero absolutely continuous part.
                          n_t = 16L, bier_seed = 20260805L, t_scale = 0.25,
                          adj_wtil = TRUE, tau_dp = 0.7,
                          ## conditional = FALSE reproduces the PORTED engine:
                          ## W centred at mean(W) everywhere -- operator, balance
                          ## weight and moment -- AND no Bierens family, AND no
                          ## Wtilde in the adjoint.  Before 2026-08-07 it gated
                          ## only the centring, so the "ported" arm still ran a
                          ## one-column Bierens family and, if adj_wtil was left
                          ## at its default, the conditional adjoint: the comment
                          ## claimed a control the code did not provide.
                          ## It must be honoured INSIDE this
                          ## function: eval_moment() is a closure over this
                          ## environment, so a caller patching the returned
                          ## rho_hat changes nothing (verified 2026-08-06, and it
                          ## silently voided the first validation run).
                          ## hx_scale ADDED 2026-08-16: the multiplicative
                          ## constant on the OPERATOR's x-bandwidth, passed
                          ## straight to make_operator().  1 is bit-for-bit the
                          ## previous engine.  It exists because the robustness
                          ## arms that RE-MEASURE X were, until this date,
                          ## holding h_x / sd(X) fixed and letting h_x / |X|
                          ## move by a factor of 4.7 -- see make_operator()'s
                          ## own note and scripts/application/
                          ## app_tsp_11_hxmatch.R.
                          hx_scale = 1,
                          conditional = TRUE, verbose = FALSE) {
  ## NOTE ON NAMES.  `rho` here is the RIDGE parameter of the balancing solve,
  ## not the propensity; the propensity is varrho and is written rho_hat /
  ## eps_rho.  The collision predates this change and is kept only because
  ## `rho` is in every caller's signature.
  n <- length(y); p <- ncol(Z)
  if (is.null(xeval)) {
    xeval <- seq(stats::quantile(c(x1, x2), 0.05),
                 stats::quantile(c(x1, x2), 0.95), length.out = 60)
  }
  folds <- sample(rep_len(seq_len(K), n))
  wbar <- mean(w)
  ## The instrument's cells, read off the data rather than assumed.  A0 makes L
  ## finite, fixed and known; cell 0 is the base and is never stored, per
  ## eq:contrast.  Lcells == 2 keeps every line below on the ported scalar path.
  cells <- sort(unique(as.integer(w)))
  Lcells <- length(cells)
  cell_shares <- vapply(cells[-1], function(k) mean(as.integer(w) == k),
                        numeric(1))

  rho_hat <- if (Lcells == 2L) numeric(n) else matrix(0, n, Lcells - 1L)
  dphi <- numeric(n)
  disc <- numeric(p)
  bal_by_fold <- vector("list", K)
  phi_paths <- vector("list", K)
  lf_info <- vector("list", K)
  ## Propensity-fit diagnostics, two per fold: the operator-stage fit (op_idx ->
  ## sol_idx) and the moment-stage fit (rest -> hold).  Pre-allocated (INV-17)
  ## and returned as `prop_diag`; the attribute is STRIPPED on receipt so it
  ## cannot ride along into any downstream operand.
  prop_diag <- vector("list", 2L * K)

  for (k in seq_len(K)) {
    hold <- which(folds == k)
    rest <- which(folds != k)
    op_idx <- sample(rest, floor(length(rest) / 2))
    sol_idx <- setdiff(rest, op_idx)

    ## --- operator stage: bandwidths from op_idx, operator on sol_idx --------
    op <- make_operator(x1[sol_idx], x2[sol_idx], xeval,
                        hx = c(bw_rot(x1[op_idx]), bw_rot(x2[op_idx])),
                        hx_scale = hx_scale)

    ## --- solve stage -------------------------------------------------------
    ys <- y[sol_idx]; Zs <- Z[sol_idx, , drop = FALSE]; ws <- w[sol_idx]
    ## varrho-hat for the operator stage: fitted on op_idx, evaluated on
    ## sol_idx.  That is def:hatT's I_a / I_m split -- the propensity must not
    ## be fitted on the same observations the operator is built from.
    ## L-CATEGORY ROUTE.  At L = 2 fit_propensity_multi() returns one column and
    ## is bit-for-bit fit_propensity(); at L >= 3 it is the multinomial fit,
    ## projected onto eq:trunset's eps-interior SIMPLEX rather than the box --
    ## which is what keeps the implied base cell non-negative and Omega-hat PSD.
    rho_s <- if (conditional) {
      P <- fit_propensity_multi(w, Z, op_idx, sol_idx, eps = eps_rho,
                                cells = cells)
      prop_diag[[2L * k - 1L]] <- c(list(stage = "operator", fold = k),
                                    attr(P, "prop_diag"))
      attr(P, "prop_diag") <- NULL
      if (Lcells == 2L) as.vector(P) else P
    } else if (Lcells == 2L) {
      rep(wbar, length(sol_idx))
    } else {
      matrix(rep(cell_shares, each = length(sol_idx)),
             length(sol_idx), Lcells - 1L)
    }
    ## Bierens family on the solve fold.  Built from the same fixed t-grid at
    ## every fold and partition, so it is part of the specification rather than
    ## a source of run-to-run variation.
    bier_s <- if (conditional)
      make_bierens(Zs, n_t = n_t, seed = bier_seed, scale = t_scale) else NULL
    init <- init_fn(ys, x1[sol_idx], x2[sol_idx], Zs, ws, op)
    fit <- lf_solve(ys, x1[sol_idx], x2[sol_idx], Zs, ws, op, init,
                    rho = rho_s, bier = bier_s,
                    adj_wtil = conditional && adj_wtil,
                    cste = cste, imax = lf_imax, patience = lf_patience,
                    tau_dp = tau_dp)
    phi_paths[[k]] <- list(dev = fit$dev, theta = fit$theta)
    ## `stop_rule` and `n_sol` ADDED 2026-08-12.  lf_solve() has returned the
    ## rule that ended each run since 2026-08-07 ("dp" / "patience" / "cap") and
    ## this list dropped it, so the one field that says WHICH rule stopped a
    ## solve never reached a caller and the application could only report the
    ## index.  Diagnosing the m = 1 defect needed exactly that field.  `n_sol`
    ## records the sample the solve actually ran on, which is what the plug-in
    ## noise level is computed at -- see lf_panel.R's operator_residual().
    ## `iter` is now THE RETURNED ITERATE (eq:lfsched(c)'s m-hat) and `argmin`
    ## is the discrepancy argmin, which used to be the same number and is not
    ## any more -- see lf_solve()'s emptiness-convention note.
    lf_info[[k]] <- list(iter = fit$iter, argmin = fit$argmin,
                         stopped = fit$stopped_at,
                         hit_cap = fit$hit_cap, stop_rule = fit$stop_rule,
                         n_sol = length(sol_idx))

    ## `cells` is the GLOBAL cell set, not this fold's.  A fold missing an
    ## interior cell would otherwise align contrast l against propensity column
    ## l+1 without erroring -- see solve_balance_weight()'s own note.
    sw <- solve_balance_weight(fit$u, ws, x1[sol_idx], x2[sol_idx], Zs,
                               rho = rho, wcen = rho_s, cells = cells)
    disc <- disc + sw$rel_bal / K
    bal_by_fold[[k]] <- sw

    ## --- moment stage: transport phi to the held-out X values --------------
    phi_fun <- stats::approxfun(xeval, cumtrapz_centre(xeval, fit$dev), rule = 2)
    dphi[hold] <- phi_fun(x2[hold]) - phi_fun(x1[hold])
    ## varrho-hat^{(-k)} for the moment: fitted on the whole complement of the
    ## held-out fold, evaluated on the fold, as def:crossfit(a) requires.
    if (Lcells == 2L) {
      if (conditional) {
        pb <- fit_propensity(w, Z, rest, hold, eps = eps_rho, with_diag = TRUE)
        prop_diag[[2L * k]] <- c(list(stage = "moment", fold = k),
                                 attr(pb, "prop_diag"))
        attr(pb, "prop_diag") <- NULL
        rho_hat[hold] <- pb
      } else {
        rho_hat[hold] <- wbar
      }
    } else {
      if (conditional) {
        Pm <- fit_propensity_multi(w, Z, rest, hold, eps = eps_rho,
                                   cells = cells)
        prop_diag[[2L * k]] <- c(list(stage = "moment", fold = k),
                                 attr(Pm, "prop_diag"))
        attr(Pm, "prop_diag") <- NULL
        rho_hat[hold, ] <- Pm
      } else {
        rho_hat[hold, ] <- matrix(rep(cell_shares, each = length(hold)),
                                  length(hold), Lcells - 1L)
      }
    }

    if (verbose) {
      message(sprintf("  fold %d/%d: LF stopped at %d (argmin %d)%s",
                      k, K, fit$stopped_at, fit$iter,
                      if (isTRUE(fit$hit_cap)) " [HIT CAP]" else ""))
    }
  }

  eval_moment <- function(theta) {
    u <- as.vector(y - Z %*% theta) - dphi
    ## ----------------------------------------------------------------------
    ## GENERALIZED TO L >= 3, 2026-08-11.  This function was the LAST binary-
    ## only piece of the estimator: everything it calls -- solve_balance_weight,
    ## eval_ell, eval_lambda, contract_cells -- had been retyped, but these two
    ## containers stayed 2-D at every L, so at L >= 3 the fold assignment raised
    ## "number of items to replace is not a multiple of replacement length" and
    ## no orthogonal one-step existed above L = 2.  What is generalized is the
    ## TYPING, not the estimator: at L = 2 every line below is arithmetically
    ## the ported one, with the third extent equal to 1.
    ##
    ## eq:psidef is  psi = DZ dU + L(dU, dZ) Wtilde(varrho), with L p x (L-1)
    ## and Wtilde a column of (L-1) contrasts, so L Wtilde is R^p-valued -- the
    ## CONTRAST ON THE RIGHT, which is the only order that multiplies at
    ## L >= 3.  eq:Jhat is the same product one derivative down:
    ## Jhat(theta) = E_n[ DZ DZ' + ellhat Wtilde DZ' ], of shape
    ## (p x (L-1))((L-1) x 1)(1 x p).  `J` below is its NEGATIVE, which is the
    ## sign convention every caller's Newton step already uses:
    ## th1 = th0 - J^{-1} psibar reproduces eq:onestep's th0 + Jhat^{-1} psibar.
    L1 <- Lcells - 1L
    ## ----------------------------------------------------------------------
    ## Pi_w IS TAKEN FROM THE SOLVE, NOT RECOMPUTED HERE.
    ##
    ## solve_balance_weight() reports its balancing residual `rel_bal` -- which
    ## is what crossfit_once() returns as `disc` and what the bias bound is
    ## stated against -- after contracting over l with ITS masses.  Recomputing
    ## the masses here opens a channel for the two to disagree, and if they ever
    ## did, `disc` would describe a different estimator from the one `psi` is.
    ## They agree today (both uniform, B1(iv.d)); this makes them agree by
    ## construction.
    piw <- bal_by_fold[[1L]]$pi_w
    stopifnot(length(piw) == L1, all(piw > 0),
              abs(sum(piw) - 1) < 1e-12)
    for (k in seq_len(K)) {
      stopifnot(isTRUE(all.equal(bal_by_fold[[k]]$pi_w, piw)))
    }
    lam <- array(0, c(n, p, L1)); ell <- array(0, c(n, p, L1))
    for (k in seq_len(K)) {
      hold <- which(folds == k)
      sw <- bal_by_fold[[k]]
      ell[hold, , ] <- eval_ell(sw, u[hold])
      lam[hold, , ] <- eval_lambda(sw, u[hold])
    }
    ## The additive constant in lambda is irrelevant: Wtil is centred in
    ## sample, so sum_i Wtil_i * c = 0.  Centre it anyway for conditioning --
    ## and centre it PER (coordinate, contrast), because A2'(iii) makes lambda
    ## p x (L-1)-valued and each of the p(L-1) slices carries its own constant.
    ## The pre-2026-08-11 line swept over dimension 2 of a 2-D container, which
    ## is this same operation at L = 2 and is not defined at all at L >= 3.
    for (l in seq_len(L1)) {
      sl <- matrix(lam[, , l], n, p)
      lam[, , l] <- sweep(sl, 2L, colMeans(sl), "-")
    }
    ## CONDITIONAL centring, 2026-08-05.  Was w - wbar, which is Wtilde only
    ## under the predecessor's unconditional independence; A1 requires
    ## W - varrho(Delta Z).  rho_hat is cross-fitted, so the moment stays
    ## Neyman-orthogonal in the propensity direction.  eq:contrast:
    ## Wtilde_l = 1{W = l} - varrho_l(Delta Z), l = 1..L-1; the base cell is the
    ## residual and is never stored.
    Wi <- vapply(cells[-1], function(k) as.numeric(as.integer(w) == k),
                 numeric(n))
    Rho <- if (is.null(dim(rho_hat))) matrix(rho_hat, n, 1L) else
      as.matrix(rho_hat)
    stopifnot(nrow(Wi) == n, ncol(Wi) == L1,
              nrow(Rho) == n, ncol(Rho) == L1)
    wtil <- Wi - Rho
    ## eq:psidef: psi = DZ dU + L(dU, dZ) Wtilde, contrast on the RIGHT.
    lamW <- contract_cells(lam, wtil, piw)
    ellW <- contract_cells(ell, wtil, piw)
    list(psi = Z * u + lamW,
         J = -(crossprod(Z) / n + crossprod(ellW, Z) / n),
         u = u, lam = lam, ell = ell, wtil = wtil, pi_w = piw, L = Lcells)
  }

  ## phi-hat on the evaluation grid, averaged over folds and centred: the
  ## criterion the Bierens family is actually about.  theta is identified by the
  ## mean restriction, so theta's bias cannot speak to the family either way.
  phi_grid <- rowMeans(vapply(phi_paths,
    function(pp) cumtrapz_centre(xeval, pp$dev), numeric(length(xeval))))
  list(dphi = dphi, folds = folds, eval_moment = eval_moment, disc = disc,
       phi_paths = phi_paths, xeval = xeval, lf_info = lf_info,
       rho_hat = rho_hat, phi_grid = phi_grid, eps_rho = eps_rho,
       hx_scale = hx_scale,
       prop_diag = summarise_prop_diag(prop_diag))
}

#' Collapse the per-fold propensity diagnostics into one record.
#'
#' Reports what A4(i) is empirically about at a given eps_varrho: the smallest
#' PRE-projection cell probability, how often the projection onto eq:trunset
#' binds, and whether any fit failed or ran to its iteration cap.  Rows are
#' weighted by the number of evaluation points so `bind_rate` is a rate over
#' observation-evaluations rather than a mean of fold-level rates.
#'
#' @param pd list of per-call records, possibly with NULL entries.
#' @return named list, or NULL when nothing was recorded.
summarise_prop_diag <- function(pd) {
  ## A record must carry the payload, not merely exist.  A propensity exit that
  ## returns a bare vector leaves `c(list(stage, fold), NULL)` here -- two
  ## fields and no n_eval -- and every vapply() below would then fail on the
  ## whole fit rather than on the one record.  Dropped and COUNTED, so a silent
  ## exit shows up as n_undocumented rather than as nothing.
  ok <- vapply(pd, function(z) !is.null(z) && !is.null(z$n_eval), logical(1))
  n_undoc <- sum(!vapply(pd, is.null, logical(1))) - sum(ok)
  if (!any(ok)) return(NULL)
  pd <- pd[ok]
  ne <- vapply(pd, function(z) as.numeric(z$n_eval), numeric(1))
  nb <- vapply(pd, function(z) as.numeric(z$n_bind_rows), numeric(1))
  conv <- vapply(pd, function(z) {
    if (is.null(z$converged) || is.na(z$converged)) NA else isTRUE(z$converged)
  }, logical(1))
  list(n_calls = length(pd), n_undocumented = n_undoc,
       n_eval_total = sum(ne),
       min_pre = min(vapply(pd, function(z) z$min_pre, numeric(1))),
       min_pre_by_call = vapply(pd, function(z) z$min_pre, numeric(1)),
       n_bind = sum(nb),
       bind_rate = if (sum(ne) > 0) sum(nb) / sum(ne) else NA_real_,
       max_move = max(vapply(pd, function(z) z$max_move, numeric(1))),
       n_fallback = sum(vapply(pd, function(z) as.numeric(z$n_fallback),
                               numeric(1))),
       n_fallback_all = sum(vapply(pd, function(z) isTRUE(z$fallback_all),
                                   logical(1))),
       n_not_converged = sum(!is.na(conv) & !conv),
       n_conv_unknown = sum(is.na(conv)),
       routes = table(vapply(pd, function(z) z$route, character(1))),
       records = pd)
}

## ---- the estimator --------------------------------------------------------

## `tau_dp` AND `lf_patience` EXPOSED 2026-08-12.  Neither was reachable from
## this entry point, so it ran crossfit_once()'s defaults (0.7 and 30) whatever
## the caller wanted.  That is invisible until a caller ships a different rule --
## which app_tsp_common.R now does (TAU_DP = 0) -- at which point the D7 driver
## validation in app_tsp_01_diagnostics.R would be comparing two estimators that
## differ in their STOPPING RULE and reporting the gap as a driver defect.
## Defaults are unchanged, so every existing caller is unaffected.
orthogonal_theta <- function(y, x1, x2, Z, w, K = 5, n_part = 5, cste = 0.5,
                             init_fn = init_control, lf_imax = 150,
                             lf_patience = 30, rho = 1e-3, xeval = NULL,
                             seed = 1, tau_dp = 0.7, verbose = TRUE) {
  p <- ncol(Z); n <- length(y)
  set.seed(seed)
  th <- matrix(NA_real_, n_part, p)
  Vs <- array(NA_real_, c(n_part, p, p))
  discs <- matrix(NA_real_, n_part, p)
  devs <- vector("list", n_part)
  caps <- 0L

  for (b in seq_len(n_part)) {
    if (verbose) message(sprintf("partition %d/%d", b, n_part))
    cf <- crossfit_once(y, x1, x2, Z, w, K = K, cste = cste, xeval = xeval,
                        init_fn = init_fn, lf_imax = lf_imax,
                        lf_patience = lf_patience, tau_dp = tau_dp,
                        rho = rho, verbose = verbose)
    caps <- caps + sum(vapply(cf$lf_info, function(z) isTRUE(z$hit_cap), TRUE))

    ## Plug-in start, then one Newton step on the orthogonal moment.
    th0 <- stats::lm.fit(Z, y - cf$dphi)$coefficients
    th0[!is.finite(th0)] <- 0
    m0 <- cf$eval_moment(th0)
    J0i <- tryCatch(solve(m0$J), error = function(e) MASS::ginv(m0$J))
    th1 <- as.vector(th0 - J0i %*% colMeans(m0$psi))

    m1 <- cf$eval_moment(th1)
    J1i <- tryCatch(solve(m1$J), error = function(e) MASS::ginv(m1$J))
    th[b, ] <- th1
    Vs[b, , ] <- J1i %*% (crossprod(m1$psi) / n) %*% t(J1i) / n
    discs[b, ] <- cf$disc
    devs[[b]] <- cf$phi_paths
    if (b == 1) xeval_out <- cf$xeval
  }

  theta_hat <- apply(th, 2, stats::median)
  Vbar <- apply(Vs, c(2, 3), stats::median)
  spread <- if (n_part > 1) apply(th, 2, stats::var) else rep(0, p)
  se <- sqrt(pmax(diag(Vbar), 0) + spread / n_part)

  list(theta = theta_hat, se = se, V = Vbar, theta_partitions = th,
       disc = colMeans(discs), phi_paths = devs, xeval = xeval_out,
       n = n, K = K, n_part = n_part, lf_hit_cap = caps)
}

## ---- comparison estimators ------------------------------------------------

## The conditional model's moving parts, in one place, so that the full-sample
## entry points (phi_second_stage, alternating_theta) and the cross-fitted one
## (crossfit_once) cannot drift apart again.  conditional = FALSE returns the
## PORTED engine exactly: unconditional centring, no Bierens family, no
## Wtilde in the adjoint.
##
## ---------------------------------------------------------------------------
## GENERALIZED TO L >= 3, 2026-08-12.  THIS WAS THE LAST BINARY-ONLY PIECE OF
## THE PHI-STEP, AND IT WAS THE WHOLE OF IT.
##
## The line below read `fit_propensity(w, Z, idx, idx, eps = eps_rho)` -- the
## BINARY wrapper, which is stats::glm(family = binomial()) -- so both
## full-sample entry points died at the first non-binary instrument with
## "y values must be 0 <= y <= 1".  The theta step had been L-general since
## 2026-08-11 (crossfit_once routes through fit_propensity_multi at L >= 3), so
## the estimator's two halves disagreed about which instruments exist: theta-hat
## ran at L = 4 while phi-hat could not be formed there at all.
##
## VERIFIED, NOT ASSUMED, BEFORE THE CHANGE: everything downstream of this
## function is already L-general.  The phi-step's entire surface is
##     conditional_parts -> rho -> lf_solve -> operator_residual,
## and operator_residual() has taken an n x (L-1) `rho` since the
## L-generalization (its stopifnot at line 423 is the precedent this function
## now follows).  solve_balance_weight(), contract_cells() and eval_moment() are
## NOT on this path -- they belong to crossfit_once() -- so nothing else needed
## retyping.  Substituting the multinomial propensity by hand and making
## lf_solve()'s call directly ran clean at L = 2, 3 and 4 before a line was
## edited.
##
## `cells` IS AN ARGUMENT AND IS THREADED FROM THE CALLER, for the reason
## solve_balance_weight() carries the same argument: a sample that happens to
## contain no observation of some cell would otherwise produce a propensity with
## fewer columns than the contrast, which is non-conformable if the missing cell
## is the last one and SILENTLY MISALIGNED -- contrast l against propensity
## column l+1 -- if it is interior.  That is not hypothetical here: the phi-step
## is called inside a bootstrap (app_tsp_05_phi_band.R), where a resample can
## miss a small cell, and Section 6's smallest cell carries 6.6% of the sample.
## A0 makes L finite, fixed and known, so the caller knows the cell set and
## passes it; a sample missing a declared cell ERRORS here rather than being
## silently re-cardinalised.
##
## THE L = 2 PATH IS UNCHANGED, and that is a routing choice rather than a
## numerical one: fit_propensity() and fit_propensity_multi() agree to
## 0.000e+00 on this data at L = 2 (measured).  The binary wrapper is kept
## anyway so the shipped binary arm cannot move for any reason at all.
##
## @param cells integer vector or NULL. The instrument's cell set, base first.
##   NULL reads it off `w`, which is correct only when `w` is the full sample.
## @return named list: rho (vector at L = 2, n x (L-1) matrix at L >= 3), bier,
##   adj_wtil, cells, L, prop_diag.
conditional_parts <- function(Z, w, conditional = TRUE, eps_rho = 0.03,
                              n_t = 16L, bier_seed = 20260805L,
                              t_scale = 0.25, adj_wtil = TRUE,
                              cells = NULL) {
  seen <- sort(unique(as.integer(w)))
  if (is.null(cells)) cells <- seen
  cells <- sort(as.integer(cells))
  L <- length(cells)
  if (L < 2L) {
    stop("conditional_parts: W is degenerate, one cell only.")
  }
  ## Both directions are errors.  A declared cell absent from `w` is the
  ## misalignment above; a cell in `w` that the caller did not declare means the
  ## caller and the data disagree about the instrument, and silently adopting
  ## the data's answer would make L a property of the resample.
  gone <- setdiff(cells, seen)
  extra <- setdiff(seen, cells)
  if (length(gone) || length(extra)) {
    stop(sprintf(paste("conditional_parts: the sample's cells do not match the",
                       "declared set. Declared {%s}, present {%s}%s%s."),
                 paste(cells, collapse = ","), paste(seen, collapse = ","),
                 if (length(gone))
                   sprintf("; missing {%s}", paste(gone, collapse = ",")) else "",
                 if (length(extra))
                   sprintf("; undeclared {%s}", paste(extra, collapse = ",")) else ""))
  }
  if (!conditional) {
    return(list(rho = NULL, bier = NULL, adj_wtil = FALSE, cells = cells,
                L = L, prop_diag = NULL))
  }
  idx <- seq_along(w)
  ## The diagnostic attribute is captured and then STRIPPED, so it cannot ride
  ## into operator_residual()'s arithmetic or into any cached object built from
  ## it -- the same discipline crossfit_once() applies on receipt.  At L = 2
  ## with_diag = TRUE is identical() to the plain call once stripped (verified),
  ## so asking for it costs the binary arm nothing and makes the binding rate
  ## reportable on the same footing at both cardinalities.
  rho <- if (L == 2L) {
    fit_propensity(w, Z, idx, idx, eps = eps_rho, with_diag = TRUE)
  } else {
    fit_propensity_multi(w, Z, idx, idx, eps = eps_rho, cells = cells)
  }
  pd <- attr(rho, "prop_diag")
  attr(rho, "prop_diag") <- NULL
  list(rho = rho,
       bier = make_bierens(Z, n_t = n_t, seed = bier_seed, scale = t_scale),
       adj_wtil = adj_wtil, cells = cells, L = L, prop_diag = pd)
}

## The current draft's estimator: LF with the alternating OLS theta step.
## Conditional by default since 2026-08-07, for the same reason as
## phi_second_stage(): as a comparator it has to differ from the orthogonal
## estimator in the THETA STEP, not in which model it solves.
alternating_theta <- function(y, x1, x2, Z, w, cste = 0.5,
                              init_fn = init_control, xeval = NULL,
                              lf_imax = 60,
                              conditional = TRUE, eps_rho = 0.03,
                              n_t = 16L, bier_seed = 20260805L,
                              t_scale = 0.25, adj_wtil = TRUE, tau_dp = 0.7,
                              cells = NULL) {
  if (is.null(xeval)) {
    xeval <- seq(stats::quantile(c(x1, x2), 0.05),
                 stats::quantile(c(x1, x2), 0.95), length.out = 60)
  }
  op <- make_operator(x1, x2, xeval)
  init <- init_fn(y, x1, x2, Z, w, op)
  cf <- conditional_parts(Z, w, conditional, eps_rho, n_t, bier_seed, t_scale,
                          adj_wtil, cells = cells)
  ## `tau_dp` AND `patience` WERE NOT PASSED THROUGH UNTIL 2026-08-12.  This
  ## function has accepted a `tau_dp` argument since the conditional engine
  ## landed on 2026-08-07 and DROPPED IT ON THE FLOOR: lf_solve() fell back to
  ## its own default, so the argument was dead and a caller setting it got the
  ## default silently.  That was invisible while both were 0.7; it stops being
  ## invisible the moment the application sets 0 (app_tsp_common.R C26), which
  ## is when this comparison arm would have kept running the OLD stopping rule
  ## while the estimator it is compared against ran the new one.
  fit <- lf_solve(y, x1, x2, Z, w, op, init, rho = cf$rho, bier = cf$bier,
                  adj_wtil = cf$adj_wtil, cste = cste, imax = lf_imax,
                  patience = lf_imax, tau_dp = tau_dp)
  list(theta = fit$theta, dphi = fit$dphi, dev = fit$dev, xeval = xeval,
       u = fit$u, iter = fit$iter, phiev = fit$phiev,
       stopped_at = fit$stopped_at, stop_rule = fit$stop_rule,
       L = cf$L, cells = cf$cells, prop_diag = cf$prop_diag)
}

## Second-stage phi given theta-hat (prp:plugin): one LF pass on
## Delta Y - Delta Z' theta-hat, with theta held fixed.
##
## CONDITIONAL BY DEFAULT since 2026-08-07.  Before that date this function had
## no rho / bier / adj_wtil parameters and no `...`, so it silently took
## lf_solve()'s defaults and ran the PORTED, unconditional engine while
## crossfit_once() ran the conditional one.  The two halves of the same
## estimator were solving different models: theta-hat under A1's conditional
## restriction, phi-hat under the predecessor's unconditional one.
##
## No sample splitting here, and none is needed: this is the plug-in stage of
## prp:plugin given theta-hat, not the orthogonal moment, so varrho-hat is
## fitted and evaluated on the whole sample.  Cross-fitting exists in
## crossfit_once() to keep the nuisance out of the theta moment's influence
## function; it has no role once theta is held fixed.
##
## `cells` IS THE INSTRUMENT'S CELL SET, THREADED FROM THE CALLER.  This
## function is called inside a bootstrap, so `w` here is a RESAMPLE and its
## realised cell set is a random object; reading L off it would let a resample
## that misses Section 6's 6.6% cell run a THREE-cell estimator and report the
## result as a replication of the four-cell one.  See conditional_parts().
phi_second_stage <- function(y, x1, x2, Z, w, theta, cste = 0.5,
                             init_fn = init_control, xeval = NULL,
                             lf_imax = 60,
                             conditional = TRUE, eps_rho = 0.03,
                             n_t = 16L, bier_seed = 20260805L,
                             t_scale = 0.25, adj_wtil = TRUE, tau_dp = 0.7,
                             cells = NULL) {
  if (is.null(xeval)) {
    xeval <- seq(stats::quantile(c(x1, x2), 0.05),
                 stats::quantile(c(x1, x2), 0.95), length.out = 60)
  }
  op <- make_operator(x1, x2, xeval)
  init <- init_fn(y, x1, x2, Z, w, op)
  cf <- conditional_parts(Z, w, conditional, eps_rho, n_t, bier_seed, t_scale,
                          adj_wtil, cells = cells)
  ## `patience = lf_imax` ADDED 2026-08-12.  This call left patience at
  ## lf_solve()'s default of 30, which is BELOW the calibrated cap at L = 3 and
  ## L = 4 (30 and 60), so a stalled path could terminate the second stage
  ## before the budget the cap declares -- and under tau_dp = 0 the cap IS the
  ## regulariser, so a pre-emption is a silently different estimator.  Tying
  ## patience to the cap makes the cap the only terminus.
  fit <- lf_solve(y, x1, x2, Z, w, op, init, rho = cf$rho, bier = cf$bier,
                  adj_wtil = cf$adj_wtil, cste = cste, imax = lf_imax,
                  patience = lf_imax, tau_dp = tau_dp,
                  theta_mode = "fixed", theta_fixed = theta)
  list(dev = fit$dev, phiev = fit$phiev, xeval = xeval, u = fit$u,
       iter = fit$iter, cste = fit$cste, stopped_at = fit$stopped_at,
       hit_cap = fit$hit_cap, stop_rule = fit$stop_rule,
       ## The realised cardinality and the truncation diagnostics, carried so a
       ## caller can REPORT which estimator ran rather than infer it from the
       ## arguments it passed.  argmin is the discrepancy argmin: a solve with
       ## iter = m-bar and argmin = 1 ran the whole budget on a path that rose
       ## throughout, which the index alone cannot express.
       argmin = fit$argmin, L = cf$L, cells = cf$cells,
       prop_diag = cf$prop_diag)
}

## TSLS of Delta Y on (Delta X, Delta Z) instrumented by (W, Delta Z).
tsls_theta <- function(y, x1, x2, Z, w) {
  Xend <- cbind(x2 - x1, Z)
  Inst <- cbind(w, Z)
  PZ <- Inst %*% solve(crossprod(Inst), t(Inst))
  Xh <- PZ %*% Xend
  b <- solve(crossprod(Xh, Xend), crossprod(Xh, y))
  u <- as.vector(y - Xend %*% b)
  bread <- solve(crossprod(Xh, Xend))
  list(coef = as.vector(b),
       se = sqrt(diag(bread %*% crossprod(Xh * u) %*% t(bread))), u = u)
}
