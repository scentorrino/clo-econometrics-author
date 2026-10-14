# ============================================================================
# sim_thm_rootn_jacobian.R   --   PRIORITY 2
#
# THE JACOBIAN SIGN, MECHANISED.
#
# def:onestep asserts the identity
#       d/dtheta bar-psi_n(theta) = - J-hat(theta)          identically,
# with J-hat of eq:Jhat, and therefore puts a PLUS sign on J-hat^{-1} in
#       theta-hat = theta-hat^(0) + J-hat^{-1} bar-psi_n(theta-hat^(0)),
# and J^{-1} -- not -J^{-1} -- in the limit law of eq:rootn.
#
# A sign error here is invisible in the limit law, because N(0, J^{-1} Sigma
# J^{-1'}) = N(0, (-J^{-1}) Sigma (-J^{-1})'), and fatal in a simulation,
# because the one-step then moves AWAY from the truth. This script checks the
# sign three ways, none of which relies on the limit law:
#
#   (T1) FINITE DIFFERENCES. The full p x p matrix d/dtheta bar-psi_n(theta) is
#        computed by central differences on a real sample and compared with
#        -J-hat(theta), coordinatewise, at several theta and several step sizes.
#   (T2) DIRECTION OF THE ONE-STEP. Starting from a preliminary deliberately
#        displaced from the truth, the one-step with +J-hat^{-1} must contract
#        the displacement; the counterfactual with -J-hat^{-1} must expand it.
#        The contraction factor is reported for both.
#   (T3) THE SIGN OF J ITSELF. The population J is not E[dZ dZ'] -- def:moment
#        says so in italics -- and its second summand E[Wtilde ell_star dZ'] is
#        in general not symmetric. Both facts are checked numerically, since a
#        implementation that silently symmetrises J would pass (T1) and (T2)
#        and still be wrong.
#
# Outputs
#   paper/tables/sim/sim_thm_rootn_jacobian.tex   (bare tabular, INV-13)
#   quality_reports/sim/sim_thm_rootn_jacobian.rds
# ============================================================================

library(here)
library(data.table)

source(here::here("scripts", "simulations", "sim_thm_rootn_dgp.R"))
source(here::here("scripts", "simulations", "sim_thm_rootn_nuisance.R"))

set.seed(20260731L)                                            # INV-14

N_CHECK  <- 20000L
N_DRAWS  <- 200L
STEPS    <- c(1e-3, 1e-4, 1e-5)
DISPLACE <- c(0.25, 1.00)

SPECS <- list(A = dgp_spec("A"), B = dgp_spec("B"))
ES    <- lapply(SPECS, solve_ell_star)
POP   <- Map(function(s, e) pop_J_Sigma(s, e, n_pilot = 2e6L), SPECS, ES)
PERT  <- Map(function(s, e) ell_pert_norms(s, e), SPECS, ES)

