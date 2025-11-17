# Workflow-Based Skill Restructure and External Skill Integration Implementation Plan

> **For Claude:** Two execution options available:
> - **flows:subagent-driven-development** (Recommended): Fresh subagent per task with code review between tasks
> - **flows:executing-plans** (Alternative): Batched execution with manual checkpoints
>
> Use whichever execution method the user invokes. If user calls /flows:subagents-execution or /flows:gradual-execution, they've chosen executing-plans.

**Goal:** Restructure skills by workflow phases and integrate valuable external skills from spacholski1225/cc-config

**Architecture:** Reorganize flat skill directory into workflow-based phases (00-meta through 07-completion), merge complementary features from external skills, maintain git history through proper mv operations

**Tech Stack:** Bash (git mv), Markdown, Shell scripting

---

## Phase 1: Documentation and Preparation

### Task 1: Create Migration Documentation

**Files:**
- Create: `docs/migration/workflow-restructure.md`

**Step 1: Write the migration guide structure**

```markdown
# Workflow-Based Skill Restructure Migration Guide

## Overview
Migrating from flat skill structure to workflow-based phases (00-meta through 07-completion)

## Old → New Mapping

### 00-meta/
- skills/using-flows/ → 00-meta/using-flows/
- skills/writing-skills/ → 00-meta/writing-skills/
- skills/testing-skills-with-subagents/ → 00-meta/testing-skills-with-subagents/
- skills/sharing-skills/ → 00-meta/sharing-skills/

### 01-understanding/
- skills/codebase-research/ → 01-understanding/codebase-research/
- skills/pattern-discovery/ → 01-understanding/pattern-discovery/
- NEW: 01-understanding/knowledge-lineages/

### 02-planning/
- skills/brainstorming/ → 02-planning/brainstorming/
- skills/writing-plans/ → 02-planning/writing-plans/
- NEW: 02-planning/when-stuck/

### 03-preparation/
- skills/using-git-worktrees/ → 03-preparation/using-git-worktrees/
- skills/defense-in-depth/ → 03-preparation/defense-in-depth/
- NEW: 03-preparation/characterization-testing/

### 04-implementation/
- skills/test-driven-development/ → 04-implementation/test-driven-development/
- skills/subagent-driven-development/ → 04-implementation/subagent-driven-development/
- skills/condition-based-waiting/ → 04-implementation/condition-based-waiting/
- NEW: 04-implementation/strangler-fig-pattern/

### 05-debugging/
- skills/systematic-debugging/ → 05-debugging/systematic-debugging/
- skills/root-cause-tracing/ → 05-debugging/root-cause-tracing/
- skills/dispatching-parallel-agents/ → 05-debugging/dispatching-parallel-agents/

### 06-validation/
- skills/verification-before-completion/ → 06-validation/verification-before-completion/
- skills/requesting-code-review/ → 06-validation/requesting-code-review/
- skills/receiving-code-review/ → 06-validation/receiving-code-review/
- skills/testing-anti-patterns/ → 06-validation/testing-anti-patterns/

### 07-completion/
- skills/finishing-a-development-branch/ → 07-completion/finishing-a-development-branch/
- skills/handoff/ → 07-completion/handoff/

### Special/
- skills/executing-plans/ → executing-plans/ (cross-phase)

## Command Updates Required
- All commands/*.md files need skill path updates
- hooks/session-start.sh needs path update for using-flows
```

**Step 2: Skip committing documentation**

```bash
# Documentation created but not committed per user preference
# Will be available for reference during execution
```

---

## Phase 2: Create New Directory Structure

### Task 2: Create Workflow Phase Directories

**Step 1: Create all phase directories**

```bash
mkdir -p skills/00-meta && \
mkdir -p skills/01-understanding && \
mkdir -p skills/02-planning && \
mkdir -p skills/03-preparation && \
mkdir -p skills/04-implementation && \
mkdir -p skills/05-debugging && \
mkdir -p skills/06-validation && \
mkdir -p skills/07-completion
```

**Step 2: Verify directory creation**

```bash
ls -la skills/ | grep "^d"
```

Expected output: Should show 8 new directories (00-meta through 07-completion) plus existing skill directories

**Step 3: Stage and commit directory structure**

```bash
# Stage only the new directories (no files yet)
git stage-lines skills/00-meta skills/01-understanding skills/02-planning \
  skills/03-preparation skills/04-implementation skills/05-debugging \
  skills/06-validation skills/07-completion && \
  git commit -m "feat: create workflow-based phase directories"
```

---

## Phase 3: Move Meta Skills (00-meta)

### Task 3: Move using-flows to 00-meta

**Step 1: Move skill with git mv to preserve history**

```bash
git mv skills/using-flows skills/00-meta/using-flows
```

**Step 2: Verify move**

```bash
ls -la skills/00-meta/using-flows/
```

Expected: Should show SKILL.md file

**Step 3: Commit the move**

```bash
git commit -m "refactor: move using-flows to 00-meta phase"
```

### Task 4: Move writing-skills to 00-meta

**Step 1: Move skill with git mv**

```bash
git mv skills/writing-skills skills/00-meta/writing-skills
```

**Step 2: Verify move with supporting files**

```bash
ls -la skills/00-meta/writing-skills/
```

Expected: Should show SKILL.md, anthropic-best-practices.md, graphviz-conventions.dot, persuasion-principles.md, examples/

**Step 3: Commit the move**

```bash
git commit -m "refactor: move writing-skills to 00-meta phase"
```

### Task 5: Move testing-skills-with-subagents to 00-meta

**Step 1: Move skill with git mv**

```bash
git mv skills/testing-skills-with-subagents skills/00-meta/testing-skills-with-subagents
```

**Step 2: Verify move**

```bash
ls -la skills/00-meta/testing-skills-with-subagents/
```

Expected: Should show SKILL.md and examples/ directory

**Step 3: Commit the move**

```bash
git commit -m "refactor: move testing-skills-with-subagents to 00-meta phase"
```

### Task 6: Move sharing-skills to 00-meta

**Step 1: Move skill with git mv**

```bash
git mv skills/sharing-skills skills/00-meta/sharing-skills
```

**Step 2: Verify move**

```bash
ls -la skills/00-meta/sharing-skills/
```

Expected: Should show SKILL.md file

**Step 3: Commit the move**

```bash
git commit -m "refactor: move sharing-skills to 00-meta phase"
```

---

## Phase 4: Move Understanding Skills (01-understanding)

### Task 7: Move codebase-research to 01-understanding

**Step 1: Move skill with git mv**

```bash
git mv skills/codebase-research skills/01-understanding/codebase-research
```

**Step 2: Verify move**

```bash
ls -la skills/01-understanding/codebase-research/
```

Expected: Should show SKILL.md file

**Step 3: Commit the move**

