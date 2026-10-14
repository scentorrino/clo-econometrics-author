# ============================================================================
# sim_thm_rootn_ckpt_restamp.R
#
# ONE-OFF CHECKPOINT MIGRATION, 2026-08-03. Re-stamps the SOURCE FINGERPRINT of
# the completed checkpoints in quality_reports/sim/ after a repair that provably
# cannot move a number. It computes nothing, runs no replication and touches no
# result: the only field it rewrites is src_hash.
#
# ---------------------------------------------------------------------------
# WHY IT EXISTS
#
# Two defects were repaired on 2026-08-03:
#
#   (D1) sim_thm_rootn_dgp.R rate_delta_hat() implemented the propensity branch
#        of A5(i) alone, where A5(i) is a MAXIMUM whose first branch is a
#        parametric floor. See the archaeology at that function.
#   (D2) sim_thm_rootn_limitlaw.R and sim_thm_rootn_phistep.R guarded their
#        checkpoints with identical() on a data.table, which is always FALSE
#        across a save/load boundary. See same_design() in sim_thm_rootn_dgp.R.
#
# Both repairs edit files that the arms MD5 into their checkpoint fingerprints.
# The guards are byte-level by design -- "anything that can change a number
# invalidates the checkpoint" -- and they cannot tell a repair from a rewrite.
# Left alone, the D2 repair would resurrect the resume path and the D1 repair
# would immediately break it again, discarding a 51-of-51-cell headroom
# checkpoint whose results are cited in the manuscript and a 36-of-36-cell
# phi-step checkpoint. That is a worse outcome than either defect.
#
# ---------------------------------------------------------------------------
# WHAT IS CERTIFIED, AND HOW IT WAS CHECKED RATHER THAN ASSERTED
#
#   (a) EVERY RATE READ AT THE SHIPPED DESIGN IS BIT-IDENTICAL. rate_delta_hat,
#       rate_rn, rate_delta_n, rate_eps_n, band_hu, band_hx, cap_mbar,
#       cap_mbar_old and the four Step-4 budget products were evaluated on all
#       six grids this project uses -- the limit-law / headroom grid, the
#       budget arm's Monte Carlo, log-log and figure grids, the phi-step grid
#       and the Jacobian grid -- under the pre- and post-repair sources: 138
#       value vectors, all identical(). At alpha = 0.32 the propensity branch
#       dominates everywhere those grids reach, so the max and its second
#       branch agree exactly.
#   (b) THE HEADROOM ARM'S REPLICATION PATH IS UNCHANGED BYTE FOR BYTE.
#       hr_lift_defs() parses sim_thm_rootn_limitlaw.R and lifts one_rep_full
#       and run_cell; both deparse identically pre and post, the D2 edit lying
#       wholly outside them. That arm also OVERRIDES rate_delta_hat at its line
#       97, so the D1 repair is dead code there in any case, and the override's
#       deparse -- which the fingerprint stores separately -- is untouched.
#   (c) NOTHING ELSE IN sim_thm_rootn_dgp.R MOVED. Sourcing both versions into
#       separate environments and comparing every binding: rate_dhat_T and
#       same_design added, nothing removed, rate_delta_hat the only existing
#       object changed. CFG, EPS_EXPONENT and SIM_CORES identical.
#
# ---------------------------------------------------------------------------
# WHAT IT REFUSES TO DO
#
# The migration is keyed to EXACT digests. A checkpoint is re-stamped only if
# its stored fingerprint is precisely the certified pre-repair state and the
# sources on disk are precisely the certified post-repair state. Any other
# combination -- a checkpoint from an older source, a source edited after this
# migration -- is left alone and reported. It therefore cannot be used to
# launder a genuine change, and re-running it is a no-op.
#
# The LIMIT-LAW checkpoint is deliberately NOT re-stamped. It was written on
# 2026-07-31 under sim_thm_rootn_dgp.R @ 5dcf1a39..., a state that no longer
# exists on disk and that this migration cannot inspect, let alone certify;
# sim_thm_rootn_dgp.R was edited on 2026-08-01, after that run. Its guard was
# right to invalidate it and stays that way. Its completed cells remain in
# quality_reports/sim/sim_thm_rootn_limitlaw.rds, which is what the tables were
# built from.
#
# Usage:  Rscript scripts/simulations/sim_thm_rootn_ckpt_restamp.R [--dry-run]
# ============================================================================

