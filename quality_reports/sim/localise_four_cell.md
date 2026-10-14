# Localisation diagnostic - four-category trigger instrument

n = 983, d_Z = 5, L = 4, 2000 null draws.
**eps_varrho = 0.0100 throughout Section 6.3**, ruled by the author on 2026-08-11: the estimate at both cardinalities, the propensity behind the theory diagnostics, and the localisation cross-fit all run at this one level.  It supersedes 0.0115, whose stated basis (the IN-SAMPLE propensity minimum) was retracted the same day; the estimator uses the CROSS-FITTED propensity, whose minimum is two orders of magnitude lower. EPS_RHO is UNCHANGED at 0.0300 and remains the level of Section 6.2's binary ladder -- see C27 in app_tsp_common.R for why the two paths can legitimately carry different constants.

## theta-hat, orthogonal one-step (eq:onestep)

**Delta TSP is the endogenous regressor and enters through phi only. There is no Delta TSP coordinate in theta.**

Both arms run on IDENTICAL cross-fitting partition streams, so the only differences between the two columns are the instrument's cardinality and what that does to the propensity. Clustered standard errors in parentheses.

**The L = 2 column is NOT Section 6.2's ladder number and must not be compared with it.** The ladder runs a different partition stream (SEED_LADDER), and at d_Z = 5 it reports 0.546 for per capita income against 0.606 here. The two differ by cross-fitting noise as well as by anything else, and no part of that gap is identified as an eps effect or as a design effect. **The comparison in this file is INTERNAL to this stage** -- L = 4 against L = 2 on one stream -- and the write-up must keep it that way.

| coefficient | L = 4 (eps 0.0100) | L = 2 (eps 0.0100) |
|---|---|---|
| Constant | -0.00252 (0.05595) | -0.01559 (0.05685) |
| Per capita income | +0.71119 (0.20275) | +0.60570 (0.18616) |
| Population | +0.31015 (0.07538) | +0.34329 (0.08376) |
| Unemployment rate | -0.99049 (0.59220) | -1.11483 (0.62375) |
| Manufacturing employment | +0.39178 (0.23975) | +0.41980 (0.27513) |
| High school | +0.87430 (0.31875) | +0.90085 (0.33963) |
| **truncation binds (%)** | 0.9966 | 0.0000 |
| **cross-fitted evaluations** | 29500 | 29500 |
| **min pre-projection varrho-hat** | 4.29e-05 | 1.91e-02 |
| **mean rel_bal** | 0.00115 | 0.00130 |
| **mean clustered se** | 0.24746 | 0.26088 |

The binding rate and the pre-projection minimum are CROSS-FITTED: they count the 29500 propensity evaluations one fit_orthogonal() run makes on fold complements, which is the object def:crossfit(a) puts in the estimator. At eps = 0.0100 the projection onto eq:trunset binds on 0.9966% of them at L = 4 and on 0.0000% at L = 2, and the pre-projection minimum is 4.29e-05 at L = 4.

At eps = 0.0100: phi-hat curves have sup gap 0.03267 and L2 gap 0.01363. Stage 5's pointwise bootstrap sd has median 0.01414, so the sup gap is 2.31 median sd (max pointwise ratio 6.09). Caveat: stage 5's band prices the second-stage phi-hat and these are the cross-fitted one, so this is an order-of-magnitude sampling scale, not a test.

## What the ruling moved

The two retired levels were RE-RUN, not read off a cached file: same partition streams for theta-hat, same null draws and same folds for the diagnostic. The differences below are therefore attributable to eps and to nothing else. **The retired levels are not the specification and appear nowhere else in this file.**

| retired eps | L = 4 abs d-theta | in se units | at coefficient | L = 2 abs d-theta | in se units |
|---|---|---|---|---|---|
| 0.0300 | 0.01674 | 0.0283 | Unemployment rate | 0.00005 | 0.0006 |
| 0.0115 | 0.00004 | 0.0008 | Constant | 0.00000 | 0.0000 |

The maximum is over coordinates of |d-theta| / se_cl and the raw difference is the one at THAT coordinate, so each row is one coefficient rather than two. The scale is the reported arm's clustered standard error throughout.

