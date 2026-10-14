# ============================================================================
# sim_merged_cardinality.R
#
# THE CARDINALITY MERGE FOR SECTION 5, EMITTED RATHER THAN TRANSCRIBED.
#
#   Rscript scripts/simulations/sim_merged_cardinality.R
#
# This file COMPUTES NOTHING.  It reads the cell summaries the six simulation
# arms already wrote to quality_reports/sim/ and re-lays them out so that the
# cardinality of the instrument is READABLE ACROSS A ROW.  It draws no random
# numbers -- there is no set.seed() here because there is nothing to seed
# (INV-14 conditions on a stochastic element existing).  Re-running it after any
# arm re-runs is seconds, and it is the ONLY place the merged tables exist:
# nothing here is transcribed by hand from a .tex fragment (INV-13).
#
# ---------------------------------------------------------------------------
# THE HAZARD THIS FILE IS BUILT AROUND
#
# Section 5's placed tables and the sim_multinomial_* tables ARE NOT THE SAME
# EXPERIMENT.  They differ on THREE factors at once, not on cardinality alone:
#
#   (i)   THE DESIGN.  Block I is sim_thm_rootn_dgp.R -- the frontier-clearing
#         configuration (mu,s,a,r,d_Z,p_K) = (2,3,3/4,8/3,3,8) at p = 4, with
#         varphi = sin(2 pi x) at amplitude 1 and a Gaussian-copula X.  Block II
#         is sim_thm_rootn_headroom_dgp.R at (5,4,2/5,21/8,1,8), p = 2.  Block
#         III is sim_multinomial_dgp.R: a different varphi normalisation, a
#         different dZ dimension, a first stage that is CELLWISE (M5), and a dU
#         whose conditional scale moves with dZ (M3).
#
#   (ii)  THE ESTIMATOR.  Blocks I and II run the theory's own sieve
#         construction against POPULATION objects computed in closed form inside
#         the DGP -- ell_star solved from the balancing equation (D1), J and
#         Sigma from a 4e6 pilot.  Block III runs the SHIPPED engine,
#         scripts/R/lf_panel.R and scripts/R/orthogonal_theta.R, the same code
#         Section 6 estimates with.  They are disjoint stacks: no file in one
#         sources a file in the other.
#
#   (iii) THE NUISANCE REGIME.  Blocks I and II do not estimate their nuisances.
#         They DRAW them as the truth plus an error of controlled size in the
#         norm thm:rootn prices (design decision D3), with the constant c_delta
#         a free knob.  Block III estimates every nuisance from the sample.
#
# A table whose columns read "L = 2" and "L = 4" but whose rows come from two of
# these blocks attributes all three differences to cardinality.  That is the
# defect tab:app-theta shipped with -- two cardinality columns that silently
# also differed in mbar -- and it is the defect this file exists to not repeat.
#
# ---------------------------------------------------------------------------
# THE RULE EVERY TABLE BELOW OBEYS
#
#   ONE ROW = ONE BLOCK = ONE DESIGN = ONE ESTIMATOR = ONE NUISANCE REGIME.
#   Cardinality varies WITHIN a row and never across one.
#
# Block I and Block II are BINARY IN THIS FILE, so their L = 3 and L = 4 cells
# are printed as an em-dash, not left blank.  A blank cell invites the reader to
# supply a number from the row above; an em-dash under a panel header that names
# the cardinality does not.
#
# THE TWO BLOCKS ARE BINARY FOR DIFFERENT REASONS, AND THE DISTINCTION IS NOT
# COSMETIC.  Block II is binary BY CONSTRUCTION: sim_thm_rootn_headroom_dgp.R:341
# is still `pw <- cbind(1 - rr, rr)` and the headroom design has no cardinality
# parameter.  Block I is NOT: since design decision D8 (2026-08-14) the
# cardinality IS a parameter of sim_thm_rootn_dgp.R, and
# sim_thm_rootn_cardinality.R runs Block I's design at FOUR cells.  Block I is
# binary here only because the arms THIS FILE READS -- sim_thm_rootn_limitlaw.R
# and its siblings -- are the binary ones.  Anyone extending this merge to the
# cardinality arm's cells must read that arm's .rds, not assume the design cannot
# produce them.
#
# The block attribution is carried IN THE TABLE, by a panel header naming the
# design, the estimator and the nuisance regime -- not in the note.  A reader who
# reads only the body still cannot merge two blocks by accident.
#
# ---------------------------------------------------------------------------
# WHAT IS EMITTED
#
#   sim_merged_rootn_balanced.tex thm:rootn -- bias, rate, coverage, with L as
#   sim_merged_rootn_skewed.tex   COLUMNS.  Block III, one file per design; the
#   sim_merged_rootn_misspec.tex  third is the design that violates (T-4).
#   sim_merged_designs.tex        the THREE-BLOCK contrast at the cardinality all
#                                 three share, L = 2, with the cardinalities each
#                                 block actually ran in the last column.  This is
#                                 the generated analogue of tab:sim-h-contrast,
#                                 whose body is at present hand-transcribed.
#   sim_merged_precision.tex      the PAIRED cardinality contrast: same draw,
#                                 same partition, L = 3 and L = 4 against L = 2.
#                                 Block III only, because pairing across blocks
#                                 is not defined.
#   sim_merged_stopping.tex       Pr(the discrepancy rule selects an iterate
#                                 inside its budget), the ONE statistic the two
#                                 phi-step arms both measure, with the threshold
#                                 parameterisation and the budget printed beside
#                                 it because they differ by four decades.
#
# ---------------------------------------------------------------------------
# WHAT IS NOT EMITTED, AND WHY -- these are findings, not omissions
#
#   tab:sim-ablation   has no Block III counterpart.  The ablation switches a
#                      nuisance between EXACT and INJECTED; Block III estimates
#                      its nuisances and has no injection mechanism, so there is
#                      no "all exact" arm to put in a column.
#   tab:sim-crossings  carries no data and no instrument.  It is rate algebra in
#                      (mu, s, a, d_Z, r); L appears in none of them.  There is
#                      no cardinality dimension to merge.
#   the sd ratio       Blocks I and II compare the simulated standard deviation
#                      with a POPULATION V known in closed form.  Block III has
#                      no population V -- orthogonal_theta() returns a sandwich,
#                      and the truth it would be compared against is not
#                      computed -- so the ratio exists in two blocks of three and
#                      is reported per block, never in a shared column.
# ============================================================================

suppressMessages({                                                     # INV-15
  library(here)
})
source(here::here("scripts", "simulations", "sim_multinomial_dgp.R"))

OUT_ROOT <- Sys.getenv("SIM_OUT_ROOT", unset = here::here())           # INV-16
OUT <- file.path(OUT_ROOT, "quality_reports", "sim")
TAB <- file.path(OUT_ROOT, "paper", "tables", "sim")
dir.create(TAB, showWarnings = FALSE, recursive = TRUE)                # INV-18

L_GRID   <- c(2L, 3L, 4L)
N_GRID   <- c(400L, 800L, 1600L)
D_CLEAN  <- c("balanced", "skewed")
D_MIS    <- "misspec"
COEF_TEX <- c("Constant", "$z_1$", "$z_2$")
DASH     <- "---"

