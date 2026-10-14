# Archive — §6 streamline, 2026-08-11

**Nothing in this repository is committed, so deleted prose cannot be recovered from git.**
This file is the recovery copy. Every passage removed from or rewritten inside
`paper/qmd/main.qmd` on 2026-08-11 is reproduced below **verbatim**, in the order it appeared
in the pre-edit file, with the line range it occupied and the reason it went.

**The ruling this pass executes.** The author ruled that §6 is *not an empirical paper*: it is an
illustration of the estimator, not an empirical contribution. §6 is streamlined to four beats —
the instrument at $\mathsf L=4$ with the reason, the estimator on this panel, the bootstrap, and a
short close. Everything else comes out. The empirical attribution of an A1 violation to particular
instrument cells is **withdrawn**, at every site that carried it: the abstract, §1's fourth
contribution item, §6.3, §7, and the head-of-file structure comment.

**Restoring a passage.** Copy the fenced block back into `main.qmd` at the position its heading
names. Two cautions:

1. Several passages carry numbers that were already known stale before this pass — see
   `quality_reports/claim_source_map_panel-npiv-discrete-section6.md` §11 and §14.9. Restoring the
   prose does **not** restore its correctness. In particular the per-cell $p$-values
   $0.062 / 0.005 / 0.003$ and the moment-norm ratios $2.2 / 3.2 / 4.4$ below are a $B=400$-era
   vintage two artifacts old; the current artifact
   (`quality_reports/sim/localise_four_cell.md`, $B=2000$, $\varepsilon_\varrho=0.01$) carries
   $0.0785 / 0.0025 / 0.0015$ and $2.0 / 3.4 / 3.8$, and its own text records that the ordering of
   the two chronic cells **flips** when only the null draws change and therefore is not identified
   at this $B$.
2. Restoring a float means restoring its `\input` as well. The table files themselves were **not
   deleted** — every one is still in `paper/tables/`.

**A pre-edit copy of the whole file** was taken to the session scratchpad
(`main.qmd.pre-streamline`) before any edit. That copy is ephemeral; this file is the durable one.

---

## Abstract — the closing localisation sentence

**Source:** `paper/qmd/main.qmd`, lines 18-20 (pre-edit numbering, file of 2800 lines backed up before this pass).

**Cut because:** It asserts the empirical attribution the ruling withdraws. Replaced by a sentence describing §6 as an illustration. INV-5 (abstract ≤ 150 words) was re-checked after the replacement.

~~~~~~
  not identification. A hedonic application splits a regulatory designation into
  four cells and attributes the failure of conditional independence to the two
  that mark chronic pollution, not to the transient one.
~~~~~~

## Head-of-file structure comment — the §6 block

**Source:** `paper/qmd/main.qmd`, lines 43-67 (pre-edit numbering, file of 2800 lines backed up before this pass).

**Cut because:** It records §6.3 as carrying "the section's headline" and prints the withdrawn $p$-values. The comment's own text notes it had been wrong twice and was on its third retype; letting it stand would have made it wrong a fourth time.

~~~~~~
       6 Empirical application          <- RE-RUN 2026-08-10 on a FOUR-CATEGORY
                                          trigger instrument, sans-L = 4.
                                          Hedonic: the Chay-Greenstone county
                                          panel, n = 983, T = 2, first
                                          differenced.  Section 6.3
                                          (sec:app-localise) carries the
                                          section's headline: the A1 violation
                                          is attributed to the two CHRONIC
                                          designation cells (p = 0.005, 0.003)
                                          and not to the transient one
                                          (p = 0.062).  The designation
                                          mismatch and d_Z against n were closed
                                          by the author, and the record is
                                          quality_reports/decisions/section6-instrument-and-dz.md.
                                          THIS LINE HAS BEEN WRONG TWICE, AND
                                          THIS IS THE THIRD RETYPE.  Through
                                          2026-07-31 it read "CFF has one; WE DO
                                          NOT"; then "the two open questions that
                                          keep it unwritten"; then "DRAFTED
                                          2026-08-03 ... whose instrument is
                                          binary", which the Phase-9 re-run
                                          falsified.  Each was true when written
                                          and none was retired when it stopped
                                          being true, which is the defect species
                                          this project keeps producing.
~~~~~~

## §1 — the fourth contribution item

**Source:** `paper/qmd/main.qmd`, lines 296-312 (pre-edit numbering, file of 2800 lines backed up before this pass).

**Cut because:** Named for removal in the brief. Its closing sentences put §6's withdrawn attribution forward as the item's payoff. NOTE: this item is also the introduction's only statement of prp:localise, which remains a theorem in §2 and remains one of the five results listed in §7, and the abstract still says "The extra cells buy localisation and not identification". Those three sites are flagged in the pass report; if the item should return in theory-only form, this block is the text to cut it from.

~~~~~~
Fourth, what the extra cells buy, which is not identification. \Cref{prp:localise}
shows that under A1 every set of instrument cells admits a common $\varphi$, so a
conflict between two cells refutes A1 and localises the refutation to the cells
that carry it. What the extra cells do not buy has to be said with it, because
each of the three is easy to assume. They do not buy identification: a coarsening
of $W$ imposes fewer restrictions, so A1b(iii) at a coarsening together with A1
implies A1b(iii) at the full instrument, and a finer instrument makes the
identification hypothesis weaker rather than stronger. They do not buy
testability, which is already present at $\mathsf L=2$, where the restriction is a
continuum of equations against one unknown function. And they do not buy
instrument strength, since splitting an instrument creates no variation. What
cannot be posed at $\mathsf L=2$ at all is the question of which cell carries a
violation, and \cref{prp:localise}(iv) is vacuous there rather than merely weak.
Section 6 puts that to work: reading the regulatory designation as the pair of
triggers that generates it gives four cells, and the violation is attributed to
the two that mark chronic pollution, at $p=0.005$ and $p=0.003$, and not to the
transient one, at $p=0.062$.
~~~~~~

## §6 opener — the clause pointing at sec:app-localise

**Source:** `paper/qmd/main.qmd`, lines 1796-1800 (pre-edit numbering, file of 2800 lines backed up before this pass).

**Cut because:** The subsection it points at is deleted. Replaced by a clause giving the methodological reason for reading the designation at $\mathsf L=4$.

~~~~~~
linearly, and we relax that here, on a two-period county panel whose instrument
is discrete because the regulation that generates it is a rule on thresholds. The
designation is usually read as a single indicator; we read it instead as the pair
of triggers that produces it, which gives $\mathsf L=4$ cells, and
\cref{sec:app-localise} is what that reading buys.
~~~~~~

## §6 — the structure comment (ARTICLE / SUPPLEMENT float roll)

**Source:** `paper/qmd/main.qmd`, lines 1737-1787 (pre-edit numbering, file of 2800 lines backed up before this pass).

**Cut because:** Its ARTICLE roll names tab:app-misclass and tab:app-feasibility, both of which leave the article in this pass, and it describes §6's floats under the old six-subsection shape. Retyped against the four-beat structure.

