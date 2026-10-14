# ============================================================================
# probe_mbar_ladder.R
#
# WHAT THE THEORY-SIZED CAP DOES TO phi-hat, MEASURED WHERE THE TRUTH IS KNOWN.
#
#   Rscript explorations/theory-cap-mbar/R/probe_mbar_ladder.R
#
# ---------------------------------------------------------------------------
# WHY THIS RUNS BEFORE THE APPLICATION IS TOUCHED
#
# The author has ruled for theory-consistency on the iteration cap.  eq:cap is
# m-bar_n >= omega_n^2 delta-hat_n^{-2}; eqcap_instantiate.R puts that at
# 2.7e6 to 1.4e11 at the application's n = 983 -- 3.2 to 1.7e5 wall-YEARS of
# stage-05 compute -- so the application cannot be run at it and the question of
# what it would produce has to be answered somewhere else.
#
# The simulation is that somewhere.  At the Monte Carlo's n = 400, d_Z = 2, the
# same display gives m-bar = 32,214 at the most favourable literal instantiation
# (c_C = 3, c_Phi = 1) -- reachable in about 25 minutes per path.  So the exact
# object the application cannot afford CAN be evaluated here, against a known
# varphi.
#
# ---------------------------------------------------------------------------
# THE INTERACTION THAT MAKES THIS NON-OBVIOUS
#
# TAU_DP = 0 (C26): the discrepancy stop is disabled and the CAP is the
# regulariser.  In the corpus those roles are reversed -- the stop regularises
# and eq:cap is a safety net sized so the cap never pre-empts it.  Raising m-bar
# to a theory-sized value at tau = 0 therefore does NOT import the corpus's
# regularisation; it removes what regularisation the configuration has.  The
# measurement below is of exactly that.
#
# ---------------------------------------------------------------------------
# DESIGN
#
#   designs      balanced, skewed -- the two whose propensity is IN the family
#                the estimator fits.  `misspec` is excluded: its phi-hat is
#                anti-correlated with the truth for a reason already diagnosed
#                (a documented violation of thm:rootn's own nuisance-rate
#                hypothesis), so running it here would confound the cap question
#                with a specification question.  Noted, not measured again.
#   L            2, 3, 4, three coarsenings of ONE W on ONE draw, paired on the
#                RNG anchor -- sim_multinomial_phistep.R's rep_one() verbatim.
#   n            400.  This is the n the C4 comparison was quoted at
#                (ISE 0.187/0.149/0.131 at m-bar = 100 against 0.098/0.103/0.112
#                at 15/30/60), so the numbers below are directly commensurable
#                with the ones already on record.
#   truth        varphi(x) = sin(2 pi x)/2;  b_m = <phi-hat_m, varphi>/||varphi||^2.
#
#   STAGE 1      B = 24, imax = 4,000.  67x the current L = 4 cap and 40x the
#                m-bar = 100 comparison point.  Powers the shape.
#   STAGE 2      B = 6,  imax = 32,214 = eq:cap at (n = 400, c_C = 3, c_Phi = 1),
#                L in {2, 4}.  The endpoint AT the theory cap, so the verdict is
#                a measurement and not an extrapolation.
#
# SELF-CHECK.  The streams are rebuilt from sim_multinomial_phistep.R's own seed
# and offsets, so for m <= 100 every path here must equal the cached path in
# sim_multinomial_phistep_ckpt.rds to machine precision.  That equality is
# ASSERTED, not inspected: if it fails, the probe is measuring a different
# estimator and its numbers mean nothing.
#
# RUNTIME, MEASURED BEFORE LAUNCH: 45.6 ms per iteration at n = 400, L = 4.
# Stage 1 about 6 core-hours, stage 2 about 8, so about 2 h wall on 7 cores.
# Checkpointed per cell; interrupting loses at most one cell.
# ============================================================================