# ---- inputs ----------------------------------------------------------------
#
# EVERY INPUT IS REQUIRED AND THE FAILURE NAMES ITS PRODUCER.  A merge that
# silently drops a block would print a table whose panel headers promise three
# designs and whose body carries two, which is worse than not running.

SRC <- list(
  limitlaw  = list(f = "sim_thm_rootn_limitlaw.rds",
                   by = "sim_thm_rootn_limitlaw.R"),
  headroom  = list(f = "sim_thm_rootn_headroom.rds",
                   by = "sim_thm_rootn_headroom.R"),
  phistep1  = list(f = "sim_thm_rootn_phistep.rds",
                   by = "sim_thm_rootn_phistep.R"),
  rootn3    = list(f = "sim_multinomial_rootn.rds",
                   by = "sim_multinomial_rootn.R"),
  ## The checkpoint carries the REQUESTED replication count, cfg$b, which the
  ## cell summary does not: sum$n_used is the count that SURVIVED.  T4 below
  ## reads this same file again through its own CK block.  That second read is
  ## 5 ms on a 235 KB file and it is deliberate -- T4 emits
  ## sim_merged_precision.tex, which is not in scope here, and rerouting it
  ## through RD would put a table that must not move on the diff.
  rootn3ck  = list(f = "sim_multinomial_rootn_ckpt.rds",
                   by = "sim_multinomial_rootn.R"),
  phistep3  = list(f = "sim_multinomial_phistep.rds",
                   by = "sim_multinomial_phistep.R")
)
miss <- vapply(SRC, function(s) !file.exists(file.path(OUT, s$f)), logical(1))
if (any(miss)) {
  stop("missing cell summaries; run the arms that produce them first:\n",
       paste(sprintf("  %s   <- Rscript scripts/simulations/%s",
                     vapply(SRC[miss], `[[`, character(1), "f"),
                     vapply(SRC[miss], `[[`, character(1), "by")),
              collapse = "\n"))
}
RD <- lapply(SRC, function(s) readRDS(file.path(OUT, s$f)))

#' Strip data.table class without requiring the package to be installed.
dt2df <- function(x) {
  x <- unclass(x)
  attr(x, ".internal.selfref") <- NULL
  as.data.frame(x, stringsAsFactors = FALSE)
}

#' Flatten an abstract-operator arm's list of per-cell summaries into a frame.
#'
#' @param out list of cell summaries (limitlaw / headroom `$out`).
#' @param keep character vector of scalar fields to lift.
flatten_cells <- function(out, keep) {
  M <- matrix(NA_real_, length(out), length(keep),                     # INV-17
              dimnames = list(NULL, keep))
  chr <- c("dgp", "cell", "h_mode")
  D <- data.frame(dgp = character(length(out)), cell = character(length(out)),
                  stringsAsFactors = FALSE)
  for (i in seq_along(out)) {
    z <- out[[i]]
    for (k in keep) M[i, k] <- if (is.null(z[[k]])) NA_real_ else z[[k]][1]
    D$dgp[i] <- z$dgp
    D$cell[i] <- z$cell
  }
  cbind(D, as.data.frame(M, stringsAsFactors = FALSE))
}

KEEP1 <- c("n", "c_delta", "c_eps", "c_r", "B", "cover90", "cover90_se",
           "cover95", "cover95_se", "sd_ratio", "sd_ratio_z", "sd_mixed")
LL <- flatten_cells(RD$limitlaw$out, KEEP1)
HH <- flatten_cells(RD$headroom$out, KEEP1)
PS1 <- dt2df(RD$phistep1)
S3 <- RD$rootn3$sum
P3 <- RD$phistep3$paths

# ---- the design grid the merge assumes is the design grid on disk ----------
#
# The tables below index Block III by (design, n, L) NAMES.  If the arm is
# re-run on a different grid those names go stale silently and the merged table
# prints a subset while looking complete.  Assert instead.

## ---------------------------------------------------------------------------
## THE CELL SUMMARY MUST BE NON-EMPTY, AND THIS IS NOT A DEFENSIVE FLOURISH:
## THE HAZARD IS ARMED IN THE TREE TODAY.
##
## sim_multinomial_rootn.R's CFG carries the md5 of lf_panel.R and
## orthogonal_theta.R.  lf_panel.R was edited on 2026-08-26 at 16:48, AFTER the
## nine-cell run finished at 07:06, so the checkpoint's stored key no longer
## matches the tree.  Verified in a sandbox: `SIM_SUMMARISE_ONLY=1 Rscript
## scripts/simulations/sim_multinomial_rootn.R` today prints "cache discarded,
## configuration changed", summarises ZERO cells, OVERWRITES
## sim_multinomial_rootn.rds with an empty summary, and then dies before writing
## a table.  The raw draws survive in the checkpoint, so nothing is lost that a
## re-summarise cannot rebuild -- but the .rds this file reads would be gone.
##
## WITHOUT THIS CHECK THAT STATE IS SILENT HERE.  An empty S3 passes every
## existing assertion above: `all(NULL %in% L_GRID)` is TRUE, `split()` on a
## zero-length vector gives an empty list, `all(integer(0) <= B_REQ)` is TRUE,
## and every loop below iterates over an empty grid.  The tables would emit with
## correct headers, correct panel tags and NO BODY -- which is the failure mode
## this project has already shipped once, in another form, and the one the
## header of this file exists to prevent.
stopifnot(is.data.frame(S3), nrow(S3) > 0L)
if (nrow(S3) != length(unique(S3$dgp)) * length(unique(S3$n)) *
      length(L_GRID) * length(COEF_TEX)) {
  stop("sim_multinomial_rootn.rds carries ", nrow(S3), " summary rows; the grid ",
       "on disk implies ",
       length(unique(S3$dgp)) * length(unique(S3$n)) * length(L_GRID) *
         length(COEF_TEX),
       ".\n  Rebuild it from the checkpoint, which still holds the raw draws:\n",
       "  SIM_SUMMARISE_ONLY=1 Rscript scripts/simulations/sim_multinomial_rootn.R\n",
       "  -- and note that this DISCARDS the cache unless lf_panel.R and\n",
       "     orthogonal_theta.R are at the md5 the checkpoint recorded.")
}

stopifnot(all(c(D_CLEAN, D_MIS) %in% names(MDGP_SPEC)),
          all(S3$L %in% L_GRID), all(P3$L %in% L_GRID),
          length(MDGP_THETA_FULL) == 3L)
DTEX <- vapply(MDGP_SPEC, function(k) k$tex, character(1))
N3 <- sort(unique(S3$n))
if (!identical(as.integer(N3), N_GRID)) {
  message("  NOTE: Block III grid on disk is n = ", paste(N3, collapse = ", "),
          "; the merge follows the disk and not the declared grid.")
}

# ---- formatting ------------------------------------------------------------
#
# The helpers are the ones sim_multinomial_rootn.R and sim_thm_rootn_limitlaw.R
# format with, so a merged cell and its per-suite cell are the SAME STRING and
# INV-11 holds by construction rather than by inspection.

