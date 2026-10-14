# Theorist-Critic Review: Round-1 Redraft of `prp:lepskii`

**Target:** `quality_reports/theory/volatility-loc-scale/{assumptions.tex, results.tex, proofs.tex, notation_glossary.md}`
**Severity:** HIGH (Execution phase)
**Prior baseline:** 32/100 (qmd version, 2 CRITICAL + 6 MAJOR + 5 MINOR)
**Round:** 1 of 3

---

## Phase 1 — Claim Identification

The new `prp:lepskii` (results.tex L158–177) asserts the oracle inequality

$\bigl(E\|\hat b'_{\hat m} - b'_\dagger\|^2\bigr)^{1/2} \le C(\tau)\,\inf_{1\le m \le M_n}[B(m) + \tilde V(m)]$,

for all $\tau \ge \tau_0$ with $\tau_0 = 2$. Compared with the original prp-lepskii:

- The RHS now uses $\tilde V$ (running maximum of $V$) rather than $V$ itself (PATCH-M4). Structurally the same oracle inequality — the change strengthens monotonicity without weakening the result, since $\tilde V \ge V$ pointwise.
- Sub-Gaussian conditional response is now an explicit hypothesis (`ass:subgauss`); the source paper only assumed bounded moments (substantive cost of CR1).
- Uniform $L^4$ bound on iterates (`ass:iterbd`) is a new hypothesis (CR2).
- $M_n \asymp \delta_n^{-2}$ stated as `ass:mn-growth`.
- $\beta_\epsilon = \beta$ in MI mode made explicit (MN5).
- Transfer to $\hat a_{\hat m}$ uses the strengthened uniform $L^\infty$ bound on $\varphi_\dagger$ (PATCH-M5).

The conclusion remains an oracle inequality with the same RHS structure. **OK.**

---

## Phase 2 — Proof Validity (per-patch verification)

