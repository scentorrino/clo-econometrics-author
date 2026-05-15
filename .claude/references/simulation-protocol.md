# Simulation Protocol

Procedure for running and reporting a Monte Carlo that verifies an asymptotic claim. Loaded by the `simulation-engineer` agent and the `/simulate` skill. Checked by `simulation-engineer-critic`.

## When a Simulation Matters

A Monte Carlo can verify:

- **Consistency:** $\hat\theta_n \to \theta_0$ as $n \to \infty$
- **Rate:** $r_n(\hat\theta_n - \theta_0) = O_p(1)$
- **Limiting distribution:** $r_n(\hat\theta_n - \theta_0) \xrightarrow{d} L$ for a stated $L$
- **Coverage:** confidence interval covers $\theta_0$ with probability $1 - \alpha$
- **Test size:** rejection rate under $H_0$ equals nominal $\alpha$
- **Test power:** rejection rate under stated alternatives
- **Bootstrap validity:** bootstrap CI / test approximates the asymptotic CI / test

A simulation does **not** verify a proof. A simulation that "works" with a broken proof is uninformative; a failing simulation with a sound proof points to a finite-sample concern.

## Sample-Size Grid

Span at least two orders of magnitude.

| Claim type | Suggested grid |
|---|---|
| Consistency / rate | $n \in \{50, 200, 500, 2000, 5000\}$ |
| Limiting distribution | $n \in \{200, 500, 2000, 5000, 10000\}$ — small $n$ gives a useful "how soon does the limit kick in" view |
| Coverage / size / power | $n \in \{100, 500, 1000, 5000\}$ with $B \geq 2000$ |

If the theorem's rate is slow (e.g., $n^{1/3}$), extend the upper end of the grid — finite-sample mismatch persists much longer.

## Number of Replications $B$ and Monte Carlo Standard Error

Pick $B$ so the Monte Carlo standard error is small compared to the effect you want to detect.

| Quantity | MC SE | Rule of thumb |
|---|---|---|
| Empirical mean of $\hat\theta - \theta_0$ | $\hat\sigma / \sqrt{B}$ | $B = 2000$ keeps MC SE $\sim$ 5% of the population SD |
| Empirical variance | $\hat\sigma^2 \sqrt{2 / (B-1)}$ | $B = 2000$ keeps MC SE $\sim$ 3% of true variance |
| Empirical quantile | $\sqrt{\alpha(1-\alpha)/B} / f(q_\alpha)$ | $B = 5000$ for tail quantiles |
| Rejection rate $\hat p$ | $\sqrt{\hat p (1 - \hat p)/B}$ | $B = 2000$ gives MC SE $\approx 0.005$ at $\hat p = 0.05$ |

**Always report MC SEs.** A reviewer should be able to tell signal from noise without redoing the calculation.

## Data-Generating Processes

At minimum two DGPs:

1. **Favorable DGP.** Exactly the conditions assumed in the theorem. Textbook case.
2. **Stress-test DGP.** Pushes against assumptions without violating them. Examples:
   - Heavier tails (bounded fourth moment, near the limit of integrability)
   - Near-boundary parameter
   - Weak signal
   - Heteroskedastic / non-iid (if the theorem allows)
   - Small but nonzero misspecification (if the theorem claims robustness)

Add a third DGP if the theorem allows non-iid sampling: independent but non-identically distributed, weakly dependent, clustered, or panel with serial correlation.

## What to Tabulate

For each DGP × n × claim type:

| Claim | Report |
|---|---|
| Consistency | Bias $\mathbb{E}[\hat\theta - \theta_0]$, variance, both with MC SE |
| Rate | Empirical SD of $r_n(\hat\theta - \theta_0)$ across $B$ — should be roughly constant in $n$ if rate is correct |
| Limiting distribution | Empirical quantiles 0.025, 0.05, 0.25, 0.5, 0.75, 0.95, 0.975 of $r_n(\hat\theta - \theta_0)$; compare to claimed limit's quantiles (MC SE in adjacent column) |
| Coverage | Empirical $\Pr(\theta_0 \in \mathrm{CI})$ with Wald CI for the proportion |
| Size | Empirical rejection rate under $H_0$ with Wald CI |
| Power | Empirical rejection rate at stated alternatives |

For limiting-distribution claims, an empirical-vs-asymptotic Q-Q plot is often more informative than a table — include it as a figure in `paper/figures/sim/`.

## Mandatory Comparison Format

For limiting-distribution claims, every results table includes the empirical-vs-asymptotic columns:

| Quantile of $r_n(\hat\theta - \theta_0)$ | Empirical (MC SE) | Asymptotic | Difference (MC SE units) |
|---|---|---|---|
| 0.025 | -1.99 (0.04) | -1.96 | -0.75 |
| 0.05 | -1.66 (0.03) | -1.645 | -0.50 |
| 0.5 | 0.01 (0.02) | 0 | +0.50 |
| 0.95 | 1.67 (0.03) | 1.645 | +0.83 |
| 0.975 | 1.97 (0.04) | 1.96 | +0.25 |

The "Difference (MC SE units)" column is what the reader looks at. Any |difference| > 2 MC SE at the largest $n$ is a flag — either the simulation has a bug, the rate is wrong, or the limit is wrong.

## Verdict Line

Every simulation summary ends with one of:

- **Matches.** Differences are within 2 MC SE at all $n$ for both DGPs.
- **Matches at large $n$ only.** Mismatch at small $n$ but tightens as $n$ grows; consistent with claimed asymptotic but slow convergence — note this in the paper.
- **Persistent mismatch at largest $n$.** Difference exceeds 2 MC SE at the largest $n$ for at least one DGP. **Escalate to theorist** — the proof or limit may be wrong.

## Reproducibility

- One seed per script, set at top (INV-14).
- All packages loaded at top (INV-15).
- No absolute paths (INV-16); use `here::here()` (R), `pathlib.Path` (Python), `joinpath(@__DIR__, ...)` (Julia).
- Pre-allocate result containers (INV-17). No growing vectors.
- Save intermediate `.rds` / `.parquet` so reruns are cheap.
- Parallelize via `future.apply`, `joblib`, or `Distributed` — record the number of workers and the seed-handling strategy (`future_lapply(..., future.seed = TRUE)`).
- Tables go to `paper/tables/sim/` as bare `tabular` (INV-13).
- Figures go to `paper/figures/sim/` as PDF (vector).
- Summary at `quality_reports/sim/sim_<theorem>_summary.md`, one page, ending in the verdict line.

## When Not to Run

- Pure identification claims with no estimator — there is nothing to simulate.
- Comparative statics — verified by direct computation, not simulation.
- Claims requiring infeasible sample sizes ($n = 10^{12}$).
- A simulation will not save a broken proof — escalate to the theorist instead.
