---
name: conjecture
description: Formalize a research conjecture into a draft theorem statement and an accompanying proof-strategy memo. Dispatches the strategist (in proof-strategy mode) to scope the proof, then drafts a theorem-statement stub (no proof yet — that comes from /prove). Theory mode only.
argument-hint: "[conjecture text or path to research spec]"
allowed-tools: Read,Grep,Glob,Write,Edit,Bash,Task
---

# Conjecture

Formalize a research conjecture into a draft theorem statement. Produces two artifacts:

1. **Proof-strategy memo** — the strategist's scoping document (conjecture, target object, toolkit, intermediate lemmas, anticipated obstacles, fallback claims). Saved at `quality_reports/strategy/{project}/proof_strategy_memo.md`.
2. **Theorem stub** — a LaTeX file at `paper/sections/theorems/{slug}.tex` containing the formal statement only. No proof yet.

This is the entry point to the theory pipeline. Hand the output to `/prove` to actually prove the theorem.

**Input:** `$ARGUMENTS` — the conjecture text, or a path to a research spec / theory memo that the conjecture is drawn from.

---

## Workflow

### Step 0: Verify project type
Read `CLAUDE.md`. The project's `PROJECT_TYPE` must be `theory` or `mixed`. If `applied`, stop and ask the user to update the flag.

### Step 1: Gather context
Read in parallel:
- `.claude/references/domain-profile.md` — Theoretical Foundational References table
- `.claude/references/theorem-environment-style.md` — required two-sentence form
- `.claude/references/asymptotic-conventions.md` — mode-of-convergence vocabulary
- Any existing `quality_reports/theory/{project}/` artifacts

### Step 2: Dispatch strategist (proof-strategy mode)
The strategist produces a proof-strategy memo with required sections:
- Conjecture (one sentence)
- Target object (consistency / rate / limiting distribution / efficiency / boundary / test)
- Toolkit (M-estimation, GMM, sieve, empirical process, etc.)
- Key intermediate lemmas
- Anticipated obstacles
- Fallback weaker claims

See `.claude/agents/strategist.md` § "Proof-Strategy (Theory / Methods paper)".

Save memo to `quality_reports/strategy/{project}/proof_strategy_memo.md`.

### Step 3: Dispatch strategist-critic (Mode 3: Proof-Strategy Review)
Review the memo through the proof-strategy rubric:
- Conjecture clarity
- Target-object fit
- Toolkit selection
- Lemma sufficiency
- Obstacle realism
- Fallback design

If score < 80, loop strategist → strategist-critic (max 3 rounds).

### Step 4: Draft the theorem statement stub
With the proof-strategy memo approved, draft the bare theorem statement (no proof yet) using the required two-sentence form:

```
\begin{theorem}\label{thm:slug}
<One sentence describing the result.>
Suppose Assumptions <tag list> hold. Then <conclusion>.
\end{theorem}
```

Save to `paper/sections/theorems/{slug}.tex`. Update `paper/main.tex` with an `\input{}` if needed (only after user confirmation).

Also append the required assumptions to `quality_reports/theory/{project}/assumptions.tex` (creating the file if missing). Tag them clearly — the assumption-auditor will check usage in /prove.

### Step 5: Save decision record
Append to `quality_reports/decisions/conjecture_{slug}.md` using `templates/decision-record.md`:
- **Decision:** the conjecture as formalized
- **Alternatives:** weaker / stronger statements considered
- **Why rejected:** for each alternative, the reason
- **Open issues:** what /prove will need to settle

---

## Output

```
quality_reports/strategy/{project}/proof_strategy_memo.md
quality_reports/strategy/{project}/proof_strategy_memo_review.md
quality_reports/theory/{project}/assumptions.tex
quality_reports/decisions/conjecture_{slug}.md
paper/sections/theorems/{slug}.tex
```

---

## Hand-off to /prove

After `/conjecture` completes, run:

```
/prove paper/sections/theorems/{slug}.tex
```

`/prove` consumes the theorem stub and the proof-strategy memo, then drives the iterative proof loop.

---

## Principles

- **Conjecture before proof.** A clear conjecture is half the work; scoping it formally prevents the theorist from generating a proof for the wrong claim.
- **The proof-strategy memo is a contract.** Once approved, it constrains the theorist — they prove what was scoped, not whatever is convenient.
- **Theorem statement is bare.** The proof comes from /prove, not from /conjecture. Don't generate proofs here.
- **Assumptions are tagged early.** Once the assumption block exists, every later theorem cites by tag (A1, A2, …).
