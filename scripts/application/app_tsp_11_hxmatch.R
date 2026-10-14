# ============================================================================
# app_tsp_11_hxmatch.R
#
# Section 6, stage 11: THE x-BANDWIDTH THE RE-MEASUREMENT ARMS HAVE TO RUN AT,
# and the feasibility ladder that says why.
#
# ---------------------------------------------------------------------------
# WHAT THIS STAGE EXISTS TO SETTLE.
#
# Robustness arms R1a and R1b re-measure X -- from the rank coordinate C2 sets
# into mu-g/m^3 and into a min-max rescaling -- WHILE HOLDING h_x AT ITS
# RULE-OF-THUMB VALUE IN THE NEW COORDINATE.  bw_rot() is proportional to
# sd(X), so that convention holds h_x / sd(X) FIXED across coordinates by
# construction (it is 1.059 n^{-1/5} in every one of them) and lets
# h_x / |X| move freely.  On this panel it moves a long way:
#
#     |X| / h_x  =  12.32  (rank)      vs      57.68  (mu-g/m^3 and min-max)
#
# so the arm was never a clean test of RE-MEASUREMENT.  It was a test of
# re-measurement at a bandwidth that means something different in the new
# coordinate -- and after the x-kernel moved to C3's order-8 boundary family on
# 2026-08-15 it stopped being a test at all, because pi-hat goes negative at a
# handful of design points and make_operator() refuses to build.
#
# Nothing in the corpus pins h_x.  No named assumption carries an h_x condition
# (the assumption-auditor's open finding F6), so the constant in front of the
# rule is a free implementation choice, exactly as LF_CSTE and T_SCALE are.
# This stage chooses it, on measured evidence, and prices the choice.
#
# ---------------------------------------------------------------------------
# THE MATCHING RULE, AND WHY THIS ONE.
#
#   (M)  Keep the estimator's bandwidth RULE, h_x = c sd(X) n^{-1/5}, and move
#        only its CONSTANT c, so that the support-relative smoothing |X| / h_x
#        matches the rank arm's on the full analysis sample:
#
#           s_coord = rho_coord / rho_rank,
#           rho_c   = |X_c| / max{ bw_rot(x1_c), bw_rot(x2_c) },   n = 983,
#
#        and the arm runs at h_x = s_coord * bw_rot(.) at every fold.
#
# Three reasons for |X| / h_x rather than any other scale-free summary:
#
#   1. It is the statistic the estimator's own guard prints when it refuses
#      (make_operator(), lf_panel.R), so the quantity being matched and the
#      quantity being diagnosed are the same quantity.
#   2. It is the only thing the BOUNDARY FAMILY's geometry depends on.  C3(ii)'s
#      truncated moments are taken over I(x*) = [(lo - x*)/h, (hi - x*)/h], so
#      the Gram system G(I) at a design point is a function of (x* - lo)/h and
#      (hi - x*)/h alone.  Matching |X| / h_x matches the fraction of the design
#      that sits in the boundary layer, which is the object p_K = 8 was raised
#      to handle.
#   3. h_x / sd(X) is ALREADY matched by bw_rot(), identically, in every
#      coordinate.  The one dimension the shipped convention leaves free is
#      |X| / sd(X) -- the SHAPE the re-measurement induces -- and (M) is exactly
#      the rule that closes it.
#
# *** AND HERE IS WHAT (M) COSTS, MEASURED, BECAUSE IT IS NOT SMALL. ***
# On this panel |X| in mu-g/m^3 is set by ONE county.  The pooled X has median
# 58, a 5th-95th span of 68.8, a largest value of 428.1, and the two next
# largest are 286.0 and 181.1.  So:
#
#     range / sd          rank 3.46   vs   mu-g/m^3 18.28    (factor 5.3)
#     (5-95 span) / sd    rank 3.12   vs   mu-g/m^3  2.94    (factor 0.94)
#
# The 4.68x gap (M) closes is ENTIRELY a tail artifact: on the bulk the two
# coordinates are already matched to within 6 per cent.  Matching on the range
# therefore buys the boundary geometry at the price of a bandwidth that is about
# half the 5th-95th span of the data.  Both calibrations are marked on the
# ladder, so the reader can see which of the two the answer depends on:
#
#     s_range     |X| / h_x matched          (rule M, the reported arm)
#     s_span      (5-95 span) / h_x matched  (the bulk-matched alternative)
#
# ---------------------------------------------------------------------------
# *** WHAT THE LADDER FOUND, AND IT IS NOT WHAT THE REPAIR EXPECTED. ***
#
# THE MATCH DOES NOT RESCUE THE ARM.  IT MAKES IT WORSE, MONOTONICALLY, AND THAT
# IS THE RESULT.  Over 120 operator builds per rung:
#
#   rank      feasible at EVERY rung from s = 0.25 to s = 6 -- a factor of 24 --
#             min pi-hat 0.207 at the shipped bandwidth, 0.891 on the full
#             sample.  It fails only below s = 0.2, i.e. undersmoothed.
#   mu-g/m^3  fails at essentially every rung, and the count RISES with h above
#             s ~ 1.1:  5/120 at the shipped bandwidth, 29/120 at s = 2.5,
#             114/120 at the matched s = 4.68, 116/120 at s = 6.  The dense grid
#             carries a negative pi-hat on 117-120 of 120 builds at EVERY rung.
#   min-max   an exact affine image of mu-g/m^3 (Panel C, 7e-14), so the same
#             ladder, times 428.1.
#
# THE MECHANISM, WHICH IS WHY THIS IS A STATEMENT ABOUT THE COORDINATE AND NOT
# ABOUT THE TUNING.  The rank map makes the pooled design uniform, so every point
# has about n h neighbours inside the order-8 kernel's positive lobe.  In
# mu-g/m^3 the pooled X runs 0.0 to 428.1 with a median of 58.0 and its smallest
# observation sits 7.8 from the next; at the lower endpoint the truncation
# interval I degenerates to a half-line, and raising h drags the bulk of the
# design into the kernel's NEGATIVE lobes there.  The ladder locates the guard
# minimum at the 0.3rd percentile of the fold's own pooled X at every rung above
# s = 0.25.  Panel D confirms it is not a few-outlier phenomenon: trimming the
# 1, 2, 5 or 10 largest counties leaves the failure count at the shipped
# bandwidth unchanged or higher.
#
# READ AS C1(ii), which is what it is: pi bounded away from zero on X is an
# ASSUMPTION, and on this panel it is the rank coordinate that satisfies it.  The
# arm is not a tuning failure that a better h_x would fix; it is a coordinate in
# which this estimator is not defined.
#
# ---------------------------------------------------------------------------
# WHAT THIS STAGE PRODUCES
#   quality_reports/application/app_tsp_hxmatch.rds
#     A  the matching constants, per coordinate
#     B  the pi-hat feasibility ladder in s, over N_DRAW independent fold draws
#        replicating crossfit_once()'s three-way split exactly
#     C  the affine-equivalence check: min-max is an affine image of mu-g/m^3,
#        so pi-hat there is rg * pi-hat here and the two arms MUST agree on
#        feasibility.  Checked rather than asserted.
#     D  the trim diagnostic: is the infeasibility a few-county phenomenon?
#
# This stage runs no estimator.  It builds pi-hat and nothing else -- about 25
# minutes on 8 cores at the shipped ladder -- and depends on nothing but the
# panel.
# ============================================================================

