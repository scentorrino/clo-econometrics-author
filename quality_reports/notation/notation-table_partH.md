<!-- RECOVERED 2026-07-30 from subagent transcript agent-abd1ed172a63074ba.jsonl.
     This report was produced on 2026-07-29 but the orchestrator never wrote it to disk.
     The gap was discovered when the consolidated gating fix round reported the file absent
     and worked from relayed content instead. Body below is the agent's final report verbatim;
     only this banner was added. Second recorded instance of an unpersisted narrow-critic
     report (cf. proofs_review_dispatch3.md). -->

# Notation Warden — Re-sweep of `panel-npiv-discrete`, Part H + three fix rounds

**Artifacts audited (all read, none edited):**
- `/Users/samuele/Documents/github_repo/clo-econometrics-author/quality_reports/theory/panel-npiv-discrete/results.tex`
- `/Users/samuele/Documents/github_repo/clo-econometrics-author/quality_reports/theory/panel-npiv-discrete/proofs.tex`
- `/Users/samuele/Documents/github_repo/clo-econometrics-author/quality_reports/theory/panel-npiv-discrete/assumptions.tex`
- `/Users/samuele/Documents/github_repo/clo-econometrics-author/quality_reports/theory/panel-npiv-discrete/notation_glossary.md`
- `/Users/samuele/Documents/github_repo/clo-econometrics-author/paper/sections/theorems/` (5 files)
- `/Users/samuele/Documents/github_repo/clo-econometrics-author/scripts/render-sync/check_rendering_sync.py` (read for the lane question only)

**Score: 0/100 (floored). GATE BLOCKED.**

Before the detail, one calibration statement, because a 0 next to Part H's 92 needs explaining. The 92 is a proof-completeness score and I do not contest it — I checked no proof. My three rules are mechanical and I found **seven** glyphs carrying two or more live referents. Seven × −15 = −105, plus −6 typography, floors at 0. **The seven are not seven defects. They are one defect with seven instances**, and the answer to the question the theorist-critic handed me is: *no, $\mathcal L$ is not the only such case, and it is not the worst one.*

---

## Section 1: Notation Table

I have restricted the table to Part H's new surface plus every glyph implicated in a finding. Symbols with a correct, current glossary row and a single referent are omitted for length; I verified them and they are clean.

### 1a. Part H's declared new surface (audit result: registered and single-referent)

