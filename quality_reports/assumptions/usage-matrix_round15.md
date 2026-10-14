# Assumption-Usage Audit — `panel-npiv-discrete`, round 15 (full re-sweep after dispatches 15–17)

**Date:** 2026-07-31
**Score: 35/100** (was 46 in round 14, 58 in round 13)

> **Persistence note.** The assumption-auditor is read-only (`agents.md` §2). This is the orchestrator's transcription. Sections marked **[ORCHESTRATOR VERIFICATION]** were re-run against the corpus after the critic reported.

---

## Read the direction before the number

Of the three substantive findings dispatched to the theorist, **two closed cleanly and one was never dispatched. Dispatches 15–17 introduced no defect the auditor can find.**

The score falls because **the auditor's own prior sweeps had a blind spot**: they audited tags and clauses and never audited the **retention notes** — the sentences the assumption block uses to justify keeping a clause no proof consumes. There is one such note per unconsumed clause. **The first one checked is false.** This is a coverage widening, not a regression in the artifact.

**Corpus correction.** The 87-result inventory is `results.tex` only and predates dispatch 17. `proofs.tex` now carries **21** numbered environments, **17 created by dispatch 17** at `proofs.tex:386–997`. The corpus is **108** numbered environments. The 17 new ones were audited as first-class results; one finding (N-6) comes from them.

---

## The headline: C1(i)'s retention note names a consumer that does not consume it (−15)

**NEW, pre-existing since round 7, missed by every prior sweep.**

**[ORCHESTRATOR VERIFICATION — confirmed exactly.]**

```
C1(i) occurrences, corpus-wide, all citation forms:
  assumptions.tex:2229   the retention note itself
  proofs.tex:4226        inside lem:aerr
  proofs.tex:4230        inside lem:aerr
→ exactly TWO uses, both in one lemma.

results.tex:2914        lem:aerr: "Consumers: none."
prp:phirate proof (proofs.tex:4963–5601): cites C1 at 0 lines.
```

The chain:

- `assumptions.tex:2230–2233` states: *"C1(i) HAS NO CONSUMER BEFORE STEP 6 … it is consumed by `prp:phirate` (Step 6) together with C3 and C5′. It is retained, and **this note is the forward reference that keeps the usage matrix honest.**"*
- `prp:phirate`'s proof cites C1 at **no line at all**, neither clause. Nor does `lem:unifop`'s hypothesis list carry C1, nor `lem:opnoise`'s.
- C1(i)'s only two uses are inside `lem:aerr`, which opens (`results.tex:2914–2917`): *"**Consumers: none.** … **the assumption-auditor should read it that way** … it is the price-tag on the route Step 0 of `prp:phirate` **declines**."*

**So the retention note names as C1(i)'s consumer the one result the file elsewhere says declines the route on which the clause is used.** This is the defect species this corpus keeps producing — a claim about the artifact that the artifact contradicts — sitting inside the sentence written to prevent exactly it.

