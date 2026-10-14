# Data Sources — `panel-npiv-discrete`

**Prepared by:** explorer
**Date:** 2026-07-31
**Target journal:** Oxford Bulletin of Economics and Statistics (applied econometrics, practitioner readership)
**Model to be served:**

$$Y_{ij} = \varphi(X_{ij}) + Z_{ij}'\theta + \eta_i + U_{ij}, \qquad j \in \{1,2\}$$

first-differenced to $\Delta Y = \varphi(X_2) - \varphi(X_1) + \Delta Z'\theta + \Delta U$, identified off $\Delta U \perp W \mid \Delta Z$ together with $E[\Delta U \mid \Delta Z] = 0$.

**Hard constraints (all five must hold):** (1) panel, $T \ge 2$; (2) $X$ continuous **scalar** endogenous, entering nonparametrically; (3) $W$ **binary** instrument with defensible exogeneity; (4) $\Delta Z \in \mathbb{R}^p$ parametric controls; (5) $n \gtrsim 500$.

---

## 0. Headline findings — read this first

**Finding 1 — the binary requirement, not the panel requirement, is what binds.** Constraint 3 eliminates almost the entire standard applied-micro data landscape. The reason is structural, not accidental: in the settings where applied economists have a genuinely binary instrument (lotteries, eligibility indicators, sibling-sex composition, draft numbers, college proximity), the endogenous regressor is *also* binary or discrete — insurance coverage, veteran status, years of schooling, number of children. A binary instrument paired with a *continuous scalar* endogenous regressor survives in essentially two families only:

- **(A) A continuous quantity regulated by a threshold rule.** The regulator observes a continuous variable, applies a cut-off, and imposes a binary designation. The designation is the instrument; the regulated quantity is $X$.
- **(B) A randomised binary offer that shifts a continuous behaviour.** Encouragement designs where the encouraged margin is continuous.

Everything credible I found sits in (A) or (B). This is worth stating in the paper: the binary instrument is not a pathological special case invented for the theory, it is the *generic* form of instrument in threshold-based regulation, and that is precisely where existing NPIV theory has nothing to say.

**Finding 2 — the author's scoped setting is the right one, and it is the only candidate that satisfies all five constraints with no construction work.** Chay & Greenstone (2005) is a literal, term-by-term instance of the model: a two-period first-differenced county panel, a continuous scalar endogenous regressor (TSP), a binary instrument (nonattainment designation), a vector of differenced covariates, and $n = 988$. I verified this from the paper itself, not from the bibliography entry. Recommend it as the application.

**Finding 3 — but the instrument has a documented, published attack on it, and the paper must pre-empt it.** Between 1972 and 1978 the *official* Clean Air Act nonattainment designation was made at the **Air Quality Control Region** level, not the county level. Chay & Greenstone impute a county-level designation from monitor readings. Murphy (2016, 2017) identified this discrepancy and examined its consequences for exactly the regression-discontinuity designs Chay & Greenstone use; Cropper, Muller, Park & Perez-Zetune (2023, *JEEM* 121) quantify it. This is the single most damaging referee objection available and it is already in print. Details in §2.1.

**Finding 4 — feasibility is a genuine risk on the flagship candidate, and I am not going to soften it.** The housing and covariate side is free and immediate (ICPSR). The TSP side is not: Chay & Greenstone obtained annual county TSP concentrations **through a Freedom of Information Act request** (their words, verified). The data are not attached to the published paper. There are three recovery routes of descending reliability (§2.1, "Access"), and the fastest — emailing Greenstone — is documented to work, because he shared his attainment-status data with Cropper et al. Budget four to eight weeks and start this in week 1, not week 6.

**Finding 5 — there is a fully public, grade-A fallback in the same setting, and it is weaker on the instrument, not stronger.** A modern PM2.5-nonattainment county panel can be assembled today from EPA AQS, the EPA Green Book, FHFA and ACS with no permissions at all. But modern designations involve state recommendations and negotiated area boundaries, so the "deterministic function of monitor readings" story that makes the 1970s instrument defensible is *weaker* in the 2000s, not better. Do not present C2 as an upgrade to C1. It is an insurance policy and a robustness exhibit.

---

## 1. Ranking

Ranked on the binary instrument first, as instructed, then on feasibility, which OBES forces me to weight heavily.

