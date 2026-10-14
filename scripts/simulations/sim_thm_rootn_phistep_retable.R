# ============================================================================
# sim_thm_rootn_phistep_retable.R
#
# RE-EMIT the phi-step arm's tables and figure from the CACHED .rds, repriced at
# C3(ii)'s current constants.  It does NOT re-run the simulation.
#
# WHY IT IS A SEPARATE FILE AND NOT A FLAG ON THE ARM.  The arm's checkpoint is
# fingerprinted on the md5 of its own source (SRC_HASH), which is the guard that
# stopped stale cells shipping in round 2 and must not be weakened.  Any edit to
# sim_thm_rootn_phistep.R therefore invalidates the checkpoint by design -- which
# is correct when the edit changes what a REPLICATION computes, and wasteful when
# it changes only what C3(ii)'s constants ARE.  R10 is the second kind: the
# constants enter eq:normconst and eq:cap in closed form, so the columns they
# govern move by arithmetic (see reprice_env() in the arm).
#
# WHY IT CANNOT DRIFT FROM THE ARM.  Nothing here is retyped.  The arm's source
# is read, split at `RES <- rbindlist(OUT)` and at the table header, and the two
# halves are EVALUATED: the definitions half verbatim, then the cached RES, then
# the tables-and-figure half verbatim.  A change to either half is picked up on
# the next call.  Only the driver loop -- the 10,800 replications -- is skipped.
#
# WHAT IT DOES NOT CERTIFY.  Panel D's Lepskii columns; see reprice_env()'s note.
#
# Outputs (same paths as the arm)
#   paper/tables/sim/sim_thm_rootn_stopping.tex
#   paper/tables/sim/sim_thm_rootn_condition.tex
#   paper/figures/sim/sim_thm_rootn_stopping.pdf
# ============================================================================

library(here)
library(data.table)

ARM <- here::here("scripts", "simulations", "sim_thm_rootn_phistep.R")
ln  <- readLines(ARM)
i_res <- grep("^RES <- rbindlist\\(OUT\\)$", ln)
i_drv <- grep("^# ---- Driver", ln)
i_tab <- grep("^# ---- Tables", ln)
stopifnot(length(i_res) == 1L, length(i_drv) == 1L, length(i_tab) == 1L,
          i_drv[1L] < i_res[1L], i_res[1L] < i_tab[1L])

# The arm prints its own tables at the end of a run; this re-emitter must land on
# the same paths, so the split is by LINE and the halves are not edited.
head_src <- ln[seq_len(i_drv[1L] - 1L)]             # definitions, ENV_CONST
mid_src  <- ln[(i_res[1L] + 1L):(i_tab[1L] - 1L)]   # reprice + assertions + rds
tail_src <- ln[i_tab[1L]:length(ln)]                # tables + figure

env <- new.env(parent = globalenv())
message("retable: sourcing the arm's definitions (env_consts() runs here) ...")
eval(parse(text = paste(head_src, collapse = "\n")), envir = env)

# SPECS and ES sit just below the Driver header and the table half reads SPECS$A
# for ||phi_dagger||.  Taken from the arm by line, not retyped.
spec_src <- ln[grep("^SPECS <- list\\(A = dgp_spec", ln):
                 grep("^ES    <- lapply\\(SPECS, solve_ell_star\\)", ln)]
stopifnot(length(spec_src) == 2L)
eval(parse(text = paste(spec_src, collapse = "\n")), envir = env)

RDS <- here::here("quality_reports", "sim", "sim_thm_rootn_phistep.rds")
env$RES <- readRDS(RDS)
message(sprintf("retable: loaded %d cached cells from %s", nrow(env$RES), RDS))

# The design the cache must match, so a cache from a different DESIGN cannot be
# tabulated against this arm's KEYS.  This is the same failure the arm's
# checkpoint guard exists for, at the one place the checkpoint is bypassed.
env$DESIGN <- CJ(n = env$N_PHI, prelim = c("zero", "rate"), c14 = env$C14_SET,
                 sorted = FALSE)
setorder(env$DESIGN, n, prelim, c14)
stopifnot(nrow(env$RES) == nrow(env$DESIGN),
          setequal(env$RES$n, env$N_PHI),
          setequal(env$RES$c14, env$C14_SET),
          setequal(env$RES$prelim, c("zero", "rate")))

# The mid half carries reprice_env(), the blocking assertions and saveRDS, minus
# the two bit-identity re-runs of phistep_rep() -- which cost two replications
# and test the REPLICATION, not the table.  They are dropped by name so that a
# rename raises here instead of silently skipping a guard.
drop_from <- grep("^s1_lo <- with_fixed_seed", mid_src)
drop_to   <- grep("^\\s+min\\(C14_SET\\), max\\(C14_SET\\), length\\(S1_NAMES\\),",
                  mid_src, fixed = FALSE)
stopifnot(length(drop_from) == 1L, length(drop_to) == 1L, drop_to > drop_from)
mid_src <- mid_src[-(drop_from:(drop_to + 1L))]
eval(parse(text = paste(mid_src, collapse = "\n")), envir = env)

message("retable: emitting tables and figure ...")
eval(parse(text = paste(tail_src, collapse = "\n")), envir = env)
message("done: phi-step retable")
