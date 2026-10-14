<!-- Persisted by the orchestrator 2026-07-30 on receipt. Round-2 review of Part I,
     against proofs_review_dispatch10.md (48/100). Body verbatim. -->

# Theory Review — Part I, `panel-npiv-discrete` — **Round 2 (post-fix)**

**Severity applied:** HIGH (Execution) · **Reviewer:** theorist-critic · **Read-only; no files edited**
**Score: 91 / 100** · 0 CRITICAL · 0 MAJOR · 2 MODERATE · 2 MINOR
**Strike 2 of 3 — the file now clears the 80 commit gate and the 90 PR gate.** It does not clear 95 (submission). No binary-gate block.

---

## 1. Headline

All fourteen round-1 findings are closed. I re-derived each fix rather than checking that it was edited near, and **the mathematics is now sound at every site I flagged**. The four MAJORs are genuinely repaired: the margin identity is right and now displayed, the $o_P$ companion is a correct theorem correctly applied at both sites, the A5(ii) sweep reached every compiled site I named, and `cor:ratefloor` is scoped correctly — further than I asked, on an argument I verified.

**The fix round opened no fifth MAJOR.** The two refusals are both upheld against me. What remains is four items: one stale definitional row in the glossary, two residual instances of a class the fix round repaired at two of four sites, and two hygiene items — none of which moves a conclusion.

---

## 2. Disposition of the fourteen round-1 findings

| # | Round-1 finding | Δ | Disposition | Evidence |
|---|---|---|---|---|
| **2.1** | $\frac{1-\kappa}{4\kappa}=\frac1{4\mu}$ false | −10 | **CLOSED, over-delivered** | `proofs.tex:5371`, `results.tex:4540–4543` now read $\frac1{8\mu}$ with $1-\kappa=(2\mu+1)^{-1}$, $4\kappa=8\mu/(2\mu+1)$ inline; numbers $\tfrac3{20}$, $\tfrac1{16}$; three memo sites swept. Infimum claim **verified**. |
| **2.2** | (P8) invoked for $o_P$ at two $O_P$ sites | −8 | **CLOSED** | Companion at `proofs.tex:226–255`; cited `proofs.tex:5153–5158` (exp 2) and `5240–5244` (exp 1). Proof and both exponents verified. |
| **4.2** | A5(ii) sweep not run | −7 | **CLOSED at all four named sites** | `rem:phirscope`(2) rewritten (`results.tex:3852–3864`); `prp:stopfeas`(iv) opening display repaired (`:2949–2953`); both `assumptions.tex` comments swept (`:1618–1622`). One *unnamed* residual → **N1**. |
| **3.1** | `cor:ratefloor` over-claim; $\mu'$ undefined | −5 | **CLOSED, over-delivered** | Three-clause branch scoping at `results.tex:4422–4452`; $\mu'$ deleted, glossary §8.7 records it. Sufficiency argument **verified correct**. |
| **3.4** | (R-e.1) not fold-indexed | −5 | **CLOSED** | `def:crossfit`(d) + `eq:foldrates` (`results.tex:4078–4097`); (R-e.1) carries $\max_k$ (`:4381–4384`); `lem:epterm`, `lem:prelimtheta` cite the fold reading in their own lists. |
| **3.2** | (R-b)'s $E\|b_\star\|^4$ unused | −4 | **CLOSED; deletion verified safe** | Re-grepped `b_\star`: live at `proofs.tex:1703, 1705, 4859, 4863` only, all at **second** moment under A2′(iii). Nothing orphaned. |
| **3.5** | (T-4) vs Step 0; corollary outside its lemmas | −4 | **CLOSED at both named lemmas** | (T-4) annotated by status (`results.tex:4345–4354`), Step 0 agrees (`proofs.tex:5282–5289`); `lem:sandwich`(i′) added; A5(vi) with $s>\tfrac12$ added. Residual at a *third* lemma → **N2(a)**. |
| **2.3 / 3.3** | `cor:elldiff` on A2′(i.a) alone | −4 | **CLOSED** | `lem:momzero` lists A2′(i) in full (`results.tex:3977–3984`); redundancy re-attributed to A2′(i)+B1(i),(ii),(iv.a) (`:4006–4009`). |
| **3.6** | A5-promotion ground false; `rem:obligations` stale | −4 | **CLOSED; (b)'s premise WITHDRAWN** | Ground replaced with four substantive grounds at `rem:rootnhyp`(5) (`:4667–4693`) and `rem:obligations` (`:1597–1604`). See Ruling 1. |
| **2.4** | `def:onestep` differentiability | −1 | **CLOSED, correctly relocated** | `def:crossfit`(c) states the three well-posedness properties (`:4069–4077`); `def:onestep` separates first from second derivative (`:4124–4131`). The fix round's diagnosis is better than mine. |
| **m1** | `rem:rootnhyp`(2) heading | −1 | **CLOSED** | Re-headed "**Not** listed … and not consumed" (`:4643–4645`). |
| **m2** | `lem:epterm` headline | −1 | **CLOSED** | `:4256–4259`. |
| **m3** | `lem:prelimtheta` collapse | −1 | **CLOSED on the proof side; re-verified** | Step 2 now uncollapsed (`proofs.tex:5320–5332`). $\sqrt n(n^{-1/2}+\delta_n)^2\le2(n^{-1/2}+\sqrt n\delta_n^2)$, threshold exactly $\delta_n=o(n^{-1/4})$. |
| **m4** | `prp:medianpart` per partition | −1 | **CLOSED** | `:4460–4467`; $\mathsf P$ fixed now used three times. |
| **4.4a** | $\Psi^\theta_n$ "written out" | −1 | **CLOSED** | `:4236–4238`. |
| **4.4b** | (P8) scope | −1 | **CLOSED** | `:4031–4045` — conditioning convention re-declared, not inherited. |
| **4.5** | §.6 short by one ($\epsilon^L_n$) | folded | **CLOSED** | Memo items 3′ and 4′ (`theory_memo.md:403–418`). |

