#!/usr/bin/env python3
"""Matrix dimension checker.

Reads a spec (same format as verify.py) and validates that all matrix
operations (multiplication, addition, inverse) are dimensionally
consistent. This catches a class of error that symbolic simplification
does not — dimensional inconsistency is decidable.

Usage:
    python3 dim_check.py <spec_path>

Exit codes:
    0 — all dimensions consistent
    1 — dimensional inconsistency found
    2 — spec error
"""

from __future__ import annotations

import json
import re
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Any

try:
    import yaml  # type: ignore[import-not-found]

    HAS_YAML = True
except ImportError:
    HAS_YAML = False


@dataclass(frozen=True)
class Dim:
    rows: str | int
    cols: str | int

    def __str__(self) -> str:
        return f"({self.rows} x {self.cols})"


def load_spec(path: Path) -> dict[str, Any]:
    text = path.read_text()
    suffix = path.suffix.lower()
    if suffix in {".yaml", ".yml"}:
        if not HAS_YAML:
            sys.stderr.write(
                "ERROR: YAML requires PyYAML. Install with: pip install pyyaml\n"
            )
            sys.exit(2)
        return yaml.safe_load(text)
    if suffix == ".json":
        return json.loads(text)
    sys.stderr.write(f"ERROR: spec must be .yaml, .yml, or .json (got {suffix})\n")
    sys.exit(2)


def extract_matrix_dims(var_decls: dict[str, Any]) -> dict[str, Dim]:
    """Collect declared matrix dimensions."""
    dims: dict[str, Dim] = {}
    for name, decl in var_decls.items():
        if isinstance(decl, dict) and decl.get("domain") == "matrix":
            d = decl.get("dims")
            if d is None or len(d) != 2:
                sys.stderr.write(f"ERROR: matrix variable '{name}' missing dims\n")
                sys.exit(2)
            dims[name] = Dim(d[0], d[1])
    return dims


# A minimal recursive-descent dimension checker for expressions of the form
#   A * B + C
#   inv(A)
#   transpose(A) or A^T  (we accept A.T or A^T)
# We do not run full SymPy here — the goal is decidable dim flow, not
# semantic simplification.

TOKEN_RE = re.compile(r"\s*(\*\*|\.T|\^T|<=|>=|==|[A-Za-z_][A-Za-z0-9_]*|\d+\.?\d*|[+\-*/()^,])\s*")


def tokenize(expr: str) -> list[str]:
    tokens: list[str] = []
    i = 0
    while i < len(expr):
        m = TOKEN_RE.match(expr, i)
        if not m:
            raise ValueError(f"tokenize error at position {i}: '{expr[i:i+20]}'")
        tok = m.group(1)
        tokens.append(tok)
        i = m.end()
    return tokens


