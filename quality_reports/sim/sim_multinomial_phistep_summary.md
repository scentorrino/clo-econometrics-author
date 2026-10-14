# The $\varphi$-step at $\mathsf L\ge3$ — empirical-vs-asymptotic summary

**Claim under test.** A7 and `results_s3_estimation.tex` eq:lfsched(c): the Landweber–Fridman
step stops at $\hat m=\min\{m\le\bar m_n:\|\hat T_m\|_{L^2(\Pi)}\le\tau_{\mathrm{DP}}\hat\delta^{\mathrm{eff}}_{n,k}\}$,
$\hat m=\bar m_n$ when the set is empty. `lf_panel.R` collapses
$\tau_{\mathrm{DP}}\mathsf c_{14}\ln n$ into `tau_dp = 0.7`, registered as `c14_realised`.

**Script.** `scripts/simulations/sim_multinomial_phistep.R` (DGPs: `scripts/simulations/sim_multinomial_dgp.R`).
**Raw.** `quality_reports/sim/sim_multinomial_phistep.rds`, `..._sweep.rds`, `..._best.rds`.

## Design

| | |
|---|---|
| DGPs | `balanced` (near-equal cells, strong first stage), `skewed` (shares 0.68/0.13/0.07/0.13, matching §6's realised shape, first stage halved), `misspec` (a $z_1z_2$ interaction in cell 3's propensity index, outside the family the estimator fits) |
| Cardinalities | $\mathsf L=2,3,4$ — three coarsenings of **one** $W$ on **one** draw, paired on the RNG anchor |
| $n$ | 400, 800, 1600 |
| $B$ | 24 paths per cell; each path run to $m=100$ with the stopping tests disabled |
| Truth | $\varphi(x)=\sin(2\pi x)/2$; $b_m=\langle\hat\varphi_m,\varphi\rangle/\|\varphi\|^2$ |

`lf_path()` is proved equal to `lf_solve()` on every invocation: max difference on the
discrepancy path, the noise path and $\hat\varphi$ is `0.0e+00`.

**Design validity** (`sim_multinomial_dgpvalid.tex`, $n=6\times10^5$): $\mathbb E[\Delta Z\Delta U]$
within 2.6 studentised units of zero on all nine (design, $\mathsf L$) combinations; A1 at the true
$\varrho$ within 2.6 units. At the **fitted** $\hat\varrho$: 0.0002–0.0008 ($|t|\le1.5$) on
`balanced` and `skewed`, against **0.0104 / 0.0235 / 0.0345** ($t=22.8/52.3/112.7$) at
$\mathsf L=2/3/4$ on `misspec`.

## Result

### 1. $\hat\varphi$ recovers at $\mathsf L=4$ when $\hat\varrho$ is consistent

$b$ at the oracle stop, `balanced`, $n=1600$: **0.809 (0.007)** at $\mathsf L=2$, **0.784 (0.013)**
at $\mathsf L=3$, **0.700 (0.027)** at $\mathsf L=4$ — the last is $+26.3$ Monte Carlo standard
errors from zero. $b_m$ rises monotonically in $m$ at every cardinality and is still rising at
$m=100$ at $\mathsf L=4$. Held-out `skewed`, $n=1600$: 0.683 / 0.581 / 0.488.

### 2. The reported anti-correlation is a propensity-specification artifact

On `misspec`, $n=1600$: $b$ at the cap is **+0.806 (0.078)** at $\mathsf L=2$, **−0.167 (0.081)**
at $\mathsf L=3$, **−0.665 (0.143)** at $\mathsf L=4$. The discrepancy rule fires 21/24, 6/24 and
**0/24**; the ratio $\|\hat T\|/\hat\delta_n$ at the cap is 0.45, 0.94, **1.88** and grows in $n$
(1.12 → 1.50 → 2.03 at $\mathsf L=4$ over $n=400,800,1600$) — a fixed misspecification over a
noise level falling at $n^{-1/2}$.

The 2026-08-11 probe reported $b=-0.623$ at $n=1600$, $\mathsf L=4$. `misspec` retains that
probe's propensity **and nothing else** and reproduces $-0.665\,(0.143)$.

### 3. $\tau_{\mathrm{DP}}$ is not the $\mathsf L$-dependent knob; $\bar m$ is

Ratio at the oracle stop, pooled over the two correctly-specified designs and the whole $n$ grid
(144 paths each):

| $\mathsf L$ | median | IQR |
|---|---|---|
| 2 | 0.493 | [0.34, 0.78] |
| 3 | 0.539 | [0.42, 0.71] |
| 4 | 0.573 | [0.47, 0.69] |

Heavily overlapping — **no material $\mathsf L$-dependence, so an $\mathsf L$-aware
$\tau_{\mathrm{DP}}$ is not supported.** What *is* $\mathsf L$-dependent is the iteration count the
oracle wants: median $\hat m$ = **36 [18, 87] / 70 [30, 100] / 100 [64, 100]** at
$\mathsf L=2/3/4$.

### 4. What the shipped constant costs, and the held-out check

A $(\tau,\bar m)$ sweep on the cached paths (`sim_multinomial_tau.tex`), chosen on `balanced`
and reported on held-out `skewed`:

| $\mathsf L$ | chosen $(\tau,\bar m)$ | ISE, held-out | ISE at (0.70, 60) | change |
|---|---|---|---|---|
| 2 | (0.00, 15) | 0.0991 (0.0057) | 0.1134 (0.0094) | −12.7% |
| 3 | (0.00, 30) | 0.0958 (0.0060) | 0.1081 (0.0063) | −11.4% |
| 4 | (0.00, 60) | 0.0936 (0.0069) | 0.1145 (0.0053) | −18.3% |

$\tau=0$ — never fire, run to the cap — is at least as good as every positive $\tau$ at every
$(\mathsf L,\bar m)$ tested. **At the implemented level the discrepancy principle is not buying
anything over a fixed iteration budget**, and the budget it should be paired with grows with
$\mathsf L$.

## Verdict

**Matches** on the two designs whose propensity is in the family the estimator fits: $\hat\varphi$
recovers $\varphi$ at $\mathsf L=3$ and $\mathsf L=4$, with $b$ increasing in $n$ and the shape
error falling. The $\mathsf L\ge3$ machinery is sound.

**Persistent mismatch** on `misspec`, at $\mathsf L\ge3$ only — and it is a **documented violation
of thm:rootn's own nuisance-rate hypothesis** ((T-4), eq:foldrates), not a failure of the result.
Reported, not repaired.

**No shipped constant was changed.** `scripts/R/lf_panel.R` and `scripts/R/orthogonal_theta.R` are
byte-identical to their state before this work; `paper/tables/sim/sim_multinomial_onestep.tex`
regenerates with md5 `56767b4bd77ed10066373d60bc63a5d7`, unchanged, and its checkpoint is reused
because the engine fingerprint matches. Two items are referred to the author in the handoff: the
$\tau$/$\bar m$ evidence above, and the fact that the implemented level drops eq:lfsched's
$\ln n$ and its stagewise second term.
