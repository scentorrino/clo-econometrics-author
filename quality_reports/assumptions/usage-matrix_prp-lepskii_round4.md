# Assumption-Usage Matrix — `prp-lepskii` (Round 4)

**Trajectory:** 32 → **80/100** (+48). Big jump after upstream cleanup.
**Date:** 2026-05-17.

## Findings
- **`ass:app4` mis-cited at L1215** (-15): proof attributes "sub-exponential concentration" to `ass:app4`, but `ass:app4` as stated (L932-934) gives only the density floor $\kappa_n > 0$. Sub-exponential concentration is a separate condition.
- **Redundant hypothesis listing** (-5): "source condition (iv) of @prp-onetoone" and "the link condition `\ref{ass:linkcond}`" are double-cited at L616 since both are already in the `ass:identif-ass:restrvarth` range.

## Recovery path
1. Add sub-exponential tail clause to `ass:app4` OR create `ass:exptail` (+15).
2. Trim redundant hypothesis listing at L616 (+5).
