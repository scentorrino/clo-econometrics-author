# Assumption-Usage Matrix — Proposition `prp-condcomp`

**File:** `/Users/samuele/Library/CloudStorage/Dropbox/Nonparametric_IV/Volatility/Centorrino_Florens_VOL_1.qmd`
**Statement:** L285–287; **Proof:** L998–1016.
**Date:** 2026-05-15. Reviewer: assumption-auditor agent.

## Score: 85 / 100

## Section 1: Usage matrix

| Assumption / Object | Used in proof at | Strength |
|---|---|---|
| \eqref{eq-mi} or \eqref{eq-fi} | L1000 ($\mathsf{T}(b^*) = 0$ defines $b^*$) | Full |
| `ass:differentiability` (L246) | L1002 (kernel form of $\mathsf{T}'_{b_\dagger}$) | Full — implicit via "computation preceding `ass:condcomp`" |
| `ass:unifbd` (L259) | L1010 ($\Vert\mathsf{T}'_{b_\dagger}\tilde b\Vert \le M\Vert\tilde b\Vert^2$) | Full |
| `ass:condcomp` FI variant (L219–225) | L1006 ("side conditions $E[\tilde h] = E[\tilde\omega] = 0$ inherited from \eqref{eq-fi}") | Full |
| `ass:condcomp` MI variant (L213–217) | — | **NOT INVOKED** |
| `def-sourceID` (L273–279) | L1012–1014 (Cauchy-Schwarz on spectral basis) | Full |

## Findings

### -15: MI variant not actually proved (incomplete coverage)

The proposition's statement uses conditional language "under the *corresponding* variant of `ass:condcomp`." In the proof body (L1002–1006), only the FI variant is deployed. The MI variant — which has no side conditions but instead uses two conditional moments — is asserted in the hypothesis block but never closed in the proof.

**Fix:** Either (a) add a one-paragraph MI case invoking the MI variant on $E[\psi(U, X) \mid W] = 0$ and $E[U\psi(U, X) \mid W] = 0$, which under \eqref{eq-mi} excludes the location/scale null directions per L148; or (b) restrict the proposition to FI only and demote MI to a remark.

## Verdict

The proof is tight for the FI route. The MI route remains the single substantive gap.
