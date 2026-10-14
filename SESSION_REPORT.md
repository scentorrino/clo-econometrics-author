# Session Report — clo-author

## 2026-05-08 — HTML Dashboard Pipeline + Guide Overhaul (v4.3.0)

**Operations:**
- Built `scripts/generate_html_report.py` — 5 subcommands (peer-review, code-audit, strategy-review, quality-gate, literature)
- Built `scripts/generate_dashboard.py` — project-level HTML dashboard
- Created `templates/html/base/styles.css` + `components.js` — shared thariqs design system
- Created `quality_reports/demo/` — demo markdown + 6 generated HTML files
- Created `quality_reports/demo/annotated_bibliography.md` — 12-paper demo for literature subcommand
- Wired HTML generation into skills: `/review`, `/analyze`, `/strategize`, `/discover lit`, `/submit final`, `/checkpoint`, `/tools dashboard`
- Rewrote `guide/custom.scss` — cyberpunk neon → thariqs ivory/clay/serif
- Created `guide/custom-dark.scss` — thariqs dark theme for Quarto dual-theme toggle
- Updated `guide/_quarto.yml` — switched base from `darkly` to `cosmo`, added light/dark toggle
- Updated 6 mermaid diagrams across `user-guide.qmd`, `architecture.qmd`, `customization.qmd`
- Readability pass on `user-guide.qmd`, `agents.qmd`, `architecture.qmd`, `changelog.qmd`
- Added v4.3.0 changelog entry
- Rendered all 7 guide pages successfully

**Decisions:**
- Literature report designed as "self-contained Zotero" per user request — filterable by category/proximity/method, sortable, searchable, with copy-cite buttons
- Guide site dark toggle via Quarto's native `light:`/`dark:` theme config rather than custom JS
- Removed "Multi-Model Strategy" section from agents.qmd (architecture topic, not agents)
- Removed duplicate "How It Works" table from user-guide.qmd (already on index page)

**Results:**
- All 5 HTML report subcommands verified against demo data
- Guide site builds cleanly (7/7 pages)
- Zero cyberpunk remnants in guide source files
- Dark/light toggle functional in navbar

**Commits:**
- None yet — all changes uncommitted

**Status:**
- Done: Phases A-F of HTML dashboard pipeline complete (v4.3.0 scope)
- Pending: Commit + deploy to GitHub Pages

## 2026-07-28 — Panel NPIV (`panel-npiv-discrete`): Stages 1–3 dispatch 1

**Operations:**
- Fixed a blocking shadowing bug in `scripts/R/orthogonal_theta.R` (stale sieve `solve_balance_weight` overriding the kernel one); estimator verified end to end
- Stage 1 Literature: librarian ×3 rounds + librarian-critic ×2 → `quality_reports/literature/panel-npiv-discrete/` (4 deliverables + critic report), 90 papers / 11 areas / 58 new bib entries
- Stage 2 Strategy: strategist ×3 rounds + strategist-critic ×3 → `proof_strategy_memo.md` (937 lines) + review
- Stage 3 Execution dispatch 1: theorist ×3 + theorist-critic ×2 + all three narrow critics → `quality_reports/theory/panel-npiv-discrete/{assumptions,results,proofs}.tex`, `notation_glossary.md`, `theory_memo.md`; `paper/sections/theorems/{lem-shiftinv,lem-bierens}.tex`; audits in `quality_reports/{counterexamples,regularity,derivations}/`
- 60 SymPy specs written under `scripts/symbolic/specs/`
- Plan amended seven times (§17 conditional A1 + Bierens; §18 escalations; §19 user decisions; §2.6 rewritten twice; §2.6b, §12, §18.3 corrected)

