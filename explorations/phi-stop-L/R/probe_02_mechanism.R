## ---------------------------------------------------------------------------
## probe_02_mechanism.R -- IS THE L = 4 phi-FAILURE THE CARDINALITY, OR THE
## PROPENSITY ESTIMATE?
##
## DIAGNOSTIC ONLY.  Nothing shipped is touched.
##
## WHAT IS ALREADY RULED OUT (explorations/adjoint-identity-L, and
## sim_multinomial_onestep.R's V6): the adjoint, the scal asymmetry, the xeval
## extrapolation, and eps-truncation.  What has NOT been separated is the
## PROPENSITY.  Every number so far ran varrho-hat from fit_propensity_multi(),
## which at L = 4 fits three logits' worth of parameters where the binary arm
## fits one.  wtil = 1{W = l} - varrho-hat_l carries that error directly, and
## E[(varrho-hat_l - varrho_l) 1{dU <= u}] is a SYSTEMATIC term in T-hat that no
## phi can remove -- so the iteration spends itself fitting it, which is a shape
## error in phi-hat that grows with the iteration count.  That is a candidate for
## the anti-correlation and for its worsening in n.
##
## THE SEPARATION.  The DGP knows the true varrho, so the same draw can be run at
## the estimated propensity and at the TRUE one.  Four arms, paired:
##     L = 2 est,  L = 2 true,  L = 4 est,  L = 4 true.
## If b turns positive at L = 4 with the true propensity, the failure is the
## multinomial FIT, which is a rate condition ((T-4), eq:foldrates) the theorem
## already assumes and a simulation can respect.  If b stays negative at the true
## propensity, the failure is the L >= 3 CRITERION itself, which is a property of
## the estimator and belongs in the paper as one.
##
## Two further arms isolate the two other design choices that only exist at
## L >= 3: the uniform Pi_w over the L - 1 non-base cells, and the Bierens
## family.  gamma = 0 makes varrho constant, so the multinomial fit has almost
## nothing to get wrong; it is the cheapest version of the same test.
## ---------------------------------------------------------------------------

suppressMessages({
  library(here)
  library(parallel)
})
source(here::here("scripts", "R", "lf_panel.R"))
source(here::here("scripts", "R", "orthogonal_theta.R"))
source(here::here("explorations", "phi-stop-L", "R", "path_kit.R"))

RNGkind("L'Ecuyer-CMRG")
set.seed(20260813L)

IMAX    <- 100L
B_REP   <- 24L
N_GRID  <- c(400L, 1600L)
N_CORES <- 8L

## gamma = 0 variant of design A: varrho is constant, so A1 is vacuous and the
## propensity fit has nothing to estimate but a constant.
DGP_SPEC$A0 <- modifyList(DGP_SPEC$A, list(gamma = 0,
                                           label = "design A at gamma = 0"))

ARMS <- data.frame(
  key  = c("L2_est", "L2_true", "L4_est", "L4_true", "L4_true_nobier",
           "L4_est_g0", "L4_true_g0"),
  L    = c(2L, 2L, 4L, 4L, 4L, 4L, 4L),
  true = c(FALSE, TRUE, FALSE, TRUE, TRUE, FALSE, TRUE),
  nt   = c(16L, 16L, 16L, 16L, 0L, 16L, 16L),
  spec = c("A", "A", "A", "A", "A", "A0", "A0"),
  stringsAsFactors = FALSE
)

#' Path at a GIVEN propensity, so the true one can be substituted for the fit.
#'
#' Mirrors path_once() exactly except that `rho` may be supplied.  At L = 2 the
#' propensity is the single column P[, 2] -- the probability of the pooled cell
#' {1,2,3}, which is what 1{W > 0} contrasts against.
path_at_rho <- function(d, L, use_true, n_t, imax = IMAX, eps_rho = 0.03) {
  w <- inst_of(d, L)
  n <- length(w)
  xev <- seq(stats::quantile(c(d$x1, d$x2), 0.05),
             stats::quantile(c(d$x1, d$x2), 0.95), length.out = 60L)
  op <- make_operator(d$x1, d$x2, xev)
  cells <- sort(unique(as.integer(w)))
  fit_idx <- sample(seq_len(n), floor(n / 2))
  if (use_true) {
    rho <- if (L == 2L) rowSums(d$P[, -1L, drop = FALSE]) else
      d$P[, -1L, drop = FALSE]
  } else {
    R <- fit_propensity_multi(w, d$Z, fit_idx, seq_len(n), eps = eps_rho,
                              cells = cells)
    attr(R, "prop_diag") <- NULL
    rho <- if (L == 2L) as.vector(R) else R
  }
  bier <- if (n_t > 0L)
    make_bierens(d$Z, n_t = n_t, seed = 20260805L, scale = 0.25) else NULL
  init <- init_control(d$y, d$x1, d$x2, d$Z, w, op)
  pth <- lf_path(d$y, d$x1, d$x2, d$Z, w, op, init, rho = rho, bier = bier,
                 adj_wtil = TRUE, cste = NULL, imax = imax)
  phi0 <- PHI_TRUE(xev); phi0 <- phi0 - mean(phi0)
  path_stats(c(pth, list(xeval = xev, phi0 = phi0, L = length(cells))))
}

streams <- vector("list", length(N_GRID) * B_REP)                    # INV-17
s <- get(".Random.seed", envir = globalenv())
for (j in seq_along(streams)) {
  s <- parallel::nextRNGStream(s)
  streams[[j]] <- s
}

