# Plan rev-2: L-category instrument — re-scoped after Phase 1

**Status:** supersedes `2026-08-08_multinomial-instrument.md` from Phase 2 onward
**Phase 1:** COMPLETE. Compiles clean, 357pp, no CRITICAL, every printed derivation verified.
**Reason for re-planning:** Phase 1 consumed five worker–critic rounds against a budget of one.

---

## 1. Post-mortem — why rev-1 mis-sized the work

Five rounds, scores 61 / 45 / 61 / 47 / 62. Causes, in order of cost:

**(a) Three blocking findings were the orchestrator's, not the agent's.** The weight-class
bijection, the τ_DP reconciliation, and the claim that L>2 "converts A1 from untestable to
testable" were all supplied by me as direction and were all wrong. Each cost a full round, and
two of them were wrong *about the code* — I asserted what `lf_panel.R` does without reading it
closely enough. **Rule: the orchestrator verifies any claim about the engine against the engine
before putting it in a dispatch, and marks inferred claims as inferred.**

**(b) The comment layer is two-thirds of the file and no build checks it.** ~3,000 of
`assumptions_main.tex`'s 4,600 lines are archaeological commentary. It has no index, so a
correction must be propagated by hand, and rounds 3–5 each closed a set of stale comment sites
and left or created another. This is a property of the corpus, not of the agent.

**(c) Author decisions were discovered at the gate rather than surfaced before dispatch.** Three
of them — the Ω⁻¹ placement, the reversal, the meaning of the multi-category instrument — each
surfaced mid-phase and each cost a round.

**(d) `proofs.tex` is larger than the file that took five rounds.** 8,883 lines and 274 sites,
scoped in rev-1 as a single phase.

---

## 2. What changes

### 2.1 Gate on printed text; sweep commentary once

Phase gates apply to **printed** LaTeX only — what compiles into the PDF and what a referee
reads. Commentary is corrected opportunistically within a phase's own sites and otherwise left.
A single dedicated pass (Phase C) sweeps it after the mathematics is settled, when the files are
open anyway.

Rationale: the printed artifact was fit to consume at round 3; rounds 4 and 5 were spent on a
layer no build checks and no reader sees. That is the wrong place to spend a gate.

**Critics are instructed accordingly**: report comment-layer defects as a separate, non-scoring
appendix. They still get recorded — they are not to be silently dropped.

### 2.2 Decompose by RESULT, not by file

`proofs.tex`'s 274 sites belong to named lemmas. Dispatch by lemma-group, so each unit is
reviewable in one pass and a failure is localised.

### 2.3 Decision inventory BEFORE each dispatch

Each phase opens with the orchestrator listing every choice the phase will force, and the author
ruling on them before an agent is dispatched. Where the orchestrator has a recommendation it
states it and its ground; where it does not, it says so.

### 2.4 Two rounds per phase, then escalate

Rev-1's three-strike rule let a phase run five rounds through a mid-flight decision reset. Two
rounds, then escalate with a specific question.

---

## 3. Revised phases

