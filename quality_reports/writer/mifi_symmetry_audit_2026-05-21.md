# MI/FI Symmetry Audit — Centorrino-Florens Volatility Paper

**Target:** `/Users/samuele/Library/CloudStorage/Dropbox/Nonparametric_IV/Volatility/Centorrino_Florens_VOL_1.qmd`
**Scope:** §2 Local identification (L93–340), §3 Estimation (L341–419), §4 Asymptotic Properties (L421–640), §A1 Additional assumptions (L987–1048), §A2 Proofs of identification (L1049–1124), §A3 Proofs of asymptotic properties (L1125–1345), §A5 Useful lemmas (L1346+). Excluded: §5 Monte-Carlo Simulations (incomplete), §6 Empirical applications (incomplete), §7 Conclusions (incomplete).
**Date:** 2026-05-21
**Severity:** MEDIUM-HIGH (Execution phase)
**Audit question:** Is the introduction's "equal footing" claim for MI (conditional-moment) and FI (full-independence) routes substantively supported by the body?

---

## Section 1 — Route-treatment inventory

| Section (lines) | MI-specific paragraphs / derivations | FI-specific paragraphs / derivations | Operator-agnostic / both-routes | Asymmetries flagged |
|---|---|---|---|---|
| §2 intro + Two routes (L93–171) | §2.1.1 "Conditional moments" L125–148 (4 paragraphs): full operator + Fréchet derivative + adjoint + null directions | §2.1.2 "Full independence" L150–170 (3 paragraphs): operator + Fréchet derivative + side conditions; defers explicit adjoint to §2.3 | L103–114 (route-setup), L119–123 (common polynomial $\psi$) | None substantive — by design (adjoint formula requires density-existence assumption) |
| §2.2 Local-id + `prp-onetoone` (L172–200) | — | — | def-locid (L178–183), prp-onetoone (L189–198), commentary L200 | Fully symmetric |
| §2.3 Conditional completeness (L202–239) | MI variant block (4 lines) | FI variant block (5 lines, with side conditions) | L227 "Both variants ask..." | None — equal clarity |
| §2.4 Sufficient primitive conditions (L241–287) | Adjoint NOT shown; "MI counterpart is analogous" (L269) | FI Fréchet derivative \eqref{eq-frechet}; full constant-$M$ + HS proof in §A2 | prp-condcomp, source-condition def-sourceID | Type B at L269 — see #2 |
| Gaussian example (L289–339) | "Conditional-moment route" L305–320 (full Mehler analysis) | "Full-independence route" L322–338 (full Mehler + binary witness) | L297–303 (modified Mehler identity) | None substantive — both worked out in matching detail |
| §3 Estimation (L341–419) | — | All formulas FI-specific. L366: "we drop the FI subscript … the rest of this section concerns the FI route only" | Step 6 stopping rule | Type B — see #4 |
| §4 prelude + `prp-convlf` (L421–448) | — | — | All operator-agnostic | None |
| §4.2 `ass:rateconv` (L458–505) | Continuous-$W$ (MI) bullet | Discrete-$W$ (FI) bullet, listed first | L487–490 abstract rates; L505 operator-agnostic | Type B (order) — see #5 |
| §4.2 `prp-koper`, `thm-mainconv`, `cor-rates` (L506–559) | — | Default is FI: $h_u^{-2}\kappa_n^{-1}$ in prp-koper(b), $\beta_\epsilon = \beta \wedge (1-\epsilon)$ in thm-mainconv | Operator-agnostic in framing | None substantive |
| §4.3 mapback (L561–571) | — | — | Operator-agnostic | None |
| §4.4 `sec-mi-rates` (L573–575) | Single paragraph: 3 substitutions | — | — | Type B — see #4 |
| §4.5 Lepskii (L577–637) | — | — | All operator-agnostic; `prp-lepskii` covers both with "(ass:app5 dropped in MI)"; `rem:linear-reduction` MI-specific (labelled) | None — excellent symmetry |
| §A1 Additional assumptions (L987–1047) | — | `ass:app5` (FI-specific bandwidth) | `ass:app1`–`ass:app4`, `ass:app3a`/`ass:app3b`, `ass:app6` | Type A inherent |
| §A2 Proofs of identification (L1049–1123) | "MI variant" in prp-condcomp proof L1111–1112 | "FI variant" in prp-condcomp proof L1105–1109; constant-$M$ kernel-difference proof L1064–1097 FI-only | prp-onetoone proof L1051–1063 (abstract derivative) | Type B — see #2 |
| §A3 Proofs of asymptotic properties (L1125–1338) | MI case in lem-itervar proof L1301 (with broken cross-ref) | Full proofs of prp-convlf, prp-koper, thm-mainconv, cor-rates, lem-itervar | prp-lepskii proof L1303–1338 operator-agnostic | Type C — see #1 |
| §A5 Useful lemmas (L1346–1372) | — | — | Operator-agnostic | None |

