# Regularity Audit — Proof of Theorem `thm-mainconv`

**File:** `/Users/samuele/Library/CloudStorage/Dropbox/Nonparametric_IV/Volatility/Centorrino_Florens_VOL_1.qmd`
**Statement:** L536–544; **Proof:** L1086–1126.
**Date:** 2026-05-15. Reviewer: regularity-checker agent.

## Score: 0 / 100 (floor; raw -19)

## Two CRITICAL findings

### CRITICAL 1 (L1090): Empirical step-size hypothesis missing
The bound $\Vert(I - c\hat{\mathsf{T}}'^*_{b_\dagger}\hat{\mathsf{T}}'_{b_\dagger})^N\Vert$ requires $c\Vert\hat{\mathsf{T}}'^*_{b_\dagger}\hat{\mathsf{T}}'_{b_\dagger}\Vert \le 1$ on a high-probability event. Same fix R7 imposed on `prp-convlf`. Hypotheses of `thm-mainconv` don't include the empirical step-size condition. **Without it, `lem-app3`'s premise $c\Vert\hat T^*\hat T\Vert\le 1$ is not satisfied.** **Fix:** state on $\mathcal{E}_n$ via `prp-convlf` hypothesis + `ass:rateconv`.

### CRITICAL 2 (L1110): $L^2$ vs $L^8$ induction inconsistency
The induction hypothesis at L1122–1124 is stated as $E\Vert\hat e_j\Vert^2 = O(\cdot)$ (in $L^2$), but Term III's Cauchy-Schwarz at L1110 needs $E\Vert\hat e_j\Vert^8 = O(\cdot)$ (in $L^8$). These are inconsistent unless an additional argument equates the rates. Same as M6 from prp-lepskii audit. **Fix:** state induction hypothesis at $L^{2l}$ for $l = 4$, OR cite the precise lemma in centorrinofeveflorens2019 that promotes $L^2$ to higher moments.

## Seven MAJOR findings

| # | Site | Issue |
|---|---|---|
| 1 | L1099 | Mixed $L^2$/$L^4$ inequality with unstated higher-moment requirement on $\hat b_0 - b_0$ (currently only $L^2$ from `ass:initcond`). |
| 2 | L1101 | Telescoping over operator fractional powers $(\cdot)^{\beta/2}$ — needs Heinz inequality + `ass:rateconv` extended to all even moments. |
| 3 | L1105 | Term II uses 4th moment of $\hat{\mathsf{T}}(b_\dagger) - \mathsf{T}(b_\dagger)$; `ass:rateconv` only states 2nd moment. |
| 4 | L1108 | $\hat M$ random, outside expectation — same as notation flag. |
| 5 | L1115 | Equality $\Vert\hat{\mathsf{T}}'^*_{\hat b_j} - \hat{\mathsf{T}}'^*_{b_\dagger}\Vert = \Vert\hat{\mathsf{T}}'^*_{b_\dagger}(K - I)\Vert$ transfers from $\hat{\mathsf{A}}^*$ via $\hat{\mathsf{T}}'_b = \hat{\mathsf{A}}_b D$ — should be displayed. |
| 6 | L1119 | "$+$ similar lower-order term" unspecified. |
| 7 | L1122 | Induction step "following the scheme of centorrinofeveflorens2019" not displayed. Same as MAJOR carryover from prp-lepskii. |

## Three MINOR findings

- L1097: $\varphi'_0 - \varphi'_\dagger$ typo for $b'_0 - b'_\dagger$.
- L1126: `ass:linkcond` cited but not invoked in detail.
- `lem-app3` requires `ass:rateconv` at all moments — should be stated.

## Verdict

`thm-mainconv` is the most heavily-loaded proof in the paper: short body, heavy reliance on `prp-koper` + `lem-app1`-`lem-app3` + the cited centorrinofeveflorens2019 induction scheme. The proof is plausible under the standard four-term-decomposition + induction package, but five separate regularity invocations are silent: empirical step-size, $L^p$ extension of `ass:rateconv`, $\hat M$ event-localization, $\Vert\hat{\mathsf{T}}'^*_{\hat b_j} - \hat{\mathsf{T}}'^*_{b_\dagger}\Vert$ derivation, off-event bookkeeping. The two CRITICAL items recur from earlier audits (the empirical step-size from `prp-convlf`; the $L^8$/$L^2$ moment mismatch from `prp-lepskii` MN6 fix). Both have known standard remedies.
