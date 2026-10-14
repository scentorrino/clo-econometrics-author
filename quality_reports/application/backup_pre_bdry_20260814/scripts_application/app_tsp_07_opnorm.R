## app_tsp_07_opnorm.R -----------------------------------------------------
##
## Emits the composite operator's SQUARED norm ||A||^2 in each of the three X
## coordinates the paper compares, together with the Landweber-Fridman step
## 1/||A||^2 each one implies.
##
## Why this script exists.  Section 6 defends implementation choice C2 -- the
## pooled empirical CDF coordinate -- by arguing that in mu-g/m^3 the operator
## norm is so large that the default relaxation exceeds the convergence bound
## of eq:normconst and the iteration diverges immediately.  That argument is
## load-bearing: it is what makes C2 a REGULARISATION choice rather than a
## cosmetic normalisation.  The number behind it was previously quoted in the
## manuscript without any artifact a replicator could check, because
## operator_norm2() is called inside lf_solve() to set the step and its value
## is never written out.  This script writes it out.
##
## How the number is obtained.  We do NOT re-implement the step-setting block.
## We call the engine unchanged with imax = 1L and cste = NULL, which makes
## lf_solve() run its own auto-step branch, and read the norm back off the
## returned constant as 1/cste.  The emitted quantity is therefore exactly the
## quantity the estimator uses, not a reconstruction of it that could drift.
##
## Note on naming: operator_norm2() returns ||A||^2, not ||A||.  The columns
## below are labelled accordingly.

library(here)

source(here::here("scripts", "R", "lf_panel.R"))
## orthogonal_theta.R too: conditional_parts() lives there, and this stage now
## norms the CONDITIONAL operator (the one the application iterates) rather
## than the ported one.  Omitting it cost a run.
source(here::here("scripts", "R", "orthogonal_theta.R"))
source(here::here("scripts", "application", "app_tsp_common.R"))

RNGkind("L'Ecuyer-CMRG")
set.seed(SEED_OPNORM)                                                # INV-14

TAB <- here::here("paper", "tables")
OUT <- here::here("quality_reports", "application")
dir.create(OUT, showWarnings = FALSE, recursive = TRUE)
dir.create(TAB, showWarnings = FALSE, recursive = TRUE)

pan <- load_tsp_panel()
dt  <- pan$dt

HEADLINE_DZ <- 5L
Z <- make_design(dt, HEADLINE_DZ)

## Same evaluation grid the robustness arms use, so the operator being normed
## is the operator those arms actually build.
grid_for <- function(x1, x2) {
  seq(stats::quantile(c(x1, x2), XEVAL_LO),
      stats::quantile(c(x1, x2), XEVAL_HI), length.out = N_XEVAL)
}

COORDS <- list(
  list(mode = "rank",   label = "Pooled empirical CDF (C2, baseline)"),
  list(mode = "ugm3",   label = "$\\mu$g/m$^3$"),
  list(mode = "minmax", label = "Min--max rescaling to $[0,1]$")
)

## The relaxation the section calls "the default" is the MATLAB source's fixed
## step; see the header comment on operator_norm2() in lf_panel.R.
DEFAULT_CSTE <- 0.5

## Iterations used by the default-step probe, and the patience it runs under.
##
## PATIENCE IS NOT DIAG_IMAX, AND THE FIRST VERSION OF THIS SCRIPT HAD IT WRONG.
## With patience == imax the break in lf_solve() needs DIAG_IMAX consecutive
## non-improvements inside DIAG_IMAX iterations, which cannot happen -- so
## `stopped_at` was DIAG_IMAX BY CONSTRUCTION.  The table shipped that column as
## the reader's check that no coordinate stopped early, and it was a column that
## could not report anything else; the manuscript sentence resting on it ("all
## three are still iterating when the count runs out") was true by construction
## rather than by measurement.  At a patience below DIAG_IMAX a coordinate that
## settles really does stop, so the column now carries information and the
## sentence is a finding.
##
## DIAG_PATIENCE WAS `LF_PATIENCE` UNTIL 2026-08-12 and is now a literal.  That
## constant is gone: patience is tied to the calibrated cap by
## lf_patience_for(), which at L = 2 is 15 -- far too short for a diagnostic
## whose whole purpose is to run PAST where the estimator stops and watch what
## the step does.  100 is the value LF_PATIENCE held, kept so the column means
## what it meant, and it is now declared here rather than borrowed.
DIAG_IMAX     <- 200L
DIAG_PATIENCE <- 100L

## Seeds for the power-iteration stability check.  operator_norm2() starts from
## rnorm(), so ||A||^2 is a random quantity; the supplement states it is stable
## across starting seeds, and that claim has to be COMPUTED here rather than
## asserted from a run nobody can repeat.  That was the defect this whole script
## exists to remove, and the first version of it reproduced the defect one level
## up: it ran a single seed while the table note claimed four.
SEEDS_OPNORM <- c(SEED_OPNORM, 1L, 7L, 99991L)

