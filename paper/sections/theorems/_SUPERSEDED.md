# `paper/sections/theorems/` is SUPERSEDED — retired 2026-08-03

**Nothing in this directory is compiled by any document. Do not edit these files, and do not
cite them. They are kept, not deleted, because nothing in this repository is committed and a
deletion would be unrecoverable.**

## What these files are

Per-theorem renderings — `lem-adjoint.tex`, `lem-bierens.tex`, `lem-shiftinv.tex`,
`rem-nophifree.tex`, plus the `dummy.tex` scaffold — produced under an **earlier architecture**
in which `paper/main.tex` would `\input{}` one file per result.

**That architecture was abandoned. `paper/main.tex` does not exist.** The manuscript is the Quarto
pair `paper/qmd/main.qmd` + `paper/qmd/supplement.qmd`, and both `\input` the theory corpus under
`quality_reports/theory/panel-npiv-discrete/` directly.

Verified 2026-08-03: **neither `.qmd` references `sections/theorems`.** The only mentions in
`paper/qmd/main.tex` and `paper/preambles/preamble.tex` are inside `%` comments.

## Why they are retired rather than resynced

They say so themselves. From `lem-bierens.tex`, its own header:

> *"NOTHING ELSE IN THIS FILE IS RESYNCED. The statements and proofs below are the **round-2 text**
> and are correct as such; the Part C repairs of rounds 3–7 (if any) are not reflected. When Parts
> C, E and F are generated together after Step 4, this file must be regenerated MECHANICALLY from
> results.tex and proofs.tex."*

The corpus is now at **dispatch 25**. That regeneration never happened, and the architecture it was
waiting for was dropped.

Measured 2026-08-03 against the live corpus, by exact substantive line:

| file | substantive lines | not in live corpus |
|---|---|---|
| `lem-adjoint.tex` | 353 | 270 (76%) |
| `rem-nophifree.tex` | 124 | 97 (78%) |
| `lem-bierens.tex` | 163 | 109 (66%) |
| `lem-shiftinv.tex` | 63 | 42 (66%) |

**Read the direction correctly: this is old text the corpus has since revised, not unique work that
would be lost.** Every `\label` these files declare also exists in the live corpus. They are behind,
not ahead.

## Source of record

| Object | Live path |
|---|---|
| Statements | `quality_reports/theory/panel-npiv-discrete/results.tex` (undivided) and the `results_s2/s3/s4/_supp` split |
| Assumptions | `.../assumptions.tex` and the `assumptions_main` + `assumptions_supp` split |
| Proofs | `.../proofs.tex` |

## What was repointed when this directory was retired

Three governance references treated this directory as live. All were corrected on 2026-08-03:

1. **`.claude/rules/quality.md` §4, binary gate 1** — gated submission on "every file under
   `paper/sections/theorems/*.tex` contains a complete proof". **This was the serious one:** the
   files exist and do contain proofs, so the gate would have *passed* while verifying round-2 text.
   A gate that passes by inspecting the wrong artifact is worse than no gate.
2. **`.claude/agents/verifier.md`** — instructed the verifier to walk this directory.
3. **`.claude/rules/permissions.md`** — listed it as an acceptable REQUIRES for `notation-warden`.

## If you ever want these back

Regenerate mechanically from the corpus. Do not hand-edit — hand-maintained parallel renderings are
what produced this directory's drift, and the files' own headers name that failure mode.
