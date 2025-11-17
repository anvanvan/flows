# Concurrent-Safe Code Review Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use flows:subagent-driven-development to implement this plan task-by-task.

**Goal:** Make code review safe for concurrent execution by using commit-SHA-list approach instead of BASE/HEAD ranges

**Architecture:** Replace destructive git range operations with read-only commit inspection. Task subagents report exact commit SHAs they created; code reviewer uses those SHAs for read-only inspection via `git show`, detects concurrent modifications, and fails loudly on conflicts.

**Tech Stack:** Markdown templates, bash scripts for git operations, no external dependencies

---

## Task 1: Update Code Reviewer Template

**Files:**
- Modify: `skills/requesting-code-review/code-reviewer.md:1-147`

**Context:**
Current template uses `{BASE_SHA}` and `{HEAD_SHA}` which assumes sequential execution. This causes data loss when concurrent work happens (other agents, human edits). We need to switch to explicit commit-SHA-list approach with safety checks.

**Step 1: Write test case for new template format**

Create: `docs/test-cases/code-reviewer-concurrent-test.md`

```markdown
# Code Reviewer Concurrent Safety Test

## Scenario
1. Task subagent creates commits ABC, DEF
2. Concurrent work creates commit GHI touching same file
3. Code reviewer should detect concurrent modification

## Expected Behavior
- Safety checks verify ABC, DEF exist
- Detect GHI modified same file as ABC/DEF
- Classify as real conflict or benign
- Report in Safety Check Results section

## Test Data
- COMMIT_SHAS: ["abc123", "def456"]
- FILES_MODIFIED: ["src/auth.js", "tests/auth.test.js"]
- Concurrent commit: ghi789 modified src/auth.js line 50
- Task commits: modified src/auth.js lines 10-20
```

**Step 2: Update template header section**

In `skills/requesting-code-review/code-reviewer.md`, replace lines 1-28 with:

```markdown
# Code Review Agent

You are reviewing code changes for production readiness in a concurrent execution environment.

**Your task:**
1. Verify commits exist and haven't been modified
2. Detect concurrent modifications to task files
3. Review {WHAT_WAS_IMPLEMENTED}
4. Compare against {PLAN_OR_REQUIREMENTS}
5. Check code quality, architecture, testing
6. Verify no uncommitted changes in task files
7. Categorize issues by severity
8. Assess production readiness

## What Was Implemented

{DESCRIPTION}

## Requirements/Plan

{PLAN_REFERENCE}

## Commits to Review

{COMMIT_SHAS}

List of commit SHAs created by this task, one per line. Example:
```
abc123def456789...
def456ghi789012...
```

## Files Modified by Task

{FILES_MODIFIED}

List of file paths the task modified, one per line. Example:
```
src/auth/login.js
src/auth/session.js
tests/auth.test.js
```
```

**Step 3: Add Safety Checks section**

After the Files Modified section (around line 29), add:

```markdown
## Safety Checks (PERFORM THESE FIRST)

**Critical:** These checks ensure we're reviewing the right commits in a concurrent-safe way. If any check fails, STOP immediately and report the failure.

### Check 1: Verify All Commits Exist

For each commit SHA in COMMIT_SHAS:

```bash
# Verify commit is reachable
git cat-file -t <SHA>
```

**Expected output:** `commit`

**If fails:** STOP and report:
```
SAFETY CHECK FAILED: Commit <SHA> not found

This may indicate:
- Commit was amended (git commit --amend)
- Commit was rebased (git rebase)
- Commit was force-pushed away
- Wrong repository or branch

Current HEAD: <run git rev-parse HEAD>
Recent commits: <run git log --oneline -5>
```

### Check 2: Detect Concurrent Modifications

For each file in FILES_MODIFIED, check if it was modified by other work after the task's commits:

```bash
# Get the last task commit SHA (last one in COMMIT_SHAS list)
LAST_TASK_SHA=<last SHA from COMMIT_SHAS>

# For each file, compare task's version to current version
git diff $LAST_TASK_SHA HEAD -- path/to/file
```

**If diff is empty:** No concurrent changes to this file ✓

**If diff shows changes:** Concurrent modification detected. Analyze the changes:

1. **Get task's changes:**
   ```bash
   FIRST_TASK_SHA=<first SHA from COMMIT_SHAS>
   git diff ${FIRST_TASK_SHA}^ $LAST_TASK_SHA -- path/to/file
   ```

2. **Get concurrent changes:**
   ```bash
   git diff $LAST_TASK_SHA HEAD -- path/to/file
   ```

3. **Analyze overlap:**
   - Compare line ranges modified by task vs. concurrent work
   - Check if changes touch same functions/blocks
   - Determine if changes contradict each other

4. **Classify:**
   - **REAL CONFLICT:** Overlapping line ranges, same function modified, or contradictory changes
     - STOP and report: "Concurrent modification conflict detected in <file>"
     - Include both diffs in report
     - Ask user how to proceed

   - **BENIGN:** Different sections, sufficient line distance (5+ lines apart), additive changes
     - Note in Safety Check Results: "Concurrent changes detected in <file> (non-conflicting, lines X-Y)"
     - Continue with review

### Check 3: Verify No Uncommitted Changes in Task Files

For each file in FILES_MODIFIED:

```bash
# Check unstaged changes
git diff path/to/file

# Check staged changes
git diff --cached path/to/file
```

**If any output:** Uncommitted changes detected. This indicates task subagent made changes but didn't commit them.

**Action:** Flag as Important issue in review:
```
Important: Uncommitted changes in <file>
- File: <file>:affected-lines
- Issue: Task made changes but didn't commit them
- Why it matters: Changes aren't versioned, could be lost
- Fix: Commit all task changes
```

## Safety Check Results Section

After completing all safety checks, report results:

```markdown
### Safety Check Results

