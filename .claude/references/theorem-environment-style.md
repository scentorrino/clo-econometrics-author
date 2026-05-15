# Theorem Environment Style

House style for stating mathematical results in theory papers. Loaded on demand by the theorist agent and by the writer when drafting a theory section. The theorist-critic and notation-warden check against these rules.

## Required Form for Formal Statements

Every theorem, proposition, lemma, and corollary follows this two-sentence pattern:

```
<Name> N. <One sentence describing the result.>
Suppose Assumptions <tag list> hold. Then <conclusion>.
```

Examples:

```
Theorem 1. The OLS estimator is consistent.
Suppose Assumptions A1–A3 hold. Then $\hat\beta \xrightarrow{p} \beta_0$.
```

```
Proposition 2. The semiparametric efficiency bound for $\theta_0$ is $V^*$.
Suppose Assumptions A1, A4, A5 hold. Then any regular asymptotically linear estimator of $\theta_0$ has asymptotic variance at least $V^* = \mathbb{E}[\psi_0 \psi_0^\top]$, where $\psi_0$ is the efficient influence function defined in equation (3.2).
```

## Rules

1. **Conditions invoked are listed by tag, not restated.** Write "Suppose A1–A3 hold," not "Suppose $X$ is iid, $\theta_0$ is interior to $\Theta$, and $f$ is twice continuously differentiable."

2. **Remarks come AFTER the proof, never inside the statement.** Use `\begin{remark}` immediately after the proof of the theorem the remark applies to. Do not put "Note that..." inside the statement.

3. **Corollaries explicitly reference the parent theorem.** "Corollary 1 (to Theorem 1)." or "It follows from Theorem 1 that..."

4. **One result per environment.** Do not pack two distinct claims into one Theorem. Split into Theorem 1 and Theorem 2 (or a Theorem with a Corollary).

5. **Number sequentially across the paper, by section.** Theorem 3.1, 3.2, 4.1. Or globally — but consistently.

6. **No proofs inside statements.** "Theorem N. The estimator is consistent because [proof sketch]" is wrong. Either it is a proof, or it is a statement; never both.

## LaTeX Environments (Standard Set)

Use `amsthm` with the project preamble's declarations:

```latex
\newtheorem{theorem}{Theorem}
\newtheorem{proposition}{Proposition}
\newtheorem{corollary}{Corollary}
\newtheorem{lemma}{Lemma}
\newtheorem{definition}{Definition}
\newtheorem{hyp}{Hypothesis}
\theoremstyle{remark}
\newtheorem*{remark}{Remark}
```

| Environment | Use for |
|---|---|
| `theorem` | Main results of the paper |
| `proposition` | Subsidiary results — narrower scope but still publication-worthy |
| `lemma` | Auxiliary results used in proofs of theorems / propositions |
| `corollary` | Direct consequences of a stated result |
| `definition` | Defining objects, parameters, classes |
| `hyp` (Hypothesis) | Null/alternative hypotheses for testing problems |
| `remark` | Comments, scope notes, special cases — placed after proofs |

The `hyp` environment is project-specific to econometrics — it lets you write `\begin{hyp}` for hypotheses without overloading `assumption`.

## Anti-Patterns

| Don't | Do |
|---|---|
| `\textbf{Theorem 1:} The estimator is consistent if...` | `\begin{theorem} Suppose A1–A3 hold. Then $\hat\theta \to \theta_0$. \end{theorem}` |
| Stating assumptions inline in the theorem statement | List by tag (A1, A2, …) and define the tags in the assumption block |
| Putting `\begin{remark}` inside the theorem | Place after the `\end{proof}` |
| "Theorem 1 (Main Theorem)." | Drop the parenthetical; Theorem 1 is the main theorem by position |
| Numbering theorems and propositions in separate sequences | Number them in one sequence, or under one shared counter (`\numberwithin{theorem}{section}`) |

## Pairing with the Assumption Block

Assumptions live in their own block at the start of the formal section. Format:

```latex
\paragraph{Assumptions.}
\begin{enumerate}
\item[\textbf{A1.}] (Sampling) $\{X_i\}_{i=1}^n$ are iid draws from $P$.
\item[\textbf{A2.}] (Moments) $\mathbb{E}\|X\|^2 < \infty$.
\item[\textbf{A3.}] (Identification) $\theta_0$ is the unique minimizer of $M(\theta)$ on $\Theta$.
\end{enumerate}
```

The bold tag (`\textbf{A1.}`) is what theorems reference. Keep the tags stable across drafts — renumbering breaks every theorem that cites by tag.
