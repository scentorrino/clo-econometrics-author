<!-- Persisted by the orchestrator 2026-07-30 on receipt. Full re-sweep post-Part-I.
     Previous full sweep: notation-table_round8.md. Orchestrator verification at foot. -->

# Notation sweep — `panel-npiv-discrete`, post-Part-I

**Score: 31/100.** Two collisions gate-blocking; the rest is declaration work.

## Collisions (−15 each)

**COL-1. $q$ — the conditional multiplier vs. a partition index.** Binding referent: $q(x_1,x_2)=E[\widetilde W\partial_u\ell_\star\mid X_1,X_2]$, glossary §3, memo §3.5, C7/C18, live **bare** at ten `results.tex` sites and decisively at **`results.tex:4107`, inside `lem:momzero`(iv.3), in Part I.** New referent: the **partition index** at `results.tex:4647`, `:4649` (bare, in a **statement**) and eight `proofs.tex` sites. They co-occur inside Part I, 540 lines apart in one file, so C30's "never co-occur" defence is unavailable. **The file already knew:** `proofs.tex:230` declines to name the $o_P$ companion's exponent because *"q, c, b, m and p are all bound elsewhere in this project."* C73 swept `\mathsf F`, `\mathsf P` and $\mathcal I$; it never swept the partition **index letter**.

**COL-2. $\psi$ — the RESERVED moment function vs. a cumulant generating function.** `proofs.tex:3766`, `lem:bdiff` Step 1: `Put $\psi(\lambda):=\log Ee^{\lambda V}$`, used at three further lines. $\psi$ is **RESERVED** ("may not be reused for anything else, at any subscript"), and **C26 exists for exactly this object** — it moved `lem:bierenscore`'s Laplace transform off $\psi$ on the ground that the transform was "the genuine breach." The same species is back on the same letter, one Part later. Aggravating: the glossary's §8.0 hazard row reads this proof for its local $V$ and did not see the $\psi$ two lines above.

## Undeclared conventions and locals (−5 each)

**U-1. The prime convention is binding in fact and declared in no binding file — and its only other live instance reads the opposite way.** The rule lives only in `lem:prelimtheta`'s statement prose. Exactly two primed clause labels exist: `lem:sandwich`(i′) ✓ conforms; **A5(vi′) does not** — a *different and stronger* conclusion, which under the new rule should be numbered. Both are cited inside one theorem. Step-level primes drift the same way: **`proofs.tex:5021` Step 4′ is a different conclusion, inside the very lemma whose statement declares the rule.**

**U-2. The nonnegative parenthesised superscript rule is false as stated.** The glossary says nonnegative = **stage**. It carries at least **five** live readings: stage; **order** ($\Lambda^{(0)},\Lambda^{(1)}$, C40); **component tag** ($\hat\delta_n^{(T)},\hat\delta_n^{(\varrho)}$, 21 sites); **enumeration** ($\Psi^{(1)}_k$–$\Psi^{(3)}_k$); **the $\theta$-step preliminary** $\hat\theta^{(0)}$, 37 sites, not a `def:lfstep` stage; and a parameter pair. *"This is the third collision you asked me to sweep for, and it is not another $\bar k$ beside a fold subscript"* — every `\bar k` site was checked and the two repairs hold. **What did not hold is the rule.**

**U-3. The $\Psi$ family gap is NOT closed.** §1.7 carries $\Psi$ at two rows; **neither mentions $\Psi^{(j)}_k$ or $\Psi^\theta_n$**. The declared device separates the argument-carrying member and not those two, both argument-free. A second unflagged hazard: **$\Psi_{jk}$ against $\Psi^{(j)}_k$ — the same two letters, separated only by which one sits up.** Five members, one row covering two.

**U-4. `lem:bdiff` carries six undeclared locals, three on rule-governed letters** (excluding $\psi$): integer-subscripted $\zeta_k$ against C28's literal text; **italic $M_k$, retired by C7 in the binding voice and re-retired at C32**; $\Delta_k$ against the period-difference operator; $\mathcal H_k$ against §1.6's $\mathcal H_b$; $Q_\lambda$ as a third italic-$Q$ reading in the slot C38 declined; bare italic $F$.