#' Build one sample with cross-fitted nuisances, and return closures that
#' evaluate bar-psi_n(theta) and J-hat(theta) at any theta.
build_sample <- function(n, spec, es, pert_norms, c_delta = 1, c_eps = 1,
                         c_r = 1) {
  p <- spec$p
  d <- dgp_draw(n, spec)
  fold <- rep_len(1:2, n)
  nz <- vector("list", 2)
  dphi_hat <- numeric(n); wt_hat <- numeric(n)
  for (k in 1:2) {
    idx <- which(fold == k)
    hh  <- draw_h(c_delta * rate_delta_n(n), mode = "smooth")
    dcf <- draw_dell(c_eps * rate_eps_n(n), spec, es, pert_norms)
    zc_k <- d$zc[idx, , drop = FALSE]
    rh   <- draw_rhat(c_r * rate_rn(n), zc_k, spec)
    nz[[k]] <- list(idx = idx, dcf = dcf, zc = zc_k)
    dphi_hat[idx] <- phi_dagger(d$x2[idx], spec) - phi_dagger(d$x1[idx], spec) +
                     eval_h(hh, d$x2[idx]) - eval_h(hh, d$x1[idx])
    wt_hat[idx] <- d$w[idx] - rh
  }
  bar_psi <- function(theta) {
    acc <- numeric(p)
    for (k in 1:2) {
      z <- nz[[k]]; idx <- z$idx
      du <- d$dy[idx] - dphi_hat[idx] - as.vector(d$dz[idx, , drop = FALSE] %*% theta)
      L  <- L_star_eval(es, du, z$zc, spec) + eval_dL(z$dcf, du, z$zc, spec, es)
      acc <- acc + colSums(d$dz[idx, , drop = FALSE] * du + wt_hat[idx] * L)
    }
    acc / n
  }
  J_hat <- function(theta) {
    M <- crossprod(d$dz) / n
    for (k in 1:2) {
      z <- nz[[k]]; idx <- z$idx
      du <- d$dy[idx] - dphi_hat[idx] - as.vector(d$dz[idx, , drop = FALSE] %*% theta)
      e  <- ell_star_eval(es, du, z$zc, spec) + eval_dell(z$dcf, du, z$zc, spec, es)
      M  <- M + crossprod(wt_hat[idx] * e, d$dz[idx, , drop = FALSE]) / n
    }
    M
  }
  list(d = d, bar_psi = bar_psi, J_hat = J_hat, dphi_hat = dphi_hat, p = p)
}

# ---- (T1) finite-difference check -----------------------------------------

t1 <- rbindlist(lapply(names(SPECS), function(nm) {
  spec <- SPECS[[nm]]; es <- ES[[nm]]; p <- spec$p
  rbindlist(lapply(seq_len(20L), function(rep_i) {
    S <- build_sample(N_CHECK, spec, es, PERT[[nm]])
    rbindlist(lapply(c(0, 0.5), function(off) {
      th <- spec$theta + off * c(0.3, -0.2, 0.15, -0.1)
      Jh <- S$J_hat(th)
      rbindlist(lapply(STEPS, function(hstep) {
        num <- matrix(0, p, p)
        for (m in seq_len(p)) {
          ep <- numeric(p); ep[m] <- hstep
          num[, m] <- (S$bar_psi(th + ep) - S$bar_psi(th - ep)) / (2 * hstep)
        }
        data.table(dgp = nm, offset = off, step = hstep,
                   max_abs_gap  = max(abs(num - (-Jh))),
                   max_rel_gap  = max(abs(num - (-Jh))) / max(abs(Jh)),
                   gap_if_plus  = max(abs(num - Jh)) / max(abs(Jh)),
                   sign_agree   = mean(sign(num) == sign(-Jh)))
      }))
    }))
  }))
}))
t1s <- t1[, .(max_rel_gap = max(max_rel_gap), med_rel_gap = median(max_rel_gap),
              gap_if_plus = min(gap_if_plus), sign_agree = min(sign_agree)),
          by = .(dgp, offset, step)]

# ---- (T2) direction of the one-step ----------------------------------------

t2 <- rbindlist(lapply(names(SPECS), function(nm) {
  spec <- SPECS[[nm]]; es <- ES[[nm]]; p <- spec$p
  rbindlist(lapply(DISPLACE, function(disp) {
    dd <- disp * c(0.4, -0.3, 0.25, -0.2)
    res <- vapply(seq_len(N_DRAWS), function(b) {
      S  <- build_sample(4000L, spec, es, PERT[[nm]])
      th0 <- spec$theta + dd
      Jh  <- S$J_hat(th0)
      bp  <- S$bar_psi(th0)
      th_plus  <- th0 + as.vector(solve(Jh, bp))               # def:onestep
      th_minus <- th0 - as.vector(solve(Jh, bp))               # wrong sign
      c(sqrt(sum((th_plus  - spec$theta)^2)) / sqrt(sum(dd^2)),
        sqrt(sum((th_minus - spec$theta)^2)) / sqrt(sum(dd^2)))
    }, numeric(2))
    data.table(dgp = nm, displacement = sqrt(sum(dd^2)),
               contraction_plus  = mean(res[1, ]),
               contraction_plus_se = sd(res[1, ]) / sqrt(N_DRAWS),
               contraction_minus = mean(res[2, ]),
               contraction_minus_se = sd(res[2, ]) / sqrt(N_DRAWS))
  }))
}))

