<!-- PERSISTED LATE, 2026-07-31. The orchestrator cited this path in the research
     journal and in a theorist brief WITHOUT HAVING WRITTEN THE FILE; the theorist
     found it absent, re-verified every relayed finding against the .tex before
     acting, and recorded the gap. FOURTH instance this session of a report cited
     from memory rather than from disk. Body is the regularity-checker's report. -->

# Regularity Audit — Part I (`thm:rootn`), `panel-npiv-discrete`

**Score: 55/100.** 3 MAJOR, 5 MINOR, no CRITICAL. Nothing counterexample-shaped to route.

## MAJOR 1 — Product measurability of the estimated nuisances is nowhere stated, and Part I dropped the one clause of the maintained block that came close

`def:crossfit`(c) says only "Borel, bounded, and continuous in $u$" — Borel **in the function's own arguments, at a fixed realisation**. Part I needs strictly more at essentially every display: **joint (product) measurability** of $(\omega,u,z)\mapsto\hat\ell^{(-k)}(\omega)(u,z)$, and likewise for the other four nuisances. Separate measurability in $\omega$ and Borel in $(u,z)$ does not give it.

Three places it is load-bearing: **composition of a random function with random arguments** (continuity handles the $u$-slot only; nothing is given in $z$ or $x$); **hypotheses that presuppose the object is a random variable** — (R-a)'s $E\|\hat b\|^4=O_P(1)$ and `eq:foldrates` are probability statements about frozen integrals, and **without product measurability they are not random variables and the hypotheses are not well posed**; and **the freezing/substitution identity itself**, which every $E[\cdot\mid\sigma(\mathcal I_{-k})]$ in three lemmas uses.

**What I looked for:** every "jointly measurable" in the corpus concerns a **deterministic** object ($G_\varphi$, $q$ via $Q_{12}$, $\ell^\Pi_\star$). None concerns a sample-dependent function. **The nearest thing in the block is `lem:balance`'s hypothesis line — "$\hat\ell$ is $\sigma(\mathcal I_a)$-measurable with $\hat\ell\in L^2(P_{\Delta U,\Delta Z})$ almost surely" — which, read as a random element of $L^2$, does deliver a jointly measurable representative. `def:crossfit` explicitly re-declares (P8)'s conditioning convention and does not re-declare this clause.**

**Consequence for $V_n$:** at `lem:epterm` Step 6 and `lem:sandwich` Step 8 the numerator's $\sigma(\mathcal I_{-k})$-measurability is **asserted at both sites, argued at neither**, and the argument (Tonelli) is unavailable until the clause exists.

**Grade: real, repairable in one clause** — re-declare at $\sigma(\mathcal I_{-k})$ for all five nuisances, and state the freezing lemma once beside (P8).

## MAJOR 2 — (P8)'s transfer rule does not have the hypothesis its two Part I sites supply, and the hypothesis it does have is unattainable there

Conditional Markov/Chebyshev delivers $P(|X_n|>\epsilon a_n\mid\mathcal G)\le\epsilon^{-p}V_n$ a.s. with $V_n$ $\mathcal G$-measurable and $O_P(1)$. At a threshold $M_n$ that is a fixed multiple of $V_n^{1/p}$ this bound is a **constant, not $o(1)$**; driving it to zero needs $M_n/V_n^{1/p}\to\infty$, destroying $M_n=O_P(1)$ unless $V_n$ carries a rate. **The header makes precisely this argument for the $o_P$ case and does not notice it applies verbatim to the $O_P$ case**, and the dispatch-11 change log confirms the diagnosis stopped at the conclusion, recording both sites as "UNTOUCHED". The mismatch is in the **hypothesis shape**, not the conclusion.

Per site: **`lem:sandwich` Step 2 over-reaches and does not need to** — the existing $o_P$ companion gives what Steps 4 and 6′ consume. **`lem:prelimtheta` Step 4 genuinely needs $O_P(\delta_n)$** and wants a third (P8) clause, two lines, with a device the file already owns.

*Routing note, not audited:* the same shape appears at the Part H sites the header names as transfer-rule consumers.

## MAJOR 3 — Sup-norms of a random function over an uncountable index, no separability supplied

(R-a)'s $\|\hat\ell^{(-k)}\|_\infty+\|\partial_u\hat\ell^{(-k)}\|_\infty$ are pointwise suprema over $\IR\times\IR^p$ of a random function; continuity is supplied **in $u$ only**. Measurability of the supremum is not established, so **(R-a) is not a well-posed probability statement as it stands.** Contrast the *population* object: `cor:elldiff` gives boundedness "uniformly in $z$" and $\ell_\star$ is deterministic. **Repairable in a line**, with one owed check that the exceptional set is $P$-null, since the envelope is used pointwise at the data.

## MINOR

**M1 — the quantifier order is not load-bearing, in either direction.** The companion is stated in the strong form (one null set, then all $\epsilon$); its proof fixes a single $\epsilon$ and needs only the weak per-$\epsilon$ form. The sites claim the strong form but derive it from Chebyshev, which gives the weak one. **"The over-claim at the sites and the over-demand in the statement cancel exactly."** Formal only.

**M2 —** `lem:biasexp` Step 0 establishes only *conditional* integrability, so the conditional expectations in `eq:biasdecomp` and `eq:threeway` are strictly **generalised** ones; the two readings coincide only under unconditional integrability.

**M3 —** a **vector-valued mean value theorem** at four sites; the MVT has no vector form. Harmless (only an envelope is wanted) but **inconsistent with the file's own practice at `prp:frechet` Step 2, which refuses the Lagrange form on exactly these grounds.**

**M4 —** `prp:medianpart` says the partitions are *drawn*, so $\sigma(\mathcal I_{-k})$ is not defined until the draw is fixed. **The median itself is clean** — Lipschitz hence Borel, and no median/limit interchange is taken.

**M5 —** (R-a) is an $O_P(1)$ statement read as a.s. finiteness; boundedness is rescued by `def:crossfit`(c), nothing rescues $\|\partial_u\hat\ell\|_\infty$, harmless only because it appears on the right of inequalities.

## Checked and clean

**`lem:momzero`(iv)'s tower step is properly discharged** — integrability argued explicitly, and it includes the right rebuttal of the natural objection (a law-dependent choice of a deterministic map is still a deterministic map; $W$ is not among the arguments). **`lem:biasexp`'s FTC step is the best-argued interchange in Part I** — Fubini licence named, joint measurability in $(\lambda,\omega)$ *argued* via Carathéodory, envelope constant. `lem:nusigma`(iii)'s (P5) proviso discharged at both sites. **No supremum over an uncountable index of a random *process* anywhere in Part I**; `lem:epterm`'s headline that it incurs no empirical-process obligation is honest. CMT/Slutsky all applied at the limit point. **`lem:sandwich`'s clause (i′) is sound on this axis**, checked step by step.

*Cross-axis note:* `lem:nusigma`(i) is stated "for every $h\in\mathcal V$" and **A1b(i) is on neither clause (i) nor (i′) of `lem:sandwich`** though Steps 3 and 6′ invoke it at $h_k$. **The bound needs no mean-zero constraint, so this is a citation gap and not a mathematical one.**
