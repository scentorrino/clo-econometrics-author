# Assumption-Usage Audit — `prp-convlf` postfix7

**File:** `/Users/samuele/Library/CloudStorage/Dropbox/Nonparametric_IV/Volatility/Centorrino_Florens_VOL_1.qmd`
**Date:** 2026-05-15 (Round 7 rollback). Reviewer: assumption-auditor agent.
**Trajectory:** 76 → 87 → 88 → 96 → 99 → 99 → 100 → **99/100** (preserved).

## State

L1028 rolled back to R5 wording. Hypothesis block unchanged (contains `ass:identif`, `ass:initcond`, `ass:unifbd`, `ass:sourcecond`, `ass:linkcond`, step-size, eq-lfconv, radius condition).

## Findings

All assumptions in the block are USED. No over-strong, no under-stated. The polar-decomposition step at L1045 draws its range condition from eq-lfconv + $\mathcal{B}^*_M$ membership — both already declared. L1028 cites @engl2000 Lemma 2.21 as a textbook reference, not a hidden assumption.

## Score

**99 / 100.** Minor: radius condition $c_1 R^2 \le M$ and strict step-size are in-line conditions inside the proposition rather than promoted to numbered assumptions — stylistic, not logical.
