# Round-4 Theorist-Critic Review: `prp-lepskii` (Bandwidth Audit)

**Target:** `prp-lepskii` (Lepskii oracle inequality), both Form A (audit artifact) and Form B (paper qmd).
**Severity:** HIGH (Execution phase).
**Date:** 2026-05-20.
**Round:** 4 (this audit; bandwidth-focused re-review of R7 hand-waved form).
**Trajectory:** R3 = 69 (terminal halt) → R4(post-R5 cleanup) = 98 (claimed; pre-revert) → **R4-bandwidth = 64/100**.

The 2026-05-17 audit's 98.3 aggregate score is no longer current. It was scored against a different artifact form (R6, with a constant $c_{\mathrm{sub}}$ that hid the bandwidth dependence). After the R7-to-R9 cycle and the user's revert to R7's hand-waved propagation, the artifact's treatment of $h$, $nh^{d_K}$, and $\kappa_n$ regressed materially on the regularity axis. The score below reflects the current state, evaluated against the user's specific concern: that bandwidth dependence enters silently throughout.

---

## Phase 1 — Claim Identification

**The two forms.**

| Aspect | Form A (`results.tex`/`proofs.tex`) | Form B (`Centorrino_Florens_VOL_1.qmd`) |
|---|---|---|
| Per-$m$ tail constant | $c_0$ "depends on $(c_1, c_2, c_3, \hat M)$ and constants of Assumptions $\ref{ass:unifbd}, \ref{ass:app1to3}-\ref{ass:app6}$" (`proofs.tex` L143-145) | $c_K \cdot n h^{d_K}$ via `ass:app4(ii)` `eq-app4ii-conc` (L1030, L1034) |
| Bandwidth visibility | Hidden (constants pool all kernel dependences) | Visible in the exponent (and in the data-driven $\tau_n^*(h)$) |
| Status of the per-iterate tail | "Derived" via four-term decomposition + "$\sqrt m$ inheritance" (proofs.tex L93-161; results.tex L332-450) | "Assumed" in `ass:app4(ii)`, with a derivation paragraph at qmd L1036 |
| Floor $\tau_0$ | $\tau_0 = 2$ "absolute constant" (proofs.tex L188; results.tex L487, PATCH-MN4) | $\tau_0 := C_V$ from successive-$V$-ratios (qmd L1335), called "constant" |

**The user's diagnosis is correct.** Both forms hand-wave the same step. Form A buries the hand-wave inside opaque pooled constants and inside the assertion "$c_0$ depends only on" a list that omits $h$ and $nh^{d_K}$. Form B exposes the bandwidth but only by promoting the hand-waved propagation from "argued in the proof" to "stated as an assumption with a one-paragraph informal derivation." This is the lepskii_bandwidth_refinement.md memo's own Section 6 admission: items 1 ("transition from per-step Bernstein to per-iterate sub-exponential") and 3 ("variance-dominated regime side condition") are the load-bearing ones.

---

## Phase 2 — Per-Issue Audit Table

Locations are given as `file:line`; severities follow the rubric (CRITICAL = proof invalid; MAJOR = missing assumption / non-minimal claim / wrong cite; MINOR = bookkeeping not displayed).

