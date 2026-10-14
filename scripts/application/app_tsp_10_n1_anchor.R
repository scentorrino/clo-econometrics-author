## ---------------------------------------------------------------------------
## app_tsp_10_n1_anchor.R -- IS N1 IMPOSED ON THE APPLICATION'S DEBIASING
## WEIGHT?  A MEASUREMENT, NOT A REPAIR.
##
## THE QUESTION.  thm:rootn's hypothesis (T-2) requires N1 AT L-star:
##
##     E[ L_star(dU, dZ) | dZ ] = 0    as a p x (L-1) MATRIX,
##
## i.e. p(L-1) SCALAR conditions, one per (j, l) -- NOT a condition on any
## contraction of the L-1 columns.  prp:orthog(iii) proves N1 is necessary and
## sufficient for exact orthogonality in the PROPENSITY direction: the Gateaux
## derivative of E[psi_j] in direction delta_l(dZ) is
##
##     - varpi_w(l) E[ delta_l(dZ) E[ L_jl(dU) | dZ ] ],
##
## so the operator norm of that derivative over ||delta||_{L^2} <= 1 is exactly
## varpi_w(l) || E[L_jl | dZ] ||_{L^2}.  When N1 fails, the term lem:biasexp
## Step 2(c) normally deletes survives at order r_n and sqrt(n) x bias carries a
## summand of order n^{1/2 - alpha}, which DIVERGES.
##
## L_ell^b is determined by ell only up to an anchor b(dZ), free in u.  The N1
## anchor is b^c = -E[ int_0^{dU} ell | dZ ], a FUNCTION OF dZ.  A constant
## anchor is admissible as a definition of a primitive but is not the one (T-2)
## and (R-a) point at.
##
## WHAT THE ESTIMATOR DOES (read off orthogonal_theta.R, verified below).
##   * eval_lambda() returns  sigma_u sqrt(2 pi) sum_j alpha_j Phi((u-u_j)/sigma_u),
##     the antiderivative of ell-hat anchored at u = -infinity.  No dZ anywhere.
##   * crossfit_once()'s eval_moment() then applies, per (j, l),
##         lam[, , l] <- sweep(sl, 2L, colMeans(sl), "-")
##     i.e. it subtracts the UNCONDITIONAL sample mean.  Its comment justifies
##     the operation by "Wtil is centred in sample, so sum_i Wtil_i c = 0" --
##     which is an argument that the constant does not matter, not an argument
##     that this is the N1 anchor.  It is not: N1 asks for a dZ-MEASURABLE
##     anchor and this one is a scalar per (j, l).
##
## THE MEASUREMENT IS THEREFORE SHARP, AND THIS IS WHY THE NUMBER BELOW IS THE
## RIGHT NUMBER.  Because the projection of L on a basis containing an intercept
## preserves sample means,
##
##     min_b  || E-hat[ lambda_jl + b | dZ ] ||_{L^2}
##
## over CONSTANT b is attained at b = -mean(lambda_jl) and equals the standard
## deviation of the fitted values -- which is exactly what the shipped sweep
## produces.  So the quantity reported here is the IRREDUCIBLE N1 defect over
## the whole class of constant anchors: no u-free, dZ-free constant can lower
## it, and only a genuinely dZ-dependent anchor can.
##
## WHAT THIS SCRIPT DOES NOT DO.  It changes no estimator, re-tunes nothing, and
## writes into no shipped artifact.  Re-anchoring would require estimating
## E[int_0^{dU} ell-hat | dZ], a further nuisance and an estimator change the
## author has not authorised.  Diagnose, measure, report.
##
## HOW THE SHIPPED FIT IS REACHED WITHOUT RE-RUNNING THE PIPELINE.  Every arm of
## Section 6 draws its cross-fitting partitions from deterministic L'Ecuyer
## streams chained off one script-level seed (make_streams() in
## app_tsp_common.R), and fit_one_partition() assigns its stream as its first
## statement.  Replaying stream b therefore reproduces partition b BIT-FOR-BIT,
## which is asserted below against the shipped .rds rather than assumed.  The
## replay calls crossfit_once() -- the same function fit_one_partition() calls,
## with the same arguments -- and then reads eval_moment()'s own `lam`, so the
## object measured is the shipped L-hat^{(-k)} and not a reconstruction of it.
##
## CARRIED, NOT RE-OPENED: TAU_DP = 0 (C26), m-bar common at 60 for the
## theta-hat contrast (app_tsp_08_localise.R), eps_for() cardinality-indexed
## (C27 as extended), and the boundary adjustment now in place.
##
## Output: quality_reports/application/app_tsp_n1_anchor.rds
##         paper/tables/app_tsp_n1_anchor.tex   (bare tabular, INV-13)
## ---------------------------------------------------------------------------

suppressMessages({
  library(here)
  library(parallel)
})
source(here::here("scripts", "R", "lf_panel.R"))
source(here::here("scripts", "R", "orthogonal_theta.R"))
source(here::here("scripts", "application", "app_tsp_common.R"))

RNGkind("L'Ecuyer-CMRG")
SEED_N1 <- 20260815L
set.seed(SEED_N1)                                                    # INV-14

D_Z     <- 5L        # the application's headline control set
B_PERM  <- 300L      # permutation draws for the projection noise floor
N_CORES_N1 <- 8L

## Output root.  Defaults to the repository tree; the override exists so a
## regeneration can be written to a scratch tree and DIFFED against the shipped
## artifacts before it replaces them, which is this project's standing rule for
## cached output (app_tsp_08_localise.R and app_tsp_09_boundary.R already carry
## it).  INPUTS -- the shipped fits this stage replays against -- are always read
## from the repository tree, so a scratch run still validates against what
## shipped rather than against itself.
OUT_ROOT <- Sys.getenv("APP_TSP_OUT_ROOT", unset = here::here())
OUT <- file.path(OUT_ROOT, "quality_reports", "application")
TAB <- file.path(OUT_ROOT, "paper", "tables")
IN  <- here::here("quality_reports", "application")
for (d in c(OUT, TAB)) dir.create(d, showWarnings = FALSE, recursive = TRUE)

# ---- data, instruments, design ---------------------------------------------

P  <- load_tsp_panel()
dt <- P$dt
n  <- nrow(dt)
iv <- load_tsp_w4(dt)
w4 <- iv$w4
w2 <- as.integer(dt$w)
Z  <- make_design(dt, d_z = D_Z)
xc <- make_x_coord(dt$x1_raw, dt$x2_raw, mode = "rank")
y  <- dt$dy
cl <- dt$cluster
xev <- seq(stats::quantile(c(xc$x1, xc$x2), XEVAL_LO),
           stats::quantile(c(xc$x1, xc$x2), XEVAL_HI), length.out = N_XEVAL)
