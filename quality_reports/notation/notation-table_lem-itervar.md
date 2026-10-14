# Notation Audit — Lemma `lem-itervar` (Per-iterate Variance Bound)

**File:** `/Users/samuele/Library/CloudStorage/Dropbox/Nonparametric_IV/Volatility/Centorrino_Florens_VOL_1.qmd`
**Scope:** L580–595 (bias paragraph + statement), L1154–1199 (proof), L1201–1212 (invocation).
**Date:** 2026-05-17. Reviewer: notation-warden.

## Score: 80/100

## Findings

**Undefined on first use (-5 each):**
- $M_4$ in lemma statement L593 has no definition. Same object as `ass:unifbd`(iv)'s $m_4$ (lowercase) at L266 and at L1197 in the proof.
- $\beta_\epsilon$ used in statement L595 without local pointer to where it is defined (in `thm-mainconv`).

**Typography inconsistency (-2 each):**
- $M_4$ (statement) vs $m_4$ (proof, assumption) for the same fourth-moment constant.

**Stale prose line-number references (-2 each):**
- L589 "L1094" → should be L1097.
- L1156 "lines 911-918" → should be L1099-L1106.
- L1179 "line 943" → should be L1131 or L1091.
- L1193 "line 948" → should be L1138-L1141.

## Recovery path
- Replace `M_4` with `m_4` at L593 (+7).
- Add `(saturation index from @thm-mainconv)` after $\beta_\epsilon$ at L595 (+5).
- Replace prose line refs with `\eqref{}` labels (+8).

Projected: 100/100.
