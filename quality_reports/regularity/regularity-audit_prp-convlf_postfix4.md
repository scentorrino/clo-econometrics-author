# Regularity Audit — `prp-convlf` postfix4

**File:** `/Users/samuele/Library/CloudStorage/Dropbox/Nonparametric_IV/Volatility/Centorrino_Florens_VOL_1.qmd`
**Date:** 2026-05-15 (post-fix round 4). Reviewer: regularity-checker agent.
**Trajectory:** 35 → 81 → 76 → 89 → **87/100** (REGRESSION −2).

## Status of prior residuals

- **R-1 (was MAJOR -5):** Hilbert-scale invariance was citation-only. Patch replaced with explicit coefficient-level derivation at L1028. **PARTIAL — new MAJOR introduced.** See below.
- **N-3 (was MINOR -3):** Polar decomposition / half-power domain. **RESOLVED** via L1041 sentence citing @engl2000 §2.2.
- **N-4 (was MINOR -3):** Sup over $\mathcal{B}_{b_\dagger}$ / induction step. **RESOLVED** via L1049 explicit base case + inductive step.

## New regularity gap introduced

**[MAJOR, -10] Co-diagonalisation gap in L1028 coefficient-level argument.** The derivation states:
$$\Vert(\mathsf{T}'^*_{b_j}\mathsf{T}'_{b_j} - \mathsf{T}'^*_{b_\dagger}\mathsf{T}'_{b_\dagger})\,v\Vert \le (1 - M_{\text{lf}}^{-1})\Vert\mathsf{T}'^*_{b_\dagger}\mathsf{T}'_{b_\dagger}\,v\Vert$$
as a direct consequence of `eq-lfconv`. It is not. `eq-lfconv` bounds the operator norm of a product (Loewner-type spectral comparison); passing to coefficient-wise contraction in the eigenbasis of $\mathsf{T}'^*_{b_\dagger}\mathsf{T}'_{b_\dagger}$ requires either:
- (i) **commutation** of $\mathsf{T}'^*_{b_j}\mathsf{T}'_{b_j}$ with $\mathsf{T}'^*_{b_\dagger}\mathsf{T}'_{b_\dagger}$ (shared eigenbasis), OR
- (ii) a **Heinz inequality / operator-monotone function calculus** to lift the Loewner ordering to a quadratic-form bound.

Neither is assumed or cited. The conclusion (geometric coefficient contraction) is plausible but the mechanical step is missing.

**[MINOR, -3] Silent boundedness invocation.** The final estimate $\sum_l (c^{(j)}_l)^2 \le M^{-2}\sup_l t_l^2$ uses boundedness of $\mathsf{T}'_{b_\dagger}$ (so $\sup_l t_l^2 < \infty$). Standard but not cited at the step.

## Score

| Item | Severity | Deduction |
|---|---|---|
| R-1 new co-diagonalisation gap | MAJOR | -10 |
| Boundedness invocation silent | MINOR | -3 |

**Score: 87 / 100** (prior 89, **−2 net**).

The patch closed N-3 (+3) and N-4 (+3) and reduced R-1 from -5 (citation-only) to "now contains a derivation" but the explicit derivation surfaced a new -10 gap, plus a -3 minor. Net: 89 + 3 + 3 + 5 − 10 − 3 = **87**.

## Suggested fix

**One-line patch at L1028:** invoke Heinz inequality or assume co-diagonalisation. Either:
- "By the Heinz inequality, the Loewner ordering $\mathsf{T}'^*_{b_\dagger}\mathsf{T}'_{b_\dagger} \le M_{\text{lf}}^{-1}\mathsf{T}'^*_{b_j}\mathsf{T}'_{b_j}$ implied by \eqref{eq-lfconv} transfers to coefficient bounds in the eigenbasis of $\mathsf{T}'^*_{b_\dagger}\mathsf{T}'_{b_\dagger}$ up to a constant"; OR
- "As in the Hilbert-scale construction of @engl2000 §8.4, we work in coordinates that co-diagonalise $\mathsf{T}'^*_{b_\dagger}\mathsf{T}'_{b_\dagger}$ and $D^{-1}$, so each spectral coefficient updates independently."

Lift: regularity 87 → ~93.