**The fix that matters is not C1(i).** It is auditing the *other* retention notes for the same defect. Three exist (A5(v)'s, C1(i)'s, B1(vi)'s); one of three is false.

---

## Findings

### Unused

**Part VI carries four clauses with no live consumer (−10, charged as one species).**

**[ORCHESTRATOR VERIFICATION]** `C5′(iii)`: **0** citations corpus-wide. `C5′(iv)`: **0**. `\kappa_n`/`\ell_n` outside C4′'s own statement: **0**.

| Clause | State |
|---|---|
| C4′ | $\kappa_n$, $\ell_n$ confined to `assumptions.tex:2405–2408` and its own comment. The two other mentions (`assumptions.tex:804`, `results.tex:2014`) read "the same *species* of restriction as C4′'s" — descriptive, not consumers. On three seen-and-left lists — a mitigation, not a fix. |
| C5′(ii) | Only citation is inside the consumer-less `lem:aerr` (`proofs.tex:4300–4302`). |
| C5′(iii) | Zero citations. Restates A4(iii) + A5(iii). |
| C5′(iv) | Zero citations. A scope declaration. |

**Unlike C1(i) and A5(v), none of the three C5′ clauses carries a status sentence anywhere.**

**A5(v) — unused and correctly declared. NOT CHARGED.** `results.tex:5170` and `rem:rootnscope`(4) both state it plainly. This is the pattern the others should follow.

### Over-strong

**A1b(iv) is carried idle by four results (−8). NEW.** Cited at 30 lines of `proofs.tex`; **none falls inside** `lem:opnoise` (4103–4186), `lem:aerr` (4188–4310), `lem:unifop` (4566–4711) or `prp:phirate` (4963–5601) — all four of which list it, and `prp:stopfeas` inherits it via "the hypotheses of `lem:opnoise`". The block's own B1(i) comment explains why it is idle: boundedness of $\Phi$ makes $w$ integrable *"with **NO** moment condition whatsoever on $\Delta Z$"* (`assumptions.tex:421–424`).

**`lem:opnoise` cites C2′ in full and uses only C2′(ii) (−5). NEW.** Within 4103–4186, C2′ is cited once, at `:4149`, as C2′(ii). C2′(i) is idle and unneeded: (ii) is assumed directly, so its sufficient primitive is redundant there. The block declares the discipline in terms — *"cite the clause, not the assumption"* (`assumptions.tex:1980`) — and applies it to A8 inside `prp:phirate`'s own hypothesis line. The same line then block-cites B1, C1, C2′, C5′.

### Unstated

**A1b(i)'s binding consumer list is short by `thm:rootn` (−8). NEW — the dispatch-14 defect one level up.** The clause (`assumptions.tex:104–123`) declares its list *"binding on every citation of this clause"* and omits `thm:rootn`, which carries A1b(i) in group (T-1) (`results.tex:4863`) with `rem:rootnhyp` explaining the use in terms (`results.tex:5246–5247`). **A reader obeying the instruction would strike a correct citation on the paper's only theorem** — the deletion-inviting direction. The dispatch-14 repair was run site-by-site, not list-by-list, which is why this survived.

**`lem:pnuid` (P5) states no assumption tag (−2). NEW, from dispatch-17 material.** `proofs.tex:489–490` uses Lebesgue densities; existence is supplied by `def:model` and C1(ii) but neither is cited, while every other result touching $\nu_g$ carries C1(ii). Minor — but (P5) is now a compiled lemma and a referee reads its hypothesis line.

### Retirement hygiene

| Retirement | Clause struck | No proof cites it | Nothing calls it live | Verdict |
|---|---|---|---|---|
| A3 (`ass:rank`) | ✓ | ✓ | ✓ | **COMPLETE** |
| A6 (`ass:tcc`) | ✓ | ✓ | ✓ (all occurrences are the refutation) | **COMPLETE** |
| A2′(ii) | ✓ | ✓ | ✓ | **COMPLETE** |
| **B1(vi)** | ✓ | ✓ | **✗ — 3 compiled sites** | **INCOMPLETE** |

B1(vi)'s three compiled sites: `assumptions.tex:2565`, `results.tex:533`, `paper/sections/theorems/lem-bierens.tex:284`. Plus non-compiled `assumptions.tex:538–541` and two glossary rows. **[ORCHESTRATOR VERIFICATION]** 8 occurrences total across `.tex` files, consistent with the split reported.

Two register items in the same species: `prp:phirate`'s hypothesis line names **B1 in full** (`results.tex:3537`), so a live hypothesis list on the flagship rate proposition carries a clause the block declares *"not maintained, is not available for use"*; and the contract header (`assumptions.tex:11–22`) still reads **"THE TWO RETIREMENTS"** where there are four. Capped as one species: **−10**.

### Prior findings, disposition

| Prior | Verdict |
|---|---|
| **F-3** — freezing lemma's hypothesis supplied at Part I, used at Part H; ninth undeclared consumer; false (c′) claim | **CLOSED.** `lem:pfreeze` states `eq:freezecomp` on the composite; `rem:pfreezesites` enumerates **nine** sites and answers the hypothesis **per site**. A4(iii) now carries joint measurability; the false rider is struck. |
| **F-4** — `def:crossfit`(c) and (c′.2) contradict each other | **CLOSED.** `results.tex:4336–4342` now states (R-a)'s differentiability is used by exactly one clause, and that a reader following (c′.2) alone would wrongly conclude the sup-norm convention is unconditional. |
| **F-1** — C4′ redundant | **STILL OPEN** (see above) |
| **F-5** — `lem:opnoise` reads C5′(i) at the retired bandwidth | **STILL OPEN.** Two lines unmoved, `proofs.tex:4154–4155` and `:4183–4184`. **The correct reading already exists 130 lines below at `proofs.tex:4315`** and in `results.tex:2896–2902`. |
| B1(vi) register, `prp:phirate` "B1", header "TWO RETIREMENTS" | **STILL OPEN** |
| Round-14 verified-closed set (A2′(ii) across nine sites; `lem:nusigma`(i); A1b(i)'s list; A4(d); (R-d); `def:crossfit`(d); `lem:momzero`(v)) | **RE-VERIFIED CLOSED.** A2′(ii)/A3/A6 grepped across both files: every occurrence is a retirement note, refutation apparatus, or history. No hypothesis list carries any of them. |

---

## Deduction table

| # | Finding | Class | Ded |
|---|---|---|---|
| N-1 | C1(i) — no live consumer; retention note names a false one | Unused + false usage claim | −15 |
| F-1+ | C4′, C5′(ii), C5′(iii), C5′(iv) — no live consumer, no status sentence | Unused (one species) | −10 |
| — | B1(vi) register: 3 compiled sites + `prp:phirate` "B1" + header "TWO RETIREMENTS" | Incomplete retirement (capped) | −10 |
| N-2 | A1b(iv) idle at 4 results | Over-strong | −8 |
| N-4 | A1b(i) binding list short by `thm:rootn` | False usage claim | −8 |
| F-5 | `lem:opnoise` reads C5′(i) at the retired bandwidth, twice | Stale ground | −7 |
| N-3 | `lem:opnoise` cites C2′ in full, uses (ii) only | Over-strong | −5 |
| N-6 | (P5) states no density tag | Unstated (minor) | −2 |
| | | **Total** | **−65 → 35/100** |

---

## Suggested fixes (minimal; no implementation prescribed)

1. **C1(i) first, in a round of its own** — the retention note is false and must be corrected before anything is decided about the clause. Either name the real consumer (`lem:aerr`, and then say what keeps `lem:aerr`) or retire C1(i) on the C4′/B1(vi) pattern. **The fix that matters is auditing the other retention notes for the same defect.**
2. **C4′, C5′(ii), C5′(iii), C5′(iv)** — decide as one species: retire, or give each a status sentence of the kind A5(v) carries.
3. **B1(vi)** — three compiled sites, located. CHECK 8 catches regressions but does not close these.
4. **A1b(iv)** — strike from the four proofs, or state where it is used.
5. **A1b(i)** — add `thm:rootn` to the binding list, or drop the word "binding". Prefer the first; the list's own transitivity convention already covers it.
6. **`prp:phirate`'s hypothesis line** — clause-cite B1, C1, C2′, C5′ as it already clause-cites A8. Closes the retired-clause citation and the C1 question at once.
7. **`lem:opnoise`** — two lines; the correct text already exists 130 lines below.
8. **(P5)** — one tag on the hypothesis line.

## Not verified

- Whether `lem:unifop` inherits C2′(ii) through `lem:opnoise`.
- Whether A1b(iv) is needed *implicitly* (rather than cited) in the four proofs that list it. The auditable fact measured is that it is not cited there.
