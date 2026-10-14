# Regularity Audit — `panel-npiv-discrete` (dispatch 2 + Part F)

**Critic:** regularity-checker (read-only; persisted by the orchestrator)
**Files audited:** `quality_reports/theory/panel-npiv-discrete/{proofs.tex,results.tex,assumptions.tex}` — read end to end (1597 / 1213 / 1224 lines), plus the notation-glossary entries for `L`, `ell_star`, `q`, `S`.

**Score: 0 / 100** (floored; raw −156: 2 CRITICAL ×−20, 8 MAJOR ×−10, 12 MINOR ×−3).

> **Filename note (orchestrator).** `regularity-audit.md` holds the **dispatch-1** record (13/100, Stage 3 dispatch 1). This report is persisted alongside it rather than over it — the same discipline the theorist-critic enforced when `proofs_review.md` was about to be overwritten.

> **Read the floor with the distribution, not as a verdict on the artifact.** The critic's own calibration: Parts A–C (`prp:wellposed`, `prp:frechet`, `prp:compact`, `lem:bierenscore`, `lem:quantu`, `lem:bierens`, `lem:density`) generated **one MINOR between them** and are described as "above the standard I usually see." Part E generated two MAJORs. **Both CRITICALs and five of the eight MAJORs sit in Part F** — `lem:solset`, `lem:secondord`, `prp:orthog`, `lem:balance`.

---

## Part 0 — Disposition of the four items handed over

| # | Handed item | Verdict |
|---|---|---|
| 1 | Compactness of $\tilde{\mathcal K}+\tilde{\mathcal K}^\ast$ asserted at `proofs.tex:1288` | **CONFIRMED TRUE — computation supplied.** MAJOR (unstated but fully available step), not CRITICAL. |
| 2 | Integrability of the shifted direction | **PROVISO REQUIRED — an extended-real reading does NOT rescue it.** Escalated to CRITICAL (F-1). |
| 3 | Non-atomicity of $\pi\,dx$ under Weyl | **CONFIRMED GAP** — MINOR (m-1). |
| 4 | Envelope list omits $D$ and $\partial_uD$ | **CONFIRMED, and worse than stated** — MAJOR (F-3). |

**On item 1, the critic did not merely confirm — it reconstructed the argument.** $\tilde{\mathcal K}h=(\mathcal Kh)/\pi$ has kernel $\tilde{\mathsf k}(x_1,x_2)=q(x_1,x_2)f_{X_1,X_2}(x_1,x_2)/\{\pi(x_1)\pi(x_2)\}$ **on $L^2(\pi)$**, so

$$\|\tilde{\mathcal K}\|_{\rm HS}^2=\iint\frac{(qf_{X_1,X_2})^2}{\pi(x_1)\pi(x_2)}\,dx_1dx_2\;\le\;\|q\|_\infty^2\,\|1/\pi\|_\infty^2\,\|f_{X_1,X_2}\|_\infty\;<\;\infty,$$

using $|q|\le\|\partial_u\ell_\star\|_\infty$ from (P1) and `cor:elldiff` (finite under A2′(i.a)–(i.b)) and C1(ii) for $\|f_{X_1,X_2}\|_\infty$, $\|1/\pi\|_\infty$. Hilbert–Schmidt ⟹ compact; the adjoint of a compact operator is compact; the sum is compact and self-adjoint. **No compactness of $\mathcal X$ is used** — only $\iint f_{X_1,X_2}=1$. **Every tag needed is already in `lem:solset`'s hypothesis list.**

**On item 2, the verdict is narrower and sharper than the question posed.** `eq:crossshift` *alone* survives an extended-real reading — its right side is defined in $[0,\infty]$ for any measurable $D$, and where finite, Cauchy–Schwarz makes the bound valid. **But that does not rescue the statement of `lem:secondord`.** Clause (iii) does not merely bound the cross-partial, it *names* it; clause (ii) asserts $\partial^2_{\tau_2\tau_2}m\equiv0$ "identically in $\tau$." Both presuppose $m(\tau)$ exists off $\tau_1=0$. See F-1.

---

## CRITICAL

### F-1 — `proofs.tex:1332–1354`, `results.tex:1081–1087`: `lem:secondord`(ii)–(iii) presuppose the shifted moment exists

