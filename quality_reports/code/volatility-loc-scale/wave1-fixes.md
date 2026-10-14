# Wave 1 Code Fixes — Volatility / Location-Scale NPIV

**Date:** 2026-05-17
**Scope:** Non-DGP-dependent fixes from `code-audit.md` HIGH/MEDIUM/LOW.
**Code root:** `/Users/samuele/Library/CloudStorage/Dropbox/Nonparametric_IV/Volatility/code/`

All modified scripts parse cleanly under R 4.5
(`Rscript -e "invisible(parse(file=…))"` returns OK for every file listed below).
The actual simulation runs were not executed (instructions specifically
exclude that — too slow).

## Files touched

| File | Status | What changed |
|---|---|---|
| `kernel_utils.R` | edited | Added `KAPPA_N_FLOOR <- 1e-6` constant + comment tying it to `ass:app4`. Added `ensure_dir()` helper. Added Tikhonov row-sum guard to `kernel_weights_lc`. |
| `empirical_estimators.R` | edited | Replaced `pmax(., 1e-6)` calls in `Dinv_star_eval` + `normalize_phi_sigma` with `KAPPA_N_FLOOR`. Switched `source()` to `here::here()`. Added `RNGkind("L'Ecuyer-CMRG")` + `mc.set.seed = TRUE` in both `bootstrap_*` functions. |
| `simulation_main.R` | rewritten | Wrapped the entire driver body in `run_mi_sim(params)` function. Top-level invocation preserved as `if (!exists("sim_main_no_run") || !sim_main_no_run) { … list2env(.out, envir=environment()) }` so the legacy entry point still works. Added `library(here)`, `here::i_am()`, `RNGkind("L'Ecuyer-CMRG")`, `mc.set.seed = TRUE`. `Dinv_star_eval` uses `KAPPA_N_FLOOR`. **DGP code unchanged.** |
| `simulation_main_IND.R` | rewritten | Same refactor as MI: `run_fi_sim(params)` callable function + sentinel for top-level invocation. **DGP code (lines for `pW`, `w_all`, `z_all`, `y_all`) unchanged.** **Stratum-filter (i0/i1 check, `length(i0) < 5 \|\| length(i1) < 5`) unchanged.** **LF iteration body unchanged.** |
| `run_large_scale.R` | rewritten | Replaced the readLines+sub+eval(parse) injection with direct calls to `run_mi_sim`/`run_fi_sim`. Stale comment at L9 removed. L'Ecuyer + `mc.set.seed` propagated. Paths via `here::here()`. `ensure_dir` for sim_results. |
| `sensitivity_runner.R` | **new** | Single parameterised utility for sensitivity sweeps. Exposes `run_one_config(kind, params)` and `run_sensitivity(kind, param_name, param_grid, …)`. Uses `sim_main_no_run <- TRUE` sentinel + `source()` so the driver functions are loaded without auto-running. |
| `sensitivity_cste.R` | rewritten | Thin wrapper around `run_sensitivity(kind="FI", param_name="cste", …)`. |
| `sensitivity_cste_mi.R` | rewritten | Thin wrapper, MI driver. |
| `sensitivity_cste_fi.R` | rewritten | Thin wrapper, FI driver. |
| `sensitivity_stopping.R` | rewritten | Multi-stopping-rule post-processing kept; the inner FI run is now `run_fi_sim(list(cste=…, simit=50, …))` instead of readLines+sub injection. |
| `analyse_sensitivity.R` | rewritten | Now accepts both the new payload shape (`s$imse_phi`) and the legacy one (`s$imse_phi_rep`). Paths via `here::here()`. |
| `nepal_estimation.R` | rewritten | Paths via `here::here()` (data at project root). Added `RNGkind("L'Ecuyer-CMRG")`. Uses `ensure_dir`. |
| `nepal_figure.R` | rewritten | Paths via `here::here()`. |
| `finance_estimation.R` | rewritten | `%||%` moved to top of file (HIGH-1). `fit$cste` typo replaced with `imax = 1500L` literal (HIGH-2). Paths via `here::here("data", "fed_rates.rds")` — now reads from project-root `data/`, matching Nepal. Added `RNGkind("L'Ecuyer-CMRG")`. |
| `finance_figure.R` | rewritten | Paths via `here::here()`. |
| `data_finance.R` | rewritten | Reads raw CSVs from `code/data/raw/` (where they already live); writes the cleaned panel to project-root `data/fed_rates.rds`. Adopts `ensure_dir` + `here::here()`. |

