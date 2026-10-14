# Assumption-Usage Audit — `prp-convlf` postfix4

**File:** `/Users/samuele/Library/CloudStorage/Dropbox/Nonparametric_IV/Volatility/Centorrino_Florens_VOL_1.qmd`
**Date:** 2026-05-15 (post-fix round 4). Reviewer: assumption-auditor agent.
**Trajectory:** 76 → 87 → 88 → 96 → **99/100** (+3).

## Updated usage matrix

| Assumption | In hypothesis block? | Invoked at | Strength |
|---|---|---|---|
| `ass:identif` | YES | L1049 | Full |
| `ass:initcond` | YES | L1028, L1049 | Full |
| `ass:unifbd` | YES (added) | L1028, L1039 | Full |
| `ass:sourcecond` | YES | L1028, L1039 | Full |
| `ass:linkcond` | YES | L1028 | Full |
| Step-size $c\sup\Vert\mathsf{A}^*_b\mathsf{A}_b\Vert<1$ | YES | L1028, L1049 | Full |
| eq-lfconv | YES | L1028, L1041-1043 | Full |
| Radius $c_1 R^2 \le M$ | YES | L1039 | Full |

## Findings

- **`ass:unifbd` residual RESOLVED.** Now in hypothesis block.
- **No unused assumptions.** Every named assumption is invoked.
- **No new dependencies introduced.** All patches use items already declared.
- **Residual phrasing -1:** L1039 still says "automatically delivered" — minor copy-edit.

## Score

**99 / 100** (prior 96, +3). Cleanly above all gates.
