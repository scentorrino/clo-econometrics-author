# Assumption-Usage Audit — `prp-convlf` postfix6

**File:** `/Users/samuele/Library/CloudStorage/Dropbox/Nonparametric_IV/Volatility/Centorrino_Florens_VOL_1.qmd`
**Date:** 2026-05-15 (post-fix round 6). Reviewer: assumption-auditor agent.
**Trajectory:** 76 → 87 → 88 → 96 → 99 → 99 → **100/100** (+1).

## Findings

**Patch 1 ($V_j \to \Pi_j$ rename):** notation only.

**Patch 2 (L1028 Route (c) rewrite):** all invoked facts trace either to (a) explicit hypothesis block at L440 (`ass:linkcond`, `ass:sourcecond`, eq-lfconv, step-size) or (b) textbook references properly cited (@engl2000 Lemma 2.21).

## Score

**100 / 100.** No assumption-level issues. All hypotheses load-bearing, none over-strong, none under-stated.

(Note: the regularity-checker found two CRITICAL mechanical errors in the Route (c) rewrite — these are mathematical, not assumption-block issues. The assumption surface is clean even though the proof step itself has mechanical errors.)
