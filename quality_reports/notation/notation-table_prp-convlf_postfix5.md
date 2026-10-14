# Notation Audit — `prp-convlf` postfix5

**File:** `/Users/samuele/Library/CloudStorage/Dropbox/Nonparametric_IV/Volatility/Centorrino_Florens_VOL_1.qmd`
**Date:** 2026-05-15 (post-fix round 5). Reviewer: notation-warden agent.
**Trajectory:** 76 → 92 → 97 → 98 → 85 (R4) → **85/100** (R5, no improvement on notation axis).

## Patches reviewed

1. **L1045 rename $U_j \to V_j$** + inline disambiguation note "(distinct from the structural error $U$ and the iterate residual $\hat U_j$ used elsewhere in the paper)".
2. **L1028 Heinz inequality invocation** with `\lambda^{(j)}_l` defined inline.

## Findings

**Fix 1 — $U_j \to V_j$ rename: RESOLVED for the $U$-family collision** but **introduced a new $V$-family collision**:
- $V$ at L322: $V \sim N(0,1)$ auxiliary Gaussian r.v. in the FI representation.
- $V$ at L81: symmetric noise in stochastic frontier example.
- $V(m)$ at L592+: variance proxy function in the Lepskii rule.
- $V_j$ at L1045 (new): partial isometry operator.

Three distinct semantic classes (scalar r.v., real-valued function of integer, operator). The disambiguation note at L1045 enumerates the $U$ conflicts but is silent on the $V$ conflicts. **[HIGH, -15]**

**Fix 2 — Heinz inequality at L1028: CLEAN.** $\lambda$ is a bound dummy; $\lambda^{(j)}_l$ defined inline with explicit interval bounds. No new free symbols.

## Score

**85 / 100** (prior 85, traded one collision for another).

## Suggested next move

Rename $V_j \to \Pi_j$ (or $\mathsf{U}_j$ with sans-serif typography). $\Pi$ is unused elsewhere in the paper. Single-occurrence rename. Lifts notation 85 → ~98.