stopifnot(nrow(Z) == n, ncol(Z) == D_Z + 1L, !anyNA(Z), !anyNA(y),
          identical(colnames(Z)[1], "const"),
          identical(as.numeric(w4 > 0L), as.numeric(w2)))

## The conditioning set: dZ WITHOUT the intercept.  These columns are already
## 1970-80 differences in the raw file, so Z is dZ and no differencing is done
## here.
DZC <- as.matrix(Z[, -1L, drop = FALSE])
d_cond <- ncol(DZC)

# ---- projection bases -------------------------------------------------------

#' Column-standardise a matrix, dropping degenerate columns.
#'
#' @param M numeric matrix.
#' @return numeric matrix with unit-variance, mean-zero columns.
standardise_cols <- function(M) {
  s <- apply(M, 2L, stats::sd)
  keep <- s > 0
  M <- M[, keep, drop = FALSE]
  sweep(sweep(M, 2L, colMeans(M), "-"), 2L, s[keep], "/")
}

#' All distinct pairwise products of the columns of M.
#'
#' @param M numeric matrix.
#' @return numeric matrix with choose(ncol(M), 2) columns.
pairwise_products <- function(M) {
  d <- ncol(M)
  if (d < 2L) return(matrix(0, nrow(M), 0L))
  idx <- utils::combn(d, 2L)
  out <- matrix(0, nrow(M), ncol(idx))                               # INV-17
  for (k in seq_len(ncol(idx))) {
    out[, k] <- M[, idx[1L, k]] * M[, idx[2L, k]]
  }
  out
}

#' The three conditioning bases, from coarse to flexible.
#'
#' B1 spans the linear index the estimator's own propensity uses (glm /
#' multinom are linear in dZ), so a defect visible in B1 is one varrho-hat
#' itself could move against.  B2 and B3 widen the class.
#'
#' @param DZ numeric matrix. Conditioning variables, no intercept.
#' @return named list of numeric matrices, each with a leading intercept.
make_bases <- function(DZ) {
  S <- standardise_cols(DZ)
  b1 <- cbind(1, S)
  b2 <- cbind(1, S, S^2, pairwise_products(S))
  cub <- matrix(0, nrow(S), 3L * ncol(S))                            # INV-17
  for (j in seq_len(ncol(S))) {
    cub[, (3L * j - 2L):(3L * j)] <- stats::poly(S[, j], degree = 3L)
  }
  b3 <- cbind(1, cub, pairwise_products(S))
  list(linear = b1, quadratic = b2, cubic = b3)
}

#' Orthonormal column basis of a design matrix, rank-revealing.
#'
#' @param B numeric matrix.
#' @return numeric matrix n x rank(B) with orthonormal columns.
orthonormalise <- function(B) {
  qrb <- qr(B, tol = 1e-9)
  keep <- qrb$pivot[seq_len(qrb$rank)]
  qr.Q(qr(B[, keep, drop = FALSE]))
}

#' Projection statistics of each column of Y onto span(Q): raw and DEBIASED.
#'
#' THE RAW STATISTIC IS NOT AN ESTIMATE OF THE DEFECT AND MUST NOT BE READ AS
#' ONE.  With r basis functions and n observations, || P_Q Y ||^2 / n has
#' expectation || m ||^2 + n^{-1} tr(Q' Sigma Q) even when m = 0, and at
#' r = 21, n = 983 the second term alone is about (0.15 sd(Y))^2 -- the same
#' order as any defect worth arguing about.  The raw statistic is therefore
#' reported only against its own permutation floor, and the POINT ESTIMATE of
#' the defect is the debiased one:
#'
#'     deb2 = ( || Q'Y ||^2 - sum_i h_i e_i^2 / (1 - h_i) ) / n,
#'     h_i  = sum_k Q_{ik}^2   (leverage),   e = Y - P_Q Y,
#'
#' i.e. HC2.  Under m = 0 this is centred at zero by construction, which the
#' permutation reference verifies rather than assumes.  It can be negative;
#' that is the point, and it is reported signed rather than clamped.
#'
#' @param Q numeric matrix with orthonormal columns.
#' @param Y numeric matrix, n rows.
#' @return named list: proj (raw L^2 norm), deb2 (debiased squared defect).
proj_stats <- function(Q, Y) {
  nn <- nrow(Y)
  cc <- crossprod(Q, Y)
  ss <- colSums(cc^2)
  ee <- Y - Q %*% cc
  h  <- rowSums(Q^2)
  wgt <- h / pmax(1 - h, 1e-8)
  tr <- as.vector(crossprod(wgt, ee^2))
  list(proj = sqrt(ss / nn), deb2 = (ss - tr) / nn)
}

BASES <- make_bases(DZC)
QLIST <- lapply(BASES, orthonormalise)
BASIS_RANK <- vapply(QLIST, ncol, integer(1))

# ---- permutation references, drawn ONCE and shared across arms --------------
#
# Common random numbers: the same index matrices calibrate every arm, every
# partition and every basis, so a difference between two reported numbers is a
# difference in the statistic and not in its reference draw.  Drawn before any
# mclapply() call, so nothing here is a function of the core count.

## A dedicated far-away L'Ecuyer substream for the propensity-error block,
## which runs AFTER the mclapply() arms.  mcparallel() advances the parent's
## stream once per forked job under L'Ecuyer-CMRG, so a draw taken from the
## ambient stream there would be a function of the core count.  Substreams are
## 2^127 apart; 200 is far past the N_PART = 10 the arms consume.
PROP_STREAM <- make_streams(200L)[[200L]]

PERM <- matrix(0L, n, B_PERM)                                        # INV-17
for (b in seq_len(B_PERM)) PERM[, b] <- sample.int(n)

## Cluster-block reference.  Within-state dependence survives an observation-
## level permutation as extra noise in the reference, but the OBSERVED
## statistic keeps it too; permuting whole state blocks preserves the block
## structure on both sides.  Rows are held in cluster order for this reference.
ORD <- order(cl)
BLK <- split(seq_len(n), cl[ORD])
CPERM <- matrix(0L, n, B_PERM)                                       # INV-17
for (b in seq_len(B_PERM)) {
  CPERM[, b] <- unlist(BLK[sample.int(length(BLK))], use.names = FALSE)
}

# ---- replay of one shipped cross-fitting partition --------------------------

