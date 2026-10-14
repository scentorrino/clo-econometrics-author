# Verification report — `panel-npiv-discrete`, L-category instrument

**Date:** 2026-08-10 · **Scope:** theory corpus + engine, after Phases 1–8 of the L-category
generalization. Theory builds clean: exit 0, **435 pages**, no hard errors, no undefined refs, no
multiply-defined labels, no unresolved cites.

---

## Theory Binary Gates (`.claude/rules/quality.md` §4, PROJECT_TYPE mixed)

| # | Gate | Result |
|---|---|---|
| 1 | Every theorem proved, keyed by `\label`, no stubs | **56 declared / 56 proved / 0 missing**; 0 TODO-XXX-FIXME. **CLEARS** |
| 2 | theorist-critic ≥ 80, no unresolved CRITICAL | 5a **94** · 5b **84** · 5c **88** · 5d **84** · 5e **82**. **CLEARS** (min 82) |
| 3 | counterexample-hunter: no confirmed counterexample | **No confirmed counterexample.** **CLEARS** |
| 4 | No unresolved escalation | The one CRITICAL — (P-g) — is repaired across five files and rebuilt. **CLEARS** |
| 5 | Simulation verdict | **N/A** — no simulation section present |

Gate 1 is run against the **compiled corpus** (the eight files `driver.tex` inputs), per the
2026-08-05 repointing. `results.tex`, `assumptions.tex`, `results_main.tex` are retired mirrors
compiled by no document; their divergence is by design and is not a gate input.

## Phase 6 narrow-critic scores

notation **46** · assumptions **30** · regularity **41** · counterexamples **80**. All four reports are
persisted under `quality_reports/{notation,assumptions,regularity,counterexamples}/`. Every finding
they raised has been repaired or has a named **editing** acquirer — a read-only critic can never be
one, which is the failure mode that stranded nine items earlier in this track.

The one CRITICAL: **(P-g) was a factor `h_u` too weak for the step consuming it**, so `thm:rootn`
inherited a hypothesis that did not cover its own admissible window. Repaired at 11 sites in 5 files.
Threshold moved `s > 31/30 → 11/10`; **both running configurations sit at `s = 3` and clear with
margins +2.13 and +2.06, so no conclusion was lost.**

---

## Engine faithfulness — engine against theory, line by line

Three divergences found. **Two were silent and are now repaired; the third was already declared.**

### F1 — the operator scale (silent; repaired)

`eq:Mdef` is `𝓜(u,t,l) = E[W̃_l·1{·}·w(t′Φ)]` — **no prefactor** — and `results_s3_estimation.tex`
carries zero `Ω^{-1}` or `ϱ(1−ϱ)` prefactors on any operator display. The engine divided by
`w̄(1−w̄)`.

**Invisible at L=2, which is why it survived**: it scales the residual and the plug-in `δ̂_n`
identically, so the discrepancy ratio the stop compares against `τ_DP` is invariant — measured
**0.216932 both ways**. It cancels.