**Commit Verification:** ✓ All X commits exist and are reachable

**Concurrent Modifications:**
- src/auth.js: Concurrent changes detected (non-conflicting, lines 50-65)
- tests/auth.test.js: No concurrent changes ✓

**Uncommitted Changes:** None ✓

**Status:** Safe to proceed with review
```

If any safety check failed, stop here and report the failure instead of proceeding to code review.
```

**Step 4: Update Review Process section**

Replace the "Git Range to Review" section (old lines 20-28) with:

```markdown
## Review Process

**After safety checks pass, review the task's commits:**

```bash
# View all task commits together
git show <SHA1> <SHA2> <SHA3>

# Or review each commit individually
for sha in <COMMIT_SHAS>; do
  echo "=== Reviewing $sha ==="
  git show $sha
done

# Get summary of all changes
FIRST_SHA=<first from COMMIT_SHAS>
LAST_SHA=<last from COMMIT_SHAS>
git diff --stat ${FIRST_SHA}^ $LAST_SHA
```

**Note:** These are READ-ONLY operations. Never checkout, reset, or modify the working tree.
```

**Step 5: Update Critical Rules to emphasize safety**

In the "Critical Rules" section (around line 94), add at the top:

```markdown
**SAFETY FIRST:**
- ALWAYS run safety checks before reviewing code
- STOP immediately if any safety check fails
- NEVER checkout, reset, or modify working tree
- Flag concurrent conflicts as Critical issues
- Read-only git operations only (show, diff, log)
```

**Step 6: Update example output**

In the example output section (line 110-146), update to include safety check results:

```markdown
## Example Output

```
### Safety Check Results

**Commit Verification:** ✓ All 2 commits exist and are reachable
- abc123d (feat: add database schema)
- def456e (test: add schema validation tests)

**Concurrent Modifications:**
- db.ts: No concurrent changes ✓
- summarizer.ts: Concurrent changes detected (non-conflicting, lines 120-135)
- tests/db.test.ts: No concurrent changes ✓

**Uncommitted Changes:** None ✓

**Status:** Safe to proceed with review

---

### Strengths
- Clean database schema with proper migrations (db.ts:15-42)
- Comprehensive test coverage (18 tests, all edge cases)
- Good error handling with fallbacks (summarizer.ts:85-92)

### Issues

#### Important
1. **Missing help text in CLI wrapper**
   - File: index-conversations:1-31
   - Issue: No --help flag, users won't discover --concurrency
   - Fix: Add --help case with usage examples

[rest of example continues...]
```
```

**Step 7: Run a mental verification**

Check that:
- Template no longer references BASE_SHA or HEAD_SHA
- All git operations are read-only (no checkout, reset, restore)
- Safety checks run before code review
- Concurrent modification detection is clear
- Examples show the new format

**Step 8: Commit the template changes**

```bash
git diff skills/requesting-code-review/code-reviewer.md
# Review the changes match steps 2-6

git stage-lines skills/requesting-code-review/code-reviewer.md && \
  git commit -m "feat: make code-reviewer template concurrent-safe

Replace BASE_SHA/HEAD_SHA with commit-SHA-list approach.
Add safety checks for commit verification and concurrent modifications.
All operations are now read-only (no checkout/reset).

Implements Task 1 of concurrent-safe-code-review plan."
```

---

## Task 2: Update Subagent Task Prompt Template

**Files:**
- Modify: `skills/subagent-driven-development/SKILL.md:66-96`

**Context:**
Task subagents need to report commit SHAs and files modified. Current prompt doesn't specify this reporting format. We need to add clear instructions for structured reporting.

**Step 1: Write test case for subagent report format**

Create: `docs/test-cases/subagent-report-format-test.md`

```markdown
# Subagent Report Format Test

## Expected Report Structure

```
## Implementation Summary
Implemented user authentication with JWT tokens. Created login/logout endpoints.

## Testing
Wrote 8 tests covering:
- Valid login (200 response)
- Invalid credentials (401)
- Token expiry (401)
- Logout (clears session)

All tests passing (8/8).

## Commits Created
- a1b2c3d4e5f6 (feat: add auth endpoints and JWT middleware)
- f6e5d4c3b2a1 (test: add auth integration tests)

## Files Modified
- src/auth/login.js (created)
- src/auth/middleware.js (created)
- src/routes.js (modified, added auth routes)
- tests/auth.test.js (created)

## Issues Encountered
None. Implementation followed plan exactly.
```

## Invalid Reports (should be detected and fixed)

**Missing commit SHAs:**
```
## Implementation Summary
[content]

## Testing
[content]

## Files Modified
[list]
```
Should prompt: "Please add 'Commits Created' section with your commit SHAs"

**Malformed SHA:**
```
## Commits Created
- commit abc123 (message)
- def456
```
Should accept both formats (with or without "commit" prefix and message)
```

**Step 2: Update task dispatch prompt in subagent-driven-development**

In `skills/subagent-driven-development/SKILL.md`, find the task dispatch prompt (around lines 66-96). Replace the entire prompt template with:

```markdown
Task tool (general-purpose):
  description: "Implement Task N: [task name]"
  prompt: |
    You are implementing Task N from [plan-file].

    Read that task carefully. Your job is to:
    1. Implement exactly what the task specifies
    2. Write tests (following TDD if task says to)
    3. Verify implementation works
    4. Commit your work
    5. Report back with structured format below

    ## Git Workflow for Parallel Safety

    Always chain stage + commit to prevent race conditions with parallel agents:

    **Single file:**
    git stage-lines new-file.js && git commit -m "feat: task description"
    git stage-lines 1-20,36 file.js && git commit -m "feat: task description"

    **Multiple files:**
    git stage-lines 1-20,36 file.js && git stage-lines new-test.js && git commit -m "feat: ..."

    **Why line ranges:** Prevents staging unrelated changes from other parallel work.
    Check line numbers: `git diff file.js`

    Work from: [directory]

    ## Required Report Format

    You MUST report back using this structure:

    ```
    ## Implementation Summary
    [2-3 sentences: what you implemented, approach taken]

    ## Testing
    [What tests you wrote, what they cover, test results with counts]

    ## Commits Created
    - <SHA> (commit message)
    - <SHA> (commit message)
    ...

    Use `git log --oneline -n <count>` to get your commit SHAs.
    Include ALL commits you created during this task.

    ## Files Modified
    - path/to/file.js (created|modified|deleted)
    - path/to/another.js (created|modified|deleted)
    ...

    List ALL files you changed, with their status.

    ## Issues Encountered
    [Any problems, workarounds, or decisions made. Write "None" if no issues.]
    ```

    **Example report:**
    ```
    ## Implementation Summary
    Implemented user authentication with JWT tokens and bcrypt password hashing.
    Created login/logout endpoints and auth middleware.

    ## Testing
    Wrote 8 integration tests covering valid login, invalid credentials, token expiry,
    and logout. All tests passing (8/8).

    ## Commits Created
    - a1b2c3d (feat: add auth endpoints and JWT middleware)
    - f6e5d4c (test: add auth integration tests)

    ## Files Modified
    - src/auth/login.js (created)
    - src/auth/middleware.js (created)
    - src/routes.js (modified)
    - tests/auth.test.js (created)

    ## Issues Encountered
    None. Implementation followed plan exactly.
    ```
```

**Step 3: Verify the updated prompt is complete**

Check that the prompt includes:
- Instructions to implement the task
- Git workflow for parallel safety (unchanged)
- **NEW:** Required Report Format section
- **NEW:** Example report showing all required sections
- Commit SHAs extraction command (`git log --oneline`)
- File listing requirement

**Step 4: Commit the changes**

```bash
git diff skills/subagent-driven-development/SKILL.md

# Verify changes are only to the task dispatch prompt section (lines ~66-96)

git stage-lines 66-150 skills/subagent-driven-development/SKILL.md && \
  git commit -m "feat: add structured reporting format to task subagent prompt

Task subagents now must report:
- Commit SHAs created
- Files modified
- Implementation summary
- Testing results
- Issues encountered

Enables concurrent-safe code review via commit-SHA-list approach.

Implements Task 2 of concurrent-safe-code-review plan."
```

---

## Task 3: Update Code Review Invocation in Subagent-Driven-Development

**Files:**
- Modify: `skills/subagent-driven-development/SKILL.md:213-228`

**Context:**
The skill currently dispatches code-reviewer with BASE_SHA/HEAD_SHA. We need to parse the subagent's report, extract commit SHAs and files, then pass those to the code reviewer instead.

**Step 1: Write test case for report parsing**

Create: `docs/test-cases/report-parsing-test.md`

```markdown
# Report Parsing Test Cases

## Valid Report

Input:
```
## Implementation Summary
Added feature X

## Testing
5 tests, all passing

## Commits Created
- a1b2c3d (feat: add feature X)
- f6e5d4c (test: add tests)

## Files Modified
- src/feature.js (created)
- tests/feature.test.js (created)

## Issues Encountered
None
```

Expected extraction:
- COMMIT_SHAS: ["a1b2c3d", "f6e5d4c"]
- FILES_MODIFIED: ["src/feature.js", "tests/feature.test.js"]

## Edge Cases

**Short SHAs (7 chars):**
```
## Commits Created
- a1b2c3d (message)
```
Accept: Yes (git supports short SHAs)

**Full SHAs (40 chars):**
```
## Commits Created
- a1b2c3d4e5f6789012345678901234567890 (message)
```
Accept: Yes

**With "commit" prefix:**
```
## Commits Created
- commit a1b2c3d (message)
```
Extract: "a1b2c3d" (strip "commit" prefix)

**Missing Commits Created section:**
Error: "Report missing 'Commits Created' section. Please add your commit SHAs."

**Missing Files Modified section:**
Error: "Report missing 'Files Modified' section. Please list all files you changed."

**Malformed SHA (not hex):**
```
## Commits Created
- xyz123 (message)
```
Warning: "SHA 'xyz123' appears invalid (not hexadecimal). Proceeding anyway, will fail in safety check."
```

**Step 2: Add report parsing logic to Step 3**

In `skills/subagent-driven-development/SKILL.md`, find "### 3. Review Subagent's Work" (around line 213). Replace lines 213-228 with:

