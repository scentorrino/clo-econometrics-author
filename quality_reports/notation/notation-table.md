# Notation Audit — `panel-npiv-discrete` (dispatch 2 + Part F)

**Critic:** notation-warden (read-only; persisted by the orchestrator)
**Score: 0 / 100** (floored; raw deduction 185). **Blocks the gate.**

**Headline: eleven glyphs carry two or more live meanings.** Four violate a reservation the glossary itself declares in the binding voice (`RESERVED`, `retired … may not be reused`, `no meaning across results`, `without exception`). The glossary is declared binding on every later `.tex`, so each propagates by construction.

## Symbols with two or more live meanings

**T1-1. $\mathcal B$ — FOUR live meanings, not the two handed off.**
(a) $\mathcal B\Xi:=\nu_{\widetilde W\Xi}/\pi$, `results.tex:770–771` (`cor:rangegap`, **Part E** not F — the clash spans E↔F); (b) $\mathcal B=(\sigma_q/\pi)\cdot-2\tilde{\mathcal K}$ on $L^2(\pi)$, `results.tex:1060–1062`; (c) **the Borel $\sigma$-algebra $\mathcal B(\cdot)$** — `proofs.tex:663, 731, 771, 1107`, `lem-adjoint.tex:166, 472`; (d) $\mathbf B$/$\mathcal B_{\rm sym}$.
**(c) is new and is what the stated rule cannot survive.** Glossary:167 disambiguates by *"$\mathcal B$ never carries a subscript"* — but $\mathcal B(\mathcal X)$ carries an *argument*, grammatically identical to $\mathcal B\Xi$. Two glossary rows for bare $\mathcal B$ (167, 185); §8.2 records only the $\mathbf B$ pair. `proofs.tex:1459` must write *"with $\mathcal B$ the operator of `cor:rangegap`"* — the file conceding context does not disambiguate.

