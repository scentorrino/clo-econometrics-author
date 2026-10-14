> ## ⚠ SUPERSEDED 2026-08-07 — READ THIS BEFORE ANY NUMBER BELOW
>
> **Every estimate in this file was produced by an estimator the paper no longer uses.**
>
> `scripts/R/lf_panel.R` began as an R port of `lfindfn_short_panel.m`, whose model is
> $\Delta U \perp\!\!\!\perp W$ **unconditionally**. This paper's A1 is the conditional form
> $\Delta U \perp\!\!\!\perp W \mid \Delta Z$. The engine had not followed: it centred the
> instrument at $\bar W$ rather than at $\varrho(\Delta Z)$, carried no Bierens family
> $w(t'\Phi(\Delta Z))$, and omitted the $\widetilde W_j$ factor `lem:adjoint`(i) places in the
> adjoint. All three were corrected on 2026-08-05/06.
>
> `scripts/simulations/sim_bierens_validate.R` (42 cells x 200 replications) shows the old engine
> was **inconsistent** once $\varrho$ varies: $\varphi$ ISE runs 1.129 → 1.100 → 1.053 across
> $n = 400/800/1600$, a ratio of 0.96 per doubling, against ~0.53 for the corrected estimator, whose
> $\theta$ bias falls 0.072 → 0.031 → 0.0035.
>
> **What changed in the re-run of 2026-08-07**, so that nothing here is quoted by accident:
> probe 2 no longer rejects A1 at any stratification (was 4 of 5); solves reaching the cap went from
> 8–10 of 50 to 29–33 of 50; per capita income lost significance at every rung; and the two
> coordinate arms now return their initial condition rather than exploding to $-3.8$ with a
> standard error of 69.
>
> **Current artifacts are the shipped tables under `paper/tables/app_tsp_*.tex`** and the prose of
> §6, which were regenerated together. The pre-correction outputs are kept, clearly labelled, at
> `quality_reports/application/pre_conditional_backup_20260806/`.
>
> This file is retained as the record of what was run and why, not as a source of current numbers.
> It has **not** been rewritten line by line; individual statements below remain as they were
> written, and several are now false. The specific ones the code critic named are corrected in
> place and marked.

# Results Summary — Section 6, hedonic TSP application

**Project:** `panel-npiv-discrete`
**Date:** 2026-08-02
**Scripts:** `scripts/application/app_tsp_{common,01_diagnostics,02_ladder,03_robustness,04_figures}.R`, driven by `app_tsp_run_all.R`
**Estimator:** applied unchanged from `scripts/R/lf_panel.R` and `scripts/R/orthogonal_theta.R`
**Claim-source map:** `quality_reports/claim_source_map_panel-npiv-discrete-section6.md`

---

## The headline, stated first

**The estimator runs, is correctly signed, and is not usable at $n = 983$ as a source of a
$\sqrt n$-inferential statement about $\theta$.** The evidence is not a large standard
error. It is that at the headline rung the fitted structural difference
$\Delta\hat\varphi$ has **3.08 times** the standard deviation of the outcome it is
supposed to decompose, and the fitted residual $\Delta\hat U$ has **3.18 times** it. An
estimator explaining a quantity with two components each three times larger than the
quantity is not delivering a $\varphi$ step; and this is exactly what this project's own
Monte Carlo verdict — *"matches at large $n$ only"* — predicts at this sample size.

The one object that survives is $\hat\varphi$ itself, which is monotonically decreasing in
TSP across the whole interior support (`paper/figures/app_tsp_phi.pdf`), i.e. the correct
hedonic sign, and the linear IV benchmark, which reproduces Chay and Greenstone's order of
magnitude.

**Nothing here was tuned to look better.** Every configuration tried is reported, including
the ones that fail.

---

## Paper-to-code naming map

| Paper symbol | Code name | Description | Source |
|---|---|---|---|
| $\Delta Y_i$ | `dy` | Change in log median property value, 1970–80 | `LogPropValue` |
| $X_{1i}$ | `x1_raw` | Mean TSP 1970, $\mu$g/m$^3$ | `MTSP1970` |
| $X_{2i}$ | `x2_raw` | Mean TSP 1980, $\mu$g/m$^3$ | `MTSP1980` |
| $\Delta X_i$ | `dx_ugm3` | $X_2-X_1$, $\mu$g/m$^3$ | constructed |
| $T(X)$ | `xc$x1`, `xc$x2` | $X$ in $[0,1]$, pooled empirical CDF | `make_x_coord()` |
| $W_i$ | `w` | Imputed 1975 county nonattainment, binary | `CATT` |
| $\widetilde W_i$ | `wtil` | $W-\bar W$ (**unconditional**, as implemented) | `crossfit_once()` |
| $\Delta Z_i$ | `Z[, -1]` | Differenced controls, $d_Z$ of them | `CTRL_ALL[seq_len(d_z)]` |
| $\theta_\dagger$ | `theta` | Target; coefficient vector on $\Delta Z$ | estimated |
| $\varphi$ | `phi`, `dphi` | Structural function; $\varphi(X_2)-\varphi(X_1)$ | estimated |
| $\Delta U_i$ | `u`, `uhat` | Structural residual | $\Delta Y-\Delta\hat\varphi-\Delta Z'\hat\theta$ |
| $\ell$, $\lambda$ | `ell`, `lam` | Representer and its primitive | `solve_balance_weight()` |
| $\hat J$ | `J` | Jacobian of the orthogonal moment | `eval_moment()$J` |
| $\hat m$ | `argmin` | Realised LF stopping index | `lf_info$iter` |
| $\delta_n$, $\hat\delta_n$ | `rate_delta_n()` | Rate symbols of A5(ii)/A4(iii) | computed |
| $\varrho(\Delta Z)$ | `rh` | $P(W=1\mid\Delta Z)$ | logit, diagnostics only |

Note the last row and the $\widetilde W$ row together. **The implemented estimator centres
$W$ unconditionally and never estimates $\varrho(\Delta Z)$.** $\varrho$ appears in this
work only as a *diagnostic* for A4(i) overlap. Consequence for reading the ladder: the
frontier's $d_Z$ cost runs through $\hat\varrho$, which this implementation does not pay,
so the ladder measures $d_Z$'s effect through the dimension of the moment and the Jacobian,
not through the propensity nuisance rate. The feasibility table is therefore a statement
about the *theory's* estimator at these $d_Z$, not a diagnosis of the code that ran.

---

## Data

`data/raw/data_tsp.txt`, Chay–Greenstone county panel, $T=2$ (1970, 1980).

| Step | Dropped | Remaining |
|---|---|---|
| Raw rows | — | 989 |
| Drop `ExpPol` (NaN in **989 of 989** — an empty column) | 0 | 989 |
| Drop counties missing the local-fiscal block | 6 | **983** |

The 6 are NY 5/47/81 (Bronx, Kings, Queens) and VA 515/595/775 (independent cities) — the
documented County–City Data Book pattern, not item non-response. The whole ladder runs on
these 983 so that movement along it is attributable to $d_Z$ alone; the full 989 is a
robustness arm.

**`DiffTSP` resolved.** `DiffTSP` $\equiv$ (`MTSP1980`$-$`MTSP1970`)$/100$, maximum absolute
deviation $5.33\times10^{-15}$ over all 989 rows: it is $\Delta X$ in units of 100
$\mu$g/m$^3$. It is redundant and **is not used**; $\Delta X$ is rebuilt from the two level
series so the units are explicit. The identity is asserted in code, not assumed.

**Candidate controls: 22, not 23.** The 23rd, `ExpPol`, is unusable.

---

## Design diagnostics

### First stage — the instrument does move TSP

| $d_Z$ | $W\to\Delta X$ ($\mu$g/m$^3$) | robust SE | clustered SE | robust $F$ | clustered $F$ |
|---|---|---|---|---|---|
| 0 | $-8.63$ | (1.74) | [2.65] | 24.5 | **10.6** |
| 5 | $-8.37$ | (1.70) | [2.32] | 24.3 | 13.0 |
| 10 | $-8.75$ | (1.90) | [2.47] | 21.3 | 12.6 |
| 22 | $-9.11$ | (1.92) | [2.52] | 22.6 | 13.1 |

Nonattainment lowers TSP by roughly 9 $\mu$g/m$^3$ — about 14% of the 1970 mean. The
first stage is strong on robust standard errors. **Under state clustering it sits at the
conventional weak-instrument boundary**: $F = 10.6$ with no controls, 12.6–13.1 with them.
Clustering is not optional here — designation was made at AQCR level (A0 assumes i.i.d.;
AQCR is not a column of this file, and state is the coarsest available proxy).

### Reduced form and the linear benchmark

| $d_Z$ | RF: $W\to\Delta Y$ | clustered SE | Linear IV on $\Delta X$ ($\times10^3$) | clustered SE |
|---|---|---|---|---|
| 0 | 0.0354 | [0.0252] | $-4.10$ | [3.64] |
| 5 | 0.0462 | [0.0124] | $-5.52$ | [2.30] |
| 10 | 0.0368 | [0.0126] | $-4.21$ | [1.89] |
| 22 | 0.0209 | [0.0116] | $-2.30$ | [1.41] |

The reduced form **more than halves** from rung 1 to rung 3 (0.0462 to 0.0209). At the
headline rung the implied semi-elasticity is $-0.0055$ per $\mu$g/m$^3$; at the 1970 mean
of 66 $\mu$g/m$^3$ that is an elasticity of $-0.36$, squarely in Chay and Greenstone's
range. This is the sanity check that the mapping is right.

### Balance — $W$ is *not* independent of $\Delta Z$

7 of 22 differenced covariates are imbalanced at 5% on robust standard errors, 4 on
clustered. Joint $F$: **6.85** robust, **10.50** clustered, both $p < 10^{-11}$. The
largest normalised differences are `UnitsWOPlumbing` (0.42), `Poverty` (0.38), `White`
($-0.38$), `PCPropTax` ($-0.25$).

This matters for the implementation, not just the design: the estimator centres $W$
unconditionally, and the data say $W$ and $\Delta Z$ are dependent. The unconditional
centring is therefore doing less than the theory's $W-\varrho(\Delta Z)$ would.

### Overlap — A4(i), the check the data assessment never ran

| Conditioning set | Min $\hat\varrho$ | Max $\hat\varrho$ | Share $\notin[.05,.95]$ | Pseudo-$R^2$ |
|---|---|---|---|---|
| $d_Z = 0$ | 0.303 | 0.303 | 0.000 | 0.000 |
| $d_Z = 5$ | 0.196 | 0.408 | 0.000 | 0.003 |
| $d_Z = 10$ | 0.026 | 0.800 | 0.005 | 0.065 |
| $d_Z = 22$ | **0.0005** | 0.901 | 0.025 | 0.112 |
| Baseline TSP only | 0.013 | **1.000** | 0.039 | 0.192 |
| Baseline TSP $+$ rung 1 | 0.012 | **1.000** | 0.044 | 0.195 |

**The fork the explorer-critic identified is now measured.** Conditioning on baseline TSP
drives $\hat\varrho$ to exactly 1 — overlap fails, as expected when designation is a
threshold rule on pre-period TSP. Not conditioning on it leaves the exogeneity of $W$
resting on the rest of $\Delta Z$. Rung 1 ($d_Z=5$) has comfortable overlap
($[0.196,0.408]$); rung 3 does not ($\min = 5\times10^{-4}$, 2.5% outside $[.05,.95]$).

### Feasibility frontier at $n = 983$

Frontier: $\kappa(\mu)\,\alpha(r,d_Z) > 1/4$, $\kappa = 2\mu/(2\mu+1)$,
$\alpha = r/(2r+d_Z)$, i.e. $r > d_Z/(4\kappa-2)$. Evaluated at $(\mu,r)=(2,8/3)$, the
frontier-clearing configuration `proofs.tex` `rem:h6bandwidth`(5) names.

| $d_Z$ | $r$ req. ($\mu{=}1$) | ($\mu{=}2$) | ($\mu{=}3$) | $\kappa\alpha$ | $\delta_n$ | $\sqrt n\delta_n^2$ | $n$ for budget $<1$ | |
|---|---|---|---|---|---|---|---|---|
| 0 | 0 | 0 | 0 | 0.400 | 0.298 | **2.8** | 1,357,005 | inside |
| 5 | 7.50 | 4.17 | 3.50 | 0.206 | 1.129 | **40.0** | never | outside |
| 10 | 15.00 | 8.33 | 7.00 | 0.139 | 1.796 | **101.1** | never | outside |
| 22 | 33.00 | 18.33 | 15.40 | 0.078 | 2.736 | **234.6** | never | outside |

**The configuration sits outside the frontier at every rung the applied literature would
accept.** Only $d_Z=0$ satisfies $\kappa\alpha>1/4$ — and even there the finite-$n$
remainder budget $\sqrt n\delta_n^2$ is 2.8, and would not fall below 1 until
$n \approx 1.36$ million. At $d_Z\ge5$ the frontier fails, so the budget never falls below
1 at any $n$. At $d_Z=5$ the required smoothness of $\varrho$ is $r>4.17$ at $\mu=2$; at
$d_Z=22$ it is $r>18.33$.

This is a finding, not a failure. It says precisely what the theory says about itself:
`cor:ratefloor`, not `thm:rootn`, describes this sample.

---

## The $d_Z$ ladder

**Rung principle (stated, as the decision record requires).** Controls are ordered by how
far they are from being *outcomes* of house prices; rungs widen along that order.

- **Rung 0, $d_Z=0$** — intercept only. The only rung where $\varrho$ is constant, so A4 is
  trivial, and the only rung where the implemented unconditional centring and the theory
  coincide exactly.
- **Rung 1, $d_Z=5$** — `PCIncome`, `Population`, `UnempRate`, `EmpManufacturing`,
  `HighSchool`. Core hedonic demand shifters plus manufacturing employment, which is the
  principal competing explanation for the 1970s property-value pattern in nonattainment
  counties. **This is the headline rung**: it is the largest the theory's own printed
  feasibility table reaches, and its overlap is comfortable.
- **Rung 2, $d_Z=10$** — adds `College`, `PopDens`, `Urban`, `Poverty`, `White`.
- **Rung 3, $d_Z=22$** — adds the housing-stock and local-fiscal blocks. The least
  defensible (per-capita property-tax revenue is mechanically a function of property
  values) and what applied practice includes.

### $\hat\theta$ along the ladder

Point estimate, (i.i.d. SE), [state-clustered SE]. Full table:
`paper/tables/app_tsp_ladder.tex`.

| Coefficient | $d_Z=0$ | $d_Z=5$ | $d_Z=10$ | $d_Z=22$ |
|---|---|---|---|---|
| Constant | 0.2318 (13.82) | $-0.0723$ (0.104) [0.125] | $-0.1119$ (0.103) [0.110] | $-0.0583$ (0.074) [0.080] |
| Per capita income | — | 0.9603 (0.323) [0.403]** | 0.8238 (0.432) [0.488]* | 0.7872 (0.227) [0.238]*** |
| Population | — | 0.3508 (0.178) [0.212]* | 0.2788 (0.132) [0.153]* | 0.2370 (0.047) [0.055]*** |
| Unemployment rate | — | $-1.0525$ (1.396) [1.448] | $-1.2739$ (1.069) [1.019] | $-0.7440$ (0.551) [0.562] |
| Manufacturing empl. | — | 0.8643 (0.788) [0.761] | 0.2809 (0.627) [0.584] | 0.0411 (0.248) [0.222] |
| High school | — | 0.5581 (0.665) [0.700] | 0.9472 (0.483) [0.474]** | 0.6362 (0.375) [0.413] |

Stars from the clustered standard error; OBES convention (stars are standard, not AEA).

**What moves.** The two coefficients that are stably signed and stably significant across
rungs are per capita income (0.96 → 0.82 → 0.79) and population (0.35 → 0.28 → 0.24) —
both decaying monotonically as controls are added, both retaining sign. Manufacturing
employment **collapses from 0.86 to 0.04** across the ladder, i.e. by more than one
clustered standard error, which is the one coefficient a reader should not treat as
identified. The intercept is not stable in sign-magnitude at rung 0 (see below).

**Standard errors fall as $d_Z$ rises**, which is the opposite of the usual pattern and is
explained by the diagnostics: the widest rung is the one where the $\varphi$ step is best
behaved (median stopping index 62 against 239 at rung 1), so it contributes the least
cross-fitting noise.

### Estimator diagnostics — this is the table that decides whether the ladder is believable

Full table: `paper/tables/app_tsp_estimator_diag.tex`. $K\times B = 5\times10 = 50$ fold
solves per rung.

| | $d_Z=0$ | $d_Z=5$ | $d_Z=10$ | $d_Z=22$ |
|---|---|---|---|---|
| Median stopping index $\hat m$ | 1 | 239 | 106 | 62 |
| Range of $\hat m$ | [1, 375] | [1, 2000] | [1, 2000] | [1, 2000] |
| Solves stopping at $\hat m=1$ | **28** | 1 | 2 | 6 |
| Solves reaching the cap $\bar m=2000$ | 0 | **10** | **8** | **9** |
| Relative balancing residual | 1.0e-3 | 9.2e-4 | 1.2e-3 | 1.4e-3 |
| Median $\kappa(\hat J)$ | 1 | 3642 | 4293 | 24893 |
| $\sigma_{\min}(\hat J)/\sigma_{\min}(E_n[\Delta Z\Delta Z'])$ | 1.027 | 1.004 | 1.007 | 0.961 |
| **Median $\mathrm{sd}(\Delta\hat\varphi)/\mathrm{sd}(\Delta Y)$** | 1.20 | **3.08** | 1.52 | 0.37 |
| **Median $\mathrm{sd}(\Delta\hat U)/\mathrm{sd}(\Delta Y)$** | 1.59 | **3.18** | 1.70 | 0.79 |
| Max $\mathrm{sd}(\Delta\hat\varphi)/\mathrm{sd}(\Delta Y)$ | 1593.3 | 7.8 | 5.7 | 4.0 |
| $\mathrm{sd}/1.4826\,$MAD of $\hat\theta_b$ | 1295.7 | 1.62 | 2.03 | 1.40 |
| Partitions $>10$ robust scales from the median | **2** | 1 | 0 | 0 |
| Sampling share of SE | 0.003 | 0.910 | 0.861 | 0.965 |
| Cross-fitting share of SE | **1.000** | 0.415 | 0.508 | 0.261 |

Read in order:

1. **The stopping rule fires, but at both extremes.** It never fails to fire — no run
   exhausted `patience` without an argmin — but the realised index ranges over the whole
   admissible interval $[1, 2000]$ within a single rung. At $d_Z=5$, **10 of 50 fold
   solves ran to the 2000-iteration cap** and 1 stopped at the first iteration (in which
   case $\hat\varphi$ *is* the initial condition and the LF step contributed nothing). At
   $d_Z=0$, **28 of 50 stopped at $\hat m=1$**.
2. **The Jacobian is fine.** $\kappa(\hat J)$ tracks the conditioning of $E_n[\Delta Z\Delta Z']$
   itself, and $\sigma_{\min}(\hat J)$ is within 4% of $\sigma_{\min}(E_n[\Delta Z\Delta Z'])$
   at every rung — the debiasing term does not degrade identification. **Nothing here is a
   near-singular-Jacobian problem.** (At $d_Z=0$, $p=1$, so $\kappa(\hat J)=1$ by
   construction and is uninformative; that is why $\sigma_{\min}$ is reported.)
3. **The balancing solve is essentially exact** — relative residual $\approx 10^{-3}$ at
   every rung. The orthogonalisation machinery works.
4. **The $\varphi$ step does not.** At the headline rung the fitted $\Delta\hat\varphi$ has
   3.08 times the standard deviation of $\Delta Y$ and the residual has 3.18 times it.
   That is under-regularisation, and it is consistent with 10 of 50 solves running to the
   cap. The one rung where the ratios are at or below 1 is $d_Z=22$ (0.37 and 0.79) — the
   rung furthest outside the feasibility frontier. The `sd`/MAD column locates the
   damage: 1.4–2.0 at the three rungs with controls (a few partitions heavier-tailed than
   Gaussian) against 1296 at $d_Z=0$, where two partitions are outright failures.

### The $d_Z=0$ rung fails, and the failure is precisely located

$\hat\theta_0 = 0.2318$ with SE $13.82$. The SE is **entirely cross-fitting spread**
(sampling share 0.003). The ten partition estimates are

```
139.06,  0.251,  0.160,  0.217,  0.228,  0.236,  7.810,  0.191,  0.220,  0.259
```

Eight cluster in $[0.16, 0.26]$; two do not, and the diagnostics flag exactly those two as
more than ten robust scales from the median. In the worst, $\mathrm{sd}(\Delta\hat\varphi)
= 274$ against $\mathrm{sd}(\Delta Y) = 0.172$ — a factor of 1593. The Jacobian in that
partition is fine ($\kappa = 1$, $\sigma_{\min} = 1.01$) and the balancing residual is
fine ($1.2\times10^{-3}$).

**Diagnosis: this is an initial-condition failure, not an estimator failure.** At $d_Z=0$,
`init_control` and `init_robinson` are *undefined* — both partial $\Delta Z$ out by
regressing on `Z[, -1]`, which at $d_Z=0$ is a zero-column matrix and makes `lm.fit()` fail
with `0 (non-NA) cases`. The only initial condition that runs is `init_poly`, a multi-start
Nelder–Mead on a non-convex CDF-matching objective, and with 28 of 50 solves stopping at
$\hat m = 1$ the LF step never corrects a bad cubic. The median across partitions is
robust; **`orthogonal_theta`'s variance formula — median sandwich plus the raw
across-partition variance — is not**, and at this rung it reports the failures rather than
the sampling uncertainty.

The $d_Z=0$ column should be read as a reference point, not as an estimate.

---

## Misclassification diagnostics

The decision record is explicit: produce *evidence*, not conclusions, and **do not assert
that non-differential misclassification holds**. Three probes, each with what it cannot
settle. Full table: `paper/tables/app_tsp_misclass.tex`.

### Probe 1 — constancy of the Wald ratio across strata: **no power, therefore uninformative**

| Stratification | Homogeneity $\chi^2_3$ | $p$ |
|---|---|---|
| Baseline TSP quartile | 4.71 | 0.195 |
| Census region | 3.74 | 0.291 |
| Manufacturing quartile | 5.04 | 0.169 |

None rejects. **This must not be read as evidence of constancy.** The within-stratum first
stages collapse: $F$ of 1.7 in the top baseline-TSP quartile, 0.0 in the West, 0.0 in the
third manufacturing quartile — where the Wald ratio is 394.55 with a standard error of
4074. A homogeneity test on ratios whose denominators are near zero has essentially no
power. The first stage and its $F$ are now printed alongside each ratio so this is visible
in the table rather than only in this note.

### Probe 2 — $W$-contrast of the fitted residual CDF within strata: **rejects**

Under A1 ($\Delta U \perp W$) the $W$-contrast of the residual distribution is null,
unconditionally *and* within any observable stratum. Statistic is a weighted Cramér–von
Mises contrast of the smoothed conditional CDFs; reference distribution from 2,000
permutations of $W$ within stratum.

| Stratification | Statistic / permutation median | $p$ |
|---|---|---|
| Unconditional | **6.41** | **0.033** |
| Baseline TSP quartile | **8.94** | **0.000** |
| Census region | 0.82 | 0.638 |
| Manufacturing quartile | **3.81** | **0.003** |
| Income growth quartile | **3.55** | **0.003** |

**The fitted residual's $W$-contrast is significantly non-null, unconditionally and within
three of four stratifications.** Under A1 it should be null. Two readings are consistent
with this and **the data here cannot separate them**:

- **(a) A1 fails for the imputed $W$** — the differential branch, under which the estimator
  is *inconsistent*, not imprecise.
- **(b) The estimator has not converged** — the $\varphi$ step is under-regularised
  (Panel C above: $\mathrm{sd}(\Delta\hat U)/\mathrm{sd}(\Delta Y) = 4.06$), so the
  residual carries fitting error that need not be independent of $W$.

Given (b) is independently established by the diagnostics, **this probe cannot be used as
evidence for the differential branch on its own.** It is a joint rejection of
{A1, convergence}, and convergence is separately in doubt.

**What the probe's null is, and is not.** The permutation holds $\hat u$ *fixed* while
relabelling $W$, and $\hat u$ was constructed using the realised $W$. That favours the
observed statistic relative to its own null, so a **rejection is conservative** and a
non-rejection (census region) is weak evidence.

### Probe 3 — the mean-reversion channel: **does not fire**

The mechanism Cropper et al. (2023) implicate is that designation tracks the pre-period TSP
level and the level mean-reverts. If the $W$-to-$\Delta Y$ relation were generated by that
channel it would collapse once the baseline level is controlled flexibly. It does not:

| Polynomial degree in $X_1$ | Coefficient on $W$ | Robust SE |
|---|---|---|
| 0 | 0.0462 | (0.0086) |
| 1 | 0.0467 | (0.0098) |
| 2 | 0.0524 | (0.0100) |
| 3 | 0.0507 | (0.0100) |

The reduced form is stable, and if anything slightly larger, under a cubic in baseline TSP.
**This is the one probe that runs in favour of the imputed designation**, and it should be
reported as such.

### Net position on the misclassification question — for the author, not for an agent

- Probe 3 finds no trace of the specific channel the contrary literature names.
- Probe 1 has no power and settles nothing in either direction.
- Probe 2 rejects the testable implication of A1, but jointly with convergence, which is
  independently in doubt — so it does not isolate differential misclassification.

**No agent has asserted, and this summary does not assert, that non-differential
misclassification holds.** The argument remains the author's; what is supplied here is the
evidence and its limits.

---

## Robustness

See the section below and `paper/tables/app_tsp_robustness.tex`.

---

## Tuning constants — every one, and where its value came from

| # | Constant | Value | Provenance |
|---|---|---|---|
| C1 | Seeds | 20260802/03/04/05, one per script | arbitrary, fixed once per script (INV-14) |
| C2 | $X$ coordinate | pooled empirical CDF onto $[0,1]$ | **CORRECTED 2026-08-07.** This row said the operator norm in $\mu$g/m$^3$ was $3.3\times10^4$ and that the iteration diverges after one step. Both were wrong and neither reached an output file: the **squared** norm is $5.8\times10^3$ (`app_tsp_07_opnorm.R`, Table S23), the convergence bound is $3.4\times10^{-4}$, the default step exceeds it by $1.5\times10^3$, and the discrepancy *falls* on step one. |
| C3 | LF step `cste` | `NULL` $\to 1/\|A\|^2$ by power iteration | `lf_panel.R` sets the step from the **squared** norm, `cste <- 1/nrm` with `nrm` = $\|A\|^2$; this row previously wrote $1/\|A\|$. |
| C4 | LF cap `lf_imax` | 2000 | longest pilot argmin was 1089. **Cap hits are counted and reported, not tuned away**; a $\bar m = 6000$ arm tests whether the cap binds on $\hat\theta$. |
| C5 | LF `patience` | 100 | the discrepancy path is monotone down to its argmin in every pilot fold that semiconverged. `orthogonal_theta()` does not expose this argument and leaves it at `lf_solve()`'s default of 30; 30 is a robustness arm. |
| C6 | Folds $K$ | 5 | `orthogonal_theta()` default. $F=2$, the value `def:crossfit` names, and $K=10$ are robustness arms. |
| C7 | Partitions $B$ | 10 (ladder), 6 (robustness), 4 (cap arm) | raised above `orthogonal_theta()`'s default of 5 because the pilot showed cross-fitting noise of the same order as the sampling SE; the two are reported separately, not merged. |
| C8 | RKHS ridge $\rho$ | $10^{-3}$ | `orthogonal_theta()` default. Swept over $\{10^{-4},10^{-3},10^{-2}\}$. |
| C9 | Cluster | `StateCode` | A0 assumes i.i.d.; designation is AQCR-level and AQCR is not in this file. State is the coarsest available proxy and most AQCRs are within-state. Both i.i.d. and clustered SEs reported side by side. |
| C10 | `xeval` grid | 5th–95th percentile of pooled $X$, 60 points | `crossfit_once()`'s own default, restated so it is visible. |
| C11 | $(\mu, r)$ | $(2, 8/3)$ | `rem:h6bandwidth`(5)'s frontier-clearing configuration, the one this project's Monte Carlo runs. **Used only to locate the application relative to the frontier**; not an input to any estimate. |
| C12 | Permutation draws | 2000 | Monte Carlo SE on a $p$-value $\le 0.011$. |
| C13 | Initial condition | `init_control` (rungs 1–3), `init_poly` (rung 0) | `orthogonal_theta()`'s default; the substitution at $d_Z=0$ is forced, reported, and is the cause of that rung's failure. |

---

## Validation

`fit_orthogonal()` in `app_tsp_common.R` exists only to add a cluster-robust variance to
what `orthogonal_theta()` already computes; it calls the same `crossfit_once()` with the
same arguments. `app_tsp_01_diagnostics.R` asserts that the two agree:

```
D7 driver validation: max |theta_driver - theta_reference| = 0.000e+00
```

Exact agreement. Any future divergence stops the pipeline (`stopifnot`).

---

## Flags for the Writer

1. **Do not write a $\sqrt n$ inferential claim about $\theta$ from this application.**
   The configuration is outside the feasibility frontier at every rung with controls, the
   remainder budget is 40–235 against a target of $o(1)$, and the fitted components are
   four times the scale of the outcome. `cor:ratefloor` is the applicable result.
2. **The $d_Z=0$ column is a diagnostic, not an estimate.** Its standard error of 13.82 is
   two failed partitions, not sampling uncertainty.
3. **Cite the clustered standard errors.** The i.i.d. sandwich is what A0 licenses and A0
   is wrong here (AQCR-level assignment, spatially correlated outcomes).
4. **The first stage is at the weak-instrument boundary under clustering** ($F = 10.6$ with
   no controls). Do not describe it as strong without the qualifier.
5. **Probe 2 must not be reported as evidence of differential misclassification** on its
   own. It is a joint rejection of {A1, convergence} and convergence is separately in
   doubt. Probe 3 is the one that runs the author's way.
6. **$\hat\varphi$ is the usable object.** Monotone decreasing across the interior support,
   correct hedonic sign, and its shape is stable. The linear IV elasticity of $-0.36$ at
   the mean matches Chay–Greenstone.
7. **`ExpPol` is an empty column and `DiffTSP` is redundant.** If either appears in a data
   appendix, it should be as an exclusion with the reason.
8. **Merge `claim_source_map_panel-npiv-discrete-section6.md` into the main claim-source
   map** when §6 is drafted, converting the Location column to grep anchors.
9. **`paper/qmd/main.qmd` §6's stale comment** ("we have none", "stays unwritten until both
   close") is now wrong on both counts and must be retired in the same edit that lands §6 —
   the decision record already flags this as the defect species this project keeps
   producing.

---

## Output files

### Tables (`paper/tables/`, bare `tabular`, booktabs, no floats or notes — INV-13, INV-3)

| File | Contents |
|---|---|
| `app_tsp_sample.tex` | sample construction and every drop |
| `app_tsp_sumstats.tex` | descriptive statistics |
| `app_tsp_firststage.tex` | first stage, reduced form, linear IV, by rung |
| `app_tsp_balance.tex` | balance of 22 differenced covariates on $W$ |
| `app_tsp_overlap.tex` | $\hat\varrho(\Delta Z)$ overlap, A4(i), by rung and on baseline TSP |
| `app_tsp_feasibility.tex` | frontier and remainder budget at $n=983$ |
| `app_tsp_misclass.tex` | the three misclassification probes |
| `app_tsp_ladder.tex` | **the headline**: $\hat\theta$ along the $d_Z$ ladder |
| `app_tsp_estimator_diag.tex` | LF stopping, Jacobian, component scale, variance decomposition |
| `app_tsp_robustness.tex` | 14 tuning arms plus two comparison estimators |

### Figures (`paper/figures/`, PDF, serif, no in-figure titles — INV-12)

| File | Contents |
|---|---|
| `app_tsp_phi.pdf` | $\hat\varphi$ on the $\mu$g/m$^3$ axis, with a rug of both periods |
| `app_tsp_lf_path.pdf` | Landweber discrepancy paths for five fold solves |
| `app_tsp_ladder.pdf` | $\hat\theta$ with 95% clustered CI along the ladder |

### Intermediate objects (`quality_reports/application/`)

| File | Contents |
|---|---|
| `app_tsp_diagnostics.rds` | drops, first stage, balance, overlap, feasibility, probes 1 and 3 |
| `app_tsp_ladder.rds` | all four rung fits with per-partition detail, probe 2, $\hat\varphi$, $\hat u$ |
| `app_tsp_robustness.rds` | 14 arms, both comparison estimators, discrepancy paths |
| `app_tsp_ladder_ckpt.rds` | fit cache with configuration fingerprint |

### Reproduction

```bash
Rscript scripts/application/app_tsp_run_all.R
```
