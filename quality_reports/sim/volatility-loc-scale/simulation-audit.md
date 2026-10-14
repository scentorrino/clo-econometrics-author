# Simulation-Engineer-Critic Audit — Centorrino-Florens Volatility

**Date:** 2026-05-17.
**Severity:** HIGH (Execution phase, theory paper).
**Theorems under test:** `thm-mainconv`, `cor-rates`, `prp-lepskii`.

## Score: 58/100 — INSUFFICIENT EVIDENCE

The simulation as written does not numerically verify the rate theorem or the adaptive-stopping oracle inequality. Reasonable as illustration; below referee standard at Ecta/JoE.

## CRITICAL findings

1. **Paper-code DGP mismatch in FI design.** Paper L664 says "$W \sim \mathrm{Bernoulli}(2/3)$"; code `simulation_main_IND.R` L78-79 generates `W ∈ {0, 1, 2}` with probabilities `(1/3, 5/12, 1/4)` and the estimator at L158 drops the `w=2` stratum (~25% of observations). Either paper or code must change.

2. **Missing FI `.rds` files.** `code/sim_results/` contains only `MI_n{500,1000,2500}_simit100_imax1500.rds`. No FI files. Paper's `tbl-mc-mise` would fail at compile.

3. **Lepskii adaptation untested.** Paper L764 reports median $\hat m = 1501$ at $n=1000$ for MI — the Lepskii rule hits the iteration cap and never fires. The adaptive claim of `prp-lepskii` cannot be verified from these numbers.

4. **No rate-slope evidence.** No log-log MISE-vs-$n$ plot, no comparison to theoretical exponent, no inference of $\beta_\epsilon$ from the simulation.

5. **No MC SE reported.** With $S=100$ and acknowledged heavy-tailed FI distribution, MC SE on the median is comparable to the differences across $n$ — reader can't distinguish signal from noise.

## Sub-axis scores

| Phase | Score | Weight |
|---|---:|---:|
| Claim identification | 12/20 | 1× |
| DGP coverage | 10/20 | 1× |
| MC error budget | 5/15 | 1× |
| Empirical-vs-asymptotic comparison | 4/20 | 1× |
| Reproducibility | 11/15 | 1× |
| Cross-cutting | 6/10 | 1× |

## What works

- Clean modular architecture (kernel utils, parallel structure, derivative-coordinate iteration).
- Lepskii implementation mathematically faithful to paper.
- `run_large_scale.R` orchestration is sound (per-config `.rds`, skip-if-exists, captures elapsed + diagnostics).
- Sensitivity machinery exists (just unreported).
- LF iteration in derivative coordinates with chain-rule mapback correct.

## Wave 1 — Must-fix before manuscript review

1. Resolve FI DGP — pick paper text or code, run consistently.
2. Generate the missing FI `.rds` files.
3. Add MC SE columns to `tbl-mc-mise`.
4. Add log-log MISE-vs-$n$ plot.

## Wave 2 — Should-fix before submission

5. Extend $n$-grid to {500, 1000, 2500, 5000, 10000} for MI minimum.
6. Increase $S$ to 200-500 for FI heavy-tail regime.
7. Compute oracle Lepskii benchmark and report $\hat m / m^*_{oracle}$.
8. Report sensitivity to $\tau \in \{1, 2, 4, 8, 16\}$.
9. Document `hw` clipping `[0.5, 5] × sd(w)` in paper text.
10. Run a second DGP at the existing `simset == 2` branch (currently unused).

## Verdict

Insufficient to support `thm-mainconv`, `cor-rates`, `prp-lepskii` as verification. Strong as illustration if the paper text reframes accordingly. Three-strikes status: this is critique #1 — strike-1 designated for the DGP mismatch.
