# Assumption Usage Matrix — smoke-test (theory-track)
**Date:** 2026-05-15
**Reviewer:** assumption-auditor (manually applied — agent not yet discoverable by Task in this session; see smoke report)

## Usage Matrix

| Assumption | Statement (short) | Used in | Strength of use |
|------------|-------------------|---------|-----------------|
| A1 | iid sampling from $P$ on $\mathbb{R}$ | Thm dummy-wlln (proofs.tex:9–12 factorisation step) | Full — iid is used to factor $\varphi_{\bar X_n}(t) = \varphi(t/n)^n$ |
| A2 | $\mathbb{E}\|X\| < \infty$ | Thm dummy-wlln (proofs.tex:5–8 c.f. differentiability) | Full — A2 is exactly the condition for $\varphi$ to be once-differentiable at the origin with $\varphi'(0) = i\mu$ |

## Findings

**Unused assumptions:** None.

**Over-strong assumptions:** None. A2 is the textbook necessary-and-sufficient first-moment condition for Khinchin's WLLN under iid; weakening would invalidate the proof.

**Unstated conditions invoked:** None. The proof uses only A1, A2, Lévy continuity (standard result, cited), and the deterministic limit $(1 + z_n/n)^n \to e^z$ (elementary).

**No issues.**

## Score: 100 / 100

## Suggestions

- The theorist's `theory_memo.md` already discusses scope strengthenings (strong LLN under pairwise independence via Etemadi, CLT under finite second moment). No remark needed in the paper itself — the assumption block is appropriately tight for the stated result.
