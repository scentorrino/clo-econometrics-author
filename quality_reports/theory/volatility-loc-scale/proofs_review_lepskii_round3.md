# Round-3 Theorist-Critic Review: `prp:lepskii` (FINAL)

**Target:** `quality_reports/theory/volatility-loc-scale/{results.tex, proofs.tex, assumptions.tex, notation_glossary.md}`
**Severity:** HIGH (Execution phase)
**Round:** 3 of 3 (FINAL — no Round 4)
**Trajectory:** R1 = 62 → R2 = 39 (regression) → R3 = 69

---

## Per-fix verification table

| Fix ID | Site | What was promised | Verified? | Notes |
|---|---|---|---|---|
| R3-G2-a | `ass:frediff`(ii), `assumptions.tex` L35–54 | $C^2$ Fréchet hypothesis with quadratic remainder $\le L'_{\mathsf T}\|b-b'\|^2$ | YES | $\mathsf L_{b'}$ stated rigorously, uniform on $\Omega'_n$. |
| R3-G2-b | `lem:propagator`, `results.tex` L153–193 | Quadratic-remainder substitution into telescoping identity | PARTIAL | Substitution asserted via unproved commutation claim. See F1. |
| R3-G2-c | Step 3, `results.tex` L523–585 | Absorption $\delta_n^2 m^2 V(m)^2 = o(1)$ at $m = M_n$ | YES | $\delta_n^2 \cdot \delta_n^{-2} \cdot \delta_n = \delta_n = o(1)$. ✓ |
| R3-G2-d | `ass:mn-growth`, `assumptions.tex` L204–210 | $M_n = O(\delta_n^{-1})$ | YES | Updated consistently. |
| R3-G2-e | `rem:scope` | Scope restriction $\beta_\epsilon \ge 1$ documented | IN REMARK ONLY | Not embedded in proposition. See F2. |
| R3-G3 | `ass:rateconv`(iv) + consumption sites | Moment-equivalence at $q = 2$ | YES | Backwards Jensen replaced. |
| R3-G1-III | `results.tex` L395–418 | $\sqrt m$ factor added; absorbed at order $V(m)$ | YES | Bookkeeping of $\tau$-dependence loose. See F5. |
| R3-CITE | Multiple sites | `\citet[Theorem~2]{hansen2008}` | YES | Consistent. |
| MN10 dedup | proofs.tex L243 | Duplicate removed | YES | Single marker. |

---

## Phase 1 — Claim Identification

Body of `prp:lepskii` (results.tex L200–219) unchanged. The narrowing to $\beta_\epsilon \ge 1$ lives exclusively in `rem:scope` (assumptions.tex L212–236), reinforced by a parenthetical "scope reminder" inside Step 3.

**Status of the formal claim.** The inequality \eqref{eq:lepskiioracle} still holds for all $\beta_\epsilon$ — the inf over $m \in [1, M_n]$ is well-defined. What changes is the *interpretation* of $m^*$: for $\beta_\epsilon < 1$, $m^*$ binds at $M_n$ and the RHS becomes $C(\tau)\tilde V(M_n)$, a truncated oracle. The bound is true but the rate is strictly slower than the unconstrained oracle.

**F2 (MAJOR scope concession).** The proposition should carry at minimum a `(cf. Remark~\ref{rem:scope})` parenthetical, or split into two corollaries (rate-adaptive for $\beta_\epsilon \ge 1$; rate-truncated otherwise). As written, a reader of the proposition alone would think Lepskii adapts over all $\beta \in (0, 2]$, contradicted by `rem:scope`. The substantive scope reduction relative to the source paper is real and should be visible at the claim level. **Deduction: -8.**

---

## Phase 2 — Proof Validity

### F1 (MAJOR) — `lem:propagator` quadratic-residual derivation incomplete

results.tex L166–187 introduces $R^{(2)}_{m,j}$ via a hand-wave: after substituting the second-order Taylor expansion into the telescoping identity, the theorist says the leading first-order term "can be folded into a modified propagator $\tilde P^{\dagger}_{m,j}$" and that "$\mathsf{L}_{b_\dagger}$ commutes with $\hat{\mathsf T}'^{*}_{b_\dagger}\hat{\mathsf T}'_{b_\dagger}$ to leading order on $\mathcal B_{b_\dagger}$." The commutation is asserted, not proved.

If commutation fails, the first-order part does not telescope cleanly, and the linear-in-$\hat e_k$ residual survives. At the tightened horizon, the linear residual closes too: $\sum_k \|\hat e_k\| \le m \cdot O(V(m))$, multiplied by $\delta_n$ in Cauchy-Schwarz gives $\delta_n^2 m^2 V(m)^2 = O(\delta_n)$ at $m = M_n$. So the residual likely absorbs even without commutation — but the proof doesn't show this. The displayed argument is incomplete; either commutation needs proof or the linear residual needs its own absorption bookkeeping. **Deduction: -10.**

### F3 (MAJOR) — `rem:hyper` justification chain fragile; citations misaligned

Hypercontractive moment-equivalence in `ass:rateconv`(iv) is honestly stated as an *assumption*. But cited references are off-target:
- **Hanson (1971)** is for quadratic forms of sub-Gaussian vectors — mismatched.
- **BLM (2013) Ch. 2** covers general concentration via entropy — too general.
- **Vershynin (2018) Ch. 2** gives moment-equivalence for sub-Gaussian random variables: $(E|X|^p)^{1/p} \le K\sqrt p$. This is the right cite *iff* $\|\hat e_m\|$ is sub-Gaussian as a real random variable, which `rem:hyper` argues via the four-term decomposition.

The argument in `rem:hyper` is: $\hat e_m = I_m + II_m + III_m + IV_m$, each term sub-Gaussian, sum sub-Gaussian. This leans on the same tail bound that Step 1 of `prp:lepskii` produces. Not strictly circular (the deterministic part of $III_m$ has no random component beyond the iterates whose tails come from $II_m, IV_m$), but the reference chain is fragile. **Deduction: -10. Vershynin Ch. 2 is the right citation; Hanson 1971 is mismatched.**

### F4 (no deduction) — Rate-balance verified

At $\beta_\epsilon = 1$: $V(M_n)^2 = c_v^2 \delta_n^2 M_n + c'_v{}^2 \gamma_n^2 = O(\delta_n) + o(\delta_n^{\epsilon+1}) = O(\delta_n)$. ✓
At $\beta_\epsilon < 1$: $V(M_n)^2$ can be dominated by $\gamma_n^2 M_n^{1-\beta_\epsilon}$, but the absorption only requires $\delta_n^2 m^2 V(m)^2 = o(1)$ at $m \le M_n$, which holds under `ass:restrvarth` regardless of $\beta_\epsilon$. `rem:scope` correctly identifies the loss of rate-adaptivity here. ✓

### F5 (MINOR) — $\tau^2$-dependence of $III_m$ absorption not bookkept

results.tex L408–418 absorbs $\|III_m\| = O(V(m))$ "into the constant $c_v$." Since $\|III_m\| \le C\hat M\tau^2 V(m)^2\sqrt m$ scales as $\tau^2$, the per-$m$ Bernstein constant $c_0$ in \eqref{eq:bernstein} may need a $\tau$-dependent adjustment. The proof asserts this works but doesn't display the bookkeeping. **Deduction: -3.**

### F6 (no deduction) — `rem:overhead` overhead claims internally consistent

With $M_n = O(\delta_n^{-1})$:
- Mildly IP ($\delta_n \asymp n^{-c}$): $\sqrt{\log M_n} = O(\sqrt{\log n})$. ✓
- Severely IP ($\delta_n \asymp (\log n)^{-c}$): $\sqrt{\log M_n} = O(\sqrt{\log\log n})$. ✓

---

## Phase 3 — Regression Check

Spot-checked Round 1+2 preserved patches: CR1 (L326–438), CR2 (L598–614), M1 propagator (L98–194 — note this is now superseded by R3-G2-b), M2 $\Omega'_n$ (L253–268), M3 (L447–450), M4 $\tilde V$ (L44–47), M5 $R^\varphi$ (`ass:unifbd`(iii) L132–135, used L648–664), M6 $L^{2l}$ (`ass:rateconv`(i) L62–72), MN1–MN10 (consistent), Step 4 $\kappa$ (L448, L616), Step 5 second-derivative (L665–684). **All preserved. No regression.**

---

## Phase 4 — Polish

- All `% PATCH-R3-*` markers present.
- Notation: $C_q, L'_{\mathsf T}, \mathsf L_b, R^{(2)}_{m,j}$ in glossary.
- Citations: Hansen 2008, Vershynin 2018, BLM 2013, Engl 2000, Bauer-Hohage 2005, Hoffmann-Reiß 2008, Dunker 2018 — all consistent.
- LaTeX hygiene: no undefined refs in scope.

---

## Scoring

| Item | Severity | Deduction |
|---|---|---|
| F1 — `lem:propagator` quadratic-remainder substitution incomplete | MAJOR | -10 |
| F2 — Scope restriction in remark only, not in proposition | Scope unmarked | -8 |
| F3 — `rem:hyper` justification fragile; citations misaligned | MAJOR | -10 |
| F5 — $\tau^2$-dependence in $III_m$ absorption not bookkept | MINOR | -3 |

**Total: -31. Score: 69 / 100.**

---

## Decision: **HALT — PARTIAL PASS**

Score 69 ∈ [60, 80). Per Round-3 protocol, this is a HALT (no Round 4). Narrow critics (regularity-checker, counterexample-hunter) NOT dispatched — gate not crossed.

**What was achieved.** Round 3 delivered substantive progress: the two CRITICAL errors from Round 2 (backwards Jensen, missing $\sqrt m$) are repaired in displayed form; the rate-balance arithmetic for G2 closes correctly at the tightened horizon; the scope concession is documented honestly. The artifact is no longer broken at the level of any CRITICAL error.

**Why not GO.** Three residual issues prevent a clean pass:
1. The propagator-substitution step in `lem:propagator` leans on an unproved commutation claim.
2. The scope restriction to $\beta_\epsilon \ge 1$ lives in a remark, not in the proposition or a corollary; the formal claim still overpromises.
3. `rem:hyper`'s justification cites references that do not directly deliver the assumed hypercontractive bound; it leans on a near-circular chain through Step 1's own tail bound.

---

## Remaining issues for user

1. **Commutation of $\mathsf L_{b_\dagger}$ with $\hat{\mathsf T}'^*_{b_\dagger}\hat{\mathsf T}'_{b_\dagger}$** (results.tex L176–178). Either prove it, OR bound the linear-residual contribution explicitly. The linear residual likely absorbs too at the tightened horizon ($\delta_n^2 m^2 V(m)^2 = O(\delta_n)$ algebra applies). Option (b) is safer.

2. **Scope statement in the proposition body.** Rewrite `prp:lepskii` with a parenthetical clause "rate-adaptive when $\beta_\epsilon \ge 1$; with realised rate $V(M_n)$ otherwise" — or split into two corollaries.

3. **Hypercontractivity citation.** Replace Hanson (1971) with **Vershynin (2018) Theorem 2.5.2** (sub-Gaussian moment-equivalence) — the direct match. Or, preferably, prove the inequality from `ass:subgauss` + the four-term sub-Gaussian decomposition without citing it as an assumption.

4. **$III_m$-into-$c_v$ absorption bookkeeping** (results.tex L412–417). Display whether $c_0$ in \eqref{eq:bernstein} needs a $\tau$-adjustment after the absorption, and confirm the $\sqrt{\log M_n}$ overhead is unchanged.

These are addressable, but they require theorist work — not just critic re-review. The proof is structurally sound but one revision short of clean. **Recommend a Round-4 outside of three-strikes** (a fresh planning cycle with these four items as targeted edits), rather than dispatching the narrow critics on the current draft.
