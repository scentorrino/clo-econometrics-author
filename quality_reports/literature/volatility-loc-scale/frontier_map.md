# Frontier Map: where this paper sits in the NPIV landscape

**Project:** *Nonparametric Estimation of Location-Scale models with Endogenous regressors* (Centorrino & Florens)
**Date:** 2026-05-17

---

## 1. The frontier in two diagrams

### Diagram A — Where the literature is

```
                       SINGLE FUNCTION                     PAIR / VECTOR FUNCTION
                       (location only)                     (location & scale, or higher)
                   +-------------------------+-------------------------+
   EXOGENOUS X     |  Nadaraya-Watson, local |  Fan-Yao (1998),        |
   (X ⊥ U)         |  poly (Härdle 1990,     |  Ruppert-Wand-Holst-    |
                   |   Masry 1995)           |  Hössjer (1997)         |
                   +-------------------------+-------------------------+
   ENDOGENOUS X    |  NPIV: Newey-Powell '03,|  *** GAP ***            |
   E[U|W]=0        |  Hall-Horowitz '05,     |  Closed by this paper   |
   (MI route)      |  Darolles-Fan-Florens-  |  (and partially by      |
                   |  Renault '11,           |  Centorrino-Fève-       |
                   |  Chen-Christensen-      |  Florens '25 for the    |
                   |  Kankanala '24          |  location-only case)    |
                   +-------------------------+-------------------------+
   ENDOGENOUS X    |  Centorrino-Fève-       |  *** THIS PAPER ***     |
   U ⊥ W           |  Florens '25 (binary W, |                         |
   (FI route)      |  location only);        |                         |
                   |  Torgovitsky '15        |                         |
                   +-------------------------+-------------------------+
```

### Diagram B — Methodological toolkit

```
                          LINEAR INVERSE PROBLEM          NONLINEAR INVERSE PROBLEM
                          (operator linear in φ)          (operator nonlinear in (φ,σ))
                       +-------------------------+-------------------------+
   TIKHONOV            | Darolles et al. '11,    | Carrasco et al. '07     |
   (single-step)       | Carrasco et al. '07     | (general framework)     |
                       +-------------------------+-------------------------+
   LANDWEBER-FRIDMAN   | Carrasco et al. '07,    | Hanke-Neubauer-         |
   (iterative)         | Centorrino-Fève-        | Scherzer '95,           |
                       | Florens '25 (location-  | Kaltenbacher-Neubauer-  |
                       | only)                   | Scherzer '08            |
                       |                         | ▸ **THIS PAPER** ◂      |
                       +-------------------------+-------------------------+
   NEWTON-TYPE         |                         | Dunker-Florens-Hohage-  |
   (nested iterative)  |                         | Johannes-Mammen '14,    |
                       |                         | Bauer-Hohage '05        |
                       +-------------------------+-------------------------+
   ADAPTIVE STOPPING   | Cavalier-Tsybakov '02,  | *** GAP — partially  *** |
   / LEPSKII           | Mathé-Pereverzev '03,   | This paper extends the  |
                       | Hoffmann-Reiss '08      | linear oracle to the    |
                       | (linear, white noise);  | pair-valued nonlinear   |
                       | Chen-Christensen-       | NPIV setting            |
                       | Kankanala '24 (sieve    |                         |
                       | NPIV)                   |                         |
                       +-------------------------+-------------------------+
```

---

## 2. The gap this paper fills

**Stated plainly:** *Nonparametric joint estimation of conditional mean and conditional variance under endogeneity has, until now, only been done either (a) in the exogenous-regressor case (Fan-Yao 1998 and successors), (b) in the location-only NPIV case (Newey-Powell 2003; Centorrino-Fève-Florens 2025), or (c) parametrically (Centorrino-Pérez-Urdiales 2023; Alejo-Galvao-Martinez-Iriarte-Montes-Rojas 2024). The pair-valued, fully nonparametric, NPIV case is the present paper's territory.*

Three specific gaps closed:

1. **Identification at the pair level under both conditional-moment and full-independence restrictions.** Existing NPIV identification is for a single function under one of (i) a single conditional moment $E[Y-\varphi(X)\mid W]=0$ (Newey-Powell) or (ii) full independence $U\perp W$ (Centorrino-Fève-Florens 2025). The present paper unifies both routes in one local-identification framework — Proposition prp-onetoone — by adapting Chen-Chernozhukov-Lee-Newey (2014) to the pair-valued setting, and gives a primitive conditional-completeness condition (Assumption \ref{ass:condcomp}) with MI and FI variants. The Gaussian Example exm-gaussian gives a clean illustration of when each route point-identifies and when it fails (in particular, FI with binary $W$ identifies the *scalar* model — Centorrino-Fève-Florens 2025 — but in the location-scale case the additional unknown $\sigma$ raises the effective dimension and additional information ($\nu(W)$ varying, or $L\ge 3$ support points) is needed). This is the cleanest taxonomic statement of NPIV identifying power for the pair to date.

2. **Iterative regularization for a non-trivial nonlinear NPIV.** The Landweber-Fridman iteration has been applied to linear NPIV (Carrasco-Florens-Renault 2007) and to single-equation nonlinear NPIV (Centorrino-Fève-Florens 2025; Dunker et al. 2014 for Newton-type). The present paper extends LF to a pair-valued nonlinear inverse problem with Fréchet derivative acting on $L^2_X \times L^2_X$ and supplies the ball-preservation argument needed for local convergence (Proposition prp-convlf). The exponential reparameterization $\sigma=e^{-\omega}$ removes the constraint $\sigma>0$ that has stymied direct iteration on $(\varphi,\sigma)$ in earlier attempts.

3. **Adaptive stopping (Lepskii-MP) for nonlinear NPIV.** Cavalier-Tsybakov (2002), Mathé-Pereverzev (2003), and Hoffmann-Reiss (2008) prove adaptive oracle inequalities for *linear* statistical inverse problems. Bauer-Hohage (2005) extend Lepskii to Newton-type *deterministic* nonlinear inverse problems. Chen-Christensen-Kankanala (2024) supply data-driven adaptive sieve dimension for *linear* (single-equation, location-only) NPIV. **The Lepskii-MP oracle inequality for a pair-valued, nonlinear, statistical NPIV with empirical operators is, to our knowledge, new** (Proposition prp-lepskii). The proof requires a *per-iterate* variance bound monotone in $m$ (Lemma lem-itervar) and a deterministic-bias bound that aggregates source-condition contributions from both the population deviation and the empirical pilot — neither of which appears in the linear adaptive literature.

---

## 3. Closest competitors / predecessors

**Direct predecessor (prox 5):**

- **Centorrino, Fève, & Florens (2025, JoE).** The authors' own prior work. Same iterative framework (Landweber-Fridman in derivative coordinates) but applied to the *scalar* location-only model with discrete instruments. The present paper extends to the pair, switches the reparameterization from $(g, 1/\sigma)$ to the unconstrained $(g, \omega)=(-\varphi/\sigma, -\log\sigma)$, adds the Lepskii-MP adaptive stopping, and adds the MI/FI dichotomy.

**Contemporary close competitors (prox 4-5):**

- **Chen, Christensen, & Kankanala (2024, ReStud).** Sieve-NPIV with data-driven choice of sieve dimension, minimax sup-norm rates, uniform confidence bands. *Single function, single conditional moment*. The most current rival on adaptive NPIV — but for a different estimand (location only) and method (sieve, not iterative).

- **Dunker, Florens, Hohage, Johannes, & Mammen (2014, JoE).** Newton-type iterative regularization for nonlinear NPIV (single function). Methodological alternative; avoids LF saturation at the cost of nested iterations. The present paper's Section sec-rates explicitly contrasts.

- **Chernozhukov, Newey, & Santos (2023, Ecta).** Constrained NPIV inference under shape restrictions. *Different scope*: shape restrictions on the structural function. The positivity $\sigma>0$ here is enforced via reparameterization rather than as a constraint, so this is more a methodological cousin than a direct competitor.

**Methodological predecessors (prox 4):**

- **Darolles, Fan, Florens, & Renault (2011, Ecta).** Tikhonov-regularized linear NPIV. The single-step, linear ancestor.
- **Florens, Johannes, & Van Bellegem (2011, ET).** Adaptive (penalized) linear NPIV. Single function.
- **Carrasco, Florens, & Renault (2007).** The regularization-theory handbook reference.

