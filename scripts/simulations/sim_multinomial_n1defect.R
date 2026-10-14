# ============================================================================
# sim_multinomial_n1defect.R
#
# THE N1 DEFECT OF THE SHIPPED DEBIASING WEIGHT, ON THE MULTINOMIAL DESIGNS,
# AT sans-L IN {2, 3, 4}.
#
#   Rscript scripts/simulations/sim_multinomial_n1defect.R      (~6 min, 8 cores)
#
# ---------------------------------------------------------------------------
# WHY THIS EXISTS: THE ONE HYPOTHESIS KNOWN TO BIND AT sans-L >= 3 WAS THE ONE
# HYPOTHESIS NO MULTINOMIAL SCRIPT MEASURED
#
# thm:rootn's (T-2) assumes N1 at L_star -- results_s4_asymptotics.tex:317-322,
# "which is p(sans-L - 1) scalar conditions and NOT a condition on a contraction
# of the sans-L - 1 columns".  N1 itself is assumptions_main.tex:2869:
#
#       E[ L(dU, dZ) | dZ ] = 0   a.s.,   as a p x (sans-L - 1) MATRIX.
#
# Section 5.3 establishes that this is exactly the clause that breaks at
# sans-L = 4 on the Block I design: entrywise defect 0.191 of ||L_star|| at four
# cells against 3.3e-6 at two (sim_thm_rootn_n1defect.tex, Panel A), and the
# sans-L = 4 divergence of that arm follows from it.
#
# NO MULTINOMIAL SCRIPT COMPUTED IT.  mdgp_validate() (sim_multinomial_dgp.R:252)
# checks A1 at the true and the fitted propensity, def:admissible (B), the cell
# shares and the first stage, and stops.  So the three designs that exist to
# verify thm:rootn at sans-L >= 3 ran without a measurement of the hypothesis
# that is known to fail at sans-L >= 3 on the only design where it was checked.
#
# AND IT IS NOT RECOVERABLE BY ANALOGY.  Block I's N1 came from PARITY: all of
# its solved representer's coefficient energy sits on odd q, so L_star is odd in
# u, and its dU is independent of (dZ, W) and symmetric about zero, so the
# conditional mean vanishes as an identity.  sim_multinomial_dgp.R's design
# decision M3 DELIBERATELY DESTROYS BOTH LIMBS of that argument:
#
#     dU = gamma z1 z2 + 0.6 (v2 - v1) + sigma(z1) e,  sigma(z1)=0.35+0.30 Phi(z1)
#
# so dU is NOT independent of dZ -- its conditional mean is gamma z1 z2 and its
# conditional scale moves with z1, which is what makes the conditional centring
# device do work on this design.  No parity argument survives that, and none was
# offered.  Consequently Section 5.4's central finding -- "at the two
# well-specified designs the cardinality does very little" -- was UNATTRIBUTABLE:
# equally consistent with N1 holding, and with N1 failing and the divergence not
# yet having emerged at a grid that stops at n = 1,600.
#
# ---------------------------------------------------------------------------
# WHAT MAKES THIS A POPULATION COMPUTATION AND NOT A SECOND MONTE CARLO
#
# Two structural facts about the shipped estimator and this design turn the N1
# functional into a CLOSED FORM.
#
# (1) THE SHIPPED WEIGHT IS A FUNCTION OF u ALONE.  solve_balance_weight()
#     represents ell in an RKHS OVER THE RESIDUAL (orthogonal_theta.R:196-199,
#     `Ku <- exp(-outer(u,u,"-")^2/(2 sigma_u^2))`), and eval_lambda() returns
#         Lambda_{jl}(u) = sigma_u sqrt(2 pi) sum_i alpha_{ijl} Phi((u-u_i)/sigma_u)
#     with NO z argument anywhere.  crossfit_once() then subtracts the SAMPLE
#     MEAN of each of the p(sans-L - 1) slices (orthogonal_theta.R:681-684), so
#     the anchor the estimator realises is a CONSTANT, whose population value is
#     E[Lambda_{jl}(dU)].  The theory's own L_star is z-dependent -- Block I's is
#     sum_{r,q} coef A_q(u) eta_r(z) -- so the shipped engine solves inside a
#     STRICT SUBCLASS of the admissible weights, and that is the whole content
#     of what follows.
#
# (2) dU | dZ IS EXACTLY GAUSSIAN ON THIS DESIGN.  v1, v2 and e in mdgp_draw()
#     are drawn independently of z, so
#         dU | dZ = z  ~  N( m(z), s(z)^2 ),
#         m(z) = gamma z1 z2,     s(z)^2 = 0.72 + (0.35 + 0.30 Phi(z1))^2,
#     the 0.72 being 2 x 0.6^2 from the (v2 - v1) term.  This is verified against
#     a draw in Panel D rather than asserted.
#
# Put together, the N1 defect of the shipped weight is EXACT, by the Gaussian
# identity E[Phi(a + bX)] = Phi(a / sqrt(1 + b^2)) at X ~ N(0,1):
#
#   b_{jl}(z) := E[L_{jl} | dZ = z]
#              = sigma_u sqrt(2 pi) sum_i alpha_{ijl}
#                  Phi( (m(z) - u_i) / sqrt(sigma_u^2 + s(z)^2) )  -  E[Lambda_{jl}]
#
# -- NO quadrature in u, no sampling, machine precision.  Only the z-integration
# is quadrature, and dZ's two non-degenerate coordinates are exactly N(0, I_2),
# so a tensor Gauss-Hermite rule integrates any bounded smooth function of z
# against its true law.  The ||L_star|| denominator needs a second moment, for
# which there is no comparably cheap closed form; it is taken on a fine u-grid
# against the exact marginal density of dU, and THAT GRID IS CERTIFIED AGAINST
# THE CLOSED FORM: the same grid recomputes E[Lambda | z], and Panel D prints the
# discrepancy between the two routes.
#
# THE ONE SAMPLED INGREDIENT IS THE WEIGHT ITSELF, and it has to be: this design
# has no closed-form ell_star -- Blocks I and II solve theirs from a balancing
# equation against population objects, and Block III's whole point is that it
# runs the SHIPPED engine, whose weight is a sample object by construction.  So
# the weight is solved by the shipped solve_balance_weight(), at the shipped
# ridge and the shipped sigma_u rule, on independent draws, AT THE SOLVE-FOLD
# SIZE THE ARM REALISES -- crossfit_once() hands the solve
# `setdiff(rest, op_idx)`, which is ceiling(0.4 n), so 160, 320 and 640 at
# n = 400, 800 and 1,600.  The variation of the ratio across solve draws is
# reported as its Monte Carlo standard error, and the ratio is reported ACROSS
# the three solve sizes so a reader can see that it does not shrink.
#
# ---------------------------------------------------------------------------
# DESIGN DECISIONS
#
# M-N1a. THE REPORTED SCALE IS SECTION 5.3'S, TO THE DIGIT.  Headline is the
#   ENTRYWISE max_{j,l}||b_{jl}||_{L2} over max_{j,l}||L_{jl}||_{L2}, with the
#   Frobenius aggregate beside it -- the two columns and the two conventions of
#   sim_thm_rootn_n1defect.tex Panel A, so 0.191 and 3.3e-6 are directly
#   comparable numbers and not analogous ones.
#
# M-N1b. THE WEIGHT IS SOLVED AT THE TRUE varrho AND THE TRUE RESIDUAL.  The
#   estimator passes varrho-hat as `wcen` and the LF residual as `u`.  Both carry
#   their own error, and a defect measured through them would confound the
#   WEIGHT CLASS -- which is what N1 is about -- with the nuisance errors, which
#   are what (T-3) and (T-4) are about and which Section 5.4 already prices
#   separately.  The population idealisation isolates the clause under test.
#   `misspec` is run too, at ITS OWN true varrho, so its row is a statement about
#   the same weight class on a third design and not about its propensity.
#
# M-N1c. THE CONTROL IS RUN AND IT IS THE MACHINERY'S CERTIFICATE.  Panel C
#   repeats the whole computation on an M3-OFF variant -- gamma = 0 and sigma
#   frozen at its mean -- under which dU is independent of dZ, the conditional
#   mean of any u-only weight is its unconditional mean, and the defect is ZERO
#   AS AN IDENTITY.  What the control returns is therefore the numerical floor of
#   this script, and every number in Panel A is read against it.  The variant is
#   BUILT HERE and not added to sim_multinomial_dgp.R, because that file's md5 is
#   in sim_multinomial_rootn.R's checkpoint key and editing it would discard
#   nine completed cells.
#
# M-N1d. THE DESIGN CEILING IS REPORTED BESIDE THE REALISED DEFECT.  R_max is
#   sup over CENTRED u-only weights of ||E[Lambda|dZ]|| / ||Lambda||, computed
#   over polynomials in u of degree <= K in a basis orthonormalised under dU's
#   own law.  It is a property of the DESIGN and of no weight, it bounds every
#   row of Panel A from above, and it says how much of the available defect the
#   shipped weight actually picks up.  It is NOT a lower bound: the operator is
#   compact, so its spectrum accumulates at zero and a u-only weight CAN have an
#   arbitrarily small defect -- which is why the realised number is the one that
#   settles the question and R_max is context.
#
# M-N1e. NO CLAIM IS MADE THAT THE THEORY'S OWN L_star FAILS N1 HERE.  It does
#   not: rem:anchor's re-anchoring at b_star(z) = -E[int_0^{dU} ell | dZ = z]
#   produces a weight satisfying N1 with the same ell, and A2'(iii) admits that
#   anchor.  What is measured is that THE SHIPPED ENGINE DOES NOT IMPLEMENT THAT
#   RE-ANCHORING -- it subtracts a constant -- so the weight it realises cannot
#   satisfy N1 on a design whose F(. | z) genuinely moves with z, except by
#   being zero.  This is a gap between the theory and the implementation, of
#   exactly the kind Section 5.4 already documents for C3(ii) and the boundary
#   kernel, and it is reported as one.
#
# Outputs
#   paper/tables/sim/sim_multinomial_n1defect.tex    (bare tabular, INV-13)
#   quality_reports/sim/sim_multinomial_n1defect.rds
#   quality_reports/sim/sim_multinomial_n1defect_ckpt.rds
# ============================================================================

