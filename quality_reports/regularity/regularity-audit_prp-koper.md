# Regularity Audit — Proof of Proposition `prp-koper`

**File:** `/Users/samuele/Library/CloudStorage/Dropbox/Nonparametric_IV/Volatility/Centorrino_Florens_VOL_1.qmd`
**Statement:** L519–530; **Proof:** L1051–1085
**Date:** 2026-05-15. Reviewer: regularity-checker agent.

## Score: 8 / 100

## Critical finding

**CRITICAL (-15): L521 "almost surely" inconsistent with random $\hat M$.** $\hat M = M_2 M_3 + M_n M_X$ contains $M_n$ (Dunker uniform-consistency constant), which by construction is random and finite "with probability $1 - o(1)$," not almost surely. Same as MN6 from prp-lepskii audit — should be "on an event $\mathcal{E}_n$ with $\mathbb{P}(\mathcal{E}_n) \to 1$."

## MAJOR findings (-10 each, 6 = -60)

| # | Site | Concern |
|---|---|---|
| 2 | L1053 | Mean-value form needs $\hat{\mathsf T}'_{\hat b_{jt}}$ defined for ALL $t \in [0,1]$ on $\mathcal{B}_{b_\dagger}$; convexity unstated |
| 3 | L1057 | Kernel representation of $\hat{\mathsf T}'_b$ asserted as "plug-in" — needs justification that Fréchet differentiation commutes with kernel substitution |
| 4 | L1062–1065 | "Uniform" bound $|\partial_y \hat f_{Y,X\mid W}| \le M_2 M_3 f_X + M_n$ — uniformity domain unspecified (in $y$? in $(y,x,w)$? trimmed?) |
| 5 | L1061 | Dunker (2018) Lemma 4 citation — Dunker's lemma is for inverse-problem operator estimates, not derivatives of conditional KDEs. Should be Hansen (2008) |
| 6 | L1068 | Division by $\hat f_X(x)$ bounded by $1/\inf f_X = M_X$ — silently uses $\hat f_X$ uniformly bounded below (high-prob event, not a.s.); domain ($\mathcal X$ compact or trimmed) unspecified |
| 7 | L1078 | Shifted-argument operator $K$: dummies inside the integral defining $\hat{\mathsf A}^*$ not made explicit; $L^2$-boundedness of shift unverified |

## MINOR findings (-3 each, 4 = -12)

- **L1082:** $h_u^{-2}$ scaling derivation compressed to one line — needs explicit Lipschitz derivation of KDE.
- **L525:** Domain $L^2_{\hat U_j \times W} \to L^2_{U \times W}$ — random Hilbert space; operator norm specification missing.
- **L1061:** Asymptotic order of $M_n$ never stated.
- **L521–530:** Measurability of $\hat M$, $\Vert K - I\Vert$ not acknowledged.

## Score breakdown

| Item | Severity | Deduction |
|---|---|---|
| #1 "a.s." vs random $\hat M$ | CRITICAL | -15 |
| #2 mean-value form | MAJOR | -10 |
| #3 kernel-representation justification | MAJOR | -10 |
| #4 uniformity domain | MAJOR | -10 |
| #5 Dunker citation | MAJOR | -10 |
| #6 $\hat f_X$ trimming/lower bound | MAJOR | -10 |
| #7 $K$ shift definition | MAJOR | -10 |
| #8 $h_u^{-2}$ Lipschitz scaling | MINOR | -3 |
| #9 random Hilbert space domain | MINOR | -3 |
| #10 $M_n$ rate unstated | MINOR | -3 |
| #11 measurability | MINOR | -3 |

**Score: 100 - 92 = 8/100.**

## Verdict

prp-koper is structurally sound — the integral form of the Fréchet MVT, the kernel-representation argument, and the density-shift construction of $K$ are all legitimate moves. The deductions stem almost entirely from compressed exposition: stochastic objects treated as deterministic, "uniform" asserted without specifying the domain, citations not verified for applicability to conditional densities, and "almost surely" used where the operative event is high-probability-but-not-certain.

None of the MAJORs is plausibly false; each can be discharged with one or two sentences citing the appropriate uniform-consistency result and specifying the trimming/compactness domain. **The CRITICAL "a.s." → "w.p. $1 - o(1)$" propagates through to `thm-mainconv`** where $\hat M$ enters Term $III$, so this fix must be made globally.

Recommend patching the "a.s." globally + verifying the Dunker (2018) citation + adding explicit domain-of-uniformity statements at L1062–1065, L1068.