---

## Section 2 — Asymmetries found

### #1 — Broken in-text line reference for MI counterpart of `prp-koper(a)`
- **Location:** qmd L1301
- **Quote:** *"(iii) Term $III_m$ uses the MI counterpart of @prp-koper(a), which holds verbatim since its proof at lines 877-898 does not use $f_U$"*
- **Type:** C (genuine gap as written — cross-reference fails to land on a real proof; lines 877-898 are in the empirical-application figure code)
- **Severity:** HIGH
- **Remediation:** Replace the brittle line pointer with a proper Quarto cross-reference: *"…holds verbatim since the proof of @prp-koper(a) treats both Fréchet derivatives uniformly through the Leibniz step in \eqref{eq-tmider}/\eqref{eq-frechet} and never invokes the marginal density $f_U$."* The actual proof of `prp-koper(a)` lives at L1158–1182.

### #2 — MI quadratic-remainder bound and Hilbert-Schmidt argument absent
- **Location:** qmd L269 (claim) and §A2 L1064–1097 (FI-only proof)
- **Quote (L269):** *"A proof of both statements for the FI operator is given in Appendix [-@sec-annexA2]; the MI counterpart is analogous and uses \eqref{eq-tmider} in place of \eqref{eq-frechet}."*
- **Type:** B (presentational — math is symmetric, but the FI proof hinges on the kernel difference $\Delta f(y,x,w) - \Delta f(y_t,x,w)$ which has no exact analog for the MI matrix-of-conditional-expectations derivative)
- **Severity:** MEDIUM
- **Remediation:** Add a 3–6 line MI-counterpart paragraph at the end of §A2 sketching the constant-$M$ derivation for \eqref{eq-tmider}: state the polynomial $\psi$ expansion (L121–123), bound the chain-rule weight via `ass:unifbd`(iii) and the second-row matrix entries by $|U| + |Y|e^\omega$, conclude with constant $M \propto M_2 M_3 \sqrt{\max(1, m_4)}$. The Hilbert-Schmidt step is shorter — matrix entries uniformly bounded by `ass:unifbd`.

### #3 — MI Fréchet derivative for general $b$
- **Location:** qmd L131–138
- **Type:** A (inherent / false alarm on closer reading — \eqref{eq-tmider} *is* displayed for general $b$ at L131–134, then specialized at $b_\dagger$)
- **Severity:** N/A
- **Remediation:** None. Recorded for the audit trail.

### #4 — §4.4 three-sentence MI rebalancing vs §3–§4's 30-paragraph FI default
- **Location:** §3 L341–419 (entire FI estimation section), §4.1–4.3 L421–571, §4.4 L573–575
- **Quote (L366):** *"…we drop the FI subscript on $\mathsf{T}$ for brevity (the rest of this section concerns the FI route only)."*
- **Quote (L573 entire `sec-mi-rates`):** Three substitutions in 3 sentences.
- **Type:** B
- **Severity:** MEDIUM
- **Remediation:** Two compatible options:
  1. **Light touch.** Add one sentence at start of §3 (around L341 or L345) clarifying that the algorithm is presented for FI because the FI adjoint subsumes the MI structure via the $f_U$-correction, and that the MI case reduces to setting the $f_U$ correction to a constant. This makes the asymmetry explicit-by-design.
  2. **Heavier touch.** Promote `@sec-mi-rates` to a half-page subsection (15–20 lines) displaying the MI adjoint, MI version of `prp-koper(b)` (with $K$ simplifying to identity), and MI version of `thm-mainconv`. Light touch suffices for the "equal footing" claim.

### #5 — Order asymmetry in `ass:rateconv`
- **Location:** qmd L494–502
- **Quote:** Discrete-$W$ FI bullet listed first; continuous-$W$ MI bullet second — contradicts the MI-then-FI ordering at L125 vs L150
- **Type:** B
- **Severity:** LOW
- **Remediation:** Swap the two bullets so MI (continuous $W$) appears first, matching §2's ordering.

