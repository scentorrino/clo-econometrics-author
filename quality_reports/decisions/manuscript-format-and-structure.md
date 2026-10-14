# Decision record — manuscript format and structure

**Date:** 2026-07-31 · **Project:** `panel-npiv-discrete` · **Status:** DECIDED, partially implemented

## Decision

1. **The paper's structure follows Centorrino, Fève & Florens (2025)**, *J. Econometrics* 247, 105950 — the companion paper. Bib key `centorrinofeveflorens2019` (a fossil of the 2019 mimeo; **do not create a 2025 key**).
2. **Proofs go to an online supplement, not a printed appendix.**
3. **Quarto (`.qmd`) is the intended manuscript format.** LaTeX remains the working format until one blocker is cleared.

## CFF's structure, read from the PDF rather than assumed

1 Introduction · 2 Local identification under independence · 3 Estimation · 4 Asymptotic properties · 5 Monte Carlo · 6 Estimation of returns to education · 7 Conclusions · Appendix A · References

Two facts that decide items 2 and the §6 question:

- **Appendix A is two lines — a DOI pointer — and the main text contains exactly ONE proof.** Statements are in the article; proofs are in the online supplement. **Our theory corpus compiles to 312 pages against CFF's 19-page main text**, so the supplement route is what the volume forces, not a preference.
- **CFF §6 is an empirical application. We have none.** With one, this is a methods-plus-application paper; without, a methods paper carried by theory and a Monte Carlo. **That is a positioning decision and is deliberately left open** — `main.qmd` records it as a decision rather than stubbing a section.

## Why Quarto is a shell, not a translation — decided by measurement

The theory corpus carries **136 theorem-like environments and 2,038 `\cref`/`\eqref` calls** across `results.tex`, `proofs.tex`, `assumptions.tex`.

Translating that into markdown would destroy the cross-reference graph **and the tooling built on it**: `check_rendering_sync.py`'s label-based CHECK 1/4/6/8, the 117 symbolic specs' source pointers, and every narrow critic's line citations.

**So the `.qmd` files own the PROSE and `\input` the theory verbatim inside raw LaTeX blocks.** Quarto renders PDF via pandoc → LaTeX, so raw blocks pass through untouched.

**Binding rule: do not use Quarto's native theorem syntax (`::: {#thm-foo}`).** It maintains its own counter and label scheme and would collide with the 136 `amsthm` environments and the `\cref` graph. **One theorem system.**

## Current state

- **Skeleton drafted** at `paper/qmd/`: `_quarto.yml`, `main.qmd`, `supplement.qmd`.
- **CLEARED:** Quarto's xelatex template loads `unicode-math` unconditionally, which fights the project preamble's `lmodern` + T1 + `amssymb` + `dsfont` setup (dies on `\g__um_prime_font_cmd_tl`). **That preamble is pdflatex-native and merely *tolerates* xelatex because the scratch driver never loads unicode-math.** Fixed with `pdf-engine: pdflatex`. *If xelatex is ever needed here, the fix is a custom pandoc template — **not** a preamble change, since the preamble is shared with the working LaTeX build.*
- **CLEARED 2026-07-31 — `titlesec`.** Was fatal at `main.log:1899`, *"No format for this command"*, at `\paragraph{Discussion.}` (`main.tex:2557`, prose that arrives via the raw-`\input` theory corpus and so cannot be dodged from the qmd side).

  **Diagnosis — an ordering problem, not a missing declaration.** Pandoc's default template emits a *"Make `\paragraph` and `\subparagraph` free-standing"* block (`main.tex:42–65`) that does `\let\oldparagraph\paragraph` and then `\renewcommand`s `\paragraph` into a wrapper. Quarto's `include-in-header` splices the project preamble in **after** that block, so `titlesec` loaded against a `\paragraph` that was no longer `\@startsection`-shaped and recorded no format for it. The earlier reading — "the preamble issues no `\titleformat`" — was the visible symptom, not the cause: the LaTeX path issues none either and has never failed.

  **Fix applied — restoration, not redeclaration.** Two guarded lines in `paper/preambles/preamble.tex` immediately before `\usepackage{titlesec}` restore `\paragraph`/`\subparagraph` from pandoc's saved originals when they exist. Both are no-ops on the LaTeX path, where `\oldparagraph` is undefined. This was chosen over the `\titleformat` route recorded above because that route would have had `titlesec` take ownership of pandoc's wrapper *and* imposed a `\paragraph` style on the shared LaTeX build, which is not the preamble's business.

  **Verified both ways, on a minimal probe reproducing pandoc's ordering verbatim:** with the fix, exit 0 and a PDF; with the two lines stripped, exit 1 and **two** errors — the bug was hitting `\subparagraph` as well, which the original one-line diagnosis missed. Regression check on the working path: `build.sh` still exits 0 at 312 pages, no undefined refs, no unresolved cites.