suppressMessages({                                                    # INV-15
  library(here)
  library(parallel)
})
source(here::here("scripts", "R", "lf_panel.R"))
source(here::here("scripts", "R", "orthogonal_theta.R"))
source(here::here("scripts", "simulations", "sim_multinomial_dgp.R"))

## SEED AND RNG KIND ARE sim_multinomial_phistep.R's, NOT THIS FILE'S.  They are
## not a choice here: reproducing that study's streams is what makes the m <= 100
## self-check below a test rather than a coincidence.
RNGkind("L'Ecuyer-CMRG")
set.seed(20260814L)                                                   # INV-14

N_STREAM <- 512L
streams <- vector("list", N_STREAM)                                   # INV-17
local({
  s <- get(".Random.seed", envir = globalenv())
  for (j in seq_len(N_STREAM)) {
    s <- parallel::nextRNGStream(s)
    streams[[j]] <<- s
  }
})

OUT <- here::here("explorations", "theory-cap-mbar", "output")        # INV-16
dir.create(OUT, showWarnings = FALSE, recursive = TRUE)

N_SIM       <- 400L
L_GRID      <- c(2L, 3L, 4L)
D_GRID      <- c("balanced", "skewed")
EPS_RHO     <- 0.03
N_T         <- 16L
T_SCALE     <- 0.25
N_CORES     <- 7L

IMAX_S1     <- 4000L
B_S1        <- 24L
## eq:cap at n = 400, d_Z = 2, c_C = 3, c_Phi = 1: the most favourable literal
## instantiation of the display.  Read from eqcap_instantiate.R's output rather
## than retyped, so the two files cannot drift.
CAP_RDS     <- file.path(OUT, "eqcap_instantiate.rds")
stopifnot(file.exists(CAP_RDS))
ecap <- readRDS(CAP_RDS)
IMAX_S2 <- as.integer(ceiling(
  ecap$sim_cap$mbar_corpus[ecap$sim_cap$c_c == 3 & ecap$sim_cap$n == N_SIM]))
B_S2    <- 6L
L_S2    <- c(2L, 4L)

## The caps the report tabulates.  15/30/60 are C4's current values; 100 is the
## comparison point already on record; the rest trace the approach to eq:cap.
REPORT_M <- c(15L, 30L, 60L, 100L, 200L, 500L, 1000L, 2000L, 4000L)

# ---------------------------------------------------------------------------
# lf_path(): sim_multinomial_phistep.R's path-recording solve, VERBATIM.
#
# Copied rather than sourced because that script runs a 6e5-observation design
# validation before it defines anything.  check_loop_fidelity() below proves the
# copy is lf_solve()'s loop on this machine on this run, exactly as the parent
# study does, and stops if it is not.
# ---------------------------------------------------------------------------

