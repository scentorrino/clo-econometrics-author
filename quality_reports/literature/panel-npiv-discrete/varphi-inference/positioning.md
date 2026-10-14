# Positioning — What §6 Can Honestly Say About $\varphi$

**Project:** `panel-npiv-discrete` · **Sub-review:** `varphi-inference` · **Compiled:** 2026-08-03

---

## 1. Direct answers to the four questions

### Q1 — Verify or refute the linearity constraint, for each named approach

| | **Babii (2020)** | **Chen & Pouzo (2015)** |
|---|---|---|
| **Is linearity assumed?** | **Yes.** | **No.** |
| **Where** | Assumption 3.1: $(\varphi,T)\in C^t_M[0,1]^p\times\mathcal L_{2,\infty}$ with $\varphi=(T^*T)^\beta T^*\psi$. $\mathcal L_{2,\infty}$ is a space of *bounded linear operators*; $T^*$ is the *Hilbert adjoint*; the source condition is *spectral calculus of $T^*T$*. | Nowhere. Their (1.2) is described in their own text as leading to "**(nonlinear) nonparametric ill-posed inverse problems with unknown operators**"; §1 says the paper treats models "that could be **nonlinearly ill-posed**". |
| **Essential or convenience?** | **Essential.** It carries all four load-bearing roles: closed-form estimator $\hat\varphi=(\alpha_nI+\hat T^*\hat T)^{-1}\hat T^*\hat r$; **bias characterisation** (Proposition 3.1, the uniform bound $R\alpha_n^{\beta\wedge1}$ that *is* the honesty); **critical values** ($q^*_n$, $\hat q_n$ built from $(\alpha_nI+T^*T)^{-1}T^*$ and $\|\hat T^*\|_{2,\infty}$); **coupling** (applied to a linear functional of residuals). Deleting linearity deletes the proof rather than perturbing it. | n/a. The three places "linear" appears are the first-stage smoother being linear in $\rho$ (LQA, (2.4)), the sieve being a linear span ((2.3)), and the functional's derivative being a bounded linear functional (§3.2). **None is operator linearity.** |
| **Second, independent failure** | **Yes — completeness.** Assumption 3.2(v): "$T:C[0,1]^p\to C[0,1]^q$ is 1-1." A binary instrument cannot deliver it. Babii's own note points to `babiiflorens2025` as the escape hatch. | Assumption 3.1(i) states point identification **directly**, without completeness. The paper can satisfy it. |
| **What would extension take?** | Re-proving Proposition 3.1 — a uniform regularisation-bias bound — for a nonlinear map with no adjoint and no spectral calculus. That is not an extension; it is a new theory. | Nothing about linearity. See Q1-addendum. |

**Addendum — what actually blocks Chen–Pouzo here, in order of severity.**

1. **The regularisation index is deterministic.** Assumptions 3.1(ii), 3.2, 3.3, 3.4, Lemmas 3.1–3.2 and the sieve variance (2.6)/(2.10) are all indexed by a deterministic sieve dimension $k(n)$. The paper's Landweber–Fridman **discrepancy stopping rule** makes the index a random stopping time correlated with the data. Nothing in Chen–Pouzo covers this. *This is the real constraint, it also kills Babii (whose Assumption 3.2(vi) fixes $\alpha_n\sim n^{-c_2}$), and it is the correct thing to say in print instead of "linearity".*
2. **$d_\rho$ is finite and the conditioning variable is the instrument.** $m(X,\alpha)$ is $d_\rho\times1$, $\Sigma(X)$ is $d_\rho\times d_\rho$. With $W$ binary and $d_\rho$ finite you get finitely many restrictions — not enough for an infinite-dimensional $\varphi$. The Bierens device produces a **continuum**, which is not literally (1.1). Recasting is a modelling choice with its own asymptotics.
3. **The evaluation functional's sieve Riesz representer must be bounded** in the metric induced by the linearisation at $\varphi_0$ — the very object whose source-condition ceiling $\beta\le1-\epsilon$ the author has already established for the binary case. Derivable, not importable.

**The single most valuable thing this review returns:** the author's stated reason for excluding Chen–Pouzo is wrong, and **the right reason is stronger**. "Chen–Pouzo assumes a linear operator" is refutable from their abstract and a methods referee would catch it. "Chen–Pouzo's inference theory is indexed by a deterministic sieve dimension and does not cover a data-driven stopping rule" is correct, sharp, and cannot be refuted by reading the abstract.

### Q2 — Is there ANY inference for the nonparametric component of a nonlinear ill-posed inverse problem?

**Yes — pointwise, in econometrics, since 2015.** Chen & Pouzo (2015) give sieve $t$/Wald intervals and SQLR sets (inverted with a generalized-residual multiplier bootstrap, no standard errors needed) for the **point-evaluation functional** $\phi(\alpha)=h(\bar y_2)$, valid whether or not the functional is $\sqrt n$-estimable. Their worked nonlinear example is NPQIV, (2.22)–(2.23), with an empirical illustration in their §7.2. **So "nothing exists" is not the correct plain statement and §6 should not make it.**

