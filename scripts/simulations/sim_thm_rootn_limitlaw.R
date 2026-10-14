# ============================================================================
# sim_thm_rootn_limitlaw.R   --   PRIORITY 1
#
# Monte Carlo verification of the limit law of thm:rootn:
#
#   sqrt(n)(theta-hat - theta_dagger)
#      = J^{-1} n^{-1/2} sum_i psi_star(O_i) + o_P(1)
#      -> N(0, J^{-1} Sigma J^{-1'}),        and  V-hat -> J^{-1} Sigma J^{-1'}
#
# with J = E[dZ dZ'] + E[Wtilde ell_star dZ'] and Sigma = E[psi_star psi_star']
# both computed in the population, not estimated from the theory.
#
# Four things are measured, in increasing sharpness:
#   (1) coverage of nominal 90 / 95 per cent Wald intervals built on V-hat;
#   (2) quantiles of the studentised statistic against N(0,1);
#   (3) consistency of V-hat for V (lem:sandwich(ii)) and of J-hat for J
#       (lem:sandwich(i));
#   (4) the LINEARISATION RESIDUAL
#          sqrt(n)(theta-hat - theta_dagger) - J^{-1} sqrt(n) E_n[psi_star],
#       which eq:rootn asserts is o_P(1). This is the sharpest of the four
#       because it differences out the central-limit noise that (1)-(3) share
#       with the oracle; it is the statistic that isolates Step 6 of the proof.
#
# Outputs
#   paper/tables/sim/sim_thm_rootn_limitlaw.tex      (bare tabular, INV-13)
#   paper/tables/sim/sim_thm_rootn_quantiles.tex     (bare tabular)
#   paper/tables/sim/sim_thm_rootn_ablation.tex      (bare tabular)
#   paper/figures/sim/sim_thm_rootn_qq.pdf           (no in-figure title, INV-12)
#   paper/figures/sim/sim_thm_rootn_linresid.pdf
#   quality_reports/sim/sim_thm_rootn_limitlaw.rds   (raw cell summaries)
# ============================================================================

library(here)
library(data.table)
library(ggplot2)
library(parallel)

source(here::here("scripts", "simulations", "sim_thm_rootn_dgp.R"))
source(here::here("scripts", "simulations", "sim_thm_rootn_nuisance.R"))

RNGkind("L'Ecuyer-CMRG")
set.seed(20260730L)                                            # INV-14

N_CORES  <- SIM_CORES              # fixed constant, see sim_thm_rootn_dgp.R
N_GRID   <- c(125L, 354L, 1000L, 2828L, 8000L, 22627L, 64000L, 181019L)

# ROUND-2 FIX (critic finding B3). The round-1 design halved B from 5000 to 2000
# above n = 22,627 -- which is to say, exactly at the two cells where the verdict
# was pronounced. That inflated the sd-ratio MC SE from 0.010 to 0.016 there and
# nowhere else, so the largest-n cells cleared a 2-SE bar partly because their
# bar had been widened. On the round-1 numbers the sd ratio at n = 181,019 would
# have been 2.2 SE -- a fail on the engineer's own bar -- had B been held at 5000.
# B is now CONSTANT ACROSS THE WHOLE GRID, so precision does not vary with n and
# no cell's verdict depends on its own noise floor. Cost: ~85 minutes.
B_ALL    <- 5000L
ALPHA_LV <- c(0.10, 0.05)
Q_PROBS  <- c(0.025, 0.05, 0.25, 0.50, 0.75, 0.95, 0.975)
THETA_MIX <- c(0.5, 0.5, 0.5, 0.5)                             # ||.|| = 1

reps_for <- function(n) B_ALL

# ---- One replication -------------------------------------------------------

