# Data Assessment Review — explorer-critic

**Date:** 2026-07-31
**Target:** `quality_reports/data-assessment/panel-npiv-discrete/` (`data_sources.md`, `data_dictionary.md`, `access_instructions.md`)
**Score: 35/100** — below the 80 commit gate. Re-dispatch required.

> **Persistence note.** The explorer-critic has no Write tool by design (`agents.md` §2: critics never create). This file is the orchestrator's transcription of its report. Sections marked **[ORCHESTRATOR VERIFICATION]** are checks the orchestrator ran against the data itself after the critic reported; one of them **corrects the critic**. Everything else is the critic's, condensed but not softened.

---

## Summary

A well-made document that cannot be acted on as written. The verification discipline is genuine, the rejection table is useful, the C4 rejection is correct, and the refusal to dress the modern PM2.5 panel up as an upgrade is exactly right. But the two headline operational instructions — *"budget 4–8 weeks and email three researchers"* and *"argue that a mismeasured designation is a weaker instrument"* — are both wrong, and three checks that determine whether this data can carry this estimator were never run.

The root cause of the largest defect is mundane: **the assessment never opened the project's own `data/` directory.**

---

## C-1 (CRITICAL, −18) — the flagship candidate's data is already in the project

`data/raw/data_tsp.txt` exists on disk and is the assembled Chay–Greenstone panel. It is gitignored (`.gitignore:66`), which is why it does not surface in `git status` — not because it is absent. `quality_reports/plans/2026-07-28_panel-npiv-direct-theta.md:808` records this as open question Q1, **RESOLVED**, three days before the assessment was written.

**[ORCHESTRATOR VERIFICATION — confirmed exactly.]**

```
rows (excl. header) : 989
columns             : 30
CATT split          : 689 zeros / 300 ones
header              : StateCode CountyCode LogPropValue DiffTSP MTSP1970 MTSP1980
                      CATT Population PCIncome PopDens UnempRate EmpManufacturing
                      HighSchool College Urban Poverty White Female Senior
                      VacancyRate OwnerOccRate UnitsWOPlumbing PCGovRev PCPropTax
                      PCGenExpLocalGov ExpEduc ExpHighways ExpWelf ExpHosp ExpPol
```

The model maps directly onto it: ΔY = `LogPropValue`, ΔX = `DiffTSP`, X levels = `MTSP1970`/`MTSP1980`, binary instrument = `CATT`, plus 25 differenced covariates.

Consequences, all from the single omission:

- **`access_instructions.md` is void for the recommended candidate.** Its Task 1 — three parallel data-request routes, 1–8 weeks, *"the only real schedule risk"* — addresses a problem that does not exist. The instruction to email named researchers should not be issued.
- **C1's feasibility grade is B; the realistic grade is A.** Feasibility is the second ranking criterion, so the ranking table is corrupted.
- **n is asserted as 988** and labelled *verified from the paper*. The project's analysis file has **989**.
- **`tsp_1974` is absent from the file.** The assessment declares this variable necessary — *"W ⊥̸ ΔU without conditioning on it"* — and builds a flagged data-fit issue around it. That the conditioning variable it calls essential is missing from the data in hand is the most useful thing the assessment could have reported, and it is not reported.
- **The control list in `data_dictionary.md` §C1.6 omits 11 of the file's columns.** Actual candidate p ≈ 25, not the stated "8–14".
- The prescription that vacancy enter as two separate levels conflicts with the file, which carries one differenced `VacancyRate`.
- Every `CODEBOOK` marker is moot. The named-column analysis file exists.

### Missingness — **[ORCHESTRATOR VERIFICATION, AND THIS ONE CORRECTS THE CRITIC]**

The critic reported *"Eight fiscal columns carry NaNs... Every one of the 989 rows contains at least one NaN. Naive listwise deletion on the control set collapses the sample."* The first two clauses are true; **the implication is not, and the real structure is benign and interpretable.**

