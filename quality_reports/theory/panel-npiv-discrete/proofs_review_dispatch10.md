<!-- Persisted by the orchestrator 2026-07-30, immediately on receipt.
     Written promptly because this session has already lost three critic reports to
     the same omission — proofs_review_dispatch3.md (recovered from a subagent
     transcript), usage-matrix_partH.md and notation-table_partH.md (both recovered
     the same way, after a fix round reported them absent and worked from relayed
     content instead). Body below is the theorist-critic's report verbatim. -->

# Theory Review — Part I, `panel-npiv-discrete` (memo §10 Step 7, `thm:rootn`)

**Severity applied:** HIGH (Execution) · **Reviewer:** theorist-critic · **Read-only; no files edited**
**Score: 48 / 100** · 0 CRITICAL · 4 MAJOR · 4 MODERATE · 5 MINOR
**Strike 1 of 3.** Below the 80 commit gate. No binary-gate block raised.

---

## Phase 1 — What is claimed

- **Object:** $\sqrt n$-asymptotic normality + variance consistency for a cross-fitted one-step estimator of a finite-dimensional $\theta_\dagger$ in a first-differenced panel model with a nonparametric nuisance $\vdagger$ solved by a regularised inverse problem.
- **Target:** $\theta_\dagger$, identified by A1b(iv) (`eq:prelimtheta`'s normal equations), *not* by A2/A3.
- **Estimator:** `def:crossfit` + `def:onestep`: $\hat\theta=\hat\theta^{(0)}+\hat J^{-1}\bar\psi_n(\hat\theta^{(0)})$, $\hat J=\hat J(\hat\theta^{(0)})$, $\hat V=\hat J^{-1}\hat\Sigma\hat J^{-1\prime}$.
- **Data:** i.i.d. panel (A0), $\mathsf F\ge2$ fixed folds.
- **Fit:** econometric methods. Object type is standard DML-with-non-orthogonal-$\varphi$-direction; the proof strategy is the right one.

**Verified correct by independent re-derivation (state this first, because the core is right):**

1. `eq:rootnid` is **exactly** what I get. $\bar\psi_n(\theta_\dagger)=\bar\psi_n(\hat\theta^{(0)})-\hat J(\theta_\dagger-\hat\theta^{(0)})+\Psi^\theta_n$, substituted into `eq:onestep`, gives $\hat\theta-\theta_\dagger=\hat J^{-1}[\bar\psi_n(\theta_\dagger)-\Psi^\theta_n]$ with no residual. The Hessian envelope $(\max_k\|\partial_u\hat\ell^{(-k)}\|_\infty)\mathbb E_n\|\Delta Z\|^2$ is the right one.
2. **`lem:biasexp` is correct term by term and sign by sign.** I reassembled Step 2 from `eq:shiftFTC`: the four vanishings, $-\Psi^{(3)}$, the $(\widetilde W-\mathsf r)$ split, the $\hat\ell$-at-$\Delta U$ split, and the collection at $g=\Delta Z+\widetilde W\hat\ell$ all land exactly on $-\langle\nu_{g_k}/\pi,h_k\rangle-\Psi^{(1)}_k+\Psi^{(2)}_k-\Psi^{(3)}_k$. All four constants (`eq:biasb1`–`eq:biasb4`) check, including the $\tfrac12\to2\bar c_\pi$ chain in Step 4. This is the strongest object in the dispatch.
3. `eq:threeway` is an identity (I verified $\sum_k\frac{n_k}{n}\mathbb E_{n,k}[\psi_\star]=\mathbb E_n[\psi_\star]$ and $E[\psi_\star\mid\sigma(\mathcal I_{-k})]=0$).
4. The **anchor device is genuinely licensed**, not convenient: conditional independence given $\Delta Z$ is invariant to adding a function of $\Delta Z$, so the $\varphi$-solution set is $\mathcal V_{CI}$ at every $\theta$. Circularity is removed outright.
5. Sign structure $\partial_\theta\bar\psi_n=-\hat J$ / $+\hat J^{-1}$ / $J^{-1}$ is consistent; influence function $J^{-1}\psi_\star$ matches $\Sigma=E[\psi_\star\psi_\star']$ and $\hat V$.
6. `prp:medianpart` is correct (median 1-Lipschitz in $\|\cdot\|_\infty$, fixes constants).

---

## Phase 2 — Proof validity: **GAPS** (no CRITICAL)

### 2.1 MAJOR (−10) — The advertised "gain" contains a false identity. $\frac{1-\kappa}{4\kappa}=\frac1{8\mu}$, not $\frac1{4\mu}$.

`proofs.tex:5268` (thm:rootn Step 4(c)) and `results.tex:4337–4342` (`rem:rootnlog`(3)(b)):

```
\alpha(1+\kappa)-\tfrac12\;>\;\frac{1+\kappa}{4\kappa}-\frac12\;=\;\frac{1-\kappa}{4\kappa}\;=\;\frac1{4\mu}\;>\;0
```

With $\kappa=\frac{2\mu}{2\mu+1}$: $1-\kappa=\frac1{2\mu+1}$, $4\kappa=\frac{8\mu}{2\mu+1}$, so $\frac{1-\kappa}{4\kappa}=\frac{1}{8\mu}$. Check at $\mu=1$: $\kappa=\tfrac23$, $\frac{1/3}{8/3}=\tfrac18=\frac1{8\mu}$; $\frac1{4\mu}=\tfrac14$. Both illustrative numbers at `results.tex:4341` are wrong by the same factor 2: the margin is $\tfrac3{20}$ at $\mu=\tfrac56$ (not $\tfrac3{10}$) and $\tfrac1{16}$ at $\mu=2$ (not $\tfrac18$).

**What survives:** the implication itself. $\kappa\alpha>\tfrac14$, $0<\kappa<1$ $\Rightarrow$ $\alpha(1+\kappa)-\tfrac12>\frac{1-\kappa}{4\kappa}>0$ is valid, so $r_n\delta_n=o(n^{-1/2})$ *is* implied by `eq:frontier` and is *not* an independent condition. The substitutions it rests on are licensed: $r_n=n^{-\alpha}$ is exact from A4(iii) (`assumptions.tex:1210`), $\hat\delta_n=n^{-\alpha}$ from A5(iii), both in (T-4). The direction claim ("shrinks as $\mu$ grows") also survives, since $\frac1{8\mu}$ is decreasing.

**What does not:** the stated margin, in two compiled files and three memo sites. This is the dispatch's headline finding and the content of its own highest-value proposed spec — the spec as *named* in §.7 would MISMATCH.

### 2.2 MAJOR (−8) — (P8)'s transfer rule is invoked to reach $o_P$ at two sites where it delivers only $O_P$.

(P8), `proofs.tex:205–216`, is stated as: conditional $O_P(a_n)$ with a $\mathcal G$-measurable $M_n$ that is **unconditionally $O_P(1)$** $\Rightarrow$ unconditional $O_P(a_n)$.

**Site 1 — `lem:epterm` Step 6, `proofs.tex:5093–5097`.** The text itself assigns $a_n:=n_k^{-1/2}$ and $M_n:=C\|\hat\psi^{(-k)}-\psi_\star\|_{L^2(P)}$ ("whose bounding constant is a fixed multiple of the $\sigma(\mathcal I_{-k})$-measurable $\|\hat\psi^{(-k)}-\psi_\star\|_{L^2(P)}$"). (P8) then yields $X_n=O_P(n_k^{-1/2})$, and $\sqrt n\,(n_k/n)\,X_n=O_P(1)$ — **not** the $o_P(1)$ of `eq:eptermbound`. The needed input, $M_n=o_P(1)$, is stated and then discarded by the rule as written.

**Site 2 — `lem:sandwich` Step 8, `proofs.tex:5157–5161`.** Same structure: conditional Markov gives $a_n=1$, $M_n=\|\hat\psi^{(-k)}-\psi_\star\|^2_{L^2(P)}=o_P(1)$; (P8) gives $O_P(1)$, the text concludes $o_P(1)$.

The conclusion is **true** and the repair is two lines (the $o_P$ companion: $P(|X_n|>\epsilon a_n)\le P(M_n>\epsilon)+E[P(|X_n|>M_na_n\mid\mathcal G)]\to0$ when $M_n\to_p0$ — the same argument (P8) already gives). But as written the step does not follow from the cited rule, at the two places that carry L-8 and $\hat\Sigma\to_p\Sigma$. (P8) lives in the header the theorist owns; it must be amended or a companion stated.

Contrast `lem:prelimtheta` Step 4 (`proofs.tex:4892–4896`), which applies (P8) **correctly** ($a_n=\delta_n$ deterministic, $M_n=C\|h_k\|/\delta_n=O_P(1)$), and `lem:sandwich` Step 2, also correct. So the defect is specific, not systemic.

### 2.3 MODERATE (−4) — `lem:momzero` invokes `cor:elldiff` under hypotheses `cor:elldiff` does not carry.

`results.tex:3936` lists A2′(i.a) but **not** A2′(i.b). `proofs.tex:4810–4812`: "By A$2'$(i.a) with B1(i), (ii), (iv.a), `cor:elldiff` gives $\|\ell_\star\|_\infty\le\ldots$". But `cor:elldiff` (`results.tex:804–806`) is stated for an **admissible representer in the sense of A2b**, and A2b (`assumptions.tex:573–581`) requires $\Lambda^{(0)}<\infty$ **and** $\Lambda^{(1)}<\infty$ **and** continuous $u$-differentiability. Further, A2′(i)'s closing clause fixes $\ell_\star$ *pointwise* "from that version" — the version satisfying (i.a) *and* (i.b) — so $\ell_\star$ is not even pointwise well-defined from (i.a) alone. The sup-norm bound is derivable from (i.a) plus B1, but the cited corollary does not say so. (T-2) lists both clauses, so `thm:rootn` is unaffected; the lemma's own list is short. This shortfall also taints the A2′(ii)-redundancy attribution — see 3.3.

### 2.4 MINOR (−1) — `def:onestep` asserts an identity whose full licence arrives later.

`results.tex:4035`: "so that $\partial_\theta\bar\psi_n(\theta)=-\hat J(\theta)$ identically". Licensed by `def:crossfit`(c) + `def:weight`(b), fine. But `thm:rootn` Step 1 (`proofs.tex:5198–5203`) additionally needs $\partial_u^2\hat L=\partial_u\hat\ell$, i.e. differentiability of $\hat\ell$, which is only in (R-a). A definition should not carry a differentiability claim whose hypothesis is stated on the theorem.

---

## Phase 3 — Assumptions and statements

### 3.1 MAJOR (−5) — `cor:ratefloor` over-claims. "The rate is in primitives" is false on the corollary's own stated branch, and $\mu'$ is undefined.

`results.tex:4259`: "the rate is in primitives." `results.tex:4268–4270`: "Every exponent in `eq:ratefloor` is a function of $(\mu,r,d_Z,s,\mu')$ through `prp:phirate`, A4(iii), A5(iv) and A8, which is what makes this a result and not bookkeeping."

Under the corollary's stated hypotheses — which include **(R-e.1)**, not (R-e.2) — two of the five terms contain rate symbols with **no primitive supplier**: $\epsilon_n$ (A5(iv) prices $\hat\ell$, and `rem:rootnscope`(3) itself says $\hat\ell$ "is priced by A5(iv) and constructed nowhere"), and $\epsilon^L_n$ (glossary C79: "$\epsilon^L_n$ is priced by nothing in the maintained block"). $s$ enters no exponent on that branch — it enters only in the (R-e.2) variant via $L_x^{-s}$. And $\mu''$ (the representer index) enters no exponent at all; it supplies a finite *constant* via `lem:reprsmooth`.

So the corollary's own scope remark and glossary row contradict its headline. The claim is correct only on the (R-e.2) branch, which is stated as the alternative.

**$\mu'$ at `results.tex:4269` is undefined project-wide.** The project's second index is $\mu''$ (A2c). I grepped the whole corpus: `\mu'` followed by a non-prime occurs at exactly this one site and nowhere else, and it has no glossary row (§1.5h registers C73–C79; none is $\mu'$). The notation sweep reported clean; this one was missed.

### 3.2 MODERATE (−4) — (R-b)'s third clause is never used.

(R-b), `results.tex:4229–4230`, assumes $E\|b_\star(\Delta Z)\|^4<\infty$. In the entire Part I proof block, $b_\star$ appears at exactly two lines — `proofs.tex:4813` and `4817` — both in `lem:momzero` Step 1, at **second** moment, supplied by A2′(iii). Nothing in Part I requires $E\|\psi_\star\|^4<\infty$: Step 8 uses conditional Markov on $\|\cdot\|^2$; Step 10's Cauchy–Schwarz needs $\mathbb E_n\|\psi_\star\|^2=O_P(1)$; the CLT is Lindeberg–Lévy. The fourth-moment need is on $\hat b$, and (R-a) supplies that separately.

This is pointed because the dispatch claims a clause-level audit and identifies exactly three non-uses — all three in the *maintained* block (A2′(ii), A5(v), A1b(ii)) — while carrying an unused clause in its **own new** hypothesis. `rem:rootnhyp`(1) closes with "(R-a), (R-b), (R-c), (R-e) — as stated", asserting consumption without a site.

### 3.3 The three claimed non-uses — verified independently, one with a caveat

- **A5(v): VERIFIED.** I grepped `A5(v)` across all `.tex`: the only live occurrences are the two "concern other objects and are untouched" pointers and Part I's own non-use statements. Consumed nowhere in the corpus. The reason given (no plug-in Landweber pass, because the $\varphi$-step runs at $\theta_\circ$) is correct.
- **A1b(ii): VERIFIED.** A1b(ii) (measure separability, `assumptions.tex:104–105`) is consumed only by `lem:nusigma`(ii) (`results.tex:712–713`), and Part I consumes (i), (iii), (iv), (v) only. I checked for hidden need: nothing in Part I requires $\ker\Delta\cap\mathcal V=\{0\}$; identification of $\theta_\dagger$ runs through A1b(iv), of $\vdagger$ through A1b(iii) assumed directly.
- **A2′(ii): SUBSTANTIVELY VERIFIED, MIS-ATTRIBUTED.** $E[\widetilde W^2\|\ell_\star\|^2]\le\|\ell_\star\|^2_\infty<\infty$ under (P1) is right, and A2′(ii) is indeed implied — but by A2′(i) **in full** plus B1(i),(ii),(iv.a), not by "A$2'$(i.a)" as `results.tex:3953` and `rem:rootnhyp`(2) both say. Since A2′(i) is maintained in both clauses the deletion the claim invites is still safe; the attribution is not. See 2.3.

### 3.4 MODERATE (−5) — A5(iv)/(R-e.1) is consumed at $\mathsf F$ fold-specific estimators it does not name.

A5(iv) (`assumptions.tex:1399–1404`) prices a **single** $\hat\ell$, "of which `lem:balance` fixes the measurability and the fold" — `lem:balance`'s fold being the two-way $(\mathcal I_a,\mathcal I_m)$. (R-e.1) is bare "A5(iv)". But `thm:rootn` Step 4(a) and `lem:sandwich` Step 3 consume it at $\hat\ell^{(-k)}$ for $k=1,\dots,\mathsf F$, and the conclusion "Summing over the fixed $\mathsf F$ folds" needs $\max_k\|\hat\ell^{(-k)}-\ell_\star\|_{L^2(P)}=O_P(\epsilon_n)$.

The author demonstrably knows this matters: `def:crossfit`(a) fold-indexes A4(iii) explicitly ("with $n$ replaced by $n_{-k}$"); (R-a) writes $\max_{k\le\mathsf F}$ four times; **(R-e.2) writes $\max_k\|\hat\ell^{(-k)}-\ell_\star\|_{L^2(P)}=o_P(1)$**. (R-e.1) is the one branch left un-indexed. The fix is a $\max_k$; the omission is squarely on the axis this dispatch claims to have audited.

Same class, lower weight: `lem:epterm` and `lem:prelimtheta` list A5(ii) and A5(vi) bare while consuming $h_k$; that is repaired only *inside* `thm:rootn` Step 0, so the two lemmas are short as standalone statements.

### 3.5 MODERATE (−4) — Hypothesis-accounting contradictions in the theorem and corollary lists.

(a) **(T-4) vs Step 0.** (T-4) (`results.tex:4211–4212`) assumes A5(i), (ii), (iii). `thm:rootn` Step 0 (`proofs.tex:5194`) says of (T-5): "*That discharges A5(i)–(iii) rather than assuming them*". Both cannot be right about the same list. A5(i)–(ii) are indeed redundant given (T-5) + A5(iii); A5(iii) is a restriction on primitives $(\mu,r,d_Z)$ and **cannot be discharged by any proposition** — `prp:phirate` delivers $\delta_n=o_P(n^{-1/4})$ only "whenever `eq:frontier` holds".

(b) **`cor:ratefloor` reaches inside its lemmas.** Its hypotheses (`results.tex:4260–4261`) drop (T-4) entirely, yet it invokes `lem:epterm`, whose stated list includes A5(ii) **and** "A5(vi) with $s>\tfrac12$". A5(vi) is recoverable via (T-5), but **$s>\tfrac12$ appears nowhere in `cor:ratefloor`'s hypotheses** and `lem:epterm` Step 2 needs it for the embedding $H^s(\mathcal X)\hookrightarrow C(\mathcal X)$. It also invokes `lem:sandwich`(i) while conceding its list is not met ("its Step 3 needs only $\delta_n\to0,\epsilon_n\to0,r_n\to0$") — honest, but it means the lemma as stated is not applicable and the corollary depends on a proof-internal reading. A clause (i′) at the weaker hypotheses is what the corollary actually needs.

(c) MINOR: (T-4) forward-references `eq:deltalog`, defined in a *later remark*, for a maintained clause that now states the same thing in `assumptions.tex`.

### 3.6 MODERATE (−4) — The stated ground for not promoting (R-a)/(R-b) to A5 is false, and `rem:obligations` was not updated.

**(a)** The line is "every A5 clause prices a *rate in $n$*, and (R-a), (R-b) are qualitative" (memo §.5), inherited from `results.tex:1570`: "Every clause of A5 prices a rate in $n$". That is **not** how A5 reads. A5(vi) (`assumptions.tex:1418–1419`) is $\|h\|_{H^s}=O_P(1)$ — a qualitative stochastic-boundedness statement with no rate in $n$, of *exactly* (R-a)'s type. A5(vi′) (`assumptions.tex:1420–1432`) is a w.p.$\to$1 envelope at a fixed radius — likewise. The *decision* to keep (R-a)/(R-b) on the theorem is defensible and I would keep it; the *reason* is not, and it is a reason the block already contradicted when A5(vi) was added in round 7.

**(b)** `rem:obligations` (`results.tex:1507–1508`) still reads "four obligations ... (O1) is discharged as of Step 4, (O4) as of Step 6, and **two remain open**". If (R-a) discharges (O3) — as the memo §.5 claims, and I agree it does, by assuming the one property `eq:dirmember` needs — and (R-c) prices (O2), then the file's own declared single inventory ("All of them are inventoried in one place ... where a reader should be sent") now understates the state. Neither is recorded there.

### 3.7 (R-a) route (α) — **VERIFIED SUFFICIENT**, site by site

I checked every use. $\|\partial_u\hat\ell\|_\infty$: `eq:shiftFTC` (needs $C^1$ + continuity), the MVT bound on $\Psi^{(1)}$, `lem:sandwich` Step 3 brace 1, Step 5's Lipschitz-in-$\theta$ step, `thm:rootn` Step 1's Hessian envelope. $\|\hat\ell\|_\infty$: `eq:biasb3`, `lem:epterm` Steps 3 and 5, `lem:sandwich` Steps 2, 3, 9. $E\|\hat b\|^4$: `lem:epterm` Step 5. $\|\hat L-L_\star\|_{L^2(P)}=o_P(1)$: `lem:epterm` Step 4. **All five clauses of (R-a) are consumed.**

The key point the memo makes is right and worth confirming: route (β) is genuinely avoidable because **every shifted evaluation of $\hat\ell$ is bounded by a sup-norm** ($\|\int_0^1\hat\ell(\Delta U-\lambda\Delta h)\|\le\|\hat\ell\|_\infty$; the $\Psi^{(1)}$ difference by $\tfrac12|\Delta h|\|\partial_u\hat\ell\|_\infty$), while `eq:biasb1` evaluates $\hat\ell-\ell_\star$ at the **unshifted** $(\Delta U,\Delta Z)$ — exactly the norm A5(iv) prices. So the shift-uniform seminorm $\|\cdot\|_{0,h}$ is never needed, and `rem:supinside`'s objection is correctly routed around rather than dodged.

### 3.8 `lem:epterm`'s concession and `lem:prelimtheta`'s rate — both check

- **The concession is precisely right and no weaker.** Cross-fitting needs exactly three things: fold independence (A0), $\sigma(\mathcal I_{-k})$-measurability of $\hat\zeta^{(-k)}$, and $L^2(P)$-consistency at *frozen* nuisances. The conditional-variance bound $\frac1{n_k}\|\hat\psi^{(-k)}-\psi_\star\|^2_{L^2(P)}$ is correct, and $\sqrt n(n_k/n)n_k^{-1/2}\le1$ is correct. The contrast drawn with `lem:unifop` (a uniform LLN with a rate over a slowly growing ball, at scale $\hat\delta_n\gg n^{-1/2}$, charged in the $\varphi$-step) is the right one, and the $\theta$-step genuinely concedes nothing at scale $n^{-1/2}$. Subject only to 2.2.
- **`lem:prelimtheta`'s rate IS what Step 2 consumes.** Step 2 needs $\sqrt n\|\hat\theta^{(0)}-\theta_\dagger\|^2=o_P(1)$; from the un-collapsed $O_P(n^{-1/2})+O_P(\delta_n)$ this holds iff $\delta_n=o(n^{-1/4})$, which is A5(ii)'s second half. The $o_P(n^{-1/4})$ threshold statement is exactly the right one, and m-23 **is** discharged. The negative answer on `eq:prelimrate` is correct: it is a condition on $\varsigma_0$, the exponent of $\hat\varepsilon_0$, i.e. (P-a.2) about $\hat\varphi^{(0)}$, and bears on nothing about $\theta$.

### 3.9 MINOR (−1 each, −4 total)

- **(m1)** `rem:rootnhyp`(2) is headed "*Listed and not consumed*" but A2′(ii), A5(v), A1b(ii), A6 are **not listed** in (T-1)–(T-5) at all. An auditor reading the heading will charge the theorem with hypotheses it does not carry.
- **(m2)** `lem:epterm`'s headline ("$o_P(n^{-1/2})$ under consistency in $L^2(P)$ alone — no entropy condition, no Donsker property") describes the `eq:psiL2` $\to$ `eq:eptermbound` step, not the lemma, which needs A5(vi), $s>\tfrac12$, (R-a), (R-b) and A4(iii) to *reach* `eq:psiL2`. The concession paragraph is precise; the headline is not.
- **(m3)** `lem:prelimtheta` (`results.tex:4080–4081`) says the collapse to $O_P(\delta_n)$ "is *cosmetic and is not on the path to* `thm:rootn`". `thm:rootn` Step 2 (`proofs.tex:5228`) opens: "By `lem:prelimtheta`, $\|\hat\theta^{(0)}-\theta_\dagger\|=O_P(\delta_n)$" — the collapsed form. Licensed (A5(i),(iii) are in (T-4)), but the annotation is self-contradicting.
- **(m4)** `prp:medianpart`'s "Suppose the hypotheses of `thm:rootn`" must be read *per partition* — (R-a), (R-e.2) quantify $\max_{k\le\mathsf F}$ within one partition, and $\mathsf P$ partitions give $\mathsf P\mathsf F$ distinct fold complements. Not stated.

---

## Phase 4 — The $\ln n$ resolution: justification tested, sweep incomplete

### 4.1 The justification **holds** — verified at all four sites, and it is stronger than the memo claims

- **(P-f):** `results.tex:3529–3530` states $\delta_n^2=O(h_u^2\hat\delta_n\ln n)$; `proofs.tex:4676` gives the equivalent form $(\hat\delta_n\ln n)^{2\kappa-1}=O(h_u^2)$, which **only follows if $\delta_n^2=(\hat\delta_n\ln n)^{2\kappa}$**. Reads log-inflated. ✓
- **`rem:h6bandwidth`(0):** `proofs.tex:4684` prints $\delta_n^2=\hat\delta_n^{2\kappa}(\ln n)^{2\kappa}$ explicitly. ✓
- **`prp:stopfeas`(iv):** `results.tex:2928` — "in which the left side **now carries** $(\ln n)^{4\mu/(2\mu+1)}$". Reads log-inflated. ✓ But `results.tex:2919–2920` reads it log-**free** (see 4.2). So this clause is **internally inconsistent** — which *strengthens* rather than weakens the decisive claim "the block was already inconsistent with itself." The amendment is a repair, not an absorption of an inconvenience. I endorse route (A).

### 4.2 MAJOR (−7) — The sweep the amendment requires was not run. Two live sites now assert falsehoods about A5(ii).

**(a) `rem:phirscope`(2), `results.tex:3819–3823` — compiled text, now flatly false:**

> "$\delta_n$ in `eq:phirate` is $(\hat\delta_n\ln n)^{2\mu/(2\mu+1)}$ and not $\hat\delta_n^{2\mu/(2\mu+1)}$. **A5(ii) writes the latter.** The two differ by $(\ln n)^{2\mu/(2\mu+1)}$ ... a downstream result that reads A5(ii) literally and then substitutes a power of $n$ will be off by that factor."

A5(ii) as amended (`assumptions.tex:1370–1375`) writes the **former**. The memo §.3 asserts "the `rem:phirscope`(2) warning is now **discharged rather than carried**." It is carried, verbatim, in its pre-amendment form, contradicting a maintained clause. Two files of the corpus now disagree about what A5(ii) says.

**(b) `prp:stopfeas`(iv) first display, `results.tex:2919–2920`:** "Replacing $\hat\delta_n$ by $\hat\delta_n\ln n$ replaces $\delta_n$ by $\delta_n(\ln n)^{2\mu/(2\mu+1)}$." Under amended A5(ii) this reads $(\hat\delta_n\ln n)^\kappa(\ln n)^\kappa=\hat\delta_n^\kappa(\ln n)^{2\kappa}$ — a *second* inflation, not the object A7's amendment produces. The sentence uses $\delta_n$ for the pre-amendment rate, which is precisely the collision A5(ii)'s "*One symbol, one object, from here on*" was written to end. Same class, lower weight (comments, not compiled): `assumptions.tex:1588` ("A5(ii) constrains delta_n = delta-hat_n^{2 mu/(2 mu+1)}") and `assumptions.tex:1816–1818`.

### 4.3 The rest of the consequence table — **VERIFIED**

| Claim | Verdict |
|---|---|
| $\delta_n^2=o(n^{-1/2})$ free; `eq:frontier` unchanged | ✓ $n^{-1/2-2\varepsilon}(\ln n)^{2\kappa}$ |
| $r_n\delta_n$ free and implied | ✓ implication; ✗ margin (2.1) |
| $\delta_n\epsilon_n$ **not** free, charged to L-13 | ✓ $\epsilon_n$ must shrink by $(\ln n)^\kappa$; correctly charged, not absorbed |
| $r_n\epsilon^L_n$ unaffected | ✓ no $\delta_n$ |
| `eq:muhalf` $\mu>\tfrac56$ unmoved | ✓ I recomputed: $h_u\asymp\hat\delta_n^{1/8}$ gives $\alpha(2\kappa-1)>\alpha/4\iff\kappa>\tfrac58\iff\mu>\tfrac56$, at the log-inflated $\delta_n$ |
| `eq:frontier`, `eq:lxwindow` unmoved | ✓ `eq:lxwindow` is in $(L_x,h_u,s,\alpha)$ only |
| A5(v) weaker | ✓ RHS inflated |
| A5(iii)'s "iff" correct at the boundary | ✓ $\kappa\alpha=\tfrac14$ gives $n^{-1/4}(\ln n)^\kappa\ne o(n^{-1/4})$ |

### 4.4 MINOR (−1 each, included in the −4 above)

- **$\Psi^\theta_n$ "written out" is false.** `results.tex:4131–4133` claims `prp:sharpquad`'s precedent is "followed where it can be, at the $\theta$-remainder and at the Hessian envelope ... **both of which are written out**." $\Psi^\theta_n$ is a symbol: registered at glossary C77 (`notation_glossary.md:594`) and used at `proofs.tex:5214, 5216, 5221, 5230, 5286, 5307`. The glossary row is careful and correct (it names the Hessian envelope and the event, not the remainder); the `results.tex` sentence is not. Also note the stated separation device — "$\Psi(\tau)$ always carries an argument and $\Psi^{(j)}_k$ never does" — does not separate $\Psi^{(j)}_k$ from $\Psi^\theta_n$.
- **(P8) scope.** Part I's standing convention (`proofs.tex:4789–4792`) says "(P8) is stated at a GENERIC sigma-field, so this is a reading and not an extension." The *transfer rule* is generic; the *conditioning convention* is stated "Throughout **Part H**" at $\sigma(\mathcal I_a)$. `def:crossfit` properly re-declares it for Part I, so the extension is licensed — the sentence overstates.

### 4.5 Declared-open items — the declaration is **honest**, one omission

All seven of §.6 are declared in the right place and at the right strength. Specifically:

- The **LR-correction contradiction** is placed correctly (closing paragraph of `lem:sandwich`, the statement whose conclusion *is* the variance) and stated at full strength: it names the two claims, says they cannot both hold, and says which side the proof is on ("*a consequence of `prp:orthog`(iii) under N1: the $\varrho$-derivative of the moment vanishes exactly*"). I verified the underlying orthogonality: perturbing $\varrho\to\varrho+\tau_3\mathsf r$ gives $-E[\mathsf r(\Delta Z)E[L\mid\Delta Z]]=0$ under N1 and only under N1. No correction term is right. Routing to the writer is correct — the positioning section is not the theorist's file. **No deduction.**
- (P-a.3)/$\mu$ primitive, $\hat\varepsilon_0$ unsupplied, $\hat\ell$ unconstructed, (O2) open with (R-c) pricing failure, A2′(ii) redundancy, alphabet exhausted: all declared, none understated. `rem:rootnscope`(3)'s "*a theorem about an estimator four of whose ingredients are assumed to exist with stated properties*" is the honest form.
- **Omission:** §.6 lists $\hat\varepsilon_0$ and $\hat\ell$ as unsupplied but not **$\epsilon^L_n$**, the third unsupplied rate symbol, live inside (R-c.2). The *file* records it (glossary C79, and `thm:rootn` states it); the memo's open-items list is short by one. Folded into 3.1's over-claim, since that is where the omission bites.

---

## The four owed specs (§.7) — three are right, one is the wrong fourth

| Spec | Verdict |
|---|---|
| `rootn-frontier-implies-rndelta.yaml` | **Keep, and it is the highest-value one — but rewrite the claim.** As named it asserts margin $\frac{1-\kappa}{4\kappa}=\frac1{4\mu}$, which is false (finding 2.1). Written as stated it will MISMATCH, and the mismatch will be misread as a harness fault. Write it at $\frac1{8\mu}$, and add a falsification arm at $\kappa\alpha=\tfrac14$ where $\alpha(1+\kappa)-\tfrac12$ must equal exactly $\frac{1-\kappa}{4\kappa}$. |
| `rootn-log-absorption.yaml` | **Keep.** The boundary half is the right thing to mechanise. |
| `rootn-jacobian-sign.yaml` | **Keep.** Cheap, and a sign error here is invisible in the limit law. |
| `rootn-biasexp-identity.yaml` | **Weakest of the four; demote.** I verified the decomposition by hand in five lines and it is exact. A bi-affine surrogate will confirm it trivially and will not touch anywhere an error changes a conclusion. |

**Two that should replace or precede it:**

1. **`rootn-rate-products.yaml`** — the five-term order list of `eq:ratefloor`, and that each of the four products is $o(n^{-1/2})$ under (T-4)+(R-c)+(R-e), evaluated at $r_n=n^{-\alpha}$, $\hat\delta_n=n^{-\alpha}$, $\delta_n=(\hat\delta_n\ln n)^\kappa$, with the falsification arm at $\kappa\alpha=\tfrac14$ where three of the four must fail. **This is where an arithmetic error moves a conclusion**, and it is exactly the bookkeeping 2.1 got wrong.
2. **`rootn-prelim-threshold.yaml`** — $\sqrt n(n^{-1/2}+\delta_n)^2=o(1)\iff\delta_n=o(n^{-1/4})$, i.e. Step 2's exact threshold, with the arm at $\delta_n\asymp n^{-1/4}$. This is the m-23 discharge, the newly closed gap; it earns mechanisation ahead of an identity that is five lines of algebra.

**And one that is not a SymPy spec.** Findings 4.2(a)–(b) would have been caught by a blocking grep row, not by symbolic algebra: assert that no live text asserts A5(ii) $=\hat\delta_n^{2\mu/(2\mu+1)}$, and that no live text writes $\delta_n(\ln n)^{2\mu/(2\mu+1)}$ as a *substitution target*. The project already runs `check_rendering_sync.py` with blocking rows (glossary §1.5b); that is the right home.

---

## Score

| # | Finding | Severity | Δ |
|---|---|---|---|
| 2.1 | $\frac{1-\kappa}{4\kappa}=\frac1{4\mu}$ false (correct $\frac1{8\mu}$); 2 compiled sites + both numbers | **MAJOR** | −10 |
| 2.2 | (P8) invoked for $o_P$ at 2 sites where it delivers $O_P$ | **MAJOR** | −8 |
| 4.2 | `rem:phirscope`(2) stale and false; `prp:stopfeas`(iv) unswept; memo claims discharge | **MAJOR** | −7 |
| 3.1 | `cor:ratefloor` "rate is in primitives" over-claim; $\mu'$ undefined | **MAJOR** | −5 |
| 3.4 | A5(iv)/(R-e.1) not fold-indexed while (R-a)/(R-e.2)/A4(iii) are | MODERATE | −5 |
| 3.2 | (R-b)'s $E\|b_\star\|^4<\infty$ unused | MODERATE | −4 |
| 3.5 | (T-4) vs Step 0 on A5(i)–(iii); `cor:ratefloor` outside its lemmas' lists; $s>\frac12$ missing | MODERATE | −4 |
| 2.3 / 3.3 | `cor:elldiff` cited on A2′(i.a) alone; A2′(ii) redundancy mis-attributed | MODERATE | −4 |
| 3.6 | "every A5 clause prices a rate in $n$" false; `rem:obligations` not updated | MODERATE | −4 |
| 2.4, 3.9(m1–m4), 4.4 | six MINORs | MINOR | −4 |
| | **Total** | | **−52** |

**Score: 48 / 100.** Below the 80 commit gate. **No CRITICAL finding, so I raise no binary-gate block**: every theorem in Part I is proved, the counterexample question is untouched by anything here, and 2.2's conclusion is true and repairable in two lines.

## Priority order for the fix pass

1. **[MAJOR 2.1]** Correct $\frac{1-\kappa}{4\kappa}=\frac1{8\mu}$ and both numbers ($\tfrac3{20}$, $\tfrac1{16}$) at `results.tex:4341`, `proofs.tex:5268`, and the three memo sites. The implication and the direction claim stand — do not withdraw the finding, restate the margin.
2. **[MAJOR 2.2]** State an $o_P$ companion to (P8) in the `proofs.tex` header and cite it at `lem:epterm` Step 6 and `lem:sandwich` Step 8.
3. **[MAJOR 4.2]** Rewrite `rem:phirscope`(2) and `prp:stopfeas`(iv)'s first display at the amended symbol; sweep the two `assumptions.tex` comments. The memo's "discharged rather than carried" is only true after this.
4. **[MAJOR 3.1]** Scope `cor:ratefloor`'s "in primitives" claim to the (R-e.2) branch; delete or define $\mu'$.
5. **[MODERATE 3.4]** Add $\max_{k\le\mathsf F}$ to (R-e.1)'s reading of A5(iv), on the model (R-e.2) already sets.
6. **[MODERATE 3.2, 3.5, 2.3, 3.6]** Drop (R-b)'s third clause or name its site; reconcile (T-4) with Step 0; add A2′(i.b) to `lem:momzero`; replace the A5-promotion rationale and update `rem:obligations`.

## Positive findings

1. **`lem:biasexp` is the real contribution and it is right.** Three exact identities and no Taylor expansion in the nuisances; I reassembled the whole decomposition and every term, sign and constant lands. The claim that three of the six second-order terms vanish *identically* by bi-affineness is correct and is a genuine structural result, not bookkeeping.
2. **The anchor device is licensed, not convenient.** Running the $\varphi$-step at a pre-data $\theta_\circ$ removes the circularity outright, and the licence (invariance of conditional independence given $\Delta Z$ to adding functions of $\Delta Z$) is exactly right. Reading `prp:phirate`'s hypotheses at $\theta_\circ$, and saying that $a,\mu,\mathsf R_\ast,\hat\delta_n$ are $\theta_\circ$-specific, is the honest form.
3. **(R-a) route (α) is the correct call and (β) is genuinely avoidable.** Every shifted evaluation is bounded by a sup-norm and `eq:biasb1` is at the unshifted argument — so A5(iv)'s norm suffices and the shift-uniform seminorm never enters. This was assessed and decided, not dodged.
4. **`lem:epterm`'s concession is exactly what cross-fitting needs and no weaker**, and the contrast with `lem:unifop` (rate-bearing uniform LLN at scale $\hat\delta_n\gg n^{-1/2}$, charged in the $\varphi$-step) is the right distinction to print. Subject only to 2.2's rule gap.
5. **The ordering discipline in `thm:rootn`.** `lem:sandwich`(i) before the limit, (ii) after, with the reason stated and the non-interchangeability flagged — and it is genuinely non-interchangeable.
6. **m-23 is discharged, and the negative answer on `eq:prelimrate` is correct.** `eq:prelimrate` is about $\hat\varphi^{(0)}$ via (P-a.2), not about $\theta$; `lem:prelimtheta` is the right instrument and its threshold is the one Step 2 consumes.

---

## Orchestrator verification appended 2026-07-30

**Finding 2.1's arithmetic checked symbolically before the fix round was briefed.** With $\kappa=2\mu/(2\mu+1)$, SymPy reduces $(1-\kappa)/(4\kappa)$ to $1/(8\mu)$; it is **not** $1/(4\mu)$. At $\mu=\tfrac56$ the margin is $\tfrac3{20}$, at $\mu=2$ it is $\tfrac1{16}$ — both a factor 2 below what the dispatch printed. **And the implication survives with the margin exact at the frontier boundary:** $\alpha(1+\kappa)-\tfrac12-\frac{1-\kappa}{4\kappa}$ evaluates to exactly $0$ at $\alpha=\frac1{4\kappa}$, and $\frac1{8\mu}$ is decreasing in $\mu$, so the direction claim holds too. The critic is right on every part, including that the finding should be **restated rather than withdrawn**.

**Findings 4.2(a) and 3.1's $\mu'$ claim confirmed by direct inspection.** A5(ii) as amended writes the log-inflated form; `rem:phirscope`(2) at `results.tex:3820` still says "A5(ii) writes the latter" (log-free). `\mu'` followed by a non-prime occurs at exactly one site, `results.tex:4269`.

**The critic's non-spec recommendation was implemented.** A blocking `OCCURS_NOWHERE` row was added to `check_rendering_sync.py` CHECK 6. It is deliberately narrow — present-tense attribution only — because the log-free glyph also occurs at `results.tex:4304` and `assumptions.tex:1378` in **legitimate past-tense narration**, so a row on the bare glyph would fire on all three and be switched off. It now fires on exactly `results.tex:3820`. Adding it also exposed a latent bug in CHECK 6: `OCCURS_NOWHERE` was documented as taking a bare regex while the code required a `(regex, keys)` pair, so the documented form was unusable until an instance existed — the same unexercised-path failure as the `RETIRED-MENTION` opt-out.
