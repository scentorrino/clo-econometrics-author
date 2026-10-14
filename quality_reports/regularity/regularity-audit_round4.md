# Regularity Audit — `panel-npiv-discrete`, round 4 (post-dispatch-16 and -17)

> ## ⚠ SUPERSEDED 2026-08-03 — BOTH MAJOR FINDINGS ARE STALE. DO NOT ACT ON THEM.
>
> **Neither MAJOR was open when this report was written into later planning, and both were
> closed by dispatch 21 — before either of the 2026-08-02/03 citation passes ran.** Verified
> against the corpus on 2026-08-03, not against this report:
>
> | Finding | This report claimed | The corpus actually carries |
> |---|---|---|
> | **MAJOR 1** — measurability of $\sup_{\mathcal V_n}$ never established | no separability, no outer-probability convention, no Suslin hypothesis | `lem:unifop`(3c), `proofs.tex:5887–5919`: "$\mathcal V_n$ is separable in $\|\cdot\|_\infty$", a **fixed countable dense $\mathcal V_n^{\circ}$**, the identity $\sup_{\mathcal V_n}\mathsf Z=\sup_{\mathcal V_n^{\circ}}\mathsf Z$, and a Lipschitz bound holding **pathwise off one $\varphi$-free null set** — so the supremum is a random variable **on the given space**. The text states the three ingredients "cover the other two" sites, i.e. `lem:aerr` Step 4 and `def:crossfit`(c′.2). |
> | **MAJOR 2** — `def:lfstep` contains "**zero** occurrences of `measurab` or `random element`" | zero | **33** inside `def:lfstep` in `results.tex`; 66 in `results_s3_supp.tex`, where the 2026-08-02 triage relocated the verification. |
>
> **Corroboration independent of any 2026-08-02/03 agent:** glossary row **C105** declares
> $\mathcal V_n^{\circ}$ as living in "`lem:unifop`'s separability step only" and dates it to
> **dispatch 24**, with a sweep. That row was written before this staleness was noticed and
> before either citation pass ran, so it is not downstream of them.
>
> **CONSEQUENCE FOR THE MISSING-REFERENCE REGISTER.** (M-8) was scoped partly to *supply* the
> device this audit asked for, via `vandervaart1996` §1.7 Examples 1.7.4/1.7.5. It is **PIN
> REFUSED**: the corpus's own argument concludes measurability on the given space, whereas
> Ex. 1.7.4 concludes *ball* measurability and Ex. 1.7.5 needs a *Suslin* index set and the
> $P$-completion. Attaching either would hang an unused hypothesis on a step that does not
> need it. See (M-8) in `proofs.tex`.
>
> **WHY THIS SAT UNCAUGHT, AND IT IS THIS PROJECT'S OWN DEFECT SPECIES.** A finding is a claim
> about the artifact, and it decays exactly like any other claim in the corpus — but nothing
> re-checks a *report* when the artifact moves under it. This one was carried forward into two
> separate hand-offs as "open" on the strength of its date alone. **A report older than the
> dispatch it describes must be re-measured before it is acted on, not quoted.**
>
> The six MINOR findings below are **NOT** re-verified here and may be stale on the same
> grounds. Re-measure before acting. Only the two MAJORs were checked.

**Date:** 2026-07-31
**Score: 62/100** (was 49, 42, 55). 2 MAJOR, 6 MINOR, **no CRITICAL. Nothing counterexample-shaped to route.**
**Status: SUPERSEDED — see the banner above. The 62/100 no longer reflects the corpus.**

> **Persistence note.** The regularity-checker is read-only (`agents.md` §2). Orchestrator transcription; **[ORCHESTRATOR VERIFICATION]** marks checks re-run against the corpus afterwards.

| | Count | Each | Total |
|---|---|---|---|
| CRITICAL | 0 | −20 | 0 |
| MAJOR | 2 | −10 | −20 |
| MINOR | 6 | −3 | −18 |
| **Score** | | | **62** |

**The rise is entirely closures. Every open finding from rounds 1–3 is closed.** What remains is one new species — suprema over an uncountable index in **Part H**, which no prior sweep covered, rounds 1–3 having been scoped to Part I and the (P8) block — plus one new object-level gap and six formal items.

---

## MAJOR 1 — measurability of $\sup_{\mathcal V_n}$ is nowhere established, and Part H takes probabilities of it

`proofs.tex:4624–4628`, `results.tex:3076–3079`, `2934–2937`.

> `proofs.tex:4627` — $P\big(\sup_{\mathcal V_n}Z\ge\tfrac34\hat\delta_n\big)\le\exp(\cdots)$
> `results.tex:3077` — $\sup_{\varphi\in\mathcal V_n}\|\hat T(\varphi,\theta_\dagger)-T(\varphi,\theta_\dagger)\|_{L^2(\Pi)}=O_P(\hat\delta_n)$

