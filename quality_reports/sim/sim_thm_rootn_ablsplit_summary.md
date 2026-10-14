# `thm:rootn` at $\mathsf L=4$: which nuisance breaks it

Scope S2. Produced by `scripts/simulations/sim_thm_rootn_ablsplit.R`, seed 20260815, on 8 cores.
Gate: `scripts/simulations/sim_thm_rootn_l2identity.R`, 36/36 `identical()`. Raw cells:
`sim_thm_rootn_ablsplit.rds`.

## What was tested

S1 (`sim_thm_rootn_cardinality_summary.md`) found `thm:rootn`'s limit law failing at $\mathsf L=4$ on the
paper's named design and localised the failure to the nuisance channel, leaving **two** assumptions on the
hook — A5(iv) on $\|\hat\ell-\ell_\star\|$ and A4(iii) on $\|\hat\varrho-\varrho\|$. A theorist cannot act on
a two-assumption finding. This arm splits it:

| arm | $c_\delta$ | $c_\epsilon$ | $c_r$ | isolates |
|---|---|---|---|---|
| $\hat\ell$ only | 0.25 | 1 | 0 | A5(iv) |
| $\hat\varrho$ only | 0.25 | 0 | 1 | A4(iii) |

each at $\mathsf L\in\{2,4\}$. $\mathsf L=2$ is the control, not a courtesy: an arm that diverges at
$\mathsf L=4$ without its binary counterpart says "this nuisance is expensive", not "this nuisance is
expensive *at $\mathsf L=4$*".

Alongside the five S1 measures, each replication decomposes the instrument block. Since
$\hat{\widetilde W}_l=\widetilde W_l-(\hat\varrho_l-\varrho_l)$,

$$\hat L\hat{\widetilde W}-L_\star\widetilde W=\underbrace{(\hat L-L_\star)\widetilde W}_{T_1}-\underbrace{L_\star(\hat\varrho-\varrho)}_{T_2}-\underbrace{(\hat L-L_\star)(\hat\varrho-\varrho)}_{T_3},$$

$T_2$ being first order in $r_n$ and surviving only because Neyman orthogonality kills its expectation. The
arms separate the three exactly: $\hat\ell$-only has $T_2=T_3=0$, $\hat\varrho$-only has $T_1=T_3=0$. All
three are reported scaled by $\sqrt n$, so the mechanism is measured, not inferred from the arm label.

## DGPs, grid, replications

S1's design primitive for primitive: DGP-A, $(\mu,s,a,\alpha)=(2,3,\tfrac34,0.32)$, $p=4$, $d_Z=3$,
$c_\delta=0.25$, smooth $h$, $h_{\text{bias}}=0$, $\varepsilon_\varrho=0.10$, ridge $10^{-10}$, nuisances
**injected** at the theorem's own rates. $B=5000$ at **every** cell.

**$n\in\{1000,8000\}$, not S1's three points, and the reason is cost, said plainly.** Measured on this host,
one replication at $\mathsf L=4$, $n=64{,}000$ costs 2.20 s; $B=5000$ on `SIM_CORES` workers is 45 min per
cell, 3 hours for the four (arm $\times$ cardinality) combinations at that $n$ alone. Thinning $B$ at the top
of the grid instead would reintroduce the noise-floor defect S1 was built to avoid. Two points carry a trend
here because the trend is well resolved between them: on S1's own full arm the residual moves
$0.8556\,(0.0068)\to0.9093\,(0.0080)$ across exactly this leg, a 5.1 MC SE separation.

**What that costs the finding.** S1's largest single jump is on the $8{,}000\to64{,}000$ leg. A *flat* arm
here could still diverge above $n=8{,}000$, so a negative result on this grid is weaker than a positive one.
Both results below are positive in the relevant direction, so this caveat binds on neither.

## The split

Worst of the five measures, in MC SE units (`_seunits.tex` has all five):

