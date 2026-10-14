# Notation Audit — Proposition `prp-koper`

**File:** `/Users/samuele/Library/CloudStorage/Dropbox/Nonparametric_IV/Volatility/Centorrino_Florens_VOL_1.qmd`
**Scope:** Statement L519–530; Proof L1051–1085
**Date:** 2026-05-15. Reviewer: notation-warden agent.

## Score: 49 / 100

## Critical findings

**HIGH (-15): $M_n$ critical collision.** Used with two incompatible meanings IN THE SAME DOWNSTREAM PROOF:
- L1061 (prp-koper proof): $M_n$ = "sufficiently large uniform-consistency constant" (random, from Dunker 2018 Lemma 4)
- L582, L604, L606, L615, L1158, L1167, L1171, L1179, L1187, L1191, L1195, L1210 (prp-lepskii proof): $M_n$ = maximum iteration index in the Lepskii rule

The prp-lepskii proof at L1167 invokes `prp-koper(a)` and uses $\hat M$ (which is built from the Dunker $M_n$) while also using $M_n$ as the iteration cap. The collision is unresolvable from context.

**HIGH (-15): $M$ overloaded.** Statement at L529 fixes $M = M_2 M_3$; proof at L1084 says "$M$ is the uniform bound in Assumption `unifbd`" (which contains $M_1$, $M_2$, $M_3$ — ambiguous). $M$ also denotes the source-condition constant at L286/L1045, and $M_{\text{lf}}$ is yet another $M$.

## MINOR/MEDIUM findings

- $\bar b_{jt}(x; u)$ at L1059 — never defined (likely typo for $\hat b_{jt}$).
- $\hat M$ at L521 declared with "almost surely" but $\hat M$ contains random $M_n$. Same as MN6 from prp-lepskii audit.
- Family of KDEs ($\hat f_{Y,X|W}$, $\hat f_{Y,X}$, etc.) used without explicit definitions.
- $b \cdot Y$ shorthand at L1080 — unusual dot notation for $g(X) + e^{\omega(X)}Y$.
- $\hat U_j$ dual role (variable + measure-label subscript).

## Score breakdown

| Item | Severity | Deduction |
|---|---|---|
| $M_n$ collision (Dunker vs Lepskii cap) | HIGH | -15 |
| $M$ overloaded | HIGH | -15 |
| $\bar b_{jt}$ undefined | -5 | -5 |
| $\hat M$ "a.s." inconsistency with random $M_n$ | -5 | -5 |
| KDE family undefined | -5 | -5 |
| $b \cdot Y$ unusual dot | -2 | -2 |
| $\hat U_j$ dual role | -2 | -2 |
| $\xi_j$ dense parsing | -2 | -2 |

**Score: 49 / 100.**

## Verdict

prp-koper is functionally readable but the notation is fragile in two consequential ways. First, $M_n$ has two unrelated meanings in the same downstream proof — Dunker's random uniform-consistency constant absorbed via prp-koper(a), and the Lepskii iteration cap. Second, the $M$-family is overloaded across the document. Both collisions should be renamed (e.g., $M_n^{\text{Dunker}}$ or $C_{\text{D}}$ for the Dunker constant; $M^\dagger$ or $M_{23}$ for the prp-koper(b) constant).
