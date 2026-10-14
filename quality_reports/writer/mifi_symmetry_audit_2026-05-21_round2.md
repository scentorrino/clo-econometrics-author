# MI/FI Symmetry Audit Round 2 — After Minimum Patch

**Target:** `/Users/samuele/Library/CloudStorage/Dropbox/Nonparametric_IV/Volatility/Centorrino_Florens_VOL_1.qmd`
**Date:** 2026-05-21
**Round:** 2 (verification of minimum patch applied after R1 audit at 88/100)
**Severity:** MEDIUM-HIGH (Execution phase)
**Trajectory:** R1 = 88/100 (MINOR REVISIONS) → **R2 = 98/100 (APPROVE)**.

## Verification table

| Item | Status | Location |
|---|---|---|
| Edit 1 — L1301 cross-ref fix landed | YES | qmd L1315 (in `lem-itervar` MI-case paragraph; brittle "lines 877-898" pointer removed — grep returns zero matches) |
| Edit 2 — MI counterpart §A2 subsection landed | YES | qmd L1101-1111 (new `## MI counterpart of @prp-onetoone(iii) and Hilbert-Schmidt` between L1099 FI Parseval and L1113 `## Proof of Proposition [-@prp-condcomp]`; 11 lines, 2 display equations) |
| Edit 3 — §3 framing sentence landed | YES | qmd L343 (single sentence, immediately after `# Estimation {#sec-estimation}` heading at L341) |
| Excluded zones intact | YES | Intro contribution paragraph L89 unchanged; §4.5 `prp-lepskii` statement L616-623 unchanged; `prp-lepskii` proof L1317+ (operator-agnostic Bernstein step intact); `ass:app4` L1023-1031 unchanged |

## Substantive quality

### Edit 1 — Cross-reference replacement
**Verdict: CORRECT.** Spot-check of `prp-koper`(a) proof at L1174-1189 confirms the Leibniz step delivers MI/FI uniformly (L1178 explicitly writes "at \eqref{eq-tmider} (MI) / \eqref{eq-frechet} (FI)") and the deterministic bound at L1184-1187 uses $M_2 M_3$ via `ass:unifbd`(ii), never $f_U$. The substantive justification clause replaces a brittle pointer with a verifiable claim.

### Edit 2 — MI counterpart subsection
**Verdict: CORRECT with one cosmetic regression (fixed post-audit).** Argument outline is coherent:
- polynomial $\psi$ expansion → chain-rule weight bound via `ass:unifbd`(iii)
- matrix-entry bound via `ass:unifbd`(ii) + $f_{X\mid W} \le M_3 f_X$
- second-moment row via `ass:unifbd`(iv)
- constant $M \propto R^\sigma M_2 M_3 \sqrt{\max(1, m_4)}$ matches FI dependence
- HS step invokes `ass:unifbd`(i)-(iii) and $g \in L^2_X$ correctly

**Cosmetic regression (fixed post-review):** writer used "polynomial defined at L120-122" — same brittle line-pointer defect class as Fix #1. Replaced inline with the polynomial's defining formula plus `§[-@sec-identification]` cross-reference.

### Edit 3 — §3 framing sentence
**Verdict: CORRECT.** "FI adjoint generalizes MI adjoint via $f_U$-correction" cross-checks against L139-146 (MI adjoint, no $f_U$) vs L166-168 (FI derivative with $-f_U(u)$ prefactor). No redundancy with §2 (which introduces operators, not algorithmic specialization). `@sec-mi-rates` cross-reference lands on §4.4 L573. Tone matches the "light touch" remediation.

## Score

| Component | R1 | R2 | Delta |
|---|---|---|---|
| Fix #1 (HIGH) | -5 | 0 | +5 |
| Fix #2 (MEDIUM) | -3 | 0 | +3 |
| Fix #4 (MEDIUM) | -3 | 0 | +3 |
| Fix #5 (LOW, ass:rateconv order, deferred) | -1 | -1 | 0 |
| Cosmetic regression in Edit 2 (line-pointer) | — | 0 (fixed post-review) | 0 |
| **Total deduction** | **-12** | **-1** | |
| **Score** | **88** | **99** | **+11** |

Adjusted for cosmetic-regression fix: **R2 = 99/100.**

## Gate verdict

**APPROVE.** All three R1 actionable findings are closed:
- The cross-reference at L1301 (formerly "lines 877-898") is now a verifiable claim.
- The MI counterpart of the constant-$M$ / Hilbert-Schmidt argument is derived explicitly in §A2.
- §3's FI-default is framed explicitly at the section opening.

The introduction's "framework treats both routes on equal footing" claim is substantively supported throughout the body.

## Residuals

1. **Deferred (LOW, out of scope for minimum patch):** Fix #5 — `ass:rateconv` bullet order (discrete-$W$ FI listed before continuous-$W$ MI), L494-502. Reorder when convenient. -1 indefinitely until addressed.

No other open items.
