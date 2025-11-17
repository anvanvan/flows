# Revert to Flat Skill Structure Implementation Plan

> **For Claude:** Two execution options available:
> - **flows:subagent-driven-development** (Recommended): Fresh subagent per task with code review between tasks
> - **flows:executing-plans** (Alternative): Batched execution with manual checkpoints
>
> Use whichever execution method the user invokes. If user calls /flows:subagents-execution or /flows:gradual-execution, they've chosen executing-plans.

**Goal:** Revert skills from workflow-based phase organization (skills/00-meta/skill-name/) back to flat structure (skills/skill-name/) to fix skill discovery system

**Architecture:** Reverse all 26 git mv operations from the workflow restructure, remove empty phase directories, and update all path references in commands, hooks, and documentation

**Tech Stack:** Bash (git mv), sed/grep for path updates, git history preservation

---

## Phase 1: Move All Skills Back to Flat Structure

### Task 1: Move completion phase skills (07-completion)

**Files:**
- Move: `skills/07-completion/handoff/` → `skills/handoff/`
- Move: `skills/07-completion/finishing-a-development-branch/` → `skills/finishing-a-development-branch/`

**Step 1: Move handoff to root**

```bash
git mv skills/07-completion/handoff skills/handoff
```

**Step 2: Verify handoff move**

```bash
ls -la skills/handoff/
```

Expected: Should show SKILL.md file

**Step 3: Move finishing-a-development-branch to root**

```bash
git mv skills/07-completion/finishing-a-development-branch skills/finishing-a-development-branch
```

**Step 4: Verify move**

```bash
ls -la skills/finishing-a-development-branch/
```

Expected: Should show SKILL.md file

**Step 5: Commit both moves**

```bash
git commit -m "refactor: move completion skills back to flat structure"
```

---

### Task 2: Move validation phase skills (06-validation)

**Files:**
- Move: `skills/06-validation/testing-anti-patterns/` → `skills/testing-anti-patterns/`
- Move: `skills/06-validation/receiving-code-review/` → `skills/receiving-code-review/`
- Move: `skills/06-validation/requesting-code-review/` → `skills/requesting-code-review/`
- Move: `skills/06-validation/verification-before-completion/` → `skills/verification-before-completion/`

**Step 1: Move all four validation skills**

```bash
git mv skills/06-validation/testing-anti-patterns skills/testing-anti-patterns && \
git mv skills/06-validation/receiving-code-review skills/receiving-code-review && \
git mv skills/06-validation/requesting-code-review skills/requesting-code-review && \
git mv skills/06-validation/verification-before-completion skills/verification-before-completion
```

**Step 2: Verify all moves**

```bash
ls -la skills/testing-anti-patterns/ && \
ls -la skills/receiving-code-review/ && \
ls -la skills/requesting-code-review/ && \
ls -la skills/verification-before-completion/
```

Expected: All should show SKILL.md files (requesting-code-review should also show code-reviewer.md)

**Step 3: Commit moves**

```bash
git commit -m "refactor: move validation skills back to flat structure"
```

---

### Task 3: Move debugging phase skills (05-debugging)

**Files:**
- Move: `skills/05-debugging/dispatching-parallel-agents/` → `skills/dispatching-parallel-agents/`
- Move: `skills/05-debugging/root-cause-tracing/` → `skills/root-cause-tracing/`
- Move: `skills/05-debugging/systematic-debugging/` → `skills/systematic-debugging/`

**Step 1: Move all three debugging skills**

```bash
git mv skills/05-debugging/dispatching-parallel-agents skills/dispatching-parallel-agents && \
git mv skills/05-debugging/root-cause-tracing skills/root-cause-tracing && \
git mv skills/05-debugging/systematic-debugging skills/systematic-debugging
```

**Step 2: Verify all moves**

```bash
ls -la skills/dispatching-parallel-agents/ && \
ls -la skills/root-cause-tracing/ && \
ls -la skills/systematic-debugging/
```

Expected: All should show SKILL.md files (systematic-debugging has 6 files, root-cause-tracing has 2 files)

**Step 3: Commit moves**

```bash
git commit -m "refactor: move debugging skills back to flat structure"
```

---

### Task 4: Move implementation phase skills (04-implementation)

**Files:**
- Move: `skills/04-implementation/strangler-fig-pattern/` → `skills/strangler-fig-pattern/`
- Move: `skills/04-implementation/condition-based-waiting/` → `skills/condition-based-waiting/`
- Move: `skills/04-implementation/subagent-driven-development/` → `skills/subagent-driven-development/`
- Move: `skills/04-implementation/test-driven-development/` → `skills/test-driven-development/`

**Step 1: Move all four implementation skills**