| Column | NaNs |
|---|---|
| `ExpPol` | **989 of 989 — the column is entirely empty** |
| `PCGovRev`, `PCPropTax`, `PCGenExpLocalGov`, `ExpEduc`, `ExpHighways`, `ExpWelf`, `ExpHosp` | 6 each |

"Every row has a NaN" is true **only because `ExpPol` is dead**. Drop that one unusable column and complete cases go from 0 to **983**.

The remaining 6 are the *same* 6 counties missing all seven fiscal variables as a block — not scattered item non-response:

```
state=36 county=5, 47, 81      (NYC boroughs — Bronx, Kings, Queens)
state=51 county=515, 595, 775  (Virginia independent cities — Bedford, Emporia, Salem)
```

Both groups are the known County–City Data Book pattern: NYC boroughs and Virginia independent cities are not fiscally independent counties and do not report county-level finance. **This is structural, documentable missingness costing 0.6% of the sample, not a threat to it.** The correct action is: drop `ExpPol`, and either drop or separately flag the 6 counties. The critic's severity claim should not be carried forward.

---

## C-2 (CRITICAL, −13) — the mismeasured instrument: "invalid" is being sold as "weak"

**The explorer's proposed framing is wrong and must not stand.**

Mismeasurement of an *instrument* is not analogous to mismeasurement of a regressor. Let $W^\ast$ be the official AQCR designation and $\widetilde W$ the imputed county designation. A1 — $\Delta U \perp W \mid \Delta Z$ — restricts whatever $W$ the estimator actually uses. A noisy proxy for a valid instrument stays valid, and is merely less relevant, **if and only if the classification error is conditionally independent of $\Delta U$ given $\Delta Z$** (non-differential misclassification). Conditional exogeneity given $\widetilde W$ is **not implied** by conditional exogeneity given $W^\ast$; it is a separate assumption. The assessment never states the condition — it goes straight to "weaker instrument."

**The cited evidence bears on exactly the skipped condition, and points the wrong way.** Cropper et al. (2023, *JEEM* 121) report TSP effects of 10.2/9.1 µg/m³ under official designation against 6.0/7.7 under the county definition, **with parallel trends failing under the official designation**. A gap that size means the classification error is systematically related to the differential trend, i.e. to $\Delta U$. That is the *differential*-misclassification branch, under which A1 for $\widetilde W$ fails and the estimator is **inconsistent, not imprecise**.

Two further points the assessment misses:

1. **Parallel trends is a testable implication of A1, not a nuance.** A1 together with $E[\Delta U \mid \Delta Z]=0$ gives $E[\Delta U \mid W, \Delta Z]=0$ — conditional parallel trends. So "parallel trends fails under the official designation" is a *published refutation of a direct consequence of the paper's maintained assumption*, for the designation that is the actual policy. The version that passes is the one that is not the policy.
2. **A1 is conditional independence, not conditional mean independence.** The assessment's exclusion argument rests on designation being *"uncorrelated with virtually all other observable determinants of house price changes."* Uncorrelatedness is not independence and covariate balance is neither. The paper maintains the strong form deliberately and exploits the full conditional restriction through the Bierens device. The assessment defends a weaker assumption than the paper carries, without noticing.

The opportunistic argument is self-defeating on its own terms: *"weak binary instruments are exactly where the linear approach fails and this estimator earns its keep"* — but **nothing in this theory is weak-identification-robust.** The variance formula, A4(i) overlap and the $\sqrt n$ limit all degrade as the instrument weakens. Weakness is a cost this paper pays, not a feature it advertises.

**Verdict: (b) — a robustness exercise the paper must run, plus a mandatory reframing.** Not (a): the proposed pre-emption is a claim that may be false and is precisely what is in dispute. Not (c): the data are in hand and both alternatives have worse exogeneity by the assessment's own reckoning. The paper must (i) state A1 for the *observed* $W$, (ii) state the non-differential-misclassification condition under which the "weaker not invalid" reading holds, (iii) run `w_aqcr_official` as a **primary robustness column, not a footnote**, and (iv) delete the claim that mismeasurement argues *for* the paper.

