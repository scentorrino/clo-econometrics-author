# Access Instructions — `panel-npiv-discrete`

**Date:** 2026-07-31
**Constraint driving everything below:** the target journal is **Oxford Bulletin of Economics and Statistics**. Practitioner readership, applied-econometrics framing, and a replication package a reader can actually run. That rules out anything behind a partnership or a long restricted-access queue, and it means an OBES referee should in principle be able to obtain the data. **Feasibility is weighted heavily here and I have graded accordingly.**

---

## Critical path at a glance

| # | Task | Blocking? | Elapsed estimate | Start when |
|---|---|---|---|---|
| **0** | **AQS API smoke test for pre-1980 TSP** | Decides C1's grade | **30 minutes** | **Now** |
| **0b** | **C2 county-count check (AQS ∩ FHFA)** | Decides C2's grade | **20 minutes** | **Now** |
| **1** | **Request TSP + designation file — all three routes in parallel** | **Yes, this is the only real schedule risk** | 1–8 weeks | **Week 1, day 1** |
| 2 | Download CCDB 1972 + 1983 from ICPSR | No | Same day (hours) | Week 1 |
| 3 | FIPS crosswalk and merge | No | 3–5 days | Week 1–2 |
| 4 | Build C2 from public sources as insurance | No | 2–3 weeks | Week 1, in parallel |
| 5 | Reproduce Chay–Greenstone benchmarks | Gate before new estimation | 3–5 days | On receipt of task 1 |

**The single most important scheduling instruction: do not sequence the three routes in task 1.** Fire all three on day 1. The cost of doing so is three emails and half an hour; the cost of sequencing them is potentially two months.

---

## Task 0 — Two checks to run before committing to anything

### 0a. Does EPA AQS actually return pre-1980 TSP nationally?

This determines whether C1's fallback data route exists, and therefore whether C1 is grade B or grade C.

**What is already established.** Pre-1980 data *are* in AQS — EPA states the database holds total-suspended-particulate records for Los Angeles County back to **1957**. But the pre-generated AirData download files begin in **1980** and **do not include TSP as a category at all**. So bulk download is not available and the API is the only mechanical route. What is *not* established is whether national coverage in 1969–1980 is dense enough to rebuild a 988-county panel, or whether it is a handful of monitors in a few states.

**Steps.**
1. Register for a free AQS API key at the AQS API documentation page. Email validation required; issued immediately.
2. Query a single state, a single year, for the TSP parameter (commonly cited as code `11101` — **verify this against the AQS parameter list rather than assuming it**). Constraints to respect: at most 5 parameters per request, `bdate` and `edate` must be in the **same calendar year**, no more than ~10 requests per minute, and a recommended 1,000,000-row ceiling.
3. Repeat for two or three states with different 1970s industrial profiles, and for 1970, 1974 and 1980.
4. Count distinct monitors and distinct counties returned.

**Decision rule.** Dense national coverage → C1's route (iii) is live and C1 is solidly grade B even if the emails fail. Sparse coverage → C1 depends entirely on routes (i) and (ii), and if both fail within four weeks, switch the application to C2.

**Also record** EPA's own caveat for the paper's data section: pre-1980 records are excluded from EPA trend analysis "because of uncertainties in the results," since nationally consistent operational and QA procedures start in 1980.

### 0b. How many counties does C2 actually have?

1. Download one EPA AirData **annual summary** file (PM2.5) for a mid-window year.
2. Download the FHFA **annual county** house price index file (or pull the FRED `ATNHPIUS{FIPS}A` series list).
3. Inner-join on FIPS, drop missing, count.

**Decision rule.** Count ≥ 700 → C2 is a strong grade-A fallback. Count 500–700 → usable but sitting at the bottom of the simulation grid; say so in the paper. Count < 500 → C2 drops to grade B and is a robustness exhibit only, not an insurance policy.

---

## C1 — Chay & Greenstone CAA/TSP county panel — **GRADE B**

### Component 1: Housing values and county characteristics — free, same day

**Source.** ICPSR.
- **ICPSR 00061** — *County and City Data Book, 1972* (1970 Census basis)
- **ICPSR 08256** — *County and City Data Book [United States], 1983* (1980 Census basis; three files — counties, cities, places; you want **counties**)

**Steps.**
1. Log in to ICPSR through your institution. These are **free to users at ICPSR member institutions** — no application, no DUA, no wait.
2. Download the county files and, critically, **the codebooks**. Every `CODEBOOK` marker in `data_dictionary.md` is resolved from these two documents.
3. Read off and record the exact column names for: median value of owner-occupied housing; per-capita income; unemployment rate; manufacturing employment; population; population density; urbanised-area share; poverty rate; owner-occupancy rate; education share of government spending; new home construction; educational attainment; vacancy variables.
4. Confirm the deflator you will use to put both years in 1982–84 dollars, then check your sample means against \$40,300 and \$53,168.

**Timeline: hours.** **Cost: none.** **Grade for this component alone: A.**

