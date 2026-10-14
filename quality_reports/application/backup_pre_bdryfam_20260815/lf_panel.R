## ---------------------------------------------------------------------------
## lf_panel.R -- Landweber-Fridman machinery for the short-panel NPIV model
##
##   Delta Y = phi(X2) - phi(X1) + Delta Z' theta + Delta U,
##   Delta U _||_ W | Delta Z                        <- A1, THIS paper
##
## MODEL CORRECTED 2026-08-05, AND THE HEADER IS WHERE THE DEFECT WAS VISIBLE.
## This file began as an R port of lfindfn_short_panel.m (Centorrino, Feve &
## Florens), whose model assumes Delta U _||_ W UNCONDITIONALLY -- and the header
## said so, accurately, for as long as the port went unchanged.  The present
## paper's contribution over that one is precisely the conditional form
## (main.qmd: "The latter route is the one we undertake in this paper, in the
## conditional form Delta U _||_ W | Delta Z"), and the engine had not followed:
##   * operator_residual() pooled the two W-cell CDFs, which is the
##     unconditional contrast;
##   * orthogonal_theta.R centred W at mean(w) rather than at varrho(Delta Z).
## Both are correct under the predecessor's assumption and neither is under A1
## unless varrho is constant, which on the Section 6 data it is not.  The
## conditional versions are now implemented and the unconditional ones remain
## reachable at rho = NULL, which is exactly the d_Z = 0 rung.
##
## THE BIERENS FAMILY w(t' Phi(Delta Z)) IS ALSO IMPLEMENTED (make_bierens()).
## It is what makes the moment IDENTIFYING rather than merely valid: the
## u-family alone imposes E[Wtilde 1{.}] = 0, the unconditional restriction,
## which A1 implies but is not implied by.  The t-family recovers the
## conditional restriction as an unconditional family, which is the Bierens
## device the identification argument runs on.  bier = NULL keeps the u-only
## behaviour and is what the d_Z = 0 rung uses, there being no Delta Z to
## condition on.
##
## Supplies:
##   * kernel density / distribution / regression helpers
##   * the integration operators M1, M2 that map phi' to phi on the sample
##   * apply_adjoint()  -- the adjoint A* of the Frechet derivative
##   * lf_solve()       -- the LF iteration for phi (alternating theta step,
##                         i.e. the estimator of the current draft)
##
## Plan: quality_reports/plans/2026-07-28_panel-npiv-direct-theta.md
## ---------------------------------------------------------------------------

## ---- kernel primitives ----------------------------------------------------

## Gaussian kernel and its integral (used as the smoothed indicator).
k_gauss <- function(u) dnorm(u)
K_gauss <- function(u) pnorm(u)

## Higher-order Gaussian-based kernels (Wand and Schucany, 1990) and their
## integrals.  The MATLAB source smooths the residual direction with an
## order-8 kernel at bandwidth ~ sd(u) * n^(-1/16); that bandwidth is far too
## wide for a second-order kernel, and using one collapses the W-contrast of
## the residual CDF to smoothing bias.  Orders 2, 4, 6, 8 are supported.
##
##   K_4(u) = (3 - u^2) phi(u) / 2
##   K_6(u) = (15 - 10u^2 + u^4) phi(u) / 8
##   K_8(u) = (105 - 105u^2 + 21u^4 - u^6) phi(u) / 48
##
## Integrals, obtained from  int_{-inf}^t u^{2k} phi = c_k Phi(t) - p_k(t)phi(t):
##   KK_4(t) = Phi(t) + t phi(t) / 2
##   KK_6(t) = Phi(t) + (7t - t^3) phi(t) / 8
##   KK_8(t) = Phi(t) + (t^5 - 16 t^3 + 57 t) phi(t) / 48
k_order <- function(u, order = 2L) {
  p <- dnorm(u)
  switch(as.character(order),
    "2" = p,
    "4" = 0.5 * (3 - u^2) * p,
    "6" = (15 - 10 * u^2 + u^4) * p / 8,
    "8" = (105 - 105 * u^2 + 21 * u^4 - u^6) * p / 48,
    stop("k_order: order must be 2, 4, 6 or 8"))
}

K_order <- function(u, order = 2L) {
  P <- pnorm(u); p <- dnorm(u)
  switch(as.character(order),
    "2" = P,
    "4" = P + u * p / 2,
    "6" = P + (7 * u - u^3) * p / 8,
    "8" = P + (u^5 - 16 * u^3 + 57 * u) * p / 48,
    stop("K_order: order must be 2, 4, 6 or 8"))
}

## Silverman-type bandwidth.
bw_rot <- function(x, power = -1 / 5, cst = 1.059) {
  cst * stats::sd(x) * length(x)^power
}

## ---------------------------------------------------------------------------
## THE RESIDUAL-DIRECTION BANDWIDTH, AND WHY IT NOW TAKES alpha.
##
## Amended C5'(i) is  h_u  ~  sd(Delta U) * delta-hat_n^{1/p_K}  =  n^{-alpha/8}
## at p_K = 8.  The engine's long-standing default was n^{-1/16}, which is
## ALPHA-FREE -- and n^{-1/16} = n^{-alpha/8} EXACTLY at alpha = 1/2.
##
## A5(iii) and rem:h6bandwidth put alpha STRICTLY below 1/2, so the retired
## tuning is the amended rule evaluated at the one alpha the theory excludes,
## and it is always NARROWER than the theory asks by n^{(1/2-alpha)/8}:
## 16.8% at n = 983, alpha = 0.32 -- the Section 6 configuration -- and 11.4%
## at alpha = 3/8.
##
## alpha = NULL reproduces the legacy n^{-1/16} bit-for-bit, so no existing
## caller moves silently; supplying alpha opts into the amended rule.
bw_u <- function(u, alpha = NULL, p_K = 8L, cst = 1.059) {
  pw <- if (is.null(alpha)) -1 / 16 else -alpha / p_K
  cst * stats::sd(u) * length(u)^pw
}

## ---------------------------------------------------------------------------
## THE x-DIRECTION BOUNDARY ADJUSTMENT.  ADDED 2026-08-14; UNTIL THEN THIS FILE
## IMPLEMENTED NONE, AND C3(ii) REQUIRES ONE.
##
## C3(ii) asks the x-direction kernel to satisfy the TRUNCATED moment conditions
## eq:truncmom,  int_{-c_C s_0}^{c_C} varsigma^j Theta_{s_0}(varsigma) dvarsigma
## = delta_{j0} for 0 <= j <= p_K - 1, at every boundary index s_0 in [0,1].
## What is implemented here is the RENORMALISED kernel of the Monte Carlo's
## design decision D11 (sim_thm_rootn_phistep.R:63-71),
##
##     C_h(x - X) / int_X C_h(y - X) dy,
##
## which enforces the j = 0 moment EXACTLY and no higher one.  j = 0 is the
## moment prp:hatAprop(iii) consumes: it is what makes int_X nu-hat dx = 0 and
## so keeps A-hat* inside V, and that clause feeds prp:phirate Step 2 (L2),
## eq:phirate and thm:rootn.  The higher truncated moments are NOT enforced, so
## the boundary bias is O(h_x) rather than O(h_x^{p_K}) within c_C h_x of an
## endpoint of X -- exactly the position D11 records for the simulation, and the
## application now runs the estimator the simulation verifies.
##
## WHY IT IS NOT COSMETIC ON THIS DESIGN.  Section 6 works in the rank
## coordinate, X = [0, 1], and bw_rot() is 0.083-0.099 there, so at an endpoint
## HALF the Gaussian mass lies outside X: the j = 0 truncated moment is 0.5000
## at the extreme design points and departs from 1 by more than 10% at 19.6% of
## them.  prp:hatAprop(iii)'s "the identity fails by an O(1) amount at design
## points within c_C h_x of an endpoint" is not an asymptotic caution here; the
## measured int_X nu-hat dx was 34% of sup|nu-hat| before this change.
##
## SCOPE.  x ONLY.  assumptions_main.tex:3074 is explicit that "the boundary
## index is carried only in the x-direction": in the residual direction u ranges
## over all of R and there is no boundary.  ker_dens() is called in BOTH
## directions (operator_residual() smooths the residual with it), so the support
## is an ARGUMENT and defaults to NULL, which reproduces the pre-2026-08-14 path
## bit-for-bit.  Only make_operator() supplies it.
##
## NOT ADJUSTED, DELIBERATELY.  ll_reg() and ll_reg_multi() are local-LINEAR, so
## their equivalent kernel already satisfies the j = 0 AND j = 1 truncated
## moments on any truncated support by construction; renormalising them would
## enforce nothing they do not already have.

## The j = 0 truncated moment of the kernel centred at each point of `x`:
##   (1/h) int_X C((y - x)/h) dy  =  K((hi - x)/h) - K((lo - x)/h).
## Equals 1 at an interior point and falls to 1/2 at an endpoint for a symmetric
## kernel.  Floored away from zero: for a higher-order kernel the mass inside a
## short interval can in principle vanish, and dividing by it must not produce
## an Inf that then propagates silently through the operator.
#' In-support mass of the x-direction kernel at each design point.
#'
#' @param x numeric. Design points the kernel is centred at.
#' @param h numeric(1). Bandwidth.
#' @param xsupp numeric(2). The endpoints of X.
#' @param order integer(1). Kernel order.
#' @return numeric, length(x). The j = 0 truncated moment at each point.
kernel_insupp_mass <- function(x, h, xsupp, order = 2L) {
  stopifnot(length(xsupp) == 2L, xsupp[2] > xsupp[1])
  m0 <- K_order((xsupp[2] - x) / h, order) -
        K_order((xsupp[1] - x) / h, order)
  pmax(m0, .Machine$double.eps)
}

## Kernel density of `x`, evaluated at `xeval`.
##
## `xsupp = NULL` is the unadjusted estimator and is what every residual-
## direction call uses.  With `xsupp = c(lo, hi)` each kernel is divided by its
## own in-support mass, so int_X f-hat dx = 1 exactly rather than the 0.939
## measured on the Section 6 design before this change.
ker_dens <- function(x, xeval = x, h = bw_rot(x), order = 2L, xsupp = NULL) {
  d <- outer(xeval, x, "-") / h
  Kd <- k_order(d, order)
  if (!is.null(xsupp)) {
    Kd <- sweep(Kd, 2L, kernel_insupp_mass(x, h, xsupp, order), "/")
  }
  rowMeans(Kd) / h
}

