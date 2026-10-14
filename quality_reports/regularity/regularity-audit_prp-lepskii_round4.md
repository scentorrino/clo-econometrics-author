# Regularity Audit — `prp-lepskii` (Round 4)

**Trajectory:** 32 → **58/100** (+26). R5 structural obstacle dissolved.
**Date:** 2026-05-17.

## R5 structural concern RESOLVED
> "The proof now compares $\hat b'_k$ and $\hat b'_{m^*}$ via deterministic-bias and per-iterate-variance bounds, both with respect to a fixed reference operator [$\mathsf{T}'^*_{b_\dagger}\mathsf{T}'_{b_\dagger}$]. The propagation issue is confined to `lem-itervar`'s proof."

## Citation-hygiene cluster (interlinked MAJORs, -30)
1. **L1215:** sub-exp tail attributed to `ass:app4` which gives only density floor.
2. **L1213/L616:** $\tau \asymp \sqrt{\log M_n}$ in proof vs $\tau \ge \tau_0$ constant in statement.
3. **L1226:** `ass:restrvarth` cited for off-event a-priori envelope; correct device is the $L^4$ induction in `lem-itervar`.

## Other residuals
- **L1209** $V$-monotonicity for $\beta\in(1,2)$ — use monotone envelope $\tilde V(m) := \max_{k\le m}V(k)$ (-3).
- **L1221** Lepskii arithmetic step $B(m^*) \le V(m^*)$ from balancing — needs explicit "up to neighbour-$V$ factor" (-3).
- **L1234** Hilbert-scale interpolation needs cite (-3).
- **L1236** Lipschitz $\Phi$ needs on-event qualifier (-3).

## Recovery path
- Add sub-exp clause to `ass:app4` (+15 + +10).
- Reconcile $\tau$ choice in statement (+10).
- Fix L1226 citation (+10).
- Use monotone envelope at L1209 (+3).
- Add interpolation + on-event citations (+6).
