# ZAckML

**Zack's Actionable "compression key-like" Markup Language.**

*Created by [VonBluebaugh](https://github.com/VonBluebaugh) - 
[ZBlue@bluebrotech.net](https://github.com/BlueBroTech)(BlueBroTech, LLC).*

ZAckML is a generic, extensible markup language in the XML family — no predefined tag names — paired with an optional in-band pattern reference system that attaches HTML-like semantics to tags on demand.

```zackml
<?zackml version="1.0" ?>
<?pattern src="html-basic.pat" ?>

<document>
  <heading level="1">Hello, ZAckML</heading>
  <paragraph>A <emphasis>short</emphasis> demonstration.</paragraph>
</document>
```

A parser that doesn't know about `html-basic.pat` still builds a valid tree. A pattern-aware consumer (renderer, validator, transformer) resolves `<heading>` → `h1`, `<paragraph>` → `p`, `<emphasis>` → `em`, and fills in attribute defaults — no hard-coded tag table required.

## Semantic compression

The idea driving ZAckML is **semantic compression**: compacting a lexicon while retaining meaning, typically by replacing specific terms with more general counterparts that can be expanded back when needed. A tag name in ZAckML is a compressed keyword — short to write, visually light — and a pattern is the decompressor, mapping each tag to its full semantic definition. The same compressed keyword `<heading>` can decompress to an HTML-style element in one document, a Word-style block in another, and an EPUB chapter title in a third — without changing the language grammar or the parser.

## What's in this repo

| Path                                 | What it is                                                    |
|--------------------------------------|---------------------------------------------------------------|
| [`SPEC.md`](SPEC.md)                 | The ZAckML v1.0 specification (grammar, semantics, patterns). |
| [`zackml.py`](zackml.py)             | Single-file reference parser + pattern resolver + CLI.        |
| [`examples/`](examples)              | The canonical `html-basic` pattern and a sample document.     |
| [`uses/`](uses)                      | Four applied use cases: Office, Spreadsheet, EPUB, SVG.       |
| [`CONTRIBUTING.md`](CONTRIBUTING.md) | How to contribute (DCO sign-off, scope guidance).             |
| [`CHANGELOG.md`](CHANGELOG.md)       | Release notes.                                                |

## Quick start

```bash
# Parse a document and print its resolved tree
python zackml.py examples/sample.zackml

# Render a ZAckML drawing to real SVG (demonstrates `maps-to` doing real work)
python uses/svg/render.py uses/svg/logo.zackml > /tmp/logo.svg
```

## Design principles

- **No reserved tag names.** Any valid name is a valid tag.
- **Attribute values are always quoted** (single or double).
- **Whitespace in text content is significant by default.** Opt in to collapsing via `ws="collapse"`.
- **Patterns are optional.** A document with no pattern is valid ZAckML; non-pattern-aware tools still see a full tree.
- **Silent fallback for undefined tags.** An unprefixed tag that no pattern defines is simply a generic element.
- **Errors are reserved for the uncomputable.** Missing required values with no default, unresolvable prefixes, prefix collisions.
- **Prefix bindings are reassuring, not required.** `<?pattern src="html-basic.pat" as="h" ?>` lets you write `<h:heading>` and know exactly which pattern defines it.

For the full resolution algorithm and error cases, see [SPEC.md § 9](SPEC.md).

## Use cases

The [`uses/`](uses) directory shows ZAckML as the underlying markup for real file-format shapes:

- **Office documents** (`.docx`-style) — sections, headings, paragraphs, inline runs, lists, tables.
- **Spreadsheets** (`.xlsx`-style) — workbooks, sheets, typed cells, formulas, named ranges.
- **EPUB eBooks** — split into chapter content and package/manifest metadata.
- **SVG graphics** — a pattern mapping one-to-one onto real SVG, plus a 60-line renderer that actually emits `.svg` from a `.zackml` source.

Each container is the same story: ZIP of ZAckML files + one or more `.pat` patterns per role.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). Short version: open an issue before non-trivial changes, sign off your commits with `git commit -s`, and keep new tag semantics in patterns rather than in the language itself.

## License

[MIT](LICENSE). Copyright © 2026 VonBluebaugh (BlueBroTech, LLC).
