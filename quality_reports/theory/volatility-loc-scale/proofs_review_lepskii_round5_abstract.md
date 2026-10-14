# Round-5 Theorist-Critic Review: `prp-lepskii` (Abstract-Form Revert)

**Target:** `prp-lepskii` (Lepskii oracle inequality), both Form A (audit artifact) and Form B (paper qmd).
**Severity:** HIGH (Execution phase).
**Date:** 2026-05-20.
**Round:** 5 (this audit; post-revert from R7 bandwidth-explicit to the abstract sub-exponential form).
**Trajectory:** R3 = 69 (terminal halt) → R4-bandwidth = 64/100 (R7 hand-waved bandwidth-explicit form) → **R5 = 88/100**.

The R7 form had bandwidth dependence quantitatively visible in the Bernstein exponent ($\exp(-c_K n h^{d_K}\tau^2)$) but was empirically vacuous at $n = 500$ and propagated multiple hand-waves in the operator-to-iterate inheritance. The user-directed revert pulls the bandwidth dependence out of the exponent (routing it entirely through the rates $\delta_n, \gamma_n, \kappa_n$ that scale $V(m)$) and replaces the load-bearing hand-wave with an honest reference to the standard inverse-problem accounting. Below, I verify the 8 grep checks, score the punch-list items B1–B5 and the R3 carryovers F2/F3/F5, evaluate operator-agnosticism, and produce a final score.

---

## Phase 0 — Verification grep table (8 checks)

| # | Check | Files | Verdict |
|---|---|---|---|
| 1 | `c_K, d_K, c_{\mathrm{sub}}, c_sub, h^{d_K}, nh^{d_K}, tau_n^*, eq-csubnh, eq-app4ii-conc` absent from all five active files | proofs.tex, results.tex, assumptions.tex, notation_glossary.md, qmd | **PASS** (5/5 grep returns empty) |
| 2 | `tau_0 := C_V \vee 2` in proofs.tex, results.tex, qmd Step 1, notation_glossary.md | All four | **PASS** (proofs.tex L211, results.tex L516, qmd L1323, glossary L48; consistent text) |
| 3 | `ass:frediff(ii)` discloses $\kappa_n^{-1}$-dependence of $L'_{\mathsf T}$ | assumptions.tex | **PASS** (L54–64: `L'_{\mathsf T} = L'_{\mathsf T}(R^\sigma, M_1, M_2, M_3, \kappa_n^{-1}, \text{kernel-envelope})`, $\kappa_n^{-1}$-factor explained as entering through Hessian along the $f_U^{-1}$-direction, with explicit absorption check $\kappa_n^{-1}\delta_n^{2}M_n^{2}V(M_n)^{2} = o(1)$) |
| 4 | `ass:iterbd` one-line derivation remark | assumptions.tex | **PASS** (L210–214: "Under `ass:rateconv`(i) at $l_0 \ge 4$ and `ass:unifbd`, the $L^4$ envelope $C_4$ is finite and bandwidth-free; the assumption packages the resulting uniform bound without re-deriving the chain.") |
| 5 | `rem:hyper` cites Vershynin 2018 Theorem 2.5.2, NOT Hanson 1971 | assumptions.tex | **PASS** (L119 cites `\citet[Theorem~2.5.2]{vershynin2018}`; no `hanson1971` or `Hanson` anywhere) |
| 6 | Hansen 2008 cited as Theorem 6 uniformly | proofs.tex, results.tex, assumptions.tex | **PASS** (proofs.tex L94, L111, L126 — all `Theorem~6`; results.tex L344, L371, L780 — all `Theorem~6`; assumptions.tex L113 `Theorem~6`. No `Theorem 2` for Hansen 2008 anywhere active.) |
| 7 | Scope reminder `(cf. Remark~\ref{rem:scope})` in proposition statement (Form A) | results.tex | **PASS** (L221: `(cf.\ Remark~\ref{rem:scope}). % PATCH-R4-F2: scope clause at statement level.`) — Form B's statement (qmd L614–620) does NOT have an equivalent clause; see Phase 2 below. |
| 8 | $III_m$ $\tau^2$-bookkeeping displayed | proofs.tex, results.tex | **PASS** (proofs.tex L140–148, results.tex L428–436 — both display "Since $\|III_m\| \le C\hat M\tau^{2}V(m)^{2}\sqrt m$ scales as $\tau^{2}$, the per-$m$ Bernstein constant $c_0$ in (eq:bernstein) retains the $\tau^{2}$-scaling when $III_m$ is absorbed — i.e., the displayed exponent $\exp(-c_0\tau^{2})$ is the *post-absorption* constant ...; the $\sqrt{\log M_n}$ adaptation overhead from the calibration $\tau_n = \sqrt{(1+\kappa)c_0^{-1}\log M_n}$ is unchanged.") |

