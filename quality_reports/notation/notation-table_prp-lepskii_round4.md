# Notation Audit — `prp-lepskii` (Round 4)

**Trajectory:** structural cleanup from upstream resolved R5; remaining notation issues now visible.
**Score: 61/100.**
**Date:** 2026-05-17.

## R5 structural concern dissolved
The `eq-Bbias` rewrite, `lem-itervar` event preamble, and `thm-mainconv` simplification flow through cleanly. No stale $(E\Vert\hat b_0\Vert^2)^{1/2}$ piece survives anywhere.

## Findings
- **$M_n$ undefined** (-5): used 22× across the file but never explicitly defined.
- **$c_0$ collision** (-15): Hermite coefficient at L318/L332 vs sub-exponential constant at L1215.
- **$\tau$ collision** (-15): deprecated $(g,\tau)$ at L563 vs Lepskii tuning at L605+.
- **Probability typography** (-4): $\mathbb{P}$ vs $P$ vs $\Pr$ used within ~3 lines at L1215.

## Recovery path
1. Define $M_n$ at sec-lepskii setup (+5).
2. Rename $c_0$ at L1215 to $c_{\rm sub}$ (+15).
3. Clean $\tau$ historical mention at L563 (+15).
4. Standardize on $\mathbb{P}$ (+4).