**No — uniformly, in either literature.** No uniform confidence band for the full function in a nonlinear operator equation surfaced anywhere. On the mathematics side, Monard, Nickl & Paternain (2021) is the state of the art and delivers a Bernstein–von Mises theorem for **smooth linear functionals only**, obtained by linearising the nonlinear forward map at $\theta_0$ and requiring $\mathbb I^*_{\theta_0}\mathbb I_{\theta_0}$ to be invertible on a large enough range. On the numerical-analysis side (`kalten2008`, `hanke1995`, `engl2000`, `bissantz2007`) the noise is deterministic or the output is rates; there are no coverage statements. Lepskii-type adaptive sets exist for the *linear* case (`CHEN_CHRISTENSEN_KANKANALA:2025`) and nowhere else.

**No — for anything, with a data-driven stopping rule in a nonlinear equation.** That cell is empty. The three nearest papers (`dunker2014`, `dunker2015`, `dunker2021`) — the same model class, the same iterative regularisation, one of them adaptive — all stop at rates.

**How to phrase it.** Not "nothing exists". Rather: *pointwise inference in nonlinearly ill-posed models exists (Chen & Pouzo 2015) but is indexed by a deterministic sieve dimension; uniform bands exist only for linear operators (Babii 2020; Chen, Christensen & Kankanala 2025); we are not aware of any procedure covering a nonlinear operator equation regularised by a data-driven stopping rule.* Hedged as "we are not aware of", because it is a negative claim.

### Q3 — What do comparable papers actually DO?

The convention is settled, and the decisive evidence is **the author's own companion paper**.

| Paper | What it does with the nonparametric component |
|---|---|
| **Centorrino, Fève & Florens (2025), JoE** — *same nonlinear equation, same binary instrument, same LF estimator* | **Reports a pointwise nonparametric bootstrap CI (99 replications) and disclaims it in one sentence**: "The confidence intervals for the nonparametric estimator are presented only to illustrate its variability but **should not be considered valid**." Conclusion names valid inference as future work. Accepted after three rounds at *Journal of Econometrics*. |
| Horowitz & Lee (2012), JoE | Constructs a band and states in the **introduction** that it "is not asymptotically exact if $L<\infty$; its true and nominal coverage probabilities are not necessarily equal even asymptotically." A dishonest band, published, with the limitation stated up front. |
| Babii (2020), ET | Honest bands — but only by restricting *both* the function class and the **operator class**, and by tuning $\alpha_n$ so the bias is dominated. That is undersmoothing, formalised. |
| Chen, Christensen & Kankanala (2025), REStud | Honest **and** adaptive; explicitly sells itself as beating undersmoothing. The only paper in the review that pays no honesty penalty — and it is linear-operator only. |
| Dunker (2014, 2015, 2021) | **Point estimates and rates. No band, no caveat, no discussion.** |
| Chen & Pouzo (2015), §7.2 | Genuine pointwise confidence sets in a nonlinear model (NPQIV) — the one paper that does it properly, at the cost of a deterministic sieve index. |

**The convention, stated plainly.** In this literature it is **normal and publishable** to display an invalid-but-informative pointwise band with an explicit one-sentence disclaimer. It is *not* normal to display a band silently. The four live options are: (i) point estimates only; (ii) pointwise bootstrap band + explicit disclaimer — **what CFF did**; (iii) a band that ignores regularisation bias and says so — what Horowitz & Lee did; (iv) undersmoothing — what Babii formalises and CCK improve on. Options (ii) and (iii) are the same move at different levels of formality.

### Q4 — The honest-band problem, and what honesty costs

**The mechanism.** In an ill-posed problem the regularisation bias does not vanish at the variance rate, so a naive plug-in band undercovers. Babii's own diagnosis, p. 4: "**the bias of the estimator, not the noise coming from the estimation of the operator, drives the coverage errors of our confidence sets.**"

**What has to be assumed.** Three things:
1. A **source condition with a known exponent** — Assumption 3.1's class is indexed by $\beta,t,M,C$, and Proposition 3.1's bias bound $R\alpha_n^{\beta\wedge1}$ **saturates at $\beta=1$**.
2. **Completeness** plus smoothness/kernel/moment conditions (Assumption 3.2(i)–(v)) and non-trivially interlocking tuning conditions (3.2(vi)).
3. **A restriction on the operator class, not just the function class.** Babii, p. 4: "the class of models should involve both the class of functions and the class of operators, **which is different from classical direct nonparametric problems where we need only to restrict the function**." This is the structural price of honesty in an inverse problem, and it is the sentence to quote if the point is ever argued in print.

**How wide the sets get.** Theorem 3.2: $\sup_{P}E_P|C_{n,1-\gamma}|_\infty=O(1/(\alpha_n\sqrt{nh^q_n}))$ and $|C^*_{n,1-\gamma}|_\infty=O_p(1/(\alpha_nh^q_nn^{1/2}))$. The sup-norm **variance** rate inflated by $1/\alpha_n$; the bands are **constant-width** and do **not** subtract an estimated bias — the bias is instead forced below the width by the tuning conditions. So honest bands here cost an explicit $1/\alpha_n$ inflation *and* a deliberately over-small $\alpha_n$.

