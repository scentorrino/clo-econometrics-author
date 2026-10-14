# Data Dictionary — `panel-npiv-discrete`

**Scope:** top candidate **C1** (Chay & Greenstone CAA/TSP county panel, 1970–1980) in full; runner-up **C2** (modern PM2.5 county panel) in summary.

**A standing rule for this file.** Where a variable's exact machine name in the source file is not known to me, the Source column names the *file* and the Status column says `CODEBOOK`. **I have not invented a single variable code.** Every `CODEBOOK` entry is resolved by opening the named ICPSR codebook and reading off the column name — a mechanical task, but one that must be done by a human with the file open, not guessed.

**Model reference.**

$$Y_{ij} = \varphi(X_{ij}) + Z_{ij}'\theta + \eta_i + U_{ij},\qquad j\in\{1,2\}$$
$$\Delta Y_i = \varphi(X_{i2}) - \varphi(X_{i1}) + \Delta Z_i'\theta + \Delta U_i$$

Roles: **Y** outcome · **X** continuous scalar endogenous, enters through $\varphi$ · **W** binary instrument · **Z** parametric controls, differenced · **KEY** identifier · **AUX** construction or diagnostic only.

---

## C1 — Chay & Greenstone CAA/TSP county panel

### C1.1 Analysis-file layout

Unit of observation: **county**. Two periods, 1970 and 1980. Estimation sample **988 counties** (VERIFIED: counties with non-missing TSP in 1970, 1980, and 1974-or-1975, and non-missing housing price in 1970 and 1980).

Recommended storage: one row per county with paired-period columns, since $T = 2$ and every quantity in the estimator is either a level at $j=1$, a level at $j=2$, or a difference. A long panel buys nothing here and complicates the differencing.

```
county_fips | y_1970 | y_1980 | x_1970 | x_1980 | w | z1_1970 | z1_1980 | ... | x_1974 | monitor_n_1970 | monitor_n_1980
```

### C1.2 Identifier

| Variable | Definition | Role | Units | Source | Status |
|---|---|---|---|---|---|
| `county_fips` | 5-digit state+county FIPS code | KEY | — | Both CCDB files and the TSP file | Present in all sources. **Watch for 1970s–1980s FIPS boundary changes** — county splits, independent-city redefinitions and the 1970s Alaska reorganisations will break a naive merge. A crosswalk pass is required, not optional |

### C1.3 Outcome — Y

| Variable | Definition | Role | Units | Source | Status |
|---|---|---|---|---|---|
| `median_house_value_1970` | County median value of owner-occupied housing units, 1970 Census | **Y** ($j=1$) | 1982–84 dollars after deflation | ICPSR 00061 (CCDB 1972) | `CODEBOOK` |
| `median_house_value_1980` | Same, 1980 Census | **Y** ($j=2$) | 1982–84 dollars | ICPSR 08256 (CCDB 1983) | `CODEBOOK` |
| `log_hv_1970`, `log_hv_1980` | Natural log of the above | **Y** as used | log points | Derived | — |
| `d_log_hv` | `log_hv_1980 − log_hv_1970` | **$\Delta Y$** | log points | Derived | — |

**Benchmarks to reproduce before trusting the build** (VERIFIED from the paper): sample mean of median house value rises from roughly **\$40,300 (1970) to \$53,168 (1980)** in 1982–84 dollars. If your assembled means do not land near these, the deflation or the sample selection is wrong. The reduced-form target is that nonattainment counties saw house prices rise about **2.5%** more, and about **0.02–0.04 log points** more in the discontinuity plots.

**Measurement caveat to carry into the paper.** This is a *median of self-reported owner valuations*, aggregated to county, not a transaction price index and not quality-adjusted. Composition change in the housing stock between 1970 and 1980 is differenced only to the extent that it is county-fixed, which it is not. Bishop et al. (2020) is the reference a referee will use; the honest response is that county aggregation and self-report are the price paid for having a 1970s panel at all, and that C2 (FHFA index) is the robustness answer.

