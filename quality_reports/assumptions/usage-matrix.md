# Assumption-usage matrix — `panel-npiv-discrete`, Phase 6 (post L-category generalization)

**Audited:** the eight compiled files only. `results.tex`, `assumptions.tex`, `results_main.tex` not opened.
**Score: 30/100.** Six findings, all verified at the artifact, all one-token or one-clause edits.
**Full report:** task `a0c49f48c6ff70724` transcript. This file carries the findings, the A4(i)
consumer analysis, and the carried-item verdicts.

> **Calibration, from the auditor:** the deduction table is mechanical and five of six findings are
> one-line edits. *"The block's self-policing is unusually good — it maintains its own unused-clause
> register, its own retirement register, and a per-theorem usage audit. What it does not have is a
> mechanism that re-runs those registers when a proof is regrounded, and four of the six findings are
> exactly that failure."*

---

## Reading conventions

| Mark | Meaning |
|---|---|
| **H** | statement-level hypothesis, on the printed "Suppose…" line |
| **H·c** | clause-level — "if in addition", inside one numbered clause |
| **S** | proof-step citation |
| **M** | *mention* — names what prices a quantity, or that a converse is non-vacuous. Conclusion holds without it. **No edge.** |
| **D** | definitional / well-formedness dependence |

---

## THE A4(i) BURDEN ON §6 — the empirical readout, and it is good news

A4(i): `ε_ϱ ∈ (0, 1/L)`, `ϱ_l ≥ ε_ϱ` a.s. for **every** `l ∈ {0,…,L−1}`; consequently
`λ_min(Ω) ≥ ε_ϱ/L`. Realised at the four-cell instrument: **`min_l ϱ̂_l = 0.0115`** against
`1/L = 0.25`. So the **range** half is comfortable and the **floor** half is thin.

**Eleven genuine consumers. Three need only the floor's POSITIVITY; eight need its VALUE.**

| site | clause consumed | value or positivity | on the line? |
|---|---|---|---|
| (P4c) `lem:pbinary` | every `{W=j}` non-null | **positivity** | H ✓, "enters once and only here" |
| `prp:kerchar`(ii), (b)⟺(c) | cells non-null; `ϱ_l > 0` to divide the per-cell prefactor | **positivity** | H·c ✓, Steps 1–4 expressly disclaim |
| `rem:localise`(2) | `ϱ_S ≥ ε_ϱ` **and** `ε_ϱ < 1/L ≤ 1/#S` — the only substantive use of the *range* half | positivity + range | H·c ✓ |
| `prp:orthog`(iii) | `ϱ_l ≥ ε_ϱ` **and** `ϱ_0 ≥ ε_ϱ`, so `ϱ + τ₃𝗋` stays in the simplex | **value** (perturbation radius) | H·c ✓ |
| `lem:momzero` reading (iv.4) | `Ω ⪰ ε_Ω I`, `ε_Ω = ε_ϱ/L` | **value** (0.0029 realised) | off-list **by design** |
| `prp:hatAprop`(v) | `eq:wbounds` lower half | **value** | H·c ✓ |
| `prp:tccfails` | same | **value** | H ✓ |
| `prp:norangeinv`(ii) | same | **value** | H ✓ |
| **`prp:tccrepair`(iii)** | same | **value** | **NO — U-1** |
| `def:hatT` truncation | `eq:trunset` non-empty; projection preserves A4(iii) | range + positivity | D ✓ |
| **`def:crossfit`(a)** | `‖𝗋_k‖_∞ ≤ 1−2ε_ϱ` | **value** | **NO, and consumed nowhere — O-4** |

> ### THE READOUT FOR §6
> **None of the eight value-consumers sits on the θ-step's inferential path.** They are the
> identification bridge (`prp:orthog`(iii)), a variance-lower-bound *reading* (`lem:momzero`(iv.4),
> off-list by design), and the four Part-H negative/repair results.
>
> **So the empirical burden A4(i) places on the application is POSITIVITY at every cell — which
> 0.0115 clears — plus a declared `ε_ϱ` small enough that `prp:orthog`(iii)'s perturbation radius and
> `eq:omegafloor`'s `ε_Ω` are reported at 0.0115 and 0.0029 rather than at nominal values.**
> That is a reportable number, not a threat.

---

## Findings

### U-1 (−15) · `prp:tccrepair`(iii) invokes `eq:wbounds`; A4(i) is not on its inherited line