```bash
git commit -m "refactor: move codebase-research to 01-understanding phase"
```

### Task 8: Move pattern-discovery to 01-understanding

**Step 1: Move skill with git mv**

```bash
git mv skills/pattern-discovery skills/01-understanding/pattern-discovery
```

**Step 2: Verify move**

```bash
ls -la skills/01-understanding/pattern-discovery/
```

Expected: Should show SKILL.md file

**Step 3: Commit the move**

```bash
git commit -m "refactor: move pattern-discovery to 01-understanding phase"
```

---

## Phase 5: Move Planning Skills (02-planning)

### Task 9: Move brainstorming to 02-planning

**Step 1: Move skill with git mv**

```bash
git mv skills/brainstorming skills/02-planning/brainstorming
```

**Step 2: Verify move**

```bash
ls -la skills/02-planning/brainstorming/
```

Expected: Should show SKILL.md file

**Step 3: Commit the move**

```bash
git commit -m "refactor: move brainstorming to 02-planning phase"
```

### Task 10: Move writing-plans to 02-planning

**Step 1: Move skill with git mv**

```bash
git mv skills/writing-plans skills/02-planning/writing-plans
```

**Step 2: Verify move**

```bash
ls -la skills/02-planning/writing-plans/
```

Expected: Should show SKILL.md file

**Step 3: Commit the move**

```bash
git commit -m "refactor: move writing-plans to 02-planning phase"
```

---

## Phase 6: Move Preparation Skills (03-preparation)

### Task 11: Move using-git-worktrees to 03-preparation

**Step 1: Move skill with git mv**

```bash
git mv skills/using-git-worktrees skills/03-preparation/using-git-worktrees
```

**Step 2: Verify move**

```bash
ls -la skills/03-preparation/using-git-worktrees/
```

Expected: Should show SKILL.md file

**Step 3: Commit the move**

```bash
git commit -m "refactor: move using-git-worktrees to 03-preparation phase"
```

### Task 12: Move defense-in-depth to 03-preparation

**Step 1: Move skill with git mv**

```bash
git mv skills/defense-in-depth skills/03-preparation/defense-in-depth
```

**Step 2: Verify move**

```bash
ls -la skills/03-preparation/defense-in-depth/
```

Expected: Should show SKILL.md file

**Step 3: Commit the move**

```bash
git commit -m "refactor: move defense-in-depth to 03-preparation phase"
```

---

## Phase 7: Move Implementation Skills (04-implementation)

### Task 13: Move test-driven-development to 04-implementation

**Step 1: Move skill with git mv**

```bash
git mv skills/test-driven-development skills/04-implementation/test-driven-development
```

**Step 2: Verify move**

```bash
ls -la skills/04-implementation/test-driven-development/
```

Expected: Should show SKILL.md file

**Step 3: Commit the move**

```bash
git commit -m "refactor: move test-driven-development to 04-implementation phase"
```

### Task 14: Move subagent-driven-development to 04-implementation

**Step 1: Move skill with git mv**

```bash
git mv skills/subagent-driven-development skills/04-implementation/subagent-driven-development
```

**Step 2: Verify move**

```bash
ls -la skills/04-implementation/subagent-driven-development/
```

Expected: Should show SKILL.md file

**Step 3: Commit the move**

```bash
git commit -m "refactor: move subagent-driven-development to 04-implementation phase"
```

### Task 15: Move condition-based-waiting to 04-implementation

**Step 1: Move skill with git mv**

```bash
git mv skills/condition-based-waiting skills/04-implementation/condition-based-waiting
```

**Step 2: Verify move with supporting files**

```bash
ls -la skills/04-implementation/condition-based-waiting/
```

Expected: Should show SKILL.md and polling.py files

**Step 3: Commit the move**

```bash
git commit -m "refactor: move condition-based-waiting to 04-implementation phase"
```

---

## Phase 8: Move Debugging Skills (05-debugging)

### Task 16: Move systematic-debugging to 05-debugging

**Step 1: Move skill with git mv**

```bash
git mv skills/systematic-debugging skills/05-debugging/systematic-debugging
```

**Step 2: Verify move with supporting files**

```bash
ls -la skills/05-debugging/systematic-debugging/
```

Expected: Should show SKILL.md, CREATION-LOG.md, test-*.md files

**Step 3: Commit the move**

```bash
git commit -m "refactor: move systematic-debugging to 05-debugging phase"
```

### Task 17: Move root-cause-tracing to 05-debugging

**Step 1: Move skill with git mv**

```bash
git mv skills/root-cause-tracing skills/05-debugging/root-cause-tracing
```

**Step 2: Verify move with supporting files**

```bash
ls -la skills/05-debugging/root-cause-tracing/
```

Expected: Should show SKILL.md and tracing-example.md files

**Step 3: Commit the move**

```bash
git commit -m "refactor: move root-cause-tracing to 05-debugging phase"
```

### Task 18: Move dispatching-parallel-agents to 05-debugging

**Step 1: Move skill with git mv**

```bash
git mv skills/dispatching-parallel-agents skills/05-debugging/dispatching-parallel-agents
```

**Step 2: Verify move**

```bash
ls -la skills/05-debugging/dispatching-parallel-agents/
```

Expected: Should show SKILL.md file

**Step 3: Commit the move**

```bash
git commit -m "refactor: move dispatching-parallel-agents to 05-debugging phase"
```

---

## Phase 9: Move Validation Skills (06-validation)

### Task 19: Move verification-before-completion to 06-validation

**Step 1: Move skill with git mv**

```bash
git mv skills/verification-before-completion skills/06-validation/verification-before-completion
```

**Step 2: Verify move**

```bash
ls -la skills/06-validation/verification-before-completion/
```

Expected: Should show SKILL.md file

**Step 3: Commit the move**

```bash
git commit -m "refactor: move verification-before-completion to 06-validation phase"
```

### Task 20: Move requesting-code-review to 06-validation

**Step 1: Move skill with git mv**

```bash
git mv skills/requesting-code-review skills/06-validation/requesting-code-review
```

**Step 2: Verify move with supporting files**

```bash
ls -la skills/06-validation/requesting-code-review/
```

Expected: Should show SKILL.md and code-reviewer.md files

**Step 3: Commit the move**

```bash
git commit -m "refactor: move requesting-code-review to 06-validation phase"
```

### Task 21: Move receiving-code-review to 06-validation

**Step 1: Move skill with git mv**

```bash
git mv skills/receiving-code-review skills/06-validation/receiving-code-review
```

**Step 2: Verify move**

```bash
ls -la skills/06-validation/receiving-code-review/
```

Expected: Should show SKILL.md file

**Step 3: Commit the move**

```bash
git commit -m "refactor: move receiving-code-review to 06-validation phase"
```

### Task 22: Move testing-anti-patterns to 06-validation

**Step 1: Move skill with git mv**