`data_dictionary.md` §C1.5's operational recommendation — **build `w_aqcr_official`** — is right. Only the framing around it is wrong.

---

## M-1 (MAJOR, −10) — the propensity nuisance, $d_Z$, and overlap are never checked

`data_dictionary.md:100` states p ≈ 8–14 is *"comfortably in the regime ... exactly the situation the Bierens device in the theory exists to handle."* **The theory says close to the opposite.**

The Bierens device removes the need to estimate a conditional distribution given $\Delta Z$ *in the restriction*. It does not remove **A4** (`assumptions.tex:1381`), which introduces $\varrho(\Delta Z)=P(W=1\mid\Delta Z)$ as a third nuisance estimated nonparametrically at $n^{-r/(2r+d_Z)}$, with $1\le d_Z\le p-1$. The theory prints its own feasibility frontier (`assumptions.tex:1894–1913`):

| μ | $d_Z=3$ | $d_Z=4$ | $d_Z=5$ |
|---|---|---|---|
| 1 | $r>4.5$ | $r>6$ | $r>7.5$ |

with the comment *"A binary propensity that is 7.5 times differentiable in five dimensions is not a condition a referee will grant."* **The table stops at $d_Z=5$. The assessment proposes p ≈ 8–14; the file offers 25.**

$\varrho(\Delta Z)$ is never mapped — it is a model object with a maintained assumption attached and it is absent from every mapping table. Nor is **A4(i) overlap** checked, and overlap is where the assessment's own `tsp_1974` flag actually bites:

- **If `tsp_1974` enters the conditioning set**, $W$ is a near-deterministic step function of it, so $\varrho(\Delta Z)\in\{0,1\}$ over most of the support and **overlap fails**. The only residual randomness is the daily criterion, which the assessment itself says yields just 67 counties.
- **If it does not enter**, A1 is threatened.

That fork decides whether this dataset can support this estimator. The assessment hands it to the strategist as a formatting question. It is not one.

---

## M-2 (MAJOR, −8) — n-adequacy never tested against the paper's own Monte Carlo

The project has already answered this and the answer is no. `quality_reports/sim/sim_thm_rootn_summary.md:167` — **"Matches at large n only."** At $c_\delta=0.25$ the sd ratio fails a 2-SE bar at every $n\le64{,}000$, clearing only at $n=181{,}019$; at $c_\delta=1$, *equally on-hypothesis*, nothing matches anywhere on the grid. Line 171: *"the theorem is right and `cor:ratefloor`, not `thm:rootn`, is what describes any feasible sample."*

At the grid point nearest the application ($n=1{,}000$, $c_\delta=1$): **sd ratio 36.71 MC-SE from nominal; 95% coverage −4.81 SE**, −6.34 SE with deterministic bias.

The assessment writes *"n = 988 > 500"* and calls identification compatibility *"Excellent on the mechanical constraints."* It also invokes "the simulation grid" as an authority while mischaracterising it: the actual grid (`sim_thm_rootn_limitlaw.R:45`) is `125, 354, 1000, 2828, 8000, 22627, 64000, 181019` — floor 125, not 500.

The decision-relevant finding, absent: **$n=989$ sits near the bottom of a grid on which this estimator's own Monte Carlo shows the $\sqrt n$ normal approximation does not hold. The application's standard errors will under-cover.**

Related: $T=2$ is correctly called the minimum "with nothing to spare," but the consequence is not drawn — at $T=2$ there is **no within-panel pre-trend test, no internal check of A1, and no $T>2$ robustness**, which is pointed given that pre-trends are the disputed object.

---

## M-3 (MAJOR, −6) — A0 assumes i.i.d.; assignment is AQCR-clustered and the data is spatially dependent

