# ============================================================================
# sim_thm_rootn_l2identity.R
#
# THE BINARY-IDENTITY CERTIFICATE for the cardinality generalisation of
# 2026-08-14 (design decision D8 in sim_thm_rootn_dgp.R).
#
# WHAT IT CERTIFIES, AND WHY IT IS THE RIGHT THING TO CERTIFY
#
# sim_thm_rootn_dgp.R and sim_thm_rootn_nuisance.R are sourced by FIVE arms --
# budget, jacobian, phi-step, headroom and limit-law -- whose tables are in the
# manuscript. Making the instrument's cardinality a parameter touches every
# object those arms consume. The bar the change has to clear is that the BINARY
# path does not move: sans-L = 2 must reproduce the shipped numbers bit for bit,
# because that is what makes a sans-L = 4 column readable as a cardinality
# contrast rather than as a code change.
#
# Re-running all five arms would demonstrate that on 5 tables at a cost of about
# seven hours. This script demonstrates it on the OBJECTS the arms are functions
# of, exactly, in under a minute, and it covers arms this change would otherwise
# only be able to argue about:
#
#   * the population layer -- solve_ell_star, pop_J_Sigma, ell_pert_norms,
#     dgp_validate -- which is deterministic under with_fixed_seed() and whose
#     output IS the shipped design-validity table;
#   * the replication layer -- dgp_draw, draw_h, draw_dell, eval_dell, eval_dL,
#     draw_rhat -- compared under a common RNG state, so a change in either the
#     VALUES or the RNG CONSUMPTION is caught;
#   * one_rep_full() itself, lifted from sim_thm_rootn_limitlaw.R into both
#     environments and run from the same seed, which is the whole limit-law arm
#     replication in one call;
#   * the HEADROOM design path, whose specs (hr_dgp_spec, d_Z = 1) never went
#     through dgp_spec() and therefore declare no cardinality at all -- the case
#     the spec_L / spec_gmat / spec_shift accessors exist for.
#
# Everything is compared with identical(), not all.equal(): a tolerance would
# defeat the purpose. identical() on doubles is bit equality, and it also
# catches a storage-mode change (an integer column becoming double).
#
# WHAT IT DOES NOT CERTIFY. That the sans-L >= 3 path is correct -- that is what
# sim_thm_rootn_cardinality.R's design-validity block measures. And it does not
# license re-stamping any checkpoint fingerprint: the fingerprints are byte
# guards on the SOURCES and they are right to fire here, since the sources did
# change. A checkpointed arm re-run after this change starts from zero and must
# reproduce its tables; this certificate is why that is expected rather than
# hoped for.
#
# Outputs
#   paper/tables/sim/sim_thm_rootn_l2identity.tex   (bare tabular, INV-13)
#   quality_reports/sim/sim_thm_rootn_l2identity.rds
#   exit status 1 if any check fails, so a driver cannot walk past it
#
#   Rscript scripts/simulations/sim_thm_rootn_l2identity.R
# ============================================================================

library(here)                                                    # INV-15
library(data.table)

# INV-14, and the one place in this project where the rule is read in its own
# terms rather than literally. The rule exists so that a stochastic RESULT is
# reproducible from one declared seed. This script produces no stochastic result:
# it runs the SAME computation under two source states and asks whether the two
# agree bit for bit, which requires putting both at an IDENTICAL RNG state
# immediately before each call. cmp() therefore re-seeds before every one of its
# two calls, from the constants declared here and nowhere else, and no draw made
# below reaches any table. The seed at the top is what every one of those resets
# is derived from.
set.seed(20260814L)                                              # INV-14
CMP_SEED  <- 4242L
CARD_SEED <- 555L
PROJ_SEED <- 99L
CONT_SEED <- 100L

SRC_DIR  <- here::here("scripts", "simulations")
BASE_DIR <- file.path(SRC_DIR, "baseline", "pre_cardinality_20260814")

# The certified pre-cardinality digests. These are the files the shipped tables
# were produced under; ckpt_restamp's own DIGEST table records the same two
# values as the certified post-repair state of 2026-08-03.
BASE_MD5 <- c(sim_thm_rootn_dgp.R      = "9efafa44900e16a3daae6855725ee580",
              sim_thm_rootn_nuisance.R = "af838f55da7597411a164eabc7b5d824")

