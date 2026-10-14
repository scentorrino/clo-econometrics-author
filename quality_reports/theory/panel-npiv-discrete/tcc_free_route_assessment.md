# CFF Assumption (18) as a Replacement for A6 / A6b / `prp:tccrepair` — Feasibility Assessment

**Project:** `panel-npiv-discrete` · **Agent:** theorist · **Date:** 2026-07-30
**Scope:** assessment only. **No edits to `results.tex`, `proofs.tex`, `assumptions.tex`,
`notation_glossary.md`** — a parallel fix round owns them. This file is the only artefact written.
**Question put:** can CFF (2025)'s Assumption (18) replace the A6 / A6b / `prp:tccrepair` apparatus?

---

## 0. Pre-Theory Report — what was read, and what was not

| Input | Read | Notes |
|---|---|---|
| CFF (2025), *J. Econometrics* 247, 105950 — **main text pp. 3–19** | in full | §2 (Notations, (4)–(11), Def. 2.1, $\mathcal B_R$, Prop. 2.1(i)–(iv), $\mathcal B_M$, Assns 2.1–2.3, Def. 2.2 / $\mathcal B^\ast_M$, Prop. 2.2, Examples 1–2), **§3 in full** ((12)–(17), notes (1)–(7)), **§4 in full** (Assns 4.1–4.7, **Prop. 4.1 + (18)**, Prop. 4.2(a)–(b), Thm 4.1, Cor. 4.2), §5, §6, §7, references |
| CFF **Supplementary Material §§A–D** | **NOT READ — NOT PRESENT** | The PDF at the given path is 19 pages, main text only; Appendix A says the supplement is online at the DOI. §B holds the proof of Prop. 4.1, §C of Prop. 4.2. **The prior assessment's declared gap is not closed.** §2 below reconstructs (18)'s role from the statement, CFF's own gloss, and the standard nonlinear-Landweber argument, and every reconstructed step is labelled as such. |
| `results.tex` | `prp:frechet`, `prp:compact`, `rem:nupi`, `def:hatTexp`/`eq:wbounds`/`eq:smdiff`/`eq:hatTx`, `def:hatAcon`/`eq:hatg`/`eq:hatnu`/`eq:hatAcon`/`eq:hatAadj`, **`prp:hatAprop`(i)–(v)**, **`prp:tccfails`**, **`rem:tccwhy`(1)–(3)** incl. `eq:a6sieve`, **`def:a6b`**, **`prp:tccrepair`(i)–(iii)**, `rem:tccverdict`, `prp:norangeinv`, `lem:opnoise` head, `lem:srctransfer`, `lem:scaleinv`, `def:lfstep`, **`prp:phirate`** ((P-a)–(P-g), `eq:muhalf`), `rem:lfnonlinear` | |
| `assumptions.tex` | `ass:tcc` block and its comment lines, A5(iii)/`eq:frontier`, budget table rows | grep-targeted, not linear |
| `theory_memo.md` | §§ carrying Q-1, Q-3, Q-4, Q-6, and the CFF dispatch note at L54–61 | grep-targeted |
| `derivative_route_assessment.md` (own, 2026-07-30) | in full | §12.1 is the claim under audit |
| Dunker (2021); Dunker et al. (2014) | **NOT READ** | §8 relays CFF's characterisations only, and is labelled relay |
| `.claude/references/domain-profile.md` | **NOT PRESENT** | declared gap, as before |
| The **in-flight fix round's** restatement of (P-a) | **NOT READ — does not exist yet** | §6 is written conditionally on it; the dependency is flagged, not assumed |

**Notation dictionary (CFF → this paper), because four letters collide.**
$\varphi_\dagger\to\vdagger$; $T'_\varphi\to\mathcal A_\varphi$; $\hat T'_\varphi$, $\hat A_\varphi\to\hat{\mathcal A}_\varphi$;
**$\beta\to2\mu$**; CFF's $\delta_n$ (equation noise) $\to\hat\delta_n$, *not* this paper's $\delta_n$ (which is the
*conclusion* `eq:phirate`); CFF's $\gamma_n$ (operator noise) $\to\gamma_n$ of `lem:aerr`, same role;
CFF's $\kappa_n=\inf f_U$ is **not** this paper's $\kappa=2\mu/(2\mu+1)$; CFF's $\epsilon$ (bias slack) is
**not** this paper's $\varepsilon_k$ (stage error); CFF's $N$ (iteration count, diverging) is this paper's
inner $m$, **not** its outer $\bar k$ (finite).

---

## 1. Recommendation, up front

**Keep A6b and `prp:tccrepair`. Do not adopt (18). Record it as a cited comparison in
`rem:tccverdict`, in two sentences, and correct my own §12.1 while doing so.**

Four findings, in decreasing order of force. Each is established below, not asserted.

