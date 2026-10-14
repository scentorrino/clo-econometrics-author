# Theory Audit — Round 6 post-fix (target: `prp-convlf`)

**Target:** Proposition `prp-convlf` after sixth round of fixes.
**Mode:** AUDIT-IN-PLACE re-audit.

## Summary — major regression on regularity axis

| Critic | R5 | **R6** | Δ |
|---|---|---|---|
| **notation-warden** | 85 | **98** | **+13** |
| **assumption-auditor** | 99 | **100** | +1 |
| **regularity-checker** | 92 | **40** | **−52** |

**Aggregate: 79 / 100** (R5 was 92, **-13 net**).

## What worked (Round 6)

- **$V_j \to \Pi_j$ rename:** clean. $\Pi$ has zero collisions. Notation 85 → 98.
- **Assumption block:** 100/100 — first round at perfect. All hypotheses load-bearing, none over-strong, none under-stated.

## What failed catastrophically (Round 6)

The Route (c) rewrite at L1028 introduced **two CRITICAL mathematical errors**:

### CRITICAL 1 — Wrong conjugation formula

I wrote $\mathsf{A}^*_{b_j}\mathsf{A}_{b_j} = D^{-1}\mathsf{T}'^*_{b_j}\mathsf{T}'_{b_j} D^{-1}$, treating $D^{-1}$ as self-adjoint. But $D^{-1}$ is a one-sided Volterra integration operator $(D^{-1}b')(x) = \int_{-\infty}^{x_1} \cdots d\xi$ — its adjoint is integration over $[x_1, +\infty)$, not the same operator. Volterra integration is quasinilpotent, not self-adjoint.

The correct formula: $\mathsf{A}^*_{b_j}\mathsf{A}_{b_j} = (D^{-1})^*\,\mathsf{T}'^*_{b_j}\mathsf{T}'_{b_j}\,D^{-1}$.

### CRITICAL 2 — Singular-value equivalence ≠ shared eigenbasis

I claimed "the eigenbasis $\{\chi_l\}$ of $\mathsf{T}'^*_{b_\dagger}\mathsf{T}'_{b_\dagger}$ ... by `ass:linkcond`'s norm equivalence ... is also an eigenbasis of $\mathsf{A}^*_{b_\dagger}\mathsf{A}_{b_\dagger}$."

This is false. `ass:linkcond` is a *singular-value* equivalence between $(\mathsf{T}'^*_{b_\dagger}\mathsf{T}'_{b_\dagger})^{1/(2a)}$ and $D^{-1}$. Two operators with the same singular values can have entirely different singular vectors. The shared-eigenbasis claim would need either commutation or a stronger structural condition.

This is the same class of error I made in Round 5 ("approximately diagonalises") and was supposed to fix in Round 6. The Route (c) "global Loewner argument" idea was sound; my execution was not. The Loewner inequality gives a *total-norm* contraction; converting it to a source-condition tail $\sum_l c_l^2/t_l^2$ contraction requires the shared-eigenbasis input I incorrectly claimed `ass:linkcond` provides.

## Trajectory across six rounds

| Round | notation | assumptions | regularity | aggregate |
|---|---|---|---|---|
| Original | 76 | 76 | 35 | 62 |
| R1 | 92 | 87 | 81 | 87 |
| R2 | 97 | 88 | 76 | 87 |
| R3 | 98 | 96 | 89 | 94 (peak) |
| R4 | 85 | 99 | 87 | 90 |
| R5 | 85 | 99 | 92 | 92 |
| **R6** | **98** | **100** | **40** | **79** |

## Honest assessment

Source-condition preservation across iterates in iterative regularisation for nonlinear inverse problems is a genuinely hard analysis problem. The "Hilbert-scale invariance" argument in @engl2000 §8.4 and @florens2012 Lemma 3.1 works because those settings either (a) have a co-diagonalisable forward operator and regulariser, or (b) target a different conclusion (norm contraction rather than smoothness-class preservation).

I have iterated three times on this step (R3 citation-only → R4 explicit-derivation-with-hidden-gap → R5 Heinz-but-still-eigenbasis-claim → R6 Loewner-but-wrong-conjugation-and-still-eigenbasis-claim) and each time the conclusion has been the same: the desired source-condition tail preservation does not follow from the hypotheses currently in the block. R3 hid this by citing rather than deriving; R5 partially exposed it; R6 fully exposed it.

## Three options for the user

### Option A (RECOMMENDED): Roll back to R5

The R5 form was the best-scoring version with this approach (aggregate 92, with PARTIAL R-1 -5). Keep the $\Pi_j$ rename (clean +13 on notation). Revert the L1028 wording back to R5's "approximately diagonalises ... interlace ... up to a multiplicative factor controlled by $M_{\text{lf}}$" — which was hand-wavy but not mathematically wrong. Expected aggregate: ~95 (notation 98 + assumptions 99 + regularity 92).

### Option B: Weaken the conclusion at L1028

Instead of claiming preservation of $\mathcal{B}^*_M$ (source-condition class) across iterates, claim only preservation of the norm ball $\mathcal{B}_R$. This is what the Loewner inequality genuinely delivers via $\|b'_{j+1} - b'_\dagger\| \le \rho\|b'_j - b'_\dagger\|$ for some $\rho \in (0, 1)$. The proof of `prp-convlf` then concludes convergence in norm; source-condition preservation across iterates becomes a separate question deferred to the rate-of-convergence section. **Substantive scope reduction** but mathematically honest.

### Option C: Add a "co-diagonalisation" assumption

Explicitly assume that $\mathsf{T}'^*_{b_\dagger}\mathsf{T}'_{b_\dagger}$ and $D^{-1}$ are simultaneously diagonalisable. This is a strong structural assumption — but exactly the structural assumption Engl-Hanke-Neubauer §8.4 uses (their Hilbert-scale construction defines the scale via $D$, so the forward operator's spectrum is by construction in the same basis). With this assumption added, the R6 argument works as written.

## Files

- `quality_reports/notation/notation-table_prp-convlf_postfix6.md` (98)
- `quality_reports/assumptions/usage-matrix_prp-convlf_postfix6.md` (100)
- `quality_reports/regularity/regularity-audit_prp-convlf_postfix6.md` (40)
- `quality_reports/audit/audit-2026-05-15-prp-convlf-postfix6.md` (this)

## My recommendation

**Option A.** Roll back to R5's wording. The R5 PARTIAL flag is honest (citation gives reader enough to reconstruct the right argument, parenthetical is hand-wavy). The R6 attempt to fully derive the step caught two real mathematical errors that I had been hiding behind the citation. Trying again here without changing structural assumptions will continue to hit the same wall.

The author may want to revisit the entire $\mathcal{B}^*_M$-preservation step as a separate concern outside `prp-convlf` — perhaps as a remark deferred to the rate section where `ass:linkcond` is genuinely load-bearing.
