#!/usr/bin/env bash
#
# build-repo.sh — construct the zackml Git repository from staged sources.
#
# Takes the tree at SRC (the fully-staged source files) and replays the
# development story into a fresh repo at DEST as a series of logical commits.
#
# Usage:
#   bash build-repo.sh            # builds to /home/claude/zackml-repo
#   bash build-repo.sh /some/path # builds there instead

set -euo pipefail

SRC="${SRC:-/home/claude/zackml-src}"
DEST="${1:-/home/claude/zackml-repo}"

rm -rf "$DEST"
mkdir -p "$DEST"
cd "$DEST"

git init -q -b main
git config user.name  "Zack"
git config user.email "zack@zackml.dev"

commit() {
    local subject="$1"; shift
    local body="$1"; shift
    git add -A
    # Use -m twice so the body is a distinct paragraph in the commit message.
    git -c commit.gpgsign=false commit -q -m "$subject" -m "$body"
}

# ---------------------------------------------------------------------------
# 1. Repository skeleton: license, gitignore, stub README.
# ---------------------------------------------------------------------------
cp "$SRC/LICENSE"    .
cp "$SRC/.gitignore" .
cat > README.md <<'EOF'
# ZAckML

Zack's Actionable "compression key-like" Markup Language.

Specification, reference parser, and example patterns. See SPEC.md (once added) for the full grammar and semantics.
EOF

commit "chore: initialize repository with MIT license" \
"Sets up the repository skeleton: an MIT license, a Python-oriented
.gitignore, and a placeholder README. No language content yet — the
spec and reference implementation land in the following commits."

# ---------------------------------------------------------------------------
# 2. Contribution guide with DCO sign-off.
# ---------------------------------------------------------------------------
cp "$SRC/CONTRIBUTING.md" .

commit "docs: add contribution guide with DCO sign-off" \
"Adds CONTRIBUTING.md covering scope expectations (new tag semantics
go in patterns, not the language grammar), commit-message conventions
modelled on Conventional Commits, and a Developer Certificate of Origin
sign-off requirement for all commits.

The DCO is a lightweight per-commit statement that the contributor has
the right to submit their change under the project's license. Preserving
this cleanly from the start keeps the relicensing path open for the
future without needing to track down every contributor for permission."

# ---------------------------------------------------------------------------
# 3. Language specification.
# ---------------------------------------------------------------------------
cp "$SRC/SPEC.md" .

commit "spec: add ZAckML v1.0 language specification" \
"Adds SPEC.md defining the ZAckML grammar and semantics.

Covers lexical structure, element syntax, mandatory-quoted attributes,
significant-by-default whitespace with a per-element opt-in to collapsing,
entity and CDATA handling, processing instructions (<?zackml?> and
<?pattern?>), and the full pattern-resolution algorithm: prefix binding,
last-declared-unprefixed-pattern-wins, silent fallback for unknown tags,
and the closed list of conditions that raise errors.

Appendix A gives the complete EBNF grammar."

# ---------------------------------------------------------------------------
# 4. Reference parser.
# ---------------------------------------------------------------------------
cp "$SRC/zackml.py" .

commit "feat: add single-file reference parser and resolver" \
"zackml.py is a hand-written recursive-descent parser with line/column
tracking, entity decoding, CDATA support, and prefixed QNames. It also
contains the pattern loader (pattern files are themselves ZAckML
documents) and the resolver that implements the spec's semantics:
prefix-bound resolution, last-declared-unprefixed-pattern-wins, silent
fallback, and attribute default / validation handling.

Exposes a small library API (parse, parse_file, resolve, load_pattern,
dump_tree) and a CLI entry point for ad-hoc inspection."

# ---------------------------------------------------------------------------
# 5. Canonical html-basic pattern + demo document.
# ---------------------------------------------------------------------------
mkdir -p examples
cp "$SRC/examples/html-basic.pat" examples/
cp "$SRC/examples/sample.zackml"  examples/

commit "docs(examples): add html-basic pattern and demo document" \
"Adds the canonical html-basic pattern (headings, paragraphs, emphasis,
links, a void break tag) and a sample document that exercises attribute
defaults, whitespace defaults, entity decoding, and silent fallback on
tags the pattern does not define.

Running the parser against examples/sample.zackml is the smoke test for
every change to the resolver."

# ---------------------------------------------------------------------------
# 6. Office document use case.
# ---------------------------------------------------------------------------
mkdir -p uses/office
cp "$SRC/uses/office/office-doc.pat"  uses/office/
cp "$SRC/uses/office/letter.zackml"   uses/office/

