# ============================================================================
# sim_thm_rootn_headroom_dgp.R
#
# The HEADROOM configuration of thm:rootn, and the d_Z-general DGP machinery it
# needs. THIS FILE IS SOURCED, NOT RUN. It sets no seed and writes no output.
#
# It is sourced AFTER sim_thm_rootn_dgp.R and sim_thm_rootn_nuisance.R and it
# REPLACES exactly three of their functions -- dgp_draw, solve_ell_star,
# draw_rhat -- each of which hard-codes d_Z = 3 or p = 4 and none of which is
# part of the ESTIMATOR. The estimator (one_rep_full, run_cell) is not copied,
# not edited and not re-implemented: sim_thm_rootn_headroom.R lifts those two
# functions out of the shipped limit-law arm by parsing it, so the replication
# path is the shipped one byte for byte.
#
# hr_assert_dgp_equivalence() proves the three replacements are not a rewrite:
# at the shipped spec (d_Z = 3, p = 4) each consumes the same random numbers in
# the same order and returns an object identical() to the shipped one.
#
# ---------------------------------------------------------------------------
# WHY A NEW CONFIGURATION AT ALL
#
# At the shipped frontier-clearing configuration (mu, s, a, r, d_Z) =
# (2, 3, 3/4, 8/3, 3) the Step-4 leading product is
#
#     sqrt(n) delta_n^2 = n^{1/2 - 2 kappa alpha} (ln n)^{2 kappa}
#                       = n^{-0.012} (ln n)^{1.6},
#
# kappa = 2mu/(2mu+1) = 0.8 and alpha = r/(2r+d_Z) = 0.32, so kappa alpha =
# 0.2560 against eq:frontier's 1/4: a margin of 0.006. The budget RISES across
# the whole Monte Carlo grid (11.7 at n = 125 to 46.7 at n = 181,019, elasticity
# still +0.120 at the top cell) and does not turn over until ln n = 133.3, i.e.
# n = 10^{57.9}, reproducing rem:h6bandwidth's own n*. The shipped limit-law arm
# therefore never entered the regime thm:rootn describes; it measured the
# remainder. THIS FILE BUILDS A CONFIGURATION THAT DOES ENTER IT.
#
# ---------------------------------------------------------------------------
# THE TWO ARITHMETIC FACTS THAT DECIDE THE DESIGN
#
# (1) A5(i) IS A MAXIMUM AND ITS FIRST BRANCH IS NOT NEGLIGIBLE HERE.
#     A5(i) reads delta-hat_n = max{delta-hat_n^{(T)}, delta-hat_n^{(varrho)}}
#     with delta-hat_n^{(T)} = O_P(n^{-1/2} sqrt(ln n)) and
#     delta-hat_n^{(varrho)} = O_P(r_n), and adds "in every configuration of
#     interest delta-hat_n = delta-hat_n^{(varrho)}". That sentence is an
#     ASYMPTOTIC statement and it is true: r_n = n^{-alpha} with alpha < 1/2
#     eventually dominates n^{-1/2} sqrt(ln n). It is FALSE OVER THE FEASIBLE
#     GRID as soon as alpha is pushed up, which is exactly what buying frontier
#     headroom requires: at n = 181,019 the propensity branch dominates only if
#     alpha < 0.397. sim_thm_rootn_dgp.R's rate_delta_hat() implements the
#     r_n-dominant branch alone -- harmless at alpha = 0.32, not harmless here.
#
#     CONSEQUENCE, and it is a bound no design can beat: delta-hat_n is at least
#     the parametric branch, so
#         sqrt(n) delta_n^2 >= sqrt(n) (n^{-1/2} (ln n)^{3/2})^{2 kappa}
#                            = n^{1/2 - kappa} (ln n)^{3 kappa}
#     which is decreasing in kappa and hence minimised as mu -> infinity at
#     n^{-1/2} (ln n)^3 = 4.17 at n = 181,019. AT c_delta = 1 NO CONFIGURATION
#     WHATSOEVER PUTS THE BUDGET BELOW ONE AT ANY n THIS GRID REACHES. The
#     constant, not the configuration, is the only lever at feasible n -- which
#     is why c_delta is swept and why the arm is run at three values of it.
#
#     hr_budget() reports BOTH readings so the difference is visible per cell.
#     The injected size uses the LITERAL max, which is the conservative choice:
#     it makes ||h|| larger, not smaller, than the r_n-only reading would.
#
# (2) THE FRONTIER AND eq:lxwindow PULL AGAINST EACH OTHER, AND THE KERNEL
#     ORDER DECIDES WHO WINS. eq:frontier wants alpha large. But (P-c) ^ (P-d)
#     read at h_u asymp delta-hat_n^{1/p_K} give the sieve window
#         n^{alpha (1 + 1/p_K) / s}  <<  L_x  =  o(n^{1 - 2 alpha} / ln n),
#     non-empty only if s > alpha (1 + 1/p_K) / (1 - 2 alpha) -- the assumption
#     block's eq:lxwindow, printed there at p_K = 8 as s > 9 alpha / (8(1-2alpha))
#     -- whose right-hand side DIVERGES as alpha -> 1/2, while lem:unifop Step 4
#     caps s <= p_K + 1/2. At p_K = 8 the two are compatible only for
#         alpha < (p_K + 1/2) / (2 p_K + 2 + 1/p_K) = 0.46897.
#     A4(ii)'s own note says the same thing at the other endpoint: at alpha = 1/2
#     the window is empty at every s, prp:phirate has no admissible sieve
#     dimension, group (T-5) of thm:rootn is unsatisfiable and THE THEOREM IS
#     VACUOUS.
#
#     This is what rules out the high-r designs. At d_Z = 1: r = 10 gives
#     alpha = 0.4762 and needs s > 11.25; r = 20 gives alpha = 0.4878 and needs
#     s > 22.5; r = 50 gives alpha = 0.4950 and needs s > 56.25. All three are
#     against s <= 8.5. NONE OF THEM IS CONSTRUCTIBLE at p_K = 8, and raising
#     p_K does not rescue them cheaply, the threshold tending to alpha/(1-2alpha)
#     = 20.0 at r = 20 even as p_K -> infinity.
#
# ---------------------------------------------------------------------------
# DESIGN H, AND WHY THESE FIVE NUMBERS
#
#   (mu, s, a, r, d_Z) = (5, 4, 2/5, 21/8, 1),  p_K = 8,  p = 2.
#
#   kappa = 10/11 = 0.90909, alpha = 21/8 / (21/4 + 1) = 0.42,
#   kappa alpha = 0.38182 against eq:frontier's 1/4: MARGIN 0.132, twenty-two
#   times the shipped 0.006.
#
#   d_Z = 1 -- the headroom comes from the propensity DIMENSION, not from its
#     smoothness. A4(ii) needs 1 <= d_Z <= p - 1, so p = 2 and dZ = (1, Z_1),
#     the differenced intercept plus one non-degenerate coordinate.
#   r = 21/8 = 2.625 -- essentially the shipped 8/3 = 2.667. THE PROPENSITY IS
#     NO SMOOTHER THAN IN THE SHIPPED DESIGN. This matters: it is what makes the
#     design constructible where (mu, r, d_Z) = (5, 20, 1) is not.
#   mu = 5 -- primitive at (P-a.3) since round 12, not derived from s/(2a).
#     phi_dagger = sin(2 pi x) is analytic, so its coefficients in any smoothing
#     operator's singular system decay faster than every polynomial and it lies
#     in the source ball at every mu; hr_operator_spectrum() MEASURES this on
#     the DGP's own operator instead of asserting it.
#   s = 4, a = 2/5 -- chosen so that mu_H1 = s/(2a) = 5 COINCIDES with the
#     primitive mu, which is the shipped design's own aesthetic (rem:pasrc(4)
#     declines the identity as a bridge; the coincidence is kept because a
#     reader finds it least surprising, not because it is load-bearing).
#     s = 4 sits inside (3.125, 8.5]: above eq:lxwindow's 2.953 AND above the
#     both-routes threshold 1/(2(1-2alpha)) = 3.125, below lem:unifop's
#     s <= p_K + 1/2 = 8.5. A8's spline degree must exceed s - 1/2 = 3.5.
#
# WHAT DESIGN H COSTS, AND IT IS REPORTED RATHER THAN HIDDEN. At alpha = 0.42
# the sieve window (P-c) ^ (P-d) is non-empty ASYMPTOTICALLY (exponents 0.0551
# < 0.16) but EMPTY AT EVERY n ON THIS GRID: at n = 181,019 it is
# (4.18, 0.573). The shipped alpha = 0.32 has it non-empty at the top three
# cells. So Design H moves the infeasibility from the remainder budget to the
# sieve dimension. That is a statement about the phi-STEP's tuning, which the
# limit-law arm does not run: thm:rootn's own hypotheses on the nuisances are
# RATE conditions ((T-4), eq:foldrates, (R-a), (R-e)) and this arm realises them
# by injection, exactly as the shipped arm does (design decision D3). It is
# printed in hr_budget() because a reader must not have to rediscover it.
# ============================================================================

