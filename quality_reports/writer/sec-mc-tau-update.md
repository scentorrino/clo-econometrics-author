# `sec-mc-tau` Update — Theory-Driven Reframe

**Date:** 2026-05-20
**File:** `/Users/samuele/Library/CloudStorage/Dropbox/Nonparametric_IV/Volatility/Centorrino_Florens_VOL_1.qmd`
**Section:** `sec-mc-tau` (Sensitivity to the Lepskii constant $\tau$)
**Trigger:** Theorist refinement of `prp-lepskii` introduced the data-driven choice $\tau_n^*(h) := \sqrt{2 \log M_n / (c_K\, n h^d)} \vee \tau_0$ and a new `rem:tau-bandwidth` that prints the $n=500$ numerical prediction.

## What changed

Two paragraphs in `sec-mc-tau` were rewritten. No theory, no equations, no figures, and no other subsection was touched.

### Paragraph 1 (intro to @fig-mc-tau, prior L845)

**Before.** Treated $\tau \in [3, 6]$ as the operative recommendation and noted that the default $\tau = 4$ is too conservative for the present DGP — framed as an empirical finding to be diagnosed by the sweep.

**After.** Names the Mathé-Pereverzev band as the *constant-$\tau$* asymptotic anchor, points the reader to the refined data-driven choice $\tau_n^*(h)$ from the new `rem:tau-bandwidth`, and frames the sweep as the finite-sample probe of that refined formula rather than as a diagnosis of anomaly.

### Paragraph 2 (post-figure interpretation, prior L857)

**Before.** Recommended "$\tau \approx 2$ for MI/sin-sin sims, $\tau = 4$ for applications", treating the empirical pattern as an isolated calibration finding and deferring the budget interaction to future work.

**After.** Reframes the empirical pattern as *consistent with* the bandwidth-explicit prediction $\tau_n^*(h) \approx 0.22\,\sqrt{2/c_K}$ at $n = 500$, with the qualifier that $c_K$ is the kernel-Bernstein constant (order unity under \ref{ass:app1}-\ref{ass:app2}, cite @gine2002). Notes that the empirical optimum at $\tau \in \{1, 2\}$ lies above $\tau_n^*(h)$ by the margin supplied by the constant floor $\tau_0$ — i.e., the floor is doing its asymptotic-safeguard job exactly as the proposition states. Replaces the "$\tau \approx 2$" recommendation with $\tau_n^*(h) \vee \tau_0$, and rescopes the constant $\tau = 4$ as the asymptotic-conservative default for the application sections, appropriate when $h$ and $c_K$ are unknown. Keeps the $c_K$ qualifier explicit (heavier-tailed kernels or smaller $\kappa_n$ push $c_K$ up and $\tau_n^*(h)$ back into the recommended band).

## Why

The theorist's refinement of @prp-lepskii's proof now derives a bandwidth-explicit Lepskii constant that numerically predicts the empirical pattern documented in @fig-mc-tau. The prior prose framed the simulation as a calibration exercise; the refined theory makes it a prediction-verification exercise. The new prose preserves the empirical content (numbers and figure are untouched) but binds it to the theory rather than presenting it as standalone.

## Voice and conventions

- All cross-references via Quarto `@`-syntax (`@rem:tau-bandwidth`, `@prp-lepskii`, `@gine2002`); no `\cref` or `\ref` rewriting.
- Hedging preserved: "consistent with", "predicts", "the pattern is consistent with the bandwidth-explicit formula" — no "this confirms the theory".
- Notation aligned with the rest of the paper: $\tau_n^*(h)$, $c_K$, $\tau_0$, $M_n$, $h$, $d$, $\kappa_n$ all match the symbols already in `prp-lepskii`, its proof in Appendix [-@sec-annexA3], and `rem:tau-bandwidth`.
- INV-7 (notation consistency) preserved.
- INV-11 (numbers in text match results): $\tau_n^*(h) \approx 0.22\,\sqrt{2/c_K}$ at $n=500$ is the figure already printed verbatim in `rem:tau-bandwidth` (L1355 of the .qmd).
- INV-22 (claim-source map): the only numerical claim added to `sec-mc-tau` is $\tau_n^*(h) \approx 0.22\,\sqrt{2/c_K}$, which derives from `rem:tau-bandwidth`'s closed-form evaluation — already in the paper, no new claim-source map entry needed.

## Scope discipline

- `sec-mc-rate`, `sec-mc-lepskii`, the MISE table, the figures, and the figure captions are untouched.
- The new `rem:tau-bandwidth` and the refined proof of @prp-lepskii were not modified; the writer is downstream of the theorist's refinement.
- No edit to `sec-mc-design`, `sec-lepskii`, or the application sections in `sec-empapp`. The reference to $\tau = 4$ at L879 (Nepali application) was left as-is — it is consistent with the refined narrative ("asymptotic-conservative default when $h$ and $c_K$ are unknown").