**It stops cancelling at L≥3 if ported cellwise.** At §6's realised shares `(0.700, 0.115, 0.066,
0.119)` the per-cell analogue gives relative weights `(1.03, 1.70, 1.00)` — **cell 2 up-weighted 1.7×
against cell 1 by a factor the theory does not contain**, `Π_w` being what carries the `l`-weights.
**Repaired**: the scale is `l`-independent, where it cancels; the legacy value is retained only at L=2.

### F2 — the bandwidth was the amended rule at the one α the theory excludes (silent; repaired)

Amended C5′(i) is `h_u ≍ sd(ΔU)·δ̂_n^{1/p_K} = n^{−α/8}` at `p_K = 8`. The engine used `n^{−1/16}` —
and **`n^{−1/16} = n^{−α/8}` exactly at `α = 1/2`**, verified to `0.000e+00`. A5(iii) and
`rem:h6bandwidth` put α **strictly** below 1/2, so the engine bandwidth was always **narrower** than
the theory asks by `n^{(1/2−α)/8}`: **16.8% at `n = 983, α = 0.32`** — the §6 configuration — and
11.4% at `α = 3/8`. **Repaired**: `bw_u()` takes α; `alpha = NULL` reproduces the legacy path
bit-for-bit, so no existing caller moved silently.

### F3 — τ_DP (DECLARED, not silent; no change made)

A7 / `eq:lfsched` stop at `‖·‖ ≤ τ_DP·δ̂_n·ln n`, `τ_DP ≥ 1`, chosen 2.1. The engine stops at
`‖·‖ ≤ 0.7·δ̂_n`, **no `ln n`** — **18.0× tighter at n=400, 20.7× at n=983, 25.6× at n=5000**.

**A7 is a ceiling** — stop no later than — so a tighter stop is inside it, and the engine registers
`tau_dp` as an implementation constant **exactly as `t_scale` is**, with the calibration printed: used
literally the rule stops at `m = 1` at these `n`, costing φ ISE **0.134 against 0.023** at the oracle
stop. **The theory records the same diagnosis independently**, computing `2.1 × 0.018 × 0.216 × ln 983
= 0.0563` and noting it sits below the initial discrepancy. **Engine and theory agree on the fact and
differ on the response.** Per §4 item 8 the realised `𝖼₁₄` and stopping index are reported and **no
verification is claimed** — `𝖼₁₆` is analytic and unknown to the analyst.

### Verified already satisfied — no change made

**`Π` is a probability measure.** The theory warns `eq:cap` is proportional to `c_*` and records a
Monte Carlo reporting **≈2.9× cap inflation**. Measured: `Π_u` is the empirical measure (mass 1),
**`sum(pi_t) = 1.0000000000` exactly** at every `n_t ∈ {4,8,16}`, and `Π_w` is normalised by
construction. **The predicted bug is not present**, and an edit here would have been the defect.

---

## Engine generalization — L=2 preserved exactly at every step

| component | L=2 invariant | L≥3 |
|---|---|---|
| `fit_propensity_multi` | **identical to `0.000e+00`**, incl. `d_Z=0` fallback | multinomial, projected onto `eq:trunset` |
| `project_trunset` | box = simplex at L=2 | **simplex**: box at L=3 raw `(0.7,0.7)` gives `q₀ = −0.400`, `λ_min(Ω̂) = −0.280` (**not PSD**); simplex gives `+0.030`, `+0.01455` |
| `operator_residual` | `‖T̂‖ = 1.5226861664e-02`, ratio `0.216932` — **unchanged** | `n×(L−1)` contrast, `Π_w` aggregation, adjoint contracted over `l` |
| `solve_balance_weight` | `ell` `n×p`, shape and value unchanged | `n×p×(L−1)`; `p(L−1)` solves, one `D_W` per cell |
| `bw_u` | legacy identical to `0.000e+00` | α-aware |
| `crossfit_once` | θ̂ = (+0.99677, −0.38685) | θ̂ = (+0.98152, −0.52822), truth (1.0, −0.5) |

> **An efficiency result, measured not asserted.** Balancing is **better at L=4 than at L=2** —
> `rel_bal` (0.00222, 0.00475) against (0.00594, 0.00875) on the same design. The surplus contrasts
> buy balancing power, which is what the rev-1 plan predicted and the first direct evidence for it.

## Diagnostics the application will report

`theory_diagnostics()` / `print_theory_diagnostics()`. Reported, **never gated on** — the assumption
audit established that of A4(i)'s eleven consumers three need only the floor's **positivity** and eight
need its **value**, and **none of the eight is on the θ-step's inferential path.**

At a four-cell design, `n = 983`, `ε_ϱ = 0.0115`: `min_l ϱ̂_l` against `1/L`; `λ_min(Ω̂)` against
`ε_ϱ/L`; **`c_W̃ = 1.414214`, flagged as NOT the binary 1**; `δ̂_n` with its **binding branch named**
(at L=4 with `r_n = n^{−1/3}` the `r_n` branch binds, where the binary case binds on the variance
branch — the fact `thm:rootn` Step 4(c) turns on); and realised `𝖼₁₄` with the no-verification note.

---

## Two things §6 must state, printed nowhere in the corpus before Phase 6

1. **Consistency of every cell set is NECESSARY, not sufficient, for A1.** A DGP exists where A1 fails
   at the truth, every conflict set is empty, the diagnostic reports nothing, and the estimator
   converges to the wrong `φ`. Not a counterexample — the converse is never asserted — but §6 will be
   attributing a non-rejection, and **the false-negative rate is unpriced.**
2. **A4(ii)'s upper bound read with A1b(iv) forces `ΔZ` to carry exactly one non-zero constant
   coordinate** — the differenced equation must have a period effect.

Both are now printed in `assumptions_supp.tex`.

## Outstanding

**Phase 9** — re-run §6 on the four-category trigger instrument. Precondition **settled and
favourable**: cells 685/114/66/118, `min_l ϱ̂_l = 0.0115` against `1/L = 0.25`, `λ_min(Ω̂) ≥ 1.13e−02`
against the floor `0.00287`. **No merging needed; localisation not forfeited.**

**Deferred by the author:** D5 (page budget, 104pp against OBES's 25–35) and F9 (67 theory-file em
dashes).
