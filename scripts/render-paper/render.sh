#!/usr/bin/env bash
#
# Render the Quarto manuscript with TinyTeX, and report what the exit code hides.
#
#   Usage:  scripts/render-paper/render.sh [main|supplement|<file.qmd>]
#           (default: main)
#
# WHY A WRAPPER RATHER THAN `quarto render'.
#
# `quarto render' asks the OS for `pdflatex' by name.  On a machine with two TeX
# distributions that is a coin toss decided by PATH ordering, and here it lands
# on the one distribution that CANNOT compile this preamble (no siunitx).  The
# fix belongs in the environment, not in _quarto.yml: an absolute engine path in
# a committed template breaks every fork.  scripts/lib/tex-env.sh discovers
# TinyTeX and puts it first; this script sources it and says which tree won.
#
# WHY IT RE-READS THE LOG.  Same reason build.sh does, and the reason is not
# theoretical on this project: an undefined citation is a LaTeX *warning*.  biber
# reports a missing database entry, LaTeX continues, quarto exits 0, and the PDF
# renders "[?]" where the reference should be.  Eight of fourteen cited keys were
# in that state once.  A green exit code is not a verification.

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HERE/../.." && pwd)"
QMD_DIR="$ROOT/paper/qmd"

# shellcheck source=../lib/tex-env.sh
. "$ROOT/scripts/lib/tex-env.sh"

TARGET="${1:-main}"
case "$TARGET" in
    *.qmd) SRC="$TARGET" ;;
    *)     SRC="$TARGET.qmd" ;;
esac

[[ -f "$QMD_DIR/$SRC" ]] || { echo "FATAL: no such source: $QMD_DIR/$SRC"; exit 2; }
command -v quarto >/dev/null || { echo "FATAL: quarto is not on PATH."; exit 2; }

echo "source    : paper/qmd/$SRC"
tex_env_report pdflatex
echo

cd "$QMD_DIR" || exit 2
quarto render "$SRC" --to pdf > render.log 2>&1
RC=$?

# The .log that pandoc's LaTeX pass leaves behind, not quarto's own chatter.
STEM="${SRC%.qmd}"
TEXLOG="$QMD_DIR/$STEM.log"
PDF="$QMD_DIR/_output/$STEM.pdf"
[[ -f "$PDF" ]] || PDF="$QMD_DIR/$STEM.pdf"

pages=""
[[ -f "$PDF" ]] && pages="$(pdfinfo "$PDF" 2>/dev/null | awk '/^Pages:/{print $2}')"

echo "quarto exit code  : $RC   ${pages:+(${pages} pages)}"

# Findings visible ONLY in quarto's own output, never in the LaTeX log.  Both of
# these were live on the first green run of this script and neither touched the
# exit code:
#   * biber "Cannot find '<file>.bib'" -- every citekey silently becomes "[?]"
#   * "maximum number of runs (N) reached" -- cross-references never converged,
#     so page numbers and \cref targets in the PDF may simply be wrong
BIBER_ERR="$(grep -E "ERROR - Cannot find|ERROR - Cannot find file" "$QMD_DIR/render.log" 2>/dev/null | sed 's/^ *//')"
MAXRUNS="$(grep -E "maximum number of runs" "$QMD_DIR/render.log" 2>/dev/null | sed 's/^ *//; s/\x1b\[[0-9;]*m//g')"

if [[ -n "$BIBER_ERR" || -n "$MAXRUNS" ]]; then
    echo
    echo "  QUARTO-LEVEL FINDINGS (invisible in the LaTeX log, and exit code $RC did not reflect them):"
    [[ -n "$BIBER_ERR" ]] && printf '%s\n' "$BIBER_ERR" | sed 's/^/      /'
    [[ -n "$MAXRUNS"   ]] && printf '%s\n' "$MAXRUNS"   | sed 's/^/      /'
fi