```bash
git mv skills/testing-anti-patterns skills/06-validation/testing-anti-patterns
```

**Step 2: Verify move**

```bash
ls -la skills/06-validation/testing-anti-patterns/
```

Expected: Should show SKILL.md file

**Step 3: Commit the move**

```bash
git commit -m "refactor: move testing-anti-patterns to 06-validation phase"
```

---

## Phase 10: Move Completion Skills (07-completion)

### Task 23: Move finishing-a-development-branch to 07-completion

**Step 1: Move skill with git mv**

```bash
git mv skills/finishing-a-development-branch skills/07-completion/finishing-a-development-branch
```

**Step 2: Verify move**

```bash
ls -la skills/07-completion/finishing-a-development-branch/
```

Expected: Should show SKILL.md file

**Step 3: Commit the move**

```bash
git commit -m "refactor: move finishing-a-development-branch to 07-completion phase"
```

### Task 24: Move handoff to 07-completion

**Step 1: Move skill with git mv**

```bash
git mv skills/handoff skills/07-completion/handoff
```

**Step 2: Verify move**

```bash
ls -la skills/07-completion/handoff/
```

Expected: Should show SKILL.md file

**Step 3: Commit the move**

```bash
git commit -m "refactor: move handoff to 07-completion phase"
```

---

## Phase 11: Move Cross-Phase Skill

### Task 25: Move executing-plans to root skills directory

**Step 1: Move skill with git mv**

```bash
git mv skills/executing-plans skills/executing-plans-temp && \
mv skills/executing-plans-temp executing-plans
```

**Step 2: Verify move**

```bash
ls -la executing-plans/
```

Expected: Should show SKILL.md file

**Step 3: Commit the move**

```bash
git stage-lines executing-plans/ && \
  git commit -m "refactor: move executing-plans to cross-phase location"
```

---

## Phase 12: Update References in Commands

### Task 26: Update brainstorm command

**Files:**
- Modify: `commands/brainstorm.md`

**Step 1: Read current file**

```bash
cat commands/brainstorm.md
```

**Step 2: Update skill path**

Replace `skills/brainstorming` with `skills/02-planning/brainstorming`

**Step 3: Parse changed lines and commit**

```bash
# Get exact line numbers of changes
git diff --unified=0 commands/brainstorm.md | grep "^@@"
# Extract line ranges (e.g., if output shows @@ -3,1 +3,1 @@, use line 3)

# Stage precisely and commit (adjust line numbers based on diff output)
git stage-lines 3 commands/brainstorm.md && \
  git commit -m "fix: update brainstorm command for new skill path"
```

### Task 27: Update write-plan command

**Files:**
- Modify: `commands/write-plan.md`

**Step 1: Read current file**

```bash
cat commands/write-plan.md
```

**Step 2: Update skill path**

Replace `skills/writing-plans` with `skills/02-planning/writing-plans`

**Step 3: Parse changed lines and commit**

```bash
# Get exact line numbers of changes
git diff --unified=0 commands/write-plan.md | grep "^@@"
# Stage precisely and commit (adjust line numbers based on diff output)
git stage-lines 3 commands/write-plan.md && \
  git commit -m "fix: update write-plan command for new skill path"
```

### Task 28: Update subagents-execution command

**Files:**
- Modify: `commands/subagents-execution.md`

**Step 1: Read current file**

```bash
cat commands/subagents-execution.md
```

**Step 2: Update skill path**

Replace `skills/subagent-driven-development` with `skills/04-implementation/subagent-driven-development`

**Step 3: Parse changed lines and commit**

```bash
# Get exact line numbers of changes
git diff --unified=0 commands/subagents-execution.md | grep "^@@"
# Stage precisely and commit (adjust line numbers based on diff output)
git stage-lines 3 commands/subagents-execution.md && \
  git commit -m "fix: update subagents-execution command for new skill path"
```

### Task 29: Update gradual-execution command

**Files:**
- Modify: `commands/gradual-execution.md`

**Step 1: Read current file**

```bash
cat commands/gradual-execution.md
```

**Step 2: Update skill path**

Replace references to `executing-plans` skill path

**Step 3: Parse changed lines and commit**

```bash
# Get exact line numbers of changes
git diff --unified=0 commands/gradual-execution.md | grep "^@@"
# Stage precisely and commit (adjust line numbers based on diff output)
git stage-lines 3 commands/gradual-execution.md && \
  git commit -m "fix: update gradual-execution command for new skill path"
```

### Task 30: Update handoff command

**Files:**
- Modify: `commands/handoff.md`

**Step 1: Read current file**

```bash
cat commands/handoff.md
```

**Step 2: Update skill path**

Replace `skills/handoff` with `skills/07-completion/handoff`

**Step 3: Parse changed lines and commit**

```bash
# Get exact line numbers of changes
git diff --unified=0 commands/handoff.md | grep "^@@"
# Stage precisely and commit (adjust line numbers based on diff output)
git stage-lines 3 commands/handoff.md && \
  git commit -m "fix: update handoff command for new skill path"
```

---

## Phase 13: Update Hook References

### Task 31: Update session-start hook

**Files:**
- Modify: `hooks/session-start.sh`

**Step 1: Read current hook file**

```bash
cat hooks/session-start.sh
```

**Step 2: Update using-flows path**

Replace `skills/using-flows/SKILL.md` with `skills/00-meta/using-flows/SKILL.md`

**Step 3: Test the hook still works**

```bash
bash hooks/session-start.sh
```

Expected: Should output the using-flows skill content without errors

**Step 4: Parse changed lines and commit**

```bash
# Get exact line numbers of changes
git diff --unified=0 hooks/session-start.sh | grep "^@@"
# Stage precisely and commit (adjust line numbers based on diff output)
git stage-lines [line-numbers] hooks/session-start.sh && \
  git commit -m "fix: update session-start hook for new using-flows path"
```

---

## Phase 14: Integrate External Skills - Knowledge Lineages

### Task 32: Create knowledge-lineages skill

**Files:**
- Create: `skills/01-understanding/knowledge-lineages/SKILL.md`

**Step 1: Write the skill file**

