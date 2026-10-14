# Theory Audit — `prp-lepskii` FINAL (round 6)

**Target:** Proposition `prp-lepskii` (Lepskii oracle inequality).
**Source:** `/Users/samuele/Library/CloudStorage/Dropbox/Nonparametric_IV/Volatility/Centorrino_Florens_VOL_1.qmd`
  - Statement: L614-621
  - Proof: L1205-1246
**Date:** 2026-05-17.

## Summary

| Critic | R3 (terminal) | R4 | R5 | **R6** | Δ from R3 |
|---|---:|---:|---:|---:|---:|
| notation-warden | — | 61 | 95 | **99/100** | — |
| assumption-auditor | 32 | 80 | 97 | **100/100** | +68 |
| regularity-checker | 32 | 58 | 72 | **96/100** | +64 |

**Aggregate: 98.3/100.** From terminal 69 to submission-clear in three rounds.

## Gates

| Gate | Threshold | Verdict |
|---|---|---|
| Commit | ≥80 | **PASS** (98.3) |
| PR | ≥90 | **PASS** (98.3) |
| **Submission** | ≥95 + all components ≥80 | **PASS** (all components ≥96) |
| Theory binary gates | no critical findings | **PASS** |

## All eight audited objects at submission grade

| Object | Final | Rounds |
|---|---|---|
| `prp-onetoone` | 99 | 1 |
| `prp-condcomp` | 97 | 1 |
| `prp-convlf` | 96 | 7 |
| `prp-koper` | 97 | 2 |
| `thm-mainconv` | 100 | 2 |
| `lem-itervar` | 97 | 2 |
| **`prp-lepskii`** | **98** | **6** (1 R5 escalation rolled back, then resolved upstream) |

## How the R5 structural impasse dissolved

R5 escalation had stuck `prp-lepskii` at 69/100 terminal, citing "source-condition preservation under non-co-diagonalisable operators" as architectural. After upstream cleanup of `eq-Bbias` (Option B source-condition route) and `lem-itervar` (event preamble + range-membership), the regularity-checker confirmed:

> "The R5 escalation concern dissolves. The proof now compares $\hat b'_k$ and $\hat b'_{m^*}$ via deterministic-bias and per-iterate-variance bounds, both with respect to a fixed reference operator $\mathsf{T}'^*_{b_\dagger}\mathsf{T}'_{b_\dagger}$."

The architectural concern was a symptom of muddled upstream substrate, not a genuine obstacle.

## Residuals (all cosmetic, single-line)

- L154 bare $P$ inside CDF definition (-1 notation).
- L1240 off-event absorption arithmetic not shown explicitly (-2 regularity).
- L1221 redundant Markov bound preface (-1 regularity).
- L1231 missing bridge to L616 about $\tau_0$ threshold (-1 regularity).

None block submission.

## Pattern observation

Top-down cleanups on heavy theorems are tempting but rarely productive when the upstream substrate is unclean. The right move was bottom-up: fix `eq-Bbias`, harden `lem-itervar`, simplify `thm-mainconv`, and `prp-lepskii` reconfigured itself. R5's structural lament about non-co-diagonalisable operators was an artifact, not a theorem.
