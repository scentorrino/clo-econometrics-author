# Regularity Re-Audit — Proposition `prp-onetoone` (post-fix)

**File:** `/Users/samuele/Library/CloudStorage/Dropbox/Nonparametric_IV/Volatility/Centorrino_Florens_VOL_1.qmd`
**Date:** 2026-05-15 (post-fix). Reviewer: regularity-checker agent.
**Prior:** 81/100. **Post-fix: 100/100** (+19).

## Patch verification

1. **L952 — Patch 1.** Now reads: "Condition (i) supplies a bounded linear Fréchet derivative $\mathsf{T}'_{b_\dagger}$ at $b_\dagger$, given concretely by \eqref{eq-tmider} under \eqref{eq-mi} and by \eqref{eq-frechet} under \eqref{eq-fi}; the argument below uses only the abstract derivative." Route dispatch explicit; proof flagged as route-agnostic.
2. **L959 — Patch 2.** Both parentheticals present.
3. **L174 — Patch 3.** MI product-norm definition and route-agnostic $\Vert\cdot\Vert$ convention inline.

## Updated 9-concern table

| # | Concern | Severity | Prior verdict | Post-fix verdict |
|---|---|---|---|---|
| 1 | Existence of explicit Fréchet kernel form when (i) invoked | MINOR | Captured weakly | **RESOLVED** — both kernel forms now cited |
| 2 | $\mathsf{T}(b_\dagger) = 0$ attribution | MINOR | Captured implicitly | **FULLY CAPTURED** — explicit parenthetical |
| 3 | $b^* \in \mathcal{B}_R$ licensing (iii) | MINOR | Gap | **RESOLVED** — explicit $b^* \in \mathcal{B}_{b_\dagger} \subseteq \mathcal{B}_R$ |
| 4 | Last inequality $< 1$ | n/a | Captured | Still captured |
| 5 | Codomain norm route-dependent | MINOR | Gap | **RESOLVED** — L174 convention |
| 6 | Measurability of $\Vert \mathsf{T}(b)\Vert$ | n/a | Captured | Still captured |
| 7 | Case-split exhaustiveness | n/a | Captured | Still captured |
| 8 | Silent route dispatch via \eqref{eq-frechet} | MAJOR | Gap | **RESOLVED** — L952 route-symmetric |
| 9 | Conclusion phrasing | n/a | Captured | Still captured |

## New regularity probes against the patches

- **Probe A — L952 phrasing introduces new condition?** No. "Bounded linear Fréchet derivative" is what (i) supplies by definition.
- **Probe B — L959 parenthetical introduces new condition?** No. Both facts (defining property of $b_\dagger$ via \eqref{eq-mi}/\eqref{eq-fi}; $b^* \in \mathcal{B}_R$ via L186/L197) are pre-existing.
- **Probe C — L174 introduces new measurability/integrability?** No. Hilbert direct-sum norm is canonical; components were already $L^2_W$ by construction of $\mathsf{T}_{\text{MI}}$.
- **Probe D — abstracting the derivative weakens anything?** No. Proof uses linearity (Fréchet ⇒ linear), codomain norm, injectivity, quadratic remainder, and source condition — each supported.

## Score

| Item | Severity | Deduction |
|---|---|---|
| All prior items | RESOLVED | 0 |
| Probes A–D | new | 0 |

**Score: 100 / 100.**

## Verdict

All five flagged concerns are cleanly resolved by the three targeted patches, and none of the patches introduces new silent regularity. Patch 1 (L952) converts the proof from kernel-specific to route-agnostic, neutralizing both concern #8 (MAJOR) and concern #1 (MINOR) in a single move. Patch 2 (L959) surfaces what a careful reader would otherwise reconstruct from L139/L162 and from $\mathcal{B}_{b_\dagger} \subseteq \mathcal{B}_R$. Patch 3 (L174) resolves the codomain-norm route-dependence and quietly supports concern #6 at the setup level. The proof is now self-contained at the regularity layer.

**Comparison to prior 81/100: +19.** Recovery complete.
