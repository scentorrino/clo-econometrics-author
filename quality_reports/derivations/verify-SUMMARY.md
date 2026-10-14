# Derivation Verification — Summary, `panel-npiv-discrete` Stage 3 dispatch 1

**Harness:** `scripts/symbolic/verify.py`, `dim_check.py` · SymPy 1.14.0 · **60 specs written, 60 run.**
**Verdict: 0 genuine mismatches. 0 dimension mismatches.** (Persisted by the orchestrator; the critic is read-only.)

| # | Claim | Source | Specs | Verdict |
|---|---|---|---|---|
| 1 | Frontier equivalence + $\mu>\tfrac12$ necessity | `assumptions.tex:431–436` | 6 | **MATCH 6/6** |
| 2 | Eighteen-entry substitution table | `assumptions.tex:452–459` | 23 | **MATCH 18/18** (2 are 2-dp roundings, error $\pm1/300$) |
| 3 | `prp:frechet` constant chain, (ii)⇒(i) via FTC | `proofs.tex:91–209`, `results.tex:146–171` | 8 | **MATCH 8/8 — exact same constant** |
| 4 | `eq:kernelcompare` and the $p_X=\varrho$ iff | `results.tex:444–452`, `proofs.tex:26–42` | 4 | **MATCH 4/4** |
| 5 | Bandwidth balance and $n^{-p/(2p+d)}$ rates | `assumptions.tex:356,425,428,660,679–687` | 9 | **MATCH 9/9** |
| 6 | `prp:compact` HS norm and the $\pi$ weight | `proofs.tex:255–273` | 6 | **MATCH 4/4 algebraic; DIM CONSISTENT** |
| — | H1 link $\mu>\tfrac12\iff s>a$; A8 window $s>1$ / $s>3/2$ | `assumptions.tex:299–317,472–490` | 4 | **MATCH 4/4** |

Raw: `verify.py` 56 MATCH / 4 non-MATCH — **2 by design** (the `-printed` rounding probes exist to *measure* the rounding) and **2 harness limitations on matrix specs** (below). `dim_check.py`: 2 matrix specs, both consistent.

## The two headline checks

**The frontier and its table.** The equivalence reduces to one identity,
$$\text{LHS}-\tfrac14=\frac{2r(2\mu-1)-d_Z(2\mu+1)}{4(2\mu+1)(2r+d_Z)},$$
whose denominator is positive, so the printed $\iff$ *and* the necessity of $\mu>\tfrac12$ both fall out of one sign computation. Confirmed additionally by **200,000 random draws with 0 disagreements**. All eighteen entries recomputed **from the general formula**, not entry-against-entry. The $\mu=\infty$ row is the unattained infimum $d_Z/2$, verified via the exact decomposition $\frac{d_Z}{2}+\frac{d_Z}{2\mu-1}$ — which also proves the threshold is *decreasing* in $\mu$, i.e. the "buy $\mu$, not $r$" reading, and mechanically justifies the prohibition on writing $r>d_Z/2$. Third independent check of this table, first mechanical one.

