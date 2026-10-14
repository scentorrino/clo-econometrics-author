# Theory Review — Part H fix pass, `panel-npiv-discrete`

**Reviewer:** theorist-critic · **Severity:** HIGH (Execution) · **Gate:** 80 · **Strike 2 of 3**
**Persisted by the orchestrator.** Prior score 58 (`proofs_review_dispatch7.md`); disposition `theory_memo.md` §D-0000000000.

## SCORE: **66 / 100 — does not clear.**

**0 CRITICAL · 7 MAJOR · 4 MODERATE · 6 MINOR · −34.**

> **Both prior CRITICALs are substantively closed. The score is a fail, but a different kind of fail: nothing here requires a new theorem, a new assumption, or a re-derivation.** Ten items are edits; three need a paragraph each; one needs a budget line plus a clause-level citation. **A focused Strike-3 round should clear 80 comfortably.**

---

## Verified correct — the larger part

**`lem:srctransfer`(ii.b), and the rejection of the prescribed downward perturbation. "This is the pass's best work."** On $\{\sigma_j\ge2\gamma\}$, $\hat\sigma_j\ge\sigma_j/2$ so $|\tilde\varsigma_j|\le2^{2\mu}|\varsigma_j|$ with residual **zero**; on $\{\sigma_j<2\gamma\}$, $\tilde\varsigma_j=0$ and $|v_j|\le(2\gamma)^{2\mu}|\varsigma_j|$. **Transfer holds for every $\mu>0$.** A shared singular system gives $\sup_j|\hat\sigma_j-\sigma_j|=\|\hat{\mathcal A}-\mathcal A\|\le\gamma$, so the hypothesis is used correctly. **The prescription is dead, and dead for the right reason: the obstruction is rotation of the singular system, not size.** Refusing a critic's repair with a proof, and leaving "does transfer itself fail above $\tfrac12$?" open in the open, is exactly right.

**`lem:srctransfer`(ii.a)'s $2\times2$ witness** — correct in every detail ($\mathcal Q_1\succeq0$; $\mathcal Q_2-\mathcal Q_1\succeq0$; $\mathcal Q_2^2-\mathcal Q_1^2$ has $\det=-1$; at $\zeta=(1,-3)'$ the form is $-3$).

**Nothing downstream weakens.** `rem:lfnonlinear`(3) invokes (ii.a) only to say the *theorem* is unavailable, explicitly separating that from "the rate fails there". **Disposes of the prior 3.3.**

**The repelling-fixed-point analysis is correct in every step.** $\mathsf a_k\ge2\kappa\mathsf a_{k-1}-\mathsf b_n$; $\mathsf a^\ast=\tfrac{\kappa\alpha}{4(2\kappa-1)}\log n$; $\mathsf a_k-\mathsf a^\ast\ge(2\kappa)^k(\mathsf a_0-\mathsf a^\ast)$. The threshold $\iff4(2\kappa-1)>1\iff\mu>\tfrac56$ ✓. The $\bar k_a$ closed form is right, $\log n$ genuinely cancels, and both numerator and denominator are positive exactly under `eq:prelimrate` and $\kappa>\tfrac58$.

**All of `rem:h6bandwidth` verified**, including $(1,3,4.5)$ failing by exactly $(\ln n)^{1/3}$ and $\mu=\tfrac56$ by $(\ln n)^{1/4}$.

**`prp:norangeinv`(ii) genuinely rebuilt — prior 2.7 closed.** No $\lambda_{\min}$, no minimum-norm solution, no genericity.

**`def:hatT`'s truncation fixes both things.** `eq:wbounds` holds **surely**, so $\mathbf G_n$'s diagonal is bounded below — **no zero row, deterministically.** Closes prior 2.5 and the hunter's partial-degeneracy finding. A4(iii) preserved by contraction ✓.

