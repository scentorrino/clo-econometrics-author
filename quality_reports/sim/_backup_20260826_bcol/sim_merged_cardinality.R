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
    list(tag = paste("\\textit{Panel B: $\\sqrt n\\times$ s.d., which the",
                     "theorem makes constant in $n$.}"),
         get = function(x, j) ff(sqrt(x$n[j]) * x$sd[j], 3)),
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
