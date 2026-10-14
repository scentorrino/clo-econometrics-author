# Scoping Record — Alternative empirical applications for `panel-npiv-discrete`

**Date:** 2026-08-04
**Status:** RECORDED, NOT DECIDED. The hedonic application in §6 stands. This file exists so the
analysis is not re-derived if §6 is revisited.
**Trigger:** three independent lines of doubt on §6's identification converged, and a proposed fix
(instrumenting the endogenous controls) was judged by the author to have small marginal
contribution as a second paper.

---

## 1. Why §6 is diagnostic rather than merely unlucky

Four failures, and they are **structural to the design**, not to the execution:

| Failure | Evidence |
|---|---|
| **Frontier fails at every usable control set** | `app_tsp_feasibility.tex`: "never" at $d_Z=5,10,22$; at $d_Z=0$ the budget is $13.0$ and needs $n\approx2\times10^{11}$ |
| **Instrument is imputed, not the policy** | official designation was by AQCR 1972–78; the county variable is an imputation from monitor readings (`cropper2023`) |
| ~~**A1 is rejected**~~ **WITHDRAWN 2026-08-07** | This row read: *the within-strata $W$-contrast of the fitted residual rejects at 4 of 5 stratifications ($p=0.033$, $<0.001$, $0.003$, $0.003$)*. **It was an artifact of the implementation, not a property of the data.** The engine centred the instrument at $\bar W$ rather than at $\varrho(\Delta Z)$ -- the moment of the *unconditional* restriction, which is the predecessor's model and not A1 -- so the fitted residual was not an estimate of $\Delta U$ and retained the $W$-dependence the probe detects. With the corrected estimator nothing rejects at 5% ($p=0.109$, $0.132$, $0.594$, $0.072$, $0.075$). **This is not evidence that A1 holds**: the corrected operator reaches the iteration cap on 29-33 of 50 fold solves against 8-10 before, so the probe is now run on a noisier residual and has lost power. The honest status is *uninformative*, not *passes*. |
| **Controls are endogenous** | A1's second clause *is* $E[\Delta U\mid\Delta Z]=0$; joint $F$ on the differenced controls by $W$ is $6.85$ robust / $10.50$ clustered, $p<0.0001$, 7 of 22 imbalanced |

The fourth is the one the author identified: per capita income is plausibly a **bad control** —
first-differencing removes the level-sorting story ("richer people live in richer counties") but
not income *growth* correlated with property-value growth shocks.

## 2. The extension considered and set aside

**Instrument $\Delta Z$ as well, so that $\hat\theta$ nests TSLS at $\varphi\equiv0$.**

