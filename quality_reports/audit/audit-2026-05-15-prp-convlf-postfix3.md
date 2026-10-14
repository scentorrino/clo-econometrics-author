# Theory Audit — Round 3 post-fix (target: `prp-convlf`)

**Target:** Proposition `prp-convlf` after a third round of fixes.
**Mode:** AUDIT-IN-PLACE re-audit.

## Summary

| Critic | Original | Round 1 fix | Round 2 fix | Round 3 fix | Total Δ |
|---|---|---|---|---|---|
| **notation-warden** | 76 | 92 | 97 | **98** | +22 |
| **assumption-auditor** | 76 | 87 | 88 | **96** | +20 |
| **regularity-checker** | 35 | 81 | 76 | **89** | +54 |

**Aggregate: 94 / 100** (prior 87, +7). **PASSES PR gate (≥90).** One point shy of submission gate (≥95).

## All four CRITICALs and most MAJORs closed across three rounds

**Round 1 closed:**
- Silent step-size threshold (CRITICAL) → explicit hypothesis at L440
- Unbounded inverse Gram (CRITICAL) → Moore-Penrose convention at L440
- L1037 telegraphic pointer (MAJOR) → explicit chain at L1039
- L1028 metric mismatch (MAJOR) → $D^{-1}$ bridge

**Round 2 closed:**
- L1039 absorbed constant unnamed (MEDIUM) → constant $(c_1/M)^2$ named, radius condition $c_1 R^2 \le M$ stated
- L1049 silent strict step-size strengthening (MEDIUM) → hypothesis tightened to strict $<1$
- L1049 $\mathsf{A}\mathsf{A}^*$ vs $\mathsf{A}^*\mathsf{A}$ silent norm equivalence (MINOR) → parenthetical added
- Fejér without citation (MINOR) → `@engl2000` §2.6
- $I$ identity not introduced (MINOR) → defined at L440

**Round 3 closed:**
- N-1 `ass:linkcond` invoked but not in hypothesis (MAJOR, -10) → added to hypothesis block at L440
- N-2 `ass:sourcecond` / $\mathcal{B}^*_M$ silently in scope (MINOR, -3) → added to hypothesis block
- Radius condition surfaced from proof body to hypothesis block

## Residual issues (all addressable but not addressed)

### MAJOR (regularity, -5)
- **R-1: Hilbert-scale invariance derivation.** L1028 invariance argument cites @engl2000 §8.4 + @florens2012 Lemma 3.1 without exhibiting the coefficient-level computation. Hypothesis block now contains the right ingredients; derivation step is the residual.

### MINOR (regularity, -3 each)
- **N-3:** Pseudo-inverse half-power domain at L1041 — needs half-line via polar decomposition or @engl2000 §2.2.
- **N-4:** Sup over $\mathcal{B}_{b_\dagger}$ at iterate at L1049 — inductive logic implicit, one-sentence fix.

### MINOR (assumption, -2 each)
- **`ass:unifbd` not in hypothesis list** — invoked via $c_1$ kernel-difference constant, but the assumption itself isn't named. One-token fix.
- Radius "automatically delivered" residual phrasing.

### MINOR (notation, -2 advisory)
- $c_1$ pre-existing collision between Hermite coefficient at L318 and kernel-difference constant elsewhere.

## Detailed reports

- `quality_reports/notation/notation-table_prp-convlf_postfix3.md` (98/100)
- `quality_reports/assumptions/usage-matrix_prp-convlf_postfix3.md` (96/100)
- `quality_reports/regularity/regularity-audit_prp-convlf_postfix3.md` (89/100)

## Net status

| Gate | Threshold | Verdict |
|---|---|---|
| Commit | ≥ 80 | **PASS** (94) |
| PR | ≥ 90 | **PASS** (94) |
| Submission | ≥ 95 + all components ≥ 80 | **CLOSE** (94 aggregate; regularity at 89, needs +6 via R-1 to clear) |
| Theory binary gates (quality.md §3) | no critical findings | **PASS** |

## Three-round trajectory comparison

| Proposition | Final aggregate | Final rounds |
|---|---|---|
| `prp-onetoone` (post-fix) | **99 / 100** | 1 round |
| `prp-convlf` (post-fix round 3) | **94 / 100** | 3 rounds |
| `prp-lepskii` (Round 3 terminal) | 69 / 100 | 3 strikes — terminal |

The pattern: short abstract propositions clean in 1 round; medium-complexity convergence proofs converge in 3 rounds; long asymptotic-statistics proofs need structural rewrites.

## Suggested next moves

To clear the submission gate (≥95 with all components ≥80):

1. **Close R-1 (regularity)** — one paragraph at L1028 exhibiting the coefficient-level Hilbert-scale preservation. Citing @engl2000 §8.4 isn't quite enough — write the four-line argument: (a) `ass:linkcond` gives norm equivalence between $(\mathsf{T}'^*_{b_\dagger}\mathsf{T}'_{b_\dagger})^{s/(2a)}$ and $D^{-s}$; (b) `eq-lfconv` gives the same equivalence at iterate $b_j$ up to constant $M_{\text{lf}}$; (c) source-class membership $\mathcal{B}^*_M$ is preserved under the LF update because the update operator commutes with the Hilbert-scale projection up to $O(c)$. Lift: regularity 89 → 94, aggregate 94 → 96.

2. **Add `ass:unifbd` to hypothesis list at L440** — one token. Lift: assumption 96 → 98.

3. **Optional MINOR fixes:** N-3 pseudo-inverse domain note + N-4 induction sentence at L1049. Lift: regularity 89 → 95.

Expected post-pass aggregate: ~97/100, clearing submission gate.

Want me to do those three fixes too?
