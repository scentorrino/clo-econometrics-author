# ============================================================================
# sim_thm_rootn_bdrylayer.R
#
# THE ACCEPTANCE TEST FOR D11a AND D11b, AND IT IS NOT THE MOMENTS.
#
# On 2026-08-15 this file MEASURED a defect. It now measures whether the repair
# took. The question it answers is narrow and it is a hypothesis test in the
# logical sense, not the statistical one:
#
#   (P-g) -- prp:phirate's hypothesis  R h_x^{s-1/2} = O(h_u delta-hat_n),
#   imported into thm:rootn by group (T-5) -- either holds along the sample-size
#   grid or it does not. Under the state this arm shipped through 2026-08-15 it
#   did NOT: the realised ratio sup_X |varphi_{h_x} - vdagger| / (h_u
#   delta-hat_n) CLIMBED monotonically across n = 125 ... 181,019, at +0.127 per
#   ln n. AFTER the repair the sequence must be FLAT OR FALLING in n. A ratio
#   that is merely smaller but still climbing has not fixed anything, and the
#   whole design of this file is built around not being able to confuse the two.
#
# ---------------------------------------------------------------------------
# WHERE THE DEFECT IS PRICED, AND WHY THE REMAINDER BUDGET IS THE WRONG RULER
#
# THE TRAP THIS PROJECT ALREADY FELL INTO ONCE. The sans-L = 4 episode cost two
# days because every comparison was made against the remainder budget when the
# failing object was A HYPOTHESIS, not a remainder: T_2 is DELETED by N1 at
# lem:biasexp Step 2(c), so it was never budgeted, and "small relative to
# budget" was an answer to a question nobody had asked. The same trap is what
# design decision D11's closing sentence fell into -- "this affects the
# phi-step's bias constant and nothing in the stopping or conditioning questions
# this arm is run to answer" -- and it is why the defect survived three rounds of
# review inside the arm that was carrying it.
#
# THE j >= 1 TRUNCATED MOMENTS ARE CONSUMED AT EXACTLY ONE LIVE SITE,
# proofs.tex:7976-8057, the Taylor route to eq:xsmoothbias:
#
#     sup_x | varphi_{h_x}(x) - varphi(x) |  <=  c_12 R h_x^{s - 1/2},
#
# whose derivation kills the terms 1 <= j <= k = floor(s - 1/2) using
# int varsigma^j Theta_I = 0. At the admissible s = 3 that is j = 1, 2. D11
# enforced j = 0 ONLY, so the j = 1 term survived and the display degraded from
# h_x^{2.5} to h_x^{1}. It is a SUP-NORM statement, so averaging over dx does not
# rescue it. (The other consumer of j >= 1, lem:aerr Step 2, is defused:
# results_supp.tex records lem:aerr as consumed by no result.) proofs.tex:8017
# then states where the degraded display is charged, and the list is closed:
#
#     "eq:xsmoothbias feeds (P-g) and (N1) and nothing else."
#
# So this file does NOT report the defect as a fraction of sqrt(n) delta_n^2. It
# reports it against (P-g)'s own two sides, and it reports the EXPONENT of the
# ratio in n, because (P-g) is an order statement and a finite-n ratio only
# locates the constant.
#
# ---------------------------------------------------------------------------
# WHAT IS MEASURED, IN THE ORDER IT HAS TO BE SETTLED
#
#  (1) ARCHITECTURE. Which scripts of the suite construct an x-smoother at all,
#      and which shipped tables are downstream of one. A mechanical audit of the
#      files, not an opinion, and it is what bounds the blast radius of D11a.
#  (2) IS THE BOUNDARY LAYER POPULATED, at the OLD and the NEW bandwidth? The
#      fraction of design mass within 3 h_x of an endpoint of X = [0, 1]. This is
#      why the defect had teeth: at n^{-0.20} the layer is 100 per cent of the
#      design, so there is no interior to hide in.
#  (3) THE TRUNCATED MOMENTS, D11's renormalisation against the C3 family, each
#      on ITS OWN shipped quadrature -- which is the honest comparison, because
#      the rule is part of what changed (D11b).
#  (4) THE eq:xsmoothbias EXPONENT, fitted on a common reference quadrature so
#      that the slope is the KERNEL's and not the grid's.
#  (5) (P-g) ACROSS THE FULL GRID, before and after, with the slope in ln n and
#      TWO standard errors for it -- see the note at pg_slope().
#  (6) THE CAP DECOMPOSITION, from the constants alone, so that it can be checked
#      against the phi-step arm's Panel C', which computes it from realised
#      omega_n. Two independent routes to one number.
#
# ---------------------------------------------------------------------------
# PROVENANCE, AND THE ONE PLACE IT CANNOT BE VERBATIM
#
# The NEW configuration is EXTRACTED VERBATIM from sim_thm_rootn_phistep.R by
# anchored text match and eval()ed, not retyped; the extraction raises if any
# anchor moves. The OLD configuration cannot be, because it is no longer in that
# file -- it is history. It is therefore reconstructed in the LEGACY block below,
# which is frozen, will never change again, and is PINNED BY REGRESSION
# ASSERTION to the figures the 2026-08-15 measurement recorded. If the
# reconstruction drifts from what was actually measured, this script stops.
#
# Outputs
#   paper/tables/sim/sim_thm_rootn_bdrylayer.tex   (bare tabular, INV-13)
#   quality_reports/sim/sim_thm_rootn_bdrylayer.rds
#
#   Rscript scripts/simulations/sim_thm_rootn_bdrylayer.R    (~80 min, 1 core)
#
# THE "~12 min" THIS LINE CARRIED WAS A 2026-08-15 FIGURE AND D11c INVALIDATED
# IT. Profiled 2026-08-19 at 4,800 s, of which section 5 is 4,560 s and the
# n = 181,019 cell of the "new" configuration alone is about 29 min: the shipped
# x-grid became n-dependent, so the replication loop's cost went from
# 2 n N_XGRID with N_XGRID fixed at 961 to 2 n nx_for(n), which is n^{1.4}.
# THE ARM WRITES ONLY AT THE END, so a stop costs the whole run; budget for it.
# ============================================================================

library(here)                                                    # INV-15
library(data.table)
library(splines)

source(here::here("scripts", "simulations", "sim_thm_rootn_dgp.R"))

set.seed(20260816L)                                              # INV-14

PHISTEP_FILE <- here::here("scripts", "simulations", "sim_thm_rootn_phistep.R")
ENGINE_FILE  <- here::here("scripts", "R", "lf_panel.R")
SELF_FILE    <- here::here("scripts", "simulations", "sim_thm_rootn_bdrylayer.R")

# ---- The stage cache, and why an 80-minute arm needs one -------------------
#
# THIS FILE WRITES ONLY AT THE END, WHICH IS THE RIGHT DESIGN AND THE WRONG
# FAILURE MODE. Section 5 alone is 76 of the 80 minutes and the n = 181,019 cell
# of the "new" configuration is 29 of those, so any interruption -- a shared
# machine reclaimed, a session capped, a laptop asleep -- costs the entire run
# and leaves the shipped .tex and .rds correctly untouched but no further along.
# It has cost two runs already.
#
# The cache is the one this suite already uses: sim_multinomial_phistep.R and
# sim_multinomial_rootn.R both keep a `*_ckpt.rds` beside their output, and
# section 7 below reads those very files to decide whether the general-L arms are
# stale. Same convention, same directory, same suffix.
#
# WHAT MAKES IT INERT, AND IT IS THE SEED AND NOT THE VALUE. Caching a result is
# only safe if the RNG stream resumes where the cached stage left it: sections 2
# and 5 both draw, and section 5's cells draw R_for(n) times each, so a restart
# that replayed the stream from set.seed() would hand cell k a different sample
# than the uncached run did. staged() therefore stores .Random.seed ALONGSIDE the
# value and restores it on a hit, so a resumed run continues from the exact state
# the interrupted one reached and every downstream figure is bit-identical to a
# single-process run. The key is the md5 of this file and of the two files it
# extracts from, so ANY edit to the measurement invalidates the whole cache
# rather than silently mixing vintages.
CKPT     <- here::here("quality_reports", "sim",
                       "sim_thm_rootn_bdrylayer_ckpt.rds")