**Condition silently used:** $E|D(\Delta U-\tau_1\Delta h,\Delta Z)|<\infty$ for $\tau_1\ne0$ — so that $m(\tau)$ in `eq:mtau` is a real number off $\tau_1=0$ and "$\partial^2m$" names something.

**Tag coverage: none.** `lem:secondord`'s only hypothesis on $D$ is $E[D\mid\Delta Z]=0$ — a statement at the **true** residual. A2′ prices $\ell^\Pi_\star$; A5(iv) prices $\|\partial_u(\hat L-L_\star)\|_{L^2(P)}$, again at the true residual. Nothing touches the shifted law.

**And it is plausibly false — by a two-character edit to the paper's own printed counterexample at `proofs.tex:1359–1365`.** Keep every element of that construction ($\Delta Z$ degenerate, $r\equiv1$, $\tau_1=1$, $\Delta U\sim\mathrm{Unif}[0,1]$, $\Delta h=-1$ on $A$ with $P(A)=\tfrac12$ and $0$ off $A$) and replace $D(u,z)=M\mathbf 1\{u\in[1,2]\}$ by

$$D(u,z)\;=\;\mathbf 1\{u>1\}\,(u-1)^{-1}.$$

Then $D(\Delta U,\Delta Z)=0$ a.s., so $E[D\mid\Delta Z]=0$ and $\|D\|_{L^2(P)}=0$ — **every hypothesis of (iii) holds.** But on $A$ the argument is $\Delta U+1$, and $E|r\,D(\Delta U-\tau_1\Delta h,\Delta Z)|=\tfrac12\int_0^1u^{-1}du=\infty$. So $m(1,\tau_2,\tau_3)$ is undefined for every $\tau_2\ne0$; clause (ii)'s "identically in $\tau$" is not merely unproved but **ill-posed**, and clause (iii)'s "the cross-partial is $-E[\cdots]$" names a non-existent object. `eq:crossshift` degenerates to $|\text{undefined}|\le\infty$.

**This is the asymmetry the surrounding prose was written to catch, one level further in:** the proof correctly refuses to bound the shifted *norm* by the unshifted one, then silently assumes the shifted *expectation* exists.

**Minimal condition** — for some $\bar\tau>0$, either
$$\sup_{|\tau_1|\le\bar\tau}E\big[D(\Delta U-\tau_1\Delta h,\Delta Z)^2\big]<\infty$$
or the sufficient primitive the proof already gestures at at `:1367`: $\sup_{|\tau_1|\le\bar\tau}\|dP_{(\Delta U-\tau_1\Delta h,\Delta Z)}/dP_{(\Delta U,\Delta Z)}\|_\infty<\infty$, under which $\|D(\cdot-\tau_1\Delta h,\cdot)\|_{L^2(P)}\le C\|D\|_{L^2(P)}$ and both (ii) and (iii) go through.

**Whichever is chosen, the proviso must sit in `lem:secondord`'s hypothesis list, not only in the closing sentence of Step 4.** `proofs.tex:1370–1371` tells Steps 6–7 to supply the control; clauses (ii) and (iii) *as printed* have already consumed it.

### F-2 — `proofs.tex:1305–1308, 1422–1437`, `results.tex:1114–1122`: `eq:mtau` and `prp:orthog`(iii) — the moment's own integrability, and $L_\star$ is undefined

**Condition silently used:** $E|\widetilde W\,L_\star(\Delta U,\Delta Z)|<\infty$; for (iii) also $E[|L_\star|\mid\Delta Z]<\infty$ a.s.

**Tag coverage: none — and the object is never defined.** $L_\star$ appears in `eq:mtau`, `lem:secondord`, `prp:orthog`(ii)–(iii), A5(iv) and the glossary's $\epsilon_n$ row, but is **defined nowhere** in `results.tex`, `assumptions.tex` or `notation_glossary.md`. The glossary defines $\ell_\star:=\mathcal W\ell^\Pi_\star$ (`:153`) and a generic $L$ "normalised by N1" (`:149`); $L_\star$ exists only through the aside "$\mathcal W\ell^\Pi_\star=\partial_uL_\star$". So $L_\star$ is **an antiderivative in $u$ of $\ell_\star$ with a free constant of integration $b(\Delta Z)$**, and nothing constrains $b$.

> **Independently confirmed by the notation-warden**, which found $L_\star$ undefined across the same three files plus the glossary. Two critics, different rubrics, same object.

