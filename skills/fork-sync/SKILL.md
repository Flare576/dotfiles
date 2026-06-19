---
name: fork-sync
description: "Keep a fork and its feature branch in sync with the upstream repository. Use when the upstream ships a release, the PR shows 'dirty' merge state, or you need to run a local fork while a PR is pending. Triggers: 'update the fork', 'sync with upstream', 'merge upstream', 'PR is dirty', 'rebase onto main', 'fork is behind', 'fork-sync'."
---

# Fork Sync

Keeps a fork (`fork` remote) and its active feature branch in sync with the upstream (`origin` remote) after upstream ships a new release.

Typical triggers:
- PR shows **Merge state: DIRTY** on GitHub
- Upstream bumps its version / ships a release
- Running a local fork while a PR is pending and you want the latest bugfixes

---

## The Two Separate Operations

These are independent. Both are usually needed together.

### Operation A — Update fork/main

Bring the fork's `main` branch up-to-date with upstream. Fast-forward only — never merge or rebase main:

```bash
git fetch origin main
git push fork origin/main:main
```

No local checkout needed. If this is rejected (non-fast-forward), the fork's main has diverged — that is a problem to investigate before pushing.

### Operation B — Merge upstream into the feature branch

```bash
git fetch origin main
git checkout feat/<name>
git merge origin/main --no-edit
# Resolve any conflicts (see below)
git push fork feat/<name>
```

`--no-edit` accepts the default merge commit message. Use `--no-ff` if you want to force a merge commit even when a fast-forward is possible.

---

## Common Conflicts

### CHANGELOG.md

The most frequent conflict. Both branches add entries under `## [Unreleased]`.

**Resolution**: keep both sets of entries under the same `## [Unreleased]` section:
- Our PR entries at the top
- Upstream entries below ours
- Everything else unchanged

Git usually auto-merges this correctly. If it doesn't, manually:
```
## [Unreleased]

### Breaking Changes
... (ours) ...

### Added
... (ours) ...
... (theirs) ...

### Fixed
... (both) ...
```

### Core source files (e.g. `agent-session.ts`)

These happen when both the PR and upstream added new fields to the same interface or constructor. Resolution is almost always **keep both** — they are independent additions.

Use the conflict tool:
```
write({ path: "conflict://1", content: "@ours\n@theirs\n" })
```

Or manually: paste ours first, then theirs, remove conflict markers.

After resolving, run `bun check` on the file to confirm types are clean.

---

## Full Sequence (both operations)

```bash
# 1. Fetch everything
git fetch origin main
git fetch fork

# 2. Update fork/main (fast-forward)
git push fork origin/main:main

# 3. Merge upstream into feature branch
git checkout feat/<name>
git merge origin/main --no-edit

# 4. Resolve conflicts if any (see above)

# 5. Run diagnostics on conflicted files
bun check  # or lsp diagnostics on affected files

# 6. Commit the merge (if conflicts required manual resolution)
git add <resolved-files>
git commit --no-edit   # or git merge --continue

# 7. Push
git push fork feat/<name>
```

---

## Checking State Before Starting

```bash
# How far behind is the feature branch?
git log --oneline feat/<name>..origin/main | wc -l   # commits behind
git log --oneline origin/main..feat/<name> | wc -l   # commits ahead (PR)

# Is fork/main current?
git log --oneline fork/main..origin/main | head -5   # empty = up-to-date
```

---

## Notes

- **Never rebase** the feature branch onto main after commits have been pushed to the fork — existing review comments on GitHub are anchored to commit SHAs and a rebase invalidates them. Merge commits are fine.
- `git merge --no-edit` uses the auto-generated merge commit message. That's correct for routine upstream syncs.
- If the merge result shows `CONFLICT (content)` on a file other than CHANGELOG.md, read both sides carefully before resolving — upstream may have restructured the same area our PR touched.
- After pushing, the PR's **Merge state** on GitHub will update to `CLEAN` within a few seconds.
