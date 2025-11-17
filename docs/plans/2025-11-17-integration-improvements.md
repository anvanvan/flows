# Integration Improvements Implementation Plan

> **For Claude:** Two execution options available:
> - **flows:subagent-driven-development** (Recommended): Fresh subagent per task with code review between tasks
> - **flows:executing-plans** (Alternative): Batched execution with manual checkpoints
>
> Use whichever execution method the user invokes. If user calls /flows:subagents-execution or /flows:gradual-execution, they've chosen executing-plans.

**Goal:** Fix structural inconsistencies and improve skill discoverability in the flows plugin

**Architecture:** Fix executing-plans location to match flat skill structure, standardize cross-reference notation across skills, fix YAML formatting issues, and add documentation for agent invocation patterns and skill dependencies

**Tech Stack:** Markdown, YAML, Bash (git operations), existing flows plugin structure

---

## Task 1: Move executing-plans to skills/ Directory

**Files:**
- Move: `/Users/tuan/tools/flows/executing-plans/` → `/Users/tuan/tools/flows/skills/executing-plans/`
- Modify: `/Users/tuan/tools/flows/commands/gradual-execution.md`
- Modify: `/Users/tuan/tools/flows/README.md`

**Step 1: Verify current location**

Run: `ls -la /Users/tuan/tools/flows/executing-plans/SKILL.md`
Expected: File exists at this location

**Step 2: Move directory to skills/**

```bash
mv /Users/tuan/tools/flows/executing-plans /Users/tuan/tools/flows/skills/executing-plans
```

**Step 3: Verify move succeeded**

Run: `ls -la /Users/tuan/tools/flows/skills/executing-plans/SKILL.md`
Expected: File exists at new location

Run: `ls -la /Users/tuan/tools/flows/executing-plans/`
Expected: Directory does not exist (or "No such file or directory")

**Step 4: Update gradual-execution command reference (if needed)**

Read: `/Users/tuan/tools/flows/commands/gradual-execution.md`
Check: Does it reference the old path explicitly?
If yes: Update path reference to new location
If no: No changes needed (skills are referenced by name, not path)

**Step 5: Verify all references still work**

Run: `grep -r "executing-plans" /Users/tuan/tools/flows/README.md /Users/tuan/tools/flows/commands/ /Users/tuan/tools/flows/skills/`
Expected: References use skill name (not absolute paths) OR are updated to new path

**Step 6: Commit the move**

```bash
# Git automatically tracks the move
git add -A && \
  git commit -m "fix: move executing-plans to skills/ for structural consistency

Moves executing-plans from root to skills/ directory to match the flat
skill structure pattern used by all other 27 skills.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"
```

---

## Task 2: Standardize @flows: Notation in systematic-debugging

**Files:**
- Modify: `/Users/tuan/tools/flows/skills/systematic-debugging/SKILL.md`

**Step 1: Read current cross-references**

Read: `/Users/tuan/tools/flows/skills/systematic-debugging/SKILL.md`
Find: All prose references to other skills (characterization-testing, root-cause-tracing, test-driven-development, condition-based-waiting, defense-in-depth, pattern-discovery)

**Step 2: Identify lines needing @flows: notation**

Extract approximate line numbers where skill names appear without @flows: prefix

Expected findings:
- "Use characterization-testing" → should be "Use @flows:characterization-testing"
- "root-cause-tracing" → should be "@flows:root-cause-tracing"
- Similar for test-driven-development, condition-based-waiting, defense-in-depth, pattern-discovery

**Step 3: Parse precise line numbers**

```bash
# Find exact lines mentioning skills without @flows: prefix
grep -n "characterization-testing\|root-cause-tracing\|test-driven-development\|condition-based-waiting\|defense-in-depth\|pattern-discovery" /Users/tuan/tools/flows/skills/systematic-debugging/SKILL.md | grep -v "@flows:"
```

**Step 4: Update references to use @flows: notation**

For each skill reference found:
- If in prose text: Add @flows: prefix
- If in REQUIRED SUB-SKILL section: Ensure @flows: prefix exists
- If in Integration Points section: Ensure @flows: prefix exists

Example changes:
```markdown
# Before:
Use characterization-testing to document current behavior

# After:
Use @flows:characterization-testing to document current behavior
```

**Step 5: Verify changes**

```bash
# Verify all cross-references now use @flows: notation
grep -n "characterization-testing\|root-cause-tracing\|test-driven-development\|condition-based-waiting\|defense-in-depth\|pattern-discovery" /Users/tuan/tools/flows/skills/systematic-debugging/SKILL.md
```

Expected: All skill names prefixed with @flows:

**Step 6: Parse changed lines and commit**

```bash
# Parse changed lines from git diff
git diff --unified=0 /Users/tuan/tools/flows/skills/systematic-debugging/SKILL.md | grep "^@@"

# VERIFY: Review changes
git diff /Users/tuan/tools/flows/skills/systematic-debugging/SKILL.md | head -50

# Stage precisely and commit
git stage-lines <parsed-lines> /Users/tuan/tools/flows/skills/systematic-debugging/SKILL.md && \
  git commit -m "docs: standardize @flows: notation in systematic-debugging

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"
```

---

## Task 3: Standardize @flows: Notation in Other Skills

**Files:**
- Modify: `/Users/tuan/tools/flows/skills/root-cause-tracing/SKILL.md`
- Modify: `/Users/tuan/tools/flows/skills/finishing-a-development-branch/SKILL.md`
- Modify: `/Users/tuan/tools/flows/skills/using-git-worktrees/SKILL.md`
- Modify: `/Users/tuan/tools/flows/skills/strangler-fig-pattern/SKILL.md`

**Step 1: Find all skill cross-references without @flows:**

```bash
# Search for skill names mentioned without @flows: prefix
for skill_dir in /Users/tuan/tools/flows/skills/*/; do
  skill=$(basename "$skill_dir")
  echo "=== Checking $skill ==="
  grep -l "defense-in-depth\|finishing-a-development-branch\|using-git-worktrees\|verification-before-completion\|pattern-discovery\|knowledge-lineages\|characterization-testing" "$skill_dir/SKILL.md" 2>/dev/null | grep -v "@flows:" || echo "  No prose references found"
