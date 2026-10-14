# Regularity audit — `panel-npiv-discrete`, Phase 6 (post L-category generalization)

**Score: 41/100** — 1 CRITICAL (−20), 3 MAJOR (−30), 3 MINOR (−9). Eight compiled files only.
**Exactly one finding changes what the paper assumes (C-1). The other six are one-printed-sentence repairs.**
Full report: task `a5a832f8f08b898e3`.

## CRITICAL — (P-g) is a factor `h_u` too weak for the step that consumes it

`results_s4_asymptotics.tex:226–227` prints `(P-g): R h_x^{s−1/2} = O(δ̂_n)`.

**The chain, recomputed:** `lem:unifop` Step 4 bounds the displacement in **operator norm** by
`c₂c_Π h_u^{−1}·max_i|Δ_{h_x}φ_i − Δφ_i|` — and that `h_u^{−1}` is real, from `lem:intker`(ii)'s
`‖∂_v C_{h_u}‖_∞ ≤ c₂h_u^{−1}`, the same `h_u^{−1}` that forces the net radius at (3c) and the `h_u`
inside `eq:entropy`. With `eq:xsmoothbias` this gives `c·h_u^{−1}R h_x^{s−1/2}`.

**So the step needs `R h_x^{s−1/2} = O(h_u δ̂_n)`.** Under (P-g) as printed, at `h_x` at the top of its
own admissible window, the displacement is `≍ h_u^{−1}δ̂_n = n^{α/8}δ̂_n ≫ δ̂_n`. (N1) then does **not**
follow from the stated hypothesis, and (N1) feeds `δ^eff`, the rate recursion, `eq:phirate`, and
`thm:rootn` through (T-5).

**The corpus contradicts itself, and the contradicting site got the arithmetic right.**
`results_supp.tex:2867–2874`, on the same displacement: *"Since `h_u^{−1}Θ₁(·/h_u)` is Lipschitz at
scale `h_u`, the resulting relative displacement of the two families is `O(h_u^{−1}δ̂_n)`."*

**And the sibling hypothesis already carries the factor:** (P-c) is `R L_x^{−s} = O(h_u δ̂_n)`, with the
comment *"The factor `h_u` is not decoration."* **(P-g) is the one place it was dropped.**

Same defect, second site, **no consumers**: `lem:aerr`'s proviso prints `R h_x^{s−1/2} = o(1)` where
its proof costs the alignment at `h_u^{−1}R h_x^{s−1/2}`.

**Remedy: NEEDS A HYPOTHESIS CHANGED.** (P-g) → `R h_x^{s−1/2} = O(h_u δ̂_n)`, and the same at
`lem:unifop`'s and `lem:aerr`'s provisos. **Verified consequence:** the non-emptiness threshold moves
from `s > ½ + 8α/(8−α)` to `s > ½ + 9α/(8−α)` — sup over `α < ½` from **31/30 = 1.0333 to 11/10 = 1.1**.
**Both running configurations have `s = 3` and clear it with margins +2.06 and +2.13, so no conclusion
is lost** — but `results_s4_asymptotics.tex`, `results_supp.tex` (two provisos), `assumptions_supp.tex`
(`rem:app5read`(2), `eq:hxwindow`) and the emptiness computation must be recomputed **together**.

## MAJOR

**M-1 · `‖E[M|𝒢]‖ ≤ E[‖M‖|𝒢]` elided at four sites.** `lem:sandwich` Step 3 (braces one and two — Phase
5f made it explicit for the **third** brace only, so within one display the device is named once and
elided twice); `lem:biasexp` Steps 4 and 5 (three sites). By the corpus's own standard this is not
cosmetic: `lem:balance` Step 1 writes the inequality out in a display and carries an archaeology note
recording that the omission was a defect repaired in **statement and proof together**.
*One printed clause each. No hypothesis moves.*

**M-2 · `ξ_i` is Bochner-integrated without strong measurability ever established.** Bochner
integrability = strong measurability + `E‖ξ_i‖ < ∞`; only the second is established. A corpus-wide
sweep returns "Bochner" at two lines and "Pettis" **nowhere**. Load-bearing: `E T̄` is the object every
subsequent Part-H display is written at. **The ingredients are already proved** — separability of
`L²(Π)` at `prp:compact` Step 4, joint measurability in `(ω,u,t,l)` at `prp:wellposed` Step 1 — and with
separability Pettis converts weak to strong. **Conspicuous, not conventional**: every other `L²`-valued
object in the paper carries such a declaration. *One printed sentence.*

**M-3 · `lem:quantu`'s two quantifiers do not meet.** The statement promises "every `u`, every `l`, every
`z` outside a **single** null set not depending on `u`"; Step 2 delivers "a.e. `z`" **per `u`**, and at
uncountably many `u` that is not a null set. What closes it is available and unprinted: Step 1 fixes a
*regular* version "for **every** `z`". Blast radius nil (**Consumers: none**), but printed and cited.
*One sentence; statement and proof must move together.*

## MINOR

**m-1 ·** `lem:momzero` Step 3 cites the mean value **theorem** for an `ℝᵖ`-valued map. The corpus
polices exactly this: `cor:udep` Step 1 states the Lagrange form "is **false** for vector- or
matrix-valued ones". **And it contradicts a printed census** — an archaeology note lists seven sites
closed by adding the word; this is an **eighth** and is not on the list. *One word + one census line,
which must move in the same pass or the corrected census is again false.*

**m-2 ·** `lem:reprsmooth` Step 0 credits σ-finiteness with supplying the product-measurable
representative; under `def:spaces`'s **uncompleted** product σ-field that is immediate and σ-finiteness
is idle at that clause (it is correctly cited at the two real Tonelli uses). **The two-factor route
itself is sound and is more general than the three-fold one**, and "B1(iv.d) does not enter" survives.

**m-3 ·** `lem:aerr`'s statement cites joint measurability in `(ω,u,t)`; at `L≥3` it is `(ω,u,t,l)`. The
source pointed at gets it right. *One printed index.*

## Verified discharged — no finding

Both nested suprema in `eq:aerr`; the countable-dense construction at `lem:unifop`(3c) (**and the
round-4 audit MAJOR a comment calls stale is genuinely stale** — all three named sites now carry it);
joint measurability in `l` at `lem:reprsmooth`(i) (**printed, not merely intended**); `cor:opsol`'s
regular conditional distributions; `lem:quantu` Step 3's right-continuity route (inverts nothing,
divides by no prefactor — **no overlap condition needed**, as claimed); parameter-on-boundary;
`L^p ⇒ a.e.` (the corpus explicitly declines the fallacy); the Sobolev scale.
