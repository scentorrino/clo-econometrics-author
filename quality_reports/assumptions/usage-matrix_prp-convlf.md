# Assumption-Usage Matrix — Proposition `prp-convlf`

**Target:** Proposition `prp-convlf` (deterministic LF convergence), statement L439–446, proof L1022–1050.
**Date:** 2026-05-15. Reviewer: assumption-auditor agent.

## Section 1: Usage matrix

| Assumption / Condition | Statement | Cited at | Strength used | Status |
|---|---|---|---|---|
| `ass:identif` (L426–428) | $b_\dagger \in \mathcal{A}'_b$ + local identification | Implicit at L1050 ("by local identification") | Full | USED (implicit) |
| `ass:initcond` (L431–433) | $b_0 \in \mathcal{B}_{b_\dagger}$ | L1050 ("Assumption \ref{ass:initcond}") | Full | USED |
| `eq-lfconv` (L442) | $\|(\mathsf{T}'^*_{b_\dagger}\mathsf{T}'_{b_\dagger})(\mathsf{T}'^*_{b_j}\mathsf{T}'_{b_j})^{-1}\| \le 1/M_4$, $M_4 \ge 1$ | L1042–1045 | Full | USED — see flag 7 (boundary case $M_4 = 1$) |
| `ass:unifbd` (L259–267) | Uniform bounds | L1039 ("uses Assumption \ref{ass:unifbd}") | Invoked for L1035→L1037 step | UNDER-STATED |
| `ass:condcomp` (L209–225) | Conditional completeness | Not cited; injectivity at $b_j$ used at L1050 | At $b_\dagger$, not $b_j$ | UNDER-STATED |
| `ass:sourcecond`, `ass:linkcond`, `ass:frediff`, `ass:rateconv`, etc. | Various | Not cited | Not needed for convergence | UNUSED (correctly) |

## Section 2: Findings

### UNUSED — none in the named hypotheses.

The auxiliary later assumptions (`ass:sourcecond`, `ass:linkcond`, `ass:frediff`, `ass:rateconv`, `ass:restrvarth`, `ass:app*`) are not invoked — correctly so, since this is a pure convergence statement, not a rate statement.

### OVER-STRONG — none.

### UNDER-STATED — three significant items.

**(a) Injectivity of $\mathsf{T}'_{b_j}$ at the iterate (L1050).** The proof writes "the second negative term is strictly negative unless $b_j = b_\dagger$ (by the injectivity of $\mathsf{T}'_{b_j}$)." `ass:condcomp` via prp-onetoone(ii) delivers injectivity at $b_\dagger$, not at iterates. Either route through `eq-lfconv` (which presupposes invertibility) or extend `ass:condcomp` explicitly.

**(b) L1037 inequality** $\|\mathsf{T}(b_j) - \mathsf{T}'_{b_j}(b_j - b_\dagger)\|^2 \le \|\mathsf{T}'_{b_\dagger}(b_j - b_\dagger)\|^2$. Pointer to "as in the proof of prp-onetoone" is opaque. prp-onetoone(iii) gives $\|\mathsf{T}(b) - \mathsf{T}'_{b_\dagger}(b - b_\dagger)\| \le M\|b - b_\dagger\|^2$ — different LHS, different RHS. The step requires mean-value theorem + Lipschitz of $b \mapsto \mathsf{T}'_b$ (delivered by L982–984) + `def-sourceID` to convert $M\|b-b_\dagger\|^2$ to $\|\mathsf{T}'_{b_\dagger}(b-b_\dagger)\|$. None spelled out.

**(c) Step-size condition $c\|\mathsf{A}^*_b\mathsf{A}_b\| < 1$.** Acknowledged at L401 as a practical implementation point, but NOT in `prp-convlf`'s named hypotheses. Required for the square-completion at L1034 to be valid (positivity of $I - c\mathsf{A}\mathsf{A}^*$).

## Section 3: Score

| Type | Count | Deduction |
|---|---|---|
| UNUSED | 0 | 0 |
| OVER-STRONG | 0 | 0 |
| UNDER-STATED | 3 (injectivity at iterate; L1037 chain; step-size threshold) | -24 |

**Score: 76 / 100.**

## Section 4: Verdict

The assumption block for `prp-convlf` is mostly tight: every named hypothesis is invoked, and the auxiliary assumptions for rates / Fréchet differentiability / stochastic apparatus are correctly absent. The three under-statements all concern proof-mechanic conditions that the theorist invokes silently:

1. **Injectivity at the iterate** — `ass:condcomp` only delivers injectivity at $b_\dagger$. The cleanest fix is to acknowledge that `eq-lfconv` subsumes this (since $(\mathsf{T}'^*_{b_j}\mathsf{T}'_{b_j})^{-1}$ presupposes invertibility), and re-source the citation at L1050.

2. **L1037 inequality** — the constant-1 form requires a non-trivial chain (mean-value + Lipschitz + source condition), not a direct application of prp-onetoone(iii). The "as in the proof of prp-onetoone" pointer is too compressed.

3. **Step-size threshold** — the proposition needs to state $c\|\mathsf{A}^*_b\mathsf{A}_b\| < 1$ (or equivalently the L403 deterministic bound) as a hypothesis, not leave it to the surrounding implementation discussion. Without this, positivity of $I - c\mathsf{A}\mathsf{A}^*$ at L1034 fails and the proof collapses.

None is fatal — each is a one-line patch in the hypothesis block or the proof. **Score 76 sits just below the 80 commit gate.**