*Consider also:* ICPSR 7736, *CCDB Consolidated File: County Data, 1947–1977*, as a cross-check on the 1970 values. It stops at 1977 so it cannot supply the 1980 endpoint.

### Component 2: TSP concentrations and nonattainment designation — the bottleneck

Chay & Greenstone obtained annual county air-pollution concentrations "based on the universe of state and national pollution monitors" **through a Freedom of Information Act request** to EPA. That file is not distributed with the article. Three routes; **run all three simultaneously.**

#### Route (i) — Ask Michael Greenstone. *Best expected value.*

This is documented to work: Cropper, Muller, Park & Perez-Zetune (2023) thank **Greenstone for sharing his data on attainment status**. He has shared this exact object with researchers pursuing exactly this question.

Write to him at the University of Chicago. Keep it to one screen and state: the model, the fact that you need county TSP for 1970, 1974/75 and 1980 plus the designation indicator, that the application revisits his 2005 estimates under a nonparametric $\varphi$ rather than disputing them, and the target journal. Offer co-citation and offer to share the assembled panel back.

**Timeline: 1–4 weeks.** Academic email latency is the variance here, not willingness.

#### Route (ii) — Ask Cropper, Muller, Park & Perez-Zetune.

They reassembled **balanced monitor panels for 1969–1978 and 1971–1978** for the *JEEM* (2023) paper, and their EPA monitor readings came from **Karen Clay**. Three assets sit behind that: the monitor panel itself, the **official AQCR-level designation** you need for the misclassification robustness table, and possibly a public replication deposit.

**Do this first, in fact:** check whether *JEEM* 121 (2023) carries a data availability statement or a Mendeley Data deposit. Elsevier journals have carried data-availability requirements for several years. **UNVERIFIED whether a deposit exists** — five minutes on the article's ScienceDirect landing page settles it, and if it does exist, route (ii) collapses from weeks to minutes.

Also worth a direct request to **Karen Clay**, who is the upstream source of the monitor readings and has assembled historical air-pollution data across several projects.

**Timeline: minutes if a deposit exists; 2–6 weeks by email.**

#### Route (iii) — Rebuild from EPA AQS.

