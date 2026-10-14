# ============================================================================
# sim_thm_rootn_budget.R   --   PRIORITY 3
#
# THE REMAINDER BUDGET OF thm:rootn ON A LOG-LOG SAMPLE-SIZE GRID.
#
# Step 4 of the proof of thm:rootn requires four products to be o(n^{-1/2}):
#
#   (a)  delta_n^2         -- the square, eq:biasb2 / prp:sharpquad
#   (b)  r_n delta_n       -- the varrho x phi cross term, eq:biasb3
#   (c)  delta_n eps_n     -- the first-order bias, eq:biasb1, under (R-e.1)
#   (d)  r_n eps^L_n       -- the varrho x L cross term, eq:biasb4, under (R-c.2)
#
# and Step 2 requires sqrt(n)||theta-hat^(0) - theta_dagger||^2 = o_P(1), which
# by lem:prelimtheta(i) is again governed by (a).
#
# WHY A POWER GRID CANNOT SEE THIS. After the dispatch-10 amendment, A5(ii)
# reads delta_n := (delta-hat_n ln n)^{2mu/(2mu+1)} -- the logarithm is IN THE
# SYMBOL and the inflation is applied ONCE, inside the power. At the
# frontier-clearing configuration (mu, alpha) = (2, 0.32), kappa = 0.8:
#
#   sqrt(n) delta_n^2 = n^{1/2 - 2 kappa alpha} (ln n)^{2 kappa}
#                     = n^{-0.012} (ln n)^{1.6}
#
# The polynomial factor and the logarithmic factor are of comparable size over
# every simulable n, and they pull in opposite directions. A grid that varies n
# by a factor of 8 varies ln n by a factor of 1.3 and cannot separate them; the
# grid here varies ln n by a factor of 2.6.
#
# The script does three things:
#   (1) tabulates the four products, and the derivative d log(budget)/d log n,
#       over the log-log grid, so the reader can see WHERE each turns over;
#   (2) solves for the n at which each product first falls below one, which is
#       the honest statement of when the theorem's own bound starts to bind;
#   (3) contrasts the amended delta_n with the pre-amendment log-free reading
#       and with the FORBIDDEN double application delta_n (ln n)^{kappa}, so
#       that the size of the dispatch-10 correction is visible.
#
# Nothing here is stochastic: it is the arithmetic of the maintained block at
# the design the paper names. It is reported because the limit-law arm cannot
# be read without it.
#
# Outputs
#   paper/tables/sim/sim_thm_rootn_budget.tex     (bare tabular, INV-13)
#   paper/figures/sim/sim_thm_rootn_budget.pdf
#   quality_reports/sim/sim_thm_rootn_budget.rds
# ============================================================================

library(here)
library(data.table)
library(ggplot2)

source(here::here("scripts", "simulations", "sim_thm_rootn_dgp.R"))

set.seed(20260732L)                                            # INV-14

# Log-log grid: equally spaced in log(log n), so that ln n itself spans a factor
# of 2.6 across the Monte Carlo range and (ln n)^{1/4} moves by 27 per cent.
LL <- exp(seq(log(log(125)), log(log(1e9)), length.out = 12L))
N_LL <- round(exp(LL))
N_MC <- c(125L, 354L, 1000L, 2828L, 8000L, 22627L, 64000L, 181019L)

# A far wider grid, used only for the figure: the leading product does not turn
# over until ln n = 133, so a plot truncated at any feasible n shows a monotone
# increase and hides the fact that the product is eventually o(1). The extreme
# right of that panel is arithmetic, not a proposal: ln n = 150 is n = 10^{65}.
LL_FIG <- seq(log(125), 150, length.out = 60L)

budget_at <- function(n, cfg = CFG) {
  dh <- rate_delta_hat(n, cfg)
  dn <- rate_delta_n(n, cfg)
  rn <- rate_rn(n, cfg)
  en <- rate_eps_n(n, cfg)
  data.table(
    n = n, ln_n = log(n), delta_hat = dh, delta_n = dn, r_n = rn, eps_n = en,
    # the four products of Step 4, all scaled by sqrt(n) so that "o_P(1)" reads
    # as "this column below one"
    b_sq   = sqrt(n) * dn^2,
    b_rd   = sqrt(n) * rn * dn,
    b_de   = sqrt(n) * dn * en,
    b_rL   = sqrt(n) * rn * en,
    # A5(ii)'s second half, delta_n = o(n^{-1/4}), as a ratio
    ratio_quarter = dn / n^(-0.25),
    # the pre-amendment (log-free) reading and the forbidden double application
    delta_logfree = dh^cfg$kappa,
    delta_double  = dn * log(n)^cfg$kappa,
    b_sq_logfree  = sqrt(n) * (dh^cfg$kappa)^2,
    b_sq_double   = sqrt(n) * (dn * log(n)^cfg$kappa)^2)
}

tab_ll <- budget_at(N_LL)
tab_mc <- budget_at(N_MC)

