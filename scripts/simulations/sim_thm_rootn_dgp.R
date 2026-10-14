# ============================================================================
# sim_thm_rootn_dgp.R
#
# Shared data-generating processes and POPULATION objects for the Monte Carlo
# verification of thm:rootn (panel-npiv-discrete, Part I).
#
# THIS FILE IS SOURCED, NOT RUN. It sets no seed and writes no output.
# The scripts that source it each set exactly one seed at their top (INV-14).
#
# ---------------------------------------------------------------------------
# WHAT IS REALISED HERE
#
# Model (def:model, eq:levels / eq:diffs):
#   Y_ij   = phi_dagger(X_ij) + Z_ij' theta_dagger + eta_i + U_ij,  j in {1,2}
#   dY_i   = d phi_i + dZ_i' theta_dagger + dU_i
# X scalar continuous endogenous on the compact interval [0,1]; W in {0,1}
# binary; dZ in R^p; eta_i differenced out and free to depend on (X,Z,W).
#
# Identification restrictions (def:admissible):
#   (A)  E[ Wtilde * varsigma(dU) | dZ ] = 0 for bounded varsigma   <=>  dU || W | dZ
#   (B)  E[ dZ dU ] = 0
#
# THE DESIGN IS THE PAPER'S OWN. proofs.tex rem:h6bandwidth(5) names the
# "frontier-clearing configuration" (mu, s, a, alpha) = (2, 3, 3/4, 0.32),
# equivalently r = 8/3 at d_Z = 3, and states that it "is the one a simulation
# should run". The BOUNDARY configuration (mu, d_Z, r) = (1, 3, 4.5) is NOT an
# admissible design (it fails (P-f) by (ln n)^{1/3}) and is not used here.
#
# A4(ii) requires d_Z <= p - 1, so d_Z = 3 forces p >= 4. The fourth coordinate
# is the differenced intercept dZ_1 == 1 (a common time effect), which is
# degenerate and therefore does not enter varrho. p = 4, d_Z = 3.
#
# ---------------------------------------------------------------------------
# SIMULATION-DESIGN DECISIONS (D1-D7) -- declared, not buried
#
# The theory does not fix every ingredient of the estimator. rem:rootnscope(3)
# says so in terms: "It does not derive its own inputs ... the representer's
# estimator ell-hat is priced by A5(iv) and CONSTRUCTED NOWHERE"; the
# preliminary phi-hat^(0) needed by def:lfstep "has no supplier in this file
# (open item Q-1)". Every gap is closed HERE, explicitly, and each closure is a
# statement about this simulation and not about the theorem.
#
# D1. ell_star is obtained by SOLVING the balancing equation of A2 numerically
#     within the DGP, not by assuming a form. The equation is
#         nu_{dZ + Wtilde ell_star(dU, dZ)} == 0    on X,
#     which is what lem:adjoint(iii) makes A2 equivalent to and what
#     lem:biasexp eq:biasb1 consumes. The solve is a one-off population
#     computation with the DGP's closed-form conditional densities; the
#     achieved balancing residual is REPORTED (dgp_validate) so a reader can see
#     how nearly A2 holds in the design rather than take it on trust.
#
# D2. The weight anchor is the ZERO anchor, b_star == 0, admissible with no
#     further assumption by rem:anchor. Consequence: (R-c.1) / N1' does NOT
#     hold for D_k = L-hat - L_star, so the simulation runs branch (R-c.2) and
#     the product r_n * eps^L_n is monitored rather than assumed away.
#
# D3. phi-hat^(-k), ell-hat^(-k), varrho-hat^(-k) are drawn as the truth plus a
#     random error of CONTROLLED size in the norm the theorem prices, measurable
#     with respect to the complement fold. This is not a shortcut around the
#     nuisance estimators: thm:rootn's hypotheses on them ((T-4), eq:foldrates,
#     (R-a), (R-e)) are RATE conditions, so a design that realises exactly those
#     rates tests the theorem in its own terms. What it does NOT test is whether
#     any particular estimator attains them -- that is what the phi-step arm
#     (sim_thm_rootn_phistep.R) measures separately, for def:lfstep.
#
# D4. The rate CONSTANT is a free parameter c_delta, not fixed at 1. A5(ii) is
#     an O_P statement; the theory pins the exponent and nothing else. At the
#     frontier-clearing configuration the leading remainder sqrt(n) delta_n^2
#     equals n^{-0.012} (ln n)^{1.6}, which is ~28 at n = 5000 with constant 1
#     and first falls below 1 near n = e^900. Fixing c_delta = 1 would therefore
#     test a regime no sample size reaches; sweeping c_delta is what makes the
#     exercise informative. See sim_thm_rootn_budget.R.
#
# D5. Cross-fitting uses F = 2 folds (def:crossfit, "At F = 2 this is Part H's
#     split"), fixed and data-independent.
#
# D6. The Bierens family is B1's maintained choice: Phi = componentwise arctan
#     rescaled to c_Phi = 1 (B1(i)), w = exp (B1(ii)). Pi_u is a bounded,
#     everywhere-positive density (B1(iv.a)) and Pi_t is UNIFORM on the compact
#     index set T (B1(iii), B1(iv.b)), both approached by quadrature.
#
#     ROUND-3 CORRECTION. Through round 2 this gloss read "T is a finite grid
#     (B1(vi)'s growing family read at a fixed n)". That justification is NOT
#     AVAILABLE, on two counts. First, B1(vi) is RETIRED -- struck in dispatch 14
#     and, per its own retirement note, "not maintained, not available for use,
#     and a hypothesis of no result in this programme" -- and it is retired on
#     precisely the ground that def:hatT integrates against Pi_t over ALL of T,
#     so a design appealing to it is appealing to a different estimator. Second,
#     even if it were live it would not cover this design: B1(vi) required
#     #T_n -> infinity, and the node count here is a CONSTANT, so "read at a
#     fixed n" describes no clause of it. What the design actually needs, and now
#     cites, is B1(iii) (Leb(T) > 0), B1(iv.b) (Pi_t not mutually singular with
#     Lebesgue on a subset) and B1(iv.c) (c_Pi finite). The nodes are quadrature
#     nodes for the fixed measure Pi_t, not a family indexed by n; see design
#     decision D13 in sim_thm_rootn_phistep.R, which is where Pi_t is built.
#
# D7. pi, the reference density of def:spaces, is Uniform[0,1]. Then
#     V = {phi : integral phi dx = 0} and || nu_g / pi ||_{L2(pi)}^2 =
#     integral nu_g^2 dx, so the balancing residual of D1 is an ordinary
#     L2[0,1] norm. C1(ii)'s bar-c-pi bounds hold trivially.
#
# ---------------------------------------------------------------------------
# D8. THE INSTRUMENT'S CARDINALITY IS A PARAMETER (added 2026-08-14, scope S1)
#
# Through 2026-08-13 this file was BINARY -- line 469 read `pw <- cbind(1 - rr,
# rr)` -- while the theory it verifies is stated at a general finite instrument
# W in {0, 1, ..., sans-L - 1} (assumptions_main.tex, eq:contrast). Every object
# below now carries sans-L through spec$L_cells, and the objects the type
# declaration of the instrument block makes contrast-indexed carry the index:
#
#   varrho    (Lc - 1)-vector of NON-BASE cell probabilities, eq:contrast
#   Wtilde_l  1{W = l} - varrho_l(dZ),  l = 1, ..., Lc - 1;  cell 0 is the base
#   ell_star  R^{p x (Lc-1)}-valued: one ROW per coordinate of theta, one COLUMN
#             per contrast, exactly as def:moment's type declaration requires
#   psi       dZ dU + L_star Wtilde,  the contrast standing to the RIGHT
#   J         E[dZ dZ'] + E[ell_star Wtilde dZ'],  eq:JSig
#
# WHAT sans-L FORCES, AND IT IS EXACTLY TWO THINGS. A cardinality cannot be
# raised without saying what the new cells do, so two primitives are generated
# from the binary ones by a rule that RETURNS THE PRINTED BINARY DESIGN AT
# sans-L = 2 and is stated once here:
#   (a) the propensity needs Lc - 1 index functions where it had one. The rule
#       is CYCLIC SHIFTS of the shipped coefficient vector gamma, so every index
#       has the same norm and the same per-coordinate strength as the binary
#       one and no cell is privileged. At Lc = 2 the rule returns gamma itself.
#   (b) the first stage needs Lc shifts of X_2* where it had two. The rule is
#       EQUALLY SPACED on [0, a_w], so the base-to-strongest contrast -- the one
#       quantity a binary design pins -- is IDENTICAL across cardinalities. At
#       Lc = 2 the rule returns (0, a_w).
# Nothing else moves with sans-L: theta, phi_dagger, sigma_z, z_mean, the
# endogeneity loading, the scale mixture, eps_varrho, and every rate symbol of
# the maintained block are the SAME NUMBERS at every cardinality.
#
# THE OVERLAP FLOOR IS HELD AT ITS SHIPPED VALUE AND THAT IS FEASIBLE, NOT
# LUCKY. A4(i) requires eps_varrho < 1/sans-L, so a floor of 0.10 is admissible
# up to sans-L = 9; DGP-B's 0.03 up to sans-L = 33. The design therefore holds
# the floor CONSTANT across the cardinality contrast rather than rescaling it.
# What does move with sans-L, because the theory makes it move, is the induced
# eigenvalue floor eq:omegafloor, eps_Omega = eps_varrho / sans-L: it is a
# CONSEQUENCE of A4(i) at each sans-L, not a second dial.
#
# TYPE CONVENTION, AND WHY IT IS R's OWN. Objects with Lc - 1 contrast slots are
# returned with the contrast dimension DROPPED when Lc = 2, which is R's
# `drop = TRUE` convention for a one-column matrix and a one-slice array. This
# is not cosmetic: it is what makes the binary path -- and the four arms that
# consume it unchanged (budget, jacobian, phi-step, headroom) -- bit-identical.
# contract_w() below is the one place the contrast index is summed out, so no
# caller has to know which shape it is holding.
# ============================================================================

