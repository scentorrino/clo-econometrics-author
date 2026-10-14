# CLAUDE.MD -- Econometrics Research with Claude Code

<!-- HOW TO USE: Replace [BRACKETED PLACEHOLDERS] with your project info.
     Customize Beamer environments for your talk preamble.
     Keep this file under ~150 lines — Claude loads it every session.
     See the guide at https://hugosantanna.github.io/clo-author/ for full documentation. -->

**Project:** [YOUR PROJECT NAME]
**Institution:** Bates White Economic Consulting and Toulouse School of Economics
**Field:** Econometrics (theoretical and applied)
**Branch:** main
**PROJECT_TYPE:** mixed
<!-- CHANGED 2026-07-31, theory -> mixed, when the empirical application was decided.
     CONSEQUENCES, all of them automatic once this flag flips (quality.md Sec.3):
       - Weight schedule changes. Proof completeness 30% -> 25%; assumption
         parsimony 20% -> 15%; notation consistency 10% -> 5%. Empirical strategy
         (15%) and applied code (10%) ENTER the aggregate; they were absent.
       - data-engineer becomes dispatchable. It lives under .claude/agents/applied/
         precisely so theory pipelines do not reach it, and theory mode never did.
       - The theory binary gates in quality.md Sec.4 STILL APPLY -- they are
         declared for `theory OR mixed`. Flipping this flag does not soften them.
     If the application is abandoned, flip this back rather than leaving it: the
     renormalisation silently changes every score computed afterwards. -->

<!-- One of: applied | theory | mixed.
     - applied (default): empirical pipeline. Dispatches data-engineer, coder, writer.
       Theorist + simulation-engineer + the five narrow theory critics are NOT dispatched.
     - theory: methods / theoretical-econometrics paper. Dispatches theorist + simulation-engineer
       + notation-warden, assumption-auditor, regularity-checker, counterexample-hunter,
       derivation-verifier. Activates /conjecture, /prove, /audit, /simulate.
       Data-engineer is NOT dispatched. Quality weights shift to favor proof completeness
       and assumption parsimony — see .claude/rules/quality.md §3.
     - mixed: theory paper with a Monte Carlo or empirical illustration. Both pipelines
       active. Weight schedule in quality.md §3 splits across both.
     Switching this flag never changes paper/, scripts/, or data/ — only which agents are
     dispatched and which weight schedule applies. -->



---

## Core Principles

- **Plan first** -- enter plan mode before non-trivial tasks; save plans to `quality_reports/plans/`
- **Verify after** -- compile and confirm output at the end of every task
- **Single source of truth** -- Paper `main.tex` is authoritative; talks and supplements derive from it
- **Quality gates** -- weighted aggregate score; nothing ships below 80/100; see `quality.md`
- **Worker-critic pairs** -- every creator has a paired critic; critics never edit files
- **Auto-memory** -- corrections and preferences are saved automatically via Claude Code's built-in memory system

---

## Getting Started

1. Fill in the `[BRACKETED PLACEHOLDERS]` in this file
2. Run `/discover interview [topic]` to build your research specification
3. Or run `/new-project [topic]` for the full orchestrated pipeline

---

## Folder Structure

```
[YOUR-PROJECT]/
├── CLAUDE.MD                    # This file
├── .claude/                     # Rules, skills, agents, hooks
├── Bibliography_base.bib        # Centralized bibliography
├── paper/                       # Main LaTeX manuscript (source of truth)
│   ├── main.tex                 # Primary paper file
│   ├── sections/                # Section-level .tex files
│   ├── figures/                 # Generated figures (.pdf, .png)
│   ├── tables/                  # Generated tables (.tex)
│   ├── talks/                   # Beamer presentations
│   ├── quarto/                  # Quarto RevealJS presentations
│   ├── preambles/               # LaTeX headers / shared preamble
│   ├── supplementary/           # Online appendix and supplements
│   └── replication/             # Replication package for deposit
├── data/                        # Project data
│   ├── raw/                     # Original untouched data (often gitignored)
│   └── cleaned/                 # Processed datasets ready for analysis
├── scripts/                     # Analysis code (R, Python, Julia)
├── quality_reports/             # Plans, session logs, reviews, scores
├── explorations/                # Research sandbox (see rules)
├── templates/                   # Session log, quality report templates
└── master_supporting_docs/      # Reference papers and data docs
```

---

## Commands

```bash
# Paper compilation (latexmk handles multi-pass + biber automatically)
cd paper && latexmk main.tex

# Talk compilation
cd paper/talks && latexmk talk.tex

# Clean auxiliary files
cd paper && latexmk -c
```

> **Note:** `paper/latexmkrc` configures XeLaTeX, TEXINPUTS, and BIBINPUTS.
> On Overleaf, set compiler to XeLaTeX via Menu > Compiler — Overleaf reads `latexmkrc` automatically.