# ---- The configuration -----------------------------------------------------

#' Build a configuration list in the shape sim_thm_rootn_dgp.R's CFG has.
hr_cfg <- function(mu, s, a, d_z, r, tau_dp = 2.5, p_K = 8) {
  cfg <- list(mu = mu, s = s, a = a, d_z = d_z, r = r, tau_dp = tau_dp,
              p_K = p_K)
  cfg$kappa <- 2 * cfg$mu / (2 * cfg$mu + 1)
  cfg$alpha <- cfg$r / (2 * cfg$r + cfg$d_z)
  cfg
}

HR_CFG      <- hr_cfg(mu = 5, s = 4, a = 2 / 5, d_z = 1L, r = 21 / 8)
SHIPPED_CFG <- hr_cfg(mu = 2, s = 3, a = 3 / 4, d_z = 3L, r = 8 / 3)

# ---- A5(i) as written: a MAXIMUM, not its second branch ---------------------

#' delta-hat_n^{(T)}: the parametric branch of A5(i).
hr_dhat_T <- function(n) n^(-0.5) * sqrt(log(n))

#' delta-hat_n^{(varrho)} = r_n: the propensity branch of A5(i) (A4(iii)).
hr_dhat_rho <- function(n, cfg = HR_CFG) n^(-cfg$alpha)