| # | Unit | Contents | Rounds |
|---|---|---|---|
| **2a** | `results_s2_identification.tex` — **types and definitions** | `def:model` (W's support), `def:operator`, `def:spaces`, `def:admissible`, `def:weight` (clause (a) is a RANGE condition — do not weaken to bounds), `eq:kernel`'s arity | 2 |
| **2b** | `results_s2_identification.tex` — **results** | `lem:bierens` (conclusion survives at every L; the printed ground is binary-only), `prp:frechet`, `prp:compact` (arity, to agree with `def:hatA`), `prp:orthog` (i)–(iii), `prp:kerchar`, `cor:udep` | 2 |
| **2c** | **The localisation proposition** — the deliverable | New result: the L−1 systems agree at a common φ; per-cell decomposition is what localises a violation. Joint-consistency / J-type statistic as apparatus. NOT an overidentification-creates-testability claim | 2 |
| **3** | `results_s3_estimation.tex`, `results_s4_asymptotics.tex`, `results_s3_supp.tex` | `eq:lfsched`, `eq:psidef`, the algorithm, the rate statements. Light: 29 sites total | 2 |
| **4** | `results_supp.tex` | `prp:wellposed`, `prp:norangeinv` (and the Ω rename), **`lem:adjoint`(i)** — see below — `def:dirclass`, `rem:orthoghyp`(5), `eq:Wderiv`'s ‖𝒲‖ bound, 109 sites | 2 |

> **`lem:adjoint`(i) re-assigned to Phase 4, 2026-08-09 — ORCHESTRATOR ERROR, recorded.**
> Rev-1 and this plan's first draft both listed it under Phase 2b. It is in `results_supp.tex`,
> so the 2b dispatch scoped it out as Phase 4's — correctly — **but never re-assigned it, and the
> Phase-4 hand-off named only `def:dirclass`. It therefore belonged to no phase.** Caught by the
> 2b critic (finding C), shared ownership. What it needs: `lem:adjoint`(i)'s hypothesis line still
> reads "with $g_{u,t}$ as in `eq:kernel`" — an object `eq:kernel` no longer prints — and
> $(\mathcal A^\ast\ell)(x)=\int_{\IR\times\mathcal T}\mathsf k(u,t;x)\ell(u,t)\,\Pi(du,dt)$
> is over a two-factor base with no sum over $l$, while clause (iii) of the same lemma is already
> at the L form and `prp:orthog`(i)'s ⟺ closes through it.
>
> **Scope-reduction rule, adopted from this:** when a dispatch removes an item from a phase's
> scope, the removal must name the phase that acquires it, in the plan, before the dispatch goes
> out. A scope reduction without a re-assignment is how an item leaves the plan entirely.
| **5a–5d** | `proofs.tex`, **by lemma-group** | ~70 sites each. Groups fixed at Phase 4's close, from the actual `\begin{proof}` inventory | 2 each |
| **C** | **Commentary sweep** | One pass over the comment layer in all eight files, once the mathematics is settled | 1 |
| **6** | Narrow critics | notation-warden, assumption-auditor, regularity-checker, counterexample-hunter, in parallel | — |
| **7** | Engine | multinomial `fit_propensity`, vector `wtil`, adjoint sum over l, τ_DP = 2.1 with 𝖼₁₄ | 2 |
| **8** | Faithfulness + full verification | engine against theory line by line; build; render; binary gates | — |
| **9** | §6 re-run | four-category trigger instrument | — |

---

## 3b. Carried OUT of Phase 2b (critic round 2, 82/100 — CLEARS)

**N2 — two PRINTED statements in the shipped supplement are false as printed at L≥3.**
Not token debts. `results_supp.tex:762` (‖Υ‖ ≤ 2c̄_π^{1/2}) and `:1533` (`lem:balance`(i)) both
carry a constant derived from a (P1) step that reads ‖W̃D‖ ≤ ‖D‖. **(P1) at `proofs.tex:860` is
still the binary |W̃| ≤ 1.** At L≥3, sup‖W̃‖₂ = √2, so the constants need min{√2, √(L−1)}.
Sources: `proofs.tex:7506`, `:2872`, `:2882–2892`, `:7573`. **Owner: Phase 4 (statements),
Phase 5 (sources).** Unowned before this.

> Useful corollary the critic established: **sup‖W̃‖₂ = √2 for every L ≥ 3**, so the bound
> saturates at L=3 and **§6's L=4 is not a distinct risk beyond L=3.**

**N5 — and the repair offered for it does not close it.** Per-cell (P1) with Frobenius gives
‖DW̃‖ ≤ √(L−1)‖D‖_F; Cauchy–Schwarz via ‖W̃‖₂ gives √2‖D‖_F. **Neither returns 1**, and the
printed inequality is genuinely false — take D = [d, −d] with W̃ ≈ (1,−1). Diagnosis right,
repair wrong. Phase 5 must derive, not adopt.

**N1 — Phase 3's hand-off was declared COMPLETE and is not.** Add to Phase 3:
`results_s3_estimation.tex:471–475` (`eq:Jhat`, the sample twin of `eq:JSig`), `:254`, `:288–289`,
`:344`; and `results_s4_asymptotics.tex:45` and **`:63`, which is inside numbered display
`eq:quadrem` of printed proposition `prp:sharpquad`**, where W̃ϑ'∂_uℓ_⋆ is (L−1)×(L−1) where a
scalar is required. Add to Phase 4: `results_supp.tex:1193` (`lem:secondord`(i)), `:4769–4771`.
The whole chain q → σ_q → ϑ'σ_q/π → the sharp constant is un-retyped and unowned.

**N4 — do NOT tell Phase 4 to "move Ξ".** Ξ carries **three** species in the corpus: generic
element of L²(Π); generic direction ℝ×ℝᵖ→ℝᵖ; generic real r.v. / ν_g/π. The four coupled sites
retype; `results_supp.tex:2121` and `proofs.tex:1289` must **not**. Route to the notation-warden
in Phase 6.

**Sequencing instruction for Phase 4, verified:** `def:dirclass` (`results_supp.tex:1038`,
`:1046–1047`) types **both** r and D at binary arity and is upstream of E2/F1/F4/F5/F7 — none
resolves before it. **Retype `def:dirclass` first.**

---

## 3c. Carried OUT of Phase 2c (critic 88/100 — CLEARS)

**O1 / O8 — TWO PROOFS MUST BE PASTED INTO `proofs.tex`, AND §2.2 WOULD HAVE MISSED THEM.**
`prp:localise` and `rem:localise` are theorem-like environments in the compiled corpus with **no
matching `\begin{proof}`** — verified by direct grep, zero matches. Binary gate 1 is blocked on
exactly this. Both proofs are written in full and paste-ready in
`results_s2_identification.tex:1399–1636`, and the critic verified them line by line.

**The orchestrator error this closes:** §2.2 fixes the 5a–5d lemma-groups "at Phase 4's close,
from the actual `\begin{proof}` inventory." **Two proofs that are not yet IN the inventory would
not appear in that enumeration**, and the hand-off existed only in a comment in a file Phase 5
has no reason to open. Same species as the `lem:adjoint`(i) loss — work that leaves the plan by
falling between two rules. **Phase 5's group construction must start from this section, not only
from the grep.**

**O8 is a mathematical discovery, not bookkeeping.** `rem:localise`(1)'s proof derives
p_l(B) = ϱ_l·P(ξ_φ ∈ B | ΔZ) at general L under **no overlap condition** — which at the truth
*is* `lem:bierens`'s missing (c)⟹(a) step, and is **strictly better than the route Phase 2b
earmarked**: no degenerate-region case split is needed (where ϱ_l = 0 both sides vanish; where
ϱ_l = 1 both equal P(ξ ∈ B | ΔZ)). **Phase 5: lift it, do not re-derive.**

**O7 — `prp:localise`(i) prints at L≥3 an equality the corpus supports only at L=2.**
`proofs.tex:2118–2119` (binary (c)⟹(a)) and `:2142` (two-factor Π against `def:spaces`'s three);
`cor:opsol`'s proof at `:2168–2173` inherits `lem:bierens`'s proof *wholesale*. Phase 5. O8 is
the replacement for the first half.

**The Q-transfer non-transfers are NOT of equal weight, and the pass printed them as if they
were.** C1(ii)'s **lower** bounds have **no consumer anywhere in the corpus** — every C1(ii)
citation is ‖π‖_∞, ‖1/π‖_∞, π > 0, or the upper ratio c̄_π — so that non-transfer is true and
inert. **A2, A2′ and H1 are the live half: there is currently NO RATE THEORY AT Q AT ALL.** That
is distinct from the statistic's rate being unestablished, and it is what a sub-population
reading would need.

**Consistency is only NECESSARY for A1.** A cell showing no conflict is **not exonerated** — some
other φ may reconcile the cells while A1 still fails there. That is the **false-negative rate of
the whole localisation procedure**, it is printed nowhere, and §6 will need it.

**N1′ — RESOLVED, AND THE ESCALATION WAS THE ORCHESTRATOR'S ERROR.** `rem:localise`(7) exhibits
a **relevant**-instrument witness (L=3, f⁽¹⁾ = 1 + γ(x₂−x₁), μ₀=μ₁=−1/3, μ₂=2/3; first stage
E[X₂−X₁|W=1] = γ/6 against 0 elsewhere; 𝒱_{0,1} ⊊ 𝒱). The mechanism is `prp:nophifree`/`eq:tilted`:
with δ_l := f⁽ˡ⁾_{X₂} − f⁽ˡ⁾_{X₁}, the first moment alone decides.

> **But the escalation should never have happened, and this is the lesson.** CFF
> (`centorrinofeveflorens2019`) **ASSUME** the relevance condition — Assumption 2.2, conditional
> completeness — and treat it exactly as: state it, relate it to completeness (Remark 1), bound it
> (Remark 2: under U ⊥ (X,W) it reverts to completeness, fails for discrete W, and φ† is only
> **partially identified**), illustrate it (Examples 1, 2). **A1b(iii) is the conditional analogue,
> and clause (iv)'s hypothesis is the same kind of object: a modelling condition whose plausibility
> is discussed, not a theorem needing a witness DGP.** I framed its non-vacuity as phase-blocking
> and reversed myself three times on it. The author's assessment — "the identification strategy here
> is just a generalization of theirs with conditional independence instead of full independence" —
> is correct, and "making a mess out of nothing" is a fair description of the excursion.
>
> **Rule adopted:** before escalating the satisfiability of a modelling condition, check how the
> companion paper handles its analogue. Assumptions in this literature are argued for, not
> constructed.

**N1″ — a DISCUSSION POINT, not a gap.** `rem:localise`(7) needs δ₀ = δ₂; §6's chronic-cell story
is a δ₀ ≠ δ₂ reading, which the worked example does not cover. CFF's Examples 1 and 2 do not
exhaust their Assumption 2.2 either. **§6 is NOT forbidden from the chronic/transient reading** —
O9's prohibition is dropped; §6 states the condition, cites CFF's 2.2 as the unconditional
analogue, and discusses plausibility.

**Superseded — the former framing of this item:** `rem:localise`(6) witnesses
clause (iv)'s hypothesis only with W ⊥ (X₁,X₂) — an **irrelevant instrument**. Per the author:
"it doesn't make any sense in an IV paper to use an assumption where the IV is irrelevant." §6's
design is exactly *relevant instrument + localised failure*, and **no example exhibits both**.
Currently dispatched to the theorist. If it proves unsatisfiable with a relevant instrument,
`prp:localise`(iv) is vacuous for this paper and must be withdrawn or heavily qualified.

## 3d. Phase 9 precondition — SETTLED, and it is good news

**The four-category instrument CLEARS A4(i) on the Section 6 data.** Measured 2026-08-09, d_Z = 5,
multinomial logit, n = 983: cells 685/114/66/118; min_l ϱ̂_l = **0.0115** with **zero** counties
below 0.01; λ_min(Ω̂) minimum 1.13e−02 against the guaranteed floor ε/L = 0.00287. So
ε_ϱ = 0.0115 < 1/L = 0.25 and **no merging is needed — the localisation is not forfeited in the
application.** Cell 2 (n = 66) binds first, as expected, but binds at 0.0115 rather than at zero.

**And the reversal decision is what makes a thin cell affordable:** under the raw contrast
‖W̃‖_∞ ≤ 1 is free of ε. Had Ω⁻¹ been retained, constants would carry ε⁻¹ ≈ 87, with sensitivity
ε⁻² ≈ 7.6e3 and curvature ε⁻³ ≈ 6.6e5.

---

## 3e. Phase 5 groups — FIXED 2026-08-09, and there are FIVE, not four

Measured, not estimated: `proofs.tex` is **8,883 lines / 55 proofs / 271 sites** (a site is a line
matching `widetilde W|varrho|\{0,1\}`). §2.2's "~70 sites each" implies four groups, and a naive
four-way cut puts **88 sites and 3,750 lines in one group**. Cut instead on dependency boundaries,
which gives five:

| group | lines | sites | proofs | first → last |
|---|---|---|---|---|
| **5-O1** | — | — | +2 | the paste; see below. Runs FIRST |
| **5a** | 1–2520 | 70 | 21 | `lem:pbounds` → `lem:adjoint` |
| **5b** | 2521–3577 | 68 | 8 | `prp:nophifree` → `prp:orthog` |
| **5c** | 3578–5143 | 27 | 9 | `lem:balance` → `prp:norangeinv` |
| **5d** | 5144–7327 | 61 | 10 | `lem:opnoise` → `lem:momzero` |
| **5e** | 7328–8883 | 45 | 7 | `lem:prelimtheta` → `prp:medianpart` |

5c is light in sites but carries the Ω→𝒪 rename and `prp:sharpquad`'s constant chain (§3b N1), so
it is not merged.

**5-O1 runs first, and §3c is why.** O1's two proofs are not in the `\begin{proof}` inventory, so
§2.2's construction rule cannot see them — the exact failure §3c warns about. Worse, they create a
**cross-group dependency**: O8's lift feeds `lem:bierens`, which is in **5a**, from a proof that
lands in **5b**. Pasting first collapses that dependency and discharges binary gate 1 early.

Line numbers verified 2026-08-09, after drift from §3c's citation:

| item | §3c said | actually |
|---|---|---|
| `prp:localise` proof | `results_s2:1399–1636` | **`:1500–1612`**, comment layer |
| `rem:localise` proof | (same range) | **`:1614–1806`**, comment layer |

All ten `\cref`/`\eqref` targets in the two blocks resolve inside `results_s2_identification.tex`,
and the blocks contain **zero** Phase-4-owned tokens (`Omega`, `mathcal O`, `dirclass`, `Xi`,
`Upsilon`, `lambdamu`, `adjoint`), so 5-O1 is independent of the Phase 4 pass and was dispatched
alongside it.

**Queue — RENUMBERED 2026-08-09 after 5-O1, and this is the third drift incident.** The paste
added 308 lines at `proofs.tex:2782`; the `\suppref` repair added 7 more at `:2905`. So: **≤ 2782
unchanged, > 2782 add 308, > 2905 add 315.** The Phase-4 critic independently caught the same
offset on four pointers it had inherited.

> **RULE, adopted after the third incident: locate by CONTENT, never by an inherited line number.**
> §3c's `:1399–1636` was stale before today; the comment layer's `proofs.tex` pointers were stale
> by +308 the moment 5-O1 landed; and the numbers below will go stale the moment 5a edits anything.
> A line number in this plan is a *starting hint for a grep*, not an address. Every dispatch must
> say so, and every agent must report when a number and its content disagree.

| owner | site (current) | was | what is wrong |
|---|---|---|---|
| 5a | `:860` (P1) | `:860` | scalar binary `|W̃| ≤ 1`. Needs per-cell `|W̃_l| ≤ 1` **plus a separate clause** c_W̃ := min{√2, √(L−1)} |
| 5a | `:882–888` (P4b) | same | `j ∈ {0,1}`, `ϱ(1−ϱ){g₁−g₀}`. `rem:pbinaryscope`'s counterexample at `:925–935` is binary-only too |
| 5a | `:2118–2119` | same | "since W is binary…" — the (c)⟹(a) step. **O8 lift replaces it**, from `:2901–2926` |
| 5a | `:2142` | same | `Π = Π_u ⊗ Π_t`, two-factor against `def:spaces`'s three. Also `:4193 :5210 :5241` |
| 5a | `:2168–2173` | same | `cor:opsol` inherits `lem:bierens` wholesale (O7) |
| 5a | `:1339` | — | `lem:pgence` binds Ξ as a generic real r.v. — the **fifth** species (Phase 4 M5) |
| 5b | `:3176` | `:2861` | prints a reference to retired `results.tex` |
| 5b | `:3187`, `:3197–3207` | `:2872`, `:2882–2892` | (P1)-consumers of the form `E|g_Ξ| ≤ ‖Ξ‖` |
| 5c | `:5359 :5361 :5363 :5365 :5447` | `:5044 …` | Ω tokens surviving the 𝒪 rename; `:5365` prints `Ω^{-1}`. **Phase 4 round 2 takes 5359/5365** |
| 5e | `:7821`, **`:7888`** | `:7506`, `:7573` | `:7888` is the literal `‖W̃D‖ ≤ ‖D‖ by (P1)` — **false as printed**; D = [d, −d], W̃ ≈ (1,−1) |

**Group boundaries, re-derived post-paste** (was 8,883 lines, now **9,198**):
5a `1–2520` · 5b `2521–3892` · 5c `3893–5458` · 5d `5459–7642` · 5e `7643–9198`.

### Phase 4 round 2 — and a THIRD orchestrator error, this one caught by the worker

Round 1: **66/100**. Round 2 closed all five findings; build clean at **395 pages**; `eq:embed`
unchanged with all 11 consumers intact; four new labels each defined once and consumed.

**M1 confirmed: round 1 retracted a correct certification.** Separating the two Cauchy–Schwarz
applications gives `c⁽⁰⁾+c⁽¹⁾ ≤ c_μ″/√2`. Verified numerically before propagating. The worker then
went one better with an integration by parts — `S = 2(μ″−1)B`, hence closed forms
`c⁽¹⁾ = c_μ″/√(8(μ″−1))` and `c⁽⁰⁾ = c_μ″√((2μ″−3)/(8(μ″−1)))`, matching quadrature to six decimals
at μ″ ∈ {2,3,5,8}, with `A/B = 2μ″−3` so equality holds **at μ″ = 2 and nowhere else**. Constants
are now computable without quadrature.

> **ORCHESTRATOR ERROR, RECORDED. I told the worker "restoring `+` re-synchronises Step 4
> automatically — do not edit Step 4." That was wrong, and it overrode me with a derivation.**
>
> The per-`l` bound with the *joint* constant delivers `max_l{Λ⁽⁰⁾_l + Λ⁽¹⁾_l}`. The statement needs
> `max_l Λ⁽⁰⁾_l + max_l Λ⁽¹⁾_l`, and `max_l a_l + max_l b_l ≥ max_l{a_l+b_l}` runs the wrong way —
> take a = (1,0), b = (0,1): 2 against 1. **Only the separated constants permit maximising inside
> each budget and then adding.** So Step 4 had to be rewritten, and Step 1's separation would have
> been dead weight without it.
>
> The fine distinction, which is the actual lesson: **round 1's diagnosis of the ROUTE was correct;
> only its inference to the STATEMENT was wrong.** I inherited the inference, saw it refuted, and
> over-corrected into assuming the route was fine too. A refuted conclusion does not refute the
> reasoning that reached it.
>
> **This is the third orchestrator error on this track** — after `lem:adjoint`(i) falling between
> two phases, and the N1′ over-escalation. All three share a shape: *acting on an inherited
> summary instead of on the artifact*. The mitigation already adopted for line numbers (locate by
> content) is the same mitigation. Extend it: **a dispatch may state a conclusion, but must never
> forbid the worker from checking the derivation behind it.** The instruction "do not edit X"
> should have read "X may not need editing — verify, and edit if it does."

### Round-2 score 76/100 → ESCALATED under §2.4 → author ruled → close-out dispatched

Round 2: **76/100**, **zero CRITICAL**. The critic re-derived every changed display and found **no
mathematical error** — Step 4's rewrite valid and non-circular, Step 5's annotation sufficient, M4's
counterexample and L=2 necessity correct, the Ξ count of five right, the 𝒪 rename complete (one
`Ω` left in `proofs.tex`, at `:5414`, and there it is a *mention* of the covariance). What blocked
were **two printed self-contradictions**, ~3 lines each, so the critic recommended escalation over
a third round. Correct call: a third round against finished mathematics buys nothing.

**Both verified by me before escalating**, not taken on report:

- `results_supp.tex:1999` prints *"no coordinatewise sum is ever taken"*; `proofs.tex:4188` opens
  *"Fix a coordinate index and suppress it: every statement below is one of p identical
  statements"*; `results_supp.tex:2116` invokes `‖g‖²_{H(ℝ;ℝᵖ)} = Σ_j‖g_j‖²` outright. Three
  printed sites, two accounts.
- `assumptions_main.tex:341–349` promises a rename *"when its own file is next opened"* while
  `results_supp.tex:2954` prints *"The intertwining family is written 𝒪"* and `:2962` cites that
  very declaration as discharged. The corpus prints both "closed" and "pending".

**AUTHOR RULINGS, 2026-08-09.**

1. **Vectorise Step 1** — *not* the critic's recommended smaller edit. Delete the coordinate
   suppression and run Step 1 at the ℝᵖ arity, which makes `:1999` true as printed. Costs nothing:
   Plancherel is coordinatewise, so the sum sits **inside the definition of the vector Sobolev
   norm**, not in the argument, and both constants stay p-free. **`:2116–2117` must move with it**
   — vectorising relocates the contradiction unless that remark is retyped too.
2. **Reopen `assumptions_main.tex` now** and retract the case-pair paragraph in two sentences.
   Resolves MAJOR-2's ownership gap: the file belonged to no phase, which is the `lem:adjoint`(i)
   failure mode a third time.

The `l`-suppression (contrast index) is **not** in scope and stays with **5c** — the proof carries
*two* suppressions, `j ∈ 1..p` and `l ∈ 1..L−1`, and conflating them is the likeliest way to break it.

### Close-out executed — and the worker overrode the dispatch THREE more times, correctly each time

Build clean at **395 pages**. `eq:embed` untouched at `results_supp.tex:1988`, all 11 consumers
(9 + 2) intact. Step 4's bridging clause verbatim at `proofs.tex:4463`, so **5c's `l`-debt survives**.

> **This is the second consecutive dispatch of mine a worker had to override, and the fourth
> orchestrator error on this track.** All four are the same failure: I scoped from an inherited
> summary rather than from the artifact.

1. **The vectorisation could not be confined to Step 1.** The suppression sentence licensed scalar
   notation in Steps 0, 1′, 2, 3 **and** 5 — six sites outside the range I named. A Step-1-only
   edit would have moved the contradiction two paragraphs down, not removed it.
2. **Step 1′ had to go too.** `results_supp.tex:2116` says "**both** routes", and clause (d)'s
   route is Step 1′, not Step 1. Constant still 2, still p-free.
3. **Step 1′ carried a live symbol collision, invisible under the suppression.** It cited Brezis at
   `W^{1,p}` with "`p = 2 < ∞`" — the **Lebesgue exponent** colliding with the corpus's
   `p = dim θ`, inside a proof this ruling was making ℝᵖ-valued. Retyped `W^{1,2}` (INV-7).
   **The suppression had been hiding it**, which is an argument for the ruling the author picked.

**It also corrected my dispatch on A2c.** I claimed A2c is stated on the scalar space; that range
is `eq:usobolev`'s only. A2c's **vector clause pre-existed** at `assumptions_main.tex:1364–1369`,
so the old proof was **misquoting its own hypothesis**, not consuming a scalar one. The one clause
added names the Euclidean norm on **ℂᵖ**, where `(ℱg)(ξ)` actually takes its values.

**Downstream my dispatch failed to name:** `results_supp.tex:2964–2969` cited the deleted case-pair
paragraph as the thing it discharges. Retyped — otherwise Ruling 2 would have relocated *its*
contradiction too, exactly as Ruling 1 nearly did.

**(P4b)'s target form, verified numerically here before 5a consumes it:**
`E[W̃_l g(W) | ΔZ] = ϱ_l{g_l − Σ_j ϱ_j g_j}` — checked against the direct expectation at
L = 2,3,4,5 and every contrast `l`; at L = 2 it reduces to `ϱ₁ϱ₀{g₁ − g₀}` to machine zero. So
**5a's retyping target already exists in print** at `results_supp.tex:500–506`, and closing 5a lets
that printed deferral be deleted.

**Four items declined and routed** (scope-reduction rule honoured — each names its acquirer):
`proofs.tex:3166`, `cor:elldiff`'s proof at scalar arity in **both** p and l, one lemma upstream
with Step 5 consuming its conclusion → **5b**; `results_supp.tex:1958–1961`'s fixed-`l` reading
clause against clause (i)'s quantifier → **5c**; the pervasive "the display earlier rounds printed"
drafting voice → **Phase C or an author ruling**; a stale comment near `assumptions_main.tex:4299`
→ **Phase C**.

### PHASE 4 CLEARS — 81/100, close-out scored 2026-08-09. Phase 5 released.

Zero CRITICAL. Every touched display re-derived: `eq:embedconstid`, the closed forms, both
`eq:fourierL1` lines, Step 1′'s constant (**still 2, still p-free**), the Brezis retype (**collision
real, retype faithful** to Thm 8.2 / Cor. 8.9 / Cor. 8.10), the L=2 identity, `:4501`'s "is"→"at
most". All three worker overrides upheld; my A2c correction upheld. Ruling 2 executed cleanly —
every printed `Ω` in the corpus is now the conditional contrast covariance or a derivative of it.

**The `l`-suppression was correctly left in the displays** — zero printed `(u,t,l)` in
`proofs.tex:4216–4535` — so 5c's debt survives, *except* as M4 records below.

#### The four gating entries, resolved here

**1 & 2 → NEW PHASE 4b.** `assumptions_supp.tex` **is owned by no phase in §3's table** (M6): Phase 1
closed it, the Euclidean-over-θ repair reopened `assumptions_main.tex` only, and Phase C is
comment-layer. M1 is its first casualty and will not be its last. Phase 4b takes printed text in
`assumptions_supp.tex`, plus M2 in Phase 4's own now-closed file:

- **M1** — `assumptions_supp.tex:626–641`. Stale downstream of *this phase's own* `eq:lambdamu`
  amendment. Says "each of the **p(L−1)** integrals in `eq:lambdamu`" where that display carries
  **L−1**, one per contrast, each of the *vector* norm; establishes measurability for the
  **coordinate** norm and asserts it for the **vector** integrand with the ℓ²-aggregation bridge
  unprinted; and `:588` attributes to A2c "one 𝒯_⋆ serving every (j,l)" where A2c quantifies over
  `l`. **Closes trivially from A2c's own printed identity at `assumptions_main.tex:1368–1369`** —
  which is why it is MAJOR and not CRITICAL.
- **M2** — `results_supp.tex:3498`. `rem:l19cost` announces **four** readings and prints **three**
  (`:3503`, `:3509`, `:3524`; `\end{remark}` at `:3536`), and `:3506` calls only (1)–(2) "readings".
  One word. The close-out certified a claim about this remark's *contents* without checking its
  own count.

**3 → 5d.** **M3**, `proofs.tex:6460–6462`, carries the identical false claim the close-out fixed at
`:3412` — that `rem:l19cost` reads C5′(i) at **two** tunings, when the `n^{-1/16}` tuning survives
only in the archaeology comment at `:3519–3522`. In 5d's range; added to its queue.

**4 → 5c, BY EXPLICIT EXTENSION.** **M5**, `results_supp.tex:1958–1961`, was shed to 5c, which is a
`proofs.tex` line-range group with no `results_supp.tex` grant — *"the `lem:adjoint`(i) failure mode
in miniature."* Correctly detected, incorrectly routed. **5c is hereby granted
`results_supp.tex:1958–1978`**, because M5 is the statement half of the same `l`-arity defect whose
proof half is M4, and they must be repaired by one agent:

- **M4 — self-inflicted, and of the gating species.** `proofs.tex:4463–4465` is held verbatim:
  *"Steps 0–3 ran at one fixed contrast … and this is the step at which it must become visible."*
  The paragraph the close-out **added** at `:4425–4432` makes the index visible **two steps
  earlier**. Held-verbatim text was not re-read against new text — override (a)'s own argument
  running in reverse. (Also "Steps 0–3" omits Step 1′, which sits between Steps 1 and 2.)
- **M5** — *"Every clause below is read at a fixed contrast index l"* against clause (i)'s
  quantifier over `l` at `:1976–1978`.

#### One instruction for 5b, and it inverts §3b N5

`proofs.tex:3161–3169` (`cor:elldiff`'s proof, scalar in **both** p and l) is 5b's — **but it is
only a retype.** The *statement* at `results_supp.tex:810–850` is already fully at p×(L−1) arity and
**prints both aggregation steps** (triangle inequality per column, then `Σ_l ϖ_w(l)² ≤ 1`), so
Step 5's citation is sound and Phase 4 ships no ungrounded conclusion. **5b retypes against the
statement; it does not re-derive.** The inverse of §3b N5, and the distinction must travel.

### Phase 4b — DONE 2026-08-09. Both items closed, and both counts confirmed against their targets.

**M1.** `eq:lambdamu` is `max_{1≤l≤L−1} ∫_{𝒯_⋆} ‖ℓ^Π(·,t,l)‖_{H^{μ''}(ℝ;ℝᵖ)} w̄(t) Π_t(dt)` — **one
integral per contrast**, the p coordinates aggregated *inside* by the Euclidean norm. So the printed
`p(L−1)` was wrong; corroborated twice inside A2c itself (`:1373` "L−1 slices", `:1381` "Euclidean
over j and maximal over l"). Fixed at `assumptions_supp.tex:667`. The ℓ²-aggregation bridge is now
printed at `:649–666`. And `:588`'s quantifier now reads "one 𝒯_⋆ serving every **l**", agreeing with
`assumptions_main.tex:1374` and `proofs.tex:4432` — it had been **the lone outlier in the corpus**.
`assumptions_supp.tex` grew 30 lines: **anything below old `:641` in that file has shifted +30.**

**M2.** Three readings, not four — `(0)` `:3503`, `(1)` `:3509`, `(2)` `:3524`. Fixed at `:3498`.
**The provenance was traced rather than assumed**, which is what makes it a diagnosis: an archived
version announced "three ways" over `(1)(2)(3)`; old `(2)` was folded into current `(1)` and
survives verbatim at `:3516`; a new `(0)` was prepended; the count was bumped 3→4 for the prepend
**without debiting the merge**. `:3506`'s "readings (1)–(2)" was correctly left alone — `(0)` is the
item being written, so a forward reference properly excludes it.

**Two items noticed and correctly declined — OWNED HERE:**

- `assumptions_supp.tex:578`, (m.1)'s opening quotes the weaker phrasing as scalar `H^{μ''}(ℝ)`
  where A2c's condition is `H^{μ''}(ℝ;ℝᵖ)` — same species as M1's third defect, one paragraph
  earlier. Now *coherent* (the repair names both arities and the construction does run at coordinate
  slices) but not literally faithful. → **Phase 4b reopen, or Phase C if it stays cosmetic.**
- **`w̄`'s measurability is never printed in this block**, though `eq:lambdamu`'s integrand is the
  norm **times `w̄(t)`**. Closes in four words from B1(ii) (`assumptions_main.tex:960–961`,
  `w̄(t) = e^{c_Φ‖t‖₁}`, continuous hence Borel) — **but printing it creates a new B1(ii) edge in
  the assumption-usage matrix.** Declining on that ground was right. → **Phase 6
  (assumption-auditor)**, which owns the matrix and will surface the edge anyway.

A spot-check of the other enumerable claims in `assumptions_supp.tex` found no further falsified
counts (`:1759` five clauses ✓, `:1763` four-on-three ✓, `:245` three facts ✓, `:350` three concepts
✓) — **a spot-check of the highest-risk claims, explicitly not an exhaustive audit.**

### Phase 5a — executed 2026-08-09, all eight sites closed, build clean at 402 pages

`proofs.tex` 9,316 → **9,603 lines**. **Group boundary moved: 5a now ends at `:2800`** (`lem:adjoint`'s
proof end); **5b starts at `:2802`.**

**The fourth worker override, and the largest.** Scoped to retype two `𝒜_cond h(u,t)` tokens, the
worker refused: those LHSs sit in displays whose RHS is `𝗄(u,t;x)`, so a two-token edit leaves **both
arities inside one proof** — the species Phase 4 was penalised for. And the real finding underneath:

> **`lem:adjoint`'s statement is already fully general-L while its entire proof was binary.**
> Confirmed by me: `eq:Wdef` at `results_supp.tex:712–716` reads `(𝒲ℓ)_l(u,z) := ϖ_w(l)ϖ_u(u)∫ℓ(u,t,l)…`,
> `l = 1..L−1`. **A proof that does not prove its statement** — the same species as (P1).

So it retyped `prp:wellposed`, `prp:frechet`, `prp:compact`, `lem:adjfubini`, `lem:adjoint`
**against the already-printed statements** — 5b's `cor:elldiff` rule, not §3b N5's. It reports every
printed constant surviving unchanged (`‖T‖ ≤ c_Π`; `‖𝒜_φ‖`; `C_𝒜`; `‖𝒜‖_HS`; `eq:adjenv`) because
`Σ_l ϖ_w(l) = 1`, and `‖𝒲‖` because `max_l ϖ_w(l) ≤ 1` — *"the argument clause (ii) prints but the
proof did not contain."* **Under critic verification; that claim is what the override rests on.**

**My dispatch misnamed a file:** the correct three-argument form is printed at
`results_s2_identification.tex:1063`, not `results_supp.tex:1063`. Fifth pointer error of the day.

**Also taken, each with a reason:** `lem:quantu`'s proof (statement general-L, proof binary; new
Step 3 avoids the case split *and* the division by a prefactor, by right-continuity in `u`);
`eq:degenreg`, ill-typed at L≥3; `:1157`, `:1647`, `:1641`, all printed and all falsified by their
own targets; and a **sixth** two-factor Π claim in `lem:adjfubini` that my enumeration of four missed.

**Blocker it raised against a file it did not own — CLOSED by me.** `assumptions_supp.tex:1065–1067`
printed *"𝒵₀ is defined at `eq:degenreg` **in its binary form** … amending that definition is the
business of the file that carries it."* The amendment falsified both halves. `eq:degenreg` now reads
`𝒵₀ := {z:Ω(z)=0} = {z:max_{0≤l≤L−1}ϱ_l(z)=1}`, agreeing character-for-character with
`assumptions_supp.tex:1063` and `results_s2_identification.tex:281`.

> ### THE `lem:adjoint`(i) FAILURE MODE HAS NOW RECURRED FOUR TIMES. It is systemic, not incidental.
>
> 1. **`lem:adjoint`(i)** — Phase 2b shed it; no acquirer named; it belonged to no phase.
> 2. **`assumptions_supp.tex` printed text** — Phase 1 closed the file, the θ-repair reopened only
>    `assumptions_main.tex`, Phase C is comment-layer. → Phase 4b, created 2026-08-09.
> 3. **M5** — routed to 5c, a `proofs.tex` line-range group with no `results_supp.tex` grant. An
>    acquirer that **cannot** acquire is the same as none.
> 4. **`eq:degenreg`** — `assumptions_supp.tex:1073` and `assumptions_main.tex:4384` both assign it
>    to **Phase 3, which closed without it.**
>
> Every one was caught by accident, by a worker looking at something else. The scope-reduction rule
> (§3) is necessary but has proved insufficient, because it governs *sheds* and three of these four
> were never shed — they were assigned to a phase that then closed, or to one that structurally
> could not take them. **Strengthened rule: at every phase CLOSE, enumerate the items that named
> that phase as acquirer and confirm each was actually done. A phase may not close on an unaudited
> inbound list.** Retrofit this to Phases 1–4 before Phase 8's verification.

### 5a round 1 scored 78/100 — mathematics FINISHED, cross-references not

Zero CRITICAL. **No invalid step anywhere in `proofs.tex` 1–2807.** The load-bearing claim of the
override — "every printed constant survives unchanged" — **verified 8 of 8** by independent
re-derivation: `‖T‖ ≤ c_Π`, `‖𝒜_φ‖`, `C_𝒜`, the Lipschitz constant, `‖𝒜‖_HS`, `eq:adjenv`, `‖𝒲‖`,
`c_W̃`. **No constant silently changed.** `‖𝒲‖`'s step — printed in clause (ii) but absent from the
proof — is now proved. `prp:frechet` was confirmed an explicit Phase-5 debt at
`results_s2_identification.tex:404–410` that my eight sites omitted.

**The `:2800` boundary was not an override.** §3e defines 5a by **content** (`lem:pbounds →
lem:adjoint`); the line numbers are hints, by this plan's own rule. The worker read it correctly.

**What blocks: four printed cross-reference falsifications, two created by the pass, none routed.**
M1 (−8) is the instructive one — round 1 correctly declined to edit `results_supp.tex:500–506`, then
**printed at `proofs.tex:953–955` that the deferral "is discharged here."** So the corpus prints
both the deferral and its discharge. **Rule: a discharge may only be asserted by the edit that
performs it.** M3 (−3) and m2 (−1) are the same shape in the other direction — round 1's own repairs
falsified sentences in a file it could not open.

> **FIFTH INSTANCE of the stranded-item failure mode: `results_supp.tex` was closed by Phase 4 while
> live debts still pointed into it.** Round 2 is granted `results_supp.tex:500–506`, `:509`,
> `:910–911` — named sentences only. No author decision is involved, so this is a grant, not an
> escalation.

**`lem:quantu` now has zero proof-step consumers.** Acceptable — `lem:nusigma`(ii) is printed with
*"Consumers: none, as of 2026-08-05"* and a reason — but it must be given the same note, and
`results_supp.tex:509` (which says A4(i) inverts a prefactor there) must be repaired, because the
rewritten proof prints **"no division by a prefactor."**

### 5a CLEARS — 94/100 after the round-2 close-out. Zero CRITICAL, zero MAJOR.

Build clean at **404 pages**, all environments balanced corpus-wide, binary gate 1 at 56/56. Five of
seven items **fully closed**; three MINOR residues (−2 each), **none a falsification** — each is a
routing or placement debt round 2 disclosed against itself.

**Verified at the artifact, not on report:** the σ-field distinction (M1) re-derived on both sides;
the L=2 reduction algebra; `c_W̃`'s simplex-diameter derivation; (P1b) inheriting **no** hypothesis
from `cor:rangegap` — checked twice, since `lem:adjoint` does not list A1b(iv) and Step 3's actual
citation is a plain Cauchy–Schwarz. **No live text lost** to the line-swallowing incident: every
resumption after a round-2 comment block is a complete construct, and the deleted `\end{remark}` is
restored in the right place. **Zero scope leakage** — round-2 markers exist in exactly two files.

**Two more of my pointers were wrong** (seventh and eighth of the day): `lem:nusigma`(ii)'s
consumer-status convention is at `results_supp.tex:645–650`, not `:611–620` (that range is comment
layer); `cor:rangegap`'s hypothesis line is `:914`, not `:880` (which is `cor:elldiff`'s
Specialisation). Round 2 had quoted its source correctly and owed no enumeration.

> ### SIXTH STRANDED ITEM: `notation_glossary.md` is owned by no phase.
> It carries the **stale binary `𝒵₀`** at **five** sites — `:178 :482 :885 :1048 :1325` — and `:1048`
> additionally glosses `𝒵₀` as "where one W-cell is null", which `proofs.tex:2235–2237` **explicitly
> denies at L≥3**. It is a **required theorist deliverable** under `permissions.md`, yet: Phase C is
> scoped to "the comment layer in all eight files" and this is neither; Phase 6's notation-warden is
> **read-only** and writes a different file. **A critic cannot be an acquirer.** Needs assignment to
> an *editing* phase.

**ADOPTED, on the critic's recommendation: drop line numbers from the queue in favour of content
anchors.** Drift is now **≥ +112 on top of +287**, confirmed empirically at three points, with a
concurrent editor adding more. The M4 retirement marker already does this. Line numbers in this plan
are archaeology; the anchor is the sentence.

### Additional hand-offs from 5a's re-score, not in the corrected queue

1. **`lem:biasexp` Step 5 → 5e, and it is load-bearing.** Anchor: *"and if $D$ satisfies N1′ then
   $E[\mathsf rD]=E[\mathsf r(\Delta Z)E[D\mid\Delta Z]]=0$"*. `r` is `(L−1)×1`, `D` is `p×(L−1)`, so
   `rD` needs `p=1`. §3e's 5e list has Step 2(b) but **not** Step 5. **`proofs.tex:1667–1676` prints
   a deferral naming `lem:biasexp` as acquirer for exactly this — if 5e closes without it, that
   deferral becomes a permanently false forward promise.** The adjacent `E[|𝗋|‖D‖]` applies a scalar
   absolute value to an ℝ^{L−1} vector; same site, same owner.
2. **`E[W̃²|ΔZ] = ϱ(1−ϱ)` → 5e** (anchor, ~`:8121`): scalar square of a vector. Not on §3e's 5e list.
   Its partner, `prp:kerchar` Step 5, is already in 5b's dispatch.
3. **`lem:quantu`'s consumer-status note belongs in the lemma body** (`results_supp.tex:197–218`), on
   `lem:nusigma`(ii)'s model. The grant boundary forced it to `:509`'s clause instead, leaving a
   reader at the lemma with no note. **5c already holds a `results_supp.tex:1958–1978` grant, so it is
   the natural holder** — extend it.
4. **Phase C:** `assumptions_supp.tex:1074` points at "proofs.tex:2173" for `eq:degenreg`, now at
   `:2230–2232` — a stale pointer *inside the discharge note* the next reader will follow.

### Phase 5b executed — and it produced the most important methodological finding of the track

Build clean at **408 pages**, environments balanced. Range grew +213 to `:2920–4503`; `lem:balance`
now opens at `:4505`. Under critic review.

> ## A TOKEN CENSUS CANNOT FIND AN ORDER DEFECT.
> `ν_{W̃c}` and `ν_{cW̃}` match the same token. The whole census — `widetilde W|varrho|\{0,1\}`, later
> `(u,t)` — was blind to the entire class, and **twelve sites 5b closed were on no list**: all five
> `cor:udep` sites, `eq:Psitau` (**non-conformable as printed**), `lem:secondord`(i)'s two and
> Step 5's four, `eq:sigmaqbound`, `eq:prodbound`, `prp:orthog`(i)'s envelope and `Ψ_L`,
> `prp:orthog`(iii)'s direction, `g_{u,t}`.
>
> **Census built and run 2026-08-10** — grep the statement-side multiplicands (`ℓ`, `ℓ̂`, `L_⋆`, `D`,
> `Ξ`, `∂_u`, `𝗋`, `w(`, `c(`) immediately **right** of `\widetilde W`:
>
> | group | likely order defects |
> |---|---|
> | 5a | 4 — all benign: its own prose *about* order, plus M2's deliberately deferred quotation |
> | **5b** | **0** — closed |
> | 5c | **6** — `:4512 :4530 :4570 :5376 :5981 :6175` |
> | 5d | **10** — `:6335 :6907 :6911 :8243 :8244 :8253 :8266 :8294 :8312 :8323` |
> | 5e | **12** — `:8508 :8515 :8516 :8518 :8529 :8530 :8543 :8546 :8592 :8618 :8707 :9018` |
>
> `:5376`, `:5981`, `:6175`, `:6335`, `:6907`, `:6911`, `:8266`, `:8294`, `:8312`, `:8323`, `:9018`
> **appear on no prior list.** Every 5c–5e dispatch must carry its group's row.
>
> ### …AND ORDER IS ONLY ONE OF FIVE CLASSES. The 5b critic's correction, adopted.
>
> *"The zero is real, and it means no order defects. It does not mean no defects, and 5b's range is
> the proof of that."* Four string censuses plus one that no string can find. **All four run
> 2026-08-10:**
>
> | census | what it catches | 5c | 5d | 5e |
> |---|---|---|---|---|
> | **constant** — `2c̄_π` with a `W̃`-contraction in scope | the whole N2 family | `:4534 :4540 :5183` | 0 | `:8439 :8477 :8552 :8577 :8615` |
> | **order** — `W̃` left-multiplying | `ν_{W̃c}` vs `ν_{cW̃}` | 6 | 10 | 12 |
> | **arity** — two-argument where `(u,t,l)` is settled | `𝒜_cond h(u,t)`, `ℳ(u,t)`, `g_{u,t}`, `Ξ(u,t)` | `:5767 :5773` | **13** | 0 |
> | **scalar-op-on-vector** — `\|W̃\| ≤ 1`, `E[\|𝗋\|‖D‖]` | tokens *and* order both correct | 0 | **11** | `:8561 :8578 :8613 :8622` |
> | **self-falsifying arithmetic** | *nothing string-based finds it* | — | — | — |
>
> **Constant is the highest yield per line** — it is the only census that would have caught N2, and
> it surfaced all three of 5c's in one pass. **5d is far heavier than its order row suggested: 13
> arity + 11 scalar-op + 10 order.** The fifth class is why **a re-derivation pass must stay in every
> dispatch** and censuses must never substitute for one.

### 5b CLEARS — 84/100, zero CRITICAL. 5c dispatched.

**5b's dominant claim verified statement-by-statement:** all twelve printed statements were already
general-L, so §3b N5 applies nowhere in the group and no `results_supp.tex` grant was needed.
`prp:localise`/`rem:localise` **independently re-derived** — the critic redid Step 1's π–λ extension,
Step 2's both directions, clause (7)'s `γ/27` coefficient and `c̄_π = 1+γ/6` — and found 5-O1's
relocated paste defect-free. Downstream inherits nothing.

**MAJOR-1 (−7) — a printed equality its own construction falsifies, inside a range two passes had
cleared.** `proofs.tex:4243` prints `‖D‖_{0,h} = 1`; with the witness as printed the `Δh=0` branch
contributes nothing and the `Δh=−1` branch has probability 1 at `τ₁=1`, so `E‖·‖² = ½` and the true
value is **2^{−1/2}**. I verified numerically: **0.500054 at τ₁ = 1.000 → 0.707145.** The
counterexample still *functions* (`½ ≤ C·0` is false for every `C`), and nothing consumes the number
— but the equality is false in print, and **5b re-certified it as unchanged.** One character.
**Granted to 5c**, since 5b is closed and no live phase named it — otherwise the seventh stranded item.

**MAJOR-2 (−4) — the routed `2c̄_π^{1/2}` falsification is at TWO lines and the routing named one.**
`:4534` is `lem:balance` Step 2 (restates clause (i)); **`:4540` is Step 3**, feeding clause (ii)'s
`O_P(ε_n)O_P(δ_n) = o_P(n^{−1/2})` chain. Both false against `results_supp.tex:1793`, which already
printed `2c_W̃c̄_π^{1/2}` before 5b ran.

**Confirmed sound and not to be re-litigated:** `prp:orthog`(iii)'s rebuild (simplex admissibility
from A4(i) on **both** sides, `ϱ_l ≥ ε_ϱ` and `ϱ_0 ≥ ε_ϱ`); `prp:kerchar` Step 5's mixture retype and
its (P4c) attribution distinction — the identity `E[Λ|C] = Σϱ_jE[Λ|C,W=j]` lives inside (P4c)'s
*proof*, not its statement, so deriving it in place was right; `ϱ(1−ϱ) ≥ ε_ϱ(1−ε_ϱ)` surviving **only**
in the L=2 reduction, where the concave minimum sits at both endpoints; `eq:crossshift` and
`eq:rprodbound` correctly keeping **no** `c_W̃`, since the contraction is against `𝗋`.

