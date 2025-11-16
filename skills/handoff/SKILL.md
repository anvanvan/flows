---
name: handoff
description: Create context handoff for new Claude session - extracts issue, files, commits, and analysis
---

# Handoff Command

You are acting as a **context engineer**. Your job is to create a complete, token-efficient handoff prompt that can be pasted into a new Claude session.

## User Input

The user provided: {{ARGS}}

## Your Process

### Step 1: Parse & Identify Issue

Extract the issue identifier from the user's input. Look for:
- Numbered references: "issue 1", "issue 2", "problem 1"
- Keywords: "code duplication", "debugging code", "performance issue"
- Descriptive phrases: "the duplication problem from above"

Search the conversation history backwards to find the matching issue. Look for patterns like:
- Numbered lists: "1. Massive Code Duplication - SOLID Violation"
- Section headers: "## CRITICAL ISSUES" followed by numbered items
- Bold markers: "**1. Issue Title**"
- Keywords matching user's description

Extract:
- Full issue title
- Complete description and impact assessment
- Your analysis of the problem
- Any severity markers or categorization

### Step 2: Extract Context from Conversation

Scan the conversation for all relevant context. Be thorough:

**Files (extract ALL mentioned):**
- Full paths: `apps/web/src/modules/calendar/timeline/Timeline.tsx`
- With line numbers: `Timeline.tsx:456-569`, `EventContent.tsx:223-304`
- Partial paths mentioned in context: "Timeline.tsx", "createEventOnDrop.tsx"
- Related files in the same discussion area

Capture files with their line number references when available.

**Commits:**
- Full SHA hashes: `abc1234567890...`
- Short hashes: `abc1234`
- Commit references: "the commit that added drag preview"
- Any git history discussed in relation to this issue

**Analysis & Context:**
- Your assessment of the problem
- Impact statements ("Bug fixes must be applied twice", "~200 lines of redundant code")
- Why this is an issue (SOLID violations, DRY violations, maintenance burden)
- Any architectural observations

**Learnings & Patterns:**
- Patterns you discovered
- Anti-patterns identified
- Root causes
- Related code smells or issues

**Recommended Solution:**
- Your proposed approach
- Alternative solutions discussed
- Implementation suggestions
- Testing considerations

### Step 3: Context Extraction: Multi-Faceted Exploration

**Dispatch 3 Explore agents IN PARALLEL** for comprehensive handoff:

**Agent 1 - Commit History:**

Use Task tool:
```python
subagent_type = "Explore"
model = "haiku"
prompt = """
Use git log to fetch commit history for [branch/feature or files].

If files mentioned: Get last 10 commits for each file using:
git log -n 10 --oneline -- <filepath>

Deduplicate commits across files (same commit may touch multiple files).

Return: Commit SHAs (short form), messages, deduplicated list

**CRITICAL:** Do NOT create temporary files (/tmp, docs/, etc).
Aggregate all findings in memory and return complete report in your final message.
All results must appear in function_results - no file creation.

Thoroughness: medium
"""
```

**Agent 2 - Modified Files Analysis:**

```python
subagent_type = "Explore"
model = "haiku"
prompt = """
Explore modified files to understand changes:
1. Identify all files changed in recent commits or mentioned in conversation
2. Understand purpose of each modified file (what it does in the system)
3. Find related files not yet modified (potential incompleteness)
4. Locate tests covering modified code
5. Find documentation that needs updating

Return: File inventory with purpose, related files, test coverage, doc status

**CRITICAL:** Do NOT create temporary files (/tmp, docs/, etc).
Aggregate all findings in memory and return complete report in your final message.
All results must appear in function_results - no file creation.

Thoroughness: very thorough
"""
```

**Agent 3 - Issue Context Discovery:**

```python
subagent_type = "Explore"
model = "haiku"
prompt = """
Explore codebase for issue context:
1. Find code comments, TODOs related to [issue/feature]
2. Locate similar features or implementations
3. Identify dependencies and integrations
4. Find configuration or environment requirements

Return: Complete context map for next session

**CRITICAL:** Do NOT create temporary files (/tmp, docs/, etc).
Aggregate all findings in memory and return complete report in your final message.
All results must appear in function_results - no file creation.

Thoroughness: very thorough
"""
```

