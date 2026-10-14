# Assumption-Usage Matrix — `prp-condcomp` postfix

**File:** `/Users/samuele/Library/CloudStorage/Dropbox/Nonparametric_IV/Volatility/Centorrino_Florens_VOL_1.qmd`
**Date:** 2026-05-15 (post-fix). Reviewer: assumption-auditor agent.
**Trajectory:** 85 → **100/100** (+15).

## Status

The MI sub-case gap is closed. L1010 explicitly invokes:
- The MI variant of `ass:condcomp` (two moment identities).
- `eq-mi`'s $\mathrm{Var}(U \mid W) = 1$ for the scale null-direction derivation.
- L148 reference for the location/scale null-direction exclusion algebra.

## Updated matrix

| Assumption / Equation | Used at | Strength |
|---|---|---|
| `ass:condcomp` FI variant | L1004–1008 | Full |
| `ass:condcomp` MI variant | L1010 | Full |
| `eq-fi` | L1008 (side conditions) | Full |
| `eq-mi` | L1010 ($\mathrm{Var}(U \mid W) = 1$) | Full |
| `ass:differentiability` | L1008 (density positivity) | Full |
| `ass:unifbd` | L1014–1016 (remainder bound) | Full |

## Score

**100 / 100.**

Minor stylistic flag (not deducted): "as observed at L148" would survive reflows better as a labeled cross-reference.
