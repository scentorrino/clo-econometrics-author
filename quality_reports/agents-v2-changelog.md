# Agents v2 — rate-theory review versions (2026-10-04)

Four new agent definitions were added beside the originals in `.claude/agents/` (originals untouched):

| New file | Based on | What changed |
|---|---|---|
| `theorist-critic-v2.md` | `theorist-critic.md` | Retargeted from identification arguments to rates/minimax/inverse problems. Adds a mandatory Phase 0 claim-status ledger (PROVED / DERIVED / NUMERICAL / ASSERTED), recomputation of every constant and exponent, noise-model and basis discipline (source-white vs image-white variance of ⟨ξ,Kη⟩; ellipsoids in a singular basis vs smoothness classes), extremal-member tests for class statements (many small features vs one), event and uniformity checks, and strict minimax terminology (a log factor ⇒ not minimax). May run throwaway scripts. |
| `counterexample-hunter-v2.md` | `counterexample-hunter.md` | Probe menu rebuilt for rate theory: many small features / staircases / triangular arrays, extremal-scale single feature, flat pieces, boundary features, cap and existence events, norm swap (L¹/L²/sup, image/source), basis-boundary mismatch, noise-model swap, pointwise vs uniform, logarithm provenance, ball interior vs boundary, grid/discretization artifacts, degenerate placements. Must run the note's own mechanism on each probe and give a numerical design for undecided ones. |
| `derivation-verifier-v2.md` | `derivation-verifier.md` | No fixed YAML harness; writes its own SymPy/NumPy scripts to recompute constants, kernel bounds on their full ranges, integrals, exponent balances (under both noise models), multiplier cutoffs, and the slopes/ratios quoted from simulation tables (and from result files when available). Classifies MATCH / LOOSE / WRONG / UNDECIDABLE. |
| `regularity-checker-v2.md` | `regularity-checker.md` | Menagerie extended to constrained estimators: existence/caps/events, KKT feasibility, finiteness and degeneracy of blocks, suprema over data-chosen partitions and the logarithms they introduce, atoms in integrations by parts, left/right limits at knots, uniformity of constants, peeling details, Hadamard differentiability of projections, triangular arrays. Adds event, uniformity and logarithm ledgers to the report. |

Motivation: an audit of a rate-theory note (monotone density, image-norm minimum-distance estimator) by ad-hoc reviewers found the defects that the v1 agents do not look for — a class threshold computed on a single feature when a staircase is worse, an ellipsoid in the singular basis that contains no density, an interpolation done under the wrong noise model, a theorem stated unconditionally but proved on a cap event, and "minimax up to a logarithm" wording. The v2 agents encode those checks.

Dispatch: the v2 agents are drop-in critics (read-only; scratch scripts allowed where the frontmatter lists Bash). They are not yet wired into `/audit`, `/prove` or `quality.md` weights; use them by direct dispatch until the skills are updated.


## First run (2026-10-04)
See `quality_reports/agents-v2-first-run/README.md`. Four agents, one note; no theorem fell; one structural fix (cap removed via existence lemma + Daniels bound), four wrong-but-harmless constants, ~25 wording/status corrections.
