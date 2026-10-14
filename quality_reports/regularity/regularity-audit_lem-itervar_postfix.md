# Regularity Audit — Lemma `lem-itervar` (post-fix)

**Trajectory:** 21 → **86/100** (+65).
**Date:** 2026-05-17.

## CRITICAL CLEARED
Event preamble at L1158 supplies step-size transfer; LF spectral filter now valid on the empirical Gram operator on $\mathcal{E}_n$.

## Four of five MAJORs cleared
- $\Vert\hat{\mathsf{T}}'^*\Vert = O_p(1)$ in preamble item (ii). ✓
- $\bar M$ envelope in preamble item (iii). ✓
- Range-membership cited via @def-sourceID + @prp-onetoone(iii). ✓
- Random-quantity subtraction rewritten cleanly. ✓

## Partially resolved (-5)
- **$I_a$ off-event Cauchy-Schwarz at L1191** claims $E\Vert\hat b_0 - b_0\Vert^4$ moment "via `ass:rateconv`'s $l_0\ge 4$ clause". But `ass:rateconv` gives moments for operators, not the pilot. Need explicit $L^4$ moment on $\hat b_0$.

## Three new minor findings (-3 each)
- **Preamble $L^4/L^8$ ambiguity (L1158).** $\sup_j E\Vert\hat e_j\Vert^4$ invoked before the induction (L1193) that establishes it. Circular in presentation.
- **MI case event $\mathcal{E}_n^{\mathrm{MI}}$ not constructed (L1203).** Preamble is FI-specific.
- **"Lepskii-relevant range $m \ge m^*$" wording at L1191** contradicts the uniform-in-$m$ lemma claim. The alternative absorption-into-$B(m)$ path immediately following is the correct argument; the "Lepskii-relevant range" sentence should be deleted.