#' A5(i) literally: the max of the two branches. This is what the arm injects.
hr_dhat_max <- function(n, cfg = HR_CFG) pmax(hr_dhat_T(n), hr_dhat_rho(n, cfg))

#' The r_n-only reading -- what sim_thm_rootn_dgp.R implements and what the
#' shipped budget arm tabulates. Kept so the two can be printed side by side.
hr_dhat_exp <- function(n, cfg = HR_CFG) hr_dhat_rho(n, cfg)

#' A5(ii) as amended (eq:deltalog): the ln n is INSIDE the power, applied once.
hr_delta_n <- function(n, cfg = HR_CFG, dhat = hr_dhat_max)
  (dhat(n, cfg) * log(n))^cfg$kappa

# ---- The admissibility ledger ----------------------------------------------

#' Every line of the assumption block's smoothness-budget table, evaluated.
#'
#' Returns one row per condition with the threshold, the realised value and a
#' pass flag, so that "the design satisfies the same assumption set" is a
#' printed check rather than a claim.
hr_admissibility <- function(cfg = HR_CFG, p = 2L, spline_degree = 4L) {
  al <- cfg$alpha; kp <- cfg$kappa; s <- cfg$s; a <- cfg$a; pK <- cfg$p_K
  mk <- function(cond, source, need, have, ok)
    data.frame(condition = cond, source = source, threshold = need,
               realised = have, pass = ok, stringsAsFactors = FALSE)
  rbind(
    mk("Propensity frontier $\\kappa\\alpha>1/4$", "A5(iii), eq:frontier",
       0.25, kp * al, kp * al > 0.25),
    mk("$r>d_Z(2\\mu+1)/(2(2\\mu-1))$", "A5(iii), eq:frontier",
       cfg$d_z * (2 * cfg$mu + 1) / (2 * (2 * cfg$mu - 1)), cfg$r,
       cfg$r > cfg$d_z * (2 * cfg$mu + 1) / (2 * (2 * cfg$mu - 1))),
    mk("Linearisation remainder $\\mu>5/6$", "(P-f), eq:muhalf",
       5 / 6, cfg$mu, cfg$mu > 5 / 6),
    mk("Mild ill-posedness $s>a+1/2$", "H1, plan sec.2.6 scope",
       a + 0.5, s, s > a + 0.5),
    mk("$L_x$ window, rate route", "(P-c)$\\wedge$(P-d), eq:lxwindow",
       al * (1 + 1 / pK) / (1 - 2 * al), s, s > al * (1 + 1 / pK) / (1 - 2 * al)),
    mk("$L_x$ window, both routes", "A8 lower end $\\wedge$ (P-d)",
       1 / (2 * (1 - 2 * al)), s, s > 1 / (2 * (1 - 2 * al))),
    mk("$h_x$ window", "eq:hxwindow, (P-g)",
       0.5 + 16 * al / (8 - 3 * al), s, s > 0.5 + 16 * al / (8 - 3 * al)),
    mk("Kernel order $p_K\\ge s-1/2$", "lem:unifop Step 4",
       s - 0.5, pK, pK >= s - 0.5),
    mk("Spline degree $>s-1/2$", "A8 basis clause",
       s - 0.5, spline_degree, spline_degree > s - 0.5),
    mk("$1\\le d_Z\\le p-1$", "A4(ii)", p - 1, cfg$d_z,
       cfg$d_z >= 1 && cfg$d_z <= p - 1))
}

