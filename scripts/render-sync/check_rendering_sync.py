#!/usr/bin/env python3
"""
check_rendering_sync.py -- mechanical diff of the paper renderings against the
source of record, for project `panel-npiv-discrete`.

WHY THIS EXISTS
---------------
`paper/sections/theorems/*.tex` are ALTERNATIVE RENDERINGS of environments whose
source of record is `quality_reports/theory/panel-npiv-discrete/results.tex` and
`proofs.tex`.  They carry the SAME \\label keys.  Through rounds 5-8 the renderings
were kept in sync by a hand-maintained list of exceptions inside a header comment.
That list failed twice in the same way: in round 7 it said FIVE and omitted a
sixth; in round 8 it said SIX and omitted a seventh (C25's \\vartheta -> \\Xi
rename, live at four lines, on the letter binding on the Step-4 dispatch).

A hand-kept list of exceptions is the same failure mode as a hand-kept header,
one remove further out.  This script replaces it.  It REPORTS; it never edits.

WHAT IT CHECKS
--------------
CHECK 1 (BLOCKING) -- statement drift.
    For every \\label key present in both the source of record and a rendering,
    the STATEMENT body (the environment text up to the first \\begin{proof}) is
    normalised and compared.  Any difference is reported as a unified diff.
    Rationale: the renderings' headers assert that statements and hypothesis
    lists are correct; proofs are allowed to lag.

CHECK 2 (ADVISORY) -- proof drift.
    Same comparison for \\begin{proof} bodies, matched by the \\cref target in
    \\begin{proof}[Proof of \\cref{KEY}] or by position inside the environment.
    Reported, not blocking: renderings may legitimately abbreviate a proof.

CHECK 3 (BLOCKING) -- retired-symbol sweep.
    A table of RETIRED patterns (glossary Sec.1.4-1.5 collision resolutions) is
    swept across every file in both trees.  A hit means a rename was applied in
    one tree and not the other, which is precisely the defect species this
    script exists to catch.  The table is the single place a new rename is
    declared; adding a row here is the last step of any rename.

CHECK 4 (BLOCKING) -- orphan labels.
    A \\label key that exists in a rendering but not in the source of record, or
    a rendering whose header claims to render N environments while it contains
    M != N, is reported.  (The round-7 header said NINE and listed eight.)

USAGE
-----
    python3 scripts/render-sync/check_rendering_sync.py
    python3 scripts/render-sync/check_rendering_sync.py --project panel-npiv-discrete
    python3 scripts/render-sync/check_rendering_sync.py --advisory-only   # never exit 1

Exit status: 0 if all BLOCKING checks pass, 1 otherwise.
Output: a report on stdout.  Nothing is written to disk.
"""

from __future__ import annotations

import argparse
import difflib
import re
import sys
from pathlib import Path

# --------------------------------------------------------------------------
# CHECK 3's table.  ONE ROW PER RETIRED PATTERN.  Adding a rename to the
# project means adding a row here; that is what makes the sweep mechanical
# rather than remembered.
#
# Fields: (regex, human name, glossary reference, replacement now in force)
# --------------------------------------------------------------------------
RETIRED_PATTERNS: list[tuple[str, str, str, str]] = [
    # --- round 7 renames -------------------------------------------------
    (r"\\mathcal\s*B\s*\(",           "calligraphic B applied to an argument "
                                      "(the Borel sigma-algebra)", "C20", r"\mathfrak B(...)"),
    (r"\\mathcal\s*B\s*\\Xi",         "calligraphic B as the tilted difference map",
                                      "C20", r"\Upsilon\Xi"),
    (r"\\varsigma\s*'\s*\\psi",       "varsigma as the R^p Step-4 direction",
                                      "C25", r"\vartheta'\psi"),
    (r"\\psi\s*\(\s*t\s*\)\s*=\s*E\[", "psi as the Laplace transform",
                                      "C26", r"\mathsf L_\Gamma(t)"),
    (r"\bm\s*\(\s*\\tau\s*\)",        "m as the moment map",  "C21", r"\Psi(\tau)"),
    (r"\\mathcal\s*C_0\b(?=[^)]*kernel)", "calligraphic C_0 as the kernel support",
                                      "C24", r"[-c_C, c_C]"),
    # --- round 8 renames -------------------------------------------------
    (r"\\mathcal\s*S_\{?L_x\}?",      "calligraphic S as the sieve span",
                                      "C31", r"\operatorname{span}(b_1,\dots,b_{L_x})"),
    (r"(?<![A-Za-z\\])M\s*:?=\s*\(\\vartheta", "roman M as the multiplication operator",
                                      "C32", r"\mathcal B_{\mathrm{mult}}"),
    (r"constant\s+\$M\s*>\s*0\$",     "roman M as a scalar constant",
                                      "C32", "the height is set to 1"),
    (r"\\tau_2\s*B\s*\(\s*\\tau_1",   "italic B as an eq:biaffine coefficient",
                                      "C33", r"\Psi_{10}(\tau_1)"),
    (r"\\tau_3\s*C\s*\(\s*\\tau_1",   "italic C as an eq:biaffine coefficient",
                                      "C33", r"\Psi_{01}(\tau_1)"),
    (r"D\s*:?=\s*\\\{\s*z\s*:\s*\\varrho", "italic D as the degenerate region",
                                      "C34", r"\mathcal Z_0"),
    (r"\\Phi\s*\(\s*\\pm\s*1\s*\)\s*=\s*\\pm\s*a\b", "italic a as the value Phi(1)",
                                      "C35", r"\Phi(1)"),
    (r"\\cos\s*\(\s*t\s*a\s*\)",      "italic a inside cos(ta)", "C35", r"\cos(t\,\Phi(1))"),
    (r"an\s+event\s+\$A\$",           "italic A as an event", "C36",
                                      r"the set \{\Delta h = -1\}, written out"),
    (r"\\mathrm\s*\{\s*supp\s*\}",    "\\mathrm for an operator name", "C37",
                                      r"\operatorname{supp}"),
    (r"\\mathrm\s*\{\s*sign\s*\}",    "\\mathrm for an operator name", "C37",
                                      r"\operatorname{sign}"),
    # --- round 9: slots DECLINED at Step 4 -------------------------------
    # These two rows differ in kind from every row above.  The rows above guard
    # a rename: a symbol MOVED and the sweep catches the old glyph left behind.
    # These guard a slot that was DELIBERATELY NOT CLAIMED, so that a later
    # author cannot claim it by accident from the strategy memo's notation.  A
    # declined slot needs the same mechanical protection as a retired one --
    # otherwise the reasoning lives only in a glossary row nobody greps.
    (r"(?<![A-Za-z\\])Q\s*\(\s*h\s*\)", "italic Q as the second-order remainder "
                                      "(the memo's Q(h)); italic Q is (P6b)'s "
                                      "regular conditional distribution, live at "
                                      "six sites, one of which supplies the "
                                      "measurable version of q",
                                      "C38", r"the form \langle\mathcal B h,h\rangle_{L^2(\pi)}"
                                             r" -- eq:quadrem"),
    (r"\\\|\s*M\s*/\s*\\pi\s*\\\|",   "||M/pi|| as the sharpness constant: M is "
                                      "retired (C7, C32) AND the object is a LOWER "
                                      "bound, not the sharp constant",
                                      "C7/C32/C38", r"\|\vartheta'\sigma_q/\pi\|_\infty,"
                                             r" a LOWER bound; the sharp constant is"
                                             r" (1/2)\|P_V B_sym P_V|_V\|"),
    # Third declined slot, added in the dispatch-6 fix pass.  The reviewer found
    # the declined abbreviation surviving at proofs.tex:2156 and observed that
    # NEITHER of the two rows above covers it: they guard Q(h) and ||M/pi||.
    # The optional backslash catches the ASCII spelling `g_vartheta' that a
    # header comment uses as well as the LaTeX `g_\vartheta' and `g_{\vartheta}'.
    #
    # KNOWN LIMIT OF THIS ROW, recorded rather than left to be rediscovered:
    # sweep_retired() strips LaTeX comments before matching, BY DESIGN (a line
    # narrating a retirement is not a use of it).  So a comment-only occurrence
    # -- which is exactly what the reviewer found -- is out of CHECK 3's reach.
    # The row guards the LIVE slot; the comment sweep is the Sec.1.5b grep.
    (r"g_\{?\\?vartheta\}?",          "g_vartheta as an abbreviation for the "
                                      "multiplier vartheta' sigma_q / pi: g is the "
                                      "generic moment weight and fills the subscript "
                                      "slot of nu_g, sigma_g, hat-nu_g; and an "
                                      "abbreviation re-collapses the Sec.8.4 item 2 "
                                      "distinction that C7 retired M to protect",
                                      "C44", r"\vartheta'\sigma_q/\pi, written out at"
                                             r" all ~15 Part G sites"),
]

