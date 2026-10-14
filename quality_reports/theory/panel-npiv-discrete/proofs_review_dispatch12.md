<!-- Persisted by the orchestrator 2026-07-30 on receipt. Round-3 (final) review of
     Part I, against proofs_review_dispatch11.md (91/100). Body verbatim. -->

# Theory Review — Part I, `panel-npiv-discrete` — **Round 3 (final)**

**Severity applied:** HIGH (Execution) · **Reviewer:** theorist-critic · **Read-only**
**Score: 97 / 100** · 0 CRITICAL · 0 MAJOR · 0 MODERATE · 3 MINOR
**Clears 80 (commit), 90 (PR) and 95 (submission).** No binary-gate block.

Score trajectory across the pair: **48 → 91 → 97.**

---

## 1. Headline

All four round-2 findings are **closed in substance**. I re-derived each rather than checking that an edit landed nearby. The round refused nothing, opened no MAJOR and no MODERATE, and the five sites it reached beyond the brief are each a genuine consequence, not scope creep. On N2(a) the theorist departed from one of the two routes I offered and **it was right to**: my route (ii) was incompletely specified and would have closed one of two defects. I record that as a second reversal against myself.

What remains is three MINORs, all one-line: two residual glyphs in the glossary and one short hypothesis list. None touches a conclusion; none is worth a fourth round.

---

## 2. Disposition of the four round-2 findings

| # | Round-2 finding | Δ | Disposition |
|---|---|---|---|
| **N1** | Glossary $\delta_n$ row stale | −4 | **CLOSED** — and the addition beyond the brief is correct |
| **N2(a)** | `cor:ratefloor` rests on `lem:prelimtheta`'s proof | part of −3 | **CLOSED via route (i); route choice and labelling both upheld** |
| **N2(b)** | `lem:momzero`(i) cited outside `lem:prelimtheta`'s list | part of −3 | **CLOSED; the theorist's strengthening VERIFIED** |
| **N3** | (O3)'s home list short by `def:crossfit`(c) | −1 | **CLOSED** |
| **N4** | Stage-vs-fold $k$ collision | −1 | **CLOSED at both sites and at the root** (one residual, N6) |

### N1 — CLOSED, and the unbriefed addition is correct

`notation_glossary.md:583` now reads the log-free form struck, $\delta_n:=(\hat\delta_n\ln n)^{2\mu/(2\mu+1)}$ stated as `eq:deltalog`'s object, the fold reading attached, `rem:rootnlog` named. Checked against `assumptions.tex:1370–1375`: **the row now says exactly what A5(ii) says.** It correctly keeps the second half ($\delta_n=o_P(n^{-1/4})$) as a downstream statement rather than folding it into the definition — right, since `eq:deltalog` bundles a definition and a threshold and only the first is what the symbol denotes.

**The addition is correct, and three words are load-bearing.** "The inflation is at the level of $\hat\delta_n$ and is applied once … never $\delta_n\mapsto\delta_n(\ln n)^{2\mu/(2\mu+1)}$ **on top of it**." Without "on top of it" the clause would be *false* — $\delta_n^{\text{new}}=\delta_n^{\text{old}}(\ln n)^{\kappa}$ *is* the correct relation between the pre- and post-amendment objects, and `rem:rootnlog`(1) and `prp:stopfeas`(iv) both narrate that transition legitimately. With them, the clause forbids only the double application, which is what the `assumptions.tex:1850–1854` A7 block warns against. The diagnosis that the definitional row is where a reader would acquire the misreading is right.

### N2(a) — CLOSED. Two rulings.

**Ruling 1 — route (i) over route (ii): UPHELD, and my route (ii) was defective.**

The decisive reason is the theorist's *second*, not its first. `cor:ratefloor` consumes the lemma **twice**: for `lem:sandwich`(i′)'s fourth hypothesis $\|\hat\theta^{(0)}-\theta_\dagger\|=o_P(1)$, and for $\|\Psi^\theta_n\|=O_P(\|\hat\theta^{(0)}-\theta_\dagger\|^2)$ at `proofs.tex:5456`. My route (ii) addressed only the first; the second would still have rested on a lemma whose stated list carried A5(ii)'s second half — the one clause the corollary exists to do without. **My instruction was necessary but not sufficient, for the second time in this pair.**

