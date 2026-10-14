# Quality: Scoring, Thresholds, and Severity

---

## 1. Scoring Protocol

**How individual agent scores aggregate into the overall project score.**

### Weighted Aggregation

The overall project score that gates submission (>= 95) is a weighted aggregate. Each agent's QUALITY_WEIGHT is declared in `.claude/rules/permissions.md`.

The Orchestrator reads the registry to compute the weighted average:
- Sum each agent's critic score multiplied by its declared weight
- Theory weight applies only when the theorist agent was dispatched (see CONDITIONAL flag in `permissions.md`)
- If a component hasn't been scored, exclude it and renormalize remaining weights

### Minimum Per Component

No component can be below 80 for submission. A perfect literature review can't compensate for broken identification.

### Score Sources

- Each critic produces a score from 0 to 100 based on its deduction table
- Scores start at 100 and deduct for issues found
- The verifier is pass/fail (mapped to 0 or 100)
- Referee scores are averaged: `(domain-referee + methods-referee) / 2`

### Gate Thresholds

| Gate | Overall Score | Per-Component Minimum | Action |
|------|--------------|----------------------|--------|
| Commit | >= 80 | None enforced | Allowed |
| PR | >= 90 | None enforced | Allowed |
| Submission | >= 95 | >= 80 per component | Allowed |
| Below 80 | < 80 | — | Blocked |

### When Components Are Missing

Not every project uses all components. If a component hasn't been scored:
- It's excluded from the weighted average
- Remaining weights are renormalized
- Example: no literature review → weights become 11%, 28%, 17%, 28%, 11%, 6%

---

## 2. Severity Gradient

**Critics calibrate severity based on the phase of the project.**

### Phase-Based Severity

| Phase | Critic Stance | Rationale |
|-------|--------------|-----------|
| Discovery | Encouraging (low severity) | Early ideas need space to develop |
| Strategy | Constructive (medium severity) | Identification must be sound, but alternatives should be suggested |
| Execution | Strict (high severity) | Code and paper are near-final — bugs are costly |
| Peer Review | Adversarial (maximum severity) | Simulates real referees — no mercy |
| Presentation | Professional (medium-high) | Talks should be polished but scored as advisory |

### How It Works

The Orchestrator includes the severity level in the critic's prompt:

```
You are reviewing at SEVERITY: HIGH (Execution phase).
Flag all issues. Do not suggest "consider" — state what must change.
```

### Deduction Scaling

The same issue may have different deductions by phase:

| Issue | Discovery | Strategy | Execution | Peer Review |
|-------|-----------|----------|-----------|-------------|
| Missing citation | -2 | -5 | -10 | -15 |
| Notation inconsistency | -1 | -3 | -5 | -5 |
| Hedging language | — | — | -3 | -5 |
| Missing robustness check | — | -5 | -15 | -20 |

### Principle

Early phases are about getting the direction right. Late phases are about getting the details right. Critics should match their tone and rigor to the phase.

---

## 3. PROJECT_TYPE Weight Schedules

`CLAUDE.md` declares `PROJECT_TYPE: applied | theory | mixed`. The Orchestrator selects the weight schedule below. Component weights still live in `permissions.md` per-agent; this section governs which agents enter the aggregate and how their weights are reshuffled.

### PROJECT_TYPE: applied (default)

Use the weights declared in `permissions.md` directly. Theorist and simulation-engineer are not dispatched; their weights drop out and the remainder is renormalized per Section 1.

Typical applied composition:

| Component | Weight |
|---|---|
| Literature (librarian-critic) | 10% |
| Data (explorer-critic) | 10% |
| Strategy (strategist-critic) | 25% |
| Code (coder-critic) | 15% |
| Manuscript (writer-critic) | 10% |
| Referees (domain + methods) | 25% |
| Verifier | 5% |

### PROJECT_TYPE: theory

The theorist pair is dispatched; the applied data pipeline is not. The composition shifts toward proof completeness, assumption parsimony, and notation consistency.

| Component | Weight | Source |
|---|---|---|
| Proof completeness | 30% | theorist-critic |
| Assumption parsimony and tightness | 20% | assumption-auditor |
| Notation consistency | 10% | notation-warden |
| Novelty and literature placement | 15% | librarian-critic and domain-referee (averaged) |
| Exposition | 15% | writer-critic |
| Simulation evidence | 10% | simulation-engineer-critic (REALLOCATES to proof completeness if no simulation section is present) |

Notes:
- regularity-checker contributes deductions into the proof-completeness bucket via the theorist-critic's rubric — it does not have a separate weight.
- counterexample-hunter is not a weighted component; it is a binary gate (Section 4).
- derivation-verifier is advisory (mismatch ≠ paper wrong).

When no simulation is present, simulation-engineer-critic's 10% reallocates to theorist-critic, making proof completeness 40%.

### PROJECT_TYPE: mixed

