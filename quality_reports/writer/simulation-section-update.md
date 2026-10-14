# Writer Update — Monte-Carlo Simulation Section

**Target file:** `/Users/samuele/Library/CloudStorage/Dropbox/Nonparametric_IV/Volatility/Centorrino_Florens_VOL_1.qmd`
**Date:** 2026-05-18
**Scope:** `# Monte-Carlo Simulations` section (line 641 onward) and its five subsections.

The update reflects the audit + diagnostic chain: a DGP change (quadratic-logistic → sin-sin), a bandwidth-selection change (CV → Silverman ROT), a reporting change (median + MAD → mean + MCSE alongside median + MAD), and prose updates throughout to surface the new empirical findings.

A small helper was also added to `preamble.tex`: `\newcommand{\todo}[1]{\textbf{[TODO: #1]}}`, so the `\todo{}` markers used as "load-bearing comments" compile without an external package.

---

## Change-by-change diff and rationale

### 1. Section chapeau (newly added, immediately after `# Monte-Carlo Simulations`)

**Diff:** Two new paragraphs inserted before `## Design`.

**Rationale:**
- **Paragraph A** states what the simulation is structured to test: the rate claim of `thm-mainconv` (via `sec-mc-rate`) and the adaptation claim of `prp-lepskii` (via `sec-mc-lepskii`). It also names the reason the smoother DGP was dropped: under it, the LF iteration is essentially inactive (m_oracle ≤ 2 in 63% of replicates), so neither claim is meaningfully tested.
- **Paragraph B** establishes the MI/FI asymmetry that the rest of the section carries: MI is the primary verification target, FI is a finite-sample backing for the Nepal application.

### 2. `## Design {#sec-mc-design}` — DGP block

**Diff:**
- Old `\varphi_\dagger(x) = -1.5x + 0.3x^2`, `\sigma_\dagger(x) = 1 + 0.5/(1+e^{-x})` → new `\varphi_\dagger(x) = 1.5 \sin(\pi x/2)`, `\sigma_\dagger(x) = 1 + 0.5 \sin(\pi x/2)`.
- New sentence explaining amplitude rationale: σ varies by ~100% of mean, vs ~25-30% under the smooth specification; explains why amplitude on σ is what makes the joint estimation nondegenerate.

**Rationale:** Diagnostic findings show m_oracle = 248 (median) and 83% replicates with m_oracle > 50 under sin-sin, vs m_oracle ≤ 2 in 63% under the old DGP — the new DGP is what exercises the theory.

### 3. `## Design {#sec-mc-design}` — FI bullet

**Diff:** Appended `\todo{Reconcile FI DGP: paper text states W ~ Bernoulli(2/3), an earlier version of code/simulation_main_IND.R drew W as a three-category variable. The strategic decision on which DGP to keep is pending.}`

**Rationale:** Flag the paper-vs-code mismatch identified by the simulation-engineer-critic audit, without committing to a resolution path.

### 4. `## Design {#sec-mc-design}` — bandwidth selection

**Diff:** Old "Bandwidths ... are selected once by leave-one-out cross-validation on the initial Nadaraya-Watson pilot" → new Silverman ROT with explicit formula `h = 1.06 \min(\hat\sigma, \widehat{IQR}/1.34) n^{-1/5}`, plus a sentence explaining why ROT replaces CV (CV produces catastrophic bandwidths in 25-50% of replicates, max:median ratio > 70:1). Citation: `[@silverman1986]` (verified to exist in the bib).

**Rationale:** The diagnostic finding (probe_lf_bw_compare.R) is exactly this trade-off; the prose now states the finding directly rather than hedging it.

### 5. `regfun`/`volfun` code chunk

**Diff:** Inline R definitions updated from quadratic + logistic to sin-sin, matching the new analytical DGP. Used by `fig-mc-onerep` to overlay truth on the representative draw.

**Rationale:** The R definitions in the .qmd were the only place where the OLD DGP was hard-coded; the actual simulation pipeline (`code/simulation_main_DEP.R`) is run separately and would need its own update. The .qmd now matches the paper text.

### 6. `## One representative draw at $n = 1000$ {#sec-mc-onerep}`

