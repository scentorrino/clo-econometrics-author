# §5 cut for OBES — plan

**Status:** APPROVED (user: "start with 5") · **Date:** 2026-08-27

## Problem
`main.qmd` is 39,447 source words / 68,843 rendered. OBES wants ~11,000 all-in.
**§5 Monte Carlo is 20,598 words — 52.2% of the article and roughly twice a complete
OBES paper.** The four sections carrying the contribution total 8,390 (21%).
§5 owns **22 of the article's 28 tables** and 4 figures.

## Target
§5 → **~2,500 words, 3 tables, 0 figures.** Article → ~21k after this cut alone
(§6 and the intro are separate later steps).

## What stays in main, and why
| Float | Ground |
|---|---|
| `tab:sim-merged-rootn-balanced` | the estimator working at n the readership has |
| `tab:sim-merged-rootn-misspec` | where it breaks; keeping only the favourable design reads as selection |
| `tab:sim-merged-stopping` | the OBES profile **requires** a defensible tuning rule with its constant pinned |

Prose keeps: the design in one paragraph; the n = 400/800/1,600 grid and why it
brackets §6's n=983; bias/√n·sd/coverage read off the two results tables; the
stopping rule and its constant; **the N1 caveat (~150 words) — it is an honesty
item and must not move out of main**; one sentence + pointer for the limit-law
arm to n=181,019.

## What moves to the supplement (19 tables, 4 figures)
Block I/II entirely (limit law, DGP A/B, ablations, crossings, headroom, boundary
layer, h-budget, QQ and quantile material), the three-suites-do-not-merge argument,
the cardinality arms' full treatment, `se_ratio`'s decomposition, the N1 defect
table, and the per-design skewed results.

## The risk that dominates this operation
Moving ~19 tables renumbers **both** documents: main 28 → ~9 tables, supplement
27 → ~46. **All 58 cross-document ordinal pointers break at once** — the class-8
defect at full scale. `scripts/render-paper/render.sh` now resolves every pointer
to the caption it lands on; both documents must be re-rendered before that list
is trustworthy.

## Order
1. Archive §5 verbatim — **DONE**, byte-identical, at
   `quality_reports/archive/section5_20260827/`.
2. Move content to the supplement (no table regeneration; move floats intact).
3. Write the new §5.
4. Re-resolve all 58 pointers using the render.sh resolver.
5. Render both; verify captions, censuses, refs, and the pointer list line by line.
6. Claim-source map §27.

## Explicitly NOT in this step
No table is regenerated. No number changes. §6 and the introduction are separate.
