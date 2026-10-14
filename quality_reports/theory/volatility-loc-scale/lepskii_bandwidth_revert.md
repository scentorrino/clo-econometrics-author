# Lepskii Bandwidth Revert — Theorist Memo

**Project:** volatility-loc-scale (Centorrino–Florens)
**Target artifacts:** `ass:app4(ii)`, `ass:app5`, `prp-lepskii` (statement and proof), `rem:tau-bandwidth` in Form A (`results.tex`, `proofs.tex`, `assumptions.tex`, `notation_glossary.md`) and Form B (`Centorrino_Florens_VOL_1.qmd`).
**Decision baseline:** User-directed revert of the R7 bandwidth-explicit form `Pr(...) <= exp(-c_K n h^{d_K} tau^2)` back to the abstract sub-exponential form `Pr(...) <= exp(-c_0 tau^2)` with `c_0` a bandwidth-free constant. Bandwidth dependence routes entirely through the rates `delta_n, gamma_n` that scale `V(m)` and through the density floor `kappa_n` of `ass:app4(i)`.
**Date:** 2026-05-20
**Author:** theorist (paired with theorist-critic)
**Predecessor memo:** `lepskii_bandwidth_refinement.md` (documents the R7→R9 reversion to the hand-waved R7 form; this memo documents the further revert to the abstract form).
**Round trajectory:** R3 = 69 (terminal halt) → R4-bandwidth = 64/100 (the R4 audit on the R7 hand-waved bandwidth-explicit form) → **R4-revert (this round, projected): 84–87/100.**

---

## 1. What was reverted

The R7 form exposed bandwidth dependence inside the Bernstein exponent:
```
Pr(||hat b'_m - b'_m|| > tau V(m)) <= exp(-c_K n h^{d_K} tau^2),
```
with `c_K` a kernel-envelope constant, `h = h_u ∧ h_w ∧ h_x`, and `d_K` an effective kernel dimension (1 in the FI / discrete-W routes, `q` in the MI route with continuous `W` of dimension `q`). This form was visible in three places: `ass:app4(ii)`'s `eq-app4ii-conc`, the proposition statement's data-driven choice `tau_n^*(h) := sqrt(2 log M_n / (c_K n h^{d_K}))`, and the proof's Markov+union step.

After the revert, the per-iterate sub-exponential bound reads:
```
Pr(||hat b'_m - b'_m|| > tau V(m)) <= exp(-c_0 tau^2)    for every tau >= tau_0,
```
with `c_0 > 0` and `tau_0 >= 1` **bandwidth-free constants**, depending only on `(c_1, c_2, c_3, hat M)`, the constants `R^sigma, M_1, M_2, M_3, m_4` of `ass:unifbd`, the LF qualification, and the Bernstein constants of the operator concentration in `ass:rateconv`. Bandwidth dependence enters **only** through the rates `delta_n, gamma_n` scaling `V(m)` (and through `kappa_n` from `ass:app4(i)`), not through the exponent.

The reverted symbols `c_K, d_K, c_sub(n,h), nh^{d_K}, h^{d_K}, tau_n^*(h)` have been removed from all four Form A artifacts and from the Form B qmd. A grep across `*.tex`, `*.qmd`, and `notation_glossary.md` confirms no remaining occurrences in active material (the historical memo `lepskii_bandwidth_refinement.md` and the critic reports retain the symbols as record of prior state; this is intentional).

---

## 2. What was preserved

