<!-- Persisted by the orchestrator 2026-07-30 on receipt. Body verbatim.
     Orchestrator verification appended at the foot: Finding A's two commands and
     Finding B1's limit were run, and all three confirm the critic. -->

# Monte Carlo Critic — `thm:rootn`, `panel-npiv-discrete`

**Severity: HIGH (Execution).** **Score: 45/100.** **Verdict: "Matches at large $n$ only" — not "Matches".**

---

## Phase 1 — Claim identification: PASSES, no early stop

The theorem under test is `results.tex` `\label{thm:rootn}`: under (T-1)–(T-5) and (R-a)–(R-e), $\sqrt n(\hat\theta-\theta_\dagger)=J^{-1}n^{-1/2}\sum\psi_\star+o_P(1)\to_d N(0,J^{-1}\Sigma J^{-1\prime})$, with $\hat V\to_p J^{-1}\Sigma J^{-1\prime}$ and the studentised statistic $\to N(0,1)$ **for any unit $\vartheta$**.

The claim is correctly typed and the four statistics map onto the four conclusions. The linearisation residual is the right sharpest statistic and is measured as a **per-replication vector norm**, not the norm of a cross-replication mean — so it does not launder bias away. The exact-nuisance ablation reproduces $O(n^{-1/2})$ to three digits (0.147 / 0.052 / 0.018; ratios 2.83, 2.89 vs $\sqrt8=2.83$). Clean implementation validation. **No early stop.**

---

## Q1. Injected nuisances: legitimate test, or tautology?

**Legitimate, and not arithmetic — but narrower than the "Does" clause claims, and one of the three narrowing idealisations is undeclared.**

Not a tautology because the theorem's content is not "the rates hold, therefore the rates hold". It is that the four Step-4 products **exhaust** the remainder. The design could have failed and did not: a term missing from `lem:biasexp`, a wrong $J$, a wrong $\Sigma$, a missing propensity correction would all have shown up. The sharpest instance is real evidence: $\hat\varrho$ perturbed at $r_n=n^{-0.32}$, far slower than $n^{-1/2}$, coverage nominal at $c_\delta=0.25$ — a genuine, falsifiable confirmation of `lem:sandwich`'s "no Neyman correction for the propensity appears in it", and the most valuable single result in the exercise.

Three idealisations narrow what may be claimed. Only (c) is declared.

**(a) Every injected error is mean-zero in direction — undeclared.** `draw_h`, `draw_dell`, `draw_rhat` draw `rnorm` coefficients and renormalise. `eq:biasb1`'s first-order bias is *bilinear* in $(h,\hat\ell-\ell_\star)$, both factors independent and symmetric, so it averages to ≈0 across replications. A real Landweber–Fridman error carries a deterministic regularisation bias that does not. The linearisation residual is immune (per-replication norm); **coverage and the sd ratio — the headline numbers — are not.** D3c declares anisotropy, not bias-vs-noise, which is the sharper omission.

**(b) Every injected error lives in a low-dimensional span containing the truth.** $h$ occupies 6 Fourier modes spanning only **three distinct frequencies** ($2\pi,4\pi,6\pi$), and $\varphi_\dagger=\sin(2\pi x)$ *is* the first. $\hat\ell-\ell_\star$ is drawn in the same 12-dimensional basis as $\ell_\star$; $\hat\varrho-\varrho$ is linear in $z$. Meanwhile the φ-step arm measures singular values decaying **exponentially**, so the operator's damped directions lie far beyond mode 6. **The two arms' findings are never connected**, and that connection turns "D3c did not achieve its intended geometry" into "the injection basis was structurally incapable of reaching it".

**(c) Full independence replaces complement-fold measurability (D3b).** Correct for the theorem *as stated*; means the exercise cannot verify cross-fitting does its job.

**What the paper may claim:** *the theorem's remainder accounting is complete and its constants are moderate, for mean-zero nuisance errors of exactly the priced size drawn in a span containing the truth.* It may **not** claim the limit law behaves "once the nuisance rates are met **with a small constant**" — that clause is asserted, not established.

## Q2. Is $c_\delta$ a free constant, or was the passing configuration chosen after the fact?

**Sweeping it is right. The labelling is wrong, and the verdict's entire defence rests on the wrong label.**