#' Reproduce one partition of a shipped arm and return the moment internals.
#'
#' Mirrors fit_one_partition() exactly -- plug-in start, one Newton step on the
#' orthogonal moment -- and then reads eval_moment()'s own containers instead of
#' discarding them.  `lam` is the shipped L-hat^{(-k)}: cross-fitted, evaluated
#' at the held-out residual, and swept by its unconditional column means.
#'
#' @param w integer vector. The instrument at its realised cardinality.
#' @param eps numeric. eq:trunset truncation level.
#' @param mbar integer. Landweber cap; patience is tied to it (C5).
#' @param stream the L'Ecuyer stream of this partition.
#' @return named list: theta, lam, lam_raw, wtil, piw, u, J, disc, L1.
replay_partition <- function(w, eps, mbar, stream) {
  assign(".Random.seed", stream, envir = globalenv())
  cf <- crossfit_once(y, xc$x1, xc$x2, Z, w, K = N_FOLDS, cste = LF_CSTE,
                      xeval = xev, init_fn = init_control, lf_imax = mbar,
                      lf_patience = mbar, rho = RHO, eps_rho = eps,
                      n_t = N_T, bier_seed = BIER_SEED, t_scale = T_SCALE,
                      adj_wtil = ADJ_WTIL, tau_dp = TAU_DP,
                      conditional = TRUE, verbose = FALSE)
  th0 <- stats::lm.fit(Z, y - cf$dphi)$coefficients
  th0[!is.finite(th0)] <- 0
  m0 <- cf$eval_moment(th0)
  j0i <- tryCatch(solve(m0$J), error = \(e) MASS::ginv(m0$J))
  th1 <- as.vector(th0 - j0i %*% colMeans(m0$psi))
  m1 <- cf$eval_moment(th1)

  ## The PRE-sweep primitive, rebuilt from the same fold objects the moment
  ## used.  environment(cf$eval_moment) IS crossfit_once()'s frame, so this is
  ## the estimator's own bal_by_fold, read and not recomputed.
  env <- environment(cf$eval_moment)
  lam_raw <- array(0, dim(m1$lam))                                   # INV-17
  for (k in seq_len(N_FOLDS)) {
    hold <- which(env$folds == k)
    lam_raw[hold, , ] <- eval_lambda(env$bal_by_fold[[k]], m1$u[hold])
  }
  ## VERIFICATION OF THE READING, not an assertion of it: the shipped lam is
  ## exactly lam_raw swept by its unconditional column means, per (j, l).
  chk <- lam_raw
  for (l in seq_len(dim(chk)[3])) {
    sl <- matrix(chk[, , l], dim(chk)[1], dim(chk)[2])
    chk[, , l] <- sweep(sl, 2L, colMeans(sl), "-")
  }
  stopifnot(max(abs(chk - m1$lam)) < 1e-10)

  list(theta = th1, lam = m1$lam, lam_raw = lam_raw, wtil = m1$wtil,
       piw = m1$pi_w, u = m1$u, J = m1$J, disc = cf$disc,
       L1 = dim(m1$lam)[3])
}

## The four objects measured, in the order they are stacked into Y.
##   entrywise            L-hat_{jl}, the p(L-1) conditions (T-2) actually asks
##   entrywise_raw        the same before the shipped unconditional sweep
##   contracted_piw       sum_l varpi_w(l) L-hat_{jl}, the contraction the
##                        moment weights by -- the WEAKER condition
##   contracted_piw_wtil  sum_l varpi_w(l) Wtilde_l L-hat_{jl}, the term that
##                        enters psi.  Under A1 this is conditionally mean zero
##                        WHATEVER the anchor is, because Wtilde is
##                        conditionally centred and L-hat(dU) is conditionally
##                        independent of W.  It is measured precisely so that
##                        "the moment looks orthogonal" cannot be mistaken for
##                        "N1 holds".
KIND_LEVELS <- c("entrywise", "entrywise_raw", "contracted_piw",
                 "contracted_piw_wtil")