| arm | $\mathsf L$ | $n=1{,}000$ | $n=8{,}000$ | |
|---|---|---|---|---|
| $\hat\ell$ only | 2 | 6.29 | **1.75** | converges |
| $\hat\ell$ only | 4 | 6.49 | **5.03** | converges |
| $\hat\varrho$ only | 2 | 5.95 | **2.97** | converges |
| $\hat\varrho$ only | 4 | 7.08 | **12.10** | **diverges** |

Linearisation residual, which `eq:rootn` requires to vanish, with its MC SE and the implied exponent
$\beta$ in $n^\beta$ over the leg:

| arm | $\mathsf L$ | $n=1{,}000$ | $n=8{,}000$ | $\beta$ | 95% coverage |
|---|---|---|---|---|---|
| $\hat\ell$ only | 2 | 0.5925 (0.0033) | 0.4155 (0.0022) | $-0.171$ | $0.943\to0.949$ |
| $\hat\ell$ only | 4 | 0.6630 (0.0041) | 0.4636 (0.0028) | $-0.172$ | $0.941\to0.946$ |
| $\hat\varrho$ only | 2 | 0.6611 (0.0039) | 0.4744 (0.0028) | $-0.160$ | $0.954\to0.951$ |
| $\hat\varrho$ only | 4 | 0.8742 (0.0069) | 0.9134 (0.0082) | $\mathbf{+0.021}$ | $0.945\to\mathbf{0.923}$ |

**The $\hat\varrho$ arm carries the divergence; the $\hat\ell$ arm does not.** The $\hat\ell$ arm decays at
$\beta=-0.171$ at $\mathsf L=2$ and $-0.172$ at $\mathsf L=4$ — the *same* rate, which is what "the
cardinality is not the problem in this channel" looks like. The $\hat\varrho$ arm decays at $-0.160$ at
$\mathsf L=2$, indistinguishable from the $\hat\ell$ arm, and stops decaying at $\mathsf L=4$.

**Each arm reproduces one of S1's rows, which is the cross-check that the split is clean.** The $\hat\ell$
arm at $\mathsf L=4$ ($0.663\to0.464$) reproduces S1's *$h$-only* arm ($0.657\to0.455$) to within 2%:
switching $\hat\ell$ on adds essentially nothing. The $\hat\varrho$ arm at $\mathsf L=4$
($0.874\to0.913$) reproduces S1's *full* arm ($0.856\to0.909$) to within 2%: switching $\hat\varrho$ on
reproduces the whole failure. At $\mathsf L=2$ the $\hat\varrho$ arm ($0.661\to0.474$) reproduces S1's full
$\mathsf L=2$ arm ($0.657\to0.474$) to within 0.6%.

**This corrects S1.** S1's summary wrote that the divergence "appears only when $\hat\ell\ne\ell_\star$ and
$\hat\varrho\ne\varrho$ are *both* switched on". S1 ran three arms — all-exact, $h$-only, full — which can
establish that the divergence needs *something* beyond $h$ but cannot say *which*. That sentence was an
over-reading of its own ablation and is now refuted: $\hat\varrho$ alone suffices.

## The mechanism: $T_2$, and orthogonality in the propensity direction

$\|T_2\|=\sqrt n\,\|\mathbb E_n[L_\star(\hat\varrho-\varrho)]\|$, the first-order propensity term
(`_channel.tex`):

| $\mathsf L$ | $n=1{,}000$ | $n=8{,}000$ | $\beta$ |
|---|---|---|---|
| 2 | 0.3374 (0.0036) | 0.2696 (0.0029) | $-0.108$ |
| 4 | 0.5687 (0.0060) | 0.8431 (0.0089) | $\mathbf{+0.189}$ |

The two reference exponents are not fitted, they are read off the design. If orthogonality holds in the
propensity direction, $T_2$ is a centred average and $\|T_2\|=O_P(\sup|L_\star|\,r_n)$, so
$\beta=-\alpha=-0.320$. If it fails outright, $T_2$ carries a non-vanishing mean and
$\|T_2\|\asymp\sqrt n\,r_n$, so $\beta=\tfrac12-\alpha=+0.180$.