CKPT_KEY <- paste(unname(tools::md5sum(c(SELF_FILE, PHISTEP_FILE, ENGINE_FILE))),
                  collapse = " ")
.ckpt <- if (file.exists(CKPT)) readRDS(CKPT) else list()
if (!identical(.ckpt$key, CKPT_KEY)) {
  if (length(.ckpt)) message("  [ckpt] key changed -- cache discarded")
  .ckpt <- list(key = CKPT_KEY, stage = list())
}

#' Evaluate `expr` once, or restore it -- together with the RNG state it left.
#'
#' @param tag character(1). Stage name; must be stable across runs.
#' @param expr expression. Evaluated lazily, and NOT at all on a cache hit.
#' @return the stage's value.
staged <- function(tag, expr) {
  hit <- .ckpt$stage[[tag]]
  if (!is.null(hit)) {
    assign(".Random.seed", hit$seed, envir = .GlobalEnv)
    message(sprintf("  [ckpt] restored '%s'", tag))
    return(hit$value)
  }
  v <- expr
  .ckpt$stage[[tag]] <<- list(value = v,
                              seed = get(".Random.seed", envir = .GlobalEnv))
  # Written through a temporary and renamed: a kill DURING the write would
  # otherwise leave a truncated cache, which is worse than no cache -- it would
  # discard every completed stage on the next readRDS() failure.
  tmp <- paste0(CKPT, ".tmp")
  saveRDS(.ckpt, tmp)
  file.rename(tmp, CKPT)
  v
}

# ---- 0. Verbatim extraction of the NEW configuration -----------------------

PL <- readLines(PHISTEP_FILE)

#' Lines [first match of `from`, line before first match of `to`], inclusive.
grab_block <- function(lines, from, to, label) {
  i <- grep(from, lines); j <- grep(to, lines)
  if (length(i) != 1L || length(j) != 1L || j[1L] <= i[1L]) {
    stop(sprintf(paste("bdrylayer: anchors for block '%s' matched %d/%d times",
                       "-- sim_thm_rootn_phistep.R has moved and this",
                       "measurement must be re-anchored before it is trusted."),
                 label, length(i), length(j)))
  }
  lines[i[1L]:(j[1L] - 1L)]
}

#' One top-level assignment line, by name.
grab_const <- function(lines, nm) {
  i <- grep(sprintf("^%s\\s*<-", nm), lines)
  if (length(i) != 1L) {
    stop(sprintf("bdrylayer: constant %s matched %d times", nm, length(i)))
  }
  lines[i]
}

# C_C and C2_SUP are DELIBERATELY ABSENT from this list. They were extracted here
# on 2026-08-15 and are retired by D11a; grab_const() raises on a missing name,
# so their absence is checked rather than assumed.
EXTRACT <- c(
  vapply(c("N_PHI", "N_UGRID", "N_TGRID", "N_XGRID", "HX_EX"),
         function(nm) grab_const(PL, nm), character(1)),
  grab_block(PL, "^#' Nodes in x at sample size n", "^# ---- Order-8 kernel",
             "nx_for"),
  grab_block(PL, "^kern8_coef <- local\\(\\{",
             "^# ---- C3\\(ii\\)'s two constants, eq:envconst", "kernel"),
  # R10, 2026-08-17: the anchor moved UP, from the env_consts() roxygen to
  # theta_abs_at().  env_consts() is no longer a self-contained function of h_x;
  # it is the top of a sweep over frak-I that needs theta_abs_at(), the ENVC_*
  # resolution constants and bar_theta(), all of which sit above its roxygen.
  # Anchored at the old line the block still MATCHED and extracted a fragment
  # whose eval() fails on a missing theta_abs_at -- loud, but for the wrong
  # reason.  The block now begins where the sweep does.
  grab_block(PL, "^theta_abs_at <- function",
             "^# ---- The Pi_t quadrature", "envconst"),
  grab_block(PL, "^T_LO  <-", "^# ---- Sieve", "Pi_t"),
  # R10, 2026-08-17: "at each n" left the header when the constants stopped
  # being per-n.  The guard above fired on the rename, which is what it is for.
  grab_block(PL, "^lx_for <- function",
             "^# ---- C3\\(ii\\)'s constants,", "sieve"))

# The x-smoother itself: phistep_rep()'s local Ker(), four lines. It closes over
# hx and xg, so it is re-eval()ed inside each caller's frame rather than defined
# once at top level -- see ker_new().
KER_TXT <- local({
  i <- grep("^  Ker <- function\\(X\\) \\{", PL)
  if (length(i) != 1L) stop("bdrylayer: Ker() anchor matched != 1 time")
  j <- i + 3L
  if (!grepl("^  \\}$", PL[j])) {
    stop("bdrylayer: Ker() is no longer four lines; re-anchor before trusting.")
  }
  sub("^  ", "", PL[i:j])
})

# The C3 family, from the shipped engine, into a sandbox environment so that
# nothing of lf_panel.R's namespace leaks into this one. Named ENG because the
# extracted Ker() refers to ENG$bdry_family by that name.
ENG <- new.env(parent = globalenv())
sys.source(ENGINE_FILE, envir = ENG)
stopifnot(is.function(ENG$bdry_family), is.function(ENG$bdry_theta),
          ENG$P_K_X == 8L)

eval(parse(text = EXTRACT))
KER_EXPR <- parse(text = KER_TXT)

#' The shipped smoother, evaluated in a frame where hx and xg are these.
ker_new <- function(X, hx, xg) {
  eval(KER_EXPR)                       # defines Ker() closing over this frame
  Ker(X)
}

# ---- 0b. The LEGACY configuration, frozen -----------------------------------
#
# D11's renormalised kern8 on trapezoid weights at N = 241 and h_x = n^{-0.20},
# i.e. exactly what sim_thm_rootn_phistep.R ran through 2026-08-15. Reconstructed
# rather than extracted because it is no longer in that file. Pinned by
# assertion at the end of section 5.
HX_EX_OLD  <- HX_EXP_SHIPPED                                    # 0.20
NX_OLD     <- 241L
C_C_OLD    <- 4.0                    # retired compact-support half-width
C2_SUP_OLD <- max(abs(kern8(seq(-C_C_OLD, C_C_OLD, length.out = 4001))))

w_trap <- function(N) { w <- rep(1 / (N - 1), N); w[c(1L, N)] <- w[1L] / 2; w }

#' D11's renormalised kernel: row-stochastic against the SAME wx it is used with.
ker_old <- function(X, hx, xg, wx) {
  M <- outer(X, xg, function(a, b) kern8((b - a) / hx))
  M / pmax(rowSums(sweep(M, 2, wx, "*")), 1e-300)
}

#' Row-block driver, so that a 20,001-node reference quadrature does not
#' allocate a 2001 x 20001 matrix. INV-17: the container is pre-allocated.
chunked <- function(xb, ncol_out, blk, f) {
  out <- matrix(0, length(xb), ncol_out)
  idx <- split(seq_along(xb), ceiling(seq_along(xb) / blk))
  for (k in idx) out[k, ] <- f(xb[k])
  out
}

