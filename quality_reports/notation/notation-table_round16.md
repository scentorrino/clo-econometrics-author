# Notation Sweep — `panel-npiv-discrete`, round 6 (post-dispatch-18/19/20)

**Date:** 2026-08-01
**Score: 0/100** (floored; raw −201). **Was 0** (raw −123). Blocks the notation-consistency component.

> Orchestrator transcription; the notation-warden is read-only. **[VERIFIED]** marks checks the
> orchestrator re-ran. Counts written "N lines" are lines-with-match; "N occurrences" were
> counted from content output — **the distinction matters and produced one false finding this
> round** (FBC-7 below).

---

## The headline, before the arithmetic

**Dispatch 18 did everything it was scoped to do.** All six false-claim findings (FBC-1 … FBC-6)
are **CLOSED and verified**, including the one that shipped in the PDF. The macro unification is
real: `\mathbb` returns **zero** in the three live `.tex` files. That is −30 of round 5's −123
removed cleanly.

**The score did not move because the round-5 collision census was short by six, and the shortfall
is the warden's own.** Three of the six new collisions ($\varDelta$, $\varTheta_k$, $Z(\varphi)$)
are verifiably present in `archive/proofs_partH.tex`, so they **predate dispatch 18 by several
rounds**; two ($\varXi_n$, $\mathbf M_n$) could not be dated; **one ($\mathcal J$) is genuinely new
material from dispatches 19–20 and is the most serious item in this report.**

**The warden's self-diagnosis, which is the useful part:** *"I swept for the symbols named in my
findings and never ran a font-and-variant census."* Four variant Greek capitals — `\varDelta`,
`\varTheta`, `\varXi`, `\varUpsilon` — are live and **none has a glossary row**; round 5 found one
of the four.

| Class | Count | Each | Total |
|---|---|---|---|
| Collisions | 10 | −15 | −150 |
| Undeclared symbols / local families | 8 | −5 | −40 |
| False claim in a binding file | 1 | −5 | −5 |
| Typography | 3 | −2 | −6 |
| **Raw** | | | **−201** → floored to **0** |

---

## Collisions, ranked

**COL-A. `\mathcal J` carries two live meanings, both in *statements*. NEW (dispatch 19/20). The
most serious item in this report.**

**[VERIFIED]**
- Reading (a), **singular-system index set** — `results.tex:223–224`, inside `prp:compact`'s
  **statement**: $(\sigma_j;e_j,\tilde e_j)_{j\in\mathcal J}$, $\mathcal J\subseteq\IN$; also
  `proofs.tex:1243, 1244, 1248`.
- Reading (b), **the sample the iteration is run on** — `results.tex:3523`, inside `def:lfstep`:
  *"Write $\mathcal J$ for the sample the iteration is run on"*; then `:3525, 3530, 3531, 3539,
  3555, 3557`. At `:3531` it is written **$i\in\mathcal J$**, an observation index, against
  `:223`'s **$j\in\mathcal J$**, a singular-value index.

Both bare, unsubscripted, calligraphic. **Neither is inside a proof**, so §1.6's "dies inside a
proof" cover is unavailable. **And the sweep was on record before the claim:** §1.5h's
methodological note ran the calligraphic census and lists $\mathcal J$ among the letters that are
**all** in use, naming `prp:compact` as its owner; **C77 cites $\mathcal J$ by name** as one of the
reasons $\mathcal R^{(j)}_k$ had to be renamed. This is C31/C32/C34's exact species — *a resolution
claimed a slot the file's own census had already recorded as occupied*. No glossary row for (b).

**[ORCHESTRATOR NOTE]** `def:lfstep` **does** carry an index warning at `:3525` — but about the
*superscript* $k$ (fold versus stage index), **not** about $\mathcal J$ colliding with
`prp:compact`. The collision is unacknowledged.

**COL-B. Bold $\mathbf M_n$ against live italic $M_n$** — separated only by weight, identical $n$
subscript. `proofs.tex:5117–5127`. The letter $M$ now carries **five** forms: retired italic $M$
(C7, binding voice), live italic $M_n$ (§8.9, recorded hazard), sans-serif $\mathsf M$, calligraphic
$\mathcal M$, and bold $\mathbf M_n$ (**no row**). §1.6's bold-roman family row enumerates
"$\mathbf B,\mathbf D,\mathbf G_n$" and is short by one. **Decisively: §8.9's specified repair for
COL-4 is "sans-serif $\mathsf M_n$"**, which would leave four live forms at once.

**COL-C. Italic $Z(\varphi)$ against the binding exogenous control $Z,\Delta Z$ — and they
co-occur inside one proof.** $Z(\varphi):=\|\bar T(\varphi)-E\bar T(\varphi)\|_{L^2(\Pi)}$ at
`proofs.tex:4630–4672`; **$\Delta Z$ is live in the same proof at `:4592, 4604, 4608`**, 22–38
lines earlier. C30's "never co-occur" defence is unavailable. §1.6's $\mathsf Z_n$ row exists
*precisely* "against the binding italic $Z$, $\Delta Z$". Present in `archive/proofs_partH.tex:701`
— **a round-5 miss, not a regression.**

