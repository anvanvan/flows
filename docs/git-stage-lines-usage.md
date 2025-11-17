# Git Stage-Lines Usage Guide

## Overview

`git stage-lines` and `git unstage-lines` are git aliases that enable precise, line-level control over staging changes. They automatically detect file state (tracked/untracked, staged/unstaged) and apply the appropriate operation.

### What They Do

**stage-lines:**
- For tracked files: Stage only specific line ranges from your changes
- For untracked files: Stage the entire file (like `git add`)

**unstage-lines:**
- For partially staged files: Unstage only specific line ranges
- For newly-added files: Remove from index entirely (make untracked again)

### Key Feature: Complete Symmetry

These commands are symmetric - what you stage with `stage-lines`, you can unstage with `unstage-lines`:

```
untracked.js  →  [stage-lines]  →  staged (A)  →  [unstage-lines]  →  untracked.js
modified.js   →  [stage-lines 1-10]  →  partial  →  [unstage-lines 1-10]  →  modified.js
```

## Usage

### Stage-Lines Syntax

```bash
# Tracked file with line ranges
git stage-lines <lines> <file>

# Untracked file (entire file)
git stage-lines <file>
```

### Unstage-Lines Syntax

```bash
# Partially staged file with line ranges
git unstage-lines <lines> <file>

# Newly-added file (remove from index)
git unstage-lines <file>
```

### Line Range Format

Line ranges use filterdiff syntax:
- Single line: `15`
- Range: `10-20`
- Multiple ranges: `1-5,8,10-12`
- Open-ended: `50-` (from line 50 to end)

## Examples

### Staging Scenarios

**Stage specific lines from a modified file:**
```bash
git stage-lines 10-20 src/auth.js
# Stages only lines 10-20 from your changes
```

**Stage multiple ranges:**
```bash
git stage-lines 1-5,15,20-25 src/config.js
# Stages lines 1-5, line 15, and lines 20-25
```

**Stage an untracked file:**
```bash
git stage-lines new-feature.js
# Adds the entire untracked file to staging
# (equivalent to: git add new-feature.js)
```

### Unstaging Scenarios

**Unstage specific lines from a partially staged file:**
```bash
git unstage-lines 10-20 src/auth.js
# Removes staging for lines 10-20, keeps other staged lines
```

**Unstage a newly-added file:**
```bash
git unstage-lines new-feature.js
# Removes file from index, makes it untracked again
# (equivalent to: git rm --cached new-feature.js)
```

## Common Workflows

### Workflow 1: Selective Staging from Multiple Changes

You modified `database.js` with both a bug fix (lines 10-15) and a new feature (lines 50-80). Stage them separately:

```bash
# Stage just the bug fix
git stage-lines 10-15 database.js
git commit -m "fix: handle null pointer in query"

# Stage the feature
git stage-lines 50-80 database.js
git commit -m "feat: add connection pooling"
```

### Workflow 2: Review and Refine Staging

Stage too much? Unstage specific lines:

```bash
# Stage lines 1-50
git stage-lines 1-50 app.js

# Review with git diff --cached
# Oops, lines 20-25 shouldn't be included

# Unstage just those lines
git unstage-lines 20-25 app.js

# Commit what remains
git commit -m "update app logic"
```

### Workflow 3: New File Staging and Refinement

```bash
# Stage a new file
git stage-lines feature.js

# Review with git diff --cached
# Realize you want to split this into multiple commits

# Unstage it completely
git unstage-lines feature.js

# The file is untracked again, ready for selective staging
# (after splitting into multiple files or commits)
```

### Workflow 4: Partial Staging Across Multiple Files

```bash
# Stage specific changes from different files
git stage-lines 1-20 auth.js
git stage-lines 5-10 config.js
git stage-lines utils.js  # entire untracked file

# Review all staged changes
git diff --cached

# Adjust if needed
git unstage-lines 15-20 auth.js

# Commit the batch
git commit -m "feat: implement authentication system"
```

## Error Messages and Troubleshooting

### "Error: Please specify line ranges"

**When staging:**
```
Error: Please specify line ranges (e.g., 1-5,8,10-12)
Usage: git stage-lines <lines> <file>
       git stage-lines <untracked-file>
```

**Cause:** You tried to stage a tracked file without specifying line ranges.

**Solution:**
```bash
# Add line ranges for tracked files
git stage-lines 1-10 file.js

# Or if you want the entire file
git add file.js
```

**When unstaging:**
```
Error: Please specify line ranges (e.g., 1-5,8,10-12)
Usage: git unstage-lines <lines> <file>
       git unstage-lines <newly-added-file>
```

**Cause:** You tried to unstage from a partially staged file without specifying line ranges.

**Solution:**
```bash
# Add line ranges for partial unstaging
git unstage-lines 1-10 file.js

# Or if you want to unstage everything
git restore --staged file.js
```

### File Doesn't Exist

If the file doesn't exist, git's native error messages appear:
```
fatal: pathspec 'missing.js' did not match any files
```

### File Ignored by .gitignore

`git stage-lines` respects `.gitignore`. Ignored files won't stage unless forced:
```bash
# This won't stage an ignored file
git stage-lines ignored.log

# Force staging if really needed
git add -f ignored.log
```

### No Changes to Stage

If a tracked file has no modifications:
```
# Nothing happens - no diff to filter
git stage-lines 1-10 unchanged.js
```

Check with:
```bash
git status
git diff file.js
```

## Understanding File States

The commands automatically detect and handle different file states:

| File State | Command | Behavior |
|------------|---------|----------|
| Untracked | `stage-lines file.js` | Stages entire file |
| Modified (tracked) | `stage-lines 1-10 file.js` | Stages lines 1-10 only |
| Modified (tracked) | `stage-lines file.js` | Error: needs line ranges |
| Newly-added (staged) | `unstage-lines file.js` | Removes from index (→ untracked) |
| Partially staged | `unstage-lines 1-10 file.js` | Unstages lines 1-10 only |
| Partially staged | `unstage-lines file.js` | Error: needs line ranges |

## Tips

1. **Preview before committing:** Always check staged changes with `git diff --cached`

2. **Line numbers refer to your changes:** The line ranges apply to the diff output, not absolute file line numbers

3. **Combine with other git commands:** These aliases work alongside normal git commands:
   ```bash
   git stage-lines 1-20 file.js
   git add other-file.js
   git commit -m "mixed staging works fine"
   ```

4. **Use `git status` frequently:** Check file states before and after staging operations

5. **Unstage is truly symmetric:** Whatever you stage with specific lines, you can unstage with the same line specification

## Requirements

These aliases require `filterdiff` (from the `patchutils` package):

```bash
# macOS
brew install patchutils

# Ubuntu/Debian
apt-get install patchutils

# Fedora/RHEL
dnf install patchutils
```
