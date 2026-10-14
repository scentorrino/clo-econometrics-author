# Assumption-Usage Audit — `panel-npiv-discrete`, round 16 (post-dispatch-18/19/20)

**Date:** 2026-08-01
**Score: 37/100** (was 35, 46, 58)

> Orchestrator transcription; the assumption-auditor is read-only. **[VERIFIED]** marks claims
> the orchestrator independently re-ran.

**Corpus measured:** `results.tex` 86 numbered environments, `proofs.tex` 21,
`assumptions.tex` 27 → **107 results, 27 assumption/definition environments.**

---

## 0. The auditor's own round-15 finding was WRONG, and it says so

**Round-15 claim:** *"C5′(ii) — only citation is inside the consumer-less `lem:aerr`."* Filed as
"no live consumer."

**FALSE.** Measured: **7 occurrences in `results.tex`** **[VERIFIED — orchestrator counted 7]**,
2 in `proofs.tex`, 3 in comments. Two are **live arithmetic consumers outside `lem:aerr`**:

- **`rem:tccwhy`(3)** — collecting A8, `eq:entropysieve`, (P-c), C5′(ii) and `lem:unifop` Step 4
  at $(2,3,\tfrac34,0.32)$ leaves $h_xL_x$ free over a range containing $n^{-0.21}$ and $n^{0.19}$.
  Strike C5′(ii) and the range computation loses its lower limit.
- **`lem:scaleinv`** — *"C5′(ii)$\wedge$(P-g) leave $h_x\in(n^{-0.44},n^{-0.128})$"*, from which
  $\omega_n^2\in(n^{0.208},n^{0.52})$, $\bar m_n\in(n^{0.848},n^{1.16})$, and *"at $n=2000$ an
  inflation between about 5 and about 50"* all follow.

**The error was of method:** *"I grepped `proofs.tex`, found the two `lem:aerr` lines, and wrote a
corpus-wide 'no live consumer' verdict on a one-file measurement."* The `lem:scaleinv` site
predates round 15, so the claim was false when made. **Had the theorist obeyed the report, C5′(ii)
would have been retired and two printed computations left without a lower limit.**

**Standing method correction:** a "no consumer" verdict now requires a grep of *every* `.tex` file
**and** a read of the surrounding environment, because this corpus consumes assumptions
**arithmetically inside printed prose** as well as through hypothesis lists.

---

## 1. Dispatch-19 verification: **16 of 16 CONFIRMED**

Zero NOT DONE, zero DONE BUT WRONG — *"the cleanest fix report I have audited on this corpus."*

Highlights: C1(i)'s note struck and replaced, with `lem:aerr` carrying the reciprocal claim and
`prp:phirate` narrowed C1 → C1(ii); the three-retention-note audit confirmed (C1(i) FALSE,
B1(vi) FALSE-on-register/TRUE-on-mathematics, A5(v) TRUE — **and understated: five declaring
sites, not three**); A1d's "sole consumer" and A2c's "exactly one consumer" both **TRUE**; the new
Part-VI status block present; B1(vi) closed at **six** locations; the header corrected to four
retirements on three grounds with a new register rule; A1b(i)'s binding list now includes
`thm:rootn`, and no other clause carries a comparable declaration.

## 2. Retirement hygiene — **all four COMPLETE, first clean round**

| Retirement | Struck | No list carries it (incl. block cite) | Nothing calls it live | Verdict |
|---|---|---|---|---|
| A3 | ✓ | ✓ | ✓ | **COMPLETE** |
| A6 | ✓ | ✓ | ✓ | **COMPLETE** |
| A2′(ii) | ✓ | ✓ | ✓ | **COMPLETE** |
| B1(vi) | ✓ | ✓ (`prp:phirate` reads B1(i)–(v)) | ✓ (six locations) | **COMPLETE** |

**But the new register rule reaches further than the retirements** — see N-10, which is that rule
failing its first application to a non-retired clause.

---

## 3. New findings — three of four come from the text the fixes added

**N-7 (−15). `lem:unifop`(3c) invokes C1(ii); C1 is on no clause of its hypothesis line.**
**[VERIFIED]** the list reads A0, A1b(iv), A4(iii), B1(i),(ii),(iv.c), C2′, C3, C5′(i) — **no C1**.
The dispatch-18 separability paragraph reads *"unique, since C1(ii)'s $\|1/\pi\|_\infty<\infty$
makes $\pi$ strictly positive"*. Uniqueness is load-bearing: without it an $L^2(\pi)$ class can
carry two continuous representatives with different sup-norms, so $\|\cdot\|_\infty$ on
$\mathcal V_n$ — the norm the whole $\epsilon_0$-net runs in — is not well defined.
**The paragraph written to close a silent-invocation defect silently invokes an unassumed clause.**
Imported by three further suprema. (The regularity-checker found this independently as its MINOR 5,
adding H1 and the Sobolev embedding to the list.)

**N-8 (−10). $\mathcal S_n\subset H^s$ invoked at four sites, no named assumption** — the same
defect the regularity-checker raised to CRITICAL, reached by a different route and a different
witness ($s=2.6$, $m=3$). Two sub-findings:

