# LaTeX Math Conventions

Typographic conventions for mathematical notation in theory papers. This is a **style sheet, not a sermon** — pick one convention per choice and stick with it across the paper. The notation-warden flags inconsistencies.

## Project Choices

Fill in `[CHOOSE ONE]` per project and commit the choice early. Once a paper uses a convention in section 1, it must use the same convention throughout.

### Probability and Expectation

- Expectation: `[CHOOSE ONE]` between `$\mathbb{E}[\cdot]$` and `$E[\cdot]$`. Default to `$\mathbb{E}$`.
- Probability: `[CHOOSE ONE]` between `$\mathbb{P}(\cdot)$` and `$\Pr(\cdot)$`. Default to `$\mathbb{P}$`.
- Variance / Covariance: `$\mathrm{Var}$`, `$\mathrm{Cov}$` (upright) — not `$Var$`, `$Cov$` (italic).
- Indicator: `$\mathds{1}\{\cdot\}$` (dsfont) — already declared as `\1{...}` in the project preamble.

### Vectors and Matrices

- Vectors: `[CHOOSE ONE]` between bold-lowercase (`$\boldsymbol{\beta}$`) and non-bold-lowercase (`$\beta$`). Most economics papers use non-bold; most stats papers use bold. Default non-bold.
- Matrices: `[CHOOSE ONE]` between bold-uppercase (`$\boldsymbol{X}$`) and non-bold-uppercase (`$X$`). Default non-bold.
- Whichever is picked, **be consistent across the paper.** The notation-warden flags switches.

### Sets, Spaces, Sigma-Algebras

- Sample space, support, parameter space: calligraphic, e.g., `$\mathcal{X}$`, `$\Theta$`, `$\mathcal{F}$`.
- Sigma-algebras: calligraphic uppercase script, e.g., `$\mathscr{F}$` if `\usepackage{mathrsfs}` is loaded — otherwise calligraphic `$\mathcal{F}$`.
- Real / complex / natural numbers: blackboard bold, `$\mathbb{R}, \mathbb{C}, \mathbb{N}, \mathbb{Z}$`.

### Transpose

`[CHOOSE ONE]` between:
- `$X^\top$` (\top) — preferred; clean visual
- `$X^T$` — sans-serif T can be confused with sample size $T$
- `$X'$` — econometrics tradition; can be confused with derivative

Default `$X^\top$`.

### Norms

- `$\|x\|$` (`\|`) for the default norm.
- `$\|x\|_p$` for $L^p$.
- `$\|x\|_2$` is the Euclidean norm — write it explicitly when distinguishing.
- The preamble provides `\norm{...}` which expands to `$\left\lVert \cdot \right\rVert$` with auto-sized delimiters.

### Operators

Use `\DeclareMathOperator` for new operators so they typeset upright with proper spacing:

```latex
\DeclareMathOperator*{\argmax}{arg\,max}
\DeclareMathOperator*{\argmin}{arg\,min}
\DeclareMathOperator{\plim}{plim}
\DeclareMathOperator{\rank}{rank}
\DeclareMathOperator{\diag}{diag}
\DeclareMathOperator{\trace}{tr}
```

The starred form puts subscripts below in display mode (e.g., $\argmax_\theta$).

### Subscripts and Indices

- $i, j, k$ for cross-sectional units. Use $i$ as default.
- $t, s$ for time. Use $t$ as default.
- $n$ for sample size. Reserve — do not use $n$ for anything else.
- $T$ for panel time length. Be careful if also using transpose; pick one convention.
- $p$ for number of parameters / regressors. Reserve.
- $\theta, \beta, \gamma$ for parameters.
- $\theta_0$ — true parameter; $\hat\theta$ — estimator; $\tilde\theta$ — alternative estimator.

### Estimators and Estimands

- True value: $\theta_0$ (or $\theta^*$ — pick one).
- Estimator: $\hat\theta$.
- Convergence target: usually $\theta_0$. Make this explicit if not.
- For multi-step estimators, distinguish first-step ($\hat\theta^{(1)}$) and final ($\hat\theta$).

### Norms on Function Spaces

- $L^p(P) = \{f : \mathbb{E}|f(X)|^p < \infty\}$. Specify the measure: $L^p(P)$ not just $L^p$.
- $\|f\|_{P, p} = (\mathbb{E}|f(X)|^p)^{1/p}$.
- $\|f\|_{\infty} = \sup_x |f(x)|$ or $\mathrm{ess\,sup}$, depending — be explicit.

## Display Equations

- Numbered if referenced later in the paper. Unnumbered otherwise.
- Use `align` for multi-line equations, `align*` for unnumbered, `gather` when alignment doesn't help.
- Inline math is fine for short, in-line algebra; display when the equation is the subject of a sentence.

## Equation Punctuation

Treat display equations as part of the sentence. Comma after if more comes; period after if the sentence ends.

```latex
By Assumption 2, we have
\begin{equation}
\hat\theta - \theta_0 = O_p(n^{-1/2}),
\end{equation}
which implies consistency.
```

## Things to Always Avoid

| Anti-pattern | Why | Fix |
|---|---|---|
| Inline `\frac{a}{b}` in body text | tiny fraction is unreadable | use `a / b` or display |
| `<=` / `>=` in math mode | typewriter symbols | `\leq` / `\geq` |
| Manual spacing (`\,\,\,`) for alignment | non-portable | use proper environments |
| `E[X]E[Y]` with both expectations italic | $E$ is also a generic letter; ambiguous | `$\mathbb{E}[X]\,\mathbb{E}[Y]$` |
| Using $e$ as both Euler's constant and an error term | collision | use $\varepsilon$ for errors |
| `\bf{X}` (old syntax) | deprecated; doesn't work in math mode | `\mathbf{X}` or `\boldsymbol{X}` |

## Project-Specific Preamble Commands

The project preamble already declares:

```latex
\newcommand{\norm}[1]{\left\lVert #1 \right\rVert}
\newcommand{\1}[1]{\mathds{1}\left[#1\right]}
\DeclareMathOperator*{\argmax}{arg\,max}
\DeclareMathOperator*{\argmin}{arg\,min}
```

Theory papers should add (if needed):

```latex
\newcommand{\E}{\mathbb{E}}
\newcommand{\Prob}{\mathbb{P}}
\newcommand{\T}{^\top}            % vector / matrix transpose
\newcommand{\indep}{\perp\!\!\!\perp}
```

Document additions in the paper's preamble file (`paper/preambles/`), not in `main.tex`.