# ---- The block ceiling, and it is an AREA and not a row count ---------------
#
# A FIXED ROW COUNT DOES NOT BOUND A TRANSIENT WHEN THE COLUMN COUNT GROWS WITH
# n, and both column counts here do.  This file's blocking was written in rows --
# 250 in chunked(), 2000 in smooth_at() -- at a time when the widest object was
# a 961-node grid.  D11b/D11c then made the shipped grid n-dependent (nx_for()
# reaches 10,145 at n = 181,019) and REF_MAX made the reference grid 60,001, so
# the same literals now describe blocks of 15.0 and 20.3 million elements.  At
# 8 bytes and roughly a dozen live transients inside bdry_theta() -- two rep()s
# for the `inside` test, seven Horner temporaries, dnorm(), the transpose, the
# sweep -- that is a measured 1,757 MB peak RSS, against the ~200 MB the same
# code costs at n = 500.
#
# THIS IS THE SAME DEFECT sim_thm_rootn_phistep.R FIXED ON 2026-08-16 and it is
# fixed the same way, at the same ceiling: that arm capped its Ker() application
# at SMOOTH_BLK = 1000 rows against N = 2915 nodes, i.e. 2,915,000 elements per
# block, which held its per-replication peak at 327 MB.  BLK_ELEM is that number,
# taken from the sibling rather than chosen here so that the two arms cannot
# drift apart.  Blocking is expressed as `min(cap, BLK_ELEM / ncols)` so it can
# only ever SHRINK a block: at every grid width below the ceiling the shipped
# literal is returned unchanged and the call site is untouched.
#
# WHY THIS IS INERT, AND IT IS BIT-INERT AND NOT MERELY CLOSE.  Every row of the
# smoother is computed independently of every other: bdry_family() is elementwise
# across the design index (batch_spd_solve() is a Cholesky written as vectorised
# scalar arithmetic over that index, lf_panel.R:235-268), bdry_theta() and
# sweep() are elementwise, and the trailing %*% accumulates over COLUMNS, whose
# order and count no row grouping can change.  Blocking draws nothing, so the RNG
# stream is untouched as well.  VERIFIED rather than argued: identical() holds at
# ALL 13 reference-grid widths (10,001 through 60,001, blk 250 -> 48) and at ALL
# 11 shipped grid widths (241 through 10,145, blk 2000 -> 287), on both the
# ker_new and the ker_old path.  Peak RSS 1,757 -> 552 MB; wall time 49.2 s
# against 49.2 s at the two largest call sites.
BLK_ELEM <- 2915000L                 # 1000 x 2915, from phistep's SMOOTH_BLK
#' Rows per block at a given grid width, never exceeding the site's own literal.
blk_for <- function(ncols, cap)
  max(1L, min(as.integer(cap), as.integer(BLK_ELEM %/% ncols)))

#' One interface over the two configurations, so that no measurement below can
#' apply the old rule to the new kernel by accident.
#'
#' @param cfg "old" or "new".
#' @return list(hx_ex, nx, w, ker) with ker(X, hx, xg, wx).
#
# THREE CONFIGURATIONS, BECAUSE THE REPAIR TOOK TWO PASSES AND THE INTERMEDIATE
# ONE IS WHAT MAKES THE SECOND LEGIBLE.
#   "old"   D11's renormalised kern8, h_x = n^{-0.20}, 241 trapezoid nodes:
#           what shipped through 2026-08-15.
#   "fixed" the C3 family at h_x = n^{-0.40} on a CONSTANT 961 Simpson nodes:
#           the first pass of 2026-08-16, SUPERSEDED. Retained because it failed
#           the acceptance test in an instructive way -- the level fell by three
#           to four orders and the SLOPE got worse -- and a reader who is not
#           shown it cannot see why the node count had to become n-dependent.
#   "new"   the same with nx_for() extracted from the arm: what ships now.
#
# nx_for() is EXTRACTED, not reproduced. The 2026-08-15 vintage of this file
# carried its own copy of the node rule as N_GROW(); that copy is deleted, on the
# principle this file already applies to the kernel -- a retyped constant is how
# a measurement silently drifts from the object it claims to measure.
CONFIG <- list(
  old   = list(hx_ex = HX_EX_OLD, nx = NX_OLD, w = w_trap,
               ker = function(X, hx, xg, wx) ker_old(X, hx, xg, wx)),
  fixed = list(hx_ex = HX_EX,     nx = N_XGRID, w = simpson_w,
               ker = function(X, hx, xg, wx) ker_new(X, hx, xg)),
  new   = list(hx_ex = HX_EX,     nx = nx_for, w = simpson_w,
               ker = function(X, hx, xg, wx) ker_new(X, hx, xg)))
CFG_ALL <- names(CONFIG)

#' Node count of a configuration at sample size n; constant or n-dependent.
nx_of <- function(cf, n) if (is.function(cf$nx)) cf$nx(n) else cf$nx

cat("== extracted from sim_thm_rootn_phistep.R ==\n")
cat(sprintf("  phistep md5 : %s\n", unname(tools::md5sum(PHISTEP_FILE))))
cat(sprintf("  engine md5  : %s\n", unname(tools::md5sum(ENGINE_FILE))))
cat(sprintf("  extracted   : %d lines, %d for Ker()\n",
            length(EXTRACT), length(KER_TXT)))
cat("  Ker() as shipped:\n")
cat(paste0("    ", KER_TXT, collapse = "\n"), "\n")
cat(sprintf("  NEW: N_XGRID = %d, Simpson, h_x = n^{-%.2f}\n", N_XGRID, HX_EX))
cat(sprintf("  OLD: N_XGRID = %d, trapezoid, h_x = n^{-%.2f}, c_C = %.1f, c_2 = %.4f\n\n",
            NX_OLD, HX_EX_OLD, C_C_OLD, C2_SUP_OLD))

# Self-check: the extracted kern8 really is order 8 on the whole line, so any
# departure found below is the TRUNCATION and not the kernel.
local({
  gg <- seq(-40, 40, length.out = 400001L)
  wg <- rep(diff(gg)[1L], length(gg)); wg[c(1L, length(gg))] <- wg[1L] / 2
  mm <- vapply(0:7, function(j) sum(wg * gg^j * kern8(gg)), numeric(1))
  cat("  kern8 moments j = 0..7 over all of R (target 1, 0, ..., 0):\n    ",
      paste(formatC(mm, format = "e", digits = 2), collapse = "  "), "\n\n")
  stopifnot(abs(mm[1L] - 1) < 1e-9, max(abs(mm[-1L])) < 1e-7)
})

# ---- 1. Architecture audit --------------------------------------------------

audit_one <- function(path) {
  L <- readLines(path)
  tabs <- regmatches(L, gregexpr('"sim_[a-z0-9_]+\\.tex"', L))
  data.table(
    file     = basename(path),
    kern8    = sum(grepl("kern8\\(", L)),
    fam      = sum(grepl("bdry_family\\(|bdry_theta\\(", L)),
    engine   = sum(grepl("make_operator\\(|ker_dens\\(|lf_step\\(", L)),
    srcs_eng = as.integer(any(grepl('"lf_panel\\.R"', L))),
    injects  = sum(grepl("dphi_hat\\[idx\\] <- phi_dagger", L)),
    tables   = paste(unique(gsub('"', "", unlist(tabs))), collapse = " "))
}
SIM_FILES <- sort(c(
  list.files(here::here("scripts", "simulations"), "^sim_thm_rootn_.*\\.R$",
             full.names = TRUE),
  list.files(here::here("scripts", "simulations"), "^sim_multinomial_.*\\.R$",
             full.names = TRUE)))
AUDIT <- rbindlist(lapply(SIM_FILES, audit_one))
AUDIT[, builds_smoother := (kern8 > 0 & fam > 0) | engine > 0 | srcs_eng > 0]

cat("== 1. architecture audit: who builds an x-smoother ==\n")
print(AUDIT[, .(file, kern8, fam, engine, srcs_eng, injects,
                smoother = builds_smoother)], nrows = 40)
cat("\n  tables written by the smoother-building files:\n")
for (i in which(AUDIT$builds_smoother)) {
  cat(sprintf("    %-32s %s\n", AUDIT$file[i],
              if (nzchar(AUDIT$tables[i])) AUDIT$tables[i] else "(none)"))
}
# THE BLAST-RADIUS CLAIM, ASSERTED RATHER THAN STATED. Of the root-n suite, only
# the phi-step arm builds an x-smoother; the limit-law, ablsplit, cardinality and
# jacobian arms inject phi-hat at a controlled rate and construct no kernel.
ROOTN <- AUDIT[grepl("^sim_thm_rootn_", file)]
stopifnot(setequal(ROOTN[builds_smoother == TRUE, file],
                   c("sim_thm_rootn_phistep.R", "sim_thm_rootn_bdrylayer.R")),
          all(ROOTN[file %in% c("sim_thm_rootn_limitlaw.R",
                                "sim_thm_rootn_ablsplit.R",
                                "sim_thm_rootn_cardinality.R",
                                "sim_thm_rootn_jacobian.R"), injects] > 0))
