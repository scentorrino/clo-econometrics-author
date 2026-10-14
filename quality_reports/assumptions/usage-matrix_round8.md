# Assumption Usage Matrix — `panel-npiv-discrete`, round-8 re-sweep

**Critic:** assumption-auditor (read-only; persisted by the orchestrator)
**Score: 7 / 100** (raw −93)
**Files read:** `quality_reports/theory/panel-npiv-discrete/{assumptions.tex, results.tex, proofs.tex, theory_memo.md, notation_glossary.md}`. No file edited.

> **Filename note.** The dispatch-2 report survives at `usage-matrix.md`. This is the round-8 re-sweep.

**Headline.** All four declared changes verified as made. But the **round-7 narrowing of A1b(i)** — made in the assumption block, in the same change log as the N1 fix — was **not propagated to the proof sites that cite the half it narrowed away**. That is the N1 defect species, in the same round, on the adjacent tag.

**Orchestrator spot-checks (four of four confirmed):** `lem:levels` carries A1b(i) in its hypothesis line (`results.tex:721`) with **zero** A1b citations in its proof body (`proofs.tex:807–854`); `lem:nusigma`(ii) at `proofs.tex:760` writes "If moreover $h\in\mathcal V$ then $\int h\,d\pi=0$ by A1b(i)" with $h$ generic; `proofs.tex:1723–1725` attributes the $O_P(\delta_nr_n)$ reading to A5(iv); A5(iv) at `assumptions.tex:991–993` does assert the equality as printed.

---

## Section 0 — The Mode column: answer is yes, and it is what caught the headline

The dispatch asked whether the matrix should distinguish a tag consumed **for a bound** from one consumed **for well-posedness**. It should. The reason is not taxonomic:

A1b(i) reads $\vdagger\in\mathcal V$, i.e. $\int\vdagger\,d\pi=0$. `def:spaces` says $\mathcal V:=\{\varphi:\int\varphi\,d\pi=0\}$, so for a *generic* $h\in\mathcal V$ the same equation holds **by definition**. The two are **typographically identical and semantically disjoint** — and A1b(i)'s own statement says so:

> *(The corresponding statement for a generic $\varphi\in\mathcal V$ is `def:spaces` and not an assumption; only membership of the truth is content.)*

A "strength of use" column cannot separate them — both read "Full". A **Mode** column forces the auditor to name *whose* membership is asserted, which is the check that separates a genuine consumer (`lem:secondord`, whose path is $\vdagger+\tau_1h$) from an idle one (`lem:nusigma`(ii), whose $h$ is generic).

**It also prevented a false positive:** with the column, `cor:udep` — which I was about to charge — clears, because its clause (a) is "first-order insensitive **at $\vdagger$**", a genuine well-posedness use of the base point.

Modes: **Bound · Well-posed · Existence · Structure · Design · Rate.**

---

## Section 1 — Usage matrix (abridged to the rows that moved; full table in the agent record)