**No printed `results.tex` reference survives anywhere in `proofs.tex`** — every remaining occurrence
is comment-layer.

**Phase 6 (assumption-auditor), not 5c–5e:** `cor:udep` lists A1b(i) in its hypothesis line and no
step of its proof cites it. And `results_main.tex` is banner-marked SUPERSEDED and referenced by no
`.qmd` — **not** a stranded item, no action.

**N2 was three sites, not one**, and only the first was on my list: `cor:rangegap` Step 1;
`eq:sigmaqbound` (`lem:solset`); `eq:prodbound` (`lem:secondord` Step 5). All now carry `c_W̃`; I
verified the first two directly. A fourth of the family ran the **other** way — `eq:crossshift`
**cited (P1) for a display in which `W̃` does not occur at all**, the contraction being `D𝗋`.

**§3b N5 applies NOWHERE in 5b.** Every printed statement in the group was already general-L; only
proofs were stale. So `results_supp.tex` needed **no grant** and 5b requested none. **The
`cor:elldiff` rule — retype against the statement — was correct for all eight proofs.** Assume the
same for 5c–5e until a statement is shown wrong.

**`prp:orthog`(iii) is the sharpest instance yet of the dominant species:** the proof printed *"a
vector-valued `r` is not well typed"* while the statement it proves types `r: ℝᵖ → ℝ^{L−1}`. Rebuilt
with `r = ε_ϱ sign(M_{jl})e_l`, one entry at a time, `p(L−1)` directions, simplex admissibility from
A4(i) on both sides.