#' Full replication -- keeps the nuisance coefficient draws so that psi and
#' J-hat can be re-evaluated at any theta, as eq:barpsi and eq:Jhat require.
one_rep_full <- function(n, spec, es, pop, pert_norms, c_delta, c_eps, c_r,
                         h_mode, h_bias = 0) {
  p <- spec$p
  d <- dgp_draw(n, spec)
  fold <- rep_len(1:2, n)

  tgt_h <- c_delta * rate_delta_n(n)
  tgt_e <- c_eps   * rate_eps_n(n)
  tgt_r <- c_r     * rate_rn(n)

  nz <- vector("list", 2)
  dphi_hat <- numeric(n); wt_hat <- numeric(n)
  h_hs <- numeric(2); d_l2 <- numeric(2); r_l2 <- numeric(2); D_l2 <- numeric(2)

  for (k in 1:2) {
    idx <- which(fold == k)
    hh  <- draw_h(tgt_h, mode = h_mode, bias_frac = h_bias)
    dcf <- if (c_eps > 0) draw_dell(tgt_e, spec, es, pert_norms) else
           matrix(0, es$Q * es$n_modes, p)
    zc_k <- d$zc[idx, , drop = FALSE]
    rh   <- if (c_r > 0) draw_rhat(tgt_r, zc_k, spec) else d$varrho[idx]
    nz[[k]] <- list(idx = idx, hh = hh, dcf = dcf, rh = rh, zc = zc_k)
    h_hs[k] <- hh$hs_norm
    r_l2[k] <- sqrt(mean((rh - d$varrho[idx])^2))
    dphi_hat[idx] <- phi_dagger(d$x2[idx], spec) - phi_dagger(d$x1[idx], spec) +
                     eval_h(hh, d$x2[idx]) - eval_h(hh, d$x1[idx])
    wt_hat[idx] <- d$w[idx] - rh
  }

  #' psi(theta, zeta-hat) and the ell-hat block, evaluated at an arbitrary theta.
  psi_at <- function(theta) {
    psi <- matrix(0, n, p); ell <- matrix(0, n, p)
    for (k in 1:2) {
      z <- nz[[k]]; idx <- z$idx
      du <- d$dy[idx] - dphi_hat[idx] - as.vector(d$dz[idx, , drop = FALSE] %*% theta)
      e_k <- ell_star_eval(es, du, z$zc, spec) + eval_dell(z$dcf, du, z$zc, spec, es)
      L_k <- L_star_eval(es, du, z$zc, spec)   + eval_dL(z$dcf, du, z$zc, spec, es)
      psi[idx, ] <- d$dz[idx, , drop = FALSE] * du + wt_hat[idx] * L_k
      ell[idx, ] <- e_k
    }
    list(psi = psi, ell = ell)
  }

  # Preliminary (eq:prelimtheta) and its rate.
  Gzz <- crossprod(d$dz) / n
  th0 <- solve(Gzz, colMeans(d$dz * (d$dy - dphi_hat)))

  # J-hat at theta-hat^(0) (eq:Jhat) and the one-step (eq:onestep).
  A0   <- psi_at(th0)
  Jhat <- Gzz + crossprod(wt_hat * A0$ell, d$dz) / n
  bpsi <- colMeans(A0$psi)
  Jinv_hat <- tryCatch(solve(Jhat), error = function(e) NULL)
  if (is.null(Jinv_hat)) return(rep(NA_real_, 6L * p + 13L))
  th1 <- th0 + as.vector(Jinv_hat %*% bpsi)                    # eq:onestep

  # Variance estimator (eq:Sighat) at theta-hat.
  A1  <- psi_at(th1)
  Sig <- crossprod(A1$psi) / n
  Vh  <- Jinv_hat %*% Sig %*% t(Jinv_hat)

  # Oracle influence function at the TRUE nuisances and the POPULATION J.
  ell_t <- ell_star_eval(es, d$du, d$zc, spec)
  L_t   <- L_star_eval(es, d$du, d$zc, spec)
  psi_t <- d$dz * d$du + d$wt * L_t
  if_n  <- as.vector(pop$Jinv %*% colMeans(psi_t)) * sqrt(n)

  # Nuisance-error diagnostics at theta_dagger (the products of Step 4).
  for (k in 1:2) {
    z <- nz[[k]]; idx <- z$idx
    du <- d$dy[idx] - dphi_hat[idx] - as.vector(d$dz[idx, , drop = FALSE] %*% spec$theta)
    if (c_eps > 0) {
      d_l2[k] <- sqrt(mean(rowSums(eval_dell(z$dcf, du, z$zc, spec, es)^2)))
      D_l2[k] <- sqrt(mean(rowSums(eval_dL(z$dcf, du, z$zc, spec, es)^2)))
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
    sqrt(n) * mean(r_l2) * mean(D_l2))
}

# ---- Cell driver -----------------------------------------------------------

run_cell <- function(n, spec, es, pop, pert_norms, c_delta, c_eps, c_r, h_mode,
                     B, h_bias = 0) {
  p <- spec$p
  res <- parallel::mclapply(seq_len(B), function(b) {
    one_rep_full(n, spec, es, pop, pert_norms, c_delta, c_eps, c_r, h_mode,
                 h_bias)
  }, mc.cores = N_CORES, mc.preschedule = TRUE)
  M <- do.call(rbind, res)
  M <- M[stats::complete.cases(M), , drop = FALSE]

  sd_mix <- sqrt(as.numeric(t(THETA_MIX) %*% pop$V %*% THETA_MIX))
  mixed  <- M[, 6 * p + 1]
  t_mix  <- mixed / sqrt(pmax(M[, 6 * p + 2], .Machine$double.eps))
  Bn <- nrow(M)

  cover <- vapply(ALPHA_LV, function(al) {
    z <- stats::qnorm(1 - al / 2)
    mean(abs(t_mix) <= z)
  }, numeric(1))
  cover_c2 <- vapply(ALPHA_LV, function(al) {
    z <- stats::qnorm(1 - al / 2)
    mean(abs(M[, 2] / sqrt(pmax(M[, 4 * p + 2], .Machine$double.eps))) <= z)
  }, numeric(1))

  q_emp <- stats::quantile(t_mix, Q_PROBS, names = FALSE, type = 7)
  # MC standard error of a sample quantile: sqrt(q(1-q)/B) / f(x_q), with the
  # density at the quantile taken from the ASYMPTOTIC law (N(0,1)), which is the
  # comparison target; this is the standard Bahadur expression.
  q_se <- sqrt(Q_PROBS * (1 - Q_PROBS) / Bn) / stats::dnorm(stats::qnorm(Q_PROBS))

  lin <- sqrt(rowSums(M[, (2 * p + 1):(3 * p), drop = FALSE]^2))

  list(
    n = n, dgp = spec$name, c_delta = c_delta, c_eps = c_eps, c_r = c_r,
    h_mode = h_mode, h_bias = h_bias, B = Bn,
    # Every gap the summary interprets, pre-converted to MC SE units here so
    # that no reader has to divide and no measure can be quietly dropped in
    # favour of the smallest one (critic finding B4 / C).
    sd_ratio = stats::sd(mixed) / sd_mix,
    sd_ratio_se = stats::sd(mixed) * sqrt(1 / (2 * (Bn - 1))) / sd_mix,
    sd_ratio_z = (stats::sd(mixed) / sd_mix - 1) /
                 (stats::sd(mixed) * sqrt(1 / (2 * (Bn - 1))) / sd_mix),
    cover90_z = (cover[1] - 0.90) / sqrt(cover[1] * (1 - cover[1]) / Bn),
    cover95_z = (cover[2] - 0.95) / sqrt(cover[2] * (1 - cover[2]) / Bn),
    # Centring: eq:rootn says the limit is CENTRED, so mean(mixed) has its own
    # test and it is no longer computed and discarded.
    mean_mixed_z = mean(mixed) / (stats::sd(mixed) / sqrt(Bn)),
    cover90 = cover[1], cover95 = cover[2],
    cover90_se = sqrt(cover[1] * (1 - cover[1]) / Bn),
    cover95_se = sqrt(cover[2] * (1 - cover[2]) / Bn),
    cover90_c2 = cover_c2[1], cover95_c2 = cover_c2[2],
    mean_mixed = mean(mixed), sd_mixed = stats::sd(mixed),
    mean_mixed_se = stats::sd(mixed) / sqrt(Bn),
    sd_mixed_se = stats::sd(mixed) * sqrt(1 / (2 * (Bn - 1))),
    sd_mixed_pop = sd_mix,
    q_emp = q_emp, q_se = q_se, q_asy = stats::qnorm(Q_PROBS),
    lin_mean = mean(lin), lin_se = stats::sd(lin) / sqrt(Bn),
    lin_med = stats::median(lin), lin_q90 = stats::quantile(lin, 0.90, names = FALSE),
    J_gap = mean(M[, 6 * p + 3]), J_gap_se = stats::sd(M[, 6 * p + 3]) / sqrt(Bn),
    V_gap = mean(M[, 6 * p + 4]), V_gap_se = stats::sd(M[, 6 * p + 4]) / sqrt(Bn),
    Vhat_mean = colMeans(M[, (4 * p + 1):(5 * p), drop = FALSE]),
    V_pop = diag(pop$V),
    bias2 = mean(M[, 2]) / sqrt(n), bias2_se = stats::sd(M[, 2]) / sqrt(Bn) / sqrt(n),
    prelim_sd = stats::sd(M[, 3 * p + 2]),
    hnorm = M[1, 6 * p + 5], hs_max = mean(M[, 6 * p + 6]),
    dnorm_mean = mean(M[, 6 * p + 7]), rnorm_mean = mean(M[, 6 * p + 8]),
    Dnorm_mean = mean(M[, 6 * p + 9]),
    rem_h2 = M[1, 6 * p + 10], rem_he = mean(M[, 6 * p + 11]),
    rem_rh = mean(M[, 6 * p + 12]), rem_rD = mean(M[, 6 * p + 13]),
    t_mix = t_mix
  )
}

# ---- Design matrix ---------------------------------------------------------

message("Building population objects ...")
SPECS <- list(A = dgp_spec("A"), B = dgp_spec("B"))
ES    <- lapply(SPECS, solve_ell_star)
POP   <- Map(function(s, e) pop_J_Sigma(s, e, n_pilot = 4e6L), SPECS, ES)
PERT  <- Map(function(s, e) ell_pert_norms(s, e), SPECS, ES)
VAL   <- Map(function(s, e, p) dgp_validate(s, e, p), SPECS, ES, POP)

core <- CJ(dgp = c("A", "B"), n = N_GRID, c_delta = c(0.25, 1.00),
           sorted = FALSE)
core[, `:=`(c_eps = 1, c_r = 1, h_mode = "smooth", h_bias = 0, cell = "core")]

# BIAS ARM (design decision D3d, added in round 2). Every injected error in the
# core grid is mean-zero in direction, so eq:biasb1's bilinear first-order bias
# averages to approximately zero across replications while a real
# Landweber-Fridman error's deterministic regularisation bias would not. The
# linearisation residual is immune (per-replication norm); coverage and the sd
# ratio are not, and they are the headline numbers. This arm holds ||h|| at
# exactly the priced size and moves only the MEAN of the error, from zero
# (bias_frac = 0) to fully deterministic (bias_frac = 1), so the contrast
# isolates what the idealisation buys.
bias_arm <- CJ(dgp = "A", n = c(1000L, 8000L, 64000L, 181019L),
               c_delta = c(0.25, 1.00), h_bias = c(0.5, 1.0), sorted = FALSE)
bias_arm[, `:=`(c_eps = 1, c_r = 1, h_mode = "smooth", cell = "bias")]

# Ablation. Three contrasts at three sample sizes:
#   (a) c_delta = c_eps = c_r = 0 -- PERFECT nuisances. This is the irreducible
#       floor of the linearisation residual: with the true zeta the only gap to
#       the oracle influence function is (J-hat^{-1} - J^{-1}) x O_P(1), so this
#       cell separates the estimator's own second-order noise from the part the
#       nuisance rates drive;
#   (b) c_eps = 0 with c_delta = 1 -- the representer supplied EXACTLY. Since
#       rem:rootnscope(3) records that ell-hat is constructed nowhere, this is
#       the most favourable implementation the theory permits, and it isolates
#       lem:biasexp eq:biasb1 (which vanishes identically when ell-hat = ell_star,
#       by the balancing property of A2);
#   (c) h_mode = "rough" -- the structural error placed on the highest available
#       frequencies rather than the lowest, at the same L2(pi) norm.
abl <- rbind(
  data.table(dgp = "A", n = c(1000L, 8000L, 64000L), c_delta = 0, c_eps = 0,
             c_r = 0, h_mode = "smooth"),
  CJ(dgp = "A", n = c(1000L, 8000L, 64000L), c_eps = c(0, 1),
     h_mode = c("smooth", "rough"), sorted = FALSE)[, `:=`(c_delta = 1, c_r = 1)],
  fill = TRUE)
abl[, `:=`(cell = "ablation", h_bias = 0)]

DESIGN <- rbind(core, bias_arm, abl, fill = TRUE)
DESIGN <- unique(DESIGN,
                 by = c("dgp", "n", "c_delta", "c_eps", "c_r", "h_mode", "h_bias"))
setorder(DESIGN, dgp, n, c_delta, c_eps, h_mode, h_bias)

message(sprintf("Running %d cells on %d cores ...", nrow(DESIGN), N_CORES))
OUT <- vector("list", nrow(DESIGN))                            # INV-17

# Checkpointing. The largest cells take ~20 minutes each, so completed cells are
# written after every cell and reloaded on a restart: a rerun costs only the
# cells that had not finished.
#
# The checkpoint also carries an MD5 fingerprint of every source file that
# defines a replication and is discarded when any of them changes -- see the
# same guard in the phi-step arm, and critic finding A for why it is needed.
SRC_FILES <- here::here("scripts", "simulations",
                        c("sim_thm_rootn_limitlaw.R", "sim_thm_rootn_dgp.R",
                          "sim_thm_rootn_nuisance.R"))
SRC_HASH <- unname(tools::md5sum(SRC_FILES))
CKPT <- here::here("quality_reports", "sim", "sim_thm_rootn_limitlaw_ckpt.rds")
# 2026-08-03 FIX. The design half of this guard read identical(old$design,
# DESIGN) on a data.table, whose .internal.selfref external pointer is recreated
# on every load -- so it was ALWAYS FALSE and this arm has never once resumed
# from a checkpoint, silently reporting a fresh start each time. same_design()
# (sim_thm_rootn_dgp.R) carries the diagnosis and the reproduction; the headroom
# arm's fp_norm() is the same fix, found first and written locally.
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
  # Advance the parent L'Ecuyer stream so that each cell gets independent child
  # streams; mclapply does not advance the parent's seed on its own, so without
  # this every cell would reuse the same child streams. The stream is advanced
  # for skipped cells too, so a resumed run reproduces a fresh one exactly.
  assign(".Random.seed", parallel::nextRNGStream(get(".Random.seed", envir = globalenv())),
         envir = globalenv())
  if (!is.null(OUT[[i]])) next
  r <- DESIGN[i]
  t0 <- Sys.time()
  parallel::mc.reset.stream()
  OUT[[i]] <- run_cell(r$n, SPECS[[r$dgp]], ES[[r$dgp]], POP[[r$dgp]],
                       PERT[[r$dgp]], r$c_delta, r$c_eps, r$c_r, r$h_mode,
                       reps_for(r$n), r$h_bias)
  OUT[[i]]$cell <- r$cell
  save_ckpt(list(design = DESIGN, out = OUT, src_hash = SRC_HASH), CKPT)
  message(sprintf("  [%2d/%2d] dgp %s  n = %6d  c_delta = %.2f  c_eps = %.0f  %s  bias %.1f  (%.0fs)",
                  i, nrow(DESIGN), r$dgp, r$n, r$c_delta, r$c_eps, r$h_mode,
                  r$h_bias, as.numeric(difftime(Sys.time(), t0, units = "secs"))))
}

