# ============================================================================
# sim_thm_rootn_phistep.R   --   PRIORITIES 4 AND 5
#
# THE phi-STEP OF def:lfstep, RUN FOR REAL.
#
# (4) THE STOPPING RULE AND THE ITERATION CAP. eq:cap was repriced in dispatch
#     10 from bar_m_n >= delta-hat_n^{-2} to bar_m_n >= omega_n^2 delta-hat_n^{-2},
#     and prp:stopfeas records that at the frontier-clearing configuration this
#     puts bar_m_n in (n^{0.848}, n^{1.16}) against delta-hat_n^{-2} = n^{0.64},
#     so "at n = 2000 that is an inflation of the iteration budget by a factor
#     between about 5 and about 50 -- 130 Landweber steps become between 630 and
#     6750". This arm measures where the discrepancy principle actually stops,
#     against both the old and the new cap, and how often it saturates.
#
# (5) THE CONDITION NUMBER. Two DIFFERENT objects are reported, because
#     results.tex warns in terms that "a round-11 cross-reference conflated them":
#       - the L_x-dimensional COMPRESSION of eq:compress,
#         P_{S_n} A-hat* A-hat |_{S_n}, which is what (P-a.3) is stated at and
#         what governs the Landweber iteration; and
#       - the n_m-dimensional GRAM MATRIX of eq:gram, the Gram of the n_m
#         functions g-hat_{.,.,i} in L^2(Pi), which prp:tccrepair(iii) needs and
#         which results.tex expressly DECLINES as open item Q-4.
#     Condition numbers, not numerical ranks: a rank is a thresholded,
#     basis-dependent artefact, and the uniform-invertibility hypotheses are
#     statements about the conditioning.
#
# A LEPSKII ARM is included. rem:tccwhy(2b) registers a balancing stop as "a live
# alternative rather than a foreclosed one ... the third arm of probe CP-13", and
# notes that what blocks it in the theory is that "a Lepskii stop over m would
# need a variance proxy at each candidate index that the operator-noise model of
# this paper does not supply without a further bound". The proxy is therefore
# SUPPLIED HERE and declared (design decision D10).
#
# ---------------------------------------------------------------------------
# SIMULATION-DESIGN DECISIONS SPECIFIC TO THIS ARM
#
# D8.  THE PRELIMINARY phi-hat^(0). (P-a.2) needs a KNOWN deterministic
#      envelope eps-hat_0 = O(n^{-varsigma_0}) with varsigma_0 > kappa alpha /
#      (4(2 kappa - 1)) = 0.107 at this configuration, and rem:rootnscope(3)
#      records that no file supplies phi-hat^(0) (open item Q-1). Two
#      preliminaries are run and reported side by side:
#        "zero"     phi-hat^(0) = 0, eps-hat_0 = ||phi_dagger||. This is what an
#                   analyst with no supplier has. It VIOLATES (P-a.2)'s rate
#                   requirement (varsigma_0 = 0) and is reported as such.
#        "rate"     phi-hat^(0) = P_{S_n} phi_dagger + noise of L2(pi) size
#                   n^{-0.15}, so varsigma_0 = 0.15 > 0.107 and (P-a.2) holds by
#                   construction. This is an INJECTION, not an estimator.
#      The contrast is the measurable cost of Q-1.
#
# D9.  THE TUNING CONSTANTS c_14 and c_15 of eq:lfsched. def:lfstep says in terms
#      that they "must be CHOSEN, because they are not identified by the data",
#      that the constants they must dominate (c_16, c_17) are "not known to the
#      analyst", and that chosen too small "the discrepancy guarantee is void and
#      the estimator is whatever the cap returns". c_14 is therefore swept over
#      five decades and the whole stopping curve reported; see the note at
#      C14_SET below for why the range is logarithmic and not {0.5, 1, 2}.
#
# D10. THE LEPSKII VARIANCE PROXY. sigma(m) = delta-hat_n sqrt(m), the classical
#      Landweber noise-propagation bound for a normalised operator with unit
#      relaxation. The balancing constant is 1. This is the "further bound" that
#      rem:tccwhy(2b) says the paper's operator-noise model does not supply.
#
# D11. BOUNDARY ADJUSTMENT.  *** WITHDRAWN AND REPLACED 2026-08-16.  D11a BELOW
#      IS WHAT THIS ARM NOW RUNS; the text is kept because the closing sentence
#      was the load-bearing error and deleting it would delete the lesson. ***
#
#      D11 read: C3(ii) requires truncated moments up to order p_K - 1 at every
#      boundary index. What is implemented is the RENORMALISED kernel,
#      K((x-X)/h) / int_X K((y-X)/h) dy, which enforces the j = 0 truncated
#      moment exactly -- and the j = 0 moment is the one prp:hatAprop(iii)
#      consumes, since it is what makes int nu-hat dx = 0 and keeps A-hat*
#      inside V. The higher truncated moments are NOT enforced, so the boundary
#      bias is O(h_x) rather than O(h_x^{p_K}) within c_C h_x of an endpoint.
#      "This affects the phi-step's bias constant and nothing in the stopping or
#      conditioning questions this arm is run to answer."
#
#      THE LAST SENTENCE IS FALSE, AND IT IS FALSE IN THE SAME WAY THE sans-L = 4
#      EPISODE WAS: it prices a defect against a BUDGET when the failing object
#      is a HYPOTHESIS. eq:xsmoothbias is consumed at exactly one live site
#      (proofs.tex:8017, "eq:xsmoothbias feeds (P-g) and (N1) and nothing else"),
#      and (P-g) is a HYPOTHESIS of prp:phirate imported into thm:rootn by group
#      (T-5). A hypothesis does not have a budget to be small relative to: it
#      holds or it does not. Measured under D11 by sim_thm_rootn_bdrylayer.R, the
#      realised ratio sup_X |varphi_{h_x} - vdagger| / (h_u delta-hat_n) CLIMBS
#      monotonically across n = 125 ... 181,019 -- 3.05, 3.80, 3.73, 4.07, 4.39,
#      4.66, 5.21, 5.97, 6.91, 8.10, fitted slope +0.127 per ln n -- where (P-g)
#      requires O(1). Under D11 this arm's h_x therefore sat OUTSIDE the window
#      in which prp:phirate's conclusion is available at all, and every number it
#      reports downstream of delta_n was conditioned on a hypothesis that fails.
#
# D11a. BOUNDARY ADJUSTMENT: THE C3 FAMILY, AT A BANDWIDTH INSIDE THE WINDOW.
#      *** 2026-08-16. Two changes, and the ORDER matters. ***
#
#      (1) h_x MOVES FIRST, from n^{-0.20} to n^{-0.40}. The window is bounded
#          below by C5'(ii) inherited (h_x >> n^{-0.440}) and above by the
#          DEGRADED (P-g) (h_x = O(n^{-0.360})); 0.40 is its midpoint. The full
#          derivation, including why an endpoint is the wrong choice and why the
#          n h_x heuristic does not bind on this arm, is at HX_EXP_PHI in
#          sim_thm_rootn_dgp.R.
#      (2) THEN the kernel moves, from D11's renormalised kern8 to the order-8
#          boundary family of lem:bdryfam -- bdry_family() / bdry_theta() of
#          scripts/R/lf_panel.R, the SAME implementation Section 6 runs, sourced
#          rather than retyped.
#
#      WHY THAT ORDER AND NOT THE OTHER. *** THE ARGUMENT BELOW IS WITHDRAWN BY
#      R10, 2026-08-17, AND IT IS KEPT BECAUSE THE ERROR IN IT IS THE POINT. ***
#      It read: "the family's constants are functions of |I| = |X| / h_x, and
#      they are catastrophic at the h_x D11 shipped. At |I| = 3.47 the boundary
#      Gram has lambda_min = 2.579e-06 and the family realises sup|Theta_I| =
#      22.11; at |I| >= 9.4 both have SATURATED at their half-line limits,
#      1.507e-05 and 17.427 ... so applying the family at the old bandwidth would
#      have inflated the cap column by a further factor of about 2.6."
#
#      C3(ii)'s CONSTANTS ARE NOT FUNCTIONS OF |I|.  They are a sup over ALL of
#      frak-I, which contains the floor |I| = 2, so the "catastrophic" short
#      intervals are IN THE SUP at every bandwidth and there is nothing for the
#      bandwidth to protect them from.  What the retired env_consts(h_x) computed
#      was c_2 restricted to one interval length, a different object; see the
#      c_2(L) note at C2_OF_L.  The factor of 2.6 the ordering argument priced is
#      therefore EXACTLY 1, and Panel C''s "reverse order" column prints 1.00.
#      What survives, and it is the part that mattered, is the BANDWIDTH move
#      itself: 0.40 puts h_x inside the (P-g) window and 0.20 did not, and the
#      binding cell n = 500 sits at |I| = 12.01, inside the [10.1, 12.4]
#      Section 6 realises.  The order of the two changes is now immaterial.
#
#      WHAT THE FAMILY BUYS. eq:truncmom holds for j = 0..7 at EVERY design
#      point, not just j = 0, so the Taylor route at proofs.tex:7976-8057 kills
#      the terms it is written to kill and eq:xsmoothbias is restored. What D11
#      got right is not lost: j = 0 is still exact, so prp:hatAprop(iii) and the
#      int nu-hat dx = 0 identity are untouched.
#
# D11b. THE x-QUADRATURE IS SIMPSON, NOT TRAPEZOID, AND THAT -- NOT THE NODE
#      COUNT -- IS WHAT MAKES THE FAMILY REALISABLE.  *** 2026-08-16 ***
#
#      The family's defining property is an exact moment identity, and it is only
#      as exact as the rule that integrates it. MEASURED, worst over 401 design
#      points, j = 0 defect at n = 8000:
#          trapezoid  N =  241   2.84e-01      Simpson  N = 241   7.26e-03
#          trapezoid  N = 2401   2.86e-03      Simpson  N = 961   2.79e-05
#      Trapezoid is O(N^{-2}) and Simpson O(N^{-4}), and the integrand oscillates
#      on scale h_x, so HALVING h_x costs the trapezoid rule a factor ~8. Raising
#      the node count alone does not close this: matching Simpson-961 with the
#      trapezoid rule needs about 24,000 nodes, which would put the smoother at
#      roughly 130 s per replication against the operator build's 3.6 s.
#
#      THE COST CLAIM THAT MOTIVATED A BARE NODE INCREASE IS FALSE AND WAS
#      MEASURED, NOT ASSUMED. "The smoother is n x N_XGRID while the dominant
#      cost is the 780 x n x L_x operator build" holds at N = 241 (0.83 s against
#      7 x 0.60 = 4.2 s at n = 8000) and REVERSES at N = 2401 (12.6 s against
#      3.6 s). The operator is built ~7 times per replication and the smoother
#      once, which is what made the shipped balance work; at 10x the nodes the
#      one build dominates the seven. N_XGRID = 961 with Simpson is 100x more
#      accurate than N_XGRID = 2401 with trapezoid at 2.5x lower cost, and that
#      is why the node count moved by 4x rather than 10x.
#
# D11c. THE NODE COUNT GROWS WITH n, BECAUSE A CONSTANT ONE CANNOT DELIVER (P-g).
#      *** 2026-08-16, SECOND PASS. This supersedes D11b's CONSTANT N_XGRID = 961
#      while leaving its choice of RULE untouched; the rule was right and the
#      constancy was not. ***
#
#      WHAT THE FIRST PASS SHIPPED, AND HOW IT FAILED ITS OWN ACCEPTANCE TEST.
#      With N_XGRID fixed at 961, sim_thm_rootn_bdrylayer.R measured the (P-g)
#      ratio sup_X |varphi_{h_x} - vdagger| / (h_u delta-hat_n) falling from
#      3.00e-04 at n = 125 to 1.00e-05 at n = 2000 and then RISING again to
#      1.11e-02 at n = 181,019 -- a U, not a plateau, with fitted slope +0.647
#      per ln n against the +0.125 the D11 state showed. The LEVEL was fixed by
#      three to four orders and the SLOPE was not, and the slope is the test.
#
#      THE CAUSE, MEASURED AND NOT INFERRED. Comparing the realised bias on the
#      shipped grid against a 10,001-node reference: the two agree to four
#      figures up to n = 1000 and then separate by 5.4x, 24x, 2294x, 11738x,
#      11722x, 11645x. The rising branch is ENTIRELY QUADRATURE. Simpson error is
#      O((N h_x)^{-4}), and the prediction is checked rather than asserted: at
#      fixed N = 961 the j = 0 defect rises by 9.18 and 9.21 across the two 4x
#      steps of the grid, against the 9.19 that (N h_x)^{-4} gives.
#
#      WHY IT WAS INVISIBLE BEFORE. Under D11 the kernel bias was O(h_x), i.e.
#      0.14 to 0.81 across the grid, and it dwarfed a quadrature error of 1e-04.
#      Repairing the first-order defect is what exposed the second. This is worth
#      recording as a pattern and not just as an event: the arm's error budget
#      had two terms, one of them a hundred thousand times the other, and no
#      measurement of the total could see the smaller one.
#
#      THE FIX. h_x = n^{-0.40} is tied to n, so a CONSTANT node count lets
#      N h_x fall like n^{-0.40} and the defect rise like n^{1.6}. Holding
#      N h_x constant requires N proportional to n^{0.40}, which is nx_for()
#      above, anchored so that nx_for(500) is D11b's 961 and N h_x = 80 at every
#      cell: N = 961, 1675, 2915 at n = 500, 2000, 8000. Verified: the realised
#      defect then holds FLAT at 3.3e-07 across all three, against 3.3e-07,
#      3.0e-06, 2.8e-05 at the fixed count, and the (P-g) slope turns from +0.647
#      to -0.813.
#
#      COST, AND IT IS THE REASON THIS IS A SECOND PASS RATHER THAN THE FIRST.
#      The smoother is O(n N), so the n = 8000 cells cost about 3x more. That is
#      bought deliberately: a table whose printed (P-g) trend runs the wrong way
#      invites exactly one referee question, and a footnote calling it a
#      quadrature artefact does less well than a column that does not need one.
#
# D12. NO CROSS-FITTING IN THIS ARM. def:crossfit runs def:lfstep on each fold
#      complement I_{-k}, of size asymptotically n. This arm runs it once on a
#      sample of size n and reports at that n; the fold structure is what the
#      limit-law arm carries.
#
# D13. Pi_t IS A QUADRATURE RULE, NOT A COUNTING MEASURE. *** ADDED IN ROUND 3,
#      critic finding (MAJOR). def:hatT integrates against Pi_t over ALL of T;
#      B1(iv.b) requires Pi_t to have a part not mutually singular with Lebesgue,
#      and B1(vi) -- which alone would have licensed a finite family with mass
#      growing in its point count -- IS RETIRED. Through round 2 this arm gave
#      each of the #T atoms WEIGHT 1, so the implemented Pi_t was counting
#      measure: its total mass equalled the point count (12/24/48/96 at those
#      grid sizes) and the L2(Pi) norm of a FIXED function grew like sqrt(#T)
#      (2.792 across an 8x refinement, against sqrt(8) = 2.828). Two things
#      followed and both were defects. (a) bar_m_n of eq:cap carried no Pi
#      scaling on delta-hat_n^{-2} while the residual it is compared against
#      carried sqrt(#T), so the cap grew LINEARLY in the point count and Panel
#      C's inflation ratio was a property of a free normalisation. (b) The
#      implemented measure was purely atomic, which B1(iv.b) excludes.
#
#      Pi_t is now UNIFORM on T = [-0.8, 0.8]^3 with quadrature weights
#      vol(T)/#T = 1.6^3/#T per atom. THE ATOMS DID NOT CHANGE, and uniform is
#      not one choice among many here: TN_FIXED is a Halton lattice, i.e. a
#      low-discrepancy point set FOR THE UNIFORM MEASURE ON THE CUBE, whose
#      canonical quadrature rule is exactly equal weights vol(T)/#T. The atoms
#      already implied uniform Pi_t; only the normalisation was missing. The
#      resulting rule integrates a function of bounded variation with
#      Koksma-Hlawka error O(#T^{-1}(ln #T)^3), not O(#T^{-1/2}). Total mass is
#      now constant in #T (4.096) and the norm of a fixed function converges.
#      c_Pi (B1(iv.c)) uses the same weights, so eq:normconst and eq:cap inherit
#      the correction with no separate adjustment.
#
# D14. THE INDEX SET IS THE THREE NON-DEGENERATE COORDINATES. B1(i) has
#      Phi: R^p -> R^p and B1(iii) asks Leb_p(T) > 0, but dZ_1 == 1 is the
#      differenced intercept (see sim_thm_rootn_dgp.R), so Phi_1(dZ_i) is the
#      same number at every i and w(t'Phi(dZ)) = e^{t_1 Phi_1} e^{t_{2:4}'Phi_{2:4}}
#      factorises: the t_1 direction multiplies the whole operator by a constant
#      and integrating it over an interval only rescales Pi_t's mass. T is
#      therefore taken as the cube in the three non-degenerate coordinates. This
#      was implicit through round 2 (Phz is built from d$zc, which is 3-column)
#      and is now declared.
#
# Outputs
#   paper/tables/sim/sim_thm_rootn_stopping.tex    (bare tabular, INV-13)
#   paper/tables/sim/sim_thm_rootn_condition.tex   (bare tabular)
#   paper/figures/sim/sim_thm_rootn_stopping.pdf
#   quality_reports/sim/sim_thm_rootn_phistep.rds
# ============================================================================