Pairwise, L = 4, in units of the reported arm's clustered se. Round 2's headline figure is the (0.0300, 0.0115) entry and is RECOMPUTED here on these arms rather than quoted:

| eps | 0.0100 | 0.0300 | 0.0115 |
|---|---|---|---|
| **0.0100** | 0.0000 | 0.0283 | 0.0008 |
| **0.0300** | 0.0283 | 0.0000 | 0.0276 |
| **0.0115** | 0.0008 | 0.0276 | 0.0000 |

Same, L = 2:

| eps | 0.0100 | 0.0300 | 0.0115 |
|---|---|---|---|
| **0.0100** | 0.0000 | 0.0006 | 0.0000 |
| **0.0300** | 0.0006 | 0.0000 | 0.0006 |
| **0.0115** | 0.0000 | 0.0006 | 0.0000 |

**Does the ruled level stay inside round 2's envelope?** The 0.0300-to-0.0115 move is 0.0276 se; the 0.0300-to-0.0100 move is 0.0283 se; the 0.0100-to-0.0115 move is 0.0008 se. At the two significant figures round 2 reported (0.029) the first two are THE SAME NUMBER, and the ruled level sits 0.0008 se from the level it replaces. At four decimals the ruled level is the FURTHER of the two from EPS_RHO, by 0.0006 se -- which is the honest answer and is a difference no reported number can carry. No coefficient moves by as much as one-thirtieth of its own standard error under any of the three levels, and at L = 2 the truncation never binds, so that arm is numerically IDENTICAL across all three (every off-diagonal entry of the L = 2 matrix is zero).

p-values at the three levels, on the SAME null draws and the SAME folds:

| eps | p (cell 1) | p (cell 2) | p (cell 3) | norm / null median |
|---|---|---|---|---|
| 0.0100 **(reported)** | 0.0395 | 0.0065 | 0.0035 | 2.25 / 3.01 / 3.17 |
| 0.0300 | 0.0390 | 0.0070 | 0.0035 | 2.25 / 2.99 / 3.18 |
| 0.0115 | 0.0395 | 0.0065 | 0.0035 | 2.25 / 3.01 / 3.17 |

These p-values are NOT comparable to the ones the artifact this run replaces carried, and the reason is not eps. The null draws were then taken from the ambient RNG state AFTER the theta-hat arms, and mclapply advances the parent L'Ecuyer stream once per forked job, so the reference sample was a function of how many arms the script ran -- and collapsing four arms to two would therefore have moved every p-value by itself. The draws now come from a dedicated substream and are a function of SEED_LOCALISE alone. The eps sweep in the table above is the clean measurement, because all three rows share one set of draws. The draw-set effect can be isolated the same way:

Holding eps at 0.0100 and changing ONLY the null draws moves the three p-values from 0.0395 / 0.0065 / 0.0035 to 0.0395 / 0.0065 / 0.0035. The cell ordering survives.

That is the scale any reading of these p-values has to clear, and it is larger than the eps effect the table above reports. **Two cells separated by a handful of exceedances out of 2000 do not carry an ordering**, and §1 and §7 currently read one off them.

## Theory diagnostics at the localisation propensity

| quantity | value | reference | verdict |
|---|---|---|---|
| `lambda_min(Omega-hat)` | 0.01127 | `eps_rho / L` = 0.00250 | eq:omegafloor HOLDS |
| `min_l varrho-hat_l` (post-projection) | 0.0115 | `1/L` = 0.25 | >= eps by construction |
| `min_l varrho-hat_l` (PRE-projection, IN-SAMPLE) | 1.15e-02 | `eps_rho` = 0.0100 | truncation does not bind |
| truncation binding rate, IN-SAMPLE fit | 0.0000% | -- | at eps = 0.0100, all n used to fit and to evaluate |
| truncation binding rate, CROSS-FITTED | 0.9966% | -- | at eps = 0.0100, the propensity the ESTIMATOR uses |
| `min_l varrho-hat_l`, CROSS-FITTED, pre-projection | 4.29e-05 | `eps_rho` = 0.0100 | orders of magnitude below the in-sample minimum. This is the gap that retracted 0.0115's calibration |
| `c_Wtilde = min{sqrt2, sqrt(L-1)}` | 1.414214 | binary value 1 | not the binary constant |
| `delta-hat_n` (A5(i)) | 0.083724 | -- | binding branch n^{-1/2}sqrt(ln n) |

