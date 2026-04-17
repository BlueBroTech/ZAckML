# Uploading ZAckML v1.0.0 to GitHub

You have three options, roughly in increasing order of "cleanliness of authorship on GitHub." All three produce the same repository contents; they differ only in who shows up as the commit author.

---

## Option A — Clone the bundle, then push (fastest)

A git bundle is a single-file archive of a repository's objects and refs. You can clone directly from it.

```bash
# 1. Clone from the bundle
git clone zackml.bundle zackml
cd zackml

# 2. Create an empty repo on GitHub (via the web UI or `gh repo create`)
#    Do NOT initialize with a README — this repo already has one.

# 3. Point the clone at your new remote and push, including the v1.0.0 tag
git remote add origin git@github.com:YOUR_USERNAME/zackml.git
git push -u origin main
git push origin v1.0.0
```

Commit author on GitHub will be the placeholder `Zack <zack@zackml.dev>`. See Option C if you want your own identity on the commits.

---

## Option B — Extract the tarball, then push

Same end result as A, but for people who prefer a normal directory tree over a git bundle.

```bash
tar xzf zackml-v1.0.0.tar.gz
cd zackml
git remote add origin git@github.com:YOUR_USERNAME/zackml.git
git push -u origin main
git push origin v1.0.0
```

---

## Option C — Re-run the build script under your own identity (recommended)

The history is reproducible. Running `build-repo.sh` on your machine rebuilds the same sequence of commits, but with *your* git identity (whatever `git config user.name` / `user.email` returns) stamped on every commit. This is what you almost certainly want if the repo is going under your personal GitHub account.

You will need the staged source tree that the script expects. The simplest way to get it is to extract the tarball and use the extracted directory as your source:

```bash
# 1. Extract the staged sources (the tarball already contains them, just
#    without the .git directory laid out as "SRC").
tar xzf zackml-v1.0.0.tar.gz     # → ./zackml/
rm -rf zackml/.git                # discard the placeholder history

# 2. Run the script, pointing SRC at the extracted tree and choosing a
#    fresh build destination.
SRC="$PWD/zackml" bash build-repo.sh /tmp/zackml-fresh

# 3. Push as usual.
cd /tmp/zackml-fresh
git remote add origin git@github.com:YOUR_USERNAME/zackml.git
git push -u origin main
git push origin v1.0.0
```

You can tweak `build-repo.sh` before running it — change the commit messages, split or merge commits, adjust the version tag, and so on. Every commit is a contiguous block of `cp` / `mkdir` calls followed by a `commit "..." "..."` call, so edits are mechanical.

---

## Creating the GitHub release

Once pushed, turn the `v1.0.0` tag into a GitHub Release:

- In the GitHub UI: **Releases → Draft a new release → choose tag `v1.0.0`**.
- Title: `ZAckML v1.0.0`.
- For the description, paste the `## [1.0.0]` section from `CHANGELOG.md`.
- Optionally attach `zackml-v1.0.0.tar.gz` as a release asset.

Or via the GitHub CLI:

```bash
gh release create v1.0.0 zackml-v1.0.0.tar.gz \
  --title "ZAckML v1.0.0" \
  --notes-file CHANGELOG.md
```