library(here)
library(data.table)
library(ggplot2)
library(splines)
library(parallel)

source(here::here("scripts", "simulations", "sim_thm_rootn_dgp.R"))
source(here::here("scripts", "simulations", "sim_thm_rootn_nuisance.R"))

# The C3 boundary family of lem:bdryfam, from the SHIPPED ENGINE (D11a), into a
# sandbox environment so that none of lf_panel.R's namespace leaks into this
# one -- both files define objects called `kern8`-adjacent things and a silent
# shadowing here would be indistinguishable from a modelling choice. Sourcing
# rather than retyping is the point: Section 5 and Section 6 must run the same
# family, and a retyped copy is how two sections silently diverge.
ENG <- new.env(parent = globalenv())
sys.source(here::here("scripts", "R", "lf_panel.R"), envir = ENG)
stopifnot(is.function(ENG$bdry_family), is.function(ENG$bdry_theta),
          identical(ENG$P_K_X, 8L), identical(as.integer(CFG$p_K), ENG$P_K_X))

RNGkind("L'Ecuyer-CMRG")
set.seed(20260733L)                                            # INV-14

N_CORES <- SIM_CORES               # fixed constant, see sim_thm_rootn_dgp.R
N_PHI   <- c(500L, 2000L, 8000L)
B_PHI   <- 300L
B_GRAM  <- 25L                    # replications on which the n_m-dim Gram runs
K_BAR   <- 3L                     # number of linearisation stages, bar-k
# Design decision D9. The sweep is LOGARITHMIC and wide, because a first pass at
# c_14 in {0.5, 1, 2} put the threshold tau_DP * delta-hat^eff above the initial
# residual ||T-hat||_{L2(Pi)} at every n, so the rule stopped at m = 1 and the
# estimator was the preliminary. That is not a tuning accident: the level of
# eq:lfsched is built from delta-hat_n, a RATE symbol carrying no units, while
# the residual is measured in L2(Pi), whose scale depends on the free reference
# measure Pi and on c_Pi. The rule is therefore not scale-invariant and c_14
# must absorb the scale -- which is consistent with def:lfstep's own statement
# that c_14 must dominate c_16, "built from the kernel constants and the design".
# The sweep spans five decades so that the whole stopping curve is visible.
# 3e-2 was added in round 2. The round-1 sweep put every Lepskii-vs-discrepancy
# comparison at c_14 <= 1e-2, where the discrepancy rule saturates the cap in
# every replication BY CONSTRUCTION -- so "Lepskii beats the discrepancy rule"
# was measured only where the discrepancy rule had already failed. 3e-2 sits in
# the transition and gives the comparison a cell where the rule is doing
# something other than returning the cap.
#
# ROUND-3 AMENDMENT TO WHAT c_14 IS ABSORBING, and the amendment WEAKENS the
# earlier statement without withdrawing it. Under round 2's counting-measure
# Pi_t the residual carried a factor sqrt(#T), so c_14 had to absorb the NODE
# COUNT -- a pure implementation artefact with no counterpart in the theory, and
# an artefact is not evidence about eq:lfsched. With Pi_t a fixed measure (D13)
# that factor is gone: Run 2 holds the mass at vol(T) across a 4x refinement.
# What remains is that the residual is an L2(Pi) norm while the level of
# eq:lfsched is built from delta-hat_n, a rate symbol carrying no units, so c_14
# must still absorb the NORMALISATION OF Pi -- and Pi is genuinely free in B1(iv),
# which asks only that Pi_u and Pi_t be finite with the stated support and
# smoothness. That is the sharper and defensible form of the claim: the constant
# absorbs a modelling choice the theory declares free, not a grid artefact.
# The sweep still spans five decades because the transition is NARROW: Panel B
# reports the interior-stop window in c_14, which is a few percent wide.
C14_SET <- c(1e-4, 1e-3, 1e-2, 3e-2, 1e-1, 1.0)
C15     <- 1.0
VARSIG0 <- 0.15                   # design decision D8, clears 0.107
N_UGRID <- 65L                    # quadrature nodes for Pi_u
N_TGRID <- 12L                    # quadrature nodes for Pi_t (design decision D13)
N_XGRID <- 961L                   # BASE nodes in x, anchored at n = 500 (D11b)
stopifnot(N_XGRID %% 2L == 1L)    # Simpson needs an even number of intervals
HX_EX   <- HX_EXP_PHI             # 0.40; derived at HX_EXP_PHI in ..._dgp.R

#' Nodes in x at sample size n. GROWS with n; see design decision D11c.
#'
#' @param n integer. Sample size.
#' @return integer, odd, so that Simpson's rule applies.
nx_for <- function(n) {
  v <- ceiling(N_XGRID * (n / 500)^HX_EX)
  as.integer(v + (v %% 2L == 0L))
}
stopifnot(nx_for(500L) == N_XGRID, all(nx_for(N_PHI) %% 2L == 1L))

# ---- Order-8 kernel (C3(i)) in the RESIDUAL direction -----------------------
#
# STILL USED, AND ONLY IN u. C3's three conditions apply to C_{h_u} and to
# C_{h_x} alike, but only the x-direction is truncated: u ranges over R, so the
# index there is I = R, Theta_I = Theta_1 is the interior member, and C3(i) is
# what has to hold. kern8 IS that interior member -- lem:bdryfam's whole point
# is that the family's interior member is exactly this kernel. So the residual
# direction is unchanged by D11a and continues to use kern8 / kern8_int.
# The x-direction, which IS truncated, no longer uses either; see Ker() below.

kern8_coef <- local({
  mom <- function(m) if (m %% 2 == 1) 0 else prod(seq_len(m - 1)[seq_len(m - 1) %% 2 == 1])
  gm <- c(1, 1, 3, 15, 105, 945, 10395)                # E[Z^{2m}], m = 0..6
  M <- matrix(0, 4, 4)
  for (j in 0:3) for (k in 0:3) M[j + 1, k + 1] <- gm[j + k + 1]
  as.vector(solve(M, c(1, 0, 0, 0)))
})
kern8 <- function(v) {
  a <- kern8_coef
  stats::dnorm(v) * (a[1] + a[2] * v^2 + a[3] * v^4 + a[4] * v^6)
}
#' Integrated kernel: int_{-inf}^{x} K_8. Closed form from
#' int_{-inf}^x w^m phi(w) dw = -x^{m-1} phi(x) + (m-1) int_{-inf}^x w^{m-2} phi.
kern8_int <- function(x) {
  a <- kern8_coef
  I0 <- stats::pnorm(x); ph <- stats::dnorm(x)
  I2 <- -x * ph + I0
  I4 <- -x^3 * ph + 3 * I2
  I6 <- -x^5 * ph + 5 * I4
  pmin(pmax(a[1] * I0 + a[2] * I2 + a[3] * I4 + a[4] * I6, 0), 1)
}
# ---- C3(ii)'s two constants, eq:envconst -----------------------------------
#
# WHAT WAS THERE, AND WHY BOTH NUMBERS WERE WRONG INDEPENDENTLY OF THE KERNEL
# AND OF THE BANDWIDTH.  *** 2026-08-16 ***  The arm shipped
#     C_C    <- 4.0                                    # "support half-width"
#     C2_SUP <- max(abs(kern8(seq(-C_C, C_C, 4001))))  # = 0.8727
# and fed both to omega_norm().  Neither survives dispatch 26.
#
#   (a) c_C IS NO LONGER A SUPPORT HALF-WIDTH.  Round-12 C3(i) required Theta_1
#       to be supported in [-c_C, c_C]; the kernel this project ships is
#       Schwartz and nowhere zero, so NO FINITE c_C made that true and C3 was
#       false of the estimator the paper runs.  Dispatch 26 replaced compact
#       support with an ENVELOPE and DERIVED c_C from it,
#           c_C := ||bar-Theta||_{L^1} / (2 c_2),   so   int bar-Theta = 2 c_C c_2.
#       4.0 is an artefact of the retired clause.
#   (b) c_2 IS THE ENVELOPE'S SUP, NOT THE INTERIOR KERNEL'S MAX.  C3(ii) writes
#       c_2 := ||bar-Theta||_inf, and bar-Theta dominates EVERY member of the
#       family, including the boundary members.  max|kern8| = 0.8727 is
#       lem:bdryfam Panel F's "interior member: 0.873" -- a different object.
#
# THE TWO CONSTANTS MUST COME FROM ONE ENVELOPE, AND THAT IS WHAT DECIDES WHICH
# NUMBERS ARE SHIPPED.  eq:envconst BINDS them through int bar-Theta = 2 c_C c_2,
# so a c_C read off one envelope and a c_2 read off another do not describe any
# envelope at all.  Two consistent pairs are available:
#
#   THE ANALYTIC MAJORANT.  bar-Theta = sqrt(2 pi) ||q||_2 m(varsigma) with
#   m(varsigma) = ||(1, varsigma, ..., varsigma^7)||_2 exp(-varsigma^2/2).  c_C
#   is scale-free and comes out at ||m||_{L1}/(2||m||_inf) = 107.948/(2*29.630)
#   = 1.8216, the corpus's 1.82.  Its c_2 carries ||q||_2 <= underline-g^{-1} and
#   is 1.97e+06 at the true infimum of lambda_min over frak-I.  (This line used
#   to end "NOT the 115.4 the C3 note quotes"; 115.4 was withdrawn from the
#   corpus on 2026-08-16 and the pointer is repointed below.)
#
#   THE MINIMAL ENVELOPE, WHICH IS WHAT IS SHIPPED.
#   bar-Theta(varsigma) := sup{|Theta_I(varsigma)| : I in frak-I} is the smallest
#   function satisfying C3(ii)'s |Theta_I| <= bar-Theta, so it is a valid
#   envelope, and both constants come off it EXACTLY with no bound in between.
#   It is preferred for the same reason c_Pi is computed rather than majorised in
#   this arm: every other constant in eq:normconst is realised, and mixing a
#   realised c_Pi with a majorised c_2 prices a proof technique as though it were
#   a property of the design.
#
# *** R10, 2026-08-17: THE SUP RUNS OVER frak-I, NOT OVER ONE BANDWIDTH. ***
#
# WHAT WAS WRONG, AND IT WAS A QUANTIFIER AND NOT A GRID.  Through 2026-08-16
# env_consts() TOOK h_x AND SWEPT {I(x) : x in X} AT THAT h_x.  By eq:ivalx those
# intervals ALL HAVE LENGTH |X| / h_x, so the function it computed was
#     c_2(L) := sup{|Theta_{[a, a+L]}(varsigma)| : a <= 0 <= a+L, varsigma in I},
# evaluated at the single L the configuration happens to realise -- a function of
# h_x, hence of n.  C3(ii) does not quantify that way.  bar-Theta is defined from
# the family lem:bdryfam declares, {Theta_I : I in frak-I} with
# frak-I = {[a, b] : a <= 0 <= b, b - a >= 2}, and def:lfstep's requirement that
# ||omega_n^{-1} hat-A_varphi|_{S_n}|| <= 1 hold SURELY is a statement about that
# family.  A c_2 carrying an n was a statement about one configuration wearing a
# theorem's clothes.  It also happened to be too SMALL, which is the direction
# that matters: c_2 enters eq:normconst squared and eq:cap to the fourth.
#
# WHAT REPLACES IT.  The two-parameter sweep over frak-I in the tanh coordinates
# lem:bdryfam(c) already uses, varsigma on [-15, 15].  env_consts() TAKES NO
# BANDWIDTH and returns ONE pair, which is the diagnostic that the repair landed:
# a constant that still has an argument is still a configuration.
#
# THE MEASUREMENT.  c_2 = 34.039389, attained at I = [0, 2] -- the FLOOR of
# frak-I -- evaluated at varsigma = 0, and confirmed independently against the
# Legendre reproducing kernel at an endpoint, sum_{j=0}^{7}(2j+1)/2 = 32, ratio
# 1.063731: the excess over the unweighted value is exactly what e^{-varsigma^2/2}
# <= 1 on I forces.  ||bar-Theta||_{L^1} = 10.5576 and c_C = ||bar-Theta||_{L^1}
# / (2 c_2) = 0.1550750.
#
# WHY THE L^1 NEEDS THE STRUCTURED RUNGS AND A PLAIN GRID WILL NOT DO.  The
# corpus's own tanh-grid value was 9.74, 8% low, and the reason is structural
# rather than a matter of resolution: at each varsigma the maximiser sits where an
# interval ENDPOINT LANDS ON varsigma, and a fixed (alpha, beta) -- equivalently
# a fixed (L, a) -- grid meets that coincidence only at isolated varsigma.  Between
# them the computed envelope drops to whatever the nearest grid interval gives, so
# the integrand is not merely inaccurate, it OSCILLATES: at varsigma just above 2,
# where the shortest admissible interval is [0, varsigma] and its length is
# therefore varsigma itself, a fixed L-grid gave 1.422 at 2.000 and 0.798 at 2.001.
# That is a spurious jump, and a jump makes composite Simpson converge at O(h) --
# which is exactly what was observed, increments halving with h across four
# refinements and heading for 10.26.  The rungs below are s-ADAPTED so that the
# endpoint coincidence is hit at EVERY node, and the O(h) signature disappears.
#
# THE REFINEMENT LADDER, and it is the sweep that refines, not the grid:
#   tanh (alpha, beta) grid alone                                  9.578
#   + the structured (L, a) sweep                                 10.062
#   + the |I| = 2 edge and the [0, L] family                      10.514
#   + exact corners, right-endpoint family, s-adapted spike       10.5576
# The last rung is the one that matters and it is worth +0.4%; the varsigma
# quadrature is then converged to 3e-05 (10.557503 / 10.557666 / 10.557632 at
# 625 / 1,245 / 2,485 nodes).  c_2 needed NO refinement -- it is attained at the
# floor |I| = 2, which every rung contains.
#
# ONE-SIDEDNESS, AND THE 4e-05 THAT IS LEFT.  A sup computed over a finite set of
# candidates is a LOWER bound, so refinement can only push these numbers UP.  The
# ruled ||bar-Theta||_{L^1} is 10.5572 and this sweep measures 10.557632, higher
# by 4.1e-05 relative; the sweep agrees with an independent brute-force sup at 11
# of 15 test varsigma exactly and to 5e-05 at the other four, so the direction is
# the expected one.  The consequence is confined to the sixth significant figure
# of c_C and therefore to the last PRINTED digit of the three omega_n cells.
#
# WITHDRAWN WITH THE OLD QUANTIFIER: the claim that the constants "saturate at
# |I| >= 9.4".  See the c_2(L) note at C2_OF_L below -- 9.4 is a noise floor, and
# saturation in |I| was never the property C3(ii) asks for in any case.
#
# THE lambda_min FLAG IS CLOSED.  It read "C3's note reports lambda_min(G) =
# 2.57e-01 over the realised intervals, giving c_2 = 115.4".  THE C3 NOTE NO
# LONGER QUOTES 115.4: suppref{Lemma}{bdryfam}'s note withdrew it on 2026-08-16
# ("The c_2 = 115.4 derived from it is WITHDRAWN"), having found the quantifier
# inversion -- 2.57e-01 is the family's MAXIMUM, at a symmetric interior interval,
# standing in an infimum's slot, while a BOUNDARY design point realises
# I = [0, |X|/h_x] where lambda_min(G) <= 1.507063e-05.  That 1.507e-05 is the
# figure lf_panel.R:287 documents and is what this arm measures on the raw Gram
# (1.7368e-07 on the diagonally equilibrated Gram the solve actually uses).
# Nothing here depends on any of it: the shipped pair is read off bar-Theta
# directly and never touches lambda_min.
#
# COST.  env_consts() takes no argument and no data, so it is evaluated ONCE at
# the top level and looked up inside the replication.  About 90 s.

