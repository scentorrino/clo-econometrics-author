## ---------------------------------------------------------------------------
## probe_00_loop_fidelity.R -- is the copied loop lf_solve()'s loop?
##
## DIAGNOSTIC ONLY.  Nothing shipped is touched.
##
## Everything downstream reads the path off lf_path(), which is a COPY of
## lf_solve()'s body.  A copy that has drifted would make every later number a
## statement about a different estimator.  The check: run the same draw through
## both, with lf_solve()'s stopping tests disabled (tau_dp = 0, patience = imax),
## and require
##   (a) the discrepancy path to agree to machine precision,
##   (b) the noise path likewise,
##   (c) lf_solve()'s returned phiev to equal the row of PHI at its own `iter`.
## Also times one solve at each n so the later runs can be costed before launch.
## ---------------------------------------------------------------------------

suppressMessages(library(here))
source(here::here("scripts", "R", "lf_panel.R"))
source(here::here("scripts", "R", "orthogonal_theta.R"))
source(here::here("explorations", "phi-stop-L", "R", "path_kit.R"))

set.seed(20260812L)

IMAX <- 30L

cat("=== loop fidelity: lf_path() against lf_solve() ===\n")
cat(sprintf("%-6s %-4s %-12s %-12s %-12s %-9s\n", "n", "L", "max|d err|",
            "max|d noise|", "max|d phi|", "secs"))

for (n in c(400L, 800L, 1600L)) {
  for (L in c(2L, 4L)) {
    set.seed(4242L + n + L)
    d <- dgp_draw(n, DGP_SPEC$A)
    w <- inst_of(d, L)
    xev <- seq(stats::quantile(c(d$x1, d$x2), 0.05),
               stats::quantile(c(d$x1, d$x2), 0.95), length.out = 60L)
    op <- make_operator(d$x1, d$x2, xev)
    cells <- sort(unique(as.integer(w)))
    ## The propensity and the Bierens family are built ONCE and handed to both
    ## engines, so the comparison is of the loops and not of two random draws.
    set.seed(99L)
    fit_idx <- sample(seq_len(n), floor(n / 2))
    Rho <- fit_propensity_multi(w, d$Z, fit_idx, seq_len(n), eps = 0.03,
                                cells = cells)
    attr(Rho, "prop_diag") <- NULL
    rho <- if (L == 2L) as.vector(Rho) else Rho
    bier <- make_bierens(d$Z, n_t = 16L, seed = 20260805L, scale = 0.25)
    init <- init_control(d$y, d$x1, d$x2, d$Z, w, op)

    ## cste fixed by hand from a common draw: operator_norm2() starts from
    ## rnorm(), so leaving it NULL would give the two engines different steps.
    set.seed(7L)
    u0 <- as.vector(d$y - d$Z %*% init$theta) -
      locate_dphi(integrate_centre(init$d2, op$M2, op$ord2) -
                  integrate_centre(init$d1, op$M1, op$ord1),
                  d$y, d$Z, init$theta)
    r0 <- operator_residual(u0, w, rho = rho, bier = bier, adj_wtil = TRUE)
    cste <- 1 / operator_norm2(op, weight = r0$adjw)

    t0 <- Sys.time()
    pth <- lf_path(d$y, d$x1, d$x2, d$Z, w, op, init, rho = rho, bier = bier,
                   adj_wtil = TRUE, cste = cste, imax = IMAX)
    secs <- as.numeric(difftime(Sys.time(), t0, units = "secs"))

    fit <- lf_solve(d$y, d$x1, d$x2, d$Z, w, op, init, rho = rho, bier = bier,
                    adj_wtil = TRUE, cste = cste, imax = IMAX,
                    patience = IMAX, tau_dp = 0)
    de <- max(abs(pth$err - fit$err_path))
    dn <- max(abs(pth$noise - fit$noise_path))
    dp <- max(abs(pth$PHI[fit$iter, ] - fit$phiev))
    cat(sprintf("%-6d %-4d %-12.3e %-12.3e %-12.3e %-9.1f\n", n, L, de, dn, dp,
                secs))
  }
}
cat("\nper-iteration cost is the `secs` column divided by imax =", IMAX, "\n")
