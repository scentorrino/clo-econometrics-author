# Proof-Strategy Memo — `panel-npiv-discrete`

**Project slug:** `panel-npiv-discrete`
**PROJECT_TYPE:** theory · **Mode:** proof-strategy (`/strategize theory`, Stage 2 of `quality_reports/plans/2026-07-28_panel-npiv-direct-theta.md`)
**Date:** 2026-07-28 · **Revision:** Round 3, closing pass (R1 65/100, R2 69/100; review at `proof_strategy_memo_review.md`)
**Author agent:** strategist · **Paired critic:** strategist-critic
**Scope:** all targets of plan §2.7 plus two new ones, one memo, one architecture.

> **What this document is.** A scoping contract for the theorist. No proofs, no theorem statements — those
> come from `/prove` and `/conjecture` Step 4. It contains the shared architecture, the lemmas the proofs
> need, the places where the programme is genuinely at risk, and the weaker claims to retreat to.
>
> **What this document is not.** Not an amendment to plan §2. Gaps found in the settled analysis are
> recorded in **§9, the escalation register**, and left for the user. Plan **§19** records three user
> decisions now in force; they are implemented here, not re-litigated.

---

## Round 3 changelog

| # | Round-2 position | Round-3 position | Driver |
|---|---|---|---|
| **1** | Three-rung ladder; `thm:rootn` scoped at Q-c2; risk downgraded. | **Q-c1 and Q-c2 WITHDRAWN — the conditions are empty, not strong.** §3.5 rewritten as a **sharpness result**: $\sup_{\|h\|\le\delta}\lvert Q(h)\rvert=\tfrac12\delta^2\lVert\mathcal B_{\rm sym}\rVert\ge\tfrac12\delta^2\lVert M/\pi\rVert_\infty>0$. **Scope reverts to plan §2.6**: $\sqrt n$ under mild ill-posedness with $s>a+\tfrac12$; unavailable under severe. **§9 item 1 is withdrawn — do not amend plan §2.6 with the ladder.** | C-3 |
| **2** | Q-c2's bound followed from A2″(2). | **It does not.** Douglas yields $\lambda'\lVert h\rVert\lVert\mathcal A^\ast\mathcal Ah\rVert$, which runs the wrong way; the delivering condition would be the **form** inequality $\mathcal B_{\rm sym}\preceq\lambda'\mathcal A^\ast\mathcal A$. Independently fatal. | M-6 |
| **3** | Lever 1 aimed at $\lVert\partial_u\ell_\star\rVert_\infty$. | **Re-aimed at $M$.** The selection question is now: does some $\ell_\star\in\ell_\dagger+\ker\mathcal A^\ast$ give $M\equiv0$ (or $q\equiv0$)? Posed as a linear feasibility problem in §3.5; **recorded as open with a specified test**, and valuable even when infeasible because it minimises the *sharp constant*. L-16, O-15, SG-15 re-aimed. | C-3(3), min. 1 |
| **4** | Lever 2 (trace) buys something on the variance half. | **Withdrawn.** $\mathcal Q=m\cdot+$compact, so $\operatorname{tr}(\mathcal Q\Sigma_v)$ contains $\int M\Sigma_v(x,x)dx$, which high-frequency noise does not shrink. **The stopping-rule change loses this justification** — but survives on two independent ones. | C-3(2), m-18 |
| **5** | A2″ = transplant of source-condition double robustness. | **WITHDRAWN.** SCDR is disjunctive on a **cross-product**; my own §2.6 inheritance argument is exactly why it does not transplant to a **square**. No precedent offered — and the absence of one is itself weak evidence for the sharpness result. | M-9 |
| **6** | $\hat\delta_n$ smooths in $(x_1,x_2,u)$; order-8 kernels "buy" $o(n^{-1/4})$. | **Dimension count corrected.** $T(\varphi)(u,t)$ is an *unconditional* expectation: one-dimensional smoothing in the residual direction only; the conditional density is analytical. **The binding component is $\hat\varrho$ in $\dim(\Delta Z)$** — costed for the first time in §3.3 Step 1b. Order-8 "coherence" claim **withdrawn**; SG-20 repaired and split. | M-8, m-10 |
| **7** | Leg 3 delivered by the GC/Donsker distinction. | **Half-delivered; now closed properly** by L-19 — a **uniform LLN with a rate over a slowly growing ball containing the LF path**, plus a narrowed restatement that concedes an entropy bound is used and says precisely which. | M-1 |
| **8** | DP cited to `hanke1995`. | **Noise model corrected.** `hanke1995` assumes an exactly known operator with noisy data; here the noise is in the **operator**, so the TCC must hold for a *random* operator (Dunker et al. 2014 — upgraded from IRGN fallback to the noise model) and $\hat\delta_n$ must dominate the true level w.p.$\to$1 or the rule never stops. Two new numbered conditions. | M-7 |
| **9** | Item 3 (balancing norm) escalated, priced incompletely. | **DECIDED by the user (plan §19.1): sieve / $L^2$ dual pairing.** Priced in rate terms in §3.7: bias $=O_P(n^{-1/2}\delta_n)+O_P(L_x^{-s})$, requiring $n^{1/(2s)}\ll L_x$, feasible iff $s>1$. | §19.1, item 3 |
| **10** | Stopping rule escalated. | **DECIDED (plan §19.2): discrepancy principle**, superseding plan §16.3. | §19.2 |
| **11** | Strict inclusion escalated; Jensen→Douglas→Picard route given. | **DECIDED (plan §19.3): dropped (F4).** Unconditional framing kept as *motivation only*, with an explicit heuristic caveat. Route retained in §3.6 in case the position changes. | §19.3 |

**What survives round 3 intact**, per the review's own credit list: the §0.1 $\nu_g$ identity and its extension
to $Q(h)$ (algebra verified); the constants-annihilation rebuttal of C-1; **O-11 — the impossibility result
*is* the origin of the quadratic remainder**; the T4 withdrawal and the plan §12 knock-on; the $\kappa_n$
withdrawal; the deterministic core of the DP argument; Jensen→Douglas→Picard in §3.6; O-14 and the
withdrawal of my own anti-CGMM argument; L-13, L-14, L-16, L-17; the leg-2 restatement; SG-7's
pre-registered criterion; the $\ell_\star$/$\ell_\dagger$ convention; F3+F4 for `prp:effbound`.

---

## Pre-Strategy Report

**Date:** 2026-07-28 · **Project:** panel-npiv-discrete

### Inputs read

| Input | Path | Status |
|---|---|---|
| Binding plan | `quality_reports/plans/2026-07-28_panel-npiv-direct-theta.md` | **READ in full.** §§1–2 binding; §17 the user-directed rewrite; §2.6b the post-Stage-1 gap; §15, §16 implementation amendments. **Round 3: §2.6 corrected by the coordinator; §9 item 1 NOT executed; §19 records three user decisions, implemented here.** |
| Strategist-critic review (round 2) | `.../proof_strategy_memo_review.md` | **READ in full.** 69/100; supersedes the round-1 file. C-3 critical; M-1, M-6…M-9; m-9…m-18. Disposition table at Appendix A. |
| Literature — positioning, frontier map, bibliography, references | `quality_reports/literature/panel-npiv-discrete/` | **READ.** Novelty CLEAR; competitor analysis §3 binding; O1–O10 adopted. |
| House style | `.claude/references/{theorem-environment-style,asymptotic-conventions,proof-style}.md` | **READ.** Two-sentence form; assumptions by tag; convergence modes qualified; banned filler list. |
| Domain profile | `.claude/references/domain-profile.md` | **READ.** Per-project anchor table empty — generic defaults apply. |
| Source draft | `…/Nonparametric_Panel/Centorrino_panel.qmd` | **READ** (`:60–210`, `:280–305`). Operator `:93`; derivative `:96–103`, `:124–126`; adjoint `:172–177`; `assapp1`–`assapp5` `:280–305`. |
| Implementation | `scripts/R/orthogonal_theta.R`, `scripts/R/lf_panel.R` | **READ (targeted).** Balancing solve `:197` is a Tikhonov inversion (O-14); Gaussian kernels `:157`, `:190`; analytic primitive `:174–177`; LF stopping `lf_panel.R:375–377`; sieve form described at `:120–127` — **reinstated as current by §19.1.** |
| Data assessment | — | **NOT APPLICABLE** (theory project). Estimation sample resolved at plan §14 Q1. |

### Research question

Under what conditions is $\theta_\dagger$ in a first-differenced partially linear panel model
$\sqrt n$-estimable when the endogenous regressor is continuous, the only instrument is binary, and the
nonparametric component therefore solves an ill-posed **nonlinear** operator equation generated by a
**conditional independence** restriction?

### Key findings from the literature that bind this memo

Unchanged from round 2: the frontier cell is empty (O1, O2, O3, O5, O6, O8); Poirier names this setting as
his open extension but writes *unconditional* independence (hard constraint); Poirier's finite-growing-basis
precedent, to which positioning §2 already commits; Chen & Pouzo must be answered by the architecture, not
asserted away; nonlinear LF is not free (`hanke1995`, `engl2000`); Khan & Tamer anchors irregular
identification; Carrasco–Florens governs efficient weighting and Domínguez–Lobato makes the finite-grid
question an identification question.

### Candidate proof architectures considered

1. **Cross-fitted Neyman-orthogonal Z-estimation with an operator-theoretic bias analysis.** *Selected.*
2. **Penalised sieve minimum distance (Chen–Pouzo).** *Rejected*; a positioning commitment (§3.1, §3.4).
3. **Regularised Newton / IRGN (Dunker et al. 2014).** *Rejected as the regulariser*, but **its noise model —
   noise in the operator — is adopted** (M-7). This is a round-3 change: Dunker et al. is no longer only a
   fallback, it is the setting `prp:phirate` must be proved in.
4. **CGMM with a regularised optimal weighting operator.** *Rejected as the estimation route*; the surviving
   argument is in §3.2 and is not the one round 1 gave.

### Missing inputs

- **None blocking.** Data assessment absent by design.
- **One unverified literature claim carried forward:** Fève & Florens (2014) has no partially linear
  specification and no $\sqrt n$ result — inferred, not read. One introduction sentence; no proof.

Proceeding to strategy design.

---

## 0. Architecture in one page

### 0.1 The organising identity, and its limit

For any integrable $g$,
$$\nu_g(x) := E[g\mid X_2=x]f_{X_2}(x) - E[g\mid X_1=x]f_{X_1}(x),\qquad
E\big[g\,\Delta\phi\big] = \langle\nu_g,\phi\rangle,$$
with $\Delta$ the period-difference operator $\phi\mapsto\phi(X_2)-\phi(X_1)$ and $\nu=\nu_{\Delta Z}$.
**Round 3 adds the companion functional, which is where the programme's limit lives:**
$$\sigma_g(x) := E[g\mid X_2=x]f_{X_2}(x) \;\textbf{+}\; E[g\mid X_1=x]f_{X_1}(x).$$

