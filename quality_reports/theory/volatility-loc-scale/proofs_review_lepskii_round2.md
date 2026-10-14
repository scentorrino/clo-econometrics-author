# Round-2 Theorist-Critic Review: `prp:lepskii`

**Target:** `quality_reports/theory/volatility-loc-scale/{results.tex, proofs.tex, assumptions.tex, notation_glossary.md}`
**Severity:** HIGH (Execution phase)
**Round:** 2 of 3
**Prior:** Round-1 = 62/100 (three MAJOR gaps + two MINORs)

---

## Phase 1 — Claim Identification

The statement of `prp:lepskii` (results.tex L191–210) is verbatim Round-1 modulo cosmetic line shifts. **Unchanged.**

`lem:propagator` (results.tex L98–185) has been enlarged with a Lipschitz step \eqref{eq:Tlip} (L159–163) asserting $\|\hat{\mathsf T}'^*_b\hat{\mathsf T}'_b - \hat{\mathsf T}'^*_{b'}\hat{\mathsf T}'_{b'}\| \le L_{\mathsf T}\|b - b'\|$. $L_{\mathsf T}$ is bundled inside the lemma, no new top-level assumption. **Statement OK; derivation examined below.**

---

## Phase 2 — Per-Gap Verification

| Gap | Round-1 status | Round-2 fix | Verdict |
|---|---|---|---|
| **G1** (sub-Gaussian for $m \ge 2$) | asserted | four-term decomp, results.tex L310–403 | **PARTIAL** |
| **G2** ($R_{m,j}$ absorption) | hand-waved | Lipschitz \eqref{eq:Tlip} + display \eqref{eq:Rabsorb-piece}–\eqref{eq:Rabsorb-total}, results.tex L487–525 | **FAILED** |
| **G3** ($L^8$ induction) | asserted | Cauchy–Schwarz display \eqref{eq:Lqdisp}, Jensen at L277–283 | **FAILED** |
| **MINOR Step 4 $c \to \kappa$** | $c$ reused | renamed throughout | **OK** |
| **MINOR Step 5 $o(\cdot)$** | loose | explicit second-derivative bound L598–615 | **OK** |

### G1 — Four-term decomposition

- **$II_m$ (L337–352).** Hansen (2008) Thm 2 on $\hat{\mathsf T}(b_\dagger) - \mathsf T(b_\dagger)$, then LF spectral filter on event $\Omega'_n$. **OK.**
- **$IV_m$ (L354–371).** Cauchy-Schwarz factorization with deterministic bound on $\Omega_n \cap \Omega'_n$. Tolerated circularity (the event being estimated bounds the inductive quantity). **[MINOR]** -2.
- **$III_m$ (L373–382).** Claimed: $\|III_m\| \le \hat M\tau^2 V(m)^2$ deterministically on $\Omega_n$. **Verification fails**: each remainder is $\le \hat M\|\hat e_j\|^2 \le \hat M\tau^2 V(j)^2$, but $III_m$ is a *sum* weighted by the spectral filter, contributing $\sum (m-j)^{-1/2} = O(\sqrt m)$. Correct deterministic bound: $\|III_m\| \le C\hat M\tau^2 V(m)^2\sqrt m$. Bound is $o(V(m))$ iff $\sqrt m V(m) = o(1)$, i.e., $\delta_n m \to 0$. With `ass:mn-growth` $M_n \asymp \delta_n^{-2}$, $\delta_n m = \delta_n^{-1} \to \infty$ at $m = M_n$. **Wrong at upper end. [MAJOR]** -10.
  - Additionally inconsistent with G3 display ($E\|III_m\|^2 = O(V(m)^4\log m)$).
- **$I_m$ (L384–393).** Absorbing via "$m\gamma_n = o(\sqrt m \delta_n)$ under `ass:restrvarth`." Verification: at $m = M_n \asymp \delta_n^{-2}$, $\sqrt m \gamma_n/\delta_n = \gamma_n/\delta_n^2$ — not directly delivered by `ass:restrvarth`(i). Asserted. **[MINOR]** -2.

### G2 — Lipschitz step and absorption

