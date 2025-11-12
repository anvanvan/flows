# Task Tool Mechanics

## Overview

The Task tool dispatches specialized subagents (Explore, general-purpose, code-reviewer, etc.) and returns their results in the function result block.

## How Task Tool Returns Results

When you invoke the Task tool, results are returned in the function_results block that follows your invocation.

**Example invocation:**
```
Invoke Task tool with prompt:
"Explore the codebase to find authentication patterns.
Return: file paths, implementation details, and testing approaches."
```

**Result location:**
The subagent's complete output appears in the function_results block.

**Result format:**
- Plain text narrative (Explore agents)
- Structured sections (if you specified return format in prompt)
- Full conversation output (what the subagent returned)

## Key Principle

**Results are in function_results, not in files the subagent created.**

**IMPORTANT:** Explore agents should NOT create temporary files. Instead:
- Aggregate all findings in memory during exploration
- Consolidate results into structured narrative
- Return complete report in final message (appears in function_results)
- No /tmp files, no docs/ files - results go to function_results only

**For main agent consuming results:**
- Read from function_results block (not files)
- The Task tool captures subagent output automatically
- Ignore any files subagents may have created

## Three Result Consumption Patterns

### Pattern 1: Narrative Consumption (Explore Agents)

**Used by:** 12+ skills (codebase-research, pattern-discovery, systematic-debugging, etc.)

**How it works:**
1. Dispatch Explore with detailed prompt specifying return format
2. Explore returns narrative report in function_results
3. Read and use findings directly from narrative

**Example:**

Skill prompt to Explore:
```
**Return structured report with:**
- Architecture summary (project structure, key directories)
- Similar implementations (file paths + brief description)
- Testing file patterns and locations
```

After Task tool returns, the function_results contains:

```
Architecture summary:
- Project uses MVC pattern
- Controllers in src/controllers/
- Models in src/models/

Similar implementations:
- User authentication: src/auth/user-auth.ts:15-45
- API key auth: src/auth/api-key-auth.ts:20-60

Testing patterns:
- Jest framework
- Tests in tests/ directory matching src/ structure
```

**Consumption:**
- Read findings from function_results text
- Reference specific file:line mentions
- Use architecture summary to inform task creation
- No parsing required - consume narratively

**When to use:** When results are reports meant for human understanding

**IMPORTANT - Prompting Explore agents:**
When dispatching Explore agents, include this instruction:
```
**CRITICAL:** Do NOT create temporary files (/tmp, docs/, etc).
Aggregate all findings in memory and return complete report in your final message.
All results must appear in function_results - no file creation.
```

---

### Pattern 2: Structured Parsing (Implementation Tasks)

**Used by:** subagent-driven-development

**How it works:**
1. Dispatch implementation task agent with strict 5-section report format
2. Agent returns structured report
3. Parse specific sections using text extraction and regex
4. Validate extracted data
5. Re-prompt if validation fails

**Example:**

Skill requires this exact format:
```
## Commits Created
- abc1234 (feat: add authentication)
- def5678 (test: add auth tests)

## Files Modified
- src/auth.ts (modified)
- tests/auth.test.ts (created)

## Implementation Summary
[Description of what was done]

## Testing
[Test results]

## Next Steps
[What comes next]
```

**Parsing code pattern** (from subagent-driven-development/SKILL.md:308-362):

```
1. Extract "Commits Created" section
2. Parse each line starting with "- "
3. Extract commit SHA using regex: [a-f0-9]{7,8}|[a-f0-9]{40}
4. Validate: non-empty list, each SHA matches pattern

5. Extract "Files Modified" section
6. Parse each line "path (status)" by splitting on first "("
7. Validate: non-empty string path

8. If validation fails:
   - Report error to user
   - Show what was extracted
   - Ask subagent to reformat
   - Retry parsing after receiving fixed report
```

**When to use:** When you need specific data extracted for automation (git operations, file tracking)

---

### Pattern 3: Semantic Analysis (Code Review)

**Used by:** requesting-code-review, subagent-driven-development (for safety check)

**How it works:**
1. Dispatch code-reviewer with plan/requirements context
2. Reviewer returns analysis with sections
3. Read for semantic meaning (keywords, categories, severity)
4. Make decisions based on review content

