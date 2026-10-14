# Regularity Audit — Lemma `lem-itervar`

**File:** `/Users/samuele/Library/CloudStorage/Dropbox/Nonparametric_IV/Volatility/Centorrino_Florens_VOL_1.qmd`
**Scope:** L591-595 (statement) + L1154-1199 (proof).
**Date:** 2026-05-17. Reviewer: regularity-checker.

## Score: 21/100

## Findings

**CRITICAL (-20):**
1. L1158, L1174 — Empirical-operator spectral filter applied to $\hat{\mathsf{T}}'^*_{b_\dagger}\hat{\mathsf{T}}'_{b_\dagger}$ without the step-size event. `prp-convlf` supplies the population bound only; the proof never imports the empirical event.

**MAJOR (-10 each):**
2. L1187 — Range membership $\hat b_0 - b_0 \in \mathrm{Ran}((\mathsf{T}'^*\mathsf{T}')^{1/2})$ for source-condition representation: silently invoked.
3. L1174 — $\Vert\hat{\mathsf{T}}'^*_{b_\dagger}\Vert$ boundedness not justified in this proof (`thm-mainconv` L1129 does, `lem-itervar` doesn't).
4. L1185 — Term $III_m$'s Cauchy-Schwarz at $L^8$ + deterministic envelope $\bar M$ on $\hat M$ imported silently from `thm-mainconv` L1119-L1123.
5. L1184-1187 — Off-event bookkeeping for $I_a$ missing relative to `thm-mainconv` L1112.
6. L1187 — Subtracting the random $I_a$ to define variance proxy informal; statement is unconditional moment bound, proof is event-conditional.

**MINOR (-3 each):**
7. L1189 — Induction's $(j+1)^{-\beta}$ term silently uses `ass:sourcecond` + `ass:app6` + orbit preservation.
8. L1199 — "Operator-agnostic" glosses MI spectral/compactness conditions.
9. L1181 — $\kappa_n^{-1}$ factor implicitly needs `ass:app4` / $\mathcal{E}_n^{\mathrm{koper}}$.

## Unifying remedy

All five MAJORs (#1-#5) plus the CRITICAL collapse to one missing preamble paragraph. `thm-mainconv` does the work at L1094-1098; `lem-itervar` inherits the same machinery but its proof never says so.

Single paragraph at L1156 ("We work throughout on $\mathcal{E}_n^{\mathrm{thm}} \cap \mathcal{E}_n^{\mathrm{pilot}}$ ...") recovers ~50 points.

Projected post-fix: ~92/100.