# ---- Configuration ---------------------------------------------------------

# The frontier-clearing configuration of proofs.tex rem:h6bandwidth(5).
CFG <- list(
  mu     = 2,        # source-condition index (primitive at (P-a.3))
  s      = 3,        # Sobolev order, H1 / A8
  a      = 0.75,     # degree of ill-posedness, H1: sigma_j asymp j^{-a}
  d_z    = 3,        # non-degenerate coordinates of dZ, A4(ii)
  r      = 8 / 3,    # Holder order of varrho, A4(ii)
  tau_dp = 2.5,      # discrepancy constant, (P-e) requires tau_DP > 2
  p_K    = 8         # kernel order, C5'(i)
)
CFG$kappa <- 2 * CFG$mu / (2 * CFG$mu + 1)          # 0.8
CFG$alpha <- CFG$r / (2 * CFG$r + CFG$d_z)          # 0.32

# Rate symbols of the maintained block, as functions of n.
#   delta-hat_n = max{delta-hat_n^{(T)}, delta-hat_n^{(varrho)}}   A5(i), LITERALLY
#                 delta-hat_n^{(T)}      = n^{-1/2} sqrt(ln n)     parametric branch
#                 delta-hat_n^{(varrho)} = r_n = n^{-alpha}        propensity branch
#   r_n         = n^{-r/(2r+d_Z)} = n^{-alpha}     A4(iii)
#   delta_n     = (delta-hat_n ln n)^{2mu/(2mu+1)} A5(ii) AS AMENDED, eq:deltalog
#
# The inflation is applied ONCE, INSIDE the power, never on top of delta_n.
# rem:rootnlog(1) and the dispatch-12 glossary row are explicit that
# delta_n -> delta_n (ln n)^{2mu/(2mu+1)} is the forbidden double application.
#
# ---------------------------------------------------------------------------
# 2026-08-03 FIX. A5(i) IS A MAXIMUM AND THIS FILE IMPLEMENTED ONE BRANCH OF IT.
#
# Through 2026-08-03 the first line below read
#     rate_delta_hat <- function(n, cfg = CFG) n^(-cfg$alpha)
# -- the PROPENSITY branch alone. A5(i) states
#     delta-hat_n = max{delta-hat_n^{(T)}, delta-hat_n^{(varrho)}},
#     delta-hat_n^{(T)} = O_P(n^{-1/2} sqrt(ln n)),  delta-hat_n^{(varrho)} = O_P(r_n),
# and its first branch is a PARAMETRIC FLOOR that no configuration goes below.
# The clause's closing sentence -- "in every configuration of interest
# delta-hat_n = delta-hat_n^{(varrho)}" -- is an ASYMPTOTIC statement, true
# because alpha < 1/2 makes n^{-alpha} eventually dominate n^{-1/2} sqrt(ln n);
# the shipped code read it as an identity holding at every n, which it is not.
#
# HOW IT WAS FOUND. The headroom arm (sim_thm_rootn_headroom_dgp.R, 2026-08-02)
# had to push alpha up to buy frontier margin, which is exactly the move that
# makes the two branches trade places, so it priced them separately and the
# omission here surfaced there -- see that file's header, fact (1), which names
# this function. hr_dhat_T / hr_dhat_rho / hr_dhat_max are the same three
# functions written against HR_CFG; the semantics below are theirs.
#
# NO SHIPPED NUMBER MOVES, AND THAT IS CHECKED, NOT ASSUMED. At the shipped
# alpha = 0.32 the propensity branch dominates at EVERY cell of EVERY grid this
# project evaluates -- the branches cross at alpha = 0.337 (n = 125) rising to
# alpha = 0.397 (n = 181,019) -- so the two readings agree BIT FOR BIT and
# sqrt(n) delta_n^2 is unchanged at 11.72, 15.82, 20.27, 25.06, 30.13, 35.45,
# 41.00, 46.74 across the Monte Carlo grid. The branches do cross at alpha =
# 0.32, but only for n in (9.4, 29.9), which no grid here reaches. This is a
# repair, not a retraction.
#
# WHAT IT SILENTLY MISPRICED, WHICH IS WHY IT IS REPAIRED. Above the crossover
# the propensity branch is the SMALLER one and an r_n-only reading UNDERSTATES
# delta-hat_n. At (mu, r, d_Z) = (5, 20, 1) and n = 181,019: alpha = 0.4878, the
# parametric branch is 0.00818 against the propensity branch's 0.00272, and the
# leading budget sqrt(n) delta_n^2 is 6.350 -- not the 0.861 an r_n-only reading
# reports. A factor of 7.4, and the difference between a design that clears its
# budget and one that does not.
#
# THE STRUCTURAL CONSEQUENCE, which any design search over (mu, r, d_Z) needs:
# once alpha >= 0.397 the floor binds at every n on the feasible grid and THE
# BUDGET STOPS RESPONDING TO r ALTOGETHER, delta-hat_n being pinned at
# n^{-1/2} sqrt(ln n). Frontier headroom is then bought with mu, not with r. The
# floor also puts an absolute lower bound under the leading product,
#     sqrt(n) delta_n^2 >= n^{1/2 - kappa} (ln n)^{3 kappa}  ->  n^{-1/2}(ln n)^3
# as mu -> infinity, which is 4.17 at n = 181,019 IN EVERY CONFIGURATION and is
# approached but never attained.
#
# A5(i)'s second branch IS r_n (A4(iii)), so rate_rn serves as both and there is
# exactly ONE implementation of it, as with h_u / eq:normconst / eq:cap below.
rate_dhat_T    <- function(n) n^(-0.5) * sqrt(log(n))
rate_rn        <- function(n, cfg = CFG) n^(-cfg$alpha)
rate_delta_hat <- function(n, cfg = CFG) pmax(rate_dhat_T(n), rate_rn(n, cfg))
rate_delta_n   <- function(n, cfg = CFG) (rate_delta_hat(n, cfg) * log(n))^cfg$kappa

