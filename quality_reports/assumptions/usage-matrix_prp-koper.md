# Assumption-Usage Matrix — Proposition `prp-koper`

**File:** `/Users/samuele/Library/CloudStorage/Dropbox/Nonparametric_IV/Volatility/Centorrino_Florens_VOL_1.qmd`
**Statement:** L519–530; **Proof:** L1051–1085
**Hypothesis block (L520):** "Let Assumptions \ref{ass:identif}-\ref{ass:frediff} and \ref{ass:app1}-\ref{ass:app5} hold."
**Date:** 2026-05-15. Reviewer: assumption-auditor agent.

## Score: 25 / 100

## Key finding: hypothesis block is materially loose

The assumption ordering in the .qmd is:
1. `ass:differentiability` (L246)
2. `ass:unifbd` (L259)
3. `ass:identif` (L426)
4. `ass:initcond` (L431)
5. `ass:sourcecond` (L459)
6. `ass:linkcond` (L467)
7. `ass:frediff` (L474)

The dash-range `\ref{ass:identif}-\ref{ass:frediff}` resolves to Assumptions 3–7, which **does NOT include `ass:unifbd`** (Assumption 2). Confirmed by `prp-convlf` (L440) which lists `ass:unifbd` separately precisely because the dash range would miss it.

## Findings

### Unstated condition invoked (-15)
- **`ass:unifbd` invoked twice in the proof but not in the hypothesis block.** L1063–1065 uses `ass:unifbd`(ii) (constants $M_2$, $M_3$); L1084 says explicitly "$M$ is the uniform bound in Assumption `unifbd`."

### Unused assumptions (-10 each, 4 = -40)
- **`ass:identif`** (local identification): never invoked. Local identification controls uniqueness of $b_\dagger$; prp-koper bounds remainders, doesn't need uniqueness.
- **`ass:initcond`** ($b_0 \in \mathcal{B}_{b_\dagger}$): prp-koper acts on $\hat b_j$, not on $b_0$ membership.
- **`ass:sourcecond`** (Hölder source on $b'_0 - b'_\dagger$): rate-of-convergence assumption, not used by prp-koper.
- **`ass:linkcond`** (link between $\mathsf{T}'$ smoothing and $D^{-1}$): rate machinery, irrelevant here.

### Unused assumption (-10)
- **`ass:app2`** (smoothness of $f_U$): the proof at L1082 invokes smoothness of *empirical* $\hat f_U$ via the kernel bandwidth, not population $f_U$. `ass:app2` is unused by prp-koper.

### Over-strong (-10)
- **`ass:app1`(i)** states $d$-times continuous differentiability of densities. Proof uses only (a) first $y$-derivative bound $M_2$ (from `ass:unifbd`(ii), not `ass:app1`), (b) lower bound on $f_X$ from `ass:app1`(ii). The "$d$-times" smoothness is rate machinery, not needed here.

### Hidden dependencies (no separate deduction)
- `ass:app3a`, `ass:app3b` (kernel properties): not invoked by name but necessary for Dunker (2018) Lemma 4 at L1061.

## Suggested cleanup

Replace L520 "Let Assumptions \ref{ass:identif}-\ref{ass:frediff} and \ref{ass:app1}-\ref{ass:app5} hold" with an explicit list mirroring prp-convlf's style:

> "Let Assumptions `\ref{ass:unifbd}`, `\ref{ass:frediff}`, `\ref{ass:app1}`(ii), `\ref{ass:app3a}`, `\ref{ass:app3b}`, `\ref{ass:app4}`, `\ref{ass:app5}` hold."

This drops the four unused assumptions, drops the unused `ass:app2`, narrows `ass:app1`(i) to `ass:app1`(ii), and adds the missing `ass:unifbd`. Single-line edit. Would lift score to ~95.

## Verdict

The hypothesis block of prp-koper is materially loose: omits the one assumption (`ass:unifbd`) the proof genuinely needs, and includes four assumptions plus `ass:app2` that the proof doesn't invoke. Single-line replacement of the hypothesis block closes both gaps.
