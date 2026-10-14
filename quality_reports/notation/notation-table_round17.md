# Notation Sweep — `panel-npiv-discrete`, round 7 (post-dispatch-21)

**Date:** 2026-08-01
**Score: 0/100** (floored; raw **−278**). Was 0 (raw −201), 0 (raw −123).

> Orchestrator transcription; the notation-warden is read-only. **[VERIFIED]** marks checks
> the orchestrator re-ran. **Counting convention:** `count` mode returns *lines-with-match*;
> `-o` returns *occurrences*. Every number is labelled.

## Headline

**No dispatch was scoped to notation, and the corpus grew ~17 pages. Every round-6 finding is
open. Three new collisions landed — all on letters a named resolution or a closed §1.7 rule had
already decided, and all in printed statements.**

The pattern is four rounds old and did not break: **the text that closes the previous findings
carries the next ones.** Round 5 fell to newly-compiled lines; round 6 to dispatch 20's
measurability paragraph; round 7 to A8's spline derivation, `lem:scaleinv`(vi), and `eq:h1match`.

**The previous dispatch's claim of "no new symbol" is FALSE.** Six glyphs entered printed text:
bare $d$, bare $\sigma$, bare $\tau$ (A8's derivation), bare italic $c$ (`lem:scaleinv`(vi)),
and bare $\mathsf c$ + $\varsigma$ promoted into H1's *statement*.

> **[ORCHESTRATOR — I got this wrong and it is on the record.]** I verified "0 `\newcommand`
> added" and reported that as confirming the claim. That checked the wrong thing: these entered
> as **bare letters in prose**, which no `\newcommand` check catches. Two verified directly:
> `assumptions.tex:2058` *"Write $d$ for the degree"*; `results.tex:3478`, `lem:scaleinv`(vi)'s
> statement, *"$c>0$ and replace $\Pi=\Pi_u\otimes\Pi_t$ by $\Pi_u\otimes(c\,\Pi_t)$"*.

| Class | Count | Each | Total |
|---|---|---|---|
| Collisions | 13 | −15 | −195 |
| Undeclared / local families (verified) | 7 | −5 | −35 |
| Undeclared (carried, **not** re-verified) | 5 | −5 | −25 |
| False claims in a binding file | 3 | −5 | −15 |
| Typography (verified) | 3 | −2 | −6 |
| Typography (carried, not re-verified) | 1 | −2 | −2 |
| **Raw** | | | **−278** → floored to **0** |

## Collisions, ranked

**COL-A. `\mathcal J`, two live meanings, both in statements. WORSE.** Round 6 measured reading
(b) at 7 lines in one paragraph and priced the fix at "one paragraph, no consumer outside it."
**It is now 18 lines**, having escaped in *both* directions — forward into `def:lfstep`'s opening
and into **`prp:phirate`(P-a.1)**, a hypothesis clause of a different result. Reading (a) is the
singular-system index in `prp:compact`'s statement. At one site it is $i\in\mathcal J$ (observation
index) against $j\in\mathcal J$ (singular-value index). `def:lfstep` carries an index warning three
lines away — about the **superscript $k$**, not about $\mathcal J$.

**COL-G. Bare italic $c$ — two live meanings, both in statements. NEW.** (a) `cor:udep`'s
affine-weight slope, bare in the corollary's own statement; (b) `lem:scaleinv`**(vi)**'s
reference-measure scale; (c) a third, $c(\tau)$, a limiting probability. **§1.6's own $\mathsf c$
row names "$c(z)$ in `cor:udep`" as the object to stay distinct from — the census was on record
before the claim.**

**COL-H. Bare $\tau$ — three readings, one breaking a resolution by name. NEW in part.**
(a) C23's **binding** Part-F perturbation $\tau=(\tau_1,\tau_2,\tau_3)$; (b) A7's discrepancy
constant written **bare** at five lines of `prp:stopfeas`'s *statement* and seven of its proof,
against §1.7's *"never appears without its word subscript"*; (c) **NEW:** Sobolev index in A8's
derivation.

**COL-I. Bare $\sigma$ against a closed four-way rule. NEW.** H1's replacement text ($X_\sigma$,
$H^\sigma$) and A8's derivation. §1.7's rule is closed — function subscript / integer subscript /
word subscript / capital — and **bare unsubscripted matches none**; $\sigma_q$ is separately
RESERVED.

**COL-B** bold $\mathbf M_n$ vs italic $M_n$ (letter carries five forms; §8.9's specified repair
would leave four live). **COL-C** $Z(\varphi)$ vs binding $Z,\Delta Z$, co-occurring in one proof.
**COL-D** $\varDelta$ vs $\Delta$, in `lem:intker`(ii)'s statement. **COL-E** $\varXi_n$ vs
$\Xi,\Xi'$. **COL-F** $\varTheta_k$ vs $\Theta_{s_0},\Theta_1$. **COL-1** $\Upsilon$ vs
$\varUpsilon$ (19 occ / 12 lines). **COL-2** $\varrho_{\mathrm B}$ vs **RESERVED** $\varrho$.
**COL-3 italic $N$ — five readings, three inside one proof, WORSE:** dispatch 21 gave
`lem:pfreeze`'s $N$ a parenthesised argument $N(\omega,\cdot)$ — the same shape as the covering
number $N(\epsilon_0)$ — so **the project's usual "arguments are the separator" device is now
unavailable on this letter.** **COL-4** italic $M_n$ vs C7's retirement.

## Undeclared (verified this round)

