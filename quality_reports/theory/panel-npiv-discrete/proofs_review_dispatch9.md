# Theory Review — Part H strike-3 fix pass, `panel-npiv-discrete`

**Reviewer:** theorist-critic · **Severity:** HIGH (Execution) · **Gate:** 80 · **Strike 3**
**Persisted by the orchestrator.** Trajectory 58 → 66 → **92**. Disposition `theory_memo.md` §D-00000000000.

## SCORE: **92 / 100 — CLEARS 80 AND CLEARS 90.**

**0 CRITICAL · 0 MAJOR · 3 MODERATE · 2 MINOR · −8.**

> All seventeen findings of dispatch 8 are closed, **each verified independently rather than accepted from the disposition.** The five residual items are new, small, and — the part that matters for routing — **not one requires a decision the theorist cannot make alone. There is no escalation question.**

---

## Priority 1 — `lem:scaleinv`: all five clauses check, and the second edge IS disposed of

| Clause | Verdict |
|---|---|
| (i) iterates identical from $v_0=0$ | ✓ |
| (ii) residuals proportional at every $m$, same first index | ✓ |
| (iii) $\mathsf R\mapsto\omega^{2\mu}\mathsf R$, $\delta\mapsto\omega^{-1}\delta$ | ✓ positive homogeneity of the functional calculus legitimately invoked |
| (iv) exponents cancel exactly | ✓ every $\omega>0$, every $\mu>0$ |
| (v) $(\omega^{2\mu+1}\mathsf R/\delta)^{2/(2\mu+1)}=\omega^2(\mathsf R/\delta)^{2/(2\mu+1)}$ | ✓ |

**The disposal of both edges is confirmed — and the critic withdraws its own dispatch-8 claim.** It is (iv) *together with* `rem:ff`'s hypothesis being $\|\mathcal L\|\le1$, an **inequality**, and $c_\mu=c_\mu(\mu,\tau_{\rm DP})$ only. If the unscaled norm is $o(1)$ then (F-f) applies **a fortiori** and $c_\mu$ is uniform over that class. *"My dispatch-8 claim that '$c_\mu$ needs $\|\mathcal L\|\asymp1$' was wrong; the theorist is right and I withdraw it."*
**The sharpest sentence in the lemma** is the observation that (F-f)'s conclusion is in the **domain** norm, which rescaling the equation does not touch — *"that is what makes the invariance non-trivial."*
**Enlarged cap verified against (L4) non-emptiness at the new cap** — both sides carry $\omega_n^2$, so the argument is the old one multiplied through. Also verified: (L2)'s projection claim, `def:lfstep`(b)'s relaxation, and (L1) genuinely **sure** with `eq:normconst` reproducing `prp:hatAprop`(i)'s constant exactly.

## Priority 2 — (L3) follows, and the $\sup_kC_k$ route is genuinely UNNECESSARY

Both inequalities do what is claimed. **The theorist's stronger claim is correct, re-derived explicitly:** with $\varepsilon_{k-1}\le C\hat\varepsilon_{k-1}$ the induction closes at $C_k\equiv C$ **for every $k$**, provided $\mathsf c_{14}\ge\mathsf c_{16}C^2$ and $\mathsf c_{15}\ge\mathsf c_{17}$. **The constant does not grow with $k$, so $\sup_kC_k<\infty$ is unnecessary, not merely unused — the repair taken is strictly better than the one offered.**
*But the same derivation exposes MODERATE A below: $C=C_0$ is the preliminary's $O_P$ constant, and $C_0=1$ is what the file assumes.*

## Priority 3 — 2.4 applied correctly, not merely applied

**Step 1's correction is right and right for the stated reason:** the spline direct (Jackson) theorem is a deterministic approximation statement requiring order-$>s$ B-splines on a quasi-uniform mesh and the given $L_x$ — **no lower bound on $L_x$ relative to $n$.**
**Both budget rows verified independently:** $s>\tfrac{9\alpha}{8(1-2\alpha)}$ ($=1.6875$ at $\alpha=\tfrac38$, $=1$ at $0.32$) and $s>\tfrac1{2(1-2\alpha)}$ ($=2$, $=1.389$); gap $\tfrac{4-9\alpha}{8(1-2\alpha)}>0$ for $\alpha<\tfrac49$; margin $(n^{0.2411},n^{0.25}/\ln n)$ ✓. `rem:l19cost`'s $1.6875$ correctly identified as **the same budget read twice, not a second line.**

