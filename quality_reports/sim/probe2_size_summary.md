# Probe 2: size and power

Nominal level 5 per cent. n = 983, 96 replications per row, 300 null draws each.
DGP gamma = 1.0.  A1 false uses lambda = 0.5 on (W - varrho).

## Homogeneous first stage

| Stratification | Size (A1 true) | Power (A1 false) | Reportable |
|---|---|---|---|
| none | 0.073 | 0.833 | yes |
| quartile of X1 (endogenous regressor) | 0.042 | 0.438 | yes |
| quartile of Z1 (component of Delta Z) | 0.698 | 0.865 | **NO** |

## Heterogeneous first stage (Masten and Torgovitsky 2014, section 6.2)

Instrument switched off on the lowest-baseline quartile, strength rising with
baseline thereafter.  This is the configuration the Section 6 data is in.

| Stratification | Size (A1 true) | Power (A1 false) | Reportable |
|---|---|---|---|
| none | 0.250 | 0.552 | -- |
| quartile of X1 (endogenous regressor) | 0.052 | 0.312 | -- |
| quartile of Z1 (component of Delta Z) | 0.708 | 0.677 | -- |

A stratification that is a function of Delta Z inherits whatever varrho-hat
gets wrong in that direction, and the null draw does not: the observed
statistic is compared against a reference built from a propensity the
observed W does not obey.  Those rows are not evidence about A1.

Produced by scripts/simulations/sim_probe2_size.R.
