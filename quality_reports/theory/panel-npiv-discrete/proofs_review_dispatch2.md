# Theory Review — `panel-npiv-discrete`, Stage 3 dispatch 2 (ROUND 2)

**Reviewer:** theorist-critic · **Severity:** HIGH · **Gate:** 80 · Supersedes the round-1 dispatch-2 report (54/100).
**Persisted by the orchestrator.** *Filename note:* the critic flagged that `proofs_review.md` held the **dispatch-1** record (88/100) and that persisting here would destroy it. Dispatch 1 is now at `proofs_review_dispatch1.md`.

## (a) SCORE: **84 / 100 — CLEARS 80.** Dispatch the narrow critics.

| Phase | Verdict |
|---|---|
| 1. Claim identification | Clean. |
| 2. Proof validity | **No CRITICAL.** All four round-1 MAJORs discharged mathematically. **Two fresh defects, both inside the new `cor:rangegap`.** |
| 3. Assumptions / statements | MAJOR ×1 (MAJ-4's debt half-paid + wrong assumption cite); MINOR ×5. |
| 4. Citations / linkage / polish | MINOR ×3; one m-9 residue in the *other* remark. |

## (b) Did the three over-delivery items introduce new defects? **Two of three did.**

### MAJ-1's recast — **CLEAN. The best work in the round.**
The increment identity is correct: `eq:trialres` gives $\Delta U(\theta,\varphi)-\Delta U(\theta,\varphi_0)=-\Delta(\varphi-\varphi_0)$ exactly; both products integrable by clause 3; `lem:nusigma`(iii) converts under clause 2. $\theta$ cancels visibly; no term of $\Delta U$ evaluated alone. **`eq:gproviso` is what the proof consumes** — clause 1 in Steps 0 and 3, clause 2 in Steps 0 and 1, clause 3 in Step 1 — with one redundancy (R2-7).

**Step 0 verified line by line:** $\int|\nu_g|\le2E|g|$ by conditional Jensen; $\int|\nu_gh|\le\sum_jE|gh(X_j)|$; $\Xi h\in L^1(\pi)$ via the constant-plus-centred decomposition; $\|T_n\|=\|\Xi\un\{|\Xi|\le n\}\|_{L^2(\pi)}$ by Riesz on a finite measure; pointwise convergence by DCT; Banach–Steinhaus; monotone convergence. Correct throughout, and the note that $h\equiv1\notin\mathcal V$ is why clause 1 is separate is exactly right.

**Dropping $\sigma(W,\Delta Z)$-measurability breaks no consumer.** Every reference grepped: `cor:udep` (three sites) and `rem:nophifree`. `lem:adjoint` Step 3 and `cor:rangegap` Step 1 route through `lem:nusigma`(iii)/(P5) directly — and `lem:adjoint`'s $g=\widetilde W(\mathcal W\ell)(\Delta U,\Delta Z)$ is *not* $\sigma(W,\Delta Z)$-measurable, so the old statement could not have covered it anyway. **The generalisation is genuine.**

### MAJ-3's independence claim — **FALSE for one of three items.**
- **`prp:kerchar`: independent — CONFIRMED.** Its only route to B1(iv.a) is Step 1's appeal to `lem:bierens` Step 5, which uses it *only* through full topological support of $\Pi_u$. $\varpi_u$ appears nowhere in Steps 1–5.
- **`cor:a1cprim`: independent — CONFIRMED.** Reads `prp:kerchar`(i) only. The m-7 split is correct.
- **`cor:rangegap`: NOT independent.** Stated under "the hypotheses of `lem:adjoint`", consuming (iii) at Step 2 and (ii) at Step 3 — both *are* the N-10 closure. Without absolute continuity of $\Pi_u$, $\mathcal W$ **has no definition**; the norm bound uses $\|\varpi_u\|_\infty$; the density argument uses $\varpi_u>0$ everywhere. Roll B1(iv.a) back and the corollary **ceases to have a subject.**

The `.tex` files get this right; **only `theory_memo.md` §D4's N-17 row adds `cor:rangegap`** — and that is the row transcribed into plan §2.7. **Highest-consequence error in the round precisely because it is the one written down.** Accurate statement: `cor:rangegap` is independent of the *round-3 $C^1$ clause* only.

### `cor:rangegap` itself — statement correct and correctly scoped; two fresh defects in the argument.
The squeeze is right: $\mathcal A^\ast_{\rm cond}=\mathcal B\circ\mathcal W$; $\mathcal R(\mathcal A^\ast)=\mathcal B(\mathcal R(\mathcal W))\subseteq\mathcal R(\mathcal B)$; continuity of $\mathcal B$ plus density gives $\mathcal R(\mathcal B)\subseteq\overline{\mathcal R(\mathcal A^\ast)}$. **Implemented at the stated strength and not beyond** — never claims $\mathcal R(\mathcal B)=\mathcal R(\mathcal A^\ast)$, and the "no characterisation of $\mathcal R(\mathcal W)$ required" disclaimer is in both renderings. F-20's half of open item 8 genuinely removed.

## (c) MAJ-4: $P$-free YES; sufficient NO; lever OVERSTATED
- **$P$-free — YES.** All four clauses restrict only $\varpi_u$, a range-side reference density the analyst picks. Gaussian, logistic, Cauchy all satisfy them.
- **Sufficient for A2′(i) — NO, only necessary (R2-3).** `eq:Wderiv` has two terms. $C^1$ makes the first bounded. The second, $\varpi_u\int\partial_u\ell\,w\,d\Pi_t$, needs $\partial_u\ell^\Pi$ to exist with a dominating function, which the block still does not deliver. **The obstruction is halved, not removed.**
- **Lever "delivered rather than asserted" — OVERSTATED.** `eq:Wderiv` is a *conditional* identity whose hypothesis is undischarged and deferred to L-21/Step 4 — which memo §D5 item 2 still lists as open. The `.tex` carries the proviso honestly; the memo does not.

## (e) DEDUCTION TABLE

| ID | Finding | Sev | Δ |
|---|---|---|---|
| **R2-1** | **N-17 groups `cor:rangegap` with `prp:kerchar`/`cor:a1cprim` as independent of the B1(iv.a) strengthening.** It is a corollary to `lem:adjoint`(ii)–(iii), which *are* the closure. The `.tex` and memo §§D1.4/D2.3 are correct; only the escalation row is wrong — the row plan §2.7 absorbs. | MAJOR | −3.5 |
| **R2-2** | **`cor:rangegap` Step 1 identifies the Riesz representer with $\nu_{g_\Xi}/\pi$ without establishing $\nu_{g_\Xi}/\pi\in L^2(\pi)$**; the cited justification presupposes it. **Exactly the defect m-3 repaired in `prp:nophifree` Step 0**, whose conclusion applies verbatim and is not cited. Both renderings. | MAJOR | −2.5 |
| **R2-3** | **`eq:Wderiv`'s proviso cites B1(v), which dominates $\partial_u\lambda$ in the $L$-representation — one derivative short** of the $\partial_u\ell^\Pi$ the second term needs, since $\mathcal W\ell^\Pi_\star=\partial_uL_\star$. A2′(i) still bounds a derivative the block does not deliver; the memo's "aspiration into a theorem" overstates. | MAJOR | −3 |
| **R2-4** | "$\tilde c$ admissible" in $\mathcal N_0$'s definition is defined nowhere; the glossary drops the qualifier and calls $\mathcal N_0$ a "subspace". Quantifier hygiene one level below where MAJ-2 fixed it. | MINOR | −1.5 |
| **R2-5** | "An injective compact operator of infinite rank has non-closed range" applied to $\mathcal A^\ast_{\rm cond}$, whose non-injectivity **the same paragraph concedes seven lines earlier**. Injectivity is unavailable and unnecessary — a compact operator has closed range iff finite-dimensional, and H1 settles it. | MINOR | −1 |
| **R2-6** | FF Prop. 2.1 display silently translated into $X_1,X_2,x$ while keeping their $\psi$; the resulting $d\omega$ integral **presupposes a non-binary instrument** in a paper whose instrument is binary; $\psi$ is glossary-RESERVED. "Notation, fixed once" sits 130 lines downstream. | MINOR | −1.5 |
| **R2-7** | `eq:gproviso` clause 3 redundant beyond $\varphi=0$ given clause 2. | MINOR | −0.5 |
| **R2-8** | `prp:kerchar` Step 4 invokes Step 1's continuity at the *conditional* level; Step 1 established it unconditionally. Justification one step early. | MINOR | −0.5 |
| **R2-9** | Memo §D2's table reads as inheriting exactly what m-7 removed. `.tex` is right. | MINOR | −0.5 |
| **R2-10** | `cor:udep`: "in that case every term of order two or higher vanishes" — by `eq:incrfree` this holds **unconditionally** whenever $g$ is $\varphi$-free. | MINOR | −0.25 |
| **R2-11** | Bookkeeping bundle: (P5) scope note; glossary `:254` $\ell_\dagger$ against §8.5's "without exception"; `results.tex:15` stale exclusion list; proof order vs header; `assapp1` vs A0 for compactness; memo "Ten specs" above a thirteen-row table. | MINOR | −0.75 |
| | | **Total** | **−15.5** |

**Score 84/100.** Clears commit and the 80 gate; below the 90 PR gate. **R2-1 is one table row; R2-2 is one cross-reference. Together worth 6 points.**

## Adjudications
**MAJ-2 is now a true three-way equivalence.** (a)⟺(b) is `prp:nophifree` at this $g$; (a)⟺(c) is linearity of $g\mapsto\nu_g$ with $\nu$ now defined at `eq:nudef` — closing the dispatch-1 R2-9 charge. The splitting is licensed by $E|\widetilde Wc|\le E|g|+E\|\Delta Z\|<\infty$. **Nothing downstream needs the existential form.** The "quantifier that must not be relaxed" paragraph is correct and is the right thing to have written.
**(P4c) re-verified.** Boundary correct; used only at `prp:kerchar` Step 5.
**F-18/N-13 — the theorist is right to decline.** $\partial_u\ell_\star\not\equiv0$ does not preclude $q\equiv0$ by cancellation inside $E[\cdot\mid X_1,X_2]$. Stating the necessary condition and stopping is what makes the $n^{-1/4}$ chain credible.
**Symbolic verification: 13/13, not scored per dispatch.**

## Priming for the narrow critics
**counterexample-hunter:** (1) $\mathcal W$ non-injective with $\mathcal A^\ast_{\rm cond}$ non-injective — refutes R2-5's reason by example; (2) **$\ell^\Pi_\star$ solving the adjoint equation with $\partial_u\ell^\Pi_\star$ nowhere defined** — converts R2-3 from "half-paid debt" to "A2′(i) is vacuous for some admissible designs"; (3) singular-continuous $\Pi_t$, now with a *second* consumer in `lem:adjoint` Step 4; (4) $p_X\ne\varrho$ with a live instrument (carried); (5) A1c holding while A1b(iii) fails (carried); (6) $\mathcal N_0$ nontrivial with $-\nu\in\overline{\mathcal N_0}\setminus\mathcal N_0$ — `cor:udep`'s escape route is a range condition whose closedness is unaddressed; (7) do **not** re-probe $w=\cos$.
**regularity-checker:** (1) (P7a) applied with a **random** $\zeta$ at `lem:adjoint` Step 3 — a freezing step on the rcd, named but not spelled out; (2) `cor:rangegap` Step 1's $L^2(\pi)$ membership (R2-2); (3) `eq:Wderiv`'s differentiation under the $\Pi_t$-integral (R2-3); (4) `cor:udep` Step 1's FTC presumes $L(\cdot,z)$ absolutely continuous, hypothesis gives only $\partial_uL=c(z)$; (5) R2-8; (6) `prp:kerchar` Step 3's functional monotone class — name the version; (7) A1c's equivalence comment may now be **stale**, since `prp:kerchar` proves the passage it called unavailable.
**notation-warden:** R2-4, R2-6, R2-11; plus `eq:adjointdisplay` writes $\nu_{\widetilde W\mathcal W\ell}$ where `eq:adjclosed` writes $\nu_{\widetilde W(\mathcal W\ell)}$.
**assumption-auditor:** R2-3 (B1(v) cited for a domination it does not supply; its second half is now the *only* live half after F-19 retired the first), R2-7, R2-9; check (iv.c) is actually consumed by each block citation; A2′(ii) implied by A2′(i), retained deliberately for tier T3 and correctly documented.
**derivation-verifier (advisory):** the $\|\mathcal W\|$ constant chain verified by hand — including the non-obvious point that one power of $\varpi_u$ is absorbed into $\Pi_u$ and one is bounded; `adjoint-Wnorm-constant` is aimed at exactly the squared-$\varpi$ error and is well designed. Add a spec for $\mathcal B\circ\mathcal W=\mathcal A^\ast$ in the two-point finite model.

## Positive findings
- **The MAJ-1 recast is the right kind of over-delivery.** Faced with a false sentence, the theorist re-derived the result on increments where the offending object never appears, then *strengthened* the proposition by dropping a hypothesis that turned out idle. **This is how a finding should be closed.**
- **The MAJ-3 re-trace found something real, and two of three items are correct.** Reporting that a critic's finding is *understated* — and being right about two thirds of it — is worth more than compliance.
- **The `cor:udep` quantifier paragraph is model discipline:** names the direction used, the direction that fails, why the contrapositive survives, and that an earlier version overstated.
- **F-21 remains the best self-catch in the project.**
- **`rem:ffcompare`'s closing synthesis is a genuine contribution, not a literature note** — naming the two asymmetries as running in *opposite* directions, meeting only because the recognisable completeness conditions are stated over a coarser class than the design's information, tells a reader where a future improvement would have to act. **The paragraph a referee will remember.**