suppressMessages({                                                    # INV-15
  library(here)
  library(parallel)
})
source(here::here("scripts", "R", "lf_panel.R"))
source(here::here("scripts", "R", "orthogonal_theta.R"))
source(here::here("scripts", "simulations", "sim_multinomial_dgp.R"))

RNGkind("L'Ecuyer-CMRG")
set.seed(20260827L)                                                   # INV-14

OUT_ROOT <- Sys.getenv("SIM_OUT_ROOT", unset = here::here())          # INV-16
OUT <- file.path(OUT_ROOT, "quality_reports", "sim")
TAB <- file.path(OUT_ROOT, "paper", "tables", "sim")
for (d_ in c(OUT, TAB)) dir.create(d_, showWarnings = FALSE, recursive = TRUE)

# ---- the grid --------------------------------------------------------------
#
# N_SOLVE is ceiling(0.4 n) at the arm's own n, NOT a round number: that is what
# crossfit_once() hands solve_balance_weight() after the fold split and the
# operator/solve halving, so the weight measured here is the weight the arm
# builds.  The map is recorded so the table can print both.

N_ARM      <- c(400L, 800L, 1600L)
N_SOLVE    <- c(160L, 320L, 640L)
L_GRID     <- c(2L, 3L, 4L)
D_GRID     <- c("balanced", "skewed", "misspec")
D_CLEAN    <- c("balanced", "skewed")
## B_SOLVE = 12 independent solve draws per (design, L, n_solve).  The quantity
## whose Monte Carlo error this controls is the RATIO, whose across-draw spread
## is measured below at about 0.02-0.05; twelve draws put its standard error at
## 0.006-0.015, an order of magnitude under the gap between this defect and
## Section 5.3's 0.191, which is what the reading turns on.  It is not chosen to
## resolve a difference between two adjacent cells of this table, and no claim
## below rests on one.
B_SOLVE    <- as.integer(Sys.getenv("SIM_B_SOLVE", unset = "12"))
RHO_RIDGE  <- 1e-3                       # crossfit_once()'s own `rho` default
GH_Z       <- 32L                        # tensor GH order per z coordinate
GH_Z_LO    <- 24L                        # stability comparison
U_HALF     <- 14                         # half-width of the u grid
U_STEP     <- 0.01                       # u grid spacing
K_POLY     <- 6L                         # degree of the R_max basis
N_CORES    <- as.integer(Sys.getenv("SIM_CORES", unset = "8"))