library(here)
library(parallel)

source(here::here("scripts", "R", "lf_panel.R"))
source(here::here("scripts", "R", "orthogonal_theta.R"))
source(here::here("scripts", "application", "app_tsp_common.R"))

RNGkind("L'Ecuyer-CMRG")
set.seed(SEED_HXMATCH)                                               # INV-14

OUT <- here::here("quality_reports", "application")

pan <- load_tsp_panel()
dt  <- pan$dt
n   <- nrow(dt)

## The number of independent fold draws.  Requirement is at least 20; each draw
## is a full K = N_FOLDS partition, so a draw contributes N_FOLDS operator
## builds and the ladder sees N_DRAW * N_FOLDS of them per rung.
N_DRAW  <- 24L
## Resolution of the dense grid pi-hat is scanned on, between the two endpoints
## of the SOLVE FOLD's own support.  4,001 is the resolution stage 09 Panel B
## reports its full-sample minimum at.
N_GRID  <- 4001L

## The ladder.  Multiplicative on bw_rot(); 1 is the shipped convention.  The
## named targets are inserted below once the matching constants are known.
##
## IT RUNS DOWN TO s = 0.05 BECAUSE THE ANSWER TURNED OUT TO BE AT THE BOTTOM.
## The first sweep, over [0.25, 6], found NO feasible rung in mu-g/m^3 and a
## failure count RISING in h -- the opposite of the direction the repair was
## expected to work in -- so the sweep is extended downward far enough to say
## whether a feasible h_x exists at all, rather than only that the reported
## range contains none.  0.05 * bw_rot is 0.37 mu-g/m^3, well below anything a
## rate condition would tolerate; it is swept to bound the answer, not to
## propose a bandwidth.
##
## IT IS DENSE AROUND s = 0.2 FOR A REASON THE FIRST TWO SWEEPS FOUND.  In
## mu-g/m^3 the failure count is NOT monotone in h: it falls to zero at s = 0.20
## and rises again on BOTH sides (4/120 at 0.15, 1/120 at 0.25).  A single
## feasible rung on a coarse grid is not a feasible window, and the difference
## matters -- an isolated zero is a knife edge no bandwidth rule could be asked
## to land on, whereas an interval would be a usable configuration.  The extra
## rungs are what tells the two apart.
S_BASE <- c(0.05, 0.1, 0.15, 0.175, 0.19, 0.2, 0.21, 0.225, 0.25, 0.4, 0.5,
            0.6, 0.7, 0.8, 0.9, 1, 1.1, 1.25, 1.5, 1.75, 2, 2.25, 2.5, 3, 3.5,
            4, 4.5, 5, 6)

