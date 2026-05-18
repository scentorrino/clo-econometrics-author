# Positioning Recommendation

**Project:** *Nonparametric Estimation of Location-Scale Models with Endogenous Regressors*
**Authors:** S. Centorrino & J.-P. Florens
**Compiled:** 2026-05-17

---

## 1. Suggested target journals (ranked)

| Rank | Journal | Why a fit | Risk |
|------|---------|-----------|------|
| 1 | **Econometrica (theory track)** | Methodology bar matches; the paper develops identification, an estimator, asymptotic rates, *and* an adaptive stopping rule with an oracle inequality. Two empirical applications (one cross-sectional, one time-series) supply the application payoff that the theory editors expect. Chen-Christensen-Kankanala (2024) was at ReStud, but Chernozhukov-Newey-Santos (2023, Ecta) shows the appetite for NPIV theory at Ecta. | 18-30 month cycle. Two-round revision likely. |
| 2 | **Review of Economic Studies** | Published Chen-Christensen-Kankanala (2024) on adaptive NPIV. Editorial taste is aligned and there is a recent precedent for adaptive-NPIV theory. The pair-valued extension is the obvious next step in that lineage. | Less theory-friendly than Ecta; one of the two empirical applications must carry weight. |
| 3 | **Journal of Econometrics** | Natural home given the authors' prior (Centorrino-Fève-Florens 2025 at JoE) and JoE's willingness to publish long theory papers in NPIV. Shorter cycle, higher acceptance, but less prestige. | Lower marginal impact than Ecta or ReStud; could be Plan B after one Ecta rejection. |
| 4 | **Econometric Theory** | Would prize the Hilbert-scale / Lepskii-MP machinery and the proof structure. Very theory-friendly, generous page budget. | Lower citation profile; less reach into applied audience. |
| 5 | **Annals of Statistics** | The adaptive Lepskii oracle inequality for a pair-valued nonlinear inverse problem with empirical operator noise is a contribution that Annals would value, *if* the inverse-problem framing is foregrounded and the econometric application is moved to background. | Major scope-recalibration: would need to strip the empirical applications and reframe as a statistical inverse-problems paper. |
| 6 | **Quantitative Economics** | Open-access AEA venue, friendly to NPIV theory. Backup if Ecta and ReStud reject. | |

**Recommended sequence:** Ecta → ReStud → JoE. Total expected time ~3-4 years to landing.

**Alternative sequence (if speed matters):** JoE → ET. Total expected ~1.5-2 years.

---

## 2. Suggested contribution statement

For the introduction / cover letter:

> *We develop nonparametric identification and estimation of the location-scale model $Y = \varphi(X) + \sigma(X)\,U$ when $X$ is endogenous and $W$ is an instrument. Our contribution is threefold.*
>
> *First, we characterize local identification of the pair $(\varphi, \sigma)$ under two alternative restrictions on $U \mid W$ — the conditional-moment route $E[U\mid W]=0,\ \mathrm{Var}[U\mid W]=1$ (which is natural when $W$ is continuous) and the full-independence route $U\perp W$ (which remains informative when $W$ is discrete) — through a single pair-valued conditional-completeness condition that nests both. The framework places the location-scale problem with discrete instruments on the same identification footing as the continuous-instrument case, which had not been done.*
>
> *Second, we propose a Landweber-Fridman iteration in derivative coordinates on the unconstrained reparameterization $b = (-\varphi/\sigma, -\log\sigma)$, prove local convergence under a ball-preservation condition, and derive the MISE rate in a pair-valued Hilbert-scale framework. The derivative-coordinate trick used in Centorrino-Fève-Florens (2025) for the scalar case lifts cleanly to the pair, with the additional ingredient that the Hilbert-scale link condition is now stated jointly for the two components.*
>
> *Third, we prove that the Lepskii-Mathé-Pereverzev balancing principle delivers an adaptive estimator that attains the same rate up to a $\sqrt{\log M_n}$ factor without knowing the source-condition exponent $\beta$. This is the first adaptive oracle inequality for a pair-valued nonlinear inverse problem with empirical (statistical) operator noise.*

This formulation positions the paper as a theory contribution with explicit method, identification, and adaptive-rate dimensions — each of which can be defended independently in front of a referee.

---

## 3. How to frame the contribution (rhetoric)

### What to lead with

1. **The pair-valued identification taxonomy.** MI vs FI is a clean dichotomy with practical consequences: continuous instruments unlock MI (faster rate, no $f_U$ nuisance), discrete instruments require FI (slower rate, $f_U$-dependent saturation). Most readers will recognize the analogy to Newey-Powell vs Centorrino-Fève-Florens.

2. **The exponential reparameterization.** Easy to explain in two sentences. Solves the $\sigma>0$ constraint without Lagrange multipliers. Reviewers familiar with optimization will appreciate it; reviewers familiar with inverse problems will recognize it as the natural extension of $(g, 1/\sigma)$.

3. **Adaptive stopping with empirical operators.** Lepskii-MP is well-known; the new content is that the oracle inequality survives the move from linear deterministic-noise to pair-valued nonlinear statistical-noise. This is the part that referees from the inverse-problems community will scrutinize most.

