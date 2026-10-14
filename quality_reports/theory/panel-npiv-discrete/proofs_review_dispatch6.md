# Theory Review — memo §10 Step 4: `prp:sharpquad`, L-20 (`lem:formstruct`), L-21 (`lem:reprsmooth`)

**Reviewer:** theorist-critic · **Severity:** HIGH (Execution) · **Gate:** 80 · **Fresh strike counter (new content)**
**Persisted by the orchestrator.**

**Read:** `results.tex` Part G (ll. 1713–2236), `proofs.tex` Part G (ll. 2118–2562) and `lem:solset`(iii) (ll. 1413–1547), `assumptions.tex` A2′/A2b/A2c (ll. 536–666), `theory_memo.md` §D-00000000, `notation_glossary.md` §1.5c/§1.6, `proof_strategy_memo.md` (:224–238, :505–522), the five new specs, `check_rendering_sync.py`.

## SCORE: **80 / 100 — PASS AT GATE.**

| | Count |
|---|---|
| CRITICAL | **0** |
| MAJOR | 3 |
| MINOR | 6 |

Clears commit (80). Does not clear PR (90) or submission (95). **No conclusion in Part G is wrong; every substantive claim checked holds.** The three MAJORs are repairable in a short pass — two in one and three sentences respectively, the third in one character.

---

## Phase 1 — Claim identification

- **Object type:** (a) sufficient-condition lemma discharging a sup-norm regularity primitive (L-21); (b) operator-structure lemma — decomposition, essential spectrum, compactness dichotomy, indefiniteness (L-20); (c) a **sharpness / negative result** — exact identity for the supremum of a quadratic form over a ball, plus lower bound, non-compactness consequence, weak-norm refutation.
- **Quantifier:** $\sup_{h\in\mathcal V,\|h\|\le\delta}$ — the best bound valid *uniformly on the ball*, not a statement about a realised estimation path. Correctly and repeatedly scoped in `rem:sharpscope`(1).
- **Main results:** `eq:sharpconst` $\sup\tfrac12|\langle\mathcal Bh,h\rangle|=\tfrac12\delta^2\|P_{\mathcal V}\mathcal B_{\rm sym}P_{\mathcal V}|_{\mathcal V}\|$; `eq:bracket` $\|\vartheta'\sigma_q/\pi\|_\infty\le\|P_{\mathcal V}\mathcal B_{\rm sym}P_{\mathcal V}|_{\mathcal V}\|\le\|\mathcal B_{\rm sym}\|\le\|\mathcal B\|$; `eq:l21budget` $\Lambda^{(0)}_\star+\Lambda^{(1)}_\star\le c_{\mu''}\Lambda^{(\mu'')}_\star$.

---

## Phase 2 — Proof validity: **VALID with three repairable gaps**

### Verified correct
- **`eq:embedconst` arithmetic.** Step 1 gives $\tfrac{2(2\pi)^{1/2}}{2\pi}=\sqrt{2/\pi}$, exactly $c_{\mu''}$'s prefactor. Finiteness via $(1+\xi^2)^{1-\mu''}\le\min\{1,|\xi|^{2-2\mu''}\}$ with $2-2\mu''<-1$. Threshold binding at $\mu''=\tfrac32$. The "$\mu''>\tfrac12$ for $L^\infty$, $\mu''>\tfrac32$ for the derivative" accounting is correct.
- **Both halves of `eq:bracket`** — via `eq:complower` (spectral chain *and* the singular-sequence route), and $\|B_{\mathcal V}\|\le\|B_{\rm sym}\|\le\|\mathcal B\|$ by projection contraction.
- **"No downstream consequence changes" is TRUE — every consumer checked.** `lem:balance` is first-order and never touches $\mathcal B$; `def:spaces` and `lem:solset`(iii) already carry the compression and already state `eq:complower` in compressed form; `thm:rootn` is unwritten.
- **Singular sequence (L-20(ii)).** Non-atomic finite measure ⟹ fine positive-measure partitions ⟹ infinite-dimensional $L^2(\mathcal X_0,\pi)$ ⟹ orthonormal sequence; Bessel ⟹ weak null; compactness ⟹ the three limits; $\|1\|=1$ ⟹ the $P_{\mathcal V}$ correction.
- **Numerical-radius identity.** Polarisation requires symmetry (holds here); parallelogram gives $\le4\mathsf c_1$. Real-field use in Step 1 correct.
- **Weyl criterion and the rank-$\le2$ argument.** $B-PBP=RB+(I-R)BR$; $PBP=(PBP|_{\mathcal V})\oplus0$ with $\sigma_{\rm ess}(0|_{\rm 1-dim})=\emptyset$.
- **`lem:solset`(iii)'s witness, arithmetic re-derived.** $q=-c\varsigma(x_1)\varsigma(x_2)$, $\pi\equiv1$: $\sigma_q\equiv0$, form $=2c\ne0$.
- **The reordered $\mathcal X_0$ construction and its two dependent sites.** `lem:formstruct`(iii) uses $\mathsf c_0\ge\|\cdot\|_\infty-\varepsilon$ and closes with $\varepsilon\downarrow0$; `prp:sharpquad` Step 6 fixes $\varepsilon<\tfrac12\|\cdot\|_\infty$. **The emptiness bug is genuinely fixed at both named sites.**