| # | Candidate | Setting | Binary $W$ quality | Maps to model? | Feasibility | $n$ |
|---|-----------|---------|--------------------|----------------|-------------|-----|
| **C1** | **Chay & Greenstone CAA/TSP county panel, 1970–1980** | Hedonic, air quality | Threshold rule; strong but attacked (§2.1) | **Yes, literally** | **B** | **988** |
| **C2** | Modern PM2.5 nonattainment county panel, 2000s | Hedonic, air quality | Threshold rule, but negotiated boundaries | Yes | **A** | ~500–700 (UNVERIFIED) |
| **C3** | SEC Regulation SHO short-sale pilot, 2005–2007 | Firm/market panel | **Best of any candidate** — mechanical assignment by the regulator | Yes | **B/C** | ~2,800 |
| **C4** | Greenstone & Gallagher Superfund NPL, 1980–2000 | Hedonic, hazardous waste | Sharp HRS 28.5 cut-off; but *local* | **Only with a constructed $X$** | **C** | ~1,300 tracts (UNVERIFIED) |
| **C5** | CAA/TSP → infant mortality, 1970–1980 | Health | Identical to C1 | Yes | **B** | ~500–900 (UNVERIFIED) |

C5 is not an independent candidate — it reuses C1's instrument and most of C1's infrastructure. It is listed because it is the cheapest possible *second* application once C1 is built, and because a referee who dislikes hedonic interpretation may be satisfied by a non-price outcome.

---

## 2. Candidates in full

### C1 — Chay & Greenstone (2005), Clean Air Act / TSP county panel — **GRADE B**

**Provider.** Two components with different providers.
- Housing values and county characteristics: *County and City Data Books* — **ICPSR 00061** (CCDB 1972, based on the 1970 Census) and **ICPSR 08256** (CCDB 1983, based on the 1980 Census). Free to users at ICPSR member institutions.
- TSP concentrations and nonattainment designation: originally obtained by Chay & Greenstone via **FOIA request to EPA**, covering "the universe of state and national pollution monitors" (verified, their §III). Not distributed with the article.

**Coverage.** United States counties. Two periods, 1970 and 1980. Primary estimation sample = **988 counties** with non-missing TSP in 1970, 1980 and 1974-or-1975, and non-missing housing prices in 1970 and 1980; approximately **80% of the US population** (verified from the paper). Sub-samples used for their validity tests: 475 counties in the regression-discontinuity sample (1974 geometric mean TSP in 50–100 µg/m³, dropping counties nonattainment solely by the daily-violation rule); 419 counties in the "bad day" sample (1974 geometric mean 50–75 µg/m³).

**Mapping onto the model — explicit.**

| Model object | Variable | Notes |
|---|---|---|
| $i$ | County | $n = 988$ |
| $j \in \{1,2\}$ | 1970, 1980 | $T = 2$ exactly — matches the estimator's minimal case with nothing to spare |
| $Y_{ij}$ | Log county median housing value | CCDB, 1982–84 dollars. Mean rises $\$40{,}300 \to \$53{,}168$ (verified) |
| $X_{ij}$ | County mean TSP concentration, µg/m³ (annual geometric mean) | **Continuous, scalar, endogenous.** Mean decline over the decade 8 µg/m³. Use levels for $\varphi$; the elasticity comparison to Chay–Greenstone needs logs |
| $W_i$ | $\mathbf{1}\{$county designated TSP nonattainment in 1975 (or 1975/76)$\}$ | **Binary, time-invariant.** This is the whole point |
| $Z_{ij}$ | Income per capita, unemployment rate, manufacturing employment, population, population density, urbanisation rate, poverty rate, owner-occupancy rate, share of government spending on education, new home construction, educational attainment | $p \approx 8$–$14$. Differenced 1970→1980. **Note:** Chay & Greenstone enter the *vacancy* variables as separate 1970 and 1980 levels rather than differenced, because the definition changed between censuses (verified, their fn. 21) |
| $\eta_i$ | County effect | Unrestricted and correlated with TSP — this is precisely the omitted-variable problem Chay & Greenstone document, so the differencing is substantively motivated, not a formality |
| $U_{ij}$ | Idiosyncratic | |

**Why the endogeneity is real and documented.** Chay & Greenstone show TSP reductions are strongly correlated with economic shocks: counties with large pollution declines had less income growth, smaller population growth, larger unemployment increases, larger declines in manufacturing employment, and less new home construction (verified, their Table 2 discussion). Their cross-sectional and fixed-effects estimates "occasionally have the perverse sign." A referee will not ask why $X$ is instrumented.

**The binary instrument: exclusion argument.** The 1970 Clean Air Act Amendments impose strict regulatory oversight on polluters in counties whose measured TSP exceeds a federal ceiling. Designation is a **discrete function of the previous year's annual geometric mean and second-highest daily TSP concentration** (verified). The annual standard is 75 µg/m³. 67 counties in the sample are nonattainment despite an annual mean below 75, having been designated on as few as two "bad days" — this is the variation that is not a deterministic function of the annual mean, and it is what makes the instrument more than a re-labelling of $X_1$. The exclusion argument is that designation affects 1970–80 house price growth *only* through the regulatory pressure it puts on local polluters and hence through TSP. Chay & Greenstone support it by showing designation is uncorrelated with virtually all other observable determinants of house price changes, including economic shocks.