ff <- function(x, d = 4) formatC(x, format = "f", digits = d)
pm <- function(m, s, d = 4) sprintf("%s (%s)", ff(m, d), ff(s, d))
nn <- function(x) format(x, big.mark = ",", scientific = FALSE)
# scientific=FALSE is load-bearing, not defensive.  format() honours scipen=0,
# which picks whichever form is NARROWER: fixed "875713000000" is 12 characters,
# scientific "8.75713e+11" is 11, so ONE CHARACTER flipped that cell in the
# Budget column of sim_merged_stopping.tex and it shipped that way.  The
# neighbours survive by accident (185035802711 ties at 12; ties go to fixed).
# Rejected alternatives, both tested: options(scipen=999) is global state;
# formatC(x, format="d") returns NA WITH A WARNING above the integer range and
# would ship a column of NAs.
blank_rep <- function(x, first) if (first) x else ""

write_tab <- function(lines, file) {
  writeLines(lines, file.path(TAB, file))
  message("  wrote ", file.path("paper", "tables", "sim", file))
}

#' A panel header spanning the whole table (INV-3: no rules but booktabs ones).
#'
#' `txt` may be a VECTOR, one spanning row per element.  A \multicolumn cell does
#' not wrap, so a single long descriptor sets the natural width of the whole
#' table: the first draft of these tables measured 724.97pt against a 469.76pt
#' text block at \footnotesize, and every one of the five was overfull by the
#' same 255pt -- the identical excess is the giveaway that the header, not the
#' body, was setting the width.  Splitting the descriptor over two short spanning
#' rows keeps the attribution in the body and lets the columns set the width.
panel <- function(txt, ncol)
  vapply(txt, function(s) sprintf("\\multicolumn{%d}{l}{%s} \\\\", ncol, s),
         character(1), USE.NAMES = FALSE)

# The block descriptors.  These strings are the design attribution and they go
# in the BODY of every table, never only in the note.
BLK1 <- c(paste("\\textbf{Block I} --- named configuration, abstract operator,",
                "nuisances injected at controlled rates"),
          paste("\\quad $(\\mu,s,a,r,d_Z,p_K)=(2,3,\\tfrac34,\\tfrac83,3,8)$,",
                "$p=4$; $\\mathsf L=2$ in this block"))
BLK2 <- c(paste("\\textbf{Block II} --- headroom configuration, abstract",
                "operator, nuisances injected at controlled rates"),
          paste("\\quad $(\\mu,s,a,r,d_Z,p_K)=(5,4,\\tfrac25,\\tfrac{21}8,1,8)$,",
                "$p=2$; $\\mathsf L=2$ in this block"))
BLK3 <- c(paste("\\textbf{Block III} --- multinomial design, shipped engine,",
                "nuisances estimated"),
          paste("\\quad \\texttt{sim\\_multinomial\\_dgp.R} with",
                "\\texttt{lf\\_panel.R}; $\\mathsf L\\in\\{2,3,4\\}$",
                "off one draw"))

# ---- the realised replication count, and why it is a header and not a column
#
# THE COUNT REQUESTED AND THE COUNT USED ARE DIFFERENT NUMBERS AND ONLY ONE OF
# THEM WAS ON THE PAGE.  Block III was drawn at cfg$b = 120 in every cell and
# returned fewer in seven of the nine: the order-8 boundary family drives
# pi-hat negative on small folds, make_operator refuses to build an adjoint it
# would have to divide by, and the draw is dropped.  The per-design tables used
# to print no count at all, and tab:sim-merged-designs prints only its n = 1,600
# row, so 117, 116, 112 and 118 were reachable from no artifact -- an INV-22
# hole that prose in the note cannot close, because the note is not generated.
#
# A COLUMN WAS THE FIRST CHOICE AND IT WAS MEASURED OUT.  Emitting $B$ as a
# fourth stub column (colspec llrl+ccc) was built and measured against this
# document's preamble at \footnotesize:
#
#            shipped     with $B$ column     delta
#   balanced  400.549pt      421.083pt      +20.534pt
#   skewed    392.489pt      413.167pt      +20.679pt
#   misspec   416.789pt      437.445pt      +20.656pt
#
# The column costs 2\tabcolsep + w("117") = 12 + 15 = 27pt and recovers only the
# 6.3-6.5pt by which the spanning block header currently overhangs the body
# columns, so it grows the widest row of all three tables by about 20.6pt.  It
# would still FIT -- \textwidth is 469.755pt -- but growing the widest row is
# the stop rule here, and this document has already shipped a table that
# overran silently (sim_merged_stopping.tex, 494.888pt, the 21.800pt overfull
# in main.log).  A header line costs the width of its own text and nothing per
# row.  The line below measures 356.842pt against a budget of 380.489pt, the
# narrowest of the three tables less 2\tabcolsep, so it changes no width at all.
#
# The line is emitted from sum$n_used and cfg$b, never transcribed, so INV-22
# is satisfied by construction and INV-11 holds against the note the writer
# places.

B_REQ <- RD$rootn3ck$cfg$b
stopifnot(length(B_REQ) == 1L, is.finite(B_REQ), B_REQ > 0L)

# Keyed "dgp|n|L".  The count is a property of the CELL, not of a coefficient,
# so a cell whose three coefficients disagree is a corrupt summary and not a
# formatting problem -- it stops rather than printing the first one.
BUSE <- local({
  sp <- split(S3$n_used, paste(S3$dgp, S3$n, S3$L, sep = "|"))
  bad <- vapply(sp, \(v) length(unique(v)) != 1L, logical(1))
  if (any(bad)) {
    stop("n_used differs across coefficients within cell(s): ",
         paste(names(sp)[bad], collapse = ", "),
         "\n  sum$n_used is a cell-level count; re-run ",
         "scripts/simulations/sim_multinomial_rootn.R")
  }
  vapply(sp, \(v) as.integer(v[1]), integer(1))
})
stopifnot(all(BUSE <= B_REQ))

#' Realised replication count for one Block III cell.
#'
#' @param dd character. Design key in `MDGP_SPEC`.
#' @param n_ integer. Sample size on the disk grid.
#' @param L integer. Cardinality of the instrument.
#' @return integer scalar, the count of draws the cell used.
b_used <- function(dd, n_, L) BUSE[[paste(dd, n_, L, sep = "|")]]

