# Regularity Audit — `prp-convlf` postfix3

**File:** `/Users/samuele/Library/CloudStorage/Dropbox/Nonparametric_IV/Volatility/Centorrino_Florens_VOL_1.qmd`
**Date:** 2026-05-15 (post-fix round 3). Reviewer: regularity-checker agent.
**Trajectory:** 35 → 81 → 76 → **89/100** (+13).

## Status of prior findings

- **N-1 [MAJOR, -10] — `ass:linkcond` invoked but not in hypothesis. RESOLVED.** L440 now lists `ass:linkcond`. Hilbert-scale invariance argument at L1028 is legitimately backed. **+10.**
- **N-2 [MINOR, -3] — `ass:sourcecond` / $\mathcal{B}^*_M$ silently in scope. RESOLVED.** L440 now states $\mathcal{B}_{b_\dagger} = \mathcal{B}_R \cap \mathcal{B}^*_M$ and lists `ass:sourcecond`. **+3.**

## Findings still open (carried forward)

- **R-1 [MAJOR, -5] — Hilbert-scale preservation derivation.** Hypothesis block now contains the right ingredients, but the derivation at L1028 still leans on @engl2000 §8.4 + @florens2012 Lemma 3.1 without exhibiting the coefficient-level computation that translates "singular values comparable" into "Fourier coefficients in $D^{-s}$ scale at radius $M$." Not a scope question (which has been closed) — a derivation question.

- **N-3 [MINOR, -3] — Pseudo-inverse square-root domain at L1041.** Identity requires $b_j - b_\dagger \in \text{Ran}((\mathsf{T}'^*_{b_j}\mathsf{T}'_{b_j})^{1/2})$. The half-power square-root domain is left implicit; range condition in hypothesis is stated but the square-root domain calculus needs a half-line via polar decomposition or @engl2000 §2.2.

- **N-4 [MINOR, -3] — Sup over $\mathcal{B}_{b_\dagger}$ at iterate.** Inductive logic at L1049 is consistent but implicit. Standard remedy: one sentence "by induction, $b_j \in \mathcal{B}_{b_\dagger}$ for present $j$; we now propagate to $j+1$."

## Score

| Item | Status | Deduction |
|---|---|---|
| R-1 (Hilbert-scale derivation, MAJOR) | open | -5 |
| N-3 (pseudo-inverse domain) | open | -3 |
| N-4 (sup over $\mathcal{B}_{b_\dagger}$ at iterate) | open | -3 |

**Score: 89 / 100** (prior 76, +13).

The expansion of the hypothesis block at L440 also tightens the strict step-size boundary case (excluded explicitly), closing a latent minor.

## Verdict

The patches close both the N-1 (MAJOR scope) and N-2 (MINOR scope) issues cleanly. Three derivation-level residuals remain: the Hilbert-scale invariance is cited rather than derived (R-1, the largest remaining gap); the pseudo-inverse half-power domain at L1041 needs a half-line of justification (N-3); the induction at L1049 is consistent but implicit (N-4). All three are addressable in a fourth pass; together they would lift the score to ~95.

PR threshold (≥90) is one point shy. Submission threshold (≥95) requires closing R-1.
