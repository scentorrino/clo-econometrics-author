# Proof-Strategy Review (ROUND 3, FINAL) — `panel-npiv-discrete`

**Target:** `proof_strategy_memo.md` (793 lines) · **Mode:** 3 · **Severity:** HIGH · **Gate:** 80
**Persisted by the orchestrator.** Supersedes rounds 1 and 2.

## (a) SCORE: **85 / 100 — CLEARS 80. Dispatch `/prove`.**

| Category | Weight | R1 | R2 | **R3** |
|---|---|---|---|---|
| Conjecture clarity | 15 | 12 | 12 | **14** |
| Target-object fit | 15 | 11 | 9 | **11** |
| Toolkit selection | 15 | 9 | 11 | **13** |
| Lemma sufficiency | 25 | 15 | 18 | **21** |
| Obstacle realism | 20 | 14 | 12 | **16** |
| Fallback design | 10 | 4 | 7 | **10** |
| **Total** | **100** | **65** | **69** | **85** |

No CRITICAL. C-3 closed in full and converted into a better result than the architecture it destroyed. M-6, M-7, M-8, M-9 and all ten round-2 minors closed. M-1 closed architecturally, mis-executed technically. Two new MAJORs, both the same shape: **the memo derives the correct condition in one place, then headlines a simpler, stronger, wrong version four lines later.** That is what the theorist most needs to know.

**No new user escalation required.** Escalation item 15 is answerable from material already in the memo.

---

## Verification of the seven repairs

### 1. C-3 diagnosis — CORRECT
$\mathcal B h(x)=h(x)M(x)-(\mathcal K+\mathcal K^\ast)h(x)$ by direct computation; the diagonal contributions combine as $\sigma$, not $\nu$. $\int M=2E[\widetilde W\partial_u\ell_\star]=0$ under A1, $M\not\equiv0$ pointwise. One phrasing imprecision: taking $\phi=h$ is legitimate; the error was inferring a *range* property of $\mathcal B$ from the *form* $\nu_g$ without noticing the $h$-dependence of $g$ turns the pairing into multiplication-plus-compact.

### 2. Weyl — CORRECT, including the equality
$\pi^{-1}\mathcal B_{dx}=m\cdot-\pi^{-1}(\mathcal K+\mathcal K^\ast)$ ✓ (resolves m-12). $\tilde{\mathcal K}$ HS, $m\cdot$ bounded self-adjoint, so $\sigma_{\rm ess}(\mathcal B_{\rm sym})=\operatorname{ess\,ran}(m)$ on non-atomic $\pi$ ✓. **Equality holds**: numerical radius $=$ norm for bounded self-adjoint operators, and $\mathcal B$ *is* self-adjoint ✓. Constructive route independently recovers $\ge\tfrac12\|m\|_\infty$ ✓. Leading with the construction and giving Weyl as remark is right.

**m-19, must fix:** (i) $qf_{X_1X_2}$ is **not** symmetric ($X_1,X_2$ are different periods), so $\tilde{\mathcal K}$ must be the symmetrization $\tfrac12(\mathcal K+\mathcal K^\ast)$; with the raw $\mathcal K$, $\mathcal B_{\rm sym}$ is not self-adjoint and the equality degrades to $\ge\tfrac14\delta^2\|\mathcal B\|$. (ii) L-20's HS condition is on the wrong object: on $L^2(\pi)$ the kernel is $qf_{X_1X_2}/(\pi\otimes\pi)$, so HS needs $\iint(qf_{X_1X_2})^2/(\pi(x)\pi(x_1))<\infty$, not "$f_{X_t}/\pi$ bounded" plus "$qf_{X_1X_2}\in L^2(dx\,dx)$."

