# Step 6 disposition — `panel-npiv-discrete`

**Dispatch 4 · memo §10 STEP 6 · `prp:phirate` and obligation (O4) · theorist · 2026-07-29**
**Status: NEW CONTENT.** To be merged into `theory_memo.md` as Part III, §E.

**Files written (none of the five locked files is touched):**

- `quality_reports/theory/panel-npiv-discrete/results_partH.tex`
- `quality_reports/theory/panel-npiv-discrete/proofs_partH.tex`
- `scripts/symbolic/specs/{phirate-fixedpoint-mu-half, phirate-retune-mu-five-sixths, l19-entropy-exponent, l19-effective-sample, aerr-propensity-scaling, phirate-operator-noise-budget}.yaml`

**Read:** `assumptions.tex` (in full), `results.tex` (Part A, `rem:obligations`, `prp:orthog`,
`lem:balance`, Part G's `rem:sharpscope`), `proofs.tex` ((P1)–(P7), Part G), `notation_glossary.md`
(in full), `proof_strategy_memo.md` §§2.7, 3.1–3.4, 4 (L-12, L-13, L-18, L-19), 5, 10,
`theory_memo.md` §D-00000000, `quality_reports/literature/panel-npiv-discrete/references.bib`,
`scripts/symbolic/{README.md, specs/*}`.
**Not available and not assumed:** the source draft, `instrumental.bib`, any simulation output.

---

## 0. Headline, in four sentences

1. **(O4) is discharged, and A6 is refuted.** The operators are exhibited (`def:hatTexp`,
   `def:hatAcon`); `prp:tccfails` proves that **A6 — a maintained assumption — is false**, with
   probability one, for every constant $\eta_{\rm TCC}<1$ and every ball of positive radius.
2. **$\hat T$ was undefined too.** A6 and A7 are statements about $\hat T$, whose only glossary row
   reads "sample analogue of $T$". `def:hatA` fixed the reading of $\hat{\mathcal A}$ one level down
   and did not sweep the level above it. `eq:hatT` supplies the definition.
3. **The registered nonlinear-LF route does not transfer, and the reason is arithmetic, not
   technical.** Nonlinear Landweber saturates at source index $\mu=\tfrac12$; A5(iii) proves
   $\mu>\tfrac12$ **necessary**. The two are incompatible at exactly one point.
4. **The replacement closes at the same threshold.** `prp:phirate` linearises and runs *linear* LF at
   each stage; the recursion contracts iff $\mu>\tfrac12$. **The condition that kills the inherited
   route is the condition that switches the replacement on.** No TCC is used.

---

## 1. (O4): what was exhibited, and what the verification returned

### 1.1 Exhibition

| Object | Where | Notes |
|---|---|---|
| Integrated kernel $\mathsf C_{h_u}$ | `def:intker`, `lem:intker` | Four properties, each derived from a named clause of C3 |
| $\hat T(\varphi,\theta)$ | `eq:hatT` | **New: this was defined in no file** |
| $\hat T_{h_x}(\varphi,\theta)$ | `eq:hatTx` | The $x$-smoothed variant; new |
| $\Delta_{h_x}\varphi_i$ | `eq:smdiff` | Smoothed period difference |
| $\hat{\mathcal A}_\varphi$, $\hat{\mathcal A}^\ast_\varphi$ | `eq:hatAcon`, `eq:hatAadj` | Discharges (O4)'s exhibition half |

`prp:hatAprop` proves the exhibited operator is bounded, of rank $\le n_{\rm m}$, adjointable into
$\mathcal V$ — **and that clause (iii) is where C3(ii)'s boundary index earns its keep**: without the
exact $x$-normalisation of `lem:intker`(iv) the adjoint leaves $\mathcal V$, which is a type error
against `def:spaces`.

**`def:hatA`'s reading is not only fixed but realised, and its rejected alternative is proved
unavailable.** `prp:hatAprop`(iv): $\hat{\mathcal A}_\varphi$ is the *exact* Fréchet derivative of
$\hat T_{h_x}$. `prp:hatAprop`(v): the Gateaux derivative of $\hat T$ exists but is an **unbounded**
linear map, so $\hat T$ is *nowhere Fréchet differentiable* on $\mathcal V$ — point evaluation is not
continuous on $L^2$. So "the derivative of $\hat T$" does not name an operator at all.

### 1.2 Verification: A6 — **CRITICAL, and it is a refutation**

`prp:tccfails`. Take a triangular spike of height 1 and vanishing width at one design point
$X_{i^*2}$: it is $o(1)$ in $L^2(\pi)$, invisible to $\hat{\mathcal A}_{\tilde\varphi}$ (which sees
only the smoothed functionals), and moves $\hat T$ by a fixed nonzero amount. A6's left side converges
to $\|\Xi_*\|>0$ and its right side to $\eta_{\rm TCC}\|\Xi_*\|<\|\Xi_*\|$.

- Holds **for every** $\eta_{\rm TCC}<1$ (A6 asks for $<\tfrac12$, so a weaker condition is refuted too).
- Holds on **every** ball of positive $L^2(\pi)$ radius.
- Uses **no** clause of A1, A2, H1 — it is a statement about the two *maps*, so no strengthening of the
  model repairs it.

**Diagnosis (`rem:tccwhy`).** A TCC asks a *second-order* quantity to dominate. Pairing $\hat T$ (point
evaluations) with $\hat{\mathcal A}$ (smoothed functionals) leaves a **first-order** discrepancy on the
left. The defect is in the *pairing*, which is exactly the ambiguity `def:hatA` identified — and could
not resolve, having performed no construction.

**Repair, stated but not maintained.** `def:a6b` (**A6b**) pairs $\hat{\mathcal A}$ with the operator
it differentiates. `prp:tccrepair` shows A6b ⟹ A6 for that pair, and gives an explicit radius
`eq:tccrad` $\propto h_u^2h_x^{1/2}\lambda_{\min}(\mathbf G_n)^{1/2}n_{\rm m}^{-1/2}$. **The radius
shrinks with the ill-posedness and no result claims it is bounded away from zero.**

**Range invariance, the one-round attempt, is spent** (`prp:norangeinv`): it forces
$\mathcal R(\hat{\mathcal A}_\varphi)=\mathcal R(\hat{\mathcal A}_{\tilde\varphi})$, which fails because
the spanning kernels are *translates* and translates by more than the support width are independent.
Same argument kills the population version.

**Nothing downstream uses A6 or A6b.** `prp:phirate` needs neither.

### 1.3 Verification: A7 — partially

`prp:stopfeas`. The $T$-component closes **at a fixed $\tau_{\rm DP}$** — and that is where A5(i)'s
$\sqrt{\ln n}$ earns its keep, via Chebyshev on a Hilbert-space second moment. The $\varrho$-component
does **not**: A4(iii) is an $O_P$ statement, and `prp:stopfeas`(ii) exhibits a sequence satisfying
A4(iii) for which $P(\|\hat\varrho-\varrho\|>\tau r_n)\not\to0$ at every fixed $\tau$.

**Two repairs, either sufficient; the second is free** — see §3 item C(3).

---

## 2. `prp:phirate`: what is proved, on what route, and at what cost

**Estimator (`def:lfstep`):** iterated linearisation with *sieve* Landweber–Fridman, DP-stopped at
each stage. **Every LF iteration is applied to a linear equation.**

**Conclusion (`eq:phirate`):** $\|\hat\varphi-\vdagger\|_{L^2(\pi)}=O_P(\delta_n)$ with
$\delta_n=(\hat\delta_n\ln n)^{2\mu/(2\mu+1)}$, and $\delta_n=o_P(n^{-1/4})$ under `eq:frontier`.
**A5(i)–(iii) are discharged. A5(vi) is consumed, not discharged. A5(iv)–(v) are untouched.**

### 2.1 The F-6 / O10 resolution, precisely

| | Inherited route | Route taken |
|---|---|---|
| Regulariser | nonlinear LF on $\hat T$ | linear LF on the stagewise linearisation |
| Needs a TCC | yes (A6 — **false**) | **no** |
| Source index | **saturates at $\mu\le\tfrac12$** | unrestricted above; recursion needs $\mu>\tfrac12$ |
| At $\mu=\tfrac12$ | $\delta_n\asymp n^{-1/4}(\ln n)^{1/4}$ — **not** $o(n^{-1/4})$, even with a perfect propensity | contraction is marginal; $\mu>\tfrac12$ strictly is required |
| Verdict | **incompatible with A5(iii)** | closes |

**The arithmetic core** is $2\kappa-1=(2\mu-1)/(2\mu+1)$ with $\kappa=2\mu/(2\mu+1)$: contraction of
$\varepsilon\mapsto \mathsf c\,\varepsilon^{2\kappa}$ needs $2\kappa>1$, i.e. $\mu>\tfrac12$ — spec
`phirate-fixedpoint-mu-half`. The saturation of nonlinear LF is at the *same* $\mu=\tfrac12$, reached
from the other side, and both trace to the same Heinz-inequality barrier that `lem:srctransfer`(ii)
exhibits.

### 2.2 What is given up, and it should be printed in the paper

1. **Global convergence.** The route needs a *consistent* preliminary $\hat\varphi^{(0)}$ (memo's
   L-14). Where it comes from is an **open item** — see §5 (Q-1).
2. **A sieve.** `lem:srctransfer`(iii): a finite-rank operator cannot satisfy the Hilbert-scale link
   condition on $\mathcal V$, so LF runs on $\mathcal S_n$ and **A8's window is consumed by the
   $\varphi$-step**, not only by the balancing solve. That is a use of A8 the block does not record.
3. **IRGN.** Dunker et al. (2014) use iteratively regularised Gauss–Newton *because* it beats
   Landweber's saturation. The project adopts their noise model and declines their regulariser, and
   then needs $\mu>\tfrac12$. **This is a live positioning tension.** The honest options are two:
   adopt IRGN, or say — as Part H does — that the linearised route reaches the same place under the
   same threshold. The second is cheaper and is what is proved; the first should be *named and priced*
   in the paper, because a methods referee who knows the regularisation literature will ask.

### 2.3 Four new lines Step 6 charges

| # | Condition | Where | Binding? |
|---|---|---|---|
| **N-1** | `eq:entropy`: $\big(\tfrac1{16}+\alpha\big)/s<1-2\alpha$, $\alpha=\tfrac r{2r+d_Z}$ — L-19's entropy cost | `lem:unifop`, `rem:l19cost` | $s>1.75$ at $(\mu,d_Z,r)=(1,3,4.5)$; $s>1$ at $(2,3,2.5)$. **Not binding against mild ill-posedness.** |
| **N-2** | **(P-b)**: $\gamma_n=O(\hat\delta_n^{1/(2\mu+1)})$ — the operator-estimation budget | `lem:aerr`, spec `phirate-operator-noise-budget` | Non-empty $h_x$ window; **not binding** |
| **N-3** | **A5(vi) is charged on BOTH routes** from Step 6 onward, not "balancing only" | `lem:pathcont`(c) | Budget-table amendment |
| **N-4** | **(P-f)**: $\delta_n^2=O(h_u^2\hat\delta_n\ln n)$ | `rem:h6bandwidth` | **BINDING, and it is the one to settle** |

**(P-f) in detail, because it is the live one.** At C5′(i)'s $h_u\asymp n^{-1/16}$ it reads
$\alpha\cdot\frac{2\mu-1}{2\mu+1}\ge\tfrac18$: satisfied with room at $\mu=2$
($\alpha\ge\tfrac5{24}$ vs $\alpha=\tfrac5{16}$), **exactly at the boundary** at
$(\mu,d_Z,r)=(1,3,4.5)$, and **impossible** at $\mu=\tfrac34$ (needs $\alpha\ge\tfrac58>\tfrac12$).

**But C5′(i) is tuned to the wrong target.** It matches the smoothing bias $h_u^{p_K}$ to the
*stochastic floor* $n^{-1/2}$. What Step 6 needs the bias to meet is $\hat\delta_n\gg n^{-1/2}$.
Re-tuning to $h_u\asymp\mathrm{sd}(\Delta U)\,\hat\delta_n^{1/p_K}$ leaves `lem:opnoise`(ii) intact and
converts (P-f) into a clean, $\alpha$-free threshold:

$$\boxed{\;\mu\;\ge\;\tfrac56\;}$$

spec `phirate-retune-mu-five-sixths`. Under H1 and plan §2.6's $s>a+\tfrac12$ (giving
$\mu>\tfrac12+\tfrac1{4a}$) this is **implied whenever $a\le\tfrac34$** and is an extra restriction
otherwise. **Recommendation: amend C5′(i) and add $\mu\ge\tfrac56$ to the budget table.**