1. **(18) is not the thing that does this job in CFF, and my §12.1 was wrong to say CFF "uses no
   tangential cone condition anywhere."** CFF's Prop. 2.1(iii)–(iv) pair a quadratic remainder
   $\|T(\varphi)-T(\varphi_\dagger)-T'_{\varphi_\dagger}(\varphi-\varphi_\dagger)\|\le M\|\varphi-\varphi_\dagger\|^2$
   with the set $\mathcal B_M=\{\varphi:\|T'_{\varphi_\dagger}(\varphi-\varphi_\dagger)\|>M\|\varphi-\varphi_\dagger\|^2\}$
   **at the same constant $M$**, and derive local identification from the difference. That inequality
   *is* a cone-type condition — it is `eq:a6b` at $\eta/(1+\eta)=1$ — and Def. 2.2's ellipsoid
   $\mathcal B^\ast_M\subseteq\mathcal B_M$ is a *sufficient condition with an explicit set*, which is
   `prp:tccrepair`(ii) one level up. **CFF's architecture contains A6b and `prp:tccrepair`; (18) is an
   additional condition on top of them.** §3.1.
2. **(18) belongs to an architecture that cannot reach this paper's frontier.** CFF never requires any
   sample object to be the exact derivative of another sample object: $\hat T$ estimates $T$ (Assn 4.6,
   line 1) and $\hat A^\ast$ estimates $A^\ast$ **in operator norm** (Assn 4.6, line 2). That is the
   *perturbation-of-$\mathcal A$* route, which `prp:phirate` Step 0 explicitly does **not** take — (P-b)
   is struck for exactly that reason. And the route is capped at $\mu\le\tfrac12$: CFF's own ceiling
   $\beta\le1-\epsilon$ is $\mu<\tfrac12$, which is `lem:srctransfer`(ii.a)'s Heinz barrier and
   `rem:lfnonlinear`(3)'s ceiling, at the same number. **`eq:frontier` needs $\mu>\tfrac12$. Importing
   (18) without the architecture leaves it with no consumer; importing the architecture kills the
   frontier.** §3.3, §5.3.
3. **On the Q-3 axis (18) is strictly more expensive than A6b, not less.** (18) contains
   $(\hat{\mathcal A}^\ast_\varphi\hat{\mathcal A}_\varphi)^{-1}$, which on $\mathcal S_n$ is
   $n_{\mathrm m}^{-2}(D^\ast\mathbf G_n(\varphi)D)^{-1}$ with $D:v\mapsto(\Delta_{h_x}v_i)_i$. (18) needs
   a **ratio** bound uniform over base points — $\lambda_{\min}(\mathbf G_n(\varphi))$ *and*
   $\lambda_{\min}(D^\ast D)$ on the sieve, a new object. `prp:tccrepair`(ii) needs only
   $\underline\lambda_n>0$, qualitatively, and lets the radius shrink with it. **(18) makes Q-3 a theory
   obligation in a stronger form and adds a second conditioning object.** §5.1–5.2.
4. **`prp:tccfails` survives, and must.** Its content is not "A6 is strong" but "$\hat T$ is nowhere
   Fréchet differentiable on $\mathcal V\subset L^2(\pi)$" — `prp:hatAprop`(v) — which is what *forces*
   `def:hatTexp`'s $x$-smoothing and hence (P-g). (18) says nothing about it, resolves nothing about
   `eq:a6sieve`, and — this is the finding that closes the question — **CFF's own Assumption 4.5 is the
   analogue of what `prp:hatAprop`(v) refutes.** CFF can assume it only because its parameter space is
   $\mathcal E'$ in derivatives, where point evaluation is bounded. §4.2, §7.

**What the dispatch hoped for is real but small and conditional, and it is not about A6b.** (18)'s one
genuine use here is as a **base-point-transfer device for (P-a)** — the answer to Q-4 — and it works only
if the fix round restates (P-a) spectrally, and only up to $\mu\le1$. §6 prices it: the ceiling retires
the block's frontier-clearing configuration $(\mu,s,a,\alpha)=(2,3,\tfrac34,0.32)$ and moves
`eq:frontier` from $r>2.5$ to $r>4.5$ at $d_Z=3$. **Register it as an open item beside Q-4; do not adopt
it.**

---

## 2. What (18) says, and what it does

### 2.1 The statement, verbatim and then in this paper's letters

CFF Prop. 4.1: let Assns 4.1 ($\varphi_\dagger\in\mathcal E'$, locally identified on $\mathcal B_\dagger$)
and 4.2 ($\varphi_0\in\mathcal B_\dagger$, where $\varphi_0$ is the **probability limit** of
$\hat\varphi_0$) hold, and
$$\big\|\big(T'^{\ast}_{\varphi_\dagger}T'_{\varphi_\dagger}\big)\big(T'^{\ast}_{\varphi_j}T'_{\varphi_j}\big)^{-1}\big\|\;\le\;\frac1{M_4},
\qquad M_4\le1,\ \text{uniformly on }\mathcal B_{\varphi_\dagger},\ \text{for all }j=0,1,2,\dots \tag{18}$$
Then $\varphi_j\in\mathcal B_\dagger$ for all $j$, and the LF algorithm (12) converges to $\varphi_\dagger$.

In this paper's letters, with $\mathcal Q_\varphi:=\mathcal A^\ast_\varphi\mathcal A_\varphi$:
$$\|\mathcal Q_{\vdagger}\,\mathcal Q_\varphi^{-1}\|\;\le\;1/M_4\qquad\text{for all }\varphi\text{ in a ball around }\vdagger. \tag{18$'$}$$

**Three readings settled.**

- **It is a ball condition, not a path condition.** The phrase "uniformly on $\mathcal B_{\varphi_\dagger}$"
  quantifies over the *set*, not the realised sequence; that is also what an induction on
  $\varphi_j\in\mathcal B_\dagger$ requires. So (18) is *local* in the same sense `def:a6b`'s
  $\mathcal V(\varphi_\circ,\rho)$ is local, and the same sense `prp:tccrepair`(ii)'s
  $\inf_{\varphi\in\mathcal V(\varphi_\circ,\rho_0)}$ is. **Not a weaker quantifier than A6b's.**
- **It is high-level, with no sufficient condition.** CFF gives only an interpretation — "the eigenvalues
  of $T'^\ast_{\varphi_j}T'_{\varphi_j}$ go to zero at a speed that is at most the one of the eigenvalues
  of $T'^\ast_{\varphi_\dagger}T'_{\varphi_\dagger}$ … we essentially require that the degree of
  ill-posedness is no larger than the true one at each step." Assn 2.3 supplies an *upper* bound
  $\|T'^\ast_\varphi T'_\varphi\|\le M_1^2$, never a relative lower bound. **Nothing in CFF derives (18),
  and nothing in this file would either.** §5.4 shows why `prp:frechet`(ii)'s Lipschitz derivative map
  cannot supply it.
- **It is a Löwner statement at the square, and that matters for exponents.** For positive self-adjoint
  $\mathcal Q_\dagger,\mathcal Q_\varphi$, $\|\mathcal Q_\dagger\mathcal Q_\varphi^{-1}\|\le c$ gives
  $\|\mathcal Q_\dagger f\|\le c\|\mathcal Q_\varphi f\|$ on a common core, i.e.
  $\mathcal Q_\dagger^2\preceq c^2\mathcal Q_\varphi^2$. Löwner–Heinz at exponent $r\in[0,1]$ then gives
  $$\mathcal Q_\dagger^{\,p}\;\preceq\;c^{\,p}\,\mathcal Q_\varphi^{\,p}\qquad\text{for all }p\in[0,2], \tag{2.1}$$
  and **only** for $p\in[0,2]$ — the counterexample of `lem:srctransfer`(ii.a) applies to
  $\mathcal Q^2_\dagger\preceq c^2\mathcal Q^2_\varphi$ raised beyond the first power exactly as it
  applies to the unsquared pair. So (18) is worth **twice** the exponent budget of
  `lem:srctransfer`(i), because it is stated at the square rather than at the first power. §6 is where
  that pays, and $p=2\mu\le2$ is the ceiling $\mu\le1$.

### 2.2 What (18) does in Prop. 4.1 — reconstructed, because §B is unread

**Labelled reconstruction, not verification.** For nonlinear Landweber
$\varphi_{j+1}=\varphi_j-cA^\ast_{\varphi_j}T(\varphi_j)$ with $e_j:=\varphi_j-\varphi_\dagger$,
$$\|e_{j+1}\|^2=\|e_j\|^2-2c\big\langle T(\varphi_j),\,A_{\varphi_j}e_j\big\rangle+c^2\|A^\ast_{\varphi_j}T(\varphi_j)\|^2 .$$
The middle term is handled by writing $A_{\varphi_j}e_j=T(\varphi_j)-T(\varphi_\dagger)-r_j$ and bounding
$\|r_j\|\le M\|e_j\|^2$ (Prop. 2.1(iii)); the last by Assn 2.3's $\|A_\varphi\|\le M_1M_2$. Monotone
decrease then needs
$$\|A_{\varphi_j}e_j\|\;>\;M\|e_j\|^2 . \tag{2.2}$$
Ball membership $\varphi_j\in\mathcal B_M$ delivers (2.2) **at the truth's derivative**,
$\|T'_{\varphi_\dagger}e_j\|>M\|e_j\|^2$. It is (18) — via (2.1) at $p=1$, giving
$\|\mathcal A_{\vdagger}f\|\le M_4^{-1/2}\|\mathcal A_\varphi f\|$ — that converts it to the *current
iterate's* derivative, which is the operator the step actually uses.

**So (18)'s job, stated exactly: it is a base-point-transfer device for the injectivity modulus. It
transfers a curvature condition assumed at the truth to every point of the ball.** It does not create
the curvature condition; $\mathcal B_M$ does. That is finding 1.

### 2.3 (18) has exactly one consumer in CFF, and no theorem consumes it

Theorem 4.1's hypothesis list is "Assumptions 4.1–4.7, and A.1–C.1". **(18) is not in it, and neither is
Prop. 4.1.** Prop. 4.2 requires "4.1–4.5 and A.1–A.6" — also not (18). Corollary 4.2 is a balancing
computation off Thm 4.1.

**So in CFF, (18)'s only consumer is Prop. 4.1, and Prop. 4.1 is consumed by nothing.** That is,
term for term, A6b's status here: *"it has exactly one consumer (`prp:tccrepair`), it is never asserted,
and no theorem in this programme uses it"* (`def:a6b`). The dispatch's framing — replacing a
non-load-bearing pair with a load-bearing alternative — has the polarity backwards: **(18) is
non-load-bearing in its own source paper.** Swapping A6b for it swaps one unconsumed local condition for
another, and loses the one that has a proved sufficient condition.

*Caveat, and it is the unread-supplement caveat.* It is possible that §C/§D's proof of Thm 4.1 silently
uses $\varphi_j\in\mathcal B_\dagger$, i.e. Prop. 4.1's conclusion, without listing it. The *statement*
is evidence, not proof. If it does, CFF's Thm 4.1 carries an unlisted hypothesis — which strengthens
this assessment's conclusion rather than weakening it.

---

## 3. Does it transfer?

### 3.1 The cone-type condition CFF does have

Prop. 2.1(iii) and (iv), read together on $\mathcal B_\dagger=\mathcal B_R\cap\mathcal B_M$:
$$\underbrace{\|T(\varphi)-T(\varphi_\dagger)-T'_{\varphi_\dagger}(\varphi-\varphi_\dagger)\|}_{\text{remainder}}
\;\le\;M\|\varphi-\varphi_\dagger\|^2\;<\;\underbrace{\|T'_{\varphi_\dagger}(\varphi-\varphi_\dagger)\|}_{\text{linear term}} .$$
Compare `eq:a6b`: remainder $\le\frac{\eta}{1+\eta}\|\hat{\mathcal A}_{\tilde\varphi}(\varphi-\tilde\varphi)\|$.
**Same shape; CFF's constant is $1$ where A6b's is $\eta/(1+\eta)<\tfrac13$.** CFF needs only the weak
version because it uses it for *identification* (Prop. 2.2: $\|T(\varphi)\|>0$), not for iteration
control — the iteration control is (18)'s job. And Def. 2.2's ellipsoid
$\mathcal B^\ast_M=\{\varphi_\dagger+\sum b_j\chi_j:\sum b_j^2/t_j^2<M^{-2}\}$ is offered *precisely* as a
verifiable sufficient condition for membership in $\mathcal B_M$ — "Definition 2.2 imposes that the set of
functions in the ellipsoid $\mathcal B^\ast_M$ around $\varphi_\dagger$ be sufficiently smooth to
guarantee that its Fourier coefficients go to zero faster than the eigenvalues of $T'_{\varphi_\dagger}$,
so that this condition is sufficient to satisfy the requirement of Proposition 2.1(iv)."

**That is `def:a6b` + `prp:tccrepair`(ii), transposed from the sample to the population.** So the
apparatus the dispatch proposes to remove is the apparatus CFF has; what CFF adds is (18).

*One asymmetry in this paper's favour.* CFF's version is at the **population** pair
$(T,T'_{\varphi_\dagger})$, where `prp:frechet`(i) already gives the remainder unconditionally and
`prp:compact` gives compactness. This paper's A6b is at the **sample** pair
$(\hat T_{h_x},\hat{\mathcal A})$, which is harder and is where `prp:tccrepair` earns its keep. If the
paper wanted the *cheap* half of CFF's structure it already has it: `prp:frechet`(i) + a
$\mathcal B_M$-style set would give a population local-identification statement at essentially no cost.
**That is a separable, positive suggestion and it is banked in §10.**

### 3.2 Which operator would (18) be stated for — and it cannot be $\hat T$

(18) mentions no $T$; it is a statement about the derivative family alone. So the question is which
family.

- **$\mathrm d\hat T_\varphi[\cdot]$ of `eq:gateaux` — unavailable.** By `prp:hatAprop`(v) this map is
  unbounded on $\mathcal V$, so $\mathrm d\hat T^\ast_\varphi\mathrm d\hat T_\varphi$ is not a bounded
  operator, and $\|\mathcal Q_\dagger\mathcal Q_\varphi^{-1}\|$ is not a statement about bounded
  operators at all. **(18) is not statable for $\hat T$.**
- **$\hat{\mathcal A}_\varphi$ of `eq:hatAcon` — statable, and it is the derivative of $\hat T_{h_x}$,
  not of $\hat T$.** So (18) inherits exactly the concession A6b already makes: it is a condition on the
  $x$-smoothed problem. §5.1 computes it.
- **$\mathcal A_\varphi$ of `eq:Adef` — statable, and clean.** A *population* (18′) says nothing about
  any sample object and so cannot meet the asymmetry.

**Answer to the dispatch's question.** (18) does not *escape* the asymmetry; it **cannot see** it,
because it never refers to $\hat T$. And the asymmetry re-enters immediately, twice. First, the
convergence argument that consumes (18) also consumes a remainder bound (2.2) relating the *equation* to
its *linearisation* — and in the sample that bound is `prp:hatAprop`(iv), about $\hat T_{h_x}$. So the
pairing `prp:tccfails` attacks is present in Prop. 4.1's argument as well; (18) sits beside it, not in
place of it. Second, an iteration licensed for $\hat T_{h_x}$ solves $\hat T_{h_x}=0$, and the distance
from there to $\hat T=0$ is (P-g)'s $x$-smoothing bias $\mathsf Rh_x^{s-1/2}=O(\hat\delta_n)$. **The
asymmetry is not escaped; it is relocated out of the display and into the budget line.**

### 3.3 The architecture finding — the reason (18) has no consumer here

CFF never asks a sample object to be the derivative of another sample object. Its two sample inputs are
Assn 4.6:
$$E\|\hat T(\varphi_\dagger)-T(\varphi_\dagger)\|^2=O(\delta_n^2),
\qquad
E\|\hat A^\ast_{\varphi_\dagger}-A^\ast_{\varphi_\dagger}\|^2=O(\gamma_n^2)\ \ \textbf{in operator norm} .$$
$\hat A^\ast$ at (17) is $x$-smoothed at $h_x$ while $\hat T$ at (16) is not — **CFF has the same
asymmetry this paper has** — and CFF simply never links them: $\hat A^\ast$ is a *consistent estimator
of the population adjoint*, full stop, and Prop. 4.2(b)'s operator $K_{\varphi_\dagger,\hat\varphi_j}$
with $\|K-I\|\le Mh_u^{-2}\kappa_n^{-1}\|\hat\varphi_j-\varphi_\dagger\|$ handles base-point movement by
a density-replacement argument rather than by differentiation.

**That is the perturbation-of-$\mathcal A$ route.** It needs the source condition to transfer from
$\mathcal A$ to $\hat{\mathcal A}$ under a norm perturbation $\gamma_n$ — which is
`lem:srctransfer`(i)–(ii) exactly, and is available only for $\mu\le\tfrac12$ by Heinz. **And CFF's own
ceiling sits there:** $\beta\le1-\epsilon$ is $\mu<\tfrac12$, and CFF attributes the $\beta\le1$ half to
LF saturation in nonlinear problems, citing the same literature `rem:lfnonlinear`(3) cites. `prp:phirate`
strikes (P-b) precisely to avoid that route — *"it belonged to the perturbation-of-$\mathcal A$ route,
which Step 0 of the proof does not take"* — and states (P-a) on $\hat{\mathcal A}$ directly, which is
what buys $\mu>\tfrac12$, which `eq:frontier` requires.

**So the two architectures are not interchangeable, and (18) is a component of the one this paper
cannot use.** Importing (18) alone gives it nothing to do; importing the architecture that consumes it
caps $\mu<\tfrac12$ and makes `eq:frontier` unsatisfiable at every $r$ (A5(iii)).

---

## 4. Is `prp:hatAprop`(iv) the counterpart of Prop. 4.2(a)? — checked, not asserted

| | CFF Prop. 4.2(a) | `prp:hatAprop`(iv) / `eq:hatTxrem` |
|---|---|---|
| Operator | $\hat T$ — $u$-smoothed at $h_u$, **not** $x$-smoothed | $\hat T_{h_x}$ — $u$- **and** $x$-smoothed |
| Base point | $\varphi_\dagger$ **only** | **every** $\varphi\in\mathcal V$ |
| Direction | the realised iterate $\hat\varphi_j-\varphi_\dagger$ | **every** $v$ with $\varphi+v\in\mathcal V$ |
| Differentiability | **assumed** (Assn 4.5) | **proved** (twice Fréchet differentiable) |
| Constant | "there exists $\hat M<\infty$", a.s.; **no bandwidth shown** | explicit $\mathsf c_4c_\Pi/(2h_u^2)$ |
| RHS norm | $\|\hat\varphi_j-\varphi_\dagger\|^2_{L^2_X}$ | $\|\Delta_{h_x}v\|_2^2/n_{\mathrm m}$ — a design seminorm |

**Verdict: yes in substance, with three differences, two of which favour this paper and one of which is
a live dependency.**

**(a) `prp:hatAprop`(iv) is stronger where it matters, and unconditional.** Uniform over base points and
directions, versus at the truth and along the realised sequence; and differentiability *proved* where
CFF *assumes* it. A6b's quantifier "over all pairs in the ball" — which `prp:tccrepair`(ii)'s infimum
pays for — is available here precisely because (iv) is uniform. CFF's Prop. 4.2(a) would not support
`def:a6b`'s quantifier.

**(b) CFF's "$\hat M<\infty$" hides the factor that generates `eq:muhalf`.** $\hat T$ at (16) enters
$\varphi$ through $\bar C_{h_u}(u-\hat U_{ji})$, whose second derivative in the argument is $O(h_u^{-2})$;
Prop. 4.2(b)'s own bound carries $h_u^{-2}\kappa_n^{-1}$ explicitly, which is evidence the mechanism is
present in (a) too. **This paper displays what CFF suppresses**, and the displayed factor is exactly
what (P-f) domination is about and hence what forces $\mu>\tfrac56$. *Adopting CFF's (a) as written
would suppress (P-f) rather than satisfy it.* (Whether §C's proof of (a) carries $h_u^{-2}$ is not
verified — supplement unread.)

**(c) The RHS norms differ, and this is a dependency on the fix round, not a finding.** `eq:hatTxrem`'s
right side is $\|\Delta_{h_x}v\|_2^2/n_{\mathrm m}$. The worst-case conversion over $\mathcal V$ is
$|\Delta_{h_x}v_i|\le\mathsf c h_x^{-1/2}\|v\|_{L^2(\pi)}$ (Cauchy–Schwarz against
$\|h_x^{-1}C_{h_x}(\cdot,s_0)\|_{L^2(dx)}\asymp h_x^{-1/2}$), giving
$\|\Delta_{h_x}v\|_2^2/n_{\mathrm m}\le\mathsf c^2h_x^{-1}\|v\|^2$; on $\mathcal S_n$ a sharper,
$h_x$-free conversion is plausible, since $\Delta_{h_x}v\approx\Delta v$ for $v$ smooth at scale
$L_x^{-1}$. **(P-f) as printed — $\delta_n^2=O(h_u^2\hat\delta_n\ln n)$ — is the $h_x$-free reading.**
I flag rather than pursue: the sweeps' Part-H repairs own this, and if the sharper conversion is not in
`proofs.tex` then (P-f) carries an unbooked $h_x$. **Not a (18) question; noted because §4 is where it
becomes visible.**

---

## 5. What it costs

### 5.1 (18) on the sieve, computed

On $\mathcal S_n$, `eq:hatAcon` factors as $\hat{\mathcal A}_\varphi|_{\mathcal S_n}=n_{\mathrm m}^{-1}GD$
with $D:\mathcal S_n\to\IR^{n_{\mathrm m}}$, $v\mapsto(\Delta_{h_x}v_i)_i$, and
$G:\IR^{n_{\mathrm m}}\to L^2(\Pi)$, $c\mapsto\sum_ic_i\hat g_{\cdot,\cdot,i}(\varphi,\theta)$. Hence
$$\mathcal Q_\varphi\big|_{\mathcal S_n}\;=\;n_{\mathrm m}^{-2}\,D^\ast\,\mathbf G_n(\varphi)\,D ,$$
with $\mathbf G_n$ exactly `eq:gram`. **The design map $D$ is the same at every base point** — the base
point enters only through $\mathbf G_n$, which is `def:hatAcon`'s point that the residual translation
lives inside $\hat g_i$. Therefore
$$\big\|\mathcal Q_{\vdagger}\mathcal Q_\varphi^{-1}\big\|
\;\le\;\frac{\lambda_{\max}\big(\mathbf G_n(\vdagger)\big)}{\lambda_{\min}\big(\mathbf G_n(\varphi)\big)}
\cdot\frac{\|D\|^2}{\lambda_{\min}(D^\ast D)} \tag{5.1}$$
whenever $D$ is injective on $\mathcal S_n$ (needs $L_x\le n_{\mathrm m}$, satisfied under A8's
$L_x\ll n^{1/2}$, but injectivity itself is the `prp:norangeinv`(ii) proviso and is *not* established at
design points inside the boundary layer).

**So (18) on the sieve requires three things, of which one is Q-3 and one is new:**

1. $\lambda_{\min}(\mathbf G_n(\varphi))$ bounded below **relative to** $\lambda_{\max}(\mathbf G_n(\vdagger))$,
   **uniformly over base points**. This is Q-3, in a *ratio* form.
2. $\mathrm{cond}(D)^2=\|D\|^2/\lambda_{\min}(D^\ast D)$ bounded on $\mathcal S_n$ — **a new object**, the
   conditioning of the smoothed-difference design map on the spline sieve. Plausibly $O(1)$ for a
   quasi-uniform mesh with $L_x\ll n^{1/2}$, established nowhere in the file.
3. $\lambda_{\max}(\mathbf G_n(\vdagger))$ finite, which **is** available — `prp:hatAprop`(i).

### 5.2 Priced against `prp:tccrepair`

| | `prp:tccrepair`(ii) | (18) on the sieve |
|---|---|---|
| What it needs | $\underline\lambda_n=\inf_\varphi\lambda_{\min}(\mathbf G_n(\varphi))>0$ — **qualitative** | ratio (5.1) **bounded**, uniformly — **quantitative** |
| If the need degrades | radius `eq:tccrad` shrinks; the conclusion survives with a smaller ball | **(18) fails outright**; there is no graceful degradation |
| Status | a *property* (A1d/A2c model), with a **proved** sufficient condition and explicit radius | a **maintained assumption**, high-level, no sufficient condition anywhere |
| Extra objects | none | $\mathrm{cond}(D)$ on $\mathcal S_n$, and injectivity of $D$ (the `prp:norangeinv`(ii) proviso promoted to a hypothesis) |
| Q-3's status | *"a simulation question, not a theory obligation"* | **a theory obligation, in ratio form** |

One point in (18)'s favour, stated and then dispatched: (18) is scale-free — it needs no *absolute* lower
bound on $\lambda_{\min}$, only a relative one, and both $\lambda$'s degrade together with $h_u,h_x$. But
`prp:tccrepair` needs no absolute lower bound either (it is qualitative, and `eq:tccrad` carries the
size). **So the advantage evaporates on comparison, and what is left is that (18) needs a uniformity
`prp:tccrepair` does not.**

### 5.3 The exponent ceiling, and the frontier arithmetic

By (2.1), (18) supports $\mathcal Q_\dagger^{\,p}\preceq c^p\mathcal Q_\varphi^{\,p}$ only for $p\le2$.
Range transfer of a source condition at index $\mu$ needs $p=2\mu$ (Douglas: $\mathcal R(\mathcal Q^\mu_\dagger)\subseteq\mathcal R(\mathcal Q^\mu_\varphi)$
iff $\mathcal Q^{2\mu}_\dagger\preceq\lambda\mathcal Q^{2\mu}_\varphi$). Hence
$$\boxed{\;(18)\ \text{delivers base-point transfer for }\mu\le1,\ \text{and for no larger }\mu.\;}$$
Against `eq:muhalf`'s $\mu>\tfrac56$ the admissible window is $\mu\in(\tfrac56,1]$, i.e.
$s\in(\tfrac53a,\,2a]$ — **non-empty, but it retires $(\mu,s,a)=(2,3,\tfrac34)$.** With
`eq:frontier` $\frac{2\mu}{2\mu+1}\cdot\frac{r}{2r+d_Z}>\frac14$:

| $\mu$ | $\kappa$ | required $\alpha$ | `eq:frontier` at $d_Z=3$ | `eq:lxwindow` |
|---|---|---|---|---|
| $2$ (block's configuration) | $0.800$ | $>5/16=0.3125$ | $r>2.5$ | $s>1.6875$ at $\alpha=\tfrac38$ |
| $1$ (**(18)'s ceiling**) | $0.667$ | $>3/8=0.375$ | $r>4.5$ | $s>1.6875$, and $s=2a$ forces $a>0.84$ |
| $\tfrac56^+$ | $0.625$ | $>2/5=0.400$ | $r>6$ | $s>1.78$ at $\alpha=0.38$ |

At $\mu=1$ a configuration exists — $(\mu,s,a)\approx(1,1.7,0.85)$, $\alpha$ just above $\tfrac38$,
$r$ just above $4.5$ at $d_Z=3$, clearing `eq:lxwindow` and H1's scope $s>a+\tfrac12$ — but it is tight
and every budget line must be re-checked at it. **The propensity smoothness requirement nearly doubles.**

*Note the coincidence and do not over-read it.* $\mu\le1$ is $\beta\le2$, whereas CFF's own rate ceiling
is $\beta\le1-\epsilon$. The two are different ceilings from different mechanisms — (2.1)'s Löwner–Heinz
range versus LF saturation plus residual-density bias — and it is only the *first* that (18) itself
imposes. CFF's is the tighter, and it is the one §3.3 says this paper cannot live with.

### 5.4 Why (18) cannot be derived here (or there)

`prp:frechet`(ii) gives $\|\mathcal A_{\varphi+h}-\mathcal A_\varphi\|\le2C_{\mathcal A}\|h\|_{L^2(\pi)}$
— a *norm* perturbation. That is useless for (18): $\mathcal A_{\mathrm{cond}}$ is compact with
$\sigma_j\downarrow0$ (`prp:compact`), so at every index with $\sigma_j\ll\|h\|$ the perturbation
dominates the operator and no relative Löwner lower bound follows. **This is the same obstruction
`lem:srctransfer`(ii.b) names — "the perturbation may rotate the singular system, not that it is
large" — read one level up.** So (18) is not derivable from the file's Lipschitz derivative map, at
either the population or the sample level, and CFF supplies no derivation either. **(18) is an
assumption of exactly the species (P-a) is**, which is the species this project has been declining.

And it is a *strong* one. At $\varphi=\vdagger$ the left side of (18′) is $\|I\|=1$, which is why
$M_4\le1$; so (18) says **no point of the ball is more than $M_4^{-1}$ times as ill-posed as the truth,
in the Löwner sense at every index including the tail.** For the family `eq:Adef`, where the base point
enters as an argument shift of $f_{\Delta Y_\theta-\Delta\varphi\mid\cdots}$, there is no reason the
tails align across the ball. CFF's own gloss concedes as much.

---

## 6. What it buys — the honest answer, and it is conditional

**Nothing on the A6b axis.** A6b and `prp:tccrepair` have one consumer between them and no theorem
consumes either; (18) would have zero consumers and no proved sufficient condition. Replacing a
non-load-bearing pair with a non-load-bearing singleton is not an exposition gain. `prp:phirate` does not
shorten by one line: it uses neither A6 nor A6b today, and would use neither under (18).

**One thing, on a different axis: (18) is the only proposed route to answering Q-4.** (P-a) currently
imposes source + link **at every stage, for the realised operator at a random base point**, derived from
nothing. (18) would replace that by: source condition **once**, at a deterministic base point, plus
(18) to carry it along the path. That is precisely the structural difference §12.2 of my prior
assessment diagnosed ("CFF puts its source condition at a *deterministic* object, once … which is why
CFF has no analogue of Q-4"), and (2.1) is the mechanism I could not then name.

**Two conditions on that, and the first is a dependency on the in-flight fix round.**

- **(18) attaches to (P-a) only if (P-a) is spectral.** (18) is a spectral domination statement.
  (P-a) as printed is a *Hilbert-scale* source condition plus a *link* condition on $\mathcal S_n$.
  There is no route from a spectral domination to a Hilbert-scale statement that does not run through
  operator interpolation — which is finding C1, the thing the spectral restatement exists to remove.
  **So if the fix round restates (P-a) spectrally on the compression
  $P_{\mathcal S_n}\hat{\mathcal A}^\ast_{\hat\varphi^{(k-1)}}\hat{\mathcal A}_{\hat\varphi^{(k-1)}}|_{\mathcal S_n}$
  (my §10 Option B), (18) acquires a clean point of attachment: (18) on the compression + (2.1) at
  $p=2\mu$ gives the stage-$k$ condition from the stage-$0$ one, with radius inflating by $M_4^{-\mu}$.
  If (P-a) is left in Hilbert-scale form, (18) has no point of attachment at all.** I flag the dependency
  and do not assume either version.
- **The price is §5.1's Q-3 plus §5.3's ceiling.** So the Q-4 answer costs: a theory obligation on
  $\lambda_{\min}(\mathbf G_n)$ in ratio form, a new conditioning object $\mathrm{cond}(D)$, promotion of
  `prp:norangeinv`(ii)'s injectivity proviso to a hypothesis, retirement of the frontier-clearing
  configuration, and `eq:frontier` from $r>2.5$ to $r>4.5$ at $d_Z=3$.

**Verdict on the trade.** Q-4's complaint is that (P-a) is assumed at a random base point with no
sufficient condition. (18) does not remove an assumption; it *relocates* the base-point dependence from
(P-a)'s quantifier into (18)'s quantifier, and charges Q-3 and a $\mu$-ceiling for the relocation. **A
referee who objects to (P-a) will object to (18) for the same reason.** Register beside Q-4, with the
$\mu\le1$ arithmetic, so the answer to "why is (P-a) at a random base point?" is *"because the
alternative caps $\mu$ at $1$, retires our configuration, and makes $\lambda_{\min}(\mathbf G_n)$ a
theory obligation"* — which is a good answer, and better than silence.

---

## 7. Does `prp:tccfails` survive? Yes, and it should be strengthened, not weakened

**It survives, for four reasons, and (18) touches none of them.**

1. **It answers a question the literature forces.** The registered route is nonlinear LF under a TCC
   (`rem:lfnonlinear`); Hanke–Neubauer–Scherzer, Engl et al. Ch. 11 and Kaltenbacher et al. all run on
   it. A paper that declines that route owes the reason. `prp:tccfails` is reason (1) of three, and
   `rem:lfnonlinear` already ranks it third — correctly, since (3) is regime-independent. **A negative
   result that is not the lead reason is still the reason a specific referee will ask about.**
2. **"A condition nobody assumes" is false.** §3.1: CFF assumes a cone-type inequality — Prop. 2.1(iii)
   against $\mathcal B_M$, with Def. 2.2 as the sufficient condition. The condition is alive in the
   nearest neighbour paper, in the same estimator class, published in 2025.
3. **Its real content is `prp:hatAprop`(v), which is load-bearing.** $\hat T$ nowhere Fréchet
   differentiable on $\mathcal V\subset L^2(\pi)$ is what *forces* `def:hatTexp`'s $x$-smoothing, hence
   $\hat T_{h_x}$, hence (P-g)'s upper bound on $h_x$ — *"an upper bound on $h_x$, which C5$'$ does not
   carry."* Retire `prp:tccfails` and the $x$-smoothing becomes an unmotivated modelling choice and
   (P-g) an unmotivated budget line. **`prp:tccfails` is the justification for a maintained condition
   that the rate route does consume.**
4. **And the finding that closes it: CFF's Assumption 4.5 is the analogue of what `prp:hatAprop`(v)
   refutes.** Assn 4.5 reads *"$\hat T$ is Fréchet differentiable for all $\varphi\in\mathcal E'$"* —
   assumed, not proved. CFF's $\hat T$ at (16) sees $\varphi$ through $\hat U_{ji}=Y_i-\varphi(X_i)-\bar{(\cdot)}$,
   i.e. through **point evaluations**, exactly as this paper's `eq:hatT` does. On $L^2_X$ that map is not
   Fréchet differentiable, by `prp:hatAprop`(v)'s own argument. **CFF can assume 4.5 only because its
   parameter space is $\mathcal E'$ — one-time differentiable functions, with the iteration run on
   $\varphi'\in L^2_X$ — where $|\varphi(x)|=|\int_0^{x_1}\varphi'|\le|\mathcal X_1|^{1/2}\|\varphi'\|$
   makes point evaluation a bounded functional.** So `prp:hatAprop`(v) does not contradict CFF; it
   *explains* CFF's Assumption 4.5, and identifies the derivative parameterisation as the reason it
   holds.

**Consequence, and it is a scope statement worth adding to `prp:tccfails` when the block next moves.**
`prp:tccfails` and `prp:hatAprop`(v) are properties of the **levels parameterisation on $L^2(\pi)$**.
In derivatives they would fail: with $v=\mathcal D^{-1}_0v'$ the centring cancels in the difference
(`lem:levels`, and §3.2 of the prior assessment), so
$\Delta v_i=\int_{X_{i1}}^{X_{i2}}v'$ and
$|\Delta v_i|\le(|\mathcal X|\,\|1/\pi\|_\infty)^{1/2}\|v'\|_{L^2(\pi)}$ — bounded. The spike of
`prp:hatAprop`(v)'s proof has $\|v'\|\to\infty$ and is excluded. **So in derivatives $\hat T$ *is*
Fréchet differentiable, the exact derivative needs no $x$-smoothing, `eq:hatTxrem`'s $h_x^{-1/2}$ in
`eq:normconst` disappears, and A6b becomes a condition on $\hat T$ itself.** `prp:tccfails`'s current
scope note names the sieve; it should name the **parameterisation** as well, because that is the second
place the refutation stops, and CFF is standing in it. *(This is a computation, offered as such; it is
not verified against `proofs.tex`'s proof of `prp:hatAprop`(v), which I read only in statement.)*

That observation cuts both ways and both should be printed. It **strengthens** the case for keeping
`prp:tccfails` as the levels-parameterisation statement it is, and it **supplies** `lem:levels` a second
consumer beyond §12.3's. It does **not** reopen the derivative route: §7.2 of the prior assessment's
$\tfrac83$-units-of-$s$ computation stands, and at the block's configuration $\mu_{\rm der}=0.571$ still
fails `eq:muhalf`. **The parameterisation that dissolves `prp:tccfails` is the one that cannot feed
`thm:rootn`.** That is worth saying in one sentence in `rem:lfnonlinear`, because it is the sharpest
available answer to "why not do what CFF does?"

**And the open sieve question is not made moot.** `eq:a6sieve` asks whether $x$-smoothing acts as a
near-identity on $\mathcal S_n$; it turns on $h_xL_x$, which no assumption constrains. (18) is a
statement about the relative spectra of $\{\mathcal Q_\varphi\}$ and says nothing about $h_xL_x$.
Worse: `rem:tccwhy`(3) records that establishing `eq:a6sieve` would cost *two* things — a joint budget
line $h_xL_x=O(\eta_{\mathrm{TCC}})$ **and** a bound on $\lambda_{\min}(\mathbf G_n)$. **(18) charges the
second and buys neither.** Q-6 is inherited verbatim, not resolved.

---

## 8. Dunker (2021) — where (18) sits, relayed

CFF: Dunker (2021) *"directly treats $\hat T'_\varphi$ and $\hat T'^\ast_{\varphi_\dagger}$ as operators
with the same range."* **Same range is range invariance**, which `prp:norangeinv` refutes here. So
Dunker's condition is close to the object the paper has already spent a round on, **not** to (18).

**And the logical placement is clean: range invariance is strictly stronger than (18).** If
$\hat{\mathcal A}_\varphi=\Omega(\varphi,\tilde\varphi)\hat{\mathcal A}_{\tilde\varphi}$ with
$\|\Omega-I\|\le\mathsf c\|\varphi-\tilde\varphi\|$, then
$\mathcal Q_\varphi=\hat{\mathcal A}^\ast_{\tilde\varphi}\Omega^\ast\Omega\hat{\mathcal A}_{\tilde\varphi}$
and $\Omega^\ast\Omega\succeq(1-\mathsf c\rho)^2I$ on the ball, so
$\mathcal Q_{\tilde\varphi}\preceq(1-\mathsf c\rho)^{-2}\mathcal Q_\varphi$ — which is (18) with
$M_4=(1-\mathsf c\rho)^2$. **The converse fails**: (18) constrains only the domain-side normal operator,
and a rotation of the range is invisible to it. (Abstractly: for rank-one
$\hat{\mathcal A}_\varphi=\langle\cdot,e\rangle f_\varphi$ with $\|f_\varphi\|$ constant and $f_\varphi$
rotating, ranges differ at every base point while $\mathcal Q_\varphi=\|f_\varphi\|^2\langle\cdot,e\rangle e$
is identical, so (18) holds at $M_4=1$.) And `prp:norangeinv`'s mechanism is exactly a range rotation —
*"$\hat{\mathcal A}_\varphi$'s range is spanned by kernels translated in $u$"*.

**So: `prp:norangeinv` does not refute (18), and should not be read as doing so. (18) is the weaker
condition, and it is the one CFF assumes.** Recording that placement is worth one sentence in
`prp:norangeinv` or `rem:tccverdict`, because a reader who has just read `prp:norangeinv` will otherwise
assume the CFF route is closed too, and it is not — it is closed for the reasons in §3.3 and §5, which
are different reasons.

*The `dunker2014`/Dunker (2021) key split of the prior §11.5 stands; nothing here changes it.*

---

## 9. Recommendation, in the form the dispatch asks for

**Keep A6b + `prp:tccrepair`. Carry (18) as a cited comparison, not as an operative route.**

Concretely, when the block next moves (not now — the fix round owns these files):

1. **`rem:tccverdict`, two sentences.** *"The nearest treatment of a nonlinear NPIV Landweber iteration,
   CFF (2025), controls its iteration by a relative-ill-posedness condition along the path
   (their (18)) rather than by a cone condition. That route is not available here: (18) is statable only
   for the $x$-smoothed family $\hat{\mathcal A}_\varphi$, it requires
   $(\hat{\mathcal A}^\ast_\varphi\hat{\mathcal A}_\varphi)^{-1}$ and hence a uniform lower bound on
   $\lambda_{\min}(\mathbf G_n(\cdot))$ relative to its value at the truth — the object `prp:tccrepair`(iii)
   declines to supply — and by Löwner–Heinz it transfers a source condition only for $\mu\le1$, below
   the configuration this paper's frontier uses. CFF's own local-identification apparatus
   (their Prop. 2.1(iii)–(iv), Def. 2.2) is a cone-type condition with a sufficient set, i.e. A6b and
   `prp:tccrepair` at the population level."*
2. **`rem:lfnonlinear`(3), one clause.** Add CFF (2025) beside `hanke1995`/`engl2000` for the
   $\mu\le\tfrac12$ ceiling: CFF's $\beta\le1-\epsilon$ **is** that ceiling in $\beta=2\mu$, reached
   independently, in econometrics, in the same estimator class, in 2025. **This is the cheapest gain in
   this dispatch** — it converts a mathematics citation into an econometrics one for the single most
   contestable line in `rem:lfnonlinear`.
3. **`prp:tccfails`, one scope clause.** The refutation stops at the sieve **and at the parameterisation**;
   §7 gives the computation, and CFF's Assumption 4.5 is the witness.
4. **`prp:norangeinv` or `rem:tccverdict`, one sentence.** Range invariance $\Rightarrow$ (18) and not
   conversely; `prp:norangeinv` does not close the CFF route, §3.3 and §5 do.
5. **Beside Q-4, one open item.** (18)-on-the-compression is the only proposed route to a deterministic
   base point for the source condition; it is available only if (P-a) is restated spectrally; it caps
   $\mu\le1$; it charges Q-3 in ratio form plus $\mathrm{cond}(D)$. **Not adopted; recorded so the
   answer to "why (P-a) at a random base point?" is not silence.**
6. **Correct `theory_memo.md` L54–61 and this file's own §12.1 predecessor.** The claim *"CFF uses no
   tangential cone condition at all"* is wrong; the claim *"`prp:tccfails` says nothing about (18)"* is
   right but does not have the significance it was given.

**The honest bottom line, said as the dispatch asks it to be said.** I named this the most promising
unexplored route nearby. **It is not.** The promise came from three errors in my own §12.1: I read CFF's
Prop. 4.1 as cone-free when its identification apparatus is not; I read (18) as a substitute for the
remainder bound when it is an addition to it; and I did not notice that (18)'s only consumer in CFF is
itself unconsumed. The current apparatus — A6b as a property, `prp:tccrepair` as its proved sufficient
condition, `prp:tccfails` as the refutation of what the literature would have had the paper assume — is
better than the alternative on every axis I can price: fewer maintained assumptions, a proved sufficient
condition where (18) has none, no exponent ceiling, and Q-3 left where the memo puts it, as a simulation
question. **What (18) is genuinely worth is three citations and a scope clause, and those are worth
having.**

---

## 10. Byproducts worth banking, separable from the recommendation

1. **`rem:lfnonlinear`(3)'s ceiling gets an econometrics citation.** §9.2. CFF's $\beta\le1-\epsilon$ is
   $\mu<\tfrac12$, independently reached.
2. **`prp:hatAprop`(iv) is sharper than its published counterpart, and the sharpening is load-bearing.**
   §4(b): CFF's Prop. 4.2(a) writes "$\hat M<\infty$" where `eq:hatTxrem` displays $h_u^{-2}$, and the
   displayed factor is what (P-f) and hence `eq:muhalf` are about. That is a defensible claim to
   *priority in care*, and it belongs in the paper's positioning rather than in a footnote.
3. **A cheap population local-identification statement is available.** §3.1: `prp:frechet`(i) is
   CFF's Prop. 2.1(iii) unconditionally; adding a $\mathcal B_M$-style set would give a population
   local-identification proposition at the cost of a definition. **Separable from everything above, and
   worth a look if the paper wants a local-identification result it does not currently state.**
4. **`prp:hatAprop`(v)'s scope note earns `lem:levels` a second consumer.** §7: the derivative
   parameterisation is precisely what makes point evaluation bounded, hence what makes CFF's
   Assumption 4.5 true, hence why CFF has no `prp:tccfails`. Combined with §12.3's $\mu_{\rm der}$
   computation, `lem:levels` now answers two questions instead of none.

---

## 11. Declared scope — what this assessment does not establish

- **CFF's Supplementary Material §§A–D was not read and is not present at the given path.** The PDF is
  19 pages, main text only. Consequences: (a) §2.2's reconstruction of (18)'s role in Prop. 4.1 is a
  labelled reconstruction from the statement, CFF's gloss, and the standard nonlinear-Landweber energy
  argument — **it is not a verification**; (b) whether §C/§D's proof of Thm 4.1 silently consumes
  Prop. 4.1's conclusion ($\varphi_j\in\mathcal B_\dagger$) is **not settled**, and §2.3 says which way
  that would cut; (c) whether Prop. 4.2(a)'s constant $\hat M$ carries $h_u^{-2}$ is **not verified** —
  §4(b) argues it must from the mechanism and from Prop. 4.2(b)'s explicit $h_u^{-2}\kappa_n^{-1}$.
- **I did not read the in-flight fix round's output.** §6 is written conditionally on the spectral
  restatement of (P-a) and flags the dependency explicitly; if (P-a) stays in Hilbert-scale form, §6's
  route does not exist. **This is a flag, not an assumption about either version.**
- **§7's derivative-parameterisation computation is offered as a computation, not verified against
  `proofs.tex`.** I read `prp:hatAprop`(v) in statement only. What is used is
  $|\int_{X_{i1}}^{X_{i2}}v'|\le(|\mathcal X|\|1/\pi\|_\infty)^{1/2}\|v'\|_{L^2(\pi)}$ and the
  cancellation of the centring under $\Delta$ (`lem:nusigma`(ii)); both are in the file, neither is
  combined there in this way.
- **§5.1's factorisation assumes $D$ injective on $\mathcal S_n$**, which is the `prp:norangeinv`(ii)
  proviso and is *not* established at design points inside the boundary layer. (5.1) is a sufficient
  bound, not an identity; a sharper base-point-only comparison may exist and is not attempted.
- **§4(c) is flagged, not adjudicated.** Whether (P-f) as printed presumes an $h_x$-free conversion of
  $\|\Delta_{h_x}v\|_2^2/n_{\mathrm m}$ to $\|v\|^2_{L^2(\pi)}$ is a Part-H question owned by the fix
  round; I did not read the relevant step of `proofs.tex`.
- **Dunker (2021) and Dunker et al. (2014) were not read.** §8's characterisations are relayed from CFF
  and labelled as relay; the *logical* placement (range invariance $\Rightarrow$ (18), not conversely) is
  my own and is proved there.
- **I did not verify Löwner–Heinz, Douglas' range-inclusion theorem, or Bhatia Ch. V against copies.**
  §2.1 and §5.3 invoke them by name; the file's own `lem:srctransfer`(ii.a) already cites Bhatia for the
  failure above the first power, and (2.1) is that statement read at the square.
- **This assessment scores nothing and edits nothing** in `results.tex`, `proofs.tex`,
  `assumptions.tex` or `notation_glossary.md`, per the dispatch. Every recommendation in §9 is phrased
  for a future round.