~~~~~~
<!-- ===================================================================
     SECTION 6. WHAT THIS SECTION KEEPS IN THE ARTICLE, AND THE RULE.

     The rule is Section 5's, applied unchanged: a float stays in the ARTICLE
     iff it carries one of the section's headline findings; floats that carry
     design validation, cell-level detail underneath a summary, or the
     diagnostics of how a number was produced go to the SUPPLEMENT and are
     named there by number in this text.  Section 5's own supplement opener
     states that rule in those words, so Section 6 does not invent one.

     ARTICLE (four tables, one figure), because each carries a headline finding
     a reader must be able to check here:
       tab:app-firststage   is the instrument relevant, and what does the linear
                            specification say about the same contrast
       tab:app-misclass     the identification evidence.  RETYPED 2026-08-11:
                            this line read "including the probe that rejects
                            A1's own testable implication", which is a claim
                            the section no longer makes.  Probe 2 now prints
                            two labelled blocks -- the predecessor's
                            unconditional restriction, which the data rejects
                            at every stratification, and A1's conditional one,
                            which is reported with its size column and from
                            which the section declines to read A1 in either
                            direction
       tab:app-phi          the object of the section: the curve, the
                            illustrative band, the bootstrap's convergence
                            record, and the scale non-invariance in Panel C
       fig:app-phi          the same object drawn
       tab:app-feasibility  where n = 983 sits against this paper's own frontier

     SUPPLEMENT (nine tables, two figures), Tables S15-S23 and Figures S4-S5:
     sample construction, descriptives, balance, overlap, the d_Z ladder, the
     estimator diagnostics, the fifteen tuning arms, the five resampling
     schemes, the operator norm by coordinate, the ladder drawn, and the
     discrepancy paths.  Counts and page numbers in this comment are as of
     2026-08-05; they have gone stale twice, so treat the rendered documents as
     authoritative and this note as intent only.  The
     ladder in particular is a SENSITIVITY AXIS here rather than the headline,
     because the object of this application is varphi and not theta.  That is
     the framing decision recorded in
     quality_reports/decisions/section6-instrument-and-dz.md and in the results
     summary, and the section states it in its own voice below.

     RESOLVED 2026-08-05.  Three references here were once named in prose and
     not \cite'd, because Chay & Greenstone (2005), Cropper, Muller, Park &
     Perez-Zetune (2023) and Monard, Nickl & Paternain (2021) had no key in the
     bibliography this document loads.  All three keys now exist in
     quality_reports/literature/panel-npiv-discrete/references.bib and all three
     are cited.  The per-site "what to add" comments below are likewise spent.
     Kept as a record of why the prose names them so fully in the first place.
     =================================================================== -->
~~~~~~

## §6.2 The instrument — the imputation and non-differential-misclassification passage

**Source:** `paper/qmd/main.qmd`, lines 1901-1947 (pre-edit numbering, file of 2800 lines backed up before this pass).

**Cut because:** Compressed, not deleted. The fact that the county designation is an imputation of an AQCR-level rule, and the condition under which it remains admissible, is part of what the instrument IS and survives in one short paragraph with the cropper2023 citation. The third paragraph here — the strategic-monitor-siting channel, citing murphy2016 and grainger2019 — goes with the probes it introduced, since it exists to motivate evidence the section no longer brings.

~~~~~~
The designation in hand is not the designation that was made. Between 1972 and
1978 nonattainment status under the Clean Air Act was assigned at the level of
the Air Quality Control Region, and the county-level variable in this file is an
imputation from monitor readings.

<!-- KEY ADDED 2026-08-03 from the RFF working paper, read on disk. The entry is
     the WORKING paper; the published J. Env. Econ. Manage. 121, 102867 fields
     were never read off an object and are deliberately not asserted. See the
     entry's own note in references.bib. -->
\citet{cropper2023} quantify the discrepancy, and their finding is more
favourable to the county variable than its reputation. The two definitions
disagree about which counties are treated on a scale that is not a rounding
error: under the official designation only $14.6$ and $19.4$ per cent of their
two panels are in attainment, against $59.7$ and $64.4$ per cent under the
county-level definition. Yet the estimated effect keeps its sign and its order of
magnitude. The average reduction in total suspended particulates is $10.2$ and
$9.1\,\mu$g/m$^{3}$ under the official designation and $6.0$ and $7.7$ under the
county-level definition this section adopts, attenuations of $41$ and $15$ per
cent rather than reversals, and on that comparison they write that the
county-level result is one they "find reassuring". The question they leave open
is not whether the county variable is a valid treatment but which of the two
guided policy, since whether counties inside a nonattainment region but not
themselves in violation felt the same pressure "is unknown".

That pattern is the one non-differential misclassification predicts. A
mislabelling that is independent of the error attenuates the instrument, leaving
it weaker and still valid, and a large disagreement in labels alongside a
same-signed estimate that shrinks without reversing is what attenuation looks
like. So the
condition under which using the imputed designation is admissible is
non-differential misclassification: the imputation may mislabel a county, but the
probability that it does so must not depend on $\Delta U$ given $\Delta Z$. Under
that condition $W$ remains a valid instrument and is merely less relevant, and A1
survives. Under the alternative the estimator is inconsistent rather than
imprecise, so no sample size repairs it.

\emph{The same paper supplies the channel by which the condition could fail, and
we state it rather than stopping at the half that suits us.} Their Figures~2 and
3 show that monitors entering the panel read lower than monitors continuously in
operation and monitors about to be retired read higher, which they read as
"the possibility of strategic placement of monitors to reduce TSP readings",
after \citet{murphy2016} and consistent with \citet{grainger2019}. A county's
imputed label is a function of its monitor readings, so if siting responds to the
same local pressures that move property values, the mislabelling is differential
and the attenuation reading fails. Nothing in their evidence or ours settles
that. We make the case rather than assume it, and only one of the probes below
carries it.
~~~~~~

## §6.2 The instrument — the three-probe misclassification battery

**Source:** `paper/qmd/main.qmd`, lines 1949-2027 (pre-edit numbering, file of 2800 lines backed up before this pass).

**Cut because:** Named for removal in the brief: probe 1 (Wald-ratio constancy), probe 2 (residual-CDF contrast, blocks (a) and (b), including the passage retyped last pass under the A1-untestability ruling), probe 3 (flexible control for baseline particulates). The section keeps the instrument's construction and drops the diagnostics. This is the sole citation site of mastentorgovitsky2014, and the \nocite{masten2016} that supported it goes with it.

~~~~~~
Three probes bear on it (\cref{tab:app-misclass}). The third runs our way. The
channel the contrary literature names is that designation tracks the pre-period
level of particulates and that the level mean-reverts, so a reduced form
generated by that channel should collapse once the baseline level is controlled
flexibly. It does not: the coefficient on $W$ is $0.0462$ with no control for
$X_1$, and $0.0467$, $0.0524$ and $0.0507$ under polynomials of degree one, two
and three.

The first probe settles nothing, and we report it as settling nothing.
Differential misclassification would induce heterogeneity in the Wald ratio
across strata, and homogeneity is not rejected in any of three stratifications
($p=0.195$, $0.291$ and $0.169$). The within-stratum first stages collapse,
however, at $F=1.7$ in the top baseline-particulate quartile, $0.0$ in the West
and $0.0$ in the third manufacturing quartile, where the ratio is $394.55$ with
a standard error of $4{,}074$. A homogeneity test on ratios whose denominators
are near zero has essentially no power, so this is a non-rejection and not
evidence of constancy.

The second probe splits in two, because the restriction the predecessor's model
imposes and the restriction A1 imposes are different and this data answers them
differently. Block (a) of \cref{tab:app-misclass} contrasts the smoothed
conditional distribution functions of the fitted residual at $W=1$ and at $W=0$
within each stratum and refers a weighted Cramér--von Mises statistic to
$2{,}000$ permutations of $W$ within stratum. That is a test of
$\Delta U\upmodels W$, which is the predecessor's restriction and not this
paper's, and it rejects at every cut of the sample: $p<0.001$ unconditionally,
$p=0.014$ by baseline-particulate quartile, $p=0.003$ by census region, and
$p<0.001$ by manufacturing and by income-growth quartile. Size is not at stake
in that block: its null is an exact permutation of $W$, with no estimated
propensity in it.

That block is a result the paper needs rather than one it survives. A rejection
there is what A1 itself predicts once $\varrho(\Delta Z)$ varies inside a
stratum, and the strata here are one cell or four against a $\Delta Z$ with six
coordinates, so the evidence runs against the unconditional restriction and not
against the conditional one. \emph{Through an earlier draft this was the only
contrast the probe formed, and the paper reported it as a test of A1.} It was
never one. Both restrictions are now computed and both are labelled.

