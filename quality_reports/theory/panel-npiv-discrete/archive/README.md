# Archived staging copies — Part H merge records

`results_partH.tex` and `proofs_partH.tex` were the **staging drafts** written by the
Step-6 dispatch. Their bodies were merged into the live `results.tex` (748 lines) and
`proofs.tex` (918 lines) on 2026-07-29. They were retained above this directory as
"merge records" and stamped *DO NOT COMPILE AND DO NOT EDIT*.

**Retained here rather than deleted, and moved here rather than left in place.**

## Why they were a hazard where they were

1. **60 of their labels — all of them — collide with the live files.** Zero labels are
   unique to the staging copies, so they carry no content the live files lack. But any
   glob that picked them up produced phantom duplicate-label reports, and any grep over
   the theory directory returned stale text as if it were live. The notation sweep and
   the gating fix round both had to say "the remaining occurrences are in the stale
   `*_partH.tex` records" — a caveat that only existed because the files sat in the
   working directory.

2. **The merge was sliced at the first LaTeX line, so their HEADERS were left behind.**
   That stranded two conventions, `(H1c)` and `(H2c)`, which were then cited at **eleven
   live sites** while being declared nowhere in any live file. The assumption-auditor's
   U-1 and the regularity-checker's A8 are that same defect reached from two directions.
   This was an orchestrator error, not an agent error.

## Status of the stranded content — fully resolved, do not restore from here

- `(H1c)` (fold conditioning + the conditional-to-unconditional $O_P$ transfer rule) is
  transcribed into `proofs.tex` as **(P8)**, joining the (P1)–(P7) block.
- `(H2c)`'s kernel-argument conventions are transcribed as **(P9)**.
- `(H2c)`'s definition of $\Theta_{s_0}$ and its moment conditions were **promoted, not
  transcribed** — they are conditions on an assumed object, so they now live in
  assumption **C3** (`eq:rescaled`, `eq:truncmom`). (P9) points at them.
- All eleven citations of `(H1c)`/`(H2c)` are rewritten to the new tags; zero remain.

**One substantive correction came out of that repair.** The round-11 `(H2c)` note (b)
recorded a clash between C3(ii) and C3(iii) and verdicted it *harmless*. **The verdict
was false**, at exactly one place — `lem:intker(iv)`, whose proof uses the two-sided
reading at interior points and the one-sided reading at boundary points. C3(ii) as
restated in round 12 dissolves the clash.

Archived 2026-07-30, after the gating fix round finished reading `proofs_partH.tex` to
perform the transcription above.
