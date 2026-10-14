# Frontier Map — Panel NPIV with a Discrete Instrument: $\sqrt{n}$ Theory for $\theta_\dagger$

**Project slug:** `panel-npiv-discrete`
**Compiled:** 2026-07-28 · Round 2 (accepted 86/100) + cleanup pass + **G-1 closure**

---

## 0. The maintained moment family (notation)

**Taken verbatim from plan §2.2.**

$$M(u,t) \;=\; E\Big[\,\widetilde W \;\cdot\; \mathbf 1\{\Delta U \le u\} \;\cdot\; w\big(t'\,\Phi(\Delta Z)\big)\Big] \;=\; 0 ,$$

for all $u$ and all $t$ in a set of positive Lebesgue measure, where

- $\widetilde W = W - \varrho(\Delta Z)$, with $\varrho(\Delta Z) = E[W\mid\Delta Z]$ a propensity score;
- $\Phi(\cdot)$ is the **bounded one-to-one transform of $\Delta Z$** (componentwise $\arctan$) required by the plan's notation contract §1;
- $w(\cdot)$ is the weight family — $\exp(\cdot)$ in Bierens (1982, 1990), but see H4 on stating this at generically-comprehensively-revealing generality instead.

**$\Phi$ acts on $\Delta Z$, not on $\Delta U$**, and it is what supplies the boundedness the Bierens lemma needs.

Three conditions travel with this display and must be numbered assumptions, not footnotes:

1. **Boundedness.** $\Phi$ exists precisely to supply it: the Bierens equivalence needs a bounded argument, and $\Delta Z$ contains income and density growth.
2. **Positive measure, not "all $t$."** The equivalence holds on any $t$-set of positive Lebesgue measure — which is what makes a finite grid tempting, and dangerous.
3. **Continuum vs finite grid is an *identification* question.** Domínguez & Lobato (2004) show an arbitrarily chosen finite family **need not be equivalent to the conditional restriction at all**. A finite subfamily is adequate only at the cost of an explicit approximation term. **Poirier (2017) makes the same finite-but-growing choice and is a precedent for it** — see §2.8.

---

## 1. The frontier in one diagram

```
                       OPERATOR IS LINEAR                OPERATOR IS NONLINEAR
                    (mean independence E[U|W]=0)      (full/conditional independence)
                  ┌──────────────────────────────┬──────────────────────────────────┐
                  │                              │                                  │
  RATES FOR THE   │  Newey–Powell 2003           │  Dunker–Florens–Hohage–           │
  NONPARAMETRIC   │  Hall–Horowitz 2005          │    Johannes–Mammen 2014           │
  FUNCTION φ      │  Blundell–Chen–Kristensen'07 │  Centorrino–Fève–Florens 2025     │
                  │  Darolles et al. 2011        │  Loh 2023                         │
                  │  Horowitz 2011               │                                   │
                  │  Chen–Christensen 2018       │  Hanke–Neubauer–Scherzer 1995     │
                  │  Chen–Reiß 2011 (optimality) │    (LF for NONLINEAR ill-posed;   │
                  │  Fève–Florens 2014 (PANEL)   │     tangential cone condition)    │
                  │  Florens–Lapenta 2024        │                                   │
                  │  Singh–Sahani–Gretton 2019   │  De Monte 2024 (panel, but        │
                  │                              │    linear operator)               │
                  │        ══ SETTLED ══         │        ══ SETTLED ══              │
                  ├──────────────────────────────┼──────────────────────────────────┤
                  │                              │                                  │
  √n THEORY FOR   │  Severini–Tripathi 2006,2012 │                                   │
  A FINITE-DIM    │  Ai–Chen 2003, 2012          │            EMPTY                  │
  PARAMETER OR    │  Chamberlain 1987            │                                   │
  FUNCTIONAL      │  Chen–Pouzo 2012, 2015       │      ◀── THIS PAPER ──▶           │
                  │  Florens–Johannes–            │                                   │
                  │    Van Bellegem 2012         │   ← Poirier (2017, §5) names this  │
                  │  Q. Chen 2021                │     cell as his open extension     │
                  │  Bennett et al. 2023, 2026   │                                   │
                  │  Bakhitov 2026               │                                   │
                  │  Poirier 2017 (INDEPENDENCE, │                                   │
                  │    WELL-POSED nuisance —     │                                   │
                  │    VERIFIED by direct read)  │                                   │
                  │  Carrasco–Florens 2000 (CGMM)│                                   │
                  │        ══ SETTLED ══         │                                   │
                  └──────────────────────────────┴──────────────────────────────────┘
```

Two entries straddle the boundary and are handled explicitly:

- **Poirier (2017)** — independence restrictions (conditional and unconditional) and finite-dimensional parameters, with a **well-posed** nuisance estimated by a finite-but-growing set of zero-covariance conditions. **Verified by direct read of the full text**: the IV example is a *linear* IV model, the partially linear example has an *exogenous* nonparametric argument, and the Monte Carlo is fully linear. Placed left because that is where its mathematics lives. **And in §5 he names the nonparametric-nuisance case — this paper's cell — as an open extension.**
- **Fève & Florens (2014)** — *panel* models by *first differences* with *endogenous variables* under an IV condition, but as a **linear** inverse problem solved by Tikhonov. The paper to distinguish most carefully on the panel axis.

Two further coordinates:

- **Panel / first-differenced structure.** Studied under exogeneity (Su & Lu 2013, well-posed second-kind Fredholm), under endogeneity with a *linear* inverse problem (Fève & Florens 2014), and with a linear NPIV operator plus two-way fixed effects (De Monte 2024). Never with a nonlinear operator.
- **Discrete (binary) instrument.** Identification settled (D'Haultfœuille–Février 2015; Torgovitsky 2015; Loh 2023); estimation of $\varphi$ alone settled (Centorrino–Fève–Florens 2025). No $\sqrt{n}$ theory for any parametric component in this branch.

---

## 2. What is settled

### 2.1 $\sqrt{n}$ estimation of a parametric component in a *linear* ill-posed problem — fully settled

$\sqrt{n}$-estimability of $\langle\nu,\varphi\rangle$ requires $\nu\in\mathcal{R}(T^\ast)$ (Severini & Tripathi 2006); the bound is finite exactly under that condition (Severini & Tripathi 2012); sieve estimators attain it (Ai & Chen 2003; Chen & Pouzo 2012, 2015); the regular/irregular line is characterised (Chen & Christensen 2018; Escanciano 2022); the partially linear case is done twice (Florens, Johannes & Van Bellegem 2012 by Tikhonov; Florens & Lapenta 2024 by LF), including under failure of completeness (Q. Chen 2021; Babii & Florens 2025).

**Verification:** forward sweep of Severini & Tripathi (2012), 32 papers since 2019, all **linear** conditional-moment operators.

### 2.2 Estimating $\varphi$ under a *nonlinear* operator equation — settled

Dunker, Florens, Hohage, Johannes & Mammen (2014) give rates for regularised Newton-type iterations. Centorrino, Fève & Florens (2025) give the LF route with a discrete instrument, including $\mathcal{A}$, $\mathcal{A}^\ast$, a source condition, conditional completeness, and an MISE bound. **Neither produces a $\sqrt{n}$ result for any finite-dimensional object; neither has a parametric component.**

### 2.3 Panel models with endogenous variables as inverse problems — settled in the LINEAR case

**Fève & Florens (2014), JoE 181(2), 151–164** estimate panel data models **by first differences** with **endogenous variables** under an **IV condition**; the framework "leads to the resolution of **linear inverse problems**," solved by **Tikhonov** with an $L^2$ or Sobolev penalty. **De Monte (2024)** adds two-way fixed effects and swaps Tikhonov for LF, still linear, no parametric component. **Su & Lu (2013)** give the exogenous case — a *well-posed second-kind* Fredholm equation.

> **Verification note.** The linear/Tikhonov characterisation is confirmed from published descriptions. The absence of a partially linear specification and of a $\sqrt n$ parametric result is inferred; full text not obtained (ScienceDirect 403). **This is now the only unverified competitor claim in the deliverables.** Confirm before the introduction is finalised.

### 2.4 Identification with a discrete instrument — settled

D'Haultfœuille & Février (2015) and Torgovitsky (2015) point-identify a nonseparable model with a binary or small-support instrument under independence. Loh (2023) maps the boundary for discrete regressors. Torgovitsky (2017) and Manski (1983) give minimum-distance-from-independence estimators. Discreteness is no obstacle to identification; it is an obstacle to *method*.

### 2.5 Efficiency under independence restrictions — settled for well-posed problems, **VERIFIED**

**Poirier (2017), JoE 196(1), 1–22** computes the semiparametric efficiency bound for finite-dimensional parameters under **unconditional and conditional independence restrictions** and gives a consistent, asymptotically normal, efficient estimator built on **a finite but growing number of zero-covariance conditions** asymptotically equivalent to the independence restriction. **The right primary citation for `prp:effbound`.**

**Verified by direct read of the full text** (working-paper PDF, metadata title matching the published title, 22 pages matching JoE 196(1), 1–22):

- **Example 1.2 (Instrumental Variables Regression):** $Y = X'\theta_0 + U$, $U \perp Z$ — *"a linear IV model with independent errors."* Fully parametric.
- **Example 1.5 (Partially Linear Regression):** $Y = X\theta_0 + G_0(W,\varepsilon)$ with $\varepsilon \perp (X,W)$ — the nonparametric argument $W$ is **exogenous**. A generalization of Robinson (1988) allowing the marginal effect to vary across observationally equivalent units, attributed to **Santos (2011)**.
- **Monte Carlo (§4):** Card (1999) returns-to-schooling with a binary instrument and endogenous schooling, but $Y = X\theta_0 + U$ — linear.

**Every nonparametric object in the paper is a function of exogenous variables or an error distribution. There is no structural inverse and no ill-posedness.** He mentions ill-posedness once, in §1.2, only to explain that his construction **avoids** it, and there it concerns the *weighting operator* of a CGMM estimator, not a structural nuisance.

**And in §5 he names this paper's cell as his open extension:** *"…to generalize our results to models with unconditional independence restriction with nuisance functions of the type $\rho(Y, X, \theta, h(\cdot)) \perp Z$, where $h(\cdot)$ is a nonparametric object."* (He writes *unconditional*; this paper maintains the *conditional* form — the closest available statement of the gap, not a literal description.)

The classical anchors behind the bound — **Chamberlain (1987)**, **BKRW (1993)**, **Newey (1990, 1994)**, **Ichimura & Newey (2022)** — are mandated by `.claude/references/domain-profile.md`.

### 2.6 Orthogonal moments and cross-fitting — settled as a recipe

Chernozhukov et al. (2018) established the recipe; Chernozhukov, Escanciano, Ichimura, Newey & Robins (2022) generalised the correction to first steps defined by conditional moment restrictions; Chernozhukov, Newey & Singh (2022a, 2022b) made it *learnable* without a closed form. **Not standard: applying it when the nuisance solves an ill-posed nonlinear operator equation via a regularised iteration with a data-driven stopping rule.**

### 2.7 Balancing / Riesz-representer estimation — settled as a toolkit

Zubizarreta (2015), Athey, Imbens & Wager (2018), Hirshberg & Wager (2021), Singh (2021/2024) and Bruns-Smith et al. (2026). Singh gives the RKHS/kernel-ridge form with misspecification guarantees — the form the amended estimator uses.

### 2.8 Continuum-of-moments estimation (CGMM) — settled, and it is the theory for our estimating equations

- **Carrasco & Florens (2000), *ET* 16(6), 797–834.** **Efficient weighting of a continuum requires a regularised inverse of the covariance operator**, and the **weighting measure governs efficiency**.
- **Carrasco, Chernov, Florens & Ghysels (2007), *JoE* 140(2), 529–573** — `carrasco2007`. Practical regularisation choices.
- **Carrasco, Florens & Renault (2007), Handbook**, 5633–5751 — `carrasco2007h`. The reference treatment of spectral decomposition and regularisation.
- **Bennett & Kallus (2023), JRSS-B 85(3), 810–841.** The adversarial route to infinitely many moments.

**Two routes to plan §14's open $\mu$ question, and both are now documented.** Plan §14 asks how to choose $w$, $\Phi$, $\mathcal{T}$ and $\mu$. There are two established answers, and the paper should pick one deliberately rather than invent a third:

1. **Regularise the continuum.** Carrasco–Florens: use the optimal weighting operator with a regularised (Tikhonov) inverse. The weighting measure is not a free tuning choice — it determines the asymptotic variance.
2. **Avoid the continuum's ill-posedness with a finite but growing basis.** **This is Poirier's (2017) choice, faced with the identical design problem.** In §1.2 he notes the CGMM route "suffers from the ill-posed inverse problem, and a Tikhonov regularization is suggested," then writes: *"By comparison, the estimator we propose uses a finite but growing number of zero-covariance conditions."* His bases are polynomials, cubic splines and Fourier series, with dimensions $K$ and $L$. His conclusion flags choosing $K$ and $L$ by **higher-order MSE expansions**, citing **Donald, Imbens & Newey**, as unfinished business — which is the lead to follow if the paper wants a principled rule.

Florens coauthors all three CGMM references and Poirier published in the same journal, so Referee A and Referee B will each expect one of these two routes to be named and adopted.

### 2.9 Conditional-to-unconditional moment devices — settled, in two literatures

**Econometrics.** Bierens (1982, 1990); Bierens & Ploberger (1997) for ICM limit theory; Stinchcombe & White (1998) for GCR families; Escanciano (2006) for the projection form; Fan & Li (2000) for ICM vs kernel-smoothing tests; **Domínguez & Lobato (2004)** for the fact that the choice of family affects **identification**; Lavergne & Patilea (2008); **Poirier (2017)** for the independence analogue and for the finite-growing-basis resolution.

**Machine learning.** Sriperumbudur et al. (2010) — characteristic kernels are exactly those with injective mean embedding, and **via Bochner's theorem** a shift-invariant kernel is characteristic iff its spectral measure has full support. Gretton et al. (2012); Muandet, Jitkrittum & Kübler (2020); Zhang et al. (2023); Dikkala et al. (2020); Singh, Sahani & Gretton (2019).

**The bridge is already public.** Round 1's claim that the Bierens ≡ characteristic-kernel identity had not been stated in econometrics is **withdrawn**. Keep the *convenience* — one characteristic-kernel choice discharges both the identification device and the RKHS debiasing bound — and drop the novelty label.

### 2.10 Regularisation theory for ill-posed problems — settled, and the LINEAR/NONLINEAR distinction is load-bearing

All three are already in `instrumental.bib`.

- **Hanke, Neubauer & Scherzer (1995), *Numer. Math.* 72(1), 21–37** — `hanke1995`. The **Landweber iteration is stable for NONLINEAR ill-posed problems**, with a discrepancy-principle stopping rule yielding rate $O(\delta^{1/2})$ under the **tangential cone condition**.
- **Engl, Hanke & Neubauer (2000)** — `engl2000`. Source conditions, semiconvergence, stopping rules, saturation.
- **Chen & Reiß (2011), *ET* 27(3), 497–521** — `chenreiss2011`. Rate optimality for ill-posed inverse problems in econometrics — **the anchor for O9**.

> **Why this is more than coverage.** The $\varphi$-step solves a **nonlinear** ill-posed equation, whereas every LF rate quoted from the companion concerns a **linear** one. Nonlinear LF convergence requires the **tangential cone condition**, which nobody on this project has stated, let alone verified for $T(\varphi,\theta)$. Plan **§2.6b**; Stage 2 action for the theorist. It also repairs an unsupported claim: `positioning.md` §4's "LF semiconvergence gives a clean stopping rule" now points at `hanke1995` and `engl2000`.

---

## 3. What is open

| # | Open question | Status |
|---|---|---|
| **O1** | **$\sqrt{n}$ estimation of a finite-dimensional parameter when the nuisance solves an ill-posed *nonlinear* operator equation.** | **Open. This is the paper — and the nearest competitor says so.** Poirier (2017, §5) names models with independence restrictions and a nonparametric nuisance $h(\cdot)$ as his open extension. Dunker et al. (2014) and Hanke et al. (1995) do the nonlinear-operator half with no parametric component; Fève & Florens (2014) the panel half with a linear operator. |
| **O2** | Partially linear structure in a *panel* with a nonparametric function of an endogenous regressor and a **discrete** instrument. | Open — **stated against Fève & Florens (2014), not around it.** Absent there: nonlinearity of the operator, the discrete instrument, and a $\sqrt n$ parametric component. |
| **O3** | What replaces Robinson-style partialling out when no exact $\varphi$-free moment exists. | Open. Remark R2 gives the exact characterisation and the negative conclusion. **Publishable content in itself.** |
| **O4** | The right source condition for $\theta$ when $\mathcal{A}$ is a Fréchet derivative that depends on the unknown $\varphi$. | Open. The *self-referential* character of $\mathcal{A}=T'_{\vdagger,\theta_\dagger}$ has no precedent in the $\sqrt n$-functional literature. |
| **O5** | Whether the empirical balancing residual, not the population adjoint residual, is the right object to control. | **Settled negatively by the project's own numerics; open theoretically.** Known for regressions; undocumented for an ill-posed nonlinear operator. |
| **O6** | Bierens/characteristic-kernel devices used to avoid smoothing in the conditioning variable **of a model whose nuisance is an ill-posed inverse problem.** | Open, **and now precisely bounded.** Poirier (2017) uses a growing unconditional family for *estimation* under independence — verified, with a well-posed nuisance. Carrasco–Florens (2000) build the general CGMM theory. Domínguez–Lobato (2004) and Lavergne–Patilea (2008) address identification and dimension. What remains open is only the combination with an **ill-posed nonlinear structural nuisance**. |
| **O7** | ~~Bierens ≡ characteristic kernel stated in econometrics.~~ | **CLOSED — claim withdrawn.** Retain as a two-sentence expository remark, not a contribution. |
| **O8** | Semiparametric efficiency bound for $\theta_\dagger$ under *conditional independence* when the co-nuisance is **ill-posed**, $\varrho$ is estimated, and the moment family is a **continuum** — and whether the orthogonal moment attains it. | Open, well-anchored: **Poirier (2017)** for the independence bound with a well-posed nuisance, Chamberlain (1987), Ai & Chen (2012), Carrasco & Florens (2000), Severini & Tripathi (2012), BKRW (1993), Newey (1990, 1994), Ichimura & Newey (2022). This is `prp:effbound`. |
| **O9** | Minimax lower bound — is $\sqrt n$ tight, and is A2 necessary as well as sufficient? | Open, declared open. **Chen & Reiß (2011)** supplies the framework. Necessity proved in the linear case only. |
| **O10** | **Does the tangential cone condition hold for $T(\varphi,\theta)$?** | Open. LF convergence for a **nonlinear** ill-posed problem requires it (Hanke, Neubauer & Scherzer 1995); the companion's rates are for the linear case. **Now the top theory risk.** Plan §2.6b. |
| **O11** | **How to choose the weighting measure / basis dimensions for the continuum.** | Open in the plan (§14), but **two established routes now documented** (§2.8): regularise the continuum (Carrasco–Florens), or use a finite growing basis (Poirier), with Donald–Imbens–Newey for choosing $K$ and $L$ by higher-order MSE. Pick one deliberately. |

---

## 4. Precisely where this paper sits

**The paper occupies O1, O2, O3, O5, O6 and O8 simultaneously**, and inherits O9, O10 and O11 as conditions to discharge.

> This is the first $\sqrt{n}$-consistency and asymptotic-normality result for a finite-dimensional structural parameter in a model whose nonparametric nuisance is the solution to an **ill-posed nonlinear** operator equation generated by a **distributional (independence)** restriction with a **binary** instrument, in a **first-differenced panel** where the nuisance enters as a difference $\varphi(X_2)-\varphi(X_1)$, with the conditioning variable handled by a **Bierens / characteristic-kernel** device so that nothing is smoothed nonparametrically in $\Delta Z$, and with the debiasing weight obtained by **RKHS balancing in sample** rather than by inverting the population adjoint.

| Clause | Who gets closest | Where they stop |
|---|---|---|
| $\sqrt n$ for a parametric component in a partially linear IV model | Florens–Johannes–Van Bellegem (2012); Florens–Lapenta (2024); Q. Chen (2021) | Linear conditional-mean operator; no panel; no independence restriction |
| $\sqrt n$ for a parameter under an **independence** restriction, with an efficiency bound | **Poirier (2017)** | **Well-posed nuisance — verified.** Every nonparametric object is a function of exogenous variables or an error distribution; no structural inverse. Finite-growing-basis GMM, not regularised inversion. No panel, no discrete instrument. **He names our case as his open extension.** |
| **Panel, first differences, endogenous, inverse problem** | **Fève & Florens (2014)** | **Linear** inverse problem solved by Tikhonov; no parametric component at $\sqrt n$; no discrete instrument; no orthogonalisation |
| $\sqrt n$ for a functional when the nuisance is ill-posed | Severini–Tripathi (2006, 2012); Chen–Pouzo (2015); Bennett et al. (2026) | Linear operator; target is a functional of the nuisance, not a separate structural parameter |
| Nonlinear operator from an independence restriction | Dunker et al. (2014); Centorrino–Fève–Florens (2025) | Rates for $\varphi$ only; no parametric component; no $\sqrt n$ anywhere |
| **LF convergence on a NONLINEAR ill-posed problem** | **Hanke, Neubauer & Scherzer (1995)** | Numerical-analysis result: stability and $O(\delta^{1/2})$ under the tangential cone condition, deterministic noise. No statistical operator noise, no $\theta$, no panel |
| **Rate optimality for ill-posed problems in econometrics** | **Chen & Reiß (2011)** | Linear NPIV; minimax rates for $\varphi$, not for a finite-dimensional parameter under a nonlinear operator |
| Panel + LF | De Monte (2024) | Fully nonparametric; linear NPIV operator |
| Panel + first-differenced integral equation, exogenous | Su & Lu (2013) | Exogenous $X$; well-posed second-kind equation |
| Orthogonal moment + cross-fitting | Chernozhukov et al. (2018, 2022) | Nuisances are regressions, not regularised inverses of nonlinear operators |
| Balancing / Riesz in RKHS | Singh (2021/2024); Hirshberg–Wager (2021); Athey–Imbens–Wager (2018) | Primal object is a regression, not a regularised inverse; no ill-posedness |
| **Continuum of unconditional moments, efficient weighting** | **Carrasco & Florens (2000)**; Carrasco et al. (2007); Bennett & Kallus (2023); **Poirier (2017)** | The regularised inverse is of the *weighting* operator, not of a structural inverse; no panel; no distributional restriction on a nonparametric $\varphi$ |
| Bierens / characteristic-kernel device | Bierens (1990); Escanciano (2006, 2026); Domínguez–Lobato (2004); **Poirier (2017)**; Muandet et al. (2020); Zhang et al. (2023) | Testing, or estimation with a **well-posed** nuisance; never with an ill-posed nonlinear one |

---

## 5. Concurrency map

**All five 2026 arXiv entries were fetched directly from arXiv on 2026-07-28 and confirmed to exist.**

| Rank | Paper | Date | Risk | Why |
|---|---|---|---|---|
| 1 | **Escanciano, *Locally Robust Kernel Specification Tests for CMR*** (arXiv:2607.24382) — **VERIFIED** | 27 Jul 2026 | **Elevated** | Exactly our tool combination. Confirmed abstract: target is a **specification test**; applications are high-dimensional linear/logistic regression, ML significance testing, constant-CTE tests, NSW data. No NPIV, no ill-posed nuisance, no panel, no discrete instrument. **Re-check before submission.** |
| 2 | **Bakhitov** (arXiv:2603.29889) — **VERIFIED** | Mar/Apr 2026 | Moderate | NPIV + automatic debiasing + $\sqrt n$ functionals. Missing the nonlinear operator, the panel and the discrete instrument. |
| 3 | **Girard & Lapenta** (arXiv:2604.11393) — **VERIFIED** | 13 Apr 2026 | Moderate | Same Toulouse/CREST lineage; RKHS; one regularisation parameter; partially linear IV. Still the linear conditional-mean operator. |
| 4 | **Bennett, Kallus, Mao, Newey, Syrgkanis & Uehara**, JRSS-B 88(3), 998–1028 | online Dec 2025, print Jul 2026 | Moderate | The most sophisticated existing $\sqrt n$-functional-under-ill-posedness result. Linear operator only. **A nonlinear extension by this group is the single most plausible route to being scooped.** |
| 5 | **Poirier (2017), JoE 196(1)** — **G-1 CLOSED** | 2017 | **Low as a competitor; moderate as an invitation** | Verified: no overlap. **But his §5 explicitly names the nonparametric-nuisance extension as the natural next step, in a JoE paper with ten citations.** Others can read that too. Reinforces "submit promptly." |
| 6 | **Shen, Kallus, Meunier, Zenati, Gretton & Bibaut** (arXiv:2604.24660) — **VERIFIED** | Apr/May 2026 | Low–moderate | Functionals of inverse problems *with no exact solution*. Adjacent, not overlapping. Same group as #4. |
| 7 | **Baiardi, Clarke, Naghi & Polselli** (arXiv:2603.20464) — **VERIFIED** | 20 Mar 2026 | Low | Panel IV DML; nuisances are ordinary conditional expectations, treatment enters linearly. Useful diagnostic template for plan §9.2 item 3. |
| 8 | **Centorrino, Fève & Florens**, JoE 247 (2025) | 2025 | Low — **this is the companion** | OpenAlex reports 0 citations on both records, but this is a single-source count from a database with known merge failures. **Round 1's use of "zero citations" as affirmative novelty evidence is withdrawn.** No *specific* extension surfaced. |

**Assessment of the window:** open, but narrowing. The specific combination is unoccupied and now verified unoccupied on the independence axis. But three of four ingredients are being actively assembled by two well-resourced groups in 2026 alone, and the nearest competitor has publicly flagged the gap. Prudent reading: **12–24 months, not 3 years.**

---

## 6. Gaps in the *project's* literature infrastructure

1. **The DML / orthogonal-moment / Riesz literature is entirely absent from `instrumental.bib`.** Supplied in `references.bib` (13 entries).
2. **The weak-identification-robust literature is entirely absent.** Stock & Wright (2000) missing; `kleibergen2006` is Kleibergen–Paap's rank test; `andrews2011` is Andrews (2017). **Blocks plan §9.2 until added.**
3. **The Bierens/ICM extensions are absent** — Bierens–Ploberger (1997), Stinchcombe–White (1998), Escanciano (2006), Fan–Li (2000), Domínguez–Lobato (2004), plus the kernel-embedding literature. Supplied.
4. **The domain-profile-mandated efficiency anchors are absent** — Chamberlain (1987), BKRW (1993), Newey (1990, 1994). Only `newey1994h` (a different work) was present. Supplied, with Ichimura & Newey (2022).
5. **Carrasco & Florens (2000) and Donald, Imbens & Newey (2009) are in neither bibliography.** Both supplied. `carrasco2007` and `carrasco2007h` *are* present and were unused in round 1.
6. **Nine entries already in the bibliography were uncited before this stage and are now used:** `feve2014`, `carrasco2007`, `carrasco2007h`, `lavergne2008`, `centorrinoflorens2021`, `centorrino2017`, `hanke1995`, `engl2000`, `chenreiss2011`. Plus the linear-NPIV canon: `newey2003`, `hall2005`, `darolles2011`, `blundell2007`, `horowitz2011`. And `poirier2017` and `santos2011`, both present and both now load-bearing.
7. **Four keys mislead on year/version** (entries otherwise correct; renaming optional): `florens2006` → EctJ 2012; `chen2012b` → Ecta 2015; `chenchristensen2015` → QE 2018; `centorrinofeveflorens2019` → JoE 2025.
8. **`babii2017a` is a superseded mimeo** — now Babii & Florens, *ET* 41(6), 1284–1321 (2025).
9. **Remaining `% UNVERIFIED` items:** `deaner2025` (publication status); page ranges for `muandet2020`, `zhang2023mmr`, `chernozhukov2022rieszznet`; title wording for `listengos1996`.
10. **`instrumental.bib` contains two duplicate pairs** — for `/tools validate-bib`, not edited here:
    - `chernozhukov2007` / `newey2007` — both Chernozhukov, Imbens & Newey.
    - `chenlee2013` / `chenchernozhukovleenewey2014` — both Chen, Chernozhukov, Lee & Newey, *Econometrica* 82(2), 785–809, 2014.
