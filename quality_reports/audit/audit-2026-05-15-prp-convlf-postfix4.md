# Theory Audit — Round 4 post-fix (target: `prp-convlf`)

**Target:** Proposition `prp-convlf` after fourth round of fixes.
**Mode:** AUDIT-IN-PLACE re-audit.

## Summary

| Critic | R1 | R2 | R3 | **R4** | Δ from R3 |
|---|---|---|---|---|---|
| **notation-warden** | 92 | 97 | 98 | **85** | **-13** |
| **assumption-auditor** | 87 | 88 | 96 | **99** | +3 |
| **regularity-checker** | 81 | 76 | 89 | **87** | -2 |

**Aggregate: 90 / 100** (prior 94, **-4 net regression**).

## Critical situation

Round 4 introduced two new issues that net-regressed the score:

1. **Notation regression (-13):** New symbol $U_j$ (partial isometry from polar decomposition at L1041 / L1045) collides with $\hat U_j$ (residual at iterate $j$, used elsewhere in the proof appendix). One-letter rename fixes it.

2. **Regularity regression (-10 MAJOR):** The R-1 patch replaced a citation-only paragraph with an explicit coefficient-level derivation at L1028, which surfaced a previously-hidden gap: the coefficient-wise contraction step requires either commutation of $\mathsf{T}'^*_{b_j}\mathsf{T}'_{b_j}$ with $\mathsf{T}'^*_{b_\dagger}\mathsf{T}'_{b_\dagger}$ OR a Heinz inequality / operator-monotone function calculus argument. eq-lfconv alone gives a Loewner ordering, not coefficient-wise contraction.

This is a familiar pattern: making implicit reasoning explicit can surface gaps that were hidden. Both regressions are addressable with one-line fixes.

## All other prior issues remain closed

- `ass:linkcond` in hypothesis block (Round 3): preserved.
- `ass:unifbd` in hypothesis block (Round 4): just added, working cleanly (+3 on assumption axis).
- Step-size strict, Moore-Penrose convention, radius condition, $D^{-1}$ bridge: all preserved.
- N-3 (polar decomposition domain) at L1041: NEW patch is mathematically correct, but introduces the $U_j$ symbol that collides.
- N-4 (induction at L1049): RESOLVED cleanly.

## Trajectory across four rounds

| Round | notation | assumptions | regularity | aggregate |
|---|---|---|---|---|
| Original | 76 | 76 | 35 | 62 |
| R1 | 92 | 87 | 81 | 87 |
| R2 | 97 | 88 | 76 | 87 |
| R3 | 98 | 96 | 89 | 94 |
| **R4** | **85** | **99** | **87** | **90** |

## Files

- `quality_reports/notation/notation-table_prp-convlf_postfix4.md` (85, regression)
- `quality_reports/assumptions/usage-matrix_prp-convlf_postfix4.md` (99, improved)
- `quality_reports/regularity/regularity-audit_prp-convlf_postfix4.md` (87, regression)
- `quality_reports/audit/audit-2026-05-15-prp-convlf-postfix4.md` (this, consolidated)

## Path to submission gate

Two single-line fixes would restore the score to ~96 and clear submission:

1. **Rename $U_j$ to $V_j$ (or $\mathsf{U}_j$)** at L1045 — eliminates the $U$-with-subscript collision with the structural error and the iterate residual.
2. **Add Heinz inequality or co-diagonalisation invocation** at L1028 — closes the coefficient-level contraction gap.

Expected post-fix: notation 85 → ~98, regularity 87 → ~93, aggregate 90 → ~97.

## Net status

| Gate | Threshold | Verdict |
|---|---|---|
| Commit | ≥ 80 | **PASS** (90) |
| PR | ≥ 90 | **PASS** (90, marginal) |
| Submission | ≥ 95 + all components ≥ 80 | **CLOSE** (aggregate 90 below; notation 85 above floor; both targeted fixes lift past gate) |
| Theory binary gates | no critical findings | **PASS** |
