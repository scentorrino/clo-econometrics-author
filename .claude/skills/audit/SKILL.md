---
name: audit
description: Batch run of notation-warden + assumption-auditor + regularity-checker across the whole paper's theory artifacts. Theory analogue of an applied robustness pass. Optional flags add counterexample-hunter and derivation-verifier sweeps.
argument-hint: "[--all] [--counter] [--derive] [path or theorem id]"
allowed-tools: Read,Grep,Glob,Write,Edit,Bash,Task
---

# Audit

Run a batch of theory-paper audits and produce a single consolidated report. The theory analogue of `/review --code` or an applied robustness check pass.

**Input:** `$ARGUMENTS` — optional flags and target path.

| Flag | What it adds |
|---|---|
| (none) | notation-warden + assumption-auditor + regularity-checker (the three mechanical critics) |
| `--all` | Also run counterexample-hunter and derivation-verifier on all derivations |
| `--counter` | Add counterexample-hunter only |
| `--derive` | Add derivation-verifier only (runs every spec under `scripts/symbolic/specs/`) |

If a target path is given, audits only that theorem or section. Otherwise audits everything under `paper/sections/theorems/` and `quality_reports/theory/{project}/`.

---

## Workflow

### Step 0: Discover artifacts
Walk:
- `paper/sections/theorems/` (recursively)
- `quality_reports/theory/{project}/` (results.tex, proofs.tex, assumptions.tex)

If none found, exit with: "No theory artifacts to audit. Run `/conjecture` and `/prove` first."

### Step 1: Dispatch the mechanical critics in parallel

Three Task calls in one message:

- **notation-warden** — receives all `.tex` files; produces `quality_reports/notation/notation-table.md`.
- **assumption-auditor** — receives `assumptions.tex` and `proofs.tex`; produces `quality_reports/assumptions/usage-matrix.md`.
- **regularity-checker** — receives `proofs.tex` and `assumptions.tex`; produces `quality_reports/regularity/regularity-audit.md`.

Each critic returns its scored report. The audit skill persists the reports at the paths above.

### Step 2: Conditional — counterexample-hunter (when --all or --counter)

Dispatch counterexample-hunter against each theorem in `results.tex`. Persist at `quality_reports/counterexamples/probe-results.md`.

**Any confirmed counterexample is a CRITICAL** — flagged in the consolidated report at top, with an explicit escalation to the user.

### Step 3: Conditional — derivation-verifier (when --all or --derive)

For each spec file under `scripts/symbolic/specs/`:
1. Run `python3 scripts/symbolic/verify.py <spec>`
2. Run `python3 scripts/symbolic/dim_check.py <spec>` if any matrix variables declared
3. Capture exit codes and stdout

Persist one report per spec at `quality_reports/derivations/verify-{claim_id}.md`. Aggregate at `quality_reports/derivations/summary-{date}.md`.

### Step 4: Consolidate

Produce a single consolidated report at `quality_reports/audit/audit-{YYYY-MM-DD}.md`:

```markdown
# Theory Audit — YYYY-MM-DD

## Summary
- Notation-warden: <score>/100 (<n> issues)
- Assumption-auditor: <score>/100 (<n> issues)
- Regularity-checker: <score>/100 (<n> issues)
- Counterexample-hunter: PASS / FAIL  (when --all or --counter)
- Derivation-verifier: <p>/(n) match  (when --all or --derive)

## Critical findings (escalations)
[List any confirmed counterexamples or DIM_MISMATCH errors.]

## Detailed reports
[Embedded or linked.]

## Action items
- [ ] [Issue from notation-warden] — File:Line
- [ ] [Issue from assumption-auditor] — Assumption tag
- [ ] [Issue from regularity-checker] — Proof step
```

### Step 5: Update dashboard

If `scripts/generate_dashboard.py` exists, run it to refresh the project dashboard with the new audit results.

---

## Empty-State Behavior

If no theory artifacts exist yet (fresh project), produce an empty audit report:

```markdown
# Theory Audit — YYYY-MM-DD

**Status:** No theory artifacts to audit.

Run `/conjecture [topic]` to draft a theorem, then `/prove` to fill in the proof.
This audit will populate once theory artifacts exist.
```

---

## Re-runnability

`/audit` can be run any time theory artifacts change. It is idempotent — running it twice in a row produces the same report (modulo the date). Use it:
- After every `/prove` round to catch fresh issues
- Before committing theory changes
- Before submission (paired with `/audit --all`)

---

## Principles

- **Audit reports are read-only critic output.** The skill persists them; the critics never write to source files.
- **A confirmed counterexample is a hard escalation.** Surface it at the top of the consolidated report.
- **SymPy mismatches are NOT errors.** Report them as "manual review required."
- **Empty is fine.** An audit with no artifacts produces an empty-state report, not an error.
