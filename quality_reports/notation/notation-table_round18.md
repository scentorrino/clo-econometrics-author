# Notation Sweeps — `panel-npiv-discrete`, rounds 8 and 9

**Date:** 2026-08-01 · notation-warden (read-only) · orchestrator transcription.

> **PERSISTENCE FAILURE, ON THE RECORD.** The round-8 report was never written to disk. The
> warden discovered this in round 9 and had to **reconstruct round 8's disposition** from the
> change register, the compiled change-notes and the dispatch brief. This file carries round 9 in
> full and round 8 in summary. The orchestrator owns the failure.
>
> **COUNTING CONVENTION — round 7's report was WRONG about the harness.** It stated "`-o` returns
> occurrences." False: `count`+`-o` returns **lines-with-match**; occurrences must be read off
> `content`+`-o`. Round 9 labels every number. `A`=`assumptions.tex`, `R`=`results.tex`,
> `P`=`proofs.tex`; `archive/` excluded (not in `driver.tex`).

---

# ROUND 8 (post-dispatch-22) — summary

**Score 0/100, raw −232** (from −278). **Nine of thirteen collisions closed, three undeclared,
two false claims — the first movement in four rounds.** The defects moved from untouched text
into **the fix dispatch's own claims**: eight false-claim findings, every one *a sweep stated
correctly in form and run over the wrong scope.*

The three decisive ones, each a rule dispatch 22 wrote being broken by dispatch 22's artifact:

1. **The limit law was written out in the proof and left standing in the theorem.** `proofs.tex`
   printed, compiled, *"The limit law is written out and carries no symbol"* while `thm:rootn`'s
   own conclusion printed $N(0,J^{-1}\Sigma J^{-1\prime})$ and $N(0,1)$.
2. **The variant-capital rule failed condition (c) on its first member, attributed to the wrong
   proof.** $\varTheta_k$ sits in `prp:hatAprop`'s proof, not `prp:tccfails`'s; the upright
   partner is bound 110 lines above it in the same proof.
