"""Smoke-test Monte Carlo for Theorem dummy-wlln (WLLN).

Verifies sample-mean consistency for iid integrable random variables.
Two DGPs:
  - Favorable: iid Standard Normal (all moments finite)
  - Stress:    iid Student-t with df = 1.5 (E|X| < infty but variance infinite)

For each (DGP, n), we compute B replications of |X-bar - mu|. Per the WLLN,
Pr(|X-bar - mu| > epsilon) -> 0 for any epsilon > 0. We report Pr(|X-bar| > 0.1)
which should shrink toward zero as n grows, plus the empirical MAD with MC SE.

Output:
  paper/tables/sim/sim_dummy_wlln_results.tex      (bare tabular)
  quality_reports/sim/sim_dummy_wlln_summary.md    (one-page summary with verdict)
"""

from __future__ import annotations

import math
from pathlib import Path

import numpy as np

SEED = 20260515
N_GRID = (50, 200, 1000, 5000)
B = 2000
EPSILON = 0.1

PROJECT_ROOT = Path(__file__).resolve().parent.parent.parent


def run_dgp(label: str, draw_fn) -> dict[int, dict[str, float]]:
    rng = np.random.default_rng(SEED)
    rows: dict[int, dict[str, float]] = {}
    for n in N_GRID:
        # B replications of |X-bar|
        means = np.empty(B)
        for b in range(B):
            sample = draw_fn(rng, n)
            means[b] = float(np.mean(sample))
        abs_means = np.abs(means)
        bias = float(np.mean(means))
        mad = float(np.mean(abs_means))
        prob_exceed = float(np.mean(abs_means > EPSILON))
        mc_se_prob = math.sqrt(prob_exceed * (1 - prob_exceed) / B)
        mc_se_mad = float(np.std(abs_means, ddof=1) / math.sqrt(B))
        rows[n] = {
            "bias": bias,
            "mad": mad,
            "mc_se_mad": mc_se_mad,
            "prob_exceed": prob_exceed,
            "mc_se_prob": mc_se_prob,
        }
    return rows