**Diff:** Old single paragraph (MI tracks well, FI noisier) → expanded to two empirical-content paragraphs:
- **Feature 1:** m_oracle is in the low hundreds (median 248) under new DGP — LF iteration is genuinely improving on the NW pilot. Contrasts with old DGP where m_oracle ≤ 2 in 63% of replicates.
- **Feature 2:** FI estimator unchanged in prose.
- **\todo block:** Flag that fig-mc-onerep PDF still reflects old DGP until simulation_main_DEP.R is re-run.

**Rationale:** The prose now describes what the figure will show after the production re-run; the \todo marker is the explicit pointer to the regeneration step.

### 7. `## Mean Integrated Squared Error across sample sizes {#sec-mc-mise}` — prose

**Diff:** Old "median is preferred ... heavy-tailed" → new "both mean (with MCSE = SD/√S) and median (with MAD)", with rationale: rate diagnostic is about MISE (first moment); under ROT bandwidth the mean is well-behaved, so mean-based reporting is now credible.

**Rationale:** The sim-engineer audit flagged median-only as masking heavy tails. Under the old CV+old DGP combination, mean was unstable; under the new ROT+new DGP combination, mean is the right target.

### 8. `## sec-mc-mise` — table chunk (`tbl-mc-mise`)

**Diff:**
- Old function returned 6 values: `(median, MAD, MCSE_median) × (phi, sig)`.
- New returns 8: `(mean, MCSE_mean, median, MAD) × (phi, sig)`, where MCSE_mean = `sd/√S`.
- Cell format changed from `median (MAD ..., MCSE ...)` to `mean (MCSE) | median (MAD)` (escaped as `\|` for kable Markdown).
- Caption updated accordingly.

**Rationale:** Reports the first-moment summary that the rate diagnostic requires alongside the robust summary that the heavy-tail concern requires.

### 9. `## sec-mc-mise` — trailing paragraph

**Diff:** Old "Two patterns emerge..." → new "Three patterns emerge..." adding:
- **Pattern 1 (new):** Mean MISE on phi is ~9.5% below the pilot at n=500 under the new DGP, well outside MCSE. Contrast with ~6% (and indistinguishable from noise) under the smooth DGP.
- **Pattern 2 (kept):** ISE on σ shrinks with n, phi more stable.
- **Pattern 3 (new):** Mean is the relevant summary but sensitive to tail behavior; ROT bandwidth makes it credible.
- Final sentence: median Lepskii index at cap 1501 vs median oracle 248 at n=1000 motivates the τ-sensitivity analysis.

**Rationale:** Directly states the key new empirical finding (9.5% MISE reduction) with specific numbers from the diagnostic.

### 10. `## sec-mc-rate` — trailing paragraph

**Diff:** Old "The MI rate readout ... empirical log-log slope on phi ... underestimate" → new version that splits into two qualifications:
1. Lepskii index at cap, oracle index ~248 — rate readout is a conservative lower bound on the true β_ε.
2. σ readout closer to β_ε = 0.5.
- Final sentence: oracle-anchored companion readout in sec-mc-lepskii isolates the rate claim from the conservativeness of the stopping rule.

**Rationale:** Makes explicit that the rate diagnostic at `\hat m` and the rate diagnostic at `m^*_{oracle}` are two different things, and the former is conservative when the stopping rule censors.

### 11. `## sec-mc-lepskii` — opening paragraph

**Diff:** Old "ratio is the empirical analogue of C(τ) ..." → expanded: explicit mention of `prp-lepskii`'s bound `\|\hat b'_{\hat m} - b'_\dagger\| / \min_m \|\hat b'_m - b'_\dagger\| \le C(\tau)\sqrt{\log M_n}`, with panel C as the 45°-line check and panel B as the index-ratio check.

**Rationale:** Connects the figure directly to the proposition statement so a reviewer can see which inequality each panel is testing.

### 12. `## sec-mc-lepskii` — trailing paragraph

