# Regularity Audit — Proof of Proposition `prp-convlf` (deterministic LF convergence)

**File:** `/Users/samuele/Library/CloudStorage/Dropbox/Nonparametric_IV/Volatility/Centorrino_Florens_VOL_1.qmd`
**Statement:** L439–446; **Proof:** L1022–1050.
**Date:** 2026-05-15. Reviewer: regularity-checker agent.

## Section 1: Per-concern table

| # | Concern | Site | Verdict | Patch |
|---|---|---|---|---|
| 1 | Polarization at L1031–1033 uses $\mathsf{A}_{b_j}(b'_j - b'_\dagger) = \mathsf{T}'_{b_j}(b_j - b_\dagger)$, requires $b'_j \in D[\mathcal{A}'_b]$ | L1031–1033 | FLAG (MINOR) | One-line: iterates stay in $D[\mathcal{A}'_b]$ by recursion + $\mathsf{A}^*$ range |
| 2 | Square-completion at L1034 requires $c\|\mathsf{A}^*_b\mathsf{A}_b\| \le 1$ for positivity of $I - c\mathsf{A}\mathsf{A}^*$ | L1034 | **FLAG (CRITICAL)** | Add step-size hypothesis to proposition (currently only mentioned at L401 as implementation note) |
| 3 | L1037 inequality $\|\mathsf{T}(b_j) - \mathsf{T}'_{b_j}(b_j-b_\dagger)\|^2 \le \|\mathsf{T}'_{b_\dagger}(b_j-b_\dagger)\|^2$ | L1037–1039 | FLAG (MAJOR) | Cite mean-value at L965–967 + kernel-difference at L982–984 (uses `ass:unifbd`(i)-(iii)) + `def-sourceID` |
| 4 | L1041 identity insertion $(\mathsf{T}'^*_{b_j}\mathsf{T}'_{b_j})^{-1/2}(\mathsf{T}'^*_{b_j}\mathsf{T}'_{b_j})^{1/2}$ — unbounded inverse | L1041 | **FLAG (CRITICAL)** | Add range/pseudo-inverse convention; require $b_j - b_\dagger \in \text{Ran}((\mathsf{T}'^*_{b_j}\mathsf{T}'_{b_j})^{1/2})$; `eq-lfconv` implicitly defines this |
| 5 | L1042 operator-norm step — standard | L1042 | FLAG (MINOR) | Cite Engl-Hanke-Neubauer Lemma 2.5 |
| 6 | L1050 strictness — needs $(I - c\mathsf{A}\mathsf{A}^*)^{1/2}$ injective on $\text{Ran}(\mathsf{T})$ | L1050 | FLAG (MINOR) | Add: under strict $c\|\mathsf{A}^*_b\mathsf{A}_b\| < 1$, injective; ties to concern 2 |
| 7 | Induction $b_j \in \mathcal{B}_{b_\dagger}$ from $b'$-monotonicity — metric mismatch | L1028, L1030 | FLAG (MAJOR) | Bridge via $\|b_j - b_\dagger\| \le \|D^{-1}\| \cdot \|b'_j - b'_\dagger\|$; argue source condition preserved across iterates |
| 8 | $M_4 = 1$ boundary case — geometric rate vs sublinear | L442, L1048 | FLAG (MINOR) | One-line: at $M_4 = 1$, sublinear convergence via Fejér monotonicity |
| 9 | Line-break typo L1047–1048 | L1047–1048 | FLAG (MINOR) | Cosmetic; LaTeX-correct but source fragile |
| 10 | $(I - c\mathsf{A}\mathsf{A}^*)^{1/2}$ as bounded operator | L1034 | FLAG (MINOR) | Spectral theorem; ties to concern 2 |
| 11 | Weighted Hilbert structure on $L^2_X, L^2_{U\times W}$ | throughout | CAPTURED | No action |
| 12 | Fréchet derivative existence at iterates | L1033, L1037, L1042 | CAPTURED (via `ass:unifbd` + L243–254) | No action beyond concern 1 |

## Section 2: Score

| Item | Severity | Deduction |
|---|---|---|
| Concerns 2, 4 — silent step-size + unbounded inverse | CRITICAL × 2 | -30 |
| Concerns 3, 7 — L1037 chain + metric mismatch | MAJOR × 2 | -20 |
| Concerns 1, 5, 6, 8, 9, 10 — 5 MINOR (concern 10 absorbed into 2) | MINOR × 5 | -15 |