cat("\n  ASSERTED: within sim_thm_rootn_*, only phistep (and this file) build a\n")
cat("  smoother; limitlaw / ablsplit / cardinality / jacobian inject phi-hat.\n\n")

# ---- 2. Is the boundary layer populated? ------------------------------------
#
# The rows of Ker() are the design points: Ker(x2) - Ker(x1), so the design is
# the pooled {X_1i} U {X_2i}, 2n points, equally weighted. X_j = Phi(X_j* /
# varsigma_x) with X_1* ~ N(0, tau2) and X_2* | W = w ~ N(shift_w, tau2), and W
# is independent of (xi, v1, v2), so the pooled law is CLOSED FORM and carries no
# Monte Carlo error. A sampled figure is reported beside it, with its MC SE.

#' P(W = l): the propensity index is a scalar normal, so this is a
#' one-dimensional quadrature and not a simulation.
cell_probs <- function(spec) {
  if (spec_L(spec) != 2L) stop("cell_probs: binary design only")
  gm <- spec_gmat(spec)
  mu <- as.vector(gm %*% spec$z_mean) + spec$gamma0
  sdv <- sqrt(as.vector(gm %*% spec$sigma_z %*% t(gm)))
  f <- function(z) {
    idx <- mu + sdv * z
    (spec$eps_varrho + (1 - 2 * spec$eps_varrho) / (1 + exp(-idx))) * dnorm(z)
  }
  p1 <- stats::integrate(f, -12, 12, rel.tol = 1e-12)$value
  c(1 - p1, p1)
}

#' Population share of the pooled design within `cc` of 0 or of 1.
layer_share_pop <- function(cc, spec) {
  if (cc >= 0.5) return(1)                      # the two layers already meet
  tau <- sqrt(spec$tau2); vx <- spec$varsigma_x
  q <- stats::qnorm(cc)
  pw <- cell_probs(spec); sh <- spec_shift(spec)
  lo <- function(s) stats::pnorm((vx * q - s) / tau)
  hi <- function(s) 1 - stats::pnorm((-vx * q - s) / tau)
  0.5 * ((lo(0) + hi(0)) + sum(pw * (lo(sh) + hi(sh))))
}

N_MC  <- c(125L, 354L, 1000L, 2828L, 8000L, 22627L, 64000L, 181019L)
N_ALL <- sort(unique(c(N_PHI, N_MC)))
b_for <- function(n) max(30L, min(400L, as.integer(2e6 / n)))
SPEC_A <- dgp_spec("A")
SPEC_B <- dgp_spec("B")

layer_rows <- function(spec, spec_nm, cfg_nm) {
  ex <- CONFIG[[cfg_nm]]$hx_ex
  rbindlist(lapply(N_ALL, function(n) {
    hx <- band_hx(n, ex); B <- b_for(n)
    fr <- numeric(B)                                            # INV-17
    for (b in seq_len(B)) {
      d <- dgp_draw(n, spec); x <- c(d$x1, d$x2)
      fr[b] <- mean(x < 3 * hx | x > 1 - 3 * hx)
    }
    data.table(
      cfg = cfg_nm, spec = spec_nm, n = n, B = B, hx = hx,
      I_len = 1 / hx,                          # |I| = |X| / h_x; C3 asks >= 2
      lay3  = 3 * hx,
      pop3  = layer_share_pop(3 * hx, spec),
      samp3 = mean(fr), samp3_se = stats::sd(fr) / sqrt(B),
      in_phi = n %in% N_PHI)
  }))
}
LAYER <- staged("layer", rbindlist(lapply(c("old", "new"), function(cf)
  rbind(layer_rows(SPEC_A, "A", cf), layer_rows(SPEC_B, "B", cf)))))

cat("== 2. boundary-layer population, OLD against NEW bandwidth ==\n")
cat("   Section 6 benchmark: 45.0 per cent within 3 h_x, at |I| in [10.1, 12.4]\n")
print(dcast(LAYER[spec == "A"], n + in_phi ~ cfg,
            value.var = c("hx", "I_len", "pop3", "samp3")))
cat("\n")

# ---- 3. Truncated moments, each configuration on its own quadrature ---------
#
# m_j(x) = int_I varsigma^j Theta_{I(x)} d varsigma, computed EXACTLY as each
# configuration computes its smoother: its own grid, its own weights, its own
# kernel. Worst over 2,001 base points, interior against layer. A 20,001-node
# SIMPSON reference separates the boundary defect from the quadrature error --
# and Simpson is what the reference must be, because the trapezoid rule at
# 20,001 nodes still carries 4e-05 at the tightest cell (D11b).

# THE REFERENCE QUADRATURE SCALES WITH h_x, AND THE EARLIER FIXED ONE WAS ITSELF
# FLOORING THE MEASUREMENT IT WAS THERE TO PROVIDE. *** 2026-08-16, second pass.
#
# A fixed 10,001-node Simpson reference realises N h_x = 3000 at the loose end of
# the exponent sweep and only 200 at h_x = 0.02. Measured on that reference, the
# LOCAL slope of the family's bias runs 1.41, 2.98, 4.17, 3.51, 4.39, 6.05, 7.09,
# 7.69, 7.94, 7.97 and then COLLAPSES to 0.47 at the last point -- the reference
# had bottomed out at 1.0e-09 and was measuring itself, not the kernel. The
# single fitted exponent of 5.401 was a range average over a local slope that
# travels from 1.4 to 8.0, with one contaminated point at the end.
#
# The reference therefore holds N h_x at REF_NHX, ten times the shipped 80, which
# puts its own error at (1/10)^4 of the shipped grid's -- about 6e-11 -- below
# anything it has to resolve. It is capped at REF_MAX nodes so that the largest
# n stays affordable, and the REALISED N h_x is reported at every row, so a
# residual floor is visible rather than assumed away.
REF_NHX <- 800
REF_MAX <- 60001L
nref_for <- function(hx) {
  v <- min(REF_MAX, max(10001L, ceiling(REF_NHX / hx)))
  as.integer(v + (v %% 2L == 0L))
}
#' Reference grid and Simpson weights at bandwidth hx.
ref_grid <- function(hx) {
  N <- nref_for(hx)
  list(xg = seq(0, 1, length.out = N), wx = simpson_w(N), N = N)
}

mom_rows <- function(n, cfg_nm) {
  cf <- CONFIG[[cfg_nm]]
  hx <- band_hx(n, cf$hx_ex)
  nx <- nx_of(cf, n)
  xg <- seq(0, 1, length.out = nx); wx <- cf$w(nx)
  xb <- seq(0, 1, length.out = 2001L)                       # sup over X
  int <- xb >= 3 * hx & xb <= 1 - 3 * hx
  # blk_for() returns the shipped 250 at every nx section 3 realises (241, 961,
  # 1675, 2915 -- all below BLK_ELEM / 250), so Panel B is untouched by
  # construction and not merely by measurement.
  M <- chunked(xb, 8L, blk_for(nx, 250L), function(xs) {
    K <- cf$ker(xs, hx, xg, wx)
    S <- outer(xs, xg, function(a, b) (b - a) / hx)
    m <- matrix(0, length(xs), 8L)
    for (j in 0:7) m[, j + 1L] <- rowSums(sweep(S^j * K, 2, wx, "*"))
    m
  })
  tgt <- c(1, rep(0, 7))
  rbindlist(lapply(0:7, function(j) {
    dd <- abs(M[, j + 1L] - tgt[j + 1L])
    data.table(cfg = cfg_nm, n = n, j = j, hx = hx, nx = nx,
               n_interior = sum(int), worst = max(dd),
               interior = if (any(int)) max(dd[int]) else NA_real_,
               layer = if (any(!int)) max(dd[!int]) else NA_real_,
               endpt = dd[1L])
  }))
}
DEF <- staged("defect", rbindlist(lapply(CFG_ALL, function(cf)
  rbindlist(lapply(N_PHI, mom_rows, cfg_nm = cf)))))