#' Landweber-Fridman with the whole path kept.
#'
#' lf_solve()'s loop with the stopping tests removed, so it always runs to
#' `imax`.  `err[m]` and `noise[m]` are the discrepancy and delta-hat_n AT the
#' iterate stored in `PHI[m, ]`, which is the pairing lf_solve()'s discrepancy
#' test uses.
#'
#' @param op operator from make_operator(); `init` from init_control().
#' @param imax integer. Iterations to run.
#' @return list: err, noise (length imax), PHI (imax x |xeval|), TH (imax x p),
#'   cste.
lf_path <- function(y, x1, x2, Z, w, op, init, rho = NULL, bier = NULL,
                    adj_wtil = TRUE, cste = NULL, imax = 60L) {
  d1 <- init$d1; d2 <- init$d2; dev <- init$dev
  theta <- init$theta
  phi1 <- integrate_centre(d1, op$M1, op$ord1)
  phi2 <- integrate_centre(d2, op$M2, op$ord2)
  dphi <- locate_dphi(phi2 - phi1, y, Z, theta)

  if (is.null(cste)) {
    u0 <- as.vector(y - Z %*% theta) - dphi
    r0 <- operator_residual(u0, w, rho = rho, bier = bier, adj_wtil = adj_wtil)
    nrm <- operator_norm2(op, weight = r0$adjw)
    cste <- if (is.finite(nrm) && nrm > 0) 1 / nrm else 0.5
  }

  errn <- rep(NA_real_, imax); noisen <- rep(NA_real_, imax)          # INV-17
  PHI <- matrix(NA_real_, imax, length(op$xeval))
  TH  <- matrix(NA_real_, imax, ncol(Z))

  for (it in seq_len(imax)) {
    u <- as.vector(y - Z %*% theta) - dphi
    res <- operator_residual(u, w, rho = rho, bier = bier, adj_wtil = adj_wtil)
    errn[it]   <- residual_norm(res)
    noisen[it] <- res$noise
    PHI[it, ]  <- cumtrapz_centre(op$xeval, dev)
    TH[it, ]   <- theta

    step <- apply_adjoint(op, res$comperr)
    d1  <- d1  - cste * step$d1
    d2  <- d2  - cste * step$d2
    dev <- dev - cste * step$dev

    phi1 <- integrate_centre(d1, op$M1, op$ord1)
    phi2 <- integrate_centre(d2, op$M2, op$ord2)
    dphi <- locate_dphi(phi2 - phi1, y, Z, theta)

    theta <- stats::lm.fit(Z, as.vector(y - dphi))$coefficients
    theta[!is.finite(theta)] <- 0
    dphi <- locate_dphi(dphi, y, Z, theta)
  }
  list(err = errn, noise = noisen, PHI = PHI, TH = TH, cste = cste)
}

#' Prove lf_path() is lf_solve()'s loop, on this machine, on this run.
#'
#' Requires exact equality; any drift makes every number below a statement about
#' a different estimator, so this is a stop and not a warning.
#'
#' @param n,L,imax integers. A small configuration; the identity is exact or not.
#' @return named numeric of the three gaps, all zero when the copy is faithful.
check_loop_fidelity <- function(n = 400L, L = 4L, imax = 25L) {
  d <- mdgp_draw(n, MDGP_SPEC$balanced)
  w <- mdgp_inst(d, L)
  xev <- seq(stats::quantile(c(d$x1, d$x2), 0.05),
             stats::quantile(c(d$x1, d$x2), 0.95), length.out = 60L)
  op <- make_operator(d$x1, d$x2, xev)
  cells <- sort(unique(as.integer(w)))
  R <- fit_propensity_multi(w, d$Z, seq_len(n), seq_len(n), eps = EPS_RHO,
                            cells = cells)
  attr(R, "prop_diag") <- NULL
  rho <- if (L == 2L) as.vector(R) else R
  bier <- make_bierens(d$Z, n_t = N_T, seed = 20260805L, scale = T_SCALE)
  init <- init_control(d$y, d$x1, d$x2, d$Z, w, op)
  u0 <- as.vector(d$y - d$Z %*% init$theta) -
    locate_dphi(integrate_centre(init$d2, op$M2, op$ord2) -
                integrate_centre(init$d1, op$M1, op$ord1), d$y, d$Z, init$theta)
  r0 <- operator_residual(u0, w, rho = rho, bier = bier, adj_wtil = TRUE)
  cste <- 1 / operator_norm2(op, weight = r0$adjw)
  a <- lf_path(d$y, d$x1, d$x2, d$Z, w, op, init, rho = rho, bier = bier,
               adj_wtil = TRUE, cste = cste, imax = imax)
  b <- lf_solve(d$y, d$x1, d$x2, d$Z, w, op, init, rho = rho, bier = bier,
                adj_wtil = TRUE, cste = cste, imax = imax, patience = imax,
                tau_dp = 0)
  gaps <- c(err = max(abs(a$err - b$err_path)),
            noise = max(abs(a$noise - b$noise_path)),
            phi = max(abs(a$PHI[b$iter, ] - b$phiev)))
  if (max(gaps) > 0) {
    stop("lf_path() has drifted from lf_solve(): ",
         paste(sprintf("%s = %.3e", names(gaps), gaps), collapse = ", "))
  }
  gaps
}