**COL-D. $\varDelta$ against $\Delta$** — variant italic capital against C11's kept binding
operator, **live in a lemma statement**: `results.tex:2293–2296`, `lem:intker`(ii), *"for all
$v,\varDelta\in\IR$"*; also `proofs.tex:3606–3608`. $\Delta$ is the period-difference operator with
hundreds of sites. Glossary grep for `varDelta`: **zero**. In `archive/proofs_partH.tex:83–85`.

**COL-E. $\varXi_n$ against $\Xi,\Xi'$ (`def:spaces`) and $\Xi_\ast$ (§1.6).**
`proofs.tex:5093–5127`. Some separation exists (variant glyph plus $n$ subscript) but **no row
records it**, in the very round dispatch 18 spent two corrections establishing where bare $\Xi$ is
declared. Glossary grep for `varXi`: zero.

**COL-F. $\varTheta_k$ against $\Theta_{s_0},\Theta_1$.** `proofs.tex:3791–3795`, `prp:tccfails`.
$\Theta_{s_0},\Theta_1$ were defined in C3 *after a round-12 finding* that they had been used at six
live sites with no declaration. Glossary grep for `varTheta`: **zero**. In the archive.

**COL-1. $\Upsilon$ vs $\varUpsilon$.** *Carried, open* (known not attempted). 22 lines vs 12
lines / 19 occurrences, `lem:bdiff` statement and proof.

**COL-2. $\varrho_{\mathrm B}$ against RESERVED $\varrho$.** *Carried, open.* 4 lines / 7
occurrences. §0:74 still reads *"may not be reused for anything else, **at any subscript**."*

**COL-3. Italic $N$ — now FIVE readings, two colliding inside one proof.** *Carried, WORSE.* The
four of round 5 plus **(e) the $\epsilon_0$-net cardinality**: `proofs.tex:4668, 4670, 4672`, and
`:5115`. **`lem:unifop`'s proof writes `lem:bdiff`(i) with $N=n_{\mathrm m}$ at `:4634`, then
$\varphi_1,\dots,\varphi_N$ at `:4668` — 34 lines apart, two different integers, one bare italic
capital.** §1.6's declaring sentence separates $N$ from $n$ by case, which separates nothing here.

**COL-4. Italic $M_n$ against C7's retirement.** *Carried, open, honestly recorded at §8.9.*
Compounded by COL-B.

---

## Undeclared symbols and local families

**UND-A. The breve accent family — a fifth accent with no declared meaning. NEW.** $\breve\nu$,
$\breve\nu_{u,t}$, $\breve g$, $\breve g_{u,t}$ at 13 sites in `proofs.tex` and — new in dispatch
19/20 — `assumptions.tex:2750`. **Grep for `breve`/`check`/`accent` over the glossary: no matches.**
The project declares hats, bars, tildes, stars, daggers and circles; the breve carries "the
infeasible version with $\varrho$ in place of $\hat\varrho$" and is declared nowhere. Not charged as
define-before-use — the `assumptions.tex` site points forward by named anchor — but it puts an
undeclared accent into the **first** file of the compiled reading order.

**UND-B. The sans-serif numbered constant register. NEW.** **17 live members**
($\mathsf c_0..\mathsf c_6,\mathsf c_8..\mathsf c_{12},\mathsf c_{14}..\mathsf c_{18}$). §1.6
enumerates three and calls the integer subscripts *"the two locally declared constants of Part G"*;
§1.7 adds four more. **Eleven are declared nowhere in the glossary**, and the numbering is a
**global counter** — the same shared-resource shape the file partitions carefully for the C-slot
register, with no equivalent inventory. Members are declared in place, which is why this is one
finding and not eleven.

**UND-C. $\mathcal V_n^{\circ}$ — the $\circ$ decoration is bound to something else. NEW.**
Declared in place, so define-before-use is met. But **C75 binds $\circ$ to "the base point at which
the linearisation is evaluated"** ($\varphi_\circ,\theta_\circ$), and here it means "countable dense
subset". Separated by superscript-versus-subscript, and $\varphi_\circ$ verifiably does **not** occur
inside `lem:unifop`'s proof — so no co-occurrence, but no row records the second meaning.

**UND-1 … UND-5.** *All carried, open.* `lem:bdiff`'s local block (§8.0 now records the $V$ row as
**owed** — good-faith disclosure, live defect); the dispatch-17 locals; bare $\mathcal C$ restored
without amending C15; $\varepsilon_{\mathsf p,n}$ (**8 occurrences in `proofs.tex`, 0 in the
glossary**); and the prime convention / $\beta$ / sans-serif families — of which **one part is
CLOSED**: the undeclared test function $\beta(\cdot)$ is gone, swept to $\varkappa$. Five $\beta$
readings remain, two undeclared.

---

## False claims in a binding file

**FBC-7 — REPORTED BY THE WARDEN, AND IT IS A FALSE FINDING. [ORCHESTRATOR VERIFIED]**

