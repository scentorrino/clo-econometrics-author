# Monte Carlo verification — `thm:rootn`, `panel-npiv-discrete`

**Agent:** simulation-engineer · **Round 3** (round 1: 45/100; round 2: 81/100; round-2 φ-step re-audit: 56/100) · **Date:** 2026-08-01
**Theory read at:** dispatch 12 (theorist-critic 97/100). Theory artifacts were read, not edited.

> **Round-3 scope.** This round corrects the **φ-step arm only**
> (`sim_thm_rootn_phistep.R`). One CRITICAL (a sign error in the discrepancy
> residual) and two MAJORs (Π\_t implemented as counting measure; κ computed with
> an absolute-units floor) are fixed and everything the φ-step arm emits is
> regenerated. **The limit-law arm is untouched and its verdict — "Matches at
> large $n$ only" — stands**: `sim_thm_rootn_limitlaw.R` is byte-identical
> (MD5 `7645e3e5913d254a24f76c8ed2d7139f`, unchanged), it was not re-run, and none
> of its outputs was rewritten. Sections **B1, B2, B3, D3d** and the **Verdict**
> below are round-2 text about that arm and are unchanged.
>
> **A round-2 headline is withdrawn as an artefact of the bug**, and the corrected
> comparison it rested on now goes the other way in half the cells. See
> **Round 3** below, which is the authoritative account of everything φ-step.

## What was tested

`thm:rootn`: $\sqrt n(\hat\theta-\theta_\dagger)=J^{-1}n^{-1/2}\sum_i\psi_\star(O_i)+o_P(1)\to_d N(0,J^{-1}\Sigma J^{-1\prime})$, with $\hat V\to_p J^{-1}\Sigma J^{-1\prime}$ (`lem:sandwich`), $J,\Sigma$ of `eq:JSig`.

| Arm | Script | Answers |
|---|---|---|
| Limit law | `sim_thm_rootn_limitlaw.R` | coverage, studentised quantiles, $\hat V$ consistency, linearisation residual, **bias arm** |
| Jacobian sign | `sim_thm_rootn_jacobian.R` | $\partial_\theta\bar\psi_n=-\hat J$, one-step direction, second summand of $J$, anchor |
| Remainder budget | `sim_thm_rootn_budget.R` | the four Step-4 products on a log-log grid |
| $\varphi$-step | `sim_thm_rootn_phistep.R` | discrepancy stop vs `eq:cap`, Lepskii arm, two condition numbers, **injection geometry** |

## Round-2 changes

All four arms were **re-run end to end from the shipped source in one detached execution** (`phi 0 / limitlaw 0 / jacobian 0` exit codes). Nothing in `paper/tables/sim/` was regenerated from a stale `.rds`.

1. **$B$ is now constant at 5,000 across the whole grid** (was 5,000 up to $n=22{,}627$ and 2,000 above — i.e. halved exactly at the two cells where the round-1 verdict was pronounced).
2. **`N_CORES` is a fixed constant** (`SIM_CORES <- 8L`), not `detectCores()-1`. With `mc.preschedule=TRUE` the replication→substream map depends only on `mc.cores`, so every number now reproduces on any host.
3. **`eq:cap` has exactly one implementation.** The dead `cap_mbar()`/`band_hu()` — which implemented `eq:cap` with proportionality constant 1 while the live path realised $\omega_{\rm thy}$ at 79–121 — are gone; `band_hu()`, `omega_norm()` and `cap_mbar()` are now the single source and the $\varphi$-step calls them.
4. **Checkpoints carry an MD5 fingerprint of every source file** that defines a replication and are discarded when any changes. Checkpoint writes are atomic (temp + rename) with retry.
5. **Bias arm added** (D3d): the injected structural error's *mean* is swept from zero to fully deterministic at fixed $\|h\|_{L^2(\pi)}$.
6. **$\mathsf c_{14}=3\times10^{-2}$ added**: a transition value where the discrepancy rule is doing something other than returning the cap, so the Lepskii comparison is no longer made only where the rule saturates by construction. *(Round 3: the value is still in the transition — at $\mathsf c_{14}=3\times10^{-2}$ the branch mix is genuinely three-way — but under the round-2 sign error "something other than returning the cap" could only mean "returning $m=1$", so the intended repair did not land.)*
7. Runtime assertions on the stopping-rule invariants; INV-17 fixed in all four arms' table emission.

## Priority 1 — the $\varphi$-step arm is now reproducible

**The round-1 defect, stated exactly.** Every branch of the stopping rule returns 1, $\bar m_n$, or a bisection result in $[1,\bar m_n]$, so $\hat m^{(1)}\le\bar m_n$ **per replication**, hence $\overline{\hat m^{(1)}}\le\overline{\bar m_n}$ as an identity. The shipped `.rds` violated it in **5 of 30 cells** (excess 14,439 / 71,391 / 132,915 / 35,696 / 20,729). Separately, in cells where stage 1 saturates in every replication, $\hat m^{(1)}=\bar m_n$ replication by replication, so the two column means must agree to the digit; across the 18 such cells they differed by up to **9.5%**. And the $\bar m_n$ column, which is free of `prelim` and $\mathsf c_{14}$ by construction, spread **1.222 / 1.156 / 1.049** across cells at $n=500/2000/8000$.

**Diagnosis: provenance, not formula.** No change to the cap *formula* can produce a violation, because the bound is structural. A violation is possible only if the stored $\bar m_n$ is not the cap the loop used — i.e. the aggregated object mixed cells produced by different versions of the replication code. The checkpoint resumed on a design match alone, so cells computed under an earlier `phistep_rep()` were merged with cells computed under a later one and the merged object was tabulated. Confirmatory: the refactor of the cap path is *numerically identical* to the round-1 inline expression (verified to 0.0e+00 on $h_u$, $\omega_n$ and an identical integer cap), so the fix cannot be what removed the violations.

The `.tex` was **faithful** to the `.rds`. The "3 violations in the table, 5 in the `.rds`" gap is a table-design artifact — Panel A printed only the $\mathsf c_{14}=10^{-4}$ cell's $\bar m_n$ per row — not two datasets.

**Proof after re-run** (36 cells, $B=300$):

| Check | Round 1 | Round 2 |
|---|---|---|
| Cells violating $\hat m^{(1)}\le\bar m_n$ | 5 of 30 | **0 of 36** |
| $\max\lvert\overline{\hat m^{(1)}}/\overline{\bar m_n}-1\rvert$, stage-1-saturating cells | 0.095 | **0 exactly** |
| $\bar m_n$ spread across cells, $n=500/2000/8000$ | 1.222 / 1.156 / 1.049 | **1.0064 / 1.0046 / 1.0011** |
| Relative MC SE of $\bar m_n$ | — | 0.0036 / 0.0019 / 0.00087 |

The residual spread is 1.8 / 2.4 / 1.3 relative-SE units — Monte Carlo noise. The round-1 spread was **62 SE**. The invariants are now asserted at runtime, so this cannot ship silently again.

## Priority 2 — the rewritten verdict

### Monte Carlo error budget, stated before any gap is interpreted

$B=5{,}000$ in every cell. Coverage MC SE $=0.0031$ at $p=0.95$ and $0.0042$ at $p=0.90$; sd-ratio MC SE $0.0099$–$0.0208$; quantile MC SE (Bahadur, density at the asymptotic law) $0.038$ at 0.025 and $0.018$ at the median. **Precision no longer varies with $n$.**

### B1 — both $c_\delta$ cells are on-hypothesis. The round-1 exculpation was false.

