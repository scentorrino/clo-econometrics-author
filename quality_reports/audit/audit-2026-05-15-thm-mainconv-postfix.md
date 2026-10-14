# Theory Audit — `thm-mainconv` postfix

**Target:** Theorem `thm-mainconv` after one-round fix pass.
**Mode:** AUDIT-IN-PLACE re-audit.

## Summary

| Critic | Initial | **Postfix** | Δ |
|---|---|---|---|
| **notation-warden** | 86 | **96** | +10 |
| **assumption-auditor** | 45 | **96** | **+51** |
| **regularity-checker** | 0 floor (raw -19) | **91** | **+91+** |

**Aggregate: 94 / 100** (initial 44). **+50 in one round.**

## Gates

| Gate | Threshold | Verdict |
|---|---|---|
| Commit | ≥ 80 | **PASS** (94) |
| PR | ≥ 90 | **PASS** (94) |
| **Submission** | ≥ 95 + all components ≥ 80 | **CLOSE** (94 aggregate; all components ≥ 91) |
| Theory binary gates | no critical findings | **PASS** |

## What the round closed

**Two CRITICAL:**
- Empirical step-size hypothesis added at L537 with explicit $\mathcal{E}_n^{\mathrm{LF}}$ event construction.
- `ass:rateconv` strengthened to $L^{2l}$ (for $l \le l_0$, $l_0 \ge 4$) — closes the $L^2$/$L^8$ induction mismatch.

**Seven MAJOR:**
- Dash-range now includes `ass:unifbd`.
- Off-event bookkeeping added at L1086 ($L^4$ moment + Markov).
- $\varphi'_0$ typo fixed.
- Heinz inequality cited for fractional-power telescoping.
- $\hat M$ → $\bar M$ deterministic envelope on $\mathcal{E}_n^{\mathrm{thm}}$.
- $\hat{\mathsf{T}}'^*_{\hat b_j} - \hat{\mathsf{T}}'^*_{b_\dagger}$ identity derived via $\hat{\mathsf{T}}'_b = \hat{\mathsf{A}}_b D$.
- "Similar lower-order term" specified.
- Induction step displayed with pinpoint citation `@centorrinofeveflorens2019 Theorem 3.2, Lemmas A.1–A.3`.

**Three MINOR:**
- `ass:restrvarth(iii)` named explicitly at saturation step.
- `ass:linkcond` singular-value equivalence stated.
- `lem-app3` paired with higher-moment clause.

## Residuals (all below submission floor of 80 per component? No — at 91+)

- **`ass:identif`, `ass:initcond` not pin-cited** inside proof body (still flow through prp-koper/prp-convlf). One-line fix: "Local identification + admissible $b_0$ keep the orbit in $\mathcal{B}_{b_\dagger}$." -4.
- **L1124 lower-order residual** uses $(E\Vert\hat e_j\Vert^{12})^{1/12}$ — requires $l_0 \ge 6$, not $\ge 4$. Either tighten `ass:rateconv` or refactor inequality to stay in $L^8$. -3.
- **L1080 Taylor expansion** of density ratio — needs Hansen 2008 Theorem 6 citation. -3.
- **L1133 tuning constraint** → saturation could use one more line of derivation. -3.
- **L1124** placeholder $(\cdot)^{1/12}$. -2.

Four single-line fixes would lift to ~99/100 and clear submission.

## Trajectory across all audited objects

| Object | Initial | Final | Rounds |
|---|---|---|---|
| `prp-onetoone` | 89 | 99 | 1 |
| `prp-convlf` | 62 | 96 | 7 (1 rollback) |
| `prp-lepskii` | 32 | 69 | 3 (terminal) |
| `prp-koper` | 27 | 97 | 2 |
| **`thm-mainconv`** | **44** | **94** | **1** |

`thm-mainconv` converged in 1 round — the fastest of the medium-complexity proofs — because nearly every fix recapitulated a patch already validated downstream. This validates the audit strategy: dependencies were patched first, and the main theorem inherits the patches.

## Net status

`thm-mainconv` is now at PR quality (94) and within striking distance of submission. The four single-line fixes listed above would clear submission.

## Files

- `quality_reports/notation/notation-table_thm-mainconv_postfix.md` (96)
- `quality_reports/assumptions/usage-matrix_thm-mainconv_postfix.md` (96)
- `quality_reports/regularity/regularity-audit_thm-mainconv_postfix.md` (91)
- `quality_reports/audit/audit-2026-05-15-thm-mainconv-postfix.md` (consolidated)