# THE CAPTION CENSUS.  IT IS THE ONLY CHECK IN THIS SCRIPT THAT CAN SEE A LOST
# CAPTION, AND IT LIVED IN A LaTeX COMMENT UNTIL 2026-08-23.
#
# rotating.sty places a `sidewaystable' by ZEROING the float box's \wd, \ht and
# \dp and dropping the rotated box into \hbox to\columnwidth{\hss ...\hss}.  The
# reference point therefore lands at the centre of the text block and the content
# spans page-x [centre - \ht, centre + \dp].  THE WALL IS \paperwidth (614.295pt
# on letter), not \textwidth and not \textheight, and an overrun sheds at BOTH
# ENDS AT ONCE: no "Overfull \hbox", no "Float too large", exit code 0, clean log.
# The head of that box carries the CAPTION and the tail carries the note's last
# line, so a document can ship a table with no caption at all.  It has, twice:
# tab:sim-stopping printed 4, 6 in the article, and tab:supp-app-phimult prints
# no "Table S23:" in the supplement as this was written.
#
# A per-float canary does not close it.  A one-ended canary cannot see a
# two-ended failure, and the list of floats worth watching is itself the thing
# that goes stale.  The census needs no list: it reads the numbers the document
# PRINTED and looks for a hole.  A missing caption is a hole by construction.
#
# FLATTEN BEFORE MATCHING.  pdftotext wraps, and a label split across lines
# ("Table" / "S23:") is invisible to a line-wise grep -- which is how an earlier
# hand-run of this census returned a false clean.  `S?' carries the supplement's
# S-prefixed numbering, and pulling the digits out of the match handles both
# documents with one pattern.
census() {          # census <Table|Figure>  ->  sorted unique printed numbers
    pdftotext "$PDF" - 2>/dev/null | tr -s '[:space:]' ' ' \
        | grep -oE "$1 S?[0-9]+:" | grep -oE '[0-9]+' | sort -n -u
}
census_gaps() {     # census_gaps <newline-separated numbers>  ->  the missing ones
    printf '%s\n' "$1" | awk 'NF{ if(!seen){lo=$1; seen=1} hi=$1; n[$1]=1 }
        END{ if(!seen) exit; for(i=lo;i<=hi;i++) if(!(i in n)) printf "%d ", i }'
}

echo
CENSUS_GAPS=""
if [[ ! -f "$PDF" ]] || ! command -v pdftotext >/dev/null; then
    printf '  %-24s %s\n' "caption census:" "SKIPPED (no PDF, or pdftotext not on PATH)"
else
    for KIND in Table Figure; do
        NUMS="$(census "$KIND")"
        if [[ -z "$NUMS" ]]; then
            printf '  %-24s %s\n' "$KIND captions:" "none printed"
            continue
        fi
        printf '  %-24s %s\n' "$KIND captions:" \
            "$(printf '%s\n' "$NUMS" | grep -c .) printed, $(printf '%s\n' "$NUMS" | head -1)..$(printf '%s\n' "$NUMS" | tail -1)"
        MISS="$(census_gaps "$NUMS")"
        [[ -n "$MISS" ]] && CENSUS_GAPS="${CENSUS_GAPS}${KIND} number(s) numbered but never printed: ${MISS% }
"
    done
    # Read from the rendered PDF, never from the .log: the log is what missed it,
    # and that is also why this block sits ABOVE the "no LaTeX log" bail-out below.
    # A census gated on the log would inherit the blindness it exists to fix.
    if [[ -z "$CENSUS_GAPS" ]]; then
        printf '  %-24s %s\n' "caption-number gaps:" "none"
    else
        printf '  %-24s %d\n' "caption-number gaps:" "$(printf '%s' "$CENSUS_GAPS" | grep -c .)"
        printf '%s' "$CENSUS_GAPS" | sed 's/^/      /'
    fi
fi

if [[ ! -f "$TEXLOG" ]]; then
    echo
    echo "NO LaTeX LOG at $TEXLOG -- the per-reference findings cannot be computed."
    echo "Set 'latex-clean: false' under format.pdf in _quarto.yml to keep it."
    echo "Read $QMD_DIR/render.log for what quarto reported."
    exit "$RC"
fi