**And the general reason it is hard.** Even in the *direct*, *linear*, well-posed problem, honest adaptive confidence sets are impossible without an extra signal-strength restriction — self-similarity or polished-tail (`szabovdvvz2015`; **abstract-only, no theorem asserted**). A fortiori here.

---

## 2. Suggested contribution statement (for the intro, not §6)

> We establish $\sqrt n$ asymptotic normality for the finite-dimensional parameter $\theta$. Inference on the nonparametric component $\varphi$ is left open, and deliberately so: the available technology does not reach this model. Honest uniform bands for ill-posed problems (Babii, 2020; Chen, Christensen and Kankanala, 2025) are constructed for a **linear** operator — Babii's source condition $\varphi=(T^*T)^\beta T^*\psi$ and the associated uniform bias bound are statements in the spectral calculus of $T^*T$, and his completeness requirement fails outright for a binary instrument. Pointwise inference *is* available for nonlinearly ill-posed conditional moment models (Chen and Pouzo, 2015), including for the evaluation functional, but that theory is indexed by a **deterministic** sieve dimension, whereas our regularisation index is the random stopping time of a discrepancy rule. The same boundary appears in the mathematical inverse-problems literature, where valid uncertainty quantification for nonlinear forward maps is currently available for smooth **linear functionals** only (Monard, Nickl and Paternain, 2021). We are not aware of any procedure delivering valid inference on the nonparametric component of a nonlinear ill-posed inverse problem regularised by a data-driven stopping rule.

**Differentiation.** Against `dunker2021` and `dunker2014`: same nonlinear model class, they give rates, we add $\sqrt n$ for the parametric part and a discrepancy-based stopping rule. Against `centorrinofeveflorens2019`: same equation, same instrument, that paper's conclusion names valid inference as future work; this one supplies it **for $\theta$**. Against `babiiflorens2025`: they relax completeness within a linear model; we replace the mean restriction with independence, which buys identification without completeness at the cost of nonlinearity.

---

## 3. Recommendation for §6 — one paragraph, as requested

**The author's working assumption is right, and the literature says so more emphatically than he assumed — but for a different reason, and §6 should give the right one.** Report $\hat\varphi$ as a point estimate with a numerical table (levels and, if the hedonic reading needs them, first differences or an implied marginal willingness-to-pay at a few TSP values), plus a pointwise bootstrap band drawn as a dotted line and disclaimed in a single sentence — **exactly what Centorrino, Fève and Florens (2025) did in *Journal of Econometrics* with this same estimator, this same binary instrument and this same nonlinear operator equation**, and what its referees accepted through three rounds. Do **not** claim the band is valid; do **not** attempt an honest band, because Babii's construction fails here twice over (Assumption 3.1's linear-operator source condition, Assumption 3.2(v)'s completeness) and CCK's Lepski bootstrap balances over a *linear sieve dimension*, not a Landweber stopping time. Do **not**, however, write that "no inference exists for nonlinear ill-posed problems": Chen & Pouzo (2015) give pointwise sieve-Wald and SQLR intervals for the evaluation functional in exactly such models and illustrate them on NPQIV Engel curves, so the honest sentence is that their theory is indexed by a **deterministic** sieve dimension while ours is a **random stopping time** — a sharper, unrefutable claim that also frames the companion paper. The economically substantive move is to lean on what the paper *can* defend: report the shape of $\hat\varphi$ (monotonicity, curvature, where it departs from the TSLS line) as descriptive evidence, put the $\sqrt n$-valid inference where it belongs — on $\theta$ — and close §6 by noting that valid inference on $\varphi$ under a data-driven stopping rule is open, citing Monard, Nickl and Paternain (2021) for the fact that the mathematical inverse-problems literature stops at the same boundary. **That last citation is the one worth adding**: it converts an apparent gap in the paper into a statement about where the frontier is, in a second literature, independently.

---

## 4. Open verification items

Two things this review could not close. Both are cheap and both matter.

1. **Confirm the CFF (2025) quotations against the published PDF.** They were read from the R3 revision typescript (`Centorrino_Feve_Florens_2024_3.tex`, October 2024). The article is *J. Econometrics* 247 (2025) 105950. R3 is almost certainly the accepted text, but the disclaimer sentence is going to be paraphrased in §6 and it should be checked. **The author has the published PDF.**
2. **Open Lob, Singh & Vijaykumar (2025), arXiv:2511.21603.** Abstract-only. "Allowing general nonlinearities" most likely means a nonlinear $h$ in a linear conditional-moment operator equation — in which case it is another linear-side paper. If it is genuinely a nonlinear operator, the frontier map changes and this sub-review should be re-run.

Lower priority: Babii's published *Econometric Theory* 36(4) numbering was not checked against the arXiv v4 numbering used throughout; and Chen & Pouzo locators are all from the arXiv typescript, not *Econometrica* 83(3). **No published-version locator is asserted anywhere in this sub-review**, so nothing is currently wrong — but if any of these numbers goes into `main.qmd`, re-pin it against the published article first.