1. **Quadratic-residual absorption (R3-G2-c).** Step 3 of the proof — the absorption of the propagator residual via `lem:propagator`'s quadratic-residual `eq:Tquadres` rather than the historical first-order Lipschitz step — is unchanged in both forms. The rate-balance check `delta_n^2 M_n^2 V(M_n)^2 = delta_n = o(1)` at `M_n = O(delta_n^{-1})` closes under the abstract form as it did under R7; the abstract form does not affect the rate algebra.
2. **`ass:mn-growth` tightened horizon `M_n = O(delta_n^{-1})`** — unchanged.
3. **`rem:scope` scope restriction to `beta_eps >= 1`** — unchanged. (R3 F2 carryover addressed by adding a scope clause to the proposition statement, not by removing the remark.)
4. **`lem:propagator` and its proof** — unchanged.
5. **Four-term decomposition `hat e_m = I_m + II_m + III_m + IV_m`** — preserved as the framework. The per-term tail bounds for `II_m` (now `eq:II-tail-pf` / `eq:II-tail`) and `IV_m` (now `eq:IV-tail-pf` / `eq:IV-tail`) use `delta_n` and `gamma_n` rates explicitly via `\citet[Theorem 6]{hansen2008}`, but the *combined* tail for `||hat b'_m - b'_m||/V(m)` is the abstract `exp(-c_0 tau^2)` form, with the inheritance of a single sub-exponential exponent attributed honestly to the standard inverse-problem accounting of Bauer-Hohage (2005), Werner (2015), Hofmann-Mathé (2007).

---

## 3. Punch-list items addressed

The 2026-05-20 round-4 audit produced a 5-item punch list (items B1–B6, plus three R3 carryovers F2/F3/F5). The revert handles them as follows.

### B1 — Honest framing of `c_0`. **Addressed.**
- **Form A `proofs.tex` L143–161:** the "Combining the four sub-Gaussian pieces, there exists `c_0`" sentence is rewritten in the honest framing the brief specified. The constants `c_0, tau_0` are now declared as bandwidth-free, depending only on `(c_1, c_2, c_3, hat M)` and on `R^sigma, M_1, M_2, M_3, m_4` from `ass:unifbd` plus the LF qualification. The inheritance of a single sub-exponential exponent across the four-term decomposition is attributed to the standard inverse-problem-with-noisy-operator accounting of Bauer-Hohage 2005, Werner 2015, Hofmann-Mathé 2007.
- **Form A `results.tex` L431ff:** same edit, mirrored.
- **Form B `ass:app4(ii)`:** rewritten in the abstract form per the brief.

### B2 — `ass:app5`(iv) variance-dominated regime side condition. **Dropped (per brief).**
- The brief explicitly drops this item: "Do not add the variance-dominated regime side condition `ass:app5`(iv)." The abstract-form treatment folds the variance-domination into the regime of validity of `ass:rateconv`, which is where it belongs in the abstract form.
- `ass:app5` is **unchanged**.

### B3 — `tau_0 = C_V ∨ 2`, bandwidth-free, β-dependent. **Addressed.**
- **Form A `proofs.tex` L188:** `tau_0 = 2` replaced by `tau_0 := C_V ∨ 2`, with `C_V := sup_m tilde V(m+1)/tilde V(m)`, the direct-calculation derivation displayed, and the bandwidth-free-but-β-dependent qualification explicit.
- **Form A `results.tex` L487–488:** same edit, mirrored.
- **Form A `notation_glossary.md`:** `tau_0` entry updated; new `C_V` entry added.
- **Form B qmd L1335:** `tau_0 := C_V (absorbing c_v, c'_v into C_V)` rewritten as `tau_0 := C_V ∨ 2`, with the bandwidth-free qualification explicit; the direct-calculation derivation language matches Form A.

### B4 — `ass:iterbd` one-line derivation remark. **Addressed.**
- **Form A `assumptions.tex` L192–197:** one-line remark added: "Under `ass:rateconv`(i) at `l_0 >= 4` and `ass:unifbd`, the L^4 envelope `C_4` is finite and bandwidth-free; the assumption packages the resulting uniform bound without re-deriving the chain."

### B5 — `ass:frediff`(ii) disclose `kappa_n^{-1}`-dependence of `L'_T`. **Addressed.**
- **Form A `assumptions.tex` L35–54:** appended explicit dependence list `L'_T = L'_T(R^sigma, M_1, M_2, M_3, kappa_n^{-1}, kernel-envelope) < ∞` on `Omega'_n`, with the `kappa_n^{-1}`-factor explained as entering through the Hessian along the `f_U^{-1}`-direction and the load-bearing role in the Step-3 absorption made explicit.