**The most damaging objection a referee would raise.** Two, and the first is now published.

1. **The designation is mis-measured, and correcting it breaks the design.** Between 1972 and 1978 the *official* nonattainment designation was made at the **Air Quality Control Region** level, not the county level. Chay & Greenstone impute county-level status ("nonattainment if any of its monitors violated the NAAQS"). Murphy (2016, 2017) identified the discrepancy and worked out its implications for RD designs of exactly this type. Cropper, Muller, Park & Perez-Zetune (2023, *JEEM* 121) quantify it: the average treatment effect on TSP is 10.2 and 9.1 µg/m³ under the *official* AQCR designation (1969 and 1971 balanced monitor panels), against 6.0 and 7.7 µg/m³ under the literature's county-level definition. Their verdict is the uncomfortable part — **under the official designation the parallel-trends assumption is violated; under the imputed county definition parallel trends hold but attainment status is mischaracterised.** For this paper the exposure is direct: $W$ is a *mismeasured binary regressor*, and misclassification in a binary instrument is not innocuous. **This must be addressed in the paper, not discovered by a referee.** It is also, viewed opportunistically, an argument *for* the paper: a mismeasured designation is a weaker instrument, and weak binary instruments are exactly where the linear approach fails and this estimator's machinery earns its keep.

2. **$W$ is a deterministic function of the running variable, which is lagged $X$.** Designation in year $t$ is a cut-off rule applied to TSP in year $t-1$. So $W$ is mechanically correlated with $X_{i1}$ and with anything that predicts $X_{i1}$. Chay & Greenstone handle this by conditioning flexibly on the 1974 selection-year mean. **This creates a data-side compatibility question the strategist must resolve:** the conditioning set for $\Delta U \perp W \mid \Delta Z$ has to contain the *level* of the 1974 running variable, but $\Delta Z$ is by construction a vector of *differences*. Either the conditioning set is allowed to differ from the linear-index regressors, or the running variable enters as a level in $\Delta Z$ and its coefficient is not a difference-in-difference coefficient. I flag this as a data-fit issue; resolving it is not my job.

**5-point critique.**

- **Measurement validity.** $Y$: county *median* housing value, self-reported by owners in the Census. Aggregated, and a median rather than a price index, so composition change over the decade contaminates it — this is a standard hedonic complaint and Bishop et al. (2020) will be the stick a referee uses. $X$: TSP is a county mean over monitors, and only **25% of the total variation in 1970–80 TSP changes is within-county** (verified) — so county aggregation is not throwing away most of the signal, which is a genuine defence and worth quoting. $W$: mismeasured, see above. Additionally EPA's own position is that pre-1980 monitor data carry "uncertainties" because nationally consistent QA procedures only begin in 1980 (verified from EPA). Classical measurement error in $X$ is *not* the usual disaster here because $X$ is instrumented, but non-classical error in $X$ interacts with the nonlinearity of $\varphi$ in a way the paper should acknowledge.
- **Sample selection.** The 988 counties are those with monitors in the right years. Monitors were sited in populous and polluted places: the sample is ~80% of US population but a much smaller share of counties. External validity is to the urban and industrial United States. Attrition between 1970 and 1980 monitor coverage is the main selection mechanism and it is plausibly related to the treatment (regulated counties have more reason to keep monitoring). **Recommend the paper report a monitor-attrition table.** UNVERIFIED: whether Chay & Greenstone report the balanced-vs-unbalanced comparison.
- **External validity.** 1970s United States. The regulatory regime (TSP, later abandoned in favour of PM10 in 1987) no longer exists. Willingness-to-pay estimates are historical. For a *methods* paper in OBES this is close to costless — the application's job is to demonstrate that the estimator runs and that relaxing linearity changes the answer, not to update policy.
- **Identification compatibility.** Excellent on the mechanical constraints: $T = 2$ exactly, $X$ scalar and continuous, $W$ binary, $\Delta Z$ available and multi-dimensional, $n = 988 > 500$. The live issue is the running-variable/conditioning-set tension above. A second issue: $W$ is time-invariant, so it can only instrument the differenced equation, not the levels — which is what the estimator wants anyway.
- **Known issues in the literature.** Murphy (2016, 2017) on designation level. Cropper et al. (2023) on parallel trends under the official designation. Chay & Greenstone themselves rule the 1980s out: "the reduction in TSPs attributable to mid-decade regulations cannot be distinguished from differential responses to the 1981-82 recession... this study focuses solely on the 1970s" (verified, their fn. 25) — so do **not** try to extend to 1980–1990 for extra periods. Bishop et al. (2020) is the referee's checklist for any hedonic design and should be worked through explicitly.