---

## 3. Required amendments to the five locked files

Reproduced from the header of `results_partH.tex` items A–E; the two **CRITICAL** ones first.

**C(1) CRITICAL — A6 must leave the maintained block.** It is false (`prp:tccfails`), not merely
strong, and is not repairable by shrinking $\eta_{\rm TCC}$ or $\mathcal V_n$. Replace by the
*property* tag **A6b** (`eq:a6b`), on the A1d/A2b/A2c model. Note that nothing consumes either.

**C(2) CRITICAL — define $\hat T$.** `eq:hatT`. Amend the glossary row, which reads only "sample
analogue of $T$" and points at memo §3.3 prose.

**C(3) — A7.** Either (a) strengthen A4(iii) to $P(\|\hat\varrho-\varrho\|_{L^2}>\mathsf c\,r_n)\to0$
for some finite $\mathsf c$; **or (b) inflate A7's threshold to $\tau_{\rm DP}\hat\delta_n\ln n$**
(`eq:a7amend`). **(b) costs nothing** because `eq:frontier` is a *strict* inequality
(`prp:stopfeas`(iv)). **(b) recommended.**

**C(4) — A5(i) confirmed, one clause loosened.** The $T$-component's *$L^2(\Pi)$-norm* is
$O_P(n^{-1/2})$ with **no logarithm** — Hilbert-space second moment, `lem:opnoise`(i). A5(i)'s
$\sqrt{\ln n}$ is therefore satisfied, and it is **not idle**: `prp:stopfeas`(i) consumes it at a fixed
constant. Record both.

