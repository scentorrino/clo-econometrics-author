# Domain Profile

<!--
HOW TO USE: Fill this in manually OR let /discover (interactive interview) generate it.
All agents read this file to calibrate their field-specific behavior.
Delete sections that don't apply. Add sections specific to your field.
If no field is specified, agents default to applied economics.
-->

## Field

**Primary:** Theoretical econometrics — nonparametric instrumental variables, ill-posed inverse problems, semiparametric estimation in panel data
**Adjacent subfields:** Applied econometrics (panel data, time series), mathematical statistics (inverse problems, regularisation theory)

---

## Target Journals (ranked by tier)

<!-- The Orchestrator uses this for journal selection. The Librarian prioritizes these in searches. -->

| Tier | Journals |
|------|----------|
| Top-5 | AER, Econometrica, JPE, QJE, REStud |
| Top field | [e.g., JHE, RAND JE, AEJ:EP, AEJ:Applied] |
| Strong field | [e.g., Health Affairs, AJHE, JPubE, JHR] |
| Specialty | [e.g., Medical Care, Health Services Research] |

---

## Common Data Sources

<!-- The Explorer prioritizes these. The explorer-critic knows their quirks. -->

| Dataset | Type | Access | Notes |
|---------|------|--------|-------|
| [e.g., CPS] | [survey/admin/panel] | [public/restricted] | [key strengths and limitations] |

---

## Common Identification Strategies

<!-- The Strategist considers these first. The strategist-critic knows field-specific threats. -->

| Strategy | Typical Application | Key Assumption to Defend |
|----------|-------------------|------------------------|
| [e.g., State-level DiD] | [Policy variation across states] | [Parallel trends in outcomes across treated/control states] |

---

## Field Conventions

<!-- The Coder and Writer follow these. The writer-critic checks for them. -->

- [e.g., Binary outcomes → report LPM alongside logit/probit marginal effects]
- [e.g., Cost outcomes → log transform or GLM (Gamma, log link)]
- [e.g., Clustering at state level for state-level policy variation]
- [e.g., Always discuss moral hazard / adverse selection implications]
- [e.g., Welfare analysis expected in top-5 submissions]

---

## Notation Conventions

<!-- The Writer and writer-critic enforce these. -->