**Lipschitz step \eqref{eq:Tlip} (L164–177).** Derivation cites `ass:frediff` + `prp:koper`(b) + `prp:koper`(a). But `prp:koper`(a) provides a **quadratic Fréchet remainder bound**, NOT a Lipschitz bound on $b \mapsto \hat{\mathsf T}'_b$. The Lipschitz constant requires *second-order* Fréchet differentiability ($C^2$-type), not in the assumption block. The text bundles $\hat M$ "into $L_{\mathsf T}$" (L176–177), but $\hat M$ controls the quadratic remainder, not the derivative-Lipschitz constant. **Non-sequitur. [MAJOR]** -10.

**Absorption display (L487–525).** Algebraic chain:
- \eqref{eq:Rabsorb-piece}: $E\|R_{m,j}(\cdot)\|^2 \le c^2L_{\mathsf T}^2(m-j)^2 V(m)^2\delta_n^2$. **OK modulo Lipschitz issue.**
- \eqref{eq:Rabsorb-total}: sum gives $C\delta_n^2 m^3 V(m)^2$.
- Theorist claims this is $o(m V(m)^2)$ "under `ass:restrvarth`(i) — which delivers $\delta_n^2 M_n \to 0$, hence $\delta_n^2 m^3 = o(m)$ uniformly in $m \le M_n$" (L518–520).

**Rate verification.** `ass:restrvarth`(i) gives $\delta_n N = O(1)$; `ass:mn-growth` gives $M_n \asymp \delta_n^{-2}$. So $\delta_n^2 M_n \asymp \delta_n^2 \cdot \delta_n^{-2} = \Theta(1)$, **NOT $\to 0$** as written. The required step is $\delta_n^2 m^2 = o(1)$ uniformly. At $m = M_n$: $\delta_n^2 M_n^2 = \delta_n^{-2} \to \infty$. **Absorption fails at the upper Lepskii range by a factor of $\delta_n^{-2}$.** Residual grows like $\delta_n^{-2}\cdot V(m)^2$ at $m \asymp M_n$ — three orders away from $V(m)^2$. Induction underlying `lem:itervar` cannot close. **[CRITICAL]** -15.

### G3 — Cauchy–Schwarz + Jensen

**Cauchy–Schwarz display \eqref{eq:Lqdisp}.** Exponents on inner moments **appear off by factor of 2**. Cosmetic. **[MINOR]** -3.

**Jensen step at L277–283.** Theorist asserts $(E\|\hat e_j\|^8)^{1/4} \le C_8 E\|\hat e_j\|^2$ via "$L^p$-norm equivalence on the bounded ball using `ass:iterbd`."

**This is the wrong direction of Jensen.** Standard Jensen: for $p \ge q \ge 1$, $(E X^q)^{1/q} \le (E X^p)^{1/p}$, hence $E\|\hat e_j\|^2 \le (E\|\hat e_j\|^8)^{1/4}$ — **opposite direction**.

Can `ass:iterbd` rescue this? It gives $\sup_m E\|\hat b'_m\|^4 \le C_4$ in expectation, NOT pathwise boundedness. With only $L^4$-in-expectation, $E\|\hat e_j\|^8 \le K E\|\hat e_j\|^4$ requires a pathwise bound $\|\hat e_j\|^4 \le K$ — not delivered.

If pathwise boundedness on $\Omega_n$ ($\|\hat e_j\|^2 \le \tau^2 V(j)^2$) were used: $\|\hat e_j\|^8 \le \tau^6 V(j)^6\|\hat e_j\|^2$, so $(E\|\hat e_j\|^8)^{1/4} \le \tau^{3/2} V(j)^{3/2}(E\|\hat e_j\|^2)^{1/4}$ — **not $C_8 E\|\hat e_j\|^2$**. Dependence is $(E\|\hat e_j\|^2)^{1/4}$.

Gaussian hypercontractivity would yield $(E\|X\|^{2k})^{1/k} \le C_k E\|X\|^2$ for sub-Gaussian $X$, but `ass:subgauss` is on $U|X,W$, NOT on $\hat e_j$. The iterates inherit sub-Gaussianity only under an additional argument not displayed.

**The Jensen step is wrong as written.** The chain to $E\|III_m\|^2 = O(V(m)^4 \log m) = o(V(m)^2)$ is broken. **[CRITICAL]** -15.

