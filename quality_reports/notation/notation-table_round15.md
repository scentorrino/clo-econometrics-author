# Notation Sweep — `panel-npiv-discrete`, round 5 (post-dispatch-16/17)

**Date:** 2026-07-31
**Score: 0/100** (floored; raw deduction −123). **Was 49.** Blocks the notation-consistency component.

> **Persistence note.** The notation-warden is read-only (`agents.md` §2). Orchestrator transcription; **[ORCHESTRATOR VERIFICATION]** marks checks re-run afterwards.

---

## Why it fell — and the finding is structural, not a regression

**Dispatch 17 compiled the (P1)–(P9) conventions into 17 numbered environments at `proofs.tex:386–979`.** Counted: 17, exactly as claimed. **No notation sweep has ever seen that material** — it was a `%`-comment block until this dispatch, therefore invisible to every prior round.

Five new findings and four new false binding-file claims sit inside it, or inside the one lemma (`lem:bdiff`) that four rounds have now declined to declare. **Dispatches 16 and 17 closed real things** — five round-4 items verified CLOSED below — **but on this axis they exposed more than they closed.** The defects were there all along; compiling the block moved ~600 lines from invisible to auditable.

| Class | Count | Each | Total |
|---|---|---|---|
| Collisions | 4 | −15 | −60 |
| Undeclared symbols / local families | 5 | −5 | −25 |
| False or unreproducible claims in a binding file | 6 | −5 | −30 |
| Typography | 4 | −2 | −8 |
| **Raw** | | | **−123** → floored to **0** |

---

## Collisions (these gate)

**COL-1. $\Upsilon$ vs $\varUpsilon$ — same Greek capital, upright against italic, no row anywhere. NEW.** C20 binds $\Upsilon$ to `cor:rangegap`'s tilted difference map (21 occurrences). `lem:bdiff`(ii) binds $\varUpsilon_1,\dots,\varUpsilon_N$ — **19 occurrences at `proofs.tex:4483–4563`** — the italic variant of the same capital, same file, **no §1.6 row, no §1.7 row, no register slot**. This is C33's charged species and C10's stated ground (variant Greek is not separable in running text).

**COL-2. $\varrho_{\mathrm B}$ against the RESERVED $\varrho$. NEW.** Glossary §0:74 — *"A symbol marked **RESERVED** may not be reused for anything else, **at any subscript**."* C10 reserves $\varrho$ for the propensity score. `lem:bdiff` Step 4 writes the Bennett function $\varrho_{\mathrm B}(w):=(e^w-1-w)/w^2$ at `proofs.tex:4536, 4539(×2), 4541, 4544`. **[ORCHESTRATOR VERIFICATION: 4 macro sites confirmed.]** The `\mathrm` word subscript is exactly the device the project's *legitimate* symbols use ($\eta_{\rm TCC}$, $\tau_{\rm DP}$), so a reader has no signal this is not a propensity object — and the consuming site, `prp:phirate` Step 1, is about $\hat\varrho$.

**COL-3. Italic $N$ — four live readings; the declaring row swept only one competitor. NEW (dispatch 17).** §1.6 glossary:481 claims *"$N$ is separated from the sample size $n$ by case and never carries a subscript."* Live readings of bare, unsubscripted, argument-free italic $N$:
- (a) `lem:pfreeze`'s frozen nuisance, a $\mathcal G$-measurable random element of a function space — `proofs.tex:835, 839, 847, 851, 854–855, 883, 892, 931`
- (b) `lem:bdiff`'s integer count of independent variables — `proofs.tex:4478–4559`, consumed as "$N=n_{\mathrm m}$" at `:4612, 5059`
- (c) `lem:reprsmooth`'s mollification index — `proofs.tex:3100–3101`
- (d) the normal law $N(0,\cdot)$ — `proofs.tex:6310`; `results.tex:4928, 4934, 5027`

(a) and (b) are both bare italic capitals in lemma **statements** in one file.

**COL-4. Italic $M_n$ against C7's binding-voice retirement of italic $M$ — live in compiled text.** *Carried, STILL OPEN, honestly recorded.* `proofs.tex:643, 644, 675, 676, 678, 679, 722, 4173`. §8.9 states the breach in terms, names the repair (sans-serif $\mathsf M_n$, joining the existing §1.6 row, claiming no new letter), and records that dispatch 15's ground for leaving it — *"no reader of the paper meets it"* — **has expired**. Not created by dispatch 17: $M_n$ was already compiled at `lem:opnoise` Step 4. The charge is for the live breach, not the disclosure.

---

## False or unreproducible claims in a binding file — the class that regressed

**FBC-3 is the most serious item in this report, because the false claim is compiled.**