| Symbol | Type | Definition | First defined (file:line) | Used in |
|---|---|---|---|---|
| $\omega_n$ | scalar sequence | normalising factor $2(2c_C)^{1/2}\mathsf c_2^2c_\Pi\|1/\pi\|_\infty^{1/2}h_u^{-1}h_x^{-1/2}$ | `results.tex:3106` (`eq:normconst`) | `def:lfstep`, `lem:scaleinv`, `lem:pathcont`, `prp:phirate` |
| $\Omega(\varphi,\tilde\varphi)$ | operator family on $L^2(\Pi)$ | range-invariance intertwining family | `results.tex:2593` | `prp:norangeinv` + proof — **see V-2** |
| $\mathsf c_{14},\mathsf c_{15}$ | constants (**analyst inputs**) | schedule constants, chosen before data | `results.tex:3125` | `eq:lfsched`, `eq:fixedpoint`, (L3), Step 3/4 |
| $\mathsf c_{16}$ | constant (**analytic output**) | collects (N1),(N2), projection constants | `proofs.tex:3987` (`eq:effnoise`) | Step 1, (L3) |
| $\mathsf c_{17}$ | constant (**analytic output**) | $:=2c_\mu\mathsf R^{1/(2\mu+1)}$ | `proofs.tex:4083` (in `eq:linlftot`) | Step 3, Step 4 — **see V-9** |
| $\bar m_n$ | integer | iteration cap, $\ge\omega_n^2\hat\delta_n^{-2}$ | `results.tex:3118` (`eq:cap`) | `def:lfstep`(c), (L4) |
| $\hat\delta^{\rm eff}_{n,k},\hat\varepsilon_k$ | deterministic sequences | computable stagewise schedule | `results.tex:3127` (`eq:lfsched`) | `def:lfstep`, (L3),(L4), Step 3/4 |
| $\delta^{\rm eff}_{n,k}$ | random sequence | *exact* (unobservable) stage data error | `proofs.tex:3986` (`eq:effnoise`) | Step 1, (L3) |
| $\varsigma_0$ | exponent in $(0,1)$ | preliminary's rate exponent | `proofs.tex:4157` (`eq:prelimrate`) | (P-a), Step 4 |
| $\mathcal S_n$ | $L_x$-dim. subspace | $\operatorname{span}(b_1,\dots,b_{L_x})\cap\mathcal V$ | `results.tex:3104` | all of Part H.4–H.5 |
| $v_\dagger,\bar v_\dagger$ | elements of $\mathcal V$ | $\vdagger-\varphi_\circ$; its $\mathcal S_n$-projection | `proofs.tex:3933`, `3960` | Steps 1–4 |
| $y^\delta$ | element of $L^2(\Pi)$ | $-\omega_n^{-1}\hat T_{h_x}(\varphi_\circ,\theta_\dagger)$ | `proofs.tex:4007` | (L1)–(L5) |
| $\varphi_\circ$ | element of $\mathcal V$ | generic ball centre; **frozen** $\hat\varphi^{(k-1)}$ in Part H.5 | `results.tex:2459`; re-fixed `proofs.tex:3933` | `def:a6b`, `prp:tccrepair`, `prp:phirate` |
| $\underline\lambda_n$ | scalar $>0$ | $\inf_{\varphi\in\mathcal V(\varphi_\circ,\rho_0)}\lambda_{\min}(\mathbf G_n(\varphi))$ | `results.tex:2508` | `prp:tccrepair`(ii), proof |
| $\kappa$ | constant in $(0,1)$ | $2\mu/(2\mu+1)$ | `results.tex:3126` | `eq:lfsched` onward. Row at glossary:389; separation from $\kappa_n$ correct |
| $\mathsf R$, $\gamma_n$, $\mathbf G_n(\varphi)$, $\hat\varphi^{(k)}$, $n_{\rm m},n_{\rm a}$, $\mathsf C_{h_u},\mathsf C_{h_x}$, $\Delta_{h_x}$, $\hat T_{h_x}$, $\mathrm d\hat T_\varphi[\cdot]$, $\mathfrak m_{p_K}$, $\mathcal V(\varphi_\circ,\rho)$ | — | as C49–C65 | as glossary §5 | **all verified single-referent and correctly registered** |

### 1b. Glyphs carrying two or more live referents

| Symbol | Referent A (file:line) | Referent B (file:line) | Register status |
|---|---|---|---|
| $\mathcal L$ | **un**scaled operator, with $\mathcal L_\omega:=\omega^{-1}\mathcal L$ — `results.tex:3046–3049`, `proofs.tex:3861–3899` | **scaled** operator $\omega_n^{-1}\hat{\mathcal A}_{\varphi_\circ}\vert_{\mathcal S_n}$, $\|\mathcal L\|\le1$ — `proofs.tex:4006`, `3695`, `3719` | **No row anywhere.** Not §1.6, not §1.7, not §5 |
| $\Omega$ | intertwining family (2 args) — `results.tex:2593` | connected open set $\subseteq\IR^p$ — `paper/sections/theorems/lem-bierens.tex:101–103`; and bare abbreviation — `proofs.tex:3116–3203` | C66 claims the letter; declares the local withdrawn and the 2 args mandatory |
| $\omega$ | sample point of $(\Omega,\mathcal F,P)$ — `proofs.tex:187,221–228,254,286,361–369,803,934`; `results.tex:726`; `lem-adjoint.tex:166,179`. Also the realised value of $W$ — `assumptions.tex:1794` | generic Landweber scale — `results.tex:3050` | C67: *"lowercase $\omega$ occurs in no file of this project"* — **false** |
| $\delta$ | radius in $\sup_{\|h\|\le\delta}$ — `results.tex:2050,2066,2084`; `proofs.tex:2589,2615` | data-error level — `results.tex:3047,3060,3067`; `proofs.tex:3720–3730`; superscript in $y^\delta$ | Glossary:449 names **only** referent A |
| $\varepsilon$ | stage error $\|\vdagger-\hat\varphi^{(k-1)}\|_{L^2(\pi)}$ — `proofs.tex:3934,3987,4030` | generic positive margin — `proofs.tex:3416–3420`; `lem:formstruct`(ii) | §1.7:297 documents $\varepsilon_k,\hat\varepsilon_k,\varepsilon_\varrho,\epsilon_n$; **bare $\varepsilon$: no row** |
| $\mathsf a$ | $\mathsf a_n$ divergent inflation factor — `proofs.tex:3409–3412`; $\mathsf a_1,\mathsf a_2$ Hoeffding endpoints — `3552–3557` | $\mathsf a_k:=\log(1/\hat\varepsilon_k)$, $\mathsf a^\ast$ — `4142–4196` | C62 records *"no symbol for the discrepancy inflation factor"* — **false**; C60's sans-serif range is $\mathsf c_i$+$\mathsf M$ only |
| $\alpha$ | **binding** rate exponent $\alpha:=r/(2r+d_Z)$ — `assumptions.tex:1893–1894`; budget table `results.tex:2079–2135`; `eq:lxwindow:3265`; `eq:prelimrate` | multi-index — `proofs.tex:507–531`; generic $L^2(\Pi)$ element — `proofs.tex:2836–2856`; product factor — `457` | §1.6:263 declares $\alpha$ a **reserved local** — a **C25 violation** |

