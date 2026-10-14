# Theory Memo — `panel-npiv-discrete`

**Project slug:** `panel-npiv-discrete` · **PROJECT_TYPE:** mixed

<!-- PROJECT_TYPE CORRECTED 2026-08-03, was `theory`. CLAUDE.md flipped it to
     `mixed` on 2026-07-31 when the empirical application was decided, and this
     header was not swept. It is not cosmetic: `quality.md` §3 selects a
     different weight schedule per flag, so a critic reading this file would
     score the project on the theory schedule (proof completeness 30%,
     assumption parsimony 20%) rather than the mixed one (25% / 15%, with
     empirical strategy and applied code entering at 15% and 10%). The theory
     binary gates in `quality.md` §4 apply under both flags and are unaffected. -->

**Author agent:** theorist · **Paired critic:** theorist-critic · **Date:** 2026-07-28

| Dispatch | Scope | Outcome |
|---|---|---|
| 1 (rounds 1–2) | memo §10 Steps 1–2 | closed at 88/100, binary gate cleared |
| 2 (rounds 3–9) | escalation N-10, memo §10 Step 3, then Step 5, then two fix rounds | round 8 cleared at 94/100; round 9 closed all nineteen narrow-critic findings |
| 3 (§D-00000000) | memo §10 Step 4 — `prp:sharpquad`, L-20, L-21 — and the N-20 strike | new content, the first since round 6; scored 80/100, cleared the commit gate |
| 4 (§D-000000000) | short fix pass on Part G against `proofs_review_dispatch6.md` (80/100, 3 MAJOR + 6 MINOR) | fix-only; no new results, no Step 6 |
| 5 (step6_memo.md) | memo §10 Step 6 — Part H: (O4), `prp:phirate` | new content; scored 58/100 |
| **6 (§D-0000000000)** | **fix pass on Part H against `proofs_review_dispatch7.md` (58/100, 2 CRITICAL + 8 MAJOR + 5 MODERATE), plus the six held requests and the counterexample-hunter's two live findings** | **fix-only; no Step 7. Two structural repairs: the ESTIMATOR is amended, and the regularisation ROUTE is decided** |
| **7 (§D-00000000000)** | **strike-3 fix pass on Part H against `proofs_review_dispatch8.md` (66/100, 0 CRITICAL + 7 MAJOR + 4 MODERATE + 6 MINOR)** | **fix-only; no Step 7. One new lemma, `lem:scaleinv`, which MAJOR 2.2 requires. No new hypotheses. Two new specs** |
| **8 (feasibility only)** | **derivative-parameterisation route: does Centorrino, Fève & Florens (2025)'s device dissolve C1?** | **NO EDITS to `results.tex`, `proofs.tex`, `assumptions.tex`, `notation_glossary.md`. Verdict: the device does not transfer. See `derivative_route_assessment.md`** |
| **9 (§D-000000000000)** | **consolidated fix round on Part H — the GATING findings of three narrow sweeps: regularity-audit C1 + A1–A10, usage-matrix U-1, notation-table V-1/V-2/V-3/V-7 + register** | **One hypothesis RESTATED (P-a, spectrally at the compression), one radius SPLIT, one assumption RESTATED (C3), two conventions PROMOTED to (P8)/(P9), one lemma clause ADDED (`lem:bdiff`(ii), proved), two new remarks, four notation slots C69–C72. No new results. Step 7 not opened** |
| **10 (§D-0000000000000)** | **memo §10 STEP 7 — `thm:rootn` at plan §2.6's scope, with `cor:ratefloor` (T2′) as the floor. Part I: 3 definitions, 4 lemmas, 1 theorem, 1 corollary, 1 proposition, 3 remarks, all proved** | **NEW CONTENT, the first since Step 6. STEP 7 IS OPEN AND CLOSED. One maintained clause AMENDED (A5(ii): the $\ln n$ carried into the symbol). Four new hypotheses (R-a)–(R-e), stated on the theorem and NOT promoted to A5. Seven notation slots C73–C79, three of them renames forced by sweeps. m-23 ANSWERED — negatively for `eq:prelimrate`. Two secondary items done. Two citation fixes applied** |
| **12 (§D-000000000000000)** | **strike-2 fix pass on Part I against `proofs_review_dispatch11.md` (91/100, 0 CRITICAL + 0 MAJOR + 2 MODERATE + 2 MINOR) — four items, bounded** | **fix-only; no Step 8. One glossary definitional row RESTATED at `eq:deltalog`'s object (N1); `lem:prelimtheta` SPLIT into clause (i) — the rate, no threshold — and clause (ii) — the threshold (N2a, route chosen and argued); one citation REPLACED by the one-line tower argument (N2b); (O3)'s home list extended to three, `def:crossfit`(c) added (N3); the stage-vs-fold $k$ collision disambiguated at two sites and its ROOT recorded in the glossary's superscript-sign convention (N4). No new result, no new assumption, no new hypothesis. Both dispatch-11 refusals upheld by the critic; nothing re-opened, nothing refused** |
| **13 (§D-0000000000000000)** | **adjudication of a relayed Monte-Carlo finding against a MAINTAINED clause: is $J=E[\Delta Z\Delta Z']$?** | **The finding is UPHELD, on a shorter argument than the one relayed. One italicised sentence in `def:moment` RETRACTED as false; one maintained assumption (A3) RETIRED IN PLACE because it is a THEOREM; one new lemma clause `lem:momzero`(iv) with three blocked readings, PROVED; `lem:momzero`(iii)'s second-derivative envelope marked VACUOUS (true, bounds zero); A3 struck from four hypothesis lists as a STRICT WEAKENING; `def:onestep`'s "one step and not a root" ground CORRECTED; one secondary item done (`rem:rootnscope`(5)). Three new labelled displays. No new assumption, no new hypothesis, no conclusion changed, no spec touched** |
| **11 (§D-00000000000000)** | **strike-1 fix pass on Part I against the Part-I review (48/100, 0 CRITICAL + 4 MAJOR + 4 MODERATE + 6 MINOR + 2 relayed items)** | **fix-only; no Step 8. One arithmetic constant CORRECTED ($\frac1{4\mu}\to\frac1{8\mu}$, finding retained); (P8) gains an $o_P$ COMPANION with proof; one definition clause ADDED (`def:crossfit`(d), `eq:foldrates`); one lemma clause ADDED and PROVED (`lem:sandwich`(i′)); one hypothesis clause DELETED ((R-b)'s third); `cor:ratefloor` SCOPED BY BRANCH; the A5(ii) sweep RUN across four sites; one stray symbol ($\mu'$) DELETED; the non-promotion GROUND replaced at three sites, decision unchanged. One glossary hazard row §8.7 (register unchanged at C1–C79). Specs §.7 revised: one demotion, two additions** |
| **14 (§D-00000000000000000)** | **consolidated fix round against FOUR narrow audits landing together: notation-table round 13 (31/100), usage-matrix round 13 (58/100), regularity-audit Part I (55/100), counterexample-hunter on `thm:rootn` (no counterexample, gate cleared)** | **fix-only; no Step 8. Two gate-blocking COLLISIONS closed ($\psi$ as a cgf; $q$ as a partition index). Two ASSUMPTION CLAUSES RETIRED IN PLACE (A2′(ii), proved; B1(vi), about a different estimator) and one WEAKENED (`lem:nusigma`(i), $\mathcal V\to L^2(\pi)$, dissolving a carried limitation at three lemmas). One new (P8) clause, the $O_P$ COMPANION, with proof, re-routing FOUR sites that had the wrong hypothesis. One new definition clause (`def:crossfit`(c′)) fixing product measurability and the sup-norm reading. One new lemma clause PROVED (`lem:momzero`(v), $\Sigma\succ0$), converting a theorem PROVISO into a CONSEQUENCE. `\hat V` made TOTAL. Three FALSE CLAIMS struck (A1b(i)'s list; A4(d)'s two). (R-d) and $d_Z\ge1$ DECLARED. One scope item ADDED (`rem:rootnscope`(6), pointwise in $P$). The $\mu$ two-referent hazard DOCUMENTED and its reading made BINDING. No conclusion changed; no new maintained assumption; register unchanged at C1–C79** |
| **15 (§D-000000000000000000)** | **deliberately narrow round: TWO findings, both about the well-posedness of a stated hypothesis, dispatched after two of dispatch 14's three narrow re-sweeps came back LOWER** | **fix-only; no Step 8. (1) The (P8) FREEZING LEMMA — added in dispatch 14 to repair a hypothesis-shape defect — is RESTATED at the conditional hypothesis its consumers actually supply, in two clauses (F-i)/(F-ii), with the conclusion read as an identity of GENERALISED conditional expectations; this SUBSUMES the unactioned finding about `eq:biasdecomp` and `eq:threeway`. Its consumer list is corrected from EIGHT to NINE (`lem:balance` Steps 0 and 2), and "where the hypothesis comes from" is now answered PER SITE, with two sites recorded as OPEN. (2) `def:crossfit`(c′.1) declared the WRONG CONTAINER — $L^2$ equivalence classes for two objects the estimator evaluates POINTWISE at undominated arguments — and is restated as product measurability of the estimator's own pointwise function (`eq:prodmeas`), with the $L^2$ reading RETAINED for the three objects that are only ever integrated. One false rider struck (continuity "preserved by the choice"), one contradiction between (c) and (c′.2) fixed. ONE new label. No conclusion changed; no new maintained assumption; register unchanged at C1–C79** |
| **16 (§D-0000000000000000000)** | **second narrow round, against `regularity-audit.md` (49/100, 3 MAJOR + 7 MINOR) — on disk under the named path for the first time in three dispatches. Every item localised to a line; none needed a new argument, and that held at every one of them** | **fix-only; no Step 8. THE THREE-INSTANCE CHAIN CLOSED — one measurability obligation asserted by citation, written three times over. A4(iii) gains a joint-measurability clause *on the estimator's own pointwise function*, not a container declaration, so that `def:hatT`'s truncation bound stays *surely*; `lem:balance`'s convention names its target and is *scoped strictly below* `eq:prodmeas`, the site evaluating $\hat\ell$ at an undistorted draw; A5(iv), which inherited the gap by citation, is CHECKED (fixing 2 does fix 3) and now names what it inherits. THE OUTER ESSENTIAL SUPREMUM in `def:crossfit`(c′.2), carried on the word "likewise", is DISCHARGED — Tonelli at each level plus a countable intersection over the rational levels, *with no letter claimed* (C12/C24/C78; §1.6 swept, no slot free). FIVE SENTENCES repaired, all one species but the last: the per-site supplier (a DELETION — the trailing "and NOT a representative of an $L^2$ class" is false at all seven sites and is STRUCK); "precisely when" (false in both directions); Tonelli for a signed vector-valued integrand (positive and negative parts, the device A2c (m.2) owns); the $L^2$ test at $\hat\varphi$ (domination, C1(ii), uncited); and a *sure* property of a class member (repaired at the assumption, not by weakening). Plus the TOWER PROPERTY, added to the "nothing downstream changes" list that two named consumers cite. ONE COUNT CORRECTED AGAINST THE AUDIT, in the direction of more defect: two-ingredient composites are SIX, not four. (P1)–(P9)'s structural status LEFT — it is the user's decision, not the theorist's. No new assumption, no new tag, no new label, no new symbol, no conclusion changed, no proof body edited** |
| **Phase 4d (§D-P4d)** | **the held MAJOR, released by an authorial ruling: what is $\pi$? `def:spaces` said "the reference density of Assumption C1" and no file in the corpus said whether it was known, chosen or unknown — an unstated condition on the object `eq:hatAadj` divides by** | **RULING: $\pi$ is the pooled design density $\tfrac12(f_{X_1}+f_{X_2})$, an unknown feature of $P$, estimated. Status DECLARED at `def:spaces`. A sample-level positivity condition ADDED at `def:lfstep` on `eq:trunset`'s device (declaration + metric projection onto a closed convex non-empty set), which the corpus had nowhere while the shipped engine enforced it. `def:hatAcon`'s "computable without knowing $\pi$" RECONCILED — true of the forward operator, not of the adjoint the iteration runs. The $\hat\pi$-for-$\pi$ gap is DECOMPOSED into four parts: two settled in print, one open and *priced* (the level of the iterate, needing $\|\hat\pi-\pi\|_{L^2(\mathcal X,dx)}=O_P(\delta_n)$), one open and unpriced (the source condition sits at a multiplicatively perturbed operator). C1(ii) NOT weakened and NOT re-spelled. No new `\label`, no numbered display, no numbered environment, so no counter moves. Two symbols declared, C109; one undeclared $\varepsilon$-family member found and reported** |
| **P1 (§D-P1)** | **counterexample-hunter escalation, 2026-08-27 (corpus at 47/100, gate 3 "NOT BLOCKED but one determination away"). The determination: is $\bar k=1$ attainable under `prp:phirate`'s own hypotheses?** | **ANSWER: NO — $\bar k=\bar k_a+1\ge2$ always, the $\vee\,1$ in Step 4(a.2) binding exactly in the favourable case the escalation proposed, so the construction empties (P-a.3) at $k=2$ and yields VACUITY, not falsity. **GATE 3 STAYS NOT BLOCKED.** The answer is now printed in the STATEMENT of `prp:phirate` — conclusion reads $\bar k\ge2$, (P-a.3) says it is never a one-stage condition — and not only in the proof. Repaired anyway: `eq:normconst` now carries $\max\{\|1/\pi\|_\infty^{1/2},\varepsilon_\pi^{-1/2}\}$, so (F-f)'s $\|\mathcal L\|\le1$ holds surely in **both** the $L^2(\pi)$ and $L^2(\hat\pi)$ pairings; one new proposition clause `prp:hatAprop`(i$'$) with three displays, PROVED; `rem:phirscope`(7) goes from four parts to FIVE, the fifth (7e) being relaxation-admissibility, which none of (7a)–(7d) reached. The repair moves a CONSTANT and not a rate, so every exponent reading $\omega_n$ is unchanged and the propagation is complete in one pass. `rem:ff` gains the pairing reading; `prp:phirate` Step 2 fixes its domain space before checking, and records that (L5) is NOT settled (it is (7d)). P2: `lem:levels`(iii)'s density step REROUTED through clause (ii) — the reversal to A0's interval was considered and DECLINED — and the statement's "(ii)–(iv) unchanged" corrected. P3: one sentence repaired to $\mathsf L^{Q}=\#\mathsf S$, with the witness. Glossary §1.5m, C110/C110a/C110b. (7c), (7d) and (7a)'s random sieve remain OPEN** |
| **P5 (§D-P5)** | **theorist-critic 56/100, 1 CRITICAL + 3 MAJOR + 3 MINOR. The CRITICAL: `prp:phirate` claimed a rate for the estimator `def:lfstep` defines while its own proof analyses a different object, and two compiled remarks print that the passage is unestablished — the 2026-08-26 $\pi$ ruling was made and not carried into the one statement it invalidates** | **ROUTE TAKEN: SCOPING, and the alternative is rejected on the merits and argued. `eq:phirate` is restated at $\hat\varphi^{\pi}$, the *infeasible* reading of `def:lfstep`(b), declared as a new symbol (C115, §1.5o) with its sweep printed; (L2)'s heading and its false quotation retyped; the propagation swept at 17 sites across six compiled files. **`thm:rootn` survives as a CONDITIONAL theorem**: A5(ii) moves from *delivered by (T-5)* to *assumed at (T-4)*, and its two halves are split (the rate half assumed, the $o_P(n^{-1/4})$ half still delivered). `def:crossfit`(c′.1)'s "discharged verification" retyped to "discharged at a fixed sieve, pending at the feasible one", both halves stated, the independent consumer named; `rem:phirscope`(7)'s accounting demoted to *two settled, one settled with a rider, two open*. A4(i) WEAKENED to $\varepsilon_\varrho\in(0,1/\mathsf L]$ under a new printed rule for numeric ranges on analyst-chosen constants — with a **partial dissent**: the report's witness was wrong and the blanket remedy would misfile $\varepsilon_\pi$. Three MINORs closed. Glossary slot inventory repaired from a four-round drift. No new `\label`, no numbered display, no counter moves** |
| **17 (§D-00000000000000000000)** | **the user's Appendix decision makes the last open MAJOR actionable: the (P1)–(P9) block, ruled by the regularity-checker across three sweeps to be "not acceptable, and no longer purely pre-existing"** | **STRUCTURAL, and it is the only structural change. The nine standing conventions are COMPILED as PART 0 of `proofs.tex` — 17 numbered environments, 6 of them with proofs. Every tag is unchanged, so NOT ONE CITATION WAS REPOINTED. The working record stays a comment, at the head of the file. Two regularity-checker MINORs about the block's own prose are CLOSED rather than balanced: the quantifier order is now PROVED (`lem:pconv`(iv), weak ⟹ strong by rational $\epsilon$) instead of declared self-cancelling, and the "nothing downstream changes" list is PROMOTED from one sentence with one ground to `lem:pgence`'s five proved clauses, because the $\pm$-split ground reaches three of the five and not conditional Jensen or conditional Cauchy–Schwarz. Three symbol decisions, all claiming nothing: the regular conditional distribution, the companions' exponent and the freezing lemma's ambient space are all WRITTEN OUT. One citation-consistency repair in `results.tex`. No proof body edited, no conclusion changed, no new assumption, no new symbol, register unchanged at C1–C79** |


---

## D-P5. 2026-08-27 — **the $\pi$ ruling carried into the one statement it invalidated: `prp:phirate` is scoped, and `thm:rootn` becomes conditional**

> Appended in the log's own idiom. As at D-P1 and D-P4d, the dispatch table above is not reconciled; the
> compiled corpus is the record.

### D-P5.0 Pre-Theory Report

**Read, in this order.** The theorist-critic report as dispatched (56/100, 1 CRITICAL + 3 MAJOR +
3 MINOR), at every line pin it gives. Then, in the compiled corpus only —
`results_s4_asymptotics.tex` (`prp:phirate`'s full statement, (P-a.1)–(P-a.3), (P-c)–(P-g),
`eq:muhalf`, the conclusion, the Notes line; `thm:rootn`'s (T-1)–(T-5) and (R-a)–(R-b));
`results_s3_estimation.tex` (`def:lfstep` entire — the $\varepsilon_\pi$ paragraph, `eq:normconst`,
`eq:cap`, clauses (a)–(d), the measurability paragraph — and `def:crossfit`(a)–(c′.2));
`proofs.tex` (`prp:phirate` Step 1's close, Step 2's pairing paragraph and (L1)–(L5), Steps 5 and 6;
`thm:rootn` Steps 0, 1 and 6); `results_supp.tex` (`rem:phirscope` entire, `rem:phirhyp`(9)–(12),
`rem:rootnlog`(1)–(3), `rem:rootngroups`(1)–(3), `rem:spacesread`(4a)–(4d), `lem:scaleinv`(i)–(vii),
`rem:R1`(iv), `lem:pathcont`'s surrounding notes); `results_s3_supp.tex` (the `def:lfstep` discussion
(iii), the $\mathsf R$-vs-$\mathsf R_\ast$ paragraph, the four-step measurability verification, the
clause-(d) paragraph); `assumptions_main.tex` (the file header's retirement register, the printed
citation-register paragraph, A4(i), A5(i)–(vi′), `def:hatT` and `eq:trunset`);
`assumptions_supp.tex` (the A5 discussion); `notation_glossary.md` §1.5k–§1.5n and the slot inventory.

**Not read, and named rather than assumed.** `results.tex`, `assumptions.tex`, `results_main.tex`,
`working_notes.tex` — retired mirrors, per the dispatch, never authority and never edited. No build was
run: this agent has no Bash. Page counts, `rc`, undefined refs and unresolved cites are **not verified
here** and are owed to the Bash-capable pass that follows.

### D-P5.1 The CRITICAL: which route, and why the other one is not a route

**The route taken is SCOPING.** `prp:phirate`'s conclusion now names $\hat\varphi^{\pi}$, the
**infeasible** reading of `def:lfstep`(b) — adjoint at the population $\pi$, projection
$L^2(\pi)$-orthogonal onto $\mathcal S_n$ — and says in its own text that it does **not** claim
`eq:phirate` at $\hat\varphi$, and does **not** discharge A5(ii).

**The other route was examined and is rejected on the merits, not on cost.** The dispatch offered
"give it the π̂ hypothesis the corpus already names at `results_supp.tex:4974`,
$\|\hat\pi-\pi\|_{L^2(\mathcal X,dx)}=O_P(\delta_n)$". That hypothesis closes `rem:phirscope`(7c) **and
only** (7c). It does not touch (7d), which is a *different* obstruction and is unpriced:
$\hat{\mathcal A}^\ast_{\hat\pi}=(\pi/\hat\pi)\hat{\mathcal A}^\ast_\varphi$ is a **multiplicative
perturbation**, and (7d) already prints, compiled, that equivalent renorming *preserves rates and does
not preserve range conditions*, that route (ii) needs "a stability result for source conditions under
multiplicative perturbation, which this paper does not carry", and that route (i) needs a *uniform*
rate for $\|\hat\pi/\pi-1\|_\infty$ that no condition in the paper supplies. And the regime is the
hostile one: `eq:muhalf` forces $2\mu>\tfrac53$, which is exactly where `lem:srctransfer`(ii.a)
**refutes** the interpolation transfer. So adding that hypothesis and keeping the unhedged conclusion
would have printed a *second* self-contradiction, against (7d) instead of against (7c) — the defect
relocated, not closed. **Route B is not available in one sentence, and a version of it that were
available would be a research contribution (source-condition stability under multiplicative
perturbation at $\mu>\tfrac12$), not a repair.**

**What survives and what does not.** Steps 0–5 of `prp:phirate`'s proof stand, unedited except at (L2)'s
heading and Step 2's pairing sentence, both of which now name the reading. Every hypothesis, `eq:muhalf`,
`eq:lxwindow`, $\delta_n$ and the budget table are untouched. **What does not survive is the claim to
have verified A5(ii) primitively.** `thm:rootn` is a **conditional** theorem on A5(ii), which (T-4)
already listed and now charges.

### D-P5.2 The propagation sweep, site by site

| Site | File | What it said | What it says |
|---|---|---|---|
| `prp:phirate` conclusion + `eq:phirate` | `results_s4_asymptotics` | "the estimator of `def:lfstep` satisfies", $\|\hat\varphi-\vdagger\|$ | scoped to $\hat\varphi^{\pi}$; plus an explicit "not claimed" sentence |
| Notes on `prp:phirate` | `results_s4_asymptotics` | pointer to `rem:phirscope` | pointer, plus one sentence saying the pointer is load-bearing |
| (T-4) | `results_s4_asymptotics` | A5(ii) listed, comment "(T-5) delivers two" | A5(ii) **assumed**; the theorem's conditionality printed on the hypothesis line |
| (T-5) | `results_s4_asymptotics` | "so that `eq:phirate` holds on each $\mathcal I_{-k}$" | same, scoped to $\hat\varphi^{\pi}$, with the non-delivery of A5(ii) stated |
| Step 2 pairing paragraph | `proofs` | "the infeasible reading" | same, naming $\hat\varphi^{\pi}$ as its output |
| (L2) | `proofs` | heading "the iteration analysed **is** the iteration run"; display attributed to `def:lfstep`(b) | heading and attribution both name the **infeasible** reading; the quotation is now a quotation |
| Step 6 | `proofs` | A5(ii) discharged | A5(ii)'s **rate** half not discharged (object), **$o_P(n^{-1/4})$** half discharged (deterministic sequence) |
| `thm:rootn` Step 0 | `proofs` | derives $\|h_k\|=O_P(\delta_n)$ from `prp:phirate` | derives it for $\hat\varphi^{\pi}$; $h_k$ is at $\hat\varphi^{(-k)}$, so the display is read off (T-4)'s A5(ii) |
| `rem:phirscope`(1), (2), (5) | `results_supp` | "upper bound on $\|\hat\varphi-\vdagger\|$"; "therefore discharges the clause"; "a rate for the estimator `def:lfstep` defines" | all three scoped; (2)'s discharge claim struck and replaced by rates-agree / objects-differ |
| `rem:phirhyp`(9) | `results_supp` | "A5(i)–(iii) discharged" | A5(i) discharged; A5(ii) split; A5(iii) never was |
| `rem:rootngroups`(2) | `results_supp` | "A5(i) and A5(ii) both **delivered** by (T-5)" | A5(i) delivered; A5(ii)'s rate half **assumed** |
| `rem:rootnlog`(1)–(2) | `results_supp` | "`prp:phirate` delivers $\|\hat\varphi-\vdagger\|$" | delivers it at $\hat\varphi^{\pi}$; the clause is about the **symbol** $\delta_n$ and is unaffected |
| `rem:R1`(iv) | `results_supp` | consistency "delivered by `prp:phirate`" | plus a third qualification: at the infeasible reading |
| `rem:spacesread`(4d) | `results_supp` | "what no result here establishes …" (correct) | unchanged, plus the record that the *proposition* moved and this sentence did not |
| A5(ii) | `assumptions_main` | rate clause | plus: first half assumed, second half delivered |
| A5 discussion | `assumptions_supp` | "`prp:phirate` delivers `eq:phirate` at …" | rate vs object separated |
| `def:lfstep` discussion (iii), clause-(d) paragraph | `results_s3_supp` | "three are settled" | two settled outright, one with a rider; and the A5(vi′) fold reading is shown to survive while A5(ii)'s does not |

**Closure disclaimer, per the standing rule.** This is a sweep of the sites that made a now-false claim,
not a census of the ~40 `\eqref{eq:phirate}` calls in the corpus. The untouched ones cite the display for
the **rate** $\delta_n$, which is the same deterministic sequence under either reading. *That is a
reading and not a census, and it is the first thing a later pass should re-measure.*

### D-P5.3 MAJOR 2 — `def:crossfit`(c′.1)

Both halves of the "discharged verification" fail **for the object clause (b) names**, and they fail for
independent reasons: **membership** ($\int\hat\varphi\,d\hat\pi=0$ vs $\mathcal V$'s
$\int\hat\varphi\,d\pi=0$) is (7c); **measurability** at a *random* sieve is (7a)'s own undischarged
rider. The clause now reads "discharged at a fixed sieve, pending at the feasible one", states both
halves, and names the independent consumer (`lem:epterm` kills its empirical-process term off
$\sigma(\mathcal I_{-k})$-measurability and off **no** rate). `rem:phirscope`(7)'s enumeration is demoted
from "(7a), (7b), (7e) settle three" to **two settled outright, one settled with a rider, two open**,
with the rider's onward consumer named. `def:lfstep`'s measurability paragraph and
`results_s3_supp`(iii) carry the same split. **Not done: the Carathéodory device for a random basis.**
It is a real argument, not a sentence, and running it here would have been a second structural change in
a pass already carrying one.

**One precision the report's framing does not carry, and it changes what "closing (7c)" buys.** A rate
condition on $\hat\pi$ makes the constant component $O_P(\delta_n)$ — **and $O_P(\delta_n)$ is not $0$**,
so it closes the *rate* mechanism of (7c) and does **not** restore exact membership
$\hat\varphi^{(-k)}\in\mathcal V$. The repair available for the membership half is a **container
weakening** — read (c′.1)'s third entry at $L^2(\pi)$ rather than at $\mathcal V$, which is exactly the
move dispatch 14 made at `lem:nusigma`(i). **It is named at three sites and made at none**, because it
has to be checked at every consumer of that clause and this pass checked none of them.

### D-P5.4 MAJOR 3 — the split-first cut for analyst-chosen constants, and a partial dissent

**The finding stands; its stated witness does not, and the corrected witness changes the remedy.**

The report's witness for A4(i) was $\varepsilon_\varrho=1$, at which "every symbol keeps a referent" *and*
"`eq:trunset` is empty so $\hat\varrho$, $\widehat{\widetilde W}$ and `eq:hatT` are undefined". Those two
cannot both hold, and the second is the true one. **The correct witness is the boundary**:
`eq:trunset` $=\{q:q_l\ge\varepsilon_\varrho,\ \sum q_l\le1-\varepsilon_\varrho\}$ is non-empty **iff**
$\mathsf L\varepsilon_\varrho\le1$ (take $q_l=\varepsilon_\varrho$; the constraint reads
$(\mathsf L-1)\varepsilon_\varrho\le1-\varepsilon_\varrho$), so at $\varepsilon_\varrho=1/\mathsf L$
exactly, every referent survives and $\varepsilon_\varrho<1/\mathsf L$ is **false** — which is precisely
the printed test's definition of a clause. The strictness was a clause printed inside a declaration.

**And the blanket remedy the report asks for would be wrong at $\varepsilon_\pi$.** `def:lfstep`'s
projection target $\{g:\varepsilon_\pi\le g\le\varepsilon_\pi^{-1}\}$ is non-empty **iff**
$\varepsilon_\pi\le1$; there is **no** admissible spelling with $\varepsilon_\pi>1$, so
"$\varepsilon_\pi\le1$" has no witness and is a declaration entire. Moving it to a hypothesis line would
print a condition no admissible spelling can violate — a hypothesis a reader cannot check, which is the
species of defect this block exists to remove.

**What is printed instead is one rule that decides all three**, in the assumption block's citation-register
paragraph: *a declared range on an analyst-chosen constant is a declaration exactly as far as its
**referent boundary**; whatever it cuts off strictly inside that boundary is a clause, and must sit where
$\tau_{\mathrm{DP}}$'s bound sits or be struck.* Applied: $\varepsilon_\varrho$'s boundary is the **weak**
$\le1/\mathsf L$, so the strictness is a clause — and it is **struck**, not relocated, because it excludes
no law (a $P$ meeting overlap at some constant meets it at half that constant) and no step consumes it;
$\varepsilon_\pi$'s printed range **is** its boundary, remainder empty, nothing to charge;
$\tau_{\mathrm{DP}}$ has no referent depending on its value at all (`def:lfstep`(c) is total at every
$\tau_{\mathrm{DP}}>0$ by its emptiness convention), so the whole of $\tau_{\mathrm{DP}}>2$ is a clause and
is correctly at (P-e). **Three registers, one rule, and the asymmetry is the rule working.**

A4(i) accordingly reads $\varepsilon_\varrho\in(0,1/\mathsf L]$ — **a weakening** — and `def:hatT`'s
non-emptiness sentence is re-grounded on the weak inequality with the arithmetic printed. *The claim that
no step consumes the strictness is a reading and not a census, and is flagged as such at the site.*

### D-P5.5 The three MINORs

1. **`def:lfstep` "stopping index" vs `lem:scaleinv`(v)'s "stopping-index bound".** The sentence now says
   (v) inflates *the bound (F-f) supplies on that index*, and prints in one clause why (ii) and (v) do not
   collide: (ii) is about the realised $\hat m^{(k)}$, (v) about the a priori bound on it.
2. **`assumptions_main.tex`'s header comment "THE FOUR RETIREMENTS".** Corrected to **five**, with **A1d**
   enumerated and its ground (retired because false — $\widetilde W$ conditionally centred under A1, so the
   clause empties at $\Lambda\equiv1$) recorded on A6's ground, matching the printed sentence that has said
   "five … and not four" since 2026-08-05. The correction carries the note that this is the **third** time
   this header's count has been wrong and that a count in a comment must be swept with the print.
3. **A0 over-cited at `def:lfstep`.** "$\mathcal X$ being a bounded interval by A0" → "$\mathcal X$ having
   finite Lebesgue measure — which is A0's **compactness** and not its interval", matching `lem:levels`.

### D-P5.6 New symbol, new labels, new `\cref`s

- **One new symbol: $\hat\varphi^{\pi}$.** Glossary slot **C115**, §1.5o, with the sweep printed: the
  pattern set `^\pi` ∪ `^{\pi}` ∪ `\varphi_\pi` ∪ `\breve\varphi` ∪ `\check\varphi` returned **0 lines,
  0 occurrences** across the eight compiled files, the four retired mirrors, `archive/` and the glossary,
  taken **before** the edit. One non-`.tex` hit is printed rather than swallowed:
  `proofs_review_dispatch3.md:289` writes $P^\pi$ for a projection, in an uncompiled review file.
- **No new `\label`. No new numbered display. No new theorem-like environment.** No equation counter moves
  in any file, so no `\eqref` anywhere changes its printed number.
- **New `\cref` edges:** `assumptions_main.tex` A5(ii) → `\cref{prp:phirate}`, `\cref{def:lfstep}`,
  `\suppref{Remark}{phirscope}` (all three call forms already live in that file);
  `results_s3_estimation.tex` `def:crossfit`(c′.1) → `\suppref{Remark}{phirscope}`,
  `\suppref{Remark}{obligations}`, `\suppref{Lemma}{epterm}` (all live in that file);
  `results_s3_supp.tex` → `\cref{prp:phirate}`, `\cref{def:crossfit}`, `\suppref{Lemma}{epterm}`,
  `\suppref{Lemma}{pathcont}` (all live in that file); `results_supp.tex` `rem:phirscope` →
  `\cref{def:crossfit}`, `\cref{lem:epterm}` (both live in that file).
- **Glossary slot inventory repaired.** It read "C1–C107" and summed to 107 while **seven** further slots
  were live below it (C108–C114, added across four rounds). Now C1–C115, both records edited in the same
  pass, arithmetic printed.

### D-P5.7 What remains open after this pass

- `rem:phirscope`(7c) — open and priced; needs one assumption on $\hat\pi$ that this paper does not make.
- `rem:phirscope`(7d) — open and unpriced; needs a source-condition stability result under multiplicative
  perturbation at $\mu>\tfrac12$.
- `rem:phirscope`(7a)'s rider — the Carathéodory device at a random basis, not run.
- **`def:crossfit`(c′.1)'s container for $\hat\varphi^{(-k)}$** — $\mathcal V$ vs $L^2(\pi)$. The
  weakening is identified, has a precedent (`lem:nusigma`(i), dispatch 14), and is **not executed**; its
  consumers were not swept. This is the cheapest of the open items and should be the next one taken.
- Consequently: `prp:phirate` says nothing about $\hat\varphi$, and `thm:rootn` is conditional on A5(ii)
  and on `def:crossfit`(c′.1) at the feasible object.
- **Not verified here:** the build. Page count, `rc`, undefined refs, unresolved cites are owed to the
  Bash-capable pass.

---

## D-P1. 2026-08-27 — **the escalation: is $\bar k=1$ attainable? No. Gate 3 is NOT blocked, and the relaxation condition is repaired anyway**

> Appended in the log's own idiom. As at D-P4d, the dispatch table above is not reconciled; the compiled
> corpus is the record.

### D-P1.0 Pre-Theory Report

**Read, in this order.** The escalation as dispatched (P1/P2/P3, with the hunter's construction and its
stopping point). Then, in the compiled corpus only — `results_s3_estimation.tex` (`def:lfstep`,
`eq:normconst`, `eq:cap`); `results_s4_asymptotics.tex` (`prp:phirate`, (P-a.1)–(P-a.3), (P-c)–(P-g));
`proofs.tex` (`rem:ff`, `prp:phirate`'s proof Steps 0–6, `prp:hatAprop`'s proof, `lem:levels`'s proof,
**`rem:localise`**'s clause-(2) transfer, `lem:pathcont`'s within-stage bound, `lem:scaleinv`'s proof of
(vi)); `results_supp.tex` (`prp:hatAprop`, `lem:scaleinv`, `rem:phirscope`(7), `rem:pasrc`,
`lem:levels`, `rem:spacesread`(4d), the `lem:bdryfam`(g) constants note); `results_s3_supp.tex` (the
`def:lfstep` discussion); `results_s2_identification.tex` (`rem:localise`(2)); `assumptions_main.tex`
(A0, the register paragraph, the A0-consumer note); `notation_glossary.md` §1.5k–§1.5l;
`.claude/references/domain-profile.md`.

**Not read, and named rather than assumed.** `results.tex`, `assumptions.tex`, `results_main.tex`,
`working_notes.tex` — retired mirrors, per the dispatch. No build was run: this agent has no Bash. Page
counts, `rc`, undefined refs and unresolved cites are **not verified here** and are owed to the
Bash-capable pass that follows.

### D-P1.1 The determination, first and unambiguously

> **Is $\bar k=1$ attainable under `prp:phirate`'s own hypotheses? NO. $\bar k\ge2$ at every admissible
> $(\mu,\varsigma_0,\alpha)$. This is therefore NOT a confirmed counterexample to `eq:phirate`, and
> GATE 3 STAYS *NOT BLOCKED*.**

**The arithmetic, which lives in the proof and not in the statement, which is why the question was not
decidable from the printed hypotheses.** Step 4(a.2) sets
$\bar k_a:=\lceil\log_{2\kappa}\frac{5\alpha/8-\kappa\alpha/(4(2\kappa-1))}{\varsigma_0-\kappa\alpha/(4(2\kappa-1))}\rceil\vee 1$
and Step 4(b) sets $\bar k:=\bar k_a+1$. The **$\vee\,1$** forces $\bar k_a\ge1$, hence $\bar k\ge2$.

**And the disjunction binds exactly in the case the escalation proposed.** The escalation asked whether
$\bar k=1$ could be reached "with $\hat\varepsilon_0$ already at or below the stagewise fixed point".
That is $\varsigma_0\ge\tfrac{5\alpha}{8}$; there the ratio inside the logarithm is $\le1$, the ceiling
is $\le0$, and $\vee\,1$ is the only thing making $\bar k_a$ a stage count. So the *most* favourable
preliminary buys $\bar k=2$. One regime-(b) stage would suffice for the rate; the count the proof
certifies is deliberately conservative, and that conservatism is what closes the question.

**Consequence for the hunter's construction.** (P-a.3) is read at $k=1$, where
$\bar v^{(1)}_\dagger=P_{\mathcal S_n}(\vdagger-\hat\varphi^{(0)})$ is free of any iterate, **and** at
$k=2$, where $\bar v^{(2)}_\dagger=P_{\mathcal S_n}(\vdagger-\hat\varphi^{(1)})$ is a functional of the
realised first stage. A stage-1 iteration that fails to contract drives $\hat\varphi^{(1)}$ past every
deterministic multiple of $\|\hat{\mathcal P}^{\,\mathcal S}\|^{\mu}\mathsf R_\ast$, so
$\|\varsigma^{(2)}\|\le\mathsf R_\ast$ fails and the hypothesis set **empties**. Vacuity, not falsity.

**Where it is now printed — and it is printed in the STATEMENT, not only the proof.** Two places.
(1) `prp:phirate`'s **statement**: the conclusion now reads "there is a finite $\bar k\ge2$", and
(P-a.3) now says in terms that $\bar k$ is `def:lfstep`'s stage count, that the construction puts it at
$\ge2$, and that the clause is therefore **never** a one-stage condition. *The ground is the one that
put the $\alpha$ restriction into this statement on 2026-08-05: a hypothesis a reader must act on should
not require reading the proof, and here the answer decides a gate.* (2) `prp:phirate`'s **proof**,
Step 4(b), as two named arithmetic facts, cited from `rem:phirscope`(7e). It was previously derivable
only by reading the ceiling and noticing the $\vee\,1$.

**And the vacuity is not a defence, which is why P1 was repaired anyway.** A hypothesis posed at the
*realised* path is checkable only after the estimator has been run, so it absorbs defects in the
estimator's own **tuning** — here a choice of $\varepsilon_\pi$ — converting a visible falsehood into an
invisible vacuity. That is stated in `rem:phirscope`(7e)'s closing paragraph, with the disclaimer that
**no audit of which other hypotheses can be emptied by an admissible tuning constant has been run**.

### D-P1.2 P1 — what was wrong, and what is now printed

**The defect, restated precisely.** (F-f) requires $\|\mathcal L\|\le1$ **out of the domain Hilbert
space whose inner product defines $\mathcal L^{\ast}$**. `def:lfstep`(b) forms the adjoint at $\hat\pi$,
so the feasible domain is $L^2(\hat\pi)$; `prp:hatAprop`(i) delivered only the $L^2(\pi)$ bound, and
`eq:normconst` carried $\|1/\pi\|_\infty^{1/2}$ with no $\varepsilon_\pi$ in it. At the admissible
constant $\hat\pi\equiv\varepsilon_\pi$ the two operator norms stand in a ratio that diverges as
$\varepsilon_\pi\downarrow0$, so the $L^2(\pi)$ bound does **not** imply the $L^2(\hat\pi)$ one.

**Stated as a gap, not as an exhibited divergence — and this is a correction to how the escalation put
it.** Showing $\|\mathcal L\|>1$ at some sample would need a matching **lower** bound on
$\|\hat{\mathcal A}_\varphi\vert_{\mathcal S_n}\|$, which is **Q-4**'s object and which `lem:scaleinv`'s
own closing note records as unavailable — that note even contemplates $\|\hat{\mathcal A}\|\asymp
(n_{\mathrm m}h_u)^{-1/2}$, i.e. $\|\mathcal L\|=o(1)$. So the corpus could neither *verify* (L1) in the
feasible pairing nor *refute* it. The honest verdict is a **proof gap**, and the repair removes the
question rather than answering it. Every site below says "not implied", never "false".

**The repair.** `prp:hatAprop` gains clause **(i$'$)**, proved: the primitive estimate is
`eq:hatAdx`, out of $L^2(\mathcal X,dx)$ and reading **no** condition on $\pi$; clause (i) is that
estimate converted at cost $\|1/\pi\|_\infty^{1/2}$; `eq:hatAhatpi` is the same estimate converted at
cost $\varepsilon_\pi^{-1/2}$ for any weight above the floor; `eq:pairgap` is the measurement showing
neither implies the other. `eq:normconst` then reads
$\max\{\|1/\pi\|_\infty^{1/2},\varepsilon_\pi^{-1/2}\}$, and (L1) closes in **both** pairings.

**The propagation, done in full and not by halves.** The new factor is a fixed positive number free of
$n$ — $\|1/\pi\|_\infty<\infty$ by C1(ii), $\varepsilon_\pi$ fixed before the data. Hence:

| Consumer of $\omega_n$ | Effect |
|---|---|
| `eq:cap`, $\bar m_n\ge\omega_n^2\hat\delta_n^{-2}$ | **Same power of $n$**; constant up by at most $(\varepsilon_\pi\|1/\pi\|_\infty)^{-1}$, and by nothing at $\varepsilon_\pi\ge\|1/\pi\|_\infty^{-1}$ |
| `lem:scaleinv`(i)–(v) | **Untouched** — stated for *every* $\omega_*>0$ |
| `lem:scaleinv`(v)'s instantiation, $\omega_n^2\asymp h_u^{-2}h_x^{-1}$, $n^{0.224}$–$n^{0.52}$, $\bar m_n\in(n^{0.864},n^{1.16})$ | **Exponents unchanged.** A sentence is added recording the constant, and that an instantiation must now state its $\varepsilon_\pi$ as well as its $\Pi_t$ |
| `lem:scaleinv`(vi), $c_*$-scaling | **Unchanged.** Its "every other factor being $\Pi$-free" list **acquired a member**, and the member is now named at the site rather than left inside "every other" |
| (L4)'s stopping-index bound, `eq:linlf`, `eq:linlftot`, Step 3–4's recursion, `eq:phirate` | **Unchanged.** The $\omega_n$ cancellation is `lem:scaleinv`(iii)–(iv), exact at every $\omega_*$ |
| `lem:pathcont`'s within-stage bound | Citation extended to (i)–(i$'$); no arithmetic moves |
| `lem:bdryfam`(g)'s constants note | Citation extended to (i)–(i$'$); the $\|\bar\Theta\|$ factors are untouched |
| `rem:spacesread`(4d)'s five-display list | Entry (2) re-spelled: `eq:normconst` reads $\|1/\pi\|_\infty^{1/2}$ **only above the threshold** |

**Nothing was half-propagated, and nothing is deferred.** The reason this is a one-pass repair rather
than the large one the escalation feared is that the amendment moves a **constant** and not a rate. Had
$\omega_n$ been re-based on a quantity moving with $n$, `eq:cap`'s exponent, `lem:scaleinv`(v)'s figures
and `rem:h6bandwidth`(5)'s configuration would all have had to move together; they do not.

**A pleasant resolution rather than a trade.** On the range `def:lfstep` *already* recommends —
$\varepsilon_\pi\le\min\{\|1/\pi\|_\infty^{-1},\|\pi\|_\infty^{-1}\}$, the range at which the clipping
costs nothing — the maximum **is** $\varepsilon_\pi^{-1/2}$. So the same number is the stability constant
and the computable one: `results_s3_supp`'s $\varepsilon_\pi^{-1/2}$ was the right quantity, filed under
computability, and it is now filed under both. Computability is now stated **on a range** rather than
after a substitution, which is stricter and truer.

**`rem:phirscope`(7) is now five parts**, `(7a)`–`(7e)`, with the arithmetic of the enumeration
corrected: none of (7a)–(7d) reaches relaxation-admissibility. (7b) is explicitly about *the norm the
conclusion is read in*, and its two-sided equivalence transfers **rates** — a normalisation is an
inequality against the constant $1$, which no equivalence preserves. **(7c) and (7d) are untouched and
remain open**, as does (7a)'s random-sieve flag.

**One reading was added to `rem:ff`**, because it is where a reader checks (F-f): the domain Hilbert
space discharges three roles at once — it defines $\mathcal L^{\ast}$, it is the space $\|\mathcal L\|$
is the norm out of, and it is where $\varsigma$ is measured — so the pairing must be fixed *before*
$\|\mathcal L\|\le1$ is checked. And the failure mode is named: at $\|\mathcal L\|^2>2$,
$I-\mathcal L^{\ast}\mathcal L$ carries an eigenvalue below $-1$ (the domain is finite-dimensional) and
the iteration **diverges geometrically** — a mode a rate theorem does not protect against.

**And `prp:phirate` Step 2 now fixes its pairing before checking anything**, with an honest statement of
which items are sensitive: **(L1)** is (settled here), **(L5)** is (it is (7d), and **not** settled —
this proof runs (L5) at the infeasible pairing throughout), and (L2)–(L4) are internal to whichever pair
is fixed. *No claim of insensitivity is made for the other three.*

### D-P1.3 P2 — `lem:levels`(iii): rerouted, and the reversal declined

**The finding is upheld and the diagnosis is exact.** The density step asserted that
$\mathcal R(\mathcal D^{-1}_0)$ contains every centred $C^1$ function on $\mathcal X$. At $\zeta(x)=x$ on
a fat Cantor $\mathcal X$: a density-point argument forces $h'=1$ a.e. on $\mathcal X$, so the primitive
is $\Lambda(x)=|\mathcal X\cap[\underline x,x]|$, and $\Lambda(x)-x$ drops by $|J|$ across each
complementary gap $J$, hence is constant on no set meeting both sides of one. **False.**

**Decision: reroute, not reverse.** The interval stays off `lem:levels`'s hypothesis line. Grounds: (a)
clause (iii) is **true** on a fat Cantor $\mathcal X$, so restoring the interval would weaken a true
lemma; (b) the statement's own claim that "(ii)–(iv) are unchanged" then stays true, which a reversal
would not preserve; (c) a reversal ripples into the assumption block's register paragraph (which now
prints A0's interval as a *clause*), `lem:intker`'s hypothesis line, and `rem:tccwhy`(4).

**The replacement argument, in the lemma's own parts.** Fubini gives
$(\mathcal D^{-1}_0)^{\ast}\zeta=\mathcal N_g/\pi$ at $\nu_g:=\zeta\pi$ — clause (ii)'s own tail function,
applied at an integrable function that need not be of the form `eq:nudef`, which clause (ii) permits
because its proof reads integrability and nothing else. Then $(\mathcal D^{-1}_0)^{\ast}\zeta=0$ gives
$\mathcal N_g=0$ a.e. on $\mathcal X$, and three steps upgrade that to $\mathcal N_g\equiv0$ on $\mathbb
R$: **(a)** $\mathcal N_g$ is continuous, by absolute continuity of the integral of $|\zeta|\pi$;
**(b)** it vanishes at every $v>\bar x$ and at every $v\le\underline x$ — the second **because $\zeta$
is centred**, which is where and only where membership of $\mathcal V$ is consumed; **(c)** the open set
$\{\mathcal N_g\ne0\}$ meets $\mathcal X$ in a null set, so $\mathcal N_g$ is constant on each of its
components and equal there to its value at the component's left endpoint, which is $0$. Clause (ii)
then gives $\zeta\pi=0$ a.e., hence $\zeta=0$. **Neither step reads connectedness.**

**Structural gain:** density is now a **conclusion** ($\ker T^{\ast}=\mathcal R(T)^{\perp}$ inside
$\mathcal V$) and not a step. The retired argument had the dependency backwards.

**The statement is amended too**, so that the printed claim is honest: "(ii) and (iv) are unchanged in
statement *and in proof*; (iii) is unchanged in statement while its proof is not", with the witness
printed. And `assumptions_main.tex`'s A0-consumer note is completed: `lem:levels` reads A0's
**compactness** at (i) **and at (iii)**, and its **interval** nowhere. The 2026-08-26 entry swept (i)
and stopped, which is how the narrowing opened the lemma to an $\mathcal X$ at which one of its own
proofs did not run.

### D-P1.4 P3 — one sentence, one witness, one repair

`proofs.tex`'s clause-(2) transfer said "the support conditions of A0 are unchanged, $\mathcal X$ and
$\mathsf L$ being fixed", four lines above a sentence reading A4(i) "at $\#\mathsf S$ cells".
**Witness for the falsity of the $\mathsf L$-fixed reading:** $\mathsf L=3$,
$\varrho\equiv(\tfrac13,\tfrac13,\tfrac13)$, $\varepsilon_\varrho=\tfrac14$, $\mathsf S=\{0,1\}$; then
$\varrho^Q=(\tfrac12,\tfrac12,0)$ and A4(i) at three cells demands $\varrho^Q_2\ge\tfrac14$.
**Repaired to $\mathcal X$ fixed and $\mathsf L^{Q}=\#\mathsf S$**, with the reason spelled at the site:
A4(i) is a condition at *every* cell of the carrier, so the carrier's count is exactly what must
transfer. `rem:localise`(2) already wrote $\varepsilon_\varrho<1/\mathsf L\le1/\#\mathsf S$, which is
needed only at $\mathsf L^{Q}=\#\mathsf S$ — the **statement** was right and this proof's own A0 line
contradicted it.

### D-P1.5 What I did not do, and what remains open

- **(7c) and (7d) remain open**, priced and unpriced respectively. Nothing here touches them, and (7e)
  says so in terms. A single uniform rate for $\|\hat\pi/\pi-1\|_\infty$ still discharges (7c) and opens
  (7d) to route (ii).
- **(7a)'s random-sieve flag remains open.** The feasible sieve is a random subspace and the
  measurability verification is written at a fixed one.
- **Q-4 is unchanged as an open item**, but its *stakes* fall: with `eq:normconst` covering both
  pairings, a lower bound on $\|\hat{\mathcal A}_\varphi\vert_{\mathcal S_n}\|$ is again about the
  **rate** and not about whether the iteration converges.
- **No audit was run** of which other hypotheses posed at the realised path can be emptied by an
  admissible tuning constant. `rem:phirscope`(7e) records this as a disclaimer rather than a closure
  claim, per the standing rule.
- **No build was run.** Counter movement is confined to the **supplement** (three new numbered displays,
  `eq:hatAdx`, `eq:hatAhatpi`, `eq:pairgap`); the article gains **no** numbered display, so no equation
  number the article prints moves.
- **The retired mirrors now diverge further** — `results.tex` and `results_main.tex` still print
  `eq:normconst` without the maximum, and `results.tex` still carries `lem:levels`(iii)'s retired proof.
  That is by design under the dispatch's standing instruction, and it is one more reason the compiled
  corpus is the gate target.

### D-P1.6 New labels and cross-references

| New | Kind | Where | Cited from |
|---|---|---|---|
| `prp:hatAprop`(i$'$) | clause | `results_supp.tex`, proof in `proofs.tex` ("Step 2$'$") | `def:lfstep`; `prp:phirate` Step 2 (L1); `lem:pathcont`'s within-stage bound; `lem:bdryfam`(g)'s constants note; `results_s3_supp`; `rem:phirscope`(7e) |
| `eq:hatAdx` | display | `prp:hatAprop`(i$'$) | `prp:hatAprop`(i$'$); `rem:phirscope`(7e); `prp:hatAprop`'s proof |
| `eq:hatAhatpi` | display | `prp:hatAprop`(i$'$) | `prp:hatAprop`(i$'$); `rem:phirscope`(7e) |
| `eq:pairgap` | display | `prp:hatAprop`(i$'$) | `prp:hatAprop`(i$'$) and its proof; `rem:phirscope`(7e) |
| `rem:phirscope`(7e) | clause | `results_supp.tex` | `def:lfstep`; `results_s3_supp`(iii); `rem:spacesread`(4d); `prp:phirate`'s Step 4(b) note |
| $\mathsf L^{Q}$ | local symbol | `proofs.tex`, **`rem:localise`**'s proof, clause-(2) transfer, 3 lines | dies there |

Glossary: **C110** (the `eq:normconst` amendment, and why a `\max` rather than a new symbol), **C110a**
(the three new labels, with the pre-edit slot sweep), **C110b** ($\mathsf L^{Q}$, with its sweep and a
self-correction on the occurrence count), under a new §1.5m.

---

## D-P4d. Phase 4d (2026-08-26) — **what $\pi$ is, and what dividing by an estimate of it costs**

> **A note on this log's currency, made once and not repaired here.** The dispatch table above stopped
> being maintained after dispatch 17, while the corpus went on to dispatch 27 and to the lettered
> phases (2c, 4c, C). This section is appended in the log's own idiom and **does not reconcile the
> gap**; the compiled corpus, not this file, is the record of what the paper says.

**The occasion.** A theorist-critic MAJOR, deliberately held for an authorial ruling. `def:spaces`
declared $\pi$ only as "the reference density on $\mathcal X$ of Assumption C1", and **no file in the
corpus said whether $\pi$ was known, chosen, or unknown.** The deduction was the *silence*, not the
absence of a theorem: it left an unstated condition on an object the estimator divides by.

**The ruling (author, 2026-08-26).** $\pi$ is the **pooled design density**
$\tfrac12(f_{X_1}+f_{X_2})$ — an unknown feature of $P$, estimated in implementation, not a reference
measure the analyst picks. `scripts/R/lf_panel.R:780–788` builds $\hat\pi$ as the equal-weight kernel
mixture of the two period marginals, which is that object; the ruling **describes** the shipped
estimator rather than changing it.

**What was written, and where.**

1. **Status, at `def:spaces`** (`results_s2_identification.tex`). $\pi$ is the pooled design density, an
   unknown feature of $P$; the estimator divides by $\hat\pi$; the symbol is **fixed at $P$ once and not
   re-indexed by a restriction of the sample**, which is what makes `rem:localise`(2)'s sub-population
   transfer — and `proofs.tex`'s "$\pi$ is a reference density and does not move" — statements about one
   denominator. The Notes line and `rem:spacesread`'s opening are re-spelled to carry a fourth clause.

2. **The sample-level positivity condition, at `def:lfstep`** (`results_s3_estimation.tex`), on
   `def:hatT`/`eq:trunset`'s device: **fix** $\varepsilon_\pi\in(0,1]$ before the data are seen (the
   declaration); **the convention** is $\hat\pi\in[\varepsilon_\pi,\varepsilon_\pi^{-1}]$ on $\mathcal X$,
   enforced by metric projection in $L^2(\mathcal X,dx)$ onto an order interval that is closed, convex
   and non-empty *on the strength of the declaration alone*. Clause (b) now says the adjoint is formed at
   $\hat\pi$. **C1(ii) is untouched**: it is a population condition, a $\hat\pi$ that goes negative
   violates nothing it states, and the new condition is additional and sample-level.

3. **The misleading-by-omission sentence, at `def:hatAcon`** (`results_supp.tex`). "Computable without
   knowing $\pi$" is true of the forward operator `eq:hatAcon` and false of `eq:hatAadj`, which every
   Landweber step of `def:lfstep`(b) runs through. Reconciled in place, beside the display it qualifies.

4. **The gap, decomposed, at `rem:phirscope`(7)** (`results_supp.tex`), with the reader-facing version at
   `results_s3_supp.tex` and the domain-side version at `rem:spacesread`(4).

**What (c) of the dispatch became: a stated open item, with two of its four parts settled.**

| Part (`rem:phirscope`(7)) | Status |
|---|---|
| **(7a)** The feasible recursion is a genuine Landweber iteration, for the same forward operator read on $L^2(\hat\pi)$ | **Settled in print.** The adjoint identity reads the weight only as a bounded function bounded away from zero. **One consequence flagged, not discharged:** $\mathcal S_n$ is cut out by $\pi$, so the *feasible* sieve is a **random** subspace, while `results_s3_supp`'s measurability verification is written at a fixed one. The Carathéodory device that verification already runs for the random functionals `eq:smdiff` is the natural instrument; it is not run for a random basis |
| **(7b)** The norm `eq:phirate` is read in | **Settled in print.** $(\varepsilon_\pi/\|\pi\|_\infty)\|h\|^2_{L^2(\pi)}\le\|h\|^2_{L^2(\hat\pi)}\le(\|1/\pi\|_\infty/\varepsilon_\pi)\|h\|^2_{L^2(\pi)}$ surely, so the rate is the same in either norm |
| **(7c)** The **level** of the iterate is pinned by $\hat\pi$, not by $\pi$ | **OPEN, priced.** The error carries a constant component bounded by $\|1/\pi\|^{1/2}_\infty\|\hat\varphi\|_{L^2(\pi)}\|\hat\pi-\pi\|_{L^2(\mathcal X,dx)}$; `eq:phirate` survives this mechanism as soon as $\|\hat\pi-\pi\|_{L^2(\mathcal X,dx)}=O_P(\delta_n)$ — a condition of exactly A4(iii)'s form, **imposed on $\hat\varrho$ and on nothing else** |
| **(7d)** The **source condition** is posed at $\hat{\mathcal A}^\ast_\varphi\hat{\mathcal A}_\varphi$, and the iteration runs $(\pi/\hat\pi)\,\hat{\mathcal A}^\ast_\varphi\hat{\mathcal A}_\varphi$ | **OPEN, unpriced.** Norm equivalence does not preserve range conditions. Two routes named, neither taken; a uniform rate for $\hat\pi/\pi$ would open route (ii) *and* discharge (7c). *The multiplication operator is written out and claims no letter: italic $M$ is retired (C7/C100)* |

**A third route, named and declined.** The results read $\pi$ through C1(ii)'s bounds, through
$\bar c_\pi$ and through $\mathcal V$'s normalisation; on that reading a **known** $\pi_0$ satisfying
C1(ii) makes the adjoint computable outright and closes the item. Declined because $\pi$ is the design
density $\hat\pi$ estimates, and because the singular system — and hence what A2, H1 and (P-a.3) assert
— moves with the weight. **That reading is offered as a reading and not as a census**; no systematic
audit for further consumers of the pooled identity was run.

**Two free consequences of the ruling, recorded because they are used.** $f_{X_j}\le2\pi$ pointwise, so
$\bar c_\pi\le2$ — a ceiling the ratio constant did not have; and C1(ii)'s bounds on $\pi$ follow from
its bounds on $f_{X_1},f_{X_2}$. **The worked example of `rem:localise`(7) is the consistency check and
it passes**: its marginals average to $1$ at every $x$, so its declared $\pi\equiv1$ *is* its pooled
design density, and its $\bar c_\pi=1+\gamma/6<7/6$ is inside the ceiling.

**Housekeeping.** No new `\label`, no numbered display, no numbered environment — every counter in files
1–8 is where it was. Two symbols declared at glossary **C109** ($\hat\pi$, $\varepsilon_\pi$; slot swept
to zero over all twelve files before the edit). One finding turned up and **left with its measurement**:
$\varepsilon_\Omega$ is a live seventh member of the $\varepsilon$ family that no glossary row declares,
at 9 lines across four compiled files.

---

## D-00000000000000000000. Dispatch 17 — **the conventions block compiled, and two MINORs re-read as a referee**

**Scope.** One structural change, taken because the user decided the proofs live in an Appendix: the
(P1)–(P9) standing conventions move from `proofs.tex`'s header comment into compiled text as **Part 0**.
**Files edited:** `proofs.tex` (header comment reduced to the working record; Part 0 added; dispatch-17
change log), `results.tex` (**one clause** in `def:crossfit`'s (P8) paragraph), `notation_glossary.md`
(one §1.7 row, two §1.6 rows, new §8.9), this memo.
**No proof body edited. No conclusion changed. No new maintained assumption. No new tag. No new symbol**
(register unchanged at C1–C79). **No existing citation repointed.**

### D-00000000000000000000.0 Pre-Theory Report

| Input | Read | Status |
|---|---|---|
| Dispatch brief (the user's Appendix decision; the line-drawing question; the four hypothesis shapes; the two MINORs; environment discipline; the do-not-touch list; the `\vdagger` and unbraced-`]` cautions) | in full | Read. Every relayed claim re-verified against the `.tex` before acting. |
| `proofs.tex` (P1)–(P9) header, all 541 lines | in full | **On disk and read.** |
| All compiled citation sites of (P1)–(P9) in `proofs.tex` and `results.tex` | swept and read at each site | **On disk and read.** The sweep is what established that the tags are cited as *plain text*, not `\cref`, and therefore that giving them a numbered home repoints nothing. |
| `.claude/references/theorem-environment-style.md` | in full | Read. Remarks after proofs; conditions by tag; `aliascnt` shared sequence. |
| `paper/preambles/preamble.tex` (environment declarations, `\vdagger`, `\un`, `\IR`, `\upmodels`) | at those lines | **On disk and read.** |
| `notation_glossary.md` §1.5–§1.8, register inventory C1–C79 | in full at those sections | **On disk and read.** This is what caught four symbol collisions the move would otherwise have created — see §.2. |
| `regularity-audit_partI_round2.md` and the 2026-07-31 journal entries carrying the two MINORs | in full | **On disk and read.** The `partI_round2` file is a condensed record; the journal entry is the fuller one, as that file itself says. |
| `.claude/references/domain-profile.md` | **NOT PRESENT** | Declared gap, as in dispatches 8–16. |
| A `paper/main.tex` | **DOES NOT EXIST** | Declared. The corpus compiles only through `scripts/build-theory/build.sh`, whose driver inputs `assumptions`, `results`, `proofs` in that order — which is why Part 0 may forward-cite `lem:intker` and `def:crossfit`. |

### D-00000000000000000000.1 Where the line was drawn, and the test

**The test:** *would a referee's understanding of a proof step change if this were absent?* If yes it is
Appendix text; if no it is a comment. Where unsure, compiled — the failure being closed was material being
invisible, and over-correcting is the cheaper error.

**Compiled — 17 environments.** `lem:pbounds` (P1)–(P3); `lem:pbinary` (P4b)–(P4c) + `rem:pbinaryscope`
(the scope warning and the counterexample); `lem:pnuid` (P5) + `eq:p5proviso`; `def:pregver` (P6a)–(P6b);
`lem:psubst` + `rem:psubstscope`; `lem:pdens` (P7a)–(P7b) + `rem:pdensscope` (scope points (α), (β) under
those tags); `def:pfold` ((P8)'s four parts, separated by standing); `lem:pconv` + `rem:pconvsites`;
`lem:pgence`; `lem:pfreeze` (F-i)/(F-ii) + `rem:pfreezeread` + `rem:pfreezesites`; `rem:pkernel` (P9).

**Left as comment — the working record.** Which dispatch introduced or struck what; the diagnosis of a
relayed remedy ("why the proof does not survive unchanged"); (P4a)'s deletion history; the (H1c)/(H2c)
merge archaeology; the o_P road not taken; the round-11 false verdict on the C3(ii)/C3(iii) clash. **The
mathematical residue of each of these is compiled where a proof step depends on it**; only the archaeology
stays.

**The two judgement calls the brief flagged, both resolved towards compiling.**

1. **The consumer lists.** Ordinarily a maintenance artifact. **Compiled**, because `eq:freezecomp` is a
   *hypothesis*, a referee must be able to check it is met, and **the supplier is not the same at every
   site** — `eq:prodmeas` at six Part-I sites, `def:crossfit`(c′.1)'s jointly measurable representative at
   the seventh, A4(iii) at `lem:opnoise`, `lem:balance`'s own convention in Part F. A list that answers a
   hypothesis site by site is part of the proof, not bookkeeping. The same argument compiles the
   companions' exponent-and-$V_n$ instantiations.
2. **The site *counts*.** Compiled ("nine sites", "six of the seven") because the prose in `results.tex`
   already cites them; the *provenance* of a count ("the ninth was undeclared through dispatch 14") is a
   record and stays.

**One scope correction the move forced.** The comment opened *"Throughout Part H"* and then stated three
tools used in Parts F, H **and** I. The freezing lemma's ninth consumer, `lem:balance` Steps 0 and 2, is in
**Part F**, several hundred lines *before* Part H. So (P8) cannot live at the head of Part H, and only its
*conditioning convention* is Part-H scoped. `def:pfold` separates the four parts by standing and says so.

### D-00000000000000000000.2 The two MINORs, re-read as a referee

**(1) The quantifier order — closed, not balanced.** The checker's M1 called it *"formal only"*: the
companion is stated in the strong form (one null set, then all $\epsilon$) while its proof fixes one
$\epsilon$; the sites claim the strong form but derive it from conditional Markov or Chebyshev, which give
the weak per-$\epsilon$ form. *"The over-claim at the sites and the over-demand in the statement cancel
exactly."* **That nets two errors against each other, which is a maintainer's move.** A referee reads a
lemma whose hypothesis is not what the cited inequality supplies, and sites asserting more than they prove.
**`lem:pconv`(iv) proves weak ⟹ strong** in three lines — union the null sets over *rational* $\epsilon$,
approach a real $\epsilon$ from below, use monotonicity of the event in the threshold and continuity of the
bound. **Neither the statement nor the sites are weakened; the missing derivation is supplied.**

**(2) The "nothing downstream changes" list — promoted, not repeated.** The list asserts that linearity,
the triangle inequality, conditional Jensen, conditional Cauchy–Schwarz **and the tower property** (with
the pull-out) all survive for generalised conditional expectations, and gives **one** ground for all five:
apply to positive and negative parts and subtract. **The list is true and its ground reaches three of the
five.** The $\pm$ split does not prove conditional **Jensen** — $\phi(\Xi^{+})-\phi(\Xi^{-})\ne\phi(\Xi)$ —
and does not by itself prove conditional **Cauchy–Schwarz**, which needs the pull-out at a
$\mathcal G$-measurable multiplier and an optimisation over a countable dense set. `lem:pgence` states five
clauses and proves each, Jensen off the countable family of affine minorants. **A strengthening of the
claim, not a retreat from it.**

### D-00000000000000000000.3 What was refused, and what was seen and left

**Refused: nothing that was asked for.** Both MINORs were upheld on inspection and both acted on.

**Four symbol collisions the move would have created, all avoided by writing out and none by claiming a
slot.** Recorded because each was a live trap: the regular conditional distribution as $\mu^{\mathcal F}$
(against C5's **source index**) → written $dG_\varphi(\omega,\cdot)$, the Lebesgue–Stieltjes measure of the
distribution function (P6a) already fixes; the companions' exponent as the word "exp" (which sets as
$\exp$) → written out at the two values every consumer already names in words; the freezing lemma's ambient
space as $(\mathcal E,\mathfrak E)$ (against C29's **best-approximation error**) → written out; the
rectangle sets in two monotone-class steps as $A$ and $B$ (against C36's **retired event** and C33's
**fourth font**) → written out. **`lem:pgence`'s generic variables are $\Xi,\Xi'$ and its scalars
$\varsigma,\varsigma'$, not $X,Y$ and $a,b$** — the latter pairing is the exact defect C72 records in an
earlier display.

**Seen and deliberately left**, per the brief, so that silence is not read as absence. **This list appears
item for item in the `proofs.tex` dispatch-17 change log as well.**

1. **Italic $M_n$ against C7's retirement of italic $M$.** **New on this list, and it is the one item
   compiling makes worse.** Pre-existing in compiled text at `lem:opnoise` Step 4; **not created here**.
   Dispatch 15 left it open on the ground that *"the header is a comment block … so no reader of the paper
   meets it"* — **that ground has expired.** The repair is specified and not executed: sans-serif
   $\mathsf M_n$, joining §1.6's existing sans-serif $\mathsf M$, claiming no letter and no register slot;
   it is a **proof-body edit at up to five sites** and outside a round scoped to the conventions block.
   Both halves of the argument are in glossary §8.9.
2. **C4′.**
3. **The three false "zero occurrences" sweep claims.**
4. **The symbolic-spec `source:` pointers** — CHECK 7, 77 of 117 failing. **Unmoved**; nothing this round
   added to or removed from that count.
5. **The B1(vi) retirement sites** — CHECK 8, 3 sites. **Unmoved**, same.
6. **The $\Psi$ family.**
7. **`eq:supnormconv`'s consumer enumeration** — untouched and intact.
8. **`lem:opnoise`'s proof preamble** ("(P8) is in force: $\hat\varrho$ is $\sigma(\mathcal I_a)$-measurable").
   Still correct under `def:pfold`(a), which is where (P8)'s conditioning convention now lives. **Checked,
   no edit needed.**
9. **The A4(iii) fold reading** in `def:crossfit`(a) and the A5 comment block's note on it. Unchanged and
   still correct.
10. **`lem:balance`'s "THREE SCOPE FACTS" comment**, item 3(c). Unchanged.
11. **The two `def:crossfit` counts.** Unchanged.
12. **The (P9) / `lem:intker` overlap.** `rem:pkernel` points at `lem:intker`'s preamble for $\mathsf c_2$
    rather than restating it, so the constant has **one** home. **Not unified further**: (P9) is a reading
    and `lem:intker` is a result, and merging them would move a Part-H lemma into Part 0. Recorded because
    a reader tracing $\mathsf c_2$ will look in both places.

### D-00000000000000000000.4 The one edit outside `proofs.tex` and the glossary, and why it was required

`def:crossfit`'s (P8) paragraph said the conversions are *"stated at a generic $\sigma$-field, **unnamed
there**"*. That was true of a comment block and is **false of a compiled lemma**, which must name it. The
clause now says the generic field is written $\mathcal G$ and that **the particular $\sigma$-field of that
definition still carries no symbol** — which is the load-bearing half and is unchanged, together with its
reason. **Leaving it would have put two compiled files in contradiction about what a third says**, which is
the precise defect this move exists to remove, and which this project has already hit at the register
(twice), at A5(ii) and at B1(vi).

**The consequence for $\mathcal G$ is documented, not hidden.** Bare $\mathcal G$ now has two readings: the
generic $\sigma$-field of `lem:pconv`/`lem:pfreeze` and `lem:density`'s closed span. They are of different
type, live in different Parts, and **never co-occur in any statement or proof** — the $\Gamma/\gamma$
disposition of C30, *documented and both retained*. A new §1.7 row records it. **It is retained rather than
moved because the hypothesis shape is under contract**: "a $\mathcal G$-measurable $V_n$" is how the $O_P$
companion's hypothesis is written in this memo, in the dispatch briefs, and now in `lem:pconv`(ii).

---

## D-0000000000000000000. Dispatch 16 — **the three-instance chain closed, the essential supremum discharged, five sentences repaired, and one clause struck**

**Scope.** Second narrow round, dispatched against `quality_reports/regularity/regularity-audit.md`
(49/100, 3 MAJOR + 7 MINOR, no CRITICAL). Every incoming item was localised to a line by the audit and
none required a new argument; that assessment held on inspection at every one of them.
**Files edited:** `assumptions.tex` (A4(iii), A5(iv)), `results.tex` (`lem:balance`'s convention;
`def:crossfit`(c′) preamble, (c′.1) and (c′.2)), `proofs.tex` ((P8) header and the change log only —
**no proof body**), `notation_glossary.md` (the C78 row only: two further sites of the write-it-out
precedent, **no symbol claimed**), this memo.
**Not edited, by instruction:** the (P1)–(P9) block's *structural status* — see §.3.
**No Step 8. No new maintained assumption. No new tag. No new label. No new symbol** (register unchanged
at C1–C79). **No conclusion of any result is changed. No proof body edited.**

### D-0000000000000000000.0 Pre-Theory Report

| Input | Read | Status |
|---|---|---|
| `quality_reports/regularity/regularity-audit.md` (49/100, was 42) | in full | **ON DISK AND READ** — the first time in three dispatches the report was on disk under the path named. Persisted "ON RECEIPT, at the path the agent named." |
| Dispatch brief (Groups A, B, C; do-not-touch list; LaTeX cautions) | in full | Read. Every relayed claim re-verified against the `.tex` before acting; **one count is corrected against the brief**, in the direction of more defect and not less (§.4 item 1). |
| `proofs.tex` (P1)–(P9) header, all nine freezing-lemma consumer sites | (P8) block in full; `lem:balance`, `lem:opnoise`, `lem:biasexp`, `lem:epterm`, `lem:sandwich`, `lem:prelimtheta` proofs at the named steps | **On disk and read.** |
| `results.tex` `lem:balance` statement + scope comment, `def:crossfit` (a)–(d), `def:weight`, `def:onestep`, `thm:rootn` (R-a)–(R-e), `rem:obligations` (O3) | in full at those sites | **On disk and read.** |
| `assumptions.tex` A4, A5, `def:hatT`, C1, A2c (`ass:reprsource`) (m.1)–(m.2) | in full at those clauses | **On disk and read.** A2c (m.2) turned out to own the exact device Group C item 3 needs. |
| `notation_glossary.md` §1.6 register, §1.7 | in full | Read, to establish that **no letter was free** for the rational level in the essential-supremum argument. Hence the write-it-out route (C12/C24/C78). |
| `quality_reports/assumptions/usage-matrix*.md`, `counterexamples/probe-results*.md` for this round | searched | **NOT ON DISK for round 16.** No assumption-auditor or counterexample sweep accompanied this dispatch. **DECLARED GAP.** A4(iii) gains a clause here; the usage matrix will need re-running against it. |
| `.claude/references/domain-profile.md` | **NOT PRESENT** | Declared gap, as in dispatches 8–15. |

### D-0000000000000000000.1 The three-instance chain — one defect written three times

The audit's characterisation is exact: **a measurability obligation asserted by citation to something
that does not state it.** All three closed, one clause each, in two files.

**1. A4(iii) carried no measurability clause of any kind.** Confirmed by reading the clause: it said
"$\hat\varrho$ is computed on an auxiliary fold and satisfies $\|\hat\varrho-\varrho\|_{L^2}=O_P(r_n)$"
and nothing more. Two things rested on the absent clause. *(a)* `lem:opnoise` Step 4 freezes $\hat\varrho$
and applies (P8)'s freezing lemma, whose hypothesis is joint measurability of the **composite**; through
dispatch 15 this was the one consumer of that lemma no clause of the block supplied, recorded as OPEN.
*(b)* **A4(iii)'s own display**: "$O_P$" is a statement about the distribution of
$\omega\mapsto\|\hat\varrho-\varrho\|_{L^2}$, an integral of a random function, and per-realisation Borel
measurability does not make that a measurable function of the sample.

**The clause added is on the estimator's own pointwise function** — $(\omega,z)\mapsto\hat\varrho(\omega)(z)$
jointly measurable — **and not a container declaration, and the choice is load-bearing.** A container fixes
a representative; `def:hatT`'s truncation bound $\varepsilon_\varrho\le|\widehat{\widetilde W}_i|\le1$
holds **surely** only of the function itself. So the form that closes instance 1 is also the form that
closes MINOR 5 (§.4 item 5). The $\sigma$-algebra of the fold is **written out and given no symbol** in
A4(iii), because `def:hatT` — which names it $\sigma(\mathcal I_a)$ — comes several hundred lines later in
that file, and a maintained clause must not name an undefined object.

**2. `lem:balance`'s convention stated membership plus a measurability with no named target.** Confirmed.
It now states that $\hat\ell$ is a $\sigma(\mathcal I_a)$-measurable **random element** of
$L^2(P_{\Delta U,\Delta Z})$ with one **jointly measurable representative fixed**. **Scoped, not imported,
exactly as the audit directed:** this is strictly *less* than `eq:prodmeas`, and deliberately — the site
evaluates $\hat\ell$ at an **undistorted** $(\Delta U,\Delta Z)$ draw, whose law is the one the container
is built on, so the choice of representative is immaterial. Importing `eq:prodmeas` would charge a Part-F
lemma with a Part-I hypothesis.

**3. A5(iv) inherited the gap by citation.** *Fixing 2 does fix 3 — and this was checked, not assumed.*
A5(iv)'s display $\|\hat\ell-\ell_\star\|_{L^2(P)}=O_P(\epsilon_n)$ is an $O_P$ statement about an integral
of a random function; with a jointly measurable representative fixed, Tonelli makes the map measurable,
which is precisely what the pointed-at convention now supplies and did not before. **The citation is
nonetheless made to *name* what it inherits**, rather than left as a pointer: a clause whose
well-posedness is one indirection away should not require the reader to take the indirection. That is what
made this an instance of the chain rather than a duplicate of instance 2.

**One consequence, checked in both directions.** A5(iv) read at the folds is `def:crossfit`(d)'s reading of
its *display*; the measurability of $\hat\ell^{(-k)}$ in Part I is (c′.1)'s `eq:prodmeas` and not this
convention. Stated explicitly at A5(iv), because a reader meeting "$L^2$ container" at A5(iv) and "the
$L^2$ container is not merely unnecessary but wrong" at (c′.1) would otherwise read a contradiction where
there is a scope distinction.

### D-0000000000000000000.2 The essential-supremum clause

**Upheld, and the audit is right that this is the gap of the dispatched species left inside the dispatched
repair.** (c′.2) discharged the *integral* by Tonelli and the *inner* supremum by a countable dense set,
then carried $\omega\mapsto\operatorname{ess\,sup}_z$ on the word "likewise". It is not a countable
supremum.

**Discharged with the tool invoked one sentence earlier.** At each fixed real level,
$\omega\mapsto P_{\Delta Z}\{z:\sup_u\|\hat\ell^{(-k)}(\omega)(u,z)\|>\text{level}\}$ is measurable by
Tonelli applied to the non-negative jointly measurable indicator; the zero set of that probability is
exactly the levels **at or above** the essential supremum (the infimum defining it is attained, the
exceptional set at the essential supremum itself being the union of the countably many exceptional sets one
reciprocal-of-an-integer above it); hence for every real level
$\{\operatorname{ess\,sup}\le\text{level}\}$ is the intersection over the **rational** levels strictly
above it — countable, and the strict inequality is what makes those exceptional sets exhaust the one at
the level itself.

**The levels are written out and carry no letter, and that was forced rather than chosen.** I swept §1.6
for a free slot: the natural names are all claimed — $q,c,b,m,p$ by the (P8) header's own declaration, $a$
by the **RESERVED** degree of ill-posedness, $r$ by A4(ii)'s Hölder order and $r_n$/$\mathsf r$, and
$\varsigma$ by this very definition's own $\mathbb E_n[\varsigma]$ 160 lines above. C12/C24/C78 is the
precedent and it applies.

**Load-bearing, and the clause now says where.** (R-a) prices *both* envelopes at $O_P(1)$ — a statement
about the distribution of these two maps — and (P8)'s $O_P$ companion requires a $\mathcal G$-measurable
$V_n$, which at `lem:sandwich` Step 2 is $\|\hat\ell^{(-k)}\|^2_\infty E\|\Delta Z\|^2$.

### D-0000000000000000000.3 What was refused, and what was seen and left

**Refused: nothing that was asked for.** The brief's Group A, B and C items were all upheld on inspection
and all acted on. There is no refusal of a request this round.

**One relayed count is corrected, and against the round.** The audit puts the number of two-ingredient
Part-I composites at **four**; I checked each of the seven sites and make it **six** — every site at which
$\hat\ell$ appears also builds the evaluation point from $\hat\varphi^{(-k)}$ (`lem:biasexp` Step 0 and
Steps 2–5 through $\hat L$ at $(\Delta U-\Delta h,\Delta Z)$; `lem:sandwich` Steps 2 and 3 at
$(\Delta U-\Delta h_k,\Delta Z)$; `lem:epterm` Step 6 and `lem:sandwich` Step 8 through $\hat\psi$, whose
residual is $\Delta U(\theta_\dagger,\hat\varphi^{(-k)})$). **The struck clause is false at more sites than
the audit charged, not fewer.**

**One item is left by instruction and it is the only one of the three MAJORs not closed.**

- **The (P1)–(P9) comment block itself** (MAJOR 3, *"carried and enlarged"*). Whether this material is
  promoted from a comment to compiled text is a **structural decision about the paper**, and it is the
  user's, not the theorist's. **LEFT.** What this dispatch did inside the block: edited two sentences,
  **struck** a third, and added the tower-property clause; the net is approximately length-neutral, which
  is the most a fix round can do about a finding whose remedy is a decision it is not authorised to take.
  *Recording this is not a substitute for the decision.*

**Seen and deliberately left**, per the brief, so that silence is not read as absence. **This list appears
item for item in the `proofs.tex` dispatch-16 change log as well, in both places** — the dispatch-15 lists
did not agree, and
A4(iii) appeared in the research journal but in neither on-disk list, which is the recording defect the
brief names and which this list is written to prevent recurring.

1. **C4′.**
2. **The three false "zero occurrences" sweep claims.**
3. **The symbolic-spec `source:` pointers** — CHECK 7, 77 of 117 failing. Not touched; nothing this round
   added to that count.
4. **The B1(vi) retirement sites** — CHECK 8, 3 sites. Not touched; nothing this round added to that count.
5. **The $\Psi$ family.**
6. **`eq:supnormconv`'s consumer enumeration** — untouched and intact. What was edited in (c′.2) is the
   clause's **measurability discharge**; the enumeration is a different sentence and was not.
7. **`lem:opnoise`'s proof preamble** ("(P8) is in force: $\hat\varrho$ is $\sigma(\mathcal I_a)$-measurable").
   **Checked, no edit needed** — it is not false, and as of this dispatch it has a *source* in A4(iii).
   Recorded because a reader tracing the repair will look there and find no change.
8. **The A4(iii) fold reading** in `def:crossfit`(a) and the A5 comment block's note on it. Both remain
   correct verbatim under the amended clause; checked rather than assumed.
9. **`lem:balance`'s "THREE SCOPE FACTS" comment**, item 3(c) ("$\hat\ell\in L^2$ almost surely, so that
   $\Upsilon$ may be applied"). Still true and still supplied under the repaired convention, which states
   membership *a fortiori*. Not extended to a fourth item: the joint measurability is in the convention
   itself, which is where the audit runs.
10. **The two `def:crossfit` counts** — "the five estimated nuisances", "the three integrated nuisances".
    A4(iii)'s new clause makes the $L^2$ container for $\hat\varrho^{(-k)}$ *superfluous for pointwise
    purposes*, which would license moving it out of the three. **Not done**: the counts are cited
    elsewhere, the container still carries A4(iii)'s *rate*, and a count change is a structural edit
    dressed as bookkeeping. Recorded instead, in (c′.1), as "the choice is moreover pinned".

### D-0000000000000000000.4 The five sentences

Five of the audit's seven MINORs are one species — **claims about what another clause says or supplies,
each off by a little** — and the sixth is not. All six are repaired.

1. **The per-site answer named the wrong supplier at one of seven, and the repair is a DELETION.** At
   `lem:prelimtheta` Steps 4/4′ the frozen object is $h_k$ and $\hat\ell$ does not appear at all; what
   supplies the composite is precisely *"a representative of an $L^2$ class"*, which the dispatch-15 line
   said it was **NOT**. That trailing clause is **struck** as false at all seven sites. What it correctly
   denied is retained in the narrower form: an $L^2$ representative supplies nothing about **$\hat\ell$**,
   whose Part-I evaluation points are undominated.
2. **"Precisely when" is false in both directions.** Not sufficient — $f$ must itself be jointly Borel,
   and where the evaluation point is built from $\hat\varphi^{(-k)}$ the other ingredient's clause is
   needed too. Not necessary — $f\equiv0$. Replaced by the direction the proofs use: `eq:prodmeas` is what
   the definition **supplies**, and it is what clause (c)'s per-realisation "Borel" does not.
3. **Tonelli cited for a signed, vector-valued integrand.** `eq:weightdef`'s integrand has arbitrary sign,
   is $\IR^p$-valued, and $\int_0^u=-\int_u^0$ for $u<0$. The conclusion holds and the step is now written:
   componentwise, on positive and negative parts, all four pieces finite because clause (c) makes
   $\hat\ell^{(-k)}$ bounded at each realisation. **This is the measurability half of Fubini–Tonelli**, and
   it is the device **A2c (m.2) already owns** — found by reading that clause, and cited.
4. **The $L^2$ test does not cover $\hat\varphi^{(-k)}$.** Its container is $L^2(\pi)$; its evaluation laws
   are $f_{X_1},f_{X_2}$. What transfers the null sets is **domination**, which is **C1(ii)**'s
   $\bar c_\pi=\max_j\|f_{X_j}/\pi\|_\infty<\infty$, and it was uncited. "The law its container is built
   on" was false as printed for that one object of the three.
5. **A *sure* property asserted of an equivalence class.** `def:crossfit`(a)'s
   $\varepsilon_\varrho\le|\widehat{\widetilde W}^{(-k)}|\le1$ **surely**, of an object (c′.1) kept in an
   $L^2$ container with nothing tying the representative to `def:hatT`'s truncation — **this file's own
   test applied to the wrong object.** Every consumer survives with "almost surely", so it was a wording
   defect and not a broken bound. **Repaired at the assumption rather than by the weakening**: A4(iii)'s
   new clause is on the pointwise function, so no representative is chosen for $\hat\varrho$ at all, and
   the truncation is a pointwise operation on the very function clause (a) names.
6. **Not that species: the "nothing downstream changes" list omitted the tower property**, which
   `lem:biasexp` Steps 2(b) and 5 name **in terms**. It does survive — for non-negative integrands the
   tower property and the pull-out of a measurable factor need no integrability, so apply each to $f^+$
   and $f^-$ and subtract on the a.s.-finite event. Added to the list, with the pull-out and with the
   one-line ground. **A sentence written to say "nothing downstream changes" that omits the one item its
   two named consumers cite is the defect**, and it is repaired at the tool and not at the two steps, for
   the reason the paragraph already gives for declaring the reading once.
7. **The seventh MINOR, which the brief did not list because instance 2 makes it stale anyway.**
   `def:crossfit`(c′)'s gloss that `lem:balance` states *"a membership statement and not a measurability
   declaration"* is **not quite what the convention said** — it also said $\hat\ell$ is
   $\sigma(\mathcal I_a)$-measurable, with the target unnamed. Repairing instance 2 makes the gloss stale
   in any case, so the sentence now reports the repaired clause and records what it said before, in both
   respects. **Accounting: all seven MINORs and all three MAJORs are addressed; MAJOR 3 is addressed by
   being left, with the reason.**

### D-0000000000000000000.5 LaTeX

`\vdagger` carries no subscript anywhere in this dispatch's edits (it appears in none of them). No
`\item[...]` optional argument introduced or modified contains an unbraced `]`. Braces balanced by
construction: every edit is a replacement of a complete sentence or clause, no environment opened or
closed. One `\[...\]` display added in `results.tex` (c′.1) and one in `assumptions.tex` A4(iii); both are
inside existing `enumerate` items and neither carries a label.

---

## D-000000000000000000. Dispatch 15 — **two findings, both well-posedness of a stated hypothesis; a repair whose own repair had the defect it repaired**

**Scope.** Deliberately narrow. The dispatch brief fixes two items and forbids the rest, on the measured
ground that dispatch 14 closed real defects but two of its three narrow re-sweeps came back *lower*
(regularity 55→42, assumptions 58→46) because each repair carried its own defect class.
**Files edited:** `proofs.tex` ((P8) header only — no proof body), `results.tex` (`def:crossfit` clauses
(c), (c′), (c′.1) only), `notation_glossary.md`, this memo.
**Not edited, by instruction:** C4′, the false-sweep rows, the symbolic-spec `source:` pointers (CHECK 7),
the B1(vi) retirement sites (CHECK 8), the $\Psi$ family, `eq:supnormconv` and its eleven-consumer
enumeration (credited by the checker as the best-reasoned of the three dispatch-14 repairs).
**Not edited, by ownership:** `assumptions.tex` — see the OPEN item below, which lives there.
**No Step 8. No new maintained assumption. No conclusion of any result is changed. No proof body edited.**

### D-000000000000000000.0 Pre-Theory Report

| Input | Read | Status |
|---|---|---|
| Dispatch brief (two findings, relayed from the regularity-checker and the assumption-auditor) | in full | **Read. Every relayed claim re-verified against the `.tex` before acting; one is corrected below.** |
| `proofs.tex` (P1)–(P9) header, and the nine consumer sites | (P8) block in full; `lem:biasexp`, `lem:opnoise`, `lem:epterm`, `lem:sandwich`, `lem:prelimtheta`, `lem:balance` proofs in full | **On disk and read.** |
| `results.tex` `def:crossfit`, `def:onestep`, `def:weight`, `def:spaces`, `lem:balance` statement | in full | **On disk and read.** |
| `assumptions.tex` A2b, A2c (`ass:reprsource`), B1(i) | the clauses bearing on containers, representatives and $\Phi$ | **On disk and read.** |
| `quality_reports/regularity/regularity-audit_*` for the Part-I audit at 42/100 | searched | **NOT ON DISK**, as in dispatch 14. Findings are relayed by the brief only. **DECLARED GAP.** Nothing was taken on the brief's word; each claim was re-derived. |
| `quality_reports/assumptions/usage-matrix_*` at 46/100 | searched | **NOT ON DISK** under that score. **DECLARED GAP**, same treatment. |

### D-000000000000000000.1 Finding 1 — the freezing lemma's hypothesis

**Verified, and the brief understates it.** Dispatch 14 stated the lemma at $E|f(N,\xi)|<\infty$,
*unconditional*. What `lem:biasexp` Step 0 proves is that the frozen integral is finite **almost surely**,
and it cannot prove more: the bound is
$E\|\hat L(\Delta U-\Delta h,\Delta Z)\|\le(E\|\hat b\|^2)^{1/2}+\|\hat\ell\|_\infty(\cdots)$, and
$\|\hat\ell\|_\infty$, $E\|\hat b\|^2$ are $O_P(1)$ by (R-a), not bounded by constants; an $O_P(1)$
variable need not be integrable. I checked all nine sites, not the six the brief names: **every consumer
but one** supplies only the conditional version. The numerators are $\|\hat\ell\|_\infty$,
$\|\partial_u\hat\ell\|_\infty$, $\|h_k\|_{L^2(\pi)}$ and $\|\hat\psi-\psi_\star\|^2_{L^2(P)}$ — each
$O_P$ or $o_P$ and none bounded. The exception is `lem:opnoise` Step 4, and only because `def:hatT`'s
truncation makes $|\hat\varrho-\varrho|\le1$ **surely**.

**The (P8) header's own words apply verbatim to the clause added to repair them** — *"NONE OF THE FIVE
SUPPLIES THIS RULE'S HYPOTHESIS"*. Acted on.

**The remedy is adopted; the claim that the proof survives unchanged is NOT upheld, and this is the one
relayed claim I checked and corrected.** The checker argued *"the monotone-class half needs no
integrability and the truncation half runs on conditional dominated convergence with the a.s.-finite
conditional envelope, which is precisely what (P6) already does."*

- **First half: right.** The rectangle case and the functional monotone class theorem use no integrability.
- **Second half: off by one step, and it is the step that matters.** (P6) obtains its envelope
  $E[|f|\mid\mathcal F_{XZW}]<\infty$ a.s. **from** the unconditional $E|f|<\infty$ — the very hypothesis
  being dropped. Under the conditional hypothesis that envelope is **not available** until the
  nonnegative case has been applied to $|f|$. And the monotone class theorem by itself delivers only
  **bounded** $f$; the passage bounded → nonnegative-unbounded is a separate monotone limit, and it is
  the clause the dispatch-14 text did not contain.
- **Once that clause is in hand, the truncation half is not needed at all.** Splitting $f=f^+-f^-$ and
  applying the nonnegative case to each closes the argument in one line, with no conditional dominated
  convergence anywhere.

**Net: the conclusion survives; the proof costs one clause and saves another.** The lemma is now stated as
(F-i) — nonnegative $f$, **no integrability whatever**, identity in $[0,+\infty]$, by rectangles → monotone
class → conditional MCT — and (F-ii) — conditional envelope finite a.s., generalised conditional
expectation well defined, identity by the $\pm$ split. The conditional-DCT route remains correct once
(F-i) is in hand and is recorded as the longer one.

**M2 is subsumed and is now discharged.** The conditional expectations the lemma produces are **generalised**
ones. That reading is declared **once**, in the (P8) clause, and covers every display the lemma produces —
`eq:biasdecomp` and the third summand of `eq:threeway` in particular. Neither display is separately
annotated, deliberately: a reading declared at the tool covers every site the tool reaches, and annotating
two of nine would imply the other seven are ordinary. Nothing downstream changes, because every consumer
bounds a **norm**, and linearity, the triangle inequality, conditional Jensen and conditional
Cauchy–Schwarz all hold for generalised conditional expectations on the a.s. event (F-ii) delivers.

**The two scope facts are verified and acted on.**

1. **`lem:opnoise` is outside `def:crossfit`(c′)'s scope — confirmed.** It is Part H, stated ~750 lines
   before `def:crossfit` exists, and does not adopt it. What is available is A4(iii), which carries **no
   measurability clause**. **OPEN, and recorded rather than papered over:** the repair is a clause on
   A4(iii) of the kind (c′) gives (R-a). It lives in `assumptions.tex`, which this round does not touch.
2. **The ninth consumer is `lem:balance` Steps 0 and 2 — confirmed, and it is the archetype.** Step 0
   freezes $\hat\ell$ inside $\nu_g$ in italics; Step 2's identity
   $\nu_g=\nu_{\widetilde W(\hat\ell-\ell_\star)}$ **is** the freezing lemma at $\mathcal G=\sigma(\mathcal I_a)$.
   Its own convention states only that $\hat\ell$ is $\sigma(\mathcal I_a)$-measurable with
   $\hat\ell\in L^2(P_{\Delta U,\Delta Z})$ **almost surely** — a *membership* statement. So
   `def:crossfit`(c′)'s claim to "re-declare for Part I what `lem:balance` states for Part F" was false in
   both directions, and is struck. **Note what that site needs is strictly *less* than Part I needs**: it
   evaluates $\hat\ell$ at an **undistorted** $(\Delta U,\Delta Z)$ draw, so a jointly measurable
   representative of the $L^2$ class would serve. The convention states neither. **ALSO OPEN.**

### D-000000000000000000.2 Finding 2 — `def:crossfit`(c′.1) states the wrong container

**Verified, and (c′.2) is indeed the proof of it.** (c′.1) declared the five nuisances random elements of
$L^2$ — equivalence classes — and fixed a representative. (c′.2), fourteen lines later, argues that the
essential supremum must be in $z$ and not $(u,z)$ **precisely because** the shifted argument's law need not
be dominated by $P_{\Delta U,\Delta Z}$. If it is not dominated, two representatives of one class differ
there, and `eq:Jhat` evaluates $\hat\ell^{(-k)}$ **pointwise** at
$(\Delta U_i(\theta,\hat\varphi^{(-k)}),\Delta Z_i)$. Different representative → different $\hat J$ →
different $\hat\theta$, $\hat\Sigma$, $\Psi^{(1)}_k$. **The estimator is not a function of the object the
clause declares.**

**Both riders check out.**
- *"The continuity clause of (c) is preserved by the choice"* is **false** for an arbitrary representative;
  point evaluation is not $L^2$-continuous and a representative need not be continuous in $u$ at any $z$.
  Struck, and replaced by the observation that under the corrected clause there **is** no choice.
- **(c′.1) is right for $\hat\varrho$, $\hat b$, $\hat\varphi$ and wrong for exactly the two objects
  (c′.2) is about.** Checked at the evaluation sites: $\hat\varrho^{(-k)}(\Delta Z_i)$ and
  $\hat b^{(-k)}(\Delta Z_i)$ are read at $\Delta Z$-draws, $\hat\varphi^{(-k)}$ at $X_{i1},X_{i2}$ whose
  law is $\pi$-dominated. For those three the choice of representative is immaterial and the $L^2$
  container is retained.

**The fix uses the device the file owns.** `eq:prodmeas` requires
$(\omega,u,z)\mapsto\hat\ell^{(-k)}(\omega)(u,z)$ to be
$\sigma(\mathcal I_{-k})\otimes\mathfrak B(\IR\times\IR^p)$-measurable — a statement about the function
clause (c) already defines, with no equivalence class and no representative. Three consequences are
**derived, not assumed**: (i) $\hat L^{(-k)}$ inherits it from `eq:weightdef` by Tonelli; (ii)
$\partial_u\hat\ell^{(-k)}$ inherits it as an everywhere-existing pointwise limit of difference quotients
— **which (c′.2)'s second envelope needs and which a representative of an $L^2$ class supplies nothing of,
having no derivative in general**, a gap the old clause also had; (iii)
$\omega\mapsto\|\hat\ell^{(-k)}-\ell_\star\|_{L^2(P)}$ is measurable, so `eq:foldrates`'s third display has
a truth value. And the **Carathéodory criterion** — already named in this file at `prp:frechet`'s preamble,
and the device `lem:biasexp` Step 1 uses to get joint measurability in $(\lambda,\omega)$ — is recorded as
the *sufficient condition* by which `eq:prodmeas` is verified: measurable in $(\omega,z)$ at each fixed
$u$, plus (c)'s continuity in $u$. **Recorded and not imposed**; the requirement is `eq:prodmeas`.

**The contradiction in (c) is fixed in the same clause, because it is the same defect.** (c) said (R-a)'s
differentiability is *"used by no clause of this definition"* while (c′.2) — a clause of this definition —
uses it to make the second envelope's inner supremum measurable. I checked all five clauses: (c′.2) is the
**only** one that uses it, so the sentence now says "one clause and only one" and names it. The reading a
reader would otherwise take — that the sup-norm convention is unconditional — is blocked explicitly.

### D-000000000000000000.3 What was refused, and what was seen and left

**Refused:** nothing was asked for that I declined. The one substantive refusal is of a *claim*, not a
request — the checker's "the proof survives unchanged", corrected above with the reason.

**Seen and deliberately left**, per the brief, so that silence is not read as absence: the three false
"zero occurrences" sweep claims; the C4′ item; the symbolic-spec `source:` pointers (CHECK 7, 77/117
failing); the B1(vi) retirement sites (CHECK 8, 3 sites); the $\Psi$ family; `eq:supnormconv` and its
eleven-consumer enumeration, left **untouched and intact** as instructed.

**Left because it is out of file ownership, and it is Finding 1's open half:** the A4(iii) measurability
clause. Without it `lem:opnoise` Step 4's display is not a well-posed probability statement, and this round
records that in the (P8) header rather than asserting a coverage that does not exist.

**Left because it is a statement change in a Part-F lemma, not a hypothesis repair:** `lem:balance`'s
sample-splitting convention, which states membership where the proof uses measurability.

---

## D-00000000000000000. Dispatch 14 — **four narrow audits landing together: two collisions, three simplifications, four false claims, and one theorem strengthened by its own hypotheses**

**Scope.** A consolidated fix round against four narrow-critic reports received simultaneously.
**Files edited:** `results.tex`, `proofs.tex`, `assumptions.tex`, `notation_glossary.md`, this memo, and
one rendering (`paper/sections/theorems/lem-adjoint.tex`) that carries a claim changed here.
**Not edited, by ownership:** `scripts/symbolic/specs/`, `references.bib`, `Bibliography_base.bib`,
`quality_reports/strategy/panel-npiv-discrete/proof_strategy_memo.md`.
**No Step 8. No new maintained assumption. No conclusion of any result is changed.**

### D-00000000000000000.0 Pre-Theory Report

| Input | Read | Status |
|---|---|---|
| `quality_reports/notation/notation-table_round13.md` (31/100) | in full, including the orchestrator verification appended at the foot | **On disk and read.** |
| `quality_reports/assumptions/usage-matrix_round13.md` (58/100) | in full, including the five settled verification requests and the orchestrator verification | **On disk and read.** |
| `quality_reports/regularity/regularity-audit_partI.md` (55/100) | **NOT ON DISK.** `quality_reports/regularity/` holds 24 files; the most recent is `regularity-audit_partH.md`. No Part-I audit exists under that or any other name | **DECLARED GAP.** The dispatch brief relays its findings in detail; every relayed finding was **re-verified against the `.tex` before acting**, and each is recorded below with what I checked. Nothing was taken on the brief's word |
| `quality_reports/counterexamples/probe-results_thm-rootn.md` | **NOT ON DISK.** `quality_reports/counterexamples/` holds three files; the most recent is `probe-results.md` (Stage-3 dispatch 1) | **DECLARED GAP**, handled the same way. The verdict relayed — *no confirmed counterexample, binary gate cleared* — is consistent with the one probe report on disk, which also clears the gate; **the binary gate of `quality.md` §4 item 3 is therefore recorded as CLEARED on the artifact I can see, not on one I cannot** |
| `results.tex`, `proofs.tex`, `assumptions.tex` | the regions named by each finding, plus their consumers: `lem:nusigma` + proof, `lem:biasexp` + proof, `lem:momzero` + proof, `lem:prelimtheta` + proof, `lem:sandwich` + proof, `lem:epterm` + proof, `lem:opnoise` Step 4, `lem:aerr` Step 3, `lem:unifop` Step 1, `lem:bdiff` + proof, `prp:medianpart` + proof, `def:crossfit`, `def:onestep`, `def:spaces`, `thm:rootn`, `rem:rootnscope`, `rem:rootnhyp`, `rem:pasrc`, `ass:ident`, `ass:sourcecondp`, `ass:overlap` + comments, `ass:bierens`, `ass:hilbscale`, the (P1)–(P9) header, the smoothness-budget table | |
| `notation_glossary.md` | §1.5h in full, §1.6, §1.7, §7, §8.0, §8.7, and the register inventory | Three of the round's findings were **findable in this file alone**, which is the fourth round running that this has been true |
| `proof_strategy_memo.md` | §2.8 in full, and the whole file swept for `necessit`/`necessar` attached to `prp:sharpquad` — **six sites, not one** | **Outside write scope.** See §.5, which corrects the brief's ``the source is `:255`'' in the direction of more work, not less |
| `Bibliography_base.bib` | swept for `li1989` | **Zero.** No citation added; see §6 |
| `.claude/references/domain-profile.md` | **NOT PRESENT** | Declared gap, as in dispatches 8–13 |

### D-00000000000000000.1 The four findings that surfaced in two lanes independently, and what I found when I checked them

**All four are upheld. Each was verified against the `.tex` before acting.**

1. **A1b(i)'s binding consumer list omits `lem:biasexp`.** Verified: `results.tex` `lem:biasexp` lists
   A1b(i), and the citation is **correct** — it is what puts $h_k=\hat\varphi^{(-k)}-\vdagger$ in
   $\mathcal V$, hence what makes the balancing pairing the object `lem:nusigma`(iii) computes. That is
   the *well-posedness* mode A1b(i)'s own sentence prescribes. Since the list declares itself binding on
   every citation, a reader following it would have struck a correct citation. **The list is repaired,
   not the citation** — the deletion-inviting direction is the one to close.
2. **A4's comment (d) contains two false statements.** Both verified.
   - *"A2′(ii) … is the clause the second-order and bias terms consume"* — false. `results.tex` says the
     opposite three times, and **the round-8 change log in the same file** says *"A2′(ii) is consumed by
     none of them."*
   - The bare *"(i) + (iii)"* in the irregularity paragraph is **ambiguous** between A2′(i), (iii) and,
     inside a comment attached to A4, A4(i), (iii); read the second way it attributes finiteness of
     $E[\widetilde W^2\|L_\star\|^2]$ to overlap. **A4(i) plays no role in that bound**: its ingredients
     are $|\widetilde W|\le1$ (P1, free), $\|\ell_\star\|_\infty<\infty$ (`cor:elldiff` under A2′(i) **in
     full** with B1(i), (ii), (iv.a) — the corollary is stated at A2b and A2b requires (i.a) *and* (i.b)),
     $E\|b_\star\|^2<\infty$ (A2′(iii)) and $E[\Delta U^2]<\infty$ (A1b(iv)).
   Both grounds struck; the forward Step-8 ground kept and stated as forward.
3. **The glyph $\mu$ carries two objects.** Verified against H1, (P-a.3), `rem:pasrc`(1)–(4),
   `lem:srctransfer`(ii.a) and `def:crossfit`(b). The consequence the hunter states is exact and
   two-sided: **the theorem covers designs its own scope remark excludes and excludes designs it
   claims.** The conclusion is untouched — no proof step computes $\mu$ from $(s,a)$.
4. **`lem:nusigma`(i) is over-strong.** Verified: the proof is `eq:deltahbound`, which uses
   $(a-b)^2\le2a^2+2b^2$ and C1(ii) and **never** $\int h\,d\pi=0$. Weakened to all of
   $L^2(\mathcal X,\pi)$. **This dissolves the carried limitation at three lemmas at once**, and it is
   strictly better than the earlier proposal to add A1b(i) to three lists — the weakening is one edit and
   removes the need entirely.

### D-00000000000000000.2 What was done, by priority

| # | Item | Disposition |
|---|---|---|
| 1 | **COL-2** — $\psi$ as a cumulant generating function at `lem:bdiff` Step 1 | **FIXED.** Renamed $\mathsf H(\lambda)$, sans-serif, always with a parenthesised scalar argument, declared in §1.6 and §1.7. Same species C26 removed one Part earlier, same ground |
| 1 | **COL-1** — $q$ as a partition index, bare, in `prp:medianpart`'s **statement** | **FIXED.** Renamed $\mathsf p$, the lowercase of its own count $\mathsf P$ (C73), an *extension* of an existing claim and not a new slot. $Z_n\to\mathsf Z_n$ in the same proof (C59's device, fourth application) |
| 2 | **Product measurability of the estimated nuisances** | **FIXED.** `def:crossfit`(c′): all five nuisances are $\sigma(\mathcal I_{-k})$-measurable **random elements** of the named $L^2$ spaces, with a jointly measurable representative fixed once; and the **freezing/substitution lemma** is stated once, beside (P8), with proof and consumers |
| 2 | **Sup-norms of random functions over an uncountable index** | **FIXED**, `eq:supnormconv`: **genuine** supremum in $u$ (legitimate — continuity in $u$ makes it a countable sup) and **essential** supremum in $z$ w.r.t. $P_{\Delta Z}$. The $z$-side reading is the one the consumers need, because every use evaluates the envelope at a *shifted first argument* whose law need not be dominated by $P_{\Delta U,\Delta Z}$, while the second argument is always a draw of $\Delta Z$ |
| 2 | **(P8)'s transfer rule has the wrong hypothesis at four sites** | **FIXED.** A **third (P8) clause**, the $O_P$ companion, stated and proved in two lines with the device the $o_P$ companion already uses. Four sites re-routed: `lem:opnoise` Step 4, `lem:prelimtheta` Step 4, `lem:sandwich` Step 2, and — inheriting — `lem:aerr` Step 3 and `lem:unifop` Step 1 |
| 3 | **A2′(ii)** | **RETIRED IN PLACE**, on the A3 precedent, because it is **proved** from A2′(i) in full + B1(i), (ii), (iv.a) + (P1). Clause number kept as a struck placeholder |
| 3 | **B1(vi)** | **RETIRED IN PLACE**, for the third retirement reason: *it describes a different estimator*. The hunter's finite-grid witness is recorded with it, so a later dispatch reinstating the growing-grid design finds statement and witness together |
| 3 | **`lem:nusigma`(i)** | **WEAKENED** to $L^2(\mathcal X,\pi)$ |
| 4 | **A1b(i)'s list; A4(d)'s two false statements** | **FIXED**, both |
| 4 | **Warden B-1** | **FIXED**: §1.5h's calligraphic census (false at $\mathcal Z$); C74's blackboard rationale (false in *both* directions); C77's three drifted line-number citations (replaced by named anchors); and **C76's missing grep pattern**, which is the diagnosis behind the census error |
| 4 | **Warden B-2** | **FIXED**: the register enumeration totalled 73 against an inventory of 79; the six unlisted were §1.3's C12–C17. Both records now agree section by section |
| 5 | **The $\mu$ collision** | **FIXED by declaration, not rename.** `rem:pasrc`(5) makes the reading binding; H1's identity is subscripted $\mu_{\rm H1}$ *where the two must be told apart*; the three sites that compute one and use the other are qualified in place; glossary §8.8 documents it |
| 6 | **$\hat V$ has no fallback** | **FIXED**: $\hat V:=0$ off $\{\hat J\ \text{nonsingular}\}$ |
| 6 | **$d_Z\ge1$ silently assumed** | **FIXED**: stated in A4(ii), with the reason ($d_Z=0$ gives $\alpha=\tfrac12$ exactly and falsifies three sites) and with the honest note that $d_Z=0$ is an *easier* problem being excluded for bookkeeping, not a pathology |
| 6 | **(R-d) does not exist** | **DECLARED** as a struck placeholder, on the (P-b) precedent |
| 6 | **`def:crossfit`(d) says "three clauses"** | **FIXED**: four, A5(vi′) being the fourth, with the fold reading and its one real consequence (a single $\mathsf R$ serving all $\mathsf F$ complements) |
| 7 | **$\Sigma\succ0$** | **PROVED**, `lem:momzero`(v) / `eq:sigmapd`, from A1b(iv) + C2′(i). `thm:rootn`'s studentised conclusion now quantifies over **every** unit $\vartheta$; the proviso is a consequence |
| 7 | **Pointwise in $P$** | **STATED**, `rem:rootnscope`(6), with the three consequences and what a uniform statement would need |
| 8 | **U-2 / N6 — the parenthesised-superscript rule** | **FIXED**: the rule was false as stated; replaced by a **six-reading census** and a per-symbol reading, at §1.7 and pointed at from C58 |
| 8 | **N5 — the two stale A5(ii) sites in this memo** | **MARKED**, not rewritten: they are dated records of past dispatches, and rewriting a dated record erases the decision. Each now carries an explicit staleness marker, which is what they lacked |
| 8 | **The memo's "no consumer" list and (P8)'s consumption list** | **BOTH RE-SWEPT**, with the general repair stated: a "no consumer" list must carry the step it was swept at *in its rows*, not in a heading |

### D-00000000000000000.3 What I refused, and why

1. **I refused the counterexample-hunter's claim that blackboard $\mathbb C$ is live.** Pattern swept:
   `\mathbb C` — **zero occurrences** in every `.tex`. C49 **declined** that slot, for a stated reason. A
   declined slot is not a live symbol. **The finding survives on its other half**, which is decisive:
   $\mathbb Q_0$ and $\mathbb Q$ *are* live, at six lines of `lem:quantu` Step 3, so C74's *"blackboard is
   otherwise used only for $\IR$ and $\mathbb N$"* is false — and, as it happens, $\mathbb N$ sweeps to
   zero as well, so the sentence was wrong in **both** directions.
2. **I refused the proposal to weaken `lem:sandwich` Step 2 to $o_P(1)$.** The checker is right that the
   step over-reaches *under the rule it cited*, and right that Steps 4 and 6′ consume only $o_P(1)$. But
   the new $O_P$ companion licenses the **stated** conclusion $O_P(n_k^{-1/2})$ exactly — Chebyshev at
   exponent two, $a_n=n_k^{-1/2}$, $V_n=\|\hat\ell^{(-k)}\|^2_\infty E\|\Delta Z\|^2=O_P(1)$ — so no
   weakening is needed. **Weakening would also have forced an edit to Step 6′**, which cites the rate by
   name. Adding the clause is the smaller change *and* the stronger statement.
3. **I refused to rename `lem:bdiff`'s five remaining undeclared locals** ($\zeta_k$, $M_k$, $\Delta_k$,
   $\mathcal H_k$, $Q_\lambda$, bare $F$). Two of them — italic $M_k$, against C7/C32's retirement, and
   $\Delta_k$, against the binding period-difference operator — are **genuine breaches** and I do not
   dispute the finding. **The obstruction is that no short free letter survives inside that proof**:
   $N$, $V$, $b$, $B$, $K$, $F$ and $Q$ all occur in `lem:bdiff` itself, sans-serif $\mathsf M$ is taken
   (`lem:srctransfer`(ii)), $\mathsf K$ is taken *in the same lemma*, and $\Lambda$ is **binding**
   (A2b's budgets $\Lambda^{(0)},\Lambda^{(1)},\Lambda^{(\mu'')}$), so the obvious large-deviations name
   is unavailable. A rename here needs either a new font family or a rewrite of Steps 2–3 that names only
   the martingale increments, and both are larger than a priority-8 item warrants in a round that already
   touches five files. **Left open with the obstruction named**, which is more useful than a hasty rename
   that a later sweep has to undo.
4. **I refused to renumber (P8)'s objects** ($a_n$, $M_n$, $V_n$ in ASCII italic; warden T-1). The header
   is a **comment block**, stripped from the PDF by design, so no reader of the paper meets it; and the
   new clause deliberately uses the *same* letters as the existing $o_P$ companion, because internal
   consistency of (P8) is worth more than partial alignment with a convention its consumers do not
   actually print. **Left open.**
5. **I declined to adopt the `rem:pasrc`(4) proviso** as the resolution of the $\mu$ collision. Naming and
   assuming it would restore $\mu=s/(2a)$ and dissolve the collision — and would reinstate a derivation the
   file has proved unavailable, at the price of an undiagnosable spectral-alignment condition and a third
   constant `def:lfstep` must print before the data are seen. **The declaration route is strictly weaker
   and strictly honest.**

### D-00000000000000000.4 What is left open

- `lem:bdiff`'s five locals and (P8)'s ASCII objects — see §.3 items 3 and 4.
- **Warden U-3**, the $\Psi$ family: §1.7 carries $\Psi$ at two rows and neither mentions $\Psi^{(j)}_k$ or
  $\Psi^\theta_n$, and $\Psi_{jk}$ against $\Psi^{(j)}_k$ is a second unflagged hazard. **Not touched**;
  it needs a single row covering five members and I did not want to write it in the same round that
  rewrote the superscript rule those members sit under.
- **Warden U-1**, the prime convention: `lem:sandwich`(i′) conforms and **A5(vi′) reads the opposite way**
  (a different and *stronger* conclusion, which under the rule should be numbered), and `proofs.tex` Step 4′
  is a different conclusion inside the very lemma whose statement declares the rule. **Not touched**:
  A5(vi′) is a maintained clause tag cited across three Parts, and renumbering it is a change to the
  assumption block, not a notation fix. Recorded for the next round with that framing.
- **Warden U-5**: `prp:medianpart`'s $\varepsilon_{\mathsf p,n}$ now carries a two-index subscript and is a
  fifth member of the $\varepsilon$ family. Declared in §1.6 only implicitly; a row is owed.
- **A1c and C4′** remain without consumers (verified this round); both carry forward-reference notes.
- **The A2′(ii) Step-8 obligation** is now a stated forward obligation rather than a maintained clause.
  Step 8 (`prp:effbound`) must state the condition it needs at tier T3.

### D-00000000000000000.5 A correction owed in the other direction — the "necessity half"

The dispatch brief records that agents have been told *"`prp:sharpquad` supplies the necessity half —
$\delta_n=o(n^{-1/4})$ is necessary"*, and asks whether that has leaked into the theory files.

**It has not. I swept and the theory files say the opposite, at five sites, three of them written to block
exactly this reading:**

| Site | What it says |
|---|---|
| `results.tex` `rem:sharpscope`(1) | *"nothing here says that $\delta_n=o(n^{-1/4})$ is **necessary**"*, and explicitly declines "sharp for this moment function" as a necessity claim about the estimator |
| `results.tex` `rem:rootnscope`(2) | headed *"…and that is a weaker claim than necessity"*; states the result does **not** say $\delta_n=o(n^{-1/4})$ is necessary for $\sqrt n$-estimability by *some* estimator |
| `proofs.tex` (the `prp:sharpquad` block) | *"Writing '$\delta_n=o(n^{-1/4})$ is necessary' without the qualifier claims …"* — a written-in guard against the phrasing |
| `proofs.tex` (Part H) | *"a necessity claim would need a lower bound and none is proved or cited"* |
| `results.tex` (comment) | *"`prp:sharpquad` IS STATED AT THE SUP-OVER-BALL QUANTIFIER and not as a necessity …"* |

**The source is `proof_strategy_memo.md:255`**, §2.8: *"Scope: plan §2.6's, with `prp:sharpquad` supplying
the necessity half."* That file is the strategist's and is **outside my write scope**, so I have not
edited it. **Requested of the coordinator, on the N-13 model:** amend `proof_strategy_memo.md` §2.8 to
*"with `prp:sharpquad` supplying the **order-sharpness of the direct bound on the second-order
remainder** — so that $\delta_n=o(n^{-1/4})$ cannot be relaxed *by a better bound on that remainder* —
and **not** a necessity claim about $\delta_n$ or about $\sqrt n$-estimability by some estimator."*

**One qualification I owe in return, because I swept the memo and the leak is not confined to §2.8.**
The word ``necessity'' or ``necessary'' attached to `prp:sharpquad` appears at **six** places in that
memo, and they are not all the same claim:

| Site | Reading | Verdict against the artifact |
|---|---|---|
| §1.0 (`:181–183`) | *"sharp for this moment function — **not** necessary for $\sqrt n$-estimability by some estimator"* | **CORRECT and already scoped.** This is exactly `rem:sharpscope`(1)'s and `rem:rootnscope`(2)'s distinction |
| §0 table (`:155`) | *"now $\delta_n=o(n^{-1/4})$, and `prp:sharpquad` says that is necessary"* | **Over-strong**, unscoped |
| §1 table (`:194`) | *"no bound of the form $o(\delta^2)$ is available, and $\delta_n=o(n^{-1/4})$ is sharp for this moment function"* | The first half is right; ``sharp for this moment function'' needs §1.0's qualifier beside it |
| §2.5 (`:225`) | *"a lower bound on the operator norm of a quadratic form, hence a **necessity** statement about the rate condition"* | **The ``hence'' is the step `rem:sharpscope`(1) blocks.** A lower bound on $\sup_{\|h\|\le\delta}$ says the *direct bound* cannot be improved; it says nothing about the realised remainder at $h_k$ |
| §2.8 (`:254–255`) | *"with `prp:sharpquad` supplying the necessity half"* | **The site the brief names, and the least scoped of the six** |
| §5 (`:557`), §6.5 (`:640`) | *"makes this necessity rather than an unimproved bound"*; *"keeps the necessity statement"* | Same over-strength as §2.5 |

**The artifact is right and the memo is not, at five of the six.** *And §1.0 is the memo's own correct
version*, so the repair is a propagation of a distinction that file already draws rather than a new one:
replace "necessity" at the five sites with "order-sharpness of the direct bound", and point each at §1.0.
**The theory files need no change**; they already say all of this, and three of the five theory sites were
written expressly to block the reading.

*One further memo correction, recorded here so the two are not conflated when the memo is amended.*
`rem:sharpscope`(2) already records that the memo's registered display "states the identity on the wrong
ball" — exact on the $L^2(\pi)$ ball, an **upper** bound on the $\mathcal V$ ball, which is the operative
one since $h=\hat\varphi-\vdagger$ lies in $\mathcal V$. That is independent of the necessity question and
should be amended separately.

---

## D-0000000000000000. Dispatch 13 — **a relayed simulation finding against a maintained clause: adjudicated, upheld, acted on**

**Scope.** A Monte-Carlo verification of `thm:rootn` returned "Matches" and, in passing, reported that
`def:moment`'s italicised sentence — *"$J$ is the matrix of A3 and it is **not** $E[\Delta Z\Delta Z']$"* —
is false, and that three consequences follow. **The instruction was to adjudicate first and to stop if the
argument fails.** It does not fail. **Files edited:** `results.tex`, `proofs.tex`, `assumptions.tex`,
`notation_glossary.md`, this memo. **Not edited, by ownership:** `scripts/symbolic/specs/`,
`scripts/render-sync/check_rendering_sync.py`, `references.bib`, `paper/sections/theorems/`.

### D-0000000000000000.0 Pre-Theory Report

| Input | Read | Status |
|---|---|---|
| The relayed finding | in full, including the four named failure modes and the MC numbers ($\max\lvert E[\widetilde W\ell_\star\Delta Z']\rvert=2.2\times10^{-3}$ vs MC SE $8.9\times10^{-4}$; $\max\lvert t\rvert=2.46$ over 16 entries against expected max 2.08) | **Adjudicated independently before acting.** The MC evidence is consistent with zero and is *not* what the disposition rests on; the disposition rests on a proof |
| `results.tex` | `lem:shiftinv` + `rem:R1` in full; `lem:nusigma`; `cor:elldiff` + its comment; `def:weight`; `prp:orthog`(i)–(iii); Part I in full — `def:moment`, `def:crossfit`, `def:onestep`, `lem:momzero`, `lem:prelimtheta`, `lem:sandwich`, `thm:rootn` (T-1)–(T-5) and (R-a)–(R-e), `cor:ratefloor`, `rem:rootnscope`, `rem:rootnhyp` | |
| `proofs.tex` | (P1)–(P5) header in full, especially **(P3), (P4b) and (P4c)**; `lem:momzero` proof Steps 1–3; `lem:sandwich` proof Steps 1–10; `thm:rootn` Steps 0–4 | (P4c) is the decisive convention and it is already in the file |
| `assumptions.tex` | A0, A1, A1b + comment, A2, A2′, A2b, A3 + comment, A4 + comments (a)–(f), N1/N1′ + comment, A6 (retirement precedent), Discussion | |
| `notation_glossary.md` | §4 rows for $\ell_\star$, $\varrho$, $\widetilde W$, $\psi$, $J$, $\Sigma$, $q$; §7 tag table; §8.4; §1.5h and §1.6 | Three rows, read together, already entailed the finding — see §.5 |
| `proofs_review_dispatch3.md` | §(m-11) and the `prp:orthog`(ii) paragraph | Confirms a *third-party critic* already validated the identical device at the identical objects |
| `.claude/references/domain-profile.md` | **NOT PRESENT** | Declared gap, as in dispatches 8–12 |
| `Bibliography_base.bib` / `references.bib` | **not consulted** | No citation added, removed or moved |

**Two declared gaps, unchanged.** (a) No domain profile. (b) **No Bash**: no symbolic spec written or run,
no compile, no `check_rendering_sync.py`. Those are the parent's.

### D-0000000000000000.1 The verdict, and it does not rest on the argument as relayed

**UPHELD.** $E[\widetilde W\,\ell_\star(\Delta U,\Delta Z)\,\Delta Z']=0$ under A1, hence
$J=E[\Delta Z\Delta Z']$ exactly.

**The relayed route works but is not the shortest, and the shortest one is already in the file.** The
relayed route factorises a product of conditionally independent factors given $\Delta Z$:
$E[\widetilde W\ell_\star\mid\Delta Z]=E[\widetilde W\mid\Delta Z]E[\ell_\star\mid\Delta Z]$. That is
valid. **But it needs more than is necessary.** `lem:momzero`'s own **Step 2** already establishes, from
A1's first clause alone,
$$P(W=1\mid\Delta U,\Delta Z)=P(W=1\mid\Delta Z)=\varrho(\Delta Z)\quad\Longrightarrow\quad E[\widetilde W\mid\Delta U,\Delta Z]=0\ \text{a.s.},$$
which is convention **(P4c)** of the `proofs.tex` header. Given that, the factor
$\ell_\star(\Delta U,\Delta Z)\Delta Z'$ is $\sigma(\Delta U,\Delta Z)$-measurable and is simply pulled
out. **No factorisation of conditionally independent variables is needed, and no conditional-independence
lemma is invoked beyond the one already used two paragraphs earlier in the same proof.** The proof of the
new clause is therefore *five lines in a proof whose Step 2 already contains four of them*.

**Three sites in the file already contained the refutation.**

1. **`lem:nusigma`(v)**, proved since dispatch 1: *if A1 holds and $g=\widetilde W\,\Xi(\Delta U,\Delta Z)$
   for an integrable $\Xi$, then $E[g]=0$.* Take $\Xi(u,z)=\ell_{\star j}(u,z)z_k$. **No round evaluated it
   there.**
2. **`rem:rootnhyp`(1)**, in Part I itself, which describes what A1's first clause buys as
   "$E[\widetilde W\,\Xi(\Delta U,\Delta Z)]=0$" — the general statement, printed three pages after the
   sentence denying its instance.
3. **`prp:orthog`(ii)**, which runs the identical argument for the $L$-direction and which the round-3
   critic checked and endorsed in writing.

**So this is a bookkeeping failure, not a mathematical one, and that is the finding worth recording.**

### D-0000000000000000.2 The four failure modes, checked before acting — all negative

| Mode | Verdict |
|---|---|
| **Does $\ell_\star$'s *selection* reintroduce $W$?** | **No.** By `eq:Wdef`, $\ell_\star=\mathcal W\ell^\Pi_\star$ is a fixed Borel map $\IR\times\IR^p\to\IR^p$. The selection of $\ell^\Pi_\star$ from $\ell^\Pi_\dagger+\ker\mathcal A^\ast_{\rm cond}$ may be a functional of the joint law *including the law of $W$* — **irrelevant**: a law-dependent choice of a deterministic function is still a deterministic function, and $\sigma(\Delta U,\Delta Z)$-measurability of $\ell_\star(\Delta U,\Delta Z)$ is a property of the map's *arguments*, of which $W$ is not one. This is the sharpest of the four objections and it is the one the relayed factorisation route is *more* exposed to than the (P4c) route, since factorisation reasons about the law and the tower step reasons about measurability. |
| **Does N1 reintroduce $W$?** | **No, twice over.** N1 constrains the *anchor* $b$ of `def:weight`(b) and leaves $\ell$ untouched (the N1 comment block in `assumptions.tex` says so explicitly); and `eq:JSig` carries $\ell_\star$, not $L_\star$. |
| **Is the population $\widetilde W$ the one in $J$?** | **Yes, and the concern is right about $\hat J$.** `def:moment` writes "$\widetilde W:=\widetilde W(\varrho)$ **at the true propensity**". A4(i) puts $\varrho$ inside $[\varepsilon_\varrho,1-\varepsilon_\varrho]$, so `def:hatT`'s truncation is free *there*. $\widehat{\widetilde W}^{(-k)}$ is **not** conditionally centred, `eq:Jhat`'s second summand does **not** vanish at any $n$, and `lem:sandwich` Step 3 pays its $\|\hat\ell\|_\infty\|\mathsf r_k\|_{L^2}$ cost unchanged. **Recorded as blocked reading (iv.2).** |
| **Integrability for the tower step?** | **Free.** $\lvert\widetilde W\rvert\le1$ (P1), $\|\ell_\star\|_\infty<\infty$ (`cor:elldiff`), $E\|\Delta Z\|<\infty$ (A1b(iv) + Cauchy–Schwarz) — **which is verbatim the bound `lem:momzero` Step 3 already used to conclude $\|J\|<\infty$**. Nothing new is assumed. |

### D-0000000000000000.3 The history — and it is the more useful finding

The sentence has a three-round provenance and each round made it worse:

| Round | What was said | Status |
|---|---|---|
| 1 | Identification of $\theta_\dagger$ routed through A3 | **Wrong** — made identification contingent on A2 |
| 2 (M-3) | Repaired by routing through A1b(iv), on the ground that A3 is *"nonsingularity of a **DIFFERENT** matrix (J, involving $\ell_\star$) and is itself conditional on A2"* | **Half right.** The *conditionality* half is correct and survives. The *different matrix* half was asserted and **never computed** |
| 10 | `eq:JSig` displayed $J$ for the first time; the uncomputed half hardened into an **italicised** claim inside a **definition** | **False as printed** |

**The diagnosis is a $\sigma$-field scope slip of exactly the species (P4b)'s warning and (P4c) exist to
police.** $E[\widetilde W\,\cdot\,]$ annihilates a $\sigma(\Delta U,\Delta Z)$-measurable factor and does
**not** annihilate a $\sigma(X_1,X_2)$-measurable one. **The nearby object that genuinely does not vanish
is $q=E[\widetilde W\,\partial_u\ell_\star\mid X_1,X_2]$**, which `lem:secondord` and `prp:sharpquad`
consume and which is in the glossary. A reader carrying $q$ in mind reads
$E[\widetilde W\ell_\star\Delta Z']$ as non-vanishing too. **That is the error, and it is now recorded on
$q$'s own glossary row, where the next reader will meet it.**

### D-0000000000000000.4 The three claimed consequences, assessed independently

**(1) "A3 is redundant given A1 + A1b(iv), and `assumptions.tex`'s 'DIFFERENT matrix' comment is wrong."
CONFIRMED, with one correction to the hypothesis list.** A3 does not follow from A1 + A1b(iv) *alone*: the
second summand must first be a **finite matrix**, which needs $\|\ell_\star\|_\infty<\infty$ and hence A2,
A2′(i), A2′(iii) and B1(i), (ii), (iv.a) through `cor:elldiff`. **The full list is `lem:momzero`'s own**,
and — the load-bearing fact for the disposition — **every tag on it was already carried by every list that
carried A3.** So striking A3 is a *strict weakening* of four hypothesis lists with no change to any
conclusion. The comment is wrong and is corrected at `assumptions.tex` A1b(iv) and at three sites in
`results.tex`.

**(2) "`lem:momzero`(iii)'s second-derivative envelope bounds zero, i.e. is vacuous." CONFIRMED, and it is
*more* than vacuous — the map is exactly affine.** `eq:psiaffine`:
$E[\psi(\theta,\zeta_\star)]=-E[\Delta Z\Delta Z'](\theta-\theta_\dagger)$ for **every** $\theta$, because
$\Delta U(\theta,\vdagger)=\Delta U-\Delta Z'(\theta-\theta_\dagger)$ is *still* a function of
$(\Delta U,\Delta Z)$. So the second derivative is identically zero and the envelope is a correct,
uninformative bound. **The envelope is marked, not struck** (this project retires in place). **A2′(i.b) is
NOT freed** — it licenses `cor:elldiff` at all, and $\|\partial_u\ell_\star\|_\infty$ retains its
`prp:sharpquad` consumer. Only the *attribution* at `rem:rootnhyp`(1) changes.

**(3) "`def:moment`'s italicised sentence is false." CONFIRMED.** Retracted with its history in place.

**And the consequence the finding did *not* claim, which is the one that matters most.** The old ground
for the one-step in `def:onestep` read: *"A3 is a **local** rank condition and $\psi$ is **not** affine in
$\theta$ … so $\bar\psi_n(\theta)=0$ need not have a unique root and **no global rank condition is
available** to make it so."* **The population half of that is now false**: by `eq:psiaffine` a global rank
condition *is* available, it is A1b(iv), and $\theta_\dagger$ is the unique root of the population moment
on all of $\IR^p$. **The operational conclusion survives** — $\bar\psi_n$ at *estimated* nuisances is
genuinely non-affine and $\widehat{\widetilde W}^{(-k)}$ is not centred — **but it was being argued from
the wrong object, and a definition should not carry a false population claim.** Corrected.

### D-0000000000000000.5 Does anything get better? Yes, four things

1. **A3 becomes a theorem.** One maintained assumption retired; it was the **only** assumption in the
   block stated conditional on another assumption, a structure the file flagged as awkward at three sites.
2. **$J$ is symmetric positive semidefinite**, and it is the *same* matrix that identifies $\theta_\dagger$
   (A1b(iv)) and normalises the preliminary (`eq:prelimtheta`). The one-step and the plug-in share a
   normaliser.
3. **The population moment has a unique global root** (`eq:psiaffine`) — a genuinely new fact, and a
   stronger statement than the local rank condition A3 ever offered.
4. **$\Sigma$ splits exactly** (`eq:sigsplit`):
   $\Sigma=E[\Delta Z\Delta Z'\Delta U^2]+E[\widetilde W^2L_\star L_\star']$, the cross term dying by the
   same tower step. With $J=E[\Delta Z\Delta Z']$ the sandwich is the **oracle plug-in variance plus a PSD
   term** — which prices the debiasing correctly: it buys removal of the first-order bias
   $\langle\nu/\pi,h_k\rangle$ that `lem:prelimtheta` Step 4′ shows the plug-in carries at exact order
   $\|h_k\|$, and it is paid for in variance. **This is the standard DML trade, stated exactly rather than
   asserted.** It is a *live* finding for **Step 8** (`prp:effbound`), where the variance is computed.

**And what is NOT affected — the parent's two conjectures, both confirmed.**

- **$\Sigma$ does not vanish.** Confirmed: $\Sigma$ is *quadratic* in $\widetilde W$ and $J$ is *linear*
  in it. Under A4(i), $E[\widetilde W^2L_\star L_\star']\succeq\varepsilon_\varrho^2E[L_\star L_\star']$.
- **Neyman orthogonality is untouched.** Confirmed: `prp:orthog` is about the three *nuisance* directions,
  not $\partial_\theta$. **And it must be untouched, or the block collapses**: $\Delta h$ is
  $\sigma(X_1,X_2)$-measurable and **not** $\sigma(\Delta U,\Delta Z)$-measurable, so
  $E[\widetilde W\ell_\star\Delta h]\ne0$ — indeed **A2 is precisely the assertion that it equals
  $-E[\Delta Z\Delta h]$ for every $h\in\mathcal V$**. Were it zero for every $h$ one would get
  $\nu_{\Delta Z}\equiv0$, i.e. the instrument does not move the regressor. **The debiasing story is not
  touched; it is *localised*, to the $\varphi$-direction, where it always lived.** Recorded as blocked
  reading (iv.3).

### D-0000000000000000.6 What changed, by file

| File | Change |
|---|---|
| `results.tex` | `def:moment`: false sentence **retracted** with its history; typing note **amended** (form vs. value) and transferred to $\hat J$. `lem:momzero`: headline amended, **clause (iv) added** with `eq:psiaffine`, plus four blocked readings (iv.1)–(iv.4) including `eq:sigsplit`. `def:onestep`: "one step and not a root" ground **corrected**. `lem:sandwich`: A3 **struck** from (i)'s and (i′)'s lists. `thm:rootn` (T-2): A3 **struck**. `rem:rootnhyp`(1): A3 row moved to (2); the $\|\partial_u\ell_\star\|_\infty$ attribution to `lem:momzero`(iii) **struck**. `rem:rootnscope`(4) amended; **(5) added** (`eq:rootnturn`). `rem:R1`(ii) amended. Part-F typing comment amended. |
| `proofs.tex` | `lem:momzero`: Step 3 annotated; **Steps 4 and 5 added and proved**. `lem:sandwich`: Steps 6 and 6′ re-sourced from A3 to `lem:momzero`(iv) + A1b(iv). |
| `assumptions.tex` | **A3 RETIRED IN PLACE** on the A6 precedent, with the ground stated (*proved*, not *false*) and a long comment block carrying the history, the four checked failure modes and the non-propagation. A1b(iv)'s comment corrected. Header contract updated for two retirements with different grounds. Discussion paragraph on A3 rewritten. |
| `notation_glossary.md` | Rows restated: $J$, $\Sigma$, $\widetilde W$, $\ell_\star$, $q$, and the §7 **A3** tag row. §8.4 hazard **moved** from $J$ to $\hat J$. §1.5h dispatch-13 note: three new labels, two §1.6 locals declared. |

**Register unchanged at C1–C79. No new symbol.** Three new labelled displays: `eq:psiaffine`,
`eq:sigsplit`, `eq:rootnturn`.

#### ESCALATED — two files I do not own carry the retracted claim, and one of them is COMPILED

**This is not rendering lag and it must not be booked as rendering lag.** Rendering lag is "the rendered
file says *less* than the theory file". These two say something *false*.

| File | Line | What it says | What it should say |
|---|---|---|---|
| `paper/sections/theorems/lem-shiftinv.tex` | 87–89 | *"This route uses neither A2 nor A3: **A3 is nonsingularity of the different matrix** $J=E[\Delta Z\Delta Z']+E[\widetilde W\ell_\star\Delta Z']$, is itself conditional on the source condition A2, and enters only the one-step estimator."* | **`results.tex`:301–310 as now written.** A3 is retired; the matrices are the same; the *conditionality* is the surviving half. |
| `paper/sections/theorems/lem-adjoint.tex` | 438, 440 | *"…and the rank condition A3, all evaluate $\ell_\star(\Delta U,\Delta Z)$…"*; *"the object A2′ and A3 speak about…"* | **`results.tex`:886–893 as now written** — the referent is `eq:JSig`, not a retired tag. Less severe: a stale *tag*, not a false *claim*. |

**I did not edit them**, on the ownership boundary the dispatch set and because
`check_rendering_sync.py` is at 21 blocking with every item declared, and I have no Bash to re-run it.
**The parent should treat `lem-shiftinv.tex`:87–89 as a CRITICAL sync item, not as item 22 of the declared
lag**, and re-run the checker after the fix.

### D-0000000000000000.7 Specs — nothing touched, and here is why

- **`rootn-jacobian-sign`** encodes $\partial_\theta\bar\psi_n=-\hat J$ and `eq:JSig`'s **plus** sign.
  **Both are unchanged.** `eq:JSig` still displays two summands with a plus; what is new is a *theorem
  about the value* of the second one. $\hat J$ (`eq:Jhat`) is untouched and its second summand is
  non-zero.
- **`jacobian-dims-numeric`** checks a dimension. The dimension is unchanged.
- **No new spec is written**, there being no Bash this round. **Suggested for the parent, if a spec is
  wanted:** a numeric check that $E[\widetilde W\,g(\Delta U,\Delta Z)]=0$ for a family of $g$ under a DGP
  satisfying A1, *and* that $E[\widetilde W\,g(X_1,X_2)]\ne0$ for the same DGP — the pair, not either
  alone, is what encodes the $\sigma$-field boundary this round is about.

### D-0000000000000000.8 The two secondary items

**Item 2 — DONE.** `rem:rootnscope`(5) is added. I re-derived it rather than transcribing it:
$\sqrt n\delta_n^2=n^{-\beta}(\ln n)^{2\kappa}$ with $\beta=2\kappa\alpha-\tfrac12>0$ by `eq:frontier`,
and $t\mapsto e^{-\beta t}t^{2\kappa}$ increases for $t<2\kappa/\beta$, so the turnover is at
$n^\ast=\exp\{2\kappa/(2\kappa\alpha-\tfrac12)\}$. **The relayed numbers check out exactly**: at $\mu=2$
($\kappa=\tfrac45$) and $\alpha=0.32$ one gets $\beta=0.012$, $2\kappa=1.6$ and
$n^\ast=e^{400/3}\approx10^{58}$ — matching the reported $n^{-0.012}(\ln n)^{1.6}$ and $n\approx10^{58}$.
**Only the derived form is written into the `.tex`**; the simulation's fitted exponents are not, since I
cannot verify them. The reading recorded is that `eq:frontier` is a *qualitative* frontier: crossing it
makes the remainder vanish eventually and says nothing about where.

**Item 1 — DEFERRED, and it is a real item.** `eq:lfsched`'s scale non-invariance and `prp:stopfeas`'s
partial factor count. **It is deferred rather than declined**, for two reasons and neither is budget: (a)
the reported decomposition — rate part $\approx8$ inside `prp:stopfeas`'s stated 5–50, the remaining
$\approx1{,}200$ being `eq:normconst`'s **constant prefactor**, with
$\omega_n/\|\hat{\mathcal A}\vert_{\mathcal S_n}\|=640$–$926$ — is a claim about a *constant in a
definition*, and repairing it means re-opening `def:lfstep` and `eq:normconst`, which is Part H and a
different dispatch's contract; (b) the accompanying claim that **Lepskii never saturates and carries no
unidentified constant** is a comparative statement about the two stopping rules that would change what
`def:lfstep`(2a)–(2b) says about *why* the schedule is preferred here, and `rem:pasrc`/CP-13 is where that
lives. **Recorded as open item Q-4** and flagged for the Part-H dispatch. **The one thing I will state
now**: if the discrepancy rule saturates the cap in 100% of replications at $\mathsf c_{14}\le10^{-2}$ and
stops at $m=1$ always at $\mathsf c_{14}=1$, then `prp:stopfeas`'s feasibility statement is *tuning-parameter
critical* in a way its text does not disclose, and that is a disclosure defect independent of whether the
factor count is repaired.

### D-0000000000000000.9 What I refused

1. **I did not replace $\hat J$ by $\mathbb E_n[\Delta Z\Delta Z']$.** It would be consistent for $J$, and
   it is tempting now that $J$ is known. **Refused**: it breaks the exact identity
   $\partial_\theta\bar\psi_n=-\hat J$ that `def:onestep` establishes and `thm:rootn` Step 1's algebra
   rests on, and it would move `rootn-jacobian-sign`. **Recorded as an option not taken**, at blocked
   reading (iv.2), rather than silently omitted.
2. **I did not delete `lem:momzero`(iii)'s second-derivative clause.** It is true. It is marked vacuous in
   place, per this project's standing rule.
3. **I did not strike A2′(i.b), A2′(ii) or A2.** (i.b) keeps a live consumer and a licensing role; (ii)'s
   redundancy is a *pre-existing* recorded finding this round does not adjudicate; A2 is consumed at
   `lem:biasexp`, `eq:biasb1`, which is untouched.
4. **I did not write the simulation's fitted exponents into the `.tex`.** Only what I derived.
5. **I did not adopt the relayed argument as given.** The factorisation route is valid but is exposed to
   the selection objection in a way the (P4c) route is not; the file gets the route it can defend.

---

## D-000000000000000. Dispatch 12 — **strike-2 fix pass on Part I: four items, bounded**

**Scope.** `proofs_review_dispatch11.md` (**91/100**, 0 CRITICAL, 0 MAJOR, 2 MODERATE, 2 MINOR). The file
already clears the 80 commit gate and the 90 PR gate; what these four close is the distance to 95.
**Fix-only. No Step 8. No new result, no new assumption, no new hypothesis.** One lemma is **split into two
clauses** and one glossary row is **restated**. Files edited: `results.tex`, `proofs.tex`,
`notation_glossary.md`, this memo. **`assumptions.tex` not edited** — the A5(ii) sweep reached both of its
comment blocks in dispatch 11 and N1 is a glossary defect, not an assumption defect. **Not edited, by
ownership:** `scripts/symbolic/specs/` (no Bash, so no spec written or verified),
`scripts/render-sync/check_rendering_sync.py`, `references.bib`.

### D-000000000000000.0 Pre-Theory Report

| Input | Read | Status |
|---|---|---|
| `proofs_review_dispatch11.md` | in full, including §3's two rulings, §5's re-verification of `lem:sandwich`(i′) and `eq:foldrates`, §8, and the orchestrator's appended CHECK-6 scope note | Read first, as instructed. All four findings verified against the live files before acting |
| `notation_glossary.md` | §5 rate rows (`\hat\delta_n`, `\delta_n`, `\epsilon_n`, `r_n`), the §7 A5 row, the `\hat\varphi^{(k)}` row at §4, §6 (C73–C79) | N1 confirmed: line 565 wrote the log-free form; line 626 the log-inflated one |
| `results.tex` | `rem:dirmember` + `rem:obligations` (O1)–(O4) in full; Part I: `def:crossfit`, `def:onestep`, `lem:prelimtheta`, `lem:sandwich`, `thm:rootn` (T-1)–(T-5), (R-a)–(R-e), `cor:ratefloor`, `rem:rootnhyp` | |
| `proofs.tex` | `lem:momzero` proof Steps 1–2; `lem:prelimtheta` proof in full; `thm:rootn` Steps 0–6; `cor:ratefloor` proof in full | N2(b) confirmed at `:4927`; N4 confirmed at Step 0 |
| `assumptions.tex` | A1, A1b, A5 + the two `eq:deltalog` comment blocks | Read to confirm no fifth site of N1's class; none found in that file |
| `.claude/references/domain-profile.md` | **NOT PRESENT** | Declared gap, as in dispatches 8–11 |
| `Bibliography_base.bib` / `references.bib` | **not consulted** | No citation added, removed or moved this round |

**Two declared gaps, unchanged.** (a) No domain profile. (b) **No Bash**: no symbolic spec written, no
checker run, no compile. The compile is the parent's.

### D-000000000000000.1 The four dispositions

1. **N1 (MODERATE, −4) — glossary `\delta_n` row. ACCEPTED, done.** The definitional row now reads
   $\delta_n:=(\hat\delta_n\ln n)^{2\mu/(2\mu+1)}$ at `eq:deltalog`'s object, with the log-free form struck
   rather than deleted, the fold reading (`eq:foldrates` display 1) added, and the disposition pointer to
   `rem:rootnlog`. **One thing added beyond the brief**, because it is the reading the row's own history
   invites: the inflation is at the level of $\hat\delta_n$ and is applied **once**, $\hat\delta_n\mapsto
   \hat\delta_n\ln n$ *inside* the power — never $\delta_n\mapsto\delta_n(\ln n)^{2\mu/(2\mu+1)}$ on top.
   That is the double-inflation misreading the `assumptions.tex` A7 comment block warns against, and the
   definitional row is where a reader would acquire it.
2. **N2(a) (MODERATE, part of −3) — `cor:ratefloor`'s fourth hypothesis. ACCEPTED; route (i) chosen.**
   `lem:prelimtheta` is split into clause **(i)** (the rate `eq:prelimthetarate`, plus consistency under
   $\delta_n\to0$, on a list *without* A5(ii)'s second half) and clause **(ii)** (the threshold
   `eq:prelimthetathresh`, the only clause A5(ii)'s second half enters). Reasoning at §.2 below.
3. **N2(b) (MODERATE, part of −3) — the `lem:momzero`(i) citation at `proofs.tex:4927`. ACCEPTED, done.**
   Replaced by the tower argument from A1's second clause with $E\|\Delta Z\Delta U\|<\infty$ from A1b(iv),
   both on `lem:prelimtheta`'s own list. **The finding is stronger than stated and the file now says so:**
   `lem:momzero`(i) is the statement $E[\psi_\star]=0$, of which $E[\Delta Z\Delta U]=0$ is *one of two
   summands*, so the old citation was an appeal to that lemma's **Step 2** and not to its statement — the
   same species as N2(a), not merely an over-wide hypothesis import.
4. **N3 (MINOR, −1) — (O3)'s home list. ACCEPTED, done.** `rem:obligations`(O3) now lists three homes:
   `rem:dirmember`, (R-a), and `def:crossfit`(c) — with the reason the third is of a different kind (a
   remark can be declined and a theorem hypothesis refused; a **definition** is adopted by every Part-I
   result that adopts `def:crossfit`, and `def:onestep`'s Jacobian identity consumes it). The item records
   that the dispatch-11 relocation created the third home and was right to.
5. **N4 (MINOR, −1) — the stage-vs-fold $k$ collision. ACCEPTED, done — at two sites and at the root.**
   `proofs.tex` Step 0 and `results.tex` (T-4) both said "$k=\bar k$"; both now say *final linearisation
   stage $\bar k$ of `def:lfstep`* in words, and the proof site states the separation explicitly.

### D-000000000000000.2 The choice on N2(a), and why route (i)

The brief offered two routes. **I took the first — a clause on `lem:prelimtheta` — and did not take the
second.** Three reasons, in order of weight.

- **The second route does not close the defect; it renames it.** A sentence in `cor:ratefloor`'s proof
  supplying the fourth hypothesis would have to say *what supplies it*, and the only available answer is
  "Steps 1–4 of `lem:prelimtheta`'s proof deliver the first equality without the threshold." That is an
  appeal to a proof, which is the exact thing `lem:sandwich`(i′) was written to end. The critic's own
  wording of the finding says so: *"that is a reading of the lemma's proof."* A repair that reproduces the
  defect one line further down is not a repair.
- **The corollary consumes the lemma twice, and route (ii) closes one.** Besides the $o_P(1)$ fourth
  hypothesis, `proofs.tex:5417` uses $\|\hat\theta^{(0)}-\theta_\dagger\|=O_P(n^{-1/2}+\delta_n)$ for
  $\Psi^\theta_n$. The brief's route (ii) supplies the first; the second would still have rested on the
  lemma-with-the-threshold. **Clause (i) supplies both from a statement**, and the corollary's proof now
  cites it for both.
- **It makes the treatment of the class uniform.** N2 is one finding about a class with four instances;
  two were repaired in dispatch 11. Repairing the third by a different device would leave the file with two
  idioms for one problem.

**One point of internal hygiene, stated in the lemma because the file cares about it.** This is **not** the
(i)/(i′) device of `lem:sandwich`. That device states *one* conclusion on *two* lists; here the two clauses
have *different* conclusions (a rate and a threshold), so they are **numbered and not primed**. Using the
prime here would have made the file's own notation ambiguous at the very site meant to fix an ambiguity.

**Nothing is lost and nothing is assumed.** Steps 1–4 of the proof were already threshold-free; the split
only relocates where Step 5 stops and Step 6 begins. `eq:prelimthetarate` keeps its label and its content
(the first equality); the second equality becomes `eq:prelimthetathresh` on clause (ii). No result loses a
hypothesis it was using, and no result gains one.

### D-000000000000000.3 What the fix reached beyond the four named sites, and why each was forced

Declared, per the brief's instruction to say so and do the minimum.

| Site | Edit | Why it was forced |
|---|---|---|
| `proofs.tex` `lem:prelimtheta` Step 4 | "by A5(ii)" → "by the **first** display of `eq:foldrates`" | The lemma's hypothesis list no longer contains A5(ii) in full; a proof step citing the whole clause would contradict the statement it proves |
| `proofs.tex` `lem:prelimtheta` Step 5 | split into Steps 5 (clause (i)) and 6 (clause (ii) + the collapse) | A two-clause statement needs a two-part proof |
| `proofs.tex` `thm:rootn` Steps 1 and 2 | `\cref{lem:prelimtheta}` → `\cref{lem:prelimtheta}(i)`, with $\delta_n\to0$ attributed *a fortiori* to A5(ii)'s second half | Bare citation of a now-clausal lemma is less precise than before the split; the file's standard since round 1 is to cite by clause |
| `results.tex` `rem:rootnhyp`(1), the A5(ii) row | rewritten to say which **half** is consumed where | After the split, "at Steps 2 and 4 **and in `lem:prelimtheta`**" over-attributes: `thm:rootn` never invokes clause (ii); Step 2 takes clause (i)'s uncollapsed rate and applies the threshold itself. Leaving it would have created a fresh stale claim of finding 4.2's own species |
| `results.tex` `rem:rootnhyp`(4) | `\cref{lem:prelimtheta}` → `(i)`, "A5(ii)" → "A5(ii)'s second half" | Same reason: m-23's answer names the rate, which is now clause (i)'s |
| `results.tex` (T-4) of `thm:rootn` | second "$k=\bar k$" disambiguated | Same class as N4, in the *statement* rather than the proof, and in a clause that says "read at each fold" seven words earlier — a worse instance than the one named. Repairing the proof site alone would have recreated N2's own shape |
| `notation_glossary.md`, `\hat\varphi^{(k)}` row | the **sign** convention recorded: nonnegative parenthesised superscript = stage, negated = fold complement | This is N4's **root**. The glossary declared "parenthesised superscript = stage" and Part I then introduced $\hat\varphi^{(-k)}$, $\hat\ell^{(-k)}$, $\hat\varrho^{(-k)}$, $\hat L^{(-k)}$, $\hat b^{(-k)}$, $\hat\zeta^{(-k)}$, $\hat\psi^{(-k)}$ with **no row anywhere** — so the collision was licensed by the file where notation is declared. Fixing two instances without the convention leaves the next author to recreate them |

### D-000000000000000.4 Nothing refused this round

Both refusals of dispatch 11 were upheld by the critic and neither is re-opened. **Of the four findings of
dispatch 11's review I contest none** — each was verified against the live files and each was real. The
only place I depart from the brief is the *choice* it explicitly delegated (N2(a)), and the reason is at
§.2.

**What I did not touch, per the scope discipline:** (P-b), the perturbation-of-$\mathcal A$ route, A6's
retirement, the Donsker rejection, the derivative reparameterisation, and the design configuration
$(\mu,s,a)=(2,3,\tfrac34)$ — none re-opened, none treated as retired.

### D-000000000000000.5 What this dispatch does NOT do

- **No Step 8.** Part I is unchanged in content: same theorem, same corollary, same hypotheses, same rates.
- **No new assumption, no new hypothesis clause, no new maintained object.** The one new label,
  `eq:prelimthetathresh`, names the *second half* of a display that already existed.
- **No spec written and no checker run** — no Bash. The claim worth a spec from this round is
  `lem:prelimtheta`'s split: that Steps 1–4 are threshold-free is a *bookkeeping* claim, not an algebraic
  one, so it is a job for the assumption-auditor's usage matrix and not for SymPy. Named here, not written.
- **No edit to `assumptions.tex`.** N1 lives in the glossary; A5(ii) itself has read `eq:deltalog` since
  dispatch 10.

---

## D-00000000000000. Dispatch 11 — **strike-1 fix pass on Part I**

**Scope.** The Part-I review (48/100): 4 MAJOR, 4 MODERATE, 6 MINOR, plus two items relayed from the
critic. **Fix-only. No Step 8. No new theorem.** Files edited: `results.tex`, `proofs.tex`,
`assumptions.tex`, `notation_glossary.md`, this memo. **Not edited, by ownership:**
`scripts/symbolic/specs/` (named only), `scripts/render-sync/check_rendering_sync.py` (the parent added the
blocking row), `references.bib`.

### D-00000000000000.0 Pre-Theory Report

| Input | Read | Status |
|---|---|---|
| The dispatch brief (Part-I review, 48/100) | in full: 4 MAJOR, 4 MODERATE, 6 MINOR, the two relayed items, the do-not-re-litigate list, the LaTeX note on `\vdagger` | Every finding verified against the live files before acting; two are answered with a *correction to the finding's framing* rather than compliance (below) |
| `results.tex` | Part F (`def:weight`, `rem:anchor`, `rem:dirmember`, `rem:obligations`, `prp:orthog` head, `lem:balance`(ii)–(iii) head); Part E (`cor:elldiff` + its round-8 comment, `lem:reprsmooth` head); Part H (`prp:stopfeas`, `rem:phirscope`); **Part I in full** | |
| `proofs.tex` | (P1)–(P9) header in full; **Part I proofs in full** (`lem:momzero`, `lem:prelimtheta`, `lem:biasexp`, `lem:epterm`, `lem:sandwich`, `thm:rootn`, `cor:ratefloor`, `prp:medianpart`); the Part-I standing-convention header | |
| `assumptions.tex` | A2′, A2b, A5 + all comment blocks, A7's comment blocks, A8 + comment, the budget table row for $\mu''$ | |
| `notation_glossary.md` | header + register, §1.5e ($\mu''$, $H^{\mu''}$), §1.5h (C73–C79 in full), §1.6, §8 | |
| `scripts/render-sync/check_rendering_sync.py` | CHECK 6's new row, in full, **including its regex** | Read so that the repair to `rem:phirscope`(2) clears the row and the two legitimate past-tense sites are not disturbed |
| `theory_memo.md` | §D-…3, §D-…5, §D-…6, §D-…7 | The four sections the brief asks about |
| `.claude/references/domain-profile.md` | **NOT PRESENT** | Declared gap, as in dispatches 8–10 |
| `Bibliography_base.bib` / project `references.bib` | **not consulted this round** | No citation was added, removed or moved. `newey1994h` and `vaart1998` remain flagged for the librarian from dispatch 10 |

**Two declared gaps.** (a) No domain profile. (b) **No Bash, so no symbolic spec was written and no checker
was run.** §.7 names five specs; the CHECK 6 row was read but not executed. The compile is the parent's.

### D-00000000000000.1 The four MAJORs

1. **The false identity (−10).** $\frac{1-\kappa}{4\kappa}=\frac1{8\mu}$, not $\frac1{4\mu}$; margins
   $\frac3{20}$ at $\mu=\frac56$ and $\frac1{16}$ at $\mu=2$. **The finding is not withdrawn**: the
   implication holds, the constant is *exact* at $\alpha=1/(4\kappa)$, and the direction in $\mu$ survives.
   `rem:rootnlog`(3)(b) now displays the identity (`eq:rndeltamargin`) and records the error. Same repair at
   `proofs.tex` `thm:rootn` Step 4(c), and at three memo sites. Full note at §D-…3.
2. **(P8) for $o_P$ (−8).** The $o_P$ companion is now stated in the `proofs.tex` header with a two-line
   proof, and cited at `lem:epterm` Step 6 and `lem:sandwich` Step 8. **I did not use the brief's suggested
   form** — see §D-…2 below for why, and for the form that works.
3. **The A5(ii) sweep (−7).** `rem:phirscope`(2) rewritten; `prp:stopfeas`(iv)'s opening display repaired;
   two `assumptions.tex` comments swept; the two past-tense sites left alone. `rem:rootnlog`(1) now records
   `prp:stopfeas`(iv)'s *internal* inconsistency, which strengthens route (A).
4. **`cor:ratefloor` (−5).** Scoped by branch in three clauses. **This goes beyond the brief**: scoping to
   (R-e.2) is necessary but not sufficient, because $\epsilon^L_n$ survives via (R-c.2) — the claim is true
   only on (R-e.2) **and** (R-c.1). A5(vi) with $s>\frac12$ added to the corollary's list. $\mu'$ deleted;
   glossary §8.7 is the record.

### D-00000000000000.2 Where I did not comply, and why

**(a) The $o_P$ companion is stated in the $V_n$ form, not the $M_n$ form the brief proposed.** The brief's
form — replace "$M_n=O_P(1)$" by "$M_n=o_P(1)$" in (P8)'s transfer rule — **is a true statement**, and the
algebra works: on $\{M_n\le\epsilon\}$ one has $\{|X_n|>\epsilon a_n\}\subseteq\{|X_n|>M_na_n\}$, so
$P(|X_n|>\epsilon a_n)\le P(M_n>\epsilon)+E[P(|X_n|>M_na_n\mid\mathcal G)]$. **But neither of the two sites
has its hypothesis.** To assert "$P(|X_n|>M_na_n\mid\mathcal G)\to0$ a.s." at a *single moving threshold*
$M_n$ with $M_n\to_p0$ one needs a **rate** for the conditional second moment, and `lem:epterm` supplies
$o_P(1)$ with no rate — that is precisely the concession `lem:epterm`'s statement is careful about. What
conditional Chebyshev and conditional Markov *do* deliver is a bound valid at **every** $\epsilon$ with a
$\mathcal G$-measurable numerator: $P(|X_n|>\epsilon a_n\mid\mathcal G)\le V_n\epsilon^{-q}$. So the
companion is stated in that form, with $q=2$ at `lem:epterm` (Chebyshev) and $q=1$ at `lem:sandwich`
(Markov). **The brief's diagnosis is exactly right and its repair is one step short of usable**; the header
records both forms and says which is invoked.

**(b) "(R-a) discharges (O3)" is corrected to "carries", against the brief's wording.** The brief says
`rem:obligations` "still says two remain open while (R-a) discharges (O3) and (R-c) prices (O2)". (R-c)
prices (O2) — agreed, and recorded. But **(R-a) does not discharge (O3): it assumes it.** By
`rem:obligations`'s own test, an obligation carried as an explicit hypothesis of every stated result is
*still* a verification owed by the construction — that is the test's whole point, and it is what distinguishes
(O3) from (O1) and (O4), which were *verified*. So **"two remain open" is retained** and what changes is the
status lines, which now name the Part-I consumers. Recording this is not pedantry: if assuming a construction
counted as discharging it, `rem:obligations`'s test would license A5(iv)'s round-7 defect, which is the exact
thing the remark exists to prevent.

**(c) The MINOR on `def:onestep` is repaired at a different site than the brief names.** The brief says
"`def:onestep`'s identity needs $\partial_u^2\hat L=\partial_u\hat\ell$, which is only in (R-a)". **The
identity $\partial_\theta\bar\psi_n=-\hat J$ needs only the first derivative** $\partial_u\hat L=\hat\ell$,
plus $\theta\mapsto\Delta U(\theta,\cdot)$ affine and a finite sum. What *does* silently ride on (R-a) is one
step earlier: **`def:crossfit`(c) invokes `def:weight`(b) at an $\hat\ell^{(-k)}$ whose boundedness and
$u$-continuity `def:weight`(b) requires to be well posed** — and only (R-a) supplied them. So
`def:crossfit`(c) now states those three properties itself, and `def:onestep` says explicitly that its
identity uses one derivative and that the second is hypothesised at `thm:rootn` Step 1. **The brief's
concern is right and its site is one clause downstream of the defect.**

### D-00000000000000.3 The eight remaining findings, disposed

| Finding | Disposition |
|---|---|
| MODERATE, A5(iv)/(R-e.1) fold indexing | **Accepted.** `def:crossfit`(d) is new and declares `eq:foldrates` once; (R-e.1) carries $\max_k$ explicitly and the strengthening is charged there rather than read into A5(iv); `lem:epterm` and `lem:prelimtheta` cite the fold reading in their own lists. A comment block in `assumptions.tex` records it at the clauses' home |
| MODERATE, (R-b)'s unused clause | **Accepted; deleted.** With the process note at §D-…5 |
| MODERATE, (T-4) vs Step 0 | **Accepted.** (T-4) annotated by status; Step 0 corrected; `lem:sandwich`(i′) added and proved at Step 6′; `cor:ratefloor` gains A5(vi) with $s>\frac12$ and invokes (i′) |
| MODERATE, `lem:momzero` / `cor:elldiff` | **Accepted.** A2′(i) in full; A2′(ii)-redundancy re-attributed; `lem:sandwich`'s list now inherits `lem:momzero` in full — **and I found one more of the same class**: A1 and B1(i), (ii), (iv.a) were missing from `lem:sandwich`, which cites `lem:momzero`(ii)–(iii) |
| MODERATE, the non-promotion ground | **Accepted, reason replaced at three sites, decision kept.** New `rem:rootnhyp`(5) |
| MINOR, `rem:rootnhyp`(2) heading | **Accepted** — re-headed "NOT listed" |
| MINOR, `lem:epterm` headline | **Accepted** — the headline now says the consistency is established below and is not free |
| MINOR, `lem:prelimtheta` collapse | **Accepted, and fixed on the proof side**: Step 2 is restated at the uncollapsed rate, so the lemma's claim becomes true rather than the lemma's claim being softened |
| MINOR, `prp:medianpart` per partition | **Accepted** — the hypothesis is read at all $\mathsf{PF}$ fold complements, and $\mathsf P$ fixed is now used **three** times, not two |
| MINOR, $\Psi^\theta_n$ "written out" | **Accepted** — the `results.tex` sentence now matches glossary C77 |
| MINOR, (P8) genericity | **Accepted** — the transfer rule is generic, the conditioning convention is Part H's and is re-declared; fixed in both files |
| Relayed: §.6 short by one | **Accepted** — $\epsilon^L_n$ added as item 3′, with (O3) added as 4′ |
| Relayed: the four owed specs | **Accepted** — `rootn-biasexp-identity` demoted with the reason; `rootn-rate-products` and `rootn-prelim-threshold` named. **Not written** |

### D-00000000000000.4 What this dispatch does NOT do

- **No Step 8**, no new theorem, no new assumption. One definition clause, one lemma clause, one hypothesis
  clause deleted.
- **No symbolic spec written**, and no checker run — no Bash this dispatch.
- **No re-litigation** of (P-b), the perturbation-of-$\mathcal A$ route, A6's retirement, the Donsker route,
  or the derivative reparameterisation. $(\mu,s,a)=(2,3,\frac34)$ is **not** retired.
- **The objects the review verified as correct are untouched**: `lem:biasexp` and its four bounds,
  `eq:rootnid`, `eq:threeway`, the $-\hat J$/$+\hat J^{-1}$/$J^{-1}$ sign chain, `prp:medianpart`'s
  influence-function argument, the anchor device, route (α) for (R-a), `lem:epterm`'s concession,
  `lem:prelimtheta`'s rate, the $\ln n$ route (A), and the seven declared-open items of §.6.

### D-00000000000000.5 One process note, because it is the round's real lesson

**Dispatch 10 audited the maintained block clause by clause, found three non-uses in it, and shipped an
unused clause in its own new hypothesis.** (R-b)'s $E\|b_\star\|^4<\infty$ was never consumed. The same
asymmetry produced the other three MAJORs: an amendment to A5(ii) whose *sweep* was run over the maintained
block and not over the new Part; a headline arithmetic claim carried in prose rather than displayed; and a
primitives claim asserted for `cor:ratefloor` on a branch the corollary does not take. **The pattern is
outward-facing rigour.** Two cheap countermeasures, both now in place: `eq:rndeltamargin` and
`eq:foldrates` **display** what was previously asserted in a sentence, and every new hypothesis clause in
Part I now names its consuming site in `rem:rootnhyp`(1).

---

## D-0000000000000. **Step 7 — `thm:rootn`**, and one amendment to the maintained block

**Scope.** Memo §10 Step 7, in full: `thm:rootn` at plan §2.6's scope, `cor:ratefloor` (T2′) as the floor,
and L-8 through L-11 plus L-14. Files edited: `results.tex` (Part I, new), `proofs.tex` (Part I proofs,
new), `assumptions.tex` (A5(ii) amended; A3's and A4's comment blocks gain their consumers),
`notation_glossary.md` (§1.5h, C2 corrected, §6 rows, §8.0), this memo. **Not edited, by ownership:**
`scripts/symbolic/specs/`, `quality_reports/literature/panel-npiv-discrete/references.bib`.

### D-0000000000000.0 Pre-Theory Report

| Input | Read | Status |
|---|---|---|
| `proof_strategy_memo.md` | §§0–10 in full; §1.1 item 8, §2.8, §3.1, §3.5, §3.7, §4 (L-6…L-11, L-14), §6.6, §9, §10 | The Step-7 contract. Machinery not re-litigated |
| `results.tex` | Part A in full; Part E (`lem:nusigma`, `lem:adjoint`, `cor:elldiff`, `lem:levels`); Part F in full (`def:weight`, `def:dirclass`, `lem:solset`, `lem:secondord`, `rem:dirmember`, `rem:obligations`, `prp:orthog`, `lem:balance`); Part G (`lem:formstruct`, `prp:sharpquad`, `rem:sharpscope`); Part H (`prp:hatAprop`, `prp:tccfails`, `rem:tccwhy`, `prp:stopfeas`, `def:srcball`, `lem:unifop`, `def:lfstep`, `prp:phirate`, `rem:pasrc`, `rem:paenvelope`, `rem:lfnonlinear`, `rem:phirscope`) | |
| `proofs.tex` | (P1)–(P9) header in full; `prp:phirate` Steps 3–6; `rem:h6bandwidth` (0)–(5); `eq:jackson`; `lem:bdiff` | (P8) and (P9) are new tools and both are used |
| `assumptions.tex` | A0, A1, A1b, A2, A2′, A2b, A2c, H1, A3, A4, N1, N1′, A5, A8, C1, C2′ | |
| `notation_glossary.md` | header + register, §1.1–§1.5g, §1.6, §1.7, §5, §6, §7, §8 | |
| `theory_memo.md` | §D change-log tail, dispatches 8–9 in full; the dispatch-8 CFF pointer | Closed routes respected: (P-b) struck, perturbation-of-$\mathcal A$ refused, A6 retired |
| `Bibliography_base.bib` / project `references.bib` | grepped for `newey`, `vaart`, `chernozhukov`, `dunker`, `centorrino`, `severini` | **Repaired by the librarian mid-dispatch.** `centorrinofeveflorens2019` and `dunker2021` exist and are now cited |
| `.claude/references/domain-profile.md` | **NOT PRESENT** | Declared gap, as in dispatches 8–9 |

**Two declared gaps.** (a) No domain profile. (b) **Two classical anchors for the one-step have no key in
this project's `references.bib` and are therefore named in prose and not cited**: Newey & McFadden (1994,
*Handbook* ch. 36) §3.4 and van der Vaart (1998) Ch. 5. `newey1994h` exists only in
`quality_reports/literature/volatility-loc-scale/references.bib`; `vaart1998` exists nowhere in this
project. `def:onestep` says so in the text, on the precedent `rem:lfnonlinear`(c) set. **Flagged for the
librarian: two keys, `newey1994h` and `vaart1998`.** Nothing was invented and no key was created.

### D-0000000000000.1 The statement, as written

`thm:rootn` (`results.tex` Part I). Hypothesis groups **(T-1)–(T-5)** — *not* (H1)–(H5), which a draft
used and which collides with H1 the Hilbert-scale link, cited inside group (T-5) — plus four additional
hypotheses **(R-a)–(R-e)** on the model of `prp:phirate`'s (P-a)–(P-g). Conclusion:

$$\sqrt n(\hat\theta-\theta_\dagger)=J^{-1}n^{-1/2}\textstyle\sum_i\psi_\star(O_i)+o_P(1)\xrightarrow{d}N(0,J^{-1}\Sigma J^{-1\prime}),\qquad \hat V\xrightarrow{p}J^{-1}\Sigma J^{-1\prime},$$

with $J=E[\Delta Z\Delta Z']+E[\widetilde W\ell_\star\Delta Z']$ and $\Sigma=E[\psi_\star\psi_\star']$,
plus a studentised statement in a direction $\vartheta$.

**Three objects the memo's target names and no file displayed, now displayed.** (i) The moment function
$\psi$ — cited by `lem:secondord`, `prp:orthog`, `prp:sharpquad` and declared *only in
`notation_glossary.md`*; now `eq:psidef`. (ii) $J$ and $\Sigma$ — presupposed by A3 and by the memo's
target; now `eq:JSig`. (iii) **The estimator.** `def:lfstep` defines the $\varphi$-step; nothing defined
the $\theta$-step. Now `def:crossfit` (folds, the fixed anchor $\theta_\circ$, (P8)'s reading) and
`def:onestep` ($\hat\theta^{(0)}$, $\hat J$, $\hat\theta$, $\hat\Sigma$, $\hat V$).

**One architectural decision, and it is licensed rather than convenient.** The $\varphi$-step is run at a
**fixed, pre-data anchor $\theta_\circ$**, not at a preliminary $\hat\theta$. `lem:shiftinv` + `cor:opsol`
make the population solution set $\mathcal V_{CI}$ at every $\theta$, so under A1b(iii) the step targets
$\vdagger$ at $\theta_\circ$; `rem:R1`(iv) is used and not extended, including its warning that
$a$, $\mu$, $\mathsf R_\ast$, $\hat\delta_n$ are **$\theta$-specific**, so `prp:phirate`'s hypotheses are
read *at $\theta_\circ$*. **This removes the circularity outright** and it is why A5(v) is consumed
nowhere in Part I: there is no plug-in Landweber pass.

### D-0000000000000.2 The proof, by step

**`lem:momzero`** (3 steps) — $E\psi_\star=0$ from A1 twice (once for $E[\Delta Z\Delta U]=0$, once for
$E[\widetilde W|\Delta U,\Delta Z]=0$); $E\|\psi_\star\|^2<\infty$ from A2′(iii) + `cor:elldiff` + A1b(iv);
$\partial_\theta E[\psi]=-J$ by dominated convergence with envelope $\|\ell_\star\|_\infty\|\Delta Z\|$.

**`lem:prelimtheta`** (5 steps) — exact algebra; the score of (B) is $O_P(n^{-1/2})$; the *undebiased*
pairing $\langle\nu/\pi,h_k\rangle$ is $O_P(\delta_n)$ by a conditional $L^1$ bound and (P8). Result:
$\|\hat\theta^{(0)}-\theta_\dagger\|=O_P(\delta_n)=o_P(n^{-1/4})$. Step 4′ records that
$\|\nu/\pi\|_{L^2(\pi)}<\infty$ needs **no appeal to A2** — it is a moment statement.

**`lem:biasexp`** (5 steps) — **the heart, and it takes no Taylor expansion in the nuisances.** Three exact
identities: the fundamental theorem of calculus in the shift (`eq:shiftFTC`), the bi-affineness of $\psi$
in $(L,\varrho)$, and `lem:nusigma`(iii). Output: the conditional bias is the balancing pairing
$-\langle\nu_{g_k}/\pi,h_k\rangle$ **plus exactly three remainders** — $\Psi^{(1)}_k$ the square in $h$,
$\Psi^{(2)}_k$ the $\varrho\times\varphi$ cross term, $\Psi^{(3)}_k$ the $\varrho\times L$ cross term,
zero under N1′ — with four bounds. **This is L-6 used as an identity and L-7 instantiated at the estimated
nuisances, both as the memo specifies.**

**`lem:epterm`** (6 steps) — $\|\hat\psi^{(-k)}-\psi_\star\|_{L^2(P)}=o_P(1)$ in four pieces, then one
conditional Chebyshev + (P8). **The Donsker route is not used and the statement says which concession is
and is not made:** `lem:unifop` concedes a uniform LLN with a rate at scale $\hat\delta_n\gg n^{-1/2}$ and
that is charged in the $\varphi$-step; the $\theta$-step concedes nothing at scale $n^{-1/2}$.

**`lem:sandwich`** (10 steps) — $\hat J\to_pJ$ and $\hat\Sigma\to_p\Sigma$. The device that lets
$\hat\theta^{(0)}$ be replaced by $\theta_\dagger$ *before* conditioning is that $\hat\ell$ is Lipschitz in
$u$, which is (R-a).

**`thm:rootn`** (Steps 0–6) — Step 1 is an **exact** identity, `eq:rootnid`:
$\hat\theta-\theta_\dagger=\hat J^{-1}[\bar\psi_n(\theta_\dagger)-\Psi^\theta_n]$ on
$\{\hat J\text{ nonsingular}\}$. Step 2 is the only place a **rate** for $\hat\theta^{(0)}$ is used, and the
threshold is exactly $o_P(n^{-1/4})$. Step 3 splits $\bar\psi_n(\theta_\dagger)$ three ways
(`eq:threeway`). Step 4 kills the bias term by term. Step 5 is L-8 + Lindeberg–Lévy. Step 6 assembles.
**The order of `lem:sandwich`(i) before and (ii) after the limit is stated, and it is not interchangeable.**

**`cor:ratefloor`** — the same identity, orders collected:
$\|\hat\theta-\theta_\dagger\|=O_P(n^{-1/2}+\delta_n\epsilon_n+\delta_n^2+r_n\delta_n+r_n\epsilon^L_n)$;
under (R-e.2) the $\delta_n\epsilon_n$ term becomes $O_P(n^{-1/2}\delta_n)+O_P(L_x^{-s})$ **and no rate for
$\hat\ell$ enters at all** — which is what §19.1's sieve decision buys and was not stated before.

**`prp:medianpart`** — one influence function shared by all $\mathsf P$ partitions; order statistics are
$1$-Lipschitz. $\mathsf P$ fixed is used **twice**, and Step 3 says where and that neither use survives
$\mathsf P\to\infty$.

### D-0000000000000.3 The $\ln n$ resolution, and the frontier arithmetic

**Resolution taken: A5(ii) is restated so that $\delta_n:=(\hat\delta_n\ln n)^{2\mu/(2\mu+1)}$ — the object
`prp:phirate` delivers.** The alternative (leave A5(ii) log-free and let `thm:rootn`'s rate conditions carry
the logarithm) is **rejected**, for two reasons and the second is decisive.

1. It would put the logarithm in five places instead of one.
2. **The block was already inconsistent with itself, not merely with `prp:phirate`.** (P-f),
   `rem:h6bandwidth`(0) and `prp:stopfeas`(iv) *all* read the log-inflated $\delta_n$ —
   `rem:h6bandwidth`(0) prints $\delta_n^2=\hat\delta_n^{2\kappa}(\ln n)^{2\kappa}$ — while A5(ii) read
   the log-free one. **Route (A) reconciles them; route (B) would have preserved the contradiction.**

**Consequence for the frontier arithmetic, term by term. It is not uniform, and this is the answer the
dispatch asked for.** Write $\hat\delta_n=n^{-\alpha}$, $\kappa=2\mu/(2\mu+1)$.

| Product `thm:rootn` needs | Effect of the $\ln n$ | Why |
|---|---|---|
| $\delta_n^2=o(n^{-1/2})$ | **free** — `eq:frontier` UNCHANGED | `eq:frontier` is *strict*: at $\kappa\alpha=\frac14+\varepsilon$, $\delta_n^2=n^{-1/2-2\varepsilon}(\ln n)^{2\kappa}$. This is `prp:stopfeas`(iv) |
| $r_n\delta_n=o(n^{-1/2})$ | **free, and IMPLIED by `eq:frontier`** | $\kappa\alpha>\frac14$, $\kappa<1$ $\Rightarrow$ $\alpha>1/(4\kappa)$ $\Rightarrow$ $\alpha(1+\kappa)-\frac12>\frac{1-\kappa}{4\kappa}=\frac1{8\mu}>0$ **(corrected in dispatch 11 — a round-10 draft wrote $\frac1{4\mu}$)**. **No separate condition is imposed** |
| $\delta_n\epsilon_n=o(n^{-1/2})$ | **NOT free — the one place it bites** | A5(iv) is now a demand on $\epsilon_n$ stronger by $(\ln n)^{\kappa}$. Nothing in the block pays for it; it is L-13's business and it is charged, not absorbed |
| $r_n\epsilon^L_n=o(n^{-1/2})$ | unaffected; zero under N1′ | (R-c) |

**What does not move:** `eq:muhalf`'s $\mu>\frac56$ **strictly** — `rem:h6bandwidth`(2) computed it at the
log-inflated $\delta_n$ and derived the strictness from precisely the failure of logarithms to cancel in
(P-f), so it is unchanged; `eq:frontier`; `eq:lxwindow`. **A5(v) becomes weaker.**

**One arithmetical finding worth its own line, because it is a *gain*.** The margin
$\alpha(1+\kappa)-\frac12>\frac1{8\mu}$ means **`eq:frontier` does double duty**: it delivers both
$\delta_n^2=o(n^{-1/2})$ and $r_n\delta_n=o(n^{-1/2})$. The memo's T2′ row lists $r_n\delta_n$ as an
independent term; it is not independent, and the margin shrinks as $\mu$ grows ($\frac3{20}$ at
$\mu=\frac56$, $\frac1{16}$ at $\mu=2$), which is the opposite of the direction one would guess.
**Spec-worthy; named in §D-0000000000000.7.**

> **CORRECTION, dispatch 11.** This block read $\frac1{4\mu}$, $\frac3{10}$ and $\frac18$ through
> dispatch 10. The correct constant is $\frac{1-\kappa}{4\kappa}=\frac1{8\mu}$, since
> $1-\kappa=(2\mu+1)^{-1}$ and $4\kappa=8\mu/(2\mu+1)$; both illustrative numbers were wrong by the same
> factor of two. **The finding itself is unchanged and is not withdrawn:** the implication is valid, the
> margin is *exact* at the frontier boundary $\alpha=1/(4\kappa)$ — so $\frac1{8\mu}$ is the infimum of
> $\alpha(1+\kappa)-\frac12$ over the frontier and cannot be improved from `eq:frontier` alone — and the
> direction in $\mu$ survives, $\frac1{8\mu}$ being decreasing. `rem:rootnlog`(3)(b) now **displays** the
> identity as `eq:rndeltamargin` so a reader can check it at sight, which is the structural lesson: the
> arithmetic *was* the content of the clause and it was carried in prose.

**And the `rem:phirscope`(2) warning is now discharged rather than carried.** The logarithm does not
vanish anywhere between `prp:phirate` and A5(ii): it is *in the symbol*, and `rem:rootnlog` is the record.

> **CORRECTION, dispatch 11 — this claim was FALSE WHEN WRITTEN, and it was false because the sweep the
> amendment required was not run.** `rem:phirscope`(2) still read *"A5(ii) writes the latter"* — the <!-- RETIRED-MENTION: this quotes the withdrawn claim in order to record its repair; it is narration, not an assertion. -->
> log-free form — so `results.tex` and `assumptions.tex` disagreed about a **maintained clause**.
> `rem:phirscope`(2) is now rewritten and the claim above is true. **Three further sites swept:**
> `prp:stopfeas`(iv)'s opening display, which inflated $\delta_n$ a *second* time; and two comment blocks
> at `assumptions.tex` (the SG-20 warning and the A7-amendment cost note). **Two sites deliberately left
> alone** — `results.tex` `rem:rootnlog`(1) and `assumptions.tex` A5(ii)'s own comment — because both are
> *past-tense narration* of what the clause used to say, which is exactly the record the amendment should
> keep. A blocking row now exists in `scripts/render-sync/check_rendering_sync.py` CHECK 6, written on
> present-tense attribution only for that reason.
>
> **And the ground for route (A) is stronger than this section claimed.** `prp:stopfeas`(iv) was not merely
> reading the log-inflated $\delta_n$ while A5(ii) read the log-free one; it was **inconsistent with
> itself** — opening display log-free, (P-f) paragraph six lines later log-inflated. So route (B) would not
> have preserved a consistent block: it would have preserved a clause that contradicted itself inside one
> proposition. Recorded at `rem:rootnlog`(1).

### D-0000000000000.4 What `eq:prelimrate` did and did not discharge — m-23, answered

**It did not, and the reason is that it is about a different object.** m-23 said: "`thm:rootn`'s one-step
needs a *rate* for the preliminary and L-14 gives consistency only."

- `eq:prelimrate` is $\varsigma_0>\frac{\kappa\alpha}{4(2\kappa-1)}$, a condition on the exponent of
  $\hat\varepsilon_0$ — the $L^2(\pi)$ rate of the **preliminary structural estimator $\hat\varphi^{(0)}$**
  inside `def:lfstep`, i.e. hypothesis (P-a.2) of the $\varphi$-step. **It says nothing about $\theta$.**
- The one-step's preliminary is $\hat\theta^{(0)}\in\IR^p$. Nothing in `eq:prelimrate` bears on it.

**What closes the gap is `lem:prelimtheta`, and closing it required specifying the preliminary — which no
file did.** The plug-in `eq:prelimtheta` inherits $\delta_n$, and A5(ii)'s
$\delta_n=o_P(n^{-1/4})$ is exactly the threshold Step 2 needs. **So: the gap m-23 named is real; the
registered instrument is the wrong one; and the discharge is a new lemma.** Recorded at
`rem:rootnhyp`(4), where a reader meets the question.

**Not a blocker.** It would have been one had the plug-in's bias not been $O_P(\delta_n)$ — and it is,
because `lem:nusigma`(iii) identifies that bias as $\langle\nu/\pi,h_k\rangle$ with
$\|\nu/\pi\|<\infty$ by a moment argument alone.

### D-0000000000000.5 Hypotheses used, by clause — and two that are listed nowhere because they are not used

Full table at `rem:rootnhyp`. The two entries that matter for the auditor:

- **A2′(ii) is consumed by no part of Part I, and it is *implied* by A2′(i) in full together with
  B1(i), (ii), (iv.a).** The variance object is
  $E[\widetilde W^2\|L_\star\|^2]$ (the **level**), bounded by A2′(iii) + $\|\ell_\star\|_\infty$;
  A2′(ii) bounds $E[\widetilde W^2\|\ell_\star\|^2]$ (the **derivative**), which is free from
  `cor:elldiff` + (P1). **This is A4's comment (d) seen from the other side — a genuine redundancy in the
  maintained block.** *Recorded, not acted on:* deleting a maintained clause is a change the
  assumption-auditor tracks and the finding belongs to it.

  > **CORRECTION, dispatch 11 — the redundancy is real but was MIS-ATTRIBUTED.** Through dispatch 10 this
  > line and `lem:momzero`'s closing paragraph said A2′(ii) is implied by **A2′(i.a)**. That is not a
  > statement this file can make: the only route to $\|\ell_\star\|_\infty<\infty$ available here is
  > `cor:elldiff`, which is stated at an admissible representer **in the sense of A2b** — and A2b requires
  > $\Lambda^{(0)},\Lambda^{(1)}<\infty$ *and* continuous $u$-differentiability, i.e. (i.a) **and** (i.b).
  > Worse, A2′(i)'s closing clause fixes $\ell_\star$ *pointwise* "from that version", the one satisfying
  > both, **so $\ell_\star$ is not pointwise well defined from (i.a) alone** and a sup-norm claim about it
  > is not well posed. `lem:momzero`'s hypothesis list therefore now carries A2′(i) in full; `thm:rootn`'s
  > (T-2) already listed both clauses, so nothing downstream moves. Fixed at `results.tex` `lem:momzero`,
  > `rem:rootnhyp`(1) and (2), and at `proofs.tex` `lem:momzero` Steps 1 and 3.
- **A5(v) is consumed nowhere**, because the $\varphi$-step runs at $\theta_\circ$. **A1b(ii) is not used**
  either: only `lem:nusigma`(i), (iii), (iv), (v) are consumed and none of those needs it.

**Four hypotheses are new and are stated on the theorem, not promoted to A5.** (R-a) the construction
envelope for $\hat L$ — which **carries obligation (O3)** of `rem:obligations` as an explicit hypothesis and
supplies what the quadratic remainder needs at the *estimated* $\hat\ell$; (R-b) fourth moments; (R-c)
N1′-or-a-rate, which **carries (O2)**; (R-e) the rate route or the balancing route.

> **CORRECTION, dispatch 11, on two counts.**
>
> **(a) The stated ground for not promoting was FALSE, and the decision stands anyway.** This section said
> "every A5 clause prices a *rate in $n$*, and (R-a), (R-b) are qualitative". **A5(vi) is
> $\|h\|_{H^s}=O_P(1)$** — a qualitative stochastic-boundedness clause with no rate in $n$, of exactly
> (R-a)'s type — and **A5(vi′) is a w.p.$\to$1 envelope at a fixed radius**. So the universal is refuted by
> the block itself, and it had propagated to three sites (`rem:dirmember`(a), `rem:obligations`, and the
> A5(iv) comment block in `assumptions.tex`). **The reason is replaced, not the decision.** The
> discriminant, now at `rem:rootnhyp`(5): *(i) object existence* — every A5 clause constrains an object the
> maintained block introduces, at a single estimator, whereas (R-a)–(R-e) constrain the fold-specific
> $\hat\varphi^{(-k)},\hat L^{(-k)},\hat\ell^{(-k)},\hat b^{(-k)},D_k$, which exist only after
> `def:crossfit`; *(ii) (R-a) is a construction claim*, and by `rem:obligations`'s own test promoting it
> converts (O3) from a verification owed by the construction into a maintained assumption — the trade that
> remark forbids; *(iii) (R-b) is misfiled in A5* whatever its status, being a moment condition on
> primitives; *(iv) precedent* — `prp:phirate`'s (P-a)–(P-g) sit on the proposition for the same reasons,
> and (R-c)/(R-e) are in addition **disjunctions**.
>
> **(b) "Discharges (O3)" was too strong and is corrected to "carries".** Assuming a construction is not
> performing it. (O2) and (O3) both **remain open**; what Step 7 changed is that each now has a *named
> consumer that carries it explicitly*, which is what `rem:obligations`'s test asks of an open obligation —
> and (R-c.2) in addition **prices** (O2)'s failure at $r_n\epsilon^L_n$ rather than assuming it away.
> `rem:obligations` is the single inventory and its status lines now say this; **"two remain open" is
> retained, because it is true.**

> **AND (R-b)'s third clause is DELETED.** $E\|b_\star\|^4<\infty$ was never used: $b_\star$ appears at two
> lines of Part I (`proofs.tex` `lem:momzero` Step 1), both at **second** moment via A2′(iii), and nothing
> in Part I needs a fourth moment of $\psi_\star$ — `lem:sandwich` Step 8 applies conditional Markov to
> squares, Step 10's Cauchy–Schwarz needs only $\mathbb E_n\|\psi_\star\|^2=O_P(1)$, and the CLT is
> Lindeberg–Lévy. The fourth-moment need is on $\hat b^{(-k)}$ and (R-a) supplies it. **This one is worth
> naming as a process failure**: dispatch 10 claimed a clause-level audit of the maintained block, found
> three non-uses there, and shipped an unused clause in its *own* new hypothesis. The audit was applied
> outward and not inward.

**(R-a) is the one that carries real content and it should not be read as bookkeeping.** The square
$\Psi^{(1)}_k$ is governed by $\partial_u\hat\ell$, not by $\partial_u\ell_\star$, and the block prices
nothing about $\partial_u\hat\ell$. Two routes were available: (α) assume
$\|\partial_u\hat\ell\|_\infty=O_P(1)$, or (β) price the *shift-uniform* seminorm
$\|\hat\ell-\ell_\star\|_{0,h}$ of `def:dirclass`. **(α) is taken**, because (β) requires a norm A5(iv)
explicitly does not price and `rem:supinside` explains why the unshifted norm does not imply it. (β) is
recorded as the alternative.

### D-0000000000000.6 What could not be closed

1. **(P-a.3) is still assumed** and $\mu$ is still primitive (Q-4). Part I inherits it through (T-5) and
   adds nothing.
2. **$\hat\varepsilon_0$ has no supplier** (Q-1). Unchanged.
3. **$\hat\ell$ is constructed nowhere.** A5(iv) prices it; L-13 owes it. Part I adds (R-a)'s envelope,
   which is a constraint on the construction and not a construction.

   **3′ (added in dispatch 11). $\epsilon^L_n$ is priced by nothing — the THIRD unsupplied rate symbol, and
   this list omitted it through dispatch 10.** It is live inside (R-c.2), it enters `eq:ratefloor` at
   $r_n\epsilon^L_n$, and **no clause of the maintained block bears on it**: glossary C79 says so, and
   `thm:rootn` states it as a hypothesis. So the corpus recorded it in two places and the memo's own
   inventory did not — which is why `cor:ratefloor`'s "the rate is in primitives" survived a round. The
   corollary is now scoped by branch and $\epsilon^L_n$ is named as one of exactly two exponents in
   `eq:ratefloor` without a primitive supplier, the other being $\epsilon_n$. **Both disappear only on the
   (R-e.2) + (R-c.1) branch**, which is the honest form of what §19.1's sieve decision buys.
4. **N1′ at the estimated direction — (O2) — is still open.** (R-c) prices its failure rather than
   assuming it away, which is the honest form, but the *cheap* discharge (re-anchor $\hat L$ at the N1
   anchor of `rem:anchor`) needs an estimate of $E[\int_0^{\Delta U}\hat\ell\mid\Delta Z]$ and is
   therefore a further nuisance. **Recorded, not solved.**

   **4′ (added in dispatch 11). (O3) is still open too, and dispatch 10's §.5 called it discharged.**
   (R-a) *asserts* the construction; asserting is not performing. `rem:obligations` now records both as open,
   each with a named consumer, and retains "two remain open" because that is the true count.
5. **A2′(ii)'s redundancy** — see §D-0000000000000.5, **with the attribution corrected there**: the ground is
   A2′(i) in full plus B1(i), (ii), (iv.a), not A2′(i.a).
6. **The LR-correction contradiction is a flag, and I do not pick a side beyond stating what the proof
   shows.** `lem:sandwich`'s closing paragraph: the influence function is $J^{-1}\psi_\star$ and carries no
   correction for $\varrho$, because `prp:orthog`(iii) makes the $\varrho$-derivative vanish **exactly**
   under N1. **The positioning section says the sandwich carries an additional correction for $\varrho$.**
   Both cannot be right. **This is memo §9 item 10 and it is for the writer.**
7. **The calligraphic alphabet is exhausted** — $\mathcal O,\mathcal Y,\mathcal Z$ are the only free
   letters. Recorded in the glossary §1.5h as a limit on the file's own machinery.

### D-0000000000000.7 Claims that warrant a symbolic spec — **named, not written**

**Revised in dispatch 11: five, in descending order of value; one demotion and two additions.** **I did not
write them: `scripts/symbolic/specs/` is owned by another agent.**

| Proposed spec | Claim to mechanise | Why it is worth a spec |
|---|---|---|
| `rootn-frontier-implies-rndelta.yaml` | $\kappa\alpha>\frac14$, $0<\kappa<1$ $\Rightarrow$ $\alpha(1+\kappa)>\frac12$, with margin $\frac{1-\kappa}{4\kappa}=\frac1{8\mu}$ **(the constant, at the corrected value, is the point)** | **The highest-value one, and dispatch 11 proved why:** the round-10 text carried $\frac1{4\mu}$ and two illustrative numbers wrong by the same factor. Add a **falsification arm** at $\kappa=\frac{2\mu}{2\mu+1}$ substituted symbolically, so the spec fails if the constant is written $\frac1{4\mu}$ |
| `rootn-rate-products.yaml` | **NEW.** The five-term order list of `eq:ratefloor`: at $\hat\delta_n=r_n=n^{-\alpha}$, $\delta_n=(\hat\delta_n\ln n)^\kappa$, verify which of $\delta_n\epsilon_n,\delta_n^2,r_n\delta_n,r_n\epsilon^L_n$ are $o(n^{-1/2})$ — with a **falsification arm at $\kappa\alpha=\frac14$, where three of the four must FAIL** | *"This is where an arithmetic error moves a conclusion, and it is exactly the bookkeeping that went wrong above."* The four-product table of §D-…3 is prose arithmetic over five symbols; it is the single most error-prone object in Part I |
| `rootn-log-absorption.yaml` | At $\kappa\alpha=\frac14+\varepsilon$: $(\hat\delta_n\ln n)^{\kappa}=o(n^{-1/4})$ and $(\hat\delta_n\ln n)^{2\kappa}=o(n^{-1/2})$; **and both FAIL at $\varepsilon=0$** | The boundary half is what makes A5(iii)'s "if and only if" correct, and it is the exact place two earlier rounds were reversed |
| `rootn-prelim-threshold.yaml` | **NEW.** $\sqrt n\,(n^{-1/2}+\delta_n)^2=o(1)\iff\delta_n=o(n^{-1/4})$ — Step 2's exact threshold, at the **uncollapsed** preliminary rate | Step 2 is the only place a rate for $\hat\theta^{(0)}$ is used, and dispatch 11 restated it at the uncollapsed rate precisely so that this equivalence is what the step rests on. Two lines, and it pins the $n^{-1/4}$ |
| `rootn-jacobian-sign.yaml` | $\partial_\theta E[\psi(\theta,\zeta_\star)]\vert_{\theta_\dagger}=-J$, hence the $+\hat J^{-1}$ in `eq:onestep` and the $J^{-1}$ (not $-J^{-1}$) in `eq:rootn` | A sign error here is invisible in the limit law and fatal in a simulation. Cheap to mechanise |

**DEMOTED, and the reason is that a reviewer verified it faster by hand than a spec would.**
`rootn-biasexp-identity.yaml` — the four-term decomposition `eq:biasdecomp` on a bi-affine surrogate for
$\psi$. The Part-I review reassembled the whole decomposition from `eq:shiftFTC` in five lines and confirmed
every term, sign and constant including the $\frac12\to2\bar c_\pi$ chain. **A bi-affine surrogate will
confirm it trivially**, because bi-affineness is exactly the hypothesis that makes the three vanishings
automatic — so the spec would test the surrogate, not the claim. Keep it on the list only if a later dispatch
changes $\psi$.

### D-0000000000000.8 The two secondary items, both done

**1. Glossary C2 is corrected.** The row claimed $\mathcal D$ "appears only in the levels-vs-derivative
remark and in `rem:draftrec`, so it is nearly dormant". **False:** 45 occurrences across the five live
theory files, and — decisively — **H1 reads "the Sobolev scale $H^s$ of order $s$ generated by
$\mathcal D$"**, repeated at `def:srcball`. So $\mathcal D$ generates the scale in which A5(vi), A5(vi′),
(P-a.1), (P-c), (P-g), `eq:entropy` and `lem:unifop` Step 4 are written. **The row is corrected, not
deleted**, and the diagnosis is C71's: a usage claim asserted in a binding file without a sweep.
Under §1.5g finding (i) the pattern swept is now named.

**2. `prp:tccfails` gains scope, on the parameterisation.** Two additions.
- **`rem:tccwhy`(4)**, new: the proposition is about $\hat T$ **on $\mathcal V$, in the levels
  parameterisation, off the sieve**, and all three qualifiers are load-bearing. CFF may assume Fréchet
  differentiability of its sample operator because its space is in **derivatives**, where point evaluation
  is bounded via $|\varphi(x)|\le|\mathcal X|^{1/2}\|\varphi'\|$ — so `prp:hatAprop`(v)'s mechanism, and
  with it `prp:tccfails`, **dissolves** under that parameterisation. **And it cannot be adopted:** by
  `lem:levels`(iii) A2 is parameterisation-invariant but the *index* is not, $\mu$ falling from $s/(2a)$ to
  $(s-1)/(2(a+1))$ — $0.571$ at $(s,a)=(3,\frac34)$, **failing `eq:muhalf`**. *The parameterisation that
  dissolves `prp:tccfails` is exactly the one that cannot feed `thm:rootn`.*
- **`rem:tccwhy`(5)**, new, one sentence as asked: **range invariance implies CFF's Assumption (18) and
  the implication does not reverse**, so `prp:norangeinv` spends the range-invariance route and leaves (18)
  open. A (18)-based, cone-free treatment is *not* closed by anything in this file — it still needs
  $\lambda_{\min}(\mathbf G_n)$ (Q-3).
- **Fold-in, free:** `lem:levels`'s headline is scoped to A2, closing the dispatch-8 note that "the source
  condition is the same in the two parameterisations" is true for A2 and **false at index $\mu$**;
  `rem:tccwhy`(4) is now that lemma's principal consumer.

**Two citation fixes applied, both in files I own.** (a) `rem:lfnonlinear`(c): the IRGN / above-$\frac12$
claim is retagged from `dunker2014` to **`dunker2021`**, and the paragraph that *stated* the split is
rewritten to say the fix is applied. (b) **CFF is now cited twice**, under `centorrinofeveflorens2019` as
instructed: at `rem:lfnonlinear`(3), where its cap $\beta\le1-\epsilon$ is $\mu<\frac12$ under
$\beta=2\mu$ — the same number as the Heinz barrier, reached from the applied side, which is the strongest
available evidence that $\frac12$ is a property of the problem; and inside `prp:hatAprop`(iv), where
`eq:hatTxrem` **exhibits** the constant CFF's Prop. 4.2(a) writes as "$\hat M<\infty$", and its $h_u^{-2}$
is what generates (P-f) and hence `eq:muhalf`.

### D-0000000000000.9 What this dispatch does NOT do

- **No Step 8.** `prp:effbound`, `prp:plugin`, `cor:trend` are untouched; `rem:rootnscope`(4) says so.
- **No new maintained assumption.** (R-a)–(R-e) sit on the theorem. **One maintained clause is amended**,
  A5(ii), and the amendment is a correction with the inconsistency it repairs named.
- **No symbolic spec written** — four are named in §D-0000000000000.7 and owed.
- **No edit to `scripts/symbolic/specs/` or to `references.bib`.**
- **No re-litigation** of the machinery, of (P-b), of the perturbation-of-$\mathcal A$ route, or of A6's
  retirement. The Donsker route stays rejected and `lem:epterm` states the concession precisely.

---

## D-000000000000. Round-12 **consolidated fix round** on Part H — the gating findings only

**Scope, and what is deliberately out of it.** Exactly the **gating** findings of three narrow sweeps, in
the order the regularity-checker's sequencing note mandates: `regularity-audit_partH.md` (0/100 — 1
CRITICAL, 11 MAJOR), the assumption-auditor's U-1, and the notation-warden's V-1, V-2, V-3, V-7 and
register finding. **Non-gating findings — A7, A11, m1–m6 except where they sit inside text this round
rewrote — are OUT of scope and are carried.** Files edited: `results.tex`, `proofs.tex`,
`assumptions.tex`, `notation_glossary.md`, `paper/sections/theorems/lem-bierens.tex`, this memo.
`results_partH.tex` and `proofs_partH.tex` remain stale merge records and are not edited.

### D-000000000000.0 Pre-Theory Report — what was read, and two declared gaps

| Input | Read | Status |
|---|---|---|
| `quality_reports/regularity/regularity-audit_partH.md` | in full | 1 CRITICAL + 11 MAJOR + 6 MINOR + the sequencing note |
| `quality_reports/assumptions/usage-matrix_partH.md` | **ABSENT FROM DISK** | declared gap — see below |
| `quality_reports/notation/notation-table_partH.md` | **ABSENT FROM DISK** | declared gap — see below |
| `quality_reports/theory/panel-npiv-discrete/derivative_route_assessment.md` | in full (own work, dispatch 8) | Option B accepted by the user; §8.3's BOTH-radii answer is this round's Step 2 |
| `results.tex` | `def:spaces`, `cor:opsol` note, `lem:intker`, `def:hatTexp`, `def:hatAcon`, `prp:hatAprop`, `prp:tccfails`, `rem:tccwhy`, `def:a6b`, `prp:tccrepair`, `prp:norangeinv`, `lem:opnoise`, `lem:aerr`, `prp:stopfeas`, `def:srcball`, `lem:unifop`, `rem:l19cost`, `lem:pathcont`, `lem:srctransfer`, `lem:scaleinv`, `def:lfstep`, `prp:phirate`, `rem:lfnonlinear`, `rem:phirscope` | |
| `proofs.tex` | (P1)–(P7) header; `lem:bierenscore` Steps 2–4; `lem:intker`; `prp:hatAprop`; `prp:tccfails`; `lem:opnoise`; `lem:aerr`; `prp:stopfeas`; `lem:bdiff`; `lem:unifop`; `lem:pathcont`; `rem:ff`; `lem:srctransfer`; `lem:scaleinv`; `prp:phirate` Steps 0–6; `rem:h6bandwidth` | |
| `assumptions.tex` | A0, A1, A1b, H1 + comment, A3, A4 + comment, A5 + comments, A8 + comment, `def:intker`, `def:hatT`, `def:hatA`, A6 (retired), A7 + comments, C1, C2′, C3 + comment, C4′, C5′ + comments, Discussion, budget table + all four reading paragraphs | |
| `notation_glossary.md` | header + inventory, §1.5–§1.5f, §1.6, §1.7, §5 | |
| `paper/sections/theorems/lem-bierens.tex`, `lem-adjoint.tex` | the $\Omega$ and $\omega$ sites | V-2, V-3 |
| `Bibliography_base.bib` | grepped for `centorrino`, `feve`, `florens`, `dunker` | **zero matches** — so **nothing in this round cites CFF or Dunker**, and the two facts relayed from the parallel dispatch that would need a citation are carried to the librarian rather than written into the `.tex` |
| `.claude/references/domain-profile.md` | **NOT PRESENT** | declared gap, as in dispatch 8 |

**Two declared gaps, and they are not assumptions.** (a) `usage-matrix_partH.md` and
`notation-table_partH.md` **do not exist on disk** — `Glob` over `quality_reports/assumptions/` and
`quality_reports/notation/` returns neither, and no `*partH*` file exists outside
`quality_reports/regularity/`. This round therefore works from **the dispatch's own relayed content** for
U-1 and V-1/V-2/V-3/V-7 and the register finding, **and independently verifies each against the live
files before acting**. Every one of the six verified: $\mathcal L$ at three referents with no glossary row
(`proofs.tex` 2950–3011 vs 3695–4068 vs `results.tex` 2372–2382); $\Omega$ live at
`lem-bierens.tex:101–103`; lowercase `\omega` at 55 sites project-wide, including
`lem-adjoint.tex:166,179` and a fourth referent at `assumptions.tex` C2′(i); $\alpha$ at three referents
with the binding one at ~40 sites; the register self-contradiction at glossary lines 14 vs 212 and
C1–C67 vs C66–C68; and (H1c)/(H2c) at eleven live sites declared only in a `DO NOT COMPILE` header.
**No finding was actioned on the dispatch's word alone.** (b) No domain profile; foundational-reference
conventions taken from the block's own citation note.

### D-000000000000.1 Step 1 — C1 and A3, repaired together, by the spectral restatement (Option B)

**C1 accepted in full, and the repair is the one the user approved.** (P-a) is restated as three clauses.
(P-a.3) now reads: *w.p.$\to1$ and at every stage,
$\bar v^{(k)}_\dagger=(\hat{\mathcal P}^{\,\mathcal S}_{\hat\varphi^{(k-1)}})^{\mu}\varsigma^{(k)}$ with
$\|\varsigma^{(k)}\|\le\mathsf R_\ast$*, where `eq:compress` **names the operator as the compression**
$P_{\mathcal S_n}\hat{\mathcal A}^\ast\hat{\mathcal A}\vert_{\mathcal S_n}$. **A3 closes as a by-product,
exactly as the checker predicted**: `eq:LstarL` in (L2) now exhibits
$\mathcal L^\ast\mathcal L=\omega_n^{-2}\hat{\mathcal P}^{\,\mathcal S}_{\varphi_\circ}$, so the operator
(L2) establishes and the operator (L5) names are the same object; (L2) was already the witness, and the
naming defect is gone rather than argued away.

| Site | Change |
|---|---|
| `prp:phirate` hypothesis line | ``with $\mu=s/(2a)$'' **STRUCK**; H1 cited for the scale and A2's Picard form only; $p_K\ge s-\tfrac12$ **added** |
| (P-a) | three clauses (P-a.1)–(P-a.3), all w.p.$\to1$ envelopes; `eq:compress` introduced |
| (L5) | **two lines**: (P-a.3) $\to$ `eq:LstarL` $\to$ spectral-mapping $\to$ (F-f)'s hypothesis. No interpolation, no Heinz range, no Löwner |
| (L2) | gains `eq:LstarL` and the compression-versus-restriction paragraph |
| `lem:srctransfer`(iii) | split into (iii.a) *the link condition must go on the sieve* and (iii.b) *and the interpolation step is unavailable there anyway*; the false claim ``A8's window is what makes the Hilbert-scale route available at $\mu>\tfrac12$'' is **struck** |
| `rem:pasrc` | **NEW.** Four clauses: the defect; the repair; **why the repair is a WEAKENING**; and the commutativity proviso priced |
| H1 + its comment block | scope narrowed in the statement; the comment rewritten in full, including the withdrawal of ``escalation item 15 closes favourably'' on the rate route |
| budget table | frontier row loses ``$\mu=s/(2a)$''; two rows added; a fourth reading paragraph added |

**The argument that carries the choice, stated where a reader meets it (`rem:pasrc`(3)) and not only in
the assessment.** **Option A = Option B + a proviso**, so Option B's hypothesis is *strictly weaker* and
needs *strictly less* proved. **And B's cost is narrower than ``H1 collapses'':** H1's matching concerns
$\mathcal A_{\rm cond}$ on $\mathcal V$, while (P-a) concerns a finite-rank realised operator on
$\mathcal S_n$ at a random base point — and `lem:srctransfer`(iii.a) records that a link condition
*cannot* hold on $\mathcal V$ at all. **So (P-a) was already assuming its own matching, and this round
makes an existing assumption visible rather than adding one.** That sentence is now printed at
`rem:pasrc`(3), at the H1 comment block, at the budget table's new paragraph and at `rem:phirscope`(6) —
four places, because it is the round's headline and a reader should not have to reconstruct it.

**And the honest cost is printed, not buried** (`rem:phirscope`(6)): $\mu$ is primitive; a referee may ask
what pins it; the answer is H1 **plus** a matching proviso, stated and not proved.

### D-000000000000.2 Step 2 — the radii split, in the same pass

**$\mathsf R$ and $\mathsf R_\ast$ are now two symbols.** $\mathsf R$ is an **$H^s$ ball radius** —
`def:srcball`, A5(vi′), (P-a.1), (P-c), (P-g), `eq:entropy`, `lem:unifop` Step 4: **seven** places, so the
hypothesis is an existential over one radius meeting seven demands, and that is stated at `def:srcball`
and `lem:pathcont`. $\mathsf R_\ast$ is a **spectral pre-image norm** — (P-a.3), (F-f),
`lem:srctransfer`(i)/(ii.b), `lem:scaleinv`(iii)–(v), `eq:linlf`,
$\mathsf c_{17}=2c_\mu\mathsf R_\ast^{1/(2\mu+1)}$, hence $\mathsf c_{15}$, which `def:lfstep` prints
before the data are seen. **Same species as dispatch-8 MAJOR 2.1, on the same inequality**, and the
diagnosis is now printed at `def:lfstep`, `def:srcball`, `rem:ff` and `eq:linlf`. Glossary C69.
**They are not comparable in either direction**, because the only device that would relate them is the
interpolation C1 refutes — which is why the collision was not benign: it hid a missing implication.

### D-000000000000.3 Step 3 — A1 and A2, after the split

**A1 accepted, and the repair is the one the checker settled on — carrying $C_0$ is NOT available.**
(P-a.1)–(P-a.3) are **w.p.$\to1$ envelopes**, not $O_P$ statements. `rem:paenvelope` is **new** and carries
the argument: $\mathsf c_{14},\mathsf c_{15}$ are part of the estimator, printed in advance, so an
$\epsilon$-indexed constant makes `eq:phirate` itself $\epsilon$-indexed; the block owns the conversion at
`prp:stopfeas`(iii); the $\ln n$ is absorbed by `eq:prelimrate`'s **strictness**, which compares
polynomial exponents. **The same repair closes the second site**, $\mathsf c_{15}\ge\mathsf c_{17}$:
(P-a.3) fixes $\mathsf R_\ast$ deterministically, so $\mathsf c_{17}$ is a *number*. Step 3 of the proof
now says all of this at the induction's base case; Step 4(a.1)/(a.2) are untouched, running on the
deterministic $\hat\varepsilon_k$.

**A2 accepted.** A5(vi′) is restated as $P(\max_k\|\hat\varphi^{(k)}-\vdagger\|_{H^s}\le\mathsf R)\to1$ at
the **fixed** $\mathsf R$ of `def:srcball`, with the existential-over-one-radius structure stated in the
assumption itself, in `lem:pathcont`, in `def:srcball` and in `rem:paenvelope`. The budget-table row
moves to the envelope form. `def:lfstep`'s preliminary declaration moves too.

### D-000000000000.4 Step 4 — the remaining gating regularity findings

| Finding | Disposition |
|---|---|
| **A4** — Markov over an $e^{O(L_x\ln n)}$ net | **ACCEPTED, and the repair uses the block's own tool at both sites.** `lem:bdiff` gains clause **(ii)**, a **Bernstein** inequality for i.i.d.\ nonnegative bounded summands, **proved in full** (Bennett's mgf bound from the monotonicity of $(e^w-1-w)/w^2$, then the standard optimisation). Clause (i) is variance-blind and would give $L_x=o(n^{1/3})$; clause (ii) gives $L_x=o(n^{1/2})$, **which is A8's own upper end**, and $L_x\ll(n/\ln n)^{1/2}$ makes the tail polynomially small. `prp:phirate` Step 1 is rewritten as (N2.1)–(N2.3): Schur's test for the smoothing operator (**not** Young — the boundary index varies, so it is not a convolution: m5 folded in where it sits inside text this round authors), the expectation conversion `eq:convmean`, the summand bound $\mathsf B\asymp L_x$ **from the sieve inverse inequality**, and **the continuity linking net points to the supremum** — supplied explicitly as the symmetric-form step, with a $\tfrac14$-net and the factor $2$. `lem:aerr` Step 4's Chebyshev/`eq:entropyA` mis-calibration is named and repaired the same way; the lemma's **statement is unchanged** |
| **A5** — `lem:intker`(iii) FALSE as stated | **ACCEPTED.** (iii) is restated for $G$ **of bounded variation with $G(-\infty)=0$**, and the proof names **Fubini** (signed integrand, envelope $\mathsf c_2\un\{|\varsigma|\le c_C\}$ against $|dG|$) rather than Tonelli. The counterexample $G\equiv\tfrac12$ is printed in the statement. The two hypotheses the old proof used silently — $g\ge0$ and $\int g=1$ — are gone; **both consumers are now covered directly**, and `lem:opnoise` Step 3's $\pm$-device is retained as a second route but is no longer necessary. **Fold-in (m3):** (i)'s ``$0\le\mathsf C_{h_u}$'' becomes $|\mathsf C_{h_u}|\le\mathsf c_3$, since the statement contradicted its own proof inside the lemma this round repairs for falsity |
| **A6** — the boundary kernel's defining property | **ACCEPTED, and C3 is restated rather than patched.** C3 now has three numbered clauses. (i) prints $\int\Theta_1=1$ and the order conditions. (ii) makes the boundary index **a distance in bandwidths, normalised so $s_0=1$ is the interior**, with support $[-c_Cs_0,c_C]$ and the **truncated moment conditions** `eq:truncmom`; the right-boundary case is the stated reflection. (iii) is the interior regularity. **`lem:intker`(iv) gains `eq:s0def`** and its proof runs three cases, each closing on `eq:truncmom` at $j=0$. **The C3(ii)/C3(iii) clash DISSOLVES rather than being re-filed** — at $s_0=1$ the support is now two-sided, so symmetry is consistent — and the old verdict *``nothing depends on which is meant''* is recorded as **false at exactly `lem:intker`(iv)**, which is where the checker said it was |
| **A8 / U-1** — (H1c)/(H2c) undeclared | **ACCEPTED. Carried into `proofs.tex` as (P8) and (P9)**, joining the (P1)–(P7) block; all eleven live citations retagged; `results.tex`'s one (H2c) reference rewritten. **(P8) states the conditional$\to$unconditional transfer rule and proves it**, and `lem:opnoise` Step 4 now supplies *both* of its halves explicitly. **(P9) is a pointer, not a declaration**: $\Theta_{s_0}$ and its moment conditions are **promoted into C3** (`eq:rescaled`, `eq:truncmom`), because they are conditions on an assumed object and not conventions of a proof. $\int\Theta_{s_0}=1$ is printed in C3, as the old (H2c) note (a) said it should be |
| **A9** — $n_{\rm m}\asymp n$ | **ACCEPTED.** `eq:foldbal` added to `def:hatT`, with its three consumers named. It is a *construction* convention and costs nothing, but it was used twice and assumed nowhere |
| **A10** — the vacuous Sobolev embedding | **ACCEPTED, and the rate survives while its justification is replaced.** `lem:unifop` Step 4 now runs $H^s\hookrightarrow C^{k,\beta}$ with $k=\lfloor s-\tfrac12\rfloor$ plus a $k$-th order Taylor expansion against C3's moments, needing **$p_K\ge s-\tfrac12$** — now a hypothesis of `prp:phirate` and a row of the budget table. Why the old route is vacuous is printed ($C^{0,\beta}$ on an interval contains only constants at $\beta>1$; at $s=3$ the claim reads ``every $H^3$ function is $\tfrac52$-Hölder''). **Both recurrences fixed**: the (F-e) note in `lem:unifop`'s statement (where the *comparison* to a Hölder-ball entropy is superseded, since the route it compares against does not exist) and `rem:tccwhy`(3a) |

### D-000000000000.5 Step 5 — the two gating auditor findings

**A-1 finished.** `lem:scaleinv`'s closing is rewritten in three paragraphs. **`eq:cap` is repriced with
numbers**: at the frontier-clearing configuration $\omega_n^2\asymp n^{0.08}h_x^{-1}\in(n^{0.208},n^{0.52})$
over the admissible $h_x$ window, so $\bar m_n\ge\omega_n^2\hat\delta_n^{-2}\in(n^{0.848},n^{1.16})$
against $\hat\delta_n^{-2}=n^{0.64}$ — **at $n=2000$, $130$ Landweber steps become between $630$ and
$6750$, a factor of $5$ to $50$** — and the factor is decreasing in $h_x$, so the upper end of the $h_x$
window is the cheap end of the cap. **The cross-reference is redirected from Q-3 to Q-4**, with the reason
stated: the object at issue is the *sieve-restricted injectivity modulus*, which is $L_x$-dimensional and
is *assumed* at (P-a.3), whereas Q-3's $\lambda_{\min}(\mathbf G_n)$ is $n_{\rm m}$-dimensional. **The
auditor's scope correction is honoured**: `prp:tccrepair`(iii) and `prp:norangeinv`'s proviso are
$n_{\rm m}$-dimensional, correctly declined, and are **left declined**; `rem:tccwhy`(3b) and its closing
paragraph, which also point at Q-3, are likewise left. `lem:srctransfer`(iii.a)'s ``generic position''
carries the same redirect, being the same $L_x$-dimensional object. **U-1 is A8 above.**

### D-000000000000.6 Step 6 — the four gating notation findings and the register

| Finding | Disposition |
|---|---|
| **V-1** $\mathcal L$ ×3, no glossary row | **`prp:tccfails`'s quantified candidate becomes $\mathcal Q$** (C70), joining `lem:srctransfer`(ii.a)'s $\mathcal Q_1,\mathcal Q_2$ as this file's letter for a generic operator in a quantified statement. **The decisive fact is a type error, not a count**: clause (iii) instantiates the quantifier at the **unbounded** Gateaux map, while $\mathcal L$ is typed *bounded* at (L1), `rem:ff` and `lem:scaleinv`. **$\mathcal L$ now has a glossary row**, which it did not before |
| **V-2** $\Omega$ alive in the renderings tree | **`lem-bierens.tex:101–103` fixed** — the identity theorem is stated at $\IR^p$, the only set it is applied to, matching `proofs.tex`'s already-corrected version. **Fifth recurrence and the first outside the theory tree**, which is the argument for extending the sync check to `paper/sections/theorems/` |
| **V-3** C67's sweep claim false | **The false claim is corrected, and it is priced as the finding.** C67 asserted ``lowercase $\omega$ occurs in no file of this project''; **verified false at 55 sites.** Bare $\omega$ is the **sample point** at (P6), (P7a), `lem:adjfubini`, `prp:compact` and `lem:adjoint`(iii); a **fourth referent** at C2′(i)'s envelope was a *value of $W$*, breaching the $W$ row, and becomes $\mathsf w$. **`lem:scaleinv`'s generic scale becomes $\omega_\ast$** — the scale moves, not the sample point, because the sample point is universal notation at ~30 sites and the scale lives in one lemma. **$\omega_n$ is untouched**: C67's substantive argument survives. C71 |
| **V-7** $\alpha$ local-made-binding | **§1.6 is amended in the open** (C72), the third time this file has amended a notation rule rather than breached it. C25's direction — *the binding use moves* — **cannot be followed**, and saying so plainly is the honest move: $\alpha=r/(2r+d_Z)$ is under contract with four assumptions and six displays. So $\alpha$ is **withdrawn from §1.6 and declared binding**; the multi-index is written out as $\mathbf j$ (ninth write-it-out), the generic $L^2(\Pi)$ element becomes $\Xi$, and the elementary inequality becomes $\varsigma,\varsigma'$ |
| **3d** register self-contradiction | **All three inconsistencies corrected and recorded**: line 14's ``two slots'' vs §1.5f's ``Three''; ``C1–C67'' vs ``C1–C68''; ``§1.5f holds C66–C67'' vs its three rows. Register now runs **C1–C72**, and the diagnosis is the same one §1.5e recorded for the C45–C48 collision |

**Two methodological findings, recorded in §1.5g because they are limits on this file's own machinery.**
**(i) §1.5b's rule is necessary and not sufficient.** C67 *did* sweep for $\omega$ and reported the sweep
**wrongly**. A second clause is now binding: **a sweep result asserted in a binding file must name the
pattern swept.** A false sweep is worse than no sweep, because later dispatches rely on it instead of
re-sweeping. **(ii) A symbol can be binding *in fact* without ever being declared.** $\alpha$ was claimed
by none of C1–C68; it accreted forty sites while sitting in §1.6. **The audit that catches this is a
census of §1.6 against usage, not a collision sweep**, and it should run once per dispatch. $s_0$ was the
other candidate this round and survives only because C3(ii) as restated now *defines* it.

### D-000000000000.7 The relayed flag from the parallel Assumption-(18) dispatch — ANSWERED, and (P-f) is correct as printed

**The flag:** (P-f) may presume an $h_x$-free conversion of $n_{\rm m}^{-1}\|\Delta_{h_x}v\|_2^2$ to
$\|v\|^2_{L^2(\pi)}$ that it does not have, because the worst-case conversion over $\mathcal V$ carries
$h_x^{-1}$.

**Answer: the conversion IS stated, it IS $h_x$-free, and (P-f) is correct — but the flag correctly
locates where the sieve is indispensable, and the step now says so explicitly.** Three parts.

1. **The conversion (P-f) presumes is the *expectation* conversion**, `eq:convmean`:
   $E[(\Delta_{h_x}v)^2]\le\mathsf K\|v\|^2_{L^2(\pi)}$ with $\mathsf K$ free of $n$, $h_x$ and $h_u$.
   **It holds on all of $\mathcal V$**, and its two ingredients are $h_x$-free because Schur's test on the
   smoothing operator needs only the two one-sided kernel integrals, both $O(1)$ in the *scaled* variable.
2. **The $h_x^{-1}$ the flag names is real, and it is the *worst-case pointwise* conversion**,
   `eq:hstep1b` — which is exactly the ``crude route'' `prp:phirate` Step 1 already named and rejected.
   **So the flag's premise is true of a different constant from the one (P-f) uses.**
3. **The flag is nevertheless right that A4's repair and (P-f) are the same question**, and that the
   conversion must be established on $\mathcal S_n$: what needs the sieve is not the conversion but its
   **uniformity**, and the price of uniformity is the *summand bound* — $\mathsf B\asymp L_x$ on
   $\mathcal S_n$ via the inverse inequality, against $\mathsf c\,h_x^{-1}$ off it, the $L^2(\pi)$ unit
   ball of $\mathcal V$ having infinite sup-norm. **Naming the exponential inequality was therefore not
   sufficient; the summand bound had to be established on $\mathcal S_n$**, and (N2.3) does that. A closing
   paragraph now says all of this, including the sentence a reconstructing reader needs: *the two displays
   are the ambient and the sieve conversion constants, and only the second is the one this step runs on.*

**Three other results from that dispatch, and what was done with each.** (a) **Do not weaken A6b or
`prp:tccrepair` — honoured**: neither is touched, and the auditor's scope correction leaves both declines
standing. (b) **CFF's ceiling $\beta\le1-\epsilon$ is $\mu<\tfrac12$, the same number as the Heinz
barrier; and CFF's Assn 4.6 requires operator-norm convergence, the perturbation route Step 0 refuses and
the reason (P-b) is struck.** This is directly relevant to `rem:lfnonlinear`(3) and to Step 0 and would be
a valuable *econometrics* citation for the ceiling — **but `Bibliography_base.bib` contains no CFF key**,
so it is **carried to the librarian and not written into the `.tex`**. (c) **`prp:hatAprop`(iv) is sharper
than CFF's Prop. 4.2(a)**, which writes ``$\hat M<\infty$'' where `eq:hatTxrem` displays the $h_u^{-2}$
that *generates* (P-f) — same disposition, same reason. (d) The **`dunker2014` / Dunker (2021) split** is
actioned in `rem:lfnonlinear`(c) *without a new key*: the citation defect and the substantive reason for
declining IRGN (it *does not model* the residual-estimation error (P-f) exists to price) are both printed,
with the missing key flagged for the librarian.

### D-000000000000.8 What this round does NOT do

- **Step 7 is not opened.** `thm:rootn` reads $\delta_n$ off A5(ii), which `prp:phirate` discharges; this
  round repairs the discharge and does not extend it.
- **Non-gating findings are carried, by name:** A7 (a.s.\ distinctness within a unit — the C1(ii)
  citation swap), A11 (the version convention for $\hat T$ on $\mathcal V$, which scopes
  `prp:hatAprop`(v) and `prp:tccfails`(i) to $\mathcal V\cap C(\mathcal X)$), m1–m2 (**closed in passing**,
  since `lem:scaleinv`(iii)'s proof is rewritten and (L5) now cites it), m3 and m5 (**closed in passing**,
  sitting inside text this round authors), m4 (`prp:hatAprop`(iv)'s ``twice Fréchet differentiable''
  contradicting `lem:intker`(ii)) and m6 (the measurability/Bochner/DCT bundle, including the
  measurability of the suprema in `eq:unifop`/`eq:aerr` and `lem:bdiff` Step 2's constant).
- **No symbolic spec is written this round**; three are owed — the `eq:cap` repricing arithmetic, the
  $\mathsf R/\mathsf R_\ast$ separation, and `lem:bdiff`(ii)'s exponent against the volumetric entropy.
- **No claim is made that (P-a.3) is derivable.** It is not, and Q-4 is sharpened rather than closed:
  what is now assumed is a *spectral* condition on a *compression*, which is a narrower and more clearly
  stated object than the round-11 pair, but it is still assumed.

---

## POINTER — dispatch 8, the derivative route: assessed and DECLINED

**Full memo: `quality_reports/theory/panel-npiv-discrete/derivative_route_assessment.md`.** Nothing in the
live theory files was edited.

**The device does not transfer, for three reasons in decreasing order of force.** (1) **It pushes the wrong
way.** CFF's derivative reparameterisation is a remedy for a *saturation ceiling* on $\mu$; this paper runs
**linear** LF, which does not saturate, and `eq:muhalf`'s $\mu>\tfrac56$ is a *floor* coming from (P-f).
Composing $\mathcal D^{-1}$ raises the degree of ill-posedness from $a$ to $a+1$ and lowers the source
index from $\mu=\frac{s}{2a}$ to $\mu=\frac{s-1}{2(a+1)}$ — at `rem:h6bandwidth`(5)'s frontier-clearing
configuration $(s,a)=(3,\tfrac34)$ that is $\mu=0.571$, which **fails `eq:muhalf`**, retiring the block's
one admissible design. The charge is exactly $\tfrac83$ extra units of $s$, uniformly in $a$.
(2) **It does not close C1 by any mechanism the spectral restatement does not already supply** — and CFF
is the witness *against* the hope that H1's collapse survives: CFF assumes 4.3 (spectral, $\beta$ free)
**and** 4.4 (link) separately, and 4.4's role is the same two-sided translation, at exponent $(s-1)/a=2.67$
here. (3) **It does not close A3**: the adjoint of a restriction maps into the restricted subspace in both
parameterisations, so (L2) and its naming defect survive verbatim.

**RECOMMENDATION: the spectral restatement of (P-a) (checker's remedy 3), not the commutativity proviso.**
Decisive: **Option A = Option B + a proviso**, so B's hypothesis is strictly weaker and needs strictly less
proved. And B's cost is narrower than "H1 collapses": H1 is retained for A2's Picard form, `def:srcball`,
(P-c)/(P-g) and the budget table; what is lost is only the *derivation* of $\mu$ for **(P-a)'s sample
operator** — which §5.3 of the assessment shows H1 never supplied, since H1's matching is about
$\mathcal A_{\mathrm{cond}}$ on $\mathcal V$ while (P-a) is about a finite-rank realised operator on
$\mathcal S_n$ at a random base point. Option B makes an existing assumption visible rather than adding one.

**Answer to the checker's A1/A2 sequencing question: BOTH radii, and they are currently ONE SYMBOL.**
$\mathsf R$ is an $H^{s}$ ball radius at `def:srcball`, A5(vi′), (F-e), (P-c), (P-g); $\mathsf R_\ast$ is a
**spectral pre-image norm** at $\mathsf c_{17}=2c_\mu\mathsf R^{1/(2\mu+1)}$, hence at $\mathsf c_{15}$,
which `def:lfstep` prints before the data are seen. One symbol on the two sides of an inequality
`def:lfstep` must establish — the same species as dispatch-8 MAJOR 2.1. **Repair order: (1) restate (P-a)
spectrally on the compression, closing C1 and A3; (2) split $\mathsf R$ from $\mathsf R_\ast$ in the same
pass; (3) then A1/A2.** Under Option A there is a **third** constant to pin, the interpolation constant.

**Four things ARE worth taking from CFF, and none is the derivative device.** (a) **CFF uses no tangential
cone condition at all** — Prop. 4.1 runs on Assumption (18), a *relative-ill-posedness condition along the
path*, plus Prop. 4.2(a)'s quadratic remainder, which is `prp:hatAprop`(iv) and which this paper already
has. `prp:tccfails` refutes A6 and says **nothing** about (18). Most promising unexplored route in the
neighbourhood; needs $\lambda_{\min}(\mathbf G_n)$ (Q-3). (b) CFF's source condition sits at a
**deterministic** limit, once — which is why CFF has no **Q-4**; not transferable under iterated
linearisation, but it diagnoses why CFF's assumption looks cheaper and it argues for (a).
(c) **`lem:levels` gets its consumer**: clause (iv) plus the $\mu_{\rm der}<\mu_{\rm lev}$ computation is a
complete one-paragraph justification of the levels choice — the file's `proofs.tex:872` already says it for
the *norm* and not for the *source index*, which is the half that matters. **`lem:levels`'s headline should
be scoped to A2**: "the source condition is the same in the two parameterisations" is true for A2, a plain
range condition, and **false at index $\mu$**. (d) **Citation split**: `rem:lfnonlinear`(c) attributes the
IRGN / above-$\tfrac12$ claim to `dunker2014`; in CFF that is **Dunker (2021)**, while `dunker2014` is the
*noise model*. One key carrying two papers; a sixth absent-key item for the librarian, not a correction.

**On Dunker:** not better for C1 (its rate theorems are spectral too, so the conversion question recurs),
but the **only** candidate that could touch `eq:muhalf`, since IRGN would remove the outer linearisation
loop and hence (P-f). CFF also names the reason it is the wrong tool *here*: Dunker *"does not consider the
estimation error that arises from the use of the regression residuals instead of the true error"* — exactly
the $h_u^{-2}$ object (P-f) exists to price. That should replace `rem:lfnonlinear`(c)'s "cheaper".

**Scope declared:** CFF's supplementary material (Sections A–D) was **not** read, so whether Assumption 4.4
is consumed in the proofs or only in the interpretation is unverified; Dunker (2021) and Dunker et al.
(2014) were not read; the EHN numbering was not checked against a copy.

---

## D-00000000000. Dispatch-8 **strike-3 fix pass** on Part H — 7 MAJOR, 4 MODERATE, 6 MINOR

**Scope.** Exactly the seventeen numbered findings of `proofs_review_dispatch8.md`. Files edited:
`results.tex`, `proofs.tex`, `assumptions.tex`, `notation_glossary.md`, this memo, plus two new
symbolic specs. **Step 7 is not opened.** `results_partH.tex` and `proofs_partH.tex` remain stale merge
records by design and are not edited.

**Nothing in the review is contested.** Two of the seven MAJORs — 2.5 and 3.3 — existed only because a
correct fix was applied in one place and not swept; both sweeps are now complete and a **third
unswept withdrawal** was found in the pass and is recorded below. One repair is *better* than the one
the review offered, and it is flagged rather than folded in silently (§D-00000000000.4).

### D-00000000000.1 The seven MAJORs

| Finding | Disposition |
|---|---|
| **2.4 (−4)** A8 in full ∧ (P-d) makes the block's own reference configuration INFEASIBLE | **ACCEPTED in full, and fixed exactly as C2′(i) was fixed in dispatch 6 — by clause.** `prp:phirate` now assumes A8's **basis** clause (B-splines of order exceeding $s$, quasi-uniform mesh) and its **upper end** $L_x\ll n^{1/2}$, and explicitly **not** its lower end — which A8's own comment already recorded as unused on the rate route. Step 1's "by A8's lower end and the spline direct theorem" is corrected: the direct theorem needs the **basis**, and (P-c) is the rate route's own lower end, calibrated to $h_u\hat\delta_n$ rather than to $n^{-1/2}$. **Two rows are added to the smoothness-budget table**: the surviving joint line $s>\frac{9\alpha}{8(1-2\alpha)}$ (`eq:lxwindow`, $=1.6875$ at $\alpha=\frac38$, $=1$ at $\alpha=0.32$) and the stronger both-routes line $s>\frac{1}{2(1-2\alpha)}$ ($=2$ at $\alpha=\frac38$). **`assumptions.tex`'s "None of the four competes with $s$ … the $s$ budget is unchanged" is REPLACED** by a paragraph saying the opposite for the two new lines, including the $L_x$ margin at $\alpha=\frac38$: $(n^{0.2411},n^{0.25}/\ln n)$. Spec `phirate-sieve-joint-window`. |
| **2.1 (−4)** (L3) is not established; the same constant sits on both sides | **ACCEPTED, and repaired by separating the symbols *and* proving the domination — the review offered "either".** `eq:effnoise` now carries $\mathsf c_{16}$ (**analytic**), `eq:lfsched` keeps $\mathsf c_{14},\mathsf c_{15}$ (**analyst-chosen**), `eq:linlf` introduces $\mathsf c_{17}$ (**analytic**). (L3) is then exactly $\mathsf c_{14}\ge\mathsf c_{16}$ and Step 3 is $\mathsf c_{15}\ge\mathsf c_{17}$, both stated in `def:lfstep`. **"Every quantity is *known* to the analyst" is replaced** by "computable from four inputs and two constants", the two constants are named as inputs, and the failure mode is printed: too small and the implemented level sits below the data error, (L3) fails, (F-f) is void, and the estimator is whatever the cap returns. `rem:phirscope`(5) now lists six items, not four. |
| **2.2 (−3)** (L1) rests on a normalisation whose only available bound diverges | **ACCEPTED. The file owed a lemma and now has one: `lem:scaleinv`, five clauses, proved.** (i) the normalisation *is* a Landweber relaxation parameter and the iterates are identical; (ii) the stopping index is identical; (iii) the source radius maps $\mathsf R\mapsto\varsigma^{2\mu}\mathsf R$ and the noise $\delta\mapsto\varsigma^{-1}\delta$; (iv) **the (F-f) bound is exactly invariant**, $\big(\varsigma^{2\mu}\mathsf R\big)^{1/(2\mu+1)}\big(\varsigma^{-1}\delta\big)^{2\mu/(2\mu+1)}=\mathsf R^{1/(2\mu+1)}\delta^{2\mu/(2\mu+1)}$; (v) **the stopping-index bound is not**, inflating by $\varsigma^{2}$. `eq:linlf` now **shows $\mathsf R$** and performs the cancellation. (L1) holds **surely** from the deterministic bound of `prp:hatAprop`(i) — `lem:pathcont` is no longer needed there. The cap is enlarged to `eq:cap`, $\bar m_n\ge\omega_n^{2}\hat\delta_n^{-2}$. **Both edges the review names are covered by one clause:** (iv) is exact for *every* $\varsigma>0$, so it does not matter whether the unscaled norm diverges or is $o(1)$, and **nothing in Part H needs $\|\mathcal L\|\asymp1$** — which is fortunate, since a matching lower bound would again be $\lambda_{\min}(\mathbf G_n)$. |
| **2.3 (−3)** `eq:a6sieve`'s stated derivation is wrong and vacuous under the display it cites | **ACCEPTED in all four parts.** The display is now derived from **A6** (raw $\hat T$), by Gateaux differentiability, and **why not `eq:a6b` is printed**: there $\hat{\mathcal A}$ is the *exact* Fréchet derivative by `prp:hatAprop`(iv), the LHS is $O(c^2)$ against an RHS of $O(c)$, and the limit is $0\le\frac{\eta}{1+\eta}\|\hat{\mathcal A}v\|$ — true and empty. The base point is **fixed at $\tilde\varphi=0$**, where the raw and smoothed period differences coincide so both displays carry the same $\hat g_i$, with the general-base-point gap $O(h_u^{-1}\hat\delta_n)$ flagged. **"Necessary and sufficient" becomes "only if"**, with the $\lambda_{\min}(\mathbf G_n)$ bound sufficiency needs named and declined; the downstream "exact first-order condition" at `rem:lfnonlinear`(1) is qualified too. **The demotion of reason (1) and the window claim are untouched.** |
| **3.1 (−3)** the $\mu>\frac56$ "coincidence" is an IDENTITY | **ACCEPTED without qualification. The sentence is struck at both sites.** Step 4(a.1) now does the algebra with $\beta$ free: $\kappa\alpha-\frac{2\kappa\beta}{2\kappa-1}=\frac{\kappa}{2\kappa-1}[\alpha(2\kappa-1)-2\beta]$, and $\alpha(2\kappa-1)\ge2\beta$ *is* (P-f) in powers of $n$; the factor is strictly positive for $\kappa>\frac12$. The third comparison is the same inequality again and is **forced** for a two-branch map. `rem:h6bandwidth` gains clause (4) replacing the struck sentence, `prp:phirate`'s statement gains the positive version, and this memo's §D-0000000000.5(2) is struck in place. **The true statement, printed:** (P-f) is exactly the condition under which the newly exposed preliminary-rate requirement is not self-defeating. **Q-1's sharpening is unchanged.** Spec `phirate-prelim-pf-identity`. |
| **2.5 (−2)** the $\bar k$ correction landed in one place out of three | **ACCEPTED.** All three sites now read $(\mu,\varsigma_0,\alpha)$, **including the statement**, which is the line a Step-7 author implements. The proof now says *why*: the base $2\kappa$ is a function of $\mu$; $\alpha$ factors out of the numerator but **not** the denominator, because $\varsigma_0$ is a free exponent and not a multiple of $\alpha$. |
| **2.6 (−2)** "no purely data-driven rule can serve" is Bakushinskii, uncited, and too strong | **ACCEPTED on both counts, and the sharp part is now claimed as the paper's own.** `def:lfstep` splits the argument into **(2a)**, the paper's own and sharp — $\hat r_{k-1}$ cannot bound $\varepsilon_{k-1}$ from below because $\|\hat{\mathcal A}v_\dagger\|\ll\|v_\dagger\|$ *is* ill-posedness — and **(2b)**, the citation: `\citet{bakushinskii1984}`, `\citet[\S3.3]{engl2000}`, declared **worst-case deterministic** and explicitly **not** read as excluding Lepskii-type balancing, which is purely data-driven and rate-optimal up to a logarithm in the statistical setting. **Three local reasons** are given for preferring the schedule (finite $\bar k$, deterministic $\bar k_a$; implemented $=$ analysed by construction; no variance proxy at each $m$). A balancing stop is registered as **CP-13's third arm** and as a **softener for Q-1**. `rem:phirscope`(5) carries the same scoping. Citation note gains **(F-h)**. |

### D-00000000000.2 MODERATE and MINOR

| Finding | Disposition |
|---|---|
| **2.7 (−2)** $\mathcal R$ carries two meanings inside one proposition statement | **ACCEPTED.** The **range-invariance family moves**, not the range: it has 8 sites against 25+, and $\mathcal R(\cdot)$ is the range in Parts B–G. It becomes $\Omega(\varphi,\tilde\varphi)$, glossary **C66**. **The sweep found bare $\Omega$ occupied once**, as the connected open set of the identity theorem inside `lem:bierens`'s proof — a §1.6 local — and per C25 the *local* moved: the theorem is now stated directly at $\IR^p$, the only set it is applied to. Fraktur $\mathfrak R$, bold $\mathbf R$, $\mathsf R$ and $\mathcal J$ were all rejected on sweep, with reasons. |
| **3.3 (−2)** `lem:aerr`, `eq:gamman`, `eq:entropyA` are orphaned | **ACCEPTED.** Both sentences naming it as consumed are corrected (`proofs.tex` `lem:pathcont`, `results.tex` after `eq:entropyA`), and the lemma now opens with **"Consumers: none"** and the two retention reasons stated rather than inferable. Same species as the A6 sweep and treated the same way. |
| **4.1 (−2)** (F-f) exists only in a LaTeX comment | **ACCEPTED.** `rem:ff` displays it in full, in the file's own letters so that (L1)–(L5) read against it line by line, with `\citet[Thm.~6.5]{engl2000}`. **The saturation contrast is added and is worth more than the statement**: Landweber has infinite qualification, the DP saturates Tikhonov at $\mu=\frac12$, and at Part H's $\mu>\frac56$ a Tikhonov step would return $n^{-1/4}(\ln n)^{3/4}$ — *not* $o(n^{-1/4})$, so it fails `eq:frontier` at every configuration. **The choice of Landweber is what makes the paper's own frontier reachable.** What is *not* claimed: that Tikhonov's rate fails, which would need a lower bound. |
| **3.2 (−1)** two "reference configurations" | **ACCEPTED.** `rem:h6bandwidth` gains clause (5), which names them once: the **boundary configuration** $(1,3,4.5)$, an illustration of clause (0) and **not an admissible design** — it fails (P-f) by $(\ln n)^{1/3}$ and, with A8 in full, has an empty sieve window at $s<2$ — and the **frontier-clearing configuration** $(2,3,\frac34,0.32)$, which clears every line in the budget table. Every "reference configuration" in the live files is renamed. |
| **3.4 (−1)** the 2-dimensional witness is claimed for all $2\mu>1$ but proved at $\mu=1$ | **ACCEPTED; the claim is true and the argument is supplied.** By Löwner's divided-difference criterion for matrix monotonicity **of order two**, $\det\big(\begin{smallmatrix}p&\frac{1-\epsilon^p}{1-\epsilon}\\ \frac{1-\epsilon^p}{1-\epsilon}&p\epsilon^{p-1}\end{smallmatrix}\big)=p^{2}\epsilon^{p-1}-\big(\frac{1-\epsilon^{p}}{1-\epsilon}\big)^{2}\to-1$ as $\epsilon\downarrow0$ **because $p>1$**, so a $2\times2$ witness exists at every $2\mu>1$. The explicit $\mu=1$ pair is kept, as a checkable instance. |
| **2.8 (−1)** joint surjectivity asserted from distinctness | **ACCEPTED.** The inclusion $\mathcal R(\hat{\mathcal A}_\varphi)\subseteq\operatorname{span}\{\hat g_i\}$ is unconditional and is all the $\tilde\varphi$ side uses; equality, used at the single index $i^\ast$, is now a **stated proviso of clause (ii)** with the correct reason given. **Distinctness is not it** — the minimum gap is $O_P(n^{-2})\ll h_x$ and the bumps overlap. **What works, and where distinctness genuinely enters:** off the boundary layer each $\mathsf d_i$ is a difference of two translates of one compactly supported function whose Fourier transform has a discrete zero set, so $\sum c_i\mathsf d_i=0$ forces a trigonometric polynomial at $2n$ distinct frequencies to vanish. **The boundary layer is where it is not established, and that is printed.** Three reasons keep the cost at zero: it is **qualitative**, not a $\lambda_{\min}$ rate; it touches clause (ii) only; and **no result consumes `prp:norangeinv`**. |
| **2.9 (−1)** $(2\mathsf c_{15})^\kappa$ vs $\mathsf c_{15}2^\kappa$; `eq:fixedpoint` vs `eq:lfsched` | **ACCEPTED.** `eq:fixedpoint` is now `eq:lfsched` written out, carrying **both** constants; Step 4(a) and (b) read $\mathsf c_{15}(2\mathsf c_{14})^{\kappa}$; $\mathsf b_n$'s $O(1)$ term changes and nothing else does. |
| **3.5 (−1)** C5′(ii)'s window computed at the retired bandwidth | **ACCEPTED.** Recomputed at $h_u\asymp\hat\delta_n^{1/8}$, at **both** configurations: at $(2,3,\frac34,0.32)$ the window is $(n^{-0.44},n^{-0.128})$; at the boundary configuration, at $s$ just above 2, it is $(n^{-0.4297},n^{-0.25})$. The retired reading $(n^{-13/32},n^{-0.3})$ is kept alongside, marked retired, with the direction of each change stated. |
| **4.2 (−1)** Löwner uncited | **ACCEPTED.** `\citet{loewner1934}` and `\citet[Ch.~V]{bhatia1997}`, with **(F-g)** added to the citation note. **The chapter and not a theorem number is cited**, because the numbering was not verified against a copy in this pass and the block's rule is that a result is not cited at a precision that has not been checked. |
| **4.4 (−1)** slot-register range | **CHECKED; the two records in the glossary agree and no renumbering is needed.** §1.5e's header and the file's opening note both say **C49–C65** for Part H's *new* slots. **An inventory line is added** so the two cannot drift: the register is one sequence C1–C68, §1.5a–c hold C1–C44, §1.5d C45–C48, §1.5e C49–C65, §1.5f C66–C68. Any external "C36–C65" or "C40–C65" is quoting the whole register or a grep window. |

### D-00000000000.3 Held from the previous round, and unchanged

`lem:srctransfer`(ii.b); the rejection of the prescribed downward perturbation; the open question
"does transfer itself fail above $\frac12$?", left open in the open; `prp:norangeinv`(ii)'s rebuilt
witness; `def:hatT`'s truncation; the repelling-fixed-point analysis; `prp:tccfails`'s quantifier; all
of `rem:h6bandwidth` clauses (0)–(2′); `eq:lfsched`'s resolution of the original 2.1 at the level of
the rule; and **C(5) stays HELD** — the reason is unchanged and the critic confirmed it.

### D-00000000000.4 One repair that is better than the one offered, and one defect found in the pass

**(1) The $C_k$ that composes does not exist, and that is a better answer than bounding it.** The review
observes that Step 3 delivers $\varepsilon\le C_k\hat\varepsilon_{k-1}$ with $C_k$ unquantified and
composing, and offers $\sup_{k\le\bar k}C_k<\infty$ as the repair. **With the constants separated by
role the composition does not arise at all.** (L3) uses the induction hypothesis as a *substitution into
a bound*, and $\mathsf c_{14},\mathsf c_{16}$ do not depend on $k$; Step 3 closes the induction through
the single inequality $\mathsf c_{15}\ge\mathsf c_{17}$, also $k$-free. **Finiteness of $\bar k$ is
still used** — to intersect finitely many "w.p.$\to1$" events, and for A5(vi′) — **but not in the
constants**, and the proof now says so. The review's diagnosis stands; its repair is not the one taken.

**(2) A third unswept withdrawal, found in this pass and not named by the review.** Glossary **C58**
withdrew $\delta_n^{(k)}$ in the dispatch-7 pass. The symbol survived at one **live** site: the
"Where the threshold comes from" paragraph of `prp:phirate`'s **statement**, which printed the stagewise
recursion in it. Rewritten in $\hat\varepsilon_k$, with both constants. **This is the same species as
2.5 and 3.3 and as the C44 comment-site of dispatch 6** — a withdrawal recorded in the glossary and not
swept in the text, three passes running — and the glossary now argues for a
`check_rendering_sync.py` row on every *withdrawn* symbol, not only on every *declined slot*.

### D-00000000000.5 What this pass did NOT do

- **No Step 7.** Both leaks the review identified are closed. `prp:phirate`'s **statement** now
  describes $\bar k$ correctly (2.5). And the sieve window is non-empty for the rate route once A8 is
  cited by clause (2.4): at $\alpha=\frac38$, `eq:lxwindow` asks $s>1.6875$, which $s=1.75$ clears,
  where A8 in full asks $s>2$, which it does not. **This does not rehabilitate the boundary
  configuration**, which still fails (P-f) by $(\ln n)^{1/3}$ and still cannot support the balancing
  route; `rem:h6bandwidth`(5) names $(2,3,\frac34,0.32)$ as the design and $(1,3,4.5)$ as the
  illustration, and a Step-7 author and a `/simulate` grid should both read that clause first.
  **`rem:phirscope`(2)'s $\ln n$ warning should still open the Step-7 brief as a hard note.**
- **One new labelled result, and it is the one MAJOR 2.2 requires.** `lem:scaleinv`, with
  `eq:scaleinv`; plus the displays `rem:ff`/`eq:ff` (a *quoted* external theorem, not a new result),
  `eq:normconst`, `eq:cap`, `eq:linlftot` and `eq:lxwindow`. **No new hypotheses**, no new assumption
  tag, and no change to any existing statement's conclusion.
- **Two specs added, none edited.** `phirate-prelim-pf-identity` (3.1) and
  `phirate-sieve-joint-window` (2.4). **The two flagged in the previous round are still flagged and
  still not edited:** `phirate-retune-mu-five-sixths` verifies the *power* condition where the
  threshold is now strict, and `phirate-operator-noise-budget` verifies the struck (P-b).
- **Not mine, and unchanged:** the eight absent bibliography keys — `engl2000`, `hanke1995`,
  `dunker2014`, `conway2000`, `severini2006`, and now `loewner1934`, `bhatia1997`, `bakushinskii1984`
  — and `chenreiss2011`, cited nowhere. **The build renders `[?]` silently rather than failing**, which
  is why a `\citation`-vs-`.bib` diff belongs in the sync script's CHECK set.
- **Three narrow critics should re-sweep before Step 7**, and the pass has enlarged two of their
  targets: **notation-warden** (C66–C68 are new, and $\Omega$/$\omega_n$ is a deliberate case pair);
  **assumption-auditor** (A8 is now cited *by clause*, `eq:lxwindow` is a new budget line, `lem:aerr`
  is declared consumer-free); **regularity-checker** (the normalisation is now a lemma, the surjectivity
  proviso is now stated, and both were on its list).

---

## D-0000000000. Dispatch-7 **fix pass** on Part H — two CRITICALs, eight MAJORs, five MODERATEs

**Scope, and what is deliberately outside it.** Exactly the fifteen numbered findings of
`proofs_review_dispatch7.md`, the critic's rulings on the six held requests, the glossary renumbering,
and the two findings the counterexample-hunter delivered mid-pass. **Step 7 is not opened.** Files
edited: `assumptions.tex`, `results.tex`, `proofs.tex`, `notation_glossary.md`, this memo.
`results_partH.tex` and `proofs_partH.tex` are left as merge records and are now stale by design.

**Nothing in the review is contested on the merits.** Two things go beyond it and both are recorded
rather than folded in silently: the review's own prescribed repair for MAJOR 2.3 **does not work**, and
the CRITICAL 2.1 repair **exposes a requirement on the preliminary estimator** that no round had
stated. Both are §D-0000000000.5.

### D-0000000000.1 PRIORITY 1 — `prp:tccfails` strengthened to the construction-free form

**Taken, and it is the cheapest strengthening in the pass.** Steps 1–4 of the proof used nothing about
$\hat{\mathcal A}_{\tilde\varphi}$ beyond boundedness: a spike of vanishing $L^2(\pi)$-norm is
annihilated in the limit by *any* bounded operator. The proposition is restated in three clauses:
**(i)** for every bounded $\mathcal L:\mathcal V\to L^2(\Pi)$ the A6 inequality is violated somewhere in
every ball; **(ii)** A6 in particular; **(iii)** the one unbounded candidate, the raw Gateaux
derivative, is disposed of separately, because $\|\mathrm d\hat T[v_k]\|\asymp n_{\rm m}^{-1}h_u^{-1/2}$
while $\|\Xi_\ast\|=O(n_{\rm m}^{-1})$.

**Clause (iii) needed one hypothesis the review did not name and it is stated rather than assumed.** The
$h_u^{-1/2}$ lower bound requires $\liminf h^{-1}\int C_h(u-\Delta U_{i^\ast},1)^2\Pi_u(du)>0$
(`eq:lebpt`), which holds at every Lebesgue point of $\varpi_u$ and hence, **at each fixed
$\tilde\varphi$**, almost surely under C2′(i). **The quantifier is "at each fixed $\tilde\varphi$,
a.s." and not "a.s., at every $\tilde\varphi$"**, because $\Delta U_{i^\ast}(\theta,\tilde\varphi)$
shifts with $\tilde\varphi$ and an uncountable union of null sets need not be null. Clauses (i)–(ii)
carry no such caveat.

**Why it matters, in one line:** it immunises the refutation against the deviation `def:hatAcon` itself
flags — the smoothed $\Delta_{h_x}\varphi_i$ inside `eq:hatg` rather than the raw $\Delta\varphi_i$ —
because that deviation changes *which* bounded operator is used and clause (i) quantifies over all of
them.

### D-0000000000.2 The two CRITICALs

| Finding | Disposition |
|---|---|
| **2.1 (−10)** the estimator does not implement the stopping rule the proof analyses | **ACCEPTED, and repaired in the ESTIMATOR, not the proof.** See below — the review's suggested repair does not survive, and the one adopted is different. |
| **2.2 (−8)** `eq:linlf` asserted; the operator-noise route undecided | **ACCEPTED in all three parts.** The route is **decided: conditional on the sample**. (F-f) is added to the citation note with the invoked statement written out in full and its five hypotheses verified one by one at `prp:phirate` Step 2 (L1)–(L5). The $\gamma_n$ term of `eq:linlf` is **struck**, hypothesis **(P-b) is struck**, and `lem:aerr` is **no longer consumed** by `prp:phirate`. The sieve-projection substitution is **performed**, at Step 1, and (P-c) is strengthened to $\mathsf RL_x^{-s}=O(h_u\hat\delta_n)$, which is what the display needs. |

**On 2.1, and the review's prescription needs a correction.** The suggested repair —
$\tau_{\rm DP}\mathsf c(\hat\delta_n\ln n+h_u^{-2}\hat r_{k-1}^2)$ with $\hat r_{k-1}$ the realised
residual — **is not sound**, and the reason is structural rather than technical. The quantity the
threshold must dominate is $h_u^{-2}\varepsilon_{k-1}^2$ with
$\varepsilon_{k-1}=\|\vdagger-\hat\varphi^{(k-1)}\|$, and the realised residual does *not* bound
$\varepsilon_{k-1}$ from below: ill-posedness is exactly the statement that
$\|\hat{\mathcal A}v_\dagger\|\ll\|v_\dagger\|$, so $\hat r_{k-1}$ can be far smaller than $\varepsilon$
and the repaired threshold would sit below the data error for the same reason the old one did.
**More generally, no purely data-driven rule can serve**: for an ill-posed problem a regularisation
parameter chosen from the data alone is not convergent, so the noise level must come from outside.

**What is done instead.** `def:lfstep` gains a **deterministic stagewise schedule** `eq:lfsched`,
$$\hat\delta^{\rm eff}_{n,k}=\mathsf c_{14}\big(\hat\delta_n\ln n+h_u^{-2}\hat\varepsilon_{k-1}^2\big),
\qquad \hat\varepsilon_k=\mathsf c_{15}\big(\hat\delta^{\rm eff}_{n,k}\big)^{\kappa},$$
and stops at level $\tau_{\rm DP}\hat\delta^{\rm eff}_{n,k}$. **Every quantity is computable before the
data are seen**, from $(\hat\delta_n,h_u,\kappa,\hat\varepsilon_0)$ — the procedure already needs the
first three. Step 4's recursion is then run on $\hat\varepsilon_k$ rather than on the unobservable
$\delta_n^{(k)}$, and the proof changes very little, because the recursion was always a recursion in a
*bound*. **The empty-set convention is stated** ($\hat m^{(k)}:=\bar m_n$), the cap is sized
($\bar m_n\ge\hat\delta_n^{-2}$), and (L4) shows the set is non-empty w.p.→1.

### D-0000000000.3 The eight MAJORs

| Finding | Disposition |
|---|---|
| **2.3 (−3)** `lem:srctransfer`(ii)'s counterexample refutes itself | **ACCEPTED as a defect; the prescribed repair REJECTED, with a proof that it cannot work.** See §D-0000000000.5(1). (ii) is restated as (ii.a) the tool fails — Löwner, with the explicit $2\times2$ witness at $\mu=1$ — and (ii.b) **no diagonal example can witness the claim, because transfer HOLDS at every $\mu$ in the commuting case**, which is proved. |
| **2.4 (−3)** (P-f)'s logarithms decide against the boundary | **ACCEPTED.** A new clause (0) of `rem:h6bandwidth` shows the logs never cancel, since $4\mu/(2\mu+1)>1$ iff $\mu>\frac12$; **all thresholds are now strict**, $\alpha(2\kappa-1)>\frac18$ and $\mu>\frac56$; and the reference configuration $(1,3,4.5)$ is displayed **failing by $(\ln n)^{1/3}$**. `prp:stopfeas`(iv) is split into "free against `eq:frontier`" and "not free against (P-f)". `eq:muhalf` now reads $\mu>\frac56$. |
| **2.5 (−2)** "with probability one" not established | **ACCEPTED, and the truncation is moved into the maintained block.** `def:hatT` truncates $\hat\varrho$ to $[\varepsilon_\varrho,1-\varepsilon_\varrho]$, giving $\varepsilon_\varrho\le|\widehat{\widetilde W}_i|\le1$ **surely** (`eq:wbounds`). Fixes `prp:tccfails`, `prp:hatAprop` Step 7, **and** — the hunter's finding — the zero-row degeneracy of $\mathbf G_n$. A4(iii)'s fold split is added to `prp:tccfails`'s hypotheses. |
| **2.6 (−2)** four unstated hypotheses | **ACCEPTED.** $\mathsf Rh_x^{s-1/2}=O(\hat\delta_n)$ becomes hypothesis **(P-g)**, an upper end for $h_x$, with the window documented in C5′(ii)'s comment; `eq:entropyA` and $\mathsf Rh_x^{s-1/2}=o(1)$ move into `lem:aerr`, which `prp:phirate` no longer consumes; A5(vi) at every stage becomes **A5(vi′)**. |
| **2.7 (−1)** `prp:norangeinv`(ii) runs an upper bound backwards | **ACCEPTED, and the construction is replaced rather than patched.** The new witness is the single explicit direction $b=\mathsf d_{i^\ast}/\pi$, whose norm and functional value are both computed ($\Delta_{h_x}b_{i^\ast}=\|b\|^2\ge(2c_C\|\pi\|_\infty h_x)^{-1}$), displaced far enough that its kernel's support leaves the union of *all* supports at the base point. **No $\lambda_{\min}$, no min-norm solution, no genericity of $\Delta Y$**, and the "supported where none of them need be" sentence is gone. The radius hypothesis becomes $\rho>\mathsf c_9\mathsf D_nh_x^{1/2}$, and (i) gains the chaining step the larger radius requires. |
| **2.8 (−1)** the entropy route is mis-wired | **ACCEPTED, and confirmed independently by the hunter.** (P-d) now names `eq:entropysieve`; `eq:entropy` is restated in primitive variables and is **consumed by nothing**; `lem:aerr` is restricted to $\mathcal V_n\cap\mathcal S_n$ and routed through the volumetric bound. |
| **2.9 (−1)** `prp:tccrepair`(ii) proves `eq:a6b` only at the centre | **ACCEPTED.** `eq:gramunif` requires $\lambda_{\min}(\mathbf G_n(\cdot))$ bounded below **uniformly over base points**; the conclusion is A6b at radius $\frac12\min\{\bar\rho_n,\rho_0\}$; and the proof prints the two quantifier steps separately. $\mathbf G_n$ now carries its base point as an argument. |
| **3.1 (−2)** `prp:phirate` contradicts its own proof about A5(vi) | **ACCEPTED; the statement was the over-claim and it is corrected.** A5(vi′) is a **hypothesis** of `prp:phirate`, listed as such; only A5(i)–(iii) are discharged. |

### D-0000000000.4 The five MODERATEs, plus 3.2, 3.3, 3.7–3.10

| Finding | Disposition |
|---|---|
| **3.2 (−2)** the A6 sweep is incomplete | **ACCEPTED.** All four prose sites rewritten: `results.tex` R1(iv) (now routed through `prp:phirate`'s actual hypotheses), the assumption block's Discussion paragraph (now "A7 … and it is now the only one"), `rem:draftrec`(iii), `rem:quadremainder`. `rem:tccverdict`(3) says explicitly that "downstream" means the prose as well as the theorems. |
| **3.3 (−1)** "saturates" over-claims | **ACCEPTED.** `rem:lfnonlinear`(3) now says the inherited **theorem is unavailable** above $\mu=\frac12$ — its proof running through the same operator monotonicity — and states in the open that **no saturation (lower-bound) result is proved or cited**. The disposition is unchanged: one cannot inherit a theorem one does not have. |
| **3.4 (−1)** A5(vi) needs a stagewise restatement | **ACCEPTED.** **A5(vi′)** added; the Route column reads "both"; the comment says why a Route change alone would not have sufficed. |
| **3.5 (−1)** `prp:tccfails`'s scope: the sieve is untouched | **ACCEPTED, and the hunter's version is sharper than the review's and is the one printed.** `rem:tccwhy`(3): on $\mathcal S_n$ the spike is **not representable**, by a margin of $n/L_x$ — not merely damped by the inverse inequality. The exact first-order condition `eq:a6sieve` is displayed; it is a **near-identity** statement about $x$-smoothing, not a curvature statement; it turns on $h_xL_x$, which **no assumption constrains**; and the block's own window contains both verdicts. **Amended at §D-00000000000 (MAJOR 2.3): the display is the first-order limit of *A6*, not of `eq:a6b` — under `eq:a6b` the same limit is vacuous — it is written at base point $0$, and it is an "only if" and not an equivalence.** The demotion of reason (1) and the window claim are untouched. |
| **3.6 (−1)** A2, C4′, A1c listed with no consumer | **ACCEPTED.** Struck from `prp:phirate`'s hypothesis line, which now reads A0, A1, A1b(iii)–(iv), A4, A5(vi′), A8, B1, C1, C2′, C3, C5′, H1. |
| **3.7** (P-a) must be priced in the same sentence | **ACCEPTED.** A dedicated paragraph in `prp:phirate`, and `rem:lfnonlinear`'s two "same place" sentences now read "**under (P-a)**". |
| **3.8 (−1)** $\varkappa$ carries four meanings | **ACCEPTED.** Both new uses **withdrawn** — Heinz's exponent written out at the strength consumed, the transfer residual written out. Glossary C64 and the §1.6 row record it. |
| **3.9 (−1)** $\mathcal V_n$ carries three meanings | **ACCEPTED.** `eq:ball`'s $\mathcal V(\varphi_\circ,\rho)$ carries centre and radius as **arguments**; bare $\mathcal V_n$ is the source-condition ball alone. This also retires `prp:norangeinv`'s ball $\mathcal B$, a fourth meaning of calligraphic $\mathcal B$ that no previous sweep caught. |
| **3.10 (−1)** slot-register collision | **ACCEPTED.** Part H renumbered to **C49–C65**, §1.5e. Recorded as an orchestration failure — parallel dispatches partitioned the files and not the register — at the head of the glossary. |
| **4.2 (−1)** (F-e)'s two pins are not interchangeable | **ACCEPTED.** Birman–Solomjak is **the** pin; the vdV&W route is recorded with its price, $\epsilon^{-1/(s-1/2)}$ and $s>2.25$, and marked not interchangeable. |
| **4.3** `dunker2014` in prose without `\cite` | **ACCEPTED.** `\citep{dunker2014}` added at `rem:lfnonlinear`(c). Fifth key for the librarian. |

### D-0000000000.5 Three things found in the fix pass that the review did not name

**(1) The review's prescribed repair for MAJOR 2.3 does not work, and the reason is provable.** The
review asks for a **downward** diagonal perturbation, $\hat\sigma_J=\sigma_J-\gamma'$. That fails too,
and so does every diagonal construction: **if $\mathcal A$ and $\hat{\mathcal A}$ share a singular
system, source-condition transfer holds at every $\mu>0$**, with $\mathsf M=2^{2\mu}\mathsf R$ and
residual $(2\gamma)^{2\mu}\mathsf R$ — split the index set at $\sigma_j\ge2\gamma$; above it
$\hat\sigma_j\ge\sigma_j/2$ bounds the pre-image, below it $|v_j|\le(2\gamma)^{2\mu}|\varsigma_j|$
bounds the residual. That display is now printed as (ii.b). It also explains *why* the round-9 attempt
inverted itself: in the diagonal case the conclusion is true, so any diagonal "counterexample" must
contain an error. **The honest claim, and the only one the file uses, is that the DEVICE is
unavailable**: operator monotonicity of $z\mapsto z^{2\mu}$ fails for $2\mu>1$ (Löwner), with the
explicit $2\times2$ witness at $\mu=1$. Whether transfer itself fails above $\frac12$ is left **open**,
in the open. Nothing downstream weakens: `prp:phirate` performs no transfer, and
`rem:lfnonlinear`(3)'s claim is exactly that the inherited theorem — whose own proof runs through the
same monotonicity — is unavailable.

**(2) The 2.1 repair exposes a requirement on the preliminary that no round had stated, and it is
governed by the same $\mu>\frac56$.** Step 4(a)'s recursion is affine in $\log(1/\hat\varepsilon_k)$
with slope $2\kappa$ and a **repelling** fixed point at
$\frac{\kappa\alpha}{4(2\kappa-1)}\log n$. The iteration improves only if the preliminary clears it:
$$\varsigma_0>\frac{\kappa\alpha}{4(2\kappa-1)} .$$
**This is weaker than the conclusion exactly when $4(2\kappa-1)>1$, i.e. when $\mu>\frac56$ — which is
(P-f).** Below $\frac56$ the two cross and the procedure would need a preliminary at least as good as
its own output. At $(\mu,\alpha)=(1,\frac38)$ it asks $\varsigma_0>\frac3{16}$ against a delivered
$\frac14$. ~~**So $\mu>\frac56$ now governs two independent things** and neither is a restatement of the
other.~~ **STRUCK in the dispatch-8 pass, §D-00000000000, MAJOR 3.1: the two are the *same*
inequality**, $\kappa\alpha-\frac{2\kappa\beta}{2\kappa-1}=\frac{\kappa}{2\kappa-1}[\alpha(2\kappa-1)-2\beta]$
and $\alpha(2\kappa-1)\ge2\beta$ *is* (P-f), the factor being strictly positive. **The correct
statement, which is what the file now prints:** (P-f) is exactly the condition under which the newly
exposed preliminary-rate requirement is not self-defeating. *The mathematics of (a.1) was right and the
sharpening of Q-1 is unaffected; only the description of why the two thresholds agree was wrong.*
The requirement is written into (P-a); $\bar k$'s closed form is given and depends on
$(\mu,\varsigma_0,\alpha)$ — **not on $\mu$ alone**, which is a second correction to `prp:phirate`'s
statement, one its own Step 4 text already conceded.

**(3) The `prp:hatAprop`(iv) remainder, not `prp:frechet`(i), is what `def:lfstep` absorbs.**
`rem:lfnonlinear` cited the deterministic operator's quadratic remainder where the proof uses the
**sample** operator's exact one, `eq:hatTxrem`. Corrected in place. Small, but it is the same species as
the A6 sweep: a citation that was right about the mechanism and wrong about the object.

### D-0000000000.6 The critic's rulings on the six held requests, as applied

| | Ruling | As applied |
|---|---|---|
| **C(1)** A6 leaves the block | APPLY, with three changes, and strengthen | **DONE.** A6 retired in place with the struck display and the label kept (`def:hatA` and two other files cite `ass:tcc`); probability claim fixed (2.5); scope stated, including the sieve (3.5); four prose sites swept (3.2); construction-free form (§D-0000000000.1). |
| **C(2)** $\hat T$ into `assumptions.tex` | APPLY, truncate to $[\varepsilon_\varrho,1-\varepsilon_\varrho]$ | **DONE.** `def:hatT` and `def:intker` both move into Part V; `def:hatTexp` in `results.tex` keeps only the $x$-smoothed objects. |
| **C(3)** A7's threshold | APPLY — MANDATORY | **DONE.** `eq:a7amend` is now A7's statement; the comment records that it is **not** free against (P-f). |
| **C(4)** A5(i)'s comment | APPLY with a guard, together with C(6) | **DONE, jointly.** A5(i)'s comment has three clauses, the third being the guard: under the re-tuning the bias is $\asymp\hat\delta_n$, so `prp:stopfeas`(i) is restated at $\hat\delta_n$, with the sharper $\hat\delta_n^{(T)}$ version recorded as holding only at the round-9 bandwidth. |
| **C(5)** C5′(ii) → (1,1) | **HOLD one round** | **HELD, and the hold is confirmed by the critic.** The re-derivation is recorded in C5′(ii)'s comment together with the reason for holding — the upper end (P-g) is still a proposition hypothesis, and relaxing the lower bound while the upper end is undocumented leaves the window unspecified in both directions. **§D-00000000000 (MINOR 3.5): the window in that comment was computed at the bandwidth C5′(i) retired in the same pass, and at an $s$ the joint sieve line rules out. It is recomputed at the amended bandwidth, at *both* running configurations.** |
| **C(6)** re-tune C5′(i), $\mu>\frac56$ strict | APPLY | **DONE.** C5′(i) reads $h_u\asymp\mathrm{sd}(\Delta U)\hat\delta_n^{1/p_K}$; the guard is rewritten with both halves marked (what survives, what does not); the $\alpha$-dependence is stated as a cost; `eq:muhalf` is $\mu>\frac56$. |
| **Glossary** | APPLY at C49+, plus $\varkappa$ and $\mathcal V_n$ | **DONE.** §1.5e, C49–C65, with $\varkappa$ at C64 (both uses **declined**) and $\mathcal V_n$ at C63. C55 carries C13's amendment; C62 is the declined inflation factor. |

### D-0000000000.7 What this pass did NOT do

- **No Step 7.** The three blockers the review names are now closed — 2.1 by the estimator amendment,
  3.1+3.4 by A5(vi′), 2.4 by the strict $\mu>\frac56$ — but opening Step 7 was not in scope.
  **`rem:phirscope`(2)'s warning stands and should be a hard note in the Step 7 brief**: `eq:phirate`
  delivers $(\hat\delta_n\ln n)^{2\mu/(2\mu+1)}$ where A5(ii) writes $\hat\delta_n^{2\mu/(2\mu+1)}$.
  <!-- STALE AS OF DISPATCH 11; MARKED IN DISPATCH 14. This sentence is a dispatch-9 record and its
  present tense has been false since dispatch 11: A5(ii) was AMENDED there and now writes
  $\delta_n:=(\hat\delta_n\ln n)^{2\mu/(2\mu+1)}$, the object `eq:phirate` delivers. See
  `rem:rootnlog`(2). The sentence is MARKED rather than rewritten because it is the record of what a
  past dispatch decided, and rewriting a dated record to match the present erases the decision; but a
  present-tense claim about a maintained clause must carry its staleness marker, which this one did not.
  This is one of the two sites the notation-warden's N5 names. -->
  **[STALE — A5(ii) was amended in dispatch 11; see `rem:rootnlog`(2). Retained as a dated record.]**
- **No new results.** `def:hatT`, `eq:ball`, `eq:lfsched`, `eq:wbounds`, `eq:a6sieve`, `eq:gramunif`,
  `eq:rirad`, `eq:prelimrate`, `eq:lebpt`, `eq:a7amend` are new displays; A5(vi′) is a new clause;
  `prp:tccfails` gains clauses. No new theorem.
- **No spec changes, and two specs now need re-checking by the coordinator.**
  `phirate-retune-mu-five-sixths` verifies $(6\mu-5)/(4(2\mu+1))$, which is right for the **power**
  condition but the threshold is now **strict**; `phirate-operator-noise-budget` verifies (P-b), which
  is **struck**. Flagged, not edited.
- **The four missing bibliography keys are still missing** — `engl2000`, `hanke1995`, `chenreiss2011`,
  `dunker2014` — and `dunker2014` is now cited rather than named in prose, so it is a fifth live
  breakage rather than a latent one. Librarian's, per §6 of `step6_memo.md`.
- **Coordinator items untouched:** N-13; `proof_strategy_memo.md` §2.5(i) and :521; §2.5(i)'s ball;
  §2.5(iii)'s necessity claim.

### D-0000000000.8 Open items after this pass

- **Q-1 (escalation, user) is now sharper and harder.** The preliminary $\hat\varphi^{(0)}$ must supply
  a **known polynomial rate** $\hat\varepsilon_0=O(n^{-\varsigma_0})$ with
  $\varsigma_0>\frac{\kappa\alpha}{4(2\kappa-1)}$, not merely consistency. This is not an artefact of
  the repair: the finiteness of $\bar k$ always required it, and the fixed-threshold rule was
  unimplementable without it. **User decision, as before.**
- **Q-4 (P-a) is unchanged and is now priced in the text.** A random link condition at a
  data-dependent base point, assumed w.p.→1, with no sufficient condition anywhere.
- **NEW (Q-6): is `eq:a6sieve` true?** A6 restricted to $\mathcal V_n\cap\mathcal S_n$ is neither
  refuted nor established. It turns on $h_xL_x$ and would cost a **new joint budget line**
  $h_xL_x=O(\eta_{\rm TCC})$ plus a $\lambda_{\min}(\mathbf G_n)$ bound. **Nothing in this programme
  needs it**; it is recorded because a referee will ask why the sieve does not rescue the inherited
  route, and the answer is `rem:lfnonlinear`(3), not `prp:tccfails`.
- **NEW: the inherited route's second sieve cost.** Even granting a cone condition on $\mathcal S_n$,
  the cited theorem is for **unprojected** nonlinear Landweber on a ball of the ambient space
  containing the solution; `def:lfstep`(b) projects, and $\vdagger\notin\mathcal S_n$. Booked at
  `rem:lfnonlinear`(b).

---

## D-000000000. Dispatch-6 **fix pass** on Part G — three MAJORs, six MINORs, two fold-ins

**Scope, and what is deliberately outside it.** Exactly the nine findings of
`proofs_review_dispatch6.md`, plus the two items the dispatch asked to be folded in without deduction.
**No new results. Step 6 (`prp:phirate`) is not written** — a parallel dispatch owns it and writes into
separate files. **Nothing under `paper/sections/theorems/` is touched**, and no Part H content exists.
Files edited: `results.tex`, `proofs.tex`, `assumptions.tex`, `notation_glossary.md`, this memo, and one
row in `scripts/render-sync/check_rendering_sync.py`.

**Nothing in the review is contested.** All three MAJORs and all six MINORs are accepted as stated. Two
things go beyond what the review found, and both are recorded below rather than folded in silently.

### D-000000000.1 The three MAJORs

| Finding | Disposition | Where |
|---|---|---|
| **2.1 (−5)** L-21 Step 2 cites the measurability of the wrong object | **ACCEPTED, and repaired structurally rather than by the one sentence.** The root cause is that **one symbol carried two functions**; Step 0's representative is now $\ell^\Pi_0$ and Step 2 *defines* $\ell^\Pi_\star$ from it. The missing sentence is then sayable and is printed as its own paragraph, headed *"The average does not see which representative it is computed from, and that is the load-bearing observation of this proof"* | `proofs.tex` Steps 0–2; glossary C45 |
| **2.2 (−3)** $\mathcal T_\ast$ and the $H^{\mu''}$-budget used as measurable without construction | **ACCEPTED.** Both repairs are made **in A2c**, as clauses **(m.1)** and **(m.2)**, because that is where the objects live and where `eq:lambdamu` sits. Step 2 now cites (m.1) for $\IR\times\mathcal T_\ast\in\mathfrak B(\IR)\otimes\mathfrak B(\mathcal T)$. `proofs.tex:2816`'s blanket claim is amended to a five-item, object-by-object statement | `assumptions.tex` A2c (m.1)–(m.2); `proofs.tex` Step 2 and the round-9 header |
| **2.3 (−3)** `rem:l21route`(d) prints a false $H^{2}$-norm identity | **ACCEPTED.** The identity is now the labelled `eq:h2norm`, with the factor $2$, plus one sentence deriving it from $(1+\xi^{2})^{2}=1+2\xi^{2}+\xi^{4}$ and one recording that **the set is right either way** (the two forms are equivalent, ratio in $[1,2]$) **and the norm was not**. Step 1$'$ now reads its two dominations against `eq:h2norm` explicitly, so the $\sqrt2<2$ comparison is visibly like for like. **No constant and no spec changes** | `results.tex` `rem:l21route`(d); `proofs.tex` Step 1$'$ |

**On 2.2, one implementation note, because the review's own prescription needs a correction.** The review
says to get the norm map "over $H^{\mu''}$–$H^{-\mu''}$ duality". That is the right *device*, and it is
what (m.2) runs — but **not through a negative-index space**, because `eq:usobolev` read at index
$-\mu''$ is $L^{2}(\IR,du)$ with a weaker norm and is **not complete**, so "the dual of $H^{-\mu''}$"
would be an object this file has not defined. (m.2) therefore sets the pairing up on the **transform
side**: the countable family is built by hand from bounded, compactly supported Hermitian functions, and
`eq:hdual` is Cauchy–Schwarz plus density in one weighted $L^{2}$. **No completion, no negative-index
space, and no appeal to a duality theorem.**

### D-000000000.2 The six MINORs

| Finding | Disposition |
|---|---|
| **2.4 (−3)** `lem:formstruct`(v) invokes (ii) at the raw sign sets | **ACCEPTED.** (v) now names $\mathcal X_\pm$, says in the open that **(ii) could not be applied there** and why, and passes to a near-supremum subset formed *inside* each sign set. **The ordering caveat is stated to be vacuous in that instance**, with the reason: no sign split is performed on a set that already carries one sign |
| **2.5 (−2)** `cor:elldiff`'s "defined pointwise" clause not verified | **ACCEPTED.** Step 5 now verifies it before applying the corollary: measurability of $t\mapsto\ell^\Pi_\star(u,t)$ at fixed $u$ from Step 2, domination by $(\sup_u\lvert\ell^\Pi_\star\rvert)\bar w$ from B1(ii)'s envelope, finiteness from `eq:l21budget`. One sentence says why it is printed: **the two budgets and the differentiability do not imply the pointwise definition** |
| **3.1 (−1)** L-21's B1-minimality claim, four sites | **ACCEPTED, and the corrected claim is slightly larger than the review's.** See §D-000000000.4 |
| **3.2 (−1)** `prp:sharpquad` inherits C2$'$(i) wholesale | **ACCEPTED.** The hypothesis line is now `lem:solset`'s, **cited by clause**, with C2$'$(i) scoped to clause (iv). **This required a proof change, not only a statement change:** Step 5 previously ran O-16(b)⟹O-16(a) through `lem:formstruct`(ii), which consumes C2$'$(i). It now runs through `eq:complower` and Step 2's numerical radius, which consume neither — the route the review verified in its Phase 3 adjudication. The (ii) route is kept in one sentence, with its price named |
| **4.1 (−1)** declined $g_\vartheta$ survives at `proofs.tex:2156` | **ACCEPTED**, occurrence fixed, third declined-slot row added — **and the row's limit recorded.** See §D-000000000.5 |
| **4.2 (−1)** "the sharp constant" names two quantities | **ACCEPTED.** `proofs.tex:1484` is scoped to "the form on the unit sphere of $L^{2}(\pi)$"; `:1533` now says explicitly that it is **a different quantity** and the one `prp:sharpquad` reports. The phrase was then swept: glossary §8.4 item 2 carried the same ambiguity and is scoped too |

### D-000000000.3 The two fold-ins

**SG-15's description is changed at both live sites**, `rem:sharpscope`(3) and accounting note 3 in
`proofs.tex`, in the review's sharper form and not the memo's earlier one. The earlier form said SG-15
minimises a lower bound. **The sharper statement is that the objective is not even monotone in the
quantity of interest:** the compact part is *unconstrained* by $\sigma_q$, so a selection lowering
$\lVert\vartheta'\sigma_q/\pi\rVert_\infty$ can *raise* $\lVert P_{\mathcal V}\mathcal B_{\rm sym}P_{\mathcal V}\vert_{\mathcal V}\rVert$,
and driving the sweep to zero makes `eq:complower` vacuous while leaving the sharp constant free.
**Design consequence, printed as one:** any claim that SG-15 improves the constant requires the
compression's norm computed directly, which `eq:bracket` brackets and does not deliver.

**The title tweak is taken.** `prp:sharpquad` is now *"The second-order remainder on the ball: the sharp
constant, and the exact $\delta^{2}$ order under O-16(a)"*. The unconditional "exactly of order
$\delta^{2}$" was blocked by the lead sentence and by `rem:sharpscope`, so this is redundancy and not a
repair — but the title is the one line a skimming referee reads, and O-16(a) is exactly the hypothesis
`rem:sharpscope`(4) says is asserted nowhere.

### D-000000000.4 Two things found in the fix pass that the review did not name

**(1) B1(iv.a) is consumed a *second* time in L-21, and not for $\sigma$-finiteness.** The review's 3.1
identifies finiteness of $\Pi_u,\Pi_t$ at Step 0. Rewriting Step 2 surfaced another: the claim that the
constructed function is a **version** needs $\Pi_u\ll\mathrm{Leb}$, since the two representatives agree
only Lebesgue-a.e. in $u$. That is B1(iv.a)'s absolute continuity, and it is substantive. **So the
corrected minimality statement is not the review's "B1(iv) enters at Step 0 for $\sigma$-finiteness and
nowhere else before Step 5" but the slightly larger "B1(iv) enters at Steps 0 *and 2*, and nowhere else
before Step 5"** — finiteness at Step 0 and at the close of Step 2, absolute continuity at Step 2. All
four sites carry the larger claim.

**(2) The A2c comment block put two different numbers on one symbol.** It read "`eq:embed` holds with
`c_2 = 2` by an elementary argument". $c_2$ is `eq:embedconst` at $\mu''=2$ and equals $\sqrt2$; the
elementary route's constant is $2$. Same species as MAJOR 2.3 — a correct statement written with the
wrong symbol — found by sweeping the block that MAJOR 2.3 pointed at. Corrected in place with the
strikethrough convention, and both corrections are listed there.

### D-000000000.5 §1.5b applied to the fix pass: four slots claimed, three rejected on sweep

Recorded in glossary **§1.5d** (new), with each sweep. Claimed: **$\ell^\Pi_0$** (C45), **$\mathcal T_\ast$**
(C46, promoted from an unrecorded round-9 use into A2c), **$\mathcal X_\pm$** (C47), **$\varkappa_k$**
(C48, a second local use of an existing local letter).

**Three candidates were swept and rejected, and each rejection is the rule paying for itself again.**
$\Phi_0$ for the countable family — **$\Phi$ is the RESERVED Bierens transform**. $\mathcal S(\IR)$ for
the Schwartz class — **calligraphic $\mathcal S$ is the selection functional** that C31 kept and that
glossary §4 puts under a forward contract; A2c (m.2) is written so that the Schwartz class is never
needed. $\mathcal J_{\mu''}$ for the weighted transform — **a third font of the RESERVED Jacobian $J$**,
the exact hazard C41 declined $\mathsf J$ for; it is written out instead.

**And the guard for C44's declined slot has a limit that is now written down.** A third declined-slot row
is added to `check_rendering_sync.py`, matching `g_vartheta`, `g_\vartheta` and `g_{\vartheta}`.
**But `sweep_retired()` strips LaTeX comments before matching, by design** — a line narrating a
retirement is not a use of it — **so the comment-only occurrence the review found would have been out of
CHECK 3's reach even with the row present.** The row guards the live slot; the §1.5b grep, which reads
comments, is the other half. Both facts are written into the script beside the row and into §1.5d,
because the alternative is rediscovering the gap in a later round.

### D-000000000.6 What this pass did NOT do

- **No Step 6.** `prp:phirate` is a parallel dispatch's, and (O4) is its opening task.
- **No new results, no new tags, no Part H.** A2c gains two justification clauses; its content is unchanged.
- **No spec changes.** `l21-embedding-constant-mu2` pins $c_2=\sqrt2$, which is right; the review
  confirmed it and MAJOR 2.3 touches only a printed definition.
- **Coordinator items untouched, as instructed:** N-13; `proof_strategy_memo.md` §2.5(i) and :521 (both
  write $\mathcal B_{\rm sym}$ for what is $\mathcal B$); §2.5(i)'s ball; §2.5(iii)'s necessity claim.
- **No renderings touched.** `prp:sharpquad`, `lem:formstruct`, `lem:reprsmooth` and A2c have no
  counterpart under `paper/sections/theorems/`, so CHECK 1 sees nothing new; the declared Part E lag is
  unchanged.

---

# Part II — Dispatch 2: N-10 and Step 3

## D-00000000. **Step 4** — `prp:sharpquad`, L-20, L-21; and N-20 struck

**Scope: new content.** Part G of `results.tex` and `proofs.tex`; one new tag, **A2c**, in
`assumptions.tex`; §1.5c and six rows in the glossary; five specs; two rows in the sync script; and the
strike of memo §10's Step-4 ordering instruction, executed per the coordinator's resolution (a).

### D-00000000.1 N-20 is closed, and the note the coordinator asked for is written where a reader meets it

**The strike is done**, at `proof_strategy_memo.md` §10 Step 4, with the replacement note printed
immediately below the table rather than as a footnote — because the table is what a Step-6 author reads.
The note says three things, in the coordinator's own terms and with the reasoning made checkable.

1. **Why the deferral was sound.** The struck instruction rested on the premise that *"L-21's primitives
   are what make A2′ statable"*, and **that premise is false as stated**: A2′(i.a)–(i.b) is a *stated
   assumption*, and L-21 derives it from a source condition rather than being needed to state it. Step 5's
   results carry A2′(i) — or, at a generic representer, A2b — as an **explicit hypothesis** at every one of
   `cor:elldiff`, `lem:solset`, `lem:secondord`, `prp:orthog`(ii)–(iii), `lem:balance`. Nothing was
   assumed silently.
2. **Why the concern nonetheless had content, stated plainly.** `eq:Wderiv`, `cor:elldiff` and the
   $\|\partial_u\ell_\star\|_\infty$ that `lem:secondord`(i) and `lem:solset`(iii) consume **all rest on
   A2′(i.b)**, and all closed before Step 4 ran. **L-21 now retroactively discharges what Step 5
   assumed.** That sentence is printed in three places — the §10 note, Part G's header, and
   `rem:obligations`(O1) — because the dependence direction is exactly what a reader should not have to
   reconstruct.
3. **What "discharged" means, spelled out rather than implied.** A2′(i) stays maintained. An assumption
   with a proved sufficient condition is still an assumption; what it loses is the status of an
   *unverifiable primitive*.

### D-00000000.2 L-20 — the target **is** stated, and where; three defects in how it is stated

**The coordinator could not locate L-20's target in memo §10 and asked me to say so if it is genuinely
unstated. It is not unstated — it is in the wrong place.** §10 is a *schedule*; it names targets and does
not state them. **L-20's target is stated in the lemma table, `proof_strategy_memo.md:521`.** So the
answer to the question as put is: look in the lemma table, not in §10.

Having found it, I record **three defects in it**, because Step 4 would otherwise inherit them.

| # | Defect in L-20's registered statement | What Part G does |
|---|---|---|
| **1** | It says *"$\mathcal B_{\rm sym}=m\cdot-2\tilde{\mathcal K}$"* — but $m\cdot-2\tilde{\mathcal K}$ is **$\mathcal B$**, not $\mathcal B_{\rm sym}$. The symmetrisation has $-(\tilde{\mathcal K}+\tilde{\mathcal K}^\ast)$. This is glossary C12's round-7 correction, which reached the glossary row and not the memo. | `lem:formstruct`(i) prints both decompositions, and V-2's rename makes them readable off the notation. |
| **2** | Its three "conditions round 2 asserted without stating" — *$q$ bounded; $qf_{X_1X_2}\in L^2$; $f_{X_t}/\pi$ bounded* — **are no longer conditions. All three are theorems**, proved inside `lem:solset`(iii) in round 7: $\|q\|_\infty\le\|\partial_u\ell_\star\|_\infty$ by (P1) and conditional Jensen; the Hilbert–Schmidt computation (F-3); and $\bar c_\pi<\infty$ by C1(ii), whose own comment already records that *"the memo's L-20 states it on the wrong object"*. | `lem:formstruct` **cites** them and does not re-derive them, which is the dispatch's inherit-verbatim instruction. |
| **3** | *"Weyl ⟹ $\sigma_{\rm ess}=\operatorname{ess\,ran}(m)$"* omits the two side conditions the implication needs: compactness of $\tilde{\mathcal K}$ (F-3) and **non-atomicity** of $\pi\,dx$ (m-1). On an atomic space the multiplier's value at an atom is an eigenvalue of *finite* multiplicity and need not lie in $\sigma_{\rm ess}$. | `lem:formstruct`(iii) carries both, citing `lem:solset`(iii) for each. |

**So L-20 as delivered is not a new derivation; it is a *collection***, and saying so is the honest
description. What it adds beyond `lem:solset`(iii) is (iii)'s transfer of the essential-spectrum identity
to the **compression**, (iv)'s **compactness dichotomy**, (v)'s **indefiniteness**, and (ii)'s **singular
sequence**, which is what carries all of them and what `prp:sharpquad`(iv) runs on.

### D-00000000.3 `prp:sharpquad` — stated at the sup-over-ball quantifier, and one correction to the registered display

**The quantifier is the whole result.** `eq:sharpconst` is an identity for
$\sup_{h\in\mathcal V,\|h\|\le\delta}$, hence about *the best bound valid uniformly on the ball*, and
`rem:sharpscope` blocks four readings, each with the true version alongside. The first is the one the
dispatch names: **it is not a claim about the estimator.** Nothing here excludes a regularisation path
confined to directions on which the form is small. What *is* true is that the direct bound is
order-sharp, so A5(ii) cannot be relaxed *by a better bound on the remainder* — relaxing it needs a
different moment or a restriction on the direction of the first-stage error, and those are different
claims.

**One correction, and it is to the registered display itself.** memo §10 and §2.5 register
$\sup_{\|h\|\le\delta}|Q(h)|=\tfrac12\delta^2\|\mathcal B_{\rm sym}\|$. **That identity is exact on the
ball of $L^2(\pi)$ and an *upper bound* on the ball of $\mathcal V$** — and $\mathcal V$ is the operative
one, since $h=\hat\varphi-\vdagger\in\mathcal V$ by `def:spaces`. The exact constant on $\mathcal V$ is
the **compression's** norm, which is precisely F-4's point and precisely what §8.4 item 3 says
`prp:sharpquad` must inherit rather than the raw $L^2(\pi)$ norm. `eq:bracket` brackets the two.
**No downstream consequence changes**, because what `thm:rootn` consumes is the lower bound — memo §6.5's
own fallback F2 says as much.

**The three things that must not slip are in the file, each at the site where a reader meets it.**
$\|\vartheta'\sigma_q/\pi\|_\infty$ appears only as `eq:bracket`'s **left**, lower, member and is called a
lower bound in the same sentence; $\mathcal B$'s non-self-adjointness is `lem:formstruct`(i) and puts
$\tfrac12\|\mathcal B\|$ at `eq:bracket`'s **right**, upper, end; and everything is stated at a fixed
$\vartheta$ with $\|\vartheta\|=1$, $\varsigma$ appearing nowhere in Part G.

### D-00000000.4 **O-16 is two hypotheses, not one, and they do different work** — a finding

The dispatch instructs that O-16 is $q\not\equiv0$ and is `prp:sharpquad`'s *hypothesis*. Both are
honoured. But **O-16 as registered conflates two conditions that are not equivalent**, and the difference
decides which conclusions survive. `prp:sharpquad` therefore states them separately:

- **O-16(a):** there is $h\in\mathcal V$ with $\vartheta'E[q(\Delta h)^2]\ne0$ — *the form does not vanish
  on $\mathcal V$*. This is what gives the **$\delta^2$ order** (clauses (i) and (iii)).
- **O-16(b):** $\vartheta'\sigma_q\not\equiv0$ — memo §2.5's "$M\not\equiv0$". This is what gives the
  **lower bound**, the **non-compactness**, and the **weak-norm refutation** (clauses (ii) and (iv)).

**(b) implies (a); the converse is false, and the counterexample is already in the paper.**
`lem:solset`(iii)'s witness — spec `solset-sigmaq-not-sufficient` — exhibits $q\not\equiv0$ with
$\sigma_q\equiv0$ and $E[q(\Delta h)^2]=2c\ne0$. **Two consequences the memo should carry.**

1. **Lever 1's target $\sigma_q\equiv0$ does not remove the $\delta^2$ order.** It removes the essential
   spectrum and the Douglas obstruction, which is what memo §3.5 observation 2 says — but the compact part
   survives and the form can still be nonzero, so the *order* is untouched. **SG-15 sweeps
   $\|\vartheta'\sigma_q/\pi\|_\infty$, which is a lower bound on the sharp constant, not the sharp
   constant**; minimising it minimises a lower bound. The target that removes the remainder outright is
   $q\equiv0$, or a cancellation in the symmetric part of $q f_{X_1,X_2}$ — which is **CP-12**.
2. **$q\not\equiv0$ alone is not sufficient for O-16(a) either**, and that is worth one line: if
   $qf_{X_1,X_2}$ is antisymmetric the form vanishes identically, since $(\Delta h)^2$ is symmetric. So
   the minimal hypothesis really is "the form does not vanish", and that is what (a) states.

**And O-16 is not inherited from O-11.** O-11 delivers $\partial_u\ell_\star\not\equiv0$ and stops; $q$
can vanish by cancellation inside the conditional expectation, and $\sigma_q$ by a second
marginalisation. **N-13 stays open and is not mine.** `prp:sharpquad` carries both O-16 clauses as
explicit hypotheses and asserts neither.

### D-00000000.5 L-21 — A2c, and why not the route the memo registers

**The target is A2′(i.a)–(i.b), in sup-inside form, on $\ell^\Pi_\star$, and never A2b.** A2b is a
predicate over generic representers, is never asserted, and therefore has nothing to discharge — which is
what round 9's Finding-4 split was for, and a Step-4 author can now read it off two hypothesis lines.

**The condition is A2c** (`ass:reprsource`), NOT MAINTAINED, on the **A1d model**: a primitive sufficient
condition with exactly one consumer. It puts the slices $\ell^\Pi_\star(\cdot,t)$ in $H^{\mu''}(\IR)$,
$\mu''>\tfrac32$, with the $\bar w$-weighted $\Pi_t$-budget $\Lambda^{(\mu'')}_\star<\infty$.

**Why the sup-inside form is *met* and not approximated.** A2c is stated **in the same
$\bar w$-weighted $L^1(\Pi_t)$ geometry as the clauses it implies**, so `eq:embed` is a *slicewise*
inequality and `eq:l21budget` is one integration of a pointwise bound. **No supremum is ever moved across
the $t$-integral**, so round 5's M-1 defect — $\sup_u\int\ne\int\sup_u$ — cannot recur. That was repair
(α), the dispatch-5 critic confirmed (α) is exactly what Leibniz consumes, and this is the form that
delivers it.

**The registered route is three steps short, and each gap is recorded rather than papered over.** The
memo's L-21 row proposes
$\ell_\star\in\mathcal R((\mathcal A_{\rm cond}\mathcal A^\ast_{\rm cond})^{\mu''})\hookrightarrow C^1$.

1. **Wrong referent.** It targets $\ell_\star$; round 5 moved A2′(i) onto $\ell^\Pi_\star$, and the bridge
   between them, `cor:elldiff`, *consumes* A2′(i) — so it cannot be used to reach it. The glossary's
   $\mu''$ row was **the last uncorrected instance** of that round-7 referent fix, and it is corrected in
   place. Found by sweeping the referent, not by a finding.
2. **No scale link on the range side, and this is the decisive one.** Membership in
   $\mathcal R((\mathcal A_{\rm cond}\mathcal A^\ast_{\rm cond})^{\mu''})$ says **nothing** about $\sup_u$
   or about $u$-differentiability unless that scale is *matched* to a $u$-smoothness scale. **H1 is
   exactly such a matching on the domain side; there is no analogue on the range side**, and supplying one
   would be a *second* Hilbert-scale link — an assumption about how the left singular functions
   $\tilde e_j$ oscillate in $u$, on an object the analyst does not choose. Strictly larger than A2c and
   buys nothing A2c does not. **Route stated and rejected**, because it is the first thing a reader will
   propose.
3. **No $t$-integration.** The row states the embedding and omits the $\Pi_t$-integral entirely, which is
   half of what (i.a) and (i.b) assert.

**What A2c costs beyond A2, stated rather than hidden.** $\ell^\Pi_\star\in L^2(\Pi)$ puts the slices in
$L^2(\Pi_u)=L^2(\varpi_u\,du)$; B1(iv.a) bounds $\varpi_u$ above and only *pointwise* below, so
$L^2(\IR,du)\subset L^2(\Pi_u)$ and **not conversely**. A2c therefore adds a **tail-decay** requirement in
$|u|$ on top of smoothness — the same species as C4′'s residual truncation, and the mirror of the
asymmetry already recorded at A2 for $\pi$. Two stronger sufficient forms (an $L^2(\Pi_t)$ form via
Cauchy–Schwarz and B1(iv.c); a uniform-in-$t$ form) are given, with A2c the weakest of the three.

**What remains an assumption.** A2c is a condition on $\ell^\Pi_\star$, determined jointly by the model
and the selection; L-21 does not derive it and does not claim to. What it buys: *one* condition on *one*
object, in the Hilbert-scale language H1 already uses, and **reportable** — by `eq:usobolev` it is a
weighted summability condition on the $u$-frequency content of the slices, the same kind of object as A2's
Picard sum. **(O1) is marked DISCHARGED in `rem:obligations`; three of four obligations remain open.**

### D-00000000.6 §1.5b applied to my own drafting: five slots claimed, **two declined**

The rule caught two things before they were written, one of them inside the chain `prp:sharpquad` runs on.

- **Italic $Q$ is DECLINED (C38).** The memo writes the remainder $Q(h)$. **The slot is occupied**:
  (P6b)'s regular conditional distributions $Q_1,Q_2,Q_{12}$ live at six sites in `proofs.tex`, and
  $Q_{12}$ is what supplies the **jointly measurable version of $q$** — the object $\sigma_q$ is built
  from. That is C32's and C34's exact species, inside the one chain Step 4 must reproduce. The remainder
  therefore carries **no symbol**: it is the form $\langle\mathcal Bh,h\rangle_{L^2(\pi)}$
  (`eq:quadrem`), which is better than a name because the sharp constant is then readable off the
  notation. Fifth application of the C12/C24/C31/C35 write-it-out precedent.
- **$g_\vartheta$ for the multiplier is DECLINED (C44)**, after drafting. $g$ is the generic *moment
  weight* and *fills the subscript slot* of $\nu_g,\sigma_g,\hat\nu_g$; and an abbreviation would
  re-collapse the very distinction §8.4 item 2 protects. All $\sim$15 sites write
  $\vartheta'\sigma_q/\pi$ out, which is what every pre-existing site does.
- **Claimed, each with its sweep recorded:** $H^{\mu''}(\IR)$ (C39, argument mandatory),
  $\Lambda^{(\mu'')}$ (C40, parenthesised-superscript family — so `eq:l21budget` reads as "the budget at
  order $\mu''$ dominates the budgets at orders 0 and 1"), $c_{\mu''}$ (C41 — and the integral inside it
  is **written out**, because the obvious name $\mathsf J$ sits one font from the RESERVED Jacobian $J$),
  $h_k$ (C42), $\mathcal B_{\mathcal V}$ (C43, local to one proof; every statement prints the compression
  in full).
- **One §1.7 rule is AMENDED in the open, not breached.** "A subscripted $h$ is always a bandwidth" now
  reads: a **variable-name** subscript is a bandwidth ($h_u,h_x$), an **integer** subscript is a member of
  a sequence of directions. Subscript-type separation is the device §1.7 already uses three times, and no
  file contains an integer-subscripted $h$.
- **Two rows added to `check_rendering_sync.py`**, and they differ in kind from every row above them: they
  guard slots **deliberately not claimed**, so a later author cannot claim italic $Q$ or reinstate
  $\|M/\pi\|$ from the memo's notation. A declined slot needs the same mechanical protection as a retired
  one, or the reasoning lives only in a glossary row nobody greps.
- **One stale string found by sweeping, not by a finding**, and it is the same species one level in:
  `assumptions.tex`'s A2b comment block said **"R1"** at three lines where it meant A2b — *the tag that
  block itself records as rejected because `rem:R1` occupies it*. Round 8's rename reached every statement
  and every citation and not the prose explaining the rename. Corrected in place.

### D-00000000.7 Citations: **none added**, and the reason is recorded

Three classical facts are consumed and **none is `\cite`d**: no spectral-theory or Sobolev-space entry
resolves in this project's bibliography, and `conway2000` — the only spectral reference ever pinned — was
**depinned in round 6**. Adding an unresolvable `\cite` breaks the build. Each fact is **proved inline**
at the strength the step needs, with the intended pin named in a comment so the bibliography pass has a
target: the one-dimensional Sobolev embedding (twice — general $\mu''$ by Fourier, and $\mu''=2$
elementarily, with the two constants $\sqrt2$ and $2$ **distinguished** rather than conflated); the
numerical-radius identity, **over the reals**, with the field flagged at both places it is used; and
essential-spectrum invariance.

**This retires a live gap rather than adding one.** `lem:solset`(iii) invokes *"Weyl's theorem"* **with no
citation**. Rather than propagate a second unpinned invocation, `lem:formstruct`(iii) proves the one
instance Step 4 consumes from the Weyl criterion in four lines, **and** supplies an independent route to
the same lower bound through the singular sequence, which uses no spectral theorem at all. The two routes
agree; the second is what makes the first checkable, and it is also the "constructive confirmation" memo
§3.5 asks for — with orthonormality in place of that memo's $\cos(kx)$, which is shorter and needs no
smoothness of the multiplier.

### D-00000000.7b One defect caught in my own drafting, recorded because the wrong route is the reconstructible one

**L-21 Step 2's first draft got joint measurability of the chosen version by applying Fubini twice to the
Fourier inversion integral. That is not available.** On $L^2(\IR,du)$ the transform $\mathcal F$ is
defined as an **$L^2$-limit** of truncated integrals, not as an integral, so joint measurability of
$(\xi,t)\mapsto(\mathcal F\ell^\Pi_\star(\cdot,t))(\xi)$ is *not* a Fubini statement; recovering it would
need an a.e.-convergent subsequence that may depend on $t$. **The repair uses no transform at all**:
mollify, use that every point is a Lebesgue point of a continuous function, then take difference
quotients — two pointwise limits of jointly measurable functions. Shorter, and it does not borrow from
the Fourier apparatus that A2c introduces for a different purpose.

**Recorded rather than silently fixed, for the reason F-21 was:** the defective route is the one a reader
will reconstruct, and the proof now says in one sentence why it is not taken. This is the same species as
F-21 — a first draft that assumed a boundedness-below that B1(iv.a) does not supply — and the same
species as the round-8 sweep failures: the error was in the step nobody would think to check.

**And a second, in L-20(ii)'s set construction, caught on the same pass.** The first draft built
$\mathcal X_0$ by *fixing a one-signed set and then intersecting it with
$\{|\vartheta'\sigma_q/\pi|>\|\vartheta'\sigma_q/\pi\|_\infty-\varepsilon\}$*. **That intersection can be
empty** — the essential supremum may be approached only where the multiplier has the *other* sign, which
is precisely the configuration L-20(v)'s indefiniteness makes generic. **The order of the two operations
matters and the proof now says so**: take the near-supremum set *first*, split it by sign *second*, and at
least one half has positive measure. The bound then reads $\mathsf c_0\ge\|\cdot\|_\infty-\varepsilon$
rather than equality, so the lower bound arrives as $\|\cdot\|_\infty-2\varepsilon$ and
$\varepsilon\downarrow0$ closes it — unchanged in substance, corrected in the step. Both dependent sites,
`lem:formstruct`(iii) and `prp:sharpquad` Step 6, are corrected with it.

### D-00000000.8 Specs written (five), and what each is aimed at

I do not run them. Each header states what the spec checks, what a mismatch would mean, and the predicted
outcome.

| Spec | Claim | Predicted |
|---|---|---|
| `sharpquad-antisym-form-vanishes` | $\langle Ah,h\rangle=0$ for antisymmetric $A$ — `prp:sharpquad` Step 1, which is what makes the sharp constant $\mathcal B_{\rm sym}$'s and $\tfrac12\|\mathcal B\|$ an upper bound. $3\times3$, because $2\times2$ antisymmetrics are one-dimensional and could pass for a dimension-specific reason | MATCH |
| `sharpquad-polarisation` | the polarisation identity carrying Step 2, **false without symmetry** — the header says where the symmetry enters | MATCH |
| `sharpquad-symnorm-strictly-below` | a witness that $\|\mathcal B_{\rm sym}\|<\|\mathcal B\|$ **can be strict**, at $B=[[1,2],[0,1]]$: $\|B_{\rm sym}\|=2$, $\|B\|=1+\sqrt2$. The inequality needs no spec; the **strictness** does, or printing $\tfrac12\|\mathcal B\|$ would be harmless | MATCH (needs sqrt denesting; the fallback is stated) |
| `l21-embedding-constant-mu2` | $c_2^2=2$, i.e. $c_2=\sqrt2$ — pins the $2/\pi$ normalisation of `eq:embedconst` against the Fourier convention of `eq:usobolev`, **and separates $c_2=\sqrt2$ from Step 1′'s weaker $2$** | MATCH |
| `l21-threshold-binding` | $\mu''>\tfrac32$ is **binding**: the integral diverges at $\tfrac32$. Uses the reciprocal device of §D-000000.5, with that section's caveat paragraph reproduced so the vacuous-looking report cannot be misquoted | MATCH |

### D-00000000.9 What is deliberately not done

- **No Part F renderings, and no resync.** Per the dispatch. The Part E lag is declared, the script
  measures it, and 21 blocking findings is the known round-7 lag, not a regression. A resync belongs with
  Part E/F generation. **Part G is not rendered either**, for the same reason.
- **N-13 is not touched.** The memo's "$Q(h)\ne0$ necessarily" is the coordinator's to amend.
  `prp:sharpquad` does not inherit it: O-16 is its hypothesis.
- **No clause of A2′ is weakened or removed.** Deleting (i) and keeping A2c would make A2c *maintained* —
  the trade `rem:obligations`'s own test forbids, and the A1c/A1d relation the block already declines to
  collapse.
- **No new maintained assumption**, and A5 gains nothing. (O2), (O3), (O4) remain open and are untouched.
- **The propensity frontier is unchanged** and is not restated: $\frac{2\mu}{2\mu+1}\cdot\frac{r}{2r+d_Z}>\frac14$,
  i.e. $r>\frac{d_Z(2\mu+1)}{2(2\mu-1)}$ with $\mu>\tfrac12$ necessary. $\mu''$ competes for no part of
  the $s$ budget and the budget table now says so.
- **Two housekeeping items are still open and still not mine**: the stray extensionless
  `scripts/symbolic/specs/frontier-table`, and the memo's stale spec counts. Flagged for a fourth time.

---

## D-0000000. Round-8 **consolidated fix round** — against `notation-table_round8.md` (0/100, raw −119) and `usage-matrix_round8.md` (7/100, raw −93)

**Scope: fixes only.** No Step 4, no Part F renderings, no new results. Nineteen findings across two
narrow lanes; **all nineteen are accepted**, none is contested, and the reason is stated below for the
one I expected to contest. Four Step-4 blockers are closed, eight assumption findings are closed, eight
notation findings are closed, and one artifact — the hand-kept exception list — is **abolished rather
than corrected for a third time**.

### D-0000000.0 The organising instruction, and what happened when I applied it to myself

The warden's structural observation is the spine of this round:

> Five of the seven collisions share one shape: a round-7 resolution **claimed a slot** — italic $D$, the
> letter $M$, calligraphic $\mathcal S$, the constant $a$, the letter $B$ — and the slot was already
> occupied. Each resolution reasoned carefully about the symbols it *renamed* and did not sweep for the
> letter it *claimed*.

**Accepted without qualification.** It is my own C25 method (glossary `:70`: "found by sweeping the file
rather than by the finding") run in the direction I had not run it, and it is now written into the
glossary at §1.5b as a binding rule. The auditor found the same failure from the other lane — A1b(i)'s
round-7 narrowing made in the block and never propagated to the four proof sites citing the half it
narrowed away — which is the N1 defect species, same round, adjacent tag.

**Applying the rule to my own fixes caught one before it was made.** The auditor's prescription for
Finding 4 was "the N1′ treatment", and my first choice of tag was **R1**. The sweep returned
`results.tex:270`: `\begin{remark}[R1]\label{rem:R1}` — **R1 already names a result** (as do L-16, R2,
O-11). Claiming it would have reproduced, *inside the fix for Finding 4*, exactly the defect the warden's
observation describes. The tag is **A2b**: letter-suffixed A-family tags are the project's existing
device for a related-but-distinct condition (A1b, A1c, A1d); the string "A2b" occurs in no file; and it
is visually separable from A2′ in a way "N2" would not have been from the memo's escalation items N-2,
N-7, N-10, N-18. Recorded in `assumptions.tex` at the tag and in glossary §1.5b.

**Five further sites were found by sweeping rather than by the findings.** All are the same species as
the finding that led to them, and none was named by either critic:

| # | Site | Species | How found |
|---|---|---|---|
| 1 | `results.tex:891` — `prp:nophifree`'s **hypothesis line** carried A1b(i) | Finding 1 | The auditor named only the roadmap sentence at `proofs.tex:1010`. Swept the proposition. |
| 2 | `results.tex:1022` — `rem:ffcompare`: "which A1b(i) sets to zero" | Finding 1 | A **fifth** A1b(i) site, outside the auditor's list of four. Swept the string. |
| 3 | `lem-adjoint.tex` `lem:nusigma`(ii), statement **and** proof — the same A1b(i) citation, **live in the compiled 26-page document** | Finding 1 | Swept the renderings, not just the source of record. |
| 4 | The memo's own "no consumer through Step 5" list carried **A4(iii)**, which `lem:secondord`(iv)'s instantiation consumes | Finding 9 | Finding 9 named H1 and A1. Swept the whole list. |
| 5 | The tag letter **R1** | Finding 4 | Swept the letter I was claiming, per §D-0000000.0. |

### D-0000000.1 TIER 1 — the four Step-4 blockers, all closed

| Finding | Disposition | Where |
|---|---|---|
| **V-2 ($M$)** | The multiplication operator becomes **$\mathcal B_{\mathrm{mult}}$** (`eq:Bmult`), joining $\mathcal B_{\mathrm{sym}}$ in the word-subscripted $\mathcal B$-family — **no new letter**, and it makes $\mathcal B=\mathcal B_{\rm mult}-2\vartheta'\tilde{\mathcal K}$, $\mathcal B_{\rm sym}=\mathcal B_{\rm mult}-\vartheta'(\tilde{\mathcal K}+\tilde{\mathcal K}^\ast)$ readable off the notation. The counterexample's scalar $M$ is **removed**: the bump height is set to $1$, both sides of `eq:crossshift` being homogeneous of degree one in $D$ | `proofs.tex` `lem:solset`(iii) lower-bound chain; `lem:secondord` Step 4; glossary C32 |
| **V-3 ($\vartheta$)** | $\vartheta\to\Xi$ at all four sites in `lem-adjoint.tex`, statement and proof. **The list is not the fix** — see §D-0000000.4 | `paper/sections/theorems/lem-adjoint.tex` |
| **V-4 ($\mathcal S$)** | The **selection functional keeps $\mathcal S$**; the spline span is **written out** as $\operatorname{span}(b_1,\dots,b_{L_x})$ at all seven sites. Both branches of §1's governing rule agree: the span has more sites *and* no contract, while $\mathcal S$ is what SG-15 sweeps. Writing it out is already the majority convention — `lem:balance`'s statement and Step 4's opening line print it in full | `proofs.tex` `eq:jackson` and Step 4; glossary C31 |
| **Finding 4 (A2′(i) dual status)** | The full N1 treatment, both halves. **(a)** A2′(i) gains an explicit **status sentence**: it is a maintained assertion about $\ell^\Pi_\star$ and about nothing else. **(b)** The generic-representer predicate gains its own tag, **A2b** (`ass:admrep`), NOT MAINTAINED. **(c)** `cor:elldiff` is **restated at a generic admissible representer** under A2b, with $\ell^\Pi_\star$ as the specialisation, and its proof is rewritten in the unstarred symbols — not annotated as "reads verbatim". **(d)** All four generic sites now cite A2b | `assumptions.tex` A2′, A2b; `results.tex` `cor:elldiff`, `def:weight`(a), `eq:PsiL`; `proofs.tex` `lem:solset`(ii), `prp:orthog`(i) |

**On (c), and why it is the right shape rather than a relabelling.** The proof of `cor:elldiff` never used
that $\ell^\Pi_\star$ *solves* the adjoint equation — only the two budgets and the differentiability,
which is exactly A2b. So the generic statement is **strictly stronger on strictly weaker hypotheses**,
the same move `prp:orthog`(i) received in round 7. The consequence the auditor asked for follows
mechanically: **L-21 discharges A2′(i) at $\ell^\Pi_\star$ and never A2b**, because A2b is never
asserted. A Step-4 author can now read that off the two hypothesis lines.

**Ordering note, which forced one design choice.** A2b is stated in `assumptions.tex` and not by forward
reference to `def:weight`(a), because `cor:elldiff` precedes `def:weight` in `results.tex` and may not
cite it. `def:weight`(a) now *defines the phrase* "admissible representer" to mean A2b — a naming
convention, not a second statement of the condition.

### D-0000000.2 TIER 2 — the eight assumption findings

| # | Disposition |
|---|---|
| **1** (−30) | A1b(i) **struck** from `lem:levels`, `prp:nophifree`, `cor:a1cprim`; **redirected to `def:spaces`** at `lem:nusigma`(ii) (source and rendering), at `prp:nophifree`'s roadmap, at `cor:a1cprim`'s proof, and at `rem:ffcompare`. A1b(i) itself gains a **Mode sentence**, binding on every citation: it is consumed for *well-posedness*, never for a bound, and its four genuine consumers are named in the clause. **The auditor's Mode column is adopted in the memo's live usage table** — it is what separates the genuine consumers from the idle ones, and it is what cleared `cor:udep`, whose clause (a) is "first-order insensitive **at $\vdagger$**" |
| **2** (−15) | A5(iv) **restated**. It prices $\|\hat\ell-\ell_\star\|_{L^2(P)}$ and nothing else. The first equality of the round-7 display is printed as **an assertion, not notation**, conditional on $\hat L=L^{\hat b}_{\hat\ell}$ per `def:weight`(b) — obligation (O3), owed and undischarged. Glossary rows for **$\hat L$ and $\hat\ell$** added (there were none); `lem:balance` now says in its own statement that its $\hat\ell$ is a **free estimator, not a derivative**. Both consumers separated by which form each uses |
| **3** (−10) | A1 **split onto `prp:orthog`(ii)**, following the `lem:shiftinv` precedent, with the reason printed. Verified: A1 appears in the proof at `proofs.tex:1791, 1799`, both inside part (ii). `lem:balance`, which inherits "the hypotheses of `prp:orthog`(i)", loses the surplus |
| **5** (−10) | `lem:secondord`(iv)'s $\mathsf r$-bound **re-denominated** in $\|\mathsf r\|_{L^2(P)}$ as `eq:rprodbound`, by the auditor's own Cauchy–Schwarz route, with the sup-norm form kept as a stated weakening — the exact shape `eq:prodbound` already had. The instantiation tag is corrected from A5(iv) to **A4(iii)**. It is a **strengthening at no cost**: $\mathsf r$ is bounded by `def:dirclass`(a), so $\|\mathsf r\|_{L^2(P)}\le\|\mathsf r\|_\infty$ |
| **6** (−5) | `rem:dirmember`'s provenance sentence rewritten in both directions. It no longer imports `lem:secondord`'s block — in particular not the direction-pair hypothesis, which is what `eq:dirmember` exists to supply — and the exhaustive list now includes **B1(i), (ii), (iv.a)** |
| **7** (−5) | A5(iv)'s scope note **scoped to the $D$-direction of clause (iv)**. The round-7 block-wide claim is quoted and refuted in place, against the file's own italics at `proofs.tex` ("Nothing in the assumption block prices $\|D\|_{0,h}$ or $\|D\|_{1,h}$") |
| **8** (−5) | "A2′" **cited by clause** at all four Part F results: A2, A2′(i), A2′(iii). Matches the round-7 C1→C1(ii) and B1(iv)→B1(iv.a) narrowings, and the reason is printed at each site |
| **9** (−3) | **H1** removed from the "no consumer" list, with `rem:adjointreconcile`(iii) named as its consumer and the Step-4 consequence spelled out. The A1 row was already right; the artifact now follows it. **And a second stale entry, found by sweeping the list rather than the finding: A4(iii)**, consumed by `lem:secondord`(iv)'s instantiation |

**The forward-obligation paragraph — the auditor's recommended fix, executed as a numbered remark.**
`rem:obligations` (new, immediately after `rem:dirmember`) inventories the obligations in one place, with
their present homes and their discharge sites, and states the **test** the auditor gave: *a forward
obligation is a verification and not an assumption so long as no stated result's truth depends on it;
the moment a stated assumption cannot be written down without it, it has already become an assumption.*
A5(iv) failed that test and is repaired. **The auditor's endorsement of the no-new-A5-clause decision is
recorded, and no new maintained assumption is created for any obligation.** There are **four**, not
three: (O1) A2′(i.b)/L-21; (O2) N1′ at the estimated direction; (O3) `def:weight`(b) membership of
$\hat L$; **(O4)** the construction of $\hat{\mathcal A}_\varphi$ — new in round 8, from warden V-8, and
of exactly the same species.

### D-0000000.3 TIER 3 — the eight notation findings

| # | Disposition |
|---|---|
| **V-1 ($D$)** | The direction **keeps italic $D$**; the degenerate region becomes **$\mathcal Z_0$** (`eq:degenreg`), calligraphic per the set convention, in `proofs.tex` and in `lem-bierens.tex`. §8.6's reasoning is corrected: it swept $\mathcal D$ and $\mathbf D$ — the symbols it was renaming around — and contemplated only a *future* clash with $\mathbf D$; the clash was present, inside the italic slot, from Part C |
| **V-5 ($\mathcal B$)** | **Closed, not deferred a third time.** $\mathcal B\to\Upsilon$ throughout `cor:rangegap` (statement and all three proof steps) and $\mathcal B(\cdot)\to\mathfrak B(\cdot)$ at both Borel sites in `lem-adjoint.tex`. These are items 5 and 6 of the abolished list; performing them costs nothing and removes a live INV-7 breach from a compiled 26-page document |
| **V-6 ($a$)** | $\Phi(\pm1)=\pm a$ **written out** as $\pm\Phi(1)$, and $\cos(ta)\to\cos(t\,\Phi(1))$, in `results.tex`, `lem-bierens.tex` and `assumptions.tex`'s B1(ii) comment. Writing it out beats moving it to $\mathsf c$ because $\Phi(1)$ *names the object* and makes the oddness step transparent; it also removes the juxtaposition of the RESERVED index $t$ with $a$ |
| **V-7 ($A,B,C,F$)** | **The counter-argument is weighed and does not survive one fact.** The warden self-flagged this as its most arguable finding and wrote the reply for me — "it is scratch notation, $A$ and $F$ appear once". What defeats that is not the label or the two cross-references: it is that **two declarations of $A$ and two of $C$ sit inside a single proof**, across steps that cite one another, and §1.6 scopes a local symbol by "the display or proof in which it appears". The coefficients become $\Psi_{00},\Psi_{10},\Psi_{01},\Psi_{11}$ — no new letter, and the double subscript *carries the content the letters did not*, since $\Psi_{jk}$ is the coefficient of $\tau_2^j\tau_3^k$ and bi-affineness becomes readable off the notation. Separation from $\Psi_L$ is by subscript **type**, the device §1.7 already documents twice |
| **V-8 ($\hat{\mathcal A}$)** | **`def:hatA` added**, and the finding's real point is taken: the hat convention is insufficient *because* $\mathcal A_\varphi$ is a Fréchet derivative, so "sample analogue" is ambiguous, and C3's bandwidth implies one of the two readings. The definition **fixes that reading** — a kernel-smoothed sample analogue, explicitly *not* the Fréchet derivative of $\hat T$ — says why A6's content depends on the choice, and records the construction as obligation (O4). A6 and C3 now cite it |
| **V-9 ($\bar\tau$)** | Closed by **monotonicity**, not by a third subscript on a glyph that already carries two indices. `def:dirclass` now prints that both seminorms are nondecreasing in $\bar\tau$; `rem:dirmember` prints the false inference explicitly and blocks it — *"read naively one would send $\bar\tau\downarrow0$ and conclude a $\bar\tau$-free bound; that inference is false, because the left side grows too."* The glossary's "$\bar\tau$ is fixed once in `def:dirclass`" row is corrected: it is re-fixed in `lem:secondord` and quantified over in `rem:dirmember` |
| **V-10** (italic sets) | Two of three moved: the degenerate region (V-1) and the event $A$, which is **written out** as $\{\Delta h=-1\}$ in both counterexamples — it *was* that set, so naming it bought a letter and lost the definition. **The third, $Z_t$, is deliberately not moved**: the warden itself placed it in "considered and declined" as declared-in-place and dying within its step, and the `rem:ffcompare` occurrences sit inside an explicitly declared verbatim-foreign-notation block, which the warden calls "the right way to do it" |
| **V-11** (`\mathrm`/`\operatorname`) | Rule stated and applied: **`\operatorname` for an operator name taking an argument; `\mathrm` for a word subscript.** `supp` and `sign` move to `\operatorname`, joining `span` and `ess ran`; $\sigma_{\mathrm{ess}}$, $\mathcal A_{\mathrm{cond}}$, $\mathcal B_{\mathrm{sym}}$, $\mathcal B_{\mathrm{mult}}$, $\eta_{\mathrm{TCC}}$, $\tau_{\mathrm{DP}}$ stay in `\mathrm` — they are subscripts, not operators |

### D-0000000.4 The hand-kept exception list is abolished, and that is the structural fix

The warden's V-3 makes a point larger than the four $\vartheta$ sites: `lem-adjoint.tex:52–58` warns **in
its own voice** that "a hand-kept list of exceptions is the SAME failure mode as a hand-kept header, one
remove further out — it failed in exactly that way in round 7: the list said FIVE and omitted a sixth."
**It then said six and omitted a seventh.** A third iteration of the same list is not a fix.

**What replaced it:** `scripts/render-sync/check_rendering_sync.py`. Four checks — statement drift per
`\label` key against `results.tex` (blocking); proof drift (advisory, because renderings may abbreviate);
a **retired-symbol sweep** driven by a declared table with one row per glossary rename (blocking); and
label coverage, which is what caught the round-7 header saying NINE and listing eight. It reports; it
never edits. **The retired-symbol table is now the last step of any rename**, which is what makes the
sweep mechanical rather than remembered — including the sweep for the letter being *claimed*.

The header no longer enumerates. It names what round 8 closed *by doing it*, points at the script, and
says explicitly that what remains unsynced "is not enumerated here, on purpose".

### D-0000000.5 What is deliberately not done

- **Step 4 is not written.** Per the dispatch. The four blockers are closed so that it can be.
- **Part F is not rendered.** Per the dispatch.
- **The Part E rendering still lags `proofs.tex`** on three round-7 proof refinements and on
  `cor:elldiff`'s round-8 restatement. Not hand-patched — that is the failure mode being retired. The
  script is the mechanism, and a resync belongs with the Part E/F generation after Step 4.
- **(O4) is recorded, not discharged.** `def:hatA` fixes the reading and names the construction; Step 6
  must exhibit the operator and verify A6 and A7 for it.
- **$Z_t$ as a zero set is left alone**, for the warden's own stated reason.

### D-0000000.6 Nothing contested

Both critics met the witness standard this session, and I have no witness against any of the nineteen
findings. The one I expected to contest — V-7, which the warden self-flagged and argued against itself —
survives on a fact the counter-argument does not reach: two declarations of $A$ and two of $C$ inside one
proof, which the local-symbol doctrine does not cover. **What the critics declined to charge is not
over-repaired:** T1-2 ($\psi$) and T1-6 ($\ell_\dagger$) stand as refuted and are untouched; no
forward-referenced unused assumption is given a new clause; A2′(ii), A1c, A3, A6, A7, C1(i), C2′(ii), C3,
C4′, C5′, A5(i)/(iii)/(v), B1(vi), A1d keep their forward-reference notes and nothing more.

---

## D-000000. Round-7 **postfix pass** — targeted fixes against `proofs_review_dispatch4.md` (66/100, strike 1 of 3)

**Scope was the nine findings and nothing else.** No new results, no Step 4, no Part F renderings. Four
MAJORs, five MINORs, one advisory. Every fix is local; none touches a proof's logic, because none of the
findings alleged a broken proof — the critic said so and I agree after re-reading each site.

**One finding's *remedy* is wrong and I say so with a witness (§D-000000.5). The finding itself is
right.** Everything else is accepted as stated.

### D-000000.1 The four MAJORs

| # | Finding | What changed | Where |
|---|---|---|---|
| **2.1** (−7) | `lem:secondord`(iv) denominated in a norm nothing prices; direction-class membership at $\hat L-L_\star$ asserted, never established | (iv) now prints `eq:prodbound`, whose **first** inequality is in $\|\partial_uD\|_{L^2(P)}$ — the norm the proof delivers and A5(iv) prices — with $\|D\|_{1,h}$ demoted to a *stated weakening*. New `rem:dirmember` carries the forward obligation **and discharges it** under one property of the estimator | `results.tex` `lem:secondord`(iv), `rem:dirmember`, `eq:dirmember`; `proofs.tex` Step 5; `assumptions.tex` A5(iv) note |
| **4.2** (−6) | The one $\psi$ violation I certified is live in the compiled paper | $\psi\to\mathsf L_\Gamma$ at all eight sites in `lem-bierens.tex` (`\psi` now returns **zero** matches in that file), with a round-7 sync header. The stale `proofs_review.md (56/100)` citation is corrected in the same header: the file was split into `_dispatch1.md` and `_dispatch2.md` and no file of that name exists | `paper/sections/theorems/lem-bierens.tex` |
| **3.1** (−5) | `prp:orthog`(i) defines $\Psi_L$ by reference to a lemma whose hypothesis list it disclaims | `eq:PsiL` defines $\Psi_L(\tau_1):=E[\psi(\theta_\dagger,(\vdagger+\tau_1h,L,\varrho))]$ **in place**, finite on all of $\IR$ | `results.tex` `prp:orthog`(i); `proofs.tex` Part (i) |
| **4.1** (−5) | Binding glossary `:170` still names $\varsigma$ as the Step-4 direction — **gates Step 4** | Corrected in place to $\vartheta'\psi$, $\|\vartheta\|=1$, matching §8.4 item 2 verbatim. **$\psi$ is the right letter there and is not changed** | `notation_glossary.md` $\sigma_q$ row |

**On 2.1 — forward note, not a new A5 clause, and here is why.** The dispatch asked me to state which and
why. Three reasons, all in `rem:dirmember` and repeated at A5(iv):

1. **Every clause of A5 prices a rate in $n$.** $\|D\|_{0,h}$ and $\|D\|_{1,h}$ are qualitative
   finiteness statements. An $O_P$ statement about them prices the wrong *kind* of object.
2. **Both seminorms are indexed by the random $h=\hat\varphi-\vdagger$.** A clean clause would have to
   quantify over a deterministic class containing $h$ w.p.a.1 — the ball $\mathcal V_n$ of L-19 — which
   Step 6 constructs and which does not exist in the block yet. Writing the assumption now would price a
   hypothesis in terms of an object that has not been built.
3. **It is implied, not assumed.** This is the substantive point, and it is why the note is short.
   `eq:dirmember` shows that if $\hat L=L^{\hat b}_{\hat\ell}$ is an admissible weight (`def:weight`(b))
   generated by an $\hat\ell$ bounded and continuous in $u$, then
   $\|D\|_{1,h}\le\|\hat\ell-\ell_\star\|_\infty$ and
   $\|D\|^2_{0,h}\le 2E\|\hat b-b_\star\|^2+4\|\hat\ell-\ell_\star\|_\infty^2\{E[\Delta U^2]+4\bar\tau^2\bar c_\pi\|h\|^2\}$,
   **for every $h\in\mathcal V$ and every $\bar\tau$, per realisation, with no uniformity in $n$.**
   Assuming an implied condition is exactly the addition this round removed eight times elsewhere.

**So what Step 6/7 owes is a verification, not a hypothesis:** that its $\hat L$ is an admissible weight
generated by a bounded, $u$-continuous $\hat\ell$. That is the third forward obligation of its kind,
alongside A2′(i.b)/L-21 and N1′, and — unlike those two — it comes with the discharge already written.

**On 3.1 — the in-place definition is *weaker* than the import it replaces**, which is why it is the right
fix rather than a cosmetic one. `eq:PsiL` needs no radius $\bar\tau$ (it is finite on all of $\IR$), no
direction pair $(D,\mathsf r)$, and no clause of A2′. The agreement
$\Psi_{L_\star}(\tau_1)=\Psi(\tau_1,0,0)$ is stated so nothing downstream has to guess. A comment block
records: **do not re-import** — the moment the definition is routed back through `lem:secondord`, part (i)
silently reacquires A2′ and the whole hypothesis reduction is lost.

### D-000000.2 The five MINORs and the advisory

| # | Finding | What changed |
|---|---|---|
| **3.2** (−3) | "affine in $(\tau_2,\tau_3)$ jointly" is false as written | Corrected at **four** sites, not the two named: `proofs.tex` proof-opening line, Step 1, Step 3, and `results.tex` `rem:supinside`. New `eq:biaffine` prints the actual form $A+\tau_2B+\tau_3C+\tau_2\tau_3F$ — degree $\le1$ in each of $\tau_2,\tau_3$ *separately*, with one bilinear term. Step 3's conclusion is re-derived from the two one-variable statements, which are the ones it actually consumes |
| **3.3** (−2) | Mixed-partial order / Hessian symmetry unstated | (iv) now names the order ($\tau_2$ or $\tau_3$ first, then $\tau_1$) and Step 5 **verifies the reverse order by direct computation**, with the envelope for $\partial_u(L_\star+\tau_2D)$ at $\tau_2\ne0$ and the term-by-term integrability the split needs. Symmetry is a computed fact here; **no Clairaut–Schwarz hypothesis is invoked anywhere** |
| **4.3** (−2) | `lem-adjoint.tex` deferral list omits the Borel rename | Item 6 added. And the critic's framing is taken seriously: the list is now declared **not authoritative** — the authoritative unsynced set is a mechanical diff — and **sites are named by content, not by line number**, because a line number in a header is invalidated by the next edit *to the header* |
| **4.4** (−2) | Glossary C15 stale against C24 | Corrected in place with strikethrough, same treatment C12 received |
| **4.5** (−2) | `secondord-shift-nonintegrable`: name over-promises content | Spec rewritten to evaluate the divergence its name asserts. **The finding's proposed remedy does not work; see §D-000000.5** |
| **3.4** (adv.) | A1b(i) listed on `lem:secondord` with no citing step | **Named, not cut.** A1b(i) is $\vdagger\in\mathcal V$; with $h\in\mathcal V$ and $\mathcal V$ a linear space it is what keeps $\vdagger+\tau_1h$ inside the parameter space, hence what makes $\partial_{\tau_1}\Psi(0)$ a Gateaux derivative *within* $\mathcal V$ — which is what makes "vanishes for every $h\in\mathcal V$" the right quantifier in `prp:orthog`(i). Now cited at Step 1 |

### D-000000.3 One site the findings did not name, fixed under 4.1

**Glossary C18 (`:70`) carries the same string as the $\sigma_q$ row** — "`prp:sharpquad` is stated
either coordinatewise or for a fixed direction $\varsigma'\psi$, $\varsigma\in\IR^p$." The finding named
only `:170`. Leaving `:70` would have been the stale-row species charged at 4.4, in the same file, on the
same symbol, in the same round. Corrected in place with the same strikethrough note.

**And a third copy, in this memo's own dispatch-2 findings table (F-15, §D3),** which says "**Binding on
Step 4:** … `prp:sharpquad` must be stated for a fixed direction $\varsigma'\psi$." That one is phrased
in the binding voice, in a document a Step-4 author reads. Corrected in place. **All three found by
sweeping for the string rather than by the finding** — which is the argument for sweeping.

### D-000000.4 `rem:shiftclass` — the sharper reason, folded in

The dispatch is right that my density-ratio rejection had the weaker reason. The remark now says: the
shifted law assigns mass $P(A)=\tfrac12$ to $\{u>1\}$, a **null set of the true law**, so
$P_{(\Delta U-\Delta h,\Delta Z)}\not\ll P_{(\Delta U,\Delta Z)}$ and **no Radon–Nikodym derivative
exists at all**. The rejected condition is therefore not a stronger assumption one might pay for — in
this design *it cannot be stated*. That is strictly better than "the ratio is unbounded", and it is worth
one clause because it closes the obvious reader's question ("could you not just assume the ratio is
bounded?") rather than deferring it.

### D-000000.5 Where the finding's remedy is wrong, with the witness

**Finding 4.5 is right that the `claim_id` over-promised, and right that my stated rationale was false.**
`integrate(1/u, (u, 0, 1))` under `positive=True` returns `oo` and produces no `Piecewise`, so the
indefinite-integral form was avoiding a hazard that did not exist. That part I accept without
qualification, and the old rationale is struck in place in §D-00000.6.

**But the remedy it offered — `start: integrate(1/u,(u,0,1))`, `claimed_end: oo` — is not available under
this harness, and it would report MISMATCH on a true claim.** `scripts/symbolic/verify.py` compares by

```python
difference = end_actual - end_claimed
is_zero, residual = reduce_to_zero(difference)
```

With both sides `oo`, the difference is `oo - oo = S.NaN`. `is_zero(nan)` is `False` — `nan == 0` is
`False` and `nan.equals(0)` does not return `True` — so the harness prints MISMATCH. **A spec whose
failure mode is indistinguishable from a real defect is exactly the thing MAJ-2 was about**, one level
down: there it was a passing spec aimed at the wrong claim; here it would be a failing spec aimed at the
right one.

**The form used instead.** Let $I:=\int_0^1u^{-1}du\in[0,+\infty]$, well defined because the integrand is
positive. Then $1/I=0\iff I=+\infty$, since a finite $I>0$ has a strictly positive reciprocal and $I>0$
because the integrand is strictly positive on a set of positive measure. So the spec checks
`1/integrate(1/u,(u,0,1)) == 0`: branch-free, equivalent to non-integrability, and landing on a **finite**
comparison target the harness's subtraction can reduce to zero. The `claim_id` is unchanged and now
matches what is evaluated.

**One cost, stated in the spec header so it cannot be misquoted.** `verify.py` evaluates `start` at parse
time, so the printed report reads `Start: 0 / Claimed end: 0 / MATCH`. That looks vacuous and is not —
the substantive step is that SymPy reduced $1/\int_0^1u^{-1}du$ **to** $0$, which it does only by
evaluating the integral to $+\infty$. There is no form under this harness that both certifies the
divergence and prints an uncollapsed left-hand side, because parse-time evaluation *is* the assertion.
The header says this in advance and says that anyone quoting the spec should quote that paragraph with
it. **The remaining human step is now one, not two:** the change of variables giving
$E|\mathsf r D(\Delta U-\tau_1\Delta h)|=\tfrac12 I$.

### D-000000.6 What this pass did NOT do

- **Step 4 remains unwritten.** `prp:sharpquad`, L-20, L-21 untouched, as instructed. The one thing that
  gated it — the $\varsigma$ string at `notation_glossary.md:170` — is fixed, at `:70` as well.
- **Part F renderings not generated.** Only `lem-bierens.tex` (one symbol) and `lem-adjoint.tex` (one
  header item) were touched, both because a finding named them.
- **No assumption was added or removed.** A5 gains a comment, not a clause.
- **`\un` and numbered remarks respected.** `rem:dirmember` is a numbered `remark` sharing the result
  counter; no `\un` is called with an argument.
- **Two housekeeping items from §D-00000.6 are still open and are not mine to close silently:** the stray
  extensionless `scripts/symbolic/specs/frontier-table`, and the memo's stale spec counts ("Ten",
  "Thirteen", "5") against an actual 62. Flagged again here rather than fixed, because both are outside
  the dispatch's stated scope.
- **`bierens1982` and `lavergne2008` remain repo-absent.** No proof edited in this pass cites either;
  `lem-bierens.tex` cites `bierens1990`, which now resolves. The moment a Step-4 proof cites the other
  two, the build breaks — recorded, not fixed.

---

## D-00000. Round-7 disposition — **fix-only** (regularity-checker 0/100, notation-warden 0/100, assumption-auditor 0/100; plus MAJ-E from `proofs_review_dispatch3.md` round 3)

**No new content. Memo §10 Step 4 (`prp:sharpquad`, L-20, L-21) is untouched and out of scope.** Two
things in this round gate it, and both are now delivered: `def:spaces`'s domain exception with the
codimension-one compression (F-4), and the Hilbert–Schmidt computation with the boundedness of the
multiplication part (F-3).

**I verified every finding before acting.** Three of the thirty-one are wrong or mis-scoped, and each is
recorded below with its witness. Where two repairs were available I took the one that removes structure:
(P4a) is deleted, `prp:orthog`(i) loses A2 entirely, the $L^2(dx)$ projection is gone, C3's support
interval loses its symbol, the anchor condition prices one scalar random variable instead of a
function-space membership, and `lem:secondord`(iv)'s standalone $\|\partial_uD\|_{L^2(P)}<\infty$ is
implied rather than assumed.

### D-00000.1 The two CRITICALs

| ID | Verdict | What changed |
|---|---|---|
| **F-1** | **CONFIRMED, and the substitution breaks my own repair exactly as stated.** I reproduced it: with $D(u,z)=\un\{u>1\}(u-1)^{-1}$, $\Delta U\sim\mathrm U[0,1]$, $\Delta h=-1$ on $A$ with $P(A)=\tfrac12$: $D(\Delta U,\Delta Z)=0$ a.s., so **every hypothesis of (iii) holds** — $E[D\mid\Delta Z]=0$ and $\|D\|_{L^2(P)}=0$ — while $E\|D(\Delta U+1)\|=\tfrac12\int_0^1u^{-1}du=\infty$. **And the failure is worse than unboundedness: with $\widetilde W$ non-degenerate, $E[\widetilde W D(\Delta U+1)]$ has both parts infinite, so $\Psi(1,\tau_2,\tau_3)$ is UNDEFINED.** Clause (ii)'s "identically in $\tau$" was ill-posed, not false, and clause (iii) named a non-existent object. **Repaired by `def:dirclass`**, which adds the shift-uniform seminorm $\|D\|_{0,h}$ to the *direction class*, and by scoping $\Psi$ to $[-\bar\tau,\bar\tau]\times\IR^2$. `rem:shiftclass` prints the separating example. |
| **F-2** | **CONFIRMED. $L_\star$ carried five sites and had no definition, and I wrote all five.** `def:weight` supplies it: $L^{\,b}_\ell(u,z)=\int_0^u\ell(v,z)dv+b(z)$, the anchored $u$-antiderivative. A2′(iii) prices the anchor and **nothing else**. `rem:anchor` shows both canonical anchors admissible free. The second half of the finding — that the variance is $E[\widetilde W^2\|L_\star\|^2]$ and A2′(ii) prices the *derivative* — is also confirmed; A4's note (d) is corrected. |

**Why the shifted-$L^2$ condition and not the density ratio.** Both were offered. The density-ratio
condition $\sup_{|\tau_1|\le\bar\tau}\|dP_{(\Delta U-\tau_1\Delta h,\Delta Z)}/dP_{(\Delta U,\Delta Z)}\|_\infty<\infty$
implies mine for *every* direction at once, so it is strictly stronger — and **it fails in the most
ordinary designs**: if $\Delta U$ has compact support and $\Delta h\not\equiv0$, the shifted law charges
points the true law does not and the ratio does not exist. That is the very display F-1 is built from.
$\|D\|_{0,h}$ restricts the direction class, where the other direction conditions already live, and
restricts the law of the data not at all.

**Why the anchor clause is the weakest form.** By `cor:elldiff`, $\|\ell_\star\|_\infty<\infty$, so
$\|L_\star(u,z)\|\le\|b_\star(z)\|+\|\ell_\star\|_\infty|u|$ and a single second moment on
$b_\star(\Delta Z)$ delivers all three things the block needs: the shifted first moment at *every*
$\tau_1$ (so no shift proviso is needed on the $L_\star$ term), the conditional integrability that
`prp:orthog`(iii)'s sign perturbation requires, and the finiteness of the variance. **What more would
buy: nothing.** A standing convention "$L_\star\in L^2(P)$" would be no stronger where it matters and
would be *false* for `cor:udep`'s affine weights $L(u,z)=c(z)u$, which are unbounded in $u$.

### D-00000.2 Where a critic is wrong, with the witness

| Finding | Verdict | Witness |
|---|---|---|
| **notation-warden T1-2: "$\psi$ is RESERVED and reused"** | **HALF WRONG, and the half matters.** The listed sites in `results.tex` and `proofs.tex` Part F are the moment function — which is $\psi$'s *reserved* meaning per glossary line 155. | The glossary row reads "$\psi$ … the moment function … **RESERVED**: the draft's $\psi$ … is renamed $\ell$". So the moment-function uses are compliant. **The genuine breach is the Laplace transform** $\psi(t)=E[\varepsilon e^{t'\Phi(V)}]$ in `lem:bierenscore`. One violation, not two; renamed $\mathsf L_\Gamma$, which introduces no new letter. |
| **notation-warden T1-6: "bare $\ell_\dagger$ has two referents, one retired"** | **WRONG at the site named.** `results.tex`'s $\ell_\dagger:=\mathcal W\ell^\Pi_\dagger$ is correctly named. | §8.5's rule is that *range-space* objects carry the superscript $\Pi$; it is not a ban on bare $\ell_\dagger$, which is an *observable-space* object and must not carry it. What was actually missing is the glossary row, now added. §8.5 is reworded so the rule cannot be read as the warden read it. |
| **regularity-checker F-5's proposed minimal condition** | **ONE QUANTIFIER SHORT — and it is the same quantifier the round-5 M-1 repair moved.** | F-5 proposes $\sup_{\vert\tau_1\vert\le\bar\tau}E[\partial_uD(\Delta U-\tau_1\Delta h,\Delta Z)^2]<\infty$ and then licenses the interchange "with envelope $\sup_{\vert\tau_1\vert\le\bar\tau}\vert\partial_uD\vert\cdot\vert\Delta h\vert$". **That envelope is integrable only under the sup-INSIDE condition** $E[\sup_s\|\partial_uD\|^2]<\infty$: $\sup_s\|\cdot\|_{L^2}<\infty$ does not give $\|\sup_s\cdot\|_{L^2}<\infty$. This is exactly the defect A2′(i.b) was repaired for in round 5. `def:dirclass` therefore states $\|D\|_{0,h}$ with the sup **outside** (which is all the exact $(\tau_2,\tau_3)$ derivatives need) and $\|D\|_{1,h}$ with the sup **inside** (which is what the one genuine limit needs). `rem:supinside` records the asymmetry and why it is forced. |
| **assumption-auditor Finding 10 (A0 / `lem:adjfubini`)** | **CONFIRMED, and resolved the cheaper way.** | $P$ is a probability measure by `def:model`, hence $\sigma$-finite with no appeal to A0. The *appeal* is struck rather than the hypothesis list extended, and A0's usage note is corrected. A0 gains a genuine consumer instead: `lem:balance`'s sample split. |

**On F-5's positive half, which is right and is the important part:** the sentence "differentiation under
the expectation is licensed by these envelopes alone" was **false**, over a list with no envelope for $D$
or $\partial_uD$. Working through it changed the accounting in a way the report did not anticipate:
**only three of the six second-order derivatives need an interchange at all**, because $\psi$ is exactly
affine in $(\tau_2,\tau_3)$, and **only one of those three involves $D$**. So the repair is one envelope,
not four, and clause (i)'s form needs no $D$-envelope whatever.

### D-00000.3 The two vacuous equivalences, and the N1 decision

**N1 is a PROPERTY, not a construction.** Made once, in `assumptions.tex`, and every other site cites it.
The auditor's read is right and the cost of the alternative is exact: under the construction reading
$L_\star$ satisfies N1 by definition, so `prp:orthog`(iii)'s "only if" is empty and the sentence "do not
assume N1" is incoherent — one cannot suspend a definitional normalisation. That equivalence is what
demotes $\varrho$ from a $\sqrt n$ nuisance to a product-rate one, so it is the claim that must survive.
Consequences: N1 struck from `lem:secondord`, `lem:solset`, `lem:balance` (listed, never consumed); the
direction condition gets its own tag **N1′**; `lem:density`(iii) reads "the subspace of weights
satisfying N1", which needed no change under the property reading; `cor:udep` keeps N1 as a genuine
hypothesis; the glossary $L$ row and the Discussion paragraph are aligned.

**`prp:orthog`(i) restated at an arbitrary admissible representer.** A2′ declares $\ell^\Pi_\star$ to be a
*solution* of the equation the second "iff" concludes, so as printed it asserted "P ⟺ True". **Quantifying
over `lem:solset`'s admissible *selections* would not have repaired it** — a selection solves by
definition. Quantifying over admissible *representers* does, and **it drops A2 and A2′ from that part
altogether**, which is a strictly stronger result on strictly fewer hypotheses.

### D-00000.4 Parts E and F — the live usage table

**Round-8 revision.** The table now carries a **Mode** column — *bound* versus *well-posedness* versus
*structure/design/rate* — because the assumption-auditor's round-8 sweep showed that a
"strength of use" reading cannot separate a genuine consumer of A1b(i) from an idle one. A1b(i) says
$\vdagger\in\mathcal V$; for a generic $h\in\mathcal V$ the same equation is `def:spaces`. The two are
**typographically identical and semantically disjoint**, and only naming *whose* membership is asserted
separates them.

| Result | Consumes | Mode | Notes |
|---|---|---|---|
| `lem:nusigma` | C1(ii); **A1b(ii)** for (ii); A1 for (v) | Structure | **A1b(i) struck** (round 8): $h$ is generic, so "constant hence zero" is `def:spaces` |
| `lem:adjfubini` | B1(i), (ii), (iv.c); C1(ii); C2′(i) | Existence | **A0 struck** |
| `lem:levels` | A0 (compact **interval**); C1(ii) | Structure | **A1b(i) struck** (round 8): in the hypothesis line, absent from every step of the proof |
| `lem:adjoint` | B1(i), (ii), (iv); **C1(ii)** (narrowed from C1); C2′(i) | Existence | not B1(iii) |
| `cor:elldiff` | B1(i), (ii), **(iv.a)**; **A2b** | Bound | **Restated at a generic admissible representer** (round 8); A2′(i.a)–(i.b) is the *specialisation* to $\ell^\Pi_\star$, not the hypothesis |
| `cor:rangegap` | `lem:adjoint`'s hypotheses; A1b(iv) via `eq:gproviso` | Bound | |
| `prp:kerchar` | (i) B1(i)–(iv), C1(ii), C2′(i); (ii) adds A1, A4(i) | Structure | |
| `cor:a1cprim` | B1(i)–(iv), C1(ii), C2′(i), **A1b(ii)**, A1d | Structure | **A1b(i) struck** (round 8), inherited via `lem:nusigma`(ii) |
| `prp:nophifree` | C1(ii) | Structure | **A1b(i) struck** (round 8): Step 3 cites `def:spaces` and `lem:nusigma`(iv) |
| `cor:udep` | A1, **A1b(i)**, A1b(iv), N1, C1(ii) | **Well-posed** | **A1b(i) KEPT.** Clause (a) is "first-order insensitive **at $\vdagger$**" — a genuine use of the base point, and the Mode column is what distinguishes it from the four struck above |
| `def:weight` | B1(i), (ii), (iv.a) + **A2b** via `cor:elldiff` | Bound | clause (a) *defines* "admissible representer" to mean A2b |
| `lem:solset` | A1, **A1b(i)**, A1b(iv), **A2, A2′(i), A2′(iii)**, B1(i), (ii), (iv), C1(ii) | Bound / Well-posed | **N1 struck**; **A2′ narrowed by clause** (round 8) — A2′(ii) consumed by no part |
| `lem:secondord` | **A1b(i)** (well-posedness, Step 1), A1b(iv), B1(i), (ii), (iv.a), C1(ii), **A2, A2′(i), A2′(iii)**; N1′ for (iii); A4(iii) for (iv)'s instantiation; `def:dirclass` | Bound / Well-posed | **N1 struck; A1 struck**; **A2′ narrowed**; **(iv)'s $\mathsf r$-bound re-denominated** in $\|\mathsf r\|_{L^2(P)}$ and its rate tag corrected from A5(iv) to **A4(iii)** |
| `prp:orthog` | (i) A1b(i), A1b(iv), B1(i), (ii), (iv), C1(ii), C2′(i) — and **not A2, not A1**; (ii) adds **A1**, A2, A2′(i), A2′(iii); (iii) adds A2, A2′(i), A2′(iii), A4(i) | Bound / Structure | **A1 split onto (ii)** (round 8), following the `lem:shiftinv` precedent; C2′(i) consumed **transitively** through `lem:adjoint`(iii) |
| `lem:balance` | `prp:orthog`(i)'s hypotheses (**no longer including A1**), **A2, A2′(i), A2′(iii)**, **A0**; (ii) A5(ii), A5(iv); (iii) A8, A5(vi), `eq:nuhat` | Rate / Design | **N1 struck**; `eq:nuhat` scoped inside (iii); the A1 surplus it inherited is now gone |
| `rem:adjointreconcile`(iii) | **H1** (infinite rank) | Structure | **The load-bearing step of the A2-versus-moment gap argument** — see the correction immediately below |
| `lem:reprsmooth` (L-21) | **A2c**, and nothing else as a hypothesis; B1(i), (ii), (iv.a) at the concluding sentence only, through `cor:elldiff` | Bound | **Round 9.** B1(ii), B1(iv) appear in A2c only as the *definitions* of $\bar w$ and $\Pi_t$, not as hypotheses. **Not A2** — A2c does not presuppose that $\ell^\Pi_\star$ solves the adjoint equation |
| `lem:formstruct` (L-20) | `lem:solset`'s hypotheses **plus C2′(i)** | Structure / Bound | **Round 9.** C2′(i) is consumed by **clause (ii) alone**, transitively through `prp:compact`, for the compactness of $\mathcal A_{\rm cond}$; `lem:solset` does not carry it, so it is listed separately. Clauses (i), (iii)–(v) do not use it |
| `prp:sharpquad` | `lem:formstruct`'s hypotheses; **O-16(a)** for (iii), **O-16(b)** for (ii) and (iv) | Bound / Structure | **Round 9.** (i) uses *no* hypothesis on $q$ beyond boundedness of $\mathcal B$. `lem:secondord` is read at the direction pair $(0,0)$, so **no direction condition and no part of (O3) is inherited**. O-16 is a hypothesis, **not a consequence of O-11** |

**Assumptions with no consumer through Step 5, each carrying a forward-reference note:** ~~A1c, A3, A6, A7,
**C1(i)** (Step 6, with C3 and C5′), C2′(ii), C3, C4′, C5′, B1(vi), A5(i), A5(iii), A5(v), A4(ii).
A2′(ii) is used at Step 8.~~ **A1d** has exactly one consumer and is not maintained. **A2b** is not
maintained at all; it is a property tag. **A2c**, new in round 9, is likewise not maintained and has
exactly one consumer, `lem:reprsmooth` — the A1d shape.

> **DISPATCH-14 RESWEEP OF THE STRUCK LIST, and it was stale on eight of its fourteen tags plus the
> sentence after it.** The list was written at Step 5 and never re-run after Steps 6 and 7 opened. Its
> heading — *"no consumer **through Step 5**"* — was true when written and is not what a later reader takes
> it for, which is why the whole list is struck and replaced rather than annotated. **Corrected status,
> verified against the current `.tex` by citation grep:**
>
> | Tag | Status now | Where |
> |---|---|---|
> | A1c | **still no consumer as a hypothesis.** It is a *target*, derived at `cor:a1cprim` | — |
> | A3 | **RETIRED (dispatch 13).** Not an assumption; must not appear on any list | `ass:rank` |
> | A6 | **RETIRED.** Not an assumption | `prp:tccfails` |
> | A7 | **CONSUMED** (Step 6), in the amended form `eq:a7amend` | `prp:phirate` |
> | C1(i) | **CONSUMED** (Step 6) | `lem:aerr` Step 2 |
> | C2′(ii) | **CONSUMED** (Step 6) | `lem:opnoise` Step 3 |
> | C3 | **CONSUMED** (Step 6), and restated in dispatch 9 | `lem:intker`, (P9) |
> | C4′ | **still no consumer.** Occurs only in its own statement | — |
> | C5′ | **CONSUMED** (Step 6); (i) amended in dispatch 9 | `lem:opnoise` Steps 3, 5 |
> | B1(vi) | **RETIRED (dispatch 14).** Not an assumption | `ass:bierens`(vi) |
> | A5(i) | **CONSUMED** (Step 7), through (T-4) and Step 0 | `thm:rootn` |
> | A5(iii) | **CONSUMED** (Step 7): it *is* `eq:frontier`, and it is the one (T-4) clause no result delivers | `thm:rootn` |
> | A5(v) | **still no consumer**, and this is now *verified* and not merely asserted — the $\varphi$-step runs at the fixed anchor $\theta_\circ$, so no Landweber pass on $\Delta Y-\Delta Z'\hat\theta$ occurs | `rem:rootnscope`(4) |
> | A4(ii) | **CONSUMED** (Step 7), with (iii), as the source of $r_n$ | `thm:rootn` (T-3) |
>
> **And the sentence "A2′(ii) is used at Step 8" was the one that mattered most, because it is a claim
> about a *maintained* clause and it was the shape of A4 comment (d)'s false retention ground.** A2′(ii)
> was used **nowhere**, at Step 8 or anywhere else, Step 8 not being open. It is **retired in dispatch 14**,
> and the Step-8 need — real, at tier T3, where A2′(i) is relaxed and the clause becomes a genuine
> irregularity boundary — is recorded at the retirement note as a **forward obligation**. *A forward need is
> not a consumer, and a list that records it as one converts an open obligation into a discharged one.*
>
> **The general repair, which is the more useful output:** a "no consumer" list must carry the step it was
> swept at **in its own row**, not in a heading, or it must be re-swept every time a step opens. This one is
> now dated and its rows carry their sites.

**One entry of this list is corrected by Step 4, and it is the kind that matters.** **C2′(i)** was not on
the "no consumer" list and is not added to it — it already had consumers — but its *transitive*
consumption is now recorded at a second place: `lem:formstruct`(ii) reaches it through `prp:compact`, the
same shape in which `prp:orthog` reaches it through `lem:adjoint`(iii). Both are named at the site.

**Two corrections to this list, both round 8.**
- **H1 is removed from it.** It has a consumer: `rem:adjointreconcile`(iii) at `results.tex:840–842`,
  the load-bearing step of the A2-versus-moment gap argument. This matters beyond bookkeeping:
  `prp:sharpquad`'s ill-posedness discussion inherits that use, and a Step-4 hypothesis list built from
  the stale row would have omitted it.
- **A4(iii) is removed from it.** It is consumed by `lem:secondord`(iv)'s instantiation, which is where
  $r_n$ is priced. Rounds 1–7 attributed that instantiation to A5(iv), which prices $\epsilon_n$ and
  says nothing about $r_n$.

### D-00000.5 MAJ-E — the refuted "product bound" survived in two artifacts

**CONFIRMED, and it is the failure mode I named against myself in §D-0000 MAJ-2**, one level out: a
passing spec aimed at the wrong claim converts an unchecked claim into an apparently checked one.

- `secondord-crossterm-tau1.yaml` closed "the residual is O($t_1$), i.e. **a product term**, which is
  exactly how the corrected clause states it." **The corrected clause states the opposite.** And the
  spec's model takes $D$ a *quadratic polynomial* — the smooth case the printed counterexample
  deliberately avoids — so it cannot certify (iii)'s negative content at all.
- `theory_memo.md`'s M-4 row carried the same word.

**Disposition: the spec is kept, its stated conclusion is rewritten, and a second spec is added.** The
model is *not* replaced, and the reason is worth stating: the algebra it checks is a genuine mechanical
verification of a genuine *positive* claim (the $\tau_1$-dependence does not vanish identically), and **no
smooth model can carry the negative claim**, because a smooth $D$ with a bounded second derivative does
have an $O(\tau_1)$ expansion. The negative content therefore gets its own spec,
`secondord-shift-nonintegrable`, built on F-1's construction; it verifies $\int u^{-1}du=\log u$
mechanically and reads the divergence off it, **with the boundary between the two stated in the spec** so
that it cannot be quoted as certifying more than it evaluates. The M-4 memo row is struck through and
corrected in place rather than edited silently.

**And the proof now says it.** `lem:secondord` Step 4 carries a named paragraph, *"What
\eqref{eq:crossshift} is and, precisely, is not"*, ending: "Step 6 or 7 … must not inherit the word
'product' from any earlier record of this step."

### D-00000.6 What this round did NOT do

- **Step 4 is untouched.** `prp:sharpquad`, L-20 and L-21 are not written.
- **`paper/sections/theorems/` Part F is not generated**, per the dispatch. Part E renderings received
  targeted syncs only (the `eq:gproviso` divergence, the environment count, the undefined "admissible").
- ~~**`preamble.tex` does not exist in this repository** and I no longer cite it as if it did. Every
  `\IR`, `\un`, `\upmodels`, `\vdagger`, `\newtheorem` and now `\mathfrak` is undefined at document
  level. That is the writer's, and it is recorded, not fixed, here.~~
  **SUPERSEDED — orchestrator note, 2026-07-29.** True when written; the orchestrator created
  `paper/preambles/preamble.tex` *during* this dispatch, so the theorist could not have seen it. It
  resolves via `paper/latexmkrc`'s `TEXINPUTS` and defines `\IR`, `\IQ`, `\un`, `\upmodels`,
  `\vdagger` and all theorem environments; `\mathfrak` comes from `amsfonts`, which it loads.
  **Verified by compilation, not assumed:** `lem-shiftinv`, `lem-bierens`, `lem-adjoint` and
  `rem-nophifree` build together at exit 0 with **0 errors and 0 undefined control sequences**,
  25 pages, numbering in one shared sequence.
  Two riders the theorist should know for the next round. (1) **`\un` is defined as a bare symbol**,
  since all 40 uses are `\un\{...\}` with literal braces — do not start calling it with an argument.
  (2) **Remarks are numbered**, sharing the result counter, because `\cref{rem:R1}(iv)` and two
  siblings are live cross-references and an unnumbered environment would render them "section 3(iv)".
  That departs from `.claude/references/theorem-environment-style.md` and is flagged for the user,
  not resolved.
- **`dummy.tex` reuses tags A1–A2 inside this project's declared-stable tag namespace.** It belongs to
  `theory-track-smoke`. I added a one-line guard comment and flagged it; deleting a pipeline smoke-test
  fixture is not mine to do.
- ~~**The symbolic specs were not executed** — this dispatch had no shell.~~ **DONE — orchestrator,
  2026-07-29.** Both run, both **MATCH**. Full-suite regression: **62 specs, 62 MATCH, 0 MISMATCH,
  0 CRASH.** `secondord-shift-nonintegrable`'s header discipline was checked and upheld — it states
  what SymPy evaluates (the antiderivative $\int u^{-1}du=\log u$) separately from what a human reads
  off it (the divergence), and says a spec "must not be quoted as certifying more than it evaluates."
  That is the MAJ-2 lesson applied. Also noted: the two `frontier-table-rounding-*` probes, previously
  by-design MISMATCHes read off a residual, have been rewritten to assert the exact rounding error
  ($10/3-333/100=1/300$) and now MATCH — a positive verification replacing an inferred one, which is
  strictly better. **Two housekeeping items for the theorist:** a stray extensionless file
  `scripts/symbolic/specs/frontier-table` sits in the spec directory, and the memo states spec counts
  of "Ten", "Thirteen" and "5" at three places against an actual 62.
  *(original note continues)* ~~`secondord-shift-nonintegrable` is written in the branch-free
  indefinite-integral form precisely so that it cannot fail on a `Piecewise`.~~
  **STRUCK IN THE ROUND-7 POSTFIX PASS — the rationale was wrong and the finding that caught it (4.5)
  is right.** `integrate(1/u, (u, 0, 1))` with `u` declared `positive` returns `oo`, not a `Piecewise`;
  there was no `Piecewise` hazard to avoid, so the indefinite form bought nothing and the `claim_id`
  named a non-integrability result the spec did not evaluate. The spec now evaluates the definite
  integral. **One correction to the finding's proposed remedy, with a witness, in §D-000000.5.**

---

## D-0000. Round-6 disposition (against `proofs_review_dispatch3.md` round 3, 58/100 — one CRITICAL)

**The CRITICAL and both new MAJORs are mine, and two of the three are repairs that broke the object they
repaired.** I reproduced each before acting.

| ID | Verdict | What changed |
|---|---|---|
| **C-1** | **CONFIRMED. I reproduced the counterexample analytically.** With $\Delta U\sim\mathrm U[0,1]$, $\Delta h=-1$ on $A$ with $P(A)=\tfrac12$, $\tau_1=1$, $D=M\un\{u\in[1,2]\}$: $D(\Delta U,\Delta Z)=0$ a.s.\ so $\|D\|_{L^2(P)}=0$, while $E[rD(\Delta U+1)]=M/2$. **The printed bound reads $M/2\le0$.** The diagnosis is exact and it is the worst kind: **the M-4 repair reproduced, one line later, the very asymmetry it was written to catch** — I identified that $E[D\mid\Delta Z]=0$ lives at the true residual, then bounded the shifted object by the true-law norm. Fixed by pricing the **shifted** norm, `eq:crossshift`, with the counterexample **printed in the proof** rather than described, and with the two conditions that would restore comparability named and *not* assumed. |
| **MAJ-1** | **ACCEPTED.** The M-3 rewrite conjugated $\mathcal K$ and not the multiplication term: on $L^2(\pi)$ the form is $\mathcal B=(\sigma_q/\pi)\cdot-2\tilde{\mathcal K}$, and the pre-M-3 $\|\sigma_q/\pi\|_\infty$ was the correct multiplication norm. Three further limbs accepted: the tilde conjugates rather than symmetrises, $q\,f_{X_1,X_2}$ is not symmetric, so $\mathcal B$ is **not self-adjoint**; $\tfrac12\|\mathcal B\|$ is therefore an **upper** bound and the sharp constant is $\tfrac12\|\mathcal B_{\rm sym}\|$ with $\mathcal B_{\rm sym}=\tfrac12(\mathcal B+\mathcal B^\ast)$; and $\sigma_q$ being $\IR^p$-valued, \eqref{eq:Bpi} is $p$ operators. $\|\sigma_q/\pi\|_\infty$ survives as a **lower** bound via Weyl. |
| **MAJ-2** | **ACCEPTED, and this is the one I mind most.** My spec passed while certifying nothing: $q=\big(\begin{smallmatrix}0&c\\-c&0\end{smallmatrix}\big)$ is anti-symmetric against a symmetric $f$, so both forms vanish and the witness showed only that $q\mapsto\sigma_q$ is non-injective. **A passing spec aimed at the wrong claim is worse than no spec**, because it converts an unchecked claim into an apparently checked one. Re-aimed at $q=\big(\begin{smallmatrix}-c&c\\c&-c\end{smallmatrix}\big)$ versus $q'\equiv0$: row and column sums zero so $\sigma_q$ shared, form $2c(h_1-h_2)^2$ versus $0$. The proof's justifying sentence now says **symmetric part**. |
| **MAJ-3** | **ACCEPTED.** Two sites printed $\tfrac12\|\sigma_q/\pi\|_\infty$ as the sharp constant, one marked binding on Step 4. Both corrected to "lower bound, via Weyl", with the three reasons spelled out at the binding site. |
| **MAJ-4** | **ACCEPTED, and thank you for saying the pass-through was yours.** `lem:balance`(ii) listed `eq:nuhat`'s first half as a hypothesis its own Step 3 never uses — the direct bound $\|\nu_g/\pi\|\|h\|$ consumes only Step 2 and A5. Removed from (ii); the "not input-free either" sentence, which contradicted the step two lines above it, deleted; **N-18(3) inverted in the memo** — it is the *balancing* route that needs `eq:nuhat`, and both halves. |
| **MAJ-5** | **ACCEPTED.** Glossary $\epsilon_n$ corrected to the derivative, with the INV-7 reason recorded: leaving it made one symbol mean two objects across two files. |
| **MAJ-6** | **ACCEPTED, and the critic's framing is the right one to keep.** The header was wrong in five ways in a file whose mathematics was flawless. Rewritten: nine environments listed, dependencies corrected (`def:model`, `prp:wellposed`, `prp:nophifree` added; `def:admissible` removed), conventions completed, **assumption tags given per result rather than in aggregate** — and a sync-discipline note stating that a hand-maintained header is the same failure mode as a hand-maintained rendering, one remove out. |
| **m-1…m-8** | **ALL ACCEPTED.** N1 removed from `prp:orthog` entirely, with "(i) and (ii) do not use it and (iii) characterises it"; **the spline bound pinned to Schumaker Thm 6.27 with DeVore–Lorentz Ch. 13 Thm 6.2 as the equivalent** — it is the whole content of Step 4 and cannot rest on a surname, so it is cited now and the librarian adds the `.bib` entry after; `lem:solset`(ii)'s reference to (iii) rewritten as an equivalence; the $L^2(dx)\to L^2(\pi)$ transfer reduced to the single factor $\|\pi\|_\infty^{1/2}$, since $P_{L_x}$ minimises over the same span; A2 dropped from `lem:solset` as contained in A2$'$; **M-1's rationale corrected — the decisive consumer is the C2′(i) removal, not `cor:udep`**, and (α) and that removal stand or fall together. |

### The DeVore–Lorentz pin: **Ch. 12**, and checking it removed an operator from the proof

The librarian's reasoning was sound and the conclusion goes the other way, because it turned on what
`proofs.tex` *displayed* rather than what the argument *consumes*. The chain was:
$\|(I-P_{L_x})\zeta\|_{L^2(\pi)}\le\|(I-P^{\rm Leb}_{L_x})\zeta\|_{L^2(\pi)}\le\dots$, and the **first**
inequality is a minimality statement — $P_{L_x}$ is the $L^2(\pi)$-nearest point of the span, so it beats
*any* element of that span. Naming $P^{\rm Leb}_{L_x}$ was incidental. So what the proof needs is a
**best-approximation (direct/Jackson) bound**, $\inf_{g\in\mathcal S_{L_x}}\|\zeta-g\|_{L^2}\le CL_x^{-s}\|\zeta\|_{H^s}$
— which is **Ch. 12, "Spline Approximation"**, not Ch. 13's projections.

**Acting on that improved the proof rather than just relabelling it.** `eq:jackson` is now stated as a
best-approximation bound and $P^{\rm Leb}_{L_x}$ is **removed from the argument entirely**. Three gains:
one operator fewer; a strictly weaker citation; and the boundedness of the $L^2$ projection — which the
coordinator correctly noted is what makes the rate $L_x^{-s}$ "either way" under a projection route — is
now not used at all, so that dependency disappears rather than being silently relied on.

This also matters for Schumaker: Thm 6.27 sits in "Approximation Power of Splines" with §§6.4–6.5 titled
"Direct Theorems", which is consistent with it being exactly `eq:jackson`'s kind of statement. **I have
not read Thm 6.27**, so the pin is to *the statement the proof needs*; if Thm 6.27 turns out to be about
a specific quasi-interpolant or projection rather than best approximation, the load-bearing pin should
move within §§6.4–6.5 — but the *kind* of theorem is fixed by the argument and is a direct theorem. The
reasoning is written into the proof so the next reader can check the choice rather than inherit it.

### Standing note: checker authority is not build authority (N-21)

The librarian's three-bibliography recommendation is right, and **the caveat is the part I need to carry**:
`references.bib` being authoritative for `/tools validate-bib` does **not** make it authoritative for
`paper/main.tex`, which resolves against whatever `\addbibresource` names. A key that exists only in
`references.bib` still breaks the build — which is what my round-6 pin did. **Rule for me from here: before
pinning any citation, check the key against the file `\addbibresource` names, not against the file the
validator reads.** Recorded because the failure mode is silent at validation time and loud at compile time.

**On the sweep and the renderings: both calls upheld, and I am adopting the mechanical-diff requirement.**
The two corruption modes are exactly right and worth restating because they generalise: the
assumption-auditor reads *statements*, so a hypothesis listed but unused becomes a false positive it
cannot detect; the notation-warden reads *internal* consistency, so a term conjugated in one place and
not the other passes as well-formed prose. **Neither critic can catch a defect that is locally coherent
and globally wrong.** That is the argument for the mechanical diff, and it is now in the header.

---

## D-000. Round-5 disposition (against `proofs_review_dispatch3.md` round 2, 65/100)

**All eight MAJORs and eleven minors accepted; each verified before acting. No mathematics changed.**

| ID | Verdict | What changed |
|---|---|---|
| **M-7** | **ACCEPTED, and my round-4 report understated it.** I described the paper renderings as "lagging one dispatch"; they were **carrying four already-scored, already-repaired defects under the same `\label` keys**, and the paper compiles those. Resynced first: R2-2 (Riesz representer now routed through `prp:nophifree` Step 0), R2-3 (`eq:Wderiv` moved into `cor:elldiff`, B1(v) citation removed), R2-5 (injectivity replaced by the compact-range argument), R2-6 (FF Prop. 2.1 verbatim in their notation, binary-instrument mismatch flagged). |
| **M-1** | **ACCEPTED. My dominating function was one quantifier short.** A2′(i.b) gave $\sup_u\int(\cdot)d\Pi_t<\infty$ while Leibniz needs $\int\sup_u(\cdot)d\Pi_t<\infty$ — $L^1$-boundedness in $u$ is not uniform integrability, and `cor:elldiff`'s proof silently used the stronger form. **Repair (α) adopted: sup moved inside in both (i.a) and (i.b).** Reason for (α) over (β): `lem:secondord`(i) and `cor:udep` evaluate $\partial_u\ell_\star$ at $\Delta U$, a **random** point, so an a.e.-in-$u$ identity would need a separate null-set argument in three consumers rather than one clause here; and A2′(i) is a sup-norm condition anyway. **L-21's target raised accordingly, and recorded in A2′'s comment before Step 4 runs.** |
| **M-3** | **ACCEPTED.** The form is $\mathcal B_{\rm sym}=\sigma_q\cdot-2\tilde{\mathcal K}$ and $\mathcal K$'s kernel $qf_{X_1,X_2}$ is bivariate — a marginalisation does not determine it. My own proof said "the two objects $q$ and $\sigma_q$"; the *statement* compressed it. Corrected, with the Step-4 consequence stated: the sharp constant is $\tfrac12\|\mathcal B_{\rm sym}\|$, not a functional of $\sigma_q$; what $\sigma_q$ governs is the essential spectrum. New spec `solset-sigmaq-not-sufficient` exhibits two selections with identical $\sigma_q$ and opposite $\mathcal K$. |
| **M-4** | **ACCEPTED, and it would have propagated.** The hypothesis $E[D\mid\Delta Z]=0$ is at the **true** residual; at $\tau_1\ne0$ the argument is the shifted one and there is no reason for vanishing. (iii) now claims $\tau_1=0$ only, with the off-$\tau_1$ bound stated **on the shifted norm $\|D\|_{0,h}$**. I had reused part (ii)'s correct "identically in $\tau$" phrasing on a weaker fact. New spec `secondord-crossterm-tau1` exhibits the $O(\tau_1)$ residual on a smooth $D$. ~~with the off-$\tau_1$ product bound stated~~ **— "product bound" CORRECTED IN ROUND 7 (MAJ-E). There is no product bound. A product bound would read $C\|\mathsf r\|_\infty\|D\|_{L^2(P)}$ with the *unshifted* norm, and the counterexample printed in the proof shows that no such bound exists ($M/2\le C\cdot0$ is false for every $C$). The word survived here and in the spec's stated conclusion after the C-1 repair had removed it from the proof, which is exactly how a Step-6/7 author reading the change log rather than the proof would have inherited the error C-1 was raised against.** |
| **M-5** | **ACCEPTED.** A5(iv) priced $\|\hat L-L_\star\|$ while both consumers use the derivative — `lem:balance`(i) needs $\|\hat\ell-\ell_\star\|$ and `lem:secondord`(iv) needs $\|\partial_uD\|$. **An $L^2$ rate does not transfer to a derivative** — the same one-directional transfer `lem:levels`(iv) records for $\mathcal D^{-1}_0$, here in the nuisance direction. A5(iv) restated on $\partial_u(\hat L-L_\star)$, with a note that the level rate is neither implied nor used at Step 5. |
| **M-2** | **ACCEPTED.** `lem:solset` now assumes A2′ and defines "admissible selection" as satisfying A2′(i.a)–(i.b), which closes m-9 as well. |
| **M-6** | **ACCEPTED.** `eq:nuhat` added to `lem:balance`'s hypotheses: ~~$\|(\hat\nu_g-\nu_g)/\pi\|=O_P(n^{-1/2})$ for both routes~~, $\|\hat\nu_g/\pi\|=O_P(1)$ for (iii). The critic is right that $O_P$ products do not divide, so it was not recoverable from hypothesis (I). **"FOR BOTH ROUTES" IS WRONG AND WAS INVERTED BY MAJ-4 IN ROUND 6; this row was not updated at the time, so the memo carried two contradictory rows on `eq:nuhat` (this one and MAJ-4 in §D-0000). Only MAJ-4 is correct: the rate route uses NO half of `eq:nuhat`. In round 7 the whole display is moved INSIDE clause (iii), so the file can no longer be read either way.** |
| **M-8** | **ACCEPTED — same species as the `lem:shiftinv` split.** N1 dropped from (iii)'s hypotheses; the proof never used it. As printed the equivalence was vacuous ("iff N1", under N1), which destroyed exactly the statement that justifies demoting the propensity. |
| **m-1…m-11** | **ALL ACCEPTED.** $E[|D|\mid\Delta Z]<\infty$ added with the degenerate-region note; the sign direction run one coordinate at a time with $p$ scalar $r$'s, since a vector $r$ is ill-typed against F-15; A4(i) added to (iii) to keep the perturbation a propensity; $\partial_uD$ hypothesised; the $L^2(dx)\to L^2(\pi)$ transfer written out with its two constants and the three citations **named but not cited**, since verifying them in the bibliography is outside my write scope (flagged for the librarian); the "(II) bounded by (III)" claim corrected; $\mathcal K$/$\tilde{\mathcal K}$ distinguished by reference measure in the glossary and $\mathcal S$, $\mathcal B_{\rm sym}$ added; **C2′(i) removed from both Part F results, where it is genuinely idle** — the $\tau_1$-derivatives differentiate $L_\star$ along its own argument, which `cor:elldiff` makes $C^1$, so no conditional density is needed; and `eq:adjointdisplay`'s bracketing, which round 4 recorded as applied and was not. |

**N-18 — the two scope corrections folded in.** (1) **A5(iv) cannot leave the block**: `lem:secondord`(iv) consumes it independently, since the $(\varphi,L)$ cross term needs $\delta_n\epsilon_n=o_P(n^{-1/2})$ on either first-order route. My phrasing was correctly scoped but the block-level inference would not have been. (2) **The prize is A8's lower end** — what the rate route removes is $L_x\gg n^{1/(2s)}$ and with it the "$s>1$ / $s>3/2$" row of the smoothness-budget table, which is contested against A2, H1 and A5(iii); the upper end survives on both routes. (3) ~~The rate route is not input-free either.~~ **INVERTED IN ROUND 6 (MAJ-4). The rate route *is*
input-free of `eq:nuhat`** — its Step 3 bounds $|\langle\nu_g/\pi,h\rangle|\le\|\nu_g/\pi\|\|h\|$
directly from Step 2 and A5, using no empirical-process statement at all. **It is the *balancing* route
that consumes `eq:nuhat`, and both halves of it.** The round-5 text listed the hypothesis on (ii) and
then contradicted it two lines below; the correction runs the other way from the one recorded.

---

## D-00. Round-4 disposition (against `proofs_review_dispatch2.md`, 84/100 — cleared) and Step 5

**All eleven findings accepted; each verified before acting.** Then memo §10 Step 5 delivered.

| ID | Verdict | What changed |
|---|---|---|
| **R2-1** | **ACCEPTED. My error, and the one that propagated.** `cor:rangegap` is a corollary to `lem:adjoint`(ii)–(iii), which **are** the N-10 closure: roll B1(iv.a) back to full support and $\mathcal W$ has no definition, so the corollary does not weaken — **it ceases to have a subject.** It is independent of the round-3 $C^1$ clause only. The `.tex` and §§D1.4/D2.3 always said this; **the N-17 escalation row did not, and that is the row that got transcribed into plan §2.7.** Row corrected. **The lesson is narrow and worth keeping: an escalation row is a claim and needs the same verification as a claim in a proof. I generalised from a verified two-item re-trace to a third item I had not re-traced.** |
| **R2-2** | **ACCEPTED.** `cor:rangegap` Step 1 wrote $\int\nu_{g_\Xi}h\,dx=\langle\nu_{g_\Xi}/\pi,h\rangle_{L^2(\pi)}$ to *identify* the Riesz representer, but that inner product is well formed only once $\nu_{g_\Xi}/\pi\in L^2(\pi)$ — the thing being identified. **The same gap `prp:nophifree` Step 0 exists to close, one corollary later, in a proof I wrote after writing Step 0.** Step 1 already verifies clauses 1 and 2 of `eq:gproviso` for $g_\Xi$, so Step 0 applies verbatim; now cited, with the projection step spelled out via `lem:nusigma`(iv). |
| **R2-3** | **ACCEPTED, and the repair is structural rather than a patch.** B1(v) dominates $\partial_u\lambda$ in the $L$-representation; since $\mathcal W\ell^\Pi_\star=\partial_uL_\star$, that is one derivative short of the $\partial_u\ell^\Pi$ `eq:Wderiv` consumes. **I did not add a second-derivative clause to B1(v)**: differentiability is a property of the *selected solution*, not of an object the analyst chooses, so it cannot live in B1 at all. **A2′(i) is restated on $\ell^\Pi_\star$** as (i.a) and (i.b), and the new `cor:elldiff` **derives** `eq:Wderiv` and both sup-norm bounds from them. What rounds 1–3 assumed is now a conclusion; (i.b) is exactly the dominating function. The $\lambda$-versus-$\ell^\Pi$ relation ($\partial_u\lambda=\varpi_u\ell^\Pi$, one $u$-integration apart) is stated so C13's reservation is not silently breached. |
| **R2-4** | **ACCEPTED.** $\mathcal C_0$ defined; glossary now calls $\mathcal N_0$ a linear subspace **and says why** (both $\mathcal C_0$ and $g\mapsto\nu_g$ are linear), with the qualifier flagged as load-bearing for MAJ-2. |
| **R2-5** | **ACCEPTED.** Injectivity was both unavailable and unnecessary. Replaced by: $\mathcal A^\ast_{\rm cond}$ is compact (adjoint of a compact operator), a compact operator has closed range iff that range is finite-dimensional, and H1's infinite-rank clause excludes it. |
| **R2-6** | **ACCEPTED — the m-9 pattern in the other remark.** FF Prop. 2.1 now quoted verbatim in *their* notation ($Z_1,Z_2,z,w,\psi$) with the translation stated adjacent, not 130 lines away. **And a difference of setting is now flagged rather than absorbed:** their $dw$ integral ranges over a general instrument space, whereas $W$ is binary here, so our counterpart is a two-point sum. $\psi$ appears only inside the quotation. |
| **R2-7** | **ACCEPTED.** Clause 3 stated at $\varphi=0$ only, with the derivation of the general case from clauses 2 and 3 given in the proof. |
| **R2-8** | **ACCEPTED.** `prp:kerchar` Step 4 rewritten to run entirely at the unconditional level, where Step 1's continuity actually lives: multiply by $\varsigma(\Delta U)e^{t'\Phi(\Delta Z)}$, recognise $\int\varsigma\,\mathcal A_{\rm cond}h(\cdot,t)$, then use continuity. |
| **R2-9** | **ACCEPTED.** §D2's table corrected to match the m-7 split. |
| **R2-10** | **ACCEPTED, and it sharpens the result.** $\psi=g\Delta U(\theta,\varphi)$ with $g$ free of $\varphi$ is **affine**, so all terms of order $\ge2$ vanish *unconditionally*; (a)–(c) add only the vanishing of the first-order term. "In that case" attached an unconditional fact to a hypothesis. |
| **R2-11** | **ACCEPTED.** (P5) scope; glossary $\ell_\dagger\to\ell^\Pi_\dagger$; `results.tex` header exclusion list rebuilt; $\mathcal X$'s compactness attributed to A0 not `assapp1`; `eq:adjointdisplay` bracketed to match `eq:adjclosed`; "Ten specs" corrected. |

**The "aspiration into a theorem" line is withdrawn.** `eq:Wderiv` is a *conditional* identity; its hypothesis is A2′(i.b), which is a primitive awaiting L-21 and which §D5 item 2 still lists as open. The `.tex` carried the proviso; the memo overstated, and the critic was right to separate them.

### Step 5 delivered (memo §10 Step 5)

`lem:solset` (L-16), `lem:secondord` (L-6), `prp:orthog` in three parts, `lem:balance` (L-7), in Part F of
`results.tex`/`proofs.tex`. Stated in the sieve / $L^2(\pi)$ dual-pairing form per plan §19.1; the RKHS
form is not stated. **Coordinatewise throughout, per F-15.**

**The three parts, and what each consumes.** (i) $\partial_{\tau_1}m(0)=-\langle\nu_{\Delta Z+\widetilde W\ell_\star}/\pi,h\rangle$,
vanishing for all $h\in\mathcal V$ iff $\mathcal A^\ast_{\rm cond}\ell^\Pi_\star=-\nu/\pi$ — the referent
settled in dispatch 1 and externally anchored by FF Prop. 2.1. (ii) **exact** in $L$, from A1 and (P3)
alone, for every admissible direction and every $\tau_2$ — no N1, no rate. (iii) **exact** in $\varrho$
**iff N1**, with the "only if" by taking $r=\operatorname{sign}(E[L_\star\mid\Delta Z])$. So N1 is
precisely what demotes the propensity from a $\sqrt n$ nuisance to a product-rate one.

**L-16 delivers the selection as part of the statement, not as a consequence:** the solution set is
affine, *every* member gives a valid orthogonal moment (validity does not select), and the object the
selection moves is $\sigma_q=\mathcal S\ell_\star$ — with $\int\sigma_q\,dx=0$ **free for every
selection** by `lem:nusigma`(v). *So the selection can move the shape of $\sigma_q$ but never its mean*,
which is exactly why the difference structure buys nothing at second order.

**And a finding on the sieve pricing (N-18, below): A5(iv) and A8 are ALTERNATIVES, not cumulative.**

---

## D-0. Round-3 disposition (against `proofs_review_dispatch1.md` lineage, 54/100, strike 2 of 3)

**Every finding accepted. I verified each independently before acting; none required re-proving anything,
and no mathematics changed.** The profile the critic named is accurate: this was a statement-discipline
failure. Three of the four MAJORs are cases where a *true* argument was fenced by a *false* statement.

| ID | Verdict | What changed |
|---|---|---|
| **MAJ-2** | **ACCEPTED. The equivalence was false as printed.** I reproduced it: $\mathcal N_0$ is a set indexed by all admissible $\tilde c$, so (c) read existentially can hold at some $\tilde c'$ while (a) and (b) fail at the given $c$. My proof text — *"which is membership of $-\nu$ in $\mathcal N_0$"* — is exactly where the quantifier slipped. **(c) restated at the given $c$**, with the existential membership named as the weaker consequence. A named paragraph in the proof now states which direction is used downstream and why the contrapositive is unaffected. |
| **MAJ-4** | **ACCEPTED, and it is my own debt.** B1(iv.a) gave $\varpi_u$ no smoothness, yet $\ell_\star=\mathcal W\ell^\Pi_\star$ carries $\varpi_u$ as a factor, so A2′(i) bounded the derivative of an object the block did not deliver. **Before N-10 was closed the defect could not exist** — A2′(0) made $\ell_\star$ primitive. Constructing it exposed the debt. B1(iv.a) now requires $\varpi_u\in C^1$ with bounded derivative, and the two-term derivative formula is stated as `eq:Wderiv`, which **turns the $\Pi_u$ selection lever from an aspiration into a theorem**. |
| **MAJ-1** | **ACCEPTED. The sentence was false.** $\Delta Y$ and $\Delta Z$ are not functions of $X_1$ or $X_2$, so the $h\in\mathcal V$ proviso covers neither $E[g\Delta Y]$ nor $E[g\Delta Z']$. **Rather than patch the hypothesis I rewrote the proof on increments**, which needs no separate term at all: $E[g\Delta U(\theta,\varphi)]-E[g\Delta U(\theta,\varphi_0)]=-\int\nu_g(\varphi-\varphi_0)dx$. The proviso is now `eq:gproviso`, three clauses. **And the $\sigma(W,\Delta Z)$-measurability is dropped from the statement**: it is never used, the result holds for any integrable $g$, and the class is imposed at the point of use in `cor:udep`. |
| **MAJ-3** | **ACCEPTED, and the critic's version is stronger than mine.** I re-traced `prp:kerchar`: it never touches $\varpi_u$. Its clauses are $P$-a.s. and the reference measure on $(u,z)$ is $P_{\Delta U,\Delta Z}$, available unconditionally; B1(iv.a) enters only through `lem:bierens` Step 5's round-2 full-support clause. **So `prp:kerchar` and `cor:a1cprim` survive a complete rollback of the B1(iv.a) strengthening** — the A1c bridge and the N-10 closure are independent results that happened to land in the same dispatch. Attribution corrected in `assumptions.tex` and in §D2.3. |
| **m-2** | **ACCEPTED.** $\|\varsigma\|_\infty\bar f_0|\Delta h|$ is constant in $u$ (a sup over $u$), hence not $u$-integrable. Correct envelope is $\|\varsigma\|_\infty f_{\Delta U\mid\mathcal F_{XZW}}(u)|\Delta h|$, whose double integral is $\|\varsigma\|_\infty E|\Delta h|$ via $\int f_{\Delta U\mid\mathcal F}\,du=1$. Interchange valid, justification was wrong; both now stated. |
| **m-3** | **ACCEPTED.** Added Step 0 to `prp:nophifree`: $E|g|<\infty$ is a *separate* clause because $1\notin\mathcal V$; and $\nu_g/\pi\in L^2(\pi)$ is proved by Banach–Steinhaus, without which "$\nu_g/\pi\in\mathcal V^\perp$" is not well formed. |
| **m-4** | **ACCEPTED.** $\varrho_t\to\varpi_t$ (matching $\varpi_u$ by type, both range-side densities); $S_k\to\mathcal U_k$; $\mathcal G_\ast$, $\mathcal T_1$, $\mathcal U_k$, $\varpi_t$, $\mathcal B$, $\Xi$ all declared. |
| **m-5** | **ACCEPTED.** A0's note rewritten: Step 3 uses A0 twice, and in neither place is it the i.i.d. clause — `lem:levels` uses compactness of $\mathcal X$, `lem:adjfubini` uses $\sigma$-finiteness of $P$. The i.i.d. clause remains unused before Step 6, and saying which clause is consumed is the point. |
| **m-6** | **ACCEPTED.** F-15 finished in the binding tables: §3 retypes $q,\sigma_q$ as $\IR^p$-valued; C4 corrected to $-\nu/\pi$ and to $\ell^\Pi_\dagger$. C4 was the last uncorrected instance of the round-1 $\nu$-versus-$\nu/\pi$ error. |
| **m-7** | **ACCEPTED.** `prp:kerchar` split: (i) (a)⟺(b) needs neither A1 nor A4(i); (ii) (b)⟺(c) needs both. `cor:a1cprim` reads (b), so it now carries B1(i)–(iv), C1, C2′(i), A1b(i)–(ii), A1d — **and nothing else**. |
| **m-9** | **ACCEPTED, and it is the one I am least comfortable having written.** I substituted $Z\to X$ inside what was presented as a quotation. Both Fève–Florens quotations are now verbatim in *their* notation, with a "Notation, fixed once" paragraph stating the translation. |
| **m-11** | **ACCEPTED. The asymmetry was argued badly and contradicted `rem:R1`(iv) in the same file.** Both $\theta$ and $\varphi$ enter `eq:Adef` as shifts, so "the reason" applied symmetrically. Restated: the display writes $f_U(u)$, supporting *neither* subscript, so the defect is symmetric and the repair is to write the shifted density. **Both indices are substantive** — `rem:R1`(iv) for $\theta$, `prp:frechet`(ii) for $\varphi$ — and what is $\theta$-free is the *solution set*, not the operator. |

**The two gifts, both taken.** F-20's sharpening is now `cor:rangegap`, a proved corollary rather than a
memo note — see §D3. The Fève–Florens caveat is folded into `rem:ffcompare`: the two asymmetries run in
*opposite* directions and meet only because the recognisable completeness conditions are stated over a
coarser class than the design's information.

---

## D0. Pre-Theory Report

| Input | Path | Status |
|---|---|---|
| Own carried flags | `.../theory_memo.md` §§5–7 (Part I below) | **RE-READ.** §5 items 1, 1b, 3; §6 F-1, F-12; §7 N-2, N-7, N-10. |
| Proof-strategy memo | `quality_reports/strategy/panel-npiv-discrete/proof_strategy_memo.md` | **RE-READ** §0.1 (the $\nu_g$/$\sigma_g$ identity), §2.3–2.4, §3.5, §4 (lemma inventory L-1, L-4, L-5, L-16, L-20, L-21), §5 (O-4, O-10, O-11, O-15), §10 (order of work + gates). |
| Own dispatch-1 artifacts | `.../{assumptions,results,proofs}.tex`, `notation_glossary.md` | **RE-READ IN FULL.** Conventions (P1)–(P6); `prp:compact` Steps 0–4; `lem:density`; `rem:Tcond`; `rem:draftrec`. |
| Source draft, adjoint display | `…/Nonparametric_Panel/Centorrino_panel.qmd:88–130`, `:172–177` | **RE-READ VERBATIM.** The `:172–177` display is transcribed and diagnosed below. |
| Fève & Florens (2014) | `feve2014`, verified at `…/Nonparametric_IV/instrumental.bib:349`, *J. Econometrics* 181(2), 151–164 | **NEW INPUT, supplied by the coordinator.** Prop. 2.1 (adjoint, difference-of-densities), the non-identification condition, Prop. 2.2 (identification) and the authors' own "too strong" remark. Used in `rem:nophifree`, `rem:ffcompare`, `cor:a1cprim`. |
| House style | `.claude/references/{proof-style,asymptotic-conventions,theorem-environment-style}.md` | **RE-READ.** |
| SymPy harness | `scripts/symbolic/{verify.py,README.md}`, `specs/` | **READ.** Three known defects noted by the coordinator; spec design adapted (below). |

**Missing inputs:** none blocking. `positioning.md` deliberately not opened (outside write scope).
**I could not read the Fève–Florens PDF directly** — no copy exists in the repo or in
`master_supporting_docs/`. Everything attributed to it below is attributed to the coordinator's
verified summary, and I flag each place where a claim depends on a page-level detail I have not seen.

---

## D1. Part 1 — how N-10 closed: **CONSTRUCTED**, at the price of one strengthening

### D1.1 The verdict

**N-10 is closed by construction, not by assumption.** A2′(0) is deleted from the block. The price is a
single strengthening of B1(iv.a), which is a condition on an object *the analyst chooses*, not on $P$.

### D1.2 What the obstruction actually was

$\mathcal A^\ast_{\rm cond}$ produces, in raw form, an object measurable with respect to
$\mathcal F_{XZW}=\sigma(X_1,X_2,\Delta Z,W)$:

$$\mathcal E\ell:=\int_{\IR\times\mathcal T}w(t'\Phi(\Delta Z))\,f_{\Delta U\mid\mathcal F_{XZW}}(u)\,\ell(u,t)\,\Pi(du,dt).$$

This is not a function of $(\Delta U,\Delta Z)$: the $u$ has been integrated out against $\Pi_u$ *and*
the conditional density. Round 2's A2′(0) asserted a $(u,z)$-representative into existence. That was the
gap, and it was correctly called architectural.

### D1.3 The construction

If $\Pi_u(du)=\varpi_u(u)\,du$, the $u$-integration becomes a conditional expectation:

$$\int_{\IR}f_{\Delta U\mid\mathcal F_{XZW}}(u)\,\zeta(u)\,\Pi_u(du)=E\big[\varpi_u(\Delta U)\zeta(\Delta U)\mid\mathcal F_{XZW}\big],$$

so $\mathcal E\ell=E[(\mathcal W\ell)(\Delta U,\Delta Z)\mid\mathcal F_{XZW}]$ with

$$(\mathcal W\ell)(u,z)\;=\;\varpi_u(u)\int_{\mathcal T}\ell(u,t)\,w(t'\Phi(z))\,\Pi_t(dt),$$

and the tower property then gives the closed form $\mathcal A^\ast_{\rm cond}\ell=\nu_{\widetilde W(\mathcal W\ell)}/\pi$.
`lem:adjoint`(ii) proves $\mathcal W$ bounded, $\|\mathcal W\|\le(\|\bar f_0\|_\infty\|\varpi_u\|_\infty\int\bar w^2d\Pi_t)^{1/2}$,
with dense range and $\ker\mathcal W\subseteq\ker\mathcal A^\ast_{\rm cond}$.

**Four things this buys beyond closing N-10.**

1. **A2′(0) becomes a theorem and leaves the block.** For *every* solution of the adjoint equation, the
   image $\ell_\star:=\mathcal W\ell^\Pi_\star$ is automatically square integrable and
   $\ell_\star(\Delta U,\Delta Z)$ is automatically a well-defined random variable.
2. **The correction measure $\gamma$ is identified with $\Pi_t$.** It was a free object with its own
   integrability condition; it is now the range measure's $t$-marginal, and **the first half of B1(v) is
   implied by B1(iv.c)** through Cauchy–Schwarz rather than assumed.
3. **A2 gets a primitive reading.** $\mathcal A^\ast_{\rm cond}\ell=-\nu/\pi$ is *equivalent* to
   $\nu_{\Delta Z+\widetilde W(\mathcal W\ell)}\equiv0$ — the equation the estimator actually targets.
   So A2 implies solvability of the primitive orthogonality equation. **The converse needs reachability
   ($\ell\in\mathcal R(\mathcal W)$), which is not proved**, so A2 may be strictly stronger than what the
   sieve estimator needs. Recorded, not claimed.
4. **A new selection lever, and a debt that round 3 collected.** $\partial_u(\mathcal W\ell)$ carries a
   $\varpi_u'$ term, so **the choice of $\Pi_u$ enters $\partial_u\ell_\star$, hence $q$, hence
   $\sigma_q$, hence `prp:sharpquad`'s sharp constant.** $\Pi_u$ is a third design lever alongside the
   selection of $\ell^\Pi$ within its affine set. **Round 3 (MAJ-4) found the debt this created**: the
   round-2 B1(iv.a) gave $\varpi_u$ no smoothness, so $\partial_u\ell_\star$ need not have existed and
   A2′(i) bounded the derivative of an object the block did not deliver. B1(iv.a) now requires
   $\varpi_u\in C^1$ with $\|\varpi_u'\|_\infty<\infty$, and the two-term formula is `eq:Wderiv`. **The
   lever is now a theorem rather than an aspiration**, and the defect was invisible before N-10 closed,
   because A2′(0) made $\ell_\star$ primitive.

### D1.4 The price, stated honestly

B1(iv.a) now reads: $\Pi_u$ finite, **absolutely continuous with a density $\varpi_u$ that is bounded,
everywhere strictly positive, and continuously differentiable with bounded derivative**. This **implies**
the round-2 full-support clause, so `lem:bierens` Step 5 — the only consumer of the round-2 form — is
unaffected, and no existing proof changes. What it excludes is a Lebesgue-singular $\Pi_u$ with full
support, and a non-smooth density. Since $\Pi_u$ is a reference measure on the range side, chosen exactly
as $\Phi$ and $w$ are, any logistic/Gaussian/Cauchy $\Pi_u$ satisfies **all four clauses** and every
implementation already uses one.

**Two things this strengthening does NOT reach**, and conflating them with it understates both.
`prp:kerchar` and `cor:a1cprim` use no clause of B1(iv.a) beyond the round-2 full-support one, and only
through `lem:bierens` Step 5; they **survive a complete rollback**. And `lem:bierens` itself is untouched
in either direction.

**I record the alternative I rejected.** One could keep B1(iv.a) as it was and retain A2′(0). Then
`lem:adjoint` would have only its kernel form, `prp:orthog` at Step 5 would have to be posed in
$\mathcal F_{XZW}$-measurable objects rather than in $(\Delta U,\Delta Z)$-measurable ones, and the
moment function $\psi=\Delta Z\Delta U+\widetilde WL(\Delta U,\Delta Z)$ — which is
$(\Delta U,\Delta Z)$-measurable *by construction of the estimator* — would not be the object the theory
governs. **That is not a weaker assumption; it is a different and worse architecture.**

### D1.5 Consistency with `rem:Tcond` — amended, not moved

`rem:Tcond` said the estimator "solves for $L$, so no $t$-integral survives" and that $\gamma$ "enters
only if one insists on the integral representation." **The first half stands; the second is now wrong in
one direction.** The remark is amended to separate the two sides:

- **Estimation side, unchanged:** the sieve solves for $\hat L$ directly; no $t$-integral is computed;
  no weighting measure is chosen; the anti-CGMM argument survives intact.
- **Population side, corrected:** the integral representation is *not* optional — it is `lem:adjoint`(ii)
  and it is what makes the representer evaluable.
- **What reconciles them:** `lem:adjoint`(ii)'s density claim. The Bierens family and the sieve have the
  same closure, so the estimator may search the larger class without losing the population object.

`rem:Tcond` stays where it is.

---

## D2. Part 2 — what Step 3 delivered

| Label | Environment | Content | Assumptions used |
|---|---|---|---|
| `lem:nusigma` | Lemma (L-1) | $\|\Delta h\|\le2\bar c_\pi^{1/2}\|h\|$; $\ker\Delta=$ constants; the $\nu_g$ pairing; $\int\nu_g=0$ **and** $\int\sigma_g=2E[g]$; and $\int\sigma_g=0$ under A1 for $g=\widetilde W\Xi$ | C1(ii); **A1b(ii)** for (ii); A1 for (v) — *round 8: A1b(i) struck, the ``constant hence zero'' step is `def:spaces`; and the generic integrable function is $\Xi$, not $\vartheta$, per C25* |
| `lem:adjfubini` | Lemma (L-4) | the adjoint-direction interchange, with the envelope $2\bar c_\pi^{1/2}\|\bar f_0\|_\infty c_\Pi\|h\|\|\ell\|$ | B1(i),(ii),(iv.c), C1(ii), C2′(i) |
| `lem:levels` | Lemma (L-5) | $\mathcal D^{-1}_0$ bounded and injective, $\mathcal D$ unbounded; $\mathcal N_g\equiv0\iff\nu_g\equiv0$; **A2 is parameterisation-free**; the rate condition is not, and levels is weaker | A0 (compact **interval**), C1(ii) — *round 8: A1b(i) struck; it appeared in the hypothesis line and nowhere in the proof* |
| `lem:adjoint` | Lemma | (i) kernel form; (ii) $\mathcal W$ bounded, dense range, $\ker\mathcal W\subseteq\ker\mathcal A^\ast$; (iii) $\mathcal A^\ast_{\rm cond}\ell=\nu_{\widetilde W(\mathcal W\ell)}/\pi$ | B1(i),(ii),(iv), C1, C2′(i) |
| `prp:nophifree` | Proposition (R2) | $\varphi$-free $\iff$ $\nu_g\equiv0$ $\iff$ the $g$-tilted marginals coincide | C1(ii) — *round 8: A1b(i) struck; Step 3 cites `def:spaces` and `lem:nusigma`(iv), and $\vdagger$ occurs nowhere* |
| `cor:udep` | Corollary (O-11) | $\partial_u\ell\equiv0$ $\Rightarrow$ $\psi=g\Delta U$ with $g$ $(W,\Delta Z)$-measurable; (a)$\iff$(b)$\iff$(c); contrapositive forces $\partial_u\ell_\star\not\equiv0$ | A1, A1b(i), A1b(iv), N1, C1(ii) |
| `prp:kerchar`(i) | Proposition | **ADDITIVE.** $\ker\mathcal A_{\rm cond}=\{h:E[\widetilde W\Delta h\mid\Delta U,\Delta Z]=0\}$ | B1(i)–(iv), C1, C2′(i) — **neither A1 nor A4(i)** (m-7) |
| `prp:kerchar`(ii) | Proposition | the cell-conditional form of the same condition | **+ A1, A4(i)**, and only here |
| `cor:a1cprim` | Corollary | **ADDITIVE.** A1d + A1b(ii) $\Rightarrow$ A1c | B1(i)–(iv), C1, C2′(i), **A1b(ii)**, A1d — **and nothing else** — *round 8: A1b(i) struck; it was inherited via `lem:nusigma`(ii) and resolves with that redirect* |

Two new standing conventions, both in the proofs header: **(P4c)**, the A1-licensed extension of the
binary identity from $\sigma(\Delta Z)$ to $\sigma(\Delta U,\Delta Z)$ (explicitly *not* to
$\mathcal F_{XZW}$, where (P4b)'s counterexample still bites); and **(P7)**, the $\varpi_u$ bookkeeping.

### D2.1 The reconciliation with draft `:172–177` — **three defects, not two**

**What the display means.** Reading left to right: the outer $\int\tilde\varphi'(v)\pi(v)dv$ is the
$L^2(\pi)$ pairing; everything right of it is $(\mathcal A^\ast\ell)(v)$; the inner braces are $\nu_g(x)$
(the $\xi$-integration of a conditional expectation against $f_{X_1,X_2}$ marginalises the other period
out, which is exactly the definition of $\nu_g$); and $\un(x\ge v)$ is $\mathcal D^{-1}$, present because
the draft parameterises in derivatives.

**What it should have said:** the operator, $\mathcal A^\ast_{\rm cond}\ell=\nu_{\widetilde W\mathcal W\ell}/\pi$.

| # | Defect | Diagnosis |
|---|---|---|
| 1 | $\pi(v)$ in both numerator and denominator | **Category error, not a cancellation error.** The display writes the *pairing*, in which the inner product contributes $\pi$ and the adjoint contributes $\pi^{-1}$. **The two do cancel, and that is the trap**: a reader who cancels concludes the $L^2(\pi)$ weighting is immaterial, when the surviving $\pi^{-1}$ in the *operator* is why A2 sits on $\nu/\pi$. |
| 2 | a $\theta$ subscript appearing nowhere in the expression | **Correct, but the round-2 diagnosis was incomplete.** The $\theta$ subscript is genuinely vacuous (`lem:shiftinv` says why) and should be dropped. **The $\varphi$ subscript is *not* vacuous**, and the display suppresses it wrongly by writing $f_U(u)$ where `:124–126` writes the density at $\varphi(x_2)-\varphi(x_1)+u$; `prp:frechet`(ii) shows the $\varphi$-dependence is real. Writing $f_U(u)$ makes both subscripts look idle when only one is. |
| 3 | **no $u$-integration** — NEW | The integrand carries a free $u$ inside $\psi(u,1)-\psi(u,0)$ and integrates only over $(x,\xi,v)$: **the left side is a function of $u$, the right side a number.** The missing object is the range measure. This also explains the $W$-argument mismatch between `:124–126` (already differenced over $W$, a function of $u$ alone) and `:172–177` (a $\psi(u,w)$): with no range measure fixed, the two displays silently use different range spaces. |

### D2.2 `rem:nophifree` and O-11's corollary

`prp:nophifree` is stated as a **proposition with a proof**; `rem:nophifree` survives as the remark that
follows it (house style: remarks after proofs). Both labels exist, each on the right environment.

**The proof is three lines and the third is the one that matters.** Constancy in $\varphi$ makes
$\nu_g/\pi\perp\mathcal V$; `def:spaces` gives $\mathcal V^\perp=\{\text{constants}\}$; and
`lem:nusigma`(iv) gives $\int\nu_g\,dx=0$, which forces the constant to be **zero**. So the conclusion is
$\nu_g\equiv0$ *exactly*, not "up to a constant" — and A1b(i) is what buys the exactness.

**Two interpretable special cases**, both worth a sentence in the paper: $g\equiv1$ gives marginal
stationarity of $X$; $g=\Delta Z_j$ gives $\nu\equiv0$, which is probe CP-1.

**O-11's corollary, stated cleanly.** If $\ell$ is constant in $u$ then N1 plus $E[\Delta U\mid\Delta Z]=0$
force $L(u,z)=c(z)u$ and $\psi=\{\Delta Z+\widetilde Wc(\Delta Z)\}\Delta U$ — a $(W,\Delta Z)$-measurable
weight. Then first-order insensitivity, exact $\varphi$-freeness, and $-\nu\in\mathcal N_0$ are all the
same statement, and $Q\equiv0$. **Contrapositive: if $-\nu\notin\mathcal N_0$ then
$\partial_u\ell_\star\not\equiv0$.**

**Where I declined to overclaim, and this is deliberate.** The memo's O-11 says "hence
$\partial_u\ell_\star\ne0$ and $Q(h)\ne0$ *necessarily*". **The second half does not follow from the
first.** $Q$ is governed by $q=E[\widetilde W\partial_u\ell_\star\mid X_1,X_2]$, and
$\partial_u\ell_\star\not\equiv0$ does not preclude $q\equiv0$ by cancellation inside the conditional
expectation. `cor:udep` therefore delivers exactly the necessary condition and stops; $q\not\equiv0$ is
`prp:sharpquad`'s own hypothesis (O-16) and probe CP-12's subject. **The chain "impossibility $\to$
quadratic remainder $\to$ $n^{-1/4}$" is real, and it has one link that is an assumption rather than a
theorem. Saying so is what makes the rest of it credible.**

I also sharpened the escape route into a checkable form: $\partial_u\ell_\star\equiv0$ is possible **only
if $-\nu\in\mathcal N_0=\{\nu_{\widetilde Wc(\Delta Z)}:c\}$** — a range condition of the same kind as A2
but on the far smaller set of residual-free representers. And $\mathcal N_0=\{0\}$ whenever
$W\upmodels(X_1,X_2)\mid\Delta Z$, which is the instrument-irrelevance condition `rem:draftrec`(ii)
rejects; so under relevance $\mathcal N_0$ is nontrivial and membership must be *checked*, not assumed
away.

### D2.3 The Fève–Florens material

**Item 1 — R2 is a recognised feature of the design, and the citation is exact.** Their non-identification
condition, $\mathrm{law}(X_1,W)=\mathrm{law}(X_2,W)$, is \eqref{eq:tilted} imposed simultaneously for every
bounded $g=g(W)$, because $\nu_{g(W)}(x)=\sum_j g(j)\{f_{X_2,W}(x,j)-f_{X_1,W}(x,j)\}$. Their Prop. 2.1's
adjoint is an integral against that same difference of joint densities — the $\nu_g$ structure, reached
independently. **What R2 adds:** the one-weight-at-a-time equivalence, and the enlargement of $g$ from
functions of $W$ to functions of $(W,\Delta Z)$, which is the class the construction searches.

**The sharper distinction, used in `lem:adjoint`'s discussion.** Not "theirs is linear." Rather:
$\mathcal A_{\rm cond}$ is a **Fréchet derivative of a nonlinear map** rather than a fixed linear
conditional-expectation operator, and three things follow that have no counterpart there — the operator
depends on the linearisation point (`prp:frechet`(ii)); the sample operator is noisy *as an operator*
(hence A6/A7 for $\hat T$); and the moment carries a second-order term in $\varphi$ (`cor:udep`).

**Item 2 — does Prop. 2.2 adapt? BOTH ANSWERS, and they land in different places.**

- **YES, to A1c.** Their two primitives become A1d (instrument completeness given the residual) and
  A1b(ii) (measure separability), and `cor:a1cprim` runs the argument. **This is a real gain**: A1c had
  no primitive route, and the round-2 comment on A1c listed five ingredients as unavailable for bridging
  the draft's conditional-mean display to the operator form. `prp:kerchar` proves the equivalence, and
  the draft's `eq-condcomppanel` at `:127–130` is thereby repaired, with two corrections: the
  conditioning set must include $\Delta Z$, and the statement is about the linearisation.
  **CORRECTED IN ROUND 3 (MAJ-3).** A first version of this paragraph said the fifth ingredient — a
  declared reference measure on $(u,z)$ — was supplied by the strengthened B1(iv.a). **That is false.**
  `prp:kerchar` never uses $\varpi_u$: its clauses are stated $P$-almost surely and the reference measure
  is $P_{\Delta U,\Delta Z}$, which is available unconditionally. B1(iv.a) enters only through
  `lem:bierens` Step 5, and only in its round-2 full-support form. **The true statement is stronger:
  `prp:kerchar` and `cor:a1cprim` survive a complete rollback of the B1(iv.a) strengthening.** The A1c
  bridge and the N-10 closure are independent results that happened to be proved in the same dispatch,
  and tying them together understated both.
- **NO, to A1b(iii), and the obstruction is nameable.** In their model the restriction is a conditional
  *mean* and the operator is linear in $\varphi$, so $\ker K=\{0\}$ **is** identification. Under
  conditional independence the operator equation is nonlinear and the two separate. Precisely: membership
  of $\mathcal V_{CI}$ is the family $E[\widetilde W\varsigma(\Delta Y-\Delta\varphi)\mid\Delta Z]=0$
  indexed by test functions of the **observed** residual; running `prp:kerchar` globally would need the
  strictly larger family $E[\widetilde W\varsigma(\Delta Y-\Delta\varphi)\varkappa(\Delta U)\mid\Delta Z]=0$,
  indexed also by test functions of the **true** residual — which is not observed at a trial $\varphi$
  and about which the restriction says nothing. The two families coincide at $\varphi=\vdagger$ and
  nowhere else. `prp:compact` closes the obvious repair: compactness means $\mathcal A_{\rm cond}$ is not
  bounded below, so A1c gives no neighbourhood of uniqueness.
- **And the "too strong" remark is the citable precedent.** Fève & Florens say of their own Prop. 2.2's
  hypothesis that it is too strong. So the honest primitive is *already* demanding in the linear case,
  where the operator is fixed and the restriction is a conditional mean. **That makes recording A1b(iii)
  as an assumption defensible rather than lazy**, and it is how the paper should present it: not "we
  could not find a primitive", but "the primitive is known to be demanding in the linear special case,
  and the nonlinearity introduced by conditional independence separates it from the linearised condition
  that the primitive does deliver."

### D2.5 The two verified quotations — **N-14 closed, and one is a striking confirmation**

**Proposition 2.1's denominator is $\pi(z)$, and the normalisation is stated.** Verbatim,
$(K^\ast\psi)(z)=\int\psi(w)\{f_{Z_2,W}(z,w)-f_{Z_1,W}(z,w)\}/\pi(z)\,dw$, followed immediately by
"*and $K^\ast\psi$ satisfies the normalizing constraint $\int[(K^\ast\psi)(z)]\pi(z)\,dz=0$*."

**This is independent confirmation of the round-1 correction that M-1 forced.** Round 1 imposed the
source condition on $\nu$; the move to $\nu/\pi$ was forced by an internal Picard membership test, and
`prp:compact` Step 2 supplies the membership by proving $\int\nu_g\,dx=0$ at $h\equiv1$. **Both features
— the $\pi^{-1}$ and the zero $\pi$-mean — appear in print, in the same form, in the linear case, with
the same letter $\pi$** (which the draft takes from them at `:172`). So the referent is not an artefact
of this project's $L^2(\pi)$ convention; it is the shape the adjoint takes in a first-differenced panel.
Folded into `lem:adjoint`'s discussion as `rem:adjointreconcile`(iv), with the scope stated: what
transfers is the *shape*, not the operator, and the induction map $\mathcal W$ has no counterpart there
because their restriction is already unconditional in the residual.

**Proposition 2.2 verbatim** confirms A1d's shape, and their rejection sentence is better than the
generic difficulty claim I wrote first: "*The assumption of Proposition 2.2 is too strong because it
assumes that $E(g(Z_1,Z_2)\mid W)=0$ implies $g(Z_1,Z_2)=0$ a.s. **for any $g$**, and we only use this
property for $g(Z_1,Z_2)$ of the form $\varphi(Z_2)-\varphi(Z_1)$.*"

**A1d reproduces that excess exactly**: it quantifies over every $\Lambda\in L^2(P_{X_1,X_2})$ while
`cor:a1cprim` consumes it only at $\Lambda=\Delta h$, a difference. `rem:ffcompare` is rewritten around
this, and I added the structure that unifies it with my own obstruction, since the two are not the same
statement and should not be run together:

> **In both designs the restriction supplies fewer moment conditions than the identification argument
> consumes.** There: completeness on all $g$, while first differencing delivers information only about
> differences. Here: `prp:kerchar` run globally would need the $(\varsigma,\varkappa)$ product family,
> while conditional independence delivers only the $\varsigma$ family.

That says *where a future improvement would have to act* — not by strengthening the completeness
condition but by finding a restriction stated over exactly the class used — which a generic "the
primitive is hard" sentence does not.

**Also pinned.** Their non-identification condition is **exchangeability**, $(Z_1,Z_2,W)\sim(Z_2,Z_1,W)$,
which implies the equal-marginals form; `rem:nophifree`(ii) now states theirs and notes that theirs is
the *simultaneous* condition over all $g=g(W)$ and correspondingly stronger than `prp:nophifree`'s
one-weight-at-a-time equivalence. Their Gaussian characterisation of strong identification is a concrete
instance available for the application section; **not used here**, since nothing in Step 3 needs it.

### D2.4 The SymPy specs (memo §10 Step-3 gate)

Thirteen specs written under `scripts/symbolic/specs/`. **All scalar-form except one**, per the coordinator's
warning that `verify.py` crashes on symbolic matrix shapes with exit 1 — indistinguishable from a genuine
MISMATCH — and reports MISMATCH on `ZeroMatrix` differences.

| Spec | Checks |
|---|---|
| `adjoint-pi-cancellation` | the $\pi/\pi^{-1}$ cancellation, so "category error, not cancellation error" is checkable |
| `adjoint-transpose-pairing` | the adjoint regrouping, in a two-point finite model with $\pi$- and $\Pi$-masses carried explicitly |
| `adjoint-W-measure-change` | the one line of algebra the $\varpi_u$ step reduces to — the load-bearing use of the strengthened B1(iv.a) |
| `adjoint-Wnorm-constant` | the constant in $\|\mathcal W\|$; catches a squared $\varpi$ |
| `p4c-extended-binary` | (P4c), the A1-licensed enlargement, with the contrast to `kernelcompare-tower` named |
| `r2-phi-linear-part` | the affine structure in $\varphi$ and the $\theta$-independence |
| `r2-nug-linearity` | (a)$\iff$(c) of `cor:udep` |
| `o11-N1-forces-b-zero` | Step 1 of `cor:udep`, isolated because it is the only step consuming A1's second clause |
| `o11-moment-collapse` | the collapse to a $(W,\Delta Z)$-measurable weight |
| `jacobian-scalar-chain` | the $\theta$-chain rule with $\ell$ genuinely varying in $u$ |
| `jacobian-sign-convention` | that $J=-E[\partial_\theta\psi]$, so a later sign flip is caught |
| `jacobian-dims-numeric` | **the only matrix spec.** Numeric shapes ($p=3$). **Treat its verdict as advisory.** |
| `levels-tail-integral` | `lem:levels`(ii)'s sign and limit of integration |

The grammar has no generic `Function`, so `jacobian-scalar-chain` instantiates
$L(u,z)=\ell_0u+\ell_1u^2/2$; that is faithful for its purpose (chain-rule bookkeeping and sign) and it
keeps $\ell$ $u$-varying, which is the case `cor:udep` says is the relevant one.

**Execution status.** SymPy 1.14.0 is now installed, but **this dispatch has no execution tool** — the
theorist's toolset here is read/write/search only. I therefore did the next best thing: I read
`verify.py` in full and validated every spec statically against its *actual* parser and comparison
logic, rather than against the README. That found two name hazards, both fixed:

- `adjoint-W-measure-change` declared a variable named `S`. `parse_with` layers `local_dict` over
  SymPy's global namespace, in which `S` is the **singleton registry**. The shadowing resolves in the
  spec's favour today but is version-fragile. Renamed `Sell`.
- `o11-moment-collapse` carried a decorative `+ 0*EdU` term that evaluates away at parse time, leaving a
  declared-but-unused variable. Removed; the A1 clause it gestured at is discharged by
  `o11-N1-forces-b-zero`, which is the spec that actually consumes it.

**Predicted verdicts**, derived from `reduce_to_zero`'s battery (`simplify, expand, trigsimp, radsimp,
together, cancel`, then `simplify(expand(·))`): **twelve MATCH (exit 0)**; **`jacobian-dims-numeric`
MISMATCH (exit 1), and the mismatch is false.** Its difference reduces to `ZeroMatrix(3,3)`, for which
`r == 0` is `False` and `r.equals(0)` routes through `as_explicit()` — the harness's first documented
defect exactly. Numeric shapes avoid the second defect (the exit-1 crash on symbolic shapes), so the run
will terminate; the verdict must still be read as advisory. **Every one of the twelve scalar specs
avoids matrix objects entirely, by design.**

**ROUND-3 OUTCOME: the coordinator ran all thirteen. Twelve MATCH; `jacobian-dims-numeric` returned the
false MISMATCH, as predicted.** No deduction was taken for it, and the harness has since been repaired
(both the `ZeroMatrix` defect and the symbolic-shape crash), with the full 73-spec suite reporting 71
MATCH, 2 by-design rounding probes, 0 crashes. **The static validation substituted for execution
correctly**, which is worth recording: reading the harness's comparison logic rather than its README is
what made the prediction exact, and it is what caught the two name hazards before the run.

---

## D3. Findings — dispatch 2

| # | Finding | Disposition |
|---|---|---|
| **F-15 (new, and it is a real error)** | **$L$ and $\ell$ are typed as scalars while $\psi$ is typed $\IR^p$-valued. Those cannot both hold.** $\psi=\Delta Z\Delta U+\widetilde WL$ adds a $p\times1$ vector to $L$; $J=E[\Delta Z\Delta Z']+E[\widetilde W\ell_\star\Delta Z']$ adds a $p\times p$ matrix to a $1\times p$ row unless $\ell_\star$ is $p\times1$. | **APPLIED.** $L,\ell,\ell_\dagger,\ell_\star,c$ retyped $\IR^p$-valued (glossary C18, §8.4). **A2's own wording already implies it** ("each coordinate of $\nu/\pi$"), so no assumption changes. Step 3's statements are written for a scalar coordinate and applied coordinatewise; every proof step is linear in the index. **Binding on Step 4:** $q$ and $\sigma_q$ are $\IR^p$-valued, so `prp:sharpquad` must be stated for a fixed direction ~~$\varsigma'\psi$~~ **$\vartheta'\psi$ with $\|\vartheta\|=1$ (round-7 postfix correction in place: $\varsigma$ is a reserved *local* bound variable and cannot be made binding — C25. Third and last copy of this string; the other two were `notation_glossary.md` C18 and the $\sigma_q$ row)**. Found by the dimension spec. |
| **F-16 (new)** | **Draft `:172–177` has a third defect: no $u$-integration.** The left side is a function of $u$, the right side a number. | **APPLIED** in `rem:draftrec`(iii). It also explains the $W$-argument mismatch with `:124–126`. |
| **F-17 (new)** | **The $\varphi$ subscript in the draft's adjoint is not vacuous, and calling both subscripts vacuous was wrong.** The display writes $f_U(u)$, suppressing a real dependence that `prp:frechet`(ii) quantifies. | **APPLIED** in `rem:draftrec`(iii). Round 2's diagnosis is corrected, not withdrawn: the $\theta$ subscript *is* vacuous. |
| **F-18 (new)** | **The memo's O-11 overclaims by one link.** "$\partial_u\ell_\star\ne0$ and $Q(h)\ne0$ necessarily" — the second does not follow, since $q=E[\widetilde W\partial_u\ell_\star\mid X_1,X_2]$ can vanish by cancellation. | **NOT APPLIED to the memo (outside write scope); `cor:udep` states only what follows.** $q\not\equiv0$ is `prp:sharpquad`'s hypothesis O-16, not a consequence of O-11. **Escalated as N-13.** |
| **F-19 (new, favourable)** | **B1(v)'s first half is now a consequence, not an assumption.** With $\gamma=\Pi_t$ (forced by `lem:adjoint`(ii)), $\int\bar w\,d\Pi_t\le(\Pi_t(\mathcal T)\int\bar w^2d\Pi_t)^{1/2}<\infty$ by Cauchy–Schwarz and B1(iv.c). | **APPLIED** in `rem:Tcond`. B1(v) is retained as written because its *second* half (the $\partial_u\lambda$ dominating function) is independent and still needed. |
| **F-21 (new, self-caught)** | **My own first draft of `lem:adjoint`(ii)'s density argument was wrong.** It placed $\ell_\epsilon=\varpi_u^{-1}\varsigma\cdot(\ldots)$ in $L^2(\Pi)$ on the ground that "$\varpi_u$ is bounded below on the compact support of $\varsigma$". B1(iv.a) makes $\varpi_u$ **strictly positive pointwise**, which for a merely measurable density does **not** give a positive infimum on a compact set, so $\varpi_u^{-1}$ need not be integrable against $\varsigma^2$. | **REPAIRED, without strengthening B1(iv.a) further.** The generating family is reduced to $\varsigma$ supported in $S_k=\{\varpi_u\ge1/k\}$; since $\varpi_u>0$ everywhere, $\bigcup_kS_k=\IR$ and a dominated-convergence step shows the reduced family still has dense span. Then $\|\ell_\epsilon\|^2_{L^2(\Pi)}\le k\,\Pi_t(B_\epsilon)^{-1}\|\varsigma\|^2_{L^2}<\infty$ explicitly. **The alternative — assuming $\varpi_u$ continuous, or bounded below on compacts — was rejected**: it is a further restriction where none is needed. |
| **F-20 (new, and SHARPENED in round 3)** | **A2 may be strictly stronger than the estimator needs.** Round 2 recorded this and priced it as needing $\mathcal R(\mathcal W)$ characterised. **That over-priced it.** $\mathcal B\Xi:=\nu_{\widetilde W\Xi}/\pi$ is *bounded*, with $\|\mathcal B\|\le2\bar c_\pi^{1/2}$ from `lem:nusigma`(i) and (iii), and $\mathcal A^\ast_{\rm cond}=\mathcal B\circ\mathcal W$; so density of $\mathcal R(\mathcal W)$ alone gives $\mathcal R(\mathcal A^\ast_{\rm cond})\subseteq\mathcal R(\mathcal B)\subseteq\overline{\mathcal R(\mathcal A^\ast_{\rm cond})}$. | **UPGRADED FROM A MEMO NOTE TO A PROVED COROLLARY**, `cor:rangegap`. The gap between A2 and the equation the estimator targets is confined to $\overline{\mathcal R(\mathcal A^\ast_{\rm cond})}\setminus\mathcal R(\mathcal A^\ast_{\rm cond})$ — **nonempty under H1**, since an injective compact operator of infinite rank has non-closed range, and precisely where the ill-posedness lives. **No characterisation of $\mathcal R(\mathcal W)$ is needed.** Credit: the theorist-critic. |
| **F-22 (new)** | **`cor:udep`'s three-way equivalence was false in one direction.** Clause (c) as printed was existential over $\tilde c$; (a) and (b) concern the given $c$. | **APPLIED.** (c) restated at the given $c$. The downstream use only ever travelled (a)$\Rightarrow$membership, so no consequence changes — but the printed statement claimed more than the proof delivered, and the concluding sentence about the second-order term sat behind the false direction. |
| **F-23 (new)** | **The $\varphi$-subscript asymmetry in `rem:draftrec`(iii) contradicted `rem:R1`(iv) in the same file.** Both $\theta$ and $\varphi$ enter `eq:Adef` as shifts. | **APPLIED.** F-17 (round 2) is **partly withdrawn**: its conclusion — that the display suppresses a real $\varphi$-dependence by writing $f_U(u)$ — stands, but the claim that $\theta$'s subscript is vacuous while $\varphi$'s is not does not. The *solution set* is $\theta$-free (`lem:shiftinv`); the *operator* is not (`rem:R1`(iv)). |

---

## D4. Escalations — dispatch 2

| # | Item | What I did | What I need |
|---|---|---|---|
| ~~N-10~~ | $\ell_\star$'s two domains | **CLOSED BY CONSTRUCTION.** `lem:adjoint`(ii)–(iii); A2′(0) deleted; B1(iv.a) strengthened. | **Coordinator to note that B1(iv.a) changed.** The change is a strengthening on a chosen object and implies the old clause, so no proof is invalidated — but the assumption-auditor should see it declared. |
| **N-11 (new)** | **`rem:nophifree` is registered in plan §2.7 as a *remark*, but its content is an *iff* with a proof.** House style forbids proofs inside remarks and requires one result per environment. | Stated the formal result as `prp:nophifree` (proposition, proved) and kept `rem:nophifree` as the remark that follows it. **Both labels exist**; nothing in the contract breaks. | **Coordinator may wish to amend plan §2.7** to register the target as `prp:nophifree` with `rem:nophifree` as its companion. Not executed — it is a plan claim. |
| **N-12 (new)** | **`prp:kerchar`, `cor:a1cprim`, `rem:ffcompare` are ADDITIVE targets not in plan §2.7.** They are the deliverable of the dispatch's Fève–Florens item 2, they are not downstream of Step 3 (nothing consumes them), and they discharge an open item in A1c's comment. | Written and flagged. Nothing downstream depends on them; deleting them costs only the A1c primitive. | **Coordinator to accept or reject.** If accepted, add `prp-kerchar.tex` to plan §2.7. I did not want to write them silently. |
| **N-13 (new)** | **Memo §5 O-11 and §0.1's one-paragraph story assert "$Q(h)\ne0$ necessarily", which does not follow.** | `cor:udep` states only the necessary condition; the memo's phrasing is untouched (outside write scope). | **Coordinator to amend memo §5 O-11 and §0.1** to "hence $\partial_u\ell_\star\not\equiv0$, which is necessary for $Q\not\equiv0$; sufficiency is `prp:sharpquad`'s hypothesis O-16." |
| ~~**N-14**~~ | Fève & Florens (2014) not in the repo. | **CLOSED by the coordinator**, who read both details from the PDF. **Both attributions confirmed, and Prop. 2.1's denominator is $\pi(z)$** — see D2.5. | — |
| ~~**N-15**~~ | SymPy not installed. | **CLOSED** — SymPy 1.14.0 installed. | — |
| ~~**N-16**~~ | Theorist has no execution tool; specs unrun. | **CLOSED for dispatch 2.** The coordinator ran all thirteen: twelve MATCH, `jacobian-dims-numeric` the predicted false MISMATCH. Harness since repaired. | — |
| **N-18 (new, and it is a memo claim)** | **`proof_strategy_memo.md` §3.7 mis-prices both sieve options, in opposite directions.** (a) It gives option (i) "no unproven inputs beyond standard sieve approximation" — but `lem:balance`(iii)'s approximation step is applied to $h=\hat\varphi-\vdagger$, an **LF iterate**, whose $H^s$ norm is not controlled by the source condition on $\vdagger$. That is the same uniform-Sobolev-stability input §3.7 assigns only to option (ii). (b) Against that, the **rate route needs no sieve condition at all** — not even A8's lower end — because $\|(I-P_{L_x})h\|\le\|h\|$ plus A5(iv) already gives $o_P(n^{-1/2})$. **Consequence: A5(iv) and A8 are ALTERNATIVE sufficient conditions for the first-order bias, not cumulative ones**, and the block currently reads as though both are required. A8's *upper* end survives in both routes (conditioning of the solve; L-13). | Stated both routes explicitly as `lem:balance`(ii) and (iii), each with its own hypotheses, and recorded the finding in a comment block in `proofs.tex`. **Not applied to the memo — outside my write scope.** | **Coordinator to amend memo §3.7's option table** and to decide whether A8 stays maintained or becomes an alternative. A8's comment already anticipated this ("the $s>1$ requirement may relax; that refinement belongs to `prp:orthog`"), so this is the anticipated refinement arriving, not a new problem. |
| **N-20 (new — a plan-order question, raised rather than acted on)** | **The dispatch asked for "Step 4 — memo §10" but listed L-16, `prp:orthog`, L-6, L-7, which is memo §10 **Step 5**. Step 4 is `prp:sharpquad` + L-20 + **L-21**.** I delivered the content requested. But memo §10 Step 4 carries an explicit ordering instruction: *"Do this before `prp:orthog` — it determines the scope, and **L-21's primitives are what make A2′ statable**."* That instruction now bites harder than when it was written: round 4 restated A2′(i) on $\ell^\Pi_\star$ as (i.a)/(i.b), and **L-21 is precisely the route to those two clauses** — so `eq:Wderiv`, `cor:elldiff`, and hence the $\|\partial_u\ell_\star\|_\infty$ that `lem:secondord`(i) and `lem:solset`(iii) consume, all rest on an undischarged primitive. `prp:sharpquad` also fixes `thm:rootn`'s scope, which `lem:balance`'s two routes will inherit. | Delivered Step 5 as requested; stated every hypothesis explicitly so nothing is hidden; flagged rather than reordered. | **Coordinator to confirm the intended order.** Either (a) Step 4 was deliberately deferred and the ordering instruction in memo §10 should be struck, or (b) Step 4 should run before Step 5's results are relied on downstream. **I have no view on which — it is a plan decision — but the two cannot both stand as written.** |
| **N-19 (new)** | **The theorist still has no execution tool**, so the six new Step-5 specs are unrun. | Written to the harness's grammar and validated statically against `verify.py` as before; all six are scalar-form. **Predicted: six MATCH.** All are polynomial identities in the harness's decidable fragment — `expand` suffices for four, `diff` for two — with no matrix objects, no `Function`, and no name shadowing SymPy's global namespace. | **Run `python3 scripts/symbolic/verify.py` on `orthog-phi-derivative`, `orthog-L-exactness`, `orthog-rho-N1`, `orthog-secondorder-six`, `orthog-Ldirection-crossterm`, `adjoint-BW-factorisation`.** The last is the $\mathcal B\circ\mathcal W=\mathcal A^\ast$ spec the critic asked for, in the two-point finite model. |
| **N-17 (CORRECTED in round 4 — the round-3 version of this row was wrong, and it is the row that was transcribed)** | **`prp:kerchar` and `cor:a1cprim` are independent of the B1(iv.a) strengthening. `cor:rangegap` is NOT** — it is a corollary to `lem:adjoint`(ii)–(iii), which *are* the N-10 closure: without absolute continuity of $\Pi_u$, $\mathcal W$ has no definition, the norm bound has no $\|\varpi_u\|_\infty$, and the density argument has no $\varpi_u>0$. Roll B1(iv.a) back and `cor:rangegap` does not weaken — **it ceases to have a subject.** It is independent of the round-3 $C^1$ clause only. | The `.tex` files and memo §§D1.4/D2.3 always had this right; only this row was wrong, and I wrote it. Corrected here. | **Nothing further needed** — the coordinator has already corrected plan §2.7. Recorded so the trace shows where the error entered: I generalised from a verified two-item re-trace to a third item I had not re-traced. **The lesson is narrow and worth keeping: an escalation row is a claim, and it needs the same verification as a claim in a proof.** |

---

## D5. What remains open after dispatch 2

Carried from Part I §5, with status:

1. **A1b(iii) has no primitive route.** **STILL OPEN, but now differently.** The Fève–Florens route was
   tried and lands on A1c, not on A1b(iii); the obstruction is named (D2.3) and there is a citable
   precedent that the primitive is hard even in the linear case. **The gap is now documented rather than
   merely recorded.**
1b. **A1c does not give local uniqueness.** **UNCHANGED** — structural, from compactness.
   **But A1c now has a primitive** (A1d, via `cor:a1cprim`) and is now *equivalent* to the draft's
   conditional-mean display (`prp:kerchar`).
2. ~~**A2′(i) is unverifiable until L-21, and L-21's target has been RAISED (M-1).**~~ **CLOSED IN
   ROUND 9.** L-21 is `lem:reprsmooth`, on the property tag **A2c**, and it delivers **the sup-inside
   form** $\int_{\mathcal T}\sup_u|\partial_u\ell^\Pi_\star(u,t)|\bar w(t)\Pi_t(dt)<\infty$ — the raised
   target, met and not approximated, because A2c is stated in the *same* $\bar w$-weighted $L^1(\Pi_t)$
   geometry, so `eq:embed` is slicewise and no supremum crosses the $t$-integral. **What survives as open
   is smaller and should be stated as such:** A2c is itself a condition on $\ell^\Pi_\star$, which the
   model and the selection determine jointly, and `lem:reprsmooth` does not derive it. It is *checkable*
   — a weighted summability condition on the $u$-frequency content of the slices, reportable like A2's
   Picard sum — and it is *one* condition on *one* object where there were two primitives with no route.
   **(O1) is DISCHARGED; three of four obligations remain open.**
3. ~~`lem:adjoint`'s closed form~~ **CLOSED.**
4. **C5′(ii) conservative** — Step 6. 5. **Sieve window lower end** — Step 5.
6. **B1(vi)'s consequence unproved** — Step 6. 7. **A6 for the random operator** — Step 6.
8. **$\mathcal R(\mathcal W)$ is not characterised.** Dense, possibly proper. **Round 3 removes the
   F-20 half of this**: `cor:rangegap` confines the A2-versus-primitive gap to
   $\overline{\mathcal R(\mathcal A^\ast_{\rm cond})}\setminus\mathcal R(\mathcal A^\ast_{\rm cond})$
   without characterising $\mathcal R(\mathcal W)$ at all. What survives is the `prp:effbound` half: is
   the variance-minimising selection reachable? **Step 8.**
9. **$q\not\equiv0$ is assumed, not derived.** `cor:udep` gives the necessary condition and stops.
   ~~**Step 4 / CP-12.**~~ **ROUND-9 STATUS: STILL OPEN, and now stated precisely rather than loosely.**
   `prp:sharpquad` carries it as the explicit hypothesis **O-16**, in *two* clauses that are not
   equivalent: (a) the form does not vanish on $\mathcal V$, which gives the $\delta^2$ **order**; and
   (b) $\vartheta'\sigma_q\not\equiv0$, which gives the **lower bound**, the non-compactness and the
   weak-norm refutation. **(b) implies (a) and the converse is false** — `lem:solset`(iii)'s witness,
   spec `solset-sigmaq-not-sufficient`, is the counterexample. Neither is derived, and **CP-12 is the
   probe for the stronger target $q\equiv0$**, which is the only one that removes the remainder outright.
   Two corollaries worth carrying forward: **lever 1's target $\sigma_q\equiv0$ does not remove the
   $\delta^2$ order** (only the essential spectrum), and **SG-15 sweeps a lower bound on the sharp
   constant, not the sharp constant**.
10. **NEW: A2c is a checkable condition, not a derived one.** See item 2. If a later step wants it
   *derived*, the only visible route is a range-side Hilbert-scale link matching the
   $\mathcal A_{\rm cond}\mathcal A^\ast_{\rm cond}$ scale to the $u$-Sobolev scale — a second H1, on an
   object the analyst does not choose. **Stated and rejected at `rem:l21route`(b); recorded here so the
   rejection is visible from the open-items list and not only from the remark.**

---

## D6. Housekeeping against the dispatch's own gates

- **Part 1 (N-10):** closed by construction; the alternative (assume it) is stated and rejected with a
  reason; `rem:Tcond` amended for consistency and not moved.
- **Part 2 (Step 3):** `lem:adjoint` with the $\nu/\pi$ referent settled in dispatch 1; L-1, L-4, L-5;
  `rem:nophifree` with the Fève–Florens citation; O-11's corollary. Draft `:172–177` reconciled.
- **Gate:** SymPy specs for the adjoint and for $J$ written under `scripts/symbolic/specs/`; scalar-form
  except one, which is flagged as advisory.
- **House style:** two-sentence theorem form throughout; assumptions by tag; every remark after its proof
  in the paper files; no banned filler; no unqualified convergence statements (this dispatch contains no
  limit statements about estimators).
- **Scope:** nothing downstream of Step 3. `prp:sharpquad`, `prp:orthog`, `prp:phirate`, `thm:rootn`,
  `prp:effbound`, `prp:plugin`, `cor:trend` are not stated.
- **Write scope respected:** only `quality_reports/theory/panel-npiv-discrete/`,
  `paper/sections/theorems/`, `scripts/symbolic/specs/`.

---
---

# Part I — Dispatch 1 (rounds 1–2), retained as the record

---

## 0. Round-2 disposition, in priority order

Both CRITICALs were correct. I verified each independently before acting.

| ID | Verdict | What changed |
|---|---|---|
| **C-1** | **ACCEPTED. The lemma was false.** I reproduced the counterexample: $V=\pm1$ equiprobable, $\Phi$ the rescaled $\arctan$ (odd), $\varepsilon=V$, $w=\cos$ gives $E[\varepsilon\cos(t\Phi(V))]=\tfrac12\cos(ta)-\tfrac12\cos(-ta)=0$ for all $t$ while $E[\varepsilon\mid V]=V\ne0$. My Step 6 sentence was wrong and the attribution to Bierens (1990) Thm 1 was wrong — that is the exponential characterisation. **Fix (i) taken:** B1(ii) is now $w=\exp$; the $\cos/\sin$ sentence is deleted; `rem:swintercept` records the counterexample, the intercept-indexed Stinchcombe–White repair with the countability argument, the correct anchor (S&W 1998 Thm 3.1), and the range-space cost fix (ii) would carry. |
| **C-2** | **ACCEPTED. (P4) was stated in a generality in which it is false.** Split into **(P4a)** $\lvert\widetilde W\rvert\le1$, unconditional and free from $W\in\{0,1\}$, $\varrho\in[0,1]$; and **(P4b)** the identity at $\sigma(\Delta Z)$ **only**, with the counterexample in the proofs header. `rem:draftrec`(ii) rewritten as a **kernel** comparison via $p_X(1-\varrho)f_1-(1-p_X)\varrho f_0$, with $p_X=\varrho$ named as the extra condition and rejected, in the precise phrasing "the instrument does not shift the endogenous regressor given $\Delta Z$" rather than the slogan "the negation of relevance", which carries more than it can. A4 comment (c), the Discussion and §2.2 below all rewritten. `lem:quantu` Step 2 now cites (P4b) and says why the $\sigma$-field is exactly right. |
| **M-1** | **ACCEPTED.** A2, A2′ and A3's referent moved from $\nu$ to $\nu/\pi$. I re-ran the Picard test: $\int\nu\pi\,dx=E[\Delta Z(\pi(X_2)-\pi(X_1))]\ne0$ generically, while $\int(\nu/\pi)\pi\,dx=\int\nu\,dx=0$ always. `prp:compact` gains a step proving $\mathsf k(u,t;\cdot)\in\mathcal V$, which makes the check internal rather than assumed. Recorded as binding on `lem:adjoint` at Step 3: the closed form must read $\mathcal A^\ast_{\mathrm{cond}}\ell=\nu_{\widetilde W\ell}/\pi$. |
| **M-2** | **ACCEPTED and PROVED, not deleted.** `prp:frechet` is now two parts; part (ii) proves $\|\mathcal A_{\varphi+h}-\mathcal A_\varphi\|\le2C_{\mathcal A}\|h\|_{L^2(\pi)}$ via the shift identity $G_{\varphi+h}(v)=G_\varphi(v+\Delta h)$ and the Lipschitz bound on $G'_\varphi$ from C2′(i). `rem:quadremainder` now separates what is proved from what A6 needs. |
| **M-3** | **ACCEPTED.** A1b(iv) added: $E[\Delta Z\Delta Z']$ nonsingular plus $E\|\Delta Z\|^2$, $E[\Delta U^2]$, $E\|\Delta Z\Delta U\|^2$ finite. R1(ii) now routes identification of $\theta_\dagger$ through A1b(iv) and says explicitly that neither A2 nor A3 is used. |
| **M-4** | **ACCEPTED.** The Discussion no longer says A2's failure implies no estimator is $\sqrt n$-consistent. It now distinguishes necessity *for this moment* from necessity for $\sqrt n$-estimability by *some* estimator, cites `severini2006` for the linear case, and calls the nonlinear case conjectural, per memo §1.0. |
| **M-5** | **ACCEPTED.** `def:spaces` fixes the domain at $\mathcal V$ once, with the reason ($L^2(\pi)=\mathcal V\oplus\{\text{constants}\}$, $\Delta$ kills constants, so a zero singular value is avoided). A1c, A2, H1 and `prp:compact` all now refer to the same singular system. |
| **M-6** | **ACCEPTED.** B1(iv) weakened to exactly what Step 5 consumes: (iv.a) full topological support of $\Pi_u$; (iv.b) non-mutual-singularity of $\mathrm{Leb}\vert_{\mathcal T_0}$ and $\Pi_t\vert_{\mathcal T_0}$. Step 5's proof now derives the needed conclusion from non-singularity by contradiction, in one line. |
| **M-7** | **ACCEPTED.** C2′(ii) restated on $u\mapsto\mathcal M(u,t)$, uniformly in $t$ after dividing by $\bar w(t)$; C2′(i) reduced to $p_K-1$ derivatives, which is what it is used for and is a sufficient primitive for (ii). |
| **M-8** | **ACCEPTED, with one disagreement.** `\IQ` → `\mathbb{Q}` (5 occurrences); the duplicate `\label{eq:binaryquant}` removed from `proofs.tex` (the statement in `results.tex` owns it); explicit "alternative rendering, never compile together" headers added to all four files. **Disagreement:** `conway2000` **is** present, in `/Users/samuele/Library/CloudStorage/Dropbox/Nonparametric_IV/instrumental.bib` at line 2167 (Conway, *A Course in Operator Theory*, AMS Graduate Studies), which plan §10.2 names as the paper's bibliography. It is absent from `Bibliography_base.bib` and from the Stage-1 `references.bib`, which is presumably what was checked. I have depinned the imprecise `[Ch.~II]`. |
| **M-9** | **ACCEPTED.** $\mathcal K$ reserved for the Hilbert–Schmidt operator; the compact cube written out as $[-c_\Phi,c_\Phi]^p$. C6 retagged **A1c** and added to the stable-tag list. |
| **M-10** | **ACCEPTED.** A0 and A4(i) removed from `prp:wellposed`, `prp:frechet`, `prp:compact`; A0 removed from `lem:shiftinv`, `lem:bierens`, `cor:opsol`, `lem:density`. §3.1 below corrected — it previously said the opposite. |
| **m-1** | **ACCEPTED, gap recorded not closed.** A1b(iii)'s comment now states that it *is* the identification conclusion assumed, that A1c is explicitly not a primitive route, that a methods referee will ask what feature of $P$ delivers it, and that the NPIV analogue is a completeness condition on the law of $(X_1,X_2)$ given $(\Delta U,\Delta Z,W)$. Listed as open work in §5. |
| **m-2** | **ACCEPTED.** R1(iv) and F-10 rewritten: population statement clean, algorithmic consequence conditional on A1b(iii) and on A6/A7 at the running $\theta$. |
| **m-3** | **ACCEPTED.** Lagrange remainder replaced by the integral form $\int_0^1(1-\varsigma)G''_\varphi(u+\varsigma\Delta h)d\varsigma$, with the measurable-selection reason stated. |
| **m-4** | **ACCEPTED.** $\lambda$/$\varsigma$, $G$/$g$, $\mathcal C$/$\mathcal F_{XZW}$, $\pi$/$\Pi$ all resolved or documented; thirteen previously-missing symbols added to the glossary (§5 and §6 tables). |
| **m-5** | **ACCEPTED.** Tag-vs-number bridge stated in the `assumptions.tex` header. |
| **m-6** | **ACCEPTED.** `rem:Tcond` now names the integral ($L=\int\lambda w\,d\gamma$, differentiated in $u$) and the dominating function ($\Lambda_1\bar w$, integrable against $\lvert\gamma\rvert$ by the new second half of B1(v)); $\Pi_u(\IR)$ restored; placement note added. |
| **m-7** | **ACCEPTED, one item flagged.** `cor:opsol` names its parents; the `conway2000` pin removed; the glossary's duplicate §6 renumbered; C4′ now assumes strict positivity of $f_{\Delta U}$ on $[-\ell_n,\ell_n]$, which $\kappa_n>0$ requires and which C2′(ii) cannot supply. **Flagged:** house style declares `\newtheorem*{remark}` (unnumbered), but the project's own `preamble.tex` declares `\newtheorem{remark}[]{Remark}` (numbered). I have kept the labels, which the project preamble supports; the discrepancy is for the writer to settle. |

---

## 1. Pre-Theory Report

### 1.1 What I read, in the order the dispatch specified

| Input | Path | Status |
|---|---|---|
| Round-1 theory review | `quality_reports/theory/panel-npiv-discrete/proofs_review.md` | **READ IN FULL** before touching any file. |
| Proof-strategy memo (the contract) | `quality_reports/strategy/panel-npiv-discrete/proof_strategy_memo.md` | **READ IN FULL** (793 lines). §4 lemma inventory, §9 escalation register and §10 order of work are the operative sections. |
| Round-3 strategist-critic review | `.../proof_strategy_memo_review.md` | **READ IN FULL.** 85/100. §(b)'s seven carried items treated as binding; the standing instruction — *"where the memo's analysis and its headline disagree, the analysis is right"* — applied at the propensity frontier and at A3's conditionality. |
| Binding plan | `quality_reports/plans/2026-07-28_panel-npiv-direct-theta.md` | **READ:** §§1–2 in full, §2.6 as rewritten, §2.6b, §2.7, §6, §7, §10.1, §15, §16, §17, §18, §19. |
| House style | `.claude/references/{proof-style,asymptotic-conventions,theorem-environment-style}.md` | **READ.** Two-sentence theorem form; assumptions by tag; remarks after `\end{proof}`; every mode of convergence qualified; no banned filler. |
| Source draft | `…/Nonparametric_Panel/Centorrino_panel.qmd` | **READ**: `:55–194`, `:246–305`. Operator `:93`; derivative `:96–103`, `:124–126`; the `edddee` placeholder `:107–113`; the truncated sentence `:120–122`; adjoint `:172–177`; `assapp1`–`assapp5` `:259–305`. |
| Source preamble | `…/Nonparametric_Panel/preamble.tex` | **READ.** Macros: `\IR`, `\IN`, `\vdagger`, `\un`, `\upmodels`. Environments: `theorem`, `lemma`, `corollary`, `proposition`, `definition`, `assumption`, `remark`, `example`. **No `\IQ`** — hence the round-2 replacement by `\mathbb{Q}`. |
| Implementation (targeted) | `scripts/R/orthogonal_theta.R:115–204` | **READ.** Confirms the `Phi` = normal-CDF collision at `:176`, and that `:120–127` still marks the sieve form "superseded", which plan §19.1 reversed. |
| Bibliography | `…/Nonparametric_IV/instrumental.bib`; `quality_reports/literature/panel-npiv-discrete/references.bib` | **VERIFIED** for every key cited: `bierens1990`, `stinchcombewhite1998`, `severini2006`, `engl2000`, `conway2000`, `chernozhukov2018dml`. `douglas1966` remains absent from both — not needed here. |

### 1.2 Missing inputs

- **None blocking.** No data assessment exists, by design.
- `quality_reports/literature/panel-npiv-discrete/positioning.md` deliberately not opened: escalation items 9 and 10 direct corrections into it, and it is outside my write scope.

### 1.3 Paper type and theoretical objects

Paper type: **econometric methods**. Objects produced: definitions (model, spaces, operator equation,
admissible sets); identification results (`lem:shiftinv`, `lem:bierens`, `cor:opsol`); structural
properties of the operator (`prp:wellposed`, `prp:frechet`, `prp:compact`); supporting lemmas
(`lem:bierenscore`, `lem:quantu`, `lem:density`). No consistency, no asymptotic normality, no
efficiency: those are Steps 6–8.

---

## 2. What was written

| File | Contents |
|---|---|
| `.../notation_glossary.md` | Sixteen collisions resolved (four dispatched, seven found in round 1, five in round 2), seven documented near-collisions, three reserved local bound variables, full symbol table by type, the stable assumption-tag list, three residual hazards. |
| `.../assumptions.tex` | A0, A1, A1b, A1c, B1, A2, A2′, H1, A3, A4, N1, A5, A8, A6, A7, C1–C5′, plus Discussion, the smoothness-budget table, and a round-2 change log. |
| `.../results.tex` | Definitions 1–4, Propositions `prp:wellposed`/`prp:frechet`/`prp:compact`, Lemmas `lem:shiftinv`/`lem:bierenscore`/`lem:quantu`/`lem:bierens`/`lem:density`, Corollary `cor:opsol`, Remarks R1, `rem:swintercept`, `rem:Tcond`, `rem:draftrec`. |
| `.../proofs.tex` | Complete proofs of all nine results, each opening with a one-sentence strategy and proceeding by named steps, with six standing conventions (P1)–(P5) — (P4) now split — stated once at the head. |
| `paper/sections/theorems/lem-shiftinv.tex` | Statement, full proof, Remark R1. Complete, so the theory binary gate is not blocked. |
| `paper/sections/theorems/lem-bierens.tex` | `lem:bierenscore`, `lem:bierens`, `cor:opsol`, each fully proved, plus `rem:swintercept` and `rem:Tcond`. |

### 2.1 The operator equation (deliverable 2)

The display missing at draft `:120–122` is Definition `def:operator`:

> With $\Delta Y_\theta:=\Delta Y-\Delta Z'\theta$,
> $\mathcal M(u,t;\varphi,\theta):=E[\widetilde W\,\mathbf 1\{\Delta Y_\theta-\Delta\varphi\le u\}\,w(t'\Phi(\Delta Z))]$,
> and $T(\varphi,\theta)$ is the element of $L^2(\Pi)$ with those coordinates. The operator equation is
> $T(\varphi,\theta)=0$.

Three structural results follow and are proved: $T$ maps into a fixed ball of $L^2(\Pi)$
(`prp:wellposed`); $T$ is Fréchet differentiable in $\varphi$ with a quadratic remainder **and a
Lipschitz derivative map** (`prp:frechet`(i)–(ii)); and $\mathcal A_{\mathrm{cond}}:\mathcal V\to L^2(\Pi)$
is Hilbert–Schmidt with kernel $\nu_{g_{u,t}}/\pi$ whose slices lie in $\mathcal V$ (`prp:compact`).

Two points for the coordinator.

- **The interchange is not an interchange (F-7).** Conditioning on $(X_1,X_2,\Delta Z,W)$ replaces the
  indicator by a conditional distribution function *exactly*; what is then needed is a second-order
  Taylor expansion of that function, in integral form. This is why `assapp2` must name the conditional
  density of $\Delta Y$ given the **endogenous** regressors and be $C^1$ in $u$. The extra order buys
  both the quadratic remainder and, in round 2, the Lipschitz derivative map.
- **Compactness and the domain are now settled together.** `prp:compact` proves compactness, and
  `def:spaces` fixes the domain at $\mathcal V$, so the singular system carries no spurious zero
  singular value and is the system A2 and H1 are about.

### 2.2 Reconciliation with the draft — **rewritten in round 2**

`rem:draftrec` records four corrections. The two the dispatch named:

- **$\pi(v)$ in both numerator and denominator (draft `:172–177`).** A category error, not a
  cancellation error: the display writes the *pairing*, in which the $L^2(\pi)$ inner product
  contributes $\pi$ and the adjoint's own formula contributes $\pi^{-1}$, instead of the adjoint.
  **Round 2 adds what this costs:** the $\pi^{-1}$ is why A2 is imposed on $\nu/\pi$.
- **The vacuous $\theta$ subscript.** `lem:shiftinv` says why it is vacuous.

**The A4 gloss is withdrawn.** Round 1 asserted, following plan §18.3, that $\mathcal A_{\mathrm{cond}}$
and the raw $W$-contrast operator "differ by the bounded, boundedly-invertible weight
$\varrho(1-\varrho)$, hence have the same range and the same kernel." That is false. The identity
$E[\widetilde W g(W)\mid\mathcal C]=\varrho(1-\varrho)\{g(1)-g(0)\}$ holds at $\mathcal C=\sigma(\Delta Z)$
and does not extend to $\sigma(X_1,X_2,\Delta Z)$, which is the $\sigma$-field the kernel comparison
needs. Writing $p_X:=P(W=1\mid X_1,X_2,\Delta Z)$, the correct object is
$$E\big[\widetilde W f_{\Delta Y\mid X_1,X_2,\Delta Z,W}(u)\mid X_1,X_2,\Delta Z\big]=p_X(1-\varrho)f_1(u)-(1-p_X)\varrho f_0(u),$$
which collapses to $\varrho(1-\varrho)\{f_1-f_0\}$ **iff $p_X=\varrho$**, i.e. iff
$W\perp(X_1,X_2)\mid\Delta Z$ — the negation of instrument relevance. `rem:draftrec`(ii) is now a
comparison of *kernels* that claims neither equality of range nor equality of kernel, and it observes
that in plan §17's architecture there is no second operator to reconcile with:
$\mathcal A_{\mathrm{cond}}$ **is** the operator governing $\hat\varphi$.

---

## 3. What is proved

| Result | Statement | Assumptions used |
|---|---|---|
| `prp:wellposed` | $T$ maps into a ball of $L^2(\Pi)$ of radius $c_\Pi$, uniformly in $(\varphi,\theta)$ | B1(i), (ii), (iv.c) |
| `prp:frechet`(i) | $\|T(\varphi+h)-T(\varphi)-\mathcal A_\varphi h\|\le C_{\mathcal A}\|h\|^2$ | B1(i), (ii), (iv.c), C1, C2′(i) |
| `prp:frechet`(ii) | $\|\mathcal A_{\varphi+h}-\mathcal A_\varphi\|\le2C_{\mathcal A}\|h\|$ | B1(i), (ii), (iv.c), C1, C2′(i) |
| `prp:compact` | $\mathcal A_{\mathrm{cond}}$ Hilbert–Schmidt on $\mathcal V$; kernel slices in $\mathcal V$; singular system exists | B1(i), (ii), (iv.c), C1, C2′(i) |
| `rem:nupi` | $\nu/\pi$ is in $\mathcal V$, $\nu$ is not; hence A2's object | A1b(iv) (only for $E\|\Delta Z\|<\infty$) |
| `lem:shiftinv` | **(split)** $\mathcal I=\mathcal V_{CI}\times\IR^p$ — **no assumption**; and, under A1, $(\vdagger,\theta)\in\mathcal I\ \forall\theta$ | A1, ~~second~~ **first** clause only — corrected in round 7: `proofs.tex` Step 3 uses $\Delta U\upmodels W\mid\Delta Z$ to place $\vdagger$ in $\mathcal V_{CI}$, not $E[\Delta U\mid\Delta Z]=0$ |
| `lem:bierenscore` | $E[\varepsilon\mid V]=0 \iff E[\varepsilon e^{t'\Phi(V)}]=0\ \forall t\in\mathcal T$ | B1(i)–(iii) |
| `lem:quantu` | binary identity at $\sigma(\Delta Z)$ + single-null-set extension from $\mathbb Q$ to $\mathbb R$ | **none** |
| `lem:bierens` | (a) $\iff$ (b) $\iff$ (c) $\iff$ (d) | **B1(i)–(iv). Not A1, not A4(i)** |
| `cor:opsol` | solution set of $T(\cdot,\theta)=0$ is $\mathcal V_{CI}$ for every $\theta$; $=\{\vdagger\}$ under A1b(iii) | **B1(i)–(iv), A1b(iii). Not A1, not A4(i)** |
| `lem:density` | closed span dense; $\gamma$ immaterial; N1 subspace covered | B1(i)–(iii), (v) |

Nothing here requires A0, A2, A2′, A3, A5, A6, A7, A8, H1 or N1. **The identification layer is separable
from the sampling, source-condition and regularisation layers**: if A2 fails, everything in this
dispatch still holds, and so does the identification of $\theta_\dagger$ through A1b(iv). Worth saying
in the paper.

### 3.1 Where each assumption is used — **corrected in round 2; STALE as of dispatch 2**

> **DO NOT READ THIS TABLE AS THE CURRENT USAGE MATRIX.** It covers dispatch 1 (Steps 1–2) only, and
> three of its rows are now false: A0 is consumed by `lem:levels` (compact interval) and by
> `lem:balance` (i.i.d., through the sample split); A4(i) is consumed by `prp:kerchar`(ii) and
> `prp:orthog`(iii); and A2, A2′, A5, A8, N1 are all consumed in Parts E and F. **The live table is
> §D-00000.4, which covers Parts E and F.** This one is retained as the dispatch-1 record.

| Assumption | Used in | What it does |
|---|---|---|
| **A0** | **nothing in this dispatch** | i.i.d. sampling. Every result at Steps 1–2 is a statement about the population $P$ and holds for a single observation. A0 enters from Step 6. |
| A1 | **`lem:shiftinv`'s final clause only** | the exogeneity primitive. **Removed from `lem:bierens` and `cor:opsol` in the cleanup pass.** It is used in neither proof, and stating it would make `lem:bierens` *vacuous*: A1's first clause **is** statement (a), so under A1 all four of (a)–(d) are true and the printed equivalence asserts nothing. What is proved is stronger — the cycle holds under B1 alone, whether or not the exogeneity restriction happens to hold. `lem:shiftinv` is now **split**, so its equality $\mathcal I=\mathcal V_{CI}\times\IR^p$ carries no hypothesis on the face of the statement and `cor:opsol` cites it cleanly |
| A1b(iii) | `cor:opsol` final clause, R1(iv) | turns the solution *set* into the point $\vdagger$ |
| A1b(iv) | R1(ii) | identifies $\theta_\dagger$; **replaces round 1's incorrect appeal to A3** |
| A4(i) | **nothing in this dispatch** | Overlap. Removed from `lem:quantu`, `lem:bierens` and `cor:opsol` in the cleanup pass: on the degenerate region $\{ \varrho(1-\varrho)=0\}$ the instrument is conditionally constant, hence conditionally independent of everything, so (a) holds there automatically and $\widetilde W=0$ a.s.; off it, `lem:quantu` needs only *pointwise* positivity, which it states in that form. A4(i) enters from Step 3 (`lem:adjoint`), where the $\varrho(1-\varrho)$ weight must be boundedly invertible. **Not** used for $\lvert\widetilde W\rvert\le1$, which is free |
| B1(i) | `lem:bierenscore` Steps 0, 1, 4, 5 | integrability; compact support of $\Gamma$; $\sigma(\Phi(V))=\sigma(V)$ |
| B1(ii) | `lem:bierenscore` Steps 1–4 | $w=\exp$: the Laplace representation, the analyticity, and the determinate moment problem |
| B1(iii) | `lem:bierenscore` Step 3 | positive Lebesgue measure for the identity theorem |
| B1(iv.a) | `lem:bierens` Step 5 | density of the zero set of $\mathcal M(\cdot,t)$ |
| B1(iv.b) | `lem:bierens` Step 5, **once** | no $\Pi_t$-null set swallows $\mathcal T_0$ |
| B1(iv.c) | `prp:wellposed`, `prp:frechet`, `prp:compact` | finiteness of $c_\Pi$ |
| B1(v) | `lem:density`(ii); `rem:Tcond` | admissibility of atomic $\gamma$; the dominating function for the $t$-integral |
| C1(ii) | `prp:frechet`, `prp:compact` | the ratio bound $\bar c_\pi$ |
| C2′(i) | `prp:frechet` Steps 1–5, `prp:compact` | the conditional density, its envelope, and the Lipschitz bound on $G'_\varphi$ |
| N1 | `lem:density`(iii) | defines the subspace |

A1c, A2, A2′, A3, A5, A6, A7, A8, H1 and C2′(ii), C3, C4′, C5′ are **stated but not yet used**: they are
in the block because tags must be stable and the dispatch asked for a consolidated block. The
assumption-auditor should read the unused column as "used at Steps 3–8", not as slack.

---

## 4. The assumption block: the two things the memo headlines wrongly

### 4.1 The propensity condition is a frontier, not a threshold

A5(iii) states
$$\frac{2\mu}{2\mu+1}\cdot\frac{r}{2r+d_Z}>\frac14 \iff r>\frac{d_Z(2\mu+1)}{2(2\mu-1)},\qquad \mu>\tfrac12,$$
with an eighteen-entry substitution table in the comments (verified correct by the round-1 review).
**$r>d_Z/2$ appears nowhere except in the prohibition.** Calibration: $(1,3)\to r>4.5$; $(1,5)\to r>7.5$;
$(2,3)\to r>2.5$; $(2,5)\to r>4.17$. Under H1, $\mu>\tfrac12$ is implied by plan §2.6's scope
$s>a+\tfrac12$, with room. Escalation item 15 closes favourably.

### 4.2 A3 is stated conditional on A2, because it is otherwise vacuous

> **SUPERSEDED BY DISPATCH 13 — read §D-0000000000000000 before this section.** A3 is **retired**
> (`ass:rank`). The sentence below is where the "different matrix" claim was first written down in this
> memo, and it is left in place, unaltered, because dispatch 13's finding *is* the history of this
> sentence. **Two halves, different fates.** *Conditional on A2*: **correct, and it survives** — $\ell_\star$
> exists only under A2. *A different matrix*: **false** — by `lem:momzero`(iv) the $\ell_\star$ summand is
> zero under A1, so A3's matrix and A1b(iv)'s are the same matrix, and A3 follows from A1 + A1b(iv) plus
> the finiteness tags already on every list that carried it.

`ass:rank` opens "Suppose A2 holds, so that $\ell_\star$ exists." Round 2 adds the further clarification
that A3 is **not** what identifies $\theta_\dagger$ — that is A1b(iv), a different matrix and an
unconditional condition.

---

## 5. What remains open

1. **A1b(iii) has no primitive route.** It *is* the conclusion "$\vdagger$ is identified", assumed. A1c
   is not a route to it, and — corrected in the cleanup pass — pointing at "the NPIV analogue, a
   completeness condition on $(X_1,X_2)$ given $(\Delta U,\Delta Z,W)$" was gesturing at the very bridge
   the block disclaims, since that is the object A1c is built on. **Recorded, not closed, not weakened,
   and no longer papered over with an analogy.**
1b. **A1c does not give local uniqueness, and cannot be made to.** Because $\mathcal A_{\rm cond}$ is
   compact (`prp:compact`), it is injective but not bounded below; with `prp:frechet`(i) a competitor at
   $\vdagger+\epsilon e_j$ is excluded only for $\epsilon<\sigma_j/C_{\mathcal A}$, and $\sigma_j\downarrow0$.
   The gap between first-order and global identification is structural. **Renamed accordingly.**
2. **A2′(i) is an unverifiable primitive until L-21 is proved.** Picard gives $\ell_\star\in L^2(\Pi)$
   and nothing about sup-norms. **Step 4.**
3. ~~**`lem:adjoint`'s closed form, now with its bookkeeping settled.**~~ **CLOSED IN DISPATCH 2.**
   `lem:adjoint`(iii) states $\mathcal A^\ast_{\mathrm{cond}}\ell=\nu_{\widetilde W(\mathcal W\ell)}/\pi$,
   with the induction map $\mathcal W$ constructed rather than assumed. See Part II, §D1.
4. **C5′(ii) is conservative.** The exponent $3$ on $h_u$ is inherited; re-derive at **Step 6**.
5. **The sieve window's lower end may relax.** **Step 5.**
6. **B1(vi)'s consequence is not proved.** With a finite $\mathcal T_n$, Step 5 of `lem:bierens` fails
   (a finite set is Lebesgue-null and $\Pi_t$ would be atomic), so identification with a growing family
   needs its own Domínguez–Lobato-style argument. **Step 6 or a dedicated lemma.**
7. **A6 for the random operator.** `prp:frechet`(ii) supplies the deterministic half with explicit
   constants; the estimation half is untouched. **Step 6.**

---

## 6. Findings — things in the memo, the plan or the draft that I believe are wrong

| # | Finding | Disposition |
|---|---|---|
| **F-1** | **A2′(ii) is implied by A2′(i).** Since $\lvert\widetilde W\rvert\le1$ — free, no overlap needed — boundedness gives finite variance. | **Applied.** Both retained: T3 relaxes (i) and keeps (ii). Round 2 corrected the comment from $<1$ to $\le1$ and the stale cross-reference from F-3 to F-1. |
| **F-2** | **`assapp5`'s exponent $p$ is not $\dim(Z)$.** It is $\dim(x)=2$ in the panel. | **Applied** in C5′(ii); **flagged** as a correction to plan §1's table. Unverified against the companion paper, which is outside the repo. |
| **F-3** | **`assapp4` requires $\kappa_n\to0$ as part of the assumption**, contradicting its own "either bounded or diverges slowly". | **Applied.** Round 2 adds the residual the review found: $\kappa_n>0$ needs strict positivity of $f_{\Delta U}$ on $[-\ell_n,\ell_n]$, now assumed. |
| **F-4** | ~~$f_{\Delta U}\in C^8$ is one derivative too strong.~~ **REASONING WITHDRAWN.** | **Corrected.** The review is right that the density was wrong: the smoothed object is $u\mapsto\mathcal M(u,t)$, whose derivative is the $\widetilde Ww$-weighted **conditional** density, and the budget must be uniform in $t$. C2′(ii) now states it on $\mathcal M$; the "one derivative of slack" claim, computed on the marginal, is withdrawn. |
| **F-5** | **$d_Z\le p-1$**, since $\Delta Z$ contains a constant. | **Applied** in A4(ii) and the glossary. Favourable, so flagged rather than exploited. |
| **F-6** | **`assapp3b` and the Dirac device are obsolete.** | **Applied.** |
| **F-7** | **The memo's L-4 mis-describes its own content.** Not an interchange. | **Applied** in `prp:frechet`, labelled "L-4" so Step 3 can cite it. |
| **F-8** | **B1(iv) needs a clause the memo does not state.** | **Applied**, and in round 2 **weakened** to the minimal form the review identified: full topological support and non-mutual-singularity. |
| **F-9** | **The memo's $\mathcal T$ conditions are stated for $w=\exp$ only.** | **Applied** via $\bar w$ — and round 2 makes the irony explicit: $w=\exp$ is now the only admissible weight, so the $\bar w$ bookkeeping is scaffolding for the intercept-indexed extension of `rem:swintercept`, not for a live generality. |
| **F-10** | **`cor:opsol` yields a favourable consequence the memo does not record:** the population solution set in $\varphi$ is $\mathcal V_{CI}$ at every $\theta$. | **Applied, and scoped in round 2.** The population statement stands. The algorithmic reading needs A1b(iii) for "targets $\vdagger$" and A6/A7 at the running $\theta$ for the regularised sample solve. Round 1 overstated both. |
| **F-11 (new)** | **Plan §18.3's "A4's mechanism" bullet is refuted.** The claim that $\mathcal A_{\mathrm{cond}}$ and the raw $W$-contrast operator share a range and a kernel requires $p_X=\varrho$, which is instrument irrelevance. | **Applied**: withdrawn in A4 comment (c) and in `rem:draftrec`(ii), replaced by a kernel comparison. **Escalated** as N-7. |
| **F-12 (new)** | **`prp:compact`'s kernel forces A2 onto $\nu/\pi$.** Confirmed independently by the Picard orthogonality test. | **Applied** to A2, A2′, A3's referent. **Binding on `lem:adjoint`.** |
| **F-13 (new)** | **The project preamble has a latent LaTeX bug, and it is not a transcription error.** `…/Nonparametric_Panel/preamble.tex:24` reads `\newtheorem{remark}[]{Remark}` and `:27` reads `\newtheorem{example}[]{Example}`. **An empty optional argument is invalid**: `\newtheorem{env}[ctr]{Name}` requires `ctr` to name an existing counter; `[]` raises an error rather than defaulting to "unnumbered". The intended form is either `\newtheorem*{remark}{Remark}` (unnumbered, which is what `theorem-environment-style.md` prescribes) or `\newtheorem{remark}{Remark}` (own counter). Both lines need the same repair. | **Not applied — outside my write scope.** `\label`s on remarks are kept, and they work under either repair. **Flagged for the writer, with line numbers.** |
| **F-14 (new)** | **A1 makes `lem:bierens` vacuous if maintained.** A1's first clause is literally statement (a) of the equivalence, so under A1 all four of (a)–(d) are true and the printed equivalence asserts nothing. | **Applied**: A1 removed from `lem:bierens` and `cor:opsol` in `results.tex`, `proofs.tex`, `lem-bierens.tex` and this memo. The proof always established the stronger, A1-free result; only the statement under-delivered. `lem:shiftinv` keeps A1, which its final clause genuinely uses. |

---

## 7. Escalations and notation decisions requiring sign-off

| # | Item | What I did | What I need |
|---|---|---|---|
| ~~N-1~~ | $\mu$ vs. the Bierens measure | Kept $\mu$ for the source index; measure $\to\gamma$. | **CLOSED** — the review reports this is already ratified in plan §1. |
| **N-2** | **$\ell$ versus $\ell_n$.** Distinct symbols, so INV-7 is not violated, but a reader meeting $\ell_n$ after twenty pages of $\ell_\star$ will misparse it. | Kept $\ell_n$ (plan §1 reserves it). | **Recommendation, not executed:** rename to $\bar u_n$. Requires amending plan §1. |
| **N-3** | **The `edddee` fill.** | Filled with global identification, A1b(iii). | **Confirmed as the right content by the review.** Its reservation — that no primitive route exists — is now recorded in the block and in §5, and is with the user separately. |
| ~~N-4~~ | $M\to\sigma_q$ | Retired $M$; multiplier is $\sigma_q$. | **CLOSED** — already ratified in plan §1. |
| **N-5** | `douglas1966` absent from both bibliographies. | Nothing. | Librarian at Step 4 if the Douglas route is revisited. |
| **N-6** | Plan §12 and the alternating loop. | Stated as R1(iv), now correctly scoped. | Coordinator may carry the *population* half into plan §12; the algorithmic half needs A6/A7. |
| **N-7 (new)** | **Plan §18.3's A4-mechanism bullet is refuted** (F-11). The reconciliation it asked for is delivered, but in the weaker, correct form: a kernel comparison, not an equivalence of operators. | Withdrawn in `assumptions.tex` and `results.tex`. | **Coordinator to amend plan §18.3.** This is a plan claim, not a memo claim, so I am not free to strike it myself. |
| **N-8 (new)** | **Plan §1's notation table lists "$\cos s$ / $\sin s$" as admissible Bierens weights.** Both are inadmissible against an odd $\Phi$ (C-1). | B1(ii) restricted to $w=\exp$; the general route recorded in `rem:swintercept`. | **Already corrected by the coordinator.** Recorded here for the trace. |
| ~~N-9~~ | `conway2000` | Kept the citation; removed the `[Ch.~II]` pin. | **CLOSED — pushback upheld.** `stinchcombewhite1998` confirmed at `references.bib:415`. |
| ~~**N-10**~~ **CLOSED in dispatch 2 — see Part II §D1** | **$\ell_\star$ has two domains and the bridge is an assumption, not a construction.** The adjoint equation lives on $(u,t)$, $t\in\mathcal T$; A2′(i)–(ii) and A3 evaluate $\ell_\star(\Delta U,\Delta Z)$ on $(u,z)$, $z\in\IR^p$. | Added **A2′(0)**: $\ell_\star\in\overline{\mathcal G_\gamma}$, which by `lem:density`(ii) equals $L^2(P_{\Delta U,\Delta Z})$, so the clause is cheap. Typed both domains in the glossary (C17). | **Step 3 must construct the map**, presumably induction through the Bierens family $\ell(u,z)=\int_{\mathcal T}\ell^\Pi(u,t)w(t'\Phi(z))\gamma(dt)$, and check that it commutes with the adjoint equation. Until then the two $\ell$'s are related by assumption. This is a genuine architectural gap, not bookkeeping. |

---

## 8. Housekeeping against the memo's own gates

- **Step 1 (notation, missing operator equation):** complete. Escalation item 12 discharged, with sixteen
  collisions resolved against the memo's five.
- **Step 2 (`lem:shiftinv` F2; `lem:bierens` F4; L-2, L-3):** complete. The strict-inclusion half is
  **not** proved and is explicitly disclaimed, per plan §19.3. The Jensen → Douglas → Picard route is
  untouched.
- **House style:** two-sentence form throughout; assumptions cited by tag; every remark follows its proof
  in the paper files; no "fast"/"slow"; no unqualified convergence statements — this dispatch contains no
  limit statements at all.
- **Compilation:** `\IQ` eliminated; the one genuine in-set duplicate label removed; the two paper files
  carry explicit "never compile together with `results.tex`" headers.
- **Not stated, as instructed:** `prp:sharpquad`, `thm:rootn`, `lem:adjoint`, `rem:nophifree`,
  `prp:orthog`, `prp:phirate`, `prp:effbound`, `prp:plugin`, `cor:trend`.

---

# Part III — Step 6 (merged from `step6_memo.md`, orchestrator 2026-07-29)

# Step 6 disposition — `panel-npiv-discrete`

**Dispatch 4 · memo §10 STEP 6 · `prp:phirate` and obligation (O4) · theorist · 2026-07-29**
**Status: NEW CONTENT.** To be merged into `theory_memo.md` as Part III, §E.

**Files written (none of the five locked files is touched):**

- `quality_reports/theory/panel-npiv-discrete/results_partH.tex`
- `quality_reports/theory/panel-npiv-discrete/proofs_partH.tex`
- `scripts/symbolic/specs/{phirate-fixedpoint-mu-half, phirate-retune-mu-five-sixths, l19-entropy-exponent, l19-effective-sample, aerr-propensity-scaling, phirate-operator-noise-budget}.yaml`

**Read:** `assumptions.tex` (in full), `results.tex` (Part A, `rem:obligations`, `prp:orthog`,
`lem:balance`, Part G's `rem:sharpscope`), `proofs.tex` ((P1)–(P7), Part G), `notation_glossary.md`
(in full), `proof_strategy_memo.md` §§2.7, 3.1–3.4, 4 (L-12, L-13, L-18, L-19), 5, 10,
`theory_memo.md` §D-00000000, `quality_reports/literature/panel-npiv-discrete/references.bib`,
`scripts/symbolic/{README.md, specs/*}`.
**Not available and not assumed:** the source draft, `instrumental.bib`, any simulation output.

---

## 0. Headline, in four sentences

1. **(O4) is discharged, and A6 is refuted.** The operators are exhibited (`def:hatTexp`,
   `def:hatAcon`); `prp:tccfails` proves that **A6 — a maintained assumption — is false**, with
   probability one, for every constant $\eta_{\rm TCC}<1$ and every ball of positive radius.
2. **$\hat T$ was undefined too.** A6 and A7 are statements about $\hat T$, whose only glossary row
   reads "sample analogue of $T$". `def:hatA` fixed the reading of $\hat{\mathcal A}$ one level down
   and did not sweep the level above it. `eq:hatT` supplies the definition.
3. **The registered nonlinear-LF route does not transfer, and the reason is arithmetic, not
   technical.** Nonlinear Landweber saturates at source index $\mu=\tfrac12$; A5(iii) proves
   $\mu>\tfrac12$ **necessary**. The two are incompatible at exactly one point.
4. **The replacement closes at the same threshold.** `prp:phirate` linearises and runs *linear* LF at
   each stage; the recursion contracts iff $\mu>\tfrac12$. **The condition that kills the inherited
   route is the condition that switches the replacement on.** No TCC is used.

---

## 1. (O4): what was exhibited, and what the verification returned

### 1.1 Exhibition

| Object | Where | Notes |
|---|---|---|
| Integrated kernel $\mathsf C_{h_u}$ | `def:intker`, `lem:intker` | Four properties, each derived from a named clause of C3 |
| $\hat T(\varphi,\theta)$ | `eq:hatT` | **New: this was defined in no file** |
| $\hat T_{h_x}(\varphi,\theta)$ | `eq:hatTx` | The $x$-smoothed variant; new |
| $\Delta_{h_x}\varphi_i$ | `eq:smdiff` | Smoothed period difference |
| $\hat{\mathcal A}_\varphi$, $\hat{\mathcal A}^\ast_\varphi$ | `eq:hatAcon`, `eq:hatAadj` | Discharges (O4)'s exhibition half |

`prp:hatAprop` proves the exhibited operator is bounded, of rank $\le n_{\rm m}$, adjointable into
$\mathcal V$ — **and that clause (iii) is where C3(ii)'s boundary index earns its keep**: without the
exact $x$-normalisation of `lem:intker`(iv) the adjoint leaves $\mathcal V$, which is a type error
against `def:spaces`.

**`def:hatA`'s reading is not only fixed but realised, and its rejected alternative is proved
unavailable.** `prp:hatAprop`(iv): $\hat{\mathcal A}_\varphi$ is the *exact* Fréchet derivative of
$\hat T_{h_x}$. `prp:hatAprop`(v): the Gateaux derivative of $\hat T$ exists but is an **unbounded**
linear map, so $\hat T$ is *nowhere Fréchet differentiable* on $\mathcal V$ — point evaluation is not
continuous on $L^2$. So "the derivative of $\hat T$" does not name an operator at all.

### 1.2 Verification: A6 — **CRITICAL, and it is a refutation**

`prp:tccfails`. Take a triangular spike of height 1 and vanishing width at one design point
$X_{i^*2}$: it is $o(1)$ in $L^2(\pi)$, invisible to $\hat{\mathcal A}_{\tilde\varphi}$ (which sees
only the smoothed functionals), and moves $\hat T$ by a fixed nonzero amount. A6's left side converges
to $\|\Xi_*\|>0$ and its right side to $\eta_{\rm TCC}\|\Xi_*\|<\|\Xi_*\|$.

- Holds **for every** $\eta_{\rm TCC}<1$ (A6 asks for $<\tfrac12$, so a weaker condition is refuted too).
- Holds on **every** ball of positive $L^2(\pi)$ radius.
- Uses **no** clause of A1, A2, H1 — it is a statement about the two *maps*, so no strengthening of the
  model repairs it.

**Diagnosis (`rem:tccwhy`).** A TCC asks a *second-order* quantity to dominate. Pairing $\hat T$ (point
evaluations) with $\hat{\mathcal A}$ (smoothed functionals) leaves a **first-order** discrepancy on the
left. The defect is in the *pairing*, which is exactly the ambiguity `def:hatA` identified — and could
not resolve, having performed no construction.

**Repair, stated but not maintained.** `def:a6b` (**A6b**) pairs $\hat{\mathcal A}$ with the operator
it differentiates. `prp:tccrepair` shows A6b ⟹ A6 for that pair, and gives an explicit radius
`eq:tccrad` $\propto h_u^2h_x^{1/2}\lambda_{\min}(\mathbf G_n)^{1/2}n_{\rm m}^{-1/2}$. **The radius
shrinks with the ill-posedness and no result claims it is bounded away from zero.**

**Range invariance, the one-round attempt, is spent** (`prp:norangeinv`): it forces
$\mathcal R(\hat{\mathcal A}_\varphi)=\mathcal R(\hat{\mathcal A}_{\tilde\varphi})$, which fails because
the spanning kernels are *translates* and translates by more than the support width are independent.
Same argument kills the population version.

**Nothing downstream uses A6 or A6b.** `prp:phirate` needs neither.

### 1.3 Verification: A7 — partially

`prp:stopfeas`. The $T$-component closes **at a fixed $\tau_{\rm DP}$** — and that is where A5(i)'s
$\sqrt{\ln n}$ earns its keep, via Chebyshev on a Hilbert-space second moment. The $\varrho$-component
does **not**: A4(iii) is an $O_P$ statement, and `prp:stopfeas`(ii) exhibits a sequence satisfying
A4(iii) for which $P(\|\hat\varrho-\varrho\|>\tau r_n)\not\to0$ at every fixed $\tau$.

**Two repairs, either sufficient; the second is free** — see §3 item C(3).

---

## 2. `prp:phirate`: what is proved, on what route, and at what cost

**Estimator (`def:lfstep`):** iterated linearisation with *sieve* Landweber–Fridman, DP-stopped at
each stage. **Every LF iteration is applied to a linear equation.**

**Conclusion (`eq:phirate`):** $\|\hat\varphi-\vdagger\|_{L^2(\pi)}=O_P(\delta_n)$ with
$\delta_n=(\hat\delta_n\ln n)^{2\mu/(2\mu+1)}$, and $\delta_n=o_P(n^{-1/4})$ under `eq:frontier`.
**A5(i)–(iii) are discharged. A5(vi) is consumed, not discharged. A5(iv)–(v) are untouched.**

### 2.1 The F-6 / O10 resolution, precisely

| | Inherited route | Route taken |
|---|---|---|
| Regulariser | nonlinear LF on $\hat T$ | linear LF on the stagewise linearisation |
| Needs a TCC | yes (A6 — **false**) | **no** |
| Source index | **saturates at $\mu\le\tfrac12$** | unrestricted above; recursion needs $\mu>\tfrac12$ |
| At $\mu=\tfrac12$ | $\delta_n\asymp n^{-1/4}(\ln n)^{1/4}$ — **not** $o(n^{-1/4})$, even with a perfect propensity | contraction is marginal; $\mu>\tfrac12$ strictly is required |
| Verdict | **incompatible with A5(iii)** | closes |

**The arithmetic core** is $2\kappa-1=(2\mu-1)/(2\mu+1)$ with $\kappa=2\mu/(2\mu+1)$: contraction of
$\varepsilon\mapsto \mathsf c\,\varepsilon^{2\kappa}$ needs $2\kappa>1$, i.e. $\mu>\tfrac12$ — spec
`phirate-fixedpoint-mu-half`. The saturation of nonlinear LF is at the *same* $\mu=\tfrac12$, reached
from the other side, and both trace to the same Heinz-inequality barrier that `lem:srctransfer`(ii)
exhibits.

### 2.2 What is given up, and it should be printed in the paper

1. **Global convergence.** The route needs a *consistent* preliminary $\hat\varphi^{(0)}$ (memo's
   L-14). Where it comes from is an **open item** — see §5 (Q-1).
2. **A sieve.** `lem:srctransfer`(iii): a finite-rank operator cannot satisfy the Hilbert-scale link
   condition on $\mathcal V$, so LF runs on $\mathcal S_n$ and **A8's window is consumed by the
   $\varphi$-step**, not only by the balancing solve. That is a use of A8 the block does not record.
3. **IRGN.** Dunker et al. (2014) use iteratively regularised Gauss–Newton *because* it beats
   Landweber's saturation. The project adopts their noise model and declines their regulariser, and
   then needs $\mu>\tfrac12$. **This is a live positioning tension.** The honest options are two:
   adopt IRGN, or say — as Part H does — that the linearised route reaches the same place under the
   same threshold. The second is cheaper and is what is proved; the first should be *named and priced*
   in the paper, because a methods referee who knows the regularisation literature will ask.

### 2.3 Four new lines Step 6 charges

| # | Condition | Where | Binding? |
|---|---|---|---|
| **N-1** | `eq:entropy`: $\big(\tfrac1{16}+\alpha\big)/s<1-2\alpha$, $\alpha=\tfrac r{2r+d_Z}$ — L-19's entropy cost | `lem:unifop`, `rem:l19cost` | $s>1.75$ at $(\mu,d_Z,r)=(1,3,4.5)$; $s>1$ at $(2,3,2.5)$. **Not binding against mild ill-posedness.** |
| **N-2** | **(P-b)**: $\gamma_n=O(\hat\delta_n^{1/(2\mu+1)})$ — the operator-estimation budget | `lem:aerr`, spec `phirate-operator-noise-budget` | Non-empty $h_x$ window; **not binding** |
| **N-3** | **A5(vi) is charged on BOTH routes** from Step 6 onward, not "balancing only" | `lem:pathcont`(c) | Budget-table amendment |
| **N-4** | **(P-f)**: $\delta_n^2=O(h_u^2\hat\delta_n\ln n)$ | `rem:h6bandwidth` | **BINDING, and it is the one to settle** |

**(P-f) in detail, because it is the live one.** At C5′(i)'s $h_u\asymp n^{-1/16}$ it reads
$\alpha\cdot\frac{2\mu-1}{2\mu+1}\ge\tfrac18$: satisfied with room at $\mu=2$
($\alpha\ge\tfrac5{24}$ vs $\alpha=\tfrac5{16}$), **exactly at the boundary** at
$(\mu,d_Z,r)=(1,3,4.5)$, and **impossible** at $\mu=\tfrac34$ (needs $\alpha\ge\tfrac58>\tfrac12$).

**But C5′(i) is tuned to the wrong target.** It matches the smoothing bias $h_u^{p_K}$ to the
*stochastic floor* $n^{-1/2}$. What Step 6 needs the bias to meet is $\hat\delta_n\gg n^{-1/2}$.
Re-tuning to $h_u\asymp\mathrm{sd}(\Delta U)\,\hat\delta_n^{1/p_K}$ leaves `lem:opnoise`(ii) intact and
converts (P-f) into a clean, $\alpha$-free threshold:

$$\boxed{\;\mu\;\ge\;\tfrac56\;}$$

spec `phirate-retune-mu-five-sixths`. Under H1 and plan §2.6's $s>a+\tfrac12$ (giving
$\mu>\tfrac12+\tfrac1{4a}$) this is **implied whenever $a\le\tfrac34$** and is an extra restriction
otherwise. **Recommendation: amend C5′(i) and add $\mu\ge\tfrac56$ to the budget table.**

---

## 3. Required amendments to the five locked files

Reproduced from the header of `results_partH.tex` items A–E; the two **CRITICAL** ones first.

**C(1) CRITICAL — A6 must leave the maintained block.** It is false (`prp:tccfails`), not merely
strong, and is not repairable by shrinking $\eta_{\rm TCC}$ or $\mathcal V_n$. Replace by the
*property* tag **A6b** (`eq:a6b`), on the A1d/A2b/A2c model. Note that nothing consumes either.

**C(2) CRITICAL — define $\hat T$.** `eq:hatT`. Amend the glossary row, which reads only "sample
analogue of $T$" and points at memo §3.3 prose.

**C(3) — A7.** Either (a) strengthen A4(iii) to $P(\|\hat\varrho-\varrho\|_{L^2}>\mathsf c\,r_n)\to0$
for some finite $\mathsf c$; **or (b) inflate A7's threshold to $\tau_{\rm DP}\hat\delta_n\ln n$**
(`eq:a7amend`). **(b) costs nothing** because `eq:frontier` is a *strict* inequality
(`prp:stopfeas`(iv)). **(b) recommended.**

**C(4) — A5(i) confirmed, one clause loosened.** The $T$-component's *$L^2(\Pi)$-norm* is
$O_P(n^{-1/2})$ with **no logarithm** — Hilbert-space second moment, `lem:opnoise`(i). A5(i)'s
$\sqrt{\ln n}$ is therefore satisfied, and it is **not idle**: `prp:stopfeas`(i) consumes it at a fixed
constant. Record both.

**C(5) — C5′(ii) is conservative; the re-derivation it asks for is `eq:gamman`.** The clause requires
$(nh_x^2h_u^3)^{-1}\ln n\to0$; what `lem:aerr` consumes is $(nh_xh_u)^{-1}\ln n\to0$ — **one** power
each. The inherited exponents 2 and 3 come from a density-*derivative* estimator in the
cross-sectional companion; $\hat{\mathcal A}_\varphi$ estimates a density-weighted conditional mean.
C5′(ii) implies the relaxed condition, so nothing proved is lost.

**C(6) — C5′(i) should be re-tuned**, per §2.3 (P-f). The block's guard against "correcting 16 to 17"
protects a *matching to the wrong target* and must be rewritten with the choice.

**C(7) — the budget table.** Add N-1, (P-b), $\mu\ge\tfrac56$; change A5(vi)'s Route entry from
"balancing only" to "both".

**C(8) — A8's role.** Record that A8's window is consumed by the $\varphi$-step (via
`lem:srctransfer`(iii)), not only by the balancing solve.

**Glossary (item A of the results header):** twelve slots claimed (C45–C57), every one with the sweep
for the **letter claimed** recorded per §1.5b, and **two declined** (blackboard $\mathbb C$, because
`lem:reprsmooth` runs complex exponentials one line away; and a symbol for the discrepancy inflation,
because the natural $a_n$ sits one subscript from the RESERVED degree of ill-posedness $a$ — the exact
species C35 was charged for). **One rule amended in the open:** C13's "$\lambda$ always carries two
arguments $(u,t)$" now reads: *two arguments $(u,t)$ = the Bierens weight; $\lambda_{\min}(\cdot)$ with
a **matrix** argument = an eigenvalue.* `sigma_min` was considered and **rejected**, because
$\sigma_{\rm ess}$ is already a word-subscripted $\sigma$ taking an operator argument and returning a
*set*.

---

## 4. Findings

| # | Finding | Severity |
|---|---|---|
| **H-1** | **A6 is false**, not strong. Proved. | **CRITICAL** |
| **H-2** | **$\hat T$ is used in two maintained assumptions and defined nowhere.** `def:hatA` fixed the level below and did not sweep the level above. | **CRITICAL** |
| **H-3** | **Nonlinear LF saturates at $\mu=\tfrac12$; A5(iii) needs $\mu>\tfrac12$.** The registered route is incompatible with the paper's own frontier, at exactly one point. This is F-6 / O10 made precise. | **CRITICAL (resolved)** |
| **H-4** | $\hat T$ is **nowhere Fréchet differentiable** on $\mathcal V$; the reading `def:hatA` rejects does not name an operator. | MAJOR |
| **H-5** | **(P-f)** is a genuine new restriction, binding at low $\mu$; re-tuning $h_u$ converts it to $\mu\ge\tfrac56$. C5′(i) is tuned to the wrong target. | MAJOR |
| **H-6** | **A5(vi) is charged on both routes** from Step 6, not "balancing only". | MAJOR |
| **H-7** | **A7 is not verifiable at a fixed $\tau_{\rm DP}$** from A4(iii); an $O_P$ hypothesis cannot yield a fixed-constant exceedance bound. Counterexample given. | MAJOR |
| **H-8** | C5′(ii)'s exponents (2 on $h_x$, 3 on $h_u$) are inherited from the wrong estimator; the correct pair is (1,1). | MODERATE |
| **H-9** | **L-19 runs the wrong way in $r$**: a smoother propensity makes it *harder*, because $\hat\delta_n$ is a tighter target. And it **excludes $\alpha\to\tfrac12$** — L-19 at rate $\hat\delta_n$ is unavailable when the propensity component does not bind strictly. | MODERATE |
| **H-10** | The **VC-subgraph** route registered for L-19 in memo §3.4 is not available: the class is indexed by an infinite-dimensional $\varphi$ through a smooth transformation and is not VC-subgraph. Smoothness of the index set, not combinatorial dimension, supplies the entropy — which is *why* the ball must be a source-condition ball. (Consistent with the standing instruction; recorded because §3.4's honest restatement names VC.) | MODERATE |
| **H-11** | **C3(ii) and C3(iii) cannot both hold literally** at $s_0=1$: the support clause gives $[0,c_C]$ (one-sided) and (iii) calls the kernel *symmetric*. Inherited from `assapp3a`. **Nothing in Part H depends on the resolution** — every use is of $[-c_C,c_C]$ and of the order conditions — but the clash should be repaired. | MODERATE |
| **H-12** | **C3 does not print the normalisation** $h^{-1}\int C_h(w,s_0)dw=1$. It is what "of order $p_K$" means for a generalized kernel and is consumed at `lem:intker`(i),(iii),(iv) — the last of which is what keeps $\hat{\mathcal A}^\ast$ inside $\mathcal V$. Should be printed. | MODERATE |
| **H-13** | The memo's registered containment mechanism for the LF path ("$\varphi_m-\varphi_0\in\mathcal R(\hat{\mathcal A}^\ast)$, norm polynomial in the cap") gives a bound **linear in $\bar m_n$** and therefore does **not** place the path in a ball of fixed radius. Containment comes from the *stopping rule*. | MODERATE |
| **H-14** | `eq:gamman`'s propensity term carries $(h_xh_u)^{-1/2}$; an earlier draft of the proof asserted the factor cancelled. It does not. The bound is likely loose (the *mean* is $O(r_n)$ with no bandwidth) but sharpening it needs $\|\hat\varrho-\varrho\|_\infty$, which **no clause prices** — consistent with the glossary's $r_n$ row. | MINOR |
| **H-15** | $\hat{\mathcal A}_\varphi$ is **computable without knowing $\pi$**; only its *kernel* carries $\pi^{-1}$. Worth one sentence in the paper, since $\pi$'s status (stationary density "if it exists") is otherwise a nuisance. | MINOR |

---

## 5. Open items and escalations

**Q-1 (escalation, coordinator or user).** **Where does $\hat\varphi^{(0)}$ come from?** `prp:phirate`
requires a preliminary with $\|\hat\varphi^{(0)}-\vdagger\|_{L^2(\pi)}=o_P(1)$. This is memo L-14's
object, registered there as LOW risk and as a *consequence* of `prp:phirate` — which is now backwards:
the linearised route makes consistency an **input**. Options: (a) a small number of nonlinear LF steps
from $\varphi=0$, which needs the very TCC that fails; (b) a Tikhonov/sieve-minimum-distance
preliminary, which needs its own analysis; (c) assume it, and say so. **User decision.**

**Q-2 (escalation, user).** **IRGN or not.** See §2.2 item 3. Adopting IRGN removes the saturation
problem at its source and matches the noise model the project already adopts; declining it is
defensible only if the linearised route is printed as the substitute, with the threshold $\mu>\tfrac12$
named. **The positioning claim "we adopt Dunker et al.'s noise model and reject their regulariser"
should not be printed without the accompanying threshold.**

**Q-3.** **Is $\lambda_{\min}(\mathbf G_n)$ bounded below at a usable rate?** Needed only for A6b's
radius `eq:tccrad`, which no theorem consumes — so this is a *simulation* question (probe CP-8), not a
theory obligation. Flagged so it is not mistaken for one.

**Q-4.** The **link condition on $\mathcal S_n$** (`lem:srctransfer`(iii), hypothesis (P-a)) is
assumed, not derived. Deriving it would need the singular values of $\hat{\mathcal A}_\varphi$
restricted to the spline sieve to track $j^{-a}$, which is a genuine open problem and is the
Hilbert-scale analogue of A2's own status. **Recorded as open, on the A1b(iii) model.**

**Q-5.** `lem:unifop` clause (a) rests on **one unpinned classical fact**, the sup-norm entropy of a
Sobolev ball (F-e). **Clause (b), the sieve version, is what `prp:phirate` consumes and is elementary**
(volumetric bound, proved inline). The separation is deliberate: *no conclusion of Part H depends on
an unpinned entropy theorem.*

**N-13 is NOT inherited.** Memo §5's "$Q(h)\ne0$ necessarily" does not follow and is the
coordinator's; nothing in Part H uses it.

**`rem:sharpscope`(2) is respected.** `rem:phirscope`(1) states explicitly that Part H does **not**
reinstate memo §2.5(iii)'s "$\delta_n=o(n^{-1/4})$ is sharp for this moment function". `eq:phirate` is
an **upper** bound; what `thm:rootn` inherits from Part G is the **lower** bound on the second-order
form. Different objects, neither a sharpness claim about $\hat\varphi$.

**One trap for `thm:rootn`.** `eq:phirate`'s $\delta_n$ is $(\hat\delta_n\ln n)^{2\mu/(2\mu+1)}$, not
$\hat\delta_n^{2\mu/(2\mu+1)}$ as A5(ii) writes. The two differ by $(\ln n)^{2\mu/(2\mu+1)}$, absorbed
by the frontier's strictness but **not absorbed into the symbol**.
**[STALE — A5(ii) was amended in dispatch 11 and now writes $\delta_n:=(\hat\delta_n\ln n)^{2\mu/(2\mu+1)}$,
so the trap is closed and the symbol *is* the object `eq:phirate` delivers; see `rem:rootnlog`(2).
Retained as a dated record of the Step-6 handoff. Marked in dispatch 14 — the second of the two sites the
notation-warden's N5 names, and the one its regex could not reach because the glyph comes first and the
verb last.]**

---

## 6. Bibliography — FLAG FOR THE LIBRARIAN (the trap fired again)

**Checked against `quality_reports/literature/panel-npiv-discrete/references.bib`, as instructed.**

| Key | In that file? | Status |
|---|---|---|
| `hanke1995` | **NO** — Area L header says "already in instrumental.bib. Annotated only." | **CITED in `results_partH.tex` (`prp:norangeinv`, `rem:lfnonlinear`). WILL BREAK THE BUILD.** |
| `engl2000` | **NO** — same header. **And it is already cited in `assumptions.tex:997` (H1).** | **WILL BREAK THE BUILD, and already would.** |
| `chenreiss2011` | **NO** — same header | Not cited by Part H |
| `dunker2014` | **NO** — listed in the "already in instrumental.bib" roll at `:53` | **Cited in prose only** (`rem:lfnonlinear` names the authors and year without `\cite`), deliberately, so nothing breaks |

**This is exactly the `bierens1990` / `feve2014` failure repeating.** Those two had to be copied into
`references.bib` after biber reported "I didn't find a database entry"; `hanke1995` and `engl2000` are
in the same position and `engl2000` is *already* cited from a locked file. The file's own header
records the problem at `:64–74` ("BIBLIOGRAPHY AUTHORITY IS UNDECLARED") and says a user decision is
required. **Requested: copy `hanke1995`, `engl2000` and `chenreiss2011` into
`quality_reports/literature/panel-npiv-discrete/references.bib`, and add `dunker2014`**, which Part H
would cite properly once it resolves.

**Two further pins named but not cited**, following Part G's practice of naming an intended pin in a
comment rather than adding an unresolvable `\cite`:

- (F-d) bounded differences — **proved inline** (`lem:bdiff`); intended pin McDiarmid (1989) or
  Boucheron–Lugosi–Massart (2013, Thm 6.2).
- (F-e) sup-norm entropy of a Sobolev ball — **not proved**; intended pin Birman–Solomjak (1967),
  Kolmogorov–Tikhomirov (1961), or van der Vaart–Wellner (1996, Thm 2.7.1). Used only in
  `lem:unifop`(a), which nothing consumes. **None of these three resolves in `references.bib` either.**

**Two more added in dispatch 14, same practice, neither cited:**

- **The one-step estimator from a $\sqrt n$-consistent preliminary.** `def:onestep` already records that
  Newey & McFadden (1994, Handbook ch. 36) §3.4 and van der Vaart (1998) Ch. 5 are the two classical
  anchors and that neither key is present. Re-flagged because Part I now has four results resting on the
  construction.
- **Honest / uniformly valid confidence sets.** `rem:rootnscope`(6), new in dispatch 14, states that
  `thm:rootn` is **pointwise in $P$** and that no uniformity is claimed or proved. The standard pins are
  Li (1989, *Ann. Statist.*) for honest confidence sets and Chernozhukov, Chetverikov & Kato or Romano &
  Shaikh for uniform-in-$P$ inference; **none resolves in `Bibliography_base.bib`** (`li1989` swept: zero).
  The remark therefore states the notion in words and cites nothing, on the `rem:lfnonlinear`(c)
  precedent. **Requested: add Li (1989) at minimum**, since the pointwise-versus-uniform boundary is now
  an explicit scope claim of the theorem and a referee will want the pin.

---

## 7. Specs written

| Spec | Verifies |
|---|---|
| `phirate-fixedpoint-mu-half` | $2\kappa-1=(2\mu-1)/(2\mu+1)$ — the contraction threshold **and** the saturation threshold are the same $\mu=\tfrac12$ |
| `phirate-retune-mu-five-sixths` | $(2\mu-1)/(2\mu+1)-\tfrac14=(6\mu-5)/(4(2\mu+1))$ — the re-tuned (P-f) threshold is exactly $\mu=\tfrac56$, not a rounded value |
| `l19-entropy-exponent` | $(h_u\hat\delta_n)^{-1/s}=n^{(1/16+\alpha)/s}$ |
| `l19-effective-sample` | $n\hat\delta_n^2=n^{1-2\alpha}$ — positive iff $\alpha<\tfrac12$ (H-9) |
| `aerr-propensity-scaling` | $h_u^{-1}h_u^{1/2}=h_u^{-1/2}$ — the factor that does **not** cancel (H-14) |
| `phirate-operator-noise-budget` | $1-2\mu/(2\mu+1)=1/(2\mu+1)$ — (P-b) is weaker than $\gamma_n=O(\hat\delta_n)$ |

**I have not run them.** Per the standing constraint, the coordinator runs the specs and the build.
