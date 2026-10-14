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

The declarations live in `paper/preambles/preamble.tex`. That file is the implementation of record — it is compile-verified, and this section describes it rather than the other way round.

```latex
\usepackage{aliascnt}   % shared counters that cleveref can still name

\theoremstyle{plain}
\newtheorem{theorem}{Theorem}

\newaliascnt{proposition}{theorem}
\newtheorem{proposition}[proposition]{Proposition}
\aliascntresetthe{proposition}
% ... lemma, corollary, definition, remark declared the same way ...

\newtheorem{hyp}{Hypothesis}          % own sequence — see below
\theoremstyle{definition}
\newtheorem*{assumption}{Assumption}  % unnumbered — see below

\crefname{lemma}{Lemma}{Lemmas}       % one \crefname per aliascnt environment
```

**One shared sequence.** `theorem`, `proposition`, `lemma`, `corollary`, `definition` and `remark` all advance the `theorem` counter, so Result 7 is Result 7 wherever it appears. This is what the anti-pattern table below requires; an earlier version of this section showed six independent counters and contradicted it.

**Why `aliascnt` and not the plain `\newtheorem{lemma}[theorem]{Lemma}` form.** cleveref names a reference from the **counter** it was made against, not from the environment. Under the plain shared-counter form every environment writes to a counter literally named `theorem`, so `\cref{lem:adjoint}` renders "theorem 12" — and `\crefname{lemma}{...}` cannot repair it, because no reference is ever tagged `lemma`. `\newaliascnt{lemma}{theorem}` creates a counter named `lemma` that *is* `theorem`: one sequence, but references carry the environment's own name. **Verified by compilation — the plain form was tried first and printed "theorem 1, theorem 2, theorem 3" for a lemma, a proposition and a theorem in a row.** Every aliascnt environment needs a matching `\crefname`.

| Environment | Numbering | Use for |
|---|---|---|
| `theorem` | shared sequence | Main results of the paper |
| `proposition` | shared sequence | Subsidiary results — narrower scope but still publication-worthy |
| `lemma` | shared sequence | Auxiliary results used in proofs of theorems / propositions |
| `corollary` | shared sequence | Direct consequences of a stated result |
| `definition` | shared sequence | Defining objects, parameters, classes |
| `remark` | **shared sequence** | Comments, scope notes, special cases — placed after proofs |
| `hyp` (Hypothesis) | own sequence | Null/alternative hypotheses for testing problems |
| `assumption` | **unnumbered** | Assumption blocks — the tag goes in the optional argument |

The `hyp` environment is project-specific to econometrics — it lets you write `\begin{hyp}` for hypotheses without overloading `assumption`. It keeps its own sequence because a hypothesis is not a result and readers cite $H_0$, $H_1$ by name.

### Remarks are numbered

**Changed 2026-07-29 with user approval, reversing the earlier `\newtheorem*{remark}{Remark}`.**

Theory papers cross-reference remarks, and by clause — `\cref{rem:R1}(iv)`, `\cref{rem:adjointreconcile}(iv)`. An unnumbered environment writes no counter, so a `\label` inside it silently captures the enclosing `\section` and the reference renders "section 3(iv)". **That is wrong output, not an error**: nothing fails, nothing warns, and the wrong number reaches the page.

If a remark is genuinely a prose aside that nothing will ever reference, that is an argument for writing it as an unlabelled paragraph, not for making the environment unnumbered.

### Assumptions are unnumbered

Assumption blocks carry their tag in the optional argument — `\begin{assumption}[A1: Conditional exogeneity]` — and those tags are not a sequence: `A1b`, `A1c`, `A2$'$`, `B1`, `C2$'$` all occur. An automatic counter would print "Assumption 7 (A1c: ...)", giving every assumption two identifiers, one of which no proof ever cites. **Proofs cite the tag**, per "Pairing with the Assumption Block" below, so nothing needs the counter.

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
