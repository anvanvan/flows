# Concurrent-Safe Code Review

The flows plugin's code review system is designed to work safely in environments where multiple agents or humans are working simultaneously.

## The Problem

Traditional code review systems use git ranges (BASE_SHA..HEAD_SHA) which assume:
- Sequential execution (one change at a time)
- HEAD doesn't move during review
- No concurrent work happens

This breaks in parallel execution environments:
```
Task agent commits work → abc123
Code reviewer starts with BASE..HEAD
Meanwhile, another agent commits → def456 (HEAD moves)
Code reviewer does git checkout HEAD → DESTROYS def456
```

## The Solution

**Commit-SHA-List Approach:**
- Task subagents report exact commit SHAs they created
- Code reviewer uses those SHAs for read-only inspection
- Never checkout or modify working tree
- Detects concurrent modifications to same files
- Fails loudly on conflicts

## How It Works

### 1. Task Subagent Reports

After completing work, task subagent reports:

```
## Commits Created
- a1b2c3d (feat: add authentication)
- f6e5d4c (test: add auth tests)

## Files Modified
- src/auth/login.js (created)
- tests/auth.test.js (created)
```

### 2. Code Reviewer Safety Checks

Before reviewing code, reviewer:

**Verifies commits exist:**
```bash
git cat-file -t a1b2c3d  # Checks commit is reachable
```
If commit missing → STOP, report error (possible rebase/amend)

**Detects concurrent modifications:**
```bash
# Compare task's final state to current state
git diff a1b2c3d HEAD -- src/auth/login.js
```

If differences found:
- **Overlapping line ranges** → REAL CONFLICT (Critical issue, STOP)
- **Different sections** → BENIGN (note in review, continue)

**Checks for uncommitted changes:**
```bash
git diff src/auth/login.js      # Unstaged
git diff --cached src/auth/login.js  # Staged
```
If found → Important issue (task forgot to commit)

### 3. Read-Only Review

All git operations are read-only:
```bash
git show a1b2c3d        # View commit
git diff a1b2c3d^ a1b2c3d  # View changes
```

**Never:**
- `git checkout`
- `git reset`
- `git restore`
- Any operation that modifies working tree

## Conflict Classification

### Real Conflict (Critical Issue)

```
Task modified lines 10-25
Concurrent modified lines 15-30
Overlapping range: 15-25 → CONFLICT
```

**Action:** STOP review, report to user with both diffs

### Benign Concurrent Change

```
Task modified lines 10-25
Concurrent modified lines 100-120
No overlap, sufficient distance → BENIGN
```

**Action:** Note in review, continue

## Edge Cases

**Missing commit:**
- Cause: Commit amended, rebased, or force-pushed
- Detection: `git cat-file -t <SHA>` fails
- Action: STOP, report error with diagnostics

**File deleted:**
- Cause: Concurrent work deleted file task modified
- Detection: `git diff` shows entire file deletion
- Action: Critical issue, STOP

**File renamed:**
- Cause: Concurrent work renamed file task modified
- Detection: `git diff` shows deletion (optionally detect rename with `--follow`)
- Action: Important issue, continue with warning

**Uncommitted changes:**
- Cause: Task made changes but didn't commit
- Detection: `git diff` or `git diff --cached` shows changes
- Action: Important issue, continue but flag

## Benefits

**Safety:**
- No data loss from checkout/reset operations
- Concurrent work is preserved
- Conflicts detected before they cause problems

**Correctness:**
- Reviews exact commits task created
- Not affected by concurrent HEAD movement
- Clear separation of task's work vs. others' work

**Transparency:**
- Explicit commit identification
- Clear reporting of concurrent changes
- Fails loudly rather than silently corrupting

## Usage

### For Task Subagents

Include this in your report:

```
## Commits Created
- <SHA> (commit message)
...

## Files Modified
- path/to/file.js (created|modified|deleted)
...
```

Get your commit SHAs:
```bash
git log --oneline -n 3  # Last 3 commits
```

### For Code Reviewers

Read the template at `skills/requesting-code-review/code-reviewer.md` and follow the safety check protocol.

### For Workflow Authors

When dispatching code-reviewer, provide:
- `COMMIT_SHAS`: List of SHAs (one per line)
- `FILES_MODIFIED`: List of paths (one per line)

**Do NOT use:**
- `BASE_SHA` (deprecated)
- `HEAD_SHA` (deprecated)

## Testing

See `docs/test-cases/concurrent-code-review-test-suite.md` for comprehensive test scenarios.

## Limitations

**Conflict detection heuristics:**
- Line-based overlap detection (not semantic)
- May miss subtle semantic conflicts
- May flag some benign changes as conflicts (false positives better than false negatives)

**File renames:**
- Basic implementation may not detect renames
- Reports as deletion instead
- Can be improved with `git log --follow`

**Performance:**
- More git operations than simple BASE..HEAD approach
- Acceptable for typical task sizes (1-5 commits)
- May be slower for very large tasks (20+ commits)

## Future Improvements

- Semantic conflict detection (AST-based)
- Better rename detection
- Automatic conflict resolution for trivial cases
- Performance optimizations for large commit ranges