### 1c. Locals introduced in Part H with no §1.6 row (all defined in place; register gaps)

$\mathsf a_n,\mathsf a_1,\mathsf a_2,\mathsf a_k,\mathsf a^\ast$; $\mathsf b$ (`proofs.tex:3546`, in `lem:bdiff`'s **statement**), $\mathsf b_n$ (`4146`); $\mathsf s$ (`3546`, statement); $\mathsf V_n$, $\mathsf Z$ (`3398–3411`); $\mathsf z_i(\varphi)$ (`3143`, and used *inside the glossary's own $\mathsf D_n$ row*, glossary:247); $\mathsf q(h)$ (`3033`); $\mathsf T,\mathsf A$ (`3060`); $\Theta_1$, and bare $\Theta$ (`2787`); $\underline\lambda_n$; $\beta$ as bandwidth exponent (`4167–4180`).

`§1.6`'s $\mathsf M$ row says "in `lem:srctransfer`(ii) only" — $\mathsf M_\epsilon$ is live in `lem:opnoise`'s proof at `proofs.tex:3396, 3410`.

---

## Section 2: Violations

**Collisions (−15 each) — 7 found, −105**

- **V-1. $\mathcal L$: two referents, and (L5) is the site where they meet.** `lem:scaleinv` fixes $\mathcal L$ = pre-normalisation operator (its own rationale paragraph, `results.tex:3082–3084`, turns on $\|\mathcal L\|$ *diverging*) and $\mathcal L_\omega=\omega^{-1}\mathcal L$. `prp:phirate` Step 2 sets $\mathcal L:=\omega_n^{-1}\hat{\mathcal A}_{\varphi_\circ}\vert_{\mathcal S_n}$ — the scaled one, $\|\mathcal L\|\le1$ at (L1). (L5) at `proofs.tex:4066–4069` cites `lem:scaleinv`(iii) and concludes $\bar v_\dagger\in\mathcal R((\mathcal L^\ast\mathcal L)^\mu)$ with radius $\omega_n^{2\mu}\mathsf R$ — which in the lemma's letters is a statement about $\mathcal L_\omega$. The reader must silently apply lemma-$\mathcal L_\omega\mapsto$Step-2-$\mathcal L$ and lemma-$\mathcal L\mapsto\hat{\mathcal A}_{\varphi_\circ}\vert_{\mathcal S_n}$. Same at (L2) (`4022`) and (L4) (`4047`). Confirmed as reported. Two aggravating facts the handoff did not have: $\mathcal L$ has **no glossary row at all**, and there is a third reading — an arbitrary bounded operator, universally quantified, in `prp:tccfails`'s proof (`proofs.tex:2950–3011`), where it co-occurs with $\eta_{\rm TCC}$ four lines from `3004`. C33's doctrine is that the local doctrine gives no cover when declarations sit in proofs that cite one another; `prp:phirate` cites `lem:scaleinv` five times.