| Symbol | Meaning | Anti-pattern |
|--------|---------|-------------|
| [e.g., $Y_{it}$] | [Outcome for individual i at time t] | [Don't use $y$ without subscripts] |

---

## Seminal References

<!-- The Librarian ensures these are cited when relevant. The strategist-critic knows their methods. -->

| Paper | Why It Matters |
|-------|---------------|
| [e.g., Finkelstein et al. (2012)] | [Oregon HIE — gold standard for insurance effects] |

---

## Theoretical Foundational References

<!-- The Theorist and theorist-critic default to these anchors when building or reviewing a theory section.
     Only needed if the paper has a formal theory section (econometric methods, theory+empirics,
     structural identification, or methodological reduced-form).
     Leave empty to fall back to the generic econometric theory defaults baked into the theorist agent. -->

<!-- FILLED FOR panel-npiv-discrete. Every key below was verified present in
     quality_reports/literature/panel-npiv-discrete/references.bib before being written
     here — none is composed from recall. Cite BY KEY; several are fossils
     whose key year differs from the publication year (see the bib's own header).
     ENTRY COUNT IS DELIBERATELY NOT STATED HERE. It read "(74 entries)" while the file
     held 92, which is the exact defect species this project keeps finding: a claim about
     an artifact that the artifact contradicts. The count changes with every bibliography
     pass and nothing here depends on it; `grep -c '^@' references.bib` is authoritative.
     PRESENT ≠ CITED: this is a reading list for the theorist and the critics, so a key
     may legitimately appear here while no live \cite points at it (`conway2000` is in
     exactly that state since its one citation was re-keyed to `conway1990`). -->

<!-- ADDITIONS TO THIS TABLE ARE DATED. 2026-08-02: `conway1990` row added; the
     `birman1980` / `birmansolomjak1967` pair is recorded under sieve/approximation. -->
     This table OVERRIDES the generic fallback list in the theory block at the foot of
     this file: that list is vdV / Newey-McFadden / BKRW and is silent on inverse
     problems, which is the whole subject here. -->

| Topic | Anchor references (keys verified in `references.bib`) |
|-------|------------------|
| Regularisation of ill-posed inverse problems | Engl, Hanke & Neubauer (`engl2000`); Hanke (`hanke1995`); Bakushinskii (`bakushinskii1984`, quasi-optimality) |
| Adaptive / data-driven regularisation in NPIV | Dunker (`dunker2021`, `dunker2014`) |
| Operator monotonicity, Löwner–Heinz | Löwner (`loewner1934`); Bhatia (`bhatia1997`); Conway (`conway2000`) |
| Operator theory used in the proofs (compactness, multiplication operators) | Conway, *A Course in Functional Analysis*, GTM 96 2nd ed. (`conway1990`) — **the live pin**: Prop. II.4.7 (compactness of an $L^2$-kernel operator), Thm II.1.5 ($\|M_f\|=\|f\|_\infty$), Ex. IX.2.6(d) (spectrum of a multiplication). Distinct book from `conway2000`, which is *A Course in Operator Theory*, AMS GSM 21 |
| Linear NPIV, identification and completeness | Severini & Tripathi (`severini2006`); Babii & Florens (`babiiflorens2025`, *Is Completeness Necessary?*) |
| **Panel NPIV, first-differenced integral equations** | Fève & Florens (`feve2014`); **Centorrino, Fève & Florens (`centorrinofeveflorens2019`) — the author's own direct companion** |
| Root-$n$ estimability under ill-posedness | Bennett, Kallus, Mao & Newey (`bennett2023source`, `bennett2026jrssb`); Khan & Tamer (`khantamer2010`, irregular identification) |
| Neyman orthogonality, cross-fitting, debiased ML | Chernozhukov et al. (`chernozhukov2018dml`, `chernozhukov2022lr`); Newey & Robins (`neweyrobins2018`) |
| Riesz representers and automatic debiasing | Chernozhukov, Newey & Singh (`chernozhukov2022adml`, `chernozhukov2022riesz`) |
| **Conditional-to-unconditional moment devices (the Bierens device used here)** | Bierens (`bierens1990`); Bierens & Ploberger (`bierensploberger1997`); Stinchcombe & White (`stinchcombewhite1998`) |
| Semiparametric efficiency | Bickel, Klaassen, Ritov & Wellner (`bkrw1993`); Newey (`newey1990`, `newey1994var`); Chamberlain (`chamberlain1987`); Ai & Chen (`aichen2012`) |
| Sieve and spline approximation theory | Schumaker (`schumaker2007`); DeVore & Lorentz (`devorelorentz1993`) |
| Entropy of Sobolev balls (the (F-e) bound) | Birman & Solomjak (`birman1980`, Ch. 2 "Approximation theorems. Entropy") — **pinned at chapter level only; pp. 21–35 are unread and no theorem number is asserted.** The device behind it is their 1967 paper (`birmansolomjak1967`), entered but deliberately uncited. **Do NOT substitute van der Vaart & Wellner Thm 2.7.1**: it is stated for Hölder balls and costs half an order |
| Partially linear IV, $\sqrt{n}$ for the parametric component | Chen (`chenq2021`); Girard & Lapenta (`girardlapenta2026`); Li & Stengos (`listengos1996`) |
| Weak-identification-robust inference | Stock & Wright (`stockwright2000`); Kleibergen (`kleibergen2005`); Andrews & Cheng (`andrewscheng2012`) |

---

## Paper Author Team

<!-- Used by the theorist-critic to calibrate respect. If the authors are themselves among the reference
     literature on a topic, the critic avoids lecturing them on their own contributions.
     List author surnames + the topics they are foundational on. -->

**Sole author: Samuele Centorrino.** This is a single-authored paper.

| Author | Foundational on |
|--------|----------------|
| Centorrino | Nonparametric IV (NPIV): estimation, regularisation, and identification in ill-posed inverse problems. Specifically — NPIV **derivative** estimation (Florens, Racine & Centorrino 2018, `florens2012`); NPIV with a **discrete/binary instrument** and the $\beta \le 1-\epsilon$ source-condition ceiling (Centorrino, Fève & Florens 2025, `centorrinofeveflorens2019` — the direct companion to this paper); **IV for duration outcomes** and global identification in nonlinear inverse problems (Beyhum, Centorrino, Florens & Van Keilegom 2023, `beyhum2024`); **exogeneity in continuous-time models**. |

<!-- CONSEQUENCE FOR CRITICS, and the reason this table exists. The theorist-critic,
     domain-referee and counterexample-hunter must NOT explain the author's own results
     back to them. Three live instances in this project:
       - CFF (2025)'s derivative-parameterisation device was ASSESSED AND DECLINED here
         (the index falls, failing the frontier) — that is the author's considered
         judgement on the author's own method, not an oversight to be flagged.
       - CFF's Assumption (18) was assessed as a replacement for A6b and DECLINED.
       - CFF's ceiling $\beta\le 1-\epsilon$ IS $\mu<\tfrac12$ under $\beta=2\mu$ — the
         same number as the Löwner–Heinz barrier reached from the applied side. It is
         therefore the econometrics citation FOR that ceiling, not a competing claim.
     A critic writing "the author should consider Centorrino, Fève & Florens (2025)" has
     failed. The correct move is to ask whether the DEPARTURE from it is justified. -->


---

## Field-Specific Referee Concerns

<!-- The domain-referee and methods-referee watch for these. -->

- [e.g., "Why not use the Oregon HIE?" — must address if studying insurance effects]
- [e.g., "Selection into treatment" — always a concern in health care utilization studies]
- [e.g., "Moral hazard vs adverse selection" — referees expect you to distinguish]
- [e.g., "External validity" — Medicaid population ≠ general population]

---

## Quality Tolerance Thresholds

<!-- Customize for your domain's standards. Used by quality.md. -->

<!-- DRAFTED FROM THIS PROJECT'S OWN SIMULATION, NOT FROM A FIELD CONVENTION. Every
     number below is derived from B = 5,000 replications, which is what
     scripts/simulations/sim_thm_rootn_run_all.R actually runs at EVERY n (it no longer
     drops to 2,000 at large n — that halving was the substance of finding B3 in
     quality_reports/sim/sim_thm_rootn_review.md, where a verdict was pronounced exactly
     at the two cells whose SE had been inflated 0.010 -> 0.016 by the drop).
     IF B CHANGES, THESE NUMBERS CHANGE. They scale as B^{-1/2}. -->

| Quantity | Tolerance | Rationale |
|----------|-----------|-----------|
| Coverage rate, nominal 95% | ± 0.0062 (2 MC SE) | $\sqrt{0.95\cdot0.05/5000}=0.0031$. A gap inside this bar is not evidence of anything. |
| Coverage rate, nominal 90% | ± 0.0085 (2 MC SE) | $\sqrt{0.90\cdot0.10/5000}=0.0042$. **Report this level too** — DGP-A's 90% coverage is below nominal in 8 of 8 cells (sign test $p=0.004$) while 95% looks clean. |
| SD ratio (empirical vs asymptotic) | 2 × the *stated* MC SE, currently 0.010 | Never a fixed constant: it must be recomputed and printed alongside the ratio. |
| Point estimates (symbolic identities) | Exact — `simplify(lhs - rhs) == 0` | `scripts/symbolic/verify.py`. A residual that merely *looks* small is a MISMATCH, not a match. |
| Point estimates (numerical) | 1e-8 relative | Below this, differences are floating-point, not substantive. Do not compare condition numbers against a bar tighter than this. |
| Rate exponents read off a log-log fit | ± 0.02 absolute | Distinguishes $n^{-1/2}$ from neighbouring rates at the n-grid in use; tighter claims need a wider grid, not a tighter bar. |

**Two standing rules that outrank any number in this table.**

1. **The MC SE is stated before the gap is interpreted, every time.** Reporting a gap in SE units using the *smallest* available measure while a larger one at the same cell goes unstated is the failure mode this project has already hit (review finding B4: worst-quantile gap reported in SE units; sd ratio at the same cells was 11.7 SE, unstated).
2. **A tolerance is not a pass.** "Within 2 MC SE" means *not distinguishable*, which is only evidence of a match when the design has been shown able to reject a violation. An assumption-broken DGP is required before "Matches" is a finding rather than a non-rejection.

---

## Theoretical Econometrics Profile (when PROJECT_TYPE: theory or mixed)

<!-- This block is the default profile for theoretical-econometrics papers.
     The librarian and domain-referee read it; the theorist and theorist-critic
     fall back to it when the per-project anchors above are empty.
     Uncomment / edit the sections you need. -->

### Target Journals (theory track)

**SELECTED TARGET for `panel-npiv-discrete`: Oxford Bulletin of Economics and Statistics (OBES).**
Profile in `.claude/references/journal-profiles.md`. This is a *decision*, not a ranking —
the tiers below remain the fallback ladder if OBES declines.

| Tier | Journals |
|------|----------|
| Top methods | Econometrica (theory track), Annals of Statistics |
| Strong methods | Journal of Econometrics, Econometric Theory, Quantitative Economics |
| Field methods | Journal of Econometric Methods, Econometrics Journal |
| **Applied-econometrics field** | **Oxford Bulletin of Economics and Statistics (OBES) — SELECTED** |
| Adjacent | JASA (Theory and Methods), Biometrika |

### Frameworks (replacing "identification strategies" in theory mode)

| Framework | Use for |
|---|---|
| M-estimation / Z-estimation | Extremum estimators with smooth or non-smooth objective |
| GMM and generalized empirical likelihood | Moment-based estimators with overidentification |
| Sieve methods | Infinite-dimensional parameter, semiparametric estimation |
| Empirical process theory | Uniform laws, weak convergence on function spaces |
| Semiparametric efficiency theory | Efficiency bounds, influence functions, adaptivity |
| U- and V-statistics | Symmetric kernels, distributional results for $\sum_{i<j}$ statistics |
| Kernel and local methods | Nonparametric estimation, bandwidth selection |
| Double / debiased machine learning | High-dimensional or ML nuisance with Neyman orthogonality |
| Bootstrap consistency | Distribution approximation, higher-order refinements |
| Parameter on boundary / weak identification | Andrews-type irregularities, identification at infinity |

### Foundational References

These are loaded by default when the per-project Theoretical Foundational References table above is empty.

| Topic | Anchor references |
|-------|------------------|
| Asymptotic statistics (general) | van der Vaart (1998), *Asymptotic Statistics*; Lehmann (1999), *Elements of Large-Sample Theory* |
| M- and Z-estimation, large-sample theory | Newey & McFadden (1994), Handbook of Econometrics ch. 36 |
| Semiparametric efficiency | Bickel, Klaassen, Ritov & Wellner (1993), *Efficient and Adaptive Estimation*; Newey (1990, 1994) |
| Empirical process theory | van der Vaart & Wellner (1996), *Weak Convergence and Empirical Processes*; Pollard (1984), *Convergence of Stochastic Processes* |
| GMM | Hansen (1982); Newey & West (1987); Newey (1991) |
| Boundary / non-standard inference | Andrews (1999, 2000, 2001) — parameter on boundary series |
| Bootstrap | Hall (1992), *The Bootstrap and Edgeworth Expansion*; Mammen (1992) |
| DiD with staggered adoption | Callaway & Sant'Anna (2021); Sant'Anna & Zhao (2020); de Chaisemartin & D'Haultfœuille (2020) |
| Debiased / double ML | Chernozhukov et al. (2018, 2022) |
| Modern econometric theory textbook | Hansen (2022), *Econometrics* |

### Theory-Paper Conventions

- Explicitly state the asymptotic framework (iid, weakly dependent, panel with fixed-$T$ vs large-$T$, triangular array).
- Distinguish weak vs strong consistency in claims and theorem statements.
- Conditions are stated as named, numbered assumptions (A1, A2, …). Theorems cite by tag.
- Every regularity step is justified — DCT/Fubini/uniform LLN invocations name the result.
- Pointwise vs uniform is always qualified.
- Rates are named ($\sqrt{n}$, $n^{1/3}$) rather than described as "fast" or "slow."
- Identification arguments precede estimation arguments.

### Theory-Paper Referee Concerns (domain + methods)

- "How does this compare to <Hansen 1982 / vdV 1998 / BKRW 1993>?" — always have an answer.
- "Why isn't this just a special case of <existing framework>?" — be explicit about novelty.
- "Where is uniformity needed and where is it proved?" — point to the lemma.
- "What happens on the boundary?" — even if the answer is "ruled out by A3," say so explicitly.
- "Is the rate tight or just an upper bound?" — be explicit about which.
- "Bootstrap validity argument?" — required when CIs are bootstrapped.
