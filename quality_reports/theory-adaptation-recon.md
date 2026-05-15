# Theory-Track Adaptation — Phase 0 Reconnaissance

**Date:** 2026-05-15
**Repo state:** `clo-author` at 26.05 (CHANGELOG.md). Cwd is `clo-econometrics-author` (local rename).
**Scope:** What every later phase needs to imitate.

---

## 1. File-Naming Conventions

| Artifact | Path | Filename | Case |
|---|---|---|---|
| Agent | `.claude/agents/` | `<role>.md` | kebab-case |
| Agent critic | `.claude/agents/` | `<role>-critic.md` | kebab-case |
| Skill | `.claude/skills/<name>/SKILL.md` | uppercase `SKILL.md` | folder kebab-case |
| Skill bundled assets | `.claude/skills/<name>/{templates,references,config}/` + `gotchas.md` | kebab-case | — |
| Rule | `.claude/rules/` | `<topic>.md` | kebab-case |
| Reference | `.claude/references/` | `<topic>.md` | kebab-case |
| Hook | `.claude/hooks/` | `<action>.{py,sh}` | kebab-case |
| Quality report | `quality_reports/<area>/<project>/` | various | mostly snake_case |
| Output | `paper/` (lowercase) | per content-standards.md | snake_case + path-scoped |

**Important deviation from spec:** spec uses `Paper/` and `Tables/sim/`; repo uses lowercase `paper/` and `paper/tables/`. The case rename was a 26.03.6 fix on macOS (CHANGELOG entry). All later phases must use lowercase.

---

## 2. Frontmatter Schemas

### 2.1 Agent (worker)

```yaml
---
name: <role>
description: <one sentence; appears in agent picker and via subagent_type lookup>
tools: Read, Write, Edit, Bash, Grep, Glob
model: inherit
---
```

### 2.2 Agent (critic) — read-only by construction

```yaml
---
name: <role>-critic
description: <one sentence including "Paired critic for the <worker>.">
tools: Read, Grep, Glob
model: inherit
---
```

The lack of `Write`/`Edit`/`Bash` is the mechanical guarantee that critics can never edit files — this enforces separation of powers from `agents.md` Section 2.

### 2.3 Skill

```yaml
---
name: <skill>
description: <description; trigger phrases here matter — agents pick skills by this string>
argument-hint: "[mode: a | b | c] [arg]"
allowed-tools: Read,Grep,Glob,Write,Edit,Bash,Task
---
```

Skills don't have a `model:` line. They have `argument-hint` and `allowed-tools` (comma-separated, no spaces — different from agents which use comma-space).

### 2.4 Rule / Reference

No frontmatter. Just `# Title` and prose.

---

## 3. Worker–Critic Pattern (Imitate This Exactly)

### Worker body structure
1. Opening line: `You are a **<role>** — <one-sentence role>.`
2. **"You are a CREATOR, not a critic."** sentence followed by who scores them.
3. Optional `## Your Task`
4. Optional `## Step 0: Classify Paper Type` (in agents that branch on type)
5. **Mandatory first output** — Pre-X Report. The Strategist has a Pre-Strategy Report; Coder has a Pre-Code Report; Theorist has a Pre-Theory Report.
6. `## Workflow` / stages
7. `## Task-Specific Resources` — bullet list pointing to skill folder paths (e.g. `strategize/templates/strategy-memo.md`). Files are loaded *on demand*, not eagerly. This is "progressive disclosure" (CHANGELOG 26.05).
8. `## Output` paths
9. `## What You Do NOT Do` — concrete negations.

### Critic body structure
1. `You are a **<role>** — <comparison to a top-journal referee or similar>. You are the **paired critic for the <worker>**.`
2. **"You are a CRITIC, not a creator."**
3. `## Cold-Read Protocol` — receives only artifact + rubric + severity + invariants; NOT round number / prior critic reports / research journal / worker intent. This is the cold-read guarantee from CHANGELOG 26.05.
4. `## Your Task` — N sequential phases or M check categories. Early-stop allowed when CRITICAL.
5. `## Task-Specific Resources` — pointers into `.claude/skills/review/templates/` and `.../config/scoring-rubrics.md` (the rubric is co-located with `/review`, not with the agent).
6. `## Standalone Mode` (if invoked by `/review`) — which category subset to run.
7. `## Three Strikes Escalation` — names the escalation target verbatim from `permissions.md`.
8. `## What You Do NOT Do` — starts with **"NEVER edit source files."**

---

## 4. Quality-Gate Scoring Mechanism