**Why this is substantive, not formal.** A2′ prices $\ell_\star$ — (i.a)–(i.b) are sup-norms on $\ell^\Pi_\star$, (ii) is $E[\widetilde W^2\ell_\star^2]<\infty$. **None of them touch $L_\star$.** Under N1 the gap closes in two lines: N1 pins $b(z)=-E[\int_0^{\Delta U}\ell_\star(v,z)dv\mid\Delta Z=z]$, whence $E|L_\star(\Delta U,\Delta Z)|\le2\|\ell_\star\|_\infty E|\Delta U|<\infty$ by A1b(iv). **But `prp:orthog` deliberately withholds N1** (`results.tex:1100`: "N1 is not assumed in any part"). With N1 withheld, $b$ is arbitrary; take any non-integrable $b(\Delta Z)$ and

- (a) $m(0)$ is undefined;
- (b) $E[L_\star\mid\Delta Z]$ on the right side of the equivalence is undefined;
- (c) the "$\Rightarrow$" direction at `:1430–1437` **constructs its perturbation direction out of the undefined object**, $r=\varepsilon_\varrho\operatorname{sign}(E[L_{\star,j}\mid\Delta Z])$.

**A second, related mis-pricing.** The moment is $\psi=\Delta Z\,\Delta U+\widetilde WL_\star$, so its variance — the object A4's note (d) invokes for irregular identification à la Khan–Tamer — is governed by $E[\widetilde W^2L_\star^2]$. A2′(ii) prices $E[\widetilde W^2\ell_\star^2]$, i.e. **the derivative**. This is the same referent slip A5(iv)'s round-5 correction fixed in the opposite direction, unfixed here.

**Minimal condition:** define $L_\star$ (as the N1-normalised antiderivative of $\ell_\star$, or as an element of $L^2(P_{\Delta U,\Delta Z})$ with $\partial_uL_\star=\ell_\star$), and add either $L_\star\in L^2(P_{\Delta U,\Delta Z})$ as a standing Part F convention or a clause $E[\widetilde W^2L_\star^2]<\infty$ alongside A2′(ii). For `prp:orthog`(iii) the weakest sufficient proviso is $E[|L_\star|\mid\Delta Z]<\infty$ a.s. and $E|L_\star|<\infty$ — **not implied by anything currently assumed once N1 is withdrawn**, and therefore a required hypothesis of (iii) if the equivalence is to stay non-vacuous.

---

## MAJOR

### F-3 — `proofs.tex:1288`: compactness of $\tilde{\mathcal K}+\tilde{\mathcal K}^\ast$ asserted in a four-word parenthesis
True; unproved; **load-bearing twice** (it licenses Weyl, and `prp:sharpquad` will inherit it). Print the three-line Hilbert–Schmidt computation of Part 0 and cite C1(ii) + `cor:elldiff` explicitly. **No new condition.**

### F-4 — `proofs.tex:1268–1290`, `results.tex:1058–1065`: the Weyl argument is run on the wrong space

**(a) Boundedness of the multiplication part** is never said. It holds — $|\sigma_q(x)|\le\|\partial_u\ell_\star\|_\infty(f_{X_1}(x)+f_{X_2}(x))$ gives $\|\sigma_q/\pi\|_\infty\le2\bar c_\pi\|\partial_u\ell_\star\|_\infty<\infty$ by C1(ii) and `cor:elldiff` — but without it the essential-spectrum statement is about an unbounded operator.

**(b) Domain collision, and this one is substantive.** `def:spaces` insists, in italics: "*Every operator in this paper has domain $\mathcal V$, not $L^2(\pi)$.*" But $\mathcal V=\{h:\int h\pi\,dx=0\}$ is **not invariant under $M_{\sigma_q/\pi}$**, so $\mathcal B$ is not an operator on $\mathcal V$ at all. The quadratic form in `lem:secondord`(i) is evaluated only at $h\in\mathcal V$, so the sharp constant is $\tfrac12\|P_{\mathcal V}\mathcal B_{\rm sym}P_{\mathcal V}|_{\mathcal V}\|$, whereas Weyl and $\|\sigma_q/\pi\|_\infty$ speak about $\mathcal B_{\rm sym}$ on all of $L^2(\pi)$. **The two are not the same operator and the proof does not say which one the display bounds.**

