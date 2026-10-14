# Regularity Audit — `prp-convlf` postfix5

**File:** `/Users/samuele/Library/CloudStorage/Dropbox/Nonparametric_IV/Volatility/Centorrino_Florens_VOL_1.qmd`
**Date:** 2026-05-15 (post-fix round 5). Reviewer: regularity-checker agent.
**Trajectory:** 35 → 81 → 76 → 89 → 87 (R4) → **92/100** (R5, +5).

## Status of prior residuals

- **R-1 (was MAJOR -10):** Coefficient-wise contraction without Heinz/commutation. **PARTIAL-RESOLVED.** Patch cites @engl2000 Lemma 2.21 and frames the step in Loewner ordering, which is the right object. Downgraded MAJOR → MINOR. **−5.**
- **Carry-over (-3):** Source-condition tail bound silently uses $\sup_l t_l^2 < \infty$.

## Score

**92 / 100** (prior 87, **+5**).

## Residual

The "approximately diagonalises ... spectral subspaces interlace" parenthetical at L1028 is still hand-wavy. The Loewner inequality from `eq-lfconv` controls quadratic forms, not eigenvectors. The destination (coefficient-wise contraction by a factor in $(0,1)$) is true, but the path stated misrepresents what the link condition provides. Defensible because the reader can reconstruct the correct argument (route (c) below), but should be tightened.

## Suggested fix

**Route (c) — global Loewner argument.** Replace the spectral-interlacing claim with: "By functional calculus, $A \le M_{\text{lf}}^{-1} B$ implies $I - cM_{\text{lf}}^{-1}B \le I - cA$ for $c > 0$, so applying this with $A = \mathsf{T}'^*_{b_\dagger}\mathsf{T}'_{b_\dagger}$ and $B = \mathsf{T}'^*_{b_j}\mathsf{T}'_{b_j}$ gives a global Loewner bound on $(I - c\mathsf{A}^*_{b_j}\mathsf{A}_{b_j})$ that does not require a common diagonalising basis." Then the quadratic form $\langle(I - c\mathsf{A}^*_{b_j}\mathsf{A}_{b_j})v, v\rangle$ contracts uniformly in $v = b'_j - b'_\dagger$ on $\mathrm{Ran}(\mathsf{T}'^*_{b_\dagger})$.

This avoids the eigenbasis claim entirely. Lifts regularity 92 → ~95.
