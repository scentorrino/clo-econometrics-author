# Theory Memo — Smoke Test (Khinchin's WLLN)

**Project:** theory-track-smoke
**Date:** 2026-05-15
**Status:** Proof complete; ready for theorist-critic review.

## Pre-Theory Report

Read:
- `paper/sections/theorems/dummy.tex` — theorem statement (`thm:dummy-wlln`).
- `quality_reports/theory/smoke-test/assumptions.tex` — A1 (iid sampling), A2 (integrability).
- `.claude/references/proof-style.md`, `theorem-environment-style.md`, `asymptotic-conventions.md`.

Not read (not provided): strategy memo, domain profile, `Bibliography_base.bib`. The proof cites `vaart1998` (van der Vaart, *Asymptotic Statistics*, 1998); confirm that key resolves in `Bibliography_base.bib` before compile.

## What Is Proved

**Theorem (`thm:dummy-wlln`, Khinchin's WLLN).** Under A1–A2, the sample mean $\bar X_n = n^{-1} \sum_{i=1}^n X_i$ converges in probability to the population mean $\mu = \mathbb{E}[X]$.

## Proof Strategy

Characteristic functions (Khinchin / L\'evy continuity), in one paragraph:

1. By A2, the characteristic function $\varphi$ is differentiable at $0$ with $\varphi'(0) = i\mu$; first-order Taylor expansion gives $\varphi(t) = 1 + i\mu t + o(t)$.
2. By A1 (iid), $\varphi_{\bar X_n}(t) = \varphi(t/n)^n$.
3. As $n \to \infty$, $\varphi_{\bar X_n}(t) \to e^{i\mu t}$, the characteristic function of the point mass at $\mu$.
4. L\'evy's continuity theorem yields $\bar X_n \xrightarrow{d} \mu$; convergence in distribution to a constant is equivalent to convergence in probability.

This is the textbook Khinchin argument. The only moment requirement is the first absolute moment (A2); no variance is needed.

## Assumptions Used

| Tag | Statement | Where used |
|---|---|---|
| A1 | $\{X_i\}_{i=1}^n$ iid $\sim P$ on $\mathbb{R}$ | Factorisation of joint characteristic function into $\varphi(t/n)^n$. |
| A2 | $\mathbb{E}\|X\| < \infty$ | Differentiability of $\varphi$ at the origin; existence of $\mu = \mathbb{E}[X]$. |

Both assumptions are tight for this conclusion under iid sampling: A1 is needed for the product form, and A2 is the well-known necessary-and-sufficient first-moment condition for Khinchin's WLLN.

## What Remains Open (Out of Scope for This Smoke Test)

1. **Strong LLN (a.s. convergence).** Etemadi's proof obtains $\bar X_n \xrightarrow{a.s.} \mu$ under the same A1–A2 (in fact under pairwise independence). A separate theorem and proof would be required; the current statement only delivers $\xrightarrow{p}$.
2. **CLT / asymptotic normality.** $\sqrt{n}(\bar X_n - \mu) \xrightarrow{d} N(0, \sigma^2)$ requires the additional moment condition $\mathbb{E}[X^2] < \infty$ (Lindeberg–L\'evy). Not addressed here.
3. **Non-iid extensions.** Heterogeneous (Markov, $L^1$-bounded triangular array) or weakly dependent ($\alpha$-mixing) versions are available in the literature; not in scope.
4. **Vector-valued $X_i$.** The statement is one-dimensional; the multivariate version follows by the Cram\'er–Wold device but is not stated.
5. **Rate of convergence.** Without higher moments, no rate is obtained. Berry–Esseen and related rates require $\mathbb{E}|X|^3 < \infty$ or analogous.

## Files Produced

- `quality_reports/theory/smoke-test/proofs.tex`
- `quality_reports/theory/smoke-test/notation_glossary.md`
- `quality_reports/theory/smoke-test/theory_memo.md` (this file)

`assumptions.tex` was provided as input and is unmodified.

## Notes for the Critic

- Cite key used: `vaart1998` (van der Vaart 1998, *Asymptotic Statistics*). Verify against `Bibliography_base.bib`.
- The `\textcite` and `\parencite` commands are biblatex; consistent with INV-9 and the working-paper preamble.
- `\cref` used per `cleveref` convention (INV-10).
- No filler phrases; every step has a justification (either an equation reference or a named result with citation).