## Smoothed CDF of `x`, evaluated at `xeval`.
ker_dist <- function(x, xeval = x, h = bw_rot(x), order = 2L) {
  d <- outer(xeval, x, "-") / h
  rowMeans(K_order(d, order))
}

## Local-linear regression of y on scalar x, returning fit and derivative.
## Vectorised over xeval; kept simple because every call here is univariate.
ll_reg <- function(x, y, xeval = x, h = bw_rot(x)) {
  m <- length(xeval)
  fit <- numeric(m)
  der <- numeric(m)
  for (j in seq_len(m)) {
    dx <- x - xeval[j]
    wt <- k_gauss(dx / h)
    s0 <- sum(wt)
    s1 <- sum(wt * dx)
    s2 <- sum(wt * dx^2)
    t0 <- sum(wt * y)
    t1 <- sum(wt * dx * y)
    det <- s0 * s2 - s1^2
    if (!is.finite(det) || abs(det) < .Machine$double.eps^0.75) {
      fit[j] <- if (s0 > 0) t0 / s0 else NA_real_
      der[j] <- 0
    } else {
      fit[j] <- (s2 * t0 - s1 * t1) / det
      der[j] <- (s0 * t1 - s1 * t0) / det
    }
  }
  list(fit = fit, der = der)
}

## Local-linear regression on a matrix of regressors, returning fit and the
## full gradient. Used only for the initial conditions.
ll_reg_multi <- function(X, y, Xeval = X, h = NULL) {
  X <- as.matrix(X)
  Xeval <- as.matrix(Xeval)
  d <- ncol(X)
  n <- nrow(X)
  if (is.null(h)) h <- apply(X, 2, bw_rot, power = -1 / (4 + d))
  m <- nrow(Xeval)
  fit <- numeric(m)
  grad <- matrix(0, m, d)
  for (j in seq_len(m)) {
    dX <- sweep(X, 2, Xeval[j, ], "-")
    wt <- exp(rowSums(dnorm(sweep(dX, 2, h, "/"), log = TRUE)))
    D <- cbind(1, dX)
    WD <- D * wt
    A <- crossprod(D, WD)
    b <- crossprod(WD, y)
    sol <- tryCatch(solve(A + diag(1e-10, d + 1), b), error = function(e) rep(NA_real_, d + 1))
    fit[j] <- sol[1]
    grad[j, ] <- sol[-1]
  }
  list(fit = fit, grad = grad)
}

## ---- integration operators ------------------------------------------------

## Build the matrix M such that (M %*% g[order(x)]) approximates the running
## integral of g from min(x) upward, evaluated at the sorted sample points.
## Trapezoidal weights on the order statistics; mirrors M1/M2 in the .m file.
build_int_matrix <- function(x) {
  n <- length(x)
  xs <- sort(x)
  M <- matrix(0, n, n)
  dx <- diff(xs)
  ## Row i integrates g over [x_(1), x_(i)] with trapezoid weights.
  for (i in seq_len(n)) {
    if (i == 1) next
    w <- numeric(n)
    w[1:(i - 1)] <- w[1:(i - 1)] + dx[1:(i - 1)] / 2
    w[2:i] <- w[2:i] + dx[1:(i - 1)] / 2
    M[i, ] <- w
  }
  M
}

## Integrate a derivative estimate on the sample points and centre it.
## `ord` is order(x); the result is returned in original observation order.
integrate_centre <- function(dphi, M, ord) {
  n <- length(dphi)
  inv <- integer(n)
  inv[ord] <- seq_len(n)
  phis <- as.vector(M %*% dphi[ord])
  phis <- phis - mean(phis)
  phis[inv]
}

## Cumulative trapezoid on a grid, centred.
cumtrapz_centre <- function(grid, g) {
  n <- length(grid)
  out <- numeric(n)
  if (n > 1) out[-1] <- cumsum(diff(grid) * (g[-1] + g[-n]) / 2)
  out - mean(out)
}

## Restore the relative constant between phi(X1) and phi(X2).
##
## integrate_centre() centres the two reconstructions SEPARATELY -- phi over the
## X1 sample and phi over the X2 sample -- so each has sample mean zero.  That
## imposes E[phi(X2)] = E[phi(X1)], which the model does not imply.  Taking
## means in
##     Delta Y = phi(X2) - phi(X1) + Delta Z' theta + Delta U,   E[Delta U] = 0,
## gives
##     E[phi(X2)] - E[phi(X1)] = E[Delta Y] - E[Delta Z]' theta,
## i.e. THE MEAN OF PHI IS PINNED DOWN BY THE MEAN OF Y.  Setting it to zero
## instead dumps that difference into Delta U as a location error -- and the
## LF step cannot correct it, because a constant added to phi cancels in the
## difference.  So it has to be restored by hand, and at EVERY iteration: the
## residual whose W-contrast the operator drives to zero is the mis-located one
## otherwise, and theta is read off a regression on that same residual.
##
## The overall LEVEL of phi stays unidentified, as def:spaces has it; what is
## pinned is the difference of its means under f_1 and f_2, which is a
## restriction on shape, not on level.  cumtrapz_centre() therefore still
## centres phi on the evaluation grid and nothing here changes that.
locate_dphi <- function(dphi, y, Z, theta) {
  dphi + mean(as.vector(y - Z %*% theta) - dphi)
}

## ---- the operator and its adjoint -----------------------------------------

## Smoothed survival matrices S[a,b] = (1/n) * P(X_a >= x_b), the discretised
## indicator 1(x >= v) appearing in the adjoint.
##
## THIS IS WHERE C_{h_x} ENTERS nu-hat, AND THEREFORE WHERE C3(ii) BITES.  This
## file works in the DERIVATIVE parameterisation, so the object it carries is
## the running integral of eq:hatnu's kernel from v to the right,
##
##   S(v; X) = int_v^{hi} (1/h) C((y - X)/h) dy,
##
## and eq:hatnu's nu-hat is minus its derivative in v.  Unadjusted, the upper
## limit is +Inf and S(v; X) = 1 - K((v - X)/h), which is the line this function
## carried until 2026-08-14.  Adjusted, the integral is cut at hi and divided by
## the whole in-support mass -- i.e. it is the survival function of the
## RENORMALISED kernel, D11's device read in this parameterisation:
##
##   S(v; X) = { K((hi - X)/h) - K((v - X)/h) } / { K((hi - X)/h) - K((lo - X)/h) }.
##
## TWO IDENTITIES FOLLOW AND BOTH ARE EXACT, NOT ASYMPTOTIC.
##   (a) S(lo; X) = 1 and S(hi; X) = 0 at EVERY X, so
##       int_X nu-hat dx = nu-hat^der(lo) - nu-hat^der(hi) = 0, which is
##       prp:hatAprop(iii) and hence A-hat* Xi in V.
##   (b) The level and derivative parameterisations of eq:hatAcon then agree
##       exactly, the integration-by-parts boundary term [nu-hat^der phi] being
##       the same two numbers.  Without the adjustment they differ, so the
##       implemented "adjoint" was not the adjoint of the implemented operator.
## The map stays monotone from 1 to 0 -- it is the kernel's survival function
## CONDITIONED on landing in X -- so nothing downstream sees a sign change.
survival_matrix <- function(xrow, xcol, h, xsupp = NULL) {
  n <- length(xcol)
  if (is.null(xsupp)) {
    return((1 / n) * (1 - K_gauss(outer(xrow, xcol, "-") / h)))
  }
  stopifnot(length(xsupp) == 2L, xsupp[2] > xsupp[1])
  k_hi <- K_gauss((xsupp[2] - xcol) / h)
  k_lo <- K_gauss((xsupp[1] - xcol) / h)
  den <- pmax(k_hi - k_lo, .Machine$double.eps)
  num <- sweep(-K_gauss(outer(xrow, xcol, "-") / h), 2L, k_hi, "+")
  (1 / n) * sweep(num, 2L, den, "/")
}

## Precompute everything about the X-design that the LF iteration reuses.
## `xeval` is the grid on which phi is reported.
##
## `xsupp` IS X, THE SUPPORT C3(ii)'s TRUNCATED MOMENTS ARE TAKEN OVER, and it
## defaults to the empirical range of everything the operator touches.  That is
## the same interval the integration operators M1/M2 run over, so the
## estimator's own notion of X and the boundary adjustment's cannot drift apart.
## In Section 6's rank coordinate it is [1/(2n), 1], which is C2's
## pi = Uniform[0,1] up to one order statistic.
##
## `xeval` IS IN THE RANGE, AND IT IS NOT DECORATION.  crossfit_once() builds
## the operator on a 40% SOLVE FOLD but passes the evaluation grid of the FULL
## sample, and app_tsp_03_robustness.R does the same.  An evaluation point
## outside the fold's own range would then sit outside X, where the adjusted
## survival S(v; X) = {K((hi - X)/h) - K((v - X)/h)} / {...} is NEGATIVE -- a
## smoothed indicator taking values below zero, which nothing downstream checks
## for and which would show up only as a strange phi-hat. On this design the
## grid is the pooled 5th-95th percentile and every fold contains points below
## and above it, so the union is the fold's range at every fold that has ever
## run; taking the union anyway makes that an identity rather than a property of
## the realised draw.
##
## `xsupp = NULL` DISABLES the adjustment and reproduces the pre-2026-08-14
## engine bit-for-bit; it exists so that the before/after measurement of
## prp:hatAprop(iii) is a measurement and not an assertion, and it is not a
## configuration any shipped stage runs at.
make_operator <- function(x1, x2, xeval, hx = NULL,
                          xsupp = range(c(x1, x2, xeval))) {
  n <- length(x1)
  if (is.null(hx)) hx <- c(bw_rot(x1), bw_rot(x2))

  bw1 <- bw_rot(x1)
  bw2 <- bw_rot(x2)

  ## Reference measure pi: equal-weight mixture of the two period marginals.
  ## Each half carries its OWN bandwidth and its own design points, so each is
  ## renormalised against its own in-support mass.
  pi_1 <- 0.5 * ker_dens(x1, x1, bw1, xsupp = xsupp) +
          0.5 * ker_dens(x2, x1, bw2, xsupp = xsupp)
  pi_2 <- 0.5 * ker_dens(x1, x2, bw1, xsupp = xsupp) +
          0.5 * ker_dens(x2, x2, bw2, xsupp = xsupp)
  pi_ev <- 0.5 * ker_dens(x1, xeval, bw1, xsupp = xsupp) +
           0.5 * ker_dens(x2, xeval, bw2, xsupp = xsupp)

  list(
    n = n, x1 = x1, x2 = x2, xeval = xeval, hx = hx, xsupp = xsupp,
    ord1 = order(x1), ord2 = order(x2),
    M1 = build_int_matrix(x1), M2 = build_int_matrix(x2),
    pi_1 = pi_1, pi_2 = pi_2, pi_ev = pi_ev,
    bw1 = bw1, bw2 = bw2,
    S11 = survival_matrix(x1, x1, hx[1], xsupp),
    S12 = survival_matrix(x1, x2, hx[2], xsupp),
    S21 = survival_matrix(x2, x1, hx[1], xsupp),
    S22 = survival_matrix(x2, x2, hx[2], xsupp),
    Sev1 = survival_matrix(xeval, x1, hx[1], xsupp),
    Sev2 = survival_matrix(xeval, x2, hx[2], xsupp)
  )
}

