# Theory Audit — `prp-koper` postfix2 (FINAL)

**Target:** Proposition `prp-koper` after two-round fix pass.
**Mode:** AUDIT-IN-PLACE.

## Summary

| Critic | Initial | R1 | **R2 (final)** | Δ from initial |
|---|---|---|---|---|
| **notation-warden** | 49 | 75 | **95** | **+46** |
| **assumption-auditor** | 25 | 70 | **100** | **+75** |
| **regularity-checker** | 8 | 91 | **97** | **+89** |

**Aggregate: 97 / 100.** Up from 27 initial (**+70 across two rounds**).

## All gates cleared

| Gate | Threshold | Verdict |
|---|---|---|
| Commit | ≥ 80 | **PASS** (97) |
| PR | ≥ 90 | **PASS** (97) |
| **Submission** | ≥ 95 + all components ≥ 80 | **PASS** (all components ≥ 95) |
| Theory binary gates | no critical findings | **PASS** |

## What R1 closed

- **CRITICAL "a.s." → "w.p. $1 - o(1)$"** via $\mathcal{E}_n$ event construction.
- **$M_n$ collision (Dunker vs Lepskii)** via rename to $C_{\mathrm{D},n}$.
- **$M$ overload** via rename to $M_{23}$ throughout (propagated to thm-mainconv, lem-itervar).
- **Hypothesis block** replaced dash-range with explicit list, dropping 4 unused, adding `ass:unifbd`.
- **All 6 MAJOR regularity items:** mean-value form, kernel-representation justification, uniformity domain, Dunker→Hansen citation, $\hat f_X$ trimming, $K$ shift definition.
- **$\bar b_{jt}$ typo** fixed to $\hat b_{jt}$.
- **$b \cdot Y$ shorthand** replaced with $\rho_b(x, y) := g(x) + e^{\omega(x)} y$.
- **$h_u^{-2}$ Lipschitz** derivation displayed explicitly.

## What R2 closed

- **$K$ triple collision** via univariate kernel rename $K \to \mathcal{K}$ with explicit disambiguation note.
- **L520 hypothesis broadening** to include `ass:app1` (both parts) + `ass:app2` — closes both prior assumption-auditor leakages.
- **$\hat U_j, \mathcal{Y}, \mathcal{W}, \mathcal{X}_{\mathrm{tr}}$** defined at first use in the statement.
- **Two of three MINOR regularity residuals**: change-of-variables explicit, Taylor expansion sourced to `ass:app3a`.

## Single remaining residual

- **Bochner integrability of $t \mapsto \hat{\mathsf T}'_{\hat b_{jt}}$ at L1053** (MINOR, -3). One-line pointer to `ass:frediff` for continuity would close it. Not blocking submission.

## Trajectory across all four propositions audited

| Proposition | Final | Rounds |
|---|---|---|
| `prp-onetoone` (post-fix) | **99 / 100** | 1 round |
| `prp-convlf` (post-fix R7) | **96 / 100** | 7 rounds (1 rollback) |
| `prp-lepskii` (Round 3 terminal) | 69 / 100 | 3 strikes — terminal |
| **`prp-koper` (postfix R2)** | **97 / 100** | **2 rounds (clean)** |

`prp-koper` was structurally similar to `prp-convlf` at initial audit (27 vs 62) but converged twice as fast (2 rounds vs 7). The cleaner trajectory reflects two factors: (a) the issues were more localized (notation collisions, assumption-block surgery, citation patches) and (b) Round 1 included a "complete" rewrite of both parts rather than incremental patches.

## Files

- `quality_reports/notation/notation-table_prp-koper_postfix2.md` (95)
- `quality_reports/assumptions/usage-matrix_prp-koper_postfix2.md` (100)
- `quality_reports/regularity/regularity-audit_prp-koper_postfix2.md` (97)
- `quality_reports/audit/audit-2026-05-15-prp-koper-postfix2.md` (this, consolidated)

## Three of four propositions now at submission quality

After this round:
- `prp-onetoone`: 99 ✓
- `prp-convlf`: 96 ✓
- **`prp-koper`: 97 ✓**
- `prp-lepskii`: 69 ✗ (terminal at three-strikes; structural issues with source-condition preservation under non-co-diagonalisable operators)

`prp-lepskii` remains the outlier and would benefit from either (a) adding a co-diagonalisation assumption (route C from earlier escalation) or (b) weakening the conclusion to norm-only convergence (route B).