#' Assemble the statistic columns of one partition and measure them.
#'
#' @param rp the replay_partition() return.
#' @return named list: cells (one row per statistic column x basis) and joint
#'   (one row per kind x basis).
measure_partition <- function(rp) {
  p <- dim(rp$lam)[2]
  l1 <- rp$L1
  flat <- function(A) matrix(A, dim(A)[1], dim(A)[2] * dim(A)[3])
  lam_f <- flat(rp$lam)
  raw_f <- flat(rp$lam_raw)
  ## The varpi_w contraction WITHOUT Wtilde: sum_l varpi_w(l) L_{.,j,l}.
  lam_pi <- matrix(0, n, p)                                          # INV-17
  for (l in seq_len(l1)) {
    lam_pi <- lam_pi + rp$piw[l] * matrix(rp$lam[, , l], n, p)
  }
  ## The eq:psidef contraction, i.e. the term that actually enters psi.
  lam_w <- contract_cells(rp$lam, rp$wtil, rp$piw)

  Y <- cbind(lam_f, raw_f, lam_pi, lam_w)
  kind <- c(rep("entrywise", ncol(lam_f)),
            rep("entrywise_raw", ncol(raw_f)),
            rep("contracted_piw", p), rep("contracted_piw_wtil", p))
  jj <- c(rep(seq_len(p), times = l1), rep(seq_len(p), times = l1),
          seq_len(p), seq_len(p))
  ll <- c(rep(seq_len(l1), each = p), rep(seq_len(l1), each = p),
          rep(NA_integer_, p), rep(NA_integer_, p))
  scale_l2 <- sqrt(colMeans(Y^2))
  ## The constant the shipped sweep removes, per (j, l).  Carried so that the
  ## size of what the estimator DOES impose is visible next to the size of what
  ## it does not.
  col_mean <- colMeans(Y)

  Yc <- Y[ORD, , drop = FALSE]
  out <- vector("list", length(QLIST))                               # INV-17
  joint <- list()
  for (ib in seq_along(QLIST)) {
    Q  <- QLIST[[ib]]
    Qc <- Q[ORD, , drop = FALSE]
    ob <- proj_stats(Q, Y)
    ref_i <- matrix(0, B_PERM, ncol(Y))                              # INV-17
    ref_c <- matrix(0, B_PERM, ncol(Y))                              # INV-17
    deb_i <- matrix(0, B_PERM, ncol(Y))                              # INV-17
    deb_c <- matrix(0, B_PERM, ncol(Y))                              # INV-17
    for (b in seq_len(B_PERM)) {
      si <- proj_stats(Q,  Y[PERM[, b], , drop = FALSE])
      sc <- proj_stats(Qc, Yc[CPERM[, b], , drop = FALSE])
      ref_i[b, ] <- si$proj
      ref_c[b, ] <- sc$proj
      deb_i[b, ] <- si$deb2
      deb_c[b, ] <- sc$deb2
    }
    ## Resolution of the debiased statistic, taken from the CLUSTER reference
    ## because it is the wider of the two and this is a floor, not a p-value.
    sd_deb <- apply(deb_c, 2L, stats::sd)
    ub2 <- ob$deb2 + stats::qnorm(0.95) * sd_deb
    out[[ib]] <- data.frame(
      basis = names(QLIST)[ib], rank = ncol(Q), kind = kind, j = jj, l = ll,
      scale_l2 = scale_l2, col_mean = col_mean,
      proj = ob$proj,
      ratio = ifelse(scale_l2 > 0, ob$proj / scale_l2, NA_real_),
      floor_iid  = apply(ref_i, 2L, stats::quantile, probs = 0.95),
      floor_clus = apply(ref_c, 2L, stats::quantile, probs = 0.95),
      p_iid  = (1 + colSums(ref_i >= rep(ob$proj, each = B_PERM))) /
        (B_PERM + 1),
      p_clus = (1 + colSums(ref_c >= rep(ob$proj, each = B_PERM))) /
        (B_PERM + 1),
      deb2 = ob$deb2, sd_deb = sd_deb,
      defect = sqrt(pmax(ob$deb2, 0)),
      defect_ub = sqrt(pmax(ub2, 0)),
      ratio_defect = ifelse(scale_l2 > 0, sqrt(pmax(ob$deb2, 0)) / scale_l2,
                            NA_real_),
      ratio_defect_ub = ifelse(scale_l2 > 0, sqrt(pmax(ub2, 0)) / scale_l2,
                               NA_real_),
      p_deb = (1 + colSums(deb_c >= rep(ob$deb2, each = B_PERM))) /
        (B_PERM + 1),
      stringsAsFactors = FALSE)

    ## ---------------------------------------------------------------------
    ## JOINT TESTS.  N1 is p(L-1) conditions at once, so the per-cell p-values
    ## above are 18 tests at L = 4 and a minimum over them is not a p-value.
    ## Two joint statistics, each with the SAME permutation draws (the draw
    ## permutes the observation index COMMONLY across cells, so the reference
    ## carries the cross-cell dependence the observed statistic has):
    ##   SUM  sum_{j,l} deb2_{jl}      -- power against a diffuse defect
    ##   MAX  max_{j,l} deb2_{jl}      -- power against one bad cell, and it is
    ##                                    multiplicity-correct by construction
    jt <- vector("list", length(KIND_LEVELS))                        # INV-17
    for (ik in seq_along(KIND_LEVELS)) {
      g <- which(kind == KIND_LEVELS[ik])
      so <- sum(ob$deb2[g]); mo <- max(ob$deb2[g])
      sr <- rowSums(deb_c[, g, drop = FALSE])
      mr <- apply(deb_c[, g, drop = FALSE], 1L, max)
      tot <- sum(scale_l2[g]^2)
      jt[[ik]] <- data.frame(
        basis = names(QLIST)[ib], rank = ncol(Q), kind = KIND_LEVELS[ik],
        n_cells = length(g),
        sum_deb2 = so, sum_rel = sqrt(max(so, 0) / tot),
        p_sum = (1 + sum(sr >= so)) / (B_PERM + 1),
        max_deb2 = mo, p_max = (1 + sum(mr >= mo)) / (B_PERM + 1),
        stringsAsFactors = FALSE)
    }
    joint[[length(joint) + 1L]] <- do.call(rbind, jt)
  }
  list(cells = do.call(rbind, out), joint = do.call(rbind, joint))
}

# ---- the arms ---------------------------------------------------------------
#
# A and B are the PAIRED contrast the headline theta-hat table reports: one eps,
# one cap, two cardinalities.  C is the shipped binary ladder rung, at ITS own
# eps and cap, so that a clean L = 2 reading cannot be an artefact of the
# configuration the paired contrast runs the binary arm at.

#' The arm's block label, built from its REALISED configuration.
#'
#' NO SECTION NUMBER APPEARS HERE, AND THAT IS THE POINT.  The labels this
#' replaced read "(S6.3 reported)" and "(S6.2 ladder)".  They named a
#' six-subsection Section 6 that the 2026-08-11 streamline retired; the section
#' has since been renumbered twice, the headline four-cell arm has moved
#' subsection, and the binary ladder has moved to the online supplement
#' altogether -- so both labels shipped pointing at subsections that no longer
#' hold what they claimed.  A label naming the CONFIGURATION is true of the arm
#' whatever the numbering does next, and it is strictly more informative: the
#' cardinality, the truncation level, the iteration cap and the partition stream
#' ARE the factors that separate the two binary arms from each other, which the
#' manuscript otherwise has to assert in prose beside the table.
#'
#' @param a list. One ARM_SPEC element.
#' @param head list. ARM_SPEC[[1]], the arm the stream is compared against.
#' @return character(1). A LaTeX block label.
arm_label <- function(a, head) {
  L <- length(unique(as.integer(a$w)))
  stream <- if (identical(a$key, head$key)) {
    "headline partition stream"
  } else if (identical(a$seed, head$seed) && identical(a$skip, head$skip)) {
    "same partition stream"
  } else {
    "its own partition stream"
  }
  sprintf("$\\mathsf{L}=%d$, %s: $\\varepsilon_\\varrho=%s$, $\\bar m=%d$, %s",
          L, if (L == 2L) "binary coarsening" else "four trigger cells",
          fmt(a$eps, 3), as.integer(a$mbar), stream)
}

ARM_SPEC <- list(
  list(key = "L4",       w = w4, eps = EPS_LOCALISE, mbar = 60L,
       seed = SEED_LOCALISE, skip = 0L,
       ref = list(file = "app_tsp_localise.rds", path = c("fit_L4"))),
  list(key = "L2_paired", w = w2, eps = EPS_LOCALISE, mbar = 60L,
       seed = SEED_LOCALISE, skip = 0L,
       ref = list(file = "app_tsp_localise.rds", path = c("fit_L2"))),
  list(key = "L2_ladder", w = w2, eps = EPS_RHO, mbar = lf_mbar(w2),
       seed = SEED_LADDER, skip = 1L,
       ref = list(file = "app_tsp_ladder.rds", path = c("fits", "5")))
)
ARMS <- lapply(ARM_SPEC, \(a) c(a, list(label = arm_label(a, ARM_SPEC[[1L]]))))