`results_supp.tex:2964` reads only "Suppose the hypotheses of `prp:hatAprop` hold" — and that line
scopes A4(i) to **clause (v) alone**. But (iii) argues *"`eq:wbounds` rules this out surely"*,
excluding the zero-row degeneracy that would make clause (ii) vacuous, and `eq:wbounds`' lower half
rests on A4(i). **This is the `prp:hatAprop` species exactly: the proposition as stated is not
implied by its listed hypotheses.**

Two sharpeners. **The sibling got the rider and this one did not** — `prp:norangeinv` (`:3132`) reads
"hypotheses of `prp:hatAprop`, **A4(i) so that `eq:wbounds` holds**". And Phase 4c's own propagation
note names *both* as inheritors, so the pair has diverged since.

Ancillary: `def:hatTexp`'s consumer register (`:2570`) points at clause **(ii)**; the appeal is in **(iii)**.

### U-2 (−15) · `lem:epterm` concludes `o_P(1)` from `O_P(r_n)`, and nothing on its list gives `r_n → 0`

Step 5 reads *"`O_P(r_n^{1/2}) = o_P(1)` by A4(iii)"*. A4(iii) states the rate and **nothing about `r`**.
The declarations `r > 0` and `1 ≤ d_Z ≤ p−1` — which is what makes `r/(2r+d_Z) > 0` — are **A4(ii)**,
absent from the list. Without it Step 5 gives `O_P(1)`, `eq:psiL2` fails, and `eq:eptermbound` with it.
`lem:sandwich` inherits wholesale.

Two adjacent sites name the pair (`cor:ratefloor` lists `r_n → 0` separately; `lem:sandwich`(i′) says
"A4(ii)–(iii) supply … whenever `r_n → 0`"); `lem:epterm` names only (iii). A lighter reading — that
citing (iii) imports (ii) as a symbol declaration — is **recorded and not adopted**, because the
corpus everywhere else refuses to let a clause citation carry a neighbour silently.

### O-1 (−10) · `prp:phirate` block-cites A4; no step consumes A4(i)

Its line reads "…A4…" while the comment two lines below announces the block's own policy: *"C1 and
C5′ are cited by clause and not as a block."* Sweeping the whole proof: A4 appears twice, both
A4(ii)–(iii). **A4(i) appears at no step.** Downstream disclaimers are explicit — `lem:unifop` prints
that `eq:wbounds` *"is **not** on this line: that display is two-sided and its lower half rests on
A4(i), which neither appeal reads."*

### O-2 (−10) · `lem:sandwich`(i′) lists A4(i)–(iii), consumes neither (i) nor (ii)

…and thereby **breaks its own "strictly weaker" claim**: the clause advertises a hypothesis set
strictly weaker than the lemma's main list, but the main list carries A4(iii) alone, so (i′)'s list
is not a subset of it. Worse, (i′) *assumes the three consistency statements outright*, so A4(ii) is
not needed either. Sweeping Steps 1–6′: the only A4 citation is A4(iii) at Step 3.

### O-3 (−10) · `rem:rootnhyp`(1) — the theorem's own usage audit — attributes A4(i) to a bound that expressly disclaims it

It prints *"A4(i) — … `‖𝗋_k‖_∞ ≤ c_W̃`, `𝗋_k` being the difference of two points of the simplex by
`eq:trunset` and A4(i)"*. `eq:estcontrnorm`'s derivation says the opposite **in print**: *"No overlap
condition is consumed and **A4(i) is not on this lemma's list**: … `ϱ` **lies in the simplex for
free**."*

**And the norm is wrong too.** `eq:estcontrnorm` gives the **Euclidean** `‖𝗋‖ ≤ c_W̃` (no A4(i));
`def:crossfit`(a) gives the **sup**-norm `‖𝗋_k‖_∞ ≤ 1−2ε_ϱ` (which does need A4(i)). The remark has
**fused the norm of one with the constant of the other and the ground of neither.**

This is not bookkeeping: `rem:rootnhyp` is what a referee or the §6 author reads to learn where A4(i)
binds in the θ-step, and it points at a site that no longer consumes it.

### O-4 (−10) · `def:crossfit`(a) states a bound that silently consumes A4(i) and that nothing consumes

`‖𝗋_k‖_∞ ≤ 1−2ε_ϱ` needs `ϱ_l ∈ [ε_ϱ, 1−ε_ϱ]` — i.e. A4(i) — which `def:crossfit` never names
(without it the constant is `1−ε_ϱ`). **And the display is used nowhere**: `1−2ε_ϱ` occurs at exactly
one site in the corpus, its own. Every downstream sure bound goes through `eq:estcontrnorm` instead,
and `lem:sandwich` Step 3 states *"No sure bound on `𝗋_k` is used."* One line carrying **both** failure
modes — an unstated ground and an unconsumed consequence — and the likely source of O-3's fusion.

