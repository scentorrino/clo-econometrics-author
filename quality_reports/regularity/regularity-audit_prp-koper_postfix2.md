# Regularity Audit — `prp-koper` postfix2

**File:** `/Users/samuele/Library/CloudStorage/Dropbox/Nonparametric_IV/Volatility/Centorrino_Florens_VOL_1.qmd`
**Date:** 2026-05-15 (post-fix round 2). Reviewer: regularity-checker agent.
**Trajectory:** 8 → 91 → **97/100** (+6).

## Status of three R1 MINOR residuals

- **R1.1 (Bochner integrability of $t \mapsto \hat{\mathsf T}'_{\hat b_{jt}}$, L1053):** PARTIAL. Asserted with parenthetical justification; one-line pointer to `ass:frediff` for continuity step would fully close it. Standard fact (norm-continuous on compact interval ⇒ Bochner-integrable) but not displayed. **-3.**
- **R1.2 (change-of-variables at L1080, $\hat f_{\hat U_j}/\hat f_U$ ratio):** RESOLVED via explicit "bounded above by $M_1/\kappa_n$ from `ass:unifbd`(i) and `ass:app4` on the event $\mathcal{E}_n$."
- **R1.3 (Taylor expansion of $\hat f_U$):** RESOLVED via the kernel rename + explicit pointer to `ass:app3a` for Lipschitz $\Vert\mathcal{K}'\Vert_\infty$.

## Other items spot-checked (unchanged from R1)

- L1061 uniform consistency: clean.
- L1066 high-probability event $\mathcal{E}_n^{(2)}$: clean.
- L1074 measurability: clean.

## Score

**97 / 100.** Single residual: one-line pointer-to-`ass:frediff` for Bochner-integrability at L1053. Above PR and submission gates.