### Issue 2.1 — L-21 Step 2 cites the measurability of the *wrong object* [MAJOR, −5]
`proofs.tex:2221–2246`. Step 2 opens by **redefining** $\ell^\Pi_\star(u,t)$ to be Step 1's continuous representative. Four lines later the mollification is written in that same symbol and justified "jointly measurable ... **by Step 0**" — but Step 0 established measurability of the **pre-redefinition** representative. Read literally, it cites a property of a different function, and of the object whose measurability is being proved.

**The mathematics is right.** The saving observation: at each $t\in\mathcal T_\ast$ the two versions agree Lebesgue-a.e. in $u$, so the interval average is *identical* for every $(u,t)$ — **which is precisely why averaging works where the transform does not.** That observation is nowhere stated. **This is the single load-bearing step of the rebuilt argument and a referee stops here.** One sentence closes it.

### Issue 2.2 — $\mathcal T_\ast$ and the $H^{\mu''}$-budget used as measurable without construction [MAJOR, −3]
`proofs.tex:2227–2242`, `assumptions.tex:592–594`. Step 2 asserts convergence "on $\IR\times\mathcal T_\ast$" and concludes "jointly measurable on the measurable set where it exists" — presupposing $\IR\times\mathcal T_\ast$ measurable; nothing establishes it. One level up, `eq:lambdamu` integrates $t\mapsto\|\ell^\Pi(\cdot,t)\|_{H^{\mu''}(\IR)}$, whose measurability is never established — **and by the file's own argument cannot come from Fubini on the transform.**

**This is the exact defect Step 3 exists to fix for $\Lambda^{(0)},\Lambda^{(1)}$, sitting one level up in the assumption that drives the lemma.** Consequently the round-9 header claim at `proofs.tex:2816` — "MEASURABILITY IS NOT ASSUMED ANYWHERE IN L-21" — is **inaccurate**. Both repairs are cheap: choose $\mathcal T_\ast$ measurable (the complement lies in a measurable null set); get the norm map by the same countable-supremum device Step 3 already uses, over $H^{\mu''}$–$H^{-\mu''}$ duality. −3 rather than −5 because A2c's wording is fairly read as asserting well-definedness.

### Issue 2.3 — `rem:l21route`(d) prints a false $H^2$-norm identity [MAJOR, −3]
`results.tex:1882–1890` prints $\|g\|^2_{H^2}=\|g\|^2+\|g'\|^2+\|g''\|^2$. Under `eq:usobolev`'s convention $(1+\xi^2)^2=1+2\xi^2+\xi^4$, so the correct identity carries $+\mathbf 2\|g'\|^2$. **The set is right; the norm is not.** *(Orchestrator independently confirmed the expansion.)*

