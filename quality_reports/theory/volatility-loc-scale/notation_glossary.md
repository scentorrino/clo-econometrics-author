# Notation Glossary — Corrected Proposition `prp:lepskii`

Every symbol used in the corrected statement and proof of the Lepskii oracle
inequality. Symbols are grouped by role for readability.

## Spaces and operators

| Symbol | First defined | Meaning |
|---|---|---|
| $\mathcal{H}$ | Source paper L452 | Product Hilbert space $L^2_X \times L^2_X$, norm $\|\tilde b\|^2 = \|\tilde g\|^2 + \|\tilde\omega\|^2$ |
| $L^2_X$, $L^2_{U\times W}$, $L^2_W$ | Source paper L368 | $f_X$-, $f_U f_W$-, $f_W$-weighted $L^2$ spaces |
| $D$ | Source paper L353 | Componentwise differential operator in the $X_1$-direction |
| $D^{-1}$ | Source paper L355 | Componentwise integration operator; bounded on $D[\mathcal{A}'_b]$ with norm $\le \lvert\mathcal{X}_1\rvert/\sqrt 2$ |
| $\mathsf{T}$ | Source paper L580 | Generic forward operator: either $T_{\mathrm{MI}}$ or $\mathsf{T}_{\mathrm{FI}}$ |
| $\mathsf{T}'_b$ | Source paper Eq. (eq-frechet) | Frechet derivative of $\mathsf{T}$ at $b$ |
| $\mathsf{A}_b = \mathsf{T}'_b D^{-1}$ | Source paper L454 | Frechet derivative on the derivative pair $b' = D b$ |
| $\mathsf{A}^*_b$ | Source paper Eq. (eq-adjoint) | Adjoint of $\mathsf{A}_b$, from $L^2_{U\times W}$ to $D[\mathcal{A}'_b]$ |
| $\hat{\mathsf{T}}$, $\hat{\mathsf{T}}'_b$, $\hat{\mathsf{A}}^*_b$ | Source paper L478ff | Kernel-density-plug-in empirical versions of the corresponding population operators |
| $K_{b_\dagger,\hat b_j}$ | Source paper L527, prp:koper(b) | Auxiliary operator satisfying $\hat{\mathsf{A}}^*_{\hat b_j} = \hat{\mathsf{A}}^*_{b_\dagger} K_{b_\dagger,\hat b_j}$ |

## Parameters and iterates

| Symbol | First defined | Meaning |
|---|---|---|
| $b = (g, \omega)$ | Source paper L102, L345 | Parameter pair: location $g$ and log-inverse-scale $\omega = -\log\sigma$ |
| $a = (\varphi, \sigma)$ | Source paper L95, L562 | Original-coordinate pair: $\varphi = -g e^{-\omega}$, $\sigma = e^{-\omega}$ |
| $b_\dagger, a_\dagger$ | Source paper L426 | True parameter values |
| $b'_\dagger = D b_\dagger$ | Source paper L460 | Derivative coordinates of the true parameter |
| $\Phi$ | Source paper L562 | Smooth map $b \mapsto a$, $\Phi(b) = (-g e^{-\omega}, e^{-\omega})$ |
| $\Phi'(b_\dagger), \Phi''(b)$ | results.tex Step~5 | Jacobian and Hessian of $\Phi$ |
| $b_j, b'_j$ | Source paper L361, L423 | Noise-free LF iterate at index $j$ (deterministic) |
| $\hat b_j, \hat b'_j$ | Source paper Eq. (eq-lfhat) | Empirical LF iterate at index $j$ |
| $\hat b'_0$ | results.tex Step~1 | Initial empirical iterate (e.g., Nadaraya-Watson) |
| $\hat e_j := \hat b'_j - b'_\dagger$ | Source paper L1089, results.tex Step~3 | Empirical error at iteration $j$ |
| $\hat m$ | def:lepskii | Lepskii index selected by the rule |
| $m^*$ | results.tex Step~1 | Oracle balancing index $\arg\min_m [B(m) + \tilde V(m)]$ |

## Constants and rates

| Symbol | First defined | Meaning |
|---|---|---|
| $c$ | Source paper L362 | LF step size; chosen $c < (2\|\mathsf{T}'_{b_\dagger}\|^2)^{-1}$ in results.tex Step~1 |
| $c_g$ | results.tex Remark `rem:cg` | LF spectral-filter constant; equals $c$ throughout (notation note) |
| $c_v, c'_v$ | Source paper L590, lem:itervar | Variance-proxy constants depending on $c, R^\sigma, M_1, M_2, M_3, m_4$, qualification |
| $c_0$ | results.tex Step~1, Eq. (bernstein) | Sub-Gaussian Bernstein constant in $P(\|\hat b'_m - b'_m\| > \tau V(m)) \le e^{-c_0\tau^2}$ |
| $C, C_4, C_\Phi, C(\tau)$ | results.tex | Generic finite constants; $C_4$ from ass:iterbd; $C_\Phi = \max(R^\sigma, R^\varphi)$; $C(\tau) = 5\tau + 1 + O(\tau^{-1})$ |
| $\tau$ | def:lepskii | Lepskii balancing constant; default $\tau = \sqrt{(1+c)\,c_0^{-1}\log M_n}$ |
| $\tau_0$ | results.tex Step~2 | Bandwidth-free threshold $\tau_0 = C_V \vee 2$ where $C_V := \sup_m \tilde V(m+1)/\tilde V(m)$ depends on $\beta$ but not on the bandwidth (PATCH-R4-B3) |
| $C_V$ | results.tex Step~2, proofs.tex Step~2 | Successive-ratio constant $\sup_{1 \le m \le M_n - 1}\tilde V(m+1)/\tilde V(m) < \infty$; $\beta$-dependent but bandwidth-free; sets the floor $\tau_0 = C_V \vee 2$ (PATCH-R4-B3) |
| $R^\sigma, R_\sigma$ | Source paper L266, ass:unifbd(iii) | Uniform upper / lower bounds on $\sigma_\dagger$ |
| $R^\varphi$ | ass:unifbd(iii) (strengthened) | Uniform $L^\infty$ bound on $\varphi_\dagger$ (PATCH-M5) |
| $M_1, M_2, M_3$ | Source paper ass:unifbd(i)-(ii) | Density / derivative / Radon-Nikodym bounds |
| $\hat M$ | Source paper L523, prp:koper(a) | Random uniform-consistency constant from \citet{dunker2018}; finite w.p. $1-o(1)$ (PATCH-MN6) |
| $m_4$ | Source paper L266, ass:unifbd(iv) | Bound on $E[U^4]$ (consolidated; was $M_4$ at some sites in source paper -- PATCH-MN2) |
| $\delta_n$ | Source paper L487, ass:rateconv | Operator-rate sequence for $\hat{\mathsf T}(b_\dagger) - \mathsf T(b_\dagger)$ |
| $\gamma_n$ | Source paper L490, ass:rateconv | Operator-rate sequence for $\hat{\mathsf A}^*_{b_\dagger} - \mathsf A^*_{b_\dagger}$ |
| $h_u, h_w, h_x$ | Source paper L407, ass:app5 | Kernel bandwidths for $U$, $W$, $X$ |
| $\kappa_n$ | Source paper L509, ass:app4 | Lower bound on $f_U$: $\kappa_n = \inf_{\lvert u\rvert\le\ell_n} f_U(u)$ |
| $\ell_n$ | Source paper L509 | Truncation level for $\kappa_n$ |
| $\beta$ | ass:sourcecond | Source-condition smoothness exponent, $\beta \in (0, 2]$ |
| $\beta_\epsilon$ | def:Bm | Effective smoothness: $\beta\wedge(1-\epsilon)$ in FI, $\beta$ in MI (PATCH-MN5) |
| $a$ (link exponent) | ass:linkcond | Hilbert-scale link exponent, $a > 1$ |
| $\epsilon$ | Source paper L509, ass:restrvarth | Small slack parameter in $(0, 1/2)$ |
| $\sigma_Y^2$ | ass:subgauss | Sub-Gaussian variance proxy for $Y \mid X, W$ |
| $N$ | Source paper L362 | Total LF iteration count |
| $M_n$ | def:lepskii, ass:mn-growth | Lepskii horizon; $M_n = O(\delta_n^{-1})$ (PATCH-R3-G2-d, tightened from $\delta_n^{-2}$ in Round-1/2) |
| $l_0$ | ass:rateconv (strengthened) | Maximal moment order, $l_0 \ge 4$ (PATCH-M6) |
| $C_q$ | ass:rateconv(iv) (PATCH-R3-G3) | Hypercontractive moment-equivalence constant: $(E\|\hat e_m\|^{2q})^{1/q} \le C_q\,E\|\hat e_m\|^2$ for $q \ge 1$ |
| $L'_{\mathsf T}$ | ass:frediff(ii) (PATCH-R3-G2-a) | Quadratic Fr\'echet-remainder constant for $b \mapsto \hat{\mathsf T}'^*_b\hat{\mathsf T}'_b$ on $\mathcal B_{b_\dagger}$ |
| $\mathsf{L}_{b}$ | ass:frediff(ii) (PATCH-R3-G2-a) | First Fr\'echet derivative of $b \mapsto \hat{\mathsf T}'^*_b\hat{\mathsf T}'_b$ (bounded linear operator) |
| $R^{(2)}_{m,j}$ | lem:propagator (PATCH-R3-G2-b) | Quadratic propagator residual: $\|R^{(2)}_{m,j}\| \le c L'_{\mathsf T}\sum_k\|\hat e_k\|^2$ |
| $n$ | Source paper L343 | Sample size |

## Bias, variance, and balancing quantities

| Symbol | First defined | Meaning |
|---|---|---|
| $B(m)$ | def:Bm, Eq. (eq:Bm) | Deterministic LF bias proxy: $m^{-\beta_\epsilon/2}[1 + (E\|\hat b_0 - b_0\|^2)^{1/2}]$; monotone non-increasing |
| $V(m)$ | def:Vm, Eq. (eq:Vm) | Per-iterate variance proxy (not necessarily monotone) |
| $\tilde V(m)$ | def:Vm, Eq. (eq:Vtilde) | Running maximum $\max_{k\le m} V(k)$ (PATCH-M4); monotone non-decreasing; dominates $V$ |

## High-probability events

| Symbol | First defined | Meaning |
|---|---|---|
| $\Omega_n$ | results.tex Step~1, Eq. (eq:Omegan) | Concentration event $\{\|\hat b'_m - b'_m\| \le \tau V(m)\ \forall m \le M_n\}$ (PATCH-CR1) |
| $\Omega'_n$ | results.tex Step~1, Eq. (eq:Omegaprime) | Operator-norm event $\{\|\hat{\mathsf T}'_{b_\dagger}\|^2 \le 2\|\mathsf T'_{b_\dagger}\|^2\}$; $P(\Omega'_n) \ge 1 - O(\gamma_n^2)$ (PATCH-M2) |
| $\mathcal{B}_{b_\dagger}$ | Source paper L286 | Local-identification ball $\mathcal{B}_R \cap \mathcal{B}^*_M$ around $b_\dagger$ |
| $\mathcal{A}'_b$ | Source paper L357 | Subset of $\mathcal{A}_b$ continuously differentiable in $X_1$ with square-integrable derivative |

## Auxiliary operators and propagators

| Symbol | First defined | Meaning |
|---|---|---|
| $\hat P_m$ | lem:propagator | Random propagator $\prod_{k=j+1}^{m-1}(I - c\hat{\mathsf T}'^*_{\hat b_k}\hat{\mathsf T}'_{\hat b_k})$ |
| $P^\dagger_{m,j}$ | lem:propagator | Fixed-linearization propagator $(I - c\hat{\mathsf T}'^*_{b_\dagger}\hat{\mathsf T}'_{b_\dagger})^{m-1-j}$ |
| $R_{m,j}$ | lem:propagator, Eq. (eq:propagator) | Remainder in propagator substitution (PATCH-M1) |
| $g_m(\lambda)$ | results.tex Remark `rem:cg` | LF generating function $c_g\sum_{j=0}^{m-1}(1-c_g\lambda)^j$; satisfies $\sup_\lambda |\lambda^{1/2} g_m(\lambda)| \le \sqrt m$ |

## Data variables

| Symbol | First defined | Meaning |
|---|---|---|
| $Y, X, W$ | Source paper L95 | Response, endogenous regressor (in $[0,1]^p$), instrument (in $\IR^q$) |
| $U$ | Source paper L95 | Structural disturbance, $E[U]=0$, $\mathrm{Var}(U)=1$ |
| $\varphi_\dagger, \sigma_\dagger$ | Source paper L95 | True location and scale functions |
| $g_\dagger, \omega_\dagger$ | Source paper L101 | Reparameterized true location and log-inverse-scale |
| $f_{Y,X\mid W}, f_X, f_W, f_U$ | Source paper L478 | Joint / marginal / residual densities |
| $\hat{f}_{Y,X\mid W}, \hat{f}_U$, ... | Source paper L1058 | Kernel estimators of the corresponding densities |
| $p, q$ | Source paper L95 | Dimensions: $\dim X = p$, $\dim W = q$ |

## Symbols introduced by patches (in summary)

| Symbol | Patch | Purpose |
|---|---|---|
| $\sigma_Y^2$, sub-Gaussian moment-generating bound | CR1 (ass:subgauss) | Replace unsupported sub-exponential claim; gives Bernstein tail \eqref{eq:bernstein} |
| $C_4$, $\sup_m E\|\hat b'_m\|^4$ | CR2 (ass:iterbd) | Off-$\Omega_n$ Cauchy-Schwarz closure |
| $\hat P_m, P^\dagger_{m,j}, R_{m,j}$ | M1 (lem:propagator) | Make propagator substitution explicit |
| $\Omega'_n$ | M2 | Operator-norm event for empirical step-size |
| $\tilde V(m)$ | M4 | Running-maximum monotone variant of $V$ |
| $R^\varphi$ | M5 | $L^\infty$ bound on $\varphi_\dagger$ for $\Phi$-Lipschitz |
| $l_0$ | M6 (strengthened ass:rateconv) | $L^{2l}$ moments up to $l \ge 4$ for operator concentration |
| $M_n = O(\delta_n^{-1})$ | R3-G2-d (tightened ass:mn-growth) | Lepskii horizon; closes quadratic-residual absorption. Trade-off: adaptive only for $\beta_\epsilon \ge 1$ (see Remark rem:scope) |
| $C_q$ | R3-G3 (ass:rateconv(iv)) | Hypercontractive moment-equivalence on iterates; legitimises $L^4$-to-$L^2$ comparison in $III_m$ display |
| $L'_{\mathsf T}, \mathsf{L}_b, R^{(2)}_{m,j}$ | R3-G2-a / -b / -c (ass:frediff(ii), lem:propagator) | $C^2$-Fr\'echet hypothesis on Hessian-like operator; quadratic propagator residual; closes G2 absorption at $M_n = O(\delta_n^{-1})$ |
