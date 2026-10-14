# Theory Audit — 2026-05-15 (target: `prp-condcomp`)

**Target:** Proposition `prp-condcomp` (concrete identification result specializing prp-onetoone).
**Source:** `/Users/samuele/Library/CloudStorage/Dropbox/Nonparametric_IV/Volatility/Centorrino_Florens_VOL_1.qmd` (statement L285–287; proof L998–1016).
**Mode:** AUDIT-IN-PLACE.

## Summary

| Critic | Score | Findings |
|---|---|---|
| **notation-warden** | **88 / 100** | 1 scope-coverage gap (-12) |
| **assumption-auditor** | **85 / 100** | 1 unstated/incomplete MI variant (-15) |
| **regularity-checker** | **67 / 100** | 1 CRITICAL + 1 MAJOR + 1 MINOR |

**Aggregate: 80 / 100.** Just at commit gate.

## Single dominant finding (flagged by all three critics)

**MI vs FI completeness gap.** The proposition statement at L286 reads "Let either condition \eqref{eq-mi} or \eqref{eq-fi} hold ... under the corresponding variant of Assumption \ref{ass:condcomp}." The proof's Case 1 at L1002–1006 invokes only FI's machinery:
- FI Fréchet kernel form $-f_U(u)\{\mathsf{D}_h(u,w) + u\mathsf{D}_\omega(u,w)\}$ from \eqref{eq-fider-bdagger}.
- FI side conditions $E[\tilde h] = E[\tilde\omega] = 0$ "inherited from \eqref{eq-fi}'s normalizations."

The MI variant of `ass:condcomp` has no side conditions; the location/scale null directions are excluded by `eq-mi`'s two conditional moments directly (per the discussion at L148). The proof does not make this MI argument.

**Fix:** Either (a) add a one-paragraph parallel Case 1 for MI explicitly invoking \eqref{eq-tmider-bdagger} and the no-side-conditions claim of L148; or (b) restrict the proposition to FI only.

## Secondary findings

**MAJOR (regularity, -10):** L1004 silently uses $f_U > 0$ a.e. to translate "$\mathsf{T}'_{b_\dagger}\tilde b = 0$ a.s." to "conditional-expectation identity in `ass:condcomp`." Positivity is not in the proposition's hypothesis range (`ass:differentiability`-`ass:unifbd`). The closest condition is `ass:app4`, in the asymptotic block. **Fix:** add a hypothesis or remark.

**MINOR (regularity, -3):** L1014 Cauchy-Schwarz strictness — clarify $\tilde b \neq 0$ provides the strict $<$.

## Detailed reports

- `quality_reports/notation/notation-table_prp-condcomp.md` (88)
- `quality_reports/assumptions/usage-matrix_prp-condcomp.md` (85)
- `quality_reports/regularity/regularity-audit_prp-condcomp.md` (67)

## Pattern

`prp-condcomp` audits cleaner than the deeper asymptotic results — it's a short identification proof (16 lines). The CRITICAL is a real scope issue, not a regularity gap; both can be closed in a focused one-round fix.

## All seven audited objects

| Object | Final | Rounds |
|---|---|---|
| `prp-onetoone` | 99 | 1 |
| **`prp-condcomp`** (this) | **80** | **0 (initial)** |
| `prp-convlf` | 96 | 7 (1 rollback) |
| `prp-koper` | 97 | 2 |
| `thm-mainconv` | 100 | 2 |
| `prp-lepskii` | 69 | 3 (terminal) |

## Net status

| Gate | Threshold | Verdict |
|---|---|---|
| Commit | ≥ 80 | **PASS** (80, marginal) |
| PR | ≥ 90 | **BLOCKED** (regularity 67 below floor) |
| Submission | ≥ 95 + all components ≥ 80 | **BLOCKED** (regularity 67 below floor) |
| Theory binary gates | no critical findings | **BLOCKED** (1 CRITICAL) |

## Path forward

Two focused fixes would lift to ~95:

1. **MI parallel argument** at L1006 (one paragraph or a "(FI) / (MI)" labeling). Closes the dominant finding across all three critics. +12 notation, +15 assumptions, +20 regularity = aggregate +16.
2. **Positivity of $f_U$** clarification at L1004 (one line citing existing condition). +10 regularity = aggregate +3.

Expected post-fix: ~96/100, clearing submission gate.

Want me to apply the fixes?