saveRDS(list(design = DESIGN, out = OUT, pop = POP, val = VAL, cfg = CFG),
        here::here("quality_reports", "sim", "sim_thm_rootn_limitlaw.rds"))

# ---- Tables ----------------------------------------------------------------

fmt <- function(x, d = 3) formatC(x, format = "f", digits = d)

core_idx <- which(vapply(OUT, function(o) o$cell, character(1)) == "core")
tab <- rbindlist(lapply(OUT[core_idx], function(o) data.table(
  dgp = o$dgp, n = o$n, c_delta = o$c_delta, B = o$B,
  rem = o$rem_h2, sd_mixed = o$sd_mixed, sd_pop = o$sd_mixed_pop,
  sd_se = o$sd_mixed_se, cover90 = o$cover90, cover90_se = o$cover90_se,
  cover95 = o$cover95, cover95_se = o$cover95_se,
  sd_ratio = o$sd_ratio, sd_ratio_se = o$sd_ratio_se, sd_ratio_z = o$sd_ratio_z,
  cover90_z = o$cover90_z, cover95_z = o$cover95_z,
  mean_mixed = o$mean_mixed, mean_mixed_z = o$mean_mixed_z,
  q_worst_z = max(abs((o$q_emp - o$q_asy) / o$q_se)),
  lin = o$lin_mean, lin_se = o$lin_se, V_gap = o$V_gap, V_gap_se = o$V_gap_se,
  J_gap = o$J_gap, J_gap_se = o$J_gap_se)))