**`prp:localise`/`rem:localise` swept and found clean** — 5-O1's relocated paste is defect-free at
general L, which matters because everything downstream inherits it.

**Deleted from printed text: the words "in `\texttt{results.tex}`"** — a typeset reference to a
retired mirror that was shipping in the supplement. That was §3e's "5b `:3176`" row; the description
was right and the number stale by ~+480.

**My dispatch's error rate, measured by the worker:** the eight proof-header numbers, `:3175/:3177`,
`:3610`, `:4248`, the six `𝒜_cond`, and the eight bare-`W̃` hints were **all exact**. The sweep list
was **4-for-8** — `:3801 :3806 :3831` are comment-layer false positives inside the Kato pin block.
Three `results_supp.tex` pointers were stale by +25…+45; **that drift is fully explained** by 5a's
round-2 edits to that file (5,687 → 5,722), not an unlogged insert.

### 5c CLEARS 88/100 · 5d executed · Phase 4c executed · 5e dispatched (last group)

**5c — 88/100, zero CRITICAL.** Both overrides upheld. **Override 2 is a genuine discovery:** `Υ`
takes **one** index and `ℓ̂−ℓ_⋆` carries **two**, so `ν_g/π = Υ(ℓ̂−ℓ_⋆)` was **non-conformable at
every L, including 2** — it survived because a token census matches `Υ` regardless of what follows.
The row-wise rebuild is exact and constant-free (Frobenius = ℓ² of rows is an *identity*). The
`lem:reprsmooth` Step 0 judgment was upheld **on the merits**: the two-factor route is *more general*
than the three-factor one it declined, because it handles zero-mass cells the obvious retype would
have to assume away.