#' |Theta_I| at one evaluation point per interval, intervals of COMMON length.
#'
#' bdry_family() is vectorised over design points at a FIXED (h, xsupp), so a
#' single call covers one interval length: with h = 1 and xsupp = c(0, L) the
#' design point x = -a gives exactly I = [a, a + L].
#'
#' THE CLAMP IS EXACT, NOT A FUDGE, AND WITHOUT IT THE SWEEP MEASURES ZERO AT
#' PRECISELY THE CONFIGURATION IT EXISTS TO MEASURE.  bdry_family() REBUILDS the
#' endpoints as (xsupp - x)/h, so the b it realises can fall one ulp short of the
#' varsigma that was asked for; bdry_theta()'s indicator is a strict s <= b, and
#' the member is then silently zeroed.  The rungs below place an endpoint ON the
#' evaluation point by construction, so varsigma lies in I at every call site and
#' clamping into the realised [a, b] moves it by at most one ulp.
#'
#' @param a numeric. Left endpoints.
#' @param L numeric(1). Common interval length, L >= 2.
#' @param s numeric. Evaluation points, one per interval, each inside its own.
#' @return numeric, |Theta_{[a, a+L]}(s)|, same length as `a`.
theta_abs_at <- function(a, L, s) {
  fam <- ENG$bdry_family(-a, 1, c(0, L), p_K = 8L)
  ev  <- pmin(pmax(s, fam$a), fam$b)
  abs(as.vector(ENG$bdry_theta(matrix(ev, nrow = 1L), fam)))
}

# The sweep's own resolution.  ENVC_NL is the number of interval lengths for the
# two ENDPOINT rungs, ENVC_NLI for the interior rung and ENVC_NT its theta grid.
# Lengths are geometric in the EXCESS ell = |I| - 2, so the floor -- where c_2 is
# attained and where the Gram is worst conditioned -- is the densest region.
ENVC_NL  <- 400L
ENVC_NLI <- 120L
ENVC_NT  <- 17L
ENVC_BI  <- 40         # numerical +infinity: dnorm(40) underflows, so the
                       # partial moments equal the full Gaussian moments EXACTLY
                       # and the half-lines and R are hit, not approached.
ENVC_SMX <- 15         # varsigma range; bar-Theta < 6e-42 at 15

#' bar-Theta on a grid of varsigma >= 0.
#'
#' bar-Theta IS EVEN, so the half line suffices and the L^1 is twice its
#' integral.  Proof: G(-I) = D G(I) D with D = diag((-1)^j) and D e_0 = e_0, so
#' q_{-I, k} = (-1)^k q_{I, k} and Theta_{-I}(varsigma) = Theta_I(-varsigma);
#' frak-I is closed under I -> -I.  Checked in the assertion block below.
#'
#' Five rungs, all of them s-ADAPTED so that the endpoint coincidence is met at
#' every node rather than at isolated ones:
#'   (5) the SHORTEST admissible interval containing {0, s}, which is [0, s] for
#'       s >= 2 and [0, 2] for s < 2, evaluated AT s;
#'   (2) the right-endpoint family, b = s exactly, a = s - L swept;
#'   (3) the [0, L] family, a = 0 exactly;
#'   (4) the interior, a = (1 - theta)(s - L) interpolating (2) and (3).
#' L -> 2*ENVC_BI is the corner: the half-lines and R.
#'
#' @param s numeric, nonnegative.
#' @param n_L,n_Li,n_T integer(1). Sweep resolution; see ENVC_* above.
#' @return numeric, bar-Theta(s), same length as `s`.
bar_theta <- function(s, n_L = ENVC_NL, n_Li = ENVC_NLI, n_T = ENVC_NT) {
  stopifnot(all(s >= 0), all(is.finite(s)))
  mk_L <- function(m) 2 + c(0, exp(seq(log(1e-4), log(2 * ENVC_BI - 2),
                                       length.out = m - 1L)))
  bar <- numeric(length(s))                                      # INV-17
  lo <- which(s < 2)
  if (length(lo)) {
    bar[lo] <- pmax(bar[lo], theta_abs_at(rep(0, length(lo)), 2, s[lo]))
  }
  for (i in which(s >= 2)) {                        # I = [0, s], at s: L varies
    bar[i] <- pmax(bar[i], theta_abs_at(0, s[i], s[i]))
  }
  for (L in mk_L(n_L)) {
    ok <- which(s <= L)
    if (!length(ok)) next
    so <- s[ok]
    bar[ok] <- pmax(bar[ok], theta_abs_at(so - L, L, so),          # b = s
                    theta_abs_at(rep(0, length(so)), L, so))       # a = 0
  }
  th_grid <- (1 - cos(pi * seq(0, 1, length.out = n_T))) / 2
  for (L in mk_L(n_Li)) {
    ok <- which(s <= L)
    if (!length(ok)) next
    so <- s[ok]
    for (th in th_grid[-c(1L, n_T)]) {
      bar[ok] <- pmax(bar[ok], theta_abs_at((1 - th) * (so - L), L, so))
    }
  }
  bar
}

#' C3(ii)'s (c_2, c_C) off the minimal envelope over ALL of frak-I.
#'
#' TAKES NO BANDWIDTH.  eq:envconst binds the pair through
#' int bar-Theta = 2 c_C c_2, so c_C is DERIVED and the identity residual is
#' returned rather than trusted.
#'
#' The varsigma quadrature is composite Simpson on five graded segments: the
#' envelope falls from 34.04 at varsigma = 0 to 3.4 by 0.14 -- a reproducing
#' kernel's off-diagonal decay, on the scale |I| / p_K^2 -- so a uniform rule
#' would resolve the peak or the tail but not both.
#'
#' @param f integer(1). Refinement factor on the varsigma grid.  f = 4 is the
#'   shipped value: the L^1 reads 10.557503 / 10.557666 / 10.557632 at f = 1 / 2
#'   / 4, so the rule is converged to 3.4e-05 and f = 4 costs about 70 s.
#' @return named numeric: c_2, c_C, l1 (= int bar-Theta over [-15, 15]), and the
#'   identity residual |l1 - 2 c_C c_2|.
env_consts <- function(f = 4L) {
  brk  <- c(0, 0.25, 0.6, 2, 4, ENVC_SMX)
  base <- c(100L, 60L, 200L, 160L, 100L) * as.integer(f)
  # Simpson needs an EVEN interval count per segment; checked rather than left to
  # the reader of the literals, since an odd count silently drops a node's weight.
  stopifnot(all(base %% 2L == 0L), length(base) == length(brk) - 1L)
  l1h <- 0
  c2  <- 0
  for (k in seq_len(length(brk) - 1L)) {
    sg <- seq(brk[k], brk[k + 1L], length.out = base[k] + 1L)
    y  <- bar_theta(sg)
    h  <- sg[2L] - sg[1L]
    N  <- length(y)
    l1h <- l1h + h / 3 * (y[1L] + y[N] + 4 * sum(y[seq(2L, N - 1L, by = 2L)]) +
                            2 * sum(y[seq(3L, N - 2L, by = 2L)]))
    c2 <- max(c2, max(y))
  }
  l1 <- 2 * l1h                                     # bar-Theta is even
  cC <- l1 / (2 * c2)
  c(c_2 = c2, c_C = cC, l1 = l1, ident = abs(l1 - 2 * cC * c2))
}

#' c_2 restricted to intervals of ONE length -- the object the retired
#' env_consts(hx) computed, at L = |X| / h_x.
#'
#' Kept because two claims this file used to make are about it and both had to be
#' reworded rather than deleted; see the C2_OF_L note below.  Not on the shipped
#' arithmetic path.
#'
#' @param L numeric(1). Interval length, L >= 2.
#' @param n_a integer(1). Left endpoints swept over [-L, 0], cosine-graded.
#' @param n_s integer(1). Nodes in varsigma inside each interval.
#' @return numeric(1).
c2_at_len <- function(L, n_a = 201L, n_s = 2001L) {
  av <- -L * (1 - cos(pi * seq(0, 1, length.out = n_a))) / 2
  fam <- ENG$bdry_family(-av, 1, c(0, L), p_K = 8L)
  best <- 0
  for (j in seq_along(av)) {
    fj <- lapply(fam, function(z)
      if (is.matrix(z)) z[j, , drop = FALSE] else if (length(z) == n_a) z[j] else z)
    sj <- c(fj$a, fj$b, seq(fj$a, fj$b, length.out = n_s))
    best <- max(best, max(abs(as.vector(ENG$bdry_theta(matrix(sj, ncol = 1L), fj)))))
  }
  best
}

# ---- c_2(L): what 17.427 IS, and what 9.4 IS -------------------------------
#
# TWO CLAIMS THIS FILE MADE ARE REWORDED HERE RATHER THAN DELETED, because both
# were true of something and it is the QUANTIFIER that was wrong in each.
#
# (1) "17.427 is the envelope sup" -- IT IS NOT, AND WHAT IT IS IS SHARPER.
#     17.427134 is Theta_{[0, +inf]}(0), the HALF-LINE value, and it is EXACT at
#     the intervals this arm realises: |I| = |X| / h_x = 12.01, 20.91 and 36.41
#     at n = 500 / 2,000 / 8,000, all above 10.11, and c_2(L) - 17.427134 is
#     0.0e+00 at each -- not small, zero in double.  It is NOT uniform over
#     frak-I, which is what C3(ii) quantifies over: c_2(L) EXCEEDS it for short
#     intervals, reaching 34.039389 at the floor L = 2, i.e. +95.3%.
# (2) "the constants saturate at |I| >= 9.4" -- 9.4 IS A NOISE FLOOR, NOT A
#     MATERIALITY THRESHOLD, and the difference is the whole point.  On the
#     shipped arithmetic the excess c_2(L)/17.427134 - 1 is +1.04e-08 at L = 8.9,
#     +5.61e-10 at 9.48, and CHANGES SIGN at 9.6 (-5.29e-10).  A quantity that
#     changes sign is at the floor of the Gram solve, not decaying.  The
#     MATERIALITY crossings are the ones worth quoting and they are far below:
#     1% excess at |I| = 5.92, 10% at |I| = 4.47.
#     So "saturation" was a statement about double precision that read as a
#     statement about the family, and a constant that is flat in |I| above some
#     threshold is not what C3(ii) asks for in any case -- it asks for a bound
#     uniform over frak-I, floor included.
#
# Both are asserted below rather than left as prose.
C2_OF_L <- local({
  half <- theta_abs_at(0, 2 * ENVC_BI, 0)      # Theta_{[0, +inf]}(0) = 17.427134
  realised <- vapply(1 / band_hx(N_PHI, HX_EX), c2_at_len, numeric(1))
  list(half = half, realised = realised,
       floor2 = c2_at_len(2), one_pct = c2_at_len(5.92), ten_pct = c2_at_len(4.47))
})
stopifnot(
  abs(C2_OF_L$half - 17.427134) < 1e-5,
  # (1) exact at every |I| the arm realises, and NOT uniform over frak-I
  max(abs(C2_OF_L$realised / C2_OF_L$half - 1)) < 1e-12,
  abs(C2_OF_L$floor2 / C2_OF_L$half - 1 - 0.9532) < 1e-3,
  # (2) the materiality crossings, which the noise floor is not
  abs(C2_OF_L$one_pct / C2_OF_L$half - 1 - 0.01) < 5e-4,
  abs(C2_OF_L$ten_pct / C2_OF_L$half - 1 - 0.10) < 5e-3)

# ---- The Pi_t quadrature (B1(iii)-(iv.b)-(iv.c)), fixed before the data -----
#
# NOT B1(vi). That clause -- a finite family T_n with #T_n -> infinity -- is
# RETIRED, and retired on the specific ground that def:hatT integrates over all
# of T. Nothing here is a growing family: N_TGRID is a constant, and the nodes
# below are quadrature nodes for a FIXED reference measure Pi_t on
# T = [-0.8, 0.8]^3. See design decisions D13 and D14.

T_LO  <- -0.8
T_HI  <-  0.8
T_DIM <-  3L                                        # design decision D14
T_VOL <- (T_HI - T_LO)^T_DIM                        # Leb(T) = 4.096

#' Van der Corput sequence in a given base -- a deterministic low-discrepancy
#' construction, used so that the nodes are reproducible without touching the RNG.
van_der_corput <- function(m, base) {
  vapply(seq_len(m), function(i) {
    f <- 1 / base; r <- 0; k <- i
    while (k > 0) { r <- r + f * (k %% base); k <- k %/% base; f <- f / base }
    r
  }, numeric(1))
}

#' Halton nodes on T. Low-discrepancy FOR THE UNIFORM MEASURE ON THE CUBE, which
#' is why pit_weights() below is equal-weight: the two together are the QMC rule
#' for Pi_t = Uniform(T), not an arbitrary pairing.
make_Tn <- function(NT) {
  cbind(van_der_corput(NT, 2L), van_der_corput(NT, 3L),
        van_der_corput(NT, 5L)) * (T_HI - T_LO) + T_LO
}

#' Quadrature weights of Pi_t = Uniform(T): vol(T)/#T at each node, so the total
#' mass is Leb(T) whatever #T is. Under counting measure -- what round 2 shipped
#' -- the mass was #T and every L2(Pi) quantity carried a sqrt(#T) that eq:cap
#' did not; see D13.
pit_weights <- function(Tn) rep(T_VOL / nrow(Tn), nrow(Tn))

TN_FIXED <- make_Tn(N_TGRID)

# ---- Sieve (A8 basis clause: B-splines of order exceeding s = 3) ------------

#' L_x window. (P-c) is L_x >> n^{9 alpha /(8 s)} = n^{0.12}; (P-d) is
#' L_x = o(n^{1 - 2 alpha} / ln n) = o(n^{0.36}/ln n). eq:lxwindow is non-empty
#' at s = 3 > 1. The interior value n^{0.24} is taken.
lx_for <- function(n) max(6L, as.integer(round(n^0.24)))

#' Composite Simpson weights on a uniform grid of ODD length (design D11b).
#'
#' Replaces the trapezoid weights this arm used through 2026-08-15. They sum to
#' one exactly, are strictly positive, and are the SAME weights everywhere wx is
#' used -- the sieve's orthonormalisation, its mean-zero centring, the smoother's
#' action, and the L2(pi) error norm -- so the rule change cannot enter one of
#' those and not another.
#'
#' @param N integer(1). Number of nodes, odd.
#' @return numeric N, summing to 1.
simpson_w <- function(N) {
  stopifnot(N %% 2L == 1L, N >= 3L)
  w <- rep(0, N)
  w[seq(2L, N - 1L, by = 2L)] <- 4
  w[seq(3L, N - 2L, by = 2L)] <- 2
  w[c(1L, N)] <- 1
  w / (3 * (N - 1))
}

#' Orthonormal, mean-zero cubic B-spline basis on [0,1] under pi = Uniform.
sieve_basis <- function(Lx, xg) {
  B <- splines::bs(xg, df = Lx, degree = 3L, intercept = TRUE,
                   Boundary.knots = c(0, 1))
  B <- matrix(as.numeric(B), nrow = length(xg))
  wx <- simpson_w(length(xg))                                  # D11b
  B <- sweep(B, 2, colSums(B * wx), "-")                       # into V
  G <- t(B * wx) %*% B
  R <- chol(G + 1e-12 * diag(ncol(G)))
  list(B = B %*% solve(R), wx = wx)                            # orthonormal
}
stopifnot(abs(sum(simpson_w(N_XGRID)) - 1) < 1e-14,
          all(simpson_w(N_XGRID) > 0))