#' One full-sample LF path on a draw at cardinality L.
#'
#' sim_multinomial_phistep.R's path_once(), with `imax` exposed and PHI dropped
#' before return: at imax = 32,214 the matrix is 15 MB per path and only its two
#' contractions against the truth are ever used.
#'
#' @param d list. One mdgp_draw().
#' @param L integer. Cardinality.
#' @param imax integer. Iterations.
#' @return list: b, ise, ratio, err, noise, cste, L.
path_once <- function(d, L, imax) {
  w <- mdgp_inst(d, L)
  n <- length(w)
  xev <- seq(stats::quantile(c(d$x1, d$x2), 0.05),
             stats::quantile(c(d$x1, d$x2), 0.95), length.out = 60L)
  op <- make_operator(d$x1, d$x2, xev)
  cells <- sort(unique(as.integer(w)))
  fit_idx <- sample(seq_len(n), floor(n / 2))
  R <- fit_propensity_multi(w, d$Z, fit_idx, seq_len(n), eps = EPS_RHO,
                            cells = cells)
  attr(R, "prop_diag") <- NULL
  rho <- if (length(cells) == 2L) as.vector(R) else R
  bier <- make_bierens(d$Z, n_t = N_T, seed = 20260805L, scale = T_SCALE)
  init <- init_control(d$y, d$x1, d$x2, d$Z, w, op)
  p <- lf_path(d$y, d$x1, d$x2, d$Z, w, op, init, rho = rho, bier = bier,
               adj_wtil = TRUE, cste = NULL, imax = imax)
  phi0 <- MDGP_PHI(xev); phi0 <- phi0 - mean(phi0)
  list(b     = as.vector(p$PHI %*% phi0) / sum(phi0^2),
       ise   = rowMeans(sweep(p$PHI, 2L, phi0, "-")^2),
       ratio = p$err / p$noise,
       err   = p$err, noise = p$noise, cste = p$cste, L = length(cells))
}

#' One replication: one draw, all requested cardinalities, PAIRED.
#'
#' rep_one() of the parent study, with the L grid and imax exposed.  The anchor
#' is restored before each L so the propensity's fit split and operator_norm2()'s
#' start vector are common across cardinalities.
#'
#' @param j integer. Replication index within the cell.
#' @param n integer. Sample size.
#' @param spec list. One MDGP_SPEC element.
#' @param off integer. Stream offset for the cell.
#' @param lgrid integer vector. Cardinalities.
#' @param imax integer. Iterations.
#' @return named list of path_once() results, one per cardinality.
rep_one <- function(j, n, spec, off, lgrid, imax) {
  assign(".Random.seed", streams[[off + j]], envir = globalenv())
  d <- mdgp_draw(n, spec)
  anchor <- get(".Random.seed", envir = globalenv())
  out <- vector("list", length(lgrid))                                # INV-17
  names(out) <- as.character(lgrid)
  for (i in seq_along(lgrid)) {
    assign(".Random.seed", anchor, envir = globalenv())
    out[[i]] <- tryCatch(path_once(d, lgrid[i], imax), error = \(e) NULL)
  }
  out
}

## The parent study's cell order, which fixes the stream offsets.  Reproduced,
## not guessed: expand.grid(dgp = D, n = N) varies dgp fastest, and the offset is
## (row - 1) * B_REP with B_REP = 24.
PARENT_D <- c("balanced", "skewed", "misspec")
PARENT_N <- c(400L, 800L, 1600L)
PARENT_B <- 24L
parent_cells <- expand.grid(dgp = PARENT_D, n = PARENT_N,
                            stringsAsFactors = FALSE)

