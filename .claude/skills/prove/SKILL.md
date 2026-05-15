---
name: prove
description: Iterative proof workflow. Dispatches theorist to draft a proof, then theorist-critic to score it, then regularity-checker and derivation-verifier to audit, then counterexample-hunter to attack. Loops with strike count until all clear or escalation. Theory mode only.
argument-hint: "[path to theorem stub OR theorem identifier]"
allowed-tools: Read,Grep,Glob,Write,Edit,Bash,Task
---

# Prove

Iterative proof workflow for theory papers. Sequences five agents through up to 3 rounds:

```
  theorist (drafts proof)
      |
      v
  theorist-critic (scores proof validity)
      |
      v  if score >= 80
      v
  +-> regularity-checker (audits silent regularity gaps)
  |   derivation-verifier (audits algebraic derivations)   <-- in parallel
  +-> counterexample-hunter (attacks at boundary cases)
      |
      v  if any flags CRITICAL
      |
      +--> back to theorist (max 3 rounds total)
      |
      v  all clear
  Final: theorem + proof + remarks saved
```

**Input:** `$ARGUMENTS` — path to a theorem stub (typically `paper/sections/theorems/{slug}.tex`) or a theorem identifier.

---

## Prerequisites

- `PROJECT_TYPE: theory` or `mixed` in `CLAUDE.md`.
- A theorem stub exists (produced by `/conjecture`).
- A proof-strategy memo exists at `quality_reports/strategy/{project}/proof_strategy_memo.md` with score >= 80.
- Assumption block at `quality_reports/theory/{project}/assumptions.tex` is non-empty.

If any prerequisite is missing, stop and direct the user to `/conjecture` first.

---

## Workflow

### Round 1: Initial draft

#### Step 1: Theorist drafts the proof
Dispatch the theorist agent with:
- The theorem stub
- The proof-strategy memo (scopes the toolkit and intermediate lemmas)
- The assumption block
- `.claude/references/proof-style.md`, `.claude/references/asymptotic-conventions.md`, `.claude/references/theorem-environment-style.md`

The theorist produces / updates:
- `quality_reports/theory/{project}/proofs.tex` — the proof
- `quality_reports/theory/{project}/results.tex` — full theorem block (statement + proof)
- `quality_reports/theory/{project}/notation_glossary.md`
- Adds any new lemmas / definitions invoked

#### Step 2: Theorist-critic scores
4-phase review per `.claude/agents/theorist-critic.md`:
1. Claim identification
2. Proof validity (early-stop on critical gaps)
3. Assumption minimality + notation consistency
4. Citation fidelity + linkage + polish

If score < 80, return to Step 1 (this is Round 1 of three-strikes). At Strike 3, escalate to user.

#### Step 3: Narrow critics in parallel
Once theorist-critic clears (score >= 80), dispatch in parallel:

- **regularity-checker** — flags silently invoked regularity conditions (DCT, Fubini/Tonelli, uniform convergence, parameter on boundary)
- **derivation-verifier** — for any multi-line algebraic derivation the theorist used, write a spec at `scripts/symbolic/specs/` and run `python3 scripts/symbolic/verify.py`. Report MATCH / MISMATCH / DIM_MISMATCH.

#### Step 4: Counterexample-hunter
Adversarial probes against each theorem under review. For each probe, the hunter reports:
- Confirmed counterexample → **CRITICAL** → return to theorist with the counterexample (Strike count +1)
- Probe captured by stated assumption → strengthens confidence
- Probe captured by unstated assumption → flag a missing condition for the theorist to add

#### Step 5: Decision
- If counterexample-hunter found a confirmed counterexample: loop back to theorist with the specific probe. Strike count +1. Max 3 strikes, then escalate to user.
- If regularity-checker found CRITICAL gaps: loop back to theorist to either justify or strengthen assumption block.
- If derivation-verifier reports MISMATCH: flag for manual review, do not block (SymPy is incomplete).
- If derivation-verifier reports DIM_MISMATCH: this is a hard error — loop back to theorist.
- If all clear: persist final artifacts and exit.

### Loop control

- Maximum 3 rounds.
- If Round 3 still has CRITICAL findings, escalate to user with a structured summary of remaining issues.
- Always log Strike count in `quality_reports/research_journal.md`.

---

## Output

```
quality_reports/theory/{project}/results.tex
quality_reports/theory/{project}/proofs.tex
quality_reports/theory/{project}/proofs_review.md       (consolidated)
quality_reports/regularity/regularity-audit.md
quality_reports/counterexamples/probe-results.md
quality_reports/derivations/verify-{claim_id}.md  (one per derivation checked)
quality_reports/theory/{project}/notation_glossary.md   (updated)
```

After `/prove` completes successfully, also update `paper/sections/theorems/{slug}.tex` to include the full statement + proof + any remarks. Remarks go AFTER the proof per `.claude/references/theorem-environment-style.md`.

---

## Hand-off

After `/prove` completes:
- Run `/audit` to consolidate notation / assumption / regularity audits.
- Run `/simulate <theorem>` to verify finite-sample behavior (if the theorem is an asymptotic claim).

---

## Principles

- **The narrow critics are unpaired.** They report; they never edit files.
- **A SymPy mismatch is not a proof of error.** Treat as manual review required.
- **A confirmed counterexample IS a hard error.** Block the gate until the theorem is restated or the assumption block is tightened.
- **Three strikes, then escalate.** Don't loop indefinitely. The user adjudicates.
- **Remarks belong after the proof.** Scope notes, special cases, weaker forms — these go in `\begin{remark}` blocks placed after `\end{proof}`.