# ---- (T3) the second summand of J, measured directly -----------------------
#
# ROUND-3 CORRECTION TO THIS COMMENT'S PREMISE. It previously cited def:moment's
# claim that "J is the matrix of A3 and it IS NOT E[dZ dZ']". A3 (ass:rank) is
# RETIRED -- dispatch 13, retired BECAUSE IT IS A THEOREM: lem:momzero(iv) proves
# the second summand vanishes under A1, so J = E[dZ dZ'] and its nonsingularity
# is A1b(iv). The retirement note also withdraws, in terms, "the further claim
# ... that the two are DIFFERENT matrices". So the premise is withdrawn while the
# measurement below, and its conclusion, are exactly what lem:momzero(iv) asserts
# -- this arm now reports it as a CHECK OF A PROVED IDENTITY rather than as a
# check of an assumption. The second summand is E[Wtilde ell_star dZ']. Under A1 --
# dU || W | dZ, which is (T-1) and maintained throughout Part I --
#     E[ Wtilde ell(dU, dZ) | dZ ] = E[Wtilde | dZ] E[ ell(dU, dZ) | dZ ] = 0
# for EVERY ell, since E[Wtilde | dZ] = 0 by construction of varrho. So the
# second summand is identically zero and J = E[dZ dZ'] exactly.
#
# This is measured rather than asserted: the summand is averaged on the SAME
# draws (not differenced across two independent pilots), so its Monte Carlo
# standard error is small and clean, and each entry can be read against it.
# The same conditional-independence argument kills the cross term of Sigma, so
# Sigma = E[dZ dZ' dU^2] + E[Wtilde^2 L_star L_star'] with no cross term: the
# debiasing weight adds variance and does not move J.

t3 <- rbindlist(lapply(names(SPECS), function(nm) {
  spec <- SPECS[[nm]]; es <- ES[[nm]]; pop <- POP[[nm]]
  sd_j <- 4242L + which(names(SPECS) == nm)
  n_p <- 2e6L; chunk <- 5e5L
  p <- spec$p
  S2 <- matrix(0, p, p); S2sq <- matrix(0, p, p)
  Gzz <- matrix(0, p, p)
  Xc <- matrix(0, p, p)                        # cross term of Sigma
  done <- 0L
  while (done < n_p) {
    m <- min(chunk, n_p - done)
    d <- with_fixed_seed(sd_j + done, dgp_draw(m, spec))
    ell <- ell_star_eval(es, d$du, d$zc, spec)
    Ls  <- L_star_eval(es, d$du, d$zc, spec)
    S2   <- S2   + crossprod(d$wt * ell, d$dz)
    S2sq <- S2sq + crossprod((d$wt * ell)^2, d$dz^2)
    Gzz  <- Gzz  + crossprod(d$dz)
    Xc   <- Xc   + crossprod(d$dz * d$du, d$wt * Ls)
    done <- done + m
  }
  S2 <- S2 / n_p; Gzz <- Gzz / n_p; Xc <- Xc / n_p
  S2_se <- sqrt(pmax(S2sq / n_p - S2^2, 0) / n_p)
  data.table(dgp = nm,
             max_abs_J        = max(abs(pop$J)),
             max_abs_summand2 = max(abs(S2)),
             max_summand2_se  = max(S2_se),
             summand2_t       = max(abs(S2 / pmax(S2_se, 1e-12))),
             max_abs_crossSig = max(abs(Xc)),
             asymmetry        = max(abs(pop$J - t(pop$J))),
             asymmetry_se     = max(pop$J_se) * sqrt(2),
             kappa_J          = kappa(pop$J))
}))

