# Theory Audit — 2026-05-15 (target: `prp-convlf`)

**Target:** Proposition `prp-convlf` (convergence of deterministic Landweber-Fridman iteration).
**Source:** `/Users/samuele/Library/CloudStorage/Dropbox/Nonparametric_IV/Volatility/Centorrino_Florens_VOL_1.qmd` (statement L439–446, proof L1022–1050).
**Mode:** AUDIT-IN-PLACE. Three mechanical critics. No `--counter` / `--derive` flags.

## Summary

| Critic | Score | Findings |
|---|---|---|
| **notation-warden** | **76 / 100** | 1 HIGH, 3 MEDIUM, 4 LOW, 3 used-but-undefined |
| **assumption-auditor** | **76 / 100** | 0 UNUSED, 0 OVER-STRONG, **3 UNDER-STATED** |
| **regularity-checker** | **35 / 100** | **2 CRITICAL**, 2 MAJOR, 6 MINOR |

Aggregate: **62 / 100** — below commit gate. **2 CRITICAL findings block the binary submission gate.**

## Critical findings (escalations)

Both flagged independently by regularity-checker and assumption-auditor.

**CRITICAL 1: Step-size threshold $c\|\mathsf{A}^*_b\mathsf{A}_b\| \le 1$ silently invoked at L1034.**

The square-completion identity at L1034 reads $-c\|(I - c\mathsf{A}_{b_j}\mathsf{A}^*_{b_j})^{1/2}\mathsf{T}(b_j)\|^2$. For $(I - c\mathsf{A}\mathsf{A}^*)^{1/2}$ to exist as a bounded self-adjoint operator, we need $c\|\mathsf{A}^*_b\mathsf{A}_b\| \le 1$ uniformly on $\mathcal{B}_{b_\dagger}$. This condition is mentioned at L401 as a practical implementation point ("any sufficiently small $c$ guarantees convergence"), but **it is absent from the proposition's hypothesis block at L440** (which lists only `ass:identif`, `ass:initcond`, eq-lfconv). Without this threshold, the entire monotonicity argument collapses.

**Fix:** Add to proposition statement: "Suppose $c < (\sup_{b \in \mathcal{B}_{b_\dagger}}\|\mathsf{A}^*_b\mathsf{A}_b\|)^{-1}$." (Or use the deterministic bound from L401–405.)

**CRITICAL 2: Unbounded inverse Gram operator at L1041.**

The proof inserts $(\mathsf{T}'^*_{b_j}\mathsf{T}'_{b_j})^{-1/2}(\mathsf{T}'^*_{b_j}\mathsf{T}'_{b_j})^{1/2}$ as an "identity." Since $\mathsf{T}'_{b_j}$ is compact (Hilbert-Schmidt, shown at L992–996), the Gram operator has 0 in its spectrum and $(\mathsf{T}'^*_{b_j}\mathsf{T}'_{b_j})^{-1/2}$ is unbounded on $L^2_X \times L^2_X$. The "identity" is only valid on $\text{Ran}((\mathsf{T}'^*_{b_j}\mathsf{T}'_{b_j})^{1/2})$ — a dense proper subspace. The proof needs $b_j - b_\dagger$ to lie in this range at every iterate — a source condition at $b_j$, not $b_\dagger$.

**Fix:** Either state the range condition explicitly, or fold it into eq-lfconv by noting the condition already presupposes $(\mathsf{T}'^*_{b_j}\mathsf{T}'_{b_j})^{-1}$ to be a bounded operator on the relevant subspace.

## Detailed reports

- `quality_reports/notation/notation-table_prp-convlf.md`
- `quality_reports/assumptions/usage-matrix_prp-convlf.md`
- `quality_reports/regularity/regularity-audit_prp-convlf.md`

## Action items (consolidated, prioritized)