> **MAJOR-1 — the repair installed a fresh instance of the species it was repairing.** 5c correctly
> overrode me to fix a sentence its own edit had falsified — and the replacement then printed that
> earlier rounds got `1` by *"reading `eq:shiftnorm` as the probability rather than its square
> root."* **That mechanism yields ½, not 1**, and the passage refutes it three lines above where it
> computes the probability as ½; nor can a missing square root reach 1, since `√1 = 1`. The only
> mechanism that lands on 1 is a **dropped mixing weight**. Repaired by me 2026-08-10.
> **Second occurrence of the fifth class, and the second time only recomputation found it.**

**5d — the cleanest pass of the track.** All ten content anchors exact, **zero pointer errors**. All
34 census sites closed plus **9 more forced by the mixed-arity rule**. All ten printed statements
already general-L — **thirty-one across four groups, none wrong.** §3e's older 5d row **did not
reproduce at all**; drift fully explained.

Two finds no census reaches: **`eq:convmean`'s constant was short by `‖π‖_∞`** — an `L²(dx)` bound
reaching `L²(π)` is a round trip costing `‖π‖_∞` out and `‖1/π‖_∞` back, and only the return leg was
printed (C1(ii) already on the hypothesis line, so **no new edge**); and `lem:srctransfer`'s proof
printed bare `R` at five lines where its statement says the radius is `R_⋆` and **never** the `H^s`
radius `R`.

> **Third occurrence of the fifth class, self-caught.** 5d's first draft claimed the sure route
> `W̃² ≥ ε_ϱ²` is sharper than the conditional `ε_Ω = ε_ϱ/L` at L=2. **Backwards.** Verified by me:
> `sure < conditional < sharp` at every ε_ϱ in A4(i)'s range, since `ε_ϱ² < ε_ϱ/2` exactly when
> `ε_ϱ < 1/2`, which A4(i)'s `(0,1/L)` forces. **The conditional route is a strict improvement at
> L=2**, and the sharp binary floor `ε_ϱ(1−ε_ϱ)` is larger again.

**Phase 4c — all six closed.** `prp:hatAprop`'s hypothesis line now carries **B1(iv.d)**, without
which `Π_w` may have mass `M` and clause (i)'s constant acquires `M^{1/2}` — the proposition as
stated was **not implied by its listed hypotheses**. `prp:tccfails` correctly left alone (it lists
clause (iv) whole). `def:spaces` now declares the power set **and** `L²(Π;ℝ^q)`, resolving the INV-7
scalar/vector collision; adding to `def:spaces` rather than repointing was chosen because repointing
would falsify `proofs.tex`'s load-bearing claim that the third factor enters **only** there.
It **overrode** item 3 correctly — the same sentence also said B1(i),(ii),(iv.a) enter "alone" at the
concluding step, false for (iv.a), which the same paragraph says enters twice earlier. And it caught
**two false claims of its own** before shipping.

**My ledger was wrong twice more:** the eight B1(iv.d) sites were **+15 stale**, and only **five** lie
inside `prp:hatAprop`'s proof — the other three are in `prp:tccfails`'s.

> ### STRANDED ITEMS NOW AT SEVEN, AND PHASE C IS TOO NARROW TO ABSORB THEM
> 6. `notation_glossary.md` — a required theorist deliverable; five stale `𝒵₀` sites; now also needs
>    an `L²(Π;ℝ^q)` row. **Phase 6's warden is read-only.**
> 7. `lem:scaleinv`(vi)'s **printed statement** carries a two-factor `Π` (`results_supp.tex:3795`).
>    5d retyped only the proof half, phrasing it to *complete* rather than contradict, and correctly
>    refused a closed file.
>
> Plus: `proofs.tex:5280–5282` (the proof-side mirror of 4c's item 3, now repaired only on the
> statement side) and `results_supp.tex:2634`'s "`def:spaces` **of this file**", stale since the split.
>
> **Phase C as written sweeps "the comment layer in all eight files." That is the wrong shape.** Four
> of these seven are **printed**, and one is not in the eight files at all. **Re-scope Phase C to
> printed text + the comment layer + `notation_glossary.md`, or it will strand them again.**

### 5d CLEARS — 84/100. Zero CRITICAL. Mathematically the strongest pass; prose the weakest.

*"Zero invalid steps in 2,326 lines, two genuine non-census finds both correct, every constant and
every number exact, the L=2 reduction clean at all ten, the override upheld on the merits, and the
self-caught error caught in the right direction."* Both non-census finds verified:

- **`eq:convmean` was a FALSE inequality, not a loose one.** The round trip is `lem:nusigma`(i) →
  `‖π‖_∞` outward → (N2.1) Schur → `‖1/π‖_∞` back, giving `K = 4c̄_π(2c_Cc₂)²‖π‖_∞‖1/π‖_∞`. Only the
  return leg was printed. C1(ii) is already on `prp:phirate`'s line — **no new edge** — and no
  consumer reads `K` at its value.
- **`lem:srctransfer`'s bare `R`** — repair complete; two `\mathsf R` survive in that proof and both
  are correct.
- **Sure/conditional direction now right everywhere**: `results_supp.tex:4582` "*the weaker of the
  two*", `proofs.tex:8714` "*weaker rather than sharper*". No compiled site prints the sure route as
  sharper.

**But three more instances of the fifth class — printed, and none reachable by any string census.
Two are in text 5d itself retyped.** Fourth occurrence on the track.

| finding | site | what |
|---|---|---|
| **MAJOR-1 (−6)** | `proofs.tex:7608` vs `:7670`, `results_supp.tex:3751` | **`c₈` carries two values in one lemma** — `2^μ` in (i), `2^{2μ}` in (ii.b). Verified at the artifact. Not a falsification: the consistent reading `c₈ := 2^{2μ}` keeps (i) true since `2^μ ≤ 2^{2μ}`. The **definition line is the wrong one.** Same species as `c₁₄`/`c₁₆` and `R`/`R_⋆` — the latter repaired **by this very pass, in this very lemma** |
| **MAJOR-2 (−5)** | `proofs.tex:7700` | *"Four one-line computations and one cancellation"* — the proof has **six** clauses over ~94 lines, two of them ~29 lines each. And *"the content is the cancellation"* is contradicted by `results_supp.tex:3850`, which says (vi) is **not** covered by (i)–(v). **5d retyped (vi) and did not re-read the head against it** — Phase 4's M4 verbatim |
| MINOR-1 (−2) | `proofs.tex:7764–7765` | the clause written to *complete* the override says "the two factors that move"; **one** moves |
| MINOR-2 (−2) | `proofs.tex:8218–8219` | "`R_⋆` **only** in `c₁₇` and (L4)" — also six sites in (L5)/`eq:linlf`. The substantive claim (the radii never co-occur) is **true**; the word "only" fails |
| MINOR-3 (−1) | `results_supp.tex:3588` | "the reference configuration" names nothing, and `1.75` belongs to the **retired** `n^{−1/16}` tuning; amended C5′(i) gives `s > 27/16` |

