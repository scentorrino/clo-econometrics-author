# Permission Registry: Agent Capabilities and Dependencies

Every agent's capabilities, dependencies, and routing are declared here. The Orchestrator reads this file to determine dispatch rules, dependency graph, escalation routing, and quality weights. No other file hardcodes these relationships.

Adding a new agent: create the agent file in `.claude/agents/`, add an entry here. No other file needs to change.

---

## librarian
- **PHASE:** Discovery
- **PARALLEL_GROUP:** discovery
- **REQUIRES:** Research idea or research spec
- **PRODUCES:** `quality_reports/literature/{project}/`
  - Required files: `annotated_bibliography.md`, `references.bib`, `frontier_map.md`, `positioning.md`
- **CRITIC:** librarian-critic
- **ESCALATION_TARGET:** User — scope disagreement, user decides breadth vs. depth
- **QUALITY_WEIGHT:** 10% (literature coverage)

## explorer
- **PHASE:** Discovery
- **PARALLEL_GROUP:** discovery
- **REQUIRES:** Research idea or research spec
- **PRODUCES:** `quality_reports/data-assessment/{project}/`
  - Required files: `data_sources.md`, `data_dictionary.md`, `access_instructions.md`
- **CRITIC:** explorer-critic
- **ESCALATION_TARGET:** User — data feasibility deadlock, user decides resource trade-offs
- **QUALITY_WEIGHT:** 10% (data quality)

## strategist
- **PHASE:** Strategy
- **PARALLEL_GROUP:** strategy
- **REQUIRES:** `quality_reports/literature/{project}/` OR `quality_reports/data-assessment/{project}/`
- **PRODUCES:** `quality_reports/strategy/{project}/`
  - Required files: `strategy_memo.md`
  - Required sections: Estimand, Specification, Assumptions, Robustness Plan, Threats
- **CRITIC:** strategist-critic
- **ESCALATION_TARGET:** User — fundamental design question, needs human judgment
- **QUALITY_WEIGHT:** 25% (identification validity)

## theorist
- **PHASE:** Strategy
- **PARALLEL_GROUP:** strategy
- **REQUIRES:** `quality_reports/strategy/{project}/strategy_memo.md`
- **PRODUCES:** `quality_reports/theory/{project}/`
  - Required files: `theory_memo.md`, `assumptions.tex`, `results.tex`, `proofs.tex`, `notation_glossary.md`
- **CRITIC:** theorist-critic
- **ESCALATION_TARGET:** User — proof-level disagreement, user adjudicates whether the result holds
- **QUALITY_WEIGHT:** 20% (theory, when present)
- **CONDITIONAL:** Only for paper types with formal theory: econometric methods, theory+empirics, structural identification, methodological reduced-form. Excluded and weight renormalized for applied papers using off-the-shelf estimators.

## data-engineer
- **AGENT FILE:** `.claude/agents/applied/data-engineer.md` (kept under `applied/` so theory pipelines do not dispatch it by default)
- **PHASE:** Execution
- **PARALLEL_GROUP:** execution-data
- **REQUIRES:** `quality_reports/strategy/{project}/strategy_memo.md` AND strategist-critic score >= 80
- **PRODUCES:** `data/cleaned/`, `paper/figures/` (data visualization), data codebooks
- **CRITIC:** coder-critic
- **ESCALATION_TARGET:** strategist-critic — re-evaluates whether the data specification is tractable
- **QUALITY_WEIGHT:** Included in code quality weight (not scored separately)
- **CONDITIONAL:** Dispatched for `PROJECT_TYPE: applied` and `PROJECT_TYPE: mixed`. Not dispatched for `PROJECT_TYPE: theory` papers without empirical data work.

## simulation-engineer
- **PHASE:** Execution
- **PARALLEL_GROUP:** execution-sim
- **REQUIRES:** `quality_reports/theory/{project}/theory_memo.md` AND theorist-critic score >= 80
- **PRODUCES:** `scripts/simulations/`, `paper/tables/sim/`, `paper/figures/sim/`, `quality_reports/sim/`
  - Required files (per theorem under test): a runnable simulation script, a results table, and a one-page summary with the empirical-vs-asymptotic verdict