- **V-2. $\Omega$: the withdrawn local is alive in the renderings tree.** C66 withdrew bare $\Omega$ as the connected open set of the identity theorem and wrote it out at `proofs.tex:522–528`, saying explicitly "*so that the letter $\Omega$ is free for `prp:norangeinv`*". It is not free: `paper/sections/theorems/lem-bierens.tex:101–103` still reads "a real-analytic function on a connected open set $\Omega\subseteq\IR^p$ … With $\Omega=\IR^p$". The C66 sweep covered the theory tree and not the renderings. Additionally, C66's own rule — "$\Omega$ never appears without its two function arguments" — is breached inside the proof C66 was written for: `proofs.tex:3116` "Write $\Omega:=\Omega(\varphi,\varphi')$", then bare $\Omega$ at `3118, 3120, 3122, 3203`. **This is the fourth recurrence of a withdrawal recorded and not swept, and the first that lands outside the theory tree.**

- **V-3. bare $\omega$: C67's slot sweep is false in the binding voice.** C67 states "*Slot swept: lowercase $\omega$ occurs in no file of this project.*" Bare $\omega$ is the sample point at ~16 live sites in `proofs.tex` (including `proofs.tex:228`, "*The argument $\omega$ is suppressed*"), at `results.tex:726` inside `lem:adjoint`(iii)'s **statement**, and at `lem-adjoint.tex:166,179`. `assumptions.tex:1794` is a further referent — the realised value of $W$ in $f_{\Delta Y\mid\cdots,W}(u\mid x_1,x_2,z,\omega)$ — which also breaches the $W$ row's rule that the realised value "is written $0$ or $1$, never $w$" (glossary:316). The measurability chain carrying sample-point $\omega$ is what `prp:phirate` Step 1's (N1)/(N2) rests on, so both referents are in one reading path. **This is the direct analogue of Finding D: the pass reasoned at length about the rejected alternative $\varsigma_n$ and about the $\Omega$ case pair, and did not grep the letter it claimed.**

- **V-4. bare $\delta$: the registered meaning was not amended.** Glossary:449 gives $\delta$ = "radius in $\sup_{\|h\|\le\delta}$", live in Part G (`results.tex:2050,2066,2084`; `proofs.tex:2589,2615`) and quoted as binding in **§8.4 item 3** — the section the dispatch says a Step-7 author reads as binding. Part H reuses bare $\delta$ as the data-error level in a lemma statement (`results.tex:3047–3048`), in `eq:scaleinv`, in `rem:ff`/`eq:ff`, and as the superscript of $y^\delta$. No slot was claimed and no row amended.

- **V-5. bare $\varepsilon$: stage error vs. generic margin, both inside Part H.** `proofs.tex:3934` sets $\varepsilon:=\|v_\dagger\|_{L^2(\pi)}$ and `eq:effnoise` and (L3) run on it; `proofs.tex:3416–3420` (`prp:stopfeas`(iv), cited by (L4)) uses bare $\varepsilon>0$ as a frontier margin. §1.7:297 was written precisely to separate the $\varepsilon$-family by hat, word subscript and lunate glyph, and has no row for the bare glyph.

- **V-6. sans-serif $\mathsf a$: four referents, and C62's decline is nominal.** C62 declined italic $a_n$ for the discrepancy inflation factor because it sits "one subscript from the RESERVED degree of ill-posedness $a$", and recorded "**no symbol** for the discrepancy inflation factor". `proofs.tex:3409–3412` names it: "*Taking $\mathsf a_n=\tau_{\rm DP}\ln n$ gives* `eq:a7amend`". One font over is not no symbol. $\mathsf a_1,\mathsf a_2$ (Hoeffding endpoints, `3552–3557`) and $\mathsf a_k$/$\mathsf a^\ast$ (`4142–4196`) are two and three more. $\mathsf a_n$ and $\mathsf a_k$ differ only by index letter — both index subscripts — so the subscript-*type* device §1.7 uses six times cannot separate them, and `eq:a7amend` is consumed at (L4), one citation from Step 4.

