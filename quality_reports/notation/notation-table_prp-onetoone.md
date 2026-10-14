# Notation Audit — Proposition `prp-onetoone`

**File audited:** `/Users/samuele/Library/CloudStorage/Dropbox/Nonparametric_IV/Volatility/Centorrino_Florens_VOL_1.qmd`
**Scope:** Statement (L189–198), discussion of (i)–(iv) (L199–200), Proof (L950–961). Secondary scope: L95–101, L117–125, L127–168, L172–188, L271–281.
**Date:** 2026-05-15. Reviewer: notation-warden agent.

---

## Section 1 — Notation table (alphabetized)

| Symbol | First definition (file:line) | Used at (file:line) |
|---|---|---|
| $b$ (running pair) | L117 ($b = (g, \omega)$) | L182, L186, L191, L192, L193, L194, L195 |
| $b_\dagger$ (true pair) | L117 ($b_\dagger = (g_\dagger, \omega_\dagger)$) | L182, L186, L191–197, L952–961 |
| $b^*$ (contradictory pair, proof only) | L952 | L952, L954, L955, L957, L959, L961 |
| $(g, \omega)$ (components of $b$) | L117 | L121, L194 |
| $g_\dagger, \omega_\dagger$ | L117 | L121, L135, L142–146, L156, L162 |
| $\tilde b = (\tilde g, \tilde\omega)$ (perturbation) | L119 | L121, L131–133, L166–168, L194 |
| $L^2_X \times L^2_X$ | L97 | L99, L100, L117, L174, L192 |
| $L^2_W \times L^2_W$ | L131 | L139, L174 (MI codomain) |
| $L^2_{U \times W}$ | L164 | L174 (FI codomain) |
| $\mathcal{A}, \mathcal{A}_b$ | L100, L117 | L131, L164, L174, L182, L186, L191, L195 |
| $T_{\text{MI}}$ (italic) | L129/eq-tmi | L131, L182, L190 |
| $\mathsf{T}_{\text{FI}}$ (sans-serif) | L162/eq-nlmomeq | L164, L168, L174, L182, L190 |
| $\mathsf{T}$ (route-agnostic) | L174 | L182, L190–195, L952–961 |
| $\mathsf{T}'_b$ (Fréchet derivative) | L174 | L191, L194, L195, L952–961 |
| $\Vert \cdot \Vert$ | L174 | L182, L186, L194, L195, L957 |
| $\mathcal{B}_R$ | L185–186 | L193, L197 |
| $R$ (radius) | L186 | L193 |
| $M$ (constant) | L193 | L194, L195, L957, L959 |
| $\mathcal{B}_M$ | L195 | L197, L271, L281, L959 |
| $\mathcal{B}_{b_\dagger}$ | L182 (abstract), L197 (concrete) | L182, L197, L952, L961 |
| $\mathcal{B}^*_M$ (source-condition variant) | L277 | L281, L286 — NOT in prp-onetoone |
| (i)–(iv) labels | L191–195 | L200, L952–959 |

---

## Section 2 — Collisions and inconsistencies

- **[HIGH] $\mathsf{T}$ vs $T$ typographic dispatch is ambiguous.** L129/L131 use *italic* $T_{\text{MI}}$. L162/L164 use *upright sans-serif* $\mathsf{T}_{\text{FI}}$. L174 says "drop the subscript and write $\mathsf{T}$" using sans-serif. The umbrella $\mathsf{T}$ silently re-tags the MI operator (which was previously italic). Same affects derivatives: italic at L133/L137/L139, sans-serif at L166/L168/L174/L191–195.

- **[MEDIUM] $\mathcal{B}_M$ vs $\mathcal{B}^*_M$.** Within prp-onetoone only $\mathcal{B}_M$ appears; prp-condcomp at L286 silently switches the conclusion to $\mathcal{B}_R \cap \mathcal{B}^*_M$. Visually close.

- **[MEDIUM] $\mathcal{B}_{b_\dagger}$ abstract-vs-concrete.** def-locid (L182) declares it as abstract neighborhood; prp-onetoone (L197) concretely sets $\mathcal{B}_{b_\dagger} = \mathcal{B}_R \cap \mathcal{B}_M$. Assignment vs use ambiguity.

- **[LOW] $M$ overloaded with $M_\eta, M_2, M_3, m_4$ in paper.** Within prp-onetoone scope, no collision — $M$ is one consistent constant.

- **[LOW] $\Vert\cdot\Vert$ unsubscripted on mixed domain/codomain.** In (iii) the norm on the LHS is in the codomain, on the RHS is in the domain. Standard but unsubscripted.

- **[LOW] $R$ (radius) vs $R_\sigma, R^\sigma$ family.** Three uses of letter $R$ disambiguated by subscripts.

- **[LOW] Codomain of $\mathsf{T}$ in (ii) is implicit.** "Codomain of $\mathsf{T}$" — route fixes it.

---

## Section 3 — Defined-but-unused / used-but-undefined

Within scope of prp-onetoone:
- **Used-but-undefined:** None.
- **Defined-but-unused:** $\mathcal{B}^*_M$ (L277) — not supposed to appear; reserved for prp-condcomp.
- Route-specific $T_{\text{MI}}$ and $\mathsf{T}_{\text{FI}}$ only via cross-references, absorbed into $\mathsf{T}$.

---

## Section 4 — Score

| Item | Severity | Deduction |
|---|---|---|
| $\mathsf{T}$/$T$ typographic dispatch | HIGH | -5 |
| $\mathcal{B}_M$ vs $\mathcal{B}^*_M$ seam | MEDIUM | -3 |
| $\mathcal{B}_{b_\dagger}$ abstract/concrete | MEDIUM | -3 |
| 4 LOW × -1 | LOW | -4 |

**Score: 85 / 100.**

---

## Section 5 — Verdict

The notation in `prp-onetoone` is substantively consistent and internally complete: every symbol used in the statement and contradiction proof has a prior, unambiguous definition, and the proof closes cleanly using exactly the four labeled conditions. The single material issue is the **typographic dispatch between italic $T_{\text{MI}}$ and upright sans-serif $\mathsf{T}_{\text{FI}}$**, combined with the route-agnostic umbrella symbol $\mathsf{T}$ at L174. The cleanest fix is either to typeset both operators sans-serif from the outset, or to make the umbrella symbol italic, or to add a sentence at L174 stating that the typography of the umbrella symbol is a convention. The two MEDIUM items concern the $\mathcal{B}$-family seam with the surrounding text (prp-condcomp silently strengthens to $\mathcal{B}^*_M$; abstract-vs-concrete $\mathcal{B}_{b_\dagger}$). The four LOW items are stylistic. The proof itself is fully aligned with the statement — no notation defect inside the contradiction argument.
