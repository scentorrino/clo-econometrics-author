# Theory Audit — `thm-mainconv` postfix2 (FINAL)

**Target:** Theorem `thm-mainconv` after two-round fix pass.
**Mode:** AUDIT-IN-PLACE.

## Summary

| Critic | Initial | R1 | **R2 (final)** | Δ from initial |
|---|---|---|---|---|
| **notation-warden** | 86 | 96 | **99** | +13 |
| **assumption-auditor** | 45 | 96 | **100** | **+55** |
| **regularity-checker** | 0 floor (raw -19) | 91 | **100** | **+100+** |

**Aggregate: 100 / 100.** (initial 44, **+56 across two rounds**)

## All gates cleared comfortably

| Gate | Threshold | Verdict |
|---|---|---|
| Commit | ≥ 80 | **PASS** (100) |
| PR | ≥ 90 | **PASS** (100) |
| **Submission** | ≥ 95 + components ≥ 80 | **PASS** (all components ≥ 99) |
| Theory binary gates | no critical findings | **PASS** |

## Final trajectory across all five audited propositions

| Object | Initial | Final | Rounds | Status |
|---|---|---|---|---|
| `prp-onetoone` | 89 | **99** | 1 | ✓ Submission-ready |
| `prp-convlf` | 62 | **96** | 7 (1 rollback) | ✓ Submission-ready |
| `prp-koper` | 27 | **97** | 2 | ✓ Submission-ready |
| **`thm-mainconv`** | **44** | **100** | **2** | **✓ Submission-ready** |
| `prp-lepskii` | 32 | 69 | 3 (terminal) | ✗ Needs structural decision |

**Four of five propositions cleared submission gate.** `prp-lepskii` remains the structural outlier.

## What R2 closed (four single-line fixes)

1. **L1088 bridging sentence** — `ass:identif`/`ass:initcond` pin-cited in proof body, with $\mathcal{E}_n^{\mathrm{thm}}$ orbit-containment via `@prp-convlf`.
2. **L1124 lower-order residual refactor** — $(E\Vert\hat e_j\Vert^8)^{3/8}$ stays within $l_0 \ge 4$ moment range; placeholder $(\cdot)^{1/12}$ eliminated.
3. **L1133 saturation derivation** — three explicit steps from `ass:restrvarth(iii)` to $\beta_\epsilon = \beta \wedge (1-\epsilon)$.
4. **L1080 Hansen 2008 Theorem 6 citation** (in prp-koper proof) — KDE Lipschitz constant explicitly sourced.

## What R1 closed (recap)

**Two CRITICAL:**
- Empirical step-size hypothesis added at L537 with $\mathcal{E}_n^{\mathrm{LF}}$ event.
- `ass:rateconv` extended to $L^{2l}$ ($l_0 \ge 4$) — closes $L^2/L^8$ mismatch.

**Seven MAJOR + three MINOR:**
- Dash-range fix, off-event bookkeeping, $\varphi' \to b'$ typo, Heinz inequality, $\hat M \to \bar M$ envelope, $\hat{\mathsf{T}}'^*_{\hat b_j}$ identity, lower-order term spec, induction step display, `ass:restrvarth(iii)` cited, `ass:linkcond` equivalence stated, `lem-app3` paired.

## Pattern: audit strategy validated

`thm-mainconv` converged in **2 rounds** — the fastest of all the medium-complexity proofs — because nearly every fix recapitulated patches already validated on dependencies:
- Empirical step-size → `prp-convlf` R7
- $L^8$ moment broadening → `prp-koper` R1 broadening
- Dash-range fix → `prp-koper` R1
- Hilbert-scale invariance → `prp-convlf` R7
- Off-event $\mathcal{E}_n$ → `prp-lepskii` R1

The bottom-up audit strategy worked: fix dependencies first, then the main theorem inherits the patches with minimal additional work.

## Files

- `quality_reports/notation/notation-table_thm-mainconv_postfix2.md` (99)
- `quality_reports/assumptions/usage-matrix_thm-mainconv_postfix2.md` (100)
- `quality_reports/regularity/regularity-audit_thm-mainconv_postfix2.md` (100)
- `quality_reports/audit/audit-2026-05-15-thm-mainconv-postfix2.md` (consolidated)

## Net status — paper-level

| Proposition | Final | Status |
|---|---|---|
| `prp-onetoone` | 99 | Submission-ready |
| `prp-condcomp` | (not audited) | — |
| `prp-convlf` | 96 | Submission-ready |
| `prp-koper` | 97 | Submission-ready |
| `thm-mainconv` | 100 | Submission-ready (perfect) |
| `cor-rates` | (not audited) | — |
| `lem-itervar` | (not audited) | — |
| `prp-lepskii` | 69 | Structural outlier (R5 escalation pending) |

**Four propositions at submission quality, one outlier.** The outlier's status reflects a real structural issue (source-condition preservation under non-co-diagonalisable operators) that requires an author-level decision among:
- Option B: weaken `prp-lepskii` conclusion to norm-only convergence.
- Option C: add a co-diagonalisation assumption.