#' The partition streams of an arm, reproduced from its script's anchor.
#'
#' INV-14 EXCEPTION, and the one app_tsp_common.R already registers with
#' with_fixed_seed(): a validation call that must reproduce a seed chosen by
#' another script.  The caller's stream is saved and restored.
#'
#' @param seed integer. The stage seed.
#' @param skip integer. Number of make_streams() hops the stage takes before the
#'   arm's own anchor (the ladder chains one anchor per rung; d_Z = 5 is the
#'   second, so skip = 1).
#' @return list of N_PART L'Ecuyer streams.
arm_streams <- function(seed, skip) {
  with_fixed_seed(seed, {
    anchor <- get(".Random.seed", envir = globalenv())
    if (skip > 0L) {
      anchor <- make_streams(skip + 1L)[[skip + 1L]]
      assign(".Random.seed", anchor, envir = globalenv())
    }
    make_streams(N_PART)
  })
}

#' The shipped theta of a partition, for the bit-for-bit assertion.
#'
#' @param ref named list with `file` and `path`.
#' @return list of N_PART numeric vectors.
shipped_thetas <- function(ref) {
  z <- readRDS(file.path(IN, ref$file))
  for (nm in ref$path) z <- z[[nm]]
  lapply(z$fits, \(f) f$theta)
}

res <- vector("list", length(ARMS))                                  # INV-17
names(res) <- vapply(ARMS, \(a) a$key, character(1))
for (ia in seq_along(ARMS)) {
  arm <- ARMS[[ia]]
  streams <- arm_streams(arm$seed, arm$skip)
  ship <- shipped_thetas(arm$ref)
  t0 <- Sys.time()
  one <- function(b) {
    rp <- replay_partition(arm$w, arm$eps, arm$mbar, streams[[b]])
    ## THE REPLAY IS ASSERTED, NOT ASSUMED.  If this fails the measurement is
    ## on some other estimator and must not be reported as Section 6's.
    stopifnot(max(abs(rp$theta - ship[[b]])) == 0)
    mp <- measure_partition(rp)
    list(tab = cbind(partition = b, mp$cells),
         jnt = cbind(partition = b, mp$joint),
         theta = rp$theta, disc = rp$disc, piw = rp$piw, L1 = rp$L1,
         J = rp$J)
  }
  got <- if (N_CORES_N1 > 1L) {
    parallel::mclapply(seq_len(N_PART), one, mc.cores = N_CORES_N1,
                       mc.preschedule = FALSE)
  } else {
    lapply(seq_len(N_PART), one)
  }
  bad <- vapply(got, \(z) inherits(z, "try-error") || is.null(z$tab),
                logical(1))
  if (any(bad)) {
    stop(sprintf("arm %s: %d of %d partitions failed", arm$key, sum(bad),
                 N_PART))
  }
  res[[ia]] <- list(
    key = arm$key, label = arm$label, eps = arm$eps, mbar = arm$mbar,
    L = length(unique(as.integer(arm$w))), L1 = got[[1L]]$L1,
    piw = got[[1L]]$piw,
    tab = do.call(rbind, lapply(got, \(z) z$tab)),
    jnt = do.call(rbind, lapply(got, \(z) z$jnt)),
    theta = do.call(rbind, lapply(got, \(z) z$theta)),
    disc = do.call(rbind, lapply(got, \(z) z$disc)),
    J = lapply(got, \(z) z$J))
  message(sprintf("%-11s L = %d  eps = %.3f  m-bar = %2d  %5.0fs  replay exact",
                  arm$key, res[[ia]]$L, arm$eps, arm$mbar,
                  as.numeric(difftime(Sys.time(), t0, units = "secs"))))
}

# ---- headline summaries -----------------------------------------------------

#' Per-partition maximum over (j, l) of each statistic, then its across-
#' partition median and range.
#'
#' The maximum is taken SEPARATELY for the raw and the debiased statistic,
#' because they need not be attained at the same (j, l) and reporting a
#' debiased value at the raw argmax would understate the defect.
#'
#' @param tab data.frame from measure_partition(), one arm.
#' @param which_kind character. The `kind` level to summarise.
#' @param basis character. Basis name.
#' @return named list of across-partition summaries.
summarise_max <- function(tab, which_kind, basis) {
  s <- tab[tab$kind == which_kind & tab$basis == basis, , drop = FALSE]
  parts <- sort(unique(s$partition))
  np <- length(parts)
  raw <- numeric(np); rt <- numeric(np); flc <- numeric(np)          # INV-17
  dfc <- numeric(np); dfr <- numeric(np); dub <- numeric(np)
  dur <- numeric(np); pmn <- numeric(np); cmx <- numeric(np)
  for (k in seq_len(np)) {
    ss <- s[s$partition == parts[k], , drop = FALSE]
    wr <- which.max(ss$proj)
    raw[k] <- ss$proj[wr]; rt[k] <- ss$ratio[wr]; flc[k] <- ss$floor_clus[wr]
    wd <- which.max(ss$defect)
    dfc[k] <- ss$defect[wd]; dfr[k] <- ss$ratio_defect[wd]
    wu <- which.max(ss$defect_ub)
    dub[k] <- ss$defect_ub[wu]; dur[k] <- ss$ratio_defect_ub[wu]
    pmn[k] <- min(ss$p_deb)
    cmx[k] <- max(abs(ss$col_mean))
  }
  list(proj_median = stats::median(raw), proj_min = min(raw),
       proj_max = max(raw), ratio_median = stats::median(rt),
       floor_clus_median = stats::median(flc),
       excess_median = stats::median(raw / flc),
       defect_median = stats::median(dfc), defect_max = max(dfc),
       ratio_defect_median = stats::median(dfr),
       defect_ub_median = stats::median(dub), defect_ub_max = max(dub),
       ratio_defect_ub_median = stats::median(dur),
       p_deb_min_median = stats::median(pmn),
       sweep_const_median = stats::median(cmx))
}

KINDS <- KIND_LEVELS
summ <- list()
for (ia in seq_along(res)) {
  for (bn in names(QLIST)) {
    for (kd in KINDS) {
      s <- summarise_max(res[[ia]]$tab, kd, bn)
      summ[[length(summ) + 1L]] <- data.frame(
        arm = res[[ia]]$key, L = res[[ia]]$L, basis = bn,
        rank = BASIS_RANK[bn], kind = kd,
        proj_median = s$proj_median, proj_min = s$proj_min,
        proj_max = s$proj_max, ratio_median = s$ratio_median,
        floor_clus = s$floor_clus_median, excess = s$excess_median,
        defect = s$defect_median, defect_max = s$defect_max,
        ratio_defect = s$ratio_defect_median,
        defect_ub = s$defect_ub_median, defect_ub_max = s$defect_ub_max,
        ratio_defect_ub = s$ratio_defect_ub_median,
        p_deb_min = s$p_deb_min_median,
        sweep_const = s$sweep_const_median, stringsAsFactors = FALSE)
    }
  }
}
SUMM <- do.call(rbind, summ)

