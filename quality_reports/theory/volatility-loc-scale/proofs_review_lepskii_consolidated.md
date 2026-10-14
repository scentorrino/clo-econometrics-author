# Consolidated `/prove` Report — `prp-lepskii`

**Mode:** AUDIT-IN-PLACE (no theorist drafting step). The proof of `prp-lepskii` already exists in the paper; this report is a consolidated read of three parallel critics.
**Target:** `/Users/samuele/Library/CloudStorage/Dropbox/Nonparametric_IV/Volatility/Centorrino_Florens_VOL_1.qmd`, statement L611–624, proof L1184–1215, dependencies `lem-itervar` (L588–594, 1137–1182) and `prp-koper` (L519–530, 1052–1085).
**Date:** 2026-05-15.

## Verdict at a glance

| Axis | Verdict |
|---|---|
| theorist-critic score | **32 / 100** (below 80 gate) |
| regularity-checker | 2 CRITICAL, 6 MAJOR, 5 MINOR, 1 CAPTURED |
| counterexample-hunter | 0 CONFIRMED counterexamples, 5 medium FLAGs, 1 minor FLAG, 4 CAPTURED |
| Binary submission gate (quality.md §3) | **BLOCKED** — theorist-critic score < 80 and unresolved critical findings on the proof |

## What converges across all three critics

The three reports independently identify the **same two load-bearing gaps**:

1. **Sub-exponential concentration at L1194 is unsupported.** The proof asserts that Assumption `ass:app4` (a lower-bound on $f_U$) "implies" sub-exponential tails for the kernel residuals $\hat b'_m - b'_m$. It does not. Without sub-exponential / sub-Gaussian tails, the union bound $P(\Omega_n) \ge 1 - M_n e^{-c_0\tau^2}$ degrades to a Markov bound $1 - C M_n/\tau^2$, and the $O(\sqrt{\log\log n})$ adaptation overhead announced in the discussion (L624) is unproved. The Lepskii oracle inequality itself does not fail, but the *high-probability event* on which it is delivered shrinks.
2. **Off-$\Omega_n$ bookkeeping at L1209 is loose.** The proof attributes the $O(\tau^{-2})$ off-event contribution to Assumption `ass:restrvarth`. `ass:restrvarth` is a tuning condition; it does not deliver a uniform a-priori bound on $\hat b'_m - b'_\dagger$, particularly because $b'_m = D b_m$ lives in the unbounded direction of $D$, not in the bounded $L^2$ ball $\mathcal{B}_{b_\dagger}$ that the identification framework controls.

Both are fixable; neither is fatal. Standard remedies (a sub-Gaussian assumption on $Y \mid X, W$ or $U$; an explicit truncation / projection of iterates) restore the proof.

## What only the regularity-checker / counterexample-hunter saw

