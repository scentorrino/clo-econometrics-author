# Notation Audit — Proposition `prp-condcomp`

**File:** `/Users/samuele/Library/CloudStorage/Dropbox/Nonparametric_IV/Volatility/Centorrino_Florens_VOL_1.qmd`
**Scope:** Statement L285–287; Proof L998–1016.
**Date:** 2026-05-15. Reviewer: notation-warden agent.

## Score: 88 / 100

## Findings

### -12: MI vs FI scope-coverage gap at L1006

The proposition statement (L286) is route-agnostic ("either condition \eqref{eq-mi} or \eqref{eq-fi}"). Proof Case 1 (L1002–1006) uses route-agnostic $\mathsf{T}'_{b_\dagger}$ but invokes only FI normalizations: "under the side conditions $E[\tilde h] = E[\tilde\omega] = 0$ inherited from the normalizations $E(U) = 0$ and $\mathrm{Var}(U) = 1$ in \eqref{eq-fi}."

The MI variant of `ass:condcomp` (L213–217) carries no side conditions; under MI, the location/scale null directions are excluded by `eq-mi`'s two conditional moments directly (per L148). This argument is not made.

**Fix:** Either (a) label cases explicitly "(FI variant) / (MI variant)" with a one-line MI parallel referring to L148; or (b) rewrite as "under the side conditions of `ass:condcomp` (vacuous in MI variant; $E[\tilde h] = E[\tilde\omega] = 0$ in FI variant inherited from \eqref{eq-fi}'s normalizations)."

### Verifications

- $\mathsf{D}_h, \mathsf{D}_\omega$ defined at L168.
- $\tilde h = \tilde g - g_\dagger\tilde\omega$ matches L121.
- $\chi_j, t_j, c_j, \mathcal{B}^*_M$ from `def-sourceID` at L273–277.
- Sans-serif $\mathsf{T}, \mathsf{T}'_{b_\dagger}$ consistent throughout L1000–1016.
- $\mathcal{B}^*_M \subsetneq \mathcal{B}_M$ strengthening parenthetical at L286 clean.

### No new collisions

$M$ overload (with $M_1, M_2, M_3, M_{\mathrm{lf}}, M_n, M_X, M_{23}$, etc.) is pre-existing project-wide; all disambiguated by subscript or accent.

## Verdict

The proof is notationally clean within the FI route. The route-agnostic claim of the proposition is not matched by the proof's symbolic coverage — Case 1 needs a parallel MI line.
