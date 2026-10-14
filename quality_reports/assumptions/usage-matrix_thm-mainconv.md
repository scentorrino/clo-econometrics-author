# Assumption-Usage Matrix — Theorem `thm-mainconv`

**File:** `/Users/samuele/Library/CloudStorage/Dropbox/Nonparametric_IV/Volatility/Centorrino_Florens_VOL_1.qmd`
**Statement:** L536–544; **Proof:** L1086–1126
**Hypothesis block (L537):** "Assumptions \ref{ass:identif}-\ref{ass:restrvarth} and \ref{ass:app1}-\ref{ass:app6}"
**Date:** 2026-05-15. Reviewer: assumption-auditor agent.

## Score: 45 / 100

## Findings

### -15: Dash-range omits `ass:unifbd`
Same defect as prp-koper. `ass:unifbd` (L259) sits before `ass:identif` (L426); dash-range `ass:identif`-`ass:restrvarth` misses it. Yet `ass:unifbd` is invoked transitively via `prp-koper(b)` at L1113–1115 (constant $M_{23}$) and via `lem-app3` boundedness at L1101, L1108–1110, L1119; clause (iii) needed for $\Vert\mathsf{T}'_{b_\dagger}\Vert$ bounds. **Fix:** change to "Assumptions \ref{ass:unifbd}-\ref{ass:restrvarth}".

### -15: High-probability event from prp-koper not propagated
`prp-koper` now delivers (a)/(b) on $\mathcal{E}_n$ with $\mathbb{P}(\mathcal{E}_n) \to 1$. Conclusion of `thm-mainconv` is on $E\Vert\hat e_N\Vert^2$ — full probability space. Off-event $\mathcal{E}_n^c$ contribution silently ignored. Same R-1 issue as `prp-lepskii`. **Fix:** add explicit a-priori bound on iterates OR reformulate `prp-koper` in expectation.

### -10: `ass:restrvarth` carries the induction but never named
The induction at L1122–1126 produces the $\beta_\epsilon = \beta \wedge (1-\epsilon)$ saturation, which comes from `ass:restrvarth`(iii). Never cited by name in the proof. "Following the scheme of @centorrinofeveflorens2019" discharges by citation. **Fix:** cite `ass:restrvarth(i)–(iii)` explicitly at induction step.

### -5 each, -10 total: `ass:identif`, `ass:initcond` weakly used
Listed in hypothesis block but never invoked by name. `ass:initcond` enters transitively through `ass:sourcecond`'s preamble. `ass:identif` is scaffolding. **Fix:** add one bridging sentence at start of proof.

### -5: Induction citation discharge
L1122 "following the scheme of @centorrinofeveflorens2019" + L1126 "the dominant contributions combine" condense the most delicate step. The $\beta_\epsilon$ saturation is NEW (does not appear in centorrinofeveflorens2019). **Fix:** expand or pinpoint specific lemmas in the cited paper that carry over.

## Usage matrix highlights

| Assumption | Used directly | Used via prp-koper |
|---|---|---|
| `ass:sourcecond` | L1097, L1101 | — |
| `ass:linkcond` | L1126 | — |
| `ass:rateconv` | L1101, L1103 | — |
| `ass:app6` | L1097 (qualification) | — |
| `ass:app4` | L1115 ($\kappa_n^{-1}$) | yes |
| `ass:restrvarth` | NEVER by name | implicitly at L1122–1126 |
| `ass:unifbd` | NOT in hypothesis | yes (via $M_{23}$) |
| `ass:identif`, `ass:initcond` | NEVER by name | only via prp-koper's frame |
| `ass:frediff`, `ass:app1-app5` | rarely direct | yes |

## Suggestions

1. Fix dash range to include `ass:unifbd`.
2. Add off-$\mathcal{E}_n$ bookkeeping (or move to expectation form).
3. Cite `ass:restrvarth` explicitly at the induction step.
4. Add bridging line for `ass:identif`/`ass:initcond`.
5. Pinpoint centorrinofeveflorens2019 citations.