stopifnot(dir.exists(BASE_DIR))
have <- tools::md5sum(file.path(BASE_DIR, names(BASE_MD5)))
if (!identical(unname(have), unname(BASE_MD5))) {
  stop("baseline sources are not the certified pre-cardinality state; ",
       "this certificate does not apply")
}

# ---- Load the two source states into separate environments -----------------

load_state <- function(dir) {
  e <- new.env(parent = globalenv())
  sys.source(file.path(dir, "sim_thm_rootn_dgp.R"), envir = e)
  sys.source(file.path(dir, "sim_thm_rootn_nuisance.R"), envir = e)
  # one_rep_full is defined in the limit-law arm; lift the definition without
  # running the arm, into whichever source state we are testing.
  ex <- parse(file.path(SRC_DIR, "sim_thm_rootn_limitlaw.R"))
  want <- c("one_rep_full", "ALPHA_LV", "Q_PROBS", "THETA_MIX")
  for (s in ex) {
    if (is.call(s) && identical(as.character(s[[1L]]), "<-") &&
        is.name(s[[2L]]) && as.character(s[[2L]]) %in% want) eval(s, e)
  }
  stopifnot(all(want %in% ls(e)))
  e
}

OLD <- load_state(BASE_DIR)
NEW <- load_state(SRC_DIR)

# ---- Comparison harness ----------------------------------------------------

RES <- new.env(parent = emptyenv())
RES$rows <- vector("list", 64L)                                  # INV-17
RES$k <- 0L

#' Evaluate the same expression in both states from the same RNG state and
#' record whether the results are identical().
#'
#' @param label what is being compared, as it appears in the table.
#' @param group which layer it belongs to.
#' @param f function of one argument, the source-state environment.
#' @param seed integer seed set immediately before EACH call, so that a
#'   difference in RNG consumption shows up as a difference in the result.
cmp <- function(label, group, f, seed = CMP_SEED) {
  set.seed(seed); a <- f(OLD)
  set.seed(seed); b <- f(NEW)
  ok <- identical(a, b)
  RES$k <- RES$k + 1L
  RES$rows[[RES$k]] <- data.table(group = group, label = label, ok = ok,
                                  n_elem = length(unlist(a, use.names = FALSE)))
  if (!ok) message("  MISMATCH: ", label)
  invisible(ok)
}

# ---- Layer 1: rate symbols and configuration -------------------------------

NGRID <- c(125L, 354L, 1000L, 2828L, 8000L, 22627L, 64000L, 181019L)

cmp("CFG", "config", function(e) e$CFG)
cmp("EPS_EXPONENT, SIM_CORES, H_MODES", "config",
    function(e) list(e$EPS_EXPONENT, e$SIM_CORES, e$H_MODES))
cmp("rate_delta_hat / rate_rn / rate_delta_n / rate_eps_n on the grid", "config",
    function(e) list(e$rate_delta_hat(NGRID), e$rate_rn(NGRID),
                     e$rate_delta_n(NGRID), e$rate_eps_n(NGRID)))
cmp("band_hu / band_hx / cap_mbar / cap_mbar_old on the grid", "config",
    function(e) list(e$band_hu(NGRID, 1.03), e$band_hx(NGRID),
                     e$cap_mbar(100, NGRID), e$cap_mbar_old(NGRID)))
cmp("h_basis, h_basis_freqs", "config",
    function(e) list(e$h_basis(seq(0, 1, length.out = 51L)), e$h_basis_freqs()))

# ---- Layer 2: the shipped DGP specs and the population objects -------------

