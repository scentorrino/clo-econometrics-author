# Proof Style

House style for writing proofs in theory papers. Loaded by the theorist; checked by theorist-critic and regularity-checker.

## Core Rules

1. **Every nontrivial step is justified.** A justification is a cross-reference to: a lemma, an assumption (by tag), a numbered equation earlier in the proof, or a named external result with a citation. "By the dominated convergence theorem" without stating the dominating function is not a justification.

2. **No filler phrases.** Banned:
   - "It is easy to see that…"
   - "Similarly,…" (without making the parallel argument explicit)
   - "Obviously,…" / "Clearly,…"
   - "By standard arguments,…" (without naming which standard arguments)
   - "It can be shown that…" / "After some algebra,…"
   - "WLOG" without stating what is lost in generality and why it is reclaimable

3. **Display equations numbered if referenced later, unnumbered otherwise.** Don't number every equation by default — only the ones the proof comes back to.

4. **End with $\qed$ or $\blacksquare$.** Use `\begin{proof} ... \end{proof}` which adds the qed automatically.

5. **Strategy in one sentence at the start.** Open the proof with the high-level approach:
   > "The proof proceeds in three steps: (i) show $\hat\theta \xrightarrow{p} \theta_0$ via the consistency theorem for M-estimators (Lemma 1); (ii) Taylor-expand the FOC around $\theta_0$; (iii) apply Slutsky and the CLT to the leading term."

6. **Each step is a named subclaim.** When a proof has multiple steps, label them:
   ```latex
   \emph{Step 1: Consistency.}
   ...
   \emph{Step 2: Asymptotic linearization.}
   ...
   ```

7. **Cite by tag for assumptions and equation number for prior steps.** "By A2 and (3.4)…" not "by the moment assumption and the earlier expansion."

## What Justifies What

| Move | Justification format |
|---|---|
| Invoke an assumption | "By A2, $\mathbb{E}\|X\|^2 < \infty$, hence…" |
| Invoke a prior lemma | "By Lemma 1, $\sup_\theta |\hat M_n(\theta) - M(\theta)| \to_p 0$." |
| Invoke a textbook result | "By the uniform LLN of van der Vaart (1998, Theorem 19.4),…" |
| Invoke a regularity condition | "Applying dominated convergence (the envelope $F$ from A4 is in $L^1(P)$),…" |
| Interchange differentiation and expectation | "By A4 (dominating function), $\partial \mathbb{E}[g(X,\theta)]/\partial\theta = \mathbb{E}[\partial g / \partial\theta]$." |
| Limit/CMT/Slutsky | "By the continuous mapping theorem (continuity of $g$ at $\theta_0$),…" |

## Proof Structure Template

```latex
\begin{proof}[Proof of Theorem N]
The proof proceeds in <k> steps. <One-sentence sketch.>

\emph{Step 1: <subclaim>.}
<Argument, with justifications.>

\emph{Step 2: <subclaim>.}
<...>

\emph{Step k: <conclusion of theorem>.}
Combining Steps 1–(k-1), <conclude theorem N>.
\end{proof}
```

For short proofs (one or two paragraphs), the step labels can be omitted.

## When to Defer to a Lemma

If a proof step takes more than ~half a page and is reusable or has independent interest, lift it into a `\begin{lemma}` block and prove the lemma separately. The main proof then cites the lemma in one line.

## Anti-Patterns from Common Submission Defects

| Pattern | Why it's bad | Fix |
|---|---|---|
| "It is easy to see that $\hat\theta \to \theta_0$." | Easy for whom? | Either prove it or cite a result. |
| "Similarly to Step 1, …" with no parallel structure | The reader can't tell what to substitute. | Make the parallel explicit, or write out the second case. |
| "After some algebra, we obtain…" with no intermediate steps | Hides where the work happens. | Show one or two intermediate lines; if more, lift to a lemma. |
| "By standard regularity conditions, …" | Which conditions, by which theorem? | Cite the specific result or condition. |
| Forty-line display equation block with no commentary | Even a correct derivation is unreadable. | Break into steps with one-line justifications between displays. |
| "We omit the proof, which is similar to Theorem 3 of [Author, Year]." | Not a proof, and the analogy may be false. | Either give the proof or, if truly identical, say so and pinpoint what changes. |

## Cross-references with `cleveref`

Use `\cref{}` and `\Cref{}` not manual `Theorem~\ref{thm:main}`. The preamble loads `cleveref` after `hyperref` (INV-10). "Cref" capitalizes at sentence start; "cref" elsewhere.
