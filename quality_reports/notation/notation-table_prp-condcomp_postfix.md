# Notation Audit — `prp-condcomp` postfix

**File:** `/Users/samuele/Library/CloudStorage/Dropbox/Nonparametric_IV/Volatility/Centorrino_Florens_VOL_1.qmd`
**Date:** 2026-05-15 (post-fix). Reviewer: notation-warden agent.
**Trajectory:** 88 → **97/100** (+9).

## Findings

- **Scope-coverage gap RESOLVED.** L1002 announces "We treat the two routes in parallel." Explicit "FI variant" and "MI variant" sub-cases at L1004–1010 with proper $\mathsf{T}'_{\text{FI}, b_\dagger}$ vs $\mathsf{T}'_{\text{MI}, b_\dagger}$ disambiguation. L1012 closes both routes uniformly.
- No new collisions, undefined symbols, or typography drift introduced by the MI sub-case.
- Cross-references resolve: `eq-tmider-bdagger`, `eq-mi`, `eq-fi`, `ass:condcomp`, `ass:differentiability`, `ass:app4`.

## Residual (-3 advisory)

L1010 contains prose line-number reference "as observed at L148" — would survive reflows better as a labeled cross-reference. Stylistic, not a notation violation.

## Score

**97 / 100.**
