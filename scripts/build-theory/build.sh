#!/usr/bin/env bash
#
# Compile the theory corpus of a project and report what a compiler -- and only
# a compiler -- can tell you.
#
#   Usage:  scripts/build-theory/build.sh [project-slug]
#           (default slug: panel-npiv-discrete)
#
# WHAT THIS IS FOR, AND WHY IT REPORTS WHAT IT REPORTS.
#
# `latexmk' exiting 0 is NOT a verification, and on this project that gap was
# load-bearing for weeks.  An undefined citation is a LaTeX *warning*: biber says
# "I didn't find a database entry", LaTeX carries on, the build exits 0, and the
# document renders "[?]" where the reference should be.  Eight of fourteen cited
# keys were in that state, and two of the eight had been flagged by nobody.
#
# So this script separates the exit code from the findings, and reports the
# findings the exit code hides:
#
#   * hard errors            -- would stop a human, do stop the build
#   * undefined references   -- \ref/\cref/\eqref pointing at nothing
#   * multiply-defined labels-- silently renumbers cross-references
#   * unresolved citations   -- read from the FINAL pass only, because early
#                              passes report everything as undefined before the
#                              .bbl exists; grepping all passes over-reports
#
# It writes into a scratch directory rather than the repo, and leaves the PDF and
# the log behind for inspection.

set -uo pipefail

PROJECT="${1:-panel-npiv-discrete}"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HERE/../.." && pwd)"

# Resolve TeX explicitly.  This build used to reach TinyTeX by accident -- see
# scripts/lib/tex-env.sh for the full story -- and an accident that produces the
# right answer is still an accident.
# shellcheck source=../lib/tex-env.sh
. "$ROOT/scripts/lib/tex-env.sh"
THEORY="$ROOT/quality_reports/theory/$PROJECT"
REFS="$ROOT/quality_reports/literature/$PROJECT/references.bib"
BUILD="${BUILD_DIR:-$ROOT/.build/theory-$PROJECT}"

# THE SPLIT IS THE SOURCE OF RECORD SINCE 2026-08-03. The undivided
# assumptions.tex / results.tex are RETIRED -- see driver.tex for why, and the
# SUPERSEDED banner at the head of each. They are deliberately NOT required
# here and NOT copied below: if they were, a stale parent could still satisfy
# this guard and mask a missing split file.
for f in assumptions_main.tex assumptions_supp.tex \
         results_s2_identification.tex results_s3_estimation.tex \
         results_s3_supp.tex results_s4_asymptotics.tex \
         results_supp.tex proofs.tex; do
    [[ -f "$THEORY/$f" ]] || { echo "FATAL: missing $THEORY/$f"; exit 2; }
done
[[ -f "$REFS" ]] || echo "WARNING: no bibliography at $REFS -- every citation will be undefined"

rm -rf "$BUILD"; mkdir -p "$BUILD/preambles"
cp "$ROOT/paper/preambles/preamble.tex" "$BUILD/preambles/preamble.tex"
cp "$ROOT/paper/latexmkrc"              "$BUILD/latexmkrc"
cp "$THEORY"/{assumptions_main,assumptions_supp}.tex "$BUILD/"
cp "$THEORY"/{results_s2_identification,results_s3_estimation}.tex "$BUILD/"
cp "$THEORY"/{results_s3_supp,results_s4_asymptotics,results_supp}.tex "$BUILD/"
cp "$THEORY"/proofs.tex "$BUILD/"
cp "$HERE/driver.tex"                   "$BUILD/driver.tex"

# THE BIBLIOGRAPHY IS COPIED IN, AND CITED BY BARE FILENAME, ON PURPOSE.
#
# An absolute path in \addbibresource looks like the obvious thing and does not
# work: latexmk resolves .bib sources through its OWN search path before deciding
# whether to run biber, and with $bibtex_use=1 it VETOES the biber run when that
# resolution fails -- logging "Veto of running of 'biber main'" and carrying on to
# exit 0 with no bibliography and every citation rendered [?].
#
# That veto is invisible unless you read the log for it.  An earlier version of
# this script hit it and looked like it worked: it reported all 14 citations
# unresolved rather than the true 8, and produced a PDF two pages shorter with no
# reference list.  It survived because "unresolved citations" was already an
# expected finding, so a total failure hid inside a partial one.
#
# Copying the file makes the build self-contained and takes latexmk's path
# resolution out of the picture entirely.
cp "$REFS" "$BUILD/references.bib" 2>/dev/null || true
# preamble.tex ALREADY carries \addbibresource{Bibliography_base.bib}, so the file
# is copied in but NOT declared again here -- declaring it twice is redundant and
# biblatex does not always warn.
BASEBIB="$ROOT/Bibliography_base.bib"
[[ -f "$BASEBIB" ]] && cp "$BASEBIB" "$BUILD/"

