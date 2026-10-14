# Counterexample Probes — Proposition `prp-lepskii` (Lepskii oracle inequality)

**File:** `/Users/samuele/Library/CloudStorage/Dropbox/Nonparametric_IV/Volatility/Centorrino_Florens_VOL_1.qmd`
**Mode:** AUDIT-IN-PLACE. Verdicts: CAPTURED BY ASSUMPTION / FLAG MISSING CONDITION / CONFIRMED COUNTEREXAMPLE (CRITICAL).

---

## Probe 1 — Boundary $\beta \to 0^+$ (very rough deviation)

**Setup.** $\beta_n = 1/\log n \downarrow 0$; all other assumptions hold.

**Result.** $\tau_0$ and $C(\tau)=(5\tau+1)+O(\tau^{-1})$ are uniform in $\beta$ — they depend only on $(c_v, c'_v)$ which themselves depend on $(c, R^\sigma, M_1{-}M_3, m_4, \text{LF qualification})$, none of which involve $\beta$. The discussion at L624 ("for every $\beta\in(0,2]$") is not falsified by $\beta\to 0$: the *rate* $\delta_n^{\beta_\epsilon/(\beta_\epsilon+1)}$ degenerates to $\delta_n^0=O(1)$, but the *inequality* RHS is correspondingly $O(1)$ — the inequality remains true.

**Verdict:** CAPTURED BY ASSUMPTION. Minor recommendation: add a one-sentence remark that "the constants $\tau_0, C(\tau)$ are uniform in $\beta\in(0,2]$."

---

## Probe 2 — Heavy-tailed $U$ with $E[U^4]\to\infty$

**Setup.** $U\sim t_\nu$, $\nu_n\downarrow 4^+$. $m_4=E[U^4]\to\infty$.

**Result.** Assumption ass:unifbd(iv) explicitly requires $E[U^4]\le m_4<\infty$. The constants $c_v,c_v'$ in `lem-itervar` (L1180) depend on $m_4$ and explode as $m_4\to\infty$. Term $III_m$ (L1168) uses $E\|\hat e_j\|^4$ which requires fourth moments.

**Verdict:** CAPTURED BY ASSUMPTION ass:unifbd(iv). No action.

---

## Probe 3 — $f_U$ vanishing fast ($\kappa_n\to 0$): monotonicity of $V(m)$

**Setup.** $\kappa_n=n^{-c}$ with $c>0$ small enough that ass:restrvarth(ii) still holds.

**Result.** Examining $V(m)$ shows $\kappa_n$ does **not directly appear in $V(m)$** as stated in lem-itervar — $\kappa_n$ enters only Term $IV_m$ via $h_u^{-2}\kappa_n^{-1}\|\hat e_j\|$, which contributes a higher-order term suppressed by ass:restrvarth (L1168). So $\kappa_n\to 0$ does NOT directly break $V$-monotonicity.

For $\beta\in(1,2)$ the second-term exponent is $(1-\beta)/2 < 0$ (decreasing). The first-term $\delta_n\sqrt m$ ensures monotonicity for $m$ large but can fail at small $m$ when $\gamma_n\gg\delta_n$. The eq-gammadelta condition ensures asymptotic dominance but not necessarily at $m=1, 2$.

**Verdict:** CAPTURED BY ASSUMPTION (under eq-gammadelta) but **minor FLAG**: monotonicity at small $m$ not formally verified. Recommended: state explicitly that $V$ is monotone increasing under eq-gammadelta and uniformly in $\beta\in(0,2]$ at $m\ge 1$, or restrict to $m\ge m_0$.

---

## Probe 4 — Severely ill-posed binary $W$ (FI): $M_n=O(\log n)$, adaptation overhead

**Setup.** FI with $L=3$ levels (so identification holds per exm-gaussian L336), singular values $t_j\asymp e^{-sj}$, source $c_j\asymp e^{-sj\beta}$. $m^*=O(\log n)$, $M_n=O(\log n)$.

**Result.** $P(\Omega_n)\ge 1-M_n e^{-c_0\tau^2}$. Choosing $\tau\asymp\sqrt{\log M_n}=\sqrt{\log\log n}$ gives $P(\Omega_n)\ge 1-n^{-c}$. Then $C(\tau)=5\tau+1=O(\sqrt{\log\log n})$. **The discussion line 624 claims "$O(\log\log n)$" overhead — but the proof gives $O(\sqrt{\log\log n})$. Mismatch.**

Reading Step 1 carefully (L1196–1200), the proof's $C(\tau)$ is correctly $(5\tau+1)+O(\tau^{-1})$ at L1209 — no $\log(M_n/m^*)$ multiplier appears. So the correct overhead is $\sqrt{\log\log n}$, not $\log\log n$.

**Verdict:** **FLAG: EXPOSITION INCONSISTENCY** (not a counterexample). Discussion at L624 should be revised: "$C(\tau)$ scales linearly with $\tau\asymp\sqrt{\log M_n}$, yielding an adaptation overhead of $O(\sqrt{\log\log n})$ in the severely ill-posed regime."

---

## Probe 5 — Step-size violation $c\|\hat{\mathsf{T}}'_b\|^2>1$ on a non-vanishing event

**Setup.** Deterministic bound at L401–405 controls the *population* operator. Estimated operator satisfies $\|\hat{\mathsf{T}}'^*_b\hat{\mathsf{T}}'_b-\mathsf{T}'^*_b\mathsf{T}'_b\|=O_p(\gamma_n)$. On the event $E_n=\{c\|\hat{\mathsf{T}}'_b\|^2>1\}$, the LF iteration is non-contractive.

**Result.** lem-app3 (L1236–1241) is stated under $c\|T\|^2\le 1$ in expectation/probability through $N^{1/2}\gamma_n\asymp 1$. So $P(E_n)\to 0$ at rate $\gamma_n$. The proof at L1209 says iterates are "bounded a priori by Assumption ass:restrvarth" but $\Omega_n$ controls closeness $\|\hat b'_m - b'_m\|$, not $\|\hat{\mathsf{T}}'_b\|$. ass:restrvarth controls $N$ and $\delta_n,\gamma_n$ but not tail behavior of $\hat b'_m$ on the event-of-failure.

**Verdict:** **FLAG MISSING CONDITION.** Off-$\Omega_n$ bookkeeping at L1209 is loose. Standard fix: explicit truncation or restriction to $\{\|\hat{\mathsf{T}}'_b\|^2\le 1/c\}$ — implicit in ass:rateconv combined with the Hilbert-Schmidt bound, but should be cited.

---

## Probe 6 — Non-iid sample (autoregressive empirical application)

**Setup.** sec-empapp-rates (L830) applies the MI estimator to monthly T-bill rates with $U_t=\rho U_{t-1}+\varepsilon_t$. Sample is $\beta$-mixing, not iid. Take $\rho=0.95$ (near-unit-root).

**Result.** L343: "We observe an **i.i.d. sample**." ass:rateconv's continuous-$W$ rates $\delta_n^2=O((nh_w^q)^{-1}+h_w^{2\rho})$ are iid Nadaraya–Watson rates. Under $\beta$-mixing with summable mixing coefficients (Hansen 2008, already cited at L505), the same rates hold up to constants. Under near-unit-root $\rho\to 1$, mixing coefficients decay slowly and rate constants explode.

**Verdict:** **FLAG MISSING CONDITION.** Theorem stated under iid (L343), applied to time series in sec-empapp-rates without bridging. Recommended: add one-line extension in sec-empapp-rates stating that ass:rateconv and lem-itervar continue to hold under exponential $\beta$-mixing (citing Hansen 2008), or note in the relevant theorem statement "iid or geometrically $\beta$-mixing". **Scope limitation, not a CRITICAL.**

---

## Probe 7 — Step 1 breaks if $V$ non-monotone

**Setup.** $\beta=1.5$, $\gamma_n=n^{-1/4}$, $\delta_n=n^{-1/2}$. Then $V(m)=\delta_n\sqrt m + \gamma_n m^{-0.25}$. Derivative zero at $m=(0.5\gamma_n/\delta_n)^{4/3}\approx 1.83$ for $n=100$.

**Result.** $V$ has a local minimum at $m\approx 2$, decreasing from $m=1$ to $m=2$, then increasing. Step 1 of the proof (L1200) uses $V(m^*)\le V(k)$ for $k>m^*$. If $m^*$ ends up at or above the local minimum, $V$ is monotone increasing for $k>m^*$ — Step 1 still works. But the *literal claim* "$V$ monotone increasing in $m$" at L1188 is false at small $m$.

**Verdict:** **FLAG: OVERSTATED CLAIM.** Recommended: weaken to "$V$ is eventually monotone increasing in $m$, and in particular $V(m^*)\le V(k)$ for all $k>m^*$ under eq-gammadelta."

---

## Probe 8 — $M_n$ fixed; oracle truncated

**Setup.** $M_n=100$ fixed independently of $n$. Optimal $N\asymp\delta_n^{-2/(\beta_\epsilon+1)}$ which diverges with $n$.

**Result.** Infimum at eq-lepskiioracle is over $m\le M_n$. If $M_n$ fixed but the bias-variance-minimal $m$ is $\gg M_n$, the "oracle" $\inf_{m\le M_n}[B(m)+V(m)]$ is far from $\inf_m[B(m)+V(m)]$. **The theorem is still technically true** but the discussion's rate-adaptivity claim (L622) requires $M_n\to\infty$ at a rate that allows $M_n\ge m^*$.

No explicit growth condition on $M_n$ stated outside ass:restrvarth which constrains $N$ via $\delta_n N=O(1)$ (so $N=O(\delta_n^{-1})$, which diverges). $M_n$ growth is presumably $M_n=N$.

**Verdict:** **FLAG MISSING CONDITION.** Add explicitly: "$M_n\to\infty$ with $n$ at a rate such that $m^*(n)\le M_n$ for all $n$ sufficiently large; in practice $M_n\asymp N\asymp\delta_n^{-1}$ suffices."

---

## Probe 9 — $C(\tau)$ explodes; adaptation overhead $\sqrt{\log M_n}$ vs $\log\log n$

**Setup.** Re-examine L1209: $C(\tau):=(5\tau+1)+O(\tau^{-1})$ with $\tau\asymp\sqrt{\log M_n}$ at L1194.

**Result.** $C(\tau)\asymp\sqrt{\log M_n}$. If $M_n\asymp\delta_n^{-1}\asymp n^c$, overhead is $\sqrt{\log n}$. In severely ill-posed regime $M_n=O(\log n)$ and overhead is $\sqrt{\log\log n}$. Neither matches the discussion's claimed $O(\log\log n)$ at L624.

**Verdict:** **FLAG: EXPOSITION ERROR (duplicate of Probe 4).** Mildly ill-posed: $\sqrt{\log n}$. Severely ill-posed: $\sqrt{\log\log n}$.

---

## Probe 10 — $\rho(W)\nu(W)=0$ on positive-measure subset (continuous $W$, MI route)

**Setup.** Define $\rho(w)\nu(w)=0$ for $w\in[0,1/2]$ and $=w-1/2$ for $w\in(1/2,1]$.

**Result.** On $\{w: \rho(w)\nu(w)\ne 0\}$ of measure 1/2, the modified Mehler at L326 has $(\rho\nu, \nu^2)$ varying continuously over a 2D set. The Hermite-mode argument forces all coefficients to zero. Identification holds.

**Verdict:** CAPTURED BY ASSUMPTION ass:condcomp (subsumes the two-dimensional-set requirement; see L326). No counterexample.

---

## Summary table

| Probe | Topic | Verdict | Severity | Recommended action |
|-------|-------|---------|----------|-----|
| 1 | $\beta\to 0^+$ | CAPTURED | none | Remark: $C(\tau),\tau_0$ uniform in $\beta\in(0,2]$ |
| 2 | Heavy-tailed $U$, $E[U^4]=\infty$ | CAPTURED | none | None — ass:unifbd(iv) handles it |
| 3 | $\kappa_n\to 0$, V-monotonicity | CAPTURED (minor flag) | minor | Verify monotonicity uniformly in $\beta$ |
| 4 | Severely ill-posed binary $W$, overhead | **FLAG: exposition** | medium | Reconcile L624 with L1209: overhead is $\sqrt{\log\log n}$ |
| 5 | Step-size $c\|\hat T\|^2>1$ event | **FLAG: unstated regularity** | medium | Explicit truncation / operator-norm convergence event |
| 6 | Non-iid (time series application) | **FLAG: scope gap** | medium | Bridge iid (L343) to $\beta$-mixing for sec-empapp-rates |
| 7 | V non-monotone at small $m$ | **FLAG: overstated claim** | minor | Weaken "V monotone increasing" at L1188 |
| 8 | $M_n$ growth not specified | **FLAG: missing condition** | medium | Add $M_n\to\infty$ at rate $\ge m^*(n)$ |
| 9 | Adaptation overhead exposition | **FLAG (= Probe 4)** | subsumed | See Probe 4 |
| 10 | $\rho\nu=0$ on positive-measure set | CAPTURED | none | None |

## Final verdict

**No CONFIRMED COUNTEREXAMPLE.** The theorem as stated is true under its assumptions. Score on this axis: **70/100** — full marks would require zero unstated assumptions; 4 minor-to-medium unstated conditions or exposition issues, none breaks the theorem.

Major findings are all **exposition / unstated regularity**, not logical errors. None is a CRITICAL escalation. Theorist should consider a short "regularity remark" block after prp-lepskii covering Probes 4–6, 8, and reconciling L624 with L1209.