**The one the fix round found itself is real.** `lem:sandwich` cited `lem:momzero`(ii)–(iii) while omitting A1 and B1(i),(ii),(iv.a). `results.tex:4287–4294` now inherits the list in full; `lem:sandwich`(i′) repeats it.

---

## 3. Rulings on the two refusals

### Ruling 1 — "(R-a) **carries**, not discharges, (O3)": **REFUSAL UPHELD. I was wrong.**

My own round-1 sentence contained its refutation: *"If (R-a) discharges (O3) … and I agree it does, **by assuming** the one property `eq:dirmember` needs."* Assuming is not discharging, and the concessive clause said so.

The file's own test decides it. (O1)'s discharge is a **lemma** — `lem:reprsmooth` derives A2′(i.a)–(i.b) from A2c. (O4)'s is a **construction** — `eq:hatAcon` exhibits the operator. (R-a) neither derives nor exhibits: it asserts $\hat L^{(-k)}=L^{\,\hat b^{(-k)}}_{\hat\ell^{(-k)}}$. If assertion counted, A5(iv) through round 7 — which printed the identity $\|\partial_u(\hat L-L_\star)\|=\|\hat\ell-\ell_\star\|$ *inside the clause* — would have "discharged" (O3), and that is precisely the defect `rem:obligations` exists to name.

**The internal-consistency question settles it in the same direction.** Three live records say $\hat\ell$ is unconstructed: `cor:ratefloor`(b) (`results.tex:4429–4431`), memo §.6 item 3, and glossary C79's $\epsilon_n$ row, which states the identity is an *assertion* conditional on undischarged (O3). Marking (O3) discharged would have put the single inventory in contradiction with all three. **"Two remain open" is the reading under which all four agree.**

Finding 3.6(b)'s first half is **WITHDRAWN**. Its second half is **CLOSED, better than I asked**: `results.tex:1513–1524` records both changes, names the Part-I consumers, distinguishes "carried" from "discharged," and states that (R-c.2) *prices* rather than assumes away — the honest third category, correctly labelled.

### Ruling 2 — the $V_n$ form of the $o_P$ companion: **REFUSAL UPHELD; correct and correctly applied.**

