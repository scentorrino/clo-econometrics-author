# Decision: the Oregon Health Insurance Experiment is NOT a viable replacement for §6

**Date:** 2026-08-08
**Status:** DECIDED — rejected on evidence from the public use files, not on argument
**Supersedes:** the "Best fit" ranking in `alternative-applications.md` §5
**Corrects:** the rejection *reasoning* in `data-assessment/panel-npiv-discrete/data_sources.md` §3

---

## Why this was checked at all

§6's A1 — $\Delta U \perp\!\!\!\perp W \mid \Delta Z$ — is **rejected** on the Chay–Greenstone
data by the one probe row entitled to speak (see `probe2_size_summary.md`). OHIE was the
leading replacement because a randomised lottery makes A1 a *design fact* rather than a
defended assumption, and because $\varrho$ is **known** (it depends only on household size),
which removes the estimated-propensity channel that invalidates three of the five probe rows.

The public use files were downloaded from NBER (login required; the click-through agreement
prohibits identifying subjects and commercial use) and unpacked to `data/raw/ohie/`, which is
gitignored.

## What the files actually contain

| file | rows | vars |
|---|---|---|
| `oregonhie_descriptive_vars.dta` | 74,922 | 22 |
| `oregonhie_ed_vars.dta` | 24,646 | 88 |
| `oregonhie_inperson_vars.dta` | 20,745 | 89 |
| `oregonhie_survey{0,6,12}m_vars.dta` | 74,922 | 123–150 |
| `oregonhie_stateprograms_vars.dta` | 74,922 | 36 |

The **only** file with a genuine pre/post pairing is the ED file, where `*_pre_ed` is
pre-randomisation and `*_ed` is the study period. There are **no credit-report and no
mortality files** in the public use data — the variables I expected to be the plausible
continuous $X$ are not released.

## Finding 1 — a continuous pre/post pair does exist, so the recorded rejection reason was wrong

`data_sources.md:215` rejected OHIE because "$X$ = insurance coverage is **binary**." Coverage
is not the only candidate. Total charges are continuous and measured in **both** periods:

| variable | n | distinct values | % exactly zero |
|---|---|---|---|
| `charg_tot_pre_ed` | 24,637 | 6,675 | 69.0 |
| `charg_tot_ed` | 24,630 | 7,537 | 65.7 |

So the **outcome** of that rejection was right and its **stated ground** was not. Corrected
here rather than left to be rediscovered.

## Finding 2 — the atom

Two-thirds of the mass sits on a single point.

- Both periods strictly positive: **4,589 of 24,621 (18.6%)**
- Zero in *both* periods: **13,136 (53.4%)** — their $\Delta\varphi$ is mechanically zero, so
  they carry no information about $\varphi$
- Zero in exactly one period: 6,896

A0 requires absolute continuity; this is not absolutely continuous. Restricting to the 4,589
means conditioning on $X_2$, which is post-treatment. Selection into that subsample is at
least not strongly differential — $P(\text{both}>0)$ is 0.1817 treated against 0.1894 control,
$t=-1.52$ — but it is still selection on an outcome.

## Finding 3 — the first stage is on the wrong variable, and this is what ends it

ITT controlling for household-size dummies (the lottery's known propensity):

| outcome | ITT | t |
|---|---|---|
| number of ED visits (post) | +0.085 | **2.64** |
| any ED visit (post) | +0.019 | **3.00** |
| $\Delta$ visits | +0.099 | **3.67** |
| total charges (post) | +126 | 0.63 |
| **$\Delta$ charges — what the model needs** | **+289** | **1.44** |

**The lottery moves the *count* of visits and does not move *charges*.** OHIE therefore offers
an exact trade-off that cannot be engineered around:

- the variable that is **continuous** has no first stage, $F \approx t^2 \approx 2.1$;
- the variable with a **first stage** is a censored count with a two-thirds atom at zero,
  inadmissible on the same ground `data_sources.md` used to reject Angrist–Evans.

For comparison, the TSP instrument runs $F = 13.0$ clustered to $24.3$ robust.

## Finding 4 — the in-person biomarkers cannot substitute

`a1c_inp`, `hdl_inp`, `chl_inp`, `bmi_inp`, `bp_sar_inp`, `bp_dar_inp` are genuinely
continuous, but measured **once**, post-lottery. The only `pre_lottery` variables in that file
are binary diagnosis indicators (`hbp_dx_pre_lottery_inp`, `chl_dx_pre_lottery_inp`). Nothing
to difference.

## Verdict

OHIE **clears** the short-panel criterion and **fails** on $X$. Not a deal-breaker that can be
engineered around: it is the joint requirement — continuous *and* twice-measured *and* moved by
the instrument — that no OHIE variable satisfies.

## What this does not settle

HAPIN remains the better structural fit (same $X$ in µg/m³, randomised, known $\varrho$, native
pre/post, first-stage contrast 70.7 → 24.0 µg/m³). It is **unavailable**: ClinicalTrials.gov
NCT02944682 records the IPD sharing statement as "NO". Obtaining it needs a collaboration and a
data use agreement with the Emory investigators.

**§6 therefore stands on the Chay–Greenstone data**, with A1 rejected and reported as such.