### CRITICAL — block submission gate
- [ ] **L440 / proposition hypothesis block:** add step-size threshold $c\|\mathsf{A}^*_b\mathsf{A}_b\| \le 1$ uniformly on $\mathcal{B}_{b_\dagger}$ (CRITICAL 1).
- [ ] **L442 (`eq-lfconv`) or new sentence after:** make explicit that $(\mathsf{T}'^*_{b_j}\mathsf{T}'_{b_j})^{-1}$ is the pseudo-inverse on the relevant range, or state the range condition directly (CRITICAL 2).

### MAJOR — block PR gate
- [ ] **L1037 chain:** replace "as in the proof of prp-onetoone" with explicit citation to mean-value at L965–967 + Lipschitz at L982–984 + `def-sourceID`. The constant-1 form needs the source condition to convert $M\|b-b_\dagger\|^2$ into $\|\mathsf{T}'_{b_\dagger}(b-b_\dagger)\|$.
- [ ] **Metric mismatch at L1028:** bridge $b'$-monotonicity to $b_j \in \mathcal{B}_{b_\dagger}$. Either state preservation of $\mathcal{B}_{b_\dagger}$ explicitly, or shrink initial ball by $\|D^{-1}\|$.

### MEDIUM — improve exposition
- [ ] **L1050:** re-source "injectivity of $\mathsf{T}'_{b_j}$" to eq-lfconv (which already presupposes invertibility), not to `ass:condcomp` (which gives injectivity at $b_\dagger$ only).
- [ ] **L456:** $A_a \to \mathsf{A}_a$ — fix italic/sans-serif typo.
- [ ] **L1034:** introduce $I$ explicitly as identity on the codomain.
- [ ] **$M_4$ vs $m_4$:** rename to distinguish; e.g., $M_4 \to M_{\text{lf}}$.

### MINOR — cosmetic
- [ ] L1047–1048: line-break inside $\Vert b'_j - b'_\dagger\Vert^2$ — join into one line.
- [ ] L1032–1033: subscript the inner products by their Hilbert space.
- [ ] L1042: cite Engl-Hanke-Neubauer Lemma 2.5 for the operator-norm step.
- [ ] $M_4 = 1$ boundary: add one line on sublinear convergence via Fejér monotonicity.

## Net status

| Gate | Threshold | Verdict |
|---|---|---|
| Commit | weighted aggregate ≥ 80 | **BLOCKED** (62/100) |
| Theory binary gates (quality.md §3) | no critical findings | **BLOCKED** (2 CRITICAL) |

## Pattern across audited propositions

| Proposition | Notation | Assumption | Regularity | Aggregate |
|---|---|---|---|---|
| `prp-onetoone` (post-fix) | 97 | 100 | 100 | **99** |
| `prp-convlf` | 76 | 76 | 35 | **62** |
| `prp-lepskii` (Round 3) | — | — | — | **69** (theorist-critic) |

The pattern is clear: short abstract propositions like `prp-onetoone` are clean; medium-complexity convergence proofs like `prp-convlf` carry silent regularity that needs explicit treatment; long asymptotic-statistics proofs like `prp-lepskii` accumulate the most issues.

## Recommended next moves

1. **Two CRITICAL fixes are mechanical** — both are one-line additions to the hypothesis block. They can be done directly on the .qmd in under five minutes.
2. **Two MAJOR fixes** require minor proof rewrites (L1037 chain + metric bridge at L1028). Each is a one-paragraph addition.
3. **MEDIUMs** are renaming + clarifications.
4. **Optional `/audit --counter #prp-convlf`** would probe at boundary cases (e.g., $M_4 = 1$, $c\|\mathsf{A}\mathsf{A}^*\| = 1$, degenerate $\mathsf{T}'_{b_j}$). Given the load-bearing role of `eq-lfconv`, counterexample-hunter might find genuine probes.

The proof's overall logic is sound under the standard LF iteration regularity package; the proposition just isn't fully closed against its named hypotheses. Same pattern as `prp-onetoone` before the recent fixes — addressable with targeted edits.
