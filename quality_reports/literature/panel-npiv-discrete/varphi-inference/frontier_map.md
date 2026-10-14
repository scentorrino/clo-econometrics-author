# Frontier Map — Inference on $\varphi$ in a Nonlinear Ill-Posed NPIV Problem

**Project:** `panel-npiv-discrete` · **Sub-review:** `varphi-inference` · **Compiled:** 2026-08-03

---

## 1. The frontier, drawn on the two axes that matter

The literature does not split on "linear vs nonlinear" alone. It splits on **two independent axes**, and the paper sits in the one cell where neither existing technology reaches.

| | **Deterministic regularisation index** ($k(n)$, $\alpha_n$ fixed sequences) | **Data-driven / random regularisation index** |
|---|---|---|
| **Linear operator** (conditional mean) | Babii (2020) — honest sup-norm bands, Tikhonov. Horowitz & Lee (2012) — sieve bands, dishonest and says so. Chen & Christensen (2018) — bands for nonlinear *functionals*. | **Chen, Christensen & Kankanala (2025)** — honest, near-adaptive UCBs via bootstrapped Lepski. *This is the frontier cell on the linear side.* |
| **Nonlinear operator** (full independence, quantile IV) | **Chen & Pouzo (2015)** — pointwise CIs and SQLR sets for evaluation functionals; NPQIV worked and illustrated. Monard–Nickl–Paternain (2021) — BvM for smooth **linear functionals** only. Dunker (2014, 2015), Dunker (2021) — **rates only**. | **EMPTY.** Nothing found. |

**The paper is in the bottom-right cell**: nonlinear operator equation from a conditional-independence restriction, Landweber–Fridman with a **discrepancy stopping rule**, i.e. a random regularisation index.

---

## 2. What has been done

### 2.1 Uniform bands exist, but only for linear operators

Three constructions, in increasing order of what they guarantee:

1. **Horowitz & Lee (2012).** Pointwise intervals on a grid, interpolated. Explicitly **not asymptotically exact** for finite grid size; they say so in their own introduction. Linear NPIV, continuous instrument.
2. **Babii (2020).** **Honest** sup-norm bands via a data-driven concentration inequality and via CCK coupling. Requires a source condition with known exponent, completeness, *and* a restriction on the operator class. Width $=O(1/(\alpha_n\sqrt{nh^q_n}))$ — the variance rate inflated by $1/\alpha_n$, with the bias killed by tuning rather than subtracted.
3. **Chen, Christensen & Kankanala (2025).** **Honest and near-adaptive**, sup-norm, via a bootstrapped Lepski procedure over the sieve dimension. Explicitly beats undersmoothing. Minimax contraction up to a log factor.

All three: linear operator, conditional-mean restriction, deterministic-or-Lepski-selected sieve/Tikhonov index.

### 2.2 Pointwise inference exists for nonlinear operators

**Chen & Pouzo (2015) is the fact that reorganises this whole question.** Their model (1.1) is explicitly allowed to be "nonlinearly ill-posed"; the point-evaluation functional $\phi(\alpha)=h(\bar y_2)$ is explicitly in scope; NPQIV — a genuinely nonlinear ill-posed problem — is the worked example, with an empirical illustration on Engel curves in their §7.2. They deliver pointwise CIs two ways: a sieve $t$/Wald statistic with a closed-form plug-in variance, and an SQLR set inverted with a **generalized residual (multiplier) bootstrap**, which needs no standard errors and works for irregular functionals.

So the answer to "is there ANY inference procedure for the nonparametric component of a nonlinear ill-posed inverse problem" is **yes, and it has been in Econometrica since 2015.** The plain-statement version the brief asked for is *not* "nothing exists."

### 2.3 Outside econometrics, the same boundary appears independently

Monard, Nickl & Paternain (2021) is the state of the art for UQ in nonlinear inverse problems on the mathematics side. Their guarantee is a Bernstein–von Mises theorem yielding valid frequentist confidence sets for **smooth linear functionals** $\langle\theta,\psi\rangle$ at the semiparametric rate — obtained by **linearising the nonlinear forward map at the truth** and requiring the resulting information operator $\mathbb I^*_{\theta_0}\mathbb I_{\theta_0}$ to be invertible on a large enough range. Nothing for the full function.

**This is a striking convergence.** Two literatures, different tools, same boundary: for a nonlinear ill-posed problem you can have valid inference on the regular, root-$n$, finite-dimensional part, and that is where it stops. The present paper's theorem — $\sqrt n$ for $\theta$, silence on $\varphi$ — is not an incompleteness. **It is the frontier.**

### 2.4 The nonlinear-NPIV estimation literature has produced no bands

`dunker2014` (Dunker, Florens, Hohage, Johannes & Mammen), `dunker2015`, and `dunker2021` are the closest existing work to the paper's estimation problem: nonlinear operator equations from full independence or quantile restrictions, solved by iterative regularisation, with `dunker2021` even doing **adaptive** estimation. All three deliver rates. **None constructs a confidence set.** The numerical-analysis literature behind them (`kalten2008`, `hanke1995`, `engl2000`) is deterministic-noise and does not produce coverage statements at all; where it turns statistical (`bissantz2007`) it produces rates.

