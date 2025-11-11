---
name: subagent-driven-development
description: Use when executing implementation plans with independent tasks in the current session - dispatches fresh subagent for each task with code review between tasks, enabling fast iteration with quality gates
---

# Subagent-Driven Development

Execute plan by dispatching fresh subagent per task, with code review after each.

**Core principle:** Fresh subagent per task + review between tasks = high quality, fast iteration

## Overview

**vs. Executing Plans (parallel session):**
- Same session (no context switch)
- Fresh subagent per task (no context pollution)
- Code review after each task (catch issues early)
- Faster iteration (no human-in-loop between tasks)

**When to use:**
- Staying in this session
- Tasks are mostly independent
- Want continuous progress with quality gates

**When NOT to use:**
- Need to review plan first (use executing-plans)
- Tasks are tightly coupled (manual execution better)
- Plan needs revision (brainstorm first)

## The Process

### Manual Testing Detection

Before executing each task, the skill checks for manual testing keywords in the task description:

**Keywords:** "manually test", "manual testing", "verify in browser", "test manually", "user testing", "manual verification", "check manually", "test in production", "verify with user", "manual check"

**When detected:**
- Pause execution
- Present testing options to user (manual vs. automated)
- Collect feedback and resolve issues before continuing

**Applies to:** Only tasks explicitly marked with manual testing keywords (not all testing tasks)

### 1. Load Plan

Read plan file, create TodoWrite with all tasks.

### 2. Execute Task with Subagent

For each task:

**Check for manual testing:**

If task description contains manual testing keywords:
1. Mark task as in_progress
2. Present task description
3. Ask user: "How should we test this?" (AskUserQuestion)
   - Option A: "I'll test it manually"
   - Option B: "Use browser automation"
4. Follow manual testing workflow (see Step 2a below)
5. After issues resolved, mark complete and continue to next task

**Otherwise, dispatch fresh subagent:**
```
Task tool (general-purpose):
  description: "Implement Task N: [task name]"
  prompt: |
    You are implementing Task N from [plan-file].

    Read that task carefully. Your job is to:
    1. Implement exactly what the task specifies
    2. Write tests (following TDD if task says to)
    3. Verify implementation works
    4. Commit your work
    5. Report back

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

    Report: What you implemented, what you tested, test results, files changed, any issues
```

**Subagent reports back** with summary of work.

### 2a. Manual Testing Workflow

**When manual testing task detected:**

**Step 1: Collect Feedback**

Based on user's choice:

**Manual Testing Path:**
- Say: "Please test and describe what worked and what didn't."
- Wait for user's conversational feedback

**Automated Testing Path:**
- Dispatch testing subagent:
  ```
  Task tool (general-purpose):
    description: "Automated testing for Task N"
    prompt: |
      You are performing automated browser testing for Task N from [plan].

      Use the superpowers-chrome:browsing skill to:
      1. Navigate to the feature
      2. Perform the test steps described in the task
      3. Test across viewports if UI-related (desktop/mobile)
      4. Document what worked and what issues you found

      Task description: [task text]

      Report back with conversational feedback like a human tester would.
  ```
- Collect feedback from testing subagent

**Step 2: Parse Feedback**

Analyze feedback to extract:
- Overall status (pass vs. issues found)
- Discrete issues with descriptions
- Severity from language cues

If no issues: Mark task complete, continue to next task.

**Step 3: Investigate Root Causes (Parallel)**

If issues found:
1. List extracted issues clearly
2. Dispatch one investigation subagent per issue in parallel:
   ```
   Task tool (general-purpose):
     description: "Investigate Issue N: [issue description]"
     prompt: |
       Investigate this issue from manual testing:

       Issue: [issue description]
       Context: [task description]
       User feedback: [relevant excerpt]

       Your job:
       1. Find the root cause
       2. Propose 2-3 solution approaches with trade-offs
       3. Return findings

       Report format:
       Root Cause: [what's causing this]
       Solution A: [approach] - [trade-offs]
       Solution B: [approach] - [trade-offs]
       Solution C: [approach] - [trade-offs]
   ```