## Priority 4 — the remaining findings, all closed
**2.3** ✓ limit now taken in A6 by Gateaux differentiability, base point at $0$ so both displays carry the same $\hat g_i$ and `eq:a6sieve` is exact; the `eq:a6b` vacuity right; gap flagged; "only if" with the declined $\lambda_{\min}$ named. **3.1** ✓ factorisation re-derived; sentence struck at all three sites; Q-1 unchanged. **2.5** ✓ all three live sites, statement included (the surviving "$\mu$ alone" is in a file carrying a **STALE MERGE RECORD** banner — not charged). **2.6** ✓ *"best-handled item of the round."* **2.7** ✓ family moved to $\Omega$; the bare-$\Omega$ local written out per C25. **3.3** ✓ `lem:aerr` opens "**Consumers: none**". **4.1** ✓ `rem:ff` displays (F-f) with the cite, transcription faithful to EHN Ch. 6. **3.2, 3.4** ✓ (the Löwner order-2 determinant verified: $\to-1$ as $\epsilon\downarrow0$ **because $p>1$**). **2.8** ✓ Paley–Wiener argument correct, boundary layer honestly printed as not established. **2.9, 3.5, 4.2, 4.4** ✓.

---

## Residual findings

### MODERATE A (−2) — the induction's base case
`eq:fixedpoint` asserts $\varepsilon_k\le\hat\varepsilon_k$ **w.p.→1**; at $k=0$ that is $\varepsilon_0\le\hat\varepsilon_0$, **strictly stronger than (P-a)'s $O_P(\hat\varepsilon_0)$.** So "(L3) needs $\mathsf c_{14}\ge\mathsf c_{16}$" is **not sufficient** — it must be $\mathsf c_{14}\ge\mathsf c_{16}C_0^2$ with $C_0$ the preliminary's unknown $O_P$ constant. **This is 2.1's own species one level down:** the content of 2.1 was that the analyst must be told what to dominate, and the file now names two constants and prints a false precision about them. Failure mode is the one the file itself prints.

### MODERATE B (−2) — (P-a) already implies the calibration `lem:scaleinv` says nothing establishes
(P-a) assumes $\|\hat{\mathcal A}\zeta\|\asymp\|\zeta\|_{H^{-a}}$ on $\mathcal S_n$ with $n$-free constants. Upper half plus $\|\zeta\|_{H^{-a}}\le\|\zeta\|_{L^2}$ gives $\|\hat{\mathcal A}|_{\mathcal S_n}\|\le C_2$; lower half at a fixed smooth $\zeta_n$ gives $\ge C_1c>0$. **So (P-a) supplies exactly the two-sided calibration `results.tex:3092` says "nothing in Part H establishes".**
Three consequences: **(1)** the claim *"nothing in Part H **needs** $\|\mathcal L\|\asymp1$"* is **true and confirmed**; the adjacent *"nothing establishes it"* is misleading. **(2)** The divergent $\omega_n$, and `eq:cap`'s $\omega_n^2$ inflation of the iteration budget, is therefore a **choice** — *"a computational cost a Step-7 author and a `/simulate` grid will actually pay."* **(3) The sharpest remaining assumption-parsimony issue in Part H:** the file declines a $\lambda_{\min}(\mathbf G_n)$ bound at **four** sites and then assumes a two-sided link condition implying a bound of that species on the sieve. **A methods referee will connect those.** Q-4 should price it.

### MODERATE C (−2) — the A8 sweep is itself unswept at one site, and this pass created the contradiction
`results.tex:3039–3041` still says *"A8's **window** is what makes the Hilbert-scale route available … and that is a use of A8 the block does not yet record."* **Both halves are now false** — `prp:phirate` cites A8 by clause and disclaims the lower end, and `assumptions.tex:2055` records the use. Substantively nothing turns on it (the link condition needs the *sieve*, not the *window*), **but it is the same "one place out of N" species as 2.5 and 3.3, in the clause (P-a) points at, and the pass claims the A8 sweep complete.**

### MINOR D (−1) — $\mathcal L$ carries two referents across the round's two new displays
`lem:scaleinv` sets $\mathcal L$ = **unscaled**; `prp:phirate` Step 2 sets $\mathcal L:=\omega_n^{-1}\hat{\mathcal A}|_{\mathcal S_n}$ = **scaled**, matching `rem:ff`. So (L5) silently maps lemma-$\mathcal L_\omega\mapsto$ Step-2-$\mathcal L$. INV-7, **in the single place the round's new lemma is consumed. The pass swept $\Omega$ and $\omega$ meticulously and did not sweep $\mathcal L$.**

### MINOR E (−1) — (L5) states the source condition at the wrong operator by one restriction
(F-f) is applied at $\mathcal L=\omega_n^{-1}\hat{\mathcal A}|_{\mathcal S_n}$, whose $\mathcal L^\ast\mathcal L$ is the **compression**, not the restriction of $\hat{\mathcal A}^\ast\hat{\mathcal A}$. (P-a) delivers the right object, so this is precision, not a gap — **but `rem:ff` invites the reader to check (L1)–(L5) line by line, and this is the line they will stop at.**

### Nits (no deduction)
Memo says "three passes running", glossary says "the second time in three passes" — same fact, two counts. `def:lfstep`(2b) calls Lepskii "purely data-driven" then notes it needs a variance proxy; both true, phrasing invites the objection.