# A5(iv) prices eps_n only through the product delta_n eps_n = o(n^{-1/2}).
# eps_n = n^{-EPS_EXPONENT} is a DESIGN CHOICE (D3): the theory supplies no
# construction for ell-hat and therefore no exponent. 0.45 clears both
# delta_n eps_n = o(n^{-1/2}) (A5(iv)) and r_n eps^L_n = o(n^{-1/2}) ((R-c.2))
# at every n in the grid; the achieved products are tabulated, not assumed.
EPS_EXPONENT <- 0.45
rate_eps_n <- function(n, cfg = CFG) n^(-EPS_EXPONENT)

# Bandwidths of C5'(i)-(ii), used by the phi-step arm.
#   h_u asymp sd(dU) * delta_hat_n^{1/p_K}
#
# ROUND-2 FIX (critic finding A / F). These three functions were previously
# DEFINED AND NEVER CALLED, while the phi-step arm computed h_u, omega_n and the
# cap inline -- and the dead cap_mbar() implemented eq:cap with the
# proportionality constant of omega_n set to 1, where the live path realises it
# at 77.6-119.3. A reader tracing eq:cap through this file would have read the
# wrong constant off a function that never ran. There is now exactly ONE
# implementation of each of h_u, eq:normconst and eq:cap, and the phi-step arm
# calls it; sd_du and the L2(Pi) constants are passed in because they are
# realised on the sample, not fixed by the theory.
band_hu <- function(n, sd_du, cfg = CFG) sd_du * rate_delta_hat(n, cfg)^(1 / cfg$p_K)

# ---------------------------------------------------------------------------
# 2026-08-16. THE h_x EXPONENT, AND WHY THE DEFAULT BELOW IS NOT THE VALUE ANY
# ARM NOW USES.
#
# WHAT THIS BLOCK USED TO SAY, AND WHY IT WAS A FOSSIL. Through 2026-08-15 it
# read "h_x in (n^{-0.44}, n^{-0.128}) at this configuration; the upper (cheap)
# end of that window is taken", and band_hx returned n^{-0.20}. Both halves were
# written against a corpus that has since moved twice:
#   (a) the upper end n^{-0.128} is (P-g) read at the UNDEGRADED eq:xsmoothbias
#       exponent s - 1/2 = 5/2. D11's row renormalisation enforces only the
#       j = 0 truncated moment, so the j = 1, 2 terms of the Taylor route at
#       proofs.tex:7976-8057 survive and the display degrades to h_x^1. At the
#       degraded exponent (P-g) reads h_x = O(n^{-9 alpha/8}) = O(n^{-0.360}),
#       and n^{-0.20} FAILS it -- measured, not inferred: the realised ratio
#       sup|varphi_{h_x} - vdagger| / (h_u delta-hat_n) CLIMBS across the grid
#       at +0.127 per ln n, where (P-g) requires O(1);
#   (b) (P-g) acquired its h_u factor only in dispatch 25, which multiplied the
#       alpha-dependent term of both non-emptiness thresholds by 9/8.
# The window that survives both is bounded BELOW by C5'(ii) in its stronger
# inherited form, (n h_x^2 h_u^3)^{-1} ln n -> 0, i.e. h_x >> n^{-(1-3 alpha/8)/2}
# = n^{-0.440}, and ABOVE by the degraded (P-g), h_x = O(n^{-0.360}). It is
# non-empty iff alpha < 8/21 = 0.38095, and clears by 0.061 at alpha = 0.32.
# (Under the DISPLAYED form of C5'(ii) -- the one assumptions_supp.tex:2181 says
# the block actually imposes -- the lower end is only n^{-0.960}, so any choice
# inside (0.360, 0.440) clears BOTH readings. The tighter reading is used here.)
#
# WHY 0.40 AND NOT AN ENDPOINT. Three reasons, in the order they bind.
#   (1) It is the MIDPOINT of (0.360, 0.440): the exponent margin is 0.040 to
#       each end, which is the largest simultaneous margin available. An
#       endpoint buys margin against one hypothesis by spending all of it
#       against the other.
#   (2) It is where the C3 family's constants have SATURATED. lambda_min of the
#       boundary Gram and sup|Theta_I| are flat in |I| = |X|/h_x once |I| >= 9.4
#       (1.507e-05 and 17.427, the half-line limits) and deteriorate steeply
#       below it -- 2.579e-06 and 22.11 at the |I| = 3.47 that n^{-0.20} gives
#       at n = 500. At 0.40 the binding cell n = 500 sits at |I| = 12.01, inside
#       the [10.1, 12.4] the application realises, so Section 5's smoother is in
#       the same interval geometry as Section 6's rather than extrapolating from
#       it; 0.36 would put it at 9.37, on the knee.
#   (3) The finite-n price is paid through omega_n asymp h_x^{-1/2}, hence
#       through the cap bar_m_n asymp h_x^{-1}, and is linear in the exponent
#       move; 0.44 would cost a further factor 1.28 in the cap at n = 500 for no
#       gain, the constants having already saturated at 0.40.
# The often-quoted n h_x count -- 41.6 at n = 500, against 33-53 across the
# window -- is NOT the operative count on this arm and is recorded here so that
# it is not read as one: the x-smoother acts on a KNOWN function (vdagger and
# the sieve basis) evaluated on a fixed quadrature grid, not on noisy responses,
# so no variance is averaged over n h_x design points. The count that does bind
# is nodes per bandwidth, N_XGRID * h_x, which is what the phi-step arm's
# quadrature rule is chosen against.
#
# WHY THE DEFAULT IS STILL 0.20, WHICH IS THE REVERSE OF THE ROUND-2 FIX ABOVE.
# band_hx()'s DEFAULT has exactly one live consumer, and it is not an estimator:
# sim_thm_rootn_l2identity.R, the binary-identity certificate, calls
# band_hx(NGRID) under two source states and compares with identical(). Its
# baseline is frozen at the pre-cardinality state, so a changed default would
# make it report a mismatch that has nothing to do with what it certifies, and
# it exits 1 on any mismatch. The default is therefore pinned to the superseded
# value and named as such. EVERY ARM THAT BUILDS A SMOOTHER PASSES THE EXPONENT
# EXPLICITLY -- there is one such arm, sim_thm_rootn_phistep.R, and it passes
# HX_EXP_PHI. A reader tracing h_x into an estimator never reads the default.
HX_EXP_SHIPPED <- 0.20     # superseded; retained only for the identity certificate
HX_EXP_PHI     <- 0.40     # the phi-step arm's h_x, inside (0.360, 0.440)
band_hx <- function(n, ex = HX_EXP_SHIPPED) n^(-ex)