# ---- The remainder budget, per cell, both readings --------------------------

#' The four Step-4 products and the two admissibility ratios, at one c_delta.
#'
#' @param c_delta the free constant of A5(ii)'s O_P statement (design D4).
#' @param eps_exponent epsilon_n = n^{-eps_exponent}; EPS_EXPONENT of the
#'   shipped file, carried so the two arms price (R-c.2) the same way.
hr_budget <- function(n, cfg = HR_CFG, c_delta = 1, eps_exponent = 0.45) {
  dh_max <- hr_dhat_max(n, cfg)
  dh_exp <- hr_dhat_exp(n, cfg)
  dn_max <- c_delta * (dh_max * log(n))^cfg$kappa
  dn_exp <- c_delta * (dh_exp * log(n))^cfg$kappa
  rn <- hr_dhat_rho(n, cfg)
  en <- n^(-eps_exponent)
  # The sieve window (P-c) ^ (P-d), evaluated at the realised n rather than as
  # an exponent comparison. See the header: this is what Design H pays.
  lx_lo <- n^(cfg$alpha * (1 + 1 / cfg$p_K) / cfg$s)
  lx_hi <- n^(1 - 2 * cfg$alpha) / log(n)
  data.frame(
    n = n, ln_n = log(n), c_delta = c_delta,
    dhat_T = hr_dhat_T(n), dhat_rho = rn,
    dhat_branch = ifelse(hr_dhat_T(n) >= rn, "parametric", "propensity"),
    delta_n = dn_max, delta_n_rn_only = dn_exp,
    b_sq = sqrt(n) * dn_max^2,                     # eq:biasb2 / prp:sharpquad
    b_sq_rn_only = sqrt(n) * dn_exp^2,
    b_rd = sqrt(n) * rn * dn_max,                  # eq:biasb3
    b_de = sqrt(n) * dn_max * en,                  # eq:biasb1 under (R-e.1)
    b_rL = sqrt(n) * rn * en,                      # eq:biasb4 under (R-c.2)
    ratio_quarter = dn_max / n^(-0.25),            # A5(ii) second half
    lx_lo = lx_lo, lx_hi = lx_hi, lx_nonempty = lx_lo < lx_hi,
    stringsAsFactors = FALSE)
}

# ---- d_Z-general replacements for three DGP functions -----------------------
#
# Each replaces a function of sim_thm_rootn_dgp.R that hard-codes d_Z = 3 or
# p = 4. hr_assert_dgp_equivalence() checks that at d_Z = 3 they consume the
# same random numbers in the same order and return identical objects, so the
# generalisation cannot have moved any shipped number.