# Patterns that are legitimate ONLY inside a declared verbatim-foreign-notation
# block (e.g. the Feve-Florens quotation, which keeps Z_t for the period-t
# regressor).  Lines between these markers are skipped by CHECK 3.
VERBATIM_OPEN = re.compile(r"verbatim\s+in\s+their\s+notation|VERBATIM FOREIGN NOTATION", re.I)
VERBATIM_CLOSE = re.compile(r"end\s+of\s+verbatim|END VERBATIM", re.I)

# A line that NARRATES a retirement is not a USE of the retired symbol.  This
# project's house style is to record every rename in place, with the old glyph
# printed so a reader can see what moved -- e.g. "A round-7 version named it
# $\mathcal S_{L_x}$ ...".  Suppressing those lines is what keeps CHECK 3's
# signal-to-noise usable; without it every recorded resolution reports as a
# defect, and a sweep nobody trusts is a sweep nobody runs.
#
# The marker must be an EXPLICIT provenance phrase, not a general hedge, so that
# a genuine live use cannot be laundered by an adjacent word.
#
# A GLOSSARY ID IS NOT A PROVENANCE PHRASE.  `|\bC\d{2}\b` was a clause here
# through round 12 and was REMOVED on 2026-07-30, on the notation-warden's
# finding: the house style puts narration and live mathematics on one line, so a
# `C\d{2}` token is trivially acquired by a line that is doing live work, and any
# retired glyph sharing that line goes invisible.  The register also runs two
# namespaces on these tokens -- assumption tags C1-C5' and collision slots C1-C68
# -- so an assumption tag reaching two digits would have silently disabled the
# marker project-wide.
#
# MEASURED BEFORE REMOVING, because a clause that suppresses real narration is
# not free to drop: across the whole swept corpus the clause was load-bearing at
# exactly ONE site, proofs.tex:2096, a genuine wrapped narration whose provenance
# phrase ("A round-7 version named it") sits on the line above.  That site now
# carries the explicit RETIRED-MENTION opt-out instead, so the suppression is
# auditable by grep rather than incidental.
PROVENANCE_LINE = re.compile(
    r"round-\d\s+version"
    r"|through\s+round\s+\d"
    r"|[Rr]ounds?\s+\d(--|-|–)?\d?\s+(printed|wrote|named|cited|listed)"
    r"|retire(d|ment|s)"
    r"|ROUND-\d:"
    # A SWEEP RECORD IS NARRATION BY CONSTRUCTION, and this clause exists because
    # the project's own rule created the false positive.  The notation-warden's
    # Sec.1.5g(i) requires that "a sweep asserted in a binding file must name the
    # pattern swept" -- and naming the glyphs you swept AGAINST means printing
    # them.  proofs.tex's prp:medianpart rename record reads "$D/\mathsf D_n$ (C59)
    # and $M/\mathsf M$.  Slot swept: \mathsf p --- zero occurrences", which an
    # ONLY_IN row correctly matched and wrongly flagged.  Honouring the rule must
    # not cost a blocking finding.
    r"|[Ss]lot swept|[Ss]wept for|sweeps? to zero|zero occurrences"
)

# The deterministic opt-out, for a line where no phrase fits -- typically a
# narration that WRAPS, leaving the old glyph on a line of its own.
#
# TESTED AGAINST THE RAW LINE, COMMENTS INCLUDED, and that is the whole point.
# As shipped through round 12 this token lived in PROVENANCE_LINE, which is
# tested only AFTER `re.sub(r"(?<!\\)%.*$", "", raw)` has removed comments.  So
# the documented escape hatch could not be used the documented way: in a comment
# it was stripped before matching, and in live text it would print in the PDF.
# It had zero uses, which is why the defect survived undetected.
RETIRED_MENTION = re.compile(r"RETIRED-MENTION")

