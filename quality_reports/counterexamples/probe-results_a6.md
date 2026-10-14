# Counterexample Probes — the two A6 boundary questions, `panel-npiv-discrete`

**Critic:** counterexample-hunter (read-only; persisted by the orchestrator) · **2026-07-29**
**Scope:** two questions only, set by the dispatch-7 critic. **Explicitly NOT a gate** — `prp:tccfails` was already verified end to end by the theorist-critic, and neither outcome changes the disposition (A6 leaves the maintained block either way).
**Read:** `results.tex` Part H (L2140–2880), `proofs.tex` (L2860–3410), `assumptions.tex` (A4 L1125, A8 L1414, A6 L1495, C5′ L1681).

## VERDICT: **no confirmed counterexample on either question.**

- **Q1 is a formality**, not a caveat — with one genuine downstream consequence the file does not name.
- **Q2 is a real scope limitation.** `prp:tccfails` **does not survive restriction to $\mathcal S_n$**, and A6-on-the-sieve is **neither refuted nor established** — its truth turns on $h_xL_x$, which **no assumption in the block constrains**, and the block's own admissible window contains both regimes **at a single frontier-clearing configuration.**

---

## Question 1 — the degenerate event $\{\widehat{\widetilde W}_i=0\ \forall i\in\mathcal I_{\rm m}\}$

### Probe 1.1 — Is $(1-\varepsilon_\varrho)^{n_{\rm m}}$ right? **Yes, and conservative. Probe fails — captured by A4(i)+A4(iii).**
A4(iii) requires $\hat\varrho$ on an auxiliary fold, so $\hat\varrho\perp\mathcal I_{\rm m}$ and
$$P(\widehat{\widetilde W}_i=0\mid\hat\varrho)\le(1-\varepsilon_\varrho)P(\Delta Z\in\mathcal E),\quad \mathcal E:=\{z:\hat\varrho(z)\in\{0,1\}\}.$$
A4(iii) further bounds $P(\Delta Z\in\mathcal E)\le\varepsilon_\varrho^{-2}\|\hat\varrho-\varrho\|^2_{L^2}=O_P(r_n^2/\varepsilon_\varrho^2)$, sharpening the bound by a factor $(r_n^2/\varepsilon_\varrho^2)^{n_{\rm m}}$. The crude bound holds always and needs nothing beyond A4(i) + cross-fitting.

### Probe 1.2 — Can a realistic first stage make it material? **No. Probe fails.**
Four adversarial constructions tried: 2-term LPM exiting $[0,1]$ on a large region; 1-NN / interpolating cell estimator; discrete $\Delta Z$ with a rare cell $p_{0,n}$ calibrated to keep A4(iii); small fold ($n_{\rm m}=100$, $\varepsilon_\varrho=0.02$).

**None works, and the reason is structural: the bound is invariant to the first-stage construction.** It uses only (i) $\hat\varrho\perp\mathcal I_{\rm m}$, (ii) overlap, (iii) iid within the main fold — **not smoothness, not the number of series terms, not the regularisation.** Making the event material needs $\|\hat\varrho-\varrho\|_{L^2}\gtrsim\varepsilon_\varrho$, a **fixed constant**, which breaks A4(iii) outright. The rare-cell device buys nothing because the event must hold **simultaneously** at all $n_{\rm m}$ points. At a realistic $\varepsilon_\varrho=0.05$, $n_{\rm m}=200$ the bound is $3.5\times10^{-5}$.

**Answer to Q1: a formality, not a caveat. The paper owes no caveat.**

### Probe 1.3 — What the "probability one" actually leans on [SCOPE NOTE — one clause owed]
Drop **cross-fitting only** and estimate $\hat\varrho$ on the full sample by any interpolating rule (1-NN, saturated cell, kernel with $h\to0$ faster than design spacing), with $\Delta Z$ continuous. Then $\hat\varrho(\Delta Z_i)=W_i$ for every $i$ **with probability one**, so $\hat T\equiv0$, $\hat{\mathcal A}\equiv0$, A6 holds trivially, and **`prp:tccfails` is false with probability one — not on a null set.**

Captured by A4(iii)'s auxiliary-fold clause, which `def:hatTexp` invokes. **But the refutation's "probability one" rests on cross-fitting, not only on overlap**, and `prp:tccfails`'s own hypothesis list does not say so. One subordinate clause closes it.