### C1.4 Endogenous regressor — X

| Variable | Definition | Role | Units | Source | Status |
|---|---|---|---|---|---|
| `tsp_1970` | County mean TSP concentration, 1970, averaged across the county's monitors | **X** ($j=1$) | µg/m³ | EPA monitor file (FOIA-derived; see `access_instructions.md`) | Source confirmed; **aggregation rule `CODEBOOK`** |
| `tsp_1980` | Same, 1980 | **X** ($j=2$) | µg/m³ | Same | Same |
| `tsp_1974` | County **annual geometric mean** TSP, 1974 — the selection-year running variable for the 1975 designation | **AUX / conditioning** | µg/m³ | Same | VERIFIED as the selection-year variable |
| `tsp_1971` | 1971 concentrations — selection year for the *1972* designation | AUX | µg/m³ | Same | VERIFIED (their fn. 22) |

**Scalar and continuous — constraint 2 is satisfied cleanly.** One number per county per year, measured on a continuous scale.

**Two decisions the strategist must make, flagged here because they are data decisions.**
1. **Levels or logs inside $\varphi$.** Chay & Greenstone report an *elasticity* of $-0.20$ to $-0.35$, which presumes logs on both sides. If $\varphi$ takes TSP in levels, the estimated $\hat\varphi$ is not directly comparable to their number, and the comparison that motivates the application ("relaxing linearity changes the picture") loses its anchor. Recommend estimating $\varphi$ on log TSP so the linear special case *is* their specification.
2. **Which monitor aggregate.** The designation rule uses the annual **geometric** mean; the pollution exposure measure is usually an arithmetic mean over monitors. These are different numbers and using one where the other belongs will silently corrupt either the first stage or the running variable. Keep both columns.

**Measurement caveats.** (i) EPA's own statement is that pre-1980 monitor data carry "uncertainties" because nationally consistent operational and QA procedures begin only in 1980 (VERIFIED). (ii) Monitor counts per county vary and change between 1970 and 1980; carry `monitor_n_1970` and `monitor_n_1980` as diagnostics and check whether the panel's composition shift is correlated with `w`. (iii) Only **25% of total variation in 1970–80 TSP changes is within-county** (VERIFIED) — quote this, it is the defence of county aggregation.

### C1.5 Binary instrument — W