- **OPEN — new blocker found behind the old one: engine resolution.** This machine has **two TeX distributions**, and the theory build succeeds by accident of which binary each tool resolves:
  - MacPorts TeX Live 2026 at `/opt/local/bin` — **has no `siunitx`**, which `preamble.tex:91` loads unconditionally.
  - TinyTeX at `~/Library/TinyTeX`, symlinked into `/usr/local/bin` — **has `siunitx`**.

  `/opt/local/bin` precedes `/usr/local/bin` on `PATH`, so bare `pdflatex`/`xelatex` resolve to MacPorts. `build.sh` survives only because it calls `latexmk`, which exists **only** in TinyTeX's tree and pulls TinyTeX's engines with it — the 312-page build's log loads `~/Library/TinyTeX/.../siunitx.sty`. `_quarto.yml` sets `pdf-engine: pdflatex`, which resolves to MacPorts and dies on `siunitx.sty not found`.

  **RESOLVED 2026-07-31 — TinyTeX, by author's decision.** Implemented as discovery rather than a hardcoded path, so the committed repository carries no machine specifics (`meta-governance.md`): `scripts/lib/tex-env.sh` locates TinyTeX (honouring `TINYTEX_ROOT`, else the standard macOS/Linux/Windows locations), globs the `bin/<arch>` directory rather than naming `universal-darwin`, prepends it to `PATH`, and **prints the resolved engine and whether `siunitx` loads** — because the failure mode being guarded against is silent substitution. Absent TinyTeX it warns and changes nothing, so a fork with a complete TeX Live is unaffected. Both build paths now source it; `build.sh` no longer reaches TinyTeX by accident.

  **Quarto now renders.** `scripts/render-paper/render.sh supplement` → exit 0, 146 pages, engine `~/Library/TinyTeX/.../pdflatex`, `siunitx` found.

## Quarto renders — and three findings the exit code hid

The first green render was not clean, which is the same lesson `build.sh` was written for. `render.sh` now reports all three; none of them moves the exit code.

1. **`ERROR - Cannot find 'Bibliography_base.bib'`.** `preamble.tex:160` names a file that is absent from the render directory. **Currently harmless, and that is the danger** — the pandoc-emitted `\addbibresource` for the project bibliography supplies all 7 citekeys, so `unresolved cites` reads `none` and the broken resource is masked. Two `\addbibresource` and two `\printbibliography` now reach the document by different routes (`supplement.tex:252` and `:500`; `:528` and `:531`), and the pandoc-emitted path arrives **with the underscore LaTeX-escaped** as `quality\_reports`. A landmine, not a wound. Fixing it means deciding whether the Quarto path keeps the `bibliography:` key in `_quarto.yml` or defers entirely to the preamble.
2. **`maximum number of runs (9) reached`.** Cross-references never converged, so page numbers and `\cref` targets in the PDF are not trustworthy.
3. **310 undefined references** in the standalone supplement. Structural, not a regression: `supplement.qmd` `\input`s `proofs.tex`, whose `\cref` targets are defined in `results.tex` — that is, in `main.qmd`. This is the known statement/proof split, now quantified. It also bears on the separate reading-order defect (§2 inputs `assumptions.tex` while §4 inputs *all* of `results.tex`).

**`latex-clean: false`** was added to `_quarto.yml` because Quarto deletes the LaTeX `.log` by default, and that log is the only record of undefined references, multiply-defined labels and unresolved citations — all warnings, all invisible at exit 0. Without it `render.sh` is blind, and it says so rather than reporting a false pass.

## Working format until then

**LaTeX.** `scripts/build-theory/build.sh` builds the theory corpus cleanly — exit 0, 312 pages, zero undefined references, zero unresolved citations. **There is still no `paper/main.tex`**; that script drives a generated wrapper. When a `main.tex` is written, `paper/preambles/preamble.tex:115–121` carries the required `\addbibresource` pattern, and **the failure mode is silent — it exits 0 and renders `[?]`.**

## Alternatives considered

- **Translate the theory into markdown.** Rejected on the measurement above — it discards 2,038 cross-references and the entire checking layer.
- **Printed appendix rather than supplement.** Rejected: 312 pages, and CFF itself does not do it.
- **Keep xelatex under Quarto.** Rejected for now: needs a custom pandoc template, which is more work than the styling blocker it would solve.
