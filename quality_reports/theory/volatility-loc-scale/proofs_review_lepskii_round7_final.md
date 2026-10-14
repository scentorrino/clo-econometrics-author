# Round-7 Theorist-Critic Review: `prp-lepskii` (Lead-in Sentence Polish)

**Target:** `prp-lepskii` (Lepskii oracle inequality), Form B (paper qmd lead-in to post-proposition discussion).
**Severity:** HIGH (Execution phase).
**Round:** 7 (one-line follow-up to R6 polish).
**Date:** 2026-05-20.
**Trajectory:** R3 = 69 (terminal halt) → R4-bandwidth = 64/100 → R5 = 88/100 (Commit-cleared) → R6 = 94/100 (PR-cleared) → **R7 = 94/100**.

The R6 critic identified one new minor item worth −1: the stale L629 first sentence "the value $\tau \in [3, 6]$ used there is in line with the Mathé-Pereverzev range," which read as if the simulations use $\tau \in [3, 6]$ when in fact `sec-mc-tau` reports the empirical optimum at $\tau \in \{1, 2\}$. This audit verifies the one-line replacement and confirms whether the submission gate (≥ 95) is now cleared.

---

## Phase 0 — Verification table

| # | Check | File(s) | Verdict |
|---|---|---|---|
| R | Regression grep: `c_K, d_K, c_{\mathrm{sub}}, h^{d_K}, nh^{d_K}, tau_n^*, eq-csubnh, eq-app4ii-conc` absent from all 5 active artifacts | qmd, proofs.tex, results.tex, assumptions.tex, notation_glossary.md | **PASS** (5/5 empty; only the `lepskii_bandwidth_refinement.md` historical memo retains the symbols, intentional) |
| 1 | L629 edit landed: "the value $\tau \in [3, 6]$ used there is in line with the Mathé-Pereverzev range" → "the Mathé-Pereverzev recommendation $\tau \in [3, 6]$ is the asymptotic range" | qmd L629 | **PASS** (Option A landed verbatim) |
| 2 | Edit-3 bridge sentence (R6 Edit 3) is unchanged | qmd L629 second sentence | **PASS** |
| 3 | R6 Edit 1 (scope clause): "rate-adaptive for source-condition exponents $\beta_\epsilon \ge 1$" in Form B prp-lepskii statement | qmd L620 | **PASS** (unchanged from R6) |
| 4 | R6 Edit 2 ($M_n$ upper bound): "$M_n = O(\delta_n^{-1})$ — equivalently, $M_n \asymp \delta_n^{-2/(\beta_\epsilon+1)}$" at both sites | qmd L601 & L1332 | **PASS** (unchanged from R6) |
| 5 | R6 Edit 4 (Step 1 value cross-cite): "the explicit value $\tau_0 := C_V \vee 2$ is computed in Step 1 of the proof of Proposition \ref{prp-lepskii}" | qmd L1024 | **PASS** (unchanged from R6) |
| 6 | R6 Edit 5 (absorption-site cross-cite): "(by Assumption~\ref{ass:frediff}\textup{(ii)}, with the $\kappa_n^{-1}$-dependence of $L'_{\mathsf T}$ disclosed there)" | proofs.tex L261-262, results.tex L576-577 | **PASS** (unchanged from R6) |
| 7 | Factual accuracy of new lead-in vs `sec-mc-tau` actual content (sweep $\{1, 2, 4, 6, 8, 12, 16\}$, empirical optimum $\{1, 2\}$) | qmd L629 vs L841, L853 | **PASS** (the "asymptotic range" framing is consistent with `sec-mc-tau` L841) |

All checks pass on landing and regression. The R6 stale-framing minor item is closed.

---

## Paragraph-flow read

Reading L629 as a single paragraph:

> "@prp-lepskii implies that the Lepskii-balanced LF estimator is *rate-adaptive* … The constant $\tau_0$ above is the theoretical analogue of the $\tau$-parameter that we calibrate empirically in @sec-mcsim; **the Mathé-Pereverzev recommendation $\tau \in [3, 6]$ is the asymptotic range**, with $\tau \to \infty$ producing a too-conservative early stop and $\tau \to 1$ producing under-regularization. **The asymptotic recommendation $\tau \in [3, 6]$ from @mathe2003 is the large-$n$ analogue** where $\tau_0$'s $\beta$-dependent component dominates; for moderate $n$ with Silverman bandwidths in our simulation regime, $\tau_0 = C_V \vee 2$ lands in the lower half of this band and the finite-sample recommendation reduces to $\tau \in \{1, 2\}$ (see Remark \ref{rem:tau-bandwidth} and @sec-mc-tau)."

**The R6 stale issue is closed** — the lead-in no longer claims that `sec-mc-tau` uses $\tau \in [3, 6]$. **However, a fresh -1 redundancy issue is introduced** by the choice of phrasing:

- **Lead-in (new):** "the Mathé-Pereverzev recommendation $\tau \in [3, 6]$ is the asymptotic range, with $\tau \to \infty$ … and $\tau \to 1$ …"
- **Edit-3 bridge (unchanged):** "The asymptotic recommendation $\tau \in [3, 6]$ from @mathe2003 is the large-$n$ analogue where $\tau_0$'s $\beta$-dependent component dominates; …"