```bash
git mv skills/04-implementation/strangler-fig-pattern skills/strangler-fig-pattern && \
git mv skills/04-implementation/condition-based-waiting skills/condition-based-waiting && \
git mv skills/04-implementation/subagent-driven-development skills/subagent-driven-development && \
git mv skills/04-implementation/test-driven-development skills/test-driven-development
```

**Step 2: Verify all moves**

```bash
ls -la skills/strangler-fig-pattern/ && \
ls -la skills/condition-based-waiting/ && \
ls -la skills/subagent-driven-development/ && \
ls -la skills/test-driven-development/
```

Expected: All should show SKILL.md files (condition-based-waiting has 2 files)

**Step 3: Commit moves**

```bash
git commit -m "refactor: move implementation skills back to flat structure"
```

---

### Task 5: Move preparation phase skills (03-preparation)

**Files:**
- Move: `skills/03-preparation/characterization-testing/` → `skills/characterization-testing/`
- Move: `skills/03-preparation/defense-in-depth/` → `skills/defense-in-depth/`
- Move: `skills/03-preparation/using-git-worktrees/` → `skills/using-git-worktrees/`

**Step 1: Move all three preparation skills**

```bash
git mv skills/03-preparation/characterization-testing skills/characterization-testing && \
git mv skills/03-preparation/defense-in-depth skills/defense-in-depth && \
git mv skills/03-preparation/using-git-worktrees skills/using-git-worktrees
```

**Step 2: Verify all moves**

```bash
ls -la skills/characterization-testing/ && \
ls -la skills/defense-in-depth/ && \
ls -la skills/using-git-worktrees/
```

Expected: All should show SKILL.md files

**Step 3: Commit moves**

```bash
git commit -m "refactor: move preparation skills back to flat structure"
```

---

### Task 6: Move planning phase skills (02-planning)

**Files:**
- Move: `skills/02-planning/when-stuck/` → `skills/when-stuck/`
- Move: `skills/02-planning/writing-plans/` → `skills/writing-plans/`
- Move: `skills/02-planning/brainstorming/` → `skills/brainstorming/`

**Step 1: Move all three planning skills**

```bash
git mv skills/02-planning/when-stuck skills/when-stuck && \
git mv skills/02-planning/writing-plans skills/writing-plans && \
git mv skills/02-planning/brainstorming skills/brainstorming
```

**Step 2: Verify all moves**

```bash
ls -la skills/when-stuck/ && \
ls -la skills/writing-plans/ && \
ls -la skills/brainstorming/
```

Expected: All should show SKILL.md files

**Step 3: Commit moves**

```bash
git commit -m "refactor: move planning skills back to flat structure"
```

---

### Task 7: Move understanding phase skills (01-understanding)

**Files:**
- Move: `skills/01-understanding/knowledge-lineages/` → `skills/knowledge-lineages/`
- Move: `skills/01-understanding/pattern-discovery/` → `skills/pattern-discovery/`
- Move: `skills/01-understanding/codebase-research/` → `skills/codebase-research/`

**Step 1: Move all three understanding skills**

```bash
git mv skills/01-understanding/knowledge-lineages skills/knowledge-lineages && \
git mv skills/01-understanding/pattern-discovery skills/pattern-discovery && \
git mv skills/01-understanding/codebase-research skills/codebase-research
```

**Step 2: Verify all moves**

```bash
ls -la skills/knowledge-lineages/ && \
ls -la skills/pattern-discovery/ && \
ls -la skills/codebase-research/
```

Expected: All should show SKILL.md files

**Step 3: Commit moves**

```bash
git commit -m "refactor: move understanding skills back to flat structure"
```

---

### Task 8: Move meta phase skills (00-meta)

**Files:**
- Move: `skills/00-meta/sharing-skills/` → `skills/sharing-skills/`
- Move: `skills/00-meta/testing-skills-with-subagents/` → `skills/testing-skills-with-subagents/`
- Move: `skills/00-meta/writing-skills/` → `skills/writing-skills/`
- Move: `skills/00-meta/using-flows/` → `skills/using-flows/`

**Step 1: Move all four meta skills**

```bash
git mv skills/00-meta/sharing-skills skills/sharing-skills && \
git mv skills/00-meta/testing-skills-with-subagents skills/testing-skills-with-subagents && \
git mv skills/00-meta/writing-skills skills/writing-skills && \
git mv skills/00-meta/using-flows skills/using-flows
```

**Step 2: Verify all moves**

```bash
ls -la skills/sharing-skills/ && \
ls -la skills/testing-skills-with-subagents/ && \
ls -la skills/writing-skills/ && \
ls -la skills/using-flows/
```

Expected: All should show SKILL.md files (writing-skills has 4 files, testing-skills-with-subagents has examples/)

**Step 3: Commit moves**

```bash
git commit -m "refactor: move meta skills back to flat structure"
```

---

### Task 9: Remove empty phase directories

