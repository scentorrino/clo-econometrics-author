# Regularity Audit — Proposition `prp-lepskii` (Lepskii oracle inequality)

**File:** `/Users/samuele/Library/CloudStorage/Dropbox/Nonparametric_IV/Volatility/Centorrino_Florens_VOL_1.qmd`
**Scope:** Statement L611–624, proof L1184–1215; Lemma `lem-itervar` (statement L588–594, proof L1137–1182); Proposition `prp-koper` (proof L1052–1085); supporting assumptions L426–945.
**Mode:** AUDIT-IN-PLACE.

---

## 1. Spectral filter on a random operator with shifting linearization point — L1139–1147

**Verdict: FLAG (MAJOR).** The proof rewrites the empirical recursion $\hat b'_{m+1} = \hat b'_m - c \hat{\mathsf A}^*_{\hat b_m} \hat{\mathsf T}(\hat b_m)$ as a closed-form four-term expansion *with the contraction operator equal to* $\hat{\mathsf T}'^*_{b_\dagger}\hat{\mathsf T}'_{b_\dagger}$ — a fixed operator across $j$. The text at L1147 claims this substitution is justified because "the deviations $\hat{\mathsf T}'^*_{\hat b_j} - \hat{\mathsf T}'^*_{b_\dagger}$ are gathered into $IV_m$ and bounded via Prop. `prp-koper`(b)."

But the actual recursion uses both $\hat{\mathsf A}^*_{\hat b_m}$ and $\hat{\mathsf T}(\hat b_m)$; rewriting it with a fixed $(I - c \hat{\mathsf T}'^*_{b_\dagger}\hat{\mathsf T}'_{b_\dagger})^{m-1-j}$ propagator requires that the *propagator itself* (not just the adjoint factor isolated in $IV_m$) be replaced — and the substitution $\hat{\mathsf A}^*_{\hat b_j}\hat{\mathsf T}'_{\hat b_j} \leadsto \hat{\mathsf T}'^*_{b_\dagger}\hat{\mathsf T}'_{b_\dagger}$ generically produces a cross-term of the form $(\hat{\mathsf T}'^*_{\hat b_j}\hat{\mathsf T}'_{\hat b_j} - \hat{\mathsf T}'^*_{b_\dagger}\hat{\mathsf T}'_{b_\dagger}) \hat e_j$ in *every* iterate, not just at the leading order. The four-term decomposition only collects the leading $(\hat{\mathsf T}'^*_{\hat b_j} - \hat{\mathsf T}'^*_{b_\dagger})$ deviation in $IV_m$; the corresponding *propagator* substitution is asserted but not justified algebraically.

**Standard remedy.** Either (a) state explicitly an auxiliary lemma that telescopes the propagator $(I - c\hat{\mathsf T}'^*_{\hat b_j}\hat{\mathsf T}'_{\hat b_j})$ into $(I - c\hat{\mathsf T}'^*_{b_\dagger}\hat{\mathsf T}'_{b_\dagger})$ plus a deviation term that is shown to be of lower order under `ass:restrvarth`; or (b) bound the actual iterated random propagator $\prod_{k=j+1}^{m-1}(I - c\hat{\mathsf T}'^*_{\hat b_k}\hat{\mathsf T}'_{\hat b_k})$ uniformly by $\sup_\lambda |(1-c\lambda)|^{m-1-j}$ via a Cordes-style or holomorphic-calculus inequality. Currently, the leakage is silent.

---

## 2. Step-size restriction $c\|\hat{\mathsf T}'_{b_\dagger}\|^2 \le 1$ for the *empirical* operator — L1157–1158, L1182

