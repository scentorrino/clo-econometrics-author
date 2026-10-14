# Counterexample probes — `panel-npiv-discrete`

# GATE STATUS (current, 2026-08-27, post-determination): **NOT BLOCKED. CLEAR, NOT PROVISIONAL.**
**Probe score: 47/100.** No fully specified law refutes a theorem's conclusion under all its stated
hypotheses. The one open determination this report raised (P1) **returned the same day and did not
block** — see the box below; it was additionally repaired at the source, so the question no longer
depends on the adjudication. The 47 reflects three findings worth repairing, **none of which is a
counterexample**; gate 3 reads the verdict on this line, not the score.

> **Note for whoever reads this next.** This header sat at "ONE DETERMINATION FROM BLOCKED /
> treat as PROVISIONAL" for several hours after the determination had returned, because the body
> was updated and the header was not. That is the same defect this corpus keeps finding in itself.
> **If you change a verdict, change the line the gate reads.**

> **THE OPEN DETERMINATION — RETURNED 2026-08-27. GATE 3 IS CLEAR, NOT PROVISIONAL.**
> The question was whether `k̄ = 1` is attainable under `prp:phirate`'s own hypotheses; if it were,
> P1 would be a confirmed counterexample to `eq:phirate` and this gate would block. **It is not.**
> `k̄_a := ⌈log_{2κ}(·)⌉ ∨ 1` and `k̄ := k̄_a + 1`, so the `∨ 1` floors the stage count at
> `k̄ ≥ 2` — and the disjunction binds **precisely in the favourable case the probe proposed**
> (ς₀ ≥ 5α/8 makes the ceiling ≤ 0). So (P-a.3) is always read at k=1 **and** k=2, a non-contracting
> stage 1 empties the hypothesis set, and the proposition is **vacuous rather than false**.
> Verified independently by theorist-critic on 2026-08-27. The conclusion now prints as
> "a finite k̄ ≥ 2" in the **statement**, not only the proof.
>
> **P1 was additionally repaired rather than merely adjudicated:** ω_n now carries
> `max{‖1/π‖_∞^{1/2}, ε_π^{−1/2}}`, covering both pairings, which removes the question independently
> of the k̄ determination. `rem:phirscope`(7) is now five parts. **One framing correction:** the
> construction shows the L²(π) bound does not *imply* the L²(π̂) one; it does **not** exhibit
> divergence, which would need a lower bound on `‖Â_φ‖` that `lem:scaleinv`'s own note records as
> unavailable. Every site now says "not implied", never "false".

Probed: the eight compiled files. Retired mirrors not read as authority.

## 2026-08-27 findings

| # | Finding | Severity | Deduction |
|---|---|---|---|
| **P1** | `def:lfstep`'s `‖ω_n^{-1}Â_φ‖ ≤ 1` **"surely"** is true in L²(π) but the iteration runs through the **L²(π̂)** adjoint, where it is **false at every `ε_π < inf π`** — the whole range `def:lfstep` itself recommends. Witness: π non-constant, `π̂ ≡ ε_π`, admissible because `rem:phirscope`(7d) constrains π̂ "by nothing beyond the floor". Then `‖Â_φ‖_{L²(π̂)} ≥ (inf π/ε_π)^{1/2}‖Â_φ‖_{L²(π)}`, which diverges as `ε_π ↓ 0` at fixed ω_n. Also: `rem:phirscope`(7) declares the gap "in four parts"; **relaxation-admissibility is a fifth, enumerated nowhere.** The right quantity (`ε_π^{-1/2}`) is already printed at `results_s3_supp.tex:93–97` but filed under **computability, not stability**. | HIGH | −30 |
| **P2** | `lem:levels`(iii)'s density step (`proofs.tex:2810–2811`) asserts the range "contains every centred C¹ function on 𝒳" — an interval argument, **false on a fat Cantor 𝒳**, at a lemma whose hypothesis line was stripped of A0's interval on 2026-08-26 and whose statement now asserts "(ii)–(iv) are unchanged". The clause is **still true** (density follows from clause (ii) after a continuity extension), so this is a proof gap, not a counterexample. | MEDIUM | −15 |
| **P3** | `proofs.tex:3603` ("𝒳 **and 𝖫** being fixed") contradicts the A4(i) transfer four lines below it (`:3606`, "at #𝖲 cells"). Witness: 𝖫=3, ϱ≡(⅓,⅓,⅓), 𝖲={0,1} gives ϱ^Q_2 = 0 < ε_ϱ. The intended reading is printed adjacent and is true; one sentence is wrong. Repair: "𝒳 fixed and 𝖫^Q = #𝖲". | LOW | −8 |

