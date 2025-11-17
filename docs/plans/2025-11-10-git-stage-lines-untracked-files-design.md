# Git Stage-Lines: Untracked Files Support

## Problem

The current `git stage-lines` alias fails when used on untracked files:
- Returns `Error: Exit code 128`
- Requires running `git add` separately afterwards
- Breaks the workflow

Current implementation:
```bash
alias.stage-lines !f() { git diff "$2" | filterdiff --lines="$1" | git apply --cached --unidiff-zero; }; f
```

The issue: `git diff` returns nothing for untracked files, causing the pipeline to fail.

## Solution

Extend `git stage-lines` and `git unstage-lines` to automatically detect and handle untracked/newly-added files.

### Behavior

**stage-lines:**
- Tracked file (modified): `git stage-lines 10-20 file.js` → stages only lines 10-20
- Untracked file: `git stage-lines file.js` → stages entire file (line params ignored)

**unstage-lines (symmetric):**
- Partially staged file: `git unstage-lines 10-20 file.js` → unstages only lines 10-20
- Newly added file: `git unstage-lines file.js` → removes from index, makes untracked again

### Complete Symmetry

```
untracked.js  →  [stage-lines]  →  staged (A)  →  [unstage-lines]  →  untracked.js
modified.js   →  [stage-lines 1-10]  →  partial  →  [unstage-lines 1-10]  →  modified.js
```

## Implementation

### Detection Logic

**Untracked file detection:**
```bash
git ls-files --error-unmatch "$file" 2>/dev/null
```
- Exit code 0 = tracked
- Exit code 1 = untracked

**Newly-added file detection:**
```bash
git diff --cached --diff-filter=A --name-only | grep -qx "$file"
```
- Returns filename if newly added (staged but not in HEAD)
- Empty if has line-level staged changes

### Updated stage-lines Alias

```bash
git config --global alias.stage-lines '!f() {
  # Handle parameter patterns
  if [ -z "$2" ]; then
    file="$1"
    lines=""
  else
    lines="$1"
    file="$2"
  fi

  # Check if file is tracked
  if git ls-files --error-unmatch "$file" 2>/dev/null; then
    # Tracked file: require line ranges
    if [ -z "$lines" ]; then
      echo "Error: Please specify line ranges (e.g., 1-5,8,10-12)" >&2
      echo "Usage: git stage-lines <lines> <file>" >&2
      echo "       git stage-lines <untracked-file>" >&2
      return 1
    fi
    # Use filterdiff for line-level staging
    git diff "$file" | filterdiff --lines="$lines" | git apply --cached --unidiff-zero
  else
    # Untracked file: stage entire file
    git add "$file"
  fi
}; f'
```

### Updated unstage-lines Alias

```bash
git config --global alias.unstage-lines '!f() {
  # Handle parameter patterns
  if [ -z "$2" ]; then
    file="$1"
    lines=""
  else
    lines="$1"
    file="$2"
  fi

  # Check if file is newly added
  if git diff --cached --diff-filter=A --name-only | grep -qx "$file"; then
    # Newly added file: remove from index, make untracked
    git rm --cached "$file"
  else
    # Partial staged changes: require line ranges
    if [ -z "$lines" ]; then
      echo "Error: Please specify line ranges (e.g., 1-5,8,10-12)" >&2
      echo "Usage: git unstage-lines <lines> <file>" >&2
      echo "       git unstage-lines <newly-added-file>" >&2
      return 1
    fi
    # Use filterdiff reverse for line-level unstaging
    git diff --cached "$file" | filterdiff --lines="$lines" | git apply --cached --unidiff-zero --reverse
  fi
}; f'
```

## Edge Cases

### Parameter Handling
- `git stage-lines file.js` → assumes untracked file (shorthand)
- `git stage-lines 10-20 file.js` → assumes tracked file with line ranges
- Empty line parameter for tracked file → shows helpful error

### File States
- File doesn't exist → git commands fail naturally with their error messages
- File is ignored by .gitignore → `git add` respects gitignore (won't stage unless forced)
- Mixed scenarios work seamlessly without user needing to know file state

## Benefits

1. **Single command** for staging regardless of file state
2. **No more errors** on untracked files
3. **Symmetric operations** between stage and unstage
4. **Backwards compatible** with existing usage patterns
5. **Clear error messages** when line ranges are needed but missing