**UND-D. Bare $\mathsf c$** — a §1.6 local declared for **one named proof site**
(`prp:nophifree` Step 3), live at **39 lines** across three files, several in statements including
**H1's**. §1.6's own round-12 amendment names this exact trigger.
**UND-E. $\varsigma$ — a declared §1.6 *local* — used in maintained assumption H1's statement.**
§1.6: *"A local symbol may not be made binding; when one was, the binding use moved instead
(C25)."* The reading is semantically consistent; this is a scope violation.
**UND-F. Bare italic $d$** (spline degree), in the first file of compiled order beside the
differentials and the dimensions $d_Z,d_K$. **UND-G. $X_\sigma$** — italic capital $X$ as a
Hilbert-scale space, against the binding regressor.
**UND-A. The breve family** — $\breve\nu,\breve g$ at 14 lines; **grep for `breve` over the
glossary returns 0, re-verified.** A fifth accent, declared nowhere.
**UND-B.** The sans-serif numbered constant register: 17 live members, eleven declared nowhere,
on a global counter with no inventory. **UND-C.** $\mathcal V_n^{\circ}$ against C75's binding of
$\circ$ to the linearisation base point.

*Carried, charged, not independently re-verified:* UND-1…UND-5.

## False claims in a binding file — all NEW

**FBC-8.** §1.7: the discrepancy constant *"never appears without its word subscript"* — false at
twelve lines including a proposition statement.
**FBC-9.** §1.6's $N$ row describes *"the $\mathcal G$-measurable frozen nuisance ($N$, a random
element of a space of functions)"* — **a clause dispatch 20 struck from the artifact.** The
glossary was not updated when the clause was deleted.
**FBC-10.** `assumptions.tex` claims *"The constant is the §1.6 sans-serif slot and carries no
name of its own"* — §1.6's slot is scoped to one named proof site and has never covered a
maintained assumption's statement.

## Typography

**T-3** $\Psi$: no row separates $\Psi_{jk}$ from $\Psi^{(j)}_k$ — the closest pair on the letter —
and the $k$-less $\Psi^{(1)},\Psi^{(2)},\Psi^{(3)}$ has no row anywhere, while `results.tex` claims
*"the separation device §1.7 already uses"*, which §1.7 does not contain. **T-5** $L^{\,b}_\ell$
matches none of §1.7's closed three-way $L$ rule. **T-6 NEW.** (P7a) was rewritten to $\zeta(u,V)$
and cites `lem:adjoint` Step 3 as applying it — **but `lem:adjoint` still writes one argument.**
Licensed by the clause, so not substantive; the C44 species. **T-4** prime drift, carried.

## The variant-and-font census — round 6's self-diagnosed blind spot, now run

Round 6: *"I swept for the symbols named in my findings and never ran a font-and-variant census."*

**Variant Greek capitals** (`\var[A-Z][a-z]+`): `\varDelta` 10 occ/6 lines, `\varTheta` 4/3,
`\varUpsilon` 19/12, `\varXi` 9/8 — **all four live, none with a row.**
`\varSigma,\varGamma,\varLambda,\varPhi,\varPsi,\varOmega,\varPi` → **zero. The family is exactly
four**, confirming round 6's count and closing the blind spot.

**Fonts:** `\boldsymbol`, `\mathscr`, `\mathtt`, `\mathit`, `\pmb` → **zero**; no bold/non-bold
vector drift exists. **Zero raw `\mathbb`** — dispatch 18's unification holds, re-verified.

**Could not verify:** no symbol's introduction can be dated without a prior snapshot; "NEW" means
new relative to round 6, corroborated by the artifact's own dispatch-numbered prose. The
nine-reading superscript census and six-reading $\xi$ census were not re-run.

## §1.5g(i) dating convention — and the gap it leaves

The clause requires every slot sweep to state as of which dispatch it ran, and **the new text
honours it.** But **the failure mode has moved up one level**: `eq:h1match`, `lem:scaleinv`(vi)
and A8's derivation introduce bare $\mathsf c$, $\varsigma$-in-a-statement, $c$, $d$, $\sigma$,
$\tau$ and $X_\sigma$ **with no slot sweep at all** — neither dated nor undated. **§1.5g(i)
disciplines the sweeps that get written; nothing requires that a sweep be written when a letter is
claimed.** All three new collisions would have been caught by that rule.

## Round-6 disposition

**CLOSED: none.** No finding of round 6 was closed, incidentally or otherwise.
**NEW:** COL-G, COL-H, COL-I, UND-D, UND-E, UND-F, UND-G, FBC-8, FBC-9, FBC-10, T-6.
**NOT RE-REPORTED:** FBC-7 — the round-6 false finding (lines vs occurrences; C74 is correct).

## Distance to the gate — worse than round 6

Round 6 cleared the floor in three steps. It no longer does: `\mathcal J` grew from 7 lines to 18,
and three collisions were added.

| Step | Work | Raw | Score |
|---|---|---|---|
| 1 | **One §1.7 row for the variant-Greek-capital convention** — closes COL-D/E/F/1 at once | −218 | 0 |
| 2 | The three new bare letters — $c$, $\tau$, $\sigma$ | −173 | 0 |
| 3 | **`\mathcal J`** — rename reading (b), now 18 lines | −158 | 0 |
| 4 | $Z(\varphi)$, $\mathbf M_n$ | −128 | 0 |
| 5 | COL-3 ($N$), COL-4 ($M_n$), COL-2 ($\varrho_{\mathrm B}$) | −83 | **17 — floor cleared** |
| 6 | 12 undeclared, 3 false claims, 4 typography | −0 | 100 |

**The single highest-value change is not on this list: require a dated slot sweep at the point a
letter is claimed**, not only where a sweep is written. Every one of this round's three new
collisions would have been caught by it, and each was claimed against a census the glossary had
already recorded.