A0 (`assumptions.tex:56`) requires i.i.d. draws indexed by $i$. There is **no clustering or spatial-dependence provision anywhere in `assumptions.tex`** (zero matches). Designation is assigned at AQCR level, so treatment is constant within AQCR clusters, and even the imputed county indicator is a coarsening of cluster-assigned treatment. County air quality and county house-price growth are both strongly spatially correlated. Under A0 and the derived $\Sigma$, **reported standard errors will be too small — the Moulton problem, on top of the under-coverage in M-2.** A genuine data/theory incompatibility, absent from the assessment.

---

## M-4 (MAJOR, −7) — the survey-panel elimination rests on a claim the document itself refutes

The load-bearing claim: *"in the settings where applied economists have a genuinely binary instrument ... the endogenous regressor is **also** binary or discrete"*, hardened in the rejection table to *"**This is the finding, not an oversight.**"*

**Refuted twice, both times from inside the document:**

1. *By its own taxonomy.* Family (A) is "a continuous quantity regulated by a threshold rule." Nothing in that is specific to environmental regulation. Statutory eligibility notches keyed to birth cohort, age or date — benefit-formula notches, pension-reform cut-offs, age-65 program eligibility — are family (A) instances living natively in household panels, shifting continuous scalar regressors (benefit income, pension wealth, out-of-pocket spending). Named to refute the universal, not to recommend.
2. *By its own rejection table.* Two rows down: Moving to Opportunity is *"**the best randomised binary instrument with a genuinely continuous X** (tract poverty rate), true panel with baseline and follow-ups."* That is a binary instrument with continuous scalar X in a survey panel, conceded on the page, then rejected on **access** — a different and legitimate ground that nonetheless destroys the structural claim.

The defensible statement is weaker and still useful: *binary-instrument / continuous-scalar-X pairs are uncommon and most canonical binary instruments do fail constraint 2.* Stated as a structural law it converts an incomplete search into a false theorem, and it is the one claim licensing not looking further.

**The Greenstone & Gallagher rejection is correct**, and for the right reason: the 1982 HRS score is measured once, so $\varphi(X_2)-\varphi(X_1)=0$ and X vanishes from the differenced equation; the only time-varying candidate is the binary listing, which fails constraint 2 the other way. Both routes reject. The supporting observation that its established finding is a precisely estimated null — poor ground for "relaxing linearity changes the picture" — is good and should be kept.

---

## m-1 (MINOR, −3) — two internal inconsistencies in the ranking

- C3's instrument is ranked **"best of any candidate"** on a mechanical selection rule the same section flags as **UNVERIFIED** while saying "the paper's exogeneity argument rests on it."
- Ranking criteria are "binary instrument first, then feasibility." **n-adequacy is not a criterion** — yet given M-2 it is arguably binding, and C3's n ≈ 2,800 is the only candidate within an order of magnitude of where the limit theory starts to bite.

---

## Load-bearing check on the UNVERIFIED items

| Item | Load-bearing? | Finding |
|---|---|---|
| **689/300 split** | **Yes — and the flag is a false alarm** | Verified from `data/raw/data_tsp.txt`: 300 of 989 have `CATT=1`. `assumptions.tex:2579` **already calibrates A4 on it** ("at ϱ ≈ 0.303 the factor ϱ(1−ϱ) ≈ 0.211 costs ≈18% in variance"). The instruction "do not carry 689/300 forward unchecked" would cast doubt on a number the theory depends on, when the check takes a minute against data already in the project. |
| **Reg SHO selection rule** | **Yes, for C3** | Correctly flagged — but C3 is simultaneously ranked best-in-set on it (m-1). |
| **C2 county count** | Yes, for C2 | Correctly flagged, priced, and given a decision rule. Good work. |
| **24-hour TSP threshold** | Marginal | The "67 bad-day counties" figure carries the argument and is verified. Low stakes, handled well. |
| **NCHS county identifiers 1970/1980** | Yes, for C5 only | C5 is explicitly secondary. Correctly priced. |
| **CCDB variable codes** | **Moot** | The named-column analysis file is on disk. |