# ---- C3(ii)'s constants, and the family's acceptance test -------------------
#
# ENV_CONST IS ONE PAIR, NOT ONE PAIR PER n, AND THAT IS THE R10 DIAGNOSTIC.  It
# was `lapply(N_PHI, function(n) env_consts(band_hx(n, HX_EX)))` -- three pairs,
# indexed by sample size, for a constant C3(ii) declares uniform over frak-I.
# The moment check below still runs per n, because eq:truncmom IS a property of
# the realised configuration; the ENVELOPE constants are not.
ENV_CONST <- env_consts()
message(sprintf(paste("phi-step: C3(ii) over frak-I -- c_2 = %.6f  c_C = %.7f",
                      "||bar-Theta||_L1 = %.6f  (identity residual %.1e)"),
                ENV_CONST[["c_2"]], ENV_CONST[["c_C"]], ENV_CONST[["l1"]],
                ENV_CONST[["ident"]]))
# eq:envconst's identity, checked rather than trusted, and the pair against the
# ruled values.  The c_2 tolerance is TIGHT because c_2 is attained at the floor
# I = [0, 2], which every rung of the sweep contains, so it is exact or it is
# broken.  The c_C tolerance is 1e-4 because a sup over a two-parameter family
# computed on a finite candidate set is a LOWER bound: refinement moves it up,
# and this sweep lands 4.1e-05 above the ruled 0.155074.  A regression of the
# sweep -- a rung dropped, the s-adaptation lost -- moves it DOWN by percent, not
# by 1e-05, and fails here.
C3_RULED <- c(c_2 = 34.039389, c_C = 0.155074)
stopifnot(ENV_CONST[["ident"]] < 1e-10,
          abs(ENV_CONST[["c_2"]] / C3_RULED[["c_2"]] - 1) < 1e-7,
          abs(ENV_CONST[["c_C"]] / C3_RULED[["c_C"]] - 1) < 1e-4,
          # bar-Theta is even: the two anchors that force it, checked directly.
          abs(theta_abs_at(0, 2, 0) - theta_abs_at(-2, 2, 0)) < 1e-9)

# eq:truncmom checked on the arm's OWN shipped quadrature rather than in closed
# form: bdry_moments() would report the Gram solve, which is not what the
# operator consumes.  What the operator consumes is the realised row of Ker(),
# integrated by wx, and that is what is asserted.
MOMCHK <- local({
  xb <- seq(0, 1, length.out = 401L)
  out <- vector("list", length(N_PHI))                         # INV-17
  message("phi-step: eq:truncmom on the shipped grid")
  for (i in seq_along(N_PHI)) {
    n <- N_PHI[i]
    nx <- nx_for(n)                                            # D11c
    xg <- seq(0, 1, length.out = nx); wx <- simpson_w(nx)
    hx <- band_hx(n, HX_EX)
    fam <- ENG$bdry_family(xb, hx, c(0, 1), p_K = 8L)
    S <- outer(xg, xb, function(b, a) (b - a) / hx)
    TH <- ENG$bdry_theta(S, fam) / hx
    mj <- vapply(0:7, function(j) max(abs(colSums(S^j * TH * wx) - (j == 0))),
                 numeric(1))
    message(sprintf(paste("  n = %6d  N = %5d  N h_x = %5.1f  |I| = %6.2f",
                          "max_j |mom - delta| = %.2e"),
                    n, nx, nx * hx, 1 / hx, max(mj)))
    # The tolerance is the QUADRATURE's, not the family's: in closed form the
    # moments are exact.  Under D11c it is tightened from D11b's 1e-4 to 1e-6,
    # because holding N h_x constant is supposed to hold the defect constant at
    # 3.3e-07 -- so a defect that DRIFTS with n now fails here rather than
    # surfacing three hours later in the (P-g) slope.
    stopifnot(max(mj) < 1e-6)
    out[[i]] <- data.table(n = n, nx = nx, hx = hx, nhx = nx * hx,
                           c_2 = ENV_CONST[["c_2"]], c_C = ENV_CONST[["c_C"]],
                           mom_worst = max(mj))
  }
  rbindlist(out)
})
# The defect must be FLAT in n, not merely small: that is what N h_x constant
# buys and it is the design's own acceptance test, checked here.
stopifnot(diff(range(MOMCHK$nhx)) < 0.5,
          max(MOMCHK$mom_worst) / min(MOMCHK$mom_worst) < 1.5)

# ---- One replication of the phi-step ---------------------------------------

