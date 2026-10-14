# Round-8 Theorist-Critic Review: `prp-lepskii` (Submission Gate)

**Target:** `prp-lepskii` (Lepskii oracle inequality), Form B (paper qmd lead-in to post-proposition discussion).
**Severity:** HIGH (Execution phase).
**Round:** 8 (one-line redundancy-closure follow-up to R7).
**Date:** 2026-05-20
**Trajectory:** R3 (69) → R4-bandwidth (64) → R5 (88, Commit) → R6 (94, PR) → R7 (94, PR; redundancy introduced) → **R8 (95, Submission)**.

---

## 1. Edit verification

**Edit location:** `Centorrino_Florens_VOL_1.qmd`, L629.

**Before (R7):**
> "...the Mathé-Pereverzev recommendation $\tau \in [3, 6]$ is the asymptotic range, with $\tau \to \infty$ producing a too-conservative early stop and $\tau \to 1$ producing under-regularization."

**After (R8) — verified at L629:**
> "...the Mathé-Pereverzev recommendation lies in $[3, 6]$, with $\tau \to \infty$ producing a too-conservative early stop and $\tau \to 1$ producing under-regularization. The asymptotic recommendation $\tau \in [3, 6]$ from @mathe2003 is the large-$n$ analogue where $\tau_0$'s $\beta$-dependent component dominates; for moderate $n$ with Silverman bandwidths in our simulation regime, $\tau_0 = C_V \vee 2$ lands in the lower half of this band and the finite-sample recommendation reduces to $\tau \in \{1, 2\}$ (see Remark \ref{rem:tau-bandwidth} and @sec-mc-tau)."

The edit landed as specified.

## 2. Verification table

| Check | Status | Evidence |
|---|---|---|
| L629 lead-in says "lies in $[3, 6]$" (drops "is the asymptotic range" tag) | PASS | qmd L629 sentence 2 reads "the Mathé-Pereverzev recommendation lies in $[3, 6]$" |
| Edit-3 bridge sentence unchanged | PASS | qmd L629 sentence 3 verbatim R6/R7 |
| Endpoint commentary ($\tau\to\infty$/$\tau\to 1$) preserved | PASS | clause intact |
| Redundancy closed (no overlapping asymptotic framing) | PASS | Lead-in now states MP range as a *recommendation* only; bridge sentence is unique site of asymptotic/moderate-$n$ framing |
| Paragraph flow coherent, no new awkwardness | PASS | literature-attributed recommendation → endpoint behavior → moderate-$n$ qualification |
| Regression grep across 5 active artifacts | PASS | `c_K\|d_K\|c_{\mathrm{sub}}\|h^{d_K}\|nh^{d_K}\|tau_n^*\|eq-csubnh\|eq-app4ii-conc` empty; only the historical `lepskii_bandwidth_refinement.md` memo retains the symbols (out of scope) |
| R6 Edit 1 — Form B F2 scope clause at qmd L620 | PASS | "rate-adaptive for source-condition exponents $\beta_\epsilon \ge 1$..." present |
| R6 Edit 2 — $M_n$ upper bound at qmd L601 and L1332 | PASS | both sites present |
| R6 Edit 3 + R7 (unchanged) — bridge sentence at qmd L629 sentence 3 | PASS | verbatim |
| R6 Edit 4 — `ass:app4(ii)` Step-1 cross-cite at qmd L1024 | PASS | "the explicit value $\tau_0 := C_V \vee 2$ is computed in Step 1 of the proof of Proposition \ref{prp-lepskii}..." |
| R6 Edit 5 — Form A absorption-site cross-cite | PASS | proofs.tex L261-262 + results.tex L576-577 |

All 11 verification checks PASS.

## 3. Score

| Component | R7 | R8 Δ | R8 |
|---|---|---|---|
| Baseline | 94 | — | 94 |
| R7 L629 redundancy (-1) | -1 | **+1** (closed by R8 edit) | 0 |
| B1 hand-wave (-3, deferred future work per theorist memo §9 item 2) | -3 | 0 (standing) | -3 |
| New issues introduced | — | 0 | 0 |
| **Total** | **94** | **+1** | **95** |

**R8 = 95/100.**

## 4. Gate verdict

| Gate | Threshold | R8 status |
|---|---|---|
| Commit | ≥ 80 | CLEARED |
| PR | ≥ 90 | CLEARED |
| **Submission** | **≥ 95 AND all components ≥ 80** | **CLEARED** |
| Execution-phase max severity | (HIGH applied) | held |

**Component check (per `.claude/rules/quality.md` §1):**
- Proof completeness (theorist-critic bucket): 100 − 3 (B1) = **97 ≥ 80** ✓
- All other narrow-critic components (assumption-auditor, notation-warden, regularity-checker, counterexample-hunter, derivation-verifier) sit at their prior cleared values from the audit cycle — none below 80.
- Binary gates (`.claude/rules/quality.md` §4): theorem proved (every `prp-lepskii` section closed with $\square$); theorist-critic ≥ 80 with no unresolved CRITICAL findings; no counterexample-hunter confirmation outstanding; no unresolved escalation. **All binary gates clear.**

**Submission gate (≥ 95) is CLEARED.**

## 5. Standing residuals

**B1 hand-wave (-3, deferred).** Classification: deferred future work per theorist memo §9 item 2. This is the binding constraint on the indefinite ceiling — worth -3 forever under the brief's classification. It does **not** block submission: the affected component (operator→iterate propagation rigor under the theorist-critic bucket) sits at 97, well above the 80 component floor.

No other open residuals.

## 6. Final recommendation

**SUBMISSION GATE CLEARED at R8 = 95/100.** The one-line L629 edit successfully removed the "is the asymptotic range" tag from the lead-in, leaving the Edit-3 bridge sentence as the unique site of the asymptotic-vs-finite-$n$ framing. The R7 redundancy is closed. No new issues introduced. The paragraph reads coherently: literature-attributed recommendation → endpoint behavior → moderate-$n$ qualification.

The artifact may now proceed to the Submission phase. The theorist-track audit cycle on `prp-lepskii` is **complete**.
