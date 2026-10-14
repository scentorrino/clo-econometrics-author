# Assumption-Usage Matrix — Proposition `prp-onetoone` (post-fix re-audit)

**File:** `/Users/samuele/Library/CloudStorage/Dropbox/Nonparametric_IV/Volatility/Centorrino_Florens_VOL_1.qmd`
**Date:** 2026-05-15 (post-fix). Reviewer: assumption-auditor agent.
**Prior audit:** 100/100. **New score: 100/100** (unchanged).

## Patch impact verification

| # | Patch | Impact |
|---|---|---|
| 1 | Global typography rename | CONFIRMED NO IMPACT. Cosmetic typeface change. |
| 2 | L174 codomain-norm explication | CONFIRMED NO IMPACT. Norm structure was already declared by operator construction. |
| 3 | L286 inclusion-explication | CONFIRMED NO IMPACT. The inclusion $\mathcal{B}^*_M \subseteq \mathcal{B}_M$ at L281 was already in scope. |
| 4 | L952 route-dispatch fix | CONFIRMED NO IMPACT. Critical check: trailing clause "the argument below uses only the abstract derivative" is dispositive — citations are exhibits, not invoked. No new dependency on `ass:differentiability` for MI inside the prp-onetoone proof body. |
| 5 | L959 parenthetical attribution | CONFIRMED NO IMPACT. $\mathsf{T}(b_\dagger) = 0$ is constitutive of $b_\dagger$ being the true value, not a new assumption. $b^* \in \mathcal{B}_{b_\dagger} \subseteq \mathcal{B}_R$ is set-theoretic from L186/L197. |

## Updated usage matrix (no rows changed status)

Conditions (i)–(iv): all USED, all load-bearing, no change. Primitive assumptions (`ass:differentiability`, `ass:condcomp`, `ass:unifbd`, `def-sourceID`): no change in delivery.

The single clarity-only annotation from the prior audit (implicit $b^* \in \mathcal{B}_R$ at the (iii) invocation) is now retired by Patch 5.

## Findings

- **UNUSED:** None.
- **OVER-STRONG:** None.
- **UNDER-STATED:** None. (Prior clarity-only annotation now explicit.)

## Score

**100 / 100.**

## Verdict

The prior audit was already clean. The five patches improve exposition without enlarging the assumption surface or introducing silent dependencies. Patch 4's caveat "the argument below uses only the abstract derivative" is the load-bearing safeguard: it makes the route-explicit citation at L952 *exhibits* rather than *invocations*. Patch 5 retires the prior clarity-only annotation. The assumption block remains as tight as before.
