# Notation Audit — `panel-npiv-discrete`, round 19

**Date:** 2026-08-04 · **Score: 72/100** (raw −28). Prior: **0/100** (round 18).
**Read-only critic; orchestrator transcription.** `[VERIFIED]` marks checks the orchestrator
re-ran against the corpus afterwards.

**Corpus:** the eight live files in `driver.tex:55–69` order. `results.tex`, `assumptions.tex`
and `results_main.tex` were opened only to read their retirement banners and were **not** audited.
Every sweep is labelled round-19 (2026-08-04); none is inherited.

## Headline

**The two extraction passes were not clean, and the defect is concentrated in one of the thirteen
new remarks.** Twelve moved only commentary. **`rem:spacesread` moved a symbol declaration**, from
compile position 2 to position 7 — behind every use of the symbols it declares.

| # | Finding | Class | Ded |
|---|---|---|---|
| F-1 | **$P_{\mathcal V}$ used at `results_s4_asymptotics.tex:59,65` — inside `eq:sharpconst` and `eq:bracket`, numbered displays in a printed proposition — and glossed only at `results_supp.tex:4708`, three files later** | undefined on first use | −5 |
| F-2 | $\Xi,\Xi'$ declared at `results_supp.tex:4693` (pos. 7); first used at `results_s2_identification.tex:73` (pos. 2), **inside the very definition the declaration was cut from** | undefined on first use | −5 |
| F-3 | $\mathcal B_{\mathrm{sym}}$ defined `results_supp.tex:1752` (pos. 7), used `results_s4_asymptotics.tex:59,65,66` (pos. 4). Split-order artifact, not extraction; compounds F-1 in the same two displays | undefined on first use | −5 |
| F-5 | **The glossary counts in units of two retired files** — `:675–676`, `:737–739` declare `A`=`assumptions.tex`, `R`=`results.tex` as "the three live files". **58 lines name a retired file**; every `A`/`R` count in C90–C107, §1.6, §1.7 is denominated against text nobody compiles | register | −5 |
| F-4 | 2 of 3 compiled `\cref{rem:spacesread}` calls resolve **forward** (`assumptions_supp.tex:237`; `results_supp.tex:2058`, by 2,629 lines). Live count is **3**, not the 5 the pass claimed — the other two are retired mirrors | typography | −4 |
| F-6 | $\widehat{\widetilde W}_i$ has two declaring sites (`assumptions_main.tex:1924`, `assumptions_supp.tex:1004`), character-identical and explicitly subordinated | typography | −2 |
| F-7 | §1.7's $\varsigma_0$ row separates by "subscript presence", which does not adjudicate (P-a.3)'s **superscripted** $\varsigma^{(k)}$, 14 lines away in the same hypothesis list | typography | −2 |

## Verified clean — six positive findings

- **V-1** `def:hatT` kept $\widehat{\widetilde W}_i$'s definition at `assumptions_main.tex:1924`;
  `eq:hatT` uses it at `:1934`. Ten lines, right order. Only the derived bound moved.
- **V-2** The `def:spaces` glossary sweep verified rather than trusted: **all seven repoints
  present and correctly worded** — C72 ×2, §1.6 $\Xi_\ast$, C89, C93, §1.7 $h$. Only the corpus
  count was wrong (F-4).
- **V-3** **C94/C104 CLOSED and reproducing exactly.** `\mathsf a_1`, `\mathsf a_2`,
  `\mathcal H_k`, `\Delta_k` → **0** compiled lines corpus-wide. Survivors are in
  `archive/proofs_partH.tex` (uncompiled) and `%` comments.
- **V-4** COL-4 executed: the Doob martingale $M_k,M_0,M_N,M_{k-1}$ has zero compiled occurrences.
- **V-5** `results_s3_supp.tex` declares zero numbered environments and zero `\label{eq:...}`,
  matching its header. The 686-line triage shifted no counter and orphaned no `\eqref`.
- **V-6** `rem:onestepread` is the only one of thirteen placed in the same file as its parent
  (`results_s3_estimation.tex:507`, two lines after `def:onestep`), because three bibliography
  anchors had to stay in the article's reference list. It is the only placement with no
  forward-reference exposure.

## The recommendation, in one line

> The thirteen extractions were governed by a rule about **what** may sit in a statement. They were
> not governed by a rule about **where the extracted text may land.** Twelve times that did not
> matter, because what moved was commentary. Once it did, because what moved was a declaration.
>
> *A pass that moves text out of a statement must sweep the moved text for `:=`, "write … for",
> "is the", "are the … variables" — and any block containing one may not land in a file that
> compiles after the block's first consumer.*

That clause would have caught F-1, F-2 and F-4: five of seven findings, 14 of 28 points.

## Orchestrator action, 2026-08-04

**F-1 and F-2 FIXED.** `[VERIFIED]` before acting: `P_{\mathcal V}` appears on 2 lines of
`results_s4_asymptotics.tex`, 0 of `results_s2_identification.tex`, with its only gloss at
`results_supp.tex:4707–4709`. The one-clause declarations of $h,h'$, $\Xi,\Xi'$ and
$P_{\mathcal V}$ are restored to `def:spaces` at `results_s2_identification.tex:75`, with the
ordering rationale and the proposed §1.5g clause recorded at the site. `rem:spacesread`(1) and (3)
keep their fuller discussion. Corpus rebuilds **CLEAN at 335 pp**. Expected score after: **82**.

**F-5 NOT fixed — it is the orchestrator's own doing and is the larger item.** Retiring
`results.tex`/`assumptions.tex` on 2026-08-03 invalidated the glossary's counting units. The fix is
to re-denominate `A`/`R` against the eight live files, which means re-measuring every count in
C90–C107, §1.6 and §1.7 — a round-20 job, not a patch.

F-3, F-4, F-6, F-7 open.