**All 8 checks pass.** No grep-level regressions.

---

## Phase 1 — Per-axis substantive scoring

### B1 — Operator→iterate propagation (the load-bearing step)

**Verdict.** Honest framing is now in place in both forms.

**Form A** (proofs.tex L156–174; results.tex L451–469): The "Combining" block now reads, "Specifically, there exist constants $c_0 > 0$ and $\tau_0 \ge 1$ — bandwidth-free, depending only on $(c_1, c_2, c_3, \hat M)$ and the constants $R^\sigma, M_1, M_2, M_3, m_4$ of Assumption~\ref{ass:unifbd} together with the LF qualification — such that for each $m \le M_n$ and every $\tau \ge \tau_0$ ... The bandwidth dependence enters this bound *only through the rates $\delta_n, \gamma_n$ scaling $V(m)$*, not through the exponent. The inheritance of a single sub-exponential exponent across the four-term decomposition follows the standard inverse-problem-with-noisy-operator accounting of \citet[Section~2]{bauerhohage2005}, \citet[Section~4]{werner2015}, and \citet[Section~3]{hofmannmathe2007}, packaged as the per-iterate concentration $c_0$ above."

This is the honest framing the brief specified: bandwidth-free constants are *declared* on a transparent input list, and the propagation is attributed *with section-level citations* to the field's standard inverse-problem accounting — not pretended-derived. The four-term decomposition (Terms $II_m$, $IV_m$, $III_m$, $I_m$) is now displayed *before* the combining block, with per-term tail bounds (eq:II-tail-pf, eq:IV-tail-pf) plus the deterministic bound on $III_m$ now $\tau^2$-bookkept (see R3-F5 below). The hand-wave is at one specific load-bearing step: the inheritance of a *single* exponent by the *sum*, which the accounting citations cover.

**Form B** (qmd L1024–1029): The same framing is in `ass:app4(ii)` as a stated assumption. The derivation paragraph is more compact than Form A's combining block but cites the same Bauer-Hohage / Werner / Hofmann-Mathé chain. One borderline phrasing: "After normalization by $V(m)$, the kernel-localization scale cancels with the $\sqrt m$ accumulation from the LF spectral filter ... leaving the bandwidth-free exponent $\exp(-c_0\tau^2)$ displayed above." This is correct under the absorption logic, but a reader might want to see the cancellation displayed; the brief's intent (treat as a stated assumption with a derivation sketch) is satisfied.