cat("== 3. eq:truncmom realised, D11 renormalisation against the C3 family ==\n")
print(dcast(DEF, n + j ~ cfg, value.var = "worst")[
  , lapply(.SD, function(z) if (is.double(z)) signif(z, 3) else z)], nrows = 30)
cat("\n  node counts, and the (N h_x)^{-4} scaling the fixed grid obeys:\n")
print(unique(DEF[, .(cfg, n, nx, hx = round(hx, 5),
                     nhx = round(nx * hx, 1))]))
cat("\n")

# ---- 4. The eq:xsmoothbias exponent ----------------------------------------
#
# Fitted on a geometric h_x grid at an h_x-SCALED Simpson reference (ref_grid),
# so that the slope is the kernel's and not the grid's. Both configurations, same
# h_x values, same reference rule. The scaling matters: see the note at REF_NHX
# for what a fixed reference did to this fit.

phi_of <- function(x) phi_dagger(x, SPEC_A)
# ||vdagger||_{H^3} in closed form for c_phi sin(2 pi x): the norm (P-g)'s R
# stands for, realised at the truth. def:srcball needs ||vdagger||_{H^s} <= R.
R_HS <- SPEC_A$c_phi * sqrt(0.5 + (2 * pi)^6 / 2)

#' sup and L2 bias of the smoother at bandwidth hx, on a given quadrature.
bias_inf <- function(hx, cfg_nm, xg, wx, nb = 2001L) {
  cf <- CONFIG[[cfg_nm]]
  xb <- seq(0, 1, length.out = nb)
  # The reference quadrature reaches REF_MAX = 60,001 nodes, so the block here
  # is capped by area; on the shipped grids (nx <= 10,145) it stays at 250.
  sm <- as.vector(chunked(xb, 1L, blk_for(length(xg), 250L), function(xs)
    matrix(as.vector(sweep(cf$ker(xs, hx, xg, wx), 2, wx, "*") %*% phi_of(xg)),
           ncol = 1L)))
  int <- xb >= 3 * hx & xb <= 1 - 3 * hx
  c(sup = max(abs(sm - phi_of(xb))),
    sup_int = if (any(int)) max(abs(sm[int] - phi_of(xb[int]))) else NA_real_,
    l2 = sqrt(sum((sm - phi_of(xb))^2) / nb))
}

HX_FIT <- exp(seq(log(0.30), log(0.02), length.out = 12L))
# "old" and "new" differ ONLY in kernel and rule here, not in node count: the fit
# is indexed by h_x directly, so nx_for() plays no part and "fixed" would be the
# same curve as "new". Both are measured on the SAME h_x-scaled reference.
FIT <- staged("fit", rbindlist(lapply(c("old", "new"), function(cf)
  rbindlist(lapply(HX_FIT, function(h) {
    rg <- ref_grid(h)
    b <- bias_inf(h, cf, rg$xg, rg$wx)
    data.table(cfg = cf, hx = h, n_ref = rg$N, nhx_ref = rg$N * h,
               sup = b[["sup"]], sup_int = b[["sup_int"]], l2 = b[["l2"]])
  })))))
sl_of <- function(y, x) {
  ok <- is.finite(log(y)) & y > 0
  unname(stats::coef(stats::lm(log(y[ok]) ~ log(x[ok])))[2L])
}
setorder(FIT, cfg, -hx)
FIT[, local_slope := c(NA_real_, diff(log(sup)) / diff(log(hx))), by = cfg]
# THE FULL-RANGE FIT AND THE ASYMPTOTIC FIT ARE DIFFERENT CLAIMS. eq:xsmoothbias
# is an asymptotic statement in h_x; over [0.02, 0.30] the family's local slope
# TRAVELS, because at the loose end |I| = 3.3 and the Taylor route has not yet
# taken hold. Reporting one number over the whole sweep averages a pre-asymptotic
# regime with the asymptotic one. The tight half is where the claim lives.
ASYM <- HX_FIT[HX_FIT <= 0.09]
SLOPES <- FIT[, .(sup = sl_of(sup, hx), sup_int = sl_of(sup_int, hx),
                  l2 = sl_of(l2, hx),
                  sup_asym = sl_of(sup[hx %in% ASYM], hx[hx %in% ASYM]),
                  local_tight = local_slope[.N]), by = cfg]

cat("== 4. the realised exponent of eq:xsmoothbias ==\n")
cat(sprintf("   d log(.) / d log h_x over h_x in [%.3f, %.3f], reference holds N h_x >= %d:\n",
            min(HX_FIT), max(HX_FIT), REF_NHX))
print(SLOPES)
cat("\n   the LOCAL slope, which is what shows the exponent is not one number:\n")
print(dcast(FIT, hx + n_ref ~ cfg, value.var = "local_slope")[order(-hx),
      .(hx = round(hx, 4), n_ref, nhx = round(n_ref * hx),
        old = round(old, 2), new = round(new, 2))])
cat(sprintf("\n   as printed: s - 1/2 = %.1f;  degraded (j=0 only): 1;\n", CFG$s - 0.5))
cat("   for this DGP the family's own leading term is j = p_K = 8, since vdagger\n")
cat("   is C-infinity and eq:truncmom kills j = 1..7 -- so 8, not 2.5, is what a\n")
cat("   floor-free measurement should approach from below.\n\n")

# ---- 5. (P-g) across the full grid, before and after ------------------------
#
# THE ACCEPTANCE TEST. bias_sup is DETERMINISTIC given h_x -- no data enter it --
# so the only random ingredient of the ratio is h_u, through
# band_hu(n, sd(dY - Delta_{h_x} vdagger)). R_PG draws per n therefore give the
# ratio its MC SE exactly, and the fit below propagates those SEs into the slope.
#
# TWO STANDARD ERRORS FOR ONE SLOPE, AND THEY ANSWER DIFFERENT QUESTIONS.
#   MC-propagated: Var(slope) = sum (x_i - xbar)^2 Var(y_i) / (sum (x_i-xbar)^2)^2
#     with Var(y_i) the MC variance of log(ratio) at n_i. This is the sampling
#     error of the slope given that the mean curve is a straight line.
#   Regression: the ordinary lm() standard error, which measures DEPARTURE FROM
#     A STRAIGHT LINE as well. It is the larger of the two whenever the ratio is
#     curved in log n -- which is itself informative and is why both are printed.
# A slope is accepted as O(1)-compatible only if it is at or below zero by BOTH.

# Replications per n. h_u is a standard deviation over n observations, so its
# own sampling error falls like n^{-1/2} and the draw count can fall with it: at
# n = 181,019 three draws already put the MC SE of the ratio three orders below
# the effect being tested, while twenty-five would cost 25 minutes on their own.
# The realised SE is reported at every n, so the schedule is auditable rather
# than assumed adequate.
R_for <- function(n) max(3L, min(25L, as.integer(ceiling(3e5 / n))))

#' Blocked application of a smoother to a known function at design points.
#' Never materialises the n x N_XGRID matrix: at n = 181,019 and 961 nodes that
#' is 1.4 GB, and R_PG of them would not fit.
#'
#' @param blk integer(1). CEILING on the rows per block, not the block size: the
#'   realised size is blk_for(ncol, blk), because 961 nodes is no longer what
#'   this is applied against -- nx_for(181,019) is 10,145 and 2000 rows of that
#'   is 20.3 million elements. See the BLK_ELEM note.
smooth_at <- function(X, hx, cfg_nm, xg, wx, rhs, blk = 2000L) {
  cf <- CONFIG[[cfg_nm]]
  blk <- blk_for(length(xg), blk)
  out <- matrix(0, length(X), ncol(rhs))                        # INV-17
  for (k in split(seq_along(X), ceiling(seq_along(X) / blk))) {
    out[k, ] <- sweep(cf$ker(X[k], hx, xg, wx), 2, wx, "*") %*% rhs
  }
  out
}

