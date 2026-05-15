# Notation Glossary — Smoke Test (WLLN)

One-page reference for every symbol used in `assumptions.tex`, `dummy.tex` (theorem statement), and `proofs.tex`.

| Symbol | Type | Meaning |
|---|---|---|
| $n$ | positive integer | Sample size; index running to infinity in asymptotic statements. |
| $i$ | index | Observation index, $i = 1, \dots, n$. |
| $X_i$ | real-valued random variable | The $i$-th observation; iid draw from $P$ (A1). |
| $P$ | probability measure on $\mathbb{R}$ | Common marginal distribution of each $X_i$ (A1). |
| $\mathbb{E}[\cdot]$ | expectation operator | Integral against $P$. |
| $\mu$ | real scalar | Population mean, $\mu := \mathbb{E}[X]$; well defined by A2. |
| $\bar X_n$ | real-valued random variable | Sample mean, $\bar X_n := n^{-1} \sum_{i=1}^n X_i$. |
| $\varphi$ | function $\mathbb{R} \to \mathbb{C}$ | Characteristic function of $X$, $\varphi(t) = \mathbb{E}[e^{itX}]$. |
| $\varphi_{\bar X_n}$ | function $\mathbb{R} \to \mathbb{C}$ | Characteristic function of $\bar X_n$. |
| $t$ | real scalar | Dummy argument of a characteristic function. |
| $i$ (in $e^{itX}$) | imaginary unit | $i^2 = -1$; context distinguishes from the observation index. |
| $o(\cdot)$ | deterministic little-$o$ | $f(t) = o(t)$ as $t \to 0$ means $f(t)/t \to 0$. |
| $\xrightarrow{p}$ | mode of convergence | Convergence in probability. |
| $\xrightarrow{d}$ | mode of convergence | Convergence in distribution (weak convergence of laws). |
| A1 | assumption tag | Sampling: $\{X_i\}_{i=1}^n$ iid $\sim P$. |
| A2 | assumption tag | Integrability: $\mathbb{E}|X| < \infty$. |