---

## Unused, declared, no deduction

The block maintains an accurate unused-clause register. **A1b(ii), A5(v), C1(i) (transitively), C4′,
C5′(ii)/(iii)/(iv), A6b** — all unused, all with a printed status note, all correctly distinguished
from the four **retirements**: A3 and A2′(ii) *proved*; A6 *false* (`prp:tccfails`); B1(vi) *about a
different estimator*.

**A1c (advisory).** Maintained, printed, and a hypothesis of **no** result — the three non-declaration
occurrences are mentions. The remedy exists (`rem:a1cwithdrawn`) but sits in the results file while
every comparable status note sits in the assumption block. One bullet closes it.

---

## Carried-item verdicts

| # | Item | Verdict |
|---|---|---|
| 1 | `lem:epterm`'s A4(i) edge removed | **CONFIRMED**, row rebuilt. The old edge was an over-attribution |
| 2 | Three parentheticals in `lem:biasexp` are mentions | **CONFIRMED**, no edges drawn. The forward direction is proved inline by the tower property, so `prp:orthog`(iii)'s A4(i) is not imported |
| 3 | `eq:estcontrnorm` a new node importing no host hypothesis | **CONFIRMED.** Matrix does **not** draw `lem:sandwich → lem:biasexp`'s list |
| 4 | `lem:momzero → A4(i)` reading-level | **CONFIRMED**, off-list. `eq:omegafloor` is A4(i)'s stated consequence, so citing it acquires nothing |
| 5 | `lem:scaleinv`(vi) checks B1(iv.d) — new edge? | **NO NEW EDGE** — the clause is *conditional*, B1(iv.d) enters as an antecedent |
| 6 | `cor:udep` lists A1b(i), no step cites it | **RESOLVED — statement-level, not unused.** Consumed by clause (a) for **well-posedness**: "first-order insensitive at `φ†`" presupposes `φ† ∈ 𝒱`. Invisible to a proof-step sweep because there is no step to find. **Closed as correct** |
| 7 | `w̄`'s measurability | **Declined again, ground recorded.** Continuous hence Borel — zero mathematical content — and printing it creates a **B1(ii) edge on A2c** propagating to `lem:reprsmooth`. Phase 4b's refusal was right |
| 8 | `p_K ≥ s − ½` on two lines | **NO DOUBLE-COUNT** — inheritance, not duplication |
| 9 | A5(ii)'s split | **BOTH HALVES CONSUMED; the refusal to narrow was correct.** Steps 2–3 read the first half and conclude `o_P(1)`, which needs `δ_n → 0` — supplied on that list **only** by the second half a fortiori |

---

## The structural finding, which matters more than any single edit

> **Four of six findings (U-2, O-1…O-4) are one failure: a proof step was regrounded or a bound
> narrowed, and the hypothesis line, the usage register, or the sibling result was not re-run against
> it.** The corpus has the right instruments — `rem:rootnhyp` is a per-theorem usage audit, the
> Part-VI register a per-clause one — but **nothing re-runs them when `proofs.tex` moves.**
>
> **STANDING RULE ADOPTED: a pass that regrounds a proof step must re-read the usage register that
> names that step before it closes.** That rule, not any of these six edits, is what stops the seventh.

## Repair pass — six items, three files, to move together

1. `results_supp.tex:2964` (U-1) — add A4(i) on `prp:norangeinv`'s exact wording; retype `:2570`'s clause number
2. `results_supp.tex:4824` (U-2) — "A4(iii)" → "A4(ii)–(iii)", **or** add "`r_n → 0`". Either, not both
3. `results_s4_asymptotics.tex:122` (O-1) — narrow the block "A4", or name the consuming step
4. `results_supp.tex:4894` (O-2) — "A4(i)–(iii)" → "A4(iii)", restoring the "strictly weaker" claim
5. `results_supp.tex:5216` (O-3) — retype against `eq:estcontrnorm`'s derivation; get the norm and the ground right. **If A4(i) has no θ-step consumer once retyped, print that — it is the stronger statement and the one §6 needs**
6. `results_s3_estimation.tex:334` (O-4) — cut the unconsumed bound, or name A4(i) at it. **Cutting preferred** — it removes O-3's confusable neighbour in the same stroke

Also: `assumptions_supp.tex:1788` — add A1c to the unused register. `results_supp.tex:2692` — one
clause saying `prp:hatAprop`(i) reads only `eq:wbounds`' free upper half.
