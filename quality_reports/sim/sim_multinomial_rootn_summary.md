# `thm:rootn` at $\mathsf L=2,3,4$ — empirical-vs-asymptotic summary

> **This file's Verdict section is a WORKER SELF-SCORE and is NOT a valid gate input.**
> Under `.claude/rules/agents.md` §2 a creator cannot score its own work: the
> simulation-engineer produces artifacts, the simulation-engineer-critic produces the verdict, and
> `.claude/rules/quality.md` §4 clause 5 reads the **critic's** verdict and only the critic's.
> The pre-2026-08-27 version of this file carried an unqualified "**Matches**" in that position,
> and it was readable as gate 5's verdict for weeks. What follows is a worker's reading of its own
> output, offered so the critic has something to disagree with.

**Claim under test.** `thm:rootn`: $\sqrt n(\hat\theta-\theta^\dagger)\to_d N(0,\Sigma)$ for the
orthogonal one-step of `eq:onestep` on the cross-fitted moment of `def:crossfit`, with an
$\mathsf L$-valued discrete instrument. The theory is general-$\mathsf L$ throughout; the paper's
first two Monte Carlo suites are binary on both designs (`sim_thm_rootn_dgp.R:469`,
`sim_thm_rootn_headroom_dgp.R:341` are each `pw <- cbind(1 - rr, rr)`), and §6 estimates on a
four-category trigger.

**Scripts.** `scripts/simulations/sim_multinomial_rootn.R` (DGPs: `sim_multinomial_dgp.R`);
`scripts/simulations/sim_multinomial_n1defect.R` (the (T-2) hypothesis check, added 2026-08-27);
`scripts/simulations/sim_merged_cardinality.R` (all tables).
**Raw.** `quality_reports/sim/sim_multinomial_rootn.rds` (+ `..._ckpt.rds`),
`quality_reports/sim/sim_multinomial_n1defect.rds` (+ `..._ckpt.rds`).
**Tables.** `paper/tables/sim/sim_merged_rootn_{balanced,skewed,misspec}.tex`,
`sim_merged_seratio.tex`, `sim_merged_precision.tex`, `sim_merged_designs.tex`,
`sim_merged_stopping.tex`, `sim_multinomial_n1defect.tex`.

## Design