```markdown
---
name: knowledge-lineages
description: Use when questioning existing approaches or proposing new ones - traces historical context of current approaches to avoid repeating past mistakes and rediscover abandoned solutions
---

# Tracing Knowledge Lineages

## Overview

Before judging current approaches or proposing new ones, trace their lineage to understand the historical context.

**Core principle:** "Before judging current approaches or proposing new ones, trace their lineage."

## When to Use

Apply this skill when:
- Questioning why existing approaches are used
- Considering abandoning current methods
- Evaluating ideas that might be historical revivals
- Declaring something a best practice
- Finding "the old way was obviously wrong" without context

## The Investigation Process

### Phase 1: Decision Archaeology

Search for when and why decisions were made:
- Architecture decision records (ADRs)
- Git history and blame annotations
- Issue/PR discussions
- Documentation evolution
- Team knowledge interviews

**Key questions:**
- When was this approach adopted?
- What problem was it solving?
- What alternatives were considered?
- Who made the decision and why?

### Phase 2: Failed Attempt Analysis

When hearing "we tried X and it didn't work":
- What was the specific context?
- What was the exact failure mode?
- Have conditions changed since then?
- Was the implementation flawed or the idea itself?

### Phase 3: Revival Detection

Identify whether "new" approaches existed previously:
- Search codebase history for similar patterns
- Check deprecated documentation
- Look for removed features in changelogs
- Understand what caused earlier decline
- Assess if resurrection conditions now exist

### Phase 4: Paradigm Shift Mapping

Document transitions between major approaches:
- What was gained in the transition?
- What was lost or sacrificed?
- What lessons were preserved?
- What knowledge was forgotten?

## Search Strategies

**Git Archaeology:**
```bash
# Find when a pattern was introduced
git log -S "pattern" --all

# See evolution of a specific file
git log -p --follow path/to/file

# Find deleted code
git log --diff-filter=D --summary

# Blame with historical context
git blame -w -C -C -C file
```

**Documentation Mining:**
- README history
- CHANGELOG entries
- Migration guides
- Deprecation notices

**Discussion Archaeology:**
- GitHub/GitLab issues
- Pull request conversations
- Slack/Discord archives
- Meeting notes

## Red Flags Indicating Ignorance of History

- "Let's rewrite this" without understanding complexity
- "The old way was obviously wrong" without context
- Dismissing approaches solely for being old
- Adopting approaches solely for being new
- "Nobody remembers why we do this" → investigate!

## When History Can Be Overridden

Valid reasons to change despite history:
1. Context fundamentally changed (new requirements, tools, constraints)
2. Critical lessons were learned that invalidate past reasoning
3. Original reasoning was flawed (now provable)

**Always document why you're overriding history.**

## Integration with Other Skills

**Complements:**
- `codebase-research` - Understand current state before tracing history
- `pattern-discovery` - Find patterns that have historical significance
- `systematic-debugging` - Historical context reveals root causes

## Output Template

When completing knowledge lineage tracing:

```markdown
## Knowledge Lineage Report: [Topic]

### Current Approach
- What: [Current implementation]
- Since: [When adopted]
- Why: [Original reasoning]

### Historical Approaches
1. [Approach 1]: [Years used]
   - Why adopted: [Reasoning]
   - Why abandoned: [Specific issues]
   - Lessons learned: [Key takeaways]

### Failed Attempts
- [Approach X]: [When tried]
  - Failure mode: [Specific issues]
  - Context then: [Conditions]
  - Context now: [What changed]

### Recommendation
Based on historical analysis: [Continue/Modify/Replace]
Reasoning: [Why history supports this]
```
```

**Step 2: Commit the new skill**

```bash
git stage-lines skills/01-understanding/knowledge-lineages/ && \
  git commit -m "feat: add knowledge-lineages skill from external repo"
```

---

## Phase 15: Integrate External Skills - When Stuck

### Task 33: Create when-stuck dispatcher skill

**Files:**
- Create: `skills/02-planning/when-stuck/SKILL.md`

**Step 1: Write the skill file**

```markdown
---
name: when-stuck
description: Use when stuck and unsure which problem-solving technique to apply - diagnostic dispatch tool that routes to appropriate problem-solving technique based on symptoms
---

# When Stuck - Problem-Solving Dispatcher

## Overview

This skill serves as a diagnostic tool for identifying the appropriate problem-solving technique based on your specific type of challenge.

**Core principle:** "Match stuck-symptom to technique"

## When to Use

Deploy this skill when:
- Stuck and unsure which technique applies
- Multiple approaches seem viable
- Previous attempts have failed
- Need systematic problem-solving approach

## Dispatch Matrix

### Symptom → Technique Mapping

| You're Stuck Because... | Use This Technique | Location |
|------------------------|-------------------|----------|
| Code too complex with multiple implementations | Simplification Cascades | See below |
| Conventional solutions falling short | Collision Zone Thinking | See below |
| Same problems recurring across domains | Meta-Pattern Recognition | See below |
| Limited by assumptions | Inversion Exercise | See below |
| Works locally but not at scale | Scale Game | See below |
| Code behaves unexpectedly | @flows:systematic-debugging | `skills/05-debugging/systematic-debugging/` |
| Can't understand existing code | @flows:codebase-research | `skills/01-understanding/codebase-research/` |
| Unsure how to implement | @flows:pattern-discovery | `skills/01-understanding/pattern-discovery/` |

## Embedded Techniques

### Simplification Cascades

**When:** Complexity spiraling with multiple implementations

**Process:**
1. Strip to absolute minimum that still demonstrates issue
2. Add back one element at a time
3. Identify exact point where complexity breaks
4. Refactor at that boundary

### Collision Zone Thinking

**When:** Conventional solutions fall short

**Process:**
1. List all constraints explicitly
2. Identify which constraints conflict
3. Question if all constraints are real
4. Find the "collision zone" where tradeoffs live
5. Make explicit decision about tradeoffs

### Meta-Pattern Recognition

**When:** Recurring issues across domains

**Process:**
1. Abstract problem to its essence
2. Find similar problems in other domains
3. Identify the meta-pattern
4. Apply proven solutions from other domains

### Inversion Exercise

**When:** Limited by current assumptions

**Process:**
1. List current assumptions
2. Invert each assumption
3. Explore what becomes possible
4. Cherry-pick valuable inversions

### Scale Game

**When:** Solution works small but fails large

**Process:**
1. 10x the scale - what breaks?
2. 100x the scale - what's impossible?
3. 1000x the scale - what assumptions fail?
4. Design for the breaking points

## Combination Strategies

Some problems require multiple techniques:

1. **Complex Legacy Code:**
   - Start: @flows:codebase-research
   - Then: Simplification Cascades
   - Finally: @flows:characterization-testing

2. **Performance at Scale:**
   - Start: Scale Game
   - Then: Meta-Pattern Recognition
   - Finally: Collision Zone Thinking

3. **Architectural Decisions:**
   - Start: @flows:knowledge-lineages
   - Then: Inversion Exercise
   - Finally: @flows:brainstorming

## Visual Dispatch Guide

```
                    STUCK?
                      |
        /-------------|-------------\
        |                           |
    Can't Understand           Can't Solve
         |                          |
    /----|----\              /------|------\
    |         |              |             |
  Code     Pattern       Complex      Unexpected
    |         |              |             |
