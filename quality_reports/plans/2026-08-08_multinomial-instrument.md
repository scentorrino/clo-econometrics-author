# Plan: generalize the instrument from binary to L-category discrete

**Status:** APPROVED (user, 2026-08-08)
**Scope:** theory corpus → engine → verification → §6 re-run with a 4-category instrument

---

## 1. What changes, in one paragraph

A1 is already cardinality-free: $\Delta U\perp\!\!\!\perp W\mid\Delta Z$. What is binary is the
*representation* — a single scalar contrast $\widetilde W=W-\varrho(\Delta Z)$ exhausts the
restriction only when $W\in\{0,1\}$. For $W\in\{0,\dots,L-1\}$ the restriction is carried by the
vector $\widetilde W_l=\mathbb 1\{W=l\}-\varrho_l(\Delta Z)$, $l=1,\dots,L-1$, with
$\varrho_l(\Delta Z)=P(W=l\mid\Delta Z)$ from a multinomial fit. **The space of functions of a
discrete $W$ is exactly $(L-1)$-dimensional, so these contrasts span it with nothing
approximated** — no Bierens device is needed in the $W$ direction. Bierens stays where it is,
over $\Delta Z$, untouched.

**Identification is not at stake.** It already holds at $L=2$ under independence. The extra
contrasts are *surplus* restrictions. They buy efficiency and, decisively for §6,
**overidentification**: $L-1$ contrasts give $L-2$ testable restrictions, which converts A1 from
an untestable assumption into one with evidence for or against it.

**No reference to the linear ill-posed inverse problem belongs in this argument.** $\varphi$
solves a nonlinear operator equation under an independence restriction; the cardinality of $W$
does not act on the conditioning of a linear Fredholm operator, and framing it that way imports
the wrong problem.

## 2. The compiled corpus, and only it

`scripts/build-theory/driver.tex` inputs eight files in this order. Counters advance in
`\input` order, so nothing may be reordered.

| file | lines | sites touching $\widetilde W$ / $\varrho$ / $\{0,1\}$ |
|---|---|---|
| `assumptions_main.tex` | 2922 | 53 |
| `results_s2_identification.tex` | 520 | 31 |
| `results_s3_estimation.tex` | 557 | 20 |
| `results_s4_asymptotics.tex` | 398 | 3 |
| `assumptions_supp.tex` | 1117 | 34 |
| `results_s3_supp.tex` | 589 | 6 |
| `results_supp.tex` | 5121 | 109 |
| `proofs.tex` | 8883 | 274 |

`results.tex`, `assumptions.tex`, `results_main.tex` are the **retired** mirrors — compiled by no
document (see `.claude/rules/quality.md` binary gate 1). They are OUT OF SCOPE and must not be
edited; touching them re-creates the divergence that gate was repointed to avoid.

## 3. The specific edits

**N1 Notation.** $W\in\mathcal W=\{0,\dots,L-1\}$, $L\ge2$ finite and known. $\varrho=(\varrho_1,
\dots,\varrho_{L-1})'$, $\widetilde W\in\IR^{L-1}$. $L=2$ must reduce to the current text
verbatim, so the binary case remains readable as a special case rather than a corollary.

**A1** — statement unchanged; add a remark that it is cardinality-free and that this is why the
generalization touches representation only.

**A4(i) Overlap.** Now $\varrho_l(\Delta Z)\ge\varepsilon_\varrho$ for every
$l\in\{0,\dots,L-1\}$ **and** $\lambda_{\min}\big(\Omega(\Delta Z)\big)\ge\varepsilon_\Omega>0$,
where $\Omega=\operatorname{diag}(\varrho)-\varrho\varrho'$ is the conditional covariance of the
contrast vector. At $L=2$, $\Omega=\varrho(1-\varrho)$ and the condition collapses to the
present one.

**A4(ii)–(iii)** — per component, same Hölder ball and same rate $r_n$.

