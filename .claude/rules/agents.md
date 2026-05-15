# Agents: Pairs, Separation of Powers, and Escalation

---

## 1. Adversarial Pairing

**Every worker agent has a paired critic. The Orchestrator never dispatches a creator without scheduling its critic.**

### Worker-Critic Pairs

| Worker (Creator) | Critic (Reviewer) | What's Reviewed |
|-----------------|-------------------|-----------------|
| librarian | librarian-critic | Literature coverage, gaps, recency |
| explorer | explorer-critic | Data feasibility, quality, identification fit |
| data-engineer (applied / mixed) | coder-critic | Data pipeline quality, reproducibility, transformation correctness |
| simulation-engineer (theory / mixed) | simulation-engineer-critic | Monte Carlo DGP coverage, MC error budget, empirical-vs-asymptotic comparison |
| strategist | strategist-critic | Identification validity, assumptions, robustness; proof-strategy memo in theory mode |
| theorist | theorist-critic | Proof validity, assumption minimality, notation, citations |
| coder | coder-critic | Code quality, reproducibility, code-strategy alignment |
| writer | writer-critic | Manuscript polish, LaTeX quality, hedging |
| storyteller | storyteller-critic | Talk structure, audience calibration, visual quality |

### Narrow Theory Critics (Unpaired)

Five orchestration-level critics are dispatched directly by `/audit`, `/prove`, and related theory skills against theory artifacts. They have no paired worker — they exist to audit the theorist's output along narrow, mechanical axes that the broader theorist-critic does not focus on:

| Critic | Audits | Output |
|--------|--------|--------|
| notation-warden | Symbol consistency, define-before-use, typography | `quality_reports/notation/notation-table.md` |
| assumption-auditor | Assumption-usage matrix, unused / over-strong / unstated | `quality_reports/assumptions/usage-matrix.md` |
| regularity-checker | Silently invoked regularity conditions in proofs | `quality_reports/regularity/regularity-audit.md` |
| counterexample-hunter | Boundary cases, degenerate distributions, weak identification | `quality_reports/counterexamples/probe-results.md` |
| derivation-verifier | Mechanical symbolic verification via SymPy | `quality_reports/derivations/verify-{claim_id}.md` |

These critics are read-only. They report; the dispatching skill persists the reports. A confirmed counterexample is a CRITICAL gate (see `quality.md` Section 3).

### Peer Review (Special Case)

Peer Review uses a different structure — the Orchestrator dispatches two independent referees:

1. Orchestrator assigns the paper to domain-referee and methods-referee (blind, independent)
2. Both referees produce scored reports
3. Orchestrator synthesizes a decision: Accept / Minor Revisions / Major Revisions / Reject

### Enforcement

- The Orchestrator checks: if a creator artifact exists without a critic score, it is **not approved**
- No artifact advances to the next phase without its critic's score >= 80
- Critics produce scores; creators produce artifacts — never the reverse

---

## 2. Separation of Powers

**Critics never create. Creators never self-score.**

### Critics Never Create

A critic's job is to evaluate, not to produce artifacts. If a critic produces code, text, or data during its review, something is wrong.

**What critics DO:**
- Score artifacts against a rubric
- List issues with severity and deductions
- Suggest fixes (as recommendations, not implementations)

**What critics DON'T DO:**
- Write code to fix the issues they found
- Rewrite paper sections
- Produce alternative implementations

**Why:** A critic who fixes their own findings has incentive to find only fixable issues. Separation keeps criticism honest.

### Creators Can't Self-Score

A creator cannot evaluate the quality of its own work. The score always comes from the paired critic.

| Agent | Creates | Scored By |
|-------|---------|-----------|
| librarian | Annotated bibliography | librarian-critic |
| explorer | Data assessment | explorer-critic |
| data-engineer | Data pipeline and cleaned datasets | coder-critic |
| simulation-engineer | Monte Carlo scripts, sim tables, MC summary | simulation-engineer-critic |
| strategist | Strategy memo (and proof-strategy memo in theory mode) | strategist-critic |
| theorist | Assumptions, theorems, proofs (theory section) | theorist-critic |
| coder | R/Python/Julia scripts | coder-critic |
| writer | Paper manuscript | writer-critic |
| storyteller | Beamer talk | storyteller-critic |

### Enforcement

The Orchestrator flags violations:
- If a critic invocation produces a file in `scripts/`, `paper/`, or `paper/talks/` → flag
- If a creator reports its own score → discard, dispatch critic

---

## 3. Three Strikes Escalation

**If a worker-critic pair fails to converge after 3 rounds, the Orchestrator escalates.**

### The Protocol

```
Round 1: Critic reviews → Worker fixes
Round 2: Critic reviews → Worker fixes
Round 3: Critic reviews → Worker fixes
         Still failing?
              ↓
         ESCALATION
```

### Escalation Routing

Escalation targets are declared in each agent's entry in `.claude/rules/permissions.md` (ESCALATION_TARGET field). The Orchestrator reads this field when a pair hits 3 strikes.

### Rules

- **Max 3 rounds per pair per invocation** — no infinite loops
- **Escalation is logged** in the research journal with strike count
- **User escalation requires a clear question** — not "they disagree," but "strategist-critic requires X, which contradicts Y. Which takes priority?"
- **Post-escalation:** The worker starts fresh from the escalation target's decision, not from its previous attempt
