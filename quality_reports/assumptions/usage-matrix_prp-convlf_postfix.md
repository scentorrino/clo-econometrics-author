# Usage-Matrix Re-Audit — `prp-convlf` (post-fix)

**File:** `/Users/samuele/Library/CloudStorage/Dropbox/Nonparametric_IV/Volatility/Centorrino_Florens_VOL_1.qmd`
**Date:** 2026-05-15 (post-fix). Reviewer: assumption-auditor agent.
**Prior score:** 76/100. **New score:** **87/100** (+11).

## Patch verification

| Patch | Target | Verdict |
|---|---|---|
| 1. Step-size hypothesis added at L440 | (c) silent step-size at L1034 | **RESOLVED with minor NEW UNDER-STATEMENT** (R-3 below) |
| 2. Injectivity re-sourced to eq-lfconv at L1050 | (a) over-extension of `ass:condcomp` | **RESOLVED** — logically tight |
| 3. L1039 expanded with MVT + kernel-difference + def-sourceID | (b) opaque "as in prp-onetoone" | **PARTIAL** — two residual silent steps (R-1, R-2) |
| 4. Pseudo-inverse convention + range condition at L440 | factorization at L1041 | **RESOLVED** |
| 5. $M_4 \to M_{\text{lf}}$ rename | notation collision | **RESOLVED** |

## Residual under-statements

- **R-1 (-3):** L1039 cites the per-$t$ operator bound from sec-annexA2, but sec-annexA2 actually proves the *integrated* version. Corollary is one display away but not stated explicitly.
- **R-2 (-5):** Constant-1 form of L1037 inequality requires a radius bound on $\mathcal{B}_{b_\dagger}$ that is absorbed implicitly into the membership rather than stated.
- **R-3 (-5):** L1049 silently strengthens the step-size hypothesis from $\le 1$ to $<1$ (strict) to get strict positivity of $(I-c\mathsf{A}\mathsf{A}^*)^{1/2}$. Either tighten the hypothesis or split boundary case.

## Updated usage matrix

| Assumption / hypothesis | Statement | Used in proof | Strength |
|---|---|---|---|
| `ass:identif` | $b_\dagger \in \mathcal{A}'_b$, locally identified | L1049 (identification → $b_j = b_\dagger$) | Full |
| `ass:initcond` | $b_0 \in \mathcal{B}_{b_\dagger}$ | L1028 (induction base) | Full |
| **NEW** Step size $c\sup_b\Vert\mathsf{A}^*_b\mathsf{A}_b\Vert \le 1$ | LF contraction | L1034, L1049 (strict) | **Partial** — strict version needed at L1049 |
| **NEW** eq-lfconv with pseudo-inverse + range | $\le 1/M_{\text{lf}}$ + $b_j - b_\dagger \in \text{Ran}((\cdot)^{1/2})$ | L1041-1043, L1050 | Full |
| `ass:unifbd` (i)-(iii) | uniform kernel bounds | sec-annexA2 (cited L1039) | Full |
| `ass:unifbd` (iv) + $g_\dagger \in L^2_X$ | moment control | Silently used in lifting integrated bound (L1039) | **Partial** |
| `def-sourceID` ($\mathcal{B}^*_M$) | Fourier decay | L1028, L1039 | Full (now cited) |
| `prp-condcomp` Cauchy-Schwarz | $\|b-b_\dagger\|^2 < M^{-1}\|\mathsf{T}'_{b_\dagger}(b-b_\dagger)\|$ | L1039 | Full |
| **UNSTATED**: radius of $\mathcal{B}_{b_\dagger}$ small enough | $CR^2 \le M$ for constant-1 inequality | L1037/L1039 | UNSTATED |

## Score

| Item | Severity | Deduction |
|---|---|---|
| R-1 | MINOR | -3 |
| R-2 | MEDIUM | -5 |
| R-3 | MEDIUM | -5 |

**Score: 87 / 100** (prior 76, +11).

## Verdict

The three patches resolve the originally flagged items with the expected discipline: issue (c) becomes an explicit step-size hypothesis, issue (a) is re-sourced to the natively-correct eq-lfconv, issue (b)'s opaque pointer is replaced by a citation chain. The eq-lfconv → injectivity link at L1050 is logically airtight given the new pseudo-inverse and range conventions. Three residual under-statements account for the -13 from a perfect score: per-$t$ operator bound used at L1039 is a corollary rather than the stated conclusion of sec-annexA2 (R-1); the constant-1 form requires an unstated radius bound (R-2, the most substantive residual); L1049 silently strengthens to strict step-size (R-3). None is counterexample-class; all are statement-tightness defects. One further pass closing R-2 and R-3 would clear the 95 submission threshold.