### Where weights live
**`.claude/rules/permissions.md`.** Every agent declares its `QUALITY_WEIGHT` field there. No other file hardcodes weights. The Orchestrator computes the aggregate by reading this file.

Current weights (sum to 100):

| Agent | Weight | Conditional |
|---|---|---|
| librarian-critic | 10% | — |
| explorer-critic | 10% | — |
| strategist-critic | 25% | — |
| theorist-critic | 20% | YES — only if paper has formal theory |
| coder-critic | 15% | — |
| writer-critic | 10% | — |
| domain-referee | 12.5% | — |
| methods-referee | 12.5% | — |
| storyteller-critic | Advisory | non-blocking |
| verifier | 5% | binary 0/100 |

Renormalization rule (`quality.md` §1): excluded components reduce the denominator; the rest are rescaled. The conditional flag for `theorist-critic` is the precedent for any other paper-type-aware weighting.

### Thresholds
- Commit: aggregate ≥ 80
- PR: aggregate ≥ 90
- Submission: aggregate ≥ 95 **and** every component ≥ 80

### Severity gradient (`quality.md` §2)
The Orchestrator passes a SEVERITY level (Discovery → Strategy → Execution → Peer Review → Presentation) to every critic. Deduction tables in critic templates scale by phase — same issue deducts more in Peer Review than in Discovery.

### Where scoring rubrics live
`.claude/skills/review/config/scoring-rubrics.md` (referenced by every critic via `## Task-Specific Resources`). The rubrics are not embedded in agent files.

---

## 5. Hooks That Touch Scoring or Commits

| Hook | Event | Behavior |
|---|---|---|
| `session-guard.py` | PreToolUse | Blocks Edit/Write outside `/freeze` paths, blocks destructive Bash under `/careful`. Reads `.claude/state/session-guards.json`. Pass-through if no guards active. |
| `pre-compact.py` | PreCompact | Reminds about checkpoint checklist. Does not block. |
| `post-compact-restore.py` | PostCompact | Restores recovery state pointer. |
| `post-edit-lint.sh` | PostToolUse | Wraps `lint-scripts.sh` on R/Python/Julia edits. Advisory (exit 0). |
| `lint-scripts.sh` | invoked by `/tools lint` and the post-edit hook | Grep-based linter, 20 checks, BSD grep -E. |
| `post-merge.sh` | git post-merge | Prompts reflection (not auto-write). |
| `protect-files.sh` | utility | File protection for `Bibliography_base.bib`, etc. |

**No hook touches quality scoring directly.** Scores are computed by the Orchestrator from critic reports. Hooks are PreToolUse / PostToolUse / PreCompact / PostCompact — no PostMessage-style scoring hook exists.

---

## 6. Spec vs. Repo: Structural Mismatches

The spec was written against an older `clo-author` baseline that lacked the 26.04 paper-type architecture and the 26.04.3 theorist pair. The repo has already absorbed roughly half of what the spec asks for, in a slightly different shape.