A5(ii) is $\|h\|_{L^2(\pi)}=O_P(\delta_n)$ with $\delta_n:=(\hat\delta_n\ln n)^{2\mu/(2\mu+1)}$ **and $\delta_n=o_P(n^{-1/4})$**. Both halves are invariant to a positive multiplicative constant. At the named configuration $\kappa\alpha=0.256>\tfrac14$, so $\delta_n/n^{-1/4}=n^{-0.006}(\ln n)^{0.8}\to0$ and **A5(ii)'s second half is TRUE**. It is a statement about a sequence, not a finite-$n$ ratio.

Therefore "at that setting $\sqrt n\delta_n^2=46.7$, so A5(ii)'s second half is numerically false and the theorem's hypothesis does not hold" **is false**. Both cells are on-hypothesis and satisfy *identical* hypotheses. There is no principled ground to exclude $c_\delta=1$.

The conditioning is quantifiably doing the work. If the distortion is driven by the quadratic remainder it must scale as $c_\delta^2=1/16$:

| $n$ | DGP | $c_\delta{=}1$ | predicted at $1/16$ | observed at $c_\delta{=}0.25$ | gap |
|---|---|---|---|---|---|
| 22,627 | A | 1.340 | 1.021 | 1.026 (SE 0.010) | 0.5 SE |
| 64,000 | A | 1.307 | 1.019 | 1.019 (SE 0.016) | 0.0 SE |
| 181,019 | A | 1.223 | 1.014 | 1.022 (SE 0.016) | 0.5 SE |
| 22,627 | B | 1.229 | 1.014 | 1.014 (SE 0.010) | 0.0 SE |
| 181,019 | B | 1.184 | 1.012 | 1.022 (SE 0.016) | 0.6 SE |

**The remainder is present at $c_\delta=0.25$ and behaving exactly as the budget says.** It clears the 2-SE bar because $c_\delta^2$ scaled it below a noise floor itself widened by halving $B$ (B3).

**Cherry-picked?** No — D4's rationale is in the script header ex ante and only two values were run. The defect is in the verdict's *logic*, not the design's integrity. The honest, stronger statement: *the hypotheses hold in both configurations; finite-sample quality is governed by $c_\delta^2\sqrt n\delta_n^2$, and at the constant the theory's own symbols suggest it is poor over the entire feasible range and deteriorating in $n$.*

---

## Findings

### A. CRITICAL (−14) — the φ-step tables cannot have been produced by the shipped script

Every branch of `phistep_rep` bounds the stop by the cap, so $\hat m^{(1)}\le\bar m_n$ in every replication. Panel A of `sim_thm_rootn_stopping.tex` violates this in 3 of 6 rows (ratios 1.045, 1.030, 1.008). Corroborating: `mbar_new` is `prelim`-free by construction with cross-cell MC SE ~0.1%, yet the observed spread at $n=500$ is 8% — 20+ SE — while the three saturating $c_{14}$ cells agree with each other to 0.12%. **For the φ-step arm the evidence says pre-fix results were not regenerated, or the script has changed since.** Likely cause: `cap_mbar()` in `sim_thm_rootn_dgp.R` uses proportionality constant **1** while the live path uses $\omega_{\rm thy}$ realised at 77.6–119.3; `cap_mbar()` and `band_hu()` are **dead code, never called**.

**Until re-run, no number from the φ-step arm may be quoted — including finding #2.**

### B. CRITICAL (−14) — the verdict paragraph is not supported by its own tables

**B1.** The exculpatory clause is false (Q2). **B2.** "Every gap shrinks monotonically" is contradicted: DGP-A sd ratio 1.026 → 1.019 → **1.022**; DGP-B bottoms at $n=8{,}000$ and **rises over the last three points**; worst quantile gap non-monotone, **2.64 SE at $n=8{,}000$**, outside the bar. **B3.** "Matches at the largest $n$" is partly an artefact of halving $B$ (5000→2000) exactly at the two cells where the verdict is pronounced, inflating the sd-ratio SE 0.010→0.016. On the engineer's own bar the sd ratio **fails at every $n\le22{,}627$** (5.9 / 4.0 / 2.6 SE), and at $n=181{,}019$ **would be 2.2 SE — a fail — had $B=5000$ been kept.** **B4.** At $c_\delta=1$ the mismatch **grows**: 90% coverage 0.882 → … → **0.849** (6.4 SE below nominal). The summary reports only the *worst quantile* gap in SE units — the **smallest** available measure — while the sd ratio at the same cells is **11.7 SE** and 90% coverage 4.75 SE below nominal, neither stated in SE units.

