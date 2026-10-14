# Derivative-Parameterisation Route — Feasibility Assessment

**Project:** `panel-npiv-discrete` · **Agent:** theorist · **Date:** 2026-07-30
**Scope:** feasibility only. **No edits to `results.tex`, `proofs.tex`, `assumptions.tex`, `notation_glossary.md`.**
**Question put:** does Centorrino, Fève & Florens (2025)'s derivative reparameterisation transfer to this
setting, and does it dissolve regularity-checker finding **C1**?

---

## 0. Pre-Theory Report — what was read

| Input | Read | Status |
|---|---|---|
| `quality_reports/regularity/regularity-audit_partH.md` | in full | C1 + 11 MAJOR + 6 MINOR; sequencing note |
| CFF (2025), *J. Econometrics* 247, 105950 | **pp. 1–15**: §1, §2 (incl. Assns 2.1–2.3, Def. 2.2, Props 2.1–2.2, Examples 1–2), **§3 in full** (incl. Eqs. 12–17 and implementation notes 1–7), **§4 in full** (Assns 4.1–4.7, Props 4.1–4.2, Thm 4.1, Cor 4.2), §5 to p. 15 | primary source for the device |
| `results.tex` | `def:model`, `def:spaces`, `def:operator`, `prp:frechet`, `prp:compact`, `rem:nupi`, `rem:draftrec`(iii)–(iv), `lem:nusigma`, `lem:adjfubini`, **`lem:levels`**, `lem:adjoint`, `prp:orthog`, `lem:balance` head, `eq:smdiff`/`eq:hatTx`, `def:hatAcon`/`eq:hatg`, `prp:hatAprop`, `prp:tccfails`, `def:srcball`, `lem:unifop`, **`lem:srctransfer`**, `lem:scaleinv`, `def:lfstep`, **`prp:phirate`**, `rem:lfnonlinear`, `rem:phirscope` | |
| `proofs.tex` | **proof of `lem:levels`** (L827–874); `rem:ff`/`eq:ff`; `prp:phirate` Steps 1–4 (L3960–4210), i.e. (L1)–(L5), `eq:effnoise`, `eq:linlf`, `eq:linlftot`, `eq:fixedpoint`, `eq:prelimrate` | |
| `assumptions.tex` | A2, A2′ head, **H1** + its comment block, A3, A4, **A5** (all clauses) + comments, **A8** + comment, budget-table paragraph | |
| `theory_memo.md` | §§D-00000000000, D-0000000000, D-000000000 (dispatch tables + open items Q-1, Q-4, Q-6) | truncated read; §§ below L447 not read |
| `.claude/references/domain-profile.md` | **NOT PRESENT** — glob returns nothing | declared gap |
| `Bibliography_base.bib` | **not consulted in this dispatch** | see §11 |

**Missing inputs, declared rather than assumed.** (a) There is no domain profile at
`.claude/references/domain-profile.md`; foundational-reference conventions were taken from the block's own
citation note instead. (b) **CFF's supplementary material (Sections A–D) was not read** — it contains the
proofs of Props 4.1, 4.2 and Theorem 4.1. Consequence: I can state where CFF's Assumption 4.4 (link)
appears in the *statements*, and that the *rate* in Thm 4.1 is written in $\beta$ alone with no $s$ or $a$
in it, but I **cannot certify** that 4.4 is unused in the proofs. §2(c) flags this. (c) Dunker (2021) and
Dunker et al. (2014) were not read; §11's attribution finding rests on CFF's own text.

---

## 1. Recommendation

**The device does not transfer. Do not adopt it.** Three findings, in decreasing order of force:

1. **It pushes the wrong way.** CFF's device is a remedy for a **saturation ceiling** on the source index.
   This paper has no saturation ceiling — `def:lfstep` runs **linear** LF with the discrepancy principle at
   each stage, and (L5)'s own note says so: *"the exponent $2\mu/(2\mu+1)$ is available for every
   $\mu>0$."* The binding constraint here, `eq:muhalf`, is a **floor**, $\mu>\tfrac56$, and it comes from
   (P-f) — remainder domination — not from qualification. Composing $\mathcal D^{-1}$ into the operator
   **lowers** the achievable source index at fixed $(s,a)$, from $\mu=\frac{s}{2a}$ to
   $\mu=\frac{s-1}{2(a+1)}$, because $\mathcal D^{-1}$ makes the operator **more** ill-posed (degree
   $a\mapsto a+1$). At the block's own frontier-clearing configuration $(\mu,s,a)=(2,3,\tfrac34)$ the
   device returns $\mu=\tfrac{2}{3.5}=0.571$, which **fails `eq:muhalf`.** §4 and §7.

2. **It does not close C1 by any mechanism the spectral restatement does not already supply.** C1
   dissolves precisely because the source condition is stated **spectrally on the operator regularised**.
   That is available in levels, at the cost of one paragraph. $\mathcal D^{-1}$ contributes nothing to the
   dissolution — and CFF pays the *same* price the checker's third remedy charges: CFF assumes 4.3
   (spectral, primitive, $\beta$ free) **and** 4.4 (link) **separately**, exactly the four-to-three
   collapse the orchestrator hoped would survive. §5.

