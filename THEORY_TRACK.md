# Theory Track

A second pipeline for theoretical-econometrics papers. Activates when `PROJECT_TYPE: theory` (or `mixed`) is set in `CLAUDE.md`. The applied pipeline (data-engineer, coder, writer) continues to work for `PROJECT_TYPE: applied`.

## What's New

### Agents (kept + added)

The pre-existing `theorist` and `theorist-critic` pair (added in 26.04.3) continues to handle assumptions, theorems, and proofs. Theory mode adds:

| Agent | Role |
|---|---|
| **simulation-engineer** | Worker. Writes Monte Carlo verifying asymptotic claims. |
| **simulation-engineer-critic** | Reviews DGP coverage, MC error budget, empirical-vs-asymptotic comparison. |
| **notation-warden** | Read-only. Audits symbol consistency across the paper. |
| **assumption-auditor** | Read-only. Builds assumption-usage matrix; flags unused / over-strong / unstated. |
| **regularity-checker** | Read-only. Catches silently invoked regularity conditions. |
| **counterexample-hunter** | Read-only. Adversarial probes at boundary, degenerate, weak-ID, etc. |
| **derivation-verifier** | Symbolic verification via SymPy. |

The applied `data-engineer` moves to `.claude/agents/applied/` — kept for `PROJECT_TYPE: applied|mixed`, not dispatched for pure theory.

### Skills

| Skill | What it does |
|---|---|
| `/conjecture <topic>` | Strategist (proof-strategy mode) produces a scoping memo; drafts theorem stub. |
| `/prove <theorem>` | Iterative loop: theorist → theorist-critic → regularity-checker + derivation-verifier → counterexample-hunter. Max 3 strikes. |
| `/audit [flags]` | Batch run of notation-warden + assumption-auditor + regularity-checker. `--counter` adds counterexample-hunter; `--derive` runs SymPy verifications. |
| `/simulate <theorem>` | Simulation-engineer + critic. Mandatory empirical-vs-asymptotic comparison with MC SEs. |

`/write` is also updated to route files under `paper/sections/theorems/` to the theorist (not the writer).

### References (style guides, on-demand)

- `.claude/references/theorem-environment-style.md`
- `.claude/references/proof-style.md`
- `.claude/references/asymptotic-conventions.md`
- `.claude/references/latex-math-conventions.md`
- `.claude/references/verify-derivation.md`
- `.claude/references/simulation-protocol.md`

### Tooling

`scripts/symbolic/` — SymPy CLI for symbolic verification:

```bash
pip install sympy pyyaml
python3 scripts/symbolic/verify.py scripts/symbolic/examples/score-gaussian.yaml
python3 scripts/symbolic/dim_check.py scripts/symbolic/examples/ols-matrix-shape.yaml
```

Four runnable examples ship with the harness.

### Quality gates

`.claude/rules/quality.md` §3 — three weight schedules (applied / theory / mixed) selected by `PROJECT_TYPE`. Theory mode:

| Component | Weight |
|---|---|
| Proof completeness | 30% |
| Assumption parsimony | 20% |
| Notation consistency | 10% |
| Novelty and lit placement | 15% |
| Exposition | 15% |
| Simulation evidence | 10% (reallocates to proof if absent) |

§4 — five hard binary submission gates independent of the weighted aggregate:

1. Every theorem under `paper/sections/theorems/` has a proof
2. theorist-critic latest score >= 80, no open CRITICAL
3. No confirmed counterexample from counterexample-hunter
4. No unresolved escalation
5. (If simulation present) verdict not "Persistent mismatch"

Any failure blocks submission regardless of the aggregate score.

---

## Worked Example: WLLN for the Sample Mean

Start with a trivial conjecture: the sample mean of iid integrable random variables converges in probability to the population mean.

### Step 1 — Set PROJECT_TYPE

In `CLAUDE.md`:

```
**PROJECT_TYPE:** theory
```

### Step 2 — `/conjecture`

```
/conjecture sample-mean WLLN
```

Strategist (proof-strategy mode) produces `quality_reports/strategy/{project}/proof_strategy_memo.md`:

```markdown
**Conjecture:** Under iid sampling with finite first moment,
  the sample mean converges in probability to the population mean.
**Target object:** Consistency (in probability).
**Toolkit:** Classical (Chebyshev variance bound or characteristic functions).
  Weak LLN under iid + integrability — covered by van der Vaart §2.1.
**Key intermediate lemmas:** None; the result is itself a textbook lemma.
**Anticipated obstacles:** None for the stated form.
  If second moments are not finite, the proof via Chebyshev fails — Khinchin's
  WLLN under just integrability is the right path.
**Fallback weaker claims:** Convergence along a subsequence (a.s.) is automatic
  given the WLLN — note as a remark.
```

The strategist-critic clears the memo. A theorem stub is drafted at `paper/sections/theorems/wlln.tex`:

```latex
\begin{theorem}\label{thm:wlln}
The sample mean of iid integrable random variables is consistent.
Suppose Assumptions A1--A2 hold. Then $\bar X_n \xrightarrow{p} \mathbb{E}[X]$.
\end{theorem}
```

