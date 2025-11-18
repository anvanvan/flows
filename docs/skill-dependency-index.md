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