**[ORCHESTRATOR VERIFICATION — confirmed, and it is worse than "a glossary error".]**
```
proofs.tex:6383  →  "\verb|\mathsf Z| likewise sweeps to zero occurrences."
                    NOT a comment. No % prefix. THIS SHIPS IN THE PDF.
proofs.tex:4331  →  "take ρ̂−ρ equal to 𝖹 r_n times a fixed unit-norm function with
proofs.tex:4332      𝖹 a standard half-normal variable independent of n"
proofs.tex:4333  →  "P(‖ρ̂−ρ‖ > τ r_n) = P(𝖹 > τ) > 0"
```
The glossary carries the same false claim at :482. $\mathsf Z$ has been live since Part H, **predating the claim**.

**FBC-1. C74: "`\mathbb C` sweeps to zero occurrences in every `.tex`."** *Carried, STILL OPEN.* **[VERIFIED refuted at `proofs.tex:3422`]** — *"the real field is used twice … and over $\mathbb C$ the …"*.

**FBC-2. C74: "$\mathbb N$ likewise sweeps to zero."** *Carried, STILL OPEN.* **[VERIFIED refuted at `results.tex:223` — inside `prp:compact`'s STATEMENT]** — $\mathcal J\subseteq\mathbb N$.

**FBC-4. The parenthesised-superscript census enumerates six readings against at least eight live.** *Carried, STILL OPEN.* Two further live readings measured: $\ell^{(N)}$, a mollification index (`proofs.tex:3100, 3114, 3127, 3128`); and $F^{(\theta,\varphi)}_j$, a base-point pair tag (10 occurrences at 9 lines).

**FBC-5. Two dispatch-17 rows assert non-co-occurrence the artifact refutes. NEW.**
- §1.7:531 (the $\mathcal G$ row): *"conversely `lem:density` **uses no conditional expectation**."* It uses it at `proofs.tex:1555` (a labelled display, `eq:condzero`) and at `:1584–1586`. **That sentence is the row's stated ground for retaining both bare-$\mathcal G$ meanings.**
- §1.6:481: *"$\xi$ is a **third** local reading … and the three never co-occur."* A **fourth** is live (`lem:density` Step 1's generic element of $\mathcal G^\perp$, 11 occurrences) and it **co-occurs with $\mathcal G$ in the same step** — precisely the pairing the other new row governs.

**FBC-6. Four claims that §1.6, or the artifact, contains something it does not. NEW.**
- §8.0 and §5's row both assert *"italic $V$ is a reserved local in §1.6."* **§1.6's table has no $V$ row.** Bare $V$ is live at four sites including a **fourth reading new in dispatch 17** (`lem:psubst`(i)'s $\mathcal F_{XZW}$-measurable $V$).
- §1.6's $\Xi_\ast$ row and C72 both state *"$\Xi$ is already a §1.6 local."* **§1.6 has no bare $\Xi$ row.**
- The struck $\alpha,\beta$ row and C72 state the monotone-class factors in `prp:kerchar` are $\varsigma,\varkappa$. The artifact writes $\varsigma\otimes\beta$ at `proofs.tex:2055–2057` and $\varsigma(v)\beta(z)$ at `:1560–1563`. **This is the C44 species — a move recorded in the glossary and never swept into the text — flagged three times now.**
- **C62 declined the slot $a_n$ by name**; dispatch 17's §1.6:480 **claims it** and §8.9 re-argues the merits without citing C62. The decline is neither amended nor withdrawn, against this file's own "amend in the open" rule applied seven times elsewhere.

---

## Undeclared symbols and local families (−5 each)

**UND-1. `lem:bdiff`'s local block, still undeclared.** *Carried from round 13. STILL OPEN.* Live and undeclared at `proofs.tex:4476–4563`: $\zeta_1..\zeta_N$ (against C28), bare italic $F$, $\mathcal H_k$, $M_k$, $\Delta_k$ (against the period-difference operator), $Q_\lambda$ (a third italic-$Q$ reading in the slot C38 declined), bare $V$, $\mathsf a_1,\mathsf a_2,\mathsf b,\mathsf s,\mathsf B,\mathsf K$, bare $\lambda$ (against C13-as-amended). **Round 4's ruling stands and was not actioned: the remedy is §1.6 rows, not renames** — letter scarcity obstructs a rename.

**UND-2. The dispatch-17 block's own locals. NEW.** $\Xi,\Xi'$ as generic real random variables in `lem:pgence` (30+ occurrences, against $\Xi\in L^2(\Pi)$ per C72); bare $\phi$ in **two** undeclared readings, both one variant glyph from $\varphi$ — the pairing C10 retired $\rho$ for; $\mathcal G_0$ a sub-σ-field against $\mathcal G_\gamma,\mathcal G_\ast$ which are **closed spans**, with §1.7:531 written in the same dispatch omitting it.

**UND-3. Bare calligraphic $\mathcal C$ restored without amending C15. NEW.** Live at **23 sites**. **C15 resolved this exact collision by moving the σ-field off $\mathcal C$ to $\mathcal F_{XZW}$.** No row governs the restored use; C15 is not amended.

**UND-4. $\varepsilon_{\mathsf p,n}$ — the row round 4 named as owed.** *Carried.* 8 occurrences in `proofs.tex`; **0 in the glossary.**

**UND-5. A5(vi′) and the prime convention; two undeclared $\beta$ readings; two sans-serif families.** The prime rule (`results.tex:4682–4684`) says two clauses with *different* conclusions are numbered, not primed — A5(vi) and A5(vi′) have different conclusions, so no §1.7 row records the standing exception round 4 asked for. $\beta$ has **five** live readings against a row claiming two; the Hölder order $s-\tfrac12-k$ and the test function $\beta(\cdot)$ are undeclared. Two sans-serif families collide on $\mathsf a,\mathsf b$, and $\mathsf s$ appears in a **statement** (`prp:hatAprop`(i)), so §1.6's "dies inside a proof" cover does not reach it.

---

## Typography

**T-1. Preamble macros vs hand-rolled blackboard — the root cause of the false sweeps.** `preamble.tex:327–332` defines `\IR, \IQ, \IN, \IZ, \IC, \IE`. Measured: raw `\mathbb Q` ×9, raw `\mathbb C` ×1, raw `\mathbb N` ×1, raw `\mathbb E` ×**57**; against `\IC`+`\IQ`+`\IZ`+`\IE` combined ×1 and `\IN` ×1. **A `\mathbb`-only sweep sees one form and a `\I*`-only sweep sees the other — which is exactly how FBC-2 survived a sweep that was actually run.** Worth doing early regardless of score, because it is what makes future sweeps trustworthy.

**T-2.** §5's $\Psi$ row prints the moment map argument-free, against C77's separator. §1.7 was fixed; §5 was not.
**T-3.** No §1.7 row for $\Psi_{jk}$ against $\Psi^{(j)}_k$.
**T-4.** Step-level prime drift at `proofs.tex:5821` (Step 4′) and `:6077` (Step 6′), both naming different conclusions.

---

## Round-4 disposition

**CLOSED and re-verified:** both gating collisions ($q\to\mathsf p$, $\psi\to\mathsf H$); register C1–C79 contiguous with both records agreeing section by section; the §1.5h calligraphic census (`\mathcal O` = 0, `\mathcal Y` = 0 re-run — the corrected census is **true**); C77's three drifted line-number citations, now cited by named anchor. **MOSTLY CLOSED:** the $\Psi$ family gap. **PARTIALLY CLOSED:** (P8)/(P9)'s ASCII locals ($a_n$, $V_n$ disposed with argument; $M_n$ still open); §5's $\Psi_{jk}$ row.

**STILL OPEN:** FBC-1, FBC-2, FBC-3, FBC-4, UND-1, UND-4, UND-5, T-1.

---

## Verified clean (measured, not asserted)

- **C37 operator typography: 0 violations.** All 21 `\mathrm{ess}` hits are the permitted word subscript $\sigma_{\mathrm{ess}}$.
- **Register C1–C79** contiguous, no gaps, no duplicates.
- **17 numbered environments from dispatch 17**, counted. The claim is exact.
- **`\mathsf p`'s sweep claim is NOT a defect** — the sweep was true *before* the claim and the claimed symbol is its own exception. **But the diagnosis is worth acting on:** the file writes "zero at the time of the claim" and "zero now" in identical words, and that ambiguity is exactly what let FBC-3 through. **A one-clause convention — every slot sweep states as of which dispatch — makes the whole class mechanically checkable.**

---

## Distance to the gate — arithmetic, not estimate

| Step | Work | Score |
|---|---|---|
| 1 | Three false sweeps (FBC-1/2/3) + superscript census (FBC-4) — four string edits, **one in compiled text at `proofs.tex:6383`** | **20** |
| 2 | The four "§1.6 contains X" claims + two dispatch-17 non-co-occurrence claims — six sentences | **50** |
| 3 | COL-1 and COL-2 — one rename each, inside one lemma, no consumer outside `lem:bdiff` | **80 — clears the floor** |
| 4 | COL-3, COL-4, UND-1..5, T-1..4 | **100** |

**Steps 1–3 touch one lemma and one file section.** Nothing requires a new argument; none is a proof-body edit outside `lem:bdiff`.

## Scope declared

The notation table (in the full report) covers the binding spine plus every symbol implicated in a finding. **A table for all ~400 corpus symbols was not built and is not asserted.** Every row cites a location opened.