## Fix-by-fix mapping

### HIGH severity

**Fix 1. `%||%` ordering in `finance_estimation.R`.**
The infix operator was defined at L67, after its use at L30. Moved the
definition to immediately after `library()` calls (line 18). The
operator is now in scope before its first use.

**Fix 2. `fit$cste` typo at `finance_estimation.R:30`.**
`estimate_mi` returns `indm` and `delta_hat` but no `cste` field. The
printf intent was clearly `"indm = N / imax = M"`. Replaced with a bare
integer literal `1500L` matching the `imax` argument passed to
`estimate_mi`. Removed the dangling `%||%` from the printf, since
neither side can be `NULL` here.

### MEDIUM severity

**Fix 3. Parallel reproducibility.**
Added `RNGkind("L'Ecuyer-CMRG")` + `set.seed(seed, kind="L'Ecuyer-CMRG")`
at the top of every script that calls `mclapply`. Passed
`mc.set.seed = TRUE` explicitly to every `mclapply` call. Scripts
covered: `simulation_main.R`, `simulation_main_IND.R`,
`empirical_estimators.R` (both `bootstrap_*` functions),
`run_large_scale.R`, `nepal_estimation.R`. (Sensitivity wrappers
inherit this through `sensitivity_runner.R`, which sources both
simulation drivers and therefore picks up the same RNGkind.)

**Fix 4. Stale comment in `run_large_scale.R:9`.**
Removed the "FI is currently still at tau = 16, change
simulation_main_IND.R line 283 if needed" sentence. The new comment
notes that both drivers use Lepskii at tau = 4.

**Fix 5. Path unification.**
Every modified script now uses `here::here()` + `here::i_am("code/<name>.R")`.
The project root is `…/Volatility/`. Data goes to `Volatility/data/`,
results to `Volatility/empirical_results/` and `Volatility/code/sim_results/`.
The previous inconsistency (Nepal used `../data/`, finance used `data/`)
is resolved — both now read from the project-root `data/`.

Note: this adds a dependency on the `here` package, which was not
required before. Confirmed `here` is NOT installed in
`/Users/samuele/Library/R/x86_64/4.5/library/` or in the system R 4.5
tree. To run any of the modified scripts, the user needs:
```r
install.packages("here")
```

**Fix 6. Sensitivity refactor (option (a) — expose callable drivers).**

`simulation_main.R` and `simulation_main_IND.R` are now structured as:

```r
default_mi_params <- function() list(simset=1L, n=500L, simit=1000L, cste=0.005, imax=1500L, …)

run_mi_sim <- function(params = list()) {
  p <- modifyList(default_mi_params(), params)
  …  # all DGP code, LF iteration, Lepskii, MASE collection — unchanged
  list(params=p, regfun=…, zeval=…, phateval=…, results=…, …)
}

if (!exists("sim_main_no_run", inherits = TRUE) || !sim_main_no_run) {
  .out <- run_mi_sim()
  list2env(.out, envir = environment())
}
```

The sentinel `sim_main_no_run` lets `sensitivity_runner.R` source the
drivers without auto-executing the 1000-rep default. The
`list2env(.out, environment())` keeps backward compatibility for any
caller that still `source("simulation_main.R")` and reads bare names
like `zeval`, `phateval`, `results`, `MASEphi`.

`sensitivity_runner.R` exposes:
- `run_one_config(kind, params)` — single config, returns IMSE, indm, trajectories
- `run_sensitivity(kind, param_name, param_grid, simit, imax, out_rds, …)` — sweep
- `print_sweep_table(out, param_name)` — pretty print

The four sensitivity scripts are now ~20 lines each and contain only
their grid + their `out_rds` path. The readLines + sub() + eval(parse)
injection is gone.

### LOW severity

**Fix 7. Tikhonov guard for `kernel_weights_lc`.**
Added a row-sum guard mirroring the LL version's denom guard:
```r
row_sums <- rowSums(K)
row_safe <- ifelse(abs(row_sums) < 1e-10,
                   sign(row_sums + 1e-30) * 1e-10, row_sums)
sweep(K, 1, row_safe, "/")
```