- **Propagator substitution at L1139–1147 is silent** (regularity-checker #1). The proof rewrites the iteration with a fixed contraction operator $\hat{\mathsf T}'^*_{b_\dagger}\hat{\mathsf T}'_{b_\dagger}$ but only gathers the *leading* deviation $(\hat{\mathsf T}'^*_{\hat b_j} - \hat{\mathsf T}'^*_{b_\dagger})$ into Term $IV_m$. The corresponding propagator substitution is asserted but not justified. Standard remedy: an auxiliary lemma telescoping the random propagator into the fixed one.
- **Step-size restriction $c\|\hat{\mathsf T}'_{b_\dagger}\|^2 \le 1$ is for the population, not the empirical operator** (regularity-checker #2). The spectral filter inequality is applied to the empirical operator. A high-probability event $\Omega'_n$ should be intersected throughout. Implicit in `ass:rateconv` but not cited.
- **$V$ monotonicity claim at L1188 / L1200 is conditional on `eq-gammadelta`** (regularity-checker #6, counterexample-hunter #7). For $\beta > 1$ the second term of $V$ is decreasing in $m$. Monotonicity is asymptotic, not pointwise at $m = 1, 2$. Standard remedy: replace $V$ by its running maximum, or add a monotonicity hypothesis.
- **$\log\log n$ vs. $\sqrt{\log\log n}$ overhead** (regularity-checker #4, counterexample-hunter #4 + #9). The discussion at L624 announces $O(\log\log n)$ overhead; the proof at L1209 + L1194 delivers $O(\sqrt{\log\log n})$. The discussion is off by a square root.
- **iid → time-series gap** (counterexample-hunter #6). L343 declares iid sampling, yet `sec-empapp-rates` applies the estimator to a $\beta$-mixing T-bill time series. The theorem extends to exponential $\beta$-mixing via Hansen (2008), already cited, but this bridge is not made in the statement of `prp-lepskii` / `ass:rateconv`.
- **$M_n$ growth condition not stated** (counterexample-hunter #8). The Lepskii index lives in $\{1,\ldots,M_n\}$. The oracle inequality bounds the LHS by $C(\tau) \inf_{m\le M_n}[B(m)+V(m)]$; rate-adaptivity requires $M_n \ge m^*(n)$.
- **$L^p$ moment in `ass:rateconv` vs. $L^8$ use in the induction** (regularity-checker C). `thm-mainconv` writes $E\|\hat e_j\|^8$ products. `ass:rateconv` gives only $L^2$ rates. Strengthen to $L^p$ for $p \ge 4$ or supply hypercontractivity.
- **$\Phi$ Lipschitz and $C^2$ bounds need $\|\varphi_\dagger\|_\infty$** (regularity-checker #9 + #10). `ass:unifbd`(iii) bounds $\sigma_\dagger$ only. $L^2$ ball ≠ $L^\infty$ neighborhood. Sobolev embedding under `ass:sourcecond` with $\beta > p/2$ closes the gap.

## What the critics agree is captured

- $\beta \to 0^+$ degeneracy is rate degradation, not theorem failure (CE #1).
- Heavy-tailed $U$ with $E[U^4] = \infty$ is excluded by `ass:unifbd`(iv) (CE #2).
- $\rho(W)\nu(W) = 0$ on a measurable subset is harmless under continuous $W$ with positive-measure 2D variation (CE #10).
- Bias monotonicity $B(m) \downarrow$ is captured by `ass:sourcecond` + `ass:restrvarth` (regularity-checker #7).

## Recommended next moves

1. **Patch `ass:app4` or replace L1194 step.** Either add a sub-Gaussian / sub-exponential assumption on $Y \mid X, W$ (cleanest), or weaken the overhead claim to a Markov-style polynomial-in-$M_n$ overhead.
2. **Make the off-$\Omega_n$ bookkeeping explicit.** Either truncate iterates by projection onto a bounded $L^\infty$ neighborhood of $b_\dagger$, or impose a uniform $L^4$ moment bound on iterates as a corollary of `ass:rateconv` strengthened to $L^p$.
3. **Rephrase the propagator substitution at L1139–1147** as an explicit auxiliary lemma. Suggested form: "On $\Omega_n \cap \Omega'_n$, $\prod_{k}(I - c\hat{\mathsf T}'^*_{\hat b_k}\hat{\mathsf T}'_{\hat b_k}) = (I - c\hat{\mathsf T}'^*_{b_\dagger}\hat{\mathsf T}'_{b_\dagger})^{m-1-j} + R_m$ with $\|R_m\| \le \cdots$."
4. **Reconcile L624 with the proof.** The correct overhead is $\sqrt{\log M_n}$, i.e., $\sqrt{\log\log n}$ in the severely ill-posed regime, $\sqrt{\log n}$ in the mildly ill-posed regime.
5. **Replace "$V$ monotone" by running maximum**, or add `eq-gammadelta` to the hypotheses of `prp-lepskii`.
6. **Add $M_n$ growth condition**: $M_n \asymp N \asymp \delta_n^{-1}$.
7. **Bridge iid to $\beta$-mixing** in `sec-empapp-rates` or in a remark after `ass:rateconv`, citing Hansen (2008) which is already in the bibliography.
8. **Correct the Cavalier–Hengartner citation** in `rem:linear-reduction` — that reference is for block-thresholding, not Lepskii balancing. Hoffmann–Reiss (2008) is the correct benchmark for the noisy-operator Lepskii setup.
9. **Fix notation slips:** $m_4$ vs $M_4$ between L590 and L1180; the $c$ collision between LF step-size and the spectral-filter constant at L596.

## Decision per skill workflow

- Audit-in-place — no theorist re-draft triggered.
- No CONFIRMED counterexample → no CRITICAL escalation on that axis.
- theorist-critic score 32 < 80 → would normally loop back to theorist. Deferred to the user.
- Binary theory submission gate (quality.md §3, items 2 and 4): **BLOCKED** until the two CRITICAL regularity gaps and the theorist-critic score are resolved.

## File index

- `quality_reports/theory/volatility-loc-scale/proofs_review_lepskii.md` — full theorist-critic report (32/100)
- `quality_reports/regularity/regularity-audit_lepskii.md` — full regularity audit (2 CRITICAL, 6 MAJOR, 5 MINOR, 1 CAPTURED)
- `quality_reports/counterexamples/probe-results_lepskii.md` — 10 probes (0 CONFIRMED, 5 medium FLAG, 1 minor FLAG, 4 CAPTURED)
- This file — consolidation