---

## Claims asserted beyond what the cited source supports

1. *"a mismeasured designation is a weaker instrument."* Cropper et al. document a **validity** failure; they support neither "weaker" nor "stronger." (C-2)
2. *"p ≈ 8–14 ... exactly the situation the Bierens device exists to handle."* The theory says the opposite about the propensity nuisance: `assumptions.tex:1913`, *"BUY μ, NOT r."* (M-1)
3. *"~500–700, at the very bottom of the simulation grid."* The grid floor is 125.
4. *"n = 988"*, labelled verified. The file has 989 rows.
5. *"Chay & Greenstone enter the vacancy variables as separate 1970 and 1980 levels ... Replicate this or explain the departure."* The file carries one differenced `VacancyRate`; the conflict is unnoted.
6. *"TSP data obtained under FOIA are public records and may be redistributed, so the assembled panel can ship with the OBES replication package."* **A legal conclusion asserted flatly, with no support and no verification label.** FOIA compels disclosure to the requester; it does not by itself settle downstream redistribution. Load-bearing for the C1-vs-C3 comparison.

---

## Model mapping

- **C1** — correct in kind, wrong in detail, incomplete in objects. Y, X, W, ΔZ, η, U map correctly and the table is the clearest thing in the document. But p ≈ 25 not 8–14; the control list omits 11 columns; `tsp_1974` is absent from the data; `ExpPol` is dead; and $\varrho(\Delta Z)$, $d_Z$, A4(i) overlap and A0's i.i.d. requirement are not mapped at all. **Those four decide feasibility.**
- **C2** — mapping sound, grading honest. Stating that negotiated designation boundaries directly violate $\Delta U \perp W \mid \Delta Z$ is the right call, correctly reasoned. Credit.
- **C3** — mapping sound; the exclusion critique is excellent. *"Removing a price test changes the mechanics of order placement ... without passing through short interest at all — a violation that no amount of econometric machinery repairs"* is the sharpest sentence in the assessment.
- **C4** — correctly declared a mapping failure.
- **C5** — mapping correct, risk correctly identified.

---

## Score

| | Deduction |
|---|---|
| Starting | 100 |
| **C-1** project's own data never checked; access artifact void; dictionary at odds with the file | −18 |
| **C-2** weak-vs-invalid conflation; recommends a defence that may be false | −13 |
| **M-1** ϱ(ΔZ), overlap and $d_Z$ never checked; mis-statement about the Bierens device | −10 |
| **M-2** n-adequacy never tested against the paper's own Monte Carlo | −8 |
| **M-4** survey-panel family eliminated on a claim the document refutes | −7 |
| **M-3** A0 i.i.d. vs AQCR-clustered assignment and spatial dependence | −6 |
| **m-1** C3 ranked best on an unverified rule; ranking omits n-adequacy | −3 |
| **Final** | **35/100** |

---

## Disposition

Below the 80 commit gate. Re-dispatch with the gaps above; the verification discipline, the C4 rejection, the C2 honesty and the C3 exclusion critique are keepers and the rebuild should preserve them.

**Two items are candidates for user escalation rather than another worker round, because they are judgment calls and not gaps** (`permissions.md`: explorer escalates to User on data-feasibility deadlock, user decides resource trade-offs):

1. **C-2.** Whether the application's identification is defensible given that the designation used is not the designation that was made, and that the official one fails a testable implication of A1.
2. **M-1 and M-2 jointly.** $n=989$ against $d_Z$ of order 10–25, with the paper's own simulation verdict "Matches at large n only": shrink the control set to shrink $d_Z$ (and weaken the conditional-exogeneity defence), or accept an application whose standard errors are known to under-cover.