Research  Discovery    Simplification  Debugging
```

## Integration Points

This skill dispatches to:
- @flows:systematic-debugging
- @flows:codebase-research
- @flows:pattern-discovery
- @flows:characterization-testing
- @flows:brainstorming
- @flows:knowledge-lineages

## Next Steps

After identifying technique:
1. Load the recommended skill
2. Read its methodology completely
3. Apply step-by-step
4. If unsuccessful, return here for alternative approach
```

**Step 2: Commit the new skill**

```bash
git stage-lines skills/02-planning/when-stuck/ && \
  git commit -m "feat: add when-stuck dispatcher skill from external repo"
```

---

## Phase 16: Integrate External Skills - Characterization Testing

### Task 34: Create characterization-testing skill

**Files:**
- Create: `skills/03-preparation/characterization-testing/SKILL.md`

**Step 1: Write the skill file**

```markdown
---
name: characterization-testing
description: Use before refactoring legacy code without tests - documents actual behavior as safety net, capturing current behavior including bugs to prevent regressions during refactoring
---

# Characterization Testing

## Overview

Characterization testing documents the actual behavior of legacy code as a safety net before refactoring, not as a specification of correctness.

**Core principle:** "Document what IS, not what SHOULD BE. Fix behavior later, after safety net exists."

**The Iron Law:** "NO REFACTORING WITHOUT CHARACTERIZATION TESTS FIRST"

## When to Use

Apply characterization testing when:
- Legacy code lacks automated tests
- Code's intended behavior is unclear
- Before refactoring critical or risky sections
- Documentation contradicts actual behavior
- You need protection without full understanding

**Don't use when:**
- Code already has comprehensive tests
- Building new features (use TDD instead)
- Code is trivially simple
- Complete rewrite is planned

## The Process (7 Steps)

### Step 1: Identify Target
- Start with a single function or method
- Choose something you need to refactor
- Don't try to test everything at once

### Step 2: Write Failing Test
```python
def test_calculate_discount():
    # Don't know expected output yet
    result = calculate_discount(100, 'GOLD')
    assert result == None  # Placeholder
```

### Step 3: Run and Capture
```bash
# Run test to see actual output
pytest test_legacy.py::test_calculate_discount
# FAILED: AssertionError: assert 85.0 == None
```

### Step 4: Lock In Behavior
```python
def test_calculate_discount():
    # Document actual behavior (even if wrong)
    result = calculate_discount(100, 'GOLD')
    assert result == 85.0  # What it ACTUALLY returns

    # Note: Should be 80.0 (20% discount) but has bug
    # DO NOT FIX YET - document first
```

### Step 5: Add Edge Cases
```python
def test_calculate_discount_edge_cases():
    # Test nulls
    assert calculate_discount(None, 'GOLD') == 0  # Actual behavior

    # Test empty
    assert calculate_discount(100, '') == 100  # No discount

    # Test negative
    assert calculate_discount(-50, 'GOLD') == -42.5  # Bug: applies to negative

    # Test boundaries
    assert calculate_discount(0, 'GOLD') == 0
    assert calculate_discount(999999, 'GOLD') == 849999.15
```

### Step 6: Document Known Issues
```python
def test_calculate_discount_known_bugs():
    """
    Known issues in calculate_discount:
    1. Returns 85 instead of 80 for GOLD (15% vs 20%)
    2. Applies discount to negative amounts
    3. No validation for customer_type
    """
    # These tests document bugs - keep them passing
    assert calculate_discount(100, 'GOLD') == 85.0  # Wrong but actual
    assert calculate_discount(-50, 'GOLD') == -42.5  # Nonsensical

    # Future correct behavior (skip for now)
    @pytest.skip("Document intended behavior")
    def test_calculate_discount_correct():
        assert calculate_discount(100, 'GOLD') == 80.0
        with pytest.raises(ValueError):
            calculate_discount(-50, 'GOLD')
```

### Step 7: Verify Coverage
```bash
# Check test coverage
pytest --cov=legacy_module test_legacy.py
# Ensure main paths covered (aim for 70%+ on legacy)
```

## Key Principles

### Document, Don't Fix

**Wrong approach:**
```python
def test_discount():
    # Fixing bug while writing characterization test
    result = calculate_discount(100, 'GOLD')
    assert result == 80.0  # "Correct" value
```

**Right approach:**
```python
def test_discount():
    # Document actual behavior
    result = calculate_discount(100, 'GOLD')
    assert result == 85.0  # Wrong but actual
    # TODO: Should be 80.0 - fix after refactoring
```

### Test the Whole Stack

Don't mock dependencies in characterization tests:

```python
# BAD: Mocking hides actual behavior
def test_with_mock():
    with mock.patch('database.fetch'):
        result = process_order(123)

# GOOD: Test actual integration
def test_actual_behavior():
    result = process_order(123)  # Real DB call
    assert result.status == 'PENDING'  # Actual result
```

### Capture Side Effects

```python
def test_side_effects():
    # Capture ALL behavior
    before_count = count_log_entries()

    result = process_payment(100)

    # Document main behavior
    assert result == 'SUCCESS'

    # Document side effects
    assert count_log_entries() == before_count + 2  # Logs twice
    assert email_queue_size() == 1  # Sends email
    assert cache.get('last_payment') == 100  # Updates cache
```

## Anti-Patterns to Avoid

### 1. Fixing During Characterization
**Never:** Change code to make "correct" test pass
**Always:** Document actual behavior, fix later

### 2. Excessive Mocking
**Never:** Mock to avoid complexity
**Always:** Test real behavior, including dependencies

### 3. Testing Implementation Details
**Never:** Test private methods directly
**Always:** Test through public interface

### 4. Ignoring Edge Cases
**Never:** Skip "unimportant" edge cases
**Always:** Document all discovered behaviors

## Integration with Other Skills

**Required by:**
- `systematic-debugging` - When debugging untested legacy code
- `strangler-fig-pattern` - Before replacing legacy systems

**Works with:**
- `code-archaeology` - Understand before characterizing
- `test-driven-development` - After characterization, use TDD for new code

## Complete Example

```python
# legacy_calculator.py (code we're characterizing)
def calculate_total(items, customer_type, tax_rate):
    """Legacy function with unclear behavior"""
    subtotal = sum(item['price'] for item in items)

    # Mysterious business logic
    if customer_type == 'VIP':
        discount = 0.15
    elif customer_type == 'GOLD':
        discount = 0.15  # Bug: should be 0.20
    else:
        discount = 0

    discounted = subtotal * (1 - discount)

    # More mysterious logic
    if tax_rate > 0:
        tax = discounted * tax_rate
    else:
        tax = discounted * 0.08  # Default tax?

    return round(discounted + tax, 2)

# test_legacy_calculator.py (characterization tests)
def test_calculate_total_normal_customer():
    """Document actual behavior for normal customer"""
    items = [{'price': 10}, {'price': 20}]

    # With tax rate
    assert calculate_total(items, 'NORMAL', 0.10) == 33.00

    # Without tax rate (uses mysterious default)
    assert calculate_total(items, 'NORMAL', 0) == 32.40

