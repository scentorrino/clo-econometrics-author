# Theory Review — `panel-npiv-discrete`, Stage 3 dispatch 1 (ROUND 2)

**Reviewer:** theorist-critic · **Severity:** HIGH (Execution) · **Gate:** 80
**Persisted by the orchestrator.** Supersedes the round-1 report.

## Round-1 record, corrected

**`conway2000` exists.** Round-1 M-8 was wrong on that item: it is at `instrumental.bib:2167`, and plan §10.2 names `instrumental.bib` as the paper's bibliography. The round-1 check used `Bibliography_base.bib` and the Stage-1 `references.bib`. The theorist's pushback with a line number was correct; the charge is withdrawn and not re-levied. `stinchcombewhite1998` is present at `references.bib:415` — *Econometric Theory* 14(3), 295–325, 1998, correct throughout, and Thm 3.1 is the right anchor for the intercept-indexed family.

## (a) SCORE: **88 / 100 — CLEARS 80.** Dispatch the narrow critics.

| Phase | Verdict |
|---|---|
| 1. Claim identification | Clean. |
| 2. Proof validity | **No CRITICAL, no MAJOR.** Every proof re-verified line by line, including the two new steps (`prp:frechet` Step 5, `prp:compact` Step 2) and the rewritten `lem:bierens` Step 5. All correct. |
| 3. Assumptions / statements | MAJOR ×4 — one substantive (a hypothesis that trivialises the headline lemma), three propagation misses. |
| 4. Citations / linkage / polish | MINOR ×6. Compiles. |

## (b) Do the CRITICALs survive?

