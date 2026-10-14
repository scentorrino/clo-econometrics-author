# Annotated Bibliography — Panel NPIV with a Discrete Instrument: Direct $\sqrt{n}$ Estimation of $\theta_\dagger$

**Project slug:** `panel-npiv-discrete`
**Plan:** `quality_reports/plans/2026-07-28_panel-npiv-direct-theta.md`
**PROJECT_TYPE:** theory
**Compiled:** 2026-07-28 · Round 2 (accepted 86/100) + cleanup pass + **G-1 closure**
**Project bibliography:** `/Users/samuele/Library/CloudStorage/Dropbox/Nonparametric_IV/instrumental.bib` (344 entries)
**New entries file:** `references.bib` (this directory) — **58 entries**

---

## Maintained model

$$Y_{it}=\vdagger(X_{it}) + Z_{it}'\theta_\dagger + \eta_i + U_{it},\qquad t\in\{1,2\},\qquad
\Delta Y = \Delta\vdagger + \Delta Z'\theta_\dagger + \Delta U .$$

- **A1:** $\Delta U \perp W \mid \Delta Z$ **and** $E[\Delta U\mid\Delta Z]=0$.
- **Instrument centring:** $\widetilde W = W - \varrho(\Delta Z)$, with $\varrho(\Delta Z)=E[W\mid\Delta Z]$.
- **Dimension control in $\Delta Z$ — the Bierens device**, verbatim from plan §2.2:

