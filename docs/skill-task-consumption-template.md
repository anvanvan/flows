# Skill Task Consumption Template

## Purpose

This template shows how to add explicit result consumption instructions to skills that use the Task tool.

## Template Structure

### Part 1: Update Explore Agent Dispatch Prompts

For each Explore agent dispatch, ADD this instruction to the prompt:

```markdown
**CRITICAL:** Do NOT create temporary files (/tmp, docs/, etc).
Aggregate all findings in memory and return complete report in your final message.
All results must appear in function_results - no file creation.
```

### Part 2: Add Consumption Section After Dispatch

For each Task tool invocation in a skill, add this section immediately after the dispatch:

```
### Consuming Task Results

**After Task tool returns:**

1. **Result location:** The complete output appears in function_results block

2. **Result format:** [Describe expected format based on your prompt]
   - Section 1: [What it contains]
   - Section 2: [What it contains]

3. **How to consume:**
   [Choose consumption pattern:]

   **If narrative consumption (Pattern 1):**
   - Read findings directly from function_results text
   - Reference specific file:line mentions
   - Use architecture summary to inform [downstream action]
   - No parsing required - consume narratively

   **If structured parsing (Pattern 2):**
   - Extract section: [section name]
   - Parse format: [parsing logic]
   - Validate: [validation requirements]
   - If validation fails: re-prompt subagent with error details
   - Use extracted data for: [specific purpose]

   **If semantic analysis (Pattern 3):**
   - Search for keywords: [list keywords]
   - Identify sections: [list sections]
   - Make decisions based on: [decision criteria]
   - No rigid parsing - interpret semantically

4. **Use findings to:**
   [List specific actions, same as current "Use findings to:" sections]

**Example:**

[Show concrete example of reading and using results for this specific skill]
```

## Application Examples

### Example 1: Adding to codebase-research

**Location:** After Agent 1 dispatch (SKILL.md:34-60)

**Add:**
```
### Consuming Agent 1 Results

**After Task tool returns:**

1. **Result location:** Architecture findings in function_results

2. **Result format:**
   - Project Overview: type, stack, frameworks
   - Directory Structure: organized by purpose
   - Entry Points: file:line references for each
   - Architectural Patterns: documented with examples
   - Module Organization: how code is structured

3. **How to consume (Pattern 1: Narrative):**
   - Read architecture summary from function_results
   - Extract entry point file:line references
   - Note architectural patterns mentioned
   - Identify directory organization

4. **Use findings to populate synthesis:**
   - Architecture Overview section: paste Project Overview and patterns
   - Entry Points section: use file:line references from results
   - Architectural Patterns section: use examples from results

**Example:**
```
Function_results contains:

"Project Overview: This is a React SPA with Express backend
- Stack: React 18, TypeScript, Express, PostgreSQL
- Pattern: Layered architecture with controllers, services, models

Entry Points:
- Backend: src/server.ts:10 (Express app initialization)
- Frontend: src/App.tsx:5 (React root component)

Directory Structure:
- src/controllers/ - Route handlers
- src/services/ - Business logic
- src/models/ - Data models"

Use this to populate:

## Architecture Overview
This is a React SPA with Express backend using layered architecture.
- Entry Points:
  - Backend: src/server.ts:10
  - Frontend: src/App.tsx:5
- Core Patterns: Controllers, services, models separation
```
```

### Example 2: Adding to systematic-debugging

**Location:** After Agent 1 dispatch (SKILL.md:58-74)

**Add:**
```
### Consuming Agent 1 Results (Error Source Discovery)

**After Task tool returns:**

1. **Result location:** Error source findings in function_results

2. **Result format:**
   - Error locations: file paths, line numbers, function names
   - Stack traces: where errors are logged or thrown
   - Trigger conditions: what causes the error
   - Error flow: path from trigger to error

3. **How to consume (Pattern 1: Narrative):**
   - Read error locations from function_results
   - Note all file:line references for errors
   - Identify trigger conditions mentioned
   - Understand error flow described

4. **Use findings to inform Phase 2:**
   - Root cause hypothesis: use error flow and trigger conditions
   - Instrumentation targets: use file:line references for where to add logging
   - Phase 3 investigation: focus on identified trigger conditions

**Example:**
```
Function_results contains:

"Error Source: TypeError in handleSubmit function
- Location: src/forms/UserForm.tsx:127
- Triggered when: user.email is undefined
- Stack trace shows: handleSubmit → validateEmail → throw TypeError
- Related code: src/validation/email.ts:45 (validation logic)

Trigger conditions:
- Occurs when user object missing email field
- Happens on rapid form submissions
- Not caught by earlier validation"

Use this for Phase 2 hypothesis:
"Root cause: Race condition where form submits before email field populates.
Instrumentation: Add logging at UserForm.tsx:127 and validation/email.ts:45"
```
```