setorder(tab, dgp, c_delta, n)

# INV-17: panel bodies are built by vectorised sprintf and assembled ONCE.
tab[, panel := paste(dgp, c_delta)]
pkeys <- unique(tab$panel)
panel_block <- function(k) {
  s <- tab[panel == k]
  c(sprintf("\\multicolumn{8}{l}{\\textit{Panel %s: DGP-%s, $c_\\delta=%.2f$}} \\\\",
            LETTERS[match(k, pkeys)], s$dgp[1], s$c_delta[1]),
    "\\midrule",
    sprintf("& %s & %s & %s (%s) & %s (%s) & %s (%s) & %s (%s) & %s \\\\",
            formatC(s$n, big.mark = ",", format = "d"),
            fmt(s$rem, 2), fmt(s$sd_ratio, 3), fmt(s$sd_ratio_se, 3),
            fmt(s$cover90, 3), fmt(s$cover90_se, 3),
            fmt(s$cover95, 3), fmt(s$cover95_se, 3),
            fmt(s$lin, 3), fmt(s$lin_se, 3), fmt(s$V_gap, 3)))
}
writeLines(c(
  "\\begin{tabular}{lrrcccccc}", "\\toprule",
  " & & $\\sqrt n\\delta_n^2$ & & \\multicolumn{2}{c}{Coverage (MC SE)} & Lin.\\ resid. & $\\|\\hat V-V\\|_\\infty$ \\\\",
  "\\cmidrule(lr){5-6}",
  "DGP & $n$ & budget & $\\hat{\\mathrm{sd}}/\\mathrm{sd}_\\infty$ (MC SE) & 90\\% & 95\\% & mean (SE) & mean \\\\",
  "\\midrule",
  unlist(lapply(pkeys, panel_block), use.names = FALSE),
  "\\bottomrule", "\\end{tabular}"),
  here::here("paper", "tables", "sim", "sim_thm_rootn_limitlaw.tex"))