### C. MAJOR (−10) — reporting discipline

Centring (`mean_mixed`) computed and never reported; seven MC SEs dropped (`V_gap_se`, `asymmetry_se`, `m1_se`, …); the second contraction direction computed and suppressed; the $c_\delta=1$ quantile set and the DGP-validation results have **no exported artifact**; `condition.tex` Panel C's "zero" column is **arithmetic sold as measurement** (printed MC SE 0.0000, reproduces $\|\varphi_\dagger\|/\delta_n$ to three digits) while its genuinely informative "rate" column is unmentioned; finding #2's headline is the **mean of a bimodal statistic**; `sat_any>0.99` reported as "100%"; `jacobian.tex` Panel D returns an **exact null** (ratio 1.000) and the summary is silent.

### D. MAJOR (−7) — φ-step numerics

Both condition numbers at/past double precision — reported $1.1\times10^{33}$ implies $\max/\min=3.3\times10^{16}$, **exceeding $1/\varepsilon_{\rm mach}$ by 7×**; the compression $\kappa$ moves only 12% when $L_x$ goes 6→9 where exponential decay predicts ~400×, so it is pinned by the floor. The power-vs-exponential fit runs on **5–8 points** and **flips with the preliminary** — proof it is unresolved; the safe statement is *the spectrum is far steeper than $a=\tfrac34$ over the resolvable directions; its functional form is not identified at this $L_x$*. $L_x$ is never placed against its own window, though the budget arm's whole thesis is placing asymptotic conditions at feasible $n$.

### E. MAJOR (−6) — coverage and reproducibility

No assumption-broken DGP, so "Matches" is a non-rejection by a procedure never shown able to reject a violation (*partially mitigated* by the $-\hat J^{-1}$ counterfactual and the $c_\delta$ contrast). One non-adversarial $\vartheta$, while DGP-B was built with $\kappa(J)=27.7$ and its ill-conditioned direction is never tested. **90% coverage in DGP-A is below nominal in 8 of 8 cells** (sign test $p=0.004$) and the verdict table reports only the 95% level. **`N_CORES <- detectCores()-1` with `mc.preschedule=TRUE` makes every number a function of the host's core count.**

### F. MINOR (−4)

INV-17 (`lines <- c(lines, ...)` in table emission); dead code duplicating `eq:cap` with a different constant; the Bahadur SE uses the asymptotic density (correct as null-referenced, but overstates the $c_\delta=1$ gaps by ~20%) and multiplicity is unaddressed (the observed max is in fact **below** $E[\max_{14}|Z|]$, which *strengthens* the case at $c_\delta=0.25$ and is not said); `label_parsed` will render "DGP − A".

---

## What I checked and found sound (no deduction)

- **Both seeding defects are genuinely fixed in the shipped scripts.** No `set.seed()` on any parallel path; `nextRNGStream` + `mc.reset.stream()` present and correctly ordered in **both** `limitlaw.R` and `phistep.R`; the stream is advanced for checkpoint-skipped cells so a resumed run reproduces a fresh one. **Only the φ-step outputs are in doubt (Finding A).**
- **The log-log grid rationale is backed by the resolution it claims.** $(\ln n)^{1/4}$ moves **27%** across the grid against a ~1% SE — ~27 SE. **Verified, not a rationale without resolution.**
- **All budget arithmetic exact**, including the $\ln n=133.3$ turnover, $\log_{10}n=394.4$, and the 12.4–54.1 amendment factor. The log-free reading gives 0.87–0.94 — below 1 at every $n$ — against 11.7–46.7 for the amended symbol. **A genuine and valuable finding, correctly computed.**
- **MC SEs correct and stated before any gap is interpreted.**
- Distributional comparison, 3.16-orders grid, two DGPs with the favourable one's hypotheses *measured* — above the standard bar.
- **The core grid runs the harsher geometry** (smooth is worse than rough), a point in the exercise's favour the summary never makes.

## The two already-acted-on findings

