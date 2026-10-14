<!-- Persisted by the orchestrator 2026-07-30 on receipt. Full re-sweep after the
     Part-H merge, four fix dispatches, Part I, and A3's retirement. The previous
     full sweep was usage-matrix_round8.md. Body verbatim; orchestrator
     verification appended at the foot. -->

# Assumption-Usage Audit — `panel-npiv-discrete`, full re-sweep

**Score: 58/100.** Post Part-H merge, Part I, A3 retirement.

## Headline findings

**UNUSED — B1(vi) (−10).** `assumptions.tex:340–342` introduces a finite growing family $\mathcal T_n\subset\mathcal T$ with $\#\mathcal T_n\to\infty$. **One occurrence corpus-wide: its own definition.** No result consumes it and the estimator does not use it — `def:hatT` integrates against $\Pi_t$ over all of $\mathcal T$. Identification of $\vdagger$ is A1b(iii), assumed outright. B1(vi) is a leftover from a growing-finite-grid design the block does not implement.

**UNUSED AND NOW PROVABLE — A2′(ii).** Provable from A2′(i) **in full** + B1(i),(ii),(iv.a) + **(P1)**. On the precedent the block has just set with A3 — *a proved clause is retired in place* — **A2′(ii) is a retirement candidate, not a retention candidate.**

**OVER-STRONG — `lem:nusigma`(i) (−5), and this DISSOLVES carried limitation N7.** Stated "for every $h\in\mathcal V$" (`results.tex:715`); the proof is one line using $(a-b)^2\le2a^2+2b^2$ and C1(ii) and **does not use $\int h\,d\pi=0$**. The bound holds for every $h\in L^2(\mathcal X,\pi)$.
Two consequences the N7 record does not carry: **the gap is three lemmas, not one** (`lem:prelimtheta`, `lem:epterm` Step 3, `lem:sandwich` Step 3/6′ all make the same appeal and none lists A1b(i)); and **the fix is a weakening, not an addition** — restate the quantifier and all three need A1b(i) *not at all*. Clause (ii) genuinely needs $h\in\mathcal V$; only (i) moves.

**FALSE USAGE CLAIM — A1b(i)'s "binding" consumer list is short by `lem:biasexp` (−10).** The clause declares its list *binding on every citation*; `lem:biasexp` lists and correctly cites A1b(i). **The citation is right and the list is wrong** — so a reader following the instruction would strike a correct citation. The deletion-inviting direction.

**CONTRADICTORY — A4's comment (d) (−7).** It asserts A2′(ii) "is the clause the second-order and bias terms consume", while `results.tex` states three times that it is consumed by no part of the relevant lemma, and `assumptions.tex:2656` — **the same file** — says it is consumed by none of them. The *retention* ground (a forward Step-8 need) is legitimate; the *stated* ground is false.

**REGISTER (capped −10, one species, five instances).** **(R-d) does not exist anywhere in the corpus** — `thm:rootn`'s hypotheses run (R-a),(R-b),(R-c),(R-e), an undeclared skip, in contrast with (P-b), retained as an explicit struck placeholder so a stale citation lands somewhere. `def:crossfit`(d) enumerates "the three clauses of A5 that price an estimated nuisance" but **A5(vi′) is a fourth**, consumed at $\mathsf F$ fold complements. A1c's comment names four "consumers" that are **mentions, not hypotheses**. `theory_memo.md:2155–2157`'s no-consumer list is **stale on eight tags**. (P8)'s "WHERE IT IS CONSUMED" list omits the two Part-I sites.

## The five verification requests, settled

1. **The three non-use claims.** **A5(v) VERIFIED** (grepped four citation forms plus `\hat m`, its only object). **A1b(ii) VERIFIED for Part I**, including the hidden-need direction — Part I cites `lem:nusigma` at (i),(iii),(iv), never (ii). **A2′(ii) VERIFIED and the corrected attribution is right** — the ground is `cor:elldiff`, stated at A2b, so it needs A2′(i.a) **and** (i.b) plus B1(i),(ii),(iv.a), not (i.a) alone. Two riders: the implication also uses **(P1)**, named at one site and omitted from the two summary statements; and one live *descriptive* mention ("A2′(i)--(ii) … evaluate $\ell_\star$") in `results.tex` and its rendering would need amending on deletion.
2. **A3's retirement: COMPLETE and correctly propagated.** Every surviving occurrence is a retirement note or history. No hypothesis list carries it. The two rendering files agree substantively; they omit the `\ref{ass:rank}` pointer and the `lem:momzero`(iv) citation — declared rendering lag, not disagreement.
3. **(R-a)–(R-e) all consumed; the (R-b) deletion orphans nothing** — verified by grepping `b_\star` across Part I: five lines, all first or second moment. (Nit: the file says "two lines only, both at second moment"; it is five, one at first.)
4. **`lem:prelimtheta`(ii): DEFENSIBLE.** Not an unused hypothesis — A5(ii)'s second half is independently consumed at `thm:rootn` Steps 1, 2, 4(b). The weakness is presentational: three *local* negations a reader must aggregate. **Keep it; add one global sentence.**
5. **Fold indexing: the declaration is short by one clause** — A5(vi′), covered operationally by (T-5) but not by `eq:foldrates`, and the radius $\mathsf R$ must now serve all $\mathsf F$ paths at once. Derivable at no cost, but undeclared.

## Suggestions (no implementation prescribed)

Cut or attach **B1(vi)**; retire **A2′(ii)** in place on the A3 precedent, or replace its stated ground with the forward one; **weaken `lem:nusigma`(i)'s quantifier** — preferable to adding A1b(i) to three lists; fix **A1b(i)'s binding list** or drop the word "binding"; correct **A4 comment (d)**; point **(R-a)**'s duplicated sub-clauses at `def:crossfit`(c); declare or renumber **(R-d)**; extend **`def:crossfit`(d)** to A5(vi′); replace **A1c**'s comment; add one global sentence to **`lem:prelimtheta`(ii)**; sweep **`theory_memo.md`'s stale list** and **(P8)'s consumption list**.

---

## Orchestrator verification appended 2026-07-30

Three findings spot-checked, all confirmed. **B1(vi):** `\mathcal T_n` occurs exactly **twice**, `assumptions.tex:341` and `:342`, both inside its own statement; zero occurrences in `results.tex` or `proofs.tex`. **(R-d):** **zero occurrences** across the theory files and the renderings — the undeclared skip is real. **`lem:nusigma`(i):** confirmed stated "for every $h\in\mathcal V$" at `results.tex:715`.

The `lem:nusigma`(i) finding is the most valuable in the report and supersedes a carried limitation: the theorist-critic's N7 proposed *adding* A1b(i) to a hypothesis list, and the auditor shows the same defect exists at **three** lemmas and is better fixed by **weakening a quantifier once**, after which none of the three needs the tag at all.
