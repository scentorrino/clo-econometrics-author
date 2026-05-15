# Theory-Track Adaptation of Clo-Author

You are Claude Code working in a local clone of `hugosantanna/clo-author`. Your job is to adapt this template — originally built for applied econometrics — into a version suited for **theoretical econometrics** papers (proofs, asymptotic theory, identification results, semi/nonparametric efficiency, etc.). The bottleneck in theory work is correctness of derivations and tightness of assumptions, not data credibility, so the agent roster, quality gates, and skills need to shift accordingly.

This file is the master spec. Execute it phase by phase. **Do not skip Phase 0.** After each phase, run the verification checklist for that phase before moving on. Open a working branch first:

```bash
git checkout -b theory-track
```

Commit at the end of every phase with a message of the form `theory-track: phase N — <name>`.

---

## Phase 0 — Reconnaissance (mandatory, do not skip)

Before writing or moving anything, read the repo to learn its conventions. The instructions below describe *what* to change; the existing files tell you *how* the project formats agents, skills, rules, commands, and hooks. You must match those formats exactly — frontmatter keys, heading levels, section order, naming.

Read at least the following, then summarize back to me what you found before proceeding:

1. `CLAUDE.md` — the master configuration, including any placeholders.
2. `README.md` — already covered, but re-skim for vocabulary.
3. `.claude/agents/` — read **all** 16 agent files. Note: frontmatter fields, the worker-vs-critic structural differences, how critics reference their paired worker, tool permissions.
4. `.claude/skills/` — read all skill files. Note frontmatter and the typical body structure (when to trigger, procedure, examples).
5. `.claude/rules/` — read all rule files, especially `domain-profile.md`.
6. `.claude/commands/` (or wherever the 10 slash commands live — discover the path) — read all of them. Note how a command sequences agent calls.
7. `.claude/hooks/` — read all hooks.
8. `MEMORY.md` and `CHANGELOG.md` — for tone and the changelog format.

Produce a short reconnaissance report at `quality_reports/theory-adaptation-recon.md` containing: file naming conventions, frontmatter schemas (agents vs. skills vs. commands vs. rules), the exact worker-critic pairing pattern, the quality-gate scoring mechanism (where weights are defined, how components are combined), and any hook that touches scoring or commits.

**Verification before leaving Phase 0:** I should be able to read your recon report and know exactly which file format to imitate for every new artifact in later phases.

---

## Phase 1 — Repurpose existing agents

Do not delete the applied-track agents. Keep them on the `main` branch and in this branch under `.claude/agents/applied/` so that papers with an empirical section can still summon them. Move:

- `data-engineer.md` → `.claude/agents/applied/data-engineer.md`

Then create theory-track replacements. For each new or renamed agent, mirror the frontmatter schema you found in Phase 0 and pair every worker with its critic. Naming uses kebab-case, matching the existing convention.