# The Bierens constant of B1(iv.c), c_Pi^2 = Pi_u(R) * int_T wbar^2 dPi_t with
# wbar(t) = e^{||t||_1}. DETERMINISTIC -- the Pi_t half is fixed before the data
# and the Pi_u half is a Riemann sum for a density's integral, so the data
# dependence of the span and of the scale cancels exactly. Its Pi_u factor is
# taken at 1 for the same reason; only the Pi_t factor is computed.
C_PI <- sqrt(sum(pit_weights(TN_FIXED) * exp(2 * rowSums(abs(TN_FIXED)))))

# C3(ii)'s constants, from the extracted sweep.  R10, 2026-08-17: ONE pair, and
# it is not a function of h_x -- bar-Theta is a sup over frak-I, which contains
# every admissible interval at every bandwidth.  Evaluated once here because the
# sweep costs about 70 s and c2_of() is called inside pg_rows()'s per-n loop.
ENV_C3 <- staged("envc", env_consts())

#' c_2 as each configuration ships it, for the (N1) composition.
#'
#' `hx` is retained in the signature and DELIBERATELY UNUSED for the new
#' configuration: the call sites pass the configuration's own bandwidth, and a
#' silent drop of the argument would read as though the caller had stopped
#' caring which configuration it was in.  The old configuration's c_2 is a
#' property of ITS kernel, so the branch is still needed.
c2_of <- function(cfg_nm, hx)
  if (cfg_nm == "old") C2_SUP_OLD else ENV_C3[["c_2"]]

# STAGED PER (cfg, n) CELL, not per configuration: the "new" configuration's
# n = 181,019 cell alone is 29 minutes, so a cell is the largest unit of work it
# is reasonable to lose. Thirty cells, each a one-row data.table.
pg_rows <- function(cfg_nm) {
  cf <- CONFIG[[cfg_nm]]
  rbindlist(lapply(N_ALL, function(n) staged(sprintf("pg_%s_%d", cfg_nm, n), {
    hx <- band_hx(n, cf$hx_ex)
    nx <- nx_of(cf, n)
    xg <- seq(0, 1, length.out = nx); wx <- cf$w(nx)
    rhs <- matrix(phi_of(xg), ncol = 1L)
    # ON THE CONFIGURATION'S OWN SHIPPED GRID, not the reference. (P-g) is a
    # statement about the bias the ESTIMATOR incurs, and the estimator integrates
    # on its own quadrature; a reference-grid figure here would test a smoother
    # nothing runs. The reference-grid value is reported alongside so that the
    # quadrature's share of the realised bias is visible rather than buried --
    # at the new configuration it is most of what is left.
    b <- bias_inf(hx, cfg_nm, xg, wx)
    rg <- ref_grid(hx)
    bref <- bias_inf(hx, cfg_nm, rg$xg, rg$wx)
    R <- R_for(n)
    hu <- numeric(R); disp <- numeric(R)                        # INV-17
    for (r in seq_len(R)) {
      d <- dgp_draw(n, SPEC_A)
      sm2 <- smooth_at(d$x2, hx, cfg_nm, xg, wx, rhs)
      sm1 <- smooth_at(d$x1, hx, cfg_nm, xg, wx, rhs)
      dphi_sm <- as.vector(sm2 - sm1)
      dphi_tr <- phi_of(d$x2) - phi_of(d$x1)
      hu[r] <- band_hu(n, stats::sd(d$dy - dphi_sm))   # theta_o = 0
      disp[r] <- max(abs(dphi_sm - dphi_tr))
    }
    dh <- rate_delta_hat(n)
    ratio <- b[["sup"]] / (hu * dh)
    data.table(
      cfg = cfg_nm, n = n, hx = hx, nx = nx, R = R, hu = mean(hu),
      hu_se = stats::sd(hu) / sqrt(R), dhat = dh,
      bias_sup = b[["sup"]], bias_int = b[["sup_int"]], bias_l2 = b[["l2"]],
      bias_ref = bref[["sup"]], n_ref = rg$N, nhx_ref = rg$N * hx,
      disp_max = mean(disp), disp_se = stats::sd(disp) / sqrt(R),
      pg_printed = R_HS * hx^(CFG$s - 0.5) / (mean(hu) * dh),
      pg = mean(ratio), pg_se = stats::sd(ratio) / sqrt(R),
      lpg = mean(log(ratio)), lpg_se = stats::sd(log(ratio)) / sqrt(R),
      # (N1), the SECOND of the two sites proofs.tex:8017 names, composed as
      # lem:unifop Step 4 composes it: c_2 c_Pi h_u^{-1} max_i |Delta_{h_x}
      # varphi_i - Delta varphi_i|, over h_u delta-hat_n. Each configuration is
      # composed with the c_2 IT ships, which is the like-for-like reading.
      n1 = mean(c2_of(cfg_nm, hx) * C_PI * disp / (hu * dh)),
      n1_se = stats::sd(c2_of(cfg_nm, hx) * C_PI * disp / (hu * dh)) / sqrt(R),
      in_phi = n %in% N_PHI)
  })))
}
PG <- rbindlist(lapply(CFG_ALL, pg_rows))

#' Slope of log(ratio) on log(n), with both standard errors.
pg_slope <- function(dt) {
  x <- log(dt$n); y <- dt$lpg; v <- dt$lpg_se^2
  xc <- x - mean(x); Sxx <- sum(xc^2)
  b <- sum(xc * y) / Sxx
  se_mc <- sqrt(sum(xc^2 * v) / Sxx^2)
  fit <- stats::lm(y ~ x)
  c(slope = b, se_mc = se_mc,
    se_reg = unname(summary(fit)$coefficients[2L, 2L]))
}
PG_SLOPE <- PG[, as.list(pg_slope(.SD)), by = cfg]

cat("== 5. (P-g) measured, the acceptance test ==\n")
print(PG[, .(cfg, n, nx, hx = round(hx, 5), hu = signif(hu, 3),
             bias_sup = signif(bias_sup, 4), bias_ref = signif(bias_ref, 4),
             q_share = signif(bias_sup / bias_ref, 3),
             pg = signif(pg, 4), pg_se = signif(pg_se, 2), phi = in_phi)],
      nrows = 40)
cat("\n  fitted d log(ratio) / d log n   ((P-g) needs <= 0):\n")
print(PG_SLOPE)
# The same slope over the phi-step arm's OWN grid, which is the only grid the
# shipped estimator is evaluated on. Reported separately because a slope fitted
# over three orders of magnitude and a slope fitted over the estimator's own
# range are different claims and only the second bears on the shipped numbers.
cat("\n  the same slope restricted to the phi-step grid {500, 2000, 8000}:\n")
PHI_SLOPE <- PG[n %in% N_PHI, as.list(pg_slope(.SD)), by = cfg]
print(PHI_SLOPE)

# IS THE U GONE, OR HAS IT MOVED? A slope that is negative on average can still
# hide a minimum, and a minimum means the two error sources have been REBALANCED
# rather than one of them removed. The test is whether the ratio's minimum sits
# at an INTERIOR point of the grid: at the left edge it is monotone rising, at
# the right edge monotone falling, and anywhere in between there is a turning
# point and the rise beyond it is still there.
UTURN <- PG[, {
  i <- which.min(pg)
  .(n_min = n[i], pg_min = pg[i], pos = i, K = .N,
    interior = i > 1L && i < .N,
    rise_after = if (i < .N) pg[.N] / pg[i] else NA_real_,
    fall_before = if (i > 1L) pg[1L] / pg[i] else NA_real_)
}, by = cfg]
cat("\n  where the ratio bottoms out (interior = TRUE means a U remains):\n")
print(UTURN)
cat("\n  (N1), the other site eq:xsmoothbias feeds, and its slope:\n")
print(PG[, .(cfg, n, disp_max = signif(disp_max, 3), n1 = signif(n1, 4),
             n1_se = signif(n1_se, 2))], nrows = 25)
N1_SLOPE <- PG[, .(slope = unname(stats::coef(stats::lm(log(n1) ~ log(n)))[2L])),
               by = cfg]