**Measured $\beta=+0.189$ at $\mathsf L=4$, against $+0.180$ predicted for outright failure.** ~~At
$\mathsf L=2$, $\beta=-0.108$: decaying, but slower than $-0.320$, so there is leakage at $\mathsf L=2$ too —
sub-critical there and super-critical at $\mathsf L=4$.~~ $T_2$ is also two orders of magnitude larger than
$T_1$ (0.006–0.020, decaying at both cardinalities), so it is not a minor term that happens to grow.

> **CORRECTED 2026-08-15 — THERE IS NO ORTHOGONALITY LEAKAGE AT $\mathsf L=2$, AND THE STATISTIC ABOVE
> IS NOT THE TERM THE TWO REFERENCE EXPONENTS WERE DERIVED FOR.**
> `scripts/simulations/sim_thm_rootn_n1defect.R` computes the N1 defect in population, not by
> estimation: $\max_{j,l}\|E[L_\star\mid\Delta Z]_{jl}\|_{L^2}$ is $8.23\times10^{-6}$ at $\mathsf L=2$
> — $3.3\times10^{-6}$ of $\|L_\star\|$, i.e. **exactly zero up to the antiderivative grid**, because
> $L_\star$ is odd in $u$ there and $\Delta U$ is symmetric — against **0.729**, or 19% of $\|L_\star\|$,
> at $\mathsf L=4$. By `prp:orthog`(iii) that makes orthogonality in the propensity direction **exact**
> at $\mathsf L=2$. The $-0.108$ cannot be leakage.
>
> **What it is instead.** Line 289 of this arm's own script evaluates $L_\star$ at
> `du` $=\Delta U-\Delta h$ (line 272), not at $\Delta U$. So the coded $T_2$ is
> $L_\star(\Delta U-\Delta h,z)(\hat\varrho-\varrho)$ and contains the $\sqrt n\|h\|r_n$ cross-product
> the theorem prices *separately* — an $\mathsf L$-free contamination with a non-zero conditional mean,
> present in both arms and visible only where the genuine defect is absent. The exponents $-\alpha$ and
> $\tfrac12-\alpha$ quoted above are right for $L_\star(\Delta U,z)\mathsf r$ and are the wrong yardstick
> for the statistic as coded.
>
> **Measured, by re-running this accumulation alone with $h$ off** ($B=1500$, DGP-A, same $c_\delta$,
> $c_r$, fold rule and targets; Panel E of `sim_thm_rootn_n1defect.tex`):
>
> | $\mathsf L$ | $h$ | $n=1{,}000$ | $n=8{,}000$ | $\beta$ (MC SE) |
> |---|---|---|---|---|
> | 2 | on | 0.3417 (0.0065) | 0.2776 (0.0053) | $-0.100$ (0.013) |
> | 2 | **off** | 0.2448 (0.0047) | 0.1308 (0.0026) | $\mathbf{-0.302}$ (0.013) |
> | 4 | on | 0.5950 (0.0109) | 0.8200 (0.0155) | $+0.154$ (0.013) |
> | 4 | **off** | 0.5358 (0.0100) | 0.8225 (0.0154) | $\mathbf{+0.206}$ (0.013) |
>
> The $h$-on rows reproduce this file's shipped 0.3374/0.2696 and 0.5687/0.8431 to within 1.4 MC SE on a
> separate stream, which is what makes the $h$-off rows comparable. **$\mathsf L=2$ with $h$ off lands
> 1.4 MC SE from $-\alpha=-0.320$**; with $h$ on it is 17 MC SE away. **$\mathsf L=4$ with $h$ off lands
> 2.0 MC SE from $\tfrac12-\alpha=+0.180$** and does not decay. Every verdict below about A4(iii) and
> the propensity direction at $\mathsf L=4$ **stands and is sharpened**; only the "leakage at
> $\mathsf L=2$ too" clause is withdrawn.