#' Spanning header line(s) carrying one design's realised replication counts.
#'
#' The counts are IDENTICAL ACROSS CARDINALITY on the run this file reads --
#' the three arms share a draw and a partition, so a draw lost to a non-positive
#' pi-hat is lost at all three -- and the single-line form SAYS SO.  That is a
#' claim about the data, so it is checked against the data rather than assumed:
#' if a future run breaks it the per-cardinality form is emitted instead and the
#' console says which fired.  Nothing here can print "equal at all L" over
#' counts that are not.
#'
#' @param dd character. Design key in `MDGP_SPEC`.
#' @return character vector of spanning-row payloads, without the \multicolumn
#'   wrapper, which `panel()` supplies.
b_lines <- function(dd) {
  M <- matrix(NA_integer_, length(N3), length(L_GRID))                 # INV-17
  for (i in seq_along(N3)) {
    for (j in seq_along(L_GRID)) M[i, j] <- b_used(dd, N3[i], L_GRID[j])
  }
  ## TWO FORMATTING TRAPS, BOTH OF WHICH COMPILE CLEANLY AND RENDER WRONG.
  ## (i) nn() is format(), which pads a VECTOR to a common width -- "  400"
  ##     would reach the .tex with its leading spaces.  Every call here is
  ##     scalar, hence the vapply rather than nn(N3).
  ## (ii) These numbers go inside $...$, where a bare comma is PUNCTUATION and
  ##     TeX sets a thin space after it: $1,600$ prints as "1, 600".  The body
  ##     of the table does not have this problem because its $n$ column is a
  ##     text cell.  Brace the comma.
  n_tex <- gsub(",", "{,}", vapply(N3, nn, character(1)), fixed = TRUE)
  b_tex <- gsub(",", "{,}", nn(B_REQ), fixed = TRUE)
  flat <- vapply(seq_len(nrow(M)), \(i) length(unique(M[i, ])) == 1L, logical(1))
  if (all(flat)) {
    sprintf("\\quad $B$ used of $%s$ drawn: %s; equal at all $\\mathsf L$",
            b_tex,
            paste(sprintf("$%d$ ($n{=}%s$)", M[, 1L], n_tex), collapse = ", "))
  } else {
    message("  NOTE: B is not constant across cardinalities for design ", dd,
            "; the header prints one line per sample size instead.")
    vapply(seq_along(N3), \(i) sprintf(
      "\\quad $B$ used of $%s$ drawn at $n{=}%s$: %s", b_tex, n_tex[i],
      paste(sprintf("$%d$ ($\\mathsf L{=}%d$)", M[i, ], L_GRID),
            collapse = ", ")), character(1))
  }
}

# ============================================================================
# THE MONTE CARLO STANDARD ERROR OF A STANDARD DEVIATION, AND THE WORST CASE
# OVER THE DROPPED DRAWS.  Both computed here, from the per-replication draws.
#
# WHY HERE AND NOT IN THE ARM.  sqrt(n) x s.d. IS the rate claim of Panel B, and
# no standard error existed for it anywhere: the arm's summarise_arm() returns
# `sd` and no companion.  The obvious repair -- add `se_sd` there and re-run with
# SIM_SUMMARISE_ONLY -- IS UNSAFE AND WAS TESTED BEFORE BEING REJECTED.
# sim_multinomial_rootn.R's CKPT_KEY is the md5 of that file (and of
# sim_multinomial_dgp.R, lf_panel.R, orthogonal_theta.R), the checkpoint is
# loaded BEFORE the SUMMARISE_ONLY branch is consulted, and a key mismatch
# discards every cell.  So editing the arm to add one column would drop nine
# completed cells -- about seven hours -- and then summarise zero of them, and
# the three per-design tables would emit with no body at all.  The same argument
# forbids touching the three sourced files, which is why the N1 arm builds its
# own M3-off control rather than adding a flag to the shipped DGP.
#
# THE COMPUTATION IS THEREFORE RE-DERIVED, AND IT CERTIFIES ITSELF.  The `keep`
# rule below is the arm's own -- complete cases on theta across all three arms
# AND every ok_ flag set (sim_multinomial_rootn.R:498) -- and the s.d. it
# recomputes is asserted equal to the s.d. the arm reported, to 1e-12, in all 81
# (design, n, L, coefficient) cells.  If the two ever part, this stops rather
# than printing a standard error attached to a different number.
#
# THE FORMULA IS THE DELTA METHOD ON THE FOURTH MOMENT, NOT THE GAUSSIAN ONE.
#   Var(s^2) ~= (mu4 - sigma^4)/B,  so  SE(s) ~= sqrt(mu4-hat - s^4)/(2 s sqrt B)
# with mu4-hat the fourth central moment about the sample mean.  At a Gaussian
# marginal this collapses to s/sqrt(2B) = s/15.49 at B = 120, which is the 6.5
# per cent the note can quote; the estimates here are NOT Gaussian -- the
# realised kurtosis runs to 8 in the misspecified cells -- and the Gaussian form
# would understate those standard errors by about a third.  Reported per cell,
# so a reader never has to know which regime a cell is in.
# ============================================================================

CKR <- readRDS(file.path(OUT, "sim_multinomial_rootn_ckpt.rds"))
KEYS_R <- sprintf("L%d", L_GRID)
COLS_R <- CKR$cfg$cols
TH_R <- lapply(KEYS_R, function(k) match(sprintf("th%d_%s", seq_along(COEF_TEX),
                                                 k), COLS_R))
names(TH_R) <- KEYS_R
stopifnot(!anyNA(unlist(TH_R)))

#' Fourth-moment Monte Carlo standard error of a sample standard deviation.
#'
#' @param x numeric vector of replication draws.
#' @return numeric scalar; NA when the vector is degenerate.
se_of_sd <- function(x) {
  b <- length(x)
  if (b < 4L) return(NA_real_)
  s <- stats::sd(x)
  if (!is.finite(s) || s <= 0) return(NA_real_)
  mu4 <- mean((x - mean(x))^4)
  sqrt(max(mu4 - s^4, 0)) / (2 * s * sqrt(b))
}

## Keyed "dgp|n|L|coef".  Pre-allocated rather than grown (INV-17).
SESD <- local({
  keys <- character(0); vals <- numeric(0); kurt <- numeric(0)
  nrow_ <- length(D_CLEAN) + length(D_MIS)
  out_k <- character(nrow_ * length(N3) * length(L_GRID) * length(COEF_TEX))
  out_v <- numeric(length(out_k)); out_ku <- numeric(length(out_k))
  i <- 0L
  for (dd in c(D_CLEAN, D_MIS)) {
    for (n_ in N3) {
      M <- CKR$res[[sprintf("%s_n%d", dd, n_)]]
      if (is.null(M)) next
      ok <- M[, paste0("ok_", KEYS_R), drop = FALSE]
      keep <- stats::complete.cases(M[, unlist(TH_R), drop = FALSE]) &
        rowSums(ok == 1, na.rm = TRUE) == length(KEYS_R)
      for (LL in L_GRID) {
        X <- M[keep, TH_R[[sprintf("L%d", LL)]], drop = FALSE]
        for (j in seq_along(COEF_TEX)) {
          i <- i + 1L
          out_k[i] <- paste(dd, n_, LL, j, sep = "|")
          out_v[i] <- se_of_sd(X[, j])
          out_ku[i] <- mean((X[, j] - mean(X[, j]))^4) / stats::sd(X[, j])^4
          ## THE CERTIFICATE.  The s.d. recomputed here must be the s.d. the arm
          ## reported; anything else means the two are looking at different
          ## draws and every standard error below would be attached to a number
          ## it does not describe.
          ref <- S3$sd[S3$dgp == dd & S3$n == n_ & S3$L == LL & S3$coef == j]
          stopifnot(length(ref) == 1L,
                    abs(stats::sd(X[, j]) - ref) < 1e-12 * max(1, ref))
        }
      }
    }
  }
  list(se = stats::setNames(out_v[seq_len(i)], out_k[seq_len(i)]),
       kurt = stats::setNames(out_ku[seq_len(i)], out_k[seq_len(i)]))
})
message(sprintf("  s.d. standard errors: %d cells, and all %d agree with the ",
                length(SESD$se), nrow(S3)),
        "arm's own s.d. to 1e-12")

