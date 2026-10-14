# Regularity Audit — `panel-npiv-discrete`, round 5 (post-dispatch-18/19/20)

**Date:** 2026-08-01
**Score: 46/100** (was 62, 49, 42, 55). **1 CRITICAL**, 1 MAJOR, 8 MINOR.

> Orchestrator transcription; the regularity-checker is read-only. **[VERIFIED]** marks
> claims the orchestrator independently re-ran against the corpus.

**Read the drop correctly.** Both round-4 MAJORs are genuinely closed and two of six MINORs
are closed — +26 of recovered headroom. Had the new apparatus been complete this round reads
**88**. The corpus printed ~90 lines of new measurability argument in three places; new
regularity text is first-class audit surface. One of those places rests on a proviso that is
not merely unsupplied but **false at configurations the block admits**; another elides the
step that turns random *functions* into random *numbers*.

## CRITICAL — A8 is half an order short; four maintained assumptions have empty events

`def:lfstep` bullet 4: *"**provided** $\mathcal S_n\subset H^{s}$ … The proviso is A8's business
and is not verified here … nothing in this definition places the B-spline basis in $H^{s}$."*

**Is it supplied anywhere? No.** The only two places asserting anything of the kind record the
Bernstein-inequality route and **decline** it (`results.tex` `lem:pathcont` reading (c);
`assumptions.tex`). So the corpus simultaneously asserts a finite $H^s$ norm on $\mathcal S_n$
and states that nothing places $\mathcal S_n$ in $H^s$.

**A8 is half an order short.** **[VERIFIED]** `eq:jackson` is pinned to
`\citet[Thm.~6.27]{schumaker2007}` twice, described as *"the load-bearing pin"* — so Schumaker's
convention governs: order $m$ = degree $m-1$, $C^{m-2}$ at simple knots, hence $H^\sigma$ iff
$\sigma<m-\tfrac12$. So $\mathcal S_n\subset H^s\iff m>s+\tfrac12$, while A8 gives only $m>s$.

- $s$ integer or $\{s\}<\tfrac12$: holds.
- $\{s\}>\tfrac12$: fails. **Witness [VERIFIED]:** $s=1.7$ clears `eq:lxwindow`'s
  $s>\tfrac{27}{16}=1.6875$; A8 admits $m=2$ (linear, $C^0$); $m-\tfrac12=1.5<1.7$.
  **[VERIFIED]** `proofs.tex` states *"$s$ need not be an integer."*
  (Independent second witness from the assumption-auditor: $s=2.6$, $m=3$.)

**What breaks: four printed conditions become EMPTY events, not low-probability ones.** Every
iterate lies in $\mathcal S_n$ and $\vdagger\in H^s$ by H1, so
$\|\hat\varphi^{(k)}-\vdagger\|_{H^s}=+\infty$ at every realisation:

- **A5(vi′)**, **A5(vi)**, **`eq:foldrates`** second display
- **(P-a.1)** — $\hat\varphi^{(0)}\in\mathcal S_n$ **and** $P(\|\vdagger-\hat\varphi^{(0)}\|_{H^s}\le\mathsf R)\to1$:
  **both halves of one clause, jointly unsatisfiable**

**[VERIFIED]** the proviso string occurs **once** in `results.tex` (the `def:lfstep` flag) and
**zero** times in `assumptions.tex`.

**Charged by the file's own test** (`rem:obligations`): *"The moment a stated assumption cannot
be written down without the obligation, the obligation has already become an assumption."*

**What this is NOT.** Not a counterexample to `prp:phirate` or `thm:rootn` — at the witness
configuration their hypotheses are unsatisfiable, so they hold vacuously. What is exhibited is
an admissible configuration at which a *maintained assumption's* event is empty.
**Routing:** counterexample-hunter (parameter sweep over $s\in(m-\tfrac12,m)$); theorist (one
clause). **Convention dependence:** if A8's "order" means *degree*, the proviso holds and the
fix is to say so — but `eq:jackson`'s Schumaker calibration then needs re-reading.

## MAJOR — `def:lfstep` bullets 1–2: random functions to random numbers is not justified

*"…being values of the bounded linear functionals `eq:smdiff` at a measurable random element."*
**The functional is itself random** — `eq:smdiff`'s kernel carries $X_{i1},X_{i2},s_{0,ij}$.
Fixed-functional reasoning does not apply; the superposition (Carathéodory) theorem does.

Contrast showing the slip is real: at `proofs.tex` the *identical phrase* does a different job
— pathwise continuity in $\varphi$ at a fixed sample point — where it is exactly right.