phistep_rep <- function(n, spec, es, prelim = c("zero", "rate"), c14 = 1.0,
                        do_gram = FALSE, Tn = TN_FIXED,
                        wt_fun = pit_weights) {
  prelim <- match.arg(prelim)
  n_t <- nrow(Tn)                       # #nodes of the Pi_t quadrature (D13)
  d  <- dgp_draw(n, spec)
  Lx <- lx_for(n)
  nx <- nx_for(n)                                              # D11c
  xg <- seq(0, 1, length.out = nx)
  SB <- sieve_basis(Lx, xg); Bm <- SB$B; wx <- SB$wx

  dh   <- rate_delta_hat(n)
  hx   <- band_hx(n, HX_EX)                                    # D11a(1)
  th_c <- rep(0, spec$p)                                       # anchor theta_o

  # Propensity, injected at A4(iii)'s rate and truncated (def:crossfit(a)).
  rh <- draw_rhat(rate_rn(n), d$zc, spec)
  wt <- d$w - rh

  # x-smoothing: the C3 BOUNDARY FAMILY of lem:bdryfam (design decision D11a),
  # from the shipped engine.  Row i is Theta_{I(X_i)}((xg - X_i)/h_x)/h_x with
  # I(X_i) = [(0 - X_i)/h_x, (1 - X_i)/h_x], so eq:truncmom holds for j = 0..7 at
  # EVERY design point -- not the j = 0 alone that D11's row renormalisation
  # enforced.  What D11 got right is preserved and not merely approximated: the
  # j = 0 moment is still exactly one, so prp:hatAprop(iii)'s int nu-hat dx = 0
  # is untouched.  No renormalisation is applied and none is needed; dividing
  # this family by its own realised j = 0 moment would be dividing by one, and
  # would silently reintroduce the quadrature error into the numerator.
  #
  # bdry_theta() takes (evaluation x design) and the arm wants (design x
  # evaluation), so the transpose is here rather than hidden in the caller.
  Ker <- function(X) {
    fam <- ENG$bdry_family(X, hx, c(0, 1), p_K = 8L)
    t(ENG$bdry_theta(outer(xg, X, function(b, a) (b - a) / hx), fam)) / hx
  }
  # APPLIED IN ROW BLOCKS, AND THE n x N_XGRID MATRIX IS NEVER MATERIALISED.
  # *** 2026-08-16, forced by D11c. *** At n = 8000 and N = 2915 the full
  # smoother is 186 MB and the transients inside two Ker() calls plus the
  # difference and the weighting peak at about 1.5 GB per replication -- times
  # SIM_CORES workers, that is 12 GB, on a machine that has to share. Blocking
  # holds the peak near 200 MB and costs nothing, because Sw is only ever used
  # through Sw %*% [vdagger, Bm]: everything downstream reads dphi_true or Dbas.
  #
  # THE ALGEBRA THIS RELIES ON, stated because it is what makes build_op()'s
  # signature change safe: build_op() was called only as build_op(Bm %*% c) at
  # all three call sites, and Sw (Bm c) = (Sw Bm) c = Dbas c. So the coefficient
  # vector is passed instead of its expansion and Dbas is reused.
  #
  # VERIFIED AGAINST THE UNBLOCKED PATH, and the exceptions are named rather than
  # tolerated. Both versions were run from an identical RNG state at all six
  # (n, preliminary) cells. Every reported quantity -- err, err_lep, omega,
  # bar_m_n, the stops, anorm, a_pow, r0, r_floor, h_capt, h_u, h_x, c_2, c_C --
  # agrees to at most 1.9e-16 relative, and at n = 8000 with the zero
  # preliminary all 46 elements are bit-identical. EXACTLY TWO quantities move by
  # more: comp_svr (1.2e-02 to 2.7e+00) and gram_svr (4.3e-02 to 4.5e-01). Both
  # are sigma_min/sigma_max ratios realised at 1e-13 and 1e-19 -- five and three
  # orders BELOW sqrt(eps_mach) and eps_mach respectively -- which is the regime
  # this script's own kappa comment declares a LOWER BOUND rather than an
  # estimate (critic finding D). A quantity pinned at the double-precision floor
  # is not reproducible across a change in summation order, and the condition
  # table prints the CLAMPED form, so no printed number depends on them.
  SMOOTH_BLK <- 1000L
  RHS <- cbind(phi_dagger(xg, spec), Bm)                       # nx x (1 + Lx)
  SR <- matrix(0, n, ncol(RHS))                                # INV-17
  for (k in split(seq_len(n), ceiling(seq_len(n) / SMOOTH_BLK))) {
    M <- Ker(d$x2[k]) - Ker(d$x1[k])                           # |k| x nx
    SR[k, ] <- sweep(M, 2, wx, "*") %*% RHS
  }
  dphi_true <- SR[, 1L]
  Dbas <- SR[, -1L, drop = FALSE]                              # n x Lx

  dY_th <- d$dy - as.vector(d$dz %*% th_c)
  # C5'(i) at theta_o, via the SINGLE implementation in sim_thm_rootn_dgp.R.
  hu <- band_hu(n, stats::sd(dY_th - dphi_true))

  # Bierens family: Phi = rescaled arctan (c_Phi = 1), w = exp (B1(i)-(ii)).
  # The Pi_t nodes are fixed BEFORE the data and are therefore built from a
  # DETERMINISTIC Halton lattice, not from set.seed() + runif: a set.seed() call
  # inside a replication would reset the worker's random stream and freeze every
  # draw made after it, which in an earlier version of this script silenced the
  # variation in the "rate" preliminary's error direction.
  Phz <- (2 / pi) * atan(d$zc)
  Wt_mat <- exp(Phz %*% t(Tn))                                 # n x n_t
  # Pi_u: density varpi bounded, positive and C^1 on R (B1(iv.a)). WHAT IS
  # IMPLEMENTED IS A TRUNCATION OF IT, AND THE TRUNCATION IS DATA-DEPENDENT --
  # declared in round 3, not absorbed. The nodes span +-4 sd(dY_th) while the
  # density has sd = 2 sd(dY_th), i.e. only +-2 of ITS OWN standard deviations,
  # so 2*pnorm(-2) = 4.55% of Pi_u's mass lies outside the quadrature; and
  # because both the span and the scale are built from sd(dY_th), the support of
  # the implemented measure is a RANDOM interval. B1(iv.a) asks for a fixed
  # measure, absolutely continuous with a bounded density strictly positive at
  # EVERY point of R. Two mitigations, neither of which makes it exact: the mass
  # outside is carried by the far tails of C_{h_u}(u - dU_i), where the
  # integrated kernel has already saturated at 0 or 1, so what is dropped is
  # nearly constant in the base point and largely cancels in the DIFFERENCE that
  # T-hat is; and sum(wu * varpi) enters c_Pi, so the truncation is at least
  # consistently applied to the operator and to the constant. The exact fix is a
  # wider span at proportionally more nodes, which costs quadrature resolution or
  # runtime and is not taken here.
  ug <- seq(-4, 4, length.out = N_UGRID) * stats::sd(dY_th)
  wu <- rep(ug[2] - ug[1], N_UGRID)
  varpi <- stats::dnorm(ug, sd = 2 * stats::sd(dY_th))         # Pi_u density, B1(iv.a)
  w_t <- wt_fun(Tn)                                            # Pi_t weights, D13
  qgrid <- as.vector(outer(wu * varpi, w_t))                   # L2(Pi) weights
  sq <- sqrt(qgrid)
  # B1(iv.c): c_Pi^2 = Pi_u(R) * int_T wbar(t)^2 Pi_t(dt), wbar(t) = e^{c_Phi ||t||_1}
  # with c_Phi = 1. NOTE (round 3): c_Pi is DETERMINISTIC, contrary to two
  # comments this script carried through round 2. wu is proportional to
  # sd(dY_th) and varpi is proportional to 1/sd(dY_th), so sum(wu * varpi) --
  # a Riemann sum for a probability density's integral -- cancels the data
  # dependence exactly; and w_t and Tn are fixed before the data. The only
  # random ingredient of bar_m_n is h_u, through band_hu(n, sd(dY_th - dphi)).
  # bar_m_n is still a random variable, so its MC SE is still reported; what is
  # withdrawn is the attribution of that randomness to c_Pi.
  c_Pi <- sqrt(sum(wu * varpi) * sum(w_t * exp(2 * rowSums(abs(Tn)))))  # B1(iv.c)

  # omega_n of eq:normconst and the cap of eq:cap, both from the single
  # implementation in sim_thm_rootn_dgp.R, so that the number the Landweber
  # iteration normalises by and the number the cap is built from CANNOT drift
  # apart. ||1/pi||_inf = 1 under D7 (pi = Uniform[0,1]). Because c_Pi is now
  # built from the SAME Pi_t weights as qgrid, omega_n and the residual it is
  # compared against are denominated in the same measure -- which is what
  # round 2 got wrong (D13).
  # c_2 and c_C are C3(ii)'s OWN constants off the minimal envelope over frak-I.
  # R10: ONE pair, not one per n -- no bandwidth and no data enter env_consts(),
  # so it is evaluated once at the top level and read here. See the eq:envconst
  # block above for why a c_2 carrying an n was the defect and not the grid.
  ec <- ENV_CONST
  omega_thy <- omega_norm(hu, hx, c_2 = ec[["c_2"]], c_Pi = c_Pi,
                          c_C = ec[["c_C"]], inv_pi_sup = 1)
  mbar_new  <- cap_mbar(omega_thy, n)                          # eq:cap, dispatch 10
  mbar_old  <- cap_mbar_old(n)                                 # the round-9 cap

  #' Operator and residual at a base point phi, given by its SIEVE COEFFICIENTS.
  #'
  #' Takes coefficients rather than values on xg (changed 2026-08-16): every call
  #' site already passed Bm %*% coef, and Sw (Bm c) = Dbas c, so this avoids
  #' materialising Sw. See the blocking note above.
  build_op <- function(phi_coef) {
    dphi <- as.vector(Dbas %*% phi_coef)
    res  <- dY_th - dphi
    Kd   <- outer(ug, res, function(u, r) kern8((u - r) / hu) / hu)   # n_u x n
    Cd   <- outer(ug, res, function(u, r) kern8_int((u - r) / hu))
    gmat <- matrix(0, N_UGRID * n_t, n)
    rvec <- numeric(N_UGRID * n_t)
    for (tt in seq_len(n_t)) {
      rows <- ((tt - 1) * N_UGRID + 1):(tt * N_UGRID)
      ww <- wt * Wt_mat[, tt]
      gmat[rows, ] <- sweep(Kd, 2, ww, "*")
      rvec[rows]   <- as.vector(Cd %*% ww) / n
    }
    A <- (gmat %*% Dbas) / n                                   # n_g x Lx
    list(A = A, r = rvec, gmat = gmat)
  }

  # Preliminary (design decision D8).
  if (prelim == "zero") {
    phi0_c <- numeric(Lx); eps0 <- sqrt(sum((phi_dagger(xg, spec)^2) * wx))
  } else {
    ctrue <- as.vector(t(Bm * wx) %*% phi_dagger(xg, spec))
    e <- stats::rnorm(Lx); e <- e / sqrt(sum(e^2)) * n^(-VARSIG0)
    phi0_c <- ctrue + e; eps0 <- n^(-VARSIG0)
  }

  ck <- phi0_c
  eps_prev <- eps0
  m_stop <- integer(K_BAR); sat <- logical(K_BAR); lev <- numeric(K_BAR)
  m_lep <- integer(K_BAR)
  kappa_S <- numeric(K_BAR); anorm <- numeric(K_BAR); svr_S <- numeric(K_BAR)
  for (k in seq_len(K_BAR)) {
    OP <- build_op(ck)
    Aw <- OP$A * sq; rw <- OP$r * sq
    P  <- crossprod(Aw)                              # eq:compress, Lx x Lx
    ev <- eigen(P, symmetric = TRUE, only.values = FALSE)
    lam <- pmax(ev$values, 0); U <- ev$vectors
    # ROUND-3 FIX, found by Run 3. A condition number is a RATIO of singular
    # values and must therefore be invariant to rescaling the operator. Round 2
    # computed max(lam) / pmax(min(lam), eps_mach) with the floor applied in
    # ABSOLUTE units. min(lam) is below eps_mach at every cell of this design, so
    # what was reported was exactly lam_max / eps_mach -- verified equal to nine
    # significant digits -- i.e. a function of the NORMALISATION, not of the
    # conditioning. Run 3 exposed it directly: rescaling Pi_t by 1/12 moved the
    # reported "kappa" by 12 while every genuine invariant held to 1e-16.
    #
    # Two consequences, and the second is the one that mattered. (a) The number
    # was not a measurement. (b) comp_svr was DEFINED as 1/sqrt(kappa_S), so the
    # singular-value ratio the round-2 table used to argue that the compression
    # is NOT at the double-precision floor was computed FROM the floored kappa
    # and was circular -- exactly the substitution the round-2 critic identified
    # in mark(). The engineer's round-2 refusal on this point is withdrawn.
    #
    # The floor now sits on the RELATIVE spectrum lam_j / lam_max, which is what
    # double precision actually bounds, so kappa is invariant; and svr_S is the
    # UNCLAMPED sigma_min/sigma_max, computed independently of kappa, so mark()
    # can no longer inherit a substitution.
    lam_rel    <- lam / max(lam)
    svr2       <- min(lam_rel)                         # (sigma_min/sigma_max)^2
    kappa_S[k] <- 1 / pmax(svr2, .Machine$double.eps)
    svr_S[k]   <- sqrt(pmax(svr2, 0))
    anorm[k] <- sqrt(max(lam))
    if (k == 1L) {
      # H1 posits sigma_j asymp j^{-a} with a = 3/4 (MILD ill-posedness).
      # rem:rootnscope(1) says the theorem does not reach severe (exponential)
      # decay. The singular values of the compression are sigma_j = sqrt(lam_j);
      # the slope of log sigma_j on log j estimates -a, and the slope of
      # log sigma_j on j detects exponential decay. Both are reported so that
      # the DESIGN's ill-posedness can be checked against the hypothesis it is
      # built to satisfy, rather than assumed.
      jj <- seq_along(lam)
      keep <- lam > max(lam) * 1e-12
      sg <- sqrt(lam[keep]); jk <- jj[keep]
      a_pow <- if (length(jk) >= 3L) unname(-stats::coef(stats::lm(log(sg) ~ log(jk)))[2]) else NA_real_
      a_exp <- if (length(jk) >= 3L) unname(-stats::coef(stats::lm(log(sg) ~ jk))[2]) else NA_real_
      r2_pow <- if (length(jk) >= 3L) summary(stats::lm(log(sg) ~ log(jk)))$r.squared else NA_real_
      r2_exp <- if (length(jk) >= 3L) summary(stats::lm(log(sg) ~ jk))$r.squared else NA_real_
      n_res <- sum(keep)

      # ---------------------------------------------------------------------
      # THE CONNECTION BETWEEN THE TWO ARMS (added in round 2).
      #
      # The limit-law arm injects the structural error h in H_MODES = 6 Fourier
      # modes spanning only THREE distinct frequencies, and phi_dagger is the
      # first of them. This arm measures the compression's singular values
      # decaying steeply over the resolvable directions. The question the two
      # arms together answer -- and which neither answers alone -- is whether
      # the injection basis can REACH the directions the operator damps.
      #
      # Measured here: the injection basis is expressed in the orthonormal
      # sieve, expanded in the compression's eigenvectors, and its energy is
      # located on the spectrum. If the energy sits at the TOP of the spectrum,
      # then D3c's "rough" mode is not merely a partial substitute for the real
      # error geometry -- it is structurally incapable of producing it, and the
      # limit-law arm's h can never be an ill-posed-direction error.
      HB <- h_basis(xg)                                  # N_XGRID x H_MODES
      cH <- t(Bm * wx) %*% HB                            # Lx x H_MODES
      l2H <- sqrt(colSums(HB^2 * wx))                    # true L2(pi) norms
      h_capt <- mean(sqrt(colSums(cH^2)) / l2H)          # sieve-captured fraction
      EH <- crossprod(U, cH)^2                           # energy by eigen-index
      EH <- sweep(EH, 2, pmax(colSums(EH), 1e-300), "/")
      w_idx <- rowMeans(EH)                              # avg energy profile
      h_mean_idx <- sum(seq_along(w_idx) * w_idx)        # centre of mass on spectrum
      nr <- max(n_res, 1L)
      h_bot_half <- sum(w_idx[seq_along(w_idx) > nr / 2])  # energy in damped half
      # Singular value the injected span actually sees, vs the operator's top.
      sig <- sqrt(lam)
      h_sig_ratio <- sig[1] / pmax(sum(sig * w_idx), 1e-300)
    }

    # eq:lfsched: the stage level, computed before the data are touched.
    lev[k] <- c14 * (dh * log(n) + hu^(-2) * eps_prev^2)
    eps_prev <- C15 * lev[k]^CFG$kappa

    # Landweber in closed form. c_m = U diag((1 - rho_j^m)/(1 - rho_j)) g,
    # rho_j = 1 - lam_j / omega^2, g = -omega^{-2} U' Aw' rw.
    g   <- -as.vector(crossprod(U, crossprod(Aw, rw))) / omega_thy^2
    rho <- 1 - lam / omega_thy^2
    r0sq <- sum(rw^2)
    if (k == 1L) r0_norm <- sqrt(r0sq)
    coef_at <- function(m) ifelse(abs(1 - rho) < 1e-14, g * m, g * (1 - rho^m) / (1 - rho))
    # ROUND-3 FIX, CRITICAL. The cross term is MINUS 2 omega^2 g'c, not plus.
    # ||Aw c + rw||^2 = c'Aw'Aw c + 2 c'Aw'rw + ||rw||^2, and c'Aw'Aw c =
    # sum(lam * cc^2) in the eigenbasis; but g is DEFINED as -U'Aw'rw/omega^2,
    # so U'Aw'rw = -omega^2 g and the middle term is -2 omega^2 sum(g * cc).
    # Round 2 shipped "+", which made the residual INCREASE in m: the two
    # sign-sensitive terms then both grew, the m = 1 branch could never fire
    # (resid_at(1) > resid_at(0) >= thr whenever thr < r0), the bisection branch
    # was unreachable, and the stop was forced to lie in {1, bar_m_n} as an
    # arithmetic identity. What round 2 reported as a bimodality FINDING was that
    # identity. The max(., 0) guard is dead code under the wrong sign and is
    # genuinely needed under this one (cancellation near the minimiser), so it
    # stays.
    resid_at <- function(m) {
      cc <- coef_at(m)
      sqrt(max(sum(lam * cc^2) - 2 * omega_thy^2 * sum(g * cc) + r0sq, 0))
    }
    # RUNTIME ASSERTION, ADDED IN ROUND 3. The round-2 assertions checked the
    # BOUND (m_stop <= bar_m_n) and the EXACTNESS of saturation; both hold under
    # the wrong sign, because both are properties of the branch structure and not
    # of the residual. Nothing checked the residual's SHAPE. Two checks are added,
    # each of which fails immediately on the round-2 code:
    #   (a) the closed form equals a DIRECT evaluation of ||Aw U cc + rw||;
    #   (b) with rho_j in [0, 1) the residual is NON-INCREASING in m.
    # Both are cheap: Aw is n_g x L_x with L_x <= 9.
    # rho_j = 1 exactly in the compression's null directions, where lam_j = 0 and
    # g_j = 0 too (Aw' rw lies in the row space of Aw), so the iterate does not
    # move there; rho_j > 1 would be divergence and is what must not happen.
    stopifnot(all(rho >= -1e-9), all(rho <= 1 + 1e-12))
    m_chk <- unique(pmin(c(0L, 1L, 2L, 4L, 16L, 256L, 4096L, mbar_new), mbar_new))
    r_chk <- vapply(m_chk, resid_at, numeric(1))
    d_chk <- vapply(m_chk, function(m)
      sqrt(sum((Aw %*% (U %*% coef_at(m)) + rw)^2)), numeric(1))
    # Relative to the initial residual. A sign error in the cross term moves the
    # residual by percent, not by roundoff: the Run-1 harness measured 2.4% at
    # m = 256 on a synthetic operator. 1e-6 is three orders inside that and four
    # orders outside the (1 - rho^m)/(1 - rho) cancellation floor at these rho.
    tol <- 1e-6 * max(r_chk[1], .Machine$double.eps)
    stopifnot(max(abs(r_chk - d_chk)) <= tol,     # closed form == direct
              all(diff(r_chk) <= tol),            # non-increasing in m
              abs(r_chk[1] - sqrt(r0sq)) <= tol)  # resid_at(0) == ||rw||
    if (k == 1L) {
      # THE RESIDUAL'S DYNAMIC RANGE OVER THE WHOLE BUDGET. With the sign
      # corrected the discrepancy criterion is a genuinely decreasing function of
      # m, so the branch it lands in is decided by where tau_DP * c_14 * level
      # sits relative to the INTERVAL [resid(bar_m_n), resid(0)]. That interval's
      # width is the whole content of the rule, and it is reported.
      r_floor  <- r_chk[length(r_chk)]            # resid at the cap
      lev_unit <- lev[1] / c14                    # the level at c_14 = 1
    }
    thr <- CFG$tau_dp * lev[k]
    if (resid_at(1) <= thr) {
      m_stop[k] <- 1L
    } else if (resid_at(mbar_new) > thr) {
      m_stop[k] <- mbar_new; sat[k] <- TRUE
    } else {
      lo <- 1; hi <- mbar_new
      while (hi - lo > 1) {
        mid <- floor((lo + hi) / 2)
        if (resid_at(mid) > thr) lo <- mid else hi <- mid
      }
      m_stop[k] <- hi
    }

    # Lepskii arm (design decision D10): largest dyadic index whose iterate is
    # within c * sigma(m') of every earlier candidate, sigma(m) = delta-hat sqrt(m).
    cand <- unique(pmin(2^(0:ceiling(log2(mbar_new))), mbar_new))
    Cs <- lapply(cand, function(m) as.vector(U %*% coef_at(m)))
    ok <- rep(TRUE, length(cand))
    for (j in seq_along(cand)) {
      for (jj in seq_len(j - 1)) {
        if (sqrt(sum((Cs[[j]] - Cs[[jj]])^2)) > dh * sqrt(cand[jj])) {
          ok[j] <- FALSE; break
        }
      }
    }
    m_lep[k] <- cand[max(which(ok))]

    ck <- ck + as.vector(U %*% coef_at(m_stop[k]))
  }

  phi_hat <- as.vector(Bm %*% ck)
  err <- sqrt(sum((phi_hat - phi_dagger(xg, spec))^2 * wx))
  # Lepskii-stopped counterpart, single final stage, for the rate comparison.
  ck_l <- phi0_c
  for (k in seq_len(K_BAR)) {
    OP <- build_op(ck_l)
    Aw <- OP$A * sq; rw <- OP$r * sq
    ev <- eigen(crossprod(Aw), symmetric = TRUE); lam <- pmax(ev$values, 0); U <- ev$vectors
    g <- -as.vector(crossprod(U, crossprod(Aw, rw))) / omega_thy^2
    rho <- 1 - lam / omega_thy^2
    coef_at <- function(m) ifelse(abs(1 - rho) < 1e-14, g * m, g * (1 - rho^m) / (1 - rho))
    ck_l <- ck_l + as.vector(U %*% coef_at(m_lep[k]))
  }
  err_lep <- sqrt(sum((as.vector(Bm %*% ck_l) - phi_dagger(xg, spec))^2 * wx))

  # The two condition numbers, each with the singular-value ratio it is built
  # from, so that a reader can see whether the number is a MEASUREMENT or a
  # report of the double-precision floor. A ratio at or below eps_mach means the
  # smallest singular value is numerically indistinguishable from zero and the
  # condition number is a LOWER BOUND, not an estimate (critic finding D).
  #
  # THE GRAM IS RANK-CAPPED BY THE QUADRATURE, and the reported kappa never sees
  # that (round-3, critic minor 1). Mg is n x n_g with n_g = N_UGRID * n_t = 780
  # at the shipped grid, so the n_m-dimensional Gram of eq:gram -- the object
  # prp:tccrepair(iii) needs -- has rank at most 780 and, at n = 2000, at least
  # 1220 STRUCTURALLY ZERO eigenvalues. svd(Mg) returns min(n, n_g) = n_g values,
  # so the reported kappa is that of the n_g-dimensional restriction and the
  # structural zeros never enter it. The count actually computed and the count
  # above the relative threshold are now both returned, so a reader can see how
  # much of the object the number describes.
  kap_gram <- NA_real_; gram_svr <- NA_real_
  n_sv <- NA_real_; n_sv_pos <- NA_real_
  if (do_gram && n <= 2000L) {
    OP <- build_op(phi0_c)
    Mg <- t(OP$gmat * sq)                                      # n x n_g
    sv <- svd(Mg, nu = 0, nv = 0)$d
    gram_svr <- min(sv) / max(sv)                              # scale-invariant
    n_sv <- length(sv); n_sv_pos <- sum(sv > max(sv) * 1e-12)
    # Same correction as for the compression: the clamp goes on the RATIO.
    kap_gram <- 1 / pmax(gram_svr, .Machine$double.eps)^2
  }
  comp_svr <- svr_S[1]                        # UNCLAMPED sigma_min/sigma_max

  # ROUND-3: the return value is a NAMED vector and every downstream reference is
  # by name. Through round 2 it was positional, read downstream as M[, 4*kb+13]
  # and documented in a comment block that had to be kept in step with the
  # constructor by hand. A positional slip is silent -- it returns a number of
  # the wrong quantity -- and this arm has already shipped wrong numbers twice
  # from provenance defects. A name slip raises a subscript error.
  c(stats::setNames(as.numeric(m_stop), paste0("m", seq_len(K_BAR))),
    stats::setNames(as.numeric(sat),    paste0("sat", seq_len(K_BAR))),
    stats::setNames(as.numeric(m_lep),  paste0("lep", seq_len(K_BAR))),
    stats::setNames(kappa_S,            paste0("kapS", seq_len(K_BAR))),
    c(mbar_new = as.numeric(mbar_new), mbar_old = as.numeric(mbar_old),
      omega = omega_thy, anorm = anorm[1], kap_gram = kap_gram,
      err = err, err_lep = err_lep, delta_n = rate_delta_n(n),
      hu = hu, hx = hx, I_len = 1 / hx,
      nx = as.numeric(nx), nhx = nx * hx,
      c2_env = ec[["c_2"]], cC_env = ec[["c_C"]],
      Lx = as.numeric(Lx), eps0 = eps0,
      a_pow = a_pow, a_exp = a_exp, r2_pow = r2_pow, r2_exp = r2_exp,
      n_res = as.numeric(n_res), r0 = r0_norm, r_floor = r_floor,
      lev_unit = lev_unit, h_capt = h_capt, h_mean_idx = h_mean_idx,
      h_bot_half = h_bot_half, h_sig_ratio = h_sig_ratio,
      comp_svr = comp_svr, gram_svr = gram_svr, n_t = as.numeric(n_t),
      n_sv = n_sv, n_sv_pos = n_sv_pos))
}

# ---- Driver ----------------------------------------------------------------

SPECS <- list(A = dgp_spec("A"))
ES    <- lapply(SPECS, solve_ell_star)

DESIGN <- CJ(n = N_PHI, prelim = c("zero", "rate"), c14 = C14_SET, sorted = FALSE)
setorder(DESIGN, n, prelim, c14)

message(sprintf("phi-step: %d cells on %d cores ...", nrow(DESIGN), N_CORES))
OUT <- vector("list", nrow(DESIGN))                            # INV-17

# Checkpointing, as in the limit-law arm: completed cells are written after each
# cell so that a rerun costs only the cells that had not finished.
#
# ROUND-2 FIX (critic finding A). The checkpoint is the mechanism by which stale
# results shipped: the design matched, so cells computed under an EARLIER version
# of phistep_rep() were reloaded and merged with cells computed under the current
# one, and the merged object was tabulated. Matching on the design alone cannot
# detect that. The checkpoint now also carries an MD5 FINGERPRINT of every source
# file that defines a replication, and is discarded whenever any of them changes.
# 2026-08-16: scripts/R/lf_panel.R JOINS THE FINGERPRINT. D11a makes the engine's
# bdry_family() / bdry_theta() part of this arm's replication, so an engine edit
# now changes what a cell computes. It was correctly absent before -- the arm did
# not source the engine -- and leaving it absent would have recreated exactly the
# staleness the round-2 fix was written against, with a checkpoint reloading
# cells computed under a different kernel.
SRC_FILES <- c(here::here("scripts", "simulations",
                          c("sim_thm_rootn_phistep.R", "sim_thm_rootn_dgp.R",
                            "sim_thm_rootn_nuisance.R")),
               here::here("scripts", "R", "lf_panel.R"))