## ---------------------------------------------------------------------------
## prp:hatAprop(iii)'s OWN OBSERVABLE, COMPUTED RATHER THAN ASSERTED.
##
## The clause is  int_X nu-hat_{u,t,l}(x) dx = 0 for every (u,t,l), hence
## A-hat*_varphi Xi in V for every Xi in L^2(Pi).  In the derivative
## parameterisation this file works in, apply_adjoint() forms
##
##   nu-hat^der(v) = (1/n) sum_i (g_i - gbar) { S(v; X_i2) - S(v; X_i1) },
##
## and eq:hatnu's level-space nu-hat is -d/dv of it, so
##
##   int_X nu-hat dx = nu-hat^der(lo) - nu-hat^der(hi),
##
## which is exactly computable from two extra survival rows.  `g` is the
## CONTRACTED residual comperr that apply_adjoint() is handed, i.e. Xi already
## paired against Pi, so the number returned is the V-membership of the
## realised A-hat* Xi and not merely of a sufficient condition for it.
##
## The centring by gbar is apply_adjoint()'s, reproduced here rather than
## dropped: the diagnostic must measure the operator the engine applies.
#' int_X nu-hat dx at a given residual: prp:hatAprop(iii)'s observable.
#'
#' @param op list. make_operator() output; op$xsupp fixes X.
#' @param g numeric, length op$n. The contracted residual apply_adjoint() takes.
#' @return named list: int_nu, nu_lo, nu_hi, scale, rel.
adjoint_range_defect <- function(op, g) {
  stopifnot(length(g) == op$n)
  if (is.null(op$xsupp)) {
    ## The unadjusted engine still HAS a support; it just does not use it.  Take
    ## the same pooled range so the two arms are compared over one interval.
    xs <- range(c(op$x1, op$x2))
  } else {
    xs <- op$xsupp
  }
  gc <- g - mean(g)
  nu_at <- function(v) {
    s2 <- survival_matrix(v, op$x2, op$hx[2], op$xsupp)
    s1 <- survival_matrix(v, op$x1, op$hx[1], op$xsupp)
    as.vector((s2 - s1) %*% gc)
  }
  nu_lo <- nu_at(xs[1])
  nu_hi <- nu_at(xs[2])
  ## Scale: the sup of |nu-hat^der| over a grid spanning X, so the defect is
  ## reported in the units of the object it is a defect in.
  grid <- seq(xs[1], xs[2], length.out = 201L)
  scale <- max(abs(nu_at(grid)))
  int_nu <- nu_lo - nu_hi
  list(int_nu = int_nu, nu_lo = nu_lo, nu_hi = nu_hi, scale = scale,
       rel = if (scale > 0) abs(int_nu) / scale else NA_real_)
}

## Squared operator norm of the composite map
##   q  |->  weight * { h_q(X2) - h_q(X1) },   h_q' = q,
## by power iteration.  Used to set the Landweber-Fridman step: the iteration
## converges for step < 2/||A||^2, and step = 1/||A||^2 is the usual choice.
##
## The MATLAB source fixes cste = 0.5 and compensates with
## imax = 20*floor((range(y)/cste) * n^(11/20)) ~ 3500 iterations, which is not
## runnable in R.  Setting the step from the operator norm reaches the same
## point on the LF path in O(100) iterations.
operator_norm2 <- function(op, weight = NULL, n_iter = 30L) {
  if (is.null(weight)) weight <- rep(1, op$n)
  v <- stats::rnorm(op$n)
  v <- v / sqrt(mean(v^2))
  nrm <- NA_real_
  for (k in seq_len(n_iter)) {
    a <- apply_adjoint(op, weight * v)
    h1 <- integrate_centre(a$d1, op$M1, op$ord1)
    h2 <- integrate_centre(a$d2, op$M2, op$ord2)
    fw <- weight * (h2 - h1)
    nrm <- sqrt(mean(fw^2))
    if (!is.finite(nrm) || nrm <= 0) return(NA_real_)
    v <- fw / nrm
  }
  nrm
}

## Apply the adjoint A* to a vector `g` defined at the sample points, i.e.
##   (A* g)(x) = { E[g | X2 = x] f_2(x) - E[g | X1 = x] f_1(x) } / pi(x),
## in the derivative parameterisation used by the LF iteration.  Returns the
## value at x1, at x2, and on the evaluation grid.
apply_adjoint <- function(op, g) {
  gbar <- mean(g)
  d1 <- ((op$S12 %*% g - rowSums(op$S12) * gbar) -
         (op$S11 %*% g - rowSums(op$S11) * gbar)) / op$pi_1
  d2 <- ((op$S22 %*% g - rowSums(op$S22) * gbar) -
         (op$S21 %*% g - rowSums(op$S21) * gbar)) / op$pi_2
  dev <- ((op$Sev2 - op$Sev1) %*% g -
          rowSums(op$Sev2 - op$Sev1) * gbar) / op$pi_ev
  list(d1 = as.vector(d1), d2 = as.vector(d2), dev = as.vector(dev))
}

## The residual of the independence restriction: the W-contrast of the smoothed
## CDF of the residual, weighted by its density.  This is `comperr` in the .m.
## `order` must stay at 8 to match the source: the bandwidth n^(-1/16) is only
## sensible for a high-order kernel.
## CONDITIONAL CENTRING, ADDED 2026-08-05.  `rho` is varrho(Delta Z), the
## propensity; the residual is the Wtilde-weighted smoothed CDF
##
##     That(u) = (1/n) sum_i (W_i - rho_i) C_{h_u}(u - u_i),
##
## which is the sample analogue of E[Wtilde 1{Delta U <= u}] in def:hatT, with
## Wtilde = W - varrho(Delta Z) as results_s2_identification.tex:160 defines it.
##
## WHY THIS CHANGED.  The previous form was F1 - F0, the difference of the two
## W-cell conditional CDFs POOLED over the sample.  That is the correct residual
## for the model this file was ported from -- Centorrino, Feve & Florens, where
## the restriction is Delta U _||_ W UNCONDITIONALLY -- and it is what the header
## above still describes.  This paper's A1 is the CONDITIONAL form
## Delta U _||_ W | Delta Z, and under it E[(W - wbar) 1{.} | Delta Z] =
## (varrho(Delta Z) - wbar) F(u | Delta Z), which is not zero unless varrho is
## constant.  So the pooled contrast solves an equation whose population zero is
## not varphi-dagger whenever W depends on Delta Z, which on the Section 6 data
## it does (joint F = 10.50, p < 1e-4).
##
## BACKWARD COMPATIBILITY, AND THE UNIT TEST THAT MATTERS.  rho = NULL keeps the
## unconditional reading, and at a constant rho the identity
##     (1/n) sum_i (W_i - wbar) C(u - u_i)  =  wbar (1 - wbar) (F1 - F0)
## holds exactly, so the new form is a positive multiple of the old one there.
## verify_conditional_centring() below checks it numerically; the factor is why
## the returned `err` is rescaled by 1 / (wbar (1 - wbar)), which leaves the
## discrepancy on the scale the stopping constants were calibrated against.
## THE BIERENS FAMILY.
##
## `bier` is NULL (the u-family alone, the pre-2026-08-05 behaviour) or a list
##   Wt   n x n_t, Wt[j, m] = w(t_m' Phi(Delta Z_j)) = exp(t_m' arctan(Delta Z_j))
##   pi_t length n_t, the Pi_t weights, summing to 1
## built by make_bierens().  With it the residual is the sample analogue of
##
##     That(u, t) = (1/n) sum_j Wtilde_j C_{h_u}(u - u_j) w(t' Phi(Delta Z_j)),
##
## which is def:hatT, and the family {That(., t)} is what converts A1's
## CONDITIONAL restriction into the unconditional one the estimator can impose.
## Without it the u-family alone imposes only E[Wtilde 1{.}] = 0, i.e.
## unconditional independence -- valid under A1 but not identifying.
##
## `err` is n x n_t.  `comperr` contracts it back to length n, because the
## adjoint acts on a per-observation vector: A*g needs
##     G_j = int int C(u - u_j) w(t' Phi(Delta Z_j)) g(u, t) dPi,
## discretised at the sample u values with density weight fu, exactly as the
## u-only code did.
make_bierens <- function(Z, n_t = 24L, seed = 20260805L, scale = 1.0) {
  ## n_t = 0 returns NULL: the u-only family, i.e. no Bierens device at all.
  ## THIS IS THE ONLY WAY TO TURN THE FAMILY OFF while keeping the conditional
  ## centring.  n_t = 1 does NOT do it -- it returns a single column
  ## exp(t_1' atan(Z)), one arbitrary direction, which is not constant across
  ## observations and is therefore a Bierens family of size one rather than
  ## none.  A validation sweep that used n_t = 1 to mean "no family" was
  ## measuring the cost of a randomly chosen direction, not of the centring.
  if (n_t <= 0L) return(NULL)
  Z <- as.matrix(Z)
  ## Drop zero-variance columns first.  make_design() returns an intercept
  ## column at every rung including d_Z = 0, so without this the family at
  ## d_Z = 0 would be built from atan(1) -- constant in j, hence a scalar
  ## multiple of the u-only residual that the LF step simply absorbs, and at
  ## d_Z >= 1 the constant would shift every index for no purpose.  Dropping
  ## them makes the family vacuous exactly when there is nothing to condition
  ## on, which is the correct behaviour and matches fit_propensity().
  keep <- apply(Z, 2, function(z) stats::sd(z) > 0)
  if (!any(keep)) return(NULL)
  Z <- Z[, keep, drop = FALSE]
  ## Phi = arctan (B1(i)), bounded, so t' Phi(z) cannot blow up the exponential.
  P <- atan(Z)
  ## A FIXED pseudo-random t-grid, seeded: a deterministic lattice is
  ## exponential in d_Z, and a fresh draw per call would put randomness inside
  ## the estimator.  Seeded once here, so the grid is part of the specification.
  old <- if (exists(".Random.seed", envir = globalenv()))
    get(".Random.seed", envir = globalenv()) else NULL
  set.seed(seed)
  Tm <- matrix(stats::rnorm(n_t * ncol(P), sd = scale), n_t, ncol(P))
  if (!is.null(old)) assign(".Random.seed", old, envir = globalenv())
  list(Wt = exp(P %*% t(Tm)), pi_t = rep(1 / n_t, n_t), Tm = Tm)
}

