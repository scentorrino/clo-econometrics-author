# Asymptotic Conventions

House style for asymptotic notation in theory papers. Loaded by the theorist; checked by theorist-critic, notation-warden, and regularity-checker.

## Notation

| Symbol | Meaning | Example |
|---|---|---|
| $o(a_n)$ | Deterministic: $x_n / a_n \to 0$ | $x_n = o(1) \iff x_n \to 0$ |
| $O(a_n)$ | Deterministic: $x_n / a_n$ bounded | $x_n = O(1) \iff (x_n)$ bounded |
| $o_p(a_n)$ | Stochastic: $X_n / a_n \xrightarrow{p} 0$ | $X_n = o_p(1) \iff X_n \xrightarrow{p} 0$ |
| $O_p(a_n)$ | Stochastic: $X_n / a_n$ tight | $X_n = O_p(1) \iff (X_n)$ tight |
| $\xrightarrow{p}$ | Convergence in probability | $\hat\theta \xrightarrow{p} \theta_0$ |
| $\xrightarrow{d}$ | Convergence in distribution | $\sqrt{n}(\hat\theta - \theta_0) \xrightarrow{d} N(0, V)$ |
| $\xrightarrow{a.s.}$ | Almost sure convergence | $\bar X_n \xrightarrow{a.s.} \mu$ |
| $X_n \rightsquigarrow X$ | Weak convergence in a metric space | Used for empirical processes |
| w.p.a.1 | With probability approaching 1 | "$\hat\theta \in \mathrm{int}(\Theta)$ w.p.a.1" |

## When to Use Which

- **Convergence in probability** is the standard for consistency statements: $\hat\theta \xrightarrow{p} \theta_0$.
- **Almost sure convergence** is stronger and used when the proof actually delivers it (strong LLN, almost sure consistency under regularity conditions). Do not claim almost sure unless your proof gives it.
- **With probability approaching one (w.p.a.1)** is the right phrase for events that hold eventually under the sampling, but where you have not (or do not need to) establish a.s.: "the FOC is solved interior to $\Theta$ w.p.a.1."

## Pointwise vs Uniform

When you write "$\hat M_n(\theta) \to M(\theta)$," qualify:

- **Pointwise:** for each $\theta$, $\hat M_n(\theta) \xrightarrow{p} M(\theta)$.
- **Uniform over $\Theta$:** $\sup_{\theta \in \Theta} |\hat M_n(\theta) - M(\theta)| \xrightarrow{p} 0$.
- **Uniform over a class of functions $\mathcal{F}$:** $\sup_{f \in \mathcal{F}} |\hat P f - P f| \to 0$ (Glivenko–Cantelli / Donsker).
- **Uniform over local alternatives:** for sequences $\theta_n = \theta_0 + h/\sqrt{n}$, uniformly in compact $h$.

The qualifier matters. Pointwise consistency does not imply uniform consistency — the latter requires either compactness + continuity, or class-of-functions structure (envelope + entropy bound).

## Stating Rates

Use one of:
- "$\sqrt{n}$-consistent" — $\sqrt{n}(\hat\theta - \theta_0) = O_p(1)$.
- "$n^{1/3}$-rate" — $n^{1/3}(\hat\theta - \theta_0) = O_p(1)$.
- "rate $r_n$" — $r_n(\hat\theta - \theta_0) = O_p(1)$, with $r_n$ defined in context.

Avoid "fast" / "slow" without naming the rate.

## Invoking Slutsky / CMT

**Slutsky's theorem:** if $X_n \xrightarrow{d} X$ and $Y_n \xrightarrow{p} c$ (constant), then $X_n + Y_n \xrightarrow{d} X + c$ and $X_n Y_n \xrightarrow{d} X c$. The constancy of $c$ matters — Slutsky does not apply to $X_n Y_n$ when $Y_n \xrightarrow{d} Y$ unless $Y$ is independent of $X$ in the limit.

**Continuous Mapping Theorem (CMT):** if $X_n \xrightarrow{d} X$ and $g$ is continuous at every point of the support of $X$ (or at every point where $X$ lies a.s.), then $g(X_n) \xrightarrow{d} g(X)$. Continuity must hold **at the limit**, not generically.

**Delta method:** if $\sqrt{n}(\hat\theta - \theta_0) \xrightarrow{d} Z$ and $g$ is continuously differentiable at $\theta_0$ with $\nabla g(\theta_0) \neq 0$, then $\sqrt{n}(g(\hat\theta) - g(\theta_0)) \xrightarrow{d} \nabla g(\theta_0)^\top Z$. The non-degeneracy condition matters — at boundary or stationary points, use the second-order delta method.

When invoking any of these, name the result and state the regularity condition you are relying on. "By Slutsky" alone is insufficient — say "by Slutsky, since $\hat\sigma \xrightarrow{p} \sigma$ is a constant…"

## Common Errors

| Error | Correction |
|---|---|
| "$\hat\theta \to \theta_0$" without specifying mode | "$\hat\theta \xrightarrow{p} \theta_0$" |
| "$\sqrt{n}(\hat\theta - \theta_0) \to N(0, V)$" using $\to$ for convergence in distribution | "$\xrightarrow{d}$" |
| "uniformly" without specifying over what | "uniformly over $\theta \in \Theta$" / "uniformly over $f \in \mathcal{F}$" |
| Using CMT at a point where $g$ has a discontinuity | Verify $g$ is continuous at the limit; otherwise use distribution-function arguments directly |
| "Almost surely" when the proof only gives probability | Use $\xrightarrow{p}$ and "with probability approaching 1" |

## Empirical Process Notation (When Used)

If the paper relies on empirical processes:

- $P_n$ = empirical distribution; $P_n f = n^{-1} \sum_i f(X_i)$.
- $P$ = population distribution; $Pf = \mathbb{E}[f(X)]$.
- $\mathbb{G}_n = \sqrt{n}(P_n - P)$ = empirical process.
- $\mathcal{F}$ = class of functions indexed by parameter; envelope $F$ with $\sup_{f \in \mathcal{F}} |f| \leq F$.
- "$\mathcal{F}$ is $P$-Donsker" means $\mathbb{G}_n$ converges weakly to a $P$-Brownian bridge on $\mathcal{F}$.

State Donsker / Glivenko–Cantelli assumptions explicitly. Do not write "$\sup_\theta |\hat M_n - M| \to 0$" and rely on the reader to infer the class condition.
