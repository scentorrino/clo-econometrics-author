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

# Results Summary — Section 6, hedonic application (`panel-npiv-discrete`)

**Date:** 2026-08-03
**Data:** `data/raw/data_tsp.txt` — Chay & Greenstone county panel, $T=2$, first-differenced
**Code:** `scripts/application/app_tsp_{common,01_diagnostics,02_ladder,03_robustness,04_figures}.R`,
driven by `app_tsp_run_all.R`
**Status:** Estimation complete. **Section 6 is not yet writable** — see *Blocking gaps* below.

---

## 0. The framing decision, and why it changes the section

**The object of interest is $\varphi$, not $\theta$.** Decided by the author 2026-08-03.

In this model $\Delta Y = \varphi(X_2)-\varphi(X_1) + \Delta Z'\theta + \Delta U$, the pollution
variable $X$ (mean TSP) enters through the **nonparametric** $\varphi$, and $\Delta Z$ are
demographic and fiscal controls. So the hedonic price of air quality — the economic question — is
$\varphi$, and $\theta$ is a vector of control coefficients.

This inverts the usual reading of the paper's own theorem. The $\sqrt n$ result is about $\theta$;
here $\theta$ is not what the application is for. **The paper should say explicitly that the two
roles are interchangeable across applications** — that one is often interested in the parametric
part and not the nonparametric one, and that this application happens to run the other way. That
sentence is owed to the reader and does not currently exist anywhere in the manuscript.

Consequence for the section's structure: the $d_Z$ ladder (§3 below) is now a **robustness axis**
for $\varphi$, not the headline. It was commissioned as the headline and must be re-framed.

---

## 1. Sample

| Step | Dropped | Remaining |
|---|---|---|
| Raw rows in `data_tsp.txt` | — | 989 |
| Drop column `ExpPol` (NaN in **989 of 989** rows) | 0 | 989 |
| Drop counties missing the local-fiscal block | 6 | 983 |
| **Analysis sample** | | **983** |

Source: `paper/tables/app_tsp_sample.tex`. Note `ExpPol` is entirely missing — it is a column of
NaN, not a column with gaps, so the usable control count is **22**, not 23. The $d_Z=22$ rung is
therefore "all usable", not "all".

Instrument $W$ = `CATT` (1975 nonattainment), 300 ones / 689 zeros in the raw file.

---

## 2. Headline: the estimated hedonic price function $\hat\varphi$

**Artifact:** `paper/figures/app_tsp_phi.pdf` — $\hat\varphi(x)-\hat\varphi(\text{median }x)$
against mean TSP, with a rug for the 1970 and 1980 marginals.

**Shape.** Monotone decreasing across the whole support, steepest between roughly 55 and 70
$\mu$g/m$^3$, flattening above ~80. Read off the figure's axis, the curve spans approximately
$+0.37$ at the low end of the support to $-0.40$ at 100 $\mu$g/m$^3$ — **about 0.75–0.8 log
points** across the range. Sign and curvature are what the hedonic literature expects: dirtier air,
lower property values, with the response concentrated in the middle of the distribution.

> **These figures are read off a plot and are not authoritative.** No numerical table of
> $\hat\varphi$ exists. See *Blocking gaps* item 1.

**Comparison.** Linear IV on the same sample gives a slope of $-4.1$ to $-5.5\times10^{-3}$ log
points per $\mu$g/m$^3$ (`app_tsp_firststage.tex`, Panel C). Over a 40 $\mu$g/m$^3$ swing that is
$0.16$–$0.22$ log points — so **the nonparametric estimate is three to five times larger** across
the support than the linear specification implies, which is the substantive reason for running the
nonparametric estimator at all. Whether that gap survives uncertainty quantification is not yet
known.

---

## 3. The $d_Z$ ladder (now a robustness axis)

Rungs: $d_Z \in \{0, 5, 10, 22\}$, chosen most-defensible-controls-first
(`paper/tables/app_tsp_ladder.tex`, $n=983$ throughout, robust SEs in `()`, clustered in `[]`).

Coefficients that are stable and signed as expected across rungs 2–4: **per capita income**
(0.96\*\*, 0.82\*, 0.79\*\*\*) and **population** (0.35\*, 0.28\*, 0.24\*\*\*). Population density
becomes significant only at $d_Z=22$ (0.096\*\*\*). Unemployment, manufacturing employment,
poverty and urban share are insignificant at every rung.

The $d_Z=0$ column is **not usable**: the constant is 0.2318 with a standard error of **13.82**.
That is not a wide interval, it is a failure — see §5.

---

## 4. Identification diagnostics

### 4a. First stage — strong