**C(5) — C5′(ii) is conservative; the re-derivation it asks for is `eq:gamman`.** The clause requires
$(nh_x^2h_u^3)^{-1}\ln n\to0$; what `lem:aerr` consumes is $(nh_xh_u)^{-1}\ln n\to0$ — **one** power
each. The inherited exponents 2 and 3 come from a density-*derivative* estimator in the
cross-sectional companion; $\hat{\mathcal A}_\varphi$ estimates a density-weighted conditional mean.
C5′(ii) implies the relaxed condition, so nothing proved is lost.

**C(6) — C5′(i) should be re-tuned**, per §2.3 (P-f). The block's guard against "correcting 16 to 17"
protects a *matching to the wrong target* and must be rewritten with the choice.

**C(7) — the budget table.** Add N-1, (P-b), $\mu\ge\tfrac56$; change A5(vi)'s Route entry from
"balancing only" to "both".

**C(8) — A8's role.** Record that A8's window is consumed by the $\varphi$-step (via
`lem:srctransfer`(iii)), not only by the balancing solve.

**Glossary (item A of the results header):** twelve slots claimed (C45–C57), every one with the sweep
for the **letter claimed** recorded per §1.5b, and **two declined** (blackboard $\mathbb C$, because
`lem:reprsmooth` runs complex exponentials one line away; and a symbol for the discrepancy inflation,
because the natural $a_n$ sits one subscript from the RESERVED degree of ill-posedness $a$ — the exact
species C35 was charged for). **One rule amended in the open:** C13's "$\lambda$ always carries two
arguments $(u,t)$" now reads: *two arguments $(u,t)$ = the Bierens weight; $\lambda_{\min}(\cdot)$ with
a **matrix** argument = an eigenvalue.* `sigma_min` was considered and **rejected**, because
$\sigma_{\rm ess}$ is already a word-subscripted $\sigma$ taking an operator argument and returning a
*set*.