```markdown
### 3. Review Subagent's Work

**Parse subagent report:**

1. **Extract commit SHAs:**
   - Find "## Commits Created" section
   - Extract all lines starting with "-"
   - Parse SHA from each line (format: "- <SHA> (message)" or "- commit <SHA>")
   - Remove "commit" prefix if present
   - Result: list of SHAs like ["a1b2c3d", "f6e5d4c"]

2. **Extract files modified:**
   - Find "## Files Modified" section
   - Extract all lines starting with "-"
   - Parse file path (format: "- path/to/file.js (status)")
   - Keep just the path, strip (status)
   - Result: list of paths like ["src/auth.js", "tests/auth.test.js"]

3. **Validate extracted data:**
   - Commit SHAs: non-empty list, each SHA matches pattern `[a-f0-9]{7,40}`
   - Files modified: non-empty list, each path is non-empty string

   **If validation fails:**
   - Report parsing error to user
   - Show what was extracted
   - Ask subagent to reformat: "Your report is missing the 'Commits Created' section. Please add it with format: `- <SHA> (message)`"
   - After subagent provides fixed report, retry parsing

4. **Extract implementation summary:**
   - Find "## Implementation Summary" section
   - Use for WHAT_WAS_IMPLEMENTED

**Dispatch code-reviewer subagent:**

```
Task tool (flows:code-reviewer):
  Use template at requesting-code-review/code-reviewer.md

  WHAT_WAS_IMPLEMENTED: [from subagent's Implementation Summary section]
  PLAN_OR_REQUIREMENTS: Task N from [plan-file]
  COMMIT_SHAS: [extracted list, one SHA per line, e.g.:]
    a1b2c3d
    f6e5d4c
  FILES_MODIFIED: [extracted list, one path per line, e.g.:]
    src/auth/login.js
    tests/auth.test.js
  DESCRIPTION: [task summary from plan]
```

**Code reviewer returns:**
- Safety Check Results (commits verified, concurrent mods detected, uncommitted changes)
- Strengths, Issues (Critical/Important/Minor), Assessment

**Handle safety check failures:**

If code reviewer reports safety check failure:

**Concurrent modification conflict:**
- STOP task execution
- Report to user:
  ```
  Task N encountered concurrent modification conflict:

  File: <file>
  Conflict: [details from code reviewer]

  This means another agent or person modified the same code this task changed.

  Options:
  1. Manually resolve conflict and retry review
  2. Skip this task for now
  3. Abort plan execution

  What would you like to do?
  ```
- Wait for user decision

**Commit not found:**
- STOP task execution
- Report to user:
  ```
  Task N safety check failed: Commit <SHA> not found

  This may indicate:
  - Commit was amended or rebased
  - Git history was modified
  - Repository state is inconsistent

  Current HEAD: <git rev-parse HEAD>
  Task reported SHAs: <list>

  Please investigate and manually verify repository state.
  ```
- Do not proceed

**Uncommitted changes:**
- Code reviewer flags as Important issue
- Continue to Step 4 (Apply Review Feedback)
```

**Step 3: Verify the changes**

Check that:
- Parsing logic is clear and handles edge cases
- Validation catches missing sections
- Code reviewer dispatch uses COMMIT_SHAS and FILES_MODIFIED (not BASE_SHA/HEAD_SHA)
- Safety check failures are handled properly
- User is informed and given options on conflicts

**Step 4: Commit the changes**

```bash
git diff skills/subagent-driven-development/SKILL.md

# Verify changes are in the "Review Subagent's Work" section

git stage-lines 213-280 skills/subagent-driven-development/SKILL.md && \
  git commit -m "feat: add report parsing and concurrent-safe review invocation

Parse commit SHAs and files from subagent report.
Pass to code-reviewer via COMMIT_SHAS/FILES_MODIFIED (not BASE_SHA/HEAD_SHA).
Handle safety check failures (conflicts, missing commits).

Implements Task 3 of concurrent-safe-code-review plan."
```

---

## Task 4: Update Requesting-Code-Review Skill Documentation

**Files:**
- Modify: `skills/requesting-code-review/SKILL.md:1-106`

**Context:**
This skill documents how to request code review. It currently shows BASE_SHA/HEAD_SHA approach. Need to update to show commit-SHA-list approach and explain when to use it.

**Step 1: Update the "How to Request" section**

In `skills/requesting-code-review/SKILL.md`, replace lines 24-42 (the "How to Request" section):

```markdown
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
```

**Step 2: Update the example**

Replace the example section (lines 49-75):

```markdown
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
```

**Step 3: Add section on concurrent safety**

After the "How to Request" section, add a new section:

```markdown
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
```

**Step 4: Update the red flags section**

Update the "Red Flags" section (around line 93-99) to add concurrent-safety warnings:

```markdown
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
```

**Step 5: Commit the documentation updates**

```bash
git diff skills/requesting-code-review/SKILL.md

# Verify changes update "How to Request", example, add concurrent safety section

git stage-lines skills/requesting-code-review/SKILL.md && \
  git commit -m "docs: update requesting-code-review for concurrent-safe approach

Replace BASE_SHA/HEAD_SHA with commit-SHA-list examples.
Add Concurrent Execution Safety section explaining safety model.
Update examples to show new format.
Deprecate BASE_SHA/HEAD_SHA approach.

Implements Task 4 of concurrent-safe-code-review plan."
```

---

## Task 5: Update Agent Description

**Files:**
- Modify: `agents/code-reviewer.md:1-48`

**Context:**
The top-level agent description explains when and how the code-reviewer agent is used. Need to add note about concurrent-safety to the description.

**Step 1: Update agent description frontmatter**

In `agents/code-reviewer.md`, update the description (line 3) to mention concurrent-safety:

```markdown
description: Use this agent when a major project step has been completed and needs to be reviewed against the original plan and coding standards. Concurrent-safe: uses commit-SHA-list approach to avoid conflicts with parallel work. Examples: <example>Context: The user is creating a code-review agent that should be called after a logical chunk of code is written. user: "I've finished implementing the user authentication system as outlined in step 3 of our plan" assistant: "Great work! Now let me use the code-reviewer agent to review the implementation against our plan and coding standards" <commentary>Since a major project step has been completed, use the code-reviewer agent to validate the work against the plan and identify any issues.</commentary></example> <example>Context: User has completed a significant feature implementation. user: "The API endpoints for the task management system are now complete - that covers step 2 from our architecture document" assistant: "Excellent! Let me have the code-reviewer agent examine this implementation to ensure it aligns with our plan and follows best practices" <commentary>A numbered step from the planning document has been completed, so the code-reviewer agent should review the work.</commentary></example>
```

**Step 2: Add concurrent-safety note to agent instructions**

After the initial role description (around line 7), add:

```markdown
You are a Senior Code Reviewer with expertise in software architecture, design patterns, and best practices. Your role is to review completed project steps against original plans and ensure code quality standards are met.

**Concurrent Execution Safety:** You operate in a concurrent environment where multiple agents or humans may be working simultaneously. You use read-only git operations and explicit commit SHAs to avoid interfering with parallel work. You detect and report concurrent modifications to files under review.

When reviewing completed work, you will:
```

**Step 3: Add concurrent modification to issue identification**

In section "5. Issue Identification and Recommendations" (around line 35), update to:

```markdown
5. **Issue Identification and Recommendations**:
   - Clearly categorize issues as: Critical (must fix), Important (should fix), or Suggestions (nice to have)
   - Concurrent modification conflicts are ALWAYS Critical issues
   - For each issue, provide specific examples and actionable recommendations
   - When you identify plan deviations, explain whether they're problematic or beneficial
   - Suggest specific improvements with code examples when helpful
```

**Step 4: Update Communication Protocol**

In section "6. Communication Protocol" (around line 41), add:

```markdown
6. **Communication Protocol**:
   - If you find concurrent modification conflicts, STOP and report immediately with details
   - If you find significant deviations from the plan, ask the coding agent to review and confirm the changes
   - If you identify issues with the original plan itself, recommend plan updates
   - For implementation problems, provide clear guidance on fixes needed
   - Always acknowledge what was done well before highlighting issues
```

**Step 5: Commit the agent description update**

```bash
git diff agents/code-reviewer.md

# Verify concurrent-safety notes added to description, instructions, and protocols

git stage-lines agents/code-reviewer.md && \
  git commit -m "docs: add concurrent-safety notes to code-reviewer agent

Update agent description to mention concurrent-safe operation.
Add note about read-only operations and commit-SHA approach.
Mark concurrent conflicts as Critical issues.

Implements Task 5 of concurrent-safe-code-review plan."
```

---

## Task 6: Create Test Documentation

**Files:**
- Create: `docs/test-cases/concurrent-code-review-test-suite.md`

**Context:**
We've created several test case files throughout the implementation. Now consolidate them into a comprehensive test suite that future maintainers can use to verify concurrent-safety.

**Step 1: Write comprehensive test suite**

Create: `docs/test-cases/concurrent-code-review-test-suite.md`

```markdown
# Concurrent Code Review Test Suite

This document contains test scenarios for verifying the concurrent-safe code review implementation.

## Test 1: Basic Sequential Review (Baseline)

**Scenario:**
1. Task subagent creates 2 commits
2. No concurrent work happens
3. Code reviewer reviews the commits

**Setup:**
```bash
# Create test branch
git checkout -b test-sequential-review

# Make changes and commit
echo "function test() { return 42; }" > src/test.js
git add src/test.js
git commit -m "feat: add test function"

echo "test('basic', () => { assert(test() === 42); });" > tests/test.test.js
git add tests/test.test.js
git commit -m "test: add test for test function"

# Get commit SHAs
git log --oneline -n 2
```

**Expected subagent report:**
```
## Commits Created
- <SHA2> (test: add test for test function)
- <SHA1> (feat: add test function)

## Files Modified
- src/test.js (created)
- tests/test.test.js (created)
```

**Expected code reviewer behavior:**
- Safety checks: ✓ All commits exist
- Safety checks: ✓ No concurrent modifications
- Safety checks: ✓ No uncommitted changes
- Status: Safe to proceed with review
- Reviews both commits successfully

**Verification:**
Working tree unchanged, HEAD unchanged, review completed

---

## Test 2: Benign Concurrent Modification

**Scenario:**
1. Task subagent creates commits modifying `auth.js` lines 10-25
2. Concurrent work creates commit modifying `auth.js` lines 100-120
3. Code reviewer detects concurrent change but classifies as benign

**Setup:**
```bash
git checkout -b test-benign-concurrent

# Task work
cat > src/auth.js <<EOF
// Lines 1-9: existing code
function authenticate(user, pass) {
  // Lines 10-25: task's changes
  if (!user || !pass) {
    throw new Error('Missing credentials');
  }
  return validateCredentials(user, pass);
}
// Lines 26-99: existing code
function helper() {
  // Lines 100-120: will be modified by concurrent work
  return 'helper';
}
EOF

git add src/auth.js
TASK_SHA=$(git commit -m "feat: add authentication validation" | grep -o '[a-f0-9]\{40\}')

# Concurrent work (modify different section)
sed -i '' 's/helper/utilityHelper/g' src/auth.js
git add src/auth.js
git commit -m "refactor: rename helper to utilityHelper"
```

**Expected code reviewer behavior:**
- Safety checks: ✓ All commits exist
- Safety checks: Concurrent changes detected in `src/auth.js`
  - Task modified lines: 10-25
  - Concurrent modified lines: 100-120
  - Classification: BENIGN (no overlap, sufficient distance)
- Note in review: "Concurrent changes detected (non-conflicting)"
- Status: Safe to proceed with review
- Reviews task's commit successfully

**Verification:**
- Code reviewer reports concurrent modification
- Classified as benign
- Review completes
- No Critical issues raised

---

## Test 3: Real Concurrent Conflict

**Scenario:**
1. Task subagent creates commit modifying `auth.js` lines 10-25
2. Concurrent work creates commit modifying `auth.js` lines 15-30
3. Code reviewer detects overlapping changes and flags as REAL CONFLICT

**Setup:**
```bash
git checkout -b test-conflict

# Task work
cat > src/auth.js <<EOF
function authenticate(user, pass) {
  // Lines 10-25: task's changes
  if (!user || !pass) {
    throw new Error('Missing credentials');
  }
  // Lines 20-25: overlap zone
  return validateCredentials(user, pass);
}
EOF

git add src/auth.js
TASK_SHA=$(git commit -m "feat: add authentication validation" | grep -o '[a-f0-9]\{40\}')

# Concurrent work (modify overlapping section, lines 15-30)
cat > src/auth.js <<EOF
function authenticate(user, pass) {
  if (!user || !pass) {
    throw new Error('Missing credentials');
  }
  // Lines 15-30: concurrent changes (overlaps with task's 20-25)
  const validated = validateCredentials(user, pass);
  logAuthAttempt(user);
  return validated;
}
EOF

git add src/auth.js
git commit -m "feat: add auth attempt logging"
```

**Expected code reviewer behavior:**
- Safety checks: ✓ All commits exist
- Safety checks: Concurrent changes detected in `src/auth.js`
  - Task modified lines: 10-25
  - Concurrent modified lines: 15-30
  - Overlapping range: 15-25
  - Classification: REAL CONFLICT
- Status: **SAFETY CHECK FAILED**
- Report: "Concurrent modification conflict detected in src/auth.js"
- Includes both diffs in report
- Stops review, asks user how to proceed

**Verification:**
- Code reviewer STOPS immediately
- Reports Critical issue
- Shows both diffs
- Does not complete review
- No working tree modifications

---

## Test 4: Missing Commit (Amended/Rebased)

**Scenario:**
1. Task subagent creates commit ABC
2. Commit gets amended to ABC' before review
3. Code reviewer can't find ABC, reports error

**Setup:**
```bash
git checkout -b test-missing-commit

# Task work
echo "function test() { return 42; }" > src/test.js
git add src/test.js
ORIGINAL_SHA=$(git commit -m "feat: add test function" | grep -o '[a-f0-9]\{40\}')

# Amend the commit (simulates rebase/amend)
echo "// Added comment" >> src/test.js
git add src/test.js
git commit --amend --no-edit
NEW_SHA=$(git rev-parse HEAD)

# Code reviewer tries to review ORIGINAL_SHA (which no longer exists)
```

**Subagent reports SHA:** $ORIGINAL_SHA

**Expected code reviewer behavior:**
- Safety checks: Try to verify commit $ORIGINAL_SHA
- Run: `git cat-file -t $ORIGINAL_SHA`
- Result: Error "Not a valid object name"
- Status: **SAFETY CHECK FAILED**
- Report: "Commit $ORIGINAL_SHA not found - may have been amended or rebased"
- Includes current HEAD: $NEW_SHA
- Includes recent commits: `git log --oneline -5`
- Stops review, asks user to investigate

**Verification:**
- Code reviewer STOPS immediately
- Reports missing commit error
- Provides diagnostic info
- Does not complete review
- No working tree modifications

---

## Test 5: Uncommitted Changes

**Scenario:**
1. Task subagent creates commit modifying `auth.js`
2. Task subagent makes additional changes to `auth.js` but forgets to commit
3. Code reviewer detects uncommitted changes

**Setup:**
```bash
git checkout -b test-uncommitted

# Task work (committed)
echo "function authenticate() { return true; }" > src/auth.js
git add src/auth.js
TASK_SHA=$(git commit -m "feat: add authentication" | grep -o '[a-f0-9]\{40\}')

# Task work (uncommitted - forgot to commit)
echo "function logout() { return false; }" >> src/auth.js

# Code reviewer runs
```

**Expected code reviewer behavior:**
- Safety checks: ✓ All commits exist
- Safety checks: ✓ No concurrent modifications (HEAD = TASK_SHA)
- Safety checks: Check for uncommitted changes in `src/auth.js`
  - Run: `git diff src/auth.js`
  - Result: Shows uncommitted changes
- Status: Uncommitted changes detected
- Flags as **Important issue** in review:
  ```
  Important: Uncommitted changes in src/auth.js
  - File: src/auth.js:+logout function
  - Issue: Task made changes but didn't commit them
  - Why it matters: Changes aren't versioned, could be lost
  - Fix: Commit all task changes
  ```
- Continues with review (not Critical, but Important)

**Verification:**
- Code reviewer completes review
- Important issue raised about uncommitted changes
- No working tree modifications
- Uncommitted changes still present

---

## Test 6: Multiple Parallel Task Subagents

**Scenario:**
1. Task subagent A modifying `auth.js`, commits
2. Task subagent B modifying `db.js`, commits (parallel)
3. Task subagent C modifying `routes.js`, commits (parallel)
4. Code reviewer A reviews A's commits (should not see B or C's work)
5. Code reviewer B reviews B's commits (should not see A or C's work)
6. Code reviewer C reviews C's commits (should not see A or B's work)

**Setup:**
```bash
git checkout -b test-parallel-tasks

# Task A
echo "auth content" > src/auth.js
git add src/auth.js
SHA_A=$(git commit -m "feat: add auth" | grep -o '[a-f0-9]\{40\}')

# Task B (parallel)
echo "db content" > src/db.js
git add src/db.js
SHA_B=$(git commit -m "feat: add db" | grep -o '[a-f0-9]\{40\}')

# Task C (parallel)
echo "routes content" > src/routes.js
git add src/routes.js
SHA_C=$(git commit -m "feat: add routes" | grep -o '[a-f0-9]\{40\}')
```

**Expected behavior:**

**Reviewer A (reviews SHA_A):**
- Reviews only commit SHA_A
- Sees only `src/auth.js` changes
- Does not see B or C's work in the diff
- Safety checks pass (no concurrent mods to auth.js)

**Reviewer B (reviews SHA_B):**
- Reviews only commit SHA_B
- Sees only `src/db.js` changes
- Detects concurrent modifications: YES (A and C's commits happened)
- Checks if concurrent work touched `src/db.js`: NO
- Safety checks pass (no concurrent mods to db.js)

**Reviewer C (reviews SHA_C):**
- Reviews only commit SHA_C
- Sees only `src/routes.js` changes
- Detects concurrent modifications: YES (A and B's commits happened)
- Checks if concurrent work touched `src/routes.js`: NO
- Safety checks pass (no concurrent mods to routes.js)

**Verification:**
- All three reviewers complete successfully
- Each reviews only their task's commits
- No interference between reviews
- No working tree modifications by any reviewer

---

## Test 7: File Deleted by Concurrent Work

**Scenario:**
1. Task subagent modifies `temp.js`
2. Concurrent work deletes `temp.js`
3. Code reviewer detects file deletion

**Setup:**
```bash
git checkout -b test-file-deleted

# Task work
echo "temp content" > src/temp.js
git add src/temp.js
TASK_SHA=$(git commit -m "feat: add temp feature" | grep -o '[a-f0-9]\{40\}')

# Concurrent work deletes the file
git rm src/temp.js
git commit -m "refactor: remove temp feature"
```

**Expected code reviewer behavior:**
- Safety checks: ✓ All commits exist
- Safety checks: Check concurrent modifications to `src/temp.js`
  - Run: `git diff $TASK_SHA HEAD -- src/temp.js`
  - Result: Entire file deleted
- Status: **SAFETY CHECK FAILED** or **Critical Issue**
- Report: "File src/temp.js deleted by concurrent work - task's changes lost"
- Stops review, asks user how to proceed

**Verification:**
- Code reviewer detects deletion
- Reports as Critical issue
- Provides details about deletion
- No working tree modifications

---

## Test 8: File Renamed by Concurrent Work

**Scenario:**
1. Task subagent modifies `auth.js`
2. Concurrent work renames `auth.js` to `authentication.js`
3. Code reviewer detects file rename

**Setup:**
```bash
git checkout -b test-file-renamed

# Task work
echo "auth content" > src/auth.js
git add src/auth.js
TASK_SHA=$(git commit -m "feat: add auth logic" | grep -o '[a-f0-9]\{40\}')

# Concurrent work renames the file
git mv src/auth.js src/authentication.js
git commit -m "refactor: rename auth.js to authentication.js"
```

**Expected code reviewer behavior:**
- Safety checks: ✓ All commits exist
- Safety checks: Check concurrent modifications to `src/auth.js`
  - Run: `git diff $TASK_SHA HEAD -- src/auth.js`
  - Result: File deleted (renamed)
  - Optional: Run `git log --follow -- src/auth.js` to detect rename
- Status: **Important Issue** (not Critical, but needs attention)
- Report: "File src/auth.js renamed to src/authentication.js - manual verification needed"
- Continues review but flags the rename

**Verification:**
- Code reviewer detects rename (or deletion)
- Reports as Important issue
- Suggests manual verification
- Review may continue or stop depending on implementation

---

## Running the Tests

**Manual verification:**
1. Create test branches for each scenario
2. Follow setup steps
3. Dispatch code-reviewer with test data
4. Verify expected behavior matches actual behavior
5. Document any discrepancies

**Automated verification (future):**
Create shell script that:
1. Sets up each test scenario
2. Invokes code-reviewer
3. Parses output
4. Asserts expected behavior
5. Reports PASS/FAIL for each test

---

## Success Criteria

All tests pass if:
- ✓ Sequential review works (baseline)
- ✓ Benign concurrent changes noted but don't block review
- ✓ Real conflicts detected and block review
- ✓ Missing commits detected and reported
- ✓ Uncommitted changes flagged as Important
- ✓ Parallel reviews don't interfere with each other
- ✓ File deletions detected
- ✓ File renames detected (or flagged as deletion)
- ✓ No working tree modifications in any scenario
- ✓ All git operations are read-only

---

## Regression Testing

After any changes to code-reviewer template or subagent-driven-development:
1. Re-run all 8 test scenarios
2. Verify behavior matches expected
3. Update tests if behavior intentionally changed
4. Document any new edge cases discovered
```

**Step 2: Commit the test suite**

```bash
git add docs/test-cases/concurrent-code-review-test-suite.md

git commit -m "test: add comprehensive concurrent code review test suite

8 test scenarios covering:
- Sequential review (baseline)
- Benign concurrent modifications
- Real concurrent conflicts
- Missing commits (amended/rebased)
- Uncommitted changes detection
- Multiple parallel task subagents
- File deletion by concurrent work
- File rename by concurrent work

Each test includes setup, expected behavior, and verification steps.

Implements Task 6 of concurrent-safe-code-review plan."
```

---

## Task 7: Final Verification and Documentation

**Files:**
- Create: `docs/concurrent-safe-code-review.md` (summary document)
- Modify: `README.md` (add link to new feature)

**Context:**
Implementation is complete. Now create user-facing documentation explaining the concurrent-safety feature and link it from the main README.

**Step 1: Write user-facing documentation**

Create: `docs/concurrent-safe-code-review.md`

```markdown
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
```

**Step 2: Add link to README**

In `README.md`, find the features section or documentation section and add:

```markdown
## Features

- **Concurrent-Safe Code Review** - Review code safely while multiple agents or humans work in parallel. See [Concurrent-Safe Code Review](docs/concurrent-safe-code-review.md) for details.
```

**Step 3: Verify all documentation is consistent**

Check:
- `docs/concurrent-safe-code-review.md` - User-facing docs
- `docs/test-cases/concurrent-code-review-test-suite.md` - Test scenarios
- `skills/requesting-code-review/code-reviewer.md` - Template
- `skills/requesting-code-review/SKILL.md` - Skill docs
- `skills/subagent-driven-development/SKILL.md` - Integration docs
- `agents/code-reviewer.md` - Agent description

All should:
- Use COMMIT_SHAS and FILES_MODIFIED (not BASE_SHA/HEAD_SHA)
- Mention concurrent-safety
- Describe safety checks
- Use read-only git operations

**Step 4: Run mental walkthrough**

Imagine executing the full workflow:
1. Task subagent implements feature, commits, reports with SHAs
2. Orchestrator parses report, extracts SHAs and files
3. Dispatches code-reviewer with COMMIT_SHAS and FILES_MODIFIED
4. Code reviewer runs safety checks (verify commits, detect concurrent mods)
5. If conflict: stops and reports
6. If safe: reviews commits with read-only operations
7. Returns review with safety check results + code quality feedback

Does this flow make sense? Is anything missing?

**Step 5: Commit the documentation**

```bash
git add docs/concurrent-safe-code-review.md README.md

git commit -m "docs: add user-facing concurrent-safe code review documentation

Comprehensive guide explaining:
- The problem with BASE_SHA/HEAD_SHA approach
- How commit-SHA-list approach works
- Safety checks and conflict classification
- Edge cases and limitations
- Usage instructions for subagents, reviewers, and workflow authors

Linked from README.

Implements Task 7 of concurrent-safe-code-review plan."
```

---

## Task 8: Clean Up Test Files

**Files:**
- Delete temporary test case files created during implementation

**Context:**
During Tasks 1-6, we created individual test case files for each component. Now that we have the comprehensive test suite in `docs/test-cases/concurrent-code-review-test-suite.md`, we can delete the individual files to avoid duplication.

**Step 1: List test files to delete**

```bash
ls -la docs/test-cases/

# Expected files to delete:
# - code-reviewer-concurrent-test.md (from Task 1)
# - subagent-report-format-test.md (from Task 2)
# - report-parsing-test.md (from Task 3)
```

**Step 2: Verify content is in comprehensive test suite**

Check that `docs/test-cases/concurrent-code-review-test-suite.md` covers:
- ✓ Concurrent modification scenarios (Test 2, 3)
- ✓ Subagent report format (covered in Test 1)
- ✓ Report parsing (implicitly covered in all tests)
- ✓ Missing commits (Test 4)
- ✓ Uncommitted changes (Test 5)

If anything is missing, add it to the comprehensive test suite first.

**Step 3: Delete individual test files**

```bash
# Only delete if they exist
rm -f docs/test-cases/code-reviewer-concurrent-test.md
rm -f docs/test-cases/subagent-report-format-test.md
rm -f docs/test-cases/report-parsing-test.md
```

**Step 4: Verify docs/test-cases/ directory**

```bash
ls -la docs/test-cases/

# Should contain:
# - concurrent-code-review-test-suite.md (comprehensive suite)
# - (any other existing test files unrelated to this feature)
```

**Step 5: Commit the cleanup**

```bash
git add -A docs/test-cases/

git commit -m "chore: remove duplicate test case files

Removed individual test files created during implementation:
- code-reviewer-concurrent-test.md
- subagent-report-format-test.md
- report-parsing-test.md

All test scenarios are now in concurrent-code-review-test-suite.md.

Implements Task 8 of concurrent-safe-code-review plan."
```

---

## Final Checklist

After completing all 8 tasks, verify:

- ✓ Code reviewer template uses COMMIT_SHAS and FILES_MODIFIED (not BASE_SHA/HEAD_SHA)
- ✓ Task subagent prompt requires structured report with commit SHAs
- ✓ Subagent-driven-development parses reports and invokes reviewer correctly
- ✓ Safety checks run before code review
- ✓ Concurrent modifications detected and classified (real vs. benign)
- ✓ All git operations are read-only (no checkout, reset, restore)
- ✓ Documentation explains concurrent-safety feature
- ✓ Test suite covers all scenarios
- ✓ No duplicate test files
- ✓ All files committed with descriptive messages

## Success Criteria

Implementation is successful if:

1. **Safety:** Code reviewer never modifies working tree
2. **Correctness:** Reviews exact commits task created, not affected by concurrent work
3. **Detection:** Identifies concurrent modifications to same files
4. **Classification:** Distinguishes real conflicts from benign changes
5. **Transparency:** Clear reporting of safety check results
6. **Usability:** Task subagents can easily report SHAs and files
7. **Documentation:** Users understand how concurrent-safety works
8. **Testability:** Test suite covers all edge cases

## Post-Implementation

After implementation:

1. Run manual tests from test suite (Task 6)
2. Test with actual parallel task execution
3. Monitor for edge cases in production use
4. Update documentation based on real-world learnings
5. Consider automating test suite execution
