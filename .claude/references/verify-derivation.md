# Verify-Derivation Protocol

Procedure for invoking the `derivation-verifier` agent against a claimed algebraic identity. Loaded on demand by the theorist (when a proof contains a multi-line derivation) and by `/audit` and `/prove` when symbolic verification is required.

## When to Run

Run symbolic verification when:

- A multi-line algebraic derivation appears in a proof (more than ~5 lines of intermediate algebra).
- A matrix identity is claimed — especially with inverses, traces, transposes, or Kronecker products.
- An influence function, asymptotic-variance formula, or efficiency bound is derived.
- A Taylor expansion to a specified order is invoked.
- A first-order condition is solved analytically.
- The proof composes multiple closed-form transformations and a downstream calculation depends on no algebra mistake having crept in.

Do NOT run verification for:
- Identities that are well-known closed-form results (the cost outweighs the benefit; instead cite the reference).
- Expressions involving conditional functions or piecewise definitions where SymPy's representation is awkward.
- Pure asymptotic-distribution claims (those are not symbolic identities).

## Procedure

1. **Extract the identity.** Find the claim in the proof:
   - The start expression (the input to the derivation)
   - The claimed end expression (the output)
   - Any intermediate steps the proof gives (optional checkpoints)
   - Domain context (which variables are real / complex / positive / matrix-valued, and matrix dimensions)

2. **Write a spec file.** Save to `scripts/symbolic/specs/<claim-id>.yaml`. Format documented at `scripts/symbolic/README.md`. Minimum content:
   ```yaml
   claim_id: thm2-score-function
   source: paper/sections/theorems/proofs.tex:L34
   variables:
     X: real
     theta: real
     sigma: positive
   start: log((2*pi*sigma**2)**(-1/2) * exp(-(X - theta)**2 / (2 * sigma**2)))
   operation: diff(theta)
   claimed_end: (X - theta) / sigma**2
   ```

3. **Dispatch the derivation-verifier agent** with the spec path as its input.

4. **Capture the result.** The agent runs `python3 scripts/symbolic/verify.py <spec>` and reports:
   - **Match** — SymPy `simplify(end_actual - end_claimed)` reduced to 0
   - **Mismatch (manual review)** — SymPy could not reduce to 0; this does NOT prove the paper is wrong (SymPy's simplifier is incomplete)
   - **Dim mismatch (for matrix specs)** — `dim_check.py` flagged a dimensional inconsistency; this DOES prove the claim is broken

5. **Log the result.** Report saved at `quality_reports/derivations/verify-<claim-id>.md` by the dispatching skill.

## Three Worked Examples

These live as runnable specs under `scripts/symbolic/examples/`.

### Example 1: Score function for Gaussian likelihood

Claim: $\partial \log f(X | \theta) / \partial\theta = (X - \theta)/\sigma^2$ where $f$ is the $N(\theta, \sigma^2)$ density.

Spec: `scripts/symbolic/examples/score-gaussian.yaml`
Expected: Match.

### Example 2: Asymptotic variance of OLS

Claim: for the linear model $Y = X\beta + \varepsilon$ with $\mathbb{E}[\varepsilon | X] = 0$ and $\mathrm{Var}(\varepsilon | X) = \sigma^2$, the asymptotic variance of $\sqrt{n}(\hat\beta - \beta_0)$ is $\sigma^2 (\mathbb{E}[XX^\top])^{-1}$ where $\hat\beta = (X^\top X)^{-1} X^\top Y$.

Spec: `scripts/symbolic/examples/ols-asymptotic-variance.yaml`
Expected: Match (with `dim_check.py` confirming dimensional consistency).

### Example 3: Taylor expansion of a moment condition

Claim: for $g(\theta) = \mathbb{E}[m(X, \theta)]$ with $g(\theta_0) = 0$ and $g'(\theta_0) = G_0 \neq 0$, the second-order Taylor expansion gives $g(\hat\theta) = G_0 (\hat\theta - \theta_0) + \tfrac{1}{2} G_0''(\theta^*) (\hat\theta - \theta_0)^2$ for some $\theta^*$ between $\theta_0$ and $\hat\theta$.

Spec: `scripts/symbolic/examples/taylor-moment-condition.yaml`
Expected: Match for the truncated expansion; the remainder term requires `series()` to the appropriate order.

## What to Do on a Mismatch

SymPy mismatch ≠ paper wrong. Likely causes:

- **True identity outside SymPy's decision procedure.** Trigonometric, special-function, or conditionally-true identities frequently lie here. Cross-check by hand or by an alternative CAS (Mathematica, Sage).
- **Spec error.** The translation from paper to spec introduced a typo. Re-read both carefully.
- **Domain mismatch.** SymPy treats a variable as complex when the paper assumes real; an identity that holds for reals may not hold for complex extensions.
- **Genuine paper error.** Possible. Escalate to the theorist with the spec attached.

When reporting a mismatch:

```
Symbolic verification failed for <claim-id>. SymPy could not reduce
the difference to zero. Manual review required.

Spec: scripts/symbolic/specs/<claim-id>.yaml
Difference (unsimplified): <SymPy output>

Likely cause: <best guess>
Recommended action: <hand-check or escalate>
```

Do NOT report "paper is wrong" without an independent hand-check that confirms the mismatch.

## Dimensional Checks

For matrix claims, also run `dim_check.py`:

```bash
python3 scripts/symbolic/dim_check.py scripts/symbolic/specs/<claim-id>.yaml
```

This validates that all matrix multiplications, additions, and inverses are dimensionally consistent. A dimensional mismatch is a hard error — unlike SymPy's incomplete simplifier, dimension arithmetic is decidable.
