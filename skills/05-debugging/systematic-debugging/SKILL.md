---
name: systematic-debugging
description: Use when encountering any bug, test failure, or unexpected behavior, before proposing fixes - four-phase framework (root cause investigation, pattern analysis, hypothesis testing, implementation) that ensures understanding before attempting solutions
---

# Systematic Debugging

## Overview

Random fixes waste time and create new bugs. Quick patches mask underlying issues.

**Core principle:** ALWAYS find root cause before attempting fixes. Symptom fixes are failure.

**Violating the letter of this process is violating the spirit of debugging.**

## The Iron Law

```
NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST
```

If you haven't completed Phase 1, you cannot propose fixes.

## When to Use

Use for ANY technical issue:
- Test failures
- Bugs in production
- Unexpected behavior
- Performance problems
- Build failures
- Integration issues

**Use this ESPECIALLY when:**
- Under time pressure (emergencies make guessing tempting)
- "Just one quick fix" seems obvious
- You've already tried multiple fixes
- Previous fix didn't work
- You don't fully understand the issue

**Don't skip when:**
- Issue seems simple (simple bugs have root causes too)
- You're in a hurry (rushing guarantees rework)
- Manager wants it fixed NOW (systematic is faster than thrashing)

## The Four Phases

You MUST complete each phase before proceeding to the next.

### Phase 0: Create Safety Net (For Legacy Code)

**REQUIRED when debugging code without tests:**

**REQUIRED SUB-SKILL:** Use flows:characterization-testing first

Before attempting to debug untested legacy code:
1. Create characterization tests for the buggy behavior
2. Document current behavior (including the bug)
3. Now you can safely investigate and fix

**Why this is mandatory:**
- Without tests, you cannot verify the fix works
- Without tests, you cannot prevent regressions
- Characterization tests capture current behavior as baseline
- Once you have tests, you can refactor safely

**Skip Phase 0 only if:**
- Code already has comprehensive test coverage
- You are debugging a test failure (tests already exist)

### Phase 1: Root Cause Investigation

**BEFORE attempting ANY fix:**

#### Step 1: Multi-Domain Exploration (MANDATORY)

**Dispatch 2-3 Explore agents IN PARALLEL** for comprehensive discovery:

**Agent 1 - Error Source Discovery:**

Use Task tool:
```python
subagent_type = "Explore"
model = "haiku"
prompt = """
Explore to find where [error/bug] originates:
1. Search for error messages, stack traces, logged errors
2. Find all locations where [problematic behavior] occurs
3. Identify entry points and trigger conditions
4. Locate error handling code related to this issue

**CRITICAL:** Do NOT create temporary files (/tmp, docs/, etc).
Aggregate all findings in memory and return complete report in your final message.
All results must appear in function_results - no file creation.

Return: File paths, line numbers, function names, error flow

Thoroughness: very thorough
"""
```

**Consuming Agent 1 Results (Error Source Discovery):**

After Task tool returns, error source report appears in function_results.

**Read and extract:**
- Error messages and locations → Note all file:line references
- Stack traces → Understand error propagation path
- Entry points and trigger conditions → Identify what causes error
- Error handling code → Locate related error handling

**Use for Phase 2:**
- Form root cause hypothesis using error flow and triggers
- Identify instrumentation targets using file:line references
- Plan Phase 3 investigation focusing on trigger conditions

**Agent 2 - Related Component Discovery:**

```python
subagent_type = "Explore"
model = "haiku"
prompt = """
Explore to map components related to [feature/module with bug]:
1. Find all components that interact with [problematic code]
2. Identify data flow: inputs, transformations, outputs
3. Locate configuration, environment variables, dependencies
4. Find tests covering this area (passing or failing)

**CRITICAL:** Do NOT create temporary files (/tmp, docs/, etc).
Aggregate all findings in memory and return complete report in your final message.
All results must appear in function_results - no file creation.

Return: Component map, data flow diagram, configuration locations

Thoroughness: very thorough
"""
```

**Consuming Agent 2 Results (Related Component Discovery):**

After Task tool returns, component map appears in function_results.

**Read and extract:**
- Component interactions → Understand what talks to what
- Data flow diagram → Map inputs → transformations → outputs
- Configuration locations → Note all config file:line references
- Test coverage → Identify which tests cover this area

**Use for Phase 2:**
- Expand root cause hypothesis with component interactions
- Identify additional instrumentation points from component map
- Plan comprehensive fix covering all related components

**Agent 3 - Pattern & History Discovery (Optional):**

```python
subagent_type = "Explore"
model = "haiku"
prompt = """
Explore for similar bugs or patterns:
1. Search for similar error messages or behavior in codebase
2. Find TODO/FIXME comments related to this area
3. Identify workarounds or temporary fixes in place
4. Look for code comments explaining edge cases

**CRITICAL:** Do NOT create temporary files (/tmp, docs/, etc).
Aggregate all findings in memory and return complete report in your final message.
All results must appear in function_results - no file creation.

Return: Similar issues found, relevant comments, workarounds

Thoroughness: medium
"""
```