### What to de-emphasize

- The Monte Carlo evidence and empirical applications are illustrative, not central. They should not be the gateway to the paper. The Nepal application is from Centorrino-Pérez-Urdiales (2023) and the interest-rate application is standard — the contribution is methodological.

- The MI route, while elegant, has the disadvantage that the most common empirical use case (binary instruments) requires FI. The MI route should be presented as the cleaner theoretical case ("here is what happens with continuous instruments") and the FI route as the empirically relevant one.

### What to anticipate

- **"Why not Newton-Landweber?"** Dunker et al. (2014) avoid the LF saturation. The paper should pre-empt this by noting that (i) Newton requires nested iterations, doubling the operator-approximation budget, and (ii) the LF saturation at $\beta_\epsilon = \beta\wedge(1-\epsilon)$ is mild — the "$1-\epsilon$" comes from the nuisance density correction in the adjoint and binds only when the source-condition smoothness is very high.

- **"Why not sieves (à la Chen-Christensen-Kankanala 2024)?"** The pair-valued problem with the exponential reparameterization does not have an obvious sieve. The LF iteration is the natural choice when the operator is nonlinear and an explicit Fréchet derivative is available.

- **"Are these rates sharp / minimax?"** Honest answer: the rates are upper bounds matching the linear-NPIV minimax under $\beta\leq 1-\epsilon$ and degraded by the saturation when $\beta>1-\epsilon$. A formal minimax lower bound for the pair-valued nonlinear problem is an open question. The paper should say this explicitly.

---

## 4. Anticipated referee compositions

### For Econometrica / ReStud / JoE submission

The editors will likely assign:

**Referee A — econometric theorist, NPIV specialist.** Likely from the Chen / Christensen / Pouzo / Horowitz / Newey / Powell / Florens-Johannes-Van Bellegem circle.
- *Will emphasize:* sharpness of identification, completeness conditions, comparability to existing NPIV rates, novelty relative to single-equation NPIV.
- *Lit they will check:* Newey-Powell 2003; Hall-Horowitz 2005; Darolles et al. 2011; Chen-Pouzo 2012/2015; Chen-Christensen-Kankanala 2024; Centorrino-Fève-Florens 2025.

**Referee B — inverse-problems / nonparametric statistician.** Likely from the Cavalier / Mathé / Pereverzev / Hoffmann / Reiss / Hohage / Kaltenbacher / Dunker circle.
- *Will emphasize:* tightness of source/link conditions, validity of the saturation argument, correctness of the Lepskii-MP transfer to the pair-valued statistical case, comparison with Newton-type schemes (Dunker et al. 2014).
- *Lit they will check:* Engl-Hanke-Neubauer 2000; Hanke-Neubauer-Scherzer 1995; Bauer-Hohage 2005; Cavalier-Tsybakov 2002; Mathé-Pereverzev 2003; Hoffmann-Reiss 2008; Dunker et al. 2014.

**Referee C (if assigned) — applied econometrician familiar with stochastic frontier / volatility modeling.** Likely from the Kumbhakar / Parmeter / Simar / Sickles / Van Keilegom circle.
- *Will emphasize:* the empirical applications, whether the Nepal application advances Centorrino-Pérez-Urdiales (2023), whether the interest-rate application improves on Aït-Sahalia (1996) / Stanton (1997).
- *Lit they will check:* Just-Pope 1978/1979; Kumbhakar-Lovell 2000; Centorrino-Pérez-Urdiales 2023; Alejo et al. 2024; CIR 1985; Aït-Sahalia 1996; Stanton 1997; Parmeter et al. 2024.

### Preparation checklist for referees

To insulate against the referees-from-different-traditions failure mode:

1. **Identification section:** cite Newey-Powell, Hall-Horowitz, Florens-Mouchart 1990, Chen-Chernozhukov-Lee-Newey 2014, Centorrino-Fève-Florens 2025 — establishes the econometric tradition for Referee A.

2. **Estimation / rates section:** cite Carrasco-Florens-Renault 2007, Engl-Hanke-Neubauer 2000, Hanke-Neubauer-Scherzer 1995, Kaltenbacher-Neubauer-Scherzer 2008, Tautenhahn 1996, Mair 1994 — anchors the regularization tradition for Referee B.

3. **Adaptive stopping section:** cite Lepskii 1990, Mathé-Pereverzev 2003, Cavalier-Tsybakov 2002, Hoffmann-Reiss 2008, Bauer-Hohage 2005, Cavalier-Hengartner 2005, Blanchard-Hoffmann-Reiss 2017 — covers both the statistics and the inverse-problems versions of the Lepskii rule.

4. **Empirical applications:** cite Just-Pope 1978/1979, Kumbhakar-Lovell 2000, Centorrino-Pérez-Urdiales 2023 (for the Nepal application); Cox-Ingersoll-Ross 1985, Aït-Sahalia 1996, Stanton 1997 (for the interest-rate application). Acknowledge Alejo et al. 2024 as the contemporaneous parametric linear analog.