| Object | In $\nu_g$ / $\sigma_g$ language |
|---|---|
| `rem:nophifree` | For $(W,\Delta Z)$-measurable $g$: a $\varphi$-free moment exists iff $\nu_g\equiv0$. |
| `lem:adjoint` | $\mathcal A^\ast_{\mathrm{cond}}\ell = \nu_{\widetilde W\ell}$. |
| `prp:orthog` (i) | Orthogonality in $\varphi$ $\iff$ $\nu_{\Delta Z+\widetilde W\ell}\equiv0$. |
| A2 | $\nu_{\Delta Z}\in\mathcal R(\mathcal A^\ast_{\mathrm{cond}})$; equivalently $\nu_{\Delta Z}\perp\ker\mathcal A_{\rm cond}$ plus Picard summability (L-15). |
| `cor:trend` | No differential drift puts the linear direction in $\ker\mathcal A_{\rm cond}$; A2 then forces $E[\Delta Z\Delta X]=0$. |
| **`prp:sharpquad` (NEW)** | $2Q(h)=\int M h^2\,dx-2\langle\mathcal Kh,h\rangle$ with $M=\sigma_{\widetilde W\partial_u\ell_\star}$. **$\int M=0$ but $M\not\equiv0$ — the difference structure buys the mean of $h^2$ and nothing more.** |

**The one-paragraph story, corrected.** `rem:nophifree` says no weight measurable in $(W,\Delta Z)$ alone can
make $\nu_g$ vanish. `prp:orthog` says a weight that also depends on the residual can. **O-11** says that
weight must therefore vary in $u$, which is what creates the quadratic remainder. **And `prp:sharpquad` says
that remainder cannot be improved**, because the second-order term is governed by $\sigma$, where the two
periods add, not by $\nu$, where they cancel. The negative result, the quadratic remainder, and the
$n^{-1/4}$ rate requirement are one phenomenon seen three times. **That is the paper's spine, and it is
tighter than what round 2 was reaching for.**

### 0.2 Dependency graph

```
  lem:shiftinv ──┐
                 │
  lem:bierens ───┼──► lem:adjoint ──► prp:orthog ──► prp:phirate ──► thm:rootn ──┬──► prp:effbound
                 │        ▲               ▲              ▲   │           ▲       │        ▲
                 │        │               │              │   └───────────┤       ├──► prp:plugin
  rem:nophifree ─┘        │               │              │               │       │
   (ν_g algebra;          │               │              │        L-14 (prelim   └──► cor:trend
    forces ∂_u ℓ ≠ 0)     │               │              │        consistency)
        │                 │               │              │
        └──► prp:sharpquad ◄──────────────┘         L-12, L-13, L-15, L-18, L-19
             (σ_g algebra; L-16, L-20)
```

`prp:sharpquad` is a **new node** fed by `rem:nophifree`/O-11 and feeding `thm:rootn`'s scope statement. It
is the only target that both consumes and constrains the main theorem.

### 0.3 Risk register

| Target | Type | Risk | Dominant obstacle | Fallback |
|---|---|---|---|---|
| `lem:shiftinv` | invariance / negative | **LOW** | O-9 | Demote the converse |
| `lem:bierens` | equivalence | **LOW–MEDIUM** *(was MEDIUM)* | O-6 | **§19.3 drops the strict inclusion (F4)** — the blocker is gone |
| `lem:adjoint` | closed form | **MEDIUM** | O-4 | Levels primary |
| `rem:nophifree` | impossibility | **LOW** | O-10 | Demote the endogenous-weight clause |
| **`prp:sharpquad` (NEW)** | **negative / sharpness** | **LOW–MEDIUM** | O-16 (measure and boundedness conditions) | Lower-bound-only version |
| `prp:orthog` | orthogonality | **MEDIUM** | O-14 (second inversion), O-15 (selection) | **§19.1 decided; price known (§3.7)** |
| **`prp:phirate`** | rate | **HIGH — the top risk** | M-1 (transfer), M-7 (random operator), O-13 ($\hat\varrho$ in $\dim\Delta Z$) | High-level A5 with leg 3 narrowed |
| `thm:rootn` | limiting distribution | **MEDIUM as scoped** | O-1 — **now $\delta_n=o(n^{-1/4})$, and `prp:sharpquad` says that is necessary** | T2′ → T3 |
| **`prp:effbound`** | efficiency bound | **HIGH** | O-3 | F3+F4 from the start |
| `prp:plugin` | negligibility | **MEDIUM** | O-12 | Conditional on $\sqrt{m_n}n^{-1/2}=o(\delta_n)$ |
| `cor:trend` | necessary condition | **LOW–MEDIUM** | O-7 | Pure non-identification statement |

**Plain statement (m-17).** `thm:rootn`'s risk is MEDIUM **as now scoped**, and the scope is the cost: mild
ill-posedness with $s>a+\tfrac12$, no theorem under severe ill-posedness. Round 2 downgraded the risk by
widening the scope on an empty condition; round 3 restores the honest scope and the risk with it. The top
risk has moved to **`prp:phirate`**, which now carries three loads (the rate, the DP transfer, the random
operator). `prp:effbound` remains high. Three targets at genuine risk, one of them new and favourable.

---

## 1. Conjecture

### 1.0 Programme-level

**One sentence.** In the first-differenced partially linear panel model with a continuous endogenous
regressor and a binary instrument, the conditional independence restriction $\Delta U\perp W\mid\Delta Z$
supplies — through a Bierens weight family and a residual-dependent debiasing weight solving
$\mathcal A^\ast_{\mathrm{cond}}\ell=-\nu$ — a Neyman-orthogonal moment whose cross-fitted one-step root is
$\sqrt n$-consistent and asymptotically normal for $\theta_\dagger$ **if** $\nu$ lies in the range of the
adjoint of the Fréchet derivative (A2) and the regularised step converges at $o(n^{-1/4})$ in $L^2(\pi)$;
**and the rate requirement cannot be weakened**, because the second-order remainder is governed by a
non-compact quadratic form.

**Necessity, stated precisely (M-5, and now sharper).** A2's necessity is proved in the linear case
(Severini–Tripathi) and remains **conjectural** here. The **rate condition, by contrast, is now shown to be
sharp for this moment function** (`prp:sharpquad`) — not necessary for $\sqrt n$-estimability of
$\theta_\dagger$ by *some* estimator, but necessary for *this* moment to deliver it. Keep the two apart.

### 1.1–1.11 Per target

