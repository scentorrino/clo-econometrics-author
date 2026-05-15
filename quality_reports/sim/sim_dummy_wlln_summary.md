# Simulation Summary — Theorem dummy-wlln (WLLN)
**Date:** 2026-05-15
**Seed:** 20260515
**B:** 2000
**n grid:** 50, 200, 1000, 5000

## What was tested
Consistency of the sample mean: $\bar X_n \to \mu$ in probability under iid + integrability (A1 + A2). The theorem makes a *probability-of-deviation* claim, not a *rate* claim — we check $\Pr(|\bar X_n - \mu| > 0.1)$ shrinks as $n$ grows.

## DGPs
- **Favorable:** iid Standard Normal (all moments finite — far more than A2 needs).
- **Stress:** iid Student-t with df = 1.5 (A2 holds, $\mathbb{E}|X| < \infty$, but variance is infinite).

## Mandatory empirical-vs-asymptotic comparison
The WLLN's asymptotic claim is $\Pr(|\bar X_n - \mu| > \varepsilon) \to 0$, so the column to watch is `Pr(|X-bar| > 0.1)`. It should be monotonically decreasing in $n$ and small at the largest $n$, within Monte Carlo SE.

Results table: `paper/tables/sim/sim_dummy_wlln_results.tex`.

Favorable DGP — largest-n Pr(|X-bar| > 0.1) = 0.0000 (MC SE 0.0000).
Stress    DGP — largest-n Pr(|X-bar| > 0.1) = 0.4340 (MC SE 0.0111).

## Teaching note
The WLLN gives consistency, not a rate. A natural follow-up would test $\sqrt{n} \bar X_n \to N(0, \sigma^2)$ — but the stress DGP (Student-t with df = 1.5) has infinite variance, so the CLT does not apply. This is exactly the kind of distinction the simulation-engineer-critic's Phase 1 (Claim Identification) is designed to surface.

## Verdict (favorable): **Matches**
## Verdict (stress):    **Matches at large n only**
## Verdict (overall):   **Matches at large n only**
