# Handoff Command Test Plan

## Test Date: 2025-11-10

## Overview
This document provides a manual test plan for the new `/flows:handoff` slash command. Since subagents cannot execute slash commands directly, this plan must be executed by a main Claude Code agent.

---

## Verification Results

### File Structure ✓
- **Command file**: `/Users/tuan/tools/flows/commands/handoff.md` - EXISTS
- **Skill file**: `/Users/tuan/tools/flows/skills/handoff/SKILL.md` - EXISTS

### Content Verification ✓

#### Command File (`commands/handoff.md`)
```yaml
---
description: Create context handoff for new Claude session - extracts issue, files, commits, and analysis
---

Use and follow the handoff skill exactly as written
```

**Status**: CORRECT
- Follows the standard pattern used by other commands (`brainstorm.md`, `write-plan.md`, etc.)
- Has proper YAML frontmatter with description
- References the skill correctly

#### Skill File (`skills/handoff/SKILL.md`)
```yaml
---
name: handoff
description: Create context handoff for new Claude session - extracts issue, files, commits, and analysis
---
```

**Status**: CORRECT
- Has proper YAML frontmatter with name and description
- Complete skill implementation (173 lines)
- Follows the established pattern with:
  - Clear process steps (Step 1-5)
  - Edge case handling
  - Important principles section
  - User input handling with {{ARGS}}

### Pattern Compliance ✓

The implementation follows the exact same pattern as existing commands:

| Command | Pattern | Handoff |
|---------|---------|---------|
| Frontmatter with description | ✓ | ✓ |
| "Use and follow [skill-name] skill exactly as written" | ✓ | ✓ |
| Corresponding skill file with matching name | ✓ | ✓ |
| Skill has name + description frontmatter | ✓ | ✓ |
| Complete implementation in skill | ✓ | ✓ |

---

## Manual Test Plan

### Prerequisites
- Must be executed in a **main Claude Code session** (not a subagent)
- Working directory: `/Users/tuan/tools/flows`
- A conversation with context to handoff (files, issues, analysis discussed)

### Test Case 1: Basic Command Invocation

**Objective**: Verify the command loads and executes

**Steps**:
1. In main Claude Code session, type: `/flows:handoff`
2. Observe if the command is recognized and loads

**Expected Result**:
- Command should appear in slash command autocomplete
- Should display: "flows:handoff is running..."
- Skill should load with full prompt

**Success Criteria**:
- No "command not found" errors
- Skill prompt expands into conversation

---

### Test Case 2: Command with Simple Issue Reference

**Objective**: Test extracting context for a numbered issue

**Setup**:
Create a conversation with a simple issue context:
```
We have 3 issues:
1. Code Duplication - Timeline.tsx and EventContent.tsx share 200 lines
2. Performance Issue - Slow rendering in large calendars
3. Bug - Events not saving properly

Files involved in issue 1:
- apps/web/src/Timeline.tsx:100-200
- apps/web/src/EventContent.tsx:150-250
```

**Steps**:
1. Type: `/flows:handoff issue 1`
2. Observe the agent's response

**Expected Result**:
- Agent should identify "Code Duplication" issue
- Extract files: Timeline.tsx and EventContent.tsx with line ranges
- Extract the description
- Generate handoff prompt
- Copy to clipboard using appropriate platform command

**Success Criteria**:
- Agent correctly identifies issue 1
- All mentioned files are extracted
- Handoff prompt follows the template format
- Clipboard copy command executes successfully
- Confirmation message: "✓ Handoff prompt copied to clipboard"

---

### Test Case 3: Command with Keyword Reference

**Objective**: Test extracting context by keyword instead of number

**Setup**:
Same conversation as Test Case 2

**Steps**:
1. Type: `/flows:handoff performance issue`
2. Observe if agent identifies issue 2

**Expected Result**:
- Agent should match "performance issue" to issue 2
- Extract relevant context
- Generate appropriate handoff

**Success Criteria**:
- Correct issue identified
- Handoff prompt generated
- No confusion with other issues

---

### Test Case 4: Missing Context Detection

**Objective**: Test agent's ability to detect incomplete context

**Setup**:
Simple conversation:
```
We need to fix the authentication bug in the login flow.
```

**Steps**:
1. Type: `/flows:handoff authentication bug`

**Expected Result**:
- Agent should detect no files mentioned
- Should warn: "No file references found in conversation about this issue"
- Should ask: "Should I search the codebase for related files?"

**Success Criteria**:
- Agent recognizes incomplete context
- Appropriate warning/question is asked
- Does not proceed without user confirmation