## adj_wtil: whether comperr carries the Wtilde_j factor that the adjoint
## derivation puts on Delta h_j.  FALSE reproduces lfindfn_short_panel.m
## (comperr = fhatu.*err, lines 271-278); TRUE is the exact adjoint of the
## operator whose residual `err` is, since
##   1{W=1}/wbar - 1{W=0}/(1-wbar) = (W - wbar) / (wbar (1 - wbar)).
## Settled empirically by the A/B harness rather than by assertion.
operator_residual <- function(u, w, rho = NULL, bier = NULL, adj_wtil = FALSE,
                              hu = NULL, order = 8L, pi_w = NULL, alpha = NULL) {
  if (is.null(hu)) hu <- bw_u(u, alpha = alpha)
  n  <- length(u)
  fu <- ker_dens(u, u, hu, order)
  ## ------------------------------------------------------------------------
  ## THE CONTRAST, AT L CATEGORIES.  Wtilde_{i,l} = 1{W_i = l} - varrho_l(dZ_i),
  ## l = 1..L-1, an n x (L-1) matrix (eq:contrast).  The base cell l = 0 is the
  ## residual and is never stored.  At L = 2 this is one column and every line
  ## below reduces to the scalar code bit-for-bit, which is the invariant the
  ## whole generalization is required to preserve.
  cells <- sort(unique(as.integer(w)))
  L <- length(cells)
  if (L < 2L) stop("operator_residual: W is degenerate, one cell only.")
  wbar <- mean(w)
  Wind <- if (L == 2L) matrix(as.numeric(as.integer(w) == cells[2]), n, 1L)
          else vapply(cells[-1], function(k) as.numeric(as.integer(w) == k),
                      numeric(n))
  Rho <- if (is.null(rho)) {
           matrix(rep(colMeans(Wind), each = n), n, L - 1L)
         } else if (is.null(dim(rho))) {
           matrix(rho, n, 1L)
         } else as.matrix(rho)
  stopifnot(nrow(Rho) == n, ncol(Rho) == L - 1L)
  wtil <- Wind - Rho
  ## SAME ARGUMENT AS locate_dphi(), one level up.  A1 gives E[Wtilde|Delta Z]=0
  ## and hence E[Wtilde]=0, so a sample Wtilde ought to have mean zero.  Under
  ## wbar centring it does, exactly and by construction.  Under varrho-hat it
  ## does NOT: the propensity is fitted on the operator fold and evaluated on
  ## the solve fold, and the leftover mean runs to +/- 0.06 at n = 400 against
  ## sd(W) = 0.5.  That leftover puts a CONSTANT in T-hat -- a component of the
  ## criterion that no phi can remove, since a constant in phi cancels in the
  ## difference -- and the LF step spends its iterations chasing it.  Imposing
  ## the model's own restriction in sample removes it.  This is a re-location,
  ## not a re-modelling: the dependence of varrho-hat on Delta Z, which is the
  ## whole point of the conditional centring, is untouched, and at rho = NULL
  ## the line is a no-op because the mean is already zero.
  wtil <- sweep(wtil, 2, colMeans(wtil), "-")
  Ku <- K_order(outer(u, u, "-") / hu, order)
  ## ------------------------------------------------------------------------
  ## THE OPERATOR SCALE, AND WHY IT IS l-INDEPENDENT.
  ##
  ## eq:Mdef is  M(u,t,l) = E[ Wtilde_l 1{...} w(t'Phi) ]  -- NO PREFACTOR.  The
  ## operator is not normalised; results_s3_estimation.tex carries no Omega^{-1}
  ## and no varrho(1-varrho) on any operator display.  Pi_w carries the l-weights.
  ##
  ## The binary code divided by wbar(1-wbar).  At L = 2 that is INVISIBLE and
  ## that is why it survived: it scales `err` and the plug-in delta-hat_n
  ## identically, so the ratio the discrepancy stop compares against tau_DP is
  ## invariant -- measured 0.216932 before and after rescaling by hand.
  ##
  ## *** IT STOPS CANCELLING AT L >= 3 IF PORTED CELLWISE. ***  The natural
  ## per-cell analogue scal_l = varrho_l(1-varrho_l) at Section 6's realised
  ## shares (0.700, 0.115, 0.066, 0.119) gives relative weights 1/scal_l of
  ## (1.03, 1.70, 1.00): cell 2 up-weighted 1.7x against cell 1 by a factor the
  ## theory does not contain.  So the scale is kept l-INDEPENDENT, where it
  ## cancels, and the legacy value is retained at L = 2 so that path is
  ## bit-for-bit unchanged.
  scal <- if (L == 2L) wbar * (1 - wbar) else 1
  if (!is.finite(scal) || scal <= 0) {
    stop("operator_residual: W is degenerate, so no W-contrast exists.")
  }
  ## `adjw` is the per-observation multiplier that comperr applies to the
  ## residual, i.e. the weight of the map the Landweber step actually
  ## contracts.  lf_solve() hands it to operator_norm2() when it has to set the
  ## step itself.  It reduces to fu EXACTLY at adj_wtil = FALSE, bier = NULL,
  ## so the ported path is bit-for-bit unchanged.  See lf_solve() for why the
  ## density alone is not the right weight once the two conditional factors are
  ## present.
  ## delta-hat_n, THE NOISE LEVEL A7's discrepancy principle stops against.
  ## T-hat(u_i, t_m) is the sample mean over j of
  ##   c_ijm = K_ij * Wtilde_j * w(t_m' Phi_j) / (wbar (1 - wbar)),
  ## so Var(T-hat(u_i,t_m)) = Var_j(c_ijm)/n, and the level is its L^2(Pi)
  ## aggregate -- the same norm residual_norm() reports, so the two are
  ## comparable without any rescaling.  Computed from Ku^2, one extra matrix
  ## product of exactly the cost of `err`.
  K2 <- Ku^2
  ## Pi_w, B1(iv.d): a PROBABILITY measure on {1,...,L-1}, masses strictly
  ## positive.  Uniform by default, so sum_l varpi_w(l) = 1 exactly -- which is
  ## the identity every constant in the corpus leans on when it declines to pay
  ## a c_Wtilde.  At L = 2 it is the scalar 1 and every line below is the
  ## ported one.
  piw <- if (is.null(pi_w)) rep(1 / (L - 1L), L - 1L) else pi_w
  stopifnot(length(piw) == L - 1L, all(piw > 0))
  piw <- piw / sum(piw)
  if (is.null(bier)) {
    err <- (Ku %*% wtil) / (n * scal)                       # n x (L-1)
    m2  <- (K2 %*% wtil^2) / (n * scal^2)
    noise <- sqrt(max(sum(colMeans(pmax(m2 - err^2, 0)) * piw), 0) / n)
    ## The adjoint is DIAGONAL in l and carries the masses inside (eq:Wdef), so
    ## the contraction is sum_l varpi_w(l) Wtilde_l err_l -- not a sum over l of
    ## separately normalised cells.
    comperr <- if (adj_wtil) {
      fu * as.vector(rowSums(sweep(wtil * err, 2, piw, "*"))) / scal
    } else fu * as.vector(rowSums(sweep(err, 2, piw, "*")))
    adjw <- if (adj_wtil) {
      abs(fu) * sqrt(as.vector(rowSums(sweep(wtil^2, 2, piw, "*")))) / scal
    } else abs(fu)
    return(list(err = if (L == 2L) as.vector(err) else err,
                comperr = comperr, fu = fu, hu = hu, wtil = wtil,
                adjw = adjw, noise = noise, pi_w = piw, L = L))
  }
  Wt <- bier$Wt; pit <- bier$pi_t
  stopifnot(nrow(Wt) == n, length(pit) == ncol(Wt))
  ## The range index is the PAIR (t, l); flatten it column-major so that the
  ## weight is the product measure pi_t (x) varpi_w, which is what Pi = Pi_u (x)
  ## Pi_t (x) Pi_w means.  At L = 2 the flattening is the identity.
  nt <- ncol(Wt)
  errL <- vector("list", L - 1L); m2L <- vector("list", L - 1L)
  for (l in seq_len(L - 1L)) {
    errL[[l]] <- (Ku %*% (wtil[, l] * Wt)) / (n * scal)
    m2L[[l]]  <- (K2 %*% (wtil[, l]^2 * Wt^2)) / (n * scal^2)
  }
  err <- do.call(cbind, errL); m2 <- do.call(cbind, m2L)
  pitl <- rep(pit, times = L - 1L) * rep(piw, each = nt)
  ## G_j = fu_j * sum_l varpi_w(l) sum_m pi_m Wt[j,m] err[j, (l,m)]
  ctr <- numeric(n)
  for (l in seq_len(L - 1L)) {
    g <- as.vector(rowSums(sweep(errL[[l]] * Wt, 2, pit, "*")))
    ctr <- ctr + piw[l] * (if (adj_wtil) wtil[, l] * g else g)
  }
  comperr <- fu * ctr / (if (adj_wtil) scal else 1)
  wsz <- sqrt(as.vector(rowSums(sweep(Wt^2, 2, pit, "*"))))
  szl <- if (adj_wtil) {
    sqrt(as.vector(rowSums(sweep(wtil^2, 2, piw, "*")))) / scal
  } else 1
  noise <- sqrt(sum(colMeans(pmax(m2 - err^2, 0)) * pitl) / n)
  list(err = err, comperr = comperr, fu = fu, hu = hu, wtil = wtil,
       pi_t = pitl, adjw = abs(fu) * szl * wsz, noise = noise,
       pi_w = piw, L = L)
}