## Streams drawn first, before anything else can consume the generator, so they
## are a function of the declared seed and of nothing else.  Same device as
## sim_multinomial_rootn.R:113.
N_STREAM <- 2048L
STREAMS <- local({                                                    # INV-17
  e <- new.env(parent = emptyenv())
  e$out <- vector("list", N_STREAM)
  s <- get(".Random.seed", envir = globalenv())
  for (j in seq_len(N_STREAM)) {
    s <- parallel::nextRNGStream(s)
    e$out[[j]] <- s
  }
  e$out
})

# ---- the design's conditional law of dU given dZ ---------------------------

#' Conditional mean and scale of dU given dZ, exactly as mdgp_draw() builds it.
#'
#' @param z numeric matrix n x 2, the non-degenerate coordinates of dZ.
#' @param spec one element of MDGP_SPEC.
#' @param m3 logical. FALSE runs the M3-OFF control: gamma = 0 and sigma frozen
#'   at E[0.35 + 0.30 Phi(z1)] = 0.50, under which dU is independent of dZ.
#' @return list(m, s), both length nrow(z).
mdgp_cond <- function(z, spec, m3 = TRUE) {
  if (!m3) {
    return(list(m = numeric(nrow(z)), s = rep(0.50, nrow(z))))
  }
  list(m = spec$gamma * z[, 1] * z[, 2],
       s = sqrt(2 * 0.6^2 + (0.35 + 0.30 * stats::pnorm(z[, 1]))^2))
}

#' One draw of the design, with the M3-OFF control as an option.
#'
#' Reproduces mdgp_draw() line for line at m3 = TRUE -- it is not called through
#' because the control needs one term of dU replaced, and a second code path is
#' cheaper to audit than a flag threaded into a shipped file whose md5 is in
#' another script's checkpoint key (design decision M-N1c).
#'
#' @param n integer. Sample size.
#' @param spec one element of MDGP_SPEC.
#' @param m3 logical. Conditional heteroskedasticity and the z1 z2 term on/off.
#' @return list with the fields sim_multinomial_dgp.R's mdgp_draw() returns.
mdgp_draw_local <- function(n, spec, m3 = TRUE) {
  z  <- matrix(stats::rnorm(n * 2L), n, 2L)
  P  <- mdgp_varrho(z, spec)
  cum <- P
  for (k in seq(2L, ncol(P))) cum[, k] <- cum[, k - 1L] + P[, k]
  w4 <- pmin(rowSums(stats::runif(n) > cum), ncol(P) - 1L)
  xi <- stats::rnorm(n); v1 <- stats::rnorm(n); v2 <- stats::rnorm(n)
  x1 <- stats::pnorm((xi + v1) / 1.5)
  x2 <- stats::pnorm((xi + spec$shift[w4 + 1L] + v2) / 1.5)
  cn <- mdgp_cond(z, spec, m3)
  ## The (v2 - v1) part of dU is the SAME draw in both branches; the control
  ## replaces only the z-dependent mean and scale, so the two variants differ in
  ## M3 and in nothing else.
  du <- cn$m + 0.6 * (v2 - v1) +
    sqrt(pmax(cn$s^2 - 2 * 0.6^2, 0)) * stats::rnorm(n)
  list(y  = MDGP_PHI(x2) - MDGP_PHI(x1) + as.vector(z %*% MDGP_THETA) + du,
       x1 = x1, x2 = x2, Z = cbind(const = 1, z),
       w4 = w4, w3 = pmin(w4, 2L), w2 = as.numeric(w4 > 0L),
       du = du, P = P, z = z)
}

#' The true propensity for a COARSENED instrument, matching mdgp_inst()'s map.
#'
#' @param P numeric matrix n x 4, the four-cell simplex.
#' @param L integer in {2, 3, 4}.
#' @return numeric matrix n x (L-1), the non-base cells of the coarsening.
coarsen_varrho <- function(P, L) {
  if (L == 4L) return(P[, -1L, drop = FALSE])
  if (L == 3L) return(cbind(P[, 2], P[, 3] + P[, 4]))
  matrix(rowSums(P[, -1L, drop = FALSE]), nrow(P), 1L)
}

# ---- exact quadrature ------------------------------------------------------

#' Gauss-Hermite nodes and weights by Golub-Welsch, for int f(x) exp(-x^2) dx.
#' Implemented here rather than taken from a package, as in
#' sim_thm_rootn_n1defect.R:178, so this script adds no dependency.
gauss_hermite <- function(m) {
  k <- seq_len(m - 1L)
  J <- matrix(0, m, m)
  J[cbind(k, k + 1L)] <- sqrt(k / 2)
  J[cbind(k + 1L, k)] <- sqrt(k / 2)
  e <- eigen(J, symmetric = TRUE)
  o <- order(e$values)
  list(x = e$values[o], w = sqrt(pi) * (e$vectors[1L, o])^2)
}

