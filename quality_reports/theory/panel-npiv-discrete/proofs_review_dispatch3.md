# Theory Review — `panel-npiv-discrete`, Stage 3 dispatch 3 (all three rounds)

**Reviewer:** theorist-critic · **Severity:** HIGH · **Gate:** 80

> ## Provenance — read this first
>
> **These reports were never persisted when they were produced.** `theory_memo.md` sections D-000 and
> D-0000 dispose against them, but the files they cite did not exist on disk. They were **recovered
> verbatim on 2026-07-29 from the subagent transcripts** and assembled here in round order. Each round
> is reproduced exactly as the critic wrote it; nothing is summarised, paraphrased or reordered within
> a round. The transcript each round came from is named in its divider.
>
> **Round-numbering discrepancy, resolved.** The critic numbers its own rounds 1-2-3 within dispatch 3.
> The theorist's memo numbers rounds cumulatively across all dispatches, so memo section D-000 ("round 2",
> 65/100) is the critic's **Round 1**, and memo section D-0000 ("round 3", 58/100) is the critic's
> **Round 2**. Both scores match once the offset is applied.
>
> **The trajectory is 65 -> 58 -> 67, not 65 -> 58.** Round 3 exists, scores **67/100**, and states that
> the CRITICAL is genuinely closed with no new counterexample. **The theorist has not yet disposed
> against it**, and it carries an unactioned section titled *"The question for the user."*

| Round | Score | Gate | Disposed in memo | Transcript |
|---|---|---|---|---|
| 1 | 65/100 | fails | section D-000 (as "round 2") | `agent-a67b6d8ce7c529b0d.jsonl` |
| 2 | 58/100, one CRITICAL | fails | section D-0000 (as "round 3") | `agent-aaa4fe4bf2fb1adf1.jsonl` |
| 3 | **67/100, CRITICAL closed** | fails | **NOT YET DISPOSED** | `agent-aa1b466ce5fd0487b.jsonl` |

---


---

<!-- ===================== Round 1 · 65/100 · recovered verbatim from a67b6d8ce7c529b0d.output ===================== -->

# Theory Review — `panel-npiv-discrete`, Stage 3 dispatch 3 (Round 1)

**Reviewer:** theorist-critic · **Severity:** HIGH · **Gate:** 80
**Under review:** carried fixes R2-1/2/3 + eight minors; new `cor:elldiff` and Part F (`lem:solset`, `lem:secondord`, `prp:orthog`, `lem:balance`).

---

## (a) SCORE: **65 / 100 — DOES NOT CLEAR 80.** Do not dispatch the narrow critics yet.

| Phase | Verdict |
|---|---|
| 1. Claim identification | Clean. Part F is the Neyman-orthogonality layer for a three-nuisance moment; object types correct. |
| 2. Proof validity | **No CRITICAL.** `prp:orthog`(i)–(iii) are true as mathematics. **One unjustified interchange** (`cor:elldiff`), **one over-claimed scope** (`lem:secondord`(iii)). |
| 3. Assumptions / statements | **MAJOR ×5** — hypothesis omissions in `lem:solset` and `lem:balance`, an over-claim in `lem:solset`(iii), a rate condition priced on the wrong object, a vacuous "only if". |
| 4. Citations / linkage / polish | MAJOR ×1 (paper renderings carry four already-repaired defects); MINOR ×11. |

**Nothing here is fatal.** Every finding is a one-clause or one-quantifier repair, and the architecture of the round — especially the R2-3 replacement — is right. But eight MAJORs on first contact with new material is what the arithmetic gives, and the project's own round-1 history (54, 56) makes 65 a comparatively good first cut, not a bad one.

---

## Carried fixes — verdicts

**R2-1 — DISCHARGED.** `theory_memo.md:443` now states the correct attribution (`cor:rangegap` is *not* independent of the B1(iv.a) strengthening; roll it back and the corollary "ceases to have a subject"). The self-diagnosis — *"I generalised from a verified two-item re-trace to a third item I had not re-traced"* — is the right mechanism and worth recording as a discipline point: an escalation row is a claim.

**R2-2 — DISCHARGED in the source of record, NOT in the paper rendering.** `proofs.tex:1181–1199` now routes through Step 0 of `prp:nophifree` for $\nu_{g_\Xi}/\pi\in L^2(\pi)$ and spells the projection out via `lem:nusigma`(iv). Verified line by line, including that $\int(\nu_{g_\Xi}/\pi)\pi\,dx=\int\nu_{g_\Xi}\,dx=0$ puts the representer in $\mathcal V$ so the projection is the identity. **`paper/sections/theorems/lem-adjoint.tex:286–287` still carries the uncorrected version** — see M-7.

**R2-3 — the refusal is right, and for a stronger reason than the one given; the replacement is architecturally right and has one execution defect.**

The theorist declined my B1(v) framing on the ground that differentiability is a property of the *selected solution*. That is correct. It is also **technically forced**, and the theorist's own F-21 supplies the reason: since $\partial_u\lambda=\varpi_u\ell^\Pi$, recovering $\partial_u\ell^\Pi$ from a clause on $\partial_u^2\lambda$ requires dividing by $\varpi_u$ — and F-21 established that B1(iv.a)'s pointwise positivity gives $\varpi_u$ **no positive infimum on a compact set**. So a second-derivative clause on $\lambda$ could not have delivered $\partial_u\ell^\Pi$ at all. The refusal is not a preference; the alternative I proposed does not work. **Second time the theorist has declined my repair in favour of a better one; second time it was right.**

Moving A2′(i) onto $\ell^\Pi_\star$ as (i.a)/(i.b) and *deriving* `eq:Wderiv` and both sup-norms in `cor:elldiff` is the correct architecture. The $\partial_u\lambda=\varpi_u\ell^\Pi$ statement does protect C13. **But (i.b) as written does not license the interchange it is advertised to license** — M-1 below.

**R2-10 — the sharpening is correct.** $\Delta U(\theta,\varphi)=\Delta Y-\Delta\varphi-\Delta Z'\theta$ is affine in $\varphi$; with $g$ free of $\varphi$, $E[\psi]=E[g\Delta Y_\theta]-\int\nu_g\varphi\,dx$ is affine on $\mathcal V$, so orders $\ge2$ vanish unconditionally and (a)–(c) add only the first-order vanishing. Verified.

**Eight minors:** R2-4 (`results.tex:884–886`, $\mathcal C_0$ defined), R2-5 (`results.tex:804–809`, injectivity replaced by the compact-range-closed-iff-finite-rank argument), R2-6 (`results.tex:821–837`, verbatim in FF notation with the binary-instrument difference flagged), R2-7 (`results.tex:861`, clause 3 at $\varphi=0$), R2-8 (`proofs.tex:1112–1126`, Step 4 run unconditionally) — **all applied.** R2-11 is applied except one sub-item (see m-10).

---

## (b) What the L-21 ordering gap costs Part F

**Part F is sound *conditional* on A2′(i.a)/(i.b), and nothing in it needs L-21's content — only its conclusion.** L-21 is a source condition of index $\mu''$ on $\ell^\Pi_\star$ plus a Sobolev embedding; no statement or proof in Part F references $\mu''$, the embedding, or any scale for $\ell^\Pi$. There is also **no circularity**: L-21's argument runs inside the range space and cannot consume `lem:secondord` or `prp:orthog`. So discharging L-21 later does complete Part F. That is the good news, and it means the theorist was right to deliver Step 5 and escalate rather than reorder silently.

**Three qualifications, one of which is a plan consequence and matters more than the ordering itself.**