for (nm in c("A", "B")) {
  cmp(sprintf("dgp_spec(\"%s\") shipped primitives", nm), "population",
      function(e) {
        s <- e$dgp_spec(nm)
        s[setdiff(names(s), c("L_cells", "gamma_mat", "shift"))]
      })
  cmp(sprintf("varrho_fun, DGP-%s", nm), "population",
      function(e) e$varrho_fun(matrix(seq(-3, 3, length.out = 300L), 100L, 3L),
                               e$dgp_spec(nm)))
  cmp(sprintf("dgp_draw(20000), DGP-%s", nm), "replication",
      function(e) e$dgp_draw(20000L, e$dgp_spec(nm)))
  cmp(sprintf("solve_ell_star, DGP-%s", nm), "population",
      function(e) {
        es <- e$solve_ell_star(e$dgp_spec(nm))
        list(es$coef, es$l2_resid, es$l2_rhs, es$rel_resid, es$n_modes,
             es$Q, es$c_u, es$u_range,
             vapply(es$anti_fun, function(f) f(seq(-4, 4, length.out = 97L)),
                    numeric(97L)))
      })
  cmp(sprintf("pop_J_Sigma (4e6 pilot), DGP-%s", nm), "population",
      function(e) {
        s <- e$dgp_spec(nm)
        e$pop_J_Sigma(s, e$solve_ell_star(s), n_pilot = 4e6L)
      })
  cmp(sprintf("ell_pert_norms, DGP-%s", nm), "population",
      function(e) {
        s <- e$dgp_spec(nm)
        e$ell_pert_norms(s, e$solve_ell_star(s))
      })
  cmp(sprintf("dgp_validate shipped fields, DGP-%s", nm), "population",
      function(e) {
        s  <- e$dgp_spec(nm)
        es <- e$solve_ell_star(s)
        v  <- e$dgp_validate(s, es, e$pop_J_Sigma(s, es, n_pilot = 4e6L))
        v[c("balancing_rel_resid", "mean_psi", "mean_psi_se", "E_dz_du",
            "kappa_J", "min_varrho", "max_varrho", "E_du4", "E_dznorm4",
            "sd_du", "ell_sup")]
      })
}

# ---- Layer 3: the injected nuisances ---------------------------------------

cmp("draw_h, both modes and three bias fractions", "replication",
    function(e) lapply(c(0, 0.5, 1), function(bf)
      lapply(c("smooth", "rough"), function(md)
        e$draw_h(0.05, mode = md, bias_frac = bf))))

cmp("draw_dell / eval_dell / eval_dL, DGP-A", "replication",
    function(e) {
      s  <- e$dgp_spec("A")
      es <- e$solve_ell_star(s)
      pn <- e$ell_pert_norms(s, es)
      d  <- e$dgp_draw(5000L, s)
      cf <- e$draw_dell(0.02, s, es, pn)
      list(cf, e$eval_dell(cf, d$du, d$zc, s, es),
           e$eval_dL(cf, d$du, d$zc, s, es))
    })

cmp("draw_rhat, DGP-A and DGP-B", "replication",
    function(e) lapply(c("A", "B"), function(nm) {
      s <- e$dgp_spec(nm)
      d <- e$dgp_draw(5000L, s)
      e$draw_rhat(0.05, d$zc, s)
    }))

# ---- Layer 4: one_rep_full, the limit-law arm's whole replication -----------

for (nm in c("A", "B")) {
  for (cd in c(0.25, 1.00)) {
    cmp(sprintf("one_rep_full x5, DGP-%s, c_delta = %.2f", nm, cd),
        "replication",
        function(e) {
          s  <- e$dgp_spec(nm)
          es <- e$solve_ell_star(s)
          pn <- e$ell_pert_norms(s, es)
          pop <- e$pop_J_Sigma(s, es, n_pilot = 5e5L)
          lapply(1:5, function(b)
            e$one_rep_full(2000L, s, es, pop, pn, cd, 1, 1, "smooth", 0))
        })
  }
}

# ---- Layer 5: the headroom path, whose specs declare no cardinality ---------
#
# hr_dgp_spec builds a d_Z = 1 spec locally and never calls dgp_spec, so it
# carries no L_cells, no gamma_mat and no shift. It nevertheless consumes the
# SHARED varrho_fun, cond_dens_x, cond_dens_x_marg, ell_star_eval, L_star_eval,
# draw_dell, pop_J_Sigma and dgp_validate. This is the accessors' test.

# The overrides are installed INTO the state environment, not into a child of
# it, because that is what sim_thm_rootn_headroom.R:98-100 does: it source()s
# into the global environment, which is also the enclosure of the shared
# functions, so dgp_validate() and pop_J_Sigma() see hr_dgp_draw. A child
# environment would give the shared functions the wrong dgp_draw and would test
# a configuration the arm never runs. This layer therefore runs LAST.
load_hr <- function(e) {
  sys.source(file.path(SRC_DIR, "sim_thm_rootn_headroom_dgp.R"), envir = e)
  e$dgp_draw       <- e$hr_dgp_draw
  e$solve_ell_star <- e$hr_solve_ell_star
  e$draw_rhat      <- e$hr_draw_rhat
  e
}
invisible(lapply(list(OLD, NEW), load_hr))