$B=120$ replications requested per cell, **112 to 120 used**; $n\in\{400,800,1600\}$;
$\mathsf L\in\{2,3,4\}$ as three coarsenings of one $W$ on one draw, **paired on the cross-fitting
partition stream**. Every arm is summarised on the common subset of draws. $K=5$ folds, one Newton
step from the plug-in OLS start, sandwich variance $J^{-1}(\Psi'\Psi/n)J^{-\top}/n$ at the one-step
iterate. `lf_imax = 100`, set from the $\varphi$-step arm's measured stopping indices.

**Status: 9 of 9 cells complete.** The whole design $\times$ sample-size grid is on disk and every
table below is emitted from it. *The pre-2026-08-27 version of this file said "6 of 9 cells
complete… the $n=1600$ row costs about 4.5 hours and is still computing", and every number in it
was that partial run's.* Tables regenerate without recomputation via
`SIM_SUMMARISE_ONLY=1` on the arm, or by re-running `sim_merged_cardinality.R`, which recomputes
nothing.

## Result

### (T-2) — the hypothesis, measured, and it does not hold

`thm:rootn`(T-2) assumes N1 at $L_\star$: $E[L(\Delta U,\Delta Z)\mid\Delta Z]=0$ a.s., which
`results_s4_asymptotics.tex:317` types as $p(\mathsf L-1)$ scalar conditions. **No multinomial
script measured it before 2026-08-27**; `mdgp_validate()` checks A1, `def:admissible` (B), the cell
shares and the first stage and stops. `sim_multinomial_n1defect.R` computes it.

The entrywise defect $\max_{j,l}\|E[L_{jl}\mid\Delta Z]\|_{L^2}$ as a fraction of
$\max_{j,l}\|L_{jl}\|_{L^2}$ — §5.3's own statistic, to the digit
(`sim_multinomial_n1defect.tex`, Panel A, at $n_{\mathrm{solve}}=640$):

| Design | $\mathsf L=2$ | $\mathsf L=3$ | $\mathsf L=4$ | Block I, DGP-A |
|---|---|---|---|---|
| Balanced | 0.641 (0.012) | 0.558 (0.032) | 0.646 (0.018) | $3.3\times10^{-6}$ / — / 0.191 |
| Skewed | 0.531 (0.030) | 0.591 (0.020) | 0.588 (0.021) | " |
| Misspecified | 0.720 (0.010) | 0.675 (0.020) | 0.688 (0.012) | " |

**N1 fails on all three designs at every cardinality, by three to five times Block I's four-cell
defect and by five orders of magnitude more than its binary one.** Three things make this a
measurement and not an artifact:

- **The control is machine zero.** Re-run with M3 switched off — $\gamma=0$ and $\sigma$ frozen, so
  $\Delta U\perp\Delta Z$ — the same code returns a cell mean of $1.6$ to $2.7\times10^{-14}$
  (Panel C), and $7.6\times10^{-14}$ at the worst of its 72 individual draws. That is the numerical
  floor of the computation, and the smallest live ratio anywhere in the arm, $0.3145$, sits **12.6
  orders of magnitude** above it.
- **It does not shrink in $n$.** Across the three solve-fold sizes the arm realises,
  $n_{\mathrm{solve}}=\lceil0.4n\rceil\in\{160,320,640\}$, the log-log slope runs $-0.133$ to
  $+0.064$ (Panel B). A sampling error would fall; a restriction on the weight class does not.
- **The mechanism is structural, and it is in the implementation.** `solve_balance_weight()`
  represents $\ell$ in an RKHS **over the residual alone** (`orthogonal_theta.R:199`), so
  $\Lambda_{jl}$ is a function of $u$ with no $z$ argument, and `crossfit_once()` anchors it by
  subtracting a **constant** (`orthogonal_theta.R:681`). Design decision M3 makes
  $\Delta U\mid\Delta Z=z\sim N(\gamma z_1z_2,\;0.72+\sigma(z_1)^2)$, a location–scale family with
  a continuum of means, and a bounded function orthogonal to all of them is zero a.e. So the only
  $u$-only weight satisfying N1 on this design is the zero weight. `rem:anchor`'s re-anchoring at
  $b_\star(z)=-E[\int_0^{\Delta U}\ell_\star\mid\Delta Z=z]$ would restore N1 with the same $\ell$,
  and A$2'$(iii) admits that anchor — **the engine does not implement it.**

**What this buys §5.4.** The finding "at the two well-specified designs the cardinality does very
little" is now *attributable*. The defect's spread **across** cardinality within a design is 0.06
to 0.09 against a level of 0.53 to 0.72, so there is no cardinality-varying N1 mechanism on this
suite to produce a cardinality-varying divergence — unlike Block I, where the same statistic moves
by a factor of $6\times10^4$ between two cells and four. The reading is not "N1 holds, so
`thm:rootn` is confirmed at $\mathsf L\ge3$"; it is "**N1 fails at every cardinality by about the
same amount, and what the cardinality does to $\hat\theta$ is measured against that**".

Two things this does **not** establish. It says nothing about §6's data, where the defect is
*estimated* on a panel whose $F(\cdot\mid z)$ is unknown and the population argument above has no
purchase. And it does not show the theory's own $\ell_\star$ fails N1 on this design — only that
the weight the shipped engine builds cannot satisfy it.

### R1/R3 — bias, and a coverage shortfall that a range concealed

Bias at $n=1{,}600$ is inside two of its own Monte Carlo standard errors at all nine balanced cells
and eight of nine skewed. Coverage is the quantity that moved.

**Seven of the eighteen well-specified cells at $n=1{,}600$ sit below $-2$ Monte Carlo standard
errors**, and they are not scattered: three are the constant on `balanced` (0.882, 0.866, 0.866 at
$\mathsf L=2,3,4$; $-2.29$, $-2.70$, $-2.70$ SE) and four are on `skewed` (the constant at
$\mathsf L=2$, and $z_2$ at all three cardinalities, 0.875/0.867/0.867). The balanced constant at
four cells runs **0.863, 0.842, 0.866 across $n=400,800,1{,}600$ — flat**, and skewed $z_2$ moves
*away* from nominal as $n$ grows ($0.905\to0.863\to0.875$ at $\mathsf L=2$). §5.4 currently reports
this only as "coverage sits between 0.866 and 0.975", which is true and conceals that the low end
is persistent, one-sided and non-shrinking.

**`se_ratio` says what kind of failure it is, and it was computed all along.** `summarise_arm()`
has returned $\overline{\mathrm{s.e.}}/\mathrm{s.d.}$ since the arm was written and it appeared in
no table; it is now `sim_merged_seratio.tex`. It is **below one in 77 of 81 cells**, below 0.85 in
42 and below 0.75 in 18. The balanced constant sits at 0.705–0.805 and does not improve in $n$; the
misspecified constant at $\mathsf L=4$ falls to 0.562.

The decomposition (`sim_merged_seratio.tex`, right-hand block): the coverage a centred normal with
that ratio would give, minus the realised coverage, is **within $\pm0.070$ at all 54
well-specified cells, r.m.s.\ 0.024**. *The entire coverage shortfall on `balanced` and `skewed` is
the interval's scale and not its shape* — the limiting normal is not the problem, the sandwich is.
On `misspec` the same statistic is $-0.028$ to $+0.033$ on the slopes and $+0.030$ to $+0.511$ on
the constant, which is the bias the approximation deliberately ignores.

This is what a live N1 defect predicts. With N1 failing, `prp:orthog`(iii)'s only-if half fires and
$\hat\varrho$ enters at first order; the propensity here is a correctly specified multinomial logit,
so it converges at $\sqrt n$ and $\hat\theta$ stays $\sqrt n$-consistent and asymptotically normal —
but the sandwich omits the $\hat\varrho$ term and is wrong by a factor that does not shrink.
*Consistent with, not demonstrated by:* the variance correction itself is not computed here.

### R2 — the rate

$\sqrt n\times$ s.d. is constant under `thm:rootn`. It now carries a Monte Carlo standard error,
computed from the fourth moment rather than the Gaussian formula (the realised kurtosis reaches 8
in the misspecified cells, where the Gaussian form understates by about a third).

It **falls across the grid in 50 of 54 (design, $\mathsf L$, coefficient) triples and rises in
four**, all of them the constant: `balanced` $\mathsf L=3$, $5.571\to6.640$ ($+19.2\%$, **1.50
SE**) and $\mathsf L=4$, $5.178\to5.455$ ($+5.4\%$, 0.45 SE); `misspec` $\mathsf L=3$,
$6.698\to7.943$ ($+18.6\%$, 1.57 SE) and $\mathsf L=4$, $6.031\to8.605$ ($+42.7\%$, **3.40 SE**).
One is not resolvable and one is; before this pass the table let a reader tell them apart not at
all.

### R4 — does the surplus buy precision? **The old answer here was wrong**

The pre-2026-08-27 version of this file read "**Below 1 in 12 of 12 cells**" and "the gain is
monotone in cardinality". Against the completed grid both fail:

- The s.d.\ ratio against $\mathsf L=2$ is **at or above one in 6 of 54 cells**: `balanced`
  $n=1{,}600$ $\mathsf L=3$ at the constant (1.181) and $z_1$ (1.059); `misspec` $n=800$
  $\mathsf L=3$ (1.003) and $\mathsf L=4$ (1.034) at the constant; `misspec` $n=1{,}600$
  $\mathsf L=3$ (1.114) and $\mathsf L=4$ (1.207) at the constant.
- **Monotonicity in $\mathsf L$ fails in 5 of 27** (design, $n$, coefficient) triples, including
  `balanced` $n=1{,}600$ at the constant, where $\mathsf L=3$ (1.181) is *above* $\mathsf L=4$
  (0.970).

§5.4 makes no precision-gain claim. **This file made one and should not have**; the claim is
withdrawn rather than weakened. `sim_merged_precision.tex` carries all 54 ratios.

### R5 — what propensity misspecification costs

Unchanged in direction and now complete. The constant's bias does not fall in $n$ at
$\mathsf L=4$ ($-0.3040$, $-0.3242$, $-0.3830$), $\sqrt n\times$ s.d.\ *rises* (3.40 SE), coverage
of the constant at $n=1{,}600$ is 0.697 / 0.294 / 0.277 down the three cardinalities, and the
paired bias differences against the binary arm are $-0.2287\,(0.0226)$ and $-0.2765\,(0.0241)$ —
10.1 and 11.5 standard errors. **The slopes are untouched**, covering 0.891 to 0.950 at every
cardinality, which is Neyman orthogonality doing what it is for. That design violates (T-4) by
construction and the theorem says nothing about it.

### Two limits, priced rather than disclosed

**Dropped draws.** A cell drawn at $B=120$ and used at $b$ has its coverage inside
$[\hat p\,b/B,\;\hat p\,b/B+(B-b)/B]$ whatever the dropped draws would have done. The bound is now
a generated header line in each per-design table: at most $0.024$ (balanced), $0.032$ (skewed),
$0.063$ (misspec), and at $n=1{,}600$ at most $0.008$. Selection is real and its direction is known
— a draw survives when the nonparametric stage behaved, so the retained figures are optimistic —
but it is bounded and small, at about one Monte Carlo standard error at the thinnest cell.

**The `misspec` arm confounds two things and only one of them is separable here.** It varies the
propensity's specification *and* runs a discrepancy rule that returns the cap (0 of 24 paths fire
at $\mathsf L=4$, $n=1{,}600$). A fixed-$m$ variant of the **$\varphi$-step** already exists and
was not read: `sim_multinomial_phistep_sweep.rds` sweeps $\tau_{\mathrm{DP}}\in\{0,\dots\}$ against
caps $\{15,30,45,60,100\}$, and at $\tau=0$ the rule never fires, so the returned iterate *is* the
cap. At $n=1{,}600$, $\mathsf L=4$, going $m=15\to100$: `misspec` ISE **rises** $0.195\to0.488$ and
$b$ falls $-0.161\to-0.656$, while `balanced` ISE **falls** $0.091\to0.036$. So the cap is not an
independent cause — iterating longer helps where the propensity is right and hurts where it is
wrong, and the rule's failure to fire is a symptom of $\|\hat T_m\|$ being bounded below by the
specification error. **The separation is not available on the $\theta$ side**: whether the
intercept's collapse would shrink at a smaller fixed cap needs the $\theta$ arm re-run with
`lf_imax` fixed, which is about 1.2 hours for the `misspec` $n=1{,}600$ cell alone — past this
machine's 65-minute background kill for a single un-chunked cell — and is not done.

