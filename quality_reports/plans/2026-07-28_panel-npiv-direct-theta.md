# Plan — Panel NPIV with discrete instruments: direct $\sqrt{n}$ estimation of $\theta_\dagger$

**Status:** IN PROGRESS — approved 2026-07-28. See §15 for an amendment forced by implementation,
and **§17 for a user-directed change to Assumption A1 that supersedes the original §2.1–§2.5**.
Sections 1 and 2 below have been rewritten in place to match §17; read them as the current contract.
**Date:** 2026-07-28
**Project slug:** `panel-npiv-discrete`
**PROJECT_TYPE:** theory
**Source draft:** `/Users/samuele/Library/CloudStorage/Dropbox/Nonparametric_IV/Discrete Instruments/Nonparametric_Panel/Centorrino_panel.qmd`
**Companion paper:** the cross-sectional Centorrino–Fève–Florens paper, referenced in the draft as `@ass:condcomp`, `@ass:sourcecondID`, `@ass:differentiability`, `@ass:scalab`, `@sec:mcsim`

---

## 0. What this plan is

The source draft is a short companion note. Its Section 2 (Identification) is unfinished: it defers
"precise conditions for identification of the pair $(\vdagger,\theta_\dagger)$, and for the
$\sqrt{n}$-consistency of the estimator of $\theta_\dagger$" to future research, and its estimation
algorithm alternates between a Landweber–Fridman step for $\varphi$ and a least-squares step for
$\theta$ — an iteration that does not admit a clean asymptotic theory.

This plan replaces the deferred content with a complete treatment: a cross-fitted, Neyman-orthogonal
moment that estimates $\theta_\dagger$ at $\sqrt{n}$ without a joint iteration, plus the source
condition under which that rate is attainable. The empirical application (pollution and house prices,
$n=989$ U.S. counties) is **kept as drafted** and re-estimated with the new estimator.

Agents: read Sections 1–4 before doing anything. Sections 5–13 are the stage-by-stage instructions.

---

## 1. Model and notation contract

The notation-warden will enforce this table. Do not introduce a symbol that collides with it, and do
not silently rename. Macros come from `preamble.tex` in the source project: `\vdagger` $=\varphi_\dagger$,
`\IR`, `\un`, `\upmodels`.

