# Symbolic Derivation Verifier

A small Python harness used by the `derivation-verifier` agent to mechanically check claimed algebraic identities and matrix-dimension consistency.

## Install

```bash
pip install sympy pyyaml
```

`sympy >= 1.10` recommended. `pyyaml` is optional — if not installed, use `.json` specs instead of `.yaml`.

## Usage

```bash
python3 scripts/symbolic/verify.py scripts/symbolic/specs/<claim>.yaml
python3 scripts/symbolic/dim_check.py scripts/symbolic/specs/<claim>.yaml
```

Exit codes:
- `verify.py`: 0 = match, 1 = mismatch (manual review required), 2 = spec error, 3 = runtime error
- `dim_check.py`: 0 = consistent, 1 = mismatch, 2 = spec error

## Spec Format

```yaml
claim_id: thm2-score-function
source: paper/sections/theorems/proofs.tex:L34

variables:
  X:
    domain: real
  theta:
    domain: real
  sigma:
    domain: positive

start: log((2*pi*sigma**2)**(-1/2) * exp(-(X - theta)**2 / (2 * sigma**2)))
operation: diff(theta)
claimed_end: (X - theta) / sigma**2
```

### Fields

| Field | Required | Description |
|---|---|---|
| `claim_id` | recommended | Short identifier; appears in the report. |
| `source` | recommended | `<file>:L<line>` pointer back to the paper claim. |
| `variables` | yes | Map of name → `domain` (and `dims` if matrix). |
| `start` | yes | Start expression as a Python/SymPy string. |
| `operation` | yes | Single declarative operation (see below). |
| `claimed_end` | yes | Expected end expression. |

### Domains

- `real` — real-valued scalar (SymPy assumption `real=True`)
- `positive` — positive real (`positive=True`)
- `negative` — negative real
- `complex` — complex scalar
- `integer` — integer
- `natural` — positive integer
- `matrix` — requires `dims: [rows, cols]`. Dims can be symbolic (`[n, p]`) or numeric.

Anything else falls back to a generic SymPy symbol.

### Operations

| Operation | Meaning |
|---|---|
| `none` | Compare `start` directly to `claimed_end` (after simplification). |
| `simplify` | Apply `sympy.simplify` to `start`. |
| `expand` | Apply `sympy.expand`. |
| `together` | Apply `sympy.together`. |
| `diff(<var>)` | First derivative with respect to `<var>`. |
| `diff(<var>, n)` | $n$-th derivative. |
| `integrate(<var>)` | Indefinite integral. |
| `taylor(<var>, <point>, <order>)` | Series expansion of order `<order>` around `<point>`, with the order term removed. |
| `substitute(<a>=<b>, <c>=<d>)` | Substitute expressions. |

### Expression Syntax

Standard Python / SymPy expression syntax. Useful built-ins available without import: `pi`, `E`, `oo` (infinity), `I` (imaginary unit), `exp`, `log`, `sqrt`, `sin`, `cos`, `tan`, `diff`, `integrate`, `Matrix`.

## Examples

See `scripts/symbolic/examples/`:

1. `score-gaussian.yaml` — derivative of Gaussian log-likelihood with respect to its mean.
2. `ols-asymptotic-variance.yaml` — matrix expression for OLS sandwich variance; exercises `dim_check.py`.
3. `taylor-moment-condition.yaml` — Taylor expansion of a moment condition to a specified order.

Run each:

```bash
python3 scripts/symbolic/verify.py scripts/symbolic/examples/score-gaussian.yaml
python3 scripts/symbolic/verify.py scripts/symbolic/examples/ols-asymptotic-variance.yaml
python3 scripts/symbolic/dim_check.py scripts/symbolic/examples/ols-asymptotic-variance.yaml
python3 scripts/symbolic/verify.py scripts/symbolic/examples/taylor-moment-condition.yaml
```

## Limitations

SymPy's `simplify()` is **incomplete**. A mismatch exit code does NOT prove the paper's claim is wrong. Common false-mismatch causes:

- Trigonometric and special-function identities outside SymPy's decision procedures
- Conditionally-true identities (true under domain assumptions SymPy hasn't propagated)
- Identities involving piecewise functions
- Identities that require ordering / inequality reasoning

When `verify.py` returns mismatch (exit 1), treat it as "manual review required," not "paper is wrong."

`dim_check.py`, by contrast, is decidable — a dimensional mismatch is a hard error.

## Spec Library

Persistent specs from real paper claims go in `scripts/symbolic/specs/`. The `examples/` folder is for runnable demos.

---

## `source:` pointers — convention, fixed 2026-08-03

**Cite the label or tag. Do not cite a line number.**

```yaml
# GOOD — durable
source: "quality_reports/theory/panel-npiv-discrete/proofs.tex (prp:compact Step 3, HS bound)"

# BAD — decays on the next edit
source: "quality_reports/theory/panel-npiv-discrete/proofs.tex:263-269 (prp:compact Step 3)"
```

### Why

`verify.py` reads `source:` **only to print it** (`spec.get("source", ...)`, then one `print`). It is
provenance for a human reader, never an input to the algebra — so a stale pointer cannot corrupt a
verification. It can only mislead the person auditing one, which is bad enough.

On 2026-08-03, `check_rendering_sync.py` CHECK 7 reported **77 drift findings across 26 specs**, with
pointers off by as much as **+1,898 lines**. The corpus is edited continuously — `proofs.tex` and
`results.tex` moved five times that day alone — so line numbers written on Monday are wrong by
Tuesday. Updating them is a treadmill; the next theory dispatch re-breaks every one.

All 63 stale pointers were stripped. The parenthetical tag that survives is exact, and CHECK 7
resolves it against the live `\label` at run time, so the check still means something — it just
checks the durable half.

**Same reasoning retired the `REGISTER_RANGE` upper bound the same day:** assert the property that
holds (contiguity), not the coordinate that moves (`C1–C79`, which the register correctly outgrew).

### If you want to point at a location

Name the environment (`lem:bdiff`), the clause (`(P-d)`), or the step (`Step 3`), and let the reader
grep. Those survive reflowing, renaming and re-splitting; line numbers survive nothing.
