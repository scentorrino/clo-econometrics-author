## ---------------------------------------------------------------------------
## sim_probe2_size.R -- size and power of the Section 6 within-stratum
## independence probe (probe 2 of app_tsp_02_ladder.R).
##
## WHY THIS EXISTS.  Probe 2 tests A1 by comparing a Wtilde-contrast of the
## fitted residual CDF against a null in which W* ~ Bern(varrho-hat(Delta Z)).
## Two things make its size a QUANTITATIVE question that no argument settles:
##
##   (1) u-hat is held fixed across null draws, and u-hat cannot be made
##       independent of W even under A1.  Cross-fitting removes phi-hat's
##       dependence on observation i's own W -- crossfit_once() evaluates
##       phi-hat on a fold it was not fitted on -- but u-hat_i still carries
##       (phi - phi-hat)(X_i), and X_i is moved by W_i because that is what an
##       instrument does.  The term is O(||phi - phi-hat||): the test is valid
##       asymptotically, and finite-sample validity is a number.
##
##   (2) varrho-hat is estimated.  Under the null draw W* - varrho-hat is
##       mean-zero given Delta Z BY CONSTRUCTION; the observed W - varrho-hat is
##       mean-zero given Delta Z only if varrho-hat is right.  A propensity too
##       rigid for the truth therefore rejects even when A1 holds.
##
## WHAT IT FOUND, and it changed which rows of the probe are reportable:
## stratifying on a COMPONENT OF Delta Z rejects 70 per cent of the time when A1
## is TRUE.  Channel (2) is the mechanism -- the stratification lines up with
## exactly the direction varrho-hat gets wrong.  Stratifying on the endogenous
## regressor, or not stratifying at all, holds size.  See PROBE2_VALID in
## app_tsp_02_ladder.R, which this file is the evidence for.
##
## A1 TRUE  : du = gamma*z1*z2 + noise, W drawn from varrho(Delta Z).  Delta U is
##            independent of W given Delta Z exactly, at every gamma.
## A1 FALSE : du also loads on (W - varrho(Delta Z)), which is precisely the
##            conditional dependence A1 forbids.
##
## Writes quality_reports/sim/probe2_size_summary.md.
## ---------------------------------------------------------------------------

suppressMessages({library(here); library(parallel)})
source(here::here("scripts","R","lf_panel.R")); source(here::here("scripts","R","orthogonal_theta.R"))
THETA <- c(1.0,-0.5); phi_true <- function(x) sin(2*pi*x)/2
N_SIM <- 983L; B_REF <- 300L; N_REP <- 96L; GAM <- 1.0

## FIRST-STAGE HETEROGENEITY, added 2026-08-08.
##
## Masten and Torgovitsky (2014 WP, section 6.2), on essentially the Section 6
## dataset (989 counties against our 983), report that the nonattainment
## instrument is NOT uniformly weak -- it is HETEROGENEOUS.  Its effect on
## Delta TSP is strong at low quantiles and fades to zero at high ones;
## from about the 0.75 quantile up it is statistically insignificant, roughly a
## quarter of counties where it does nothing at all, and this coexists with
## F = 25 (ours is 23-25 robust).  The mechanism is that nonattainment
## regulation only bites where there is a pollution problem, so instrument
## strength tracks BASELINE pollution.
##
## That is exactly the dimension on which our probe rejects hardest -- the
## baseline-TSP-quartile row -- so a homogeneous strong first stage, which is
## what `het = 0` gives, cannot speak to whether that rejection is A1 failing or
## the instrument dying on part of the support.  `het = 1` reproduces their
## pattern: the instrument's effect is switched off for the quarter of units
## with the lowest xi, which is also the quarter with the lowest baseline X, so
## strength and baseline are tied together as they are in the data.
dgp <- function(n, gamma, lam, het = 0) {
  z  <- matrix(rnorm(n*2),n,2); zx <- z[,1]*z[,2]
  rr <- 0.05+0.9/(1+exp(-(0.2+gamma*z[,1]+0.5*gamma*z[,2]+gamma*zx)))
  w  <- as.numeric(runif(n) < rr)
  xi <- rnorm(n); v1 <- rnorm(n); v2 <- rnorm(n)
  ## pi_i: per-unit first-stage strength.  het = 0 is the constant 0.9 of the
  ## original design; het = 1 is zero on the lowest-baseline quartile and rises
  ## with baseline, matching M&T's figure 2 and their sorting explanation.
  base <- pnorm(xi)
  pi_i <- if (het == 0) rep(0.9, n) else 1.6 * pmax(base - 0.25, 0) / 0.75
  x1 <- pnorm((xi+v1)/1.5); x2 <- pnorm((xi + pi_i*w + v2)/1.5)
  du <- gamma*zx + lam*(w - rr) + 0.6*(v2-v1) + 0.5*rnorm(n)   # lam>0 breaks A1
  list(y = phi_true(x2)-phi_true(x1)+as.vector(z%*%THETA)+du,
       x1=x1, x2=x2, Z=z, w=w)
}
qcut <- function(v,k=4L) cut(v, stats::quantile(v, seq(0,1,length.out=k+1L)),
                             include.lowest=TRUE, labels=FALSE)
