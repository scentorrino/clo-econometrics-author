# Localisation diagnostic - four-category trigger instrument

n = 983, d_Z = 5, L = 4, 2000 null draws.
The estimate is reported at BOTH truncation levels, eps_rho = 0.0300 and 0.0115; the localisation diagnostic runs at 0.0115.

## theta-hat, orthogonal one-step (eq:onestep)

**Delta TSP is the endogenous regressor and enters through phi only. There is no Delta TSP coordinate in theta.**

**No eps is chosen here.** 0.03 is EPS_RHO and is like-for-like against Section 6.2's ladder; 0.0115 exists because 0.03 binds. The binding rate under each is in the table, so the trade-off is a number rather than an argument. Clustered standard errors in parentheses.

| coefficient | L = 4 (eps 0.0300) | L = 2 (eps 0.0300) | L = 4 (eps 0.0115) | L = 2 (eps 0.0115) |
|---|---|---|---|---|
| Constant | +0.01075 (0.05737) | -0.00713 (0.05847) | +0.01053 (0.05729) | -0.00713 (0.05847) |
| Per capita income | +0.68547 (0.21534) | +0.64010 (0.19484) | +0.68391 (0.21415) | +0.64010 (0.19484) |
| Population | +0.31787 (0.07202) | +0.35335 (0.07992) | +0.31866 (0.07193) | +0.35335 (0.07992) |
| Unemployment rate | -1.01217 (0.55065) | -1.20533 (0.62144) | -1.02798 (0.54997) | -1.20533 (0.62143) |
| Manufacturing employment | +0.41597 (0.26273) | +0.24008 (0.27668) | +0.41958 (0.26061) | +0.24008 (0.27667) |
| High school | +0.82713 (0.31536) | +0.83343 (0.36794) | +0.82820 (0.31447) | +0.83343 (0.36794) |
| **truncation binds (%)** | 12.4915 | 0.0034 | 1.2915 | 0.0000 |
| **min pre-projection varrho-hat** | 4.29e-05 | 1.91e-02 | 4.29e-05 | 1.91e-02 |

At eps = 0.0300: phi-hat curves have sup gap 0.02079 and L2 gap 0.00857. Stage 5's pointwise bootstrap sd has median 0.01839, so the sup gap is 1.13 median sd (max pointwise ratio 2.96). Caveat: stage 5's band prices the second-stage phi-hat and these are the cross-fitted one, so this is an order-of-magnitude sampling scale, not a test.
Mean rel_bal: L = 4 0.00119 against L = 2 0.00130.
Mean clustered se: L = 4 0.24558 against L = 2 0.26655.

## Theory diagnostics at the localisation propensity

| quantity | value | reference | verdict |
|---|---|---|---|
| `lambda_min(Omega-hat)` | 0.01127 | `eps_rho / L` = 0.00287 | eq:omegafloor HOLDS |
| `min_l varrho-hat_l` (post-projection) | 0.0115 | `1/L` = 0.25 | >= eps by construction |
| `min_l varrho-hat_l` (PRE-projection) | 1.15e-02 | `eps_rho` = 0.0115 | **binds on 1 of 983 rows** |
| truncation binding rate, IN-SAMPLE fit | 0.1017% | -- | at eps = 0.0115, all n used to fit and to evaluate |
| truncation binding rate, CROSS-FITTED | 1.2915% | -- | at eps = 0.0115, the propensity the ESTIMATOR uses |
| `min_l varrho-hat_l`, CROSS-FITTED, pre-projection | 4.29e-05 | `eps_rho` = 0.0115 | **two orders of magnitude below the in-sample minimum.** EPS_LOCALISE was calibrated on the in-sample fit; the estimator uses the cross-fitted one |
| `c_Wtilde = min{sqrt2, sqrt(L-1)}` | 1.414214 | binary value 1 | not the binary constant |
| `delta-hat_n` (A5(i)) | 0.083724 | -- | binding branch n^{-1/2}sqrt(ln n) |

## Per-cell localisation

| cell | trigger | n | \|\|M_l\|\| | null median | p (in-sample varrho) | p (cross-fitted varrho) |
|---|---|---|---|---|---|---|
| 1 | bad-day only | 114 | 6.106e-03 | 3.025e-03 | 0.0745 | 0.0770 |
| 2 | annual-mean only | 66 | 7.780e-03 | 2.280e-03 | 0.0015 | 0.0015 |
| 3 | both | 118 | 1.127e-02 | 3.120e-03 | 0.0025 | 0.0015 |

**M5, flagged not fixed.** The `p (in-sample)` column centres the contrast at a propensity fitted on all n -- on the same W it centres -- while `draw_null_w()` redraws W without refitting. The observed statistic is shrunk by overfitting and the reference draws are not, so the test is CONSERVATIVE, which is the one bias direction that could manufacture a non-rejection. The cross-fitted column is the same statistic at the propensity the estimator itself uses. Whether prp:localise's diagnostic should use a cross-fitted propensity is a **theorist call**; nothing has been switched.

Sensitivity to the Bierens t-grid, a free implementation constant under B1(iv).
The null draws are HELD FIXED across grids, so the spread below is the grid's
contribution and not a fresh Monte Carlo error per column:

| grid seed | p (cell 1) | p (cell 2) | p (cell 3) |
|---|---|---|---|
| 20260805 | 0.0745 | 0.0015 | 0.0025 |
| 1 | 0.0730 | 0.0015 | 0.0025 |
| 20260901 | 0.0740 | 0.0015 | 0.0025 |
| 4242 | 0.0735 | 0.0015 | 0.0025 |
| **spread** | 0.0015 | 0.0000 | 0.0000 |
| **one MC se at B = 2000** | 0.0059 | 0.0009 | 0.0011 |

The base cell (l=0, attainment) carries no contrast of its own; it is recovered
as 1 - sum_l varrho_l and is what the three contrasts are measured against.

**Consistency is NECESSARY, NOT SUFFICIENT, for A1.** A cell showing no conflict
is not exonerated -- prp:localise(iii) detects cal-V_CI = empty and nothing more,
so a violation reconciled by some other phi is invisible here, and the
false-negative rate of the attribution is unpriced.  No multiplicity adjustment
is applied; three cells are tested at once.

Produced by scripts/application/app_tsp_08_localise.R.
