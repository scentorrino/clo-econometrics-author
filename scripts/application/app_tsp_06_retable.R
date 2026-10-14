# ============================================================================
# app_tsp_06_retable.R
#
# RE-EMIT paper/tables/app_tsp_phi_boot_compare.tex from the CACHED stage-06
# .rds.  Stage 06 itself is NOT re-run: it costs 3.6 core-hours, and a change
# confined to the table block -- which row is printed, how a cell is formatted --
# changes no replication.
#
# WHY IT CANNOT DRIFT FROM THE GENERATOR.  Nothing here is retyped.  The
# generator's own comparison-table block is read out of app_tsp_06_phi_mult.R by
# line and EVALUATED against inputs restored from app_tsp_phi_mult.rds; an edit
# to that block is picked up on the next call.  Verified 2026-08-17 by replaying
# the block UNCHANGED and diffing against the shipped fragment: byte for byte.
#
# WHAT IT CANNOT DO.  Anything that reads the per-replication records rather than
# the saved summaries.  If a future row needs a quantity outcomes_of() does not
# compute, stage 06 has to run.
#
# Usage
#   Rscript scripts/application/app_tsp_06_retable.R
# ============================================================================

library(here)

source(here::here("scripts", "application", "app_tsp_common.R"))

SRC <- here::here("scripts", "application", "app_tsp_06_phi_mult.R")
ln  <- readLines(SRC)
i0  <- grep("^# ---- Comparison table", ln)[1L]
i1  <- grep('^  file\\.path\\(TAB, "app_tsp_phi_boot_compare\\.tex"\\)\\)$', ln)[1L]
stopifnot(is.finite(i0), is.finite(i1), i1 > i0)
message(sprintf("retable: replaying generator lines %d-%d", i0, i1))

r  <- readRDS(here::here("quality_reports", "application", "app_tsp_phi_mult.rds"))

env <- new.env(parent = globalenv())
env$out_c0      <- r$outcomes$C0
env$out_m       <- r$outcomes$M
env$tie         <- r$outcomes$subsample
env$subeff      <- r$outcomes$subsample_eff
env$bands       <- r$bands
env$bm          <- r$bands[["M"]]
env$m_full      <- r$m_full
env$point_range <- r$point_range
# n is the estimation sample; the instrument's cell counts partition it, so this
# is the sample the stage RAN on and not a constant retyped from the paper.
env$n           <- sum(r$inst_counts)
env$N_MAP       <- r$n_map
env$TAB_PROBS   <- TAB_PROBS
env$BAND_PROBS  <- r$band_probs
env$fmt         <- fmt
env$write_tabular <- write_tabular
env$`%||%`      <- `%||%`
env$TAB         <- here::here("paper", "tables")
stopifnot(env$n == 983L)

# width_of() sits above the extracted block; taken from the same file by line.
w0 <- grep("^width_of <- function", ln)[1L]
w1 <- w0 + which(ln[w0:length(ln)] == "}")[1L] - 1L
eval(parse(text = paste(ln[w0:w1], collapse = "\n")), envir = env)
stopifnot(is.function(env$width_of))

eval(parse(text = paste(ln[i0:i1], collapse = "\n")), envir = env)
message("done: app_tsp_06 retable")
