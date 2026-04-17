# Contributing to ZAckML

Thanks for your interest in contributing. ZAckML is open-source under the MIT license, and contributions of all kinds — spec clarifications, parser improvements, new pattern examples, tooling, documentation — are welcome.

## Ground rules

- **Start with an issue** for anything more than a typo fix, so scope and direction can be agreed on before time is spent.
- **Keep the language generic.** New tag semantics belong in a pattern (`.pat`), not in the language grammar.
- **Spec and parser move together.** Any change to semantics in `SPEC.md` needs a corresponding update in `zackml.py`, and vice versa. PRs that drift them apart will be asked to reconcile.
- **Preserve the public API.** The functions `parse`, `parse_file`, `resolve`, `load_pattern`, `dump_tree`, and the `ZAckMLError`/`ZMLError` aliases are public surface. Breaking them is a major version change.

## Sign off on your commits

All commits must carry a `Signed-off-by` line. This is the [Developer Certificate of Origin (DCO)](https://developercertificate.org) — a lightweight per-commit statement that you wrote the change, or have the right to submit it under the project's license. It replaces the heavier CLA pattern for most projects.

To sign off, pass `-s` to `git commit`:

```bash
git commit -s -m "feat: add foo"
```

This appends a line like:

```
Signed-off-by: Your Name <your.email@example.com>
```

to the commit message. Pull requests whose commits lack sign-offs will be asked to rebase with `git rebase --signoff HEAD~N`.

## Commit message conventions

Commit subjects follow a light version of [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` — a new feature.
- `fix:` — a bug fix.
- `spec:` — specification changes.
- `docs:` — documentation only.
- `chore:` — tooling, build, repo plumbing.
- `refactor:` — code change with no behavioral difference.
- `test:` — adding or adjusting tests.

Optional scope in parentheses: `feat(uses): …`, `docs(examples): …`.

Write the subject in imperative mood, under ~72 characters, and follow it with a blank line and a short body explaining the *why*.

## License

By contributing, you agree that your contributions will be licensed under the [MIT License](LICENSE) — the same license as the rest of the project.
