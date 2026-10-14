# Notation Audit — `prp-convlf` postfix6

**File:** `/Users/samuele/Library/CloudStorage/Dropbox/Nonparametric_IV/Volatility/Centorrino_Florens_VOL_1.qmd`
**Date:** 2026-05-15 (post-fix round 6). Reviewer: notation-warden agent.
**Trajectory:** 76 → 92 → 97 → 98 → 85 → 85 → **98/100** (+13).

## Patches reviewed

1. **L1045 — $V_j \to \Pi_j$ rename.** Disambiguation note removed (unnecessary since $\Pi$ has no collision).
2. **L1028 — Route (c) Loewner argument** replacing the spectral-interlacing parenthetical.

## Findings

- **$\Pi_j$ has zero collisions in the paper.** Single occurrence at L1045, defined-before-use, no other $\Pi$ usage anywhere.
- **L1028 rewrite:** introduces local placeholders $A, B$ (defined inline), reuses already-established $M_{\text{lf}}, \chi_l, t_l, c^{(j)}_l$. No new symbols, no new collisions.
- Minor stylistic note: generic $A, B$ as positive-operator dummies sit in the same paragraph as bold-sans-serif $\mathsf{A}_{b_j}$. Fonts distinct, but cosmetic friction.

## Score

**98 / 100** (prior 85, **+13**). Notation issues from R4/R5 fully resolved.
