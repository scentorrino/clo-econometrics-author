# Theorist-Critic Report — Proposition `prp-lepskii` (Lepskii Oracle Inequality)

**Target file:** `/Users/samuele/Library/CloudStorage/Dropbox/Nonparametric_IV/Volatility/Centorrino_Florens_VOL_1.qmd`
**Scope:** prp-lepskii (statement 611–624, proof 1184–1215), with dependencies lem-itervar (588–594; proof 1137–1182) and prp-koper (519–530; proof 1052–1085).
**Severity:** HIGH (Execution-phase audit-in-place).
**Mode:** AUDIT-IN-PLACE — no theorist drafting; this report scores the existing proof.

---

## Phase 1 — Claim Identification

The proposition makes four claims:

1. **Existence of an absolute constant $\tau_0 = \tau_0(c_v, c'_v) > 1$** such that for every $\tau \ge \tau_0$ the data-driven index $\hat m$ from `def-lepskii` satisfies an oracle inequality.
2. **Oracle inequality in derivative coordinates:** $(E\Vert\hat b'_{\hat m} - b'_\dagger\Vert^2)^{1/2} \le C(\tau)\inf_{m\le M_n}[B(m) + V(m)]$ with $B, V$ as in eq-Bbias and lem-itervar (line 615).
3. **Transfer to integrated coordinates:** the same inequality holds for $\hat b_{\hat m} = D^{-1}\hat b'_{\hat m}$ with the "matched Hilbert scale" rates — explicitly an additional factor $\delta_n^{1/(a+1)}$ (lines 616–617).
4. **Transfer to native $(\varphi, \sigma)$:** composition with $\Phi$ from `sec-mapback` yields an oracle inequality for $\hat a_{\hat m}$ with constant $C(\tau)\cdot C_\Phi$.

The statement on line 620–624 then asserts (informally — outside the proposition body) that composition with cor-rates yields the *rate* $\delta_n^{(\beta_\epsilon(a+1)+1)/((\beta_\epsilon+1)(a+1))}$, "without requiring knowledge of $\beta$."

**Ambiguous quantifiers identified:**

- [MINOR, line 613–615] **"$C(\tau)$ a finite constant"** — the formula $C(\tau) = (5\tau + 1) + O(\tau^{-1})$ in line 1209 suggests $C(\tau)$ does not include the $\sqrt{\log M_n}$ that the proof itself flags as the source of the adaptation overhead (line 1194). The narrative at line 620–626 says the constant *does* scale with $\tau\log(M_n/m^*)$. Two different "constants" are circulating: one inside the proof (Steps 1–2) and one in the discussion. The proposition statement does not match what the proof actually delivers if the log factor is genuine.
- [MINOR, line 617] **"the right-hand side gains a factor $\delta_n^{1/(a+1)}$"** — gains a factor of $\delta_n^{1/(a+1)}$ relative to *what*? Relative to $\inf_m[B(m)+V(m)]$? Relative to the calibrated rate of cor-rates? The natural reading (relative to the inf) is dimensionally suspect since $B,V$ are already in derivative norms; the factor truly comes from substituting cor-rates calibration in the matched Hilbert scale.

Total Phase 1 deductions: **-4**.

---

## Phase 2 — Proof Validity

### 2.1 The Markov / sub-exponential step (line 1190–1194)

This is the most consequential weakness in the proof.

[CRITICAL, line 1194] The proof first claims $P(\Omega_n) \ge 1 - CM_n/\tau^2$ from "Markov applied to lem-itervar at each $m$ and a union bound." That is the *only* concentration result that lem-itervar actually supports: lem-itervar bounds $E\Vert\hat b'_m - b'_m\Vert^2$, and Markov gives $\Pr(\Vert\hat b'_m - b'_m\Vert > \tau V(m)) \le 1/\tau^2$. With a union bound over $m\le M_n$, the bound is $M_n/\tau^2$, which requires $\tau \gg \sqrt{M_n}$ to be non-trivial.

The proof then asserts: "under the sub-exponential concentration of the kernel residuals implied by Assumption \ref{ass:app4} ... gives $\Pr(\Vert\hat b'_m - b'_m\Vert > \tau V(m)) \le \exp(-c_0\tau^2)$ at each $m$."

This is unsupported. Assumption \ref{ass:app4} (line 929–931) states only that $\kappa_n = \inf_{|u|\le \ell_n} f_U(u) > 0$ with $\kappa_n\to 0$. This is a *lower-tail* condition on $f_U$, not a sub-exponential or sub-Gaussian tail condition on any kernel residual, and certainly not a concentration inequality for the random object $\hat b'_m - b'_m$.

To get $\Pr(\Vert\hat b'_m - b'_m\Vert > \tau V(m)) \le \exp(-c_0\tau^2)$ one would need either:
(a) a Bernstein- or Talagrand-type inequality applied to $II_m$, the leading variance term (which is a sum of i.i.d. operator perturbations and could plausibly be sub-Gaussian under bounded kernels), AND
(b) propagation of the concentration through $III_m, IV_m$ — which involve $\hat e_j^2$ and $\hat e_j$ multiplied by adjoint deviations and density-correction factors $h_u^{-2}\kappa_n^{-1}$.

The proof asserts the sub-exponential bound without showing either ingredient. The logarithmic adaptation overhead announced at line 624 ($\tau \asymp \sqrt{\log M_n}$, giving the $\log\log n$ overhead in the severely ill-posed case) rests entirely on this step. With only Markov, the overhead is $\sqrt{M_n}$ — useless.

This is a **structural gap**, not a typo. Either (i) the paper needs an explicit lemma showing sub-Gaussian / sub-exponential tails for the per-iterate variance — likely citing Bauer–Hohage 2005, Werner 2015, or a Bernstein inequality for kernel-density-based U-statistics — or (ii) the proof must accept the Markov rate and re-state $\tau_0$ as growing polynomially in $M_n$, sacrificing the $\log\log n$ overhead claim.

[CRITICAL, line 1209] **Off-event contribution.** "Off $\Omega_n$ the iterates are bounded a priori by Assumption \ref{ass:restrvarth}, contributing $O(\tau^{-2})$ to the squared expectation." Assumption \ref{ass:restrvarth} (line 508–513) governs *tuning parameters* — $\delta_n N$, $\gamma_n N^{(\epsilon+1)/2}$, and $h_u^2\kappa_n$ — not a uniform a-priori bound on the random iterates $\hat b'_m$. To bound $E[\Vert\hat b'_{\hat m} - b'_\dagger\Vert^2 \mathbf{1}_{\Omega_n^c}]$ one needs either a uniform-in-$\omega$ bound on $\Vert\hat b'_m\Vert$ (which is not in the assumption block and would be implausible without truncation), or a higher moment bound combined with $P(\Omega_n^c) \le 1/\tau^2$. The latter would give $E[\Vert\hat b'_{\hat m}-b'_\dagger\Vert^2\mathbf{1}_{\Omega_n^c}] \le (E\Vert\hat b'_{\hat m}-b'_\dagger\Vert^4)^{1/2}/\tau^2 = O(\tau^{-2})\cdot(\text{4th moment of iterates})$, but the 4th moment uniformly in $m\le M_n$ is not established. The "$O(\tau^{-2})$" is asserted, not derived.

Combined deduction: **-30** (two critical gaps, $2\times -15$).

### 2.2 Monotonicity of $V(m)$ (lem-itervar, Step 1 of prp-lepskii)

[MAJOR, line 1200] The proof states "$V(m^*) \le V(k)$ by monotonicity of $V$." Looking at the formula $V(m) = c_v \delta_n \sqrt m + c'_v \gamma_n m^{(1-\beta)/2}\ln(m)^{\mathbf{1}(\beta=2)} m^{(\beta/2-1)\vee 0}$ on line 592:

- For $\beta \le 1$, the second term scales as $m^{(1-\beta)/2}$, which is **non-decreasing** in $m$ — fine.
- For $1 < \beta \le 2$, the exponent of $m$ in the second term is $(1-\beta)/2 + (\beta/2-1)\vee 0 = (1-\beta)/2 \in (-1/2, 0)$ — i.e., the second term is **decreasing** in $m$.

For $\beta > 1$, $V(m)$ is monotone-increasing only if the first term $c_v\delta_n\sqrt m$ dominates the second uniformly in $m\le M_n$. The condition $\eqref{eq-gammadelta}$ (line 551) gives exactly this domination *asymptotically*; but to guarantee monotonicity *as a function of $m$* and hence the existence of a unique balancing index $m^*$ (line 1188), the proof should explicitly invoke \eqref{eq-gammadelta}. As written, the line "existence follows from $B$ being monotone decreasing and $V$ monotone increasing in $m$, so $m^*$ is the unique balancing index" (line 1188) and the subsequent step assume monotonicity without justification.

This is a real gap, fixable by a one-sentence reference to \eqref{eq-gammadelta}, but the proof as it stands does not establish what it claims for $\beta > 1$.

Deduction: **-15**.

### 2.3 Step 3, transfer to integrated coordinates (line 1215)

[MAJOR, line 1215] "the additional $\delta_n^{1/(a+1)}$ factor through the source-bias balance of @cor-rates." This is asserted in a single phrase. The link condition (Assumption \ref{ass:linkcond}, line 467–469) gives a norm equivalence between $(\mathsf{T}'^*_{b_\dagger}\mathsf{T}'_{b_\dagger})^{1/(2a)}$ and $D^{-1}$ — so $\Vert D^{-1}\Vert$ in the matched Hilbert scale corresponds to the operator's $-1/(a+1)$-power smoothing. The mechanical step from "oracle inequality at the inf level" to "matched-scale bound with $\delta_n^{1/(a+1)}$" requires either:
(a) applying the oracle inequality at the calibrated $m^* \asymp \delta_n^{-2/(\beta_\epsilon+1)}$ from cor-rates and then computing $\Vert D^{-1}\Vert$ on the leading variance term, or
(b) running the Mathé–Pereverzev argument directly in the matched Hilbert scale with a re-defined $V$ and $B$.

The proof does neither — it points at cor-rates without writing the substitution. For an audit-in-place reviewer this is borderline between MAJOR and uncited regularity step. Scored as the latter.

Deduction: **-8** (uncited regularity / derivation step).

### 2.4 Step 1, the algebraic chain (line 1198–1200)

[MINOR, line 1198] The chain $\Vert\hat b'_k - \hat b'_{m^*}\Vert \le \tau V(k) + B(k) + B(m^*) + \tau V(m^*)$ uses on $\Omega_n$ both $\Vert\hat b'_k - b'_k\Vert\le \tau V(k)$ and $\Vert\hat b'_{m^*} - b'_{m^*}\Vert\le\tau V(m^*)$, then triangulates through $b'_k$, $b'_\dagger$, $b'_{m^*}$. The conclusion $\le (2\tau+2)V(k) \le 4\tau V(k)$ requires $\tau\ge\tau_0$ for some $\tau_0>1$ to make $2\tau+2\le 4\tau$, i.e. $\tau\ge 1$. The phrase "$\tau_0 = \tau_0(c_v, c'_v)$" is misleading — the algebraic step requires only $\tau\ge 1$, and $c_v, c'_v$ enter only through $V$. The constants in the statement should be made explicit.