Both schedules are active. Use this for theory papers with a Monte Carlo or an empirical illustration:

| Component | Weight |
|---|---|
| Proof completeness | 25% |
| Assumption parsimony | 15% |
| Notation consistency | 5% |
| Empirical strategy | 15% |
| Code (applied) | 10% |
| Simulation evidence | 10% |
| Manuscript | 10% |
| Referees | 10% |

If a section is absent (no simulation, no empirical illustration), reallocate proportionally to proof completeness.

### Renormalization

In all PROJECT_TYPE schedules: if a declared component has no critic score (because the agent was not dispatched), exclude it and renormalize the remaining weights to sum to 100. The Orchestrator computes this from `permissions.md` and the `PROJECT_TYPE` flag — no other file hardcodes the rule.

---

## 4. Hard Binary Submission Gates (Theory and Mixed Mode)

Independent of the weighted aggregate, the submission gate (overall >= 95) requires **all** of the following binary conditions when `PROJECT_TYPE` is `theory` or `mixed`:

1. **Every theorem proved.** Every theorem-like environment declared in the **compiled theory corpus** — for `panel-npiv-discrete` that is `quality_reports/theory/{project}/{assumptions_main, results_s2_identification, results_s3_estimation, results_s4_asymptotics, assumptions_supp, results_s3_supp, results_supp}.tex` — has a matching `\begin{proof}...\end{proof}` in `quality_reports/theory/{project}/proofs.tex`, keyed by `\label`. Definitions are exempt; they take no proof. Stubs and TODOs block the gate.

   > **REPOINTED 2026-08-03, AND THE OLD TARGET COULD FALSE-PASS.** This clause used to read
   > "every file under `paper/sections/theorems/*.tex`". That directory is a rendering from an
   > abandoned architecture (`paper/main.tex`, which does not exist); it is compiled by no
   > document and its contents are round-2 vintage against a corpus at dispatch 25. Because those
   > files *do* contain proofs, the gate would have **passed while inspecting the wrong artifact**
   > — worse than no gate, since it reports safety it never checked. Retired with a marker rather
   > than deleted; see `paper/sections/theorems/_SUPERSEDED.md`.
   >
   > **REPOINTED AGAIN 2026-08-05, WITH USER APPROVAL, AND THE FAILURE MODE THIS TIME WAS THE
   > MIRROR IMAGE.** The 2026-08-03 note said to gate on the undivided `results.tex`, on the
   > ground that it "feeds `scripts/build-theory/build.sh`" and the split is derived from it.
   > **That ground has since evaporated:** `scripts/build-theory/driver.tex` now `\input`s the
   > eight split files, and `build.sh:46` itself records `assumptions.tex` / `results.tex` as
   > RETIRED. The undivided files are today compiled by **no document at all** — precisely the
   > position `paper/sections/theorems/` was in when it was retired.
   >
   > The two copies have now diverged. `cor:a1cprim` was withdrawn on 2026-08-05, because its
   > hypothesis set is empty (A1 makes $\widetilde W$ conditionally centred, so A1d fails at
   > $\Lambda\equiv1$); the statement and its proof were removed together from the split and from
   > `proofs.tex`. `results.tex` still declares the corollary. **Gating on it would therefore FAIL
   > on a statement the paper no longer makes** — the mirror of 2026-08-03's false pass, and just
   > as uninformative: a gate that fails on an artifact nobody compiles reports danger it never
   > checked.
   >
   > **Gate on the compiled corpus.** The rule is now: gate on whatever set of files the shipped
   > documents actually `\input`, and never on a parallel copy, whichever direction the divergence
   > runs. `results.tex` and `assumptions.tex` are retained on disk — ~33 specs under
   > `scripts/symbolic/specs/` cite them by line number, and
   > `scripts/render-sync/check_rendering_sync.py:567` still reads `results.tex` as its source of
   > record — but they are **not** the gate target and are no longer the source of record for it.
   > Those two consumers are a known follow-up, recorded here rather than repaired silently.

2. **theorist-critic cleared.** The most recent theorist-critic score in the research journal is >= 80, with no unresolved CRITICAL findings.

3. **counterexample-hunter cleared.** The most recent `/audit --counter` (or `/audit --all`) run has no **confirmed counterexample**. A "probe captured by assumption" outcome is fine; a confirmed counterexample is a block until the theorem or assumption block is updated.

4. **No unresolved escalation.** The research journal shows no open escalation from the theorist or any narrow theory critic.

5. **(If simulation is present)** simulation-engineer-critic verdict is "Matches" or "Matches at large n only" — not "Persistent mismatch."

If any binary check fails, the submission gate is **blocked regardless of the aggregate weighted score.** The Verifier reports this explicitly in `quality_reports/verification_report.md` Section "Theory Binary Gates."

These checks are independent of the weighted aggregate so that a high overall score cannot mask a broken proof or an unresolved counterexample.
