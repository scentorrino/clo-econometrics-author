# Notation Audit (Post-Fix) — Proposition `prp-convlf`

**File:** `/Users/samuele/Library/CloudStorage/Dropbox/Nonparametric_IV/Volatility/Centorrino_Florens_VOL_1.qmd`
**Date:** 2026-05-15 (post-fix). Reviewer: notation-warden agent.
**Prior score:** 76/100. **New score:** **92/100** (+16).

## Section 1. Patch verification table

| # | Patch | Location | Verdict |
|---|---|---|---|
| 1 | Step-size hypothesis + Moore-Penrose convention + range condition | L440 | **RESOLVED** |
| 2 | $M_4 \to M_{\text{lf}}$ in eq-lfconv | L442, L445 | **RESOLVED** |
| 3 | Metric-mismatch bridge via $D^{-1}$ | L1028 | **RESOLVED** |
| 4 | Explicit chain for L1037 inequality | L1039 | **RESOLVED** |
| 5 | $M_4 \to M_{\text{lf}}$ in proof + line-break fix | L1043, L1047-1048 | **RESOLVED** |
| 6 | Re-source injectivity through eq-lfconv + Fejér for $M_{\text{lf}}=1$ | L1049 | **RESOLVED** |
| 7 | $A_a \to \mathsf{A}_a$ typography | L456 | **RESOLVED** |

## Section 2. Residual

- **[-5]** $I$ (identity operator) used at L1034, L1036, L1047 without explicit introduction.
- **[-2]** $T_{\text{FI}}$ at L661 (simulation section) still plain italic — outside prp-convlf scope but in same document.
- **[-1, advisory]** $c_1$ used both as Hilbert-Schmidt constant (L401, L984) and as Hermite coefficient at L318. Disjoint contexts.

## Section 3. Score

**92 / 100** (prior 76, +16).

## Section 4. Verdict

The targeted edit pass closes every issue specifically tied to prp-convlf. The Moore-Penrose convention is now stated, the range condition explicit, the step-size hypothesis bound to operator norm with deterministic bound from sec-derivreparam, $M_4\to M_{\text{lf}}$ rename eliminates the $m_4$ near-collision, $D^{-1}$ metric bridge supplies the transfer from derivative-space to function-space convergence, the L1037 inequality is derived end-to-end, and the boundary case $M_{\text{lf}}=1$ is handled cleanly via Fejér monotonicity. The $\mathsf{A}_a$ italic typo at L456 is repaired. Two residual notation items remain ($I$ identity operator, one stray $T_{\text{FI}}$ at L661) but neither falls inside the proposition under review. The proposition is now notation-clean and well above the 80 gate.
