---
name: executing-plans
description: Use when partner provides a complete implementation plan to execute in controlled batches with review checkpoints - loads plan, reviews critically, executes tasks in batches, reports for review between batches
---

# Executing Plans

## Overview

Load plan, review critically, execute tasks in batches, report for review between batches.

**Core principle:** Batch execution with checkpoints for architect review.

## The Process

### Step 1: Load and Review Plan
1. Read plan file
2. Review critically - identify any questions or concerns about the plan
3. If concerns: Raise them with your human partner before starting
4. If no concerns: Create TodoWrite and proceed

### Pre-Execution: Plan Context Loading (MANDATORY)

**After loading plan, before starting batch 1, dispatch Explore** with thoroughness: "very thorough"

Use Task tool:
```python
subagent_type = "Explore"
model = "haiku"
prompt = """
Explore codebase to verify plan context for [feature from plan]:
1. Verify all file paths mentioned in plan exist and are current
2. Find any codebase changes since plan was written that affect tasks
3. Locate additional context not in plan (recent refactors, new patterns)
4. Identify any risks or conflicts with current codebase state
5. Find updated dependencies, configurations, or requirements

Return:
- Plan accuracy assessment (paths valid, assumptions current)
- Codebase changes affecting plan
- Additional context needed
- Risks or conflicts identified
- Updated requirements

**CRITICAL:** Do NOT create temporary files (/tmp, docs/, etc).
Aggregate all findings in memory and return complete report in your final message.
All results must appear in function_results - no file creation.

Thoroughness: very thorough
"""
```

**Consuming Plan Validation Results:**

After Task tool returns, validation report appears in function_results.

**Read and extract:**
- Plan accuracy assessment (paths valid, assumptions current)
- Codebase changes affecting plan
- Additional context needed
- Risks or conflicts identified
- Updated requirements

**Use for:** Deciding whether plan needs updates. If discrepancies found, report to user with options (update plan, proceed with adaptation, cancel for revision).

**If discrepancies found:**
Report to user:
"Plan is from [date]. Codebase changes detected:
- [Changes affecting plan]
- [Risks identified]

Options:
1. Update plan to reflect current codebase
2. Proceed with plan and adapt as needed
3. Cancel execution for plan revision"

**Per-batch targeted Explore (optional):**
Before each batch, can dispatch focused Explore for batch-specific context.

### Step 2: Execute Batch
**Default: First 3 tasks**

For each task:
1. Mark as in_progress
2. Follow each step exactly (plan has bite-sized steps)
3. Run verifications as specified
4. Commit using targeted line staging (see Git Workflow below)
5. Mark as completed

---

### Git Workflow for Commits

When committing changes for each task, use the targeted line staging workflow for surgical precision:

**Phase 1: Track Changes Semantically (As You Work)**

Maintain a mental change log with brief descriptions:

```
Changes to <filename>:
1. [What you changed] (~approximate line)
2. [What you changed] (~approximate lines)
```

**Example:**
```
Changes to EventContent.tsx:
1. Removed PlaceholderEvent import (~line 18)
2. Changed 7 type unions to remove PlaceholderEvent (~lines 26-162)
3. Removed setPlaceholderEvent from context (~line 139)
4. Removed setPlaceholderEvent(null) call (~line 327)
```

**Purpose:** Keeps you organized. Line numbers are approximate hints only.

---

**Phase 2: Extract Precise Lines (At Commit Time)**

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

**Phase 3: Verify Changes (MANDATORY)**

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

**Phase 4: Generate Commit Command**

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

**Why This Approach Works:**

✓ **Semantic log** keeps you organized during execution
✓ **Git diff** provides drift-proof line numbers (handles insertions/deletions)
✓ **Mandatory verification** catches mismatches before committing
✓ **Precise staging** prevents conflicts with parallel work
✓ **No manual tracking** of shifting line numbers

---

### Step 3: Report
When batch complete:
- Show what was implemented
- Show verification output
- Say: "Ready for feedback."

### Step 4: Continue
Based on feedback:
- Apply changes if needed
- Execute next batch
- Repeat until complete

### Step 5: Complete Development

After all tasks complete and verified:
- Announce: "I'm using the finishing-a-development-branch skill to complete this work."
- **REQUIRED SUB-SKILL:** Use @flows:finishing-a-development-branch
- Follow that skill to verify tests, present options, execute choice

## When to Stop and Ask for Help

**STOP executing immediately when:**
- Hit a blocker mid-batch (missing dependency, test fails, instruction unclear)
- Plan has critical gaps preventing starting
- You don't understand an instruction
- Verification fails repeatedly

**Ask for clarification rather than guessing.**

## When to Revisit Earlier Steps

**Return to Review (Step 1) when:**
- Partner updates the plan based on your feedback
- Fundamental approach needs rethinking

**Don't force through blockers** - stop and ask.

## Remember
- Review plan critically first
- Follow plan steps exactly
- Don't skip verifications
- Reference skills when plan says to
- Between batches: just report and wait
- Stop when blocked, don't guess
