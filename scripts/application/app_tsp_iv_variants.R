## ---------------------------------------------------------------------------
## app_tsp_iv_variants.R -- rebuild the nonattainment instrument from the raw
## EPA AQS monitor files, under every defensible reading of the standard.
##
## WHY THIS EXISTS.  The 1971 TSP primary standard is violated if EITHER the
## annual geometric mean exceeds 75 ug/m^3 OR the second-highest daily
## concentration exceeds 260 ug/m^3 (Chay and Greenstone 2005, p. 356).  The
## first criterion is unambiguous and merging.R implements CG's own county
## aggregation verbatim -- "the county mean is a weighted average of the
## monitor-specific geometric means, with the number of observations per monitor
## used as weights" (CG data appendix, pp. 420-421).  THE SECOND IS NOT
## UNAMBIGUOUS, and the choice moves the instrument by a third.
##
## Masten and Torgovitsky (2014 WP, footnote 3) identify the ambiguity and could
## not resolve it: "We are unsure what they used, and neither author has
## responded to our requests for clarification."
##
## Four readings, all defensible:
##   A  second-highest over RAW SAMPLES pooled across every monitor in the
##      county.  This is what merging.R does -- and it uses TSP_19xx rather than
##      TSP_19xx_2, so a monitor reporting three samples on one bad day supplies
##      both the highest and the second-highest and the county is designated on
##      the strength of a SINGLE DAY.  The 24-hour standard permits one
##      exceedance a year, so that reads a compliant county as violating.  It is
##      also internally inconsistent: the script builds monitor-day geometric
##      means and then does not use them here.
##   B  as A, but on monitor-DAY values.  The one-word fix to A.
##   C  second-highest per MONITOR, county designated if any monitor violates.
##      M&T's reading (1), which they adopt.
##   D  monitors averaged into a county daily value, then its second-highest.
##      M&T's reading (2), which they rejected because THEIR implementation gave
##      222 of 989, far below CG's 280.  On this data -- built from the raw AQS
##      files including 1969, which M&T could not obtain -- reading D reproduces
##      CG almost exactly.  That is evidence their rejection of it was an
##      artifact of the missing year.
##
## Writes data/raw/tsp_iv_variants.csv, keyed on (StateCode, CountyCode), with
## one column per variant plus the annual-mean criterion on its own.
##
## PROVENANCE WARNING.  The raw AQS files live OUTSIDE this repository, under
## the path in TSP_RAW below.  This script is therefore not runnable from a
## clean checkout; the CSV it writes is the reproducible artifact and is what
## the pipeline consumes.  Recorded rather than papered over.
## ---------------------------------------------------------------------------

library(here)

TSP_RAW <- Sys.getenv(
  "TSP_RAW_DIR",
  "/Users/samuele/Library/CloudStorage/Dropbox/Endogenous RCM/R Code")

if (!dir.exists(TSP_RAW)) {
  stop("raw AQS directory not found: ", TSP_RAW,
       "\nSet TSP_RAW_DIR to the folder holding TSP_1974.csv / TSP_1975.csv.")
}

## CG's geometric mean, taken from merging.R unchanged so that the annual-mean
## criterion is bit-for-bit the one already in the shipped instrument.
gm_mean <- function(x, na.rm = TRUE) {
  if (max(x, na.rm = TRUE) == 0) {
    0
  } else {
    n <- length(x[x > 0 & !is.na(x)])
    exp(sum(log(x[x > 0 & !is.na(x)])) / n)
  }
}

## Second-highest, with the singleton convention merging.R uses.
sec_high <- function(x) if (length(x) > 1) sort(x)[length(x) - 1] else x

county_of <- function(ids) sub("_[^_]+$", "", ids)

one_year <- function(path) {
  d <- utils::read.csv(path, header = TRUE, stringsAsFactors = FALSE)
  d$ID  <- paste(d$State.Code, d$County.Code, sep = "_")
  d$IDS <- paste(d$ID, d$Site.Num, sep = "_")

  ## monitor-DAY geometric mean: several samples can share a monitor-day
  day <- stats::aggregate(d$Sample.Measurement,
                          by = list(IDS = d$IDS, DATE = d$Date.Local),
                          FUN = gm_mean)
  names(day)[3] <- "val"
  day$ID <- county_of(day$IDS)

  ## --- annual mean, CG's county aggregation (merging.R implements this) -----
  gmm <- tapply(day$val, day$IDS, gm_mean)
  frq <- as.data.frame(table(day$IDS))
  fr  <- data.frame(GMEAN = as.numeric(gmm), Freq = frq$Freq,
                    IND = county_of(names(gmm)))
  cmean <- tapply(seq_len(nrow(fr)), fr$IND,
                  function(i) stats::weighted.mean(fr$GMEAN[i],
                                                   fr$Freq[i] / sum(fr$Freq[i])))

  ## --- the four bad-day readings -------------------------------------------
  A <- tapply(d$Sample.Measurement, d$ID, sec_high)
  B <- tapply(day$val, day$ID, sec_high)
  permon <- tapply(day$val, day$IDS, sec_high)
  C <- tapply(permon, county_of(names(permon)), max)
  cd <- stats::aggregate(day$val, by = list(ID = day$ID, DATE = day$DATE),
                         FUN = mean)
  D <- tapply(cd$x, cd$ID, sec_high)

  list(mean = cmean, A = A, B = B, C = C, D = D)
}

message("reading 1974 ...");  y74 <- one_year(file.path(TSP_RAW, "TSP_1974.csv"))
message("reading 1975 ...");  y75 <- one_year(file.path(TSP_RAW, "TSP_1975.csv"))

ids <- union(names(y74$mean), names(y75$mean))
pull <- function(v, id) { o <- v[id]; o[is.na(o)] <- -Inf; as.numeric(o) }

## CATT is designated in EITHER mid-decade year, exactly as merging.R has it.
mean_viol <- (pull(y74$mean, ids) > 75) | (pull(y75$mean, ids) > 75)
bad <- lapply(c(A = "A", B = "B", C = "C", D = "D"), function(k)
  (pull(y74[[k]], ids) > 260) | (pull(y75[[k]], ids) > 260))

out <- data.frame(
  StateCode  = as.integer(sub("_.*$", "", ids)),
  CountyCode = as.integer(sub("^.*_", "", ids)),
  mean_viol  = as.integer(mean_viol),
  CATT_A = as.integer(bad$A | mean_viol),
  CATT_B = as.integer(bad$B | mean_viol),
  CATT_C = as.integer(bad$C | mean_viol),
  CATT_D = as.integer(bad$D | mean_viol),
  badday_A = as.integer(bad$A), badday_B = as.integer(bad$B),
  badday_C = as.integer(bad$C), badday_D = as.integer(bad$D),
  stringsAsFactors = FALSE)
out <- out[order(out$StateCode, out$CountyCode), ]

f <- here::here("data", "raw", "tsp_iv_variants.csv")
utils::write.csv(out, f, row.names = FALSE)
message(sprintf("wrote %s  (%d counties)", f, nrow(out)))
for (k in c("A", "B", "C", "D")) {
  message(sprintf("  CATT_%s : %4d designated  (bad-day rule alone: %4d)",
                  k, sum(out[[paste0("CATT_", k)]]), sum(out[[paste0("badday_", k)]])))
}
message(sprintf("  annual-mean criterion alone: %d", sum(out$mean_viol)))
