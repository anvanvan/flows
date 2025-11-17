# Targeted Line Staging Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use flows:subagent-driven-development to implement this plan task-by-task.

**Goal:** Replace broad line range staging (e.g., `1-420`) with surgical precision staging (e.g., `18,25-31,138,326`) using semantic tracking + git diff parsing.

**Architecture:** Two-phase approach - semantic change log during work + git diff parsing at commit time with mandatory verification.

**Tech Stack:** Markdown skill documentation, git diff parsing, bash commands

---

## Task 1: Update writing-plans/SKILL.md

**Files:**
- Modify: `skills/writing-plans/SKILL.md:100-109`

**Step 1: Read current git workflow section**

Read `skills/writing-plans/SKILL.md` lines 100-109 to see current commit instructions.

**Step 2: Replace with new semantic tracking + git diff workflow**

Replace lines 100-109 with the complete standalone workflow:

```markdown
**Step 5: Commit with Precise Line Staging**

Use semantic tracking during work, then git diff parsing at commit time for surgical precision.

---

**Workflow: Semantic Tracking + Git Diff Parsing**

### Phase 1: Track Changes Semantically (As You Work)

Maintain a mental change log with brief descriptions:

```
Changes to <filename>:
1. [What you changed] (~approximate line)
2. [What you changed] (~approximate lines)
```

**Example while working on EventContent.tsx:**
```
Changes to EventContent.tsx:
1. Removed PlaceholderEvent import (~line 18)
2. Changed 7 type unions to remove PlaceholderEvent (~lines 26-162)
3. Removed setPlaceholderEvent from context (~line 139)
4. Removed setPlaceholderEvent(null) call (~line 327)
```

**Purpose:** Keeps you organized. Line numbers are approximate hints only.

---

### Phase 2: Extract Precise Lines (At Commit Time)

**Step 2a: Run git diff with zero context**
```bash
git diff --unified=0 apps/web/.../EventContent.tsx
```

**Step 2b: Extract hunk headers**
```bash
git diff --unified=0 apps/web/.../EventContent.tsx | grep "^@@"
```

**Output shows hunks like:**
```
@@ -18,1 +18,0 @@
@@ -26,7 +25,7 @@
@@ -139,1 +138,1 @@
@@ -327,1 +326,0 @@
```

**Step 2c: Parse hunk format `@@ -<old> +<new> @@`**

Extract from `+<new_start>,<new_count>`:

| Hunk Header | Meaning | Extract |
|-------------|---------|---------|
| `@@ -18,1 +18,0 @@` | Deleted 1 line at position 18 | `18` |
| `@@ -26,7 +25,7 @@` | Changed 7 lines starting at 25 | `25-31` |
| `@@ -139,1 +138,1 @@` | Changed 1 line at position 138 | `138` |
| `@@ -327,1 +326,0 @@` | Deleted 1 line at position 326 | `326` |
| `@@ -50,0 +51,3 @@` | Inserted 3 lines starting at 51 | `51-53` |

**Parsing rules:**
- Single line (`+N,1`): Extract `N`
- Range (`+N,C` where C>1): Extract `N-(N+C-1)`
- Deletion (`+N,0`): Extract `N`

**Step 2d: Combine into comma-separated format**
```
18,25-31,138,326
```

---

### Phase 3: Verify Changes (MANDATORY)

**Before staging, verify changes match your semantic log:**
```bash
# REQUIRED: Review human-readable diff
git diff apps/web/.../EventContent.tsx | head -50
```

**Check:**
✓ Import removal visible?
✓ Type union changes visible?
✓ Context destructuring change visible?
✓ setPlaceholderEvent call removal visible?

**If verification fails:** Re-examine your semantic log and parsed line numbers. Something doesn't match.

---

### Phase 4: Generate Commit Command

**Modified files (with parsed lines):**
```bash
git stage-lines 18,25-31,138,326 apps/web/.../EventContent.tsx && \
  git commit -m "refactor: remove PlaceholderEvent from EventContent"
