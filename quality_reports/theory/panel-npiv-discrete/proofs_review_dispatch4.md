# Theory Review — `panel-npiv-discrete`, consolidated narrow-critic fix round (round 7)

**Date:** 2026-07-29 · **Reviewer:** theorist-critic · **Severity:** HIGH (Execution) · **Gate:** 80
**Persisted by the orchestrator.** Written to `proofs_review_dispatch4.md`, **not** `proofs_review_dispatch3.md`, which holds the recovered three-round dispatch-3 record.

**Strike counter:** fresh — this is the routed handoff the round-3 critic recommended, not a fourth round of dispatch 3. **Strike 1 of 3.**

**Files read end to end:** `quality_reports/theory/panel-npiv-discrete/{results.tex, proofs.tex, assumptions.tex, notation_glossary.md, theory_memo.md}`; the three sweeps at `quality_reports/{regularity/regularity-audit_dispatch2-partF.md, notation/notation-table.md, assumptions/usage-matrix.md}`; the renderings under `paper/sections/theorems/`; both specs under `scripts/symbolic/specs/`.

Step 4 (`prp:sharpquad`, L-20, L-21) and Part F renderings are **not** scored as missing, per the dispatch.

## SCORE: **66 / 100 — DOES NOT CLEAR 80.**

| | Count |
|---|---|
| CRITICAL | **0** |
| MAJOR | 4 |
| MINOR | 5 |
| Advisory | 1 |

**Binary gates:** no confirmed counterexample — the F-1 construction is now *captured by assumption* via `def:dirclass`(b) and printed as `rem:shiftclass`. **Both regularity CRITICALs discharged.** Nothing to escalate; no mathematical dispute; no proof broken.

---

## Phase 1: Claim identification

- **Object type:** Neyman orthogonality + second-order expansion of a debiased moment in three nuisances; plus a balancing bound on first-order bias. Supporting: solution-set structure and the selection functional.
- **Target:** $\theta_\dagger$ in a first-differenced panel NPIV model with a binary instrument; moment $\psi=\Delta Z\,\Delta U+\widetilde W L(\Delta U,\Delta Z)$.
- **New objects this round:** `def:weight` (anchored $u$-antiderivative $L^{\,b}_\ell$, and $L_\star$), `def:dirclass` (admissible direction pairs with seminorms $\|\cdot\|_{0,h}$ sup-outside and $\|\cdot\|_{1,h}$ sup-inside), `rem:anchor`, `rem:supinside`, `rem:shiftclass`, tag N1′, A2′(iii), A5(vi).
- **Data structure:** i.i.d. two-period panel, cross-fitted.

---

## Phase 2: Proof validity — **VALID. No CRITICAL remains.**

### Priority 1 — the three adjudications. **The theorist is right on all three, verified against the artifact.**

**1. regularity F-5 is one quantifier short — CONFIRMED, and the theorist's remedy is correct.**
F-5 proposes the sup-**outside** condition $\sup_{|\tau_1|\le\bar\tau}E[\partial_uD(\Delta U-\tau_1\Delta h,\Delta Z)^2]<\infty$ and then licenses DCT "with envelope $\sup_{|\tau_1|\le\bar\tau}|\partial_uD|\cdot|\Delta h|$". Integrability of that envelope requires $E[\sup_s\|\partial_uD\|^2]<\infty$ — sup **inside** — and $\sup_s\|f_s\|_{L^2}<\infty$ does not give $\|\sup_s f_s\|_{L^2}<\infty$.

**Separating witness:** $g(u)=|u|^{-1/4}\mathbf 1\{0<u<1\}$ has $\|g\|_{L^2}^2=2$ for every shift, while $\sup_{|s|\le1}g(\cdot-s)\equiv\infty$ on $(0,1)$.

`def:dirclass`'s asymmetric statement (`results.tex:1150–1172`) is therefore **well formed, not malformed, and both CRITICALs stay closed.**

The theorist's re-accounting is also *better* than the checker's: F-5 said four of six second-order terms need a $D$-envelope; in fact only the three $\tau_1$-derivatives require an interchange at all, and only $\partial^2_{\tau_1\tau_2}$ involves $D$ (`proofs.tex:1538–1559`). Verified term by term. **"One envelope, not four" is correct.**