| Patch | Status | Comment |
|---|---|---|
| **CR1** (sub-Gaussian / Bernstein) | APPLIED, with reservations | `ass:subgauss` (L119–129) supplies the m.g.f. bound. Eq.~(bernstein), results.tex L246–248, asserts $P(\|\hat b'_m - b'_m\| > \tau V(m)) \le e^{-c_0\tau^2}$. Citation `hansen2008` Thm 2 is appropriate for kernel-regression exponential bounds under sub-Gaussian responses. **[MAJOR]:** The argument that $\hat b'_m - b'_m$ "factors through linear functionals of bounded kernels of $Y$" (L240) is asserted rather than derived. For $m \ge 2$, $\hat b'_m$ is a *nonlinear* function of the kernel estimators (it depends on $\hat{\mathsf T}$, $\hat{\mathsf A}^*$ via the iteration); Hansen (2008) gives concentration for a single kernel average, not for $m$-fold iterates. The proper Bernstein step should bound $\|\hat b'_m - b'_m\|$ through a decomposition into kernel-average pieces, each of which is sub-Gaussian, with $V(m)$ absorbing the iteration count. This is asserted via Lemma~\ref{lem:itervar} ("uniformity in $m$") but the lemma bounds *second moments*, not exponential moments. The leap from $L^2$-rate-$V(m)$ to sub-Gaussian-rate-$V(m)$ at fixed $m$ is not justified for $m \ge 2$. |
| **CR2** (L^4 on iterates) | APPLIED | `ass:iterbd` (L138–143) carries cleanly. Off-event step in Step 4 (L347–363) is correctly Cauchy–Schwarz with $(a+b)^4 \le 8(a^4 + b^4)$. Plausibility of $\sup_m E\|\hat b'_m\|^4 \le C_4$ not argued. **[MINOR].** |
| **M1** (propagator lemma) | APPLIED, with reservations | `lem:propagator` (L98–124) and proof (L126–152) telescope correctly. **[MAJOR]:** The remainder norm in eq.~(propagator) is $c(m-1-j)\sup_k\|\hat{\mathsf T}'^*_{\hat b_k}\hat{\mathsf T}'_{\hat b_k} - \hat{\mathsf T}'^*_{b_\dagger}\hat{\mathsf T}'_{b_\dagger}\|$. The text at L336 then claims "uniformly $O(\sum_k \|\hat b_k - b_\dagger\|)$ in operator norm" — requires local Lipschitzness of $b \mapsto \hat{\mathsf T}'^*_b\hat{\mathsf T}'_b$, invoked but not displayed. The audit pointed out the residual should be quadratic in $\|\hat e_j\|$; here it is delivered as linear in $\|\hat b_k - b_\dagger\|$ multiplied by $(m-1-j)$. Bookkeeping hand-waved ("absorbed into the original Term~$IV_m$"). |
| **M2** (Omega'_n + step size) | APPLIED CORRECTLY | $c < (2\|\mathsf T'_{b_\dagger}\|^2)^{-1}$ stated at L114, L228, L53 (proofs.tex). $\Omega'_n$ defined L210–216 and intersected with $\Omega_n$ at Steps 2, 3 (L271, L309) and Step 4 (L346). **OK.** |
| **M3** (log log n vs sqrt(log log n)) | APPLIED CORRECTLY | Remark~\ref{rem:overhead} (L430–446) explicit: overhead is $\sqrt{\log M_n}$ in all regimes, specialising to $\sqrt{\log n}$ (MI) and $\sqrt{\log \log n}$ (severely IP). **OK.** |
| **M4** (running max V tilde) | APPLIED CORRECTLY | $\tilde V$ defined L45–49; def:lepskii uses $\tilde V$ at L67–69; monotonicity invoked at L289, L295, L102 (proofs.tex). Step 2's certificate (L298) correctly uses $\tilde V(m^*) \le \tilde V(k)$ for $k \ge m^*$. **OK.** |
| **M5** ($R^\varphi$ bound) | APPLIED CORRECTLY | `ass:unifbd`(iii) L77–81 includes $|\varphi_\dagger(x)| \le R^\varphi$. Step 5 (L395–411) uses $C_\Phi := \max(R^\sigma, R^\varphi)$. **OK.** |
| **M6** ($L^{2l}$ moments) | APPLIED, with reservations | `ass:rateconv` L46–58 states $L^{2l}$ moments up to $l_0 \ge 4$. **[MAJOR]:** Proof invokes these at Step 1 (L221–226: "license the $E\|\hat e_j\|^8$ products"), `lem:itervar` is asserted to use them. But the *actual induction step* consuming the $L^8$ moments is not displayed in either file — text says "the induction underlying Lemma~\ref{lem:itervar}" relies on $L^8$. Lemma~\ref{lem:itervar} itself is stated but not proved here. Audit fix is partial: assumption correctly strengthened, but proof step consuming it is opaque. |
| **MN1** (single cite for link) | APPLIED | `florens2012` at L390 results.tex and L193 proofs.tex. **OK.** |
| **MN2** ($m_4$ not $M_4$) | APPLIED | L90 results.tex, L145 proofs.tex use $m_4$. `ass:unifbd`(iv) L82 uses $m_4$. **OK.** |
| **MN3** ($c_g$ renamed) | APPLIED | Remark~\ref{rem:cg} (L491–502) clarifies $c_g = c$. **OK.** |
| **MN4** ($\tau_0$ absolute) | APPLIED CORRECTLY | $\tau_0 = 2$ at L301–302 results.tex, L109 proofs.tex. **OK.** |
| **MN5** ($\beta_\epsilon$ in MI) | APPLIED | def:Bm L52–61: $\beta_\epsilon := \beta$ in MI. **OK.** |
| **MN6** ("w.p. $1-o(1)$") | APPLIED | L134–137 results.tex, L140–141 proofs.tex. **OK.** |
| **MN7** (Cavalier–Hengartner replaced) | APPLIED | Remark~\ref{rem:linear-reduction} (L448–473) cites `hoffmannreiss2008` and `cavalier2002`. **OK.** |
| **MN8** ($\beta$-mixing) | APPLIED | Remark~\ref{rem:mixing} (L475–489) explicit. **OK.** |
| **MN9** ($M_n \asymp \delta_n^{-2}$) | APPLIED | `ass:mn-growth` (L149–154). Used L204–205 results.tex, L34–35 proofs.tex. **OK.** |
| **MN10** ("for each $m$, constants independent of $m$") | APPLIED | L84, L88–91 results.tex. L149–153 proofs.tex (cosmetic duplicate comment on L150). **OK.** |

### Phase 2 findings

- **[MAJOR]** Step 1, results.tex L246–249 (also proofs.tex L62–72): The Bernstein bound $P(\|\hat b'_m - b'_m\| > \tau V(m)) \le e^{-c_0\tau^2}$ is asserted from `hansen2008` Thm 2 "since $\hat b'_m - b'_m$ is a sample average of bounded kernel functionals of a sub-Gaussian response." Only true for $m = 1$. For $m \ge 2$, $\hat b'_m$ is built recursively through estimated operators — not a sample average. Bound at rate $V(m)$ for iterated estimates requires either (i) a separate concentration argument for each operator-estimation step combined via $V(m)$'s construction, or (ii) a Talagrand-style chaining argument. Lemma~\ref{lem:itervar} gives $L^2$ control, not sub-Gaussian. Leap from $L^2$ control to exponential control is crux of CR1 — currently asserted, not proved. (Deduction −10.)

- **[MAJOR]** Lemma~\ref{lem:propagator} remainder is *linear*, not quadratic in $\|\hat e_k\|$, and absorption into Term~$IV_m$ at L336–340 is hand-waved. Audit (M1) called for a quadratic residual. Lemma gives linear-in-$\|\hat b_k - b_\dagger\|$ multiplied by $(m-1-j)$. Whether this produces the right rate after absorption into `lem:itervar`'s induction depends on the induction step displayed in the source paper; not checked here. (Deduction −10.)