## Joint tests, aggregated across partitions.  The p-values are combined by
## their MEDIAN across the 10 partitions rather than by any pooling rule: the
## partitions share the data and differ only in the fold draw, so they are not
## independent replications and Fisher-style pooling would overstate the
## evidence.  The median is the across-partition central p-value and is read as
## such, not as a size-alpha test.
jsumm <- list()
for (ia in seq_along(res)) {
  jt <- res[[ia]]$jnt
  for (bn in names(QLIST)) {
    for (kd in KINDS) {
      s <- jt[jt$basis == bn & jt$kind == kd, , drop = FALSE]
      jsumm[[length(jsumm) + 1L]] <- data.frame(
        arm = res[[ia]]$key, L = res[[ia]]$L, basis = bn, kind = kd,
        n_cells = s$n_cells[1L],
        sum_rel = stats::median(s$sum_rel),
        p_sum_median = stats::median(s$p_sum),
        p_sum_min = min(s$p_sum), p_sum_max = max(s$p_sum),
        p_max_median = stats::median(s$p_max),
        p_max_min = min(s$p_max), p_max_max = max(s$p_max),
        stringsAsFactors = FALSE)
    }
  }
}
JOINT <- do.call(rbind, jsumm)

## Worst-case first-order propensity-direction sensitivity of theta-hat.
##
## The bias in coordinate j from a propensity error of L^2 size epsilon in the
## worst direction is bounded by  sum_l varpi_w(l) || E[L_jl | dZ] || epsilon,
## and theta-hat's bias is J^{-1} times that vector.  Reported at epsilon = 0.01
## as a RATE OF EXCHANGE -- "per 0.01 of L^2 error in varrho-hat" -- because
## ||varrho-hat - varrho|| is not identified here.  It is an upper bound in the
## worst direction, not a point prediction.
## Built from the DEBIASED upper bound `defect_ub`, not from the raw projection
## norm, which at rank 21 is mostly overfitting and would convert an artefact
## into a bias claim.
EPS_PROBE <- 0.01
SENS_BASES <- c("linear", "quadratic")

#' theta-hat's worst-direction shift per EPS_PROBE of propensity L^2 error.
#'
#' @param r one element of `res`.
#' @param basis character. Which conditioning basis the defect is read at.
#' @return numeric vector of length p, the across-partition median.
theta_shift <- function(r, basis) {
  s <- r$tab[r$tab$kind == "entrywise" & r$tab$basis == basis, , drop = FALSE]
  p <- ncol(r$theta)
  parts <- sort(unique(s$partition))
  shift <- matrix(0, length(parts), p)                               # INV-17
  for (k in seq_along(parts)) {
    ss <- s[s$partition == parts[k], , drop = FALSE]
    v <- numeric(p)
    for (j in seq_len(p)) {
      sj <- ss[ss$j == j, , drop = FALSE]
      v[j] <- sum(r$piw * sj$defect_ub[order(sj$l)])
    }
    jinv <- tryCatch(solve(r$J[[k]]), error = \(e) MASS::ginv(r$J[[k]]))
    shift[k, ] <- abs(as.vector(jinv %*% (EPS_PROBE * v)))
  }
  apply(shift, 2L, stats::median)
}

sens <- vector("list", length(SENS_BASES))                           # INV-17
names(sens) <- SENS_BASES
for (bn in SENS_BASES) {
  sb <- vector("list", length(res))                                  # INV-17
  names(sb) <- names(res)
  for (ia in seq_along(res)) sb[[ia]] <- theta_shift(res[[ia]], bn)
  sens[[bn]] <- sb
}

## The reported standard errors the sensitivity is compared against.
SE_REF <- list(
  L4 = readRDS(file.path(IN, "app_tsp_localise.rds"))$se_cl_L4,
  L2_paired = readRDS(file.path(IN, "app_tsp_localise.rds"))$se_cl_L2,
  L2_ladder = readRDS(file.path(IN, "app_tsp_ladder.rds"))$fits[["5"]]$se_cl)

## ---------------------------------------------------------------------------
## HOW BIG IS 0.01 OF PROPENSITY ERROR?  A LOWER BOUND, AND IT IS ONLY THAT.
##
## The rate of exchange above is per unit of || varrho-hat - varrho ||_{L^2},
## which is not identified.  What IS measurable is the SAMPLING component of it
## under the estimator's own model: fit_propensity_multi() runs a multinomial
## logit linear in dZ (glm at L = 2), so beta-hat has an estimable covariance
## and varrho-hat's sampling error follows by simulation from it.  The fits run
## on fold complements, so the covariance is scaled by n / n_{-k}.
##
## THIS IS A LOWER BOUND ON THE ERROR THAT MATTERS.  A4(iii) treats varrho
## NONPARAMETRICALLY at rate n^{-alpha}; the parametric logit's error has a
## MISSPECIFICATION component that does not shrink at all and is not in this
## number.  Read it as "the propensity error is at least this big", never as
## "the propensity error is this big".
S_PROP <- 200L
assign(".Random.seed", PROP_STREAM, envir = globalenv())
prop_err <- function(w) {
  cells <- sort(unique(as.integer(w)))
  l1 <- length(cells) - 1L
  X <- cbind(1, standardise_cols(DZC))
  n_fold <- round(n * (N_FOLDS - 1) / N_FOLDS)
  if (l1 == 1L) {
    g <- suppressWarnings(stats::glm(as.numeric(w == cells[2L]) ~ X - 1,
                                     family = stats::binomial()))
    bh <- matrix(stats::coef(g), 1L, ncol(X))
    vv <- stats::vcov(g) * (n / n_fold)
  } else {
    g <- nnet::multinom(factor(as.integer(w), levels = cells) ~ X - 1,
                        trace = FALSE)
    bh <- matrix(stats::coef(g), l1, ncol(X))
    vv <- stats::vcov(g) * (n / n_fold)
  }
  vv <- (vv + t(vv)) / 2
  ev <- eigen(vv, symmetric = TRUE)
  rt <- ev$vectors %*% diag(sqrt(pmax(ev$values, 0)), nrow(vv)) %*%
    t(ev$vectors)
  softmax <- function(B) {
    e <- exp(X %*% t(B))
    e / (1 + rowSums(e))
  }
  base <- softmax(bh)
  dev <- numeric(S_PROP)                                             # INV-17
  for (s in seq_len(S_PROP)) {
    bs <- bh + matrix(as.vector(rt %*% stats::rnorm(nrow(vv))), l1, ncol(X),
                      byrow = (l1 > 1L))
    dd <- softmax(bs) - base
    dev[s] <- sqrt(sum(colMeans(dd^2)))
  }
  list(median = stats::median(dev), q90 = stats::quantile(dev, 0.90),
       n_fold = n_fold, l1 = l1)
}
PROP_ERR <- list(L4 = prop_err(w4), L2 = prop_err(w2))