done
```

**Step 2: Update root-cause-tracing**

Read: `/Users/tuan/tools/flows/skills/root-cause-tracing/SKILL.md`
Find: References to "defense-in-depth" without @flows: prefix
Update: Add @flows: prefix to all skill references

```bash
# Parse and commit
git diff --unified=0 /Users/tuan/tools/flows/skills/root-cause-tracing/SKILL.md | grep "^@@"
git diff /Users/tuan/tools/flows/skills/root-cause-tracing/SKILL.md | head -50
git stage-lines <parsed-lines> /Users/tuan/tools/flows/skills/root-cause-tracing/SKILL.md && \
  git commit -m "docs: standardize @flows: notation in root-cause-tracing

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"
```

**Step 3: Update finishing-a-development-branch**

Read: `/Users/tuan/tools/flows/skills/finishing-a-development-branch/SKILL.md`
Find: Skill references without @flows: prefix
Update: Add @flows: prefix

```bash
git diff --unified=0 /Users/tuan/tools/flows/skills/finishing-a-development-branch/SKILL.md | grep "^@@"
git diff /Users/tuan/tools/flows/skills/finishing-a-development-branch/SKILL.md | head -50
git stage-lines <parsed-lines> /Users/tuan/tools/flows/skills/finishing-a-development-branch/SKILL.md && \
  git commit -m "docs: standardize @flows: notation in finishing-a-development-branch

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"
```

**Step 4: Update using-git-worktrees**

Read: `/Users/tuan/tools/flows/skills/using-git-worktrees/SKILL.md`
Find: Skill references without @flows: prefix
Update: Add @flows: prefix

```bash
git diff --unified=0 /Users/tuan/tools/flows/skills/using-git-worktrees/SKILL.md | grep "^@@"
git diff /Users/tuan/tools/flows/skills/using-git-worktrees/SKILL.md | head -50
git stage-lines <parsed-lines> /Users/tuan/tools/flows/skills/using-git-worktrees/SKILL.md && \
  git commit -m "docs: standardize @flows: notation in using-git-worktrees

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"
```

**Step 5: Verify strangler-fig-pattern already uses @flows:**

Read: `/Users/tuan/tools/flows/skills/strangler-fig-pattern/SKILL.md`
Check: Does it already use @flows: notation for characterization-testing, verification-before-completion, pattern-discovery, knowledge-lineages?
If yes: No changes needed
If no: Update and commit

---

## Task 4: Fix testing-skills-with-subagents YAML

**Files:**
- Modify: `/Users/tuan/tools/flows/skills/testing-skills-with-subagents/SKILL.md`

**Step 1: Read current YAML header**

Read: `/Users/tuan/tools/flows/skills/testing-skills-with-subagents/SKILL.md` (lines 1-10)
Identify: Duplicate description fields

Expected:
```yaml
---
name: testing-skills-with-subagents
description: <first description>
description: <second description>
---
```

**Step 2: Determine correct description**

Compare the two description values
Select: The more complete/accurate description (typically the second one, as it may be an update)

**Step 3: Remove duplicate field**

Edit file to keep only one description field:
```yaml
---
name: testing-skills-with-subagents
description: Use when creating or editing skills, before deployment, to verify they work under pressure and resist rationalization - applies RED-GREEN-REFACTOR cycle to process documentation by running baseline without skill, writing to address failures, iterating to close loopholes
---
```

**Step 4: Verify YAML parses correctly**

Test: Parse YAML header manually or with tool
Expected: Valid YAML with name + description only

**Step 5: Parse and commit**

```bash
# Parse changed lines
git diff --unified=0 /Users/tuan/tools/flows/skills/testing-skills-with-subagents/SKILL.md | grep "^@@"