for (nm in c("HA", "HB")) {
  cmp(sprintf("headroom varrho_fun / cond_dens_x, %s", nm), "headroom",
      function(e) {
        s  <- e$hr_dgp_spec(nm)
        zc <- matrix(seq(-2, 3, length.out = 200L), 200L, 1L)
        xg <- seq(0.01, 0.99, length.out = 61L)
        list(e$varrho_fun(zc, s),
             e$cond_dens_x(xg, 2L, 1L, 1, seq(-2, 2, length.out = 11L), s),
             e$cond_dens_x_marg(xg, 2L, 1L, s),
             e$cond_dens_x_marg(xg, 1L, 0L, s))
      })
  cmp(sprintf("headroom hr_dgp_draw / hr_solve_ell_star / evals, %s", nm),
      "headroom",
      function(e) {
        s  <- e$hr_dgp_spec(nm)
        es <- e$hr_solve_ell_star(s)
        d  <- e$hr_dgp_draw(4000L, s)
        list(es$coef, es$rel_resid, d,
             e$ell_star_eval(es, d$du, d$zc, s),
             e$L_star_eval(es, d$du, d$zc, s),
             e$hr_draw_rhat(0.05, d$zc, s))
      })
  cmp(sprintf("headroom pop_J_Sigma / dgp_validate, %s", nm), "headroom",
      function(e) {
        s   <- e$hr_dgp_spec(nm)
        es  <- e$hr_solve_ell_star(s)
        pop <- e$pop_J_Sigma(s, es, n_pilot = 5e5L)
        v   <- e$dgp_validate(s, es, pop, n_check = 5e4L)
        list(pop, v[c("balancing_rel_resid", "mean_psi", "E_dz_du", "kappa_J",
                      "min_varrho", "max_varrho", "E_du4", "sd_du", "ell_sup")])
      })
}

# ---- Layer 6: the general branches agree with the binary closed forms -------
#
# Two places carry an explicit sans-L = 2 closed form -- the metric projection
# onto eq:trunset (a clamp in dimension one) and contract_w (an elementwise
# product when Wtilde is a scalar). The closed forms are what ship, for exactness;
# these checks are what says they are the general construction and not an
# exception to it. Agreement is to machine precision, NOT bit equality, because
# the general algorithm reaches the same point by a different arithmetic route --
# which is exactly why the closed form is the one that ships.

set.seed(PROJ_SEED)
qv <- matrix(runif(4000L, -0.4, 1.4), 4000L, 1L)
# The general branch's body, run at ONE contrast -- i.e. with the sans-L = 2
# short circuit removed. A padded two-column problem would NOT be the same test:
# at Lc = 3 the base cell's own floor makes the budget q_1 + q_2 <= 1 - eps, so
# a slack second column of eps caps q_1 at 1 - 2 eps rather than 1 - eps. The
# constraint sets genuinely differ across cardinalities, which is the point.
proj_general <- function(q, eps) {
  nL1 <- ncol(q)
  a   <- pmax(q, eps)
  bad <- rowSums(a) > 1 - eps
  if (any(bad)) {
    a[bad, ] <- eps + NEW$proj_simplex_rows(q[bad, , drop = FALSE] - eps,
                                            1 - (nL1 + 1L) * eps)
  }
  a
}
proj_gap <- max(abs(proj_general(qv, 0.10) - pmin(pmax(qv, 0.10), 0.90)))

set.seed(CONT_SEED)
Amat <- matrix(rnorm(500L * 4L), 500L, 4L)
wvec <- rnorm(500L)
Aarr <- array(0, c(500L, 4L, 1L)); Aarr[, , 1L] <- Amat
contract_gap <- max(abs(NEW$contract_w(Aarr, matrix(wvec, 500L, 1L)) -
                        NEW$contract_w(Amat, wvec)))

RES$k <- RES$k + 1L
RES$rows[[RES$k]] <- data.table(
  group = "closed form", label = "eq:trunset projection vs the binary clamp",
  ok = proj_gap < 1e-15, n_elem = 4000L)
RES$k <- RES$k + 1L
RES$rows[[RES$k]] <- data.table(
  group = "closed form", label = "contract\\_w: 1-slice array vs scalar product",
  ok = contract_gap == 0, n_elem = 2000L)