And the assumption block (`quality_reports/theory/{project}/assumptions.tex`):

```latex
\textbf{A1.} (Sampling) $\{X_i\}_{i=1}^n$ are iid draws from $P$.
\textbf{A2.} (Integrability) $\mathbb{E}|X| < \infty$.
```

### Step 3 — `/prove`

```
/prove paper/sections/theorems/wlln.tex
```

The theorist drafts the proof (Khinchin's WLLN via characteristic functions). theorist-critic clears the proof at score 92. regularity-checker confirms only first-moment finiteness is invoked. counterexample-hunter probes:

- *Cauchy distribution.* Captured by A2 (Cauchy has no first moment).
- *Atom at $x_0$.* Trivially confirms; degenerate distribution is allowed.
- *Heavy tail with $\mathbb{E}|X|^{1.5} = \infty$.* Captured — but only barely; $\mathbb{E}|X|$ can be infinite even when fractional moments are finite. The probe is correctly captured by A2.

`/prove` succeeds. The full theorem + proof is now in `paper/sections/theorems/wlln.tex`.

### Step 4 — `/audit`

```
/audit
```

Three reports:
- `quality_reports/notation/notation-table.md` — clean.
- `quality_reports/assumptions/usage-matrix.md` — A1 and A2 both used; no violations.
- `quality_reports/regularity/regularity-audit.md` — Khinchin's WLLN invocation is cited correctly.

Consolidated report: `quality_reports/audit/audit-<date>.md` reports PASS.

### Step 5 — `/simulate`

```
/simulate paper/sections/theorems/wlln.tex
```

simulation-engineer designs:
- DGP 1 (favorable): iid $N(0, 1)$
- DGP 2 (stress): iid $t_{1.5}$ (finite first moment, infinite variance — A2 holds, but heavier tails than usual)

Sample-size grid $n \in \{50, 200, 1000, 5000, 20000\}$, $B = 2000$ replications. Verdict: **Matches.** $\mathbb{E}[\bar X_n]$ is at the mean within MC SE, and $\Pr(|\bar X_n - 0| > \epsilon) \to 0$ at every $n$.

simulation-engineer-critic flags one MINOR: the WLLN gives consistency, not a rate. A rate-style normalization $\sqrt{n}$ would be appropriate only if the theorem claimed asymptotic normality (which it doesn't). The critic suggests adding a remark to the paper noting the simulation verifies the rate of the strengthened CLT, not the WLLN itself.

### Step 6 — `/audit` re-run

```
/audit
```

Clean. No new issues. Ready to `/write` the introduction + results sections and proceed to `/review --peer`.

### Submission gate

When the manuscript is otherwise ready and the user runs `/submit`:

1. Weighted aggregate (theory schedule) computed — proof completeness 30, etc.
2. Binary gates TG1–TG5 checked:
   - TG1 ✓ wlln.tex has a proof
   - TG2 ✓ theorist-critic at 92
   - TG3 ✓ no confirmed counterexample
   - TG4 ✓ no open escalation
   - TG5 ✓ simulation verdict "Matches"
3. If aggregate >= 95 and all binary gates PASS, submission allowed.

---

## Switching modes

A user with `PROJECT_TYPE: applied` who wants to add a theory section flips to `mixed`. Both pipelines activate. Quality weights split per `quality.md §3`. The applied pipeline (data-engineer, coder, writer) continues to run unchanged for the empirical part.

A user with `PROJECT_TYPE: theory` who never plans to run a simulation has the simulation-evidence weight (10%) reallocated to proof completeness (30 → 40%). No manual intervention needed — the renormalization is computed from `permissions.md` and the `PROJECT_TYPE` flag.

---

## Limitations and future work

- The SymPy harness is incomplete. Many true identities (trigonometric, conditional, special-function) lie outside its decision procedures. A mismatch is *always* "manual review required," not "paper is wrong."
- The counterexample-hunter is heuristic. It probes standard failure modes — boundary, degenerate, heavy tails, weak ID — but does not exhaustively explore the assumption manifold. A clean report does not prove the theorem holds; it only means the standard probes failed.
- The five narrow critics are read-only and unpaired. They produce reports; they never edit files. The skills that dispatch them are responsible for persistence.
- Quality weights are heuristics. They are not calibrated to journal-specific weighting of proof completeness vs exposition. Override per-project via `permissions.md` if needed.

---

## References

- `Theory_adaptation.md` — the master spec this implementation follows.
- `quality_reports/theory-adaptation-recon.md` — Phase 0 reconnaissance against the actual repo state.
- `.claude/rules/quality.md` §3–§4 — weight schedules and binary gates.
- `.claude/agents/{theorist,simulation-engineer,notation-warden,assumption-auditor,regularity-checker,counterexample-hunter,derivation-verifier}.md` — agent definitions.
- `.claude/skills/{conjecture,prove,audit,simulate}/SKILL.md` — orchestration skills.
- `scripts/symbolic/README.md` — symbolic-verification harness.