A5(ii) reads, verbatim: $\|h\|_{L^2(\pi)}=O_P(\delta_n)$ with $\delta_n:=(\hat\delta_n\ln n)^{2\mu/(2\mu+1)}$, **and** $\delta_n=o_P(n^{-1/4})$.

$c_\delta$ is the constant in the *first* half's $O_P(\delta_n)$. It does not appear in the second half at all, which is a property of the deterministic sequence $\delta_n$ that this simulation computes identically in both cells. At the named configuration $\kappa\alpha=0.256>\tfrac14$, so $\delta_n/n^{-1/4}=n^{-0.006}(\ln n)^{0.8}\to0$. Verified numerically for $c_\delta\in\{0.25,1,100\}$: the ratio $\to 0$ in every case.

**Both configurations satisfy identical hypotheses. There is no ground on which to set the failing one aside, and the round-1 sentence claiming otherwise is withdrawn.**

The finite-$n$ picture and the asymptotic statement disagree without contradicting: $-0.006\ln n+0.8\ln\ln n$ is *increasing* until $\ln n=400/3$ ($n\approx10^{57.9}$) and only then turns. On every simulable grid the ratio rises; the limit is nonetheless zero.

### B2 — "every gap shrinks monotonically" is corrected

At constant $B$ the sd ratio is monotone decreasing over the full grid in three of four core panels. It is **not** monotone in DGP-A at $c_\delta=0.25$: $1.0319\to1.0349$ between $n=8{,}000$ and $22{,}627$. The unqualified round-1 claim is withdrawn and replaced by the panel-by-panel statement.

DGP-B at $c_\delta=0.25$ *is* monotone throughout under constant $B$ and reaches $0.9924$ at the largest $n$ — the round-1 non-monotonicity over its last three points was an artifact of the halved $B$.

### B3 — every measure in MC SE units, at the largest $n$

$c_\delta=0.25$, $n=181{,}019$ (full table: `sim_thm_rootn_seunits.tex`):

| DGP | sd ratio | sd ratio (SE) | 90% cov. (SE) | 95% cov. (SE) | Worst quantile (SE) | Centring (SE) |
|---|---|---|---|---|---|---|
| A | 1.0027 | **0.27** | 0.48 | 0.59 | 1.02 | 0.66 |
| B | 0.9924 | **−0.77** | 0.67 | 0.07 | **2.92** | 1.76 |

Every measure is inside 2 SE at the largest $n$ **except DGP-B's worst quantile gap, at 2.92 SE.**

$c_\delta=1$ — reported for *every* available measure, not the smallest:

| DGP | $n$ | sd ratio | sd ratio (SE) | 90% cov. | 90% (SE) | 95% (SE) | Worst quantile (SE) |
|---|---|---|---|---|---|---|---|
| A | 64,000 | 1.266 | 21.03 | 0.860 | −8.12 | −6.53 | 6.67 |
| A | 181,019 | 1.232 | **18.85** | 0.854 | **−9.18** | −8.08 | 7.02 |
| B | 64,000 | 1.178 | 15.08 | 0.883 | −3.66 | −2.48 | 3.75 |
| B | 181,019 | 1.139 | **12.23** | 0.878 | **−4.79** | −4.61 | 4.15 |

The sd ratio is the largest of these by a factor of two-and-a-half; the round-1 summary reported only the worst quantile gap, the smallest available measure. All four measures are decreasing in $n$ in both DGPs.

### The remainder is present at $c_\delta=0.25$ and scales as $c_\delta^2$

If the distortion is driven by the quadratic remainder it must scale as $1/16$. Predicting the $c_\delta=0.25$ sd ratio from the $c_\delta=1$ cell:

| DGP | $n$ | $c_\delta{=}1$ | predicted at $1/16$ | observed at $c_\delta{=}0.25$ | gap (SE) |
|---|---|---|---|---|---|
| A | 22,627 | 1.3265 | 1.0204 | 1.0349 | 1.40 |
| A | 64,000 | 1.2663 | 1.0166 | 1.0291 | 1.21 |
| A | 181,019 | 1.2323 | 1.0145 | 1.0027 | −1.18 |
| B | 22,627 | 1.2662 | 1.0166 | 1.0227 | 0.59 |
| B | 64,000 | 1.1775 | 1.0111 | 1.0121 | 0.10 |
| B | 181,019 | 1.1393 | 1.0087 | 0.9924 | −1.65 |

Quadratic scaling reproduces the $c_\delta=0.25$ cells to within 2 SE at every $n\ge1{,}000$. The distortion at $c_\delta=0.25$ is not absent — it is the same remainder, divided by 16.

### The statistics that isolate the theorem

- **Linearisation residual** (per-replication vector norm, so nothing cancels across replications): **monotone decreasing in all four core panels**, $c_\delta=1$ included. DGP-A $c_\delta=0.25$: $1.015\to0.319$. DGP-B $c_\delta=1$: $5.505\to1.781$.
- $\|\hat V-V\|_\infty$: monotone decreasing in all four panels ($1.227\to0.096$ for A at $c_\delta=0.25$).
- **Exact-nuisance ablation**: $0.1474\to0.0515\to0.0186$ at $n=1000/8000/64000$; ratios 2.86 and 2.77 against $\sqrt8=2.828$. $O(n^{-1/2})$ to three digits, and coverage $0.951/0.948/0.952$.
- Jacobian sign confirmed three ways.

## The two declared idealisations, now measured

### D3d — the mean-zero injection (previously undeclared)

Every injected error was drawn mean-zero in direction, so `eq:biasb1`'s bilinear first-order bias averaged to $\approx0$ across replications while a real Landweber–Fridman error's deterministic regularisation bias would not. This is now **declared in the script header and measured**: `bias_frac` interpolates from mean-zero to fully deterministic at fixed $\|h\|_{L^2(\pi)}$, so only $E[h]$ moves.

What actually moves (DGP-A, `sim_thm_rootn_bias.tex`):

| $c_\delta$ | $n$ | bias | sd ratio (SE) | 95% cov. (SE) | **Centring (SE)** |
|---|---|---|---|---|---|
| 0.25 | 181,019 | 0.0 | 0.27 | 0.59 | 0.66 |
| 0.25 | 181,019 | 1.0 | −1.96 | −1.07 | 1.21 |
| 1.00 | 181,019 | 0.0 | 18.85 | −8.08 | −0.12 |
| 1.00 | 181,019 | 1.0 | 6.78 | −9.65 | **3.34** |
| 1.00 | 1,000 | 0.0 | 36.71 | −4.81 | −0.44 |
| 1.00 | 1,000 | 1.0 | 22.65 | −6.34 | **5.51** |

**The idealisation was concealing a location distortion, not a scale distortion.** With a deterministic error the sd ratio gets *better* (18.85 → 6.78 SE) and coverage slightly worse (−8.08 → −9.65 SE), but the **centring**, which is $\approx0$ under mean-zero injection at every cell, becomes 2.0–5.5 SE. That is precisely the signature of a bias that does not average away, and it is invisible to a mean-zero design. The headline numbers therefore move less than feared; the omission was real but its consequence sits on a statistic the round-1 exercise computed and discarded.

### D3c — the injection basis cannot reach the damped directions

The two arms are now connected, and quantitatively (`sim_thm_rootn_condition.tex` Panel D). The injected $h$ occupies 6 Fourier modes spanning **three distinct frequencies** $\{2\pi,4\pi,6\pi\}$, and $\varphi_\dagger=\sin(2\pi x)$ *is* the first. Expressing that basis in the sieve and expanding it in the compression's eigenvectors:

| $n$ | $L_x$ | Resolvable dim. | Sieve-captured | Energy c.o.m. index | $\sigma_1/\sigma$ at c.o.m. |
|---|---|---|---|---|---|
| 500 | 6 | 5 | 0.783 | 3.03 | 4.13 |
| 2,000 | 6 | 5 | 0.783 | 3.01 | 4.11 |
| 8,000 | 9 | 8 | 0.973 | 3.68 | 4.93 |

The injected error sits where the operator damps it by a factor of **3.7–4.9**, while the compression's dynamic range over the resolvable directions is $\sigma_1/\sigma_{\min}\ge6.7\times10^{7}$ (the ratio is at the arithmetic floor — Round 3 §3 — so this is a lower bound, not the $7.5$–$8.6\times10^{6}$ the round-2 text quoted from the floored $\kappa$). In log terms the injection basis reaches **at most 10% of the spectrum**. D3c's "rough" mode did not merely fail to achieve the intended geometry — **the injection basis is structurally incapable of reaching it**, and the gap widens with $n$ (the damped-half energy share falls 0.65 → 0.36 as $L_x$ goes 6 → 9).

**Round 3: this claim is NOT contingent on $\#\mathcal T$.** Run 2 quadruples the $\Pi_t$ quadrature at constant total mass. Every quantity Panel D is built from is inside 1.3 MC SE:

| Quantity | $\#\mathcal T=12$ | $\#\mathcal T=48$ | Difference in MC SE |
|---|---|---|---|
| Resolvable dim. | 5.000 | 5.000 | 0.00 (both degenerate) |
| Energy c.o.m. index | 2.995–3.024 | 2.998–3.025 | −0.33 to +0.55 |
| Energy in damped half | 0.624–0.647 | 0.625–0.648 | −0.64 to +0.89 |
| $\sigma_1/\sigma$ at c.o.m. | 3.773–4.145 | 3.753–4.129 | −1.23 to −0.58 |