**The conclusion survives, through a step nobody has taken:** $\mathcal B_{\rm sym}-P_{\mathcal V}\mathcal B_{\rm sym}P_{\mathcal V}$ has rank $\le2$ ($\mathcal V$ has codimension one), and a finite-rank perturbation changes no essential spectrum, so $\sigma_{\rm ess}(P_{\mathcal V}\mathcal B_{\rm sym}P_{\mathcal V}|_{\mathcal V})=\sigma_{\rm ess}(\mathcal B_{\rm sym})$ and the lower bound transfers.

**No new condition** — but state $\|\sigma_q/\pi\|_\infty<\infty$ from C1(ii)+`cor:elldiff`, say explicitly that $\mathcal B$ is read on $L^2(\pi)$, and record the codimension-one compression. **Otherwise `prp:sharpquad` at Step 4 inherits a norm taken on a space `def:spaces` has forbidden.**

### F-5 — `proofs.tex:1309–1312, 1377–1384`, `results.tex:1088–1091`: `lem:secondord` Step 1's envelope list, and clause (iv)'s proviso

Step 1 closes with "**Differentiation under the expectation is licensed by these envelopes alone.**" The list contains **no envelope for $D$ and none for $\partial_uD$** — so the sentence is false for $\partial_{\tau_2}m$, $\partial^2_{\tau_2\tau_2}m$, $\partial^2_{\tau_2\tau_3}m$ and $\partial^2_{\tau_1\tau_2}m$: **four of the six second-order terms the lemma is about.**

**Clause (iv)'s own proviso does not repair it.** "$\partial_uD$ exists with $\|\partial_uD\|_{L^2(P)}<\infty$" is a statement at the **unshifted** argument. $\partial^2_{\tau_1\tau_2}m(0)$ differentiates $\tau_2D(\Delta U-\tau_1\Delta h,\Delta Z)$ in $\tau_1$ and needs a **$\tau_1$-uniform** integrable envelope for $\sup_{|\tau_1|\le\bar\tau}|\partial_uD(\Delta U-\tau_1\Delta h,\Delta Z)\Delta h|$. **Same shift asymmetry as F-1, now biting at $\tau=0$ — where the paper believes it is safe.**

**Minimal condition:** add to the direction class $\sup_{|\tau_1|\le\bar\tau}E[\partial_uD(\Delta U-\tau_1\Delta h,\Delta Z)^2]<\infty$ (plus the analogue for $D$, which F-1 already requires). DCT with envelope $\sup_{|\tau_1|\le\bar\tau}|\partial_uD|\cdot|\Delta h|$ — integrable by Cauchy–Schwarz and `lem:nusigma`(i) — then licenses the interchange and recovers the printed bound $2\bar c_\pi^{1/2}\|\partial_uD\|_{L^2(P)}\|h\|_{L^2(\pi)}$ at $\tau=0$.

**Do not over-repair.** The $\tau_1$-differentiations of the $L_\star$ term **are** properly licensed: `cor:elldiff` makes $\partial_uL_\star=\ell_\star$ and $\partial^2_uL_\star=\partial_u\ell_\star$ exist, be continuous and bounded, so $\|\ell_\star\|_\infty|\Delta h|$ and $\|\partial_u\ell_\star\|_\infty(\Delta h)^2$ are genuine envelopes and clause (i) plus the $(\tau_1,\tau_3)$ half of (iv) go through. **The defect is confined to the $D$-direction.**

### F-6 — `proofs.tex:94–107, 113–122, 847–853`: (P7a) applied outside (P6)'s stated scope *(carried)*

(P6)'s substitution lemma requires $f$ **bounded**. `lem:adjoint` Step 3 applies (P7a) with $f(v,z)=\varpi_u(v)\int_{\mathcal T}\ell(v,t)w(t'\Phi(z))\Pi_t(dt)$ — jointly measurable by Step 2 ✓, $V=\Delta Z$ is $\mathcal F_{XZW}$-measurable ✓ — **but not bounded**, since $\ell$ is only in $L^2(\Pi)$. **The lemma (P7a) cites does not cover the use (P7a) makes of it**, and `lem:adjoint` Step 3 inherits the gap. This is the convention on which the entire N-10 closure rests.

**Repair available from within the proof:** Step 2 gives $\mathcal W\ell\in L^2(P_{\Delta U,\Delta Z})\subset L^1(P)$, so $E|f(\Delta U,\Delta Z)|<\infty$ and the bounded case extends by truncation + monotone convergence. Restate (P6) for $f$ jointly measurable with $E[|f(\Delta U,V)|\mid\mathcal F_{XZW}]<\infty$ a.s. (functional monotone class), and record $\mathcal W\ell\in L^1(P)$ at `:847`.