### A hazard found while doing this, armed in the tree now

`sim_multinomial_rootn.R`'s `CFG` carries the md5 of `lf_panel.R` and `orthogonal_theta.R`.
**`lf_panel.R` was edited on 2026-08-26 at 16:48, after the nine-cell run finished at 07:06**, so
the checkpoint's stored key no longer matches the tree. Verified in a sandbox:
`SIM_SUMMARISE_ONLY=1 Rscript scripts/simulations/sim_multinomial_rootn.R` today prints *"cache
discarded, configuration changed"*, summarises **zero of nine cells**, **overwrites
`sim_multinomial_rootn.rds` with an empty summary**, and then dies before writing a table. The raw
per-replication draws survive in `sim_multinomial_rootn_ckpt.rds`, so nothing is unrecoverable —
but the `.rds` every merged table reads would be gone, and the escape hatch that exists to avoid a
three-hour recompute is the thing that destroys it.

This is why `se_ratio` and the s.d.\ standard errors are computed in `sim_merged_cardinality.R`
and not added to `summarise_arm()`: the one-line change that looks right would have discarded nine
completed cells. Two guards were added rather than a note: `sim_merged_cardinality.R` now stops if
`S3` is empty or its row count disagrees with the grid on disk (an empty `S3` passed every prior
assertion and would have emitted five tables with correct headers and no body), and it asserts that
the s.d.\ it recomputes from the checkpoint equals the arm's own in all 81 cells, to $10^{-12}$.