# ---- EVERY measure in MC SE units ------------------------------------------
#
# Critic finding B4: the round-1 summary reported the worst QUANTILE gap in SE
# units -- the smallest of the available measures -- while the sd ratio and the
# 90% coverage at the same cells were larger and were never converted. All five
# are converted here, in one place, so the verdict cannot select among them.
# Sign convention: positive means the empirical quantity EXCEEDS its asymptotic
# target (sd ratio above 1, coverage above nominal).
setorder(tab, dgp, c_delta, n)
writeLines(c(
  "\\begin{tabular}{lrrrrrrr}", "\\toprule",
  " & & & \\multicolumn{5}{c}{Deviation from the asymptotic value, in MC SE units} \\\\",
  "\\cmidrule(lr){4-8}",
  "DGP & $c_\\delta$ & $n$ & $\\hat{\\mathrm{sd}}/\\mathrm{sd}_\\infty$ & 90\\% cov. & 95\\% cov. & Worst quantile & Centring \\\\",
  "\\midrule",
  sprintf("%s & %s & %s & %s & %s & %s & %s & %s \\\\",
          tab$dgp, fmt(tab$c_delta, 2),
          formatC(tab$n, big.mark = ",", format = "d"),
          fmt(tab$sd_ratio_z, 2), fmt(tab$cover90_z, 2), fmt(tab$cover95_z, 2),
          fmt(tab$q_worst_z, 2), fmt(tab$mean_mixed_z, 2)),
  "\\bottomrule", "\\end{tabular}"),
  here::here("paper", "tables", "sim", "sim_thm_rootn_seunits.tex"))

