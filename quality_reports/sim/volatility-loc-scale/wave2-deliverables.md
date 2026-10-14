# Wave 2 deliverables — Centorrino-Florens volatility Monte Carlo

**Date:** 2026-05-17
**Theorems addressed:** thm-mainconv, cor-rates, prp-lepskii.
**Critic-target score:** clear the 80/100 commit gate for simulation evidence.

---

## What was built (and what each script does)

| File | Status | Purpose |
|---|---|---|
| `code/make_mc_rate_loglog.R` | runnable now | Reads existing `MI_n{500,1000,2500}_simit100_imax1500.rds`, computes median ISE and MC SE on the median, fits the log-log slope, writes `code/figures/mc_rate_loglog.pdf` and `code/sim_results/mc_rate_table.rds`. Backs out the implied beta_eps from the slope. |
| `code/make_oracle_lepskii.R` | runnable now (long) | Recomputes MI trajectories at `S_oracle = 30` replicates per n in `{500, 1000, 2500}`, with `imax = 1500`. Saves per-rep oracle index `m_oracle = argmin_m \|\|b'_m - b'_dagger\|\|^2`, the Lepskii index `hat m`, ratio `hat m / m_oracle`, and the median ISE trajectory. Writes `code/figures/oracle_lepskii.pdf`. Knobs overridable via env vars `ORACLE_{S,IMAX,NGRID}_OVERRIDE` for smoke tests. |
| `code/make_tau_sensitivity_mi.R` | runnable now (long) | tau sweep `tau in {1,2,4,6,8,12,16}` for the MI Lepskii rule at `n in {500, 1000}` (default; configurable). Writes `code/figures/tau_sensitivity_mi.pdf` and `code/sim_results/tau_sensitivity_mi.rds`. Knobs overridable via `TAU_*` env vars. |
| `Centorrino_Florens_VOL_1.qmd` `tbl-mc-mise` chunk | edited | Adds MC SE columns to the cells (`MAD x.xxxx, MCSE y.yyyy`). Gracefully omits FI rows when the FI rds files are missing. |
| `Centorrino_Florens_VOL_1.qmd` new chunks | edited | Three new chunks under `@sec-mcsim`: `fig-mc-rate-loglog` (rate plot), `fig-mc-lepskii` (oracle vs. Lepskii), `fig-mc-tau` (tau sensitivity). Each chunk conditionally evaluates only if the corresponding PDF exists in `code/figures/`. |
| `Centorrino_Florens_VOL_1.qmd` `load-sim` and `fig-mc-onerep` | edited | Defensive: when an FI rds is missing, the load returns `NULL` (for FI only — MI is still required) and `fig-mc-onerep` plots only the MI curve plus a "FI (deferred)" placeholder in the legend. |

All R scripts comply with the project's coding conventions: `set.seed` once at top (INV-14), libraries at top (INV-15), no `setwd` outside the `on.exit`-guarded code-dir resolution, no `rm(list=ls())`, no `install.packages()` (INV-19), pre-allocated result containers (INV-17), no absolute paths (INV-16).

---

## What was deferred (and why)

| Item | Why deferred | Resolution path |
|---|---|---|
| Regenerating the FI `.rds` files | The paper text says `W ~ Bernoulli(2/3)`; `code/simulation_main_IND.R` (lines 78-79 of the audit) draws `W in {0, 1, 2}` with weights `(1/3, 5/12, 1/4)`. Until the user picks one, regenerating is wasted compute. | Strike 1 in the audit. Step 3 strategic discussion: pick paper or code, run `make_oracle_lepskii.R` plus the FI equivalent of `make_tau_sensitivity_mi.R` after the decision, then re-add the FI rows to `tbl-mc-mise` (the chunk already handles both cases). |
| Extending the MI grid to `n = 5000` | Per scope: "if more than ~6 hours single-node, defer to user." A single `n = 2500` replicate at `imax = 1500` is already several minutes; `n = 5000` would push the full S=100 run beyond a single afternoon. The current three-point log-log is the minimum the rate diagnostic needs. | Re-add `list(kind = "MI", n = 5000, simit = 100, imax = 1500, cste = 0.005)` to the `configs` list at the bottom of `code/run_large_scale.R` and re-run. |
| Increasing S beyond 100 for FI heavy-tail regime | FI deferred as above. | Bundled with the FI DGP resolution. |
| Re-running the existing MI configs with trajectory saving | The existing `MI_n*_simit100_imax1500.rds` files do *not* contain the per-replicate `gpev_mat`/`opev_mat` matrices needed for the oracle Lepskii benchmark. `make_oracle_lepskii.R` is therefore self-contained and recomputes (S_oracle = 30 replicates per n). This was the cheapest path. | None needed — `make_oracle_lepskii.R` produces what is needed. |
| Running a second DGP at `simset == 2` | Out of scope for Wave 2; audit item #10. | Future Wave-3 work. |

