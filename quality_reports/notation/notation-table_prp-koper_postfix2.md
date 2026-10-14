# Notation Audit — `prp-koper` postfix2

**File:** `/Users/samuele/Library/CloudStorage/Dropbox/Nonparametric_IV/Volatility/Centorrino_Florens_VOL_1.qmd`
**Date:** 2026-05-15 (post-fix round 2). Reviewer: notation-warden agent.
**Trajectory:** 49 → 75 → **95/100** (+20).

## Verification of three fixes

1. **Univariate kernel rename $K \to \mathcal{K}$ at L1084.** RESOLVED. Explicit "(distinct from the operator $K_{b_\dagger,\hat b_j}$ of this proposition)" disambiguation. Sourced to `ass:app3a`.
2. **$\hat U_j$ defined at first use in L520.** RESOLVED. Inline definition $\hat U_j := e^{\hat\omega_j(X)}Y + \hat g_j(X)$.
3. **$\mathcal{Y}, \mathcal{W}, \mathcal{X}_{\mathrm{tr}}$ defined at L520.** RESOLVED. Trimming domain stated.

## Residual

**MEDIUM (-5):** Operator $K_{b_\dagger,\hat b_j}$ vs Fréchet-derivative kernel $K(b,x,u,w)$ at L969 (different proof section). Context disambiguates (subscripts vs functional argument list), and the two uses are in different proof sections. The originally flagged HIGH (operator vs univariate kernel) is now fixed.

## Score

**95 / 100.** Above PR (≥90) and submission (≥95).