#' Monte Carlo standard error of one cell's sqrt(n)-scaled standard deviation.
#'
#' @param dd character. Design key.
#' @param n_ integer. Sample size.
#' @param L integer. Cardinality.
#' @param j integer. Coefficient index.
#' @return numeric scalar.
sd_se <- function(dd, n_, L, j) {
  v <- SESD$se[[paste(dd, n_, L, j, sep = "|")]]
  if (is.null(v)) NA_real_ else v
}

#' Worst-case coverage bound over the draws a cell dropped.
#'
#' A dropped draw either covers or does not, so a coverage p-hat measured on b of
#' B draws lies in [p b/B, (p b + (B-b))/B] whatever the dropped draws would have
#' done.  SELECTION IS REAL AND ITS DIRECTION IS KNOWN -- a draw survives when
#' the nonparametric stage behaved, so the retained figures are optimistic -- and
#' a stated bound is worth more than a disclosure of that fact.
#'
#' @param dd character. Design key.
#' @return list(lo_worst, hi_worst, cell) at the design's widest displacement.
drop_bound <- function(dd) {
  best <- list(disp = -1)
  for (n_ in N3) {
    for (L in L_GRID) {
      b <- b_used(dd, n_, L)
      if (is.null(b)) next
      for (j in seq_along(COEF_TEX)) {
        x <- S3[S3$dgp == dd & S3$n == n_ & S3$L == L & S3$coef == j, ]
        if (!nrow(x)) next
        lo <- x$cover * b / B_REQ
        hi <- (x$cover * b + (B_REQ - b)) / B_REQ
        d <- max(x$cover - lo, hi - x$cover)
        if (d > best$disp) best <- list(disp = d, p = x$cover, lo = lo, hi = hi,
                                        n = n_, L = L, j = j, b = b)
      }
    }
  }
  best
}

#' The dropped-draw bound as one spanning header line.
#'
#' Emitted from the same b_used() the count line reads, so the two cannot
#' disagree, and never transcribed (INV-22).
#'
#' @param dd character. Design key.
#' @return character(1), a spanning-row payload without the \multicolumn wrapper.
drop_line <- function(dd) {
  z <- drop_bound(dd)
  if (z$disp < 0) return(character(0))
  ## WIDTH IS THE STOP RULE ON THIS LINE AND IT WAS MEASURED, NOT GUESSED.  The
  ## first draft named the cell -- "at $n{=}400$, $\\mathsf L{=}3$" -- and
  ## measured 451.5pt at \\footnotesize, which put the whole tabular at 466.9pt
  ## against a 469.8pt text block: inside, by 2.9pt, on a table that had 69pt of
  ## clearance before this pass.  The cell is recoverable from Panel C by the
  ## reader and the bound is not, so the bound stays and the cell goes; this form
  ## measures 357.1pt, under the block header the table already carries.
  sprintf(paste("\\quad Dropped draws move any coverage by at most $%s$;",
                "worst $%s\\to[%s,\\,%s]$"),
          ff(z$disp, 3), ff(z$p, 3), ff(z$lo, 3), ff(z$hi, 3))
}

# ============================================================================
# T1 / T2  thm:rootn with CARDINALITY AS COLUMNS.  Block III only.
#
# Three quantities, three panels, one row per (design, n, coefficient).  Every
# row is one design at one sample size, so the three numeric columns differ in
# the cardinality of W AND IN NOTHING ELSE: sim_multinomial_dgp.R's M4 builds
# w4, w3 = min(w4,2) and w2 = 1{w4>0} off ONE draw, and sim_multinomial_rootn.R's
# S1 restores the RNG state before each arm so the cross-fitting partition is
# shared too.  This is the only cardinality contrast in the paper that is paired.
# ============================================================================

mk_rootn <- function(designs, file) {
  ncol_ <- 3L + length(L_GRID)
  hdr <- BLK3
  hdr[1] <- sprintf("%s, \\emph{%s design}", hdr[1], DTEX[[designs[1]]])
  ## The counts go in the BLOCK header, not in each quantity panel.  B is a
  ## property of the run, not of the quantity: three identical copies of one
  ## line, one per panel, invite the reader to check whether they differ.  This
  ## is a local edit to `hdr` -- BLK3 itself is untouched, so T4 and T5, which
  ## also panel() it, emit byte-for-byte what they emitted before.
  ## Two generated header lines, not one.  The count line says how many draws
  ## survived; the bound line says what the ones that did not could have done.
  ## Disclosure without a bound leaves the reader to assume the worst, and the
  ## worst here is small: at most 0.067 of the coverage scale at the thinnest
  ## cell and 0.008 at n = 1,600.
  hdr <- c(hdr, b_lines(designs[1]), drop_line(designs[1]))
  l <- c(sprintf("\\begin{tabular}{lll%s}", strrep("c", length(L_GRID))),
         "\\toprule",
         panel(hdr, ncol_),
         "\\midrule",
         paste0("Design & $n$ & Coefficient & ",
                paste(sprintf("$\\mathsf L=%d$", L_GRID), collapse = " & "),
                " \\\\"),
         "\\midrule")
  panels <- list(
    list(tag = paste("\\textit{Panel A: bias, with its Monte Carlo standard",
                     "error.  Truth $(0,\\,1.0,\\,-0.5)$.}"),
         get = function(x, j) pm(x$bias[j], x$se_bias[j])),
    ## NO \cref IN A GENERATED FRAGMENT.  The caption the writer places names the
    ## theorem; a cross-reference inside the body makes the table fragment
    ## depend on a label defined in a document it knows nothing about, and it
    ## renders "??" in any harness that compiles the fragment on its own.
    ## PANEL B CARRIES A STANDARD ERROR NOW, AND IT COSTS NO WIDTH.  sqrt(n) s.d.
    ## IS the rate claim, and it shipped as a bare number: a reader could not
    ## tell the balanced constant's 5.571 -> 6.640 rise (about 2.1 s.e.) from the
    ## misspecified 6.031 -> 8.605 (about 3.8), and the second is the finding
    ## while the first is not.  The widest cell this format produces is
    ## "6.640 (0.446)", thirteen characters; Panel A already sets these columns
    ## at "-0.1053 (0.0428)", sixteen.  So the column width is Panel A's before
    ## and after and the width certificate in main.qmd survives the edit.
    list(tag = paste("\\textit{Panel B: $\\sqrt n\\times$ s.d., which the",
                     "theorem makes constant in $n$, with its s.e.}"),
         get = function(x, j) {
           se <- sd_se(x$dgp[j], x$n[j], x$L[j], j)
           if (is.finite(se)) pm(sqrt(x$n[j]) * x$sd[j],
                                 sqrt(x$n[j]) * se, 3)
           else ff(sqrt(x$n[j]) * x$sd[j], 3)
         }),
    list(tag = paste("\\textit{Panel C: coverage of the nominal $95\\%$",
                     "interval, with its Monte Carlo standard error.}"),
         get = function(x, j) pm(x$cover[j], x$se_cover[j], 3)))
  for (pi_ in seq_along(panels)) {
    if (pi_ > 1L) l <- c(l, "\\addlinespace")
    l <- c(l, panel(panels[[pi_]]$tag, ncol_), "\\midrule")
    for (dd in designs) {
      first_d <- TRUE
      for (n_ in N3) {
        first_n <- TRUE
        for (j in seq_along(COEF_TEX)) {
          cells <- vapply(L_GRID, function(L) {
            x <- S3[S3$dgp == dd & S3$n == n_ & S3$L == L, ]
            if (!nrow(x)) DASH else panels[[pi_]]$get(x, j)
          }, character(1))
          if (all(cells == DASH)) next
          l <- c(l, sprintf("%s & %s & %s & %s \\\\",
                            blank_rep(DTEX[[dd]], first_d),
                            blank_rep(nn(n_), first_n), COEF_TEX[j],
                            paste(cells, collapse = " & ")))
          first_d <- first_n <- FALSE
        }
      }
      if (dd != designs[length(designs)]) l <- c(l, "\\addlinespace")
    }
  }
  write_tab(c(l, "\\bottomrule", "\\end{tabular}"), file)
}
## ONE TABLE PER DESIGN, AND THE MEASUREMENT IS THE REASON.  Three quantity
## panels over both correctly-specified designs measure 787.5pt against a
## 650.4pt text block at \footnotesize; the tallest body Section 5 currently
## places is sim_thm_rootn_limitlaw.tex at 501.5pt, which with a caption and
## INV-1 notes is already most of a page.  Splitting on the DESIGN rather than on
## a quantity panel costs nothing that can be compared: the designs are separate
## data-generating laws, so no row is ever read against a row of the other, while
## cardinality -- the comparison that must survive -- stays inside every row.
## It also puts one design name, and only one, in each table's block header.
for (dd in c(D_CLEAN, D_MIS)) {
  mk_rootn(dd, sprintf("sim_merged_rootn_%s.tex", dd))
}