| # | Label | Conjecture, one sentence |
|---|---|---|
| 1 | `lem:shiftinv` | Under conditional independence the residual at *any* trial $\theta$ remains conditionally independent of $W$, so (A) admits $\mathcal V_{CI}\times\IR^p$ and carries no first-order information about $\theta_\dagger$. |
| 2 | `lem:bierens` | For bounded one-to-one $\Phi$, analytic non-polynomial $w$, and $\mathcal T$ of positive Lebesgue measure, the conditional restriction is equivalent to $\{\mathcal M(u,t)=0\}$, and the closed span of $\{\lambda(\cdot)w(t'\Phi(\cdot))\}$ is dense in $L^2(P_{\Delta U,\Delta Z})$. **(Strict-inclusion half dropped — §19.3.)** |
| 3 | `lem:adjoint` | $\mathcal A^\ast_{\mathrm{cond}}\ell=\nu_{\widetilde W\ell}$, coinciding up to the strictly positive weight $\varrho(1-\varrho)$ with draft `:172–177` once the $\pi(v)$ duplication and vacuous $\theta$ subscript are removed and the parameterisation is fixed at levels. |
| 4 | `rem:nophifree` | A $(W,\Delta Z)$-measurable weight gives a $\varphi$-free moment for every admissible $\varphi$ **iff** $\nu_g\equiv0$; this fails in the application — **and hence any admissible debiasing weight must vary with the residual.** |
| 5 | **`prp:sharpquad` (NEW)** | The second-order remainder satisfies $\sup_{\|h\|_{L^2(\pi)}\le\delta}\lvert Q(h)\rvert=\tfrac12\delta^2\lVert\mathcal B_{\rm sym}\rVert\ge\tfrac12\delta^2\lVert M/\pi\rVert_{L^\infty}>0$, so **no bound of the form $o(\delta^2)$ — in particular no weak-norm bound — is available**, and $\delta_n=o(n^{-1/4})$ is sharp for this moment function. |
| 6 | `prp:orthog` | Under N1 the moment is Neyman-orthogonal in all three nuisances — exactly in $L$ and $\varrho$ (both affine), and in $\varphi$ iff $\nu_{\Delta Z+\widetilde W\ell}\equiv0$ — and the sample version is the **sieve balancing program of plan §15**, whose residual is measured in $L^2(\pi)$. |
| 7 | `prp:phirate` | Under a tangential cone condition **for the random operator $\hat T$** on a ball, a source condition of index $\mu$, a uniform operator-error bound over that ball, and the discrepancy principle at a level $\hat\delta_n$ dominating the true noise w.p.$\to$1, the LF step satisfies $\|\hat\varphi-\varphi_\dagger\|_{L^2(\pi)}=O_P(\hat\delta_n^{2\mu/(2\mu+1)})$. |
| 8 | `thm:rootn` | Under A1–A5, N1 and A2′, the cross-fitted one-step estimator satisfies $\sqrt n(\hat\theta-\theta_\dagger)\xrightarrow{d}N(0,J^{-1}\Sigma J^{-1\prime})$, $J=E[\Delta Z\Delta Z']+E[\widetilde W\ell_\star\Delta Z']$, $\Sigma=E[\psi_\star\psi_\star']$. |
| 9 | `prp:effbound` | The bound is finite **iff** A2′ holds; within the moment class the variance-minimising $\ell$ solves a stated variational problem over $\ell_\dagger+\ker\mathcal A^\ast_{\rm cond}$; global attainment is scoped open. |
| 10 | `prp:plugin` | One LF pass on $\Delta Y-\Delta Z'\hat\theta$ costs $O_P(\sqrt{m_n}n^{-1/2})$ relative to the oracle, negligible provided $\sqrt{m_n}n^{-1/2}=o(\delta_n)$. |
| 11 | `cor:trend` | If $\varphi_\dagger$ has a linear component and $\Delta X$ has no differential drift across $W$ conditional on $(\Delta U,\Delta Z)$, the linear direction lies in $\ker\mathcal A_{\rm cond}$, so **A2 fails** whenever $E[\Delta Z\Delta X]\neq0$. |

---

## 2. Target object

### 2.1 `lem:shiftinv` — invariance / negative identification result
Exact distributional invariance for every $\theta$. **Precedent:** Poirier (2017)'s conditional-independence
section runs the *reverse* direction; cite and state the difference (positioning §4(b)).

### 2.2 `lem:bierens` — identification / equivalence
$(\Rightarrow)$ is the Bierens/Stinchcombe–White argument carrying the operator equation; L-2's density is
what removes $\mu,\lambda,\mathcal T$ from the $\theta$-side. **§19.3 drops the strict-inclusion half**, so
this target is no longer blocked and its risk falls.

### 2.3 `lem:adjoint` — closed form + reconciliation
**The linchpin**: proves the operator in P1(i) is the operator whose regularised inverse produces
$\hat\varphi$. Mechanism: $E[\widetilde W g(W)\mid\Delta U,\Delta Z]=\varrho(1-\varrho)\{g(1)-g(0)\}$, so the
two differ by $\varrho(1-\varrho)$; **A4 is what makes that weight bounded away from $0$ and $\infty$.**

### 2.4 `rem:nophifree` — negative result (impossibility)
Highest positioning weight of any single result. Carries O-11's corollary, which is now the entry point to
`prp:sharpquad`.

### 2.5 `prp:sharpquad` — negative / sharpness result. **NEW; §9 item 13.**
**Object.** A lower bound on the operator norm of a quadratic form, hence a **necessity** statement about the
rate condition. Formally: the symmetric form $\mathcal B_{\rm sym}=m\cdot-2\tilde{\mathcal K}$ on $L^2(\pi)$
with $m=M/\pi$ has, by **Weyl's theorem** on invariance of the essential spectrum under compact
perturbation, $\sigma_{\rm ess}(\mathcal B_{\rm sym})=\operatorname{ess\,ran}(m)$; since $\int M\,dx=0$ and
$M\not\equiv0$, $m$ takes both signs and the form is **non-compact**. Consequences: (i)
$\sup_{\|h\|\le\delta}|Q(h)|=\tfrac12\delta^2\|\mathcal B_{\rm sym}\|\ge\tfrac12\delta^2\|m\|_\infty$;
(ii) $\mathcal R(\mathcal B)\subseteq\mathcal R(\mathcal A^\ast)$ is impossible for compact $\mathcal A$
unless $M\equiv0$; (iii) $\delta_n=o(n^{-1/4})$ is sharp for this moment function.
**Precedent.** No direct one. Nearest in spirit: Severini & Tripathi (2006) on which functionals are
$\sqrt n$-estimable; Khan & Tamer (2010) on rate failure surviving point identification. The absence of a
precedent for weak-norm bounding a *square* is itself weak evidence for the result (M-9).
**Two forms, and both should be stated.** The **constructive** one ($h_k=\sqrt2\chi\cos(kx)$, Riemann–Lebesgue
plus compactness of $\mathcal A$ and $\tilde{\mathcal K}$) is short and self-contained; the **spectral** one
(Weyl) is the reason and generalises. Lead with the construction; give Weyl as the remark.

### 2.6 `prp:orthog` — orthogonality, in sieve balancing form (§19.1)
Three claims of different logical type: an *iff* in $\varphi$; **exact** vanishing in $L$ and $\varrho$ (both
affine). Keep as one proposition with three parts; lift the balancing bound into **L-7**, now stated in the
$L^2(\pi)$ dual pairing with the sieve approximation term priced in §3.7.

### 2.7 `prp:phirate` — rate (§9 item 2)
**Object.** An $L^2(\pi)$ rate for a regularised solution of a **nonlinear ill-posed operator equation with
noise in the operator**, under a data-driven stopping rule. Round 3 makes the noise model explicit: this is
Dunker et al. (2014)'s setting, not `hanke1995`'s.
**Precedent.** `hanke1995` (nonlinear LF, DP, TCC — exactly known operator); `engl2000` Ch. 6 (source
conditions, $O(\delta^{2\mu/(2\mu+1)})$, noise propagation); **Dunker et al. (2014) for operator noise.**

### 2.8 `thm:rootn` — limiting distribution
Z-estimation with cross-fitted nuisances; $\hat\theta$ a **one-step** estimator from the plug-in (the moment
is nonlinear in $\theta$, and A3 is only local rank). Scope: **plan §2.6's**, with `prp:sharpquad` supplying
the necessity half.

### 2.9 `prp:effbound` — semiparametric efficiency bound
(a) finiteness iff A2′; (b) attainment within the class over L-16's affine set. F3+F4.

### 2.10 `prp:plugin` — negligibility; **2.11 `cor:trend`** — necessary condition
As round 2. `cor:trend`: **A3 is vacuous when A2 fails**, since A3 involves $\ell_\star$, which does not
exist then. State A3 as conditional on A2.

---

## 3. Toolkit

### 3.1 Chosen machinery, and why not the alternatives

| Machinery | Used for | Why this rather than the alternative |
|---|---|---|
| **Z-estimation with cross-fitted nuisances** (Newey–McFadden 1994 §6; vdV 1998 Ch. 5; Chernozhukov et al. 2018) | `thm:rootn` | Avoids stochastic equicontinuity **at the estimated point at $\sqrt n$ scale**. **Alternative rejected: functional CLT / Donsker.** A positioning commitment (leg 3), and it now also constrains L-18/L-19 — see §3.4. |
| **Neyman orthogonality with an explicit second-order expansion** | `prp:orthog`, `thm:rootn` | The second-order term must be written out **and its sharpness established** (§3.5). |
| **Spectral theory of self-adjoint forms: Weyl's theorem, essential spectrum, non-compactness of multiplication** — **NEW** | `prp:sharpquad` | The right tool for a *negative* statement about a quadratic form. Douglas answers "is there a factorisation?"; Weyl answers "can there be?" — and here the answer is no. Round 2 invoked Douglas without checking its compactness consequence. |
| **Douglas's range-inclusion theorem** (Douglas 1966, *PAMS* 17, 413–415) | §3.6 (retained, unused by decision) | Correctly applied in §3.6; **withdrawn from §3.5**. Kept because §19.3 may be revisited. |
| **Picard's criterion / singular-system calculus** (`carrasco2007h`; `engl2000`) | L-15; A2/A2′ diagnostics | Range conditions as summability conditions — checkable and reportable (plan §9.2 item 3). **Now includes $\nu\perp\ker\mathcal A$** (m-13), which is `cor:trend`'s content. |
| **Regularisation for NONLINEAR ill-posed problems with OPERATOR noise** (`hanke1995`; `engl2000` Ch. 6; **Dunker et al. 2014**; `chenreiss2011`) | `prp:phirate` | M-7: the noise here is in the operator, so `hanke1995` alone is the wrong citation for the stopping rule's validity. |
| **Uniform LLN with a rate over a slowly growing ball** (bracketing/VC entropy; van der Vaart–Wellner 1996 §2.5 for the *rate*, not §2.8 for the CLT) — **NEW** | L-19, `prp:phirate` | The minimal machinery closing the DP transfer without a functional CLT. §3.4 states exactly what is and is not conceded. |
| **Bierens / GCR device** (Bierens 1990; Stinchcombe–White 1998; Domínguez–Lobato 2004; Sriperumbudur et al. 2010) | `lem:bierens`, index set | Alternative rejected: nonparametric smoothing in $\Delta Z$ (leg 2). |
| **Sieve balancing in $L^2(\pi)$** (plan §15; Zubizarreta 2015; Athey–Imbens–Wager 2018; Hirshberg–Wager 2021) + **Tikhonov theory for the solve** | `prp:orthog`, L-7, L-13 | **§19.1.** Chosen by the dual-pairing principle: the residual is measured in the norm dual to the one in which a rate for $h$ exists, and that norm is $L^2(\pi)$. |
| **Semiparametric efficiency / tangent-space calculus** (BKRW 1993 §3–4; Newey 1990, 1994; Chamberlain 1987; Poirier 2017) | `prp:effbound` | Alternative rejected: quoting Poirier's bound (well-posed nuisance, unconditional independence). |
| **Irregular / weak identification** (Khan–Tamer 2010; Escanciano 2022; Stock–Wright 2000) | A4; reporting when A2 fails | A2 can hold as a range statement while the influence function has infinite variance. |
| **NOT used: PSMD; the naive S-set; RKHS balancing; higher-order orthogonalisation** | — | Respectively: positioning; C-2; §19.1; a different paper. |

### 3.2 The weighting measure $\mu$ (m-14 corrected)

1. **$\theta$-side: no $\mu$.** L-2's density makes $L(u,z)=\int\lambda(u,t)w(t'\Phi(z))\mu(dt)$ a
   parameterisation of an arbitrary element of a dense span; the estimator *solves* for $L$.
2. **$\varphi$-side: finite but growing $\mathcal T_{K_n}$, $K_n\to\infty$.** Domínguez–Lobato bites here and
   only here, as an *identification* assumption. Poirier is the precedent; Donald–Imbens–Newey the lead.
3. **Efficiency: $\mu$ returns; Carrasco–Florens is the benchmark, not the machinery.**

**The argument against CGMM, restated once more (m-14).** Round 1's version ("we would carry two ill-posed
problems") was withdrawn in round 2 because the paper already carries two. Round 2's replacement leg (i)
("the balancing inversion is finite-dimensional and governed by standard Tikhonov theory") **contradicts
O-14 and L-13**, which give that same solve its own $\rho$, source index $\mu'$ and rate. **The surviving,
load-bearing content is:** *adopting CGMM would require choosing a weighting measure on the continuum and
regularising the inverse of its covariance operator; the construction here requires **no weighting-measure
choice at all**, because $L$ is solved for rather than weighted.* Add: CGMM's inversion would be a third,
and its efficiency theory presumes a known moment function. State those three; retire the others.

### 3.3 `prp:phirate`, the noise level, the TCC, and the stopping rule

**Step 1a — the operator component of the noise.** $T(\varphi)(u,t)=E[\widetilde W\1{\Delta U(\varphi,\theta)\le u}\,w(t'\Phi(\Delta Z))]$
is an **unconditional** expectation. Its sample analogue is a plain average with smoothing **only in the
residual direction**, to smooth the indicator — exactly plan §16.1 (order-8 kernels *in the residual
direction*, $h_u\propto\mathrm{sd}(u)n^{-1/16}$). **The conditional density of $\Delta Y$ given the
endogenous regressors appears in the *analysis* (the Fréchet derivative), not as an estimated object.**
Round 2's "$(x_1,x_2,u)$, $d=3$" was wrong (M-8). With $d=1$, order $p$, and no local-averaging denominator,
the stochastic part is $O_P(\sqrt{\log n/n})$ and the smoothing bias is $O(h_u^p)$; at $p=8$,
$h_u\asymp n^{-1/16}$ gives bias $n^{-1/2}$, matching the stochastic term. So
$$\hat\delta_n^{(T)}=O_P\big(n^{-1/2}\sqrt{\log n}\big)\quad\text{— nearly parametric.}$$
**This also explains plan §16.1's bandwidth exactly, and it means the kernel order is not the binding thing
asymptotically.**

**Step 1b — the propensity component, costed for the first time (M-8, O-13).** $\hat\varrho$ enters through
$\widetilde W_i=W_i-\hat\varrho(\Delta Z_i)$ and is a genuinely $d_Z$-dimensional nonparametric regression,
$d_Z=\dim(\Delta Z)\in\{3,\dots,5\}$. For smoothness $r$, $\hat\delta_n^{(\varrho)}=O_P(n^{-r/(2r+d_Z)})$,
and $\hat\delta_n=\max\{\hat\delta_n^{(T)},\hat\delta_n^{(\varrho)}\}=\hat\delta_n^{(\varrho)}$ for any
practical $(r,d_Z)$. **$\hat\delta_n=o(n^{-1/4})$ therefore requires $r>d_Z/2$** — $r>1.5$ at $d_Z=3$,
$r>2.5$ at $d_Z=5$. **This is the honest cost of §17's conditional route and it should be a numbered
condition, not a footnote.** It is also what SG-20 must test.

**Step 2 — the residual at the stopping index.** With the TCC, $\|\mathcal A h\|\le(1+\eta)\|T(\varphi_{\hat m})\|$.
The DP stops on $\|\hat T(\varphi_{\hat m})\|\le\tau\hat\delta_n$; L-19 transfers to $\|T(\varphi_{\hat m})\|$.
**Round 2's use of this — as the input to Q-c2 — is withdrawn with the rung.** The deterministic core is
still correct and still useful: it is what makes the stopping index well-defined and gives `prp:plugin` its
handle. It is no longer load-bearing for `thm:rootn`.

**Step 3 — the $L^2$ rate.** Under a source condition of index $\mu$, $\|h\|_{L^2(\pi)}=O_P(\hat\delta_n^{2\mu/(2\mu+1)})=:\delta_n$.
**Combined with Step 1b and `prp:sharpquad`'s $\delta_n=o(n^{-1/4})$: $\hat\delta_n^{2\mu/(2\mu+1)}=o(n^{-1/4})$,
i.e. $r/(2r+d_Z)>\tfrac{2\mu+1}{8\mu}$.** That is the theorem's operative condition, in primitives, and it is
what makes T2′ a result rather than bookkeeping.

**The TCC, for a RANDOM operator (M-7).** `hanke1995` proves the DP for an **exactly known operator with
noisy data**. Here the noise is in the **operator**: $\hat T$ is built from smoothed indicators and
$\hat\varrho$, so $\hat T(\varphi_\dagger)\neq0$. Two conditions must be stated and neither was:
- **A6 (random TCC).** The tangential cone condition holds for $\hat T$ on a ball around $\varphi_\dagger$
  with probability approaching one, with a constant $\eta<\tfrac12$ not depending on $n$. **This is the
  Dunker et al. (2014) setting** — upgraded from the IRGN fallback to the noise model.
- **A7 (stopping feasibility).** $\hat\delta_n$ dominates the true noise level, $P(\|\hat T(\varphi_\dagger)\|\le\tau\hat\delta_n)\to1$.
  **Without it the discrepancy principle never stops** and the estimator is the iteration cap.
Route (a) for the TCC (range invariance, `hanke1995` (2.6)/(2.7)) is capped at **one round**, and must now be
attempted for $\hat T$, not $T$.

**The stopping rule (§19.2 — DECIDED: discrepancy principle, superseding plan §16.3).** **The justification
must change.** Round 2's reason — that it controls $\|\mathcal A h\|$ for Q-c2 — **dies with Q-c2**, as does
lever 2's trace argument (§3.5). Two independent reasons survive and are sufficient: (i) it is the rule
`hanke1995` proves for the **nonlinear** case, modulo M-7's noise-model correction; (ii) **the implemented
argmin-over-the-path rule has no theorem behind it** in either noise model, and belongs to the
Lepskii/balancing family whose analysis is a separate undertaking. Record the change of reason explicitly —
a decision that outlives its argument needs a new one on the record.

### 3.4 Chen & Pouzo: the four legs, with leg 3 finally closed

| Leg | Verdict |
|---|---|
| 1. Continuum vs finite $d_\rho$; Domínguez–Lobato | **DELIVERED**, provided $K_n\to\infty$ is numbered and the implementation does not use a fixed grid (SG-6). |
| 2. Smoothing in $\Delta Z$ | **RESTATED (round 1).** PSMD needs a $d_\rho$-vector of conditional expectations of the generalized residual on $\Delta Z$ at **first order**; we need **one scalar binary regression** at **second order** under N1, and no conditional *distribution*. **Round 3 adds the price:** that one regression is $d_Z$-dimensional and, by Step 1b, it is the binding component of $\hat\delta_n$. The leg is narrower than round 1 thought and narrower than round 2 said. |
| 3. Donsker | **CLOSED, and narrowed (M-1).** Round 2's version was a relocation: L-18 is Glivenko–Cantelli at the **fixed** $\varphi_\dagger$, while Step 2 evaluates the residual at $\varphi_{\hat m}$ — a data-dependent element of a path generated by $\hat T$, which cross-fitting does not decouple. **The closure is L-19:** a uniform bound $\sup_{\varphi\in\mathcal V_n}\|\hat T(\varphi)-T(\varphi)\|=O_P(\hat\delta_n)$ over a **deterministic ball $\mathcal V_n$ containing the LF path**, the containment holding because $\varphi_m-\varphi_0\in\mathcal R(\hat{\mathcal A}^\ast)$ with norm growing at most polynomially in the iteration cap $\bar m$. **The honest restatement:** *we do use an entropy bound — a uniform LLN at rate $\hat\delta_n\gg n^{-1/2}$ over a ball of slowly growing radius, for a VC-subgraph class of indicator-weighted functions. We do not use, and the LF path would not support, stochastic equicontinuity of the $\sqrt n$-scaled empirical process at the estimated point, which is what PSMD's $\theta$-asymptotics require.* **That is a difference in kind and in scale, and it is defensible; "we avoid empirical process theory entirely" is not, and is withdrawn.** |
| 4. Negative result, panel | **DELIVERED**, and strengthened by `prp:sharpquad`. |

### 3.5 THE SHARPNESS RESULT — what replaces the ladder

**Round 2 staked the scope on A2″. A2″ cannot hold. Here is the calculation, and the result it yields.**

**The decomposition.** With $q(x_1,x_2)=E[\widetilde W\partial_u\ell_\star\mid X_1,X_2]$ and
$(\Delta h)^2=h(X_2)^2-2h(X_1)h(X_2)+h(X_1)^2$:
$$2Q(h)=E\big[q(\Delta h)^2\big]=\int M(x)h(x)^2dx-2\langle\mathcal Kh,h\rangle,\qquad
M=\sigma_{\widetilde W\partial_u\ell_\star},$$
$\mathcal K$ the integral operator with kernel $q\,f_{X_1,X_2}$ (Hilbert–Schmidt when $qf_{X_1X_2}\in L^2$).
**The two diagonal terms ADD.** Round 2's route took $\phi=h$ in the $\nu_g$ identity, which applies the
difference structure to *one* factor of $\Delta h$ and leaves the other as a pointwise multiplier — so what
it buys is $\int M=2E[\widetilde W\partial_u\ell_\star]=0$ under A1, the **mean of $h^2$ and nothing more.**
That is precisely the accounting I used against C-1; I did not apply it to my own construction.

**Why both Q-c rungs are empty.** On $L^2(\pi)$ write $m:=M/\pi$, so $\mathcal B_{\rm sym}=m\cdot-2\tilde{\mathcal K}$.
$\mathcal A$ is compact — the premise of the whole project ($\sigma_j\asymp j^{-a}$, Picard, source
conditions, LF regularisation all presuppose it). Douglas gives
$\mathcal R(\mathcal B)\subseteq\mathcal R(\mathcal A^\ast)\Rightarrow\mathcal B=\mathcal A^\ast C\Rightarrow\mathcal B$
**compact**; multiplication by $m$ on a non-atomic space is compact **iff $m\equiv0$**. So
**A2″(1) and A2″(2) hold iff $M\equiv0$**, a knife-edge with no structural motivation.
**Constructive confirmation:** $\chi$ smooth supported where $M>0$, $h_k=\sqrt2\chi\cos(kx)$; then
$h_k\rightharpoonup0$, so $\|\mathcal Ah_k\|\to0$ and $\langle\tilde{\mathcal K}h_k,h_k\rangle\to0$, while
$\int Mh_k^2\to\int\chi^2M>0$ by Riemann–Lebesgue. Both ratios diverge.
**Independently (M-6):** even granting A2″(2), Douglas yields $\lambda'\|h\|\|\mathcal A^\ast\mathcal Ah\|\ge\lambda'\|\mathcal Ah\|^2$
— the inequality runs the wrong way. The delivering condition would be the **form** inequality
$\mathcal B_{\rm sym}\preceq\lambda'\mathcal A^\ast\mathcal A$. Q-c1's derivation was correct as written; Q-c2's was not.

**The result (`prp:sharpquad`).** By Weyl's theorem the essential spectrum is invariant under the compact
perturbation $\tilde{\mathcal K}$, so $\sigma_{\rm ess}(\mathcal B_{\rm sym})=\operatorname{ess\,ran}(m)$;
since $\int M=0$ and $M\not\equiv0$, $m$ takes both signs and
$$\sup_{\|h\|_{L^2(\pi)}\le\delta}\big|Q(h)\big|=\tfrac12\delta^2\big\|\mathcal B_{\rm sym}\big\|\;\ge\;\tfrac12\delta^2\big\|m\big\|_{L^\infty}\;>\;0 .$$
**Consequences to state in the paper.** (i) $\delta_n=o(n^{-1/4})$ is **sharp for this moment function** — not
an artefact of proof technique. (ii) No weak-norm bound on $Q$ exists, so the Severini–Tripathi mechanism
that governs the *first-order* term has no analogue at second order. (iii) The scope is plan §2.6's:
$\sqrt n$ under mild ill-posedness with $s>a+\tfrac12$; **unavailable under severe ill-posedness**, and round
2's withdrawal of that statement is itself withdrawn. (iv) It is **falsifiable** — SG-16 computes the ratios
and predicts divergence in $n$ *and* in discretisation refinement.

**Lever 1, re-aimed at $M$ (min. item 1).** The non-uniqueness insight survives: validity holds for any
$\ell$ (under A1, $E[\widetilde WL\mid\Delta Z]=E[\widetilde W\mid\Delta Z]E[L\mid\Delta Z]=0$), so
$\ell_\star$ ranges over the affine set $\ell_\dagger+\ker\mathcal A^\ast_{\rm cond}$. But the object
governing feasibility is **$M$**, not $\|\partial_u\ell_\star\|_\infty$, which now only moves the constant in
an order-sharp bound. Define $\mathcal S\ell:=\sigma_{\widetilde W\partial_u\ell}$. Then:

> **The $M\equiv0$ question is the linear feasibility problem $\mathcal S\ell_\dagger\in\mathcal S\big(\ker\mathcal A^\ast_{\rm cond}\big)$.**

**Recorded as OPEN, with three observations the theorist should carry.**
1. **The dimension count favours feasibility.** $\ker\mathcal A^\ast$ is infinite-dimensional (because
   $\mathcal A^\ast$ maps into functions of a *scalar*), while the target $\mathcal S\ell_\dagger$ is one
   function of a scalar. There is no containment obstruction: $\ell\in\ker\mathcal A^\ast$ constrains the
   *difference* of the period conditionals of $\widetilde W\ell$, while $\mathcal S$ reads the *sum* of those
   of $\widetilde W\partial_u\ell$ — different combinations of different objects.
2. **$M\equiv0$ is necessary, not sufficient, for any weak-norm rung.** With $M\equiv0$ the form is
   $-2\tilde{\mathcal K}$, compact, so the Douglas obstruction disappears — but the range inclusion is then
   still a genuine and strong condition needing its own argument, and by M-6 the delivering condition is the
   *form* inequality. **Do not present $M\equiv0$ as reopening Q-c2; it reopens the *question*.**
   A stronger and cleaner target is $q\equiv0$, which kills $M$ and $\mathcal K$ together and gives $Q\equiv0$.
3. **The lever pays even when infeasible.** By the sharpness identity the constant is $\tfrac12\|m\|_\infty$
   (up to the compact part), so **minimising $\|M/\pi\|_\infty$ over the affine set directly minimises the
   sharp constant.** That is a real design gain in a bound whose *order* cannot be improved, and it is what
   SG-15 should sweep.
4. **The numerical test must not be a discretised Picard check (m-9).** Every discretised $\mathcal B_n$ is
   finite-rank, so any singular-system comparison passes spuriously. The valid test is the **test sequence**:
   compute $Q(h_k)/\|\mathcal Ah_k\|^2$ for increasing $k$ *and* increasing mesh, and check divergence in both.

**Lever 2 (trace) — WITHDRAWN.** $\mathcal Q=m\cdot+$compact, so $\operatorname{tr}(\mathcal Q\Sigma_v)$
contains $\int M(x)\Sigma_v(x,x)dx$, the integrated pointwise variance, which high-frequency noise does not
shrink. The claim that the remainder-optimal regularisation differs from the MISE-optimal one loses its
argument. SG-18 is retained as an exploratory design, not as a test of a stated claim.

**Q-b's residue, corrected (m-18).** Round 2 called it $O(\|h\|_\infty\|h\|_{L^2})$; by Cauchy–Schwarz it is
$O(\|h\|^2_{L^2})$ with no sup-norm needed — so the split is strictly **worse** than the direct bound, and
the direct bound is what `prp:sharpquad` shows to be sharp.

### 3.6 The "A2 gets weaker" comparison (§19.3 — DECIDED)

**Decision: keep the unconditional framing as *motivation only*; drop the strict-inclusion half of
`lem:bierens` (F4).** Plan §17.3 stays as prose with an explicit caveat that it is a **heuristic comparison
across modelling assumptions, not a range inclusion.** Concretely, the caveat must say: under the
unconditional reading the two moment classes are **not nested** —
$\{\widetilde W\ell(\Delta U,\Delta Z)\}=\{G:E[G\mid\Delta U,\Delta Z]=0\}$ versus
$\{G(W,\Delta U):E[G\mid\Delta U]=0\}$ — so no inclusion statement is being claimed.

**Route retained in case the position changes.** Under the $\Delta Z$-averaged reading the inclusion is
provable in three citable steps: **Jensen** ($\mathcal A_{\rm avg}h(u)=E[\mathcal A_{\rm cond}h(u,\Delta Z)]$
gives $\mathcal A^\ast_{\rm avg}\mathcal A_{\rm avg}\preceq\mathcal A^\ast_{\rm cond}\mathcal A_{\rm cond}$);
**Douglas** (the ordering yields the range inclusion); **Picard** (strictness when
$\sigma_j(\mathcal A_{\rm avg})/\sigma_j(\mathcal A_{\rm cond})\to0$, exhibitable in SG-19). All three steps
were verified in round 2. **What dropping it costs** (the gap the review named): the paper loses its one
formal argument that conditioning buys something in exchange for A4 and the third nuisance. That cost should
be stated in the conclusion rather than papered over — the conditional route is now defended on
*economic* grounds (CAAA assignment on 1970 TSP levels correlates with income, density, manufacturing share)
and on internal consistency with the draft's `ass:condind`, not on a weaker source condition.

### 3.7 Pricing the balancing decision (§19.1 — DECIDED: sieve / $L^2$), owed from item 3

**The bound.** With basis $b_1,\dots,b_{L_x}$, $P_{L}$ the $L^2(\pi)$-projection onto its span, and
$g=\Delta Z_j+\widetilde W\hat\ell$, the balancing solve makes the *empirical* $\hat\nu_g$ orthogonal to the
sieve. Then
$$\big|\langle\nu_g,h\rangle\big|\;\le\;\underbrace{\big|\langle\nu_g-\hat\nu_g,\,h\rangle\big|}_{O_P(n^{-1/2})\cdot\|h\|_{L^2(\pi)}}
\;+\;\underbrace{\big|\langle\hat\nu_g,\,P_Lh\rangle\big|}_{=0\ \text{by balancing}}
\;+\;\underbrace{\big|\langle\hat\nu_g,\,(I-P_L)h\rangle\big|}_{\le\ \|\hat\nu_g\|\cdot\|(I-P_L)h\|}.$$

**The price, in rates.** For $\varphi_\dagger$ in a Sobolev ball of order $s$ and a basis with approximation
power $L_x^{-s}$, $\|(I-P_{L_x})h\|_{L^2(\pi)}=O_P(L_x^{-s})$, so
$$\text{first-order bias}=O_P\big(n^{-1/2}\delta_n\big)+O_P\big(\|\hat\nu_g\|\,L_x^{-s}\big).$$
For $o_P(n^{-1/2})$: **$L_x\gg n^{1/(2s)}$**, while conditioning of the balancing solve and control of
$\|\hat\ell\|$ require $L_x$ to grow slower than $n^{1/2}$ (the usual sieve trade-off; L-13 supplies the
other side). **Feasible iff $s>1$**, with the admissible window $n^{1/(2s)}\ll L_x\ll n^{1/2}$. That is the
condition the theorist must state and the Monte Carlo must exhibit (SG-9, SG-17).

**The three options, priced by the criterion that decides them** — the resulting bound on the first-order
bias and whether it is $o_P(n^{-1/2})$:

| Option | Bias bound | $o_P(n^{-1/2})$ when | Unproven inputs |
|---|---|---|---|
| **(i) Sieve / $L^2(\pi)$ — DECIDED** | $O_P(n^{-1/2}\delta_n)+O_P(L_x^{-s})$ | $L_x\gg n^{1/(2s)}$, $s>1$ | None beyond standard sieve approximation. **Decidable and it works.** |
| (ii) RKHS / Matérn | $\big(O_P(n^{-1/2})+\text{ridge bias}+\|\mathcal A^\ast(\hat\ell-\ell_\star)\|\big)\cdot\|h\|_{H^{s'}}$ | $\|h\|_{H^{s'}}=o(1)$ via interpolation | A **uniform $H^m$ stability bound on the LF iterate** (`engl2000` Ch. 6 under a source condition, uncited); loss of the analytic primitive at `orthogonal_theta.R:174–177`. |
| (iii) Weak-dual / adjoint norm | $\|\hat\ell_{\rm bal}\|\cdot\|\mathcal Ah\|$ | $\|\mathcal Ah\|$ fast | *Recorded for accuracy:* its attraction concerned the **first-order** term, which A2 governs, so it does not die with A2″. It does, however, inherit §15's discretisation problem and is untested. **Not chosen; not re-litigated.** |

### 3.8 Withdrawal of the SCDR precedent (M-9)

Round 2 sold A2″ as the transplant of source-condition double robustness (Bennett et al. 2026;
Chernozhukov–Newey–Singh 2022a,b). **Withdrawn.** SCDR supplies a **disjunctive** condition trading primal
against dual smoothness on a **cross-product** $\|\hat\varphi-\varphi\|\|\hat\ell-\ell\|$. The remainder here
is a **square** in one nuisance, and my own §2.6 inheritance argument — that a square gets no help from a
second nuisance — is exactly why the transplant fails. **No precedent is offered in its place.** Note in the
paper that the absence of any precedent for weak-norm bounding a second-order *square* is consistent with
`prp:sharpquad`: if it were generally possible, it would be in the literature.

---

## 4. Key intermediate lemmas

**Convention (retained):** $\ell_\star$ is the *selected* solution in $\ell_\dagger+\ker\mathcal A^\ast$;
every statement about $\|\partial_u\ell\|_\infty$, $E[\widetilde W^2\ell^2]$, $M$ and A2′ is about $\ell_\star$.

| # | Lemma | Serves | Content | Risk |
|---|---|---|---|---|
| **L-1** | Boundedness and kernel of $\Delta$; the pair $(\nu_g,\sigma_g)$ | `lem:adjoint`, `rem:nophifree`, `cor:trend`, `prp:sharpquad` | $\|\Delta\|\le2$; $\ker\Delta=$ constants under measure-separability; $\langle\nu_g,\phi\rangle=E[g\Delta\phi]$. **Round 3: also define $\sigma_g$ and record that $\int\nu_g=0$ *and* $\int\sigma_g=2E[g]$** — the two facts that separate first- from second-order behaviour. | LOW |
| **L-2** | Density of the closed span | `lem:bierens`, A2, §3.2 | Dense in $L^2(P_{\Delta U,\Delta Z})$; what makes $\mu$ drop out. | LOW–MED |
| **L-3** | Quantifier management in $u$ | `lem:bierens` | Rationals + right-continuity; no union problem in $t$. | LOW |
| **L-4** | Interchange through the indicator | `lem:adjoint` | Needs $f_{\Delta Y\mid X_1,X_2,\Delta Z,W}$ continuous **and $C^1$ in $u$ with bounded derivative** — not $f_U$. State the dominating function. | MED |
| **L-5** | Level vs derivative parameterisation | `lem:adjoint`, `thm:rootn` | A2 equivalent in both; remainder bounds not. Prove in levels. | MED |
| **L-6** | Second-order expansion in three nuisances | `prp:orthog`, `thm:rootn` | Six terms; $\partial^2_{LL}=\partial^2_{\varrho\varrho}=0$ **exactly** (affine); $\partial^2_{\varphi\varphi}=Q(h)\neq0$. | HIGH VALUE |
| **L-7** | Balancing residual bounds the first-order bias — **now in $L^2(\pi)$ (§19.1)** | `prp:orthog`, `thm:rootn` | The three-term decomposition and the price of §3.7, including the $\hat\ell$-error and — for the Tikhonov solve — the ridge bias, both omitted in round 1. | HIGH VALUE |
| **L-8** | Cross-fitting kills the empirical-process term | `thm:rootn` | Conditional Chebyshev given $\|\hat\eta-\eta_\star\|=o_P(1)$. | LOW |
| **L-9** | No double-counting of the propensity | `thm:rootn` | Route (b): rate for $\hat\varphi$ *as constructed*, $\hat\varrho$ inside $\hat\delta_n$ (Step 1b). Chain rule as a remark only. | MED |
| **L-10** | Median over partitions | `thm:rootn` | Same influence function ⟹ asymptotic equivalence for fixed $S$; variance from the sandwich. | LOW |
| **L-11** | Sandwich variance consistency | `thm:rootn`, application | **Under N1 and P1(iii) there is NO additional LR correction for $\varrho$** — positioning §4 says otherwise; flag for the writer (§9 item 10). | LOW |
| **L-12** | Landweber noise propagation | `prp:plugin` | $O(\sqrt m\,\delta)$ at stopping index $m$ (`engl2000` Ch. 6). | LOW–MED |
| **L-13** | Rate for $\hat\ell$ | `thm:rootn` cross terms, L-7 | Tikhonov on the empirical form: $O_P(\rho^{\mu'}+n^{-1/2}\rho^{-1/2})$, optimised at $\rho\asymp n^{-1/(2\mu'+1)}$. | MED |
| **L-14** | Consistency of the one-step preliminary | `thm:rootn` | Consistent **iff** $\|\hat\varphi-\varphi_\dagger\|\xrightarrow{p}0$; the `prp:phirate` dependency. | LOW |
| **L-15** | Picard conditions — **CORRECTED (m-13)** | A2 family; application diagnostic | Two clauses, not one: **$\nu\perp\ker\mathcal A_{\rm cond}$** (which is `cor:trend`'s content — omitting it was internally inconsistent) **and** $\sum_j\sigma_j^{-2}\langle\nu,\phi_j\rangle^2<\infty$. Supplies the reportable diagnostic of plan §9.2 item 3. **Explicitly supplies no primitives for A2′'s sup-norm clauses — see L-21.** | MED |
| **L-16** | Structure of the solution set — **RE-AIMED (C-3(3))** | §3.5 lever 1, `prp:effbound` | Solutions form $\ell_\dagger+\ker\mathcal A^\ast$, infinite-dimensional; **every selection gives a valid, orthogonal moment** (validity from A1 alone). **Round 3: the selection functionals that matter are $\mathcal S\ell=\sigma_{\widetilde W\partial_u\ell}$ (feasibility of $M\equiv0$; minimisation of $\|M/\pi\|_\infty$) and the variance functional (F4)** — not $\|\partial_u\ell\|_\infty$. | HIGH VALUE |
| **L-17** | Tangent space under conditional independence with infinite-dimensional $\varphi$ | `prp:effbound` | Sum-space structure $\{a(u,z)+b(w,z)\}$ with constraints (BKRW 1993 §4), plus the $\varphi$-direction Poirier lacks. | HIGH |
| **L-18** | Operator-estimation rate at fixed $\varphi_\dagger$ — **SCOPE CORRECTED** | `prp:phirate` Step 1 | Glivenko–Cantelli at the **fixed** truth, over the fixed $(u,t)$ index set, at $O_P(\hat\delta_n)$ with the two components of §3.3 Steps 1a/1b. **Not sufficient on its own** — see L-19. | MED |
| **L-19 (NEW)** | **Uniform operator error over a ball containing the LF path** | `prp:phirate` Step 2, leg 3 | $\sup_{\varphi\in\mathcal V_n}\|\hat T(\varphi)-T(\varphi)\|=O_P(\hat\delta_n)$ for a deterministic ball $\mathcal V_n$ containing the path, containment because $\varphi_m-\varphi_0\in\mathcal R(\hat{\mathcal A}^\ast)$ with norm growing at most polynomially in the cap $\bar m$. **A uniform LLN with a rate for a VC-subgraph class of indicator-weighted functions — not a functional CLT.** Closes M-1. | **HIGH — the load-bearing new lemma** |
| **L-20 (NEW)** | **Structure of $\mathcal B_{\rm sym}$: boundedness, decomposition, non-compactness (m-12)** | `prp:sharpquad` | $\mathcal B_{\rm sym}=m\cdot-2\tilde{\mathcal K}$ on $L^2(\pi)$, with the conditions round 2 asserted without stating: **$q$ bounded; $qf_{X_1X_2}\in L^2$; $f_{X_t}/\pi$ bounded**. Resolves the $L^2(\pi)$-vs-$L^2(dx)$ mismatch by carrying $m=M/\pi$ throughout. Weyl ⟹ $\sigma_{\rm ess}=\operatorname{ess\,ran}(m)$. | MED |
| **L-21 (NEW)** | **Primitives for A2′'s sup-norm clauses (M-2 leftover)** | A2′, L-6, `prp:sharpquad` | L-15's Picard gives $L^2$ membership only; A2′ needs $\ell_\star$ and $\partial_u\ell_\star$ **bounded**, which is what bounds $Q$ and defines $q$. Route: a source condition of index $\mu''>$ the Sobolev-embedding threshold, giving $\ell_\star\in\mathcal R((\mathcal A\mathcal A^\ast)^{\mu''})\hookrightarrow C^1$; state the embedding explicitly. **Without this the whole second-order analysis rests on an unverifiable clause.** | **MED–HIGH** |

**Assumption-block consequences** (for `assumptions.tex`, beyond plan §6's seven items):

- **`assapp2` insufficient** (L-4): carry $C^1$ in $u$ for the conditional density given the endogenous
  regressors, bounded on compacts.
- **`assapp5` rewritten** for the panel + Bierens index set: **one-dimensional smoothing in $u$ only**
  (M-8); $h_x$ and $h_w$ disappear from the operator (no local averaging; $W$ enters through $\widetilde W$);
  no bandwidth in $t$ or $\Delta Z$; **a smoothness/rate condition for $\hat\varrho$ in $d_Z$ dimensions
  replaces them, and it is the binding one** (§3.3 Step 1b, $r>d_Z/2$).
- **`assapp4`'s $\kappa_n$ — withdrawn, with the tail caveat corrected (m-15).** With $\ell_n$ bounded,
  $\kappa_n$ is a positive constant and there is no penalty. If $\ell_n\to\infty$ the penalty is
  **sub-polynomial, not logarithmic** — for Gaussian $f_U$ and $\ell_n\asymp\sqrt{2c\log n}$,
  $\kappa_n^{-1}\asymp n^{c}$. Say "sub-polynomial for slowly diverging $\ell_n$." Coordinator to strike the
  plan §2.6 echo.
- **A2′:** A2 **and** $\ell_\star$, $\partial_u\ell_\star$ bounded (L-21) **and** $E[\widetilde W^2\ell_\star^2]<\infty$.
  **A2″ is NOT to be written into `assumptions.tex`** — it is empty unless $M\equiv0$, which is open.
- **A5:** the two rates `prp:phirate` delivers — $\|h\|_{L^2(\pi)}=O_P(\delta_n)$ with $\delta_n=o(n^{-1/4})$,
  and $\hat\delta_n$ per Steps 1a/1b.
- **A6 (random TCC), A7 (stopping feasibility)** — new, from M-7.
- **$\mathcal T$:** compactness sufficient not necessary ($\int e^{c\|t\|_1}|\mu|(dt)<\infty$), and nearly
  moot given §3.2. Footnote.

**Notation-warden pre-warnings.** (1) $\Phi$ ×3 — transform of $\Delta Z$ (keep), identified set (rename
$\mathcal V_{CI}$), normal CDF in `orthogonal_theta.R:176` (rename in the comment). (2) $D$ ×2 — draft's
differentiation operator, plan §15's design matrix; do not add a third. (3) $\ell_n$ RESERVED by `assapp4`;
use $m_n$ for the LF stopping index and $\bar m$ for the cap. (4) $\ell_\star$ vs $\ell_\dagger$. (5) **New:**
$\nu_g$ (difference) vs $\sigma_g$ (sum) — the distinction is the paper's spine; keep the symbols apart.

---

## 5. Anticipated obstacles

### O-1 — The quadratic remainder. **Now bounded, sharp, and scoped.**
$\delta_n=o(n^{-1/4})$; mildly ill-posed $s>a+\tfrac12$; **unavailable under severe ill-posedness**.
`prp:sharpquad` makes this necessity rather than an unimproved bound. **What to do:** state the scope
plainly; state the sharpness result; decline higher-order orthogonalisation in one sentence.

### O-1b — The tangential cone condition, **for a random operator (M-7)**
Quadratic remainder $\ne$ TCC. Budget range invariance at one round — **attempted for $\hat T$, not $T$** —
then state A6. IRGN (Dunker et al. 2014) remains the regulariser fallback; its *noise model* is now adopted
regardless.

### O-2 — The balancing norm. **DECIDED (§19.1); price in §3.7.**
Retained as an obstacle only in this respect: the sieve route's admissible window
$n^{1/(2s)}\ll L_x\ll n^{1/2}$ requires $s>1$, and $s$ is the same smoothness that A2 and the rate condition
draw on. **The three conditions compete for the same $s$ budget; state them together, not in three places.**

### O-3 — `prp:effbound` needs a projection onto a sum space
Sum-space tangent structure plus the infinite-dimensional $\varphi$-direction; the projection inherits the
ill-posedness. Scope at F3+F4 with L-16, L-17.

### O-4 — Differentiating through the indicator
In `lem:adjoint`, not `prp:orthog`; on $f_{\Delta Y\mid X_1,X_2,\Delta Z,W}$, $C^1$ in $u$; `assapp2`
insufficient.

### O-5 — A2 ∧ A4: point identification needing unbounded weights is not $\sqrt n$
The $\varrho(1-\varrho)$ mechanism; A2 can hold while $E[\widetilde W^2\ell_\star^2]=\infty$. State A2′;
A4 sufficient for it; report the overlap diagnostic; T3 as fallback; Escanciano (2022) vocabulary. L-16's
selection freedom also bears (CP-6).

### O-6 — `lem:bierens` for the derivative family
P1(i) needs no equivalence there; $\ell\mapsto L$ is a bijection modulo integrability and L-2 gives density.
**§19.3 drops the strict inclusion, so this obstacle is now purely technical.**

### O-7 — `cor:trend` is a corollary of A2, not A3 — **and A3 is vacuous when A2 fails**
A3 involves $\ell_\star$, which does not exist without A2. State A3 as conditional on A2; probe A2.

### O-8 — Pathwise differentiability at the boundary of A2
State which side the assumptions place the model.

### O-9 — `lem:shiftinv`'s converse is too strong; **O-10** — `rem:nophifree`'s selection-bias clause is asserted
Add a genericity qualifier; demote to a worked example.

### O-11 — The impossibility result creates the quadratic remainder. **A result; keep.**
If $\ell$ were constant in $u$, N1 with $E[\Delta U\mid\Delta Z]=0$ gives $L(u,z)=\ell(z)u$, so
$\psi=\{\Delta Z+\widetilde W\ell(\Delta Z)\}\Delta U$ — a $(W,\Delta Z)$-measurable weight, forbidden by
`rem:nophifree`. **Hence $\partial_u\ell_\star\not\equiv0$ and $Q(h)\neq0$ necessarily.** Round 3 completes
the chain: O-11 says the quadratic term must exist; `prp:sharpquad` says it cannot be improved.

### O-12 — `prp:plugin`'s constant diverges
$O(\sqrt{m_n})$ (`engl2000` Ch. 6); needs $\sqrt{m_n}n^{-1/2}=o(\delta_n)$.

### O-13 — The propensity is the binding component of $\hat\delta_n$. **Costed (M-8).**
$\hat\delta_n^{(\varrho)}=O_P(n^{-r/(2r+d_Z)})$ dominates $\hat\delta_n^{(T)}=O_P(n^{-1/2}\sqrt{\log n})$.
$r>d_Z/2$ is required for $o(n^{-1/4})$. **This is the price of §17's conditional route and the narrowest
version of rebuttal leg 2.**

### O-14 — The balancing solve is a second ill-posed inversion
`orthogonal_theta.R:197` is Tikhonov on the empirical form with its own $\rho$. L-13 required; L-7 must carry
the ridge bias; §3.2's leg (i) restated (m-14); $\rho$ needs a rate (SG-17). **Note this survives §19.1: the
sieve form of plan §15 solves an $L_x\times L_u$ system by truncated SVD, which is the same regularisation
question in a different guise — the truncation level replaces $\rho$.**

### O-15 — The selection of $\ell_\star$ — **RE-AIMED at $M$**
The selection determines the variance, the sharp constant $\|M/\pi\|_\infty$, and whether $M\equiv0$ is
achievable at all. Until the criterion is fixed, statements about $M$, $q$ and A2′ are not well-defined. Fix
it in `prp:orthog`.

### O-16 — `prp:sharpquad`'s own conditions. **NEW.**
The result is only as good as L-20's hypotheses: $q$ bounded (needs L-21), $qf_{X_1X_2}\in L^2$,
$f_{X_t}/\pi$ bounded, and $\pi$ non-atomic with $M\not\equiv0$ on a set of positive measure. **The last is
the one to check in the application, because $M\equiv0$ is exactly the escape hatch of lever 1** — the same
condition appears as a hypothesis of the negative result and as the target of the design lever. Say so; it is
the cleanest way to present both.

---

## 6. Fallback weaker claims

### 6.1–6.4 `lem:shiftinv`, `lem:bierens`, `lem:adjoint`, `rem:nophifree`
As round 2, with one change: **`lem:bierens` is at F4 by decision (§19.3)**, not by retreat — strict
inclusion dropped, density and equivalence retained.

### 6.5 `prp:sharpquad` — NEW
- **F1.** Both forms: constructive sequence **and** the Weyl/essential-spectrum statement, with the exact
  constant $\tfrac12\|\mathcal B_{\rm sym}\|$.
- **F2 (safe).** Lower bound only: exhibit the sequence and conclude $\sup_{\|h\|\le\delta}|Q(h)|\ge c\delta^2$
  for some $c>0$. Loses the exact constant, keeps the necessity statement — **which is all `thm:rootn` needs.**
- **F3.** Statement conditional on $M\not\equiv0$, verified numerically in the application rather than
  assumed. Weakest, still publishable as a remark.

### 6.6 `prp:phirate` and `thm:rootn` — the ladder, with Q-c removed

| Tier | Claim | Requires | Status |
|---|---|---|---|
| **T1** | $\sqrt n(\hat\theta-\theta_\dagger)\xrightarrow{d}N(0,J^{-1}\Sigma J^{-1\prime})$ | A1–A5, A6, A7, N1, A2′; $\delta_n=o(n^{-1/4})$; §3.7's $L_x$ window | **The target, at plan §2.6's scope.** Mild ill-posedness, $s>a+\tfrac12$. |
| ~~T1′, T1″~~ | ~~Q-c1, Q-c2 rungs~~ | — | **WITHDRAWN (C-3).** Both conditions are empty unless $M\equiv0$. |
| **T2′** | **Rate theorem with concrete $\delta_n$:** $\hat\theta-\theta_\dagger=O_P\big(n^{-1/2}\vee\delta_n^2\vee\delta_n\epsilon_n\vee r_n\epsilon_n\vee r_n\delta_n\vee L_x^{-s}\big)$, with $\delta_n$, $\hat\delta_n$, $\epsilon_n$ mapped to $(\mu,\mu',r,d_Z,s)$ by `prp:phirate`, L-13 and §3.7 | A1–A5, A6, A7, N1, A2′ | **The floor**, and a result rather than bookkeeping because the rates are in primitives. |
| **T3** | T1 for a **trimmed** estimator with an explicit trimming-bias term | A4 relaxed | Fallback for O-5. |
| ~~T4~~ | ~~naive S-set~~ | — | **WITHDRAWN (C-2).** |
| **T4′** | **Profiled** S-set with its uniform-entropy condition | uniform control over a $\varphi$-sieve | **Recommend not writing it.** Note that L-19 already concedes a uniform LLN, so the *distance* between the paper and T4′ is smaller than round 2 implied — but T4′ needs uniformity at $\sqrt n$ scale, which L-19 does not give. |

**Floor: T2′ + T3.** When A2 fails, report the Picard diagnostic (L-15) and the plug-in at its slower rate
(the plug-in *rate* survives A2's failure, bias $\le\|\nu\|\delta_n$; only pivotal inference does not), and
**decline pivotal inference** — plan §12 is not implementable as written (§9 item 6).

### 6.7 `prp:effbound` — F3+F4 from the start
F3 **the bound is finite iff A2′** (Severini–Tripathi analogue) as headline; F4 **optimal instrument within
the class** over L-16's affine set as companion; F1/F2 not promised; F5 the floor. Supports: L-16, L-17.

### 6.8 `prp:plugin`, **6.9 `cor:trend`** — as round 2 (F2 and F1 respectively).

---

## 7. Simulation grid

| # | Design / quantity | Tests | Notes |
|---|---|---|---|
| SG-1 | $\varphi$ linear; $U$-shaped; A2-violating | `thm:rootn`, `cor:trend` | Diagnostic is A2, not A3 (O-7). |
| SG-2 | $n\in\{250,500,1000,2000,4000\}$; scaled RMSE flat | the rate | $n=1000$ mandatory. |
| SG-3 | Coverage of the sandwich interval | T1 | S-set row withdrawn with T4. |
| SG-4 | vs alternating estimator and TSLS | positioning | Plan §8, §12. |
| SG-5 | $\varrho$ genuinely non-constant | the §17 amendment | Plan §17.6. |
| SG-6 | Fixed grid $\mathcal T_K$ vs growing $\mathcal T_{K_n}$ | §3.2, Domínguez–Lobato | Do not invoke D–L while using a fixed grid. |
| SG-7 | **Severely ill-posed design** | O-1, the scope statement | **Expectation restored to round 1's:** the theorem should **fail** here. Pre-registered criterion retained — scaled RMSE rising over $\ge3$ consecutive $n$ by more than $2\times$ MC s.e. |
| SG-8 | $\|h\|_{L^2(\pi)}$ and $\|\mathcal Ah\|$ | `prp:phirate` | $\|h\|_{\mathcal H}$ row dropped with the RKHS option. |
| SG-9 | **Sieve balancing: sweep $L_x$ across the window $n^{1/(2s)}\ll L_x\ll n^{1/2}$** | §3.7, §19.1 | **Re-aimed:** no longer a Gaussian/Matérn/sieve comparison but a test of the decided option's price. Report bias vs $L_x$ and exhibit both failure modes (approximation for small $L_x$, conditioning for large). |
| SG-10 | Solve-fold balancing residual vs its population version | L-7 | Show the empirical residual is $O_P(n^{-1/2})$ + truncation bias + $\hat\ell$-error in population. |
| SG-11 | Overlap sweep, $\varrho\to0$ on an identifying subregion | O-5, A4 | $E[\widetilde W^2\hat\ell^2]$ growing while A2 formally holds. |
| SG-12 | Discrepancy principle vs argmin stopping | §3.3, §19.2 | The theorem is stated for the DP. **Also report how often the DP fails to stop** — the A7 condition. |
| SG-13 | $K=5$ vs $K=2$ | cross-fitting | Plan §8. |
| SG-14 | MC error budget: coverage s.e. $<1$ pp, stated | critic gate | Plan §8. |
| **SG-15 (RE-AIMED, m-16)** | **Sweep $\|M/\pi\|_{L^\infty}$ across selections in $\ell_\dagger+\ker\mathcal A^\ast$; and search for a selection with $M\equiv0$ or $q\equiv0$** | §3.5 lever 1, L-16, O-15 | **The right object.** Two deliverables: (a) does the sharp constant fall materially across selections — the design gain that pays even when infeasible; (b) a numerical verdict on the $M\equiv0$ feasibility problem, reported as evidence, not proof. |
| **SG-16 (REPAIRED, m-9)** | **Test-sequence divergence: $Q(h_k)/\|\mathcal Ah_k\|^2$ and $Q(h_k)/(\|h_k\|\|\mathcal Ah_k\|)$, in $k$ AND in mesh refinement** | `prp:sharpquad` | **Round 2's Picard comparison cannot work**: every discretised $\mathcal B_n$ is finite-rank, so it confirms A2″ spuriously at any mesh. The valid test is divergence along the explicit sequence, in both limits. **This is the falsification test for the paper's new headline.** |
| SG-17 | Truncation level / $\rho$ sweep in the balancing solve | O-14, L-13 | Under §19.1 the truncated-SVD level replaces $\rho$; exhibit its semiconvergence. |
| SG-18 | Stopping index by MISE vs by remainder | exploratory | **Demoted:** lever 2 is withdrawn, so this no longer tests a stated claim. Keep as exploration; do not report as evidence for the stopping rule. |
| SG-19 | $\sigma_j(\mathcal A_{\rm avg})/\sigma_j(\mathcal A_{\rm cond})$ | §3.6 | **Optional** under §19.3; run only if the position on the inclusion is revisited. |
| **SG-20 (REPAIRED, m-10)** | **$\hat\delta_n^{(\varrho)}$ against $n^{-1/4}$, sweeping $d_Z\in\{3,4,5\}$ and the propensity estimator's effective smoothness $r$** | O-13, §3.3 Step 1b | **Round 2's pre-registration was arithmetically false** — "order 2 fails $n^{-1/4}$" needs $d>4$; at $d=1$ order 2 gives $n^{-2/5}$, at $d=3$, $n^{-2/7}$, both clearing. **The binding component is the propensity, not the residual kernel.** Pre-registration: the crossing occurs at $r=d_Z/2$; designs with $r<d_Z/2$ should show $\sqrt n$ failure. |
| **SG-20b (NEW)** | Kernel order 2/4/6/8 in the residual direction vs finite-sample collapse of the $W$-contrast | plan §16.1 | **Separated from SG-20 deliberately.** §16.1's finding is a **finite-sample bias-dominance** phenomenon at a particular bandwidth, not an asymptotic rate failure — at $d=1$, order 4 already suffices asymptotically. The round-2 "order-8 coherence" claim is withdrawn; this design reports the finite-sample fact on its own terms. |

Invariants: `INV-14` (one `set.seed()`), `INV-15`, `INV-16` (`here()`), `INV-13` (bare `tabular`).

## 8. Counterexample probes

| # | Probe | Expected outcome |
|---|---|---|
| CP-1 | $\nu\equiv0$ | **Captured.** $\ell_\star=0$, moment degenerates to OLS; A3 must hold. |
| CP-2 | $\mathrm{Cov}(W,\Delta Z)=0$, $\varrho$ constant | **Captured.** N1 vacuous; degenerates gracefully. |
| CP-3 | $\varphi$ linear, no differential $X$-drift | **`cor:trend`; probe A2, not A3** (O-7). |
| CP-4 | $\nu\notin\mathcal R(\mathcal A^\ast)$ | **Genuine $\sqrt n$ failure**; exhibit the slower rate. |
| ~~CP-5, CP-5b, CP-10~~ | ~~rung-conditioned probes~~ | **WITHDRAWN** — conditioned on a rung structure that no longer exists. Replaced by CP-12. |
| CP-6 | $\varrho\to0$ on an identifying region, A2 formally holds | Irregular identification; excluded by A2′. **Also test whether a different $\ell_\star$ restores finite variance** (L-16). |
| CP-7 | $\varphi_\dagger$ rougher than the sieve's approximation class | **RE-AIMED to §19.1:** the $L_x$ window of §3.7 closes; bias no longer $o_P(n^{-1/2})$. Replaces the RKHS-membership probe. |
| CP-8 | TCC violated **for $\hat T$** | LF stalls or diverges; `prp:phirate` must not claim a rate. **Re-aimed at the random operator (M-7).** |
| CP-9 | $\ell_\star$ solves the adjoint equation but $\partial_u\ell_\star$ unbounded | $Q$ uncontrolled; must be excluded by A2′ via **L-21**, not by Picard. |
| CP-11 | Reading-(a) comparison: $\varrho$ non-constant, unconditional operator | **Exhibit non-nestedness**, supporting §19.3's "heuristic, not an inclusion" caveat. |
| **CP-12 (NEW)** | **$M\equiv0$ by construction** (a DGP engineered so the selected $\ell_\star$ has $q\equiv0$) | **The probe for `prp:sharpquad`'s own hypothesis (O-16).** Here $Q\equiv0$ and $\sqrt n$ should hold at any $\delta_n=o(1)$. If the theory does not degrade gracefully to this case, the sharpness statement is mis-stated. **The only probe that could reopen the scope.** |
| **CP-13 (NEW)** | **A7 violated:** $\hat\delta_n$ set below the true noise level | The discrepancy principle never stops; $\hat\varphi$ is the iteration cap. Must be excluded by A7, not assumed away. |

---

## 9. Escalation register

| # | Item | Where | Nature | Status / requested action |
|---|---|---|---|---|
| ~~**1**~~ | ~~Amend plan §2.6 with the three-rung ladder~~ | plan §2.6 | — | **WITHDRAWN BY THE STRATEGIST.** The ladder is empty (C-3). The coordinator's non-execution was correct. **Replacement request:** replace §2.6's "severity under review" block with the **sharpness statement** of `prp:sharpquad`, and strike both the refuted "one piece is free" sentence and the $\kappa_n^{-1}$ echo. |
| **2** | `prp:phirate` absent from §2.7 | plan §2.7, §2.6b | MISSING TARGET | Add as `prp-phirate.tex`, between `prp:orthog` and `thm:rootn`. **Now also carries A6, A7 and L-19.** |
| ~~**3**~~ | Balancing norm | plan §15 | — | **DECIDED — plan §19.1: sieve / $L^2$.** Priced in §3.7; RKHS out; code moves back. |
| **4** | `cor:trend` ← A2, not A3; **A3 vacuous when A2 fails** | plan §7 | CORRECTION | Reword probe (iii); state A3 conditional on A2. |
| **5** | Plan §7's regularity priming misplaces the interchange and names $f_U$ | plan §7 | CORRECTION | Reword; strengthen `assapp2`. |
| **6** | **Plan §12's "slower rate with robust intervals" is not implementable** | plan §12 | GAP | Replace with: report the Picard diagnostic and the plug-in at its slower rate (**the rate survives; only pivotal inference does not**); decline pivotal inference. *Note the ambiguity:* "robust intervals" could mean identification-robust or merely conservative SEs; this reads it the harder way, which is the binding one. |
| ~~**7**~~ | Stopping rule | plan §16.3 | — | **DECIDED — plan §19.2: discrepancy principle.** **But the reason changed** (§3.3): round 2's justification died with Q-c2; the surviving reasons are `hanke1995`'s nonlinear theorem (modulo M-7) and the argmin rule's lack of any theorem. Record the new reason. |
| ~~**8**~~ | "Unconditional" ambiguity | plan §2.4 vs §17.3 | — | **DECIDED — plan §19.3: unconditional framing kept as motivation; strict inclusion dropped.** §3.6 carries the required caveat text and prices what is lost. |
| **9** | positioning §3 Competitor 3 legs 2 and 3 | Stage 1 artifact | PRECISION ×2 | Restate both per §3.4. **Leg 3's restatement now concedes a uniform LLN and says which one** — do not let the manuscript claim "no empirical process theory." |
| **10** | positioning §4's "LR correction for $\varrho$ in the sandwich" contradicts P1(iii)/N1 | Stage 1 artifact | CORRECTION | Flag for the writer. |
| **11** | Plan §2.6's $\kappa_n^{-1}$ echo | plan §2.6 | WITHDRAWAL | Strike. **Tail caveat: sub-polynomial, not logarithmic** (m-15). |
| **12** | Notation collisions (now five) | plan §1 + code | NOTATION | Fix before any `.tex`; add $\nu_g$ vs $\sigma_g$. |
| **13 (NEW)** | **`prp:sharpquad` is a new target absent from §2.7** | plan §2.7 | **MISSING TARGET** | Add as `prp-sharpquad.tex`, immediately after `rem:nophifree` (they share the $\sigma_g$/$\nu_g$ algebra and O-11 is the bridge). **This is the result the coordinator identified as worth more than the ladder.** |
| **14 (NEW)** | **A6 (random TCC) and A7 (stopping feasibility)** are not in plan §6's assumption list | plan §6 item 7 | **GAP (M-7)** | §6 item 7 anticipates the TCC but for the *deterministic* operator. Add both, and record that Dunker et al. (2014) supplies the noise model even though IRGN is not the regulariser. |
| **15 (NEW)** | **The three smoothness budgets compete** | plan §2.6b, §6 | COORDINATION | A2's source index, the rate condition's $\mu$, and §3.7's $L_x$ window all draw on $\varphi_\dagger$'s smoothness $s$. State them together in `assumptions.tex`, not in three separate places, or the block will look weaker than it is. |

---

## 10. Order of work and gates

| Step | Produce | Gate |
|---|---|---|
| 0 | **Resolve §9 items 1 (replacement request), 2, 13, 14 with the user.** Items 3, 7, 8 are decided (§19). | — |
| 1 | Missing operator equation (draft `:120–122`); notation (§9 item 12). | — |
| 2 | `lem:shiftinv` (F2); `lem:bierens` (F4 per §19.3) + L-2, L-3. | Fixes the index set. |
| 3 | `lem:adjoint` + L-1 (now with $\sigma_g$), L-4, L-5; `rem:nophifree` + **O-11's corollary**. | SymPy specs for the adjoint and $J$. |
| 4 | **`prp:sharpquad`** + L-20, L-21. ~~**Do this before `prp:orthog`** — it determines the scope, and L-21's primitives are what make A2′ statable.~~ **STRUCK — see the ordering note below.** | The paper's new headline. |
| 5 | **L-16** (re-aimed at $\mathcal S$), then `prp:orthog` in sieve form + L-6, L-7, and §3.7's $L_x$ window. | §19.1 in force. |
| 6 | `prp:phirate` + L-18, **L-19**, L-12, L-13; A6, A7. TCC route (a) for $\hat T$, **one round only**. | Where leg 3 is delivered. **Top risk.** |
| 7 | `thm:rootn` at **plan §2.6's scope**, T2′ as the floor; + L-8…L-11, L-14. | theorist-critic $\ge80$; `/audit --all`. |
| 8 | `prp:effbound` at F3+F4 with L-16, L-17; `prp:plugin` at F2; `cor:trend` at F1. | — |
| 9 | Hand off to `/simulate` (§7, 21 designs) and `/audit --counter` (§8, 11 probes). | Verdict "Matches" or "Matches at large $n$ only". |

**Ordering note — Step 4 ran after Step 5, and the instruction that said otherwise is struck.** This
records escalation **N-20** and the coordinator's resolution (a), on the record. Step 4's ordering
instruction was written on the premise that *"L-21's primitives are what make A2′ statable"*, and that
premise is false as stated. **A2′(i.a)–(i.b) is a *stated assumption*; L-21 derives it from a source
condition rather than being needed to state it.** Step 5's results carry A2′(i), or the generic-representer
predicate A2b, as an **explicit hypothesis** throughout — `cor:elldiff`, `lem:solset`, `lem:secondord`,
`prp:orthog`(ii)–(iii), `lem:balance` — so nothing was assumed silently, which is exactly why the
theorist's response to the ordering conflict ("state every hypothesis explicitly so nothing is hidden")
was the right one and why the deferral was sound.

**But the concern had real content, and the dependence direction should not have to be reconstructed.**
`eq:Wderiv`, `cor:elldiff`, and the $\|\partial_u\ell_\star\|_\infty$ that `lem:secondord`(i) and
`lem:solset`(iii) consume **all rest on A2′(i.b)**, and all were written and closed at Step 5 before
Step 4 ran. **L-21 — now `lem:reprsmooth`, on the new property tag A2c — therefore retroactively
discharges what Step 5 assumed.** That is stated plainly at the head of `results.tex` Part G and at
`rem:obligations`(O1), which is now marked DISCHARGED with the meaning of "discharged" spelled out:
A2′(i) remains a maintained assumption and stops being an unverifiable primitive.

**Gate to Stage 3 (`/prove`):** strategist-critic $\ge80$ on this memo.

---

## Appendix A — disposition of every round-2 review finding

| ID | Finding | Disposition |
|---|---|---|
| **C-3** | A2″ unsatisfiable; both Q-c rungs collapse; Q-a order-sharp | **ACCEPTED IN FULL, verified independently.** Rungs withdrawn (§3.5, §6.6); scope reverted to plan §2.6; **§9 item 1 withdrawn by the strategist**; the counterexample converted into `prp:sharpquad` with the **exact constant** via Weyl (§2.5, §3.5); lever 1 re-aimed at $M$ and posed as a linear feasibility problem with three carried observations; lever 2 withdrawn; SG-16 repaired to the test-sequence form; CP-5/5b/10 withdrawn, CP-12 added. |
| **M-6** | The Q-c2 bound does not follow from the Q-c2 condition | **ACCEPTED.** Recorded in §3.5; the delivering condition would be the form inequality. Noted that Q-c1's derivation was correct as written. |
| **M-1** | Leg 3 still a relocation | **ACCEPTED and CLOSED** by **L-19** — uniform LLN with a rate over a slowly growing ball containing the LF path — **plus** a narrowed restatement (§3.4) that concedes an entropy bound and names it. Both routes the coordinator offered, taken together. |
| **M-7** | DP assumes an exactly known operator | **ACCEPTED.** A6 (random TCC) and A7 (stopping feasibility) added; **Dunker et al. (2014) upgraded from IRGN fallback to the noise model**; §9 item 14; CP-8 re-aimed; CP-13 added. |
| **M-8** | $\hat\delta_n$ dimension count | **ACCEPTED.** $d=1$ for the operator component, $\hat\delta_n^{(T)}=O_P(n^{-1/2}\sqrt{\log n})$ — which also explains plan §16.1's $n^{-1/16}$ bandwidth. **$\hat\varrho$ costed for the first time**: $r>d_Z/2$. Order-8 coherence claim withdrawn; SG-20 repaired and SG-20b split off. |
| **M-9** | SCDR precedent is a category error | **ACCEPTED and WITHDRAWN** (§3.8). No replacement offered; the absence of a precedent for weak-norm bounding a square is noted as consistent with `prp:sharpquad`. |
| **m-9** | Picard diagnostic ill-defined for non-compact $\mathcal B$ | **ACCEPTED.** SG-16 rebuilt on the test sequence; the warning carried to the $M$-feasibility test (§3.5 obs. 4). |
| **m-10** | SG-20 arithmetically wrong | **ACCEPTED.** Repaired and re-aimed at the propensity; SG-20b added for the finite-sample kernel-order fact. |
| **m-11** | Two unreconciled values for $\|\mathcal Ah\|$ | **ACCEPTED.** Moot with the rungs gone; reconciled once in §3.3 Step 2 — the DP value is operative, the NPIV minimax weak rate is what an oracle-tuned estimator would give. |
| **m-12** | $\mathcal B$ boundedness; $L^2(\pi)$ vs $L^2(dx)$ | **ACCEPTED.** **L-20** states the conditions ($q$ bounded, $qf_{X_1X_2}\in L^2$, $f_{X_t}/\pi$ bounded) and resolves the mismatch by carrying $m=M/\pi$. |
| **m-13** | L-15 omits $\nu\perp\ker\mathcal A$ | **ACCEPTED.** Added as the first of two clauses. |
| **m-14** | §3.2 leg (i) self-undermining | **ACCEPTED.** Restated as "no weighting-measure choice is required"; the other two legs retained. |
| **m-15** | $\kappa_n$ tail | **ACCEPTED.** Sub-polynomial, with the Gaussian example. |
| **m-16** | SG-15 sweeps the wrong object | **ACCEPTED.** Re-aimed at $\|M/\pi\|_\infty$ and the $M\equiv0$ search. |
| **m-17** | §0.3 downgrade; item 3 undecidable | **ACCEPTED.** `thm:rootn` restored to MEDIUM *as scoped* with the scope named as the cost; top risk moved to `prp:phirate`; item 3 priced in §3.7 by the bias bound each option yields. |
| **m-18** | $\mathcal Q$ not compact; Q-b residue | **ACCEPTED.** Lever 2 withdrawn; residue corrected to $O(\|h\|^2_{L^2})$, making the split strictly worse than the direct bound. |

## Appendix B — the seven round-1 obstacles, closing status

1. **Nonlinear Landweber.** `prp:phirate` with a four-step route; **A6/A7 for a random operator**; DP decided
   (§19.2) with a **new reason** on the record.
2. **The weighting measure $\mu$.** Drops out of the $\theta$-side; finite growing family on the
   $\varphi$-side; the anti-CGMM argument now rests on "no weighting-measure choice is required."
3. **Chen & Pouzo.** Legs 1, 2, 4 delivered; **leg 3 closed by L-19 and narrowed honestly** — a uniform LLN
   at rate $\hat\delta_n\gg n^{-1/2}$ over a slowly growing ball, not stochastic equicontinuity at the
   estimated point at $\sqrt n$ scale.
4. **Differentiating through the indicator.** In `lem:adjoint`; $C^1$ in $u$ for the conditional density
   given the endogenous regressors; `assapp2` insufficient.
5. **A2 ∧ A4.** The $\varrho(1-\varrho)$ mechanism; A2′ with the finite-variance clause; **L-21 supplies the
   sup-norm primitives Picard cannot**.
6. **`lem:bierens` for the derivative family.** No equivalence needed; strict inclusion **dropped by
   decision** (§19.3), with the cost stated rather than hidden.
7. **`cor:trend`.** A corollary of A2, and **A3 is vacuous when A2 fails** — not merely the wrong assumption
   to probe, an empty one.