**Decisions:**
- Assumption A1 switched from unconditional to **conditional** independence, with the Bierens device for the $\Delta Z$ dimension — user-directed; the plan's original justification was a non-sequitur and was withdrawn
- Balancing norm: **sieve / $L^2$ dual pairing** (RKHS form dropped — $\varphi_\dagger$ is only Sobolev-$s$, so the RKHS bound was vacuous)
- LF stopping rule: **discrepancy principle** (the rule `hanke1995` proves for the nonlinear case)
- "A2 gets weaker" kept as **motivation only**; the strict-inclusion half of `lem:bierens` dropped
- $w=\exp$ only for the Bierens family — $\cos/\sin$ shown false by counterexample

**Results:**
- Stage 1 gate **86/100**, novelty **CLEAR** (unconditional). Poirier (2017) gate item closed on a first-party read; his conclusion names this paper's contribution as an open extension
- Stage 2 gate **85/100** after 3 rounds (65→69→85). Two architectures refuted; the second refutation became a new target result, `prp:sharpquad`
- Stage 3 dispatch 1 gate **88/100** (56→88). **Binary gate CLEARED** — no confirmed counterexample across 6 probes. 13 results proved, no stubs
- Derivation verifier: 60 specs, **0 genuine mismatches**; the `prp:frechet` constant chain closes exactly under the FTC
- Fève & Florens (2014) verified from the full text — **no unverified competitor claims remain**

**Commits:**
- None. 93 untracked files.

**Status:**
- Done: Stages 1, 2, and Stage 3 memo §10 Steps 1–2
- Pending: **N-10** ($\ell_\star$ domain bridge, blocks Step 3); **F-13** (`preamble.tex:24,27` invalid `\newtheorem{...}[]{...}`); **Q9** (three bibliographies, no declared authority); symbolic-harness defects (crashes reported as MISMATCH); Step 3 = `lem:adjoint` + `rem:nophifree`

## 2026-07-30 — panel-npiv-discrete: Step 7 closed at 97/100; first end-to-end build; J = E[ΔZΔZ'] established

**Operations:**
- Dispatched 12 agents: theorist ×5 (Step 7, three fix rounds, specs), theorist-critic ×3 (48 → 91 → 97), librarian (bibliography), simulation-engineer (Monte Carlo), plus two assessment dispatches (CFF derivative device, CFF Assumption 18).
- Created `scripts/build-theory/{build.sh,driver.tex}` — the theory corpus had no reproducible build; it existed only in a session scratchpad.
- Added CHECK 6 to `scripts/render-sync/check_rendering_sync.py` (`OCCURS_NOWHERE` / `ONLY_IN` / `REGISTER_RANGE`), plus fixes to `PROVENANCE_LINE` and the `RETIRED-MENTION` opt-out.
- Recovered `usage-matrix_partH.md` and `notation-table_partH.md` verbatim from subagent transcripts — never written to disk.
- Persisted `proofs_review_dispatch{10,11,12}.md`; archived the Part-H staging copies to `archive/` with a provenance README.
- Created `paper/preambles/preamble.tex` hazard note; `quality_reports/literature/panel-npiv-discrete/references.bib` 62 → 72 entries.

**Decisions:**
- Carried three MINORs (N5–N7) as known limitations rather than running a fourth critic round — the critic's own recommendation: recovering three points against a file that closed twenty-one findings is a poor use of the loop.
- Retired the `\mathcal D` `ONLY_IN` checker row because its *subject* was withdrawn, not to silence a failure — the distinction the "do not delete the row" rule turns on.
- Reverted my own sentence-scoped `PROVENANCE_LINE` rewrite after a probe showed widening the window widens the laundering surface.
- Did not rule on the (O3) discharge/carry question myself; sent it to the critic, which upheld the theorist against itself.