```

**New files (no line numbers):**
```bash
git stage-lines tests/path/new-test.tsx && \
  git commit -m "test: add EventContent tests"
```

**Multiple files (mixed):**
```bash
git stage-lines 18,25-31,138,326 apps/web/.../EventContent.tsx && \
  git stage-lines 50-75,100 src/other-file.tsx && \
  git stage-lines tests/new-test.tsx && \
  git commit -m "feat: implement feature per Task N"
```

---

### Why This Approach Works

✓ **Semantic log** keeps you organized during execution
✓ **Git diff** provides drift-proof line numbers (handles insertions/deletions)
✓ **Mandatory verification** catches mismatches before committing
✓ **Precise staging** prevents conflicts with parallel work
✓ **No manual tracking** of shifting line numbers

---

**Complete commit step example:**

```bash
# 1. Parse changed lines from git diff
git diff --unified=0 apps/web/.../EventContent.tsx | grep "^@@"
# Hunks show: 18, 25-31, 138, 326

# 2. VERIFY: Review changes (MANDATORY)
git diff apps/web/.../EventContent.tsx | head -50
# Confirm: matches semantic log ✓

# 3. Stage precisely and commit
git stage-lines 18,25-31,138,326 apps/web/.../EventContent.tsx && \
  git commit -m "refactor: remove PlaceholderEvent from EventContent"
```
```

**Step 3: Verify the edit**

Read the modified section to confirm it matches the design.

Expected: Complete standalone workflow with all 4 phases documented.

**Step 4: Commit**

```bash
# Parse changed lines
git diff --unified=0 skills/writing-plans/SKILL.md | grep "^@@"
# Extract line ranges from hunks

# Verify changes
git diff skills/writing-plans/SKILL.md | head -100

# Stage and commit
git stage-lines <parsed-ranges> skills/writing-plans/SKILL.md && \
  git commit -m "docs(skills): add targeted line staging to writing-plans"
```

---

## Task 2: Update subagent-driven-development/SKILL.md

**Files:**
- Modify: `skills/subagent-driven-development/SKILL.md:78-95`

**Step 1: Read current git workflow section**

Read `skills/subagent-driven-development/SKILL.md` lines 78-95.

**Step 2: Replace with new workflow**

Replace lines 78-95 with:

```markdown
## Git Workflow with Semantic Tracking + Precise Staging

**Two-phase commit process with mandatory verification:**

### Phase 1: Semantic Change Tracking (as you work)

Maintain a simple change log as you edit:

```
Changes to <filename>:
1. [Brief description of change] (~line X)
2. [Brief description of change] (~lines Y-Z)
3. [Brief description of change] (~line W)
```

**Example:**
```
Changes to EventContent.tsx:
1. Removed PlaceholderEvent import (~line 18)
2. Changed type unions to remove PlaceholderEvent (7 locations)
3. Removed setPlaceholderEvent from context (~line 139)
4. Removed setPlaceholderEvent(null) call (~line 327)
```

**Why:** Keeps you organized. Line numbers are approximate hints only.

---

### Phase 2: Precise Line Extraction (at commit time)

When ready to commit, extract exact line numbers using git diff:

**Step 1: Parse git diff for changed lines**
```bash
git diff --unified=0 <file> | grep "^@@"
```

**Step 2: Extract line numbers from hunk headers**

Hunk format: `@@ -<old> +<new> @@`
Extract from `+<new_start>,<new_count>`:

| Hunk Header | Meaning | Extract |
|-------------|---------|---------|
| `@@ -18,1 +18,0 @@` | Deleted 1 line at position 18 | `18` |
| `@@ -26,7 +25,7 @@` | Changed 7 lines starting at 25 | `25-31` |
| `@@ -139,1 +138,1 @@` | Changed 1 line at position 138 | `138` |
| `@@ -327,1 +326,0 @@` | Deleted 1 line at position 326 | `326` |
| `@@ -50,0 +51,3 @@` | Inserted 3 lines starting at 51 | `51-53` |

**Parsing rules:**
- Single line (`+N,1`): Extract `N`
- Range (`+N,C` where C>1): Extract `N-(N+C-1)`
- Deletion (`+N,0`): Extract `N`

**Step 3: Combine into comma-separated format**
```
18,25-31,138,326
```

---

### Phase 3: Verification (MANDATORY)

**Before staging, ALWAYS verify changes match your semantic log:**

```bash
# REQUIRED: Review human-readable diff
git diff <file> | head -50
```

**Verify each item from your semantic log is visible in the diff.**

**If verification fails:** Re-examine your semantic log and parsed line numbers. Something doesn't match - investigate before proceeding.

---

### Phase 4: Commit Command Examples

**New file:**
```bash
git stage-lines new-file.tsx && git commit -m "feat: add new component"
```

**Modified file with parsed lines:**
```bash
# After verification passes
git stage-lines 18,25-31,138,326 EventContent.tsx && \
  git commit -m "refactor: remove PlaceholderEvent from EventContent"