### MINOR fixes

- **$c \to \kappa$ rename.** Verified L412, L549–551, L559; proofs.tex L149–150. **OK.**
- **Step 5 second-derivative bound.** Verified L598–615. **OK.**

---

## Phase 3 — Regression Check

Spot-checked CR2, M2, M3, M4, M5, MN1–MN10. **All Round-1 clean patches preserved. No regressions.**

---

## Phase 4 — Polish

- **Notation.** $\kappa$, $L_{\mathsf T}$ consistent.
- **Cross-references.** All `\eqref{}` resolve.
- **Hansen (2008) cite.** Plain-text "Hansen (2008, Theorem~2)" instead of `\citet[Theorem~2]{hansen2008}`. **[MINOR]** -2.
- **Duplicate `% PATCH-MN10`** at proofs.tex L243. **[MINOR]** -2.

---

## Score

| Item | Severity | Deduction |
|---|---|---|
| G3 backwards Jensen | CRITICAL | -15 |
| G2 rate algebra ($\delta_n^2 M_n \to 0$ misread) | CRITICAL | -15 |
| G2 Lipschitz \eqref{eq:Tlip} non-sequitur from `prp:koper`(a) | MAJOR | -10 |
| G1 $III_m$ off by $\sqrt m$; inconsistent with G3 | MAJOR | -10 |
| G1 $I_m$ absorption not derived from `ass:restrvarth` | MINOR | -2 |
| G1 $IV_m$ circular framing on $\Omega_n$ | MINOR | -2 |
| G3 Cauchy–Schwarz inner exponents off by 2 | MINOR | -3 |
| Hansen cite plain-text | MINOR | -2 |
| Duplicate `PATCH-MN10` | MINOR | -2 |

**Total: -61. Score: 39/100.**

---

## Verdict

**39/100. NO-GO. ESCALATE TO USER.**

The Round-2 surgical patches were ambitious — display previously hand-waved steps — and **regressed** the proof. By displaying G2 and G3 explicitly, the theorist exposed two errors latent in Round 1:

1. **G3's backwards Jensen.** $(E\|\hat e_j\|^8)^{1/4} \le C_8 E\|\hat e_j\|^2$ does not follow from `ass:iterbd` ($L^4$-in-expectation). Standard Jensen goes the other way. Requires hypercontractivity or sub-Gaussian iterates, neither stated.
2. **G2's rate algebra.** $\delta_n^2 M_n \to 0$ contradicts `ass:restrvarth`(i) + `ass:mn-growth` which give $\delta_n^2 M_n = O(1)$. Required bound $\delta_n^2 m^2 = o(1)$ fails at $m \asymp M_n$ by factor $\delta_n^{-2}$.

Per `permissions.md` ESCALATION_TARGET, this requires user adjudication. Three options:

- **Option A.** Strengthen `ass:rateconv` to deliver hypercontractive bounds on $\hat e_j$ (e.g., assume sub-Gaussian iterates directly, or moment-equivalence on $\mathcal B_{b_\dagger}$).
- **Option B.** Tighten `ass:mn-growth` from $M_n \asymp \delta_n^{-2}$ to $M_n = o(\delta_n^{-2/3})$, restricting the Lepskii horizon and risking $m^*(n) > M_n$.
- **Option C.** Reformulate the G2 absorption via Hilbert-scale interpolation between the propagator residual and the bias, avoiding the $m^3$ summation. Substantive rewrite.

**Files reviewed (absolute paths):**
- `quality_reports/theory/volatility-loc-scale/results.tex` (708 lines)
- `quality_reports/theory/volatility-loc-scale/proofs.tex` (319 lines)
- `quality_reports/theory/volatility-loc-scale/assumptions.tex` (154 lines, Round-1 unchanged)

**Load-bearing problem lines:**
- results.tex L278–283 (backwards Jensen at G3)
- results.tex L518–520 (rate algebra error at G2)
- proofs.tex L67–69 (Jensen condensed)
- proofs.tex L232–233 (rate algebra condensed)
- results.tex L164–177 (Lipschitz from quadratic remainder)
- results.tex L378–380 ($III_m$ missing $\sqrt m$)
