# Assumption-Usage Matrix — `thm-mainconv` postfix2

**File:** `/Users/samuele/Library/CloudStorage/Dropbox/Nonparametric_IV/Volatility/Centorrino_Florens_VOL_1.qmd`
**Date:** 2026-05-15 (post-fix round 2). Reviewer: assumption-auditor agent.
**Trajectory:** 45 → 96 → **100/100** (+4).

## Residual fix verified

L1088 now reads: "Local identification (Assumption \ref{ass:identif}) and admissibility of the initial condition (Assumption \ref{ass:initcond}: $b_0 \in \mathcal{B}_{b_\dagger}$) keep the LF orbit $\{\hat b_j\}_{j=0}^N$ inside $\mathcal{B}_{b_\dagger}$ on $\mathcal{E}_n^{\mathrm{thm}}$ via @prp-convlf, so @prp-koper applies at every $j$."

This pin-cites both `ass:identif` (orbit containment) and `ass:initcond` (basin admissibility), cites the bridging proposition `@prp-convlf`, and explains the downstream consequence (uniform applicability of `@prp-koper` across all LF iterates).

## Final matrix

| Assumption | Pin-cited in proof | Strength |
|---|---|---|
| `ass:identif` | L1088 | Full |
| `ass:initcond` | L1088 | Full |
| `ass:sourcecond` | L1099 (Term I) | Full |
| `ass:rateconv` | L1088 ($L^4$), Terms II/IV | Full |
| `ass:unifbd` | L1084, throughout | Full |
| `ass:linkcond` | L1135 | Full |
| `ass:restrvarth(iii)` | L1133 (saturation) | Full |
| `ass:app1`–`ass:app6` | L1080, L1084 | Full |

## Score

**100 / 100.** No unused, over-strong, or unstated conditions remain.
