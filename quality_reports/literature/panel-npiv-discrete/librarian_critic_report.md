# Literature Review — librarian-critic, ROUND 2

**Project:** `panel-npiv-discrete` · **Date:** 2026-07-28
**Reviewed:** `annotated_bibliography.md`, `references.bib`, `frontier_map.md`, `positioning.md`
**Severity:** coverage/recency/categorisation at normal Discovery severity; **citation accuracy and novelty verdict at maximum severity**
**Persisted by the orchestrator** (the librarian-critic is read-only). This supersedes the round-1 report.

# SCORE: 86/100 — CLEARS THE 80 GATE (plan §5)

Clears commit (≥80). Does **not** clear the PR gate (≥90). Three named defects must be repaired before the introduction is drafted; none requires another librarian round.

**Tooling limitation.** Read/Grep/Glob only, no web access. Everything checkable locally — `instrumental.bib` (344 entries), the plan, the domain profile, `references.bib` well-formedness — was checked mechanically. The three orchestrator-supplied findings (Poirier DOI correct; no OA copy; Drive link dead) are used as given.

---

## (a) VERDICT: **CLEAR (PROVISIONAL) — SUSTAINED**

Round-1 framing defect (V1) fully repaired. `positioning.md` §1 now leads with *"One open condition remains. It is G-1. Stage 2 may proceed, but this verdict is not final until G-1 closes,"* plus a gate-status table and an explicit consequence clause. G-1 is named in the first ten lines. **V1 CLOSED.**

**G-2 CLOSED.** All five 2026 arXiv entries carry `% VERIFIED 2026-07-28`; six previously-mis-flagged entries unflagged; `deaner2025` correctly retains its flag; three genuinely unconfirmed page ranges newly flagged. **C3 CLOSED.**

**`shen2026` and `brunssmith2026` renames consistent across all four files** — grep finds old keys only in provenance notes.

**V2 fully withdrawn** in `positioning.md` §4, `frontier_map.md` O7 and §4, the Area H blockquote, and the contribution statement, which now *cites* Bochner and Stinchcombe–White. **V2 CLOSED.**

**C4 closed and the risk register correctly re-weighted** — the "somebody extends CFF 2025" row now states the evidence was downgraded, so the risk is less well bounded than round 1 implied.

---

## (b) CRITICAL FINDINGS

**None.**

---

## (c) CITATION ACCURACY — MAXIMUM SEVERITY

### Verified correct against `instrumental.bib` (mechanical, first-party)

| Claim | Status |
|---|---|
| **C1 fix.** `beyhumlapentalavergne2025` = *The Econometrics Journal* **28**(2), 176–197, 2025 | ✅ matches exactly |
| **C1 knock-on.** §5's re-derived ET case rests on Carrasco–Florens 2000, Stinchcombe–White 1998, Escanciano 2006, Fan–Li 2000, Babii–Florens 2025 | ✅ **All five genuinely ET.** Re-derivation sound |
| **C2 fix.** Both JRSS-B entries now 2026 at 88(3), distinct online-first notes | ✅ resolved |
| `feve2014` = JoE **181**(2), 151–164 — **full abstract in the bib entry** | ✅ every Fève–Florens claim first-party verifiable |
| `poirier2017` abstract in bib matches B12's quoted "Summary (published abstract)" **word for word** | ✅ |
| 13 "IN BIB" claims | ✅ **13 of 13 present**, fields as annotated |
| 11 new round-2 keys vs `instrumental.bib` | ✅ **Zero collisions** |

**BibTeX well-formedness: clean.** All **56** entries parse; no duplicates; no collisions. Spot-checked correct: `carrascoflorens2000`, `dominguezlobato2004`, `chamberlain1987`, `newey1990`, `newey1994var` (correctly distinguished from `newey1994h`), `ichimuranewey2022`, `bkrw1993`, `bennettkallus2023vmm`.

### G-1-A — UNSUPPORTED CLAIM: the PDF was not demonstrably obtained. — MAJOR