cat > "$BUILD/main.tex" <<'TEX'
\documentclass[12pt]{article}
\input{preamble}
\addbibresource{references.bib}
% \suppref / \suppeq ARE DEFINED HERE AND NOT BY \input-ING paper_header.tex.
% The split files carry these calls because in the MANUSCRIPT they are
% cross-DOCUMENT pointers (article -> supplement) and cannot be \cref.  The
% corpus build puts every file in ONE document, so the pointer is textual here
% too; that is honest -- it renders exactly what the article's reader sees.
% paper_header.tex is NOT \input because it carries its own \addbibresource
% with a relative path, and latexmk resolves .bib sources through its own
% search path before deciding whether to run biber: when that resolution fails
% it VETOES the biber run, logs "Veto of running of 'biber main'", and exits 0
% with no bibliography and every citation rendered [?].  Copying the bib in and
% citing it by bare filename is what avoids that, and declaring a second
% resource by relative path would reintroduce it.
% Definitions copied verbatim from paper_header.tex:44-45.
\providecommand{\suppref}[2]{#1~\textup{S:#2}}
\providecommand{\suppeq}[1]{\textup{(S:#1)}}
\begin{document}
\input{driver}
\end{document}
TEX

echo "project   : $PROJECT"
echo "build dir : $BUILD"
tex_env_report xelatex
echo

cd "$BUILD" || exit 3
latexmk main.tex > build.log 2>&1
RC=$?

pages=$(pdfinfo main.pdf 2>/dev/null | awk '/^Pages/{print $2}')
echo "latexmk exit code : $RC   ${pages:+(${pages} pages)}"
[[ -n "${pages:-}" ]] || echo "  NO PDF PRODUCED"
echo

fail=0
report () {  # report <label> <newline-separated findings>
    local label="$1" body="$2" n
    n=$(printf '%s' "$body" | grep -c . )
    if [[ -z "$body" ]]; then printf '  %-24s none\n' "$label:"
    else printf '  %-24s %d\n' "$label:" "$n"; printf '%s\n' "$body" | sed 's/^/      /'
         fail=$((fail+n)); fi
}

report "hard errors"        "$(grep -E '^! ' build.log)"
report "undefined refs"     "$(grep -oE "Reference '[^']+'[^.]*undefined" build.log \
                                | grep -oE "'[^']+'" | sort -u)"
report "multiply defined"   "$(grep -oE "Label '[^']+' multiply defined" build.log | sort -u)"
# A \ref or \cref to an UNNUMBERED environment is invisible to every check
# above: the label exists, so it is not an undefined reference, and LaTeX emits
# no warning.  It silently prints whatever counter last incremented -- nothing at
# all here, the section number in the article.  82 such calls accumulated across
# four files before anyone read the PDF closely enough to notice.  `assumption'
# is declared \newtheorem*{assumption} at preamble.tex:283, so ANY \ref{ass:...}
# is wrong by construction.  Cite the tag (A5, H1, C2') in running text instead.
# Comments are stripped from each SOURCE line before matching.  A first draft
# filtered grep's OUTPUT lines instead, which begin "file:line:" and so never
# start with % -- it duly reported this very header as a violation.
assumption_refs="$(for f in "$THEORY"/*.tex; do
    awk -v F="$(basename "$f")" '{ line=$0; sub(/(^|[^\\])%.*/, "", line)
        if (match(line, /\\(c|C)?ref\{ass:[^}]*\}/))
            printf "%s:%d:%s\n", F, NR, substr(line, RSTART, RLENGTH) }' "$f"
  done)"
report "assumption refs"    "$assumption_refs"

# FINAL PASS ONLY -- main.log is the last xelatex run; build.log concatenates all
# of them and reports pre-.bbl citations that in fact resolve.
report "unresolved cites"   "$(grep -oE "Citation '[^']+'[^.]*undefined" main.log 2>/dev/null \
                                | grep -oE "'[^']+'" | sort -u)"

echo
if [[ $RC -eq 0 && $fail -eq 0 ]]; then
    echo "CLEAN: compiles, and nothing the exit code would have hidden."
else
    echo "$fail finding(s). NOTE: a nonzero count with exit code 0 is the normal"
    echo "case for missing citations -- the build succeeds and renders [?]."
fi
echo "log: $BUILD/build.log    pdf: $BUILD/main.pdf"
exit $(( RC != 0 ? RC : 0 ))