---

## 4. What is genuinely new (versus recombination)

The paper is *not* simply a recombination of (i) Centorrino-Fève-Florens 2025 + (ii) Hanke-Neubauer-Scherzer 1995 + (iii) Mathé-Pereverzev 2003. Each combination would yield a tractable extension, but each requires non-trivial technical work that is genuinely new:

1. **Pair-valued Fréchet derivative and its spectral structure.** The Fréchet derivative $\mathsf{T}'_{\text{FI}, b_\dagger}$ acts on $L^2_X \times L^2_X$ and is characterized by the polynomial-in-$U$ structure $\psi(U,X) = \tilde h(X) + U\,\tilde\omega(X)$. The Mehler-type expansions of Example exm-gaussian and the conditional-completeness assumption (Assumption \ref{ass:condcomp}) are *new* and have no scalar predecessor. The MI variant — using two conditional moments of $U$ — is itself an identification refinement that goes beyond the existing NPIV vocabulary.

2. **The $(g,\omega) = (-\varphi/\sigma, -\log\sigma)$ reparameterization.** Replacing the constrained problem on $\{\sigma\ge R_\sigma > 0\}$ by an unconstrained problem on $L^2_X \times L^2_X$ is the technical move that makes the iteration well-defined. The earlier $(g, 1/\sigma)$ reparameterization in Centorrino-Fève-Florens (2025) for a scalar problem is much weaker — it allows $\sigma\to 0$ along the iteration. The exponential parameterization is novel for nonparametric IV.

3. **The pair-valued Hilbert-scale framework with linked source and link conditions.** Assumptions \ref{ass:sourcecond} (source condition on the *derivative* of $b_0-b_\dagger$) and \ref{ass:linkcond} (link between $\mathsf{T}'^*_{b_\dagger}\mathsf{T}'_{b_\dagger}$ and $D^{-1}$) are joint conditions on the pair. Their interplay with the saturation index $\beta_\epsilon = \beta\wedge(1-\epsilon)$ is a new contribution.

4. **The Lepskii-MP oracle inequality for the empirical pair-valued nonlinear problem.** The per-iterate variance bound (Lemma lem-itervar) propagates *two* operator-approximation rates $(\delta_n,\gamma_n)$ through LF and combines them with the saturation index. The proof of Proposition prp-lepskii is not a direct transfer from Mathé-Pereverzev (2003): the noise structure is non-Gaussian (kernel density / empirical operators), the operator is nonlinear, and the bias contributions aggregate population *and* empirical pilot pieces.

5. **The MI / FI taxonomy.** The clean statement that "MI ⇔ continuous $W$ ⇔ two-moment route" and "FI ⇔ discrete or continuous $W$ ⇔ independence route" (with the corresponding rate consequences and saturation indices) is a contribution in its own right. The MI route reduces saturation from $\beta\wedge(1-\epsilon)$ to plain $\beta$ — a substantive rate improvement — and removes the dependence on the nuisance density $f_U$.

---

## 5. Scooping risk assessment

We scanned NBER WP, SSRN, arXiv, and the journals AER / Ecta / JoE / ET / JBES / QE / ReStud / Annals for 2023-2026 papers on:
- nonparametric IV with location-scale or conditional-variance estimation;
- adaptive estimation for nonlinear NPIV;
- Lepskii-type stopping for statistical inverse problems with operator noise.

**Findings:**