#' Tensor Gauss-Hermite rule for dZ's two non-degenerate coordinates.
#'
#' mdgp_draw() builds them as independent standard normals exactly, so this
#' integrates any bounded smooth function of z against its true law.
#'
#' @param m integer. Nodes per coordinate; the rule has m^2 points.
#' @return list(z = m^2 x 2 matrix of nodes, w = weights summing to one).
z_rule <- function(m) {
  q <- gauss_hermite(m)
  g <- as.matrix(expand.grid(q$x, q$x))
  list(z = sqrt(2) * g, w = as.vector(outer(q$w, q$w)) / pi)
}

# ---- the defect of one weight ----------------------------------------------

#' The N1 defect of one realised shipped weight, in population.
#'
#' @param sw list returned by solve_balance_weight().
#' @param spec one element of MDGP_SPEC.
#' @param m3 logical. Passed to mdgp_cond().
#' @param mz integer. Gauss-Hermite order per z coordinate.
#' @return list of the two ratios, the entrywise matrices, the argmax entry and
#'   the closed-form-against-grid certificate.
n1_defect_one <- function(sw, spec, m3 = TRUE, mz = GH_Z) {
  al <- sw$alpha; su <- sw$sigma_u; uref <- sw$u_ref
  p <- dim(al)[2]; nL1 <- dim(al)[3]
  stopifnot(is.finite(su), su > 0, all(is.finite(al)))

  G  <- z_rule(mz)
  cn <- mdgp_cond(G$z, spec, m3)

  ## The CLOSED FORM.  E[Phi((dU - u_i)/sigma_u) | dZ = z] with dU | z ~ N(m,s^2)
  ## is Phi((m - u_i)/sqrt(sigma_u^2 + s^2)); no u-quadrature enters here.
  Pm  <- stats::pnorm(outer(cn$m, uref, "-") / sqrt(su^2 + cn$s^2))
  bt  <- su * sqrt(2 * pi) * apply_alpha(Pm, al)            # ng x p x (L-1)

  ## The marginal law of dU on a fine grid, as the z-mixture of the conditional
  ## normals.  The grid is used for the SECOND moment, which has no comparably
  ## cheap closed form, and it recomputes the FIRST as its own certificate.
  ug <- seq(-U_HALF, U_HALF, by = U_STEP)
  fU <- as.vector(stats::dnorm(outer(ug, cn$m, "-") /
                                 rep(cn$s, each = length(ug))) %*% (G$w / cn$s))
  Lg <- su * sqrt(2 * pi) *
    apply_alpha(stats::pnorm(outer(ug, uref, "-") / su), al)

  EL   <- apply(bt, c(2L, 3L), function(v) sum(G$w * v))
  ELg  <- apply(Lg, c(2L, 3L), function(v) sum(v * fU) * U_STEP)
  EL2g <- apply(Lg, c(2L, 3L), function(v) sum(v * v * fU) * U_STEP)

  b_l2 <- L_l2 <- matrix(0, p, nL1)                                   # INV-17
  for (j in seq_len(p)) {
    for (l in seq_len(nL1)) {
      b_l2[j, l] <- sqrt(max(sum(G$w * (bt[, j, l] - EL[j, l])^2), 0))
      L_l2[j, l] <- sqrt(max(EL2g[j, l] - EL[j, l]^2, 0))
    }
  }
  am <- which(b_l2 == max(b_l2), arr.ind = TRUE)[1L, ]

  list(b_l2 = b_l2, L_l2 = L_l2,
       b_max = max(b_l2), L_max = max(L_l2),
       ratio_max = max(b_l2) / max(L_l2),
       b_fro = sqrt(sum(b_l2^2)), L_fro = sqrt(sum(L_l2^2)),
       ratio_fro = sqrt(sum(b_l2^2)) / sqrt(sum(L_l2^2)),
       arg_j = as.integer(am[1L]), arg_l = as.integer(am[2L]),
       ## The certificate: the same E[Lambda] by two routes that share no line
       ## of arithmetic.  Reported as an ABSOLUTE gap and as the scale it is a
       ## gap in, because a relative figure on a near-zero entry is unreadable.
       cert_abs = max(abs(EL - ELg)), cert_scale = max(abs(EL)),
       mass_fU = sum(fU) * U_STEP, sigma_u = su, rel_bal = max(sw$rel_bal))
}

#' Solve the shipped weight once on a fresh draw, and take its defect.
#'
#' @param j integer. Replication index; selects the L'Ecuyer stream.
#' @param design character. Key in MDGP_SPEC.
#' @param L integer. Cardinality.
#' @param n_sol integer. Solve-fold size the arm realises.
#' @param m3 logical. M3 on (the shipped design) or off (the control).
#' @return one-row data.frame, or NULL when the solve failed.
defect_once <- function(j, design, L, n_sol, m3 = TRUE) {
  assign(".Random.seed", STREAMS[[j]], envir = globalenv())
  spec <- MDGP_SPEC[[design]]
  d <- mdgp_draw_local(n_sol, spec, m3)
  w <- switch(as.character(L), "2" = d$w2, "3" = d$w3, "4" = d$w4)
  cells <- sort(unique(as.integer(w)))
  ## A solve fold that lost a cell is a different cardinality, not a defect
  ## measurement at this one; it is dropped and COUNTED rather than silently
  ## measured at L - 1.
  if (length(cells) != L) return(NULL)
  sw <- tryCatch(
    solve_balance_weight(d$du, w, d$x1, d$x2, d$Z, rho = RHO_RIDGE,
                         wcen = coarsen_varrho(d$P, L), cells = cells),
    error = function(e) NULL)
  if (is.null(sw)) return(NULL)
  f <- tryCatch(n1_defect_one(sw, spec, m3), error = function(e) NULL)
  if (is.null(f)) return(NULL)
  data.frame(design = design, L = L, n_sol = n_sol, m3 = m3, rep = j,
             b_max = f$b_max, L_max = f$L_max, ratio_max = f$ratio_max,
             b_fro = f$b_fro, L_fro = f$L_fro, ratio_fro = f$ratio_fro,
             arg_j = f$arg_j, arg_l = f$arg_l,
             cert_abs = f$cert_abs, cert_scale = f$cert_scale,
             mass_fU = f$mass_fU, sigma_u = f$sigma_u, rel_bal = f$rel_bal,
             stringsAsFactors = FALSE)
}