**(F-f) is a faithful transcription of EHN Thm 6.5**, and the load-bearing "no saturation" claim is right — Landweber has infinite qualification and the DP is order-optimal for all $\nu>0$ here, **in contrast to Tikhonov where the DP saturates at $\nu=\tfrac12$.**

**`prp:tccfails`'s quantifier is the right way round** ("at each fixed $\tilde\varphi$, a.s."), with the reason given.

**Does `eq:lfsched` resolve the original 2.1? At the level of the rule, YES — including in the contraction regime.** `def:lfstep`(c) and (L4) now stop at the identical quantity, so implemented and analysed rules coincide **by construction, in both regimes.** Empty-set convention and cap stated; (L4)'s non-emptiness argument sound. What survives is the constant, not the mismatch.

---

## MAJOR

### 2.1 (−4) — (L3) is not established; the same constant sits on both sides
`eq:effnoise` and `eq:lfsched` both read $\mathsf c_{14}(\hat\delta_n\ln n+h_u^{-2}(\cdot)^2)$ — **literally the same symbol** — the first with the unobservable $\varepsilon$, the second with $\hat\varepsilon_{k-1}$. (L3) asserts $\varepsilon\le\hat\varepsilon_{k-1}$ w.p.→1, but Step 3 delivers $\varepsilon\le C_k\hat\varepsilon_{k-1}$ for an unquantified $C_k$ the text says "composes" across stages. **Repairable** — $\bar k$ finite, so $\sup_k C_k<\infty$ — **but the repair falsifies the file's own claim** that "*every quantity in `eq:lfsched` is known to the analyst*". $\mathsf c_{14},\mathsf c_{15}$ are not, and `rem:phirscope`(5)'s list of four analyst inputs omits them. **If $\mathsf c_{14}$ is chosen too small the implemented level again sits below the true data error and (F-f) is void.**

### 2.4 (−4) — A8 in full ∧ (P-d) makes the block's own reference configuration INFEASIBLE
`prp:phirate` lists **A8** and Step 1 invokes "A8's lower end". A8 is $n^{1/(2s)}\ll L_x\ll n^{1/2}$; (P-d) is $L_x\ln n=o(n^{1-2\alpha})$. Jointly $s>\frac{1}{2(1-2\alpha)}$.
**At the reference $(1,3,4.5)$, $\alpha=\tfrac38$: $n^{0.2857}$ against $n^{0.25}$ — the window is EMPTY.** The block records $s>1.75$; the true requirement is $s>2$. *(Orchestrator confirmed both numbers independently.)*
The strengthened (P-c) adds $s>\tfrac{9\alpha}{8(1-2\alpha)}=1.6875$ — satisfiable, but consuming most of the remaining $L_x$ margin. **Neither line is in the smoothness-budget table, and `assumptions.tex:2067` states the opposite:** *"None of the four competes with $s$ … the $s$ budget is unchanged."* **Fix as C2′(i) was fixed in dispatch 6: cite A8 by clause, drop the lower end from `prp:phirate`, record the surviving joint line.**

### 2.2 (−3) — (L1) rests on a normalisation whose only available bound diverges
`def:lfstep` says "normalise so that $\|\hat{\mathcal A}_\varphi|_{\mathcal S_n}\|\le1$ … this costs nothing." **The only norm bound in the file is `prp:hatAprop`(i): $\|\hat{\mathcal A}_\varphi\|\le\mathsf c\,h_u^{-1}h_x^{-1/2}$ — divergent.** A rescaling of $\Pi$ rescales $\|\mathcal L\|$, $\hat\delta_n$ **and** the source radius simultaneously; the rate survives only because (F-f)'s $R^{1/(2\mu+1)}\delta^{2\mu/(2\mu+1)}$ is scale-invariant — **and `eq:linlf` drops $\mathsf R$ entirely, so that cancellation is never performed.** Second edge: if the unscaled norm is instead $o(1)$ (plausible — near-orthogonal $\hat g_i$ give $\asymp(n_{\rm m}h_u)^{-1/2}$), (L4)'s stopping-index bound and (F-f)'s $c_\mu$ both need $\|\mathcal L\|\asymp1$. **The file owes a lemma, not a sentence.**

