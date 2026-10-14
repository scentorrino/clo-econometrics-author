# First run of the v2 theory agents (2026-10-04)

Artifact: `Monotone_density_short.md` (Dropbox/Nonparametric_IV/Monotone NPIV/JP), a 1,770-line rate-theory note
(monotone density, image-norm minimum-distance fit). Dispatched as four `general-purpose` subagents instructed to read
their definition file and act as it. Full reports were returned to the session; this file keeps the verdicts.

| Agent | Verdict | Score | Key yield |
|---|---|---|---|
| theorist-critic-v2 | proofs VALID, statements MAJOR issues | 58/100 | Phase-0 ledger of 29 claims; every constant recomputed; Prop 4.6 stated without its event; abstract/intro/§8 dropped the event; "at best linear-rate" drawn from an upper bound; **constructive**: the cap can be removed (uncapped minimizer exists; Daniels' theorem bounds f̂(1) uniformly) ⇒ unconditional theorems |
| regularity-checker-v2 | 1 CRITICAL, 3 MAJOR, 9 MINOR | 23/100 | Cap event doubtful for fixed B′ (Grenander endpoint spike); §4 estimator is the cone fit, not (1.1) over the density class (integral multiplier); knot finiteness never proved (proof sketch supplied); left/right-limit convention in the identity; event/uniformity/logarithm ledgers |
| derivation-verifier-v2 | 58 MATCH / 13 LOOSE / 4 WRONG / 0 exponent changes | — | ∫w_I²=6/(5h) not 3/(5h); kernel perturbation O(n⁻²h⁻²); ‖R⁰_u‖₁ sup is 5/4 δ² (stated 1.23); boundary constant 27.12; all §7 slopes reproduced from the printed tables |
| counterexample-hunter-v2 | no counterexample; 7 scope limitations | — | f'≥c₁ in Thm 4.7 is a proof artifact (plateau truth converges at −0.339; block-wise (4.4)); many-jump test consistent with Thm 4.11; L¹ extremal member is the n^{1/3}-staircase; §7 scripts compute the mirror twin pinned at the max end; γ=1+β wording contradicted §6.2; two undecided items with numerical designs (ε̂ ∝ 1/J; cusp SEs) |

All findings were applied to the note the same day (uncapped cone fit (4.0) with existence/finiteness lemma and
Daniels bound (4.2′); unconditional Theorems 4.7/4.11; constants; wording). Two agents could not read a result file
(`.npz`) that exists on disk — the sandbox path visibility should be checked before relying on result files in prompts.

Observed costs: 200k–275k tokens and 20–35 minutes per agent on a 1,770-line note.
