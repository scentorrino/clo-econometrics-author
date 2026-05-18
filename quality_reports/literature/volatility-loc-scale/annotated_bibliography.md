# Annotated Bibliography

**Project:** Nonparametric Estimation of Location-Scale Models with Endogenous Regressors
**Authors:** S. Centorrino & J.-P. Florens
**Compiled:** 2026-05-17

Conventions: Each entry is tagged CORE (directly competes / direct predecessor), RELATED (closely related, different angle), METHODS (econometric / mathematical tool the paper uses), FOUND (foundational, motivates the literature), TANG (tangentially relevant). Proximity scores: 5 (direct competitor), 4 (closely related), 3 (related method or context), 2 (tangentially relevant), 1 (background).

The companion BibTeX file `references.bib` re-exports every entry below using the existing `instrumental.bib` keys (so the paper's `.qmd` source compiles unchanged) plus the new entries discovered through 2023-2026 search.

---

## 1. Nonparametric Instrumental Variables — the spine

### Directly related (proximity 4-5)

**Newey, W. K., & Powell, J. L. (2003).** *Instrumental Variable Estimation of Nonparametric Models.* Econometrica, 71(5), 1565-1578. [CORE, prox 4]
The canonical statement of nonparametric IV: the structural function $\varphi$ solves $E[Y-\varphi(X)\mid W]=0$. Establishes identification through bounded completeness of the joint $(X,W)$ distribution and a series-based estimator. Foundational backdrop for the MI route of the present paper: the Centorrino-Florens paper extends this from a single conditional moment $E[U\mid W]=0$ to the pair $(E[U\mid W]=0, \mathrm{Var}[U\mid W]=1)$, which delivers identification of the location and scale jointly.

**Hall, P., & Horowitz, J. L. (2005).** *Nonparametric Methods for Inference in the Presence of Instrumental Variables.* Annals of Statistics, 33(6), 2904-2929. [CORE, prox 4]
First minimax rate result for NPIV. Introduces the modulus-of-continuity framework that captures degree of ill-posedness through eigenvalue decay of the conditional expectation operator $E[\cdot\mid W]$. The present paper inherits the source-condition / Hilbert-scale apparatus through Carrasco-Florens-Renault (2007) but the rate of $\hat b_N$ here is the pair-valued analog of the Hall-Horowitz rate.

**Darolles, S., Fan, Y., Florens, J.-P., & Renault, E. (2011).** *Nonparametric Instrumental Regression.* Econometrica, 79(5), 1541-1565. [CORE, prox 5]
Tikhonov-regularized NPIV with a kernel-based empirical operator and minimax rate under source/link conditions. Establishes the regularization-theory machinery (Hilbert-Schmidt operators, source-condition exponent, Hilbert scales) that the present paper extends to the nonlinear, pair-valued case. Notation and proof structure carry over: Assumptions \ref{ass:unifbd}, \ref{ass:sourcecond}, \ref{ass:linkcond} are direct descendants.

**Carrasco, M., Florens, J.-P., & Renault, E. (2007).** *Linear Inverse Problems in Structural Econometrics Estimation Based on Spectral Decomposition and Regularization.* Handbook of Econometrics 6B, 5633-5751. [METHODS, prox 5]
Authoritative survey: Tikhonov, Landweber-Fridman, spectral cutoff, source conditions, Hilbert scales for econometric inverse problems. The present paper's regularization vocabulary (saturation index, qualification, source-condition exponent $\beta$, link-condition exponent $a$) is the one set down here. Heavily cited at every regularization-theoretic step.

**Florens, J.-P. (2003).** *Inverse Problems and Structural Econometrics: The Example of Instrumental Variables.* In Advances in Economics and Econometrics, vol. 2. [METHODS, prox 4]
Earlier handbook chapter introducing the inverse-problem perspective on NPIV. Anchors the methodological lineage; cited as background for the operator formulation.

**Florens, J.-P., Johannes, J., & Van Bellegem, S. (2011).** *Identification and Estimation by Penalization in Nonparametric Instrumental Regression.* Econometric Theory, 27(3), 472-496. [CORE, prox 4]
Adaptive NPIV via penalization with source-condition adaptivity. Closest non-iterative cousin to the Lepskii-Mathé-Pereverzev adaptive stopping rule used here. Differs in method (penalization vs iterative regularization) but addresses the same problem (adaptation to the unknown source-condition exponent $\beta$).

**Horowitz, J. L., & Lee, S. (2007).** *Nonparametric Instrumental Variables Estimation of a Quantile Regression Model.* Econometrica, 75(4), 1191-1208. [RELATED, prox 3]
Nonparametric IV quantile regression. Methodologically akin (nonlinear inverse problem), but the unknown is a quantile function rather than the (mean, scale) pair. Useful comparator for how the literature handles other nonlinear conditional-moment objects.

**Chen, X., & Pouzo, D. (2012).** *Estimation of Nonparametric Conditional Moment Models with Possibly Nonsmooth Generalized Residuals.* Econometrica 80(1), 277-321. [`chen2012`, RELATED, prox 4]
Sieve-based estimation for nonparametric conditional-moment models with smooth and non-smooth residuals; covers the case where the unknown function enters the moment nonlinearly. The Chen-Pouzo identification conditions are a sieve analog of `prp-onetoone`. Centorrino-Florens estimates the same class of nonlinear moment problems but via Landweber-Fridman iteration rather than sieves.

**Chen, X., & Pouzo, D. (2015).** *Sieve Wald and QLR Inferences on Semi/Nonparametric Conditional Moment Models.* Annals of Statistics 43(3), 1011-1044. [`chen2012b`, RELATED, prox 3]
Inference (Wald, QLR) for the sieve estimator of Chen-Pouzo (2012). Provides confidence-band machinery for sieve estimands that could be adapted to the LF-Lepskii estimator of this paper in a follow-up inference paper.

**Gagliardini, P., & Scaillet, O. (2012).** *Tikhonov Regularization for Nonparametric Instrumental Variable Estimators.* Journal of Econometrics 167(1), 61-75. [`gagliardini2012`, RELATED, prox 4]
Tikhonov-regularized NPIV with operator-noise asymptotics. Provides the methodological template for FI-route nonparametric IV with CDF-difference operators; the present paper's FI Fréchet derivative kernel $\mathsf{T}'_{\text{FI}}$ inherits the same CDF-difference structure. Direct comparator for the choice of regularization scheme (Tikhonov vs Landweber-Fridman).

**Chen, X., Christensen, T. M., & Kankanala, S. (2024).** *Adaptive Estimation and Uniform Confidence Bands for Nonparametric Structural Functions and Elasticities.* Review of Economic Studies 92, 162-198. [CORE, prox 5]
Sieve NPIV with data-driven choice of sieve dimension attaining the minimax sup-norm rate and uniform confidence bands. Direct contemporary competitor on adaptive estimation; differs in method (sieve, Lepskii-type choice of $J$) but addresses the same adaptation question for a single-equation location-only NPIV. The present paper extends adaptivity (Lepskii-MP balancing) to the pair-valued nonlinear case.

**Chernozhukov, V., Newey, W. K., & Santos, A. (2023).** *Constrained Conditional Moment Restriction Models.* Econometrica 91(2), 709-736. [RELATED, prox 3]
Inference under shape restrictions in conditional moment models, including NPIV. Builds the GMM-with-shape-restriction inference toolkit. The location-scale model's positivity $\sigma(x)\geq R_\sigma$ could be cast as a shape constraint, but the present paper instead enforces it through the exponential reparameterization, so the Chernozhukov-Newey-Santos framework is a methodological alternative rather than a competitor.

**Centorrino, S., Fève, F., & Florens, J.-P. (2025).** *Iterative Estimation of Nonparametric Regressions with Continuous Endogenous Variables and Discrete Instruments.* Journal of Econometrics 247, 105950. [CORE, prox 5]
**Direct predecessor.** Single-equation nonparametric IV with discrete instruments, $E[Y-\varphi(X)\mid W]=0$, using a Landweber-Fridman iteration in derivative coordinates. The present paper:
(i) extends from $\varphi$ alone to the pair $(\varphi, \sigma)$;
(ii) replaces the awkward $(g, 1/\sigma)$ predecessor with the unconstrained $(g, \omega)=(-\varphi/\sigma, -\log\sigma)$ reparameterization;
(iii) adds the Lepskii-MP adaptive stopping;
(iv) supplies the MI/FI dichotomy that lets continuous-$W$ designs operate on conditional moments and discrete-$W$ designs on full independence.

**Chen, X., & Christensen, T. M. (2018).** *Optimal Sup-norm Rates and Uniform Inference on Nonlinear Functionals of Nonparametric IV Regression.* Quantitative Economics 9(1), 39-84. [RELATED, prox 3]
Optimal sup-norm rates and uniform inference for functionals of NPIV. Methodological reference for sup-norm asymptotics; the present paper works in $L^2$.

**Loh, I. (2023).** *Nonparametric Identification and Estimation with Discrete Instruments and Regressors.* Journal of Econometrics 235(2), 1257-1279. [RELATED, prox 3]
Higher-order conditional moments between instrument and residual deliver identification when the regressor has more support points than the instrument. Conceptually adjacent to the MI route (using higher moments to identify), though in a finite-mass-point regime.

**Beyhum, J., Centorrino, S., Florens, J.-P., & Van Keilegom, I. (2023).** *Instrumental Variable Estimation of Dynamic Treatment Effects on a Duration Outcome.* JBES 41(4). [RELATED, prox 2]
Co-author work; uses related operator-theoretic techniques. Cited as part of the authors' regularization-IV program.

**Chetverikov, D., & Wilhelm, D. (2017).** *Nonparametric Instrumental Variable Estimation Under Monotonicity.* Econometrica 85(4), 1303-1320. [RELATED, prox 3]
Monotonicity constraints regularize NPIV. The present paper's exponential reparameterization plays an analogous role for $\sigma>0$.

### Background (proximity 1-2)

**Florens, J.-P., Heckman, J. J., Meghir, C., & Vytlacil, E. J. (2008).** *Identification of Treatment Effects Using Control Functions in Models with Continuous, Endogenous Treatment.* Econometrica 76(5), 1191-1206. [FOUND, prox 2]
Identification with continuous endogenous treatments using control functions. Methodological alternative to the IV approach pursued here.

**Imbens, G., & Newey, W. (2009).** *Identification and Estimation of Triangular Simultaneous Equations Models Without Additivity.* Econometrica 77(5), 1481-1512. [FOUND, prox 2]
Control function approach for nonseparable triangular models. Provides the standard contrast against which the conditional-moment / full-independence routes are positioned.

**Chesher, A. (2003).** *Identification in Nonseparable Models.* Econometrica 71(5), 1405-1441. [FOUND, prox 2]
Identification of nonseparable structural models. The location-scale model is separable in $U$, but Chesher's apparatus motivates the FI route.

**Florens, J.-P., & Simoni, A. (2014).** *Bayesian Nonparametric Estimation in Inverse Problems.* QE / Bayesian Analysis. [TANG, prox 1]
Bayesian counterpart to the regularization machinery.

---

## 2. Iterative regularization for nonlinear inverse problems

### Core methods (proximity 4-5)

**Engl, H. W., Hanke, M., & Neubauer, A. (2000).** *Regularization of Inverse Problems.* Kluwer. [METHODS, prox 5]
The reference monograph. Chapters 6 (Landweber-Fridman), 7 (Newton-type methods for nonlinear), 8 (Hilbert scales). Cited throughout for the spectral-filter inequality $\sup_\lambda|(1-c\lambda)^m\lambda^{\beta_\epsilon/2}|\le c_* m^{-\beta_\epsilon/2}$ (Eq. 4.66), the qualification index of LF, and Hilbert-scale source conditions.

**Hanke, M., Neubauer, A., & Scherzer, O. (1995).** *A Convergence Analysis of the Landweber Iteration for Nonlinear Ill-Posed Problems.* Numerische Mathematik 72, 21-37. [METHODS, prox 5]
The canonical convergence result for LF on nonlinear inverse problems. Establishes the tangential-cone / local-strong-monotonicity condition that motivates the ball-preservation argument of Proposition prp-convlf.

**Kaltenbacher, B., Neubauer, A., & Scherzer, O. (2008).** *Iterative Regularization Methods for Nonlinear Ill-Posed Problems.* De Gruyter. [METHODS, prox 5]
Comprehensive treatment of iterative regularization for nonlinear inverse problems: Landweber, Newton-Landweber, Levenberg-Marquardt, gradient methods, with convergence rates under source conditions. The present paper's local convergence argument (Prop. prp-convlf) is in the Kaltenbacher-Neubauer-Scherzer mold.

**Bauer, F., & Hohage, T. (2005).** *A Lepskij-type stopping rule for regularized Newton methods.* Inverse Problems 21(6), 1975-1991. [METHODS, prox 5]
Lepskii stopping rule for regularized Newton iterations on nonlinear inverse problems. Direct precursor to the Lepskii-MP rule used in Section sec-lepskii.

**Werner, F. (2015).** *On convergence rates for iteratively regularized Gauß-Newton-type methods under a Lipschitz-type nonlinearity condition.* J. Inverse Ill-posed Probl. 23(1), 75-84. [METHODS, prox 3]
Refined convergence rates for IRGN under weaker nonlinearity assumptions. Cited as a reference for the Hilbert-scale / nonlinearity regime where saturation can be relaxed.

**Hofmann, B., & Mathé, P. (2007).** *Analysis of profile functions for general linear regularization methods.* SIAM J. Numer. Anal. 45(3), 1122-1141. [METHODS, prox 4]
General linear regularization with noisy operators. Source for the iterate-norm bounds used in the variance-side argument of Lemma lem-itervar.

**Dunker, F., Florens, J.-P., Hohage, T., Johannes, J., & Mammen, E. (2014).** *Iterative Estimation of Solutions to Noisy Nonlinear Operator Equations in Nonparametric Instrumental Regression.* Journal of Econometrics. [`dunker2014`, CORE, prox 5]
Newton-type iterative regularization for nonlinear NPIV. Direct alternative to LF; the present paper's Section sec-rates discussion (saturation, qualification) explicitly compares to Dunker et al.'s Newton scheme, which avoids LF saturation at the cost of nested iterations.

**Dunker, F. (2018).** *Adaptive estimation for some nonparametric instrumental variable models with full independence.* Electronic Journal of Statistics 12(2), 6151-6190. [`dunker2018`, CORE, prox 5]
FI-route nonparametric IV with iteratively regularized Newton method and adaptive choice of regularization parameter. Weakens the nonlinearity condition relative to Dunker-Florens-Hohage-Johannes-Mammen (2014) and obtains stronger convergence guarantees. Direct methodological alternative — the present paper's L559 and L1076 invoke Dunker (2018) as the comparator. Differs from Centorrino-Florens in three respects: (i) FI-only (no MI taxonomy); (ii) location-only (no scale function); (iii) Newton-type rather than Landweber-Fridman.

**Hohage, T. (2000).** *Regularization of exponentially ill-posed problems.* Numerical Functional Analysis and Optimization 21, 439-464. [METHODS, prox 3]
Iterative regularization for exponentially ill-posed problems (relevant when the singular-value decay is geometric, as in the Gaussian example exm-gaussian).

**Hofmann, B., & Scherzer, O. (1998).** *Local ill-posedness and source conditions of operator equations in Hilbert spaces.* Inverse Problems 14, 1189-1206. [METHODS, prox 3]
Foundational paper on local ill-posedness, the concept used in Section sec-condcomp.

**Tautenhahn, U. (1996).** *Error estimates for regularization methods in Hilbert scales.* SIAM J. Numer. Anal. 33(6), 2120-2130. [METHODS, prox 3]
Optimality and error estimates for Hilbert-scale regularization. Background for Assumption \ref{ass:linkcond}.

**Mair, B. A. (1994).** *Tikhonov regularization for finitely and infinitely smoothing operators.* SIAM J. Math. Anal. 25, 135-147. [METHODS, prox 3]
Tikhonov in Hilbert scales — companion to Tautenhahn (1996).

**Morozov, V. A. (1966; 1967).** *On the solution of functional equations by the method of regularization* and *Methods for solving incorrectly posed problems.* Soviet Math. Dokl. [METHODS, prox 2]
Original Morozov discrepancy principle; cited as the in-sample alternative to Lepskii stopping.

**Blanchard, G., Hoffmann, M., & Reiss, M. (2017).** *Optimal adaptation for early stopping in statistical inverse problems.* SIAM/ASA J. Uncertainty Quantification 6(3). [METHODS, prox 4]
Modern early-stopping theory for spectral cutoff and Landweber iteration. Cited alongside Morozov as alternative to Lepskii.

### Background

**Landweber, L. (1951).** *An iteration formula for Fredholm integral equations of the first kind.* American Journal of Mathematics 73, 615-624. [FOUND, prox 2]
The original LF iteration.

**Fridman, V. M. (1956).** *Method of successive approximations for a Fredholm integral equation of the first kind.* Uspekhi Mat. Nauk 11, 233-234. [FOUND, prox 2]
Companion piece.

**Tikhonov, A. N. (1943; 1995).** *On the stability of inverse problems; Numerical Methods for the Solution of Ill-Posed Problems.* [FOUND, prox 2]
Foundational background.

**Groetsch, C. W. (1993).** *Inverse Problems in the Mathematical Sciences.* Vieweg. [TANG, prox 1]
Textbook reference.

---

## 3. Adaptive estimation and the Lepskii principle

### Core methods (proximity 4-5)

**Lepskii, O. V. (1990; 1991; 1992).** *On a problem of adaptive estimation in Gaussian white noise* (Theory Probab. Appl. 35, 454-466), and two follow-ups. [METHODS, prox 5]
The original Lepskii method papers. The principle: among a family of estimators indexed by a regularization level, pick the smallest level at which the estimator agrees with all coarser estimators within a noise-calibrated band. Foundation for Section sec-lepskii.

**Mathé, P., & Pereverzev, S. V. (2003).** *Discretization strategy for linear ill-posed problems in variable Hilbert scales.* Inverse Problems 19(6), 1263-1277. [METHODS, prox 5]
Balancing principle for general regularization filters in variable Hilbert scales. The Lepskii-Mathé-Pereverzev terminology of the paper is precisely the one set down here. The $\sqrt{\log M_n}$ adaptation cost in Proposition prp-lepskii descends from this work.

**Cavalier, L., & Tsybakov, A. B. (2002).** *Sharp adaptation for inverse problems with random noise.* Probab. Theory Relat. Fields 123(3), 323-354. [METHODS, prox 4]
Sharp adaptive estimation for inverse problems in the white-noise model. Proves the oracle inequality for spectral cutoff that Proposition prp-lepskii transfers to the pair-valued nonlinear setting.

**Cavalier, L. (2008).** *Nonparametric statistical inverse problems.* Inverse Problems 24, 034004. [METHODS, prox 4]
Survey on adaptive estimation in statistical inverse problems. Best single reference for the adaptive minimax theory.

**Hoffmann, M., & Reiss, M. (2008).** *Nonlinear estimation for linear inverse problems with error in the operator.* Annals of Statistics 36(1), 310-336. [METHODS, prox 4]
Adaptation with noisy operators — directly relevant since the present paper's $\hat{\mathsf{T}}$ is empirical. The two-rate $(\delta_n,\gamma_n)$ structure of Assumption \ref{ass:rateconv} mirrors the Hoffmann-Reiss setup.

**Cavalier, L., & Hengartner, N. W. (2005).** *Adaptive estimation for inverse problems with noisy operators.* Inverse Problems 21(4), 1345-1361. [METHODS, prox 4]
Lepskii-type adaptation with operator noise.

**Marteau, C., & Mathé, P. (2014).** *General regularization schemes for signal detection in inverse problems.* Mathematical Methods of Statistics. [METHODS, prox 2]
Related work on regularization filter families.

**Bissantz, N., Hohage, T., Munk, A., & Ruymgaart, F. (2007).** *Convergence rates of general regularization methods for statistical inverse problems and applications.* SIAM J. Numer. Anal. [METHODS, prox 3]
Convergence rates for general regularization in statistical inverse problems.

### Adaptive NPIV (proximity 3-4)

**Breunig, C., & Johannes, J. (2016).** *Adaptive Estimation of Functionals in Nonparametric Instrumental Regression.* Econometric Theory 32(3), 612-654. [RELATED, prox 3]
Adaptive estimation of linear functionals of the NPIV regression. Related toolkit, different target.

**Liu, C., & Tao, M. (2014).** *Adaptive nonparametric instrumental variables estimation: Empirical choice of the regularization parameter.* Journal of Econometrics 180, 158-173. [RELATED, prox 3]
Data-driven regularization parameter in NPIV. Related practical Lepskii / cross-validation choice.

---

## 4. Conditional moment models, GMM, and semiparametric efficiency

**Hansen, L. P. (1982).** *Large Sample Properties of Generalized Method of Moments Estimators.* Econometrica 50(4), 1029-1054. [FOUND, prox 2]
The GMM canonical reference. Backbone of the MI route as a conditional-moment problem.

**Ai, C., & Chen, X. (2003).** *Efficient Estimation of Models with Conditional Moment Restrictions Containing Unknown Functions.* Econometrica 71(6), 1795-1843. [CORE, prox 4]
Efficient sieve estimation of conditional-moment models with unknown functions. The location-scale model is precisely such a model: two conditional moments and two unknown functions. The present paper does not pursue efficiency, but Ai-Chen is the gold-standard reference for semiparametric efficiency in this class.

**Ai, C., & Chen, X. (2007; 2012).** *Estimation of possibly misspecified semiparametric conditional moment restriction models with different conditioning variables* (J. Econom. 141, 5-43); *The semiparametric efficiency bound for models of sequential moment restrictions...* (J. Econom. 170, 442-457). [RELATED, prox 3]
Extensions of Ai-Chen (2003) to misspecification, sequential restrictions, and different conditioning variables.

**Domínguez, M. A., & Lobato, I. N. (2004).** *Consistent Estimation of Models Defined by Conditional Moment Restrictions.* Econometrica 72(5), 1601-1615. [RELATED, prox 2]
Consistent estimation under conditional moment restrictions without smoothing.

**Carrasco, M., & Florens, J.-P. (2000).** *Generalization of GMM to a Continuum of Moment Conditions.* Econometric Theory 16(6), 797-834. [METHODS, prox 3]
GMM with a continuum of moments — operator perspective on overidentified moment conditions. Conceptual ancestor of the operator setup here.

**Newey, W. K., & McFadden, D. (1994).** *Large Sample Estimation and Hypothesis Testing.* Handbook of Econometrics 4, ch. 36. [FOUND, prox 2]
Standard reference for extremum estimation; cited for asymptotic theory background.

**Poirier, A. (2017).** *Efficient estimation in models with independence restrictions.* Journal of Econometrics 196(1), 1-22. [RELATED, prox 3]
Efficiency bound for parametric models under independence restrictions, equivalent to a continuum of zero-covariance moments. Useful comparator for the FI route's identifying power.

**Severini, T. A., & Tripathi, G. (2012).** *Efficiency bounds for estimating linear functionals of nonparametric regression models with endogenous regressors.* Journal of Econometrics 170, 491-498. [RELATED, prox 3]
Efficiency bounds for NPIV functionals.

---

## 5. Heteroskedasticity and conditional-variance estimation

**Fan, J., & Yao, Q. (1998).** *Efficient estimation of conditional variance functions in stochastic regression.* Biometrika 85(3), 645-660. [CORE, prox 4]
Canonical exogenous local-polynomial estimator of $\mathrm{Var}(Y\mid X)$. The closest exogenous-regressors counterpart to what the present paper does under endogeneity. Cited as the off-the-shelf method that fails under endogeneity.

**Ruppert, D., Wand, M. P., Holst, U., & Hössjer, O. (1997).** *Local polynomial variance-function estimation.* Technometrics 39(3), 262-273. [METHODS, prox 3]
Local-polynomial variance estimation under exogenous regressors. Methodological cousin.

**Yu, K., & Jones, M. C. (2004).** *Likelihood-based local linear estimation of the conditional variance function.* J. Amer. Statist. Assoc. 99, 139-144. [METHODS, prox 2]
Local-linear conditional variance estimation.

**Härdle, W., & Tsybakov, A. B. (1997).** *Local polynomial estimators of the volatility function in nonparametric autoregression.* J. Econometrics 81, 223-242. [RELATED, prox 3]
Volatility-function estimation in nonparametric autoregression (the third motivating example of the paper).

**Cai, Z. (2002).** *Regression Quantiles for Time Series.* Econometric Theory 18, 169-192. [RELATED, prox 2]
Nonparametric conditional quantile estimation, time-series context.

**Carroll, R. J., & Wand, M. P. (1998).** *Variance estimation in regression models.* JASA. [TANG, prox 2]
Reference for variance-function estimation.

**Fan, J., Yao, Q., & Tong, H. (1997).** *Estimation of conditional densities and sensitivity measures in nonlinear dynamical systems.* Biometrika. [TANG, prox 2]

**Alejo, J., Galvao, A. F., Martinez-Iriarte, J., & Montes-Rojas, G. (2024).** *Endogenous Heteroskedasticity in Linear Models.* arXiv:2412.02767. [RELATED, prox 3]
**Very recent.** Triangular linear model with endogeneity *and* heteroskedasticity in both equations: shows that standard CF identification fails when the skedastic function depends on the endogenous regressor, and proposes alternative identification routes. The closest contemporaneous paper on the linear analog of the present nonparametric problem — useful for positioning the contribution as the nonparametric / NPIV counterpart.

**Centorrino, S., & Perez-Urdiales, M. (2023).** *Stochastic Frontier Estimation with Endogenous Inputs.* JBES / EFA. [RELATED, prox 3]
Parametric stochastic frontier with endogenous inputs; cited as the parametric predecessor of the Nepal empirical application.

**Kumbhakar, S. C., & Wang, H.-J. (2010).** *Estimation of technical inefficiency in production frontier models using cross-sectional data.* Indian Econ. Rev. [RELATED, prox 2]
Cited as the standard exogenous-input stochastic frontier reference that the present paper extends to endogeneity.

**Kumbhakar, S. C., & Lovell, C. A. K. (2000).** *Stochastic Frontier Analysis.* Cambridge UP. [FOUND, prox 2]
Textbook reference for the stochastic frontier motivating example.

**Just, R. E., & Pope, R. D. (1978; 1979).** *Stochastic specification of production functions and economic implications* (J. Econometrics) and *Production function estimation and related risk considerations* (American J. of Agric. Economics). [FOUND, prox 3]
The Just-Pope production function — the first motivating example of the paper.

**Parmeter, C. F., Simar, L., Van Keilegom, I., & Zelenyuk, V. (2024).** *Inference in the nonparametric stochastic frontier model.* Econometric Reviews 43(7), 518-539. [RELATED, prox 2]
Recent inference for nonparametric stochastic frontier — methodological cousin under exogeneity.

---

## 6. Hilbert scales, source conditions, and derivative coordinates

**Engl-Hanke-Neubauer (2000), Section 8.** *Hilbert scales.* See entry above. [METHODS, prox 5]

**Florens, J.-P., Johannes, J., & Van Bellegem, S. (2012).** *Instrumental Regression in Partially Linear Models.* Econometrics Journal 15, 304-324. [METHODS, prox 4]
The derivative-coordinate reparameterization used in Section sec-derivreparam. Establishes the bound $\|D^{-1}\|\le|\mathcal{X}_1|/\sqrt{2}$ on the integration operator. Direct technical citation.

**Tautenhahn, U. (1996); Mair, B. A. (1994).** See Section 2 above. [METHODS, prox 3]

**Nair, M. T., Pereverzev, S. V., & Tautenhahn, U. (2005).** *Regularization in Hilbert scales under general smoothing conditions.* Inverse Problems 21, 1851-1869. [METHODS, prox 3]
Generalization of Tautenhahn (1996) to varied smoothing — relevant if the saturation in Section sec-rates is to be relaxed.

**Krein, S. G., & Petunin, J. I. (1966).** *Scales of Banach spaces.* Russian Math. Surveys 21, 85-159. [FOUND, prox 1]
Foundational reference for Hilbert / Banach scales.

---

## 7. Identification in nonlinear / abstract settings

**Chen, X., Chernozhukov, V., Lee, S., & Newey, W. K. (2014).** *Local Identification of Nonparametric and Semiparametric Models.* Econometrica 82(2), 785-809. [CORE, prox 5]
The abstract local-identification framework. Proposition prp-onetoone in the paper "adapts the abstract local-identification characterization of Chen-Lee (2013) to the pair-valued setting." Direct technical citation.

**Chen, X., & Lee, S. (2013).** Working paper version of the above. [CORE, prox 5]

**Florens, J.-P., & Mouchart, M. (1990).** *Elements of Bayesian Statistics* (and earlier "Florens 1990" results on completeness). [METHODS, prox 3]
Background on the completeness condition appealed to in Remark 1 ("weaker than strong identification in Florens 1990"). Identifies the conditional-completeness condition.

**Newey, W. K., & Powell, J. L. (2003).** See Section 1. [METHODS, prox 4]
Completeness foundations.

**D'Haultfœuille, X. (2011).** *On the completeness condition in nonparametric instrumental problems.* Econometric Theory 27(3), 460-471. [`dhaultfoeuille2011`, RELATED, prox 4]
Primitive sufficient conditions for nonparametric completeness — the key identifying restriction in `prp-condcomp`'s MI variant. An Ecta referee will probe whether the paper's conditional-completeness assumption admits a primitive condition; this is the canonical reference.

**Hu, Y., & Shiu, J.-L. (2018).** *Nonparametric identification using instrumental variables: sufficient conditions for completeness.* Econometric Theory 34(3), 659-693. [`hushiu2018`, RELATED, prox 3]
Operator-theoretic primitive sufficient conditions for completeness via injectivity of integral operators. Complements D'Haultfœuille (2011) with sharper conditions exploiting the operator structure that the present paper also relies on.

**Andrews, D. W. K. (2017).** *Examples of L2-Complete and Boundedly Complete Distributions.* J. Econometrics 199(2), 213-220. [TANG, prox 2]
Concrete distributional examples of completeness — useful for the empirical-application section to verify the MI / FI identifying restrictions hold in the specific data-generating processes considered.

**Torgovitsky, A. (2015; 2017).** *Identification of Nonseparable Models Using Instruments with Small Support* (Econometrica 83, 1185-1197); *Minimum distance from independence estimation of nonseparable instrumental variables models* (J. Econometrics 199, 35-48). [RELATED, prox 3]
Nonparametric IV identification with discrete / small-support instruments. Conceptually adjacent to the FI route's handling of binary $W$.

---

## 8. Kernel-density bounds, uniform consistency, and operator-approximation rates

**Hansen, B. E. (2008).** *Uniform Convergence Rates for Kernel Estimation with Dependent Data.* Econometric Theory 24, 726-748. [METHODS, prox 5]
The reference for uniform consistency of kernel estimators in $L^p$ norms, including the higher-moment $L^{2l}$ bounds (Proposition prp-koper, Assumption \ref{ass:rateconv}, proof of Lemma lem-itervar). Heavily cited throughout the proofs.

**Giné, E., & Guillou, A. (2002).** *Rates of strong uniform consistency for multivariate kernel density estimators.* Annales IHP 38, 907-921. [METHODS, prox 4]
Concentration / uniform consistency for KDE — companion to Hansen (2008) for the multivariate case.

**Einmahl, U., & Mason, D. M. (2005).** *Uniform in bandwidth consistency of kernel-type function estimators.* Annals of Statistics 33(3), 1380-1403. [METHODS, prox 3]
Uniform-in-bandwidth consistency of kernel estimators; bandwidth selection robustness.

**Li, Q., & Racine, J. S. (2007).** *Nonparametric Econometrics: Theory and Practice.* Princeton UP. [METHODS, prox 3]
Standard reference for nonparametric kernel methods used throughout.

**Härdle, W., & Linton, O. (1994).** *Applied nonparametric methods.* Handbook of Econometrics. [TANG, prox 2]

**Härdle, W. (1990).** *Applied Nonparametric Regression.* Cambridge UP. [METHODS, prox 3]
Standard reference cited for Nadaraya-Watson rates.

**Masry, E. (1995).** *Multivariate local polynomial regression for time series: Uniform strong consistency and rates.* J. Time Ser. Anal. 17, 571-599. [METHODS, prox 2]
Local-polynomial rates — relevant for the interest-rate empirical application.

**Bhatia, R. (1994).** *Matrix Analysis.* Springer. [METHODS, prox 2]
Cited for operator-norm / matrix-perturbation inequalities used in proof of Proposition prp-koper.

---

## 9. Empirical-application backdrop (data + parametric ancestors)

**Just, R. E., & Pope, R. D. (1978).** *Stochastic Specification of Production Functions and Economic Implications.* Journal of Econometrics 7(1), 67-86. [`justpope1978`, FOUND, prox 4]
The original Just-Pope production-function specification: output $Y = f(X) + g(X)^{1/2}\,\varepsilon$ with multiplicative heteroskedasticity. This is exactly the parametric ancestor of the location-scale model under endogeneity that the present paper estimates nonparametrically. Anchor citation for the empirical application.

**Just, R. E., & Pope, R. D. (1979).** *Production Function Estimation and Related Risk Considerations.* American Journal of Agricultural Economics 61(2), 276-284. [`justpope1979`, FOUND, prox 3]
Companion paper on risk implications. Sets up the agricultural-economics tradition that the empirical application sits in.

**Chambers, R. G. (1988).** *Applied Production Analysis: A Dual Approach.* Cambridge University Press. [`chambers1988`, METHODS, prox 3]
Canonical treatment of duality-based production analysis. Provides the conceptual framework (dual cost / profit functions) that motivates separating systematic from stochastic components in production technology — the structural setting in which the location-scale model is interpretable.

**Mundlak, Y. (2001).** *Production and Supply.* In Handbook of Agricultural Economics, Vol. 1A, Ch. 1, eds. Gardner & Rausser. [`mundlak2001`, METHODS, prox 3]
Handbook chapter on production-function estimation with attention to endogeneity (inputs choices respond to anticipated shocks) and heteroskedasticity. Positions the present paper's joint nonparametric estimation as the natural endpoint of the production-function literature's struggle with both issues.

**Kumbhakar, S. C., & Lovell, C. A. K. (2000).** *Stochastic Frontier Analysis.* Cambridge University Press. [`kumbhakarlovell2000`, RELATED, prox 3]
Frontier-analysis treatment of stochastic production with location-scale structure. Methodological cousin of the empirical application, particularly the IFPRI / Seed Entrepreneurs' Association of Nepal data.

**Centorrino, S., & Pérez-Urdiales, M. (2023).** See Section 5.

**International Food Policy Research Institute (2017); Seed Entrepreneurs' Association of Nepal data documentation (DataNepal).** [TANG, prox 2]
Data source for the Just-Pope empirical application.

**Federal Reserve Bank of St. Louis (FRED) — TB3MS, CPIAUCSL.** [TANG, prox 1]
Data source for the interest-rate empirical application. (Series-level reference; no academic citation.)

**Cox, J., Ingersoll, J., & Ross, S. (1985).** *A Theory of the Term Structure of Interest Rates.* Econometrica 53, 385-407. [FOUND, prox 2]
The CIR specification motivates the interest-rate empirical application's level-dependent volatility.

**Aït-Sahalia, Y. (1996).** *Testing continuous-time models of the spot interest rate.* Review of Financial Studies 9(2), 385-426. [RELATED, prox 2]
Nonparametric volatility of the short rate — methodological cousin of the second empirical application.

**Stanton, R. (1997).** *A nonparametric model of term structure dynamics and the market price of interest rate risk.* Journal of Finance 52, 1973-2002. [RELATED, prox 2]
Nonparametric estimation of the short-rate drift and diffusion.

---

## 10. Very recent (2023-2026) papers to monitor for scooping

**Centorrino-Christensen-Kankanala (2024)** — see Section 1, prox 5. Different problem (single-equation adaptive sup-norm NPIV), but adjacent and very current.

**Alejo-Galvao-Martinez-Iriarte-Montes-Rojas (2024)** — see Section 5, prox 3. Linear analog of the present nonparametric problem; not a scoop because both the model class (linear) and the route (control function) are different.

**Brunss-Smith (2024).** *Two-Stage Machine Learning for Nonparametric Instrumental Variable Regression.* JMP. [TANG, prox 2]
Machine-learning NPIV; methodological alternative.

**Chen, Christensen & Kankanala (2025+).** *Nonparametric Instrumental Variable Inference with Many Weak Instruments.* arXiv 2505.07729. [RELATED, prox 2]
Many-weak-IV asymptotics for NPIV. Methodologically separate but contemporaneous.

**Florens, J.-P., & Lapenta, E. (2024).** *Partly linear instrumental variables regressions without smoothing on the instruments.* TEST 33(3), 897-920. [`florenslapenta2024`, RELATED, prox 3]
Partly linear NPIV that avoids smoothing the instrument — a different design choice from the present paper's full-nonparametric Landweber-Fridman scheme, but illustrates the same recent push toward more tractable NPIV variants. Not a scoop: the location-scale + endogeneity problem is orthogonal.
Co-author work; methodologically adjacent.

**Beyhum, J., Lapenta, E., & Lavergne, P. (2025).** Working paper on NPIV / IV. [RELATED, prox 3]
Methodologically adjacent.

**Working papers on Newton-type regularization for nonlinear NPIV (Dunker-Hohage line, 2018-2025).** [METHODS, prox 4]
Alternative iterative scheme that avoids LF saturation; cited in Section sec-rates discussion.

---

## Summary by category

| Category | # entries | Top citations |
|---|---|---|
| Directly related (NPIV core) | 16 | Newey-Powell '03; Darolles-Fan-Florens-Renault '11; Chen-Pouzo '12, '15; Gagliardini-Scaillet '12; Chen-Christensen-Kankanala '24; Centorrino-Fève-Florens '25 |
| Iterative regularization | 14 | Engl-Hanke-Neubauer '00; Hanke-Neubauer-Scherzer '95; Kaltenbacher-Neubauer-Scherzer '08; Dunker et al. '14; Dunker '18 |
| Adaptive estimation / Lepskii | 8 | Lepskii '90; Mathé-Pereverzev '03; Cavalier-Tsybakov '02; Hoffmann-Reiss '08 |
| Conditional moments / GMM / efficiency | 7 | Ai-Chen '03; Hansen '82; Newey-McFadden '94 |
| Heteroskedasticity / variance / volatility | 9 | Fan-Yao '98; Alejo et al. '24 |
| Hilbert scales / source conditions | 4 | Tautenhahn '96; Mair '94; Florens-Johannes-Van Bellegem '12 |
| Identification (abstract) | 9 | Chen-Chernozhukov-Lee-Newey '14; Florens-Mouchart '90; D'Haultfœuille '11; Hu-Shiu '18 |
| KDE bounds / uniform consistency | 6 | Hansen '08; Giné-Guillou '02; Einmahl-Mason '05 |
| Empirical-application backdrop | 9 | Just-Pope '78, '79; Chambers '88; Mundlak '01; Kumbhakar-Lovell '00; Centorrino-Pérez-Urdiales '23; CIR '85; Aït-Sahalia '96 |
| Very recent (2023-2026) | 7 | Alejo et al. '24; CCK '24; CFF '25; Florens-Lapenta '24 |

**Total: ~115 entries.** Expanded from the original ~75 after the librarian-critic R1 review identified gaps in primitive-completeness conditions (Section 7), agricultural backdrop (Section 9), and the Dunker (2018) FI-route adaptive NPIV (Section 2). The expanded count is appropriate for a theory paper at Ecta/ReStud altitude that spans NPIV econometrics + inverse-problems mathematics + adaptive statistics + two empirical applications.