### 2.3 (−3) — `eq:a6sieve`'s stated derivation is wrong, and vacuous under the display it cites
It claims to come from $c\downarrow0$ in **`eq:a6b`** — but `eq:a6b` is written in $\hat T_{h_x}$, and `prp:hatAprop`(iv) makes $\hat{\mathcal A}_\varphi$ its **exact Fréchet derivative** with $O(\|v\|^2)$ remainder. So the LHS is $O(c^2)$, the RHS $O(c)$, and the limit is $0\le\tfrac{\eta}{1+\eta}\|\hat{\mathcal A}v\|$ — **trivially true.** `eq:a6sieve` is the first-order limit of **A6** (raw $\hat T$), which is what the hunter derived. Two further transcription losses: the hunter set $\tilde\varphi=0$ *precisely so* both displays use identical $\hat g_i$, whereas `eq:a6sieve` writes one $\hat g$ against both $\Delta v_i$ and $\Delta_{h_x}v_i$ at a general base point (gap $O(h_u^{-1}\hat\delta_n)$, unflagged); and **"necessary and sufficient" over-claims the hunter's "only if"** — sufficiency needs the $\lambda_{\min}(\mathbf G_n)$ bound the same paragraph declines to supply.
**The demotion of reason (1) is correctly scoped**, and the window claim checks out independently: $h_xL_x$ over roughly $(n^{-0.27},n^{0.23})$, containing both tunings ✓. **The demotion is right; its supporting display is derived from the wrong inequality.**

### 3.1 (−3) — the $\mu>\tfrac56$ "coincidence" is an IDENTITY
`proofs.tex:4022` and the memo both say *"the same number governs both, and neither is a restatement of the other."* **They are the same inequality.** With $h_u=n^{-\beta}$, $\hat\delta_n=n^{-\alpha}$:
- **(P-f)**: $\alpha(2\kappa-1)\ge2\beta$.
- **(a.1)**, the preliminary requirement being weaker than the delivered rate: $\tfrac{2\kappa\beta}{2\kappa-1}<\kappa\alpha$, i.e. $2\beta<\alpha(2\kappa-1)$.

Identical, the second strict. *(Orchestrator confirmed symbolically: (a.1) $=\tfrac{\kappa}{2\kappa-1}\times$(P-f), a strictly positive factor.)* A third comparison — the repelling fixed point lying above the regime boundary — is **also** the same inequality. **This is forced, not coincidental:** for a two-branch map, "the attracting fixed point lies in branch (b)" and "branch (a)'s repelling fixed point lies above it" are equivalent.
**Neither a structural fact nor an algebra slip — an identity written up as a coincidence.** The mathematics of (a.1) is correct and `eq:prelimrate` is a real new requirement, so **Q-1's sharpening stands unchanged.** One sentence must change. The true and still-worth-printing statement: *(P-f) is exactly the condition under which the newly exposed preliminary-rate requirement is not self-defeating.* **`prp:phirate`'s own statement is already careful here** ("the coincidence worth naming is at $\tfrac12$, not at $\tfrac56$") — the error is in the two places contradicting it.

### 2.5 (−2) — the $\bar k$ correction was applied in one place out of three
`results.tex:3068` (**the statement**) still says "computable from $\mu$ and $\varsigma_0$ **alone**"; `proofs.tex:3899` says $(\mu,\varsigma_0,\alpha)$; `proofs.tex:3910` says "from $\mu$ and $\varsigma_0$". In the closed form $\alpha$ factors out of the numerator but **not** the denominator. **The proof contradicts itself within eleven lines, and the statement — the line a Step-7 author implements — is still wrong.**