| Candidate scoop | Year | Distance | Verdict |
|---|---|---|---|
| Alejo et al., *Endogenous Heteroskedasticity in Linear Models* (arXiv 2412.02767) | 2024 (rev. 2025) | Linear model + control function | **Not a scoop.** Different model class (linear), different method (control function, not NPIV). Positions the present paper as the nonparametric analog. |
| Chen-Christensen-Kankanala, *Adaptive Estimation and Uniform Confidence Bands...* (ReStud) | 2024 (pub. 2025) | Sieve NPIV, single function, adaptive sup-norm | **Not a scoop, but a direct contemporary.** Different estimand (location only), different method (sieve, not iterative). Co-citation strategy: position as parallel adaptive-NPIV work. |
| Florens-Lapenta, *Partly linear IV regressions without smoothing on the instruments* (TEST 33(3), 897-920, 2024) | 2024 | Partly linear NPIV, no instrument smoothing | **Not a scoop.** Different design (partly linear, not full nonparametric); orthogonal to location-scale + endogeneity. |
| Beyhum-Lapenta-Lavergne, working paper on smoothing-spline NPIV | 2025 | Single function, spline regularization | **Not a scoop.** Different scope. |
| Bruns-Smith, *Two-Stage Machine Learning for NPIV* (JMP) | 2024 | Single function, ML regularization | **Not a scoop.** Different method (ML). |
| Distributional / quantile IV papers (arXiv 2406.19986; 2311.15871; 2601.16865) | 2023-2026 | Different estimand (CDF / quantile) | **Not a scoop.** Different object. |
| Newton-Landweber in Banach spaces (Werner '15 line, several 2023-2024 papers in De Gruyter, Springer) | 2023-2024 | Pure inverse-problems literature | **Not a scoop.** Generic mathematical methods; not applied to NPIV. |

**Overall risk: LOW.** No working paper in the public domain (as of May 2026) attempts joint nonparametric estimation of the conditional mean and conditional variance under endogeneity. The closest is Alejo et al. (2024) in the parametric linear case, which positions the present paper rather than scoops it.

**Risk to monitor:** the Chen-Christensen-Kankanala "adaptive NPIV" program could plausibly extend to vector-valued / location-scale settings. Recommend submitting before any such extension surfaces. The September 2025 version of CCK already sets the adaptive-NPIV bar at the sieve / sup-norm frontier; the present paper is the iterative-regularization / pair-valued counterpart and should be staked promptly.

---

## 6. Where the location-scale + endogeneity intersection sits in the broader NPIV landscape

The intersection sits *between* two literatures that the paper newly joins:

- **The NPIV literature** has been organized around (i) the choice of regularization — Tikhonov, LF, sieve; (ii) the choice of identifying restriction — single conditional moment vs full independence; (iii) the choice of estimand — single function, functional of the function, derivative; (iv) the inference target — pointwise CIs, sup-norm bands, uniform inference. Almost every paper picks one cell of this 4-dimensional cube.

- **The conditional-variance / volatility literature** has been organized around (i) the form of heteroskedasticity — multiplicative, additive, ARCH/GARCH; (ii) exogenous vs endogenous regressors; (iii) parametric vs nonparametric. Under exogeneity, the joint nonparametric estimation of $(\varphi,\sigma)$ is essentially solved (Fan-Yao 1998 and successors). Under endogeneity, only the parametric case has been treated (Alejo et al. 2024; Centorrino-Pérez-Urdiales 2023).

The present paper sits at the joint cell {pair-valued, NPIV, iterative LF, adaptive Lepskii, MI/FI both available, $L^2$ rates}. This cell is, to the best of our knowledge, *empty before this paper*. The methodological contribution is to show that the cell is reachable — the pair-valued nonlinear inverse problem is tractable provided one (i) reparameterizes to unconstrain $\sigma$, (ii) lifts the source and link conditions to the pair, and (iii) propagates two operator-approximation rates through the iteration.

---

## 7. Suggested target tier (for the Positioning memo, see `positioning.md`)

Given the contribution profile (theory-heavy, pair-valued, two empirical applications):

- **First choice:** *Econometrica* (theory track) — the contribution is methodological enough, the identification and rate results sit at the right altitude, and the two empirical applications give the editor a concrete payoff. Cycle time, however, is long.
- **Strong second:** *Review of Economic Studies* — would value the joint identification + adaptive estimation story and has just published Chen-Christensen-Kankanala (2024), so the editorial taste is aligned.
- **Strong econometrics venue:** *Journal of Econometrics* — natural venue given the authors' prior history (Centorrino-Fève-Florens 2025) and the kind of methodological depth that JoE actively wants.
- **Methods-leaning specialty:** *Econometric Theory* — would prize the Hilbert-scale / Lepskii machinery and is friendly to long theory papers.
- **Adjacent:** *Annals of Statistics* — would value the adaptive Lepskii oracle inequality but might prefer the inverse-problem framing scrubbed of the econometric application.