# VERIFY changes
git diff /Users/tuan/tools/flows/skills/testing-skills-with-subagents/SKILL.md | head -20

# Stage and commit
git stage-lines <parsed-lines> /Users/tuan/tools/flows/skills/testing-skills-with-subagents/SKILL.md && \
  git commit -m "fix: remove duplicate description field in YAML header

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"
```

---

## Task 5: Create Agent Invocation Pattern Documentation

**Files:**
- Create: `/Users/tuan/tools/flows/docs/agent-invocation-patterns.md`

**Step 1: Create documentation file structure**

Write: `/Users/tuan/tools/flows/docs/agent-invocation-patterns.md`

```markdown
# Agent Invocation Patterns

## Overview

This document explains when and how to invoke agents in the flows plugin. Agents can be triggered through multiple mechanisms, and understanding which to use improves efficiency and integration.

---

## Agent Types

### 1. Explore Agent
- **Type:** `subagent_type = "Explore"`
- **Model:** haiku (cost-effective)
- **Purpose:** Codebase exploration, architecture discovery, pattern finding
- **Invocation:** Task tool only (programmatic)

### 2. Code-Reviewer Agent
- **Type:** `flows:code-reviewer`
- **Model:** sonnet
- **Purpose:** Review implementations against requirements
- **Invocation:** Task tool only (via requesting-code-review skill)

### 3. Web-Researcher Agent
- **Type:** `flows:web-researcher` or `@agent-web-researcher`
- **Model:** sonnet
- **Purpose:** Research current docs, APIs, best practices
- **Invocation:** Hook-based (automatic) or manual

### 4. General-Purpose Agent
- **Type:** `subagent_type = "general-purpose"`
- **Purpose:** Task implementation, issue fixing
- **Invocation:** Task tool (via subagent-driven-development)

---