# ---- Quantile table: the mandatory empirical-vs-asymptotic comparison ------
#
# BOTH c_delta configurations are reported. The round-1 table showed only
# c_delta = 0.25, so the quantile set at c_delta = 1 -- the configuration whose
# gaps the verdict had to explain -- was computed and never exported. Since both
# configurations satisfy IDENTICAL hypotheses (see the summary), there is no
# ground on which to table one and suppress the other.
qsel <- which(vapply(OUT, function(o)
  o$cell == "core" && o$n %in% c(1000L, 8000L, 64000L, 181019L), logical(1)))
qblock <- function(j) {
  o <- OUT[[j]]
  z <- (o$q_emp - o$q_asy) / o$q_se
  c(sprintf("%s & %s & %s & %.3f & %s (%s) & %s & %s \\\\",
            c(o$dgp, rep("", length(Q_PROBS) - 1L)),
            c(fmt(o$c_delta, 2), rep("", length(Q_PROBS) - 1L)),
            c(formatC(o$n, big.mark = ",", format = "d"),
              rep("", length(Q_PROBS) - 1L)),
            Q_PROBS, fmt(o$q_emp, 3), fmt(o$q_se, 3), fmt(o$q_asy, 3), fmt(z, 2)),
    "\\addlinespace")
}
qbody <- unlist(lapply(qsel, qblock), use.names = FALSE)
writeLines(c(
  "\\begin{tabular}{lrrrrrr}", "\\toprule",
  "DGP & $c_\\delta$ & $n$ & Quantile & Empirical (MC SE) & Asymptotic & Diff.\\ (MC SE units) \\\\",
  "\\midrule", qbody[-length(qbody)], "\\bottomrule", "\\end{tabular}"),
  here::here("paper", "tables", "sim", "sim_thm_rootn_quantiles.tex"))

