<!-- CONDENSED RECORD, written 2026-07-31. The orchestrator cited this path in
     quality_reports/research_journal.md without having written the file — the fifth
     through ninth instance of that omission in one session, after being caught twice.
     The full agent report was not persisted at receipt and is not recoverable from
     this context; what follows is the substance as recorded in the journal entry of
     the same date, which is detailed and on disk. Treat the journal entry as the
     fuller record and this as its index. -->

# Monte Carlo critic, round 2. **Score: 81/100** (was 45). **Verdict: "Matches at large $n$ only" — HELD.**

**Clears the 80 per-component floor.** *"The engineer was right not to self-upgrade."*

**Three refusals adjudicated:** the condition-number finding **withdrawn** — but the engineer's margin is also wrong, since what is decomposed is `crossprod(Aw)`, giving a margin of **66**, not $10^8$; **and the shipped `mark()` rule inherits the same substitution, so the compression column can never be marked at-the-floor even when it is.** The "3 vs 5" correction is **owed to the engineer, not the critic**. The sign test **weakens** at the smaller constant (7 of 8, $p=0.070$) and the engineer **under-reports its own finding** — pooled it is 29 of 32.

**Central finding: the verdict's monotonicity claim is false and self-contradicted three sentences later.** Of 16 group×measure combinations only 3 shrink; coverage and worst-quantile fail in all four groups. **The correct statement, never made: scale gaps shrink, location and tail gaps grow with the budget** — consistent with the theorem and inconsistent with nothing.

**Bias arm:** 4 of 4 cells beyond 2 SE at the full bias, 0 of 4 at half — existence replicated, **rate not characterised** — and **the verdict is pronounced entirely on the zero-bias arm** while the realistic design shows 3.34 SE of centring at the largest $n$.

**Provenance fix "mostly" adequate:** assertions run **after** `saveRDS` and the tables; `limitlaw.R` has **zero** assertions. *"It cannot ship silently again, but it does ship."*

Full detail: research_journal.md, 2026-07-31 entry.