## The contraction norm: S1's hypothesis, tested and refuted

S1 hypothesised that A5(iv) prices $\|\hat\ell-\ell_\star\|$ in the **Frobenius** norm while $\hat J$ and
$\psi$ consume the **contraction** $\sum_l(\hat\ell-\ell_\star)_{\cdot l}\widetilde W_l$, and that at
$\mathsf L\ge3$, $\Omega=\operatorname{diag}(\varrho)-\varrho\varrho'$ being non-diagonal breaks the
control. Both norms are now measured, in $L^2(P)$, against the true $\widetilde W$:

| $\mathsf L$ | $n$ | consumed/priced, $\hat\ell-\ell_\star$ | consumed/priced, $\hat L-L_\star$ |
|---|---|---|---|
| 2 | 1,000 | 0.4627 | 0.4617 |
| 2 | 8,000 | 0.4629 | 0.4623 |
| 4 | 1,000 | 0.4200 | 0.4200 |
| 4 | 8,000 | 0.4195 | 0.4195 |

The ratio is flat in $n$ — as it must be, since both norms are scaled to the same injected target, so only the
constant is informative — and it is **smaller at $\mathsf L=4$ than at $\mathsf L=2$**, by 9.3%. The
Frobenius norm A5(iv) prices is therefore *conservative* at $\mathsf L=4$, not slack. **The seam S1 proposed
does not exist in this design, and the measurement moves in the wrong direction for the hypothesis.** Two
independent refutations, then: the arm that should have carried the divergence does not, and the norm gap
that should have opened closes.

## Verdict

**Mismatch exceeds MC error at the largest $n$ reached and grows in $n$ — flag to theorist, against A4(iii)
and the propensity direction of the orthogonality argument, not A5(iv).**

- $\hat\ell$ only, $\mathsf L\in\{2,4\}$: **matches at large $n$** (worst 1.75 and 5.03 MC SE at
  $n=8{,}000$, both falling; identical decay exponents across cardinalities). A5(iv) is not implicated.
- $\hat\varrho$ only, $\mathsf L=2$: **matches at large $n$** (2.97 MC SE, falling).
- $\hat\varrho$ only, $\mathsf L=4$: **persistent mismatch**, 12.10 MC SE at $n=8{,}000$ and rising, 95%
  coverage 0.923, residual flat-to-rising where `eq:rootn` needs it to vanish.

As in S1 this is not evidence that the proof is wrong: the design injects nuisances at a fixed rate constant,
and `thm:rootn` is asymptotic in $n$ at fixed $\mathsf L$ with no claim of uniformity in $\mathsf L$. It is
evidence that the surviving first-order propensity term $T_2$ is not negligible at $\mathsf L=4$ over the
sample sizes an OBES readership has, and that the term's growth exponent matches the non-orthogonal
prediction $\tfrac12-\alpha$ to within 0.01.

**For the theorist, one question rather than two:** does the orthogonality argument's derivative in
$\varrho$ vanish at $\mathsf L\ge3$, or does it vanish only cell by cell in a way that does not survive the
contraction $\sum_{l}$ against a non-diagonal $\Omega$? `assumptions_main.tex` records that $\Omega$ "enters
as the conditional covariance and never as a weight" and that $\widetilde W^\Omega:=\Omega^{-1}\widetilde W$
"exists and is worth knowing". S2 says the seam is in the $\varrho$-derivative of the moment, not in the
norm A5(iv) uses.

**Not run, and what it would settle (S3):** the $\hat\varrho$-only arm at $n=64{,}000$ and at
$\mathsf L=3$, which would confirm the $\beta=+0.18$ exponent on a third point and locate the onset in
$\mathsf L$. At $\mathsf L=4$ that is one 45-minute cell.
