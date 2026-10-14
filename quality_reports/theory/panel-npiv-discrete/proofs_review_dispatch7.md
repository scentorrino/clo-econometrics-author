# Theory Review — Part H (memo §10 Step 6) + Part G fix pass

**Reviewer:** theorist-critic · **Severity:** HIGH (Execution) · **Gate:** 80 · **Strike 1 of 3**
**Persisted by the orchestrator.**
**Read:** merged Part H in `results.tex` (2139–2895) and `proofs.tex` (2709–3635), the retained drafts, `assumptions.tex` (A4–A8, C1–C5′, H1, A2c, `def:hatA`), `notation_glossary.md`, `step6_memo.md`, `theory_memo.md` §D-000000000. **Arithmetic verified independently rather than read off the specs.**

## SCORE: **58 / 100 — DOES NOT CLEAR.**

| | Count |
|---|---|
| CRITICAL | **2** |
| MAJOR | 8 |
| MODERATE | 5 |
| BLOCKING (librarian, not charged) | 1 |

**Verdict: the A6 refutation is sound in substance; `prp:phirate` is not yet a theorem.**

*Critic's scoring note: "Proportional application — the rubric's flat −20/gap is calibrated for a single-theorem section; this dispatch contains fourteen numbered results and a large volume of correct work. Items are weighted by risk-to-conclusion plus cost-to-repair."*

---

## PRIORITY 1 — `prp:tccfails` VERIFIED END TO END. It holds.

All four requested checks passed:

1. **The spike is $o(1)$ in $L^2(\pi)$.** $\int\varTheta_k^2dx=\tfrac23\epsilon_k$, so $\|v_k\|_{L^2(\pi)}\le2\|\pi\|_\infty^{1/2}(\tfrac23\epsilon_k)^{1/2}\to0$ — **including the factor 2 from centring into $\mathcal V$.** ✓
2. **`eq:hatAcon` does not see it.** $\hat{\mathcal A}_{\tilde\varphi}$ acts on $h$ only through $\Delta_{h_x}h_i$; $|\Delta_{h_x}v_{k,i}|\le2\mathsf c_2h_x^{-1}(\epsilon_k+\|\pi\|_\infty\epsilon_k|\mathcal X|)\to0$ **at fixed $n$** — and the quantifier order ($n$ fixed, $k\to\infty$) is right, since A6 is a statement at each $n$. ✓
3. **`eq:hatT` moves by a fixed amount.** $\Delta v_{k,i^\ast}\to1$, others $\to0$; $\mathsf C_{h_u}(w+1)-\mathsf C_{h_u}(w)=1$ on a set nonempty iff $h_u<1/(2c_C)$ (C5′(i)); $\|\Xi_\ast\|>0$ by B1(iv.a)+B1(ii). ✓
4. **"No model assumption."** The *proposition* is honest — it lists A0, A4(i), B1(i),(ii),(iv), C1(ii), C3. **The orchestrator's paraphrase was stronger than what is proved**: `def:model`'s continuity of $X$, B1(iv.a) and C5′(i) are all used. Not a defect in the file.

### The result is STRONGER than stated — an under-claim
Nothing in Steps 1–4 uses the specific construction: **any bounded operator $\mathcal V\to L^2(\Pi)$ sends $v_k\to0$ while $\hat T$ moves by $\Xi_\ast$.** So **no bounded operator whatsoever can serve as $\hat{\mathcal A}_{\tilde\varphi}$ in A6.** State it that way — it matters, because `def:hatAcon` itself flags a deviation from `def:hatA`'s literal prescription, and the construction-free form immunises the refutation against that deviation. It also disposes of the raw-Gateaux reading, where $\|\mathrm d\hat T[v_k]\|\asymp n_{\rm m}^{-1}h_u^{-1/2}\gg\eta\|\Xi_\ast\|\asymp n_{\rm m}^{-1}$.

---

## CRITICAL