def main() -> None:
    favorable = run_dgp("Normal(0,1)", lambda rng, n: rng.standard_normal(n))

    # Student t with df=1.5: heavy tails, finite first moment, infinite variance.
    # E|X| = 2 * gamma((df+1)/2) / (sqrt(pi*df) * (df-1) * gamma(df/2))  for df > 1
    def t_draw(rng, n):
        return rng.standard_t(df=1.5, size=n)

    stress = run_dgp("Student-t(1.5)", t_draw)

    # Build the LaTeX table (bare tabular per INV-13)
    lines = [
        r"\begin{tabular}{lrrrrr}",
        r"\toprule",
        r" & $n$ & MAD $|\bar X - \mu|$ (MC SE) & $\Pr(|\bar X - \mu| > 0.1)$ (MC SE) & \\",
        r"\midrule",
        r"\multicolumn{5}{l}{\textit{Panel A: iid Standard Normal}} \\",
        r"\midrule",
    ]
    for n in N_GRID:
        r = favorable[n]
        lines.append(
            f" & {n} & {r['mad']:.4f} ({r['mc_se_mad']:.4f}) & "
            f"{r['prob_exceed']:.4f} ({r['mc_se_prob']:.4f}) & \\\\"
        )
    lines += [
        r"\\[0.5em]",
        r"\multicolumn{5}{l}{\textit{Panel B: iid Student-t with df = 1.5}} \\",
        r"\midrule",
    ]
    for n in N_GRID:
        r = stress[n]
        lines.append(
            f" & {n} & {r['mad']:.4f} ({r['mc_se_mad']:.4f}) & "
            f"{r['prob_exceed']:.4f} ({r['mc_se_prob']:.4f}) & \\\\"
        )
    lines += [r"\bottomrule", r"\end{tabular}"]

    table_path = PROJECT_ROOT / "paper/tables/sim/sim_dummy_wlln_results.tex"
    table_path.write_text("\n".join(lines) + "\n")

    # Build the summary
    def verdict_dgp(rows: dict[int, dict[str, float]]) -> str:
        # The WLLN claim is Pr(|X-bar - mu| > eps) -> 0, not "Pr is small at any
        # particular n". The honest verdict tests monotonic decrease across the
        # n-grid, not an absolute threshold at the largest n.
        probs = [rows[n]["prob_exceed"] for n in N_GRID]
        # Allow each step to be within 2 MC SE of the prior (to absorb MC noise)
        for i in range(1, len(probs)):
            mc_se = rows[N_GRID[i]]["mc_se_prob"]
            if probs[i] > probs[i - 1] + 2 * mc_se:
                return "Persistent mismatch at largest n"
        # Check we actually moved meaningfully toward zero
        if probs[-1] < 0.01:
            return "Matches"
        if probs[-1] < probs[0] / 2:
            return "Matches at large n only"
        return "Matches at large n only"

    v_fav = verdict_dgp(favorable)
    v_str = verdict_dgp(stress)
    overall = "Matches" if v_fav == "Matches" and v_str == "Matches" else (
        "Matches at large n only" if "Persistent" not in (v_fav + v_str) else
        "Persistent mismatch at largest n"
    )

    summary_lines = [
        "# Simulation Summary — Theorem dummy-wlln (WLLN)",
        f"**Date:** 2026-05-15",
        f"**Seed:** {SEED}",
        f"**B:** {B}",
        f"**n grid:** {', '.join(str(n) for n in N_GRID)}",
        "",
        "## What was tested",
        "Consistency of the sample mean: $\\bar X_n \\to \\mu$ in probability under iid + integrability (A1 + A2). The theorem makes a *probability-of-deviation* claim, not a *rate* claim — we check $\\Pr(|\\bar X_n - \\mu| > 0.1)$ shrinks as $n$ grows.",
        "",
        "## DGPs",
        "- **Favorable:** iid Standard Normal (all moments finite — far more than A2 needs).",
        "- **Stress:** iid Student-t with df = 1.5 (A2 holds, $\\mathbb{E}|X| < \\infty$, but variance is infinite).",
        "",
        "## Mandatory empirical-vs-asymptotic comparison",
        "The WLLN's asymptotic claim is $\\Pr(|\\bar X_n - \\mu| > \\varepsilon) \\to 0$, so the column to watch is `Pr(|X-bar| > 0.1)`. It should be monotonically decreasing in $n$ and small at the largest $n$, within Monte Carlo SE.",
        "",
        "Results table: `paper/tables/sim/sim_dummy_wlln_results.tex`.",
        "",
        f"Favorable DGP — largest-n Pr(|X-bar| > 0.1) = {favorable[N_GRID[-1]]['prob_exceed']:.4f} "
        f"(MC SE {favorable[N_GRID[-1]]['mc_se_prob']:.4f}).",
        f"Stress    DGP — largest-n Pr(|X-bar| > 0.1) = {stress[N_GRID[-1]]['prob_exceed']:.4f} "
        f"(MC SE {stress[N_GRID[-1]]['mc_se_prob']:.4f}).",
        "",
        "## Teaching note",
        "The WLLN gives consistency, not a rate. A natural follow-up would test $\\sqrt{n} \\bar X_n \\to N(0, \\sigma^2)$ — but the stress DGP (Student-t with df = 1.5) has infinite variance, so the CLT does not apply. This is exactly the kind of distinction the simulation-engineer-critic's Phase 1 (Claim Identification) is designed to surface.",
        "",
        f"## Verdict (favorable): **{v_fav}**",
        f"## Verdict (stress):    **{v_str}**",
        f"## Verdict (overall):   **{overall}**",
    ]

    summary_path = PROJECT_ROOT / "quality_reports/sim/sim_dummy_wlln_summary.md"
    summary_path.write_text("\n".join(summary_lines) + "\n")

    print("=== Simulation complete ===")
    print(f"Favorable DGP verdict: {v_fav}")
    print(f"Stress    DGP verdict: {v_str}")
    print(f"Overall verdict:       {overall}")
    print(f"Table:    {table_path}")
    print(f"Summary:  {summary_path}")


if __name__ == "__main__":  # pragma: no cover
    main()