SRC_HASH <- unname(tools::md5sum(SRC_FILES))
CKPT <- here::here("quality_reports", "sim", "sim_thm_rootn_phistep_ckpt.rds")
# 2026-08-03 FIX, and it is the round-2 guard's blind spot rather than a second
# defect. The round-2 fix above added the SOURCE half of this test because a
# design match alone could not detect stale cells; what it could not notice is
# that the DESIGN half never matched either. identical() on a data.table
# compares the .internal.selfref external pointer, which is recreated on every
# load, so the test was always FALSE and this arm has never resumed from a
# checkpoint -- reporting a fresh start each time, which is indistinguishable
# from having no checkpoint. The diagnosis and reproduction are at same_design()
# in sim_thm_rootn_dgp.R. The checkpoint on disk holds 36 of 36 completed cells.
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
  assign(".Random.seed", parallel::nextRNGStream(get(".Random.seed", envir = globalenv())),
         envir = globalenv())
  if (!is.null(OUT[[i]])) next
  r <- DESIGN[i]
  t0 <- Sys.time()
  parallel::mc.reset.stream()
  res <- parallel::mclapply(seq_len(B_PHI), function(b)
    phistep_rep(r$n, SPECS$A, ES$A, r$prelim, r$c14, do_gram = (b <= B_GRAM)),
    mc.cores = N_CORES, mc.preschedule = TRUE)
  M <- do.call(rbind, res[vapply(res, is.numeric, logical(1))])
  kb <- K_BAR
  Bn <- nrow(M)
  se <- function(v) stats::sd(v, na.rm = TRUE) / sqrt(sum(is.finite(v)))
  sat_cols <- paste0("sat", seq_len(kb))
  m_cols   <- paste0("m", seq_len(kb))
  # bar_m_n is realised on the sample -- through h_u ALONE, not through c_Pi,
  # which is deterministic (see the c_Pi comment in phistep_rep) -- so it is a
  # random variable and the meaningful comparison to the stop is the
  # PER-REPLICATION ratio, not the ratio of the two means. Both are reported,
  # each with its MC SE. Arithmetic invariant of the stopping rule:
  # m_stop[1] <= bar_m_n in every replication, so ratio_rep <= 1 ALWAYS.
  ratio_rep <- M[, "m1"] / M[, "mbar_new"]
  stopifnot(all(ratio_rep <= 1 + 1e-12))
  sat_stage <- colMeans(M[, sat_cols, drop = FALSE])
  sat_any_v <- as.numeric(rowSums(M[, sat_cols, drop = FALSE]) > 0)
  OUT[[i]] <- data.table(
    n = r$n, prelim = r$prelim, c14 = r$c14, B = Bn,
    m1 = mean(M[, "m1"]), m1_se = se(M[, "m1"]), m1_med = median(M[, "m1"]),
    m1_q10 = quantile(M[, "m1"], 0.10, names = FALSE),
    m1_q90 = quantile(M[, "m1"], 0.90, names = FALSE),
    m_last = mean(M[, "m3"]), m_last_se = se(M[, "m3"]),
    m_max = mean(apply(M[, m_cols, drop = FALSE], 1, max)),
    # The three branches of the rule, as frequencies. Under the round-2 sign
    # error at_one + at_cap == 1 by construction; they no longer sum to 1.
    at_one = mean(M[, "m1"] == 1), at_cap = sat_stage[1],
    at_int = mean(M[, "m1"] > 1 & M[, "sat1"] == 0),
    at_int_se = sqrt(mean(M[, "m1"] > 1 & M[, "sat1"] == 0) *
                     (1 - mean(M[, "m1"] > 1 & M[, "sat1"] == 0)) / Bn),
    sat_any = mean(sat_any_v),
    sat_any_se = sqrt(mean(sat_any_v) * (1 - mean(sat_any_v)) / Bn),
    sat_s1 = sat_stage[1], sat_s2 = sat_stage[2], sat_s3 = sat_stage[3],
    ratio_rep = mean(ratio_rep), ratio_rep_se = se(ratio_rep),
    ratio_rep_med = median(ratio_rep),
    lep1 = mean(M[, "lep1"]), lep1_se = se(M[, "lep1"]),
    lep_last = mean(M[, "lep3"]),
    mbar_new = mean(M[, "mbar_new"]), mbar_new_se = se(M[, "mbar_new"]),
    mbar_old = mean(M[, "mbar_old"]),
    omega = mean(M[, "omega"]), omega_se = se(M[, "omega"]),
    anorm = mean(M[, "anorm"]), anorm_se = se(M[, "anorm"]),
    omega_slack = mean(M[, "omega"]) / mean(M[, "anorm"]),
    kappa_S = mean(M[, "kapS1"]), kappa_S_med = median(M[, "kapS1"]),
    kappa_S_se = se(M[, "kapS1"]),
    kappa_G = mean(M[, "kap_gram"], na.rm = TRUE),
    kappa_G_med = median(M[, "kap_gram"], na.rm = TRUE),
    kappa_G_se = se(M[, "kap_gram"]),
    err = mean(M[, "err"]), err_se = se(M[, "err"]),
    err_sd = stats::sd(M[, "err"]),
    err_lep = mean(M[, "err_lep"]), err_lep_se = se(M[, "err_lep"]),
    delta_n = M[1, "delta_n"], hu = mean(M[, "hu"]), hu_se = se(M[, "hu"]),
    hx = M[1, "hx"], I_len = M[1, "I_len"],
    nx = M[1, "nx"], nhx = M[1, "nhx"],
    c2_env = M[1, "c2_env"], cC_env = M[1, "cC_env"],
    Lx = M[1, "Lx"], eps0 = M[1, "eps0"],
    a_pow = mean(M[, "a_pow"], na.rm = TRUE), a_pow_se = se(M[, "a_pow"]),
    a_exp = mean(M[, "a_exp"], na.rm = TRUE), a_exp_se = se(M[, "a_exp"]),
    r2_pow = mean(M[, "r2_pow"], na.rm = TRUE),
    r2_exp = mean(M[, "r2_exp"], na.rm = TRUE),
    # Fraction of replications in which the exponential fit wins, which is what
    # "which functional form" actually rests on at 5-8 resolvable points.
    exp_wins = mean(M[, "r2_exp"] > M[, "r2_pow"], na.rm = TRUE),
    exp_wins_se = sqrt(mean(M[, "r2_exp"] > M[, "r2_pow"], na.rm = TRUE) *
                       (1 - mean(M[, "r2_exp"] > M[, "r2_pow"], na.rm = TRUE)) / Bn),
    n_res = mean(M[, "n_res"]), n_res_se = se(M[, "n_res"]),
    r0 = mean(M[, "r0"]), r0_se = se(M[, "r0"]),
    # The discrepancy rule's whole dynamic range: the residual at the cap
    # against the residual at m = 0, and the c_14 interval that lands strictly
    # between them (an interior stop). Both new in round 3.
    r_floor = mean(M[, "r_floor"]), r_floor_se = se(M[, "r_floor"]),
    range_ratio = mean(M[, "r_floor"] / M[, "r0"]),
    range_ratio_se = se(M[, "r_floor"] / M[, "r0"]),
    c14_lo = mean(M[, "r_floor"] / (CFG$tau_dp * M[, "lev_unit"])),
    c14_hi = mean(M[, "r0"] / (CFG$tau_dp * M[, "lev_unit"])),
    h_capt = mean(M[, "h_capt"]), h_mean_idx = mean(M[, "h_mean_idx"]),
    h_mean_idx_se = se(M[, "h_mean_idx"]),
    h_bot_half = mean(M[, "h_bot_half"]),
    h_bot_half_se = se(M[, "h_bot_half"]),
    h_sig_ratio = mean(M[, "h_sig_ratio"]),
    h_sig_ratio_se = se(M[, "h_sig_ratio"]),
    comp_svr = mean(M[, "comp_svr"]), comp_svr_se = se(M[, "comp_svr"]),
    gram_svr = mean(M[, "gram_svr"], na.rm = TRUE),
    n_t = M[1, "n_t"], n_g = N_UGRID * M[1, "n_t"],
    n_sv = mean(M[, "n_sv"], na.rm = TRUE),
    n_sv_pos = mean(M[, "n_sv_pos"], na.rm = TRUE))
  save_ckpt(list(design = DESIGN, out = OUT, src_hash = SRC_HASH), CKPT)
  message(sprintf("  [%2d/%2d] n=%5d %s c14=%.1f (%.0fs)", i, nrow(DESIGN),
                  r$n, r$prelim, r$c14,
                  as.numeric(difftime(Sys.time(), t0, units = "secs"))))
}
RES <- rbindlist(OUT)

# ---- Repricing cached cells at C3(ii)'s CURRENT constants -------------------
#
# WHY THIS EXISTS, AND WHY IT IS ARITHMETIC RATHER THAN A SHORTCUT.  eq:normconst
# and eq:cap are CLOSED FORMS in (c_C, c_2):
#     omega_n  proportional to  sqrt(c_C) c_2^2,      bar_m_n  to  c_C c_2^4,
# with every other factor -- c_Pi, h_u, h_x, ||1/pi||_inf -- untouched by C3(ii)'s
# envelope.  So when the constants a cached cell was RUN under differ from the
# ones C3(ii) now certifies, those two columns move by a factor, not by a
# simulation.  Each cell carries the pair it was run under (c2_env, cC_env), so
# the factor is computed per cell and cannot be applied to the wrong vintage.
#
# ON A FRESH RUN THIS IS A NO-OP AND THE CODE SAYS SO RATHER THAN ASSUMING IT:
# the cells were run at ENV_CONST, gam is 1 to machine precision, and the branch
# returns untouched.  It fires only against a .rds computed under an earlier pair.
#
# WHAT IT REPRICES, AND THE JUSTIFICATION IS DIFFERENT FOR THE INDEX THAN FOR THE
# CAP.  omega_n and bar_m_n are closed forms, above.  THE STOPPING INDEX ALSO
# MOVES EXACTLY, but NOT by a single factor, and getting that wrong is how this
# block would ship a median stopping index of 12.85 for a rule that returns
# integers.  With relaxation omega^{-2} the iterate is
#     c_{m, j} = -(U'A'r)_j / lam_j * (1 - (1 - lam_j/omega^2)^m),
# a function of (m, omega) THROUGH m/omega^2 ALONE up to O(lam_j^2 m/omega^4), and
# lam_j/omega^2 <= 1.2e-10 here, so the flow time is exact to ten digits.  omega
# therefore reparameterises the iteration; it does not change the iterate.  The
# stop's FLOW TIME is invariant, so its INDEX scales by gam^2 -- EXCEPT on the
# m = 1 branch, which is not a flow time at all but a floor: the rule takes it
# when resid(1) <= tau_DP c_14 level, resid(1) differs from resid(0) = ||r|| by
# 1.2e-10 relative at either omega, so the branch fires on the same replications
# and returns the same integer 1.  The map on the stopping index is therefore
#     m  |-->  1 if m = 1,   m gam^2 otherwise,
# MEASURED in a paired run of the same RNG stream at both omega: across 40
# replications spanning both branches, every replication either held at exactly 1
# or scaled by exactly 12.84805 = gam^2, with identical branch membership; err
# moved by <= 6.6e-06 relative and anorm and every conditioning quantity were
# bit-identical.
#
# THE MAP IS ORDER-PRESERVING (1 is below every interior or capped stop, before
# and after), so QUANTILES map by applying it pointwise, and at_one is exactly
# mean(m1 == 1), so the MEAN maps as at_one + (m1 - at_one) gam^2.  A STANDARD
# DEVIATION of the mixture does not follow from the mean and the branch share, so
# m1_se and the stage-3 aggregates -- m_last, m_last_se, m_max, whose branch share
# is not recorded per stage -- are set to NA rather than approximated.  None of
# them is read by any table or figure; a silent approximation in a print-only
# column is how a number without provenance gets quoted later.
#
# WHAT IT DOES **NOT** REPRICE, AND THIS IS A REPORTED LIMITATION AND NOT AN
# OVERSIGHT.  The LEPSKII arm is not omega-invariant, for two reasons that are
# both about D10 and the candidate ladder rather than about the estimator:
#   (a) D10's variance proxy is sigma(m) = delta-hat sqrt(m), stated in the
#       ITERATION INDEX.  In the flow time it is delta-hat omega sqrt(t), so it
#       inflates with omega -- the classical bound it cites is for "a normalised
#       operator with UNIT RELAXATION", which is exactly the case omega = 1.
#   (b) the candidates are dyadic in m, so their phase relative to the flow time
#       shifts by log2(gam^2) mod 1 and the ladder does not map onto itself.
# Measured in the same paired run: lep1 moves by a factor of 8 or 16 rather than
# by gam^2 = 12.85, replication by replication, and mean err_lep moves by -1.7%
# to +1.1% -- of the order of its own MC standard error (0.5-1.7%), not inside it.
# lep1, lep1_se, lep_last, err_lep and err_lep_se are therefore LEFT AT THE VALUE
# THEY WERE RUN AT, and Panel D is the one panel of this arm that a change of
# C3(ii)'s constants does not certify.  Repairing it exactly costs a re-run of
# the six ORACLE cells only -- Panel D reads .SD[which.min(err)] by (n, prelim)
# and err is invariant, so which cell is the oracle does not move -- which is
# 600 replications at each n, about 1.9 core-hours at the measured 0.49 / 1.63 /
# 9.23 s per replication.  The full arm is 11.4 core-hours.
reprice_env <- function(dt, ec) {
  dt  <- copy(dt)                      # set() is by reference; do not alias RES
  gam <- sqrt(ec[["c_C"]] / dt$cC_env) * (ec[["c_2"]] / dt$c2_env)^2
  if (max(abs(gam - 1)) < 1e-12) {
    message("phi-step: cells already at C3(ii)'s current constants; no reprice")
    return(dt)
  }
  message(sprintf(paste("phi-step: REPRICING cached cells at C3(ii)'s current",
                        "(c_2, c_C) = (%.6f, %.7f); omega x %.5f-%.5f,",
                        "cap x %.4f-%.4f. Lepskii columns NOT repriced."),
                  ec[["c_2"]], ec[["c_C"]], min(gam), max(gam),
                  min(gam)^2, max(gam)^2))
  g2  <- gam^2
  mb0 <- dt$mbar_new                                   # pre-reprice, for ratios
  for (v in c("omega", "omega_se", "omega_slack")) {
    set(dt, j = v, value = dt[[v]] * gam)
  }
  for (v in c("mbar_new", "mbar_new_se")) set(dt, j = v, value = dt[[v]] * g2)
  # quantiles of the stopping index: the map applied pointwise
  for (v in c("m1_med", "m1_q10", "m1_q90")) {
    set(dt, j = v, value = fifelse(dt[[v]] > 1 + 1e-9, dt[[v]] * g2, dt[[v]]))
  }
  set(dt, j = "m1", value = dt$at_one + (dt$m1 - dt$at_one) * g2)
  # ratio_rep = m1 / bar_m_n per replication: invariant off the m = 1 branch,
  # divided by gam^2 on it (the numerator holds at 1, the denominator scales).
  set(dt, j = "ratio_rep",
      value = dt$ratio_rep - (dt$at_one / mb0) * (1 - 1 / g2))
  set(dt, j = "ratio_rep_med",
      value = fifelse(dt$ratio_rep_med * mb0 <= 1 + 1e-6,
                      dt$ratio_rep_med / g2, dt$ratio_rep_med))
  for (v in c("m1_se", "m_last", "m_last_se", "m_max", "ratio_rep_se")) {
    set(dt, j = v, value = NA_real_)
  }
  set(dt, j = "c2_env", value = rep(ec[["c_2"]], nrow(dt)))
  set(dt, j = "cC_env", value = rep(ec[["c_C"]], nrow(dt)))
  # The arithmetic invariants of the stopping rule survive the reprice, and the
  # branch shares are untouched by construction.  (m1_med against mbar_new is NOT
  # among them: it compares a median to a mean and is not an invariant of the
  # rule at either omega.)
  stopifnot(all(dt$m1 <= dt$mbar_new + 1e-9), all(dt$ratio_rep <= 1 + 1e-12))
  dt
}
RES <- reprice_env(RES, ENV_CONST)