Block (b) is A1's restriction. It contrasts the residual against
$W-\hat\varrho(\Delta Z)$, the sample counterpart of $\widetilde W$, and draws
the null as $W^{*}\sim\mathrm{Bern}(\hat\varrho(\Delta Z))$ independent of
everything else, which is the conditional law A1 asserts. It rejects at five per cent at all five
stratifications: $p=0.015$ unconditionally, $p<0.001$ by baseline-particulate
quartile and by census region, $p=0.044$ by manufacturing quartile and
$p=0.002$ by income-growth quartile. Four of the five rows do not have nominal
size and \cref{tab:app-misclass} marks them. The mechanism is $\hat\varrho$:
under the null draw $W^{*}-\hat\varrho$ is mean zero given $\Delta Z$ by
construction, while the observed $W-\hat\varrho$ is mean zero only where
$\hat\varrho$ is right, so a stratification built from $\Delta Z$ compares the
observed statistic against a reference the observed $W$ does not obey.
Simulated at $n=983$ against a design in which A1 holds by construction, at a
nominal five per cent, such a stratification rejects a true A1 at $0.698$ under
a homogeneous first stage and at $0.708$ under the heterogeneous one
\citet{mastentorgovitsky2014} document for this instrument on this data, and the
unstratified cut rejects at $0.250$ under the second.<!-- THE \nocite BELOW IS
     LOAD-BEARING AND NOT A STRAY.  The `mastentorgovitsky2014' entry's own note field
     contains \textcite{masten2016}, so citing the working paper puts an
     unresolved key into the printed bibliography unless the published note is
     also in it.  The first build after this citation was added reported exactly
     that: "Citation `masten2016' undefined" twice, both inside the bibliography.
     The two entries are NOT interchangeable -- the Chay-Greenstone application
     survives only in the 2014 working paper -- so the fix is to carry both, not
     to re-point the \citet.  See the bib entry's own header note. -->
\nocite{masten2016} Only the
baseline-particulate quartile holds its level in both, at $0.042$ and $0.052$,
and the reason is mechanical: stratifying on baseline pollution groups counties
of similar instrument strength, because strength tracks baseline. That row also
carries the largest statistic in the block, at $136.30$ times its null median.

Neither block settles A1, and what stops them is the construction rather than
the answers. $\Delta\hat U$ is not an observable. It is the residual of a fit
that imposes A1, both reference distributions hold it fixed while $W$ is
redrawn, and it was built at the realised $W$, so the same $W$ enters the
statistic and the object the statistic is computed on. Block (b) carries a
second: its null is drawn from $\hat\varrho$, so its $p$-values refer to A1
together with correct specification of the propensity, and this sample separates
the two nowhere. We report the block and decline to read A1 off it in either
direction.
~~~~~~

## §6.2 The instrument — the tab:app-misclass float and its notes

**Source:** `paper/qmd/main.qmd`, lines 2029-2088 (pre-edit numbering, file of 2800 lines backed up before this pass).

**Cut because:** The float carries the probes only. `paper/tables/app_tsp_misclass.tex` is NOT deleted; it is orphaned from main.qmd and is not \input by supplement.qmd either.

~~~~~~
::: {.content-visible when-format="pdf"}
```{=latex}
% 424.4pt wide and 357.6pt tall at \footnotesize and the stock 6pt \tabcolsep,
% against a \textwidth of 469.8pt and a \textheight of 650.4pt.  Fits upright
% with the caption and the notes.  Measured.
\begin{table}[!htbp]
\centering
\begin{threeparttable}
\caption{Three probes of the imputed designation}
\label{tab:app-misclass}
\footnotesize
\input{../tables/app_tsp_misclass}
\begin{tablenotes}\footnotesize
\item \textit{Notes:} Chay--Greenstone county panel, $n=983$. Probe 1 splits the
sample and reports, within each stratum, the first-stage coefficient of $\Delta
X$ on $W$, its $F$ statistic, and the just-identified Wald ratio scaled by
$10^{3}$ with its standard error; the homogeneity statistic tests the four
ratios against a common value. Its $F$ column is printed beside the ratios
because the ratios are what the test consumes and two of the strata have
first stages indistinguishable from zero. Probe 2 reports two hypotheses at each
stratification, both computed from the fitted residual $\Delta\hat U$ of the
headline fit and both summarised by a weighted Cramér--von Mises statistic,
printed as a ratio to its own null median. Block (a) contrasts the smoothed
conditional distribution functions of $\Delta\hat U$ at $W=1$ and at $W=0$
within stratum and refers the statistic to $2{,}000$ permutations of $W$ within
stratum; it tests $\Delta U\upmodels W$, the unconditional restriction of the
predecessor model. Block (b) contrasts $\Delta\hat U$ against
$W-\hat\varrho(\Delta Z)$, the sample counterpart of $\widetilde W$, and refers
the statistic to $2{,}000$ draws of
$W^{*}\sim\mathrm{Bern}(\hat\varrho(\Delta Z))$; it tests A1.
\emph{The ``Valid size'' column marks whether the block-(b) reading attains its
nominal level at that stratification}, judged by simulating this probe at
$n=983$ against a design in which A1 holds by construction: a stratification
that is a function of $\Delta Z$ inherits whatever $\hat\varrho$ gets wrong in
that direction while the null draw does not, and rejects a true A1 about seven
times in ten against a nominal five per cent. The column is ``--'' on the
block-(a) rows, whose null is an exact permutation of $W$ given $\Delta\hat U$
with no estimated propensity in it. Both reference distributions hold
$\Delta\hat U$ fixed while $W$ is redrawn, and $\Delta\hat U$ was built using
the realised $W$, so a rejection is conservative and a non-rejection is weak
evidence; block (b)'s null is in addition drawn from $\hat\varrho$, so its
$p$-values refer to A1 jointly with correct specification of the propensity.
\Cref{sec:app-localise} reports a separate cell-by-cell diagnostic on the
four-category fit, which returns an attribution rather than a verdict. Probe 3
reports the reduced
form of $\Delta Y$ on $W$ with a polynomial in baseline particulates $X_1$
entered as an additional control, at the five-control set. Table S18 of the
supplement reports the overlap diagnostic for A4(i) alongside these probes; it
is worth reading beside probe 2, because the two conditioning sets that break
overlap outright are the two that condition on the variable the designation rule
thresholds. Sources:
\texttt{scripts/application/app\_tsp\_01\_diagnostics.R} for probes 1 and 3 and
\texttt{app\_tsp\_02\_ladder.R} for probe 2, with the size simulation behind the
fourth column in \texttt{scripts/simulations/sim\_probe2\_size.R}; table
\texttt{paper/tables/app\_tsp\_misclass.tex}.
\end{tablenotes}
\end{threeparttable}
\end{table}
```
:::
~~~~~~

## §6.3 Which cells carry the violation {#sec:app-localise} — the entire subsection

**Source:** `paper/qmd/main.qmd`, lines 2090-2159 (pre-edit numbering, file of 2800 lines backed up before this pass).

**Cut because:** The empirical attribution the ruling withdraws. Two of its measurable premises had also failed before the ruling: the p-values it prints are a B=400 vintage, and at B=2000 the ordering of the two chronic cells is not identified. Its A4(i) feasibility material and its 983-of-983 designation agreement are NOT lost — both were moved into the new beat 1 and re-sourced at the ruled eps_varrho = 0.01.

~~~~~~
## Which cells carry the violation {#sec:app-localise}

The designation rule fires on either of two triggers. A county is designated if
its annual geometric mean exceeds the standard, or if its second-highest daily
reading does, and $298$ of the $983$ counties are designated on one or the
other. Reading $W$ as the pair of triggers rather than as their disjunction
gives a four-valued instrument: $685$ counties trigger neither, $114$ the
bad-day rule alone, $66$ the annual mean alone, and $118$ both. The four cells
are ordered in baseline particulates, at $58.0$, $73.3$, $79.9$ and
$97.8\,\mu$g/m$^3$, and in the decadal change, at $-7.1$, $-13.7$, $-9.9$ and
$-21.0$. The refinement is exactly that: a county is designated in the binary
reading if and only if it lies outside the first cell, at all $983$
observations.

