# Assumption-Usage Audit — `prp-convlf` postfix3

**File:** `/Users/samuele/Library/CloudStorage/Dropbox/Nonparametric_IV/Volatility/Centorrino_Florens_VOL_1.qmd`
**Date:** 2026-05-15 (post-fix round 3). Reviewer: assumption-auditor agent.
**Trajectory:** 76 → 87 → 88 → **96/100** (+8).

## Section 1: Updated usage matrix

| Assumption | Statement | In hypothesis block (L440)? | Invoked at | Strength |
|---|---|---|---|---|
| `ass:identif` | Local identification of $b_\dagger$ on $\mathcal{B}_{b_\dagger}$ | YES | L1049 | Full |
| `ass:initcond` | $b_0 \in \mathcal{B}_{b_\dagger}$ | YES | L1028, L1049 | Full |
| `ass:sourcecond` | Hölder source condition (defines $\mathcal{B}^*_M$) | **YES (added)** | L1028, L1039 | Full |
| `ass:linkcond` | $(\mathsf{T}'^*_{b_\dagger}\mathsf{T}'_{b_\dagger})^{1/(2a)} \sim D^{-1}$ | **YES (added)** | L1028 | Full |
| `ass:unifbd` | Uniform bounds | Implicit (via `ass:identif` framing + radius hypothesis) | L1039 (via $c_1$ kernel-difference) | Full |
| Radius scaling $c_1 R^2 \le M$ | Local-id radius small enough | **YES (added)** | L1039 | Full |
| Step-size $c\sup\Vert\mathsf{A}^*_b\mathsf{A}_b\Vert<1$ | Strict step-size | YES | L1049 | Full |
| eq-lfconv $\le 1/M_{\text{lf}}$ | Singular-value comparability | YES | L1043 | Full |

## Section 2: Findings

- **N-1 RESOLVED.** `ass:linkcond` is now in the hypothesis block.
- **R-2 RESOLVED.** Radius condition $c_1 R^2 \le M$ is now an explicit hypothesis at L440.
- **`ass:sourcecond` newly added — USED.** Not unused: proof at L1028 uses $\mathcal{B}^*_M$; L1039 uses source-condition control. Legitimate use.
- **Residual: `ass:unifbd` not named in hypothesis block (-2 MINOR).** The proof at L1039 invokes `ass:unifbd`(i)-(iii) via the kernel-difference bound. Currently absorbed into the radius-scaling hypothesis which names $c_1$ from sec-annexA2 (which depends on `ass:unifbd`). Stylistic gap, not a logical hole.

## Section 3: Score

**96 / 100** (prior 88, +8).

| Item | Severity | Deduction |
|---|---|---|
| `ass:unifbd` not in hypothesis list | MINOR | -2 |
| Radius "automatically delivered" wording (residual phrasing) | MINOR | -2 |

## Section 4: Verdict

Both N-1 and R-2 are cleanly closed. The hypothesis block at L440 now lists all four primary assumptions used in the proof. The only residual is a stylistic gap: `ass:unifbd` is invoked via the kernel-difference constant $c_1$ but not named directly. **One-token fix:** "Let Assumptions \ref{ass:identif}, \ref{ass:initcond}, \ref{ass:unifbd}, \ref{ass:sourcecond}, and \ref{ass:linkcond} hold." Would lift to 98/100.

Submission-component threshold (≥80) cleared with margin. Both PR (≥90) and submission (≥95) thresholds cleared.