## Panel D's trims: how many of the most extreme counties are removed from every
## solve fold before pi-hat is rebuilt.  0 is the arm itself.
TRIM_K <- c(0L, 1L, 2L, 5L, 10L)

COORDS <- c("rank", "ugm3", "minmax")

grid_for <- function(x1, x2) {
  seq(stats::quantile(c(x1, x2), XEVAL_LO),
      stats::quantile(c(x1, x2), XEVAL_HI), length.out = N_XEVAL)
}

# ---- Panel A: the matching constants ---------------------------------------
#
# Computed ONCE, on the full analysis sample, so that s_coord is part of the
# arm's specification rather than a fold-level random variable.  Panel B reports
# what the fold-level realisation of |X| / h_x then is, which is the honest
# diagnostic on how well a full-sample constant transfers.

coord_stats <- function(md) {
  xc <- make_x_coord(dt$x1_raw, dt$x2_raw, mode = md)
  xe <- grid_for(xc$x1, xc$x2)
  xs <- range(c(xc$x1, xc$x2, xe))
  b1 <- bw_rot(xc$x1)
  b2 <- bw_rot(xc$x2)
  pooled <- c(xc$x1, xc$x2)
  q <- stats::quantile(pooled, c(XEVAL_LO, XEVAL_HI))
  list(mode = md, x1 = xc$x1, x2 = xc$x2, xeval = xe, xsupp = xs,
       bw1 = b1, bw2 = b2, bw = max(b1, b2),
       range = diff(xs), span_5_95 = as.numeric(diff(q)),
       iqr = stats::IQR(pooled), sd = stats::sd(pooled),
       rho_range = diff(xs) / max(b1, b2),
       rho_span  = as.numeric(diff(q)) / max(b1, b2),
       rho_iqr   = stats::IQR(pooled) / max(b1, b2))
}

A <- lapply(COORDS, coord_stats)
names(A) <- COORDS

## Rule (M): s so that |X| / h_x lands on the rank arm's value.
s_range <- vapply(A, \(z) z$rho_range / A$rank$rho_range, numeric(1))
## The bulk-matched alternative, priced beside it.
s_span  <- vapply(A, \(z) z$rho_span  / A$rank$rho_span,  numeric(1))

message("A. matching constants (full analysis sample, n = ", n, ")")
for (md in COORDS) {
  message(sprintf(paste0("   %-7s  bw = %.5g   |X| = %.5g   |X|/h = %7.3f   ",
                         "(5-95)/h = %6.3f   s_range = %.4f   s_span = %.4f"),
                  md, A[[md]]$bw, A[[md]]$range, A[[md]]$rho_range,
                  A[[md]]$rho_span, s_range[[md]], s_span[[md]]))
}