**Files:**
- Remove: `skills/00-meta/`
- Remove: `skills/01-understanding/`
- Remove: `skills/02-planning/`
- Remove: `skills/03-preparation/`
- Remove: `skills/04-implementation/`
- Remove: `skills/05-debugging/`
- Remove: `skills/06-validation/`
- Remove: `skills/07-completion/`

**Step 1: Remove all empty phase directories**

```bash
rmdir skills/00-meta && \
rmdir skills/01-understanding && \
rmdir skills/02-planning && \
rmdir skills/03-preparation && \
rmdir skills/04-implementation && \
rmdir skills/05-debugging && \
rmdir skills/06-validation && \
rmdir skills/07-completion
```

**Step 2: Verify skills directory is now flat**

```bash
ls -la skills/ | grep "^d"
```

Expected: Should only show . and .. plus skill directories (no phase directories)

**Step 3: Commit directory cleanup**

```bash
git stage-lines skills/ && \
  git commit -m "refactor: remove empty workflow phase directories"
```

---

## Phase 2: Update Command Files

### Task 10: Update brainstorm command

**Files:**
- Modify: `commands/brainstorm.md`

**Step 1: Read current file**

```bash
cat commands/brainstorm.md
```

**Step 2: Update skill path**

Use Edit tool to replace `skills/02-planning/brainstorming` with `brainstorming`

**Step 3: Verify change**

```bash
grep "brainstorming" commands/brainstorm.md
```

Expected: Should show `brainstorming` without phase prefix

**Step 4: Parse changed lines and commit**

```bash
git diff --unified=0 commands/brainstorm.md | grep "^@@"
git stage-lines 5 commands/brainstorm.md && \
  git commit -m "fix: update brainstorm command for flat skill structure"
```

---

### Task 11: Update write-plan command

**Files:**
- Modify: `commands/write-plan.md`

**Step 1: Read current file**

```bash
cat commands/write-plan.md
```

**Step 2: Update skill path**

Use Edit tool to replace `skills/02-planning/writing-plans` with `writing-plans`

**Step 3: Parse changed lines and commit**

```bash
git diff --unified=0 commands/write-plan.md | grep "^@@"
git stage-lines 5 commands/write-plan.md && \
  git commit -m "fix: update write-plan command for flat skill structure"
```

---

### Task 12: Update subagents-execution command

**Files:**
- Modify: `commands/subagents-execution.md`

**Step 1: Read current file**

```bash
cat commands/subagents-execution.md
```

**Step 2: Update skill path**

Use Edit tool to replace `skills/04-implementation/subagent-driven-development` with `subagent-driven-development`

**Step 3: Parse changed lines and commit**

```bash
git diff --unified=0 commands/subagents-execution.md | grep "^@@"
git stage-lines 5 commands/subagents-execution.md && \
  git commit -m "fix: update subagents-execution command for flat skill structure"
```

---

### Task 13: Update handoff command

**Files:**
- Modify: `commands/handoff.md`

**Step 1: Read current file**

```bash
cat commands/handoff.md
```

**Step 2: Update skill path**

Use Edit tool to replace `skills/07-completion/handoff` with `handoff`

**Step 3: Parse changed lines and commit**

```bash
git diff --unified=0 commands/handoff.md | grep "^@@"
git stage-lines 5 commands/handoff.md && \
  git commit -m "fix: update handoff command for flat skill structure"
```

---

## Phase 3: Update Hook Files

### Task 14: Update session-start hook

**Files:**
- Modify: `hooks/session-start.sh`

**Step 1: Read current hook file**

```bash
cat hooks/session-start.sh
```

**Step 2: Update using-flows path**

Use Edit tool to replace `skills/00-meta/using-flows/SKILL.md` with `skills/using-flows/SKILL.md`

**Step 3: Test the hook works**

```bash
bash hooks/session-start.sh
```

Expected: Should output using-flows skill content without errors

**Step 4: Parse changed lines and commit**

```bash
git diff --unified=0 hooks/session-start.sh | grep "^@@"
git stage-lines 18 hooks/session-start.sh && \
  git commit -m "fix: update session-start hook for flat skill structure"
```

---

## Phase 4: Update Skill Content References

### Task 15: Update when-stuck dispatcher table

**Files:**
- Modify: `skills/when-stuck/SKILL.md`

**Step 1: Read current file section with dispatcher table**

```bash
sed -n '20,40p' skills/when-stuck/SKILL.md
```

**Step 2: Update path references in dispatcher table**

Use Edit tool to update lines 33-35:
- Replace `skills/05-debugging/systematic-debugging/` with `skills/systematic-debugging/`
- Replace `skills/01-understanding/codebase-research/` with `skills/codebase-research/`
- Replace `skills/01-understanding/pattern-discovery/` with `skills/pattern-discovery/`

**Step 3: Parse changed lines and commit**