`app_tsp_firststage.tex`. $W$ moves $\Delta X$ by $-8.37$ to $-9.11$ $\mu$g/m$^3$ (the four
coefficients are $-8.627$, $-8.369$, $-8.755$, $-9.108$; an earlier version of this line wrote
"$-8.6$ to $-9.1$", which brackets neither end), significant at
1% at every rung. Robust $F$ = 21.3–24.5; **clustered $F$ = 10.6–13.1**, which is the number to
report — it straddles the conventional weak-instrument threshold of 10 rather than clearing it
comfortably. Reduced form: 0.021–0.046, significant at rungs 2–4.

### 4b. Misclassification probes — split, and the failing half is load-bearing

`app_tsp_misclass.tex`. The author's decision was to keep the **imputed** county designation and
defend non-differential misclassification. The evidence does not settle it.

| Probe | What it tests | Result |
|---|---|---|
| **1. Wald-ratio constancy** across baseline-TSP quartile, census region, manufacturing quartile | heterogeneity that differential misclassification would induce | **Passes.** $\chi^2_3$ homogeneity $p = 0.195$, $0.291$, $0.169$ |
| **2. $W$-contrast of the fitted residual CDF within strata** | $\Delta U \perp\!\!\!\perp W$, i.e. **A1 itself** | **Rejects at 3 of 5.** Unconditional $p=0.033$; baseline-TSP quartile $p<0.001$; manufacturing quartile $p=0.003$; income-growth quartile $p=0.003$. Only census region passes ($p=0.638$) |
| **3. Reduced form under flexible control for baseline $X_1$** | sensitivity to pre-period pollution | **Stable.** 0.0462 → 0.0467 → 0.0524 → 0.0507 across polynomial degrees 0–3 |

**Probe 2's rejection cannot be attributed, and the report must say so.** The residual it tests is
*fitted*, by an estimator whose own diagnostics (§5) show it is not converging at this sample size.
A rejection is consistent with (i) failure of the independence assumption, (ii) failure of
non-differential misclassification, or (iii) estimator failure contaminating the residual. **These
diagnostics cannot separate the three.** Reporting the rejection while stating the confound is the
honest course; a referee running the same probe will find the same thing.

### 4c. Overlap

`app_tsp_overlap.tex`. Fine at $d_Z \le 10$. At $d_Z=22$ the propensity score runs
$[0.001, 0.901]$ with 2.5% outside $[.05,.95]$ and 9.9% outside $[.10,.90]$. Conditioning on
baseline TSP pushes the maximum to **1.000** — perfect in-sample prediction, an overlap failure —
which is worth knowing given Probe 2 stratifies on exactly that variable.

---

## 5. Estimator behaviour — the estimator does not deliver a credible $\hat\theta$ at $n=983$

`app_tsp_estimator_diag.tex`. Reported because it is a finding, not because it is a failure to
hide.

- **Non-convergence.** 8–10 of 50 fold solves hit the iteration cap $\bar m = 2000$ at every
  $d_Z>0$. Median stopping index 239 / 106 / 62 at $d_Z = 5/10/22$.
- **$d_Z=0$ is degenerate.** 28 of 50 solves stop at $\hat m = 1$; max
  $\text{sd}(\Delta\hat\varphi)/\text{sd}(\Delta Y) = \mathbf{1593.3}$; sd / robust-scale of
  $\hat\theta_b$ across partitions $= \mathbf{1295.68}$. The **sampling share of the standard error
  is 0.003** — essentially the whole reported SE is cross-fitting noise.
- **Jacobian conditioning.** Median $\kappa(\hat J)$ rises 1 → 3,642 → 4,293 → **24,893**, max
  30,739 at $d_Z=22$.