**Ruling 2 — labelling (i)/(ii) rather than (i)/(i′): UPHELD, and the ground is exactly right.**

`lem:sandwich`'s prime device states **one** conclusion on **two** lists — a *weakening of hypotheses at fixed conclusion*. `lem:prelimtheta`(ii) is the opposite move: a *strengthening of hypotheses to a stronger conclusion*. Priming would have made the file's own prime convention two-directional at the site meant to end an ambiguity.

**Clause (i)'s list verified sufficient for both corollary uses.** Requires A0, A1, A1b(iv), C1(ii), `def:crossfit`, `eq:foldrates` display 1 — all carried by the corollary via (T-1), (T-3), adoption, (T-5), and its own $\delta_n\to0$ line. Steps 1–4 verified threshold-free line by line; the Step 5/6 split is clean.

### N2(b) — CLOSED, and the theorist's reading is verified correct

`lem:momzero`(i) is "$E\|\psi_\star\|<\infty$ and $E[\psi_\star]=0$". With $\psi_\star=\Delta Z\Delta U+\widetilde W L_\star$, the fact $E[\Delta Z\Delta U]=0$ is **one of two summands**, established at that lemma's Step 2 and nowhere in its statement. So the old citation was an appeal to a **proof step** — **the same species as N2(a), not merely an over-wide import.** My round-2 framing was the weaker of the two available readings. The replacement runs A1b(iv), A1's second clause, tower, then Chebyshev with A0 — all on `lem:prelimtheta`'s own list.

### N3, N4 — CLOSED

(O3) lists three homes with the kind-distinction argued, and the third is real: `def:onestep` derives $\partial_\theta\bar\psi_n=-\hat J$ "under the three properties `def:crossfit`(c) requires". A definition is adopted, not declined.

N4 repaired at both sites in words. **The self-report is accurate and the (T-4) instance is worse than the one I named** — inside a theorem *statement*, seven words after "read at each fold". The root fix at `:528` is right: nonnegative parenthesised superscript = stage, negated = fold complement, all seven Part-I symbols enumerated. Re-grepped `\bar k` corpus-wide: the three remaining instances are Part H, where no fold index is in scope. **No collision survives.**

---

## 3. The five sites reached beyond the brief — each forced, none creep

| Site | Verdict |
|---|---|
| `lem:prelimtheta` Step 4 → `eq:foldrates` display 1 | **Forced.** Citing the whole clause would contradict the statement being proved. |
| Step 5 split into 5 and 6 | **Forced.** Two-clause statement, two-part proof. |
| `thm:rootn` Steps 1–2 → clause (i) | **Forced**, attributions check. |
| **`rem:rootnhyp`(1) A5(ii) row rewritten** | **Forced, accurate on every load-bearing claim.** The theorem cites clause (i) at Steps 1 and 2 and **never** clause (ii). Leaving "and in `lem:prelimtheta`" would have been a stale claim of finding 4.2's species. |
| `rem:rootnhyp`(4) re-pointed | **Forced and accurate.** |

One qualification, no deduction: the row lists Step 4 as a direct site of A5(ii)'s second half where the proof names A5(iii)/`eq:frontier`. Defensible — Step 0 declares them equivalent under `eq:deltalog`, and $\delta_n^2=o(n^{-1/2})$ is literally the second half squared. A usage table records what a hypothesis is needed for, not which of two declared-equivalent tags a step prints.

---

## 4. New findings — three MINOR

**N5 (−1) — the glossary sweep reached the definitional row but not the C5 register rationale.** `notation_glossary.md:79` prints $\delta_n=\hat\delta_n^{2\mu/(2\mu+1)}$ in the present tense. Much weaker than N1 — the sentence's subject is where the letter $\mu$ occurs, the rate is illustrative, the claim survives the amendment — but it is the fifth live site of finding 4.2's class, in the file that declares "one symbol, one object." Note for the checker: CHECK 6's `OCCURS_NOWHERE` row targets *present-tense attribution to A5(ii)*, and this instance attributes to nothing, so it would not fire.