- **V-7. $\alpha$: a §1.6 local made binding — a C25 violation.** `assumptions.tex:1893–1894` defines $\alpha:=r/(2r+d_Z)\in(0,\tfrac12)$ inside C5′(i). It then governs the smoothness-budget table (`results.tex:2079–2135`), `eq:lxwindow` (`3265`), `eq:prelimrate` (`proofs.tex:4157`) and all of Step 4. §1.6:263 lists $\alpha$ among the **reserved local bound variables** ("multi-indices, and the factors of a product function"). C25's rule is *"A local symbol may not be made binding; when one was, the binding use moved instead"* — the rule invoked to move $\vartheta$ in round 7 and invoked again to reject $\varsigma_n$ in C67's own reasoning. It is breached on $\alpha$, which also carries the multi-index reading (`proofs.tex:507–531`) and a generic-$L^2(\Pi)$-element reading inside Part H's own `prp:hatAprop` proof (`proofs.tex:2836–2856`). Bare $\beta$ is the same defect one degree weaker (bandwidth exponent, `proofs.tex:4167–4180`).

**Undefined on first use (−5 each): 0 found. −0**

Every symbol Part H introduces is declared at its first appearance, including the ones with no register row ($\mathcal L$, $\mathsf a_k$, $\mathsf b$, $\mathsf s$, $\mathsf V_n$, $\mathsf z_i$, $\underline\lambda_n$, $\Theta_1$, $y^\delta$, $v_\dagger$, $\bar v_\dagger$, $\varphi_\circ$). I checked reading order across `assumptions.tex` → `results.tex` → `proofs.tex` for each. **This is a genuine strength and it is why every finding above is a register/collision finding rather than a comprehension failure.**

**Typography inconsistency (−2 each): 3 found. −6**

- **V-8.** $\eta$ and $\eta_{\rm TCC}$ for **one constant**. Rule: C8, C23, glossary:448 — "word subscript never omitted". Bare $\eta$ in the **statements** of `def:a6b` (`results.tex:2467,2468,2471`) and `prp:tccrepair` (`2487,2497–2500,2508–2515`) and their proofs (`proofs.tex:3060–3066,3089–3092,3109`); $\eta_{\rm TCC}$ in A6 (`assumptions.tex:1657–1667`), `prp:tccfails` (`results.tex:2330–2378`). `prp:tccrepair`(i) prints both in one clause: "$\eta_{\rm TCC}=\eta$".
- **V-9.** $\mathbf G_n$ with and without the argument C54 declares mandatory and "load-bearing": bare at `results.tex:2210` and `2453`, against `eq:gram`'s $\mathbf G_n(\varphi)$.
- **V-10.** $\mathsf c_{17}$'s defining display is mis-cited. `def:lfstep` (`results.tex:3140`), `rem:phirscope`(5) (`3457`), glossary C68 and §1.7:301 all say $\mathsf c_{17}$ is "the constant of `eq:linlf`". It is introduced at `proofs.tex:4083` for **`eq:linlftot`**; `eq:linlf`'s constant is $c_\mu$. The parallel wording with $\mathsf c_{16}$ (which does appear inside `eq:effnoise`) makes the asymmetry a trap on the one constant a Step-7 author must set.

**Verified clean (rule 3):** $\mathbb E/\mathbb P/\Pr$ appear **nowhere** in the theory tree — bare $E$, bare $P$ without exception. Bold roman is reserved to sample matrices ($\mathbf B,\mathbf D,\mathbf G_n$) and no $\IR^p$-valued object is ever set bold, consistent with C18/§8.4 item 1. `\operatorname` vs `\mathrm` (C37) holds. The only $\mathbb E$ in the repo is `paper/sections/theorems/dummy.tex:14`, whose header comment flags it as a fixture — correct handling, no deduction.

**Arithmetic:** $100-105-6=-11\Rightarrow$ **0/100 (floor).**

---

## Section 3: The three adjudications assigned to me