### 3. The $M$ question — (ii) correct, (i) oversold, (iii) mis-aimed
**(ii) right, and the best of the three.** $M\equiv0$ removes the Douglas obstruction but leaves a genuine range condition; by M-6 the delivering condition is the form inequality. It reopens the *question*, not the rung. Escalating to $q\equiv0$ is cleaner — it gives $Q\equiv0$ outright.
**(i) — "no containment obstruction" ✓; "the dimension count favours feasibility" ✗ (m-21).** $\ker\mathcal A^\ast$ constrains the *difference* of period conditionals of $\widetilde W\ell$ while $\mathcal S$ reads the *sum* of those of $\widetilde W\partial_u\ell$ — different object, no obvious obstruction ✓. But infinite-dimensionality implies nothing about surjectivity: $\mathcal S$ is itself a smoothing map, so $\mathcal S(\ker\mathcal A^\ast)$ is generically thin and non-closed. **Same inference pattern that produced the A2″ error.** Keep the negative half; delete "favours feasibility."
**(iii) — pays, but not through $\|m\|_\infty$ (m-20).** The sharp constant is $\tfrac12\|\mathcal B_{\rm sym}\|$; $\|m\|_\infty$ is only a lower bound, and $\tilde{\mathcal K}$ moves with the selection too (same $q$). **SG-15 should sweep $\|\mathcal B_{\rm sym}(\ell)\|$** — the largest-magnitude eigenvalue of the discretised symmetric form, and unlike the Picard diagnostic m-9 killed, *not* corrupted by finite rank. Second consecutive round SG-15 has been aimed at a proxy.

### 4. Leg 3 / L-19 — rebuttal in architecture, not yet in execution
Architecture right and a genuine advance: the LF path lies in a *source set* (ball in the range of a smoothing operator), compact with controllable entropy; a uniform LLN at rate $\hat\delta_n\gg n^{-1/2}$ over such a set is categorically weaker than stochastic equicontinuity at the estimated point at $\sqrt n$ scale; entropy budget has enormous slack ($H(\hat\delta_n)\lesssim n\hat\delta_n^2$). Three defects:
- **"VC-subgraph" is wrong, and it is the load-bearing word.** Indicators indexed by $\varphi$ over an *infinite-dimensional* set have infinite VC dimension. Correct route: bracketing entropy inherited from sup-norm entropy of $\mathcal V_n$ via a bounded conditional density — **which L-4 already supplies.** Cheap fix, but the sentence as written goes into `positioning.md` and a Chen–Pouzo-literate referee will know the class is not VC.
- **$\mathcal R(\hat{\mathcal A}^\ast)$ singular is wrong for a nonlinear iteration** — each increment lies in the range of $\hat{\mathcal A}^\ast_{\varphi_m}$, a different operator each step. Needs uniform smoothing over $\{\hat{\mathcal A}^\ast_\varphi:\varphi\in\mathcal V_n\}$.
- **The ball's "deterministic" status is circular** — $\mathcal V_n$ is defined through the random $\hat{\mathcal A}^\ast$. Standard fix (induction on a high-probability event, cap $\bar m$ as budget) is unstated, and unstated circularity in a load-bearing lemma is what eats a fortnight.

**The sentence `positioning.md` can carry, once repaired:** *"we use a uniform law of large numbers, at a rate slower than $\sqrt n$, over a source-condition ball containing the Landweber path, with bracketing entropy inherited from a bounded conditional density; we do not use stochastic equicontinuity of the $\sqrt n$-scaled empirical process at an estimated nonparametric point, which is what the penalised sieve $\theta$-asymptotics require."* Weaker than the memo's version, still a difference in kind and scale. `positioning.md`'s "we avoid all three" is false on two of three legs; escalation item 9's scope is right.

### 5. $\hat\delta_n$ — Step 1a correct and it explains §16.1; Step 1b's threshold wrong by ~3× (M-11)
**Step 1a verified.** $T$ is an unconditional expectation; no local-averaging denominator, variance $O(1/n)$ irrespective of $h_u$, sup over $(u,t)$ costing $\sqrt{\log n}$. Bias $O(h_u^p)$; at $p=8$, $h_u\asymp n^{-1/16}$ gives $h_u^8=n^{-1/2}$, matching exactly ✓. **It does explain plan §16.1's bandwidth. Good find.**
**Step 1b's costing right, threshold wrong.** $\hat\delta_n^{(\varrho)}=O_P(n^{-r/(2r+d_Z)})$ ✓, and $\hat\delta_n=o(n^{-1/4})\iff r>d_Z/2$ ✓ *in isolation*. **But the rate condition is on $\delta_n=\hat\delta_n^{2\mu/(2\mu+1)}$, which is larger.** §3.3 Step 3 gets this right ($\frac{r}{2r+d_Z}>\frac{2\mu+1}{8\mu}$); Step 1b, O-13, the `assapp5` rewrite and SG-20 all headline $r>d_Z/2$ — the $\mu\to\infty$ limit. In primitives:
$$r>\frac{d_Z(2\mu+1)}{2(2\mu-1)},\qquad \mu>\tfrac12 \text{ necessary regardless of } r.$$

