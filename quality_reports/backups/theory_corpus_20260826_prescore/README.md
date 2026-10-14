# Theory corpus snapshot — 2026-08-26, pre-score

Byte-identical copy of `quality_reports/theory/panel-npiv-discrete/*.tex` taken
immediately before the round-6 theorist-critic and round-7 writer-critic re-scores,
with the build verified at **457pp, latexmk rc=0**, zero undefined refs, zero
multiply-defined labels, zero unresolved cites.

## Why this exists

The eight gate-target files are **untracked in git** (not ignored — simply never
added). The only other copy is `.build/theory-panel-npiv-discrete/`, which is
gitignored *and rewritten from live on every `build.sh` run* — a staging mirror,
not a backup. Before this snapshot, a bad edit followed by a build was
unrecoverable. This is the rollback path.

## READ THIS BEFORE USING ANYTHING HERE

This directory contains **two kinds of file, and they must not be confused.**

**The compiled corpus — authority.** These eight are what
`scripts/build-theory/driver.tex` `\input`s, and they are the gate target under
`.claude/rules/quality.md` §4.1:

    assumptions_main.tex   results_s2_identification.tex
    assumptions_supp.tex   results_s3_estimation.tex
    results_s3_supp.tex    results_s4_asymptotics.tex
    results_supp.tex       proofs.tex

**Retired mirrors — NEVER authority:**

    assumptions.tex   results.tex   results_main.tex   working_notes.tex

They are compiled by no document. They are kept — here and live — only because
~33 specs under `scripts/symbolic/specs/` and
`scripts/render-sync/check_rendering_sync.py:567` read the first two **by line
number**, so deleting or reflowing them breaks those consumers. That coupling is
a known, recorded follow-up.

Their staleness is visible in the timestamps preserved by `cp -p`: the mirrors
date from Aug 4–14, the corpus from Aug 23–25.

## This exact confusion has misfired the gate twice

- **2026-08-03** — the gate pointed at `paper/sections/theorems/*.tex`, a
  rendering from an abandoned architecture. Those files *do* contain proofs, so
  the gate **passed while inspecting the wrong artifact** — worse than no gate,
  because it reported safety it never checked.
- **2026-08-05** — repointed to the undivided `results.tex`, which by then had
  diverged the other way: it still declares `cor:a1cprim`, withdrawn on
  2026-08-05 because its hypothesis set is empty (A1 makes $\widetilde W$
  conditionally centred, so A1d fails at $\Lambda\equiv1$). Gating on it would
  have **failed on a statement the paper no longer makes**.

Both directions are uninformative. The standing rule: gate on whatever set of
files the shipped documents actually `\input`, never on a parallel copy,
whichever way the divergence runs.

## Restoring

    cp -p <this dir>/<file>.tex quality_reports/theory/panel-npiv-discrete/

then rebuild with `scripts/build-theory/build.sh`. Never run `build.sh` and
`scripts/render-paper/render.sh` concurrently — they race on biber's PAR cache
and fake a mass-unresolved-citations regression against clean baselines.