**U-5. `prp:medianpart`'s proof introduces $Z_n$, $Z_{n,j}$, $\varepsilon_{q,n}$ with no glossary row** — italic capital $Z$ is the exogenous control, same font, same case.

## Typography (−2 each)

**T-1.** The (P8)/(P9) header states its objects in ASCII italic (`a_n`, `M_n`, `V_n`) while its consumers write them sans-serif — and `a_n` is **the slot C62 declined by name**, `M` is retired. Comments are stripped by design, so no guard can reach it: the C44 limit recurring.

**T-2.** Glossary §5's $\Psi_{jk}$ row drops the arguments the separator depends on — **the rule is broken in the file that declares it.**

## Binding-claim and register (−5 each)

**B-1. Three sweep-shaped claims in the binding file are false or unreproducible.** §1.5h's calligraphic census says "$\mathcal O,\mathcal Y,\mathcal Z$ are the only free ones" — **false at $\mathcal Z$**: 17 occurrences, $\mathcal Z_0$ **claimed at C34** with its own §5 row. C74's rationale that blackboard is used only for $\IR,\mathbb N$ is **false** — $\mathbb Q_0$ and $\mathbb C$ are live and named in use by the glossary's own rows. C77's three "claimed" citations **do not resolve**. Diagnosis: §1.5h asserts every row names its grep pattern, and **C76 names none.**

**B-2. The header's two register records still disagree — a different pair from the one round 12 fixed.** The inventory paragraph is correct (C1–C79; independently verified contiguous, no gaps, no duplicates). **The enumeration sentence totals 73** — the six unlisted are §1.3's C12–C17.

## Carried findings — confirmed and sharpened

**N5 — CONFIRMED, and now one of *three* live sites.** Sixth and seventh found in `theory_memo.md` (`:1366`, `:3386`), both attributing to A5(ii) in the present tense, neither carrying the file's own staleness marker. **Two structural reasons the CHECK 6 row could not see them, one a defect in the row itself:** `theory_memo.md` was not in scope; and **the regex is direction-sensitive** — `:3386` puts the glyph first and the verb last and matched neither alternative, in any file.

**N6 — CONFIRMED, and it is *two* rows.** The incomplete "superscript = linearisation stage" survives at C58's slot table **and at §1.7, the documented-near-collisions index** — the table a reader consults when two objects share a glyph.

## What checks out
Register rows C1–C79 contiguous, verified independently. The $E$/$\mathbb E_n$ separation holds with no bare $\mathbb E$ and no $\mathbb P$. **Both repaired stage-vs-fold sites hold**, each naming "stage" in words. Dispatch 13's two §1.6 locals are properly declared. All six new labelled displays resolve and are cited. C79's $\epsilon^L_n$/$\epsilon_n$ separation is clean.

## Priority for the theorist
1. **COL-2** — a RESERVED-symbol breach and the exact object C26 was written to remove.
2. **COL-1** — a statement-level use of a letter the file itself calls bound.
3. **B-1** — the census is what later dispatches will trust instead of re-sweeping. C71's lesson, second occurrence.
4. **U-2 / N6** — one amendment covering all five superscript readings.

---

## Orchestrator verification appended 2026-07-30

**COL-2 confirmed** at `proofs.tex:3766`. **COL-1 confirmed**: $\hat\theta_q$ and "for every $q,q'$" in a *statement* at `results.tex:4647`/`:4649` against bare $q$ as the conditional multiplier at `results.tex:4107` — and `proofs.tex:230` does say *"q, c, b, m and p are all bound elsewhere in this project."*

**N5's checker findings confirmed, and both defects were in the row I wrote. Both fixed:**
1. **Scope** — `theory_memo.md` added to `reg_targets_occurs`.
2. **Direction-sensitivity** — a third ordering added (glyph → A5(ii) → verb), which `:3386` needs.
3. **And extending scope to prose exposed a third defect I introduced in the act of fixing the first two:** the `VERBATIM_OPEN`/`CLOSE` bracketing is a **LaTeX-source convention**, and **one memo line containing the phrase "verbatim in their notation" opened a block that never closed, silencing every finding after it** — including `:3386`, a thousand lines further down. Bracketing is now applied only to `.tex`.
The row now fires on exactly the two real stale sites and not on the retraction narration at `:640`, which was marked `RETIRED-MENTION`. Build re-verified clean: exit 0, 273 pages.