# ============================================================================
# T2b  THE DIAGNOSTIC THAT EXPLAINS PANEL C, AND THAT WAS COMPUTED AND NEVER
#      PRINTED.  Block III only.
#
# summarise_arm() has returned `se_ratio = colMeans(S)/sdv` -- the mean sandwich
# standard error over the Monte Carlo standard deviation -- since the arm was
# written, and it appeared in no table.  It is the quantity that says WHETHER A
# COVERAGE SHORTFALL IS A VARIANCE PROBLEM OR A DISTRIBUTION PROBLEM, and the
# suite has a coverage shortfall that a range conceals: "coverage at n = 1,600
# sits between 0.866 and 0.975" is true and hides that the low end is
# PERSISTENT, ONE-SIDED AND NON-SHRINKING.  The balanced constant at four cells
# runs 0.863, 0.842, 0.866 across the grid -- flat, and more than 2.7 Monte
# Carlo standard errors under nominal at the largest n -- and the skewed z2 moves
# AWAY from nominal as n grows.  A coverage of 0.866 is an effective half-width
# of 1.50 rather than 1.96 standard errors, i.e. an understatement of about 23
# per cent, and se_ratio is that number measured directly.
#
# A SEPARATE TABLE AND NOT A FOURTH PANEL, AND THE REASON IS HEIGHT.  The three
# per-design tabulars measure 457.1pt with the header line this pass added, and
# they are already [p] floats; a fourth panel is twelve more rows, about 144pt,
# which with a caption and INV-1 notes would not fit a page.  A separate table
# also puts the three designs in ONE body, which is where this diagnostic has to
# be read: the finding is that the understatement is present at the FAVOURABLE
# design too, and that is invisible when each design has its own float.
#
# PANEL B IS A DERIVED QUANTITY AND IS LABELLED AS ONE.  A centred normal whose
# standard error is r times its standard deviation covers a nominal 95 per cent
# interval with probability 2 Phi(1.96 r) - 1.  Printing that against the
# REALISED coverage decomposes the shortfall: a small difference means the
# interval is mis-scaled and nothing else, and a large one means the limit law
# itself is not yet reached.  The approximation ignores two things and says so
# in the panel tag -- the randomness of the standard error, and the bias, which
# is separately in Panel A of the per-design tables.
# ============================================================================

mk_seratio <- function(file) {
  ## THE TWO QUANTITIES SIT SIDE BY SIDE AND NOT IN STACKED PANELS, AND THE
  ## REASON IS MEASURED.  Stacked, the two 27-row panels make a tabular
  ## 793.5pt tall against a 650.4pt text block -- 143pt over, before a caption
  ## and INV-1 notes, so it would not fit a page in any float placement.  Side
  ## by side the same 54 numbers are 27 rows: 338.4pt wide, well inside
  ## \textwidth, and the reader gets the ratio and what it implies on ONE line
  ## rather than 40 rows apart.  The device is tab:sim-merged-precision's, which
  ## already carries two \cmidrule'd groups over a shared stub.
  ncol_ <- 3L + 2L * length(L_GRID)
  hdr <- BLK3
  hdr[2] <- paste("\\quad the interval's scale, not its centre:",
                  "\\texttt{lf\\_panel.R}, $\\mathsf L$ off one draw")
  l <- c(sprintf("\\begin{tabular}{lll%s}", strrep("c", 2L * length(L_GRID))),
         "\\toprule",
         vapply(hdr, function(t) sprintf("\\multicolumn{%d}{l}{%s} \\\\",
                                         ncol_, t), character(1),
                USE.NAMES = FALSE),
         "\\midrule",
         sprintf(paste("& & & \\multicolumn{%d}{c}{Mean s.e.\\ over Monte Carlo",
                       "s.d.} & \\multicolumn{%d}{c}{Implied $-$ realised",
                       "coverage} \\\\"), length(L_GRID), length(L_GRID)),
         sprintf("\\cmidrule(lr){4-%d}\\cmidrule(lr){%d-%d}",
                 3L + length(L_GRID), 4L + length(L_GRID), ncol_),
         paste0("Design & $n$ & Coefficient & ",
                paste(rep(sprintf("$\\mathsf L=%d$", L_GRID), 2L),
                      collapse = " & "), " \\\\"),
         "\\midrule")
  ## Panel A is the ratio itself: unity is exact, below unity the interval is
  ## too short.  Panel B is DERIVED and is labelled as derived in the note the
  ## writer places: a centred normal whose standard error is r times its
  ## standard deviation covers a nominal 95 per cent interval with probability
  ## 2 Phi(1.96 r) - 1, and the column is that minus the realised coverage.  A
  ## small entry means the interval is mis-scaled and NOTHING ELSE; a large one
  ## means the limit law itself is not yet reached.  The approximation ignores
  ## the standard error's own randomness and the bias, and the bias is in
  ## Panel A of the per-design tables.
  get_ratio <- function(x, j) ff(x$se_ratio[j], 3)
  get_gap <- function(x, j)
    ff(2 * stats::pnorm(stats::qnorm(0.975) * x$se_ratio[j]) - 1 - x$cover[j], 3)
  for (dd in c(D_CLEAN, D_MIS)) {
    first_d <- TRUE
    for (n_ in N3) {
      first_n <- TRUE
      for (j in seq_along(COEF_TEX)) {
        cells <- c(vapply(L_GRID, function(L) {
                     x <- S3[S3$dgp == dd & S3$n == n_ & S3$L == L, ]
                     if (!nrow(x)) DASH else get_ratio(x, j)
                   }, character(1)),
                   vapply(L_GRID, function(L) {
                     x <- S3[S3$dgp == dd & S3$n == n_ & S3$L == L, ]
                     if (!nrow(x)) DASH else get_gap(x, j)
                   }, character(1)))
        if (all(cells == DASH)) next
        l <- c(l, sprintf("%s & %s & %s & %s \\\\",
                          blank_rep(DTEX[[dd]], first_d),
                          blank_rep(nn(n_), first_n), COEF_TEX[j],
                          paste(cells, collapse = " & ")))
        first_d <- first_n <- FALSE
      }
    }
    if (dd != D_MIS) l <- c(l, "\\addlinespace")
  }
  write_tab(c(l, "\\bottomrule", "\\end{tabular}"), file)
}
mk_seratio("sim_merged_seratio.tex")