# ---- the design ceiling ----------------------------------------------------

#' sup over centred u-only weights of ||E[Lambda | dZ]|| / ||Lambda||.
#'
#' A property of the DESIGN and of no weight (design decision M-N1d).  The
#' supremum is taken over polynomials in u of degree <= K, in a basis
#' orthonormalised under dU's own law, so the returned value is a Rayleigh
#' quotient of a symmetric PSD matrix with unit trace bound and lands in [0,1]
#' by construction rather than by hope -- the un-orthonormalised generalised
#' eigenproblem in a raw Hermite basis returns values above one at K >= 6, which
#' is the ill-conditioning of that Gram and not a defect above the ceiling.
#'
#' @param spec one element of MDGP_SPEC.
#' @param K integer. Polynomial degree.
#' @param m3 logical.
#' @param mz integer. Gauss-Hermite order per z coordinate.
#' @return list(r_max, rank_used).
design_ceiling <- function(spec, K = K_POLY, m3 = TRUE, mz = GH_Z) {
  G  <- z_rule(mz)
  cn <- mdgp_cond(G$z, spec, m3)
  qu <- gauss_hermite(60L)
  sdu <- sqrt(sum(G$w * (cn$m^2 + cn$s^2)) - sum(G$w * cn$m)^2)

  ## Monomials in the STANDARDISED residual, which is what keeps the Gram
  ## conditioned; the span is the same, so the supremum is unchanged.
  mono <- function(t) {
    M <- matrix(0, length(t), K)                                      # INV-17
    M[, 1L] <- t
    if (K >= 2L) for (k in 2:K) M[, k] <- M[, k - 1L] * t
    M
  }
  ## A = E[m m'] and Cm = E[m | dZ], both by the same u-rule at each z node.
  ng <- nrow(G$z)
  A  <- matrix(0, K, K); Cm <- matrix(0, ng, K)                       # INV-17
  for (q in seq_along(qu$x)) {
    uu <- (cn$m + sqrt(2) * cn$s * qu$x[q]) / sdu
    Mq <- mono(uu)
    wq <- qu$w[q] / sqrt(pi)
    A  <- A + crossprod(Mq * (wq * G$w), Mq)
    Cm <- Cm + wq * Mq
  }
  mu <- colSums(G$w * Cm)
  A  <- A - outer(mu, mu)
  Bm <- crossprod(Cm * G$w, Cm) - outer(mu, mu)

  ea <- eigen((A + t(A)) / 2, symmetric = TRUE)
  keep <- which(ea$values > ea$values[1L] * 1e-10)
  R <- ea$vectors[, keep, drop = FALSE] %*%
    diag(1 / sqrt(ea$values[keep]), length(keep))
  S <- t(R) %*% ((Bm + t(Bm)) / 2) %*% R
  ev <- eigen((S + t(S)) / 2, symmetric = TRUE, only.values = TRUE)$values
  list(r_max = sqrt(max(min(max(ev), 1), 0)), rank_used = length(keep))
}

# ---- run, checkpointed per cell --------------------------------------------
#
# Nothing here costs an hour, so the checkpoint is insurance and not a schedule:
# background R on this machine is killed at about 65 minutes, and a script that
# writes only at the end loses everything it did.  Same *_ckpt.rds convention as
# sim_multinomial_rootn.R.

CKPT <- file.path(OUT, "sim_multinomial_n1defect_ckpt.rds")
CFG <- list(b = B_SOLVE, n_sol = N_SOLVE, L = L_GRID, d = D_GRID,
            rho = RHO_RIDGE, gh = GH_Z, uhalf = U_HALF, ustep = U_STEP,
            kpoly = K_POLY, seed = 20260827L,
            src = unname(tools::md5sum(here::here(
              "scripts", "R", c("lf_panel.R", "orthogonal_theta.R")))),
            dgp = unname(tools::md5sum(here::here(
              "scripts", "simulations", "sim_multinomial_dgp.R"))))

CELLS <- expand.grid(design = D_GRID, L = L_GRID, n_sol = N_SOLVE,
                     m3 = TRUE, stringsAsFactors = FALSE)
## The control runs at the largest solve size only and on the two
## correctly-specified designs: it certifies the machinery, and a floor does not
## need a grid.
CELLS <- rbind(CELLS,
               expand.grid(design = D_CLEAN, L = L_GRID,
                           n_sol = max(N_SOLVE), m3 = FALSE,
                           stringsAsFactors = FALSE))
CELLS$key <- sprintf("%s_L%d_s%d_m3%d", CELLS$design, CELLS$L, CELLS$n_sol,
                     as.integer(CELLS$m3))

CK_ENV <- new.env(parent = emptyenv())      # NOT `<<-` (R standard section 9)
CK_ENV$res <- vector("list", nrow(CELLS))
names(CK_ENV$res) <- CELLS$key
if (file.exists(CKPT)) {
  old <- readRDS(CKPT)
  if (identical(old$cfg, CFG)) {
    for (k in names(old$res)) {
      if (k %in% CELLS$key && !is.null(old$res[[k]])) CK_ENV$res[[k]] <- old$res[[k]]
    }
    message(sprintf("  resuming: %d of %d cells on disk",
                    sum(!vapply(CK_ENV$res, is.null, logical(1))), nrow(CELLS)))
  } else {
    message("  cache discarded, configuration changed")
  }
}