### 2.1 (−10) — the estimator does not implement the stopping rule the proof analyses
`def:lfstep`(c) (`results.tex:2753–2755`) stops at a **fixed** threshold $\tau_{\rm DP}\hat\delta_n\ln n$, identical at every stage. `prp:phirate` Step 2 (`proofs.tex:3526`) analyses a **stage-dependent** one at level $\tau_{\rm DP}\hat\delta_n^{\rm eff}$, $\hat\delta_n^{\rm eff}=\mathsf c_{14}(\hat\delta_n\ln n+h_u^{-2}\varepsilon^2)$.

**These are not the same rule and the gap is not asymptotically negligible.** Step 4(a) — the contraction regime, which the proof *must* enter since (P-a) gives only $\delta_n^{(0)}=o_P(1)$ and $h_u^{-2}\to\infty$ — is **defined** by $h_u^{-2}(\delta_n^{(k-1)})^2\ge\hat\delta_n\ln n$, exactly where $\hat\delta_n^{\rm eff}\gg\tau_{\rm DP}\hat\delta_n\ln n$. There the implemented threshold sits **below** the true data error; the classical DP guarantee does not apply, and what happens instead is noise over-fitting or no stop before the cap — **precisely the failure the block's own A7 comment names** (`assumptions.tex:1532`: *"Without A7 THE DISCREPANCY PRINCIPLE NEVER STOPS … the estimator is whatever the iteration cap returns, with no rate."*).

**Repair:** make `def:lfstep`(c) stage-adaptive, e.g. $\tau_{\rm DP}\mathsf c(\hat\delta_n\ln n+h_u^{-2}\hat r_{k-1}^2)$ with $\hat r_{k-1}$ the realised residual — implementable, since the procedure already needs $\hat\delta_n$ — then re-derive Step 4. **Until then `eq:phirate` is a rate for an estimator the file does not define.** Secondary: `def:lfstep`(c) does not say what $\hat m^{(k)}$ is when the set is empty.

### 2.2 (−8) — `eq:linlf` is asserted; the operator-noise route is undecided
**(a) No proof and no resolvable pin.** The display carrying the entire proposition has **no `\cite` at all**. Its natural pin is `engl2000` Ch. 6 — **absent from `references.bib`.** Part G's stated practice (prove inline at the strength consumed, or NAME the intended pin in a comment) is followed scrupulously for (F-d) and (F-e) and **abandoned here, at the one place it matters most.**

**(b) The setting is not the classical one, and the block says so** (`assumptions.tex:1524–1527`: *"hanke1995 proves the DP for an EXACTLY KNOWN operator with NOISY DATA. Here the noise is IN THE OPERATOR."*). Two readings, and the proof runs both:
- *Conditional-on-sample* — classical theory applies verbatim, **but then $\gamma_n$, (P-b) and `lem:aerr` are idle**, the third term of `eq:linlf` should not be there, and one of the four newly charged lines evaporates.
- *Perturbation of $\mathcal A$* — then the source condition must transfer from $\mathcal A$ to $\hat{\mathcal A}$, **which `lem:srctransfer`(ii) says is impossible for $\mu>\tfrac12$** — the exact regime the proposition inhabits.

**(c) A missing step under either reading.** The link condition is stated **on $\mathcal S_n$**, but $v_\dagger=\vdagger-\hat\varphi^{(k-1)}\notin\mathcal S_n$. The source condition does not apply to $v_\dagger$ as written; one must pass to its sieve projection and account for the residual. (P-c) is presumably meant to pay for this; **the substitution is never performed.**

---

## MAJOR

### 2.3 (−3) — `lem:srctransfer`(ii)'s counterexample refutes itself
`proofs.tex:3461–3467` takes $\hat\sigma_j=\sigma_j+\gamma$ (upward) and argues membership fails because $\sigma_j^{4\mu}/(\sigma_j+\gamma)^{4\mu}\to0$. **That ratio is $\le1$, so $|\tilde\varsigma_j|\le|\varsigma_j|$ and $v$ IS in the set** with $\mathsf M=\mathsf R$ — the ratio tending to zero makes membership *easier*. The next sentence is a non sequitur.
**The claim is true; an upward perturbation cannot witness it.** Use a **downward** one: $\hat\sigma_J=\sigma_J-\gamma'$ with $\gamma'\uparrow\sigma_J$, so $\|\hat{\mathcal A}-\mathcal A\|=\gamma'\le\sigma_J$ is small for large $J$ while $\tilde\varsigma_J=\sigma_J^{2\mu}/(\sigma_J-\gamma')^{2\mu}$ diverges. **Load-bearing for the positioning argument** — `rem:lfnonlinear`(3) cites it as "the same Heinz-inequality barrier."