#' eq:normconst. omega_n asymp h_u^{-1} h_x^{-1/2}, with the proportionality
#' constant a PRODUCT OF REALISED QUANTITIES -- the kernel sup-norm c_2, the
#' Bierens constant c_Pi of B1(iv.c), the support half-width c_C and ||1/pi||_inf
#' (= 1 under D7) -- not a free 1. Every factor is supplied by the caller and
#' the realised value is reported in the stopping table.
omega_norm <- function(hu, hx, c_2, c_Pi, c_C, inv_pi_sup = 1) {
  2 * sqrt(2 * c_C) * c_2^2 * c_Pi * inv_pi_sup * hu^(-1) * hx^(-0.5)
}

#' eq:cap: bar_m_n >= omega_n^2 delta-hat_n^{-2}. omega is passed in from
#' omega_norm() so that the cap and the operator normalisation used by the
#' Landweber iteration are THE SAME NUMBER by construction.
cap_mbar <- function(omega, n, cfg = CFG) {
  ceiling(omega^2 * rate_delta_hat(n, cfg)^(-2))
}

#' The round-9 predecessor of eq:cap, kept for the Panel-B comparison.
cap_mbar_old <- function(n, cfg = CFG) ceiling(rate_delta_hat(n, cfg)^(-2))

# ---- Parallel discipline ---------------------------------------------------
#
# ROUND-2 FIX (critic finding E). Every parallel arm previously used
# detectCores() - 1. With mc.preschedule = TRUE, mclapply splits seq_len(B) into
# mc.cores contiguous chunks and hands each chunk one forked child with its own
# L'Ecuyer substream, so the replication -> substream map -- and therefore every
# number in every table -- is a function of mc.cores. Taking it from the host
# made "reproduce with run_all.R" false anywhere but an 8-core machine. It is now
# a FIXED CONSTANT: the arms are reproducible on any host, and a machine with
# fewer physical cores pays only in wall time.
SIM_CORES <- 8L

#' Atomic, interruption-tolerant checkpoint write.
#'
#' A bare saveRDS() into the checkpoint path is a single point of failure for a
#' multi-hour arm: a signal delivered while gzfile() is open raises
#' "cannot open the connection ... Interrupted system call" and the whole run
#' dies with every completed cell lost from that write onward. It is also
#' non-atomic, so an interruption mid-write leaves a truncated file that the next
#' run cannot read. This writes to a temporary file in the same directory and
#' renames it into place -- rename(2) is atomic within a filesystem -- and
#' retries a few times on failure.
save_ckpt <- function(obj, path, tries = 5L) {
  for (k in seq_len(tries)) {
    ok <- tryCatch({
      tmp <- paste0(path, ".tmp", Sys.getpid())
      saveRDS(obj, tmp)
      if (!file.rename(tmp, path)) stop("rename failed")
      TRUE
    }, error = function(e) {
      warning(sprintf("checkpoint write attempt %d failed: %s", k,
                      conditionMessage(e)), call. = FALSE)
      FALSE
    })
    if (isTRUE(ok)) return(invisible(TRUE))
    Sys.sleep(0.5 * k)
  }
  warning("checkpoint could not be written; the run continues in memory",
          call. = FALSE)
  invisible(FALSE)
}

#' Compare a reloaded design matrix with a live one, for checkpoint validity.
#'
#' 2026-08-03 FIX. CHECKPOINT RESUME HAD NEVER WORKED IN ANY ARM.
#'
#' The limit-law and phi-step arms both guarded their checkpoint with
#'     identical(old$design, DESIGN)
#' on a data.table. A data.table carries an .internal.selfref EXTERNAL POINTER,
#' and an external pointer serialises to the null pointer, so a reloaded design
#' carries <pointer: 0x0> where a live one carries a real address and
#' identical() is ALWAYS FALSE -- whatever the cells say. Minimal reproduction:
#'
#'     d <- data.table(a = 1:3); saveRDS(list(design = d), f); old <- readRDS(f)
#'     identical(old$design, d)                                # FALSE
#'     identical(as.data.frame(old$design), as.data.frame(d))  # TRUE
#'
#' Every checkpoint those two arms were ever handed was therefore discarded and
#' every long run restarted from zero, and the failure is INVISIBLE: the script
#' reports that it is starting fresh, which is what it would say if there were
#' no checkpoint at all. Confirmed against this project's own files: the
#' limit-law checkpoint holds 60 of 60 completed cells and the phi-step one 36
#' of 36, and both fail the shipped test and pass this one.
#'
#' Found while auditing the headroom arm, whose fp_norm() carries the same fix
#' written locally (sim_thm_rootn_headroom.R) and is the only guard in the
#' project that has ever fired. Coercing to data.frame drops the pointer and
#' compares what is meant -- the cells, their types, their order and the column
#' names -- and nothing else. It is NOT a loosening: as.data.frame() keeps
#' storage modes, so an integer column that became double still fails.
#'
#' @param a,b data.table or data.frame. The reloaded and the live design.
#' @return TRUE if the two describe the same cells in the same order.
same_design <- function(a, b) identical(as.data.frame(a), as.data.frame(b))

# ---- DGP specifications ----------------------------------------------------