Five places assert the Google Drive preprint was retrieved (`positioning.md`:65, :73, :301; `annotated_bibliography.md`:165, :167), including *"the PDF's own annotation links … contain multiple citations to 'Robinson88'."* The orchestrator tried all three Drive endpoints and got HTTP 404 on each. Same file that produced round 1's confabulation. **Strike the claim and remove the Robinson88 strand from leg 2** — it is presented as *independent* corroboration, which is weight it cannot bear.

Deducting for over-claim, not fabrication: the librarian honestly reported the prose as unextractable and did not claim to have read the text. But this is the second consecutive round in which this one file generated an unreproducible assertion, and it is load-bearing for the open gate. **−3.**

### G-1-B — The surviving evidence names no source. — MAJOR

Leg 2 is now the whole argument and rests on five direct quotations, none attributed. Attribution is *"two published secondary descriptions, surfaced independently"* — **neither named in any of the four files.** None of these strings appears in the published abstract at `instrumental.bib:15`. G-1 is being escalated to the user; the user cannot weigh evidence they cannot locate. **Name both sources. −2.**

### C6 — Coverage-summary bookkeeping still wrong, third round. — MINOR

- **Row G reads "8 | 4 | 4"; it is 3 in bib / 5 new** — new error introduced this round.
- **Row H's "14 new" is an entry count, not a key count** — H17 carries two keys, so Area H contributes **15**. The note *"Row H now reports its true key count"* is false.
- **Totals should be 35 | 55, not 36 | 54** — and `references.bib` holds **56** entries.
- **Area-letter collision:** `references.bib` labels its final block "AREA K — Variational / adversarial estimation" while the annotated bibliography's Area K is the linear-NPIV canon.

**−1.**

---

## (d) COVERAGE

**Round-1 gaps F-1 through F-5: all five CLOSED, and closed well.**

- **F-1.** Fève & Florens (2014) now Competitor 4, G1 in the annotated bibliography, in the frontier diagram, its own §2.3, the §4 clause table, both O1 and O2, the JoE row of §5, Referee A, prep item 2, an objection row and a risk row. **O2 is now stated *against* it, not around it.**
- **F-2.** The CGMM block is **substantive, not a dump** — connects Carrasco–Florens's regularised-inverse-of-the-covariance-operator result to plan §14's open $\mu$ question in three files.
- **F-3.** Domínguez–Lobato integrated as an **identification** point; O6 correctly narrowed.
- **F-4.** All three domain-profile-mandated anchors present, plus Chamberlain and Ichimura–Newey.
- **F-5.** Linear-NPIV canon annotated with scores and falls-short clauses; Bennett–Kallus VMM added.

### F-6 — NEW GAP: regularisation theory for the *nonlinear* Landweber step is absent, and it is in the author's own bibliography. — MAJOR

This is a theory paper whose nuisance step is Landweber–Fridman on a **nonlinear** ill-posed operator equation, and whose `thm:rootn` product remainder needs a rate for $\hat\varphi$. Three references already in `instrumental.bib` appear in **none** of the four deliverables:

- **`hanke1995`** — Hanke, Neubauer & Scherzer, *Numerische Mathematik* **72**(1), 21–37. Bib abstract: *"we prove that the Landweber iteration is a stable method for solving **nonlinear** ill-posed problems… we propose a stopping rule that yields the convergence rate $O(\delta^{1/2})$ **under appropriate conditions**."* This is the convergence theorem for the $\varphi$-step, and the "appropriate conditions" are the **tangential-cone condition** the theorist will have to state.
- **`engl2000`** — Engl, Hanke & Neubauer, *Regularization of Inverse Problems*. Primary source for source conditions, semiconvergence, spectral cut-off and stopping rules — vocabulary the deliverables use throughout and attribute only to Carrasco–Florens–Renault (2007).
- **`chenreiss2011`** — Chen & Reiß, *ET* **27**(3), 497–521. The anchor for O9, which the frontier map declares open and positioning carries as a risk row, with no citation.