# Elasticity d log(budget) / d log n, evaluated exactly:
#   log b_sq = (1/2 - 2 kappa alpha) log n + 2 kappa log log n
#   d/d log n = (1/2 - 2 kappa alpha) + 2 kappa / log n
elas_sq <- function(n, cfg = CFG)
  (0.5 - 2 * cfg$kappa * cfg$alpha) + 2 * cfg$kappa / log(n)
tab_ll[, elasticity := elas_sq(n)]
tab_mc[, elasticity := elas_sq(n)]

# Turning point: elasticity zero at ln n = 2 kappa / (2 kappa alpha - 1/2).
n_turn <- exp(2 * CFG$kappa / (2 * CFG$kappa * CFG$alpha - 0.5))

# Crossing points: smallest n with the product below one. Solved on log n.
cross_n <- function(f, lo = log(100), hi = log(1e400)) {
  g <- function(l) f(exp(l)) - 1
  if (g(lo) < 0) return(exp(lo))
  hi_use <- hi
  while (g(hi_use) > 0 && hi_use < 5000) hi_use <- hi_use + 50
  if (g(hi_use) > 0) return(NA_real_)
  exp(stats::uniroot(g, c(lo, hi_use))$root)
}
# Work on the log scale to avoid overflow: log b_sq(l) with l = log n.
log_b_sq <- function(l) (0.5 - 2 * CFG$kappa * CFG$alpha) * l + 2 * CFG$kappa * log(l)
log_b_rd <- function(l) (0.5 - CFG$alpha * (1 + CFG$kappa)) * l + CFG$kappa * log(l)
log_b_de <- function(l) (0.5 - CFG$kappa * CFG$alpha - EPS_EXPONENT) * l + CFG$kappa * log(l)
log_b_rL <- function(l) (0.5 - CFG$alpha - EPS_EXPONENT) * l
root_log <- function(f, lo = log(125)) {
  if (f(lo) <= 0) return(lo)               # already below one at the smallest n
  hi <- 20
  while (f(hi) > 0 && hi < 2e5) hi <- hi * 1.5
  if (f(hi) > 0) return(NA_real_)
  stats::uniroot(f, c(lo, hi))$root
}
cross <- data.table(
  product = c("$\\sqrt n\\,\\delta_n^2$", "$\\sqrt n\\,r_n\\delta_n$",
              "$\\sqrt n\\,\\delta_n\\epsilon_n$", "$\\sqrt n\\,r_n\\epsilon^L_n$"),
  ln_n_cross = c(root_log(log_b_sq), root_log(log_b_rd),
                 root_log(log_b_de), root_log(log_b_rL)))
cross[, n_cross_log10 := ln_n_cross / log(10)]

saveRDS(list(tab_ll = tab_ll, tab_mc = tab_mc, cross = cross,
             n_turn = n_turn, cfg = CFG, eps_exp = EPS_EXPONENT),
        here::here("quality_reports", "sim", "sim_thm_rootn_budget.rds"))

# ---- Table -----------------------------------------------------------------

fmt <- function(x, d = 3) formatC(x, format = "f", digits = d)
big <- function(x) {
  ifelse(x < 1e6, formatC(x, big.mark = ",", format = "d"),
         paste0("$10^{", fmt(log10(x), 1), "}$"))
}

# INV-17: bodies built by vectorised sprintf, assembled once (no growing vectors).
budget_rows <- function(d) sprintf(
  "%s & %s & %s & %s & %s & %s & %s & %s \\\\",
  big(d$n), fmt(d$ln_n, 2), fmt(d$delta_n, 3), fmt(d$b_sq, 2), fmt(d$b_rd, 2),
  fmt(d$b_de, 3), fmt(d$b_rL, 3), fmt(d$ratio_quarter, 2))

writeLines(c(
  "\\begin{tabular}{rrrrrrrr}",
  "\\toprule",
  " & & & \\multicolumn{4}{c}{Step-4 products, scaled by $\\sqrt n$} & \\\\",
  "\\cmidrule(lr){4-7}",
  "$n$ & $\\ln n$ & $\\delta_n$ & $\\delta_n^2$ & $r_n\\delta_n$ & $\\delta_n\\epsilon_n$ & $r_n\\epsilon^L_n$ & $\\delta_n/n^{-1/4}$ \\\\",
  "\\midrule",
  "\\multicolumn{8}{l}{\\textit{Panel A: the Monte Carlo grid}} \\\\",
  "\\midrule",
  budget_rows(tab_mc),
  "\\addlinespace",
  "\\multicolumn{8}{l}{\\textit{Panel B: extended log-log grid, to the point where each product turns over}} \\\\",
  "\\midrule",
  budget_rows(tab_ll),
  "\\bottomrule", "\\end{tabular}"),
  here::here("paper", "tables", "sim", "sim_thm_rootn_budget.tex"))