The regenerated Panel D reproduces the round-2 numbers to two decimals (0.641/0.647/0.626/0.638/0.356/0.363 for the damped-half share against round 2's 0.65 → 0.36), which is the second confirmation: these are functions of the compression's eigenvectors and are invariant to $\Pi$'s normalisation by construction.

## Priority 3 — reporting discipline

- **Exported for the first time:** centring $\mathbb E[\text{mixed}]$ with its $z$ (in every core cell), all previously dropped MC SEs, the $c_\delta=1$ quantile set (`sim_thm_rootn_quantiles.tex` now carries both $c_\delta$), the DGP-validation table (`sim_thm_rootn_dgpvalid.tex`), the bias arm, and a dedicated all-measures-in-SE-units table (`sim_thm_rootn_seunits.tex`).
- **`condition.tex` Panel C fixed.** Under the "zero" preliminary at $\mathsf c_{14}=1$ the rule stops at $m=1$ in every replication, so $\hat\varphi\equiv0$ and the ratio is $\|\varphi_\dagger\|/\delta_n$ **exactly** — verified to $1.2\times10^{-4}$ relative. The column is now labelled arithmetic and its fake "0.0000" MC SE is gone; the informative "rate" column is read in the text. *(Round 3: this survives the correction — $1.24\times10^{-4}$ relative on the re-run — and the label is no longer asserted in prose but computed from the check, so if a future change makes the column non-arithmetic the heading changes with it.)*
- ~~**Finding #2's headline replaced.** The stop is bimodal — at $\mathsf c_{14}=10^{-1}$, $n=500$: median 1, 10th–90th percentile $[1,1]$, mean 20,856.~~ **WITHDRAWN IN ROUND 3.** Bimodality was an arithmetic consequence of the residual sign error, not a finding; see Round 3 §1. Panel A still reports medians, and **no fixed $\mathsf c_{14}$ is $n$-stable** still holds — but on the corrected branch-frequency evidence of Round 3 §4, not on this statistic.
- ~~**"100%" corrected.** At $\mathsf c_{14}\le10^{-2}$ all three stages saturate in **300 of 300** replications; the exact two-sided 95% lower bound is **0.988**, not 1.~~ **SUPERSEDED.** Under the corrected rule saturation at $\mathsf c_{14}=10^{-2}$ runs 0.403–0.977 by cell and is exactly 1.000 only at $\mathsf c_{14}\le10^{-3}$. The reporting principle (counts and a Clopper–Pearson bound rather than a proportion with an arithmetically-zero SE) was right and is retained in spirit; Panel B now reports the three branch frequencies, which are not degenerate.
- ~~**Lepskii comparison made fair.** ... Lepskii still wins at every cell: $0.3347$ vs $0.5426$ at $n=8{,}000$ (rate), $0.6305$ vs $0.8152$ (zero).~~ **WITHDRAWN AND RE-RUN.** That comparison was made against a rule that could not stop in the interior at any $\mathsf c_{14}$, and the quoted "stage-1 saturation 0.35–0.78, per-replication $\hat m^{(1)}/\bar m_n$ 0.35–0.78" were **numerically identical because the bug forced $E[\hat m/\bar m_n]=\Pr(\text{saturate})$**. The corrected comparison is Round 3 §5 and **splits by preliminary**: Lepskii wins all three `zero` cells, the discrepancy rule wins all three `rate` cells.
- **$L_x$ placed against its own window** (Panel B′), in the budget arm's own manner. At a literal constant-1 reading of (P-c) $L_x\gg n^{9\alpha/8s}$ and (P-d) $L_x=o(n^{1-2\alpha}/\ln n)$, `eq:lxwindow` is **empty at every $n$ in this arm** (upper/lower $=0.715/0.815/0.962$) and first opens at $n\approx10{,}775$. These are rate statements with unspecified constants, so this is a *reading*, not a violation — the same status the budget arm gives $\sqrt n\delta_n^2$.
- **Jacobian Panel D's null explained rather than left silent.** The N1 and zero anchors give the same asymptotic sd to five digits (ratio $1.00000$) because $\hat b=E[L_\star\mid\Delta Z]$ ~~is small in this design: $\|\hat b\|/\|L_\star\|=0.0123$ (A), $0.0116$ (B) in rms, now reported in the table. A 1.2% anchor shift cannot move $V$ measurably~~ **is ZERO in this design, not merely small — see the banner below**, so the arm **cannot** detect anchor-sensitivity of $V$ and `rem:anchor`'s free anchor is untested here — a fact about the design, not a confirmation that $V$ is anchor-invariant.

  > **CORRECTED 2026-08-15 — 0.0123 AND 0.0116 ARE THE STATISTIC'S OWN NOISE FLOOR, NOT THE SIZE OF $\hat b$.** `sim_thm_rootn_jacobian.R:224–226` estimates $b$ by averaging $L_\star$ within 200 quantile cells of the propensity index at $n=1.5\times10^6$ — 7,500 draws per cell — so a binned mean returns $\|\hat b\|/\|L_\star\|\approx1/\sqrt{7500}=0.0115$ **when the truth is exactly zero**. Re-running that statistic reproduces 0.0110 (A) and 0.0122 (B) against that floor. It therefore cannot resolve $b$ at all, in either direction.
  >
  > `scripts/simulations/sim_thm_rootn_n1defect.R` computes the quantity instead of estimating it — $\Delta U\perp(\Delta Z,W)$ exactly and $L_\star$ separates in $(u,z)$, so $E[L_\star\mid\Delta Z]$ is closed form. At $\mathsf L=2$, **$\max_{j,l}\|b_{jl}\|_{L^2}=8.23\times10^{-6}$, i.e. $3.3\times10^{-6}$ of $\|L_\star\|$** (DGP-B: $1.7\times10^{-5}$), quadrature-stable to $10^{-14}$. The mechanism is parity, not smallness: the solved representer's energy is entirely on odd $q$, so $L_\star$ is odd in $u$ and $\Delta U$ is symmetric. **The bullet's conclusion is not weakened but upgraded** — the two anchors do not merely give indistinguishable $V$, they are the same object.
  >
  > **This confirms the "Does not" entry below, which stands as written:** "the N1 anchor coincides with the zero anchor here" is now machine-checked rather than inferred from a floored statistic. It is *not* true at $\mathsf L=4$, where the defect is 19% of $\|L_\star\|$ — but that cardinality is outside this arm.

## Where I disagree with the critic

1. ~~**Finding D, "Both condition numbers at/past double precision" — wrong for the compression.**~~ **THIS REFUSAL IS WITHDRAWN IN FULL (Round 3 §3).** The critic was right and I was wrong, and the mechanism is worse than the critic argued. `kappa_S` was computed as `max(lam)/pmax(min(lam), eps_mach)` with the floor in **absolute** units; `min(lam)` is below $\varepsilon_{\rm mach}$ at every cell, so the shipped number was **exactly $\lambda_{\max}/\varepsilon_{\rm mach}$** — verified equal to nine significant digits — i.e. a function of the operator's normalisation, not of its conditioning. Run 3 demonstrates it mechanically: rescaling $\Pi_t$ by $1/12$ moved the reported $\kappa$ by 12 while every genuine invariant held to $10^{-16}$. And `comp_svr`, the singular-value ratio I used to argue the compression was *not* at the floor, was **defined as $1/\sqrt{\kappa_S}$** — so it was computed from the floored $\kappa$ and the argument was circular. That is precisely the substitution the round-2 critic identified in `mark()`. Both $\kappa$'s are now built from the **relative** spectrum, are invariant under rescaling (Run 3: identical to 16 digits), and **both are marked $\ge$**. The rest of finding D stands: the power-vs-exponential fit runs on 5–8 points and is not identified — the exponential wins in 0.49 of replications at $n=2000$/rate against 0.85 at $n=2000$/zero, so it is a coin flip at one cell and not at its neighbour. The safe statement, now used: *the spectrum is far steeper than $a=\tfrac34$ over the resolvable directions ($\hat a\approx2.6$–$3.2$); its functional form is not identified at this $L_x$.*

2. **Finding A's "3 in the `.tex` vs 5 in the `.rds`" is not evidence of two datasets.** The `.tex` reproduces the `.rds` exactly; Panel A simply printed one $\bar m_n$ per row. The conclusion — not reproducible from the shipped script — is right, and the argument above is stronger than the one given, because it rests on an arithmetic identity rather than on a spread comparison.

3. **Finding E's sign test weakens at $c_\delta=0.25$ under constant $B$.** 90% coverage in DGP-A is now below nominal in **7 of 8** cells at $c_\delta=0.25$ (sign test $p=0.070$), not 8 of 8 — the one cell that crosses is the largest $n$, at $+0.48$ SE. The finding is decisive at $c_\delta=1$ (8 of 8, $p=0.0078$, every cell beyond 3 SE) and across both configurations (15 of 16, $p=0.0005$). So the systematic under-coverage is real and is *driven by the remainder*: it survives at the constant the theory's symbols give and largely dissolves at the largest $n$ once the remainder is divided by 16. The other half of finding E — that the verdict table reported only the 95% level — is accepted and fixed: 90% coverage is now in the SE-units table at every cell.

Everything else I checked, the critic had right, including the items it credited: the seeding fixes are genuine, the log-log grid rationale is backed by 27 SE of resolution, the budget arithmetic is exact ($\ln n=133.3$ turnover, $\log_{10}n=394.4$ crossing, 12.4–54.1 amendment factor all reproduced after the INV-17 refactor), and the core grid does run the harsher geometry — DGP-B's linearisation residual exceeds DGP-A's at every $n$.

## Verdict

> ### Matches at large $n$ only.

**Not "Matches".** At $c_\delta=0.25$ the sd ratio fails a 2-SE bar at $n\le64{,}000$ in DGP-A (16.90, 8.30, 5.83, 4.93, 3.09, 3.37, 2.82 SE) and clears it only at $n=181{,}019$; DGP-B's worst quantile gap is 2.92 SE at the largest $n$. At $c_\delta=1$ — **equally on-hypothesis** — nothing matches anywhere on the grid: the sd ratio is 18.85 SE and 90% coverage 9.18 SE below nominal at the largest $n$. Finite-sample quality is governed by $c_\delta^2\sqrt n\delta_n^2$, and at the constant the theory's own symbols suggest it is poor over the entire feasible range.

**Not "Persistent mismatch".** Nothing here is evidence against `thm:rootn`. The linearisation residual — the sharpest statistic, immune to cross-replication cancellation — declines monotonically in **every cell of every panel including $c_\delta=1$**; $\|\hat V-V\|_\infty$ likewise; the exact-nuisance ablation reproduces $O(n^{-1/2})$ to three digits; every gap at $c_\delta=1$ shrinks in $n$; and the $c_\delta=0.25$ distortion is reproduced to within 2 SE by scaling the $c_\delta=1$ distortion by $c_\delta^2=1/16$, which is what the theorem's own remainder accounting predicts. The gaps track the budget $\sqrt n\delta_n^2$, which on this grid is *increasing* in $n$ and does not fall below 1 until $n\approx10^{394}$ — so the theorem is right and `cor:ratefloor`, not `thm:rootn`, is what describes any feasible sample.

## What this exercise does and does not establish

**Does:** the estimator of `def:crossfit`/`def:onestep` is implementable and correctly signed; its remainder accounting is complete and its constants moderate, **for nuisance errors of exactly the priced size drawn in a span containing the truth**; the theory's own remainder budget at its own named design is far from met at any simulable $n$; ~~the discrepancy stop is governed by an unidentified constant while a Lepskii stop is not~~ — **replaced (Round 3 §5)** by: *which of the two stopping rules is better is itself decided by $\mathsf c_{14}$, which `def:lfstep` says is not identified by the data* — and the mechanism is not the one round 2 claimed, since Lepskii's test compares an $L^2(\pi)$ quantity that is invariant under rescaling $\Pi$, so it is scale-free **by denomination**, not by the absence of a tuning constant.

**Does not:** verify that any *constructed* $\hat\ell$ attains A5(iv) — none exists to test (L-13, Q-1); verify `prp:phirate` on-hypothesis, since the realised operator is more ill-posed than H1 admits (**Round 3: this is *not* contingent on $\#\mathcal T$** — Run 2 moves $\hat a$ by $\le0.032$, at most 2.4 MC SE, across a 4× refinement, from 2.60–3.21 against H1's 0.75); verify (R-c.1)/N1$'$, since D2 takes the zero anchor; test the $\mathsf P$-partition median of `prp:medianpart`; verify that cross-fitting does its job (D3b replaces complement-fold measurability with full independence); detect anchor-sensitivity of $V$ (the N1 anchor coincides with the zero anchor here); exhibit an error in the operator's damped directions (D3c — the injection basis reaches at most 10% of the spectrum in log terms); **measure either condition number** — both are at the double-precision floor, so Panel A reports lower bounds and nothing else (Round 3 §3); **or say what $\kappa$ of the $n_{\rm m}$-dimensional Gram of `eq:gram` is at $n=2{,}000$**, since the quadrature caps its rank at $n_g=780$ and 1,220 structurally zero eigenvalues never enter the number (Round 3 §6). `def:hatT`'s $\Pi_t$ **is** now implemented (Round 3 §2), so that entry is discharged rather than added. There is still **no assumption-broken DGP**, so "Matches at large $n$" remains a non-rejection by a procedure shown able to reject only via the $-\hat J^{-1}$ counterfactual and the $c_\delta$ contrast.

**Reproduce:** `Rscript scripts/simulations/sim_thm_rootn_run_all.R` (~7 h on 8 cores; `N_CORES` is fixed at 8 so the numbers do not depend on the host).

---

# Round 3 — the $\varphi$-step arm, corrected

Everything below concerns `sim_thm_rootn_phistep.R` and the two tables and one figure it emits. Design, $n$-grid and $B$ are unchanged: DGP-A, $n\in\{500,2{,}000,8{,}000\}$, $B=300$ ($B_{\rm gram}=25$), $\mathsf c_{14}\in\{10^{-4},10^{-3},10^{-2},3\times10^{-2},10^{-1},1\}$, two preliminaries — 36 cells.

**Provenance.** The shipped tables were produced by the shipped script in one run. MD5 at launch = MD5 now = the fingerprint stored in the checkpoint: `phistep 31a6ecea25fd8e856cadeaf19a72041e`, `dgp 77ca9331b18e321bea0791eac5f3cfee`, `nuisance af838f55da7597411a164eabc7b5d824`. No source file was edited after the run began.

## 1. CRITICAL — the sign of the cross term. Fixed.

`resid_at()` evaluated $\|\hat{\mathcal A}c_m+\hat r\|^2$ as $c'\Lambda c \;\mathbf{+}\;2\omega^2 g'c+\|\hat r\|^2$. Since $g:=-\omega^{-2}U'\hat{\mathcal A}'\hat r$, we have $U'\hat{\mathcal A}'\hat r=-\omega^2 g$ and the cross term is $\mathbf{-}2\omega^2g'c$. Reproduced against a direct evaluation of $\|A_wUc_m+r_w\|$ on a synthetic operator:

| $m$ | shipped | sign-fixed | direct |
|---|---|---|---|
| 0 | 1.088186 | 1.088186 | 1.088186 |
| 1 | 1.100331 | 1.082364 | 1.082364 |
| 4 | 1.107131 | 1.081648 | 1.081648 |
| 256 | 1.107583 | 1.081643 | 1.081643 |

Sign-fixed $=$ direct to $2.2\times10^{-16}$; the shipped version starts at $\|\hat r(0)\|$ and **increases**.

**What that did to the round-2 finding.** With the residual increasing in $m$, `resid_at(1) <= thr` could fire only when the threshold already exceeded $\|\hat r(0)\|$, and otherwise `resid_at(mbar) > thr` fired. **The bisection branch was unreachable at every $\mathsf c_{14}$**, so $\hat m^{(1)}\in\{1,\bar m_n\}$ was an identity, not a measurement — and the two round-2 columns "stage-1 saturation" and "per-replication $\hat m^{(1)}/\bar m_n$" were identical (both 0.35–0.78) because $E[\hat m/\bar m_n]=\Pr(\text{saturate})$ follows from it. Both are withdrawn.

**Assertion added, at replication level, inside the stage loop.** The round-2 assertions checked the *bound* $\hat m\le\bar m_n$ and the exactness of saturation; both hold under the bug because both are properties of the branch structure. Two checks now run on every stage of every replication of every cell — 3 × 300 × 36 = 32,400 evaluations per run:

1. the closed form equals a **direct** evaluation of $\|A_wUc_m+r_w\|$ at $m\in\{0,1,2,4,16,256,4096,\bar m_n\}$, to $10^{-6}$ relative;
2. the residual is **non-increasing in $m$**, and $\hat r(0)=\|r_w\|$; plus $\rho_j\in[0,1]$.

Both fail immediately on the round-2 code. Blocking assertions were also **moved above `saveRDS()` and above the table emission** — round 2 ran them at the bottom of the file, so a violated invariant still wrote every output before raising ("it cannot ship silently again, but it does ship").

## 2. MAJOR — $\Pi_t$ was counting measure. Now a quadrature. (design decision D13)

Measured on the shipped construction: $\Pi_t$'s total mass was $12/24/48/96$ at those node counts, and the $L^2(\Pi)$ norm of a **fixed** function scaled as $\sqrt{\#\mathcal T}$ (ratio 2.792 across an 8× refinement against $\sqrt8=2.828$). A quadrature for a fixed measure gives 1.000.

**The fix, and why uniform is not one choice among many.** `TN_FIXED` is a **Halton lattice** — a low-discrepancy point set *for the uniform measure on the cube*, whose canonical rule is exactly equal weights $\mathrm{vol}(\mathcal T)/\#\mathcal T$. The atoms already implied $\Pi_t=\mathrm{Unif}(\mathcal T)$; only the normalisation was missing. So $w_t=1.6^3/\#\mathcal T$, total mass $4.096$ at every $\#\mathcal T$, Koksma–Hlawka error $O(\#\mathcal T^{-1}(\ln\#\mathcal T)^3)$. $c_\Pi$ (B1(iv.c)) uses the same weights, so `eq:normconst` and `eq:cap` inherit the correction with no separate adjustment. B1(iv.b) — which asks that $\Pi_t$ not be mutually singular with Lebesgue — is satisfied by an a.c. measure and was **not** satisfied by an atomic one. A runtime assertion now checks that the mass is $\mathrm{vol}(\mathcal T)$ at both $\#\mathcal T$ and $4\#\mathcal T$.

**Effect on `eq:cap`.** $\omega_n$ falls by $\sqrt{12/4.096}=1.712$ and $\bar m_n$ by $12/4.096=2.93$:

| $n$ | $\bar m_n$ round 2 | round 3 | $\omega_n$ r2 → r3 | inflation $\bar m_n/\hat\delta_n^{-2}$ r2 → r3 | $\omega_n/\|\hat{\mathcal A}\|$ r2 → r3 |
|---|---|---|---|---|---|
| 500 | 336,145 | **114,738** (417) | 79.3 → **46.3** | 6,225 → **2,125** | 665 → **665** |
| 2,000 | 1,252,970 | **427,681** (823) | 98.3 → **57.4** | 9,638 → **3,290** | 803 → **803** |
| 8,000 | 4,612,067 | **1,574,253** (1,371) | 121.0 → **70.7** | 14,641 → **4,998** | 958 → **958** |

Round 2 therefore **overstated the cap inflation by a factor of 2.93**, traceable entirely to the counting-measure normalisation. The last column is unchanged to the digit, which is the scale-invariance check landing in the shipped table itself. The inflation is still enormous, and it is now what it should be: exactly $\omega_n^2$, i.e. a measurement of `eq:normconst`'s realised constant against a **declared** $\Pi$, not a property of a node count.

## 3. Run 3 — pure rescaling. What is invariant, what is not, and one thing neither of us expected.

Same atoms, counting measure vs $\tfrac1{12}\sum_k\delta_{t_k}$, sign corrected in both arms, identical RNG state, $n\in\{500,2{,}000\}\times$ both preliminaries.

| Prediction | Result |
|---|---|
| $\rho$, $g$, $\hat\varphi$ at fixed $m$ bit-identical | **Holds** (they are functions of $\lambda/\omega^2$ and of $U$, both invariant) |
| $n_{\rm res}$, $\hat a_{\rm pow}$, $\hat a_{\rm exp}$, $R^2$, and all of condition-table Panel D bit-identical | **Holds**, exactly |
| $\omega_n/\|\hat{\mathcal A}\|$ invariant | **Holds** to $2\times10^{-16}$ (786.8398009781 → 786.8398009781) |
| $\bar m_n$ down by exactly 12 | **Holds**: ratio 11.999679 / 11.999899 — exact up to `ceiling()` |
| stopping curve shifted in $\mathsf c_{14}$ by exactly $\sqrt{12}=3.4641$ | **Holds exactly at the $m=1$ boundary** in all four cells (3.464102). **Does not hold at the cap boundary**: 2.50/2.75/2.87. That is not a defect — the lower endpoint is $\|\hat r(\bar m_n)\|$ and $\bar m_n$ *itself* moved, so the residual is read at a different $m$. |
| $\kappa_S$ invariant | **FAILS — and this is the finding.** $\kappa_S$ moved by exactly 12. |
| all of **stopping-table** Panel D bit-identical | **FAILS.** $\hat m^{\rm Lep}$ is clipped by the smaller cap (32,768 → 28,017; 131,072 → 99,441), because the Lepskii candidate set is `pmin(2^(0:ceiling(log2(mbar))), mbar)` and therefore depends on $\bar m_n$. Condition-table Panel D *is* bit-identical; the two Panel D's are different objects. |

**The $\kappa_S$ failure.** `kappa_S <- max(lam)/pmax(min(lam), eps_mach)` applies the floor in **absolute** units, and $\min\lambda<\varepsilon_{\rm mach}$ here, so the shipped number was $\lambda_{\max}/\varepsilon_{\rm mach}$ — verified equal to nine digits (at $n=500$: $\lambda_{\max}=1.026768\times10^{-2}$, $\kappa_S=4.624153\times10^{13}=\lambda_{\max}/\varepsilon_{\rm mach}$). A condition number that moves when you rescale the operator is not a condition number. Worse, `comp_svr` was *defined* as $1/\sqrt{\kappa_S}$, so the $\sigma_{\min}/\sigma_{\max}=1.16\times10^{-7}$ that round 2 used to refuse the critic's finding was **computed from the floored $\kappa$** and was circular.

Both $\kappa$'s are now built from the **relative** spectrum $\lambda_j/\lambda_{\max}$ (which is what double precision bounds), and $\sigma_{\min}/\sigma_{\max}$ is computed independently. After the fix, Run 3 gives $\kappa_{\rm comp}=4.5036\times10^{15}=1/\varepsilon_{\rm mach}$ and $\kappa_{\rm Gram}=2.0282\times10^{31}=1/\varepsilon_{\rm mach}^2$ in **both** arms — invariant, and both at the floor. The compression's true $\sigma_{\min}/\sigma_{\max}$ is $0$ to $1.4\times10^{-13}$, against the $\sqrt{\varepsilon_{\rm mach}}=1.5\times10^{-8}$ resolution of `eigen(A'A)`. **Panel A now marks both columns $\ge$.** The Gram's ratio moves by 10–75% under a pure rescaling ($1.27\to1.42\times10^{-18}$; $2.0\to8.0\times10^{-21}$), which is what "it is roundoff" predicts and independently confirms the round-2 critic on that column.

## 4. Run 2 — refinement at constant mass. Do 12 nodes span the informative directions?

$\#\mathcal T\in\{12,48\}$, $\Pi_t$ mass held at 4.096 in both, sign corrected, $n\in\{500,2{,}000\}$, both preliminaries, $B=300$. **Answer: yes for everything spectral and geometric; no for the normalising constant.**

| Quantity | $\#\mathcal T=12$ (MC SE) | $\#\mathcal T=48$ (MC SE) | Difference in MC SE (4 cells) |
|---|---|---|---|
| $\kappa_S$ | $4.5036\times10^{15}$ (0) | $4.5036\times10^{15}$ (0) | 0.00 — identical (both at the floor) |
| $n_{\rm res}$ | 5.000 (0) | 5.000 (0) | 0.00 |
| $\hat a_{\rm pow}$ | 2.599–3.208 (0.010–0.013) | 2.568–3.180 (0.009–0.013) | −1.37, −1.51, **−2.01**, **−2.38** |
| $\Pr(\text{exp. wins})$ | 0.457–0.973 (0.013–0.029) | 0.467–0.977 (0.012–0.029) | +0.25 to +0.39 |
| Energy c.o.m. index | 2.995–3.024 (0.0013–0.0031) | 2.998–3.025 | −0.33 to +0.55 |
| Energy in damped half | 0.624–0.647 (0.0006–0.0009) | 0.625–0.648 | −0.64 to +0.89 |
| $\sigma_1/\sigma$ at c.o.m. | 3.773–4.145 (0.012–0.019) | 3.753–4.129 | −1.23 to −0.58 |
| $\sigma_{\min}/\sigma_{\max}$, compression | $5.1$–$6.5\times10^{-14}$ | $7.1$–$9.1\times10^{-14}$ | +1.87 to **+4.13** |
| $\omega_n/\|\hat{\mathcal A}\|$ | 684.7–824.3 (6.3–9.0) | 762.4–921.8 (7.4–11) | **+6.02 to +10.09** |

**9 of 36 quantity × cell comparisons move by $\ge2$ MC SE.** Reading them:

- **The spectral and injection-geometry quantities are refinement-insensitive.** $\kappa_S$, $n_{\rm res}$, $\Pr(\text{exp wins})$ and all three Panel-D geometry statistics are inside 1.3 SE everywhere. $\hat a$ crosses 2 SE at $n=2{,}000$ but moves by $-0.03$ on a base of 2.6–2.7 — 1.2%, against an H1 value of 0.75. **So the two contingency caveats the brief asked for are discharged: Panel B's "the realised operator is more ill-posed than H1 admits" and Panel D's cross-arm claim are *not* artefacts of $\#\mathcal T=12$.**
- **$\sigma_{\min}/\sigma_{\max}$ of the compression "moves" by up to 4.1 SE — between $5\times10^{-14}$ and $9\times10^{-14}$, i.e. between two numerically-zero values** eight orders below the $1.5\times10^{-8}$ resolution of the decomposition. It confirms the floor rather than measuring anything.
- **$\omega_n$ genuinely has not converged at $\#\mathcal T=12$, and now it is possible to say so.** $\omega_n\propto c_\Pi\propto\sqrt{\int_{\mathcal T}e^{2\|t\|_1}\Pi_t(dt)}$, a **fixed finite integral** under D13, whose exact value on $[-0.8,0.8]^3$ is $(e^{1.6}-1)^3=61.7719$. The QMC rule gives:

  | $\#\mathcal T$ | 12 | 48 | 192 | 768 | 3,072 | 12,288 |
  |---|---|---|---|---|---|---|
  | QMC | 43.579 | 55.657 | 59.976 | 61.309 | 61.636 | 61.752 |
  | rel. error | −29.5% | −9.9% | −2.9% | −0.75% | −0.22% | −0.033% |
  | $c_\Pi$ / exact | 0.8399 | 0.9492 | 0.9854 | 0.9962 | 0.9989 | 0.9998 |

  Predicted $\omega_n$ ratio $48/12=0.9492/0.8399=1.1301$; **measured 1.130, 1.129, 1.131, 1.130.** Predicted cap ratio $1.1301^2=1.2771$; **measured 1.277, 1.274, 1.278, 1.277.** So at the shipped grid $\omega_n$ is 16% below and the cap 29% below their exact-$\Pi$ values. That is a one-sided, quantified, **convergent** quadrature error on a well-defined object — which is exactly what counting measure made impossible to state, because there the sum had no limit. It is a residual imprecision of the shipped configuration and is declared here rather than absorbed.
- $\|\hat{\mathcal A}\|$ moves by only 1.0–1.5%, so essentially all of the $\omega_n/\|\hat{\mathcal A}\|$ movement is $c_\Pi$.

## 5. The corrected Lepskii comparison — and it does not go round 2's way

Round 2 compared the two rules at one fixed $\mathsf c_{14}$, against a rule that could not stop in the interior. Panel D now gives the discrepancy rule its **oracle** $\mathsf c_{14}$: the value of the sweep minimising mean $\|\hat\varphi-\varphi_\dagger\|$ in that cell — an advantage Lepskii is not given, and one no analyst can take, since `def:lfstep` says $\mathsf c_{14}$ is not identified. Both readings are reported.

**At the oracle $\mathsf c_{14}$:**

| $n$ | Prelim. | oracle $\mathsf c_{14}$ | Lepskii (SE) | discrepancy (SE) | difference | in SE | winner |
|---|---|---|---|---|---|---|---|
| 500 | zero | $10^{-4}$ | 0.6407 (0.0095) | 0.6787 (0.0114) | +0.0379 | 2.56 | **Lepskii** |
| 500 | rate | $1$ | 0.4109 (0.0059) | 0.3596 (0.0025) | −0.0513 | −7.97 | **discrepancy** |
| 2,000 | zero | $10^{-1}$ | 0.6581 (0.0045) | 0.7071 (0.0000) | +0.0490 | 10.83 | **Lepskii** |
| 2,000 | rate | $10^{-1}$ | 0.3161 (0.0042) | 0.2920 (0.0019) | −0.0241 | −5.18 | **discrepancy** |
| 8,000 | zero | $3\times10^{-2}$ | 0.6615 (0.0021) | 0.6964 (0.0041) | +0.0350 | 7.60 | **Lepskii** |
| 8,000 | rate | $10^{-1}$ | 0.2561 (0.0023) | 0.2424 (0.0013) | −0.0137 | −5.21 | **discrepancy** |

**At the fixed $\mathsf c_{14}=3\times10^{-2}$ of round 2:** Lepskii wins all six, by 2.23 to 7.67 SE.

**How to read this honestly, including the part that is unflattering to the discrepancy rule's win.** The rule's oracle $\mathsf c_{14}$ in every `rate` cell is $10^{-1}$ or $1$ — values at which $\Pr(\hat m^{(1)}=1)=1.000$. It wins by taking **one Landweber step out of a budget of $10^5$–$10^6$**, i.e. by returning (almost) the preliminary; and under D8 that preliminary is $P_{S_n}\varphi_\dagger$ plus noise of size $n^{-0.15}$, an *injection* that no estimator in this paper supplies (open item Q-1). In every `zero` cell, where the same "stop at 1" prescription returns $\hat\varphi\approx0$ and an error of exactly $\|\varphi_\dagger\|=0.7071$, it loses. **So the corrected statement is: the sign of the comparison is decided by $\mathsf c_{14}$ and by whether the preliminary satisfies (P-a.2), and the oracle prescriptions for the two preliminaries are opposite — run to the cap for `zero`, stop at 1 for `rate` — with no data-driven way to choose between them.** That is a stronger version of round 2's point about the unidentified constant, and it is now supported by a rule that can actually stop in the interior.

**The claimed mechanism is corrected too.** Round 2 said "a Lepskii stop carries no unidentified constant". Lepskii here carries a balancing constant fixed at 1 (design decision D10) and a variance proxy $\sigma(m)=\hat\delta_n\sqrt m$ that `rem:tccwhy`(2b) says the paper's operator-noise model does not supply. What makes it scale-free is that its test compares $\|\hat c_m-\hat c_{m'}\|_{L^2(\pi)}$ — a quantity **invariant** under rescaling $\Pi$ (Run 3: identical to 16 digits) — against a threshold in the same units. It is scale-free by **denomination**, not by the absence of a tuning constant. The round-2 sentence is withdrawn.

## 6. What the corrected rule actually does

Not bimodal. All three branches are reached, and the branch mix is the finding:

| $n$ | Prelim. | $\Pr(\hat m=1)$ | $\Pr(\text{interior})$ (SE) | $\Pr(\text{cap})$ | $\|\hat r(\bar m_n)\|/\|\hat r(0)\|$ (SE) | interior-stop $\mathsf c_{14}$ window |
|---|---|---|---|---|---|---|
| 500 | zero | 0.040 | 0.017 (0.007) | 0.943 | 0.9061 (0.0041) | (0.0236, 0.0265) |
| 500 | rate | 0.020 | 0.003 (0.003) | 0.977 | 0.9217 (0.0028) | (0.0273, 0.0299) |
| 2,000 | zero | 0.050 | 0.123 (0.019) | 0.827 | 0.7766 (0.0085) | (0.0162, 0.0214) |
| 2,000 | rate | 0.093 | 0.037 (0.011) | 0.870 | 0.8613 (0.0054) | (0.0199, 0.0236) |
| 8,000 | zero | 0.097 | **0.500 (0.029)** | 0.403 | 0.6127 (0.0136) | (0.0097, 0.0167) |
| 8,000 | rate | 0.107 | 0.103 (0.018) | 0.790 | 0.7887 (0.0075) | (0.0174, 0.0228) |

(at $\mathsf c_{14}=10^{-2}$; the last two columns are stage-1 quantities and do not vary with $\mathsf c_{14}$.)

**The mechanism, which is new and is not an artefact.** Over the *entire* admissible budget the discrepancy criterion falls by only 8–39%: $\|\hat r(\bar m_n)\|/\|\hat r(0)\|$ is 0.61–0.92. So the threshold $\tau_{\rm DP}\mathsf c_{14}\times\text{level}$ is above $\|\hat r(0)\|$ (stop at 1) or below $\|\hat r(\bar m_n)\|$ (saturate) unless it lands in a window **0.04 to 0.24 decades wide** — 1–6% of the four decades swept. Across the sweep: $\Pr(\text{cap})=1.000$ in all twelve cells at $\mathsf c_{14}\le10^{-3}$ and $\Pr(\hat m=1)=1.000$ in all twelve at $\mathsf c_{14}\ge10^{-1}$; the entire transition lives in the two decades between, and the interior branch carries majority weight in exactly one of 36 cells. **"No fixed $\mathsf c_{14}$ is $n$-stable" survives** — the window moves from (0.024, 0.027) at $n=500$/zero to (0.0097, 0.017) at $n=8{,}000$/zero — but it now rests on the branch frequencies rather than on a mean of a degenerate variable.

The reason the criterion barely moves is visible in Panel C: $\omega_n/\|\hat{\mathcal A}\|$ is 665–958, so the Landweber relaxation $1/\omega_n^2$ is $\sim\!10^6$ times smaller than the largest stable step, and a single step is numerically invisible (at $n\ge2{,}000$ with the zero preliminary, $\hat m=1$ gives $\|\hat\varphi-\varphi_\dagger\|=0.7071=\|\varphi_\dagger\|$ with an MC SE of exactly zero). That over-normalisation *is* `eq:cap`'s inflation factor $\omega_n^2$ — the same number, read twice.

## 7. Verified rather than assumed: which panels depend on the stop

The brief asked for this to be checked. One replication is run twice from the same RNG state at $\mathsf c_{14}=10^{-4}$ and $\mathsf c_{14}=1$ — five decades apart — and **all 25 stage-1 return elements are bit-identical** ($\kappa_S$ at all three stages, $\omega_n$, $\|\hat{\mathcal A}\|$, $\bar m_n$, $\hat a_{\rm pow}$, $\hat a_{\rm exp}$, both $R^2$, $n_{\rm res}$, $\|\hat r(0)\|$, $\|\hat r(\bar m_n)\|$, all four injection-geometry statistics, both $\sigma_{\min}/\sigma_{\max}$, $h_u$, $h_x$, $L_x$, $\hat\varepsilon_0$, $\delta_n$) while the stop moved 105,079 → 1. This runs as a `stopifnot` on every execution. Comparing *cell means* would not have shown this: cells at different $\mathsf c_{14}$ draw different replications, so they differ by Monte Carlo noise regardless.

**Conclusion:** `sim_thm_rootn_condition.tex` Panels **A, B, B′ and D are unaffected** by the correction to the stopping rule (they do change through §2's rescaling only where a rescaling can reach them — it cannot: they are all built from $\lambda_j/\lambda_{\max}$ or from $U$). **Panel C is affected**, being built from the error of the stopped iterate, and is regenerated.

## 8. Run 4 — $\kappa$(Gram) is rank-capped by the quadrature

| $\#\mathcal T$ | $n$ | $n_g$ | dim Gram | `length(sv)` | `sum(sv > max·1e-12)` | `qr(Mg)$rank` | $\sigma_{\min}/\sigma_{\max}$ |
|---|---|---|---|---|---|---|---|
| 12 | 500 | 780 | 500 | 500 | 249 | 301 | $1.31\times10^{-18}$ |
| 12 | 2,000 | 780 | 2,000 | **780** | 312 | 393 | $3.11\times10^{-21}$ |
| 48 | 500 | 3,120 | 500 | 500 | **500** | **500** | $9.79\times10^{-11}$ |
| 48 | 2,000 | 3,120 | 2,000 | 2,000 | 944 | 1,087 | $4.77\times10^{-19}$ |

The brief's claim is confirmed at the shipped configuration and refined:

- At $\#\mathcal T=12$, $n=2{,}000$: `svd(Mg)` returns 780 values, so **1,220 of the 2,000 eigenvalues of the $n_{\rm m}$-dimensional Gram are structurally zero and never enter the reported $\kappa$.** The $\ge$ mark is right, and at this cell it is right for the reason the brief gives. Panel A now prints "780 of 2,000".
- At $\#\mathcal T=12$, $n=500$ the cap does **not** bind ($n_g=780>500$), yet only 249 of 500 singular values clear a $10^{-12}$ relative threshold and $\sigma_{\min}/\sigma_{\max}=1.3\times10^{-18}<\varepsilon_{\rm mach}$. So at $n=500$ the $\ge$ mark is right for the *right* reason — genuine numerical singularity, not shape.
- **Refining removes the cap but not the singularity at $n=2{,}000$** (2,000 values computed, still $\sigma_{\min}/\sigma_{\max}=4.8\times10^{-19}$). At $n=500$, however, refinement makes the Gram numerically **non**-singular ($9.8\times10^{-11}>\varepsilon_{\rm mach}$, full `qr` rank), so part of the apparent singularity at that cell was quadrature resolution rather than ill-posedness. Neither reading changes `results.tex`'s own position, which expressly declines $\kappa$(Gram) as open item Q-4.

## 9. Retired-clause citations, corrected

- **B1(vi)** was cited at four sites as the justification for a finite index family. It is **retired** (dispatch 14), and retired on precisely the ground that `def:hatT` integrates over all of $\mathcal T$; it also required $\#\mathcal T_n\to\infty$, which `N_TGRID = 12L` is not, so `sim_thm_rootn_dgp.R`'s D6 gloss "B1(vi)'s growing family read at a fixed $n$" described no clause of it. All four sites now cite **B1(iii)** ($\mathrm{Leb}(\mathcal T)>0$), **B1(iv.b)** and **B1(iv.c)**, which is what a quadrature for a fixed $\Pi_t$ actually needs.
- **A3** was cited as live at three sites. It is **retired** (dispatch 13) *because it is a theorem*: `lem:momzero`(iv) gives $J=E[\Delta Z\Delta Z']$ and its nonsingularity is **A1b(iv)**. The Jacobian arm's comment additionally quoted `def:moment`'s claim that "$J$ is the matrix of A3 and it IS NOT $E[\Delta Z\Delta Z']$" — a claim the retirement note withdraws in terms. All three re-cite A1b(iv) / `lem:momzero`(iv); the arm's measurement is unchanged and is now framed as a check of a proved identity.

## 10. Three departures declared, not absorbed

- **$\Pi_u$ is truncated and data-dependent.** The nodes span $\pm4\,\mathrm{sd}(\Delta Y)$ while the density has $\mathrm{sd}=2\,\mathrm{sd}(\Delta Y)$, i.e. $\pm2$ of its own sd, so $2\Phi(-2)=4.55\%$ of $\Pi_u$'s mass lies outside the quadrature and the implemented measure's support is a **random** interval. B1(iv.a) asks for a fixed measure with a density strictly positive at every point of $\mathbb R$. Mitigations: the dropped mass sits where $\mathsf C_{h_u}$ has already saturated at 0 or 1, so it is nearly constant in the base point and largely cancels in the difference $\hat T$ is; and $\sum w_u\varpi_u$ enters $c_\Pi$, so the truncation is applied consistently to the operator and to the constant. Not fixed: the exact remedy is a wider span at proportionally more nodes.
- **$c_\Pi$ is deterministic.** Two shipped comments attributed part of $\bar m_n$'s randomness to it. `wu` $\propto\mathrm{sd}(\Delta Y)$ and `varpi` $\propto1/\mathrm{sd}(\Delta Y)$ cancel exactly, and $w_t$ and $\mathcal T$ are fixed before the data. $\bar m_n$ is still random and still reported with its MC SE — the only random ingredient is $h_u$. The attribution is corrected; the conclusion is not affected.
- **The index set is 3-dimensional, not $p=4$.** $\Delta Z_1\equiv1$, so $\Phi_1(\Delta Z_i)$ is constant and $w(t'\Phi)$ factorises: the $t_1$ direction multiplies the operator by a constant and integrating it only rescales $\Pi_t$'s mass. $\mathcal T$ is the cube in the three non-degenerate coordinates. This was implicit through round 2 and is now declared as D14.

## 11. Regenerated, and not

**Regenerated** (all from the one run whose fingerprint is recorded above): `paper/tables/sim/sim_thm_rootn_stopping.tex` (all four panels), `paper/tables/sim/sim_thm_rootn_condition.tex` (**Panel C** by the stopping correction; **Panel A** by the $\kappa$ correction and the new rank column; Panels B, B′, D re-emitted with identical content plus MC SEs on $\Pr(\text{exp wins})$), `paper/figures/sim/sim_thm_rootn_stopping.pdf`, `quality_reports/sim/sim_thm_rootn_phistep.rds`.

**Not touched:** `sim_thm_rootn_limitlaw.tex`, `quantiles.tex`, `seunits.tex`, `bias.tex`, `ablation.tex`, `dgpvalid.tex`, `qq.pdf`, `linresid.pdf`, `sim_thm_rootn_limitlaw.rds`, and the budget and Jacobian outputs. The limit-law arm was not re-run.

**One consequence to flag.** `sim_thm_rootn_dgp.R` changed (comments only: the D6 and A3 re-citations), so its MD5 moved from `5dcf1a39bfd33683c1ed35f4afb4ecdd` to `77ca9331b18e321bea0791eac5f3cfee`. The **limit-law checkpoint stores the old fingerprint**, so a future `run_all.R` will discard it and recompute that arm from scratch (~5.5 h) rather than resume. The numbers will be identical — the change is comment-only — but the cost is real and is stated rather than worked around by editing the stored hash, which would be exactly the provenance tampering the guard exists to prevent.

## Round-3 verdict, $\varphi$-step arm only

> ### The arm now measures `def:lfstep`. Its finding is that at this configuration the discrepancy stop is decided almost entirely by an unidentified constant, because the criterion it thresholds moves by less than 40% over the whole iteration budget.

The limit-law arm's verdict ("Matches at large $n$ only") is unaffected and stands.
