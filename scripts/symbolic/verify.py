#!/usr/bin/env python3
"""Symbolic derivation verifier.

Reads a YAML or JSON spec describing a claimed algebraic identity and
asks SymPy whether it holds. Reports MATCH, MISMATCH (manual review),
or DIM_MISMATCH (hard error).

Usage:
    python3 verify.py <spec_path>

Exit codes:
    0 — match (SymPy confirmed the identity)
    1 — mismatch (SymPy could not reduce to zero; manual review needed)
    2 — spec error (malformed input)
    3 — runtime error (SymPy threw)

A SymPy mismatch is NOT a proof that the paper is wrong. SymPy's
simplify() is incomplete. Many true identities (trigonometric,
special-function, conditionally-true) lie outside its decision
procedures. Treat exit code 1 as "manual review required."
"""

from __future__ import annotations

import json
import signal
import sys
from pathlib import Path
from typing import Any

try:
    import sympy as sp
    from sympy.parsing.sympy_parser import parse_expr
except ImportError as exc:  # pragma: no cover
    sys.stderr.write(
        "ERROR: SymPy is required. Install with: pip install sympy\n"
    )
    sys.exit(3)

try:
    import yaml  # type: ignore[import-not-found]

    HAS_YAML = True
except ImportError:
    HAS_YAML = False


SIMPLIFY_TIMEOUT_SECONDS = 60


class TimeoutError_(Exception):
    pass


def _timeout_handler(signum, frame):  # pragma: no cover
    raise TimeoutError_("SymPy simplify exceeded budget")


def load_spec(path: Path) -> dict[str, Any]:
    text = path.read_text()
    suffix = path.suffix.lower()
    if suffix in {".yaml", ".yml"}:
        if not HAS_YAML:
            sys.stderr.write(
                "ERROR: YAML spec requires PyYAML. Install with: pip install pyyaml\n"
                "Or convert the spec to .json.\n"
            )
            sys.exit(2)
        return yaml.safe_load(text)
    if suffix == ".json":
        return json.loads(text)
    sys.stderr.write(f"ERROR: spec must be .yaml, .yml, or .json (got {suffix})\n")
    sys.exit(2)


def build_symbols(var_decls: dict[str, Any]) -> dict[str, sp.Symbol | sp.MatrixSymbol]:
    """Build SymPy symbols / matrix symbols from a variable declaration block.

    Each variable entry is either a string ("real", "positive", ...) for
    scalar shorthand, or a mapping with `domain` and optional `dims`.
    """
    symbols: dict[str, sp.Symbol | sp.MatrixSymbol] = {}
    for name, decl in var_decls.items():
        if isinstance(decl, str):
            domain = decl
            dims = None
        else:
            domain = decl.get("domain", "real")
            dims = decl.get("dims")

        if domain == "matrix":
            if dims is None or len(dims) != 2:
                sys.stderr.write(
                    f"ERROR: variable '{name}' is matrix but lacks dims: [rows, cols]\n"
                )
                sys.exit(2)
            rows, cols = dims
            r = sp.Symbol(str(rows), positive=True, integer=True) if isinstance(rows, str) else rows
            c = sp.Symbol(str(cols), positive=True, integer=True) if isinstance(cols, str) else cols
            symbols[name] = sp.MatrixSymbol(name, r, c)
            continue

        kwargs: dict[str, Any] = {}
        if domain == "real":
            kwargs["real"] = True
        elif domain == "positive":
            kwargs["positive"] = True
        elif domain == "negative":
            kwargs["negative"] = True
        elif domain == "complex":
            kwargs["complex"] = True
        elif domain == "integer":
            kwargs["integer"] = True
        elif domain == "natural":
            kwargs["positive"] = True
            kwargs["integer"] = True
        else:
            # Unrecognized domain — fall back to generic symbol
            pass
        symbols[name] = sp.Symbol(name, **kwargs)
    return symbols


