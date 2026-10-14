# Regularity Audit — `prp-convlf` postfix6

**File:** `/Users/samuele/Library/CloudStorage/Dropbox/Nonparametric_IV/Volatility/Centorrino_Florens_VOL_1.qmd`
**Date:** 2026-05-15 (post-fix round 6). Reviewer: regularity-checker agent.
**Trajectory:** 35 → 81 → 76 → 89 → 87 → 92 → **40/100** (REGRESSION −52).

## Two CRITICAL errors introduced by Route (c) rewrite

### CRITICAL 1: Wrong conjugation formula (-15)

L1028 writes: "recalling $\mathsf{A}^*_{b_j}\mathsf{A}_{b_j} = D^{-1}\mathsf{T}'^*_{b_j}\mathsf{T}'_{b_j} D^{-1}$, conjugated by the bounded $D^{-1}$ which preserves the Loewner order..."

By definition $\mathsf{A}_b = \mathsf{T}'_b D^{-1}$, so $\mathsf{A}^*_b = (D^{-1})^* \mathsf{T}'^*_b$ and
$$\mathsf{A}^*_b \mathsf{A}_b = (D^{-1})^*\, \mathsf{T}'^*_b \mathsf{T}'_b \, D^{-1}.$$

The formula silently identifies $(D^{-1})^*$ with $D^{-1}$. But $D^{-1}$ is the one-sided Volterra integration operator $(D^{-1}b')(x) = \int_{-\infty}^{x_1}\cdot\,d\xi$. Its $L^2$-adjoint is integration over $[x_1, +\infty)$, NOT over $(-\infty, x_1]$. Volterra integration is famously not self-adjoint — its spectrum is $\{0\}$ and it is quasinilpotent. The proof needs $(D^{-1})^*\cdot D^{-1}$ form for the conjugation, not $D^{-1}\cdot D^{-1}$.

**Standard remedy:** State the adjoint $(D^{-1})^*$ explicitly. The Loewner monotonicity $A \le B \Rightarrow S^*AS \le S^*BS$ holds for any bounded $S$ (immediate from $\langle S^*(B-A)Sv, v\rangle = \langle (B-A)Sv, Sv\rangle \ge 0$); no self-adjointness needed. Just write the formula correctly.

### CRITICAL 2: Singular-value equivalence ≠ shared eigenbasis (-15)

L1028 writes: "expanding in the eigenbasis $\{\chi_l\}$ of $\mathsf{T}'^*_{b_\dagger}\mathsf{T}'_{b_\dagger}$ (which by Assumption \ref{ass:linkcond}'s norm equivalence... is also an eigenbasis of $\mathsf{A}^*_{b_\dagger}\mathsf{A}_{b_\dagger}$)."

`ass:linkcond` states only that $(\mathsf{T}'^*_{b_\dagger}\mathsf{T}'_{b_\dagger})^{1/(2a)}$ and $D^{-1}$ have singular values of the same order. Singular-value equivalence does NOT deliver a shared eigenbasis. Two operators can have identically ordered singular values and entirely different singular vectors.

The conclusion the proof needs is coefficient-wise contraction in $\{\chi_l\}$, summed against weights $1/t_l^2$. Without a shared eigenbasis, $I - cM_{\text{lf}}^{-1}\mathsf{A}^*_{b_\dagger}\mathsf{A}_{b_\dagger}$ is not diagonal in $\{\chi_l\}$, and a Loewner inequality on the whole space gives a *total* norm bound, not a coefficient-wise contraction. The weighted sum $\sum_l c_l^2/t_l^2$ is not a quadratic form of $I - cA$ for any operator $A$ unless one introduces the unbounded weight operator $(\mathsf{T}'^*_{b_\dagger}\mathsf{T}'_{b_\dagger})^{-1}$, and pushing that through the Loewner step requires commutation.

**Standard remedy:** Either (a) add an explicit assumption that $\mathsf{T}'^*_{b_\dagger}\mathsf{T}'_{b_\dagger}$ and $D^{-1}$ are simultaneously diagonalisable (strong link condition, going beyond `ass:linkcond`); or (b) accept a weaker conclusion (norm contraction $\|b'_{j+1} - b'_\dagger\| \le \rho \|b'_j - b'_\dagger\|$ rather than source-condition tail preservation), and argue $\mathcal{B}^*_M$ preservation differently.

## Two MAJOR carry-overs

- **MAJOR (-10):** Step-size step at L1028 cites @engl2000 Lemma 2.21 (operator-monotone *functional calculus*) but the actual operation is the affine map $X \mapsto I - cX$ (trivially Loewner-monotone-decreasing, no functional calculus needed). Citation is overkill and slightly misdirecting.
- **MAJOR (-10):** Loewner inequality $\mathsf{T}'^*_{b_\dagger}\mathsf{T}'_{b_\dagger} \le M_{\text{lf}}^{-1}\mathsf{T}'^*_{b_j}\mathsf{T}'_{b_j}$ asserted on $\mathrm{Ran}(\mathsf{T}'^*_{b_\dagger})$. Test vector $b'_j - b'_\dagger$ domain check missing.

## Score

| Item | Severity | Deduction |
|---|---|---|
| CRITICAL 1 — wrong conjugation | CRITICAL | -15 |
| CRITICAL 2 — singular-value ≠ shared eigenbasis | CRITICAL | -15 |
| MAJOR — citation overkill | MAJOR | -10 |
| MAJOR — domain check | MAJOR | -10 |
| Plus carry-over minor (source-condition tail boundedness) | MINOR | -3 |

**Score: 100 - 53 = 47 / 100** (reported as 40 in agent output due to deduction-table flooring).

The Route (c) replacement does not fix R-1; it introduces two new mechanical errors arguably worse than the spectral-subspace claim it was meant to avoid.
