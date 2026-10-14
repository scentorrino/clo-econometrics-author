# Decision Record — Replication package is a submission-stage task

**Date:** 2026-08-04 · **Decided by:** Samuele Centorrino · **Status:** DECIDED

## Decision

`paper/replication/` stays empty until the paper reaches **submission stage**. It is not a gap in
the current draft and should not be raised as one again before then.

## Context

`paper/replication/` is empty, and `.claude/references/journal-profiles.md` records for OBES that
**"Code availability expected."** That combination reads as an open blocker on any submission
checklist, and it was surfaced as one on 2026-08-04 after the four-audit round.

**It is not a blocker now, because the paper is not near submission.** Live at the time of this
record: three CRITICAL manuscript findings fixed but four MAJORs open (F4–F7); the assumption
auditor at 50/100 with A5(i) unresolved; the notation warden at 72/100 pre-fix; §6's
manuscript→map anchors owed; and an open question about whether the hedonic application survives
at all (`quality_reports/decisions/alternative-applications.md`).

## Why the timing matters, rather than just the sequencing

A replication package assembled now would package a moving target. The scripts under
`scripts/application/` have been edited on three of the last four days — `rate_delta_n` was
corrected on 2026-08-03 and moved a printed number, and `app_tsp_02_ladder.R` had to be re-run on
2026-08-04 because a *second* table carried the same stale quantity. A package built before those
settle certifies reproducibility of numbers that are still changing, which is worse than no package:
it is a claim about the artifact that the artifact would contradict, which is this project's
signature defect species.

The specific risk if §6 is replaced (see the alternative-applications record) is that the entire
`scripts/application/` tree goes with it.

## What the package will need when the time comes

Recorded now while the context is fresh, so the work is not re-derived:

- **Seeds.** `SEED_PHIBAND`, `SEED_PHIMULT = 20260807L`, and the simulation seeds. Every replication
  draws from its own L'Ecuyer anchor, so results are core-count independent — that is worth stating
  in the README because it is unusual and it is already verified.
- **The checkpoint story.** `identical()` on a reloaded `data.table` is always `FALSE`, so every
  checkpoint was silently discarded until 2026-08-03; `same_design()` in `sim_thm_rootn_dgp.R` is the
  fix. A replicator resuming from a checkpoint needs to know this or they will conclude the cache is
  broken.
- **Runtimes.** `app_tsp_05_phi_band.R` is ~19.4 core-hours. The headroom arm is 51 cells at
  $B=5{,}000$. These need stating or a replicator will assume something has hung.
- **Data provenance.** `data/raw/data_tsp.txt` is the Chay–Greenstone county panel, 989 rows, and
  `ExpPol` is NaN in all of them. The file's origin is not documented in the repo and must be
  before deposit.
- **The one number a replicator cannot check.** The $\mu$g/m$^3$ composite operator norm
  $3.3\times10^4$ justifies tuning constant C2 and exists only in a comment at
  `scripts/application/app_tsp_common.R:77`; no routine in the tree computes it on that coordinate.
  Either make it an output artifact or drop the claim.

## Reopen when

The manuscript clears its critic gate (80) **and** the §6 application question is settled. Not
before.