The two sentences are now almost-verbatim duplicates on the load-bearing content:
- the **same numeric range** $\tau \in [3, 6]$ stated twice in immediate succession
- the **same source** (Mathé-Pereverzev, once by name, once by `@mathe2003` cite)
- the **same framing** ("asymptotic range" ≈ "large-$n$ analogue")

The lead-in's residual content beyond the bridge is the endpoint commentary ($\tau \to \infty$ over-conservative, $\tau \to 1$ under-regularized) — useful, but it is now in the second clause of a sentence whose first clause restates information that the next sentence will also state. A reader gets the "$\tau \in [3, 6]$ is asymptotic, Mathé-Pereverzev" assertion twice in two sentences.

This is the kind of polish minor that Phase-4 critics call out: not factually wrong, not structurally broken, but a redundancy a copy-editor would flag and ask to consolidate. Worth **-1**, exactly offsetting the **+1** closure of the R6 stale-framing minor.

Two non-disruptive alternatives that would have avoided the redundancy:
- *Lead-in trimmed:* "the Mathé-Pereverzev recommendation lies in $[3, 6]$, with $\tau \to \infty$ … and $\tau \to 1$ …" (drops "is the asymptotic range" — the framing is then carried only by the bridge).
- *Lead-in re-cast:* "the empirical $\tau$-grid in `sec-mc-tau` is centered below the Mathé-Pereverzev band, with $\tau \to \infty$ … and $\tau \to 1$ …" (re-anchors on the simulation grid; lets the bridge introduce Mathé-Pereverzev cleanly).

---

## Scoring

| Component | R6 score | R7 delta | R7 score |
|---|---|---|---|
| B1 — operator→iterate propagation (deferred future work per memo §9 item 2) | -3 | 0 | -3 |
| B5 — `ass:frediff(ii)` $\kappa_n^{-1}$-disclosure (R6 Edit 5) | 0 | 0 | 0 |
| R3 F2 — scope clause Form B alignment (R6 Edit 1) | 0 | 0 | 0 |
| Cross-form $M_n$ growth presentation (R6 Edit 2) | 0 | 0 | 0 |
| Cross-form $\tau$-recommendation tension (R6 Edit 3) | 0 | 0 | 0 |
| Phase 4 polish — Form B `ass:app4(ii)` cross-cite (R6 Edit 4) | 0 | 0 | 0 |
| Stale qmd L629 first sentence (R6 NEW minor) | -1 | +1 (Option A closes the "used there" stale framing) | 0 |
| **NEW — qmd L629 redundancy** (lead-in restates "Mathé-Pereverzev $\tau \in [3, 6]$ as asymptotic range," then bridge restates "$\tau \in [3, 6]$ from @mathe2003 is the large-$n$ analogue") | — | -1 | -1 |
| **Total deductions** | -4 | 0 net | -4 |
| **Final score** | 94 | 0 net | **94/100** |

---

## Gate verdict

| Gate | Threshold | Verdict |
|---|---|---|
| Commit | ≥ 80 | **PASS** (94) |
| PR | ≥ 90 | **PASS** (94) |
| Submission | ≥ 95 + all components ≥ 80 | **FAIL** (94, 1 point short — same gap as R6) |
| Execution-phase | ≥ 80 | **PASS** (94) |

Submission gate remains 1 point short. The net score did not move because the R7 edit closed the R6 stale-framing minor (+1) but opened a new same-weight redundancy minor (-1).

---

## Standing residuals

1. **B1 — operator→iterate propagation hand-wave (deferred per theorist memo §9 item 2).** Worth -3 indefinitely under the brief's "deferred future work" classification.
2. **NEW — qmd L629 redundancy (replaces R6 stale-framing minor).** A one-line edit consolidating the two consecutive sentences — for example, trimming the lead-in to "the Mathé-Pereverzev recommendation lies in $[3, 6]$, with $\tau \to \infty$ … and $\tau \to 1$ …" so the bridge carries the "asymptotic range" framing alone — would close the last 1-point gap. Worth +1 toward submission gate.

---

## Recommendation

**Status: CLEAR for Commit (≥ 80) and PR (≥ 90); not yet cleared for Submission (≥ 95).**

**One more single-line polish would clear the submission gate.** The R7 edit closed the precise stale-framing minor flagged by R6, but the choice between three roughly equivalent rephrasing options introduced a redundancy with the immediately following bridge sentence. The fix is a single-line consolidation: either trim the lead-in's "is the asymptotic range" tag (letting the bridge own that framing), or drop the $[3, 6]$ from the lead-in entirely. With either fix, the L629 paragraph reads as: *theoretical-analogue framing → endpoint commentary → bridge to large-$n$ vs moderate-$n$ contrast → finite-sample recommendation* — without restating the same range twice.

**Trajectory commentary.** R3→R4→R5→R6 closed five substantive items; R6→R7 attempted to close the last polish minor but introduced an equal-weight new one. The submission gate is genuinely close (one consolidation away), but the cleanest path is now a second pass on L629 first sentence, not a verdict of "submission-cleared."

**Do not** attempt to address B1 in the current round — the brief is explicit that this is deferred future work.

**Verdict: one more polish.**
