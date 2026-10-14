# Notation Audit — Proposition `prp-convlf` (Convergence of deterministic LF)

**File:** `/Users/samuele/Library/CloudStorage/Dropbox/Nonparametric_IV/Volatility/Centorrino_Florens_VOL_1.qmd`
**Scope:** Statement L437–448, proof L1022–1050.
**Date:** 2026-05-15. Reviewer: notation-warden agent.

## Section 1: Notation table (alphabetical)

| Symbol | First definition (file:line) | Used at |
|---|---|---|
| $\mathsf{A}_b = \mathsf{T}'_b D^{-1}$ | L359 (re-stated L454) | L1033–1036, L1048 |
| $\mathsf{A}^*_b$ | L368 (closed form L369–375) | L1032–1036, L1048 |
| $A_a$ | undefined; only mentioned L456 | L456 only |
| $b_j, b'_j$ | L362–365 (eq-lfalg) | proof passim |
| $\mathcal{B}_{b_\dagger}$ | L286 / L427 | L432, L445, L1028, L1030 |
| $c$ (LF step size) | L362–365 | proof passim |
| $D, D^{-1}$ | L351–355 | passim |
| $I$ (identity on codomain) | not introduced explicitly | L1034, L1036, L1048 |
| $\langle\cdot,\cdot\rangle$ | inferred from L174/L368 | L1032, L1033 |
| $M_4$ | L442 (eq-lfconv) | L1043, L1048 |
| $\mathsf{T}, \mathsf{T}'_b, \mathsf{T}'^*_b$ | L174, L250 | proof passim |
| $(\mathsf{T}'^*_{b_j}\mathsf{T}'_{b_j})^{-1}$ | L442 — convention not stated | L442, L1041, L1042 |
| $(\cdot)^{1/2}$ on positive operators | implicit functional calculus | L1034, L1036, L1041, L1048 |
| $\Vert\cdot\Vert$ | L174 | proof passim |

## Section 2: Collisions and inconsistencies

- **[HIGH] $(\mathsf{T}'^*_{b_j}\mathsf{T}'_{b_j})^{-1}$ — undefined inversion convention.** Compact Gram operator has 0 in spectrum; inverse unbounded on $L^2_X \times L^2_X$. L1041 inserts $(\mathsf{T}'^*_{b_j}\mathsf{T}'_{b_j})^{-1/2}(\mathsf{T}'^*_{b_j}\mathsf{T}'_{b_j})^{1/2}$ as identity without specifying convention.
- **[MEDIUM] $A_a$ at L456 — typography collision with $\mathsf{A}_b$.** Plain italic $A_a$ vs sans-serif $\mathsf{A}_b$ used everywhere else. Likely typo for $\mathsf{A}_a$.
- **[MEDIUM] $I$ at L1034, L1036, L1048 — used but not introduced.** Identity operator's domain ($L^2_{U\times W}$ for FI) clear from context but never stated.
- **[MEDIUM] $M_4$ vs $m_4$ near-collision.** $M_4 \ge 1$ at L442 (new) vs $m_4 < \infty$ at L266 (fourth-moment bound). Different objects, same indexing pattern. Risk of confusion.
- **[LOW] $\langle\cdot,\cdot\rangle$ at L1032–1033 — inner product not subscripted.** L1032 first uses $\mathcal{H}$ inner product, L1033 codomain inner product. Two different spaces, same symbol.
- **[LOW] Conclusion at L445.** Convergence stated for $b_j$; proof shows monotone decrease of $\|b'_j - b'_\dagger\|^2$ in $D[\mathcal{A}'_b]$. Bridge $b_j = D^{-1}b'_j$ implicit.
- **[LOW] Line-break typo at L1047–1048.** `\Vert b'_j - b'_\dagger\Vert^2` split mid-symbol (LaTeX compiles correctly but source is fragile).
- **[LOW] Implicit FI scope.** Closed-form $\mathsf{A}^*_b$ at L368–375 is FI-only; proof uses it without explicitly noting MI counterpart at L143–146.

## Section 3: Defined-but-unused / used-but-undefined

- **Used but undefined within scope:** $I$ (identity); $(\cdot)^{1/2}$ on positive operators; $(\cdot)^{-1}$ on Gram (already flagged HIGH).

## Section 4: Score

| Item | Severity | Deduction |
|---|---|---|
| $(\mathsf{T}'^*_{b_j}\mathsf{T}'_{b_j})^{-1}$ inversion convention | HIGH | -5 |
| $A_a$ typography collision (L456) | MEDIUM | -3 |
| $I$ not introduced | MEDIUM | -3 |
| $M_4$ vs $m_4$ near-collision | MEDIUM | -3 |
| LOWs × 4 ($\langle\cdot,\cdot\rangle$, conclusion phrasing, line break, FI scope) | LOW | -4 |
| Used but undefined × 3 ($I$, $(\cdot)^{1/2}$, $(\cdot)^{-1}$ — partial double-count with HIGH) | -2 each | -6 |

**Score: 100 - 5 - 9 - 4 - 6 = 76 / 100.**

## Section 5: Verdict

Notation is mostly internally consistent — sans-serif $\mathsf{T}, \mathsf{T}'_b, \mathsf{T}'^*_b, \mathsf{A}_b, \mathsf{A}^*_b$ used uniformly. The $b$/$b'$ coordinate distinction is observed faithfully. $M_4$ is introduced properly at first use. The score is held down by three issues:

1. **$(\mathsf{T}'^*_{b_j}\mathsf{T}'_{b_j})^{-1}$ used without specifying the inversion convention.** Compact Gram operators have unbounded inverses; the "identity" insertion at L1041 needs a range condition or pseudo-inverse convention. Notational gap with regularity teeth.
2. **Stray italic $A_a$ at L456** — typography slip relative to the sans-serif convention.
3. **$M_4$ vs $m_4$ near-collision** — uppercase/lowercase distinction is fragile under copyedit.

Other items are MINOR. The line-break typo at L1047–1048 compiles fine. The implicit FI-route scope mirrors `def-locid`'s convention. Recommended fix: a one-paragraph convention statement on the inverse Gram operator; rename $A_a \to \mathsf{A}_a$ at L456.

**Score 76 sits just below the 80 commit gate.**