# ---- Ablation table (INV-17: vectorised) -----------------------------------
aidx <- which(vapply(OUT, function(o) o$cell, character(1)) == "ablation")
atab <- rbindlist(lapply(OUT[aidx], function(o) data.table(
  n = o$n,
  arm = if (o$c_delta == 0) "all exact" else if (o$c_eps == 0) "$\\hat\\ell=\\ell_\\star$" else "feasible",
  hm = o$h_mode,
  c90 = o$cover90, c95 = o$cover95, lin = o$lin_mean, rat = o$sd_ratio,
  se90 = o$cover90_se, se95 = o$cover95_se)))
setorder(atab, n, arm, hm)
writeLines(c(
  "\\begin{tabular}{rllcccc}", "\\toprule",
  "$n$ & $\\hat\\ell$ & $h$ geometry & 90\\% & 95\\% & Lin.\\ resid. & $\\hat{\\mathrm{sd}}/\\mathrm{sd}_\\infty$ \\\\",
  "\\midrule",
  sprintf("%s & %s & %s & %s (%s) & %s (%s) & %s & %s \\\\",
          formatC(atab$n, big.mark = ",", format = "d"), atab$arm, atab$hm,
          fmt(atab$c90, 3), fmt(atab$se90, 3), fmt(atab$c95, 3),
          fmt(atab$se95, 3), fmt(atab$lin, 3), fmt(atab$rat, 3)),
  "\\bottomrule", "\\end{tabular}"),
  here::here("paper", "tables", "sim", "sim_thm_rootn_ablation.tex"))

# ---- Bias arm: what the mean-zero idealisation was buying (D3d) ------------
bidx <- which(vapply(OUT, function(o) o$cell, character(1)) %in% c("bias", "core"))
btab <- rbindlist(lapply(OUT[bidx], function(o) data.table(
  n = o$n, dgp = o$dgp, c_delta = o$c_delta, h_bias = o$h_bias,
  c90 = o$cover90, c90_se = o$cover90_se, c95 = o$cover95, c95_se = o$cover95_se,
  rat = o$sd_ratio, rat_se = o$sd_ratio_se, lin = o$lin_mean, lin_se = o$lin_se,
  cz = o$cover95_z, rz = o$sd_ratio_z, mz = o$mean_mixed_z)))
btab <- btab[dgp == "A" & n %in% c(1000L, 8000L, 64000L, 181019L)]
setorder(btab, c_delta, n, h_bias)
writeLines(c(
  "\\begin{tabular}{rrccccc}", "\\toprule",
  " & & \\multicolumn{2}{c}{Coverage (MC SE)} & $\\hat{\\mathrm{sd}}/\\mathrm{sd}_\\infty$ & Lin.\\ resid. & Centring \\\\",
  "\\cmidrule(lr){3-4}",
  "$n$ & Bias frac. & 90\\% & 95\\% & (MC SE) & mean (SE) & (MC SE units) \\\\",
  "\\midrule",
  unlist(lapply(unique(btab$c_delta), function(cd) {
    s <- btab[c_delta == cd]
    c(sprintf("\\multicolumn{7}{l}{\\textit{$c_\\delta=%.2f$}} \\\\", cd), "\\midrule",
      sprintf("%s & %s & %s (%s) & %s (%s) & %s (%s) & %s (%s) & %s \\\\",
              formatC(s$n, big.mark = ",", format = "d"), fmt(s$h_bias, 1),
              fmt(s$c90, 3), fmt(s$c90_se, 3), fmt(s$c95, 3), fmt(s$c95_se, 3),
              fmt(s$rat, 3), fmt(s$rat_se, 3), fmt(s$lin, 3), fmt(s$lin_se, 3),
              fmt(s$mz, 2)), "\\addlinespace")
  }), use.names = FALSE),
  "\\bottomrule", "\\end{tabular}"),
  here::here("paper", "tables", "sim", "sim_thm_rootn_bias.tex"))