| | $d_Z=3$ | $d_Z=5$ |
|---|---|---|
| memo headline | $r>1.5$ | $r>2.5$ |
| **true, $\mu=1$** | $r>4.5$ | $r>7.5$ |
| **true, $\mu=2$** | $r>2.5$ | $r>4.17$ |

A 7.5-times-differentiable binary propensity in five dimensions is not a condition anyone will grant. **SG-20's pre-registration wrong for the second consecutive round.** The constructive form is a **frontier**: $\frac{2\mu}{2\mu+1}\cdot\frac{r}{2r+d_Z}>\frac14$ — smoothness in $\varphi_\dagger$ and in $\varrho$ substitute. Sweep the frontier in $(\mu,r,d_Z)$.
**Favourable half:** $\mu>1/2$ is a *new* necessary condition, unstated — and under the Hilbert-scale link plan §2.6's own $s>a+\tfrac12$ delivers $\mu>\tfrac12+\tfrac1{4a}$, so the scope already implies it with room. Say so; it makes the block look tighter.
**m-25:** order-8 bias $O(h_u^8)$ requires $f_{\Delta U}\in C^8$ — a **fourth** smoothness budget, absent from escalation 15's list.

### 6. Item 3 pricing — arithmetic correct, bound conservative and basis-dependent (m-26)
$L_x^{-s}=o(n^{-1/2})\iff L_x\gg n^{1/(2s)}$ ✓; window nonempty iff $s>1$ ✓. Caveats: (a) the display prices the third term as $\|\hat\nu_g\|L_x^{-s}$, the table as $L_x^{-s}$; it is really $\le\|\hat\nu_g\|\min(\delta_n,L_x^{-s})$, which may relax $s>1$ materially — and $s>1$ then enters `assumptions.tex` competing for the smoothness budget unnecessarily. (b) $L_x\ll n^{1/2}$ is the **spline** conditioning constraint; polynomials give $L_x\ll n^{1/3}$ and $s>3/2$. The basis is not named.

### 7. Other repairs — all land
SCDR withdrawal ✓ with absence-of-precedent correctly labelled weak evidence. L-21 ✓ (right route; right diagnosis that Picard gives $L^2$ membership only). L-20 ✓ modulo m-19. $\nu\perp\ker\mathcal A$ in L-15 ✓. §3.2 leg (i) ✓. $\kappa_n$ sub-polynomial ✓. A6/A7 and Dunker-as-noise-model ✓ — A7 stated exactly right, CP-13 tests it. §3.6's non-nestedness **verified**: because $W$ is binary, $\{G:E[G|\Delta U,\Delta Z]=0\}=\{\widetilde W\ell\}$ is an *equality*. Item 8's round-2 gap now priced ✓.

---

## The three "also assess" questions

**Assumption block: hangs together. Escalation 15 is answerable — do not send it to the user (m-22).** Under the Hilbert-scale link ($\sigma_j\asymp j^{-a}$, source set a Sobolev-$s$ ball), $\mu=s/(2a)$: **$\mu$ is not an independent budget.**

| Condition | In terms of $s$ | Source |
|---|---|---|
| $s>a+\tfrac12$ | — | plan §2.6 scope |
| $\mu>\tfrac12$ | $s>a$ | **implied above**, with room |
| $s>1$ (splines) / $s>3/2$ (polys) | — | §3.7 sieve window |
| $\frac{2\mu}{2\mu+1}\cdot\frac{r}{2r+d_Z}>\frac14$ | joint in $(s,a,r,d_Z)$ | §3.3 Step 3 |

$s$ never has to be two things at once. $\mu''$ (L-21) concerns $\ell_\star$ and is genuinely independent. State the Hilbert-scale link as a numbered assumption (`engl2000` §8.5). The only real competition is $\mu$ vs $r$ in the frontier — worth **displaying**, not hiding.