---

## 4. Findings

| # | Finding | Severity |
|---|---|---|
| **H-1** | **A6 is false**, not strong. Proved. | **CRITICAL** |
| **H-2** | **$\hat T$ is used in two maintained assumptions and defined nowhere.** `def:hatA` fixed the level below and did not sweep the level above. | **CRITICAL** |
| **H-3** | **Nonlinear LF saturates at $\mu=\tfrac12$; A5(iii) needs $\mu>\tfrac12$.** The registered route is incompatible with the paper's own frontier, at exactly one point. This is F-6 / O10 made precise. | **CRITICAL (resolved)** |
| **H-4** | $\hat T$ is **nowhere Fréchet differentiable** on $\mathcal V$; the reading `def:hatA` rejects does not name an operator. | MAJOR |
| **H-5** | **(P-f)** is a genuine new restriction, binding at low $\mu$; re-tuning $h_u$ converts it to $\mu\ge\tfrac56$. C5′(i) is tuned to the wrong target. | MAJOR |
| **H-6** | **A5(vi) is charged on both routes** from Step 6, not "balancing only". | MAJOR |
| **H-7** | **A7 is not verifiable at a fixed $\tau_{\rm DP}$** from A4(iii); an $O_P$ hypothesis cannot yield a fixed-constant exceedance bound. Counterexample given. | MAJOR |
| **H-8** | C5′(ii)'s exponents (2 on $h_x$, 3 on $h_u$) are inherited from the wrong estimator; the correct pair is (1,1). | MODERATE |
| **H-9** | **L-19 runs the wrong way in $r$**: a smoother propensity makes it *harder*, because $\hat\delta_n$ is a tighter target. And it **excludes $\alpha\to\tfrac12$** — L-19 at rate $\hat\delta_n$ is unavailable when the propensity component does not bind strictly. | MODERATE |
| **H-10** | The **VC-subgraph** route registered for L-19 in memo §3.4 is not available: the class is indexed by an infinite-dimensional $\varphi$ through a smooth transformation and is not VC-subgraph. Smoothness of the index set, not combinatorial dimension, supplies the entropy — which is *why* the ball must be a source-condition ball. (Consistent with the standing instruction; recorded because §3.4's honest restatement names VC.) | MODERATE |
| **H-11** | **C3(ii) and C3(iii) cannot both hold literally** at $s_0=1$: the support clause gives $[0,c_C]$ (one-sided) and (iii) calls the kernel *symmetric*. Inherited from `assapp3a`. **Nothing in Part H depends on the resolution** — every use is of $[-c_C,c_C]$ and of the order conditions — but the clash should be repaired. | MODERATE |
| **H-12** | **C3 does not print the normalisation** $h^{-1}\int C_h(w,s_0)dw=1$. It is what "of order $p_K$" means for a generalized kernel and is consumed at `lem:intker`(i),(iii),(iv) — the last of which is what keeps $\hat{\mathcal A}^\ast$ inside $\mathcal V$. Should be printed. | MODERATE |
| **H-13** | The memo's registered containment mechanism for the LF path ("$\varphi_m-\varphi_0\in\mathcal R(\hat{\mathcal A}^\ast)$, norm polynomial in the cap") gives a bound **linear in $\bar m_n$** and therefore does **not** place the path in a ball of fixed radius. Containment comes from the *stopping rule*. | MODERATE |
| **H-14** | `eq:gamman`'s propensity term carries $(h_xh_u)^{-1/2}$; an earlier draft of the proof asserted the factor cancelled. It does not. The bound is likely loose (the *mean* is $O(r_n)$ with no bandwidth) but sharpening it needs $\|\hat\varrho-\varrho\|_\infty$, which **no clause prices** — consistent with the glossary's $r_n$ row. | MINOR |
| **H-15** | $\hat{\mathcal A}_\varphi$ is **computable without knowing $\pi$**; only its *kernel* carries $\pi^{-1}$. Worth one sentence in the paper, since $\pi$'s status (stationary density "if it exists") is otherwise a nuisance. | MINOR |

---

## 5. Open items and escalations

**Q-1 (escalation, coordinator or user).** **Where does $\hat\varphi^{(0)}$ come from?** `prp:phirate`
requires a preliminary with $\|\hat\varphi^{(0)}-\vdagger\|_{L^2(\pi)}=o_P(1)$. This is memo L-14's
object, registered there as LOW risk and as a *consequence* of `prp:phirate` — which is now backwards:
the linearised route makes consistency an **input**. Options: (a) a small number of nonlinear LF steps
from $\varphi=0$, which needs the very TCC that fails; (b) a Tikhonov/sieve-minimum-distance
preliminary, which needs its own analysis; (c) assume it, and say so. **User decision.**

**Q-2 (escalation, user).** **IRGN or not.** See §2.2 item 3. Adopting IRGN removes the saturation
problem at its source and matches the noise model the project already adopts; declining it is
defensible only if the linearised route is printed as the substitute, with the threshold $\mu>\tfrac12$
named. **The positioning claim "we adopt Dunker et al.'s noise model and reject their regulariser"
should not be printed without the accompanying threshold.**

**Q-3.** **Is $\lambda_{\min}(\mathbf G_n)$ bounded below at a usable rate?** Needed only for A6b's
radius `eq:tccrad`, which no theorem consumes — so this is a *simulation* question (probe CP-8), not a
theory obligation. Flagged so it is not mistaken for one.

**Q-4.** The **link condition on $\mathcal S_n$** (`lem:srctransfer`(iii), hypothesis (P-a)) is
assumed, not derived. Deriving it would need the singular values of $\hat{\mathcal A}_\varphi$
restricted to the spline sieve to track $j^{-a}$, which is a genuine open problem and is the
Hilbert-scale analogue of A2's own status. **Recorded as open, on the A1b(iii) model.**

**Q-5.** `lem:unifop` clause (a) rests on **one unpinned classical fact**, the sup-norm entropy of a
Sobolev ball (F-e). **Clause (b), the sieve version, is what `prp:phirate` consumes and is elementary**
(volumetric bound, proved inline). The separation is deliberate: *no conclusion of Part H depends on
an unpinned entropy theorem.*

**N-13 is NOT inherited.** Memo §5's "$Q(h)\ne0$ necessarily" does not follow and is the
coordinator's; nothing in Part H uses it.

**`rem:sharpscope`(2) is respected.** `rem:phirscope`(1) states explicitly that Part H does **not**
reinstate memo §2.5(iii)'s "$\delta_n=o(n^{-1/4})$ is sharp for this moment function". `eq:phirate` is
an **upper** bound; what `thm:rootn` inherits from Part G is the **lower** bound on the second-order
form. Different objects, neither a sharpness claim about $\hat\varphi$.

**One trap for `thm:rootn`.** `eq:phirate`'s $\delta_n$ is $(\hat\delta_n\ln n)^{2\mu/(2\mu+1)}$, not
$\hat\delta_n^{2\mu/(2\mu+1)}$ as A5(ii) writes. The two differ by $(\ln n)^{2\mu/(2\mu+1)}$, absorbed
by the frontier's strictness but **not absorbed into the symbol**.

---

## 6. Bibliography — FLAG FOR THE LIBRARIAN (the trap fired again)

**Checked against `quality_reports/literature/panel-npiv-discrete/references.bib`, as instructed.**

| Key | In that file? | Status |
|---|---|---|
| `hanke1995` | **NO** — Area L header says "already in instrumental.bib. Annotated only." | **CITED in `results_partH.tex` (`prp:norangeinv`, `rem:lfnonlinear`). WILL BREAK THE BUILD.** |
| `engl2000` | **NO** — same header. **And it is already cited in `assumptions.tex:997` (H1).** | **WILL BREAK THE BUILD, and already would.** |
| `chenreiss2011` | **NO** — same header | Not cited by Part H |
| `dunker2014` | **NO** — listed in the "already in instrumental.bib" roll at `:53` | **Cited in prose only** (`rem:lfnonlinear` names the authors and year without `\cite`), deliberately, so nothing breaks |

**This is exactly the `bierens1990` / `feve2014` failure repeating.** Those two had to be copied into
`references.bib` after biber reported "I didn't find a database entry"; `hanke1995` and `engl2000` are
in the same position and `engl2000` is *already* cited from a locked file. The file's own header
records the problem at `:64–74` ("BIBLIOGRAPHY AUTHORITY IS UNDECLARED") and says a user decision is
required. **Requested: copy `hanke1995`, `engl2000` and `chenreiss2011` into
`quality_reports/literature/panel-npiv-discrete/references.bib`, and add `dunker2014`**, which Part H
would cite properly once it resolves.

**Two further pins named but not cited**, following Part G's practice of naming an intended pin in a
comment rather than adding an unresolvable `\cite`:

- (F-d) bounded differences — **proved inline** (`lem:bdiff`); intended pin McDiarmid (1989) or
  Boucheron–Lugosi–Massart (2013, Thm 6.2).
- (F-e) sup-norm entropy of a Sobolev ball — **not proved**; intended pin Birman–Solomjak (1967),
  Kolmogorov–Tikhomirov (1961), or van der Vaart–Wellner (1996, Thm 2.7.1). Used only in
  `lem:unifop`(a), which nothing consumes. **None of these three resolves in `references.bib` either.**

---

## 7. Specs written

| Spec | Verifies |
|---|---|
| `phirate-fixedpoint-mu-half` | $2\kappa-1=(2\mu-1)/(2\mu+1)$ — the contraction threshold **and** the saturation threshold are the same $\mu=\tfrac12$ |
| `phirate-retune-mu-five-sixths` | $(2\mu-1)/(2\mu+1)-\tfrac14=(6\mu-5)/(4(2\mu+1))$ — the re-tuned (P-f) threshold is exactly $\mu=\tfrac56$, not a rounded value |
| `l19-entropy-exponent` | $(h_u\hat\delta_n)^{-1/s}=n^{(1/16+\alpha)/s}$ |
| `l19-effective-sample` | $n\hat\delta_n^2=n^{1-2\alpha}$ — positive iff $\alpha<\tfrac12$ (H-9) |
| `aerr-propensity-scaling` | $h_u^{-1}h_u^{1/2}=h_u^{-1/2}$ — the factor that does **not** cancel (H-14) |
| `phirate-operator-noise-budget` | $1-2\mu/(2\mu+1)=1/(2\mu+1)$ — (P-b) is weaker than $\gamma_n=O(\hat\delta_n)$ |

**I have not run them.** Per the standing constraint, the coordinator runs the specs and the build.