## Discrepancy norm: ||That||_{L2(Pi)}.  With the t-family this is the Pi_t-
## weighted mean over t of the mean-square over u, so it reduces exactly to the
## u-only norm when n_t = 1 and pi_t = 1.
residual_norm <- function(res) {
  if (is.null(dim(res$err))) return(sqrt(mean(res$err^2)))
  sqrt(sum(colMeans(res$err^2) * res$pi_t))
}

## ---------------------------------------------------------------------------
## PROJECTION ONTO eq:trunset, THE eps-INTERIOR SIMPLEX -- NOT THE BOX.
##
## eq:trunset is  {q in R^{L-1} : q_l >= eps for l = 1..L-1,  sum_l q_l <= 1-eps},
## which is the statement that ALL L cells, the base l = 0 included, carry mass
## at least eps.  A4(i) quantifies over l in {0,...,L-1} for exactly that reason.
##
## WHY NOT THE BOX.  Clamping each coordinate to [eps, 1-eps] independently -- the
## binary code's `pmin(pmax(p, eps), 1-eps)` read coordinatewise -- leaves
## sum_l q_l free to exceed 1, so the IMPLIED BASE CELL q_0 = 1 - sum_l q_l can
## go NEGATIVE.  Omega-hat = diag(q) - qq' then loses positive-semidefiniteness
## and eq:omegafloor's lambda_min >= eps/L is not merely loose but false.  At
## L = 2 the box and the simplex coincide, which is why the binary code could
## use the box and be right; they part company at the first extra cell.
##
## The projection: floor every coordinate at eps, then if the sum exceeds 1-eps,
## shrink the excess above the floor proportionally.  Afterwards sum = 1-eps
## exactly and every coordinate is >= eps, so q_0 >= eps too.  Well posed iff
## (L-1)eps < 1-eps, i.e. eps < 1/L -- which is A4(i)'s own range, and which the
## Section 6 design satisfies with room (eps = 0.0115 against 1/L = 0.25).
project_trunset <- function(P, eps) {
  P <- pmax(P, eps)
  L1 <- ncol(P)
  if (eps * L1 >= 1 - eps) {
    stop(sprintf(paste("project_trunset: eps = %.4g is not < 1/L = %.4g, so",
                       "eq:trunset is empty and A4(i) cannot hold."),
                 eps, 1 / (L1 + 1)))
  }
  s <- rowSums(P)
  hot <- s > 1 - eps
  if (any(hot)) {
    room <- (1 - eps - eps * L1) / (s[hot] - eps * L1)
    P[hot, ] <- eps + (P[hot, , drop = FALSE] - eps) * room
  }
  P
}

## Cross-fitted MULTINOMIAL propensity varrho-hat(Delta Z), per def:crossfit(a):
## fitted on one index set, evaluated on a disjoint one, then projected into
## eq:trunset.  Returns an n_eval x (L-1) matrix whose l-th column is
## varrho-hat_l = P(W = l | Delta Z); the base cell l = 0 is the residual
## 1 - rowSums(.) and is never stored, matching eq:contrast's parameterisation.
##
## At L = 2 this is one column and reduces to the binary logit exactly; that is
## the invariant the whole L-generalization is required to preserve, so it is
## checked by a test rather than asserted.
##
## ---------------------------------------------------------------------------
## INSTRUMENTED 2026-08-11.  THREE THINGS THIS FUNCTION USED TO DO SILENTLY.
##
## (1) THE FALLBACK HAD NO COUNTER.  `P[bad] <- flat[bad]` substitutes the
##     UNCONDITIONAL cell shares -- the predecessor's model, the one A1 is not
##     about -- for whatever entries the fit could not produce, and nothing
##     recorded that it had happened or how often.
## (2) NON-CONVERGENCE WAS INVISIBLE.  nnet::multinom(maxit = 500L) returns the
##     LAST ITERATE without signalling, so tryCatch() cannot see it; the object's
##     `convergence` field (0 = converged, 1 = maxit reached) is the only
##     evidence and it was discarded.
## (3) THE TRUNCATION HAD NO BINDING RATE.  project_trunset() floors at eps and
##     shrinks the simplex excess.  Whether it BINDS -- and where truncation
##     destroys E[Wtilde_l | Delta Z] = 0, which is A1 itself -- is a measured
##     property of the design at a given eps, and it was measured nowhere.
##     theory_diagnostics()'s trunset_ok tested min(rho_hat) >= eps on the
##     POST-projection object, which project_trunset() guarantees by
##     construction: an identity dressed as a check.
##
## The three are reported through the "prop_diag" attribute of the return value,
## which every caller may ignore.  NO ARITHMETIC BELOW CHANGES: the attribute is
## attached last, and crossfit_once() strips it on receipt so it cannot leak into
## any downstream operand.
fit_propensity_multi <- function(w, Z, idx_fit, idx_eval, eps = 0.03,
                                 cells = NULL) {
  if (is.null(cells)) cells <- sort(unique(as.integer(w)))
  L <- length(cells)
  if (L < 2L) stop("fit_propensity_multi: W is degenerate, one cell only.")
  wf <- as.integer(w)[idx_fit]
  ne <- length(idx_eval)
  ## The d_Z = 0 fallback is the fitted CELL SHARES, which are varrho when there
  ## are no controls -- the L-category reading of the binary code's fitted mean.
  shares <- vapply(cells[-1], function(k) mean(wf == k), numeric(1))
  flat <- matrix(rep(shares, each = ne), ne, L - 1L)
  if (is.null(Z) || ncol(as.matrix(Z)) == 0L) {
    return(with_prop_diag(project_trunset(flat, eps), flat, eps, L,
                          route = "shares-no-Z", converged = NA,
                          n_fallback = ne * (L - 1L), fallback_all = TRUE))
  }
  Zf <- as.matrix(Z)[idx_fit, , drop = FALSE]
  keep <- apply(Zf, 2, function(z) stats::sd(z) > 0)
  if (!any(keep)) {
    return(with_prop_diag(project_trunset(flat, eps), flat, eps, L,
                          route = "shares-no-variation", converged = NA,
                          n_fallback = ne * (L - 1L), fallback_all = TRUE))
  }
  Zf <- Zf[, keep, drop = FALSE]
  Ze <- as.matrix(Z)[idx_eval, keep, drop = FALSE]
  conv <- NA
  fit <- tryCatch({
    if (L == 2L) {
      ## Binary: keep glm, so the L = 2 path is bit-for-bit the ported one.
      g <- suppressWarnings(stats::glm(
        .w ~ ., data = data.frame(.w = as.numeric(wf == cells[2]), Zf),
        family = stats::binomial()))
      list(P = matrix(as.vector(suppressWarnings(
             stats::predict(g, newdata = data.frame(Ze), type = "response"))),
             ne, 1L),
           converged = isTRUE(g$converged), route = "glm")
    } else {
      if (!requireNamespace("nnet", quietly = TRUE)) {
        stop("fit_propensity_multi: package 'nnet' is required at L >= 3.")
      }
      g <- nnet::multinom(.w ~ ., data = data.frame(.w = factor(wf, levels = cells), Zf),
                          trace = FALSE, maxit = 500L)
      pr <- stats::predict(g, newdata = data.frame(Ze), type = "probs")
      ## nnet's `convergence` is 1 when maxit was reached and 0 otherwise.  It
      ## is the ONLY signal of a non-converged fit: multinom() does not warn and
      ## does not error, so without this the last iterate is used as if it were
      ## the optimum.
      list(P = as.matrix(pr)[, -1L, drop = FALSE],
           converged = identical(as.integer(g$convergence), 0L),
           route = "multinom")
    }
  }, error = function(e) NULL)
  ## A separated or non-converged fit gives NULL / NA; fall back to the shares
  ## rather than propagate, and do it row-wise so one bad row does not discard
  ## the fit everywhere.
  fallback_all <- is.null(fit) || !is.matrix(fit$P) || ncol(fit$P) != L - 1L
  if (fallback_all) {
    P <- flat
    route <- "shares-fit-failed"
  } else {
    P <- fit$P
    conv <- fit$converged
    route <- fit$route
  }
  bad <- !is.finite(P)
  n_fallback <- sum(bad)
  if (n_fallback > 0L) P[bad] <- flat[bad]
  with_prop_diag(project_trunset(P, eps), P, eps, L, route = route,
                 converged = conv,
                 n_fallback = if (fallback_all) ne * (L - 1L) else n_fallback,
                 fallback_all = fallback_all)
}

#' Attach the pre-projection truncation diagnostics to a fitted propensity.
#'
#' The binding rate is the quantity A4(i) is empirically about: eq:trunset's
#' floor is harmless exactly when it does not bind, because where it binds the
#' projection moves varrho-hat away from the conditional probability and
#' E[Wtilde_l | Delta Z] = 0 -- A1 itself -- no longer holds at the truncated
#' propensity.  Reported over ALL L cells including the implied base
#' 1 - rowSums(.), because eq:trunset constrains that one too.
#'
#' @param P_post numeric matrix n_eval x (L-1). AFTER project_trunset().
#' @param P_pre numeric matrix n_eval x (L-1). BEFORE project_trunset().
#' @param eps numeric. The truncation level eps_varrho.
#' @param L integer. Number of cells.
#' @param route character. Which branch produced P_pre.
#' @param converged logical or NA. Fit convergence, NA when no fit was run.
#' @param n_fallback integer. Entries replaced by the unconditional shares.
#' @param fallback_all logical. Whether the whole matrix is the shares.
#' @return P_post with a "prop_diag" attribute.
with_prop_diag <- function(P_post, P_pre, eps, L, route, converged,
                           n_fallback, fallback_all) {
  all_pre <- cbind(1 - rowSums(P_pre), P_pre)
  ne <- nrow(P_pre)
  ## A row BINDS when the projection moved it: some cell below the floor, or a
  ## simplex excess that forced the proportional shrink.  Compared on the
  ## realised move rather than on the floor alone, so the shrink branch counts.
  moved <- rowSums(abs(P_post - P_pre)) > 1e-12
  attr(P_post, "prop_diag") <- list(
    n_eval = ne, L = L, eps = eps, route = route, converged = converged,
    n_fallback = as.integer(n_fallback), fallback_all = isTRUE(fallback_all),
    min_pre = min(all_pre), min_pre_stored = min(P_pre),
    min_base_pre = min(all_pre[, 1L]),
    n_below_eps = sum(all_pre < eps), n_bind_rows = sum(moved),
    bind_rate = if (ne > 0L) sum(moved) / ne else NA_real_,
    max_move = if (ne > 0L) max(abs(P_post - P_pre)) else NA_real_)
  P_post
}