# ============================================================================
# T3  THE THREE-BLOCK CONTRAST AT THE ONE CARDINALITY ALL THREE SHARE.
#
# The shared observable is the empirical coverage of the nominal interval; it is
# the only quantity all three blocks measure against the same target.  It is
# reported AT THE LARGEST n ON EACH BLOCK'S OWN GRID, which the table prints,
# because the grids do not intersect: Blocks I and II run 125 to 181,019 and
# Block III runs 400 to 1,600.  Reading a Block I row against a Block III row is
# therefore reading two designs at two sample sizes with two estimators, and the
# row labels, the n column, the B column and the regime column all say so.
#
# The last column is the point of the table: it records which cardinalities the
# block ran, so the em-dashes in the L = 3 and L = 4 columns of Blocks I and II
# are attributable to the design and not to a gap in the run.
# ============================================================================

#' One row of the three-block contrast.
#' @return character vector of length 6: label, n, B, cov at L=2,3,4.
blk_row <- function(label, n_max, B, cov, se, extra = c(DASH, DASH)) {
  c(label, nn(n_max), nn(B), pm(cov, se, 3), extra)
}

rows <- list()                                                         # INV-17
ncol3 <- 6L
core1 <- LL[LL$cell == "core" & LL$n == max(LL$n), ]
core1 <- core1[order(core1$dgp, core1$c_delta), ]
for (i in seq_len(nrow(core1))) {
  rows[[length(rows) + 1L]] <- list(blk = 1L, cells = blk_row(
    sprintf("DGP %s, injected $c_\\delta=%s$", core1$dgp[i],
            ff(core1$c_delta[i], 2)),
    core1$n[i], core1$B[i], core1$cover95[i], core1$cover95_se[i]))
}
core2 <- HH[HH$cell == "core" & HH$n == max(HH$n), ]
core2 <- core2[order(core2$dgp, core2$c_delta), ]
for (i in seq_len(nrow(core2))) {
  rows[[length(rows) + 1L]] <- list(blk = 2L, cells = blk_row(
    sprintf("DGP-%s, injected $c_\\delta=%s$", core2$dgp[i],
            ff(core2$c_delta[i], 2)),
    core2$n[i], core2$B[i], core2$cover95[i], core2$cover95_se[i]))
}
n3max <- max(N3)
for (dd in c(D_CLEAN, D_MIS)) {
  for (j in seq_along(COEF_TEX)) {
    cells <- vapply(L_GRID, function(L) {
      x <- S3[S3$dgp == dd & S3$n == n3max & S3$L == L & S3$coef == j, ]
      if (!nrow(x)) DASH else pm(x$cover, x$se_cover, 3)
    }, character(1))
    if (all(cells == DASH)) next
    x2 <- S3[S3$dgp == dd & S3$n == n3max & S3$L == 2L & S3$coef == j, ]
    rows[[length(rows) + 1L]] <- list(blk = 3L, cells = c(
      sprintf("%s, %s, estimated", DTEX[[dd]], COEF_TEX[j]),
      nn(n3max), nn(x2$n_used), cells))
  }
}

l <- c("\\begin{tabular}{lrrccc}", "\\toprule",
       paste("Design and nuisance regime & $n$ & $B$ &",
             "$\\mathsf L=2$ & $\\mathsf L=3$ & $\\mathsf L=4$ \\\\"),
       "\\midrule")
for (b in 1:3) {
  if (b > 1L) l <- c(l, "\\addlinespace")
  l <- c(l, panel(list(BLK1, BLK2, BLK3)[[b]], ncol3), "\\midrule")
  for (r in rows) if (r$blk == b)
    l <- c(l, paste0(paste(r$cells, collapse = " & "), " \\\\"))
}
write_tab(c(l, "\\bottomrule", "\\end{tabular}"), "sim_merged_designs.tex")

# ============================================================================
# T4  THE PAIRED CARDINALITY CONTRAST.  Block III only, and only Block III can
# carry it: pairing requires the two arms to share a draw, and no draw is shared
# between an abstract-operator block and the shipped engine.
#
# The standard-deviation ratio is a ratio of two marginal standard deviations
# over the SAME draws; the bias difference is a WITHIN-DRAW mean and carries its
# own standard error, so it is the column on which the precision claim can fail.
# sim_multinomial_precision.tex reports the paired difference for L = 4 against
# L = 2 only; both surplus cardinalities are reported here.
# ============================================================================

CK <- file.path(OUT, "sim_multinomial_rootn_ckpt.rds")
if (!file.exists(CK)) {
  stop("missing ", CK, "; the paired panel needs the per-replication draws.\n",
       "  run: Rscript scripts/simulations/sim_multinomial_rootn.R")
}
ck <- readRDS(CK)
KEYS <- sprintf("L%d", L_GRID)
COLS <- ck$cfg$cols
TH_IDX <- lapply(KEYS, function(k) match(sprintf("th%d_%s", 1:3, k), COLS))
names(TH_IDX) <- KEYS

l <- c("\\begin{tabular}{lllcccc}", "\\toprule",
       panel(BLK3, 7L),
       "\\midrule",
       paste("& & & \\multicolumn{2}{c}{s.d.\\ ratio against $\\mathsf L=2$}",
             "& \\multicolumn{2}{c}{Paired bias difference (s.e.)} \\\\"),
       "\\cmidrule(lr){4-5}\\cmidrule(lr){6-7}",
       paste("Design & $n$ & Coefficient & $\\mathsf L=3$ & $\\mathsf L=4$ &",
             "$\\mathsf L=3-\\mathsf L=2$ & $\\mathsf L=4-\\mathsf L=2$ \\\\"),
       "\\midrule")