**Consuming Agent 3 Results (Pattern & History Discovery):**

After Task tool returns, similar issues report appears in function_results.

**Read and extract:**
- Similar error messages → Check if known issue
- TODO/FIXME comments → Understand known problems in area
- Workarounds → Identify temporary fixes already in place
- Edge case comments → Learn about known edge cases

**Use for Phase 2:**
- Refine hypothesis based on similar issues found
- Check if existing workarounds provide clues
- Avoid duplicate debugging if issue already understood

**Verification pattern:**
If findings conflict, dispatch additional targeted Explore agents to clarify specific contradictions.

**Use findings for:**
- Accurate root cause hypothesis in Phase 2
  - Agent 1: Error flow and triggers
  - Agent 2: Component interactions
  - Agent 3: Similar issues and workarounds
- Comprehensive instrumentation targets in Phase 3
  - Agent 1: Error location file:line references
  - Agent 2: Component boundary file:line references
- Complete fix coverage in Phase 4
  - Agent 2: All related components identified
  - Agent 3: Existing workarounds to formalize

2. **Read Error Messages Carefully**
   - Don't skip past errors or warnings
   - They often contain the exact solution
   - Read stack traces completely
   - Note line numbers, file paths, error codes

3. **Reproduce Consistently**
   - Can you trigger it reliably?
   - What are the exact steps?
   - Does it happen every time?
   - If not reproducible → gather more data, don't guess

4. **Check Recent Changes**
   - What changed that could cause this?
   - Git diff, recent commits
   - New dependencies, config changes
   - Environmental differences

5. **Gather Evidence in Multi-Component Systems**

   **WHEN system has multiple components (CI → build → signing, API → service → database):**

   **BEFORE proposing fixes, add diagnostic instrumentation:**
   ```
   For EACH component boundary:
     - Log what data enters component
     - Log what data exits component
     - Verify environment/config propagation
     - Check state at each layer

   Run once to gather evidence showing WHERE it breaks
   THEN analyze evidence to identify failing component
   THEN investigate that specific component
   ```

   **Example (multi-layer system):**
   ```bash
   # Layer 1: Workflow
   echo "=== Secrets available in workflow: ==="
   echo "IDENTITY: ${IDENTITY:+SET}${IDENTITY:-UNSET}"

   # Layer 2: Build script
   echo "=== Env vars in build script: ==="
   env | grep IDENTITY || echo "IDENTITY not in environment"

   # Layer 3: Signing script
   echo "=== Keychain state: ==="
   security list-keychains
   security find-identity -v

   # Layer 4: Actual signing
   codesign --sign "$IDENTITY" --verbose=4 "$APP"
   ```

   **This reveals:** Which layer fails (secrets → workflow ✓, workflow → build ✗)

6. **Trace Data Flow**

   **WHEN error is deep in call stack:**

   **REQUIRED SUB-SKILL:** Use flows:root-cause-tracing for backward tracing technique

   **Quick version:**
   - Where does bad value originate?
   - What called this with bad value?
   - Keep tracing up until you find the source
   - Fix at source, not at symptom

### Phase 2: Pattern Analysis

**Find the pattern before fixing:**

1. **Find Working Examples**
   - Locate similar working code in same codebase
   - What works that's similar to what's broken?

2. **Compare Against References**
   - If implementing pattern, read reference implementation COMPLETELY
   - Don't skim - read every line
   - Understand the pattern fully before applying
   - **INVOKE WEB-RESEARCHER WHEN** reference is in external documentation:
     - Official library documentation (current version needed)
     - Framework guides (may have updated since training)
     - External codebases (GitHub repositories)
     - API specifications (OpenAPI, GraphQL schemas)
     - Search for: official docs, example repositories, migration guides

3. **Identify Differences**
   - What's different between working and broken?
   - List every difference, however small
   - Don't assume "that can't matter"

4. **Understand Dependencies**
   - What other components does this need?
   - What settings, config, environment?
   - What assumptions does it make?

### Phase 3: Hypothesis and Testing

**Scientific method:**

1. **Form Single Hypothesis**
   - State clearly: "I think X is the root cause because Y"
   - Write it down
   - Be specific, not vague

2. **Test Minimally**
   - Make the SMALLEST possible change to test hypothesis
   - One variable at a time
   - Don't fix multiple things at once

3. **Verify Before Continuing**
   - Did it work? Yes → Phase 4
   - Didn't work? Form NEW hypothesis
   - DON'T add more fixes on top

4. **When You Don't Know**
   - Say "I don't understand X"
   - Don't pretend to know
   - Ask for help
   - Research more
   - **INVOKE WEB-RESEARCHER IF ISSUE INVOLVES:**
     - Unfamiliar libraries/frameworks beyond training data
     - Error messages from tools not in training corpus
     - Modern API changes or deprecations
     - Platform-specific behaviors
     - Search for: official documentation, Stack Overflow solutions, GitHub issues, release notes

