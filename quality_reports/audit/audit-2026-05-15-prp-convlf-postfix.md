# Theory Audit — 2026-05-15 (post-fix, target: `prp-convlf`)

**Target:** Proposition `prp-convlf` after 7 targeted edits to the .qmd.
**Mode:** AUDIT-IN-PLACE re-audit. Three mechanical critics.

## Summary

| Critic | Prior | Post-fix | Δ |
|---|---|---|---|
| **notation-warden** | 76 / 100 | **92 / 100** | +16 |
| **assumption-auditor** | 76 / 100 | **87 / 100** | +11 |
| **regularity-checker** | 35 / 100 | **81 / 100** | **+46** |

**Aggregate: 87 / 100** (prior 62, +25). **PASSES commit gate.** One paragraph short of PR gate.

## Critical findings

**None.** Both prior CRITICALs are closed:
- Silent step-size threshold → explicit hypothesis at L440.
- Unbounded inverse Gram → Moore-Penrose convention + range condition at L440.

## Patch trail (7 edits)

1. **L440 — proposition hypothesis block.** Added step-size $c\sup_b\Vert\mathsf{A}^*_b\mathsf{A}_b\Vert \le 1$ (with deterministic bound reference). Added Moore-Penrose convention for $(\mathsf{T}'^*_{b_j}\mathsf{T}'_{b_j})^{-1}$ on $\text{Ran}(\mathsf{T}'^*_{b_j})$. Added range condition $b_j - b_\dagger \in \text{Ran}((\mathsf{T}'^*_{b_j}\mathsf{T}'_{b_j})^{1/2})$.
2. **L1028 — metric bridge.** $b_j - b_\dagger = D^{-1}(b'_j - b'_\dagger)$, $\Vert D^{-1}\Vert \le |\mathcal{X}_1|/\sqrt 2$, source condition preserved.
3. **L1039 — explicit L1037 chain.** Mean-value theorem + kernel-difference bound from sec-annexA2 + source-condition control via def-sourceID and prp-condcomp.
4. **L1043, L1048 — $M_4 \to M_{\text{lf}}$ rename.** Disambiguates from $m_4$.
5. **L1047-1048 — line-break typo fixed.**
6. **L1049 — re-source injectivity to eq-lfconv + $M_{\text{lf}}=1$ boundary discussion.**
7. **L456 — $A_a \to \mathsf{A}_a$ typography fix.**

## Detailed reports

- `quality_reports/notation/notation-table_prp-convlf_postfix.md`
- `quality_reports/assumptions/usage-matrix_prp-convlf_postfix.md`
- `quality_reports/regularity/regularity-audit_prp-convlf_postfix.md`

## Residual issues (all addressable in one more pass)

### MAJOR (-10, one item)
- **R-1 (regularity).** L1028 asserts that $\mathcal{B}^*_M$ is preserved across iterates via Hilbert-scale invariance. Argument verbal, depends on `ass:linkcond` and eq-lfconv. **Fix:** one explicit paragraph naming `ass:linkcond` and citing Engl-Hanke-Neubauer §8.4.

### MEDIUM (-5 each, two items)
- **R-2 (assumption-auditor).** L1037 constant-1 form requires unstated radius bound on $\mathcal{B}_{b_\dagger}$ ($CR^2 \le M$ where $C = c_1$ from L984).
- **R-3 (assumption-auditor).** L1049 strict-positivity argument silently strengthens step-size from $\le 1$ to $< 1$. Either tighten hypothesis or split boundary case.

### MINOR (cosmetic)
- R-1 also flagged at -3 in assumption matrix.
- $\mathsf{A}\mathsf{A}^*$ vs $\mathsf{A}^*\mathsf{A}$ norm equivalence not cited at L1049.
- Absorbed constant in L1039 not named.
- Fejér monotonicity invoked without citation.
- $I$ (identity operator) not introduced at L1034.

## Net status

| Gate | Threshold | Verdict |
|---|---|---|
| Commit | weighted aggregate ≥ 80 | **PASS** (87) |
| PR | weighted aggregate ≥ 90 | **CLOSE** (87) — one paragraph away |
| Submission | aggregate ≥ 95 + all components ≥ 80 | **CLOSE** (regularity 81, assumptions 87, notation 92 — all ≥ 80) |
| Theory binary gates (quality.md §3) | no critical findings | **PASS** |

## Pattern across the four audited propositions

| Proposition | Prior aggregate | Post-fix aggregate |
|---|---|---|
| `prp-onetoone` (post-fix) | 89 (then-prior) | **99** |
| `prp-convlf` (post-fix) | 62 (prior) | **87** |
| `prp-lepskii` (Round 3) | — | 69 (3-strikes terminal) |

Pattern: short abstract propositions are cleanest; medium-complexity convergence proofs respond well to targeted fixes (62 → 87 = +25); long asymptotic-statistics proofs accumulate the most structural issues even after three rounds of revision.

## Recommended next moves

1. **One MAJOR fix** at L1028 — add a paragraph displaying the Hilbert-scale invariance of $\mathcal{B}^*_M$, naming `ass:linkcond`. Would lift regularity-checker to ~91.
2. **Two MEDIUM fixes** at L1039 and L1049 — name the constant, switch hypothesis to strict $<1$ or split. Would lift assumption-auditor to ~95.
3. After those: clean MINORs ($\mathsf{A}\mathsf{A}^*$ vs $\mathsf{A}^*\mathsf{A}$, Fejér citation, $I$ introduction, $T_{\text{FI}}$ typo at L661) — cosmetic; would lift notation-warden to ~98.

Expected post-pass aggregate: ~94/100, clearing PR gate. Submission gate requires further work on `prp-lepskii` (the Round-3 residual issues remain in repo artifacts, not in the .qmd).