---

## Quality Thresholds

| Score | Gate | Applies To |
|-------|------|------------|
| 80 | Commit | Weighted aggregate (blocking) |
| 90 | PR | Weighted aggregate (blocking) |
| 95 | Submission | Aggregate + all components >= 80 |
| -- | Advisory | Talks (reported, non-blocking) |

See `quality.md` for weighted aggregation formula.

---

## Skills Quick Reference

| Command | What It Does |
|---------|-------------|
| `/new-project [topic]` | Full pipeline: idea → paper (orchestrated) |
| `/discover [mode] [topic]` | Discovery: interview, literature, data, ideation |
| `/strategize [mode] [question]` | Identification strategy, pre-analysis plan, or formal theory section (`theory` mode) |
| `/analyze [dataset]` | End-to-end data analysis |
| `/write [section]` | Draft paper sections + humanizer pass (`style-guide` mode extracts voice from prior papers) |
| `/review [file/--flag]` | Quality reviews (routes by target: paper, code, peer) |
| `/revise [report]` | R&R cycle: classify + route referee comments |
| `/talk [mode] [format]` | Create, audit, or compile Beamer presentations |
| `/submit [mode]` | Journal targeting → package → audit → final gate |
| `/tools [subcommand]` | Utilities: commit, compile, validate-bib, journal, etc. |
| `/checkpoint [--flag]` | Session handoff: memory + SESSION_REPORT + research journal (+ Obsidian if configured) |

---

<!-- CUSTOMIZE: Replace the example entries below with your own
     Beamer environments for talks. -->

## Beamer Custom Environments (Talks)

| Environment       | Effect        | Use Case       |
|-------------------|---------------|----------------|
| `[your-env]`      | [Description] | [When to use]  |

---

## Output Organization

<!-- Options: by-script (default) or by-purpose -->
Output organization: by-script

<!-- by-script:  paper/figures/main_regression/figure1.pdf, paper/tables/main_regression/table1.tex -->
<!-- by-purpose: paper/figures/estimation/coefplot_main.pdf, paper/tables/robustness/alt_controls.tex -->

---

## Current Project State

| Component | File | Status | Description |
|-----------|------|--------|-------------|
| Paper | `paper/qmd/main.qmd` + `supplement.qmd` | first draft compiled | Manuscript renders via `scripts/render-paper/render.sh` — main **86pp**, supplement **331pp**, both zero undefined refs / zero unresolved cites. Theory corpus builds via `scripts/build-theory/build.sh` (**321pp**, clean). §6 deliberately unwritten. **No `paper/main.tex` exists**; the `.qmd` pair is the manuscript. Page counts drift with every pass — the two scripts are authoritative, not this row. |
| Manuscript format | `paper/qmd/` | **DECIDED, blocked** | **Quarto is the intended format**; LaTeX is the working format until one `titlesec` clash clears. See `quality_reports/decisions/manuscript-format-and-structure.md` |
| Paper structure | `paper/qmd/main.qmd` | DECIDED | Follows Centorrino, Fève & Florens (2025). **Proofs → online supplement, not a printed appendix.** No empirical application yet — see the row below, which changes the default |
| Target journal | `.claude/references/journal-profiles.md` | **DECIDED** | **Oxford Bulletin of Economics and Statistics (OBES).** Applied-econometrics field journal, Wiley/Oxford. Consequences: proofs-to-supplement goes from preference to requirement; Monte Carlo must run at sample sizes the readership has; stars are standard (not AEA) |
| §6 Empirical application | `quality_reports/data-assessment/panel-npiv-discrete/` | **DECIDED, scoping** | **Hedonic pollution application.** Resolved 2026-07-31; was explicitly left unwritten as an open positioning decision, and OBES's applied readership forced it. Bibliography Area F already scoped the anchors (`rosen1974`, `greenstonegallagher2008`, `bishop2020`); **Superfund NPL listing is a natural *binary* instrument**, which is what the estimator requires. **§6 is WRITTEN** — hedonic application on the Chay–Greenstone county panel, n=983, with a first stage, a ladder, robustness, φ̂ bands, and (2026-08-10) a cell-by-cell localisation on a four-category trigger instrument. **The "we have none" comment this row used to flag is GONE from `main.qmd`; the note outlived the defect and was itself the stale claim** |
| Authorship | -- | DECIDED | **Sole-authored: Samuele Centorrino.** Recorded in `domain-profile.md` § Paper Author Team so critics do not lecture the author on their own NPIV results |
| Data | `scripts/R/` | [complete/in-progress] | [Analysis description] |
| Replication | `paper/replication/` | [not started/ready] | [Deposit status] |
| Job Market Talk | `paper/talks/job_market_talk.tex` | -- | [Status] |