---

## 3. What the gap actually is

**Not** "no inference exists for nonlinear ill-posed problems." That is false.

The gap is the conjunction of three things, and each alone is handled somewhere in the literature:

| Ingredient | Handled by | Handled *together with* the others? |
|---|---|---|
| Nonlinear operator equation | Chen & Pouzo (2015); Dunker (2014, 2015, 2021); Monard–Nickl–Paternain (2021) | — |
| **Random (discrepancy-rule) regularisation index** | Chen, Christensen & Kankanala (2025), for a *linear* sieve index via Lepski | **No** |
| Conditional independence converted to a **continuum** of unconditional moments via a Bierens family | Continuum-of-moments GMM; the full-independence NPIV literature | **No** |

The binding one is the middle row. Chen–Pouzo's Assumptions 3.1(ii), 3.2, 3.3 and 3.4, Lemmas 3.1 and 3.2, and the sieve variance (2.6)/(2.10) are all indexed by a **deterministic** $k(n)$; Babii's Assumption 3.2(vi) fixes $\alpha_n\sim n^{-c_2}$ deterministically. A Landweber discrepancy stopping time is random, and the randomness is correlated with the data driving the estimator. Handling that is exactly the problem CCK (2025) solved for the linear sieve case with a bootstrapped Lepski argument — and it took a *Review of Economic Studies* paper to do it.

**Second binding constraint, specific to Babii.** Assumption 3.2(v) is completeness: "the integral operator $T:C[0,1]^p\to C[0,1]^q$ is 1-1." A binary instrument cannot deliver it. So Babii fails on **two logically independent grounds** — linearity and completeness — and either is sufficient. Babii himself names the escape hatch for the second (`babiiflorens2025`), which is already in the parent bibliography.

---

## 4. Where this paper fits

The paper does **not** need to fill this gap. It needs to **locate** itself relative to it, and the location is unusually favourable:

1. It proves $\sqrt n$ normality for $\theta$ — which is exactly the class of result the nonlinear inverse-problems frontier delivers (MNP 2021: smooth linear functionals, semiparametrically efficient, via linearisation).
2. It estimates $\varphi$ in a cell where **no** valid band exists in either literature, and the two nearest neighbours (`dunker2021`, and the author's own `centorrinofeveflorens2019`) both stopped at the same place.
3. It can say so in two sentences and move on, because **the author's own companion paper already set the convention at *Journal of Econometrics*.**

**This is a publishable observation in its own right**, and it costs one paragraph: *inference on the nonparametric component of a nonlinear ill-posed inverse problem with a data-driven stopping rule is open; the linear-operator technology (Babii 2020; Chen, Christensen & Kankanala 2025) does not transfer; the nonlinear-operator technology (Chen & Pouzo 2015) transfers only under a deterministic sieve index and a finite-dimensional conditional moment vector.*

---

## 5. Adjacent work to watch

| Paper | Why | Risk |
|---|---|---|
| van der Laan, Kallus & Bibaut (2025), arXiv:2505.07729 | Discrete instruments $+$ inference, very recent, three versions through Jan 2026 | **Low.** Instrument levels grow with $n$; operator linear; targets are linear functionals. Cite pre-emptively. |
| Lob, Singh & Vijaykumar (2025), arXiv:2511.21603 | Uniform confidence sets for kernel IV, "general nonlinearities" | **Unresolved — abstract only.** Almost certainly linear operator / nonlinear $h$, but **open it before deciding**. If it does handle a nonlinear operator it changes the frontier map. |
| Chen, Christensen & Kankanala (2025) follow-ups | The Lepski-bootstrap template a future companion paper would extend | Not a scoop; a roadmap. |

---

## 6. Confidence in this map

| Claim | Warrant | Strength |
|---|---|---|
| Babii requires a linear $T$ essentially | Assumption 3.1, Prop. 3.1, closed-form estimator — **read** in arXiv v4 | **High** |
| Babii additionally requires completeness | Assumption 3.2(v) — **read**, plus Babii's own commentary | **High** |
| Chen–Pouzo does *not* require a linear operator | Their own introduction, pp. 1–3 — **read** | **High** |
| Chen–Pouzo covers point evaluation | p. 2, and NPQIV worked at (2.22)–(2.23) — **read** | **High** |
| Chen–Pouzo's index is deterministic | Assumptions 3.1(ii)–3.4, (2.6)/(2.10) — **read** | **High** |
| CFF (2025) reported an invalid pointwise band with a caveat | R3 typescript — **read**; published PDF **not** checked | **High, with one verification outstanding** |
| MNP (2021) covers only linear functionals | pp. 1–3 — **read** | **High** |
| CCK (2025) is honest+adaptive for linear NPIV | **Abstract only** | Medium |
| Nothing exists in the bottom-right cell | **Negative evidence**: no such paper surfaced across econometrics and inverse-problems searches, and the three nearest papers (`dunker2014/2015/2021`) explicitly stop at rates | Medium-high — a negative claim, and it should be stated as "we are not aware of", not as "there is none" |
