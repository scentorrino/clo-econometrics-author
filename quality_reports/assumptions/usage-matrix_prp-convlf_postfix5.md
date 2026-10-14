# Assumption-Usage Audit — `prp-convlf` postfix5

**File:** `/Users/samuele/Library/CloudStorage/Dropbox/Nonparametric_IV/Volatility/Centorrino_Florens_VOL_1.qmd`
**Date:** 2026-05-15 (post-fix round 5). Reviewer: assumption-auditor agent.
**Trajectory:** 76 → 87 → 88 → 96 → 99 (R4) → **99/100** (R5, stable).

## Findings

**Patch 1 ($U_j \to V_j$ rename):** Notational only. No assumption added or removed.

**Patch 2 (Heinz inequality at L1028):** Imports `ass:linkcond` + `eq-lfconv` (both in hypothesis block) + textbook Heinz/operator-monotonicity (Engl-Hanke-Neubauer Lemma 2.21, not an assumption). No new dependency.

## Score

**99 / 100** (prior 99, stable). Single residual is a phrasing minor ("approximately diagonalises" conflates `ass:linkcond` norm equivalence with `eq-lfconv` Loewner ordering — splitting them tightens exposition but doesn't change assumption usage).

Cleanly above all gates.