library(here)                                                    # INV-15

DRY_RUN <- "--dry-run" %in% commandArgs(trailingOnly = TRUE)

SIM_DIR <- here::here("quality_reports", "sim")
SRC_DIR <- here::here("scripts", "simulations")

# ---- The certified digests -------------------------------------------------
#
# PRE are the digests as of 2026-08-03, before the repair; POST are the digests
# the repair produced. Only these exact transitions are honoured.
DIGEST <- data.frame(
  file = c("sim_thm_rootn_dgp.R", "sim_thm_rootn_limitlaw.R",
           "sim_thm_rootn_phistep.R", "sim_thm_rootn_nuisance.R",
           "sim_thm_rootn_headroom_dgp.R"),
  pre  = c("77ca9331b18e321bea0791eac5f3cfee", "7645e3e5913d254a24f76c8ed2d7139f",
           "31a6ecea25fd8e856cadeaf19a72041e", "af838f55da7597411a164eabc7b5d824",
           "d5bf94729fdc8bba49caff0e9af7b497"),
  post = c("9efafa44900e16a3daae6855725ee580", "40d81f6c91a5c85a5febe655594abe53",
           "67d9b288558161bf6a5ebd0b526377ea", "af838f55da7597411a164eabc7b5d824",
           "d5bf94729fdc8bba49caff0e9af7b497"),
  stringsAsFactors = FALSE)

#' Digest a file list in the order an arm's SRC_FILES declares it.
digest_now <- function(files) unname(tools::md5sum(file.path(SRC_DIR, files)))

#' The certified pre- / post-repair digest vector for an arm's SRC_FILES.
digest_certified <- function(files, which) {
  idx <- match(files, DIGEST$file)
  stopifnot(!anyNA(idx))
  DIGEST[[which]][idx]
}

# ---- The two arms this migration covers ------------------------------------
#
# SRC_FILES for each arm is copied from the arm itself, IN ITS ORDER, because
# the stored fingerprint is an ordered vector.
ARMS <- list(
  phistep = list(
    ckpt  = "sim_thm_rootn_phistep_ckpt.rds",
    files = c("sim_thm_rootn_phistep.R", "sim_thm_rootn_dgp.R",
              "sim_thm_rootn_nuisance.R"),
    where = "src_hash"),                    # list(design, out, src_hash)
  headroom = list(
    ckpt  = "sim_thm_rootn_headroom_ckpt.rds",
    files = c("sim_thm_rootn_headroom_dgp.R", "sim_thm_rootn_limitlaw.R",
              "sim_thm_rootn_dgp.R", "sim_thm_rootn_nuisance.R"),
    where = "fingerprint$src_hash")         # list(fingerprint, out)
)

#' Read the stored source digest, whichever shape the arm's checkpoint has.
get_stored <- function(obj, where) {
  if (identical(where, "src_hash")) obj$src_hash else obj$fingerprint$src_hash
}

#' Write the source digest back, preserving the checkpoint's shape.
set_stored <- function(obj, where, value) {
  if (identical(where, "src_hash")) obj$src_hash <- value
  else obj$fingerprint$src_hash <- value
  obj
}

#' Count completed cells without caring which shape the checkpoint has.
cells_done <- function(obj) sum(!vapply(obj$out, is.null, logical(1)))

report <- vector("list", length(ARMS))                           # INV-17
names(report) <- names(ARMS)