#' Build a Design-H DGP specification.
#'
#' @param name "HA" (favourable) or "HB" (stress; no assumption violated).
hr_dgp_spec <- function(name = c("HA", "HB")) {
  name <- match.arg(name)
  base <- list(
    name        = name,
    p           = 2L,                       # dZ = (1, Z1); d_Z = 1 = p - 1
    theta       = c(0.30, 1.00),
    c_phi       = 1.00,
    sigma_xi    = 0.80,
    sigma_v     = 0.70,
    varsigma_x  = 1.25,
    rho_uv      = 0.60,
    sigma_e     = 0.70,
    s_mix       = 1.0,
    p_mix       = 0.0,
    eps_varrho  = 0.10,                     # A4(i)
    gamma0      = 0.00,
    gamma       = 0.90,                     # scalar index: d_Z = 1
    a_w         = 1.10,
    sigma_z     = matrix(1.00, 1, 1),
    z_mean      = 0.35
  )
  if (name == "HB") {
    # Stress, all four moves strictly inside the hypotheses -- the same four the
    # shipped DGP-B makes, minus the one that needs d_Z >= 2 (DGP-B raises the
    # correlation of dZ's coordinates; at d_Z = 1 there is no such move, so the
    # near-singularity of J is produced instead by pushing E[Z] away from zero
    # against a small Var(Z), which is A1b(iv)'s own margin).
    base$eps_varrho <- 0.03                 # overlap to the edge of A4(i)
    base$a_w        <- 0.55                 # instrument halved
    base$s_mix      <- 3.00                 # E[dU^4] finite, (R-b) holds
    base$p_mix      <- 0.10
    base$sigma_e    <- 0.55
    base$gamma      <- 2.80                 # index spread: varrho reaches A4(i)
    base$z_mean     <- 1.20
    base$sigma_z    <- matrix(0.36, 1, 1)   # Var(Z1) = 0.36 -> kappa(J) large
    # THE INDEX IS RECENTRED, and the reason is that at d_Z = 1 the two stress
    # dimensions collide. E[Z] far from zero is what makes J near-singular; but
    # varrho_fun's index is gamma0 + gamma z, so a large E[Z] also pushes the
    # propensity to one end of [eps, 1 - eps] and the overlap stress is LOST --
    # at gamma0 = 0 the realised range is [0.28, 0.96] and A4(i)'s bound never
    # binds. gamma0 = -gamma E[Z] centres the index at zero, so E[Z] buys the
    # conditioning stress and gamma buys the overlap stress independently. The
    # realised range is then [0.030, 0.970] against eps_varrho = 0.03.
    base$gamma0     <- -base$gamma * base$z_mean
  }
  base$tau2 <- base$sigma_xi^2 + base$sigma_v^2
  base
}

#' d_Z-general replacement for dgp_draw(). Identical at d_Z = 3.
hr_dgp_draw <- function(n, spec) {
  d_z <- ncol(spec$sigma_z)
  zc <- matrix(rnorm(n * d_z), n, d_z) %*% chol(spec$sigma_z)
  zc <- sweep(zc, 2, spec$z_mean, "+")
  dz <- cbind(1, zc)
  rr <- varrho_fun(zc, spec)
  w  <- as.numeric(runif(n) < rr)
  wt <- w - rr

  xi <- rnorm(n, sd = spec$sigma_xi)
  v1 <- rnorm(n, sd = spec$sigma_v)
  v2 <- rnorm(n, sd = spec$sigma_v)
  sc <- ifelse(runif(n) < spec$p_mix, spec$s_mix, 1)

  x1s <- xi + v1
  x2s <- xi + spec$a_w * w + v2
  x1  <- pnorm(x1s / spec$varsigma_x)
  x2  <- pnorm(x2s / spec$varsigma_x)

  du <- spec$rho_uv * (v2 - v1) + sc * spec$sigma_e * rnorm(n)
  dy <- phi_dagger(x2, spec) - phi_dagger(x1, spec) +
        as.vector(dz %*% spec$theta) + du

  list(n = n, dz = dz, zc = zc, w = w, varrho = rr, wt = wt,
       x1 = x1, x2 = x2, du = du, dy = dy, sc = sc)
}