# ---- Reproducibility assertions --------------------------------------------
#
# THESE RUN BEFORE saveRDS AND BEFORE THE TABLES (round-3 fix). Through round 2
# they ran at the very bottom of the file, so a violated invariant still wrote
# the .rds and still emitted every .tex before raising -- "it cannot ship
# silently again, but it does ship". A failed assertion must now leave the
# previous outputs in place rather than overwrite them with bad ones.
stopifnot(all(RES$m1 <= RES$mbar_new + 1e-9))          # every branch bounds the stop
sat_cells <- RES[sat_s1 > 0.999]
stopifnot(nrow(sat_cells) == 0L ||
          max(abs(sat_cells$m1 / sat_cells$mbar_new - 1)) < 1e-9)  # saturation is exact
# The three branch frequencies partition the replications.
stopifnot(max(abs(RES$at_one + RES$at_cap + RES$at_int - 1)) < 1e-12)
# Pi_t is a quadrature for a FIXED measure (D13): its total mass is Leb(T)
# whatever the node count, so nothing downstream may depend on the node count
# through the measure's normalisation.
stopifnot(abs(sum(pit_weights(TN_FIXED)) - T_VOL) < 1e-12,
          abs(sum(pit_weights(make_Tn(4L * N_TGRID))) - T_VOL) < 1e-12)
spread <- RES[, .(sp = max(mbar_new) / min(mbar_new)), by = n]
message(sprintf("  cap spread across the %d prelim x c14 cells: %s",
                RES[, .N, by = n]$N[1],
                paste(sprintf("n=%d: %.4f", spread$n, spread$sp), collapse = "  ")))

# WHICH PANELS DEPEND ON THE STOP -- VERIFIED, NOT ASSUMED (round 3). The
# condition table's Panels A, B, B' and D are built from quantities computed at
# stage 1, before any stopping decision; only its Panel C, which is built from
# err, depends on the stop. The claim is checked EXACTLY rather than by comparing
# cell means, which would measure Monte Carlo noise between cells rather than
# c_14 dependence: one replication is run twice from the same RNG state at two
# c_14 five decades apart, and every stage-1 return element must be bit-identical.
# with_fixed_seed() (sim_thm_rootn_dgp.R) saves and restores the stream, so
# INV-14's single set.seed() at the top of this script still governs.
S1_NAMES <- c("kapS1", "kapS2", "kapS3", "anorm", "omega", "mbar_new",
              "mbar_old", "a_pow", "a_exp", "r2_pow", "r2_exp", "n_res", "r0",
              "r_floor", "h_capt", "h_mean_idx", "h_bot_half", "h_sig_ratio",
              "comp_svr", "gram_svr", "hu", "hx", "I_len", "nx", "nhx",
              "c2_env", "cC_env", "Lx", "eps0", "delta_n")
s1_lo <- with_fixed_seed(424242L,
  phistep_rep(N_PHI[1], SPECS$A, ES$A, "rate", min(C14_SET), do_gram = TRUE))
s1_hi <- with_fixed_seed(424242L,
  phistep_rep(N_PHI[1], SPECS$A, ES$A, "rate", max(C14_SET), do_gram = TRUE))
stopifnot(identical(s1_lo[S1_NAMES], s1_hi[S1_NAMES]))
message(sprintf("  stage-1 quantities bit-identical across c14 in [%g, %g]: TRUE (%d elements); the stop moved %.0f -> %.0f",
                min(C14_SET), max(C14_SET), length(S1_NAMES),
                s1_lo[["m1"]], s1_hi[["m1"]]))

saveRDS(RES, here::here("quality_reports", "sim", "sim_thm_rootn_phistep.rds"))

# ---- Tables ----------------------------------------------------------------

fmt <- function(x, d = 3) formatC(x, format = "f", digits = d)
#' Integer-style formatting that cannot silently overflow.
#'
#' 2026-08-16. This was formatC(round(x), format = "d"), which coerces to
#' INTEGER. Under D11a the cap reaches 7e+10 and m-hat with it, and at those
#' magnitudes format = "d" returns NA with a WARNING, not an error -- so the
#' script would have run to completion and shipped a table of NAs in the column
#' the repair exists to report. Values at or above 1e7 print in scientific form.
big <- function(x) {
  out <- rep("---", length(x))
  ok <- is.finite(x)
  sm <- ok & abs(x) < 1e7
  out[sm] <- formatC(round(x[sm]), big.mark = ",", format = "f", digits = 0)
  lg <- ok & abs(x) >= 1e7
  if (any(lg)) {
    ex <- floor(log10(abs(x[lg])))
    out[lg] <- sprintf("$%s\\times10^{%d}$",
                       formatC(x[lg] / 10^ex, format = "f", digits = 2),
                       as.integer(ex))
  }
  out
}
stopifnot(identical(big(c(500, 114742, 6.85e10)),
                    c("500", "114,742", "$6.85\\times10^{10}$")))
sci <- function(x, d = 1) formatC(x, format = "e", digits = d)

# INV-17. Table bodies are built by vectorised sprintf into pre-sized character
# vectors and assembled ONCE; the previous version grew `lines` inside for-loops
# (`lines <- c(lines, ...)`), which the critic flagged and which carries no
# small-object exemption.
KEYS <- CJ(n = N_PHI, prelim = c("rate", "zero"), sorted = FALSE)
setorder(KEYS, n, -prelim)
# The conditioning and ill-posedness quantities are measured at STAGE 1, before
# the stop, so they do not depend on c_14 at all -- verified by the exact
# bit-identity check in the assertion block above, not assumed. Any c_14 cell
# therefore serves for those panels; 3e-2 is kept as the reference. (Cells at
# different c_14 do differ, but only by Monte Carlo noise: each cell draws its
# own B replications from its own substream.)
RES3 <- RES[abs(c14 - 3e-2) < 1e-12][KEYS, on = .(n, prelim)]

# ---- Table 1: the stopping rule against the cap and against Lepskii ---------
#
# Panel A reports the MEDIAN and the 10th-90th percentile range. ROUND-3: the
# round-2 headline -- "the stop is bimodal, either 1 or at the cap, with
# essentially no mass between" -- IS WITHDRAWN. It was an arithmetic consequence
# of the cross-term sign error: with the residual increasing in m the m = 1
# branch fired only when the threshold already exceeded resid(0), and otherwise
# the saturation branch fired, so the bisection branch could not be reached at
# any c_14. The corrected rule reaches all three branches, and Panel B reports
# the frequency of each.
mA <- dcast(RES, n + prelim ~ c14, value.var = c("m1_med", "m1_q10", "m1_q90"))
capA <- RES[, .(cap = mean(mbar_new), cap_se = mean(mbar_new_se)), by = .(n, prelim)]
mA <- capA[mA, on = .(n, prelim)]
setorder(mA, n, -prelim)
cn <- as.character(C14_SET)
bodyA <- vapply(seq_len(nrow(mA)), function(i) {
  cells <- vapply(cn, function(k)
    big(mA[[paste0("m1_med_", k)]][i]), character(1))
  sprintf("%s & %s & %s & %s \\\\", big(mA$n[i]), mA$prelim[i],
          paste(cells, collapse = " & "), big(mA$cap[i]))
}, character(1))

# Panel B: WHICH BRANCH the rule takes, and the residual range that decides it.
# The three frequencies partition the replications (asserted above). The last
# two columns are the mechanism: resid(bar_m_n)/resid(0) is the entire dynamic
# range of the discrepancy criterion over the whole admissible budget, and
# (c_14^lo, c_14^hi) is the interval of c_14 that puts tau_DP c_14 * level
# strictly inside it -- i.e. the only c_14 values at which the rule can stop in
# the interior. Reported at c_14 = 10^{-2}; both are stage-1 quantities and do
# not vary with c_14.
brD <- RES[abs(c14 - 1e-2) < 1e-12][KEYS, on = .(n, prelim)]
bodyB <- sprintf("%s & %s & %s & %s & %s (%s) & %s (%s) & (%s,\\,%s) & \\\\",
  big(brD$n), brD$prelim, fmt(brD$at_one, 3), fmt(brD$at_cap, 3),
  fmt(brD$at_int, 3), fmt(brD$at_int_se, 3),
  fmt(brD$range_ratio, 4), fmt(brD$range_ratio_se, 4),
  fmt(brD$c14_lo, 4), fmt(brD$c14_hi, 4))

# Panel C: the cap and where the inflation comes from, with MC SEs. bar_m_n is
# realised on the sample through h_u -- and only through h_u -- so it is a random
# variable and is reported with its standard error.
capC <- RES[, .(mbar = mean(mbar_new), mbar_se = mean(mbar_new_se),
                mold = mean(mbar_old), om = mean(omega), om_se = mean(omega_se),
                an = mean(anorm), an_se = mean(anorm_se),
                slack = mean(omega) / mean(anorm)), by = n]
setorder(capC, n)
bodyC <- sprintf("%s & & %s (%s) & %s & %s & %s (%s) & %s (%s) & %s & \\\\",
  big(capC$n), big(capC$mbar), big(capC$mbar_se), big(capC$mold),
  big(capC$mbar / capC$mold), fmt(capC$om, 1), fmt(capC$om_se, 2),
  fmt(capC$an, 4), fmt(capC$an_se, 4), big(capC$slack))

# Panel C': WHERE THE CAP MOVED, LEG BY LEG. *** 2026-08-16 ***
#
# The cap column moves by four to five orders between the 2026-08-15 state and
# this one, and a single blended number is not usable: three things changed at
# once and they are not the same KIND of change. eq:cap is
#     bar_m_n  =  omega_n^2 delta-hat_n^{-2},
#     omega_n  =  2 sqrt(2 c_C) c_2^2 c_Pi ||1/pi||_inf h_u^{-1} h_x^{-1/2},
# so bar_m_n is proportional to  c_C * c_2^4 * h_x^{-1} * h_u^{-2}, and the legs
# below are that product evaluated along a stated PATH. The total is
# path-independent; the legs are not, and the path is the one the repair took.
#
#   STATE 0, as shipped through 2026-08-15: h_x = n^{-0.20}, D11's renormalised
#     kern8, c_C = 4.0 (a retired compact-support half-width), c_2 = 0.8727 (the
#     INTERIOR member's max, not the envelope's).
#   LEG A, THE CONSTANTS. c_C and c_2 are properties of the family C3(ii)
#     POSITS, not of whatever the code happens to smooth with, so this leg is
#     well defined at State 0 and is the part that was wrong independently of the
#     kernel and of the bandwidth.
#   LEG B, THE BANDWIDTH, now the explicit h_x^{-1} AND NOTHING ELSE.
#   LEG C, THE FAMILY. Cap factor EXACTLY 1, and that is the point: swapping
#     D11's renormalised kern8 for Theta_I does not enter eq:cap except through
#     c_2 and c_C, which Leg A already carries. The family is paid for in the
#     BIAS -- eq:xsmoothbias and (P-g), measured by sim_thm_rootn_bdrylayer.R --
#     which is where it was supposed to be paid.
#   LEG D, THE h_u COUPLING, realised rather than derived: h_u is
#     sd(dY - Delta_{h_x} vdagger) * delta-hat^{1/8}, and the smoother enters
#     that standard deviation. Reported as the residual between the product of
#     Legs A-C and the realised ratio, so it cannot absorb an arithmetic slip.
#
# *** R10, 2026-08-17: LEG B LOST ITS CONSTANTS AND THE ORDERING ARGUMENT IS
# MOOT. ***  Leg B used to read "(hx0/hx) * (cC/cC_0) * (c2/c2_0)^4" and Leg A
# was evaluated "at the shipped bandwidth", because c_C and c_2 were computed as
# sup over {I(x) : x in X} at a given h_x and therefore MOVED WITH THE BANDWIDTH.
# They do not: C3(ii)'s constants are a sup over frak-I and carry no h_x at all.
# So the bandwidth leg is the explicit h_x^{-1}, full stop, and the "ordering
# argument" -- which quantified what applying the family at the OLD h_x would
# have cost, through (c_2(old h_x)/c_2(new h_x))^4 -- is EXACTLY 1 by
# construction, not approximately.  The column is kept and prints 1.00, because a
# reader of the 2026-08-16 vintage of this table needs to see that the factor it
# reported went to one rather than that the column vanished.
CAP0 <- data.table(n = c(500L, 2000L, 8000L),
                   hx0 = c(500, 2000, 8000)^(-HX_EXP_SHIPPED),
                   omega0 = c(46.34, 57.43, 70.72),   # RES, 2026-08-15 vintage
                   mbar0  = c(114742, 427733, 1574243))
capD <- RES[, .(hx = hx[1], I_len = I_len[1], c2 = c2_env[1], cC = cC_env[1],
                om = mean(omega), mbar = mean(mbar_new)), by = n]
capD <- CAP0[capD, on = .(n)]
capD[, legA := (cC / 4.0) * (c2 / 0.8726862)^4]
capD[, legB := hx0 / hx]
capD[, legC := 1]
capD[, legD := (mbar / mbar0) / (legA * legB * legC)]
capD[, order_cost := 1]                        # R10: exactly 1, see the note above
setorder(capD, n)
# THE PANEL PRINTS THE CONSTANTS IT WAS BUILT FROM, SO THAT IT CAN BE RESCALED
# WITHOUT RE-RUNNING, and R10 is the dispatch that CASHED THAT IN: eq:cap gives
# bar_m_n proportional to c_C * c_2^4 and eq:normconst gives omega_n proportional
# to sqrt(c_C) * c_2^2, both in closed form, so moving C3(ii)'s constants moves
# those columns by arithmetic and not by simulation. See the reprice block above
# RES for what that does and does NOT certify.
bodyCp <- sprintf("%s & %s & %s & %s & %s & %s & %s & %s & %s \\\\",
  big(capD$n), fmt(capD$c2, 3), fmt(capD$cC, 4),
  big(capD$mbar / capD$mbar0), big(capD$legA), fmt(capD$legB, 2),
  fmt(capD$legC, 2), fmt(capD$legD, 3), fmt(capD$order_cost, 2))

# Panel D: Lepskii against the discrepancy rule. ROUND-3: the comparison is now
# made at the discrepancy rule's OWN BEST c_14 in each cell -- the value of the
# sweep minimising mean ||phi-hat - phi_dagger||. That is an ORACLE the analyst
# cannot compute, since c_14 is unidentified (def:lfstep), so it hands the
# discrepancy rule an advantage Lepskii does not get. Round 2 made the comparison
# at a single fixed c_14 chosen as a "transition" value under the broken rule;
# whichever way the oracle comparison goes, it is the honest form of it. The
# fixed-c_14 column is kept alongside so the two readings are visible together.
#
# 2026-08-26: THE FIXED-c_14 COMPARISON IS NOW A DIFFERENCE OF TWO PRINTED
# COLUMNS, WHICH IT WAS NOT. The panel printed ONE Lepskii column, read at each
# row's ORACLE cell, beside TWO discrepancy columns -- oracle and fixed. Lepskii
# does not depend on c_14, so that column costs the Lepskii arm nothing; but the
# cells of the c_14 sweep are separate mclapply runs on separate draws, so
# pairing the oracle-cell Lepskii column with the fixed-c_14 discrepancy column
# CROSSES TWO CELLS. Measured on the shipped RES: the within-cell fixed-c_14
# margins run 1.94 to 6.93 standard errors, the cross-cell ones 4.09 to 6.97,
# and the two agree only at n = 8,000 under the zero preliminary, where the
# oracle IS 3e-2. Section 5 could therefore not read its own quoted range off
# this panel and said so in prose instead -- a paragraph explaining a defect
# rather than a table without one. A SEVENTH COLUMN closes it: err_lep at the
# fixed cell, which RES already carries for every (n, prelim, c_14). No re-run.
#
# THE HEADERS SHED THE REPEATED ||phi-hat - phi_dagger|| INTO THE PANEL TITLE,
# and that is what pays for the column. This float sets in a landscape longtable
# whose sibling already carries a 21.8pt overfull; the prefix moved out of two
# headers is 22 characters against 15 for the widest new cell, so the widest
# entry of every column is unchanged and the table does not grow.
orc <- RES[, .SD[which.min(err)], by = .(n, prelim)][KEYS, on = .(n, prelim)]
bodyD <- sprintf("%s & %s & %s (%s) & %s (%s) & %s & %s (%s) & %s (%s) & %s (%s) & \\\\",
  big(orc$n), orc$prelim, big(orc$lep1), big(orc$lep1_se),
  fmt(orc$err_lep, 4), fmt(orc$err_lep_se, 4),
  sprintf("$%s$", formatC(orc$c14, format = "g", digits = 2)),
  fmt(orc$err, 4), fmt(orc$err_se, 4),
  fmt(RES3$err_lep, 4), fmt(RES3$err_lep_se, 4),
  fmt(RES3$err, 4), fmt(RES3$err_se, 4))