### 2.4 (−3) — (P-f)'s logarithms decide the boundary, and they decide against it
The power-of-$n$ algebra is right (verified: $\alpha\frac{2\mu-1}{2\mu+1}\ge\tfrac18$; $\mu=2\Rightarrow\alpha\ge\tfrac5{24}$; $\mu=\tfrac34\Rightarrow\alpha\ge\tfrac58$ impossible; re-tuning gives $\mu\ge\tfrac56$ free of $\alpha$).
**But (P-f) is an exact domination and both sides carry logs.** $\delta_n^2$ carries $(\ln n)^{4\mu/(2\mu+1)}$, the right side $(\ln n)^1$, and $\frac{4\mu}{2\mu+1}>1$ **precisely when $\mu>\tfrac12$** — i.e. always, here.
- **At the reference configuration $(\mu,d_Z,r)=(1,3,4.5)$** — which `rem:h6bandwidth`(1) calls "exactly at the boundary" and `rem:l19cost` uses as the running example — LHS $=n^{-1/2}(\ln n)^{4/3}$, RHS $=n^{-1/2}\ln n$. **(P-f) fails by $(\ln n)^{1/3}$.**
- **The threshold must be $\mu>\tfrac56$ STRICT**, not $\ge$.

This is what the A7 amendment costs, and `prp:stopfeas`(iv)'s "costs nothing" is right about `eq:frontier` and **silent about (P-f)**.

### 2.5 (−2) — "with probability one" is not established
`proofs.tex:2914–2916` derives $\widehat{\widetilde W}_{i^\ast}\ne0$ from **A4(i), which constrains $\varrho$, not $\hat\varrho$.** And `def:hatTexp` **creates** the problem it ignores: truncating $\hat\varrho$ to $[0,1]$ makes $\hat\varrho\in\{0,1\}$ positive-probability, so $\widehat{\widetilde W}_i=0$ occurs; on the event that it holds for all $i\in\mathcal I_m$, $\hat T\equiv0$, $\hat{\mathcal A}\equiv0$, and **A6 holds trivially.** Same sentence at `prp:hatAprop` Step 7.
**Two free repairs:** (a) truncate to $[\varepsilon_\varrho,1-\varepsilon_\varrho]$ — free under A4(i), preserves A4(iii), fixes both sites; or (b) restate as $P(\cdot)\le(1-\varepsilon_\varrho)^{n_{\rm m}}\to0$, **which already suffices since A6 is itself a $P(\cdot)\to1$ statement.** (a) is cleaner.

### 2.6 (−2) — four unstated hypotheses, one an undocumented fifth budget line
| Invoked | Where | Status |
|---|---|---|
| $\mathsf R\,h_x^{s-1/2}=O(\hat\delta_n)$ | Step 1 via `lem:unifop` Step 4 | **not stated; an UPPER bound on $h_x$, which C5′ does not carry at all** |
| `eq:entropyA` | Step 2 via `lem:aerr` | not stated |
| $\mathsf R\,h_x^{s-1/2}=o(1)$ | Step 2 via `lem:aerr` | not stated |
| A5(vi) **at every stage** | Step 5 via `lem:pathcont` | not stated |

The first is a genuine **fifth** new line. Satisfiable — at $(1,3,4.5)$ with $s>1.75$ it needs $h_x=O(n^{-0.3})$ against C5′(ii)'s $h_x\gg n^{-13/32}$ — **but the block documents no upper end for $h_x$, so the window is undocumented.**