### Probe 1.4 — **THE REAL FINDING: $\mathbf G_n$ is singular, and it is the PARTIAL event, not the all-zero event**
For any first stage whose raw values exit $[0,1]$ on a set of $\Delta Z$-measure $\asymp r_n^2$ — **any series LPM** — the expected number of main-fold observations with $\widehat{\widetilde W}_i=0$ is $\asymp n_{\rm m}r_n^2=n^{1-2\alpha}$, which **diverges for every $\alpha<\tfrac12$.**

$\widehat{\widetilde W}_i=0$ makes $\hat g_{u,t,i}\equiv0$ (`eq:hatg` carries it as a factor), so row and column $i$ of $\mathbf G_n$ vanish and $\lambda_{\min}(\mathbf G_n)=0$. **With probability NOT tending to zero:**
- `prp:tccrepair`(ii)'s "$\mathbf G_n$ nonsingular" hypothesis **fails**;
- `eq:tccrad` returns $\bar\rho_n=0$, so **A6b's explicit radius is vacuous** and `prp:tccrepair`(ii) — the file's sole demonstration that A6b is non-vacuous — **has no content on that event**;
- `prp:tccrepair`(iii)'s injectivity modulus is $0$.

**Captured by no stated assumption. A real gap, small, and it sits in the repair rather than the refutation** — created by exactly the $[0,1]$ truncation convention Q1 asks about.

**The planned fix does more work than the memo credits.** With $W_i\in\{0,1\}$ and $\hat\varrho\in[\varepsilon_\varrho,1-\varepsilon_\varrho]$:
$$|\widehat{\widetilde W}_i|=|W_i-\hat\varrho(\Delta Z_i)|\ \ge\ \varepsilon_\varrho\ >\ 0\qquad\text{for every }i,\ \textbf{deterministically.}$$
So it (i) makes `prp:tccfails`'s "with probability one" **literally true with no exception event at all** — the a.s. qualifier then covers only distinctness of the $X_{ij}$ — and (ii) **removes the deterministic source of singularity in $\mathbf G_n$, restoring `prp:tccrepair`(ii)**. It does not guarantee $\lambda_{\min}>0$ (near-collinear $\hat g_i$ remain possible). A4(iii) is preserved by the same non-expansiveness argument, since A4(i) puts $\varrho$ inside the interval.

---

## Question 2 — does A6 survive on the sieve?

### Probe 2.1 — Transplanting the spike into $\mathcal S_n$: **fails, for a STRONGER reason than the inverse inequality**
The proof needs the spike's support to contain no design point but $X_{i^\ast2}$. On $\mathcal S_n$ the narrowest representable feature has width $\asymp L_x^{-1}$ (A8 quasi-uniform mesh) while design spacing is $\asymp n^{-1}$; A8 caps $L_x\ll n^{1/2}$, so **every sieve feature contains $\asymp n/L_x\gg n^{1/2}\to\infty$ design points.**

**The spike is not merely damped by $\|\zeta\|_\infty\le\mathsf c_{11}L_x^{1/2}\|\zeta\|_{L^2(\pi)}$ — it is not representable at all, by a margin of $n/L_x$.** The single-point isolation Steps 1–2 depend on is unavailable in $\mathcal S_n$ for any $L_x$ satisfying A8.

### Probe 2.2 — The exact necessary condition, and what it is a condition *on*
Take $\varphi=\tilde\varphi+cv_0$ with $c\downarrow0$ at $\tilde\varphi=0\in\mathcal S_n\cap\mathcal V$ (legitimate: $\mathcal V$ is linear, `proofs.tex:394`; `lem:pathcont` takes $\bar\rho,\mathsf R$ fixed and large). Both base points coincide, so `eq:gateaux` and `eq:hatAcon` use identical $\hat g_{\cdot,\cdot,i}$ and differ only in the coefficient vector. With $\Gamma a:=n_{\rm m}^{-1}\sum_i\hat g_{\cdot,\cdot,i}a_i$, the remainder is $O(c^2)$ while both first-order terms are $O(c)$:

> **A6 on $\mathcal V_n\cap\mathcal S_n$ at level $\eta_{\rm TCC}$ holds only if**
> $$\sup_{v\in\mathcal S_n\setminus\{0\}}\frac{\|\Gamma(\Delta v-\Delta_{h_x}v)\|_{L^2(\Pi)}}{\|\Gamma\Delta v\|_{L^2(\Pi)}}\ \le\ \eta_{\rm TCC}.\qquad(\star)$$