3. **It does not close A3 either.** A3's compression-versus-restriction naming is *identical* in the two
   parameterisations: $(\hat{\mathcal A}\mathcal D^{-1}_0|_{\mathcal S'_n})^\ast$ maps into
   $\mathcal S'_n$ for the same reason $(\hat{\mathcal A}|_{\mathcal S_n})^\ast$ maps into $\mathcal S_n$,
   so (L2) survives verbatim and the naming defect survives verbatim. §8.

**Between the two remaining remedies: take the spectral restatement (checker's remedy 3), not the
commutativity proviso.** The decisive argument is one line: **Option A = Option B + a proviso**, so
Option B's hypothesis is *strictly weaker* and needs *strictly less* proved. §10 gives the trade-off in
full, including what H1 does and does not lose.

**Three things in CFF are worth taking, and none of them is the derivative device.** §12: CFF's
Assumption (18) as a replacement for the tangential cone condition; CFF's *placement* of the source
condition at a deterministic limit; and a citation correction. And **the assessment hands `lem:levels`
its consumer for free** (§3.4) — as the proof that the levels choice is optimal, which is the one thing it
was proved for and never used to say.

---

## 2. The device, read from CFF, in this paper's letters

**(a) What CFF does.** With $\varphi'_\dagger:=D\varphi_\dagger=\partial\varphi_\dagger/\partial x_1$ and
$(D^{-1}\varphi')(x)=\int_0^{x_1}\varphi'(\xi,x_{-1})\,d\xi$, CFF sets $A_{\varphi_\dagger}:=T'_{\varphi_\dagger}D^{-1}$
and iterates (Eq. 12)
$$\varphi'_{j+1}=\varphi'_j-c\,A^\ast_{\varphi_j}T(\varphi_j),\qquad \varphi_j=D^{-1}\varphi'_j,$$
recovering $\hat\varphi_j$ by integration at implementation note (7). §3's own justification is the one
the dispatch quotes: LF *"cannot take full advantage of the smoothness of the regression function (i.e.,
it saturates at a certain level of regularity) … saturates at $s=a$ … prevents achieving a faster
convergence rate."*

**(b) Where the source condition sits, and this is the load-bearing fact.** CFF's **Assumption 4.3** is
$$\varphi'_0-\varphi'_\dagger=\big(A^\ast_{\varphi_\dagger}A_{\varphi_\dagger}\big)^{\beta/2}v,\qquad\|v\|=1,$$
i.e. **spectral on the composed operator, primitive, with $\beta$ existentially quantified.** So the
orchestrator's reading is *correct as far as it goes*: there is no Hilbert-scale-to-spectral conversion
inside CFF's rate proof, and Theorem 4.1's rate is written in $\beta$ with **no $s$ and no $a$ appearing
in it**.

**(c) But CFF still carries a link condition, and it exercises the same two-sided equivalence C1 objects
to.** **Assumption 4.4** is $(T'^{\ast}_{\varphi_\dagger}T'_{\varphi_\dagger})^{1/(2a)}\sim D^{-1}$ for
$a>1$, and CFF's §4 uses it exactly to translate: *"if $s$ is the speed of decay of the generalized
Fourier coefficients of $\varphi_0-\varphi_\dagger$, $\beta=\frac{s-1}{a+1}$, then Assumption 4.3 is
equivalent to $\varphi'_0-\varphi'_\dagger=(T'^{\ast}T')^{\frac{s-1}{2a}}v$."* **That equivalence is an
operator-interpolation claim at exponent $\frac{s-1}{a}$**, and at this paper's configurations that
exponent exceeds 1 — at $(s,a)=(3,\tfrac34)$ it is $2.67$. So the device does not remove the interpolation
obligation; it **relocates it from the proof to the interpretation.** That relocation is a genuine gain
in status — an interpretation defect is not a proof gap — but **it is exactly and only the gain the
spectral restatement of (P-a) delivers, at a fraction of the cost.**
*Scope: Assumption 4.4 is in Theorem 4.1's hypothesis list. Because I did not read the supplementary
proofs, I cannot rule out that 4.4 is consumed there for something other than the translation. The rate's
form is evidence, not proof.*

**(d) CFF's saturation is not removed, only re-priced.** Theorem 4.1 runs at
$\beta_c=\beta\wedge(1-\epsilon)$, and CFF states the limit twice: *"we need $\beta\le1-\epsilon$"* and
*"we cannot reach the optimal rate for any $\beta>1-\epsilon$."* In $\mu=\beta/2$ that ceiling is
**$\mu\lesssim\tfrac12$ — the same $\tfrac12$ this file's `lem:srctransfer` and
`rem:lfnonlinear`(3) live at.** The additional $\epsilon$ is the density-of-residuals bias (Assn 4.7(iii),
via $h_u$ and $\kappa_n$) and is CFF's analogue of this paper's $h_u^{-2}$ term — read as a **ceiling** in
CFF because the outer iteration is nonlinear, and as a **floor** here, (P-f), because the outer loop is a
finite sequence of linearisations. **Same bandwidth mechanism, opposite direction, and that is the whole
of §7.**

**(e) So what the device actually buys, stated exactly.** At fixed $(s,a)$ it converts a $\beta$-budget of
$s/a$ into one of $(s-1)/(a+1)$ — *smaller*. Its value to CFF is that the **ceiling** $\beta\le1$ then
covers more Sobolev smoothness: $\beta\le1$ reads $s\le a+2$ in derivatives against $s\le a$ in levels.
CFF's *"the estimation of the first derivative allows us to extend our result to more regular functions,
as the order of convergence of $\hat\varphi_N$ to $\varphi_\dagger$ is improved by integration"* is that
sentence. **Two units of $s$, bought by lowering $\mu$ under a ceiling.** This paper needs $\mu$ raised
above a floor.

---

## 3. Transfer question 1 — does $\mathcal D^{-1}$ compose with $\Delta$?

**Yes, and more cleanly here than in CFF. This part is entirely favourable and it is already proved.**

**3.1 The composition, computed.** With $\mathcal D^{-1}_0$ of `lem:levels` — integration from
$\underline x$ then centring in $L^2(\pi)$ — and $h=\mathcal D^{-1}_0h'$,
$$\Delta\big(\mathcal D^{-1}_0h'\big)=\int_{\underline x}^{X_2}h'-\int_{\underline x}^{X_1}h'=\int_{X_1}^{X_2}h'(v)\,dv=\int_{\mathcal X}\big[\un(v\le X_2)-\un(v\le X_1)\big]h'(v)\,dv,$$
so, by `eq:Adef` and `prp:compact`'s kernel,
$$\mathcal A_{\mathrm{cond}}\mathcal D^{-1}_0h'(u,t)=\int_{\mathcal X}\mathcal N_{g_{u,t}}(v)\,h'(v)\,dv,\qquad \mathcal N_g(v)=\int_{\{x\ge v\}\cap\mathcal X}\nu_g(x)\,dx.$$
**$\mathcal N_g$ is `lem:levels`(ii)'s object, defined there and nowhere else in the file.** So
`lem:levels`(ii) *is* the kernel computation for the composed operator, and its conclusion
($\mathcal N_g\equiv0\iff\nu_g\equiv0$) is the statement that composing $\mathcal D^{-1}_0$ does not
enlarge the kernel.

**3.2 On the left-endpoint normalisation and $\mathcal V$'s centring — the interaction is not merely
correct, it is void.** $\Delta$ annihilates constants (`lem:nusigma`(ii)), so **the centring cancels in
the difference and the composed operator does not see which anti-derivative is taken.** Every choice of
lower limit gives the same $\mathcal A_{\mathrm{cond}}\mathcal D^{-1}$. This is strictly better than CFF,
where the normalisation of $D^{-1}$ at $0$ is a real convention. The file already knows the fact and
records it in the one place a reader would look: `results.tex:603` says the draft's kernel
$\un(x\ge v)$ **is** $\mathcal D^{-1}$, *"present because the draft parameterises in derivatives"*, and
`:644` names $\mathcal D^{-1}$ *"the integration operator of the derivative parameterisation"*.
*Where the centring is not void:* it fixes the **codomain** at $\mathcal V$, which is what makes
`lem:levels`(iv) a statement about elements of the parameter space, and it is what the factor $2$ in
$\|\mathcal D^{-1}_0\|\le2(|\mathcal X|\|1/\pi\|_\infty)^{1/2}$ pays for (`proofs.tex:840`). Dropping the
centring halves the constant and breaks (iv)'s typing.

**3.3 One real structural cost: a second exception to `def:spaces`.** The composed operator's **domain is
$L^2(\pi)$, not $\mathcal V$** — `lem:levels`(i) types $\mathcal D^{-1}_0:L^{2}(\pi)\to\mathcal V$. But
`def:spaces` declares *"Every operator in this paper has domain $\mathcal V$, with one declared
exception"* ($\mathcal B$). The derivative route adds a second. The kernel hazard H1's comment block
warns of does **not** recur — $\mathcal D^{-1}_0$ is injective on all of $L^2(\pi)$ (`proofs.tex:841–843`)
and a constant derivative maps to a non-constant, non-centred level, so it is not annihilated — but
`prp:compact`'s singular system, **H1's $\sigma_j\asymp j^{-a}$**, A2's Picard form and A1c's completeness
are all stated for $\mathcal A_{\mathrm{cond}}$ **on $\mathcal V$** and would each need restating on
$L^2(\pi)$ for the composed operator. That is a re-derivation across Parts A, C and E, not a Part-H edit.

**3.4 Is `lem:levels` the operator this device needs? Yes — all four clauses, and that is why it has zero
consumers.** Read against the device:

| Clause | What the device needs it for |
|---|---|
| (i) $\|\mathcal D^{-1}_0\|\le2(|\mathcal X|\|1/\pi\|_\infty)^{1/2}$, injective | the constant $\omega_n$ must absorb; and injectivity for (iii) |
| (ii) $\mathcal N_g\equiv0\iff\nu_g\equiv0$ | the composed kernel and its triviality |
| (iii) A2 $\iff$ the same for $\mathcal A_{\mathrm{cond}}\mathcal D^{-1}_0$ | that $\theta$'s source condition is parameterisation-free |
| (iv) $\|h\|_{L^2(\pi)}\le\|\mathcal D^{-1}_0\|\,\|h'\|_{L^2(\pi)}$ | converting a derivative-norm rate to the level-norm rate A5(ii) writes |

**Two extensions are needed and one over-reach must be flagged.**

- **Extension needed (sieve).** (i)–(iv) are ambient. The sieve version — $\mathcal D^{-1}_0$ exact on
  splines, order $q\mapsto q+1$, and the direct theorem re-read at Sobolev order $s-1$ — is not in
  `lem:levels` and is §4's cost.
- **Extension needed (sample operator, data-dependent base point).** (iii) is stated for the *population*
  operator at the *truth*. (P-a) is about $\hat{\mathcal A}_{\hat\varphi^{(k-1)}}$ at a *random* base
  point. The argument transfers — injectivity of $(\mathcal D^{-1}_0)^\ast$ plus density of
  $\mathcal R(\mathcal D^{-1}_0)$ in $\mathcal V$, both in `proofs.tex:854–858`, are base-point-free — but
  it is a different statement and would have to be stated.
- **OVER-REACH, and it should be recorded whatever is decided.** `lem:levels`'s headline reads *"The
  orthogonality condition and the source condition are the same in the two parameterisations."* For
  **A2** — a plain range condition $\nu/\pi\in\mathcal R(\mathcal A^\ast_{\mathrm{cond}})$ — that is true
  and is what (iii) proves. For **(P-a)'s source condition at index $\mu$** it is **false**, and §4 gives
  the arithmetic: the index *changes*, from $s/(2a)$ to $(s-1)/(2(a+1))$. The proof of (iii) is a
  range-of-the-adjoint argument and cannot see a general $\mu$. **A reader who takes the headline as a
  licence for the device will be misled**, and the headline should be scoped to A2. *(This is the same
  species as dispatch-8's MAJOR 2.3 — a correct statement whose stated generality exceeds what its proof
  delivers.)*

---

## 4. Transfer question 2 — does it survive the sieve?

**It survives, and it charges exactly one unit of $s$ on the sieve window plus one re-declaration.**

**4.1 What is free.**

- **`prp:hatAprop`(i) / $\omega_n$.** $\|\hat{\mathcal A}_\varphi\mathcal D^{-1}_0\|\le\|\hat{\mathcal A}_\varphi\|\cdot\|\mathcal D^{-1}_0\|$,
  so `eq:normconst` inflates by the *constant* of `lem:levels`(i) and by nothing $n$-dependent.
  `lem:scaleinv` is stated for a generic bounded $\mathcal L$ and covers it **verbatim, all five clauses.**
- **(L2), and this is the finding that kills the A3 hope.** With
  $\mathcal L:=\omega_n^{-1}\hat{\mathcal A}_{\varphi_\circ}\mathcal D^{-1}_0|_{\mathcal S'_n}$ the adjoint
  of a *restriction* maps into the restricted subspace, so $\mathcal L^\ast$ maps into $\mathcal S'_n$
  and the projection is again the identity on the iterates. **(L2) survives unchanged — and so does its
  defect.** The operator analysed is the *compression* in both parameterisations.
- **A5(vi′).** In derivatives the object is $\max_k\|\hat\varphi'^{(k)}-\varphi'_\dagger\|_{H^{s-1}}=O_P(1)$,
  which is the same statement one index down on a derivative. Free.
- **`lem:unifop`.** It prices $\sup_{\varphi\in\mathcal V_n}\|\hat T(\varphi)-T(\varphi)\|$, a statement
  about the **level** $\varphi$ entering $\hat T$. The reparameterisation changes the iteration, not
  $\hat T$. Free. Same for `eq:entropysieve`, which is volumetric in $L_x$ and $s$-free.
- **Step 3's conclusion.** (F-f) delivers a **derivative**-norm bound; A5(ii) is written in the **level**
  norm; `lem:levels`(iv) converts, with the constant already computed. Free, and it is the one clause of
  `lem:levels` whose direction is favourable.

**4.2 What it costs — `eq:lxwindow` moves up by exactly 1.** The direct theorem now approximates
$\bar v'_\dagger$, of Sobolev order $s-1$, so (P-c) becomes $\mathsf R L_x^{-(s-1)}=O(h_u\hat\delta_n)$,
i.e. $L_x\gg n^{9\alpha/(8(s-1))}$ at $h_u\asymp\hat\delta_n^{1/8}$, against (P-d)'s
$L_x=o(n^{1-2\alpha}/\ln n)$. Non-empty iff
$$\boxed{\;s\;>\;1+\frac{9\alpha}{8(1-2\alpha)}\;}$$
— **$s>2.6875$ at $\alpha=\tfrac38$** (against `eq:lxwindow`'s $1.6875$) and **$s>2$ at $\alpha=0.32$**
(against $1$). A8's *basis* clause weakens correspondingly (order exceeding $s-1$ suffices), which is not
a compensation: it is the same one unit, seen from the other side.

**4.3 What must be re-declared.** $\mathcal S_n$ becomes a sieve **in derivatives**, $\mathcal S'_n$, and
$\mathcal D^{-1}_0\mathcal S'_n$ is a spline space one order higher. So A8's basis clause, `def:lfstep`'s
$\mathcal S_n$, `def:srcball`, (P-c), (P-d) and `eq:lxwindow` are all re-read in derivatives.
$\mathcal D^{-1}_0$ **does not** commute with $L^2(\pi)$-projection, so nothing may be silently swapped;
but by 4.1 nothing needs to be, because the restriction-then-adjoint device does the work.

**4.4 One containment worth naming.** (F-e)'s bracketing bound
$\log N_{[\,]}(\epsilon,\mathcal V_n,\|\cdot\|_\infty)\le\mathsf c_6(\mathsf R/\epsilon)^{1/s}$ requires
$s>\tfrac12$; read at order $s-1$ it requires $s>\tfrac32$ and gives exponent $1/(s-1)$. This bites only
in `eq:entropy`, which dispatch 7 already made consumer-free, so the impact is contained — but the
inherited statement would be wrong if copied.

---

## 5. C1: does it dissolve, and does H1's collapse survive?

**5.1 It dissolves — but not because of $\mathcal D^{-1}$.** C1's mechanism is that (L5) converts
(a) $\|\bar v_\dagger\|_{H^s}\le\mathsf R$ plus (b) a link condition into (F-f)'s spectral hypothesis, and
that the conversion is operator interpolation, valid only at $2\mu\le1$, while `eq:muhalf` forces
$2\mu>\tfrac53$. **The conversion disappears the moment the source condition is stated spectrally on the
operator regularised.** That is true of $\hat{\mathcal A}_{\varphi_\circ}$ and of
$\hat{\mathcal A}_{\varphi_\circ}\mathcal D^{-1}_0$ alike. $\mathcal D^{-1}$ is not doing the work; the
*restatement* is.

**5.2 And H1's four-to-three collapse does NOT survive the device — CFF is the witness.** The
orchestrator's conjecture was that *"$\mu$ stays linked to $D$'s properties."* CFF shows otherwise: it
assumes **4.3 (spectral, $\beta$ free) and 4.4 (link) as two separate assumptions**, and 4.4's stated role
in §4 is to translate $\beta$ into $(s,a)$ — the interpretive layer, exercising the same two-sided
equivalence at exponent $(s-1)/a>1$ (§2(c)). So the parameter count under the device is
$(\beta,s,a)$ with $s$ interpretive: **four parameters, with one of them soft.** That is precisely the
cost the checker's third remedy names. The device does not avoid it; it pays it in CFF's own text.

**5.3 A sharper observation, and it cheapens Option B materially.** `lem:srctransfer`(iii) already
records that the link condition *"cannot hold on all of $\mathcal V$ because $\hat{\mathcal A}$ has finite
rank by `prp:hatAprop`(ii)"*, and is therefore *imposed on the sieve*. H1's matching is a statement about
the **population** operator $\mathcal A_{\mathrm{cond}}$ on $\mathcal V$; (P-a)'s link clause is a
statement about the **realised, finite-rank, sieve-restricted** operator at a **random** base point.
**These are different conditions, and H1 never delivered $\mu=s/(2a)$ for the second one — (P-a) assumes
its own matching.** So the identity `prp:phirate` prints in its hypothesis line, *"with $\mu=s/(2a)$"*, is
already a *transported* claim rather than H1's own, and the collapse it advertises is already partly
illusory at (P-a). Option B does not destroy the collapse; **it makes visible that (P-a) was already
carrying it as an assumption.**

---

## 6. Transfer question 3 — `prp:orthog` and the $\sqrt n$ result for $\theta$

**The $\theta$ result is NOT broken by the reparameterisation. It is broken by the reparameterisation's
*rate*, which is §7.** The distinction matters and I state it as the dispatch asks — plainly.

**6.1 `prp:orthog`(i) is invariant, and the file already contains the proof.** (i)'s derivative is
$\partial_{\tau_1}\Psi_L(0)=-\langle\nu_{\Delta Z+\widetilde W\ell}/\pi,\;h\rangle_{L^2(\pi)}$, quantified
over $h\in\mathcal V$. At $h=\mathcal D^{-1}_0h'$,
$$\partial_{\tau_1}\Psi_L(0)=-\big\langle(\mathcal D^{-1}_0)^\ast\big(\nu_{\Delta Z+\widetilde W\ell}/\pi\big),\;h'\big\rangle_{L^2(\pi)},$$
which vanishes for every $h'\in L^2(\pi)$ iff
$(\mathcal D^{-1}_0)^\ast(\nu_{\Delta Z+\widetilde W\ell}/\pi)=0$, iff
$\nu_{\Delta Z+\widetilde W\ell}\equiv0$ — **by the injectivity of $(\mathcal D^{-1}_0)^\ast$ proved at
`proofs.tex:854–858` for `lem:levels`(iii).** Equivalently and more directly:
$\mathcal R(\mathcal D^{-1}_0)$ is dense in $\mathcal V$ (it contains every centred $C^1$ function), and
$h\mapsto\partial_{\tau_1}\Psi_L(0)$ is a bounded linear functional on $\mathcal V$ by `lem:nusigma`(iii)
and Cauchy–Schwarz, so vanishing on a dense set is vanishing on $\mathcal V$. **`eq:orthphi` is
unchanged, and so is $\ell_\star$, $L_\star$, A2, A3's $J$, and N1.** No new assumption. This is
`lem:levels`'s headline read at the clause where it *is* true.

**6.2 Parts (ii) and (iii) are untouched** — they perturb $L$ and $\varrho$, not $\varphi$, and neither
sees the parameterisation.

**6.3 The second-order layer is untouched structurally.** `lem:secondord`, `prp:sharpquad`,
`lem:balance` and A5(ii)/(iv)/(v) are denominated in $\|h\|_{L^2(\pi)}$, $\delta_n$, $\epsilon_n$. The
device supplies $\|h'\|=O_P(\delta'_n)$ and `lem:levels`(iv) supplies
$\|h\|\le\|\mathcal D^{-1}_0\|\,\delta'_n$. So every downstream statement reads at
$\delta_n:=\|\mathcal D^{-1}_0\|\delta'_n$ — **a constant multiple. The architecture of `thm:rootn` is
undisturbed.**

**6.4 What *is* broken, said plainly.** `thm:rootn` needs A5(ii)'s $\delta_n=o_P(n^{-1/4})$ and
A5(iv)'s $\delta_n\epsilon_n=o_P(n^{-1/2})$. Under the device $\delta'_n=(\hat\delta_n\ln n)^{\kappa'}$
with $\kappa'=2\mu'/(2\mu'+1)$ and $\mu'=(s-1)/(2(a+1))<\mu$. **At the block's admissible configuration
$\mu'=0.571$, so `eq:muhalf` fails and `eq:phirate` is not proved at all** — Step 7 then has no
$\delta_n$, which is exactly the gating condition the checker records for C1. So: **the device does not
break the $\theta$ result's construction; it fails to supply its input.** The dispatch's instruction
applies — *"if this breaks the $\theta$ result, the device is unavailable however well it fixes C1"* — and
the honest form of that verdict is: **it is unavailable because it cannot feed `thm:rootn` at any
configuration the rest of the block admits.**

---

## 7. Transfer question 4 — `eq:muhalf`, re-derived under $\mathcal A=\hat{\mathcal A}\mathcal D^{-1}_0$

**7.1 `eq:muhalf` survives as an inequality on $\mu$, verbatim — nothing in its derivation sees
$\mathcal D^{-1}$.** (P-f) is $\delta_n^2=O(h_u^2\hat\delta_n\ln n)$; in powers of $n$ with
$\hat\delta_n=n^{-\alpha}$, $h_u=n^{-\beta_{\rm bw}}$ and $\delta_n=(\hat\delta_n\ln n)^\kappa$ it reads
$2\kappa\alpha\ge2\beta_{\rm bw}+\alpha$; at C5′(i)'s amended $\beta_{\rm bw}=\alpha/p_K=\alpha/8$ this is
$\kappa>\tfrac58$, i.e. $\mu>\tfrac56$. **Every step is in $(\kappa,\alpha,\beta_{\rm bw})$ and none in
the operator's conditioning.** Step 4(a.1)'s identity — $\alpha(2\kappa-1)>2\beta_{\rm bw}$ *is* (P-f) —
is likewise untouched, as is `eq:prelimrate`. *So `eq:muhalf` is re-derived, not assumed to survive, and
it does survive.*

**7.2 What changes is the price of $\mu$ in $s$, and it changes by a constant.** Under matching in the
sense H1 names, $\|\mathcal A_{\mathrm{cond}}\zeta\|\asymp\|\zeta\|_{H^{-a}}$ gives
$\|\mathcal A_{\mathrm{cond}}\mathcal D^{-1}_0\zeta'\|\asymp\|\zeta'\|_{H^{-a-1}}$, so the composed
operator has **degree of ill-posedness $a+1$**, and the object carrying the source condition is
$\zeta'=\mathcal D\zeta$, of Sobolev order $s-1$. Hence
$$\mu_{\rm lev}=\frac{s}{2a}\qquad\text{versus}\qquad \mu_{\rm der}=\frac{s-1}{2(a+1)},$$
matching CFF's $\beta=(s-1)/(a+1)$ with $\mu=\beta/2$ exactly. And **$\mu_{\rm der}<\mu_{\rm lev}$ for
every $s>0,a>0$**, since $(s-1)/(2(a+1))<s/(2a)\iff -a<s$. Therefore
$$\mu_{\rm lev}>\tfrac56\iff s>\tfrac53a,\qquad \mu_{\rm der}>\tfrac56\iff s>\tfrac53a+\tfrac83 .$$
**The device charges exactly $\tfrac83$ additional units of $s$, uniformly in $a$.**

**7.3 The two numbers.**

| | levels (the file) | derivative device |
|---|---|---|
| At the block's frontier-clearing configuration $(s,a)=(3,\tfrac34)$ | $\mu=2$ ✔ clears `eq:muhalf` | $\mu=0.571$ ✘ **fails `eq:muhalf`** |
| … and its `eq:frontier` at $d_Z=3$ | $r>2.5$ | $r>22.5$ — **not a condition a referee grants** |
| $s$ needed for $\mu>\tfrac56$ at $a=\tfrac34$ | $s>1.25$ | $s>3.917$ |
| `eq:frontier` at $\mu$ just above $\tfrac56$, $d_Z=3$ | $r>6$ | $r>6$ (same — it depends on $\mu$ only) |
| `eq:lxwindow` at $\alpha=\tfrac38$ | $s>1.6875$ | $s>2.6875$ |

So the cost is payable *in principle* — take $s>3.917$, and $p_K=8\ge s-\tfrac12$ keeps A10's repaired
route intact, and the $L_x$ window is non-empty at $\alpha=0.4$ — but the paper then buys $\mu$ just above
$\tfrac56$ where it currently has $\mu=2$ with room, and the propensity frontier tightens from $r>2.5$ to
$r>6$ at $d_Z=3$. **Against zero benefit.**

**7.4 CFF's "additional saturation effect on $\beta$", relayed and weighed.** CFF's ceiling
$\beta\le1-\epsilon$ arises because *"we need the regularization bias to go to zero fast enough so that
the additional bias from the nonparametric estimation of the unknown density of the residuals is
negligible"* — Assumption 4.7(iii), in $h_u$ and $\kappa_n$. This paper's (P-f) requires the
**linearisation remainder** $h_u^{-2}\varepsilon^2$ to be dominated by $\hat\delta_n\ln n$. Both are
$h_u$-driven conditions relating a bias to a noise level, and I do **not** claim they are the same
condition. What I do claim, and it is the whole point: **CFF's binds from above and this paper's from
below, because CFF's outer iteration is nonlinear and accumulates regularisation bias across $N$, while
this paper's outer loop is a finite sequence of linear solves whose regularisation bias does not
accumulate.** `def:lfstep`'s closing sentence already says the thing that makes this true: *"Every
Landweber iteration in this construction is applied to a **linear** equation; the nonlinearity is carried
by the outer index $k$ and by nothing else."*

---

## 8. Transfer question 5 — what it closes, leaves, and creates; and the A1/A2 sequencing answer

**8.1 C1 — CLOSED, by the spectral restatement, with or without the device.** §5.

**8.2 A3 — NOT closed by the device.** §4.1's (L2) computation: the adjoint of the restriction maps into
the restricted subspace in both parameterisations, so the operator analysed is the compression
$P\hat{\mathcal P}P$ either way, and (L5) names $\hat{\mathcal P}$ either way. **A3 is a naming defect in
both, and it closes as the checker says — as a by-product of restating (P-a) *on the compression*.** The
device is orthogonal to it.

**8.3 A1/A2 — the sequencing question, answered: BOTH radii, and they are currently one symbol.** The
checker's instruction is that the shape of the (P-a) repair determines whether A1 and A2 must pin
$\mathsf R$, $\mathsf R_\ast$, or both. **Under either surviving remedy the answer is both, because the
restatement forces a split that the file does not yet make.** Trace $\mathsf R$'s live sites:

| Site | Which radius it is |
|---|---|
| `def:srcball`/`eq:srcball`, A5(vi′), (F-e)'s entropy, `eq:entropy`, `lem:unifop` Step 4 | **$\mathsf R$** — the $H^s$ ball radius |
| (P-c) $\mathsf RL_x^{-s}=O(h_u\hat\delta_n)$; (P-g) $\mathsf Rh_x^{s-1/2}=O(\hat\delta_n)$ | **$\mathsf R$** — approximation/bias, an $H^s$ statement |
| $\mathsf c_{17}:=2c_\mu\mathsf R^{1/(2\mu+1)}$ in `eq:linlf`, hence $\mathsf c_{15}\ge\mathsf c_{17}$ in `def:lfstep` | **$\mathsf R_\ast$** — the **spectral pre-image** norm (F-f) is applied at |

**One symbol is carrying an $H^s$ radius and a spectral pre-image norm, on the two sides of an inequality
`def:lfstep` must establish.** That is the same species as dispatch-8's MAJOR 2.1 ($\mathsf c_{14}$ versus
$\mathsf c_{16}$) and dispatch-7's `eq:effnoise` defect, and it is what makes A2's *"$\mathsf R$ is not a
free tuning constant"* both true and under-stated: it is not one constant. **Concretely, the repair
order the checker asks for is:** (1) restate (P-a) spectrally on the compression, which closes C1 and A3;
(2) in the same pass split $\mathsf R$ (deterministic ball radius, fixed and large — L-19 requires
$\mathcal V_n$ deterministic) from $\mathsf R_\ast$ (spectral pre-image, fixed because $\mathsf c_{15}$ is
printed before the data are seen); (3) *then* A1 and A2, which are now two statements about two objects
and not one existential over a shared constant. **Repairing A1 first would indeed pin a constant to an
object step (1) renames — the checker's warning is correct and this is the mechanism.**
*Under the commutativity proviso there is a **third** constant to pin: the interpolation constant $c$ in
$A^{-2\mu}\preceq c^2B^{-2\mu}$, which multiplies into $\mathsf R_\ast$. One more reason for Option B.*

**8.4 What the device would CREATE.** (a) A second declared exception to `def:spaces`, with
`prp:compact`/H1/A2/A1c restated on $L^2(\pi)$ (§3.3). (b) `eq:lxwindow` up by 1 (§4.2). (c) A8's basis
clause, $\mathcal S_n$, `def:srcball` re-declared in derivatives (§4.3). (d) $\tfrac83$ units of $s$
(§7.2). (e) **H1's comment block becomes false**: it argues *"the scope condition $s>a+\tfrac12$ already
delivers $\mu=s/(2a)>\tfrac12+\tfrac1{4a}$, with room"*; under the device $s=a+\tfrac12$ gives
$\mu'=\frac{a-1/2}{2a+2}<\tfrac12$ **for every $a$**, so the scope condition delivers nothing and
escalation item 15 re-opens. (f) `lem:levels`'s headline needs scoping to A2 (§3.4). (g) CFF's own
interpretive payoff — *"the first derivative has an important meaning in empirical analysis, as it
measures marginal effects"* — **is not available here**: the estimand is $\theta_\dagger$, and $\vdagger$
enters only through $\Delta\vdagger$, so a derivative parameterisation buys no reporting advantage at the
estimand.

**8.5 What is NOT touched by any of this** — recorded so it is not re-litigated in the next pass. A4
(Markov over an exponential net), A5 (`lem:intker`(iii) false as stated), A6 (the boundary-adjusted
kernel), A8 ((H1c)/(H2c) undeclared — the orchestrator's, per the dispatch), A9 ($n_{\rm m}\asymp n$),
A10 (the Sobolev embedding), A7 and A11 (the negative results). None is parameterisation-dependent.

---

## 9. Transfer question 6 — the cost, and how much of Part H survives

**If the device were adopted:**

| Object | Disposition |
|---|---|
| `lem:levels` | RETAINED, extended by two clauses (sieve; sample operator at a random base point), headline scoped |
| `def:spaces`, `prp:compact`, H1, A2, A1c | **RESTATED** — second domain exception; new singular system; H1's comment block rewritten (its central argument fails) |
| A8, `def:srcball`, (P-c), (P-d), `eq:lxwindow`, A5(vi′) | RESTATED in derivatives; `eq:lxwindow` recomputed |
| `def:lfstep`, `eq:normconst`, `eq:cap`, `lem:scaleinv` | **SURVIVE** — `lem:scaleinv` is generic in $\mathcal L$; $\omega_n$ absorbs one constant |
| (L1)–(L5), `eq:effnoise`, `eq:linlf`, `eq:linlftot`, `eq:fixedpoint`, Step 4(a.1)–(a.2), `eq:prelimrate`, `eq:muhalf` | **SURVIVE verbatim** in $(\kappa,\alpha,\beta_{\rm bw})$; only $\mu$'s *value* changes |
| Step 3's conclusion | one extra line: `lem:levels`(iv) to the level norm |
| `prp:orthog`, `lem:secondord`, `prp:sharpquad`, `lem:balance`, A3, N1 | **UNTOUCHED** (§6) |
| `prp:tccfails`, `prp:norangeinv`, `prp:hatAprop`, `rem:lfnonlinear` | UNTOUCHED — they concern $\hat T$, not the parameterisation |
| `rem:h6bandwidth`(5)'s frontier-clearing configuration $(2,3,\tfrac34,0.32)$ | **RETIRED** — $\mu'=0.571$ fails `eq:muhalf`; a new configuration at $s>3.917$ must be found and every budget line re-checked at it |
| New hypotheses required | 0 new *tags*, but (P-a), (P-c), (P-d), A8, A5(vi′), H1 all change content; `eq:lxwindow` is a changed budget line |

**So Part H largely survives and Parts A/C/E do not, and the paper's one admissible configuration is
retired.** Against that: **the spectral restatement of (P-a) is a one-paragraph edit to a hypothesis, plus
the $\mathsf R/\mathsf R_\ast$ split, plus an interpretive remark carrying H1 under a named proviso —
and it closes C1 and A3 outright.**

---

## 10. The choice the user actually faces

### Option A — commutativity / spectral-alignment proviso

Add to (P-a): $\hat{\mathcal A}^\ast_{\varphi_\circ}\hat{\mathcal A}_{\varphi_\circ}$ and the compressed
scale operator $B_n$ **commute on $\mathcal S_n$** (equivalently, share an eigenbasis). Then
$m^2B_n\preceq A_n\preceq M^2B_n$ gives $A_n^{-p}\preceq m^{-2p}B_n^{-p}$ for **all** $p>0$ by
simultaneous diagonalisation, and the interpolation step is licensed at $2\mu=4$.

- **The file owns the proof.** This is `lem:srctransfer`(ii.b)'s device — *"if $\mathcal A$ and
  $\hat{\mathcal A}$ share a singular system, transfer holds at every $\mu>0$"* — already proved, with
  constants.
- **H1's collapse is fully preserved.** $\mu=s/(2a)$ remains *derived*, the budget table is unchanged,
  `rem:h6bandwidth`(5)'s configuration stands, `eq:frontier` stands, the $s$-budget stands. **Nothing
  downstream moves.**
- **The price is the assumption's content.** It says a *random, rank-$\le n_{\rm m}$* operator built from
  $2n$ design points has its singular system aligned with a *spline-Sobolev* scale on $\mathcal S_n$.
  There is no sufficient condition for it, it is not diagnosable, and it is **stacked on top of (P-a)**,
  which Q-4 already flags as *"derived from nothing"*. It is exactly the species of over-strong,
  unverifiable proviso this project has rejected elsewhere.
- **And it adds a third constant to pin** (§8.3).

### Option B — state (P-a) spectrally *(RECOMMENDED)*

(P-a)'s third clause becomes: w.p.$\to1$ and at every stage,
$$P_{\mathcal S_n}\big(\vdagger-\hat\varphi^{(k-1)}\big)=\Big(P_{\mathcal S_n}\hat{\mathcal A}^\ast_{\hat\varphi^{(k-1)}}\hat{\mathcal A}_{\hat\varphi^{(k-1)}}\big|_{\mathcal S_n}\Big)^{\mu}\varsigma,\qquad\|\varsigma\|\le\mathsf R_\ast,$$
with the operator **named as the compression** (closing A3), and H1's $\mu=s/(2a)$ retained as an
**interpretive remark under an explicitly stated interpolation proviso**, in CFF's own structure.

- **The decisive argument: Option A = Option B + a proviso.** Under the commutativity proviso the pair
  (Hilbert-scale source + link) *implies* the spectral condition. So **Option B's hypothesis is strictly
  weaker than Option A's**, and Option B needs strictly less proved. Assuming the conclusion of a step
  whose only licence is an unverifiable alignment condition is the weaker assumption, not the stronger one.
- **(F-f) applies verbatim**, no interpolation, no Heinz range, no Löwner. (L5) becomes two lines.
- **The cost is narrower than "H1 collapses".** H1 is **not retired**: it still supplies A2's Picard form,
  `def:srcball`'s $H^s$ ball, (P-c)/(P-g)'s approximation rates and the whole budget table. What is lost
  is only the *derivation* of $\mu$ from $(s,a)$ **for (P-a)'s sample operator** — and §5.3 shows H1 never
  supplied that anyway: H1's matching is about $\mathcal A_{\mathrm{cond}}$ on $\mathcal V$, while (P-a)
  is about a finite-rank realised operator on $\mathcal S_n$ at a random base point, and (P-a) has been
  assuming its own matching all along. **Option B makes an existing assumption visible rather than
  adding one.**
- **Two consequential edits, both cheap.** (1) `prp:phirate`'s hypothesis line *"with $\mu=s/(2a)$"* is
  struck from the rate route and re-appears in an interpretive remark. (2) The $\mathsf R/\mathsf R_\ast$
  split of §8.3 — which is owed *regardless*, and which is the input A1 and A2 need.
- **What must be said in the open, and it is the honest cost.** With $\mu$ primitive at (P-a), a referee
  can ask what pins it. The answer the paper can give is the one CFF gives: it is pinned by H1 plus a
  matching proviso, stated and not proved. That is a weaker positioning claim than the current one, and
  it should be printed in `rem:phirscope`, not buried.

### Verdict

**Option B.** It is weaker in hypothesis, shorter in proof, closes C1 and A3 together as the checker's
sequencing note requires, produces the $\mathsf R/\mathsf R_\ast$ split A1/A2 need, and its one real cost
— $\mu$ becomes primitive at (P-a) — is a cost the block was already paying without saying so.
**Option A should be recorded in the same remark as the alternative, with its content stated plainly**, so
that a referee who prefers a derived $\mu$ can see exactly what buying it costs.

---

## 11. Dunker, relayed and weighed

**What CFF says.** Dunker (2021) *"is of more general scope than the one provided here and obtained under
high-level regularity conditions"*; its Newton method *"does not suffer from the saturation effect of LF
regularization, although its implementation is more cumbersome as it involves outer and inner iterations
of the regularization scheme"*; and it *"directly treats $\hat T'_\varphi$ and
$\hat T'^\ast_{\varphi_\dagger}$ as operators with the same range and does not consider the estimation
error that arises from the use of the regression residuals instead of the true error."*

**Weighed for this paper.**

1. **On saturation: Dunker buys nothing, for the same reason the derivative device buys nothing.** This
   paper's inner iteration is *linear* LF with the discrepancy principle, which does not saturate. There
   is no qualification barrier to remove.
2. **On $\mu>\tfrac56$: Dunker is the *only* one of the three candidates that could touch it.** The floor
   comes from (P-f), which exists because the outer loop linearises and the remainder
   $h_u^{-2}\varepsilon^2$ must be absorbed into the noise. An IRGN-type method regularises the *nonlinear*
   problem directly and would remove the outer linearisation loop, hence the stagewise schedule
   `eq:lfsched`, hence (P-f), hence `eq:muhalf`. **That is a materially better target than either
   remaining remedy — for a different finding.**
3. **But it does not close C1.** IRGN rate theorems are also stated at spectral source conditions on the
   linearisation, so the Hilbert-scale-to-spectral question recurs unchanged. Adopting IRGN would be a new
   Part H, not a repair to this one.
4. **And CFF names the reason it is the wrong tool for *this* paper specifically.** Dunker's treatment
   *"does not consider the estimation error that arises from the use of the regression residuals instead of
   the true error"* — which is exactly the $h_u^{-2}$/generated-regressor problem this paper's `eq:effnoise`
   and (P-f) exist to price. So the route that removes (P-f) is the route that does not model the object
   (P-f) is about. **That should be printed as the reason IRGN is declined, in place of
   `rem:lfnonlinear`(c)'s current "cheaper".**
5. **CITATION FINDING, cheap and worth fixing.** `rem:lfnonlinear`(c) attributes the IRGN /
   above-$\tfrac12$ claim to **`dunker2014`**. In CFF that claim belongs to **Dunker (2021)**; `dunker2014`
   is Dunker, Florens, Hohage, Johannes & Mammen (2014), which is the **operator-noise model** the paper
   adopts and which `rem:lfnonlinear`'s opening cites correctly. **One key is carrying two papers, and the
   one the paper prices as its alternative is the one that is missing from the bibliography under any
   key.** Both are needed: `dunker2014` (noise model, already cited at 2 sites) and a new
   `dunker2021` (IRGN, the alternative). Librarian's, and it belongs on the five-absent-keys list as a
   sixth item rather than a correction to an existing one.

**Verdict on Dunker:** not better *for C1*; the best available candidate *for `eq:muhalf`*; out of scope
here. Register as an open item alongside Q-6.

---

## 12. What IS worth taking from CFF

Four items, none of them the derivative reparameterisation.

1. **CFF's Assumption (18) is a replacement for the tangential cone condition, and this paper does not
   have one.** CFF's Prop. 4.1 secures local convergence from
   $\|(T'^{\ast}_{\varphi_\dagger}T'_{\varphi_\dagger})(T'^{\ast}_{\varphi_j}T'_{\varphi_j})^{-1}\|\le1/M_4$
   — a **relative-ill-posedness condition along the path** (*"the eigenvalues of
   $T'^{\ast}_{\varphi_j}T'_{\varphi_j}$ go to zero at a speed that is at most the one of the eigenvalues
   of $T'^{\ast}_{\varphi_\dagger}T'_{\varphi_\dagger}$"*) — **plus Prop. 4.2(a)'s quadratic remainder,
   which is exactly `prp:frechet`(i)/`prp:hatAprop`(iv) and which this paper already has.** CFF uses **no
   tangential cone condition anywhere.** `prp:tccfails` refutes A6; **it says nothing about (18).** On the
   sieve, where $\hat{\mathcal A}_\varphi$ has finite rank, an inverse-of-the-Gram condition of that shape
   is statable. **This is the most promising unexplored route in the file's neighbourhood and it deserves
   its own open item** — the honest caveat being that (18) is an assumption too, so it relocates the
   "assumed, not derived" complaint rather than removing it, and it would need
   $\lambda_{\min}(\mathbf G_n)$, which Q-3 records as open. Out of scope here; flagged.
2. **CFF puts its source condition at a *deterministic* object, once.** Assumption 4.3 is on
   $\varphi'_0-\varphi'_\dagger$, with $\varphi'_0$ the *probability limit* of the initial condition — not
   at a random, stage-dependent base point. That is why CFF has no analogue of **Q-4**. It is **not
   transferable as it stands**, because this paper's iterated-linearisation structure re-poses a linear
   problem at each $k$ and so needs the condition at each stage; CFF's single nonlinear iteration needs it
   once. But it is the right diagnosis of *why* CFF's assumption looks cheaper, it should be recorded
   beside Q-4, and it is a further argument for item 1: a single nonlinear iteration under (18) would
   restore the deterministic base point.
3. **`lem:levels` gets its consumer, and it is the levels choice itself.** Combine (iv) —
   $\|h\|_{L^2(\pi)}\le\|\mathcal D^{-1}_0\|\|h'\|_{L^2(\pi)}$, with the converse false — with §7.2's
   $\mu_{\rm der}=\frac{s-1}{2(a+1)}<\frac{s}{2a}=\mu_{\rm lev}$ and the $\tfrac83$ computation, and one
   gets a complete, quantitative, one-paragraph justification of conducting the analysis in levels:
   *the derivative parameterisation delivers a strictly weaker rate in the norm the programme needs, and
   buys a strictly smaller source index at the same smoothness, because $\mathcal D^{-1}$ raises the
   degree of ill-posedness from $a$ to $a+1$.* The proof of (iv) already gestures at exactly this —
   *"Nothing is lost by conducting the second-order analysis in levels, and something would be lost by
   conducting it in derivatives"* (`proofs.tex:872`) — but states it only for the norm, not for the source
   index, which is the half that matters and the half a referee will ask about. **Cost: one paragraph.
   `lem:levels` stops being consumer-free and `rem:lfnonlinear` acquires the answer to "why not
   derivatives?" before anyone asks.**
4. **The `dunker2014`/Dunker (2021) split** (§11.5).

---

## 13. Honest scope — what this assessment does not establish

- **I did not read CFF's supplementary material.** Whether Assumption 4.4 is consumed in the proofs of
  Props 4.1/4.2 and Thm 4.1, or only in §4's interpretive translation, is **not verified**. §2(c) rests on
  the *form* of Thm 4.1's rate (written in $\beta$, with no $s$ or $a$) plus Cor. 4.2's placement of
  $\beta=(s-1)/(a+1)$, which is evidence and not proof. **If 4.4 is consumed in the proofs, CFF's own
  route carries an unlicensed interpolation at $(s-1)/a>1$ — which would strengthen this assessment's
  conclusion, not weaken it.**
- **I did not verify the Engl–Hanke–Neubauer numbering** (Prop. 8.21 / Cor. 8.22, §8.5) against a copy.
  Per the block's rule I cite the section, which H1 already names, and not a theorem number.
- **I did not read Dunker (2021) or Dunker et al. (2014).** §11 relays CFF's characterisations of them and
  is labelled as relay throughout.
- **§7.2's degree-of-ill-posedness computation assumes matching in H1's sense** ($\|\mathcal A\zeta\|\asymp\|\zeta\|_{H^{-a}}$)
  and that $\mathcal D^{-1}$ raises Sobolev order by exactly one on $\mathcal X\subset\IR$. Both are
  standard on a compact interval and both are what H1 and `lem:levels` already assert; neither is proved
  here. The *conclusion* $\mu_{\rm der}<\mu_{\rm lev}$ is robust to the exact constants — it needs only
  that $\mathcal D^{-1}$ smooths (raises $a$) and differentiates (lowers $s$), and each strictly.
- **§12.1 is a conjecture about availability, not a result.** Whether CFF's (18) is statable and defensible
  on $\mathcal S_n$ here is not established, and it would need the $\lambda_{\min}(\mathbf G_n)$ bound
  Q-3 records as open.
- **This assessment scores nothing and edits nothing** in `results.tex`, `proofs.tex`, `assumptions.tex`
  or `notation_glossary.md`, per the dispatch.