*Two riders on the same step:* the passage to the iterated integral at `eq:adjstep` is a Fubini step (licensed by $\|\bar f_0\|_\infty c_\Pi\|\ell\|_{L^2(\Pi)}<\infty$, uncited); and (P7a)'s identification of $\mu^{\mathcal F}(\omega,\cdot)$'s density with $f_{\Delta U\mid\mathcal F_{XZW}}$ holds for a.e. $\omega$, not every $\omega$.

### F-7 — `proofs.tex:1006–1010`: `cor:udep` Step 1's fundamental theorem of calculus *(carried)*

"$\partial_uL(u,z)=c(z)$ gives $L(u,z)=c(z)u+b(z)$ **by the fundamental theorem of calculus in $u$**." The hypothesis (`results.tex:875`) is only "let $L$ satisfy $\partial_uL(u,z)=c(z)$" — no smoothness, no sense of differentiation declared. **The two readings need different theorems:**

- **Everywhere-pointwise** derivative ⟹ follows from the **mean value theorem** on $u\mapsto L(u,z)-c(z)u$; no absolute continuity, and **the FTC is the wrong citation**.
- **A.e.** — which is how derivatives of $L$-type nuisances are meant everywhere else in the block (A5(iv), `lem:density`) — ⟹ the FTC *is* right and the conclusion is **false without absolute continuity**: the Cantor function has zero a.e.-derivative and is not constant.

**Do not over-repair Step 4.** The contrapositive at `:1047–1053` makes the same move on $\ell_\star$ and **there it is sound** — `cor:elldiff` makes $\ell_\star$ continuously differentiable in $u$, so a vanishing derivative is an everywhere-vanishing continuous derivative and the MVT applies. **The asymmetry is that the corollary's $L$ is a bare hypothesis while its $\ell_\star$ inherits `cor:elldiff`.**

### F-8 — `proofs.tex:1245–1253`, `results.tex:1054–1055`: `lem:solset`(ii)'s "every member of that image"

`prp:orthog`(i) does not merely equate two defined quantities — it asserts $\partial_{\tau_1}m(0)$ **exists**, and its proof (`:1397–1399`) gets this "by the envelopes of `lem:secondord` Step 1", i.e. by $\|\ell_\star\|_\infty<\infty$ — which is `lem:solset`'s **admissibility** clause A2′(i.a)–(i.b), not a property of a generic solution. The image $\mathcal W(\ell^\Pi_\dagger+\ker\mathcal A^\ast_{\rm cond})$ contains members with no sup-norm bound. For those the (P5) proviso survives (Cauchy–Schwarz + C1(ii)), but **the differentiation under the expectation does not.**

**Minimal condition:** restrict (ii) to "every **admissible** member" — the term `lem:solset` already defines — or supply the alternative envelope $|\ell(\Delta U,\Delta Z)||\Delta h|$ and note it dominates uniformly in $\tau_1$ only under F-1's shifted condition. **The headline "validity does not select" is currently stated one class wider than it is proved.**

### F-9 — `assumptions.tex:36–40` (A0) and consumers at `:873–880` (A8), `proofs.tex:1484–1500`, `:755–766`: $\mathcal X$ is never declared connected

A0 says "$\mathcal X\subset\mathbb R$ **compact**". Four separate results consume **compact interval**:

| Site | What it needs |
|---|---|
| A8 | "a B-spline basis of order exceeding $s$ on a **quasi-uniform mesh over $\mathcal X$**" |
| `lem:balance` Step 4 | $\|(I-P^{\rm Leb}_{L_x})\zeta\|_{L^2(dx)}\le CL_x^{-s}\|\zeta\|_{H^s}$ (Schumaker Thm 6.27) |
| H1 | "the source set is a ball of the **Sobolev scale of order $s$**" |
| `lem:levels`(i) | $\mathcal D_0^{-1}$ integrates "from the **left endpoint** of $\mathcal X$" |

Compactness alone permits a Cantor set, a convergent sequence with its limit, or a countable union of intervals — on any of which all four are undefined or false. C1(ii) + $\iint f=1$ forces finite positive Lebesgue measure, **which a fat Cantor set has.**