**Fix 8. Document the density floor.**
Introduced `KAPPA_N_FLOOR <- 1e-6` at the top of `kernel_utils.R` with a
comment referencing the paper's `ass:app4`. All occurrences of
`pmax(fz, 1e-6)` in `Dinv_star_eval` (both simulation drivers and both
`estimate_*` routines in `empirical_estimators.R`) and the
`pmax(sigma_sample, 1e-6)` in `normalize_phi_sigma` now reference the
named constant. The 1e-2 floor inside the pilot `pmax(shat0_ev, 1e-2)`
is left as a literal because it has a different role (variance floor,
not density floor) and ties to a different assumption block — flagged
for follow-up.

**Fix 9. Unified output-directory creation.**
`ensure_dir(path)` defined in `kernel_utils.R`, used in
`run_large_scale.R`, `nepal_estimation.R`, `data_finance.R`, the
sensitivity wrappers, and `finance_estimation.R`. The three legacy
idioms (`if (!dir.exists(.)) dir.create(.)`, plain `dir.create(., recursive=TRUE)`,
and the silent `mkdir`-from-saveRDS) are replaced.

## Constraints — verified not touched

- `simulation_main_IND.R` lines 78–79 (the three-category `pW` DGP and
  `w_all` construction): **unchanged**. Differs from paper text
  ("Bernoulli(2/3)") — flagged for user-level discussion.
- `simulation_main_IND.R` L158 (`length(i0) < 5 || length(i1) < 5`
  stratum check): **unchanged**.
- LF iteration body in `simulation_main.R`, `simulation_main_IND.R`,
  `empirical_estimators.R::estimate_fi`, and
  `empirical_estimators.R::estimate_mi`: **unchanged**. Verified by
  diffing the iteration loops line-by-line against the originals.
- Kernel formulas (`gauss_kernel`, `gauss_cdfker`), Lepskii block,
  chain-rule mapback, affine renormalization: **unchanged**.

## Parse verification

```
kernel_utils.R                 OK
empirical_estimators.R         OK
simulation_main.R              OK
simulation_main_IND.R          OK
run_large_scale.R              OK
sensitivity_runner.R           OK
sensitivity_cste.R             OK
sensitivity_cste_mi.R          OK
sensitivity_cste_fi.R          OK
sensitivity_stopping.R         OK
analyse_sensitivity.R          OK
nepal_estimation.R             OK
nepal_figure.R                 OK
finance_estimation.R           OK
finance_figure.R               OK
data_finance.R                 OK
```

Generated with `Rscript -e "for (f in c(...)) parse(file=f)"`.

## Still pending (not in Wave 1 scope)

1. **FI DGP mismatch (paper says Bernoulli(2/3), code uses 3 categories
   with `pW <- c(1/3, 5/12, 1/4)`).** Deferred to user-level discussion.
   This is the core open question.
2. **Nepal raw-to-cleaned preprocessing not committed.** The cleaned
   `nepal_vegetables.rds` is in the repo but the script that builds it
   from raw inputs is not. Replication audit will flag this.
3. **Step-size contraction guard not documented in paper.** Audit
   recommended adding a runtime check that
   `c · ‖A_b* A_b‖ < 1` (paper prp-convlf). Not done here — needs a
   paper-text update too, not just code.
4. **Three `make_*.R` scripts in `code/` were created during this
   session (timestamps 23:13–23:20 on 2026-05-17) and were not in the
   audit's per-script table.** They contain `setwd()`, `getwd()`, and
   relative `source("kernel_utils.R")` patterns that violate the
   project's INV-16 / INV-19 rules. They are out of Wave 1 scope and
   were not modified. Flagged for the next wave or for the user to
   decide whether they should be merged into the standard pipeline.

## User decisions needed before further DGP-dependent fixes

1. **What is the intended FI DGP?**
   - Option A: change paper text to match code (three-category instrument).
   - Option B: change code to match paper (Bernoulli(2/3)).
   - Option C: keep both, document why they differ.
2. **Is `here` an acceptable new dependency?** It is now required by
   every modified script. The user should `install.packages("here")`
   before running anything.
3. **Should `data/fed_rates.rds` (which currently exists in BOTH
   `Volatility/data/` and `Volatility/code/data/`) be deduplicated?**
   The new `data_finance.R` writes only to `Volatility/data/`. The
   stale copy in `code/data/` can be removed.
4. **Should the three new `make_*.R` scripts be brought into the
   standard pipeline?** They appear to support paper figures
   (rate-loglog, oracle Lepskii, tau sensitivity) but use prohibited
   patterns (`setwd`, `getwd`) that the rest of the suite no longer uses.
