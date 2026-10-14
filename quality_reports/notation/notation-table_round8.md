# Notation Audit — `panel-npiv-discrete`, round-8 re-sweep

**Critic:** notation-warden (read-only; persisted by the orchestrator)
**Score: 0 / 100** (floored; raw −119)
**Artifacts read:** `quality_reports/theory/panel-npiv-discrete/{results.tex, proofs.tex, assumptions.tex, notation_glossary.md, theory_memo.md}`; `paper/sections/theorems/{lem-shiftinv,lem-bierens,lem-adjoint,rem-nophifree}.tex`; `paper/preambles/preamble.tex`.

> **Filename note.** The dispatch-2 report survives at `notation-table.md`.
> **Full symbol table** is in the agent record; this file carries the verification section, the Part-F additions, all findings, and the gating verdict.

---

## Section 0 — Verification of the round-7/8 fixes

All verified by inspection, not assumption:

| Claim | Verdict | Witness |
|---|---|---|
| `cor:rangegap`'s operator → $\Upsilon$ | ✓ in source | `results.tex:790–792`; glossary `:211` |
| Borel → $\mathfrak B(\cdot)$ | ✓ in source | `proofs.tex:717, 720, 785, 830, 1196`; glossary `:213` |
| "never carries a subscript" rule **replaced**, not patched | ✓ | glossary `:81` (C20), `:121` ("The 'no subscript' rule of round 6 is withdrawn") |
| $L_\star$ defined via `def:weight` | ✓ | `results.tex:1103–1126`; A2′(iii) at `assumptions.tex:538–540` |
| Two glossary rows with the refuted $\mathcal B_{\rm sym}$ formula | ✓ corrected | C12 `:59`; $\mathcal B_{\rm sym}$ row `:231` now prints $(\vartheta'\sigma_q/\pi)\cdot-\vartheta'(\tilde{\mathcal K}+\tilde{\mathcal K}^\ast)$ |
| `$\varsigma'\psi$` at three sites | ✓ all three | glossary `:170`, `:70`; `theory_memo.md:796` |

**T1-2 ($\psi$) and T1-6 ($\ell_\dagger$) are NOT re-raised.** Both refutations hold against the artifact: glossary `:197` fixes $\psi$ as the moment function and the Part-F sites are that reserved use; `:194` now carries the $\ell_\dagger$ row and §8.5 `:385–390` states the $\Pi$ rule as a **type marker, not a ban**. No witness against either.

**On advisory 4.6 — half closed, half not.** The symbol table **does** now carry a seminorm row (`notation_glossary.md:241`) covering both $\|D\|_{0,h}$ and $\|D\|_{1,h}$, with the sup-outside/sup-inside asymmetry stated and `rem:supinside` cited. **The "no rows" half is discharged.** The $\bar\tau$-suppression is not — priced as V-9.

---

## Section 1 — Part F symbols (new since the last sweep)

| Symbol | Type | Definition | First defined |
|---|---|---|---|
| $\tau=(\tau_1,\tau_2,\tau_3)$ | $\IR^3$ | perturbation parameter | `results.tex:1271–1275` |
| $\bar\tau$ | constant $>0$ | radius in $\tau_1$ | `results.tex:1151` (`def:dirclass`) |
| $D$ | $\IR\times\IR^p\to\IR^p$ | perturbation direction in $L$ | `results.tex:1160` |
| $\mathsf r$ | $\IR^p\to\IR$, bounded | perturbation direction in $\varrho$ | `results.tex:1159` |
| $(D,\mathsf r)$ | pair | admissible direction pair at $(h,\bar\tau)$ | `results.tex:1157` |
| $\|\Xi\|_{0,h}$ | $[0,\infty]$ | $\sup_{|\tau_1|\le\bar\tau}\|\Xi(\cdot-\tau_1\Delta h,\cdot)\|_{L^2(P)}$ — sup **outside** | `results.tex:1152–1155` |
| $\|D\|_{1,h}$ | $[0,\infty]$ | $(E[\sup_{|s|\le\bar\tau}\|\partial_uD\|^2])^{1/2}$ — sup **inside** | `results.tex:1164–1166` |
| $A,B,C,F$ (of $\tau_1$) | functions | the four expectations of `eq:biaffine` | `proofs.tex:1546–1548` |
| $\bar{\mathsf r}$ | constant | $\|\mathsf r\|_\infty$ | `proofs.tex:1537` |
| $\Psi_L(\tau_1)$ | $\IR^p$-valued | moment along the $\varphi$-direction only | `results.tex:1377–1380` (`eq:PsiL`) |
| $L^{\,b}_\ell$, $b$, $b_\star$, $\hat b$ | weight, anchors | $\int_0^u\ell+b(z)$ | `results.tex:1111–1119` |
| $\Upsilon$ | $L^2(P_{\Delta U,\Delta Z})\to\mathcal V$ | tilted difference map | `results.tex:789–792` |
| $\vartheta$ | unit vector in $\IR^p$ | coordinate-contraction direction; **BINDING on Step 4** | `results.tex:1248`; glossary `:242` |
| $\mathfrak B(\cdot)$ | $\sigma$-algebra | Borel; Fraktur without exception | glossary `:213`; `proofs.tex:717` |

**Clean, recorded so it is not re-audited.** Expectation/probability: bare $E[\cdot]$, $P(\cdot)$ **without exception across all seven files** — no $\mathbb E$/$E$ or $\mathbb P$/$\Pr$ mixing. Vector typography: non-bold throughout for $\theta,\nu,\ell,\psi,\vartheta,\Delta Z,q,\sigma_q,D,b$; bold reserved for $\mathbf B,\mathbf D$, consistent with glossary `:121–122`.

---

## Section 2 — Violations

### Collisions (−15 each)

**V-1. Italic $D$ — Part-F perturbation direction AND the degenerate region. −15.**
Direction (~40 sites): `results.tex:1157–1171`, `1268–1310`, `1318–1362`, `1206`, `1402`; `assumptions.tex:932–934`; glossary `:240`. Degenerate region $D:=\{z:\varrho(1-\varrho)=0\}$: `proofs.tex:569, 595, 626, 628`; `lem-bierens.tex:156, 158`.
**Not absorbable by the local-variable doctrine.** C27 lifted C2's retirement of italic $D$ on an explicit **three-font rule** (glossary `:88`, §8.6 `:400–407`) — $\mathcal D$ operator, $\mathbf D$ design matrix, italic $D$ direction. **The italic slot was claimed and was already occupied.** §8.6's recorded hazard contemplates only a *future* clash with $\mathbf D$; the live clash is inside the italic slot, in the same file, today.

**V-2. Roman $M$ — retired by C7, then reused for two different objects. −15. GATES STEP 4.**
C7 (glossary `:49`), in the binding voice: "$M$ **retired**: the multiplier of `prp:sharpquad` is written **$\sigma_q$** throughout … **Binding on the Step-4 dispatch.**"
- **Reuse (a), the multiplication operator:** `proofs.tex:1453` "$M:=(\vartheta'\sigma_q/\pi)\cdot{}$", then `:1457, 1460, 1462, 1470` — **inside `lem:solset`(iii)'s proof, the exact argument §8.4 item 3 tells Step 4 to inherit.**
- **Reuse (b), a scalar constant:** `proofs.tex:1655` "$D(u,z)=M\un\{u\in[1,2]\}$ for a constant $M>0$", then `:1657` (×3), `:1658` (×2), `:1664`.
**Why it gates.** C7 retired $M$ *because $M$ meant the multiplier and the multiplier is now $\sigma_q$*. A Step-4 author obeying C7 reads `:1453`'s $M$ as $\sigma_q$. **It is not** — it is multiplication *by* $\vartheta'\sigma_q/\pi$, precisely the distinction §8.4 item 2 exists to protect. The lower-bound chain at `:1452–1466` runs entirely on $M$, and that is the chain `prp:sharpquad` must reproduce.

**V-3. $\vartheta$ — BINDING Step-4 direction in the source, generic integrable function in a rendering. −15. GATES STEP 4.**
Unit direction: `results.tex:1248–1259`; `proofs.tex:1405–1485`; `assumptions.tex:29–30, 718–725`; glossary `:242`. Generic integrable function: **`lem-adjoint.tex:119, 120, 145, 146`** — `lem:nusigma`(v) still reads "$g=\widetilde W\,\vartheta(\Delta U,\Delta Z)$ for an integrable $\vartheta$", where `results.tex:697–698` carries the C25 replacement $\Xi$.
**Why it gates.** `lem:solset`(iii)'s proof closes at `proofs.tex:1489–1490`: "$\int\sigma_q\,dx=0$ … is `lem:nusigma`(v) applied with **$\Xi=\partial_u\ell_\star$**." A Step-4 author following that `\cref` into the rendered lemma lands on a slot occupied by $\vartheta$ — the Step-4 direction letter — where the instantiation says $\Xi$.
**And it is the seventh unsynced item in a list of six.** `lem-adjoint.tex:60–72` enumerates six; C25's $\vartheta\to\Xi$ move is absent. The header itself warns at `:52–58` that "a hand-kept list of exceptions is the SAME failure mode as a hand-kept header … it failed in exactly that way in round 7 — the list said FIVE and omitted a sixth." **It now says six and omits a seventh. The mechanical-diff discipline the header asks for is the fix; the list is not.**
*Mitigation, stated honestly:* Part F is not rendered, so the two meanings do not yet co-occur in one compiled document — but the `\cref` already points across the gap.

**V-4. $\mathcal S$ — selection functional AND spline span. −15. GATES STEP 4 (weakly).**
Selection functional $\mathcal S\ell:=\sigma_{\widetilde W\partial_u\ell}$: `results.tex:1249–1250`; `proofs.tex:1373`; glossary `:229` — "$\sigma_q=\mathcal S\ell_\star$, and **$\mathcal S$ is what SG-15 sweeps**". Spline span $\mathcal S_{L_x}$: `proofs.tex:1895–1946`; glossary `:90, :126`.
**C29 introduced the collision while fixing another.** C29 moved $E\to\mathcal E$ and the infimum's bound variable $g\to\varkappa$ on the stated ground that "two arguments and a subscripted space do not disambiguate a symbol from the most-used symbol in the project" — **then wrote that subscripted space as $\mathcal S_{L_x}$ without checking $\mathcal S$.** No glossary row for $\mathcal S_{L_x}$; §1.7 does not document the pair, though the project has precedent (the $\sigma$ and $L$ families, glossary `:129, :132`).

**V-5. $\mathcal B$ — tilted difference map AND Borel $\sigma$-algebra, live in one compiled document. −15.**
Operator (~13 sites): `lem-adjoint.tex:373–408`. Borel: `lem-adjoint.tex:214`, `:520`. Resolved in the source ($\Upsilon$, $\mathfrak B$), unresolved in the rendering. **Since the four theorem files now compile together this is a live INV-7 breach in a real artifact**, by the same standard that caught the $\psi$ breach.
*Mitigation:* self-declared at `lem-adjoint.tex:65–83`, naming both sites and stating "The collision is LIVE IN THE COMPILED DOCUMENT and is DEFERRED, not resolved." **Declaration is honest and credited; it does not remove the defect.** Can wait — until the next rendering pass, which the header already schedules.

**V-6. Italic $a$ — degree of ill-posedness AND the value $\Phi(1)$. −15.**
Ill-posedness (glossary `:234`): `results.tex:315`; `assumptions.tex:792–799` (H1), `:1423`. $\Phi(\pm1)=\pm a$: `results.tex:429, 433, 439`; `lem-bierens.tex:222, 226, 232`; `assumptions.tex:319`.
**Not merely local.** §1.6 `:105` declares $\mathsf c$ sans-serif expressly to keep generic constants separate "from $c(z)$…, from $c_\Phi$, $c_\Pi$, and from **$a$ (the degree of ill-posedness)**". `rem:swintercept`'s $a$ is exactly a generic constant, **so the glossary's own separation rule is breached on the symbol the rule names.** Aggravated by $\cos(ta)$ at `results.tex:433, 439`, juxtaposing the RESERVED index $t$ with $a$.
*Mitigation:* the two do **not** co-occur in the rendered set. Can wait.

**V-7. Italic $B$ and the `eq:biaffine` family $A,B,C,F$ — a fourth font of a letter §1.7 declares three-font. −15.**
`proofs.tex:1545–1548` introduces $\Psi=A+\tau_2B+\tau_3C+\tau_2\tau_3F$, a **labelled** display advertised in `theory_memo.md:65` as this round's bi-affine fix, cross-referenced at `:1618, 1674`.
- $B$: glossary `:121` declares "$\mathcal B$ / $\mathbf B$ / $\mathfrak B(\cdot)$ … **Never written without its font.**" Plain italic $B$ is a fourth font, not in that row; collides with the generic Borel set $B$ at `results.tex:149`, `proofs.tex:491, 536`, `lem-bierens.tex:82`.
- $C$: collides with the generic constant $C$ at `proofs.tex:1663, 1664` — **inside the same proof, 117 lines after `eq:biaffine`** — and `:1892`.
- $A$: collides with the event $A$ at `proofs.tex:1654–1657` (same proof), `results.tex:1205–1206`.
- $F$: collides with $F_j^{(\theta,\varphi)}$ at `results.tex:339, 343`, `proofs.tex:566, 576, 592`, `lem-bierens.tex:154–157`, and $F_{\mathcal N}$ (glossary `:280`).
**The local doctrine gives no cover:** §1.6 `:95–97` scopes local symbols by "the display or proof in which they appear", and here two declarations of $A$ and two of $C$ sit **inside a single proof**, across steps that cite one another.
*Self-flagged as the most arguable finding:* $A(\tau_1)$ and $F(\tau_1)$ are each used once, so only $B$ and $C$ carry forward. The reply to "it is scratch notation" is that it is labelled, cross-referenced twice, and named in the memo as a durable repair. Can wait.

### Undefined on first use (−5 each)

**V-8. $\hat{\mathcal A}_{\tilde\varphi}$, $\hat{\mathcal A}_{\rm cond}$, $\hat{\mathcal A}^\ast_{\rm cond}$ — used in a maintained assumption, defined nowhere. −5.**
`assumptions.tex:1154` (A6, inside the tangential-cone display) and `:1286–1287` (C3). No glossary row, no defining display in any `.tex`. **The hat convention is insufficient here:** $\hat T$ gets a row ("sample analogue of $T$", glossary `:208`), but $\mathcal A_\varphi$ is a **Fréchet derivative**, so "sample analogue" is ambiguous between "the derivative of $\hat T$" and "a separately smoothed operator" — and C3, by attaching a bandwidth $h_x$ to it, implies the second. **A6 is the tangential-cone condition; its content depends on which reading holds.**

**V-9. $\|\cdot\|_{0,h}$ suppresses the $\bar\tau$ that `eq:dirmember` quantifies over. −5.**
The seminorm is defined at `results.tex:1151–1155` after "Fix $\bar\tau>0$ **and** $h\in\mathcal V$", so its value depends on $(h,\bar\tau)$; the glyph carries only $h$. `def:dirclass` is careful elsewhere — "admissible direction pair at $(h,\bar\tau)$" names both.
**The consequence is a display that invites a false inference.** `rem:dirmember` reads "for every $h\in\mathcal V$ and **every $\bar\tau>0$**" then prints a left side with no $\bar\tau$ and a right side with $\bar\tau^2$, under a universal quantifier over $\bar\tau$. **Read literally, one minimises the right side by letting $\bar\tau\downarrow0$ and concludes a $\bar\tau$-free bound — false, because the left side grows with $\bar\tau$.** The statement is mathematically correct; the notation gives no signal against the invalid reading.
*Pricing rationale, given explicitly:* −5 under define-before-use, not −15, because the glyph is *incompletely* specified rather than doubly specified, and glossary `:241`, `def:dirclass`'s pair notation and `rem:supinside` all name the dependence in prose. **Charged at all because `rem:dirmember` is a declared forward obligation on Step 6/7, and the one place the reader is told to carry the display forward is the one place the notation misleads.** Not a Step-4 item.
*Advisory, no deduction:* glossary `:243` calls $\bar\tau$ "fixed once in `def:dirclass`", but `lem:secondord` re-fixes it (`results.tex:1267`) and `rem:dirmember` quantifies over it.

### Typography (−2 each)

**V-10. Sets and events italic where the convention is calligraphic. −2.** $\mathcal X,\mathcal V,\mathcal T,\mathcal I,\mathcal C_0,\mathcal N_0,\mathcal U_k,\mathcal S_{L_x},\mathcal J,\mathcal G_\ast$ all calligraphic; $\IR,\mathbb N,\mathbb Q$ blackboard; $\mathfrak B$ Fraktur. Three italic: degenerate region $D$, zero set $Z_t$, event $A$. Charged once; overlaps V-1 and V-7.

**V-11. `\mathrm` vs `\operatorname` inconsistent. −2.** `supp`: `\mathrm` at `results.tex:493–498`, `lem-bierens.tex:270–271`; `\operatorname` at `proofs.tex:953–982`, `lem-adjoint.tex:309`. `sign`: `\mathrm` at `proofs.tex:722`; `\operatorname` at `:1819`. **The two differ in spacing before the argument, so the same operator sets differently in the compiled document.**

### Sub-threshold — considered and declined

Recorded so the theorist sees what was weighed. Plain $c$ vs C18's $\IR^p$-valued $c(z)$ (type separation total). $Z_t$ as a zero set (declared in place, dies within the step) — though `results.tex:860, 1015` use $Z_t$ for Fève–Florens's period-$t$ regressor, breaching C6, **inside an explicitly declared verbatim-foreign-notation block, which is the right way to do it**. $\Lambda_z(u)$ a fourth $\Lambda$ whose discriminator does not separate it from $\Lambda_1$. $\xi$ with four local meanings, the third being exactly the type $\Xi$ is declared for. $P$ as polynomial vs probability in one rendered file (self-disambiguating). The prime doing three jobs — transpose, derivative, variant-marker — with two in one display at `lem-shiftinv.tex:41` (standard practice). Missing glossary rows for $\bar c_\pi$ (~25 sites), $\mathcal S_{L_x}$, $\mathcal J$, $P_{L_x}$, $\psi_\star$. **Cross-project hazard, not a defect:** `dummy.tex:14` uses $\mathbb E$ where this project uses bare $E$ — its own header declares the difference and the preamble defines `\IE`, which `panel-npiv-discrete` correctly never uses.

---

## Score

| Bucket | Count | Deduction |
|---|---|---|
| Collisions | 7 (V-1 … V-7) | −105 |
| Undefined on first use | 2 (V-8, V-9) | −10 |
| Typography | 2 (V-10, V-11) | −4 |
| **Raw** | | **−119** |
| **Score** | | **0 / 100** (floored) |

---

## Step-4 gating verdict

**Must clear before `prp:sharpquad` is dispatched (raw −35):**
- **V-2 ($M$)** — inside `lem:solset`(iii)'s lower-bound chain, which §8.4 items 2–3 instruct Step 4 to inherit verbatim, breaching a retirement C7 declares "Binding on the Step-4 dispatch."
- **V-3 ($\vartheta$)** — the Step-4 direction letter occupies the generic-function slot in a rendered lemma that `lem:solset`(iii) `\cref`s by name.
- **V-4 ($\mathcal S$)** — $\sigma_q=\mathcal S\ell_\star$ is the Step-4 object and glossary `:229` names $\mathcal S$ as what SG-15 sweeps.

**Can wait — fix before the next rendering pass (raw −84):** V-1, V-5 (already scheduled by `lem-adjoint.tex`'s header), V-6, V-7, V-10, V-11.

**Step 6/7, not Step 4:** V-8 ($\hat{\mathcal A}$, consumed by A6/A7 and `prp:phirate`), V-9 ($\bar\tau$-suppression, consumed by `rem:dirmember`'s forward obligation).

**Sensitivity, so the number is legible.** Charging only the Step-4 gating items gives raw −45, **score 55**. Holding V-5 as declared-and-scheduled still gives 0. **The floor is doing real work: the count is dominated by seven independent glyphs, not one artifact.**

---

## One structural observation, offered without a proposed remedy

**Five of the seven collisions (V-1, V-2, V-4, V-6, V-7) share one shape:** a round-7 resolution **claimed a slot** — italic $D$, the letter $M$, calligraphic $\mathcal S$, the constant $a$, the letter $B$ — **and the slot was already occupied** by an object introduced in Part A–C. Each resolution reasoned carefully about the symbols it *renamed* and did not sweep for the letter it *claimed*.

C25's own record (glossary `:70`) says the `$\varsigma'\psi$` residue was "found by sweeping the file rather than by the finding, which named only the $\sigma_q$ row." **That method, applied to the five claimed slots, returns all five of these.** The theorist decides which symbol moves in each case; the warden reports only that the sweep was run in one direction and not the other.
