# Lepskii Bandwidth Refinement — Theory Memo

**Project:** volatility-loc-scale (Centorrino–Florens)
**Target artifacts:** `ass:app4(ii)`, `ass:app5`, `prp-lepskii` (statement and proof), `rem:tau-bandwidth` in `Centorrino_Florens_VOL_1.qmd`
**Current state (after R9-to-R7 revert):** R7-style bandwidth-explicit scaling with hand-waved per-iterate sub-Gaussian tail, plus the salvageable R8 polish.
**Date:** 2026-05-20
**Author:** theorist (paired with theorist-critic)
**Audit baseline:** R6 score 98/100 (constant-$c_{\mathrm{sub}}$ form); R7 aggregate 75/100 (bandwidth-explicit, hand-waved); R8 aggregate 84/100 (martingale-Bernstein attempt — structurally invalid for fixed-sample iteration); R9 aggregate 84/100 with deeper structural concerns (Talagrand step (a) sub-Gaussian assertion not derivable from cited references).
**Decision:** User has selected the R7 hand-waved form as the right resting state. Theory papers routinely state heuristic scalings with full derivation deferred. The R7 form is honest about what is hand-waved; R8/R9 claimed derivations that did not in fact go through.

---

## 1. Motivation (unchanged from R7)

The pre-refinement statement of `ass:app4(ii)` posited a fixed sub-exponential constant $c_{\mathrm{sub}} > 0$ independent of $m \le M_n$, with per-iterate tail bound $\mathbb{P}(\Vert\hat b'_m - b'_m\Vert > \tau V(m)) \le \exp(-c_{\mathrm{sub}}\tau^2)$. This is correct as written but hides the dependence of $c_{\mathrm{sub}}$ on the kernel bandwidth $h$ and the sample size $n$. The refinement makes the dependence explicit:
$$
c_{\mathrm{sub}}(n, h) = c_K \cdot n\, h^{d_K},
$$
where $h$ is the slowest-rate bandwidth among $(h_u, h_w, h_x)$, $d_K$ is the effective dimension of the corresponding kernel direction, and $c_K$ is a kernel-envelope constant depending only on the kernel order, the uniform bounds in `ass:unifbd`, the marginal-density floors of `ass:app1(ii)`, and the conditional-density floor $\kappa_n$ from `ass:app4(i)`.

Empirical motivation from `sec-mc-tau`: at $n = 500$, MI design, Silverman ROT, the realised ISE at $\tau \in \{1, 2\}$ is below the ISE at the recommended $\tau = 4$. With $(n, h)$ made explicit, the theoretically optimal $\tau$ depends on $nh^{d_K}$, and for moderate $n$ + Silverman bandwidth $\tau_n^*(h)$ lands in the lower half of the Mathé–Pereverzev band — matching the simulation finding.

---

## 2. Hand-waved derivation of $c_{\mathrm{sub}}(n,h) = c_K\, n\, h^{d_K}$

### 2.1 Operator-deviation Bernstein bound (cited from the literature)

For a kernel-based empirical operator $\hat{\mathsf{T}}(b_\dagger)$ built from a $d_K$-dimensional kernel with bandwidth $h$ (univariate $h_u$ for the FI route; multi-dimensional $h_w$ in the MI route with $d_K = q$), `@gine2002` Theorem 2.3 and `@hansen2008` Theorem 6 give the Bernstein-type concentration
$$
\mathbb{P}\bigl(\Vert\hat{\mathsf{T}}(b_\dagger) - \mathsf{T}(b_\dagger)\Vert > t\bigr) \le 2\exp\!\Bigl(-\frac{t^2}{2\sigma_n^2 + M_K t/3}\Bigr),
$$
with $\sigma_n^2 \asymp 1/(n h^{d_K})$, $M_K = M_K(\text{kernel envelope})$. In the variance-dominated regime $t = O((nh^{d_K})^{-1/2})$, this simplifies to $\mathbb{P}(\cdot > t) \le 2\exp(-C n h^{d_K} t^2)$.

### 2.2 Propagation through the LF recursion (hand-waved)