**Access.** Split, and this determines the grade.
- Housing/covariates: **immediate**, ICPSR 00061 and 08256, free at member institutions. This is grade A on its own.
- TSP + designation: **grade B/C**, three routes in descending reliability — (i) request the assembled file from Michael Greenstone, documented to work since he shared attainment-status data with Cropper et al.; (ii) request from Cropper, Muller, Park & Perez-Zetune, who reassembled 1969–78 and 1971–78 balanced monitor panels (their monitor readings came from Karen Clay); (iii) rebuild from **EPA AQS**, which does hold pre-1980 TSP — EPA states the database goes back to 1957 for total suspended particulate in Los Angeles County (verified) — via the AQS API with a free key. Route (iii) is real but slow: the pre-generated AirData files start in 1980 and **do not include TSP at all** (verified), so the API is the only mechanical route, and it is rate-limited (5 parameters per request, single calendar year per request, ~10 requests/minute). **UNVERIFIED and decision-relevant: whether AQS returns usable national TSP coverage for 1969–1980, or only scattered monitors.** Confirmed by a single API call for parameter 11101, one state, one year — do this in week 1; it is a 30-minute test that determines whether the flagship candidate is grade B or grade C.

**Format.** Two-period panel, one row per county per year, or one differenced row per county. Small — under 1 MB.

**Who else used it.** Chay & Greenstone (2003, NBER w10053, infant mortality — search evidence says the dataset is "essentially identical," with covariates from the same 1972 and 1983 County and City Data Books). Cropper, Muller, Park & Perez-Zetune (2023, *JEEM* 121). Murphy (2016, 2017). Singer, "Clean identification? The effects of the Clean Air Act on air pollution, exposure disparities and house prices" (LSE working paper; author list and status UNVERIFIED).

---

### C2 — Modern PM2.5 nonattainment county panel — **GRADE A**

**Provider.** Assembled from four public sources, no permissions anywhere:
- **EPA AQS / AirData** — county-level annual PM2.5 summaries. Pre-generated annual summary files, 1980–present, PM2.5 (FRM/FEM and non-FRM/FEM) explicitly included (verified).
- **EPA Green Book** — nonattainment designations. The 1997 PM2.5 NAAQS original designations were **effective 5 April 2005**, covering 39 metropolitan areas comprising all or part of **208 counties** with a population of 88 million (verified). Green Book provides data exports and GIS shapefiles for download (verified).
- **FHFA House Price Index** — annual county-level all-transactions index, published as a *developmental* series and also carried on FRED as `ATNHPIUS{FIPS}A` (verified). Not reported where county sample sizes are small.
- **ACS / BEA / BLS** — county covariates.

**Mapping onto the model.**

| Model object | Variable |
|---|---|
| $i$ | County with a PM2.5 FRM monitor |
| $j \in \{1,2\}$ | Pre-designation year (e.g. 2003) and post year (e.g. 2008); or a longer annual panel differenced to two endpoints |
| $Y_{ij}$ | Log FHFA county annual house price index (or log ACS median owner-occupied home value) |
| $X_{ij}$ | County annual mean PM2.5, µg/m³ — **continuous, scalar, endogenous** |
| $W_i$ | $\mathbf{1}\{$county designated nonattainment for the 1997 PM2.5 NAAQS, effective 5 April 2005$\}$ — **binary** |
| $Z_{ij}$ | Per-capita income, unemployment rate, population, manufacturing employment share, housing units |
| $\eta_i$ | County effect |

**The binary instrument: exclusion argument, and why it is weaker than C1's.** Same logic as C1 — designation triggers state implementation plan obligations and permitting restrictions on local sources, which lower PM2.5, which capitalises into house prices. But the modern designation process is *not* a mechanical cut-off on a monitor reading. States submit recommendations, EPA negotiates area boundaries, and areas are drawn at the metropolitan rather than county level, so counties with no violating monitor are swept in on the basis of contribution to a neighbouring area's problem. **The most damaging objection: designation status is partly the outcome of a negotiation between a state and EPA, and states with strong housing markets or particular political characteristics may negotiate differently.** That is a direct violation of $\Delta U \perp W \mid \Delta Z$ and it has no clean fix. C1's 1970s rule is more mechanical, and therefore more defensible, than C2's.