#' Build a DGP specification.
#'
#' @param name "A" (favourable) or "B" (stress; no assumption violated).
#' @param L_cells integer >= 2. The instrument's cardinality, sans-L of
#'   eq:contrast: W takes values in {0, 1, ..., L_cells - 1} with cell 0 the
#'   base cell. The default 2 IS the shipped binary design, primitive for
#'   primitive; see design decision D8 for what a larger cardinality forces and
#'   for the rule that generates it.
#' @return list of primitives.
dgp_spec <- function(name = c("A", "B"), L_cells = 2L) {
  name <- match.arg(name)
  L_cells <- as.integer(L_cells)
  stopifnot(length(L_cells) == 1L, !is.na(L_cells), L_cells >= 2L)
  base <- list(
    name        = name,
    p           = 4L,                       # dZ = (1, Z1, Z2, Z3)
    theta       = c(0.30, 1.00, -0.50, 0.25),
    c_phi       = 1.00,                     # amplitude of phi_dagger
    sigma_xi    = 0.80,                     # individual component of X*
    sigma_v     = 0.70,                     # idiosyncratic component of X*
    varsigma_x  = 1.25,                     # scale in X = Phi_norm(X* / varsigma_x)
    rho_uv      = 0.60,                     # endogeneity: dU loads on V2 - V1
    sigma_e     = 0.70,
    s_mix       = 1.0,                      # scale-mixture second point
    p_mix       = 0.0,                      # mass on the second point
    eps_varrho  = 0.10,                     # A4(i) overlap
    gamma0      = 0.00,
    gamma       = c(0.90, -0.60, 0.45),     # varrho index coefficients
    a_w         = 1.10,                     # instrument strength: X2* shift
    sigma_z     = matrix(c(1.00, 0.30, 0.15,
                           0.30, 1.00, 0.25,
                           0.15, 0.25, 1.00), 3, 3),
    z_mean      = c(0.35, -0.20, 0.10)      # E[Z] != 0 keeps nu_{dZ} non-trivial
  )
  if (name == "B") {
    # Stress: all four moves stay strictly inside the hypotheses.
    #  - overlap tightened to the edge of A4(i) but not through it;
    #  - instrument halved => the operator is closer to degenerate;
    #  - dU becomes a two-point Gaussian scale mixture: E[dU^4] < infinity, so
    #    (R-b) holds, but the fourth moment is 3.4x the Gaussian one;
    #  - E[Z] moved so that J is closer to singular while A1b(iv) still holds.
    #    (Round 3: this read "while A3 still holds". A3 is RETIRED -- dispatch
    #    13, because it is a theorem: lem:momzero(iv) gives J = E[dZ dZ'], whose
    #    nonsingularity is A1b(iv). The design point is unchanged; the tag was.)
    base$eps_varrho <- 0.03
    base$a_w        <- 0.55
    base$s_mix      <- 3.00
    base$p_mix      <- 0.10
    base$sigma_e    <- 0.55
    base$z_mean     <- c(0.10, -0.05, 0.03)
    base$gamma      <- c(1.30, -0.95, 0.70)
    base$sigma_z    <- matrix(c(1.00, 0.88, 0.82,
                                0.88, 1.00, 0.90,
                                0.82, 0.90, 1.00), 3, 3)
  }
  base$tau2 <- base$sigma_xi^2 + base$sigma_v^2      # Var(X_j*)

  # ---- what the cardinality forces (design decision D8) --------------------
  #
  # A4(i) requires eps_varrho < 1 / sans-L, and the design holds eps_varrho at
  # its shipped value across cardinalities rather than rescaling it, so the
  # bound is CHECKED here rather than assumed. It is not close to binding at the
  # cardinalities this project runs: 0.10 admits sans-L <= 9, 0.03 admits 33.
  base$L_cells <- L_cells
  if (base$eps_varrho >= 1 / L_cells) {
    stop(sprintf(paste("dgp_spec: A4(i) requires eps_varrho < 1/L, and this",
                       "design has eps_varrho = %.3f at L = %d"),
                 base$eps_varrho, L_cells))
  }
  # (a) Lc - 1 propensity index functions, cyclic shifts of the shipped gamma.
  #     At Lc = 2 this is the 1 x d_z matrix holding gamma itself.
  d_g <- length(base$gamma)
  base$gamma_mat <- t(vapply(seq_len(L_cells - 1L), function(l)
    base$gamma[((seq_len(d_g) - 1L + (l - 1L)) %% d_g) + 1L], numeric(d_g)))
  # (b) Lc first-stage shifts of X_2*, equally spaced on [0, a_w]. At Lc = 2
  #     this is (0, a_w), which is the shipped `a_w * w` for w in {0, 1}. The
  #     fractions are formed FIRST so that the endpoint is exactly a_w.
  base$shift <- base$a_w * ((seq_len(L_cells) - 1) / (L_cells - 1))
  base
}

# ---- Cardinality accessors: the ONE place the binary default lives ---------
#
# sim_thm_rootn_headroom_dgp.R builds its own d_Z = 1 specs (hr_dgp_spec) and
# its own representer (hr_solve_ell_star) WITHOUT going through dgp_spec() or
# solve_ell_star(), and it consumes the shared varrho_fun, cond_dens_x,
# ell_star_eval, L_star_eval, draw_dell, pop_J_Sigma and dgp_validate. Every
# such object predates the cardinality parameter and is BINARY. Rather than
# reach into a file this change does not own, the shared functions read the
# cardinality through these accessors, which return the binary reading -- and
# the binary DERIVED primitives, matrix(gamma) and (0, a_w) -- for any spec or
# representer that declares none. There is no other default anywhere.

#' The instrument's cardinality declared by a spec; 2 if it declares none.
spec_L <- function(spec) if (is.null(spec$L_cells)) 2L else spec$L_cells

#' The (Lc-1) x d_z matrix of propensity index slopes; the binary row if absent.
spec_gmat <- function(spec) {
  if (is.null(spec$gamma_mat)) matrix(spec$gamma, 1L, length(spec$gamma))
  else spec$gamma_mat
}

#' The Lc first-stage shifts of X_2*; the binary pair (0, a_w) if absent.
spec_shift <- function(spec) if (is.null(spec$shift)) c(0, spec$a_w) else spec$shift

#' The cardinality a fitted representer was solved at; 2 if it declares none.
es_L <- function(es) if (is.null(es$L_cells)) 2L else es$L_cells

#' Structural function, centred on V under pi = Uniform[0,1] (D7).
phi_dagger <- function(x, spec) spec$c_phi * sin(2 * pi * x)

#' The Lc - 1 propensity indices, one row of gamma_mat each (design decision D8).
#'
#' @return numeric matrix n x (Lc - 1). At Lc = 2 the single column is the
#'   shipped index gamma0 + zc gamma.
varrho_index <- function(zc, spec) {
  idx <- zc %*% t(spec_gmat(spec))
  idx + spec$gamma0
}

#' Propensity varrho(dZ) = (varrho_1, ..., varrho_{Lc-1}), A4(i)-(ii).
#'
#' Multinomial logit on the indices of varrho_index(), with the BASE cell's
#' index normalised to zero, mixed with the uniform simplex point so that every
#' cell -- base included -- clears A4(i)'s floor by construction:
#'
#'     varrho_l  =  eps + (1 - Lc eps) S_l(z),      l = 0, 1, ..., Lc - 1,
#'     S_l       =  softmax_l(0, index_1, ..., index_{Lc-1}),
#'
#' so varrho_0 = 1 - sum_{l>=1} varrho_l = eps + (1 - Lc eps) S_0 >= eps as
#' well, and A4(i)'s eps_varrho < 1/Lc is exactly what keeps the mixing weight
#' 1 - Lc eps positive. The base index is the zero column of the softmax and
#' carries no free parameter, which is the usual multinomial-logit normalisation.
#'
#' AT Lc = 2 THIS IS THE SHIPPED EXPRESSION, BIT FOR BIT, AND THAT IS THE POINT.
#' The softmax denominator is formed in the SHIFTED way, sum_k exp(index_k -
#' index_l), so that at Lc = 2, l = 1 it is exp(-index) + exp(0) = exp(-index) +
#' 1; the floor mix is then a SINGLE division, eps + (1 - 2 eps) / (1 + exp(-
#' index)), which is the pre-2026-08-14 line character for character. Writing it
#' as (1 - 2 eps) * S with S formed first would NOT be bit-identical -- a * (1/D)
#' and a/D differ in the last place -- and the binary tables would move. The
#' accumulation is a plain double `+` loop rather than rowSums() for the same
#' reason: rowSums() accumulates in long double.
#'
#' @return numeric vector of length n when Lc = 2 (R's drop convention, and what
#'   the four binary arms consume), numeric matrix n x (Lc - 1) when Lc >= 3.
varrho_fun <- function(zc, spec) {
  Lc  <- spec_L(spec)
  idx <- varrho_index(zc, spec)
  den <- matrix(0, nrow(idx), Lc - 1L)
  for (l in seq_len(Lc - 1L)) {
    dl <- exp(-idx[, l])                                   # the base cell, k = 0
    for (k in seq_len(Lc - 1L)) dl <- dl + exp(idx[, k] - idx[, l])
    den[, l] <- dl
  }
  out <- spec$eps_varrho + (1 - Lc * spec$eps_varrho) / den
  if (Lc == 2L) as.vector(out) else out
}