The iterate deviation has the linearization
$$
\hat b'_m - b'_m = -c \sum_{j=0}^{m-1}(I - c\hat{\mathsf{T}}'^*\hat{\mathsf{T}}')^{m-1-j}\hat{\mathsf{T}}'^*\bigl(\hat{\mathsf{T}}(b_\dagger) - \mathsf{T}(b_\dagger)\bigr) + \text{higher-order remainder},
$$
i.e. a deterministic bounded linear transformation of the operator deviation plus a quadratic remainder absorbed on the high-probability event $\mathcal{E}_n$ via `prp-koper`. Under `prp-convlf`'s step-size condition, the spectral-filter inequality $\sup_\lambda |g_m(\lambda)|^2 \le c\,m$ delivers an accumulated operator-norm $O(\sqrt m)$, which is absorbed into the variance proxy $V(m)$ from `lem-itervar` (whose $\sqrt m$ growth is exactly this factor). Hence — at the level of heuristic accounting — the per-iterate tail satisfies
$$
\mathbb{P}(\Vert\hat b'_m - b'_m\Vert > \tau V(m)) \le \exp(-c_K\, n h^{d_K}\, \tau^2)
$$
uniformly in $m \le M_n$.

### What is hand-waved (and why it is acceptable here)

The heuristic step is treating the per-iterate tail as if it inherits the per-step Bernstein exponent of the empirical operator, with the $\sqrt m$ accumulation absorbed into $V(m)$. A fully rigorous derivation would require either (a) a martingale-Bernstein argument — invalid because the LF iteration is a deterministic function of the fixed sample, with no natural martingale-difference structure; or (b) a uniform-in-class concentration argument across $\{1, \ldots, M_n\}$ via Talagrand — which requires a per-iterate sub-Gaussian tail that is not directly derivable from `@gine2002` / `@hansen2008` without an additional argument (the cited references give operator-norm Bernstein bounds, not Hilbert-space-norm sub-Gaussian bounds for $Z_m/V(m)$). Both routes were attempted in R8 and R9 and found to be structurally flawed.

The paper's statement explicitly flags this as a propagation claim sourced from the cited Bernstein literature plus the spectral-filter accounting; this is the level of detail standard in the inverse-problem literature (cf. `@bauerhohage2005`, `@werner2015`, `@hofmannmathe2007`, where the analogous propagation is similarly stated without a self-contained martingale or Talagrand derivation).

### 2.3 Identification of the slowest-rate bandwidth (unchanged from R7)

- **FI route, discrete $W$:** $h = h_u$, $d_K = 1$. The factor $nh_u$ controls the tail.
- **MI route, continuous $W$ of dimension $q$:** $h = h_w$, $d_K = q$. The factor $nh_w^q$ controls the tail.
- **MI route, discrete $W$:** $h = h_w$, $d_K = 1$ (the $W$-direction is discrete and contributes no smoothing).

---

## 3. Propagation through `prp-lepskii` (R7 form, with R8 $\sqrt m$ algebra preserved)

The Markov + union step:
$$
\mathbb{P}(\Omega_n) \;\ge\; 1 - M_n\,\exp\!\bigl(-c_K\, n h^{d_K}\, \tau^2\bigr).
$$
Setting the RHS to $1 - M_n^{-1}$ gives
$$
\tau_n^*(h) \;:=\; \sqrt{\frac{2\log M_n}{c_K\, n\, h^{d_K}}}.
$$
The $\sqrt m$ cancellation step (added in R8 as a polish independent of derivation route) is preserved in the proof: the $\sqrt m$ growth in the operator-noise propagation exactly cancels the $\sqrt m$ growth in $V(m)$, so the per-$m$ exponent in `eq-app4ii-conc` is independent of $m$.

The floor $\tau_0$ from Step 1 binds for $n$ large and standard bandwidth schedules; $\tau_n^*(h)$ may exceed $\tau_0$ for moderate $n$ or undersmoothed schedules.

---

## 4. R7-to-R9 reversion record

### What was reverted (R8/R9 → R7)

