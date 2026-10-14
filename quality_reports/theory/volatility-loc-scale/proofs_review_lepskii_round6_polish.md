# Round-6 Theorist-Critic Review: `prp-lepskii` (Polish Round)

**Target:** `prp-lepskii` (Lepskii oracle inequality), both Form A (audit artifact) and Form B (paper qmd).
**Severity:** HIGH (Execution phase).
**Round:** 6 (polish round on R5 abstract-form revert).
**Date:** 2026-05-20.
**Trajectory:** R3 = 69 (terminal halt) → R4-bandwidth = 64/100 → R5 = 88/100 (Commit-cleared) → **R6 = 94/100**.

The R5 critic cleared the abstract-form revert at 88/100 with five single-line residual items, all cosmetic. The theorist applied the five suggested edits. This audit verifies the edits land and confirms whether the PR gate (≥ 90) is now cleared.

---

## Phase 0 — Regression check + per-edit verification grep table

| # | Check | File(s) | Verdict |
|---|---|---|---|
| R | Regression grep: `c_K, d_K, c_sub, h^{d_K}, nh^{d_K}, tau_n^*, eq-csubnh, eq-app4ii-conc` absent from all 5 active artifacts | proofs.tex, results.tex, assumptions.tex, notation_glossary.md, qmd | **PASS** (5/5 empty; only historical memos retain symbols, intentional) |
| 1 | "rate-adaptive for source-condition exponents $\beta_\epsilon \ge 1$" in Form B prp-lepskii statement | qmd L620 | **PASS** (present at end of statement paragraph, before `:::` close) |
| 2 | "$M_n = O(\delta_n^{-1})$ — equivalently, $M_n \asymp \delta_n^{-2/(\beta_\epsilon+1)}$ in the rate-optimal regime" at both sites | qmd L601 & L1332 | **PASS** (L601: rate-discussion of `ass:restrvarth`; L1332: Step 2 off-event combination — both display the upper bound + asymptotic) |
| 3 | "The asymptotic recommendation $\tau \in [3, 6]$ ... reduces to $\tau \in \{1, 2\}$ ... (see Remark \ref{rem:tau-bandwidth} and @sec-mc-tau)" | qmd L629 | **PASS** (bridge sentence appended at end of discussion paragraph; `\ref{rem:tau-bandwidth}` resolves to the LaTeX label at L1341) |
| 4 | "the explicit value $\tau_0 := C_V \vee 2$ is computed in Step 1 of the proof of Proposition \ref{prp-lepskii}" | qmd L1024 | **PASS** (spliced into `ass:app4(ii)` dependence list; "We have, for every $m \le M_n$..." re-flow attaches cleanly to the displayed inequality at L1026) |
| 5 | "(by Assumption~\ref{ass:frediff}\textup{(ii)}, with the $\kappa_n^{-1}$-dependence of $L'_{\mathsf T}$ disclosed there)" at absorption display | proofs.tex L261-262, results.tex L576-577 | **PASS** (proofs.tex: parenthetical follows the bound display at L259-260, before the next "The contribution..." sentence; results.tex: parenthetical sits between L575 first $R^{(2)}_{m,j}$ occurrence and L578 `\begin{align}` block — at the first $L'_{\mathsf T}$ occurrence in the absorption step, not buried inside the align environment) |

All 6 checks pass. No regressions; all 5 polish edits visible at the specified line ranges in the specified files.

---

## Per-edit credit table

| Edit | Status | R5 deduction closed | Credit applied | New minor issue |
|---|---|---|---|---|
| 1. Form B F2 scope clause (qmd L620) | LANDED | -3 (Form B F2 lingering) | **+3** | None — inline phrasing substantively equivalent to Form A's "(cf. Remark~\ref{rem:scope})" |
| 2. Form B $M_n$ upper bound (qmd L601, L1332) | LANDED | -1 (cross-form $M_n$ presentation) | **+1** | Mild parse issue at L601: "...of @cor-rates, in the scope $\beta_\epsilon \ge 1$, polynomial in $n$" — "polynomial in $n$" could be parsed as modifying $\beta_\epsilon \ge 1$ rather than the whole clause; context resolves. Not deducted. |
| 3. Form B $\tau$-recommendation bridge (qmd L629) | LANDED | -1 ($\tau$-recommendation tension) | **+1** | Yes (-1): the appended bridge sharpens the bridge between asymptotic $\tau \in [3, 6]$ and finite-$n$ $\tau \in \{1, 2\}$, but the *first* sentence of the same paragraph still reads "the value $\tau \in [3, 6]$ used there is in line with the Mathé-Pereverzev range" — which is stale (the empirical analysis at `sec-mc-tau` actually uses $\tau \in \{1, 2\}$ at $n = 500$). The bridge mostly reconciles this, but the un-corrected first sentence remains technically misleading in isolation. |
| 4. Form B `ass:app4(ii)` cross-cite (qmd L1024) | LANDED | -1 (Phase 4 polish, Step 1 value cross-cite) | **+1** | The "such that for every" → "We have, for every" re-flow keeps the display attached cleanly. The sentence is now longer (single semicolon + period split) but reads correctly. None deducted. |
| 5. Form A absorption-site cross-cite (proofs.tex L261-262, results.tex L576-577) | LANDED | -1 (B5 absorption-site cross-reference) | **+1** | Placement is at the first $L'_{\mathsf T}$ occurrence in the absorption display in both files, NOT buried inside the align environment. None deducted. |

Total credit: **+7 (R5 deductions closed)** − **1 (new minor: stale "$\tau \in [3, 6]$ used there" in qmd L629 first sentence, surfaced more starkly by the appended bridge)** = **+6 net**.

---

## Cross-references and grammatical verification

- **Edit 3 cross-reference adaptation.** The theorist correctly rewrote `@rem-tau-bandwidth` as `Remark \ref{rem:tau-bandwidth}` because the label `\label{rem:tau-bandwidth}` is defined inside a `{=latex}` block (qmd L1341) and Quarto's `@`-cross-ref convention applies to native chunk-ids only, not raw-LaTeX labels. Under XeLaTeX compilation, `\ref{rem:tau-bandwidth}` resolves correctly because both the label and the reference are LaTeX-level. **Adaptation correct.**
- **Edit 4 grammatical splice.** "such that for every $m \le M_n$..." → "We have, for every $m \le M_n$ and every $\tau \ge \tau_0$,". The "We have, for every..." properly introduces the display equation $\Pr(\|\hat b'_m - b'_m\| > \tau V(m)) \le \exp(-c_0 \tau^2)$ at L1026, with "with $V(m)$ from @eq-Vm." attaching cleanly after the display. **Acceptable.**
- **Edit 5 placement.** proofs.tex L261-262: parenthetical immediately after the bound display (L259-260) and before the next sentence "The contribution of $R^{(2)}_{m,j}$ to Term~$IV_m$..." (L263). results.tex L576-577: parenthetical between L575 (first $R^{(2)}_{m,j}$ occurrence outside the lemma statement) and L578 (`\begin{align}` block where $L'_{\mathsf T}$ first appears in the absorption step). **Placement correct in both files.**

---

## Scoring

| Component | R5 score | R6 delta | R6 score |
|---|---|---|---|
| B1 — operator→iterate propagation (deferred future work per memo §9 item 2) | -3 | 0 | -3 |
| B3 — $\tau_0 = C_V \vee 2$ | 0 | 0 | 0 |
| B4 — `ass:iterbd` one-liner | 0 | 0 | 0 |
| B5 — `ass:frediff`(ii) $\kappa_n^{-1}$-disclosure | -1 | +1 (Edit 5) | 0 |
| R3 F2 — scope clause Form B alignment | -3 | +3 (Edit 1) | 0 |
| R3 F3 — Vershynin 2018 cite | 0 | 0 | 0 |
| R3 F5 — $III_m$ $\tau^2$-bookkeeping | 0 | 0 | 0 |
| MI/FI operator-agnosticism | 0 | 0 | 0 |
| `rem:tau-bandwidth` reframe | 0 | 0 | 0 |
| `sec-mc-tau` consistency | 0 | 0 | 0 |
| Cross-form $M_n$ growth presentation | -1 | +1 (Edit 2) | 0 |
| Cross-form $\tau$-recommendation tension | -1 | +1 (Edit 3) | 0 |
| Phase 4 polish — Form B `ass:app4(ii)` cross-cite to Step 1 | -1 | +1 (Edit 4) | 0 |
| **NEW** — stale "$\tau \in [3, 6]$ used there" in qmd L629 first sentence | — | -1 | -1 |
| **Total deductions** | | | **-4** |
| **Final score** | 88 | +6 | **94/100** |

---

## Gate verdict

| Gate | Threshold | Verdict |
|---|---|---|
| Commit | ≥ 80 | **PASS** (94) |
| PR | ≥ 90 | **PASS** (94) |
| Submission | ≥ 95 + all components ≥ 80 | **FAIL** (94, 1 point short) |
| Execution-phase ≥ 80 gate | ≥ 80 | **PASS** (94) |

The polish round successfully crosses the PR gate with 4 points of margin. The submission gate (≥ 95) is 1 point away and is gated by the residual B1 hand-wave (deferred future work) and the stale qmd L629 first-sentence phrasing.

---

## Residual issues (R6)

1. **B1 — operator→iterate propagation hand-wave (deferred per theorist memo §9 item 2).** Field-standard accounting via Bauer-Hohage / Werner / Hofmann-Mathé citations is in place; a fully self-contained derivation (e.g., covering-number / chaining over $\{1, \ldots, M_n\}$) is out of scope for this paper. **Do not re-litigate.**
2. **Stale qmd L629 first sentence (NEW, minor).** "The constant $\tau_0$ above is the theoretical analogue of the $\tau$-parameter that we calibrate empirically in @sec-mcsim; the value $\tau \in [3, 6]$ used there is in line with the Mathé-Pereverzev range, with $\tau \to \infty$ producing a too-conservative early stop and $\tau \to 1$ producing under-regularization." The phrase "the value $\tau \in [3, 6]$ used there" is stale — the actual finite-$n$ recommendation in `sec-mc-tau` and `rem:tau-bandwidth` is $\tau \in \{1, 2\}$, with $\tau = 4$ as the asymptotic-conservative default. The appended bridge (Edit 3) partly reconciles this, but the un-corrected first sentence reads as if the simulations use $\tau \in [3, 6]$. A one-line edit to either drop "the value $\tau \in [3, 6]$ used there is in line with" or rephrase as "the empirical guidance at moderate $n$ — $\tau \in \{1, 2\}$ — sits in the lower half of the Mathé-Pereverzev range $\tau \in [3, 6]$" would close this. **Worth +1 toward submission gate.**

---

## Recommendation

**Status: CLEAR for Commit (≥ 80) and PR (≥ 90).** The polish round delivered the five expected single-line edits cleanly: all R5 residual items (Edits 1–5) close at the line ranges and file sites specified by the brief; no regressions on the R5 grep checks; the cross-form Form A / Form B alignment on F2 scope, $M_n$ growth, $\tau$-recommendation, and absorption-site cross-cite is now substantively closed.

**One additional polish edit would clear the submission gate (≥ 95).** The stale "$\tau \in [3, 6]$ used there" in qmd L629 first sentence is a single-line fix that would close the last 1-point gap. Combined with the deferred B1 hand-wave (worth -3 indefinitely, by the brief's "deferred future work" classification), the realistic submission ceiling on this artifact is 96–97 — i.e., one more polish edit clears the submission gate with margin.

**Do not** attempt to address B1 in the current round — the brief is explicit that this is deferred future work.
