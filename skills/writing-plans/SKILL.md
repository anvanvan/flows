---
name: writing-plans
description: Use when design is complete and you need detailed implementation tasks for engineers with zero codebase context - creates comprehensive implementation plans with exact file paths, complete code examples, and verification steps assuming engineer has minimal domain knowledge
---

# Writing Plans

## Overview

Write comprehensive implementation plans assuming the engineer has zero context for our codebase and questionable taste. Document everything they need to know: which files to touch for each task, code, testing, docs they might need to check, how to test it. Give them the whole plan as bite-sized tasks. DRY. YAGNI. TDD. Frequent commits.

Assume they are a skilled developer, but know almost nothing about our toolset or problem domain. Assume they don't know good test design very well.

**Announce at start:** "I'm using the writing-plans skill to create the implementation plan."

**Context:** This should be run in a dedicated worktree (created by brainstorming skill).

**Save plans to:** `docs/plans/YYYY-MM-DD-<feature-name>.md`

## Bite-Sized Task Granularity

**Each step is one action (2-5 minutes):**
- "Write the failing test" - step
- "Run it to make sure it fails" - step
- "Implement the minimal code to make the test pass" - step
- "Run the tests and make sure they pass" - step
- "Commit" - step

## Plan Document Header

**Every plan MUST start with this header:**

```markdown
# [Feature Name] Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use flows:subagent-driven-development to implement this plan task-by-task.

**Goal:** [One sentence describing what this builds]

**Architecture:** [2-3 sentences about approach]

**Tech Stack:** [Key technologies/libraries]

---
```

**BEFORE WRITING PLAN** - If tech stack includes unfamiliar technologies:
- **INVOKE WEB-RESEARCHER** to understand:
  - Current installation/setup procedures
  - API usage patterns and examples
  - Integration requirements
  - Common gotchas and best practices
  - Version compatibility matrices
  - Search for: official quickstarts, setup guides, integration examples, troubleshooting docs

**WHEN WRITING IMPLEMENTATION STEPS:**
- **INVOKE WEB-RESEARCHER IF STEPS INVOLVE:**
  - External API calls (syntax verification needed)
  - Library-specific patterns (need current examples)
  - Configuration formats (may have version-specific differences)
  - CLI commands (flags and options may have changed)
  - Search for: API signatures, required parameters, authentication flows, configuration schemas

## Task Structure

```markdown
### Task N: [Component Name]

**Files:**
- Create: `exact/path/to/file.py`
- Modify: `exact/path/to/existing.py:123-145`
- Test: `tests/exact/path/to/test.py`

**Step 1: Write the failing test**

```python
def test_specific_behavior():
    result = function(input)
    assert result == expected
```

**Step 2: Run test to verify it fails**

Run: `pytest tests/path/test.py::test_name -v`
Expected: FAIL with "function not defined"

**Step 3: Write minimal implementation**

```python
def function(input):
    return expected
```

**Step 4: Run test to verify it passes**

Run: `pytest tests/path/test.py::test_name -v`
Expected: PASS

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

## Remember
- Exact file paths always
- Complete code in plan (not "add validation")
- Exact commands with expected output
- Reference relevant skills with @ syntax
- DRY, YAGNI, TDD, frequent commits

## Execution Handoff

After saving the plan, use AskUserQuestion to offer execution choices:

**Question:** "Plan complete and saved! How would you like to execute it?"
**Header:** "Execution"
**multiSelect:** false
**Options:**

1. **"Copy command for new session"** (Recommended)
   - Description: "Copies `/flows:execute-plan @docs/plans/filename.md` to clipboard for pasting into a fresh session"

2. **"Execute with subagent-driven-development (this session)"**
   - Description: "Dispatch fresh subagent per task with code review between tasks - fast iteration in current session"

3. **"Execute in parallel session (gradual)"**
   - Description: "Open new session, run `/flows:execute-plan-gradual` for batched execution with manual checkpoints"

4. Auto-provided "Other" option allows refinement feedback

**Handling the user's choice:**

**If "Copy command for new session" selected:**
- Extract actual plan filename from the path where plan was saved
- Copy to clipboard: `/flows:execute-plan @docs/plans/<actual-filename>.md`
- Example: If saved to `docs/plans/2025-11-11-auth-system.md`, copy: `/flows:execute-plan @docs/plans/2025-11-11-auth-system.md`
- Confirm: "Command copied to clipboard! Paste into a new session to begin execution."
- Skill completes

**If "Execute with subagent-driven-development (this session)" selected:**
- Announce: "Using flows:subagent-driven-development to execute the plan"
- **REQUIRED SUB-SKILL:** Use flows:subagent-driven-development
- Stay in this session

**If "Execute in parallel session (gradual)" selected:**
- Guide them to open new session in worktree
- Tell them to run `/flows:execute-plan-gradual`
- **REQUIRED SUB-SKILL:** New session uses flows:executing-plans

**If "Other" / refinement feedback provided:**
- Read user's feedback text
- Ask clarifying questions (one at a time) about what needs refinement
- Update plan document based on discussion
- Confirm changes made
- Re-offer execution choices (return to AskUserQuestion)
- Continue refinement loop until user selects a concrete execution option
