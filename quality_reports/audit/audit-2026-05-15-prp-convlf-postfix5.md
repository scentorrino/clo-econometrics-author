# Theory Audit — Round 5 post-fix (target: `prp-convlf`)

**Target:** Proposition `prp-convlf` after fifth round of fixes.
**Mode:** AUDIT-IN-PLACE re-audit.

## Summary

| Critic | R3 | R4 | **R5** | Δ from R4 |
|---|---|---|---|---|
| **notation-warden** | 98 | 85 | **85** | 0 |
| **assumption-auditor** | 96 | 99 | **99** | 0 |
| **regularity-checker** | 89 | 87 | **92** | +5 |

**Aggregate: 92 / 100** (R4 was 90, **+2 net**).

## Mixed result

- **Heinz inequality fix worked (regularity +5).** R-1 downgraded from MAJOR (-10) to MINOR/PARTIAL (-5). Citation to @engl2000 Lemma 2.21 gives the reader enough to reconstruct the correct argument.

- **$U_j \to V_j$ rename traded one collision for another (notation unchanged).** The new $V_j$ collides with:
  - $V$ at L322 (Gaussian r.v. in FI representation)
  - $V$ at L81 (symmetric noise in stochastic frontier)
  - $V(m)$ at L592+ (variance proxy in Lepskii rule)

The disambiguation note at L1045 enumerates $U$ conflicts but is silent on $V$ conflicts.

## Trajectory across five rounds

| Round | notation | assumptions | regularity | aggregate |
|---|---|---|---|---|
| Original | 76 | 76 | 35 | 62 |
| R1 | 92 | 87 | 81 | 87 |
| R2 | 97 | 88 | 76 | 87 |
| R3 | 98 | 96 | 89 | 94 |
| R4 | 85 | 99 | 87 | 90 |
| **R5** | **85** | **99** | **92** | **92** |

Net trajectory: 62 → 92 across five rounds (+30 points).

## Two remaining issues

### 1. Notation: $V_j$ collision (HIGH, -15)

**Fix:** rename $V_j \to \Pi_j$ at L1045 (single occurrence). $\Pi$ is unused in the paper. Lifts notation 85 → ~98.

### 2. Regularity: "approximately diagonalises" parenthetical (MINOR, -5)

The Heinz fix is correct in object (Loewner ordering) but the parenthetical claims the link condition delivers spectral-subspace interlacing — which it does not. Loewner bounds control quadratic forms, not eigenvectors.

**Fix (route c):** rewrite the step to use a global Loewner bound on $(I - c\mathsf{A}^*_{b_j}\mathsf{A}_{b_j})$ — by functional calculus, $A \le M_{\text{lf}}^{-1} B$ implies $I - cM_{\text{lf}}^{-1}B \le I - cA$, so the quadratic form contracts uniformly without invoking a common basis. Lifts regularity 92 → ~95.

## Path to submission gate

Two single-line/short-paragraph fixes:
1. $V_j \to \Pi_j$ rename at L1045.
2. Rewrite L1028 spectral-interlacing claim with global Loewner argument.

Expected post-Round-6: notation ~98, regularity ~95, assumptions 99, aggregate ~97. Clears submission gate (≥95).

## Files

- `quality_reports/notation/notation-table_prp-convlf_postfix5.md` (85, $V_j$ collision)
- `quality_reports/assumptions/usage-matrix_prp-convlf_postfix5.md` (99, stable)
- `quality_reports/regularity/regularity-audit_prp-convlf_postfix5.md` (92, +5)
- `quality_reports/audit/audit-2026-05-15-prp-convlf-postfix5.md` (this, consolidated)

## Net status

| Gate | Threshold | Verdict |
|---|---|---|
| Commit | ≥ 80 | **PASS** (92) |
| PR | ≥ 90 | **PASS** (92) |
| Submission | ≥ 95 + all components ≥ 80 | **CLOSE** (aggregate 92; notation at 85 above floor; two targeted fixes lift past gate) |
| Theory binary gates | no critical findings | **PASS** |