**5-point critique.**
- **Measurement validity.** Much better than C1 on $X$: post-1990 AQS data are the QA-standardised series EPA itself uses for trends. $Y$ is a repeat-sales-style index rather than a self-reported median, which is a real improvement over C1 and is what Bishop et al. (2020) ask for. $W$ is exactly measured — no AQCR problem. So C2 wins on measurement and loses on exogeneity.
- **Sample selection.** Only counties with FRM PM2.5 monitors, and FHFA suppresses small-county indices. The two selection rules compound. **UNVERIFIED and decision-relevant: the number of counties with both a continuous PM2.5 monitor series and a non-missing FHFA county index across the window. My estimate is 500–700, which is at the very bottom of the simulation grid.** Confirmed by intersecting one AQS annual summary file with one FHFA county file — a 20-minute check. If it comes in under 500 this candidate drops a grade.
- **External validity.** Contemporary US; more relevant to current policy than C1, which is C2's one genuine advantage for a non-methods audience.
- **Identification compatibility.** All five constraints met, with $n$ the open question. A bonus over C1: many periods are available, so $T > 2$ robustness is possible — the paper can show the estimator is not an artefact of the two-period case.
- **Known issues.** The designation-endogeneity literature on modern nonattainment is large and a referee will know it. Also: PM2.5 fell nearly everywhere over the 2000s for reasons unrelated to designation (fleet turnover, coal retirement), which compresses the first stage.

**Access.** Everything public, no registration except a free AQS API key. **Assembly time is the cost, not permission: 2–3 weeks of careful work,** most of it in reconciling monitor-to-county aggregation rules and the Green Book's partial-county designations.

---

### C3 — SEC Regulation SHO short-sale pilot — **GRADE B/C**

Included because it has, by a distance, **the best binary instrument of any candidate here**, and because if a referee destroys the nonattainment instrument this is the escape route.

**Provider.** SEC (pilot list), CRSP and Compustat via WRDS (prices, fundamentals), exchange short-interest files.

**Coverage.** In July 2004 the SEC suspended short-sale price tests for **one-third of the Russell 3000 firms** trading on NYSE, AMEX or Nasdaq NM — roughly 1,000 "pilot" stocks — from **2 May 2005** until the price tests were eliminated for all stocks in July 2007 (verified). Russell 3000 gives $n \approx 2{,}800$–3,000 after the usual filters.

**Mapping onto the model.**

| Model object | Variable |
|---|---|
| $i$ | Firm / listed stock |
| $j \in \{1,2\}$ | Pre-pilot window and pilot window |
| $Y_{ij}$ | Firm-level market-quality outcome — log realised volatility, a price-efficiency measure, or effective spread |
| $X_{ij}$ | Short interest ratio (shares sold short / shares outstanding) — **continuous, scalar, endogenous** |
| $W_i$ | $\mathbf{1}\{$pilot stock$\}$ — **binary** |
| $Z_{ij}$ | Log market capitalisation, log turnover, log price, book-to-market |
| $\eta_i$ | Firm effect |

**The binary instrument: exclusion argument.** Assignment was made by the regulator by a mechanical rule applied to the Russell 3000 list, not by firm choice and not by any firm characteristic that could plausibly enter $U$. This is as close to an experiment as the observational world gets, and unlike C1 and C4 the exogeneity is *global*, not local to a cut-off — which matters, because $\Delta U \perp W \mid \Delta Z$ is a global restriction. **PARTIALLY VERIFIED:** that one-third of the Russell 3000 was selected is verified; the commonly cited "every third stock after sorting by exchange and then average daily volume" rule I did **not** confirm this session and it must be checked against the SEC release before it is described in the paper.

**The most damaging objection a referee would raise.** The exclusion restriction is that the pilot moves outcomes only through the *quantity* of short selling. It plainly does not: removing a price test changes the *mechanics* of order placement and execution — tick-by-tick order routing, quoted spreads, the timing at which a short order can be posted — and those affect volatility and price efficiency directly, without passing through short interest at all. This is a first-order exclusion violation and I would not expect a finance referee to let it go. It is also, note, a violation that *no* amount of econometric machinery repairs.

**5-point critique.**
- **Measurement validity.** Strong. Short interest is reported to exchanges and is not self-reported. Outcomes are computed from trade and quote data.
- **Sample selection.** Russell 3000 membership is a size cut-off; results generalise to listed US equities above a market-cap floor.
- **External validity.** Narrow — a two-year regulatory experiment in one market. For OBES this is a genuine handicap: the readership is applied economists, not market microstructure specialists.
- **Identification compatibility.** All five constraints met, with the largest $n$ of any candidate. The one wrinkle: short interest is reported semi-monthly, so the natural panel is much longer than $T=2$ and the paper would be choosing to collapse it.
- **Known issues.** A large literature disputes the pilot's effects and, importantly, the *sensitivity of the findings to specification choice* — this is the explicit subject of recent work in *Management Science* on the SEC's short-sale experiment. A referee will ask why your specification is the right one.