**C-1 — mathematics fixed; one documentation residue.** `lem:bierenscore` now stated and proved for $w=\exp$ only in both renderings; the false Step 6 gone; the scope note localises the failure at Step 4 correctly; the Bierens (1990) Thm 1 citation is now exact. $\bar w$ bookkeeping consistent with $\exp$ throughout: B1(ii) gives $\bar w(t)=e^{c_\Phi\|t\|_1}$ (correct, since $|t'\Phi(z)|\le\|t\|_1\|\Phi(z)\|_\infty\le c_\Phi\|t\|_1$), B1(iv.c) ⟹ $c_\Pi$, and `prp:wellposed` Step 2, `prp:frechet` Steps 3–5, `prp:compact` Step 3 all route through (P2). **The countability argument in `rem:swintercept` is correct**: $w$ real-analytic non-polynomial ⟹ $w^{(k)}\not\equiv0$ for every $k$ ⟹ each zero set discrete and closed, hence countable ⟹ countable union countable. The remark correctly identifies the repair as an intercept rather than a stronger $\Phi$, and prices the range-space change. **Residue:** `notation_glossary.md:129` still defines $w$ as "analytic non-polynomial" in a file declaring itself binding — R2-2.

**C-2 — fully caught, no stale invocation.** (P4b) is invoked exactly once, at `proofs.tex:405` in `lem:quantu` Step 2, where the conditioning field is *exactly* $\sigma(\Delta Z)$ and the derivation is written longhand anyway. A grep for every form of $\varrho(1-\varrho)$ returns only: the (P4b) statement, `lem:quantu`'s conclusion, the $\varepsilon_\varrho(1-\varepsilon_\varrho)$ bound in `lem:bierens` Step 3, and the three withdrawal passages. `eq:kernelcompare` is arithmetically right, and $p_X=\varrho$ is equivalent to $W\upmodels(X_1,X_2)\mid\Delta Z$ for binary $W$. **Closed.**

## (c) What the fixes broke, and what they missed

**M-2 — the new proof is correct and the constants are mutually consistent.** The shift identity $G_{\varphi+h}(v)=G_\varphi(v+\Delta h)$ is valid because $\Delta h$ is $\mathcal F_{XZW}$-measurable; C2′(i) supplies $|G''_\varphi|\le\|\bar f_1\|_\infty$; Cauchy–Schwarz plus `eq:deltahbound` twice gives $4\bar c_\pi\|\bar f_1\|_\infty\bar w(t)\|h\|\|h'\|$, and $C_{\mathcal A}=2\bar c_\pi\|\bar f_1\|_\infty c_\Pi$ is correctly constituted. **Independent check:** (ii) implies (i) *exactly* — $\int_0^1 2C_{\mathcal A}s\|h\|^2ds=C_{\mathcal A}\|h\|^2$, precisely `eq:frechetbound`, same constant. Two separately-derived bounds satisfying the fundamental-theorem relation on the nose is strong evidence both are right.

**C2′(i) at $p_K-1$ is exactly tight.** M-2 needs $C^1$; C2′(ii) needs $\partial_u^{p_K}\mathcal M=E[\widetilde Ww\,\partial_u^{p_K-1}f]$, i.e. exactly $p_K-1$ derivatives plus the envelope. Nothing in this dispatch consumes the stronger version. The F-4 withdrawal and its replacement are both correct.

**M-1 — the new step is correct; its stated justification is stale.** Taking $h\equiv1$ in (P5) gives $\int\nu_g\,dx=0$, hence $\mathsf k(u,t;\cdot)\in\mathcal V$ and $\mathcal A^\ast_{\rm cond}$ maps into $\mathcal V$ with no projection — correct, and it independently confirms the Picard test. But the reason given ("orthogonality forced by $\mathcal R(\mathcal A^\ast)\subseteq(\ker\mathcal A)^\perp$ together with $\Delta\mathbf1=0$") is the $L^2(\pi)$ argument M-5 abolished. Once `def:spaces` fixes the domain at $\mathcal V$, constants are not in the domain. The orthogonality comes from $\mathcal R(\mathcal A^\ast)\subseteq\mathcal V$ by construction, which is what Step 2 actually proves. Conclusion right, reason stale — R2-5.

**M-6, M-3, M-4, M-5, M-8, M-9 and the minors: all landed and verified.** M-6's contradiction argument is clean (if $\mathrm{Leb}(\mathcal T_0\setminus N_{\mathcal T})=0$ the two measures concentrate disjointly, contradicting non-mutual-singularity); (iv.a) used exactly once and correctly. M-3 correct, and the "neither A2 nor A3" sentence is right. M-8 verified mechanically. Frontier algebra re-verified independently, all eighteen entries correct; $h_u\asymp n^{-1/16}$ with $p_K=8$ balances $h_u^{p_K}=n^{-1/2}$; A8's window non-empty iff $s>1$; H1's $\mu>\tfrac12\iff s>a$.

## (d) DEDUCTION TABLE

| ID | Finding | Sev | Δ |
|---|---|---|---|
| **R2-1** | A1 listed as a hypothesis of `lem:bierens` and `cor:opsol`, used in neither — and since **A1's first clause *is* statement (a)**, the printed equivalence is **vacuous**. The proof establishes the non-trivial result (equivalence under A4(i) and B1 alone); the statement under-delivers. `theory_memo.md:156` repeats it. | MAJOR | −2.5 |
| **R2-2** | `notation_glossary.md:129` still defines $w$ as "analytic non-polynomial" — the generality C-1 refuted — in the file declared binding for every later `.tex`. | MAJOR | −2 |
| **R2-3** | `notation_glossary.md:136` still has $\ell_\dagger$ solving $\mathcal A^\ast\ell=-\nu$, making A2′'s $-\nu/\pi$ incoherent; `:126` still has $|\widetilde W|<1$, false without overlap. **The first binds Step 3 — it is the row `lem:adjoint` reads.** | MAJOR | −2 |
| **R2-4** | B1(iii), (iv.a), (iv.b) idle in the three setup propositions, which consume only (i), (ii), (iv.c). Memo §3.1 is right; the statements are not. | MAJOR | −1.5 |
| **R2-5** | `prp:compact` Step 2 and the A2 comment justify $\nu/\pi$ via the $L^2(\pi)$ argument M-5 abolished. Conclusion right, reason stale. | MINOR | −1 |
| **R2-6** | (P5) scoped "for $h\in\mathcal V$" but applied at $h\equiv1\notin\mathcal V$, twice. True for bounded $h$; say so. | MINOR | −0.5 |
| **R2-7** | `rem:draftrec`(ii) attributes boundedness of $p_X(1-\varrho)$, $(1-p_X)\varrho$ to A4(i); they are bounded for free. | MINOR | −0.5 |
| **R2-8** | C2′(ii) implied by C2′(i) (verified); retained without the kind of reason A2′ gives. | MINOR | −0.5 |
| **R2-9** | $\nu$ unsubscripted used in A2/A2′ but defined nowhere in the `.tex` set — only (P5)'s $\nu_g$ exists. | MINOR | −0.5 |
| **R2-10** | Four slips: `rem:quadremainder` mislabels (i) as the Lipschitz bound; `eq:kernelcompare` uses $f_{\Delta Y}$ where `eq:kernel` uses $f_{\Delta U}$, unbridged; `lem:density` Step 2 verifies only half of B1(v); `proofs.tex` lacks the "never compile together" header though `eq:laplace` and `eq:shift` collide with the paper files. | MINOR | −0.5 |
| | | **Total** | **−11.5** |

**Score 88/100.** Clears commit; below the 90 PR gate. R2-1…R2-4 are each one line and would put this at 96.

## Adjudications

**N-7 — plan §18.3's A4-mechanism bullet is REFUTED, not under-argued.** The reweighting needs $p_X=\varrho$, i.e. $W\upmodels(X_1,X_2)\mid\Delta Z$; and under the fuller $W\upmodels(X_1,X_2,\Delta U)\mid\Delta Z$ one gets $\mathcal A_{\rm cond}\equiv0$ — **the operator is annihilated, not reweighted.** The assumption the bullet silently needed is destructive of the object it characterises. The theorist's handling was right on all three counts. **Coordinator has amended plan §18.3.** Preserve the bullet's second half (Khan–Tamer irregularity as overlap degrades), retained as A4 comment (d). Use the precise phrasing "the instrument does not shift the endogenous regressor given $\Delta Z$", not the slogan "the negation of relevance."

**F-13 — right call.** Nothing in the artifact set `\cref`s or `\ref`s a remark, so the labels are inert under either declaration and cannot break a compile. **For the writer:** `theory_memo.md:35` transcribes `\newtheorem{remark}[]{Remark}`, which is **not valid LaTeX** — the optional argument requires a counter name and an empty one errors. Either the transcription is inexact or the preamble has a latent bug.

**A1b(iii) — right disposition.** Consumed only by `cor:opsol`'s final clause and R1(iv), both of which now name it. Advisory: the comment offers the completeness condition on $(X_1,X_2)\mid(\Delta U,\Delta Z,W)$ as the NPIV analogue, but that object is what A1c is built on and the same comment disclaims A1c as a route to (iii). Sharpen or drop.

## Priming for the narrow critics

**counterexample-hunter, in order.**
1. **B1(iv.b), newly weakened.** Build a $\Pi_t$ that is not purely atomic but **singular continuous** (Cantor-type), so $\mathrm{Leb}\vert_{\mathcal T_0}$ and $\Pi_t\vert_{\mathcal T_0}$ are mutually singular for every Borel $\mathcal T_0$ of positive Lebesgue measure. Does `lem:bierens` Step 5 fail? This is where the weakening can bite.
2. **$p_X\neq\varrho$ with a live instrument** — a DGP satisfying A1, A4(i) and relevance where $\mathcal A_{\rm cond}$ and the raw $W$-contrast operator have demonstrably different kernels. Converts N-7 from "unproved" to "false."
3. **A2, not A3** — A3 has no truth value when A2 fails; plan §7 probe (iii) is misdirected as written.
4. **A1c holding while A1b(iii) fails** — the block asserts non-nestedness; a witness sharpens the paper's most exposed flank.
5. **Overlap degradation** — $\varepsilon_\varrho\downarrow0$ with A2 holding as a range statement while $E[\widetilde W^2\ell_\star^2]\to\infty$. Asserted at A4 comment (d), not demonstrated.
6. **Do not re-probe $w=\cos$** — captured by B1(ii) and inside the paper as `rem:swintercept`.

**regularity-checker.**
1. `prp:frechet` Step 5's shift identity is a regular-conditional-distribution freezing step; existence of a regular version of $P(\cdot\mid\mathcal F_{XZW})$ with a jointly measurable df is used and never named.
2. Measurability of $(u,t)\mapsto\mathcal A_\varphi h(u,t)$ and $(u,t,x)\mapsto\mathsf k$ asserted; only $\mathcal M$ gets the Fubini–Tonelli argument.
3. `prp:compact` Step 2 places $\mathsf k(u,t;\cdot)$ in $\mathcal V$, presupposing $\mathsf k\in L^2(\pi)$, proved only in Step 3. Also the Bochner-integral step.
4. (P5)'s scope line versus the $h\equiv1$ application; existence of the conditional-expectation versions with the implicit Fubini.
5. C2′(i)⟹C2′(ii) asserted in a comment, never carried out — name the DCT and the dominating function $\bar w(t)\bar f_k$.
6. `lem:quantu` Step 1's "for *every* $z$, not merely a.e." needs its standard-Borel citation.
7. **A1c's "equivalently $\ker\mathcal A_{\rm cond}=\{0\}$ on $\mathcal V$" is the one unproved equivalence in the block** — passing from the conditional-mean form to the density-weighted operator form needs a Bierens step plus positivity of $f_{\Delta U\mid\Delta Z}$.

**derivation-verifier (advisory):** the frontier equivalence and the eighteen-entry table; the constant chain $C_{\mathcal A}=2\bar c_\pi\|\bar f_1\|_\infty c_\Pi$ against the fundamental-theorem relation between `prp:frechet`(i) and (ii).

**notation-warden:** R2-2, R2-3, R2-9 and the $f_{\Delta Y}$/$f_{\Delta U}$ drift — all in its lane, three in the file it treats as binding.

**assumption-auditor:** R2-1, R2-4, R2-8; plus A1b(i)'s first clause is definitional given `def:spaces`, A0 is idle by design and declared so, and (P4a) is defined and never invoked.

## Positive findings

- **`prp:frechet`(ii) is the best work in this round** — the shift identity is the right device, the Lipschitz bound is proved rather than assumed, and the constants pass an independent consistency test the theorist did not claim.
- **The C2′(i) weakening is exactly tight, not merely sufficient** — and it retires the round-1 "one derivative of slack" claim honestly rather than quietly. Weakening an assumption while fixing a different finding is where errors hide; this one is right.
- **`rem:swintercept` is the right way to lose an argument** — counterexample against the paper's own maintained transform, mechanism named, repair given with its correct anchor and exact cost, and the reason for declining it is that nothing consumes the generality.
- **B1(iv) now states exactly what Step 5 consumes.**
- **The disagreement on `conway2000` was pressed with a line number and was correct.** A worker that checks its reviewer rather than deferring is worth more than one that does not.
