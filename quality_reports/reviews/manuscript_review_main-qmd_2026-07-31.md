# Manuscript Review — `panel-npiv-discrete`

**Date:** 2026-07-31
**Target:** `paper/qmd/main.qmd` (title block, abstract, §1, §§2–4)
**Paper type:** Theoretical econometrics, `PROJECT_TYPE: mixed`, single-authored
**Target journal:** Oxford Bulletin of Economics and Statistics
**Severity:** HIGH (Execution phase)
**Score: 48/100** — below the 80 commit gate.

> **Persistence note.** The writer-critic has no Write tool (`agents.md` §2: critics never create). This is the orchestrator's transcription. Sections marked **[ORCHESTRATOR VERIFICATION]** are checks run against the corpus after the critic reported.

---

## Verdicts

| Category | Verdict |
|---|---|
| 1. Structure and Flow | **MAJOR ISSUES** |
| 2. Claims and Evidence | **GAPS** |
| 3. Fidelity to the theory corpus | **ISSUES** |
| 4. Writing Quality | **CLEAN** |
| 5. LaTeX and Format | **COMPLIANT (minor)** |
| 6. Compilation | **NOT SCORED** (critic has no Bash; state supplied by orchestrator) |
| 7. Voice Fidelity | **DRIFT** |
| 8. Notation Consistency | **INCONSISTENCIES** |

## Deduction table

| # | Issue | Rule | Ded |
|---|---|---|---|
| D1 | §§2–3 argue entirely from objects not printed until §4 | INV-7 at document scale | −8 |
| D2 | ~80 of ~115 printed statements never referenced in prose | orphan statements | −3 |
| D3 | §1 is 2,245 w / 39 ¶; concession block outweighs contribution block | house standard | −2 |
| D4 | §2's `\input` comment describes contents not in the file it inputs | — | −1 |
| D5 | §1 and abstract wholly outside the claim-source map | **INV-22** | −6 |
| D6 | "semiparametric efficiency" keyword not delivered anywhere | INV-6, claims/evidence | −3 |
| D7 | Abstract reports a Monte Carlo the paper does not contain | claims/evidence | −1 |
| D8 | Lepskii optimality claim uncited; key absent from this project's bib | missing citation | −2 |
| D9 | Poirier absent at the §2 site `positioning.md` §4(b) names | missing citation | −1 |
| D10 | Restriction (B) misstated against `def:admissible` printed in the same section | **INV-11** | −5 |
| D11 | §1's counting argument for the mean restriction's failure does not carry | — | −3 |
| D12 | $\mu=4/7$ not derivable from the mechanism §1 states for it | **INV-11** | −3 |
| D13 | Unhedged characterisation of a named competitor's framework | style guide | −2 |
| D14 | Title block: no affiliation, no email, no `\thanks{}` | working-paper-format | −2 |
| D16 | 15 paragraphs open by announcing a cardinal count | Anti-pattern #8 | −5 |
| D17 | Four textual self-citations across three sentences | Citation Conventions | −2 |
| D18 | No novelty hedge anywhere | Hedging pattern | −1 |
| D19 | $\ell^\Pi,\nu,\pi,\mathsf R_\ast,\sigma_q$ used in prose before definition | **INV-7** | −2 |
| | | **Final** | **48/100** |

---

## MUST CHANGE

### D1 — the document cannot be read in order (the headline)

`main.qmd` has exactly two `\input` blocks: `assumptions.tex` at §2 (L307) and `results.tex` at §4 (L631). **§3 prints nothing.**

Every object §2's prose reasons about lives in `results.tex`: `def:admissible` (L153), `lem:shiftinv` (L271), `prp:nophifree` (L980), `prp:kerchar` (L1086), `cor:a1cprim` (L1100), plus `lem:nusigma`, `lem:momzero`, `lem:bierens`, `prp:compact`, `cor:udep`, `lem:density`, `prp:orthog`, `rem:swintercept`, `lem:bierenscore`. **None is in `assumptions.tex`.** §3 is worse: it defines the estimator in prose while `def:lfstep`, `def:crossfit`, `eq:psidef`, `eq:onestep`, `eq:lfsched` and `prp:phirate` are fifteen pages away.