- **[MAJOR]** Step 1's appeal to $L^{2l}$ moments (M6) does not display the induction step that consumes them. Reader asked to trust `lem:itervar` (proved elsewhere) uses them correctly. For $\ge 80$-grade proof under HIGH severity, this needs a one-paragraph displayed argument: where exactly in the induction does $E\|\hat e_j\|^8$ appear, and how does the propagator-substitution residual contribute? (Deduction −10.)

- **[MINOR]** Step 4, results.tex L368: "for any $c$ large enough relative to the smallest pole rate" — constant $c$ being reused (also LF step size). Notation collision: $c$ in $\tau_n = \sqrt{(1+c)c_0^{-1}\log M_n}$ is unrelated to LF step size $c$ at L227. (Deduction −3.)

- **[MINOR]** Step 5, results.tex L416–419: "squared error is $o(\|\hat b_{\hat m} - b_\dagger\|)$" — should read $\|\hat b_{\hat m} - b_\dagger\|^2 \le \|\hat b_{\hat m} - b_\dagger\|\cdot\sup\|\Phi''\|\cdot(\text{diameter of }\mathcal{B}_{b_\dagger})$. Minor exposition. (Deduction −2.)

---

## Phase 3 — Assumption Minimality and Notation Consistency

- **Usage:** All 15 assumptions referenced in `results.tex`. No orphans.
- **New assumptions beyond patch list:** None. **OK.**
- **Notation:** $\tilde V$ vs $V$, $\Omega_n$ vs $\Omega'_n$, $\beta_\epsilon$ vs $\beta$ in MI/FI consistent.
- **[MINOR]** Symbol collision between $a$ (link-condition exponent) and $a$ (original-coordinate pair $(\varphi, \sigma)$). Glossary L26 vs L61. Inherited from source paper. (Deduction −3.)
- **Glossary coverage:** All symbols in `results.tex` listed. **OK.**

---

## Phase 4 — Citation Fidelity and Polish

- **Bernstein citation:** `hansen2008` Thm 2 canonical for kernel-regression exponential bounds — appropriate for the building block, but not by itself for $m \ge 2$ iterates. (Already counted under CR1.)
- **Bauer–Hohage and Hoffmann–Reiss:** Cited as parallel references for inverse-problem residuals. Reasonable.
- **MN7 (Cavalier–Hengartner mis-cite):** Replaced; `cavalier2002` and `hoffmannreiss2008` cited correctly. **OK.**
- **LaTeX hygiene:** All theorem environments balanced. `\begin{proof}...\end{proof}` correctly placed. All `\label{}` references defined. Remarks AFTER `\end{proof}` (L426+) — compliant. **OK.**

---

## Scoring

Starting at 100, HIGH severity (Execution-phase deductions):

| Finding | Severity | Deduction |
|---|---|---|
| CR1 — Bernstein bound for $m \ge 2$ iterates asserted not proved | MAJOR | −10 |
| M1 — propagator-residual absorption hand-waved; linear-vs-quadratic question unresolved | MAJOR | −10 |
| M6 — induction step consuming $L^8$ moments not displayed | MAJOR | −10 |
| Reuse of constant `$c$` in Step 4 vs LF step size | MINOR | −3 |
| Step 5 wording "$o(\|\hat b - b\|)$" loose | MINOR | −2 |
| Symbol collision $a$ (link) vs $a$ (coords) | MINOR | −3 |

**Total deductions: −38**

**Final score: 62 / 100**

---

## Verdict

13 patches present; most mechanically sound (M2, M3, M4, M5, MN1–MN10 are clean). Three patches that matter most for proof validity — **CR1, M1, M6** — are **applied at the level of assumptions and remarks but not at the level of displayed proof steps**. The proof now states the right hypotheses and gestures at the right arguments, but the load-bearing steps (Bernstein tail for iterated estimates; quadratic absorption of the propagator residual; the $L^8$-moment induction) are still asserted rather than proved. A referee would not pass this redraft.

**Score: 62 / 100. NO-GO for the narrow critics.**

**Recommendation:** Return to theorist for **Round 2** with three targeted requests:
1. Display the decomposition that turns Hansen (2008)'s single-kernel exponential bound into the $\hat b'_m - b'_m$ bound at $V(m)$ rate — even one paragraph showing how each iteration step contributes a sub-Gaussian piece would suffice.
2. Either prove the propagator remainder is genuinely $O(\|\hat e_k\|^2)$, or display the induction step in `lem:itervar` that absorbs an $O((m-1-j)\|\hat e_k\|)$ remainder without breaking the rate.
3. Display the $L^8$ induction step (or import the relevant lines from the source paper's proof of `thm:mainconv`).

Round 2 budget: 2 more rounds before escalation per `agents.md` §3.
