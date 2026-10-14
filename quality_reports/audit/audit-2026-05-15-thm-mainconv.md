# Theory Audit — 2026-05-15 (target: `thm-mainconv`)

**Target:** Theorem `thm-mainconv` — main convergence bound for the LF estimator.
**Source:** `/Users/samuele/Library/CloudStorage/Dropbox/Nonparametric_IV/Volatility/Centorrino_Florens_VOL_1.qmd` (statement L536–544; proof L1086–1126).
**Mode:** AUDIT-IN-PLACE.

## Summary

| Critic | Score | Findings |
|---|---|---|
| **notation-warden** | **86 / 100** | 1 typo, 1 $\hat M$ event-localization, 3 conventions |
| **assumption-auditor** | **45 / 100** | Dash-range gap, off-event handling, `ass:restrvarth` un-named, induction citation discharge |
| **regularity-checker** | **0 / 100** (floor; raw -19) | **2 CRITICAL**, 7 MAJOR, 3 MINOR |

**Aggregate: 44 / 100.** BLOCKED at all gates.

## Two CRITICAL findings

**1. Empirical step-size hypothesis missing (L1090).** Same as the CRITICAL fixed in `prp-convlf` R7. The contraction $(I - c\hat{\mathsf{T}}'^*_{b_\dagger}\hat{\mathsf{T}}'_{b_\dagger})^N$ requires $c\Vert\hat{\mathsf{T}}'^*_{b_\dagger}\hat{\mathsf{T}}'_{b_\dagger}\Vert \le 1$ on a high-probability event. Not in `thm-mainconv` hypotheses. Standard remedy: cite `prp-convlf`'s hypothesis + `ass:rateconv` to transfer from population to empirical.

**2. $L^2$ vs $L^8$ induction inconsistency (L1110 vs L1122).** Induction stated in $L^2$, but Term III's Cauchy-Schwarz needs $L^8$. Same as M6 from `prp-lepskii` audit. Standard remedy: extend `ass:rateconv` to all even moments OR cite a specific moment-promotion lemma.

## Pattern

`thm-mainconv` recapitulates the same gaps already found and patched in `prp-convlf` and `prp-koper`:
- Empirical step-size hypothesis missing → `prp-convlf` CRITICAL 1 (fixed R7).
- $L^2 \leftrightarrow L^8$ moment inconsistency → `prp-lepskii` M6 + `prp-koper` need for `ass:rateconv` higher moments.
- Off-event $\mathcal{E}_n^c$ bookkeeping missing → `prp-lepskii` R-1.
- Dash-range omits `ass:unifbd` → `prp-koper` initial audit.
- Induction citation discharge → `prp-lepskii` R3 R-1 (Hilbert-scale invariance).

The structural fixes that worked for the dependencies apply verbatim here.

## Pattern across all audited propositions

| Proposition | Initial | Final | Rounds |
|---|---|---|---|
| `prp-onetoone` | 89 | 99 | 1 |
| `prp-convlf` | 62 | 96 | 7 (1 rollback) |
| `prp-lepskii` | 32 | 69 | 3 (terminal) |
| `prp-koper` | 27 | 97 | 2 |
| **`thm-mainconv` (this)** | **44** | — | **0 (initial)** |

`thm-mainconv` at 44 is in the same league as the harder propositions at initial. Trajectory likely similar to `prp-convlf` (62 → 96 in 7 rounds) or `prp-koper` (27 → 97 in 2 rounds), since most fixes are recapitulations of patches already made and tested.

## Action items (priority order)

### CRITICAL
- [ ] **L1090 / hypothesis block** — add empirical step-size condition (transfer from `prp-convlf`).
- [ ] **L1110 / induction** — strengthen `ass:rateconv` to higher moments + state induction hypothesis at $L^8$.

### MAJOR
- [ ] **Dash-range** at L537 — include `ass:unifbd`.
- [ ] **Off-event bookkeeping** — propagate $\mathcal{E}_n$ from `prp-koper` to the unconditional $E\Vert\hat e_N\Vert^2$ conclusion.
- [ ] **L1097 typo** — $\varphi'_0 \to b'_0$ etc.
- [ ] **L1101 telescoping** — Heinz inequality justification for operator fractional powers.
- [ ] **L1105 Term II** — extend `ass:rateconv` to $L^4$ moment of $\hat{\mathsf{T}}(b_\dagger) - \mathsf{T}(b_\dagger)$.
- [ ] **L1108 $\hat M$** — localize on $\mathcal{E}_n$ explicitly.
- [ ] **L1115** — display the $\hat{\mathsf{T}}'^*_{\hat b_j} - \hat{\mathsf{T}}'^*_{b_\dagger}$ derivation via $\hat{\mathsf{T}}'_b = \hat{\mathsf{A}}_b D$.
- [ ] **L1119** — specify "similar lower-order term."
- [ ] **L1122** — display induction step or pinpoint cite.

### MINOR
- [ ] **L1126** — cite `ass:linkcond` exponent adjustment in detail.
- [ ] **`lem-app3` higher moments** — extend `ass:rateconv` (one-line addition).

## Files

- `quality_reports/notation/notation-table_thm-mainconv.md` (86)
- `quality_reports/assumptions/usage-matrix_thm-mainconv.md` (45)
- `quality_reports/regularity/regularity-audit_thm-mainconv.md` (0 floor)
- `quality_reports/audit/audit-2026-05-15-thm-mainconv.md` (consolidated)

## Net status

| Gate | Threshold | Verdict |
|---|---|---|
| Commit | ≥ 80 | **BLOCKED** (44) |
| Theory binary gates (quality.md §3) | no critical findings | **BLOCKED** (2 CRITICAL) |

## Recommendation

This is a focused recapitulation pass: most fixes are patches already validated on earlier propositions (`prp-convlf`, `prp-koper`, `prp-lepskii`). A single round addressing the 2 CRITICAL items + 4 MAJOR items would lift aggregate to ~85; a second round on the rest would clear submission. Want me to apply these fixes?