print(N1_SLOPE)
cat("\n")

# THE REGRESSION PIN ON THE FROZEN LEGACY BLOCK. If the reconstruction of the
# 2026-08-15 state has drifted from what was actually measured then the "before"
# column is not the before column, and every ratio below is against the wrong
# baseline. Tolerances are loose on pg (h_u is now averaged over R_PG draws
# where the 2026-08-15 figure used one) and tight on the deterministic parts.
local({
  o <- PG[cfg == "old"][order(n)]
  # THE DETERMINISTIC PARTS ARE PINNED TIGHT AND THE STOCHASTIC PART IS NOT, and
  # the split is the point. h_x and the bias are functions of n alone, so they
  # must reproduce to rounding. The RATIO also carries h_u, which the 2026-08-15
  # measurement took from ONE draw per n and this one averages over R_for(n); at
  # n = 125, where h_u is noisiest, that alone moves the ratio by about 2 per
  # cent. Pinning the ratio tightly would be pinning a Monte Carlo error.
  stopifnot(
    abs(o$hx[o$n == 500L] - 0.28853998) < 1e-8,          # h_x = n^{-0.20}
    abs(o$bias_sup[o$n == 500L] - 0.5935728) < 1e-4,     # deterministic
    abs(o$bias_sup[o$n == 181019L] - 0.1420517) < 1e-4,
    abs(SLOPES[cfg == "old", sup] - 1.0850106) < 5e-3,   # was 1.085
    abs(PG_SLOPE[cfg == "old", slope] - 0.127) < 0.02,   # was +0.127
    abs(o$pg[o$n == 125L] / 3.049221 - 1) < 0.05,        # h_u, 1 draw vs R
    abs(o$pg[o$n == 181019L] / 8.098802 - 1) < 0.05)
  cat("  LEGACY BLOCK PINNED: reconstruction reproduces the 2026-08-15 figures.\n\n")
})

# ---- 6. What the repair costs eq:cap, from the constants alone --------------
#
# The same decomposition the phi-step arm's Panel C' computes from realised
# omega_n, computed here from the constants instead. Two independent routes: if
# they disagree, one of them is wrong, and a single blended number could hide it.
#     bar_m_n  propto  c_C * c_2^4 * h_x^{-1} * h_u^{-2}.

MAJ <- local({
  gg <- seq(-40, 40, length.out = 400001L)
  wg <- rep(diff(gg)[1L], length(gg)); wg[c(1L, length(gg))] <- wg[1L] / 2
  m <- sqrt(rowSums(outer(gg, 0:7, function(v, k) v^(2 * k)))) * exp(-gg^2 / 2)
  c(sup = max(m), l1 = sum(wg * m))
})

# R10, 2026-08-17: C3(ii)'s pair is the SAME at both bandwidths, so the "family
# at the old h_x" and "family at the new h_x" columns collapse onto one another
# and the ordering cost is exactly 1.  Leg A is the whole constants move, Leg B
# is the bare h_x^{-1}.  This tracks the phi-step arm's Panel C' change; the two
# routes are meant to agree, and they can only be checked against each other if
# they are repaired together.
CAP <- rbindlist(lapply(N_PHI, function(nn) {
  hx_o <- band_hx(nn, HX_EX_OLD); hx_n <- band_hx(nn, HX_EX)
  # `nn` rather than `n`: inside i, data.table resolves a bare `n` to the COLUMN.
  hu_o <- PG[cfg == "old" & n == nn, hu]
  hu_n <- PG[cfg == "new" & n == nn, hu]
  data.table(
    n = nn, hx_old = hx_o, hx_new = hx_n, I_old = 1 / hx_o, I_new = 1 / hx_n,
    c2_old_fam = ENV_C3[["c_2"]], c2_new_fam = ENV_C3[["c_2"]],
    cC_old_fam = ENV_C3[["c_C"]], cC_new_fam = ENV_C3[["c_C"]],
    legA = (ENV_C3[["c_C"]] / C_C_OLD) * (ENV_C3[["c_2"]] / C2_SUP_OLD)^4,
    legB = hx_o / hx_n,
    legC = 1,
    legD = (hu_o / hu_n)^2,
    order_cost = 1)
}))
CAP[, total := legA * legB * legC * legD]

cat("== 6. the cap decomposition, from the constants ==\n")
cat(sprintf("   majorant m(s): sup = %.4f, L1 = %.4f, c_C(majorant) = %.4f\n",
            MAJ[["sup"]], MAJ[["l1"]], MAJ[["l1"]] / (2 * MAJ[["sup"]])))
cat("   NOTE: the majorant's c_C = 1.8216 pairs with ITS OWN c_2, not with the\n")
cat(sprintf("   minimal envelope's %.4f; eq:envconst binds the two through\n",
            ENV_C3[["c_2"]]))
cat("   int bar-Theta = 2 c_C c_2, so the pair shipped is the realised one.\n")
print(CAP[, .(n, I_old = round(I_old, 2), I_new = round(I_new, 2),
              c2_old = round(c2_old_fam, 3), c2_new = round(c2_new_fam, 3),
              cC_old = round(cC_old_fam, 4), cC_new = round(cC_new_fam, 4),
              legA = signif(legA, 4), legB = round(legB, 3),
              legD = round(legD, 3), total = signif(total, 4),
              order_cost = round(order_cost, 2))])
cat("\n")

# ---- 7. Staleness of the general-L arms -------------------------------------

eng_md5 <- unname(tools::md5sum(here::here(
  "scripts", "R", c("lf_panel.R", "orthogonal_theta.R"))))
cache_src <- function(p, pick) {
  if (!file.exists(p)) return(NA_character_)
  paste(pick(readRDS(p)), collapse = " ")
}
STALE <- data.table(
  arm = c("sim_multinomial_phistep", "sim_multinomial_rootn",
          "sim_multinomial_phiplugin", "sim_multinomial_onestep"),
  cache = c("quality_reports/sim/sim_multinomial_phistep_ckpt.rds",
            "quality_reports/sim/sim_multinomial_rootn_ckpt.rds",
            "quality_reports/sim/sim_multinomial_phiplugin_parts/cfg.rds",
            "quality_reports/sim/sim_multinomial_onestep.rds"))
STALE[, recorded := c(
  cache_src(here::here(cache[1L]), function(x) x$cfg$src),
  cache_src(here::here(cache[2L]), function(x) x$cfg$src),
  cache_src(here::here(cache[3L]), function(x) x$src),
  cache_src(here::here(cache[4L]), function(x) x$cfg$src))]
STALE[, current := paste(eng_md5, collapse = " ")]
STALE[, stale := recorded != current]

cat("== 7. general-L arms: are the cached tables stale? ==\n")
print(STALE[, .(arm, stale, recorded = substr(recorded, 1L, 10L),
                current = substr(current, 1L, 10L))])
cat("  (NOT re-run: deferred by the author until the engine settles.)\n\n")

# ---- Output ----------------------------------------------------------------

saveRDS(list(audit = AUDIT, layer = LAYER, defect = DEF, fit = FIT,
             slopes = SLOPES, pg = PG, pg_slope = PG_SLOPE,
             n1_slope = N1_SLOPE, c_Pi = C_PI, cap = CAP,
             pg_slope_phigrid = PHI_SLOPE, uturn = UTURN,
             nx_new = nx_for(N_ALL), nx_base = N_XGRID, ref_nhx = REF_NHX,
             majorant = MAJ, engine_md5 = eng_md5, stale = STALE, R_HS = R_HS,
             config = list(old = list(hx_ex = HX_EX_OLD, nx = NX_OLD,
                                      c_C = C_C_OLD, c_2 = C2_SUP_OLD),
                           new = list(hx_ex = HX_EX, nx = N_XGRID)),
             exponents = c(hx_old = HX_EX_OLD, hx_new = HX_EX,
                           pg_printed = 9 * CFG$alpha / (8 * (CFG$s - 0.5)),
                           pg_degraded = 9 * CFG$alpha / 8,
                           c5_displayed = 1 - CFG$alpha / 8,
                           c5_inherited = (1 - 3 * CFG$alpha / 8) / 2,
                           window_max_alpha = 8 / 21),
             cfg = CFG, phistep_md5 = unname(tools::md5sum(PHISTEP_FILE))),
        here::here("quality_reports", "sim", "sim_thm_rootn_bdrylayer.rds"))