**Minimal condition:** amend A0 to "$\mathcal X=[\underline x,\bar x]\subset\mathbb R$ a compact interval." **Free** — the application has a scalar continuous regressor.

### F-10 — `proofs.tex:1447–1462`, `results.tex:1130–1138`: `lem:balance`'s cross-fitting is never made a hypothesis

"let $\hat\ell$ be computed on an auxiliary fold" is a sentence about the algorithm; three properties the argument uses are never declared:

1. **$\nu_g$ at a random $g$ is a conditional object.** `eq:nudef` defines $\nu_g$ for a fixed integrable $g$. With $g=\Delta Z+\widetilde W\hat\ell$ this must be read **with $\hat\ell$ frozen**; otherwise $E[g\mid X_2=x]$ mixes estimation noise into the conditional expectation and Step 2's identity $\nu_g=\nu_{\widetilde W(\hat\ell-\ell_\star)}$ fails.
2. **Independence of the folds** — A0's i.i.d. clause supplies it *once the split is declared*, and the declaration is absent.
3. **$\hat\ell\in L^2(P_{\Delta U,\Delta Z})$ a.s.**, so $\mathcal B$ (domain fixed by `cor:rangegap`) may be applied to $\hat\ell-\ell_\star$ at all. A5(iv) implies it in $O_P$ terms but does not state membership.

**Minimal condition:** state the sample-splitting convention once (auxiliary fold $\mathcal I_a$, main fold $\mathcal I_m$, independent by A0; $\hat\ell$ is $\sigma(\mathcal I_a)$-measurable; all $\nu$-objects and $O_P$ statements in `lem:balance` are conditional on $\sigma(\mathcal I_a)$), and add $\hat\ell\in L^2$ a.s. to the hypotheses.

---

## MINOR

