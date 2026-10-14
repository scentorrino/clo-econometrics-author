<!-- RECOVERED 2026-07-30 from subagent transcript agent-a947ccba31c598c8d.jsonl.
     This report was produced on 2026-07-29 but the orchestrator never wrote it to disk.
     The gap was discovered when the consolidated gating fix round reported the file absent
     and worked from relayed content instead. Body below is the agent's final report verbatim;
     only this banner was added. Second recorded instance of an unpersisted narrow-critic
     report (cf. proofs_review_dispatch3.md). -->

# Assumption-Usage Matrix — `panel-npiv-discrete`, Part H

**Scope:** `assumptions.tex` (full block), `results.tex:2150–3474` (Part H), `proofs.tex:2712–4353` (Part H proofs), cross-checked against `theory_memo.md`.
**Score: 30/100.**
**No finding is a soundness defect.** Every deduction is hypothesis-list fidelity or assumption parsimony. Part H has not had the cite-by-clause narrowing pass that Parts E/F received in round 7, and its four inherited hypothesis lists were merged verbatim from `results_partH.tex` without a clause audit.

---

## Section 1 — Usage Matrix (Part H only)

`Mode`: Bound / Well-posed / Existence / Structure / Design / Rate.

| Tag | Statement (short) | Used in (Part H) | Mode | Strength of use |
|---|---|---|---|---|
| A0 | i.i.d. from $P$; $\mathcal X$ compact **interval** | `lem:intker`(iv) proof (`proofs.tex:2774`), `prp:hatAprop` Step 3 (`:2832`), `lem:opnoise` Step 2 (i.i.d.), `def:hatT` (fold independence), `(H1c)` | Structure + Well-posed | Full — **but unlisted on `lem:intker`; both Part H consumers absent from A0's own consumer list (`assumptions.tex:59–70`)** |
| A1 | $\Delta U\perp W\mid\Delta Z$, $E[\Delta U\mid\Delta Z]=0$ | `lem:opnoise` Step 0 → $T(\vdagger,\theta_\dagger)=0$; transitively `prp:stopfeas`, `prp:phirate` (N1) | Structure | Full |
| A1b(ii) | measure-separability | not used in Part H (`lem:nusigma`(ii), Part C) | — | Not invoked here |
| A1b(iii) | $\mathcal V_{CI}=\{\vdagger\}$ | listed on `prp:phirate` (`results.tex:3226`); **no proof appearance** | — | **Carried as background; `rem:phirscope`(4) (`:3447`) says so explicitly. No deduction — see Observation O-1** |
| A1b(iv) | $E[\Delta Z\Delta Z']$ nonsingular; 2nd moments | listed on `lem:opnoise`, `lem:aerr`, `lem:unifop`; **no appearance in any Part H proof, direct or transitive** | — | **UNUSED, no retention remark** |
| A4(i) | overlap $\varrho\in[\varepsilon_\varrho,1-\varepsilon_\varrho]$ | `prp:hatAprop`(v), `prp:tccfails`, `prp:norangeinv` via `eq:wbounds` | Structure | Partial — `def:hatT`(b) derives `eq:wbounds` from the truncation and $W_i\in\{0,1\}$ alone; A4(i) only names the level |
| A4(ii) | $\varrho$ in Hölder ball of order $r$ | definitional, via $\alpha=r/(2r+d_Z)$ | Design | Full (definitional) |
| A4(iii) | $\|\hat\varrho-\varrho\|_{L^2}=O_P(r_n)$, auxiliary fold | `lem:opnoise`(iii), `lem:unifop` Step 1, `lem:aerr` Step 3, `prp:tccfails` (fold split), `prp:stopfeas`(ii) | Rate + Structure | Full — both the rate and the fold clause are separately load-bearing |
| A5(i)–(iii) | operator noise, structural rate, frontier | **discharged** by `prp:phirate` Step 6 | — | Not hypotheses |
| A5(vi) | $\|h\|_{H^s}=O_P(1)$, final iterate | follows from A5(vi′) at $k=\bar k$ | — | Not a Part H hypothesis |
| A5(vi′) | $\max_{k\le\bar k}\|\hat\varphi^{(k)}-\vdagger\|_{H^s}=O_P(1)$ | `lem:pathcont`(c), `prp:phirate` Step 5 | Structure | Full — **but its $k=0$ instance is restated twice more, under (P-a) and in `def:lfstep`'s preamble** |
| A6 | tangential cone condition | **RETIRED** — refuted by `prp:tccfails` | — | Not available; struck display retained at `ass:tcc` |
| A6b | restricted curvature (property) | `prp:tccrepair`(i),(ii) only | Structure | Full, single declared consumer, never asserted — **clean** |
| A7 (`eq:a7amend`) | $P(\|\hat T(\vdagger,\theta)\|\le\tau_{\rm DP}\hat\delta_n\ln n)\to1$ | (P-e); `prp:phirate` (L4); verified by `prp:stopfeas`(iii) | Bound | Full |
| A8 basis clause | B-splines of order $>s$, quasi-uniform mesh | `prp:phirate` Step 1 (direct theorem, `proofs.tex:3963`), `lem:unifop`(3d) inverse inequality (`:3648`) | Design | Full |
| A8 upper end | $L_x\ll n^{1/2}$ | `lem:srctransfer`(iii) (`:3854`), `prp:phirate` Step 1 (`:3956`) | Design | Full |
| A8 lower end | $L_x\gg n^{1/(2s)}$ | **not used on the rate route** — replaced by (P-c) | — | Correctly disclaimed in `prp:phirate` and recorded at `assumptions.tex:2052–2056` |
| B1(i) | $\Phi$ Borel, injective, bounded | via $\bar w$, all Part H bounds | Bound | Full |
| B1(ii) | $w=\exp$ | `prp:hatAprop` Step 7, `prp:tccfails` Steps 3, 5 ($w>0$) | Existence | Full |
| B1(iii) | $\mathrm{Leb}(\mathcal T)>0$ | **no Part H appearance** | — | Charged by `prp:phirate`'s "B1" in full |
| B1(iv.a) | $\Pi_u\ll$ Leb, $\varpi_u>0$ bounded, $C^1$ | `prp:hatAprop` Step 7, `prp:tccfails` Steps 3, 5, `prp:norangeinv`, `lem:aerr` Step 1 | Existence + Bound | Full — positivity and $\|\varpi_u\|_\infty$ both used; the $C^1$ clause is Part F's |
| B1(iv.b) | $\Pi_t$ has nonzero a.c. part | $\Pi_t(\mathcal T)>0$ at four sites | Existence | Partial — only $\Pi_t(\mathcal T)>0$ used in Part H |
| B1(iv.c) | $c_\Pi<\infty$ | every $L^2(\Pi)$ bound | Bound | Full |
| B1(v) | correction measure $\gamma$ | **no Part H appearance** | — | Charged by "B1" in full |
| B1(vi) | growing family $\mathcal T_n$ | **no Part H appearance** (identification only, per its own clause) | — | Charged by "B1" in full |
| C1(i) | densities $C^{p_K}$, bounded | **sole Part H appearance: `proofs.tex:3317`, inside `lem:aerr` Step 2 — and `lem:aerr` is declared consumer-free** | — | **Orphaned; retention note at `assumptions.tex:1774–1778` names `prp:phirate` as its consumer and is now false** |
| C1(ii) | $f_{X_j},\pi$ bounded above/below | `prp:hatAprop` Steps 2–3, `prp:tccrepair`, `prp:norangeinv`, `lem:aerr`, `lem:nusigma`(i) | Bound | Full |
| C2′(i) | $f_{\Delta Y\mid\cdot}$ $C^{p_K-1}$, envelopes | `lem:unifop` Step 2 (the free uniformity), `prp:tccfails`(iii), `lem:aerr` Steps 2, 4 | Bound | Full |
| C2′(ii) | $u\mapsto\mathcal M(u,t)$ in $C^{p_K}$ uniformly in $t$ | `lem:opnoise`(ii) Step 3 | Bound | Full |
| C3(i) | order $p_K$ | `lem:intker`(i),(iii),(iv) | Bound | Full — **the normalisation $\int\Theta_{s_0}=1$ it carries is not printed in C3; see U-1** |
| C3(ii) | support + boundary index $s_0$ | `lem:intker`(i),(iv), `prp:hatAprop`(iii) | Structure | Full |
| C3(iii) | $C_h(\cdot,1)$ symmetric Lipschitz | `lem:intker`(ii) → $\mathsf c_4$, `eq:hatTxrem` | Bound | Full |
| C4′ | residual truncation, $\kappa_n>0$ | **no Part H appearance** (correctly struck from `prp:phirate`, memo 3.6) | — | Not invoked |
| C5′(i) | $p_K=8$, $h_u\asymp\mathrm{sd}(\Delta U)\hat\delta_n^{1/p_K}$ | everywhere: `lem:opnoise`, `prp:stopfeas`, `prp:tccfails` Steps 3, 5, Step 4(a)'s $\mathsf b_n$ | Design | Full |
| C5′(ii) | $(nh_x^2h_u^3)^{-1}\ln n\to0$ | **discussed only** at `proofs.tex:3367–3370` (inside `lem:aerr`); no live consumer | — | Retained with an explicit reason (`assumptions.tex:1977–1985) — **no deduction for retention**; charged by "C5′" in full |
| C5′(iii) | $r$ obeys `eq:frontier` | `prp:stopfeas`(iv), `prp:phirate` conclusion | Design | Full |
| C5′(iv) | no bandwidth in $t,\Delta Z,W$ | convention | Structure | Full |
| H1 | $\sigma_j\asymp j^{-a}$, infinite rank, matched scales, $\mu=s/(2a)$ | `prp:phirate` statement, `def:srcball` ($\|\vdagger\|_{H^s}\le\mathsf R$), `lem:unifop` Step 4, `lem:srctransfer`(iii) | Structure | Full |
| `def:model` | $X$ scalar, continuously distributed | `prp:hatAprop` Step 7, `prp:tccfails` (distinctness of the $2n$ points) | Existence | Full — declared and cited by tag |
| `def:hatT` | truncation to $[\varepsilon_\varrho,1-\varepsilon_\varrho]$; fold split | `eq:wbounds` **surely** → `prp:hatAprop`(v), `prp:tccfails`, `prp:norangeinv`(ii), `prp:tccrepair`(ii)–(iii) | Structure | Full — the truncation is the operative content, not A4(i) |
| (P1)–(P7) | standing conventions | throughout | mixed | Declared at `proofs.tex:12–168` |
| **(H1c)** | fold conditioning + conditional-to-unconditional $O_P$ | `proofs.tex:2786, 3216, 3268, 3270, 3292, 3577` | Structure | **Invoked by tag at 6 live sites; declared ONLY in `proofs_partH.tex:29–36`, stamped "DO NOT COMPILE"** |
| **(H2c)** | $\Theta_{s_0}(\varsigma):=C_h(h\varsigma,s_0)$ + order conditions | `proofs.tex:2736, 2739, 2812, 3303, 3347`; `results.tex:2359` | Bound | **Same — declared only at `proofs_partH.tex:38–58`** |
| (P-a) | preliminary ∈ $\mathcal S_n$; $H^s$; rate $\varsigma_0$; stagewise source; **two-sided link on $\mathcal S_n$ at the realised operator** | `prp:phirate` (L5), Step 3 base case, Step 4(a.1) | Structure + Rate | Full — **five conditions under one tag; the link half implies a calibration the file denies (Finding A-1)** |
| (P-b) | *[struck]* | label kept empty; no live citation | — | Correctly handled |
| (P-c) | $\mathsf RL_x^{-s}=O(h_u\hat\delta_n)$ | `prp:phirate` Step 1 (projection), `eq:linlftot` | Design | Full |
| (P-d) | `eq:entropysieve` | `prp:phirate` Step 1 twice, via `lem:unifop`(b),(3d) | Design | Full |
| (P-e) | $\tau_{\rm DP}>2$ | (L4) | Bound | Full |
| (P-f) | $\delta_n^2=O(h_u^2\hat\delta_n\ln n)$ | Step 4(b) fixed point; = Step 4(a.1) | Rate | Full |
| (P-g) | $\mathsf Rh_x^{s-1/2}=O(\hat\delta_n)$ | Step 1 (N1) via `lem:unifop` Step 4; `rem:tccwhy`(3)(a) | Design | Full |
| `eq:muhalf` | $\mu>5/6$ | Step 4 | Rate | Full — subsumes $\mu>1/2$ |
| `eq:entropy` | Sobolev-ball entropy condition | `lem:unifop`(a) only; **consumed by nothing** | — | Explicitly declared unconsumed (`results.tex:2873`, `rem:l19cost`(0)) — **no deduction** |
| `eq:gamman`, `eq:entropyA`, `lem:aerr` | operator-estimation rate | **"Consumers: none"** (`results.tex:2713`) | — | Retention reasons stated at reading (iv) — **honest; no deduction** |
| `eq:gramunif` | $\underline\lambda_n>0$ uniform over base points | `prp:tccrepair`(ii) | Bound | Full, correctly scoped as a hypothesis |
| `eq:rirad`, `eq:lebpt`, independence proviso | local hypotheses | `prp:norangeinv`, `prp:tccfails`(iii) | Existence | Full, each stated |

---

## Section 2 — Findings

### Unstated conditions invoked (−15 / −10 / −5)

**U-1 (−15). Conventions (H1c) and (H2c) are invoked by tag at eleven live sites and are declared nowhere in the compilable block.** Both are declared only in `proofs_partH.tex:29–58`, whose own header reads:

> `%  *** STALE MERGE RECORD.  DO NOT COMPILE AND DO NOT EDIT. ***`

`proofs.tex` declares (P1)–(P7) at lines 12–168 and never declares (H1c) or (H2c). The glossary carries neither. Three sub-items:

- `proofs.tex:3270` reads *"Conditional Markov and **(H1c)'s last sentence** give …"*. That last sentence — a conditional $O_P(a_n)$ bound with an $O_P(1)$ bounding constant is unconditionally $O_P(a_n)$ — is a substantive inference step and exists only in the stale file.
- (H1c) is also where the fold independence is attributed to A0. Part H's consumption of A0's i.i.d. clause therefore runs through an undeclared convention.
- (H2c) carries the order-$p_K$ normalisation $\int\Theta_{s_0}=1$, which `lem:intker`(i),(iii),(iv) consume by that name (`proofs.tex:2741, 2766, 2780`), together with the flag *"C3 does not print the normalisation … It should be printed"*. In the live block it is neither printed in C3 nor recorded anywhere. **Route to the regularity-checker:** the same note records an internal clash in C3 — at $s_0=1$ the C3(ii) support clause reads $[0,c_C]$, one-sided, while C3(iii) calls $C_h(\cdot,1)$ symmetric. That flag is also live nowhere.

This reproduces, for Part H's own conventions, exactly the failure mode the retired-A6 tag policy exists to prevent: a reader following a cited tag lands on a file marked do-not-compile.

**U-2 (−10). `lem:intker` states "Suppose C3 holds" and its proof consumes A0.** `proofs.tex:2774–2775`: *"If $x^\ast$ is at distance at least $c_Ch_x$ from both endpoints of $\mathcal X$ — **which is an interval, by A0** —"*. Clause (iv) is a statement about the interior of a compact interval and is false on a disconnected $\mathcal X$; A0 is not on the hypothesis line (`results.tex:2169`). The defect runs both ways: A0's own consumer list (`assumptions.tex:59–70`, corrected twice) names `lem:levels`, `lem:balance`, A8, H1 and `lem:balance` Step 4, and omits both Part H consumers — `lem:intker`(iv) and `prp:hatAprop` Step 3 (`proofs.tex:2832`, where the interval clause delivers $\dim\mathcal V=\infty$, on which clause (ii) rests).

**U-3 (−5). `lem:pathcont`'s hypothesis list omits what its own within-stage bound consumes.** The statement (`results.tex:2958–2962`) lists only $\hat\varphi^{(0)}$'s two rates, A5(vi′), and "the stages of `def:lfstep`". The proof's within-stage paragraph (`proofs.tex:3695–3706`) consumes `prp:hatAprop`(i) and `lem:intker`(i) with (P1), (P2), B1(iv.c) — hence A0, B1(i),(ii),(iv.a–c), C1(ii), C3, none listed. Mitigated by the reference to `def:lfstep`, which imports the ambient setting; not mitigated for a reader checking minimality.

### Hypothesis lists charging what the proofs do not consume (−10 each)

**O-1 (−10). A1b(iv) is charged on three Part H lemmas and consumed by none.** `lem:opnoise` (`results.tex:2668`), `lem:aerr` (`:2718`) and `lem:unifop` (`:2855`) all open "Suppose A0, A1b(iv), A4(iii), …". A1b(iv) does not appear anywhere in `proofs.tex` after line 1924 (Part F). Nor is it consumed transitively: `lem:nusigma`, the only Part E result these three invoke, needs C1(ii) alone (`results.tex:699`). The reason it is idle is the block's own: B1(i)'s boundedness makes $w=\exp$ integrable *"with NO moment condition whatsoever on Delta Z"* (`assumptions.tex:360–363`), and every Part H summand is bounded by (P1), (P2), `lem:intker`(i) and B1(iv.c). No retention remark exists at any of the three sites. The three lists are verbatim identical to `results_partH.tex:558, 600, 691`, which is how the over-citation survived the merge.

**O-2 (−10). C1, B1 and C5′ are cited in full on `prp:phirate`, against the block's own cite-by-clause rule, and C1(i)'s retention note is now false.** `prp:phirate` (`results.tex:3226`) reads "Suppose A0, A1, A1b(iii)–(iv), A4, A5(vi′), B1, C1, C2′, C3, C5′ and H1". Live content:

- **C1**: only C1(ii). C1(i)'s single Part H appearance is `proofs.tex:3317`, inside `lem:aerr` Step 2 — and `lem:aerr` opens "**Consumers: none**". So C1(i) is orphaned in Part H, while `assumptions.tex:1774–1778` justifies its retention with *"it is consumed by prp:phirate (Step 6) together with C3 and C5′."* That is no longer true. The `lem:aerr` sweep reached the lemma's head and `lem:pathcont` (`proofs.tex:3687–3689`) but not the assumption whose retention depends on it.
- **B1**: B1(iii), (v), (vi) appear nowhere in Part H.
- **C5′**: C5′(ii) appears only as discussion (`proofs.tex:3367–3370`, inside `lem:aerr`); it has no live consumer. Its retention reason is stated and honest (`assumptions.tex:1977–1985`), so I deduct nothing for the retention — only for the in-full citation.

The block narrowed C1→C1(ii) at thirteen sites in round 7 and A2′→by-clause at four sites in round 8, for exactly this reason. Part H's flagship reverts.

### Attribution statements contradicting the block's own hypotheses (−10, −5)

**A-1 (−10) — PRIORITY 1 CONFIRMED, with the scope tightened. (P-a) implies the calibration `lem:scaleinv` says nothing in Part H establishes; the cross-reference is routed to the wrong open item.**

`lem:scaleinv`'s closing paragraph (`results.tex:3091–3094`):

> *Nothing in Part~H therefore needs $\|\hat{\mathcal A}_\varphi\|\asymp1$*, which is fortunate, because nothing in Part~H establishes it: only the upper bound of `prp:hatAprop`(i) is available, a matching lower bound would again be $\lambda_{\min}(\mathbf G_n(\cdot))$, and Q-3 records that as open.

But (P-a) (`results.tex:3245–3247`) assumes *"the link condition of `lem:srctransfer`(iii) holds on $\mathcal S_n$ for the realised operator $\hat{\mathcal A}_{\hat\varphi^{(k-1)}}$"*, i.e. $\|\hat{\mathcal A}\zeta\|_{L^2(\Pi)}\asymp\|\zeta\|_{H^{-a}}$ on $\mathcal S_n$. The constants must be $n$-free: (L5) (`proofs.tex:4061–4066`) concludes "a pre-image of norm $O_P(\mathsf R)$" with $\mathsf R$ fixed and $n$-free by `def:srcball`, so $n$-dependent link constants would propagate into `eq:linlf` and destroy the rate. Then, on the event (P-a) holds (w.p.$\to1$, which is where every other step of the proof lives):

- **Upper half.** $\|\zeta\|_{H^{-a}}\le\|\mathcal D^{-a}\|\,\|\zeta\|_{L^2(\pi)}$, with $\|\mathcal D^{-a}\|<\infty$ because a Hilbert scale requires $\mathcal D$ strictly positive (Engl §8.4, which H1 invokes). Hence $\|\hat{\mathcal A}_{\hat\varphi^{(k-1)}}|_{\mathcal S_n}\|\le C_2\|\mathcal D^{-a}\|$ — **an $n$-free operator-norm bound**, directly contradicting `results.tex:3081–3084`, *"The only norm bound available in this file diverges."*
- **Lower half** at a fixed smooth $\zeta$ with $\zeta_n:=P_{\mathcal S_n}\zeta$ gives $\|\hat{\mathcal A}|_{\mathcal S_n}\|\ge C_1\liminf\|\zeta_n\|_{H^{-a}}>0$.

So $\|\hat{\mathcal A}_{\hat\varphi^{(k-1)}}|_{\mathcal S_n}\|\asymp1$, and the parenthetical alternative at `results.tex:3088–3091` — *"If the unscaled norm were instead $o(1)$ — which is plausible, since near-orthogonal $\hat g_i$ would give $\|\hat{\mathcal A}_\varphi|_{\mathcal S_n}\|\asymp(n_{\rm m}h_u)^{-1/2}$"* — is **excluded by a hypothesis of the very proposition that consumes this lemma**. The two-sided robustness argument defends against a case (P-a) rules out.

Three consequences, priced:

1. **"Nothing in Part H *needs* it" is confirmed true.** `lem:scaleinv`(iv) is exact for every $\omega>0$ and nothing rests on the calibration. Adjacent **"nothing establishes it" is false as to the object (L1) is about** — the paragraph slides between $\|\hat{\mathcal A}_\varphi\|$ (full space, where the claim is defensible) and $\|\hat{\mathcal A}_\varphi|_{\mathcal S_n}\|$ (where (P-a) settles it).
2. **The divergent $\omega_n$ and `eq:cap`'s $\omega_n^2$ inflation are a choice, and the price is computable.** The only thing $\omega_n$ buys over $\omega=C_2\|\mathcal D^{-a}\|$ is that (L1) holds **surely** rather than w.p.$\to1$ — and (L3), (L4), (L5), Step 3 and Step 4 are all w.p.$\to1$ anyway. The cost, at the design configuration $(\mu,s,a,\alpha)=(2,3,\tfrac34,0.32)$ with $h_u\asymp n^{-0.04}$ and $h_x\in(n^{-0.44},n^{-0.128})$ (`assumptions.tex:1993–2003`): $\omega_n^2\propto h_u^{-2}h_x^{-1}\in(n^{0.208},n^{0.52})$, so `eq:cap` requires $\bar m_n\ge n^{0.848}$ to $n^{1.16}$ against $\hat\delta_n^{-2}=n^{0.64}$ — **a Landweber iteration budget inflated by a factor of roughly 5 to 50 at $n=2000$.** Step 7 and `/simulate` pay that directly.
3. **The cross-reference is misrouted between two open items.** The sentence sends the reader to **Q-3** (`theory_memo.md:2254`: *"Needed only for A6b's radius `eq:tccrad`, which no theorem consumes — so this is a simulation question, not a theory obligation"*). The object actually at issue is the sieve-restricted injectivity modulus, which is **Q-4** (`:2258`: the link condition, *"assumed, not derived"*). Routing an **assumed** quantity to the open item the memo classifies as *not a theory obligation* is what makes it read as unavailable.

**Scope correction to the dispatch framing.** The block declines a $\lambda_{\min}$-species bound at four sites, but only two are on the sieve and only those two are touched:

| Site | Object | Touched by (P-a)? |
|---|---|---|
| `lem:scaleinv` closing (`results.tex:3091`) | $\|\hat{\mathcal A}\vert_{\mathcal S_n}\|$ from below | **Yes — settled** |
| `eq:a6sieve`'s "only if" (`results.tex:2431–2438`) | lower bound on $\|\sum_i\hat g_i\Delta v_i\|$ over $\mathcal S_n$ | **Partly.** (P-a) bounds $\|\hat{\mathcal A}v\|$ below on $\mathcal S_n$; the raw-difference version follows via the reverse triangle inequality once the $x$-smoothing discrepancy $O(h_xL_x\|v\|_\infty)$ is controlled — which is the *other* item the remark already charges. So the remark over-prices sufficiency by one item on the sieve |
| `prp:tccrepair`(iii) (`results.tex:2529–2537`) | $\lambda_{\min}$ of the $n_{\rm m}\times n_{\rm m}$ Gram matrix over an $L^2(\pi)$-ball of $\mathcal V$ | **No** — an $n_{\rm m}$-dimensional statement; (P-a) constrains an $L_x$-dimensional restriction, $L_x\ll n^{1/2}\le n_{\rm m}$ |
| `prp:norangeinv`'s proviso (`results.tex:2645–2651`) | linear independence of the $n_{\rm m}$ functions $\mathsf d_i$ in $L^2(\mathcal X,dx)$ | **No** — same dimension mismatch |

So (b) and (c) are correctly declined and should stay declined. **Does the matrix record (P-a) as a use of something in that family? It now does — the row above marks the link half as an injectivity-modulus assumption on $\mathcal S_n$, and that is the gap the four disclaimers, read together, conceal.**

**A-2 (−5) — PRIORITY 2 CONFIRMED, both halves.** `lem:srctransfer`(iii) closes (`results.tex:3039–3041`): *"**A8's window** is what makes the Hilbert-scale route available at $\mu>\tfrac12$, and that is a use of A8 **the block does not yet record**."* Both halves are false:

- **"window"** should be **"upper end"**. The lemma's own proof, four lines of a different file away (`proofs.tex:3853–3856`), says: *"for which A8's **upper end** $L_x\ll n^{1/2}\le n_{\rm m}$ is sufficient in generic position. **The upper end, not A8 in full**: the lower end plays no part here."* A statement-versus-proof over-attribution inside one lemma.
- **"the block does not yet record"** is false. `assumptions.tex:2052–2056` records it, naming `lem:srctransfer`(iii) and `lem:unifop`(3d) as the two consumers, and disclaiming the lower end.

Substantively nothing turns on it — the link condition needs the sieve, not the window — but the sentence is the sole surviving instance of a claim the pass otherwise swept, and the pass presents A8 as handled (`theory_memo.md:108`, dispatch-8 log MAJOR 2.4).

**A-3 (−5). The preliminary's $H^s$ bound is stated under three tags.** $\|\hat\varphi^{(0)}-\vdagger\|_{H^s}=O_P(1)$ appears at `def:lfstep`'s preamble (`results.tex:3103`), inside (P-a) (`:3234`), and as A5(vi′) at $k=0$ (`assumptions.tex:1330–1334`, whose max runs over $0\le k\le\bar k$); `lem:pathcont` (`:2959–2961`) restates the $L^2(\pi)$ half a fourth time. `prp:phirate` therefore lists both A5(vi′) and (P-a) and assumes one condition twice. This is the "one tag, one object" discipline the block enforces for A1b(i)/`def:spaces`, A2′(i)/A2b and N1/N1′, not applied to its own newest hypotheses.

### Sweep for the recurring species (Priority 2, third instance → now sixth)

**The species — a claim corrected in one place out of N, with no symbol withdrawn — recurs five more times in Part H.** All are in-lane assumption-attribution statements:

1. **A-2 above** — `lem:srctransfer`(iii)'s closing sentence: two prose sweeps performed, this one missed.
2. **O-2's C1(i)** — the `lem:aerr` sweep reached the lemma head and `lem:pathcont` and missed the assumption whose *retention justification* names it.
3. **U-1's (H1c)/(H2c)** — `results_partH.tex` and `proofs_partH.tex` were declared stale, and eleven live tag citations into them were not swept.
4. **O-1's A1b(iv)** — three hypothesis lists merged verbatim without a clause audit.
5. **A1b(iii) on `prp:phirate`** — memo Finding 3.6 struck A2, C4′ and A1c for having no consumer and kept two tags in the same category without examining them.

### No issues (recorded so they are not re-flagged)

- `lem:aerr`, `eq:gamman`, `eq:entropyA`, `eq:entropy` and C5′(ii)'s lower bound are all **unconsumed with explicit, honest retention reasons stated at the site**. Per standing calibration, **zero deduction**. `lem:aerr`'s "Consumers: none" head and reading (iv) are the model the rest of the block should follow.
- **A6b** is exemplary: property tag, never asserted, exactly one declared consumer (`prp:tccrepair`), and `def:a6b` says so in the statement.
- **(P-b)** struck with the label kept empty and no live citation — correct handling.
- **A8 by clause** in `prp:phirate` is correct and matches both its proof sites.
- **`def:hatT`'s truncation** is correctly placed in the maintained block, and `eq:wbounds`'s three consumers are named at `def:hatTexp`.

---

## Section 3 — Suggestions

Minimal fixes; implementation is the theorist's.

1. **U-1 — merge the standing conventions.** Carry (H1c) and (H2c) into `proofs.tex`'s (P1)–(P7) block, or retag them (P8)/(P9). While transcribing: print $\int\Theta_{s_0}=1$ in C3(i) or record that "order $p_K$" carries it, and re-file the $s_0=1$ support-versus-symmetry clash — it belongs live, and it is the regularity-checker's to adjudicate.
2. **U-2 — add A0 to `lem:intker`'s hypothesis line**, and add `lem:intker`(iv) and `prp:hatAprop` Step 3 to A0's consumer list at `assumptions.tex:59–70`.
3. **U-3 — either add "Suppose the hypotheses of `prp:hatAprop`" to `lem:pathcont`**, or state that the within-stage paragraph inherits them.
4. **O-1 — strike A1b(iv) from `lem:opnoise`, `lem:aerr` and `lem:unifop`**, or name the clause and the step that consumes it. If it is carried for the reader's orientation, say so, as `rem:phirscope`(4) does for A1b(iii).
5. **O-2 — narrow `prp:phirate`'s citations to C1(ii), B1(i),(ii),(iv.a)–(iv.c), C5′(i),(iii),(iv)**, and narrow `lem:aerr`'s C1 to C1(i)+(ii) since it alone uses (i). Correct C1(i)'s retention note: it is now the price-tag on `lem:aerr`'s route, not a `prp:phirate` input.
6. **A-1 — rewrite `lem:scaleinv`'s closing two sentences and reprice `eq:cap`.** State that (P-a)'s link half pins $\|\hat{\mathcal A}_{\hat\varphi^{(k-1)}}|_{\mathcal S_n}\|\asymp1$ w.p.$\to1$; that $\omega_n$ is chosen divergent to obtain (L1) **surely** rather than w.p.$\to1$; and that the price is the $\omega_n^2$ factor in `eq:cap`. Redirect the cross-reference from Q-3 to Q-4. Delete or scope the $o(1)$ scenario, which (P-a) excludes. Correspondingly, scope `rem:tccwhy`(3)'s cost estimate: on $\mathcal S_n$, the $\lambda_{\min}$-species half is already granted by (P-a), so only the $h_xL_x$ budget line remains genuinely unpaid.
7. **A-1, second-order — consider splitting (P-a).** It bundles five conditions, two of which are undischarged and open under *different* memo items (preliminary rate → Q-1; source-and-link → Q-4). Splitting into (P-a1)/(P-a2) would let the file price the two separately and would make the norm calibration attributable to (P-a2) alone.
8. **A-2 — replace "A8's window" with "A8's upper end"** in `lem:srctransfer`(iii)'s closing sentence and strike "the block does not yet record", pointing instead at `assumptions.tex:2052–2056`.
9. **A-3 — state the preliminary's $H^s$ bound once.** A5(vi′) at $k=0$ already carries it; (P-a) and `def:lfstep`'s preamble can cite the tag.
10. **Process — one sweep discipline for the recurring species.** Five of nine findings are withdrawal-not-swept. When a symbol, lemma, hypothesis or file is retired, grep the retired string across all four artifacts, including comment blocks and *retention justifications* — the last is where three of the five hid.

---

## Gate statement for Step 7

- **Gating: U-1 and A-1.** U-1 because a live proof cites two conventions that do not exist in the compilable block, one of them for a substantive inference step — this is a `\cite`-to-nowhere in the assumption layer and it should not survive into Step 7. A-1 because Step 7 and `/simulate` will size the Landweber cap from `eq:cap`, and the file currently justifies a 5×–50× inflation with a sentence that a hypothesis of the same proposition refutes.
- **Not gating, but fix in the same pass: O-1, O-2, U-2, A-2, A-3.** All are one-pass clause audits; none blocks Step 7's mathematics.
- **Explicitly cleared for Step 7:** the `lem:aerr` / `eq:gamman` / `eq:entropyA` / `eq:entropy` orphan set (honest retention), A6b's property status, (P-b)'s empty label, A8's by-clause citation, and `def:hatT`'s truncation placement.

**Files read (all absolute):**
`/Users/samuele/Documents/github_repo/clo-econometrics-author/quality_reports/theory/panel-npiv-discrete/assumptions.tex`
`/Users/samuele/Documents/github_repo/clo-econometrics-author/quality_reports/theory/panel-npiv-discrete/results.tex`
`/Users/samuele/Documents/github_repo/clo-econometrics-author/quality_reports/theory/panel-npiv-discrete/proofs.tex`
`/Users/samuele/Documents/github_repo/clo-econometrics-author/quality_reports/theory/panel-npiv-discrete/theory_memo.md`
`/Users/samuele/Documents/github_repo/clo-econometrics-author/quality_reports/theory/panel-npiv-discrete/notation_glossary.md`
`/Users/samuele/Documents/github_repo/clo-econometrics-author/quality_reports/theory/panel-npiv-discrete/proofs_partH.tex` (stale merge record — read only to locate the (H1c)/(H2c) declarations)
`/Users/samuele/Documents/github_repo/clo-econometrics-author/quality_reports/theory/panel-npiv-discrete/results_partH.tex` (stale merge record — read only to confirm the three hypothesis lists were merged verbatim)

No files were edited. Report only, per role.