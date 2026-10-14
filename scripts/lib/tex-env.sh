# shellcheck shell=bash
#
# Put TinyTeX first on PATH.  SOURCE this, do not execute it.
#
#   . "$ROOT/scripts/lib/tex-env.sh"
#
# WHY THIS FILE EXISTS.
#
# A machine can carry more than one TeX distribution, and then "which engine ran"
# stops being a property of the project and becomes a property of PATH ordering.
# That is what happened here.  On the author's machine:
#
#   /opt/local/bin   MacPorts TeX Live 2026  -- earlier on PATH, HAS NO siunitx
#   /usr/local/bin   symlinks into TinyTeX   -- later on PATH, has siunitx
#
# paper/preambles/preamble.tex loads siunitx unconditionally, so the two
# distributions are not interchangeable for this project: one builds it and one
# cannot.  Yet the theory build worked for weeks, because `latexmk' happens to
# exist ONLY in TinyTeX's tree and drags TinyTeX's engines along with it, while a
# bare `pdflatex' resolves to MacPorts.  Two tools, two answers, no diagnostic.
# Quarto asks for `pdflatex' by name and therefore died on "siunitx.sty not
# found" -- a failure that looks like a Quarto problem and is not.
#
# An accident that produces the right answer is still an accident.  Installing
# latexmk into MacPorts would have silently flipped the theory build onto an
# engine that cannot compile the preamble.  So both build paths now source this
# and say out loud which tree they are using.
#
# WHY NOT AN ABSOLUTE PATH IN _quarto.yml.  Machine paths do not belong in a
# committed template -- see .claude/rules/meta-governance.md.  This file
# DISCOVERS TinyTeX instead of naming it, so a fork with TinyTeX somewhere else,
# or on another architecture, or with no TinyTeX at all, still works.
#
# NOT FINDING TinyTeX IS NOT AN ERROR.  A forker with a complete TeX Live needs
# no help from this file.  It warns, changes nothing, and lets the caller run
# against whatever is already on PATH -- the caller reports the failure if one
# comes.  Set TINYTEX_ROOT to override discovery.

tex_env_activate() {
    local root candidate archdir

    if [[ -n "${TINYTEX_ROOT:-}" ]]; then
        root="$TINYTEX_ROOT"
        [[ -d "$root" ]] || {
            echo "tex-env: TINYTEX_ROOT is set to '$root' but that is not a directory." >&2
            return 1
        }
    else
        for candidate in \
            "$HOME/Library/TinyTeX" \
            "$HOME/.TinyTeX" \
            "$HOME/AppData/Roaming/TinyTeX"
        do
            [[ -d "$candidate" ]] && { root="$candidate"; break; }
        done
    fi

    if [[ -z "${root:-}" ]]; then
        echo "tex-env: no TinyTeX found; using whatever TeX is already on PATH." >&2
        return 0
    fi

    # One arch subdirectory under bin/ (universal-darwin, x86_64-linux, ...).
    # Globbed rather than named so this survives a machine or OS change.
    archdir="$(find "$root/bin" -maxdepth 1 -mindepth 1 -type d 2>/dev/null | head -1)"
    if [[ -z "$archdir" ]]; then
        echo "tex-env: '$root' exists but has no bin/<arch> directory; leaving PATH alone." >&2
        return 0
    fi

    export PATH="$archdir:$PATH"
    export TEX_ENV_ACTIVE="$archdir"
    return 0
}

# Report the engine actually resolved, and whether it can load the one package
# that distinguishes the two trees on this machine.  Printing this is the whole
# point: the failure mode being guarded against is silent substitution.
tex_env_report() {
    local engine="${1:-xelatex}" resolved siunitx
    resolved="$(command -v "$engine" 2>/dev/null || true)"
    siunitx="$(kpsewhich siunitx.sty 2>/dev/null || true)"

    echo "tex engine  : ${resolved:-NOT FOUND ($engine)}"
    if [[ -n "$siunitx" ]]; then
        echo "siunitx     : $siunitx"
    else
        echo "siunitx     : NOT FOUND -- preamble.tex loads it unconditionally, so this build will fail."
    fi
}

tex_env_activate