Only viable if task 0a comes back positive. Then: pull monitor-level TSP by state-year via the API for 1969–1980, aggregate to county (both arithmetic and **geometric** annual means — the designation rule uses the geometric mean), and reconstruct the designation from the rule (previous year's annual geometric mean above 75 µg/m³, or second-highest daily reading above the daily standard).

**Be honest about what route (iii) cannot do.** Reconstructing the *designation* from monitor readings reproduces the **imputed county-level** definition — which is precisely the object Murphy (2016, 2017) and Cropper et al. (2023) identify as not being the official designation. Route (iii) therefore rebuilds the instrument *including its known defect*, and gives you no independent way to build `w_aqcr_official`. For that you still need route (ii) or archival Federal Register work.

**Timeline: 3–6 weeks** including the aggregation and designation logic. **Cost: none.**

### Legal / licensing

None binding. ICPSR data carry standard terms of use — cite the study numbers and do not redistribute the raw files. TSP data obtained under FOIA are public records and may be redistributed, which means **the assembled panel can ship with the OBES replication package**. That is a real advantage over C3 and should be stated in the submission.

### Realistic overall timeline for C1

| Optimistic | Central | Pessimistic |
|---|---|---|
| 2 weeks (deposit found, or fast reply) | 5–6 weeks | 10 weeks (all emails slow, AQS rebuild required) |

---

## C2 — Modern PM2.5 county panel — **GRADE A**

No permissions anywhere. The cost is assembly labour, not access.

1. **EPA AQS / AirData annual summaries.** Download pre-generated annual summary files (1980–present; PM2.5 FRM/FEM and non-FRM/FEM both included) for the chosen years. Bulk download, no key needed for the pre-generated files. Aggregate monitor-level to county, and **document the aggregation rule** — the choice of monitor-average versus maximum-monitor is exactly what determines who is treated in a designation context, and a referee will ask.
2. **EPA Green Book.** Take the PM2.5 (1997) area information: original designations **effective 5 April 2005**, 39 metropolitan areas, all or part of **208 counties**, 88 million people. Download the data exports and the GIS shapefiles. **Build the `partial_county_flag` and write down your rule for partial counties** — this is a discretionary researcher choice sitting directly on top of the binary instrument, and it must be disclosed and varied in robustness. Cross-check against the PM2.5 (2006) area information if you extend the window.
3. **FHFA House Price Index.** Annual county all-transactions index from the FHFA datasets page, or the FRED series `ATNHPIUS{FIPS}A`. **Flag it as developmental in the paper** — that is FHFA's own characterisation — and note that indices are not reported where county sample sizes are small, which is a selection mechanism on $Y$, not just missingness.
4. **Covariates.** BEA CAINC per-capita income, BLS LAUS unemployment, Census population estimates, County Business Patterns for manufacturing share. All free bulk downloads.

**Timeline: 2–3 weeks** of assembly, zero waiting on anyone. **Cost: none.** Start in parallel with C1's requests — the labour is not on C1's critical path and it converts a schedule risk into a hedged position.

---

## C3 — Regulation SHO pilot — **GRADE B/C**

1. **Pilot list.** From the SEC's 2004 Regulation SHO releases and the associated pilot-stock list. Public. **Verify the exact selection rule from the SEC release before describing it in the paper** — that one-third of Russell 3000 firms on NYSE/AMEX/Nasdaq NM were selected is confirmed; the frequently repeated "every third stock sorted by exchange then average daily volume" formulation is **UNVERIFIED here** and the paper's exogeneity argument rests on it.
2. **Prices, returns, fundamentals.** CRSP and Compustat via **WRDS** — institutional subscription required.
3. **Short interest.** Exchange-reported semi-monthly short interest; also available through WRDS.
4. **Window.** Pre-pilot baseline through the pilot period beginning **2 May 2005** and running until price tests were eliminated for all stocks in July 2007.

**Timeline: 1–2 weeks** given an existing WRDS account; add 2–4 weeks if account provisioning is needed.

**The OBES-specific problem, stated plainly.** CRSP and Compustat cannot be redistributed. A replication package can ship code and a variable list but not the data, so a reader without a WRDS subscription cannot reproduce the application. For a journal with a practitioner readership that is a real cost, and it is why C3 sits below C2 despite having the best instrument in the whole set. **Use C3 only if the nonattainment instrument collapses** — for instance if the AQCR misclassification objection proves fatal in referee reports.

---

## C4 — Greenstone & Gallagher Superfund — **GRADE C**

Listed for completeness. Recall from `data_sources.md` that this candidate **does not map to the model without constructing an $X$ that does not exist in the published data**, and that its established finding is a null.

1. **NPL and HRS records.** EPA public site records (SEMS/CERCLIS lineage) for sites on the NPL by 2000 and sites with 1982 HRS scores below the 28.5 cut-off.
2. **Tract housing and demographics.** IPUMS **NHGIS** — free, registration only, 1980 and 2000 tract tables with boundary crosswalks. NHGIS is the right tool for the 1980→2000 tract-boundary problem, which is otherwise severe.
3. **Assembled replication file.** **UNVERIFIED** whether Greenstone & Gallagher deposited one publicly. Check the QJE article page and Greenstone's institutional page; failing that, email.
4. **Constructed $X$.** Requires GIS work: geocode sites, compute distance-weighted uncleaned-site exposure per tract at 1980 and 2000 using remediation-completion dates. Every detail of this is unspecified and unverified. **Budget 4–8 weeks and treat it as a separate project.**

---

## C5 — CAA/TSP → infant mortality — **GRADE B**

Marginal cost once C1 exists is one outcome variable.

1. **NCHS Vital Statistics** natality and mortality detail files for 1970 and 1980, via NBER's vital statistics archive or NCHS directly.
2. **UNVERIFIED and blocking:** whether county identifiers are present in the public-use files for that vintage, and what minimum-births suppression rule applies. Read the NCHS public-use documentation for those years before assuming. If county identifiers are restricted, this becomes an NCHS/NAPHSIS research application and the grade falls to C with a multi-month timeline.
3. Everything else — $X$, $W$, $Z$, the county frame — comes free from the C1 build.

**Timeline: 1 week if public; 3–6 months if an application is required.**

---

## Rejected candidates — access notes, for the record

| Candidate | Access status |
|---|---|
| Moving to Opportunity | Restricted geography via HUD/ICPSR application. Realistically **months**, and the tract-level variable that would serve as $X$ is the restricted part. Fails the OBES feasibility bar despite an excellent instrument |
| Progresa / Oportunidades | Public-use panel freely downloadable — access is *not* the problem. The exclusion restriction is, because transfers are conditional on the very behaviours one would use as outcomes |
| Zillow ZTRAX | **Access changed.** Zillow discontinued distribution in October 2023 (researchers were required to delete raw data by 30 September 2023). Now hosted **exclusively by ICPSR**, refreshed twice yearly, **application required**. 20+ years, 2,750+ counties. No longer a free same-day resource |
| EU ETS firm panel | EUTL emissions public; firm financials need Orbis/Amadeus subscription. Grade C/D |
| Oregon HIE, NLSY, PSID, HRS, Add Health | Access is easy or moderate for all of them. **Access is not why they were rejected** — they fail constraint 2 or 3 on the merits. See the rejection table in `data_sources.md` |

---

## What to do this week

1. Run task 0a (30 min) and task 0b (20 min). Record both results in the research journal — they are grade-determining.
2. Check *JEEM* 121 (2023) for a data availability statement or Mendeley deposit (5 min). This is the highest-return single action in the whole plan.
3. Email Greenstone, Cropper/Muller/Park, and Clay. Three emails, same day, no sequencing.
4. Download ICPSR 00061 and 08256 and resolve every `CODEBOOK` marker in `data_dictionary.md`.
5. Begin the C2 assembly in parallel.

If by end of week 4 no TSP file has arrived and task 0a came back sparse, escalate the choice between C1 and C2 to the user. That is a resource trade-off, not a technical question, and per the escalation route for this agent it is the user's call.