- **CRITIC:** simulation-engineer-critic
- **ESCALATION_TARGET:** theorist (when persistent mismatch suggests the proof or limit is wrong) or simulation-engineer (when only the design needs fixing) — the simulation-engineer-critic chooses
- **QUALITY_WEIGHT:** 10% (theory / mixed); 0% (applied — agent not dispatched)
- **CONDITIONAL:** Dispatched for `PROJECT_TYPE: theory` and `PROJECT_TYPE: mixed`. Not dispatched for `PROJECT_TYPE: applied`. When dispatched, the weight reallocates from the proof-completeness (theorist-critic) bucket if no simulation section is present — see `quality.md` theory weight schedule.

## coder
- **PHASE:** Execution
- **PARALLEL_GROUP:** execution-code
- **REQUIRES:** `quality_reports/strategy/{project}/strategy_memo.md` AND strategist-critic score >= 80
- **PRODUCES:** `scripts/`, `paper/tables/`, `paper/figures/`, `quality_reports/results_summary.md`
- **CRITIC:** coder-critic
- **ESCALATION_TARGET:** strategist-critic — re-evaluates whether the strategy memo is implementable
- **QUALITY_WEIGHT:** 15% (code quality)

## writer
- **PHASE:** Execution
- **PARALLEL_GROUP:** execution-write
- **REQUIRES:** coder-critic score >= 80 AND `paper/tables/` contains `.tex` files
- **PRODUCES:** `paper/main.tex`, `paper/sections/*.tex`, `quality_reports/claim_source_map_{project}.md`
- **CRITIC:** writer-critic
- **ESCALATION_TARGET:** Orchestrator — structural rewrite, not just polish
- **QUALITY_WEIGHT:** 10% (manuscript polish)

## editor
- **PHASE:** Peer Review
- **PARALLEL_GROUP:** peer-review
- **REQUIRES:** writer-critic score >= 80 AND coder-critic score >= 80
- **PRODUCES:** `quality_reports/reviews/editorial_decision.md`
  - Dispatches domain-referee and methods-referee (see below)
  - Synthesizes referee reports into editorial decision
- **CRITIC:** None — the editor IS the review coordinator
- **ESCALATION_TARGET:** User — editorial judgment calls
- **QUALITY_WEIGHT:** None (manages the peer review process, not scored directly)

## domain-referee
- **PHASE:** Peer Review
- **PARALLEL_GROUP:** peer-review
- **REQUIRES:** writer-critic score >= 80 AND coder-critic score >= 80
- **PRODUCES:** `quality_reports/reviews/{project}_referee_domain.md`
- **CRITIC:** None — referee is already a reviewer
- **ESCALATION_TARGET:** editor
- **QUALITY_WEIGHT:** 12.5% (half of 25% paper quality)

## methods-referee
- **PHASE:** Peer Review
- **PARALLEL_GROUP:** peer-review
- **REQUIRES:** writer-critic score >= 80 AND coder-critic score >= 80
- **PRODUCES:** `quality_reports/reviews/{project}_referee_methods.md`
- **CRITIC:** None — referee is already a reviewer
- **ESCALATION_TARGET:** editor
- **QUALITY_WEIGHT:** 12.5% (half of 25% paper quality)

## storyteller
- **PHASE:** Presentation
- **PARALLEL_GROUP:** presentation
- **REQUIRES:** writer-critic score >= 80
- **PRODUCES:** `paper/talks/` or `paper/quarto/`
- **CRITIC:** storyteller-critic
- **ESCALATION_TARGET:** Writer — talk narrative issues stem from paper structure
- **QUALITY_WEIGHT:** Advisory (reported, non-blocking)

## verifier
- **PHASE:** Submission
- **PARALLEL_GROUP:** submission
- **REQUIRES:** Overall score >= 95 AND all components >= 80
- **PRODUCES:** `quality_reports/verification_report.md`
- **CRITIC:** None — infrastructure agent
- **ESCALATION_TARGET:** User
- **QUALITY_WEIGHT:** 5% (replication readiness, 0 or 100)

---

## Narrow Theory Critics