Rendered, the paper reads: 24 assumptions → eleven paragraphs about theorems the reader has not seen → twelve paragraphs about an estimator whose definition has not been printed → 87 numbered results → twenty paragraphs.

**What the OBES reader concretely fails to understand.** §2 L322 states $\theta_\dagger=(E[\Delta Z\Delta Z'])^{-1}E[\Delta Z(\Delta Y-\Delta\vdagger)]$ and attributes it to "restriction (B) of `\cref{def:admissible}`" — the reader turns to `def:admissible` and it is not there. §3 L486 writes the stage-$k$ equation "posed on the spline sieve $\mathcal S_n$ of A8 and solved by Landweber–Fridman from $v_0=0$ at the relaxation `\eqref{eq:normconst}`" — that is *the definition of the estimator this journal exists to publish*, rendered as a paragraph of pointers into a section the reader has not reached.

**Fix — placement, not rewriting.** Split `results.tex` at its own Part boundaries (the corpus already carries markers such as `% PART C. STEP 2 -- THE BIERENS EQUIVALENCE`, L346) and `\input` the pieces where the prose uses them. Parts B–D at §2; the estimator definitions at §3; only `thm:rootn`, `cor:ratefloor`, `prp:sharpquad` and the scope remarks at §4.

> **[ORCHESTRATOR NOTE]** This is the same root as the **310 undefined references** in the standalone `supplement.qmd` render and, very likely, the *"maximum number of runs (9) reached"* non-convergence. One fix closes three symptoms.

### D10 — restriction (B) is misstated against the definition printed above it

`main.qmd:312`: *"The mean-zero half, $E[\Delta U\mid\Delta Z]=0$, is restriction (B) of `\cref{def:admissible}`"*.

**[ORCHESTRATOR VERIFICATION — confirmed.]** `results.tex:153` `def:admissible` prints:

```latex
\text{(A)}\quad E\big[\widetilde W\,\varsigma(\Delta U)\;\big|\;\Delta Z\big]=0  \text{ a.s. for every bounded measurable }\varsigma,
\text{(B)}\quad E\big[\Delta Z\,\Delta U\big]=0 .
```

(B) is an **unconditional orthogonality**. $E[\Delta U\mid\Delta Z]=0$ is A1's second half (`ass:condind`, `assumptions.tex:96`) and is strictly stronger. The identification display that follows needs only the corpus's (B), so **the result is unharmed** — but the manuscript labels a printed, numbered restriction with an equation that is not it, then reuses the label at L321, L329, L344 and L567. **Fix the labelling, not the derivation.**

### D11 — §1's motivating argument does not carry

`main.qmd:91–96`: *"…one restriction per $\Delta Z$, while $\vdagger$ is a function on a continuum. The operator it generates therefore has a kernel too large for identification at any sample size."*

The "therefore" does not follow. $\Delta Z$ is nowhere assumed discrete — §2 L381 explicitly permits it continuous, and the Bierens device exists precisely so no conditional law given $\Delta Z$ is estimated. With continuous $\Delta Z$, "one restriction per $\Delta Z$" is a *continuum* of restrictions against a function on a continuum, and the count is not decisive.

**The conclusion is right; the reason is wrong.** The operative fact is that injectivity needs a completeness condition a two-valued instrument cannot supply — `cor:a1cprim`'s A1d, "instrument completeness given the residual" (`assumptions.tex:296`), which is also CFF (2025)'s own argument. No source for the counting version exists anywhere in the corpus. This is the first substantive paragraph of the paper and the one a methods referee reads hardest.

### D12 — the $4/7$ is not derivable from the reason given

`main.qmd:281–288` gives **one** change: composing with the inverse derivative operator "raises the degree of ill-posedness by one". `results.tex:2641` gives **two**: "…raises the degree of ill-posedness from $a$ to $a+1$ **and lowers the index from $s/(2a)$ to $(s-1)/(2(a+1))$**". At $(s,a)=(3,\tfrac34)$ that is $2/3.5=4/7$ — correct.

But a reader applying only the stated mechanism ($a\mapsto a+1$ in $\mu=s/(2a)$) gets $3/3.5=6/7\approx0.857$, which is **above** $5/6$ and therefore **passes** `eq:muhalf`. **The omitted half is exactly what reverses the verdict.** Compounding it: $(s,a)=(3,\tfrac34)$ appears nowhere in §1 — the reader must fetch it from a bracketed placeholder in the undrafted §5 (L807) — and $\mu=s/(2a)$ appears only later, twice, both times to say it is *not* the operative index. This is the least checkable sentence in the introduction, and it is the one declining the author's own published device.

### D5 — INV-22: §1 and the abstract are outside the claim-source map

`claim_source_map_panel-npiv-discrete.md` declares scope as *"§§2–4 only… §1, the abstract, §5 and §7 are not yet drafted and carry no entries."* **No longer true.** §1 now carries at least twelve quantitative claims. Most duplicate mapped §4 rows and need only anchors. **One does not: the $4/7$ has no counterpart in §§2–4 and therefore no row anywhere in the map** — which, given D12, is not a coincidence. It is what the map exists to catch.

The critic independently re-derived and confirms the map's arithmetic: $r>d_Z(2\mu+1)/\{2(2\mu-1)\}$ follows correctly from $\kappa\alpha>\tfrac14$; $f(\mu)$ decreasing with $f(\tfrac56)=2$; $\beta=2\kappa\alpha-\tfrac12$; $n^\ast=\exp\{2\kappa/\beta\}$; all four $n^\ast$ values check. **Update the scope; do not rebuild it.**

### D6 — "semiparametric efficiency": a keyword problem, and it should stay one

`rem:rootnscope`(4) (`results.tex:5168`): *"It says nothing about efficiency… Those are `prp:effbound`, `prp:plugin` and `cor:trend`, Step 8."* `theory_memo.md:1523`: **"No Step 8."** `prp:effbound` exists nowhere in `results.tex`. Meanwhile §4 L664 states the sandwich is the infeasible plug-in's variance **plus a positive semidefinite term**, and L670 that debiasing "buys not variance but the removal of the first-order bias."

**As a keyword it must go.** It is the only one of four the paper does not deliver, and the one an efficiency-literate referee searches on. `positioning.md:146` records Poirier (2017) as **the** efficiency-bound paper under independence restrictions — so a referee arriving via that keyword reads §1's Poirier paragraph, sees the bound named as Poirier's theorem, and finds the paper computes no bound and compares to none. Replace with something delivered: *Neyman orthogonality*, *cross-fitting*, or *ill-posed inverse problems*.

**As a result it should not be added.** OBES asks "who runs this, on what data, tomorrow?", not "is it efficient?". Adding `prp:effbound` is a *Journal of Econometrics* move costing a Step-8 development this paper does not need. The right response is **one sentence** in the corpus's own limitation grammar, placed where the sandwich is (§4, after L667): the estimator is not shown to attain the bound of Poirier (2017), and computing that bound when the nuisance solves an ill-posed nonlinear equation is left to future research.

### D8, D9 — two named-result claims with no citation

**Lepskii.** §3 L526: *"Lepskii-type balancing over the regularisation index is purely data-driven and attains the optimal rate up to a logarithmic factor."* No citation.

> **[ORCHESTRATOR VERIFICATION — confirmed.]** `lepskii` appears **0 times** in `quality_reports/literature/panel-npiv-discrete/references.bib` and **1 time** in the sibling `volatility-loc-scale/references.bib`. The key exists in the repo but in a different project's bibliography; it needs copying by the N-21 route.

This is load-bearing: it is the sentence that defuses the Bakushinskii veto — and **the veto *is* cited** (`bakushinskii1984`, L522). The paper cites the authority *against* data-driven selection and merely asserts the authority *for* it. For OBES this is the tuning-rule paragraph, and the profile's standing question is *"What do I set the tuning parameter to?"*

**Poirier at §2.** `positioning.md` §4(b) (L186) directs: Poirier has a section showing a conditional *moment* restriction in place of conditional *independence* loses identification — *"Cross-reference it at Lemma L1 / Remark R1 — **but state the direction difference**."* The §2 paragraph at L329–332 is that site and carries no citation. The direction difference is genuinely interesting: in Poirier conditional independence *buys* identification; here it is uninformative about $\theta_\dagger$ and supplies the debiasing channel instead. One sentence.

---

## §1 length — adjudicated

**The four candidates the writer named are not where the problem is.** They total ~295 w; cutting all four leaves ~1,950, still 30% over.

| Candidate | Verdict |
|---|---|
| Two-step preview (~55 w, L84–89) | **KEEP in §1; trim §3's opener instead.** The most OBES-relevant paragraph in the introduction, and it carries what §3's copy does not: *"The propensity score $\varrho(\Delta Z)=E[W\mid\Delta Z]$ is the only conditional expectation the procedure estimates nonparametrically."* That is the dimension-burden fact a practitioner needs before deciding whether to read on. §3 L476 is the redundant copy. Net saving **0**. |
| Four ingredients (~77 w, L251–257) | **CUT the enumeration, keep the count.** §3 L604–614 already carries the full inventory, and "state the limitation where the result is" puts it there. Saving **~60 w**. |
| $n^\ast$ numbers (~49 w, L266–270) | **CUT the closed forms, REORDER, keep both numbers.** $e^{400/3}$ and $e^{176/25}$ are noise; $10^{58}$ and $1{,}140$ are content, and the *contrast* is the content. As written $10^{58}$ arrives first and reads as self-defeating. Lead with $1{,}140$. Saving **~30 w**, and the paragraph gets better rather than merely shorter. **Highest-value single edit in §1.** |
| Rate condition in primitives (~114 w, L234–247) | **CUT the first paragraph, KEEP the second.** L244–247 contains the best sentence in the introduction for this journal — *"a scalar conditioning variable and five derivatives clear it throughout"* answers "does this work on my data?". L234–242 is the derivation, which belongs in §4 where `eq:frontier` is stated. Saving **~65 w**. |

**Where the other ~600 words actually are.** §1 runs **39 paragraphs**; Paper A's introduction is 14 / 991 words, Paper B's ~20 / ~1,300.

- **Literature, ¶15–24 (L134–198), ~490 w.** Four competitors each get the full credit-engage-distinguish treatment: CFF (2¶), Fève–Florens (2¶), the linear-operator √n literature (2¶), Chen–Pouzo (1¶), Poirier (3¶). The style guide's move 6 is *"The closest paper, engaged directly and at length"* — **singular**. Paper A engages exactly one at length and handles the rest in parenthetical lists closed with `among others`. **Pick one (Poirier, on §1.4's open-extension quote), demote the other three to two sentences each. Saving ~250 w — and the positioning gets sharper, because one engaged competitor reads as confidence and four reads as anxiety.**
- **Concessions, ¶32–38 (L249–291), ~370 w in seven paragraphs.** Paper A's concession block is **one** paragraph. The contribution block, ¶25–29, is five paragraphs / ~310 words. **The paper's list of caveats is longer than its statement of what it contributes**, and an OBES reader reaching L291 has just read 370 consecutive words about what the paper does not do. Cut to three paragraphs (~180 w); move the pointwise-in-$P$ limitation, the global-identification discussion and the derivative parameterisation to §§2 and 4, where each already has a home. **Saving ~190 w.**

**Total ~595 w → §1 lands at ~1,650.** Slightly over, and acceptable: the paper has unusual positioning to do. **What is not acceptable is the current ordering, where concessions outnumber contributions.**

---

## Voice fidelity — what the measurements cannot see

The register statistics are all in-corpus and taken as given. They cannot capture one tic repeated file-wide.

**Fifteen paragraphs open by announcing a cardinal count** (L102, 156, 194, 251, 259, 334, 353, 467, 536, 616, 659, 702, 720, 765, 793), plus four embedded (L200, 249, 311, 522) — ~18 instances. The style guide names this directly, Anti-pattern #8: *"Rule-of-three list scaffolding… **'Three things follow' is not corpus phrasing.**"* **L353 is verbatim "Three things follow."** Some is inherited from `rem:R1`, but a remark inside a 312-page corpus can afford a house style an introduction and three prose sections cannot repeat eighteen times. **Convert at least ten to bare topic-noun openers.**

**Self-citations, adjudicated:**

- **L135 `centorrinofeveflorens2019` — warranted, recast the opener.** The companion cannot be engaged for two paragraphs unnamed. But nothing signals it is the author's own work: a referee who does not recognise the name reads third-party engagement; one who does reads unflagged self-promotion. The corpus's own device is available — Paper A opens *"In a previous paper, Dunker et al. (2014) have considered…"*.
- **L276 `beyhum2024` — not warranted.** Sentence-initial and doing contrastive work: the author names himself in order to say the conditions are "difficult to check on data." Recast parenthetically.
- **L282 `florens2012` + `centorrinofeveflorens2019` — the worst.** Two foregrounded self-citations in one sentence, in a paragraph concluding that the device is declined. Both parenthetical.

**No novelty hedge anywhere.** The style guide reserves hedges for exactly two contexts, one being novelty claims, with the device *"new to the best of our knowledge."* `positioning.md`'s novelty verdict rests on absence-of-evidence sweeps, which is what the hedge exists for. Also L175–182 characterises what instantiating Chen & Pouzo's framework "would call for" unhedged; the corpus's device is *"to the best of our understanding."*

---

## Would improve

- **§3 does not open as the corpus opens an estimation section.** Paper A opens *"Recall that"* and restates the model. For OBES this is the section a practitioner reads first.
- **Assumption interpretation.** OBES's methods referee expects every high-level condition glossed in terms an applied reader recognises. 24 assumptions printed; ~10 interpreted. **A2, A5(iv), A8, C5′ and H1 get no plain-language gloss anywhere.**
- `\eqref{eq:muhalf}` (L288) is cited in §1 but never stated there.
- `\mathcal K` → "compact part" (L728) is defensible, but $\sigma_q$ is undefined in prose, and this is the paper's answer to "can the frontier be relaxed?"
- **Title block (D14):** no affiliation, no email, no `\thanks{}`.
- **Roadmap vs. structure comment:** header lists seven sections plus appendix; the rendered document has six.

## Not deducted — noted

- `\addbibresource{../../quality\_reports/…}` underscore escaping (already on record).
- Two `\printbibliography` reach the document by different routes. **Ownership is the template, and nobody currently owns it.**
- Abstract will not carry `\noindent`/`\singlespacing`; no `\thispagestyle{empty}` or page-counter reset under pandoc's article template.
- §§5–7 absence and forward references into them.

## What is genuinely good

The AI-tell sweep is **clean — zero hits across the 24-pattern check**. The author's 22-word avoid list returns **zero hits**. Zero em dashes. The opening sentence is a flat uncited declarative about the standard object; the model is displayed in ¶2; L108 lands the decision in one sentence exactly as the corpus does; L291 hands off to future research in corpus phrasing; the roadmap is the corpus's shape to the clause. **Citation precision is exemplary** — every load-bearing cite carries the theorem, proposition or section number (`\citet[Thm.~3.1]{stinchcombewhite1998}`, `\citet[Prop.~2.2]{feve2014}`, `\citet[\S5]{poirier2017}`, `\citet[Thm.~1]{bierens1990}`). The limitation grammar is reproduced faithfully throughout §§3–4. **This is the prose; the problems are structural, factual and bibliographic.**

## Claim-source map status

- Map exists: **YES**. §§2–4: **complete** (58 anchors, machine-verified unique, MD5-checksummed sources). §1 + abstract: **0 of ~12**. Broken links: **none**. Numbers independently verified against the corpus: $\beta=0.012$, $n^\ast=e^{400/3}$, $e^{176/25}$, $e^{352/61}$, $e^{400/87}$, and the frontier-in-primitives algebra — **all correct**.

## Escalation status

**None.** Every finding is a bounded fix: a placement change, a labelling correction, two citations, a keyword deletion, a map scope update, and a prose pass on paragraph openers. **The theorem is not in question at any point in this review.**
