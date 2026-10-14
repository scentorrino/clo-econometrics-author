## Does the `scal` asymmetry at lf_panel.R:458 change the LANDWEBER STEP?
## The step is  cste * apply_adjoint(op, comperr), with
##   cste = 1 / operator_norm2(op, weight = adjw).
## scal enters err (:486,:510) always; comperr (:493,:521) only when adj_wtil;
## adjw (:496,:524) only when adj_wtil.  So the cancellation is branch-specific.
## Here the shipped formulas are re-evaluated at scal and at 4*scal and the FULL
## step vector is compared.
suppressMessages(library(here))
source(here::here("scripts","R","lf_panel.R"))
source(here::here("scripts","R","orthogonal_theta.R"))
set.seed(11L)
THETA<-c(1.0,-0.5); PHI<-function(x) sin(2*pi*x)/2; G<-1.2; CS<-c(0,0.6,0.9,1.2)
dgp<-function(n){z<-matrix(rnorm(n*2),n,2);zx<-z[,1]*z[,2]
 eta<-cbind(0,0.20+G*z[,1],0.10+0.5*G*z[,2],-0.10+G*zx)
 P<-exp(eta)/rowSums(exp(eta));cum<-P
 for(k in 2:4) cum[,k]<-cum[,k-1]+P[,k]
 w4<-pmin(rowSums(runif(n)>cum),3); xi<-rnorm(n);v1<-rnorm(n);v2<-rnorm(n)
 x1<-pnorm((xi+v1)/1.5); x2<-pnorm((xi+CS[w4+1]+v2)/1.5)
 du<-G*zx+0.6*(v2-v1)+0.5*rnorm(n)
 list(y=PHI(x2)-PHI(x1)+as.vector(z%*%THETA)+du,x1=x1,x2=x2,
      Z=cbind(const=1,z),w4=w4,w2=as.numeric(w4>0))}
n<-300L; d<-dgp(n)
xev<-seq(quantile(c(d$x1,d$x2),.05),quantile(c(d$x1,d$x2),.95),length.out=60)
u<-as.vector(d$y-d$Z%*%c(0,THETA))-(PHI(d$x2)-PHI(d$x1)); hu<-bw_u(u)

## The shipped expressions, with scal exposed as an argument.
step_at_scal <- function(w, Z, adj_wtil, mult) {
  op <- make_operator(d$x1, d$x2, xev)
  cells <- sort(unique(as.integer(w))); L <- length(cells)
  fit_idx <- sample(seq_len(n), floor(n/2))
  Rho <- fit_propensity_multi(w, Z, fit_idx, seq_len(n), eps=0.03, cells=cells)
  attr(Rho,"prop_diag") <- NULL
  rho <- if (L==2L) as.vector(Rho) else Rho
  bier <- make_bierens(Z, n_t=16L, seed=20260805L, scale=0.25)
  r <- operator_residual(u, w, rho=rho, bier=bier, adj_wtil=adj_wtil,
                         hu=hu, order=8L)
  scal <- (if (L==2L) mean(w)*(1-mean(w)) else 1) * mult
  Wt <- bier$Wt; nt <- ncol(Wt); pit <- bier$pi_t
  wtil <- r$wtil; piw <- r$pi_w; fu <- r$fu
  ## err at this scal
  errL <- lapply(seq_len(L-1L), \(l) (K_order(outer(u,u,"-")/hu,8L) %*%
                                        (wtil[,l]*Wt))/(n*scal))
  ctr <- numeric(n)
  for (l in seq_len(L-1L)) {
    g <- rowSums(sweep(errL[[l]]*Wt, 2, pit, "*"))
    ctr <- ctr + piw[l]*(if (adj_wtil) wtil[,l]*g else g)
  }
  comperr <- fu*ctr/(if (adj_wtil) scal else 1)
  wsz <- sqrt(rowSums(sweep(Wt^2,2,pit,"*")))
  szl <- if (adj_wtil) sqrt(rowSums(sweep(wtil^2,2,piw,"*")))/scal else 1
  adjw <- abs(fu)*szl*wsz
  nrm <- operator_norm2(op, weight=adjw)
  cste <- if (is.finite(nrm) && nrm>0) 1/nrm else 0.5
  st <- apply_adjoint(op, comperr)$dev
  list(cste=cste, step=cste*st)
}
cat(sprintf("%-4s %-9s %-13s %-13s %-13s\n","L","adj_wtil","cste ratio",
            "step ratio","step cos"))
for (Lk in c(2L,4L)) {
  w <- if (Lk==2L) d$w2 else d$w4
  for (aw in c(TRUE,FALSE)) {
    set.seed(5L); a <- step_at_scal(w, d$Z, aw, 1)
    set.seed(5L); b <- step_at_scal(w, d$Z, aw, 4)
    cat(sprintf("%-4d %-9s %-13.6f %-13.6f %-13.10f\n", Lk, aw,
        b$cste/a$cste, sqrt(sum(b$step^2)/sum(a$step^2)),
        sum(a$step*b$step)/sqrt(sum(a$step^2)*sum(b$step^2))))
  }
}
