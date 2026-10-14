# Notation Audit — Theorem `thm-mainconv`

**File:** `/Users/samuele/Library/CloudStorage/Dropbox/Nonparametric_IV/Volatility/Centorrino_Florens_VOL_1.qmd`
**Scope:** Statement L536–544; Proof L1086–1126.
**Date:** 2026-05-15. Reviewer: notation-warden agent.

## Score: 86 / 100

## Findings

- **(-5) L1097 coordinate-space typo:** "$\varphi'_0 - \varphi'_\dagger$ at the population initial condition $\varphi_0$" — should be $b'_0 - b'_\dagger$ at $b_0$. The proof works in $b'$-coordinates; $\varphi$ belongs to the original $(\varphi, \sigma)$ coordinates. Likely copied from centorrinofeveflorens2019.
- **(-3) L1108 random $\hat M$ outside expectation:** $\hat M = M_2 M_3 + C_{\mathrm{D},n} M_X$ (random); the inequality $(E\Vert III\Vert^2)^{1/2} \le c\hat M\sum_j(\cdots)$ pulls $\hat M$ outside $E[\,\cdot\,]$. Valid only on $\mathcal{E}_n$ from the prp-koper fix; should be localized.
- **(-2) L1099 mixed $L^2$/$L^4$ Minkowski:** $(E\Vert I\Vert^2)^{1/2} \le \sum(E\Vert I_i\Vert^4)^{1/4}$. Valid by Jensen ($L^2 \le L^4$) + Minkowski, but should be motivated (needed because Term III uses 8th moments).
- **(-2) Empirical vs population operator switch:** L1090 uses $\hat{\mathsf{T}}'^*_{b_\dagger}\hat{\mathsf{T}}'_{b_\dagger}$; L1101 uses $\mathsf{T}'^*_{b_\dagger}\mathsf{T}'_{b_\dagger}$ for the source decomposition; not flagged in text.
- **(-2) L1126 exponent adjustment phrasing:** "$\beta \mapsto \beta + 1/(a+1)$" should be "$\beta_\epsilon \mapsto \beta_\epsilon + 1/(a+1)$" (the $\epsilon$-saturation is the actual relevant index).

## What's clean

- $M_{23}$ rename consistent at L1115, L1119.
- $\hat b_0$ vs $b_0$ distinction maintained.
- $\un$ macro consistent.
- $a$ collision (link exponent vs coordinate pair) is a known unpatched inheritance from earlier.
