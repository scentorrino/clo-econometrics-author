# Theory Audit — 2026-05-15 (post-fix re-audit, target: `prp-onetoone`)

**Target:** Proposition `prp-onetoone` after 5 targeted edits to the .qmd.
**Mode:** AUDIT-IN-PLACE re-audit. Three mechanical critics. No `--counter` / `--derive` flags.

## Summary

| Critic | Prior | Post-fix | Δ |
|---|---|---|---|
| **notation-warden** | 85 / 100 | **97 / 100** | +12 (after adjoint follow-up fix) |
| **assumption-auditor** | 100 / 100 | **100 / 100** | 0 (preserved) |
| **regularity-checker** | 81 / 100 | **100 / 100** | +19 |

**Aggregate: 99 / 100.** Above all gates (commit, PR, submission).

## Critical findings (escalations)

**None.** No confirmed counterexample (not run). No CRITICAL findings on any axis.

## Patch trail

1. **L952 — route-dispatch fix.** Cites \eqref{eq-tmider} (MI) and \eqref{eq-frechet} (FI), flags abstract derivative. Resolves MAJOR (regularity #8).
2. **L959 — parenthetical.** Attributes $\mathsf{T}(b^*) = \mathsf{T}(b_\dagger) = 0$ to its sources; spells out $b^* \in \mathcal{B}_{b_\dagger} \subseteq \mathcal{B}_R$. Resolves MINOR #2 and #3.
3. **L286 — strengthening note.** Makes $\mathcal{B}^*_M \subseteq \mathcal{B}_M$ inclusion explicit. Resolves MEDIUM seam.
4. **L174 — codomain norm + typography convention.** MI product norm spelled out; $\Vert\cdot\Vert$ convention adopted; upright sans-serif convention stated. Resolves HIGH typography dispatch + MINOR norm.
5. **Global typography rename.** 19 sites: `T_{\text{MI}} → \mathsf{T}_{\text{MI}}`, derivative variants, FI typo, adjoint follow-up (caught by re-audit). Resolves HIGH typography.

## Detailed reports

- `quality_reports/notation/notation-table_prp-onetoone_postfix.md`
- `quality_reports/assumptions/usage-matrix_prp-onetoone_postfix.md`
- `quality_reports/regularity/regularity-audit_prp-onetoone_postfix.md`

## Residual items (LOW severity)

- $\chi$ overloading (codomain components vs basis vectors at L142 vs L275) — pre-existing, not introduced by patches.
- L174 sentence density — three declarations in one sentence; cosmetic.
- Codomain of $\mathsf{T}$ in (ii) at L192 still implicit (norm fixed by L174 convention, but symbol not written explicitly in the proposition statement).

None block any gate.

## Net status

| Gate | Threshold | Verdict |
|---|---|---|
| Commit | weighted aggregate ≥ 80 | **PASS** (99) |
| PR | weighted aggregate ≥ 90 | **PASS** (99) |
| Submission | weighted aggregate ≥ 95 + all components ≥ 80 | **PASS** (all components ≥ 97) |
| Theory binary gates (quality.md §3) | no critical findings | **PASS** |

## Next moves

- Compile the .qmd to confirm rendering.
- Optional: address the three residual LOWs (rename $\chi$ in adjoint definition; split L174 sentence; spell out codomain in (ii)) for a perfect 100 on notation.
- The `prp-lepskii` Round-3 findings (in repo artifacts) remain unaddressed; if you want those patched into the .qmd, that's a separate workstream.
