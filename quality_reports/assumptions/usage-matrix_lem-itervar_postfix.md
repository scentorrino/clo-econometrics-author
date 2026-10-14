# Assumption-Usage Matrix — Lemma `lem-itervar` (post-fix)

**Trajectory:** 60 → **90/100** (+30).
**Date:** 2026-05-17.

## All three prior deductions cleared
- `ass:unifbd` now in hypothesis range (`ass:unifbd-ass:restrvarth and ass:app1-ass:app6`).
- LF step-size hypothesis restated explicitly at L593.
- `ass:linkcond` transitive use explicitly flagged at L1158(v).

## New minor finding (-10)
- **`ass:app4`** listed in hypothesis but unused in `lem-itervar`'s proof. Consumed downstream by `prp-lepskii` (L1215). Recommend a one-line remark.

## Step-size clause confirmed load-bearing
Invoked at L1158(i) and underwrites the spectral-filter calculations at L1178, L1185, L1191.

## Hypothesis count
15 named assumptions (8 in `ass:unifbd-ass:restrvarth` + 7 in `ass:app1-ass:app6`, with `ass:app3` split into 3a/3b).
