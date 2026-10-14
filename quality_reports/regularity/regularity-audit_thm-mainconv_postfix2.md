# Regularity Audit — `thm-mainconv` postfix2

**File:** `/Users/samuele/Library/CloudStorage/Dropbox/Nonparametric_IV/Volatility/Centorrino_Florens_VOL_1.qmd`
**Date:** 2026-05-15 (post-fix round 2). Reviewer: regularity-checker agent.
**Trajectory:** 0 (floor; raw -19) → 91 → **100/100** (+9).

## All three MINORs RESOLVED

**L1124 lower-order residual moment exponent** — RESOLVED. Patched text decomposes $\hat{\mathsf{T}}(\hat b_j) - \mathsf{T}(b_\dagger)$ via prp-koper(a), bounds residual piece by Cauchy-Schwarz at $L^8$ yielding $(E\Vert\hat e_j\Vert^8)^{3/8}$ — strictly within $l_0 \ge 4$ moment class. Absorption into leading term justified via `ass:restrvarth(ii)–(iii)` and the induction bounds on $E\Vert\hat e_j\Vert^2$.

**L1080 KDE Lipschitz constant** — RESOLVED. `@hansen2008 Theorem 6` citation added with explicit "delivers both pointwise consistency and a Lipschitz constant for the kernel density via differentiation of the kernel." Lipschitz constant then derived in plain view at L1082.

**L1133 tuning constraint → saturation derivation** — RESOLVED. Three explicit steps: (1) Term-IV bias is $N^{1-\beta/2}\cdot h_u^{-2}\kappa_n^{-1}$; (2) multiply by $N^{-\epsilon/2}\cdot N^{\epsilon/2}$ and apply `ass:restrvarth(iii)` to invert into $N^{1-(\beta-\epsilon)/2}$; (3) balance against $N^{-\beta/2}$ to obtain $N^{-\beta_\epsilon/2}$.

## New regularity issues

None. Patches strictly tighten earlier hand-waved steps without introducing new conditions.

## Score

**100 / 100.** No outstanding findings.