message("== N1 defect of the shipped weight, ", nrow(CELLS), " cells x ",
        B_SOLVE, " solve draws ==")
for (cc in seq_len(nrow(CELLS))) {
  if (!is.null(CK_ENV$res[[cc]])) next
  t0 <- Sys.time()
  off <- (cc - 1L) * B_SOLVE
  raw <- parallel::mclapply(seq_len(B_SOLVE), function(b)
    tryCatch(defect_once(off + b, CELLS$design[cc], CELLS$L[cc],
                         CELLS$n_sol[cc], CELLS$m3[cc]),
             error = function(e) NULL),
    mc.cores = N_CORES, mc.preschedule = FALSE)
  ok <- vapply(raw, function(z) is.data.frame(z) && nrow(z) == 1L, logical(1))
  cur <- CK_ENV$res
  cur[[cc]] <- if (any(ok)) do.call(rbind, raw[ok]) else NULL
  CK_ENV$res <- cur
  tmp <- paste0(CKPT, ".tmp")
  saveRDS(list(cfg = CFG, res = CK_ENV$res), tmp)
  file.rename(tmp, CKPT)                    # atomic
  message(sprintf("  %-26s %2d/%2d draws in %4.1f s", CELLS$key[cc],
                  sum(ok), B_SOLVE,
                  as.numeric(difftime(Sys.time(), t0, units = "secs"))))
}

RAW <- do.call(rbind, CK_ENV$res[!vapply(CK_ENV$res, is.null, logical(1))])
stopifnot(nrow(RAW) > 0L)

# ---- the design ceiling, and the conditional-law check ---------------------

CEIL <- do.call(rbind, lapply(D_GRID, function(dd) {
  a <- design_ceiling(MDGP_SPEC[[dd]], K_POLY, TRUE)
  b <- design_ceiling(MDGP_SPEC[[dd]], K_POLY, FALSE)
  data.frame(design = dd, r_max = a$r_max, rank_used = a$rank_used,
             r_max_ctrl = b$r_max, stringsAsFactors = FALSE)
}))

## dU | dZ ~ N(m(z), s(z)^2) is ASSERTED at the head of this file and is checked
## here against a draw of the SHIPPED mdgp_draw(), not of the local copy: the
## studentised residual of the standardised draw against N(0,1) in its first
## four moments.  A failure here voids every closed form above.
LAWCHK <- do.call(rbind, lapply(D_GRID, function(dd) {
  spec <- MDGP_SPEC[[dd]]
  assign(".Random.seed", STREAMS[[N_STREAM - match(dd, D_GRID)]],
         envir = globalenv())
  n <- 4e5L
  d <- mdgp_draw(n, spec)
  cn <- mdgp_cond(d$Z[, -1L, drop = FALSE], spec, TRUE)
  t <- (d$du - cn$m) / cn$s
  mom <- c(mean(t), mean(t^2) - 1, mean(t^3), mean(t^4) - 3)
  se <- c(1, sqrt(2), sqrt(6), sqrt(96)) / sqrt(n)
  data.frame(design = dd, t1 = mom[1] / se[1], t2 = mom[2] / se[2],
             t3 = mom[3] / se[3], t4 = mom[4] / se[4],
             stringsAsFactors = FALSE)
}))

saveRDS(list(raw = RAW, ceiling = CEIL, lawchk = LAWCHK, cells = CELLS,
             cfg = CFG),
        file.path(OUT, "sim_multinomial_n1defect.rds"))

# ---- cell summaries --------------------------------------------------------

#' Mean and Monte Carlo standard error of one column over solve draws.
mc <- function(v) c(m = mean(v), se = stats::sd(v) / sqrt(length(v)))

SUM <- do.call(rbind, lapply(split(RAW, paste(RAW$design, RAW$L, RAW$n_sol,
                                              RAW$m3, sep = "|")),
                             function(x) {
    rm_ <- mc(x$ratio_max); rf_ <- mc(x$ratio_fro)
    bm_ <- mc(x$b_max); lm_ <- mc(x$L_max)
    data.frame(design = x$design[1L], L = x$L[1L], n_sol = x$n_sol[1L],
               m3 = x$m3[1L], nrep = nrow(x),
               b_max = bm_[["m"]], b_max_se = bm_[["se"]],
               L_max = lm_[["m"]], L_max_se = lm_[["se"]],
               ratio_max = rm_[["m"]], ratio_max_se = rm_[["se"]],
               ratio_fro = rf_[["m"]], ratio_fro_se = rf_[["se"]],
               arg_j = as.integer(stats::median(x$arg_j)),
               arg_l = as.integer(stats::median(x$arg_l)),
               share_j1 = mean(x$arg_j == 1L),
               cert = max(x$cert_abs), cert_scale = max(x$cert_scale),
               sigma_u = mean(x$sigma_u), rel_bal = mean(x$rel_bal),
               stringsAsFactors = FALSE)
  }))
rownames(SUM) <- NULL
SUM <- SUM[order(match(SUM$design, D_GRID), SUM$m3 == FALSE, SUM$L,
                 SUM$n_sol), ]

# ---- the table -------------------------------------------------------------