**Access.** CRSP/Compustat require a **WRDS subscription**. Most economics departments have one, which is why this is B/C rather than D — but it is not public, it is not reproducible by a reader without a subscription, and an OBES replication package cannot ship the raw data. That last point is the real cost.

---

### C4 — Greenstone & Gallagher (2008), Superfund NPL — **GRADE C**

The user asked that this be assessed seriously as the primary candidate. I did, and my verdict is that **it is not the primary candidate, for a specific and I think decisive reason.**

**The problem is constraint 2, not constraint 3.** Greenstone & Gallagher's design has an excellent binary treatment — NPL listing, assigned by whether a site's 1982 Hazard Ranking System score cleared **28.5** — and their data cover all sites placed on the NPL by 2000 plus sites with 1982 HRS scores below 28.5, with tract-level housing prices, housing characteristics and demographics (verified). But **the published design has no continuous, scalar, time-varying endogenous regressor.** The treatment is the binary listing itself. The one continuous variable in the design, the 1982 HRS score, is the *running variable*, is measured once, and therefore **differences out of the model entirely.** As published, this candidate cannot be mapped, and by the rule given to me it would be dropped.

It can be mapped only by *constructing* an $X$ that does not exist in their data — for example a distance-weighted measure of uncleaned contamination in a tract's neighbourhood, built from EPA SEMS/CERCLIS site records and GIS, which changes between 1980 and 2000 as sites are remediated. That is a different paper's worth of data work, and every detail of it is UNVERIFIED.

**Mapping, if the constructed $X$ route is taken.**

| Model object | Variable |
|---|---|
| $i$ | Census tract |
| $j \in \{1,2\}$ | 1980, 2000 |
| $Y_{ij}$ | Log tract median housing value (Census/NHGIS) |
| $X_{ij}$ | **TO BE CONSTRUCTED** — distance-weighted uncleaned-site exposure. Does not exist off the shelf |
| $W_i$ | $\mathbf{1}\{$1982 HRS score $\ge 28.5\}$ — **binary** |
| $Z_{ij}$ | Tract demographics and housing characteristics |

**The most damaging objection.** Beyond the constructed-$X$ problem: the HRS instrument's exogeneity is **local to the 28.5 cut-off**. That is exactly the right property for an RD and exactly the wrong property for this estimator, which needs $\Delta U \perp W \mid \Delta Z$ to hold over the support of $\Delta Z$, not in a neighbourhood of a threshold. Restricting to a window around 28.5 to buy exogeneity would cut $n$ below the point where the asymptotics are credible. **This tension — local exogeneity versus a global conditional-independence restriction — is the general reason threshold-based instruments are awkward for this estimator, and it applies to C1 and C2 as well, just less severely because their samples are not concentrated at the cut-off.**

**5-point critique (abbreviated, given the mapping failure).** *Measurement:* tract median values from the decennial Census, same composition problem as C1. *Selection:* tracts within 3 miles of a hazardous site — a specific and unusual population. *External validity:* narrow. *Identification compatibility:* fails constraint 2 as published. *Known issues:* Greenstone & Gallagher find **little or no effect** on tract median housing values within three miles (verified) — a null result. Building a methods paper's showcase application on a setting whose established finding is a precisely estimated zero is a poor choice: the demonstration "relaxing linearity changes the picture" has much less force when the linear picture is a null.

**Access.** NPL/HRS site records public via EPA. Tract housing data public via IPUMS NHGIS (free, registration). Greenstone & Gallagher's assembled file: **UNVERIFIED** whether a public replication deposit exists.

**Recommendation.** Keep as background and cite `greenstonegallagher2008` for the hedonic-and-binary-designation *setting*. Do not build the application on it.

---

### C5 — CAA/TSP nonattainment → infant mortality — **GRADE B**

**Not an independent candidate.** Same $W$, same $X$, same $Z$, same counties, same two periods as C1; only $Y$ changes, to the county infant mortality rate per 1,000 live births from NCHS Vital Statistics natality and mortality files. Search evidence indicates Chay & Greenstone's own infant-mortality work uses a dataset "essentially identical" to the 2005 housing dataset with covariates from the same 1972 and 1983 County and City Data Books.

**Value.** Once C1 is assembled the marginal cost is one outcome variable. It buys two things: a second application at near-zero cost, and an answer to the referee who objects to hedonic interpretation, since a dose-response function for pollution and infant mortality has an obvious reason to be nonlinear and no Rosen-model baggage. A $U$-shaped or convex $\hat\varphi$ is more interpretable here than in the price equation.

**Risks.** $n$ falls — small counties have too few births for a stable rate, so expect a smaller and more urban sample than 988. **UNVERIFIED: county-level identifiers in the NCHS public-use natality/mortality files for 1970 and 1980, and the minimum-births suppression rule that applies.** Confirmed by reading the NCHS public-use file documentation for those years. If county identifiers turn out to be restricted for that vintage, this becomes grade C with an NCHS/NAPHSIS application.