# ---- (T4) the asymptotic variance depends on the FREE anchor ---------------
#
# A2'(iii) fixes L_star = L^{b_star}_{ell_star} for SOME b_star with
# E||b_star||^2 < infinity, and rem:anchor says in terms that the anchor "is a
# FREE DESIGN OBJECT". Since Sigma = E[psi_star psi_star'] and psi_star carries
# Wtilde L_star, V = J^{-1} Sigma J^{-1'} can move with b_star while J cannot.
# Two admissible anchors are compared -- the zero anchor (design decision D2)
# and the N1 anchor of rem:anchor -- together with the counterfactual that drops
# the debiasing term from psi entirely. The last column is the price of
# debiasing in asymptotic standard deviation, which is what buys insensitivity
# to the first-order error in phi-hat.

t4 <- rbindlist(lapply(names(SPECS), function(nm) {
  spec <- SPECS[[nm]]; es <- ES[[nm]]; pop <- POP[[nm]]
  d <- with_fixed_seed(5150L + which(names(SPECS) == nm), dgp_draw(1.5e6L, spec))
  L0 <- L_star_eval(es, d$du, d$zc, spec)                     # zero anchor
  # N1 anchor: b(z) = -E[ int_0^{dU} ell(v, z) dv | dZ = z ]. Estimated by a
  # local average over a fine grid of the propensity index, which is the only
  # z-dependence L_star has in this design.
  idx  <- varrho_fun(d$zc, spec)
  brk  <- stats::quantile(idx, seq(0, 1, length.out = 201L))
  cell <- cut(idx, unique(brk), include.lowest = TRUE, labels = FALSE)
  bhat <- apply(L0, 2, function(cc) ave(cc, cell, FUN = mean))
  L1 <- L0 - bhat                                             # N1 anchor
  # WHY PANEL D RETURNS A NULL (added in round 2; the critic is right that the
  # round-1 summary was silent about a ratio of 1.000). The N1 anchor subtracts
  # b(z) = E[L_star | dZ = z]. If that conditional mean is itself ~0, the two
  # admissible anchors COINCIDE and the arm cannot detect any anchor-sensitivity
  # of V -- which is a fact about this design, not a confirmation that
  # rem:anchor's free anchor leaves V invariant. The size of b-hat relative to
  # L_star is therefore measured and reported alongside the ratio.
  b_rel <- max(abs(bhat)) / max(abs(L0))
  b_rms <- sqrt(mean(bhat^2)) / sqrt(mean(L0^2))
  psi0 <- d$dz * d$du + d$wt * L0
  psi1 <- d$dz * d$du + d$wt * L1
  S0 <- crossprod(psi0) / nrow(psi0); S1 <- crossprod(psi1) / nrow(psi1)
  Ji <- pop$Jinv
  V0 <- Ji %*% S0 %*% t(Ji); V1 <- Ji %*% S1 %*% t(Ji)
  Vpl <- Ji %*% (crossprod(d$dz * d$du) / nrow(d$dz)) %*% t(Ji)
  data.table(dgp = nm,
             sd_zero = sqrt(V0[2, 2]), sd_n1 = sqrt(V1[2, 2]),
             sd_nodebias = sqrt(Vpl[2, 2]),
             ratio_anchor = sqrt(V1[2, 2] / V0[2, 2]),
             ratio_debias = sqrt(V0[2, 2] / Vpl[2, 2]),
             b_rel = b_rel, b_rms = b_rms)
}))

saveRDS(list(t1 = t1, t1s = t1s, t2 = t2, t3 = t3, t4 = t4),
        here::here("quality_reports", "sim", "sim_thm_rootn_jacobian.rds"))

# ---- Table -----------------------------------------------------------------

