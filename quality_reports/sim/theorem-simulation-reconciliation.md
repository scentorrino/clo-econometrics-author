# Reconciling `thm:rootn` with the Monte Carlo

**Date:** 2026-08-03
**Question put by the author:** *"Either the theorem is wrong or the simulations are."*
**Answer: neither.** The two agree; they were measured in different regimes. This file gives the
arithmetic so the claim is checkable rather than asserted.

---

## 1. The budget, and where the shipped design sits

The remainder the theorem must dominate is

$$\sqrt n\,\delta_n^{2} \;=\; n^{\,1/2-2\kappa\alpha}\,(\ln n)^{2\kappa},
\qquad \kappa=\frac{2\mu}{2\mu+1},\quad \alpha=\frac{r}{2r+d_Z},$$

with $\delta_n=(\hat\delta_n\ln n)^{\kappa}$ and $\hat\delta_n=n^{-\alpha}$
(`sim_thm_rootn_dgp.R:126–128`). The theorem's operative hypothesis A5(ii) is
$\delta_n=o_P(n^{-1/4})$, i.e. **this budget $\to 0$**. The frontier `eq:frontier` is exactly the
condition that it does: $\kappa\alpha>\tfrac14$.

Shipped design (`sim_thm_rootn_dgp.R:106–116`): $(\mu,s,a,r,d_Z)=(2,\,3,\,\tfrac34,\,\tfrac83,\,3)$.

| | value |
|---|---|
| $\kappa$ | $0.8$ |
| $\alpha$ | $0.32$ |
| $\kappa\alpha$ | $\mathbf{0.2560}$ |
| frontier threshold | $0.25$ |
| **margin** | $\mathbf{0.0060}$ |
| power of $n$ in the budget | $\mathbf{-0.012}$ |
| power of $\ln n$ in the budget | $\mathbf{+1.60}$ |

**The design clears the frontier by six thousandths.** In $r$ terms: `eq:frontier` requires
$r>d_Z(2\mu+1)/(2(2\mu-1)) = 3\cdot\tfrac56 = 2.5$, and the design runs $r=8/3=2.667$.

## 2. The budget *rises* across the entire experiment

Because the $\ln n$ power ($1.6$) swamps the $n$ power ($-0.012$) at any human sample size:

$$\frac{d}{d\ln n}\ln\big(\sqrt n\,\delta_n^2\big) \;=\; -0.012 + \frac{1.6}{\ln n},$$

which is **positive** until $\ln n = 1.6/0.012 = 133.3$.

| $n$ | 125 | 1,000 | 8,000 | 64,000 | 181,019 |
|---|---|---|---|---|---|
| $\sqrt n\,\delta_n^2$ | 11.72 | 20.27 | 30.13 | 41.00 | **46.74** |

Slope at the largest cell is still $+0.120$. **The remainder the estimator must overcome gets
larger, not smaller, at every sample size the experiment reached.**

### Two independent checks that this is the paper's own arithmetic

- The turning point computes to $n=10^{57.9}$ — the paper prints $n^\ast\approx10^{58}$ (§5 opening,
  from `rem:rootnscope`(5)).
- The crossing below 1 computes to $\approx10^{394}$ — `sim_thm_rootn_crossings.tex` prints
  $\log_{10}n = 394.4$.

Both reproduced from the definition alone. The theory, the shipped tables and this note agree.

## 3. What the experiment therefore tested

**Not the theorem.** The theorem describes $\sqrt n\,\delta_n^2\to0$; the experiment ran where that
quantity is 12 to 47 and increasing. It measured the remainder — which is what §5 already says in
its own voice ("the gaps are the remainder and not the theorem").

**The ablation is the corroboration.** Setting nuisances exact zeroes the remainder by
construction, and there (`sim_thm_rootn_ablation.tex`):

| $n$ | 1,000 | 8,000 | 64,000 |
|---|---|---|---|
| 95% coverage | 0.951 | 0.948 | 0.952 |
| residual | 0.147 | 0.052 | 0.019 |

Successive ratios **2.83** and **2.74** against $\sqrt8=2.828$ — exact $\sqrt n$ scaling, nominal
coverage. **A false theorem does not do this.**

So theorem and simulation say the same thing: the estimator misbehaves at these $n$. The theorem
adds that it eventually will not, and "eventually" is $10^{58}$.

## 4. Why the $c_\delta$ contrast is the same fact

$c_\delta$ multiplies $\delta_n$, so it scales the budget **quadratically**. At $c_\delta=0.25$ the
budget is $1/16$ of §1's table: $46.74/16 = 2.92$ at $n=181{,}019$. That is why the
$c_\delta=0.25$ arm nearly cleared at the top cell while $c_\delta=1$ failed everywhere — and it is
the "divide by 16" the prose already reports. The constant, not the theorem, separates the two arms.

## 5. The open question, and the test that settles it

Everything above establishes that the shipped experiment *cannot* refute the theorem. It does not
establish that the theorem binds anywhere reachable. Getting the budget under 1 at
$n\approx181{,}019$ needs roughly $\kappa\alpha\ge0.44$:

| $\mu$ | $r$ | $d_Z$ | $\kappa\alpha$ | budget at 181,019 |
|---|---|---|---|---|
| 2 | 8/3 | 3 | 0.256 | 46.74 *(shipped)* |
| 3 | 10 | 1 | 0.408 | 1.56 |
| 5 | 20 | 1 | 0.443 | 0.86 |
| 10 | 50 | 1 | 0.471 | 0.54 |

**A run at such a design was dispatched 2026-08-03 with the decision rule fixed in advance:**