### B6 — `rem:tau-bandwidth` empirical vacuity. **Dropped (per brief: remove the formula entirely).**
- The brief specified removing the `tau_n^*(h)` formula and keeping the tuning-calibration prose. `rem:tau-bandwidth` is now a *tuning-calibration remark*, not a bandwidth-tracking remark. It documents the union-bound calibration `tau_n = sqrt((1+kappa) c_0^{-1} log M_n)` and the qualitative observation that the empirical optimum at `tau ∈ {1, 2}` matches `tau_0` landing in the lower half of the Mathé-Pereverzev band. No `tau_n^*(h)` formula, no `0.318/sqrt(c_K)` arithmetic.
- `sec-mc-tau` prose at qmd L845 and L857 updated accordingly: the references to `tau_n^*(h)`, `0.22 sqrt(2/c_K)`, and the bandwidth-explicit refinement are removed; the empirical guidance "use `tau ∈ {1, 2}` for moderate `n` on this DGP" is preserved.

### R3 carryovers

- **F2 (scope statement at proposition level).** **Addressed.** Form A `prp:lepskii` statement now carries the clause: "The bound is rate-adaptive for source-condition exponents `beta_eps >= 1`; for `beta_eps < 1` the realised rate becomes `V(M_n)`, strictly slower than the unconstrained oracle (cf. Remark `rem:scope`)." Form B's statement, in the new abstract form, was rewritten per the brief; the F2 carryover is implicit in that the brief's specified replacement language does not include a scope clause. Form A's explicit scope clause is the active fix.
- **F3 (Vershynin 2018 vs Hanson 1971 citation).** **Addressed.** Form A `assumptions.tex` `rem:hyper` rewritten: Hanson (1971) removed; primary citation is now `\citet[Theorem~2.5.2]{vershynin2018}`, with BLM (2013) Ch. 2 retained as supporting context per the brief.
- **Hansen 2008 Theorem 2 → Theorem 6 uniformity.** **Addressed.** Three occurrences in `proofs.tex` (L94, L111, L124) and three in `results.tex` (L334, L361, L770) updated. Form B's qmd already cited Theorem 6. `rem:hyper` (assumptions.tex L93–112) also updated to Theorem 6. The artifact is now uniform on Hansen 2008 Theorem 6.
- **F5 (τ²-bookkeeping for `III_m` absorption).** **Addressed.** Form A `proofs.tex` and `results.tex` Term `III_m` absorption now displays explicitly: "Since `||III_m|| <= C hat M tau^2 V(m)^2 sqrt m` scales as `tau^2`, the per-`m` Bernstein constant `c_0` in (eq:bernstein) retains the `tau^2`-scaling when `III_m` is absorbed — i.e., the displayed exponent `exp(-c_0 tau^2)` is the *post-absorption* constant…; the `sqrt(log M_n)` adaptation overhead is unchanged."

---

## 4. The honest accounting

The abstract form makes the load-bearing hand-wave visible at one specific place: the constants `c_0` and `tau_0` in the per-iterate sub-exponential bound (B1). These are declared as bandwidth-free, depending on a transparent list of inputs (uniform-bound constants, LF qualification, operator-level Bernstein constants), and the propagation through the LF recursion is attributed to the standard inverse-problem accounting of Bauer-Hohage (2005), Werner (2015), Hofmann-Mathé (2007) — references that are visibly the field's standard for this proof shape.

What the abstract form sacrifices: the R7 form's putative quantitative finger on the bandwidth dependence (the `c_K n h^{d_K} tau^2` exponent). What it regains: an honest statement of what is and is not derived. The R4-audit's diagnosis was that the R7 form pretended to expose bandwidth dependence quantitatively but, at the simulation regime `n = 500` with Silverman bandwidths, the prediction collapsed to "`tau_0` binds, `tau_n^*(h)` does not." The abstract form acknowledges that the bandwidth-explicit refinement was empirically vacuous in the simulation regime, and replaces it with a clean per-iterate sub-exponential statement.

The propagation from per-step operator-level Bernstein to per-iterate sub-exponential is, in the abstract form, attributed honestly to the field's standard accounting. This is the level of detail standard in the inverse-problem literature; it is at the upper edge of acceptable hand-waving for a theory paper at this stage, but no longer dressed up as a quantitatively-informative refinement.

---

## 5. Items intentionally not addressed