1. **The undischarged primitive is load-bearing in more places than §D5 item 2 records.** It is consumed by `cor:elldiff` (directly), `lem:secondord`(i) (existence *and* $\|\partial_u\ell_\star\|_\infty$ in Step 1's envelope), `lem:secondord`(iv) ($\|\ell_\star\|_\infty$), `lem:solset`(ii)–(iii), and `prp:orthog`(i) (`eq:gproviso` needs $\|\ell_\star\|_\infty<\infty$). **Four of the five Part F results are conditional on it. `prp:orthog`(ii) is the only unconditional statement in the part.**

2. **L-21's target is currently mis-specified, and the mis-specification is exactly M-1.** Memo §D5 item 2 says L-21 "need only deliver a sup-in-$u$, $L^1(\bar w\Pi_t)$-in-$t$ bound on $\ell^\Pi$". That is the $\sup_u\int$ form — which is what A2′(i.b) states and what **does not dominate**. Step 4 must aim at $\int_{\mathcal T}\sup_u|\partial_u\ell^\Pi_\star(u,t)|\,\bar w(t)\,\Pi_t(dt)<\infty$ (or a local uniform-integrability variant). This **raises** what L-21 has to prove. Fixing it before Step 4 runs is cheap; discovering it during Step 4 is not.

3. **On N-20 itself:** the theorist's dichotomy is right and the answer is its branch (b) — Step 4 should run before Step 5's results are relied on downstream — but only because of (2). Absent the quantifier defect, the ordering would be a pure deferral and branch (a) would have been defensible.

**Net:** the ordering gap costs **scope, not soundness**, plus one mis-specified plan target. It does not account for the score.

---

## (c) N-18 — ADJUDICATED: **UPHELD**, with two scope corrections

Both halves check out.

**(a) The sieve route does need a Sobolev bound on the iterate — confirmed.** `proofs.tex:1369–1378` applies $\|(I-P_{L_x})\zeta\|\le CL_x^{-s}\|\zeta\|_{H^s}$ at $\zeta=h=\hat\varphi-\vdagger$, and `lem:balance`(iii) carries "$\|h\|_{H^s}=O_P(1)$" as an explicit hypothesis. $h$ is a Landweber–Fridman iterate; H1 puts $\vdagger$ in a Sobolev ball of order $s$, which says nothing about the iterate's $H^s$ norm without a uniform stability result. **§3.7's "no unproven inputs beyond standard sieve approximation" for option (i) is wrong**, and the theorist stating the bound as a visible hypothesis rather than absorbing it is the right response.

**(b) The rate route needs no sieve condition — confirmed, and it is stronger than claimed.** Step 3 uses only $\|(I-P_{L_x})h\|\le\|h\|$ and $\|P_{L_x}h\|\le\|h\|$, which hold for *any* closed subspace. In fact the decomposition `eq:balance3` is unnecessary on that route: $|\langle\nu_g/\pi,h\rangle|\le\|\nu_g/\pi\|\,\|h\|$ directly.

**Correction 1 — the block-level inference is not "A5(iv) is a condition the block does not need."** A5(iv) is consumed independently by `lem:secondord`(iv): the $(\varphi,L)$ cross term is $O_P(\delta_n\epsilon_n)$ and needs $\delta_n\epsilon_n=o_P(n^{-1/2})$ whichever first-order route is taken. **A5(iv) cannot leave the block.** The theorist's own phrasing is correctly scoped ("alternative sufficient conditions **for the first-order bias**"); the inference to draw at block level is narrower.

**Correction 2 — the real prize is A8's lower end, and it is a smoothness-budget item.** What the rate route removes is $L_x\gg n^{1/(2s)}$, and with it the **"Sieve window non-empty: $s>1$ (splines); $s>3/2$ (polynomials)"** row of the smoothness-budget table at `assumptions.tex:1080`. Since $s$ is contested against A2, H1 and A5(iii), that row becoming route-conditional is the substantive gain. A8's upper end ($L_x\ll n^{1/2}$) survives in both routes as the conditioning constraint, exactly as the theorist says.

**Caveat, and it is M-6:** the rate route is not free of unproven inputs either — Step 3 silently uses $\|(\hat\nu_g-\nu_g)/\pi\|=O_P(n^{-1/2})$, which nothing supplies. §3.7's corrected option table should show that input on the rate side.

**The sieve window itself verifies.** $n^{1/(2s)}\ll L_x\ll n^{1/2}$ is non-empty iff $1/(2s)<1/2$ iff $s>1$; $L_x\ll n^{1/3}$ gives $s>3/2$. The basis-dependent exponents ($\zeta_K\asymp\sqrt K$ for splines, $\asymp K$ for polynomials) are the standard ones. §19.1's owed item is discharged correctly — but uncited (m-5).

---

## (d) Deduction table

| ID | Finding | Sev | Δ |
|---|---|---|---|
| **M-1** | **`cor:elldiff`'s dominating function is one quantifier short.** `proofs.tex:1156–1159` bounds the integrand by $\lvert\partial_u\ell^\Pi_\star(u,t)\rvert\bar w(t)$ — a function of $u$ — and calls it "the dominating function", supplied by A2′(i.b). A2′(i.b) (`assumptions.tex:498–500`) gives $\sup_u\!\int\!(\cdot)\,d\Pi_t<\infty$; Leibniz needs $\int\!\sup_u(\cdot)\,d\Pi_t<\infty$, or local uniform integrability. $L^1$-boundedness in $u$ is not UI. **Two repairs, both checked:** (α) move the sup inside — strictly stronger, implies (i.a) and every printed conclusion; (β) keep (i.b) and weaken the conclusion — Fubini + FTC give $u\mapsto\int\ell^\Pi_\star w\,d\Pi_t$ Lipschitz with constant $\Lambda^{(1)}_\star$ and `eq:Wderiv` for a.e. $u$, not "continuously differentiable" pointwise. **Also mis-specifies L-21's target.** | MAJOR | −4 |
| **M-2** | **`lem:solset` consumes A2′ without assuming it.** Hypotheses are A1, A2, N1, C1(ii) (`results.tex:1046`). Part (ii) asserts `prp:orthog`(i)–(iii), whose hypothesis block contains A2′; part (iii)'s proof cites `cor:elldiff` "under A2′(i)" (`proofs.tex:1246`). Fixed by adding A2′ and defining "admissible selection" as a solution satisfying A2′(i) — which closes m-9 too. | MAJOR | −2.5 |
| **M-3** | **`lem:solset`(iii) over-claims the dependence.** "*the second-order form of `lem:secondord`(i) depends on the selection only through $\mathcal S\ell_\star=\sigma_q$*" (`results.tex:1054–1056`). It does not: the form is $\int\sigma_qh^2dx-2\langle\mathcal Kh,h\rangle$ and $\mathcal K$'s kernel $q\,f_{X_1,X_2}$ is a *bivariate* object not determined by its marginalisation $\sigma_q$. **The proof says the right thing** — "the two objects $q$ and $\sigma_q$" (`proofs.tex:1244`) — and the glossary already writes $\mathcal B_{\rm sym}=\sigma_q\cdot-2\tilde{\mathcal K}$. **Bears directly on `prp:sharpquad`'s constant at Step 4, and the memo (§D-00) repeats the compressed version.** The mean-zero claim itself is correct: `lem:nusigma`(iv)+(v) with $g=\widetilde W\partial_u\ell_\star$ give $E[g]=0$ under A1 and hence $\int\sigma_q\,dx=0$ — verified. | MAJOR | −3.5 |
| **M-4** | **`lem:secondord`(iii)'s "$\equiv0$" holds only at $\tau_1=0$.** The cross-partial of the integrand is $-r(\Delta Z)D(\Delta U-\tau_1\Delta h,\Delta Z)$; the hypothesis is $E[D(\Delta U,\Delta Z)\mid\Delta Z]=0$, at the **true** residual. For $\tau_1\ne0$, $E[D(\Delta U-\tau_1\Delta h,\Delta Z)\mid\Delta Z]\ne0$ and the term is a product bound, not zero. Part (ii) explicitly and *correctly* claims "identically in $\tau$, not merely at $\tau=0$"; (iii) reuses the symbol on a weaker fact, and `proofs.tex:1286–1287` establishes only $\tau_1=0$. **Consequential:** any Taylor remainder taken along the path at Step 6/7 would inherit the false version. | MAJOR | −3 |
| **M-5** | **A5(iv) prices the wrong object, and both consumers need the other one.** A5(iv) (`assumptions.tex:756–757`) and the glossary (`:198`) define $\epsilon_n$ by $\lVert\hat L-L_\star\rVert_{L^2}$. `lem:balance`(i)–(ii) consume $\lVert\hat\ell-\ell_\star\rVert_{L^2(P)}$ (`proofs.tex:1355`, `:1363`) and `lem:secondord`(iv) consumes $\lVert\partial_uD\rVert_{L^2(P)}$ (`proofs.tex:1297`). $\ell=\partial_uL$: an $L^2$ rate for a function does not transfer to its derivative. Either restate A5(iv) on $\partial_u(\hat L-L_\star)$ or introduce a second rate. | MAJOR | −3.5 |
| **M-6** | **`lem:balance`(ii)–(iii) consume rate conditions on $\hat\nu_g$ that neither the statements nor the block supplies.** Step 3 uses $\lVert(\hat\nu_g-\nu_g)/\pi\rVert=O_P(n^{-1/2})$ (`proofs.tex:1363`) — unsourced; it is not recoverable from the stated hypothesis (I)$=O_P(n^{-1/2}\delta_n)$, since $O_P$ products do not divide. Step 4 uses $\lVert\hat\nu_g/\pi\rVert=O_P(1)$ **and** (I)$=O_P(n^{-1/2}\delta_n)$ (`proofs.tex:1374–1375`), neither of which appears in (iii)'s statement. | MAJOR | −3 |
| **M-7** | **The paper renderings are not a coverage lag — they carry four already-scored, already-repaired defects.** `paper/sections/theorems/lem-adjoint.tex` declares itself derived from "Source of record: .../{results,proofs}.tex" and still contains: **R2-2** at `:286–287` (Riesz representer identified as $\nu_{g_\Xi}/\pi$ with no $L^2(\pi)$ membership established); **R2-3** at `:336` (`eq:Wderiv` justified "wherever $\partial_u\ell$ exists and **B1(v)'s dominating function applies**" — the exact citation R2-3 refuted); **R2-5** at `:325–326` ("an ***injective*** compact operator of infinite rank has non-closed range", against a non-injective $\mathcal A^\ast_{\rm cond}$); **R2-6** at `:340–346` (FF Prop. 2.1 translated to $X_1,X_2,x$ while keeping their $\psi$, with a $d\omega$ integral presupposing a non-binary instrument). Same `\label` keys, materially different content, and the paper compiles the defective one. The theorist described this as label coverage; it is content divergence. | MAJOR | −4 |
| **M-8** | **`prp:orthog`(iii)'s "only if" is vacuous under its own hypothesis block.** N1 is listed at `results.tex:1086`; (iii) then concludes exactness "if and only if $E[L_\star\mid\Delta Z]=0$ a.s., **which is N1**". Assuming N1 makes the right side true and the equivalence "true iff true". The equivalence is genuine, is proved, and is the paper's justification for demoting the propensity — it just cannot be read off the proposition as printed. Drop N1 from (iii)'s hypotheses; the proof (`proofs.tex:1333–1339`) never uses it. Same species as the `lem:shiftinv` split the theorist performed itself. | MAJOR | −2.5 |
| **m-1** | `prp:orthog`(ii) Step: $E[\widetilde WD\mid\Delta Z]=E[\widetilde W\mid\Delta Z]E[D\mid\Delta Z]$ presupposes $E[\lvert D\rvert\mid\Delta Z]<\infty$, which $E\lvert\widetilde WD\rvert<\infty$ does not give without A4(i) ($\lvert\widetilde W\rvert\ge\varepsilon_\varrho$). The **conclusion survives** — on $\{\varrho(1-\varrho)=0\}$, $\widetilde W=0$ a.s. — but the displayed factorisation does not hold there. One line. | MINOR | −1 |
| **m-2** | "take $r=\operatorname{sign}(E[L_\star\mid\Delta Z])$ **coordinatewise**" (`proofs.tex:1338–1339`) is ill-typed: $r$ perturbs the *scalar* $\varrho$, while $L_\star$ is $\IR^p$-valued per F-15. The construction must run one coordinate of $L_\star$ at a time with $p$ scalar $r$'s. Conclusion unaffected. | MINOR | −0.75 |
| **m-3** | (iii)'s "only if" perturbs $\varrho\to\varrho+\tau_3r$ with $r$ merely bounded; under A4(i) this stays a propensity for $\lvert\tau_3\rvert\le\varepsilon_\varrho/\lVert r\rVert_\infty$, but A4(i) is not in the hypothesis block. Either say the $\varrho$-slot is unconstrained or cite A4(i) — otherwise the direction may be inadmissible for a realistic nuisance set. | MINOR | −0.75 |
| **m-4** | `lem:secondord`(iv) states $\partial^2_{\tau_1\tau_2}m(0)=-E[\widetilde W\partial_uD\,\Delta h]$, but $D$'s differentiability in $u$ is nowhere a hypothesis (only $E[D\mid\Delta Z]=0$, and $E\lvert\widetilde WD\rvert<\infty$ in `prp:orthog`(ii)). | MINOR | −1 |
| **m-5** | "standard spline approximation" and the basis-dependent conditioning exponents are invoked with no citation (Newey 1997; Belloni–Chernozhukov–Chetverikov–Kato for $\zeta_K$; Schumaker / DeVore–Lorentz for the approximation bound). The $L^2(dx)\to L^2(\pi)$ transfer of the approximation bound runs through C1(ii) and is unstated. | MINOR | −1 |
| **m-6** | "Term (II) is bounded by (III) via the same projection contraction" (`proofs.tex:1366`) is not literally true — (II) carries $\lVert P_{L_x}h\rVert$, (III) carries $\lVert(I-P_{L_x})h\rVert$. Both are bounded by $\lVert\hat\nu_g/\pi\rVert\lVert h\rVert$, which is what the argument needs. | MINOR | −0.5 |
| **m-7** | Notation: `lem:secondord`(i) names the integral operator $\mathcal K$, but the glossary (`:183`) reserves $\mathcal K,\tilde{\mathcal K}$ for Step 4 and writes this very form as $\sigma_q\cdot-2\tilde{\mathcal K}$; $\mathcal K$ was separately reserved at M-9 for `prp:compact`'s HS operator. $\mathcal S$ is introduced at `results.tex:1054` and is absent from the glossary. | MINOR | −1 |
| **m-8** | C2′(i) is listed on `lem:secondord` and `prp:orthog` and appears to be consumed by neither: Step 1's envelopes are $\lvert\widetilde W\rvert\le1$ (P1), the two $\ell_\star$ sup-norms (`cor:elldiff`), boundedness of $r$, A1b(iv) and `lem:nusigma`(i). Flagged rather than asserted — route to the assumption-auditor. | MINOR | −1 |
| **m-9** | "for every **admissible** selection" (`results.tex:1056`) — undefined qualifier; from the proof it means "satisfying A2′(i)". Same species as R2-4's $\tilde c$, one level up. Closed by M-2's repair. | MINOR | −0.5 |
| **m-10** | Bookkeeping bundle: `proofs.tex:1463` still reads "WHAT IS NOT PROVED HERE, deliberately: `prp:sharpquad`, **`prp:orthog`**, …" — the R2-11 stale-exclusion species, fixed in `results.tex:19–22` and not here. R2-11's `eq:adjointdisplay` bracketing is **recorded as applied in the memo but is not**: `results.tex:574` still writes $\nu_{\widetilde W\,\mathcal W\ell}$ against `eq:adjclosed`'s $\nu_{\widetilde W(\mathcal W\ell)}$. `lem-adjoint.tex:21–23`'s own rendered-set list omits `cor:rangegap`, `rem:adjointreconcile`, `rem:ffcompare`, which are in the file. | MINOR | −1 |
| **m-11** | `lem:solset`(ii): the N1 re-centring leaves $E[\psi]$ unchanged "by (P3) **and A1**" (`proofs.tex:1240`). (P3) alone suffices — $c$ is $\sigma(\Delta Z)$-measurable, so $E[\widetilde Wc]=E[c\,E[\widetilde W\mid\Delta Z]]=0$. | MINOR | −0.25 |
| | | **Total** | **−34.75** |

**Score 65/100.** Below the 80 gate. **M-1, M-3, M-4, M-5 are the four that must move.** M-7 is mechanical and blocks the narrow-critic sweep.

---

## What is right, and should not be touched

- **`prp:orthog`(i) verifies completely.** $\partial_{\tau_1}m(0)=-E[(\Delta Z+\widetilde W\ell_\star)\Delta h]=-\langle\nu_g/\pi,h\rangle$ via (P5); vanishing on $\mathcal V$ with $\nu_g/\pi\in\mathcal V$ gives $\nu_g\equiv0$; linearity of $g\mapsto\nu_g$ plus `lem:adjoint`(iii) closes `eq:orthphi`. The $\nu/\pi$ referent is right and is the one FF Prop. 2.1 anchors.
- **`prp:orthog`(ii) is correct, and the claim "A1 and (P3) alone — no N1, no rate" is exactly right.** Conditional independence factorises $\widetilde W$ against $D$ given $\Delta Z$; $E[\widetilde W\mid\Delta Z]=0$ kills it; $\psi$ is linear in $L$, so the statement is exact for every $\tau_2$, not first-order. That the pure-$L$ direction is exact while the $(\varphi,L)$ cross term is not is stated correctly and not conflated.
- **`lem:solset`(iii)'s mean-zero claim is correct and is the right thing to have isolated.** $\int\sigma_q\,dx=2E[\widetilde W\partial_u\ell_\star]=0$ under A1 — free for every selection. "The selection can move the shape of $\sigma_q$ but never its mean" survives. It is only the *dependence* claim around it that over-reaches.
- **N-18 is a real finding, correctly scoped, and correctly declined-to-apply** (memo write scope). Naming (b) as "the anticipated refinement arriving, not a new problem", and pointing at A8's own comment as the anticipation, is exactly how a memo mis-pricing should be reported.
- **N-20 was escalated rather than silently reordered.** Given that L-21 is now the route to (i.a)/(i.b) — the theorist's own round-4 restatement created that dependence — flagging it instead of absorbing it is the right call, and my dispatch was the error.

---

## Priming for the narrow critics — **hold the sweep until M-7 closes**

Running the sweep now over `dispatch-2 + Part F` will read two renderings of the same labels that disagree on R2-2/3/5/6. The notation-warden and assumption-auditor will report against `paper/sections/theorems/lem-adjoint.tex` findings already closed in `results.tex`, and the reports will contradict each other. **Resync `paper/sections/theorems/` first, then sweep.** When it runs:

- **counterexample-hunter.** (1) $\ell^\Pi_\star$ with $\sup_u\int\lvert\partial_u\ell^\Pi_\star\rvert\bar w\,d\Pi_t<\infty$ but no $u$-free integrable envelope — turns M-1 from "wrong justification" into "`eq:Wderiv` fails for an admissible design". (2) $q\not\equiv0$ with $\sigma_q\equiv0$, or two selections with the same $\sigma_q$ and different $\langle\mathcal Kh,h\rangle$ — settles M-3 by example and prices `prp:sharpquad`'s exposure. (3) $D$ with $E[D(\Delta U,\Delta Z)\mid\Delta Z]=0$ but $E[D(\Delta U-c,\Delta Z)\mid\Delta Z]\ne0$ — M-4. (4) $\varrho$ hitting $\{0,1\}$ on a positive-measure set, against `prp:orthog`(ii)'s factorisation (m-1) and (iii)'s admissible directions (m-3). (5) Carried: $p_X\ne\varrho$; A1c holding while A1b(iii) fails; $\mathcal N_0$ with $-\nu\in\overline{\mathcal N_0}\setminus\mathcal N_0$. (6) Do **not** re-probe $w=\cos$.
- **regularity-checker.** (1) `cor:elldiff`'s differentiation under $\Pi_t$ — **M-1, the headline item.** (2) `lem:secondord` Step 1's two differentiations under $E$, uniformly in $\tau$ in a neighbourhood, and the unstated $\partial_uD$ (m-4). (3) `lem:balance` Step 4's spline bound and the $L^2(dx)\to L^2(\pi)$ transfer (m-5). (4) Carried from dispatch 2: (P7a) with a random $\zeta$ at `lem:adjoint` Step 3; `cor:udep` Step 1's FTC. (5) A1c's equivalence comment is now stale — `prp:kerchar` proves the passage it calls unavailable.
- **assumption-auditor.** M-2 (A2′ unlisted on `lem:solset`), M-5 (A5(iv)'s object), M-6 (`lem:balance`'s unstated $\hat\nu_g$ inputs), M-8 (N1 hollowing out `prp:orthog`(iii)), m-8 (C2′(i) apparently idle in both Part F propositions), m-3 (A4(i)). Also: **N-18's block consequence** — record A5(iv) and A8 as alternatives *for the first-order bias*, and mark A8's lower end and the "$s>1$" budget row as route-conditional while noting A5(iv) survives via `lem:secondord`(iv).
- **notation-warden.** m-7 ($\mathcal K$ vs $\tilde{\mathcal K}$; $\mathcal S$ absent from the glossary), m-2 ($r$'s type), m-10 (`eq:adjointdisplay` bracketing recorded-but-unapplied; `proofs.tex:1463`; `lem-adjoint.tex`'s header list), plus a full label-for-label diff of `results.tex`/`proofs.tex` against `paper/sections/theorems/` once M-7 closes.
- **derivation-verifier (advisory).** Six MATCH accepted, not scored. Two new specs worth writing: the $\tau_1\ne0$ cross-partial $-E[r\,D(\Delta U-\tau_1\Delta h,\Delta Z)]$ in the two-point model (**M-4**), and the two-selection $\sigma_q$-identical / $\mathcal K$-different construction (**M-3**).

---

**Files read:** `/Users/samuele/Documents/github_repo/clo-econometrics-author/quality_reports/theory/panel-npiv-discrete/{results.tex,proofs.tex,assumptions.tex,theory_memo.md,notation_glossary.md,proofs_review_dispatch2.md}`; `/Users/samuele/Documents/github_repo/clo-econometrics-author/paper/sections/theorems/lem-adjoint.tex`.


---

<!-- ===================== Round 2 · 58/100 — one CRITICAL · recovered verbatim from aaa4fe4bf2fb1adf1.output ===================== -->

# Theorist-Critic Report — Stage 3, dispatch 3, round 2

**Target:** `panel-npiv-discrete` — Part E/F of `results.tex`/`proofs.tex`, `assumptions.tex`, `notation_glossary.md`, `paper/sections/theorems/lem-adjoint.tex`
**Severity:** HIGH · **Gate:** 80

---

## (a) Score: **58/100 — DOES NOT CLEAR**

The eight round-1 MAJORs are genuinely discharged; I re-verified each and found no cosmetic patching. The score falls rather than rises because **two of the repairs introduced defects in the objects they touched**, one of which I can refute with an explicit counterexample. That is the honest reading of the movement: round 1 could not have found either defect, because neither clause existed before this round wrote it.

No proof in Part E or Part F is structurally broken. `prp:orthog`, `lem:secondord`(i)–(ii),(iv), `lem:solset`(i)–(ii), `lem:balance`(i),(iii), `lem:adjoint`, `cor:elldiff`, `cor:rangegap`, `prp:kerchar`, `cor:a1cprim`, `prp:nophifree` and `cor:udep` all verify as written.

---

## CRITICAL-1 — `lem:secondord`(iii)'s off-$\tau_1$ bound is false; I have a counterexample

`results.tex:1077-1079` (and `proofs.tex:1315-1316`) prints:

> away from $\tau_1=0$ the cross-partial is $-E[r(\Delta Z)D(\Delta U-\tau_1\Delta h,\Delta Z)]$, which need not vanish and **is bounded in modulus by $\|r\|_\infty\,\|D\|_{L^{2}(P)}$**.

The proof asserts this with no argument. It fails for exactly the reason M-4 correctly identified two sentences earlier: $\|D\|_{L^2(P)}$ is the norm at the **true** law of $(\Delta U,\Delta Z)$, while the term evaluates $D$ at the **shifted** point $\Delta U-\tau_1\Delta h$. The repair caught the asymmetry in the vanishing claim and then reproduced it in the replacement bound.

**Counterexample.** $\Delta Z$ degenerate, $r\equiv1$, $\tau_1=1$. Let $\Delta U$ have a bounded density supported on $[0,1]$ (permitted — C2′(i) bounds the conditional density and imposes no support condition). Let $h\in\mathcal V$ be such that $\Delta h=-1$ on an event $A$ with $P(A)=\tfrac12$. Take $D(u,z)=M\,\mathbb 1\{u\in[1,2]\}$ (mollify if you want $D$ smooth). Then

- $D(\Delta U,\Delta Z)=0$ a.s., so $E[D\mid\Delta Z]=0$ ✓ and $\|D\|_{L^2(P)}=0$;
- $E[r\,D(\Delta U-\tau_1\Delta h,\Delta Z)]=M\,P(\Delta U+1\in[1,2],A)=M/2$, arbitrarily large.

$D$ satisfies every hypothesis (iii) imposes — clause (iii) requires only $E[D\mid\Delta Z]=0$; $\partial_uD$ is required by (iv), not (iii). The printed bound therefore fails by an unbounded margin.

This is a confirmed counterexample to a printed clause, so it would block the `quality.md` §4 binary gate at the counterexample-hunter step regardless of the aggregate. The fix is one line — drop the bound, or price it as $\sup_{|\tau_1|\le\bar\tau}\|D(\cdot-\tau_1\Delta h,\cdot)\|_{L^2}$, or add the density-ratio condition that makes the shifted and true laws comparable. **Deduction: −10.**

---

## (b) Is the M-7 resync complete?

**Mathematically yes; at the metadata layer no.** All four named defects are verifiably gone from `paper/sections/theorems/lem-adjoint.tex`:

| Defect | Verdict | Evidence |
|---|---|---|
| R2-2 Riesz representer | **GONE** | `:316-318` — "so Step~0 of the proof of `prp:nophifree` applies verbatim and gives $\nu_{g_\Xi}/\pi\in L^{2}(\pi)$ — which must be established before the inner product below can be written" |
| R2-3 `eq:Wderiv` | **GONE** | `eq:Wderiv` now sits inside `cor:elldiff` at `:268`; the refuted B1(v) citation is absent; `:285-288` carries the sup-inside justification, so **M-1 propagated to the paper file** |
| R2-5 injectivity | **GONE** | `:362-367` — compact ⟹ closed range iff finite-dimensional, H1's infinite-rank clause excludes it. Correct (Schauder + rank$(A^*)=$rank$(A)$) |
| R2-6 FF display | **GONE** | `:376-400` — verbatim in $Z_1,Z_2,z,w,\psi$, translation adjacent, binary-instrument two-point sum flagged |

**Label-for-label diff against `results.tex`/`proofs.tex`: clean.** Every `\label` in `lem-adjoint.tex` has a same-named twin (`eq:Wpointwise`, `eq:adjstep`, `eq:kerfam` live in `proofs.tex`; the rest in `results.tex`). Statement hypotheses match one-for-one across both renderings. No orphan, no collision, no divergence in mathematical content.

**But the header — which is the anti-drift device — is wrong in five ways** (see MAJOR-6). A sweep run against this file will read a self-description that under-declares what the file contains and mis-states what it consumes. Fix the header first; it is a ten-minute correction, not a re-derivation.

---

## (c) Did any repair introduce a new defect? **Yes — two.**

### MAJOR-1 — M-3 conjugated one term of $\mathcal B_{\rm sym}$ and not the other (−7)

The framing you asked me to check is **right in kind and wrong in typing**, and the typing error is exactly the object Step 4 will build `prp:sharpquad` on.

`lem:secondord`(i) gives the form with the **Lebesgue** pairing: $\int_{\mathcal X}\sigma_q h^{2}dx-2\langle\mathcal Kh,h\rangle_{L^{2}(dx)}$. `notation_glossary.md:185` declares $\mathcal B_{\rm sym}$ an **operator on $L^2(\pi)$**, and `:183` says $\tilde{\mathcal K}$ is "its $L^{2}(\pi)$ conjugate". So the compact part *is* conjugated. The multiplication part is not. On $L^2(\pi)$, $\langle Mh,h\rangle_{L^2(\pi)}=\int Mh^2\pi\,dx$, so matching $\int\sigma_qh^2dx$ requires $M=\sigma_q/\pi$:

$$\mathcal B_{\rm sym}^{\,L^2(\pi)}=\underbrace{(\sigma_q/\pi)\cdot{}}_{\text{not }\sigma_q\cdot}-\,2\tilde{\mathcal K}.$$

The pre-M-3 $\|\sigma_q/\pi\|_\infty$ was the *correct* $L^2(\pi)$ multiplication norm; M-3's rewrite dropped the $\pi^{-1}$ while keeping the space. Three limbs:

1. **The $\pi$-weighting.** As printed, $\mathcal B_{\rm sym}$ is correct only on $L^2(dx)$ — but $\delta_n$ is priced in $L^2(\pi)$ by A5(ii), so $L^2(\pi)$ is the operative space.
2. **Nothing symmetrises.** The tilde does conjugation, not symmetrisation. $\tilde{\mathcal K}=\pi^{-1}\mathcal K$ is self-adjoint on $L^2(\pi)$ only if $q\,f_{X_1,X_2}$ is a symmetric kernel, which neither $q$ nor $f_{X_1,X_2}$ is. So $\mathcal B_{\rm sym}$ is not self-adjoint despite its name, and $\tfrac12\|\mathcal B_{\rm sym}\|$ is an **upper bound, not the sharp constant** — for real $B$, $\sup_{\|h\|=1}|\langle Bh,h\rangle|=\|(B+B^*)/2\|\le\|B\|$, generally strict.
3. **$\sigma_q$ is $\IR^p$-valued** (C18), so "operator on $L^2(\pi)$" is $p$ operators. `notation_glossary.md` §8.4 item 2 already flags this as "Binding on the Step-4 dispatch" and resolves it in the direction form — but with the refuted constant (below).

The rest of the M-3 framing is right: $\sigma_q$ *is* only the multiplication part; a compact perturbation *does* leave the essential spectrum alone (Weyl), so "$\sigma_q$ governs the essential spectrum" is correct once the multiplication part is $\sigma_q/\pi$.

### MAJOR-2 — the `solset-sigmaq-not-sufficient` spec is aimed at the wrong claim (−3)

Same root cause. The spec (`scripts/symbolic/specs/solset-sigmaq-not-sufficient.yaml`) takes $f_{ab}\equiv1$ and

$$q=\begin{pmatrix}0&c\\-c&0\end{pmatrix},\qquad q'=\begin{pmatrix}0&-c\\c&0\end{pmatrix}.$$

Both are **anti-symmetric**, and $f$ is symmetric, so the kernels $qf$ and $q'f$ are anti-symmetric — whence $\langle\mathcal Kh,h\rangle=\sum_{a,b}q_{ab}h_ah_b=0$ for *both*. The two selections therefore give the **identical quadratic form** (identically zero). The spec MATCHes, but it witnesses only that $q\mapsto\sigma_q$ is non-injective, which is trivial and is *not* what `lem:solset`(iii) needs. What is needed is that $\sigma_q\mapsto\mathcal B_{\rm sym}$ is non-injective, which requires differing **symmetric parts**.

The proof's own justifying sentence has the same gap: `proofs.tex:1256-1257` says "two selections may share $\sigma_q$ and differ in $\mathcal K$", when only the symmetrised part enters.

A correct witness is one line away: $q=\begin{pmatrix}-c&c\\c&-c\end{pmatrix}$ has $\sigma_q\equiv0$ (identical to $q'\equiv0$) yet $\langle\mathcal Kh,h\rangle=-c(h_1-h_2)^2\not\equiv0$. Please re-aim the spec; a passing spec pointed at the wrong claim is worse than no spec.

The **`secondord-crossterm-tau1`** spec, by contrast, is sound: I re-derived the expansion and $-rD(dU-t_1Dh)+rD(dU)=r\,t_1\,Dh\,(d_0+d_1dU-d_1t_1Dh/2)$ is exact. It witnesses M-4's *first* half (non-vanishing off $\tau_1=0$), at the integrand level. It does not touch the second half — which is the half that is false (CRITICAL-1).

---

## Verdicts on the remaining items you flagged

**M-1 (option α) — CORRECT, and more strongly so than the stated reason.**

- **(a) Does (α) imply the round-4 form with the same conclusions?** Yes. $\sup_u\int(\cdot)d\Pi_t\le\int\sup_u(\cdot)d\Pi_t$, so the round-4 clauses are implied and both printed bounds in `cor:elldiff` remain valid with the same symbols. One precision note: $\Lambda^{(0)}_\star,\Lambda^{(1)}_\star$ are *redefined*, so the constants are weakly larger numbers bearing the same names — "the same constants" is true of the symbols, not of the values. The sup-inside form is needed only for the Leibniz license, never for the bounds themselves.
- **(b) Is the random-evaluation argument correct?** Yes, and it understates its own case. The decisive fact is not named: **under (β), C2′(i) would have to be put back into `lem:secondord` and `prp:orthog`**, from which this same round removed it — an a.e.-in-$u$ identity evaluated at $\Delta U$ needs $\Delta U$ absolutely continuous, which is exactly what C2′(i) supplies. So (α) and the C2′(i) removal stand or fall together. Minor imprecision: `cor:udep` is named as one of the three consumers, but its use of $\partial_u\ell_\star$ is function-level ($\partial_u\ell_\star\equiv0\Rightarrow\ell_\star(u,z)=\tilde c(z)$), which (β)'s Lipschitz conclusion handles unaided. The three real consumers are `lem:secondord`(i), `lem:solset`(iii) via `lem:nusigma`(v), and $q$ in `rem:nophifree`(iv).
- **(c) Is L-21's target now the sup-inside form in both places?** Yes — `assumptions.tex:589-596` ("**L-21 MUST NOW DELIVER THE SUP-INSIDE FORM**") and `theory_memo.md:478-482`. The trap is closed.

**M-4 — the $\tau_1=0$ restriction is correct; the replacement bound is not.** See CRITICAL-1.

**M-5 — the cross-reference to `lem:levels`(iv) is apt, not decorative.** It is the same one-directional transfer (integration bounded, differentiation not), transposed from $x$ to $u$ and from the structural to the nuisance direction. One caveat worth a clause: `lem:levels`(iv)'s *constant* does not transfer — it depends on $\mathcal X$ compact and $\pi$ bounded below (C1(ii), A0), neither of which holds for $u\in\IR$. The comment claims only the direction, so it is safe as written.

**M-8 — confirmed on both counts, but the repair left a new idle clause.** `prp:orthog`(iii) is now non-vacuous: it does not presuppose N1, and the equivalence "exact propensity orthogonality $\Leftrightarrow$ N1" is the statement that licenses demoting $\varrho$ to a product-rate nuisance. The proof genuinely never used N1 — the $(\Leftarrow)$ direction is the tower property, the $(\Rightarrow)$ direction is the $p$ scalar sign perturbations, and A4(i) does the $[0,1]$-preservation work. **However**, the statement now reads "assume N1 for parts (i)–(ii) only", and neither (i) nor (ii) uses N1 either: (i) is (P5) + A1b(iv) + `cor:elldiff`; (ii) is A1 + (P3), and its own proof says so ("nothing about N1 or about the size of $D$"). N1 is idle in (i)–(ii). See m-1.

**M-2, M-6 and the eleven minors — all present and correct as described**, with the exceptions logged below. I verified specifically: `E[|D|\mid\Delta Z]<\infty` with the degenerate-region note; the $p$ scalar sign directions with the F-15 typing reason; A4(i) added to (iii); `\partial_uD` hypothesised in (iv); the "(II) bounded by (III)" correction; the $L^2(dx)\to L^2(\pi)$ transfer written out.

**C2′(i) removed from both Part F results — correct, and it is not consumed elsewhere unnoticed.** I traced every remaining consumer (`prp:frechet`, `prp:compact`, `lem:adjfubini`, `lem:adjoint`, `prp:kerchar`, `cor:a1cprim`) and each integrates out an indicator, which is what C2′(i) is for. The Part F $\tau_1$-derivatives differentiate $L_\star$ along its own argument, which `cor:elldiff` makes $C^1$ with bounded derivative under (α), so no residual density is needed. Removal is right.

**`eq:adjointdisplay` bracketing — applied this time.** `results.tex:572-576` now carries $\big(\mathcal A^\ast_{\mathrm{cond}}\ell\big)(x)$, matching `lem:adjoint`(i) at `:727`.

**N-18 — two of the three corrections land; the third is backwards.** A5(iv) staying is right (`lem:secondord`(iv) consumes it independently on either route). A8's lower end and the smoothness-budget row being the prize is right. But **the rate route does *not* consume `eq:nuhat`'s first half** — see MAJOR-4.

---

## (d) Deduction table

| ID | Sev | Finding | Location | Δ |
|---|---|---|---|---|
| **C-1** | CRITICAL | `lem:secondord`(iii)'s off-$\tau_1$ bound $\|r\|_\infty\|D\|_{L^2(P)}$ is false; explicit counterexample above. Introduced by the M-4 repair | `results.tex:1078-1079`; `proofs.tex:1315-1316` | −10 |
| **MAJ-1** | MAJOR | $\mathcal B_{\rm sym}$ mis-typed: multiplication part must be $\sigma_q/\pi$ on $L^2(\pi)$; nothing symmetrises, so $\tfrac12\|\mathcal B_{\rm sym}\|$ is an upper bound not a sharp constant; $\IR^p$-valued $\sigma_q$ unreconciled. Introduced by the M-3 repair | `results.tex:1058`; `proofs.tex:1258-1261`; `notation_glossary.md:183,185` | −7 |
| **MAJ-2** | MAJOR | `solset-sigmaq-not-sufficient` witnesses non-injectivity of $q\mapsto\sigma_q$ with an anti-symmetric $q$; both selections give the *identical* form. Certifies the wrong claim | `scripts/symbolic/specs/solset-sigmaq-not-sufficient.yaml` | −3 |
| **MAJ-3** | MAJOR | M-3 not propagated: two files still print the refuted $\tfrac12\|\sigma_q/\pi\|_\infty$ as `prp:sharpquad`'s sharp constant, one of them marked "**Binding on the Step-4 dispatch**" | `assumptions.tex:600-604`; `notation_glossary.md:288-292` | −3 |
| **MAJ-4** | MAJOR | `lem:balance`(ii) lists "the first half of `eq:nuhat`" as a hypothesis its own primary argument never uses (Step 3's direct bound is A5(ii)+A5(iv) only); the closing "the rate route is not input-free either" contradicts Step 3 two sentences above it | `results.tex:1141-1143`; `proofs.tex:1412-1425` | −3 |
| **MAJ-5** | MAJOR | M-5 not propagated: $\epsilon_n$ still glossed as $\|\hat L-L_\star\|$ — the object M-5 established no consumer uses. INV-7: the symbol in $\delta_n\epsilon_n=o_P(n^{-1/2})$ means two different things in two files | `notation_glossary.md:200` vs `assumptions.tex:781-783` | −3 |
| **MAJ-6** | MAJOR | `lem-adjoint.tex` header wrong in five ways: (a) "ALTERNATIVE RENDERING of" omits `cor:elldiff`, `cor:rangegap`, `rem:adjointreconcile`, `rem:ffcompare` — four of nine environments; (b) DEPENDENCIES omits `prp:wellposed` (cited `:197`) and `prp:nophifree`/`eq:gproviso` (cited `:316-317`); (c) declares `prp:frechet`, never cited; (d) conventions list omits (P3) (`:71`) and (P4c) (`:458`); (e) assumption tags scope A1/A1b to `prp:kerchar`/`cor:a1cprim` "only" — false, `lem:nusigma`(ii),(v) use them — and omit A0, A2′(i.a)–(i.b), H1 | `paper/sections/theorems/lem-adjoint.tex:10-19` | −3 |
| m-1 | MINOR | N1 idle in `prp:orthog`(i)–(ii); neither proof uses it. Created by the M-8 repair | `results.tex:1092` | −2 |
| m-2 | MINOR | Spline approximation bound quoted without a theorem-level pointer (author names only) | `proofs.tex:1429-1432, 1441-1447` | −2 |
| m-3 | MINOR | `lem:solset`(ii) says every member "gives a moment satisfying `prp:orthog`(i)–(iii)"; after M-8, (iii) is an equivalence, not an orthogonality assertion | `results.tex:1053` | −1 |
| m-4 | MINOR | $\tilde{\mathcal K}$ used in `results.tex` and `proofs.tex` but defined only in the glossary — define-before-use in the theorem artifacts | `results.tex:1058`; `proofs.tex:1258` | −1 |
| m-5 | MINOR | $L^2(dx)\to L^2(\pi)$ transfer over-charged: $P^\pi$ minimises over the same span, so $\|\pi\|_\infty^{1/2}$ alone suffices; the extra $(\|\pi\|_\infty\|1/\pi\|_\infty)^{1/2}$ is unnecessary | `proofs.tex:1432-1433` | −1 |
| m-6 | MINOR | `lem:solset` lists both A2 and A2′; A2′ contains A2 | `results.tex:1046` | −1 |
| m-7 | MINOR | M-1's rationale names `cor:udep` as a random-evaluation consumer; its use is function-level and (β) would suffice there. The decisive consumer (the C2′(i) removal) is unnamed | `assumptions.tex:581-587`; `theory_memo.md:22` | −1 |
| m-8 | MINOR | `rem:adjointreconcile`'s derivative clause is (iv′) in `results.tex` and (iii′) in `lem-adjoint.tex` | `results.tex:812` vs `lem-adjoint.tex:369` | −1 |
| | | **Total** | | **−42** |

**Score: 58/100.**

---

## The two open items you asked me to judge

**1. Three citations named but not cited — right call on process, wrong stopping point on one of them.**

Routing to the librarian is correct: the theorist cannot verify `.bib` scope, and naming beats citing on faith. Two of the three are not load-bearing for anything proved in this dispatch — **Newey (1997)** and **BCCK for $\zeta_K$** support A8's *upper* end, which enters `lem:balance` only through the window-non-emptiness discussion, not through any proof step. Those can wait for the librarian.

**The spline approximation bound cannot.** It is the *entire* content of `lem:balance`(iii)'s Step 4 — without it, route (iii) is unproved, and (iii) is one of the two independent routes N-18 is built on. A bare author surname is not a citation a referee can check. The bound as stated is correct and standard (order $>s$ B-splines, quasi-uniform mesh, $h\asymp L_x^{-1}$), so this is a pointer problem, not a mathematics problem: pin **Schumaker Thm 6.27** or **DeVore–Lorentz Ch. 13 Thm 6.2** in the proof now, and let the librarian add the `.bib` entry afterwards. The proof does not stand on an author's name.

**2. No Part F rendering — right call, and I would extend it.**

The deciding fact is one the theorist did not invoke: per `permissions.md`, the narrow critics accept *either* `quality_reports/theory/{project}/{results,proofs,assumptions}.tex` *or* `paper/sections/theorems/*.tex`. **Nothing is lost by deferring** — the sweep reaches Part F through `results.tex`/`proofs.tex` either way. And there is a positive reason to defer beyond drift-aversion: Part F's central object, $\mathcal B_{\rm sym}$, is currently mis-typed (MAJ-1). Rendering now would freeze the defect into a fifth file and guarantee a second M-7.

No stub means the `quality.md` §4 binary gate is not blocked — that reading is correct.

I would go further: **generate Part E and Part F together, in one pass, after Step 4 settles $\mathcal B_{\rm sym}$**, and add a mechanical label-and-hypothesis diff to the dispatch checklist. M-7's real lesson is not "fewer files" but "the sync must not be manual" — this round's resync was mathematically flawless and still shipped a header that misdescribes the file's own dependency set in five places. A human-maintained header is the same failure mode at one remove.

---

## On the narrow-critic sweep

**Hold it.** Two of the findings above would corrupt the sweep's output rather than be caught by it:

- The **assumption-auditor** will read `prp:orthog`'s "assume N1 for parts (i)–(ii) only" and `lem:solset`'s A2+A2′ and report them as unused — correct, but it will *also* mark `eq:nuhat`'s first half as *used* by `lem:balance`(ii), because the statement says so. It cannot see that the proof does not consume it. Fix MAJ-4 first or the matrix records a false positive on the exact clause N-18 turns on.
- The **notation-warden** will read `notation_glossary.md:185` and certify $\mathcal B_{\rm sym}$ as consistently defined — it is internally well-formed prose. It has no way to detect that the multiplication part was not conjugated with the compact part. Fix MAJ-1 and MAJ-5 first, or the notation table certifies a mis-typed operator and a symbol ($\epsilon_n$) with two meanings.

When it runs, prime it on: (i) the $L^2(dx)$ / $L^2(\pi)$ boundary — every quadratic-form object in Part F crosses it, and `lem:secondord`(i) is the only place the reference measure is written down; (ii) the $\ell^\Pi$ / $\ell_\star$ superscript discipline recorded in glossary §8.5, which Part F exercises harder than Part E; (iii) the $\IR^p$-valued typing of $L,\ell,\ell_\star,q,\sigma_q,c$ (F-15/C18) against the scalar-written statements applied coordinatewise.

**No files were edited.**


---

<!-- ===================== Round 3 · 67/100 — CRITICAL closed · recovered verbatim from aa1b466ce5fd0487b.output ===================== -->

# Theory Review: Part F (dispatch 3, round 3)

**Target:** `/Users/samuele/Documents/github_repo/clo-econometrics-author/quality_reports/theory/panel-npiv-discrete/{results,proofs,assumptions}.tex`, `notation_glossary.md`, `theory_memo.md`; `/Users/samuele/Documents/github_repo/clo-econometrics-author/paper/sections/theorems/lem-adjoint.tex`; two specs under `/Users/samuele/Documents/github_repo/clo-econometrics-author/scripts/symbolic/specs/`
**Severity:** HIGH · **Gate:** 80

---

## (a) Score: **67 / 100 — DOES NOT CLEAR**

Up from 58. No CRITICAL. Six MAJOR, four minor clusters. **The mathematics has cleared; the artifacts around it have not.**

Every remaining MAJOR is one species: the round-6 repairs were executed *in the proof* and not propagated to the three surrounding artifacts — the theorem statement of `lem:balance`, the notation glossary, and the spec/memo commentary. Not one of them threatens a result. Five of the six are squarely inside the narrow critics' remit, which is what makes the disposition question in (d) the real one.

---

## (b) C-1 is genuinely closed. No new counterexample exists.

I re-derived the counterexample from scratch rather than accepting it. With $\Delta U\sim\mathrm U[0,1]$, $\Delta h=-1$ on $A$ ($P(A)=\tfrac12$), $\tau_1=1$, $D=M\un\{u\in[1,2]\}$: $P(\Delta U\in[1,2])=0$ so $D(\Delta U,\Delta Z)=0$ a.s., giving $E[D\mid\Delta Z]=0$ and $\|D\|_{L^2(P)}=0$; on $A$ the argument is $\Delta U+1\in[1,2]$, so $E[rD(\Delta U-\tau_1\Delta h,\Delta Z)]=M/2$. The discarded bound reads $M/2\le 0$. Confirmed, and it is a legitimate instance of clause (iii) — $D$ need not be differentiable, that being (iv)'s hypothesis, and the printed proof says so.

The replacement bound `eq:crossshift` (proofs.tex:1351–1353) is **correct**: $|E[rD_{\rm shift}]|\le\|r\|_\infty E|D_{\rm shift}|\le\|r\|_\infty(E[D_{\rm shift}^2])^{1/2}$, valid in $[0,\infty]$. No counterexample to it.

**The non-assumption is honestly flagged, not quietly load-bearing.** The caveat survives in `results.tex`:1086–1087 — the *statement*, not only the proof — so a downstream reader who never opens `proofs.tex` still meets "the norm of the *shifted* direction, which is not controlled by $\|D\|_{L^2(P)}$." Nothing in the current artifact consumes the false version: (iv)'s product bounds are at $\tau=0$, `prp:orthog` uses first derivatives at $0$, `lem:balance` never touches $\tau$. The judgment to print the counterexample as a numbered display was right and should not be reversed.

One residue, and it is why MAJ-E below exists: the *supporting* files still describe the fix in the refuted vocabulary.

**MAJ-1 verified.** $\mathcal B_{\rm sym}=\tfrac12(\mathcal B+\mathcal B^\ast)=(\sigma_q/\pi)\cdot-(\tilde{\mathcal K}+\tilde{\mathcal K}^\ast)$ is self-adjoint; $M_{\sigma_q/\pi}$ is unaffected by symmetrisation; $\pi\,dx$ is non-atomic so $\sigma_{\rm ess}(M_m)=\sigma(M_m)=\operatorname{ess\,ran}(m)$; Weyl gives $\sigma_{\rm ess}(\mathcal B_{\rm sym})=\sigma_{\rm ess}(M_{\sigma_q/\pi})$, hence $\|\mathcal B_{\rm sym}\|\ge\|\sigma_q/\pi\|_\infty$. **The lower bound is correct and Step 4 may build on it** — subject to MAJ-F.

**MAJ-2 verified.** The witness is right: $q=\binom{-c\ \ c}{\ c\ -c}$ has all row and column sums zero so $\sigma_q\equiv0$, and $E[q(\Delta h)^2]=2c(h_1-h_2)^2$ both directly and via $\int\sigma_qh^2-2\langle\mathcal Kh,h\rangle=0-2(-c(h_1-h_2)^2)$. The coordinator's reconciliation is the correct one: $\langle\mathcal Kh,h\rangle=-c(h_1-h_2)^2$ alone, $8.0=-2\times(-4.0)$. **The spec's own reconciliation is wrong** — see m-2 — and the spec still certifies the arithmetic, not the aim.

---

## (c) Priority findings

### MAJOR

**MAJ-A — $\mathcal B$ denotes two different operators (INV-7). −5**
`results.tex`:770–772 defines $\mathcal B:L^2(P_{\Delta U,\Delta Z})\to\mathcal V$, $\mathcal B\Xi:=\nu_{\widetilde W\Xi}/\pi$. `results.tex`:1060–1062 (`eq:Bpi`, the MAJ-1 fix) defines $\mathcal B=(\sigma_q/\pi)\cdot-2\tilde{\mathcal K}$ on $L^2(\pi)$, $\IR^p$-valued. Different domains, different codomains, both live in Part F. The glossary carries **two rows for bare $\mathcal B$** (lines 167 and 185), and line 167's stated disambiguation rule — "$\mathcal B$ never carries a subscript, $\mathcal B_{\rm sym}$ always does" — is now the source of the ambiguity, since $\mathcal B_{\rm sym}$ symmetrises the *other* $\mathcal B$. The proof of `lem:balance` (proofs.tex:1459) has to write "with $\mathcal B$ the operator of `cor:rangegap`", which is the evidence that context does not disambiguate. §8.2 of the glossary records only the two-way $\mathbf B$/$\mathcal B_{\rm sym}$ hazard; the three-way one is unrecorded.

**MAJ-B — the glossary still prints the refuted MAJ-1 formula. −3**
`notation_glossary.md`:183 reads: *"the compact part of $\mathcal B_{\mathrm{sym}}=\sigma_q\cdot-2\tilde{\mathcal K}$."* Two errors in one clause. (1) The multiplier is un-conjugated — this is verbatim the string `proofs.tex`:1273–1275 names as wrong ("Writing $\sigma_q\cdot{}-2\tilde{\mathcal K}$ conjugates the compact part and leaves the multiplication part in the wrong space"). (2) $-2\tilde{\mathcal K}$ is $\mathcal B$, not $\mathcal B_{\rm sym}$, which is $-(\tilde{\mathcal K}+\tilde{\mathcal K}^\ast)$. The memo's MAJ-3 row claims "two sites… both corrected"; §8.4 item 2 and the $\mathcal B_{\rm sym}$ row are indeed corrected. Line 183 is a third site and it was not.

**MAJ-C — `eq:nuhat`'s first half is still a blanket hypothesis of `lem:balance`. −4**
`results.tex`:1133–1138 reads *"Suppose further that the empirical difference functional satisfies [$\|(\hat\nu_g-\nu_g)/\pi\|=O_P(n^{-1/2})$] and, **for part (iii)**, [$\|\hat\nu_g/\pi\|=O_P(1)$]."* Only the second half was moved. So clause (ii) — which states "no appeal to `eq:nuhat`" — formally inherits the first half from its own lemma preamble, and Step 3 of the proof ("The rate route is therefore input-free of `eq:nuhat` **entirely**", proofs.tex:1478) contradicts the statement it proves. The memo's MAJ-4 row claims "Removed from (ii)"; it is not. The first half is used only in (iii)'s term (I) and in Step 3's explicitly optional routing. Correct placement: both halves under "for part (iii)".

**MAJ-D — N1's status is not fixed, and the M-8 repair reached only one of four sites. −5**
`prp:orthog`(iii) derives N1 as an *equivalence* and its proof insists (proofs.tex:1439–1441) that assuming N1 would make the equivalence vacuous. But: (1) `assumptions.tex`:773–774 phrases N1 as *"$L$ **is normalised** so that…"*; (2) `notation_glossary.md`:149 types $L$ as *"debiasing weight on $(u,z)$, **normalised by N1**"*; (3) `lem:secondord` (results.tex:1072) **lists N1 among its hypotheses and never uses it** — Steps 1–5 use envelopes, `cor:elldiff`, affineness, the separately stated $E[D\mid\Delta Z]=0$, and (P1)/Cauchy–Schwarz; the closing paragraph of Step 4 itself says "N1 imposed on the **direction**, not on $L_\star$." Under readings (1) or (2), $L_\star$ satisfies N1 by construction and `prp:orthog`(iii)'s "only if" has no content — the exact defect M-8 was raised against. `lem:solset`(ii) is the one site that gets it right ("N1 is a normalisation of $L$ that **can be** imposed on any member of the set"). This needs one decision, applied in all four places.

**MAJ-E — the refuted "product bound" vocabulary survives in two live artifacts. −3**
`scripts/symbolic/specs/secondord-crossterm-tau1.yaml`:14–15 closes: *"The residual is O(t1), i.e. a product term, which is exactly how the corrected clause states it."* The corrected clause states no such thing — it states that the shifted norm is **not** controlled by $\|D\|$, which is precisely what a "product term" would require. The spec's model ($D$ a quadratic polynomial) is the smooth case the printed counterexample deliberately avoids, so it cannot certify (iii)'s negative content. `theory_memo.md`:49 (M-4 row) likewise still reads "with the off-$\tau_1$ **product bound** stated." A Step-6/7 author reading the change log rather than the proof inherits exactly the error C-1 was raised against — which is the failure mode the proof's own closing sentence ("Step 6 or 7 must supply it before expanding along the path") was written to prevent.

**MAJ-F — compactness of $\tilde{\mathcal K}+\tilde{\mathcal K}^\ast$ is asserted, not shown, and it is the sole input to the Weyl bound. −3**
`proofs.tex`:1288 — *"$\tilde{\mathcal K}+\tilde{\mathcal K}^\ast$ being compact"* — carries no justification. It is **true** under the listed hypotheses (I checked: $|q|\le\|\partial_u\ell_\star\|_\infty$ by (P1) and `cor:elldiff`; C1(ii) bounds $f_{X_1,X_2}$ above and $\pi$ below, so $\iint(qf)^2/(\pi(x_1)\pi(x_2))\,dx_1dx_2\le\|q\|_\infty^2\|1/\pi\|_\infty^2\|f\|_\infty<\infty$ and $\tilde{\mathcal K}$ is Hilbert–Schmidt on $L^2(\pi)$ — no compactness of $\mathcal X$ needed). One line, but the entire Weyl argument that Step 4 binds on rests on it, and a referee will ask.

### MINOR (clustered)

**m-1 — five one-line imprecisions in the C-1 / MAJ-1 paragraphs. −3**
(i) `proofs.tex`:1349 attributes `eq:crossshift` to "(P1) and the Cauchy–Schwarz inequality"; (P1) is $|\widetilde W|\le1$ and $\widetilde W$ does not appear in that term — $\|r\|_\infty$ comes from the lemma's own "$r$ bounded". (ii) `proofs.tex`:1368–1370: "pricing $\sup_{|\tau_1|\le\bar\tau}\|D(\cdot-\tau_1\Delta h,\cdot)\|$ directly, which is what `eq:crossshift` does" — `eq:crossshift` prices the shifted norm at a *given* $\tau_1$; the sup is a further step. (iii) Nothing hypothesises $E|D(\Delta U-\tau_1\Delta h,\Delta Z)|<\infty$, so "away from $\tau_1=0$ the cross-partial **is** $-E[\dots]$" may name an undefined object; read `eq:crossshift` as an extended-real inequality or add the proviso. (iv) `proofs.tex`:1282 — "so $\tfrac12\|\mathcal B\|$ is an upper bound on the sharp constant" — the Taylor $\tfrac12$ is silent; the display two lines above carries no $\tfrac12$. (v) `proofs.tex`:1289 writes $\|\sigma_q/\pi\|_\infty$ three sentences after establishing that `eq:Bpi` is $p$ operators requiring a fixed $\varsigma\in\IR^p$; glossary §8.4 item 2 has it right as $\|\varsigma'\sigma_q/\pi\|_\infty$.

**m-2 — the MAJ-2 apparatus. −3**
(i) `solset-sigmaq-not-sufficient.yaml`:27–33 offers an **incorrect** reconciliation of the arithmetic discrepancy: with $f_{ab}=1/4$ the form is $0.5c(h_1-h_2)^2$, which against $-c(h_1-h_2)^2$ differs in *sign* for $c<0$ and by a factor 2 in magnitude — so "the two agree in sign and magnitude" is false. The correct reconciliation is the coordinator's: two different objects, $\langle\mathcal Kh,h\rangle$ versus the full form. Flagging rather than absorbing was right; the flag is wrong. (ii) The spec's `start`/`claimed_end` verify only that selection 1's form is $2c(h_1-h_2)^2$; the crux — that the row and column sums vanish, so $\sigma_q$ is *shared* — lives in the comment block, uncomputed. The theorist's own caveat is accurate and should stay attached. (iii) `proofs.tex`:1263–1265 types the witness as *"the selections $q$ and $q'\equiv0$"*; $q$ is not a selection, and realisability of either from an admissible $\ell_\star$ is not shown. The negative claim survives this, but the sentence overstates.

**m-3 — bibliography. −2**
Confirmed independently: `schumaker2007` and `devorelorentz1993` appear in **no** `.bib` in the repo (`Bibliography_base.bib`, `quality_reports/literature/panel-npiv-discrete/references.bib`, `quality_reports/literature/volatility-loc-scale/references.bib`). **Pinning before the entry existed was the right call and should not be reversed** — the spline bound is the entire content of Step 4 and a surname is not checkable. The cost is smaller than "breaks the build": with `biblatex` an undefined key is a warning and a `???` in output, not a failure. I could not verify either locator from within this environment; the Schumaker Thm 6.27 attribution is plausible, but my recollection places splines in **Ch. 12** of DeVore–Lorentz, not Ch. 13 — the librarian should verify the chapter and theorem number against the physical book rather than transcribe.

**m-4 — housekeeping. −2**
(i) `paper/sections/theorems/lem-adjoint.tex`:36–39 says *"NINE numbered environments"* and lists **eight** (`lem:nusigma`, `lem:adjfubini`, `lem:levels`, `lem:adjoint`, `cor:elldiff`, `cor:rangegap`, `prp:kerchar`, `cor:a1cprim`); `theory_memo.md`:28 repeats "nine environments listed." The per-result assumption-tag table is correct and lists the same eight — this is the header arithmetic, in the file whose own SYNC DISCIPLINE note warns about exactly this. (ii) `proofs.tex`:1594 still lists `prp:orthog` under *"WHAT IS NOT PROVED HERE, deliberately"*; neither `proofs.tex` nor `results.tex` carries a dispatch-3 change log. (iii) `lem:solset`(ii) cites "(P3) and A1" where (P3) alone suffices — $E[\widetilde W c(\Delta Z)]=E[cE[\widetilde W\mid\Delta Z]]=0$ is free. (iv) $\mathcal S$ is introduced in `results.tex`:1056 and consumed once, in its own proof.

### Verified correct — no finding

`lem:secondord` Step 2's expansion ($\int\sigma_qh^2-2\langle\mathcal Kh,h\rangle$ with $\sigma_q=\sigma_{\widetilde W\partial_u\ell_\star}$ by the tower property) · `prp:orthog`(i)–(iii) including the $p$ scalar sign directions and the A4(i) admissibility argument · `lem:balance` Steps 1–4, including $\|\mathcal B\|\le2\bar c_\pi^{1/2}$ reused from `cor:rangegap` Step 1 · **the $L^2(dx)\to L^2(\pi)$ transfer reduced to the single factor $\|\pi\|_\infty^{1/2}$ is right** — $P_{L_x}$ minimises over the same span, so it beats $P^{\rm Leb}_{L_x}$ in $L^2(\pi)$; the second factor a round-5 version charged is genuinely not needed · the $s>1$ / $s>3/2$ window arithmetic · `secondord-crossterm-tau1`'s algebra (MATCH is correct) · `solset-sigmaq-not-sufficient`'s algebra (MATCH is correct) · glossary $\epsilon_n$ row on the derivative with the INV-7 reason (MAJ-5 closed) · `lem-adjoint.tex` per-result assumption tags (MAJ-6 substantively closed).

---

## (d) The question for the user

**This is not a proof-level disagreement.** There is nothing here for a human to adjudicate mathematically: the four Part F results are correctly stated and correctly proved, C-1 is closed with a counterexample I reproduced independently, and MAJ-1's Weyl argument is sound. Escalating "is the theorem true?" would waste the user's time.

The question is a **disposition** question, and it is sharp:

> Five of the six remaining MAJORs are, by construction, the narrow critics' remit — `MAJ-A` and `MAJ-B` are notation-warden findings, `MAJ-C` and `MAJ-D` are assumption-auditor findings, `MAJ-F` is a regularity-checker finding. Do you want a fourth theorist-critic round on artifact-propagation defects, or do you want the sweep run now and its findings routed back to the theorist as a **single consolidated fix**?
>
> The argument for the sweep: these defects are mechanically checkable and mechanically fixable, and the theorist has already committed to producing the label/dependency/tag lists by diff rather than by hand (`lem-adjoint.tex`:43–51).
>
> The argument against: the theorist's own round-6 diagnosis is that **"neither critic can catch a defect that is locally coherent and globally wrong."** `MAJ-B` is exactly that — glossary line 183 is internally well-formed prose that happens to print the refuted formula — and the notation-warden will miss it unless primed. `MAJ-D` is the same: a hypothesis listed but unused reads to the assumption-auditor as a satisfied hypothesis.

**My recommendation:** run the sweep, but only with the priming below, and treat this report's six MAJORs as *inputs* to the sweep rather than as a fourth round of theorist-critic findings. That converts a third strike into a routed handoff and does not ask the user to adjudicate mathematics that is not in dispute.

---

## Consolidated priming for the narrow critics — dispatch-2 + Part F

Give each critic its list verbatim. These are the items each will **not** find unaided.

**notation-warden** — over `results.tex`, `proofs.tex`, `notation_glossary.md`, `paper/sections/theorems/*.tex`
1. Bare $\mathcal B$ has **two** live definitions (`cor:rangegap` vs `eq:Bpi`) and **two glossary rows** (167, 185). Line 167's disambiguation rule is itself broken. §8.2 records only the $\mathbf B$/$\mathcal B_{\rm sym}$ pair — the three-way clash is unrecorded. Check whether `proofs.tex`:1459's in-prose disambiguation is the only thing keeping `lem:balance` readable.
2. **Glossary line 183 is locally coherent and globally wrong.** It prints $\mathcal B_{\rm sym}=\sigma_q\cdot-2\tilde{\mathcal K}$: wrong multiplier (should be $\sigma_q/\pi$) and wrong label (that expression is $\mathcal B$). Compare against `eq:Bpi`, glossary 185–186, and §8.4 item 2, all of which are correct. Do a three-way diff of every site where the second-order form is printed.
3. Check every occurrence of $\|\sigma_q/\pi\|_\infty$ for the missing direction $\varsigma\in\IR^p$ under F-15 — `proofs.tex`:1289 is $\varsigma$-free, glossary §8.4 item 2 is not.
4. `lem-adjoint.tex`:36 says NINE, lists EIGHT; `theory_memo.md`:28 repeats it. Produce the label list mechanically from `results.tex` and diff.
5. $\mathcal S$ (`results.tex`:1056) — single-use; confirm it earns its symbol or is inlined.

**assumption-auditor** — over `assumptions.tex` × `proofs.tex`, Part F
1. **N1 has three incompatible statuses.** `assumptions.tex`:773 ("$L$ **is normalised** so that"), glossary:149 ("normalised by N1"), `lem:secondord` hypothesis list (listed, never used), `prp:orthog` ("N1 is not assumed in any part"). Only `lem:solset`(ii) is right. Under the first two readings `prp:orthog`(iii) is vacuous — the M-8 defect, unrepaired in three of four sites. **This is the highest-value item in the sweep.**
2. **`eq:nuhat`'s first half is a blanket hypothesis of `lem:balance`** (`results.tex`:1134–1135) while clause (ii) says "no appeal to `eq:nuhat`" and Step 3 says "input-free… entirely." Build the usage matrix per *clause*, not per lemma — this defect is invisible at lemma granularity.
3. Confirm A1 is used in `lem:secondord` (I could not find a use; it *is* used in `prp:orthog`(ii)). Confirm the C2′(i) removal from both Part F results is complete and correct (I believe it is).
4. Check A5(iv)/A8 are recorded as **alternatives**, not cumulative, everywhere — `proofs.tex`:1512–1537 records this as N-18 and explicitly says it was not applied to the memo.

**regularity-checker** — over `proofs.tex` Part F
1. `proofs.tex`:1288 asserts $\tilde{\mathcal K}+\tilde{\mathcal K}^\ast$ compact with no argument. True under C1(ii) + `cor:elldiff`; supply the HS computation.
2. Integrability of the shifted direction $D(\Delta U-\tau_1\Delta h,\Delta Z)$ is nowhere hypothesised, yet `lem:secondord`(iii) asserts an identity for the off-$\tau_1$ cross-partial.
3. Weyl's theorem is invoked without stating the non-atomicity of $\pi\,dx$ that makes $\sigma_{\rm ess}(M_{\sigma_q/\pi})=\operatorname{ess\,ran}(\sigma_q/\pi)$.
4. Differentiation under the expectation in `lem:secondord` Step 1: the envelope list covers $L_\star$ but not $D$ or $\partial_uD$.

**counterexample-hunter** — over `results.tex` Part F
1. **Do not re-probe `lem:secondord`(iii)** — the counterexample is printed at `proofs.tex`:1359–1365 and I verified it. Probe instead whether `eq:crossshift`'s RHS can be $+\infty$ under the stated hypotheses (I believe it can), which is a *statement* defect, not a bound defect.
2. Probe `lem:solset`(iii)'s witness for **realisability**: is there an admissible $\ell_\star$ generating $q=\binom{-c\ \ c}{\ c\ -c}$, and is $q'\equiv0$ compatible with $\mathcal A^\ast_{\rm cond}\ell^\Pi=-\nu/\pi$? The negative claim survives either answer; the sentence "the selections $q$ and $q'$" does not.
3. Probe `lem:balance`(ii) at $\hat\ell$ with $\|\hat\ell-\ell_\star\|$ large but $\nu_{\widetilde W(\hat\ell-\ell_\star)}$ small — the bound is one-sided and the route is advertised as needing no sieve condition.

**derivation-verifier** (advisory)
1. `solset-sigmaq-not-sufficient`: the ARITHMETIC NOTE's reconciliation is wrong (m-2(i)); the spec certifies selection 1's form only, not the shared $\sigma_q$. Add a spec computing the row and column sums.
2. `secondord-crossterm-tau1`: the closing sentence ("i.e. a product term, which is exactly how the corrected clause states it") contradicts the corrected clause. Fix the comment; the algebra is right.
3. Suggested new spec: $\mathcal B_{\rm sym}=\tfrac12(\mathcal B+\mathcal B^\ast)$ in the two-point model, to pin `eq:Bpi` against glossary line 183.

---

## Positive findings

- **The C-1 disposition is the right way to handle a refuted claim.** Printing the counterexample as a numbered display, naming the two conditions that would restore comparability, and explicitly *not* assuming them, with the consumer (Step 6/7) named — this is better practice than a caution, and it survives into the theorem statement where a downstream reader will actually meet it.
- **The MAJ-1 operator analysis is correct in all four limbs and is more careful than it needed to be.** Distinguishing $\sup|\langle\mathcal Bh,h\rangle|$ from $\|\mathcal B\|$, identifying the sharp constant as $\tfrac12\|\mathcal B_{\rm sym}\|$, and recovering $\|\sigma_q/\pi\|_\infty$ as a Weyl *lower* bound rather than the constant — this is exactly the right level of precision for a Step-4 input, and I verified each step.
- **`lem:balance`'s two-route structure is a genuine contribution, and the $\|\pi\|_\infty^{1/2}$ reduction is right.** The observation that A5(iv) and A8 are alternatives rather than cumulative (recorded as N-18, `proofs.tex`:1512–1537) is a real finding about the block, correctly flagged as outside the theorist's write scope rather than silently applied to the memo.
