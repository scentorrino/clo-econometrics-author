# Notation Audit — `prp-convlf` postfix3 (final pass)

**File:** `/Users/samuele/Library/CloudStorage/Dropbox/Nonparametric_IV/Volatility/Centorrino_Florens_VOL_1.qmd`
**Date:** 2026-05-15 (post-fix round 3). Reviewer: notation-warden agent.
**Trajectory:** 76 → 92 → 97 → **98/100** (+1).

## Patch under review

L440 hypothesis block expanded:
- Added `ass:sourcecond` and `ass:linkcond` to the hypothesis list.
- Made $\mathcal{B}_{b_\dagger} = \mathcal{B}_R \cap \mathcal{B}^*_M$ explicit.
- Surfaced radius condition $c_1 R^2 \le M$ from L1039 to the proposition statement.

## Verification

- All cross-references resolve: `@sec-annexA2` (L948), `@prp-onetoone` (L189), `@prp-condcomp` (L285), `\eqref{eq-derivdiff}` (L972, forward reference).
- Constants on L440 vs. original definitions: $c_1$ from L986 (kernel-difference, same role); $M$ from prp-onetoone(iii) and L277; $R$ from L186; $M_{\text{lf}}$ unchanged; $I$ matches L1034/L1047 usage.
- No new collisions introduced.

## Residual

- **[-2 advisory]** $c_1$ pre-existing collision: L318 uses $c_1$ as Hermite coefficient of $\tilde h$ (Gaussian example); L401/L440/L986/L1158 use $c_1$ as kernel-difference constant. Patch widens the constant's scope (now appears in proposition statement) but doesn't widen collision — Hermite-coefficient reading impossible in the proposition context. Recommend renaming Hermite coefficient at L318 to $\gamma_1$ in a future polish pass.

## Score

**98 / 100** (prior 97, +1). Trajectory 76 → 92 → 97 → 98.

The expanded hypothesis block is internally consistent, all cross-references resolve, no new notation issue. The only residual is the carried-over `$c_1$ scope collision` advisory, which is pre-existing and not introduced by these patches.