### 1.1 `simulation-engineer` (worker)
Replaces `data-engineer` in the theory pipeline. Its job is Monte Carlo verification: write simulation code (in the user's configured language — R by default) that checks whether finite-sample behavior of a proposed estimator or test matches the asymptotic claims of the paper. Inputs: a theorem statement (rate, limiting distribution, size/power claim). Outputs: a script under `scripts/simulations/`, a results table under `Tables/sim/`, and a one-page summary under `quality_reports/sim/`. Should explicitly compare empirical quantiles to the claimed limit and flag when mismatch exceeds Monte Carlo error.

Pair it with `simulation-engineer-critic` modeled on the existing `coder-critic`.

### 1.2 Split `writer` into two
Keep `writer.md` for prose (intro, related-literature, discussion, conclusion). Create a new `proof-author.md` whose scope is theorems, propositions, lemmas, corollaries, and their proofs. The proof-author must follow a strict template for every mathematical statement (define this template in a new skill — see Phase 3): Statement → Conditions invoked → Proof → Remarks. Proofs must justify every nontrivial step with an inline cross-reference to the lemma, assumption, or known result invoked.

Pair `proof-author` with a new `proof-critic.md` whose mandate is **logical gaps**, not exposition. The proof-critic checks: does every step follow from the previous? Are all invoked assumptions explicitly listed? Are limits, sums, integrals, and derivatives interchanged with justification? Is uniformity claimed where needed?

Keep the existing `writer-critic` paired with the prose `writer`.

### 1.3 Rename `strategist` deliverable
Do not rename the agent file. Edit `.claude/agents/strategist.md` so that for theory projects (detected via a flag in `CLAUDE.md` — see Phase 6) its output is a **proof-strategy memo** rather than an identification-strategy memo. The memo's required sections: conjecture, target object (estimator / test / identification result), toolkit (empirical process theory, M-estimation, U/V-statistics, sieve methods, semiparametric efficiency, etc.), key intermediate lemmas, anticipated obstacles, fallback weaker claims. Update `strategist-critic` accordingly.

**Verification:** `git diff` shows the move of `data-engineer.md`, the two new worker agents (`simulation-engineer`, `proof-author`), their two new critics, and the strategist edits. Frontmatter validates against the schema from Phase 0.

---

## Phase 2 — Add adversarial theory-specific agents

These are net-new agents with no applied counterpart. Each one is small in scope; resist the urge to merge them. The point of the worker-critic philosophy is that narrow critics catch more.

Create the following under `.claude/agents/`:

### 2.1 `notation-warden.md`
Scope: every mathematical symbol is defined exactly once on first use, used consistently afterward, and not reused for a different object elsewhere. Outputs a notation table (`quality_reports/notation/notation-table.md`) listing every symbol, its definition, and every section where it appears. Flags collisions, undefined-on-first-use cases, and inconsistent typography (e.g., $\beta$ vs. $\boldsymbol{\beta}$).

### 2.2 `assumption-auditor.md`
Scope: for every named assumption (A1, A2, …), build an assumption-usage matrix mapping assumption → every theorem/lemma that invokes it. Flag: assumptions that are never used (cut them), assumptions that are strictly stronger than what the proofs need (weaken them), and theorems that invoke conditions not stated as assumptions (state them). Output at `quality_reports/assumptions/usage-matrix.md`.

### 2.3 `regularity-checker.md`
Scope: the standard menagerie of regularity-condition gaps — measurability of suprema, integrability of envelopes, moment conditions, dominated-convergence justifications, interchange of limits and integrals or limits and derivatives, uniformity of convergence over the parameter space, behavior on the boundary of the parameter space. Reads proofs and flags every step that silently assumes one of these.

### 2.4 `counterexample-hunter.md`
An adversarial agent. Its only job is to attempt to break each theorem at boundary cases: parameter on the boundary of the parameter space, degenerate distributions (point mass, heavy tail with infinite moment, non-absolutely-continuous), non-iid relaxations of the sampling assumption, infinite-dimensional nuisance with slow rate, weak instruments / weak identification analogues. For each attempt, it produces either a confirmed counterexample (paper is wrong as stated — escalate) or an argument for why the attempt fails (which strengthens confidence and may suggest a remark to add).

### 2.5 `derivation-verifier.md`
The symbolic-computation agent. See Phase 4 for the tooling it depends on. Its scope is mechanical verification of algebraic derivations: expansions, simplifications, derivatives, matrix identities, asymptotic expansions to a specified order. Given a claimed identity from the paper, it recomputes symbolically and reports match / mismatch.

### Pairing
- `notation-warden`, `assumption-auditor`, `regularity-checker`, `counterexample-hunter`, and `derivation-verifier` are **critic-type** agents — they don't edit the paper, they report. They don't need paired critics of their own, since they are themselves narrow critics.
- Note this clearly in their frontmatter (read-only file permissions, matching the existing critic pattern from Phase 0).

**Verification:** five new files under `.claude/agents/`, each with correct frontmatter, none with write permissions to `Paper/`.

---

## Phase 3 — New skills

Create the following under `.claude/skills/` (matching the structure you observed in Phase 0):

### 3.1 `theorem-environment-style.md`
House style for stating mathematical results. Required structure for every formal statement:

```
Theorem N. <Sentence describing the result.>
Suppose Assumptions A1–Ak hold. Then <conclusion>.
```

Conditions invoked are listed by tag, not restated. Remarks come *after* the proof, never inside the statement. Corollaries are stated in the same form and explicitly reference the parent theorem. Document conventions for `\begin{theorem}`, `\begin{proposition}`, `\begin{lemma}`, `\begin{corollary}`, `\begin{remark}` LaTeX environments.

### 3.2 `proof-style.md`
House style for writing proofs. Rules: no "it is easy to see," no "similarly," no "obviously," no unexplained "by standard arguments." Every nontrivial step justified by a cross-reference (lemma, assumption, equation number, or named external result with citation). Display equations numbered if referenced later, unnumbered otherwise. End with `\qed` or `$\blacksquare$`.

### 3.3 `asymptotic-conventions.md`
House style for asymptotic notation: $o_p$ vs $O_p$ vs $o$ vs $O$, "with probability approaching one" vs "almost surely," pointwise vs uniform convergence (when "uniform" needs to be qualified — over the parameter space, over a class of functions, etc.), how to state rates ($\sqrt{n}$-consistency, $n^{1/3}$-rate, etc.), Slutsky and continuous-mapping invocations.

### 3.4 `verify-derivation.md`
Trigger conditions: when the proof-author or a critic encounters a multi-line algebraic derivation, matrix calculation, or asymptotic expansion. Procedure: extract the claimed start and end expressions, hand off to `derivation-verifier`, log the result. Include three worked examples (e.g., influence-function calculation, asymptotic-variance derivation, Taylor expansion of a moment condition).

### 3.5 `latex-math-conventions.md`
Typographic conventions: $\mathbb{E}$ vs $E$ for expectation, $\mathbb{P}$ vs $\Pr$ for probability, bold lowercase for vectors and bold uppercase for matrices (or whatever convention the user picks — leave a `[CHOOSE ONE]` placeholder), calligraphic for sets and sigma-algebras, transpose as $\top$ not $T$ or $'$, etc. This is a style sheet, not a sermon.

### 3.6 `simulation-protocol.md`
Procedure for running and reporting a Monte Carlo that verifies an asymptotic claim: choice of sample sizes (typically a grid spanning at least two orders of magnitude), number of replications (with rationale tied to Monte Carlo standard error), data-generating processes (at least one "favorable" and one "stress-test" DGP), what to tabulate (bias, variance, coverage, size, power, with MC standard errors), how to compare empirical to limiting quantiles.

**Verification:** six new skill files, each with the frontmatter and structure of the existing skills.

---

## Phase 4 — Symbolic tooling

This is the biggest functional addition. The `derivation-verifier` agent needs to actually execute symbolic computation. Implement this with **SymPy** via a small Python harness so it works on any machine with Python ≥ 3.10.

### 4.1 Create the harness
- `scripts/symbolic/verify.py` — a CLI that accepts a YAML or JSON spec describing a derivation (variables, assumptions on those variables, start expression, claimed end expression, optional sequence of intermediate steps) and reports whether SymPy can confirm equality (`simplify(start - end) == 0`, with fallbacks to `trigsimp`, `radsimp`, `together`, depending on expression type). Should support matrix expressions via `sympy.MatrixSymbol` and `sympy.Matrix`.
- `scripts/symbolic/examples/` — at least three working example specs corresponding to the three worked examples in `verify-derivation.md`.
- `scripts/symbolic/README.md` — install instructions (`pip install sympy`), usage, limitations (transcendental identities SymPy may not auto-simplify, etc.).

### 4.2 Wire the agent to the harness
In `derivation-verifier.md`, document the exact CLI invocation it should use and the format of the JSON/YAML spec. Include the rule that if SymPy reports non-equality, the agent does **not** conclude the paper is wrong — it reports "symbolic verification failed, manual review required" — because SymPy's simplifier is incomplete.

### 4.3 Dimension checks
For matrix expressions, add a separate quick utility `scripts/symbolic/dim_check.py` that takes a list of matrix dimension symbols and an expression, and checks consistency of all multiplications, additions, and inverses. This catches a different class of error from symbolic simplification.

**Verification:** running `python scripts/symbolic/verify.py scripts/symbolic/examples/<example>.yaml` returns a clear pass/fail report on each of the three example specs.

---

## Phase 5 — New and modified slash commands

Locate the commands directory (from Phase 0). Add the following, matching the existing command file format:

### 5.1 `/conjecture`
Formalize a research conjecture into a draft theorem statement: identifies the target object, candidate assumptions, candidate rate/limit, and produces a stub under `Paper/sections/` with the statement but no proof. Calls `strategist` (in proof-strategy mode) to produce the accompanying memo.

### 5.2 `/prove`
The iterative proof workflow. Sequences: `proof-author` drafts → `proof-critic` reviews → `regularity-checker` and `derivation-verifier` audit → `counterexample-hunter` attacks → `proof-author` revises. Loop until proof-critic and counterexample-hunter both clear, with a max iteration count to prevent infinite loops.

### 5.3 `/audit`
Batch run of `notation-warden` + `assumption-auditor` + `regularity-checker` across the whole paper. Outputs a consolidated report at `quality_reports/audit/audit-<date>.md`. This is the theory analogue of an applied robustness check pass.

### 5.4 `/simulate`
Calls `simulation-engineer` to produce a Monte Carlo verifying a specified theorem, then `simulation-engineer-critic` to review the simulation design. Replaces most uses of `/analyze` for pure-theory projects (keep `/analyze` available for papers with an empirical section).

### 5.5 Edit `/write`
Update `/write` so that for theory projects it routes mathematical-statement and proof writing to `proof-author` and prose writing to `writer`. This routing can be a simple file-pattern check (sections under `Paper/sections/theorems/` go to proof-author, all others to writer) — design that directory split as part of this phase.

**Verification:** the four new commands exist, `/write` is updated, and a dry-run of `/audit` on the empty paper template produces a report file (even if it's mostly "nothing to audit yet").

---

## Phase 6 — Quality gates and CLAUDE.md flag

### 6.1 Add a theory flag
In `CLAUDE.md`, add a new top-level configuration field (matching the placeholder style of the existing fields):

```
PROJECT_TYPE: [applied|theory|mixed]
```

Document that `theory` activates the new agents/commands/skills and downgrades the empirical ones, `applied` is the original behavior, and `mixed` activates both (used for theory papers with a Monte Carlo or empirical illustration).

### 6.2 Rewrite the quality-gate weights for theory mode
Locate the file that defines the weighted aggregate (you found this in Phase 0). For `PROJECT_TYPE: theory`, install new component weights:

| Component | Weight | Notes |
|---|---|---|
| Proof completeness | 30% | from `proof-critic` |
| Assumption parsimony and tightness | 20% | from `assumption-auditor` |
| Notation consistency | 10% | from `notation-warden` |
| Novelty and literature placement | 15% | from `librarian-critic` and `domain-referee` |
| Exposition | 15% | from `writer-critic` |
| Simulation evidence | 10% | from `simulation-engineer-critic`; weight reallocates to proof completeness if PROJECT_TYPE has no simulation section |

### 6.3 Hard binary gate
At the submission tier (95), add a binary check that is independent of the weighted score: **every theorem in `Paper/sections/theorems/` must have a proof that passes `proof-critic` and survives `counterexample-hunter` without an unresolved escalation.** If this binary check fails, the submission gate cannot pass regardless of aggregate score. Implement this in the same place the existing per-component-≥80 check lives.

**Verification:** the gate file shows the new weighting under a clear `theory:` branch; the binary check is encoded; existing applied behavior is untouched when `PROJECT_TYPE: applied`.

---

## Phase 7 — Domain profile and bibliography

### 7.1 Edit `.claude/rules/domain-profile.md`
Add a parallel "theoretical econometrics" profile alongside the existing applied one. The new profile lists:

- Journals: Econometrica (theory track), Journal of Econometrics, Econometric Theory, Quantitative Economics, Journal of Econometric Methods, Annals of Statistics (for the more probabilistic work), Econometrics Journal.
- Frameworks (replacing "identification strategies"): M-estimation, GMM and generalized empirical likelihood, sieve methods, empirical process theory, semiparametric efficiency theory, U/V-statistics, kernel and local methods, debiased machine learning.
- Foundational references: van der Vaart (*Asymptotic Statistics*), Newey & McFadden (large-sample chapter in *Handbook of Econometrics*), Bickel, Klaassen, Ritov & Wellner (*Efficient and Adaptive Estimation*), Pollard (*Convergence of Stochastic Processes*), Andrews (parameter-on-boundary papers), van der Vaart & Wellner (*Weak Convergence and Empirical Processes*), Hansen (*Econometrics* textbook for context).
- Conventions: explicit statement of asymptotic framework, attention to weak vs. strong consistency, conditions stated as named assumptions, etc.

### 7.2 Loosen `validate-bib` for theory
Find the `validate-bib` rule. Currently (per the README) it favors recent published versions. For theory projects, allow book references without DOIs, allow citing specific editions and page numbers, and require edition + publisher + year for book entries. Working papers are still allowed.

**Verification:** `domain-profile.md` clearly has two profiles; the `validate-bib` rule branches on `PROJECT_TYPE`.

---

## Phase 8 — Documentation, MEMORY, and CHANGELOG

### 8.1 Update `README.md`
Add a section titled "Theory Track" after "Adapting for Your Field." Keep it brief — point to a new doc rather than duplicating this whole spec. Mention the `PROJECT_TYPE` flag and link to `docs/theory-track.md`.

### 8.2 Create `docs/theory-track.md`
A user-facing guide describing the new agents, commands, skills, the symbolic-verification tooling, the new quality-gate weights, and the binary submission check. Include a worked example: a one-page sketch of taking a conjecture through `/conjecture` → `/prove` → `/audit` → `/simulate` → `/write` → `/review` → `/submit`.

### 8.3 Update `MEMORY.md`
Add a note explaining the theory-track adaptation. The existing applied learning patterns stay; the new entry just announces the parallel track.

### 8.4 Update `CHANGELOG.md`
Add a new version entry (next minor version after the latest release in the repo). Summarize the change as a single "Theory track adaptation" line and itemize the new agents, commands, skills, and the symbolic-verification harness.

**Verification:** `README.md` references the theory track, `docs/theory-track.md` exists and walks through a single example end-to-end, `CHANGELOG.md` has a new version entry.

---

## Phase 9 — Smoke test

With everything in place, run a smoke test from a clean state:

1. Set `PROJECT_TYPE: theory` in `CLAUDE.md`.
2. Create a trivial dummy theorem in `Paper/sections/theorems/dummy.tex`: state that the sample mean of iid integrable random variables converges in probability to the population mean.
3. From Claude Code, run `/audit`. Expect a report that flags the dummy theorem as having no proof.
4. Run `/prove` on the dummy theorem. Expect proof-author to produce a one-paragraph proof citing the weak LLN, proof-critic to clear it, regularity-checker to confirm only first-moment finiteness is needed, counterexample-hunter to attempt and fail (e.g., note Cauchy distribution as a non-counterexample because it violates the integrability assumption).
5. Run `/simulate` for the dummy theorem. Expect a Monte Carlo confirming convergence at the $\sqrt{n}$ rate (technically the WLLN gives only consistency, not rate — flag this as a teaching moment if the simulation-engineer-critic catches it).
6. Run `/audit` again. Expect a clean report.

Document the smoke-test results in `quality_reports/theory-adaptation-smoke.md`.

If any step fails in a way that suggests a structural problem (not just the dummy proof being too trivial), pause and surface the issue before committing.

---

## Final commit and PR

After Phase 9 passes:

```bash
git add -A
git commit -m "theory-track: phase 9 — smoke test green"
git push -u origin theory-track
gh pr create --title "Theory-track adaptation" --body-file quality_reports/theory-adaptation-smoke.md
```

Then summarize for me, in chat, what changed, what was harder than expected, and what you'd recommend as the next iteration once a real theory paper has been run through the pipeline.

---

## Guardrails for this whole job

- **Match conventions.** Every new file imitates the format of the closest existing file. Do not invent new frontmatter schemas.
- **Keep applied behavior intact.** A user with `PROJECT_TYPE: applied` should see zero behavioral change. Test this explicitly in Phase 9 by toggling the flag.
- **Don't overfit to my sketch.** If during Phase 0 you discover the repo already has something close to what I'm asking for, adapt rather than duplicate. Note the deviation in the recon report.
- **Pause and ask** if you find a structural assumption in this spec that doesn't fit the actual repo. Don't paper over the mismatch.