# Probe 2 with the initial condition in the propensity

Nominal 5 per cent. n = 983, 96 replications, 300 null draws.
DGP: W's probability depends on Delta Z AND on X_1, and X_1 shares a shock with
Delta U.  So A1 (conditioning on Delta Z alone) fails by construction while
A1' (conditioning on Delta Z and X_1) holds -- the configuration the Section 6
data appears to be in.

| | rho-hat(Delta Z) | rho-hat(Delta Z, X_1) |
|---|---|---|
| A1' TRUE  (size for the second column) | 1.000 | **0.010** |
| A1' FALSE (power) | 1.000 | **0.052** |

## VERDICT: the test is disarmed, and the non-rejection is uninformative

Power 0.052 against size 0.010. The test rejects a genuine violation of A1' about
one time in twenty. So the p = 0.34 obtained on the Section 6 data once X_1 enters
the propensity is **not** evidence that A1' holds -- it is what a powerless test
returns whether or not the null is true.

What survives:

* **A1 is rejected**, on a stratification whose size holds under both a
  homogeneous and a heterogeneous first stage (see `probe2_size_summary.md`),
  robustly across conditioning sets from 5 to 22 covariates and across all four
  readings of the instrument's bad-day rule.
* **A1' is untested.** Not supported, not refuted.

Why the power collapses is itself informative: conditioning the propensity on
X_1 absorbs most of the variation in W, because W IS a threshold rule on the
pollution level and the level is what X_1 measures. Little independent variation
in W remains to test against -- which is a statement about how nearly the
instrument is a function of the initial condition, not merely about this test.

CALIBRATION CAVEAT, and it bounds what this file can claim: the DGP sets the
loading of W on X_1 at 2.5 on (x1 - 0.5). If that over-determines W from the
initial condition relative to the application -- where varrho-hat's pseudo-R^2
rises from 0.132 to 0.330 when X_1 is added, so two-thirds of the variation in W
does survive -- then the power loss here is overstated. Matching that loading to
the data's is the obvious next step and has not been done.

Produced by scripts/simulations/sim_probe2_initcond.R.
