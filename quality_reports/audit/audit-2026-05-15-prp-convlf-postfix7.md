# Theory Audit — Round 7 rollback (target: `prp-convlf`)

**Target:** Proposition `prp-convlf` after R6 rollback to R5 wording.
**Mode:** AUDIT-IN-PLACE re-audit.

## Summary

| Critic | R3 (peak) | R5 | R6 (regression) | **R7 (rollback)** |
|---|---|---|---|---|
| **notation-warden** | 98 | 85 | 98 | **98** |
| **assumption-auditor** | 96 | 99 | 100 | **99** |
| **regularity-checker** | 89 | 92 | 40 | **92** |

**Aggregate: 96 / 100.** (Up from 79 in R6, up from 94 in R3 peak.) **PASSES SUBMISSION GATE (≥ 95).**

## Final state

Rollback successful. The R6 CRITICAL errors (wrong $D^{-1}$ conjugation; false shared-eigenbasis from singular-value equivalence) are both gone. The R6 wins are preserved:
- **$\Pi_j$ rename** at L1045 (notation +13 retained).
- **`ass:unifbd` in hypothesis block** at L440 (assumptions stable at 99).
- **Heinz inequality citation** at L1028 framing the step in Loewner ordering (regularity +5 over R4).

## Trajectory across seven rounds

| Round | notation | assumptions | regularity | aggregate |
|---|---|---|---|---|
| Original | 76 | 76 | 35 | 62 |
| R1 | 92 | 87 | 81 | 87 |
| R2 | 97 | 88 | 76 | 87 |
| R3 | 98 | 96 | 89 | 94 |
| R4 | 85 | 99 | 87 | 90 |
| R5 | 85 | 99 | 92 | 92 |
| R6 | 98 | 100 | 40 | 79 |
| **R7** | **98** | **99** | **92** | **96** |

Net: **62 → 96 (+34)** across seven rounds.

## Net status

| Gate | Threshold | Verdict |
|---|---|---|
| Commit | ≥ 80 | **PASS** (96) |
| PR | ≥ 90 | **PASS** (96) |
| Submission | ≥ 95 + all components ≥ 80 | **PASS** (96 aggregate; notation 98, assumptions 99, regularity 92 — all above floor) |
| Theory binary gates | no critical findings | **PASS** |

## Comparison across audited propositions

| Proposition | Final aggregate | Rounds | Notes |
|---|---|---|---|
| `prp-onetoone` (post-fix) | **99 / 100** | 1 round | Short abstract proposition |
| `prp-convlf` (post-fix R7) | **96 / 100** | 7 rounds (1 rollback) | Medium-complexity convergence proof |
| `prp-lepskii` (Round 3 terminal) | 69 / 100 | 3 strikes — terminal | Long asymptotic-statistics proof, unresolved |

## Residual issues (acceptable for submission)

- **MAJOR PARTIAL R-1 (-5):** L1028 "approximately diagonalises ... interlace" hand-wavy. Heinz inequality citation provides reader enough to reconstruct correct argument; full derivation would need a Weyl-Horn-Birman-Solomyak-style lemma for self-adjoint compact operators under Loewner sandwich. Acceptable for submission as PARTIAL.
- **MINOR (-3):** Source-condition tail boundedness silent (compactness of $\mathsf{T}'_{b_\dagger}$ from `ass:unifbd` delivers it; just not cited at the step).
- Stylistic phrasing residuals: "automatically delivered" wording at L1039.

## Lessons learned

1. **Making implicit reasoning explicit can surface real mathematical gaps.** R4–R6 exposed gaps that the R3 citation hid.
2. **In iterative regularisation for nonlinear inverse problems, source-condition preservation across iterates is genuinely hard.** It requires either co-diagonalisability (Engl-Hanke-Neubauer §8.4 construction) or a Weyl-type perturbation argument. The R5/R7 hand-wavy form is the cleanest position without changing the structural setup.
3. **A rollback is a legitimate move** when a "fix" introduces worse mathematical errors than what it replaces. R5's PARTIAL is honest; R6's two CRITICALs were not.

## Files

- `quality_reports/notation/notation-table_prp-convlf_postfix7.md`
- `quality_reports/assumptions/usage-matrix_prp-convlf_postfix7.md`
- `quality_reports/regularity/regularity-audit_prp-convlf_postfix7.md`
- `quality_reports/audit/audit-2026-05-15-prp-convlf-postfix7.md` (this)

## Recommendation

**STOP.** `prp-convlf` is now at submission quality (96/100, all components ≥ 92). Further iteration risks reintroducing errors. The PARTIAL R-1 is a known limitation acceptable for publication. The author may choose to invest a focused theorist pass on the Weyl-Horn-Birman-Solomyak-style lemma if they want to push to 99, but it is not necessary for submission.