**Results:**
- **Step 7 closed at 97/100** (48 → 91 → 97), clearing commit (80), PR (90) and submission (95) gates. No binary-gate block.
- **First compilation of `results.tex`/`proofs.tex`** — they had never been through a compiler and did not compile. Now: exit 0, 273 pages, zero errors, zero undefined refs, zero unresolved citations.
- **Specs 95 → 117** (115 MATCH, 2 by-design). All new specs falsification-tested: 26 of 26 perturbations flipped.
- **Monte Carlo verdict "Matches"**, and it found **J = E[ΔZΔZ'] exactly under A1** — A3 now retired as a consequence of A1 + A1b(iv), and Σ splits exactly (`eq:sigsplit`), making the sandwich the oracle variance plus a PSD term.
- Sync 29 → 21 blocking (declared rendering lag only).

**Commits:**
- None. Standing instruction: do not commit. 140 files uncommitted by design.

**Status:**
- Done: Step 7 and its three review rounds; bibliography; specs; Monte Carlo; the J finding and A3's retirement.
- Pending: **simulation-engineer-critic was never dispatched — a worker–critic pairing gap I owe.** Then the assumption-auditor re-sweep (A3's retirement changed the maintained block), Step 8 (`prp:effbound`, `prp:plugin`, `cor:trend`), and the counterexample-hunter, which has never probed `thm:rootn`. Carried: N5–N7, deferred Q-4 (`eq:lfsched` scale-invariance), one named-but-unwritten spec.

## 2026-08-11 15:04 — panel-npiv-discrete: manuscript retyped to general L; estimator audit; §6.4–§6.6 rebuilt

**Operations:**
- 11 agent dispatches: writer ×2, writer-critic, coder ×6, coder-critic ×2. Started as "retype the manuscript prose"; became an estimator audit.
- `paper/qmd/main.qmd` retyped from a binary to a general $\mathsf L$-valued instrument (24 sites: abstract, §1, §2, §3, §6 framing, §7). Localisation result carried into abstract/§1/§7. A4(ii)+A1b(iv) period-effect requirement printed in §3 for the first time.
- §6.4, §6.5, §6.6 and `supplement.qmd`'s S19/S21 notes retyped against the shipped tables.
- `scripts/R/orthogonal_theta.R`: `contract_cells` conformability guard, then a single `wtil` contract (3-D only, `stopifnot` on shapes); `eval_moment` generalized to $\mathsf L\ge3$; `solve_balance_weight` fold-alignment repair; `eps_rho` threaded through `fit_orthogonal`/`fit_one_partition`.
- `scripts/application/app_tsp_02_ladder.R` probe-2 block re-emitted with hypothesis and size-validity columns; `app_tsp_08_localise.R` moved to the orthogonal one-step, RDS saved, preconditions added, Bierens seed registered, B 400 → 2000; stage 8 added to `app_tsp_run_all.R`; `app_tsp_weighted.R` mirror signature restored.
- New: `scripts/simulations/sim_multinomial_onestep.R`, `paper/tables/{app_tsp_localise.tex, app_tsp_localise_theta.tex, sim/sim_multinomial_onestep.tex}`, `explorations/adjoint-identity-L/`.

**Decisions:**
- **Lead general $\mathsf L$, binary as the $\mathsf L=2$ special case** — the title already says "discrete", the corpus is L-general, and §6.3's finding does not exist at $\mathsf L=2$.
- **Generalize `eval_moment` to $\mathsf L\ge3$** (author) rather than drop §6.3's point estimate — the only route that lets §6.3 keep an estimate.
- **$\Delta\varphi$ normalized to mean zero, intercept absorbs the constant** (author). Probe then showed the estimator is already invariant: `init_control` sets $\bar z'\theta_{\text{init}} = \bar y$, so the shipped device already centres.
- **No ε chosen for §6.3** — both 0.03 and 0.0115 reported with binding rates; the estimate moves 0.029 SE between them.
- Writer fenced out of §6.2/§6.3/abstract/§1/§7-localisation pending author rulings.

**Results:**
- **The engine was dead since 2026-08-10.** `contract_cells` broke every binary rung with controls ($d_Z = 5, 10, 22$); only $d_Z=0$ ran. Repaired; L=2 reproduces bit-for-bit (`identical(fits)` TRUE).
- **§6.3's headline number was wrong twice** — `lm.fit` plug-in, not the orthogonal one-step, and `th[2]` = per-capita income, not ΔTSP. The comparator 0.6789 was produced by no script. Now: per-capita income +0.68547 (L=4) vs +0.64010 (L=2), difference +0.045, 38× the reported 0.0012.
- **§6.2's prose contradicted its own table in direction.** Five prose p-values traced to a superseded 2026-08-07 vintage on an unconverged fit, matching no current specification. Current: predecessor restriction rejects everywhere; A1's restriction rejects at the one size-valid stratification, p < 0.001 at 136× the null median.
- **12 of 13 §6 tables reproduce byte-identically** — the tables are authoritative, the prose was the stale party. Six conclusion reversals rebuilt in §6.4–§6.6 (notably "about twice" the linear IV → about one sixth; "neither is stably significant" → both significant at every rung).
- **φ̂ at $\mathsf L=4$ converges anti-correlated with the truth**, worsening with $n$ (b = −0.333 → −0.623). Cause: `tau_dp = 0.7`, calibrated 2026-08-07, four days before the $\mathsf L\ge3$ path existed. Adjoint, `scal` and `xeval` extrapolation each tested and cleared.
- **§6.3's p-values survive** — same verdict at the L=4 fit, the L=2 fit, and at φ̂ ≡ 0 — but are therefore effectively pre-φ̂.
- Phase 7's "both cardinalities on one code path, θ̂ = (+0.98152, −0.52822)" was **unreproducible**; that string appears in no script or artifact. Replaced with a real Monte Carlo.
- Builds: `main` exit 0, **128pp**, 0 undefined refs, 0 unresolved cites. `supplement` exit 0, 467pp, 3 pre-existing undefined refs.
- Critic scores: writer-critic **22/100** (dominated by §6 subsections the pass did not touch); coder-critic **41 → 49**.

**Commits:**
- None. Standing instruction.

**Status:**
- Done: general-$\mathsf L$ retype; §6.4–§6.6 and supplement notes rebuilt against the tables; engine repaired and generalized; probe-2 table re-emitted; §6.3 computed through the real estimator.
- Pending — **five author rulings**: ε for §6.3 (0.03 like-for-like vs 0.0115 non-binding); whether §6 may assert A1 is rejected; whether to recalibrate `tau_dp` for $\mathsf L\ge3$; whether §6.3 states the pre-φ̂ caveat or refits first; stage-5 cache restamp vs 63-minute rebuild.
- Pending — **theory**: whether the localisation attribution survives `rem:localise`(1) and (3) (the corpus says slices "do not carry localisation"); whether `prp:localise`'s reference distribution must re-estimate per draw.
- Pending — **open defects**: `residual_norm()` returns exactly 0 at $\mathsf L\ge3$ when `bier = NULL` (no-Bierens return omits `pi_t`), firing the DP stop at iteration 1 and returning the initial condition; three dangling `\eqref`s in the shipped supplement (`eq:kernelcompare`, `eq:kernelcompareci`) declared only in the retired `results.tex`; the three new `.tex` fragments are `\input` by no document; §6.2/§7's "uninformative residual" premise is gone (cap count is 0, not 29–33).

## 2026-08-15 11:16 — panel-npiv-discrete: estimator matched to the theory; §5 and §6 rewritten; N1's arity found

**Operations:**
- ~19 agent dispatches across four days: coder ×8, simulation-engineer ×4, writer ×3, theorist ×2, general-purpose ×2.
- **Engine:** φ-step generalized to any $\mathsf L\ge2$ (`conditional_parts` dispatched to `fit_propensity_multi`); $x$-direction **boundary adjustment** implemented (renormalised kernel, D11's device) in `lf_panel.R` + weighted mirrors; weighted layer generalized to $\mathsf L\ge3$; `TAU_DP` 0.7 → 0 with $\bar m$ = 15/30/60; `eps_for()` cardinality-indexed; `lf_solve` returns the cap, not the discrepancy argmin, when the rule is disabled.
- **Simulations:** §5's named design generalized to $\mathsf L\ge2$ (`sim_thm_rootn_cardinality.R`), with a 36/36 bit-identity certificate at $\mathsf L=2$; ablation split $\hat\ell$-only vs $\hat\varrho$-only; six merged cross-suite tables; `sim_multinomial_phiplugin.R`.
- **Corpus:** B1(i) restated ($c_\Phi=\pi/2$, value read by no proof) with `lem:scaleinv`(vii) proving the index scale free; **`cor:centarity` added** with proof; N1's arity declared at `ass:centering`, (T-2), `rem:anchor`, (O2), `rem:rootnscope`(3); `results_main.tex` marked as a third retired mirror.
- **Manuscript:** §6 streamlined to four beats (cut text archived); instrument section rewritten under the A1-untestability ruling; §6 renumbered at one factor; §5 gains the cardinality arm and six merged tables; `tab:sim-h-contrast`, the one hand-transcribed float, removed.

**Decisions (author):**
- $\varepsilon_\varrho = 0.01$ for §6.
- **§6 may not assert A1 is rejected** — A1 is fundamentally untestable; the residual is built under the hypothesis.
- **This is not an empirical paper** — §6 streamlined to instrument / estimator / bootstrap / close.
- $\Delta\varphi$ normalized to mean zero, intercept absorbs the constant.
- **Generalize the φ-step to any $\mathsf L$**; match the code to the theory where implementable, disclose where not.
- $\bar m$ **not** moved to `eq:cap` — it instantiates at 9.5e6 ($d_Z=5$), an 11.5-wall-year run producing a curve worse than $\hat\varphi\equiv0$; `main.qmd:2207` already discloses the deviation.

**Results:**
- **`thm:rootn` is true at every $\mathsf L$.** A Monte Carlo on §5's own design diverges at $\mathsf L=4$ (linearisation residual 0.856 → 0.909 → 1.230, coverage 0.941 → 0.895) — but that design uses the **zero anchor**, so it runs outside (T-2), and the measured $n^{+0.189}$ is `prp:orthog`(iii)'s **"only if" half firing at its predicted $n^{1/2-\alpha}=n^{+0.180}$**. Ablation localises it entirely to the propensity channel; A5(iv) exonerated twice.
- **The corpus defect is documentation-level and real:** (T-2) needs N1 at $L_\star$, A2′(iii) leaves that anchor free, (R-a) pins it, (O2) declines the construction — legitimate for $D_k$, not for $L_\star$ — and **N1's arity is stated nowhere**. Repair is additive; no proof, constant or display moves.
- **§6's estimator does not impose N1** — the anchor is a constant, not $\Delta Z$-measurable. Not resolvable from zero at $n=983$ (joint $p$ 0.085–0.12). §6 now reports the diagnostic. No moment-level check could have caught it.
- **`prp:hatAprop`(iii) was violated by 43.6% of its own sup norm** and is now exactly zero; the implemented adjoint is now the adjoint of the implemented operator.
- `tab:app-theta` made a **one-factor** contrast; the cap confound alone was 0.2138. §6's "the two cardinalities agree" was an artifact of two effects cancelling (0.62 band sd at two factors, **1.71** at one).
- Builds: theory **431pp** clean; main **143pp**, 0 undefined refs, 0 unresolved cites; supplement 473pp with its 3 known dangling refs.

**Commits:**
- None. Standing instruction. 293 paths uncommitted.

**Status:**
- Done: engine matched to theory; §5 and §6 rewritten against current artifacts; corpus repaired.
- Pending: **writer-critic on §5/§6** (dispatched, first non-stale version, never reviewed); regenerate `app_tsp_n1_anchor.tex` (stale section labels) and reconcile `app_tsp_boundary.tex` Panel E against `tab:app-theta`; ship/supplement/drop the orphaned `app_tsp_phi_mult.tex`; repair the bare italic $M$ in `prp:orthog`(iii)'s proof (C7 breach, pre-existing); C3's support condition adjudicated but **not applied** — blocked on the envelope-uniformity step the theorist flagged.
