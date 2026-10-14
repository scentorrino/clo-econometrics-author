<!-- CONDENSED RECORD, written 2026-07-31. The orchestrator cited this path in
     quality_reports/research_journal.md without having written the file — the fifth
     through ninth instance of that omission in one session, after being caught twice.
     The full agent report was not persisted at receipt and is not recoverable from
     this context; what follows is the substance as recorded in the journal entry of
     the same date, which is detailed and on disk. Treat the journal entry as the
     fuller record and this as its index. -->

# Symbolic suite audit. **117 specs: 115 exit 0, 2 by-design exit 1, 0 crash.**

**Falsifiability CLEAN — 117/117 perturbations flip.** Survivors of individual tests explained (`claimed_end: 0`, and `diff` specs where invariance to an added constant is correct). No `nan`/`zoo` residuals. **"Nothing in the suite is unfalsifiable. That is not where the rot is."**

**The rot is in the source pointers.** Only **5 of 40** label citations resolve at the cited line; median drift **+118**, max **+1208**; one cited range returns a comment about compactness where it claims the frontier condition. **Five specs cite the archived partH path** — and the archive README gives the reason those files were moved. **Zero specs name a label that no longer exists**: nothing deleted, everything moved. **Round 12's hand-repointing has itself gone stale — both specs it fixed are wrong again.**

**The honest tally is not "115 MATCH":** of the 115, **one is a declared retirement record**, **≥5 price a subject that has moved**, **2 run an interpretive transfer the paper declines**, **3 cite a retired tag**, and **28 are identities under automatic evaluation alone.**

**Eight load-bearing claims unmechanised**, each with a diagnostic written and all eight MATCH — true-and-unmechanised, not suspected errors. Two worth writing: the $d_Z\ge1$ identity (**the suite's most-relied-upon unstated premise**) and `lem:momzero`(iv)'s vanishing summand (**three `jacobian-*` specs are silently downstream of it**).

**It checked a deferral rather than accepting it:** `rootn-psi1-halfconstant`'s trigger **has not fired** — *"a verified finding, not an assumption."*

**Routing:** the pointer sweep **must not be done by hand a second time** — label anchors or a mechanical check, because *"hand-repointing rots within two dispatches."* (Now implemented as CHECK 7.)

Full detail: research_journal.md, 2026-07-31 entry.