**N6 (−1) — N4's root convention landed on the symbol row but not on the collision-pairs table.** `notation_glossary.md:423` still carries the incomplete convention ("superscript = linearisation stage") verbatim, in the file's **index of glyph collisions** — the natural home for a third member of the parenthesised-superscript family. The round's own diagnosis applies to its own fix: it is now written down once, in one of the two places that state it.

**N7 (−1) — `lem:prelimtheta`'s list is short by A1b(i).** Step 4 closes via `lem:nusigma`(i), stated "for every $h\in\mathcal V$", and $h_k\in\mathcal V$ requires $\vdagger\in\mathcal V$ — attributed to **A1b(i)** by `rem:rootnhyp`(1) and by `lem:nusigma`(ii)'s own proof note, expressly as content. `lem:biasexp` lists A1b(i) for the same pairing; `lem:prelimtheta` does not. Nothing downstream is affected — (T-1) carries A1b(i). *(The bound itself is fine: `lem:nusigma`(i)'s proof uses only C1(ii), so the $\mathcal V$ quantifier is inessential to the inequality — the shortfall is in what the cited clause is quantified over, not in the mathematics.)*

---

## 5. Observations — verified, no deduction

1. `cor:ratefloor`'s appeal to `thm:rootn` Step 0 is **not** the N2(a) species: Step 0's inputs are all carried by the corollary; nothing is laundered.
2. `cor:ratefloor` cites "Step 2" for what is Step 1's content; one hop, and the sentence says which rate is used.
3. **`lem:prelimtheta`(ii) is consumed by nothing** and `thm:rootn` Step 2 re-derives it — a documented design choice, stated consistently in three places. The assumption-auditor may want it noted.
4. `lem:epterm` still writes bare "A5(ii)" where `lem:prelimtheta` now writes "A5(ii)'s first half"; the appositive fixes the reading, so nothing is over-strong.
5. Two different "second half"s in one sentence at `proofs.tex:5345–5347`; readable, but a phrase collision in a file that polices glyph collisions.
6. No dispatch-12 change-log block in `results.tex` / `proofs.tex`, breaking the convention of dispatches 10 and 11. The record exists in `theory_memo.md` and the glossary.

---

## 6. Score

| # | Finding | Severity | Δ |
|---|---|---|---|
| N5 | Glossary C5 register rationale prints the log-free $\delta_n$ | MINOR | −1 |
| N6 | N4's root convention absent from the §1.5 collision-pairs row | MINOR | −1 |
| N7 | `lem:prelimtheta`'s list short by A1b(i) | MINOR | −1 |
| | **Total** | | **−3** |

## **Score: 97 / 100**

---

## 7. Verdict on the gate

**It clears 95 (submission) on the theorist-critic component.** Nothing blocks it.

Binary gates, checked independently of the aggregate: no CRITICAL; every Part-I result carries a complete proof; nothing in this round touches the counterexample question; no unresolved escalation from this pair — both dispatch-11 refusals were upheld by me, and this round refused nothing.

**A fourth round is not warranted.** The three MINORs total −3 and no conclusion moves. All three are single-line edits with zero collateral surface. If they are fixed, that should be a cleanup commit, not a review round — dispatching a fifth critic pass to recover three points against a file that has now closed twenty-one findings across three rounds is a poor use of the loop. **Recommendation: carry N5–N7 as known limitations in the research journal, or fold them into whatever pass next touches those three files.**

## 8. What this round did that deserves saying

1. **It reversed me a third time, on substance.** My route (ii) would have closed one of two consumption sites. The theorist found the second, said so, and chose the route that closes both *from a statement*.
2. **It made N2(b) a stronger finding than I did**, and the strengthening is verified.
3. **It found and repaired an instance of N4 worse than the one I named** — in a theorem *statement*.
4. **It went to the root on N4** rather than patching two sites, and the root diagnosis is correct.
5. **Its labelling argument is a genuine refinement of the file's own prime convention** — one conclusion on two lists takes a prime; two conclusions take numbers. That distinction was not in the file before and it should stay.