```

**Multiple files:**
```bash
# After verifying all files
git stage-lines 18,25-31 file1.tsx && \
  git stage-lines 50-75,100 file2.tsx && \
  git stage-lines new-test.tsx && \
  git commit -m "feat: implement feature per Task N"
```

---

### Complete Workflow Example

```bash
# 1. Parse changed lines
git diff --unified=0 EventContent.tsx | grep "^@@"
# Shows hunks: @@ -18,1 +18,0 @@, @@ -26,7 +25,7 @@, etc.
# Extract: 18,25-31,138,326

# 2. VERIFY (MANDATORY)
git diff EventContent.tsx | head -50
# Confirm all 4 semantic changes visible ✓

# 3. Stage and commit
git stage-lines 18,25-31,138,326 EventContent.tsx && \
  git commit -m "refactor: remove PlaceholderEvent from EventContent"
```

---

### Why This Works

✓ **Semantic log** keeps you organized during execution
✓ **Git diff** provides drift-proof line numbers (handles insertions/deletions)
✓ **Mandatory verification** catches mismatches before committing
✓ **Precise staging** prevents conflicts with parallel work
✓ **No manual tracking** of shifting line numbers
```

**Step 3: Verify the edit**

Read the modified section to confirm completeness.

Expected: Full standalone workflow matching writing-plans.

**Step 4: Commit**

```bash
# Parse changed lines
git diff --unified=0 skills/subagent-driven-development/SKILL.md | grep "^@@"

# Verify
git diff skills/subagent-driven-development/SKILL.md | head -100

# Stage and commit
git stage-lines <parsed-ranges> skills/subagent-driven-development/SKILL.md && \
  git commit -m "docs(skills): add targeted line staging to subagent-driven-development"
```

---

## Task 3: Test the workflow with a simple example

**Files:**
- Create: `test-targeted-staging.md`

**Step 1: Create test file**

Create a simple test markdown file with 50 lines:

```bash
cat > test-targeted-staging.md << 'EOF'
# Test File for Targeted Staging

Line 3
Line 4
Line 5
...
Line 50
EOF

git add test-targeted-staging.md && git commit -m "test: add test file"
```

**Step 2: Make some edits**

Edit lines 10, 20-25, and 40 to test the workflow.

**Step 3: Apply the new workflow**

Follow the semantic tracking + git diff parsing workflow:

1. Track changes semantically
2. Parse git diff --unified=0
3. Verify with git diff
4. Stage using parsed line numbers
5. Commit

**Step 4: Verify staged lines match changes**

```bash
git diff --cached test-targeted-staging.md

# Should only show the exact lines we edited
```

Expected: PASS - only edited lines staged

**Step 5: Clean up test**

```bash
git reset HEAD~1
git checkout test-targeted-staging.md
rm test-targeted-staging.md
```

**Step 6: Report results**

Document whether the workflow successfully staged only the changed lines.
