# Assumption-Usage Audit — `prp-koper` postfix2

**File:** `/Users/samuele/Library/CloudStorage/Dropbox/Nonparametric_IV/Volatility/Centorrino_Florens_VOL_1.qmd`
**Date:** 2026-05-15 (post-fix round 2). Reviewer: assumption-auditor agent.
**Trajectory:** 25 → 70 → **100/100** (+30).

## Updated usage matrix

All eight assumptions in the new L520 hypothesis block are USED:

| Assumption | Invoked at | Strength |
|---|---|---|
| `ass:unifbd` | L1063, L1070, L1080, L1084 | Full ((i)-(iii)) |
| `ass:frediff` | L1053 (mean-value theorem) | Full |
| `ass:app1`(i) | L1061 (Hansen 2008 rate for $\partial_y\hat f_{Y,X|W}$) | Full |
| `ass:app1`(ii) | L1066-1070 ($\mathcal{E}_n^{(2)}$, $M_X<\infty$) | Full |
| `ass:app2` | L1080 (Hansen 2008 rate for $\hat f_{\hat U_j}$, needs $f_U$ smoothness) | Full |
| `ass:app3a` | L1061, L1074, L1084 (univariate kernel $\mathcal{K}$) | Full |
| `ass:app3b` | L1061, L1074 | Full |
| `ass:app4` | L1080 ($M_1/\kappa_n$ ratio bound), L1084 | Full |
| `ass:app5` | L1061 ($C_{\mathrm{D},n}$ rate), L1066 | Full |

## Findings

- Both prior leakages RESOLVED:
  - L1061 `ass:app1`(i) — now in scope (full `ass:app1`).
  - L1080 `ass:app2` — now in scope (explicit listing).
- Necessity verified: `ass:app1`(i) genuinely needed for Hansen 2008 derivative rate; `ass:app2` genuinely needed for $\hat f_{\hat U_j}$ uniform consistency (target $f_U$ smoothness).
- No newly unused assumptions.

## Score

**100 / 100.** Cleanly above all gates.
