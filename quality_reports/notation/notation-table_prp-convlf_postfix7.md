# Notation Audit — `prp-convlf` postfix7 (rollback)

**File:** `/Users/samuele/Library/CloudStorage/Dropbox/Nonparametric_IV/Volatility/Centorrino_Florens_VOL_1.qmd`
**Date:** 2026-05-15 (Round 7 rollback). Reviewer: notation-warden agent.
**Trajectory:** 76 → 92 → 97 → 98 → 85 → 85 → 98 → **98/100** (stable, preserved from R6).

## State

R6 Route (c) rewrite rolled back to R5 wording at L1028 (Heinz inequality + "approximately diagonalises ... interlace" hand-wavy phrasing). R6 $\Pi_j$ rename at L1045 preserved.

## Findings

- $\Pi_j$ uniquely defined at L1045, no collisions anywhere in paper.
- All operators ($\mathsf{T}, \mathsf{T}'_b, \mathsf{A}_b, D, \Pi_j$), sets ($\mathcal{B}_R, \mathcal{B}^*_M$), scalars ($M, M_{\text{lf}}, c, c_1, R, t_l$), and bases ($\chi_l$) consistently typed.
- Minor advisory: L1028 "approximately diagonalises" is a proof-validity concern (out of warden scope).

## Score

**98 / 100.** Stable.