#' d_Z-general replacement for solve_ell_star(). Identical at d_Z = 3.
#'
#' Only the quadrature draw of zc is generalised; the balancing solve itself --
#' design decision D1, the equation nu_{dZ + Wtilde ell} == 0 of lem:adjoint(iii)
#' -- is the shipped one line for line.
hr_solve_ell_star <- function(spec, Q = 6L, c_u = 1.5, n_x = 401L, n_u = 241L,
                              n_z = 60000L, ridge = 1e-10, seed_z = 90210L) {
  d_z <- ncol(spec$sigma_z)
  xg <- seq(0.002, 0.998, length.out = n_x)
  wx <- rep((xg[2] - xg[1]), n_x)

  s_pts <- if (spec$p_mix > 0) c(1, spec$s_mix) else 1
  s_prb <- if (spec$p_mix > 0) c(1 - spec$p_mix, spec$p_mix) else 1
  sd_du_s <- sqrt(2 * spec$rho_uv^2 * spec$sigma_v^2 + s_pts^2 * spec$sigma_e^2)
  ug <- seq(-6 * max(sd_du_s), 6 * max(sd_du_s), length.out = n_u)
  wu <- rep(ug[2] - ug[1], n_u)

  zc <- with_fixed_seed(seed_z, {
    m <- matrix(rnorm(n_z * d_z), n_z, d_z) %*% chol(spec$sigma_z)
    sweep(m, 2, spec$z_mean, "+")
  })
  rr <- varrho_fun(zc, spec)
  dz <- cbind(1, zc)
  eta <- cbind(1, rr)
  n_r <- ncol(eta)

  pw <- cbind(1 - rr, rr)
  A_wr <- array(0, c(2L, n_r))
  Zbar <- array(0, c(2L, spec$p))
  for (wi in 1:2) {
    w <- wi - 1
    A_wr[wi, ] <- colMeans((w - rr) * eta * pw[, wi])
    Zbar[wi, ] <- colMeans(dz * pw[, wi])
  }

  rhs <- matrix(0, spec$p, n_x)
  for (wi in 1:2) {
    w  <- wi - 1
    d2 <- cond_dens_x_marg(xg, 2, w, spec)
    d1 <- cond_dens_x_marg(xg, 1, w, spec)
    rhs <- rhs + outer(Zbar[wi, ], d2 - d1)
  }

  PhiU <- ell_basis_u(ug, Q, c_u)
  Kmat <- matrix(0, n_x, Q * n_r)
  for (wi in 1:2) {
    w <- wi - 1
    Dw <- matrix(0, n_x, n_u)
    for (k in seq_along(s_pts)) {
      fu_k <- s_prb[k] * dnorm(ug, sd = sd_du_s[k])
      Dw <- Dw + sweep(cond_dens_x(xg, 2, w, s_pts[k], ug, spec) -
                       cond_dens_x(xg, 1, w, s_pts[k], ug, spec), 2, fu_k, "*")
    }
    Gw <- (Dw * matrix(wu, n_x, n_u, byrow = TRUE)) %*% PhiU
    for (ri in seq_len(n_r)) {
      cols <- ((ri - 1) * Q + 1):(ri * Q)
      Kmat[, cols] <- Kmat[, cols] + A_wr[wi, ri] * Gw
    }
  }

  sw <- sqrt(wx)
  Kw <- Kmat * sw
  G  <- crossprod(Kw) + ridge * diag(Q * n_r)
  cf <- matrix(0, spec$p, Q * n_r)
  for (m in seq_len(spec$p)) {
    cf[m, ] <- as.vector(solve(G, crossprod(Kw, -rhs[m, ] * sw)))
  }

  resid <- rhs + cf %*% t(Kmat)
  l2_resid <- sqrt(rowSums(resid^2 * matrix(wx, spec$p, n_x, byrow = TRUE)))
  l2_rhs   <- sqrt(rowSums(rhs^2   * matrix(wx, spec$p, n_x, byrow = TRUE)))

  u_fine <- seq(min(ug), max(ug), length.out = 4001L)
  Pf <- ell_basis_u(u_fine, Q, c_u)
  du_f <- u_fine[2] - u_fine[1]
  Af <- apply(Pf, 2, function(cc) {
    ci <- cumsum(cc) * du_f
    ci - approx(u_fine, ci, xout = 0)$y
  })
  anti_fun <- lapply(seq_len(Q), function(q)
    stats::splinefun(u_fine, Af[, q], method = "natural"))

  structure(list(coef = cf, Q = Q, c_u = c_u, n_modes = n_r,
                 l2_resid = l2_resid, l2_rhs = l2_rhs,
                 rel_resid = l2_resid / pmax(l2_rhs, 1e-12),
                 anti_fun = anti_fun, u_range = range(ug)),
            class = "ell_star")
}