---

## 3. Rejection table

Candidates considered and dropped. "Deal-breaker" means the constraint failure is structural and cannot be engineered around.

| Candidate | Why it was considered | Reason dropped | Constraint | Deal-breaker? |
|---|---|---|---|---|
| Oregon Health Insurance Experiment | Textbook randomised **binary** lottery instrument; panel; large $n$ | **REASON CORRECTED 2026-08-08 against the public use files** — see `quality_reports/decisions/ohie-rejected-2026-08-08.md`. The row previously read "$X$ = insurance coverage is binary", which is true of coverage but is not the only candidate: total ED charges *are* continuous (6,675 / 7,537 distinct values) and *are* measured both pre- and post-lottery. It fails for two other reasons. (i) 65.7–69.0% of charges are exactly zero; only 4,589 of 24,621 (18.6%) are positive in both periods and 53.4% are zero in both, so A0's absolute continuity fails. (ii) Controlling for household size, the lottery moves the *count* of visits ($\Delta$ visits ITT $+0.099$, $t=3.67$) but **not** charges ($\Delta$ charges ITT $+289$, $t=1.44$, $F\approx2.1$). The continuous variable has no first stage; the variable with a first stage is a censored count | 2 | **Yes** |
| Medicaid expansion / ACA designs | Binary policy instruments, state panels | Same — the endogenous regressor is coverage, binary | 2 | **Yes** |
| Card college-proximity (NLSYM) | Genuinely **binary** instrument, canonical | $X$ = years of schooling, discrete; and no panel with time-varying adult schooling, so nothing to difference | 1, 2 | **Yes** |
| Angrist & Evans same-sex sibling composition | **Binary** and quasi-random — one of the cleanest binary instruments in economics | $X$ = number of children, a count | 2 | **Yes** |
| Angrist & Krueger quarter of birth | Can be collapsed to binary | $X$ = schooling, discrete; repeated cross-section, not a panel | 1, 2 | **Yes** |
| Vietnam draft lottery | Randomised **binary** eligibility | $X$ = veteran status, binary | 2 | **Yes** |
| Maimonides-rule class size | Famous threshold design | Instrument is multi-valued (a sawtooth in enrolment), and $X$ = class size is integer-valued | 2, 3 | **Yes** |
| **NLSY / PSID / HRS / Add Health as a family** | Long panels, many periods, public or lightly restricted, exactly the data OBES readers use | No natural binary instrument for a *continuous scalar* endogenous regressor anywhere in the family. Where these panels have binary instruments the regressor is discrete. **This is the finding, not an oversight: the binary requirement rules out the entire survey-panel family** | 2, 3 | **Yes** |
| Judge / examiner / caseworker leniency | Ubiquitous, strong, credible | Leniency is **continuous by construction**. Binarising it is the researcher's choice, which directly undercuts the paper's motivation — the contribution is that binariness is *forced* by the setting. A referee would ask why information was discarded | 3 | No, but self-defeating |
| Rainfall / temperature / wind instruments | Common, exogenous, panel-friendly | Continuous instruments. Same objection as leniency | 3 | No, but self-defeating |
| Progresa / Oportunidades | Randomised **binary** village treatment, genuine panel, public data, continuous candidate $X$ (household income or consumption), large $n$ — mechanically this maps | Transfers are **conditional** on school attendance and clinic visits. The exclusion restriction "village treatment affects child outcomes only through household income" is violated by the programme's own design, for precisely the outcomes one would want to study | 3 | **Yes** for the natural outcomes |
| Moving to Opportunity | **The best randomised binary instrument with a genuinely continuous $X$** (tract poverty rate), true panel with baseline and follow-ups. On instrument quality alone it would rank second | Three arms, so $W$ is binary only after discarding the Section 8 arm; geography is **restricted-access** (HUD/ICPSR application, realistically months); and the exclusion restriction is contested — moving changes schools, networks and disruption, not only tract poverty. **Feasibility fails the OBES bar** | 3, access | No, but access-blocked |
| EU ETS 20 MW capacity threshold | **Binary** by regulation, firm panel, continuous $X$ (emissions or energy intensity) | Firm financials need Orbis/Amadeus (subscription); and there is documented behaviour at the capacity threshold, which is exactly the manipulation that invalidates a threshold instrument | 3, access | No, grade C/D |
| Zillow ZTRAX parcel hedonics | The natural modern hedonic $Y$; 20+ years, 2,750+ counties | Not a design — it is an outcome source with no instrument of its own. Also **no longer freely distributed**: Zillow discontinued ZTRAX in October 2023 and it is now hosted exclusively by ICPSR under an access application | n/a | n/a — but note the access change |
| Chay & Greenstone extended to 1980–1990 | Would give $T = 3$ and more variation | The authors rule it out themselves: the 1981–82 recession's differential effects cannot be separated from mid-decade regulation, and the TSP regulatory programme terminated in 1987 | 3 | **Yes** for that window |
| Clean Water Act §303(d) impaired-waters listing | Structurally identical to nonattainment: **binary** listing from a continuous water-quality criterion; EPA ATTAINS and the Water Quality Portal are public | Not pursued to verification this session. Plausible but the listing process is highly discretionary at state level, and the water-quality $X$ is multi-dimensional (dissolved oxygen, nutrients, bacteria) rather than a natural scalar | 2, 3 | Unresolved — worth a look only if C1 and C2 both fail |