## Per-cell localisation

| cell | trigger | n | \|\|M_l\|\| | null median | #{ref >= obs} | p (in-sample varrho) | p (cross-fitted varrho) |
|---|---|---|---|---|---|---|---|
| 1 | bad-day only | 114 | 6.747e-03 | 3.001e-03 | 78 | 0.0395 | 0.0420 |
| 2 | annual-mean only | 66 | 6.914e-03 | 2.296e-03 | 12 | 0.0065 | 0.0125 |
| 3 | both | 118 | 9.585e-03 | 3.020e-03 | 6 | 0.0035 | 0.0045 |

`#{ref >= obs}` is the exceedance count out of 2000 and p = (1 + exc) / (B + 1). It is reported because the two chronic cells sit within a few draws of the resolution floor: they are separated by **6 draws out of 2000**, against one Monte Carlo standard error of 0.0018. **Their ordering is not identified at this B** and must not be read as one.

**M5, flagged not fixed.** The `p (in-sample)` column centres the contrast at a propensity fitted on all n -- on the same W it centres -- while `draw_null_w()` redraws W without refitting. The observed statistic is shrunk by overfitting and the reference draws are not, so the test is CONSERVATIVE, which is the one bias direction that could manufacture a non-rejection. The cross-fitted column is the same statistic at the propensity the estimator itself uses. Whether prp:localise's diagnostic should use a cross-fitted propensity is a **theorist call**; nothing has been switched.

Sensitivity to the Bierens t-grid, a free implementation constant under B1(iv).
The null draws are HELD FIXED across grids, so the spread below is the grid's
contribution and not a fresh Monte Carlo error per column:

| grid seed | p (cell 1) | p (cell 2) | p (cell 3) |
|---|---|---|---|
| 20260805 | 0.0395 | 0.0065 | 0.0035 |
| 1 | 0.0395 | 0.0065 | 0.0035 |
| 20260901 | 0.0395 | 0.0075 | 0.0035 |
| 4242 | 0.0395 | 0.0075 | 0.0035 |
| **spread** | 0.0000 | 0.0010 | 0.0000 |
| **one MC se at B = 2000** | 0.0044 | 0.0018 | 0.0013 |

The base cell (l=0, attainment) carries no contrast of its own; it is recovered
as 1 - sum_l varrho_l and is what the three contrasts are measured against.

**Consistency is NECESSARY, NOT SUFFICIENT, for A1.** A cell showing no conflict
is not exonerated -- prp:localise(iii) detects cal-V_CI = empty and nothing more,
so a violation reconciled by some other phi is invisible here, and the
false-negative rate of the attribution is unpriced.  No multiplicity adjustment
is applied; three cells are tested at once.

## Known-open, reported not repaired

**TAU_DP = 0.7 is uncalibrated at L >= 3**, and it is why the L = 4 phi-hat converges anti-correlated with the truth. That is a separate ruling and nothing here recalibrates it. The stopping behaviour is printed at every eps so that any INTERACTION with the truncation level is visible rather than inferred:

| eps | arm | median stopping index | folds stopping at m = 1 | folds hitting the cap | diagnostic cross-fit m by fold |
|---|---|---|---|---|---|
| 0.0100 | L = 4 | 60 | 0 | 50 | 60, 60, 60, 60, 60 |
| | L = 2 | 60 | 0 | 50 | -- |
| 0.0300 | L = 4 | 60 | 0 | 50 | 60, 60, 60, 60, 60 |
| | L = 2 | 60 | 0 | 50 | -- |
| 0.0115 | L = 4 | 60 | 0 | 50 | 60, 60, 60, 60, 60 |
| | L = 2 | 60 | 0 | 50 | -- |

**`residual_norm()` returns exactly 0 at L >= 3 when `bier = NULL`**, because the no-Bierens branch of `operator_residual()` omits `pi_t` and the matrix branch of `residual_norm()` then sums an empty product. Every path in this file runs `conditional = TRUE` with `n_t = 16 > 0`, so `bier` is never NULL here and no number in this file is affected. Recorded because the defect is live for any caller that turns the Bierens family off at L >= 3.

Produced by scripts/application/app_tsp_08_localise.R.
