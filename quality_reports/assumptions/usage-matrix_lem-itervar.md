# Assumption-Usage Matrix — Lemma `lem-itervar`

**File:** `/Users/samuele/Library/CloudStorage/Dropbox/Nonparametric_IV/Volatility/Centorrino_Florens_VOL_1.qmd`
**Statement:** L591-595 — hypothesis lists `ass:identif–ass:restrvarth and ass:app1–ass:app6` (drop `ass:app5` in MI).
**Proof:** L1154–1199.
**Date:** 2026-05-17. Reviewer: assumption-auditor.

## Score: 60/100

## Findings

**Unstated (-15 each):**
- **`ass:unifbd` (uniform bounds) not in hypothesis range.** The lemma starts at `ass:identif` (L426) but `ass:unifbd` is at L259, BEFORE the range. Proof relies on it transitively via `prp-koper`, `prp-convlf`, and the explicit constants $M_1$-$M_3, R^\sigma$ at L593 and L1197. `thm-mainconv` (L537) correctly lists `ass:unifbd–ass:restrvarth`.
- **LF step-size hypothesis not restated.** `thm-mainconv` (L537) states $c\sup_{b\in\mathcal{B}_{b_\dagger}}\Vert\mathsf{A}^*_b\mathsf{A}_b\Vert < 1$ + boundary case excluded. `lem-itervar` invokes the spectral filter at L1174 without this clause.

**Unused (-10):**
- **`ass:linkcond`** is in the hypothesis range but never bites in the proof. The link condition transfers iterates from derivative coordinates to integrated coordinates; lem-itervar's conclusion is in derivative coordinates only. Used in `prp-lepskii`'s proof, not here.

## Other observations
- `ass:rateconv`'s $l_0 \ge 4$ extension is invoked implicitly at L1185 (for $L^4$ bounds on $\hat e_j$ feeding Term III). Worth citing explicitly.
- `ass:app5` correctly dropped in MI case per hypothesis.
- `ass:initcond`'s new empirical clause is load-bearing at L1187 (for $I_a$).

## Recovery path
1. Hypothesis range: `ass:identif` → `ass:unifbd` (+15).
2. Add LF step-size clause to hypothesis (+15).
3. Either drop `ass:linkcond` from hypothesis or note it is needed by `prp-convlf`'s transitive invocation (+10).

Projected: 100/100.