#' d_Z-general replacement for draw_rhat(). Identical at d_Z = 3.
hr_draw_rhat <- function(target_l2, zc, spec) {
  d_z <- ncol(zc)
  b  <- rnorm(1L + d_z)
  g  <- b[1] + zc %*% b[-1]
  g  <- g / sqrt(mean(g^2)) * target_l2
  rh <- varrho_fun(zc, spec) + as.vector(g)
  pmin(pmax(rh, spec$eps_varrho), 1 - spec$eps_varrho)
}

#' Prove the three replacements are generalisations and not rewrites.
#'
#' At the shipped spec each must consume the same random numbers in the same
#' order and return an identical() object. Called by the runnable arm BEFORE the
#' single set.seed(), under with_fixed_seed(), so the Monte Carlo stream is
#' untouched.
hr_assert_dgp_equivalence <- function(shipped_draw, shipped_solve,
                                      shipped_rhat) {
  sp <- dgp_spec("A")
  d_ship <- with_fixed_seed(4242L, shipped_draw(97L, sp))
  d_gen  <- with_fixed_seed(4242L, hr_dgp_draw(97L, sp))
  stopifnot(identical(d_ship, d_gen))

  e_ship <- shipped_solve(sp, n_x = 121L, n_u = 81L, n_z = 4000L)
  e_gen  <- hr_solve_ell_star(sp, n_x = 121L, n_u = 81L, n_z = 4000L)
  stopifnot(isTRUE(all.equal(e_ship$coef, e_gen$coef, tolerance = 0)))

  r_ship <- with_fixed_seed(909L, shipped_rhat(0.05, d_ship$zc, sp))
  r_gen  <- with_fixed_seed(909L, hr_draw_rhat(0.05, d_ship$zc, sp))
  stopifnot(identical(r_ship, r_gen))
  invisible(TRUE)
}

# ---- The source condition, measured rather than assumed ---------------------