#' Sum the contrast index out of a contrast-indexed object.
#'
#' The one place in this project where the l index of eq:contrast is contracted.
#' It exists so that no caller has to branch on the cardinality: at Lc = 2 the
#' object is the printed n x p matrix and Wtilde is a scalar per observation, so
#' the contraction is the shipped elementwise product.
#'
#' @param A n x p matrix (Lc = 2) or n x p x (Lc-1) array (Lc >= 3), e.g.
#'   ell_star or L_star evaluated at a sample.
#' @param wt length-n vector (Lc = 2) or n x (Lc-1) matrix (Lc >= 3): Wtilde.
#' @return n x p matrix, the R^p-valued product A Wtilde of eq:psidef / eq:JSig.
contract_w <- function(A, wt) {
  if (length(dim(A)) == 2L) return(wt * A)
  out <- matrix(0, dim(A)[1L], dim(A)[2L])
  for (l in seq_len(dim(A)[3L])) out <- out + A[, , l] * wt[, l]
  out
}

#' Per-observation squared FROBENIUS norm of a contrast-indexed object.
#'
#' The instrument block's type declaration fixes the norm carried by L, ell and
#' their hatted variants as Frobenius, so the size eq:foldrates prices is the
#' Frobenius norm over BOTH the theta index and the contrast index. At Lc = 2
#' that is the shipped rowSums(A^2); the array case reshapes rather than
#' apply()s, which is the same arithmetic at a fraction of the cost.
#'
#' @param A n x p matrix (Lc = 2) or n x p x (Lc-1) array (Lc >= 3).
#' @return numeric vector of length n.
row_sqnorm <- function(A) {
  if (length(dim(A)) == 2L) return(rowSums(A^2))
  rowSums(matrix(A^2, dim(A)[1L]))
}

#' Draw one sample of n differenced observations.
#'
#' Returns a list with all objects a Part-I result refers to, including the
#' latent scale indicator so that population conditionals stay closed form.
dgp_draw <- function(n, spec) {
  Lc <- spec_L(spec)
  zc <- matrix(rnorm(n * 3), n, 3) %*% chol(spec$sigma_z)
  zc <- sweep(zc, 2, spec$z_mean, "+")
  dz <- cbind(1, zc)                                 # p = 4
  rr <- varrho_fun(zc, spec)
  rm <- as.matrix(rr)                                # n x (Lc - 1)
  # Inverse-CDF cell draw from ONE uniform, cells ordered 1, 2, ..., Lc-1, then
  # the base cell 0 last. That order is not arbitrary: at Lc = 2 it makes the
  # rule `w = 1 iff u < varrho_1`, which is the shipped `as.numeric(runif(n) <
  # rr)` realisation for realisation, not merely in distribution.
  uu <- runif(n)
  w  <- numeric(n)                                   # 0 = base cell
  cs <- rm[, 1L]
  w[uu < cs] <- 1
  if (Lc > 2L) {
    for (l in 2:(Lc - 1L)) {
      lo <- cs
      cs <- cs + rm[, l]
      w[uu >= lo & uu < cs] <- l
    }
  }
  # Wtilde of eq:contrast: 1{W = l} - varrho_l, l = 1, ..., Lc - 1.
  wt <- if (Lc == 2L) w - rr else
    vapply(seq_len(Lc - 1L), function(l) as.numeric(w == l), numeric(n)) - rm

  xi <- rnorm(n, sd = spec$sigma_xi)
  v1 <- rnorm(n, sd = spec$sigma_v)
  v2 <- rnorm(n, sd = spec$sigma_v)
  sc <- ifelse(runif(n) < spec$p_mix, spec$s_mix, 1)

  x1s <- xi + v1                                     # a_1 = 0
  x2s <- xi + spec_shift(spec)[as.integer(w) + 1L] + v2   # a_2 = shift[w]
  x1  <- pnorm(x1s / spec$varsigma_x)
  x2  <- pnorm(x2s / spec$varsigma_x)

  du <- spec$rho_uv * (v2 - v1) + sc * spec$sigma_e * rnorm(n)
  dy <- phi_dagger(x2, spec) - phi_dagger(x1, spec) +
        as.vector(dz %*% spec$theta) + du

  list(n = n, dz = dz, zc = zc, w = w, varrho = rr, wt = wt,
       x1 = x1, x2 = x2, du = du, dy = dy, sc = sc)
}

# ---- Population machinery for ell_star (design decision D1) -----------------
#
# The conditional law of (X1*, X2*, dU) given (W = w, S = s) is trivariate
# normal, which is what makes nu_g computable in closed form:
#     mean   (0, a_w w, 0)
#     Var(Xj*) = tau2,  Cov(X1*, X2*) = sigma_xi^2
#     Var(dU)  = omega_s^2 = 2 rho^2 sigma_v^2 + s^2 sigma_e^2
#     Cov(X1*, dU) = -rho sigma_v^2,  Cov(X2*, dU) = +rho sigma_v^2
# Hence Xj* | (w, s, dU = u) ~ N(a_j w + b_{j,s} u, v_{j,s}).

#' Conditional density of X_j (on [0,1]) given (W = w, S = s, dU = u).
cond_dens_x <- function(xg, j, w, s, u, spec) {
  om2 <- 2 * spec$rho_uv^2 * spec$sigma_v^2 + s^2 * spec$sigma_e^2
  cv  <- if (j == 1) -spec$rho_uv * spec$sigma_v^2 else spec$rho_uv * spec$sigma_v^2
  b   <- cv / om2
  vv  <- spec$tau2 - cv^2 / om2
  m   <- (if (j == 1) 0 else spec_shift(spec)[w + 1L]) + b * u     # length(u)
  q   <- qnorm(xg)
  xs  <- spec$varsigma_x * q
  jac <- spec$varsigma_x / dnorm(q)
  # outer over (x grid) x (u grid)
  outer(xs, m, function(A, M) dnorm(A - M, sd = sqrt(vv))) * jac
}

#' Marginal conditional density of X_j given W = w (dU and S integrated out).
cond_dens_x_marg <- function(xg, j, w, spec) {
  q   <- qnorm(xg)
  xs  <- spec$varsigma_x * q
  jac <- spec$varsigma_x / dnorm(q)
  m   <- if (j == 1) 0 else spec_shift(spec)[w + 1L]
  dnorm(xs - m, sd = sqrt(spec$tau2)) * jac
}

#' Bounded, C^1 basis in u for ell (A2b needs boundedness and continuous
#' u-differentiability; a Chebyshev polynomial of tanh(u/c) delivers both).
ell_basis_u <- function(u, Q, c_u) {
  tt <- tanh(u / c_u)
  out <- matrix(0, length(u), Q)
  out[, 1] <- 1
  if (Q >= 2) out[, 2] <- tt
  if (Q >= 3) for (q in 3:Q) out[, q] <- 2 * tt * out[, q - 1] - out[, q - 2]
  out
}