fmt <- function(x, d = 3) formatC(x, format = "f", digits = d)
sci <- function(x, d = 2) formatC(x, format = "e", digits = d)

# INV-17: all four panel bodies built by vectorised sprintf, assembled once.
writeLines(c(
  "\\begin{tabular}{llrrrr}",
  "\\toprule",
  # \eqref, not the bare label: eq:Jhat is set in results_s3_estimation.tex,
  # which BOTH main.qmd and supplement.qmd input, so the reference resolves in
  # either host and does not need the by-name cross-document form.
  "\\multicolumn{6}{l}{\\textit{Panel A: finite-difference check of $\\partial_\\theta\\bar\\psi_n=-\\hat J$ of \\eqref{eq:Jhat}}} \\\\",
  "\\midrule",
  "DGP & $\\theta$ & Step & Max rel.\\ gap to $-\\hat J$ & Min rel.\\ gap to $+\\hat J$ & Sign agreement \\\\",
  "\\midrule",
  sprintf("%s & %s & %s & %s & %s & %s \\\\",
          t1s$dgp, ifelse(t1s$offset == 0, "$\\theta_\\dagger$", "displaced"),
          sci(t1s$step, 0), sci(t1s$max_rel_gap, 1), fmt(t1s$gap_if_plus, 3),
          fmt(t1s$sign_agree, 3)),
  "\\addlinespace",
  "\\multicolumn{6}{l}{\\textit{Panel B: direction of the one-step, $\\|\\hat\\theta-\\theta_\\dagger\\|/\\|\\hat\\theta^{(0)}-\\theta_\\dagger\\|$}} \\\\",
  "\\midrule",
  "DGP & Displacement & & $+\\hat J^{-1}$ (MC SE) & $-\\hat J^{-1}$ (MC SE) & \\\\",
  "\\midrule",
  sprintf("%s & %s & & %s (%s) & %s (%s) & \\\\",
          t2$dgp, fmt(t2$displacement, 2), fmt(t2$contraction_plus, 4),
          fmt(t2$contraction_plus_se, 4), fmt(t2$contraction_minus, 3),
          fmt(t2$contraction_minus_se, 3)),
  "\\addlinespace",
  "\\multicolumn{6}{l}{\\textit{Panel C: the second summand of $J$, $E[\\widetilde W\\ell_\\star\\Delta Z']$, measured directly}} \\\\",
  "\\midrule",
  "DGP & $\\max|J|$ & $\\max|E[\\widetilde W\\ell_\\star\\Delta Z']|$ & MC SE & $\\max|t|$ & $\\|J-J'\\|_\\infty$ \\\\",
  "\\midrule",
  sprintf("%s & %s & %s & %s & %s & %s \\\\",
          t3$dgp, fmt(t3$max_abs_J, 3), sci(t3$max_abs_summand2, 2),
          sci(t3$max_summand2_se, 2), fmt(t3$summand2_t, 2),
          sci(t3$asymmetry, 2)),
  "\\addlinespace",
  "\\multicolumn{6}{l}{\\textit{Panel D: the asymptotic sd of $\\hat\\theta_2$ under two admissible anchors}} \\\\",
  "\\midrule",
  "DGP & Zero anchor & N1 anchor & N1 / zero & $\\|\\hat b\\|/\\|L_\\star\\|$ (rms) & Zero / no debias. \\\\",
  "\\midrule",
  sprintf("%s & %s & %s & %s & %s & %s \\\\",
          t4$dgp, fmt(t4$sd_zero, 4), fmt(t4$sd_n1, 4),
          fmt(t4$ratio_anchor, 4), sci(t4$b_rms, 1), fmt(t4$ratio_debias, 3)),
  "\\bottomrule", "\\end{tabular}"),
  here::here("paper", "tables", "sim", "sim_thm_rootn_jacobian.tex"))

message("done: Jacobian-sign arm")
print(t1s); print(t2); print(t3); print(t4)
