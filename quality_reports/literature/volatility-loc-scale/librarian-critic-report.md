# Librarian-Critic Report

**Date:** 2026-05-17.
**Project:** volatility-loc-scale (Centorrino & Florens, *Nonparametric Estimation of Location-Scale Models with Endogenous Regressors*).
**Phase:** Discovery (encouraging stance).
**Score: 84/100. PASS (≥80).**

## Headline verdict

Strong, well-curated bibliography for a theory paper at Ecta/ReStud/JoE altitude. 10-section thematic decomposition aligns with paper structure. Frontier map correctly identifies the empty cell (pair-valued × endogenous × nonparametric).

Main deductions concentrated on **BibTeX hygiene** — the paper compiles against keys that don't all match `references.bib`, plus one truly missing reference (Aitchison-Aitken 1976) used in the paper but absent from the bibliography.

## Score breakdown

| Category | Deduction |
|---|---:|
| Compile-blocking BibTeX issues | -4 |
| Aitchison-Aitken 1976 substantively missing | -5 |
| Missing primitive-completeness refs (D'Haultfœuille, Hu-Shiu) | -2 |
| Thin agricultural/production-function backdrop | -2 |
| Scope creep (3 tangential entries) | -1 |
| Loh duplication + Chen-Pouzo conflation | -2 |
| **Total** | **-16** |

## Compile-blocking issues (CRITICAL fix-first)

| Paper uses | references.bib has | Fix |
|---|---|---|
| `aitch1976` (L924) | **MISSING** | Add Aitchison & Aitken (1976) *Biometrika* 63(3), 413-420 |
| `li2008` (L955) | **MISSING** | Identify which Li paper, add entry |
| `carrasco2007` (L471) | `carrasco2007h` | Reconcile in qmd or bib |

These cause `latexmk` warnings/errors. Should be resolved before the writer-critic round.

## Substantive coverage gaps

1. **Aitchison-Aitken (1976)** — discrete product kernel foundational reference. The paper invokes it for the discrete-$W$ FI route's kernel structure.
2. **D'Haultfœuille (2011, ET) + Hu-Shiu (2018, JoE)** — primitive sufficient conditions for completeness. An Ecta referee will probe identification primitives.
3. **Gagliardini-Scaillet (2012, Ecta)** — Tikhonov for nonparametric IV CDF estimation. Relevant to the FI route's CDF-difference operator.
4. **Agricultural / production-function depth** — Chambers (1988) *Applied Production Analysis*, Mundlak (2001) handbook chapter. Currently only Just-Pope + Kumbhakar-Lovell + Centorrino-Pérez-Urdiales.

## Categorization issues

- Loh (2022, 2023) appears in both Section 1 and Section 7 — pick one.
- Chen-Pouzo (2012 Ecta) and Chen-Pouzo (2015 Annals) conflated in one annotation; bib correctly splits as `chen2012` and `chen2012b`. Annotate separately.
- Dunker (2018) is in the bib but only generically referenced in the annotated bibliography. Should have its own entry as a CORE methodological alternative invoked twice (L559, L1076).
- Mathé-Pereverzev (2003 *Geometry*) in bib but only the 2003 *Discretization* paper annotated. Both cited in the paper.

## What worked well

- Engl-Hanke-Neubauer (2000) annotated with chapter-level detail matching the paper's specific invocations.
- Carrasco-Florens-Renault (2007) handbook chapter correctly anchored as the regularization-vocabulary reference.
- 2023-2026 frontier coverage (CCK 2024, Florens-Lapenta 2024, Beyhum-Lapenta-Lavergne 2025, Chernozhukov-Newey-Santos 2023, Alejo et al. 2024, Bruns-Smith 2024) — comprehensive.
- Working-paper fraction ~8% (below the 50% threshold).
- Frontier map's two landscape diagrams correctly identify the empty cell.
- Positioning memo's referee composition (theorist + inverse-problems statistician + applied econometrician) is well-thought-out.

## Recommendations for the writer-critic

The bibliography supports a clean three-paragraph related-work structure:

1. **NPIV lineage** — Newey-Powell → Hall-Horowitz → Darolles et al. → Chen-Pouzo → CCK 2024 → Centorrino-Fève-Florens 2025. Frame: "single-function NPIV is mature; pair-valued is open."

2. **Inverse-problems toolkit** — Carrasco-Florens-Renault → Engl-Hanke-Neubauer → Hanke-Neubauer-Scherzer / Kaltenbacher-Neubauer-Scherzer → Dunker et al. → Bauer-Hohage / Mathé-Pereverzev / Cavalier-Tsybakov / Hoffmann-Reiss. Frame: "ingredients exist; contribution is assembly for pair-valued NPIV with empirical operators."

3. **Heteroskedasticity lineage** — Fan-Yao → Ruppert-Wand-Holst-Hössjer → Just-Pope → Centorrino-Pérez-Urdiales → Alejo et al. Frame: "joint mean-variance under exogeneity solved; under endogeneity only parametric — this paper closes the nonparametric gap."

**Must-cite in introduction:** CCK 2024, Chernozhukov-Newey-Santos 2023, Centorrino-Fève-Florens 2025, Alejo et al. 2024, Fan-Yao 1998, Newey-Powell 2003.

## Action items (priority order)

1. **(Compile-blocking)** Add `aitch1976` BibTeX entry.
2. **(Compile-blocking)** Resolve `li2008` — identify which Li paper.
3. **(Compile-blocking)** Reconcile `carrasco2007` vs `carrasco2007h`.
4. Add dedicated annotated entry for Dunker (2018, EJS).
5. Add separate entry for Mathé-Pereverzev (2003, Geometry).
6. Add D'Haultfœuille (2011, ET) and Hu-Shiu (2018, JoE) for primitive completeness.
7. Add Gagliardini-Scaillet (2012, Ecta) for the CDF-operator angle.
8. Deepen agricultural backdrop: Chambers (1988), Mundlak (2001).
9. Resolve Loh duplication; split Chen-Pouzo.

## Frontier map + positioning assessment

**Frontier map:** Excellent. Two landscape diagrams correctly identify the empty cell. "What is genuinely new" enumeration aligns with the paper's actual contribution.

**Positioning memo:** Realistic. Ecta → ReStud → JoE sequence appropriate. Cover-letter sketch should soften the "first treatment of pair-valued NPIV" claim slightly to acknowledge Alejo et al. (2024) parametric and Centorrino-Pérez-Urdiales (2023) parametric-frontier predecessors.

**Scooping risk register:** Conservative — actual risk slightly higher than "LOW" given the CCK program's velocity. Recommendation to submit promptly is correct.