| Tag | Used in | Mode | Strength |
|---|---|---|---|
| **A1** | `lem:shiftinv` (final clause), `lem:nusigma`(v), `prp:kerchar`(ii), `cor:udep` St.1, `lem:solset`, **`prp:orthog`(ii) only**, (P4c) | Structure | **Over-listed at `prp:orthog`** — Finding 3 |
| **A1b(i)** | **Genuine:** `lem:secondord`, `prp:orthog`(i), `cor:udep`, `lem:solset` (transitive) | **Well-posed** | **Idle at `lem:nusigma`(ii), `lem:levels`, `prp:nophifree`, `cor:a1cprim`** — Finding 1 |
| **A2′(i.a)–(i.b)** | `cor:elldiff`; **and by textual substitution `def:weight`(a)** → `lem:solset`(ii), `prp:orthog`(i), `eq:PsiL` | Bound | **Dual status under one tag** — Finding 4 |
| **A2′(ii)** | *(Step 8, tier T3)* | Bound | Forward-referenced; **cited-by-inclusion at four Part F results** — Finding 8 |
| **A2′(iii)** | `def:weight`, `rem:anchor`, `lem:secondord` St.1, `prp:orthog`(iii), **`rem:dirmember` (new)** | Bound | Full — **new consumer verified** |
| **A4(ii),(iii)** | A5(i),(iii); C5′(iii); `lem:secondord` instantiation | Rate | **Instantiation reads a sup-norm bound at an $L^2$ rate** — Finding 5 |
| **N1** | `lem:density`(iii) [property]; `cor:udep` [hypothesis]; `prp:orthog`(iii) [**characterised**, not assumed] | Structure | **Five-site resolution VERIFIED — the model the A2′(i) fix should follow** |
| **A5(iv)** | `lem:balance`(ii); `lem:secondord`(iv) | Rate | **First equality presupposes an unstated construction condition** — Finding 2 |
| **H1** | **`rem:adjointreconcile`(iii)** [infinite rank]; budget table | Structure | Full — **memo table stale**, Finding 9 |
| **A8** | lower end `lem:balance`(iii) only; upper end both routes | Design | **Route-conditional pricing VERIFIED** |

---

## Section 2 — Findings

### Finding 1 (−30, three independent sources). A1b(i) charged to four results that consume `def:spaces`, not A1b(i)

The round-7 change log records: *"A1b(i) reduced to its content, $\varphi_\dagger\in\mathcal V$; the generic-$\varphi$ half is `def:spaces` and not an assumption."* **Four results cite exactly the narrowed-away half:**

- **`proofs.tex:760`** (`lem:nusigma`(ii)): "If moreover $h\in\mathcal V$ then $\int h\,d\pi=0$ **by A1b(i)**." $h$ is generic — that is `def:spaces`. Statement line `results.tex:689` carries "under A1b(i)–(ii)"; only (ii) is consumed.
- **`results.tex:721`** (`lem:levels`): A1b(i) in the hypothesis line, **appears nowhere in the proof** (`proofs.tex:807–854` cites A0, C1(ii), Cauchy–Schwarz, Lebesgue differentiation and nothing else). Clauses (i)–(iv) concern generic $h,h',\nu_g$; $\vdagger$ does not occur.
- **`proofs.tex:1010`** (`prp:nophifree`): roadmap says the proof "uses the normalisation A1b(i) to upgrade 'orthogonal to $\mathcal V$' to 'zero'." Step 3 actually cites `def:spaces` and `lem:nusigma`(iv). $\vdagger$ appears nowhere in the proposition.
- **`results.tex:1004`** (`cor:a1cprim`): inherits via `lem:nusigma`(ii). Its conclusion is about generic $h\in\mathcal V$.

**Same species the block struck N1 for at three results this same round, A0 for at `lem:adjfubini`, and A4(i) for at three setup propositions.** Charged −10 per independent source; `cor:a1cprim` resolves automatically.

### Finding 2 (−15). A5(iv)'s first equality presupposes $\partial_u\hat L=\hat\ell$ — a forward obligation has already migrated into the block, unstated

`assumptions.tex:991–993` prints $\|\partial_u(\hat L-L_\star)\|_{L^2(P)}=\|\hat\ell-\ell_\star\|_{L^2(P)}=O_P(\epsilon_n)$.

**The first equality is an assertion, not notation.** It holds only if $\hat L$ is $u$-differentiable everywhere with $\partial_u\hat L=\hat\ell$ — i.e. only if $\hat L=L^{\hat b}_{\hat\ell}$ per `def:weight`(b). **That is precisely the obligation `rem:dirmember` records as owed and undischarged.**

Nothing declares the relation: the glossary has rows for $L$, $L^b_\ell$, $\ell$, $\ell^\Pi_\dagger$, $\ell^\Pi_\star$, $\ell_\dagger$, $\ell_\star$, $D$, $\hat T$, $\hat m$, $\hat\delta_n$, $\hat\nu_g$ — and **no row for $\hat L$, none for $\hat\ell$**. The $\epsilon_n$ row repeats the identity without deriving it. And **`lem:balance` introduces $\hat\ell$ independently** ("$\sigma(\mathcal I_a)$-measurable with $\hat\ell\in L^2$ a.s.") with **no mention of $\hat L$**, so there $\hat\ell$ is a free estimator, not a derivative.