**Consuming 3 Agent Results:**

After Task tool returns, you receive 3 function_results blocks (one per agent).

**Agent 1 - Commit History:**
- Read from first function_results
- Extract commit SHAs (short form) and messages
- Deduplicated list of commits

**Agent 2 - Modified Files Analysis:**
- Read from second function_results
- Extract file inventory with purpose explanations
- Note related files not yet modified
- Get test coverage assessment
- Identify documentation gaps

**Agent 3 - Issue Context Discovery:**
- Read from third function_results
- Extract code comments, TODOs related to issue
- Get similar feature implementations
- Note dependencies and integrations
- Understand configuration requirements

**Consumption pattern:** Narrative (Pattern 1) - read all three reports and synthesize into handoff document.

**Handoff document includes:**
- Git history (commits, SHAs) ← Agent 1 function_results
- File inventory with purpose and relationships ← Agent 2 function_results
- Test coverage assessment ← Agent 2 function_results
- Related code not yet addressed ← Agent 2 function_results
- Issue context from codebase ← Agent 3 function_results

**All content sourced directly from agent function_results** - no speculation, only discovered facts.

### Step 4: Format the Handoff Prompt

Use this exact structure:

```markdown
# [Issue Title]

## Context & Analysis
[Your original analysis from conversation, including:
- Problem description
- Impact assessment (lines duplicated, maintenance burden, etc.)
- Why this matters (SOLID violations, DRY violations, etc.)
- Any architectural observations]

## Files
[From Agent 2 - Modified Files Analysis:]
- path/to/file1.tsx:line-range - [Purpose: what this file does]
- path/to/file2.tsx:line-range - [Purpose: what this file does]
- path/to/related-file.tsx - [Purpose: what this file does]

**Related Files (not yet modified):**
- path/to/potentially-affected.tsx - [Why relevant]

**Test Coverage:**
- path/to/test-file.test.tsx - [What's tested]
- [Gaps in coverage identified]

**Documentation Needs:**
- [Docs that need updating based on changes]

*Read these files to verify current state - code may have changed since this analysis.*

## Relevant Commits
[From Agent 1 - Commit History:
abc1234 - Commit subject line
def5678 - Another commit subject

If no commits available, omit this section]

## Issue Context
[From Agent 3 - Issue Context Discovery:
- Code comments/TODOs related to this issue
- Similar features or implementations found
- Dependencies and integrations identified
- Configuration or environment requirements]

## Learnings & Patterns
[Extracted from conversation:
- Patterns discovered
- Anti-patterns identified
- Root causes found
- Related observations]

## Recommended Solution
[Your proposed approach from the conversation:
- How to fix it
- Where to refactor
- What principles to apply
- Any implementation notes]

## Task
[Clear, actionable description of what needs to be done:
- Specific goal
- Success criteria
- What to eliminate/fix/implement]
```

### Step 5: Copy to Clipboard

Detect the platform and use the appropriate copy command:
- macOS: `pbcopy`
- Linux: `xclip -selection clipboard` or `xsel --clipboard`
- Windows/WSL: `clip.exe`

Use the Bash tool to copy the formatted handoff prompt to clipboard.

Then confirm to the user:
"✓ Handoff prompt copied to clipboard. Ready to paste into new Claude session."

## Edge Cases

**Issue not found:**
- Show what you searched for
- Ask user to clarify which issue or provide more context

**No files mentioned:**
- Warn: "No file references found in conversation about this issue."
- Ask: "Should I search the codebase for related files?"

**Multiple matching issues:**
- List all matches with brief descriptions
- Ask user to specify which one

**Ambiguous input:**
- Show what you interpreted
- Ask for confirmation before proceeding

## Important Principles

1. **Extract, don't invent** - Only use what's in the conversation
2. **Be thorough** - Include all mentioned files, even if they seem minor
3. **Token efficient** - No redundant text, file paths only (no contents)
4. **Context rich** - Preserve your analysis and learnings
5. **Actionable** - End with a clear task statement
6. **Trust conversation first** - Only spawn subagents when genuinely needed

Your goal: Create a handoff prompt that allows a fresh Claude session to understand the problem and solution approach immediately, without asking clarifying questions.