---

## Findings (preliminary, from `make_mc_rate_loglog.R` output)

These numbers come directly from the existing MI `.rds` files; they were not available before this wave.

**Log-log MISE slopes (3-point OLS):**
- `varphi`: slope `-0.053`. Implied `beta_eps = 0.056`.
- `sigma`: slope `-0.306`. Implied `beta_eps = 0.442`.

Theoretical slope under cor-rates with `delta_n ~ n^{-1/2}` is `-beta_eps / (beta_eps + 1)`. The reference slopes plotted are:

| `beta_eps` | theoretical slope |
|---:|---:|
| 0.5 | -0.333 |
| 1.0 | -0.500 |
| 1.5 | -0.600 |
| 2.0 | -0.667 |

**Reading.** The `varphi` slope is essentially flat — orders of magnitude away from the cor-rates prediction for any plausible `beta_eps in (0.5, 1.5)`. This is consistent with the audit observation (#3) that the Lepskii rule at `tau = 4` sits at the iteration cap for *every* MI replicate (`cap_share = 1.0` at all three n in our readout from the rds files). When the rule is capped, the iterate at `hat m` is just the iterate at `imax + 1`, which has not yet entered the variance-dominated regime; therefore the `varphi` MISE is dominated by residual bias and does not benefit from increasing n in the way cor-rates predicts at the bias-variance balance point.

The `sigma` slope is closer to the `beta_eps = 0.5` reference, consistent with the iteration spending its early budget on the scale piece (the affine renormalization fixes the variance of the implied residual exactly, which gives the scale block a head start).

**Implication for `prp-lepskii` verification.** With the Lepskii rule capped, the *adaptive* claim of prp-lepskii cannot be directly checked from the existing rds files. The two remaining diagnostics that *can* check it are now in place:
1. `make_oracle_lepskii.R` measures `m_oracle` against the known truth; if `m_oracle` is also at the cap, the *budget* `imax` is the binding constraint, not the rule. If `m_oracle` is well inside the budget but `hat m` is at the cap, `tau = 4` is too conservative for this DGP and the adaptive guarantee fails empirically.
2. `make_tau_sensitivity_mi.R` sweeps tau down to 1; the variance-noise pickup as tau shrinks should be visible in the realized MISE if the iteration is genuinely beyond the bias-variance balance.

**Partial result already in hand: oracle Lepskii at n = 500.** The script was already executed for the n = 500 cell (file: `code/sim_results/oracle_lepskii_n500_S30.rds`, S = 30 replicates, elapsed 181 s on this machine). The numbers:

| quantity | value |
|---|---|
| median `hat m` (Lepskii at tau = 4) | 1501 (i.e., at the cap I_max + 1) |
| cap-share of `hat m` | 0.967 (29 of 30 replicates capped) |
| median `m_oracle` | 2 |
| cap-share of `m_oracle` | 0.000 |
| median ratio `hat m / m_oracle` | 750.5 |
| IQR of ratio | (4.6, 1501) |
| median oracle ISE in deriv. coords | 0.94 |
| median Lepskii ISE in deriv. coords | 1.50 |

**Reading.** The oracle says "stop at iteration 2" (the iterate just after the pilot, where the pilot already places `b'_0` close to `b'_dagger` in derivative coordinates) while the Lepskii rule at tau = 4 runs all the way to the cap and finishes at an ISE that is roughly 1.6x the oracle's. This is *not* "matches at large n only": the empirical ratio is *three orders of magnitude* off the `sqrt(log M_n) ~ 2.7` adaptation overhead that prp-lepskii predicts. Three possibilities:

(a) **The variance proxy in the rule is mis-scaled for this DGP.** The rule uses `delta_hat^2 = cfun[1] / n` from the *initial* discrepancy; at n = 500 this proxy is large, the threshold `(tau * delta_hat)^2 * m` therefore loose at every iterate, and the rule fails to fire. The MI design with continuous W has a much larger `cfun[1]` than the FI design (where the binary instrument carries less information into the initial moment functional); the audit observation that median `indm = 126` in the FI design is consistent with this.

(b) **`tau = 4` is genuinely too conservative.** The Mathé-Pereverzev range `tau in [3, 6]` is theoretical guidance; the simulation evidence is now suggesting that for this DGP a tau closer to 1 might be appropriate. `make_tau_sensitivity_mi.R` is the right next experiment.

(c) **The pilot is already at the oracle.** If `m_oracle = 2` for nearly every replicate, the LF iteration is not actually buying anything beyond the Nadaraya-Watson pilot: the pilot ISE is close to the optimum and every subsequent iterate moves away. This would be a finding about the *DGP* (the pilot is highly informative here because X is only mildly endogenous) rather than about the rule.

The n = 1000 and n = 2500 cells of `make_oracle_lepskii.R` should be run to confirm whether `m_oracle` stays near 2 (case (c)) or grows with n (cases (a)/(b)).

Running `make_oracle_lepskii.R` to completion (which will pick up where it left off — the n = 500 file already exists and is skipped) and `make_tau_sensitivity_mi.R` is the next step. They are deliberately structured as separate scripts so the user can run them when compute is available, without blocking the rate-plot deliverable.

---

## How to regenerate outputs

From the project root (`Volatility/`), in order of compute cost:

```bash
## Cheap (seconds): rate plot from existing rds files
Rscript code/make_mc_rate_loglog.R

## Expensive (~30-60 min on a 16-core box at default S = 30):
##   oracle Lepskii at n = {500, 1000, 2500}, imax = 1500
Rscript code/make_oracle_lepskii.R

## Expensive (~30-60 min at default S = 20):
##   tau sweep at n = {500, 1000}, imax = 1500
Rscript code/make_tau_sensitivity_mi.R
```

To check the pipeline quickly without committing to the full budget, override knobs via env vars:

```bash
ORACLE_S_OVERRIDE=3 ORACLE_IMAX_OVERRIDE=100 ORACLE_NGRID_OVERRIDE=300 \
  Rscript code/make_oracle_lepskii.R

TAU_S_OVERRIDE=3 TAU_IMAX_OVERRIDE=100 TAU_NGRID_OVERRIDE=300 \
  Rscript code/make_tau_sensitivity_mi.R
```

The Quarto chunks for `fig-mc-rate-loglog`, `fig-mc-lepskii`, and `fig-mc-tau` each evaluate only if their PDF exists in `code/figures/`, so the manuscript compiles cleanly at any point along the way.

---

## Step 3 strategic-discussion items

1. **FI DGP decision.** Bernoulli(2/3) per the paper, or the three-category W per the code? Once decided, `code/simulation_main_IND.R` needs an edit (line 78-79 per the audit), then re-run `run_large_scale.R` to regenerate `FI_n{500,1000,2500}_simit100_imax1500.rds`. After that, re-run the three new scripts with `kind = "FI"` variants (the MI versions can be straightforwardly adapted) and re-add the FI rows to `tbl-mc-mise` (the chunk already auto-detects).
2. **Iteration budget `imax`.** If `make_oracle_lepskii.R` shows `m_oracle` itself sitting at `imax + 1` for n in {1000, 2500}, the conclusion is that `imax = 1500` is too small to resolve the bias-variance optimum on this DGP. Two responses are possible: (a) raise `imax` (linear in compute, easy), (b) accept that the present MC is a partial verification and reframe the paper text in @sec-mcsim accordingly.
3. **`tau` recalibration.** If `make_tau_sensitivity_mi.R` shows that `tau = 4` keeps the rule at the cap while a smaller tau pulls it inside, the audit's recommendation "report sensitivity to tau" naturally extends into a recommendation to *change* the default tau in the production code path. This is a paper-text-change, not a methods-change.
4. **Rate readout in the paper text.** The implied `beta_eps` should be discussed in @sec-mc-rate. The current text (added by this wave) describes the readout as a "conservative lower bound" — a more substantive interpretation requires either the oracle plot (showing the iteration is budget-bound, not method-bound) or an extended-`imax` run.

---

## Files changed / added in this wave

Added:
- `code/make_mc_rate_loglog.R`
- `code/make_oracle_lepskii.R`
- `code/make_tau_sensitivity_mi.R`
- `code/figures/mc_rate_loglog.pdf` (output of `make_mc_rate_loglog.R`)
- `code/sim_results/mc_rate_table.rds` (output of `make_mc_rate_loglog.R`)
- `quality_reports/sim/volatility-loc-scale/wave2-deliverables.md` (this file)

Modified:
- `Centorrino_Florens_VOL_1.qmd` (`load-sim`, `fig-mc-onerep`, `tbl-mc-mise`, plus three new chunks `fig-mc-rate-loglog`, `fig-mc-lepskii`, `fig-mc-tau`, plus prose between them).

Not touched (per scope):
- `code/simulation_main.R`
- `code/simulation_main_IND.R`
- `code/empirical_estimators.R`
- LF iteration body anywhere.