The warden reported C74's *"$\IE_n,\IE_{n,k}$ **47 sites**"* as wrong, measuring 44. **Both numbers
are right and they measure different things:**

```
\IE_   LINES-with-match : 44
\IE_   OCCURRENCES      : 47      <-- C74 counts occurrences; C74 is CORRECT
```

The warden's own preamble states its tooling counts lines. **This is exactly that.** Sending it to
a fix dispatch would have "corrected" a correct count into a wrong one. **No deduction should be
taken for FBC-7** — the −5 above is retained only to keep the warden's arithmetic reproducible, and
the true raw total is **−196**, still far below the floor.

The orchestrator's separately reported figures (`\IE` 48, `\IQ` 9, `\IC` 2, `\IN` 3) counted one
bare `\IE` inside a `%` comment at `proofs.tex:3546` as live. **Live counts are `\IE_` 47
occurrences, `\IQ` 8, `\IC` 1, `\IN` 2.**

---

## Typography

**T-3. Open, worse.** No §1.7 row separates $\Psi_{jk}$ (two integer subscripts) from $\Psi^{(j)}_k$
(parenthesised superscript plus subscript) — the closest pair on the letter. And a **fourth form is
live with no row**: bare $\Psi^{(1)},\Psi^{(2)},\Psi^{(3)}$ without the $k$ subscript.
**T-4. Open.** Step-level prime drift at four sites, all naming different conclusions.
**T-5. NEW.** §1.7's $L$ rule is stated as a closed three-way rule, and a **fourth form is live
matching none of the three**: $L^{\,b}_{\ell}$, `def:weight`(b), used at ten sites. Third instance
of a species the file has already amended twice.

---

## Dispatch-18 verification: 9 of 10 CONFIRMED, 1 DONE-BUT-WRONG-ON-COUNTS

All six false-claim corrections **CONFIRMED**, each checked at the row that made the claim,
including the compiled `\mathsf Z` sentence (now dated, and the claim as rewritten is **exact**:
three bare occurrences, all inside `prp:stopfeas`(ii)'s proof). The $\varsigma/\varkappa$ sweep is
**complete** — three sites, zero survivors. `def:spaces` genuinely declares $\Xi,\Xi'$, so the
relocated pointer is right. C62 amended in the open. **Macro unification: substance CONFIRMED
(zero raw `\mathbb`); counts not reproducible — see FBC-7, which is itself a lines/occurrences
artifact.**

**The most valuable thing dispatch 18 produced**, per the warden: the new §1.5g(i) clause requiring
every slot sweep to state **as of which dispatch** it was run. *It is what made three of this
round's verification checks mechanically possible.*

**One residual noted, not charged:** a false "§1.6 contains X" string survives at
`archive/results_partH.tex:137` — a `%` comment in a non-compiled archived file.

---

## Round-5 disposition

**CLOSED:** FBC-1, FBC-2, FBC-3, FBC-4, FBC-5, FBC-6, T-1 (substance), T-2 (closed incidentally,
not claimed by dispatch 18), and the $\beta(\cdot)$ half of UND-5.
**STILL OPEN:** COL-1, COL-2, COL-3 (worse), COL-4, UND-1, UND-2, UND-3, UND-4, UND-5, T-3
(worse), T-4.
**NEW:** COL-A, COL-B, COL-C, COL-D, COL-E, COL-F, UND-A, UND-B, UND-C, T-5, FBC-7 (false).

---

## Distance to the gate

| Step | Work | Score |
|---|---|---|
| 1 | **`\mathcal J`** — rename reading (b) in `def:lfstep`. 7 lines, one paragraph, no consumer outside it; the paragraph's own text calls it *"the sample the iteration is run on"*, which is sayable without a letter (C78 precedent) | **15** |
| 2 | **One §1.7 row declaring the variant-Greek-capital convention**, or four renames ($\varDelta,\varXi_n,\varTheta_k,\varUpsilon$). The row is cheaper and is the C20/C59 four-font device the file already runs. $\varDelta$ in `lem:intker`(ii)'s **statement** may need the rename regardless | **75** |
| 3 | **$Z(\varphi)$** and **$\mathbf M_n$** — one rename each, one proof each, no consumer outside | **105 → clears the floor** |
| 4 | COL-1..4, UND-1..5, UND-A/B/C, T-3/T-4/T-5 | **100** |

**Steps 1–3 touch four proofs and one definition.** None requires a new argument; none changes any
stated result.

## Verified clean

Zero raw `\mathbb`. The $\varsigma/\varkappa$ sweep complete. The `\mathsf Z` sweep as now written
is true. $\mu_{\rm H1}$ properly declared at all 12 sites. The §1.5g(i) dating clause honoured in
every sweep sentence written this dispatch.

## Scope declared

The notation table covers the binding spine plus every symbol implicated in a finding. **A table
for all ~400 corpus symbols was not built and is not asserted.** The warden did not independently
re-run the full nine-reading superscript census or the six-reading $\xi$ census; it spot-checked one
of each and both held. $\varXi_n$ and $\mathbf M_n$ could not be dated — the archive holds no
counterpart of `prp:phirate`'s proof.