#' Stream offset of a (design, n) cell in the parent study's numbering.
#'
#' @param dgp character(1); @param n integer(1).
#' @return integer(1).
stream_off <- function(dgp, n) {
  k <- which(parent_cells$dgp == dgp & parent_cells$n == n)
  stopifnot(length(k) == 1L)
  (k - 1L) * PARENT_B
}

message("== loop fidelity: lf_path() against lf_solve() ==")
fid <- check_loop_fidelity()
message(sprintf("  max gap %.1e on err / noise / phi -- IDENTICAL",
                max(fid)))

# ============================================================================
# STAGE 1  --  B = 24, imax = 4,000
# ============================================================================

CK1 <- file.path(OUT, "probe_mbar_stage1_ckpt.rds")
CFG1 <- list(stage = 1L, imax = IMAX_S1, b = B_S1, n = N_SIM, L = L_GRID,
             d = D_GRID, eps = EPS_RHO, n_t = N_T, t_scale = T_SCALE,
             seed = 20260814L,
             src = unname(tools::md5sum(here::here(
               "scripts", "R", c("lf_panel.R", "orthogonal_theta.R")))),
             dgp = unname(tools::md5sum(here::here(
               "scripts", "simulations", "sim_multinomial_dgp.R"))),
             driver = c(paste(deparse(lf_path), collapse = "\n"),
                        paste(deparse(path_once), collapse = "\n"),
                        paste(deparse(rep_one), collapse = "\n")))

S1 <- vector("list", length(D_GRID))                                  # INV-17
names(S1) <- D_GRID
if (file.exists(CK1)) {
  old <- readRDS(CK1)
  if (identical(old$cfg, CFG1)) {
    for (k in intersect(names(old$res), names(S1))) S1[[k]] <- old$res[[k]]
    message(sprintf("  stage 1: reusing %d of %d cached cells",
                    sum(!vapply(S1, is.null, logical(1))), length(S1)))
  } else {
    message("  stage 1: cache discarded, configuration changed")
  }
}

for (dd in D_GRID) {
  if (!is.null(S1[[dd]])) next
  t0 <- Sys.time()
  message(sprintf("== stage 1: %s, n = %d, B = %d, imax = %d ==",
                  dd, N_SIM, B_S1, IMAX_S1))
  raw <- parallel::mclapply(seq_len(B_S1), rep_one, n = N_SIM,
                            spec = MDGP_SPEC[[dd]],
                            off = stream_off(dd, N_SIM),
                            lgrid = L_GRID, imax = IMAX_S1,
                            mc.cores = N_CORES, mc.preschedule = FALSE)
  bad <- vapply(raw, \(z) inherits(z, "try-error") || !is.list(z), logical(1))
  if (any(bad)) {
    message(sprintf("  *** %d of %d workers errored ***", sum(bad), B_S1))
    raw <- raw[!bad]
  }
  S1[[dd]] <- raw
  tmp <- paste0(CK1, ".tmp")
  saveRDS(list(cfg = CFG1, res = S1), tmp)
  file.rename(tmp, CK1)
  message(sprintf("  %-9s %2d/%2d paths in %5.1f min", dd, length(raw), B_S1,
                  as.numeric(difftime(Sys.time(), t0, units = "mins"))))
}

# ---- SELF-CHECK against the shipped study, m <= 100 ------------------------

CKPT_PARENT <- here::here("quality_reports", "sim",
                          "sim_multinomial_phistep_ckpt.rds")