**Risk register: directionally honest, understated in one place, missing a claim-risk row.** `thm:rootn` MEDIUM as scoped ✓. `prp:phirate` top risk ✓ — and it carries a **fourth** load the register omits: by M-11 its rate condition may be near-vacuous at $d_Z=5$ unless $\varphi_\dagger$ is very smooth. That is a *feasibility* risk. `prp:sharpquad` at LOW–MEDIUM understates: the mathematics is LOW (three self-contained lines), but the *claim* carries M-10's quantifier problem — separate proof risk from claim risk.

**Lemma sufficiency (21/25).** Chains verified complete for `prp:sharpquad`, `prp:orthog`, `lem:adjoint`, `lem:bierens` at F4, `prp:plugin`, `cor:trend`. T2′'s rate list maps one-to-one onto §2.6's four surviving second-order terms plus $n^{-1/2}$ and $L_x^{-s}$ ✓; $J$ verified against the moment ✓. Four gaps: **no lemma/assumption for the source condition itself** and its link to $(s,a)$; **`thm:rootn`'s one-step needs a *rate* for the preliminary** and L-14 gives consistency only (m-23); **compactness of $\mathcal A_{\rm cond}$** is a premise of `prp:sharpquad`(ii) and appears nowhere; **§10's order of work contradicts O-15** (m-24) — resolved by stating `prp:sharpquad` for an *arbitrary* admissible selection, which is stronger and removes the dependency.

---

## (b) RESIDUAL RISK INTO `/prove`

**Governing instruction: where the memo's analysis and its headline disagree, the analysis is right.** Both new MAJORs are that shape.

1. **`prp:sharpquad` must be stated at the quantifier the proof supports (M-10).** What is proved is $\sup_{\|h\|\le\delta}|Q(h)|=\tfrac12\delta^2\|\mathcal B_{\rm sym}\|$ — about the class of admissible **proof techniques**, not about the estimator. §1.1 row 5 states it correctly; §1.0, §2.5(iii), §3.5(i) **and the rewritten plan §2.6** overstate it, §3.5(i) exactly backwards. Genuine necessity needs the realised $\hat\varphi-\vdagger$ to point where $Q$ is bad — plausible under semiconvergence, not proved, **and not tested by SG-16**, which evaluates the constructed sequence. Fixes: (i) write it as *"no bound in $\|h\|_{L^2(\pi)}$ alone improves on $\delta^2$; in particular no weak-norm bound exists"*; (ii) **add to SG-16 the ratio $Q(\hat\varphi-\vdagger)/\|\hat\varphi-\vdagger\|^2$ across the $n$ grid** — the only falsification test for the necessity reading.
2. **Do not write $r>d_Z/2$ into `assumptions.tex` or SG-20 (M-11).** State the frontier; display the $\mu$/$r$ substitution; re-pre-register SG-20 on it.
3. **L-19:** replace "VC-subgraph" with bracketing entropy over a source-condition ball via L-4; fix $\mathcal R(\hat{\mathcal A}^\ast_\varphi)$ to a uniformly controlled family; make the ball's determinism an explicit induction on a high-probability event with $\bar m$ as budget. Do not let the repaired sentence into `positioning.md` before it is proved.
4. **L-20:** symmetrize $\tilde{\mathcal K}$; restate HS on $qf_{X_1X_2}/(\pi\otimes\pi)$.
5. **Add the Hilbert-scale link $\mu=s/(2a)$** as a numbered assumption; it closes escalation 15 favourably.
6. **State `prp:sharpquad` for an arbitrary admissible selection**, removing the O-15/§10 conflict.
7. **SG-15 sweeps $\|\mathcal B_{\rm sym}(\ell)\|$**; delete "the dimension count favours feasibility."

**theorist-critic must re-check at the `/prove` gate,** in priority order: (i) `prp:sharpquad`'s quantifier and the object it ranges over; (ii) L-19's entropy class, containment induction, and whether the ball is genuinely deterministic; (iii) whether `assumptions.tex` carries the frontier or the threshold, and whether $\mu>1/2$ appears; (iv) whether A6 is stated for $\hat T$ and A7 for the stopping level; (v) whether the one-step preliminary has a *rate*, not just consistency; (vi) L-20's symmetrization and HS condition; (vii) that `positioning.md`'s Competitor-3 one-liner no longer says "we avoid all three."