**Two structural readings the paper should print if it goes this route:**
1. **($\star$) is a first-order condition, not a curvature condition** — the quadratic remainder `eq:hatTxrem` has been scaled away. So A6-on-the-sieve is **not "the tangential cone condition, restricted"** but *the requirement that $x$-smoothing at bandwidth $h_x$ act as a near-identity on $\mathcal S_n$, in the $\Gamma$-seminorm.* **`rem:tccwhy`'s "the defect is in the pairing, not in the constant and not in the radius" survives verbatim** — what changes is that the pairing defect becomes **finite** instead of infinite.
2. **Shrinking $\bar\rho$ still does not help**, exactly as `rem:tccwhy` says. **What helps is $h_xL_x$.**

Since $\eta_{\rm TCC}<\tfrac12$, it suffices for a violation to exhibit one $v\in\mathcal S_n$ with $\|\Gamma\Delta_{h_x}v\|<\tfrac12\|\Gamma\Delta v\|$.

### Probe 2.3 — The single B-spline bump: **regime-dependent, not confirmable**
$v_0:=b_{\ell_0}-(\int b_{\ell_0}d\pi)\sum_\ell b_\ell$ — the correction is exactly annihilated by both $\Delta$ and $\Delta_{h_x}$, by the partition of unity and `lem:intker`(iv)'s exact normalisation. $b_{\ell_0}$ is **the extremal for `lem:unifop`(3d)**, so the inverse inequality is tight in this direction.

With $w\asymp L_x^{-1}$ the support width:
- $h_x\gg w$: $\|\Delta_{h_x}v_0\|_2/\|\Delta v_0\|_2\asymp(h_xL_x)^{-1/2}\to0$;
- $h_x\ll w$: relative discrepancy $O(h_xL_x)\to0$ by Markov's inequality for splines.

**So the mechanism survives in weakened, quantified form — raw and smoothed responses separate by exactly $(h_xL_x)^{1/2}$.**

**Where it cannot be closed:** ($\star$) is a ratio of $\Gamma$-seminorms; converting via $\lambda_{\min},\lambda_{\max}$ makes the violation condition $h_xL_x>\mathsf c\,\kappa(\mathbf G_n)$, and $\kappa(\mathbf G_n)$ **is the empirical ill-posedness and is controlled nowhere in the block.** Three routes around it, all dead: exact null direction of $\Delta_{h_x}$ on $\mathcal S_n$ ($\ker=\{0\}$ generically, since $L_x\ll n^{1/2}\ll n_{\rm m}$); exact null direction of $\Gamma$ (needs $\operatorname{rank}\mathbf G_n<L_x-1$, but rank is $n_{\rm m}$ generically once every $\widehat{\widetilde W}_i\ne0$ — **which is what the Q1 fix delivers**); order-$p_K$ kernel zeros ($p_K=8$, sharper than the bump but the same regime, and still needs the $\Gamma$-conversion).

### Probe 2.4 — **Is the failure regime inside the block's own window? YES, at a single frontier-clearing configuration**
Constraints collected: A8 ($n^{1/(2s)}\ll L_x\ll n^{1/2}$); `eq:entropysieve` ($L_x\ln n=o(n^{1-2\alpha})$); (P-c) ($L_x\gtrsim n^{\alpha/s}$); C5′(ii) ($h_x\gg n^{-13/32}\sqrt{\ln n}$ at $h_u\asymp n^{-1/16}$); `lem:unifop` Step 4 ($h_x\lesssim n^{-\alpha/(s-1/2)}$).

At $(\mu,s,a,\alpha)=(2,3,0.75,0.32)$ — `eq:frontier` clears at $0.256>\tfrac14$ ✓, `eq:entropy` clears ✓, mild ill-posedness ✓, H1's $\mu=s/(2a)$ ✓ — we get $h_x\in(n^{-0.406},n^{-0.128})$, $L_x\in(n^{0.167},n^{0.36})$, hence $h_xL_x\in(n^{-0.24},n^{0.23})$:

| tuning | $h_x$ | $L_x$ | $h_xL_x$ | verdict on ($\star$) |
|---|---|---|---|---|
| A | $n^{-0.39}$ | $n^{0.18}$ | $n^{-0.21}\to0$ | discrepancy $O(h_xL_x)\to0$; A6-on-sieve plausible |
| B | $n^{-0.15}$ | $n^{0.34}$ | $n^{0.19}\to\infty$ | bump loses $n^{-0.095}$ of $\ell_2$ energy; presumptively fails |

