# ============================================================================
# app_tsp_04_figures.R
#
# Section 6, stage 4: figures.  Reads the saved objects; runs no estimation.
#
#   paper/figures/app_tsp_lf_path.pdf     Landweber discrepancy paths
#   paper/figures/app_tsp_ladder.pdf      theta-hat with 95% CI along the ladder
#
# paper/figures/app_tsp_phi.pdf is NOT drawn here.  It carries a bootstrap
# variability band, and the band and the curve come from the same object, so
# stage 5 (app_tsp_05_phi_band.R) owns both that figure and the matching table.
# Drawing it in both places would let whichever stage ran last silently decide
# whether the published figure has a band.
#
# No titles inside any panel (INV-12); titles live in the manuscript caption.
# Serif throughout, colour paired with shape and linetype so every panel reads
# in grayscale.
# ============================================================================

library(here)
library(ggplot2)

source(here::here("scripts", "application", "app_tsp_common.R"))

# Nothing in this stage is stochastic -- it reads saved objects and draws.  The
# seed is set anyway so that adding a jitter or a sampled rug later cannot make
# the figures irreproducible without anyone noticing (INV-14).
set.seed(20260805L)

FIG <- here::here("paper", "figures")
OUT <- here::here("quality_reports", "application")
dir.create(FIG, showWarnings = FALSE, recursive = TRUE)

lad <- readRDS(file.path(OUT, "app_tsp_ladder.rds"))
rob <- readRDS(file.path(OUT, "app_tsp_robustness.rds"))

thm <- theme_minimal(base_family = "serif", base_size = 10) +
  theme(panel.grid.minor = element_blank(),
        strip.text = element_text(face = "bold"),
        legend.position = "bottom")

# ---- phi-hat: see app_tsp_05_phi_band.R -------------------------------------
#
# phi is identified only up to an additive constant (the LF iteration centres
# it), so the level is normalised to zero at the median of the pooled X support
# and the figure is read as a difference from that point.  That figure, with
# its bootstrap variability band and its companion table, is stage 5's.

# ---- Landweber discrepancy paths -------------------------------------------

pp <- rob$paths
pp$fold_lab <- factor(sprintf("Fold %d", pp$fold))
marks <- do.call(rbind, lapply(split(pp, pp$fold), \(s) {
  s[s$iter == s$argmin[1], , drop = FALSE]
}))

p_lf <- ggplot(pp, aes(iter, err, colour = fold_lab, linetype = fold_lab)) +
  geom_line(linewidth = 0.5) +
  geom_point(data = marks, aes(shape = fold_lab), size = 2.1) +
  scale_x_log10() +
  scale_colour_brewer(palette = "Set2") +
  labs(x = "Landweber--Fridman iteration (log scale)",
       y = expression(paste("|| ", hat(F)[1], " - ", hat(F)[0], " ||")),
       colour = NULL, linetype = NULL, shape = NULL) +
  thm
ggsave(file.path(FIG, "app_tsp_lf_path.pdf"), p_lf, width = 6.0, height = 3.4,
       device = grDevices::cairo_pdf)

# ---- The ladder -------------------------------------------------------------

fits <- lad$fits
# Every coefficient that appears at some rung and has a publication label; a
# coefficient absent from a rung simply contributes no point there.
#
# The intercept is EXCLUDED from this figure and kept in the table.  It is a
# common time effect rather than a coefficient of substantive interest, and its
# $d_Z = 0$ interval is +/- 27 -- two orders of magnitude wider than any other
# interval in the figure -- so including it would compress every other panel to
# a flat line.  The number itself, and why it is that wide, are in the ladder
# table and in the results summary.
common <- setdiff(intersect(names(COEF_LABELS),
                            Reduce(union, lapply(fits, \(f) f$coef_names))),
                  "const")
lad_rows <- vector("list", length(fits) * length(common))            # INV-17
m <- 0L
for (f in fits) {
  for (nm in common) {
    i <- match(nm, f$coef_names)
    m <- m + 1L
    lad_rows[[m]] <- data.frame(
      d_z = f$d_z, coef = nm,
      est = if (is.na(i)) NA_real_ else f$theta[i],
      se  = if (is.na(i)) NA_real_ else f$se_cl[i],
      stringsAsFactors = FALSE)
  }
}
ld <- do.call(rbind, lad_rows)
ld <- ld[stats::complete.cases(ld), , drop = FALSE]
ld$coef <- factor(ld$coef, levels = names(COEF_LABELS),
                  labels = COEF_LABELS[names(COEF_LABELS)])
ld$d_z_f <- factor(ld$d_z, levels = LADDER_DZ)

p_lad <- ggplot(ld, aes(d_z_f, est)) +
  geom_hline(yintercept = 0, colour = "grey60", linewidth = 0.3) +
  geom_errorbar(aes(ymin = est - stats::qnorm(0.975) * se,
                    ymax = est + stats::qnorm(0.975) * se),
                width = 0.16, linewidth = 0.35) +
  geom_point(size = 1.8) +
  facet_wrap(~coef, scales = "free_y", ncol = 3) +
  labs(x = expression(paste("Control-set size ", d[Z])),
       y = expression(paste(hat(theta), " with 95% clustered CI"))) +
  thm
ggsave(file.path(FIG, "app_tsp_ladder.pdf"), p_lad, width = 6.5, height = 5.0,
       device = grDevices::cairo_pdf)

message("done: app_tsp_04_figures")