A4(i) survives the refinement. The multinomial propensity, fitted on the
five-control set and projected onto the truncation set of \cref{def:hatT},
returns $\min_l\hat\varrho_l=0.0115$ against the $1/\mathsf L=0.25$ the
assumption allows, with a single county at the floor and that county in the
$66$-observation cell. The implied covariance clears the bound of
\eqref{eq:omegafloor} with room, at $\lambda_{\min}(\hat\Omega)=0.0113$ against
$\varepsilon_\varrho/\mathsf L=0.0029$. No cells need merging, which matters
because merging strengthens A1b(iii) and forfeits the localisation the cells
exist for.

The slope is unmoved. At the headline control set the four-category instrument
returns $\hat\theta_{\Delta\mathrm{TSP}}=0.6777$ against $0.6789$ binary, a
difference of $0.0012$. That is the expected direction of no effect rather than
a null result: the surplus contrasts are additional restrictions on the same
$\varphi^\dagger$, so under A1 they buy precision and localisation, not a
different answer, and a large shift would have been evidence against either the
binary estimate or the generalisation.

What the cells buy is the attribution. \Cref{prp:localise} says the
$\mathsf L-1$ cell systems agree at a common $\varphi$ under A1, so the
per-cell moments decompose a violation onto the cells that carry it. Computed
at the common fit and referred to $400$ draws of $W$ from the fitted propensity,
which imposes A1 by construction while holding the conditioning fixed, the three
contrasts separate: $p=0.062$ for the bad-day cell, $p=0.005$ for the
annual-mean cell, and $p=0.003$ for the cell that triggers both. The moment
norms stand at $2.2$, $3.2$ and $4.4$ times their null medians, in that order.

The ordering is the one the mechanism predicts. A county designated on its
annual mean is designated for a chronic condition, and chronic pollution is a
function of the baseline level $X_1$, which is the variable the differenced
error inherits through the initial condition. A county designated on a single
bad day is designated for a transient spike, which carries much less information
about the level. So the two cells that reject are the two whose designation is
close to a function of $X_1$, and the cell that does not reject is the one whose
designation is closest to an accident of timing. The cell that fires on both
triggers is the most chronic of the three and carries the largest violation.

Three limits belong with that reading, and the first is the one an applied
reader is most likely to overlook. \emph{Consistency is necessary for A1 and not
sufficient.} \Cref{prp:localise}(iii) detects an empty solution set and nothing
more, so a violation that some other $\varphi\in\mathcal V$ reconciles is
invisible to the diagnostic. The bad-day cell is therefore not exonerated by its
$p=0.062$; it is not convicted, which is a weaker statement, and the
false-negative rate of the attribution is not something we can price. Second,
the base cell carries no contrast of its own. It is recovered as
$1-\sum_l\varrho_l$ and is the reference the three contrasts are measured
against, so it cannot be tested separately. Third, three cells are tested at
once and no multiplicity correction is applied; the two chronic cells survive a
Bonferroni threshold of $0.017$ and the bad-day cell does not approach it from
either side.

The binary instrument cannot make any of these statements. With one contrast
there is one moment and one $p$-value, and A1 is either rejected on the sample
or it is not. The cells convert that verdict into a claim about where the
condition fails, and it fails where the paper's own account of the designation
rule says it should.
~~~~~~

## §6.4 What can be said about $\hat\varphi$, and what cannot — the entire subsection

**Source:** `paper/qmd/main.qmd`, lines 2161-2198 (pre-edit numbering, file of 2800 lines backed up before this pass).

**Cut because:** Named for removal in the brief. Three of its claims are limitations of the ESTIMATOR rather than of the withdrawn empirical claim, and those were moved into the bootstrap beat rather than lost — the pass report names the sentences. The rest, including the survey of what the two literatures do reach, is duplicated almost sentence for sentence in §7's fifth future-work item, which is untouched.

~~~~~~
## What can be said about $\hat\varphi$, and what cannot

Valid uniform inference on the nonparametric component of this model does not
exist, and the reason is worth stating precisely rather than as an absence.

Uniform confidence bands for ill-posed problems are built on a source condition
written in the spectral calculus of $T^\ast T$ and on completeness of the
instrument, and neither is available here. The operator equation of Section 2 is
nonlinear in $\varphi$, so there is no adjoint in which to write the condition,
and a $W$ with four values does not deliver completeness any more than a
two-valued one does
\citep[see][]{severini2006,babiiflorens2025}. Pointwise inference, on the other
hand, does exist for nonlinearly ill-posed conditional moment models.
\citet{chen2012b} give sieve Wald and quasi-likelihood-ratio confidence sets for
the evaluation functional, valid whether or not that functional is
$\sqrt n$-estimable. Their theory is indexed by a *deterministic* sieve
dimension, whereas the regularisation index of \cref{def:lfstep} is the random
stopping time of a discrepancy rule, and we are not aware of any procedure that
covers the second. The nearest work in the same model class stops at rates and
constructs no set at all \citep[see][]{dunker2014,dunker2021}.