for (dd in c(D_CLEAN, D_MIS)) {
  first_d <- TRUE
  for (n_ in N3) {
    key <- sprintf("%s_n%d", dd, n_)
    M <- ck$res[[key]]
    if (is.null(M)) next
    ok <- M[, paste0("ok_", KEYS), drop = FALSE]
    keep <- stats::complete.cases(M[, unlist(TH_IDX), drop = FALSE]) &
      rowSums(ok == 1, na.rm = TRUE) == length(KEYS)
    D3 <- M[keep, TH_IDX$L3, drop = FALSE] - M[keep, TH_IDX$L2, drop = FALSE]
    D4 <- M[keep, TH_IDX$L4, drop = FALSE] - M[keep, TH_IDX$L2, drop = FALSE]
    nb <- sum(keep)
    first_n <- TRUE
    for (j in seq_along(COEF_TEX)) {
      s <- function(L) {
        x <- S3[S3$dgp == dd & S3$n == n_ & S3$L == L & S3$coef == j, ]
        if (nrow(x)) x$sd else NA_real_
      }
      l <- c(l, sprintf("%s & %s & %s & %s & %s & %s & %s \\\\",
                        blank_rep(DTEX[[dd]], first_d),
                        blank_rep(nn(n_), first_n), COEF_TEX[j],
                        ff(s(3L) / s(2L), 3), ff(s(4L) / s(2L), 3),
                        pm(mean(D3[, j]), stats::sd(D3[, j]) / sqrt(nb)),
                        pm(mean(D4[, j]), stats::sd(D4[, j]) / sqrt(nb))))
      first_d <- first_n <- FALSE
    }
  }
  if (dd != D_MIS) l <- c(l, "\\addlinespace")
}
write_tab(c(l, "\\bottomrule", "\\end{tabular}"), "sim_merged_precision.tex")

# ============================================================================
# T5  THE ONE STATISTIC BOTH phi-STEP ARMS MEASURE.
#
# Pr(the discrepancy rule selects an iterate at or before the budget).  In Block
# I that is 1 - Pr(cap): sim_thm_rootn_phistep.R's branches at_one, at_int and
# at_cap sum to one in all 36 cells, and at_cap is the branch on which the rule
# returned the budget without ever meeting its threshold.  In Block III it is the
# share of paths with a non-missing m_dp, which is the same event.
#
# THE TWO ARMS DO NOT PARAMETERISE THE THRESHOLD THE SAME WAY AND THEIR BUDGETS
# DIFFER BY FOUR DECADES, so both are printed as columns.  Block I sweeps
# c_14 over four decades against a budget of eq:cap, of order 1e5 to 1e6; Block
# III fixes tau_DP at lf_panel.R's registered 0.7 against a cap of 100.  Reading
# a Block I row against a Block III row without reading those two columns is
# reading two different rules.
#
# Only the two decades in which Block I's branch frequencies are non-degenerate
# are printed.  Outside them the answer is a constant and is stated in the note
# the writer will place, not spread over twenty-four identical rows: Pr(cap) is
# one in all twelve cells at c_14 <= 1e-3 and Pr(m = 1) is one in all twelve at
# c_14 >= 1e-1.
# ============================================================================

C14_SHOW <- c(1e-2, 3e-2)
c14_tex <- function(v) if (isTRUE(all.equal(v, 1e-2))) "$10^{-2}$" else
  sprintf("$%g\\times10^{-2}$", v * 100)

l <- c("\\begin{tabular}{llrrccc}", "\\toprule",
       paste("& & & &",
             "\\multicolumn{3}{c}{$\\Pr(\\text{rule selects an iterate})$} \\\\"),
       "\\cmidrule(lr){5-7}",
       paste("Design and preliminary & Threshold & Budget & $n$ &",
             "$\\mathsf L=2$ & $\\mathsf L=3$ & $\\mathsf L=4$ \\\\"),
       "\\midrule",
       panel(BLK1, 7L), "\\midrule")
PS1 <- PS1[order(PS1$prelim, PS1$c14, PS1$n), ]
## THE BUDGET IS A PROPERTY OF n, NOT OF THE THRESHOLD.  eq:cap's mbar_n is
## realised per replication, so the cell means differ in the fourth digit across
## the c_14 sweep; printing the cell's own mean would put three different budgets
## against one n and read as though the cap moved with the threshold.  The mean
## over the sweep at each n is what tab:sim-stopping Panel C already prints, so
## the two tables carry the same number (INV-11).
MBAR <- vapply(sort(unique(PS1$n)),
               function(v) mean(PS1$mbar_new[PS1$n == v]), numeric(1))
names(MBAR) <- sort(unique(PS1$n))
for (pr in c("zero", "rate")) {
  first_pr <- TRUE
  for (cv in C14_SHOW) {
    sel <- PS1[PS1$prelim == pr & abs(PS1$c14 - cv) < 1e-12, ]
    sel <- sel[order(sel$n), ]
    first_c <- TRUE
    for (i in seq_len(nrow(sel))) {
      fires <- 1 - sel$at_cap[i]
      l <- c(l, sprintf("%s & %s & %s & %s & %s & %s & %s \\\\",
                        ## The block header already names the design, so the
                        ## row label carries only what varies inside the block.
                        blank_rep(sprintf("%s preliminary", pr), first_pr),
                        blank_rep(c14_tex(cv), first_c),
                        nn(round(MBAR[[as.character(sel$n[i])]])),
                        nn(sel$n[i]), ff(fires, 3), DASH, DASH))
      first_pr <- first_c <- FALSE
    }
  }
  if (pr != "rate") l <- c(l, "\\addlinespace")
}
l <- c(l, "\\addlinespace", panel(BLK3, 7L), "\\midrule")
for (dd in c(D_CLEAN, D_MIS)) {
  first_d <- TRUE
  for (n_ in N3) {
    cells <- vapply(L_GRID, function(L) {
      x <- P3[P3$dgp == dd & P3$n == n_ & P3$L == L, ]
      if (!nrow(x)) DASH else
        sprintf("%s [%d/%d]", ff(mean(!is.na(x$m_dp)), 3),
                sum(!is.na(x$m_dp)), nrow(x))
    }, character(1))
    if (all(cells == DASH)) next
    l <- c(l, sprintf("%s & %s & %s & %s & %s \\\\",
                      blank_rep(DTEX[[dd]], first_d),
                      blank_rep("$\\tau_{\\mathrm{DP}}=0.7$", first_d),
                      blank_rep("100", first_d),
                      nn(n_), paste(cells, collapse = " & ")))
    first_d <- FALSE
  }
  if (dd != D_MIS) l <- c(l, "\\addlinespace")
}
write_tab(c(l, "\\bottomrule", "\\end{tabular}"), "sim_merged_stopping.tex")

# ---- console verdict -------------------------------------------------------

cat("\n\n===== WHAT MERGED, AND ON WHAT ==================================\n")
cat("Block I  : ", nrow(LL[LL$cell == "core", ]), " core cells, n = ",
    min(LL$n), "-", nn(max(LL$n)), ", B = ", max(LL$B, na.rm = TRUE), "\n", sep = "")
cat("Block II : ", nrow(HH[HH$cell == "core", ]), " core cells, n = ",
    min(HH$n), "-", nn(max(HH$n)), ", B = ", max(HH$B, na.rm = TRUE), "\n", sep = "")
cat("Block III: ", length(unique(paste(S3$dgp, S3$n))), " cells x 3 cardinalities, n = ",
    min(N3), "-", nn(max(N3)), ", B = ", max(S3$n_used), " usable\n", sep = "")
cat("\nGrid intersection between the abstract-operator blocks and Block III: ",
    length(intersect(unique(LL$n), N3)), " sample sizes.\n", sep = "")
cat("Every merged row is one block.  Cardinality varies within a row only.\n")
cat("\ndone\n")
