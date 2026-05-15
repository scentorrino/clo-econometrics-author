# Regularity Audit — smoke-test (theory-track)
**Date:** 2026-05-15
**Reviewer:** regularity-checker (manually applied — agent not yet discoverable by Task in this session; see smoke report)

## Findings

### proofs.tex:5–8 — Differentiability of $\varphi$ at the origin [OK]
The proof invokes $\varphi(t) = 1 + i\mu t + o(t)$ as $t \to 0$, citing van der Vaart (1998). The underlying regularity condition is $\mathbb{E}|X| < \infty$, which is exactly A2 — explicitly used and stated. No silent assumption.

### proofs.tex:9–12 — Factorisation $\varphi_{\bar X_n}(t) = \varphi(t/n)^n$ [OK]
This requires only iid (A1) plus the basic fact that the characteristic function of a sum of independent variables is the product of individual c.f.s. No measurability or integrability issue beyond A2 (which gives finite mean and hence finite c.f. everywhere — c.f.s are always bounded by 1).

### proofs.tex:13–16 — Pointwise limit $\varphi_{\bar X_n}(t) \to e^{i\mu t}$ [OK]
Uses the deterministic limit $(1 + z_n/n)^n \to e^z$ when $n z_n \to z$. The relevant $z_n = i\mu t/n + o(1/n)$, so $n z_n = i\mu t + n \cdot o(1/n) = i\mu t + o(1) \to i\mu t$. Elementary and standard; a pedantic referee might want this one-line check inline, but it is implicit and unambiguous.

### proofs.tex:17 — Lévy continuity and $\xrightarrow{d}$ to a constant $\Rightarrow \xrightarrow{p}$ [OK]
Both invocations are named results with citations. Lévy's continuity theorem applies here because the candidate limit function $e^{i\mu t}$ is itself a characteristic function (of the point mass at $\mu$), automatically continuous at $t = 0$. The conv-in-dist-to-constant $\Leftrightarrow$ conv-in-prob equivalence is a textbook fact.

## No silent regularity gaps.

## Score: 100 / 100

For a smoke test the proof is regularity-clean. A more pedantic reviewer would note that the proof implicitly assumes the c.f. is well defined globally (always true for $\mathbb{R}$-valued RVs, never an issue here).