rep_one <- function(j, n, off) {
  assign(".Random.seed", streams[[off + j]], envir = globalenv())
  ## Both designs drawn from the SAME stream position, so the gamma = 0 arms are
  ## a design change and not a different draw index.
  dA <- dgp_draw(n, DGP_SPEC$A)
  anchor <- get(".Random.seed", envir = globalenv())
  d0 <- dgp_draw(n, DGP_SPEC$A0)
  out <- vector("list", nrow(ARMS))
  names(out) <- ARMS$key
  for (a in seq_len(nrow(ARMS))) {
    assign(".Random.seed", anchor, envir = globalenv())
    d <- if (ARMS$spec[a] == "A") dA else d0
    out[[a]] <- tryCatch(path_at_rho(d, ARMS$L[a], ARMS$true[a], ARMS$nt[a]),
                         error = function(e) NULL)
  }
  out
}

CKPT <- here::here("explorations", "phi-stop-L", "output",
                   "probe_02_mechanism.rds")
CFG <- list(imax = IMAX, b = B_REP, n = N_GRID, arms = ARMS, seed = 20260813L,
            src = unname(tools::md5sum(here::here(
              "scripts", "R", c("lf_panel.R", "orthogonal_theta.R")))),
            kit = unname(tools::md5sum(here::here(
              "explorations", "phi-stop-L", "R", "path_kit.R"))))

RES <- NULL
if (file.exists(CKPT)) {
  old <- readRDS(CKPT)
  if (identical(old$cfg, CFG)) {
    RES <- old$res
    message("  reusing cached paths (configuration unchanged)")
  }
}
if (is.null(RES)) {
  RES <- vector("list", length(N_GRID))                              # INV-17
  names(RES) <- as.character(N_GRID)
  for (i in seq_along(N_GRID)) {
    t0 <- Sys.time()
    RES[[i]] <- parallel::mclapply(seq_len(B_REP), rep_one, n = N_GRID[i],
                                   off = (i - 1L) * B_REP,
                                   mc.cores = N_CORES, mc.preschedule = FALSE)
    message(sprintf("  n = %d done in %.1f min", N_GRID[i],
                    as.numeric(difftime(Sys.time(), t0, units = "mins"))))
  }
  saveRDS(list(cfg = CFG, res = RES), CKPT)
}

# ---- report ----------------------------------------------------------------

ff <- function(x, d = 3) formatC(x, format = "f", digits = d)
q3 <- function(x) sprintf("%s [%s, %s]", ff(stats::median(x, na.rm = TRUE), 2),
                          ff(stats::quantile(x, 0.25, na.rm = TRUE), 2),
                          ff(stats::quantile(x, 0.75, na.rm = TRUE), 2))

cat("\n\n===== IS IT THE CARDINALITY OR THE PROPENSITY? ====================\n")
cat("b at the ORACLE stop, and b at the cap, by arm.  If the `true` arms\n")
cat("recover phi at L = 4 and the `est` arms do not, the failure is the\n")
cat("multinomial FIT and not the L >= 3 criterion.\n\n")
cat(sprintf("%-6s %-16s %-16s %-16s %-9s %-9s\n", "n", "arm", "b at oracle",
            "oracle m", "b at cap", "b max"))
SUM <- list()
for (i in seq_along(N_GRID)) {
  for (a in ARMS$key) {
    v <- lapply(RES[[i]], function(z) z[[a]])
    v <- v[!vapply(v, is.null, logical(1))]
    if (!length(v)) next
    orc <- vapply(v, function(z) which.min(z$ise), integer(1))
    b_o <- vapply(seq_along(v), function(k) v[[k]]$b[orc[k]], numeric(1))
    b_c <- vapply(v, function(z) z$b[length(z$b)], numeric(1))
    b_m <- vapply(v, function(z) max(z$b), numeric(1))
    r_o <- vapply(seq_along(v), function(k) v[[k]]$ratio[orc[k]], numeric(1))
    i_o <- vapply(v, function(z) min(z$ise), numeric(1))
    i_c <- vapply(v, function(z) z$ise[length(z$ise)], numeric(1))
    SUM[[length(SUM) + 1L]] <- data.frame(n = N_GRID[i], arm = a,
                                          b_orc = mean(b_o), b_cap = mean(b_c),
                                          rat_orc = stats::median(r_o),
                                          ise_orc = mean(i_o),
                                          ise_cap = mean(i_c),
                                          orc = stats::median(orc))
    cat(sprintf("%-6d %-16s %-16s %-16s %-9s %-9s\n", N_GRID[i], a, q3(b_o),
                q3(orc), ff(mean(b_c)), ff(mean(b_m))))
  }
}
SUM <- do.call(rbind, SUM)
saveRDS(SUM, here::here("explorations", "phi-stop-L", "output",
                        "probe_02_table.rds"))

cat("\n\n===== ISE AND THE ORACLE RATIO ====================================\n")
cat(sprintf("%-6s %-16s %-11s %-11s %-11s\n", "n", "arm", "ISE oracle",
            "ISE cap", "ratio orc"))
for (k in seq_len(nrow(SUM))) {
  cat(sprintf("%-6d %-16s %-11s %-11s %-11s\n", SUM$n[k], SUM$arm[k],
              ff(SUM$ise_orc[k], 4), ff(SUM$ise_cap[k], 4),
              ff(SUM$rat_orc[k], 3)))
}
cat("\ndone\n")