#' Singular spectrum of the DGP's own conditional operator, and the source
#' radius at a given mu.
#'
#' WHAT THIS IS. In this DGP dZ is independent of (X_1, X_2, dU) given W, so the
#' informative direction of the conditional operator is the RESIDUAL index u:
#' the map
#'     phi  |-->  (u, w) |-> E[ phi(X_2) - phi(X_1) | dU = u, W = w ] f(u, w)
#' has infinite rank in u, while the (t, dZ) direction contributes only through
#' W's two cells. The kernel is the closed-form conditional density
#' cond_dens_x() that solve_ell_star() already uses, so nothing is invented
#' here: the operator is discretised on the same x- and u-grids, weighted by
#' Lebesgue on x (pi = Uniform, design D7) and by the law of (dU, W) on the
#' range, and its singular system is read off an SVD.
#'
#' WHAT IT IS NOT, stated so the number is not over-read. This is the POPULATION
#' operator on the (u, w) index, NOT the finite-rank sieve compression at the
#' random anchor theta_circ that (P-a.3) states the source condition at, and the
#' radius is computed over the NUMERICALLY RESOLVABLE spectrum only, so it is a
#' lower bound on the true radius. What it can settle is the question actually
#' at issue -- whether phi_dagger's energy sits in directions the operator
#' damps polynomially, in which case a source condition of ANY index holds, or
#' whether it leaks into the tail, in which case mu = 5 would not be available.
#'
#' @return list with the fitted power-law and exponential decay of sigma_j, the
#'   resolvable count, and R_star(mu) for each mu requested.
hr_operator_spectrum <- function(spec, mu_grid = c(2, 5), n_x = 301L,
                                 n_u = 241L, rel_floor = 1e-10) {
  xg <- seq(0.002, 0.998, length.out = n_x)
  wx <- xg[2] - xg[1]
  s_pts <- if (spec$p_mix > 0) c(1, spec$s_mix) else 1
  s_prb <- if (spec$p_mix > 0) c(1 - spec$p_mix, spec$p_mix) else 1
  sd_du_s <- sqrt(2 * spec$rho_uv^2 * spec$sigma_v^2 + s_pts^2 * spec$sigma_e^2)
  ug <- seq(-6 * max(sd_du_s), 6 * max(sd_du_s), length.out = n_u)
  wu <- ug[2] - ug[1]

  # P(W = w) and, inside each cell, the conditional density of X_j given
  # (W, S, dU) integrated against the S-mixture -- the operator kernel.
  zc <- with_fixed_seed(515L, {
    m <- matrix(rnorm(4e5L * ncol(spec$sigma_z)), 4e5L, ncol(spec$sigma_z)) %*%
      chol(spec$sigma_z)
    sweep(m, 2, spec$z_mean, "+")
  })
  rr <- varrho_fun(zc, spec)
  pW <- c(mean(1 - rr), mean(rr))

  blocks <- vector("list", 2L)                                   # INV-17
  for (wi in 1:2) {
    w <- wi - 1
    Dw <- matrix(0, n_x, n_u)
    for (k in seq_along(s_pts)) {
      fu_k <- s_prb[k] * dnorm(ug, sd = sd_du_s[k])
      Dw <- Dw + sweep(cond_dens_x(xg, 2, w, s_pts[k], ug, spec) -
                       cond_dens_x(xg, 1, w, s_pts[k], ug, spec), 2, fu_k, "*")
    }
    # Range-side L2 weights: sqrt(du * P(W = w)); domain-side: sqrt(dx).
    blocks[[wi]] <- t(Dw) * sqrt(wu * pW[wi]) * sqrt(wx)
  }
  A <- do.call(rbind, blocks)                                    # (2 n_u) x n_x

  sv <- svd(A)
  sig <- sv$d
  keep <- sig > max(sig) * rel_floor
  jj <- seq_along(sig)[keep]
  sg <- sig[keep]
  fit_pow <- stats::lm(log(sg) ~ log(jj))
  fit_exp <- stats::lm(log(sg) ~ jj)

  # phi_dagger in the domain orthonormal basis induced by the sqrt(dx) weights.
  phi_w <- phi_dagger(xg, spec) * sqrt(wx)
  cph <- as.vector(crossprod(sv$v, phi_w))
  captured <- sum(cph^2) / sum(phi_w^2)

  r_star <- vapply(mu_grid, function(mu) {
    sqrt(sum((cph[keep] / sig[keep]^(2 * mu))^2))
  }, numeric(1))
  # Where phi_dagger's energy sits: index of the last direction holding more
  # than 1e-6 of it. A source condition at any mu needs this to be early.
  cum <- cumsum(cph^2) / sum(cph^2)
  j_999 <- which(cum >= 1 - 1e-6)[1]

  list(sigma = sig, n_resolvable = sum(keep),
       a_pow = unname(-stats::coef(fit_pow)[2]),
       r2_pow = summary(fit_pow)$r.squared,
       a_exp = unname(-stats::coef(fit_exp)[2]),
       r2_exp = summary(fit_exp)$r.squared,
       phi_captured = captured, j_energy_1e6 = j_999,
       mu_grid = mu_grid, R_star = r_star,
       phi_Hs_norm4 = sqrt(sum((2 * pi)^(2 * (0:4)) / 2)))
}

# ---- Lifting the estimator out of the shipped arm --------------------------

#' Evaluate ONLY the named top-level assignments of a script.
#'
#' sim_thm_rootn_limitlaw.R defines one_rep_full() and run_cell() at top level
#' and then RUNS the 5.5-hour arm, so it cannot be source()d. Parsing it and
#' evaluating only those two assignments gives the shipped replication path
#' byte for byte, with no copy to drift out of date and no edit to the shipped
#' file. The returned environment's parent is the caller's, so the lifted
#' functions resolve CFG, THETA_MIX, N_CORES and the rate symbols against
#' whatever the caller has bound -- which is how the configuration is switched.
#'
#' @return the environment holding the lifted objects.
hr_lift_defs <- function(path, names, parent = parent.frame()) {
  exprs <- as.list(parse(path))
  env <- new.env(parent = parent)
  got <- character(0)
  for (e in exprs) {
    if (is.call(e) && length(e) >= 3L &&
        as.character(e[[1]]) %in% c("<-", "=") && is.name(e[[2]]) &&
        as.character(e[[2]]) %in% names) {
      eval(e, envir = env)
      got <- c(got, as.character(e[[2]]))
    }
  }
  missing <- setdiff(names, got)
  if (length(missing)) {
    stop("could not lift from ", basename(path), ": ",
         paste(missing, collapse = ", "))
  }
  env
}
