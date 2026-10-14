# Assumption-Usage Matrix — Proposition `prp-onetoone`

**Scope:** Local-identification proposition at L189–198 of `Centorrino_Florens_VOL_1.qmd`, proof at L950–961, with primitive deliveries from sec-primitive (L241–287) and sec-condcomp (L202–227).
**Date:** 2026-05-15. Reviewer: assumption-auditor agent.

## Section 1: Usage Matrix

### Conditions (i)–(iv) — proposition's direct hypotheses

| Condition | Statement (short) | Cited at | Primitive | Strength used |
|---|---|---|---|---|
| (i) | $\mathsf{T}$ Fréchet differentiable for all $b \in \mathcal{A}_b$ | L952 | `ass:differentiability` (L246) | **Partial** — proof needs differentiability at $b_\dagger$ only; "for all $b$" needed by auxiliary lemma at L963 |
| (ii) | $\mathsf{T}'_{b_\dagger}$ one-to-one | L954 | `ass:condcomp` (L209–225) | **Full** |
| (iii) | $\exists M$: quadratic remainder bound for $b \in \mathcal{B}_R$ | L957 | `ass:unifbd` (L259–267) via proof at L963 | **Full** |
| (iv) | $\mathcal{B}_M = \{b : \|\mathsf{T}'_{b_\dagger}(b - b_\dagger)\| > M\|b - b_\dagger\|^2\}$, same $M$ | L959 | `def-sourceID` + $\mathcal{B}^*_M \subseteq \mathcal{B}_M$ at L281 | **Full** |

### Primitive assumptions

| Primitive | Direct use in prp-onetoone? | Delivers | Clauses not consumed |
|---|---|---|---|
| `ass:differentiability` (L246) | No — only delivers (i) | (i) | None (minimal) |
| `ass:condcomp` (L209) | No — only delivers (ii) | (ii) | None for prp-onetoone |
| `ass:unifbd` (L259) | No — only delivers (iii) | (iii) | Compactness corollary at L269 used downstream, not in prp-onetoone |
| `def-sourceID` (L273) | No — delivers (iv) via $\mathcal{B}^*_M \subseteq \mathcal{B}_M$ | (iv) | None |

## Section 2: Findings

### UNUSED conditions
**None.** All four (i)–(iv) are explicitly invoked. Two-case contradiction structure cleanly partitions use of (ii) from (iii)+(iv); (i) licenses the Fréchet expansion.

### OVER-STRONG primitive assumptions
**None.** (i)'s "for all $b$" quantifier is over-strong relative to the *proof of prp-onetoone in isolation* but is needed by the supporting lemma at L963 (mean-value theorem along path $b_t$). The compactness corollary at L269 of `ass:unifbd` is a free byproduct, not an extra clause.

### UNDER-STATED conditions
**None substantive.** One clarity-only flag: the proof at L957 implicitly requires $b^* \in \mathcal{B}_R$ for (iii) to apply. This is automatic since $b^* \in \mathcal{B}_{b_\dagger} = \mathcal{B}_R \cap \mathcal{B}_M$, but a parenthetical would tighten the exposition.

## Section 3: Score

| Type | Count | Deduction |
|---|---|---|
| UNUSED | 0 | 0 |
| UNDER-STATED | 0 | 0 |
| OVER-STRONG | 0 | 0 |

**Score: 100 / 100.**

## Section 4: Verdict

`prp-onetoone` is an exceptionally tight piece of bookkeeping. The proposition is unusual in that its four conditions (i)–(iv) are the proposition's *hypotheses*, with primitive deliveries organized separately in sec-condcomp and sec-primitive. This compresses the audit: hypotheses ARE the assumptions, and each is invoked by name at a specific proof line. The contradiction argument cleanly partitions into the kernel case (uses (ii)) and the non-kernel case (uses (iii) and (iv) jointly with the Fréchet expansion licensed by (i)). Constant $M$ is shared between (iii) and (iv) by explicit statement. Radius $R$ is the same in $\mathcal{B}_R$ and in scope of (iii). Proof uses $\mathcal{B}_M$ directly, leaving the strictly stronger $\mathcal{B}^*_M$ for downstream `prp-condcomp`. The "for all $b$" scope of (i) is justified by the auxiliary lemma at L963. No condition is silently invoked; no condition is unused. The assumption block is minimal and tight.