**What is now safe.** Q-c is dead and buried, with the memo's own verification. The scope is plan §2.6's, honestly. The sharpness result is real and the tool well chosen. F2 (lower bound only) is a genuine safe harbour surviving every finding. T2′+T3 is a floor depending on no open question. The five narrow theory critics have clean targets.

---

## (d) DEDUCTION TABLE

| ID | Finding | Sev | Δ |
|---|---|---|---|
| **M-10** | "Sharp/necessary" overstates a sup-over-ball result — it is about admissible proof techniques, not the estimator. §1.1 correct; §1.0, §2.5(iii), §3.5(i) and rewritten plan §2.6 overstate, §3.5(i) exactly backwards. SG-16 tests the constructed sequence, not the realised error. | MAJOR | −3 |
| **M-11** | Propensity threshold wrong by ~3×; $\mu>1/2$ unstated necessary condition. §3.3 Step 3 correct; Step 1b, O-13, `assapp5`, SG-20 headline the $\mu\to\infty$ limit. May render `prp:phirate` near-vacuous at $d_Z=5$; not in the risk register. | MAJOR | −3 |
| **M-1** | Leg 3 closed architecturally, mis-executed: "VC-subgraph" wrong for an infinite-dimensionally indexed class; $\mathcal R(\hat{\mathcal A}^\ast)$ singular wrong for a nonlinear iteration; $\mathcal V_n$'s determinism circular. | MAJOR | −2 |
| **m-19** | L-20: $\tilde{\mathcal K}$ must be symmetrized; HS condition on the wrong object. | MINOR | −1 |
| **m-20** | Lever objective is a lower bound, not the sharp constant; SG-15 aimed at a proxy for the second round. | MINOR | −1 |
| **m-21** | "Dimension count favours feasibility" unsupported — same inference pattern as the A2″ error. | MINOR | −1 |
| **m-22** | Escalation 15 answerable in-memo via $\mu=s/(2a)$; should not go to the user. | MINOR | −1 |
| **m-23** | One-step needs a *rate* for the preliminary (L-14 gives consistency); no lemma for the source condition or for compactness of $\mathcal A_{\rm cond}$. | MINOR | −1 |
| **m-24** | §10 order of work contradicts O-15; fixed by arbitrary-selection statement. | MINOR | −0.5 |
| **m-25** | Fourth smoothness budget unstated: $f_{\Delta U}\in C^8$ for the order-8 bias. | MINOR | −0.5 |
| **m-26** | §3.7 drops $\|\hat\nu_g\|$; basis unnamed (splines $s>1$, polynomials $s>3/2$). | MINOR | −0.5 |
| **m-27** | §0.2's graph omits the `prp:sharpquad`→`thm:rootn` edge its own text calls load-bearing. | MINOR | −0.5 |
| | | **Total** | **−15** |

**Score 85. Gate cleared. Dispatch `/prove`.**

## Credit

C-3 accepted in full, verified independently, and **converted into a better result than the architecture it destroyed** — with an exact constant, via a tool not previously used and applied correctly. The self-diagnosis ("that is precisely the accounting I used against C-1; I did not apply it to my own construction") is the mark of a document trying to be right rather than to survive review. §3.3 Step 3's frontier, §3.6's non-nestedness identity (verified: equality, because $W$ is binary), §3.7's window arithmetic, the $n^{-1/16}$/order-8 reconciliation with plan §16.1, A7 as a stopping-feasibility condition, L-21's diagnosis that Picard cannot supply sup-norms, O-16's observation that the sharpness hypothesis and the design lever are the same condition, CP-12 as the only probe that could reopen the scope, SG-16's rebuild, and the SCDR withdrawal with no replacement — all correct, several better than round 2 asked for. Four of five round-2 MAJORs and all ten minors properly closed. Escalation item 1 was withdrawn *by the strategist*, which is the right instinct and rare.

**The two remaining MAJORs are not errors of understanding.** They are the memo doing the hard derivation correctly in §3.3 Step 3 and §1.1, then summarising it too confidently four lines later. **Tell the theorist to trust the derivations.**
