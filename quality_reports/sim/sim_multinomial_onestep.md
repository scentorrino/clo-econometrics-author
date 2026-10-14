# Multinomial one-step: known-truth verification at L >= 3

4 arms x 80 replications at n = 400, 800, 1600, gamma = 1.2, K = 5 folds. Seed 20260811. Produced by `scripts/simulations/sim_multinomial_onestep.R`.

## What this file settles

The arms are **paired**: they share the draw *and* the cross-fitting partition, because the RNG state is restored before each arm. The previous version did not do this -- it called the two arms in sequence with no reset, and `crossfit_once()` consumes the stream at four places -- so every arm-to-arm difference it reported, the precision claim included, was confounded with a partition difference.

Every arm is summarised on the **common** subset of draws. Filtering each arm on its own `complete.cases` would compare arms on different draws, and the draws an arm fails on are the extreme-propensity draws the bias question is about.

## V1 -- design validity, at n = 2,000,000, before any estimation

- `E[dZ dU]` = +0.00154, -0.00266, +0.00024 (target 0)
- `max_l,q |E[Wtil_l 1{dU<=q}]|` = 0.00039 at the TRUE propensity (A1, target 0)
- true `min varrho` = 9.723e-11; `P(varrho_l < 0.03)` = 0.0167, 0.0403, 0.0219, 0.0657
- verdict: **design admissible**

## Intercept bias against n, with Monte Carlo error

| arm | n = 400 | n = 800 | n = 1600 | change | se | in se |
|---|---|---|---|---|---|---|
| L=2, eps=0.03 | -0.1197 (0.0440) | -0.0743 (0.0207) | -0.1140 (0.0173) | +0.0056 | 0.0473 | +0.12 |
| L=4, eps=0.03 | -0.2912 (0.0342) | -0.3621 (0.0285) | -0.3513 (0.0219) | -0.0601 | 0.0406 | -1.48 |
| L=2, eps=1e-4 | -0.1194 (0.0440) | -0.0743 (0.0207) | -0.1140 (0.0173) | +0.0054 | 0.0473 | +0.11 |
| L=4, eps=1e-4 | -0.2921 (0.0342) | -0.3616 (0.0282) | -0.3504 (0.0221) | -0.0584 | 0.0407 | -1.43 |

Monte Carlo standard errors in parentheses. `change` is the difference between the largest and smallest n, across **disjoint** streams, so its standard error is the root sum of squares. A change under about two standard errors is not a trend.

## Truncation binding rate (%), the mechanism's own observable

| arm | n = 400 | n = 800 | n = 1600 |
|---|---|---|---|
| L=2, eps=0.03 | 0.0274 | 0.0057 | 0.0016 |
| L=4, eps=0.03 | 7.7437 | 5.4344 | 4.4070 |
| L=2, eps=1e-4 | 0.0000 | 0.0000 | 0.0000 |
| L=4, eps=1e-4 | 0.0032 | 0.0000 | 0.0000 |

The eps-truncation hypothesis is that the multinomial fit sharpens as n grows, predicted probabilities get more extreme, the floor binds more often, and the truncated propensity stops satisfying `E[Wtil_l | dZ] = 0`. That mechanism requires the binding rate to **rise** in n. Measured, it **falls**: 7.74% -> 5.43% -> 4.41% at L = 4, eps = 0.03. So the hypothesis fails on its own observable, before the paired eps comparison below is even consulted.

## Sampling spread of the slope coefficients, PAIRED

V5's question -- does the surplus contrast buy precision? -- was a one-draw comparison in the plan and an unpaired one in the first version of this file. Here it is paired and it is a Monte Carlo.

| n | sd $z_1$ (L=2, eps=0.03) | sd $z_2$ (L=2, eps=0.03) | sd $z_1$ (L=4, eps=0.03) | sd $z_2$ (L=4, eps=0.03) |
|---|---|---|---|---|
| 400 | 0.2564 | 0.2398 | 0.1788 | 0.1528 |
| 800 | 0.1621 | 0.1496 | 0.1092 | 0.0936 |
| 1600 | 0.0919 | 0.0978 | 0.0741 | 0.0734 |

The four-cell arm is tighter on both slopes at **3 of 3** sample sizes. The claim survives the re-pairing; what it did not have before was a design under which it could have failed.

## Paired arm differences

| n | L=4 minus L=2 (eps 0.03), intercept | se | L=4 eps 0.03 minus eps 1e-4, intercept | se |
|---|---|---|---|---|
| 400 | -0.1715 | 0.0503 | +0.0009 | 0.0024 |
| 800 | -0.2878 | 0.0360 | -0.0005 | 0.0010 |
| 1600 | -0.2373 | 0.0210 | -0.0009 | 0.0006 |

The second pair is the eps-truncation test. If the floor is what generates the L = 4 intercept bias, removing it must move the intercept, and the paired difference is where that shows.

**Verdict:** the paired eps effect on the L = 4 intercept is distinguishable from zero at **no sample size tested**.

Truncation does **not** explain the L = 4 intercept bias on this design. Removing the floor entirely -- from a 4.41% binding rate to 0.0000% at n = 1600 -- moves the intercept by 0.0009 against a bias of 0.3513, i.e. by **0.24% of it**. What remains is a question about whether `eq:trunset`'s truncation is admissible at L >= 3 at all, and that is a **theorist** question, not a coding one.

## What the intercept bias is, and what it is not

The bias is **in the intercept only**. At n = 1600 the slope biases are +0.0140 and -0.0133 against Monte Carlo errors of 0.0083 and 0.0082, while the intercept sits at -0.3513 against 0.0219. The paired L = 4 minus L = 2 intercept gap is -0.2373 with standard error 0.0210 -- **11.3 standard errors** -- and it does not shrink over a fourfold range of n.

**The intercept is where `phi-hat`'s systematic error lands.** The plug-in regresses `dY - d(phi-hat)` on `dZ`, and `dZ`'s first column is the constant, so the intercept absorbs `E[d(phi) - d(phi-hat)]`: any systematic error in the SHAPE of `phi-hat` shows up there and nowhere else, since a constant shift in `phi` cancels in the difference and is therefore not what is being measured. So this is a statement about the L >= 3 arm's `phi-hat`, not about the orthogonal moment for the slopes -- which is consistent with the slopes being clean at both cardinalities. It is left as a measurement; naming the cause is beyond what this design can settle.

## Failures

| n | workers that errored | draws usable in all arms |
|---|---|---|
| 400 | 0 | 79 of 80 |
| 800 | 0 | 80 of 80 |
| 1600 | 0 | 80 of 80 |

## What is not verified

This is a check that the estimator is the one the theory describes and that it recovers a known truth on an admissible design. It is **not** a test of `thm:rootn`: no rate and no coverage are claimed.

