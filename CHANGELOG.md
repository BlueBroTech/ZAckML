# Changelog

All notable changes to ZAckML are documented here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] — 2026-04-17

The initial public release. The language, the reference parser, and a set of worked use cases are all stable and mutually consistent.

Authored by [Zack VonBluebaugh](https://github.com/VonBluebaugh) (BlueBroTech, LLC).

### Added

- **Specification v1.0** (`SPEC.md`). Lexical structure, element grammar, mandatory-quoted attributes, significant-by-default whitespace with per-element opt-in collapsing, entity and CDATA rules, processing instructions (`<?zackml?>`, `<?pattern?>`), and the full pattern-resolution algorithm including prefix binding, last-declared-unprefixed-wins, silent fallback, and the closed list of conditions that raise errors. EBNF grammar in Appendix A.
- **Reference parser** (`zackml.py`). Single-file, hand-written recursive-descent parser with line/column tracking, entity decoding, CDATA support, prefixed `QName`s, a pattern loader (`.pat` files are themselves ZAckML), and a resolver that implements the spec's semantics verbatim. Exposes a library API and a small CLI.
- **Canonical pattern** (`examples/html-basic.pat`) mapping a minimal HTML-like tag set to rendering and attribute semantics, plus a demo document (`examples/sample.zackml`).
- **Applied use cases** (`uses/`) showing ZAckML as the underlying markup for four real file-format shapes:
    - `uses/office/` — a Word-style `office-doc.pat` + sample letter, and a `spreadsheet.pat` + sample budget workbook.
    - `uses/epub/` — `epub-content.pat` for chapter text and `epub-package.pat` for OPF-style metadata/manifest/spine, plus matching sample documents.
    - `uses/svg/` — an SVG pattern with one-to-one `maps-to` bindings, a sample artwork, and a 60-line renderer (`render.py`) that actually emits real SVG from ZAckML, demonstrating that pattern metadata is actionable.

### Naming

The language name expands to **Zack's Actionable "compression key-like" Markup Language**: **Z** is the author's initial in possessive form, **Ack** stands for *Actionable "compression key-like"* (a tag name is a short, actionable acknowledgement that stands in for a larger semantic definition), and **ML** is *Markup Language*.

[1.0.0]: https://github.com/zack/zackml/releases/tag/v1.0.0