**P1 and P2 are both defects introduced by the 2026-08-26 dispatches** — the ε_π positivity
convention and the `lem:levels` retyping respectively. Re-probing after a repair round is what
caught them.

## Cleared this round — attacked and no attack landed

- **`lem:bdryfam`(g)** — attainment attacked as directed, not the constants. 𝔍's compactness
  survives the extended endpoints; the slice `{I : ς* ∈ I}` is closed in a compact set and
  non-empty; both directions of 𝛩̄'s continuity hold; Step 7's domination confines the sup to a
  compact `[−M,M]` with `M` not needing to be explicit. Every consumed constant re-derived
  independently, including the Legendre value `Σ_{j<p_K}(2j+1) = p_K²` and `c_C = √π(1+erf(2^{-3/2}))`
  being genuinely `p_K`-free. The note's warning against pairing the standalone `c_C` bound with
  the upper half of `eq:envbnds` is correct.
- **A4(i)'s 2026-08-26 re-spelling admits exactly the same class of P.** Boundary checked:
  `ε = 1/𝖫` is excluded but the exactly-uniform propensity is admitted at any `ε_ϱ < 1/𝖫`, so no
  law is lost. The re-spelling is a genuine repair — it makes `ε_ϱ` analyst-declared, which
  `def:hatT` constitutively needs and the existential form could not supply.
- **A0's declaration/clause split is drawn correctly at every consumer except `lem:levels`(iii)** (P2).
- **π's non-re-indexing clause is load-bearing and used correctly** — both sides of the
  `rem:localise`(2) transfer divide by the *same* π, which is what makes `𝒱_𝖲 = 𝒱_CI(Q)` a
  statement about subsets of one space.
- **Standing targets all captured by stated clauses**: boundary parameter, degenerate/point-mass X,
  empty W-cells, conditional degeneracy, heavy tails, non-iid, slow first step, weak identification
  / singular Σ, identification at infinity, 𝖫 at both extremes, T=2 exactly, p=1.
- **`eq:crossshift`** (the 2026-08-10 P5) remains closed; the `proofs.tex:4434–4437` witness is
  feasible and the negative claim stands. Not re-litigated.

---

# SUPERSEDED — Phase 6 report, 2026-08-10, 80/100

> **Read the current status above.** The report below scored 80/100 and predates
> `lem:bdryfam`, the citation-register paragraph, `eq:envbnds`, the ε_π convention and the
> A0/A4(i) re-spellings. Its verdict line is **not** the gate's current input.

## Captured by stated assumptions — no action

| probe | verdict |
|---|---|
| **`eq:omegafloor` at A4(i)'s boundary** | A4(i) is an **existential** over `ε_ϱ`; at `ϱ ≡ 1/L` take `ε_ϱ = 1/(2L)`. The strictness excludes **no law** — only the claim `ε_ϱ = 1/L`. Bound re-derived independently: `Ω^{-1} = diag(ϱ)^{-1} + ϱ_0^{-1}11′`, `λ_min(Ω) ≥ ε_ϱ/L`, tight in the limit. One live consumer of strictness: `rem:localise`(2) |
| **Null cell without degeneracy, L=3** (`ϱ = (q,0)′`: `det Ω = 0` yet **outside** `𝒵₀`) | **Every step that needs one of the two sets is given the right one.** `lem:bierens` Step 3 no longer splits at all — it runs through `eq:cellfact` and never divides by `ϱ_l`. `prp:orthog`(ii) explicitly says it is `𝒵₀` and not the null-cell set that is wanted, "because it is `𝒵₀` on which `W̃` vanishes" — correct, since `W̃ ≠ 0` at `(q,0)′` |
| **Is `c_W̃` claimed attained?** | `‖W̃‖ = √2` needs `ϱ_k = 1` and `P(W=l\|ΔZ) = 0` on the same event — a null event, so **never attained at any L**. No step needs attainment; `cor:rangegap` prints "*No sharpness is claimed*" |
| **The `‖DW̃‖` witness under A4(i)** | At `ε_ϱ = 0.1`, `ϱ = (0.15,0.70)`: ratio **1.096 > 1**. A constant of `1` would be **false** on a DGP satisfying A4(i) — the (P1)/(P1b) separation is load-bearing, not pedantic |
| **Weak identification downstream** | Nothing silently needs more than A1b(iii). A1c is **not** vacuously false (captured by A1b(ii)/C1(ii)); A1d is already retired as unsatisfiable by the cardinality-free `Λ ≡ 1` argument; `Σ ≻ 0` rests on A1b(iv) + C2′(i), and the `L≥3` route through `Ω ⪰ ε_Ω I` is correct with the proof stating plainly that the sure `L=2` route has no analogue above it |
| **8 standing probes** | boundary, degenerate/atomic `X`, heavy tails, non-iid, slow first step (**proved sharp** by `prp:sharpquad`), misspecification, and the **L=2 reduction of every L≥3 construction** — all exact, with one *declared* exception (`prp:localise`(iv), vacuous at L=2, printed in the statement) |