Deduction: **-2** (loose phrasing).

### 2.5 Step 2 (line 1202–1208)

Clean. The chain $\Vert\hat b'_{\hat m} - b'_\dagger\Vert \le 4\tau V(m^*) + \tau V(m^*) + B(m^*) \le (5\tau+1)[B(m^*)+V(m^*)]$ uses $\hat m\le m^*$ from Step 1 and the Lepskii defining condition at $\hat m$ with $k = m^*$. No issue.

---

## Phase 3 — Assumption Minimality and Notation Consistency

[MAJOR, line 1194] Assumption \ref{ass:app4} is invoked beyond what it states (see 2.1 above). Either drop the citation and acknowledge that sub-exponential concentration is *assumed*, or add a separate concentration assumption. (Already counted under 2.1.)

[MINOR, line 613] The proposition cites "Assumptions \ref{ass:identif}-\ref{ass:restrvarth} and \ref{ass:app1}-\ref{ass:app6} ... the source condition (iv) of @prp-onetoone, and the link condition \ref{ass:linkcond}." But \ref{ass:linkcond} is already part of the \ref{ass:identif}-\ref{ass:restrvarth} block. The link condition is cited twice; the source condition "(iv) of @prp-onetoone" is presumably ass:sourcecond but the cross-reference is non-standard. Minor citation duplication.