writeLines(c(
  "\\begin{tabular}{rlrrrrrrr}", "\\toprule",
  "\\multicolumn{9}{l}{\\textit{Panel A: median $\\hat m^{(1)}$ by the unidentified $\\mathsf c_{14}$; $[q_{10},q_{90}]$ in Panel B's branch frequencies}} \\\\",
  "\\midrule",
  "$n$ & Prelim. & $\\mathsf c_{14}=10^{-4}$ & $10^{-3}$ & $10^{-2}$ & $3\\times10^{-2}$ & $10^{-1}$ & $1$ & mean $\\bar m_n$ \\\\",
  "\\midrule", bodyA, "\\addlinespace",
  "\\multicolumn{9}{l}{\\textit{Panel B: which branch the rule takes at $\\mathsf c_{14}=10^{-2}$, and the residual range that decides it}} \\\\",
  "\\midrule",
  "$n$ & Prelim. & $\\Pr(\\hat m^{(1)}{=}1)$ & $\\Pr(\\text{cap})$ & $\\Pr(\\text{interior})$ (SE) & $\\frac{\\|\\hat r(\\bar m_n)\\|}{\\|\\hat r(0)\\|}$ (MC SE) & interior-stop $\\mathsf c_{14}$ window & \\\\",
  "\\midrule", bodyB, "\\addlinespace",
  "\\multicolumn{9}{l}{\\textit{Panel C: the cap \\eqref{eq:cap}, its round-9 predecessor, and where the inflation comes from}} \\\\",
  "\\midrule",
  "$n$ & & $\\bar m_n$ (MC SE) & $\\hat\\delta_n^{-2}$ & Ratio & $\\omega_n$ (MC SE) & $\\|\\hat{\\mathcal A}\\vert_{\\mathcal S_n}\\|$ (MC SE) & $\\omega_n/\\|\\hat{\\mathcal A}\\|$ & \\\\",
  "\\midrule", bodyC, "\\addlinespace",
  "\\multicolumn{9}{l}{\\textit{Panel C$'$: where the cap moved against the 2026-08-15 state, leg by leg. $\\bar m_n\\propto c_C\\,\\mathsf c_2^{4}$, so the column rescales without re-running}} \\\\",
  "\\midrule",
  "$n$ & $\\mathsf c_2$ & $c_C$ & Total $\\bar m_n$ ratio & Constants & Bandwidth $h_x$ & Family $\\Theta_I$ & $h_u$ coupling & Reverse order \\\\",
  "\\midrule", bodyCp, "\\addlinespace",
  "\\multicolumn{9}{l}{\\textit{Panel D: $\\|\\hat\\varphi-\\varphi_\\dagger\\|$ under Lepskii and under the discrepancy rule (DP), at the latter's \\emph{oracle} $\\mathsf c_{14}$ (an advantage Lepskii is not given) and at a fixed $\\mathsf c_{14}$}} \\\\",
  "\\midrule",
  "$n$ & Prelim. & $\\hat m^{\\mathrm{Lep}}$ (MC SE) & Lep.\\ (SE) & oracle $\\mathsf c_{14}$ & DP (SE) & Lep.\\ at $3{\\times}10^{-2}$ (SE) & DP at $3{\\times}10^{-2}$ (SE) & \\\\",
  "\\midrule", bodyD, "\\bottomrule", "\\end{tabular}"),
  here::here("paper", "tables", "sim", "sim_thm_rootn_stopping.tex"))

# ---- Table 2: conditioning, ill-posedness, and the injection geometry -------
#
# Panel A. Each condition number is reported WITH the singular-value ratio it is
# built from, and the ratio is now computed INDEPENDENTLY of the condition number
# rather than as 1/sqrt(kappa) -- see the kappa comment in phistep_rep(). Both
# kappa's are ratios of relative singular values and are therefore invariant to
# the operator's normalisation, which the round-2 versions were not.
#
# The two decompositions have DIFFERENT resolution floors and the mark reflects
# that. The compression's spectrum is obtained from eigen(Aw'Aw), which resolves
# lam_j/lam_max down to eps_mach, hence sigma_min/sigma_max down to sqrt(eps_mach)
# = 1.5e-8; below that kappa is a lower bound. The Gram's is obtained from
# svd(Mg), which resolves sigma_min/sigma_max down to eps_mach.
#
# The Gram column carries a second caveat, which the round-2 mark did not: the
# object is RANK-CAPPED BY THE QUADRATURE. n_g = N_UGRID * #T = 780, so at
# n = 2,000 the n_m-dimensional Gram of eq:gram has at least 1,220 structurally
# zero eigenvalues that svd(Mg) never returns. The last column reports how many
# of the n_m singular values the number is actually built from.
EPSM <- .Machine$double.eps
mark <- function(k, svr, floor_at) {
  if (!is.finite(k)) return("---")
  if (!is.finite(svr) || svr <= floor_at) paste0("$\\ge$", sci(k)) else sci(k)
}
bodyA2 <- vapply(seq_len(nrow(RES3)), function(i) sprintf(
  "%s & %s & %s & %s & %s & %s & %s & \\\\",
  big(RES3$n[i]), RES3$prelim[i], big(RES3$Lx[i]),
  mark(RES3$kappa_S_med[i], RES3$comp_svr[i], sqrt(EPSM)),
  mark(RES3$kappa_G_med[i], RES3$gram_svr[i], EPSM),
  big(RES3$n[i]),
  if (is.finite(RES3$n_sv[i])) sprintf("%s of %s", big(RES3$n_sv[i]), big(RES3$n[i]))
  else "---"), character(1))

# Panel B. The functional form of the decay is NOT identified at this L_x: the
# fit runs on 5-8 points and the winner flips with the preliminary. What is
# reported is therefore the fraction of replications in which the exponential
# wins, alongside both fits -- and the safe reading, which is that the spectrum
# is far steeper than a = 3/4 over the resolvable directions whatever its form.
bodyB2 <- sprintf(
  "%s & %s & \\multicolumn{2}{c}{%s (%s)} & \\multicolumn{2}{c}{%s (%s)} & %s & \\\\",
  big(RES3$n), RES3$prelim, fmt(RES3$a_pow, 2), fmt(RES3$r2_pow, 3),
  fmt(RES3$a_exp, 2), fmt(RES3$r2_exp, 3),
  sprintf("%s (%s)", fmt(RES3$exp_wins, 2), fmt(RES3$exp_wins_se, 2)))

# Panel B2. L_x against its own window, in the budget arm's own manner: a
# literal constant-1 reading of (P-c) L_x >> n^{9alpha/(8s)} and (P-d)
# L_x = o(n^{1-2alpha}/ln n). These are rate statements with unspecified
# constants, so a constant-1 reading is a READING and not a violation -- exactly
# the status the budget arm gives sqrt(n) delta_n^2. It is reported because the
# whole point of that arm is placing asymptotic conditions at feasible n.
lx_lo <- N_PHI^(9 * CFG$alpha / (8 * CFG$s))
lx_hi <- N_PHI^(1 - 2 * CFG$alpha) / log(N_PHI)
lx_at <- vapply(N_PHI, lx_for, integer(1))
bodyB3 <- sprintf("%s & & %s & %s & %s & %s & %s & \\\\", big(N_PHI),
  big(lx_at), fmt(lx_lo, 2), fmt(lx_hi, 2),
  ifelse(lx_hi > lx_lo, "non-empty", "empty"),
  fmt(lx_hi / lx_lo, 3))

# Panel C. THIS IS THE ONLY PANEL OF THIS TABLE THAT DEPENDS ON THE STOP: it is
# built from err, which is the error of the discrepancy-stopped iterate. Panels
# A, B, B' and D are computed at stage 1, before any stopping decision, and the
# STAGE1 spread check above verifies that -- they are constant across the c_14
# cells to machine precision, which they could not be if the stop entered them.
#
# The two columns are DIFFERENT KINDS OF OBJECT. Whenever the "zero" preliminary
# at c_14 = 1 stops at m = 1 in every replication, phi-hat = phi-hat^(0) = 0
# identically and the ratio is ||phi_dagger||/delta_n EXACTLY -- arithmetic, with
# a genuine MC SE of zero because nothing varies. Whether that still holds under
# the corrected rule is CHECKED rather than asserted in prose, and the column
# heading is written from the check.
rr <- RES[prelim == "rate" & abs(c14 - 1) < 1e-12][order(n)]
rz <- RES[prelim == "zero" & abs(c14 - 1) < 1e-12][order(n)]
phi_l2 <- sqrt(sum(phi_dagger(seq(0, 1, length.out = 4001L), SPECS$A)^2) / 4001)
z_arith <- max(abs(rz$err / phi_l2 - 1)) < 1e-3
z_head <- if (z_arith)
  "\\multicolumn{2}{c}{Prelim.\\ ``zero'': $\\|\\varphi_\\dagger\\|/\\delta_n$, arithmetic}" else
  "\\multicolumn{2}{c}{Prelim.\\ ``zero'': measured (MC SE)}"
bodyC2 <- sprintf("%s & & %s & \\multicolumn{2}{c}{%s (%s)} & \\multicolumn{2}{c}{%s%s} & \\\\",
  big(rr$n), fmt(rr$delta_n, 3), fmt(rr$err / rr$delta_n, 3),
  fmt(rr$err_se / rr$delta_n, 4), fmt(rz$err / rz$delta_n, 3),
  if (z_arith) "" else sprintf(" (%s)", fmt(rz$err_se / rz$delta_n, 4)))

# Panel D. THE CONNECTION BETWEEN THE TWO ARMS. See phistep_rep().
bodyD2 <- sprintf("%s & %s & %s & %s & %s & %s & %s & \\\\",
  big(RES3$n), RES3$prelim, fmt(RES3$h_capt, 3), fmt(RES3$n_res, 1),
  fmt(RES3$h_mean_idx, 2), fmt(RES3$h_bot_half, 3), fmt(RES3$h_sig_ratio, 2))

writeLines(c(
  "\\begin{tabular}{rlrrrrrr}", "\\toprule",
  "\\multicolumn{8}{l}{\\textit{Panel A: two condition numbers, and they are two different objects ($\\ge$: at the double-precision floor)}} \\\\",
  "\\midrule",
  "$n$ & Prelim. & $L_x$ & $\\kappa$, compression \\eqref{eq:compress} & $\\kappa$, Gram \\eqref{eq:gram} & $n_{\\mathrm m}$ & Gram s.v.\\ computed & \\\\",
  "\\midrule", bodyA2, "\\addlinespace",
  "\\multicolumn{8}{l}{\\textit{Panel B: ill-posedness of the realised design, against H1's $\\sigma_j\\asymp j^{-a}$ with $a=3/4$}} \\\\",
  "\\midrule",
  "$n$ & Prelim. & \\multicolumn{2}{c}{Power fit: $\\hat a$ ($R^2$)} & \\multicolumn{2}{c}{Exponential fit: $\\hat c$ ($R^2$)} & Pr(exp.\\ wins) & \\\\",
  "\\midrule", bodyB2, "\\addlinespace",
  "\\multicolumn{8}{l}{\\textit{Panel B$'$: $L_x$ against \\eqref{eq:lxwindow}, at a literal constant-1 reading of (P-c) and (P-d)}} \\\\",
  "\\midrule",
  "$n$ & & $L_x$ used & (P-c) lower & (P-d) upper & Window & Upper/lower & \\\\",
  "\\midrule", bodyB3, "\\addlinespace",
  "\\multicolumn{8}{l}{\\textit{Panel C: does the $\\varphi$-step attain $\\delta_n$? $\\|\\hat\\varphi-\\varphi_\\dagger\\|_{L^2(\\pi)}/\\delta_n$ at $\\mathsf c_{14}=1$}} \\\\",
  "\\midrule",
  paste("$n$ & & $\\delta_n$ & \\multicolumn{2}{c}{Prelim.\\ ``rate'': measured (MC SE)} &",
        z_head, "& \\\\"),
  "\\midrule", bodyC2, "\\addlinespace",
  "\\multicolumn{8}{l}{\\textit{Panel D: can the limit-law arm's injected $h$ reach the directions this operator damps?}} \\\\",
  "\\midrule",
  "$n$ & Prelim. & Sieve-captured & Resolvable dim. & Energy c.o.m.\\ index & Energy in damped half & $\\sigma_1/\\sigma$ at c.o.m. & \\\\",
  "\\midrule", bodyD2, "\\bottomrule", "\\end{tabular}"),
  here::here("paper", "tables", "sim", "sim_thm_rootn_condition.tex"))

# ---- Figure ----------------------------------------------------------------

thm_sim <- theme_minimal(base_family = "serif", base_size = 10) +
  theme(panel.grid.minor = element_blank(), strip.text = element_text(face = "bold"))
fd <- melt(RES[, .(n, prelim, c14, `Discrepancy stop` = m1_med,
                   `Lepskii stop` = lep1,               # These names are drawn INSIDE the figure by geom_text, where no
              # LaTeX runs, so they must read as English.  The equation pointer
              # belongs in the caption, which is where fig:supp-stopping puts it.
              `Cap (current)` = mbar_new,
                   `Cap, round 9` = mbar_old)],
           id.vars = c("n", "prelim", "c14"), variable.name = "series",
           value.name = "m")
fd <- fd[series %in% c("Lepskii stop", "Cap (current)", "Cap, round 9") |
         (series == "Discrepancy stop")]
p <- ggplot(fd[series == "Discrepancy stop"],
            aes(n, pmax(m, 1), colour = factor(c14), shape = factor(c14),
                linetype = factor(c14))) +
  geom_line(linewidth = 0.5) + geom_point(size = 1.7) +
  geom_line(data = unique(fd[series != "Discrepancy stop",
                             .(n, prelim, series, m)]),
            aes(n, m, group = series), colour = "grey35", linewidth = 0.45,
            linetype = "dashed", inherit.aes = FALSE) +
  geom_text(data = unique(fd[series != "Discrepancy stop" & n == max(N_PHI),
                             .(n, prelim, series, m)]),
            aes(n, m, label = series), colour = "grey25", size = 2.5,
            family = "serif", hjust = 1.02, vjust = -0.5, inherit.aes = FALSE) +
  facet_wrap(~prelim, labeller = labeller(prelim = c(
    zero = "Preliminary: zero (P-a.2 fails)",
    rate = "Preliminary: rate (P-a.2 holds)"))) +
  scale_x_log10() + scale_y_log10() + scale_colour_brewer(palette = "Set2") +
  labs(x = "Sample size (log scale)", y = "Landweber iterations (log scale)",
       colour = expression(c[14]), shape = expression(c[14]),
       linetype = expression(c[14])) +
  thm_sim + theme(legend.position = "bottom")
ggsave(here::here("paper", "figures", "sim", "sim_thm_rootn_stopping.pdf"), p,
       width = 6.5, height = 3.4, device = cairo_pdf)

# ---- Post-emission diagnostics ---------------------------------------------
#
# The BLOCKING invariants now run before saveRDS and before the tables (see the
# assertion block above); what remains here is reporting, not gating.
message(sprintf("  Panel C 'zero' column vs ||phi_dagger||/delta_n: max rel. gap %.2e (arithmetic: %s)",
                max(abs(rz$err / phi_l2 - 1)), z_arith))

message("done: phi-step arm")
print(RES[, .(n, prelim, c14, m1_med, m1, mbar_new, mbar_new_se, ratio_rep,
              at_one, at_int, at_cap, range_ratio, c14_lo, c14_hi,
              lep1, kappa_S_med, err, err_lep, delta_n,
              omega_slack, a_pow, exp_wins, n_res, h_mean_idx, h_bot_half)])