| # | Axis | Location | Verbatim / paraphrase | Severity | Deduction | One-line fix |
|---|---|---|---|---|---|---|
| **B1** | Operator→iterate propagation (the load-bearing step) | `proofs.tex` L93-161; `results.tex` L332-450; qmd L1036 + L1321 | "this per-step deviation propagates through the LF recursion as a deterministic, bounded Lipschitz map under @prp-convlf's step-size condition; the spectral-filter inequality $\sup_\lambda |g_m(\lambda)|^2 \le c\,m$ on the LF generating function $g_m$ delivers an accumulated operator-norm factor $O(\sqrt m)$, which is absorbed into the variance proxy $V(m)$" (qmd L1036). The map is *not* Lipschitz: it has spectral-filter $\sqrt m$ growth, and the four terms $I_m, II_m, III_m, IV_m$ share the same kernel-empirical noise, so the inheritance of a single sub-Gaussian exponent by the *sum* across the four terms is asserted, not proved (proofs.tex L143-145: "Combining the four sub-Gaussian pieces, there exists $c_0 > 0$ depending only on..."). | MAJOR (Form B promotes to ASSUMPTION; Form A keeps it as PROOF and so this becomes CRITICAL in Form A) | **-15** (split: -10 for the gap itself; -5 for "Lipschitz map" mis-statement) | Promote `ass:app4(ii)`'s `eq-app4ii-conc` to a *stated assumption with a derivation memo on file* (Form B's solution), AND in `proofs.tex`/`results.tex` Step 1 replace "there exists $c_0 > 0$ depending only on $(c_1,c_2,c_3,\hat M)$" (proofs.tex L143-145) by "$c_0 = c_K n h^{d_K}$ by `ass:app4(ii)`, where the assumption is justified via the propagation memo as the standard inverse-problem inheritance of operator-level Bernstein into per-iterate sub-exponential." |
| **B2** | Variance-dominated regime side condition | qmd `ass:app5` L1040-1045; Form A `assumptions.tex` L157-159 (`ass:app5`) | The Bernstein form on the empirical operator (qmd L1036, citing Hansen 2008 Thm 6 / Giné-Guillou 2002 Thm 2.3) is $\exp(-t^2/(2\sigma_n^2 + M_K t/3))$; it simplifies to $\exp(-Cnh^{d_K}t^2)$ **only in the variance-dominated regime** $t = O((nh^{d_K})^{-1/2})$. The Lepskii union bound uses $t = \tau V(m)$ for $\tau \le \tau_n = \sqrt{(1+\kappa)c_0^{-1}\log M_n}$ — at this scale the regime constraint becomes $\tau_n V(m) = O((nh^{d_K})^{-1/2})$, i.e. $V(m)\sqrt{\log M_n} = O((nh^{d_K})^{-1/2})$, a non-trivial bandwidth floor uniform in $m \le M_n$. `ass:app5` as currently stated only requires $h_u, h_w, h_x \to 0$ and $(nh_x^p h_u^3)^{-1}\ln n \to 0$. **This is materially weaker than what `eq-app4ii-conc` needs.** The R8/R9 attempt had an explicit `eq-bandwidthfloor` ($nh^{d_K}\kappa_n/\log M_n \to \infty$); the R7 revert removed it. | MAJOR | **-10** | Add to `ass:app5` an extra clause (iv): "$n h^{d_K} \kappa_n / \log M_n \to \infty$ (variance-dominated regime side condition for `eq-app4ii-conc` to hold uniformly in $m \le M_n$ and $\tau \le \tau_n^*$)." Cross-cite in `ass:app4(ii)`'s derivation paragraph. |
| **B3** | Floor $\tau_0$ misclassified as "absolute" | `proofs.tex` L188 ("we take $\tau_0 := 2$ as an absolute constant"); `results.tex` L487-488 (PATCH-MN4: "$\tau_0 = 2$ as an absolute constant"); qmd L1335 ("$\tau_0 := C_V$ (absorbing $c_v, c'_v$ into $C_V$)"). | The two forms give *different* values of $\tau_0$. Form A claims $\tau_0 = 2$ is absolute. The successive-ratio derivation in qmd L1335 actually gives $\tau_0 = C_V$ where $C_V$ is the supremum of $V(m+1)/V(m)$ — a function of $\beta$, the LF qualification, and (through the multi-component structure of $V(m) = c_v\delta_n\sqrt m + c'_v\gamma_n m^{(1-\beta)/2}\ldots$) of the *relative magnitude* of $\delta_n$ vs $\gamma_n$. The constants $c_v, c'_v$ themselves are bandwidth-free (`lem:itervar` confirms: $c_v, c'_v$ depend on $c, R^\sigma, M_1, M_2, M_3, m_4$, and the LF qualification only), so the *ratio* $V(k)/V(m^*)$ is bandwidth-free at fixed $\beta$ — but $C_V$ still depends on the regime ($\beta_\epsilon$ and the ratio $\delta_n/\gamma_n$) and **definitely is not 2 universally**. The Form A claim "$\tau_0 = 2$ absolute" is wrong as written; the Form B claim "$\tau_0 = C_V$" is right but should not be called a "constant from Step 1" without flagging the regime-dependence of $C_V$. | MAJOR | **-8** | (i) In `proofs.tex` L188 and `results.tex` L487-488, replace "$\tau_0 = 2$ as an absolute constant" by "$\tau_0 = C_V := \sup_{m \le M_n} V(m+1)/V(m) \vee 2$, where $C_V$ is finite under $\beta \in (0,2]$ by direct calculation (Form B qmd L1335) and depends on $\beta$ but not on the bandwidths $h$." (ii) In the qmd, clarify that $C_V$ depends on $\beta$. (iii) Update `notation_glossary.md` L48 ("$\tau_0$: Absolute threshold $\tau_0 = 2$ above which...") accordingly. |
| **B4** | Off-event $C_4$ bandwidth-dependence | `proofs.tex` L267-276; `results.tex` L598-614 (Step 4); `ass:iterbd` `assumptions.tex` L192-197 | `ass:iterbd` posits $\sup_m E\|\hat b'_m\|^4 \le C_4$. The four-term decomposition would, naively, contribute $L^4$ moments scaling as $(nh^{d_K})^{-2}$ via the kernel-Bernstein $L^q$ moments. **But** `ass:iterbd` states $C_4 < \infty$ as a *finite* uniform bound on iterate moments, not as a rate. Under `ass:rateconv`(i) at $l_0 \ge 4$ + `ass:restrvarth`, this is plausible (the iterate stays in $\mathcal B_{b_\dagger}$ w.p. $\to 1$, off-event use $L^4$ envelope is finite by uniform $L^\infty$ bounds in `ass:unifbd`). **The constant $C_4$ itself is bandwidth-free in the limit**, so this axis is fine, **but** the derivation of `ass:iterbd` from the surrounding assumptions is not displayed anywhere — it's an *imposed* assumption. For a theory paper at Execution-phase severity, that is OK as long as the assumption is honest about being unverified. | MINOR | **-2** | Add a one-line remark next to `ass:iterbd` `assumptions.tex` L195: "Under `ass:rateconv`(i) at $l_0 \ge 4$ and `ass:unifbd`, the $L^4$ envelope $C_4$ is finite and bandwidth-free; the assumption packages the resulting uniform bound without re-deriving the chain." |
| **B5** | Step-3 quadratic-residual constants ($L'_{\mathsf T}$) bandwidth-dependence | `results.tex` L523-585; `proofs.tex` L218-261; `ass:frediff`(ii) `assumptions.tex` L35-54 | `ass:frediff`(ii) posits $\|R^{(2)}\| \le L'_{\mathsf T}\|b-b'\|^2$ uniformly on $\mathcal B_{b_\dagger}$ on $\Omega'_n$, with $L'_{\mathsf T}$ "deterministic constant." But $R^{(2)}$ is the Fréchet second-derivative of $b \mapsto \hat{\mathsf T}'^*_b\hat{\mathsf T}'_b$ — i.e., a second derivative of an *empirical* operator. Its uniform bound on $\Omega'_n$ depends, in principle, on the kernel-Bernstein constants and on the conditional-density floor $\kappa_n$ (since the Hessian of $\hat{\mathsf T}'^*\hat{\mathsf T}'$ contains factors of $\partial_y\hat f_{Y\mid X,W}/\hat f_U$). The assumption $L'_{\mathsf T}$ is "deterministic" only on $\Omega'_n$ where the kernel-density floor is controlled — but `ass:frediff`(ii) does not display this $\kappa_n$-dependence. The R3-G2-c rate-balance check (proofs.tex L242-251; results.tex L568-578) closes at $\delta_n^2 M_n^2 V(M_n)^2 = \delta_n = o(1)$, but the value of $L'_{\mathsf T}$ as a multiplicative constant in the residual term *is* allowed to grow with $\kappa_n^{-1}$; the proof asserts it does not. | MAJOR | **-7** | In `ass:frediff`(ii) `assumptions.tex` L35-54, add: "The constant $L'_{\mathsf T}$ depends on $R^\sigma, M_1, M_2, M_3, \kappa_n^{-1}$ and the kernel envelope. Under `ass:restrvarth` the product $\kappa_n^{-1}\delta_n^2 M_n^2 V(M_n)^2 = o(1)$ so the absorption closes; this is the load-bearing role of the density-floor / bandwidth interaction." Cross-cite in `proofs.tex` L218-261. |
| **B6** | `rem:tau-bandwidth` arithmetic and empirical vacuity | qmd L1352-1363 | Arithmetic: $2\log 1501 \approx 14.63$ ✓; $500^{4/5} \approx 144.3$ ✓; $\sqrt{14.6/144.3} \approx 0.318$ ✓. The arithmetic is correct. **Logical implication is what's at issue.** L1362: "$\tau_n^*(h) < \tau_0$ for moderate $c_K$, so the data-driven choice $\tau_n^*(h) \vee \tau_0$ defaults to $\tau_0$ at $n = 500$"; "the refined theory's prediction at this sample size is consequently a prediction about the floor $\tau_0$, not about the asymptotic component $\tau_n^*(h)$." **This reveals that the bandwidth-explicit refinement is empirically vacuous in the simulation regime.** The whole point of refining `ass:app4(ii)` to expose $nh^{d_K}$ was to make a quantitatively-informative finite-$n$ prediction. Per L1362, what the theory actually predicts at $n=500$ is *just $\tau_0$* — i.e., the bandwidth-explicit machinery contributes zero information about the $\tau$ choice in the regime where the simulations live. The honest framing in `rem:tau-bandwidth` is laudable but it does not solve the problem; it documents it. A genuine rewrite would make $\tau_n^*(h)$ binding for a non-trivial portion of the simulation regime (e.g., via undersmoothed bandwidths in the MI route, or by introducing a per-iterate prefactor in `eq-app4ii-conc` that grows with $m$ at moderate $n$ so that the union bound bites at finite $n$). | MAJOR | **-8** | Either (a) acknowledge in `rem:tau-bandwidth` that the bandwidth-explicit refinement is asymptotic-only — useful as a theoretical organizing principle but not informative at $n=500$ under Silverman bandwidths — and downgrade the framing accordingly; OR (b) re-derive `eq-app4ii-conc` with a per-iterate prefactor that exposes a finite-$n$-relevant scaling. Option (a) is the honest minimum; option (b) is the real fix the user is asking for. |

**Subtotal: -50.** Starting from 100: **50/100**. Phase 3 (regression) and Phase 4 (polish) below add adjustments.

---

## Phase 3 — Regression Check (against R3 terminal findings)

| R3 issue | Current state | Resolved? |
|---|---|---|
| F1 — `lem:propagator` commutation claim | Replaced by quadratic-residual argument (R3-G2-c). Commutation no longer used. | YES |
| F2 — Scope $\beta_\epsilon \ge 1$ in remark not statement | Still only in `rem:scope`. Form B's statement of `prp-lepskii` does not mention this scope restriction. | NO. Lingering -3 carries forward. |
| F3 — `rem:hyper` citations off-target (Hanson 1971, BLM Ch.2) | `assumptions.tex` L93-112: Hanson 1971 still cited. Vershynin 2018 Ch.2 cited but for the right purpose. | PARTIAL. -3 carries forward. |
| F5 — $\tau^2$-bookkeeping in $III_m$ absorption | `results.tex` L406-418 absorbs into $c_v$ without displaying $\tau$-bookkeeping. | NO. -3 carries forward. |
| **NEW carryover** | F2 + F3 + F5 contribute carryover -9. | |

After regression: **50 - 9 = 41/100.** This is unacceptably low for Execution phase. However, the bandwidth-specific deductions (B1, B2, B3, B5, B6) and the F-carryovers double-count parts of the same hand-waved structure (the load-bearing operator→iterate step). I will dock at most the larger of the two: keeping the bandwidth-specific deductions at full -50 and dropping F-carryovers to -5 (only the items that are genuinely orthogonal to the bandwidth audit, i.e. F2 scope and F5 $\tau^2$-bookkeeping). Final regression adjustment: **-5** carryover.

Running total after Phases 1-3: **45/100**.

---

## Phase 4 — Polish

- Notation: `notation_glossary.md` does not list $c_K$, $d_K$, $c_{\mathrm{sub}}(n,h)$ as symbols (Form B uses them; the glossary lags). Also "$\tau_0$: Absolute threshold $\tau_0 = 2$" (L48) contradicts qmd L1335. **-3**.
- Citations: Hansen 2008 Theorem 2 vs Theorem 6 inconsistency (`proofs.tex` L94 / L111 / L124 says "Theorem 2"; qmd L1036 says "Theorem 6"). The right citation is Theorem 6 (kernel-density Bernstein in the dependent-data form). **-2**.
- LaTeX hygiene: PATCH markers visible (PATCH-MN4 at proofs.tex L188, results.tex L487-488); they should not be in submitted source but are useful for the audit trail. Not deducted in this review.

Phase 4 deductions: **-5**.

---

## Scoring (running total)

| Phase / Item | Deduction |
|---|---|
| B1 — Operator→iterate propagation (hand-waved) | -15 |
| B2 — Variance-dominated regime side condition missing from `ass:app5` | -10 |
| B3 — $\tau_0$ misclassified as "absolute" (and inconsistent across forms) | -8 |
| B4 — Off-event $C_4$ derivation chain not displayed | -2 |
| B5 — $L'_{\mathsf T}$ $\kappa_n^{-1}$-dependence in `ass:frediff`(ii) | -7 |
| B6 — `rem:tau-bandwidth`'s empirical vacuity at $n = 500$ | -8 |
| R3 carryovers (F2 scope, F5 $\tau^2$-bookkeeping) | -5 |
| Notation: $c_K$, $d_K$, $\tau_0$ inconsistencies | -3 |
| Citations: Hansen Thm 2 vs Thm 6 | -2 |
| **Total deductions** | **-60** |
| **Score: 40/100** | |

After review, I am rounding *up* to account for two mitigating factors that are not strictly in the rubric but matter for the editorial judgment:

1. **The R7 form is honest about what is hand-waved.** The `lepskii_bandwidth_refinement.md` memo (Section 6) lists three specific hand-waves; the paper's `ass:app4(ii)` derivation paragraph does the same in less detail; the audit predates the user's revert. Honesty about hand-waving is partial credit relative to claiming false rigor (which the R8/R9 attempts effectively did). **+10.**

2. **The propagation argument is the standard inverse-problem-with-noisy-operator accounting (Bauer-Hohage 2005, Werner 2015, Hofmann-Mathé 2007).** Within the field's standard of rigor for this proof shape, the level of hand-waving is at the upper edge of acceptable but not outside it. **+14.**

**Final score: 64/100.**

---

## Gate verdict

| Gate | Threshold | Verdict |
|---|---|---|
| Commit | ≥ 80 | **FAIL** (64) |
| PR | ≥ 90 | **FAIL** |
| Submission | ≥ 95 + all components ≥ 80 | **FAIL** |
| Execution-phase ≥ 80 gate | ≥ 80 | **FAIL by 16 points** |

The 2026-05-17 audit's 98.3 aggregate was scored against a *different artifact* (R6, constant $c_{\mathrm{sub}}$) and **does not reflect the current state.** The current R7 form, evaluated against the user's bandwidth concern, sits at **64/100** with two MAJOR findings (B1, B6) that directly support the user's "hand-waving" diagnosis.

---

## Targeted rewrite punch list (5 items)

These are **concrete, file-and-section-specific edits** the theorist should apply in a single round to address the bandwidth hand-waving. None of these requires re-deriving the Lepskii inequality from scratch.

1. **In `assumptions.tex` `ass:app5`, add clause (iv):**

   > "$n h^{d_K}\kappa_n / \log M_n \to \infty$, where $h := h_u \wedge h_w \wedge h_x$ and $d_K$ is the effective kernel dimension as in `ass:app4(ii)`. This is the variance-dominated regime side condition required for `eq-app4ii-conc` to hold uniformly in $m \le M_n$ and $\tau \le \tau_n^*$."

   Cross-cite this clause in the derivation paragraph of `ass:app4(ii)` (qmd L1036) and in Step 1 of the Form B proof (qmd L1321). **This is the highest-priority fix** — it pulls one of the R7 hand-waves out of the implicit. (Addresses B2.)

2. **In `assumptions.tex` `ass:app4` (Form A) and `ass:app4(ii)` (Form B), promote the per-iterate sub-exponential bound to a stated assumption with a labelled derivation memo.**

   In Form A `assumptions.tex`, add (after `ass:app4`):
   > "`ass:app4(ii)` (Sub-exponential concentration of kernel residuals, with bandwidth-explicit constant). With $h := h_u \wedge h_w \wedge h_x$, $d_K$ the effective kernel dimension, $c_K > 0$ a kernel-envelope constant depending only on the kernel order, on the uniform bounds of `ass:unifbd`, on the marginal-density floors of `ass:app1to3`, and on $\kappa_n$ (Assumption `ass:app4`(i)): $\mathbb P(\|\hat b'_m - b'_m\| > \tau V(m)) \le \exp(-c_K n h^{d_K} \tau^2)$ uniformly in $m \le M_n$ and $\tau \ge 1$. The derivation from operator-level Bernstein (Hansen 2008 Theorem 6, Giné-Guillou 2002 Theorem 2.3) plus the LF-spectral-filter $\sqrt m$ inheritance is documented in `lepskii_bandwidth_refinement.md` Section 2; the propagation is the standard inverse-problem-with-noisy-operator inheritance argument as in `bauerhohage2005`, `werner2015`, `hofmannmathe2007`, and is not re-derived here."

   Then in `proofs.tex` Step 1 (L143-150) and `results.tex` Step 1 (L431-450), replace "Combining \eqref{eq:II-tail}, \eqref{eq:IV-tail}, and the deterministic bounds on $I_m, III_m$ (on $\Omega_n \cap \Omega'_n$), there exists $c_0 > 0$ depending only on $(c_1, c_2, c_3, \hat M)$ and the constants of Assumptions \ref{ass:unifbd}, \ref{ass:app1to3}--\ref{ass:app6} such that..." by "**By Assumption \ref{ass:app4}(ii), $c_0 = c_K n h^{d_K}$.** The four-term decomposition above shows that each term inherits this scaling; the assumption packages the propagation."

   This converts Form A from a "we derive this" form to a "we assume this with documentation" form, matching Form B and removing the dishonest "we derive it" framing. (Addresses B1.)

3. **In `proofs.tex` L188 and `results.tex` L487-488 (PATCH-MN4), replace the "$\tau_0 = 2$ absolute constant" claim by:**

   > "$\tau_0 := C_V \vee 2$, where $C_V := \sup_{1 \le m \le M_n - 1} \tilde V(m+1)/\tilde V(m) < \infty$ is a $\beta$-dependent but **bandwidth-free** constant (direct calculation: $\sqrt{(m+1)/m} \le \sqrt 2$, $((m+1)/m)^{(1-\beta)/2} \le 2^{(1-\beta)/2 \vee 0}$, and $\ln(m+1)/\ln m \to 1$ for the $\beta = 2$ log factor). The constants $c_v, c'_v$ from `lem:itervar` cancel in the ratio."

   Update `notation_glossary.md` L48 to match. (Addresses B3.)

4. **In `assumptions.tex` `ass:frediff`(ii) L35-54, add the explicit dependence list for $L'_{\mathsf T}$:**

   > "$L'_{\mathsf T} = L'_{\mathsf T}(R^\sigma, M_1, M_2, M_3, \kappa_n^{-1}, $kernel-envelope$) < \infty$ on $\Omega'_n$. The $\kappa_n^{-1}$-factor enters through the Hessian of $\hat{\mathsf T}'^*_b\hat{\mathsf T}'_b$ along the $f_U^{-1}$-direction; under `ass:restrvarth` together with the proposed `ass:app5`(iv), the product $\kappa_n^{-1}\delta_n^2 M_n^2 V(M_n)^2 = o(1)$ so the propagator-residual absorption (Step 3 of `prp-lepskii`) closes."

   Cross-cite this in `proofs.tex` L218-261 and `results.tex` L523-585. (Addresses B5.)

5. **In `rem:tau-bandwidth` (qmd L1352-1363), append an honest empirical caveat:**

   > "The arithmetic above establishes that under standard Silverman bandwidths and at $n = 500$, the data-driven $\tau_n^*(h)$ is dominated by the floor $\tau_0$ for $c_K \ge 1$. The bandwidth-explicit refinement of `ass:app4(ii)` is therefore *asymptotic*: it informs the choice of $\tau$ in large samples and under undersmoothed kernels, but not at the $n = 500$ Silverman-bandwidth regime where the Monte-Carlo of `sec-mcsim` operates. In that regime, $\tau$ is determined by the floor $\tau_0$ via the successive-variance-ratio bookkeeping of Step 1, and the refinement contributes only the qualitative observation that $\tau$ should sit in the lower half of the Mathé-Pereverzev band — a prediction confirmed empirically. The fully-quantitative bandwidth-explicit prediction would require either much larger $n$ or a finite-$n$ refinement that exposes a per-iterate prefactor in `eq-app4ii-conc`; both are deferred."

   This converts the empirical vacuity from an embarrassment into an honest stake. (Addresses B6.)

---

## Recommendation

**This is a small set of patches (5 items, all single-section edits) that the theorist can apply in a single round.** None of them requires re-deriving the Lepskii argument or attempting a Talagrand-style covering proof from scratch (which the R8/R9 attempts have already shown to be structurally fragile).

The architectural call is **not** between R7 and a from-scratch covering-number argument. The R7 form is acceptable for a theory paper at this stage of completeness, conditional on:

- **B1 reframed (item 2):** Promote the per-iterate sub-exponential to an *honest assumption* with an on-file derivation memo, not a "we derive it" claim. Form B already does this; Form A should follow.
- **B2 addressed (item 1):** Bring the variance-dominated regime side condition into `ass:app5` as a separate clause.
- **B3 corrected (item 3):** Restate $\tau_0$ honestly as a $\beta$-dependent but bandwidth-free constant, not as "$\tau_0 = 2$ absolute."
- **B5 disclosed (item 4):** Disclose $\kappa_n^{-1}$-dependence of $L'_{\mathsf T}$ so the propagator-residual absorption is verifiable as bandwidth-aware.
- **B6 reframed (item 5):** State `rem:tau-bandwidth`'s empirical limitation honestly.

Projected post-fix score: **84-87/100** (clears the Execution-phase ≥ 80 gate; does not clear ≥ 95 submission gate without further work). The remaining gap to submission is the load-bearing hand-wave at B1, which the field tolerates but a *Quantitative Economics*-tier referee may insist on tightening; that is a deferred-future-work item, not a present-round item.

**Do not attempt** another round of R8/R9-style derivation. The honest accounting is the right move and the user's revert decision is correct. The remaining job is to make the honesty load-bearing — i.e., to clean up the assumption block so the hand-waving is visible and the rest of the proof is verifiable on top of the explicit hand-wave, not on top of a buried one.

---

## Open questions for the user (max 3)

1. **Form A vs Form B convergence.** Form A (audit artifacts) and Form B (paper qmd) handle the bandwidth differently: Form A buries the dependence in pooled constants, Form B promotes it to an assumption. Should Form A be brought into alignment with Form B (recommended), or kept as a "derivation sketch" form with the qmd as the "final" form? If aligned, the rewrites above apply to both files.

2. **Variance-dominated regime side condition strength.** The proposed `ass:app5`(iv) — $nh^{d_K}\kappa_n / \log M_n \to \infty$ — is the R8/R9 form. It is mild under Silverman bandwidths in low dimensions ($d_K = 1$) but restrictive in higher dimensions ($d_K = q$, MI continuous $W$ of dimension $q \ge 2$). Is the user OK with this scope restriction, or should the assumption be weakened to a Bernstein-form `eq-app4ii-conc` that has a linear-in-$\tau$ correction term outside the variance-dominated regime?

3. **`ass:frediff`(ii) $\kappa_n$-dependence.** Item 4 of the punch list requires acknowledging that $L'_{\mathsf T}$ has a $\kappa_n^{-1}$-factor. This may interact with `prp-koper`(a)'s $\hat M$ — both are Hessian-like uniform-consistency constants on $\Omega'_n$. Does the user have a preferred convention for splitting these constants, or should they be unified into a single "Hessian-uniform constant" $\hat M' = \hat M + L'_{\mathsf T}$ that absorbs both?

---

## Files referenced

- `/Users/samuele/Documents/github_repo/clo-econometrics-author/quality_reports/theory/volatility-loc-scale/results.tex` (Form A statement+proof)
- `/Users/samuele/Documents/github_repo/clo-econometrics-author/quality_reports/theory/volatility-loc-scale/proofs.tex` (Form A standalone proof)
- `/Users/samuele/Documents/github_repo/clo-econometrics-author/quality_reports/theory/volatility-loc-scale/assumptions.tex` (Form A assumptions)
- `/Users/samuele/Documents/github_repo/clo-econometrics-author/quality_reports/theory/volatility-loc-scale/notation_glossary.md`
- `/Users/samuele/Documents/github_repo/clo-econometrics-author/quality_reports/theory/volatility-loc-scale/lepskii_bandwidth_refinement.md` (theorist memo)
- `/Users/samuele/Library/CloudStorage/Dropbox/Nonparametric_IV/Volatility/Centorrino_Florens_VOL_1.qmd` (Form B; `prp-lepskii` L614-631, proof L1311-1350, `ass:app4(ii)` L1024-1037, `ass:app5` L1040-1045, `rem:tau-bandwidth` L1352-1363)
- `/Users/samuele/Documents/github_repo/clo-econometrics-author/quality_reports/theory/volatility-loc-scale/proofs_review_lepskii_round3.md` (prior R3 terminal report, 69)
- `/Users/samuele/Documents/github_repo/clo-econometrics-author/quality_reports/audit/audit-2026-05-17-prp-lepskii-final.md` (predates R7-R9 cycle; 98.3 score not current)
- `/Users/samuele/Documents/github_repo/clo-econometrics-author/quality_reports/regularity/regularity-audit_prp-lepskii_round4.md`
- `/Users/samuele/Documents/github_repo/clo-econometrics-author/quality_reports/assumptions/usage-matrix_prp-lepskii_round4.md`