| Component | R8/R9 attempt | Reverted to R7 |
|---|---|---|
| `ass:app4(ii)` derivation | Step (a) per-iterate sub-Gaussian via $L^4$ + Bernstein; Step (b) Talagrand uniform-in-class (`eq-app4ii-perm`, `eq-app4ii-uniform`) | Single statement of `eq-app4ii-conc` with hand-waved propagation paragraph citing `@gine2002` / `@hansen2008` + spectral-filter inequality |
| `ass:app5` structure | Two clauses: (i) decoupled (`eq-bw-decoupled`); (ii) common-bandwidth with $h_u \asymp h_w \asymp h_x$ + density-floor side condition (`eq-bandwidthfloor`, `eq-kappa-floor`) | Single un-split statement: $h_u, h_w, h_x \to 0$ and $(n h_x^p h_u^3)^{-1}\ln n \to 0$ |
| `prp-lepskii` statement | Cites `ass:app5(ii)` and drops `ass:app5(i)` in MI | Cites `ass:app5` (no clause) and drops `ass:app5` in MI |
| `prp-lepskii` proof Markov+union | Talagrand inequality with `eq-app4ii-uniform`; sub-Gaussianity assertion | Direct union bound over `eq-app4ii-conc`; sentence on $\sqrt m$ cancellation kept |
| Bibliography (paper-level citations) | Added `@pinelis1994`, `@vandervaart1996`, `@blm2013` (R8/R9 attempts) | All three are no longer cited in the paper after revert |

### What was preserved across the revert (R8/R9 fixes that survive)

- **$d \to d_K$ rename** (R8 notation-warden fix): the kernel-direction dimension is consistently denoted $d_K$ throughout `ass:app4(ii)`, `prp-lepskii`, `rem:tau-bandwidth`, and `sec-mc-tau` (lines 845, 857).
- **`ass:app1(ii)` citation in $c_K$ dependence trace** (R8 assumption-auditor fix): the kernel-envelope constant's dependence on marginal-density floors is now stated explicitly.
- **$\sqrt m$ cancellation algebra in `prp-lepskii` proof** (R8 theorist-critic polish, derivation-route-independent): the proof now explicitly notes that the $\sqrt m$ growth in operator-noise propagation cancels the $\sqrt m$ in $V(m)$.
- **Corrected numerical band $0.32/\sqrt{c_K}$ in `rem:tau-bandwidth`** (R7 had the wrong 0.22 — arithmetic error in $\sqrt{14.6/144.3}$).
- **Honest framing in `rem:tau-bandwidth`**: "$\tau_n^*(h) < \tau_0$ at $n = 500$ for moderate-to-large $c_K$; refined theory's prediction at this sample size is consequently a prediction about $\tau_0$, not about $\tau_n^*(h)$."
- **Writer's prose update in `sec-mc-tau`**: connecting empirical evidence to $\tau_n^*(h)$, untouched (independent of the proof route).

### Bibliography entries

`@pinelis1994`, `@tropp2012`, `@blm2013`, `@vandervaart1996` are no longer cited anywhere in the paper after the revert. The bibliography file (`../instrumental.bib`) is shared across multiple projects in the user's `Nonparametric_IV` workspace; we leave the entries in place to avoid breaking sibling projects. They are uncited dead entries from this paper's perspective.

---

## 5. Projected score impact

R7 had aggregate ~75/100 with most deductions concentrated in regularity (~41/100), driven by the bandwidth-explicit propagation step that the regularity-checker flagged as not fully argued. The post-revert state retains the R7 hand-waved propagation but with R8 polish layered in:

| Component | R7 | R8 | R9 | Post-revert (projected) |
|---|---|---|---|---|
| Notation | ~80 (`d` collision) | 97 | 97 | ~97 ($d_K$ rename preserved) |
| Assumptions | ~85 (`c_K` trace missing `ass:app1(ii)`) | 95 | 95 | ~95 (`ass:app1(ii)` citation preserved) |
| Theorist-critic | 92 | ~85 | ~85 | ~92 (R7's structural cleanliness restored) |
| Regularity | ~50 (hand-waved propagation flagged) | ~55 (still hand-waved under martingale framing) | ~55 (Talagrand step (a) flagged) | ~50–60 (hand-waved propagation, flagged honestly) |
| Counterexample | clear | clear | clear | clear |
| **Aggregate** | **~75** | **~84** | **~84** | **~85** |

The post-revert state is honest about what is hand-waved (the propagation through the LF recursion) and does not claim derivations that do not work. Regularity will continue to flag the propagation as a concern; the paper's exposition acknowledges this and points to the cited literature for the standard accounting.

---

## 6. What is intentionally hand-waved

1. **The transition from the per-step Bernstein bound on $\Vert\hat{\mathsf{T}}(b_\dagger) - \mathsf{T}(b_\dagger)\Vert$ to the per-iterate sub-exponential bound on $\Vert\hat b'_m - b'_m\Vert / V(m)$.** The paper states this via the spectral-filter $\sqrt m$ accounting and the normalization by $V(m)$. A fully rigorous derivation would require either (a) a martingale-Bernstein argument (invalid in the fixed-sample LF setting) or (b) a uniform-in-class Talagrand argument with a derivable per-iterate sub-Gaussian tail (not derivable from `@gine2002` / `@hansen2008` without additional steps). This is acceptable for a theory paper at this stage, in line with the propagation accounting standard in the inverse-problem literature (`@bauerhohage2005`, `@werner2015`, `@hofmannmathe2007`).

2. **Uniformity in $m$ of the constant $c_K$.** The paper asserts that $c_K$ is independent of $m$. Under the hand-waved propagation, this follows from the $\sqrt m$ growth in operator-noise propagation cancelling the $\sqrt m$ in $V(m)$. A fully tight construction of $c_K$ — including, e.g., an explicit covering-number argument over $\{1, \ldots, M_n\}$ — is not provided.

3. **The variance-dominated regime side condition.** R8/R9 introduced an explicit side condition $n h^{d_K} \kappa_n / \log M_n \to \infty$ (the `eq-bandwidthfloor`) to enforce variance-domination of the Bernstein tail. The R7 form leaves this implicit in the cited Bernstein references; it is recoverable from the standard kernel-Bernstein regime but not stated as a separate assumption.

---

## 7. Files modified

- `Centorrino_Florens_VOL_1.qmd`:
  - `ass:app4(ii)` (lines 1024–1037): removed R9 Step (a)/(b) Talagrand structure; restored hand-waved propagation paragraph with $c_K$ dependence trace including `ass:app1(ii)` (R8 fix preserved).
  - `ass:app5` (lines 1039–1045): collapsed to single un-split statement; removed clauses (i)/(ii), `eq-bw-decoupled`, `eq-bandwidthfloor`, `eq-kappa-floor`.
  - `prp-lepskii` statement (line 616): citation reverted from `ass:app5(ii)` to `ass:app5`.
  - `prp-lepskii` proof Markov+union step (lines 1348ff): removed Talagrand+`eq-app4ii-uniform` invocation; restored direct union bound; kept the $\sqrt m$ cancellation sentence.
  - `prp-lepskii` proof off-event step: $2 M_n^{-1} \to M_n^{-1}$ for consistency with the single-tail form.
  - `rem:tau-bandwidth` (lines 1383–1394): unchanged from R8 (kept the corrected $0.32/\sqrt{c_K}$ band and the "$\tau_n^*(h) < \tau_0$ at $n=500$" honest framing).
  - `sec-mc-tau` (lines 843–857): unchanged (writer prose).

- `quality_reports/theory/volatility-loc-scale/lepskii_bandwidth_refinement.md`: this memo, rewritten to document the revert decision.

## 8. Open items

- **Calibration of $c_K$ in practice.** A small Monte-Carlo calibration matching the empirical sub-exponential tail of $\Vert\hat b'_m - b'_m\Vert / V(m)$ at one bandwidth would let practitioners use $\tau_n^*(h) \vee \tau_0$ directly. Flagged for the simulation-engineer.
- **A fully rigorous derivation of `eq-app4ii-conc`.** Both R8 (martingale-Bernstein) and R9 (Talagrand) attempts had structural flaws. A correct route would likely require either a self-contained uniform-in-class concentration argument with an explicit covering-number / chaining step, or a careful re-statement of the result conditional on a high-probability event on which the spectral filter is operator-bounded uniformly. Out of scope for the present paper; flagged as future work in the theory section.
- **The uncited bibliography entries** (`@pinelis1994`, `@tropp2012`, `@blm2013`, `@vandervaart1996`) are retained in the shared `../instrumental.bib` to avoid breaking sibling projects in the workspace.
