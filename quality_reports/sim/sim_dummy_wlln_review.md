# Simulation Review — Theorem dummy-wlln
**Date:** 2026-05-15
**Reviewer:** simulation-engineer-critic (manually applied — agent not yet discoverable in this session; see smoke report)

## Phase 1: Claim Identification
**PASS.** The claim under test is correctly identified: $\Pr(|\bar X_n - \mu| > \varepsilon) \to 0$ for $\varepsilon > 0$ (the WLLN's probability-of-deviation form). The simulation does NOT test a rate claim — and correctly notes in the teaching note that the WLLN gives consistency, not rate, and that the CLT would require finite second moments (which the stress DGP violates).

## Phase 2: DGP Coverage
**PASS.** Two DGPs:
- Favorable: iid Standard Normal — A1, A2 hold abundantly.
- Stress: Student-t(1.5) — A2 holds but variance is infinite. This is exactly the kind of stress test that exercises the gap between WLLN and CLT.

A third DGP (non-iid relaxation) would be appropriate if the theorem allowed for it, but since A1 is strict iid, the two DGPs cover the relevant assumption space.

## Phase 3: MC Error Budget
**PASS.** B = 2000 replications. MC SE for $\Pr(|\bar X_n| > 0.1)$ is bounded above by $\sqrt{0.25/2000} \approx 0.011$ — small enough to distinguish 5% effects from noise. The sample-size grid spans two orders of magnitude (50 → 5000). Each empirical quantity is reported with its MC SE in the adjacent column.

## Phase 4: Empirical-vs-Asymptotic Comparison
**PASS** with one substantive comment.

The empirical $\Pr(|\bar X_n - \mu| > 0.1)$ is reported. Favorable DGP shrinks from 0.48 (n=50) to 0.0000 (n=5000) — clean match to WLLN. Stress DGP shrinks from 0.84 (n=50) to 0.43 (n=5000) — also monotonically decreasing, consistent with WLLN, just slowly (because infinite variance kills the standard $\sqrt{n}$ rate that would apply with finite variance).

The verdict logic was initially too strict (flagged "MISMATCH" when absolute Pr > 0.1 at largest n) and was corrected during the smoke test to test **monotonic decrease** instead, which is the actual content of the WLLN. This is a teachable moment: simulation engineers tend to expect "small absolute probability at large n" because that's what CLT-rate claims deliver, but the WLLN only promises eventual decay.

## Phase 5: Reproducibility and Standards
**PASS.** Script `scripts/simulations/sim_dummy_wlln.py`:
- Seed set once at top (`SEED = 20260515`); `np.random.default_rng(SEED)` per DGP. (INV-14)
- `numpy` imported at top (INV-15).
- All paths via `Path(__file__).resolve().parent.parent.parent` and `Path` joins (INV-16).
- No growing vectors; `np.empty(B)` pre-allocated (INV-17).
- Table exported as bare `tabular` to `paper/tables/sim/` (INV-13).
- Summary at `quality_reports/sim/sim_dummy_wlln_summary.md` with verdict line.

## Score: 92 / 100

## Issues

- **MINOR (-5):** Initial verdict logic confused absolute probability with WLLN content. Corrected during smoke test. In future runs, the verdict function should default to monotonic-decrease testing for consistency claims and reserve absolute-quantile comparison for limiting-distribution claims.
- **MINOR (-3):** No Q-Q plot. For consistency claims this is less critical than for limiting-distribution claims, but a simple plot of $\log \Pr(|\bar X_n| > 0.1)$ vs $\log n$ would visualize the convergence rate (and show the Normal DGP is roughly straight line at slope $-1/2$ while the Student-t DGP is much flatter).

## Verdict (overall): **Matches at large n only**

The Normal DGP matches the WLLN cleanly. The Student-t(1.5) DGP also matches in the sense the theorem makes (probability-of-deviation shrinks monotonically), but at the largest n in the grid the probability is still substantial (0.43) — reflecting the cost of infinite variance. The simulation is consistent with the proof; no escalation to the theorist.

## Recommendation
Add a one-sentence remark to the paper after the proof: "While the WLLN guarantees consistency under just integrability, the rate of convergence depends sensitively on higher moments — Monte Carlo evidence confirms much slower decay of $\Pr(|\bar X_n - \mu| > \varepsilon)$ when only first moments are finite (Student-t with df = 1.5) versus when higher moments are finite (Standard Normal)."