| Variable | Definition | Role | Units | Source | Status |
|---|---|---|---|---|---|
| `w_nonattain_1975` | $\mathbf{1}\{$county designated TSP nonattainment in 1975$\}$ | **W** | {0,1} | EPA designation file / Greenstone's assembled file | Rule VERIFIED; the file itself is the access bottleneck |
| `w_nonattain_7576` | $\mathbf{1}\{$nonattainment in 1975 **or** 1976$\}$ | **W** (alternative) | {0,1} | Same | The paper uses "nonattainment in either or both 1975 and 1976" in its figures — VERIFIED |
| `w_nonattain_1972` | $\mathbf{1}\{$nonattainment in 1972$\}$, set by 1971 concentrations | AUX / falsification | {0,1} | Same | VERIFIED. Chay & Greenstone argue *against* using this as the instrument — it leaves 5–6 years for sorting before the 1980 Census |
| `w_aqcr_official` | $\mathbf{1}\{$county's **Air Quality Control Region** officially designated nonattainment$\}$ | AUX — **required robustness** | {0,1} | Cropper et al. (2023) / EPA archival | **Build this.** See below |

**The designation rule (VERIFIED).** Nonattainment status is a *discrete function of the annual geometric mean and the second-highest daily TSP concentration in the previous year*. The annual federal standard is **75 µg/m³**. A county can be designated on the daily criterion alone: **67 counties** in the sample are nonattainment despite a 1974 annual geometric mean below 75, some on as few as two "bad days." That subset is the most valuable variation in the whole design, because it is the part of $W$ that is *not* a deterministic function of the annual running variable.

> **UNVERIFIED — confirm before writing.** The numeric 24-hour TSP standard (the second-highest-daily threshold). I did not confirm it from the paper or from EPA this session. Do not state a number until it is read off the paper's Data Appendix or the NAAQS table.

> **UNVERIFIED — confirm before writing.** The nonattainment/attainment split within the 988. The project bibliography records "689/300"; I could only verify **265 attainment / 149 nonattainment within the 414-county** sub-sample that has monitor readings in every year 1970–1980. Report whatever the assembled file gives, and do not carry the 689/300 figure forward unchecked.

**Why `w_aqcr_official` must be built.** Between 1972 and 1978 the *official* designation was made at the **Air Quality Control Region** level. The county-level `w_nonattain_1975` is an imputation. Cropper et al. (2023) show the choice matters materially — treatment effects on TSP of 10.2 and 9.1 µg/m³ under the official AQCR designation against 6.0 and 7.7 under the literature's county definition — and that parallel trends fail under the official designation while holding under the imputed one. For this paper the exposure is that $W$ is a **mismeasured binary instrument**. Carrying both columns turns a referee's attack into a robustness table.

### C1.6 Controls — Z

All differenced 1970→1980 unless noted. Both CCDB files; every entry `CODEBOOK`. This list is the set of controls Chay & Greenstone describe (VERIFIED as their control set); the exact column names are not.

| Variable | Definition | Role | Units | Status |
|---|---|---|---|---|
| `d_income_pc` | Change in per-capita income | Z | 1982–84 dollars | `CODEBOOK`. Rose ~15% over the decade (VERIFIED) |
| `d_unemp_rate` | Change in unemployment rate | Z | pp | `CODEBOOK`. Rose 2.2 pp (VERIFIED) |
| `d_mfg_emp` | Change in manufacturing employment | Z | count or share | `CODEBOOK`. **Decide count vs share and hold it fixed** |
| `d_population` | Change in population | Z | count or log | `CODEBOOK` |
| `d_pop_density` | Change in population density | Z | per sq mi | `CODEBOOK`. Roughly constant across the decade (VERIFIED) |
| `d_urban_share` | Change in fraction residing in urbanised areas | Z | share | `CODEBOOK`. Roughly constant (VERIFIED) |
| `d_poverty_rate` | Change in poverty rate | Z | share | `CODEBOOK` |
| `d_owner_occ` | Change in fraction of houses owner-occupied | Z | share | `CODEBOOK` |
| `d_educ_spending_share` | Change in share of government spending on education | Z | share | `CODEBOOK` |
| `d_new_construction` | Change in new home construction | Z | count or rate | `CODEBOOK` |
| `d_educ_attainment` | Change in educational attainment | Z | share or years | `CODEBOOK`. Increased visibly over the decade (VERIFIED) |
| `vacancy_1970`, `vacancy_1980` | Vacancy variables **as separate levels, not differenced** | Z | share | **VERIFIED exception (their fn. 21):** the definition changes between censuses, so the first difference is meaningless and both levels enter separately. Replicate this or explain the departure |

Expected $p \approx 8$–$14$ after choices are made — comfortably in the regime where $\theta$ is the $\sqrt n$-estimable target and $\Delta Z$ is too high-dimensional to smooth over directly, which is exactly the situation the Bierens device in the theory exists to handle.

### C1.7 Variables required for identification but not in the model's notation

| Variable | Why it is needed | Status |
|---|---|---|
| `tsp_1974` (level) | The running variable. $W$ is a cut-off rule applied to it, so $W \not\perp \Delta U$ without conditioning on it. **But $\Delta Z$ is a vector of differences and this is a level.** This is a genuine data-side/model-side mismatch and the strategist must resolve it — either the conditioning set for $\Delta U \perp W \mid \cdot$ is allowed to differ from the linear-index regressors, or the level enters $\Delta Z$ and $\theta$'s interpretation changes for that coordinate | VERIFIED as necessary; resolution out of scope for this report |
| `rd_sample_flag` | $\mathbf{1}\{$1974 geometric mean in 50–100 µg/m³, and attainment if below 75$\}$ — **475 counties** (VERIFIED) | Build it |
| `badday_sample_flag` | $\mathbf{1}\{$1974 geometric mean in 50–75 µg/m³$\}$ — **419 counties** (VERIFIED) | Build it |
| `monitor_n_1970`, `monitor_n_1980` | Attrition and aggregation-quality diagnostics; supports the monitor-attrition table recommended in `data_sources.md` | Build it |

### C1.8 Reproduction targets

Before any new estimation, reproduce these VERIFIED numbers. Each one that fails localises a build error.

| Target | Value |
|---|---|
| Estimation sample | 988 counties, ~80% of US population |
| Mean median house value | \$40,300 (1970) → \$53,168 (1980), 1982–84 dollars |
| Mean TSP decline, full sample | 8 µg/m³ |
| Reduced form, TSP | nonattainment counties fell ~10 µg/m³ (12%) more |
| Reduced form, prices | nonattainment counties rose ~2.5% more |
| IV elasticity of house value w.r.t. TSP | $-0.20$ to $-0.35$ |
| RD sub-sample | 475 counties |
| Bad-day sub-sample | 419 counties |
| Bad-day-only nonattainment counties | 67 |
| Within-county share of 1970–80 TSP change variation | 25% |

---

## C2 — Modern PM2.5 county panel (summary)

| Variable | Definition | Role | Source | Status |
|---|---|---|---|---|
| `county_fips` | 5-digit FIPS | KEY | all | — |
| `hpi_t` | FHFA annual county all-transactions house price index | **Y** | FHFA county file, or FRED `ATNHPIUS{FIPS}A` | Series confirmed; **developmental**, and suppressed where county samples are small |
| `median_value_t` | ACS median value, owner-occupied units | **Y** (alternative) | ACS 5-year | Public |
| `pm25_t` | County annual mean PM2.5 | **X** | EPA AQS annual summary files (1980–present; PM2.5 explicitly included) | Confirmed available |
| `w_pm25_nonattain` | $\mathbf{1}\{$designated nonattainment, 1997 PM2.5 NAAQS, effective 5 April 2005$\}$ | **W** | EPA Green Book | Confirmed: 39 areas, all or part of **208 counties**, 88M population. Exports and shapefiles downloadable |
| `partial_county_flag` | $\mathbf{1}\{$county designated only in part$\}$ | AUX — **essential** | Green Book | Green Book designations are areas, and some counties are split. A county-level binary $W$ requires a documented rule for partial counties, and the rule is a researcher choice that a referee will probe |
| `d_income_pc`, `d_unemp`, `d_pop`, `d_mfg_share` | Differenced covariates | Z | BEA, BLS, Census | Public |

**The one count that decides this candidate's grade.** Intersect the AQS annual PM2.5 summary file with the FHFA county index file and count counties with both, non-missing, across the chosen window. My estimate is 500–700 — at the very bottom of the simulation grid. UNVERIFIED. This is a 20-minute check and should be done before any assembly work.

---

## Cross-candidate summary: does each satisfy the five constraints?

| Constraint | C1 CAA/TSP | C2 PM2.5 | C3 Reg SHO | C4 Superfund | C5 Infant mortality |
|---|---|---|---|---|---|
| 1. Panel, $T \ge 2$ | Yes, $T=2$ exactly | Yes, $T$ flexible | Yes | Yes, $T=2$ | Yes, $T=2$ |
| 2. $X$ continuous scalar | **Yes** | **Yes** | **Yes** | **No — must be constructed** | **Yes** |
| 3. $W$ binary, defensible | Yes; attacked in print | Yes; weaker exogeneity | **Yes; strongest** | Yes but *local* | Yes; same as C1 |
| 4. $\Delta Z \in \mathbb{R}^p$ | Yes, $p\approx 8$–14 | Yes | Yes | Yes | Yes |
| 5. $n \gtrsim 500$ | **988** | ~500–700 (UNVERIFIED) | ~2,800 | UNVERIFIED | UNVERIFIED |

C1 is the only column with no red cell and no unverified $n$.