```bash
git diff --unified=0 skills/when-stuck/SKILL.md | grep "^@@"
git stage-lines 33-35 skills/when-stuck/SKILL.md && \
  git commit -m "fix: update when-stuck dispatcher table for flat structure"
```

---

### Task 16: Update using-flows workflow phase documentation

**Files:**
- Modify: `skills/using-flows/SKILL.md`

**Step 1: Read workflow phase documentation section**

```bash
sed -n '50,90p' skills/using-flows/SKILL.md
```

**Step 2: Remove workflow phase documentation section**

Use Edit tool to remove lines 51-87 (the entire "Understanding Workflow Phases" section added during restructure)

**Step 3: Parse changed lines and commit**

```bash
git diff --unified=0 skills/using-flows/SKILL.md | grep "^@@"
git stage-lines 51-87 skills/using-flows/SKILL.md && \
  git commit -m "docs: remove workflow phase documentation from using-flows"
```

---

## Phase 5: Update README Documentation

### Task 17: Update README skills library section

**Files:**
- Modify: `README.md`

**Step 1: Read current Skills Library section**

```bash
sed -n '275,325p' README.md
```

**Step 2: Replace workflow phase organization with flat listing**

Use Edit tool to replace lines 279-324 with simpler flat skill listing:

```markdown
### Skills Library

**Testing & Quality**
- **test-driven-development** - RED-GREEN-REFACTOR cycle
- **condition-based-waiting** - Async test patterns
- **testing-anti-patterns** - Common pitfalls to avoid
- **verification-before-completion** - Ensure it's actually fixed
- **characterization-testing** - Document legacy code behavior before refactoring

**Debugging**
- **systematic-debugging** - 4-phase root cause process
- **root-cause-tracing** - Find the real problem
- **dispatching-parallel-agents** - Concurrent debugging workflows

**Development**
- **brainstorming** - Socratic design refinement
- **writing-plans** - Detailed implementation plans
- **executing-plans** - Batch execution with checkpoints
- **subagent-driven-development** - Fast iteration with quality gates
- **using-git-worktrees** - Parallel development branches
- **finishing-a-development-branch** - Merge/PR decision workflow

**Code Understanding**
- **codebase-research** - Systematic codebase exploration
- **pattern-discovery** - Find existing patterns to follow
- **knowledge-lineages** - Trace historical context of decisions
- **when-stuck** - Problem-solving technique dispatcher

**Refactoring**
- **defense-in-depth** - Multiple validation layers
- **strangler-fig-pattern** - Incremental legacy system replacement

**Collaboration**
- **requesting-code-review** - Pre-review checklist
- **receiving-code-review** - Responding to feedback
- **handoff** - Context handoff for new Claude session

**Meta**
- **using-flows** - Introduction to the skills system
- **writing-skills** - Create new skills following best practices
- **testing-skills-with-subagents** - Validate skill quality
- **sharing-skills** - Contribute skills back via branch and PR
```

**Step 3: Update path reference in Contributing section**

Use Edit tool to replace `skills/00-meta/writing-skills/SKILL.md` with `skills/writing-skills/SKILL.md` at line 359

**Step 4: Parse changed lines and commit**

```bash
git diff --unified=0 README.md | grep "^@@"
git stage-lines 279-324,359 README.md && \
  git commit -m "docs: update README for flat skill structure"
```

---

## Phase 6: Final Verification

### Task 18: Verify all skills are discoverable

**Step 1: Count skills in flat structure**

```bash
find skills -maxdepth 1 -type d ! -name skills | wc -l
```

Expected: 26 skill directories

**Step 2: Verify all SKILL.md files exist**

```bash
find skills -maxdepth 2 -name "SKILL.md" | wc -l
```

Expected: 26 SKILL.md files

**Step 3: Check for any remaining phase directory references**

```bash
grep -r "skills/0[0-7]-" commands/ hooks/ README.md
```

Expected: No results (all phase references removed)

**Step 4: Verify hook works**

```bash
bash hooks/session-start.sh | head -20
```

Expected: Should output using-flows skill content

**Step 5: Verify git history is intact**

```bash
git log --follow skills/codebase-research/SKILL.md --oneline | head -10
```

Expected: Should show full history including move operations

**Step 6: Document verification results**

No commit needed - verification only.

---

## Summary

This plan reverts the workflow-based skill organization back to a flat structure in 18 tasks:

**Phase 1:** Move all 26 skills back to `skills/{skill-name}/` (Tasks 1-9)
**Phase 2:** Update 4 command files to remove phase prefixes (Tasks 10-13)
**Phase 3:** Update session-start hook path (Task 14)
**Phase 4:** Update skill content references (Tasks 15-16)
**Phase 5:** Update README documentation (Task 17)
**Phase 6:** Verify all changes work correctly (Task 18)

All git history is preserved through `git mv` operations.