**Score: 100 - 65 = 35 / 100.**

## Section 3: Verdict

The proof is recognizable as the standard Hanke-Neubauer-Scherzer Landweber argument adapted to the location-scale operator $\mathsf{T}_{\text{FI}}$ in $b'$-coordinates. The algebraic core (L1030–1048) is correct in outline. But the 29-line proof leans on **three** non-trivial regularity invocations that are entirely silent, two of which are load-bearing.

**CRITICAL 1 (L1034) — silent step-size threshold.** The square-completion $-c\|(I - c\mathsf{A}_{b_j}\mathsf{A}^*_{b_j})^{1/2}\mathsf{T}(b_j)\|^2$ requires $(I - c\mathsf{A}\mathsf{A}^*)$ to be positive semi-definite, i.e., $c\|\mathsf{A}^*_b\mathsf{A}_b\| \le 1$ uniformly on $\mathcal{B}_{b_\dagger}$. This is mentioned at L401 as practical implementation, but is absent from the proposition's hypotheses (L440 lists only `ass:identif`, `ass:initcond`, eq-lfconv). Without this threshold, $(I - c\mathsf{A}\mathsf{A}^*)^{1/2}$ does not exist as a bounded self-adjoint operator, the first negative term can have the wrong sign, and the monotonicity argument collapses. **Fix:** add to the hypothesis block.

**CRITICAL 2 (L1041) — unbounded inverse Gram.** The "identity" $(\mathsf{T}'^*_{b_j}\mathsf{T}'_{b_j})^{-1/2}(\mathsf{T}'^*_{b_j}\mathsf{T}'_{b_j})^{1/2}$ is the identity only on $\text{Ran}((\mathsf{T}'^*_{b_j}\mathsf{T}'_{b_j})^{1/2})$; since $\mathsf{T}'^*_{b_j}\mathsf{T}'_{b_j}$ is compact, this is a dense proper subspace and the inverse is unbounded. The proof needs $b_j - b_\dagger$ to lie in this range — a genuine source condition at the iterate, not just at $b_\dagger$. `def-sourceID` gives Fourier decay relative to $\mathsf{T}'^*_{b_\dagger}\mathsf{T}'_{b_\dagger}$, related but not identical to membership in the range at $b_j$. The condition eq-lfconv presupposes that the product operator is bounded, which is an implicit constraint on the spectra. **Fix:** state the range condition explicitly; cite eq-lfconv as the bound that defines the relevant range.

**MAJOR (L1037) — telegraphic pointer.** The inequality with constant 1 is not prp-onetoone(iii). The actual derivation needs: (a) mean-value theorem for Fréchet derivatives, (b) Lipschitz-in-$b$ property of $\mathsf{T}'_b$ from L982–984, (c) `def-sourceID` to convert $M\|b - b_\dagger\|^2$ into $\|\mathsf{T}'_{b_\dagger}(b - b_\dagger)\|$. None of these is at L1037. **Fix:** one paragraph spelling out the chain.

**MAJOR (concern 7) — metric mismatch.** Monotonicity is shown in $\|b'_j - b'_\dagger\|^2$; $\mathcal{B}_{b_\dagger}$ is defined in $\|b - b_\dagger\|$. The bridge $b = D^{-1}b'$ gives a *static* operator-norm bound but does not preserve a fixed radius $R$ across iterates unless the initial ball is scaled by $\|D^{-1}\|$. The source condition $\mathcal{B}^*_M$ preservation under recursion needs a Fourier-coefficient argument. **Fix:** add one paragraph routing the metric bridge.

Five MINOR flags are typographic/expository or expand on the CRITICAL/MAJOR concerns: the polarization identity needs one explicit line about $b'_j \in D[\mathcal{A}'_b]$ being preserved; the operator-norm step is routine; strictness at L1050 inherits the step-size issue; the $M_4 = 1$ boundary admits convergence but not at geometric rate; the line-break at L1047–1048 is cosmetic.

**Score 35/100.** This is far below all gates. The proof's logic is correct under the standard LF regularity package, but the proposition's stated hypothesis block and proof citations only cover two of the four conditions actually needed. None is hard to fix — each is a one-to-three-sentence patch in the right location. The theorist should treat this as a clean rewrite of the hypothesis block plus three pointer-citations in the proof body, not a substantive change.