# ---- Layer 7: one_rep_card is one_rep_full at sans-L = 2 -------------------
#
# sim_thm_rootn_cardinality.R carries its own replication, one_rep_card(), which
# differs from the limit-law arm's one_rep_full() only at the three points where
# the contrast index is summed out. The header of that file CLAIMS the two agree
# bit for bit at sans-L = 2; this is the check behind the claim, so the claim is
# machine-verified rather than asserted. Both are run in the CURRENT source
# state, from a common RNG state, on the spec dgp_spec("A") returns by default.

CARD <- new.env(parent = NEW)
local({
  ex <- parse(file.path(SRC_DIR, "sim_thm_rootn_cardinality.R"))
  for (s in ex) {
    if (is.call(s) && identical(as.character(s[[1L]]), "<-") &&
        is.name(s[[2L]]) && as.character(s[[2L]]) == "one_rep_card") eval(s, CARD)
  }
})
stopifnot(exists("one_rep_card", envir = CARD, inherits = FALSE))

local({
  s   <- NEW$dgp_spec("A")
  es  <- NEW$solve_ell_star(s)
  pn  <- NEW$ell_pert_norms(s, es)
  pop <- NEW$pop_J_Sigma(s, es, n_pilot = 5e5L)
  for (cd in c(0.25, 1.00)) {
    set.seed(CARD_SEED)
    a <- lapply(1:5, function(b)
      NEW$one_rep_full(2000L, s, es, pop, pn, cd, 1, 1, "smooth", 0))
    set.seed(CARD_SEED)
    b <- lapply(1:5, function(k)
      CARD$one_rep_card(2000L, s, es, pop, pn, cd, 1, 1, "smooth", 0))
    ok <- identical(a, b)
    RES$k <- RES$k + 1L
    RES$rows[[RES$k]] <- data.table(
      group = "provenance",
      label = sprintf("one\\_rep\\_card vs one\\_rep\\_full, $c_\\delta=%.2f$", cd),
      ok = ok, n_elem = length(unlist(a)))
    if (!ok) message("  MISMATCH: one_rep_card vs one_rep_full at c_delta = ", cd)
  }
})

# ---- Report ----------------------------------------------------------------

TAB <- rbindlist(RES$rows[seq_len(RES$k)])
n_ok <- sum(TAB$ok)
message(sprintf("\n%d of %d checks identical()", n_ok, nrow(TAB)))
print(TAB[order(group, label)], nrows = 100L)
message(sprintf("eq:trunset projection vs clamp, max |gap| = %.3g", proj_gap))
message(sprintf("contract_w consistency,        max |gap| = %.3g", contract_gap))

saveRDS(list(table = TAB, proj_gap = proj_gap, contract_gap = contract_gap,
             baseline_md5 = BASE_MD5,
             current_md5 = unname(tools::md5sum(
               file.path(SRC_DIR, names(BASE_MD5))))),
        here::here("quality_reports", "sim", "sim_thm_rootn_l2identity.rds"))

grp <- TAB[, .(n = .N, ok = sum(ok)), by = group]
writeLines(c(
  "\\begin{tabular}{lrrl}", "\\toprule",
  "Layer & Checks & Bit-identical & Objects compared \\\\",
  "\\midrule",
  sprintf("%s & %d & %d & %s \\\\", grp$group, grp$n, grp$ok,
          c("config"      = "$\\mathrm{CFG}$, every rate and bandwidth symbol on the eight-point grid",
            "headroom"    = "$d_Z=1$ specs, which declare no cardinality at all",
            "population"  = "$\\ell_\\star$, $J$, $\\Sigma$, perturbation norms, design validity",
            "replication" = "$\\Delta$-draws, injected $h$, $\\hat\\ell$, $\\hat\\varrho$, \\texttt{one\\_rep\\_full}",
            "provenance"  = "the cardinality arm's replication against the limit-law arm's",
            "closed form" = "binary closed forms against the general algorithms")[grp$group]),
  "\\midrule",
  sprintf("Total & %d & %d & \\\\", nrow(TAB), n_ok),
  "\\bottomrule", "\\end{tabular}"),
  here::here("paper", "tables", "sim", "sim_thm_rootn_l2identity.tex"))

if (n_ok < nrow(TAB)) {
  print(TAB[ok == FALSE])
  stop("BINARY IDENTITY FAILED: the cardinality change moves the sans-L = 2 path")
}
message("done: binary-identity certificate clean")