| ID | Site | Finding |
|---|---|---|
| **m-1** | `proofs.tex:1287–1289` | Weyl needs $\sigma_{\rm ess}(M_{\sigma_q/\pi})=\operatorname{ess\,ran}(\sigma_q/\pi)$. For multiplication operators the *full* spectrum is always the essential range; the *essential* spectrum equals it **only when the measure is non-atomic** (an atom makes $\phi(x_0)$ a finite-multiplicity eigenvalue). Here $\pi\,dx\ll$ Lebesgue, so the condition is available — **but it is not automatic and must be said.** |
| **m-2** | `proofs.tex:1170–1172` | `cor:elldiff` asserts *continuous* differentiability; Leibniz gives only differentiability. **The round-5 (α) repair is confirmed correct** — the sup-inside form $\int(\sup_u\|\partial_u\ell^\Pi_\star\|)\bar w\,d\Pi_t=\Lambda^{(1)}_\star<\infty$ is *exactly* Leibniz's dominating hypothesis, and the round-4 sup-outside form is not. Missing is only the extra DCT pass for **continuity** of $u\mapsto\int\partial_u\ell^\Pi_\star w\,d\Pi_t$. |
| **m-3** | `assumptions.tex:497–500` | A2′(i.a)–(i.b) are **version-dependent**: $\ell^\Pi_\star\in L^2(\Pi)$ is an equivalence class, and $\sup_u|\ell^\Pi_\star(u,t)|$ / "continuously differentiable in $u$" are not invariant under $\Pi$-null modification — yet `cor:elldiff`'s conclusions are evaluated at the **random** point $(\Delta U,\Delta Z)$. Fix: "…admits a version satisfying (i.a)–(i.b), and $\ell_\star:=\mathcal W\ell^\Pi_\star$ is defined pointwise from that version." |
| **m-4** | `results.tex:1079`, `proofs.tex:1324–1326` | No jointly measurable version of $q$ or $\sigma_q$. `prp:compact` Step 0 constructs exactly this kind of object via (P6b) and says why it must be constructed; nothing analogous for $q$, even though $\mathcal K$ is *defined* by kernel $qf_{X_1,X_2}$ and $\|q\|_\infty$ is used as a sup bound. |
| **m-5** | `proofs.tex:1326–1329` | Term-by-term splitting of $E[q(\Delta h)^2]$ into three expectations — the same move (P5)'s scope note devotes a paragraph to. Proviso needed and available. |
| **m-6** | `proofs.tex:1263–1266` | The two-point witness ($X_1,X_2\in\{1,2\}$, $f\equiv1$) contradicts `def:model` ("continuously distributed") and C1(ii). The algebraic point is correct; **as printed it does not exhibit two admissible selections within the paper's own hypotheses.** Flag as finite-dimensional illustration, or use a two-cell piecewise-constant $q$ on continuous $\mathcal X$. |
| **m-7** | `proofs.tex:1486–1489` | H1 sets $\mu=s/(2a)$ and A5's table runs $\mu\in\{0.75,1,1.5,2,3\}$, so **$s$ need not be an integer**; Schumaker Thm 6.27 is a Sobolev-scale statement and fractional $s$ needs the Besov/interpolation scale. *(The $L^2(dx)\to L^2(\pi)$ transfer itself is **correct as repaired** — both inequalities re-verified, single factor right, round-5 second factor indeed spurious.)* |
| **m-8** | `proofs.tex:912–915` | $\|\ell_\epsilon\|^2\le k\,\Pi_t(B_\epsilon)^{-1}\|\varsigma\|^2$ needs $\mathrm{Leb}(\mathcal U_k)<\infty$. True — $\mathcal U_k=\{\varpi_u\ge1/k\}$ and $\int\varpi_u=\Pi_u(\mathbb R)<\infty$ by B1(iv.a) give $\mathrm{Leb}(\mathcal U_k)\le k\Pi_u(\mathbb R)$ — but it is **finiteness of $\Pi_u$, not positivity of $\varpi_u$**, that supplies it, and neither is cited. |
| **m-9** | `proofs.tex:171–178` | (P6a) fixes $G_\varphi(\omega,\cdot)$ for *every* $\omega$; C2′(i) supplies density and $C^2$ for *a.e.* $\omega$. Step 2's Taylor expansion is fine a.s.; acknowledge the null set once. |
| **m-10** | `proofs.tex:123–126` | (P7b)'s $f_{\Delta U}(u)=E[f_{\Delta U\mid\mathcal F_{XZW}}(u)]$ is a **Tonelli** step (nonnegative integrand, no side condition) — name it. |
| **m-11** | `assumptions.tex:136–207` | **A1c's "the two are not equivalent" comment is stale.** The block asserts in capitals that the passage "is not free" and lists five ingredients — and the dispatch-2 addendum forty lines later says `prp:kerchar` **proves** it. The regularity content is discharged: `prp:kerchar`(i) supplies the $L^2(\Pi)$-a.e.-to-pointwise upgrade and continuity in $u$; (ii) consumes A1 and A4(i); the reference measure is $P_{\Delta U,\Delta Z}$, available unconditionally. **Documentation fix only** — rewrite the head so a reader does not carry away a debt the same file closes. |
| **m-12** | `proofs.tex:845` | `eq:adjstep`'s split of $\int_{\mathbb R\times\mathcal T}\Pi(du,dt)$ into the iterated form is a Fubini step on $\Pi_u\otimes\Pi_t$; `lem:adjfubini` covers the *adjacent* $\Pi\otimes P$ interchange, not this one. |

---

## Root cause

> **An object is priced at the true residual and then used at a shifted or unnormalised one.**

`eq:crossshift` catches this for the *norm* of $D$. The same slip is uncaught for the **integrability** of $D$ (F-1), for the **$\tau_1$-uniform envelope** of $\partial_uD$ (F-5), and for the **antiderivative** $L_\star$ once N1 is withdrawn (F-2). **Two hypothesis clauses — a shift-uniform $L^2$ bound on the direction class, and an integrability clause on $L_\star$ — close all three.**

## What the critic verified rather than flagged

- **The Weyl chain is sound.** Not refuted — reconstructed. Needs three added sentences at `proofs.tex:1284–1290` (Hilbert–Schmidt, boundedness of $\sigma_q/\pi$, non-atomicity) plus the codimension-one compression.
- **The A2′(i.b) sup-inside repair is correct**, checked against all three Leibniz hypotheses.
- **The $L^2(dx)\to L^2(\pi)$ transfer is correct as repaired**, both inequalities re-derived; the round-5 second factor was indeed spurious.
- **Parts A–C generated one MINOR between them.** The integral-form Taylor remainder with its measurable-selection reason, `prp:compact` Step 0's jointly measurable kernel construction, (P5)'s term-by-term proviso and scope note, and `prp:nophifree` Step 0's Banach–Steinhaus argument are all named as above-standard.