if (file.exists(CKPT_PARENT)) {
  par_ck <- readRDS(CKPT_PARENT)
  gaps <- vector("list", 0L)
  for (dd in D_GRID) {
    ref <- par_ck$res[[sprintf("%s_n%d", dd, N_SIM)]]
    if (is.null(ref)) next
    nb <- min(length(ref), length(S1[[dd]]))
    for (j in seq_len(nb)) for (lab in as.character(L_GRID)) {
      a <- S1[[dd]][[j]][[lab]]; r <- ref[[j]][[lab]]
      if (is.null(a) || is.null(r)) next
      m <- length(r$b)
      gaps[[length(gaps) + 1L]] <- c(
        b = max(abs(a$b[seq_len(m)] - r$b)),
        ise = max(abs(a$ise[seq_len(m)] - r$ise)),
        cste = abs(a$cste - r$cste))
    }
  }
  G <- do.call(rbind, gaps)
  worst <- apply(G, 2, max)
  message(sprintf(
    "\n== self-check against sim_multinomial_phistep_ckpt.rds, m <= 100 ==\n  %d paths compared, max |gap|: b %.2e  ise %.2e  cste %.2e",
    nrow(G), worst[["b"]], worst[["ise"]], worst[["cste"]]))
  if (max(worst) > 0) {
    stop("probe paths differ from the shipped study's at m <= 100; ",
         "the probe is measuring a different estimator.")
  }
  message("  IDENTICAL -- the probe reproduces the shipped paths exactly.")
} else {
  message("\n  parent checkpoint absent; self-check SKIPPED.")
}

# ============================================================================
# STAGE 2  --  B = 6, imax = eq:cap at (n = 400, c_C = 3, c_Phi = 1)
# ============================================================================

CK2 <- file.path(OUT, "probe_mbar_stage2_ckpt.rds")
CFG2 <- CFG1
CFG2$stage <- 2L; CFG2$imax <- IMAX_S2; CFG2$b <- B_S2; CFG2$L <- L_S2

S2 <- vector("list", length(D_GRID))                                  # INV-17
names(S2) <- D_GRID
if (file.exists(CK2)) {
  old <- readRDS(CK2)
  if (identical(old$cfg, CFG2)) {
    for (k in intersect(names(old$res), names(S2))) S2[[k]] <- old$res[[k]]
    message(sprintf("  stage 2: reusing %d of %d cached cells",
                    sum(!vapply(S2, is.null, logical(1))), length(S2)))
  }
}

for (dd in D_GRID) {
  if (!is.null(S2[[dd]])) next
  t0 <- Sys.time()
  message(sprintf("== stage 2: %s, n = %d, B = %d, imax = %d (eq:cap) ==",
                  dd, N_SIM, B_S2, IMAX_S2))
  raw <- parallel::mclapply(seq_len(B_S2), rep_one, n = N_SIM,
                            spec = MDGP_SPEC[[dd]],
                            off = stream_off(dd, N_SIM),
                            lgrid = L_S2, imax = IMAX_S2,
                            mc.cores = N_CORES, mc.preschedule = FALSE)
  bad <- vapply(raw, \(z) inherits(z, "try-error") || !is.list(z), logical(1))
  if (any(bad)) {
    message(sprintf("  *** %d of %d workers errored ***", sum(bad), B_S2))
    raw <- raw[!bad]
  }
  S2[[dd]] <- raw
  tmp <- paste0(CK2, ".tmp")
  saveRDS(list(cfg = CFG2, res = S2), tmp)
  file.rename(tmp, CK2)
  message(sprintf("  %-9s %2d/%2d paths in %5.1f min", dd, length(raw), B_S2,
                  as.numeric(difftime(Sys.time(), t0, units = "mins"))))
}

# ============================================================================
# COLLAPSE AND REPORT
# ============================================================================

#' Mean and Monte Carlo standard error of a statistic at a set of indices.
#'
#' @param res list of replications, each a named list by cardinality.
#' @param lab character(1). Cardinality label.
#' @param field character(1). "b" or "ise".
#' @param at integer vector. Iteration indices.
#' @return data.frame: m, mean, mcse, n_path.
summarise_at <- function(res, lab, field, at) {
  v <- lapply(res, \(z) if (is.null(z[[lab]])) NULL else z[[lab]][[field]])
  v <- v[!vapply(v, is.null, logical(1))]
  if (!length(v)) return(NULL)
  M <- do.call(rbind, lapply(v, \(x) x[at]))
  data.frame(m = at, mean = colMeans(M),
             mcse = apply(M, 2, stats::sd) / sqrt(nrow(M)),
             n_path = nrow(M))
}