---

## 4. Recommendation, stated plainly

**Build C1.** It is the only candidate that instantiates the model exactly as written, with no constructed variables, at $n = 988$, with a binary instrument that is binary because a regulator drew a line and not because anyone chose to discretise. The setting is already in the project bibliography and the positioning memo, the comparison estimate exists (elasticity $-0.20$ to $-0.35$), and the referee objection about linearity is one the original authors effectively invite by imposing it.

**Start the TSP data request in week 1, in parallel, on all three routes.** This is the only real schedule risk in the project. Email Greenstone, email Cropper/Muller/Park, and run the 30-minute AQS API test for parameter 11101. Do not sequence these.

**Assemble C2 in parallel as insurance and as a robustness exhibit.** It is fully public, it needs no permission, and it lets the paper show the estimator running on data a reader can download. But say honestly in the paper that C2's designation is less mechanical than C1's — do not dress the fallback up as an improvement.

**Pre-empt the AQCR misclassification objection in the paper itself.** Murphy (2016, 2017) and Cropper et al. (2023) are in print. A hedonic referee — and the positioning memo already anticipates a Greenstone/Kuminoff/Banzhaf/Timmins-circle referee — will raise it. Better to raise it first and argue that a mismeasured binary designation is a *weaker* instrument, which strengthens rather than weakens the case for an estimator built for exactly this situation.

**Two counts to run before committing.** (i) AQS coverage for TSP 1969–1980 nationally; (ii) the C2 county count after intersecting PM2.5 monitor coverage with the FHFA index. Both are under an hour of work and both can change a grade.

---

## 5. Verification status

**Verified first-hand this session** (from the Chay & Greenstone working paper text, EPA pages, ICPSR listings, or NBER abstracts): the 988-county primary sample and its selection rule; the 475- and 419-county sub-samples; the 67 bad-day counties; ~80% of US population; the 75 µg/m³ annual standard; designation as a discrete function of the previous year's annual geometric mean and second-highest daily reading; 1972 designation set by 1971 concentrations; the FOIA provenance of the TSP data; the CCDB provenance of housing values; the $-0.20$ to $-0.35$ elasticity; the ~10 µg/m³ and ~2.5% reduced forms; the 25% within-county TSP variation share; the vacancy-variable exception; the authors' own exclusion of the 1980s; ICPSR 00061 and 08256; AirData files starting 1980 and excluding TSP; pre-1980 TSP existing in AQS back to 1957; EPA's own quality caveat on pre-1980 data; AQS API key and rate limits; Green Book PM2.5 (1997) designations effective 5 April 2005 covering 208 counties / 39 areas / 88 million; Green Book shapefile and export downloads; FHFA developmental county annual index and its FRED series; Cropper et al.'s AQCR-versus-county finding and the four treatment-effect magnitudes; the parallel-trends verdict; Murphy (2016, 2017) as the origin of the objection; Greenstone having shared attainment data with Cropper et al.; Greenstone & Gallagher's 28.5 HRS cut-off, sample composition and null result; Reg SHO covering one-third of the Russell 3000 from 2 May 2005; ZTRAX discontinuation and migration to ICPSR.

**Explicitly UNVERIFIED, flagged in place, each with a stated confirmation step:** the nonattainment/attainment split within the 988 (the bibliography's "689/300" was not confirmed — I saw 265/149 only in the 414-county figure sub-sample); the numeric 24-hour TSP standard; national AQS coverage for TSP 1969–1980; whether Cropper et al. or Greenstone & Gallagher have public replication deposits; the C2 county count; NCHS county identifiers and suppression rules for 1970/1980; the exact Reg SHO selection rule; the Superfund tract count; all Superfund constructed-$X$ details; the Singer LSE paper's authorship and status; exact ICPSR variable codes for the CCDB files (see `data_dictionary.md` — I have deliberately not invented these).

No dataset, variable name, or coverage figure in this document was written from recall without one of the two labels above.