## The operator whose norm this measures must be the one the application
## ITERATES.  Since 2026-08-07 that is the conditional engine (C21-C25):
## comperr carries Wtilde/(wbar(1-wbar)) and the Bierens weight, and
## operator_residual()$adjw is the multiplier lf_solve() norms.  Measuring the
## ported operator here would report a norm for a strictly smaller map and the
## coordinate defence would rest on the wrong number.
## `cells` PASSED EXPLICITLY, 2026-08-12.  This stage is binary and the cell set
## it would infer is the same one, so this is a no-op TODAY -- it is passed
## because conditional_parts() now dispatches on cardinality, and a call site
## that leaves the instrument implicit is one that would silently follow `dt$w`
## if that column ever changed.  Every call site now says which instrument it
## means.
CF_COND <- conditional_parts(Z, dt$w, conditional = TRUE, eps_rho = EPS_RHO,
                             n_t = N_T, bier_seed = BIER_SEED,
                             t_scale = T_SCALE, adj_wtil = ADJ_WTIL,
                             cells = cells_of(dt$w))
stopifnot(identical(as.integer(CF_COND$L), 2L))

norm2_at <- function(op, init, seed) {
  set.seed(seed)
  a <- lf_solve(dt$dy, init$x1, init$x2, Z, dt$w, op, init$init,
                rho = CF_COND$rho, bier = CF_COND$bier,
                adj_wtil = CF_COND$adj_wtil,
                cste = NULL, imax = 1L, patience = 1L, tau_dp = TAU_DP)
  # lf_solve sets cste <- 1/||A||^2 when it computes the step itself.  The
  # fallback branch sets cste <- 0.5 when the norm is not finite or positive;
  # that would silently turn a failure into the number 2, so we refuse it.
  stopifnot(is.finite(a$cste), a$cste > 0,
            !isTRUE(all.equal(a$cste, DEFAULT_CSTE)))
  1 / a$cste
}

probe_coord <- function(mode) {
  xc   <- make_x_coord(dt$x1_raw, dt$x2_raw, mode = mode)
  op   <- make_operator(xc$x1, xc$x2, grid_for(xc$x1, xc$x2))
  init <- init_control(dt$dy, xc$x1, xc$x2, Z, dt$w, op)
  bundle <- list(x1 = xc$x1, x2 = xc$x2, init = init)

  A2s <- vapply(SEEDS_OPNORM, function(s) norm2_at(op, bundle, s), numeric(1))
  A2  <- A2s[1]
  # Significant figures common to every seed: how many digits the claim can carry.
  sigfig <- max(which(vapply(1:8, function(d)
    length(unique(signif(A2s, d))) == 1L, logical(1))), 0L)

  # What the default step actually does in this coordinate.  The section's claim
  # is about the consequence of exceeding the convergence bound, so the
  # consequence is measured, not asserted.
  #
  # DIAG_IMAX, not the estimator's m-bar: the application's calibrated budget
  # is lf_mbar(dt$w) = 15 at L = 2 (C4), and this diagnostic exists to run PAST
  # that and see whether the step is still descending when the estimator stops.
  # The count used is printed in the table.
  set.seed(SEED_OPNORM)
  f <- lf_solve(dt$dy, xc$x1, xc$x2, Z, dt$w, op, init,
                rho = CF_COND$rho, bier = CF_COND$bier,
                adj_wtil = CF_COND$adj_wtil,
                cste = DEFAULT_CSTE, imax = DIAG_IMAX, patience = DIAG_PATIENCE,
                tau_dp = TAU_DP)

  list(A2 = A2, A2_seeds = A2s, sigfig = sigfig,
       bound = 2 / A2, excess = DEFAULT_CSTE / (2 / A2),
       max_dphi = max(abs(f$dphi)), hit_cap = isTRUE(f$hit_cap),
       stopped_at = f$stopped_at,
       # err_path is retained because app_tsp_common.R's C2 note quotes the
       # first two discrepancies; a quoted number needs a saved object.
       err_path = f$err_path)
}

pr <- lapply(COORDS, function(c) probe_coord(c$mode))
names(pr) <- vapply(COORDS, function(c) c$mode, character(1))