**Step 4: Present Solutions**

For each issue, use AskUserQuestion:
- Question: "How should we fix [Issue N: description]?"
- Header: "Issue N fix"
- multiSelect: false
- Options: 2-3 solution approaches from investigation subagent

**Step 5: Implement Fixes**

After all solutions chosen:
1. Determine if fixes are independent or dependent
2. Dispatch fix subagents:
   - If independent: dispatch in parallel
   - If dependent: dispatch sequentially
   ```
   Task tool (general-purpose):
     description: "Fix Issue N: [issue description]"
     prompt: |
       Fix this issue from manual testing:

       Issue: [issue description]
       Chosen solution: [selected approach]
       Root cause: [from investigation]

       Implement the fix, test it, and commit your work.
   ```

**Step 6: Review Fixes**

Dispatch code-reviewer for all fixes (same as Step 3)

**Step 7: Handle Review Feedback**

If Critical/Important issues in review:
- Dispatch fix subagent to address
- Re-run code review
- Only mark complete when review passes

**Error Handling:**

- If fix subagent fails: Report to user, re-investigate, present new solutions
- If feedback ambiguous: Show interpretation, ask user to confirm/clarify
- If user wants to skip: Mark task as "deferred", continue, remind at final review
- Multiple rounds: After fixes, ask "Ready for another round of testing?" (max 3 rounds)

### 3. Review Subagent's Work

**Dispatch code-reviewer subagent:**
```
Task tool (flows:code-reviewer):
  Use template at requesting-code-review/code-reviewer.md

  WHAT_WAS_IMPLEMENTED: [from subagent's report]
  PLAN_OR_REQUIREMENTS: Task N from [plan-file]
  BASE_SHA: [commit before task]
  HEAD_SHA: [current commit]
  DESCRIPTION: [task summary]
```

**Code reviewer returns:** Strengths, Issues (Critical/Important/Minor), Assessment

### 4. Apply Review Feedback

**If issues found:**
- Fix Critical issues immediately
- Fix Important issues before next task
- Note Minor issues

**Dispatch follow-up subagent if needed:**
```
"Fix issues from code review: [list issues]"
```

### 5. Mark Complete, Next Task

- Mark task as completed in TodoWrite
- Move to next task
- Repeat steps 2-5

### 6. Final Review

After all tasks complete, dispatch final code-reviewer:
- Reviews entire implementation
- Checks all plan requirements met
- Validates overall architecture

### 7. Complete Development

After final review passes:
- Announce: "I'm using the finishing-a-development-branch skill to complete this work."
- **REQUIRED SUB-SKILL:** Use flows:finishing-a-development-branch
- Follow that skill to verify tests, present options, execute choice

## Example Workflow

```
You: I'm using Subagent-Driven Development to execute this plan.

[Load plan, create TodoWrite]

Task 1: Hook installation script

[Dispatch implementation subagent]
Subagent: Implemented install-hook with tests, 5/5 passing

[Get git SHAs, dispatch code-reviewer]
Reviewer: Strengths: Good test coverage. Issues: None. Ready.

[Mark Task 1 complete]

Task 2: Recovery modes

[Dispatch implementation subagent]
Subagent: Added verify/repair, 8/8 tests passing

[Dispatch code-reviewer]
Reviewer: Strengths: Solid. Issues (Important): Missing progress reporting

[Dispatch fix subagent]
Fix subagent: Added progress every 100 conversations

[Verify fix, mark Task 2 complete]

...

[After all tasks]
[Dispatch final code-reviewer]
Final reviewer: All requirements met, ready to merge

Done!
```

### Example with Manual Testing (Manual Path)