#' Solve the balancing equation nu_{dZ + ell Wtilde}(x) == 0 for ell_star.
#'
#' The z-side of ell uses the Lc modes {1, varrho_1(z), ..., varrho_{Lc-1}(z)}:
#' the (W, S)-pattern of the right-hand side has one component per cell, so Lc
#' z-modes span it. At Lc = 2 that is the shipped pair {1, varrho}. The solve is
#' a ridge-stabilised linear least squares on an x-grid with L2[0,1] weights.
#'
#' ---------------------------------------------------------------------------
#' WHAT sans-L CHANGES HERE, WHICH IS MORE THAN A LOOP BOUND
#'
#' ell_star is R^{p x (Lc-1)}-valued, so the unknown is a coefficient block per
#' (contrast, z-mode, u-mode): the design matrix goes from Q n_r = 12 columns at
#' Lc = 2 to Q n_r (Lc - 1) = 72 at Lc = 4, and the cell weights A become the
#' 3-index array
#'     A[w, l, r] = E[ eta_r(Z) ( 1{w = l} - varrho_l(Z) ) P(W = w | Z) ],
#'         w = 0, ..., Lc-1,   l = 1, ..., Lc-1,   r = 1, ..., Lc,
#' which at Lc = 2 collapses to the shipped 2 x 2 matrix because 1{w=1} - varrho
#' is w - varrho when w is 0 or 1.
#'
#' A STRUCTURAL FACT WORTH RECORDING, because it is what the achieved residual
#' is up against and it is not an artefact of the design. Every slice
#' A[ , l, r] SUMS TO ZERO over w: sum_w P(W=w|Z)(1{w=l} - varrho_l) = 0
#' pointwise. So the cell patterns reachable by ell Wtilde span at most the
#' (Lc-1)-dimensional zero-sum subspace of R^{Lc}, while the right-hand side's
#' own pattern, Zbar[w, ] = E[dZ 1{W=w}], sums to E[dZ] and is NOT zero-sum.
#' The equation is nevertheless solvable to the residual reported below, because
#' nu only sees x and the Lc cell-conditional density differences are far from
#' linearly independent as functions of x. This is why the achieved residual is
#' MEASURED and exported (dgp_validate, and the design-validity table of every
#' arm) instead of being taken on trust -- at Lc = 2 and at Lc = 4 alike, and at
#' the same ridge.
#'
#' @param ridge absolute Tikhonov constant added to the Gram diagonal. It is
#'   NOT rescaled with the cardinality: the whole value of the cardinality
#'   contrast is that one factor moves, so the regularisation of the population
#'   solve is held fixed and the achieved balancing residual is reported at both
#'   cardinalities. If a cardinality cannot clear the binary design's residual at
#'   this ridge, that is a finding to report, not a tolerance to loosen.
solve_ell_star <- function(spec, Q = 6L, c_u = 1.5, n_x = 401L, n_u = 241L,
                           n_z = 60000L, ridge = 1e-10, seed_z = 90210L) {
  Lc  <- spec_L(spec)
  nL1 <- Lc - 1L
  xg <- seq(0.002, 0.998, length.out = n_x)
  wx <- rep((xg[2] - xg[1]), n_x)

  # u-grid and marginal density of dU by mixture component.
  s_pts <- if (spec$p_mix > 0) c(1, spec$s_mix) else 1
  s_prb <- if (spec$p_mix > 0) c(1 - spec$p_mix, spec$p_mix) else 1
  sd_du_s <- sqrt(2 * spec$rho_uv^2 * spec$sigma_v^2 + s_pts^2 * spec$sigma_e^2)
  ug <- seq(-6 * max(sd_du_s), 6 * max(sd_du_s), length.out = n_u)
  wu <- rep(ug[2] - ug[1], n_u)

  # z-side expectations by W-cell, via a large fixed quadrature draw.
  zc <- with_fixed_seed(seed_z, {
    m <- matrix(rnorm(n_z * 3), n_z, 3) %*% chol(spec$sigma_z)
    sweep(m, 2, spec$z_mean, "+")
  })
  rr  <- as.matrix(varrho_fun(zc, spec))                 # n_z x (Lc - 1)
  dz  <- cbind(1, zc)
  eta <- cbind(1, rr)                                    # z-modes, n_z x Lc
  n_r <- ncol(eta)

  # A[w, l, r] = E[(1{w = l} - varrho_l) eta_r 1{W = w}], Zbar_w = E[dZ 1{W=w}].
  pw <- cbind(1 - rowSums(rr), rr)                       # P(W = 0), ..., P(W = Lc-1)
  A_wlr <- array(0, c(Lc, nL1, n_r))
  Zbar  <- array(0, c(Lc, spec$p))
  for (wi in seq_len(Lc)) {
    w <- wi - 1
    for (l in seq_len(nL1)) {
      A_wlr[wi, l, ] <- colMeans((as.numeric(w == l) - rr[, l]) * eta * pw[, wi])
    }
    Zbar[wi, ] <- colMeans(dz * pw[, wi])
  }

  # Right-hand side: nu_{dZ}(x), p x n_x.
  rhs <- matrix(0, spec$p, n_x)
  for (wi in seq_len(Lc)) {
    w  <- wi - 1
    d2 <- cond_dens_x_marg(xg, 2, w, spec)
    d1 <- cond_dens_x_marg(xg, 1, w, spec)
    rhs <- rhs + outer(Zbar[wi, ], d2 - d1)
  }

  # Design: K[x, (l, r, q)] = sum_w A[w,l,r] E_{S,dU}[ phi_q(dU) (f2 - f1) ].
  # Column (l, r, q) sits at ((l-1) n_r + (r-1)) Q + q, so at Lc = 2 the block
  # layout is the shipped ((r-1) Q + q) unchanged.
  PhiU <- ell_basis_u(ug, Q, c_u)                        # n_u x Q
  fdu  <- rowSums(vapply(seq_along(s_pts), function(k)
            s_prb[k] * dnorm(ug, sd = sd_du_s[k]), numeric(n_u)))
  Kmat <- matrix(0, n_x, Q * n_r * nL1)
  for (wi in seq_len(Lc)) {
    w <- wi - 1
    Dw <- matrix(0, n_x, n_u)
    for (k in seq_along(s_pts)) {
      fu_k <- s_prb[k] * dnorm(ug, sd = sd_du_s[k])
      Dw <- Dw + sweep(cond_dens_x(xg, 2, w, s_pts[k], ug, spec) -
                       cond_dens_x(xg, 1, w, s_pts[k], ug, spec), 2, fu_k, "*")
    }
    Gw <- (Dw * matrix(wu, n_x, n_u, byrow = TRUE)) %*% PhiU    # n_x x Q
    for (l in seq_len(nL1)) {
      for (ri in seq_len(n_r)) {
        b0 <- ((l - 1L) * n_r + (ri - 1L)) * Q
        cols <- (b0 + 1):(b0 + Q)
        Kmat[, cols] <- Kmat[, cols] + A_wlr[wi, l, ri] * Gw
      }
    }
  }

  sw <- sqrt(wx)
  Kw <- Kmat * sw
  G  <- crossprod(Kw) + ridge * diag(Q * n_r * nL1)
  cf <- matrix(0, spec$p, Q * n_r * nL1)
  for (m in seq_len(spec$p)) {
    cf[m, ] <- as.vector(solve(G, crossprod(Kw, -rhs[m, ] * sw)))
  }

  resid <- rhs + cf %*% t(Kmat)                            # p x n_x
  l2_resid <- sqrt(rowSums(resid^2 * matrix(wx, spec$p, n_x, byrow = TRUE)))
  l2_rhs   <- sqrt(rowSums(rhs^2   * matrix(wx, spec$p, n_x, byrow = TRUE)))

  # Antiderivative of the u-basis (zero anchor, D2): L_star(u,z) = int_0^u ell.
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
                 L_cells = Lc, ridge = ridge, n_col = ncol(cf),
                 l2_resid = l2_resid, l2_rhs = l2_rhs,
                 rel_resid = l2_resid / pmax(l2_rhs, 1e-12),
                 kappa_gram = kappa(G),
                 anti_fun = anti_fun, u_range = range(ug)),
            class = "ell_star")
}

