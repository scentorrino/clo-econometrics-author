# Annotated Bibliography — Inference on $\varphi$ in a Nonlinear Ill-Posed NPIV Problem

**Project:** `panel-npiv-discrete` · **Sub-review:** `varphi-inference` · **Compiled:** 2026-08-03

**Question posed.** The paper delivers $\sqrt n$ asymptotic normality for $\theta$ and nothing for $\varphi$. Section 6 (hedonic, Chay–Greenstone county panel, TSP as $X$, nonattainment as $W$) makes $\varphi$ the object of economic interest. Can a confidence band be had? The author's working hypothesis was that the two candidate routes — Chen–Pouzo's multiplier bootstrap and Babii's honest sets — **both require a linear operator**, so each would be a separate paper.

**Verdict in one line.** The hypothesis is **half right, and the half that is wrong is the more useful half.** Babii requires linearity essentially and irreparably. Chen–Pouzo does **not** — their framework is stated for nonlinear ill-posed problems and their worked example (NPQIV) is one. What blocks Chen–Pouzo here is a *different* obstacle, and naming it correctly is worth more to §6 than the linearity story was.

---

## Reading discipline for this document

Every locator below was **read off an object**. Provenance is stated at each entry. Three standing flags:

| Flag | Meaning |
|---|---|
| **WP-NUMBERING** | Locator read from a working-paper/arXiv typescript, not the published article. Published numbering may differ and was **not** checked. |
| **TITLE-LEVEL** | Paper not opened for this review. No equation, assumption, or theorem number is asserted. |
| **ABSTRACT-ONLY** | Only the abstract page was read. Scope claims are provisional and marked as such. |

This register has produced six wrong locators already, all from recall. One near-miss was caught during *this* pass: a guessed TSE working-paper number (`wp_tse_795`) returned a paper on privacy regulation. It was discarded, not patched.

---

# PART A — Directly related: the two named approaches

## A1. Chen & Pouzo (2015), *Sieve Wald and QLR Inferences on Semi/Nonparametric Conditional Moment Models*, Econometrica 83(3), 1013–1079

**Parent key:** `chen2012b` · **This file:** `CHEN_POUZO:2015` · **Proximity: 5**

**Provenance.** Read on disk: `~/Library/CloudStorage/Dropbox/Papers/Nonparametric Instrumental Variables/Chen,Pouzo(2014).pdf`, the arXiv typescript (arXiv:1411.1144), pp. 1–4, 9–14, 15–20, 21–26. **WP-NUMBERING applies to every locator below.**