**Statement and proof** (`proofs.tex:226–240`). With $a_n$ deterministic, $V_n$ $\mathcal G$-measurable, and $P(|X_n|>\epsilon a_n\mid\mathcal G)\le V_n\epsilon^{-\mathrm{exp}}$ a.s. for **all** $\epsilon>0$: since $\{V_n\le\eta\}\in\mathcal G$,
$P(|X_n|>\epsilon a_n)=E[P(\cdot\mid\mathcal G)]\le P(V_n>\eta)+E[\mathbf 1\{V_n\le\eta\}V_n\epsilon^{-\mathrm{exp}}]\le P(V_n>\eta)+\eta\epsilon^{-\mathrm{exp}}$; $\limsup_n$ gives $\eta\epsilon^{-\mathrm{exp}}$, then $\eta\downarrow0$. Correct; the header's note that no bounded-convergence appeal is needed is right.

**Site 1, `lem:epterm` Step 6** (`proofs.tex:5147–5158`). After rescaling by $n(n_k/n)^2\le n_k$, conditional Chebyshev on the squared norm gives the bound at $a_n=1$ with **exponent two** and $V_n=\|\hat\psi^{(-k)}-\psi_\star\|^2_{L^2(P)}$, $\sigma(\mathcal I_{-k})$-measurable and $o_P(1)$ by `eq:psiL2`. Correct.

**Site 2, `lem:sandwich` Step 8** (`proofs.tex:5235–5244`). Conditional Markov on a nonnegative variable with conditional mean exactly $V_n$ gives **exponent one**, $a_n=1$, same $V_n$. Correct.

Two things easy to get wrong and got right: the quantifier order is stated as "almost surely **and** for every $\epsilon>0$" at both sites — one null set, then all $\epsilon$; and both sites say explicitly why the $O_P$ transfer rule would not serve.

---

## 4. The two claims verified on request

**Infimum claim (2.1) — CONFIRMED.** $f(\alpha)=\alpha(1+\kappa)-\tfrac12$ is strictly increasing; `eq:frontier` gives $\alpha>1/(4\kappa)$; $f(1/(4\kappa))=\frac{1-\kappa}{4\kappa}=\frac1{8\mu}$. The infimum over admissible $\alpha$ is $\frac1{8\mu}$, **not attained** — and the text says "infimum," not "minimum," which is the correct word. It is genuine rather than vacuous: `eq:muhalf` forces $\mu>\tfrac56$, hence $\kappa>\tfrac58$, hence $1/(4\kappa)<\tfrac25<\tfrac12$, so $\alpha$ can approach $1/(4\kappa)^+$ inside $(0,\tfrac12)$.

**Sufficiency argument (3.1) — CONFIRMED, and a real strengthening of my finding.** Scoping to (R-e.2) removes $\epsilon_n$ but leaves $\epsilon^L_n$ alive through (R-c.2) in the $r_n\epsilon^L_n$ term, and $\epsilon^L_n$ has no primitive supplier. Only (R-c.1) kills it, via $\Psi^{(3)}_k=0$ by the second half of `eq:biasb4`. The claim holds on **(R-e.2) and (R-c.1)** and on no weaker pair. My round-1 instruction was necessary but not sufficient.

---

## 5. New objects, reviewed at full severity

**`lem:sandwich`(i′) with Step 6′ — VALID.** Checked (i′)'s list against Steps 1–6 line by line: Step 1 (A0, A1b(iv)); Step 2 ((R-a), A1b(iv), conditional Chebyshev with the $O_P$ transfer rule, bounding constant $\|\hat\ell^{(-k)}\|^2_\infty E\|\Delta Z\|^2=O_P(1)$); Step 3 (three braces bounded by the three consistency statements, with (P1), `lem:nusigma`(i), C1(ii), A4(i)–(iii)); Step 4 ($\mathsf F$ fixed); Step 5 ((R-a), (P1), A1b(iv), $\hat\theta^{(0)}$ consistency); Step 6 (A3); $J$ finite by `lem:momzero`(iii), whose full list (i′) carries. **Every hypothesis in (i′)'s list is consumed and none is missing.** The claim that `eq:psiL2` is nowhere invoked in Steps 1–6 is true, and the closing note that (ii) has no analogue is correct.