## Findings

**P5 (−15) · `eq:crossshift`'s printed witness is INFEASIBLE under C1(ii) — a stated hypothesis of the
lemma it lives in — while the proof asserts "Every hypothesis of (iii) holds".**

C1(ii) puts `f_{X₁,X₂} ≥ c > 0` on `𝒳²`, so `P` is equivalent to Lebesgue. If `Δh ∈ {−1,0}` a.e., Fubini
makes `h` a.e. two-valued on `A = {h=a}`, `B = {h=a−1}`; `P(Δh=−1) = P(X₁∈A, X₂∈B) = ½ > 0` forces
`|A|,|B| > 0`, whence `P(X₁∈B, X₂∈A) ≥ c|A||B| > 0` — where `Δh = +1 ∉ {−1,0}`. **Contradiction.**

> **Orchestrator's verification sharpens this: the witness fails twice over.** `P(Δh=−1) = ½` requires
> `|A||B| ≥ ½` at `c=1`, but `max|A||B| = ¼`. It is **infeasible on the probability alone**, before the
> sign argument.

**Secondary:** the witness also sets `ΔZ` degenerate, which at `p ≥ 2` contradicts **A1b(iv)**.

**What survives:** the *statement* `lem:secondord`(iii) is an upper bound and **remains true**. The
*negative claim* it supports — "not a product bound", which drives (R-c)'s branch structure in
`thm:rootn` — is **not established by the witness as printed**. It is **not itself false**: drop the
"`Δh = 0` elsewhere" requirement and take `h = 1{x>½} − ½` with `Δh ∈ {−1,0,1}`, `ΔZ` non-degenerate.
*Orchestrator verified: `P(Δh=−1) = 0.2499`, which is all the negative claim needs.*

**A4(ii)'s upper bound `d_Z ≤ p−1` (−5) · an undiscussed scope restriction that is a consequence of two
assumptions rather than a printed one.** It forces at least one degenerate coordinate; **read with
A1b(iv)** (nonsingular `E[ΔZΔZ′]`) a degenerate coordinate must be a **non-zero constant**, and two such
make two rows proportional — so **`d_Z = p−1` exactly and `ΔZ` must contain exactly one non-zero
constant coordinate**, i.e. *the differenced equation must carry a period effect*. The asymmetry is
striking: the **lower** bound `d_Z ≥ 1` gets a full printed paragraph; the upper bound appears at one
line and is discussed nowhere.

## Recommended remark — no deduction, and §6 needs it

**The false-negative direction of `prp:localise` is printed NOWHERE.** A DGP was constructed where **A1
fails at the truth and the cell system shows no conflict**: `L=3`, `ϱ_l ≡ 1/3`, `φ_† := φ₁ + g` with
`∫gδ₁ = 0` but `ℒ(Δg|W=1) ≠ ℒ(Δg|W=0)` separating third moments. A1 fails; `φ₁ ∈ 𝒱_CI`, so **every `S` is
consistent, every conflict set is empty, the diagnostic reports nothing**, and the estimator converges
to `φ₁ ≠ φ_†`.

**This is not a counterexample** — `prp:localise`(ii) states only `A1 ⟹ every S consistent` and its
contrapositive; the converse is never asserted, and all hypotheses and conclusions hold. **But a search
for any printed statement that consistency is *necessary and not sufficient* returns zero hits.**
`rem:localise`(5)'s "What is **not** claimed" blocks two *other* over-readings and not this one.

> **A cell showing no conflict is not exonerated. The procedure detects `𝒱_CI = ∅` and nothing more, so
> a violation reconciled by some other `φ ∈ 𝒱` is invisible to it, and the false-negative rate of the
> attribution is unpriced.** §6 must say this.

## Independently re-verified

`eq:adjclosed`'s R1 repair (`𝒜*Ξ = ν_{W̃′(𝒲Ξ)}/π`, `ϖ_w(l)` absorbed into `𝒲`); every printed number in
`rem:localise`(7)'s worked example (`E[X₂−X₁|W=1] = γ/6`; `γ/27 = ⅓ × ⅔ × γ/6`; `Σϱ_lμ_l = 0` at both the
L=3 and L=4 variants; `c̄_π = 1+γ/6`); and `rem:localise`(6)'s deconvolution refutation.