*Caveat (MINOR, folded into 3.2's neighbourhood):* `rem:supinside`'s title says the asymmetry is "forced". What is established is that sup-outside does not license the *DCT route*; an $L^2$-continuity/Fubini route with a different added condition is not excluded. The remark itself concedes the point ("nothing is lost by stating the stronger form"). Rhetoric, not mathematics.

**2. notation-warden T1-2 ($\psi$) — CONFIRMED half-wrong.** The glossary row for $\psi$ (`notation_glossary.md:197`) fixes the reserved meaning as *the moment function*. The Part-F sites the warden lists as violations are that reserved use. **One violation (the Laplace transform), not two.** The rename to $\mathsf L_\Gamma$ introduces no new letter. Correct.

**3. notation-warden T1-6 ($\ell_\dagger$) — CONFIRMED wrong at the named site.** §8.5 (`notation_glossary.md:373–389`) marks *range-space* objects with $\Pi$; `results.tex`'s $\ell_\dagger:=\mathcal W\ell^\Pi_\dagger$ is an observable-space object and must **not** carry it. The missing glossary row is now at `:194`. Correct.

### Priority 2 — both CRITICALs discharged

**F-1.** `def:dirclass`(b) plus scoping $\Psi$ to $[-\bar\tau,\bar\tau]\times\IR^2$ makes $\Psi$ finite off $\tau_1=0$ (`proofs.tex:1506–1524`), which is exactly what clauses (ii) and (iii) presupposed. The "worse than stated" reading is right: with $D=\mathbf 1\{u>1\}(u-1)^{-1}$ both parts of $\Psi(1,\tau_2,\tau_3)$ diverge when $\widetilde W$ is non-degenerate, so (ii)'s "identically in $\tau$" was **ill-posed rather than false**.

**The rejection of the density-ratio alternative is correct, and I checked it independently:** with $\Delta U\sim U[0,1]$ and $\Delta h=-1$ on $A$, the shifted law assigns mass $P(A)\tau_1>0$ to $\{u>1\}$, a **null set of the true law**, so no Radon–Nikodym derivative exists. The condition fails whenever the conditional support of $\Delta U$ is bounded in the shift direction and $\Delta h$ is non-degenerate. It is also strictly stronger, since it bounds every $\Xi$ at once. The theorist adopted F-1's *first* offered condition and rejected only its "sufficient primitive" — **a faithful reading of the finding.**

**F-2.** `def:weight` + A2′(iii) (`assumptions.tex:523–542`) define $L_\star$ and price the anchor alone. **The equivalence in `prp:orthog`(iii) is non-vacuous with N1 withheld:** A2′(iii) requires only $E\|b_\star(\Delta Z)\|^2<\infty$, which does not pin $b_\star$ to the N1 anchor, so the right-hand side remains a genuine restriction. **This is the crux of F-2 and it is handled correctly** — a standing "$L_\star$ satisfies N1" convention would have voided the proposition, and the memo's argument that it would also be false for `cor:udep`'s affine weights checks out. `rem:anchor`'s two admissibility computations are correct (conditional Jensen, A1b(iv)).

### Other regularity items, verified

- **F-4 (Weyl on the wrong space) — fully repaired.** Re-derived: $\mathcal V=\{1\}^\perp$ has codimension one; $\mathcal B_{\rm sym}-P_{\mathcal V}\mathcal B_{\rm sym}P_{\mathcal V}=(I-P_{\mathcal V})\mathcal B_{\rm sym}+P_{\mathcal V}\mathcal B_{\rm sym}(I-P_{\mathcal V})$ has rank $\le2$; the direct-sum/empty-essential-spectrum step and the transfer of $\|\vartheta'\sigma_q/\pi\|_\infty$ are all correct (`proofs.tex:1468–1487`). `def:spaces` now names the exception (`results.tex:95–101`). **Step 4's stated blocker is genuinely cleared.**
- **F-3 (Hilbert–Schmidt)** — computation correct, including the kernel with respect to $\pi(x_2)dx_2$ and the use of $\iint f_{X_1,X_2}=1$.
- **F-7 (FTC → MVT)** — correctly repaired, with the everywhere-pointwise reading moved into the hypothesis and the a.e. reading's Cantor-function failure printed.
- **m-6 witness** — algebra checked ($\sigma_q=\sigma_{q'}\equiv0$, $E[q(\Delta h)^2]=2c$): correct, and now inside `def:model` and C1(ii).

### Issue 2.1 — `lem:secondord`(iv) is stated in a norm nothing prices [MAJOR, −7]

- **Location:** `results.tex:1280–1285` (statement); `proofs.tex:1652–1661` (Step 5).
- **Problem:** The statement prints the bound $2\bar c_\pi^{1/2}\|D\|_{1,h}\|h\|_{L^2(\pi)}$. The proof derives the *sharper* $2\bar c_\pi^{1/2}\|\partial_uD\|_{L^2(P)}\|h\|$ and then weakens it. A5(iv) prices $\epsilon_n=\|\partial_u(\hat L-L_\star)\|_{L^2(P)}$ — the sharper one. **Nothing anywhere prices $\|\cdot\|_{0,h}$ or $\|\cdot\|_{1,h}$:** both seminorms occur only inside Part F and are absent from `assumptions.tex`. Yet Step 5 closes "which is what makes them $O_P(\delta_n\epsilon_n)$ and $O_P(\delta_n r_n)$ under A5" — an instantiation at $D=\hat L-L_\star$, while clause (iv) is conditional on $(D,\mathsf r)$ being differentiable in the sense of `def:dirclass`, i.e. on $\|\hat L-L_\star\|_{1,h}<\infty$ a.s. **That membership is neither assumed nor discharged.**
- **Why it matters here specifically:** this is the round's own root cause — *an object priced at the true residual and then used at a shifted one* — **displaced one step forward.** The block records the symmetric forward obligation twice elsewhere (A2′(i.b): "L-21 MUST NOW DELIVER THE SUP-INSIDE FORM", `assumptions.tex:699`; and N1′: "Step 6 or 7 must supply that control", `proofs.tex:1648`). The obligation created by `def:dirclass` is the one that got no note.
- **Fix:** print (iv) in $\|\partial_uD\|_{L^2(P)}$, keep $\|D\|_{1,h}$ as the stated weakening, and add one forward-reference sentence requiring Step 6/7 to establish $\|\hat L-L_\star\|_{0,h}$ and $\|\hat L-L_\star\|_{1,h}$ finite w.p.a.1 (or a new A5 clause).

---

## Phase 3: Assumptions and statements

### Issue 3.1 — `prp:orthog`(i) defines its central object by reference to a lemma whose hypothesis list it disclaims [MAJOR, −5]

- **Location:** `results.tex:1296–1299`: "*write $\Psi_L$ for the map of \cref{lem:secondord} with $L$ in place of $L_\star$*", inside a clause headed "*Structural function — stated at an arbitrary admissible representer, and A2 is not assumed.*"
- **Problem:** `lem:secondord`'s hypothesis list is "A1b(i), A1b(iv), B1(i), (ii), (iv.a), C1(ii) and **A2′**", and its $\Psi$ is defined only after fixing $\bar\tau$, $h$, and an admissible direction pair $(D,\mathsf r)$ — none of which `prp:orthog`(i) introduces. The object in the conclusion is under-specified, and the italicised hypothesis reduction (the round's centrepiece: "drops A2 and A2′ from that part altogether") is **not readable off the statement**.
- **The proof is correct** — it re-derives from `cor:elldiff` under `def:weight`(a)'s admissibility clause, and the equivalence chain $\nu_g\equiv0\iff\nu_{\widetilde W\ell}=-\nu\iff\mathcal A^\ast_{\rm cond}\ell^\Pi=-\nu/\pi$ needs no A2 (A2 asserts existence; here a given $\ell^\Pi$ is characterised). **The defect is in the statement**, and hypothesis-list fidelity is exactly what the auditor sweep was about.
- **Fix:** one line — define $\Psi_L(\tau_1):=E[\psi(\theta_\dagger,(\vdagger+\tau_1h,L,\varrho))]$ in place.

### Issue 3.2 — "affine in $(\tau_2,\tau_3)$ jointly" is false as written [MINOR, −3]

- **Location:** `proofs.tex:1528`; repeated at `results.tex:1179` (`rem:supinside`).
- The integrand contains $-\tau_2\tau_3\,\mathsf r D(\Delta U-\tau_1\Delta h,\Delta Z)$. It is **bi-affine, not jointly affine.** Read literally, joint affineness gives $\partial^2_{\tau_2\tau_3}\Psi\equiv0$ — precisely what clause (iii) denies. The enumeration two lines later shows the cross term *was* accounted for, so the conclusion stands. But **this is the single sentence that licenses the "no interchange needed" re-accounting**, so it should read "affine in each of $\tau_2,\tau_3$ separately, with one bilinear term".

### Issue 3.3 — mixed-partial order and Hessian symmetry unstated [MINOR, −2]
`lem:secondord`(iv) computes $\partial_{\tau_1}$ of the exact $\tau_2$-coefficient and prints it in symmetric-Hessian notation; symmetry is neither claimed nor needed here, but Step 6/7 takes a second-order expansion along a path and should be told which object it inherits.

### Issue 3.4 — `lem:secondord` lists A1b(i) with no citing step [ADVISORY, 0]
The natural consumer is $\vdagger\in\mathcal V$ via `eq:trialres`; the memo's own Part-F usage table records A1b(i) as consumed. Name the step or cut it — the auditor will re-sweep this.

### Removals (Priority 3) — checked, none broke a consumer

| Removal | Verified |
|---|---|
| (P4a) deleted | `proofs.tex:22–28`; `rem:draftrec`(ii) was the only pointer and is handled ✓ |
| `prp:orthog`(i) loses A2 | Both consumers (`lem:solset`(ii), `lem:balance`) supply A2′ themselves ✓ |
| $P^{\rm Leb}_{L_x}$ gone | Only surviving mention records the removal (`proofs.tex:1831`); the minimality-of-$P_{L_x}$ route is correct ✓ |
| C3's $\mathcal C_0$ written out | `assumptions.tex:1256`, $[-c_C,c_C]$; $\mathcal C_0$ now `cor:udep`-only ✓ |
| `lem:secondord`(iv)'s $\|\partial_uD\|<\infty$ implied | `def:dirclass`'s $s=0$ remark ✓ |
| `lem:adjfubini`'s A0 appeal struck | `proofs.tex:803–804`, with the $\sigma$-finiteness reason; A0 gains `lem:balance`, `lem:levels` ✓ |
| Five C1 → C1(ii); `cor:elldiff` B1(iv) → (iv.a) | ✓ |
| Anchor prices one scalar moment | A2′(iii) ✓, demonstrably weakest — the "what more would buy: nothing" argument checks out |

### Sweep findings (Priority 4) — spot-check

- **N1's five sites:** decision made once (`assumptions.tex:926–971`), property reading adopted, N1 struck from `lem:secondord`/`lem:solset`/`lem:balance`, N1′ tagged, glossary $L$ row and Discussion aligned, `cor:udep` keeps it as a genuine hypothesis. ✓ Clean.
- **`prp:orthog`(i)'s second "iff":** non-vacuous under the representer quantifier ✓ (residual bookkeeping in 3.1).
- **$\mathcal B$'s four referents:** resolved in the source — `cor:rangegap`'s operator → $\Upsilon$ (18 sites), Borel → $\mathfrak B(\cdot)$, and the unenforceable "never carries a subscript" rule **replaced rather than patched** ✓. **Not resolved in the renderings** — see 4.2.
- **The two glossary rows printing the refuted $\mathcal B_{\rm sym}$ formula:** both corrected, C12 with an explicit in-place round-7 correction ✓.
- **Part F hypothesis-list inheritance:** B1(i),(ii),(iv) onto `lem:secondord` and `prp:orthog`; C2′(i) onto `prp:orthog`; A1b(i),(iv) onto `lem:solset`; A1 struck from `lem:secondord` (checked line by line — the only `A1*` citations in `proofs.tex:1496–1662` are A1b(iv)) ✓.
- **`eq:nuhat`** scoped inside (iii) ✓; memo M-6 row corrected in place with strikethrough ✓; the "NOT PROVED HERE" list corrected in place ✓; $\mu''$ referent slip corrected to $\ell^\Pi_\star$ in note, budget table and glossary ✓; A5(iv)/A8 budget row now route-conditional with a "Route" column ✓; A4 note (d) variance referent moved to $L_\star$ ✓; `eq:gproviso` divergence between `results.tex` and `rem-nophifree.tex` synced ✓.

---

## Phase 4: Citations, notation, renderings

### Issue 4.1 — the binding glossary still names $\varsigma$ as the Step-4 direction [MAJOR, −5] — **THIS GATES STEP 4**

`notation_glossary.md:170`:
> `| $\sigma_q$ | ... **$\IR^p$-valued** (C18), so `prp:sharpquad` is stated for a fixed direction $\varsigma'\psi$, $\varsigma\in\IR^p$ — see §8.4 |`

This contradicts C25 (`:86`), the $\vartheta$ row (`:241`) and **§8.4 item 2 (`:347`, "The direction letter is $\vartheta$ and not $\varsigma$") — the section it points at.** It is the T1-4 site the warden named, it re-creates the "a local symbol cannot be made binding" defect C25 exists to remove, and it sits in the row a Step-4 author will read, in a file declared binding on every later `.tex`, whose §8.4 is labelled "Binding on the Step-4 dispatch". **One string.**

### Issue 4.2 — the one $\psi$ violation the theorist itself certified is live in the compiled paper [MAJOR, −6]

C26 states the genuine breach is "the Laplace transform, in `lem:bierenscore`'s proof **and its Part C rendering**." The source is fixed (`proofs.tex:496–524`, $\mathsf L_\Gamma$). **`paper/sections/theorems/lem-bierens.tex` still writes $\psi(t):=E[\varepsilon e^{t'\Phi(V)}]$ at lines 60, 65, 70, 71, 73, 74, 77**, and its header is still marked "ROUND 2" with **no round-7 sync note**.

Since the full document now compiles all four theorem files together, **the 26-page artifact carries $\psi$ with two meanings** — moment function in `rem-nophifree.tex:99,101,106,129,130,136,150`, Laplace transform in `lem-bierens.tex` — which is the INV-7 collision this round adjudicated as real.

By contrast `lem-adjoint.tex:50–57` *does* carry an explicit round-7 deferral note. That is the right discipline and it is not charged for the $\Upsilon$ rename.

### Issue 4.3 — `lem-adjoint.tex`'s deferral note is itself incomplete [MINOR, −2]
It enumerates five unsynced items and omits a sixth: the Borel $\mathcal B(\cdot)\to\mathfrak B(\cdot)$ rename, still live at `lem-adjoint.tex:182` and `:488`. **A hand-maintained deferral list reproducing the hand-maintained-header failure the same header warns against, one remove further out.**

### Issue 4.4 — glossary C15 is stale [MINOR, −2]
`notation_glossary.md:62` still asserts "`assapp3`'s compact support interval is $\mathcal C_0$", superseded by C24 (`:85`). C12 received an explicit in-place round-7 correction for the same species of problem; C15 did not.

### Issue 4.5 — `secondord-shift-nonintegrable`: honest header, under-delivering spec [MINOR, −2]
The header is **exemplary** — it separates what SymPy evaluates ($\int u^{-1}du=\log u$) from what a human reads off it, and states that a spec "must not be quoted as certifying more than it evaluates." That is the MAJ-2 lesson correctly applied, and it should be kept.

**But the boundary does not travel with the artifact.** What propagates upward is "62 specs, 62 MATCH" — as it did in this very dispatch — and the `claim_id` names a non-integrability result the spec does not check. The stated rationale ("branch-free indefinite-integral form precisely so that it cannot fail on a `Piecewise`") **does not hold**: `integrate(1/u, (u, 0, 1))` under `positive=True` returns `oo`, and `limit(log(u), u, 0, '+')` returns `-oo`; neither produces a `Piecewise`. A strictly better mechanical form was available at zero cost.

The `secondord-crossterm-tau1` header rewrite, by contrast, is **fully satisfactory** — it names both halves of the refuted conclusion and explains why the model is retained.

---

## Deduction table

| # | Finding | Severity | Δ |
|---|---|---|---|
| 2.1 | `lem:secondord`(iv) denominated in an unpriced norm; direction-class membership at $\hat L-L_\star$ asserted, never established; no forward obligation recorded | MAJOR | −7 |
| 4.2 | Certified $\psi$ violation live in the compiled paper (`lem-bierens.tex`), no deferral note | MAJOR | −6 |
| 3.1 | `prp:orthog`(i) defines $\Psi_L$ by reference to a lemma assuming A2′, in the clause disclaiming A2′; $\bar\tau,h,(D,\mathsf r)$ unquantified | MAJOR | −5 |
| 4.1 | Binding glossary `:170` still names $\varsigma$ as the Step-4 direction, contradicting C25 / `:241` / §8.4 | MAJOR | −5 |
| 3.2 | "affine in $(\tau_2,\tau_3)$ jointly" false as written, in the licensing sentence (×2 sites) | MINOR | −3 |
| 4.3 | `lem-adjoint.tex` deferral note omits the Borel rename | MINOR | −2 |
| 4.4 | Glossary C15 stale against C24 | MINOR | −2 |
| 4.5 | `secondord-shift-nonintegrable`: name over-promises content; better branch-free form available | MINOR | −2 |
| 3.3 | Mixed-partial order / Hessian symmetry unstated for Step 6/7 | MINOR | −2 |
| 3.4 | A1b(i) listed on `lem:secondord` with no citing step | ADVISORY | 0 |
| | | **Total** | **−34** |

---

## Priority recommendations

1. **[MAJOR]** Print `lem:secondord`(iv) in $\|\partial_uD\|_{L^2(P)}$ (the norm the proof establishes and A5(iv) prices), keep $\|D\|_{1,h}$ as the stated weakening, and add the forward obligation on $\|\hat L-L_\star\|_{0,h}$, $\|\hat L-L_\star\|_{1,h}$ — matching the discipline already applied to A2′(i.b)/L-21 and N1′.
2. **[MAJOR]** Sync $\psi\to\mathsf L_\Gamma$ in `paper/sections/theorems/lem-bierens.tex`, or give that file a round-7 deferral note of the kind `lem-adjoint.tex:50–57` already carries.
3. **[MAJOR]** Define $\Psi_L$ in place in `prp:orthog`(i).
4. **[MAJOR]** One string at `notation_glossary.md:170`: $\varsigma\to\vartheta$. **This one gates Step 4.**
5. **[MINOR]** 3.2, 4.3, 4.4, 4.5, 3.3 — all local.

## Positive findings

- **Three for three on adjudications.** Each counter-claim was checked against the artifact and each is right, including the one that mattered most: **F-5's stated condition genuinely could not carry its own envelope.** Catching a critic's remedy at the same quantifier the project repaired in round 5 is the correct instinct, and the resulting `def:dirclass` is well formed.
- **The two CRITICALs are closed on the merits, not papered over.** A2′(iii) prices exactly one scalar moment and leaves `prp:orthog`(iii)'s equivalence with real content — the hardest thing to get right in F-2, and where a lazier repair (a standing N1 convention) would have voided the proposition that justifies the whole rate architecture.
- **F-4's codimension-one compression is correct and unblocks Step 4.** Re-derived independently. This was the stated sequencing reason for deferring `prp:sharpquad`, and **the deferral was justified.**
- **The removal-over-addition discipline held under scrutiny.** Eight removals, no orphaned consumer. And the in-place strikethrough convention (memo M-4/M-6, D-00000.6, the "NOT PROVED HERE" list) is genuinely good practice — **it is what let me verify the corrections rather than guess at them. Keep it.**

## Routing recommendation

**One short targeted fix round, then re-sweep notation-warden and assumption-auditor, then Step 4.**

Not an escalation: nothing here is a mathematical dispute, and no proof is broken. All four MAJORs are local — two are single strings, two are single sentences plus one hypothesis note.

- **regularity-checker does NOT need re-running before Step 4** — its Part F CRITICALs and MAJORs are discharged and the substantive ones were verified independently.
- **notation-warden must re-run** — 4.1–4.4 are all in its lane.
- **assumption-auditor must re-run** — 2.1 and 3.1 are hypothesis-list findings in its lane.

**Step 4 must not open until item 4 is fixed:** `prp:sharpquad`'s author will read the $\sigma_q$ glossary row and be told the direction is $\varsigma$ — exactly the defect C25 was written to remove.