**On the $c_2$ question the dispatch raised — both constants are correct and the recorded sharp value is safe.** $\int(1+\xi^2)^{-1}=\pi$ so $c_2=\sqrt2$, and `l21-embedding-constant-mu2` pins exactly the right quantity. Step 1′ is *also* correct against `eq:usobolev` — $2\|g\|\|g'\|\le\|g\|^2+\|g'\|^2\le\|g\|^2+2\|g'\|^2+\|g''\|^2$ — so "$\sqrt2<2$" is a genuine like-for-like comparison, not a category error. **The defect is the printed definition alone, in the one passage telling an applied reader how to check A2c without the transform.**

### Issue 2.4 — `lem:formstruct`(v) invokes clause (ii) outside its hypothesis [MINOR, −3]
`proofs.tex:2412–2415` — *the "third site" the dispatch asked about*. The two sets are the raw sign sets $\{\vartheta'\sigma_q/\pi\gtrless0\}$, which do not satisfy (ii)'s premise $|\vartheta'\sigma_q/\pi|\ge\mathsf c_0-\varepsilon$ for any $\varepsilon$ small enough to make $\mathsf c_0-\varepsilon>0$; taking $\varepsilon$ large enough makes the modulus bound vacuous and no sign information survives.

**It does not assume the old ordering — so the reordering is complete in that sense** — but it applies (ii) at a set that need not meet its premise. Repair: pass to a near-supremum subset *within* each sign set, automatically one-signed. **MINOR rather than MAJOR because the conclusion is independently delivered in the same sentence by the (iii) route.**

### Issue 2.5 — `cor:elldiff`'s "defined pointwise" hypothesis not verified [MINOR, −2]
`proofs.tex:2271–2274`. Step 5 concludes A2b from (i.a)+(i.b) alone. The clause does follow — from (iii)'s budget, B1(ii)'s envelope, Step 2's joint measurability — but the file's own standard is to print such checks, and this one gates the corollary being applied.

---

## Phase 3 — Assumptions and statements

### Adjudication: the O-16 split. **AGREED, on all five links.**

1. **(b) ⟹ (a): holds, by two independent routes.** Via `eq:complower`, $\|\mathcal B_{\mathcal V}\|\ge\|\vartheta'\sigma_q/\pi\|_\infty>0$, so the numerical-radius identity yields $h$ with $\langle\mathcal B_{\mathcal V}h,h\rangle\ne0$ — **needing neither `lem:formstruct`(ii) nor C2′(i)**. The tower property gives $\langle\mathcal Bh,h\rangle=\vartheta'E[q(\Delta h)^2]$, so "form nonzero" and O-16(a) are the same statement.
2. **(a) ⟹̸ (b): the counterexample is valid** — `lem:solset`(iii)'s witness, re-derived, living inside `def:model` and C1(ii).
3. **Therefore lever 1's target $\sigma_q\equiv0$ does NOT remove the $\delta^2$ order.** The three things that *do* change are each stated correctly in `rem:sharpscope`(3).
4. **SG-15 sweeps a lower bound — and the critic states the consequence one notch sharper than the theorist:** since the compact part is *unconstrained* by $\sigma_q$, **the objective is not even monotone in the quantity of interest** — a selection lowering $\|\vartheta'\sigma_q/\pi\|_\infty$ can in principle *raise* $\|\mathcal B_{\mathcal V}\|$. Driving the sweep to zero makes `eq:complower` vacuous while leaving the sharp constant free. **SG-15 should be described as minimising a *certified lower bound*, and any claim that it improves the constant requires the compression's norm computed directly.**
5. **$q\not\equiv0$ alone is insufficient for (a).** Antisymmetric $qf_{X_1,X_2}$ against symmetric $(\Delta h)^2$ integrates to zero; the example is internally coherent, since antisymmetric $k=qf$ with symmetric $f$ also forces $\sigma_q\equiv0$.

**N-13 containment: VERIFIED.** `prp:sharpquad`(iii)–(iv) write both O-16 clauses out as explicit hypotheses rather than citing a tag; `rem:sharpscope`(4) says they are "asserted nowhere"; nothing in Part G asserts $Q(h)\ne0$ necessarily.

### Adjudication: L-20 as a "collection". **LEGITIMATE, not a dodge.**
All three registered defects verified independently: `proof_strategy_memo.md:521` does write $\mathcal B$ where it says $\mathcal B_{\rm sym}$ (memo §2.5 repeats it); all three "unstated conditions" are theorems at `proofs.tex:1452–1476`; the Weyl implication does need compactness *and* non-atomicity, both already carried at `lem:solset`(iii):1496–1503 with the atom counterexample.

**Judgment:** L-20's registered content migrated into `lem:solset`(iii) in round 7; `lem:formstruct` restates it as one citable block and **adds four genuinely new clauses** — (ii)'s singular sequence (carrying (iv), (v) and `prp:sharpquad`(iv), and supplying a **spectral-theorem-free route to `eq:complower`**), (iii)'s transfer to the compression, (iv)'s dichotomy, (v)'s indefiniteness. **It is delivered as a single five-clause lemma, not scattered; "collection" describes provenance, not form.** Nothing is papered over.

### Issue 3.1 — L-21's advertised B1-minimality is not exact [MINOR, −1]
Four sites claim "no clause of B1 ... B1(ii) and B1(iv) are used only in that they *define* symbols". **Step 0 consumes *finiteness* of $\Pi_u$ and $\Pi_t$ — B1(iv.a)–(iv.b), substantive — twice**: for product-measurable representatives (a σ-finiteness fact, not definitional) and for Tonelli.

### Issue 3.2 — `prp:sharpquad` inherits C2′(i) into clauses that do not need it [MINOR, −1]
`results.tex:1973` says "the hypotheses of `lem:formstruct`" wholesale, while `lem:formstruct` is scrupulous that C2′(i) "is consumed by clause (ii) alone". Only clause (iv) needs compactness of $\mathcal A_{\rm cond}$. Against the round-7 "cited by clause, not as a block" convention this should be scoped.

### Observation (no deduction)
The title "The second-order remainder is exactly of order $\delta^2$ on the ball" is unconditional, but "exactly of order" holds only under O-16(a). The lead sentence hedges correctly and `rem:sharpscope` blocks the reading — a title tweak, not a finding.

---

## Phase 4 — Notation, citations, polish

### Adjudication: the two declines. **Both right; one for a stronger reason than the other.**

**Italic $Q$ (C38) — correct, and first-best rather than a compromise.** $Q_{12}$ supplies the jointly measurable version of $q$ inside `lem:secondord`(i) — the chain `prp:sharpquad` runs on — and the incumbent lives at six sites in a closed proof. **But the decisive point is that the substitute is better than any name:** writing the remainder as $\langle\mathcal Bh,h\rangle_{L^2(\pi)}$ **makes the sharp constant readable off the notation, which is the substantive content of the whole proposition.** Moving the incumbent would have been expensive and produced a worse artifact.

**$g_\vartheta$ (C44) — correct, but reason (b) carries it, not reason (a).** Reason (b) — an abbreviation re-collapses the §8.4 item 2 distinction between the multiplier $\sigma_q$ and multiplication *by* $\vartheta'\sigma_q/\pi$, which is what C7 retired $M$ to protect — is decisive. **Reason (a) is weaker than presented:** $g_\vartheta$ is a function on $\mathcal X$ while $g$ is a moment weight on the observables, and the types separate them.

**On the accumulation worry:** real and worth naming, **but not yet binding.** $\vartheta'\sigma_q/\pi$ is three glyphs; at ~15 sites the readability cost is small against the collision cost. **The right tripwire is the *displays*, not the count of declines — and Part G's displays remain legible.**

**$h_k$ and the §1.7 amendment: sound.** Subscript-type separation is already the device §1.7 uses three times; the amendment is made in the open; the sweep is the right check.

### Adjudication: inline proof versus `.bib` entries. **Right for (F-a) and (F-b); defensible but overstated for (F-c).**
- **(F-a) Sobolev embedding** — right, and barely a choice: the paper needs the *constant* in `eq:usobolev`'s specific normalisation, which no textbook states.
- **(F-b) Numerical radius = norm** — right. Three lines, and the **real**-field version is exactly the one most references state over $\mathbb C$.
- **(F-c) Essential-spectrum invariance** — the inline proof derives invariance from the **Weyl criterion, itself asserted without a pin**, and $\sigma_{\rm ess}(\text{mult})=\operatorname{ess\,ran}$ is still asserted at `lem:solset`(iii) uncited. A genuine improvement, but `proofs.tex:2803–2806`'s "no longer has a step that rests on an unavailable reference" **overstates it**.

**No deduction, for one verified reason: every conclusion of `prp:sharpquad` was traced and NONE depends on an unpinned spectral theorem.** `eq:complower` has the transform-free constructive route; the essential-spectrum identity is used only for a parenthetical in Step 3 and for (v), which has the (ii) route. **The load-bearing chain is self-contained** — which is what makes the inline choice defensible rather than evasive. The missing `.bib` entries are a **submission-gate** item for the librarian, not commit-gate.

### Issue 4.1 — the declined abbreviation survives at one site [MINOR, −1]
`proofs.tex:2156` still writes `g_vartheta` in a comment. It does not render, **but it is precisely the species of stale string §1.5b exists to catch, and neither new declined-slot sync row covers it** (they guard italic $Q(h)$ and $\|M/\pi\|$).

### Issue 4.2 — "the sharp constant" names two quantities in one proof [MINOR, −1]
`proofs.tex:1484` (sup over the $L^2(\pi)$ sphere) versus `:1533` (on $\mathcal V$). Both right in context, so ambiguity rather than error, and pre-existing — **but it is now the round's headline distinction, and the round swept for the symbol without sweeping for the phrase.**

### Verified clean
`prp:sharpquad` carries its `\label`; (O1) marked DISCHARGED with the meaning correctly qualified ("an assumption with a proved sufficient condition is still an assumption"); the two declined-slot sync rows exist; glossary §1.5c records all seven dispositions with sweeps; `sharpquad-symnorm-strictly-below`'s witness checks out ($B=[[1,2],[0,1]]$: $\|B_{\rm sym}\|=2$, $\|B\|=1+\sqrt2$, strict).

---

## Deduction table

| # | Finding | Severity | Δ |
|---|---|---|---|
| 2.1 | L-21 Step 2 cites Step 0's measurability for the post-redefinition symbol; the identification of the two interval averages is unstated | MAJOR | −5 |
| 2.2 | $\mathcal T_\ast$ used as measurable without construction; the $H^{\mu''}$-budget's measurability never established; the header's blanket claim inaccurate | MAJOR | −3 |
| 2.3 | `rem:l21route`(d) prints $\|g\|^2_{H^2}$ without the factor 2 on $\|g'\|^2$ | MAJOR | −3 |
| 2.4 | `lem:formstruct`(v) invokes (ii) at the raw sign sets, which need not satisfy its hypothesis | MINOR | −3 |
| 2.5 | `cor:elldiff`'s pointwise-definition hypothesis not verified before application | MINOR | −2 |
| 3.1 | L-21's "no clause of B1" minimality claim (4 sites) not exact | MINOR | −1 |
| 3.2 | `prp:sharpquad` inherits C2′(i) into clauses (i)–(iii) | MINOR | −1 |
| 4.1 | Declined $g_\vartheta$ survives at `proofs.tex:2156`, unguarded by either new sync row | MINOR | −1 |
| 4.2 | "the sharp constant" names two quantities (`:1484` vs `:1533`) | MINOR | −1 |
| | | **Total** | **−20** |

---

## Priority recommendations
1. **[MAJOR]** `proofs.tex:2234` — state that the interval average is unchanged by the redefinition (versions agree Lebesgue-a.e. in $u$ at each $t\in\mathcal T_\ast$). **The step the round was rebuilt around.**
2. **[MAJOR]** `proofs.tex:2227` — construct $\mathcal T_\ast$ measurable; add the countable-supremum/duality line for the norm map; amend `:2816`'s blanket claim.
3. **[MAJOR]** `results.tex:1884` — restore the factor 2. Both constants and the spec need no change.
4. **[MINOR]** 2.4, 2.5, 3.1, 3.2, 4.1, 4.2 — all local.

---

## Routing

- **Step 6 (`prp:phirate`) CAN OPEN NOW**, in parallel with the fix pass — it runs on L-18, L-19, L-12, L-13, A6, A7 and the TCC route, with **no dependence on Part G**. Its opening task is **(O4)**, which `rem:obligations` already assigns to it. **State that explicitly in the dispatch.**
- **Step 7 (`thm:rootn`) must NOT open yet**, for two reasons independent of the score. The Part G fix pass must land, because `rem:sharpscope`(2) changes what `thm:rootn` may inherit — **the lower bound, not the identity, and NOT memo §2.5(iii)'s "$\delta_n=o(n^{-1/4})$ is sharp for this moment function"**, which is a necessity claim Part G deliberately does not prove. And **N-13 is still open, and `thm:rootn`'s scope sentence is exactly where the O-11 overclaim would leak into the paper.**
- **Steps 8–9** unaffected; schedule as registered.

**Narrow critics: re-sweep REQUIRED, after the fix pass. No narrow critic has seen Part G.**
1. **regularity-checker** — highest value; L-21 Steps 0–3 are dense with measurability, Tonelli, mollification and countable-supremum steps, and Issues 2.1/2.2 are squarely its remit.
2. **assumption-auditor** — A2c is a new property tag with one consumer and no usage row; Issues 3.1/3.2 are its bucket (deducted lightly here to avoid double-scoring the 20% assumption-parsimony component).
3. **counterexample-hunter** — has never seen `prp:sharpquad`; CP-12 is registered and aimed at its hypothesis. **A submission binary gate (`quality.md` §4.3); must run before Step 7 closes.**
4. **notation-warden** — seven new dispositions (C38–C44), the §1.7 amendment, Issues 4.1/4.2.
5. **derivation-verifier** — nothing further; all five specs MATCH and two were confirmed by hand.

**`/simulate`: hold until the fix pass, then dispatch WITH A DESIGN CORRECTION.** At 80 the simulation-engineer is technically unblocked, but the O-16 split changes what the first simulation must sweep. **A Monte Carlo driving $\sigma_q\to0$ and expecting the $\delta^2$ order to vanish would be testing the wrong hypothesis** — that is O-16(b), and (b) ⟹̸ vanishing form. **The DGP must target O-16(a) (the form on $\mathcal V$), not O-16(b) (the multiplier)**, and CP-12's "$q\equiv0$ by construction" is the correct target. **Put this in the dispatch or the first simulation round will be wasted.**

**(O2)–(O4) block nothing.** (O2) and (O3) are Step 6/7 discharge sites carried as explicit hypotheses meanwhile — inputs to `thm:rootn`, not blockers. (O4) is Step 6's opening task, not a precondition.

**Coordinator items (not the theorist's), four memo corrections now owed:** **N-13** (must be amended before Step 7 writes the scope sentence); **§2.5(i)** and **the L-20 row at :521** (both write $\mathcal B_{\rm sym}=m\cdot-2\tilde{\mathcal K}$, which is $\mathcal B$); **§2.5(i)**'s ball (exact on $L^2(\pi)$, upper bound on $\mathcal V$); **§2.5(iii)**'s necessity claim. Also **SG-15's description → "minimises a certified lower bound"**, with the non-monotonicity caveat.

## Positive findings

1. **The rebuilt measurability route is the right mathematics, and the reason it is right is the reason the transform route fails.** Averaging is invariant to the choice of version; the Fourier transform on $L^2$ is an $L^2$-limit with no version-invariant pointwise meaning. **Catching that mid-round, discarding a completed draft, and printing why the discarded route is unavailable — because it is the one a reader will reconstruct — is the behaviour that finds defects before referees do.**
2. **The O-16 split is a genuine contribution, correctly proved, and it changes a design decision.** Two non-equivalent conditions were riding under one tag. **Exactly the kind of finding that only surfaces when someone writes the proof rather than the schedule.**
3. **The scope discipline in `rem:sharpscope` is exemplary.** Four false readings blocked, each with the true version alongside, and the registered display corrected rather than reproduced. **The distinction between "the order is unimprovable" and "the estimator's remainder is not $o_P$" is the one a referee would have forced; the paper makes it unprompted.**