5. **Methodological alternatives:** explicitly contrast with Dunker et al. 2014 (Newton-type), Chen-Christensen-Kankanala 2024 (sieve adaptive), Chernozhukov-Newey-Santos 2023 (constrained moments) — heads off the "why not X" objection from each tradition.

---

## 5. Differentiation from the closest competitors

For the introduction and the cover letter:

| Competitor | What they do | What we do differently |
|---|---|---|
| Centorrino-Fève-Florens (2025, JoE) | Scalar NPIV $E[Y-\varphi(X)\mid W]=0$ with discrete $W$, LF iteration | Pair-valued $(\varphi,\sigma)$, MI *and* FI routes, exponential reparameterization, Lepskii-MP adaptive stopping |
| Chen-Christensen-Kankanala (2024, ReStud) | Sieve NPIV, single function, adaptive sup-norm | LF iteration, pair function, adaptive $L^2$ via Lepskii-MP |
| Dunker et al. (2014, JoE) | Newton-Landweber for nonlinear NPIV, single function | LF (simpler, no nested iterations), pair function, adaptive stopping |
| Chernozhukov-Newey-Santos (2023, Ecta) | Constrained NPIV with shape restrictions | Constraint $\sigma>0$ removed by reparameterization, pair function, iterative not GMM |
| Alejo et al. (2024, arXiv) | Linear model with endogenous heteroskedasticity, control function | Nonparametric $(\varphi,\sigma)$, NPIV with $E[U\mid W]=0,\mathrm{Var}[U\mid W]=1$ or $U\perp W$ |
| Fan-Yao (1998, Biometrika) | Local-polynomial conditional variance under exogeneity | Allow $X$ endogenous, instrument $W$, joint $(\varphi,\sigma)$ estimation |

---

## 6. Cover letter sketch

> *Dear Editor,*
>
> *Please find enclosed our manuscript "Nonparametric Estimation of Location-Scale Models with Endogenous Regressors." The paper develops nonparametric identification and adaptive estimation of the conditional mean $\varphi$ and the conditional scale $\sigma$ in the model $Y=\varphi(X)+\sigma(X)\,U$ when $X$ is endogenous and $W$ is an instrument. To our knowledge, this is the first treatment of the pair-valued NPIV problem.*
>
> *Three contributions are worth flagging:*
>
> *(i) A unified local-identification framework that accommodates both conditional-moment ($E[U\mid W]=0,\ \mathrm{Var}[U\mid W]=1$) and full-independence ($U\perp W$) restrictions. The two routes have complementary strengths: the former is natural with continuous instruments, the latter remains informative when $W$ is discrete with finite support. Both are derived as primitive conditional-completeness conditions on the pair.*
>
> *(ii) A Landweber-Fridman iteration on the unconstrained reparameterization $(g,\omega)=(-\varphi/\sigma,-\log\sigma)$. We prove local convergence, derive the MISE rate in a pair-valued Hilbert-scale framework, and obtain rates that match the linear-NPIV minimax in the unsaturated regime.*
>
> *(iii) A Lepskii-Mathé-Pereverzev adaptive stopping rule that attains the rate up to a logarithmic adaptation cost without knowing the source-condition exponent. This is the first oracle inequality of this kind for a pair-valued nonlinear inverse problem with empirical operator noise.*
>
> *The paper concludes with two empirical applications: a Just-Pope production function on a cross-section of Nepali vegetable farmers (binary instrument, FI route) and a heteroskedastic nonlinear autoregression of the U.S. short rate (continuous instrument, MI route).*
>
> *We believe the paper is a natural fit for [Journal] given [Journal's] recent publications on adaptive NPIV (Chen-Christensen-Kankanala 2024 in ReStud; Chernozhukov-Newey-Santos 2023 in Ecta).*

---

## 7. Risk register for submission

| Risk | Mitigation |
|------|-----------|
| Reviewer wants a minimax lower bound to confirm rate is sharp | Acknowledge as open question in the conclusion; cite Dunker et al. for the linear lower bound and note the pair-valued lower bound is an open problem |
| Reviewer asks for uniform / sup-norm rates rather than $L^2$ | Acknowledge that sup-norm extension is feasible via Chen-Christensen-style arguments but outside the scope; cite Chen-Christensen 2018 |
| Reviewer asks for inference (CIs, test, bands) | Note that the multiplier bootstrap in the empirical sections is a step toward inference; formal validity is left for future work |
| Reviewer suggests comparing to sieve NPIV head-to-head | Add a Monte Carlo comparison if time permits; otherwise, frame as methodological alternative |
| Reviewer asks about the empirical relevance / external validity | The Nepal application connects to Centorrino-Pérez-Urdiales (2023); the interest-rate application connects to the term-structure / CIR literature. Both are recognized testbeds. |
| Scoop by adaptive-NPIV extension (e.g. CCK going to pairs) | Submit promptly. The paper is sufficiently differentiated by the FI route and the exponential reparameterization that an adaptive-NPIV extension would not subsume it, but the contribution window for the LF / Lepskii / pair-valued combination should not be left open indefinitely. |