### 2.7 (−1) — `prp:norangeinv`(ii) runs an upper bound backwards
`proofs.tex:3038–3041` asserts a $v$ attaining a prescribed functional value while annihilating $n_{\rm m}-1$ others "may be taken with $\|v\|\le\mathsf c_9h_uh_x^{1/2}$ by `eq:hstep1b`" — **but `eq:hstep1b` bounds $|\Delta_{h_x}v_i|$ ABOVE given $\|v\|$.** Producing such a $v$ needs the *minimum-norm* solution, whose norm is governed by the conditioning of $\{\mathsf d_i\}$ — the $\lambda_{\min}$ information Q-3 says is unavailable. Separately, "supported where none of them need be" is generically false once $n_{\rm m}h_u\to\infty$. **Conclusion very likely right; the one-round cap is not yet honestly spent.**

### 2.8 (−1) — the entropy route is mis-wired; "no unpinned entropy theorem" is false as stated
1. **(P-d) names the wrong clause** — it states `eq:entropy` (clause (a), from the unpinned (F-e)), while the proof says *"by `lem:unifop` clause (b), which is where L-19 is consumed."* **As written, `prp:phirate` charges $s>1.75$ for a condition its proof does not use.**
2. **`lem:aerr` is the real (F-e) dependency and is not confined** — `eq:entropyA` covers the full source-condition ball. Restricting it to $\mathcal V_n\cap\mathcal S_n$ (all `prp:phirate` ever evaluates) routes it through the elementary volumetric bound and **removes a budget line.**

