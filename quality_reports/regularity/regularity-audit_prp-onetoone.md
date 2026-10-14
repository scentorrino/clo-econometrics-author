# Regularity Audit — Proposition `prp-onetoone`

**File:** `/Users/samuele/Library/CloudStorage/Dropbox/Nonparametric_IV/Volatility/Centorrino_Florens_VOL_1.qmd`
**Scope:** Statement L189–198; proof L950–961.
**Date:** 2026-05-15. Reviewer: regularity-checker agent.

## Section 1: Per-concern table

| # | Concern | Site | Verdict | Patch |
|---|---|---|---|---|
| 1 | Existence of explicit Fréchet kernel form \eqref{eq-frechet} | L952 | FLAG (MINOR) | Drop the equation reference; the proof uses only the abstract derivative from (i). |
| 2 | $\mathsf{T}(b_\dagger) = 0$ at the second equality | L956–957 | CAPTURED | Proof states "uses $\mathsf{T}(b^*) = \mathsf{T}(b_\dagger) = 0$." $\mathsf{T}(b^*) = 0$ is contradiction hypothesis; $\mathsf{T}(b_\dagger) = 0$ is defining property under \eqref{eq-mi} / \eqref{eq-fi}. |
| 3 | $b^* \in \mathcal{B}_R$ to license condition (iii) | L957–959 | FLAG (MINOR) | Add parenthetical "($\mathcal{B}_{b_\dagger} \subseteq \mathcal{B}_R$)" at next-to-last inequality. |
| 4 | Last inequality uses definition of $\mathcal{B}_M$ | L959 | CAPTURED | Mechanical use of (iv). |
| 5 | Codomain norm route-dependent | L955–957 | FLAG (MINOR) | Footnote pinning codomain norm under each route. |
| 6 | Norm-measurability of $\mathsf{T}'_{b_\dagger}(b^* - b_\dagger)$ | L955 | CAPTURED | Automatic from Fréchet differentiability and Hilbert codomain. |
| 7 | Case-split exhaustiveness | L953 | CAPTURED | Zero or nonzero — exhaustive. |
| 8 | Implicit dispatch on route — \eqref{eq-frechet} is FI-only | L952 | **FLAG (MAJOR)** | Proof cites only the FI kernel form. MI uses \eqref{eq-tmider}. Either cite both or drop the equation reference. |
| 9 | Conclusion at L961 | L961 | CAPTURED | Logically sound. |

## Section 2: Score

| Item | Severity | Deduction |
|---|---|---|
| #8 — \eqref{eq-frechet} silently dispatches to FI | MAJOR | -10 |
| #1 — same equation reference (narrow read) | MINOR | -3 |
| #3 — $\mathcal{B}_{b_\dagger} \subseteq \mathcal{B}_R$ not spelled out | MINOR | -3 |
| #5 — codomain norm route-dependent | MINOR | -3 |

**Score: 100 - 19 = 81 / 100.**

## Section 3: Verdict

The proof of `prp-onetoone` is a short, clean, by-contradiction adaptation of @chenlee2013's abstract local-identification argument to the pair-valued setting. It does not silently invoke heavyweight regularity machinery — no Fubini, no dominated convergence, no uniform LLN, no Donsker class. The proof is a deterministic operator-theoretic inequality chain. All genuine work is loaded into conditions (i)–(iv); the proof combines them.

From the regularity-checker's standpoint, this is a low-risk proof. The only operations are: (a) Fréchet differentiability from (i), (b) injectivity from (ii), (c) substituting $\mathsf{T}(b^*) = \mathsf{T}(b_\dagger) = 0$, (d) quadratic-remainder from (iii), (e) source-condition lower bound from (iv). Each is explicitly invoked. There are no hidden measurability claims, no boundary-of-parameter-space issues (the proposition is local, on an open ball), no exchange of limit and integral, no compactness for a sup, no continuous-mapping theorem in disguise.

The audit surfaces one substantive issue and three cosmetic ones. The substantive issue (#8 MAJOR) is the equation reference at L952: the proof asserts "Condition (i) gives Fréchet differentiability and \eqref{eq-frechet} for $\mathsf{T}'_{b_\dagger}$," but \eqref{eq-frechet} is the FI-specific kernel form. The MI route uses the different form \eqref{eq-tmider}. The proof itself never uses the kernel form — only the abstract bounded linear derivative — so the result holds under both routes, but the citation creates the appearance that the author has silently passed to FI. Documentation defect, not logical. Cleanest repair: drop the equation reference and let the abstract Fréchet derivative carry the argument.

The three minor flags are bookkeeping: same equation-reference issue read narrowly; proof never spells out $\mathcal{B}_{b_\dagger} \subseteq \mathcal{B}_R$ when invoking (iii); codomain norm at L957 is route-dependent. None affects validity. The proof would go through verbatim if (i)–(iv) are read as abstract statements about a bounded linear operator $\mathsf{T}: \mathcal{A}_b \to \mathcal{H}_{\text{cod}}$ on some Hilbert codomain.

**Recommended patch:** change "Condition (i) gives Fréchet differentiability and \eqref{eq-frechet} for $\mathsf{T}'_{b_\dagger}$" to "Condition (i) supplies a bounded linear Fréchet derivative $\mathsf{T}'_{b_\dagger}$ at $b_\dagger$ (given concretely by \eqref{eq-tmider} under MI and \eqref{eq-frechet} under FI; the proof below uses only the abstract derivative)," and add a parenthetical "($\mathcal{B}_{b_\dagger} \subseteq \mathcal{B}_R$)" before the application of (iii).