1. **The `eq:jackson` pointer runs the wrong direction.** It states $\inf_{\varkappa\in\mathcal S_n}\|\zeta-\varkappa\|_{L^2}\le CL_x^{-s}\|\zeta\|_{H^s}$ — how well splines *approximate* $H^s$ functions. What is needed is that splines *lie in* $H^s$. **Approximation power does not give membership.**
2. **A8 may be a half-order short.** *"Order exceeding $s$"* under the standard convention gives $\mathcal S_n\subset H^\sigma$ iff $\sigma<m-\tfrac12$, so $m>s$ fails whenever $s\in(m-1,m-\tfrac12]$. **[VERIFIED]** `proofs.tex` uses the identical phrase for the direct theorem — i.e. it is calibrated to approximation, not membership, *which is why the two came apart*.

**N-10 (−10). Three hypothesis lists block-cite C5′ in full, against a brand-new printed paragraph
saying nothing should.** The status block states *"Nothing cites C5′(iii) and nothing should"* and
*"there is nothing for a proof to cite [C5′(iv)] for."* But `lem:aerr`, `prp:phirate` and
`rem:rootnhyp`(3) all carry **C5′** as a block — and dispatch 19's own register rule says a block
citation of the parent tag **is** a citation of every clause. **So the paper's only theorem
inherits two clauses the block declares uncitable.** The same dispatch narrowed B1 and C1 on that
line and left C5′ and A4. Two of five narrowed, three not.

**N-9 (−3). (R-a)'s new sure-boundedness conjunct is not needed by any conclusion, by the clause's
own text**: *"**Nothing was broken by the omission**: at both sites the envelope appears only on the
right of an inequality."* Either strike the conjunct and keep the $O_P(1)$ display, or strike the
two proof sentences. **Both cannot be minimal.**

**N-11 (−3). `lem:unifop` consumes A8's basis clause at (3d)** — the inverse inequality carrying
the entire sieve entropy bound — **but A8 is absent from its "Suppose" line**, appearing only in a
parenthetical. A reader building the matrix from "Suppose" lines misses it.

## 4. Open, known not attempted

**N-2 (−8)** A1b(iv) idle at four results — re-measured: 44 citations, **zero** in the four listing
proofs. **F-5 (−7)** `lem:opnoise` reads C5′(i) at the retired bandwidth, twice; **the correct
reading already exists 150 lines below and in the lemma's own statement**. **N-3 (−5)**
`lem:opnoise` block-cites C2′ using only (ii) — and it is the one site not covered by transitivity.
**N-6 (−2)** (P5) states no density tag.

## 5. Unused clauses

| Clause | State | Charged? |
|---|---|---|
| A5(v) | Unused; declared at **five** sites | No — the model |
| C4′ | Unused; $\ell_n,\kappa_n$ measured at **0** occurrences outside its own statement; now declared | No — remedy delivered |
| C5′(iii), C5′(iv) | **0** citations; declared | No as unused — but see **N-10** |
| C5′(ii) | **Not unused** — two live arithmetic consumers | No — the auditor's own error |
| C1(i) | One live consumer (`lem:aerr` Step 2); declared correctly | No |

**Round-15's F-1+ (−10) is CLOSED.** The remedy asked for — a status sentence of the kind A5(v)
carries — was delivered for all five, uniformly, with the register distinction (inert ≠
unavailable) stated.

## 6. Deduction table

| # | Finding | Class | Ded |
|---|---|---|---|
| N-7 | `lem:unifop`(3c) invokes C1(ii); C1 on no clause of its list | Unstated (NEW, from dispatch-18 text) | −15 |
| N-8 | $\mathcal S_n\subset H^s$; wrong-direction pointer; A8 half-order short | Unstated (NEW) | −10 |
| N-10 | C5′ block-cited against the new paragraph's own text | False usage claim (NEW, from dispatch-19 text) | −10 |
| N-2 | A1b(iv) idle at 4 results | Over-strong (open) | −8 |
| F-5 | `lem:opnoise` reads C5′(i) at the retired bandwidth | Stale ground (open) | −7 |
| N-3 | `lem:opnoise` block-cites C2′, uses (ii) only | Over-strong (open) | −5 |
| N-9 | (R-a)'s sure-boundedness conjunct surplus per its own text | Over-strong (NEW) | −3 |
| N-11 | `lem:unifop` consumes A8 at (3d); A8 absent from "Suppose" | Register (NEW) | −3 |
| N-6 | (P5) states no density tag | Unstated (open) | −2 |
| | | **Total** | **−63 → 37** |

**Read the direction.** Four findings worth **−43** closed cleanly and 16 of 16 dispatch-19 claims
verified. The score moves two points because three of four new findings come from the new printed
text, and one round-15 finding was a false positive that cost a dispatch. **The artifact is
materially better than at round 15; the audit surface grew with it.**

## 7. Not verified

Whether A1b(iv) is needed *implicitly* in the four proofs that list it (measured: not cited).
Whether `lem:unifop`(3c)'s appeal to `eq:wbounds` needs A4(i)'s **lower** propensity bound.
The order-vs-degree convention in A8 — arithmetic stated, convention left to the theorist.
Whether H1's $\mathcal D$-generated Hilbert scale coincides with the standard Sobolev scale at
every site reading $H^s\hookrightarrow C(\mathcal X)$ — a regularity-checker question.