for (nm in names(ARMS)) {
  a    <- ARMS[[nm]]
  path <- file.path(SIM_DIR, a$ckpt)
  cat(sprintf("\n---- %s : %s ----\n", nm, a$ckpt))
  if (!file.exists(path)) {
    cat("  no checkpoint on disk; nothing to do\n")
    report[[nm]] <- "absent"
    next
  }

  obj    <- readRDS(path)
  stored <- get_stored(obj, a$where)
  now    <- digest_now(a$files)
  pre    <- digest_certified(a$files, "pre")
  post   <- digest_certified(a$files, "post")

  cat(sprintf("  cells complete           : %d of %d\n",
              cells_done(obj), length(obj$out)))
  cat("  stored fingerprint       : ", paste(substr(stored, 1, 8), collapse = " "), "\n")
  cat("  certified pre-repair     : ", paste(substr(pre,    1, 8), collapse = " "), "\n")
  cat("  on disk now              : ", paste(substr(now,    1, 8), collapse = " "), "\n")
  cat("  certified post-repair    : ", paste(substr(post,   1, 8), collapse = " "), "\n")

  if (identical(stored, now)) {
    cat("  VERDICT: already current; nothing to do\n")
    report[[nm]] <- "already-current"
  } else if (!identical(now, post)) {
    cat("  VERDICT: REFUSED -- the sources on disk are not the certified\n",
        "           post-repair state. This migration does not apply; if the\n",
        "           arm's sources have genuinely changed the checkpoint must\n",
        "           be discarded and the arm re-run.\n", sep = "")
    report[[nm]] <- "refused-source-moved"
  } else if (!identical(stored, pre)) {
    cat("  VERDICT: REFUSED -- the checkpoint was written under a source state\n",
        "           this migration has not certified. Left untouched.\n", sep = "")
    report[[nm]] <- "refused-uncertified-checkpoint"
  } else if (DRY_RUN) {
    cat("  VERDICT: would re-stamp (dry run; nothing written)\n")
    report[[nm]] <- "would-restamp"
  } else {
    bak <- paste0(path, ".pre-restamp-20260803")
    if (!file.exists(bak)) file.copy(path, bak)
    obj <- set_stored(obj, a$where, post)
    # Provenance at the TOP level only: the headroom guard compares the whole
    # fingerprint object with identical(), so a field added inside it would be
    # the very regression this script exists to prevent.
    obj$restamped <- list(
      date = "2026-08-03", script = "sim_thm_rootn_ckpt_restamp.R",
      reason = "A5(i) max repair + data.table checkpoint-guard repair",
      src_hash_before = stored, src_hash_after = post, backup = basename(bak))
    save_ok <- tryCatch({
      tmp <- paste0(path, ".tmp", Sys.getpid())
      saveRDS(obj, tmp)
      if (!file.rename(tmp, path)) stop("rename failed")
      TRUE
    }, error = function(e) {
      warning(sprintf("re-stamp of %s failed: %s", a$ckpt, conditionMessage(e)),
              call. = FALSE)
      FALSE
    })
    cat(sprintf("  VERDICT: re-stamped (%s); backup at %s\n",
                if (isTRUE(save_ok)) "written" else "FAILED", basename(bak)))
    report[[nm]] <- if (isTRUE(save_ok)) "restamped" else "write-failed"
  }
}

cat("\n---- limitlaw : sim_thm_rootn_limitlaw_ckpt.rds ----\n")
cat("  NOT COVERED, deliberately. Written 2026-07-31 under\n")
cat("  sim_thm_rootn_dgp.R @ 5dcf1a39..., a state edited away on 2026-08-01 and\n")
cat("  therefore not certifiable here. Its guard is correct to reject it.\n")

cat("\n==== summary ====\n")
for (nm in names(report)) cat(sprintf("  %-9s %s\n", nm, report[[nm]]))