The generic glossary row "$\ell\mid\partial_uL$" does not close this — it is a convention for the undecorated pair, and the substantive content (that $\hat L$ is differentiable in $u$ at every point) is exactly what `rem:dirmember` says must be verified.

### Finding 3 (−10). `prp:orthog` carries A1 globally; only part (ii) consumes it

`results.tex:1371` says "Suppose A1, A1b(i), A1b(iv), B1(i), (ii), (iv), C1(ii) and C2′(i) hold." Part (i)'s proof uses `cor:elldiff`, `def:weight`, A1b(iv), `lem:nusigma`(i), (P5), C1(ii), `prp:nophifree` Steps 2–3, `lem:adjoint`(iii) — **no A1**. Part (iii)'s proof uses A4(i), A2′(iii), `cor:elldiff`, A1b(iv), tower — **no A1**. Only (ii) invokes it and says so. **The memo's table gets this right; the printed statement does not.** The block already performed this split at `lem:shiftinv`, with the reason printed. `lem:balance` inherits the surplus.

### Finding 4 (−10). A2′(i) carries two statuses under one tag; the property/construction split is NOT applied consistently with N1. **THIS GATES STEP 4**

`def:weight`(a) defines *admissible representer* by re-using **the text of A2′(i.a)–(i.b) with $\ell^\Pi$ in place of $\ell^\Pi_\star$**. So A2′(i) names two objects:
- a **maintained assertion** about the selected solution (`cor:elldiff`, `lem:solset`, `lem:secondord`, `prp:orthog`(ii)–(iii), `lem:balance`);
- a **property predicate** over generic representers (`def:weight`(a), hence `lem:solset`(ii), `prp:orthog`(i), `eq:PsiL`).

**N1 got two things this defect does not:** an explicit block sentence ("N1 is a property that a weight may or may not have; it is not maintained, and a result that needs it says so") **and a separate tag** when applied to a different object (N1′), "so that the tag N1 names exactly one object." **A2′(i) got neither.**

**Issue 3.4 is wider than reported — four sites, not two:**

| Site | Text |
|---|---|
| `results.tex:1109` | `def:weight`(a): "Under B1(i), (ii), (iv.a), `cor:elldiff` then applies to $\ell$" |
| `results.tex:1384` | `eq:PsiL`: "$\|\ell\|_\infty<\infty$ by `cor:elldiff`" |
| `proofs.tex:1368` | `lem:solset`(ii): "which is `cor:elldiff` under A2′(i.a)–(i.b)" |
| `proofs.tex:1743` | `prp:orthog`(i): "`cor:elldiff`, which under B1(i), (ii), (iv.a) and the admissibility clauses gives…" |

Nothing is unsupported — each site restates the bridge — but **the corollary's own hypothesis line is what a Step-4 author reads, and L-21's target is A2′(i.a)–(i.b) *on $\ell^\Pi_\star$*.** If the tag has silently become a predicate over generic representers, **L-21 does not know which object it is discharging.**

### Finding 5 (−10). `lem:secondord`(iv)'s $\mathsf r$-bound: MAJOR 2.1 reproduced one line away, in the other direction

`results.tex:1302` and `proofs.tex:1716` print $\|\partial^2_{\tau_1\tau_3}\Psi(0)\|\le2\bar c_\pi^{1/2}\|\mathsf r\|_\infty\|\ell_\star\|_\infty\|h\|$ — a **sup**-norm on $\mathsf r$. `proofs.tex:1723–1725` then reads it at the estimated direction as $O_P(\delta_nr_n)$ "**under A5(ii) and A5(iv)**".