$\mathcal V_n$ is the source-condition ball `eq:srcball` — **uncountable**. $Z(\varphi):=\|\bar T(\varphi)-E\bar T(\varphi)\|_{L^2(\Pi)}$ is a process indexed by it. Writing $P(\sup Z\ge\cdot)$ and $\sup=O_P(\hat\delta_n)$ requires the supremum to be a random variable. The three standard remedies — separability in a norm for which the process is continuous; an outer-probability convention; a Suslin/analytic-set hypothesis — **none is invoked**. The lemma's own "What is used, and what is not" paragraph (`results.tex:3093–3119`) is silent on it.

Three further instances of the same shape: `proofs.tex:4575`; `proofs.tex:4266–4271` (`lem:aerr` Step 4); `results.tex:2935` (`eq:aerr`).

**Why charged rather than excused as ambient: the doctrine is the file's own.**

> `proofs.tex:3152–3157` — *"each supremum over $u\in\IR$ equals the supremum over $u\in\mathbb Q$, a countable set… **This step is not a formality: without it $\Lambda^{(0)}_\star$ and $\Lambda^{(1)}_\star$ are integrals of functions not known to be measurable**"*

Applied again at `results.tex:4493–4496` (inner sup in $u$) and `4498–4514` (outer ess-sup). **[ORCHESTRATOR VERIFICATION]** the device is also load-bearing in `lem:pgence` (`proofs.tex:275–276`, `796`, `810`), which "states the five operations as FIVE CLAUSES AND PROVES EACH, with Jensen run off the countable dense set." **Part H's suprema over $\varphi$ are the one family it was not applied to.**

**Repairable in a line, because the ingredients are present.** `lem:unifop` (3a) at `proofs.tex:4597–4606` already proves $\varphi\mapsto Z(\varphi)$ is $\mathsf c_{10}h_u^{-1}$-Lipschitz in $\|\cdot\|_\infty$. What is missing is the statement that $\mathcal V_n$ is $\|\cdot\|_\infty$-separable — which it is, $\mathcal X$ being a compact interval by A0 and $s>1/2$.

**Honest scoping, measured.** `\eqref{eq:unifop}` and `\eqref{eq:aerr}` are cited by equation number **nowhere** downstream. `prp:phirate`'s "Where L-19 is consumed" (`proofs.tex:5299–5302`) names `lem:unifop` **Step 4** (deterministic) and **(3d)** (a covering-number bound) — neither is the supremum. So the live exposure is *a stated lemma whose display is not a well-posed probability statement*, not a currently-consumed proof step. Still MAJOR by this file's own precedent: it is verbatim the ground on which A4(iii) was repaired in dispatch 16.

---

## MAJOR 2 — $\hat\varphi^{(-k)}$ is *required* measurable and simultaneously *pinned* to a data-driven-stopping construction; nothing verifies compatibility

`results.tex:4364–4372` vs `4321–4329` and `3470–3478`.

> `results.tex:4365` — *"Each of $\hat\varrho^{(-k)}$, $\hat b^{(-k)}$ and $\hat\varphi^{(-k)}$ is a **$\sigma(\mathcal I_{-k})$-measurable random element** of … $\mathcal V$"*
> `results.tex:4358` — *"(c′.1) **is a requirement on the estimators and not a consequence of anything above it**"*

But clause (b), two lines earlier, has already fully specified the object: *"$\hat\varphi^{(-k)}$ **is** the estimator of `def:lfstep`"* — and `def:lfstep` builds it through a **data-driven stopping index** $\hat m^{(k)}$ with an emptiness convention (`results.tex:3472–3478`).

**You cannot require a property of an object you have already constructed; you must verify it.** The verification is three lines: $\hat m^{(k)}$ is a hitting index of a finite family of measurable events (measurable, the cap $\bar m_n$ being deterministic and the convention making it total); the iterates $v_m$ are finite compositions of measurable maps; and $v_{\hat m^{(k)}}=\sum_{m\le\bar m_n}\un\{\hat m^{(k)}=m\}v_m$.

**[ORCHESTRATOR VERIFICATION — confirmed.]** `def:lfstep` (`results.tex:3398–3534`, 136 lines) contains **zero** occurrences of `measurab` or `random element`. The critic's corpus-wide greps (80+ `measurab`, 13 `random element`) return no hit concerning $\hat\varphi$, $\hat m$, or $v_m$.

**Three live consequences, each a probability statement about the object:** `proofs.tex:5318` ($O_P(\hat\varepsilon_k)$); `proofs.tex:4717–4718` (`lem:pathcont`, "with probability tending to one"); `proofs.tex:5235–5236` ((P-a.3), an event defined through the realised random operator).

**The file does exactly this verification where it is trivial and not where it is not.** `assumptions.tex:1445–1453` discharges $\hat\varrho$'s version *"by inspection of the formula — which every kernel and every series construction is."* That is unavailable for a Landweber–Fridman iterate stopped by a discrepancy rule. The corpus's own test applies (`rem:obligations`, `results.tex:1561–1566`): *"The moment a stated assumption cannot be written down without the obligation, the obligation has already become an assumption."* It is also absent from the (O1)–(O4) inventory.

Not plausibly false; unstated, and stated as an assumption where it is a verification.

---

## MINOR