# ---- DGP validation: measured, and now exported ----------------------------
#
# Critic finding C: these numbers were computed by dgp_validate() and quoted in
# prose with no artifact behind them. A design whose whole claim is that it
# REALISES the hypotheses rather than assuming them must table the realisation.
vtab <- rbindlist(lapply(names(VAL), function(nm) {
  v <- VAL[[nm]]
  data.table(dgp = nm, bal = v$balancing_rel_resid,
             psi_t = max(abs(v$mean_psi / v$mean_psi_se)),
             dzdu = max(abs(v$E_dz_du)), kj = v$kappa_J,
             rlo = v$min_varrho, rhi = v$max_varrho,
             u4 = v$E_du4, sdu = v$sd_du, ellsup = v$ell_sup)
}))
writeLines(c(
  "\\begin{tabular}{lrrrrrrr}", "\\toprule",
  "DGP & A2 rel.\\ resid. & $\\max|t|$, $E\\psi_\\star$ & $\\max|E[\\Delta Z\\Delta U]|$ & $\\kappa(J)$ & $\\varrho$ range & $E[\\Delta U^4]$ & $\\sup|\\ell_\\star|$ \\\\",
  "\\midrule",
  sprintf("%s & %s & %s & %s & %s & [%s, %s] & %s & %s \\\\",
          vtab$dgp, formatC(vtab$bal, format = "e", digits = 1),
          fmt(vtab$psi_t, 2), formatC(vtab$dzdu, format = "e", digits = 1),
          fmt(vtab$kj, 1), fmt(vtab$rlo, 3), fmt(vtab$rhi, 3),
          fmt(vtab$u4, 2), fmt(vtab$ellsup, 2)),
  "\\bottomrule", "\\end{tabular}"),
  here::here("paper", "tables", "sim", "sim_thm_rootn_dgpvalid.tex"))

# ---- Figures (no in-figure titles, serif, PDF; INV-12) ---------------------

thm_sim <- theme_minimal(base_family = "serif", base_size = 10) +
  theme(panel.grid.minor = element_blank(),
        strip.text = element_text(face = "bold"))

qq_cells <- which(vapply(OUT, function(o)
  o$cell == "core" && o$c_delta %in% c(0.25, 1.00) &&
  o$n %in% c(1000L, 64000L), logical(1)))
qq_dt <- rbindlist(lapply(OUT[qq_cells], function(o) {
  pr <- stats::ppoints(min(length(o$t_mix), 4000L))
  data.table(dgp = paste0("DGP-", o$dgp),
             n = factor(formatC(o$n, big.mark = ",", format = "d"),
                        levels = c("1,000", "64,000")),
             c_delta = paste0("c[delta] == ", o$c_delta),
             theo = stats::qnorm(pr),
             emp = stats::quantile(o$t_mix, pr, names = FALSE))
}))
p_qq <- ggplot(qq_dt, aes(theo, emp, colour = n, shape = n, linetype = n)) +
  geom_abline(slope = 1, intercept = 0, colour = "grey45", linewidth = 0.35) +
  geom_line(linewidth = 0.5) +
  # label_parsed on BOTH facets rendered "DGP-A" as an expression, so the hyphen
  # came out as a minus sign ("DGP - A"). Only c_delta needs parsing.
  facet_grid(dgp ~ c_delta,
             labeller = labeller(dgp = label_value, c_delta = label_parsed)) +
  scale_colour_brewer(palette = "Set2") +
  labs(x = "Standard normal quantile",
       y = "Empirical quantile of the studentised statistic",
       colour = "Sample size", shape = "Sample size", linetype = "Sample size") +
  coord_cartesian(xlim = c(-3.2, 3.2), ylim = c(-4.2, 4.2)) +
  thm_sim + theme(legend.position = "bottom")
ggsave(here::here("paper", "figures", "sim", "sim_thm_rootn_qq.pdf"), p_qq,
       width = 6.5, height = 5.2, device = cairo_pdf)

lin_dt <- rbindlist(lapply(OUT[core_idx], function(o) data.table(
  dgp = paste0("DGP-", o$dgp), n = o$n, c_delta = factor(o$c_delta),
  lin = o$lin_mean, se = o$lin_se, rem = o$rem_h2)))
p_lin <- ggplot(lin_dt, aes(n, lin, colour = c_delta, shape = c_delta,
                            linetype = c_delta)) +
  geom_hline(yintercept = 0, colour = "grey60", linewidth = 0.3) +
  geom_line(linewidth = 0.5) + geom_point(size = 1.6) +
  geom_errorbar(aes(ymin = lin - 1.96 * se, ymax = lin + 1.96 * se),
                width = 0.06, linewidth = 0.3) +
  facet_wrap(~dgp) + scale_x_log10() + scale_y_log10() +
  scale_colour_brewer(palette = "Set2") +
  labs(x = "Sample size (log scale)",
       y = expression(paste("E ", "||", sqrt(n)(hat(theta) - theta[dagger]) -
                            J^{-1} * sqrt(n) * E[n] * psi[symbol("\052")], "||")),
       colour = expression(c[delta]), shape = expression(c[delta]),
       linetype = expression(c[delta])) +
  thm_sim + theme(legend.position = "bottom")
ggsave(here::here("paper", "figures", "sim", "sim_thm_rootn_linresid.pdf"), p_lin,
       width = 6.5, height = 3.2, device = cairo_pdf)

message("done: limit-law arm")