[MINOR, line 590] Lemma lem-itervar declares constants $c_v, c'_v$ "depending only on the LF step size $c$, on $R^\sigma$, $M_1$-$M_3$, $M_4$, and on the qualification of the LF iteration." Yet at the end of the lem-itervar proof (line 1180), the dependence list is "on $c, R^\sigma, M_1$-$M_3, m_4$ and on the qualification of LF" — note **lowercase $m_4$** instead of $M_4$ used in the lemma statement. (INV-7 violation.)

[MINOR, line 1147 / line 596] "$\hat{\mathsf{T}}'^*_{b_\dagger}\hat{\mathsf{T}}'_{b_\dagger}$ is the *empirical* derivative at $b_\dagger$ -- a fixed operator across iterations." The spectral filter inequality "$\sup_\lambda|g_m(\lambda)|^2 \le c\,m$" appears with constant $c$ — but the same $c$ is the LF step-size used throughout. Notation collision per INV-7.

Net Phase 3: **-6** (notation only).

---

## Phase 4 — Citation Fidelity, Linkage, and Polish

[MAJOR, line 624 and Remark `rem:linear-reduction`] **@cavalierhengartner2005 cited for the "linear reduction" remark.** Cavalier–Hengartner (2005) treats *block-thresholding* in inverse problems with white Gaussian noise; their Theorem 1 establishes an oracle inequality for the block-thresholded SVD estimator, *with deterministic operator $T$*. The remark's claim that "Proposition \ref{prp-lepskii}'s oracle inequality becomes precisely the adaptive oracle inequality of \citet[Theorem 1]{cavalierhengartner2005}" is overstated:
- Cavalier–Hengartner use block thresholding, not Lepskii balancing — different adaptation mechanism.
- Their setup has known $T$; the alleged correspondence "$(\delta_n,\gamma_n)$ ↔ data noise on $\hat r$ and operator noise on $\hat T$" only matches @hoffmannreiss2008.

