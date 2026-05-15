---
name: simulate
description: Run a Monte Carlo verifying a stated theorem's finite-sample behavior. Dispatches simulation-engineer to design and run the simulation, then simulation-engineer-critic to review the DGP coverage, MC error budget, and empirical-vs-asymptotic comparison. Theory or mixed mode.
argument-hint: "[theorem id or path] [--lang r|python|julia]"
allowed-tools: Read,Grep,Glob,Write,Edit,Bash,Task
---

# Simulate

Monte Carlo verification of an asymptotic claim. Dispatches:

```
  simulation-engineer (designs and runs the MC)
      |
      v
  simulation-engineer-critic (reviews 5 phases)
      |
      v  if score >= 80: persist
      v  if < 80: loop (max 3) → escalate to user or theorist
```

This is the theory-mode analogue of `/analyze` for empirical papers. Use it after `/prove` to verify finite-sample behavior of the proved result.

**Input:** `$ARGUMENTS` — theorem id or path to the theorem file, plus optional language flag.

---

## Prerequisites

- `PROJECT_TYPE: theory` or `mixed` in `CLAUDE.md`.
- A proved theorem exists (results.tex contains a full statement with proof).
- The theorem is an asymptotic claim that can be exercised by sample-size simulation:
  - Consistency
  - Rate (e.g., $\sqrt{n}$-consistency)
  - Limiting distribution
  - Coverage
  - Test size / power
  - Bootstrap validity

If the claim is purely an identification result with no estimator, exit with "Nothing to simulate."

---

## Workflow

### Step 0: Identify the claim
Read the theorem from `paper/sections/theorems/{slug}.tex` or `quality_reports/theory/{project}/results.tex`. Identify:
- Claim type
- Asymptotic limit (or rate)
- Estimator definition
- Assumption block

### Step 1: Language selection
Read `CLAUDE.md` for the project's analysis language. R by default; Python and Julia supported. Override with `--lang`.

Load the coding standards: `.claude/references/coding-standards-{r|python|julia}.md`.

### Step 2: Dispatch simulation-engineer
The simulation-engineer produces:
- Pre-Simulation Report (theorem, claim type, target quantity, DGPs, sample sizes, B, acceptance rule)
- Script: `scripts/simulations/sim_{slug}.{R|py|jl}`
- Tables: `paper/tables/sim/sim_{slug}_results.tex` (bare tabular per INV-13)
- Figures (optional Q-Q plots): `paper/figures/sim/sim_{slug}_qq.pdf`
- Summary: `quality_reports/sim/sim_{slug}_summary.md` with verdict line

The simulation must include at least:
- Favorable DGP (textbook conditions)
- Stress-test DGP (pushes against assumptions without violating)
- Sample-size grid spanning at least two orders of magnitude
- $B$ replications chosen for adequate MC SE
- Mandatory empirical-vs-asymptotic comparison table with MC SEs

See `.claude/references/simulation-protocol.md`.

### Step 3: Execute the simulation
Run the script end-to-end:

```bash
Rscript scripts/simulations/sim_{slug}.R
# or python3, julia
```

Capture exit code and verify expected output files exist. If execution fails, return to Step 2 (Strike 1 of 3).

### Step 4: Dispatch simulation-engineer-critic
5-phase review:
1. Claim identification — is the right claim being tested?
2. DGP coverage — favorable + stress + non-iid (if allowed)
3. MC error budget — $B$ sufficient, SE reported alongside every quantity
4. Empirical-vs-asymptotic comparison — distribution-level (quantiles / Q-Q), reported in MC SE units
5. Reproducibility and standards — INV-13 through INV-19

### Step 5: Escalation rules
- If score < 80 due to design issues (Phases 2–5): loop simulation-engineer (max 3 strikes).
- If Phase 1 says "wrong claim under test": escalate to **theorist** — theorem statement is ambiguous and needs clarification.
- If the simulation runs valid and shows **persistent mismatch at largest n**: escalate to **theorist** — the proof or limit may be wrong. Document in `quality_reports/sim/sim_{slug}_summary.md`.

---

## Verdict Format

Every successful run ends with a one-line verdict in `quality_reports/sim/sim_{slug}_summary.md`:

| Verdict | Meaning |
|---|---|
| **Matches** | All differences within 2 MC SE at every n and DGP |
| **Matches at large n only** | Mismatch shrinks as n grows; slow convergence; note in paper |
| **Persistent mismatch at largest n** | Critical — escalate to theorist |

---

## Output

```
scripts/simulations/sim_{slug}.{R|py|jl}
paper/tables/sim/sim_{slug}_results.tex
paper/figures/sim/sim_{slug}_qq.pdf       (optional)
quality_reports/sim/sim_{slug}_summary.md
quality_reports/sim/sim_{slug}_review.md  (critic report)
```

---

## When NOT to Run

- Pure identification claims with no estimator
- Comparative statics (verified analytically)
- Infeasible sample sizes ($n = 10^{12}$)
- The theorem failed `/prove` — fix the proof first

---

## Hand-off

After `/simulate` succeeds with verdict "Matches":
- Tables are ready for inclusion in the paper.
- The `/write` skill will pick up `paper/tables/sim/` automatically.

---

## Principles

- **Simulations verify finite-sample behavior of a stated claim — not the proof.**
- **MC SEs are non-negotiable.** Every reported quantity has an MC SE in the adjacent column.
- **At least two DGPs.** Favorable plus stress-test. Always.
- **A persistent mismatch at largest n is a CRITICAL finding.** Do not bury it.
