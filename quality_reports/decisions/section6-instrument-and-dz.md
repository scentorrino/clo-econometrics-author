# Decision Record — Strategy: Section 6 instrument choice and the $d_Z$ ladder

**Date:** 2026-08-03
**Stage:** Strategy (Section 6, empirical application)
**Decided by:** Samuele Centorrino, on two questions escalated to him and left open since 2026-07-31

---

## Decision

**(1)** Section 6 uses the **imputed county-level nonattainment designation** as the binary
instrument $W$, and makes the **non-differential-misclassification case explicitly**, confronting
the contrary evidence rather than assuming past it.
**(2)** Section 6 reports a **$d_Z$ sensitivity ladder** across control-set sizes rather than a
single specification, so that the tension between the theory's feasibility frontier and applied
practice is shown rather than resolved by assumption.

## Context

These are the two items that kept Section 6 unwritten. They were recorded in the `main.qmd`
comment block as *"escalation items for the user, not worker rounds"* — correctly, because each is
a judgement about what the paper is willing to defend, not a question any agent can settle from
the data. They blocked drafting for three days.

The section is otherwise unblocked: `data/raw/data_tsp.txt` holds the Chay & Greenstone county
panel — 989 counties, `CATT` split 300/689 so overlap is fine, 23 candidate controls — and the
estimator is already implemented in `scripts/R/lf_panel.R` and `scripts/R/orthogonal_theta.R`.
**Section 6 was never blocked on data or on code.**

### Question 1 — the designation mismatch

The county-level designation in hand is an *imputation*. The designation actually made was at AQCR
level. The two cannot both be used:

- Under the **official AQCR** designation, $W$ is the policy, but the conditional parallel-trends
  implication of **A1 fails** (Cropper et al. 2023, *JEEM* 121).
- Under the **imputed county** designation, A1's testable implication passes, but $W$ is not the
  policy. Rescuing it requires **non-differential misclassification**, which is not established,
  and the cited evidence points the other way.

The asymmetry that makes this sharp: on the differential branch the estimator is
**inconsistent, not merely imprecise**.

### Question 2 — $d_Z$ against $n$

$n = 989$. The applied literature expects 10–25 controls. The feasibility table the theory prints
stops at $d_Z = 5$ and already requires implausible smoothness there. Shrinking the control set
shrinks $d_Z$ but weakens the conditional-exogeneity defence at the same time, and the Monte Carlo
verdict is already *"matches at large $n$ only"* — so the two constraints bind together rather
than separately.

## Alternatives Considered

### Question 1

| Alternative | Why rejected |
|---|---|
| **Official AQCR designation, report the A1 failure** | $W$ becomes unimpeachable, but a testable consequence of the paper's *own maintained assumption* then fails in the data. The application's role is to illustrate that the method works; a section documenting where its assumption breaks undercuts that role. |
| **Drop §6; methods + Monte Carlo only** | Scientifically cleanest, and the theory is the contribution. Rejected because OBES is an applied-econometrics field journal and the application exists precisely for that readership — dropping it means re-targeting the journal. |
| **Both designations as a sensitivity** | Refuses to hide the tension, but doubles the section and still requires naming a headline estimate. Rejected for §6's page budget; the article is already 75pp against a ~60pp target. |

### Question 2

| Alternative | Why rejected |
|---|---|
| **Small control set, inside the frontier** | Keeps the paper internally consistent, but buys that consistency with a conditional-exogeneity argument a referee can attack directly. Rejected as trading an external defence for an internal one. |
| **Full control set, flagged as outside the frontier** | Honest and consistent with the large-$n$-only verdict, but discards the information in the comparison — it reports one point where a curve is available. |

## What was chosen, and the obligation each choice creates

**(1) Imputed $W$.** This is the highest-payoff branch and the one that fails hardest if wrong.
The obligation is that the misclassification argument must be **made, not assumed**, and Cropper
et al. must be confronted head-on — a referee will find it. The estimation brief therefore asks
for *diagnostics*, not conclusions: first-stage strength of $W$ on $\Delta X$, and whatever bears
on whether the misclassification looks differential. **No agent is to assert that non-differential
misclassification holds.** That argument is the author's.

**(2) The ladder.** Rungs are to be chosen on a stated principle (most-defensible controls first,
then widening), not picked to flatter the estimate, and the movement of $\hat\theta$ and its
standard error along the ladder is itself the reported object.

## Key assumptions

- Non-differential misclassification of the imputed designation — **assumed for the headline
  specification, not established**, and this record is the place that says so.
- The 989-county configuration very likely sits **outside** the feasibility frontier the theory
  prints. That is expected and is to be reported as a finding, not tuned away.

## What would invalidate this

- Evidence that misclassification is differential. Under that branch the headline estimate is
  inconsistent and the decision reverses to the official designation or to dropping §6.
- An estimator that only converges after tuning chosen to make it converge. The brief explicitly
  forbids reporting a tuned run without its diagnostics.
- A clean, tight, significant estimate at $n = 989$ would be **more** suspicious than a noisy one,
  given the large-$n$-only simulation verdict, and should trigger a review of the pipeline before
  it is believed.

## Consequences for the manuscript

- The abstract and the roadmap must be revised when §6 lands — the `main.qmd` comment block
  already flags this, and it remains true.
- The §6 comment block in `main.qmd` says the section "stays unwritten until both close." **Both
  are now closed**, so that block is stale the moment §6 is drafted and must be retired in the
  same edit — not left to be found later. This is the defect species this project keeps producing.
- `CLAUDE.md`'s §6 row says "DECIDED, scoping" and "Data discovery in progress." Both are now
  wrong: the data is on disk and the design is settled. Update when §6 lands.