The right citation for the Lepskii-on-derived-Hilbert-scale-with-noisy-operator benchmark is @hoffmannreiss2008 (cited) and @mathe2003 (cited). Cavalier–Hengartner 2005 should be cited only as the *block-thresholding* analog — or dropped from this specific claim.

Deduction: **-3** (citation fidelity).

---

## Cross-cutting

- INV-7 (notation consistency, paper): mild violation via the $c$ collision and the $m_4$/$M_4$ slip.
- The proof is well-organized in three steps and the Mathé–Pereverzev skeleton is correct in shape; the failures are in the *quantitative* substantiation of three discrete claims (sub-exponential concentration, $V$ monotonicity, off-event control), not in the overall architecture.

---

## Scoring Tally

| Finding | Severity | Deduction |
|---|---|---|
| 2.1 Sub-exponential tail from ass:app4 not justified | CRITICAL | -15 |
| 2.1 Off-$\Omega_n$ bound via ass:restrvarth not derived | CRITICAL | -15 |
| 2.2 $V$ monotonicity conditional on eq-gammadelta, unstated | MAJOR | -15 |
| 2.3 Transfer $\delta_n^{1/(a+1)}$ uncited derivation step | uncited regularity | -8 |
| 2.4 $\tau_0$ dependence overstated | MINOR | -2 |
| 1.x ambiguous quantifiers ($C(\tau)$, $\delta_n^{1/(a+1)}$ scope) | MINOR | -4 |
| 3.x $m_4$/$M_4$, $c$ collision, citation duplication | MINOR | -6 |
| 4.x Cavalier–Hengartner mis-cited for the reduction remark | MAJOR | -3 |

**Cumulative: -68. Score = 32 / 100.**

**Verdict:** The Lepskii oracle inequality is plausible and the Mathé–Pereverzev scaffolding is correctly identified, but the proof as written has two critical gaps (unsupported sub-exponential concentration claim citing ass:app4, and an undefended off-event contribution) plus a proof step that requires \eqref{eq-gammadelta} to make sense for $\beta>1$. The logarithmic adaptation overhead announced in the statement is not delivered by the proof. **Not ready for the binary theory submission gate.**
