# ============================================================================
# sim_thm_rootn_run_all.R
#
# Driver for the Monte Carlo verification of thm:rootn (panel-npiv-discrete).
# Runs the arms in the order their outputs depend on one another (none does, so
# the order is only the order of the priority list in the brief).
#
# PART I -- the ABSTRACT-OPERATOR arms.  These run the theory's own sieve
# construction against the population objects of sim_thm_rootn_dgp.R.
#
#   0. sim_thm_rootn_l2identity.R  binary-identity certificate        (~1 min)
#   1. sim_thm_rootn_budget.R      remainder budget on a log-log grid (seconds)
#   2. sim_thm_rootn_jacobian.R    the Jacobian sign                  (~1 min)
#   3. sim_thm_rootn_phistep.R     stopping rule, cap, conditioning   (~65 min)
#   4. sim_thm_rootn_limitlaw.R    the limit law                      (~5.5 hours)
#   4b. sim_thm_rootn_cardinality.R the limit law at sans-L = 2 vs 4  (~20 min)
#   4c. sim_thm_rootn_ablsplit.R    WHICH nuisance breaks it         (~22 min)
#
# ARM 0 RUNS FIRST AND GATES EVERYTHING BELOW IT.  Until 2026-08-14 arms 1-4
# were binary by construction: sim_thm_rootn_dgp.R:469 and
# sim_thm_rootn_headroom_dgp.R:341 were each `pw <- cbind(1 - rr, rr)`.  The
# cardinality is now a parameter of the shared DGP (design decision D8) and arm
# 4b uses it, which means the file arms 1-4 are functions of has changed.  Arm 0
# is the certificate that the sans-L = 2 path did not move: it compares every
# population and replication object -- and one_rep_full itself -- against the
# vendored pre-cardinality sources under identical(), and EXITS NON-ZERO if any
# comparison fails, so the loop below stops before producing a table nobody can
# interpret.  Arms 1 and 2 additionally reproduce their .tex byte for byte,
# which has been checked; arms 3 and 4 are checkpointed and expensive, and their
# checkpoints are correctly discarded by the source-fingerprint guard -- a
# re-run starts from zero and, by arm 0, must reproduce their tables.
#
# ARM 4b IS NOT A REPLACEMENT FOR ARM 4.  It runs ONE design (DGP-A), ONE rate
# constant (c_delta = 0.25) and THREE sample sizes, at sans-L in {2, 4}, so that
# exactly one factor varies across its two panels.  Arm 4's eight-point grid,
# two designs, two rate constants, bias arm and ablation stay binary.
#
# ARM 4c IS THE FOLLOW-UP ARM 4b's VERDICT ASKED FOR.  4b found the limit law
# failing at sans-L = 4 and localised the failure to a JOINT condition -- present
# only when ell-hat != ell_star AND varrho-hat != varrho are both switched on --
# which leaves TWO assumptions on the hook and is not something a theorist can
# act on.  4c splits that condition into an ell-hat-only arm and a
# varrho-hat-only arm at sans-L in {2, 4}, and decomposes the instrument block
# into its three terms so the mechanism is measured rather than inferred from the
# arm label.  It runs 4b's design and 4b's B = 5,000 on a SHORTER n grid
# ({1000, 8000}, not {1000, 8000, 64000}): one cell at n = 64,000 and sans-L = 4
# costs 45 minutes on SIM_CORES workers, and thinning B at the top of the grid
# instead would reintroduce exactly the noise-floor defect 4b was built to avoid.
# The arm's own header states what that costs the finding.
#
# PART II -- the GENERAL-L arms, added 2026-08-12.  These run the SHIPPED engine
# (scripts/R/lf_panel.R, orthogonal_theta.R) at L = 2, 3 and 4 on the designs of
# sim_multinomial_dgp.R.  They exist because Part I verifies nothing about the
# L >= 3 machinery the theory is written for and Section 6 estimates on a
# four-category trigger.
#
#   5. sim_multinomial_phistep.R the phi-step's stopping rule at L>=3 (~75 min)
#   6. sim_multinomial_rootn.R   thm:rootn at L = 2, 3, 4            (~4.5 hours)
#
# Arm 5 gates arm 6 in interpretation, not in code: it establishes whether the
# discrepancy stop selects a usable iterate at L >= 3, which is what makes arm
# 6's phi-hat column readable.  Both are checkpointed and both re-run cheaply.
# SIM_B and SIM_NMAX shorten arm 6 for a smoke run.
#
# PART III -- the MERGE, added 2026-08-14.  It computes nothing and must run
# LAST, because it reads the cell summaries Parts I and II write.
#
#   7. sim_merged_cardinality.R  the cardinality merge                (seconds)
#
# Parts I and II ARE NOT THE SAME EXPERIMENT: they differ in the design, in the
# estimator (abstract sieve against population objects, versus the shipped
# lf_panel.R / orthogonal_theta.R) and in the nuisance regime (injected at a
# controlled rate, versus estimated).  Arm 7 lays them out as three LABELLED
# BLOCKS with the cardinality contrast confined to Block III, which is the only
# block that ran more than one cardinality and the only one whose cardinalities
# are paired on a shared draw.  It never puts two blocks in one row.  It fails
# with a named producer if any block's .rds is missing, so a partial pipeline
# cannot emit a table whose headers promise three designs and whose body has two.
#
# Each arm sets its own seed once at its top (INV-14) and is runnable on its
# own; this file exists so that the whole exercise reproduces with one command.
#
#   Rscript scripts/simulations/sim_thm_rootn_run_all.R
#
# REPRODUCIBILITY (round 2). The wall time is dominated by the limit-law arm,
# which now runs B = 5,000 at EVERY n rather than dropping to 2,000 above
# n = 22,627 -- so Monte Carlo precision does not vary across the grid and no
# cell's verdict depends on its own noise floor.
#
# The numbers do not depend on the host. mc.cores is the fixed constant
# SIM_CORES (sim_thm_rootn_dgp.R), not detectCores() - 1: under
# mc.preschedule = TRUE the replication -> L'Ecuyer-substream map is a function
# of mc.cores, so taking it from the machine made every table host-specific. A
# host with fewer physical cores pays only in wall time.
#
# Both parallel arms checkpoint after every cell. The checkpoint carries an MD5
# fingerprint of every source file that defines a replication and is DISCARDED
# if any of them has changed, so a resumed run can never merge cells computed
# under different versions of the code. Checkpoint writes are atomic.
# ============================================================================

library(here)

ARMS <- c("sim_thm_rootn_l2identity.R",  # FIRST: gates the binary path
          "sim_thm_rootn_budget.R",
          "sim_thm_rootn_jacobian.R",
          "sim_thm_rootn_phistep.R",
          "sim_thm_rootn_limitlaw.R",
          "sim_thm_rootn_cardinality.R",
          "sim_thm_rootn_ablsplit.R",
          "sim_multinomial_phistep.R",
          "sim_multinomial_rootn.R",
          "sim_merged_cardinality.R")   # LAST: reads what the arms above write

for (a in ARMS) {
  message("\n==== ", a, " ====")
  t0 <- Sys.time()
  status <- system2("Rscript", here::here("scripts", "simulations", a))
  message(sprintf("---- %s finished with status %d in %.1f min", a, status,
                  as.numeric(difftime(Sys.time(), t0, units = "mins"))))
  if (status != 0L) stop("arm failed: ", a)
}

message("\nAll arms complete. Tables in paper/tables/sim, figures in ",
        "paper/figures/sim, raw cell summaries in quality_reports/sim.")