**Severity:** MAJOR → reduced to MINOR (the load-bearing hand-wave is now visibly hand-waved, with proper attribution).
**Deduction:** **-3** (down from R4-bandwidth's -15; the field-standard hand-wave at the upper edge of acceptable is now honestly framed).

### B3 — $\tau_0 = C_V \vee 2$, $\beta$-dependent but bandwidth-free

**Verdict.** Cleanly addressed across all four sites.

**Form A.** proofs.tex L209–219 and results.tex L514–524 both display: "$\tau_0 := C_V \vee 2$ and $C_V := \sup_{1 \le m \le M_n - 1}\tilde V(m+1)/\tilde V(m) < \infty$ is a $\beta$-dependent but *bandwidth-free* constant. Direct calculation: $\sqrt{(m+1)/m} \le \sqrt 2$, $((m+1)/m)^{(1-\beta)/2} \le 2^{((1-\beta)/2)\vee 0}$, and $\ln(m+1)/\ln m \to 1$ for the $\beta = 2$ log factor; ratios of $\tilde V$ inherit the same uniform bound via the running-maximum construction. The constants $c_v, c'_v$ from Lemma~\ref{lem:itervar} cancel in $\tilde V(m+1)/\tilde V(m)$."

The cancellation of $c_v, c'_v$ in the ratio — the load-bearing fact that makes $C_V$ bandwidth-free — is now explicit. The $\beta$-dependence is acknowledged.

**Form B.** qmd L1323 displays the same derivation (with the variant phrasing "the constants $c_v, c'_v$ from @lem-itervar cancel in the ratio"). Consistent.

**notation_glossary.md** L48 ("$\tau_0$: Bandwidth-free threshold $\tau_0 = C_V \vee 2$ where $C_V := \sup_m \tilde V(m+1)/\tilde V(m)$ depends on $\beta$ but not on the bandwidth (PATCH-R4-B3)") and L49 ($C_V$ entry added) both match.

**Deduction:** **0** (down from R4-bandwidth's -8; fully addressed).

### B4 — `ass:iterbd` $C_4$ bandwidth-freeness one-liner

**Verdict.** Addressed (assumptions.tex L210–214). One-line remark added as specified. The phrasing acknowledges the chain `ass:rateconv(i)` at $l_0 \ge 4$ + `ass:unifbd` → $L^4$ envelope $C_4$ finite, bandwidth-free, without re-deriving.

**Deduction:** **0** (down from R4-bandwidth's -2; addressed).

### B5 — `ass:frediff`(ii) $L'_{\mathsf T}$ $\kappa_n^{-1}$-dependence

**Verdict.** Genuinely disclosed (assumptions.tex L54–64). The explicit dependence list `L'_{\mathsf T} = L'_{\mathsf T}(R^\sigma, M_1, M_2, M_3, \kappa_n^{-1}, \text{kernel-envelope})` is displayed; the $\kappa_n^{-1}$-factor is explained ("enters through the Hessian of $\hat{\mathsf T}'^{*}_{b}\hat{\mathsf T}'_{b}$ along the $f_U^{-1}$-direction"); the absorption check $\kappa_n^{-1}\delta_n^{2}M_n^{2}V(M_n)^{2} = o(1)$ is exhibited. Not a vague "depends on the kernel" — this is a substantive disclosure with the absorption logic load-bearing on `ass:restrvarth`.

One observation: the absorption check $\kappa_n^{-1}\delta_n^{2}M_n^{2}V(M_n)^{2} = \kappa_n^{-1}\delta_n^{2}\cdot\delta_n^{-2}\cdot\delta_n = \kappa_n^{-1}\delta_n$ requires $\kappa_n^{-1}\delta_n = o(1)$ at $m = M_n$. From `ass:app4`, $\kappa_n^{-1} = o(n^c)$ for some $c > 0$; this is a side condition implicit in `ass:restrvarth` but not displayed at the absorption site. The Form A assumptions block does the work but a one-line cross-reference at the absorption display in proofs.tex/results.tex would tighten this. MINOR.

**Deduction:** **-1** (down from R4-bandwidth's -7; substantively disclosed, with a one-line tightening still desirable).

### R3 F2 — Scope clause in proposition statement

**Verdict.** Addressed in Form A (results.tex L218–221), NOT in Form B.

**Form A** results.tex L218–221: "The bound is *rate-adaptive* for source-condition exponents $\beta_\epsilon \ge 1$; for $\beta_\epsilon < 1$ the realised rate becomes $V(M_n)$, strictly slower than the unconstrained oracle (cf.\ Remark~\ref{rem:scope}). % PATCH-R4-F2: scope clause at statement level."

**Form B** qmd L614–620: the proposition statement has no scope-restriction clause. The data-driven $\tau_n$ overhead carries some of the same scope information *implicitly* (M_n grows polynomially in n in the rate-adaptive regime), but a parenthetical "(rate-adaptive for $\beta_\epsilon \ge 1$; for $\beta_\epsilon < 1$ the realised rate becomes $V(M_n)$)" would close the gap. The two forms are *not aligned* on this point.

The revert memo (Section 3, R3 carryovers) acknowledges this: "Form B's statement, in the new abstract form, was rewritten per the brief; the F2 carryover is implicit in that the brief's specified replacement language does not include a scope clause." The theorist's reading is defensible (the brief said "Keep the qualitative connection ... between the empirical optimum at $\tau \in \{1, 2\}$ and $\tau_0$ landing in the lower Mathé-Pereverzev band") but Form A's explicit scope clause sets a higher bar that Form B does not meet.

**Deduction:** **-3** (down from R4-bandwidth's carryover of -3, now MAJOR-but-isolated-to-Form-B).

### R3 F3 — Vershynin 2018 vs Hanson 1971

**Verdict.** Addressed. `rem:hyper` in assumptions.tex L119 cites `\citet[Theorem~2.5.2]{vershynin2018}`; `\citet[Ch.~2]{boucheron2013}` retained as supporting context. Hanson 1971 is gone (grep #5 confirms). Hansen 2008 cited as Theorem 6 in L113.

**Deduction:** **0** (down from R4-bandwidth's carryover of -3; addressed).

### R3 F5 — $\tau^2$-bookkeeping for $III_m$ absorption

**Verdict.** Addressed cleanly in both proofs.tex L140–148 and results.tex L428–436. The crucial observation — that $\|III_m\| \le C\hat M\tau^{2}V(m)^{2}\sqrt m$ scales as $\tau^{2}$, so the per-$m$ Bernstein constant $c_0$ in (eq:bernstein) retains $\tau^{2}$-scaling when $III_m$ is absorbed — is displayed. The post-absorption interpretation of $c_0$ is made explicit ("$c_0$ reflecting both the noise terms $II_m, IV_m$ and the deterministic term $III_m$"), and the $\sqrt{\log M_n}$ adaptation overhead is confirmed unchanged.

**Deduction:** **0** (down from R4-bandwidth's carryover of -2; addressed).

### MI/FI uniformity — operator-agnosticism

**Verdict.** Holds. With the bandwidth-explicit form gone, the proof now references only:
- `lem:itervar` (which is route-aware in its derivation but exposes a route-uniform $V(m)$);
- `ass:rateconv` (which encodes the route-specific $\delta_n, \gamma_n$ rates);
- the abstract per-iterate sub-exponential bound `eq:bernstein` (route-uniform);
- `ass:linkcond` and `ass:mn-growth` (route-uniform).

Neither $d_K$, nor the dimension of $W$, nor the route-specific kernel structure appears in the proof outside of `ass:rateconv` references. The proof's opening "The argument is operator-agnostic" claim (proofs.tex L11–18; results.tex L232–239) is now substantively defensible. Grep #1 confirms no $d_K$, $nh^{d_K}$, etc., anywhere.

**Form B**: same agnosticism. The proof at qmd L1305 says "we phrase it without route-specific notation" and the subsequent display references only `ass:rateconv`, `lem:itervar`, `ass:linkcond`. Consistent.

**Deduction:** **0** (no issue identified).

### `rem:tau-bandwidth` — tuning-calibration framing

**Verdict.** Successfully reframed (qmd L1340–1343). The bandwidth-explicit formula $\tau_n^*(h) := \sqrt{2\log M_n/(c_K nh^{d_K})}$ is gone; the new prose is tuning-calibration: "The constant $\tau_0$ in Proposition \ref{prp-lepskii} is the asymptotic floor for the Lepskii constant: any $\tau \ge \tau_0$ delivers the oracle inequality. In finite samples, the appropriate $\tau$ is determined by the union-bound calibration $\tau_n := \sqrt{(1+\kappa)c_0^{-1}\log M_n}$ with $\kappa > 0$ the inflation parameter, but the constants $c_0, \tau_0$ that fix the calibration are intrinsically tied to the kernel-Bernstein scale and the LF qualification — not directly tunable from data without case-by-case calibration."

The qualitative connection (empirical optimum at $\tau \in \{1, 2\}$ → $\tau_0$ in the lower half of the Mathé-Pereverzev band) is preserved. No vacuous arithmetic, no bandwidth-explicit formula.

**Deduction:** **0** (down from R4-bandwidth's -8; cleanly reframed).

### `sec-mc-tau` consistency (qmd L839–853)

**Verdict.** Cleaned up. The references to $\tau_n^*(h)$, $0.22\sqrt{2/c_K}$, $0.32/\sqrt{c_K}$ are gone (grep #1 confirms). L841: "Proposition @prp-lepskii's floor $\tau_0$ is the asymptotic-conservative default; at moderate $n$ with Silverman-type bandwidths, $\tau_0$ tends to sit in the lower half of the Mathé-Pereverzev band, motivating the sensitivity sweep." L853: "The empirical optimum at $\tau \in \{1, 2\}$ is consistent with the floor $\tau_0$ of Proposition @prp-lepskii landing in the lower half of the Mathé-Pereverzev band at moderate $n$ with Silverman-type bandwidths." The empirical guidance "use $\tau \in \{1, 2\}$ for moderate $n$" is preserved.

**Deduction:** **0** (addressed).

---

## Phase 2 — Cross-form consistency check

Three substantive cross-form items to flag:

1. **F2 scope clause asymmetry.** Form A's proposition statement (results.tex L218–221) has the explicit `(cf. Remark~\ref{rem:scope})` clause; Form B's statement (qmd L614–620) does not. The two forms communicate the scope restriction asymmetrically — Form B leaves it implicit in the rate-balance side conditions. Already scored under R3-F2 above (-3).

2. **$M_n$ growth: Form B says $M_n \asymp \delta_n^{-2/(\beta_\epsilon+1)}$; Form A says $M_n = O(\delta_n^{-1})$.** Form B qmd L601 and L1332 use the rate-optimal $M_n \asymp \delta_n^{-2/(\beta_\epsilon+1)}$ (this is the *oracle index order* in the rate-balance regime); Form A `ass:mn-growth` (assumptions.tex L222–228) insists on the tighter $M_n = O(\delta_n^{-1})$ (required for the quadratic-residual absorption in Step 3 — see results.tex L597–621). For $\beta_\epsilon = 1$, the two coincide; for $\beta_\epsilon = 2$, Form B's order $\delta_n^{-2/3}$ is *tighter* than Form A's $O(\delta_n^{-1})$ (so consistent); for $\beta_\epsilon < 1$, Form B's order exceeds $\delta_n^{-1}$ — but `rem:scope` restricts the rate-adaptive regime to $\beta_\epsilon \ge 1$, so the two are *consistent* in the regime of adaptation. The Form B language could be tightened by stating the *upper bound* explicitly (e.g., "$M_n \le c \cdot \delta_n^{-1}$ for some $c < \infty$, with $M_n \asymp \delta_n^{-2/(\beta_\epsilon+1)}$ in the rate-optimal regime"). MINOR cosmetic.

3. **Form B post-proposition discussion (qmd L629) recommends $\tau \in [3, 6]$** in line with the Mathé-Pereverzev range — while `rem:tau-bandwidth` and `sec-mc-tau` recommend $\tau \in \{1, 2\}$ for moderate $n$. The discussion paragraph is asymptotic-framed and the recommendation paragraphs are finite-$n$-framed; the framing distinction is implicit. A reader who skims would see two different recommendations. The theorist could insert a one-line bridge ("the asymptotic recommendation $\tau \in [3, 6]$ is the analogue at large $n$ where $\tau_0 = O(\sqrt{\log n})$ pulls the floor up; the finite-$n$ recommendation $\tau \in \{1, 2\}$ reflects $\tau_0 = C_V \vee 2$ at moderate $n$"). MINOR cosmetic.

**Deductions:** -1 for item 2 (cross-form $M_n$ order presentation), -1 for item 3 ($\tau$-recommendation tension). Item 1 already scored.

---

## Phase 3 — Regression check (R3 terminal findings)

| R3 issue | R4-bandwidth state | R5 state | Status |
|---|---|---|---|
| F1 — `lem:propagator` commutation claim | Replaced by quadratic-residual argument (R3-G2-c) — preserved | preserved | RESOLVED |
| F2 — Scope at proposition level | Lingering -3 carry | Form A addressed; Form B lingering | PARTIAL (Form B: -3 above) |
| F3 — `rem:hyper` Hanson 1971 vs Vershynin 2018 | -3 carry | Vershynin 2018 Thm 2.5.2 cited | RESOLVED |
| F5 — $III_m$ $\tau^2$-bookkeeping | -3 carry | Displayed in both files | RESOLVED |

R3 regression carry-overs: only F2 remains as a Form B–side issue (already counted above).

---

## Phase 4 — Polish

- **Notation glossary.** L48 (`tau_0`) and L49 (`C_V`) consistent with the proofs; L45 (`c_0`) consistent with the abstract Bernstein form. No `c_K`, `d_K`, `c_{\mathrm{sub}}` entries needed (all symbols dropped). Glossary is now in sync with the active artifact.
- **Hansen citation uniformity.** All three sites (proofs.tex, results.tex, assumptions.tex) cite Theorem 6. Consistent.
- **PATCH markers.** PATCH-R4-B1, R4-B3, R4-B4, R4-B5, R4-F2, R4-F5 markers all visible — good audit trail. These should be cleaned before submission (not deducted in this review; the markers are useful for the audit cycle).
- **Reference completeness.** `bauerhohage2005`, `werner2015`, `hofmannmathe2007` cited with section-level pin-cites at the load-bearing step. `vershynin2018` Theorem 2.5.2 cited in `rem:hyper`. All four references are real, on-target, and standard for the inverse-problem-with-noisy-operator literature.
- **Form B `\tau_n` defined twice slightly differently.** In the abstract `ass:app4(ii)` (L1024), $\tau_0 \ge 1$ is described as "depending only on the LF step size $c$, on $R^\sigma$ and $M_1, M_2, M_3, m_4$ from Assumption \ref{ass:unifbd}, on the LF qualification, and on the Bernstein constants of the operator concentration in Assumption \ref{ass:rateconv}." In Step 1 of the proof (qmd L1323), $\tau_0 := C_V \vee 2$. The two descriptions are consistent (the second is the *value* of the floor; the first is its *dependence list*), but the connection could be made explicit by noting in `ass:app4(ii)` that $\tau_0 = C_V \vee 2$ from the successive-ratio bookkeeping in the proof. MINOR cosmetic.

Phase 4 deductions: **-1** (minor cosmetic items, not blocking).

---

## Scoring

| Item | Severity | Deduction |
|---|---|---|
| B1 — Operator→iterate propagation (now honestly framed with field-standard citations) | MINOR | -3 |
| B3 — $\tau_0 = C_V \vee 2$ (addressed across all sites) | — | 0 |
| B4 — `ass:iterbd` one-liner (addressed) | — | 0 |
| B5 — `ass:frediff`(ii) $\kappa_n^{-1}$-disclosure (substantively addressed; one-line tightening desirable) | MINOR | -1 |
| R3 F2 — Scope clause: Form A addressed, Form B lingering | MAJOR (Form-B-isolated) | -3 |
| R3 F3 — Vershynin 2018 cite (addressed) | — | 0 |
| R3 F5 — $III_m$ $\tau^2$-bookkeeping (displayed) | — | 0 |
| MI/FI operator-agnosticism (proof references no route-specific structure) | — | 0 |
| `rem:tau-bandwidth` tuning-calibration framing (cleanly reframed) | — | 0 |
| `sec-mc-tau` consistency (cleaned up) | — | 0 |
| Cross-form $M_n$ growth (Form A vs Form B order presentation) | MINOR | -1 |
| Cross-form $\tau$-recommendation tension ($\tau \in [3,6]$ vs $\tau \in \{1,2\}$) | MINOR | -1 |
| Phase 4 polish (Form B `ass:app4(ii)` does not cross-cite Step-1 value of $\tau_0$) | MINOR | -1 |
| **Total deductions** | | **-10** |
| **Final score: 88/100** | | |

The score sits 8 points above the Execution-phase ≥80 gate and 2 points below the PR ≥90 gate. The 88 reflects:
- **Substantive progress**: every B1–B5 item from R4-bandwidth, every R3 carry-over (F2/F3/F5), and the B6 / `rem:tau-bandwidth` / `sec-mc-tau` cluster is addressed. The bandwidth dependence has been pulled out of the exponent and placed honestly in the rates that scale $V(m)$.
- **Residual issues**: (i) the load-bearing hand-wave at B1 is now visibly hand-waved with field-standard citations but not eliminated; (ii) Form A and Form B are not fully aligned on the F2 scope clause; (iii) three minor cosmetic items (cross-form $M_n$ language, $\tau$-recommendation tension, `ass:app4(ii)` cross-cite to Step 1).

---

## Gate verdict

| Gate | Threshold | Verdict |
|---|---|---|
| Commit | ≥ 80 | **PASS** (88) |
| PR | ≥ 90 | **FAIL** (88) — close but not crossed |
| Submission | ≥ 95 + all components ≥ 80 | **FAIL** (88) |
| Execution-phase ≥ 80 gate | ≥ 80 | **PASS** (88) |

The Execution-phase gate is now cleared with margin. The PR gate is 2 points away; closing that gap would require either (i) bringing Form B into full F2 alignment with Form A (worth +3) or (ii) tightening the three cosmetic items (worth +3 collectively).

---

## Residual issues

**Form B F2 scope clause.** Form B's `prp-lepskii` statement (qmd L614–620) should carry a parenthetical scope clause matching Form A's "(cf.\ Remark~\ref{rem:scope})." Currently Form B has no `rem:scope` equivalent; either port it from Form A or insert a parenthetical "(rate-adaptive for $\beta_\epsilon \ge 1$; for $\beta_\epsilon < 1$ the realised rate is $V(M_n)$)" directly into the statement.

**Form B $M_n$ growth presentation.** qmd L601 / L1332 use $M_n \asymp \delta_n^{-2/(\beta_\epsilon+1)}$ where Form A uses $M_n = O(\delta_n^{-1})$. The two are consistent in the rate-adaptive regime $\beta_\epsilon \ge 1$, but Form B should state the *upper bound* explicitly (e.g., "$M_n = O(\delta_n^{-1})$ — equivalently, $M_n \asymp \delta_n^{-2/(\beta_\epsilon+1)}$ in the rate-optimal regime of Corollary $X$ in the scope $\beta_\epsilon \ge 1$").

**Form B $\tau$-recommendation tension.** qmd L629 recommends $\tau \in [3, 6]$ in the discussion paragraph; `rem:tau-bandwidth` (L1342) and `sec-mc-tau` (L853) recommend $\tau \in \{1, 2\}$ for moderate $n$. A one-line bridge in L629 reconciling the asymptotic and finite-$n$ recommendations would close this.

**Form B `ass:app4(ii)` cross-cite.** The dependence list in `ass:app4(ii)` (qmd L1024) could note explicitly that $\tau_0 = C_V \vee 2$ from Step 1 of the proof, so the abstract description and the proof value are visibly the same object.

**B5 absorption-check cross-reference.** `ass:frediff`(ii) (assumptions.tex L62) displays the absorption check $\kappa_n^{-1}\delta_n^{2}M_n^{2}V(M_n)^{2} = o(1)$, but the absorption site in proofs.tex / results.tex (Step 3) does not cross-cite this disclosure. A `\ref{ass:frediff}\textup{(ii)}` next to the quadratic-residual absorption display would close the loop.

**B1 residual hand-wave (deferred future work).** The inheritance of a *single* sub-exponential exponent by the *sum* across the four-term decomposition is attributed to Bauer-Hohage / Werner / Hofmann-Mathé rather than self-contained-derived. A fully rigorous derivation (likely via a covering-number / chaining argument over $\{1, \ldots, M_n\}$) is out of scope per the brief and the theorist memo (Section 5, item 1). This is acceptable for the present round but is the natural target of a methods-track refinement.

---

## Recommendation

**Status: CLEAR for Commit (≥ 80). Worth one more polish round before PR (≥ 90).**

The R5 revert delivered the substantive content of the punch list. The four residual cosmetic items (Form B F2 scope clause, Form B $M_n$ growth wording, Form B $\tau$-recommendation tension, Form B `ass:app4(ii)` cross-cite to Step 1 value of $\tau_0$, plus the B5 absorption-site cross-reference) are all single-line edits that would lift the score above 90 without touching the proof's structure or invoking any new derivation.

**Do not** attempt a from-scratch covering-number derivation for B1 in the current round — the field-standard hand-wave is acceptable at this stage, and the prior R8/R9 attempts established that the formal-derivation route is structurally fragile. The user-directed revert was the right call and is correctly executed.

The architectural call is now stable: the abstract Bernstein form with bandwidth dependence routed through the rates $\delta_n, \gamma_n, \kappa_n$ is the honest accounting; the propagation citation is the field's standard. The remaining work is presentation polish, not theorem-level rewriting.