3. **§1.5g(iii)(a) — the clause binding the dispatch that writes it — was breached by that
   dispatch.** $s'$ was swept as the *command* `s'`; sans-serif $\mathsf s$ was live at 23 lines,
   two in lemma statements, with zero glossary rows.

Also: **FBC-16** — C83's withdrawal of §8.9's standing $\mathsf M_n$ repair rested entirely on
the claim that $\mathsf M$ lives in `lem:srctransfer`(ii), where it occurs **nowhere**. And the
**sans-serif family census had never been run**; running it produced four new collisions,
including $\mathsf V_n$ against italic $V_n$ — the exact configuration C83 charged for
$\mathbf M_n$ *and* declined to create for $\mathsf M_n$, live in the corpus throughout.

---

# ROUND 9 (post-dispatch-23) — full

**Score: 0/100** (floored; raw **−125**). Prior: −278, −232. **Raw improves by 107 — the largest
single-round movement in the series.**

## Headline

**The count-reproduction clause works, and it caught what reading could not have caught cheaply.**
Of **23 checkable per-file counts** printed by C90–C99, **21 reproduce exactly** — including four
non-obvious ones ($\mathsf a$ at 16 lines / **31 occurrences**; the `a_`-prefix sweep at A0/R2/P48;
$\mathsf s$ and $H^{s}$ **eight lines apart**; italic $M_n$ at **9 live lines**). Two fail, and both
were falsified by arithmetic in seconds.

**The failure has moved. For the first time in four rounds the new defects are not in the compiled
corpus — all five new false claims are in `notation_glossary.md`.** Every compiled `.tex` change
dispatch 23 claimed verifies TRUE.

**Nothing dispatch 23 closed was re-opened. That has not been true of any prior round.**

| Class | Count | Each | Total |
|---|---|---|---|
| Collisions (open, verified live) | 3 | −15 | −45 |
| Undeclared / local families | 7 | −5 | −35 |
| False claims in a binding file (**all 5 NEW**) | 5 | −5 | −25 |
| §1.5g(iii)(a) non-compliance *by the round that wrote it* | 3 | −2 | −6 |
| Typography | 7 | −2 | −14 |
| **Raw** | | | **−125** → floored to **0** |

## The two count failures — both are *completeness* claims

**FBC-13. C99's "the letter's full census" is not full.** Its pattern set (`\bM\b`, `M_n`,
`\mathsf M`, `\mathbf M`, `\mathcal M`) **cannot return `M_k`** — `\bM\b` fails on the word
boundary at `_`. The Doob martingale at `proofs.tex:4768` is live and uncounted:

```latex
$M_k:=E[F\mid\mathcal H_k]$, so $M_0=EF$, $M_N=F$, and $\Delta_k:=M_k-M_{k-1}$ is a martingale
```

**[ORCHESTRATOR VERIFIED]** on that line `\bM\b` → **0**, `M_k` → **2**. This is §1.5j(i)'s own
first sub-shape — *command against glyph family* — at the width of a subscript, committed in the
row that re-decides the letter.

**FBC-14. C92 and §1.7 print "exactly one line falls inside `prp:phirate`'s proof."** Measured:
**3 lines, 4 occurrences.** Substance survives (all four in one naming sentence, 0 uses), but the
count is wrong by two in a row whose stated purpose is that condition (c) "can be checked
**arithmetically**." The compiled text makes the same slip — *"the single line of it that names
$\Xi_\ast$ is this sentence"* — a sentence is not a line, which is (a.1)'s distinction one level up.

## The other three new false claims — all in the glossary

**FBC-11.** §1.6 still prints the clause C90 struck: *"the Gaussian $N(0,\Sigma)$ … is written out
at its single site."* C90 strikes it by name and §1.7 corrects it in place; §1.6 was not updated.
**The exact species C90 itself diagnoses** — a clause struck in one binding record, left standing in
another — and the third consecutive round in which this row is where a defect is findable.

**FBC-12.** §8.9 claims a correction §1.7 does not contain. `not absent` occurs at glossary 655,
728, 1318 and **nowhere in §1.7**. §8.9 also says $M_n$'s separations are "all of which §1.7
documents" — **§1.7 has no $M_n$ row at all.**

**FBC-15.** §1.5j(ii) contradicts itself five lines apart: the census "was run for … `V, T, A, a,
b, q, s, c, M, N`", then lists $\mathsf N$ among "letters known to be live and **not swept here**."
C90 did sweep it (A0/R0/P15, reproduced). One list is false.

## Collisions still open — 3

**COL-4. The letter $M$ — SIX live forms, third round handed on, and the census saying so is short.**
Bare italic $M$ (`results.tex:3458, 4127`, with bare $m,A,B$ beside it) · $M_n$ (9 lines) ·
**$M_k,M_0,M_N,M_{k-1}$** (`proofs.tex:4768`) · $\mathsf M_\epsilon$ (5 use-lines) · $\mathcal M$ ·
$\mathbf M$ (mentions). **$M_k$ against $M_n$ is the same letter, same font, both index-subscripted,
both random sequences in a probability argument, both in `proofs.tex`** — the configuration C83
charged for $\mathbf M_n/M_n$ and C93 charged for $\mathsf V_n/V_n$, here separated by nothing but
the subscript letter.

**COL-BK. $B$ and $K$ — five and three live forms, two in a *statement*.** $\mathsf B$/$\mathsf K$
at **33 lines**, including `lem:bdiff`(ii)'s statement, with **no row anywhere**. §1.7 governs
$\mathcal B$/$\mathbf B$/$\mathfrak B$ as a closed three-font rule. C12 **RESERVES** $\mathcal K$;
bare italic $K$ is live at 9 lines of `lem:pconv`'s proof — *and C99 quotes that very object*.
Inside the declared-deferred list, so open rather than a regression — but C95 and C97 gave rows to
$\mathsf b$ and $\mathsf s$ in the **same statement**, two lines above.

**COL-2. $\varrho_{\mathrm B}$ against RESERVED $\varrho$.** 2 lines. Carried since round 6;
untouched by any dispatch.

**Charges withdrawn:** COL-E ($\varXi_n$) and COL-1 ($\Upsilon/\varUpsilon$) — §1.7 now states
condition (c) in arithmetically checkable form and both surviving members pass on substance
(upright partner in naming clauses only, 0 uses). That is the documented-near-collision disposition
§1.7 exists for.

## Dispatch-23 verification — all seven claims TRUE

Limit law at **three** sites, `N(` one character too narrow, `prp:medianpart` a third site no round
had named — **TRUE, all parts**; live parenthesised italic $N$ is now the covering number only.
Bare $\tau$ moved and §1.7's row false **twice** — TRUE. $\varTheta_k$ written out, family now two,
bare $\Theta$ deleted, the rejected-draft $\varpi^{\mathrm d}_i$ display corrected, two `\cref`s
retargeted **and flagged in the open** — TRUE, all five. Sans-serif dispositions — TRUE, all counts
reproduce. COL-4 re-decided — **TRUE in premise, INCOMPLETE in execution** (§1.7 not corrected;
census not full). §1.5g(iii)(a) amended — TRUE, *"well-drafted and it did its job."* Self-audit —
**TRUE and verified**: C91's own correction reproduces exactly, *"the best-formed row in the
register."*

**Register contiguity C1–C99: CONFIRMED**, no gaps, no duplicates.
**`assumptions.tex` untouched: consistent** with every A-file count re-run.

## Distance to the gate

| Step | Work | Raw | Score |
|---|---|---|---|
| 0 | now | −125 | **0** |
| 1 | **Five strings in `notation_glossary.md`** — §1.6's struck clause, a §1.7 $M_n$ row, C99's "full census", C92's "one line", §1.5j(ii)'s $\mathsf N$ | −100 | 0 |
| 2 | **COL-BK** — rows for $\mathsf B$, $\mathsf K$, bare $K$, or rename | −85 | **15 — floor cleared** |
| 3 | **COL-4** — rename `lem:pconv`'s $M_n$ (9 lines), write out the Löwner $m,A,B,M$ (2), rename $M_k$ (1). ~12 lines | −70 | 30 |
| 4 | **COL-2** — $\varrho_{\mathrm B}$, 2 lines | −55 | 45 |
| 5 | Seven undeclared families (breve first — 14 lines, zero glossary presence) | −20 | **80 — gate cleared** |
| 6 | Three clause-(a) rows + seven typography | −0 | 100 |

**Step 1 is the cheapest 25 points on the board and touches no compiled text.**

## The structural recommendation

Round 7 asked for *a dated sweep at the point a letter is claimed*; dispatch 22 delivered something
better in §1.5g(iii)(a), and **this round proved it works**. But three rows of the round that wrote
it do not comply with it, and **both count failures are *completeness* claims** — "the letter's full
census", "exactly one line".

> **The clause disciplines the arithmetic of a sweep. It does not yet discipline the word attached
> to it.** A one-line addition — *a sweep may not be described as "full", "complete", "only" or
> "single" unless the pattern printed is the glyph family and the count is printed for all three
> files* — would have caught FBC-13 and FBC-14, this round's only two count failures and two of its
> five new findings.