## Cross-fitted propensity varrho-hat(Delta Z), per def:crossfit(a): fitted on
## one index set and evaluated on a disjoint one, then truncated into
## [eps, 1 - eps] so that |Wtilde-hat| stays bounded away from degeneracy, which
## is the role A4(i)'s eps_varrho plays in the theory.
##
## BINARY WRAPPER, retained so that every existing caller is bit-for-bit
## unchanged: it returns a VECTOR, as the scalar-contrast code expects.  New
## L-category callers use fit_propensity_multi() and get a matrix.
##
## The d_Z = 0 case returns the fitted mean, which IS varrho when there are no
## controls -- so at that rung the conditional and unconditional estimators
## coincide exactly, as they must.
##
## `with_diag` is OPT-IN, and deliberately so: the attribute it attaches would
## otherwise ride along in every downstream arithmetic result and into every
## cached object built from one, changing fingerprints for a diagnostic nobody
## asked for.  Off, this function returns exactly the object it returned before
## 2026-08-11.
fit_propensity <- function(w, Z, idx_fit, idx_eval, eps = 0.03,
                           with_diag = FALSE) {
  ## The two no-covariate exits.  They MUST carry a diagnostic record when one
  ## was asked for: an exit that returns a bare vector under with_diag = TRUE
  ## leaves the caller's accumulator holding a record with no fields, and
  ## summarise_prop_diag() then fails on the whole fit.  Caught on 2026-08-11 by
  ## the ladder's d_Z = 0 rung, where make_design() returns the intercept alone
  ## and `keep` is empty at every fold -- ten of ten partitions raised before the
  ## guard was added.  The failure was loud, which is the intended behaviour;
  ## the missing exit is what is fixed here.
  flat_exit <- function(route) {
    out <- rep(mean(w[idx_fit]), length(idx_eval))
    if (!with_diag) return(out)
    ## The shares are already in [0, 1] and untruncated, so nothing binds.
    attr(out, "prop_diag") <- list(
      n_eval = length(out), L = 2L, eps = eps, route = route,
      converged = NA, n_fallback = length(out), fallback_all = TRUE,
      min_pre = min(c(out, 1 - out)), min_pre_stored = min(out),
      min_base_pre = min(1 - out), n_below_eps = sum(c(out, 1 - out) < eps),
      n_bind_rows = 0L, bind_rate = 0, max_move = 0)
    out
  }
  if (is.null(Z) || ncol(Z) == 0L) return(flat_exit("mean-no-Z"))
  Zf <- as.matrix(Z)[idx_fit, , drop = FALSE]
  ## Drop columns with no within-fold variation: glm would return NA
  ## coefficients and predict() would propagate them silently.
  keep <- apply(Zf, 2, function(z) stats::sd(z) > 0)
  if (!any(keep)) return(flat_exit("mean-no-variation"))
  Zf <- Zf[, keep, drop = FALSE]
  Ze <- as.matrix(Z)[idx_eval, keep, drop = FALSE]
  df <- data.frame(.w = w[idx_fit], Zf)
  g <- suppressWarnings(
    stats::glm(.w ~ ., data = df, family = stats::binomial()))
  p <- suppressWarnings(
    stats::predict(g, newdata = data.frame(Ze), type = "response"))
  p <- as.vector(p)
  ## A separated or non-converged fit gives NA / 0 / 1; fall back rather than
  ## propagate, and do it loudly enough to be visible in a diagnostic.
  bad <- !is.finite(p)
  if (any(bad)) p[bad] <- mean(w[idx_fit])
  ## Same instrumentation as fit_propensity_multi(), so the L = 2 arm reports a
  ## binding rate on the same footing as the L = 4 one and the two are
  ## comparable.  The attribute is stripped by the caller; the arithmetic of the
  ## returned vector is unchanged.
  out <- pmin(pmax(p, eps), 1 - eps)
  if (!with_diag) return(out)
  attr(out, "prop_diag") <- list(
    n_eval = length(p), L = 2L, eps = eps, route = "glm",
    converged = isTRUE(g$converged), n_fallback = sum(bad),
    fallback_all = FALSE,
    min_pre = min(c(p, 1 - p)), min_pre_stored = min(p),
    min_base_pre = min(1 - p),
    n_below_eps = sum(c(p, 1 - p) < eps),
    n_bind_rows = sum(abs(out - p) > 1e-12),
    bind_rate = mean(abs(out - p) > 1e-12),
    max_move = max(abs(out - p)))
  out
}

## Unit test for the change above: at a constant propensity the Wtilde-weighted
## residual must reproduce the pooled cell contrast exactly.  Returns the max
## absolute discrepancy; called by the application's verification stage.
verify_conditional_centring <- function(u, w, order = 8L, tol = 1e-10) {
  hu <- 1.059 * stats::sd(u) * length(u)^(-1 / 16)
  new <- operator_residual(u, w, rho = NULL, hu = hu, order = order)$err
  F0  <- ker_dist(u[w == 0], u, hu, order)
  F1  <- ker_dist(u[w == 1], u, hu, order)
  gap <- max(abs(new - (F1 - F0)))
  list(max_gap = gap, ok = gap < tol)
}

## Independence criterion used to stop the iteration (cfun in the .m file):
## joint CDF of (U, Z'theta) within each W cell against the product.
indep_criterion <- function(u, v, w) {
  n <- length(u)
  Iu <- outer(u, u, "<=")
  Iv <- outer(v, v, "<=")
  j0 <- colMeans(Iu[w == 0, , drop = FALSE] & Iv[w == 0, , drop = FALSE])
  j1 <- colMeans(Iu[w == 1, , drop = FALSE] & Iv[w == 1, , drop = FALSE])
  mu <- colMeans(Iu)
  m0 <- colMeans(Iv[w == 0, , drop = FALSE])
  m1 <- colMeans(Iv[w == 1, , drop = FALSE])
  sum((j0 + j1 - mu * (m0 + m1))^2)
}

## ---- initial conditions ---------------------------------------------------

## Initial condition 1: derivative of a partially linear (Robinson) fit.
## All three initial conditions share the signature (y, x1, x2, Z, w, op) so
## that they are interchangeable; `w` is unused here.
init_robinson <- function(y, x1, x2, Z, w = NULL, op) {
  n <- length(y)
  X12 <- cbind(x1, x2)
  ## Partial out (x1, x2) nonparametrically, then OLS for theta.
  hZ <- apply(X12, 2, bw_rot, power = -1 / 6)
  resid_np <- function(v) v - ll_reg_multi(X12, v, X12, hZ)$fit
  Zt <- apply(Z[, -1, drop = FALSE], 2, resid_np)
  yt <- resid_np(y)
  g <- stats::lm.fit(as.matrix(Zt), yt)$coefficients
  g[!is.finite(g)] <- 0
  theta0 <- c(mean(y - Z[, -1, drop = FALSE] %*% g), g)
  r <- y - Z %*% theta0
  ## Marginal-integration derivatives in each argument.
  fit <- ll_reg_multi(X12, r, X12, hZ)
  d1 <- ll_reg(x1, r, x1, op$bw1)$der
  d2 <- ll_reg(x2, r, x2, op$bw2)$der
  dev <- 0.5 * ll_reg(x1, r, op$xeval, op$bw1)$der +
         0.5 * ll_reg(x2, r, op$xeval, op$bw2)$der
  list(d1 = d1, d2 = d2, dev = dev, theta = as.vector(theta0))
}

## Initial condition 2: control-function start, control from a linear quantile
## regression of Delta X on (W, Delta Z).
init_control <- function(y, x1, x2, Z, w, op, nq = 100) {
  n <- length(y)
  dx <- x2 - x1
  Q <- cbind(w, Z)
  probs <- seq(0.05, 0.95, length.out = nq)
  fitq <- suppressWarnings(quantreg::rq(dx ~ Q - 1, tau = probs))
  pred <- Q %*% coef(fitq)
  Vhat <- min(probs) + (1 - 2 * min(probs)) * rowMeans(pred <= dx)
  X12V <- cbind(x1, x2, Vhat)
  hZ <- apply(X12V, 2, bw_rot, power = -1 / 7)
  resid_np <- function(v) v - ll_reg_multi(X12V, v, X12V, hZ)$fit
  Zt <- apply(Z[, -1, drop = FALSE], 2, resid_np)
  yt <- resid_np(y)
  g <- stats::lm.fit(as.matrix(Zt), yt)$coefficients
  g[!is.finite(g)] <- 0
  theta0 <- c(mean(y - Z[, -1, drop = FALSE] %*% g), g)
  r <- y - Z %*% theta0
  d1 <- ll_reg(x1, r, x1, op$bw1)$der
  d2 <- ll_reg(x2, r, x2, op$bw2)$der
  dev <- 0.5 * ll_reg(x1, r, op$xeval, op$bw1)$der +
         0.5 * ll_reg(x2, r, op$xeval, op$bw2)$der
  list(d1 = d1, d2 = d2, dev = dev, theta = as.vector(theta0), V = Vhat)
}

## Initial condition 3: flexible parametric (cubic) start that imposes
## independence of U and W through a minimum-distance CDF criterion.
init_poly <- function(y, x1, x2, Z, w, op, porder = 3, nmulti = 5) {
  n <- length(y)
  D <- sapply(seq_len(porder), function(l) x2^l - x1^l)
  d1m <- sapply(seq_len(porder), function(l) l * x1^(l - 1))
  d2m <- sapply(seq_len(porder), function(l) l * x2^(l - 1))
  devm <- sapply(seq_len(porder), function(l) l * op$xeval^(l - 1))
  DZ <- cbind(D, Z)
  b_ols <- stats::lm.fit(DZ, y)$coefficients
  b_ols[!is.finite(b_ols)] <- 0

  ## Objective: squared discrepancy between the W-conditional ECDFs of the
  ## residual (the same independence criterion the LF iteration minimises).
  obj <- function(b) {
    u <- y - D %*% b
    u <- as.vector(u - mean(u))
    sum((colMeans(outer(u[w == 1], u, "<=")) -
         colMeans(outer(u[w == 0], u, "<=")))^2)
  }
  best <- b_ols[seq_len(porder)]
  bestv <- obj(best)
  sdb <- stats::sd(y) / (stats::sd(as.vector(D %*% best)) + 1e-8)
  for (k in seq_len(nmulti)) {
    st <- best + sdb * 0.1 * stats::rnorm(porder)
    o <- stats::optim(st, obj, method = "Nelder-Mead",
                      control = list(maxit = 500, reltol = 1e-10))
    if (o$value < bestv) { best <- o$par; bestv <- o$value }
  }
  theta0 <- stats::lm.fit(Z, as.vector(y - D %*% best))$coefficients
  theta0[!is.finite(theta0)] <- 0
  list(d1 = as.vector(d1m %*% best), d2 = as.vector(d2m %*% best),
       dev = as.vector(devm %*% best), theta = as.vector(theta0))
}

