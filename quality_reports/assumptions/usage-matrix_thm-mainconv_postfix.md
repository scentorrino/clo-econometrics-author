# Assumption-Usage Matrix — `thm-mainconv` postfix

**File:** `/Users/samuele/Library/CloudStorage/Dropbox/Nonparametric_IV/Volatility/Centorrino_Florens_VOL_1.qmd`
**Date:** 2026-05-15 (post-fix). Reviewer: assumption-auditor agent.
**Trajectory:** 45 → **96/100** (+51).

## Status of prior findings

1. **Dash-range omits `ass:unifbd`:** RESOLVED. L537 now reads "Assumptions \ref{ass:unifbd}-\ref{ass:restrvarth} and \ref{ass:app1}-\ref{ass:app6}."
2. **Off-event $\mathcal{E}_n$ not propagated:** RESOLVED. L537 constructs $\mathcal{E}_n^{\mathrm{LF}}$; L1086 proof preamble defines $\mathcal{E}_n^{\mathrm{thm}} = \mathcal{E}_n^{\mathrm{LF}} \cap \mathcal{E}_n^{\mathrm{koper}}$; off-event bounded by $\sup_j E\Vert\hat e_j\Vert^4 \cdot \mathbb{P}(\mathcal{E}_n^{\mathrm{thm},c})$ via $L^4$ moment + Markov.
3. **`ass:restrvarth` un-named at induction:** RESOLVED. L1133 explicitly cites `\ref{ass:restrvarth}(iii)` as the saturation mechanism for $\beta_\epsilon$.
4. **`ass:identif`, `ass:initcond` weakly used:** PARTIAL. Both still flow through prp-koper/prp-convlf rather than pin-cited inside the `thm-mainconv` proof body. Not blocking. -4.
5. **Induction citation discharge:** RESOLVED. L1129 names "@centorrinofeveflorens2019 [Theorem 3.2, Lemmas A.1–A.3]"; L1133 gives one-step decomposition explicitly + attributes $\beta_\epsilon$-saturation to `ass:restrvarth(iii)`.

## Score

**96 / 100.** Single -4 for `ass:identif`/`ass:initcond` not pin-cited inside the proof body.

## Suggestion

Add a single sentence after L1088: "Local identification (`ass:identif`) and $b_0 \in \mathcal{B}_{b_\dagger}$ (`ass:initcond`) keep the LF orbit $\{\hat b_j\}$ in $\mathcal{B}_{b_\dagger}$ on $\mathcal{E}_n^{\mathrm{thm}}$." One-line fix.