## C22 warns that t_scale = 0.25 was chosen at d_Z = 2 and is applied here at
## d_Z = %d.  The realised spread of w(t' Phi(Delta Z)) is what that
## extrapolation costs, so it is measured rather than left as a caveat: comperr
## carries this weight TWICE, so a wide spread means the criterion is dominated
## by a handful of t directions and the 16-point family is effectively smaller
## than it looks.
WT <- CF_COND$bier$Wt
wt_spread <- if (is.null(WT)) NA_real_ else max(WT) / min(WT)
wt_eff <- if (is.null(WT)) NA_real_ else {
  cm <- colMeans(WT^2); sum(cm)^2 / sum(cm^2)     # participation ratio over t
}
message(sprintf(
  "Bierens family at d_Z = %d: range %.4g to %.4g (spread %.3g), effective t count %.2f of %d",
  ncol(Z), min(WT), max(WT), wt_spread, wt_eff, ncol(WT)))

nrm2 <- vapply(pr, function(p) p$A2, numeric(1))
base <- nrm2[["rank"]]

message("||A||^2 and default-step behaviour by coordinate:")
for (k in seq_along(pr)) {
  p <- pr[[k]]
  message(sprintf(
    "  %-8s ||A||^2=%11.5g  bound=%10.4g  0.5/bound=%9.4g  max|dphi|=%9.4g  cap=%s (%d)",
    names(pr)[k], p$A2, p$bound, p$excess, p$max_dphi, p$hit_cap, p$stopped_at))
}

## Formatting: these span many orders of magnitude, so a fixed number of
## decimals is useless.  Two significant figures in scientific notation for
## anything outside [0.01, 1000), plain otherwise.
sci <- function(x) {
  if (!is.finite(x)) return("--")
  if (x >= 1e-2 && x < 1e3) return(formatC(x, format = "fg", digits = 3))
  e <- floor(log10(abs(x)))
  m <- x / 10^e
  sprintf("$%.1f\\times10^{%d}$", m, e)
}

## "Iterations run" is printed even though it is DIAG_IMAX in every row as
## things stand.  That is the point: the magnitude comparison in the last column
## is only fair if no coordinate stopped early, and a reader should be able to
## check that rather than take it on trust.  If a future run does stop one arm
## early, the column says so instead of silently changing what is being compared.
## Wrapping columns, not `lrrrrr'.  Adding the "Iterations run" column above
## widened this table by about 21pt and pushed it 43pt past the text block; the
## column is worth keeping, so the table is refitted around it rather than the
## other way round.  Sized once here so a future column does not silently
## reintroduce the overflow.
write_tabular(
  paste0("@{}p{0.26\\textwidth}",
         paste(rep(">{\\raggedleft\\arraybackslash}p{0.12\\textwidth}", 5),
               collapse = ""), "@{}"),
  paste("Coordinate & $\\|A\\|^{2}$ & Bound $2/\\|A\\|^{2}$ &",
        "Step $0.5\\div$ bound & Iterations run &",
        "$\\max|\\Delta\\hat\\varphi|$ \\\\"),
  vapply(seq_along(COORDS), function(k) {
    p <- pr[[k]]
    sprintf("%s & %s & %s & %s & %d & %s \\\\",
            COORDS[[k]]$label, sci(p$A2), sci(p$bound), sci(p$excess),
            p$stopped_at, sci(p$max_dphi))
  }, character(1)),
  file.path(TAB, "app_tsp_opnorm.tex"))

message(sprintf("wrote %s", file.path(TAB, "app_tsp_opnorm.tex")))

## EVERY number the manuscript quotes from this stage now has a saved producer.
## Until 2026-08-07 sigfig, A2_seeds and err_path were computed here and emitted
## nowhere -- the supplement's "stable to six significant figures across four
## starting seeds" and C2's "0.0812 -> 0.0326" were unreachable claims about a
## run nobody could repeat, which is the exact defect this script exists to
## remove.
for (k in seq_along(pr)) {
  p <- pr[[k]]
  message(sprintf(
    "  %-8s ||A||^2 across seeds: %s  -> stable to %d significant figure%s",
    names(pr)[k], paste(formatC(p$A2_seeds, format = "g", digits = 8),
                        collapse = ", "),
    p$sigfig, if (p$sigfig == 1L) "" else "s"))
  message(sprintf("  %-8s discrepancy path (first 3): %s",
                  names(pr)[k],
                  paste(formatC(utils::head(p$err_path, 3), format = "g",
                                digits = 4), collapse = " -> ")))
}
saveRDS(list(pr = pr, seeds = SEEDS_OPNORM, diag_imax = DIAG_IMAX,
             diag_patience = DIAG_PATIENCE, default_cste = DEFAULT_CSTE,
             bierens = list(spread = wt_spread, eff_t = wt_eff,
                            n_t = ncol(WT), d_Z = ncol(Z)),
             conditional = TRUE),
        file.path(OUT, "app_tsp_opnorm.rds"))
message(sprintf("wrote %s", file.path(OUT, "app_tsp_opnorm.rds")))