```
Task 3: Manually test the login flow in browser

Skill: This is a manual testing task: "Manually test the login flow in browser"
       How should we test this?
       A) I'll test it manually
       B) Use browser automation

User: A) I'll test it manually

Skill: Please test and describe what worked and what didn't.

User: Tried it out. Login works but the error message for wrong password
      is cut off on mobile and the redirect after login is slow.

Skill: I found these issues:
       1. Error message cut off on mobile
       2. Slow redirect after login

       Investigating root causes... [dispatches 2 parallel subagents]

Investigation subagent 1:
  Root Cause: Error message uses fixed width (320px), overflows on small viewports
  Solution A: Add text wrapping (quick, may look cramped)
  Solution B: Shorten message text (requires copy changes)
  Solution C: Use responsive width with max-width (best UX, standard approach)

Investigation subagent 2:
  Root Cause: Redirect waits for full session sync (500ms average)
  Solution A: Optimistic redirect, sync in background (faster UX, standard pattern)
  Solution B: Parallel sync operations (complex, minimal gain)
  Solution C: Lazy sync non-critical data (requires refactor)

Skill: How should we fix Issue 1: Error message cut off on mobile?
       A) Add text wrapping
       B) Shorten message text
       C) Use responsive width with max-width

User: C

Skill: How should we fix Issue 2: Slow redirect after login?
       A) Optimistic redirect, sync in background
       B) Parallel sync operations
       C) Lazy sync non-critical data

User: A

Skill: Implementing fixes... [dispatches 2 parallel fix subagents]

Fix subagent 1: Changed error container to use responsive width with max-width
Fix subagent 2: Implemented optimistic redirect with background session sync

Skill: [Runs code review on fixes]
Reviewer: Both fixes look good. Issue 1 follows responsive design patterns.
          Issue 2 properly handles sync errors. No issues found.

Skill: Task 3 completed. Moving to Task 4...
```

### Example with Manual Testing (Automated Path)

```
Task 5: Manually verify the checkout flow works end-to-end

Skill: This is a manual testing task: "Manually verify the checkout flow"
       How should we test this?
       A) I'll test it manually
       B) Use browser automation

User: B) Use browser automation

Skill: Testing with browser automation... [dispatches testing subagent]

Testing subagent:
  Used superpowers-chrome:browsing to test checkout flow.

  Tested: Add to cart → proceed to checkout → fill shipping → payment → confirm

  Issues found:
  1. Shipping form submit button disabled when all fields valid (desktop Chrome)
  2. Payment section shows "Loading..." indefinitely after selecting saved card

Skill: I found these issues:
       1. Shipping form submit button disabled incorrectly
       2. Payment section stuck on "Loading..." with saved cards

       Investigating root causes... [dispatches 2 parallel subagents]

[Investigation and fix workflow continues as in manual path example...]
```

## Advantages

**vs. Manual execution:**
- Subagents follow TDD naturally
- Fresh context per task (no confusion)
- Parallel-safe (subagents don't interfere)

**vs. Executing Plans:**
- Same session (no handoff)
- Continuous progress (no waiting)
- Review checkpoints automatic

**Cost:**
- More subagent invocations
- But catches issues early (cheaper than debugging later)

## Red Flags

**Never:**
- Skip code review between tasks
- Proceed with unfixed Critical issues
- Dispatch multiple implementation subagents in parallel (conflicts)
- Implement without reading plan task
- Skip manual testing tasks without user permission
- Implement fixes without investigating root cause first
- Present solutions without giving user choice

**If subagent fails task:**
- Dispatch fix subagent with specific instructions
- Don't try to fix manually (context pollution)

**For manual testing:**
- Always ask user whether to test manually or use automation
- Always investigate root cause before proposing fixes
- Always present solution options via AskUserQuestion
- Don't guess at solutions - let investigation subagents analyze first

## Integration

**Required workflow skills:**
- **writing-plans** - REQUIRED: Creates the plan that this skill executes
- **requesting-code-review** - REQUIRED: Review after each task (see Step 3)
- **finishing-a-development-branch** - REQUIRED: Complete development after all tasks (see Step 7)

**Subagents must use:**
- **test-driven-development** - Subagents follow TDD for each task

**Optional for manual testing:**
- **superpowers-chrome:browsing** - For automated browser testing option

**Alternative workflow:**
- **executing-plans** - Use for parallel session instead of same-session execution

See code-reviewer template: requesting-code-review/code-reviewer.md