#' Contract a coefficient block against a u-basis and the z-modes.
#'
#' The shared body of ell_star_eval() and L_star_eval(): the two differ only in
#' whether the u-factor is the basis or its antiderivative, and writing the loop
#' once removes the risk that a cardinality fix lands in one and not the other.
#'
#' @param Uf n x Q matrix, the u-factor evaluated at the sample.
#' @return n x p matrix when Lc = 2, n x p x (Lc-1) array when Lc >= 3.
ell_block_eval <- function(es, Uf, zc, spec) {
  eta <- cbind(1, as.matrix(varrho_fun(zc, spec)))       # n x Lc
  nL1 <- es_L(es) - 1L
  out <- array(0, c(nrow(Uf), spec$p, nL1))
  for (l in seq_len(nL1)) {
    for (ri in seq_len(es$n_modes)) {
      b0 <- ((l - 1L) * es$n_modes + (ri - 1L)) * es$Q
      cols <- (b0 + 1):(b0 + es$Q)
      out[, , l] <- out[, , l] +
        (Uf %*% t(es$coef[, cols, drop = FALSE])) * eta[, ri]
    }
  }
  if (nL1 == 1L) out[, , 1L] else out
}

#' Evaluate ell_star(u, z): n x p (Lc = 2) or n x p x (Lc-1) (Lc >= 3).
ell_star_eval <- function(es, u, zc, spec) {
  ell_block_eval(es, ell_basis_u(u, es$Q, es$c_u), zc, spec)
}

#' Evaluate L_star(u, z) = int_0^u ell_star(v, z) dv (zero anchor, D2).
L_star_eval <- function(es, u, zc, spec) {
  uc <- pmin(pmax(u, es$u_range[1]), es$u_range[2])
  # matrix() pins the shape: vapply collapses to a plain vector at length(uc)=1.
  Au <- matrix(vapply(es$anti_fun, function(f) f(uc), numeric(length(uc))),
               nrow = length(uc))
  ell_block_eval(es, Au, zc, spec)
}

#' Population J and Sigma (eq:JSig) by a large pilot draw, with the pilot's own
#' Monte Carlo standard errors -- these enter the error budget alongside B.
pop_J_Sigma <- function(spec, es, n_pilot = 4e6L, chunk = 5e5L, seed = 20260730L) {
 with_fixed_seed(seed, {
  p <- spec$p
  J_acc <- matrix(0, p, p); S_acc <- matrix(0, p, p)
  S_sq  <- matrix(0, p, p); J_sq  <- matrix(0, p, p)
  n_done <- 0L
  while (n_done < n_pilot) {
    m <- min(chunk, n_pilot - n_done)
    d <- dgp_draw(m, spec)
    ell <- ell_star_eval(es, d$du, d$zc, spec)
    Ls  <- L_star_eval(es, d$du, d$zc, spec)
    psi <- d$dz * d$du + contract_w(Ls, d$wt)                 # eq:psistar
    Jt  <- d$dz + contract_w(ell, d$wt)                       # g_star rows
    J_acc <- J_acc + crossprod(Jt, d$dz)
    J_sq  <- J_sq  + crossprod(Jt^2, d$dz^2)
    S_acc <- S_acc + crossprod(psi)
    S_sq  <- S_sq  + crossprod(psi^2)
    n_done <- n_done + m
  }
  J <- J_acc / n_pilot
  S <- S_acc / n_pilot
  J_se <- sqrt(pmax(J_sq / n_pilot - J^2, 0) / n_pilot)
  S_se <- sqrt(pmax(S_sq / n_pilot - S^2, 0) / n_pilot)
  Ji <- solve(J)
  list(J = J, Sigma = S, V = Ji %*% S %*% t(Ji), Jinv = Ji,
       J_se = J_se, Sigma_se = S_se, n_pilot = n_pilot)
 })
}

#' Report how nearly the design satisfies the hypotheses it is built on.
dgp_validate <- function(spec, es, pop, n_check = 4e5L, seed = 77001L) {
  d <- with_fixed_seed(seed, dgp_draw(n_check, spec))
  ell <- ell_star_eval(es, d$du, d$zc, spec)
  Ls  <- L_star_eval(es, d$du, d$zc, spec)
  psi <- d$dz * d$du + contract_w(Ls, d$wt)
  # A4(i) is a floor on EVERY cell, base cell 0 included, so the full simplex is
  # rebuilt here; min_varrho / max_varrho keep their shipped meaning (the range
  # of the NON-BASE coordinates) so the binary design-validity table is
  # unchanged, and min_cell_prob is the quantity A4(i) actually names.
  rr_all <- cbind(1 - rowSums(as.matrix(d$varrho)), as.matrix(d$varrho))
  # lambda_min(Omega) of eq:omegadef. Closed form at Lc = 2 (Omega is the scalar
  # varrho(1-varrho)); at Lc >= 3 an eigenvalue per observation, so it is read on
  # a fixed 20,000-row prefix -- varrho is a smooth function of z and the floor
  # is a population statement, not a tail event.
  n_om <- min(n_check, 20000L)
  Om_min <- if (spec_L(spec) == 2L) min(rr_all[, 1] * rr_all[, 2]) else
    min(apply(as.matrix(d$varrho)[seq_len(n_om), , drop = FALSE], 1, function(q)
      min(eigen(diag(q, length(q)) - tcrossprod(q), symmetric = TRUE,
                only.values = TRUE)$values)))
  list(
    balancing_rel_resid = max(es$rel_resid),         # A2, design decision D1
    mean_psi            = colMeans(psi),             # lem:momzero(i)
    mean_psi_se         = apply(psi, 2, sd) / sqrt(n_check),
    E_dz_du             = colMeans(d$dz * d$du),     # restriction (B)
    kappa_J             = kappa(pop$J),              # A1b(iv); A3 is retired
    min_varrho          = min(d$varrho),             # A4(i)
    max_varrho          = max(d$varrho),
    E_du4               = mean(d$du^4),              # (R-b)
    E_dznorm4           = mean(rowSums(d$dz^2)^2),   # (R-b)
    sd_du               = sd(d$du),
    ell_sup             = max(abs(ell)),             # A2'(i.a) budget, empirical
    # --- cardinality-aware additions (D8); absent from no binary table -------
    L_cells             = spec_L(spec),
    min_cell_prob       = min(rr_all),               # A4(i) as stated, all cells
    eps_varrho          = spec$eps_varrho,
    eps_Omega_thy       = spec$eps_varrho / spec_L(spec),   # eq:omegafloor
    lambda_min_Omega    = Om_min,                    # realised, against the floor
    cell_shares         = colMeans(rr_all),
    n_ell_col           = if (is.null(es$n_col)) ncol(es$coef) else es$n_col,
    kappa_gram          = if (is.null(es$kappa_gram)) NA_real_ else es$kappa_gram
  )
}

# ---- RNG discipline (INV-14) -----------------------------------------------
#
# Each SCRIPT calls set.seed() exactly once, at its top. The functions below are
# the one exception and it is deliberate: the POPULATION constants of a DGP --
# ell_star, J, Sigma, the perturbation-basis norms -- must be identical in every
# run and in every replication, so they are computed under a fixed, named seed
# that is local to the call and is REVERTED afterwards. The Monte Carlo stream
# is therefore untouched: a replication draws exactly what it would have drawn
# had these helpers never run.
#
# with_fixed_seed() is the only place in this project's simulation code where
# set.seed() is called outside a script header, and it never appears inside a
# parallel worker's replication path.

#' Evaluate expr under a fixed seed, restoring the caller's RNG state.
with_fixed_seed <- function(seed, expr) {
  had <- exists(".Random.seed", envir = globalenv())
  old <- if (had) get(".Random.seed", envir = globalenv()) else NULL
  set.seed(seed)
  on.exit({
    if (had) assign(".Random.seed", old, envir = globalenv())
    else if (exists(".Random.seed", envir = globalenv()))
      rm(".Random.seed", envir = globalenv())
  }, add = TRUE)
  force(expr)
}