# ---- report -----------------------------------------------------------------

message("")
message("=== N1 AT L-STAR: max_{j,l} || E-hat[ L-hat_{jl} | dZ ] ||_{L2} ===")
message(sprintf("  n = %d, d_Z = %d, partitions = %d, perm draws = %d",
                n, D_Z, N_PART, B_PERM))
message(sprintf("  basis ranks: %s",
                paste(sprintf("%s=%d", names(BASIS_RANK), BASIS_RANK),
                      collapse = ", ")))
for (bn in names(QLIST)) {
  message(sprintf("\n  -- basis: %s (rank %d) --", bn, BASIS_RANK[bn]))
  message(paste("     arm        statistic             raw     floor  x     ",
                "defect  95%ub   ub/||L||  p"))
  sb <- SUMM[SUMM$basis == bn, , drop = FALSE]
  for (ia in seq_along(res)) {
    for (kd in KINDS) {
      rr <- sb[sb$arm == res[[ia]]$key & sb$kind == kd, , drop = FALSE]
      message(sprintf(
        "  %-10s %-20s %7.4f %7.4f %4.1f  %7.4f %7.4f   %6.3f  %5.3f",
        res[[ia]]$key, kd, rr$proj_median, rr$floor_clus, rr$excess,
        rr$defect, rr$defect_ub, rr$ratio_defect_ub, rr$p_deb_min))
    }
  }
}
message("")
message(paste("=== JOINT TESTS OF N1 (median p over partitions;",
              "range in brackets) ==="))
for (bn in names(QLIST)) {
  message(sprintf("\n  -- basis: %s (rank %d) --", bn, BASIS_RANK[bn]))
  for (ia in seq_along(res)) {
    for (kd in c("entrywise", "contracted_piw", "contracted_piw_wtil")) {
      rr <- JOINT[JOINT$arm == res[[ia]]$key & JOINT$basis == bn &
                    JOINT$kind == kd, , drop = FALSE]
      message(sprintf(
        paste("  %-10s %-20s cells %2d  rel %6.3f",
              " p_sum %5.3f [%5.3f,%5.3f]  p_max %5.3f [%5.3f,%5.3f]"),
        res[[ia]]$key, kd, rr$n_cells, rr$sum_rel,
        rr$p_sum_median, rr$p_sum_min, rr$p_sum_max,
        rr$p_max_median, rr$p_max_min, rr$p_max_max))
    }
  }
}

message("")
message("  Sweep constant removed by the shipped centring, max_{j,l} |mean|:")
for (ia in seq_along(res)) {
  rr <- SUMM[SUMM$arm == res[[ia]]$key & SUMM$basis == "linear" &
               SUMM$kind == "entrywise_raw", , drop = FALSE]
  message(sprintf("  %-10s %8.4f", res[[ia]]$key, rr$sweep_const))
}
message("")
message(sprintf("  |theta shift| per %.2f of L2 propensity error, worst",
                EPS_PROBE))
message("  direction, from the 95% upper bound; reported SE beneath:")
for (bn in SENS_BASES) {
  message(sprintf("\n  -- defect read at basis: %s --", bn))
  for (ia in seq_along(res)) {
    se <- SE_REF[[res[[ia]]$key]]
    sh <- sens[[bn]][[res[[ia]]$key]]
    message(sprintf("  %-10s shift %s", res[[ia]]$key,
                    paste(fmt(sh, 4), collapse = " ")))
    message(sprintf("  %-10s se_cl %s", "", paste(fmt(se, 4), collapse = " ")))
    message(sprintf("  %-10s ratio %s", "",
                    paste(fmt(sh / se, 3), collapse = " ")))
  }
}
message("")
message("  Sampling-only L2 error of varrho-hat at the fold sample size")
message("  (LOWER BOUND: parametric, no misspecification component):")
for (nm in names(PROP_ERR)) {
  pe <- PROP_ERR[[nm]]
  message(sprintf("  %-10s n_fold = %d  median %.4f   q90 %.4f", nm,
                  pe$n_fold, pe$median, pe$q90))
}
message("")
message("  Implied worst-case |theta bias| / se_cl at that propensity error,")
message("  defect read at the quadratic basis:")
for (ia in seq_along(res)) {
  key <- res[[ia]]$key
  pe <- PROP_ERR[[if (res[[ia]]$L == 4L) "L4" else "L2"]]
  rr <- (sens[["quadratic"]][[key]] / EPS_PROBE) * pe$median /
    SE_REF[[key]]
  message(sprintf("  %-10s %s", key, paste(fmt(rr, 3), collapse = " ")))
}

# ---- artifacts --------------------------------------------------------------

out <- list(
  seed = SEED_N1, n = n, d_z = D_Z, n_part = N_PART, b_perm = B_PERM,
  eps_probe = EPS_PROBE, sens_bases = SENS_BASES, basis_rank = BASIS_RANK,
  coef_names = colnames(Z), arms = res, summary = SUMM, joint = JOINT,
  theta_sensitivity = sens, se_reference = SE_REF, prop_err = PROP_ERR,
  note = paste("Measured, not repaired.  The shipped lambda is anchored at",
               "u = -infinity and then swept by its UNCONDITIONAL column mean",
               "per (j, l), which is the BEST CONSTANT anchor; the reported",
               "projection norm is therefore the minimal N1 defect over the",
               "whole class of constant anchors.  `proj` is overfitting-",
               "dominated at rank 21 and is reported only against its own",
               "permutation floor; `defect` and `defect_ub` are the HC2-",
               "debiased point estimate and its 95 per cent upper bound."))
saveRDS(out, file.path(OUT, "app_tsp_n1_anchor.rds"))