def test_calculate_total_vip_customer():
    """Document VIP discount behavior"""
    items = [{'price': 100}]

    # VIP gets 15% discount
    assert calculate_total(items, 'VIP', 0.10) == 93.50

def test_calculate_total_gold_customer_bug():
    """Document GOLD discount bug"""
    items = [{'price': 100}]

    # GOLD gets 15% (WRONG - should be 20%)
    assert calculate_total(items, 'GOLD', 0.10) == 93.50

    # Document that GOLD == VIP (the bug)
    vip_result = calculate_total(items, 'VIP', 0.10)
    gold_result = calculate_total(items, 'GOLD', 0.10)
    assert vip_result == gold_result  # Bug documented!

def test_calculate_total_edge_cases():
    """Document edge case behavior"""
    # Empty items
    assert calculate_total([], 'NORMAL', 0.10) == 0

    # Negative prices (shouldn't happen but does)
    items = [{'price': -10}]
    assert calculate_total(items, 'NORMAL', 0.10) == -11.00

    # Unknown customer type (treated as NORMAL)
    items = [{'price': 100}]
    assert calculate_total(items, 'UNKNOWN', 0.10) == 110.00

# Skip tests showing intended behavior
@pytest.mark.skip("Future behavior after fixing bugs")
def test_calculate_total_intended():
    items = [{'price': 100}]
    # GOLD should get 20% discount
    assert calculate_total(items, 'GOLD', 0.10) == 88.00

    # Negative prices should raise error
    with pytest.raises(ValueError):
        calculate_total([{'price': -10}], 'NORMAL', 0.10)
```

## Success Criteria

Characterization tests are complete when:
1. ✅ Main execution paths have tests
2. ✅ Edge cases are documented
3. ✅ Known bugs are captured (not fixed)
4. ✅ Tests pass without code changes
5. ✅ Coverage is sufficient for safe refactoring

You can now refactor with confidence, knowing these tests will catch any behavior changes.
```

**Step 2: Commit the new skill**

```bash
git stage-lines skills/03-preparation/characterization-testing/ && \
  git commit -m "feat: add characterization-testing skill from external repo"
```

---

## Phase 17: Integrate External Skills - Strangler Fig Pattern

### Task 35: Create strangler-fig-pattern skill

**Files:**
- Create: `skills/04-implementation/strangler-fig-pattern/SKILL.md`

**Step 1: Write the skill file**

```markdown
---
name: strangler-fig-pattern
description: Use when replacing legacy systems incrementally - safely replaces legacy systems by building new implementations alongside, gradually routing traffic, and eventually removing obsolete code
---

# Strangler Fig Pattern

## Overview

This refactoring approach safely replaces legacy systems incrementally by building new implementations alongside existing code, gradually routing traffic, and eventually removing obsolete code—mirroring how strangler fig trees grow around host trees.

**Core principle:** "Never big-bang rewrite. Replace incrementally with production traffic validating each step."

## When to Use

**Ideal for:**
- Large legacy systems too complex for complete rewrites
- Systems requiring continuous operation during migration
- High-risk migrations where downtime is unaffordable
- Situations requiring production validation before full cutover

**Avoid when:**
- Legacy system is small enough to simply rebuild
- Planned downtime is acceptable
- Legacy and new implementations cannot coexist architecturally
- System has no natural seams for splitting

## The Six-Step Process

### Step 1: Identify a Seam

Find natural architectural boundaries:
- Module boundaries
- API endpoints
- Feature toggles
- Database tables
- Service interfaces

```python
# Example: Payment processing seam
class PaymentProcessor:
    def process_payment(self, amount, method):
        if method == 'credit_card':
            return self._process_credit_card(amount)  # Seam here
        elif method == 'paypal':
            return self._process_paypal(amount)      # And here
```

### Step 2: Add Characterization Tests

**REQUIRED SUB-SKILL:** Use @flows:characterization-testing

Document existing behavior comprehensively:

```python
def test_legacy_payment_behavior():
    """Characterization tests for legacy payment"""
    processor = LegacyPaymentProcessor()

    # Document actual behavior
    assert processor.process_payment(100, 'credit_card') == 'SUCCESS'
    assert processor.process_payment(-10, 'credit_card') == 'SUCCESS'  # Bug!
    assert processor.process_payment(0, 'paypal') == 'ERROR'
```

### Step 3: Create Abstraction Layer

Build a facade that routes between implementations:

```python
class PaymentFacade:
    def __init__(self):
        self.legacy = LegacyPaymentProcessor()
        self.modern = ModernPaymentProcessor()
        self.feature_flags = FeatureFlags()

    def process_payment(self, amount, method):
        # Route based on feature flags
        if self.feature_flags.is_enabled('modern_payments', user_id):
            try:
                return self.modern.process_payment(amount, method)
            except Exception as e:
                # Fallback to legacy on error
                logger.error(f"Modern payment failed: {e}")
                return self.legacy.process_payment(amount, method)
        else:
            return self.legacy.process_payment(amount, method)
```

### Step 4: Implement New Version

Build replacement behind feature flags:

```python
class ModernPaymentProcessor:
    def process_payment(self, amount, method):
        # New implementation with fixes
        if amount <= 0:
            raise ValueError("Amount must be positive")

        if method == 'credit_card':
            return self._process_credit_card_v2(amount)
        elif method == 'paypal':
            return self._process_paypal_v2(amount)
        else:
            raise ValueError(f"Unknown payment method: {method}")
```

### Step 5: Gradually Route Traffic

Execute phased rollout:

```python
# Phase 1: Dark launch (0% traffic, monitoring only)
class DarkLaunchFacade(PaymentFacade):
    def process_payment(self, amount, method):
        # Process with legacy
        legacy_result = self.legacy.process_payment(amount, method)

        # Shadow process with modern (async, non-blocking)
        async_task.delay(
            self.modern.process_payment,
            amount,
            method,
            compare_with=legacy_result
        )

        return legacy_result

# Phase 2: Canary (1% traffic)
feature_flags.set_percentage('modern_payments', 1)

# Phase 3: Gradual ramp-up
# Week 1: 1%
# Week 2: 5%
# Week 3: 25%
# Week 4: 50%
# Week 5: 90%
# Week 6: 100%
```

### Step 6: Remove Legacy Code

After full migration and stability period:

```python
class PaymentProcessor:
    """Final state - legacy removed"""
    def __init__(self):
        self.processor = ModernPaymentProcessor()

    def process_payment(self, amount, method):
        return self.processor.process_payment(amount, method)

# Delete legacy files
# git rm legacy_payment_processor.py
# git rm tests/test_legacy_payment.py
```

## Feature Flag Strategies

### Boolean Flags
```python
if feature_flags.is_enabled('use_new_system'):
    return new_system.process()