**#1 ($J=E[\Delta Z\Delta Z']$): not over-read, but the design guaranteed the answer.** The DGP makes the identity true **by construction** ($\Delta U$ drawn with no dependence on $W$), so the measurement is an implementation check on `dgp_draw`, not independent evidence about the population identity. $\max|t|=2.46$ over 16 entries is a clean non-rejection ($p\approx0.20$). *"Did it get lucky? Somewhat"* — a 3.2 was within reach, and the right reading would still have been "the algebra says zero, the MC is noisy". **Missing: the power statement** — the pilot can exclude only a summand exceeding **0.24% of $\|J\|_\infty$**. The claim was carried by the one-line argument, stated first and correctly and routed as "none is a counterexample" — **that framing was right** — but the simulation alone would not have supported retiring A3.

**#2 (`prp:stopfeas` tuning-critical): qualitatively stronger than claimed, quantitatively unsupported.** Two decades of transition with **one** interior grid point at which the statistic is a mixture, so the shape is unresolved — but at that point the switch moves **25,121 → 4,204 → 1** across a 16× change in $n$, so **no fixed $\mathsf c_{14}$ can be $n$-stable**. **The Lepskii comparison is not fair as run**: made where the DP saturates by construction, with no cell reporting the DP at an intermediate $\mathsf c_{14}$.

---

## Score: 45/100

| # | Finding | Severity | Δ |
|---|---|---|---|
| A | φ-step tables not reproducible from the shipped script | CRITICAL | −14 |
| B | Verdict unsupported by its own tables | CRITICAL | −14 |
| C | Reporting discipline | MAJOR | −10 |
| D | φ-step numerics | MAJOR | −7 |
| E | Coverage and reproducibility | MAJOR | −6 |
| F | Minor set | MINOR | −4 |

**Recovery path:** re-run the φ-step arm and regenerate its tables (+14); rewrite the verdict against what the tables say and re-run the two largest $n$ at $B=5000$ for constant precision (+14) → ~73; add the suppressed quantities and a DGP-validation table (C) → clears 80.

## Verdict for the binary gate

> **"Matches at large $n$ only."**

Not "Matches": the sd ratio fails at every $n\le22{,}627$ and clears only where $B$ was halved; $c_\delta=1$ is equally on-hypothesis and matches nowhere; and the $c_\delta=0.25$ distortion is present and $\approx1/16$ of the $c_\delta=1$ distortion, reproduced to within 0.6 SE by quadratic scaling.

Not "Persistent mismatch": nothing here is evidence against `thm:rootn`. The linearisation residual — the sharpest statistic — **declines monotonically in every cell of every panel, including $c_\delta=1$**; $\|\hat V-V\|_\infty$ likewise; the ablation reproduces $O(n^{-1/2})$; the Jacobian sign is confirmed three ways.

**Clears binary gate 5** (`quality.md` §3(5)). **The submission gate is blocked on the weighted route:** the simulation component is 45, below the 80 per-component minimum. **Escalation: simulation-engineer, not theorist** — every finding is design, numerics or reporting.

---

## Orchestrator verification appended 2026-07-30

**Finding A — CONFIRMED, and worse than estimated from the tables.** Ran both named commands. Five cells have $\hat m^{(1)}/\bar m_n>1$: **1.045, 1.060, 1.030, 1.008, 1.005** — the critic identified three from the shipped `.tex`; the `.rds` holds five. And the `mbar_new` spread, predicted `<1.005` and estimated at ≈1.08 from the tables, is measured at **1.222 / 1.156 / 1.049** at $n=500/2000/8000$. The φ-step arm's outputs are not reproducible from its script.

**Finding B1 — CONFIRMED symbolically, and it is a correction the orchestrator owes upstream.** `sympy.limit` of $c_\delta\,\delta_n/n^{-1/4}=c_\delta\,n^{-0.006}(\ln n)^{0.8}$ is **0 for every positive $c_\delta$**. A5(ii)'s second half is therefore true and invariant to the swept constant; both cells are on-hypothesis and the failing one cannot be set aside. The orchestrator relayed the engineer's exculpation as sound reasoning without checking it — one `limit` call. (The ratio nonetheless *rises* to a peak at $\ln n=400/3$, $n\approx10^{58}$, which is why the finite-$n$ picture and the asymptotic statement disagree without contradicting.)