commit "docs(uses): add word-processing pattern and sample letter" \
"First of the applied use cases. office-doc.pat models the core of
WordprocessingML (the XML dialect inside .docx): sections with page
geometry, headings, paragraphs with alignment, inline runs for
character formatting, lists, tables, images, and page breaks.

letter.zackml is a short business letter that exercises the pattern
end-to-end, including a 4-row comparison table."

# ---------------------------------------------------------------------------
# 7. Spreadsheet use case.
# ---------------------------------------------------------------------------
cp "$SRC/uses/office/spreadsheet.pat" uses/office/
cp "$SRC/uses/office/budget.zackml"   uses/office/

commit "docs(uses): add spreadsheet pattern and sample workbook" \
"spreadsheet.pat covers the shape of SpreadsheetML: workbook, sheets,
typed cells (string, number, currency, percent, date, boolean,
formula), optional per-cell formulas and format strings, column
widths, and named ranges.

budget.zackml is a two-sheet workbook with a SUM formula driving a
total row and percent-typed cells computing shares."

# ---------------------------------------------------------------------------
# 8. EPUB use case.
# ---------------------------------------------------------------------------
mkdir -p uses/epub
cp "$SRC/uses/epub/epub-content.pat" uses/epub/
cp "$SRC/uses/epub/epub-package.pat" uses/epub/
cp "$SRC/uses/epub/chapter-1.zackml" uses/epub/
cp "$SRC/uses/epub/package.zackml"   uses/epub/

commit "docs(uses): add EPUB content and package patterns" \
"An EPUB is a ZIP of two kinds of markup: per-chapter content and a
package/manifest file. Adds separate patterns for each role.

epub-content.pat covers chapters, titles, sections, paragraphs,
emphasis, blockquotes, and footnotes. epub-package.pat covers
package-level metadata (title, authors with roles, identifiers,
publisher, date), the manifest of files, and the spine that defines
reading order.

chapter-1.zackml and package.zackml are matched samples showing the
two files side by side."

# ---------------------------------------------------------------------------
# 9. SVG pattern + renderer — proof that patterns are actionable.
# ---------------------------------------------------------------------------
mkdir -p uses/svg
cp "$SRC/uses/svg/svg.pat"       uses/svg/
cp "$SRC/uses/svg/logo.zackml"   uses/svg/
cp "$SRC/uses/svg/render.py"     uses/svg/
cp "$SRC/uses/svg/logo.svg"      uses/svg/

commit "feat(uses): add SVG pattern and renderer demonstration" \
"The SVG pattern maps one-to-one onto real SVG tags via the pattern's
maps-to field. logo.zackml is a small wordmark drawn with the pattern.

render.py is the payoff: a ~60-line consumer that parses the document,
resolves it against the pattern, and walks the resolved tree emitting
real SVG. No hard-coded tag table; every element's output name comes
from its resolved pattern definition, attribute defaults are filled in
from the pattern, and void-mode elements render as self-closing.

The checked-in logo.svg is the output of running render.py on
logo.zackml. Opens in any browser."

# ---------------------------------------------------------------------------
# 10. Use-case README that ties it all together.
# ---------------------------------------------------------------------------
cp "$SRC/uses/README.md" uses/

commit "docs(uses): add README tying the four use cases together" \
"A map of the uses/ directory. Explains, per use case, which real-world
format the pattern is modelled on (.docx, .xlsx, EPUB, SVG) and what
each file demonstrates.

Frames the broader point: patterns are additive. Every format here is
another .pat file plus conventions; the language itself stays generic."

# ---------------------------------------------------------------------------
# 11. Final top-level README + CHANGELOG for v1.0.0 release.
# ---------------------------------------------------------------------------
cp "$SRC/README.md"    .
cp "$SRC/CHANGELOG.md" .

commit "docs: finalize top-level README and add CHANGELOG for v1.0.0" \
"Replaces the placeholder README with the real one: quick example,
directory map, quick-start commands for parser and SVG renderer, a
summary of the design principles, and a tour of the applied use cases.

Adds CHANGELOG.md covering everything in v1.0.0 under Keep a Changelog
conventions."

# ---------------------------------------------------------------------------
# Annotated release tag.
# ---------------------------------------------------------------------------
git tag -a v1.0.0 -m "ZAckML v1.0.0

First public release. Specification, reference parser, canonical
html-basic pattern, and four applied use cases (word-processing
document, spreadsheet, EPUB content and package, SVG) — all mutually
consistent and exercised end-to-end."

echo
echo "=== Repository built at $DEST ==="
git --no-pager log --oneline --decorate
echo
echo "=== File count and total size ==="
find . -type f ! -path "./.git/*" | wc -l
du -sh . --exclude=.git