else:
    return legacy_system.process()
```

### Percentage Rollout
```python
if feature_flags.percentage_enabled('new_system', user_id, 25):
    # 25% of users get new system
    return new_system.process()
```

### User-Based Rollout
```python
if user_id in feature_flags.get_users('new_system_beta'):
    return new_system.process()
```

### A/B Testing
```python
variant = feature_flags.get_variant('payment_system', user_id)
if variant == 'control':
    return legacy_system.process()
elif variant == 'treatment':
    return new_system.process()
```

## Monitoring Strategy

### Key Metrics to Track

```python
class MigrationMonitor:
    def track_migration(self, user_id, result, system):
        metrics.increment(f'payment.{system}.count')
        metrics.timing(f'payment.{system}.duration', result.duration)

        if result.error:
            metrics.increment(f'payment.{system}.errors')

        # Compare systems
        if system == 'modern':
            legacy_result = self.shadow_legacy_call(...)
            if legacy_result != result:
                metrics.increment('payment.divergence')
                logger.warning(f"System divergence: {legacy_result} vs {result}")
```

### Rollback Triggers

Define automatic rollback conditions:

```python
def should_rollback():
    error_rate = metrics.get('payment.modern.errors') / metrics.get('payment.modern.count')
    latency_p99 = metrics.get_percentile('payment.modern.duration', 99)

    if error_rate > 0.01:  # >1% errors
        return True
    if latency_p99 > 1000:  # >1s P99 latency
        return True

    return False

# Auto-rollback
if should_rollback():
    feature_flags.disable('modern_payments')
    alert_team("Auto-rolled back modern payments")
```

## Database Migration Strategy

### Dual Write Pattern
```python
def save_order(order_data):
    # Write to both databases during migration
    legacy_db.save(order_data)
    new_db.save(transform_for_new_schema(order_data))

def read_order(order_id):
    # Read from legacy, validate against new
    legacy_data = legacy_db.read(order_id)
    new_data = new_db.read(order_id)

    if not equivalent(legacy_data, new_data):
        log_divergence(order_id, legacy_data, new_data)

    return legacy_data  # Still trust legacy during migration
```

### Event Sourcing Bridge
```python
class EventBridge:
    def handle_legacy_change(self, entity):
        # Convert legacy changes to events
        event = self.create_event_from_legacy(entity)
        event_store.append(event)

        # Apply to new system
        new_system.apply_event(event)
```

## Complete Example: API Migration

```python
# Step 1: Identify seam (API endpoints)
# OLD: /api/v1/users
# NEW: /api/v2/users

# Step 2: Characterization tests
def test_v1_user_api():
    response = client.get('/api/v1/users/123')
    assert response.json() == {
        'id': 123,
        'name': 'John',
        'email': 'john@example'  # No .com - bug!
    }

# Step 3: Abstraction layer
class UserAPIRouter:
    def get_user(self, user_id, api_version=None):
        # Determine version
        if api_version == 'v2' or self.should_use_v2(user_id):
            return self.get_user_v2(user_id)
        else:
            return self.get_user_v1(user_id)

    def should_use_v2(self, user_id):
        # Gradual rollout logic
        return feature_flags.percentage_enabled('api_v2', user_id, 10)

# Step 4: New implementation
def get_user_v2(self, user_id):
    user = db.get_user(user_id)
    return {
        'id': user.id,
        'name': user.name,
        'email': user.email + '.com' if '@example' in user.email else user.email,
        'created_at': user.created_at.isoformat(),  # New field
        'version': 'v2'
    }

# Step 5: Gradual routing
@app.route('/api/users/<user_id>')
def user_endpoint(user_id):
    router = UserAPIRouter()

    # Check header for explicit version
    requested_version = request.headers.get('API-Version')

    # Route based on version or rollout
    return router.get_user(user_id, requested_version)

# Step 6: Remove legacy (after 100% rollout + 2 weeks)
# Delete get_user_v1 method
# Delete /api/v1/* routes
# Update documentation
```

## Risk Mitigation

### The Safety Period

**Wait 2-4 weeks at 100% before removing legacy code:**

```python
def can_remove_legacy():
    # Check conditions
    days_at_100 = (datetime.now() - feature_flags.get_100_percent_date('modern_payments')).days
    error_rate = metrics.get_recent('payment.modern.errors', days=7)
    rollback_count = metrics.get('payment.rollbacks', days=30)

    if days_at_100 < 14:
        return False, "Need 14 days at 100%"
    if error_rate > 0.001:
        return False, "Error rate too high"
    if rollback_count > 0:
        return False, "Had rollbacks recently"

    return True, "Safe to remove legacy"
```

### Parallel Run Validation

```python
class ParallelValidator:
    def validate_systems_match(self, input_data):
        legacy_result = legacy_system.process(input_data)
        modern_result = modern_system.process(input_data)

        if legacy_result != modern_result:
            self.log_divergence(input_data, legacy_result, modern_result)

            # Analyze divergence
            if self.is_legacy_bug(legacy_result, modern_result):
                # Modern is correct, legacy had bug
                return modern_result
            else:
                # Unexpected divergence - investigate!
                alert_team(f"Unexpected divergence: {input_data}")
                return legacy_result  # Safe default
```

## Success Criteria

Migration is complete when:
1. ✅ 100% traffic on new system for 2+ weeks
2. ✅ Error rates equal or better than legacy
3. ✅ Performance metrics acceptable
4. ✅ No rollbacks in past 30 days
5. ✅ Legacy code removed and archived
6. ✅ Documentation updated
7. ✅ Feature flags cleaned up

## Integration with Other Skills

**Required:**
- @flows:characterization-testing - Before creating abstraction layer
- @flows:verification-before-completion - Before declaring migration complete

**Recommended:**
- @flows:pattern-discovery - Find similar migrations in codebase
- @flows:knowledge-lineages - Understand why legacy exists
```

**Step 2: Commit the new skill**

```bash
git stage-lines skills/04-implementation/strangler-fig-pattern/ && \
  git commit -m "feat: add strangler-fig-pattern skill from external repo"
```

---

## Phase 18: Enhance Existing Skills

### Task 36: Enhance codebase-research with code-archaeology

**Files:**
- Modify: `skills/01-understanding/codebase-research/SKILL.md`

**Step 1: Read current file to find insertion point**

```bash
cat skills/01-understanding/codebase-research/SKILL.md | head -50
```

**Step 2: Add code-archaeology section after main process**

Add new section "Deep Archaeological Investigation" with 4-phase archaeological process

**Step 3: Run tests to verify skill still works**

```bash
grep -r "codebase-research" commands/
```

**Step 4: Parse changes and commit the enhancement**