Architecturally this is clean. $\Delta Z$ enters in exactly two places — the moment
$\psi = \Delta Z\,\Delta U + \widetilde W L(\Delta U,\Delta Z)$ and the right-hand side of the
representer equation $\mathcal A^\ast_{\mathrm{cond}}\ell^\Pi = -\nu/\pi$ — and substituting $V$ for
$\Delta Z$ in both leaves the **same adjoint equation with a different right-hand side**. The LF
solver, cross-fitting and stopping rule are untouched, and at $\varphi\equiv0$ the estimator becomes
$\hat\theta=(\mathbb E_n[V\Delta Z'])^{-1}\mathbb E_n[V\Delta Y]$, just-identified TSLS exactly.

**Set aside because the marginal contribution is small relative to the cost.** What would need
re-derivation: $J=E[V\Delta Z']$ is no longer symmetric (sandwich becomes $J^{-1}\Sigma J'^{-1}$);
A2's source condition is a *different* condition at the new $\nu$; **A1's conditioning set changes,
which changes the operator $\mathcal A$ itself and therefore every rate result, the source index and
the frontier**; over-identification introduces a GMM weighting step the paper does not have; and
$\ell_\star$'s existence is a new condition. Practically, a Bartik instrument for income growth has
its own exclusion problem in a hedonic regression — local labour demand moves property values
directly, not only through income — so it is not obviously easier than the restriction already
defended for $W$.

**One property that would have survived and is worth remembering:** $\theta$ would still be
identified by a *mean* restriction ($E[V\Delta U]=0$), so the paper's clean separation — independence
identifies $\varphi$, a mean restriction identifies $\theta$ — is preserved rather than muddied.

## 3. The structural insight that should drive any replacement

**The frontier condition changes shape when the propensity score is known.**

Observational: $\kappa\alpha>\tfrac14$ with $\alpha=r/(2r+d_Z)$ — needs a smooth $\varrho$ **and**
few controls. Known/constant $\varrho$: the propensity branch contributes nothing, $\hat\delta_n$
collapses to the parametric floor $n^{-1/2}\sqrt{\ln n}$, and the condition becomes
$\kappa>\tfrac12$, i.e. $\mu>\tfrac12$ — **already implied by `eq:muhalf`'s $\mu>\tfrac56$.**

Budgets $\sqrt n\,\delta_n^{2}$ at $\mu=2$ (computed 2026-08-04; **sketch, re-derive before citing**):

| $n$ | hedonic ($r=8/3,d_Z=5$) | known $\varrho$ |
|---|---|---|
| $10^3$ | 40.2 | 13.0 |
| $10^4$ | 77.8 | 13.0 |
| $10^5$ | 136.0 | 11.1 |
| $10^6$ | 222.4 | 8.7 |

**The observational budget RISES in $n$; the known-propensity budget FALLS.** That is the difference
between "more data cannot help" and "more data helps". It is still slow — the $(\ln n)^{3\kappa}$
factor persists, and at $\mu=5$, $n=10^6$ the budget is $4.5$, not below one — so the constant
$c_\delta$ still binds. But the *direction* flips, and that was the fatal property of §6.

## 4. Criteria for a replacement

1. **Randomly assigned binary instrument** — known propensity; no imputation, so the misclassification problem disappears.
2. **Few controls** — randomisation delivers this, and the frontier rewards small $d_Z$.
3. **A1 holds by design** — $\Delta U\perp\!\!\!\perp W$ *unconditionally*, so $\Delta Z$ need not be conditioned on and the bad-control problem evaporates.
4. **Large $n$.**
5. **Continuous endogenous $X$ where the nonlinearity is the economic point.**
6. **$T=2$ or more**, so the individual effect can be first-differenced.

This is the case the paper's own introduction already names: *randomized experiments with partial
compliance, where the intent-to-treat provides an obvious source of exogenous variation* (Krueger;
Torgovitsky).

## 5. Candidates

| Candidate | $W$ | $X$ (continuous, endogenous) | $n$ | Notes |
|---|---|---|---|---|
| ~~Oregon Health Insurance Experiment~~ | lottery won | healthcare utilisation / spending | ~75,000 | **REJECTED 2026-08-08 on the public use files** — `decisions/ohie-rejected-2026-08-08.md`. This row treated "utilisation / spending" as one variable. They are two, and the trade-off between them is fatal: utilisation is a censored **count** with a two-thirds atom at zero, and spending — which is continuous and twice-measured — is **not moved by the lottery** ($t=1.44$, $F\approx2.1$) while visit counts are ($t=3.67$) |
| **PROGRESA / Oportunidades** | village randomised | transfer amount (varies with household composition) | ~24,000 hh | Multiple rounds so $T=2$ natural; clustered assignment complicates the variance |
| **Vietnam draft lottery** | draft-eligible (birthdate) | years of schooling | census-scale | Cleanest possible instrument; nonlinearity is **sheepskin effects**. Weakness: panel structure must be constructed |
| **Job Corps / JTPA** | random assignment | hours of training | moderate | Clear nonlinear dose-response |
| Moving to Opportunity | voucher lottery | neighbourhood poverty rate | ~4,600 | **Too small** for the frontier |

## 6. Recommendation, if §6 is ever replaced

~~**OHIE**, with the draft lottery as fallback if its panel structure works out.~~

**WITHDRAWN 2026-08-08.** OHIE was checked directly and rejected; see
`decisions/ohie-rejected-2026-08-08.md`. Its panel structure was never the binding
constraint — $X$ was. HAPIN (`clinicaltrials.gov/study/NCT02944682`) is the better structural
fit but shares no individual participant data, so it is unavailable without a collaboration.
**§6 stands on the Chay--Greenstone data.** The reasoning below is retained because the
*criteria* in §4 are still the right ones; only the recommendation is withdrawn.

Two things make it more than a substitution. It converts the paper's weakest section into its
strongest: A1 stops being a defended assumption and becomes a design fact, so the probe that
currently rejects should pass. And the feasibility table, which now reads "never" at every
$d_Z>0$, becomes an argument *for* the method rather than a confession — the randomised design is
precisely where the frontier is satisfiable.

**The caveat a referee will raise:** with $\varrho$ known and constant, why is the propensity
machinery needed at all? The answer is that $\varphi$ remains the solution of an ill-posed
**nonlinear** operator equation — randomisation fixes the instrument, not the inverse problem — but
the paper would have to say so explicitly, since a substantial part of its current apparatus
estimates something a randomised design hands you.

## 7. What is NOT decided here

§6 stands as drafted. Nothing in the manuscript changes on the strength of this file. If §6 is
replaced, the theory is unaffected — §§2–4 make no reference to the application — but §5's Monte
Carlo design was chosen at a *frontier-clearing* configuration and would want revisiting against a
known-propensity design, where the binding constraint is $\mu$ rather than $r$ and $d_Z$.