**Framing correction:** "all ten statements already general-L" is strictly **nine** L-free-or-general
plus `lem:scaleinv`(vi), which is *true verbatim at every L under stale notation*. The substantive
answer stands: **no result was silently changed.**

### PHASE 7 REQUIREMENTS PRODUCED BY THE THEORY — carry these into the engine

Not preferences. Each follows from a clause Phase 5 verified.

1. **`Π` must be normalised to a probability measure.** `eq:normconst`'s `ω_n` is **linear in `c_Π`**,
   so `eq:cap`'s `m̄_n ≥ ω_n²δ̂_n^{−2}` is **proportional to `c_*`**. `lem:scaleinv`(vi) records a
   Monte Carlo that reported cap inflation **≈2.9× too large for exactly this reason.** This is an
   engine bug the theory predicts, not a theory question.
2. **`h_u` must take `α` as an input.** Amended C5′(i) is `h_u ≍ sd(ΔU)·δ̂_n^{1/p_K} = n^{−α/8}` at
   `p_K = 8`. The **retired** `n^{−1/16}` was α-free; this one is not. The engine must be handed `r`
   and `d_Z` — A4(ii)–(iii) already require both, so no new primitive.
3. **The simulation runs the frontier-clearing configuration** `(μ,s,a,α) = (2,3,¾,0.32)`, `r = 8/3`
   at `d_Z = 3`. `rem:h6bandwidth`(5) says **in terms** that the boundary configuration `(1,3,4.5)`
   *"is not an admissible design"* and fails (P-f) by `(ln n)^{1/3}`.
4. **`c₁₄ ≥ c₁₆` stays unverifiable** (§4 item 8): `c₁₆` is analytic and unknown to the analyst,
   `c₁₄` is chosen. Report realised `c₁₄` and stopping index; **do not claim verification.**
5. `τ_DP = 2.1 > 2` unchanged, (P-e) satisfied.

## PHASE 5 — ALL FIVE GROUPS CLEAR. L-arity mandate DISCHARGED; the phase is NOT closed.

| group | score | range |
|---|---|---|
| 5-O1 | (gate) | the `localise` paste; binary gate 1 cleared |
| **5a** | **94** | `lem:pbounds` → `lem:adjoint` |
| **5b** | **84** | `prp:nophifree` → `prp:orthog` |
| **5c** | **88** | `lem:balance` → `prp:norangeinv` |
| **5d** | **84** | `lem:opnoise` → `lem:momzero` |
| **5e** | **82** | `lem:prelimtheta` → `prp:medianpart` |

**Zero CRITICAL in any group. 38 of 38 printed statements were already general-L, and no result was
silently changed at any point.** Every group was a retype of stale proofs; §3b N5's "derive, do not
adopt" applied **nowhere** in Phase 5. Build clean at **421 pages**, binary gate 1 at **56/56**.

**5e — 82/100.** `thm:rootn` verified sound: `∂_θψ̄_n = −Ĵ(θ)` identically, the Hessian envelope and
Taylor remainder `c_W̃` insertions correct, necessary and complete, Step 4(c)'s `1/(8μ)` margin exact
with the infimum attained at `α = 1/(4κ)`. `eq:estcontrnorm` was **genuinely forced**, not convenient:
`def:crossfit`(a) says *in terms* that its per-cell bound is **not** a bound on `‖Ŵ̃^{(-k)}_i‖`, and
three proofs need exactly that object. The A4(i) regrounding is a **strict weakening** — `eq:trunset`
sits inside the simplex at every `ε_ϱ > 0`, so the diameter argument runs with `ε_ϱ = 0`.

> ### PHASE 5 MAY NOT CLOSE: two printed defects survive inside its own results.
>
> **F1 — `prp:medianpart`, and it is the fifth class again.** `results_supp.tex:4861–4862` prints
> *"a third place `P` fixed is doing work, **beyond the two the proof names**"* — but `proofs.tex:9574`
> names **three**, the first being the hypothesis, and the statement's own later paragraph
> (`:4878–4881`) lists three. **Three printed sites, two accounts.** Fourth occurrence of the class,
> second found by a critic rather than the worker.
>
> **F2 — `eq:biasb1`'s scalar modulus is LOAD-BEARING, not cosmetic.** `|⟨ν_g/π,h⟩|` applies a scalar
> modulus to an ℝᵖ vector — and `thm:rootn` Step 4 reads *"`‖E[ψ̂|σ]‖` is at most the sum of the four
> right-hand sides of `eq:biasb1`–`eq:biasb4`"*, a triangle inequality that **needs** `‖·‖`. **As
> printed, `eq:biasb1` does not supply it at `p ≥ 2`** — a gap at one link of the headline theorem's
> bias chain. It also contradicts `eq:biasdecomp` two displays away, which types the summand ℝᵖ-valued.
> **p-arity, not L-arity** — it predates the multinomial work, which is why no Phase-5 group owned it,
> and 5e declined it correctly under INV-7. **→ Phase 5f, dispatched: statement and proof in one pass.**

**RULE ADOPTED, on the fourth occurrence:** *every claim of the form "the proof names N" or "X enters
at K points" must be re-counted against the artifact in the same pass that touches either.*

### Routing ledger — every item names an EDITING acquirer

**→ Phase 5f (dispatched):** F2's four sites (`results_supp.tex:1808`, `:4712`; `proofs.tex:8987`,
`:9415`); the non-minimal `eq:estcontrnorm` tag at `proofs.tex:9205`, whose own next sentence says
that brace carries no `c_W̃`; and `thm:rootn` Step 4(c)'s unprinted `r_n ≤ δ̂_n = n^{−α}` substitution.

**→ Phase C, RE-SCOPED to printed text + comment layer + `notation_glossary.md`:** F1 (blocking);
`def:crossfit`(a)'s *"which no statement in this file uses"*, now misdirecting three proofs that need
exactly that norm; `eq:supnormconv`'s consumer list, short by ≥5; `lem:epterm`'s A5(ii)-first-half
wording; the missing L=2 annotation at `lem:sandwich` Step 9; **`notation_glossary.md`** (5 stale
`𝒵₀` sites + an `L²(Π;ℝ^q)` row); `lem:scaleinv`(vi)'s two-factor `Π`; and the carried 5c/5d/4b/4c items.

**→ Phase 6 (read-only, surfacing only — repairs return to C):** three parenthetical edges in
`lem:biasexp`'s proof are **mentions, not steps** and must be marked as such; `lem:epterm`'s A4(i)
edge is **removed** and its matrix row must be rebuilt; **`eq:estcontrnorm` is a new node** — a
labelled display inside one proof with consumers in three others, importing **no** hypothesis of its
host, so the matrix must not draw `lem:sandwich → lem:biasexp`'s list.

**→ Phase 7, and this one changes reported numbers:**

> **At §6's four-cell instrument `L = 4`, so `√(L−1) = √3 > √2` and `c_W̃ = √2`, not 1.** Every
> constant the engine surfaces from `eq:biasb1`, `eq:biasb2`, `lem:sandwich` Steps 2/5/9 and
> `thm:rootn` Step 1 carries **√2**. **The engine must not report binary-case constants on the
> multinomial instrument.**

Also: report **both branches** of A5(i)'s `δ̂_n = max{n^{−1/2}√(ln n), r_n}`; report realised
`min_l ϱ̂_l` against `1/L` (0.0115 vs 0.25 ⟹ `eq:trunset` non-empty ⟹ `def:crossfit`(a)'s truncation
well posed).

### The 5b–5e queue, CORRECTED by the 5a critic — supersedes §3e's earlier table

**Two routing errors in my queue, both toward 5c:** `:4103–4111` and `:4128–4138` sit inside
`prp:orthog`'s proof, and 5b is `prp:nophifree → prp:orthog` under the content rule. **They are 5b's.**

**5b — `prp:nophifree → prp:orthog`, `:2808–4179`. THE HEAVIEST GROUP.**
- **Highest priority, and it is §3b N2's original site now precisely located:** `:3473–3495`
  (`cor:rangegap`) derives `‖Υ‖ ≤ 2c̄_π^{1/2}` from `E‖g_Ξ‖ ≤ ‖Ξ‖` **by (P1)** — contradicting the
  printed `‖Υ‖ ≤ 2c_W̃ c̄_π^{1/2}` at `results_supp.tex:888`. **This is the proof of the very
  corollary (P1b) now cites for c_W̃.** It needs (P1b), not (P1). Also `g_Ξ := W̃Ξ` order.
