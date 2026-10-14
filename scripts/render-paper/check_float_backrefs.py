#!/usr/bin/env python3
"""Flag prose back-references inside float captions and notes.

CLASS 11, found 2026-08-28.  A note that says "the absence of shrinkage
DISCUSSED IN THE TEXT" is a pointer with no check behind it.  It names no
label, no float and no ordinal, so \\cref cannot bind it, the caption census
cannot see it, and none of the five forms the xdoc resolver handles reaches
it.  Unlike the ordinal classes it is not machine-decidable EVEN IN PRINCIPLE
-- there is no target to resolve against -- so this surfaces rather than
resolves, and never fails a build.

It shipped once: fig:app-phi's note pointed at a sentence that had been cut
with the rest of section 6.3 the previous day.  Nothing in the pipeline could
see it.

The defence is a discipline, not a gate: ANY PASS THAT DELETES PROSE MUST
CHECK THIS LIST, because the sentence it removes may be the referent of a note
somewhere else in the document.  This script exists to make that list cheap.

Usage:  check_float_backrefs.py <file.qmd> [<file.qmd> ...]
"""
import re
import sys

# Deictic reference to prose, with no resolvable target.
PAT = re.compile(
    r"(discussed|noted|shown|described|argued|explained|stated|given)\s+"
    r"(in the text|above|below|earlier|there)"
    r"|as\s+(noted|shown|argued|described)\s+(above|earlier|below)"
    r"|the\s+(text|discussion)\s+(above|below|earlier)",
    re.I,
)
FLOAT = re.compile(r"\\begin\{(table|figure)\}.*?\\end\{\1\}", re.S)


def strip_comments(text):
    """Drop LaTeX comments. `\\%' is an escaped percent and is not a comment."""
    return "\n".join(re.sub(r"(?<!\\)%.*$", "", line) for line in text.split("\n"))


def scan(path):
    src = strip_comments(open(path, encoding="utf-8").read())
    out = []
    for m in FLOAT.finditer(src):
        block = m.group(0)
        lab = re.search(r"\\label\{([^}]+)\}", block)
        for h in PAT.finditer(block):
            j = h.start()
            ctx = " ".join(block[max(0, j - 95):j + 50].split())
            out.append((lab.group(1) if lab else "(unlabelled float)", ctx))
    return out


def main(argv):
    total = 0
    for path in argv:
        hits = scan(path)
        total += len(hits)
        name = path.rsplit("/", 1)[-1]
        if not hits:
            print(f"  {name}: no prose back-references inside floats")
            continue
        print(f"  {name}: {len(hits)} prose back-reference(s) inside floats "
              f"-- UNRESOLVABLE, check each by hand")
        for lab, ctx in hits:
            print(f"    [{lab}] ...{ctx}...")
    if total:
        print("  These cannot be resolved automatically. If a pass deleted prose,")
        print("  confirm each referent still exists.")
    return 0            # advisory only, never fails a build


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