def parse_with(expr: str, local_dict: dict[str, Any]) -> sp.Expr:
    """Parse an expression string in the context of the declared symbols.

    Adds `pi`, `E`, `oo`, and common functions to the namespace.
    """
    namespace: dict[str, Any] = {
        "pi": sp.pi,
        "E": sp.E,
        "oo": sp.oo,
        "I": sp.I,
        "exp": sp.exp,
        "log": sp.log,
        "ln": sp.log,
        "sin": sp.sin,
        "cos": sp.cos,
        "tan": sp.tan,
        "sqrt": sp.sqrt,
        "diff": sp.diff,
        "integrate": sp.integrate,
        "Sum": sp.Sum,
        "Symbol": sp.Symbol,
        "Matrix": sp.Matrix,
    }
    namespace.update(local_dict)
    return parse_expr(expr, local_dict=namespace, evaluate=True)


def apply_operation(start: sp.Expr, operation: str, symbols: dict[str, Any]) -> sp.Expr:
    """Apply a single declarative operation to the start expression.

    Supported operations:
      diff(<var>)          — differentiate once with respect to <var>
      diff(<var>, n)       — differentiate n times
      integrate(<var>)     — indefinite integral
      expand               — sp.expand
      simplify             — sp.simplify
      together             — sp.together
      taylor(<var>, <pt>, <order>) — series expansion
      substitute(<a>=<b>)  — substitute expressions
      none                 — no transformation; compare start directly to claimed_end
    """
    op = operation.strip()
    if op == "none":
        return start
    if op == "expand":
        return sp.expand(start)
    if op == "simplify":
        return sp.simplify(start)
    if op == "together":
        return sp.together(start)

    if op.startswith("diff(") and op.endswith(")"):
        args = [a.strip() for a in op[5:-1].split(",")]
        if len(args) == 1:
            var = symbols[args[0]]
            return sp.diff(start, var)
        if len(args) == 2:
            var = symbols[args[0]]
            n = int(args[1])
            return sp.diff(start, var, n)

    if op.startswith("integrate(") and op.endswith(")"):
        var = symbols[op[10:-1].strip()]
        return sp.integrate(start, var)

    if op.startswith("taylor(") and op.endswith(")"):
        args = [a.strip() for a in op[7:-1].split(",")]
        var = symbols[args[0]]
        pt = parse_with(args[1], symbols)
        order = int(args[2])
        return sp.series(start, var, pt, order).removeO()

    if op.startswith("substitute(") and op.endswith(")"):
        body = op[11:-1].strip()
        # Allow comma-separated substitutions: a=b, c=d
        subs_list = [s.strip() for s in body.split(",")]
        subs: list[tuple[sp.Expr, sp.Expr]] = []
        for s in subs_list:
            left, right = s.split("=", 1)
            subs.append((parse_with(left.strip(), symbols), parse_with(right.strip(), symbols)))
        return start.subs(subs)

    sys.stderr.write(f"ERROR: unsupported operation '{op}'\n")
    sys.exit(2)


def is_zero(r: Any) -> bool:
    """Zero test that handles scalars AND matrix expressions, and never raises.

    Two failure modes this exists to prevent, both observed in practice:

    1. ``ZeroMatrix`` is not equal to the integer 0, and ``MatrixExpr.equals``
       does not recognise it either -- so a spec whose difference reduces to a
       zero matrix printed "Residual: 0" and was then reported MISMATCH.
    2. ``MatrixExpr.equals`` raises ``ValueError`` on symbolic shapes. Raising
       out of ``reduce_to_zero`` made Python exit 1, which is *indistinguishable
       from a genuine MISMATCH* in a batch run.
    """
    # NOTE: the isinstance dispatch is deliberately OUTSIDE any try/except.
    # An earlier version referenced an unimported name here; the resulting
    # NameError was swallowed by a broad `except Exception: return False`,
    # so every spec in the suite silently reported MISMATCH. A programming
    # error must not be able to masquerade as "the residual is nonzero" --
    # that is the same failure class this function exists to remove.
    if isinstance(r, sp.ZeroMatrix):
        return True
    if isinstance(r, (sp.MatrixBase, sp.MatrixExpr)):
        # Concrete shapes: expand to entries and test them.
        try:
            return bool(sp.Matrix(r.as_explicit()).is_zero_matrix)
        except Exception:
            # Symbolic shapes cannot be made explicit. Fall back to a
            # structural test on the simplified expression.
            try:
                return isinstance(sp.simplify(r), sp.ZeroMatrix)
            except Exception:
                return False
    # Scalar path: `==` is cheap, `.equals` is the thorough (and fallible) one.
    try:
        if r == 0:
            return True
        return bool(r.equals(0))
    except Exception:
        return False