### 2.6 (−2) — "no purely data-driven rule can serve" is Bakushinskii, uncited, and too strong here
**The diagnosis is right and I withdraw my prescription.** $\hat r_{k-1}$ cannot bound $\varepsilon_{k-1}$ from below precisely because $\|\hat{\mathcal A}v_\dagger\|\ll\|v_\dagger\|$ is what ill-posedness *is*. **That is a genuine, sharp observation and should be stated as the paper's own.**
**The generalisation is not.** It is **Bakushinskii's veto** (1984; EHN §3.3), asserted twice with no citation in a file that pins (F-d)–(F-f) scrupulously. **And it is too strong for the statistical setting this paper inhabits:** the veto is worst-case deterministic, while in statistical inverse problems **Lepskii-type balancing over the regularisation index is purely data-driven and attains the optimal rate up to a logarithm** — the device **this author team already runs as `prp:lepskii` in the sibling project.** Keep the sharp claim, cite Bakushinskii, and say why the schedule is preferred (finite $\bar k$, deterministic $\bar k_a$) rather than claiming Lepskii is unavailable.

---

## MODERATE
- **2.7 (−2)** $\mathcal R$ carries two meanings **inside one proposition statement** — the range-invariance family at `results.tex:2561` and the **range** at `:2576`, four lines apart. INV-7. ($\mathsf R$ is already the source radius, so the neighbourhood is crowded.)
- **3.3 (−2)** `lem:aerr`, `eq:gamman`, `eq:entropyA` are now consumed by nothing. **Striking (P-b) orphans nothing downstream — verified** — but the lemma has no theorem consumer and **two sentences still say it does** (`proofs.tex:3627`, `results.tex:2679`). The retention reason (C5′(ii)'s re-derivation, HELD) is inferable but never stated. **Same species as the A6 sweep the pass just completed.**
- **4.1 (−2)** **(F-f) exists only in a LaTeX comment.** The single external theorem the whole of `prp:phirate` rests on is invoked by tag at three places with no in-text statement and no `\cite`. Must be displayed with `\citet[Thm 6.5]{engl2000}` before Step 7 — **and add the Tikhonov-vs-Landweber saturation contrast, which is worth more to a methods referee than the statement.**
- **3.2 (−1)** Two different "reference configurations", and by 2.4 the first is infeasible at its recorded $s$.

## MINOR
**3.4 (−1)** (ii.a) claims a 2-dimensional witness for **every** $2\mu>1$; Löwner gives *some* dimension. The claim is true but by a different argument. **2.8 (−1)** joint surjectivity asserted from distinctness, though the minimum design gap is $O_P(n^{-2})\ll h_x$ so the bumps overlap. **2.9 (−1)** $(2\mathsf c_{15})^\kappa$ vs $\mathsf c_{15}2^\kappa$; `eq:fixedpoint` vs `eq:lfsched` — *the third job two constants are doing*. **3.5 (−1)** C5′(ii)'s window computed at the bandwidth C(6) just retired. **4.2 (−1)** Löwner uncited. **4.4 (−1)** slot-register range disagrees between records.

## Verified correct in Phase 3
2.4's strictness work (**"the pass's second-best instinct"** — all thresholds strict, `prp:stopfeas`(iv) split, the $(1,3,4.5)$ failure displayed rather than buried); 3.1's over-claim corrected (A5(vi′) a hypothesis, only A5(i)–(iii) discharged); 3.4; 3.6; 3.7 ((P-a) priced in its own paragraph and both "same place" sentences); 3.8; 3.9; 2.9 (`eq:gramunif`'s infimum, radius halved, halving argument correct); **C(5) HELD with the reason recorded — the right call given (P-g) is still a hypothesis.**

## Bibliography — confirmed, not charged
Five keys absent over live sites: `engl2000`, `hanke1995`, `dunker2014`, **`conway2000`** (`proofs.tex:419`) and **`severini2006`** (`assumptions.tex:1988`). **`chenreiss2011` is not cited anywhere — the orchestrator's correction is right.** Librarian's. *"With a compiling build and `[?]` rendering, a `\citation`-vs-`.bib` diff belongs in the sync script's CHECK set, since no existing gate catches it."*

---

## Routing

**Step 7: NO — but the gap is one short fix round, not a re-derivation.** Two of the three blockers the memo declares closed are only partially closed and **both leak directly into Step 7**: `prp:phirate`'s *statement* still misdescribes $\bar k$ (2.5), and A8 ∧ (P-d) leaves the running configuration infeasible (2.4). Step 7 reads $\delta_n$ off A5(ii)/`prp:phirate` and would inherit both silently. Close 2.1–2.6 and 3.1, then open with `rem:phirscope`(2)'s $\ln n$ warning as a hard note.

**Narrow critics — three of five MUST re-sweep first.** None has seen Part H or the fix pass, and Part H is now the largest block in the file.
- **notation-warden — MUST.** $\mathcal R$ overloaded *inside a single proposition statement*, $\mathsf c_{14}/\mathsf c_{15}$ carrying three jobs. **"I found them incidentally, which means there are more."**
- **assumption-auditor — MUST, and the highest-value sweep.** (P-b) struck, (P-g) added, A5(vi′) added, (P-c) strengthened, A8 cited wholesale, three objects orphaned. **"2.4 is exactly what it would have caught mechanically."**
- **regularity-checker — SHOULD.** Three silently invoked conditions: the normalisation (2.2), joint surjectivity (2.8), and `rem:tccwhy`(3)'s design statement written deterministically.
- **counterexample-hunter — NOT needed before Step 7.** Verdict stands, **binary gate holds**, both findings disposed. Re-run only if `eq:a6sieve` is restated.
- **derivation-verifier — one targeted spec would settle 3.1 definitively**, and it carries Q-1 plus a simulation prediction.

**Add one spec** for the (P-c) ∧ (P-d) ∧ A8 joint window (2.4) — *"the kind of arithmetic that will drift again."*

### The three `/simulate` design corrections
1. **O-16(a) rather than (b) — CONFIRM, unchanged.**
2. **The $\mu>\tfrac56$ line — AMEND on two counts.** **(a) Change the configuration:** by 2.4, $(1,3,4.5)$ at $s=1.75$ is outside the admissible set. Run at $s>2$, or move to $(2,3,\tfrac34,0.32)$ — feasible, frontier-clearing, and already the hunter's, so the ($\star$) and $\mu$ legs share a design. **(b) Change what is predicted:** by 3.1 the two conditions are one, so registering them as two predictions tests one thing twice; and the claimed boundary effect is **logarithmic** — at $\mu=\tfrac56$, (P-f) fails by $(\ln n)^{1/4}$, which **a power-law grid will not see.** Register a log-log design against $(\ln n)^{1/4}$, or it is not falsifiable as written. **The genuinely two-sided prediction is that (P-f) binds only through $h_u$:** at fixed $\mu<\tfrac56$, re-tuning $h_u$ upward should restore the rate — that separates the mechanism from $\mu$ itself.
3. **CP-13 — CONFIRM the core, AMEND two legs.** Both thresholds by stage ✓, **plus sensitivity to $\mathsf c_{14}$**, which by 2.1 is not known and whose practical importance only CP-13 can measure. **Add a third arm: a Lepskii/balancing stop over $m$** — if it matches, Q-1 softens materially and the paper need not lean on an over-strong veto. **($\star$) at both tunings A and B**, since the whole content of Q-6 is that the verdict flips inside the window. **$\mathbf G_n$: report $\lambda_{\min}$ and $\kappa(\mathbf G_n)$, not numerical rank** — after the truncation, rank is $n_{\rm m}$ generically and carries no information, while conditioning is **the one number the simulation can supply that the theory cannot.**
