# Section 6 outputs as they stood before the conditional-independence re-run

Snapshot taken 2026-08-06, immediately before `app_tsp_run_all.R` was re-run
against the corrected engine.

**Why these are kept.** Every table and figure here was produced by the engine
as ported from `lfindfn_short_panel.m`, whose model is
`Delta U _||_ W` UNCONDITIONALLY. This paper's A1 is the conditional form
`Delta U _||_ W | Delta Z`, and `sim_bierens_validate.R` shows the ported
estimator is **inconsistent** for both theta and phi once `varrho` varies:
phi ISE 1.129 -> 1.100 -> 1.053 across n = 400/800/1600, a ratio of 0.96 per
doubling, against ~0.53 for the faithful estimator.

So these outputs are not a rival set of estimates to be compared against the
new ones on their merits. They are the record of what was shipped, retained so
that any number quoted in a draft, a referee reply or a decision record can be
traced to the artifact that produced it.

**Do not re-cite these.** The replacements carry the same filenames.