Two problems: **(a)** A5(iv) prices $\epsilon_n$, not $r_n$ — the tag pricing $r_n$ is A4(iii) via A5(i). **(b)** A4(iii) prices $\|\hat\varrho-\varrho\|_{L^2}=O_P(r_n)$, an **$L^2$** rate; **nothing prices $\|\hat\varrho-\varrho\|_\infty$**.

**The round fixed exactly this defect for the $D$-direction (finding 2.1, repaired by `eq:prodbound`'s first inequality) and left the identical defect standing for the $\mathsf r$-direction in the adjacent display.** Cheap repair: Cauchy–Schwarz gives $|E[\mathsf r\,\ell_\star\Delta h]|\le\|\ell_\star\|_\infty\|\mathsf r\|_{L^2(P)}\|\Delta h\|_{L^2(P)}$, landing in the norm A4(iii) prices.

### Finding 6 (−5). `rem:dirmember`'s provenance sentence wrong in both directions (Issue 2.2 confirmed)
**Too broad:** `lem:secondord`'s hypotheses include "let $(D,\mathsf r)$ be an admissible direction pair" — the membership `rem:dirmember` exists to establish. Not circular in substance (`eq:dirmember` derives from `def:weight`(b), `cor:elldiff`, A1b(iv), `lem:nusigma`(i), A2′(iii), touching the direction-pair hypothesis nowhere). **Too narrow:** "and nothing else" omits **B1(i), (ii), (iv.a)**, consumed transitively via `cor:elldiff`. A false exhaustiveness claim, which is exactly what this lane reads.

### Finding 7 (−5). A5(iv)'s new scope declaration over-reaches, and the block's own proof contradicts it
`assumptions.tex:1052–1055`: "…so that **no bound in the block is denominated in a norm this assumption does not price**." Read literally, false: `eq:crossshift` is denominated in $\|D\|_{0,h}$ and $\|\mathsf r\|_\infty$; (iv)'s second bound in $\|\mathsf r\|_\infty$. **`proofs.tex:1719–1721` says so in italics** — "Nothing in the assumption block prices $\|D\|_{0,h}$ or $\|D\|_{1,h}$." Intended scope is the $D$-direction of clause (iv); as printed it is a block-wide claim the file refutes two hundred lines later.

### Finding 8 (−5). "A2′" cited whole at four Part F results; A2′(ii) consumed by none
`lem:solset`, `lem:secondord`, `prp:orthog`(ii)–(iii), `lem:balance` all cite A2′ as a block. Each consumes A2, A2′(i), A2′(iii); **none consumes A2′(ii)**, which the memo places at Step 8. Charged at half rate — A2′(ii) is implied by A2′(i), so this is granularity not over-strength — **but the block narrowed C1→C1(ii) and B1(iv)→B1(iv.a) this same round for precisely this reason.**

### Finding 9 (−3). Memo's live usage table stale in two places
- `theory_memo.md:239–241` lists **H1** among "assumptions with no consumer through Step 5". It has one: `rem:adjointreconcile`(iii), `results.tex:840–842` — the load-bearing step of the A2-versus-moment gap argument.
- `theory_memo.md:236` scopes A1 to `prp:orthog`(ii); `results.tex:1371` puts it in the global list. **The memo is right and the artifact is wrong** — the divergence runs the direction that makes the artifact over-strong.

### No deduction — verified clean
- **N1's five-site resolution**, verified at every site. **The model the A2′(i) fix should follow.**
- **The Part-F inheritance gap, both directions.** A1 struck from `lem:secondord`, confirmed line by line.
- **A5(iv)/A8 route-conditional pricing**; the $s>1$ line correctly charged on the balancing route only.
- **A4 note (d)'s referent** correctly moved to $E[\widetilde W^2\|L_\star\|^2]$.
- **Unused-with-forward-remark tags** — A1c, A3, A6, A7, C1(i), C2′(ii), C3, C4′, C5′, A5(i)/(iii)/(v), A2′(ii), B1(vi): **no deduction**, per the prior round's calibration. **A1d's "single declared consumer" note is exemplary practice.**

---

## Section 3 — The two questions

### Is a forward obligation an assumption in my sense?

**No — until a stated assumption cannot be written down without it. Then it already is one, and one of the three has crossed that line.**

The test: a forward obligation is a *verification* obligation, not an assumption, when **no present result's truth depends on it** — every present result states the condition as an explicit hypothesis.

| Obligation | Where the condition lives now | Verdict |
|---|---|---|
| A2′(i.b) / L-21 | A2′(i.b) is a tagged clause; L-21 is a future *derivation* of it | Correctly placed |
| N1′ | N1′ is a tagged property; `lem:secondord`(iii) states it as a hypothesis | Correctly placed |
| `rem:dirmember`'s construction constraint | `def:dirclass` membership is a hypothesis of `lem:secondord`(iii)–(iv) | Correctly placed **as a remark**; the three reasons (a)–(c) are sound and **I endorse the no-new-A5-clause decision** |

**But A5(iv) fails the test** (Finding 2): it *asserts* an equality that cannot be written without the construction constraint. **The obligation has already migrated into the block, unstated** — precisely the risk the scattering creates.

**On the scattering:** the three sit in three different *kinds* of place and are tagged inconsistently — one a clause, one a property, one untagged. **The minimal fix is not new assumptions.** It is one paragraph in the Discussion, where the block already inventories itself, listing the three with their discharge sites — so A5(iv)'s presupposition is visible from the same page that says the obligation is open.

### Which findings gate Step 4

**GATES STEP 4:**
- **Finding 4 — decisively.** L-21 must deliver A2′(i.a)–(i.b) in sup-inside form **on $\ell^\Pi_\star$**. With `def:weight`(a) having made the same text a predicate over generic representers, and `cor:elldiff`'s hypothesis line still naming $\ell^\Pi_\star$ while four sites apply it generically, **a Step-4 author cannot read off which object L-21 discharges.** Fix before writing L-21, not after.
- **Finding 9 (H1 half)** — advisory gate. `prp:sharpquad`'s ill-posedness discussion inherits `rem:adjointreconcile`(iii)'s H1 use; a hypothesis list built from the memo's stale "no consumer" row would omit it.

**CAN WAIT (but must close before Step 6/7):** Finding 2 (bites where $\hat L$ is constructed; Step 4 is a population result); Finding 5 (a Step-6/7 reading); Findings 1, 3, 6, 7, 8 (hypothesis-list hygiene, none touching the second-order form `prp:sharpquad` inherits — `lem:solset`(iii)'s inputs are all clean).

### Minimal fixes
- **A1b(i)** — strike from the four idle sites, redirect the three proof citations to `def:spaces`; or say once in the block that the tag carries the normalisation convention. Label the four genuine consumers as well-posedness uses.
- **A5(iv)** — either declare $\hat L=L^{\hat b}_{\hat\ell}$ where $\hat\ell$ is named, or replace the first equality with a definition of $\hat\ell$; not both silently.
- **`prp:orthog`** — split A1 onto part (ii), following the `lem:shiftinv` precedent already in the file.
- **A2′(i)** — give the generic-representer predicate its own tag (the N1′ treatment), or add A2′'s missing counterpart to N1's status sentence; and restate `cor:elldiff` at a generic admissible representer with $\ell^\Pi_\star$ as the specialisation.
- **`lem:secondord`(iv)** — restate the $\mathsf r$-bound in $\|\mathsf r\|_{L^2(P)}$; correct the instantiation tag from A5(iv) to A4(iii).
- **`rem:dirmember`** — narrow the import; complete or drop the "nothing else" list.
- **A5(iv)'s scope note** — scope the final clause to the $D$-direction of clause (iv).
- **A2′ citations** at four Part F results — narrow to A2, A2′(i), A2′(iii), matching the C1→C1(ii) treatment.
- **Memo table** — add `rem:adjointreconcile`(iii) to H1's row; the A1 row is already right and the artifact should follow it.