These critics are not paired with a worker — they are dispatched directly by `/audit`, `/prove`, and `/conjecture` against theory artifacts. They are read-only (the dispatching skill persists their reports). Active only when `PROJECT_TYPE: theory` or `mixed`.

### notation-warden
- **PHASE:** Strategy / Execution (re-runnable any time theory artifacts change)
- **REQUIRES:** Any of `quality_reports/theory/{project}/{results.tex,proofs.tex,assumptions.tex}` (or the `results_s2/s3/s4/_supp` and `assumptions_main/_supp` split mirrors of the first two)
  <!-- `paper/sections/theorems/*.tex` REMOVED 2026-08-03: retired renderings, compiled by no
       document, round-2 vintage. See paper/sections/theorems/_SUPERSEDED.md. -->

- **PRODUCES:** `quality_reports/notation/notation-table.md`
- **PAIRED WORKER:** None (orchestration-level critic)
- **ESCALATION_TARGET:** theorist (when collisions or undefined symbols block proof readability)
- **QUALITY_WEIGHT:** Contributes to notation-consistency component (see `quality.md` theory weight schedule)

### assumption-auditor
- **PHASE:** Strategy / Execution
- **REQUIRES:** `quality_reports/theory/{project}/assumptions.tex` AND `proofs.tex`
- **PRODUCES:** `quality_reports/assumptions/usage-matrix.md`
- **PAIRED WORKER:** None
- **ESCALATION_TARGET:** theorist
- **QUALITY_WEIGHT:** Contributes to assumption-parsimony component

### regularity-checker
- **PHASE:** Strategy / Execution
- **REQUIRES:** `quality_reports/theory/{project}/proofs.tex` AND `assumptions.tex`
- **PRODUCES:** `quality_reports/regularity/regularity-audit.md`
- **PAIRED WORKER:** None
- **ESCALATION_TARGET:** theorist
- **QUALITY_WEIGHT:** Contributes to proof-completeness component (via theorist-critic bucket)

### counterexample-hunter
- **PHASE:** Strategy / Execution
- **REQUIRES:** `quality_reports/theory/{project}/results.tex` AND `assumptions.tex`
- **PRODUCES:** `quality_reports/counterexamples/probe-results.md`
- **PAIRED WORKER:** None
- **ESCALATION_TARGET:** theorist (a confirmed counterexample is a CRITICAL escalation)
- **QUALITY_WEIGHT:** Binary gate — a confirmed counterexample blocks the submission gate regardless of weighted aggregate (see `quality.md` Section 3: Hard Binary Gate)

### derivation-verifier
- **PHASE:** Strategy / Execution (called by the theorist or other critics on demand)
- **REQUIRES:** A spec file at `scripts/symbolic/specs/*.yaml` and the SymPy harness at `scripts/symbolic/verify.py`
- **PRODUCES:** `quality_reports/derivations/verify-{claim_id}.md`
- **PAIRED WORKER:** None
- **ESCALATION_TARGET:** theorist (when symbolic verification fails — note: not a proof that the paper is wrong, only that manual review is required)
- **QUALITY_WEIGHT:** Advisory (mismatch ≠ proof of error)

---

## Parallel Groups

Agents in the same parallel group can run concurrently when their REQUIRES are met:

| Group | Agents | When |
|-------|--------|------|
| discovery | librarian, explorer | From the start (only needs research idea) |
| strategy | strategist, theorist | After Discovery (literature OR data assessment) |
| execution-data | data-engineer | After Strategy (approved strategy memo). Applied / mixed only. |
| execution-sim | simulation-engineer | After Strategy (approved theory memo). Theory / mixed only. |
| execution-code | coder | After Strategy (approved strategy memo) |
| execution-write | writer | After Code (approved code output) |
| peer-review | editor, domain-referee, methods-referee | After Execution (approved paper + code) |
| presentation | storyteller | After Write (approved paper) — can run parallel with Peer Review |
| submission | verifier | After Peer Review (editorial accept/minor + overall >= 95) |

## Phase Order

```
Discovery → Strategy → Execution → Peer Review → Submission
                                         ↕
                                   Presentation (parallel)
```

Re-entry is allowed for all phases except Submission (terminal). A referee comment can trigger re-entry at any prior phase.