**3a. C67's $\Omega$ / $\omega_n$ case pair — APPROVED as reasoning, REJECTED as executed.**

The reasoning is sound and I endorse every step of it: $\varsigma_n$ was correctly rejected on both grounds (C25 forbids promoting the §1.6 local $\varsigma$; and $\varsigma_0$ of (P-a) is binding one subscript away, which is C34's species); $\omega$ *is* the regularisation literature's letter for a Landweber relaxation parameter and `lem:scaleinv`(i) proves the normalisation is one, so the reading is correct and not merely non-colliding; and the case pair with $\Omega$ passes on all four separators it claims — distinct glyphs, scalar against operator family, $n$-subscript against two function arguments, different results. $\gamma/\Gamma$ and $\pi/\Pi$ are fair precedent. **The case pair stands.**

What fails is the sweep attached to it. "Lowercase $\omega$ occurs in no file of this project" is false at ~18 live sites across all four artifacts and one rendering (V-3), and one of those sites (`assumptions.tex:1794`) is a fourth referent that also breaches the $W$ row. §1.5b's binding rule is *sweep for the letter being claimed*; C67 is the row that most conspicuously did not. **Remedy is the theorist's choice: either document the near-collision in §1.7 (bare $\omega$ = sample point, $\omega_n$ = relaxation parameter, never co-occurring) or move one. I do not propose which.** But the claim in C67 must be corrected either way, because a false sweep in a binding file is worse than no sweep — the next author trusts it.

**3b. The recorded $\mathsf c_{13}$ hole — ACCEPTED, no deduction, and I verified it is the only one.**

I enumerated the whole family across all files: $\mathsf c_0,\mathsf c_1$ (Part G), $\mathsf c_2$–$\mathsf c_{12}$, $\mathsf c_{14}$–$\mathsf c_{17}$. $\mathsf c_{13}$ is used nowhere; **$\mathsf c_7$ is used exactly once**, at `results.tex:2987` (the spline Bernstein constant), so it is not a second hole — I checked this specifically because a single-site constant is what a hole looks like from a grep. The hole is harmless: the $\mathsf c_i$ are locally declared at their sites, not a globally numbered family where a gap signals a missing definition, and C60 records it so no reader hunts. The only cost is that C60's *range* declaration "$\mathsf c_2,\dots,\mathsf c_{16}$" over-declares by one; the honest fix is to state the family by enumeration rather than by range, since a range is what let $\mathsf c_{13}$ and $\mathsf c_{16}$ be "declared" without being written. **No deduction.**

**3c. Priority-3 check: the $\mathsf c_{14}/\mathsf c_{15}$ vs $\mathsf c_{16}/\mathsf c_{17}$ role separation — COMPLETE.**

I traced all 47 occurrences. Every one is role-consistent: $\mathsf c_{14},\mathsf c_{15}$ appear only as inputs (`eq:lfsched`, `eq:fixedpoint`, $\mathsf b_n$, and the two dominance conditions); $\mathsf c_{16},\mathsf c_{17}$ only as analytic outputs (`eq:effnoise`, `eq:linlftot`, and the same two conditions from the other side). The "three jobs" defect is gone: (L3) is now $\mathsf c_{14}\ge\mathsf c_{16}$ (`proofs.tex:3996, 4030`), Step 3 is $\mathsf c_{15}\ge\mathsf c_{17}$ (`4113`), and `eq:fixedpoint` (`4117`) now carries both constants where the round-10 draft folded $\mathsf c_{14}^\kappa$ into $\mathsf c_{15}$. **`rem:phirscope`(5) (`results.tex:3451–3461`) matches exactly** — four inputs ($\hat\delta_n$, $h_u$, $\mu$ through $\kappa$, $\hat\varepsilon_0$), two analyst constants, both named, with the dominance requirement and the asymmetric failure mode stated. The only defect is V-10, the mis-cited defining display for $\mathsf c_{17}$.

**3d. Register integrity — a finding the dispatch did not ask for, in my lane, and it matters.**

The glossary contradicts itself about its own register, in the paragraph whose stated purpose is to prevent exactly that:

- Line 23–25: "**Slot inventory, so that the two records in this file cannot drift apart:** the register is a single sequence **C1–C67** … §1.5f holds **C66–C67**."
- Line 14: "**two slots** claimed in the dispatch-8 fix pass".
- Line 210: "§1.5f Dispatch-8 fix pass on Part H: slots **C66–C68**"; line 212: "**Three slots**"; line 215: "the register as a whole runs **C1–C68**"; line 222: a **C68** row exists; line 203: "Extended to $\mathsf c_{17}$ at **C68**".

I enumerated the rows: **C1 … C68, contiguous, no gaps, no duplicates.** So the header is wrong and §1.5f is right. Part H's *new* block is **C49–C65**; C66–C68 were added by the dispatch-8 fix pass. For the record, the dispatch's own framing to me ("the register runs C36–C65 plus C67") does not match the file either — C36/C37 are round-8 rows, and C68 exists.

Separately: the file runs **two namespaces on the same tokens** — "C1"–"C5′" are *assumption tags* (§7, glossary:496) and "C1"–"C68" are *collision-slot IDs*. There is no live ambiguity today only because no assumption tag reached two digits. This is the same shape as the "C36–C65 / C40–C65" confusion, one level up, and it interacts with the tooling (below).

---

## Section 4: Your question about my lane — the retired-phrase register

**I agree with the theorist-critic that this is a tooling gap and not a discipline gap, and I agree the row closes only part of it — but I disagree that it is the smaller part, and I can show why with today's evidence.**

**On the withdrawn-symbol row: adopt it, and it is worth more than "half".** V-2 is the fifth recurrence and the first outside the theory tree, and it is a **pure symbol withdrawal** — exactly what the proposed row catches. I traced it through the script:

- `CHECK 1` (blocking) compares **statements only**. The $\Omega$ occurrence is inside `\begin{proof}` at `lem-bierens.tex:71`, within `\begin{lemma}\label{lem:bierenscore}`. **Missed.**
- `CHECK 2` (advisory) would emit one undetailed line, "differs lem-bierens.tex: proof of lem:bierenscore", non-blocking.
- `CHECK 3` (blocking) sweeps `renders` — `sweep_targets = [results_tex, proofs_tex] + renders` at line 370 — so **a row would have caught it as BLOCKING**.

So on the four recurrences: the row catches C58's $\delta_n^{(k)}$ and C66's $\Omega$ outright, and it would also cover C64's two withdrawn $\varkappa$ uses and C62's/C49's declined slots. That is not the smaller half.

**On the retired-phrase register: I agree it is needed, and here is exactly what belongs in it.** My findings make the case sharper than "a claim corrected in one place out of N". The species that no symbol-level row can catch is: **a binding row that asserts a fact about the file which the file falsifies.** Three of today's seven findings are that species, and all three are undetectable by any symbol sweep because the *symbol* is fine:

| Register claim | File | Verdict |
|---|---|---|
| C67: "lowercase $\omega$ occurs in no file of this project" | ~18 sites | **false** |
| C62: "no symbol for the discrepancy inflation factor" | `proofs.tex:3412` names it $\mathsf a_n$ | **false** |
| §1.6: "$\mathsf M$ … in `lem:srctransfer`(ii) only" | `proofs.tex:3396, 3410` | **false** |
| §1.7:303: "$\varsigma$ … a generic scale in `lem:scaleinv`" | $\varsigma$ there is the source pre-image; the generic scale is $\omega$ | **false** — the row was written with C67's phrase pasted onto the wrong glyph |
| Glossary:449: $\delta$ = "radius in $\sup_{\|h\|\le\delta}$" | also the noise level, Part H | **incomplete** |
| §1.6:263: $\alpha$ is a reserved local | binding at `assumptions.tex:1894` | **false** |
| Glossary header: register is C1–C67, two slots in §1.5f | C1–C68, three slots | **false** |

**So the register should hold *checkable assertions*, not phrases.** Concretely, three row types, each mechanically verifiable:

1. **`OCCURS_NOWHERE`** — a glyph the register asserts is unused. Field: regex. The check greps all four artifacts plus the renderings and fails on any hit outside a `PROVENANCE_LINE`. Would have caught C67 and C62 the day they were written.
2. **`ONLY_IN`** — a symbol the register scopes to named results. Fields: regex + list of `\label` keys. The check fails on a hit outside those environments. Would have caught the $\mathsf M$ row, and would catch every future "*in X only*" and "*never appears without its subscript/argument*" claim — which is the project's single most common rule form (it appears in C19, C23, C26, C39, C43, C54, C55, C66, and the $\eta_{\rm TCC}$ row) and today is breached at three of them (V-2, V-8, V-9).
3. **`REGISTER_RANGE`** — the slot-inventory assertion, checked against the actual `^| **C\d+**` rows. Would have caught 3d.

**One defect in the existing guard, which the register must not inherit.** `PROVENANCE_LINE` includes `|\bC\d{2}\b` and is applied **per line**. This project's house style routinely puts narration and live mathematics on one line — `results.tex:3115` reads "…(P-a). Glossary C67.} By `\cref{lem:scaleinv}`(i)--(ii) this is a choice of relaxation parameter and changes neither the". Any retired glyph on such a line is invisible to CHECK 3, and a `C\d{2}` token is trivial to acquire. Combined with the two-namespace problem in 3d, an assumption tag reaching two digits would silently disable the marker project-wide. The provenance test should be scoped to the *sentence* or require the marker and the hit to be in the same `\emph{}` group — not the line.

---

## Section 5: What gates Step 7

**Blocking before a Step-7 author writes a line (each is a live two-referent glyph in the chain Step 7 builds on):**

1. **V-1 $\mathcal L$** — Step 7 will cite `lem:scaleinv` and `prp:phirate` together. The silent (L5) substitution is the one a new author reproduces without noticing.
2. **V-2 $\Omega$** — `paper/sections/theorems/lem-bierens.tex:101–103`. If a Part H section is ever `\input` alongside the renderings, $\Omega$ compiles with two meanings in one document.
3. **V-3 $\omega$ + the C67 correction** — Step 7 owns $\hat L$ and $\hat b$ (obligations O2/O3) and will write measurability arguments, which is where sample-point $\omega$ lives.
4. **V-7 $\alpha$** — Step 7 reads the smoothness-budget table. A binding rate exponent recorded as a reserved local is the C25 trap, and it is the one symbol that appears in every budget line.
5. **3d, the register self-contradiction** — the next dispatch partitions the slot register. It cannot partition a register whose two records disagree; that is precisely how C45–C48 collided with Part H's draft.

**Not blocking, fix in the same pass:** V-4 ($\delta$ row amendment), V-5 (bare $\varepsilon$ row), V-6 ($\mathsf a$ family + C62 correction), V-8/V-9/V-10, and the §1.6 completion for the ~14 unregistered Part H locals in 1c — including $\mathsf z_i$, which the glossary's own $\mathsf D_n$ row uses in its definition without a row of its own.

**Also flagging, no deduction:** `quality_reports/theory/panel-npiv-discrete/proofs_partH.tex` and `results_partH.tex` are pre-fix staging copies still carrying the withdrawn $\delta_n^{(k)}$ (`proofs_partH.tex:756–909`, `results_partH.tex:880`), the superseded one-constant `eq:fixedpoint` with $\mathsf c_{15}$ in the analytic role (`proofs_partH.tex:892`), and duplicate `\label{eq:effnoise}`, `\label{eq:linlf}`, `\label{eq:fixedpoint}`, `\label{eq:stagedecomp}`. They are outside my scored artifact set and outside `check_rendering_sync.py`'s `sweep_targets`, so they are invisible to every guard while sitting in the directory a Step-7 author opens. Whether they are archived or swept is the theorist's call.

**Not re-raised:** T1-2 ($\psi$) and T1-6 ($\ell_\dagger$). I re-read glossary rows 339, 363 and §8.5 and found no witness against either refutation. **$\vartheta'\psi$ in the $\sigma_q$ row is correct**, and I confirm it independently: $\psi$ there is the moment function in its RESERVED sense and $\vartheta'\psi$ is the scalar moment for $\vartheta'\theta_\dagger$, which is C25's own mnemonic.