# ---- Panel B: the pi-hat feasibility ladder --------------------------------
#
# pi-hat is rebuilt exactly as make_operator() builds it -- same mixture, same
# bandwidths, same support, same order, same family -- rather than by calling
# make_operator(), which STOPS on a non-positive pi-hat and so cannot report how
# non-positive it was.  The formula is copied from lf_panel.R:748-753 and the
# copy is the point: a probe that called the guarded function could only ever
# report "it refused".

pi_min_at <- function(x1, x2, xeval, xsupp, b1, b2) {
  ord <- P_K_X
  ev <- function(v) {
    0.5 * ker_dens(x1, v, b1, ord, xsupp = xsupp, p_K = P_K_X) +
      0.5 * ker_dens(x2, v, b2, ord, xsupp = xsupp, p_K = P_K_X)
  }
  p1 <- ev(x1)
  p2 <- ev(x2)
  pe <- ev(xeval)
  pg <- ev(seq(xsupp[1], xsupp[2], length.out = N_GRID))
  ## WHERE the guard minimum sits, not only how deep it is.  A pi-hat that goes
  ## negative in the far tail is a different finding from one that goes negative
  ## in the reported range, and only the location distinguishes them.
  gv <- c(p1, p2, pe)
  gx <- c(x1, x2, xeval)
  i <- which.min(gv)
  ## `guard` is EXACTLY what make_operator() thresholds: design points of the
  ## solve fold and the evaluation grid.  `grid` is the wider scan, which the
  ## engine does not check and which is reported separately for that reason --
  ## a negative pi-hat away from any design or evaluation point never divides.
  list(guard = min(gv), grid = min(pg),
       x_at_min = gx[i], at_xeval = i > (length(p1) + length(p2)),
       min_design = min(c(p1, p2)), min_xeval = min(pe),
       ## The rank of the offending point in the fold's own pooled X, as a
       ## fraction: 1 means the largest value in the fold.
       q_at_min = mean(c(x1, x2) <= gx[i]),
       n_bad_design = sum(c(p1, p2) <= 0), n_design = length(p1) + length(p2),
       n_bad_xeval = sum(pe <= 0), n_bad_grid = sum(pg <= 0))
}

## The fold draws.  Each draw reproduces crossfit_once()'s split verbatim:
## K folds, the fold complement halved into an operator half and a solve half,
## and the operator built on the SOLVE half at its own bandwidths.
draw_splits <- function(n, K) {
  folds <- sample(rep_len(seq_len(K), n))
  lapply(seq_len(K), function(k) {
    rest <- which(folds != k)
    op_idx <- sample(rest, floor(length(rest) / 2))
    setdiff(rest, op_idx)
  })
}

DRAW_STREAM <- make_streams(N_DRAW)
splits <- vector("list", N_DRAW)                                     # INV-17
for (b in seq_len(N_DRAW)) {
  assign(".Random.seed", DRAW_STREAM[[b]], envir = globalenv())
  splits[[b]] <- draw_splits(n, N_FOLDS)
}
SOL <- unlist(splits, recursive = FALSE)
message(sprintf("B. %d fold draws x %d folds = %d operator builds per rung; ",
                N_DRAW, N_FOLDS, length(SOL)),
        sprintf("n_sol = %d", length(SOL[[1]])))

S_LADDER <- sort(unique(c(S_BASE, round(s_range, 6), round(s_span, 6))))

## mu-g/m^3 and min-max are AFFINE IMAGES OF EACH OTHER, so the ladder need only
## be swept once for the pair; Panel C establishes the equivalence numerically.
## It is swept on both anyway at the two rungs that matter, because "must be
## equivalent" and "is equivalent in this code" are different claims.
LADDER_COORD <- c("rank", "ugm3")

## Panel D's trim set: the counties with the largest pooled X, which are what
## makes |X| in mu-g/m^3 what it is.  Ordered by the county's own maximum over
## the two periods, so a county is removed whole -- removing one PERIOD of a
## county would change the panel rather than the design.
TRIM_ORDER <- order(pmax(dt$x1_raw, dt$x2_raw), decreasing = TRUE)