fmt <- function(x, d = 3) formatC(x, format = "f", digits = d)
sci <- function(x, d = 2) {
  out <- rep("---", length(x))
  ok <- is.finite(x)
  out[ok & x == 0] <- "0"
  big <- ok & abs(x) >= 1e-3
  out[big] <- formatC(x[big], format = "f", digits = 4)
  sm <- ok & x != 0 & abs(x) < 1e-3
  if (any(sm)) {
    ex <- floor(log10(abs(x[sm])))
    out[sm] <- sprintf("$%s \\times 10^{%d}$",
                       formatC(x[sm] / 10^ex, format = "f", digits = d),
                       as.integer(ex))
  }
  out
}

LA <- dcast(LAYER[spec == "A"], n ~ cfg,
            value.var = c("hx", "I_len", "pop3"))[order(n)]
# INV-17: every body is a vectorised sprintf, assembled once.
bodyA <- sprintf("%s & %s & %s & %s & %s & %s & %s \\\\",
  formatC(LA$n, big.mark = ",", format = "d"),
  fmt(LA$hx_old, 4), fmt(LA$I_len_old, 2), fmt(100 * LA$pop3_old, 2),
  fmt(LA$hx_new, 4), fmt(LA$I_len_new, 2), fmt(100 * LA$pop3_new, 2))

DW <- dcast(DEF, n + j ~ cfg, value.var = "worst")[order(n, j)]
bodyB <- sprintf("$n{=}%s$, $j{=}%d$ & %s & %s & %s & %s & %s \\\\",
  formatC(DW$n, big.mark = ",", format = "d"), DW$j,
  sci(DW$old), sci(DW$fixed), sci(DW$new),
  formatC(DEF[cfg == "new"][order(n, j), nx], big.mark = ",", format = "d"),
  fmt(DEF[cfg == "new"][order(n, j), nx * hx], 1))

PW <- dcast(PG, n ~ cfg, value.var = c("hx", "bias_sup", "pg", "pg_se"))[order(n)]
bodyC <- sprintf("%s & %s & %s & %s & %s & %s & %s \\\\",
  formatC(PW$n, big.mark = ",", format = "d"),
  fmt(PW$hx_old, 4),
  sprintf("%s (%s)", fmt(PW$pg_old, 2), fmt(PW$pg_se_old, 3)),
  fmt(PW$hx_new, 4), sci(PW$bias_sup_new),
  sprintf("%s (%s)", sci(PW$pg_fixed), fmt(PW$pg_se_fixed, 4)),
  sprintf("%s (%s)", sci(PW$pg_new), fmt(PW$pg_se_new, 4)))

sl_fmt <- function(r) sprintf("$%s$ (%s MC, %s reg.)", fmt(r$slope, 3),
                              fmt(r$se_mc, 3), fmt(r$se_reg, 3))
eo <- SLOPES[cfg == "old"]; en <- SLOPES[cfg == "new"]
row3 <- function(lab, f) sprintf("%s & \\multicolumn{2}{c}{%s} & \\multicolumn{2}{c}{%s} & \\multicolumn{2}{c}{%s} \\\\",
                                 lab, f("old"), f("fixed"), f("new"))
bodyD <- c(
  row3("$d\\log(\\text{ratio})/d\\log n$, full grid",
       function(k) sl_fmt(PG_SLOPE[cfg == k])),
  row3("\\quad restricted to $n\\in\\{500,2000,8000\\}$",
       function(k) sl_fmt(PHI_SLOPE[cfg == k])),
  row3("\\quad minimum of the ratio at $n=$ (interior $\\Rightarrow$ a U remains)",
       function(k) sprintf("%s (%s)",
                           formatC(UTURN[cfg == k, n_min], big.mark = ",",
                                   format = "d"),
                           ifelse(UTURN[cfg == k, interior], "interior",
                                  "edge"))),
  sprintf(paste("$d\\log\\sup|\\varphi_{h_x}-\\vdagger|/d\\log h_x$, full sweep &",
                "\\multicolumn{2}{c}{%s} & \\multicolumn{4}{c}{%s} \\\\"),
          fmt(eo$sup, 3), fmt(en$sup, 3)),
  sprintf(paste("\\quad over $h_x\\le0.09$, and the tightest local slope &",
                "\\multicolumn{2}{c}{%s} & \\multicolumn{4}{c}{%s} \\\\"),
          sprintf("%s / %s", fmt(eo$sup_asym, 3), fmt(eo$local_tight, 3)),
          sprintf("%s / %s", fmt(en$sup_asym, 3), fmt(en$local_tight, 3))))

CP <- CAP[order(n)]
bodyE <- sprintf("%s & %s & %s & %s & %s & %s & %s \\\\",
  formatC(CP$n, big.mark = ",", format = "d"),
  formatC(CP$total, format = "g", digits = 4),
  formatC(CP$legA, format = "g", digits = 4), fmt(CP$legB, 3),
  fmt(CP$legC, 2), fmt(CP$legD, 3), fmt(CP$order_cost, 2))

writeLines(c(
  "\\begin{tabular}{lrrrrrr}",
  "\\toprule",
  " & \\multicolumn{3}{c}{Through 2026-08-15 (D11)} & \\multicolumn{3}{c}{From 2026-08-16 (D11a/b)} \\\\",
  "\\cmidrule(lr){2-4}\\cmidrule(lr){5-7}",
  "\\multicolumn{7}{l}{\\textit{Panel A: is the boundary layer populated? Pooled design $\\{X_{1i}\\}\\cup\\{X_{2i}\\}$, DGP-A}} \\\\",
  "\\midrule",
  "$n$ & $h_x$ & $|I|$ & Within $3h_x$ (\\%) & $h_x$ & $|I|$ & Within $3h_x$ (\\%) \\\\",
  "\\midrule",
  bodyA,
  "\\addlinespace",
  "\\multicolumn{7}{l}{\\textit{Panel B: $\\int_I\\varsigma^{\\,j}\\Theta_I-\\delta_{j0}$, worst over design points, each configuration on its own quadrature}} \\\\",
  "\\midrule",
  " & D11, 241 trap. & C3, 961 fixed & C3, $N\\propto n^{0.40}$ & $N$ & $Nh_x$ \\\\",
  "\\midrule",
  bodyB,
  "\\addlinespace",
  "\\multicolumn{7}{l}{\\textit{Panel C: \\eqref{eq:xsmoothbias} realised, and (P-g) measured rather than assumed. The middle column is the superseded fixed-$N$ pass}} \\\\",
  "\\midrule",
  "$n$ & $h_x$ & $\\sup/(h_u\\hat\\delta_n)$ (SE) & $h_x$ & $\\sup_{\\mathcal X}|\\varphi_{h_x}-\\vdagger|$ & fixed $N$: $\\sup/(h_u\\hat\\delta_n)$ & $N\\propto n^{0.40}$: same \\\\",
  "\\midrule",
  bodyC,
  "\\addlinespace",
  "\\multicolumn{7}{l}{\\textit{Panel D: the two exponents, by configuration (D11 / fixed $N$ / grown $N$). (P-g) holds only if the first row is $\\le0$}} \\\\",
  "\\midrule",
  bodyD,
  "\\addlinespace",
  "\\multicolumn{7}{l}{\\textit{Panel E: what the repair costs \\eqref{eq:cap}, leg by leg, from the constants}} \\\\",
  "\\midrule",
  "$n$ & Total & Constants & Bandwidth & Family & $h_u$ coupling & Reverse-order cost \\\\",
  "\\midrule",
  bodyE,
  "\\bottomrule",
  "\\end{tabular}"),
  here::here("paper", "tables", "sim", "sim_thm_rootn_bdrylayer.tex"))

message("done: (P-g) acceptance test, before and after D11a/D11b")