**Verdict: FLAG (MAJOR).** The spectral filter inequality $\sup_\lambda |\lambda^{1/2} g_m(\lambda)| \le \sqrt m$ (Engl–Hanke–Neubauer eq. 6.5) holds on $[0, 1/c]$. The proof of `prp-convlf` at L401–405 gives a deterministic bound $\|\mathsf{T}'^*_b \mathsf{T}'_b\| \le c_1 (R^\sigma)^2 M_1^2(M_3^2 + 1)$ for the *population* operator. The application at L1157 is to the *empirical* operator $\hat{\mathsf T}'^*_{b_\dagger}\hat{\mathsf T}'_{b_\dagger}$, whose spectrum lives in $[0, \|\hat{\mathsf T}'_{b_\dagger}\|^2]$ — a *random* set.

Nowhere is it shown that $c\|\hat{\mathsf T}'_{b_\dagger}\|^2 \le 1$ holds uniformly in $n$, almost surely or on $\Omega_n$. The convergence rate $\gamma_n$ on $\hat{\mathsf A}^*_{b_\dagger}$ (Assumption `ass:rateconv`) only bounds the operator-norm distance between $\hat{\mathsf A}^*$ and $\mathsf A^*$, which delivers $\|\hat{\mathsf T}'_{b_\dagger}\| \le \|\mathsf T'_{b_\dagger}\| + O_P(\gamma_n)$, but the step size $c$ is fixed at the population level. For $\gamma_n \to 0$ this *eventually* gives the bound on a high-probability event, but the event has to be conditioned on, and the conditioning has to be propagated through every later use of the spectral inequality.

**Standard remedy.** Add a sentence: "On the event $\Omega'_n := \{\|\hat{\mathsf T}'_{b_\dagger}\|^2 \le 2\|\mathsf T'_{b_\dagger}\|^2 \le 2/c\}$, which has probability $1 - O(\gamma_n^2)$ by Markov and Assumption `ass:rateconv`, the spectral inequality applies." Then intersect with $\Omega_n$ throughout. Currently silent.

---

## 3. Sub-exponential concentration of kernel residuals — L1194

**Verdict: CRITICAL.** The proof writes: "under the sub-exponential concentration of the kernel residuals implied by Assumption `ass:app4` — which gives $\Pr(\|\hat b'_m - b'_m\| > \tau V(m)) \le \exp(-c_0 \tau^2)$ at each $m$." Assumption `ass:app4` (L929–931) states only that $\kappa_n = \inf_{|u| \le \ell_n} f_U(u) > 0$. This is a *density lower-bound at the origin*, not a concentration inequality. It implies nothing whatsoever about Gaussian/sub-Gaussian/sub-exponential tails of the kernel-based estimator $\hat b'_m - b'_m$.

A sub-exponential (Bernstein-type) concentration $\Pr(\|\hat b'_m - b'_m\| > \tau V(m)) \le \exp(-c_0 \tau^2)$ for an $L^2$-norm of a kernel-density-based estimator of a derivative pair typically requires (a) bounded kernel (have it, `ass:app3a`), (b) compactly supported $X$ (have it, L343), and (c) sub-Gaussian or bounded $Y \mid X, W$ — *not in the assumption block*. With only `ass:unifbd`(iv) $E[U^4] \le m_4 < \infty$, a Markov-type tail $\Pr(\cdot > \tau V(m)) \le C/\tau^2$ is all one gets, and the union bound at L1194 reads $P(\Omega_n) \ge 1 - CM_n/\tau^2$ — which is *exactly what the proof writes first*. Then the proof silently upgrades this to $\exp(-c_0\tau^2)$ citing `ass:app4`, which it does not.

**Standard remedy.** Add an assumption: either (i) $Y \mid X, W$ is sub-Gaussian, (ii) $U$ is sub-Gaussian with $\sigma_\dagger$ uniformly bounded, or (iii) replace the Mathé–Pereverzev choice $\tau \asymp \sqrt{\log M_n}$ by a polynomial choice $\tau \asymp M_n^{c'}$ that survives the Markov tail. Without one of these, the $O(\sqrt{\log M_n})$ adaptation overhead and the high-probability $P(\Omega_n) \ge 1 - n^{-c}$ are both unproved. **Load-bearing.**

---

## 4. Consistency of $\log M_n$ overhead vs. $\log\log n$ claim — L622–624, L1194

**Verdict: FLAG (MAJOR).** The discussion at L622–624 states: "in the severely ill-posed regime ($t_j \asymp e^{-sj}$ Hermite, e.g. binary $W$ under FI), $m^* = O(\log n)$ and the adaptation overhead is $O(\log\log n)$." The proof at L1194 derives an overhead $\tau \asymp \sqrt{\log M_n}$.

`def-lepskii` does not pin down $M_n$. If $M_n \asymp \log n$ in the severely ill-posed regime, $\sqrt{\log M_n} = \sqrt{\log\log n}$, *not* $\log\log n$. If instead $M_n$ is polynomial in $n$, $\sqrt{\log M_n} = O(\sqrt{\log n})$.

Either claim could be defended, but the paper currently states $O(\log\log n)$ in the discussion text (L624) and $\sqrt{\log M_n}$ in the proof (L1194). These are not reconciled. The square root must not be dropped.

---

## 5. Off-$\Omega_n$ a-priori bound on iterates — L1209

**Verdict: CRITICAL.** L1209: "Off $\Omega_n$, the iterates are bounded a priori by Assumption `ass:restrvarth`, contributing $O(\tau^{-2})$ to the squared expectation." This is the silent step that closes $E\|\hat b'_{\hat m} - b'_\dagger\|^2 \le P(\Omega_n) \cdot (\text{on-event bound}) + P(\Omega_n^c) \cdot (\text{off-event bound})$.

`ass:restrvarth` is a *tuning condition*, not a uniform bound on $\|\hat b'_m - b'_\dagger\|$. The natural a-priori bound would come from $\mathcal{B}_{b_\dagger} = \mathcal{B}_R \cap \mathcal{B}^*_M$ (L286), but this controls $b_j$ (the integrated parameter), *not* $b'_j = D b_j$. The operator $D$ is unbounded on $L^2_X$. So a bound $\|\hat b_j - b_\dagger\| \le R$ does *not* imply $\|\hat b'_j - b'_\dagger\| \le R'$.

**Standard remedy.** Either (a) impose explicit projection of each iterate onto a bounded set of derivative pairs; or (b) impose a moment bound $\sup_m E\|\hat b'_m\|^4 < C$, which would deliver the off-event contribution by Cauchy-Schwarz.

---

## 6. Monotonicity of $V(m)$ — L1188, L1200

**Verdict: FLAG (MAJOR).** $V(m) = c_v\,\delta_n\sqrt m + c'_v\,\gamma_n\,m^{(1-\beta)/2}\,\ln(m)^{\mathbf 1(\beta=2)}\,m^{(\beta/2-1)\vee 0}$. For $\beta \in (1, 2)$ the second term's exponent of $m$ is $(1-\beta)/2 + 0 < 0$, i.e., *decreasing*. The sum is monotone increasing only under the rate-balance condition `eq-gammadelta`. This dependence is invoked in the rate corollary but not stated as a prerequisite for the oracle inequality. The Lepskii proof asserts monotonicity unconditionally.

**Standard remedy.** Add to the hypotheses of `prp-lepskii`: "Assume $V$ is monotone non-decreasing in $m \le M_n$." Alternatively, replace $V(m)$ by $\tilde V(m) := \max_{1 \le k \le m} V(k)$.

---

## 7. Bias monotonicity — L584

**Verdict: CAPTURED.** $B(m) = m^{-\beta_\epsilon/2}[1 + \cdots]$ is strictly decreasing iff $\beta_\epsilon > 0$, which holds under `ass:sourcecond` and `ass:restrvarth`. Confirmed.

---

## 8. $E$ vs. $\sup_m$ interchange; uniform-in-$m$ wording in `lem-itervar` — L592, L1180

**Verdict: FLAG (MINOR–MAJOR).** The proof of `lem-itervar` bounds $E\|II_m\|^2$, $E\|IV_m\|^2$, $E\|III_m\|^2$ pointwise in $m$. There is no maximal inequality. The "uniformly in $m$" at L1180 means only "for each $m$, with the same constants" — i.e., pointwise in $m$, uniform in constants. The Lepskii proof then requires the union bound to do the lifting from pointwise to uniform, which is exactly what concern #3 (sub-exponential vs. Markov) refers to.

**Standard remedy.** Reword to "for each $m \le M_n$, with constants $(c_v, c'_v)$ not depending on $m$." Or supply a maximal inequality.

---

## 9. Lipschitz of $\Phi$ requires $\|\varphi_\dagger\|_\infty$ — L568, L1215

**Verdict: FLAG (MINOR).** $\Phi'(b_\dagger) = \begin{pmatrix}-\sigma_\dagger & -\varphi_\dagger \\ 0 & -\sigma_\dagger\end{pmatrix}$. `ass:unifbd`(iii) bounds $\sigma_\dagger$ only; not $\varphi_\dagger$. $L^2_X$ membership does not imply $L^\infty$ boundedness.

**Standard remedy.** Strengthen `ass:unifbd`(iii) to "$|\varphi_\dagger(x)| \le R^\varphi < \infty$," or add a Sobolev-embedding remark under the source condition with $\beta > p/2$.

---

## 10. Bounded second derivative of $\Phi$ — L570, L1215

**Verdict: FLAG (MAJOR).** L570: $\|\hat a_N - a_\dagger\| \le C_\Phi \|\hat b_N - b_\dagger\| + o(\|\hat b_N - b_\dagger\|)$. The $o(\cdot)$ remainder requires $\Phi$ twice differentiable with bounded second derivative on $\mathcal{B}_{b_\dagger}$. Requires $\omega$ uniformly bounded on $\mathcal{B}_{b_\dagger}$, which is an $L^\infty$ neighborhood, not the $L^2$ ball $\mathcal{B}_{b_\dagger}$ as defined at L286.

**Standard remedy.** State $C^2$-boundedness via Sobolev embedding under `ass:sourcecond` with $\beta > p/2$, or strengthen the definition of $\mathcal{B}_{b_\dagger}$ to an $L^\infty$ neighborhood.

---

## Additional items

**(A) `prp-koper`(a) constant $\hat M$ random — L1062–1073.** $\hat M = M_2 M_3 + M_n M_X$ depends on the random uniform-consistency constant $M_n$ from `dunker2018`. The line "almost surely" at L521 elides this. **FLAG (MINOR).**

**(B) `lem-itervar` MI case at L1182 silently sets $\beta_\epsilon = \beta$.** Should be made explicit that the *bias* $B(m)$ uses $\beta_\epsilon = \beta$ in the MI case. **FLAG (MINOR).**

**(C) `lem-itervar`, Term $III_m$ at L1168.** Implicitly uses $E\|\hat e_j\|^4 = O(\cdot)$ in the induction, and `thm-mainconv` writes 8th-moment products. `ass:rateconv` only gives $L^2$ rates on the operator approximation. The induction needs $L^4$/$L^8$ moment control beyond `ass:rateconv`'s $L^2$ rate. **FLAG (MAJOR).** Strengthen `ass:rateconv` to $L^p$ for some $p \ge 4$, or supply hypercontractive bound.

---

## Summary table

| # | Concern | L# in `.qmd` | Verdict | Type of patch |
|---|---|---|---|---|
| 1 | Spectral filter on random operator with shifting linearization point | 1139–1147 | FLAG (MAJOR) | New auxiliary lemma (propagator substitution) |
| 2 | Step-size $c\|\hat{\mathsf T}'_{b_\dagger}\|^2 \le 1$ for empirical operator | 1157–1158, 1182 | FLAG (MAJOR) | High-probability event, strengthen existing assumption block |
| 3 | Sub-exponential concentration of kernel residuals | 1194 | **CRITICAL** | New assumption (sub-Gaussian $Y \mid X, W$ or $U$) |
| 4 | $\sqrt{\log M_n}$ vs. $\log\log n$ overhead | 622–624, 1194 | FLAG (MAJOR) | Define $M_n$ explicitly; fix the square-root |
| 5 | Off-$\Omega_n$ a-priori bound on iterates | 1209 | **CRITICAL** | New assumption (projection, or $L^4$ moment bound on iterates) |
| 6 | Monotonicity of $V(m)$ | 588, 1188, 1200 | FLAG (MAJOR) | Add monotonicity hypothesis or replace $V$ by running max |
| 7 | Bias monotonicity ($\beta_\epsilon > 0$) | 584 | CAPTURED | — |
| 8 | $E$ vs. $\sup_m$; "uniform in $m$" wording | 592, 1180 | FLAG (MINOR) | Reword; or supply maximal inequality |
| 9 | $\|\varphi_\dagger\|_\infty$ for Lipschitz of $\Phi$ | 568, 1215 | FLAG (MINOR) | Strengthen `ass:unifbd`(iii) |
| 10 | Bounded second derivative of $\Phi$ | 570, 1215 | FLAG (MAJOR) | Sobolev embedding, or $L^\infty$ neighborhood |
| A | $\hat M$ random in `prp-koper`(a) | 1071 | FLAG (MINOR) | Replace "a.s." with high-probability event |
| B | MI $\beta_\epsilon = \beta$ shorthand | 1182 | FLAG (MINOR) | Clarify $B(m)$ vs. $V(m)$ |
| C | $L^8$ moment use vs. $L^2$ statement in `ass:rateconv` | 1111, 1120, 1168 | FLAG (MAJOR) | Strengthen `ass:rateconv` to $L^p$ |

**Silent gaps (require new content):** #1, #3, #5, #10, C.
**Strengthen existing assumption (no new structure):** #2, #4, #6, #8, #9, A, B.
**Captured:** #7.

**Two CRITICAL gates** (#3, #5) block the proof as written.