def reduce_to_zero(expr: sp.Expr) -> tuple[bool, sp.Expr]:
    """Apply a battery of simplification passes; return (is_zero, residual)."""
    # Try a sequence of simplifiers; succeed if any reduces to zero
    for f in (sp.simplify, sp.expand, sp.trigsimp, sp.radsimp, sp.together, sp.cancel):
        try:
            r = f(expr)
        except Exception:  # pragma: no cover
            continue
        if is_zero(r):
            return True, r
    # Last-resort: combined simplify on expanded form
    try:
        r = sp.simplify(sp.expand(expr))
        return is_zero(r), r
    except Exception:
        return is_zero(expr), expr


def verify(spec: dict[str, Any]) -> int:
    claim_id = spec.get("claim_id", "<unnamed>")
    source = spec.get("source", "<unknown source>")
    var_decls = spec.get("variables", {})
    start_expr = spec.get("start")
    operation = spec.get("operation", "none")
    claimed_end = spec.get("claimed_end")

    if start_expr is None or claimed_end is None:
        sys.stderr.write("ERROR: spec must declare 'start' and 'claimed_end'\n")
        return 2

    symbols = build_symbols(var_decls)
    try:
        start = parse_with(start_expr, symbols)
        end_claimed = parse_with(claimed_end, symbols)
    except Exception as exc:
        sys.stderr.write(f"ERROR parsing expression: {exc}\n")
        return 2

    try:
        end_actual = apply_operation(start, operation, symbols)
    except Exception as exc:
        sys.stderr.write(f"ERROR applying operation: {exc}\n")
        return 3

    # Install a timeout for the simplify pass — some identities can hang.
    if hasattr(signal, "SIGALRM"):
        signal.signal(signal.SIGALRM, _timeout_handler)
        signal.alarm(SIMPLIFY_TIMEOUT_SECONDS)
    try:
        difference = end_actual - end_claimed
        is_zero, residual = reduce_to_zero(difference)
    except TimeoutError_:
        sys.stderr.write(
            f"TIMEOUT: SymPy could not simplify within {SIMPLIFY_TIMEOUT_SECONDS}s. "
            "Treating as 'manual review required'.\n"
        )
        is_zero, residual = False, sp.Symbol("__timeout__")
    finally:
        if hasattr(signal, "SIGALRM"):
            signal.alarm(0)

    print(f"=== Verification report: {claim_id} ===")
    print(f"Source:        {source}")
    print(f"Operation:     {operation}")
    print(f"Start:         {start}")
    print(f"Actual end:    {end_actual}")
    print(f"Claimed end:   {end_claimed}")
    if is_zero:
        print("Result:        MATCH (SymPy reduced the difference to 0)")
        return 0
    print(f"Residual:      {residual}")
    print(
        "Result:        MISMATCH — SymPy could not reduce the difference to zero.\n"
        "               Manual review required. SymPy's simplifier is incomplete;\n"
        "               this is NOT a proof that the paper is wrong."
    )
    return 1


def main(argv: list[str]) -> int:
    if len(argv) != 2:
        sys.stderr.write(__doc__)
        return 2
    spec_path = Path(argv[1])
    if not spec_path.exists():
        sys.stderr.write(f"ERROR: spec file not found: {spec_path}\n")
        return 2
    spec = load_spec(spec_path)
    return verify(spec)


if __name__ == "__main__":  # pragma: no cover
    sys.exit(main(sys.argv))