## ---- the Landweber-Fridman iteration --------------------------------------

## Solve for phi by LF, stopping at the argmin of the independence criterion.
##
## Two modes:
##   theta_mode = "alternate" -- update theta by OLS at every step (the current
##                               draft's estimator; used for comparison)
##   theta_mode = "fixed"     -- hold theta at `theta_fixed` (the second-stage
##                               solve of prp:plugin, once theta is known)
##
## DEVIATION FROM THE MATLAB SOURCE: lfindfn_short_panel.m sets
##   imax = 20*floor((range(y)/cste)*n^(11/20)),
## which is ~3500 iterations at n = 989.  Each iteration costs several n-by-n
## matrix products, so that is not runnable in R.  The criterion reaches its
## argmin far earlier, so we terminate once it has failed to improve for
## `patience` consecutive iterations.  `imax` remains a hard cap.  The realised
## stopping index is returned so it can be checked against the cap.
## `cste = NULL` sets the step from the operator norm (recommended).
##
## STOPPING RULE.  The MATLAB source stops at the argmin of a joint
## independence criterion (cfun).  We stop instead at the argmin of the direct
## operator residual ||F1 - F0||, which is the standard Landweber-Fridman
## discrepancy and displays clean semiconvergence here: it falls to a minimum
## and then rises as the iteration starts fitting noise.  cfun is still
## computed and returned as a diagnostic.
lf_solve <- function(y, x1, x2, Z, w, op, init,
                     rho = NULL,   # varrho(Delta Z); NULL = unconditional
                     bier = NULL,  # Bierens family from make_bierens()
                     adj_wtil = FALSE,
                     cste = NULL, imax = 200, patience = 30,
                     tau_dp = 0.7,
                     theta_mode = c("alternate", "fixed"),
                     theta_fixed = NULL, track_cfun = FALSE) {
  theta_mode <- match.arg(theta_mode)

  d1 <- init$d1; d2 <- init$d2; dev <- init$dev
  theta <- if (theta_mode == "fixed") theta_fixed else init$theta

  phi1 <- integrate_centre(d1, op$M1, op$ord1)
  phi2 <- integrate_centre(d2, op$M2, op$ord2)
  dphi <- locate_dphi(phi2 - phi1, y, Z, theta)

  ## STEP SIZE.  cste = 1/||A||^2 is only inside the Landweber stability bound
  ## 2/||A||^2 if ||A|| is the norm of the map the loop below actually
  ## contracts.  That map is d |-> A*(comperr), and comperr carries TWO
  ## multiplicative factors the ported engine did not have: aw = Wtilde/(wbar
  ## (1-wbar)), which reaches |aw| ~ 1/(wbar(1-wbar)) once varrho-hat is
  ## truncated at eps_rho, and the Bierens weight w(t'Phi(Delta Z)).  Norming
  ## f(u) alone -- correct for the ported engine, where aw was 1 and there was
  ## no Bierens family -- measures a strictly smaller operator, so 1/||A||^2
  ## computed from it can EXCEED 2/||A||^2 for the operator being iterated and
  ## the scheme over-steps.  res$adjw carries both factors and reduces to f(u)
  ## exactly when neither is present.  Corrected 2026-08-07.
  if (is.null(cste)) {
    u0 <- as.vector(y - Z %*% theta) - dphi
    r0 <- operator_residual(u0, w, rho = rho, bier = bier, adj_wtil = adj_wtil)
    nrm <- operator_norm2(op, weight = r0$adjw)
    cste <- if (is.finite(nrm) && nrm > 0) 1 / nrm else 0.5
  }

  ## STOPPING RULE.  A7 and results_s3_estimation.tex eq:lfsched(c) specify a
  ## DISCREPANCY PRINCIPLE: stop at the first m whose residual falls to the
  ## noise level,
  ##     m-hat = min{ m <= m-bar : ||T-hat_m||_{L^2(Pi)} <= tau_DP delta-hat_n ln n },
  ## with m-hat = m-bar when that set is empty.
  ##
  ## What this file did until 2026-08-07 was argmin-plus-patience, which is a
  ## DIFFERENT rule and only looked like a stopping rule because the step it
  ## was paired with was not a descent direction: with adj_wtil = FALSE the
  ## discrepancy RISES on iteration one (measured: 0.0698 -> 0.0958 at n = 400),
  ## so the argmin was reached immediately and patience did the stopping.  Once
  ## the adjoint carries the Wtilde factor lem:adjoint(i) puts there, the step
  ## IS the gradient of ||T-hat||^2, the discrepancy falls monotonically, the
  ## argmin is the cap, and argmin-plus-patience returns the OVERFITTED iterate
  ## every time.  That is the mechanism behind the median stopping index sitting
  ## at the cap in every arm of the application.
  ##
  ## The argmin is still tracked, and still used if the threshold is never
  ## reached -- but as the theory's m-bar convention, not as the rule.
  ##
  ## TWO CONSTANTS, AND WHERE EACH COMES FROM.
  ## (1) delta-hat_n.  A7 asks for a level that dominates the true operator
  ##     noise with probability approaching one; it does not hand the analyst
  ##     one.  operator_residual() computes the plug-in: the L^2(Pi) sampling
  ##     standard deviation of T-hat, in the same norm residual_norm() reports,
  ##     so the two are comparable with no rescaling.
  ## (2) tau_dp.  A7 states the level as tau_DP delta-hat_n ln n with
  ##     tau_DP >= 1.  The ln n there is a PROBABILITY-ENVELOPE device -- it
  ##     buys the "with probability approaching one" -- and is not a numerical
  ##     calibration.  Used literally it stops at m = 1 in every replication,
  ##     because at these n the initial discrepancy is already below
  ##     delta-hat_n ln n.
  ##
  ##     THE DEFAULT HERE IS 0.7 AND THE APPLICATION NO LONGER USES IT.
  ##     app_tsp_common.R sets tau_dp = 0 from 2026-08-12 -- the rule disabled,
  ##     the cap regularising -- on a (tau, m-bar) sweep in which tau = 0 was at
  ##     least as good as every positive tau at every (L, m-bar) tested.  The
  ##     reasoning, the measured firing rates and the cost accounting are at
  ##     app_tsp_common.R C4 and C26 and are NOT duplicated here; what matters
  ##     at this file's level is only that tau_dp = 0 is a supported setting and
  ##     is handled explicitly at the stop below.
  ##
  ##     0.7's own basis, kept because the default is still 0.7 for callers that
  ##     do not pass one: tracking ISE(phi_m) along the whole path over 10
  ##     replications, the oracle stop sits at m ~ 12 and the ratio
  ##     ||T-hat_m|| / delta-hat_n there has median 0.63 at n = 400 (IQR
  ##     0.39-0.93) and 0.76 at n = 800 (IQR 0.57-1.14).  At n = 400: phi ISE
  ##     0.023 at the oracle against 0.069 run to the cap and 0.134 at m = 1.
  ##     THAT COMPARISON IS AT THIS FILE'S OWN PILOT DESIGN, and the later sweep
  ##     on three multinomial designs reverses its conclusion at the sample
  ##     sizes the application runs at.
  errn <- rep(NA_real_, imax); cfun <- rep(NA_real_, imax)
  noisen <- rep(NA_real_, imax)
  best <- 1L; bestv <- Inf; keep <- NULL; since <- 0L; last <- 0L
  stop_dp <- NA_integer_
  ## THE CURRENT iterate, snapshotted every pass.  Needed because the loop
  ## APPLIES THE STEP after computing the residual, so once the loop exits by
  ## exhausting `imax` the live d1/d2/dev/dphi have already advanced to iterate
  ## imax + 1 -- whose residual was never computed.  eq:lfsched(c) asks for the
  ## iterate AT m-bar, so it has to be taken before the step.  phiev is NOT
  ## built here: it is one cumtrapz per iteration and is only ever needed for
  ## the single iterate that is returned, so it is built once, below.
  cur <- NULL

  for (it in seq_len(imax)) {
    u <- as.vector(y - Z %*% theta) - dphi
    res <- operator_residual(u, w, rho = rho, bier = bier, adj_wtil = adj_wtil)
    errn[it] <- residual_norm(res)
    noisen[it] <- res$noise
    if (track_cfun) cfun[it] <- indep_criterion(u, as.vector(Z %*% theta), w)
    last <- it
    cur <- list(dphi = dphi, dev = dev, theta = theta, u = u,
                d1 = d1, d2 = d2, iter = it)

    if (errn[it] < bestv) {
      bestv <- errn[it]; best <- it; since <- 0L
      keep <- list(dphi = dphi, dev = dev, theta = theta, u = u,
                   d1 = d1, d2 = d2, iter = it,
                   phiev = cumtrapz_centre(op$xeval, dev))
    } else {
      since <- since + 1L
    }

    ## The discrepancy stop, checked at the CURRENT iterate, which is the one
    ## the rule is about.
    ##
    ## `tau_dp > 0` IS AN EXPLICIT BRANCH, not a float accident.  tau_dp = 0 is
    ## the application's shipped setting from 2026-08-12 (app_tsp_common.R C26)
    ## and means "the rule never fires; run to the cap", which is
    ## eq:lfsched(c)'s emptiness convention.  Leaving it to `errn <= 0` would
    ## reach the same place by relying on a norm never underflowing to exactly
    ## zero -- true here, but not something to depend on, and it would read to
    ## the next person as an unintended degenerate case rather than the
    ## configuration it is.
    if (tau_dp > 0 && is.finite(res$noise) && errn[it] <= tau_dp * res$noise) {
      stop_dp <- it
      keep <- list(dphi = dphi, dev = dev, theta = theta, u = u,
                   d1 = d1, d2 = d2, iter = it,
                   phiev = cumtrapz_centre(op$xeval, dev))
      break
    }
    ## Patience remains only as a guard against a criterion that has stopped
    ## improving AND never reaches the level -- a diverging run, not a
    ## converging one.  It can no longer pre-empt the discrepancy stop.
    if (since >= patience) break

    step <- apply_adjoint(op, res$comperr)
    d1 <- d1 - cste * step$d1
    d2 <- d2 - cste * step$d2
    dev <- dev - cste * step$dev

    phi1 <- integrate_centre(d1, op$M1, op$ord1)
    phi2 <- integrate_centre(d2, op$M2, op$ord2)
    dphi <- locate_dphi(phi2 - phi1, y, Z, theta)

    if (theta_mode == "alternate") {
      theta <- stats::lm.fit(Z, as.vector(y - dphi))$coefficients
      theta[!is.finite(theta)] <- 0
      ## theta moved, so the location the line above was solved at has moved
      ## with it.  Re-impose it rather than carry a stale one into the next
      ## residual.
      dphi <- locate_dphi(dphi, y, Z, theta)
    }
  }

  ## How the run ended, so that a table can report the MIX rather than only the
  ## count of cap hits: "dp" = discrepancy level reached (the theory's rule
  ## fired), "patience" = criterion stalled above the level, "cap" = neither.
  stop_rule <- if (!is.na(stop_dp)) "dp" else
    if (last < imax) "patience" else "cap"

  ## ------------------------------------------------------------------------
  ## eq:lfsched(c)'s EMPTINESS CONVENTION, HONOURED FROM 2026-08-12.
  ##
  ## "stop at m-hat := min{m <= m-bar : ||T-hat_m|| <= tau_DP delta-hat_eff},
  ##  WITH THE CONVENTION THAT m-hat := m-bar WHEN THE SET IS EMPTY."
  ##
  ## Until now the empty-set branch returned the ARGMIN of the discrepancy path
  ## instead of the iterate at m-bar.  Those coincide whenever the path is
  ## monotone -- which is why the substitution survived while tau_dp = 0.7 made
  ## the branch rare -- and they come apart precisely on the paths that rise,
  ## where the argmin is m = 1 AND THE RETURNED phi-hat IS THE INITIAL
  ## CONDITION.  That is the same pathology the tau_dp recalibration exists to
  ## remove, reached by a different route: measured on the first re-run,
  ## 4 of 50 solves at d_Z = 10 and 8 of 50 at d_Z = 22 had argmin = 1 while
  ## running the full budget.
  ##
  ## It also matters for the CALIBRATION, not just for faithfulness: the
  ## (tau, m-bar) sweep that chose LF_MBAR prices each path at
  ## `m <- if (length(h)) h[1] else cap` (sim_multinomial_phistep.R, rule_at()),
  ## i.e. AT THE CAP.  A cap that returned the argmin instead would be a
  ## different estimator from the one the constants were chosen for.
  ##
  ## The patience branch is deliberately NOT changed.  Patience fires only on a
  ## run that has stopped improving and never reached the level -- a diverging
  ## path -- and the argmin is the right thing to salvage from one of those.
  if (identical(stop_rule, "cap") && !is.null(cur)) {
    cur$phiev <- cumtrapz_centre(op$xeval, cur$dev)
    keep <- cur
  }

  keep$err_path <- errn[seq_len(last)]
  keep$noise_path <- noisen[seq_len(last)]
  keep$cfun <- if (track_cfun) cfun[seq_len(last)] else NULL
  keep$cste <- cste
  keep$stopped_at <- last
  keep$hit_cap <- (last == imax)
  keep$stop_rule <- stop_rule
  ## The discrepancy argmin, retained as a DIAGNOSTIC now that it is no longer
  ## the selection rule on any branch but patience.  A gap between `argmin` and
  ## `iter` is a semiconvergent path; argmin = 1 with iter = m-bar is a path
  ## that rose throughout, which is worth counting and no longer worth
  ## returning.
  keep$argmin <- best
  keep$tau_dp <- tau_dp
  keep$noise_final <- noisen[last]
  keep
}

