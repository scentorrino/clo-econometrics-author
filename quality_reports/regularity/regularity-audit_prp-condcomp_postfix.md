# Regularity Audit — `prp-condcomp` postfix

**File:** `/Users/samuele/Library/CloudStorage/Dropbox/Nonparametric_IV/Volatility/Centorrino_Florens_VOL_1.qmd`
**Date:** 2026-05-15 (post-fix). Reviewer: regularity-checker agent.
**Trajectory:** 67 → **94/100** (+27).

## Both CRITICAL and MAJOR RESOLVED

- **CRITICAL (MI vs FI completeness):** RESOLVED. L1004–1012 split Case 1 into FI variant (using $\mathsf{T}'_{\text{FI}, b_\dagger}$ and FI side conditions) and MI variant (using $\mathsf{T}'_{\text{MI}, b_\dagger}$ via \eqref{eq-tmider-bdagger}, with null-direction exclusion via \eqref{eq-mi}'s moments). Conclusion "In either route, $b^* = b_\dagger$" at L1012.

- **MAJOR ($f_U > 0$):** RESOLVED. L1008 explicitly states "$f_U(u) > 0$ a.e. on $\mathrm{supp}(U)$" with citation to `ass:differentiability` + standing positive-density assumption; `ass:app4` noted as quantitative-floor counterpart.

## Two remaining MINORs (-3 each)

- **L1010 conditional-variance cite:** Uses $E[U^2 \mid W] = 1$ via $\mathrm{Var}(U \mid W) = 1$. Cleaner to cite both moments ($E[U \mid W] = 0$ + $\mathrm{Var}(U \mid W) = 1$) jointly.
- **L1014 Cauchy-Schwarz strictness:** Carryover from prior audit. Strict $<$ justified by `def-sourceID`'s strict bound; one-line clarification would help.

## Score

**94 / 100.**

The FI/MI case split with explicit citations to `ass:differentiability`, standing positive-density assumption, and the null-direction exclusion leaves no silent regularity invocations in Case 1. No new structural regularity gaps introduced.
