# Regularity Audit — Proposition `prp:lepskii` (Post-Round-3)

**Files audited:** `quality_reports/theory/volatility-loc-scale/{proofs.tex, results.tex, assumptions.tex}`.
**Prior audit:** `regularity-audit_lepskii.md` (13 items: 2 CRITICAL + 6 MAJOR + 5 MINOR).

## Section 1: Per-concern table (fresh scan)

| # | Concern | Site | Verdict | Patch |
|---|---|---|---|---|
| R1 | Tonelli/Fubini citation for finite sum $E\|III_m\|^2 \le \sum_j$ | results L278–307; proofs L63–76 | FLAG (MINOR) | Cite Tonelli for non-negative summation. |
| R2 | Conditional-vs-unconditional Cauchy–Schwarz at `R^{(2)}_{m,j}` absorption | results L540–560; proofs L231–240 | FLAG (MAJOR) | Use $E[XY\mathbf 1_E] \le (EX^2)^{1/2}(EY^2\mathbf 1_E)^{1/2}$ on $\Omega_n \cap \Omega'_n$. |
| R3 | Commutation of $\mathsf L_{b_\dagger}$ with $\hat{\mathsf T}'^*_{b_\dagger}\hat{\mathsf T}'_{b_\dagger}$ "to leading order" | results L173–178 | **FLAG (CRITICAL)** | Either spectral-algebra assumption or replace commutation with direct operator-norm bound. |
| R4 | `rem:hyper` proxy-variance scaling near-circular | assumptions L93–112 | FLAG (MAJOR) | Make proxy-variance scaling explicit; break circularity. |
| R5 | $\tau$-inflation in $c_v$ via $III_m$ absorption | results L406–417; proofs L131–135 | FLAG (MAJOR) | Make $c_v(\tau)$ explicit; verify fixed-point $\tau_n = \sqrt{(1+\kappa)c_0(\tau_n)^{-1}\log M_n}$. |
| R6 | $L^\infty$ neighborhood for $\Phi''$ at Step 5 | results L656–680; proofs L314–326 | FLAG (MAJOR) | State $\mathcal B_{b_\dagger}$ as $L^\infty$ ball via Sobolev embedding. |
| R7 | Lipschitz of population $\mathsf T$ on $\mathcal B_{b_\dagger}$ | results L386–389 | FLAG (MINOR) | Cite `ass:app1to3` + `ass:unifbd`(iii) or strengthen `ass:frediff`. |
| R8 | Random-index $L^4$ bookkeeping at $\hat m$ | proofs L268–275; results L599–606 | FLAG (MINOR) | One-line argument $E\|\hat b'_{\hat m}\|^4 \le \sum_m E\|\hat b'_m\|^4$. |
| R9 | $I_m$ tail uniform in $m$ | results L420–429; proofs L138–141 | FLAG (MINOR) | State $\sup_m m\gamma_n = M_n\gamma_n = o(1)$. |
| R10 | `lem:itervar` used uniform-in-$j$ for induction hypothesis | proofs L51–52, L69–71 | FLAG (MAJOR) | Restate `lem:itervar` with "for all $m \le M_n$" or supply maximal inequality. |
| R11 | $\tau_n \ge \tau_0 = 2$ for small $n$ | proofs L155–160, L188 | FLAG (MINOR) | Restrict $\kappa$ so $\tau_n \ge 2$ for $n \ge n_0$. |
| R12 | Measurability of $\sup_{b \in \mathcal B_{b_\dagger}} \|\Phi''(b)\|$ | proofs L320, L324 | FLAG (MINOR) | State deterministic OR invoke separability. |

## Section 2: Cross-reference with prior audit

| Prior # | Concern | Status post-R3 |
|---|---|---|
| 1 | Propagator substitution | CLOSED (PATCH-M1) |
| 2 | Empirical-operator step-size | CLOSED ($\Omega'_n$, PATCH-M2) |
| 3 | Sub-exponential concentration (CRITICAL) | **CLOSED** (PATCH-CR1) |
| 4 | $\log\log n$ overhead | CLOSED (PATCH-M3) |
| 5 | Off-$\Omega_n$ a-priori (CRITICAL) | **CLOSED** (PATCH-CR2) |
| 6 | $V$ monotonicity | CLOSED ($\tilde V$, PATCH-M4) |
| 7 | Bias monotonicity | CAPTURED |
| 8 | Uniform-in-$m$ wording | PARTIALLY CLOSED (R10 re-flag) |
| 9 | $\|\varphi_\dagger\|_\infty$ | CLOSED (PATCH-M5) |
| 10 | $\Phi''$ on $L^\infty$ neighborhood | PARTIALLY CLOSED (R6 re-flag) |
| A | $\hat M$ random | CLOSED (PATCH-MN6) |
| B | MI $\beta_\epsilon = \beta$ | CLOSED (PATCH-MN5) |
| C | $L^8$ moments | CLOSED (PATCH-M6 + (iv); R4 re-flag) |

**Summary:** 10 of 13 prior concerns closed cleanly; 3 partially closed.

## Section 3: New regularity concerns introduced by Round-3 additions

1. **Commutation of $\mathsf L_{b_\dagger}$ and $\hat{\mathsf T}'^*_{b_\dagger}\hat{\mathsf T}'_{b_\dagger}$** (R3) — **CRITICAL** new gap from PATCH-R3-G2-b.
2. **Proxy-variance scaling in `rem:hyper`** (R4) — MAJOR; near-circular with the induction it supports.
3. **Measurability of $\sup \|\Phi''(b)\|$** (R12) — MINOR.
4. **Random-index $L^4$ bookkeeping at $\hat m$** (R8) — MINOR.
5. **$\tau$-inflation in $c_v$** (R5) — MAJOR.

## Section 4: Score

| Item | Severity | Deduction |
|---|---|---|
| R3 — commutation (NEW CRITICAL) | -15 | -15 |
| R2, R4, R5, R6, R10 — 5 MAJOR | -10 each | -50 |
| R1, R7, R8, R9, R11, R12 — 6 MINOR | -3 each | -18 |

**Score: 100 − 83 = 17 / 100** (floored at 0).

## Section 5: Verdict

The regularity scaffolding of `prp:lepskii` post-Round-3 is partially sound: 10 of 13 prior concerns closed cleanly via the named patches, and 3 are partially closed in ways that re-emerge as MAJOR items. The Round-3 additions address the central gap (linear-residual non-absorption at the Round-1/-2 horizon) but introduce a new CRITICAL: the *commutation* of the second-derivative operator $\mathsf L_{b_\dagger}$ with the empirical Gram operator $\hat{\mathsf T}'^*_{b_\dagger}\hat{\mathsf T}'_{b_\dagger}$ asserted "to leading order on $\mathcal B_{b_\dagger}$" (results L173–178) is a non-trivial structural Hilbert-space property not delivered by any assumption. Two further MAJOR items are direct consequences of Round-3 patches: (i) the proxy-variance scaling in `rem:hyper` is near-circular with the induction it supports; (ii) absorbing the $III_m$ contribution into $c_v$ creates implicit $\tau$-dependence that the union-bound choice $\tau_n$ chases without a fixed-point check. A third MAJOR — $L^\infty$-vs-$L^2$ neighborhood for $\Phi''$ — is a partially-closed regression of prior #10. The headline regression — that the two prior CRITICAL gates (sub-Gaussian concentration, off-event a-priori bound) are now cleanly closed — is the right one to emphasize. But the commutation gap (R3) is the single highest-priority item for any next round.