**The constant chain — passes on the nose.** Integrating `prp:frechet`(ii) along the segment returns (i) with **exactly** $C_{\mathcal A}=2\bar c_\pi\|\bar f_1\|_\infty c_\Pi$, both sides rebuilt from primitives: Step 5 + FTC gives `2*Hn**2*cPi*cpi*f1bar`; Step 3 direct gives `2*Hn**2*cPi*cpi*f1bar`. Identical — same constant, not merely same order. The test simultaneously exercises the Taylor $\tfrac12$, the $4\bar c_\pi$ of `eq:deltahbound`, both Cauchy–Schwarz roots at $\sup_{\|h'\|\le1}$, and the factor 2 in `eq:lipschitz` being consumed exactly by $\int_0^1\varsigma\,d\varsigma=\tfrac12$.

**Two limits on that inference, stated by the critic and worth keeping:** (1) it verifies that the constants *compose*, not the analytic inputs — Cauchy–Schwarz, $|G''_\varphi|\le\|\bar f_1\|_\infty$, the shift identity, measurability of $\Delta h$ are not symbolic facts and were not tested; (2) **the FTC test is necessary, not sufficient** — an error in a *shared* input would propagate to both sides and still pass. That degeneracy is why `eq:deltahbound` was checked separately: its slack is exactly $(a+b)^2$ and the $\bar c_\pi$ accounting is one per period, both MATCH.

## Advisory findings — none is an algebra error

**1. Rounding direction in a referee-facing table.** "$r>3.33$" rounds a **strict lower bound down**: the true threshold is $10/3=3.\overline3$, so $r\in(3.33,\,3.\overline3]$ passes the printed test and **fails the frontier**. "$r>4.17$" versus $25/6=4.1\overline6$ rounds up and is conservative. Print the exact fractions ($10/3$, $25/6$) or round up ("$r>3.34$"). Magnitude 1/300.

**2. "Order 2 clears $n^{-1/4}$" is about $\hat\delta_n$, NOT about A5(iii) — and quoting it otherwise would repeat, in a new place, exactly the mistake the $r>d_Z/2$ prohibition exists to prevent.** A5(ii) requires $\delta_n=\hat\delta_n^{2\mu/(2\mu+1)}=o_P(n^{-1/4})$, and the exponent is deflated by $\frac{2\mu}{2\mu+1}<1$. Substituting $r=2$ into the frontier numerator: $d_Z=1$ gives $6\mu-5$, so **$\mu>5/6$**; $d_Z=3$ gives $2\mu-7$, so **$\mu>7/2$**. Consistent with the printed table, whose $\mu=3$ row already demands $r>2.1>2$ at $d_Z=3$. If this arithmetic is used to retire the pre-registration item, state it at the level of $\hat\delta_n$ and do the frontier check separately.

**3. $h_u\asymp n^{-1/16}$ is a bias-to-stochastic-*floor* match, not a bias–variance trade-off.** The standard balance at $p_K=8$, $d=1$ would give $n^{-1/17}$ and rate $n^{-8/17}$. The paper's exponent comes from matching bias to the $n^{-1/2}$ floor of an *unconditional* expectation — no local-averaging denominator, hence no variance term inflating as $h_u\downarrow0$. Reasoning right, arithmetic right; the guard value $1/17$ is recorded in `bandwidth-not-standard-tradeoff` **so a later editing pass does not "fix" 16 to 17.**

**4. The frontier equivalence presumes $d_Z\ge1$.** At $d_Z=0$ the right side degenerates to a vacuous "$r>0$" while the left still requires $\mu>\tfrac12$. A4(ii) defines $d_Z$ as a count of non-degenerate coordinates, so no change needed.

**5. Three harness defects — tooling, not paper. For whoever owns `scripts/symbolic/`.**
   - `verify.py` **reports MISMATCH on matrix-valued identities whose difference is `ZeroMatrix`** — `reduce_to_zero` tests `r == 0 or r.equals(0)`, both `False` for `ZeroMatrix`. A spec printing `Residual: 0` is then reported MISMATCH. Fix: a matrix-aware branch (`isinstance(r, ZeroMatrix)` or `r.as_explicit().is_zero_matrix`).
   - `verify.py` **crashes on symbolic matrix shapes** — `MatrixExpr.equals` raises `ValueError`, uncaught because `r.equals(0)` sits outside the `try` in `reduce_to_zero` (`verify.py:218`). Python exits 1, **indistinguishable from a genuine MISMATCH in a batch run.** Silent failure mode for any future matrix spec.
   - **SymPy is not installed for the repo's `python3`** (`/opt/local/bin/python3`). All runs used a throwaway venv — the single reproducibility blocker for repeating this run.

## Notable verification, beyond the primed list

**The $\pi$-weight point in `prp:compact` was verified rather than accepted.** On a finite-dimensional model of the same statement (domain $L^2(q)$, range $L^2(P)$, $(Th)_a=\sum_i\mathsf k_{ai}h_iq_i$), the matrix of $T$ in orthonormal bases is $D_P^{1/2}KD_q^{1/2}$, and $\operatorname{tr}(M^\top M)=\sum_{a,i}P_a q_i\mathsf k_{ai}^2$ — the discrete form of $\iint|\mathsf k|^2\pi\,dx\,d\Pi$. **Had the $\pi$ weight been dropped on the domain side, the $q_i$ factors would be absent. They are present.** The proof's sentence is right, and right for the reason it gives.

**`eq:kernelcompare`'s "iff" is mechanical, not asserted.** The discrepancy factorises as $(p_X-\varrho)\{(1-\varrho)f_1+\varrho f_0\}$; necessity was confirmed by solving the coefficient system, each coefficient having unique root $p_X=\varrho$ and each needing one endpoint excluded ($\varrho\neq1$, $\varrho\neq0$) — **exactly what A4(i) overlap supplies.** So the "iff" holds *under A4(i)*. Nothing in the algebra supports the struck plan §18.3 reweighting claim.

## Escalation

**None.** No claim failed symbolic verification. Findings 1–3 go to the theorist as presentational or scope precision; finding 5 to whoever owns the harness. Standing rule: MATCH verifies formal symbolic equivalence only — it does not validate analytic inputs or the relevance of an identity to the argument.

**Specs:** 40 in `scripts/symbolic/specs/`, 20 in `scripts/symbolic/specs/frontier-table/`.
