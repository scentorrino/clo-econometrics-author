# Theory Review: smoke-test (Khinchin's WLLN)
**Date:** 2026-05-15
**Reviewer:** theorist-critic
**Severity:** STRATEGY-LEVEL (smoke test)

## Phase 1: Claim Identification

- **Object type:** Consistency (weak law of large numbers).
- **Target parameter:** $\mu := \mathbb{E}[X]$, the population mean of the common marginal distribution $P$ (well defined under A2).
- **Estimator:** Sample mean $\bar X_n := n^{-1}\sum_{i=1}^{n} X_i$.
- **Main result (verbatim):** "Suppose Assumptions A1--A2 hold. Then $\bar X_n \xrightarrow{p} \mathbb{E}[X]$" (`paper/sections/theorems/dummy.tex:6`).
- **Assumptions:** A1 iid sampling from $P$ on $\mathbb{R}$; A2 first-absolute-moment integrability $\mathbb{E}|X|<\infty$.
- **Data structure:** iid scalar.
- **Paper type fit:** Smoke test (no enclosing paper). The theorem is the textbook Khinchin statement.

## Phase 2: Proof Validity

**Assessment:** VALID.

The proof is the standard characteristic-function (Khinchin) argument. Each step has a justification. Structure:

1. Differentiability of $\varphi$ at $0$ from A2, yielding $\varphi(t) = 1 + i\mu t + o(t)$ (`proofs.tex:5-8`). Correct.
2. Factorisation $\varphi_{\bar X_n}(t)=\varphi(t/n)^n$ from A1 (`proofs.tex:9-12`). Correct.
3. Pointwise convergence $\varphi_{\bar X_n}(t) \to e^{i\mu t}$ via $(1+z_n/n)^n \to e^z$ when $nz_n \to z$ (`proofs.tex:13-16`). Correct.
4. Lévy continuity $\Rightarrow \bar X_n \xrightarrow{d}\mu$; convergence in distribution to a constant $\Leftrightarrow$ convergence in probability (`proofs.tex:17`). Correct.

**Issues found: 0.** A maximally pedantic referee might want one line justifying $(1+i\mu t/n + o(1/n))^n \to e^{i\mu t}$ explicitly, but this is standard practice.

## Phase 3: Assumptions and Statements

**Issues found: 0.**

- A1 is used at step 2 (factorisation); A2 at step 1 (existence of $\mu$ and differentiability of $\varphi$).
- Both primitive; both necessary; non-redundant.
- A2 is the well-known necessary-and-sufficient first-moment condition for Khinchin's WLLN under iid.
- $\xrightarrow{p}$ is exactly what the characteristic-function argument delivers — no over- or under-claim.
- Notation consistent across all artifacts (INV-7).

## Phase 4: Citations, Linkage, Polish

**Issues found: 2 (both MINOR).**

### 4.1 Bibliography key `vaart1998` not present in `Bibliography_base.bib`
- Location: `proofs.tex:8, 17` (three citation calls).
- Will emit "citation undefined" warnings at compile time. Theory memo already flags this pre-compile.

### 4.2 Specific theorem locators in vdV citations should be verified
- Location: `proofs.tex:8` ([Lemma 2.3.1]), `proofs.tex:17` ([Theorem 2.13], [Theorem 2.7(iii)]).
- Plausible but not independently verified.

## Summary

- **Overall:** SOUND.
- **Score:** 94 / 100
- **Critical issues:** 0
- **Major issues:** 0
- **Minor issues:** 2

## Recommendations

1. [MINOR] Add `vaart1998` entry to `Bibliography_base.bib`.
2. [MINOR] Verify exact theorem/lemma numbers in vdV (1998), or weaken to chapter-level.

## Positive Findings

1. Proof strategy stated upfront in one sentence; argument follows it step-by-step.
2. Every step has an explicit justification — no hand-waving.
3. Assumptions are tight and minimal; out-of-scope strengthenings (SLLN, CLT, dependence, multivariate, rates) explicitly listed in the memo.
4. Notation glossary disambiguates dual use of `i` (observation index vs imaginary unit).