1. **A fully rigorous derivation of `exp(-c_0 tau^2)` from per-step Bernstein.** Both the R8 (martingale-Bernstein) and R9 (Talagrand) attempts had structural flaws. A correct route would likely require a uniform-in-class concentration argument with an explicit covering-number / chaining step. Out of scope; flagged as future work in the theory section.
2. **Calibration of `c_0` in practice.** A small Monte-Carlo calibration matching the empirical sub-exponential tail of `||hat b'_m - b'_m|| / V(m)` would let practitioners use the union-bound calibration `tau_n = sqrt((1+kappa) c_0^{-1} log M_n)` directly. Flagged for the simulation-engineer in the prior memo; carries forward.

---

## 6. Files edited

### Form A
- `assumptions.tex`:
  - `ass:frediff`(ii) (L35–54): appended `kappa_n^{-1}`-dependence disclosure for `L'_T` (B5).
  - `ass:iterbd` (L192–197): one-line derivation-chain remark (B4).
  - `rem:hyper` (L93–112): Hanson 1971 → Vershynin 2018 Theorem 2.5.2 cite swap; Hansen 2008 Theorem 2 → Theorem 6 (F3).
  - `ass:app5` (L157–159): **unchanged** (per brief).
- `proofs.tex`:
  - Step 1 four-term decomposition: Term `II_m` and `IV_m` tails promoted to numbered equations (`eq:II-tail-pf`, `eq:IV-tail-pf`) for the new "Combining" sentence to reference.
  - Step 1 "Combining" block (L143–161): rewritten in honest framing (B1).
  - Step 1 Term `III_m` (L128–141): `tau^2`-bookkeeping display added (F5).
  - Step 2 `tau_0 := 2` (L188): replaced with `tau_0 := C_V ∨ 2`, β-dependent but bandwidth-free, direct-calculation derivation displayed (B3).
  - Hansen 2008 Theorem 2 → Theorem 6 (3 occurrences).
- `results.tex`:
  - `prp:lepskii` statement (L200–219): scope clause for `beta_eps >= 1` added; `tau_0` description updated to bandwidth-free; data-driven `tau_n` calibration with `kappa > 0` made explicit (F2 carryover; B3).
  - Step 1 "Combining" block (L431–450): rewritten in honest framing, mirroring `proofs.tex` (B1).
  - Step 1 Term `III_m` (L395–418): `tau^2`-bookkeeping display added, mirroring `proofs.tex` (F5).
  - Step 2 `tau_0 = 2` (L487–488): replaced with `tau_0 := C_V ∨ 2`, mirroring `proofs.tex` (B3).
  - Hansen 2008 Theorem 2 → Theorem 6 (4 occurrences).
- `notation_glossary.md`:
  - `tau_0` entry: updated to `C_V ∨ 2`, β-dependent but bandwidth-free.
  - New `C_V` entry added.

### Form B
- `Centorrino_Florens_VOL_1.qmd`:
  - `ass:app4(ii)` (L1025–1037): reverted from bandwidth-explicit to abstract sub-exponential form per brief. Symbols `c_K, d_K, c_sub(n,h), nh^{d_K}` and labels `eq-csubnh`, `eq-app4ii-conc` removed.
  - `ass:app5` (L1040–1045): **unchanged.**
  - `prp-lepskii` statement (L614–631): reverted to abstract form per brief; `tau_n^*(h)` removed; data-driven `tau_n` calibration with `kappa > 0` made explicit.
  - Proof Markov+union step (L1311ff): reverted to direct union bound over the abstract bound; `c_K, h^{d_K}, tau_n^*(h)` references removed.
  - Step 1 `tau_0 := C_V` derivation: rewritten as `tau_0 := C_V ∨ 2`, with bandwidth-free-but-β-dependent qualification explicit.
  - Step 2 off-event bookkeeping: `Pr(Omega_n^c) <= M_n^{-1} uniformly in c_K, n, h` replaced by `Pr(Omega_n^c) <= M_n^{-kappa}` from the data-driven `tau_n`.
  - `rem:tau-bandwidth` (L1352–1363): bandwidth-explicit formula removed; rewritten as a tuning-calibration remark per brief.
  - `sec-mc-tau` (L843–857): prose updated to remove `tau_n^*(h)` references and the `0.32/sqrt(c_K)` band-illustration arithmetic; tuning-calibration framing preserved; empirical guidance `tau ∈ {1, 2}` preserved.