---

## Judgement on the sync-script proposal: **tooling gap — but the proposed row closes only half, and the smaller half**

Two distinct species:
- **(a) A withdrawn symbol survives at a live site** — C44, C58. A grep is complete and mechanical. **"No human discipline is reliable against a 4,000-line file; this is unambiguously tooling."** Add the row.
- **(b) A *claim* corrected in one place out of N, with no symbol withdrawn** — 2.5 ($\bar k$, 1 of 3), 3.3 (`lem:aerr`, 2 sites), and finding **C** above. **A withdrawn-symbol row catches none of these. Three of the four recurrences are species (b), and species (b) recurred again this round, in the fix meant to end it.**

**Recommendation: adopt the row, and add a second list on the same mechanism — a *retired-phrase register*.** When a pass corrects a repeated statement of fact (a parameter list, a consumer list, an assumption-clause attribution) it records the *old* string and the script greps live files for it. **Same cost, same machinery, and it is the list that would have caught 2.5, 3.3 and C.** *"The theorist's instinct is right; the diagnosis is one species too narrow."*

---

## Blocking vs polish — **NO ESCALATION**

> **Findings requiring a decision the theorist cannot make alone: NONE.** All five are inside the theorist's own authority and none changes a conclusion, a hypothesis, or a rate.

| # | Nature | Closes by |
|---|---|---|
| **A** | Mechanical | One clause: declare $\hat\varepsilon_0$ a w.p.→1 bound, or carry $C_0$ into the $\mathsf c_{14}$ condition and `rem:phirscope`(5). |
| **C** | Mechanical | One sentence at `results.tex:3039–3041`. |
| **D** | Mechanical | Rename in `lem:scaleinv`, or a mapping sentence at (L5). |
| **E** | Mechanical | One restriction marker at `proofs.tex:4064`. |
| **B** | An **authorial choice** | (i) keep the divergent $\omega_n$ and note (P-a) also caps the norm, so `eq:cap` is conservative; or (ii) re-base on (P-a)'s constant and shrink the cap. **Neither changes `eq:phirate`.** (i) is more honest and cheaper. Either way **Q-4 must price (P-a) as implying an operator-norm calibration of $\lambda_{\min}$ species.** |

**Four polish, one authorial choice, zero escalations.** Step 7 does not read B — it reads $\delta_n$ off A5(ii) and `prp:phirate`, both now correct.

---

## Routing

**Step 7: YES**, after the three narrow re-sweeps. **Both dispatch-8 leaks are closed** — `prp:phirate`'s statement describes $\bar k$ correctly, and `eq:lxwindow` makes the rate route's sieve window non-empty at $s=1.75$. Open with `rem:phirscope`(2)'s $\ln n$ warning as a hard note and `rem:h6bandwidth`(5): **design $(2,3,\tfrac34,0.32)$, illustration $(1,3,4.5)$.**

- **assumption-auditor — MUST, still the highest-value sweep.** **Finding B is exactly its species** — (P-a) implies a calibration no usage matrix records as a use of (P-a). Finding C too, plus the `eq:lxwindow` rows and A8's clause-citation.
- **notation-warden — MUST.** Finding D ($\mathcal L$). Adjudicate C67's $\Omega/\omega_n$ case pair and the recorded $\mathsf c_{13}$ hole.
- **regularity-checker — SHOULD.** Findings A ($O_P$ vs w.p.→1) and E (compression vs full operator); confirm `lem:scaleinv`'s functional calculus. **Its two prior items are now discharged.**
- **counterexample-hunter — RE-RUN, a change from dispatch-8 routing. The trigger I set fired:** `eq:a6sieve` *has* been restated — derived from A6, base point fixed, claim weakened to "only if". Binary gate not in question; re-read the restated display.
- **derivation-verifier — done.** `phirate-prelim-pf-identity` settles 3.1; factorisation reproduced by hand.

## Positive findings
**`lem:scaleinv` is the round's best work and real mathematics, correctly done** — it converts "this costs nothing" into a five-clause proved statement, identifies the normalisation as a *relaxation parameter* (not merely non-colliding but the **correct reading**), locates the cancellation in the exponent pair, and **finds the one thing that does not cancel and pays for it with `eq:cap`.**
**The 2.1 repair is stronger than the one offered, and the file says so without overstating it.** Separating constants by *role* makes the $C_k$ composition **not arise at all** rather than be bounded. *"Refusing a critic's repair by producing a better one, and flagging it rather than folding it in silently, is exactly right."*
**Two self-caught items, both good judgement** — rejecting $\varsigma_n$ on the double ground of a C25 violation *and* proximity to the binding $\varsigma_0$; and finding the third unswept withdrawal in no report of either reviewer, **then naming it as a species rather than a one-off.**
**"Nothing was contested that should have been, and nothing was conceded that should not have been."**