# ---------------------------------------------------------------------------
# CHECK 6's table: THE REGISTER OF CHECKABLE ASSERTIONS.
#
# WHY THIS EXISTS, and it is a different failure species from CHECK 3's.  CHECK 3
# catches a retired GLYPH surviving in live text.  It cannot catch the species the
# notation-warden isolated: A BINDING ROW THAT ASSERTS A FACT ABOUT THE FILE WHICH
# THE FILE FALSIFIES.  The symbol is fine; the claim about it is false.  Three of
# the warden's seven Part-H findings were that species, and no symbol sweep can
# see any of them.  Its examples, all false when written:
#
#     C67  "lowercase omega occurs in no file of this project"   -- ~18 sites
#     C62  "no symbol for the discrepancy inflation factor"      -- proofs.tex names it
#     S1.6 "M ... in lem:srctransfer(ii) only"                   -- also at two other sites
#     hdr  "the register is C1-C67, two slots in S1.5f"          -- C1-C68, three slots
#
# The lesson the warden drew, and the design here: THE REGISTER SHOULD HOLD
# CHECKABLE ASSERTIONS, NOT PHRASES.  A claim in prose decays silently; the same
# claim as a row fails loudly the day the file stops satisfying it.
#
# "never appears without its subscript/argument" and "in X only" is this project's
# single most common rule form -- it appears at C19, C23, C26, C39, C43, C54, C55,
# C66 and the eta_TCC row -- so ONLY_IN is the highest-yield of the three.
#
# Fields: (kind, subject, spec, glossary ref)
#   OCCURS_NOWHERE  spec = regex.  Any hit in any swept file is a failure.
#   ONLY_IN         spec = (regex, [label keys]).  A hit outside the named
#                   environments is a failure.
#   REGISTER_RANGE  spec = (lo, hi).  The glossary's own "| **Cnn** |" rows must
#                   form exactly the contiguous range [lo, hi].
#
# Provenance suppression applies to OCCURS_NOWHERE and ONLY_IN exactly as in
# CHECK 3: a line narrating the rule is not a breach of it.
REGISTER_ASSERTIONS: list[tuple[str, str, object, str]] = [
    # The warden enumerated C1-C68 on 2026-07-29 and found the glossary header
    # asserting C1-C67.  The register has grown twice since: to C72 (dispatch 9),
    # then to C79 (dispatch 10 / Step 7, seven slots, three of them renames forced
    # by sweeps).  BOTH GROWTHS WERE CAUGHT BY THIS ROW RATHER THAN BY A READER,
    # which is the whole argument for holding the range as an assertion instead of
    # a sentence in a header.  Verified contiguous, no gaps, no duplicates.
    # UPPER BOUND RETIRED 2026-08-03: was (1, 79), which the register outgrew
    # legitimately (C80-C107 added in dispatches 23-24).  `None` asserts
    # contiguity from C1 with no ceiling -- gaps and duplicates still fail, which
    # is the property that was ever worth checking.  See the sentinel handling in
    # the REGISTER_RANGE branch below.
    ("REGISTER_RANGE", "collision-slot register is contiguous from C1, no gaps",
     (1, None), "glossary header / Sec.1.5f"),
    # ADDED 2026-07-30 on the theorist-critic's recommendation, which was that this
    # defect class needs "a blocking grep row, not symbolic algebra" -- and it was
    # right: no SymPy spec could have caught it.
    #
    # THE DEFECT CLASS: a claim ABOUT a maintained clause goes stale when the clause
    # is amended.  Dispatch 10 amended A5(ii) to carry the logarithm in the symbol,
    # delta_n := (hat-delta_n ln n)^{2 mu/(2 mu+1)}.  rem:phirscope(2) still read
    # "A5(ii) writes the latter" -- the log-FREE form -- so two files of the corpus
    # asserted different things about the same maintained clause, and the memo
    # claimed the warning was "discharged rather than carried" when it was carried
    # verbatim.  The amendment's own sweep was not run.
    #
    # WHY THE PATTERN IS PRESENT-TENSE-ATTRIBUTION AND NOT THE BARE GLYPH.  The
    # log-free rate occurs three times in live text and TWO ARE LEGITIMATE: past-tense
    # narration of what the clause used to say (assumptions.tex, "wrote this clause
    # at ...", and rem:rootnlog's comparison of the two forms).  A row on the glyph
    # would fire on all three and be switched off within a week.  What is false is
    # only a PRESENT-TENSE claim that A5(ii) writes the log-free form.
    #
    # This is narrower than the ONLY_IN/OCCURS_NOWHERE family and deliberately so:
    # it guards one clause whose amendment has already produced this defect once.
    ("OCCURS_NOWHERE", r"a present-tense claim that A5(ii) writes the LOG-FREE rate "
                       r"(amended dispatch 10: the log is in the symbol)",
     # THREE ORDERINGS, because the row as first written was DIRECTION-SENSITIVE and
     # the warden found a live site it could not match in any file: "...$\hat\delta_n^{2\mu
     # /(2\mu+1)}$ as A5(ii) writes." puts the glyph FIRST and the verb LAST, matching
     # neither original alternative. A guard that depends on word order is a guard with a
     # blind spot the prose will eventually find.
     (r"A5\(ii\)[^.]{0,60}(writes|reads|states)[^.]{0,40}"
      r"(latter|log-free|\\hat\\delta_n\^)"
      r"|(writes|reads|states)[^.]{0,40}\\hat\\delta_n\^\{?2\\mu[^.]{0,40}A5\(ii\)"
      r"|\\hat\\delta_n\^\{?2\\mu[^.]{0,40}A5\(ii\)[^.]{0,25}(writes|reads|states)",),
     "A5(ii) / rem:phirscope(2)"),
    # BARE sans-serif M only.  The subscripted \mathsf M_\epsilon in prp:stopfeas
    # is an O_P bounding constant, a different object, and whether it collides
    # with this row's symbol is a notation judgement for the warden -- not
    # something this checker should decide by widening a regex.
    ("ONLY_IN", r"\mathsf M (bare), the source-condition radius",
     (r"\\mathsf\s*\{?\s*M\s*\}?(?![_A-Za-z])", ["lem:srctransfer"]), "Sec.1.6"),
    # ---- RETIRED 2026-07-30, and retired for the RIGHT reason -----------------
    # This row asserted glossary C2's claim that \mathcal D "appears only in the
    # levels-vs-derivative remark and in rem:draftrec, so it is nearly dormant."
    # The row's first run reported that claim false, and dispatch 10 CORRECTED THE
    # GLOSSARY: 45 occurrences across five live files, and \mathcal D is
    # load-bearing in a maintained assumption -- H1 (ass:hilbscale) reads "the
    # Sobolev scale H^s of order s generated by \mathcal D", repeated at
    # def:srcball, so it generates the scale in which A5(vi), A5(vi'), (P-a.1),
    # (P-c), (P-g), eq:entropy and lem:unifop Step 4 are all written.
    #
    # SO THE ROW IS RETIRED BECAUSE ITS SUBJECT WAS WITHDRAWN, NOT TO SILENCE A
    # FAILURE.  C2 no longer makes a scoping claim about \mathcal D, and an ONLY_IN
    # row is meaningless without one -- widening the licensed list to cover 45 sites
    # would have kept a green check that asserted nothing.  That is the distinction
    # the "do not delete the row to silence it" rule turns on: delete when the
    # CLAIM is gone, never when the claim is merely inconvenient.
    #     ("ONLY_IN", r"\mathcal D, the differentiation operator",
    #      (r"\\mathcal\s*\{?\s*D\s*\}?", ["rem:draftrec", "lem:levels"]), "C2"),
    # --------------------------------------------------------------------------
    # ass:tcc is the A6 assumption block (retired-but-stated); def:a6b in
    # results.tex is the DIFFERENT object A6b, the restricted-curvature property.
    # A first version of this row licensed def:a6b and not ass:tcc, and the three
    # resulting hits were a defect in the row, not in the file.
    ("ONLY_IN", r"\eta_{\rm TCC}, the tangential-cone constant",
     (r"\\eta_\{?\\?(mathrm\{TCC\}|rm\s+TCC)\}?", ["ass:tcc", "def:a6b",
                                                   "prp:tccrepair", "prp:tccfails",
                                                   "rem:tccwhy", "rem:tccverdict"]), "C8"),
]


# ---------------------------------------------------------------------------
# CHECK 8's register: TAGS THAT HAVE BEEN RETIRED.
#
# WHY THIS EXISTS.  A retirement is two edits, not one: the clause is marked
# retired, AND every live sentence that still treats the tag as maintained is
# swept.  The assumption-auditor found B1(vi) with the first done and the second
# not -- three live sites still called it a maintained identification assumption,
# one of them the PRINTED DISCUSSION PARAGRAPH of the assumption block itself and
# one a COMPILED RENDERING.  The identical sweep HAD been run for A2'(ii) in the
# same dispatch, so the discipline exists; what was missing was anything that
# checks it.  Retiring a clause tag-by-tag rather than clause-by-clause is the
# defect, and it is mechanical to catch.
#
# Fields: (regex for the tag, human name, where the retirement is recorded)
RETIRED_TAGS: list[tuple[str, str, str]] = [
    (r"(?<![A-Za-z])A3(?![0-9A-Za-z])",        "A3 (rank condition)",
                                                "proved: lem:momzero(iv)"),
    (r"(?<![A-Za-z])A6(?![0-9A-Za-z'b])",      "A6 (tangential cone)",
                                                "false: prp:tccfails; replaced by A6b + prp:tccrepair"),
    (r"A\?2'?\?\textup\{\(ii\)\}|A\$2'\$\(ii\)|A2'\(ii\)",
                                                "A2'(ii)", "proved from A2'(i)+B1+(P1)"),
    (r"B1\(vi\)|B1\\textup\{\(vi\)\}", "B1(vi) (growing finite index family)",
                                                "unused; prices a device not implemented"),
]