| Spec asks for | Repo state | Recommended adaptation |
|---|---|---|
| `proof-author` agent | `theorist` agent exists (87 lines, paper-type aware, 4 phases, calibrated to Econometrica/JoE/QE/AnnStat). The role is *broader* than "writing proofs" — it also writes assumptions, defines objects, and establishes identification. | **User chose Full reconciliation:** rename `theorist` → `proof-author` (and critic). Note: the broader scope is lost in the name. Alternative would have been to keep `theorist` and add `proof-author` as an alias. |
| `proof-critic` | `theorist-critic` exists (4-phase: claim type → proof validity → assumption minimality → citation+linkage). | Rename to `proof-critic`. |
| `simulation-engineer` agent | `coder` already advertises "Monte Carlo simulations" in description. | Add `simulation-engineer` as a thin specialization that delegates structurally to `coder`'s patterns. Critic = `simulation-engineer-critic` (modeled on `coder-critic`). |
| `data-engineer` move to `.claude/agents/applied/` | Currently at `.claude/agents/data-engineer.md`. | Move to `applied/`. Update `permissions.md` references. |
| `PROJECT_TYPE: applied\|theory\|mixed` flag in CLAUDE.md | Existing **paper-type** classification (reduced-form / structural / theory+empirics / descriptive) is *orthogonal* to PROJECT_TYPE — paper-type is about econometric design; PROJECT_TYPE is about pipeline mode. | Add PROJECT_TYPE as a new top-level flag. Don't remove paper-type. Theory mode in PROJECT_TYPE changes which agents are dispatched and which weight schedule applies; paper-type continues to drive section templates. |
| `.claude/commands/` directory | Doesn't exist. Skills live in `.claude/skills/<name>/SKILL.md`. | Create new "commands" as skills (`/conjecture`, `/prove`, `/audit`, `/simulate` → skill folders). |
| `Paper/sections/theorems/` | Repo uses `paper/sections/`. No `theorems/` subdir yet. | Create `paper/sections/theorems/` (lowercase). |
| `Tables/sim/` | Repo uses `paper/tables/`. No `sim/` subdir yet. | Create `paper/tables/sim/`. |
| Theoretical foundational references | Already in `.claude/references/domain-profile.md` under `## Theoretical Foundational References`. | Expand the template entries with the spec's reference list (van der Vaart, Newey & McFadden, BKRW, Pollard, vdV & Wellner, Andrews) as commented-out defaults users can uncomment. |
| `/strategize` theory mode | Already exists (`/strategize theory [target]`). Produces theory memo + assumptions.tex + results.tex + proofs.tex + notation_glossary.md — exactly the spec's wishlist. | No change to the dispatch; only update internal naming (theorist → proof-author). The strategist's proof-strategy memo (spec phase 1.3) is the existing theory_memo.md. |
| validate-bib for theory | `/tools validate-bib` checks cite-key cross-reference only; doesn't currently distinguish book vs. paper. | Add a `--theory` flag (or auto-detect via PROJECT_TYPE) that accepts books without DOIs and requires `edition`, `publisher`, `year`. |
| Bibliography file | Repo has `Bibliography_base.bib` at root; preamble uses `\addbibresource{references.bib}` (working-paper-format.md). | Both names coexist — the preamble is a template; project files use `Bibliography_base.bib`. New theory entries go there. |

### Net additions (genuinely new, no overlap)
- 5 narrow critics: `notation-warden`, `assumption-auditor`, `regularity-checker`, `counterexample-hunter`, `derivation-verifier`
- 6 style/protocol skills: `theorem-environment-style`, `proof-style`, `asymptotic-conventions`, `verify-derivation`, `latex-math-conventions`, `simulation-protocol`
- SymPy harness: `scripts/symbolic/verify.py`, `dim_check.py`, examples, README
- 4 orchestration skills: `/conjecture`, `/prove`, `/audit`, `/simulate`
- PROJECT_TYPE flag + theory weight schedule + binary submission gate (every theorem proved & counterexample-hunter clear)
- `paper/sections/theorems/` directory + `paper/tables/sim/`
- `docs/theory-track.md` walkthrough

### Net removals
- None. Applied behavior is preserved (per spec guardrail).

---

## 7. Files That Will Be Touched in Phase 1 Rename (`theorist` → `proof-author`)

10 files (excluding CHANGELOG.md historical entries which we leave intact):

```
.claude/agents/theorist.md             → .claude/agents/proof-author.md
.claude/agents/theorist-critic.md      → .claude/agents/proof-critic.md
.claude/skills/strategize/SKILL.md     (multiple references)
.claude/skills/review/SKILL.md         (--theory flag mention)
.claude/skills/new-project/SKILL.md    (conditional dispatch)
.claude/rules/permissions.md           (## theorist section, ESCALATION references)
.claude/rules/agents.md                (worker-critic table)
.claude/rules/quality.md               (weight schedule mentions)
.claude/references/domain-profile.md   (comments)
.claude/agents/guide-writer.md         (mention only)
```

Plus `.claude/skills/strategize/templates/theory-memo.md` (if present) and `gotchas.md` (theory-mode section).

CHANGELOG.md is intentionally NOT renamed — historical entries are immutable record.

---

## 8. Verification

Following the spec's Phase 0 exit criterion: reading this report should tell another instance (or me-in-the-future) exactly which template to imitate for each new artifact, which files Phase 1's rename touches, and where every structural mismatch is.

**Phase 0 exit:** PASS. Proceeding to Phase 1 with the recommended adaptations above.

---

## 9. Open Question for User (Optional)

Renaming `theorist` → `proof-author` *narrows* the name. The agent's actual scope (theorems, definitions, assumptions, identification results, proofs) is broader than "authoring proofs." If you want the name to stay `theorist` and we just *layer* the spec's new critics and skills on top, that's also coherent. The "Full reconciliation" choice you selected proceeds with the rename. If you want to reverse that one decision while keeping everything else, say "keep theorist" and I'll adjust Phase 1.