- `:3063` — prints (P4c) at L=2, the binary `ϱ(1−ϱ){E[Δh|·,W=1] − E[Δh|·,W=0]}`.
- `prp:kerchar` `:2987–3068`: six two-argument `𝒜_cond h(u,t)`; bare `W̃` at eight sites.
- `:2941`, `:2949` (`|W̃| ≤ 1` at the vector), `:2957–2958`, `:2979–2981`.
- `cor:elldiff` `:3406–3467` — **retype against `results_supp.tex:810–850`, do not re-derive.**
- `:3498` (`ν_{W̃(𝒲ℓ)}` vs `:801`'s `ν_{W̃′(𝒲ℓ)}`, wrong before this pass); `:3603 :3801 :3806
  :3831 :3919 :3947 :3989 :4022`; `:4103–4111`; `:4128–4138` incl. **`:4136`'s `{ϱ(1−ϱ)=0}`**.

**5c — `lem:balance → prp:norangeinv`:** `:4186`, `:4203`, `:4517` (two-factor Π), `:5091`
(`Ξ(u,t)`), the `l`-suppression debt (Phase 4 M4/M5) with the granted `results_supp.tex:1958–1978`,
Ω→𝒪 survivors, `:5613`, `:5644`.

**5d — `lem:opnoise → lem:momzero`:** Phase 4's M3; `:5850 :5869 :5896 :5910–5914` (two-argument
`ℳ(u,t)`); `:6580 :6589 :6598 :6689 :6695 :6771 :6863`.

**5e — `lem:prelimtheta → prp:medianpart`:** `:7896`, `:7964`, `:8211`, `:8215`, `:8222`;
**`:8293`** — the literal `‖W̃D‖ ≤ ‖D‖ by (P1)`, false as printed, needs `c_W̃` per §3e's derivation;
`:8361 :8385 :8405 :8436 :8464 :8526`; `:8183 :8191 :8193`, **and `proofs.tex:1624–1625` (M2) must
travel with them.**

### Pointer corrections the round-2 critic made to THIS PLAN

Three of my own pointers were wrong, which is the same disease as §3c's and the +308:

| plan said | actually |
|---|---|
| covariance Ω at `results_supp.tex:4324–4327` | **`:4448–4450`**; `:4324` is `lem:momzero`'s hypothesis line and carries no Ω |
| 𝒪 tokens at `proofs.tex:5408 5410 5412 5414 5496` | **`:5412 5416 5418 5420 5502`** (+4/+6) |
| §3b N4: "do not retype `results_supp.tex:2121`" | **that line contains no Ξ and never did in the split file** — a dead pointer, guarding nothing |

**New 5a site the census missed:** `proofs.tex:2283` writes `E[W̃ Ξ(ΔU,ΔZ)|ΔZ]` with the contrast
on the **left** — non-conformable at L≥3 against `lem:nusigma`(v)'s printed `ΞW̃`
(`results_supp.tex:627–633`). Also `:5091` binds `Ξ ∈ L²(Π)` as `Ξ(u,t)` against the declared
`(u,t,l)` → **5c**; `:5502` writes "acting on the (u,t) side" → **5d/5e**.

### Two items the Ω→𝒪 rename orphaned in `assumptions_main.tex` — OWNED HERE so they cannot fall through

The scope-reduction rule (§3's `lem:adjoint`(i) note) requires an acquiring phase to be named
*before* the dispatch that sheds the item. Round 2 correctly declined both — `assumptions_main.tex`
is not its file — so they are assigned here, pending the round-2 critic's ownership ruling (item G).

**(i) `assumptions_main.tex:341–349` is PRINTED, and it is now false, not merely stale.** It states
*"The symbol Ω **also** names the intertwining family of Proposition norangeinv"* and gives the
reader a disambiguation rule to apply *"until"* a rename *"when its own file is next opened."*
**That file has been opened and the rename is done** — `results_supp.tex` in round 1, the last five
`proofs.tex` tokens in round 2. So the shipped document instructs the reader to disambiguate a
collision that no longer exists, and asserts Ω names an object it no longer names. **This is the
project's dominant defect species — a claim about the artifact that the artifact contradicts —
and it is in printed text, so it scores.** One paragraph, no mathematics: delete the case-pair
paragraph, keep `eq:omegadef`'s covariance, and let `𝒪` stand on its own declaration.

**(ii) `assumptions_main.tex:1312` is comment-layer** — *"proofs.tex:4086 already writes the MAX
form … which is what survives."* **False in both halves now:** the pointer is stale by +315 *and*
round 2 rewrote that region, and the MAX form is **not** what survives — `eq:l21budget`'s `+` form
was restored. → **Phase C.**

**The site count is an undercount, and by a lot.** The 271 figure counts lines matching
`widetilde W|varrho|\{0,1\}`. It does **not** catch arity defects: eight `𝒜_cond h(u,t)` two-argument
applications survive in `proofs.tex` (`:1828 :2408` in 5a; `:2710 :2717 :2722 :2766 :2769 :2771`
inside `prp:kerchar`, 5b) against the settled three-argument `(u,t,l)` form — which the relocated
`rem:localise` proof at `:3054` already writes correctly, matching printed
`results_s2_identification.tex:1063`. **The relocated text is ahead of its neighbours, not
inconsistent with them.** Adding the `(u,t)` pattern raises the total from 271 to **394**, with 5a
at 106 and 5b at 130 rather than 70 and 68. Groups are unchanged — but 5b is the heaviest, not
mid-weight, and must not be dispatched as if it were light.

**§3b N5 stands: DERIVE, do not adopt.** Per-cell + Frobenius gives √(L−1)‖D‖_F; Cauchy–Schwarz
via ‖W̃‖₂ gives √2‖D‖_F. Neither returns 1.

### The derivation N5 asks for — done here, 2026-08-09, so 5a/5b/5e do not each redo it

**Claim.** ‖W̃‖₂ ≤ c_W̃ := min{√2, √(L−1)} almost surely, with **no overlap condition**, and the
constant is sharp.

*Proof.* Write ϱ = (ϱ₁,…,ϱ_{L−1})′, ϱ_l ≥ 0, Σ_{l≥1} ϱ_l ≤ 1.

- *W = j ≥ 1.* W̃ = e_j − ϱ, so ‖W̃‖² = (1−ϱ_j)² + Σ_{l≥1, l≠j} ϱ_l². Put s := Σ_{l≥1,l≠j} ϱ_l
  ≤ 1 − ϱ_j. Since the ϱ_l are non-negative, Σ_{l≠j} ϱ_l² ≤ s² ≤ (1−ϱ_j)². Hence
  ‖W̃‖² ≤ 2(1−ϱ_j)² ≤ 2.
- *W = 0.* W̃ = −ϱ and ‖ϱ‖² ≤ (Σϱ_l)² ≤ 1 ≤ 2.

Separately ‖W̃‖₂ ≤ √(L−1)·max_l|W̃_l| ≤ √(L−1) by per-cell (P1). Take the smaller. ∎

*Sharpness.* ϱ_j = δ, ϱ_k = 1−δ−η, W = j gives ‖W̃‖² → 2 as δ, η → 0. Not attained — ϱ_j = 0
would make {W = j} null — so **√2 is a supremum, and the a.s. bound ‖W̃‖ ≤ √2 is sharp.** At L = 2,
√(L−1) = 1 recovers the present scalar bound with **zero change**, as §5 requires.

**Consequence for the three source sites.** Both routes give the *same* sharp constant:
‖DW̃‖₂ ≤ c_W̃‖D‖_op and ‖DW̃‖₂ ≤ c_W̃‖D‖_F. §3b's counterexample D = [d, −d] with W̃ → (1,−1)
saturates **both**: ‖DW̃‖ = 2‖d‖, while ‖D‖_F = ‖D‖_op = √2‖d‖. So the repair is uniform —
insert c_W̃, keep whichever norm the site already uses, and do not switch norms.

**c_W̃ = 1 iff L = 2.** Every constant downstream of these sites therefore acquires a factor that
is exactly 1 in the binary case, which is why §5's "L = 2 reduces with zero exceptions" survives
this repair.

*Checked numerically before being written down, not after* — 400k Dirichlet draws per L over
L ∈ {2,3,4,5,8}, concentration varied to load the vertices. Realised max‖W̃‖: **1.000000** at
L = 2 and **1.414214** at every L ≥ 3, zero violations of c_W̃. The counterexample evaluates to
7.861519 against √2‖D‖_F = √2‖D‖_op = 7.861519 and against the printed bound's ‖D‖_F = 5.558933 —
saturating the repair and violating the printed claim by exactly √2.

---

## 4. Carried into Phase 2 — the eight items

1. **`a` does NOT depend on Π_w.** Under B1(iv.d) all admissible Π_w give equivalent range norms
   on a finite index set, so singular values are comparable with j-independent constants and the
   exponent is identical. Π_w moves the constant, which `max_l ϖ_w(l)^{-1/2}` already prices.
2. **The budget table has not been re-read at L≥3.** The deferral stands; its stated ground was
   wrong. Settle whether the per-cell operators share a decay exponent — if they do, `a` is
   unchanged; if not, `a = min_l a_l` and the exponent weakly *improves*.
3. **Merging cells STRENGTHENS A1b(iii)** and forfeits localisation. Both must be stated wherever
   coarsening is contemplated — including §6, if overlap fails on the n=66 cell.
4. **The owed result is the LOCALISATION proposition**, not "the overidentification result".
5. **`def:hatA` and `prp:compact` disagree on arity** until `results_s2:226–228` is amended.
   Declared, not hidden.
6. **`def:weight:449` (`b: ℝᵖ → ℝᵖ`) already contradicts A2′(iii)** (`ℝ^{p×(L−1)}`).
7. **Five files unswept**; the census is a lower bound.
8. **`𝖼₁₄ ≥ 𝖼₁₆` is unverifiable.** Phase 7 reports realised 𝖼₁₄ and stopping index; it must not
   claim verification.

---

## 5. What Phase 1 settled, and is not reopened

W ∈ {0,…,L−1}; contrast vector W̃_l = 1{W=l} − ϱ_l(ΔZ); Ω = diag(ϱ) − ϱϱ′ as covariance and as
`eq:omegaprefac`'s prefactor; **the operator is NOT normalised** — raw contrast on both sides;
A4(i) per-cell overlap with `eq:omegafloor`; `eq:trunset` the ε-interior **simplex**; 𝒵₀ = {Ω=0};
τ_DP = 2.1 > 2 with the calibration in 𝖼₁₄; the claim is **localisation**, not testability and not
instrument strength. `L = 2` reduces with **zero exceptions** — the binary estimator is unchanged
by the theory work.

---

## 6. The §6 instrument this is for

| l | trigger | n | baseline TSP | mean ΔTSP |
|---|---|---|---|---|
| 0 | attainment | 685 | 58.0 | −7.1 |
| 1 | bad-day only — **transient** | 114 | 73.3 | −13.7 |
| 2 | annual mean only — chronic | 66 | 79.9 | −9.9 |
| 3 | both — chronic | 118 | 97.8 | −21.0 |

The hypothesis the split exists to test: **A1 fails through the chronic channel**, where W is
close to a function of X₁, and not through the transient one. Overlap binds first — 66 counties
against d_Z = 5 — and if it fails, §3 above applies.

---

## Phase 7 — engine. Started 2026-08-10, propensity complete, and the first faithfulness finding.

**Subagent limit reached (200/200); Phases 7–9 proceed by direct tool use.**

### DONE — the propensity, and it is verified rather than asserted

`project_trunset()` and `fit_propensity_multi()` in `scripts/R/lf_panel.R`.

**`eq:trunset` is the ε-interior SIMPLEX, and the code now projects onto it.** Measured at L=3 with a
raw `(0.7, 0.7)`:

| | implied base cell `q₀` | `λ_min(Ω̂)` |
|---|---|---|
| **box** (coordinatewise clamp, the binary idiom read naively) | **−0.400** | **−0.280** — *not PSD* |
| **simplex** (`project_trunset`) | +0.030 | **+0.01455** against the floor `ε/L = 0.01` |

So on the box `eq:omegafloor` is not loose, it is **false**. At L = 2 box and simplex coincide, which is
why the binary code could use the box and be right; they part at the first extra cell.

**L = 2 invariant holds exactly**: `fit_propensity_multi` reproduces `fit_propensity` to **0.000e+00**,
including the `d_Z = 0` share fallback. At L = 4 the multinomial lands in the simplex with
`min_l ϱ̂_l = 0.0300`, `min ϱ̂_0 = 0.0300`, and `λ_min(Ω̂) = 0.00803 ≥ ε/L = 0.00750` — **floor holds**.

### FAITHFULNESS FINDING 1 — the engine normalises an operator the theory defines unnormalised

`eq:Mdef` is `𝓜(u,t,l) := E[W̃_l·1{ΔY_θ − Δφ ≤ u}·w(t′Φ(ΔZ))]` — **no prefactor**. `eq:trunset`'s file
carries **zero** `Ω^{-1}` or `ϱ(1−ϱ)` prefactors on any operator display. The engine divides by
`scal = w̄(1−w̄)`.

**At L = 2 this is invisible, and that is why it survived.** `scal` scales `err` and the plug-in `δ̂_n`
identically, so the discrepancy ratio the stop compares against `τ_DP` is invariant — measured
**0.216932 before and after** rescaling by hand. It cancels.

**At L ≥ 3 the natural per-cell analogue `scal_l = ϱ_l(1−ϱ_l)` does NOT cancel — it reweights the
cells.** At §6's realised shares `(0.700, 0.115, 0.066, 0.119)` the implied relative weights `1/scal_l`
are `(1.03, 1.70, 1.00)`: **cell 2 up-weighted 1.7× against cell 1 by a factor the theory does not
contain.** `Π_w` is what carries the `l`-weights, and `eq:Mdef` has no prefactor.

> **Consequence for the implementation: the faithful L-generalization drops the per-cell scaling.**
> Keep at most an `l`-independent scale — which cancels, as at L = 2 — and let `Π_w` carry the cell
> weights. **Do not port `w̄(1−w̄)` cellwise.** This is precisely the divergence Phase 8's faithfulness
> check exists to find, surfaced while implementing rather than after.

### REMAINING in Phase 7

Vector `wtil` (n × (L−1)) through `operator_residual`; `err` per-`l` with the `Π_w` aggregation; the
adjoint summed over `l` per `eq:Wdef` (diagonal in `l`, masses inside); `τ_DP = 2.1` with `𝖼₁₄`; and the
five theory-produced requirements — **Π normalised to a probability measure** (the cap is proportional
to `c_*`; a Monte Carlo on record reported ≈2.9× inflation for exactly this), **`h_u` taking `α`**,
**`c_W̃ = √2` at §6's `L = 4`, not 1**, both branches of `δ̂_n`, and realised `𝖼₁₄` reported with **no
claim of verification**.

### Phase 7 progress, 2026-08-10 — core generalized, two more faithfulness findings

**Done, each verified by execution rather than asserted:**

| piece | status |
|---|---|
| `project_trunset()` | ε-interior **simplex**. Box at L=3 raw `(0.7,0.7)` gives `q₀ = −0.400`, `λ_min(Ω̂) = −0.280` — **not PSD**; simplex gives `+0.030`, `+0.01455` against floor `0.01` |
| `fit_propensity_multi()` | multinomial; **L=2 identical to 0.000e+00** incl. the `d_Z=0` share fallback. L=4: `min_l ϱ̂_l = 0.0300`, `λ_min(Ω̂) = 0.00803 ≥ ε/L = 0.00750` |
| `operator_residual()` | `n×(L−1)` contrast, `Π_w` aggregation, adjoint contracted over `l` per `eq:Wdef`. **L=2 bit-for-bit**: `‖T̂‖ = 1.5226861664e-02`, ratio `0.216932`, both unchanged. Bierens flattens `(t,l)` to `n × n_t(L−1)`, weights sum 1 |
| `crossfit_once()` | L-aware propensity plumbing; **L=2 end-to-end θ̂ = (0.98903, −0.48381)** against truth `(1.0, −0.5)` |
| `bw_u()` | α-aware bandwidth; legacy path identical to `0.000e+00` |

**FAITHFULNESS FINDING 1 — the operator scale (recorded above), now implemented.** Kept
`l`-independent, where it cancels; the legacy value retained only at L=2.

**FAITHFULNESS FINDING 2 — the engine's `h_u` is the amended rule at the one α the theory excludes.**
Amended C5′(i) is `h_u ≍ sd(ΔU)·δ̂_n^{1/p_K} = n^{−α/8}` at `p_K = 8`. The engine used `n^{−1/16}`, and
**`n^{−1/16} = n^{−α/8}` exactly at `α = 1/2`** — verified to `0.000e+00`. A5(iii) and
`rem:h6bandwidth` put α **strictly** below 1/2, so the engine bandwidth was always **narrower** than
the theory asks by `n^{(1/2−α)/8}`: **16.8% at `n = 983, α = 0.32`** — the §6 configuration — and 11.4%
at `α = 3/8`. `alpha = NULL` reproduces the legacy path bit-for-bit; supplying α opts in.

**REQUIREMENT (a) — VERIFIED ALREADY SATISFIED, no change made.** The theory warns that `eq:cap` is
proportional to `c_*` and records a Monte Carlo reporting **≈2.9× cap inflation**. Measured in the
engine: `Π_u` is the empirical measure (mass 1), **`sum(pi_t) = 1.0000000000` exactly** at every
`n_t ∈ {4,8,16}`, and `Π_w` is normalised by construction in the new code. **`Π` is a probability
measure; the predicted bug is not present.** Recorded rather than "fixed" — an unneeded change here
would have been the defect, not the repair.

**REMAINING in Phase 7:** the θ balancing solve at L≥3 — `solve_balance_weight()` produces `ell` as
`n×p` and the moment contracts `wtil * lam`; at L categories `ℓ` is `p×(L−1)`-valued, so the solve runs
per `(j,l)` and the contraction becomes `Σ_l ϖ_w(l) W̃_l ℓ_{·l}`. Then `τ_DP = 2.1` with `𝖼₁₄`, and the
diagnostic reporting (both branches of `δ̂_n`; realised `𝖼₁₄` and stopping index with **no claim of
verification**; realised `min_l ϱ̂_l` against `1/L`; `c_W̃ = √2` at L=4, **not 1**).

### Phase 7 — engine core COMPLETE, 2026-08-10. Both cardinalities on one code path.

**θ balancing solve generalized.** A2′(iii) types `ℓ` as `p×(L−1)`-valued, and the system
`(D_W Ω D_W K_u + ρI)α = −D_W Ω DZ_j` has `D_W = diag(W̃)` — **one diagonal per cell** — so the solve
runs over the `p(L−1)` pairs `(j,l)`, not over `p` coordinates. `ell`/`alpha` become `n×p×(L−1)`,
dropped to `n×p` at L=2. `eval_ell`/`eval_lambda` carry the index; `contract_cells()` performs
`eq:psidef`'s `Σ_l ϖ_w(l) W̃_l ℓ_{·l}` — **contrast on the right, the only order that multiplies.**

**End to end, one code path:** L=2 → θ̂ = (+0.99677, −0.38685); L=4 → θ̂ = (+0.98152, −0.52822),
truth (1.0, −0.5). `rho_hat` is a vector at L=2 and `600×3` at L=4.

> **AN EFFICIENCY RESULT, MEASURED NOT ASSERTED.** The balancing is **better at L=4 than at L=2**:
> `rel_bal` (0.00222, 0.00475) against (0.00594, 0.00875) on the same design. The surplus contrasts
> buy balancing power — which is what §1 of the rev-1 plan predicted ("they buy efficiency") and the
> first direct evidence for it.

### FAITHFULNESS FINDING 3 — τ_DP, and it is DECLARED, unlike findings 1 and 2

A7 / `eq:lfsched` stop at `‖·‖ ≤ τ_DP·δ̂_n·ln n` with `τ_DP ≥ 1`, chosen **2.1**. The engine stops at
`‖·‖ ≤ 0.7·δ̂_n` — **no `ln n`**. Measured gap: **18.0× at n=400, 20.7× at n=983, 25.6× at n=5000.**

**But this one is not a silent divergence, and the distinction matters.** A7 is a *ceiling* — stop no
later than — so a tighter stop is inside it. The engine registers `tau_dp` **as an implementation
constant, exactly as `t_scale` is**, with the calibration printed: the `ln n` is a probability-envelope
device, used literally it stops at `m = 1` at these `n`, and the measured cost is φ ISE **0.134 against
0.023** at the oracle stop. **And the theory records the same diagnosis** — its own note computes
`2.1 × 0.018 × 0.216 × ln 983 = 0.0563` and observes it sits *below* the initial discrepancy.

**Engine and theory agree on the fact and differ on the response.** §4 item 8 already governs the
report: state the realised `𝖼₁₄` and stopping index, **claim no verification**.

### REMAINING in Phase 7 → then Phase 8

Diagnostic reporting: both branches of `δ̂_n = max{n^{−1/2}√(ln n), r_n}`; realised `min_l ϱ̂_l` against
`1/L`; `λ_min(Ω̂)` against `ε_ϱ/L`; realised `𝖼₁₄` and stopping index; and `c_W̃ = √2` at §6's `L = 4`
— **the engine must not print binary-case constants on the multinomial instrument.**

---

## PHASE 9 — §6 re-run on the four-category instrument. 2026-08-10.

### The instrument, rebuilt from the two triggers and reproducing the plan's table exactly

`CATT = badday | mean_viol`, so the four cells are the 2×2 of the **two triggers**, not of CATT with
anything. (A first attempt crossed `CATT_A × badday_A` and got an **empty cell 1** — bad-day
violations occur only among nonattainment counties, so that cross is nested, not a 2×2. Recorded
because the empty cell is what exposed it.)

| l | trigger | n | baseline TSP | mean ΔTSP | plan §6 |
|---|---|---|---|---|---|
| 0 | attainment | **685** | 58.0 | −7.12 | 685 / 58.0 / −7.1 ✓ |
| 1 | bad-day only — *transient* | **114** | 73.3 | −13.74 | 114 / 73.3 / −13.7 ✓ |
| 2 | annual mean only — chronic | **66** | 79.9 | −9.90 | 66 / 79.9 / −9.9 ✓ |
| 3 | both — chronic | **118** | 97.8 | −20.96 | 118 / 97.8 / −21.0 ✓ |

**`(W4 > 0)` agrees with the binary CATT on 983 of 983** — the four-category instrument is a strict
refinement, not a different instrument.

### A4(i) on the §6 data — measured through the generalized engine, `d_Z = 5`

```
L = 4, cells 685 / 114 / 66 / 118
A4(i)          min_l rho-hat_l = 0.0115   vs 1/L = 0.2500    eq:trunset non-empty: YES
eq:omegafloor  lambda_min(Omega-hat) = 0.01127  vs eps/L = 0.00287   HOLDS
c_Wtilde       = min{sqrt2, sqrt(L-1)} = 1.414214   <- NOT 1
A5(i)          binding branch: r_n
```

Per-cell realised ranges: cell 0 `[0.5613, 0.8101]`, cell 1 `[0.0155, 0.3524]`, cell 2
`[0.0115, 0.2634]`, cell 3 `[0.0454, 0.3765]`. **Exactly one county sits at the floor**, in cell 2 —
the n=66 cell, which §3d predicted would bind first. **No merging needed; localisation not forfeited.**

### The estimate

| instrument | θ̂[ΔTSP] |
|---|---|
| binary (CATT) | **+0.67889** |
| four-category | **+0.67769** |
| difference | **−0.00120** |

> **The refinement does not move the point estimate**, which is what the theory leads one to expect:
> the surplus contrasts are *additional restrictions on the same φ†*, so they buy efficiency and
> localisation, not a different answer. A large shift would have been evidence that something was
> wrong — either the binary estimate or the generalization.

### What remains for §6, and it is not estimation

1. **The localisation diagnostic.** `prp:localise` is the deliverable the four cells exist for: whether
   the L−1 cell-systems agree at a common φ, and which cells conflict. The estimate above does not
   answer it.
2. **The false-negative caveat, which §6 must state.** Consistency of every cell set is **necessary,
   not sufficient**, for A1 — a cell showing no conflict is **not exonerated**, and the false-negative
   rate is unpriced. Printed in `assumptions_supp.tex` by Phase 6a; §6 must carry it, because §6 will
   be attributing a non-rejection.
3. **The stale comment at `paper/qmd/main.qmd` §6** still says the paper has no empirical application.

### THE LOCALISATION RESULT — and it is the hypothesis §6 was built to test

`scripts/application/app_tsp_08_localise.R`, output `quality_reports/sim/localise_four_cell.md`.
n = 983, d_Z = 5, L = 4, ε_ϱ = 0.0115, 400 null draws. Common fit θ̂[ΔTSP] = +0.67769.

| cell | trigger | channel | n | ‖M_l‖ | null median | **p** |
|---|---|---|---|---|---|---|
| 1 | bad-day only | **transient** | 114 | 6.353e−03 | 2.904e−03 | **0.0623** |
| 2 | annual-mean only | **chronic** | 66 | 8.118e−03 | 2.511e−03 | **0.0050** |
| 3 | both | **chronic** | 118 | 1.355e−02 | 3.052e−03 | **0.0025** |

The reference redraws `W` from the fitted `ϱ̂(ΔZ)`, which **imposes A1 by construction while
preserving the propensity** — the null the test is about, not a permutation that would also destroy
the conditioning.

> **§6's hypothesis, as the plan stated it before any of this was run:** *"A1 fails through the
> **chronic** channel, where W is close to a function of X₁, and not through the transient one."*
>
> **The two chronic cells reject; the transient cell does not, at 5%.** And the ordering is monotone
> in how chronic the cell is — `p = 0.0623 > 0.0050 > 0.0025`, with ‖M_l‖ at 2.2×, 3.2× and **4.4×**
> the null median. The "both" cell, the most chronic, carries the largest violation.
>
> **This is what the binary instrument could not say.** At L = 2 there is one contrast and one
> p-value: A1 is rejected, full stop. The four cells turn a verdict into an attribution.

**Three things this does NOT establish, and §6 must say all three.**

1. **Cell 1 is not exonerated.** Consistency is **necessary, not sufficient** — `prp:localise`(iii)
   detects `𝒱_CI = ∅` and nothing more, so a violation reconciled by some other `φ ∈ 𝒱` is invisible
   here. **The false-negative rate of the attribution is unpriced.** And p = 0.0623 is marginal on its
   own terms.
2. **The base cell carries no contrast.** l = 0 (attainment, n = 685) is recovered as `1 − Σ_l ϱ_l`
   and is what the three contrasts are measured *against*; it is not separately testable.
3. **No multiplicity adjustment is applied.** Three cells are tested at once. Cells 2 and 3 survive a
   Bonferroni threshold of 0.0167; cell 1 does not approach it either way.

### Phase 9 status

**Estimation, diagnostics and localisation all run on the four-category instrument.** What remains is
authorial, not computational: §6's prose, the three caveats above, and the stale comment at
`paper/qmd/main.qmd` §6 still saying the paper has no empirical application.
