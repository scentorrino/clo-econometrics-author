# Regularity Audit — Proof of Proposition `prp-condcomp`

**File:** `/Users/samuele/Library/CloudStorage/Dropbox/Nonparametric_IV/Volatility/Centorrino_Florens_VOL_1.qmd`
**Statement:** L285–287; **Proof:** L998–1016.
**Date:** 2026-05-15. Reviewer: regularity-checker agent.

## Score: 67 / 100

## CRITICAL (-20): L1000–1006, MI vs FI completeness

Proposition claims both routes. Proof Case 1 uses only FI's kernel form \eqref{eq-fider-bdagger} and FI's side conditions. MI's parallel — using \eqref{eq-tmider-bdagger} (a pair of $W$-conditional moments, no $f_U$ prefactor) and the no-side-conditions argument of L148 — is not made.

**Fix:** Add explicit MI case (one paragraph) or note "We prove the FI case; the MI case is identical with \eqref{eq-tmider-bdagger} replacing \eqref{eq-fider-bdagger} and the no-side-conditions claim of L148 replacing the FI side conditions."

## MAJOR (-10): L1004, positivity of $f_U$

"$\mathsf{T}'_{b_\dagger}\tilde b = 0$ a.s. is equivalent to the conditional-expectation identity in `ass:condcomp`" — requires $f_U(u) > 0$ a.e. on $\mathrm{supp}(U)$ to translate "a.s. zero product" to "a.s. zero factor." Otherwise, on $\{u: f_U(u) = 0\}$, no constraint on $\mathsf{D}_h, \mathsf{D}_\omega$.

The closest stated condition is `ass:app4` ($\kappa_n$ floor), but `ass:app4` is in the asymptotic block, not invoked by `prp-condcomp`'s hypothesis range `ass:differentiability`-`ass:unifbd`.

**Fix:** Either (a) add explicit hypothesis "$f_U > 0$ a.e." to identification block; (b) cite `ass:app4` inside the proposition; (c) add a one-line remark "positivity of $f_U$ on its support is implicit in `ass:differentiability`'s requirement that $F(y, x|w)$ be differentiable in $y$ — verify and cite."

## MINOR (-3): L1014 Cauchy-Schwarz strictness

Strict $<$ at the end relies on $\tilde b \neq 0$ from $b^* \neq b_\dagger$. Half-line clarification would help.

## What's clean

- L1008 spectral decomposition: compactness + self-adjointness + completeness all OK.
- L1014 series convergence: source-condition + compactness deliver both.
- L1016 contradiction logic: $M\Vert\tilde b\Vert^2 < M\Vert\tilde b\Vert^2$ is genuinely impossible.

## Verdict

The proof is structurally sound. Case 2 (the contraction in Hilbert scales) is clean. Two genuine regularity gaps: (1) the "both routes" claim only proved for FI; (2) implicit positivity of $f_U$ in the route-conversion step. Both have standard remedies.
