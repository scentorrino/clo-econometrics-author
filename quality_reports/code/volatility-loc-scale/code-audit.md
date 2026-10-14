# Coder-Critic Audit — Volatility / Location-Scale NPIV

**Date:** 2026-05-17.
**Severity:** HIGH (execution phase numerical claims), relaxed for advisory style points.
**Score: 78/100.**

The implementation is mathematically faithful to the paper. No incorrect mathematics. Deductions are engineering hygiene, reproducibility fragility, and one concrete bug.

## HIGH-severity findings

1. **`%||%` ordering bug in `finance_estimation.R`** (L30 vs L67). The infix operator is used at line 30 before being defined at line 67. R does not hoist user infix operators — this WILL error in a clean session. Practical impact: the buggy call is inside `sprintf` so it prints nonsense (not a numerical bug), but the script fails to run.

2. **Fragile `readLines + sub + eval(parse(.))` injection** in `run_large_scale.R` + 4 sensitivity scripts. Anchored regex like `^cste   <- 0\.005$` is whitespace-fragile. A one-character change to the source default silently no-ops the `sub()` and the original default runs.

## MEDIUM-severity findings

3. **`mclapply` reproducibility partial.** Default child seeding is NOT bit-reproducible across cores. Need explicit `RNGkind("L'Ecuyer-CMRG")` for parallel-stream reproducibility.

4. **Path inconsistency.** Nepal uses `../data/`, finance uses `data/`. Both assume `cwd = code/` but with different relative depths. Adopt `here::here()`.

5. **Code duplication.** Four `sensitivity_*` scripts share ~80% of bodies. Sim drivers' `run_one` duplicates `estimate_*` from `empirical_estimators.R`.

6. **Step-size contraction guard not checked at runtime.** Paper `prp-convlf` requires $c\,\|\hat{\mathsf{A}}^*_b\hat{\mathsf{A}}_b\| < 1$; code hard-codes `c = 0.005` without diagnostic.

7. **Nepal preprocessing not committed.** Only cleaned `nepal_vegetables.rds` is in repo. Raw-to-cleaned step missing — replication impossible.

8. **Docstring vs code mismatch in `simulation_main_IND.R` L38** — comment says "Bernoulli(2/3)" but code generates three-category $W$. Same defect viewed as docs (here) and as DGP mismatch (sim-critic finding #1).

## LOW-severity findings

9. Stale comment in `run_large_scale.R:9` ("FI is currently still at tau = 16") — code uses 4.

10. Density floor `pmax(., 1e-6)` is hard-coded everywhere, not tied to $n$.

11. `kernel_weights_lc` divides by `rowSums(K)` without a floor (LL version has Tikhonov guard).

12. Output directories use three different creation idioms.

13. `finance_estimation.R` `fit$cste` is a printf typo — `estimate_mi` never returns a field called `cste`.

## What works

- LF iteration correctly in derivative coordinates with chain-rule mapback.
- Lepskii balancing in $\mathcal{H}$-norm matches paper definition.
- Higher-order kernel CDF closed forms (orders 4, 6, 8) derived from scratch — verified order 4 and 6 by hand.
- Affine renormalization at end matches paper L730.
- Multiplier bootstrap reproducible (weights pre-generated in master process).
- Documentation in `kernel_utils.R` is exceptional (recursion stated, Matlab predecessor's bug noted and corrected).
- `cv_bw_ll` correctly uses leave-one-out (no data leakage).
- INV-12 / INV-13 / INV-15 / INV-17 / INV-19 respected in paper-facing figures.

## Per-script grades

| Script | Grade | Concern |
|---|---|---|
| `kernel_utils.R` | A | None. |
| `empirical_estimators.R` | A- | Some duplication with sim drivers. |
| `simulation_main.R` (MI) | B+ | `hw` clipping undocumented. |
| `simulation_main_IND.R` (FI) | C+ | DGP mismatch with paper text. |
| `run_large_scale.R` | B- | Fragile injection scheme. |
| `nepal_estimation.R` | B | Preprocessing not committed. |
| `finance_estimation.R` | C | `%||%` ordering bug. |
| `data_finance.R` | A- | Date handling reasonable; FRED CSVs committed. |
| `sensitivity_*.R` (×4) | C+ | Substantial duplication. |
| `analyse_sensitivity.R` | B- | Plot titles via `main =` ok for diagnostics. |
| `*_figure.R` (Nepal, finance) | A | Clean base-R plotting, no titles in panels. |

## Wave 1 — Must-fix before release

1. Fix `%||%` ordering in `finance_estimation.R`.
2. Resolve FI DGP — coordinate with paper text fix.
3. Commit Nepal raw-to-cleaned preprocessing.
4. Fix docstring in `simulation_main_IND.R` L38.

## Wave 2 — Should-fix before submission

5. Adopt `RNGkind("L'Ecuyer-CMRG")` + explicit `mc.set.seed` for parallel reproducibility.
6. Unify paths via `here::here()`.
7. Refactor sensitivity scripts into one parameterized utility.
8. Replace `readLines + sub + eval` injection with parameterizable functions.
9. Update stale comment in `run_large_scale.R:9`.
10. Document the step-size contraction guard in paper text.