# Findings the exit code hides.  Unresolved citations are read from the FINAL
# pass only: earlier passes report every key as undefined before the .bbl exists,
# so grepping the whole log over-reports and trains you to ignore it.
report() {
    local label="$1" body="$2" n
    if [[ -z "$body" ]]; then
        printf '  %-24s %s\n' "$label:" "none"
    else
        n="$(printf '%s\n' "$body" | grep -c .)"
        printf '  %-24s %d\n' "$label:" "$n"
        printf '%s\n' "$body" | sed 's/^/      /'
    fi
}

echo
report "hard errors"        "$(grep '^!' "$TEXLOG" 2>/dev/null)"
report "undefined refs"     "$(grep -o "Reference \`[^']*' on page [0-9]* undefined" "$TEXLOG" 2>/dev/null | sort -u)"
report "multiply defined"   "$(grep -o "Label \`[^']*' multiply defined" "$TEXLOG" 2>/dev/null | sort -u)"
# PATTERN WIDENED 2026-08-01, AND THE OLD ONE WAS A MEASUREMENT BLINDNESS.
# It anchored on a BACKTICK -- Citation `key' -- and on the literal " on page N".
# xelatex writes the warning with a STRAIGHT QUOTE and does not always carry the
# page clause, so this check reported "unresolved cites: none" on a run whose
# .bbl was ZERO BYTES and whose every citation rendered as bare key text. The
# article had no bibliography and this script said it was clean. build.sh's
# pattern was right all along; this now matches it.
report "unresolved cites"   "$(grep -oE "Citation .[^']+.[^.]*undefined" "$TEXLOG" 2>/dev/null | sort -u)"

# ---- CLASS 8: CROSS-DOCUMENT ORDINAL ROT ----------------------------------
# A pointer that names a float by its PRINTED NUMBER IN THE OTHER DOCUMENT --
# "Table 26 of the article" -- has no defence anywhere else in this pipeline.
# It cannot use \cref (separate documents).  The caption census above cannot see
# it: the census looks for HOLES in a numbering, and a pointer to a number that
# still exists leaves no hole.  A per-float canary cannot see it: canaries grep
# for strings, and the string still prints.  Both documents exit 0.
#
# It is invalidated by ANY float insertion above the target -- including a
# correct one, made for a good reason, in a different section, by someone who
# never opened the other file.  On 2026-08-27 two new tables were inserted at
# positions 16 and 20 of the article; that moved tab:app-phi from Table 26 to
# Table 28, and SIX supplement sites went on pointing at "Table 26 of the
# article", which is now a theta-hat table with no Panel C, no percentiles and
# no envelope.  Every automated check reported CLEAN.
#
# AN EXISTENCE CHECK IS NOT ENOUGH, and that is the whole difficulty: Table 26
# still exists.  So this resolves each pointer to the CAPTION TEXT it actually
# lands on and prints it.  A wrong pointer then reads as an obvious mismatch in
# the log instead of being invisible.  Out-of-range pointers are a hard failure;
# in-range ones are printed for eyeball, because only a human (or a reviewing
# pass) knows which table the sentence MEANT.
XDOC_FAIL=""
if [[ ! -f "$PDF" ]] || ! command -v pdftotext >/dev/null; then
    printf '  %-24s %s\n' "xdoc pointers:" "SKIPPED (no PDF, or pdftotext not on PATH)"
else
    XDOC_OUT="$(python3 - "$PDF" "$QMD_DIR/_output/main.pdf" "$QMD_DIR/_output/supplement.pdf" <<'PYEOF'
import re, subprocess, sys, os
this_pdf, main_pdf, supp_pdf = sys.argv[1], sys.argv[2], sys.argv[3]

def flat(path):
    if not os.path.exists(path):
        return None
    out = subprocess.run(["pdftotext", path, "-"], capture_output=True, text=True).stdout
    return " ".join(out.split())

def captions(text, kind):
    # "Table 26: The iteration cap, held fixed and then varied." -> {26: "The iteration cap..."}
    #
    # THE MATCH CONSUMES THE LABEL ONLY, AND THAT IS A BUG FIX, 2026-08-27.
    # This read `re.finditer(rf"{kind} (S?)(\d+): (.{{0,90}})", text)', which
    # consumes the label PLUS 90 characters.  `finditer' does not overlap, so a
    # caption printed within 90 characters of the previous one was swallowed and
    # never entered the dictionary -- and a pointer at it then resolved to
    # "!! NOT PRINTED (out of range)" for a float that prints perfectly well.
    # It fired the first time two captions landed adjacent in the extracted
    # text: on 2026-08-27 tab:app-phi arrived in the supplement as S43 with
    # tab:supp-app-bootcompare at S44 seventy-eight characters later, and
    # "Table S44 of the supplement" was reported out of range while the caption
    # census counted S1..S49 with no gaps.  A check that cries wolf gets ignored,
    # and the next wolf goes with it.
    #
    # The fix consumes the label alone and slices the text afterwards, so every
    # printed caption is seen however tightly they pack.  It can only make the
    # resolver see MORE captions, never fewer, so it cannot mask a real
    # out-of-range pointer.  The trailing split also stops the printed
    # resolution from running one caption into the next.
    d = {}
    for m in re.finditer(rf"{kind} (S?)(\d+):", text):
        n = int(m.group(2))
        if n in d:
            continue
        tail = text[m.end():m.end() + 92]
        tail = re.split(r"(?:Table|Figure) S?\d+:", tail)[0]
        d[n] = tail.strip()
    return d

this_t = flat(this_pdf)
targets = {"article": flat(main_pdf), "supplement": flat(supp_pdf)}
this_is = "main" if os.path.abspath(this_pdf) == os.path.abspath(main_pdf) else "supplement"

# CLASS 9, FOUND 2026-08-27: the canonical form is not the only form.
# "of the article" is what this check was written for, but the same pointer is
# also written possessively ("the article's Table 1") and deictically ("its
# Table 6", "Table S22 there").  TEN such sites were live when this was added
# and ONE WAS ALREADY ROTTEN -- the supplement's ladder notes read "the article
# reads this table against its Table 23", where Table 23 was the first-stage
# table (OLS, reduced form, linear IV) while the description it carried was the
# theta table at Table 25.
#
# Possessives carry their document and resolve exactly like the canonical form.
# Deictics do NOT: "its" and "there" take their referent from a sentence this
# script cannot parse, so they are printed as UNRESOLVED rather than guessed.
# That is the same principle as the in-range case below -- convert an invisible
# pointer into a visible one and let a reader settle it.
pat = re.compile(r"(Table|Figure) (S?)(\d+) of the (article|supplement)")
pat_poss = re.compile(r"the (article|supplement)'s (Table|Figure) (S?)(\d+)")
pat_deix = re.compile(r"(Table|Figure) (S?)(\d+) there|its (Table|Figure) (S?)(\d+)")

# CLASS 10 AND THE COMPOUND FORM, BOTH FOUND 2026-08-27 DURING THE SECTION 6 CUT,
# AND BOTH HAD LIVE ROTTEN INSTANCES THE PRECEDING SWEEP HAD REPORTED CLEAN.
#
# BARE: an S-number with NO document clause at all -- "Descriptive statistics
# are in Table S16".  Two were live in section 6 and BOTH had been wrong since
# the section 5 block move: S16 was a Monte Carlo cardinality table (S35 was
# meant), and "Table S19 prints ten of them as rows" pointed at Design H
# standard-error units (S38 was meant).  The preceding sweep reported every
# section 6 pointer re-resolved, and that was true of every form it looked for.
#
# The bare form IS machine-decidable, because the two documents number
# disjointly: the article prints 1..N and the supplement prints S1..SM.  So in
# the article a bare S-number can only be the supplement, and in the supplement
# a bare un-prefixed number can only be the article.  The un-prefixed direction
# is the noisier one -- a quoted title or a foreign paper's table can look like
# it -- which is another reason this resolves and prints rather than asserting.
#
# COMPOUND: "Tables S44 and S45 of the supplement" is invisible to the canonical
# pattern, which needs the literal `Table' before each number.  One instance was
# written by the very pass that was repairing the others.
pat_comp = re.compile(r"(?:Tables|Figures) (S?)(\d+) and (S?)(\d+) of the (article|supplement)")
# `(?!\d)' IS LOAD-BEARING: without it the engine backtracks to a PREFIX of the
# number to satisfy the lookahead, so "Table 26 of the article" also matched as a
# bare "Table 2" and reported a float that was never referenced.  A check that
# invents pointers is worse than one that misses them.
pat_bare = re.compile(r"(?<!of the )(?<!the )(Table|Figure) (S?)(\d+)(?!\d)(?! of the)(?! there)")
seen, bad = {}, 0
for m in pat.finditer(this_t or ""):
    kind, sflag, num, doc = m.group(1), m.group(2), int(m.group(3)), m.group(4)
    # a document pointing at itself is an intra-document reference; \cref owns those
    if (doc == "article") == (this_is == "main"):
        continue
    key = (kind, sflag, num, doc)
    if key in seen:
        seen[key] += 1
        continue
    seen[key] = 1
    other = targets[doc]
    if other is None:
        print(f"  {kind} {sflag}{num} of the {doc:<10} -> OTHER DOCUMENT NOT RENDERED (cannot resolve)")
        continue
    caps = captions(other, kind)
    if num not in caps:
        print(f"  {kind} {sflag}{num} of the {doc:<10} -> !! NOT PRINTED in the {doc} (out of range)")
        bad += 1
    else:
        print(f"  {kind} {sflag}{num} of the {doc:<10} -> \"{caps[num]}\"")
# possessive form -- resolves the same way
for m in pat_poss.finditer(this_t or ""):
    doc, kind, sflag, num = m.group(1), m.group(2), m.group(3), int(m.group(4))
    if (doc == "article") == (this_is == "main"):
        continue
    key = (kind, sflag, num, doc)
    if key in seen:
        continue
    seen[key] = 1
    other = targets[doc]
    if other is None:
        print(f"  the {doc}'s {kind} {sflag}{num} -> OTHER DOCUMENT NOT RENDERED")
        continue
    caps = captions(other, kind)
    if num not in caps:
        print(f"  the {doc}'s {kind} {sflag}{num} -> !! NOT PRINTED in the {doc}")
        bad += 1
    else:
        print(f"  the {doc}'s {kind} {sflag}{num} -> \"{caps[num]}\"")

# compound form -- same document clause, two numbers
for m in pat_comp.finditer(this_t or ""):
    doc = m.group(5)
    if (doc == "article") == (this_is == "main"):
        continue
    kind = "Table" if "Tables" in m.group(0) else "Figure"
    for sflag, num in ((m.group(1), int(m.group(2))), (m.group(3), int(m.group(4)))):
        key = (kind, sflag, num, doc)
        if key in seen:
            continue
        seen[key] = 1
        other = targets[doc]
        caps = captions(other, kind) if other else {}
        if other is None:
            print(f"  [compound] {kind} {sflag}{num} of the {doc} -> OTHER DOCUMENT NOT RENDERED")
        elif num not in caps:
            print(f"  [compound] {kind} {sflag}{num} of the {doc} -> !! NOT PRINTED"); bad += 1
        else:
            print(f"  [compound] {kind} {sflag}{num} of the {doc} -> \"{caps[num]}\"")

# bare form -- no document clause; direction fixed by the S-prefix convention
for m in pat_bare.finditer(this_t or ""):
    kind, sflag, num = m.group(1), m.group(2), int(m.group(3))
    doc = "supplement" if sflag == "S" else "article"
    if (doc == "article") == (this_is == "main"):
        continue          # un-prefixed number in the article is its own float
    key = (kind, sflag, num, doc)
    if key in seen:
        continue
    seen[key] = 1
    other = targets[doc]
    caps = captions(other, kind) if other else {}
    if other is None:
        print(f"  [bare] {kind} {sflag}{num} -> OTHER DOCUMENT NOT RENDERED")
    elif num not in caps:
        print(f"  [bare] {kind} {sflag}{num} -> !! NOT PRINTED in the {doc}"); bad += 1
    else:
        print(f"  [bare] {kind} {sflag}{num} (no document clause) -> \"{caps[num]}\"")

# deictic form -- referent is not machine-decidable; surface, never guess
deix = set()
for m in pat_deix.finditer(this_t or ""):
    g = [x for x in m.groups() if x is not None]
    deix.add(" ".join(g))
for d in sorted(deix):
    print(f"  DEICTIC \"{d}\" -> UNRESOLVED: referent not machine-decidable, check by hand")

if not seen and not deix:
    print("  (no cross-document ordinal pointers)")
print(f"__XDOC_BAD__{bad}")
PYEOF
)"
    XDOC_BAD="$(printf '%s\n' "$XDOC_OUT" | grep -o '__XDOC_BAD__[0-9]*' | grep -o '[0-9]*$')"
    printf '  %-24s\n' "xdoc pointers:"
    printf '%s\n' "$XDOC_OUT" | grep -v '__XDOC_BAD__'
    if [[ -n "$XDOC_BAD" && "$XDOC_BAD" -gt 0 ]]; then
        XDOC_FAIL="$XDOC_BAD out-of-range cross-document pointer(s)"
        printf '  %-24s %s\n' "" "!! $XDOC_FAIL"
    fi
    printf '  %-24s %s\n' "" "resolved captions above are NOT auto-verified: read them."