**`eq:foldrates` — VALID.** Displays 1 and 2 are *derived*, not assumed: Step 0 gets $\|h_k\|_{L^2(\pi)}=O_P(\delta_n)$ per fold from (T-5) with $n_{-k}\asymp n$, and a max of finitely many $O_P(\delta_n)$ statements is $O_P(\delta_n)$; A5(vi) follows from A5(vi′)'s w.p.$\to1$ envelope at the final stage on each fold complement. Display 3 is a genuine strengthening of A5(iv) in form, and charging it to (R-e.1) rather than reading it into A5(iv) is the correct disposition.

---

## 6. New findings

### N1. MODERATE (−4) — The A5(ii) sweep missed the glossary's own definitional row; the glossary now contradicts itself.

`notation_glossary.md:565`:

```
| $\delta_n$ | rate | $\|\hat\varphi-\vdagger\|_{L^2(\pi)}=O_P(\delta_n)$, $\delta_n=\hat\delta_n^{2\mu/(2\mu+1)}$ | memo §3.3 |
```

This is the **live definitional row** for $\delta_n$, writing the log-free form that `eq:deltalog` and amended A5(ii) supersede. The same file, at line 626, states the opposite: *"Clause (ii) **now defines** $\delta_n:=(\hat\delta_n\ln n)^{2\mu/(2\mu+1)}$."*

Not a rendering-lag artifact: **the glossary was edited three times this round.** The dispatch-11 note closes with *"A glossary row that is more careful than the file it describes is doing its job."* The row defining the file's most-used rate symbol is, this round, less careful than the file it describes. It is the one site of finding 4.2's class the sweep did not reach, and the site a reader consults first. Violates INV-7.

### N2. MODERATE (−3) — The (i′)-style repair reached two lemmas, not the remaining two instances of the class.

**(a) `cor:ratefloor` still rests on a proof-internal reading — now of `lem:prelimtheta`.** `lem:sandwich`(i′) carries $\|\hat\theta^{(0)}-\theta_\dagger\|=o_P(1)$ as an **explicit hypothesis** (`results.tex:4300`). The corollary's proof (`proofs.tex:5409–5411`) enumerates what supplies "(i′)'s three consistency statements" and is silent on this fourth. It then uses $\|\hat\theta^{(0)}-\theta_\dagger\|=O_P(n^{-1/2}+\delta_n)$ at `:5417`. Both come from `lem:prelimtheta`, whose stated list (`results.tex:4166–4168`) includes A5(ii)'s second half $\delta_n=o_P(n^{-1/4})$ — the one clause this corollary exists to do without. The conclusion is true (Steps 1–4 deliver the first equality from `eq:foldrates` display 1 alone, and $\delta_n\to0$ is assumed), but that is a reading of the lemma's *proof* — the exact defect clause (i′) was created to eliminate, one lemma short.

**(b) `lem:prelimtheta` Step 3 cites `lem:momzero`(i) outside its own list.** `proofs.tex:4927`: *"By `lem:momzero`(i), $E[\Delta Z\Delta U]=0$."* `lem:momzero`'s list is A1, A1b(iv), A2′(i), A2′(iii), B1(i),(ii),(iv.a); `lem:prelimtheta` carries A0, A1, A1b(iv), C1(ii) and advertises *"No condition on $\hat\ell$, on $\hat L$, on $\hat\varrho$, on $L_x$ or on A2 is used"* (`results.tex:4184`). The needed fact is one line from A1's second clause plus the tower property with $E\|\Delta Z\Delta U\|<\infty$ — both carried — but the citation imports A2′ and B1 into a lemma whose selling point is that it needs neither.

### N3. MINOR (−1) — `rem:obligations`(O3)'s "where the condition lives now" is short by one home, and the fix round made it so.

`results.tex:1563–1565` locates (O3) at `rem:dirmember` and (R-a). But `def:crossfit`(c) now asserts the construction *and* the three properties `def:weight`(b) needs, *"stated here rather than inherited"* (`:4072–4075`). Every Part-I result that adopts `def:crossfit` therefore carries (O3) through a definition as well.

### N4. MINOR (−1) — Index collision at `thm:rootn` Step 0.