class DimChecker:
    """Recursive descent dimension flow.

    Grammar (subset):
        expr   := term (('+' | '-') term)*
        term   := factor (('*' | '/') factor)*
        factor := atom ('**' factor | '^T' | '.T')?
        atom   := IDENT | NUMBER | '(' expr ')' | 'inv' '(' expr ')' | 'transpose' '(' expr ')'
    """

    def __init__(self, tokens: list[str], dims: dict[str, Dim]) -> None:
        self.tokens = tokens
        self.pos = 0
        self.dims = dims
        self.findings: list[str] = []

    def peek(self) -> str | None:
        return self.tokens[self.pos] if self.pos < len(self.tokens) else None

    def eat(self, expected: str | None = None) -> str:
        if self.pos >= len(self.tokens):
            raise ValueError("unexpected end of expression")
        tok = self.tokens[self.pos]
        if expected is not None and tok != expected:
            raise ValueError(f"expected '{expected}' got '{tok}'")
        self.pos += 1
        return tok

    def parse_expr(self) -> Dim | None:
        left = self.parse_term()
        while self.peek() in {"+", "-"}:
            op = self.eat()
            right = self.parse_term()
            if left is None or right is None:
                continue
            if left.rows != right.rows or left.cols != right.cols:
                self.findings.append(
                    f"Dimension mismatch on '{op}': {left} vs {right}"
                )
                # Return left and continue — best-effort
            # Same dim; left unchanged
        return left

    def parse_term(self) -> Dim | None:
        left = self.parse_factor()
        while self.peek() in {"*", "/"}:
            op = self.eat()
            right = self.parse_factor()
            if left is None or right is None:
                continue
            if op == "*":
                # Matrix mult: left.cols == right.rows ; result (left.rows, right.cols)
                if isinstance(left.cols, str) or isinstance(right.rows, str):
                    if left.cols != right.rows:
                        self.findings.append(
                            f"Multiplication dimension mismatch: {left} * {right}"
                        )
                else:
                    if left.cols != right.rows:
                        self.findings.append(
                            f"Multiplication dimension mismatch: {left} * {right}"
                        )
                left = Dim(left.rows, right.cols)
            else:  # /
                # Treat A / B as A * inv(B); B must be square
                if right.rows != right.cols:
                    self.findings.append(
                        f"Division by non-square matrix: {right}"
                    )
                if left.cols != right.rows:
                    self.findings.append(
                        f"Division dimension mismatch: {left} / {right}"
                    )
                left = Dim(left.rows, right.cols)
        return left

    def parse_factor(self) -> Dim | None:
        atom = self.parse_atom()
        # Power / transpose suffixes
        while self.peek() in {"**", "^T", ".T"}:
            op = self.eat()
            if op in {"^T", ".T"}:
                if atom is None:
                    continue
                atom = Dim(atom.cols, atom.rows)
            elif op == "**":
                exp_tok = self.eat()
                # If it's an integer, the matrix must be square
                try:
                    int(exp_tok)
                    if atom is not None and atom.rows != atom.cols:
                        self.findings.append(
                            f"Power on non-square matrix: {atom}**{exp_tok}"
                        )
                except ValueError:
                    pass
                # dimension unchanged
        return atom

    def parse_atom(self) -> Dim | None:
        tok = self.peek()
        if tok is None:
            return None
        if tok == "(":
            self.eat("(")
            inner = self.parse_expr()
            self.eat(")")
            return inner
        if tok in {"inv", "transpose"}:
            name = self.eat()
            self.eat("(")
            inner = self.parse_expr()
            self.eat(")")
            if inner is None:
                return None
            if name == "inv":
                if inner.rows != inner.cols:
                    self.findings.append(f"inv() on non-square matrix: {inner}")
                return inner
            else:  # transpose
                return Dim(inner.cols, inner.rows)
        if tok in self.dims:
            self.eat()
            return self.dims[tok]
        # Number or unknown identifier — treat as scalar (rows=cols=1)
        try:
            float(tok)
            self.eat()
            return Dim(1, 1)
        except ValueError:
            # Unknown identifier; assume scalar
            self.eat()
            return Dim(1, 1)


def check_expr(expr: str, dims: dict[str, Dim]) -> tuple[Dim | None, list[str]]:
    tokens = tokenize(expr)
    checker = DimChecker(tokens, dims)
    final = checker.parse_expr()
    return final, checker.findings


def main(argv: list[str]) -> int:
    if len(argv) != 2:
        sys.stderr.write(__doc__)
        return 2
    spec_path = Path(argv[1])
    if not spec_path.exists():
        sys.stderr.write(f"ERROR: spec file not found: {spec_path}\n")
        return 2
    spec = load_spec(spec_path)

    var_decls = spec.get("variables", {})
    dims = extract_matrix_dims(var_decls)
    if not dims:
        print("No matrix variables in spec — dim_check is a no-op.")
        return 0

    print(f"=== Dim check: {spec.get('claim_id', '<unnamed>')} ===")
    print(f"Matrix variables: {dict((k, str(v)) for k, v in dims.items())}")

    all_findings: list[str] = []
    for field in ("start", "claimed_end"):
        expr = spec.get(field)
        if expr is None:
            continue
        try:
            final, findings = check_expr(expr, dims)
            print(f"{field}: final dim = {final}")
            for f in findings:
                print(f"  - {f}")
            all_findings.extend(findings)
        except Exception as exc:
            print(f"{field}: parse failure — {exc}")
            all_findings.append(f"{field}: parse failure")

    if all_findings:
        print(f"\nResult: DIM_MISMATCH ({len(all_findings)} issues)")
        return 1
    print("\nResult: ALL DIMENSIONS CONSISTENT")
    return 0


if __name__ == "__main__":  # pragma: no cover
    sys.exit(main(sys.argv))
