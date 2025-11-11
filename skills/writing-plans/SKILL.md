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

**Step 5: Commit**

```bash
# Chain stage + commit to minimize race conditions with parallel work
git stage-lines tests/path/test.py && \
  git stage-lines 1-20,36 src/path/file.py && \
  git commit -m "feat: implement feature X per Task N"

# TIP: Use `git diff src/path/file.py` to see line numbers for your changes
# TIP: Multi-range syntax (1-20,36) stages only your changes, not others' work
```
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