rung <- function(job) {
  md <- job$md
  s  <- job$s
  k  <- job$trim %||% 0L
  a  <- A[[md]]
  drop <- if (k > 0L) TRIM_ORDER[seq_len(k)] else integer(0)
  res <- lapply(SOL, function(sol) {
    sol <- setdiff(sol, drop)
    x1 <- a$x1[sol]
    x2 <- a$x2[sol]
    xs <- range(c(x1, x2, a$xeval))
    b1 <- s * bw_rot(x1)
    b2 <- s * bw_rot(x2)
    out <- pi_min_at(x1, x2, a$xeval, xs, b1, b2)
    out$ratio <- diff(xs) / max(b1, b2)
    out
  })
  gm <- vapply(res, \(z) z$guard, numeric(1))
  gr <- vapply(res, \(z) z$grid, numeric(1))
  rt <- vapply(res, \(z) z$ratio, numeric(1))
  qm <- vapply(res, \(z) z$q_at_min, numeric(1))
  list(mode = md, s = s, trim = k, h1 = s * a$bw1, h2 = s * a$bw2,
       h_full = s * a$bw, ratio_full = a$rho_range / s,
       guard_min = min(gm), guard_med = stats::median(gm),
       grid_min = min(gr),
       n_builds = length(gm), n_fail = sum(gm <= 0),
       n_fail_grid = sum(gr <= 0),
       fold_ratio_min = min(rt), fold_ratio_med = stats::median(rt),
       fold_ratio_max = max(rt),
       ## Where the minimum sits, over the builds that FAIL if any fail, and
       ## over all builds otherwise.
       q_at_min_med = stats::median(if (any(gm <= 0)) qm[gm <= 0] else qm),
       x_at_min = vapply(res, \(z) z$x_at_min, numeric(1)),
       at_xeval = sum(vapply(res, \(z) isTRUE(z$at_xeval), logical(1))),
       n_bad_design = sum(vapply(res, \(z) z$n_bad_design, numeric(1))),
       n_design_tot = sum(vapply(res, \(z) z$n_design, numeric(1))),
       guard_all = gm)
}

JOBS <- do.call(c, lapply(LADDER_COORD, function(md)
  lapply(S_LADDER, function(s) list(md = md, s = s))))
JOBS <- c(JOBS, lapply(c(1, s_range[["minmax"]], s_span[["minmax"]]),
                       function(s) list(md = "minmax", s = s)))
## Panel D: is the infeasibility a FEW-COUNTY phenomenon?  The 4.68x gap between
## the two coordinates' |X| / h_x is set by one county (428.1 mu-g/m^3, against a
## next-largest 286.0 and a pooled median of 58.0), so the same question has to be
## asked of the infeasibility itself.  Trims are applied at the shipped h_x and at
## the matched one; the answer is a fact about the design, not about the rule.
JOBS <- c(JOBS, do.call(c, lapply(TRIM_K[TRIM_K > 0L], function(k)
  lapply(c(1, s_range[["ugm3"]]), function(s)
    list(md = "ugm3", s = s, trim = k)))))

t0 <- Sys.time()
LAD <- parallel::mclapply(JOBS, rung, mc.cores = N_CORES,
                          mc.preschedule = FALSE)
bad <- vapply(LAD, \(z) inherits(z, "try-error") || is.null(z$guard_min),
              logical(1))
if (any(bad)) stop(sprintf("hxmatch: %d of %d ladder rungs failed", sum(bad),
                           length(LAD)))
message(sprintf("   ladder: %d rungs in %.0fs", length(LAD),
                as.numeric(difftime(Sys.time(), t0, units = "secs"))))

lad <- do.call(rbind, lapply(LAD, function(z)
  data.frame(mode = z$mode, s = z$s, trim = z$trim, h_full = z$h_full,
             ratio_full = z$ratio_full, guard_min = z$guard_min,
             guard_med = z$guard_med, grid_min = z$grid_min,
             n_fail = z$n_fail, n_builds = z$n_builds,
             n_fail_grid = z$n_fail_grid, at_xeval = z$at_xeval,
             q_at_min_med = z$q_at_min_med,
             n_bad_design = z$n_bad_design, n_design_tot = z$n_design_tot,
             fold_ratio_min = z$fold_ratio_min,
             fold_ratio_med = z$fold_ratio_med,
             fold_ratio_max = z$fold_ratio_max,
             stringsAsFactors = FALSE)))

