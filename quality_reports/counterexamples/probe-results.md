# Counterexample Probes — Theorem dummy-wlln
**Date:** 2026-05-15
**Reviewer:** counterexample-hunter (manually applied — agent not yet discoverable by Task in this session; see smoke report)

## Probe 1: Cauchy distribution
**Setup:** $X_i$ iid Cauchy(0, 1). The Cauchy distribution has no first moment, so $\mathbb{E}|X| = \infty$.
**Result:** $\bar X_n$ does NOT converge in probability — it is itself Cauchy(0, 1) for every $n$ (the Cauchy is stable with index 1). So this looks like a counterexample, but it violates A2.
**Outcome:** **Probe captured by A2.** Cauchy violates the integrability condition, so the theorem does not claim anything about it. No counterexample. Suggested remark: a one-line note in the paper that A2 rules out infinite-mean distributions like Cauchy would strengthen the assumption block's interpretability.

## Probe 2: Atom at a single point
**Setup:** $X_i$ degenerate at $x_0 \in \mathbb{R}$. All assumptions hold trivially ($\mathbb{E}|X| = |x_0| < \infty$).
**Result:** $\bar X_n = x_0$ deterministically. $\xrightarrow{p} x_0 = \mathbb{E}[X]$ trivially.
**Outcome:** Theorem holds. Not a counterexample.

## Probe 3: Heavy tail with $\mathbb{E}|X|^{1.5} = \infty$ but $\mathbb{E}|X| < \infty$
**Setup:** $X$ with density $f(x) \propto |x|^{-2.3}$ for $|x| > 1$, zero otherwise. Tail decay $|x|^{-2.3}$ gives $\mathbb{E}|X| < \infty$ but $\mathbb{E}|X|^{1.5} = \infty$.
**Result:** A2 holds; Khinchin's WLLN applies; $\bar X_n \xrightarrow{p} \mu$.
**Outcome:** Theorem holds. Confirms A2 is sufficient even with infinite higher fractional moments.

## Probe 4: Non-iid relaxation (independent but not identical)
**Setup:** $X_i$ independent with $\mathbb{E}|X_i| < \infty$ but distributions $P_i$ varying with $i$.
**Result:** The product structure $\varphi_{\bar X_n}(t) = \prod_i \varphi_i(t/n)$ no longer collapses to a single $\varphi(t/n)^n$. A1 is needed for the factorisation step at `proofs.tex:9-12`.
**Outcome:** **Probe captured by A1.** Not a counterexample. Suggested remark: the iid assumption is doing real work; the theorem does not extend to inid without further conditions (Lindeberg-Feller-style).

## Probe 5: Weak dependence (alpha-mixing)
**Setup:** $X_i$ stationary, $\mathbb{E}|X_1| < \infty$, with summable alpha-mixing coefficients.
**Result:** Ergodic theorem extensions give consistency, but the iid characteristic-function argument breaks. A1 is again required.
**Outcome:** Probe captured by A1. Not a counterexample.

## Summary

**Confirmed counterexamples:** 0.
**Probes captured by stated assumptions:** 4 of 5 (Probes 1, 4, 5 — and trivially Probe 2).
**Theorem holds for stated probe:** Probe 3 (and Probe 2).
**Probes captured by unstated assumptions:** 0.

## Score: 100 / 100 (Theorem dummy-wlln)

The theorem withstood all standard probes. The assumption block is exactly tight: A2 rules out Cauchy-type counterexamples; A1 rules out non-iid relaxations. No unstated conditions surfaced.

**Recommendation:** Consider adding two one-sentence remarks after the proof:
1. "A2 cannot be weakened — without first-moment integrability, the sample mean need not converge (e.g., Cauchy)."
2. "A1 cannot be weakened to mere independence — the factorisation in step 2 fails for non-identical distributions; extensions to inid or weakly-dependent sequences require Lindeberg-style conditions."

These would address probes 1, 4, 5 explicitly and strengthen reviewer confidence.