ff <- function(x, d = 4) formatC(x, format = "f", digits = d)
sci <- function(x, d = 2) {
  ## Section 5.3's own convention for a number below 1e-3: the shipped
  ## sim_thm_rootn_n1defect.tex prints $8.23\times10^{-6}$, not 0.0000.
  if (!is.finite(x)) return(DASH)
  ## THREE DIGITS ABOVE 1e-3, WHICH IS WHAT SECTION 5.3 PRINTS: its 0.191 is
  ## the number this column has to be readable against, and a fourth digit on a
  ## comparator is a fourth digit the comparison does not use.
  if (abs(x) >= 1e-3 || x == 0) return(ff(x, d + 1))
  e <- floor(log10(abs(x)))
  sprintf("$%s\\times10^{%d}$", ff(x / 10^e, d), e)
}
pm <- function(m, s, d = 4) sprintf("%s (%s)", ff(m, d), ff(s, d))
nn <- function(x) format(x, big.mark = ",", scientific = FALSE)
## A BARE COMMA INSIDE $...$ IS PUNCTUATION AND TeX SETS A THIN SPACE AFTER IT,
## so $1,600$ prints as "1, 600".  Same trap, same brace, as
## sim_merged_cardinality.R's b_lines().
tex_num <- function(x) gsub(",", "{,}", nn(x), fixed = TRUE)
DASH <- "---"
DTEX <- vapply(MDGP_SPEC, function(k) k$tex, character(1))
NC <- 7L
panel <- function(txt) vapply(txt, function(s)
  sprintf("\\multicolumn{%d}{l}{%s} \\\\", NC, s), character(1),
  USE.NAMES = FALSE)
blank_rep <- function(x, first) if (first) x else ""

L_TOP <- max(N_SOLVE)
l <- c("\\begin{tabular}{llccccc}", "\\toprule",
       ## EVERY SPANNING ROW HERE IS MEASURED AT \\footnotesize AGAINST THE
       ## 469.8pt TEXT BLOCK, NOT ESTIMATED.  The first draft of this table was
       ## 499.8pt -- overfull by 30pt, silently, in a project that has already
       ## shipped one table that overran without saying so.  What set the width
       ## was two panel tags at 446.1 and 484.4pt; split over two short rows
       ## apiece they measure 236.6/227.4 and 247.0/246.6pt, and the widest body
       ## row, 360.8pt, sets the width instead.
       panel(c(paste("\\textbf{Block III} --- multinomial design, weight from",
                     "\\texttt{solve\\_balance\\_weight}"),
               paste("\\quad the N1 functional is exact; the weight is the",
                     "estimator's own"))),
       "\\midrule")

# Panel A -- the headline, at the arm's largest solve fold, WITH BLOCK I'S OWN
# NUMBER IN THE LAST COLUMN.  That column is READ FROM BLOCK I'S .rds, never
# transcribed (INV-22): Section 5.3's 3.3e-6 and 0.191 are what this measurement
# has to be read against, and a comparator typed in by hand is a comparator that
# goes stale the next time that arm runs.  Block I is BINARY and four-cell only,
# so its sans-L = 3 cell is an em-dash and not a blank.
BLK1_N1 <- local({
  f <- file.path(OUT, "sim_thm_rootn_n1defect.rds")
  if (!file.exists(f)) {
    message("  NOTE: Block I's N1 record is absent; its column prints ---.")
    return(NULL)
  }
  z <- readRDS(f)$fit
  vapply(c("A-L2", "A-L4"), function(k) z[[k]]$b_max / z[[k]]$L_max, numeric(1))
})
blk1_cell <- function(LL) {
  if (is.null(BLK1_N1)) return(DASH)
  k <- if (LL == 2L) "A-L2" else if (LL == 4L) "A-L4" else NA_character_
  if (is.na(k)) DASH else sci(BLK1_N1[[k]])
}
l <- c(l, panel(c(sprintf(paste("\\textit{Panel A: the N1 defect at",
                               "$n_{\\mathrm{solve}}=%d$, i.e.\\ $n=%s$.}"),
                          L_TOP, tex_num(N_ARM[which.max(N_SOLVE)])),
                  sprintf(paste("\\textit{\\quad Monte Carlo standard errors",
                                "over $%d$ solve draws.}"), B_SOLVE))),
       "\\midrule",
       paste("Design & $\\mathsf L$ & $\\max_{j,l}\\|b_{jl}\\|$ &",
             "$\\max_{j,l}\\|L_{jl}\\|$ & entrywise ratio &",
             "$\\|b\\|_F/\\|L\\|_F$ & Block I, DGP-A \\\\"),
       "\\midrule")
CO <- c("const.", "$z_1$", "$z_2$")
for (dd in D_GRID) {
  first_d <- TRUE
  for (LL in L_GRID) {
    x <- SUM[SUM$design == dd & SUM$L == LL & SUM$n_sol == L_TOP & SUM$m3, ]
    if (!nrow(x)) next
    l <- c(l, sprintf("%s & %d & %s & %s & %s & %s & %s \\\\",
                      blank_rep(DTEX[[dd]], first_d), LL,
                      ## b_max AND L_max ARE SCALE, NOT THE READING.  Their
                      ## Monte Carlo standard errors are in the .rds and are
                      ## dropped from the page: printing them widened the table
                      ## by 34pt for two columns nothing here turns on, and the
                      ## RATIO -- which is what is read against Section 5.3's
                      ## 0.191 -- carries its own in both conventions.
                      ff(x$b_max, 3), ff(x$L_max, 3),
                      ## THREE DIGITS, NOT FOUR.  The two ratio columns at four
                      ## digits are 66.7pt each and are the widest numeric
                      ## columns in the table; three digits is a resolution of
                      ## 0.001 on a quantity read against Section 5.3's 0.191
                      ## and against a control at 1e-14, and no reading here is
                      ## finer than the 0.01-0.03 Monte Carlo standard error
                      ## printed beside it.
                      pm(x$ratio_max, x$ratio_max_se, 3),
                      pm(x$ratio_fro, x$ratio_fro_se, 3),
                      blk1_cell(LL)))
    first_d <- FALSE
  }
  if (dd != D_GRID[length(D_GRID)]) l <- c(l, "\\addlinespace")
}

# Panel B -- against the solve size.
l <- c(l, "\\addlinespace",
       panel(c(paste("\\textit{Panel B: the entrywise ratio against the solve",
                     "fold, $\\lceil 0.4n\\rceil$.}"),
               paste("\\textit{\\quad A restriction on the weight class does",
                     "not shrink in $n$.}"))),
       "\\midrule",
       paste("Design & $\\mathsf L$ &",
             paste(sprintf("$n_{\\mathrm{solve}}=%d$", N_SOLVE),
                   collapse = " & "),
             ## "worst $j$ [share]" is 70.8pt and is the widest cell in its
             ## column; the payload "const. [1.00]" is 56.2pt.  The header is
             ## what sets the width, so the header is what gets shortened.
             "& log-log slope & worst $j$ \\\\"),
       "\\midrule")