# A line that RECORDS a retirement is not a line that treats the tag as live.
# CALIBRATED AGAINST THE FIRST RUN, which is the only way to get this right.
# The narrow first draft fired on eight lines, of which SEVEN were legitimate and
# one was the real defect. The seven were all retirement-CONSISTENT phrasings the
# draft did not recognise: a non-use statement ("A2'(ii) is consumed by no part of
# this lemma"), the history of a retirement, and -- most tellingly -- the title of
# the very proposition that proves the tag false ("A6 is false, and not only for
# the operator it names"). A checker that flags the proof of a retirement as a
# failure to record it is worse than no checker, because it teaches its reader to
# skim. The surviving finding is the one the assumption-auditor found by hand.
RETIREMENT_MARKER = re.compile(
    r"retire(d|ment|s)|struck|withdraw(n|s)?|no longer (maintained|available)"
    r"|not maintained|is not available for use|RETIRED|superseded"
    r"|proved rather than assumed"
    # non-use and falsity statements: both are ways of recording a retirement
    r"|is false|are false|consumed by no|no consumer|not consumed|is vacuous"
    r"|has no consumer|unused|does not hold|cannot hold|is empty"
    # the tag being discussed as history rather than invoked
    r"|round-\d|through round|dispatch~?\d|formerly|previously|used to|once ",
    re.I,
)

# CHECK 7: a spec's `source:` is a claim about where a thing is. Claims decay.
SPEC_CITE = re.compile(r"([A-Za-z0-9_\-]+\.tex):(\d+)(?:\s*[-\u2013]\s*(\d+))?")
SPEC_LABEL = re.compile(r"\b((?:eq|lem|prp|thm|cor|def|rem|ass):[A-Za-z0-9_\-]+)")

ENV_NAMES = ("lemma", "corollary", "proposition", "theorem", "definition", "remark")

# CHECK 6 needs a WIDER environment list than CHECKS 1-4, which compare statements
# against renderings and so only care about numbered results.  A rule scoped to an
# assumption ("eta_TCC ... in A6b only") lives inside \begin{assumption}, and this
# project has 24 of those.  Omitting them made every assumption-scoped rule report
# as a breach with an empty membership set -- the same empty-set signature as the
# bare-proof defect above, from a different cause.
REG_ENV_NAMES = ENV_NAMES + ("assumption", "hyp")

ENV_RE = re.compile(
    r"\\begin\{(?P<env>" + "|".join(ENV_NAMES) + r")\}"
    r"(?P<opt>(?:\[(?:[^\[\]]|\[[^\]]*\])*\])?)"
    r"\s*\\label\{(?P<key>[^}]+)\}"
    r"(?P<body>.*?)"
    r"\\end\{(?P=env)\}",
    re.S,
)

REG_ENV_RE = re.compile(
    r"\\begin\{(?P<env>" + "|".join(REG_ENV_NAMES) + r")\}"
    r"(?P<opt>(?:\[(?:[^\[\]]|\[[^\]]*\])*\])?)"
    r"\s*\\label\{(?P<key>[^}]+)\}"
    r"(?P<body>.*?)"
    r"\\end\{(?P=env)\}",
    re.S,
)

PROOF_RE = re.compile(
    r"\\begin\{proof\}(?P<opt>(?:\[(?:[^\[\]]|\[[^\]]*\])*\])?)(?P<body>.*?)\\end\{proof\}",
    re.S,
)

PROOF_TARGET_RE = re.compile(r"\\[Cc]ref\{([^}]+)\}")


def strip_comments(text: str) -> str:
    """Remove LaTeX line comments, preserving escaped percent signs."""
    out = []
    for line in text.splitlines():
        cleaned = re.sub(r"(?<!\\)%.*$", "", line)
        out.append(cleaned)
    return "\n".join(out)


def normalise(text: str) -> str:
    """
    Canonical form for comparison: comments removed, whitespace collapsed,
    LaTeX spacing macros dropped, sentence-level line breaks removed.

    Deliberately does NOT normalise \\emph{...} away: a rendering that drops an
    italicised scope caveat present in the source of record IS a drift, and it
    is the kind that has bitten this project (an omitted "and nothing else"
    qualifier changes an exhaustiveness claim).
    """
    text = strip_comments(text)
    text = re.sub(r"\\[,;:!]|\\quad|\\qquad|\\;|\\ ", " ", text)
    text = re.sub(r"~", " ", text)
    text = re.sub(r"\s+", " ", text)
    return text.strip()


def split_statement_and_proofs(body: str) -> tuple[str, list[tuple[str | None, str]]]:
    """Return (statement text, [(proof target key or None, proof body), ...])."""
    proofs = []
    for m in PROOF_RE.finditer(body):
        target = None
        if m.group("opt"):
            hit = PROOF_TARGET_RE.search(m.group("opt"))
            if hit:
                target = hit.group(1)
        proofs.append((target, m.group("body")))
    statement = PROOF_RE.sub("", body)
    return statement, proofs


def collect_environments(path: Path) -> dict[str, dict]:
    text = path.read_text(encoding="utf-8")
    found: dict[str, dict] = {}
    for m in ENV_RE.finditer(text):
        key = m.group("key")
        statement, proofs = split_statement_and_proofs(m.group("body"))
        found[key] = {
            "env": m.group("env"),
            "statement": statement,
            "proofs": proofs,
            "path": path,
        }
    return found


def collect_free_proofs(path: Path) -> dict[str, str]:
    """Proofs written outside an environment, as in proofs.tex."""
    text = path.read_text(encoding="utf-8")
    out: dict[str, str] = {}
    for m in PROOF_RE.finditer(text):
        if not m.group("opt"):
            continue
        hit = PROOF_TARGET_RE.search(m.group("opt"))
        if hit:
            out[hit.group(1)] = m.group("body")
    return out


def sweep_retired(paths: list[Path]) -> list[str]:
    """Flag live uses of retired symbols, one PHYSICAL LINE at a time.

    THE LINE IS THE UNIT ON PURPOSE, and it was re-tested on 2026-07-30 against
    the notation-warden's recommendation to widen it.  The warden's DEFECT is real
    (see PROVENANCE_LINE) but its REMEDY -- "scope the provenance test to the
    sentence" -- was tried, measured against a four-case probe, and REVERTED:

      Widening the window WIDENS THE LAUNDERING SURFACE, which is the direction
      the warden was trying to close.  A sentence that opens with a glossary ID
      for one symbol -- "The glossary row C44 governs a different symbol ... and
      this makes a genuinely live use of $Q(h)$" -- is CORRECTLY FLAGGED at line
      scope and SUPPRESSED at sentence scope.  Suppression is monotone in window
      size, so any widening buys false negatives, and a missed live use is a wrong
      paper where a spurious hit is thirty seconds.

    The warden's real target was the wrapped narration -- provenance phrase on
    line N, retired glyph on line N+1 -- which does occur here, at exactly one
    site.  That is fixed at the marker rather than at the window: the acquirable
    `C\\d{2}` clause is gone, and the one wrapped narration carries an explicit
    RETIRED-MENTION comment.  Narrow window, non-acquirable marker, auditable
    exceptions -- rather than a wide window that excuses whatever shares a sentence.
    """
    problems = []
    for path in paths:
        in_verbatim = False
        for lineno, raw in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
            if VERBATIM_OPEN.search(raw):
                in_verbatim = True
            if VERBATIM_CLOSE.search(raw):
                in_verbatim = False
            if in_verbatim:
                continue
            if RETIRED_MENTION.search(raw):
                # explicit opt-out; tested on RAW so it works from a comment
                continue
            line = re.sub(r"(?<!\\)%.*$", "", raw)
            if not line.strip():
                continue
            if PROVENANCE_LINE.search(line):
                # narrating a retirement, not using the retired symbol
                continue
            for pattern, name, ref, replacement in RETIRED_PATTERNS:
                if re.search(pattern, line):
                    problems.append(
                        f"  {path}:{lineno}\n"
                        f"      retired: {name}  (glossary {ref})\n"
                        f"      now:     {replacement}\n"
                        f"      line:    {line.strip()[:160]}"
                    )
    return problems