one <- function(b, lam, het = 0) {
  set.seed(20000L+b); d <- dgp(N_SIM, GAM, lam, het)
  set.seed(30000L+b)
  cf <- crossfit_once(d$y,d$x1,d$x2,d$Z,d$w,K=5,cste=NULL,lf_imax=300L,
                      lf_patience=40L, n_t=16L,t_scale=0.25,adj_wtil=TRUE,
                      conditional=TRUE, eps_rho=0.03)
  th <- stats::lm.fit(d$Z, d$y - cf$dphi)$coefficients
  uh <- as.vector(d$y - cf$dphi - d$Z %*% th)        # dphi is OUT-OF-FOLD
  n <- N_SIM
  hu <- 1.059*stats::sd(uh)*n^(-1/16); K <- K_order(outer(uh,uh,"-")/hu, 8L)
  rho <- fit_propensity(d$w, d$Z, seq_len(n), seq_len(n), eps=0.03)
  st_list <- list(rep(1L,n), qcut(d$x1), qcut(d$Z[,1]))
  cvm <- function(wv, st) {
    wt <- wv - rho; tot <- 0
    for (s in unique(st)) {
      idx <- which(st==s); if (length(idx)<10L) next
      wb <- mean(wv[idx]); if (!is.finite(wb)||wb<=0||wb>=1) next
      dd <- as.vector(K[idx,idx,drop=FALSE] %*% wt[idx])/(length(idx)*wb*(1-wb))
      tot <- tot + (length(idx)/n)*mean(dd^2)
    }; tot }
  vapply(st_list, function(st) {
    o <- cvm(as.integer(d$w), st)
    r <- vapply(seq_len(B_REF), function(k) cvm(stats::rbinom(n,1L,rho), st), numeric(1))
    (1 + sum(r >= o))/(B_REF + 1)
  }, numeric(1))
}
RES <- list(); LAB <- character(0)
for (cfg in list(c(lam=0, het=0), c(lam=0.5, het=0),
                 c(lam=0, het=1), c(lam=0.5, het=1))) {
  lam <- cfg[["lam"]]; het <- cfg[["het"]]
  P <- do.call(rbind, mclapply(seq_len(N_REP), function(b)
        tryCatch(one(b, lam, het), error=function(e) rep(NA_real_,3)), mc.cores=8L))
  P <- P[complete.cases(P),,drop=FALSE]
  lab <- sprintf("A1 %-5s, first stage %s",
                 if (lam==0) "TRUE" else "FALSE",
                 if (het==0) "homogeneous" else "HETEROGENEOUS (M&T)")
  cat(sprintf("%-42s %3d reps | reject at 5%%:  none %.3f   X1 quartile %.3f   Z1 quartile %.3f\n",
      lab, nrow(P), mean(P[,1]<0.05), mean(P[,2]<0.05), mean(P[,3]<0.05)))
  RES[[length(RES)+1L]] <- c(mean(P[,1]<0.05), mean(P[,2]<0.05), mean(P[,3]<0.05))
  LAB <- c(LAB, lab)
}

OUT <- here::here("quality_reports", "sim")
dir.create(OUT, showWarnings = FALSE, recursive = TRUE)
writeLines(c(
  "# Probe 2: size and power",
  "",
  sprintf("Nominal level 5 per cent. n = %d, %d replications per row, %d null draws each.",
          N_SIM, N_REP, B_REF),
  sprintf("DGP gamma = %.1f.  A1 false uses lambda = 0.5 on (W - varrho).", GAM),
  "",
  "## Homogeneous first stage",
  "",
  "| Stratification | Size (A1 true) | Power (A1 false) | Reportable |",
  "|---|---|---|---|",
  sprintf("| none | %.3f | %.3f | yes |", RES[[1]][1], RES[[2]][1]),
  sprintf("| quartile of X1 (endogenous regressor) | %.3f | %.3f | yes |", RES[[1]][2], RES[[2]][2]),
  sprintf("| quartile of Z1 (component of Delta Z) | %.3f | %.3f | **NO** |", RES[[1]][3], RES[[2]][3]),
  "",
  "## Heterogeneous first stage (Masten and Torgovitsky 2014, section 6.2)",
  "",
  "Instrument switched off on the lowest-baseline quartile, strength rising with",
  "baseline thereafter.  This is the configuration the Section 6 data is in.",
  "",
  "| Stratification | Size (A1 true) | Power (A1 false) | Reportable |",
  "|---|---|---|---|",
  sprintf("| none | %.3f | %.3f | -- |", RES[[3]][1], RES[[4]][1]),
  sprintf("| quartile of X1 (endogenous regressor) | %.3f | %.3f | -- |", RES[[3]][2], RES[[4]][2]),
  sprintf("| quartile of Z1 (component of Delta Z) | %.3f | %.3f | -- |", RES[[3]][3], RES[[4]][3]),
  "",
  "A stratification that is a function of Delta Z inherits whatever varrho-hat",
  "gets wrong in that direction, and the null draw does not: the observed",
  "statistic is compared against a reference built from a propensity the",
  "observed W does not obey.  Those rows are not evidence about A1.",
  "",
  "Produced by scripts/simulations/sim_probe2_size.R."),
  file.path(OUT, "probe2_size_summary.md"))
message("wrote ", file.path(OUT, "probe2_size_summary.md"))
