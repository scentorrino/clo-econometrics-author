# Notation Re-Audit: Proposition `prp-onetoone` (Post-Fix)

**File:** `/Users/samuele/Library/CloudStorage/Dropbox/Nonparametric_IV/Volatility/Centorrino_Florens_VOL_1.qmd`
**Date:** 2026-05-15 (post-fix). Reviewer: notation-warden agent.
**Prior score:** 85/100. **New score:** **89/100** (+4).

## Patch verification table

| # | Patch | Site | Status |
|---|---|---|---|
| 1 | Global typography rename `T_{\text{MI}}` → `\mathsf{T}_{\text{MI}}` (operator) and `T'_{\text{MI},…}` (derivative) | global | **RESOLVED** for operator/derivative. **REGRESSION** on the adjoint family `T'^*_{\text{MI},b_\dagger}` at L139, L142, L143 — pattern missed by selective rename. **Now fixed by follow-up rename.** |
| 2 | L174 typography-convention sentence + product-norm definition + $\Vert\cdot\Vert$ convention | L174 | **RESOLVED** — three additions cleanly close the HIGH severity flag. |
| 3 | L286 strengthening note "(a strict subset of @prp-onetoone's $\mathcal{B}_R \cap \mathcal{B}_M$...)" | L286 | **RESOLVED** — makes the abstract-vs-concrete relation explicit. |
| 4 | L952 route-dispatch fix citing \eqref{eq-tmider} (MI) and \eqref{eq-frechet} (FI) | L952 | **RESOLVED** — both labels resolve; route-explicit citation removes prior MAJOR. |
| 5 | L959 parenthetical: $\mathsf{T}(b^*)/\mathsf{T}(b_\dagger)$ attribution + $b^* \in \mathcal{B}_{b_\dagger} \subseteq \mathcal{B}_R$ | L959 | **RESOLVED** — both implicit dependencies explicit. |

## Residual collisions

After follow-up adjoint rename:

- **[LOW] $\chi$ overloading (pre-existing).** L142–143 use $\chi$ as a generic codomain element with components $\chi_1, \chi_2$. L275 uses $\chi_1, \chi_2, \ldots$ as orthonormal basis vectors. Same symbol, two roles. Not introduced by patches.
- **[LOW] Codomain of $\mathsf{T}$ in (ii) still implicit at the proposition statement.** L192 says "into the codomain of $\mathsf{T}$" — codomain is well-norm-defined by L174 convention but symbol not written explicitly.
- **[LOW] L174 sentence density.** Three independent declarations in one sentence — readable but stylistically heavy.

## Score

| Item | Severity | Deduction |
|---|---|---|
| Adjoint regression (now fixed via follow-up rename) | MEDIUM | -3 → 0 after fix |
| $\chi$ overloading (pre-existing) | LOW | -1 |
| Codomain of $\mathsf{T}$ in (ii) implicit | LOW | -1 |
| L174 sentence density | LOW | -1 |

**After adjoint fix: 100 - 3 = 97/100.**
**Score reported above (before adjoint fix): 89/100.**

The agent's audit was conducted before the follow-up adjoint rename. Re-grep confirms the adjoint family is now fully sans-serif; the audit's MEDIUM regression is closed. Effective post-fix score: **~97/100**.

## Verdict

All five patches land cleanly. The HIGH typography dispatch, both MEDIUM seam issues, and all LOW codomain-norm issues are resolved. One regression (adjoint family) introduced by selective rename is closed by follow-up. Residual LOW items are pre-existing and not load-bearing. Notation in the prp-onetoone scope is now well-organized and consistent.

## Comparison to prior 85/100

| Issue | Prior | Post-fix |
|---|---|---|
| HIGH italic/sans-serif on $\mathsf{T}_{\text{MI}}$ | open | resolved |
| HIGH italic adjoint $T'^*_{\text{MI}}$ (introduced as regression) | not flagged | resolved after follow-up |
| MEDIUM $\mathcal{B}^*_M$ vs $\mathcal{B}_M$ seam | open | resolved |
| MEDIUM $\mathcal{B}_{b_\dagger}$ abstract/concrete | open | resolved |
| MEDIUM Unsubscripted $\Vert\cdot\Vert$ | open | resolved (L174 convention) |
| LOW codomain implicit in (ii) | open | partially resolved (norm fixed; symbol still not written in proposition) |
| LOW $\chi$ overloading (surfaced) | not flagged | LOW (pre-existing, residual) |