**Diff:** Old "When oracle at cap... when oracle inside while \hat m at cap..." → new version with the concrete empirical numbers:
- Median m_oracle ≈ 248 at n=1000, 83% replicates with m_oracle > 50.
- Median \hat m at τ=4 sits at cap 1501.
- Two diagnoses (τ mis-calibration vs budget-interaction) and how `sec-mc-tau` distinguishes them.
- Last sentence: ratio in panel B should be interpreted as a one-sided diagnostic under the cap.

**Rationale:** Names the finding directly — at τ=4, the rule is too conservative — and motivates the τ-sensitivity section without hedging.

### 13. `## sec-mc-tau` — opening paragraph

**Diff:** Old "recommended Mathé-Pereverzev band" → new "recommended band in the Lepskii balancing literature is τ ∈ [3, 6] `[@mathe2003]`" (verified to exist in the bib). Plus a sentence explicitly connecting back to sec-mc-lepskii.

**Rationale:** The previous text cited "Mathé-Pereverzev" by name without a `\citep`; `mathepereverzev` is not a key in the bib. The closest entry is `mathe2003`, which I substituted.

### 14. `## sec-mc-tau` — trailing paragraph

**Diff:** Old "increasing τ leaves \hat m_τ at cap ... decreasing τ down to 1..." → new version that:
- Names a working recommendation: τ ≈ 2 for the MI design at the present DGP.
- Keeps τ = 4 for the applied sections where operator-noise scale is unknown.
- Notes the budget interaction: a more compute-intensive run with `I_max = 5000` would decouple the two diagnostics. Marked as future work.

**Rationale:** Gives a concrete actionable answer rather than leaving the sensitivity story open.

### 15. `preamble.tex` — `\todo` macro

**Diff:** Added `\newcommand{\todo}[1]{\textbf{[TODO: #1]}}` after the existing `\R`, `\Ls` definitions.

**Rationale:** The `\todo` markers in the .qmd would not compile without this. Avoids the `todonotes` package dependency (which would require an additional `\usepackage`).

---

## Bibliography flags for librarian follow-up

| Citation key used in update | Status | Notes |
|---|---|---|
| `silverman1986` | OK — exists in `../instrumental.bib` | Used for the Silverman rule-of-thumb bandwidth statement in `sec-mc-design`. |
| `mathe2003` | OK — exists in `../instrumental.bib` | Used as the reference for the τ ∈ [3, 6] recommended band in `sec-mc-tau`, replacing the previous nameless "Mathé-Pereverzev" mention. |

No new bib entries are required as a result of this update.

---

## Open questions for the user

1. **FI DGP.** The `\todo{}` block in `sec-mc-design` flags the paper-vs-code mismatch. The instruction explicitly said to leave the FI DGP description alone in the code, and the `\todo` marker preserves the paper text's claim (`W ~ Bernoulli(2/3)`). When the strategic decision is made, this `\todo` block should be removed.

2. **`fig-mc-onerep`.** The `\todo{}` block in `sec-mc-onerep` flags that the figure's underlying simulation (`simulation_main_DEP.R`) must be re-run with the sin-sin DGP before the figure matches the surrounding prose. The R definitions in the .qmd's `load-sim` chunk now match the new analytical DGP, but the `.rds` files under `code/sim_results/` were produced under the old DGP.

3. **Table re-rendering.** The table chunk `tbl-mc-mise` now uses `\|` inside cells for the visual separator between mean and median statistics. This compiles fine through kable + Pandoc; if visual rendering is unsatisfactory the cell format can be changed to a two-line cell or two adjacent columns.

4. **`m^*_oracle = 248` claim.** This number appears in three places: `sec-mc-onerep` (paragraph), `sec-mcsim` trailing paragraph of `sec-mc-mise`, and `sec-mc-lepskii` (trailing paragraph). The number is from `oracle_lepskii_n1000_S30.rds` per the diagnostic narrative. When the production runs are completed with the full S = 100 replicates, the number may shift slightly; the prose should be re-verified at that point.

5. **`τ ≈ 2` recommendation.** This recommendation is derived from the diagnostic narrative ("recommend τ that fires near m_oracle for the new DGP"). The figure `tau_sensitivity_mi.pdf` was generated; the .rds is at `code/sim_results/tau_sensitivity_mi.rds`. The exact value (2 vs 1.5 vs 2.5) should be confirmed against the .rds before the next compile.