### Phase 4: Implementation

**Fix the root cause, not the symptom:**

1. **Create Failing Test Case**
   - Simplest possible reproduction
   - Automated test if possible
   - One-off test script if no framework
   - MUST have before fixing
   - **REQUIRED SUB-SKILL:** Use flows:test-driven-development for writing proper failing tests

2. **Implement Single Fix**
   - Address the root cause identified
   - ONE change at a time
   - No "while I'm here" improvements
   - No bundled refactoring

3. **Verify Fix**
   - Test passes now?
   - No other tests broken?
   - Issue actually resolved?

4. **If Fix Doesn't Work**
   - STOP
   - Count: How many fixes have you tried?
   - If < 3: Return to Phase 1, re-analyze with new information
   - **If ≥ 3: STOP and question the architecture (step 5 below)**
   - DON'T attempt Fix #4 without architectural discussion

5. **If 3+ Fixes Failed: Question Architecture**

   **Pattern indicating architectural problem:**
   - Each fix reveals new shared state/coupling/problem in different place
   - Fixes require "massive refactoring" to implement
   - Each fix creates new symptoms elsewhere

   **STOP and question fundamentals:**
   - Is this pattern fundamentally sound?
   - Are we "sticking with it through sheer inertia"?
   - Should we refactor architecture vs. continue fixing symptoms?

   **Discuss with your human partner before attempting more fixes**

   This is NOT a failed hypothesis - this is a wrong architecture.

## Red Flags - STOP and Follow Process

If you catch yourself thinking:
- "Quick fix for now, investigate later"
- "Just try changing X and see if it works"
- "Add multiple changes, run tests"
- "Skip the test, I'll manually verify"
- "It's probably X, let me fix that"
- "I don't fully understand but this might work"
- "Pattern says X but I'll adapt it differently"
- "Here are the main problems: [lists fixes without investigation]"
- Proposing solutions before tracing data flow
- **"One more fix attempt" (when already tried 2+)**
- **Each fix reveals new problem in different place**

**ALL of these mean: STOP. Return to Phase 1.**

**If 3+ fixes failed:** Question the architecture (see Phase 4.5)

## your human partner's Signals You're Doing It Wrong

**Watch for these redirections:**
- "Is that not happening?" - You assumed without verifying
- "Will it show us...?" - You should have added evidence gathering
- "Stop guessing" - You're proposing fixes without understanding
- "Ultrathink this" - Question fundamentals, not just symptoms
- "We're stuck?" (frustrated) - Your approach isn't working

**When you see these:** STOP. Return to Phase 1.

## Common Rationalizations

| Excuse | Reality |
|--------|---------|
| "Issue is simple, don't need process" | Simple issues have root causes too. Process is fast for simple bugs. |
| "Emergency, no time for process" | Systematic debugging is FASTER than guess-and-check thrashing. |
| "Just try this first, then investigate" | First fix sets the pattern. Do it right from the start. |
| "I'll write test after confirming fix works" | Untested fixes don't stick. Test first proves it. |
| "Multiple fixes at once saves time" | Can't isolate what worked. Causes new bugs. |
| "Reference too long, I'll adapt the pattern" | Partial understanding guarantees bugs. Read it completely. |
| "I see the problem, let me fix it" | Seeing symptoms ≠ understanding root cause. |
| "One more fix attempt" (after 2+ failures) | 3+ failures = architectural problem. Question pattern, don't fix again. |

## Quick Reference

| Phase | Key Activities | Success Criteria |
|-------|---------------|------------------|
| **1. Root Cause** | Read errors, reproduce, check changes, gather evidence | Understand WHAT and WHY |
| **2. Pattern** | Find working examples, compare | Identify differences |
| **3. Hypothesis** | Form theory, test minimally | Confirmed or new hypothesis |
| **4. Implementation** | Create test, fix, verify | Bug resolved, tests pass |

## When Process Reveals "No Root Cause"

If systematic investigation reveals issue is truly environmental, timing-dependent, or external:

1. You've completed the process
2. Document what you investigated
3. Implement appropriate handling (retry, timeout, error message)
4. Add monitoring/logging for future investigation

**But:** 95% of "no root cause" cases are incomplete investigation.

## Integration with Other Skills

**This skill requires using:**
- **root-cause-tracing** - REQUIRED when error is deep in call stack (see Phase 1, Step 5)
- **test-driven-development** - REQUIRED for creating failing test case (see Phase 4, Step 1)

**Complementary skills:**
- **defense-in-depth** - Add validation at multiple layers after finding root cause
- **condition-based-waiting** - Replace arbitrary timeouts identified in Phase 2
- **verification-before-completion** - Verify fix worked before claiming success

## Real-World Impact

From debugging sessions:
- Systematic approach: 15-30 minutes to fix
- Random fixes approach: 2-3 hours of thrashing
- First-time fix rate: 95% vs 40%
- New bugs introduced: Near zero vs common
