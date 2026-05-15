# Notation Audit — smoke-test (theory-track)
**Date:** 2026-05-15
**Reviewer:** notation-warden (manually applied — agent not yet discoverable by Task in this session; see smoke report)

## Notation Table

| Symbol | Type | Definition | First defined | Used in |
|--------|------|------------|---------------|---------|
| $n$ | positive integer | Sample size | assumptions.tex:L4 | dummy.tex, proofs.tex |
| $i$ (subscript) | index | Observation index, $i = 1, \ldots, n$ | assumptions.tex:L4 | dummy.tex, proofs.tex |
| $X_i$ | real RV | $i$-th observation | assumptions.tex:L4 | dummy.tex, proofs.tex, glossary |
| $P$ | prob measure | Common marginal distribution of $X_i$ | assumptions.tex:L4 | proofs.tex |
| $\mathbb{E}$ | operator | Expectation | assumptions.tex:L5 | dummy.tex, proofs.tex, glossary |
| $\mu$ | real | $\mathbb{E}[X]$ — population mean | assumptions.tex:L5 | dummy.tex (implicit), proofs.tex, glossary |
| $\bar X_n$ | real RV | $n^{-1}\sum_{i=1}^n X_i$ — sample mean | proofs.tex | dummy.tex, proofs.tex, glossary |
| $\varphi$ | function | Characteristic function of $X$ | proofs.tex | proofs.tex, glossary |
| $\varphi_{\bar X_n}$ | function | Characteristic function of $\bar X_n$ | proofs.tex | proofs.tex, glossary |
| $t$ | real | Argument of characteristic function | proofs.tex | proofs.tex |
| $i$ (imaginary unit) | complex | $\sqrt{-1}$ | proofs.tex | proofs.tex, glossary |
| $o(\cdot)$ | rate symbol | Deterministic little-o | proofs.tex | proofs.tex |
| $\xrightarrow{p}$ | relation | Convergence in probability | dummy.tex | dummy.tex, proofs.tex, glossary |
| $\xrightarrow{d}$ | relation | Convergence in distribution | proofs.tex | proofs.tex, glossary |
| A1, A2 | tags | Assumption tags | assumptions.tex | dummy.tex, proofs.tex |

## Violations

**Collisions:** 0. The symbol $i$ is used for both the observation index (subscript context) and the imaginary unit (inside the characteristic function). The notation glossary at `quality_reports/theory/smoke-test/notation_glossary.md` flags this dual use explicitly and disambiguates by context. Per latex-math-conventions.md this is acceptable when documented; no deduction.

**Undefined on first use:** 0.

**Typography inconsistency:** 0. $\mathbb{E}$ used consistently; $\bar X_n$ over-bar typography consistent; rate symbols $\xrightarrow{p}, \xrightarrow{d}$ rendered uniformly.

**No violations.**

## Score: 100 / 100

The notation block is clean. The only theoretical concern (the $i$ collision) is preemptively disambiguated in the glossary.
