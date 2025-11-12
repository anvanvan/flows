---
name: requesting-code-review
description: Use when completing tasks, implementing major features, or before merging to verify work meets requirements - dispatches flows:code-reviewer subagent to review implementation against plan or requirements before proceeding
---

# Requesting Code Review

Dispatch flows:code-reviewer subagent to catch issues before they cascade.

**Core principle:** Review early, review often.

## Pre-Review: Completeness Verification

**Before requesting code-reviewer, dispatch Explore agent** with thoroughness: "very thorough"

Use Task tool:
```python
subagent_type = "Explore"
model = "haiku"
prompt = """
Explore to verify implementation completeness for [feature]:
1. Find all files that should be modified for this feature (based on similar features)
2. Locate test files that should cover this implementation
3. Identify documentation that should be updated
4. Find configuration or migration files that might need changes
5. Locate any integration points or dependent code

Return:
- Expected file modifications (based on patterns)
- Test coverage expectations
- Documentation update requirements
- Configuration/migration needs
- Integration points to verify

Compare against actual changes made.

Thoroughness: very thorough
"""
```

**Pass findings to code-reviewer agent:**
Include Explore report in review context so code-reviewer can:
- Verify all expected files were modified
- Check for missing tests
- Identify missing documentation updates
- Flag incomplete integration coverage

## When to Request Review

**Mandatory:**
- After each task in subagent-driven development
- After completing major feature
- Before merge to main

**Optional but valuable:**
- When stuck (fresh perspective)
- Before refactoring (baseline check)
- After fixing complex bug

## How to Request

**1. Identify commits to review:**

If you're a task subagent, you already know your commit SHAs:
```bash
# Get your last N commits
git log --oneline -n 3
# Example output:
# a1b2c3d feat: add feature X
# f6e5d4c test: add tests for X
# 9e8d7c6 docs: update README
```

If you're manually requesting review:
```bash
# Review specific commits
COMMIT_SHAS="abc123
def456
ghi789"

# Or review all commits since a base
BASE_REF=origin/main  # or a specific SHA
git log --oneline $BASE_REF..HEAD
# Copy the SHAs you want reviewed
```

**2. Identify files modified:**

```bash
# List files changed in your commits
FIRST_SHA=<oldest commit to review>
LAST_SHA=<newest commit to review>
git diff --name-only ${FIRST_SHA}^ $LAST_SHA

# Example output:
# src/auth/login.js
# tests/auth.test.js
```

**3. Dispatch code-reviewer subagent:**

Use Task tool with flows:code-reviewer type, fill template at `code-reviewer.md`

**Placeholders:**
- `{WHAT_WAS_IMPLEMENTED}` - What you just built
- `{PLAN_OR_REQUIREMENTS}` - What it should do
- `{COMMIT_SHAS}` - List of commit SHAs to review (one per line)
- `{FILES_MODIFIED}` - List of file paths modified (one per line)
- `{DESCRIPTION}` - Brief summary

**4. Act on feedback:**
- Fix Critical issues immediately (especially concurrent conflicts)
- Fix Important issues before proceeding
- Note Minor issues for later
- Push back if reviewer is wrong (with reasoning)

## Example

```
[Just completed Task 2: Add verification function]

You: Let me request code review before proceeding.

[Get commit SHAs]
git log --oneline -n 2
# Output:
# 3df7661 test: add verification tests (8 tests)
# a7981ec feat: add verifyIndex and repairIndex functions

[Get files modified]
git diff --name-only a7981ec^ 3df7661
# Output:
# src/verify.js
# tests/verify.test.js

[Dispatch flows:code-reviewer subagent]
  WHAT_WAS_IMPLEMENTED: Verification and repair functions for conversation index
  PLAN_OR_REQUIREMENTS: Task 2 from docs/plans/deployment-plan.md
  COMMIT_SHAS: |
    3df7661
    a7981ec
  FILES_MODIFIED: |
    src/verify.js
    tests/verify.test.js
  DESCRIPTION: Added verifyIndex() and repairIndex() with 4 issue types

[Subagent returns]:
  Safety Check Results: ✓ Commits verified, no concurrent changes, no uncommitted changes
  Strengths: Clean architecture, real tests
  Issues:
    Important: Missing progress indicators (verify.js:45-60)
    Minor: Magic number (100) for reporting interval
  Assessment: Ready to proceed with fixes

You: [Fix progress indicators]
[Request review again]
[Review passes]
[Continue to Task 3]
```

## Concurrent Execution Safety

The code-reviewer is designed to work safely in concurrent environments:

**Safe scenarios:**
- Multiple task subagents running in parallel
- Human editing files while review happens
- Other commits added between task completion and review

**How it works:**
1. **Read-only operations:** Reviewer never checks out or modifies working tree
2. **Explicit commit identification:** Uses exact commit SHAs, not ranges
3. **Concurrent modification detection:** Checks if files were changed after task commits
4. **Conflict classification:** Distinguishes real conflicts from benign concurrent changes

**If concurrent conflict detected:**
- Code reviewer stops and reports Critical issue
- Includes details: which file, what changed, line ranges
- You must manually resolve before proceeding

**Example conflict:**
```
Task modified src/auth.js lines 10-25
Concurrent work modified src/auth.js lines 15-30
Overlapping range 15-25 = REAL CONFLICT
```

**Example benign concurrent change:**
```
Task modified src/auth.js lines 10-25
Concurrent work modified src/auth.js lines 100-120
No overlap, sufficient distance = BENIGN
Code reviewer notes it but continues review
```

## Integration with Workflows

**Subagent-Driven Development:**
- Review after EACH task
- Catch issues before they compound
- Fix before moving to next task

**Executing Plans:**
- Review after each batch (3 tasks)
- Get feedback, apply, continue

**Ad-Hoc Development:**
- Review before merge
- Review when stuck

## Red Flags

**Never:**
- Skip review because "it's simple"
- Ignore Critical issues (especially concurrent conflicts)
- Proceed with unfixed Important issues
- Argue with valid technical feedback
- Use BASE_SHA/HEAD_SHA approach (deprecated, unsafe for concurrent execution)

**If concurrent conflict detected:**
- STOP immediately
- Read the conflict details carefully
- Manually inspect both changes
- Resolve conflict appropriately
- Re-run review after resolution

**If reviewer wrong:**
- Push back with technical reasoning
- Show code/tests that prove it works
- Request clarification

See template at: requesting-code-review/code-reviewer.md
