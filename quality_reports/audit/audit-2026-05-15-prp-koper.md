# Theory Audit — 2026-05-15 (target: `prp-koper`)

**Target:** Proposition `prp-koper` (control of the empirical Fréchet derivative and its adjoint).
**Source:** `/Users/samuele/Library/CloudStorage/Dropbox/Nonparametric_IV/Volatility/Centorrino_Florens_VOL_1.qmd` (statement L519–530, proof L1051–1085).
**Mode:** AUDIT-IN-PLACE.

## Summary

| Critic | Score | Findings |
|---|---|---|
| **notation-warden** | **49 / 100** | 2 HIGH, 3 MEDIUM, 3 MINOR |
| **assumption-auditor** | **25 / 100** | 1 UNSTATED, **4 UNUSED**, 1 OVER-STRONG, 1 UNUSED |
| **regularity-checker** | **8 / 100** | **1 CRITICAL**, 6 MAJOR, 4 MINOR |

**Aggregate: 27 / 100.** BLOCKED at all gates.

## Critical findings (escalations)

**CRITICAL (regularity #1): L521 "almost surely" — $\hat M$ contains random $M_n$.**

Same as MN6 from earlier prp-lepskii audit. The constant $\hat M = M_2 M_3 + M_n M_X$ contains Dunker (2018)'s random uniform-consistency constant $M_n$. The "a.s." claim should be "w.p. $1 - o(1)$" or "on an event $\mathcal{E}_n$ with $\mathbb{P}(\mathcal{E}_n) \to 1$." This propagates to `thm-mainconv` Term III.

## Single most consequential issue: $M_n$ collision

$M_n$ has **two incompatible meanings** in the same paper, both used in `prp-lepskii`'s proof:

1. L1061 (prp-koper proof): $M_n$ = Dunker uniform-consistency constant (random).
2. L582, L604, L606, L615, L1158, L1167, L1171, L1179, L1187, L1191, L1195, L1210 (prp-lepskii proof): $M_n$ = maximum iteration index (Lepskii rule).

The prp-lepskii proof at L1167 invokes prp-koper(a) (which uses Dunker's $M_n$) while also using $M_n$ as the iteration cap. **Unresolvable from context. Critical rename needed.**

## Hypothesis block materially loose (assumption-auditor)

The dash-range `\ref{ass:identif}-\ref{ass:frediff}` at L520 misses `ass:unifbd` (which is *invoked twice* in the proof at L1063–1065 and L1084).

The block includes four UNUSED assumptions: `ass:identif`, `ass:initcond`, `ass:sourcecond`, `ass:linkcond` — none invoked in the prp-koper proof.

**Single-line fix:** Replace L520 with explicit list mirroring prp-convlf's style:
```
Let Assumptions \ref{ass:unifbd}, \ref{ass:frediff}, \ref{ass:app1}(ii), \ref{ass:app3a}, \ref{ass:app3b}, \ref{ass:app4}, \ref{ass:app5} hold.
```

## Detailed reports

- `quality_reports/notation/notation-table_prp-koper.md` (49)
- `quality_reports/assumptions/usage-matrix_prp-koper.md` (25)
- `quality_reports/regularity/regularity-audit_prp-koper.md` (8)

## Action items (priority order)

### CRITICAL
- [ ] **L521:** "almost surely" → "with probability $1 - o(1)$." Propagate to thm-mainconv references.
- [ ] **Global $M_n$ rename:** disambiguate between Dunker constant (L1061) and Lepskii iteration cap (L582+). Suggested: $C_{\text{D}}$ or $M^{\text{D}}_n$ for the Dunker constant; keep $M_n$ for the Lepskii cap (since it's used more often). Affects: L1061, L1063, L1064, L1068, L1070 (all in prp-koper proof).

### MAJOR (assumption-auditor)
- [ ] **L520 hypothesis block:** replace dash-range with explicit list adding `ass:unifbd` and dropping the four unused.

### MAJOR (regularity-checker)
- [ ] **L1057:** Justify kernel representation of $\hat{\mathsf T}'_b$ (Leibniz commutation).
- [ ] **L1062–1065:** Specify uniformity domain (in $(y, x, w)$? trimmed compact?).
- [ ] **L1061:** Verify Dunker (2018) Lemma 4 citation — likely should be Hansen (2008).
- [ ] **L1068:** State trimming on $\mathcal{X}$ + high-probability event $\{\inf \hat f_X \ge \tfrac12 \inf f_X\}$.
- [ ] **L1078:** Make dummies in $K$ definition explicit; verify $L^2$-boundedness via change-of-variables.

### MEDIUM (notation)
- [ ] **$M$ disambiguation:** Statement L529 fixes $M = M_2 M_3$; proof L1084 says "the uniform bound in `ass:unifbd`" (ambiguous). Pick one or rename.
- [ ] **L1059:** $\bar b_{jt}$ — define or fix typo (likely $\hat b_{jt}$).
- [ ] **L1080:** Replace $b \cdot Y$ shorthand with explicit $g(X) + e^{\omega(X)} Y$.

### MINOR
- [ ] KDEs ($\hat f_{Y,X|W}$ etc.) define inline.
- [ ] L1082 $h_u^{-2}$ Lipschitz derivation explicit.
- [ ] L525 $K$ operator norm specification.

## Net status

| Gate | Threshold | Verdict |
|---|---|---|
| Commit | ≥ 80 | **BLOCKED** (27) |
| Theory binary gates (quality.md §3) | no critical findings | **BLOCKED** (1 CRITICAL) |

## Comparison across audited propositions

| Proposition | Aggregate (final) | Rounds |
|---|---|---|
| `prp-onetoone` (post-fix) | 99 | 1 |
| `prp-convlf` (post-fix R7) | 96 | 7 (with rollback) |
| `prp-lepskii` (Round 3 terminal) | 69 | 3 (terminal) |
| **`prp-koper` (this audit)** | **27** | **0 (initial)** |

`prp-koper` is in the same league as `prp-convlf` was at its initial audit (62). The fix profile is similar — mechanical patches to hypothesis block + a.s./w.p. qualifier + uniformity domain — and should respond well to one or two focused rounds.

## Recommendation

The CRITICAL fix (L521 "a.s." → "w.p.") and the assumption-block fix (single line replacement at L520) together would lift the aggregate from 27 to ~75. Adding the $M_n$ disambiguation + the regularity-domain clarifications would push to ~90. Want to do those?