**Normalisation.** The scalar $\varrho(1-\varrho)$ becomes $\Omega(\Delta Z)$, and the efficient
weighting is $\Omega^{-1}$. **This is a design decision, not a substitution**: componentwise
$\varrho_l(1-\varrho_l)$ ignores the negative cross-category correlation and is wrong.

**`def:hatT`** — $\widehat T(u,t,l)$, with $\Pi=\Pi_u\otimes\Pi_t\otimes\Pi_l$, $\Pi_l$ a
probability measure on $\{1,\dots,L-1\}$.

**`lem:adjoint`(i)** — $g_{u,t,l}=\widetilde W_l\,w(t'\Phi)\,f(u)$ and
$\mathcal A^\ast\ell=\sum_l\pi_l\,\nu_{g_{l}}/\pi$.

**`prp:orthog`** — $\psi=\Delta Z\,\Delta U+\sum_l\widetilde W_l\,\lambda_l(\Delta U)$; Neyman
orthogonality becomes a system in $(\lambda_1,\dots,\lambda_{L-1})$.

**NEW: overidentification.** A proposition stating that under A1 every contrast identifies the
same $\varphi$, and a statistic testing it. This is the deliverable that makes §6 answerable.

**Rates (§4).** Structure unchanged; constants carry $L$. Check whether any constant is claimed
$L$-free when it is not.

## 4. Phases

| phase | agent | output | gate |
|---|---|---|---|
| 1 | theorist | notation + A1 remark + A4 + normalisation in `assumptions_main.tex`, `assumptions_supp.tex` | theorist-critic ≥ 80 |
| 2 | theorist ×2 (parallel) | `results_s2_identification.tex` + `results_s3_estimation.tex`; `results_s4_asymptotics.tex` + `results_s3_supp.tex` + `results_supp.tex` | theorist-critic ≥ 80 |
| 3 | theorist | `proofs.tex` — the 274 sites | theorist-critic ≥ 80 |
| 4 | notation-warden, assumption-auditor, regularity-checker, counterexample-hunter (parallel) | audits | no CRITICAL |
| 5 | orchestrator (me, Bash) | `scripts/build-theory/build.sh` compiles clean; render `main.qmd`/`supplement.qmd` | zero undefined refs |
| 6 | coder | engine: multinomial `fit_propensity`, vector `wtil`, $\Omega^{-1}$ weighting, adjoint sum over $l$ | coder-critic ≥ 80 |
| 7 | orchestrator | faithfulness check: engine vs theory, line by line | — |
| 8 | orchestrator | full top-to-bottom verification | binary gates |
| 9 | — | §6 re-run with the 4-category trigger instrument | — |

**Phase 1 is a contract.** It fixes the notation every later phase consumes. Nothing downstream
starts until it is settled, or the phases collide.

## 5. The empirical instrument this is for

Four categories from the two triggers already in `data/raw/tsp_iv_variants.csv`:

| $l$ | trigger | n | baseline TSP | mean $\Delta$TSP |
|---|---|---|---|---|
| 0 | attainment | 685 | 58.0 | −7.1 |
| 1 | bad-day only (spike, clean) | 114 | 73.3 | −13.7 |
| 2 | annual mean only | 66 | 79.9 | −9.9 |
| 3 | both | 118 | 97.8 | −21.0 |

**Overlap will bind before the algebra does.** 66 counties in $l=2$ against $d_Z=5$ is thin for a
conditional multinomial, and A4(i) is exactly the condition it strains. Expect to report the
realised $\min_l\hat\varrho_l$ and $\lambda_{\min}(\hat\Omega)$, and to consider collapsing
$l\in\{2,3\}$ if overlap fails.

## 6. What this does NOT do

It does not repair A1 on the TSP data. The chronic-level channel remains a function of $X_1$ at
any cardinality. What it does is let the transient channel be *separated* from it and the two
tested against each other.