**T1-2. $\psi$ — RESERVED (four times), and reused.** Glossary:155 *"$\psi$ … RESERVED: the draft's $\psi$ … is renamed $\ell$."* Violated: moment function `proofs.tex:1014–1015, 1023, 1042–1043, 1253, 1300`, `results.tex:877, 1075, 1113, 1118`; **and Laplace transform** $\psi(t):=E[\varepsilon e^{t'\Phi(V)}]$ at `proofs.tex:446, 452, 461–466`, `lem-bierens.tex:60, 65, 70, 77`.

**T1-3. $D$ — declared retired, and reused.** Glossary:32 (C2): *"Plain $D$ is retired and may not be reused."* Part F reuses it as the $L$-direction: `results.tex:1073, 1084–1091, 1111–1113`; `proofs.tex:1307, 1333, 1338, 1352, 1362, 1374, 1378`. Plain $D$ is in no glossary table.

**T1-4. $\varsigma$ — declared local "with no meaning across results", then made BINDING.** `assumptions.tex:26` and glossary §1.5 declare it a reserved local bound variable; `assumptions.tex:625`, glossary:63, §8.4 item 2 and `proofs.tex:1286` make it the $\IR^p$ direction **"BINDING ON STEP 4."** Third meaning alongside the Taylor integration variable in `prp:frechet` Step 2.

**T1-5. $m$ — LF iteration counter vs the moment function $m(\tau)$.** `results.tex:1075`, `proofs.tex:1300–1305, 1319–1339, 1387–1392, 1409–1429`. **Aggravating: glossary C7 retired the shorthand $m:=M/\pi$ for exactly this reason** — *"it collided with the iteration index $m$"* — and Part F introduced a second one.

**T1-6. $\ell_\dagger$ (bare) — two referents, one retired.** §8.5 makes the $\Pi$ superscript mandatory *"without exception"*. Surviving bare sites: glossary:63 (binding voice, pre-rename referent) and `results.tex:1052–1053` where $\ell_\dagger:=\mathcal W\ell^\Pi_\dagger$ is a **different** object with no glossary row. The R2-11 fix landed at glossary 34 and 151–153 and missed 63.

**T2-7. $\mathcal C_0$ — kernel support interval vs admissible weight class (NEW).** `assumptions.tex:1014–1015` (compact interval in $\IR$, C3) vs `results.tex:885–886` (a **linear space of $\IR^p$-valued functions**, `cor:udep`(c)). **The glossary carries both and notices neither** — line 55 fixes it as the support interval, line 171 as the admissible class. Both rows internally impeccable; jointly a collision.

**T2-8. $r$ — Hölder smoothness of $\varrho$ vs perturbation direction.** They co-occur in one sentence: `proofs.tex:1379–1383` uses $r$ as the direction and closes *"$O_P(\delta_n\epsilon_n)$ and $O_P(\delta_n r_n)$"* where $r_n=n^{-r/(2r+d_Z)}$ is built from the *other* $r$. **The project already knows: `assumptions.tex:781` writes the identical derivative using `rdir`.** Two competing conventions across two files.

**T2-9. $\tau$ — discrepancy constant $\ge1$ (A7) vs perturbation parameter**, used bare at `proofs.tex:1334–1335, 1344–1345`, plus $\bar\tau$ at 1368.

**T2-10. $\zeta$ — glossary row is the defect.** Glossary:156 declares bare $\zeta$ = the nuisance triple, rationale C8 *"$\zeta$ is free."* It was not. **Every bare $\zeta$ in the audited files is a generic function** — element of $\mathcal V$ (`results.tex:205`; `proofs.tex:344–345, 776–779, 1488–1495`), the (P7a) inner function (`proofs.tex:113–115, 848`), and $\zeta_K$ (`proofs.tex:1508`). The triple only ever appears subscripted.

**T2-11. $\Gamma$ vs $\gamma$** — two finite signed measures separated only by case; $\Gamma$ in no glossary table and no §1.6 near-collision row, though §1.6 records every comparable pair.

## Verification of the five handed-off findings

| # | Verdict |
|---|---|
| 1 | **CONFIRMED and worse** — four-way, not two. Scope correction: `cor:rangegap` is Part E. |
| 2 | **CONFIRMED, three wrong sites not one** — `notation_glossary.md:52` (a binding *resolution* row, present voice) and `theory_memo.md:48` are both NEW, alongside the handed-off `:183`. Correct at glossary 185–186, §8.4, `results.tex:1061`, `proofs.tex:1284`, `assumptions.tex:616`, `theory_memo.md:23`. |
| 3 | **CONFIRMED, four $\varsigma$-free sites against two correct** — `proofs.tex:1289` (handed off), plus glossary:186, `assumptions.tex:613, 621`, `theory_memo.md:23`, all NEW. `assumptions.tex:621` is self-refuting: `:624–625` then says *"'the constant' presupposes a direction $\varsigma$."* And `proofs.tex:1286` states the requirement three lines before omitting it. |
| 4 | **CONFIRMED.** Header claims NINE, lists eight; file holds 8 numbered + 2 remarks = 10. Part E carries **13** environments; `lem-adjoint.tex` renders 10, `rem-nophifree.tex` the other 3 — **the partition is sound, only the count word is wrong.** |
| 5 | **CONFIRMED.** $\mathcal S$ defined `results.tex:1056`, sole consumer `proofs.tex:1256`. One-site symbol; whether it earns one is the theorist's call. |

## Undefined on first use

- **$L_\star$ — never defined anywhere.** Not in the glossary, `results.tex`, or `assumptions.tex`. First appears `results.tex:1074`; consumed by A5(iv), the glossary's own $\epsilon_n$ row, `prp:orthog`(ii)–(iii), and throughout Part F. Nearest thing to a definition is an incidental *"since $\ell_\star=\partial_uL_\star$"* at `proofs.tex:1323`, inside a proof step ~250 lines after first use.
- **$\hat\nu_g$** — first appears at `results.tex:1135` **inside a hypothesis** with no construction given.
- **$\zeta_\star`** (`results.tex:1113`), **$P^{\rm Leb}_{L_x}$** (glossed one line *after* use), and `rem-nophifree.tex:101`'s "admissible" — **R2-4 was recorded fixed but the fix landed only in `results.tex`; re-opened in the paper rendering.**

## Typing inconsistencies

- **`eq:gproviso` carries two different formulas under one label key:** third clause is $E|g\Delta U(\theta,0)|<\infty$ at `results.tex:861` but $E|g\Delta U(\theta,\varphi)|<\infty$ *for every* $\varphi$ at `rem-nophifree.tex:37`. `proofs.tex:959` relies on the narrower form — **the paper rendering silently strengthens a proviso the source proof prices as weaker.**
- **Contradictory reading instructions for A3:** `assumptions.tex:1215` says A2′(i)–(ii), A3 and N1 are read **coordinatewise**; glossary §8.4 item 3 says A3's $J$ is $p\times p$ **only under the vector reading**. $E[\widetilde W\ell_\star\Delta Z']$ is $p\times p$ only if $\ell_\star$ is a genuine $p\times1$ vector; coordinatewise returns $p$ scalars and $J$ is ill-formed.
- $\mathcal W$ typed with scalar codomain at `results.tex:731` and glossary:154, while $\ell_\star:=\mathcal W\ell^\Pi_\star$ is typed $\IR^p$-valued at glossary:153.
- Two expectation conventions in one `\input` directory ($\mathbb E$ in `dummy.tex` vs bare $E$ everywhere else).

## Observations (not scored)

1. **`preamble.tex` does not exist.** All four theorem files declare requiring `\IR`, `\un`, `\upmodels`, `\vdagger` from it; `\newtheorem` appears in **no** file under `paper/`. Every `\begin{remark}`, `\begin{lemma}`, `\begin{assumption}` and `\IR` is undefined at document level. Build-infrastructure gap, not a symbol one — **and it is why the "are remarks numbered?" question has had no answer.**
2. $\sigma_q$ and $\mathcal K$ are used at `results.tex:1058` and defined at `:1079–1080`, with an explicit forward `\cref`. Legal, but `lem:solset` prints before `lem:secondord`.
3. **`dummy.tex` reuses tags A1–A2** against a different project's block, inside a declared-stable tag namespace.
4. A2′(ii) writes $E[\widetilde W^2\ell_\star^2]$ in scalar form for an $\IR^p$-valued $\ell_\star$ — covered by the change-log declaration at `assumptions.tex:1215`, but that is the same sentence that mis-states A3, so the cover is thin.

## Fix order (highest leverage first)

1. **`notation_glossary.md:52` and `:183`** — the two binding rows printing the refuted $\mathcal B_{\rm sym}$. One string each; the glossary is binding on every later `.tex`, so these stop the widest propagation.
2. **Bare $\mathcal B$** — three referents on one glyph. The line-167 rule must be **replaced, not patched**; $\mathcal B(\cdot)$ for Borel is idiomatic and unlikely to move, which forces the two operators to.
3. **$L_\star$** — a symbol carrying `prp:orthog`, `lem:secondord` and A5(iv) with no definition anywhere.
4. **Part F's four reservation breaches at once** — $D$, $m$, $r$, $\tau$. All four introduced in a single statement, `results.tex:1073–1075`, all four colliding with symbols reserved or retired earlier.
5. The four remaining $\varsigma$-free norm sites, and the `lem-adjoint.tex:36` / `theory_memo.md:28` count.

---

# Notation audit — 2026-08-27, notation-warden. **29/100**

Measured against the compile order in `scripts/build-theory/driver.tex:55–69`, not the
alphabet. The four retired mirrors (`results.tex`, `assumptions.tex`, `results_main.tex`,
`working_notes.tex`) were excluded from every count.

## Collisions (−30)

**COL-1 · italic $I$ carries three types, two of them inside statements (−15).**
Identity operator (`results_supp.tex:1704` in `lem:balance`'s *statement*; `proofs.tex:4173,
4176, 4918–5112`); a closed interval $I\in\mathfrak I$ (C3's *statement*,
`assumptions_main.tex:3866–3911`; `def:intker` at `:3399–3406`; `lem:bdryfam`'s statement,
`results_supp.tex:2402–2427`); and a function $x\mapsto I(x)$ (`results_supp.tex:2777, 2871`;
`proofs.tex:6454`). Nothing separates them — no font, no subscript, no argument convention.
**The glossary asserts the opposite as a closed rule** at `notation_glossary.md:934`: "Italic
$I$ appears *only* as $I-P_{\mathcal V}$ and $I-P_{L_x}$." False at every interval site.

**COL-2 · bare $\varepsilon$ carries five live objects across 91 compiled lines, undeclared (−15).**
Census by file: AM 0 / S2 2 / S3 0 / S4 0 / AS 9 / S3S 1 / RS 17 / P 62. The readings: the LF
stage error (`proofs.tex:8836, 9049–9273`) — which §1.7 declares *subscripted*, as
$\varepsilon_k$, with the subscript doing the separating work, **printed here without its
recursion index while the recursion in $k$ is running**, and at `:9170` standing beside its own
declared partner ($\varepsilon\le\hat\varepsilon_{k-1}$); a generic integrable r.v. bound by
"let" in `lem:bierenscore`'s statement; a generic positive tolerance; a generic rate slack; and
a perturbation size / cell-probability value. The $\varepsilon$ family is the corpus's largest
constant family — seven subscripted members — and every declared separator *is* the subscript.

## Undefined on first use (−35)

- **UND-1 (−5) · O-16(a) and O-16(b) are carried as named hypotheses and defined nowhere.**
  `results_s4_asymptotics.tex:58` (a proposition *title*), `:96–103`; consumed at
  `results_supp.tex:2261–5743` and `proofs.tex:6091–6122`. **The split lost the only definition
  the corpus had:** the retired mirror printed it as an em-dash apposition — "O-16(a) — there
  exists $h\in\mathcal V$ with $\vartheta'E[q(\Delta h)^2]\ne0$ — the constant …" — and the
  compiled split at `:96` replaced the dashes with a comma, turning a definition into a
  comma-chain of consequences. This is a regression introduced by the split itself.
- **UND-2 (−5) · $\varepsilon_\Omega$**, bound inside `eq:omegafloor` (a numbered display inside
  A4(i)) and read three results away; no glossary row. Nine lines, four files.
- **UND-3 (−5) · the interval-index family is undeclared while its superseded scalar predecessor
  is still declared BINDING.** $\mathfrak I, I, \Theta_I, \bar\Theta, \mathsf C_{h_u}(v;I),
  I(x^\ast), I_{ij}, I^\ast, \mathsf G(I), \underline g$ have no glossary row. Meanwhile the
  glossary declares the **scalar** boundary index $s_0\in[0,1]$ BINDING with a defining display
  at `:888, 953, 956, 869` — and **non-comment `s_0` returns zero lines in all eight compiled
  files.** The symbol's *arity changed*, scalar → interval; the corpus took the change and the
  register still declares the old type.
- **UND-4 (−5) · bare $\beta$** — declared with two readings at `:856–860`; four are live
  (bandwidth exponent ✔, Hölder exponent, rate-gap exponent with a printed value $0.012$, and a
  foreign paper's source index). Readings 1 and 2 sit in a consumer/consumed pair.
- **UND-5 (−5) · bare $\gamma$** — B1(v) makes it a finite signed measure on $\mathcal T$;
  `rem:localise`(7) rebinds it as a scalar density-tilt parameter (`results_s2:1131–1165`).
  §1.7's row does not list `rem:localise` among its homes. C25 forbids promoting a local to
  binding; this is the reverse, which is sharper.
- **UND-6 (−5) · the prime carries two readings on the stem $\varpi$.** $\varpi_u'$ is a
  derivative (B1(iv.a)); $\varpi'_{\mathsf w}$ is a second measure's masses
  (`assumptions_supp.tex:843, 845`). §1.7 states the prime is "the corpus's ordinary mark for a
  second object of the same type."
- **UND-7 (−5) · bare italic $c$** without an argument (`results_supp.tex:366, 376–377`, two
  distinct objects in one remark), and an *argumented* $c$ that is not `cor:udep`'s slope
  (`assumptions_main.tex:442`), against §1.7's closure claim at `:962`.

## Typography (−6)

- **TYP-1 (−2) · bare italic $M$ is live** at `proofs.tex:6451–6452` (`lem:bdryfam` Step 7),
  **fifty-three lines before the same file's comment** at `:6504` reading "Bare italic M is
  retired by C7." The one surviving compiled use; italic $M_n$ is confirmed gone.
- **TYP-2 (−2) · `2\pi` means two things and the declared separator misclassifies the site.**
  `results_supp.tex:6256` prints $f_{X_1}+f_{X_2}=2\pi$ — twice the *design density* — in a file
  with four `2\pi`-is-Archimedes sites. §1.7's separator ("the $\pi$ carrying an argument or
  sitting under $d\pi$") classifies it as Archimedes and is wrong.
- **TYP-4 (−2) ·** three register/corpus disagreements: §3 still defines $\pi$ as "stationary
  density … otherwise a convex combination", superseded by `def:spaces` and by C109 written the
  same day; three incompatible claims about $K$ at `:1143, 1156, 902`; and $R_n$, $\mathcal T_n$
  declared but returning zero compiled sites.

## The two handed-over findings

1. **$\varepsilon_\Omega$ — CONFIRMED**, with a correction: C109's printed site list gives
   `results_supp.tex:5229, 5231`; the live sites are **`:5241, 5243`**. The register is twelve
   lines stale on its own measurement.
2. **Bare $\pi$ — fact confirmed, finding as framed REFUTED.** The theorist proposed "a §1.7 row
   declaring the two readings and their separator." **That row already exists**, at `:944`, dated
   *Swept 2026-08-14* — a repair proposed twelve days after it was executed, without checking.
   Both prior counts are also wrong: the Archimedes reading is live at **23 lines** across four
   files, against the theorist's 6 (self-flagged as a floor) and the glossary's 14; the
   Gaussian-kernel block at `proofs.tex:6330–7173` postdates the 2026-08-14 sweep and is the gap.
   The repair owed is **an amendment to the existing separator plus one site**, not a new row.

## Verified clean

$\hat\pi$ and $\varepsilon_\pi$ (C109) re-verified against the eight compiled files only — no
prior claimant, both clean. $\varpi$ has no bare occurrences. $\mathsf N$ has one reading.
**The C5$'$(iii)/(iv) rename took everywhere**; the old wording survives only in a retired
mirror. A0, A4(i) and A1d re-spellings are consistent across files, and `cor:a1cprim` is absent
from every compiled file. Expectation/probability typography is uniform, bold is reserved
consistently, and the sans-serif family is used as the declared separator throughout.

## Fastest path off 29

**COL-1 and UND-3 are one repair (−20):** the boundary index's move from scalar $s_0$ to
interval $I$ is complete in the corpus and unrecorded in the register, and the glyph it landed
on was already the identity. **Rename the interval index** — the identity operator cannot move,
it is universal notation — and four stale glossary rows retire with it.
**COL-2 (−15):** restore the recursion index on `prp:phirate`'s $\varepsilon$ (eleven lines, one
proof), then a §1.7 row for the remaining generic uses on the model of the declared bare-$\mathsf c$
convention. **UND-1 (−5):** one sentence — state O-16's two clauses once, as a display.

---

# Notation re-audit — 2026-08-27 (second pass). **81/100 — CLEARS THE GATE**

Up from 29/100. **Collisions: none. Undefined-on-first-use: none.** All seven prior UND findings
closed and re-measured rather than inherited.

**`\mathrm{Id}` migration verified complete at 24/24, checked five ways** — `I-P_{L_x}`/`I-P_{\mathcal V}`;
`-I`/`I-` adjacent to `\mathcal`, `\hat`, `\mathsf`, `P_`; scalar-times-`I`; `\preceq`/`\succeq`…`I`;
and a full word-boundary census of `proofs.tex` (153 hits) and `results_supp.tex`. **Every surviving
bare identity `I` is in a retired mirror or `archive/`.** Also re-verified: `\varepsilon_{k-1}` at
exactly 13 lines with `:9411` and `:9552` now agreeing; γ's three-reading census complete line-for-line
across all 58 lines; β's four readings reproduced exactly; `\varpi` exact at 10/10; `s_0` at zero.

## −19: the repairs' own closure claims

**The dispatch predicted "a replacement that is itself short by one". It occurred four times, and
once by two.**

- **(−5) The amended bare-π separator is false at two sites four lines apart in one paragraph.**
  `results_supp.tex:2171` (`∫(1+ξ²)^{-1}dξ = π`, a **bare** Archimedes π matching none of the five
  declared shapes) and `:2175` (`= π/2`, Archimedes, but **not** `c_Φ`'s value, so that escape does
  not reach it). Applied as written the rule assigns the pooled design density to both — the same
  defect the row was rewritten to cure, one file from the counterexample the row itself exhibits.
- **(−2) The recount is short by two: 26, not 24.** The pattern set cannot see `\tfrac\pi2` or a bare
  `=\pi`. **The sequence on this one glyph is now 6 → 14 → 23 → 24 → 26.**
- **(−2) C111's identity census carries its own false closure claim, at 6 of its own 24 lines** — and
  it omitted `\mathcal O - I` and `\gamma^{4\mu}I`, **the very shapes the hand-off note named as
  previously missed.**
- **(−2) "Upright `\mathrm i` occurs only inside a complex exponential" is false** at `proofs.tex:5589,
  7330, 7332` (multiplier, not exponent) and outside `lem:reprsmooth` entirely at six further sites.
- **(−2) The italic-`c` row is short by one reading** — the linear-independence coefficient vector.
- **(−2) C112's ε residue census prints AS 8; the measurement is 9.** Family total 78, not ~77.
- **(−2) Every `proofs.tex` address printed by C111/C112 is stale** — censuses taken before the round's
  own edits and never re-resolved (identity off by 7–9, π by 9 then 28, β by 28 and 41). **The counts
  are right and were verified; the addresses resolve to other text.** Other files' addresses are
  current, which makes this a partial re-measure rather than a missing one.
- **(−2) "`R_n` and `\mathcal T_n` return zero compiled sites" is false of `\mathcal T_n`**, printed at
  `assumptions_supp.tex:500, 501, 516, 517`. The house "N lines, k uses, m mentions" convention
  (C99, C114) was not applied.

## Adjudication of the reversal and the refutation

**COL-1 — overruled, accepted without reservation, and the warden went further than required.** It
reproduced both censuses independently (identity 24, interval ~120), confirmed its own list was short
by ten, and stated that **its ground was worse than its count: "the identity operator cannot move; it
is universal notation" is false as stated** — Conway, Lang and Bourbaki-descended texts write
`Id`/`id`. It also recorded that it never checked the target-glyph space before recommending a rename,
and that the digit-1 elimination is real.

**UND-3 — refuted, accepted.** The interval family did carry §5 rows from dispatch 26. The corrected
diagnosis is worse than the original: **a register that declares a symbol and then guards it with a
false rule needs the rule replaced, not a row added.** The half that stands: four `s_0` rows declared
a superseded scalar BINDING at zero live sites.

## One call still disputed, on internal-consistency grounds

**Italic `c`.** Its replacement rule is a *property* ("bound by the clause it appears in, in every
reading") — which is precisely what the π row, **written in the same round**, rejects: *"The separator
is now a closed list of five shapes rather than a property, because a property is what failed."* A
property cannot be checked by grep, and its census is short by a reading.

## Highest-leverage remaining repairs
(1) `results_supp.tex:2171, 2175` and the rule that misreads them; (2) re-resolve the `proofs.tex`
addresses in C111/C112 against the shipped files; (3) the `\mathrm i` clause in both rows; (4) the
identity shape-list and the italic-`c` count word.