### #6 — `prp-onetoone` proof's "either route" abstract-derivative coverage
- **Location:** qmd L1051–1063
- **Type:** A (inherent — injectivity by hypothesis (ii); case-split is correctly done in `prp-condcomp`'s proof L1099–1113 with both variants)
- **Severity:** N/A
- **Remediation:** None.

### #7 — Notation: `\mathsf{T}` consistency
- **Location:** qmd L174 (convention statement) plus all in-scope sections
- **Verification:** grep returns 11 `\mathsf{T}_{\text{MI}}` and 11 `\mathsf{T}_{\text{FI}}` — exact parity. No `T_{\text{MI}}` or `T_{MI}` instances.
- **Type:** B (notation)
- **Severity:** LOW (no deduction — clean)
- **Remediation:** None.

### #8 — `ass:app5` FI-specific
- **Type:** A (inherent — $f_U$ does not appear in MI adjoint)
- **Severity:** N/A
- **Remediation:** None. Acknowledged at L575, L593, L616 ("ass:app5 dropped in the MI case"). Clean handling.

### #9 — $\beta_\epsilon$ saturation FI-specific
- **Type:** A (inherent — comes from $h_u^{-2}\kappa_n^{-1}$ in prp-koper(b), FI-only)
- **Severity:** N/A
- **Remediation:** None.

### #10 — Aitchison-Aitken kernels for discrete $W$
- **Location:** qmd L1011–1018 (`ass:app3b`)
- **Type:** A (inherent)
- **Severity:** N/A
- **Remediation:** None.

---

## Section 3 — Verdict

**Is the introduction's "equal footing" claim substantively supported by the body?** Mostly yes, with three caveats:

1. **The broken cross-reference at L1301 is a real defect.** The reader cannot independently verify the MI verbatim-claim for `prp-koper(a)`. Fix is a 30-second `\ref` replacement.
2. **The MI Fréchet/Hilbert-Schmidt argument in §A2 is hand-waved at L269.** A 3–6 line block at the end of §A2 closes this gap.
3. **The §4.4 single-paragraph rebalancing reads as an afterthought.** One framing sentence at start of §3 makes the asymmetry explicit-by-design.

**Cross-route notational consistency:** **Clean.** $\mathsf{T}_{\text{MI}}$ and $\mathsf{T}_{\text{FI}}$ are typeset identically (11 of each in upright sans-serif). Convention at L174 is consistently followed throughout §2–§4 and §A2–§A3.

**Inherent asymmetries (Type A) are handled well.** Each of the four inherent asymmetries (`ass:app5` drop, $\beta_\epsilon$ saturation, discrete-kernel `ass:app3b`, discrete-$W$ vs continuous-$W$ rates) is acknowledged at the point of use with a "drop in MI" or "MI substitution" clause.

---

## Section 4 — Score

| Finding | Type | Severity | Deduction |
|---|---|---|---|
| #1 — Broken "lines 877-898" cross-reference at L1301 | C | HIGH | −5 |
| #2 — Missing MI quadratic-remainder / HS proof in §A2 | B | MEDIUM | −3 |
| #4 — §4.4 three-sentence MI rebalancing vs §3-§4 default | B | MEDIUM | −3 |
| #5 — Order asymmetry in `ass:rateconv` (discrete-FI first) | B | LOW | −1 |
| #3, #6, #7, #8, #9, #10 — Type A inherent or false alarm | A | — | 0 |
| **Total** | | | **−12** |
| **Score** | | | **88 / 100** |

---

## Section 5 — Recommendation

**MINOR REVISIONS.** The intro's "equal footing" claim is defensible *after* the L1301 cross-reference fix, but the manuscript would be visibly stronger with the two MEDIUM fixes.

**Minimum patch (≈ 1 hour of work):**

1. **L1301:** Replace `"lines 877-898"` with proper `@prp-koper`(a) cross-reference, e.g., *"…holds verbatim since the proof of @prp-koper(a) treats both Fréchet derivatives uniformly through the Leibniz step in \eqref{eq-tmider}/\eqref{eq-frechet} and never invokes the marginal density $f_U$."*

2. **End of §A2 (after L1097):** Add 3–6 lines sketching the MI constant-$M$ bound from \eqref{eq-tmider}. Keep it terse — closes the loop on L269's "is analogous" reassurance.

3. **Start of §3 (around L341 or L345):** Add one sentence noting that the algorithm is presented for FI because the FI adjoint subsumes the MI structure via the $f_U$-correction, and that MI implementation follows by the substitutions of `@sec-mi-rates`. This makes §3–§4 ordering explicit-by-design.

**Optional polish:**
- Reorder `ass:rateconv` bullets (MI continuous-$W$ first, FI discrete-$W$ second).
- Consider promoting `@sec-mi-rates` to a half-page subsection (+10–15 lines) for visual symmetry.

With the minimum patch applied, the intro's "framework treats both routes on equal footing" claim is well-supported and the score moves into the 92–94 band.