**The provenance consequence is for the writer, not for this file.** Every $\theta$-side number in
the merged tables was produced under the *pre-16:48* `lf_panel.R`. The N1 arm added here runs
against the current tree, but it touches only `solve_balance_weight()`, which lives in
`orthogonal_theta.R` and is unchanged, so the two are not in conflict. Whether the $\theta$ arm
needs re-running against the edited `lf_panel.R` is a question for whoever made that edit.

## Verdict (worker self-assessment; see the banner — not a gate input)

**Matches at large $n$ only, with one hypothesis newly measured and found to fail.**

- The **rate** holds: $\sqrt n\times$ s.d.\ falls or is flat in 50 of 54 triples, and the four
  exceptions are the constant, two of them inside 1.6 Monte Carlo standard errors.
- The **limiting normal** is not contradicted: on the two well-specified designs the coverage
  shortfall is accounted for to r.m.s.\ 0.024 by the standard-error ratio alone.
- The **interval** does not match: `se_ratio` is below one in 77 of 81 cells and does not improve
  across a grid spanning a factor of four in $n$. Seven of eighteen well-specified coverages at
  $n=1{,}600$ are more than two Monte Carlo standard errors under nominal.
- **(T-2) does not hold on any of the three designs**, at any cardinality, by 12.6 orders of
  magnitude over the computation's own floor. The gap is between the theory and the implementation — the
  engine's weight class and anchor, not `thm:rootn` — of the same kind §5.4 already documents for
  C3(ii) and the boundary kernel.
- `misspec` remains a **documented violation** of (T-4) and not a mismatch.

**Open, and for the theorist rather than for this arm:** whether §5.4 should now read the
well-specified coverage shortfall as the priced consequence of a live N1 defect, and whether §6 —
which runs the same engine at $\mathsf L=4$ — inherits the argument.
