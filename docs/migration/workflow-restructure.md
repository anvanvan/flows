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