fi

# ---- CLASS 11: PROSE BACK-REFERENCES INSIDE FLOATS ------------------------
# ADVISORY, AND DELIBERATELY SO.  A note reading "the absence of shrinkage
# discussed in the text" names no label, no float and no ordinal, so \cref
# cannot bind it, the caption census cannot see it, and none of the five forms
# the resolver above handles reaches it.  Unlike those, it is not
# machine-decidable EVEN IN PRINCIPLE -- there is no target to resolve against.
# So this surfaces and never fails the build.
#
# It shipped once, on 2026-08-28: fig:app-phi's note pointed at a sentence cut
# with the rest of section 6.3 the previous day, and nothing in the pipeline
# could see it.  The defence is a discipline -- any pass that DELETES PROSE
# must read this list, because the sentence it removes may be some float note's
# referent -- and this exists to make that list cheap rather than to gate.
#
# Source-level, not PDF-level: the referent is a claim about the source, and a
# rendered page cannot tell you whether a sentence was deleted yesterday.
# $ROOT and $QMD_DIR are the variables this script actually defines; an earlier
# draft of this block referenced a $SCRIPT_DIR that does not exist here, which
# would have made the check SKIP SILENTLY FOREVER while printing a reassuring
# line.  That is the failure this whole file exists to catch, so the skip is
# printed loudly and names which of the two preconditions failed.
BACKREF="$ROOT/scripts/render-paper/check_float_backrefs.py"
printf '  %-24s\n' "float back-refs:"
if [[ ! -f "$BACKREF" ]]; then
    printf '  %-24s %s\n' "" "!! NOT RUN: checker missing at $BACKREF"
elif ! command -v python3 >/dev/null; then
    printf '  %-24s %s\n' "" "!! NOT RUN: python3 not on PATH"
else
    python3 "$BACKREF" "$QMD_DIR/$SRC"
fi

echo
if [[ $RC -eq 0 && -f "$PDF" ]] \
   && ! grep -q '^!' "$TEXLOG" 2>/dev/null \
   && [[ -z "$BIBER_ERR" && -z "$MAXRUNS" && -z "$CENSUS_GAPS" && -z "$XDOC_FAIL" ]] \
   && ! grep -q "undefined" "$TEXLOG" 2>/dev/null; then
    echo "CLEAN: renders, and nothing the exit code would have hidden."
else
    echo "NOT CLEAN: see the findings above and $QMD_DIR/render.log."
fi
echo "log: $TEXLOG    pdf: ${PDF:-none}"

exit "$RC"