1. **Vector-valued MVT, seven sites** (R1-M3, still open and broader than round 1's count of four): `proofs.tex:2485, 2494, 2613, 2711, 5649–5650, 5943–5944, 6087`, all with $\IR^p$-valued integrands. Harmless — only an envelope is wanted and the *mean value inequality* is valid — but the file names the wrong theorem while **refusing exactly this** at `proofs.tex:1073–1076` and `6221–6223`.
2. **(P7a) does not print the $\mathcal F_{XZW}$-measurable second argument its only live consumer supplies** (`proofs.tex:580–586` vs `1772–1773`). The tool it delegates to, `lem:psubst`(i), *does* carry the slot. One-line remedy.
3. **`lem:pfreeze` states a hypothesis six of its nine sites cannot supply** (`proofs.tex:835` vs `results.tex:4439`), and `rem:pfreezesites` is silent on it. Harmless — the proof uses only `eq:freezecomp` — but this is the shape the file has twice charged higher. **Remedy is deletion of the clause, not repair of the sites.**
4. **C2′(i)'s envelope $\bar f_k$ is a sup over an uncountable index and $E[\bar f_k]<\infty$ presupposes its measurability** (`assumptions.tex:2247–2250`). Same species as the A4(iii) defect dispatch 16 repaired; the supplier exists one Part away and is uncited (`def:pregver`(P6a); the Carathéodory argument at `proofs.tex:1046–1048`, which says *"this is used silently below"*). Also unresolved in the same clause: whether $\|\bar f_0\|_\infty+\|\bar f_1\|_\infty<\infty$ is essential or sure.
5. **(R-a) prices $\|\partial_u\hat\ell^{(-k)}\|_\infty$ as $O_P(1)$; three proof steps read it as a.s. finite** (R1-M5, still open). Harmless — the envelope appears only on the right of inequalities — but "bounded" should extend to the derivative. One word.
6. **"A9" is cited once and defined nowhere** (`proofs.tex:5086`). **[ORCHESTRATOR VERIFICATION — confirmed: exactly one occurrence corpus-wide.]** The condition itself exists and is correctly located elsewhere (`proofs.tex:4181`, `eq:foldbal`), so this is a mis-citation, not a missing condition. Primarily the assumption-auditor's territory.

---

## Checked and clean — recorded so silence is not read as absence

- **Fréchet derivative at the unknown truth.** `prp:frechet` takes **no** derivative-under-integral: the increment is exact by conditioning, the expansion is Taylor with **integral** remainder with the measurable-selection objection stated and answered (`proofs.tex:1073–1076`), joint measurability by Carathéodory. `prp:phirate` Step 0 elects the conditional-on-sample route and prices it. **The operator-noise-as-operator issue is handled, not hidden.**
- **Data-driven stopping index.** Freezing the realisation makes (F-f) applicable verbatim; (L1)'s $\|\mathcal L\|\le1$ is **sure** via a deterministic normalisation; (L2) separates compression from restriction; (L4)'s non-emptiness is established with a convention for the empty case. **The only gap is MAJOR 2's measurability, not the argument.**
- **Every interchange is named with its hypothesis** — 40+ sites grepped, each naming DCT/MCT/Fubini/Tonelli and exhibiting an envelope. `proofs.tex:3600–3606` corrects Tonelli to Fubini because the integrand is signed.
- **$L^p\Rightarrow$ a.e. is not committed** — `proofs.tex:3119–3122` rejects a Fourier route explicitly because the a.e.-convergent subsequence could depend on $t$.
- **Boundary / degeneracy.** $\theta_\dagger$ interior; $\vdagger\in\mathcal V$ by A1b(i). Binary-instrument degeneracy: A4(i) bounds $\varrho$ off $\{0,1\}$; `lem:momzero` Step 5 records that without overlap $E[\widetilde W^2\mid\Delta Z]$ may vanish.
- **CMT / Slutsky** — all at the limit point, nonsingular-$\hat J$ event carried explicitly; the studentised limit's strict positivity now *derived* rather than assumed.

## Prior findings — all closed

R3-MAJOR-1 (outer ess-sup on "likewise"), R3-MAJOR-2 (A4(iii) measurability), R3-MAJOR-3 ((P1)–(P9) uncompiled), both R3 recorded-not-charged items, all seven R3-MINORs, R2-MAJOR-1, R2-MAJOR-2, R1-MAJOR-2, R1-MAJOR-3, R1-M1, R1-M2, R1-M4 — **each verified against the current `.tex`, not against the prior report.** Only R1-M3 and R1-M5 remain (MINORs 1 and 5).

## Distance to the gate

| Fix | Score |
|---|---|
| Separability of $\mathcal V_n$ in $\|\cdot\|_\infty$ — one sentence in `lem:unifop`(3c), one in `lem:aerr` Step 4 | **72** |
| A measurability paragraph for `def:lfstep`'s output (3 lines) + a pointer from `def:crossfit`(c′.1) | **82** |
| The six MINORs, one sentence each | **100** |

**Every item is localised to a named line and none requires a new argument.**