# Panel C as its own table: the size of the dispatch-10 amendment. A5(ii) read
# log-free through dispatch 9; rem:phirscope(2) is the standing warning that a
# downstream result reading it literally is off by (ln n)^{2mu/(2mu+1)}. The
# third column is the FORBIDDEN double application delta_n (ln n)^kappa, which
# the dispatch-12 glossary row exists to block.
writeLines(c(
  "\\begin{tabular}{rrrrrr}", "\\toprule",
  " & \\multicolumn{3}{c}{$\\sqrt n\\,\\delta_n^2$ under three readings of A5(ii)} & \\multicolumn{2}{c}{Ratio to amended} \\\\",
  "\\cmidrule(lr){2-4}\\cmidrule(lr){5-6}",
  "$n$ & Log-free (pre-disp.~10) & Amended & Double (forbidden) & Log-free & Double \\\\",
  "\\midrule",
  sprintf("%s & %s & %s & %s & %s & %s \\\\",
          big(tab_mc$n), fmt(tab_mc$b_sq_logfree, 3), fmt(tab_mc$b_sq, 2),
          fmt(tab_mc$b_sq_double, 1), fmt(tab_mc$b_sq_logfree / tab_mc$b_sq, 3),
          fmt(tab_mc$b_sq_double / tab_mc$b_sq, 1)),
  "\\bottomrule", "\\end{tabular}"),
  here::here("paper", "tables", "sim", "sim_thm_rootn_logreadings.tex"))

writeLines(c(
  "\\begin{tabular}{lrr}", "\\toprule",
  "Product & $\\ln n$ at which it first falls below 1 & $\\log_{10} n$ \\\\",
  "\\midrule",
  sprintf("%s & %s & %s \\\\", cross$product,
          ifelse(is.na(cross$ln_n_cross), "---", fmt(cross$ln_n_cross, 1)),
          ifelse(is.na(cross$n_cross_log10), "---", fmt(cross$n_cross_log10, 1))),
  "\\midrule",
  sprintf("$\\sqrt n\\delta_n^2$ turns from increasing to decreasing at & %s & %s \\\\",
          fmt(log(n_turn), 1), fmt(log10(n_turn), 1)),
  "\\bottomrule", "\\end{tabular}"),
  here::here("paper", "tables", "sim", "sim_thm_rootn_crossings.tex"))

# ---- Figure ----------------------------------------------------------------

thm_sim <- theme_minimal(base_family = "serif", base_size = 10) +
  theme(panel.grid.minor = element_blank())

tab_fig <- budget_at(exp(LL_FIG))
fig_dt <- melt(tab_fig[, .(ln_n, `sqrt(n)*delta[n]^2` = b_sq,
                           `sqrt(n)*r[n]*delta[n]` = b_rd,
                           `sqrt(n)*delta[n]*epsilon[n]` = b_de,
                           `sqrt(n)*r[n]*epsilon[n]^L` = b_rL)],
                id.vars = "ln_n", variable.name = "product", value.name = "val")
rng <- range(N_MC)
p_bud <- ggplot(fig_dt, aes(ln_n, val, colour = product, linetype = product,
                            shape = product)) +
  annotate("rect", xmin = log(rng[1]), xmax = log(rng[2]),
           ymin = min(fig_dt$val), ymax = max(fig_dt$val),
           alpha = 0.12, fill = "grey40") +
  annotate("text", x = log(rng[2]) + 2.5, y = min(fig_dt$val) * 30,
           label = "Monte Carlo grid", hjust = 0, size = 2.9, family = "serif",
           colour = "grey30") +
  annotate("text", x = log(n_turn) - 2.5, y = min(fig_dt$val) * 30,
           label = "turnover of the leading product", hjust = 1, size = 2.9,
           family = "serif", colour = "grey30") +
  geom_vline(xintercept = log(n_turn), colour = "grey55", linewidth = 0.3,
             linetype = "dotted") +
  geom_hline(yintercept = 1, colour = "grey35", linewidth = 0.35) +
  geom_line(linewidth = 0.55) +
  scale_y_log10() +
  scale_colour_brewer(palette = "Set2", labels = scales::parse_format()) +
  scale_linetype_discrete(labels = scales::parse_format()) +
  scale_shape_discrete(labels = scales::parse_format()) +
  labs(x = expression(paste("log sample size, ", ln, " ", n)),
       y = "Step-4 product (log scale)",
       colour = NULL, linetype = NULL, shape = NULL) +
  thm_sim + theme(legend.position = "bottom")
ggsave(here::here("paper", "figures", "sim", "sim_thm_rootn_budget.pdf"), p_bud,
       width = 6.5, height = 3.6, device = cairo_pdf)

message("done: budget arm")
print(tab_mc[, .(n, ln_n, delta_n, b_sq, b_rd, b_de, b_rL, ratio_quarter, elasticity)])
print(cross)
cat("turning point of sqrt(n) delta_n^2: ln n =", round(log(n_turn), 1),
    " (log10 n =", round(log10(n_turn), 1), ")\n")