| Symbol | Meaning | First defined |
|---|---|---|
| $\vdagger$ | true structural function, scalar argument | Section 1 |
| $\theta_\dagger \in \IR^p$ | true linear coefficient; $\Delta Z$ includes a constant (time trend) | Section 1 |
| $X_{it} \in \mathcal{X} \subset \IR$ | continuous endogenous regressor, $t\in\{1,2\}$ | Section 1 |
| $W \in \{0,1\}$ | discrete (binary) instrument | Section 1 |
| $\Delta Y, \Delta Z, \Delta U$ | first differences over $t$ | eq. `eq-mainmoddiffs` |
| $\Delta\varphi$ | shorthand for $\varphi(X_2)-\varphi(X_1)$ | Section 2 (new) |
| $\Delta U(\theta,\varphi)$ | $\Delta Y - \Delta\varphi - \Delta Z'\theta$ (residual at trial values) | Section 2 (new) |
| $\varrho(\cdot)$ | propensity score $E[W\mid\Delta Z] = P(W=1\mid\Delta Z)$ | Section 2 (§17) |
| $\widetilde{W}$ | $W - \varrho(\Delta Z)$ — **conditionally** centred (was $W - P(W=1)$; see §17) | Section 2 (§17) |
| $\nu(\cdot) \in \IR^p$ | $E[\Delta Z\mid X_2=x]f_{X_2}(x) - E[\Delta Z\mid X_1=x]f_{X_1}(x)$ | Section 2 (new) |
| $\Phi(\cdot)$ | bounded one-to-one transform of $\Delta Z$ (componentwise $\arctan$) — Bierens integrability device | Section 2 (§17) |
| $w(\cdot)$ | Bierens weight. **CORRECTED 2026-07-28 (Stage 3 C-1): $w=e^{s}$ is the maintained choice; $\cos$ and $\sin$ are NOT admissible in the intercept-free family.** With $\Phi$ odd (componentwise $\arctan$) and $w$ even, $\{w(t'\Phi(z))\}$ sees only the even part of the measure and the identification converse fails — take $V=\pm1$ equiprobable, $\varepsilon=V$: then $E[\varepsilon\cos(t\Phi(V)))]=0$ for every $t$ while $E[\varepsilon\mid V]=V\neq0$. General analytic non-polynomial $w$ is recovered only by the **intercept-indexed** Stinchcombe–White family $\{w(t_0+t'\Phi(z))\}$. | Section 2 (§17) |
| $t \in \mathcal{T}$ | Bierens index; $\mathcal{T}\subset\IR^p$ of positive Lebesgue measure | Section 2 (§17) |
| $\gamma$ | finite signed measure on $\mathcal{T}$ defining the correction (**was $\mu$** — renamed 2026-07-28, Stage 3 N-1) | Section 2 (§17) |
| $\mu$ | **RESERVED — source-condition index.** $\mu=s/(2a)$ under the Hilbert-scale link (`engl2000` §8.5). It appears in every rate display and in the propensity frontier, so it keeps the symbol; the Bierens measure was renamed to $\gamma$ instead. | Stage 2 memo §3.3 |
| $\sigma_q$ | the multiplication-operator symbol in $\mathcal B_{\mathrm{sym}}=\sigma_q\cdot-2\tilde{\mathcal K}$ (**was $M$** — renamed 2026-07-28, Stage 3 N-4, to avoid collision with $\mathcal M$) | §2.6 |
| $L(\cdot,\cdot)$ | debiasing weight on $(u,z)$, **$\IR^p$-valued** (corrected 2026-07-28, Stage 3 F-15 — the table never typed it, which licensed a glossary error; $\Delta Z\,\Delta U$ is $\IR^p$ so $\widetilde W L$ must be, and A2's own "each coordinate of $\nu/\pi$" presupposes it); normalised so $E[L\mid\Delta Z]=0$ | Section 2 (§17) |
| $\ell(\cdot,\cdot)$ | $\partial_u L$ — derivative of the debiasing weight in the residual, **$\IR^p$-valued** | Section 2 (§17) |
| $\mathcal{A}$ | $T'_{\vdagger,\theta_\dagger}$, the Fréchet derivative already derived in the draft | draft `:98–103`, `:124–126` |
| $\mathcal{A}^\ast$ | its adjoint, already derived in the draft | draft `:172–177` |
| $\pi$ | reference density on $\mathcal{X}$ | draft `:172` |
| $\kappa_n, \ell_n$ | **RESERVED** — already used in `assapp4`. Do not reuse $\ell_n$ for the debiasing weight. | draft `:294–299` |
| $p$ | **RESERVED** — $\dim(Z)$. Use $\varrho(\cdot)$ for a propensity score, never $p(\cdot)$. | draft `:69` |
| — | **CORRECTION 2026-07-28 (Stage 3 F-2):** this table previously also attributed draft `:302` to $p=\dim(Z)$. That is wrong — `assapp5`'s exponent there is $\dim(x)$, and since $X$ is scalar in the panel it equals **2**, not $\dim(Z)$. The mis-attribution was in the binding table and is struck. | draft `:302` |

Model in levels and first differences:

$$Y_{it}=\vdagger(X_{it}) + Z_{it}'\theta_\dagger + \eta_i + U_{it}, \qquad t\in\{1,2\}$$
$$\Delta Y_i = \vdagger(X_{i2}) - \vdagger(X_{i1}) + \Delta Z_i'\theta_\dagger + \Delta U_i.$$

---

## 2. The mathematical core

This is settled analysis. Agents implement and verify it; they do not need to rediscover it. The
theorist may sharpen statements, but any *departure* from the structure below is an escalation to the
user, not a judgment call.

### 2.1 The two restrictions

**Assumption A1 (exogeneity).** $\Delta U \upmodels W \mid \Delta Z$ and $E[\Delta U \mid \Delta Z] = 0$.

The independence is **conditional on $\Delta Z$** — this is the weaker of the two candidate
assumptions and it is the one the paper maintains. See §17 for why the original unconditional form
was abandoned. It matches the draft's own Assumption `ass:condind` (`:78–80`); what has to change to
restore internal consistency is the *operator* (`:124–126`), which currently centres $W$
unconditionally.

Under A1, with $W$ binary, the model is equivalent to

$$\text{(A)}\quad E\big[\widetilde{W}\,\lambda(\Delta U)\;\big|\;\Delta Z\big] = 0 \ \ \text{a.s., for every bounded }\lambda,
\qquad\qquad
\text{(B)}\quad E\big[\Delta Z\,\Delta U\big] = 0 ,$$

with $\widetilde{W} = W - \varrho(\Delta Z)$. Equivalence in (A): conditionally on $\Delta Z=z$,
$E[(W-\varrho(z))\lambda(\Delta U)\mid \Delta Z = z]$ factorises to
$E[W-\varrho(z)\mid z]\,E[\lambda\mid z] = 0$ under conditional independence; conversely, holding for
every bounded $\lambda$ forces the conditional law of $\Delta U$ given $(W,\Delta Z)$ not to depend on
$W$.

(A) is the distributional restriction the Landweber–Fridman algorithm exploits. (B) is an ordinary
$p$-dimensional moment.

### 2.2 Handling the conditioning without smoothing in $\Delta Z$ — the Bierens device

(A) is now a *conditional* moment restriction, so taken literally it requires nonparametric
conditioning on $\Delta Z$ and the operator would inherit dimension $1+p$. It is not taken literally.
By Bierens (1990) and Stinchcombe–White (1998), for each fixed $u$ the restriction
$E[\widetilde W\,\1{\Delta U \le u}\mid\Delta Z]=0$ a.s. is **equivalent** to the continuum of
*unconditional* moments

$$\mathcal{M}(u,t) \;:=\; E\big[\widetilde{W}\;\1{\Delta U \le u}\;w\big(t'\Phi(\Delta Z)\big)\big] \;=\; 0
\qquad \text{for all } t \in \mathcal{T},$$

for $w$ analytic non-polynomial and $\mathcal{T}$ of positive Lebesgue measure. $\Phi$ is a bounded
one-to-one transform (componentwise $\arctan$) so that $w=\exp$ is integrable without moment
conditions on $\Delta Z$ — do not skip $\Phi$, it is what makes the device unconditional on moments.

**Nothing is smoothed nonparametrically in $\Delta Z$.** Every element of the family is a plain
sample average. $\Delta Z$ enters the operator only through the scalar index $t'\Phi(\Delta Z)$, and
otherwise only through the scalar propensity $\varrho$. The operator remains indexed by
$(u,t)$ with $u$ scalar, so the existing LF machinery carries over with the index set enlarged.

**Lemma L1 (shift invariance) — retained, but its role has changed.** For every $\theta \in \IR^p$,
$$\Delta Y - \Delta\vdagger - \Delta Z'\theta \;\upmodels\; W \mid \Delta Z .$$

*Proof.* Write $R(\theta) = \Delta U + \Delta Z'(\theta_\dagger-\theta)$. On $\{\Delta Z = z\}$ the term
$z'(\theta_\dagger-\theta)$ is a constant, so for Borel $B$,
$P(R(\theta)\in B \mid W=w,\Delta Z=z) = P(\Delta U \in B - z'(\theta_\dagger-\theta)\mid W=w,\Delta Z=z)$,
which does not depend on $w$. $\square$

**Remark R1 (corrected).** L1 says (A) does not *identify* $\theta_\dagger$ — the set of pairs it
admits is $\Phi_{CI}\times\IR^p$. It does **not** say $\theta_\dagger$ is unidentified, and it does not
say (A) is useless. $\theta_\dagger$ is identified by (B):
$$\theta_\dagger = \big(E[\Delta Z\Delta Z']\big)^{-1}\,E\big[\Delta Z\,(\Delta Y - \Delta\vdagger)\big],$$
and (A) supplies the mean-zero family from which the Neyman correction is built. A debiasing term is
mean-zero at the truth **by construction** — that is what makes it a valid correction rather than a
new restriction — so "carries no information about $\theta$" is a property of every Riesz
representer, not a defect. The earlier version of this plan inferred from L1 that the conditional
assumption forces a two-step plug-in with no $\sqrt n$ theorem; that inference was wrong and is
withdrawn (§17).

What L1 *does* cost is over-identification. Under the unconditional assumption
$R(\theta)\not\upmodels W$ for $\theta\neq\theta_\dagger$ whenever $\Delta Z\not\upmodels W$, so (A)
would carry information about $\theta$ and deliver a testable restriction. Under A1 as now stated,
$\theta_\dagger$ is exactly identified by (B) and (A) is a pure debiasing device. Say so in the paper.

### 2.3 Why Robinson-style partialling out is unavailable

**Remark R2 (negative result — include in the paper).** A weight $g$ measurable with respect to
$(W,\Delta Z)$ yields a moment free of $\varphi$ for *every* admissible $\varphi$ if and only if
$$E[g\mid X_2=x]f_{X_2}(x) = E[g\mid X_1=x]f_{X_1}(x) \quad \text{a.e. } x,$$
i.e. if and only if the $g$-tilted marginals of $X_1$ and $X_2$ coincide. Taking $g\equiv 1$ requires
marginal stationarity of $X$; taking $g = \Delta Z$ requires $\nu \equiv 0$. Both fail in the
application — TSP fell sharply between 1970 and 1980. Weights that depend on $(X_1,X_2)$ directly
(matching on $X_{i1}\approx X_{i2}$, or crossed pairs) annihilate $\varphi$ mechanically but are
functions of endogenous variables, so they induce a selection bias of the same order as the parameter.

**There is therefore no exact $\varphi$-free moment.** Do not pursue one. The correct route is
orthogonalization plus cross-fitting.

### 2.4 The orthogonal moment

The correction is built from the Bierens family of §2.2. For a finite signed measure $\mu$ on
$\mathcal{T}$ and a weight $\lambda(\cdot,t)$, set
$$L(u,z) \;=\; \int_{\mathcal{T}} \lambda(u,t)\,w\big(t'\Phi(z)\big)\,\mu(dt),$$
and define, for a candidate $(\theta,\varphi)$,
$$\psi_i(\theta,\varphi,L) \;=\; \Delta Z_i\,\Delta U_i(\theta,\varphi)
\;+\; \widetilde{W}_i\,L\big(\Delta U_i(\theta,\varphi),\,\Delta Z_i\big) .$$
Both terms have mean zero at the truth for **any** $L$ in this class, by (B) and (A) respectively.

**Normalisation N1 (conditional centring).** $L$ is normalised so that
$E\big[L(\Delta U,\Delta Z)\mid \Delta Z\big] = 0$ a.s.

This is free: adding any $c(\Delta Z)$ to $L$ leaves $E[\widetilde W(L+c)] = 0$ and does not change the
$\varphi$-derivative, so $c = -E[L\mid\Delta Z]$ may always be imposed. It is not cosmetic — it is what
buys orthogonality in the propensity (see P1(iii)).

**Proposition P1 (Neyman orthogonality).** Write $\ell = \partial_u L$. Then:

*(i) In $\varphi$.* $E[\psi]$ has zero Gateaux derivative along every direction $h$ if and only if
$$E\big[\widetilde{W}\,\ell(\Delta U,\Delta Z)\mid X_2=x\big]f_{X_2}(x)
- E\big[\widetilde{W}\,\ell(\Delta U,\Delta Z)\mid X_1=x\big]f_{X_1}(x) \;=\; -\,\nu(x),$$
that is, if and only if $\mathcal{A}^\ast_{\mathrm{cond}} \ell = -\nu$. This is the draft's adjoint at
`:172–177` with $\widetilde W$ conditionally centred and $\ell$ now a function of $(u,z)$.

*(ii) In $L$.* $\partial_L E[\psi] = E[\widetilde{W}\,\delta L(\Delta U,\Delta Z)] = 0$ **exactly** at
the truth, for every admissible direction $\delta L$. So $\hat\theta$ is consistent for any $\hat L$;
the quality of $\hat L$ affects only the second-order remainder.

*(iii) In $\varrho$.* Perturbing $\varrho \to \varrho + \tau r$ gives
$\partial_\tau E[\psi] = -E\big[r(\Delta Z)\,L(\Delta U,\Delta Z)\big] = -E\big[r(\Delta Z)\,E[L\mid\Delta Z]\big]$,
which vanishes **under N1**. Without N1 the moment is *not* orthogonal in the propensity and $\hat\varrho$
would need a $\sqrt n$ rate. With N1 the estimator is Neyman-orthogonal in all three nuisances
$(\varphi, L, \varrho)$ and only product rates are required.

**Assumption A2 (source condition for $\theta$).** $\nu \in \mathcal{R}(\mathcal{A}^\ast_{\mathrm{cond}})$,
where the adjoint's domain is the closed span of $\{\lambda(\cdot)\,w(t'\Phi(\cdot)) : t\in\mathcal{T}\}$.

This is the Severini–Tripathi condition for $\sqrt{n}$-estimability of a linear functional in an
ill-posed problem. It is not a technical convenience: if it fails, no estimator of $\theta_\dagger$ is
$\sqrt{n}$-consistent. It should be stated in the same generalized-Fourier language as the companion
paper's `@ass:sourcecondID`, i.e. as a decay condition on the coefficients of $\nu$ relative to the
singular values of $\mathcal{A}$.

**Note that A2 is now *weaker* than in the unconditional version of this plan.** Exploiting the full
conditional restriction enlarges the family of available directions from $\{\lambda(u)\}$ to
$\{\lambda(u)w(t'\Phi(z))\}$, so $\mathcal{R}(\mathcal{A}^\ast_{\mathrm{cond}})$ strictly contains the
range of the unconditional adjoint. Conditioning costs an assumption on the design and a third
nuisance; it *buys* an easier source condition. Make this point explicitly in the paper — it is the
main technical argument for the conditional route.

**Assumption A3 (local rank).**
$E[\Delta Z\Delta Z'] + E\big[\widetilde{W}\,\ell_\dagger(\Delta U,\Delta Z)\,\Delta Z'\big]$
is nonsingular.

**Assumption A4 (propensity regularity).** $\varrho$ is bounded away from $0$ and $1$ on the support of
$\Delta Z$, and $\hat\varrho$ satisfies the product-rate condition of `thm:rootn`. Overlap is not
automatic here and must be checked in the application — CAAA attainment is far from balanced (689/300).

### 2.5 The estimator

Cross-fitting with a three-way split. Partition $\{1,\dots,n\}$ into $K$ folds; for each $k$ split the
complement $I_k^c$ into two halves $I_k^{c,\mathrm{op}}$ and $I_k^{c,\mathrm{sol}}$.

0. **Propensity stage** (on $I_k^{c,\mathrm{op}}$): fit $\hat\varrho^{(-k)}(\Delta Z)$ by ML
   (regularised logit / gradient boosting / random forest — the choice is free, only the rate matters)
   and form $\widetilde W_i = W_i - \hat\varrho^{(-k)}(\Delta Z_i)$ for every $i$ used downstream.
   This is the only object anywhere that takes $\Delta Z$ as a full vector argument, and it is a
   scalar-valued regression, not a conditional distribution.
1. **Operator stage** (on $I_k^{c,\mathrm{op}}$): estimate the densities and the operator
   $\widehat{\mathcal{A}}$, $\widehat{\mathcal{A}}^\ast_{\mathrm{cond}}$ on the $(u,t)$ index set.
2. **Solve stage** (on $I_k^{c,\mathrm{sol}}$): run Landweber–Fridman for
   $\widehat{\mathcal{A}}\hat\varphi = \hat r$ to get $\hat\varphi^{(-k)}$; obtain the debiasing weight
   $\hat L^{(-k)}$ by **kernel balancing, not by solving the adjoint equation** — see §15, which
   supersedes the original "run LF twice" instruction. Impose N1 as a linear constraint in the
   balancing solve (residualise $\hat L$ against a $\Delta Z$-basis), otherwise P1(iii) fails.
3. **Moment stage** (on $I_k$): accumulate $\psi_i(\theta,\hat\varphi^{(-k)},\hat L^{(-k)})$.

Then $\hat\theta$ solves $\frac{1}{n}\sum_k\sum_{i\in I_k}\psi_i(\theta,\hat\varphi^{(-k)},\hat\lambda^{(-k)})=0$,
or equivalently take one Newton step from the plug-in estimator. Rotate the roles of the three parts,
average, and repeat over several random partitions taking the median across partitions.

$\hat\nu$ requires only $p$ separate **one-dimensional** nonparametric regressions of $\Delta Z$ on
$X_t$. The only object that takes $\Delta Z$ as a vector argument is the scalar propensity $\varrho$;
no conditional *distribution* is ever estimated given $\Delta Z$, because the Bierens device of §2.2
replaces that conditioning with the scalar index $t'\Phi(\Delta Z)$.

### 2.6 What cross-fitting buys, precisely

Agents must not overstate this. Splitting does two things and not a third:

- **It removes the stochastic-equicontinuity requirement.** With $\hat\varphi$ fitted off-fold, the
  empirical-process term is $o_P(1)$ by conditional Chebyshev given only
  $\|\hat\varphi-\vdagger\|_{L^2(\pi)} = o_P(1)$, which the existing MISE bound already delivers. No
  Donsker class for a regularized inverse with a data-driven stopping rule is required. **This is the
  gap that currently blocks a clean proof.**
- **It decouples the estimated operator from the regularized inverse**, turning the remainder analysis
  into a sequence of conditional arguments.
- **It does not remove the first-order bias** $\sqrt{n}\langle\nu,\hat\varphi-\vdagger\rangle$. Only
  P1 (orthogonalization) does that. Any draft claiming otherwise fails review.

**CORRECTED 2026-07-28 (Stage 2 escalation 1).** An earlier version of this section said the remainder
was a sum of three *pairwise products* over $(\varphi,L,\varrho)$. **That was wrong and it understated
what the theorem needs.** A second-order expansion has six terms. Two vanish *exactly*, because
$E[\psi]$ is affine in $L$ and affine in $\varrho$ (the moment is $\Delta Z\Delta U + (W-\varrho)L$,
linear in each separately). Four survive:

$$O_P\Big(\underbrace{\|\hat\varphi-\vdagger\|^{\,2}}_{\text{a SQUARE, not a product}}
\;+\; \|\hat\varphi-\vdagger\|\cdot\|\hat L-L_\dagger\|
\;+\; \|\hat\varphi-\vdagger\|\cdot\|\hat\varrho-\varrho\|
\;+\; \|\hat L-L_\dagger\|\cdot\|\hat\varrho-\varrho\|\Big).$$

The square arises because $L$ is **nonlinear in the residual**: perturbing $\varphi_\dagger\to\vdagger+h$
sends $\Delta U\to\Delta U_\dagger-\Delta h$, and expanding
$L(\Delta U_\dagger-\Delta h)=L-\ell\,\Delta h+\tfrac12\partial_u\ell\,(\Delta h)^2+\cdots$ leaves,
after P1(i) cancels the first-order terms,
$$\tfrac12\,E\big[\widetilde W\,\partial_u\ell_\dagger\,(\Delta h)^2\big].$$

**Consequence — this is the binding constraint on the whole paper, not a technicality.** A product of
two errors is $o_P(n^{-1/2})$ when each is $o_P(n^{-1/4})$; a *square* gives no such help from a second
nuisance. It forces
$$\big\|\hat\varphi-\vdagger\big\| = o_P\big(n^{-1/4}\big)$$
outright. In a **mildly** ill-posed problem this is attainable when the source smoothness $s$ exceeds
$a+\tfrac12$ ($a$ the degree of ill-posedness). In a **severely** ill-posed problem, where the
nonparametric rate is logarithmic, it is **unattainable at any smoothness** — and no amount of
orthogonalisation repairs it. ~~Note also that `assapp4`'s $\kappa_n\to0$ device multiplies the rate by
$\kappa_n^{-1}$, making the constraint *harder*.~~ **Struck 2026-07-28:** `assapp4` sets
$\kappa_n=\inf_{|u|\le\ell_n}f_U(u)$, and with $\ell_n$ bounded $\kappa_n$ is a positive constant — no
rate penalty. (For diverging $\ell_n$ the penalty is sub-polynomial, not logarithmic: Gaussian $f_U$
with $\ell_n\asymp\sqrt{2c\log n}$ gives $\kappa_n^{-1}\asymp n^{c}$.)

This binds **even if A2 holds and even if the tangential cone condition of §2.6b holds.**

**RESOLVED 2026-07-28 after two rounds — the bound above is SHARP, and that is now a theorem, not a
concession.** Both the "severity under review" caveat and the weak-norm hope that motivated it are
withdrawn. The record, because the reasoning matters:

*Attempt 1 (orchestrator, wrong).* Under A2, $\nu=\mathcal A^\ast_{\mathrm{cond}}\ell_\star$, so the
first-order object is a weak-norm pairing $\langle\ell_\star,\mathcal A h\rangle$; writing
$(\Delta h)^2=\Delta(h^2)-2h(X_1)\Delta h$ appeared to make one piece of $Q$ weak-norm-able and "free."
**It is not.** $\mathcal A$ annihilates only *constants*, so
$\|\mathcal A(h^2)\|\lesssim\|h\|_\infty\|h\|_{L^2}$ — the same order as the residue, which is in fact
$O(\|h\|_{L^2}^2)$ by Cauchy–Schwarz. The split is strictly **worse** than the direct bound.

*Attempt 2 (strategist, also wrong).* A three-rung ladder resting on
$\mathcal R(\mathcal B)\subseteq\mathcal R(\mathcal A^\ast\mathcal A)$, where $Q(h)=\tfrac12\langle\mathcal Bh,h\rangle$.

*The refutation (strategist-critic, verified).* Expanding the square, the two diagonal terms **add**
into a multiplication operator while only the cross term is Hilbert–Schmidt:
$$2Q(h)=\int M(x)h(x)^2dx-2\langle\mathcal Kh,h\rangle,\qquad
M(x)=E[q\mid X_2=x]f_{X_2}(x)+E[q\mid X_1=x]f_{X_1}(x).$$
Under A1, $\int M=2E[\widetilde W\partial_u\ell_\star]=0$ — but $M\not\equiv0$ pointwise. Multiplication
by $M$ is compact iff $M\equiv0$, while $\mathcal R(\mathcal A^\ast)$ is the range of a **compact**
operator. So the range condition is satisfiable only on a knife-edge. Constructively, with $\chi$
supported where $M>0$ and $h_k=\sqrt2\,\chi\cos(kx)$: $h_k\rightharpoonup0$ weakly, so
$\|\mathcal Ah_k\|\to0$ and $\langle\mathcal Kh_k,h_k\rangle\to0$ by compactness, while
$\int Mh_k^2\to\int\chi^2M>0$ by Riemann–Lebesgue. **Both candidate weak-norm rungs fail.**

**What this buys the paper — stated at the quantifier the proof actually supports.** The same sequence,
together with Weyl's theorem, gives
$$\sup_{\|h\|_{L^2(\pi)}\le\delta}|Q(h)| \;=\; \tfrac12\delta^2\big\|\mathcal B_{\mathrm{sym}}\big\|
\;\ge\; \tfrac12\delta^2\|m\|_{L^\infty} \;>\;0,\qquad m:=M/\pi,$$
the equality holding because $\mathcal B_{\mathrm{sym}}$ is self-adjoint (numerical radius $=$ norm).

**Be careful what this says.** It is a statement about **the class of admissible proof techniques**: no
bound depending on $h$ only through $\|h\|_{L^2(\pi)}$ can improve on $\delta^2$ — in particular no
weak-norm bound exists. **An earlier version of this section said the requirement is "necessary for this
moment function, not an artefact of the proof technique." That is exactly backwards and is withdrawn.**
Genuine necessity would additionally require the *realised* $\hat\varphi-\vdagger$ to point where $Q$ is
bad. That is plausible under semiconvergence, it is **not proved**, and it is not tested by a simulation
that evaluates the constructed sequence — testing it means tracking
$Q(\hat\varphi-\vdagger)/\|\hat\varphi-\vdagger\|^2$ across the $n$ grid.

State the proposition as: *no bound in $\|h\|_{L^2(\pi)}$ alone improves on $\delta^2$; in particular no
weak-norm bound is available.* That is fully proved, and it is enough to justify the scope: $\sqrt n$
under mild ill-posedness with $s>a+\tfrac12$; not available under severe ill-posedness.

**The one surviving lever, re-aimed.** $\ell_\star$ is not unique — $\mathcal A^\ast_{\mathrm{cond}}$
maps an infinite-dimensional space onto functions of a *scalar*, so solutions of
$\mathcal A^\ast\ell=-\nu$ form the affine set $\ell_\star+\ker\mathcal A^\ast$, and validity of $\psi$
holds for **any** member (mean-zero comes from A1 and N1, not from the adjoint equation). The object to
minimise over that set is **$M$**, not $\|\partial_u\ell_\star\|_\infty$ — the latter only moves the
constant in a bound now known to be order-sharp. Whether some selection achieves $M\equiv0$ is the one
open question that could still reopen the scope.

**A corollary worth stating in the paper:** `rem:nophifree` *forces* $\partial_u\ell_\dagger\not\equiv0$.
If $\ell$ were constant in $u$, N1 and $E[\Delta U\mid\Delta Z]=0$ give $L(u,z)=c(z)u$, hence
$\psi=(\Delta Z+\widetilde W c(\Delta Z))\Delta U$ — a $(W,\Delta Z)$-measurable weight, which R2 forbids.
**The impossibility result is exactly what creates the quadratic remainder.**

Whatever the outcome, do not present $\sqrt n$ as unconditional.

**A2 is promoted to A2′,** adding boundedness of $\partial_u\ell_\dagger$ and
$E[\widetilde W^2\ell_\dagger^2]<\infty$ — the square term is meaningless without the former, and the
variance of the correction is infinite without the latter.

Finally, $\hat\varphi$ itself depends on $\hat\varrho$ through $\widetilde W$ in the LF step, so the
propensity error enters twice; the proof must not double-count it or omit the induced term.

### 2.6b The rate for $\hat\varphi$ — what the *nonlinear* Landweber step requires

Added 2026-07-28 after the Stage 1 librarian-critic flagged (finding F-6) that the regularisation theory
for the $\varphi$-step is missing from the literature deliverables — and, more importantly, from this
contract. It is a genuine gap, not a citation gap.

`thm:rootn` needs a rate for $\|\hat\varphi - \vdagger\|$ to feed the product remainder of §2.6. That
rate does not come for free, because the operator equation solved by Landweber–Fridman here is
**nonlinear** in $\varphi$ — the companion paper's machinery and every rate quoted from it concern
**linear** ill-posed problems, where LF convergence is classical.

For nonlinear ill-posed problems, LF convergence and the associated stopping rule require an extra
structural condition on the operator — in the standard treatment, the **tangential cone condition**
(sometimes the Scherzer condition): for $\varphi,\tilde\varphi$ in a ball around the truth,
$$\big\|T(\varphi)-T(\tilde\varphi)-\mathcal{A}(\varphi-\tilde\varphi)\big\|
\;\le\; \eta\,\big\|T(\varphi)-T(\tilde\varphi)\big\|, \qquad \eta < \tfrac12 .$$

Anchors, all three already in `instrumental.bib`:

- **`hanke1995`** — Hanke, Neubauer & Scherzer, *Numer. Math.* 72(1), 21–37. Proves LF is a stable
  method for **nonlinear** ill-posed problems and gives the discrepancy-principle stopping rule with
  rate $O(\delta^{1/2})$ under exactly these conditions. This is the convergence theorem for the
  $\varphi$-step; cite it, and state the condition it needs.
- **`engl2000`** — Engl, Hanke & Neubauer, *Regularization of Inverse Problems*. Source conditions,
  semiconvergence, stopping rules. The deliverables and this plan use that vocabulary throughout and
  currently attribute it only to Carrasco–Florens–Renault (2007).
- **`chenreiss2011`** — Chen & Reiß, *ET* 27(3), 497–521, rate optimality for ill-posed inverse
  problems in econometrics.

**Action for Stage 2 (theorist).** Either (i) verify the tangential cone condition for this operator
and state it as a numbered assumption alongside A1–A4, or (ii) state it as a high-level assumption on
$\hat\varphi$'s rate and say plainly that it is inherited rather than proved. Do **not** quote a linear
LF rate as if it applied. Referee A is the Florens/Carrasco/Johannes/Dunker circle; they will ask.

**Note the interaction with §16 item 3.** The implementation already departs from the source's stopping
rule — it stops at the argmin of the direct operator residual $\|F_1-F_0\|$, which shows clean
semiconvergence, rather than at the argmin of the joint independence criterion. Whichever rule the
theory adopts, the code and the theorem must use the same one.

### 2.7 Target results

| Label | Statement | File |
|---|---|---|
| `lem:shiftinv` | Lemma L1 (shift invariance) — and Remark R1, why it does *not* block $\sqrt n$ | `paper/sections/theorems/lem-shiftinv.tex` |
| `lem:bierens` | Equivalence of the $\Delta Z$-conditional restriction (A) with the unconditional family $\{\mathcal{M}(u,t)\}$; conditions on $w$, $\Phi$, $\mathcal{T}$ | `lem-bierens.tex` |
| `lem:adjoint` | Closed form of $\mathcal{A}^\ast_{\mathrm{cond}}$, reconciled with draft `:172–177` | `lem-adjoint.tex` |
| `prp:nophifree` + `rem:nophifree` | Remark R2 (no exact $\varphi$-free moment) — **proved as an *iff*, so the substance is a proposition with the remark as its companion** (N-11, accepted 2026-07-28). Its proof turns on $\nu_g/\pi\perp\mathcal V$ with $\mathcal V^\perp=\{$constants$\}$, and `lem:nusigma`(iv) forcing that constant to **zero** — so the conclusion is $\nu_g\equiv0$ exactly. **Cite Fève–Florens (2014)**: they reach the same condition in the linear case, stated as exchangeability of $(Z_1,Z_2)$ given $W$. | `rem-nophifree.tex` |
| `cor:udep` | O-11 — `prp:nophifree` **forces** $\partial_u\ell_\star\not\equiv0$: a $u$-constant $\ell$ gives $L(u,z)=c(z)u$ and hence a $(W,\Delta Z)$-measurable weight, which R2 forbids. **The impossibility result is what creates the quadratic remainder.** Note the memo's O-11 overclaims by one link (N-13) — this does *not* give $Q(h)\neq0$, since $q=E[\widetilde W\partial_u\ell_\star\mid X_1,X_2]$ can vanish by cancellation. | with `rem-nophifree.tex` |
| `prp:kerchar`, `cor:a1cprim`, `rem:ffcompare` | **ADDITIVE, accepted 2026-07-28 (N-12).** `prp:kerchar` characterises $\ker\mathcal A_{\mathrm{cond}}=\{h:E[\widetilde W\Delta h\mid\Delta U,\Delta Z]=0\}$ and closes the ingredients the A1c comment listed as unavailable. **N-17 (2026-07-28, CORRECTED same day): `prp:kerchar` and `cor:a1cprim` are INDEPENDENT of the N-10 closure — but `cor:rangegap` is NOT.** The first two never touch $\varpi_u$: their clauses are $P$-a.s. with reference measure $P_{\Delta U,\Delta Z}$, and B1(iv.a) enters only via `lem:bierens` Step 5's *round-2 full-support* clause, so **they survive a complete rollback of the strengthening.** `cor:rangegap` does **not** — it is a corollary to `lem:adjoint`(ii)–(iii), which *are* the N-10 closure; roll B1(iv.a) back to full support and $\mathcal W$ has no definition, no norm bound and no dense range, so the corollary does not weaken, it **ceases to have a subject.** It is independent only of the round-3 $C^1$ clause. *(The orchestrator transcribed the theorist's over-broad escalation row into this table before it was reviewed; the `.tex` files and memo §§D1.4/D2.3 had it right all along.)* The A1c bridge and the N-10 closure merely landed in the same dispatch; bundling them understates both, and a future revisit of $\Pi_u$ must not drag them along.; `cor:a1cprim` adapts Fève–Florens Prop. 2.2 to A1c (not to A1b(iii) — the obstruction is that global membership needs test functions of the *unobserved* true residual). | with `lem-adjoint.tex` |
| `prp:orthog` | Proposition P1 (orthogonality in $\varphi$, $L$, **and** $\varrho$; normalisation N1) — stated in RKHS balancing form per §15 and §17 | `prp-orthog.tex` |
| `prp:phirate` | **NEW (Stage 2 escalation 2).** Rate for $\|\hat\varphi-\vdagger\|$ from the *nonlinear* LF iterate with the data-driven stopping rule, under the tangential cone condition of §2.6b. §2.6b delegated this choice but created no result to hold it, and `thm:rootn` cannot be stated without it — it is what supplies the $o_P(n^{-1/4})$ of §2.6, and what fills leg 3 of the Chen–Pouzo rebuttal (which currently says what we avoid, Donsker, without saying what we use). | `prp-phirate.tex` |
| `thm:rootn` | Rate theorem for the cross-fitted $\hat\theta$, **with $\sqrt n$ asymptotic normality as a corollary** holding under the mild-ill-posedness restriction of §2.6. State it in this order — it costs nothing and pre-empts the obvious referee question. $\hat\theta$ is defined as a **one-step** estimator: the moment is nonlinear in $\theta$ and A3 is only a *local* rank condition. | `thm-rootn.tex` |
| `prp:effbound` | Semiparametric efficiency bound; whether $\psi$ attains it | `prp-effbound.tex` |
| `prp:plugin` | Second-stage $\hat\varphi$ from LF on $\Delta Y - \Delta Z'\hat\theta$; plug-in error negligible relative to the nonparametric rate | `prp-plugin.tex` |
| `cor:trend` | Separation of the time trend from a linear component of $\vdagger$ requires differential $X$-drift across $W$ | `cor-trend.tex` |

---

## 3. Paper skeleton

Follow the source draft's scheme. New material is marked **NEW**; everything else is revision of
existing prose.

```
1. Introduction                                    revise — add the θ contribution
2. Identification
   2.1 Assumptions and the two restrictions        revise — fix ass:condind, finish item (iii)
   2.2 Identification of φ                         revise — complete the truncated derivation
   2.3 Why θ needs separate treatment       NEW    Lemma L1, Remark R2
3. Direct estimation of θ                   NEW
   3.1 The orthogonal moment                       Proposition P1
   3.2 Cross-fitting and the algorithm             Algorithm 1
   3.3 Asymptotic theory                           Theorem thm:rootn, prp:effbound
   3.4 Recovering φ                                prp:plugin
4. Monte Carlo                              NEW    see Section 8
5. Effect of pollution on house prices             KEEP — re-estimate, see Section 9
6. Conclusions                                     revise
Appendix A. Additional assumptions                 revise — keep assapp1–assapp5, add A2/A3
Appendix B. Proofs                          NEW
```

---

## 4. Working locations

The source draft is a Quarto project outside this repository. Do not move it. Use:

| Artifact | Location |
|---|---|
| Prose + Quarto build (source of truth for the manuscript) | the Dropbox project, `Centorrino_panel.qmd` |
| Theorem stubs and proofs | `paper/sections/theorems/*.tex` in this repo |
| Theory memo, assumptions, results, proofs, notation glossary | `quality_reports/theory/panel-npiv-discrete/` |
| Critic reports | `quality_reports/{notation,assumptions,regularity,counterexamples,derivations}/` |
| Simulation code and output | `scripts/simulations/`, `paper/tables/sim/`, `paper/figures/sim/` |
| Literature | `quality_reports/literature/panel-npiv-discrete/` |

A sync step at the end of each stage copies the settled LaTeX into the `.qmd`. The repo is where the
quality gates run; the Quarto document is what compiles.

---

## 5. Stage 1 — Literature

**Skill:** `/discover lit partially linear IV panel, discrete instruments with continuous endogenous
regressor, root-n estimation of linear functionals in ill-posed inverse problems`
**Agents:** librarian → librarian-critic
**Gate:** librarian-critic $\ge 80$

Must cover, at minimum:

- Partially linear IV and $\sqrt{n}$-estimation of the parametric component — Robinson (1988);
  Ai & Chen (2003); Florens, Johannes & Van Bellegem, "Instrumental Regression in Partially Linear
  Models" (the draft cites `florens2006`; check whether the intended entry is the working paper or the
  published *Econometrics Journal* version, and fix the bib).
- $\sqrt{n}$-estimability of linear functionals under ill-posedness — Severini & Tripathi (2006, 2012);
  Chen & Pouzo (2015); Chen & Christensen (2018).
- Debiased/orthogonal moments and cross-fitting — Chernozhukov et al. (2018); Chernozhukov, Newey &
  Singh (2022) on automatic Riesz representers.
- Discrete instruments with a continuous endogenous regressor — D'Haultfœuille & Février (2015);
  Torgovitsky (2015); the companion Centorrino–Fève–Florens paper.
- Weak-identification-robust inference — Stock & Wright (2000).
- Hedonic pollution literature for the application — `chay2005`, `masten2016` are already cited.

**Positioning statement the librarian must produce:** what is new here is not the LF algorithm (that is
the companion paper) but the $\sqrt{n}$ theory for the parametric component under a *discrete*
instrument, where the standard partially-linear-IV projection argument is unavailable. Verify nobody
has done this. If someone has, escalate to the user before Stage 2.

---

## 6. Stage 2 — Formalize the results

**Skill:** `/conjecture` once per target result in Section 2.7, then `/strategize theory` for the
proof-strategy memo.
**Agents:** strategist (proof-strategy mode) → strategist-critic; theorist → theorist-critic
**Gate:** strategist-critic $\ge 80$ before any `/prove` call

Order matters. `lem:shiftinv` and `lem:bierens` first (they are short and they fix notation and the
index set), then `lem:adjoint`, then `prp:orthog`, then `thm:rootn`, then the rest.

The theorist must also produce, in `quality_reports/theory/panel-npiv-discrete/assumptions.tex`, a
consolidated assumption block that:

1. States A1 with the independence **conditional on $\Delta Z$** — $\Delta U \upmodels W \mid \Delta Z$
   together with $E[\Delta U\mid\Delta Z]=0$ — per §17. (The original version of this plan said
   *unconditional* and cited Lemma L1 as the justification; that reasoning was withdrawn in §17 and
   this item is corrected. L1 is retained, but as the reason $\theta_\dagger$ is *exactly* identified
   by (B) rather than over-identified, not as a reason to strengthen A1.)
2. Fills in the placeholder at draft `:111` — assumption item (iii) currently reads `edddee`.
3. Carries over `assapp1`–`assapp5` from the draft's appendix unchanged unless the new theorem needs
   more. **Check `assapp5` against the Bierens index set** — the bandwidth condition was written for an
   operator indexed by $u$ alone.
4. Adds A2 (source condition on $\nu$, stated for $\mathcal{A}^\ast_{\mathrm{cond}}$), A3 (local rank),
   and **A4 (propensity regularity / overlap)**. A4 is new in §17 and is not innocuous at the
   application's 689/300 split — see Khan & Tamer (2010) on irregular identification, added to the
   bibliography at Stage 1.
5. Adds the cross-fitting rate condition as an explicit assumption, not a footnote — and note it is now
   a **sum of three pairwise nuisance products** over $(\varphi, L, \varrho)$, per §2.6.
6. Adds **normalisation N1** ($E[L\mid\Delta Z]=0$) as a numbered condition, not an aside. It is what
   makes the moment orthogonal in the propensity (P1(iii)); without it $\hat\varrho$ needs a $\sqrt n$
   rate and the whole construction fails.
7. Addresses **the tangential cone condition** for the nonlinear Landweber step, per §2.6b — either
   verified for this operator and numbered alongside A1–A4, or stated as a high-level condition on
   $\hat\varphi$'s rate with the inheritance made explicit. Do not quote a linear LF rate as if it
   applied to a nonlinear operator.

**Known gap to close:** the draft at `:120–122` ends mid-sentence — the operator equation
$T(\varphi,\theta)$ for $Y_{\theta_\dagger}$ is missing before "whose Fréchet derivative can be written
as." The theorist must write it out; the whole Section 2 derivation depends on it.

---

## 7. Stage 3 — Prove

**Skill:** `/prove paper/sections/theorems/{slug}.tex` for each target, in the order above.
**Agents:** theorist → theorist-critic → {regularity-checker, derivation-verifier, counterexample-hunter}
**Gate:** theorist-critic $\ge 80$, no unresolved CRITICAL, no confirmed counterexample

Then `/audit --all` across the whole set.

Points the critics should be primed to attack:

- **regularity-checker.** Differentiation under the integral sign in the derivation of P1 (the
  $\partial_\varphi$ step passes a derivative through an indicator — this needs $f_U$ continuous, which
  `assapp2` supplies, but the interchange must be justified, not asserted). Measurability of
  $\hat\ell$ as a function of the estimated residual. The $\kappa_n \to 0$ device in `assapp4`
  interacting with the source condition A2.
- **counterexample-hunter.** Probe: (i) $\nu \equiv 0$, where the moment degenerates and $\theta$ is
  identified only through the $\widetilde{W}$ channel; (ii) $\mathrm{Cov}(W,\Delta Z)=0$, which kills
  the distributional restriction's first-order information about $\theta$; (iii) $\varphi$ linear with
  $X$-drift constant across $W$, where the time trend is confounded with the linear component (this
  should be *captured* by A3 — verify that it is, and if so record it as `cor:trend` rather than a
  counterexample); (iv) $\nu \notin \mathcal{R}(\mathcal{A}^\ast)$, which must produce a genuine
  failure of $\sqrt{n}$ rather than a proof gap.
- **derivation-verifier.** Write SymPy specs under `scripts/symbolic/specs/` for the adjoint
  computation and for the Jacobian
  $J = -\{E[\Delta Z\Delta Z'] + E[\widetilde{W}\ell_\dagger(\Delta U)\Delta Z']\}$. Reconcile the
  adjoint against the draft's `:172–177` display, which currently has $\pi(v)$ in both numerator and
  denominator and carries a $\theta$ subscript that never appears in the expression.

---

## 8. Stage 4 — Monte Carlo

**Skill:** `/simulate thm:rootn --lang r`
**Agents:** simulation-engineer → simulation-engineer-critic
**Gate:** verdict "Matches" or "Matches at large $n$ only"

Design requirements:

- **DGP.** Scalar continuous $X_{it}$, binary $W_i$, $\Delta Z_i$ of dimension 3–5 including a
  constant. Endogeneity through a common shock in $(\Delta U, X_1, X_2)$. Calibrate the first stage —
  $E[\Delta X\mid W=1]-E[\Delta X\mid W=0]$ — to what the TSP data show, so the simulation speaks to
  the application.
- **$\varphi$ specifications.** At least three: linear (the case where the trend is fragile — see
  `cor:trend`), the $U$-shape the empirical results suggest, and one that violates A2 so the
  simulation exhibits the failure of $\sqrt{n}$.
- **Sample sizes.** $n \in \{250, 500, 1000, 2000, 4000\}$. Include $n=1000$ since the application has
  $n=989$.
- **What to report.** $\sqrt{n}\,(\hat\theta-\theta_\dagger)$ scaled RMSE flat in $n$ (the rate check);
  coverage of the plug-in interval and of the weak-identification-robust interval; comparison against
  (i) the draft's alternating estimator and (ii) TSLS. Report the ratio
  $\|\hat\varphi-\vdagger\|\cdot\|\hat\ell-\ell_\dagger\|$ against $n^{-1/2}$ to show the product-rate
  condition is met in practice.
- **MC error budget.** Enough replications that the Monte Carlo standard error on coverage is below
  one percentage point. State it explicitly; the critic checks this.
- **Cross-fitting.** $K=5$. Also run $K=2$ to show why it is a bad idea at $n\approx 1000$.

Invariants: `INV-14` (one `set.seed()` at top), `INV-15`, `INV-16` (no absolute paths — use `here()`),
`INV-13` (bare `tabular` export).

---

## 9. Stage 5 — Empirical application

**Keep the application exactly as drafted:** Chay–Greenstone TSP and house-price data, $n=989$ U.S.
counties, 1970 and 1980, CAAA attainment status as the binary instrument, the same variable
definitions and the same $1\%$ trim on the marginal distribution of $X$. Section 5.1 (Data) needs
almost no change.

**What changes is the estimator and the reporting.**

### 9.1 Blocking dependency — resolve before anything else

The current figure is produced from `tspapp.mat` (draft `:154`), read from a hardcoded absolute path
(`:57`) pointing into `Matlab_code/Code_Papers/Centorrino_Feve_Florens_2018/`. That `.mat` file holds
*results*, not the underlying county panel. The new estimator cannot be computed from it.

Before Stage 5, obtain the estimation sample — county identifier, $\Delta Y$, $X_1$, $X_2$, $\Delta Z$,
$W$ — as a plain data file. **Escalate to the user if it cannot be located.** Do not attempt to
reverse-engineer it from the `.mat`. Once obtained, place it under `data/cleaned/` and remove the
hardcoded `homedir` (`INV-16`).

### 9.2 New results to produce

1. $\hat\theta$ by the cross-fitted orthogonal moment, $K=5$, median over at least 20 random
   partitions.
2. Standard errors from the sandwich form implied by `thm:rootn`, **and** a
   weak-identification-robust confidence set, since the draft currently states its bootstrap intervals
   "should not be considered valid" (`:183`). Report both.
3. The identification-strength diagnostic: the share of each $\Delta Z_j$ explained by period
   differences of functions of $X$, and its behaviour as the sieve dimension grows. If it approaches
   one, A2 is in doubt and the paper must say so.
4. A comparison table: new estimator / draft's alternating estimator / TSLS, coefficient by
   coefficient.
5. **Figure `fig:fct_tsp_1` is kept.** Regenerate $\hat\varphi$ from the second-stage LF run on
   $\Delta Y - \Delta Z'\hat\theta$ (`prp:plugin`), preserving the existing three initial conditions
   ($\hat\varphi_{0,1}$ Robinson-type, $\hat\varphi_{0,2}$ control function, $\hat\varphi_{0,3}$
   flexible parametric) and the existing layout. Keep the substantive discussion at `:237` — the
   $U$-shape, the sign pattern of the marginal effects, the consistency with `masten2016` — and revise
   only where the new numbers require it.

### 9.3 Interpretive point the writer must not omit

Identification of $\theta_\dagger$ now leans on $E[\Delta U\mid\Delta Z]=0$ doing real work: the
controls must be mean-exogenous. In this application that asks county income growth and population
density growth to be mean-independent of housing-price shocks. That is not innocuous and must be
argued in prose, not assumed silently. Flag it as a limitation in the Conclusions.

**Skill:** `/analyze` for the estimation code, then `/review --code`.
**Gate:** coder-critic $\ge 80$.

---

## 10. Stage 6 — Write

**Skill:** `/write` section by section, then `/write humanize`.
**Agents:** writer → writer-critic
**Gate:** writer-critic $\ge 80$

### 10.1 Defects in the source draft to fix while writing

| Line | Defect |
|---|---|
| `:111` | Assumption item (iii) is the placeholder `edddee` |
| `:120–122` | Sentence ends "Then we have that" — the operator equation is missing |
| `:78–80` vs `:83–89` | `ass:condind` is in $\Delta$'s; `eq-exogres1`/`eq-exogres2` and everything after drop them |
| `:91` | `@exogres1` is missing the `eq-` prefix |
| `:118`, `:168`, `:170`, `:179` | `@ass:differentiability`, `@ass:scalab`, `@ass:sourcecondID`, `@ass:condcomp`, `@sec:mcsim`, `@tab:sumstat` point at labels in the companion paper and render as literal text |
| `:116` | `\eqref{eq:restrins}`, `\eqref{eq:fullrestr}` — same problem in LaTeX form |
| `:179`, `:305` | `@robinson1988}` and `@muller1991}` — stray closing braces |
| `:93–103` | $T(\varphi,\theta)$ is integrated over $x_1,x_2$ but written as a function of $(w,z,u)$; the operator's arguments are never declared |
| `:69` | "pontially" → "potentially" |
| `:172–177` | Adjoint display: $\pi(v)$ in both numerator and denominator; $\theta$ subscript with no $\theta$ in the expression |
| `:192` | `fig.cap` reads "effect of p#\| ollution" — a chunk-option marker leaked into the caption |
| `:243–247` | Raw `%%` LaTeX comments in the markdown body render literally in Quarto |
| `:57` | Hardcoded absolute Dropbox path |

Every cross-reference that points into the companion paper must either be replaced with a
self-contained statement or converted into an explicit citation. The note must read standalone.

### 10.2 Format

`working-paper-format.md` applies: `biblatex` + `biber`, `booktabs` not `\hline`, `cleveref` after
`hyperref`, table and figure notes on everything (`INV-1`, `INV-2`), abstract $\le 150$ words
(`INV-5`), JEL codes and keywords (`INV-6`). The existing abstract and JEL block (`:31`) already
comply — update the abstract to mention the $\sqrt{n}$ result.

The bibliography is `../../instrumental.bib`. Run `/tools validate-bib` after the librarian adds
entries.

---

## 11. Stage 7 — Review and submit

1. `/audit --all` — final sweep of all five narrow critics.
2. `/review --theory` — theorist-critic standalone on the full proof set.
3. `/review --peer` — editor dispatches domain-referee and methods-referee.
4. `/submit target` — the natural targets are econometrics field journals; the contribution is a
   $\sqrt{n}$ theory result with an application, not an applied paper.
5. `/submit final` — the Verifier checks the theory binary gates.

**Binary gates (from `quality.md` §4), all must pass regardless of the weighted score:**

- Every theorem in `paper/sections/theorems/` has a complete proof — no stubs.
- theorist-critic $\ge 80$ with no unresolved CRITICAL.
- No confirmed counterexample from the most recent `/audit --counter`.
- No open escalation in the research journal.
- Simulation verdict is "Matches" or "Matches at large $n$ only".

**Weight schedule** (`PROJECT_TYPE: theory`, simulation present): proof completeness 30%, assumption
parsimony 20%, notation consistency 10%, novelty and placement 15%, exposition 15%, simulation 10%.

---

## 12. Do not do

- **Do not pursue an exact $\varphi$-free moment.** Remark R2 settles it. The condition requires the
  $g$-tilted marginals of $X_1$ and $X_2$ to coincide, which is false in these data.
- **Do not estimate a conditional *distribution* given $\Delta Z$.** (Revised by §17 — the original
  instruction was "do not condition on $\Delta Z$ anywhere", which A1's new conditional form makes
  impossible.) Two $\Delta Z$-dependent objects are now permitted and required: the scalar propensity
  $\varrho(\Delta Z)$, and the scalar Bierens index $t'\Phi(\Delta Z)$. Neither is a conditional
  distribution, and neither carries the curse of dimensionality into the operator. Anything that
  smooths nonparametrically over the full $\Delta Z$ vector to obtain a conditional law is out.
- **Do not reinstate the alternating $\theta \leftrightarrow \varphi$ loop for the main theorem.** It
  is the reason the asymptotics were deferred in the first place. It may stay in the paper as the
  comparison estimator in the simulation and application tables.
- **Do not claim cross-fitting removes the plug-in bias.** It removes the empirical-process term. The
  bias is removed by orthogonality (P1). Conflating the two fails review.
- **Do not weaken A2 to make the theorem look stronger.** If $\nu \notin \mathcal{R}(\mathcal{A}^\ast)$
  the honest conclusion is that $\theta_\dagger$ is not $\sqrt{n}$-estimable and the paper reports a
  slower rate with robust intervals.

---

## 13. Housekeeping

- Update the "Current Project State" table in `CLAUDE.md` when Stage 5 completes.
- Append to `quality_reports/research_journal.md` after every agent invocation, per `logging.md`.
- Maintain `quality_reports/pipeline_state.json` so session recovery works.
- `/checkpoint` before each `/compact`.
- The repo is also a public template (`meta-governance.md`): project-specific paths and the county
  data stay local; workflow patterns learned here are candidates for promotion only with user
  approval.

---

## 15. AMENDMENT (2026-07-28) — the debiasing weight must be obtained by balancing

Implementation forced one change to the method, not just to the code. It is recorded here because
`prp:orthog` and `thm:rootn` have to be stated in these terms.

**What §2.5 said.** Solve $\mathcal{A}^\ast \ell = -\nu$ by Landweber–Fridman, reusing the adjoint
already derived at `:172–177` of the draft.

**Why that fails.** The kernel representation of $\mathcal{A}^\ast$ approximates the *continuum*
adjoint. It is not the adjoint of the empirical bilinear form, so driving
$\lVert \nu + \mathcal{A}^\ast\ell\rVert$ to zero does not zero the finite-sample bias
$$n^{-1}\textstyle\sum_i \big\{\Delta Z_{ij} + \widetilde W_i\,\ell(u_i)\big\}\big\{h(X_{i2}) - h(X_{i1})\big\}.$$
Verified numerically: with the kernel adjoint solved to relative discrepancy $0.0000$, the bias was
still entirely uncancelled. Two further consequences of the same defect — conjugate gradient on the
normal equations diverges (residual path $0.06 \to 130$), and in the derivative parameterisation the
bias bound $\mathrm{disc}\times\lVert\hat\varphi' - \varphi'\rVert$ is vacuous because
$\lVert\hat\varphi'-\varphi'\rVert \approx 70$ for an LF iterate.

**What to do instead.** Impose the orthogonality condition directly in sample, which is the balancing
program already written down in §2.5 as eq. (td-balancing). With a basis $b_1,\dots,b_{L_x}$ for $h$
on $\mathcal{X}$ and $\beta_1,\dots,\beta_{L_u}$ for $\ell$ on the residual,
$$D_{i\ell} = b_\ell(X_{i2}) - b_\ell(X_{i1}),\qquad B_{im} = \beta_m(u_i),$$
$$\big(D^\prime \mathrm{diag}(\widetilde W) B\big)\,\beta = -D^\prime \Delta Z_j ,$$
an $L_x\times L_u$ system solved by truncated SVD. Exact in sample up to the approximation error of
the $h$-basis, no $n\times n$ matrices, and still no conditioning on $\Delta Z$.

**Consequences for the theory.** `prp:orthog` should be stated as the balancing condition, with the
kernel adjoint equation as its population limit. `thm:rootn` needs the $h$-sieve approximation error
as an explicit term: the bias is bounded by (balancing residual) $\times \lVert\hat\varphi-\varphi\rVert$
plus a term for the part of $\hat\varphi - \varphi$ outside the span of $b_1,\dots,b_{L_x}$. A2 is
unchanged in substance.

**Numerical status.** A2 verified to hold in the test DGP (an explicit SVD shows $\nu$ fully inside
$\mathcal{R}(\mathcal{A}_L^\ast)$, 99.8% within the leading 10 singular directions). Balancing attains
relative residual $\sim 10^{-15}$ and cancels the first-order bias term with ratio 1.02. Validation
Monte Carlo, $n=400$, $R=100$, $\theta_2 = -0.5$:

| estimator | bias | sd | rmse |
|---|---|---|---|
| oracle (true $\varphi$) | $-0.0068$ | 0.0616 | 0.0617 |
| plug-in | $0.0227$ | 0.0928 | 0.0951 |
| **orthogonal (balanced)** | **$0.0089$** | 0.1053 | 0.1052 |
| alternating (draft) | $0.0298$ | 0.0883 | 0.0928 |

Bias falls 61% and is within Monte Carlo error of the oracle; sd rises 13%. RMSE is flat at this $n$,
as expected — the plug-in bias does not shrink at $\sqrt n$ while the sd does, so the ordering must be
demonstrated across the $n$ grid of §8. That comparison is the central Monte Carlo result.

## 16. Other deviations from the source MATLAB

Recorded for the replication package.

1. **Order-8 kernels are required in the residual direction.** `lfindfn_short_panel.m` smooths with
   `kerdist(..., 'order', 8)` at $h \propto \mathrm{sd}(u)\,n^{-1/16}$. Porting with a second-order
   Gaussian collapses the $W$-contrast of the residual CDF to smoothing bias: the operator residual at
   the initial condition came out *below* its value at the truth, so the LF iteration had nothing to
   descend and terminated at iteration 1 with $\mathrm{corr}(\Delta\hat\varphi, \Delta\varphi) = -0.01$.
   `k_order()` / `K_order()` in `lf_panel.R` implement orders 2/4/6/8 and their integrals.
2. **Step size from the operator norm.** The source fixes `cste = 0.5` and compensates with
   $\texttt{imax} \approx 3500$ at $n=989$, which is not runnable in R. `operator_norm2()` sets the
   step to $1/\lVert\mathcal{A}\rVert^2$, reaching the same point on the LF path in $O(100)$ steps.
3. **Stopping rule.** The source stops at the argmin of a joint independence criterion; we stop at the
   argmin of the direct operator residual $\lVert F_1 - F_0\rVert$, which shows clean semiconvergence
   (falls to a minimum, then rises). The source criterion is still computed as a diagnostic.
4. **$\Delta\varphi$ carries an additive offset** because $\varphi$ is integrated and centred
   separately on the two period grids. The offset is absorbed by the constant in $\Delta Z$; this is
   inherited from the source and is harmless, but it means $\varphi$ is identified only up to a
   constant, consistent with the normalisation $E[\vdagger(X)] = 0$.

## 14. Open questions for the user — ALL RESOLVED 2026-07-28

1. **Data access.** ✅ **RESOLVED.** The estimation sample is at `data/raw/data_tsp.txt`: 989 rows
   (matching the application's $n=989$), 30 columns, `CATT` split 689/300. Gitignored as local-only
   per `meta-governance.md`. Eight fiscal columns (`PCGovRev`, `PCPropTax`, `PCGenExpLocalGov`,
   `ExpEduc`, `ExpHighways`, `ExpWelf`, `ExpHosp`, `ExpPol`) carry `NaN`s — a control-selection
   decision is required at Stage 5, not before.
2. **Assumption A1.** ✅ **RESOLVED — conditional, with the full conditional operator.** The user
   rejected the unconditional form. A1 is $\Delta U \upmodels W \mid \Delta Z$ with
   $E[\Delta U\mid\Delta Z]=0$, the *full* conditional restriction is exploited (not its
   $\Delta Z$-average), and the curse of dimensionality is handled by the Bierens device. See §17 and
   the rewritten §2.1–§2.6.
3. **Scope.** ✅ **RESOLVED — fully standalone.** Restate `ass:condcomp`, `ass:sourcecondID`,
   `ass:differentiability`, `ass:scalab` in this paper rather than cross-referencing the companion.
   This closes the six dangling `@`-refs listed in §10.1 and forces a substantial rewrite of Section 2
   — budget for it.
4. **Second-stage $\varphi$.** ✅ **RESOLVED — one LF pass with $\theta$ fixed.** `prp:plugin` as
   drafted: after $\hat\theta$ is obtained, a single LF pass on $\Delta Y - \Delta Z'\hat\theta$ with
   $\theta$ held fixed. Already implemented as `phi_second_stage()` in `scripts/R/orthogonal_theta.R`.
   The alternating loop survives only as a comparison estimator (§12).

**New open question raised by §17, to settle during Stage 2:** the choice of Bierens weight $w$,
transform $\Phi$, index set $\mathcal{T}$ and weighting measure $\mu$ is not pinned down by the theory.
The RKHS/characteristic-kernel route (see §17) makes it a single kernel choice instead of four
separate ones. Decide before `thm:rootn` is stated, because the approximation-error term depends on it.

---

## 17. AMENDMENT 2 (2026-07-28, user-directed) — A1 becomes conditional; Bierens device

This supersedes the original §2.1–§2.6, which have been rewritten in place. Recorded here for
provenance, because it withdraws a claim the earlier plan asserted as settled analysis.

### 17.1 What the plan got wrong

The original §2.2 argued from Lemma L1 that Assumption A1 *must* be unconditional. L1 itself is
correct: under $\Delta U \upmodels W \mid \Delta Z$, the pair $(\vdagger,\theta)$ satisfies the
independence restriction for every $\theta$, so restriction (A) does not identify $\theta_\dagger$.

Remark R1 then inferred that the conditional version "would reduce to a two-step in which $\varphi$ is
recovered first and $\theta$ by ordinary least squares" — i.e. no $\sqrt n$ theorem. **That inference
does not follow.** Two things were conflated:

- **Identification of $\theta$** comes from the mean restriction (B), not from (A). $\theta_\dagger$ is
  identified under the conditional assumption:
  $\theta_\dagger = (E[\Delta Z\Delta Z'])^{-1}E[\Delta Z(\Delta Y - \Delta\vdagger)]$.
- **Debiasing** comes from (A), and a Neyman correction is mean-zero at the truth *by construction*.
  "Carries no information about $\theta$" is a property of every Riesz representer in the DML
  literature, not a defect that disqualifies (A) from serving as the correction.

The naive plug-in is indeed not $\sqrt n$ — its bias is $\langle\hat\varphi-\vdagger,\nu\rangle$, a
nonparametric rate — but that is exactly what orthogonalisation removes, and orthogonalisation is
available under the conditional assumption with $\widetilde W = W - \varrho(\Delta Z)$.

### 17.2 What the user decided

A1 is conditional. The **full** conditional restriction is exploited, not its $\Delta Z$-average, and
the curse of dimensionality in $\Delta Z$ is handled by **Bierens' device**: the conditional moment
restriction is converted into a continuum of unconditional moments indexed by a finite-dimensional
$t$, so no conditional distribution is ever estimated given $\Delta Z$.

### 17.3 Why this is the better paper

- **Economically defensible.** CAAA attainment status was assigned on 1970 TSP levels, which correlate
  with county income, density and manufacturing share. Unconditional independence of $\Delta U$ and
  $W$ is a strong claim in this application; conditional independence is the standard one.
- **A2 gets weaker.** The available directions grow from $\{\lambda(u)\}$ to
  $\{\lambda(u)w(t'\Phi(z))\}$, so $\mathcal{R}(\mathcal{A}^\ast_{\mathrm{cond}})$ strictly contains the
  unconditional range. The source condition — the binding assumption for $\sqrt n$ — is easier to
  satisfy, not harder.
- **Consistent with the draft.** The draft's `ass:condind` (`:78–80`) is already conditional. It is the
  operator at `:124–126` that has to move, not the assumption.

### 17.4 What it costs

- A third nuisance, the propensity $\varrho$, and hence Assumption A4 (overlap). Overlap is a real
  question at a 689/300 split — check it, do not assume it.
- Loss of over-identification: under the unconditional assumption (A) would have carried information
  about $\theta$ and delivered a testable restriction. It no longer does.
- Normalisation N1 becomes load-bearing. Without $E[L\mid\Delta Z]=0$ the moment is not orthogonal in
  $\varrho$ and the propensity would need a $\sqrt n$ rate, defeating the purpose.
- Four new tuning objects ($w$, $\Phi$, $\mathcal{T}$, $\mu$) enter the estimator.

### 17.5 The RKHS connection — probably the right way to state all of this

The user has separately fixed `prp:orthog` in **RKHS balancing form** (§15 amendment, and the
implementation in `solve_balance_weight()`). That choice and the Bierens device are the same idea:

> A **characteristic kernel** has the Bierens property automatically. If $k$ is characteristic on
> $(u,z)$, then $E[\varepsilon\,k((u,z),\cdot)] = 0$ implies $E[\varepsilon\mid Z]=0$ — which is
> precisely what the family $\{w(t'\Phi(z))\}$ is chosen to deliver.

**This equivalence is NOT a contribution — cite it, do not claim it.** When this section was first
written it was flagged as a possible free secondary contribution, and the Stage 1 librarian
independently reached the same conclusion. Both were wrong on the novelty question, and the
librarian-critic caught it. The bridge is already in the literature in at least two places:
Stinchcombe & White (1998), whose *generically comprehensively revealing* families are the injectivity
property under another name, and the Bochner characterisation in Sriperumbudur et al. (2010) — a
shift-invariant kernel is characteristic iff its spectral measure has full support, with
$\{e^{it'v}\}$ the running example. The kernel conditional-moment-test literature states the Bierens
connection outright. Write two sentences with those citations; a referee who knows them will otherwise
read a novelty claim as a literature gap. The *expositional* value stands — one kernel choice
discharging both the identification device and the debiasing bound is worth stating plainly.

So rather than choosing $w$, $\Phi$, $\mathcal{T}$ and $\mu$ separately, state the condition once in
terms of a characteristic kernel on $(u,z)$ and let the representer theorem produce $\hat L$ as a
finite expansion. Concretely, in `orthogonal_theta.R` this is a **contained change**: `Ku`, currently a
Gaussian kernel over the scalar residual $u$, becomes a Gaussian kernel over $(u,\Delta z)$; `wbar`,
currently the scalar `mean(w)`, becomes the cross-fitted vector $\hat\varrho(\Delta Z_i)$; and N1 is
imposed as a linear constraint in the balancing solve. The $n\times n$ solve is unchanged in size.

Honest caveat for the write-up: this does not make the statistical curse of dimensionality disappear.
It re-expresses it as the eigenvalue-decay / source condition on the chosen kernel — which is the
currency this paper already works in, and is why the framing is worth adopting rather than a trick.

### 17.6 Consequences for the stages

- **Stage 1 (Literature).** Coverage area (7) added mid-search: Bierens (1982, 1990), Bierens–Ploberger
  (1997), Stinchcombe–White (1998), characteristic kernels / MMD (Gretton et al., Fukumizu et al.,
  Sriperumbudur et al.), and RKHS-based Riesz-representer estimation. The librarian has been notified.
- **Stage 2.** New target result `lem:bierens`. `prp:orthog` gains parts (ii) and (iii) and the
  normalisation N1. A2 restated for $\mathcal{A}^\ast_{\mathrm{cond}}$. New assumption A4.
- **Stage 3.** The regularity-checker should be primed on the Bierens interchange (differentiating
  $\mathcal{M}(u,t)$ under the integral in $t$) and on whether $\mathcal{T}$ of positive measure
  suffices for the *derivative* family, not just the level family.
- **Stage 4.** The Monte Carlo must include a design where $\varrho$ is genuinely non-constant —
  otherwise the conditional and unconditional estimators coincide and the new theory is untested.
- **Stage 5.** Overlap diagnostics on $\hat\varrho$ become a reported result, not a footnote.
- **§12 "Do not do" still stands**, with one deletion: the instruction not to condition on $\Delta Z$
  anywhere is replaced by "do not estimate a conditional *distribution* given $\Delta Z$" — a scalar
  propensity and the scalar Bierens index are both fine.

---

## 18. STAGE 2 ESCALATIONS AND CORRECTIONS (2026-07-28)

Raised by the proof-strategy memo (`quality_reports/strategy/panel-npiv-discrete/proof_strategy_memo.md`)
and resolved by the orchestrator. Recorded here because several correct errors in §2, which agents were
told to treat as settled analysis.

### 18.1 Resolved — no user decision needed

1. **Six second-order terms, not three pairwise products.** §2.6 corrected in place; A2 promoted to
   **A2′**. The $\|\hat\varphi-\vdagger\|^2$ term is a *square*, forcing $o_P(n^{-1/4})$ outright and
   restricting `thm:rootn` to the mildly ill-posed case. **This is the binding constraint on the
   paper.** Verified independently before acceptance.
2. **`prp:phirate` added to §2.7.** §2.6b delegated the $\hat\varphi$-rate question but created no
   result to carry it.
3. **§15 vs the implementation — resolved in favour of RKHS.** §15 records the sieve balancing form
   (explicit approximation term, $L^2$ norm); `orthogonal_theta.R:120–127` declares it superseded by
   RKHS balancing. The user already chose the **RKHS form** (2026-07-28). §15 is therefore historical;
   `prp:orthog` is stated in RKHS terms. **But see 18.2 — the current kernel makes the bound vacuous.**

### 18.2 THE RKHS KERNEL MUST CHANGE — code and theory both

The §15 balancing bound is $\lVert\mu_g\rVert_{\mathcal H}\cdot\lVert\hat\varphi-\vdagger\rVert_{\mathcal H}$,
in the **RKHS** norm. `balance_gram()` and `Ku` in `scripts/R/orthogonal_theta.R` both use a **Gaussian**
kernel, whose RKHS consists essentially of analytic functions. **An LF iterate is not in it**, so
$\lVert\hat\varphi-\vdagger\rVert_{\mathcal H}=\infty$ and the bound is vacuous.

This is the *same failure mode* §15 already diagnosed for the derivative parameterisation
($\lVert\hat\varphi'-\varphi'\rVert\approx70$ making the bias bound useless) — reappearing in a stronger
norm. The project is about to walk into it twice.

**Fix:** a **Matérn / Sobolev** kernel with smoothness $s$ *below* the source-condition smoothness, plus
an interpolation bound relating the RKHS norm to the $L^2$ norm in which the LF rate is stated. This is
a Stage 4 code change and a Stage 2/3 theory statement; they must use the same kernel.

### 18.3 Corrections to §2 the theorist must apply

- **`cor:trend` follows from A2, not A3** — against this plan's stated expectation (§7). A3 is a
  $p\times p$ *local rank* condition and can hold throughout while the linear direction lies in
  $\ker\mathcal A_{\mathrm{cond}}$, which forces **A2** to fail whenever $E[\Delta Z\,\Delta X]\neq0$.
  The corollary is *stronger* than anticipated. The Stage 3 counterexample probe must therefore test
  **A2**, not A3 — §7's probe (iii) is misdirected as written.
- **Obstacle 4 was misplaced.** There is no indicator in $\psi$; the interchange lives in `lem:adjoint`.
  The density needing continuity is that of $\Delta Y$ given $(X_1,X_2,\Delta Z,W)$ — **`assapp2`
  supplies only $f_U$ and is therefore insufficient as cited.**
- **$\mathcal{T}$ must be compact.** §2.2 requires only "positive Lebesgue measure," which suffices for
  the Bierens *equivalence* but not for differentiating under the integral in $t$. Tighten it.
- **Obstacle 6 restated.** P1(i) needs no Bierens equivalence for the derivative family. The claim that
  actually requires proof is the **strict inclusion**
  $\mathcal R(\mathcal A^\ast_{\mathrm{cond}})\supsetneq\mathcal R(\mathcal A^\ast_{\mathrm{uncond}})$ —
  which is the paper's central technical argument for the conditional route (§17.3) and is currently
  asserted there without proof.
- **The weighting measure $\mu$ drops out of the $\theta$-side** once `lem:bierens` gives density of the
  closed span — the estimator *solves for* $L$ rather than weighting a continuum. A growing family is
  needed only on the $\varphi$-side, where Domínguez–Lobato bites; it must be a **numbered
  identification assumption**, following Poirier. This closes §14's open question on $\mu$ for the
  $\theta$-side.
- ~~**A4's mechanism.** $\mathcal A_{\mathrm{cond}}$ and the raw $W$-contrast operator differ by
  $\varrho(1-\varrho)$; A4 is what makes them equivalent up to a bounded-invertible weight.~~
  **REFUTED 2026-07-28 (Stage 3 C-2 / N-7, confirmed by theorist-critic). This was my claim and it is
  wrong.** The reweighting requires $p_X:=P(W=1\mid X_1,X_2,\Delta Z)$ to equal $\varrho(\Delta Z)$,
  which for binary $W$ is $W\upmodels(X_1,X_2)\mid\Delta Z$ — i.e. *the instrument does not shift the
  endogenous regressor given $\Delta Z$*. That is not merely a strong extra assumption: under the fuller
  conditional independence $W\upmodels(X_1,X_2,\Delta U)\mid\Delta Z$ one gets
  $\mathcal A_{\mathrm{cond}}\equiv0$ — **the operator is annihilated, not reweighted.** The assumption
  the bullet silently needed is destructive of the object it was trying to characterise.

  The correct statement is a comparison of the two operators' **kernels**, built on
  $$E\big[\widetilde W f_{\Delta U\mid X_1,X_2,\Delta Z,W}(u)\,\big|\,X_1,X_2,\Delta Z\big]
  = p_X(1-\varrho)f_1(u)-(1-p_X)\varrho\,f_0(u),$$
  which collapses to $\varrho(1-\varrho)\{f_1-f_0\}$ only in the degenerate case above. Delivered in
  `rem:draftrec`(ii). Use the precise phrasing — "the instrument does not shift the endogenous regressor
  given $\Delta Z$" — not the slogan "the negation of relevance," which carries more than it can.

- **The second half of the old bullet survives and is retained.** As overlap degrades, A2 can hold as a
  range statement while $E[\widetilde W^2\ell_\star^2]=\infty$ — the Khan–Tamer irregularity. Kept as A4
  comment (d) in `assumptions.tex`. Note it is *asserted* there and not yet demonstrated; the
  counterexample-hunter has been primed to probe it.

### 18.4 Scope decisions

- **`prp:effbound` is scoped down from the start.** The independence tangent space is a sum space, and
  projecting onto it requires solving an integral equation that inherits the ill-posedness. Target the
  Severini–Tripathi analogue ("the bound is finite iff A2 holds") plus optimal instrument within class;
  declare full attainment **open**, against Poirier. Do not let the theorist attempt full attainment.
- ~~**Build the Stock–Wright S-set in from the start.** The paper is publishable on the rate theorem
  plus identification-robust inference even if $\sqrt n$ is unreachable.~~
  **WITHDRAWN 2026-07-28 (strategist-critic, C-2). This was wrong and I accepted it without checking.**
  The proposed tier claimed identification-robust inference needs "no A2, no rate condition." It does.
  An S-set inverts $\hat m_n(\theta)$, and under the null
  $$\sqrt n\,\hat m_n(\theta_\dagger)=\sqrt n\,\overline\psi_\dagger-\sqrt n\big\langle\nu+\mathcal A^\ast\hat\ell,\ \hat\varphi-\vdagger\big\rangle+\cdots$$
  The second term vanishes **only by orthogonality, and orthogonality *is* A2.** Without A2 no $\ell$
  solves the adjoint equation, the bias is $O_P(\sqrt n\,\delta_n)\to\infty$, and the statistic has no
  pivotal limit. Dropping A2 would require $\delta_n=o(n^{-1/2})$ — **strictly stronger** than the
  $o(n^{-1/4})$ it was supposed to protect against.

  The three repairs are each worse than advertised: a $\varphi$-free moment is ruled out by the paper's
  own `rem:nophifree`; $\delta_n=o(n^{-1/2})$ is harder than the thing it replaces; and a **profiled**
  S-set is valid but needs uniform control over a $\varphi$-sieve — **exactly the entropy machinery
  `positioning.md` §3 leg 3 promises the paper avoids.** The safety net was woven from the material the
  paper claims not to use.

  **The honest floor is the rate theorem with a concrete $\delta_n$ (i.e. `prp:phirate` doing real work,
  mapping $\delta_n$ to primitives $(s,a)$) plus a trimmed tier — not rate-plus-S-set.** If an
  identification-robust set is wanted, it is the profiled one, and the paper must own the entropy
  requirement rather than deny it.
- **Cap tangential-cone verification at one round.** §2.6 dominates it: the $n^{-1/4}$ wall binds even
  when the TCC holds, so effort spent proving the TCC does not buy the theorem.

---

## 19. USER DECISIONS, 2026-07-28 (Stage 2 escalations 3, 7, 8)

### 19.1 Balancing norm — **SIEVE / $L^2$ dual pairing** (escalation item 3)

`prp:orthog` is stated in the **sieve** form of §15, not the RKHS form. §15 is reinstated as current;
`orthogonal_theta.R:120–127`'s "superseded" note is now wrong and the code must move back.

The governing principle, which is what settles it: **the balancing residual must be measured in the norm
dual to the norm in which a rate for $h$ exists.** The rate is in $L^2(\pi)$, so the residual belongs in
$L^2(\pi)$. The RKHS route failed on exactly this — $\varphi_\dagger$ is assumed only Sobolev-$s$ and is
not in a Gaussian RKHS, so $\|\hat\varphi-\vdagger\|_{\mathcal H}=\infty$ and the bound was vacuous. The
Matérn repair was withdrawn as under-priced (it loses the analytic primitive at
`orthogonal_theta.R:174–177` and needs an uncited uniform $H^m$ stability bound).

Note the weak-dual option is moot regardless: its attraction was that it paired with rung Q-c2, and
Q-c2 is empty (§2.6).

**Owed:** the sieve form carries an explicit $h$-basis approximation term for the part of
$\hat\varphi-\vdagger$ outside $\mathrm{span}(b_1,\dots,b_{L_x})$. Its rate, and the required growth of
$L_x$, were never priced. Price them before `prp:orthog` is stated.

### 19.2 LF stopping rule — **DISCREPANCY PRINCIPLE** (escalation item 7)

Supersedes §16 item 3. Code and theorem must both use it.

Note the justification has changed under it. The strategist argued for the DP because it controls
$\|\mathcal A h\|$ by construction, which rung Q-c2 would have consumed; **that reason died with Q-c2.**
The surviving reasons are independent and sufficient: it is the rule `hanke1995` actually proves
convergence for in the **nonlinear** case, and §16 item 3's argmin rule has no such theorem behind it.
Keep the decision, change the stated reason.

**Owed (critic M-7):** `hanke1995` proves the DP for an *exactly known operator with noisy data*. Here
the noise is in the **operator** — $\hat T$ is built from estimated smoothed CDFs and $\hat\varrho$ — so
$\hat T(\vdagger)\neq0$ and the tangential cone condition must hold for a **random** operator. That is
the Dunker et al. (2014) setting. Also never stated: $\hat\delta_n$ must dominate the true noise level
w.p. $\to1$, or the rule does not stop.

### 19.3 The "$A2$ gets weaker" comparison — **KEEP THE UNCONDITIONAL FRAMING** (escalation item 8)

**Orchestrator's interpretation, flagged for confirmation.** Reading (a) — comparison against genuine
unconditional independence — is what §17.3's motivation says, and both the strategist and its critic
show it is **not well-posed as a theorem**: the two weight classes are not nested
($\{G(W,\Delta U):E[G|\Delta U]=0\}$ versus $\{G:E[G|\Delta U,\Delta Z]=0\}$), and the comparison runs
across two different models, coinciding only where $\varrho$ is constant.

Taking the decision at face value together with that fact, the reading adopted is:

- **§17.3's unconditional framing stays as *motivation*** — informal, economic, about why conditioning
  on $\Delta Z$ is the defensible assumption in this application. It is prose, and it is legitimate as
  prose.
- **No theorem claims it.** The strict-inclusion half of `lem:bierens` is **dropped** (the F4 fallback),
  not proved under reading (b). The Jensen → Douglas → Picard route is recorded in the memo and remains
  available if the position changes.
- **§17.3 must carry an explicit caveat** that "A2 gets weaker" is a heuristic comparison across
  modelling assumptions and not a range inclusion, so no reader or referee mistakes it for a proved
  claim. Without that caveat the paper asserts something it does not establish.

If the intent was instead to attempt the theorem under reading (a), say so — but it cannot be proved as
stated, and the honest alternative is reading (b) with a narrower claim.
