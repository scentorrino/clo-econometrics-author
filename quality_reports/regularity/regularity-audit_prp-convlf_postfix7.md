# Regularity Audit — `prp-convlf` postfix7 (rollback)

**File:** `/Users/samuele/Library/CloudStorage/Dropbox/Nonparametric_IV/Volatility/Centorrino_Florens_VOL_1.qmd`
**Date:** 2026-05-15 (Round 7 rollback). Reviewer: regularity-checker agent.
**Trajectory:** 35 → 81 → 76 → 89 → 87 → 92 → 40 → **92/100** (matches R5).

## R6 CRITICALs verified gone

- **R6 CRITICAL #1 (wrong conjugation $D^{-1}\cdot D^{-1}$):** RESOLVED. Paragraph reverted — the inverted formula is no longer in the text.
- **R6 CRITICAL #2 (false shared-eigenbasis from singular-value equivalence):** RESOLVED. Hard claim replaced by hedged R5 wording: "(approximately) diagonalises ... spectral subspaces interlace ... up to a multiplicative factor controlled by $M_{\text{lf}}$."

## Current residuals (R5 baseline restored)

- **MAJOR PARTIAL R-1 (-5):** L1028 "approximately diagonalises ... interlace" parenthetical is hand-wavy. Heinz inequality is the right tool; coefficient-level transfer requires a Birman-Solomyak / Weyl-type lemma not cited inline. Defensible but not fully derived.
- **MINOR (-3):** Source-condition tail boundedness silent ($\sup_l t_l^2 < \infty$).

## Items cleared at earlier rounds (preserved)

Mean-value theorem at L1039; kernel-difference bound; $\Pi_j$ polar decomposition at L1045; inductive membership at L1049; boundary $M_{\text{lf}} = 1$ via Fejér; $\Vert\mathsf{A}^*\mathsf{A}\Vert = \Vert\mathsf{A}\mathsf{A}^*\Vert$.

## Score

**92 / 100.** Matches R5 exactly — confirming the rollback was clean.

## Honest assessment

The cleanest state achievable without a full rigorous replacement of the eigenbasis-and-coefficient transfer. Either:
- accept the R5 hand-wavy "approximately diagonalises" phrasing (PARTIAL R-1, -5);
- OR perform a theorist-level rewrite with a precise Weyl-Horn-Birman-Solomyak-style citation for self-adjoint compact operators under two-sided Loewner bounds.

This is the same assessment from R5. R6's attempt to fully derive without changing structural assumptions revealed two real mathematical errors and was rolled back.