for (dd in D_GRID) {
  first_d <- TRUE
  for (LL in L_GRID) {
    v <- vapply(N_SOLVE, function(s) {
      x <- SUM[SUM$design == dd & SUM$L == LL & SUM$n_sol == s & SUM$m3, ]
      if (nrow(x)) x$ratio_max else NA_real_
    }, numeric(1))
    if (all(is.na(v))) next
    sl <- if (sum(is.finite(v)) >= 2L)
      stats::coef(stats::lm(log(v) ~ log(N_SOLVE)))[[2L]] else NA_real_
    xt <- SUM[SUM$design == dd & SUM$L == LL & SUM$n_sol == L_TOP & SUM$m3, ]
    l <- c(l, sprintf("%s & %d & %s & %s & %s \\\\",
                      blank_rep(DTEX[[dd]], first_d), LL,
                      paste(vapply(v, function(z) ff(z, 3), character(1)),
                            collapse = " & "),
                      if (is.finite(sl)) ff(sl, 3) else DASH,
                      if (nrow(xt))
                        sprintf("%s [%s]", CO[xt$arg_j], ff(xt$share_j1, 2))
                      else DASH))
    first_d <- FALSE
  }
  if (dd != D_GRID[length(D_GRID)]) l <- c(l, "\\addlinespace")
}

# Panel C -- the control, the ceiling and the certificates.
l <- c(l, "\\addlinespace",
       panel(paste("\\textit{Panel C: the M3-off control, the design ceiling",
                   "and the quadrature certificates.}")),
       "\\midrule",
       paste("Design & $\\mathsf L$ & control ratio & $R_{\\max}$ &",
             "$R_{\\max}$ control & cert.\\ $|\\Delta E[L]|$ & scale \\\\"),
       "\\midrule")
for (dd in D_GRID) {
  first_d <- TRUE
  ce <- CEIL[CEIL$design == dd, ]
  for (LL in L_GRID) {
    xc <- SUM[SUM$design == dd & SUM$L == LL & !SUM$m3, ]
    xm <- SUM[SUM$design == dd & SUM$L == LL & SUM$n_sol == L_TOP & SUM$m3, ]
    if (!nrow(xm)) next
    l <- c(l, sprintf("%s & %d & %s & %s & %s & %s & %s \\\\",
                      blank_rep(DTEX[[dd]], first_d), LL,
                      if (nrow(xc)) sci(xc$ratio_max) else DASH,
                      blank_rep(ff(ce$r_max, 4), first_d),
                      blank_rep(sci(ce$r_max_ctrl), first_d),
                      sci(xm$cert), ff(xm$cert_scale, 2)))
    first_d <- FALSE
  }
  if (dd != D_GRID[length(D_GRID)]) l <- c(l, "\\addlinespace")
}
writeLines(c(l, "\\bottomrule", "\\end{tabular}"),
           file.path(TAB, "sim_multinomial_n1defect.tex"))
message("  wrote ", file.path("paper", "tables", "sim",
                              "sim_multinomial_n1defect.tex"))

# ---- console verdict -------------------------------------------------------

cat("\n\n===== N1 AT THE MULTINOMIAL DESIGNS ==============================\n")
cat("N1 requires the ratio to be ZERO.  Section 5.3's comparators, on\n")
cat("Block I: 3.3e-6 at L = 2 (holds) and 0.191 at L = 4 (fails).\n\n")
cat(sprintf("%-10s %-2s %-6s %-18s %-18s %-8s\n",
            "design", "L", "n_sol", "entrywise ratio", "Frobenius ratio",
            "worst j"))
for (dd in D_GRID) for (LL in L_GRID) for (s in N_SOLVE) {
  x <- SUM[SUM$design == dd & SUM$L == LL & SUM$n_sol == s & SUM$m3, ]
  if (!nrow(x)) next
  cat(sprintf("%-10s %-2d %-6d %-18s %-18s %-8s\n",
              dd, LL, s, sprintf("%.4f (%.4f)", x$ratio_max, x$ratio_max_se),
              sprintf("%.4f (%.4f)", x$ratio_fro, x$ratio_fro_se),
              c("const", "z1", "z2")[x$arg_j]))
}
cat("\n----- M3-OFF CONTROL: the numerical floor of this script ----------\n")
for (dd in D_CLEAN) for (LL in L_GRID) {
  x <- SUM[SUM$design == dd & SUM$L == LL & !SUM$m3, ]
  if (!nrow(x)) next
  cat(sprintf("  %-10s L=%d  ratio %.3e   (%d draws)\n", dd, LL,
              x$ratio_max, x$nrep))
}
cat("\n----- DESIGN CEILING (sup over centred u-only weights) ------------\n")
for (i in seq_len(nrow(CEIL))) {
  cat(sprintf("  %-10s R_max %.4f (rank %d)   control %.3e\n",
              CEIL$design[i], CEIL$r_max[i], CEIL$rank_used[i],
              CEIL$r_max_ctrl[i]))
}
cat("\n----- dU | dZ ~ N(m(z), s(z)^2): studentised moments of the ------\n")
cat("      standardised residual, on the SHIPPED mdgp_draw(), n = 4e5.\n")
for (i in seq_len(nrow(LAWCHK))) {
  cat(sprintf("  %-10s t1 %6.2f  t2 %6.2f  t3 %6.2f  t4 %6.2f\n",
              LAWCHK$design[i], LAWCHK$t1[i], LAWCHK$t2[i], LAWCHK$t3[i],
              LAWCHK$t4[i]))
}
cat("\ndone\n")