## ---------------------------------------------------------------------------
## THEORY-FACING DIAGNOSTICS, per the plan's Phase 7 requirements.
##
## Everything here is REPORTED, never gated on: the assumption audit established
## that of A4(i)'s eleven consumers three need only the floor's POSITIVITY and
## eight need its VALUE, and that none of the eight sits on the theta-step's
## inferential path.  So the empirical burden is positivity at every cell, and
## the value belongs in the report at its realised level rather than a nominal one.
##
## c_14 >= c_16 is UNVERIFIABLE -- c_16 is analytic and unknown to the analyst,
## c_14 is chosen -- so the realised c_14 and stopping index are stated and NO
## verification is claimed.  Plan section 4, item 8.
##
## ---------------------------------------------------------------------------
## `trunset_ok` REDEFINED 2026-08-11, BECAUSE THE OLD ONE COULD NOT FAIL.
##
## It read  min(allc) >= eps_rho - 1e-12 && eps_rho < 1/L  on the POST-projection
## propensity.  project_trunset() returns every coordinate >= eps and the implied
## base >= eps by construction, so the first conjunct is an identity: it tests
## that a projection projected.  What it appeared to certify -- that A4(i)'s
## floor is a harmless formality on this design -- is a statement about the
## PRE-projection fit, and that statement is exactly what the old field could not
## make.  A4(i)'s empirical content is: does the floor BIND, and where?  Where it
## binds, varrho-hat is moved off the conditional probability and
## E[Wtilde_l | Delta Z] = 0 -- A1 -- fails at the truncated propensity.
##
## The field now carries only the WELL-POSEDNESS half, eps_rho < 1/L, which is a
## real (if weak) condition on the constant and is what project_trunset() itself
## errors on.  `rho_pre` is optional and, when supplied, adds the two quantities
## that carry the content: min_rho_pre and bind_rate.  Callers that gate on
## trunset_ok keep a true assertion; callers that want the content read the new
## fields.
theory_diagnostics <- function(w, rho_hat, eps_rho = 0.03, n = length(w),
                               r_n = NULL, stop_idx = NULL, tau_dp = NULL,
                               rho_pre = NULL) {
  cells <- sort(unique(as.integer(w)))
  L <- length(cells)
  R <- if (is.null(dim(rho_hat))) matrix(rho_hat, n, 1L) else as.matrix(rho_hat)
  R0 <- 1 - rowSums(R)                       # the base cell, never stored
  allc <- cbind(R0, R)
  ## A5(i): delta-hat_n = max{ n^{-1/2} sqrt(ln n), r_n }.  Which branch binds is
  ## an empirical fact about the design and thm:rootn Step 4(c) depends on it.
  br_var <- n^(-1 / 2) * sqrt(log(n))
  delta <- if (is.null(r_n)) br_var else max(br_var, r_n)
  cw <- min(sqrt(2), sqrt(L - 1))
  lam <- apply(R, 1, function(q) {
    if (length(q) == 1L) q * (1 - q)
    else min(eigen(diag(q, length(q)) - outer(q, q), only.values = TRUE)$values)
  })
  ## PRE-projection quantities: NA when the caller cannot supply them, never
  ## silently substituted by the post-projection ones.
  n_rows <- nrow(R)
  if (is.null(rho_pre)) {
    min_pre <- NA_real_
    bind_rate <- NA_real_
    n_bind <- NA_integer_
  } else {
    Rp <- if (is.null(dim(rho_pre))) matrix(rho_pre, n, 1L) else
      as.matrix(rho_pre)
    stopifnot(nrow(Rp) == nrow(R), ncol(Rp) == ncol(R))
    allp <- cbind(1 - rowSums(Rp), Rp)
    min_pre <- min(allp)
    moved <- rowSums(abs(R - Rp)) > 1e-12
    n_bind <- sum(moved)
    bind_rate <- n_bind / nrow(R)
  }
  list(L = L,
       cell_counts = as.vector(table(factor(as.integer(w), levels = cells))),
       min_rho = min(allc), one_over_L = 1 / L,
       trunset_ok = eps_rho > 0 && eps_rho < 1 / L,
       min_rho_pre = min_pre, n_bind = n_bind, bind_rate = bind_rate,
       n_rows = n_rows,
       lam_min_Omega = min(lam), omega_floor = eps_rho / L,
       floor_holds = min(lam) >= eps_rho / L - 1e-12,
       c_Wtilde = cw, c_Wtilde_is_binary = isTRUE(all.equal(cw, 1)),
       delta_n = delta, branch_variance = br_var, branch_rn = r_n,
       binding_branch = if (is.null(r_n) || br_var >= r_n) "n^{-1/2}sqrt(ln n)" else "r_n",
       c14_realised = tau_dp, stop_index = stop_idx,
       c14_claim = "REPORTED ONLY -- c_14 >= c_16 is unverifiable (c_16 analytic, unknown)")
}

print_theory_diagnostics <- function(d) {
  cat(sprintf("  L = %d, cells %s\n", d$L, paste(d$cell_counts, collapse = " / ")))
  cat(sprintf("  A4(i)  eq:trunset well posed (eps < 1/L): %s   eps/1/L = %.4f\n",
              ifelse(d$trunset_ok, "YES", "NO"), d$one_over_L))
  cat(sprintf("  A4(i)  min_l rho-hat_l POST-projection = %.4f  (>= eps by construction)\n",
              d$min_rho))
  if (is.finite(d$min_rho_pre)) {
    cat(sprintf("  A4(i)  min_l rho-hat_l PRE-projection  = %.4g   truncation binds on %d of %d rows (%.2f%%)\n",
                d$min_rho_pre, d$n_bind, d$n_rows, 100 * d$bind_rate))
  } else {
    cat("  A4(i)  PRE-projection minimum NOT SUPPLIED -- binding rate unknown\n")
  }
  cat(sprintf("  eq:omegafloor  lambda_min(Omega-hat) = %.5f  vs eps/L = %.5f   %s\n",
              d$lam_min_Omega, d$omega_floor, ifelse(d$floor_holds, "HOLDS", "*** VIOLATED ***")))
  cat(sprintf("  c_Wtilde = min{sqrt2, sqrt(L-1)} = %.6f%s\n", d$c_Wtilde,
              ifelse(d$c_Wtilde_is_binary, "  (binary case)",
                     "  <- NOT 1; constants carry this factor")))
  cat(sprintf("  A5(i)  delta-hat_n = %.6f   binding branch: %s\n", d$delta_n, d$binding_branch))
  if (!is.null(d$c14_realised))
    cat(sprintf("  c_14 realised = %.4f at stopping index %s  [%s]\n",
                d$c14_realised, ifelse(is.null(d$stop_index), "NA", d$stop_index), d$c14_claim))
  invisible(d)
}