## ---------------------------------------------------------------------------
## Bare tabular (INV-13, INV-3): one block per arm, entrywise against the two
## contractions, at the basis that spans the estimator's own propensity index.
##
## TWO THINGS THE SHIPPED FRAGMENT LEFT A READER TO GUESS, BOTH FIXED HERE.
##
## (1) WHICH BASIS.  Every number printed is a conditional mean fitted on the
##     QUADRATIC basis, rank 21, and the fragment never said so -- while the
##     script computes all three and the linear one is smaller by a factor of
##     four at the headline arm (entrywise defect 0.067 against 0.306).  A reader
##     who assumed the linear basis would understate the defect fourfold, so the
##     basis and its rank are now a spanning header of the table itself and are
##     read off BASIS_RANK rather than typed.
##
## (2) WHICH ANCHOR.  The column head "Raw" meant "undebiased", but this script
##     also carries a statistic called `entrywise_raw` that means something else
##     entirely -- L-hat BEFORE the estimator's unconditional sweep -- and the
##     two readings are three decimal places apart (0.5415 against 3.0130 at the
##     headline arm).  The column is renamed "Projection", which cannot be read
##     as an anchor, and the pre-sweep row is now PRINTED rather than computed
##     and discarded.  That row is the size of what the estimator DOES impose,
##     sitting beside the size of what it does not, which is what measure_
##     partition()'s `col_mean` was carried for and never reached a table.
##
## THE COLUMN IS "Plug-in" AND NOT "Raw", and not "Projection" either.  "Raw"
## was the collision above.  "Projection" removes the collision but costs width
## the table has not got: measured at \footnotesize in the manuscript's own
## 12pt / 1in geometry, the fragment sets 462.7pt against a 469.8pt text block,
## which is inside by 7pt and therefore inside by nothing.  "Plug-in" is both
## shorter and better: the column IS the plug-in estimate of the defect, which
## is what makes it the natural opposite of "Debiased" two columns along.
##
## WIDTH, MEASURED RATHER THAN HOPED.  The emitted fragment sets 429.6pt in that
## geometry, an 8.5 per cent margin.  The old three-row fragment set 416.4pt, so
## the extra row and the two header lines cost 13pt, not the 116pt that the
## first draft of this block cost before the stubs were shortened.
## ---------------------------------------------------------------------------
PRIMARY <- "quadratic"
stopifnot(PRIMARY %in% names(QLIST),
          BASIS_RANK[[PRIMARY]] == ncol(QLIST[[PRIMARY]]))

## Row order within a block, and the stub each `kind` prints under.  The two
## entrywise rows are the SAME statistic at two anchors, so the second is an
## INDENTED continuation of the first rather than a fourth free-standing
## statistic: the extra \quad is what says "this is that row, without the
## removal", and it is the whole disambiguation in four words.
ROW_STUBS <- c(
  entrywise           = "Entrywise $\\max_{j,l}$",
  entrywise_raw       = "\\quad before mean removal",
  contracted_piw      = "Contracted, $\\varpi_w$ only",
  contracted_piw_wtil = "Contracted, $\\varpi_w \\widetilde{W}$")
## The 28-character bound is a PROXY for a typeset width this script cannot
## measure, and it counts only the NON-MATH characters because those are the
## ones whose count tracks width.  A bound on raw source length does not: it
## fires on "Contracted, $\varpi_w \widetilde{W}$", 36 characters that set less
## than half the width of the 25-character "\quad before mean removal", which is
## the row this stub set was actually at risk from.  Set from the measurement
## recorded above -- 429.6pt against a 469.8pt text block, longest stub 25 -- so
## an edit that lengthens a stub past it must re-measure rather than discover the
## overflow in a rendered PDF.
stopifnot(setequal(names(ROW_STUBS), KIND_LEVELS),
          max(nchar(gsub("\\$[^$]*\\$", "", ROW_STUBS))) <= 28L)

body <- character(0)
row_for <- function(sb, jb, kd) {
  g <- function(col) sb[[col]][sb$kind == kd]
  h <- function(col) jb[[col]][jb$kind == kd]
  stopifnot(sum(sb$kind == kd) == 1L, sum(jb$kind == kd) == 1L)
  sprintf("\\quad %s & %s & %s & %s & %s & %s & %s \\\\", ROW_STUBS[[kd]],
          fmt(g("proj_median"), 4), fmt(g("floor_clus"), 4),
          fmt(g("defect"), 4), fmt(g("defect_ub"), 4),
          fmt(g("ratio_defect_ub"), 3), fmt_p(h("p_max_median")))
}
for (ia in seq_along(res)) {
  sb <- SUMM[SUMM$arm == res[[ia]]$key & SUMM$basis == PRIMARY, ,
             drop = FALSE]
  jb <- JOINT[JOINT$arm == res[[ia]]$key & JOINT$basis == PRIMARY, ,
              drop = FALSE]
  body <- c(body,
    sprintf("\\multicolumn{7}{l}{\\textit{%s}} \\\\", res[[ia]]$label),
    vapply(names(ROW_STUBS), \(kd) row_for(sb, jb, kd), character(1),
           USE.NAMES = FALSE),
    if (ia < length(res)) "\\\\[0.4em]" else NULL)
}

header <- c(
  sprintf(paste("& \\multicolumn{6}{c}{Conditional mean fitted on a %s basis",
                "in $\\Delta Z$, rank $%d$} \\\\"),
          PRIMARY, BASIS_RANK[[PRIMARY]]),
  "\\cmidrule(lr){2-7}",
  paste("Statistic & Plug-in & Null floor & Debiased &",
        "95\\% upper & Upper$/\\|\\widehat{L}\\|$ & $p$ \\\\"))

## WRITE-TIME GUARDS, and the first of them is the one this round exists for: a
## label naming a section number is exactly the defect being repaired, so the
## fragment refuses to carry one rather than trusting the author not to type it
## again.  The rest pin the shape, so a silently dropped arm or kind fails here
## instead of shipping a short table.
stopifnot(
  !any(grepl("S[0-9]+\\.[0-9]|Section", c(header, body))),
  length(body) == length(res) * (1L + length(ROW_STUBS)) + (length(res) - 1L),
  sum(grepl("multicolumn\\{7\\}", body)) == length(res),
  all(vapply(res, \(r) any(grepl(r$label, body, fixed = TRUE)), logical(1))),
  !any(grepl("--", body, fixed = TRUE)))          # fmt()'s non-finite marker
write_tabular(colspec = "lcccccc", header = header, body = body,
              path = file.path(TAB, "app_tsp_n1_anchor.tex"))

message(sprintf("\nwrote %s", file.path(OUT, "app_tsp_n1_anchor.rds")))
message(sprintf("wrote %s", file.path(TAB, "app_tsp_n1_anchor.tex")))
