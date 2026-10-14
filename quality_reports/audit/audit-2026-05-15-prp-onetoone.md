# Theory Audit — 2026-05-15 (target: `prp-onetoone`)

**Target:** Proposition `prp-onetoone` (abstract local-identification, adapted from @chenlee2013 to pair-valued setting).
**Source:** `/Users/samuele/Library/CloudStorage/Dropbox/Nonparametric_IV/Volatility/Centorrino_Florens_VOL_1.qmd` (no repo artifacts).
**Mode:** AUDIT-IN-PLACE. Three mechanical critics. No `--counter` / `--derive` flags.

## Summary

| Critic | Score | Findings |
|---|---|---|
| **notation-warden** | **85 / 100** | 1 HIGH, 2 MEDIUM, 4 LOW |
| **assumption-auditor** | **100 / 100** | 0 UNUSED, 0 OVER-STRONG, 0 UNDER-STATED |
| **regularity-checker** | **81 / 100** | 0 CRITICAL, 1 MAJOR, 3 MINOR |

Aggregate (unweighted average): **89 / 100** — well above the 80 commit gate.

## Critical findings (escalations)

**None.** No confirmed counterexample (not run), no CRITICAL regularity gap, no contradictory conditions. The proof is short (10 lines) and well-structured. The single MAJOR finding is a documentation issue, not a logical one.

## Detailed reports

- `quality_reports/notation/notation-table_prp-onetoone.md`
- `quality_reports/assumptions/usage-matrix_prp-onetoone.md`
- `quality_reports/regularity/regularity-audit_prp-onetoone.md`

## Action items (consolidated, prioritized)

### MAJOR — block PR gate (but not commit gate)
- [ ] **L952 — silent route dispatch via \eqref{eq-frechet}.** The proof cites the FI-only kernel form of the Fréchet derivative, even though the proposition is supposed to be route-agnostic. Cleanest fix: replace "Condition (i) gives Fréchet differentiability and \eqref{eq-frechet} for $\mathsf{T}'_{b_\dagger}$" with "Condition (i) supplies a bounded linear Fréchet derivative $\mathsf{T}'_{b_\dagger}$ at $b_\dagger$ (given concretely by \eqref{eq-tmider} under MI and \eqref{eq-frechet} under FI; the proof below uses only the abstract derivative)."

### MEDIUM — improve exposition
- [ ] **$\mathsf{T}$ vs $T$ typographic dispatch** (HIGH from notation-warden; affects readability). Either typeset both operators sans-serif from the outset (introduce $\mathsf{T}_{\text{MI}}$ and $\mathsf{T}_{\text{FI}}$), or make the umbrella symbol italic, or add a sentence at L174 stating that the typography of the umbrella symbol is a convention.
- [ ] **$\mathcal{B}_M$ vs $\mathcal{B}^*_M$ seam** with prp-condcomp (L286). Make the strengthening explicit when prp-condcomp invokes the source-condition tightening.
- [ ] **L957 — spell out $\mathcal{B}_{b_\dagger} \subseteq \mathcal{B}_R$** as a parenthetical when invoking (iii). One-clause clarification.

### MINOR — cosmetic
- [ ] **L955–957 — codomain norm $\Vert\cdot\Vert$ is route-dependent.** Footnote at first appearance pinning the inherited Hilbert structure under each route.
- [ ] $\mathcal{B}_{b_\dagger}$ abstract-vs-concrete reuse (def-locid vs prp-onetoone).
- [ ] Letter $R$ family ($R, R_\sigma, R^\sigma$) disambiguation could be globalized in a notation glossary.
- [ ] $M$ overloading with $M_\eta, M_2, M_3, m_4$ across the paper — no in-scope collision.

## Net status

| Gate | Threshold | Verdict |
|---|---|---|
| Commit | weighted aggregate ≥ 80 | **PASS** (89/100) |
| PR | weighted aggregate ≥ 90 | borderline — fix MAJOR (#1) to clear |
| Theory binary gates (quality.md §3) | no critical findings | **PASS** (no CRITICAL) |

## Contrast with `prp-lepskii` audit (same day)

`prp-onetoone` is a much cleaner artifact than `prp-lepskii`. The asymmetry is structural:

- `prp-onetoone` is an *abstract* proposition: its four conditions (i)–(iv) ARE the assumptions; the proof is 10 lines of inequality chain; no stochastic objects appear; no kernel-density-based estimators; no LF iteration; no Lepskii balancing.
- `prp-lepskii` is an *asymptotic* result: it carries 15 assumptions, a 250+ line proof with four-term decomposition, a four-event ($\Omega_n, \Omega'_n$, plus complements) bookkeeping, hypercontractivity, propagator substitution, and rate-balance arithmetic. Three rounds of /prove brought it to 69/100 — well below `prp-onetoone`'s 89/100 here.

The primitive deliveries of (i)–(iv) — `ass:differentiability`, `ass:condcomp`, `ass:unifbd`, `def-sourceID` — are heavier objects in their own right and would each merit a separate audit if the user wanted to verify the primitive chain back to the conditions of `prp-onetoone`.

## Recommended next moves

1. Patch the MAJOR documentation issue (L952 route dispatch) — single sentence edit.
2. Address the MEDIUM typographic dispatch ($\mathsf{T}$ vs $T$) globally; this affects the whole identification section.
3. Optionally run `/audit --counter #prp-onetoone` to probe the abstract proposition at boundary cases (e.g., $\mathcal{B}_R = \emptyset$, $\mathsf{T}'_{b_\dagger}$ with non-closed range, etc.). Given that this is a `@chenlee2013` adaptation, the result is essentially proved in the literature; adversarial probes would be confirmatory.
4. No `/prove` needed for `prp-onetoone` — the existing proof is sound and short.