rep_m <- REPORT_M[REPORT_M <= IMAX_S1]
tab1 <- vector("list", 0L)
for (dd in D_GRID) for (lab in as.character(L_GRID)) {
  for (fld in c("b", "ise")) {
    s <- summarise_at(S1[[dd]], lab, fld, rep_m)
    if (is.null(s)) next
    s$dgp <- dd; s$L <- as.integer(lab); s$stat <- fld
    tab1[[length(tab1) + 1L]] <- s
  }
}
TAB1 <- do.call(rbind, tab1)

tab2 <- vector("list", 0L)
for (dd in D_GRID) for (lab in as.character(L_S2)) {
  for (fld in c("b", "ise")) {
    s <- summarise_at(S2[[dd]], lab, fld, IMAX_S2)
    if (is.null(s)) next
    s$dgp <- dd; s$L <- as.integer(lab); s$stat <- fld
    tab2[[length(tab2) + 1L]] <- s
  }
}
TAB2 <- do.call(rbind, tab2)

#' Print one statistic as caps-in-rows, (design, L) in columns.
#'
#' @param tab data.frame from the collapse above.
#' @param fld character(1). "b" or "ise".
#' @return invisible NULL; prints.
print_panel <- function(tab, fld) {
  s <- tab[tab$stat == fld, ]
  key <- paste0(substr(s$dgp, 1, 4), ".L", s$L)
  w <- stats::reshape(data.frame(m = s$m, key = key, v = s$mean),
                      idvar = "m", timevar = "key", direction = "wide")
  names(w) <- sub("^v\\.", "", names(w))
  w <- w[order(w$m), ]
  cat(sprintf("\n-- %s, mean over paths --\n", toupper(fld)))
  print(w, row.names = FALSE, digits = 4)
  invisible(NULL)
}

cat("\n\n===========================================================\n")
cat("STAGE 1 -- B = ", B_S1, ", imax = ", IMAX_S1, ", n = ", N_SIM, "\n",
    sep = "")
cat("===========================================================\n")
print_panel(TAB1, "b")
print_panel(TAB1, "ise")

cat("\n\n===========================================================\n")
cat("STAGE 2 -- AT eq:cap, m-bar = ", IMAX_S2, ", B = ", B_S2, "\n", sep = "")
cat("===========================================================\n\n")
print(TAB2[order(TAB2$stat, TAB2$dgp, TAB2$L),
           c("stat", "dgp", "L", "m", "mean", "mcse", "n_path")],
      row.names = FALSE, digits = 4)

## The ratio ||T-hat_m|| / delta-hat_n at the caps of interest: whether the
## discrepancy the corpus's stop would test is anywhere near its level.
rat <- vector("list", 0L)
for (dd in D_GRID) for (lab in as.character(L_GRID)) {
  s <- summarise_at(S1[[dd]], lab, "ratio", rep_m)
  if (is.null(s)) next
  s$dgp <- dd; s$L <- as.integer(lab); s$stat <- "ratio"
  rat[[length(rat) + 1L]] <- s
}
RAT <- do.call(rbind, rat)
cat("\n")
print_panel(RAT, "ratio")

saveRDS(list(stage1 = S1, stage2 = S2, tab1 = TAB1, tab2 = TAB2, ratio = RAT,
             cfg1 = CFG1, cfg2 = CFG2, report_m = rep_m, imax_s2 = IMAX_S2),
        file.path(OUT, "probe_mbar_ladder.rds"))
cat("\nwrote ", file.path(OUT, "probe_mbar_ladder.rds"), "\n", sep = "")