**Two further elisions in the same bullets, both $\Pi$-integrations:** the adjoint `eq:hatAadj`
is $\int_{\IR\times\mathcal T}\hat\nu_{u,t}(x)\Xi(u,t)\Pi(du,dt)$, an integral of a random
integrand ("a finite composition of measurable maps" does not reach it); and the $L^2(\Pi)$ norm
claimed measurable *"by the previous step"*.

**The tool is the corpus's own, one Part away:** `def:crossfit`(c′.1) names Carathéodory for
exactly this passage and runs Tonelli for the analogous object; C2′(i) runs it again.
**A verification paragraph that announces itself as a discharge and skips its first link is
worse than none.**

## MINOR

1. **Vector-valued MVT, 7 sites** (round-4 MINOR 1, open). Only the mean value *inequality* is
   valid; an envelope is all that is wanted, so nothing breaks. The file refuses this elision
   twice elsewhere.
2. **(P7a)'s missing $\mathcal F_{XZW}$ slot** (open). The delegate `lem:psubst`(i) carries it.
3. **`lem:pfreeze`'s over-strong $N$-clause** (open, sharper). Six of nine sites cannot supply
   "random element of a space of functions"; `def:crossfit` says of that object *"No equivalence
   class is formed."* **Remedy is deletion of the clause.**
4. **"A9" cited once, defined nowhere** (open). Mis-citation, not a missing condition.
5. **NEW — `lem:unifop`'s hypothesis list is short by what its new paragraph consumes**: C1(ii)
   (strict positivity of $\pi$, load-bearing for uniqueness of the continuous representative),
   H1 (via `def:srcball`), and the Sobolev embedding $H^s\hookrightarrow C(\mathcal X)$ at
   $s>\tfrac12$. `lem:aerr` carries C1 in full; only `lem:unifop` is short.
6. **NEW — `eq:aerr`'s supremum is nested**; the operator norm is itself an uncountable
   supremum over the unit ball of $\mathcal V$. The new paragraph covers the outer $\varphi$-sup
   only. Ingredient present and uncited (separability of $\mathcal V$ and $L^2(\Pi)$).
   Contained: `lem:aerr` declares **Consumers: none**.
7. **NEW — C2′(i)'s "jointly Borel" declaration is one step short of its supplier.** (P6a) gives
   joint measurability in $(\omega,u)$; Doob–Dynkin transports at each *fixed* $u$. **The use is
   unaffected** — the shortfall sits in a declaration, not in the consumption. Formal.
8. **NEW — `def:lfstep` bullet 3 states a hypothesis on $\hat\varphi^{(0)}$ in a parenthesis**
   that no hypothesis list carries.

## Dispatch-20 verification: 12 of 13 claims CONFIRMED

Both MAJORs closed; the separability argument stated once and referenced at four sites plus a
fifth the round-4 report missed; **site accounting measured complete** — six suprema over
$\mathcal V_n$ corpus-wide, two needing no cover, four covered, none missed; `def:lfstep` zero →
16 measurability statements; MINOR 4 settled as **essential** with suppliers cited; MINOR 5
closed, **and its correction of the round-4 count (two sites, not three) is verified and accepted**.

**One claim WRONG:** declining the (O1)–(O4) inventory. The stated ground — *"the discharge is
performed in the same definition that constructs the object"* — holds for bullets 1–3. It does
**not** hold for bullet 4, whose discharge is explicitly deferred to A8. That is precisely a
forward obligation with a later discharge site, i.e. the shape `rem:obligations` inventories.

## Checked and clean

`def:crossfit`(c′.1)–(c′.2) remains the corpus's strongest measurability material and takes no
damage. $\sup_{\mathcal V_n}Z$ is only *a.s. equal* to a random variable — the file sidesteps by
declaring the display is read at the countable sup; legitimate, **not charged**. Step 2's
supremum is deterministic and correctly uncovered. Every interchange in the new text is named
with its hypothesis. Boundary/degeneracy/CMT/Slutsky/$L^p\Rightarrow$a.e. re-checked, clean.

## Distance to the gate

| Fix | Score |
|---|---|
| CRITICAL: A8's order clause + membership condition where the four can cite it | **66** |
| MAJOR: name Carathéodory + Tonelli at the three elided links | **76** |
| The four new MINORs (5–8), one clause each | **88** |
| The four un-attempted MINORs (1–4), one sentence each | **100** |

**Nothing requires a new argument.** Every remedy is a tag already in the block, a device the
corpus runs one Part away, or — for the CRITICAL — half an order on a spline basis.