def unified(a: str, b: str, a_name: str, b_name: str) -> str:
    return "\n".join(
        difflib.unified_diff(
            a.split(". "), b.split(". "),
            fromfile=a_name, tofile=b_name, lineterm="", n=1,
        )
    )


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--project", default="panel-npiv-discrete")
    ap.add_argument("--root", default=None,
                    help="repository root; defaults to two levels above this script")
    ap.add_argument("--advisory-only", action="store_true",
                    help="report everything but always exit 0")
    args = ap.parse_args()

    root = Path(args.root) if args.root else Path(__file__).resolve().parents[2]
    theory = root / "quality_reports" / "theory" / args.project
    # RETIRED TARGET, 2026-08-03.  paper/sections/theorems/ holds per-theorem
    # renderings from an ABANDONED architecture: they were written for a
    # paper/main.tex that does not exist, neither .qmd inputs them, and their
    # text is round-2 vintage against a corpus at dispatch 25.  Diffing the live
    # corpus against them produced ~101 BLOCKING findings that were all phantom
    # -- drift against a file nobody compiles is not drift.  A checker that
    # cries wolf 101 times is worse than no checker, because the one real
    # finding is indistinguishable from the noise.
    #
    # The directory is retired with a marker rather than deleted (nothing in
    # this repo is committed).  Files carrying the marker are excluded here, so
    # CHECK 1 and CHECK 2 report on live renderings only -- of which there are
    # currently none, which is the honest answer.
    # See paper/sections/theorems/_SUPERSEDED.md.
    _all_renders = sorted((root / "paper" / "sections" / "theorems").glob("*.tex"))
    renders = [p for p in _all_renders
               if "SUPERSEDED 2026-08-03" not in p.read_text(errors="replace")]
    _retired = len(_all_renders) - len(renders)

    results_tex = theory / "results.tex"
    proofs_tex = theory / "proofs.tex"
    assumptions_tex = theory / "assumptions.tex"

    for required in (results_tex, proofs_tex):
        if not required.exists():
            print(f"FATAL: source of record missing: {required}")
            return 1
    if not renders:
        # NOT FATAL when every rendering is retired.  That is the expected state
        # since 2026-08-03 and it means CHECK 1 and CHECK 2 have nothing to say,
        # not that the tool is broken.  The remaining checks (bibliography,
        # symbolic specs) are independent of the renderings and still run.
        if _retired:
            print(f"NOTE: all {_retired} rendering(s) under "
                  f"paper/sections/theorems/ are RETIRED (superseded marker present).")
            print("      CHECK 1 (statement drift) and CHECK 2 (proof drift) are SKIPPED:")
            print("      there is nothing live to drift against.  This is expected.")
            print("      See paper/sections/theorems/_SUPERSEDED.md.")
        else:
            print(f"FATAL: no renderings found under {root/'paper'/'sections'/'theorems'}")
            return 1

    source_envs = collect_environments(results_tex)
    source_proofs = collect_free_proofs(proofs_tex)

    blocking = 0
    advisory = 0

    print("=" * 78)
    print(f"RENDERING SYNC REPORT -- project {args.project}")
    print(f"source of record : {results_tex.relative_to(root)}")
    print(f"                   {proofs_tex.relative_to(root)}")
    print(f"renderings       : {len(renders)} file(s) under paper/sections/theorems/")
    print("=" * 78)

    # ---------------- CHECK 1 and 2 --------------------------------------
    print("\n[CHECK 1, BLOCKING] statement drift, by \\label key\n")
    for render in renders:
        render_envs = collect_environments(render)
        for key, entry in sorted(render_envs.items()):
            if key not in source_envs:
                print(f"  ORPHAN  {render.name}: \\label{{{key}}} has no counterpart "
                      f"in {results_tex.name}  [CHECK 4]")
                blocking += 1
                continue
            a = normalise(source_envs[key]["statement"])
            b = normalise(entry["statement"])
            if a != b:
                blocking += 1
                print(f"  DRIFT   {render.name}: {key}")
                print(unified(a, b, f"results.tex:{key}", f"{render.name}:{key}"))
                print()
    if blocking == 0:
        print("  (no statement drift)")

    print("\n[CHECK 2, ADVISORY] proof drift, by \\label key\n")
    for render in renders:
        render_envs = collect_environments(render)
        for key, entry in sorted(render_envs.items()):
            rendered_proofs = [p for _, p in entry["proofs"]]
            if not rendered_proofs or key not in source_proofs:
                continue
            a = normalise(source_proofs[key])
            b = normalise(rendered_proofs[0])
            if a != b:
                advisory += 1
                print(f"  differs {render.name}: proof of {key}")
    if advisory == 0:
        print("  (no proof drift)")

    # ---------------- CHECK 3 --------------------------------------------
    print("\n[CHECK 3, BLOCKING] retired-symbol sweep\n")
    sweep_targets = [results_tex, proofs_tex] + renders
    if assumptions_tex.exists():
        sweep_targets.append(assumptions_tex)
    hits = sweep_retired(sweep_targets)
    if hits:
        blocking += len(hits)
        print("\n".join(hits))
    else:
        print("  (no retired symbol found in any tree)")

    # ---------------- CHECK 4 --------------------------------------------
    print("\n[CHECK 4, BLOCKING] label coverage\n")
    rendered_keys: set[str] = set()
    for render in renders:
        keys = set(collect_environments(render))
        rendered_keys |= keys
        print(f"  {render.name}: {len(keys)} environment(s) -- "
              + ", ".join(sorted(keys)))
    missing = sorted(set(source_envs) - rendered_keys)
    if missing:
        print(f"\n  not rendered anywhere ({len(missing)}): " + ", ".join(missing))
        print("  (informational: not every source environment needs a rendering)")

    # ---------------- CHECK 5 --------------------------------------------
    #
    # WHY THIS CHECK EXISTS.  A key cited in the source but absent from the
    # bibliography does NOT fail the build.  latexmk exits 0; biber emits
    # "I didn't find a database entry", LaTeX downgrades it to a warning, and
    # the document renders "[?]" with the entry silently missing.  Nothing in
    # the pipeline caught that: /tools validate-bib reads a different file
    # (see N-21), and a rendering-only compile never touches the theory source.
    # By the time it was measured, EIGHT of fourteen cited keys were absent.
    #
    # A grep over source is not a build, and a build that exits 0 is not a
    # verification.  This check is the cheap part of the difference.
    print("\n[CHECK 5, BLOCKING] cited keys vs bibliography\n")
    # N-21, applied to this check itself.  The build resolves against whatever
    # \addbibresource names -- the project's OWN bib plus the shared base.  A key
    # that exists only in ANOTHER project's bib does not resolve here, so it is
    # reported separately rather than counted as found.  A first draft of this
    # check globbed every references.bib in the repo and silently under-reported
    # three keys that live in the sibling project's bibliography.
    own_bibs = [root / "quality_reports" / "literature" / args.project / "references.bib"]
    own_bibs += sorted(root.glob("*.bib"))
    other_bibs = [b for b in sorted(root.glob("quality_reports/literature/*/references.bib"))
                  if b not in own_bibs]

    def keys_in(paths: list[Path]) -> set[str]:
        out: set[str] = set()
        for b in paths:
            try:
                out |= set(re.findall(r"^@[a-zA-Z]+\{([^,]+),", b.read_text(), re.M))
            except OSError:
                continue
        return out

    bib_paths = own_bibs
    known = keys_in(own_bibs)
    elsewhere = keys_in(other_bibs) - known
    cite_re = re.compile(r"\\[a-zA-Z]*cite[a-zA-Z]*\s*(?:\[[^\]]*\])*\{([^}]+)\}")
    cited: dict[str, list[str]] = {}
    for path in [results_tex, proofs_tex, assumptions_tex] + renders:
        try:
            text = strip_comments(path.read_text())
        except OSError:
            continue
        for group in cite_re.findall(text):
            for key in (k.strip() for k in group.split(",")):
                if key:
                    cited.setdefault(key, []).append(path.name)
    unresolved = sorted(k for k in cited if k not in known)
    if unresolved:
        for key in unresolved:
            where = ", ".join(sorted(set(cited[key])))
            tag = "CROSS-PROJ" if key in elsewhere else "ABSENT    "
            print(f"  {tag}  {key}  (cited in {where})")
        n_cross = sum(1 for k in unresolved if k in elsewhere)
        print(f"\n  {len(unresolved)} of {len(cited)} cited keys do not resolve for "
              f"this project ({len(bib_paths)} own bib file(s), {len(known)} entries).")
        if n_cross:
            print(f"  {n_cross} of them exist only in ANOTHER project's bibliography: "
                  f"they must be COPIED, not created (N-21).")
        print("  The build will NOT fail on any of these -- it renders [?] silently.")
        blocking += len(unresolved)
    else:
        print(f"  (all {len(cited)} cited keys resolve)")

    # ---------------- CHECK 6 --------------------------------------------
    print("\n[CHECK 6, BLOCKING] register assertions\n")
    # SCOPE IS THE LIVE FILES ONLY -- archive/ IS DELIBERATELY EXCLUDED, and this
    # note exists so nobody "fixes" that by widening it.  The Part-H staging copies
    # under quality_reports/theory/<project>/archive/ are stale by design: they hold
    # 60 labels, every one of which collides with a live file, plus superseded text.
    # archive/results_partH.tex:959 still carries the pre-amendment "A5(ii) writes
    # the latter" that the OCCURS_NOWHERE row below is written to catch -- correctly,
    # because that file records what the corpus USED to say and is stamped DO NOT
    # EDIT.  Widening reg_targets would turn every archived record into a blocking
    # finding and the row would be switched off within a week.
    reg_targets = [results_tex, proofs_tex, assumptions_tex] + renders
    # PER-ROW SCOPE, and the distinction is the point.
    #
    # ONLY_IN asks "is this symbol USED outside the results licensed to use it?"
    # A glossary row NAMES a symbol in order to describe it, and a description is
    # not a use -- so scanning the glossary with ONLY_IN rows is pure noise.
    # Measured before deciding: adding it produced 8 hits, all false positives,
    # every one a glossary row doing its job.
    #
    # OCCURS_NOWHERE asks "does any live text assert this falsehood?"  There the
    # glossary is the HIGHEST-value file to read, because it is where symbol
    # definitions live and where a reader looks first.  This blind spot was not
    # hypothetical: the dispatch-11 sweep repaired every .tex site of the stale
    # A5(ii) rate and left notation_glossary.md's own definitional row for
    # delta_n writing the superseded log-free form -- while the same file, sixty
    # lines later, stated the amended one.  A checker about symbol claims that
    # cannot read the file where symbols are defined has a structural hole.
    reg_targets_occurs = reg_targets + [
        root / "quality_reports" / "theory" / args.project / "notation_glossary.md",
        # theory_memo.md ADDED 2026-07-30. The notation-warden found the sixth and
        # seventh live sites of the A5(ii) stale-claim class in it, one of which this
        # row WOULD have caught had the file been in scope. The memo is prose about
        # the maintained block, so a claim ABOUT a clause is exactly what it carries.
        root / "quality_reports" / "theory" / args.project / "theory_memo.md"]
    glossary = root / "quality_reports" / "theory" / args.project / "notation_glossary.md"
    reg_problems: list[str] = []
    suppressed: list[str] = []

    # Map every label key to the (start, end) character span of its environment,
    # so ONLY_IN can ask "is this hit inside one of the named results?"
    def env_spans(paths: list[Path]) -> dict[Path, list[tuple[str, int, int]]]:
        out: dict[Path, list[tuple[str, int, int]]] = {}
        for p in paths:
            try:
                text = p.read_text(encoding="utf-8")
            except OSError:
                continue
            spans = [(m.group("key"), m.start(), m.end()) for m in REG_ENV_RE.finditer(text)]
            # A proof belongs to the result it proves, or every proof reads as a
            # breach of a rule scoped to that result.  TWO forms occur here and
            # BOTH are needed: the renderings tree writes `\begin{proof}[\cref{key}]`
            # in some files and a BARE `\begin{proof}` positionally after the
            # statement in others (lem-adjoint.tex does the latter for all four of
            # its lemmas).  Keying only off \cref -- as a first version did -- left
            # every bare proof span unfindable, and its contents then reported as
            # "outside any licensed result" with an empty membership set.
            for m in PROOF_RE.finditer(text):
                hit = PROOF_TARGET_RE.search(m.group("opt") or "")
                if hit:
                    spans.append((hit.group(1), m.start(), m.end()))
                    continue
                preceding = [(k, s, e) for k, s, e in spans if e <= m.start()]
                if preceding:
                    key, _, _ = max(preceding, key=lambda t: t[2])
                    spans.append((key, m.start(), m.end()))
            out[p] = spans
        return out

    spans_by_file = env_spans(reg_targets)   # ONLY_IN needs environment spans; the
    # glossary has none, which is another way of saying it holds no results.

    for kind, subject, spec, ref in REGISTER_ASSERTIONS:
        if kind == "REGISTER_RANGE":
            lo, hi = spec  # type: ignore[misc]
            try:
                # BOTH row formats.  The glossary bolds the slot ID in the 55 rows
                # added from C18 onward and leaves it plain in the original 17, so a
                # bold-only pattern reports C1-C17 "missing" -- which is a defect in
                # the pattern, not drift in the register.
                rows = sorted(int(n) for n in re.findall(
                    r"^\|\s*\*{0,2}C(\d+)\*{0,2}\s*\|",
                    glossary.read_text(encoding="utf-8"), re.M))
            except OSError:
                reg_problems.append(f"  {subject}\n"
                                    f"      cannot check: {glossary} unreadable")
                continue
            # hi = None means "contiguous from lo, no upper bound".
            #
            # WHY THIS SENTINEL EXISTS, 2026-08-03.  The assertion was hard-coded
            # (1, 79) and the register has since grown to C107 -- legitimately,
            # dispatches 23 and 24 added C80-C107.  So the CHECKER was stale, not
            # the glossary, and it reported a breach for doing exactly what it is
            # supposed to do.  A check that fires every time the artifact grows
            # correctly is a check that gets ignored, and it was: this breach sat
            # under ~101 phantom findings from the retired renderings.
            #
            # The property actually worth asserting is CONTIGUITY -- no gaps, no
            # duplicates, starts at lo -- which is what catches a mis-numbered or
            # skipped slot. The upper bound was never the point and only created
            # maintenance debt. Same reasoning as the symbolic specs' line-number
            # pointers, retired the same day: assert the durable property, not the
            # coordinate that moves.
            if hi is None:
                hi = rows[-1] if rows else lo
            expected = list(range(lo, hi + 1))
            if rows != expected:
                missing = sorted(set(expected) - set(rows))
                extra = sorted(set(rows) - set(expected))
                dupes = sorted({n for n in rows if rows.count(n) > 1})
                reg_problems.append(
                    f"  REGISTER_RANGE  {subject}  (glossary {ref})\n"
                    f"      asserted: C{lo}-C{hi} contiguous ({len(expected)} rows)\n"
                    f"      found:    {len(rows)} row(s)"
                    + (f", missing {missing}" if missing else "")
                    + (f", outside range {extra}" if extra else "")
                    + (f", duplicated {dupes}" if dupes else ""))
            continue

        # OCCURS_NOWHERE carries a BARE REGEX; ONLY_IN carries (regex, [label keys]).
        # The first version unpacked a pair unconditionally, so the documented
        # OCCURS_NOWHERE form crashed the moment the first such row was added --
        # an unexercised code path, exactly like the RETIRED-MENTION opt-out that
        # could not work from a comment.  A row type with no instance is untested.
        if kind == "OCCURS_NOWHERE":
            pattern = spec[0] if isinstance(spec, (tuple, list)) else spec
            licensed: set[str] = set()
        else:
            pattern, keys = spec  # type: ignore[misc]
            licensed = set(keys)
        for path in (reg_targets_occurs if kind == "OCCURS_NOWHERE" else reg_targets):
            in_verbatim = False
            try:
                lines = path.read_text(encoding="utf-8").splitlines()
            except OSError:
                continue
            offset = 0
            for lineno, raw in enumerate(lines, 1):
                start = offset
                offset += len(raw) + 1
                # VERBATIM BRACKETING IS A LaTeX-SOURCE CONVENTION AND IS APPLIED ONLY
                # TO .tex FILES.  Extending OCCURS_NOWHERE's scope to prose (the memo)
                # immediately broke on this: ONE memo line containing the phrase
                # "verbatim in their notation" opened a block that never closed and
                # silenced every finding after it -- including a live stale claim 1000
                # lines further down.  In .tex the markers bracket a deliberate foreign
                # quotation; in prose the phrase just occurs.
                if path.suffix == ".tex":
                    if VERBATIM_OPEN.search(raw):
                        in_verbatim = True
                    if VERBATIM_CLOSE.search(raw):
                        in_verbatim = False
                if in_verbatim or RETIRED_MENTION.search(raw):
                    continue
                line = re.sub(r"(?<!\\)%.*$", "", raw)
                if not line.strip():
                    continue
                # A SUPPRESSION THAT IS NOT COUNTED IN THE OUTPUT IS A LAUNDERING
                # CHANNEL BY CONSTRUCTION, WHATEVER TRIGGERS IT.  The notation-warden's
                # ruling, and it was earned: the sweep-record exemption added last round
                # silently swallowed a hit at proofs.tex:5754 -- and that very line
                # carried a FALSE "sweeps to zero" claim.  Had the run printed
                # "1 hit suppressed as provenance at proofs.tex:5754", a reader would
                # have opened the line and found it.  Silent suppression removed the one
                # prompt that would have caught the defect it was hiding.
                # A RETIREMENT MARKER ON THE FOLLOWING LINE COUNTS, 2026-08-03.
                # The corpus's convention for a dated record whose present tense has
                # since gone false is to leave the sentence intact and mark it
                # underneath -- "<!-- STALE AS OF DISPATCH 11; MARKED IN DISPATCH 14"
                # and "**[STALE -- A5(ii) was amended in dispatch 11". That is the
                # RIGHT convention: it preserves the record and dates the correction
                # instead of quietly rewriting history. But the marker lands on the
                # NEXT line, so a strictly per-line test reported both as live
                # breaches -- charging the corpus for doing the correct thing.
                # Two sites, theory_memo.md:2049 and :4111, both already marked.
                #
                # The lookahead is ONE line and requires an EXPLICIT marker word, so
                # it cannot swallow an unmarked claim. Suppressions are still printed
                # below, which is this file's own hard-won rule: a silent suppression
                # once hid a false "sweeps to zero" at proofs.tex:5754.
                # SCOPE: TO THE END OF THE PARAGRAPH, not a fixed line count.
                # `lineno` is 1-based (enumerate(lines, 1)), so lines[lineno] IS the
                # next line -- lines[lineno-1] would be this line again.
                #
                # A retirement marker terminating a paragraph retires that paragraph,
                # and the claim it retires may wrap. theory_memo.md:2049 carries its
                # marker one line below; :4111 carries it TWO below, because the
                # sentence runs across three lines. A fixed one-line lookahead caught
                # the first and charged the second for the arbitrary fact that its
                # sentence was longer. Stopping at the blank line is the semantic
                # bound: it cannot reach past the paragraph the marker belongs to.
                # Capped at 6 lines so a long unbroken block cannot silently widen it.
                marked_below = None
                for look in range(lineno, min(lineno + 6, len(lines))):
                    peek = lines[look]
                    if not peek.strip():
                        break
                    if re.search(r"\bSTALE\b|\bSUPERSEDED\b|\bWITHDRAWN\b", peek):
                        marked_below = True
                        break
                if PROVENANCE_LINE.search(line) or marked_below:
                    if re.search(pattern, line):
                        why = "retired below" if marked_below else "provenance"
                        suppressed.append(f"      {path.name}:{lineno} "
                                          f"[{kind} {subject[:40]}] ({why}) "
                                          f"{line.strip()[:76]}")
                    continue
                if not re.search(pattern, line):
                    continue
                inside = {k for k, s, e in spans_by_file.get(path, [])
                          if s <= start < e}
                if kind == "OCCURS_NOWHERE" or not (inside & licensed):
                    where = ("outside any licensed result"
                             if kind == "ONLY_IN" else "asserted to occur nowhere")
                    reg_problems.append(
                        f"  {kind}  {subject}  (glossary {ref})\n"
                        f"      {path.name}:{lineno} -- {where}"
                        + (f"; this hit is in {sorted(inside)}" if inside else "")
                        + f"\n      line:    {line.strip()[:130]}")

    if suppressed:
        print(f"  {len(suppressed)} hit(s) suppressed as provenance/narration "
              f"-- listed so the exemption is auditable, not silent:")
        for sline in suppressed:
            print(sline)
        print()
    if reg_problems:
        for p in reg_problems:
            print(p)
        print(f"\n  {len(reg_problems)} register assertion breach(es). Each is either a "
              f"defect in\n  the file or a STALE CLAIM in the glossary -- fix whichever "
              f"is wrong, but\n  do not delete the row to silence it.")
        blocking += len(reg_problems)
    else:
        print(f"  (all {len(REGISTER_ASSERTIONS)} register assertions hold)")


    # ---------------- CHECK 7 --------------------------------------------
    #
    # WHY.  Every symbolic spec's `source:` field is a claim about WHERE a thing
    # is, and this project moves text constantly: the derivation-verifier found
    # only 5 of 40 label citations resolving at the line they cite, median drift
    # +118 lines, maximum +1208 -- one range returning a comment about
    # compactness where it claimed the frontier condition. Five specs cite a path
    # that no longer exists at all, and the archive README explains exactly why
    # those files were moved: a grep over them "returned stale text as if it were
    # live".
    #
    # DECISIVELY: round 12 hand-repointed two of these and BOTH ARE WRONG AGAIN.
    # Hand-repointing rots within two dispatches, which is what makes this a
    # check rather than a chore.
    print("\n[CHECK 7, BLOCKING] symbolic-spec source pointers\n")
    spec_dir = root / "scripts" / "symbolic" / "specs"
    label_line: dict[tuple[str, str], int] = {}
    for tex in [results_tex, proofs_tex, assumptions_tex]:
        try:
            for i, raw in enumerate(tex.read_text(encoding="utf-8").splitlines(), 1):
                for m in re.finditer(r"\\label\{([^}]+)\}", raw):
                    label_line.setdefault((tex.name, m.group(1)), i)
        except OSError:
            continue

    ptr_problems: list[str] = []
    specs = sorted(spec_dir.rglob("*.yaml"))
    TOL = 12   # a citation may name the line above a display; do not be pedantic
    for spec in specs:
        try:
            text = spec.read_text(encoding="utf-8")
        except OSError:
            continue
        src = "\n".join(l for l in text.splitlines()
                        if re.match(r"\s*(source|claim_id|#)", l) or l.startswith("  "))
        for cm in SPEC_CITE.finditer(src):
            fname, lo = cm.group(1), int(cm.group(2))
            hi = int(cm.group(3)) if cm.group(3) else lo
            if not (root / "quality_reports" / "theory" / args.project / fname).exists():
                ptr_problems.append(f"  {spec.name}\n"
                                    f"      ABSENT PATH  cites {fname}, which does not exist "
                                    f"(archived or renamed)")
                continue
            window = src[max(0, cm.start() - 240): cm.end() + 240]
            for lm in SPEC_LABEL.finditer(window):
                key = (fname, lm.group(1))
                if key not in label_line:
                    continue
                actual = label_line[key]
                if not (lo - TOL <= actual <= hi + TOL):
                    ptr_problems.append(
                        f"  {spec.name}\n"
                        f"      DRIFT  cites {fname}:{lo}"
                        + (f"-{hi}" if hi != lo else "")
                        + f" for {lm.group(1)}, which is at {fname}:{actual} "
                          f"({actual - lo:+d})")
                    break
    if ptr_problems:
        seen_p: set[str] = set()
        for pp in ptr_problems:
            if pp not in seen_p:
                print(pp); seen_p.add(pp)
        print(f"\n  {len(seen_p)} spec(s) with a source pointer that no longer resolves, "
              f"of {len(specs)} specs.\n  A spec that passes while its source pointer is "
              f"wrong still verifies its identity --\n  but a reader cannot check WHAT it "
              f"verifies, which is most of the value.")
        blocking += len(seen_p)
    else:
        print(f"  (all source pointers in {len(specs)} specs resolve)")

    # ---------------- CHECK 8 --------------------------------------------
    #
    # WHY.  A retirement is two edits: mark the clause, then sweep the live text
    # that still treats the tag as maintained. B1(vi) got the first and not the
    # second -- and the same dispatch DID run the full sweep for A2'(ii), so the
    # discipline exists and only the verification was missing.
    print("\n[CHECK 8, BLOCKING] retired tags described as maintained\n")
    #
    # NARROWED AFTER TWO CALIBRATION RUNS, and the narrowing is the design.
    #
    # The first draft asked "is a retired tag mentioned without a retirement
    # marker nearby". That fires 31 times, and ~29 are legitimate: REFUTING a
    # clause requires DISCUSSING it, so A6 -- which a whole proposition and four
    # remarks exist to refute -- generates twenty hits that are the refutation
    # itself. A check with that signal-to-noise gets switched off, which is the
    # notation-warden's own standard: "a sweep nobody trusts is a sweep nobody
    # runs."
    #
    # What the real defect actually looked like is narrower and mechanical. The
    # assumption-auditor found B1(vi) described with a PRESENT-TENSE COPULA as a
    # KIND OF ASSUMPTION -- "B1(vi) is an identification assumption rather than an
    # approximation device" -- in the printed Discussion paragraph and in a
    # compiled rendering. That is a claim about the tag's CURRENT STATUS, and it
    # is what a retirement must sweep. Discussion of a tag's falsity is not.
    #
    # So CHECK 8 tests exactly that shape and nothing else. It will miss a
    # status claim phrased another way; it will not cry wolf, which is the
    # property that decides whether it survives.
    STATUS_CLAIM = re.compile(
        r"\b(is|are|remains?|stays?)\s+(an?\s+|the\s+)?"
        r"(maintained|identification|standing|primitive|regularity|design)?\s*"
        r"(assumption|restriction|condition|requirement|hypothesis)\b", re.I)
    ret_problems: list[str] = []
    ret_targets = [results_tex, proofs_tex, assumptions_tex] + renders
    for path in ret_targets:
        try:
            lines = path.read_text(encoding="utf-8").splitlines()
        except OSError:
            continue
        for lineno, raw in enumerate(lines, 1):
            line = re.sub(r"(?<!\\)%.*$", "", raw)
            if not line.strip():
                continue
            # SAME-LINE suppression only. A neighbouring line recording the
            # retirement does not license this line calling the tag a current
            # assumption -- that pairing is precisely the B1(vi) defect, where the
            # clause was marked and the Discussion paragraph two hundred lines
            # away was not. Context suppression here cost two of the three known
            # sites on the calibration run.
            if RETIREMENT_MARKER.search(line):
                continue
            for pat, name, where in RETIRED_TAGS:
                m = re.search(pat, line)
                if not m:
                    continue
                # JOIN THE FOLLOWING LINE before testing. LaTeX wraps at ~100
                # characters and the status phrase straddles the break at two of
                # the three known sites -- "B1(vi) is an identification" ends one
                # line and "assumption" opens the next. Joining is safe HERE and
                # not for suppression: this widens what a POSITIVE match can see,
                # where widening a suppression window would widen the laundering
                # surface (the sentence-scope revert, and the VERBATIM_OPEN bug).
                nxt = re.sub(r"(?<!\\)%.*$", "", lines[lineno]) if lineno < len(lines) else ""
                tail = (line[m.end():] + " " + nxt.strip())[:120]
                if STATUS_CLAIM.search(tail):
                    ret_problems.append(
                        f"  {path.name}:{lineno}\n"
                        f"      retired: {name}  ({where})\n"
                        f"      claim:   {line.strip()[:120]}")
    if ret_problems:
        for rp in ret_problems:
            print(rp)
        print(f"\n  {len(ret_problems)} live site(s) describing a retired tag as a current\n"
              f"  assumption. A retirement is two edits -- mark the clause, then sweep\n"
              f"  the text that still calls it maintained. This is the second edit.")
        blocking += len(ret_problems)
    else:
        print("  (no retired tag is described as a current assumption)")

    # ---------------- verdict --------------------------------------------

    print("\n" + "=" * 78)
    print(f"BLOCKING findings : {blocking}")
    print(f"ADVISORY findings : {advisory}")
    print("=" * 78)

    if args.advisory_only:
        return 0
    return 1 if blocking else 0


if __name__ == "__main__":
    sys.exit(main())