<!-- RESOLVED 2026-08-05. `monardnicklpaternain2021' was present only in the
     sibling varphi-inference/references.bib, which this document does not
     \addbibresource. It has since been copied into the loaded bib and is
     \citet'd below. -->
The mathematical inverse-problems literature stops at the same boundary. Its
state of the art for nonlinear forward maps, \citet{monardnicklpaternain2021},
delivers a Bernstein--von Mises theorem for smooth *linear functionals* only,
obtained by linearising the map at the truth. Both literatures deliver valid
inference for the regular part and are silent beyond it, and that is where
\cref{thm:rootn} sits.

We therefore follow the convention of the companion paper
\citep{centorrinofeveflorens2019}, which estimates the same operator equation from
a discrete instrument under the same regularisation: a point estimate, a
bootstrap band drawn to show variability, and one sentence saying what the band
is not. *The band below illustrates the variability of $\hat\varphi$ and is not
a confidence set. No coverage is claimed for it and none is computed.*
~~~~~~

## §6.5 The estimated hedonic price function — the entire subsection, pre-rewrite

**Source:** `paper/qmd/main.qmd`, lines 2200-2338 (pre-edit numbering, file of 2800 lines backed up before this pass).

**Cut because:** REWRITTEN, NOT DELETED. Its curve description becomes the second half of beat 2 and its bootstrap material becomes beat 3. Archived whole because the rewrite reorders, compresses and re-labels it, and a sentence-level diff against the new text would not be readable. The figure float and its notes are included.

~~~~~~
## The estimated hedonic price function

\cref{fig:app-phi} draws $\hat\varphi$ at the five-control set, normalised at
the pooled median of $X$, and \cref{tab:app-phi} prints it at eleven percentiles
of the pooled distribution.

The curve is not monotone, and the sign the hedonic reading asks for is
delivered on part of the support and not on the rest. It runs from $-0.0081$ log
points at the 5th percentile of $X$, or $31.4\,\mu$g/m$^3$, to $-0.0059$ at the
95th, or $100.2\,\mu$g/m$^3$, and it rises at $33$ of its $59$ grid steps and
falls at $26$. It descends monotonically to $-0.0392$ at $45.7\,\mu$g/m$^3$, just
above the 20th percentile, climbs monotonically to $+0.0212$ at $67.4$, just
below the 70th, and falls again over the rest, at $15$ of the last $17$ steps, so
its whole range is $0.0604$ and its
largest sustained movement, at $+2.78\times10^{-3}$ log points per $\mu$g/m$^3$
between the trough and the peak, runs the wrong way for the hedonic reading.

The linear instrumental-variables slope on the same sample and the same controls
is $-5.519\times10^{-3}$ log points per $\mu$g/m$^3$, which over the
$68.8\,\mu$g/m$^3$ separating the 5th and the 95th percentiles is $0.380$ log
points. The nonparametric estimate's whole range is $0.0604$, which bounds its
movement between any two points of the support and is about one sixth of that;
between those same two percentiles it moves $0.0022$. It is nowhere as steep
either: its steepest single
descending step is $-3.23\times10^{-3}$, or $59$ per cent of the linear slope,
and every other descending step is flatter. *The two estimates therefore
disagree about the level of the gradient and not only about its shape.* What the
nonparametric estimator buys here is a negative result: the constant slope the
linear specification imposes is not a feature of $\hat\varphi$ at any point of
the support, and the sign it imposes fails over the half of the pooled
distribution that lies between the 20th and the 70th percentiles.

The band is wide against the curve it surrounds. At the 5th percentile of $X$
the fifth-to-ninety-fifth bootstrap envelope runs from $-0.0688$ to $+0.0274$, a
width of $0.0962$; at the 95th percentile it runs from $-0.0567$ to $+0.0517$, a
width of $0.1084$. The curve's entire range is $0.0604$, and over the whole
sixty-point evaluation grid the median width of the envelope is $0.0582$, so the
typical envelope is as wide as everything the curve does. It pinches to $0.0077$
near the anchor, where the normalisation puts it, and widens towards both tails,
at every one of the $29$ steps to its left and at $29$ of the $30$ steps to its
right. The envelope excludes zero at five of the eleven levels
\cref{tab:app-phi} prints, at the 20th, 30th, 40th, 60th and 70th percentiles,
and at $37$ of the $60$ grid points. We give those widths and those counts as a
description of the envelope and we draw no inference from them in either
direction: no coverage is claimed for the envelope, so the five exclusions are
not evidence that the sign of the hedonic gradient is pinned down anywhere, and
the six non-exclusions are not evidence that it is unidentified.

The bootstrap's own convergence record is in Panel B, and it does not explain
the width. All $99$ replications returned a finite curve, with no errors and no
non-finite values. The realised stopping index $\hat m_\varphi$ has median $28$
and ranges over $[1,235]$, well inside the admissible interval: $2$ replications
stopped at the first iteration, where $\hat\varphi$ *is* the initial condition
and the Landweber step contributed nothing, and none ran to the cap. Ninety-seven
of $99$ replications therefore returned a regularised estimate of $\vdagger$, and
the two that did not cannot be carrying the band: the envelope is the fifth and
ninety-fifth percentile of $99$ values, so it trims roughly five replications at
each edge and two of them cannot set either edge of it. Nor
is there any shrinkage to
attribute to them: the bootstrap median curve, drawn dashed in
\cref{fig:app-phi}, spans $0.0615$ against the point estimate's $0.0604$, or
$101.8$ per cent of it, and departs from the point estimate by at most $0.0074$ at
any grid point. *The width is what the estimator produces when it converges, not
the footprint of replications in which it failed to.* The level of the curve
remains unidentified separately from its shape, and the anchor's own standard
deviation across resamples is $0.63$.

Two mechanisms could produce a width like that, and separating them matters,
because one would make the width an artefact of the resampling scheme and the
other would make it a property of the estimator. A resample of $n$ counties with replacement
leaves roughly $37$ per cent of the draw as duplicates, which give the
integration operator repeated rows; it also halves the information, since
weights that are multinomial have Kish effective sample size $n/2$, here $492$.
The first mechanism is a defect of the scheme and the second is not.

A multiplier bootstrap separates them. Weights drawn i.i.d. $\mathrm{Exp}(1)$
have the same first two moments as multinomial weights and the same effective
sample size, $492$, but they duplicate nothing: every county enters every
replication with a positive weight, and the operator's rows are never repeated.
If duplication were the mechanism, the multiplier scheme would repair it. It
does not. Under $\mathrm{Exp}(1)$ weights $7$ of $99$ replications stop at
$\hat m_\varphi=1$ against $2$ of $99$ under the resample, more rather than
fewer, and the band narrows to $0.045$ from $0.058$ without approaching zero. A
little over a fifth off the width is what removing every tie in the design is
worth, and what remains is still three quarters of the curve's own range of
$0.0604$.

Information moves the stopping index where duplication does not. Drawing $492$
*distinct* counties without replacement, which matches the effective sample size
of both bootstrap schemes, gives $2$ of $24$ subsamples at $\hat m_\varphi=1$: at
$8.3$ per cent that is above the resample's $2.0$, so removing the ties at
matched information makes the degeneracy more common and not less. Drawing $621$,
the expected number of distinct counties in a resample of $983$, gives $0$ of
$24$ at a median stopping index of $19.5$ against the full sample's $28$. What
separates the healthy arm from the degenerate ones is how many counties they
carry and not whether those counties repeat. **The width of the
band is therefore a property of the estimator at this effective sample size, and
not an artefact of how the sample is resampled.** That is the less comfortable
of the two readings and it is the one the evidence supports; the five schemes are
compared in Table S22 of the supplement. It does not make the band valid, which
remains barred for the reason given above: the regularisation index is a random
stopping time.

::: {.content-visible when-format="pdf"}
```{=latex}
\begin{figure}[!htbp]
\centering
\includegraphics[width=0.92\textwidth]{../figures/app_tsp_phi.pdf}
\caption{The estimated hedonic price function and its variability}
\label{fig:app-phi}
\begin{minipage}{0.92\textwidth}\footnotesize
\textit{Notes:} $\hat\varphi(x)-\hat\varphi(x_{0.5})$ against mean total
suspended particulates, at the five-control set, on the $983$-county
Chay--Greenstone panel. The vertical axis is in log points of median property
value and the curve is normalised at the pooled median of $X$,
$58.0\,\mu$g/m$^3$, so the figure carries the shape of the price function and
not its level. The solid line is the point estimate and the dashed line the
median of $99$ bootstrap replications; the two track each other to within
$0.0074$ log points everywhere on the grid, which is the absence of shrinkage
discussed in the text, and only $2$ of those $99$ replications stopped at the
first iteration without iterating at all. The two shaded regions are the
twenty-fifth-to-seventy-fifth and fifth-to-ninety-fifth percentiles of the
replications at each evaluation point, the outer one bounded by dotted lines.
\emph{They illustrate variability and are not confidence sets; no coverage is
claimed for them and none is computed}, following
\citet{centorrinofeveflorens2019} for the same estimator on the same equation.
The rug at the foot marks the county-level marginal distribution of $X$ in each
of the two periods, so the thinning of the $1980$ rug above
$80\,\mu$g/m$^3$ is where the right-hand tail of the curve is supported by few
counties. The levels drawn are tabulated in \cref{tab:app-phi}, and the
magnitudes are those of $\hat\varphi$ in the pooled-rank coordinate of that
table's Panel C. Source:
\texttt{scripts/application/app\_tsp\_02\_ladder.R} and
\texttt{app\_tsp\_05\_phi\_band.R}; figure
\texttt{paper/figures/app\_tsp\_phi.pdf}.
\end{minipage}
\end{figure}
```
:::
~~~~~~

## §6.6 The curve is not invariant to the coordinate $X$ is measured in — the entire subsection

**Source:** `paper/qmd/main.qmd`, lines 2340-2423 (pre-edit numbering, file of 2800 lines backed up before this pass).

**Cut because:** Named for removal in the brief. Panel C of tab:app-phi, which is the measurement behind it, still prints, so the table's notes retain a factual one-sentence description of what Panel C computes (INV-1); the argumentative reading is gone. `app_tsp_opnorm.tex` loses its only mention in main.qmd but keeps its supplement float.

~~~~~~
## The curve is not invariant to the coordinate $X$ is measured in

The estimator does not see $X$ in $\mu$g/m$^3$. It sees the pooled empirical
distribution function of $\{X_1,X_2\}$ mapped onto $[0,1]$, which is the
coordinate the implementation registers as choice C2 of
`app_tsp_common.R`'s tuning register, a different register from this paper's
assumption tags, and in particular not the condition C2$'$. That map is strictly increasing, so
$\vdagger\circ T^{-1}$ is the structural function in the new coordinate and
$\theta_\dagger$ is unchanged; on the theory's own terms nothing has been
assumed. On this data it is not innocuous.

Panel C of \cref{tab:app-phi} recomputes the same normalised curve in two other
strictly increasing coordinates, $\mu$g/m$^3$ itself and a min--max rescaling to
$[0,1]$. Against the baseline the normalised curve moves by up to $0.036$ in absolute
value in both, at a root-mean-square deviation of $0.017$. That is $60$ per cent
of the curve's own total range of $0.0604$, and $1.07$ bootstrap standard
deviations at the point where the movement is largest. The shape moves with it:
the baseline rises at $33$ of its $59$ steps and both alternatives at $39$.
\emph{The two alternative arms agree with each other to $2.5\times10^{-4}$ at
every grid point}, two orders of magnitude finer than either agrees with the
baseline, and the reason is in the maps rather than in the estimates. The
min--max rescaling is an affine function of $\mu$g/m$^3$, so those two arms are
one coordinate at two scales, while the pooled rank transform is the only
genuinely different map of the three. What Panel C measures is therefore one
departure and not two, and what it isolates is the estimator's response to the
nonlinearity of the coordinate rather than to its units.

*Magnitudes therefore cannot be reported as invariant features of the data.*
What \cref{fig:app-phi} and Panel A of \cref{tab:app-phi} report are magnitudes
of $\hat\varphi$ in the pooled-rank coordinate, and we say so here rather than
leave it to be inferred from a tuning table.

Two measured facts bear on how that indictment should be read, and neither
softens it. The first is that all three arms iterate. In both the $\mu$g/m$^3$
and the min--max coordinate the second stage stops at $\hat m_\varphi=17$,
against $28$ in the baseline, so all three curves are regularised estimates and
none is its own initial condition; the coordinate-dependence is a property of
the estimator and not of where it was started.
\emph{These three are the $\varphi$-step index on the full sample,
and they are not the medians over fold solves that Table S21 of the supplement
reports for the same three arms}; that table's $\theta$-step is a different
computation, at medians of $16$, $10$ and $9$ over $30$ fold solves, with no
solve reaching the cap in any of the three.

The second is that the two
alternative arms' bands are narrow and not wide. On $25$ paired bootstrap draws
the band width is $0.026$ and $0.027$ against the baseline's $0.063$, factors of
$2.4$ and $2.3$. \emph{We report that inversion and we do not explain it.} The
one candidate we can test is that holding $\hat\theta$ fixed
across draws is what widens the baseline band, and Panel B's last block rules it
out: re-estimating $\theta$ inside each of the same $25$ draws, with the
coordinate untouched, moves the baseline band to $0.0638$ from $0.0631$, wider by
$0.0007$ and leaving the factor of two where it was. Nothing else we measure
separates the three arms on this axis, and we would rather leave the fact
standing than attach to it an account the numbers do not carry.

The coordinate is independently documented as a substantive choice rather than a
cosmetic one, and the documentation predates any estimate. Table S23 of the
supplement measures why. In $\mu$g/m$^3$ the composite operator's squared norm
is $5.7\times10^{4}$, against $2.48$ in the coordinate we use and $0.312$ in the
min--max one. Landweber converges only for a relaxation below
$2/\|A\|^{2}$, here $3.5\times10^{-5}$, and the default of $0.5$ exceeds that by
a factor of $1.4\times10^{4}$. This is the scale that \eqref{eq:normconst}
removes from the theory by running the iteration on a normalised operator; the
implementation has to achieve the same thing numerically, and the coordinate is
how it does. \emph{What the default step then produces does not track the
bound.} The largest fitted $|\Delta\hat\varphi|$ is $0.646$ log points of
property value in $\mu$g/m$^3$, which breaks the bound by four orders of
magnitude, and $0.45$ in min--max, which respects it by one; the two differ from
each other by a factor of $1.4$. Both are large against the $0.0769$ of the
coordinate we use, and the convergence condition, which only one of them breaks,
does not separate them from each other.
Neither does stopping: Table S23 runs $101$ and $97$ iterations against the
baseline's $23$, and that count is a diagnostic budget rather than the
$\varphi$-step index of the preceding paragraph, which is $17$, $17$ and $28$.
What the table does establish is that the coordinate moves the operator's squared
norm across five orders of magnitude, and that the baseline is the only one of
the three in which the default step sits inside the convergence bound and the
fitted amplitude stays under a tenth of a log point. That much is measured; an
account that assigns the amplitude to the bound is not, and we do not offer one.
The coordinate is therefore a regularisation choice and not
a normalisation, and $\hat\varphi$'s magnitudes are conditional on it. We would
rather record that than report a curve in units a reader will assume are the
physical ones.
~~~~~~

## §6 — the tab:app-phi float and its notes, pre-rewrite

**Source:** `paper/qmd/main.qmd`, lines 2425-2490 (pre-edit numbering, file of 2800 lines backed up before this pass).

**Cut because:** REWRITTEN, NOT DELETED. The float survives into beats 2 and 3; the notes were retyped to drop the coordinate argument while keeping a factual description of Panel C.

~~~~~~
::: {.content-visible when-format="pdf"}
```{=latex}
% ROTATED AND SET IN \tiny, AND BOTH ARE MEASURED RATHER THAN CHOSEN.
% Nine columns whose first entry is a Panel B label as long as "Share at
% m_phi = 1: resample of n / subsample of 621", and whose seventh is "Band
% width, 25 paired draws".  Natural widths, at the shipped artifact, which is
% not edited to fit:
%       \footnotesize 6pt  846.0pt      \footnotesize 3pt  798.0pt
%       \scriptsize   3pt  687.0pt      \scriptsize   1pt  655.0pt
%       \tiny         3pt  604.0pt
% Upright the budget is \textwidth = 469.8pt and nothing reaches it; rotated it
% is \textheight = 650.4pt, which \scriptsize still misses at every \tabcolsep
% down to 1pt.  \tiny at 3pt is the first setting that fits, at 604.0pt, and it
% is 208.4pt tall so the caption and the notes have 261pt of the rotated frame.
% \resizebox was rejected for the reason it is rejected at tab:sim-stopping and
% tab:sim-h-verdict: it would scale the table's type away from the notes' type,
% and the notes are where INV-1 lives.
\begin{sidewaystable}[p]
\centering
\begin{threeparttable}
\caption{The estimated hedonic price function, its bootstrap variability, and
its dependence on the coordinate}
\label{tab:app-phi}
\tiny
\setlength{\tabcolsep}{3pt}
\input{../tables/app_tsp_phi}
\begin{tablenotes}\footnotesize
\item \textit{Notes:} Chay--Greenstone county panel, $n=983$, at the
five-control set. Panel A evaluates $\hat\varphi(x)-\hat\varphi(x_{0.5})$ at
eleven percentiles of the pooled distribution of $\{X_1,X_2\}$, normalised at
its median $x_{0.5}=58.0\,\mu$g/m$^3$; the ``TSP'' column is the particulate
level in $\mu$g/m$^3$ at that percentile, and the last two columns count the
counties within $\pm5\,\mu$g/m$^3$ of it in each period, so a row supported by
few counties is visible as such. The bootstrap columns summarise $99$
replications that resample counties with replacement and re-select the stopping
index in each; the envelope is the $5$th and $95$th percentile of the
replications at that level. \emph{The envelope illustrates variability and is
not a confidence set. No coverage is claimed for it and none is computed}, which
follows \citet{centorrinofeveflorens2019} for the same estimator on the same
equation. Panel B records the design and what it returned: $\hat m_\varphi$ is
the realised Landweber--Fridman stopping index and $\bar m=2{,}000$ the cap.
\emph{That cap is a hand-set computational budget and not the $\bar m_n$ of
\eqref{eq:cap}}, which Section 5 measures at $114{,}738$ to $1{,}574{,}253$ and finds
inflated against the operator norm by three to four orders of magnitude; the two
are different objects and only the first bounds the runs reported here. Panel B
also records how many replications were retained at each end of that range; a
replication retained at $\hat m_\varphi=1$ returned its initial condition
unchanged. Its last block re-estimates $\theta$ inside each of $25$ draws rather
than holding $\hat\theta$ fixed, and the resulting band on those same draws is
slightly wider, $0.0638$ against $0.0631$. Panel C recomputes the whole normalised
curve in two further strictly increasing coordinates and compares it to the
baseline pooled-rank coordinate pointwise over the $60$-point grid:
``Max $|\Delta|$'' and ``RMS $\Delta$'' are in log points, the two ``/SD''
columns divide them by the bootstrap standard deviation at the same point,
``Steps up'' counts the grid steps on which the curve rises, and the last column
is the band width on $25$ paired draws. A strictly increasing reparameterisation
leaves $\vdagger\circ T^{-1}$ structural and $\theta_\dagger$ unchanged, so
Panel C measures the estimator's dependence on the coordinate and not a change
of model. Source:
\texttt{scripts/application/app\_tsp\_05\_phi\_band.R}; table
\texttt{paper/tables/app\_tsp\_phi.tex}.
\end{tablenotes}
\end{threeparttable}
\end{sidewaystable}
```
:::
~~~~~~

## §6.7 The control set, and where $n=983$ sits against the frontier — the entire subsection

**Source:** `paper/qmd/main.qmd`, lines 2492-2603 (pre-edit numbering, file of 2800 lines backed up before this pass).

**Cut because:** Named for removal in the brief. Its frontier verdict — that no rung of the ladder both satisfies A4(ii) and clears eq:frontier, so cor:ratefloor and not thm:rootn describes this run — survives in two sentences of the new close.

~~~~~~
## The control set, and where $n=983$ sits against the frontier

We report $\hat\theta$ along a ladder of control-set sizes,
$d_Z\in\{0,5,10,22\}$, ordered by how far each block is from being an outcome of
house prices: an intercept alone, then five core hedonic demand shifters, then
five demographic variables, then the housing-stock and local-fiscal blocks,
whose per-capita property-tax revenue is mechanically a function of the
dependent variable. The rungs were fixed on that principle and not chosen to
flatter an estimate. The full table is Table S19 of the supplement and the same
estimates are drawn in Figure S4. Two coefficients are stably signed across the three
rungs with controls, per capita income at $0.55$, $0.57$ and $0.65$ and
population at $0.35$, $0.27$ and $0.22$, and both are stably significant on the
state-clustered standard error, per capita income at the $1$, $5$ and $1$ per
cent levels and population at $1$ per cent at all three. Population decays
monotonically as controls are added; per capita income does not, and rises at
both steps of the ladder. Manufacturing employment is the
coefficient the ladder does not identify: it moves between $0.08$, $0.06$ and
$-0.18$, changing sign at the last rung, with robust standard errors from $0.22$
to $0.28$ and clustered ones from $0.23$ to $0.30$, so it clears no conventional
level anywhere and its point estimate is smaller than its own standard error at
every rung.

Stability along the ladder is not stability in the coordinate, and the second is
where per capita income fails. Table S21 of the supplement re-runs the
five-control specification under the two strictly increasing reparameterisations
of $X$ of the preceding subsection, which leave $\vdagger\circ T^{-1}$ structural
and $\theta_\dagger$ unchanged in population. Its per capita income coefficient
moves from $+0.6027$ at that table's own baseline to $+0.4909$ and $+0.4958$,
and its standard error from $0.1989$ to $0.3141$ and $0.3254$. The sign and the
order of magnitude survive; the precision does not, the standard error rising by
about three fifths and carrying the coefficient from three standard errors above
zero to about one and a half. \emph{What moves is the estimator and not the estimand,
and on this table the movement is a loss of precision rather than a change of
answer.} Stopping does not account for it: the three arms return their initial
condition on $3$, $2$ and $1$ of $30$ fold solves and none of the three reaches
the cap of $2{,}000$, so the divergence cannot be attributed to one arm
iterating and another not. The arm started from a cubic
fit is the useful control, since it changes where the iteration starts and not the
coordinate the operator is built in, and its coefficient is $0.6192$ with a
standard error of $0.2853$, sitting at the baseline's value and nearly as
imprecise as the coordinate arms. So the precision loss is not specific to
reparameterisation. That control is weaker than it looks, though: $24$ of its
$30$ fold solves return the initial condition, so what it establishes is that a
second and different perturbation of the estimator costs the same precision, and
not that the two perturbations act alike. We therefore do
not offer per capita income as a coefficient this design pins down, even though
the ladder on its own would suggest that it does. The ladder exposes
manufacturing employment and the coordinate exposes per capita income, and a
reader should hold both at arm's length, for the two different reasons.

The intercept-only column is a reference point and not an estimate. Its constant
is $0.2285$ with a standard error of $12.6109$, of which the sampling share is
$0.003$: what is reported there is failed cross-fitting partitions and not
sampling uncertainty. The failure is concentrated to a degree the summary hides.
Nine of the ten partitions return a constant between $0.13$ and $1.25$ and the
tenth returns $126.43$; the cross-fitting term is the standard deviation of the
ten divided by $\sqrt{10}$, so dropping that one partition takes it from $12.61$
to $0.115$. What diverged there is the structural difference, at a mean
$\Delta\hat\varphi$ of $-38.32$ against at most $0.96$ in absolute value in any
other partition. At that rung the two initial conditions the estimator prefers
are undefined and the fallback is a cubic fit; all $50$ fold solves stop at the
first iteration and none reaches the cap, so $\hat\varphi$ *is* that fallback and
the Landweber step never corrects it (Table S20 of the supplement). What the
column reports is one divergent multistart, left standing by an iteration that
never ran.

Where the application sits against this paper's own frontier is the last thing
to report and it is not flattering. \cref{tab:app-feasibility} evaluates
\eqref{eq:frontier} at $(\mu,r)=(2,\tfrac83)$, the frontier-clearing
configuration of Section 5. Only $d_Z=0$ satisfies $\kappa\alpha>\tfrac14$, and
even there the remainder budget $\sqrt n\,\delta_n^{2}$ is $13.0$ at $n=983$ and
would not fall below one until $n\approx2\times10^{11}$. That rung is where
A5(i)'s parametric floor binds: at $d_Z=0$ the propensity exponent is
$\alpha=\tfrac12$, so $\hat\delta_n^{(T)}=n^{-1/2}\sqrt{\ln n}$ exceeds
$\hat\delta_n^{(\varrho)}=n^{-\alpha}$ at every sample size, and reading A5(i) as
its propensity branch alone understates the budget there by a factor of $4.7$ at
this sample size, and by more at larger ones: the factor is $(\ln n)^{\kappa}$,
not a constant.
At $d_Z=5$, $10$ and $22$
the frontier fails outright, so the budget never falls below one at any sample
size, and the smoothness the propensity score would need is $r>4.17$, $8.33$ and
$18.33$ at $\mu=2$.

The rung that clears the frontier is also the rung A4(ii) excludes, and the two
facts should be read together rather than in sequence. A4(ii) asks $d_Z\ge1$, so
$d_Z=0$ is outside the assumption block; and it is outside for the reason
Section 3 gives, that at $\alpha=\tfrac12$ the sieve-entropy condition admits no
integer sieve dimension and \cref{thm:rootn} is vacuous there. So the frontier
column at $d_Z=0$ is not a rung at which the theorem applies with a large
constant. It is a rung at which the theorem does not apply at all, and no rung of
this ladder both satisfies A4(ii) and clears \eqref{eq:frontier}.

\emph{This table describes the estimator that produced
\cref{tab:app-phi}, and an earlier draft said it did not.} That draft carried a
paragraph here explaining that the frontier's $d_Z$ cost runs through
$\hat\varrho$, which the implementation never estimated, so the feasibility
verdict applied to the estimator the theory defines rather than to the code. The
premise was true of the code as it then stood and is no longer: the estimator now
centres at a cross-fitted $\hat\varrho(\Delta Z)$ and pays that cost. \emph{The
caveat is withdrawn, and with it the reading on which the feasibility table
described a hypothetical.} The table is a diagnosis of the estimator that ran,
and that is the harder reading of it, not the easier one. The data make it
binding rather than idle: $W$ and $\Delta Z$ are dependent, at a joint $F$ of
$10.50$ under clustering (Table S17 of the supplement), so $\hat\varrho$ is
estimating something that varies.

The reading is the one Section 4 already prescribes. At $n=983$, and at every
control set an applied literature would accept, the object that describes this
estimator is \cref{cor:ratefloor} and not \cref{thm:rootn}. *The application
illustrates the procedure on a design the method was built for; it does not
demonstrate that the asymptotics bind at this sample size*, and we would rather
say so than let the section be read as though they did.
~~~~~~

## §6 — the tab:app-feasibility float and its notes

**Source:** `paper/qmd/main.qmd`, lines 2605-2641 (pre-edit numbering, file of 2800 lines backed up before this pass).

**Cut because:** The float belonged to the subsection above. `paper/tables/app_tsp_feasibility.tex` is NOT deleted; it is orphaned from main.qmd and is not \input by supplement.qmd either. NOTE: the close and §7 both still assert the frontier verdict in prose, so this is the one orphan whose removal leaves a live claim without a printed float.

~~~~~~
::: {.content-visible when-format="pdf"}
```{=latex}
% 408.6pt at \footnotesize and the stock 6pt \tabcolsep against a \textwidth of
% 469.8pt.  Measured; fits upright with no surgery.
\begin{table}[!htbp]
\centering
\begin{threeparttable}
\caption{The application against the frontier, at $n=983$}
\label{tab:app-feasibility}
\footnotesize
\input{../tables/app_tsp_feasibility}
\begin{tablenotes}\footnotesize
\item \textit{Notes:} Chay--Greenstone county panel, $n=983$. Each row is one
rung of the control-set ladder, indexed by the number $d_Z$ of differenced
controls. The frontier \eqref{eq:frontier} asks $\kappa\alpha>\tfrac14$ with
$\kappa=2\mu/(2\mu+1)$ and $\alpha=r/(2r+d_Z)$, where $\mu$ is the source index
and $r$ the Hölder smoothness of the propensity score, so it is equivalent to
$r>d_Z/(4\kappa-2)$; the first three numeric columns give the $r$ that
requirement implies at three values of $\mu$. The remaining columns are
evaluated at $(\mu,r)=(2,\tfrac83)$, the frontier-clearing configuration of
Section 5, and report the realised $\delta_n$ of \cref{prp:phirate}, the
leading Step-4 product $\sqrt n\,\delta_n^{2}$ at $n=983$, and the sample size
at which that product would first fall below one. ``never'' means the frontier
fails at that $d_Z$, so the product does not fall below one at any $n$. These
are deterministic functions of the configuration and carry no sampling error,
and they price the estimator that produced \cref{tab:app-phi}: since
2026-08-07 that estimator centres at a cross-fitted $\hat\varrho(\Delta Z)$ and
so pays the $d_Z$ cost this table charges. An earlier draft of this note said the
table priced a hypothetical estimator instead; it no longer does. Source:
\texttt{scripts/application/app\_tsp\_01\_diagnostics.R} and
\texttt{app\_tsp\_common.R}; table
\texttt{paper/tables/app\_tsp\_feasibility.tex}.
\end{tablenotes}
\end{threeparttable}
\end{table}
```
:::
~~~~~~

## §7 — the localisation paragraph

**Source:** `paper/qmd/main.qmd`, lines 2729-2738 (pre-edit numbering, file of 2800 lines backed up before this pass).

**Cut because:** Named for removal in the brief. Restates the withdrawn attribution and the per-cell $p$-values and moment-norm ratios.

~~~~~~
What that design does deliver is the attribution. Computed at the common fit and
referred to draws of $W$ from the fitted propensity, the three cell contrasts
separate: $p=0.005$ and $p=0.003$ at the two cells whose designation marks a
chronic condition, and $p=0.062$ at the cell designated on a single bad day, with
moment norms at $2.2$, $3.2$ and $4.4$ times their null medians. The ordering is
the one the mechanism predicts, since chronic pollution is close to a function of
the baseline level the differenced error inherits through the initial condition
and a transient spike is not. \emph{The binary reading of the same designation
cannot make that statement}: it has one contrast, one moment and one verdict, and
which channel carries the failure is not a question it can pose.
~~~~~~

## §7 — the probe paragraph

**Source:** `paper/qmd/main.qmd`, lines 2740-2755 (pre-edit numbering, file of 2800 lines backed up before this pass).

**Cut because:** Summarises the probe battery that beat 1 no longer runs. Removed with it.

~~~~~~
\emph{What the attribution is not is a verdict on A1, and the direction of the
gap runs one way.} Consistency of every cell set is necessary for A1 and not
sufficient, so a cell showing no conflict is not exonerated; the bad-day cell is
not convicted, which is weaker, and the false-negative rate of the attribution is
not something we can price. Section 6 also reports a stratified probe of the
fitted residual's dependence on the designation, and reports it as a diagnostic
rather than as a verdict. The unconditional restriction $\Delta U\upmodels W$,
which is the predecessor's and not this paper's, is rejected at every one of the
five stratifications, which is why the conditional form is imposed at all. A1's
own conditional contrast rejects at all five as well, at four of which the test
does not have nominal size. \emph{Neither block settles A1, and the reason is
the construction rather than the answers.} The residual is the output of a fit
that imposes the hypothesis under examination and is held fixed while the
instrument is redrawn, and the conditional null is drawn from an estimated
propensity, so its $p$-values refer to A1 together with the specification of
that propensity. We report the numbers and take no position on A1 from them.
~~~~~~

## §7 — the sentence carrying \cref{tab:app-feasibility}

**Source:** `paper/qmd/main.qmd`, lines 2721-2727 (pre-edit numbering, file of 2800 lines backed up before this pass).

**Cut because:** EDITED, NOT DELETED. The float it points at leaves the article, so the \cref would dangle. The claim is kept and the cross-reference removed.

~~~~~~
We run the estimator in Section 6 on the county panel of \citet{chay2005}, where
the object is the hedonic price of air quality and the instrument is a
nonattainment designation read as the pair of triggers that produces it, at
$\mathsf L=4$. At $n=983$ the frontier fails at every control set an
applied literature would accept (\cref{tab:app-feasibility}). The application
therefore illustrates the procedure on a design the method was built for, and
does not show that the asymptotics bind at this sample size.
~~~~~~

---

## Floats orphaned from `main.qmd` by this pass

No file in `paper/tables/` was deleted. These are the ones that lost their last `\input` or `\cref` in `main.qmd`:

| Table file | Was cited from | Still `\input` by `supplement.qmd`? |
|---|---|---|
| `app_tsp_misclass.tex` | §6.2, `tab:app-misclass` | no |
| `app_tsp_feasibility.tex` | §6.7, `tab:app-feasibility` | no |

Two more were already orphaned from both documents before this pass and remain so:
`app_tsp_localise.tex` and — until this pass used it — `app_tsp_localise_theta.tex`, which the new
beat 2 now `\input`s as `tab:app-theta`.

`app_tsp_opnorm.tex`, `app_tsp_ladder.tex`, `app_tsp_robustness.tex` and
`app_tsp_estimator_diag.tex` lost their **prose mentions** in `main.qmd` but were never `\input`
there; they are supplement floats and are untouched.