**Question / method / finding.** Inference on a functional $\phi(\alpha_0)$ of $\alpha_0=(\theta_0',h_0)$ satisfying a conditional moment restriction, when the problem may be ill-posed and $\phi(\alpha_0)$ may or may not be $\sqrt n$-estimable. Method: penalized sieve minimum distance (PSMD) with sieve Wald ($t$) and sieve QLR statistics, plus a bootstrap. Finding: $\sqrt n\{\phi(\hat\alpha_n)-\phi(\alpha_0)\}/\|\hat v^*_n\|_{n,sd}\Rightarrow N(0,1)$ **regardless of whether the functional is $\sqrt n$-estimable**, and the optimally weighted SQLR statistic is $\chi^2_1$ under the null.

**Identification strategy / operator assumption.** The model is

> (1.1) $E[\rho(Y,X;\theta_0,h_0)\mid X]=0$ a.s.$-X$

and the paper says, in its own words on p. 1 of the typescript:

> "The residual function $\rho(\cdot;\alpha)$ could be **nonlinear** and pointwise non-smooth in the parameters $\alpha\equiv(\theta',h)\in\Theta\times\mathcal H$."

and on p. 2:

> "In fact, model (1.1) includes all of the **(nonlinear)** semi/nonparametric IV regressions when the unknown functions $h_0$ depend on the endogenous variables $Y$: (1.2) $E[\rho(Y_1;\theta_0,h_0(Y_2))\mid X]=0$ a.s.$-X$, which could lead to difficult **(nonlinear) nonparametric ill-posed inverse problems with unknown operators**."

and on p. 3:

> "In this paper, for the general model (1.1) that could be **nonlinearly ill-posed** and for any $\phi(\alpha_0)$ that may or may not be root-$n$ estimable, we first establish the asymptotic normality of the plug-in penalized sieve minimum distance (PSMD) estimator $\phi(\hat\alpha_n)$ of $\phi(\alpha_0)$."

**There is no assumption anywhere in this paper that the operator be linear in $h$.** The author's working hypothesis is refuted for Chen–Pouzo, in their introduction, on the first three pages.

### What linearity claim *is* true of Chen–Pouzo, and why it is a trap

The word "linear" appears in three places in their setup, and **none of them is linearity of the operator**:

1. **The LQA condition, (2.4), p. 11.** The high-level "local quadratic approximation" condition "allows for any consistent nonparametric estimator $\hat m(x,\alpha)$ that is **linear in $\rho(Z,\alpha)$**": $\hat m(x,\alpha)\equiv\sum_i\rho(Z_i,\alpha)A_n(X_i,x)$. That is linearity of the *first-stage smoother in the residual*, satisfied by kernels, local linear, series and nearest neighbours. It says nothing about how $h$ enters $\rho$.
2. **The sieve, (2.3), p. 10.** $\mathcal H_{k(n)}$ is a "finite dimensional **linear** sieve" — a linear span of basis functions. That is the approximating space, not the operator.
3. **The Riesz representer, §3.2, p. 25.** $\frac{d\phi(\alpha_0)}{d\alpha}[\cdot]$ must be a bounded **linear** functional. That is linearity of the *derivative of the functional*, which holds by construction for a pathwise derivative.

**The near-miss the brief asked to resolve.** `chen2012`'s title says "possibly nonsmooth generalized residuals." Non-smooth $\neq$ nonlinear-in-the-operator, and the two are genuinely different axes — but Chen–Pouzo cover **both**, independently. Non-smoothness is why they need the SQLR statistic (no simple variance estimator exists when $\rho$ is not pointwise differentiable, p. 3); nonlinearity is handled by pathwise differentiability of the *conditional mean* $m(x,\alpha)$, not of $\rho$. The distinction is resolved: **the title's "nonsmooth" is a weaker and separate claim than "nonlinear", and the paper makes the nonlinear claim explicitly elsewhere.**

### The assumptions that actually carry the nonlinearity

- **Assumption 3.1(i), p. 21.** "$E[\rho(Y,X;\alpha)\mid X]=0$ if and only if $\alpha\in(\mathcal A,\|\cdot\|_s)$ with $\|\alpha-\alpha_0\|_s=0$." Global point identification, stated directly. **Completeness is not invoked.** The present paper can satisfy this — it is what CFF (2025) establish for the binary-instrument case.
- **Assumption 3.4(i), p. 23.** "There exists a convex $\|\cdot\|_s$-neighborhood of $\alpha_0$, $\mathcal A_{os}$, such that $m(\cdot,\alpha)$ is continuously pathwise differentiable with respect to $\alpha\in\mathcal A_{os}$..." — **this is the linearisation condition**, and it is a local smoothness requirement on a possibly nonlinear operator, not a linearity requirement.
- **Assumption 3.4(ii), p. 23.** "$Q(\alpha)\asymp\|\alpha-\alpha_0\|^2$ for all $\alpha\in\mathcal A_{os}$", where $\|\cdot\|$ is the pseudo-metric (3.1) induced by the *derivative* $\frac{dm(X,\alpha_0)}{d\alpha}$. **This is the econometric cousin of the tangential cone condition** in nonlinear Landweber (`hanke1995`): it says the nonlinear criterion is equivalent, up to constants, to its own linearisation on a neighbourhood. The paper already carries `hanke1995` for exactly this device, so the two are structurally compatible.
- **Sieve measure of local ill-posedness, (3.3), p. 24.** $\tau_n\equiv\sup\|\alpha-\Pi_n\alpha_0\|_s/\|\alpha-\Pi_n\alpha_0\|$, denominator in the derivative-induced metric. Every rate and every variance in the paper is governed by the **linearisation at $\alpha_0$**, never by a global linearity.

### The estimand: point evaluation IS covered

p. 2: "Let $\phi:\Theta\times\mathcal H\to\mathbb R^{d_\phi}$ be a (possibly nonlinear) functional with a finite $d_\phi\ge1$. Typical linear functionals include an Euclidean functional $\phi(\alpha)=\theta$, **a point evaluation functional $\phi(\alpha)=h(\bar y_2)$** (for $\bar y_2\in\mathrm{supp}(Y_2)$), a weighted derivative functional..."

So **pointwise confidence intervals for $\varphi(x)$ are inside their framework**, and are explicitly listed. p. 17–18 of the typescript notes that "the point evaluation functional $\phi(h)=h(\bar y_2)$ is known to be irregular for the nonparametric LS regression and hence for the NPIV (2.18) as well" — irregular, i.e. $\lim_{k(n)}\|v^*_n\|^2_{sd}=\infty$ — and Theorem 4.2 is cited as showing the sieve variance is still consistently estimable in that case, so the studentised statistic is still asymptotically standard normal.

### The bootstrap is a multiplier bootstrap, and the brief's attribution is defensible

(2.14)–(2.16), p. 15: the bootstrap PSMD criterion replaces $\rho(Z_i,\alpha)$ with $\omega_{i,n}\rho(Z_i,\alpha)$, where "$\{\omega_{i,n}\ge0\}$ is a sequence of bootstrap weights that has mean 1 and is independent of the original data", with i.i.d. weights satisfying $E[\omega_i]=1$, $E[|\omega_i-1|^2]=1$ or multinomial weights. Their name for it: "We sometimes call our bootstrap procedure **'generalized residual bootstrap'** since it is based on randomly perturbing the generalized residual function $\rho(Z,\alpha)$." That is a multiplier bootstrap on the generalized residual. The resulting set, (2.17): $\{r\in\mathbb R:\ \widehat{QLR}_n(r)\le\hat c_n(1-\tau)\}$, and "the bootstrap consistency holds for possibly non-optimally weighted SQLR statistic and **possibly irregular functionals, without the need to compute standard errors**."

### The worked nonlinear example — this is the existence proof

**NPQIV, (2.22), p. 19:** $Y_1=h_0(Y_2)+U$, $\Pr(U\le0\mid X)=\gamma$. This is a genuinely nonlinear ill-posed inverse problem — $h_0$ sits inside an indicator. Theorem 4.1 is applied to it directly, with sieve variance (2.23) built from $D_n=\frac1{\gamma(1-\gamma)}E\big(E[f_{U|Y_2,X}(0)q^{k(n)}(Y_2)\mid X]E[f_{U|Y_2,X}(0)q^{k(n)}(Y_2)\mid X]'\big)$ — note $f_{U|Y_2,X}(0)$, the derivative of the nonlinear operator at $h_0$. And p. 20 records an empirical illustration:

> "See Subsection 7.2 for an empirical illustration of this result to the NPQIV Engel curve regression using the British Family Survey data set that was first used in Blundell *et al.* (2007)."

**So: inference on the nonparametric component of a nonlinear ill-posed inverse problem exists, is published in Econometrica, and has an empirical illustration.** That settles the brief's question 2 in the affirmative.

### What actually blocks porting it to this paper

Three obstacles, in decreasing order of severity. None of them is linearity.

1. **The regularisation index is deterministic; ours is data-driven. (Essential, and it also kills Babii.)** Chen–Pouzo's regularisation is the sieve dimension $k(n)$, a deterministic sequence — Assumptions 3.1(ii), 3.2, 3.3, 3.4, Lemmas 3.1 and 3.2 and the sieve variance (2.6)/(2.10) are all indexed by it. The present paper regularises by **Landweber–Fridman iteration stopped by a discrepancy rule**, so the regularisation index is a *random* stopping time. Nothing in Chen–Pouzo covers a random index. Closing this is not a technicality; it is the standard hard problem in adaptive inference and it is what makes the whole enterprise a separate paper.
2. **$d_\rho$ is finite and the conditioning variable is $X$. (Surmountable, but it is work.)** $m(X,\alpha)\equiv E[\rho(Y,X;\alpha)\mid X]$ is a $d_\rho\times1$ vector and $\Sigma(X)$ is $d_\rho\times d_\rho$ (p. 9–10): $d_\rho$ is finite. With $W$ binary and $d_\rho$ finite, conditioning on $W$ delivers finitely many restrictions and cannot pin an infinite-dimensional $\varphi$. The Bierens device produces a **continuum** of moments indexed by the weight parameter, which is not literally (1.1). Recasting means either indexing $\rho$ by an auxiliary continuous argument so the conditioning variable becomes $(W,u)$ — how the full-independence NPIV literature sets it up (`dunker2014`, `dunker2021`, `dunker2015`) — or moving to continuum-of-moments GMM. Either is a modelling decision with its own asymptotics.
3. **The linearisation must support a bounded sieve Riesz representer.** §3.2, p. 25 builds everything on the inner product $\langle v_1,v_2\rangle=E[(\frac{dm(X,\alpha_0)}{d\alpha}[v_1])'\Sigma(X)^{-1}(\frac{dm(X,\alpha_0)}{d\alpha}[v_2])]$ and notes that "$(\bar{\mathbf V},\|\cdot\|)$ is an infinite dimensional Hilbert space (under Assumptions 3.1(i)(iii)(iv) and 3.4(i)(ii))." The evaluation functional's representer must be bounded in **that** metric on the sieve. Here the relevant linearisation is precisely the object whose source-condition ceiling $\beta\le1-\epsilon$ the author already established for the binary-instrument case; the machinery would have to be re-derived under that ceiling rather than imported.

**Bottom line for A1.** Linearity is **not** the obstacle and citing it as one would be a mis-citation a methods referee could catch by reading Chen–Pouzo's abstract. The obstacle is the **random stopping index** first, the **continuum-of-moments recasting** second.

---

## A2. Babii (2020), *Honest Confidence Sets in Nonparametric IV Regression and Other Ill-Posed Models*, Econometric Theory 36(4), 658–706

**Key:** `BABII:2020` · **Proximity: 5**

**Provenance.** Read on disk: arXiv:1611.03015v4 (paper dated 24 Oct 2019, arXiv stamp 19 Dec 2020), pp. 1–4, 6–11, 12–14. **WP-NUMBERING applies.** Published ET numbering not checked; no ET-numbered locator asserted.

**Question / method / finding.** Honest **uniform** (sup-norm) confidence sets for $\varphi$ in ill-posed models treated with Tikhonov regularisation. Two constructions: one from a data-driven concentration inequality, one from Gaussian/bootstrap coupling à la Chernozhukov–Chetverikov–Kato. Finding: both have coverage and expected diameter valid **uniformly over a class of models**, with explicit non-asymptotic coverage-error rates.

### The operator is linear, and here is exactly where

**§3.1, p. 8.** The model is stated as $Y=\varphi(Z)+U$, $E[U\mid W]=0$ — a **conditional mean** restriction — leading to (3) $E[Y\mid W=w]=E[\varphi(Z)\mid W=w]$ and then

$$r(w)\triangleq E[Y\mid W=w]f_W(w)=\int_{[0,1]^p}\varphi(z)f_{ZW}(z,w)\,\mathrm dz\triangleq(T\varphi)(w).$$

$T$ is a linear integral operator by construction.

**The estimator, §3.1, p. 9.** $\hat\varphi=\arg\min_{\phi\in L_2}\|\hat T\phi-\hat r\|^2+\alpha_n\|\phi\|^2$, "which admits a **closed-form solution** $\hat\varphi=(\alpha_nI+\hat T^*\hat T)^{-1}\hat T^*\hat r$, where $\hat T^*$ is the adjoint operator of $\hat T$." The closed form and the Hilbert adjoint both exist *because* $T$ is linear.

**Assumption 3.1, §3.2, p. 9 — the load-bearing one.** Verbatim:

> "The structural function $\varphi$ and the 1-1 operator $T:C[0,1]^p\to C[0,1]^q$ belong to the following class
> $$\mathcal F=\mathcal F_{\beta,t,M,C}=\{(\varphi,T)\in C^t_M[0,1]^p\times\mathcal L_{2,\infty}:\ \varphi=(T^*T)^\beta T^*\psi,\ \kappa(\varphi,\psi,T,T^*)\le C\},$$
> where $\kappa(\varphi,\psi,T,T^*)=\|\varphi\|_\infty\vee\|T^*\|_{2,\infty}\vee\|\psi\|\vee\|T\|^{-1}$ and $0<\beta,t,M,C<\infty$."

Three linearity dependencies in one line: $\mathcal L_{2,\infty}$ is defined on p. 6 as a space of **bounded linear operators**; $T^*$ is the **Hilbert adjoint**, which presupposes linearity; and the source condition $\varphi=(T^*T)^\beta T^*\psi$ is a statement in the **spectral calculus of $T^*T$**, which has no meaning for a nonlinear map.

**Proposition 3.1, p. 10.** $\sup_{(\varphi,T)\in\mathcal F}\|(\alpha_nI+T^*T)^{-1}T^*r-\varphi\|_\infty\le R\,\alpha_n^{\beta\wedge1}$ with $R=C^2[\beta^\beta(1-\beta)^{1-\beta}\mathbb 1_{0<\beta<1}+C^{2(\beta-1)}\mathbb 1_{\beta\ge1}]$. **This is the regularisation-bias bound, it is uniform over $\mathcal F$, and it is what makes the sets honest.** It is pure linear spectral calculus. Note the saturation at $\beta=1$, which Babii flags on p. 10 as "reminiscent of the saturation of convergence of the kernel density estimator."

**Verdict: linearity is ESSENTIAL, not convenience.** It enters at all four load-bearing places the brief asked about — the estimator's closed form, the **bias characterisation** (Prop. 3.1), the **critical-value construction** (both $\hat q_n$ and $q^*_n$ below are built from $(\alpha_nI+T^*T)^{-1}T^*$ and $\|\hat T^*\|_{2,\infty}$), and the **coupling** (which is applied to a linear functional of residuals). Replacing $T$ by a nonlinear $\mathcal F(\cdot)$ does not perturb this proof; it deletes it.

### A second, independent failure: completeness

**Assumption 3.2(v), p. 10:** "the integral operator $T:C[0,1]^p\to C[0,1]^q$ is 1-1." Babii's own commentary, p. 11:

> "Assumption (v) is a completeness condition which may be questionable in empirical applications. Note, however, that in many cases the completeness condition can be relaxed, and it is possible to have valid inferences for various deviations from the completeness condition, see Babii and Florens (2020) for more details."

**A binary instrument cannot deliver completeness. That is the paper's entire premise.** So Babii fails here on two logically independent grounds. Note also that "Babii and Florens (2020)" is the working-paper year for the parent's `babiiflorens2025` (*Is Completeness Necessary?*, ET 41(6), 2025) — **same paper, fossil year**, not a distinct reference.

### What honesty costs

**Honesty defined, eq. (2), §2, p. 7:** $\inf_{P\in\mathcal P}\Pr(\varphi(z)\in C_{n,1-\gamma}(z),\ \forall z\in[0,1]^p)\ge1-\gamma-O(\delta_n)$, versus the dishonest requirement $\inf_P\liminf_n\Pr(\cdot)\ge1-\gamma$.

**What has to be assumed.** Three things, and the third is the interesting one:
1. A **source condition with a known exponent $\beta$** (Assumption 3.1) — the class $\mathcal F$ is indexed by $\beta,t,M,C$.
2. **Completeness** (Assumption 3.2(v)) and a battery of smoothness/kernel/moment conditions (3.2(i)–(iv)).
3. **The model class must restrict the OPERATOR, not just the function.** p. 4: "we show that the class of models should involve both the class of functions and the class of operators, **which is different from classical direct nonparametric problems where we need only to restrict the function**." This is the structural price of honesty in an inverse problem and it is worth quoting in §6 if the point is ever made in print.

**How wide the sets get.** The bands are constant-width, eq. (4), p. 11: $C^*_{n,1-\gamma}=\{[\hat\varphi(z)-q^*_n,\hat\varphi(z)+q^*_n]\}$ and $C_{n,1-\gamma}=\{[\hat\varphi(z)-\hat q_n,\hat\varphi(z)+\hat q_n]\}$, with $q^*_n=\frac{c^*_{1-\gamma}\|\hat T^*\|_{2,\infty}+\log^{-1}n}{\alpha_n\sqrt{nh^q_n}}$ and $\hat q_n=2\|\hat\nu^\eta_n\|_\infty+\frac{3\|\hat T^*\|_{2,\infty}F\|k\|^q\sqrt{2\log(1/\gamma)}+\log^{-1}n}{\alpha_n\sqrt{nh^q_n}}$. Here $\|\hat\nu^\eta_n\|_\infty$ is a **Rademacher multiplier bootstrap** statistic and $c^*_{1-\gamma}$ a Gaussian multiplier quantile.

**Theorem 3.2, p. 13** gives the price:

$$\sup_{P\in\mathcal P}E_P|C_{n,1-\gamma}|_\infty=O\!\left(\frac1{\alpha_n\sqrt{nh^q_n}}\right),\qquad |C^*_{n,1-\gamma}|_\infty=O_p\!\left(\frac1{\alpha_nh^q_nn^{1/2}}\right).$$

So the width is the sup-norm **variance** rate inflated by $1/\alpha_n$ — the bands do **not** subtract an estimated bias. Honesty is bought instead by (a) the *uniform* bias bound of Prop. 3.1 and (b) tuning conditions in Assumption 3.2(vi) — e.g. $\alpha_n^{2(\beta\wedge1+1)}h^q_nn\log^2n\to0$ — which force the bias below the width. **That is undersmoothing, dressed properly.** Theorem 3.1, p. 12 gives the coverage error $\delta_n$ explicitly (a five-term expression); Babii's own gloss, p. 4: "**the bias of the estimator, not the noise coming from the estimation of the operator, drives the coverage errors of our confidence sets.**"

**Bottom line for A2.** The author's hypothesis is **correct for Babii**, and doubly so: linearity is essential *and* completeness fails independently. Extending it would require re-proving Prop. 3.1 for a nonlinear operator with a random regularisation index — i.e. not an extension.

---

## A3. Centorrino, Fève & Florens (2025), *Iterative estimation of nonparametric regressions with continuous endogenous variables and discrete instruments*, Journal of Econometrics 247, 105950

**Parent key:** `centorrinofeveflorens2019` · **Proximity: 5** — and the single most load-bearing entry in this file for §6.

**Provenance.** Read on disk: `~/Library/CloudStorage/Dropbox/Nonparametric_IV/Discrete Instruments/Nonparametric/3_Revision_JE_3/Centorrino_Feve_Florens_2024_3.tex`, §"Estimation of returns to education" and §"Conclusions". **This is the R3 revision typescript, not the published PDF.** R3 is dated October 2024 and the article appeared in 2025, so R3 is almost certainly the accepted text — but that was not verified and the quotations below should be checked against the published version before they are relied on in print.

**Why it decides the question.** This is the author's own direct companion: same nonlinear operator equation from full independence, same **binary** instrument, same Landweber–Fridman estimator, published in a top field journal after three rounds of revision. It faced precisely the problem §6 now faces.

**What it did with $\varphi$.** From the empirical section:

> "The dotted lines show the $95\%$ pointwise confidence intervals for $\hat\varphi_{N,1}$, $\hat\varphi_{N,2}$, $\hat\varphi_{N,3}$ obtained by nonparametric bootstrap with $99$ replications. **The confidence intervals for the nonparametric estimator are presented only to illustrate its variability but should not be considered valid.**"

and later in the same section:

> "The wide confidence intervals (dashed-dotted lines) indicate higher uncertainty in the estimates."

and from the conclusion:

> "**Future work should focus on providing valid inference procedures** and carefully studying the case with additional exogenous controls."

**This is the convention, demonstrated at the journal tier the present paper is aiming below.** Report a pointwise nonparametric bootstrap interval; state in one sentence that it is illustrative and not valid; name valid inference as future work. In the Monte Carlo the same paper is careful to call its bands what they are — the caption reads "LF Monte-Carlo means and pointwise $2.5\%$ and $97.5\%$ **quantiles**", i.e. a sampling distribution across replications, not a confidence band.

**Consequence for §6.** The author does not need to discover a convention. He set one, in this exact model, and referees accepted it.

---

# PART B — Same problem class, different regularisation: uniform bands in *linear* NPIV

These are the frontier on the other side of the line. Each assumes the conditional-mean restriction and a linear operator. They belong in §6 or the literature review as *the benchmark that does not apply*, and saying so explicitly is a contribution in itself.

## B1. Chen, Christensen & Kankanala (2025), *Adaptive Estimation and Uniform Confidence Bands for Nonparametric Structural Functions and Elasticities*, Review of Economic Studies 92(1), 162–196

**Key:** `CHEN_CHRISTENSEN_KANKANALA:2025` · **Proximity: 4** · **ABSTRACT-ONLY**

Data-driven sieve dimension attaining minimax sup-norm rates for $h_0$ and its derivatives, plus UCBs that "guarantee coverage over a generic class of data-generating processes and contract at the minimax rate, possibly up to a logarithmic factor" — i.e. honest and near-adaptive, built (per the Cowles/RePEc description) on a **bootstrapped Lepski procedure in sup-norm**. Their own selling point is the comparison the brief asked about: "our UCBs are asymptotically more efficient than UCBs based on the usual approach of **undersmoothing**."

**This is the direct answer to "adaptive/Lepskii-type confidence sets are a natural place to look."** They exist, they are the current state of the art, and they are for **linear** NPIV via sieve 2SLS. There is an `npiv` R package (Chen–Christensen–Racine). Note the bib entry's `year` field reads 2024 while the issue is January 2025 — copied verbatim per N-21, flagged rather than repaired.

**Why it does not transfer.** Lepski balancing is over the *sieve dimension*, a scalar index of a linear-sieve family; the bias term being balanced is the linear approximation bias, characterised through the linear operator. It is not a drop-in for a Landweber discrepancy stopping rule in a nonlinear equation — but it is the closest thing to a template if the author ever writes the companion inference paper, and it is where the "cost of adaptation" accounting lives.

## B2. Chen & Christensen (2018), *Optimal Sup-norm Rates and Uniform Inference on Nonlinear Functionals of Nonparametric IV Regression*, Quantitative Economics 9(1), 39–84

**Key:** `CHEN_CHRISTENSEN:2015` (fossil key) · **Proximity: 4** · **TITLE-LEVEL**

**Flagged as a mis-citation hazard.** "Nonlinear functionals" means consumer surplus, elasticities, and similar nonlinear maps of a structural function that solves a **linear** operator equation. It is *not* inference in a nonlinear operator equation. A methods referee would catch this immediately. Sieve score bootstrap for uniform bands over collections of such functionals.

## B3. Horowitz & Lee (2012), *Uniform confidence bands for functions estimated nonparametrically with instrumental variables*, Journal of Econometrics 168(2), 175–188

**Key:** `HOROWITZ_LEE:2012` · **Proximity: 4**

**Provenance.** Read on disk (published version, despite the filename): `~/Library/CloudStorage/Dropbox/Papers/Nonparametric Instrumental Variables/Horowitz,Lee(2011).pdf`, pp. 1–2.

Model (1.1) $Y=g(X)+U$, $E(U\mid W=w)=0$, with $W\in\mathbb R^q$ **continuously distributed**. Sieve estimator; the operator $(Av)(w):=\int v(x)f_{XW}(x,w)\,\mathrm dx$ is linear with $Ag=m$. Bootstrap critical values. The band is built by taking simultaneous pointwise intervals on a finite grid $x_1,\dots,x_L$ and interpolating using smoothness or monotonicity.

**Convention evidence, and unusually candid.** Their own §1: "The resulting uniform confidence band is not asymptotically exact if $L<\infty$; its true and nominal coverage probabilities are not necessarily equal even asymptotically. But the confidence band can be made arbitrarily accurate... by letting $L\to\infty$ as $n\to\infty$." In Babii's vocabulary this is a **dishonest** band, published in a top field journal, with the limitation stated in the introduction. They also explain why the natural route is blocked: "A seemingly natural approach to constructing a confidence band is to obtain the asymptotic distribution of a suitably scaled version of $\sup_x|\hat g(x)-g(x)|$... However, when $\hat g$ is a sieve estimator, this is a difficult problem that has been solved only for special cases."

## B4. Darolles, Fan, Florens & Renault (2011), *Nonparametric Instrumental Regression*, Econometrica 79(5), 1541–1565

**Key:** `DAROLLES_FAN_FLORENS_RENAULT:2011` · **Proximity: 3** · **TITLE-LEVEL**

The kernel Tikhonov estimator Babii's whole apparatus is built on (his §3.1 says so explicitly). Background for why Babii's construction is inseparable from a linear $T$.

## B5. Blundell, Chen & Kristensen (2007) · B6. Horowitz (2011)

**Keys:** `BLUNDELL_CHEN_KRISTENSEN:2007`, `HOROWITZ:2011` · **Proximity: 2** · **TITLE-LEVEL**

The canonical applied NPIV targets. BCK's British Family Survey Engel curves are the data set both Chen–Pouzo (§7.2) and Babii (§6) use for their empirical illustrations, which makes them the reference point for what an applied NPIV section is expected to display.

---

# PART C — UQ in genuinely nonlinear ill-posed inverse problems (outside econometrics)

## C1. Monard, Nickl & Paternain (2021), *Statistical guarantees for Bayesian uncertainty quantification in non-linear inverse problems with Gaussian process priors*, Annals of Statistics 49(6)

**Key:** `monardnicklpaternain2021` · **Proximity: 4**

**Provenance.** Read on disk: arXiv:2007.15892v2 (stamped 14 Apr 2021), pp. 1–3. **WP-NUMBERING.** Journal/volume/DOI are ON-DISK UNVERIFIED and pages are omitted.

**The model is genuinely nonlinear.** Eq. (1): $Y_i=\mathscr G(\theta)(X_i)+\sigma\varepsilon_i$, $i=1,\dots,N$, with $\theta\mapsto\mathscr G(\theta)$ "a non-linear 'forward map'". Applications: an elliptic inverse problem for a Schrödinger equation, and inversion of non-Abelian X-ray transforms.

**What is covered, and this is the whole point.** p. 2, verbatim:

> "Specifically, conditions will be provided under which optimal asymptotic semi-parametric inference is possible for **linear functionals $\langle\theta,\psi\rangle$ for smooth $\psi\in C^\infty$**, from data in (1)... As a consequence Bayesian credible sets for such parameters are shown to be valid frequentist confidence sets."

**Not the whole function.** The guarantee is for smooth linear functionals at the semiparametric ($\sqrt N$) rate — obtained via a Bernstein–von Mises theorem.

**The two conditions, p. 2–3.** (i) **Global consistency**: the posterior concentrates on a shrinking $\|\cdot\|_\infty$-neighbourhood of $\theta_0$, which "requires 'global' stability estimates for the inverse problem". (ii) **Invertibility of the linearised information operator**: "If we denote by $\mathbb I_{\theta_0}$ the linear operator obtained from **linearising the non-linear map $\mathscr G$ near the ground truth $\theta_0$**... What can be made rigorous, however, only if the **information (or normal) operator $\mathbb I^*_{\theta_0}\mathbb I_{\theta_0}$ is surjective onto a large enough range**, and if the mapping properties of its inverse allow for the composition of $\mathbb I_{\theta_0}$ with $(\mathbb I^*_{\theta_0}\mathbb I_{\theta_0})^{-1}$. In the settings above this is not at all clear a-priori and in fact it generates new PDE questions in its own right."

**Why this matters for §6, and it is the most quotable finding in this file.** The state of the art in the mathematical inverse-problems literature for **nonlinear** problems delivers exactly what the present paper's theorem already delivers — valid inference for the *regular, root-$n$-estimable, finite-dimensional* part, obtained by linearising at the truth — and **stops there**. The $\theta$-yes/$\varphi$-no boundary is not a shortcoming of this paper. It is where the frontier is, in two literatures independently.

## C2. Dunker (2015), *Convergence of the risk for nonparametric IV quantile regression and nonparametric IV regression with full independence*

**Key:** `dunker2015` · **Proximity: 4**

**Provenance.** Read on disk: `~/Library/CloudStorage/Dropbox/Nonparametric_IV/Discrete Instruments/Nonparametric/Papers/Dunker(2018).pdf`, pp. 1–2. arXiv:1511.03977v1. **Distinct from the parent's `dunker2021`** (EJS 15(2), full independence, adaptive) — same author, different paper.

Model, eq. (1): $\mathcal F(\varphi)=\psi$, "a possible **nonlinear** operator equation", with $\mathcal F$ unknown and only $\hat{\mathcal F}$ available. Estimator: iteratively regularised Gauss–Newton (IRGNM) with iterated Tikhonov. Contribution over `dunker2014`: spectral methods plus a modification of Hoeffding's inequality, "a significantly **weaker non-linearity condition** for the operator $\mathcal F$", and faster rates for smooth regression functions.

**What it delivers: convergence rates of the risk. No confidence sets.** Together with `dunker2014` and `dunker2021` this is the closest existing work to the present paper's estimation problem, and none of the three constructs a band. That is the negative evidence the §6 framing rests on, and it is strong because it comes from the one author who has worked this exact model class hardest.

## C3. Kaltenbacher, Neubauer & Scherzer (2008), *Iterative Regularization Methods for Nonlinear Ill-Posed Problems*

**Key:** `kalten2008` · **Proximity: 3** · **TITLE-LEVEL** (a copy is on disk; not opened for this review, so **no chapter or theorem locator is asserted**)

The monograph for the numerical-analysis side the brief asked to search — the book-length companion to `hanke1995`. This literature is overwhelmingly **deterministic-noise**: it delivers convergence, rates, and stopping-rule theory, not coverage statements. Where it does go statistical (`bissantz2007`), it delivers rates under random noise, still not confidence sets.

## C4. Bissantz, Hohage & Munk (2007), SIAM J. Numer. Anal. 45(6), 2610–2636

**Key:** `bissantz2007` · **Proximity: 2** · **TITLE-LEVEL**

Rates for general regularisation methods in statistical inverse problems. Named because the brief asked for the Hohage/Munk line specifically. Rates, not bands.

## C5. Szabó, van der Vaart & van Zanten (2015), *Frequentist coverage of adaptive nonparametric Bayesian credible sets*, Annals of Statistics

**Key:** `szabovdvvz2015` · **Proximity: 2** · **ABSTRACT-ONLY, and the weakest-warranted entry in this file**

No Szabó entry exists in any `.bib` on disk; volume and pages are **omitted** because they were not verified; nothing was read beyond search snippets. Cited for one general proposition only, and **no theorem number is asserted**: adaptive confidence sets are impossible without an extra signal-strength restriction, and the literature buys them with **self-similarity** or **polished-tail** conditions.

**Why it belongs here anyway.** It is the general reason the honest-band problem is hard, and it applies a fortiori in an ill-posed nonlinear setting. If §6 ever needs a one-sentence justification for "a valid band is out of scope", this is the shape of it: even in the *direct*, *linear*, well-posed problem, honest adaptive bands need an assumption nobody can check.

---

# PART D — Scooping watch

## D1. van der Laan, Kallus & Bibaut (2025), *Nonparametric Instrumental Variable Inference with Many Weak Instruments*, arXiv:2505.07729 (v1 12 May 2025; v3 1 Jan 2026)

**Key:** `vanderlaankallusbibaut2025` · **Proximity: 3** · **ABSTRACT-ONLY**

Inference on **linear functionals** in NPIV with a discretely-valued instrument, under **many-weak-instrument asymptotics where the number of instrument levels grows with $n$**. Point identification fails with finitely many moments, so they target linear functionals of the **minimum-norm** solution, and build npJIVE plus automatic debiased ML estimators.

**Not a scoop, and the reason is structural, not chronological.** Three mismatches: their instrument count grows, ours is fixed at two; their operator equation is linear (conditional mean), ours is nonlinear (full independence); their targets are linear functionals, ours is $\varphi$ itself. But it is the nearest recent neighbour on "discrete instruments $+$ inference" and should be cited so a referee does not raise it first. It is also independent corroboration that with a *fixed* discrete instrument and a *linear* restriction the problem is not point identified — which is precisely why this paper uses independence instead.

## D2. Lob, Singh & Vijaykumar (2025), *Uniform inference for kernel instrumental variable regression*, arXiv:2511.21603 (26 Nov 2025)

**Key:** `lobsinghvijaykumar2025` · **Proximity: 3** · **ABSTRACT-ONLY, scope unresolved**

Uniform confidence sets for kernel IV regression, "allowing general nonlinearities and data types", bootstrap requiring only a single run of the estimator.

**Scope caution, stated because it is genuinely unresolved.** In the kernel-IV literature "general nonlinearities" normally means a nonlinear structural function $h$ inside a **linear** conditional-moment operator equation, which would make this another B-family paper. That was **not verified** — only the abstract was read. **Open the paper before citing it as nonlinear-operator precedent.** If it does turn out to handle a nonlinear operator, it is the most important recent development for this project and should be re-reviewed at priority.

---

# PART E — Cross-references to the parent bibliography

Already present in `../references.bib`; not duplicated here. Their role in *this* question:

| Key | Role in the $\varphi$-inference question |
|---|---|
| `chen2012` | Chen & Pouzo (2012). The **rate/consistency** paper behind A1's inference theory. Its "possibly nonsmooth generalized residuals" is the near-miss resolved in A1. Proximity 4. |
| `chen2012b` | = A1. Cite by this key when merging. Proximity 5. |
| `babiiflorens2025` | *Is Completeness Necessary?* — the escape hatch **Babii himself points to** for Assumption 3.2(v). Proximity 4. |
| `dunker2014` | Dunker, Florens, Hohage, Johannes & Mammen (2014). Nonlinear NPIV, iterative estimation, **rates only**. Proximity 4. |
| `dunker2021` | Dunker, EJS. Full independence, **adaptive** estimation, nonlinear. Rates and adaptation, **no confidence sets** — the closest miss in existence. Proximity 5. |
| `hanke1995` | Nonlinear Landweber, tangential cone condition. The deterministic analogue of Chen–Pouzo Assumption 3.4(ii). Proximity 4. |
| `engl2000` | Regularisation of inverse problems. Background. Proximity 3. |
| `lepskii1990` | The adaptation device B1 bootstraps. Proximity 3. |
| `feve2014` | Fève & Florens, panel NPIV. Context. Proximity 3. |
| `centorrinofeveflorens2019` | = A3. **The convention precedent.** Proximity 5. |
