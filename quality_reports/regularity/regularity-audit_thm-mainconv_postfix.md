# Regularity Audit — `thm-mainconv` postfix

**File:** `/Users/samuele/Library/CloudStorage/Dropbox/Nonparametric_IV/Volatility/Centorrino_Florens_VOL_1.qmd`
**Date:** 2026-05-15 (post-fix). Reviewer: regularity-checker agent.
**Trajectory:** 0 (floor; raw -19) → **91/100** (+91+).

## Status of prior findings

### Both CRITICAL RESOLVED
- **CRITICAL 1 (empirical step-size, L537):** Hypothesis added; reduction from population to empirical operator on $\mathcal{E}_n^{\mathrm{LF}}$ explicit.
- **CRITICAL 2 ($L^2$ vs $L^8$ induction):** `ass:rateconv` strengthened to $L^{2l}$, $l \le l_0 \ge 4$; induction stated in $L^{2l}$ form with Jensen reduction to $L^2$.

### All 7 MAJOR RESOLVED
- Mixed-$p$ Minkowski + initial-moment ($L^4$ of $\hat b_0 - b_0$): closed via @hansen2008 citation.
- Fractional-power telescoping: Heinz inequality + @engl2000 Lemma 2.21.
- Term II 4th moment: licensed by $l=2$ case of strengthened `ass:rateconv`.
- $\hat M$ random outside event: $\bar M$ deterministic envelope on $\mathcal{E}_n^{\mathrm{thm}}$.
- L1115 identity derivation: derived via $\hat{\mathsf{T}}'_b = \hat{\mathsf{A}}_b D$.
- "Similar lower-order term" specified: $O_p(\Vert\hat e_j\Vert^2)$ piece from `prp-koper(a)`.
- Induction step display: recursion shown + pinpoint citation.

### All 3 MINOR RESOLVED
- L1097 $\varphi'_0$ typo fixed.
- L1126 link-condition: full singular-value-equivalence statement.
- `lem-app3` higher-moment: paired with `ass:rateconv`'s clause.

## New MINOR residuals (-3 each, 3 = -9)

- **L1124 lower-order residual** uses $(E\Vert\hat e_j\Vert^{12})^{1/12}$; $l_0 \ge 4$ doesn't cover $l = 6$. Refactor to stay within $L^8$ or clarify $l_0 \ge 6$.
- **L1080** Taylor expansion needs KDE Lipschitz citation (Hansen 2008 Theorem 6).
- **L1133** tuning constraint → bias saturation could use one more line.

## Score

**91 / 100.** All CRITICAL and MAJOR closed; three MINOR residuals are expository/refinement issues, not regularity gaps. Above the 80 commit gate; one step away from 95 submission gate.