---

### Test Case 5: Complex Context Extraction

**Objective**: Test full feature with complete context

**Setup**:
Create a rich conversation:
```
## CRITICAL ISSUES

**1. Massive Code Duplication - SOLID Violation**

Impact: ~200 lines of duplicated code across Timeline.tsx and EventContent.tsx
Why it matters: DRY violation, bug fixes must be applied twice

Files:
- apps/web/src/modules/calendar/timeline/Timeline.tsx:456-569
- apps/web/src/modules/calendar/events/EventContent.tsx:223-304
- apps/web/src/utils/createEventOnDrop.tsx

Recent commits:
- abc1234 Added drag preview support
- def5678 Fixed event positioning bug

Analysis:
The drag-and-drop logic is duplicated between Timeline and EventContent components.
Both implement the same event handling, validation, and state updates.
This violates Single Responsibility Principle.

Recommended Solution:
Extract shared logic into a custom hook: useEventDragDrop()
Move validation to a separate validator function
Update both components to use the extracted logic
```

**Steps**:
1. Type: `/flows:handoff issue 1`

**Expected Result**:
Agent should extract:
- Full issue title and description
- All 3 file paths with line ranges
- Both commit hashes with subjects
- Complete analysis section
- Recommended solution
- Generate complete handoff prompt

**Success Criteria**:
- All files extracted (3 files)
- Commit history included
- Analysis preserved
- Solution recommendation included
- Prompt follows exact template format
- Successfully copied to clipboard

---

### Test Case 6: Ambiguous Input Handling

**Objective**: Test handling of unclear references

**Setup**:
Conversation with multiple similar issues:
```
Issues:
1. Login bug - users can't log in
2. Logout bug - users can't log out
3. Session bug - sessions expire too fast
```

**Steps**:
1. Type: `/flows:handoff bug`

**Expected Result**:
- Agent should recognize ambiguity
- Should list all matching issues
- Should ask user to specify which one

**Success Criteria**:
- Agent doesn't guess
- All matching issues listed
- Clear request for clarification

---

### Test Case 7: Platform-Specific Clipboard Copy

**Objective**: Verify correct clipboard command for macOS

**Setup**:
Any conversation with valid issue

**Steps**:
1. Execute `/flows:handoff [issue reference]`
2. Check the bash command used for clipboard

**Expected Result**:
- On macOS: Should use `pbcopy`
- Command should execute successfully
- Content should be in clipboard

**Success Criteria**:
- Correct platform detection
- `echo "..." | pbcopy` format used
- No clipboard errors
- User can paste the result

---

## Validation Checklist

Before marking as complete, verify:

- [ ] Command appears in slash command list
- [ ] Command loads without errors
- [ ] Skill prompt expands correctly
- [ ] Agent can parse numbered issue references
- [ ] Agent can parse keyword references
- [ ] Agent extracts all mentioned files
- [ ] Agent extracts commit information when present
- [ ] Agent preserves analysis and recommendations
- [ ] Agent handles missing context appropriately
- [ ] Agent asks for clarification when ambiguous
- [ ] Handoff prompt follows template format
- [ ] Clipboard copy works on macOS
- [ ] Confirmation message is displayed
- [ ] Generated prompt is pasteable into new session

---

## Known Limitations

1. **Subagent Restriction**: This command cannot be tested by subagents. It must be tested in a main Claude Code session.

2. **Clipboard Commands**: The skill references platform-specific clipboard commands:
   - macOS: `pbcopy`
   - Linux: `xclip` or `xsel`
   - Windows/WSL: `clip.exe`

   Testing should verify the appropriate command is used based on platform detection.

3. **Conversation Context Dependency**: The command's effectiveness depends on the quality of context in the conversation. Limited context will produce limited handoffs.

---

## Recommendation

**STATUS: READY FOR TESTING**

The `/flows:handoff` command implementation is **complete and properly structured**:

✓ Command file exists and follows pattern
✓ Skill file exists and is complete (173 lines)
✓ Frontmatter is correct in both files
✓ Follows same pattern as other flows commands
✓ Comprehensive implementation with edge cases
✓ Clear process steps and principles

**Next Steps**:
1. Execute this test plan in a main Claude Code session
2. Test with real conversation context
3. Verify clipboard functionality
4. Document any issues found
5. If all tests pass, command is ready for production use

**Integration Check**:
The command should automatically appear in the slash command list once the plugin is loaded, as it follows the same pattern as existing commands (`/flows:brainstorm`, `/flows:write-plan`, `/flows:subagents-execution`, `/flows:gradual-execution`).