`positioning.md` §4 answers *"Why not regularised Newton?"* with *"LF semiconvergence gives a clean stopping rule"* — invoking the result without citing the paper that proves it. Referee A is explicitly the Florens/Carrasco/Johannes/Dunker circle. **−3.**

### F-7 — No overlap / irregular-identification anchor for the new Assumption A4. — MINOR

Plan §17.4 adds A4 (overlap) and warns overlap is a real question at 689/300. **Khan & Tamer (2010), *Econometrica* 78(6), 2021–2042** is canonical for $\sqrt n$ failure under limited overlap and bears on the A2 ∧ A4 interaction. In neither bibliography. **−1.**

### Otherwise
**Scope correct** (90 entries, 11 areas). **Journal quality excellent** — 12/56 unpublished (~21%). **Recency excellent.** **Frontier map strong** and materially improved.

---

## (e) CATEGORISATION

### P-1 — CLOSED ✅
Proximity now strictly competition distance with a separate Role tag. Exactly four entries score **1** and all four are COMPETITOR. The round-1 two-dimensional score is gone. New Areas I/J/K scored on the corrected scale.

### N-1 — NOT FIXED. REGRESSED. — MAJOR

`frontier_map.md` §0, headed *"The maintained moment family (notation, corrected)"* and *"The display a drafter should copy is"*:
$$M(u,t) = E\big[\{W-\varrho(\Delta Z)\}\,\Phi_u(\Delta U)\,e^{\,t'\Delta Z}\big]$$

The plan's notation contract defines $\Phi(\cdot)$ as a bounded one-to-one transform **of $\Delta Z$**, and plan §2.2 writes $\mathcal{M}(u,t) := E[\widetilde W\,\mathbf 1\{\Delta U\le u\}\,w(t'\Phi(\Delta Z))]$. All ten $\Phi$ usages in the plan are on $\Delta Z$.

The "restoration" put $\Phi$ on the wrong argument. Three consequences:

1. **The original defect is not fixed** — the weight is still $e^{t'\Delta Z}$ with no $\Phi$, precisely what plan §2.2 forbids. The display is internally incoherent: the next line repeats the plan's rationale about a formula in which it no longer holds.
2. **Three-way symbol collision.** $\Phi_u(\Delta U)$ collides with the contract's $\Phi(\Delta Z)$ **and** with $\Phi_{CI}$ from Lemma L1 — which `annotated_bibliography.md` line 24 uses correctly in the same file where line 20 uses $\Phi_u$.
3. **Duplicated** in two files, both instructing the drafter to take $\Phi$'s definition from plan §2.2 while displaying something the plan does not contain.

The one place round 2 made a deliverable worse than round 1, in the display flagged for copying. **−3.**

### P-2 — Verdict-carrying tables assert the item under check without a marker. — MINOR
`frontier_map.md` §4 (two rows) and `positioning.md` §1.1 state Poirier's well-posedness flatly, with no G-1 marker, while §1/§2.5/§5 flag it prominently. These summary tables are what a drafter lifts. **−1.**

---

## (f) DEDUCTION TABLE

| # | Finding | Axis | Sev | Ded. |
|---|---|---|---|---|
| **G-1-A** | Five assertions the Poirier Drive PDF "resolves"/"downloads" + `Robinson88` annotations used as independent corroboration — unreproducible, same file as round 1's confabulation | Citation accuracy | MAX | **−3** |
| **N-1** | $\Phi$ restored onto the wrong argument; original defect unfixed; three-way collision; duplicated and labelled "corrected" | Categorisation | MAJOR | **−3** |
| **F-6** | `hanke1995`, `engl2000`, `chenreiss2011` absent from all four files though in `instrumental.bib` | Coverage | MAJOR | **−3** |
| **G-1-B** | Entire surviving G-1 argument rests on unattributed quotations while escalated to the user | Citation accuracy | MAX | **−2** |
| **C6** | Row G wrong; row H "true key count" false; totals off; AREA K collision | Citation accuracy | MINOR | **−1** |
| **F-7** | No Khan–Tamer (2010) anchor for A4 | Coverage | MINOR | **−1** |
| **P-2** | Three verdict-carrying rows assert Poirier's well-posedness with no G-1 marker | Categorisation | MINOR | **−1** |

**Total: −14 → FINAL SCORE 86/100. Gate cleared.**

**Closed without deduction:** V1, V2, C1, C2, C3, C4, C5, F-1, F-2, F-3, F-4, F-5, P-1, G-2. Twelve of thirteen round-1 findings fully closed, several propagated further than asked — including into the plan itself (§17.5 now carries the V2 withdrawal with citations).

---

## (g) RESIDUAL RISK ON G-1, FOR THE USER ESCALATION

**The verdict moves to PARTIAL OVERLAP if and only if** at least one example in Poirier (2017) §2 puts an **endogenous regressor inside the nonparametric component**, making that nuisance ill-posed. Concretely: if his "instrumental variables regression model" is *nonparametric* IV rather than linear/parametric, or if the partially linear example's $\varphi$ takes an endogenous argument.

**Settled, first-party.** The published abstract at `instrumental.bib:15` confirms the paper computes the efficiency bound for **finite-dimensional** parameters under unconditional and conditional independence, proposes an estimator that **attains** it, built on *"a growing number of zero-covariance conditions asymptotically equivalent to the independence restriction,"* illustrated with *"an instrumental variables regression model and partially linear regression models."*

**Not settled.** Whether either example is ill-posed. "Instrumental variables regression model" is ambiguous between linear IV (well-posed) and NPIV (ill-posed).

**No longer counts.** Attainment of a finite bound is *not* evidence against ill-posedness — a finite-dimensional structural parameter can be $\sqrt n$-estimable under an ill-posed nuisance given a range condition, exactly what this paper's A2 supplies. Round-1 leg 1 argued the opposite and is correctly withdrawn. Leg 3 withdrawn. The `Robinson88` strand should now also be discounted.

**What carries the argument.** Two structural descriptions, both unnamed: (i) Poirier's class is models *"identified using zero-covariance or mean-independence restrictions,"* where full independence is a **strengthening** that buys efficiency — structurally different from this paper, where mean independence is *vacuous* under a binary instrument and independence is the sole channel; (ii) the estimator is *optimally-weighted GMM over countable basis functions*, which is not how one estimates in an ill-posed problem, where regularisation replaces an optimal weighting matrix. Both plausible and mutually consistent; neither checkable as written.

**Net.** Direction of evidence unchanged from round 1; its *kind* improved — structural and bibliographic rather than readership-based — and one strand should be struck. **Probability the verdict moves: low, not negligible.** Cannot be reduced further from open sources.

**What would close it.** Ten minutes with the ScienceDirect HTML from a university network, or any library PDF: read §2 and the two examples. Failing that, email the author. **If either example is ill-posed**, the contribution narrows from "first" to "extends Poirier from a well-posed to a nonlinear ill-posed nuisance, in a panel, with a binary instrument" — still publishable, but the headline sentence changes and `positioning.md` §1, §3 and `frontier_map.md` O1 must be rewritten.

---

## (h) ROUTING

**Accept the Stage 1 deliverables.** Do not run a third librarian round.

Carry four items into Stage 2, alongside the two the librarian lists (`deaner2025` status; Fève & Florens full text):

1. **Escalate G-1 to the user** as an institutional-access action, with the residual-risk statement above.
2. **Strike the `Robinson88` / "PDF downloads" claims**; name the two secondary sources or drop the quotations. *(Editorial, minutes.)*
3. **Fix the $\Phi$ display** to $M(u,t)=E[\{W-\varrho(\Delta Z)\}\,\mathbf 1\{\Delta U\le u\}\,w(t'\Phi(\Delta Z))]$ per plan §1 and §2.2. **Prime the notation-warden on the $\Phi$ / $\Phi_u$ / $\Phi_{CI}$ collision.** *(Editorial, minutes.)*
4. **Add `hanke1995`, `engl2000`, `chenreiss2011`** with annotations; consider Khan–Tamer (2010) for A4.

*This report evaluates and scores only. No deliverable was edited and no bibliography content was produced.*