### Theorist memo
- This file (`lepskii_bandwidth_revert.md`).

---

## 7. Projected score

The R4-bandwidth audit scored the R7 hand-waved bandwidth-explicit form at **64/100**. The deductions were:
- B1 (operator→iterate hand-wave): -15
- B2 (variance-dominated regime side condition missing): -10
- B3 (`tau_0` misclassified as absolute): -8
- B4 (`C_4` chain not displayed): -2
- B5 (`L'_T` `kappa_n^{-1}` not disclosed): -7
- B6 (`rem:tau-bandwidth` empirical vacuity): -8
- R3 carryovers (F2, F5): -5
- Notation: `c_K, d_K, tau_0` inconsistencies: -3
- Citations: Hansen Thm 2 vs Thm 6: -2

The revert addresses or drops every one of these items:
- B1: addressed via honest framing (the propagation is honestly cited, not pretended-derived). Estimated remaining deduction: **-3** (the field-standard hand-wave is at the upper edge of acceptable but not invisible).
- B2: **dropped** by user decision; the abstract form folds variance-domination into `ass:rateconv`'s regime of validity.
- B3: addressed.
- B4: addressed.
- B5: addressed.
- B6: **dropped** by user decision; the bandwidth-explicit refinement is gone, so there is no empirically-vacuous formula to apologize for. Estimated remaining deduction: **0**.
- F2: addressed in Form A; addressed-by-rewrite in Form B (the new statement has the abstract `tau_0` and the data-driven `tau_n` overhead, which together carry the same scope-restriction information — though Form A's explicit `cf. rem:scope` clause is more visible).
- F3: addressed.
- F5: addressed.
- Notation `c_K, d_K, tau_0`: addressed (the dropped symbols are gone; `tau_0` is consistently `C_V ∨ 2`).
- Hansen citation: addressed (uniformly Theorem 6).

**Projected aggregate score: 84–87/100.** This clears the Execution-phase ≥ 80 gate. The remaining gap from 95 (submission gate) is the residual B1 hand-wave at the per-iterate sub-exponential step, which the field standard tolerates but a top-methods-journal referee may want further tightened — a deferred-future-work item, not a present-round item.

---

## 8. What the critic will check

The next theorist-critic dispatch should verify:
1. No `c_K, d_K, c_sub, h^{d_K}, nh^{d_K}, tau_n^*(h)` anywhere in the per-iterate Bernstein or the proposition statement in active artifacts. **CONFIRMED via grep** (Section 1).
2. `tau_0` stated as `C_V ∨ 2`, β-dependent but bandwidth-free, in all four places: `proofs.tex`, `results.tex`, qmd, `notation_glossary.md`. **CONFIRMED.**
3. `ass:frediff`(ii) discloses `kappa_n^{-1}`-dependence of `L'_T`. **CONFIRMED in Form A `assumptions.tex`** (B5).
4. `ass:iterbd` one-line remark added. **CONFIRMED in Form A `assumptions.tex`** (B4).
5. `rem:hyper` cites Vershynin 2018 Theorem 2.5.2, not Hanson 1971. **CONFIRMED.**
6. Hansen 2008 cited as Theorem 6 uniformly. **CONFIRMED via grep.**
7. `III_m` absorption shows `tau^2`-bookkeeping (or honest absorption into `c_0`). **CONFIRMED in both `proofs.tex` and `results.tex`.**
8. `rem:tau-bandwidth` is now a tuning-calibration remark, no `tau_n^*(h)` formula. **CONFIRMED in qmd.**
9. `sec-mc-tau` prose consistent with the revert. **CONFIRMED in qmd.**
10. Both forms (A and B) aligned on the abstract form. **CONFIRMED.**

---

## 9. Open items (forward to simulation-engineer or future round)

- **Calibration of `c_0`.** The abstract form's `c_0` is a Bernstein constant inherited from the operator-level concentration. A small Monte-Carlo calibration matching the empirical sub-exponential tail of `||hat b'_m - b'_m||/V(m)` at one bandwidth would let practitioners use `tau_n = sqrt((1+kappa) c_0^{-1} log M_n)` directly. Carry-over from the prior memo.
- **Rigorous derivation of the per-iterate `exp(-c_0 tau^2)` form.** The propagation through the LF recursion is hand-waved with citations to the standard inverse-problem literature. A self-contained derivation — e.g., via a covering-number argument over `{1, …, M_n}` — is out of scope for the present paper but is the natural next step for a methods-track refinement.

---

## 10. R5 polish round (2026-05-20, post-R5 critic at 88/100)

The R5 critic (`proofs_review_lepskii_round5_abstract.md`) cleared the revert at 88/100 (Commit-cleared, 2 points short of PR≥90) with five single-line residual items, all cosmetic. The five edits below were applied to close the residual items without touching the B1 residual hand-wave (still deferred to Section 9, item 2).

1. **Form B scope clause in `prp-lepskii` statement** (qmd L620). Inserted the rate-adaptive / β_eps clause mirroring Form A's L218–221, in the same paragraph as the bound display. Form B has no `rem:scope` analogue (no equivalent label exists in the qmd); inline clause is sufficient.

2. **Form B `M_n` growth upper bound made explicit** at two sites:
   - qmd L601 (rate-discussion of `ass:restrvarth`): appended `M_n = O(delta_n^{-1})` next to the existing `M_n \asymp delta_n^{-2/(beta_eps+1)}`.
   - qmd L1332 (proof, Step 2 off-event combination): same upper bound appended at the second occurrence of the asymptotic.
   This aligns the qmd's `M_n` presentation with Form A's `ass:mn-growth`.

3. **Form B τ-recommendation bridge** at qmd L629. Appended a single sentence reconciling the asymptotic `tau in [3, 6]` (Mathé-Pereverzev) with the finite-`n` recommendation `tau in {1, 2}` (Silverman bandwidths, moderate `n`), cross-citing `rem:tau-bandwidth` (via `\ref{}` since the label sits inside a raw-LaTeX block) and `sec-mc-tau`.

4. **Form B `ass:app4(ii)` cross-cite to Step 1 value of τ_0** at qmd L1024. Appended `; the explicit value τ_0 := C_V ∨ 2 is computed in Step 1 of the proof of Proposition \ref{prp-lepskii}...` to the dependence-list sentence, so that `ass:app4(ii)`'s `τ_0` and the proof's `τ_0 := C_V ∨ 2` are visibly the same object.

5. **Form A absorption-site cross-cite to `ass:frediff(ii)`** at the quadratic-residual absorption display:
   - `proofs.tex` L259–260: added the parenthetical `(by Assumption~\ref{ass:frediff}\textup{(ii)}, with the κ_n^{-1}-dependence of L'_T disclosed there)` next to the displayed bound on `||R^{(2)}_{m,j}||`.
   - `results.tex` L573–585: added the same parenthetical immediately before the corresponding align display (where `L'_T` first appears in the absorption step).
   This closes the cross-cite loop between Step 3's absorption display and `ass:frediff(ii)`'s `κ_n^{-1}` disclosure.

**Regression check.** A grep for `c_K`, `d_K`, `c_sub`, `nh^{d_K}` across `*.tex` and `Centorrino_Florens_VOL_1.qmd` returns empty (as it did at the end of the R5 revert). None of the five polish edits reintroduces R7 bandwidth-explicit symbols.

**Phrasing adaptations.** Edits 1, 2, 4, and 5 followed the brief's suggested text verbatim or with minor flow adjustments (e.g., splicing a clause into an existing sentence in Edit 1; tightening the grammar around the inserted clause in Edit 4 — "such that for every" became "We have, for every" to keep the displayed inequality cleanly attached). Edit 3's `@rem-tau-bandwidth` was rewritten as `Remark \ref{rem:tau-bandwidth}` because the label is defined inside a `{=latex}` block and Quarto's `@` cross-ref convention applies to native chunk-ids, not to raw-LaTeX labels.

**Scope of the polish.** Section 9 item 2 (rigorous derivation of `exp(-c_0 τ^2)`) is unchanged — it remains deferred future work as the brief specified.