```bash
# Get exact line numbers of changes
git diff --unified=0 skills/01-understanding/codebase-research/SKILL.md | grep "^@@"
# Stage precisely and commit (adjust line numbers based on diff output)
git stage-lines [line-numbers] skills/01-understanding/codebase-research/SKILL.md && \
  git commit -m "feat: enhance codebase-research with code-archaeology techniques"
```

### Task 37: Update systematic-debugging to require characterization-testing

**Files:**
- Modify: `skills/05-debugging/systematic-debugging/SKILL.md`

**Step 1: Read current file to find where to add requirement**

```bash
grep -n "REQUIRED SUB-SKILL" skills/05-debugging/systematic-debugging/SKILL.md
```

**Step 2: Add new required sub-skill section**

Add after existing REQUIRED SUB-SKILL sections:
- **characterization-testing** - REQUIRED when debugging untested legacy code (see Phase 1, Step 0)

**Step 3: Add Phase 0 for legacy code without tests**

Insert before Phase 1:

```markdown
### Phase 0: Create Safety Net (For Legacy Code)

**REQUIRED when debugging code without tests:**

**REQUIRED SUB-SKILL:** Use @flows:characterization-testing first

Before attempting to debug untested legacy code:
1. Create characterization tests for the buggy behavior
2. Document current behavior (including the bug)
3. Now you can safely investigate and fix
```

**Step 4: Parse changes and commit the enhancement**

```bash
# Get exact line numbers of changes
git diff --unified=0 skills/05-debugging/systematic-debugging/SKILL.md | grep "^@@"
# Stage precisely and commit (adjust line numbers based on diff output)
git stage-lines [line-numbers] skills/05-debugging/systematic-debugging/SKILL.md && \
  git commit -m "feat: add characterization-testing requirement to systematic-debugging"
```

---

## Phase 19: Update Cross-References

### Task 38: Update using-flows skill for new structure

**Files:**
- Modify: `skills/00-meta/using-flows/SKILL.md`

**Step 1: Read current file**

```bash
cat skills/00-meta/using-flows/SKILL.md | head -100
```

**Step 2: Update all skill paths to new structure**

Replace all `skills/skill-name` references with new paths like `skills/00-meta/skill-name`

**Step 3: Add section about workflow phases**

Add new section explaining the workflow-based organization

**Step 4: Parse changes and commit the update**

```bash
# Get exact line numbers of changes
git diff --unified=0 skills/00-meta/using-flows/SKILL.md | grep "^@@"
# Stage precisely and commit (adjust line numbers based on diff output)
git stage-lines [line-numbers] skills/00-meta/using-flows/SKILL.md && \
  git commit -m "fix: update using-flows for new workflow structure"
```

---

## Phase 20: Final Validation

### Task 39: Test all commands work

**Step 1: Test brainstorm command**

```bash
grep "skills/" commands/brainstorm.md
```

Expected: Should show `skills/02-planning/brainstorming`

**Step 2: Test all other commands**

```bash
for cmd in commands/*.md; do
  echo "=== $cmd ==="
  grep "skills/" "$cmd"
done
```

**Step 3: Verify no broken references**

```bash
grep -r "skills/[^0-9]" --include="*.md" skills/
```

Expected: Should return no results (all paths should have phase numbers)

### Task 40: Create workflow visualization

**Files:**
- Create: `docs/workflow-phases.md`

**Step 1: Create workflow documentation**

```markdown
# Skill Workflow Phases

## Overview
Skills are organized by development lifecycle phases to guide natural workflow progression.

## Phase Structure

```
00-meta/          ← Start here to understand the system
    ↓
01-understanding/ ← Comprehend existing code
    ↓
02-planning/      ← Design and architecture
    ↓
03-preparation/   ← Set up safety nets
    ↓
04-implementation/← Write code
    ↓
05-debugging/     ← Fix issues
    ↓
06-validation/    ← Ensure quality
    ↓
07-completion/    ← Finalize work
```

## Quick Reference

| Phase | Purpose | Key Skills |
|-------|---------|------------|
| 00-meta | Learn the system | using-flows, writing-skills |
| 01-understanding | Analyze code | codebase-research, pattern-discovery, knowledge-lineages |
| 02-planning | Design solutions | brainstorming, writing-plans, when-stuck |
| 03-preparation | Prepare safety | characterization-testing, using-git-worktrees |
| 04-implementation | Build features | test-driven-development, strangler-fig-pattern |
| 05-debugging | Solve problems | systematic-debugging, root-cause-tracing |
| 06-validation | Verify quality | verification-before-completion, requesting-code-review |
| 07-completion | Ship work | finishing-a-development-branch, handoff |

## New Skills from Integration

- **knowledge-lineages** (01): Trace historical context
- **when-stuck** (02): Problem-solving dispatcher
- **characterization-testing** (03): Legacy code safety net
- **strangler-fig-pattern** (04): Incremental replacement

## Enhanced Skills

- **codebase-research**: Now includes code-archaeology techniques
- **systematic-debugging**: Requires characterization-testing for legacy code
```

**Step 2: Skip committing documentation**

```bash
# Documentation created but not committed per user preference
# File available at docs/workflow-phases.md for reference
```

### Task 41: Final cleanup and verification

**Step 1: Verify old skills directory is empty**

```bash
ls -la skills/ | grep -v "^d.*[0-9]" | grep -v "^total" | grep -v "^\."
```

Expected: Should only show executing-plans if it exists, or be empty

**Step 2: Update README if needed**

```bash
grep -n "skills/" README.md
```

Update any references to the old structure

**Step 3: Run final verification**

```bash
# Check all skills are accessible
find skills -name "SKILL.md" -type f | wc -l
```

Expected: Should show 28 skills (24 original + 4 new)

**Step 4: Create final commit**

```bash
# Stage all skill changes (excluding docs/)
git stage-lines skills/ commands/ hooks/ README.md && \
  git commit -m "feat: complete workflow-based restructure with external skill integration

- Reorganized skills into workflow phases (00-meta through 07-completion)
- Integrated 4 valuable skills from external repository
- Enhanced existing skills with complementary features
- Preserved git history through proper migrations
- Updated all references"
```

---

## Execution Summary

This plan restructures your skills library into workflow-based phases and integrates valuable external skills:

**Structure Changes:**
- 8 workflow phases from 00-meta to 07-completion
- Skills organized by development lifecycle
- Natural progression through phases

**New Skills Added:**
- knowledge-lineages: Historical context tracing
- when-stuck: Problem-solving dispatcher
- characterization-testing: Legacy code safety net
- strangler-fig-pattern: Incremental system replacement

**Enhanced Skills:**
- codebase-research: Added code-archaeology techniques
- systematic-debugging: Added characterization-testing requirement

**Total Tasks:** 41 bite-sized tasks
**Estimated Time:** 2-3 hours with subagent execution
**Commits:** 41 atomic commits preserving history