`proofs.tex:5278–5280`: *"A5(vi$'$) is consumed inside `prp:phirate` and A5(vi) follows from it **at $k=\bar k$** on each fold complement."* Here $k$ is the linearisation-**stage** index, in a paragraph where $k$ is the **fold** index — $h_k$, $\mathcal I_{-k}$, $\hat\varphi^{(-k)}$ all appear within three sentences, separated only by the sign of the superscript. INV-7.

---

## 7. Score

| # | Finding | Severity | Δ |
|---|---|---|---|
| N1 | Glossary $\delta_n$ row stale; contradicts its own A5 row | MODERATE | −4 |
| N2 | (i′)-class repair short at two further sites | MODERATE | −3 |
| N3 | `rem:obligations`(O3) home list short by `def:crossfit`(c) | MINOR | −1 |
| N4 | Stage-vs-fold $k$ collision at Step 0 | MINOR | −1 |
| | **Total** | | **−9** |

## **Score: 91 / 100.**

**Clears 80 (commit) and 90 (PR). Does not clear 95 (submission).** What blocks 95 is N1 and N2 — hypothesis-and-symbol hygiene, neither touching a conclusion. No CRITICAL, no MAJOR, no unresolved counterexample, every Part-I theorem proved: **no binary-gate block.**

---

## 8. What the fix round did that deserves saying

1. **It refused me twice and was right both times**, on grounds better than mine. The (O3) argument — that assuming counts as discharging only if the test that names A5(iv)'s round-7 defect is abandoned — is the correct reading of the file's own criterion, and I had contradicted myself inside a single sentence.
2. **It exceeded the brief on `cor:ratefloor`** with an argument I could not fault.
3. **It found a defect of my class that I missed** — `lem:sandwich` short of A1 and three B1 clauses.
4. **It relocated my `def:onestep` MINOR one clause upstream and was right to.** My site was one clause downstream of the defect.
5. **It fixed m3 on the proof side rather than softening the annotation** — the harder and better repair, and it makes the proposed `rootn-prelim-threshold.yaml` test the thing the step actually rests on.
6. **`eq:rndeltamargin` and `eq:foldrates` are the right response to both MAJORs** — an object asserted in prose across several sites gets a label. Structural, not a patch.

## 9. Priority order, if a third round is run

1. **[N1]** Restate `notation_glossary.md:565` at `eq:deltalog`'s object.
2. **[N2a]** Either state a `lem:prelimtheta` clause (i′) at $\delta_n\to0$ without A5(ii)'s second half, or add one sentence to `cor:ratefloor`'s proof supplying `lem:sandwich`(i′)'s fourth hypothesis from `eq:foldrates` display 1.
3. **[N2b]** Replace the `lem:momzero`(i) citation at `proofs.tex:4927` with the one-line tower argument from A1's second clause.
4. **[N3, N4]** Add `def:crossfit`(c) to (O3)'s home list; disambiguate the stage index at `proofs.tex:5279`.

---

## Orchestrator verification appended 2026-07-30

**N1 and N2(b) confirmed by direct inspection.** `notation_glossary.md:565` writes the log-free form as the definition while the same file states the amended one sixty lines later; `proofs.tex:4927` carries the `lem:momzero`(i) citation as described.

**N1 exposed a structural blind spot in CHECK 6, now fixed.** The checker's `reg_targets` covered `results.tex`, `proofs.tex`, `assumptions.tex` and the renderings — **not `notation_glossary.md`** — so the blocking row added on the critic's own round-1 recommendation could not have caught a stale claim in the file where symbols are *defined*. Scope is now **per row type**, and the distinction is the point: `ONLY_IN` asks whether a symbol is **used** outside its licensed results, and a glossary row *names* a symbol in order to describe it, which is not a use — measured before deciding, adding the glossary produced 8 hits, all false positives, every one a glossary row doing its job. `OCCURS_NOWHERE` asks whether any live text asserts a falsehood, and there the glossary is the highest-value file to read. `OCCURS_NOWHERE` rows now scan it; `ONLY_IN` rows do not.

**Limit recorded rather than papered over:** the existing row's pattern targets *present-tense attribution to A5(ii)* and would still not match N1's shape, which is a bare equation inside a table cell. Fixing the scope does not by itself catch this instance; the round-3 fix does that.