## Invocation Mechanisms

### Hook-Based Invocation (Automatic)

**When it triggers:**
- SessionStart hook: Injects using-flows skill automatically
- UserPromptSubmit hook: Detects research keywords and suggests web-researcher

**Keywords that trigger web-researcher:**
- "research online..."
- "web search for..."
- "search the web..."
- "look up online..."
- "find information about..."

**Advantages:**
- Zero manual effort
- Consistent triggering
- Contextual awareness

**When to use:**
- Let hooks handle SessionStart (using-flows) automatically
- Let hooks detect research needs when user asks questions

**Example:**
```
User: "Look up the latest React 18 hooks API"
Hook: Auto-triggers web-researcher agent
```

---

### Manual Invocation (Explicit)

**Syntax:** `@agent-<agent-name>`

**When to use:**
- Override hook behavior (force web-researcher when keywords don't match)
- Explicit control over timing
- User specifically requests agent by name

**Example:**
```markdown
Use @agent-web-researcher to verify the current Vite configuration syntax
```

**Advantages:**
- Precise control
- Clear intent in documentation
- Works when hooks don't trigger

---

### Task Tool Invocation (Programmatic)

**Syntax:**
```python
Task tool:
  subagent_type = "Explore"  # or "general-purpose", "flows:code-reviewer"
  model = "haiku"             # or "sonnet"
  prompt = "..."
```

**When to use:**
- Within skills that need to dispatch agents
- Parallel agent execution
- Structured result consumption

**Examples:**

**Explore Agent:**
```python
subagent_type = "Explore"
model = "haiku"
prompt = """
Explore codebase architecture...

**CRITICAL:** Do NOT create temporary files (/tmp, docs/, etc).
Aggregate all findings in memory and return complete report in your final message.
All results must appear in function_results - no file creation.

Thoroughness: very thorough
"""
```

**Code-Reviewer Agent:**
```python
subagent_type = "flows:code-reviewer"
model = "sonnet"
prompt = "[Full review specification from requesting-code-review/code-reviewer.md]"
```

**Advantages:**
- Programmatic control
- Result consumption patterns (function_results)
- Parallel dispatch support

---

## Decision Matrix: Which Invocation to Use

| Scenario | Use This | Why |
|----------|----------|-----|
| Need using-flows at session start | Hook-based (automatic) | SessionStart hook handles it |
| User asks to research something | Hook-based (automatic) | UserPromptSubmit hook detects keywords |
| Forcing web research without triggers | Manual (@agent-web-researcher) | Override hook behavior |
| Within skill: need Explore agent | Task tool (programmatic) | Structured result consumption |
| Within skill: need code review | Task tool (flows:code-reviewer) | Programmatic dispatch |
| Parallel agent execution | Task tool (programmatic) | Multiple Task calls in sequence |

---

## Result Consumption Patterns

See `/Users/tuan/tools/flows/docs/task-tool-mechanics.md` for full details.

**Pattern 1: Narrative (Explore agents)**
- Read function_results directly as narrative report
- Extract sections matching requested structure
- 90% of agent invocations

**Pattern 2: Structured Parsing (Implementation agents)**
- Parse specific fields from function_results
- Extract commit SHAs, file paths, issue descriptions
- Validate extracted data

**Pattern 3: Parallel Dispatch (Multiple agents)**
- Correlate results by dispatch order
- Synthesize findings from multiple agents
- Used in codebase-research, handoff, systematic-debugging

---

## Best Practices

1. **Let hooks work first** - Don't manually invoke agents that hooks handle automatically
2. **Use Task tool in skills** - For programmatic control and result consumption
3. **Verify thoroughness level** - "very thorough" vs "medium" affects depth
4. **Always consume from function_results** - Never create /tmp files
5. **Parallel when possible** - Dispatch 3-5 Explore agents in parallel for speed
6. **Single agent in_progress** - Only one Task tool invocation should be in_progress at a time in TodoWrite

---

## Examples from Skills

**Codebase Research (5 parallel Explore agents):**
```python
# Agent 1 - Architecture
subagent_type = "Explore"
model = "haiku"
prompt = "Explore architecture..."

# Agent 2 - Implementation
subagent_type = "Explore"
model = "haiku"
prompt = "Explore core features..."

# ... (3 more agents)
```

**Requesting Code Review (Code-Reviewer agent):**
```python
subagent_type = "flows:code-reviewer"
model = "sonnet"
prompt = "[Full specification from code-reviewer.md template]"
```

**Web Research (Manual invocation in brainstorming):**
```markdown
Before proposing approaches, use @agent-web-researcher to verify:
- Current framework best practices
- API syntax and examples
- Integration patterns
```

---

## Integration with Skills

**Skills that auto-invoke agents:**
- using-flows (injected via SessionStart hook)
- All skills with Explore dispatches (16 total)
- requesting-code-review (code-reviewer agent)
- brainstorming (optional web-researcher)
- writing-plans (optional web-researcher)

**See also:**
- `/Users/tuan/tools/flows/docs/task-tool-mechanics.md` - Result consumption patterns
- `/Users/tuan/tools/flows/agents/code-reviewer.md` - Code reviewer specification
- `/Users/tuan/tools/flows/agents/web-researcher.md` - Web researcher specification
```

**Step 2: Verify file created**

Run: `ls -la /Users/tuan/tools/flows/docs/agent-invocation-patterns.md`
Expected: File exists

**Step 3: Commit**

```bash
git add /Users/tuan/tools/flows/docs/agent-invocation-patterns.md && \
  git commit -m "docs: add agent invocation pattern guide

Explains when to use hook-based, manual, and Task tool invocations
for Explore, Code-Reviewer, Web-Researcher, and General-Purpose agents.

Includes decision matrix, best practices, and examples from existing skills.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"
```

---

## Task 6: Create Skill Dependency Index

**Files:**
- Create: `/Users/tuan/tools/flows/docs/skill-dependency-index.md`

**Step 1: Create dependency index file**

Write: `/Users/tuan/tools/flows/docs/skill-dependency-index.md`

```markdown
# Skill Dependency Index

## Overview

This index maps all skill dependencies and cross-references in the flows plugin, showing which skills use or reference other skills.

**Last Updated:** 2025-11-17

---

## Critical Dependency Chains

### Content Creation → Implementation
```
@flows:brainstorming
  → @flows:writing-plans
    → @flows:subagent-driven-development
      → @flows:requesting-code-review
        → @flows:finishing-a-development-branch
```

### Debugging → Understanding → Fix
```
@flows:systematic-debugging
  → (Phase 0) @flows:characterization-testing
  → (Phase 1) @flows:root-cause-tracing
  → (Phase 4) @flows:test-driven-development
```

### Legacy Migration
```
@flows:characterization-testing
  → @flows:strangler-fig-pattern
    → @flows:verification-before-completion
```

### Codebase Understanding → Pattern Discovery → Implementation
```
@flows:codebase-research
  → @flows:pattern-discovery
    → @flows:brainstorming
      → @flows:writing-plans
```

---

## Skill-by-Skill Dependencies

### Entry Point Skills

**using-flows**
- Entry point for all workflows
- Recommends: @flows:codebase-research, @flows:pattern-discovery
- Invokes: @agent-web-researcher (via documentation)

**when-stuck**
- Dispatcher skill
- Routes to:
  - @flows:systematic-debugging
  - @flows:codebase-research
  - @flows:pattern-discovery
  - @flows:characterization-testing
  - @flows:brainstorming
  - @flows:knowledge-lineages

---

### Design & Planning Skills

**brainstorming**
- Pre-recommends: @flows:pattern-discovery
- Required sub-skills:
  - @flows:writing-plans
  - @flows:subagent-driven-development
- Invokes: @agent-web-researcher (optional)

**writing-plans**
- Required sub-skills:
  - @flows:subagent-driven-development
  - @flows:executing-plans (alternative)
- Invokes: @agent-web-researcher (optional for tech stack)
- Dispatches: Explore agents for architecture

---

### Execution Skills

**subagent-driven-development**
- Required sub-skills:
  - @flows:writing-plans (creates the plan)
  - @flows:requesting-code-review (review after each task)
  - @flows:finishing-a-development-branch (completion)
- Dispatches: Explore agents (context), general-purpose agents (tasks), code-reviewer agents (review)
- Task subagents must use: @flows:test-driven-development

**executing-plans**
- Alternative to subagent-driven-development
- Required sub-skill: @flows:finishing-a-development-branch
- Dispatches: Explore agents (plan context)

**finishing-a-development-branch**
- Called by: @flows:subagent-driven-development, @flows:executing-plans
- Dispatches: Explore agents (cleanup detection)
- Pairs with: @flows:using-git-worktrees (cleanup)

---

### Debugging & Analysis Skills

**systematic-debugging**
- Required sub-skills:
  - (Phase 0) @flows:characterization-testing
  - (Phase 1) @flows:root-cause-tracing
  - (Phase 4) @flows:test-driven-development
- Invokes: @agent-web-researcher (unfamiliar libraries)
- Dispatches: 2-3 Explore agents in parallel
- Complements: @flows:condition-based-waiting, @flows:defense-in-depth, @flows:pattern-discovery

**root-cause-tracing**
- Referenced by: @flows:systematic-debugging
- Complements: @flows:defense-in-depth (add layers after finding root cause)
- Dispatches: Explore agents (call chain discovery)

**defense-in-depth**
- Complements: @flows:root-cause-tracing
- Dispatches: 3-4 Explore agents (layer discovery)

---

### Testing Skills

**test-driven-development**
- Pre-requisite for: @flows:writing-skills, @flows:testing-skills-with-subagents
- Referenced by: @flows:subagent-driven-development (subagents use TDD)
- Dispatches: Explore agents (test pattern discovery)

**characterization-testing**
- Required by: @flows:systematic-debugging, @flows:strangler-fig-pattern
- Complements: @flows:knowledge-lineages (understand before characterizing)

**testing-anti-patterns**
- Reference skill (what NOT to do)
- Complements: @flows:test-driven-development, @flows:testing-skills-with-subagents

**condition-based-waiting**
- Complements: @flows:systematic-debugging (replace arbitrary timeouts)

---

### Codebase Understanding Skills

**codebase-research**
- Pre-requisite for: pattern discovery, architectural understanding
- Integrates with: @flows:pattern-discovery
- Dispatches: 5 Explore agents in parallel
- Optional Phase 4: @flows:knowledge-lineages techniques

**pattern-discovery**
- Integration with: @flows:brainstorming, @flows:writing-plans, @flows:test-driven-development, @flows:subagent-driven-development
- Dispatches: Explore agents, 2-3 verification agents if needed

**knowledge-lineages**
- Complements: @flows:codebase-research, @flows:pattern-discovery, @flows:systematic-debugging
- Referenced in: @flows:when-stuck combination strategies

---

### Code Review Skills

**requesting-code-review**
- Dispatches: @flows:code-reviewer subagent
- Pre-verification: Explore agents (completeness)
- Referenced by: @flows:subagent-driven-development

**receiving-code-review**
- Standalone complement to @flows:requesting-code-review
- Invokes: @agent-web-researcher (verify claims)

---

### Refactoring Skills

**strangler-fig-pattern**
- Required sub-skills:
  - @flows:characterization-testing (Step 2)
  - @flows:verification-before-completion
- Recommended: @flows:pattern-discovery, @flows:knowledge-lineages

---

### Meta Skills (Skill Management)

**writing-skills**
- Required background: @flows:test-driven-development
- Required sub-skill: @flows:testing-skills-with-subagents
- Foundational references: @flows:systematic-debugging

**testing-skills-with-subagents**
- Required background: @flows:test-driven-development
- Used by: @flows:writing-skills

**sharing-skills**
- Required: @flows:writing-skills (must use TDD)

---

### Workflow Skills

**using-git-worktrees**
- Integration: @flows:finishing-a-development-branch (cleanup)
- Dispatches: Explore agents (structure discovery after creation)

**verification-before-completion**
- Referenced by: all completion workflows
- Dispatches: Explore agents (command discovery)

**dispatching-parallel-agents**
- Pattern documentation skill
- Complements: all skills using parallel Explore agents

**handoff**
- Context bridge between sessions
- Dispatches: 3 Explore agents in parallel

---

## Agent Integration Summary

### Skills Using Explore Agents (16 total)
- @flows:brainstorming
- @flows:codebase-research (5 parallel)
- @flows:defense-in-depth (3-4 sequential)
- @flows:executing-plans
- @flows:finishing-a-development-branch
- @flows:handoff (3 parallel)
- @flows:pattern-discovery
- @flows:requesting-code-review
- @flows:root-cause-tracing
- @flows:subagent-driven-development
- @flows:systematic-debugging (2-3 parallel)
- @flows:test-driven-development
- @flows:using-git-worktrees
- @flows:verification-before-completion
- @flows:writing-plans
- @flows:writing-skills

### Skills Using Code-Reviewer Agent (2 total)
- @flows:requesting-code-review
- @flows:subagent-driven-development

### Skills Using Web-Researcher Agent (5 total)
- @flows:using-flows
- @flows:brainstorming
- @flows:writing-plans
- @flows:systematic-debugging
- @flows:receiving-code-review

---

## Orphaned Skills (Specialized, Not in Main Chains)

These skills are specialized tools for specific contexts, not part of primary workflow chains:

- @flows:receiving-code-review - Standalone complement to requesting-code-review
- @flows:condition-based-waiting - Utility skill for timing issues
- @flows:testing-anti-patterns - Reference/learning material
- @flows:dispatching-parallel-agents - Pattern documentation
- @flows:using-git-worktrees - Workspace isolation tool
- @flows:sharing-skills - Contributing skills upstream
- @flows:handoff - Context bridge between sessions
- @flows:executing-plans - Alternative execution model

**Note:** "Orphaned" does not mean unused - these skills serve specific purposes outside the main workflow chains.

---

## Circular Dependencies

**Result:** NONE FOUND

The skill dependency graph is acyclic. All dependencies flow cleanly:
- Entry: @flows:using-flows
- Decision: @flows:when-stuck
- Design: @flows:brainstorming
- Planning: @flows:writing-plans
- Execution: @flows:subagent-driven-development
- Verification: @flows:verification-before-completion, @flows:requesting-code-review
- Completion: @flows:finishing-a-development-branch

---

## Cross-Skill Communication Points

1. **Planning Handoff**: @flows:brainstorming → @flows:writing-plans (design → tasks)
2. **Execution Handoff**: @flows:writing-plans → @flows:subagent-driven-development (plan → implementation)
3. **Review Handoff**: @flows:subagent-driven-development → @flows:requesting-code-review (code → verification)
4. **Completion Handoff**: @flows:subagent-driven-development → @flows:finishing-a-development-branch (ready → finish)
5. **Understanding Handoff**: @flows:codebase-research → @flows:pattern-discovery (codebase → patterns)
6. **Debugging Handoff**: @flows:systematic-debugging → @flows:root-cause-tracing (investigation → tracing)

---

## Summary Statistics

- **Total skills**: 27
- **Skills with required sub-skills**: 10
- **Skills that dispatch Explore agents**: 16
- **Skills that use code-reviewer**: 2
- **Skills that use web-researcher**: 5
- **Longest dependency chain**: 5 steps (brainstorming → writing-plans → subagent-driven-development → requesting-code-review → finishing-a-development-branch)
- **Skills with circular dependencies**: 0
- **Fully orphaned skills**: 0

---

## See Also

- `/Users/tuan/tools/flows/docs/agent-invocation-patterns.md` - How to invoke agents
- `/Users/tuan/tools/flows/docs/task-tool-mechanics.md` - Result consumption patterns
- `/Users/tuan/tools/flows/README.md` - Main documentation
```

**Step 2: Verify file created**

Run: `ls -la /Users/tuan/tools/flows/docs/skill-dependency-index.md`
Expected: File exists

**Step 3: Commit**

```bash
git add /Users/tuan/tools/flows/docs/skill-dependency-index.md && \
  git commit -m "docs: add skill dependency index

Maps all skill dependencies and cross-references showing:
- Critical dependency chains
- Skill-by-skill dependencies
- Agent integration summary
- Communication points between skills

Helps discover which skills to use and in what order.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"
```

---

## Task 7: Update README to Reference New Docs

**Files:**
- Modify: `/Users/tuan/tools/flows/README.md`

**Step 1: Read current README structure**

Read: `/Users/tuan/tools/flows/README.md`
Find: Documentation section or links to docs/

**Step 2: Add references to new documentation**

Add links to the new documentation files in an appropriate section:

```markdown
## Documentation

- [Agent Invocation Patterns](docs/agent-invocation-patterns.md) - When and how to invoke agents
- [Skill Dependency Index](docs/skill-dependency-index.md) - Skill dependencies and cross-references
- [Task Tool Mechanics](docs/task-tool-mechanics.md) - How agents return results
```

**Step 3: Verify links work**

Test: Navigate to the referenced files
Expected: Files exist at the specified paths

**Step 4: Parse and commit**

```bash
# Parse changed lines
git diff --unified=0 /Users/tuan/tools/flows/README.md | grep "^@@"

# VERIFY changes
git diff /Users/tuan/tools/flows/README.md

# Stage and commit
git stage-lines <parsed-lines> /Users/tuan/tools/flows/README.md && \
  git commit -m "docs: add links to new documentation in README

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"
```

---

## Verification

After completing all tasks:

**Step 1: Verify directory structure**

Run: `ls -la /Users/tuan/tools/flows/skills/executing-plans/`
Expected: executing-plans now in skills/ directory

**Step 2: Verify @flows: notation standardized**

```bash
# Check systematic-debugging
grep -c "@flows:" /Users/tuan/tools/flows/skills/systematic-debugging/SKILL.md

# Check root-cause-tracing
grep -c "@flows:" /Users/tuan/tools/flows/skills/root-cause-tracing/SKILL.md

# Should show increased @flows: usage
```

**Step 3: Verify YAML is valid**

Read: `/Users/tuan/tools/flows/skills/testing-skills-with-subagents/SKILL.md` (lines 1-10)
Expected: Only one description field

**Step 4: Verify documentation exists**

```bash
ls -la /Users/tuan/tools/flows/docs/agent-invocation-patterns.md
ls -la /Users/tuan/tools/flows/docs/skill-dependency-index.md
```

Expected: Both files exist

**Step 5: Run git status**

Run: `git status`
Expected: Clean working directory (all changes committed)

**Step 6: Review commit log**

Run: `git log --oneline -10`
Expected: 7-8 commits for integration improvements

---

## Success Criteria

- [ ] executing-plans moved to `/Users/tuan/tools/flows/skills/executing-plans/`
- [ ] All skill cross-references use @flows: notation consistently
- [ ] testing-skills-with-subagents YAML has no duplicate fields
- [ ] Agent invocation pattern documentation created
- [ ] Skill dependency index created
- [ ] README updated with links to new docs
- [ ] All changes committed with semantic messages
- [ ] No broken references or links

---

**Estimated Time:** 30-45 minutes (7 tasks × 5 minutes average)

**Dependencies:** None (can be executed independently)

**Risk Level:** Low (documentation and structural changes, no code logic changes)