- nominal coverage where the budget is below 1 → the theorem binds at a feasible $n$; the shipped
  verdict is about the shipped *design*, not the theorem;
- coverage still off nominal there → **a real problem**, with the remainder explanation exhausted;
- no valid DGP constructible with budget below 1 → a first-order finding in its own right.

### RESULT, 2026-08-03: **BRANCH (1). The theorem is confirmed at a feasible $n$.**

24 of 51 cells, $B=5{,}000$ throughout, at **Design H** $(\mu,s,a,r,d_Z,p_K)=(5,4,\tfrac25,\tfrac{21}8,1,8)$,
$\kappa\alpha=0.3818$ — **frontier margin 0.132, twenty-two times the shipped 0.006.**

At $c_\delta=0.25$ the realised budget is **below 1 at every cell of both DGPs** (0.397–0.721,
*falling* in $n$; the shipped arm at the same constant runs 0.73–2.92 and *rises*). At the
pre-committed criterion, **14 of 16 below-budget cells pass**, and the whole five-measure battery
passes at $n\ge8{,}000$ in both laws. The cross-design contrast at matched $n$ and matched constant,
sd-ratio in MC SE units — this is the measure the shipped verdict failed on:

| $n$ | shipped: budget → $z$ | Design H: budget → $z$ |
|---|---|---|
| 22,627 | 2.216 → **3.37** | 0.556 → 0.18 |
| 8,000 | 1.883 → **3.09** | 0.631 → 0.61 |
| 2,828 | 1.566 → **4.93** | 0.690 → 1.74 |
| 1,000 | 1.267 → **5.83** | 0.721 → 2.12 |

**So "matches at its limit law at large $n$ only" is a statement about the shipped DESIGN, not about
`thm:rootn`.** Artifacts: `paper/tables/sim/sim_thm_rootn_headroom_*.tex` (8 tables, each printing
its own $B$), `paper/figures/sim/sim_thm_rootn_headroom_{qq,budget}.pdf`.

### ⚠ §5's DESIGN TABLE ABOVE IS WRONG — corrected 2026-08-03

**It drops A5(i), and the error is exactly in the direction that flattered the plan.** A5(i) sets
$\hat\delta_n=\max\{\hat\delta_n^{(T)},\hat\delta_n^{(\varrho)}\}$ with
$\hat\delta_n^{(T)}=O_P(n^{-1/2}\sqrt{\ln n})$ — a **parametric floor**. The table used the
propensity branch alone. Pushing $\alpha$ up to buy frontier headroom drives the propensity branch
*below* that floor, at which point **$\alpha$ stops mattering entirely**.

Re-verified independently at $n=181{,}019$:

| $\mu$ | $r$ | $d_Z$ | §5 table (wrong) | literal A5(i) |
|---|---|---|---|---|
| 2 | 8/3 | 3 | 46.74 | **46.74** — shipped design unaffected |
| 3 | 10 | 1 | 1.56 | **8.07** |
| 5 | 20 | 1 | 0.86 | **6.35** |
| 10 | 50 | 1 | 0.54 | **5.20** |

At $(5,20,1)$ the parametric branch is $0.00818$ against the propensity branch's $0.00272$ — the
floor binds. **No shipped number changes**, because at $\alpha=0.32$ the propensity branch dominates.

**The floor is the real constraint:**
$$\sqrt n\,\delta_n^2 \;\ge\; n^{-1/2}(\ln n)^3 \;=\; 4.17 \ \text{ at } n=181{,}019,\ \text{ for \emph{every} configuration,}$$
approached only as $\mu\to\infty$. **At $c_\delta=1$ no admissible design clears budget anywhere on
this grid** — the first crossing is $n\approx2.4\times10^7$. So the experiment succeeded through the
**constant**, not the configuration, and $r=20$ was never the lever: once $\alpha\ge0.397$ the budget
is *invariant to $r$ to twelve digits*. Design H accordingly runs $r=21/8=2.625$, **no smoother than
the shipped $8/3$**, and buys its headroom from $\mu$ alone.

Two further reasons $r=20$ was unreachable: `eq:lxwindow` against `lem:unifop` Step 4's cap
$s\le p_K+\tfrac12$ bounds $\alpha<0.469$ at $p_K=8$, so $(5,20,1)$ would need $s>22.5$ against
$s\le8.5$.

## 6. The finding for the paper regardless of how §5 resolves

$\kappa\alpha\gtrsim0.44$ means a propensity score of Hölder order $\approx20$ against a single
control. That is not a plausible applied configuration, and the application's own feasibility table
(`paper/tables/app_tsp_feasibility.tex`) runs at $\kappa\alpha = 0.078$–$0.400$, **inside the
frontier only at $d_Z=0$** and needing $n\approx1.36$ million even there.

This is not the theorem being wrong. It is the theorem's operative regime being narrow, and the
paper already has the honest instrument for it — the rate-floor corollary of §4, which is what
describes any sample anyone will run. **Recommendation: promote that sentence from the closing line
of §5 to explicit framing.** A referee who does this arithmetic will do it in the report; it lands
better as the paper's own statement than as an objection.

---

## Reproducing §§1–2

```r
budget <- function(n, mu, r, dz) {
  k <- 2*mu/(2*mu+1); a <- r/(2*r+dz)
  sqrt(n) * ((n^(-a))*log(n))^(2*k)
}
sapply(c(125,1000,8000,64000,181019), budget, mu=2, r=8/3, dz=3)
#  11.72  20.27  30.13  41.00  46.74
2*(2*2/(2*2+1)) / (2*(2*2/(2*2+1))*(8/3/(2*8/3+3)) - 0.5)   # 133.3 = ln n at the turn
```