- **What is healthy:** the relative balancing residual is $\approx 10^{-3}$ at every rung, and
  $\sigma_{\min}(\hat J)/\sigma_{\min}(E_n[\Delta Z\Delta Z'])$ stays within 4% of 1 — the moment
  condition is being solved; it is the stopping rule and the conditioning that are not.

---

## 6. Feasibility against the paper's own frontier

`app_tsp_feasibility.tex`, evaluated at $(\mu,r)=(2,8/3)$.

| $d_Z$ | $\kappa\alpha$ | $\delta_n$ | $\sqrt n\,\delta_n^2$ | $n$ for budget $<1$ | Verdict |
|---|---|---|---|---|---|
| 0 | 0.400 | **0.644** | **13.0** | **2.1×10¹¹** | inside |
| 5 | 0.206 | 1.129 | 40.0 | never | **outside** |
| 10 | 0.139 | 1.796 | 101.1 | never | **outside** |
| 22 | 0.078 | 2.736 | 234.6 | never | **outside** |

**Only $d_Z=0$ sits inside the frontier, and even there the remainder budget needs $n\approx1.36$
million.** The smoothness required to clear the frontier at $d_Z=5$ is $r=3.5$ even at $\mu=3$; at
$d_Z=22$ it is $r=15.4$. This is consistent with the Monte Carlo verdict ("matches at large $n$
only") and with §5. **The application illustrates the procedure; it does not demonstrate that the
asymptotics bind at $n=983$.** The section must say this in its own voice.

---

## 7. Robustness — one arm is disqualifying and must not be buried

`app_tsp_robustness.tex`, 15 arms plus two comparison estimators.

**Stable arms.** Step size $c \in \{1.0, 0.5, 0.1\}$, ridge $\rho \in \{10^{-4},10^{-2}\}$,
patience, cap $\bar m = 6000$, folds $K=2$ vs $10$, and the all-989-county sample all keep the
constant within roughly $[-0.15, +0.03]$ and population within $[0.29, 0.45]$.

**The scale arms do not.** Re-expressing $X$:

| Arm | Constant (SE) | Per capita income (SE) |
|---|---|---|
| Baseline | −0.0677 (0.1386) | 0.6816 (0.5111) |
| $X$ in $\mu$g/m$^3$ | 1.1758 (**9.2110**) | −3.6510 (**37.3284**) |
| $X$ min–max scaled | 0.4691 (**10.6739**) | −3.7961 (**68.8991**) |

**Standard errors inflate by two orders of magnitude and point estimates change sign under a
monotone rescaling of $X$.** A rescaling of the regressor should be absorbed by the bandwidth and
the stopping rule; here it is not. This is the single most serious finding in the run and it points
at the tuning constants being scale-dependent rather than at the theory. It should be diagnosed
before Section 6 is drafted, because a reader who rescales the data gets a different paper.

**Comparisons.** Linear IV (2SLS) gives a constant of −0.2955 (0.3150); the draft alternating-LF
estimator gives −0.0074. The baseline sits between them.

---

## 8. Blocking gaps — what stands between this and a drafted Section 6

1. ~~**$\hat\varphi$ has no uncertainty quantification and no numerical table.**~~ **CLOSED** by stages 05–07, which this file predates: `app_tsp_phi.tex` prints the curve at eleven deciles with a bootstrap envelope, `app_tsp_phi_boot_compare.tex` compares five resampling schemes, and `app_tsp_opnorm.tex` prices the coordinate choice. None of it is a confidence set and §6 says so. Original text: It is now the
   headline object of the section and it is a single unbanded curve. A confidence band (bootstrap
   or the paper's own variance result, whichever is defensible for the nonparametric part) and a
   table of $\hat\varphi$ at named TSP levels are both required. **Nothing can be written about
   magnitudes until this exists.**
2. **The scale-sensitivity finding (§7) is unexplained.** Diagnose before drafting.
3. ~~**No claim-source map.**~~ **FALSE — CORRECTED 2026-08-03.** A §6 claim-source map **does**
   exist, at `quality_reports/claim_source_map_panel-npiv-discrete-section6.md` (written
   2026-08-02, 44 rows, every number traced to a script and line). The estimation agent wrote it
   before it terminated. Three of its line references were spot-checked against the scripts and
   point exactly where claimed. INV-22 is **satisfied for §6**.
   *This entry was wrong when written: it inferred the map's absence from the agent's termination
   rather than checking the directory. That is the defect species this project keeps producing — a
   claim about an artifact that the artifact contradicts — committed here in the very file that
   catalogues it.*
   What the §6 map does still need: its `Location` column is empty by design, because §6 is not
   drafted and there are no `main.qmd` grep anchors to point at. It is to be merged into the main
   map as a §6 block once §6 exists.
4. **Stale comment blocks.** `main.qmd`'s §6 block still says the section "stays unwritten until
   both close"; both are now closed. `CLAUDE.md`'s §6 row still says "DECIDED, scoping" and "Data
   discovery in progress" — the data is on disk and the design is settled. Both must be retired in
   the same edit that drafts §6, per the decision record.

---

## 9. Artifacts

**Tables** (`paper/tables/`, bare `tabular` + booktabs per INV-13, wrapped by the manuscript):
`app_tsp_sample`, `app_tsp_sumstats`, `app_tsp_balance`, `app_tsp_overlap`, `app_tsp_firststage`,
`app_tsp_misclass`, `app_tsp_ladder`, `app_tsp_estimator_diag`, `app_tsp_feasibility`,
`app_tsp_robustness`.

**Figures** (`paper/figures/`): `app_tsp_phi.pdf` (the headline), `app_tsp_ladder.pdf`,
`app_tsp_lf_path.pdf`.

**Not produced:** results summary was written post hoc by the orchestrator from the artifacts; the
estimation agent terminated on a usage limit before writing it, and before the claim-source map.
Every number in this file was read from the table or figure named beside it.