**Two admissible tunings at the same $(\mu,s,a,r,d_Z)$, opposite verdicts.** A6-on-the-sieve is **neither refuted nor established**, and its truth depends on a bandwidth-to-knot-spacing ratio **no assumption constrains** — C5′ places no upper bound on $h_x$ at all (`assumptions.tex:1685`), A8 no joint restriction with it.

**What A6-on-the-sieve would require:** a **new joint budget line $h_xL_x=O(\eta_{\rm TCC})$** — *"the $x$-bandwidth may not be coarser than the knot spacing"* — **plus** a conditioning bound on $\mathbf G_n$ restricted to $\Delta\mathcal S_n+\Delta_{h_x}\mathcal S_n$. **Plausible?** Partly: at the *lower* end of the sieve window it is automatic ($h_xL_x\lesssim n^{-\alpha[1/(s-1/2)-1/s]}\to0$ free). The general cost is $\alpha(\frac{4\mu}{2\mu+1}-\frac1s)\ge\frac1{16}$, satisfied at $(2,3,0.32)$ and $(1,3,0.375)$ — a real but typically non-binding line. **The conditioning half is NOT plausible in the same sense** — it is the same $\lambda_{\min}(\mathbf G_n)$ object `prp:tccrepair`(iii) already declines to bound.

### Probe 2.5 — What the sieve restriction costs independently of ($\star$)
Even granting A6-on-$\mathcal S_n$, the referee's route is **projected** nonlinear Landweber. `def:lfstep`(b) projects onto $\mathcal S_n$; **projection does not commute with the nonlinear $\hat T$**, so the Hanke–Neubauer–Scherzer theorem does not apply as-is — it needs the cone condition on a ball in the **ambient** space containing $x^\dagger$, and $\vdagger\notin\mathcal S_n$. The restriction therefore also **moves the target to $\Pi_{\mathcal S_n}\vdagger$** and obliges a re-derivation for regularisation-by-projection-plus-iteration. `rem:lfnonlinear`(b) books "a sieve" as given up, **but against `lem:srctransfer`(iii)'s link condition rather than against the validity of the cited theorem.**

---

## Bottom line

**Q1 — a formality.** $(1-\varepsilon_\varrho)^{n_{\rm m}}$ is correct, conservative and **invariant to the first-stage construction**; no admissible first stage makes it material at practical $n$. **Two things are owed:** the auxiliary-fold clause inside `prp:tccfails`'s own hypotheses (the "probability one" leans on cross-fitting, not only overlap), and recognition that the **partial** event is **not** negligible and vacates `prp:tccrepair`(ii). **The planned $[\varepsilon_\varrho,1-\varepsilon_\varrho]$ truncation fixes both, deterministically, at no cost to A4(iii).**

**Q2 — a real scope limitation.** `prp:tccfails` **does not survive restriction to $\mathcal S_n$** (the spike is not representable, by a margin of $n/L_x$). No sieve counterexample confirmed: the tight extremal reproduces the mechanism with separation $(h_xL_x)^{1/2}$, but the conversion needs an ill-posedness bound the block declines to supply. **A6-on-the-sieve is a genuinely open, tuning-dependent condition**, and the block's own window contains both regimes at one frontier-clearing configuration.

> **For the paper's positioning: the file currently asserts reason (1) — the cone condition is false — as if unconditional, and on the sieve, which is where `def:lfstep` actually lives, it is not. The weight should shift to reason (3), saturation at $\mu=\tfrac12$, which is regime-independent, with (1) restated as "false on $\mathcal V$, and on $\mathcal S_n$ contingent on $h_xL_x$."**

**For `/simulate`:** CP-8 already reports $\lambda_{\min}(\mathbf G_n)$; it should also report the ($\star$) supremum over $\{b_\ell\}$, a direct $L_x$-term maximisation, and the numerical rank of $\mathbf G_n$ against $L_x$.

**One line outside scope, as instructed:** (P-d) cites `eq:entropy` while `lem:unifop` states that `def:lfstep` consumes clause (b) under `eq:entropysieve` — **and clause (b) is the one deliberately built to avoid the unpinned (F-e).** If (P-d) is meant to be the sieve version it cites the wrong condition and carries an unnecessary restriction. *(Independently reproduces dispatch-7 finding 2.8.)*