$$M(u,t) \;=\; E\Big[\,\widetilde W \;\cdot\; \mathbf 1\{\Delta U \le u\} \;\cdot\; w\big(t'\,\Phi(\Delta Z)\big)\Big] \;=\; 0$$

for all $u$ and all $t$ in a set of positive Lebesgue measure, where $\Phi(\cdot)$ is the **bounded one-to-one transform of $\Delta Z$** (componentwise $\arctan$) required by the notation contract §1. **$\Phi$ acts on $\Delta Z$, not on $\Delta U$**, and supplies the boundedness the Bierens lemma needs.

- **Debiasing weight $\ell$:** obtained by **sample balancing in RKHS form**, one ridge parameter, not by inverting the population adjoint.

**On Lemma L1.** L1 shows the conditional-independence restriction alone admits a product set $\Phi_{CI}\times\IR^p$, so it carries no information about $\theta_\dagger$ *by itself*. Not an obstruction: $\theta_\dagger$ is identified by $E[\Delta U\mid\Delta Z]=0$, and the added term in a Neyman-orthogonal moment is mean-zero at the truth by construction. Retain L1 as a *characterisation*.

> **Cross-reference for the L1 / R1 discussion (from the G-1 read).** Poirier (2017) has a section headed *"Conditional independence restrictions and partially linear regression example"* showing that *"imposing a conditional moment restriction instead of conditional independence restriction results in a loss of identification."* Adjacent territory, **but the direction differs and the manuscript must say so**: in Poirier, conditional independence *buys* identification that a conditional mean restriction does not; here, the conditional-independence restriction is *uninformative* about $\theta_\dagger$, identification comes from the mean restriction, and independence supplies the debiasing channel. Related, not the same.

---

## Conventions

Proximity is **strictly competition distance**; a separate **Role** tag carries importance.

| Proximity | Meaning |
|---|---|
| **1** | Directly competes — same question, same or near-same machinery. Scooping-relevant. |
| **2** | Closely related — same question, different method, or same method, different problem class. |
| **3** | Related — overlapping topic or shared technical ingredient, different angle. |
| **4** | Background — supplies theory, method or context we build on. |
| **5** | Framing only. |

| Role | Meaning |
|---|---|
| COMPETITOR | Could be argued to do what we do. |
| FRAMEWORK | A general theory that might be argued to nest the result. |
| COMPANION | Same authors/lineage, supplies machinery, does not compete. |
| TOOL | Supplies a technique or condition we use. High importance, zero competition. |
| PRECEDENT | Structural or methodological forerunner. |
| BACKGROUND | Context, motivation, application. |

**Bib status:** `IN BIB` · `IN BIB (key misleads)` · `NEW` (in `references.bib`) · `NEW / UNVERIFIED`.

---

## Area A — Partially linear IV and $\sqrt{n}$ estimation of the parametric component

### A1. Robinson (1988) — `robinson1988` — IN BIB · Proximity **3** · TOOL/PRECEDENT
**Root-N-Consistent Semiparametric Regression.** *Econometrica* 56(4), 931–954.
Subtracting conditional expectations given $X$ annihilates $\varphi$; OLS on residualised variables is $\sqrt n$-normal. **Relevance:** exactly the argument Remark R2 shows is unavailable — with two $X$'s and $\varphi$ entering as a difference, no weight measurable w.r.t. $(W,\Delta Z)$ annihilates $\varphi$ unless the tilted marginals coincide, which fails when $X$ drifts. Draft has a stray `@robinson1988}` at `:179`.

### A2. Ai & Chen (2003) — `ai2003` — IN BIB · Proximity **2** · FRAMEWORK
**Efficient Estimation of Models with Conditional Moment Restrictions Containing Unknown Functions.** *Econometrica* 71(6), 1795–1843.
**Relevance:** directly comparable under the amendment, since $\Delta U\perp W\mid\Delta Z$ *is* a conditional moment system. Two differences: they need a nonparametric estimate of $E[\cdot\mid\Delta Z]$ (what the Bierens device removes), and their empirical-process control is stochastic equicontinuity over the sieve.

### A3. Florens, Johannes & Van Bellegem (2012) — `florens2006` — IN BIB (key misleads) · Proximity **1** · COMPETITOR
**Instrumental Regression in Partially Linear Models.** *The Econometrics Journal* 15(2), 304–324.

> **Plan §5 to-do — CLOSED.** The entry is the **published** version, year **2012**. Key name and singular/plural title are cosmetic.

Tikhonov regularisation of the linear ill-posed equation; $\sqrt n$ normality under a source-type condition. **Falls short:** conditional-mean restriction ⇒ **linear, fixed** operator; ours is a Fréchet derivative at the unknown truth. No panel; continuous instrument; no conditioning variable, hence no Bierens device.

### A4. Florens & Lapenta (2024) — `florenslapenta2024` — IN BIB · Proximity **1** · COMPETITOR
**Partly linear IV regressions without smoothing on the instruments.** *TEST* 33(3), 897–920.
**Falls short:** the operator is again **linear**; "no smoothing on the instruments" is a *fixed-bandwidth* device, not a conditional-to-unconditional conversion with a consistency guarantee. No panel, no orthogonalisation, no cross-fitting.

### A5. Chen, Qihui (2021) — `chenq2021` — NEW · Proximity **2** · COMPETITOR
**Robust and optimal estimation for partially linear IV models with partial identification.** *JoE* 221(2), 368–380.
The parametric component can be $\sqrt n$-estimable even when the nonparametric one is not — the logic of A2. **Falls short:** linear conditional-mean PLIV; no cross-fitting, no distributional restriction, no panel.

### A6. Beyhum, Lapenta & Lavergne (2025) — `beyhumlapentalavergne2025` — IN BIB · Proximity **3** · PRECEDENT
**One-step smoothing splines instrumental regression.** ***The Econometrics Journal* 28(2), 176–197.**

> **Round-2 correction (C1).** Round 1 gave the journal as *Econometric Theory*. The bib entry is correct; the journal-targeting ranking was re-derived and the ordering is unchanged.

Uniform rates for the estimator **and its first derivative** — bearing on plan §15's finding that the derivative-parameterised bias bound is vacuous for an LF iterate ($\lVert\hat\varphi'-\varphi'\rVert\approx 70$).

### A7. Girard & Lapenta (2026) — `girardlapenta2026` — NEW (arXiv verified) · Proximity **3** · COMPETITOR
**Average Marginal Effects in One-Step Partially Linear IV Regressions.** arXiv:2604.11393.
RKHS one-step, single regularisation parameter, asymptotic normality, Bayesian bootstrap. Technically adjacent; still the linear conditional-mean operator.

### A8. Ai & Chen (2012) — `aichen2012` — NEW · Proximity **3** · TOOL
**Semiparametric efficiency bound for sequential moment restrictions containing unknown functions.** *JoE* 170(2), 442–457.
Under the amendment the restriction system is genuinely sequential. Feeds `prp:effbound` alongside Poirier (B13) and Chamberlain (J1).

### A9. Li & Stengos (1996) — `listengos1996` — NEW · Proximity **3** · PRECEDENT
**Semiparametric estimation of partially linear panel data models with endogenous variables.** *JoE* 71(1–2), 389–397.
**Falls short:** exogenous nonparametric component; endogeneity handled linearly. *Title wording flagged.*

---

## Area B — $\sqrt{n}$-estimability under ill-posedness and under independence

### B1. Severini & Tripathi (2006) — `severini2006` — IN BIB · Proximity **3** · TOOL
**Some Identification Issues in NP Linear Models with Endogenous Regressors.** *ET* 22(2), 258–278.
$\langle\nu,\varphi\rangle$ identified iff $\nu\in\mathcal{R}(T^\ast)$. **The identification half of A2**; the transplant onto a nonlinear operator's Fréchet derivative is the contribution.

### B2. Severini & Tripathi (2012) — `severini2012` — IN BIB · Proximity **4** · TOOL
**Efficiency bounds for estimating linear functionals of NP regression models with endogenous regressors.** *JoE* 170(2).
The bound is finite **iff** $\nu\in\mathcal{R}(T^\ast)$. **The authority for why plan §12 forbids weakening A2.**

**Caveat.** The result concerns **linear functionals**. A finite-dimensional structural parameter can be $\sqrt n$-estimable under ill-posedness given a range condition — which is what A2 supplies. Round 1 used the theorem in reverse to argue about Poirier; withdrawn, and the G-1 read settled the question directly.

### B3. Chen & Pouzo (2012) — `chen2012` — IN BIB · Proximity **2** · FRAMEWORK
**Estimation of NP Conditional Moment Models with Possibly Nonsmooth Generalized Residuals.** *Econometrica* 80(1).
**The strongest framework-level overlap.** Rebuttal in `positioning.md` §3.

### B4. Chen & Pouzo (2015) — `chen2012b` — IN BIB (key misleads) · Proximity **2** · FRAMEWORK
**Sieve Wald and QLR Inferences.** *Econometrica* 83(3), 1013–1079.
The most complete existing $\sqrt n$-functional theory for conditional moment models; the sieve Riesz representer condition is the sieve analogue of A2.

### B5. Chen & Christensen (2018) — `chenchristensen2015` — IN BIB (key misleads) · Proximity **3** · TOOL
**Optimal sup-norm rates and uniform inference on nonlinear functionals of NPIV regression.** *QE* 9(1), 39–84.
The regular/irregular dividing line; the best-case nonparametric rate `prp:plugin` must be compared against.

### B6. Babii & Florens (2025) — `babiiflorens2025` — NEW · Proximity **3** · TOOL
**Is completeness necessary?** *ET* 41(6), 1284–1321. **The citation for plan §12's honest fallback.**

### B7. Escanciano (2022) — `escanciano2022` — NEW · Proximity **3** · TOOL
**Semiparametric Identification and Fisher Information.** *ET* 38(2), 301–338.
**The cleanest language for what A2 buys** — state A2 as the condition under which $\theta_\dagger$ is *regularly identified*.

### B8. Bennett, Kallus, Mao, Newey, Syrgkanis & Uehara (2026) — `bennett2026jrssb` — NEW · Proximity **2** · COMPETITOR
**Inference on strongly identified functionals of weakly identified functions.** *JRSS-B* 88(3), 998–1028.
Penalised **minimax (adversarial)** estimation of the debiasing nuisance. **Closest published analogue in the linear case.** **Falls short:** linear inverse problem; target is a functional of the nuisance; no panel.

### B9. Bennett et al. (2023) — `bennett2023source` — NEW · Proximity **2** · TOOL
**Source Condition Double Robust Inference.** arXiv:2307.13793.
The primal/dual pairing is our $(\hat\varphi,\hat\ell)$ pairing. Suggests a *disjunctive* smoothness condition — probable referee ask.

### B10. Santos (2011) — `santos2011` — IN BIB · Proximity **4** · TOOL
**IV Methods for Recovering Continuous Linear Functionals.** *JoE* 161(2), 129–146.
Cite alongside Severini–Tripathi for A2 — **and note from the G-1 read that Poirier (2017) attributes his partially linear generalization to this paper**, so it sits in the independence lineage too.

### B11. Chen, Chernozhukov, Lee & Newey (2014) — `chenchernozhukovleenewey2014` — IN BIB · Proximity **4** · TOOL
**Local Identification.** *Econometrica* 82(2), 785–809. The citation for Assumption A3. *Duplicated as `chenlee2013`.*

### B12. Khan & Tamer (2010) — `khantamer2010` — NEW · Proximity **3** · TOOL
**Irregular Identification, Support Conditions, and Inverse Weight Estimation.** *Econometrica* 78(6), 2021–2042.
If point identification **requires weights taking arbitrarily large values**, the parameter is point identified but **not $\sqrt n$-estimable**.
**The anchor for Assumption A4.** At the application's **689/300 split**, limited overlap in $\varrho(\Delta Z)$ is live: A2 can hold and $\theta_\dagger$ still fail to be $\sqrt n$-estimable if identification leans on regions where $\varrho$ approaches 0 or 1. A4 should make the two conditions jointly sufficient, and the overlap diagnostic should be reported alongside the identification-strength diagnostic.

### B13. Poirier (2017) — `poirier2017` — IN BIB · Proximity **1** · COMPETITOR — **G-1 CLOSED, VERIFIED**
**Efficient estimation in models with independence restrictions.** *Journal of Econometrics* 196(1), 1–22.

Computes the semiparametric efficiency bound for **finite-dimensional parameters** under **unconditional and conditional independence restrictions**, with a consistent, asymptotically normal, efficient estimator built on **a finite but growing number of zero-covariance conditions** asymptotically equivalent to the independence restriction.

**What the full text shows.** Verified by direct read (working-paper PDF; metadata title matches the published title; 22 pages matching JoE 196(1), 1–22):

- **Example 1.2 (Instrumental Variables Regression):** $Y = X'\theta_0 + U$ with $U \perp Z$ — in his words, *"a linear IV model with independent errors."* Fully parametric, no nonparametric component. **This resolves the ambiguity that kept the gate open: "instrumental variables regression model" means linear IV, not NPIV.**
- **Example 1.5 (Partially Linear Regression):** $Y = X\theta_0 + G_0(W,\varepsilon)$ with $\varepsilon \perp (X,W)$ — the nonparametric argument $W$ is **exogenous by assumption**. A generalization of Robinson (1988) allowing the marginal effect of $W$ to vary across observationally equivalent units, attributed to **Santos (2011)**; reduces to $\rho(Y,X,\theta)\perp X\mid W$.
- **Monte Carlo (§4):** Card (1999) returns-to-schooling, binary instrument, endogenous schooling — but $Y = X\theta_0 + U$, linear.

**Every nonparametric object is a function of exogenous variables or an error distribution. No structural inverse, no ill-posedness.** He mentions ill-posedness once, in §1.2, only to say his construction **avoids** it — and there it concerns the CGMM *weighting operator*, not a structural nuisance. That passage is also the source of round 1's confabulated output, whose context was the opposite of what was reported.

**Why he matters more, not less.** Three uses:

1. **He names this paper's setting as his open extension.** §5, verbatim: *"…to generalize our results to models with unconditional independence restriction **with nuisance functions of the type $\rho(Y, X, \theta, h(\cdot)) \perp Z$, where $h(\cdot)$ is a nonparametric object**."* The strongest single piece of novelty evidence available. **Caveat to state honestly:** he writes *unconditional*, whereas this paper maintains the *conditional* form — the closest available statement of the gap, not a literal description.
2. **Primary citation for `prp:effbound`** — the efficiency bound under independence restrictions for a finite-dimensional parameter is his theorem.
3. **A precedent for plan §14's weighting question** — see I5.

**Falls short as a competitor:** well-posed nuisance; finite-growing-basis GMM rather than regularised inversion; no panel, no first differencing, no discrete-instrument requirement, no orthogonalisation for a subvector.

**Provenance:** the published version remains paywalled to this agent (ScienceDirect 403, SSRN 403, CORE 403); the above is verified against the working paper.

---

## Area C — Orthogonal moments, cross-fitting, and balancing / Riesz-representer estimation

> **Bib gap.** Grepping `instrumental.bib` for `Double/Debiased`, `Automatic Debiased`, `Locally Robust`, `Riesz`, `Balancing`, `Cross-fitting`, `Orthogonal` returns **one** hit — "Orthogonal Series Density Estimators."

### C1. Chernozhukov et al. (2018) — `chernozhukov2018dml` — NEW · Proximity **4** · TOOL
**Double/debiased machine learning.** *EctJ* 21(1), C1–C68.
**The direct parent of Section 3.** The moment carries **two** nuisances — the ill-posed nonlinear $\varphi$ and the ordinary regression $\varrho(\Delta Z)$. DML covers the second exactly and the first not at all.

### C2. Chernozhukov, Escanciano, Ichimura, Newey & Robins (2022) — `chernozhukov2022lr` — NEW · Proximity **4** · TOOL
**Locally Robust Semiparametric Estimation.** *Econometrica* 90(4), 1501–1535.
P1 is an instance; the $\varrho$-correction is the LR adjustment for the propensity step.

### C3. Chernozhukov, Newey & Singh (2022) — `chernozhukov2022adml` — NEW · Proximity **2** · TOOL
**Automatic Debiased ML.** *Econometrica* 90(3), 967–1027.
**The central citation for plan §15.** The kernel-adjoint failure — discrepancy $0.0000$ with the bias uncancelled, CG diverging $0.06\to 130$ — is the failure mode it avoids.

### C4. Chernozhukov, Newey & Singh (2022) — `chernozhukov2022riesz` — NEW · Proximity **4** · TOOL
**Debiased ML using regularized Riesz representers.** *EctJ* 25(3), 576–601. The single-ridge-parameter form.

### C5. Singh (2021/2024) — `singh2024krrr` — NEW · Proximity **2** · PRECEDENT
**Kernel Ridge Riesz Representers.** arXiv:2102.11076.
**Kernel balancing weights *are* kernel ridge Riesz representers** — the closest technical precedent for the amended debiasing step. Misspecification analysis reusable for the out-of-span term.

### C6. Athey, Imbens & Wager (2018) — `atheyimbenswager2018` — NEW · Proximity **4** · PRECEDENT
**Approximate residual balancing.** *JRSS-B* 80(4), 597–623. The founding "balance in sample" paper.

### C7. Hirshberg & Wager (2021) — `hirshbergwager2021` — NEW · Proximity **4** · TOOL
**Augmented minimax linear estimation.** *AoS* 49(6), 3206–3227. Bounding the out-of-span component over an RKHS ball *is* a minimax-linear calculation.

### C8. Zubizarreta (2015) — `zubizarreta2015` — NEW · Proximity **4** · PRECEDENT
**Stable weights that balance covariates.** *JASA* 110(511), 910–922.

### C9. Bruns-Smith, Dukes, Feller & Ogburn (2026) — `brunssmith2026` — NEW · Proximity **4** · BACKGROUND
**Augmented balancing weights as linear regression.** *JRSS-B* 88(3), 699–723. **Defensive:** the conditions under which augmentation is redundant — which our setting fails.

### C10. Bakhitov (2026) — `bakhitov2026` — NEW (arXiv verified) · Proximity **2** · COMPETITOR
**Penalized GMM for Functionals of NPIV Estimators.** arXiv:2603.29889. **Falls short:** linear operator, no panel, no independence restriction.

### C11. Chernozhukov, Newey, Quintas-Martínez & Syrgkanis (2022) — `chernozhukov2022rieszznet` — NEW · Proximity **4** · BACKGROUND
**RieszNet and ForestRiesz.** ICML, PMLR 162. *Page range flagged.*

### C12. Newey & Robins (2018) — `neweyrobins2018` — NEW · Proximity **4** · TOOL
**Cross-fitting and fast remainder rates.** arXiv:1801.09138; cemmap CWP41/17.

### C13. Shen, Kallus, Meunier, Zenati, Gretton & Bibaut (2026) — `shen2026` — NEW (arXiv verified) · Proximity **3** · BACKGROUND
**NPIV Analysis Without Structural Equations.** arXiv:2604.24660. *Round 2 keyed this `zhen2026` and mis-transcribed the first author; it is **Zikai Shen**.*

---

## Area D — Discrete instruments with a continuous endogenous regressor

### D1. Centorrino, Fève & Florens (2025) — `centorrinofeveflorens2019` — IN BIB (key misleads) · Proximity **2** · COMPANION
**Iterative estimation of NP regressions with continuous endogenous variables and discrete instruments.** *JoE* 247, 105950.
**Supplies the entire $\varphi$-machinery.** **Absent:** no parametric component, no panel, no conditioning variable, no orthogonal moment, no cross-fitting, no $\sqrt n$ theory.

> **Round-2 correction (C4).** The "zero forward citations" claim is downgraded to a weak single-source signal and not used as evidence.

### D2. D'Haultfœuille & Février (2015) — `fevrier2015` — IN BIB · Proximity **4** · BACKGROUND
**Identification of Nonseparable Triangular Models with Discrete Instruments.** *Econometrica.*

### D3. Torgovitsky (2015) — `torgovitsky2015` — IN BIB · Proximity **4** · BACKGROUND
**Identification of Nonseparable Models Using Instruments with Small Support.** *Econometrica* 83(3), 1185–1197.

### D4. Torgovitsky (2017) — `torgovitsky2017` — IN BIB · Proximity **3** · PRECEDENT
**Minimum distance from independence estimation.** *JoE.* The closest existing *estimator* on an independence restriction.

### D5. Dunker, Florens, Hohage, Johannes & Mammen (2014) — `dunker2014` — IN BIB · Proximity **2** · TOOL
**Iterative estimation of solutions to noisy nonlinear operator equations in NPIV.** *JoE* 178(P3), 444–455.
**Rates for $\hat\varphi$ but no $\sqrt n$ theory for any finite-dimensional object.** The nonlinear-operator half of the frontier.

### D6. Loh (2023) — `loh2022` — IN BIB · Proximity **3** · BACKGROUND
**NP identification and estimation with discrete instruments and regressors.** *JoE* 235(2), 1257–1279. **Cites Poirier (2017)** — same tradition.

### D7. De Monte (2024) — `demonte2024` — NEW · Proximity **2** · COMPETITOR
**NP Instrumental Regression with Two-Way Fixed Effects.** *J. Econometric Methods* 13(1), 49–66.
**Falls short:** fully nonparametric, no $\sqrt n$; standard linear conditional-mean operator.

### D8. Manski (1983) — `manski1983` — IN BIB · Proximity **5** · BACKGROUND
**Closest empirical distribution estimation.** *Econometrica.* The non-attaining benchmark for `prp:effbound`.

---

## Area E — Weak-identification-robust inference

> **Bib gap confirmed.** The only "Wright" is `wright1981` (F. T. Wright); `kleibergen2006` is Kleibergen–Paap; `andrews2011` is Andrews (2017).

### E1. Stock & Wright (2000) — `stockwright2000` — NEW · Proximity **4** · TOOL — **REQUIRED BY PLAN §9.2**
**GMM with Weak Identification.** *Econometrica* 68(5), 1055–1096.
The S-statistic's limit is free of the weakly-identified parameters. The Jacobian can be near-singular exactly where the counterexample-hunter probes; the amendment adds channels — nearly-constant $\varrho(\Delta Z)$, or a flat $t$-region.
**Implementation note:** hold all cross-fitted nuisances fixed across the $\theta$-grid.

### E2. Kleibergen (2005) — `kleibergen2005` — NEW · Proximity **4** · TOOL
**Testing Parameters in GMM Without Assuming that They Are Identified.** *Econometrica* 73(4), 1103–1123.
**More relevant under the amendment:** the $(u,t)$ family makes the system massively over-identified, where S loses power relative to K.

### E3. Andrews & Cheng (2012) — `andrewscheng2012` — NEW · Proximity **5** · BACKGROUND
*Econometrica* 80(5), 2153–2211.

### E4. Andrews, Stock & Sun (2019) — `andrewsstocksun2019` — NEW · Proximity **5** · BACKGROUND
*Annual Review of Economics* 11, 727–753.

---

## Area F — Hedonic pollution application

### F1. Chay & Greenstone (2005) — `chay2005` — IN BIB · Proximity **3** · BACKGROUND
**Does Air Quality Matter?** *JPE* 113(2), 376–424.
**The data and the design.** (i) They impose **linearity** in TSP; (ii) their $W$ is our **binary** instrument, their 1970–1980 difference our $t\in\{1,2\}$; (iii) their $\Delta Z$ is where $E[\Delta U\mid\Delta Z]=0$ bites; (iv) **under the amendment $\Delta Z$ also conditions the independence restriction and argues $\varrho(\Delta Z)$** — a better model of CAA designation, though the 689/300 split makes overlap live (B12).

### F2. Masten & Torgovitsky (2016) — `masten2016` — IN BIB · Proximity **4** · BACKGROUND
*REStat* 98(5), 1001–1005. The draft at `:237` reads the sign pattern as consistent with this.

### F3. Rosen (1974) — `rosen1974` — NEW · Proximity **5** · BACKGROUND
*JPE* 82(1), 34–55. Why $\varphi$ is a *price function*.

### F4. Greenstone & Gallagher (2008) — `greenstonegallagher2008` — NEW · Proximity **5** · BACKGROUND
*QJE* 123(3), 951–1003.

### F5. Bishop et al. (2020) — `bishop2020` — NEW · Proximity **5** · BACKGROUND
*REEP* 14(2), 260–281.

---

## Area G — Panel nonparametrics and first-differenced integral equations

### G1. Fève & Florens (2014) — `feve2014` — IN BIB · Proximity **1** · COMPETITOR
**Non parametric analysis of panel data models with endogenous variables.** *JoE* 181(2), 151–164.
**Panel data models by first differences** with **endogenous variables** under an **IV condition**; **linear inverse problems** solved by **Tikhonov** with an $L^2$ or Sobolev penalty. By **two of the three companion-paper authors**; the closest prior work on the *panel* axis.
**Falls short:** the inverse problem is **linear**; no parametric component at $\sqrt n$; no discrete-instrument requirement; no orthogonalisation.

> **Verification note.** The linear/Tikhonov characterisation is confirmed from published descriptions. The absence of a partially linear specification and of a $\sqrt n$ result is **inferred**; full text not obtained (ScienceDirect 403). **This is now the only unverified competitor claim in the deliverables.**

### G2. Su & Lu (2013) — `sulu2013` — NEW · Proximity **3** · PRECEDENT
*JoE* 176(2), 112–133. The first-differenced model's components share the **same functional form**, giving a **second-kind Fredholm equation**. **Falls short:** exogenous $X$ ⇒ well-posed.

### G3. Evdokimov (2010) — `evdokimov2010` — NEW · Proximity **4** · BACKGROUND
Princeton WP. What two periods deliver without an instrument.

### G4. Deaner (2025) — `deaner2025` — NEW / UNVERIFIED · Proximity **3** · BACKGROUND
**Proxy Controls and Panel Data.** arXiv:1810.00283. The proximal alternative. *Publication status unconfirmed — the only remaining `% UNVERIFIED` entry.*

### G5. Chernozhukov, Deaner, Gao, Hausman & Newey (2025) — `chernozhukov2025fs` — NEW · Proximity **4** · BACKGROUND
NBER WP 33325. **Falls short:** large-$T$; we have $T=2$.

### G6. Baiardi, Clarke, Naghi & Polselli (2026) — `baiardi2026` — NEW (arXiv verified) · Proximity **3** · BACKGROUND
arXiv:2603.20464. **Falls short:** nuisances are ordinary conditional expectations; treatment enters linearly. Useful diagnostic template.

### G7. Centorrino & Florens (2021) — `centorrinoflorens2021` — IN BIB · Proximity **4** · COMPANION
*EJS* 15(2), 5333–5379. Author's own prior work; shared regularisation machinery.

### G8. Centorrino & Racine (2017) — `centorrino2017` — IN BIB · Proximity **4** · COMPANION
*AES* 128, 261–295. The closest prior *semiparametric* treatment in the author's own record.

---

## Area H — Conditional-to-unconditional moment devices

### H1. Bierens (1982) — `bierens1982` — IN BIB · Proximity **3** · TOOL
*JoE* 20, 105–143. $E[\varepsilon\mid V]=0$ **iff** $E[\varepsilon\,e^{t'V}]=0$ on a positive-measure $t$-set, **for bounded $V$**. **The enabling lemma** — and the reason $\Phi$ exists.

### H2. Bierens (1990) — `bierens1990` — IN BIB · Proximity **3** · TOOL
*Econometrica* 58(6), 1443–1458. A data-driven $t$ that preserves the limit.

### H3. Bierens & Ploberger (1997) — `bierensploberger1997` — NEW · Proximity **3** · TOOL
*Econometrica* 65(5), 1129–1151. Weighted-$\chi^2$ limit from the eigenvalues of a covariance kernel — **the same object as the spectral decomposition defining the source condition.**

### H4. Stinchcombe & White (1998) — `stinchcombewhite1998` — NEW · Proximity **3** · TOOL
*ET* 14(3), 295–325. **Generically comprehensively revealing (GCR)** families. **Frees the paper from the exponential.** Their GCR property *is* the injectivity property in Banach-valued form.

### H5. Escanciano (2006) — `escanciano2006` — NEW · Proximity **3** · TOOL
*ET* 22(6), 1030–1051. **The cleanest statement that the projection device solves the dimension problem.**

### H6. Fan & Li (2000) — `fanli2000` — NEW · Proximity **3** · BACKGROUND
*ET* 16(6), 1016–1041. The econometrics half of the ICM↔kernel bridge.

### H7. Domínguez & Lobato (2004) — `dominguezlobato2004` — NEW · Proximity **2** · TOOL
*Econometrica* 72(5), 1601–1615. A *finite*, arbitrarily chosen instrument set can make GMM **inconsistent**: those unconditional moments **need not be equivalent to the conditional restrictions**. **Makes the finite-grid caveat an identification issue.** *(Poirier (2017) makes the finite-but-growing choice — see I5 — so the paper has both the warning and a precedent.)*

### H8. Lavergne & Patilea (2008) — `lavergne2008` — IN BIB · Proximity **3** · TOOL
*JoE* 143(1), 103–122. Companion to H5.

### H9. Sriperumbudur et al. (2010) — `sriperumbudur2010` — NEW · Proximity **3** · TOOL
*JMLR* 11, 1517–1561. **Characteristic** kernels = injective mean embedding; **via Bochner**, shift-invariant kernels are characteristic iff the spectral measure has full support.

### H10. Gretton et al. (2012) — `gretton2012` — NEW · Proximity **4** · TOOL
*JMLR* 13, 723–773. MMD; the balancing residual is an MMD-type quantity.

### H11. Muandet et al. (2017) — `muandet2017` — NEW · Proximity **5** · BACKGROUND
*FnT ML* 10(1–2), 1–141.

### H12. Muandet, Jitkrittum & Kübler (2020) — `muandet2020` — NEW · Proximity **3** · TOOL
UAI, PMLR 124. **The modern, kernel-native Bierens device.** *Page range flagged.*

### H13. Zhang, Imaizumi, Schölkopf & Muandet (2023) — `zhang2023mmr` — NEW · Proximity **2** · PRECEDENT
*J. Causal Inference* 11(1). **The closest existing "kernel device + IV + inverse problem" paper.** **Falls short:** mean-independence ⇒ **linear** NPIV. *Page range flagged.*

### H14. Dikkala et al. (2020) — `dikkala2020` — NEW · Proximity **3** · BACKGROUND
NeurIPS 33, 12248–12262. The adversarial route.

### H15. Singh, Sahani & Gretton (2019) — `singhsahanigretton2019` — NEW · Proximity **3** · BACKGROUND
NeurIPS 32, 4595–4607. The reference RKHS-NPIV estimator.

### H16. Escanciano (2026) — `escanciano2026` — NEW (arXiv verified) · Proximity **2** · COMPETITOR (concurrency)
arXiv:2607.24382. **Our exact toolkit, different target.** **Not a scoop:** specification testing; nuisances are regressions, not ill-posed inverses. **Re-check before submission.**

### H17. Fukumizu, Bach & Jordan (2004, 2009) — `fukumizu2004`, `fukumizu2009` — NEW · Proximity **5** · BACKGROUND
*JMLR* 5, 73–99 and *AoS* 37(4), 1871–1905. *(Two keys, one entry.)*

> ### The round-1 "not written down in econometrics" claim — **WITHDRAWN**
> Both obvious sources contain the bridge: **Stinchcombe & White (1998)** (GCR = injectivity for Banach-valued families) and the **Bochner route in Sriperumbudur et al. (2010)**. **Keep the substance — one characteristic-kernel choice discharges both the identification device and the RKHS debiasing bound — as a two-sentence remark. Drop the novelty label.**

---

## Area I — Continuum of moment conditions (CGMM)

> The estimator *is* a continuum of unconditional moments indexed by $(u,t)$. **Two established routes to plan §14's open weighting question are documented here (I1 and I5); pick one deliberately rather than invent a third.**

### I1. Carrasco & Florens (2000) — `carrascoflorens2000` — NEW · Proximity **2** · TOOL
**Generalization of GMM to a Continuum of Moment Conditions.** *ET* 16(6), 797–834.
**Route 1:** the efficient weighting operator and its **regularised inverse**; the weighting measure determines the asymptotic variance. **Falls short as a competitor:** the regularisation is of the *weighting* operator, not a structural inverse.

### I2. Carrasco, Chernov, Florens & Ghysels (2007) — `carrasco2007` — IN BIB · Proximity **3** · TOOL
*JoE* 140(2), 529–573. Practical regularisation and tuning.

### I3. Carrasco, Florens & Renault (2007) — `carrasco2007h` — IN BIB · Proximity **3** · TOOL
*Handbook of Econometrics*, 5633–5751. Spectral decomposition and regularisation; the vocabulary the paper uses throughout.

### I4. Bennett & Kallus (2023) — `bennettkallus2023vmm` — NEW · Proximity **2** · COMPETITOR
**The variational method of moments.** *JRSS-B* 85(3), 810–841.
Infinitely many moments via flexible function classes while retaining efficiency. **Falls short:** linear conditional-moment problems; no ill-posed nonlinear structural operator; no panel.

### I5. Poirier's finite-growing-basis route — see **B13** · **NEW THIS ROUND, from the G-1 read**
**Route 2, and a direct precedent.** Poirier (2017) faced the identical design choice — a continuum of moments whose optimal weighting operator is ill-posed — and resolved it by **avoiding the continuum**. §1.2, verbatim: the CGMM estimator *"is efficient when the optimal weighting operator is used… More generally, this problem suffers from the ill-posed inverse problem, and a Tikhonov regularization is suggested. **By comparison, the estimator we propose uses a finite but growing number of zero-covariance conditions**."* His bases are polynomials, cubic splines and Fourier series, with dimensions $K$ and $L$.
**Relevance:** a citable, published alternative to Route 1 in exactly our setting, from the nearest competitor. His conclusion flags choosing $K$ and $L$ by **higher-order MSE expansions** (I6) as unfinished business — the lead to follow for a principled rule.

### I6. Donald, Imbens & Newey (2009) — `donaldimbensnewey2009` — NEW · Proximity **4** · TOOL
**Choosing instrumental variables in conditional moment restriction models.** *JoE* 152(1), 28–36.
Asymptotic-MSE-based criteria for instrument/moment selection in conditional moment restriction models; higher-order variance comparisons across GMM and GEL estimators.
**Relevance:** the citation Poirier points at for choosing the basis dimensions. If the paper adopts Route 2, this is where the rule for $K$ and $L$ comes from. *(Poirier cites it as "Donald et al. (2008)", presumably the working-paper version; the published version is verified here.)*

---

## Area J — Semiparametric efficiency anchors

> **BKRW (1993) and Newey (1990, 1994) are mandated by `.claude/references/domain-profile.md`.**

### J1. Chamberlain (1987) — `chamberlain1987` — NEW · Proximity **4** · TOOL
*JoE* 34(3), 305–334. **The classical anchor for the conditional half of our restriction system.**

### J2. Bickel, Klaassen, Ritov & Wellner (1993) — `bkrw1993` — NEW · Proximity **5** · TOOL
Johns Hopkins UP. Tangent spaces, efficient influence functions, adaptivity.

### J3. Newey (1990) — `newey1990` — NEW · Proximity **5** · TOOL
*JAE* 5(2), 99–135.

### J4. Newey (1994) — `newey1994var` — NEW · Proximity **4** · TOOL
*Econometrica* 62(6), 1349–1382. **How to account for nonparametric estimates of nuisance functions** — the sandwich in `thm:rootn` must carry both the $\varphi$ and the $\varrho$ corrections. *Distinct from `newey1994h`.*

### J5. Ichimura & Newey (2022) — `ichimuranewey2022` — NEW · Proximity **4** · TOOL
*QE* 13(1), 29–61. The influence function as a Gateaux derivative at a point mass — the cleanest way to present P1 to Referee B.

---

## Area K — The linear-NPIV canon

### K1. Newey & Powell (2003) — `newey2003` — IN BIB · Proximity **4** · BACKGROUND
*Econometrica* 71(5), 1565–1578. **Falls short:** linear operator; continuous instrument; no parametric component; no panel.

### K2. Hall & Horowitz (2005) — `hall2005` — IN BIB · Proximity **4** · BACKGROUND
*AoS* 33(6), 2904–2929. **Falls short:** rates for $\varphi$ only.

### K3. Blundell, Chen & Kristensen (2007) — `blundell2007` — IN BIB · Proximity **4** · BACKGROUND
*Econometrica* 75(6), 1613–1669. Sieve NPIV with a semiparametric structure and a finite-dimensional parameter — **the closest of the canon to a partially linear target**. **Falls short:** linear operator; continuous instruments; no panel; no orthogonalisation.

### K4. Darolles, Fan, Florens & Renault (2011) — `darolles2011` — IN BIB · Proximity **4** · BACKGROUND
*Econometrica* 79(5), 1541–1565. The source-condition vocabulary A2 borrows.

### K5. Horowitz (2011) — `horowitz2011` — IN BIB · Proximity **5** · BACKGROUND
*Econometrica* 79(2), 347–394. Practitioner-facing.

---

## Area L — Regularisation theory for (nonlinear) ill-posed problems

> The $\varphi$-step solves a **nonlinear** ill-posed equation, but every LF rate quoted from the companion concerns a **linear** one. Nonlinear LF convergence requires the **tangential cone condition**, unstated so far. Plan **§2.6b**; Stage 2 action.

### L1. Hanke, Neubauer & Scherzer (1995) — `hanke1995` — IN BIB · Proximity **2** · TOOL
**A convergence analysis of the Landweber iteration for nonlinear ill-posed problems.** *Numerische Mathematik* 72(1), 21–37.
The **Landweber iteration is stable for NONLINEAR ill-posed problems**: with noise level $\delta$, a **discrepancy-principle stopping rule** yields $O(\delta^{1/2})$ under the **tangential cone condition**.
**Three uses:** the honest citation for "LF converges here"; the theory behind plan §16.3's stopping rule; and **it names the condition that must be checked** (new O10). **Falls short as a competitor:** deterministic noise; no statistical operator noise, no $\theta$, no panel.

### L2. Engl, Hanke & Neubauer (2000) — `engl2000` — IN BIB · Proximity **4** · TOOL
**Regularization of Inverse Problems.** Kluwer. Source conditions, semiconvergence, stopping rules, saturation — the standard citation for the vocabulary, and specifically for the semiconvergence plan §16.3 relies on.

### L3. Chen & Reiß (2011) — `chenreiss2011` — IN BIB · Proximity **3** · TOOL
**On rate optimality for ill-posed inverse problems in econometrics.** *ET* 27(3), 497–521.
**The anchor for O9** — the framework in which "is $\sqrt n$ tight, is A2 necessary?" is properly posed. **Falls short:** linear NPIV; minimax rates for $\varphi$.

---

## Coverage summary

Counted by **BibTeX key** (H17 carries two keys; I5 is a cross-reference to B13, not a separate key).

| Area | Keys | In `instrumental.bib` | New in `references.bib` |
|---|---|---|---|
| A. Partially linear IV, $\sqrt n$ for $\theta$ | 9 | 5 | 4 |
| B. $\sqrt n$ under ill-posedness and independence | 13 | 8 | 5 |
| C. Orthogonal moments, cross-fitting, balancing/Riesz | 13 | 0 | 13 |
| D. Discrete instrument, continuous endogenous regressor | 8 | 7 | 1 |
| E. Weak-identification-robust inference | 4 | 0 | 4 |
| F. Hedonic pollution application | 5 | 2 | 3 |
| G. Panel nonparametrics / differenced integral equations | 8 | 3 | 5 |
| H. Bierens / ICM / characteristic kernels | 18 | 3 | 15 |
| I. Continuum of moments (CGMM) | 5 | 2 | 3 |
| J. Semiparametric efficiency anchors | 5 | 0 | 5 |
| K. Linear-NPIV canon | 5 | 5 | 0 |
| L. Regularisation theory | 3 | 3 | 0 |
| **Total** | **96** | **38** | **58** |

`references.bib` holds **58** entries — matching the "new" column exactly.

---

## Open items carried into Stage 2

1. **O10 — the tangential cone condition** for $T(\varphi,\theta)$. Now the top theory risk; plan §2.6b. Area L.
2. **O11 — the weighting route.** Two documented options: regularise the continuum (I1) or a finite growing basis (I5, with I6 for choosing $K$, $L$). Pick one deliberately.
3. **Fève & Florens (2014) full text** — confirm no partially linear specification and no $\sqrt n$ parametric result. **The only remaining unverified competitor claim.** G1.
4. **`deaner2025` publication status** — the only remaining `% UNVERIFIED` entry.
5. **Three page ranges** flagged: `muandet2020`, `zhang2023mmr`, `chernozhukov2022rieszznet`.
6. **`listengos1996` title wording** — likely "endogenous variables," not "regressors."
7. **For `/tools validate-bib`:** two duplicate pairs in `instrumental.bib` — `chernozhukov2007`/`newey2007`, and `chenlee2013`/`chenchernozhukovleenewey2014`.

**G-1 is closed.** The novelty verdict is **CLEAR, unconditional** — see `positioning.md` §1.