*(The exponent itself is right — Birman–Solomjak $\epsilon^{-1/s}$; `eq:entropy`'s derivation checks: $s>1.75$ at $\alpha=\tfrac38$, $s>1$ at $\alpha=\tfrac5{16}$.)*
**L-19 honours the Stage-2 carried constraint** — sup-norm discretisation of the source-condition ball plus `lem:bdiff` (Hoeffding + Azuma, correctly proved inline). **No VC-subgraph.** ✓

### 2.9 (−1) — `prp:tccrepair`(ii) does not prove `def:a6b`
`def:a6b` quantifies over **all** pairs in $\mathcal V_n$; the proof establishes `eq:a6b` only at the fixed centre (`eq:gramlow` at $\hat{\mathcal A}_{\tilde\varphi}$ alone, $\mathbf G_n$ at $\tilde\varphi$ alone). Repairable (halve the radius; require $\lambda_{\min}(\mathbf G_n(\cdot))$ bounded below uniformly over base points). Low impact — A6b has zero consumers — but the stated proposition is not what is proved. *(The radius algebra `eq:tccb`→`eq:tccrad` checks exactly.)*

### 3.1 (−2) — `prp:phirate` contradicts its own proof about A5(vi)
`results.tex:2793`: *"A5(vi) are **discharged**, not assumed."* `proofs.tex:3582`: *"A5(vi) is **not discharged**: it is consumed, at `lem:pathcont`(c)."* The memo sides with the proof. **The statement claims a maintained assumption has been eliminated when the proof consumes it as an unstated hypothesis.**

### 3.2 (−2) — the A6 sweep is incomplete. **SPLIT VERDICT on the orchestrator's question.**
**True of theorem hypotheses.** A6 appears in **no `Suppose …` clause of any result**; `cor:opsol` does not take it as a hypothesis; **`prp:phirate` genuinely uses neither A6 nor A6b.** ✓
**False of the corpus.** Four prose sites assert something about A6; **two become substantively wrong:**

| Site | Status after Part H |
|---|---|
| `results.tex:320–322` (R1(iv)) — "consistency of the regularised sample solve … **requires A6 and A7**" | **Now false.** Delivered by `prp:phirate`, which uses neither. Must be rewritten. |
| `assumptions.tex:1757` — "**A6 and A7 are the two conditions** under which a DP stopping rule is a theorem…" | **Now false.** A6 refuted; the stopping theorem runs on A7-amended alone. |
| `results.tex:1021` | Descriptive; survives with rewording. |
| `proofs.tex:341–344` | Moot; reads oddly. |

**This is the same one-level-up omission Part H diagnoses in round 9's `def:hatA`.** `rem:tccverdict`(3)'s "Nothing downstream needs either" is true of theorems and false of the file set — and **the orchestrator's "ZERO dangling references" measures Part H's *outbound* references, not what breaks *inbound* when A6 is struck.**

### 3.3 (−1) — "saturates" over-claims the cited theory
`results.tex:2821` says the nonlinear LF rate *"saturates"* at $\mu=\tfrac12$; the body four lines later is correct — *"above $\tfrac12$ **the analysis** gives no improvement."* **No saturation (lower-bound) result is cited or proved**, and `lem:srctransfer`(ii) establishes failure of *source-condition transfer*, not of the *rate*. The disposition survives — you cannot inherit a theorem you do not have — but the paper cannot print "saturates" against `hanke1995`/`engl2000` without one.

### 3.8 (−1) — $\varkappa$ carries four meanings
Spline-span dummy (`proofs.tex:2007`); A2c's countable family $\varkappa_k$ (C48); **the Heinz exponent (`proofs.tex:3442`)**; **the source-transfer residual (`:3448`)** — the last two **four lines apart, both new in Part H, neither in the slot list.**

### 3.9 (−1) — $\mathcal V_n$ carries three meanings in Part H alone
A6's LF-path ball; `def:a6b`/`prp:tccrepair`(ii)'s $\bar\rho_n$-ball at an arbitrary centre; `def:srcball`'s deterministic source-condition ball (consumed by four results). `def:srcball` notes the subscript oddity but not the collision.

---

## MODERATE

- **3.4 (−1)** A5(vi) reads $\|h\|_{H^s}=O_P(1)$ for the **final** estimator; `lem:pathcont` needs it **at every stage**. A Route-column change is necessary but **not sufficient** — the clause's content must change, or add A5(vi′).
- **3.5 (−1)** `prp:tccfails`'s scope: **the sieve is untouched.** `def:lfstep` runs LF on $\mathcal S_n$, where the inverse inequality $\|\zeta\|_\infty\le\mathsf c_{11}L_x^{1/2}\|\zeta\|$ — which the file itself proves at `lem:unifop`(3d) — **kills the spike.** A referee will ask "why not restrict A6 to the sieve and keep nonlinear LF?" The answer exists and is independent (saturation has nothing to do with the TCC), but `rem:tccwhy`'s "not the radius of $\mathcal V_n$" does not cover a change of *space*. One paragraph.
- **3.6 (−1)** A2, C4′, A1c listed on `prp:phirate` with no consumer.
- **3.7** (P-a) is the load-bearing high-level condition — a **random** link condition at a **data-dependent** base point, assumed w.p.→1, no sufficient condition anywhere. Q-4 concedes it honestly. **But it is exactly what carries $\mu>\tfrac12$**, and the paper cannot print "the linearised route reaches the same place under the same threshold" without pricing (P-a) in the same sentence.
- **3.10 (−1)** **Slot-register collision: Part H claims C45–C48, which §1.5d already holds from the Part G fix pass ($\ell^\Pi_0$, $\mathcal T_\ast$, $\mathcal X_\pm$, $\varkappa_k$). Two parallel dispatches both started at C45.** Renumber Part H to C49+.
- **4.2 (−1)** **(F-e)'s two named pins give different exponents.** Birman–Solomjak gives $\epsilon^{-1/s}$ (used, correct); vdV&W Thm 2.7.1 via $H^s\hookrightarrow C^{s-1/2}$, offered as interchangeable, gives $\epsilon^{-1/(s-1/2)}$ — moving `eq:entropy` from $s>1.75$ to $s>2.25$. **Not interchangeable.**
- **4.3** `dunker2014` named in prose without `\cite`; `rem:lfnonlinear`(c)'s positioning claim needs a real cite.

## BLOCKING, not charged (librarian's)
**4.1** `engl2000` (`results.tex:2809`, `assumptions.tex:1070`, `proofs.tex:423`), `hanke1995` (`results.tex:2446`, `:2809`), `chenreiss2011`, `dunker2014` — **all absent from `references.bib`. Build breaks today**, and `engl2000` was already breaking `assumptions.tex:1070` before Part H landed. Correctly flagged by the theorist in `step6_memo.md` §6.

---

## F-6/O10 — the arithmetic checks out

| Claim | Check | ✓ |
|---|---|---|
| Contraction iff $\mu>\tfrac12$ | $2\kappa-1=\frac{2\mu-1}{2\mu+1}>0$ | ✓ |
| Fixed point at $\delta_n^2=O(\hat\delta_n)$ | $\frac{4\mu}{2\mu+1}\ge1\iff\mu\ge\tfrac12$ | ✓ |
| $\mu=\tfrac12$ barrier | $n^{-1/4}(\ln n)^{1/4}\ne o(n^{-1/4})$, also at the log-free floor | ✓ |
| A5(iii) forces $\mu>\tfrac12$ | $\frac{2\mu}{2\mu+1}\alpha>\tfrac14$, $\alpha<\tfrac12$ | ✓ |
| Linear LF does not saturate | infinite qualification; DP order-optimal all $\nu>0$ | ✓ |

**The two thresholds do coincide and the reasoning is genuinely good** — subject to 3.3's wording and 3.7's pricing of (P-a).
**The three things given up are honestly scoped** ✓ — global convergence (Q-1), the sieve (Q-2 route), the IRGN tension (Q-2). One inconsistency: `rem:lfnonlinear`(b) says A8's **upper** end is consumed; the memo and `lem:srctransfer`(iii) say A8's **window**. The upper end is right.

## A7 — counterexample valid, repair really is free
(ii) $\hat\varrho-\varrho=\mathsf Zr_n g$ with $\mathsf Z$ half-normal is $O_P(r_n)$ with $P(\|\cdot\|>\tau r_n)>0$ for every fixed $\tau$ ✓, and survives the truncation convention. **An $O_P$ hypothesis genuinely yields no fixed-constant exceedance bound — exactly the right pedantry for a maintained assumption.** (iii) ✓ standard. (iv) ✓ free against `eq:frontier` — **but NOT free against (P-f)**, see 2.4.
**C(3) is now mandatory, not optional:** `def:lfstep`(c) already implements $\tau_{\rm DP}\hat\delta_n\ln n$, so leaving A7 unamended puts the maintained block in contradiction with the estimator.

## What is right in Phase 2
`lem:intker` (all four clauses; the *"no second derivative assumed or used"* discipline is real); **`prp:hatAprop`(iii) + `lem:intker`(iv)** — without the exact $x$-normalisation the adjoint leaves $\mathcal V$ at an $O(h_x)$ fraction of design points, **invisible in any rate, a type error against `def:spaces`** — good catch, correctly proved; **`prp:hatAprop`(v)** proving $\hat T$ **nowhere Fréchet differentiable**, so the rejected reading is *unavailable* rather than merely declined; `lem:opnoise`(i)'s log-free Hilbert-space second-moment route; `prp:stopfeas`(ii)–(iv); `lem:bdiff`.
**Linkage:** `rem:phirscope` is **exemplary** — (2) flags that A5(ii) writes $\hat\delta_n^{2\mu/(2\mu+1)}$ while `eq:phirate` delivers $(\hat\delta_n\ln n)^{2\mu/(2\mu+1)}$, **exactly the trap Step 7 would fall into.**

## Part G fix pass — two spot checks, both favourable
**The theorist's rejection of the predecessor's MAJOR-2 remedy is correct** — `eq:usobolev` at $-\mu''$ is $L^2$ with a strictly weaker norm, not complete, so "the dual of $H^{-\mu''}$" names nothing here. **(m.2) checked line by line** and is a correct substitute: Plancherel, Hermitian first factor with norm exactly $\|g\|_{H^{\mu''}}$, dense family in the unit ball, sup over a dense subset is the norm; truncation preserves Hermitian symmetry; $\varkappa_k$ real. **No completion, no negative-index space. Credit — it caught a defective prescription rather than executing it.**
**The MAJOR-1 enlargement is also correct:** two representatives agreeing Lebesgue-a.e. agree $\Pi_u$-a.e. only under $\Pi_u\ll\mathrm{Leb}$, so **"B1(iv) enters at Steps 0 and 2" is right and the review's narrower claim was wrong.**

---

## Rulings on the six held requests

| | Ruling |
|---|---|
| **C(1)** A6 leaves the block | **APPLY — with three changes first.** (i) Fix the probability claim (2.5). (ii) State the scope: refuted on $L^2(\pi)$-balls, **untouched on $\mathcal V_n\cap\mathcal S_n$**, and why that does not rescue the inherited route. (iii) **Sweep the four A6 prose sites; two are substantively false.** **And strengthen it** — state the construction-free form. |
| **C(2)** $\hat T$ into `assumptions.tex` | **APPLY.** `eq:hatT` is the right object and pairs coherently with `eq:hatAcon`. **One change:** truncate to $[\varepsilon_\varrho,1-\varepsilon_\varrho]$, not $[0,1]$ — free under A4(i), removes the degenerate event at both sites. |
| **C(3)** A7's threshold | **APPLY — now mandatory.** Verified free against `eq:frontier`; **record that it is not free against (P-f).** |
| **C(4)** A5(i)'s comment | **APPLY with a guard.** Do **not** hard-code C5′(i)'s bandwidth: under C(6)'s re-tuning the smoothing bias becomes $\asymp\hat\delta_n$, not $o(n^{-1/2})$, and `prp:stopfeas`(i)'s proof relies on the old relation. **C(4) and C(6) must be written together.** |
| **C(5)** C5′(ii) → (1,1) | **HOLD one round.** Derivation right and nothing can break, **but relaxing the lower bound on $h_x$ while the upper bound (2.6) is undocumented leaves the window unspecified.** Apply together with the missing upper-end clause, or not at all. Holding costs nothing. |
| **C(6)** Re-tune C5′(i) | **APPLY, with $\mu>\tfrac56$ STRICT** (2.4), and see the C(4) interaction. The re-tuned $h_u\asymp\hat\delta_n^{1/p_K}$ needs $\alpha$ — not a new infeasibility, but deserves a sentence. |
| **Glossary C45–C57** | **APPLY after renumbering to C49+** (3.10). **Add two rows:** $\varkappa$'s two new meanings (3.8), $\mathcal V_n$'s disambiguation (3.9). C51's C13 amendment, C56's decline and C55b's $\varpi$ rejection are all sound. |

## Routing

1. **counterexample-hunter — YES, in parallel, NOT as a gate.** The construction was verified end to end; the hunter is not needed to confirm the refutation. Scope it to the two boundary questions the file does not answer: **(a)** the degenerate event under the $[0,1]$ convention; **(b)** whether A6 restricted to $\mathcal V_n\cap\mathcal S_n$ survives — where the spike dies on the inverse inequality, and which is the ball `def:lfstep` actually uses. **Neither outcome changes the disposition, so it must not block the fix pass.**
2. **Step 7 — DO NOT OPEN.** Three blockers, all in `prp:phirate`, which is what Step 7 reads: **2.1** (would inherit a rate for an undefined estimator); **3.1+3.4** (cannot yet say whether A5(vi) is discharged, consumed, or needs restating); **2.4** (whether the reference configuration is admissible, and $\ge$ vs $>$, unsettled). **Make `rem:phirscope`(2)'s warning a hard note in the Step 7 brief.** The Part G lower bound and the O-16 split are independent and can proceed.
3. **`/simulate`.** **CP-13 is now the critical probe, not CP-8** — report realised $\hat m^{(k)}$ **by stage** and how often the rule fails to stop before $\bar m_n$, running the implemented fixed threshold and the stage-adaptive one **side by side**. Grid $\mu\in\{0.75,\tfrac56,1,2\}$ at $d_Z=3$; **include $(1,3,4.5)$ specifically — the log arithmetic predicts it degrades despite sitting "exactly at the boundary" in powers of $n$, which is a falsifiable prediction of 2.4.** Both bandwidths on the same DGPs. CP-8 widened to A6b at pairs *not* anchored at the centre (2.9). O-16(a) and (b) reported separately.
4. **Build gate.** The four keys into `references.bib` before anything compiles `assumptions.tex` or `proofs.tex`.