for (md in unique(lad$mode)) {
  message(sprintf("   -- %s (trim = 0) --", md))
  sub <- lad[lad$mode == md & lad$trim == 0L, , drop = FALSE]
  sub <- sub[order(sub$s), , drop = FALSE]
  for (i in seq_len(nrow(sub))) {
    message(sprintf(paste0("   s = %6.4f  h = %8.5g  |X|/h(full) = %8.3f  ",
                           "fold |X|/h %6.2f-%7.2f  min pi (guard) = %11.4g  ",
                           "fail %3d/%3d  grid-neg %3d  min at pooled q = %.3f"),
                    sub$s[i], sub$h_full[i], sub$ratio_full[i],
                    sub$fold_ratio_min[i], sub$fold_ratio_max[i],
                    sub$guard_min[i], sub$n_fail[i], sub$n_builds[i],
                    sub$n_fail_grid[i], sub$q_at_min_med[i]))
  }
}

## The quantitative feasibility statement requirement 2 asks for: the largest
## h_x that still fails and the smallest that succeeds, per coordinate.  Read on
## the UNTRIMMED ladder only -- a trimmed rung is a different design, not a
## different bandwidth.
feas <- lapply(unique(lad$mode), function(md) {
  sub <- lad[lad$mode == md & lad$trim == 0L, , drop = FALSE]
  sub <- sub[order(sub$s), , drop = FALSE]
  ok <- sub$n_fail == 0L
  ## THE WIDTH OF THE FEASIBLE SET, NOT ONLY ITS INFIMUM.  A single rung at zero
  ## failures on a grid is not a feasible window; `ok_run` is the length of the
  ## longest CONSECUTIVE run of feasible rungs, so an isolated zero (run of 1)
  ## reads as the knife edge it is.
  runs <- rle(ok)
  list(mode = md, n_rungs = nrow(sub),
       ## min-max is swept at a HANDFUL of rungs, not the ladder: Panel C shows
       ## it is an exact affine image of mu-g/m^3, so its ladder IS that one and
       ## duplicating it would only re-measure the same numbers.  Flagged so
       ## that a summary line reading "no feasible h_x" is not misread as a
       ## difference between the two coordinates.
       spot_check = !identical(md, "rank") && nrow(sub) < length(S_LADDER),
       s_swept = range(sub$s), h_swept = range(sub$h_full),
       s_fail_max = if (any(!ok)) max(sub$s[!ok]) else NA_real_,
       h_fail_max = if (any(!ok)) max(sub$h_full[!ok]) else NA_real_,
       s_ok_min = if (any(ok)) min(sub$s[ok]) else NA_real_,
       h_ok_min = if (any(ok)) min(sub$h_full[ok]) else NA_real_,
       s_ok = sub$s[ok], ok_run_max = if (any(ok)) max(runs$lengths[runs$values]) else 0L,
       n_fail_min = min(sub$n_fail),
       s_at_fewest = sub$s[which.min(sub$n_fail)],
       monotone = if (any(ok)) all(ok[sub$s >= min(sub$s[ok])]) else NA)
})
names(feas) <- unique(lad$mode)
message("   feasibility (0 failing builds out of ", length(SOL), "):")
for (md in names(feas)) {
  message(sprintf(paste0("   %-7s %2d rungs%s, h_x in [%.4g, %.4g]; largest ",
                         "FAILING h_x = %.5g (s = %.4g); smallest SUCCEEDING ",
                         "h_x = %.5g (s = %.4g); feasible rungs %d, longest ",
                         "consecutive run %d; fewest failures %d at s = %.4g; ",
                         "feasible above the first = %s"),
                  md, feas[[md]]$n_rungs,
                  if (isTRUE(feas[[md]]$spot_check)) " (SPOT CHECK, not a ladder)" else "",
                  feas[[md]]$h_swept[1], feas[[md]]$h_swept[2],
                  feas[[md]]$h_fail_max, feas[[md]]$s_fail_max,
                  feas[[md]]$h_ok_min, feas[[md]]$s_ok_min,
                  length(feas[[md]]$s_ok), feas[[md]]$ok_run_max,
                  feas[[md]]$n_fail_min, feas[[md]]$s_at_fewest,
                  feas[[md]]$monotone))
}

# ---- Panel D: is the infeasibility a few-county phenomenon? ------------------

trm <- lad[lad$trim > 0L | (lad$mode == "ugm3" & lad$trim == 0L &
                            lad$s %in% c(1, s_range[["ugm3"]])), , drop = FALSE]