**Example:**

After code review returns, search for keywords:
```
- Look for "Safety Check Results" section
- Extract issue categories:
  - Critical: [issues that must be fixed]
  - Important: [issues that should be fixed]
  - Minor: [optional improvements]
- Check for specific concerns:
  - "concurrent modification" → Stop execution
  - "✓" or "No issues" → Proceed
  - "Missing tests" → Add test task
```

**Consumption:**
- Read review text from function_results
- Identify key sections and keywords
- Make workflow decisions based on content
- No rigid parsing - semantic understanding

**When to use:** When results require interpretation and judgment

## End-to-End Consumption Examples

### Example 1: Codebase Research (Narrative Consumption)

**Step 1: Dispatch 5 parallel Explore agents**

```
Invoke Task tool 5 times in parallel:
- Agent 1: Architecture & entry points
- Agent 2: Core implementation & data flow
- Agent 3: Testing infrastructure
- Agent 4: Dev workflow & configuration
- Agent 5: Integration points & dependencies
```

**Step 2: Receive results in 5 function_results blocks**

Each function_results contains agent's complete report.

**Step 3: Synthesize findings into onboarding document**

Read each function_results and populate sections:
```
## Architecture Overview
[Use Agent 1 findings]
- Entry Points: file:line from Agent 1

## Key Features
[Use Agent 2 findings]
- Feature A: file:line from Agent 2

## Testing Approach
[Use Agent 3 findings]
- Framework: from Agent 3
- Patterns: examples from Agent 3

## Development Workflow
[Use Agent 4 findings]
- Commands from Agent 4

## Integration Points
[Use Agent 5 findings]
- Services: file:line from Agent 5
```

**Key insight:** Every section populated directly from function_results. No file reading required.

---

### Example 2: Implementation Task (Structured Parsing)

**Step 1: Dispatch task agent with strict format requirements**

Prompt includes:
```
**REQUIRED:** Return report in this EXACT format:

## Commits Created
- <sha> (<message>)

## Files Modified
- <path> (<status>)

## Implementation Summary
[...]

## Testing
[...]

## Next Steps
[...]
```

**Step 2: Receive report in function_results**

Report appears as text in function_results block.

**Step 3: Parse specific sections**

```
commits_section = extract_section("Commits Created", function_results)
commits = []
for line in commits_section.lines:
    if line.startswith("- "):
        sha = extract_sha(line)  # Regex: [a-f0-9]{7,8}|[a-f0-9]{40}
        if sha matches pattern:
            commits.append(sha)

files_section = extract_section("Files Modified", function_results)
files = []
for line in files_section.lines:
    if line.startswith("- "):
        path = line.split("(")[0].strip()  # Split on first "("
        files.append(path)
```

**Step 4: Validate extracted data**

```
if not commits:
    error = "Report missing 'Commits Created' section"
    ask_subagent_to_reformat(error)
    retry_parsing()

if not files:
    error = "Report missing 'Files Modified' section"
    ask_subagent_to_reformat(error)
    retry_parsing()
```

**Step 5: Use validated data**

```
Present to user:
"Task complete. Created commits:
- commits[0]
- commits[1]

Modified files:
- files[0]
- files[1]"
```

---

### Example 3: Code Review (Semantic Analysis)

**Step 1: Dispatch code-reviewer with context**

Pass plan and current implementation to code-reviewer agent.

**Step 2: Receive review in function_results**

Review appears as structured narrative with sections.

**Step 3: Read for semantic meaning**

```
Look for "Safety Check Results" section in function_results

If section contains "concurrent modification":
    Stop execution
    Report: "Code review detected concurrent changes. Please resolve conflicts."

If section contains "Critical:" or "CRITICAL:":
    Extract critical issues list
    Report to user: "Must fix before proceeding: [issues]"
    Wait for fixes

If section contains "✓" or "No issues found":
    Report: "Code review passed. Proceeding..."
    Continue to next task

If section contains "Missing tests":
    Add task: "Write tests per code review feedback"
```

**Step 4: Make workflow decisions based on content**

No rigid parsing - read and interpret like a human would.
