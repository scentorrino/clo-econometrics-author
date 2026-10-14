# Notation Audit — `prp-convlf` postfix4

**File:** `/Users/samuele/Library/CloudStorage/Dropbox/Nonparametric_IV/Volatility/Centorrino_Florens_VOL_1.qmd`
**Date:** 2026-05-15 (post-fix round 4). Reviewer: notation-warden agent.
**Trajectory:** 76 → 92 → 97 → 98 → **85/100** (REGRESSION −13).

## Patches reviewed

1. L440: Added `ass:unifbd` to hypothesis list.
2. L1028: Coefficient-level Hilbert-scale derivation.
3. L1041: Polar decomposition note with $\mathsf{T}'_{b_j} = U_j(\mathsf{T}'^*_{b_j}\mathsf{T}'_{b_j})^{1/2}$.
4. L1049: Explicit induction step.

## Critical finding

**[HIGH, -15] Notation collision: $U_j$ (partial isometry, new at L1045) vs $\hat U_j$ / $\tilde U_{j i}$ (residual at iterate $j$, used at L525, L1078, L1080, L1082, L390-407).** Although the operator-side $U_j$ has no hat, the same subscripted base letter denoting a different mathematical object in the same proof appendix is a genuine collision. The partial isometry is conventionally $U$ in operator theory but $U$ is the structural error of the paper from L75.

## Other observations

- $\chi_l$, $t_l$, $c^{(j)}_l$, $\lambda^{(j)}_l$ new symbols at L1028 are defined inline or inherited from `def-sourceID` (L275). No collision.
- Coefficient-level argument is well-anchored to existing notation.
- Induction step adds no new symbols.

## Score

**85 / 100** (prior 98, −13). The −13 is entirely the $U_j$ collision.

**Suggested fix:** rename $U_j \to V_j$ or $\mathsf{U}_j$ at L1045 — one-token edit returns score to ~98.