trm <- trm[order(trm$s, trm$trim), , drop = FALSE]
message("D. counties trimmed from every solve fold, mu-g/m^3:")
message(sprintf("   the trim order's first %d pooled X: %s",
                max(TRIM_K),
                paste(sprintf("%.1f", pmax(dt$x1_raw, dt$x2_raw)[
                  TRIM_ORDER[seq_len(max(TRIM_K))]]), collapse = ", ")))
for (i in seq_len(nrow(trm))) {
  message(sprintf(paste0("   s = %6.4f  trim %2d  h = %8.5g  min pi = %11.4g  ",
                         "fail %3d/%3d  grid-neg %3d"),
                  trm$s[i], trm$trim[i], trm$h_full[i], trm$guard_min[i],
                  trm$n_fail[i], trm$n_builds[i], trm$n_fail_grid[i]))
}

# ---- Panel C: the affine-equivalence check ---------------------------------
#
# min-max is (ugm3 - lo) / rg with rg = diff(range(pooled)), an AFFINE map.  Under
# an affine change of variable the standardised argument (x - X)/h is invariant
# when h scales with the coordinate -- which bw_rot() makes it do, being
# proportional to sd -- the truncation interval I is invariant, the Gram system
# is invariant, and Theta_I is invariant.  So pi-hat_minmax = rg * pi-hat_ugm3
# EXACTLY, and R1a and R1b are the same arm in different units: they cannot
# disagree about feasibility, and their reported estimates can differ only
# through the parts of the estimator that are NOT scale-equivariant (the RKHS
# ridge rho, which is a fixed 1e-3 whatever the units) and through the fact that
# the two arms draw DIFFERENT cross-fitting partitions from different L'Ecuyer
# streams.
rg_pooled <- diff(range(c(dt$x1_raw, dt$x2_raw)))
eq_sol <- SOL[[1]]
eq <- local({
  a_u <- A$ugm3
  a_m <- A$minmax
  xs_u <- range(c(a_u$x1[eq_sol], a_u$x2[eq_sol], a_u$xeval))
  xs_m <- range(c(a_m$x1[eq_sol], a_m$x2[eq_sol], a_m$xeval))
  ev <- function(a, sol, xs, b1, b2, at) {
    0.5 * ker_dens(a$x1[sol], at, b1, P_K_X, xsupp = xs, p_K = P_K_X) +
      0.5 * ker_dens(a$x2[sol], at, b2, P_K_X, xsupp = xs, p_K = P_K_X)
  }
  pu <- ev(a_u, eq_sol, xs_u, bw_rot(a_u$x1[eq_sol]), bw_rot(a_u$x2[eq_sol]),
           a_u$xeval)
  pm <- ev(a_m, eq_sol, xs_m, bw_rot(a_m$x1[eq_sol]), bw_rot(a_m$x2[eq_sol]),
           a_m$xeval)
  list(rg = rg_pooled, max_abs_dev = max(abs(pm - rg_pooled * pu)),
       max_rel_dev = max(abs(pm - rg_pooled * pu) / pmax(abs(pm), 1e-300)))
})
message(sprintf(paste0("C. min-max = affine image of mu-g/m^3 (rg = %.4f): ",
                       "max |pi_mm - rg pi_ug| = %.3g, relative %.3g"),
                eq$rg, eq$max_abs_dev, eq$max_rel_dev))
if (eq$max_rel_dev > 1e-10) {
  message("   *** the two coordinates are NOT numerically affine images; ",
          "the ladder does not transfer between them.")
}

saveRDS(list(panelA = A[c("rank", "ugm3", "minmax")],
             s_range = s_range, s_span = s_span,
             ladder = lad, ladder_raw = LAD, feasibility = feas,
             trim = trm, trim_k = TRIM_K,
             trim_x = pmax(dt$x1_raw, dt$x2_raw)[TRIM_ORDER[seq_len(max(TRIM_K))]],
             affine = eq, n = n, n_draw = N_DRAW, n_folds = N_FOLDS,
             n_grid = N_GRID, n_sol = length(SOL[[1]]),
             p_K = P_K_X, seed = SEED_HXMATCH),
        file.path(OUT, "app_tsp_hxmatch.rds"))

message("done: app_tsp_11_hxmatch")
