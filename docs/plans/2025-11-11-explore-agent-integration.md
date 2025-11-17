# Explore Agent Integration Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use flows:subagent-driven-development to implement this plan task-by-task.

**Goal:** Integrate Explore agent usage across flows skills to enable aggressive codebase discovery with token efficiency and accuracy prioritized over speed.

**Architecture:** Phased rollout starting with 2 new skills (codebase-research, pattern-discovery), then enhancing 4 high-impact existing skills (writing-plans, systematic-debugging, subagent-driven-development, handoff), followed by 6 enhancement skills and 5 supporting skills. All integrations use "very thorough" thoroughness by default and verification patterns for contradictions.

**Tech Stack:** Claude Code Task tool with subagent_type=Explore, Markdown skill files, flows plugin infrastructure

---

## Phase 1: New Skills - Codebase Research & Pattern Discovery

### Task 1: Create codebase-research skill directory and structure

**Files:**
- Create: `/Users/tuan/tools/flows/skills/codebase-research/SKILL.md`

**Step 1: Create skill directory**

```bash
mkdir -p /Users/tuan/tools/flows/skills/codebase-research
```

**Step 2: Create SKILL.md with frontmatter and overview**

```markdown
---
name: codebase-research
description: Systematically research and understand unfamiliar codebases using parallel Explore agents. Use when encountering unfamiliar code, new projects, or undocumented systems.
---

# Codebase Research

## Overview

When working with unfamiliar codebases, use this skill to build comprehensive understanding before making changes. Acts as a **technical documentarian** to explain the codebase as it exists through parallel Explore agent dispatch.

## When to Use (Auto-Discovery Triggers)

**using-flows should recommend this skill when it detects:**
- User mentions: "unfamiliar codebase", "don't know this project", "new to this code"
- User asks: "how does X work?", "what does this codebase do?", "where is Y?"
- Task involves debugging or modifying unfamiliar code
- Documentation is missing or outdated
- User is starting work on inherited/legacy code

**Common trigger phrases:**
- "I need to understand this codebase"
- "What does this project do?"
- "Where do I start with this code?"
- "How is X implemented here?"
- "This is a new codebase to me"
```

**Step 3: Commit**

```bash
git add /Users/tuan/tools/flows/skills/codebase-research/SKILL.md && \
  git commit -m "feat: create codebase-research skill structure (Task 1)"
```

### Task 2: Write codebase-research Phase 1 - Multi-dimensional exploration

**Files:**
- Modify: `/Users/tuan/tools/flows/skills/codebase-research/SKILL.md`

**Step 1: Add Phase 1 exploration section**

Append to SKILL.md:

```markdown
## The Process

### Phase 1: Multi-Dimensional Exploration (MANDATORY)

**Dispatch 4-5 Explore agents IN PARALLEL** with thoroughness: "very thorough"

**Agent 1 - Architecture & Entry Points:**

Use Task tool:
```python
# Invoke Task tool with:
subagent_type = "Explore"
model = "haiku"
prompt = """
Explore codebase architecture and entry points.

**Methodology:**
1. Read Entry Points: main files, server.js, app.js, index files, exports
2. Identify project type, tech stack, frameworks used
3. Map directory structure and organization patterns
4. Locate key entry points with file:line references
5. Understand module/package organization
6. Identify architectural patterns (MVC, microservices, layered, etc.)

**Report Structure:**
- Project Overview: type, stack, frameworks
- Directory Structure: organized by purpose
- Entry Points: file:line references for each
- Architectural Patterns: documented with examples
- Module Organization: how code is structured

Thoroughness: very thorough
"""
```

**Agent 2 - Core Implementation & Data Flow:**

```python
# Invoke Task tool with:
subagent_type = "Explore"
model = "haiku"
prompt = """
Explore core features and trace data flow.

**Methodology:**
1. Identify main features/capabilities from entry points
2. Follow Code Paths: trace function calls step-by-step through files
3. Document Key Logic: business logic, validation, transformations
4. Map data flow: inputs → transformations → outputs
5. Locate domain models and business logic with file:line references
6. Understand key workflows end-to-end

**Report Structure:**
- Feature Inventory: what the codebase does
- Implementation Details: file:line for core logic
- Data Flow Diagrams: source → destination with transformations
- Business Logic Locations: precise references
- Key Workflows: documented step-by-step

Thoroughness: very thorough
"""
```

**Agent 3 - Testing & Quality Infrastructure:**

```python
# Invoke Task tool with:
subagent_type = "Explore"
model = "haiku"
prompt = """
Explore testing infrastructure as it exists.

**Methodology:**
1. Find test suite organization and locations
2. Identify testing frameworks, assertion libraries, mocking tools
3. Locate test helpers, fixtures, factories with file:line
4. Document existing test patterns (describe/it structure, naming)
5. Find CI/CD configuration files
6. Document coverage tools and quality gates

**Report Structure:**
- Test Organization: directory structure, naming conventions
- Testing Tools: frameworks, libraries, utilities (with file:line)
- Test Patterns: examples from actual tests
- CI/CD Setup: configuration files and commands
- Quality Gates: coverage requirements, lint rules

**Constraint:** Document testing as it exists, don't suggest improvements.

Thoroughness: very thorough
"""
```

**Agent 4 - Development Workflow & Configuration:**

```python
# Invoke Task tool with:
subagent_type = "Explore"
model = "haiku"
prompt = """
Explore development setup and configuration.

**Methodology:**
1. Find build/run commands in package.json, Makefile, scripts
2. Locate all configuration files: env, config, settings
3. Identify dependency management (package.json, requirements.txt, etc.)
4. Find development documentation (README, CONTRIBUTING, docs/)
5. Understand git workflow from recent commits and branches
6. Document environment requirements

**Report Structure:**
- Setup Instructions: commands to run, dependencies to install
- Configuration Files: file:line for all configs
- Dev Commands: build, run, test, lint with exact commands
- Documentation Locations: READMEs, guides
- Git Workflow: branch patterns, commit conventions observed

Thoroughness: very thorough
"""
```

**Agent 5 - Integration Points & Dependencies:**

```python
# Invoke Task tool with:
subagent_type = "Explore"
model = "haiku"
prompt = """
Explore integrations and external dependencies.

**Methodology:**
1. Find external service integrations with file:line references
2. Locate API clients, database connections, SDK usage
3. Identify third-party libraries: versions, usage patterns
4. Find authentication/authorization implementations
5. Document deployment configuration and requirements
6. Locate environment-specific settings

**Report Structure:**
- External Services: what integrations exist (file:line)
- Database: connection code, query patterns, ORMs
- Third-Party Dependencies: major libraries and their usage
- Auth Implementation: how authentication works (file:line)
- Deployment Config: deployment files and requirements

Thoroughness: very thorough
"""
```

**Verification Pattern:**
If findings from different agents contradict, dispatch 2-3 additional targeted Explore agents with different search strategies to triangulate truth.
```

**Step 2: Commit**

```bash
git add /Users/tuan/tools/flows/skills/codebase-research/SKILL.md && \
  git commit -m "feat: add Phase 1 multi-dimensional exploration to codebase-research (Task 2)"
```

### Task 3: Write codebase-research Phase 2 & 3 - Synthesis and deep-dive

**Files:**
- Modify: `/Users/tuan/tools/flows/skills/codebase-research/SKILL.md`

**Step 1: Add Phase 2 synthesis section**

Append to SKILL.md:

```markdown
### Phase 2: Synthesis & Onboarding Report

**Synthesize all Explore findings into structured onboarding document:**

**Format:**
````markdown
# Codebase Onboarding: [Project Name]

## Executive Summary
[What this codebase does - 2-3 sentences]

## Architecture Overview
[How it's organized - architectural patterns, structure]
- Entry Points: [file:line references]
- Core Patterns: [patterns identified]

## Key Features
[What it includes - feature inventory with file:line]
1. Feature A - implemented in file.js:10-50
2. Feature B - implemented in file.js:60-100

## Data Flow
[How data moves through the system]
Input → [file:line] → Transform → [file:line] → Output

## Development Workflow
[How to work on it]
- Setup: [exact commands]
- Run: [exact commands]
- Test: [exact commands]
- Build: [exact commands]

## Testing Approach
[How to verify changes]
- Framework: [name]
- Patterns: [examples from actual tests]
- Helpers: [file:line references]

## Integration Points
[What it connects to]
- Service A: [file:line]
- Database: [file:line]
- APIs: [file:line]

## Configuration
[Environment and settings]
- Config files: [list with file:line]
- Environment variables: [documented locations]

## Next Steps for [User's Task]
[Specific guidance based on what user wants to do]
````

### Phase 3: Focused Deep-Dive (Optional)

**If user needs specific area understanding, dispatch targeted Explore:**

Use Task tool:
```python
subagent_type = "Explore"
model = "haiku"
prompt = """
Explore [specific feature/module] in detail.

**Methodology:**
1. Read entry point for [feature]
2. Follow code paths step-by-step through implementation
3. Document key logic with file:line references
4. Extract code snippets for critical sections
5. Map data flow specific to this feature

**Report with:**
- Implementation breakdown (numbered sections with line ranges)
- Code snippets showing key logic
- Data flow for this specific feature
- Related files and dependencies

Thoroughness: very thorough
"""
```

## Key Principle

**Act as documentarian, not consultant.** Report what exists with precise file:line references, concrete code snippets, and data flow diagrams. Do not suggest improvements unless explicitly requested.
```

**Step 2: Commit**

```bash
git add /Users/tuan/tools/flows/skills/codebase-research/SKILL.md && \
  git commit -m "feat: add Phase 2 synthesis and Phase 3 deep-dive to codebase-research (Task 3)"
```

### Task 4: Create pattern-discovery skill directory and structure

**Files:**
- Create: `/Users/tuan/tools/flows/skills/pattern-discovery/SKILL.md`

**Step 1: Create skill directory**

```bash
mkdir -p /Users/tuan/tools/flows/skills/pattern-discovery
```

**Step 2: Create SKILL.md with frontmatter and overview**

```markdown
---
name: pattern-discovery
description: Discover and document existing code patterns with concrete examples for consistency and reuse. Use before implementing features to find existing patterns to model after.
---

# Pattern Discovery

## Overview

Use Explore to find patterns, conventions, and reusable code across the codebase. Provides **concrete code examples** rather than just file locations. Acts as **documentarian showing existing patterns as they are.**

## When to Use (Auto-Discovery Triggers)

**using-flows should recommend this skill when it detects:**
- User asks: "how do I implement X?", "what's the pattern for Y?", "how are we doing Z?"
- Before brainstorming new features (find existing similar implementations)
- Before writing-plans (understand patterns to follow)
- User mentions: "consistent with existing code", "follow codebase conventions", "like the other ones"
- During code review when checking pattern adherence

**Common trigger phrases:**
- "How should I implement X?" → "Let me use pattern-discovery to find existing X patterns"
- "What's the convention for Y?" → "Let me discover existing Y patterns"
- "I want this to match existing code" → "Let me find the patterns to match"
- "Show me examples of Z" → "Let me discover Z patterns in the codebase"
- "How are errors handled here?" → "Let me discover error handling patterns"

**Integration with other skills:**
- **brainstorming** → Use pattern-discovery before proposing approaches
- **writing-plans** → Use pattern-discovery to find examples to model after
- **test-driven-development** → Use pattern-discovery to find test patterns
- **subagent-driven-development** → Include pattern-discovery findings in task context
```

**Step 3: Commit**

```bash
git add /Users/tuan/tools/flows/skills/pattern-discovery/SKILL.md && \
  git commit -m "feat: create pattern-discovery skill structure (Task 4)"
```

### Task 5: Write pattern-discovery process and methodology

**Files:**
- Modify: `/Users/tuan/tools/flows/skills/pattern-discovery/SKILL.md`

**Step 1: Add pattern categories and exploration process**

Append to SKILL.md:

```markdown
## The Process

### Pattern Categories

Before dispatching Explore, classify what you're looking for:
- **Feature Patterns**: How similar features are implemented
- **Structural Patterns**: Architecture and organization conventions
- **Integration Patterns**: How external services are integrated
- **Testing Patterns**: How tests are structured and written

### Exploration Phase

**Dispatch Explore agent** with thoroughness: "very thorough"

**Prompt Template:**

Use Task tool:
```python
subagent_type = "Explore"
model = "haiku"
prompt = """
Find and document existing patterns for [specific concern].

**Methodology:**
1. Pattern Identification: Locate all implementations of [pattern]
2. Search Execution: Use Grep/Glob to find relevant code
3. Extraction: Read files and extract pattern sections with context
4. Documentation: Present with file:line, code snippets, use cases

**For each pattern found, provide:**
- Pattern Name & Location (file:line-line range)
- Use Case: What this pattern accomplishes
- Code Snippet: Actual implementation (5-20 lines)
- Key Aspects: Important elements highlighted
- Variations: Different approaches if multiple exist
- Related Utilities: Helper functions or shared code used

**Return structured report with:**
1. Primary Pattern (most common/mature implementation)
   - file:line-line
   - Code snippet
   - Usage notes

2. Pattern Variations (alternative approaches)
   - file:line-line for each
   - Code snippets
   - When each is used

3. Testing Patterns (how these patterns are tested)
   - file:line for tests
   - Test code snippets

4. Related Code (utilities, helpers, shared components)
   - file:line references
   - Brief descriptions

Thoroughness: very thorough
"""
```

**Verification Pattern:**
If findings seem incomplete or contradictory, dispatch 2-3 additional Explore agents with different search strategies (keyword variations, alternative patterns, different scopes).
```

**Step 2: Commit**

```bash
git add /Users/tuan/tools/flows/skills/pattern-discovery/SKILL.md && \
  git commit -m "feat: add pattern categories and exploration process to pattern-discovery (Task 5)"
```

### Task 6: Write pattern-discovery report structure and common use cases

**Files:**
- Modify: `/Users/tuan/tools/flows/skills/pattern-discovery/SKILL.md`

**Step 1: Add report structure section**

Append to SKILL.md:

```markdown
### Report Structure

**Standard Pattern Documentation:**

````markdown
# Pattern: [Pattern Name]

## Primary Implementation

**Location:** file.js:10-35

**Use Case:** [What this accomplishes]

**Code:**
```language
[Actual code snippet]
```

**Key Aspects:**
- Aspect 1: [Explanation]
- Aspect 2: [Explanation]

## Variations

### Variation A
**Location:** other.js:45-60
**When Used:** [Context for this variation]
**Code:**
```language
[Code snippet]
```

### Variation B
**Location:** another.js:100-120
**When Used:** [Context]
**Code:**
```language
[Code snippet]
```

## Testing Patterns

**Test Location:** test/file.test.js:20-40
**Code:**
```language
[Test code snippet]
```

## Related Utilities

- **Helper Function:** utils.js:15-25 - [Brief description]
- **Shared Component:** shared.js:30-50 - [Brief description]

## Usage in Codebase

Found in: [Number] locations
- file1.js:line
- file2.js:line
- file3.js:line
````

### Common Pattern Discovery Use Cases

**Error Handling:**
"Find error handling patterns: try-catch structures, error logging, error response formatting, custom error classes"

**Validation:**
"Find validation patterns: input validation, schema validation, business rule enforcement, sanitization techniques"

**API Endpoints:**
"Find API endpoint patterns: route handler structures, request validation, response formatting, error handling in endpoints"

**Database Queries:**
"Find database query patterns: ORM usage, raw query patterns, transaction handling, connection management"

**Component Organization (React/Vue):**
"Find component patterns: component structure conventions, props validation, state management, lifecycle usage"

**Authentication/Authorization:**
"Find auth patterns: login flow implementations, token handling, permission checking, session management"

## Key Principles

1. **Show, Don't Tell**: Provide actual code snippets, not descriptions
2. **Precise References**: Use file:line-line ranges for all examples
3. **Document As-Is**: Show patterns as they exist, don't evaluate quality
4. **Multiple Examples**: Show variations when they exist
5. **Include Tests**: Show how patterns are tested
6. **Related Code**: Point to utilities and helpers used by patterns

## Constraints

**DO:**
- Provide concrete code examples with file:line
- Show multiple variations when they exist
- Include testing patterns
- Document usage frequency and locations

**DO NOT:**
- Suggest pattern improvements
- Identify anti-patterns or bad practices
- Recommend which pattern to use
- Perform comparative analysis or evaluation
- Critique pattern quality

**Role:** Documentarian showing what exists, not consultant evaluating quality.
```

**Step 2: Commit**

```bash
git add /Users/tuan/tools/flows/skills/pattern-discovery/SKILL.md && \
  git commit -m "feat: add report structure and common use cases to pattern-discovery (Task 6)"
```

## Phase 2: High-Impact Core Skills - Enhance Existing Skills

### Task 7: Enhance writing-plans with architecture discovery

**Files:**
- Modify: `/Users/tuan/tools/flows/skills/writing-plans/SKILL.md`

**Step 1: Read current writing-plans skill**

```bash
cat /Users/tuan/tools/flows/skills/writing-plans/SKILL.md
```

Identify insertion point: After "Plan Document Header" section, before "Task Structure"

**Step 2: Add codebase architecture discovery section**

Insert after line ~60 (after Plan Document Header section):

```markdown
## Step 1: Codebase Architecture Discovery (MANDATORY)

**Before writing tasks, dispatch Explore agent** with thoroughness: "very thorough"

Use Task tool:
```python
subagent_type = "Explore"
model = "haiku"
prompt = """
Explore the codebase to understand architecture and locate components for [feature description].

I need you to:
1. Identify project structure (directory organization, module patterns)
2. Find similar existing features/implementations to model after
3. Locate all relevant components: models, controllers, services, tests, configs
4. Identify testing patterns and locations
5. Find validation/error handling patterns
6. Document naming conventions and code organization patterns

Return:
- Architecture summary (project structure, key directories)
- Similar implementations (file paths + brief description)
- Relevant component locations (organized by layer/responsibility)
- Testing file patterns and locations
- Naming conventions observed

Thoroughness: very thorough
"""
```

**Use findings to:**
- Generate accurate file paths in task descriptions
- Model task structure after existing patterns
- Reference exact locations for tests, configs, validation points
- Follow codebase naming conventions

**If findings contradict observations:**
Dispatch 2-3 additional Explore agents in parallel with different search strategies to triangulate truth.
```

**Step 3: Commit**

```bash
git add /Users/tuan/tools/flows/skills/writing-plans/SKILL.md && \
  git commit -m "feat: add mandatory codebase architecture discovery to writing-plans (Task 7)"
```

### Task 8: Enhance systematic-debugging with multi-domain exploration

**Files:**
- Modify: `/Users/tuan/tools/flows/skills/systematic-debugging/SKILL.md`

**Step 1: Read current systematic-debugging skill**

```bash
cat /Users/tuan/tools/flows/skills/systematic-debugging/SKILL.md
```

Identify insertion point: Within "Phase 1: Root Cause Investigation" section

**Step 2: Add multi-domain exploration subsection**

Insert after Phase 1 header (around line ~40):

```markdown
### Step 1: Multi-Domain Exploration (MANDATORY)

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

Return: File paths, line numbers, function names, error flow

Thoroughness: very thorough
"""
```

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

Return: Component map, data flow diagram, configuration locations

Thoroughness: very thorough
"""
```

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

Return: Similar issues found, relevant comments, workarounds

Thoroughness: medium
"""
```

**Verification pattern:**
If findings conflict, dispatch additional targeted Explore agents to clarify specific contradictions.

**Use findings for:**
- Accurate root cause hypothesis in Phase 2
- Comprehensive instrumentation targets in Phase 3
- Complete fix coverage in Phase 4
```

**Step 3: Commit**

```bash
git add /Users/tuan/tools/flows/skills/systematic-debugging/SKILL.md && \
  git commit -m "feat: add multi-domain exploration to systematic-debugging Phase 1 (Task 8)"
```

### Task 9: Enhance subagent-driven-development with context discovery

**Files:**
- Modify: `/Users/tuan/tools/flows/skills/subagent-driven-development/SKILL.md`

**Step 1: Read current subagent-driven-development skill**

```bash
cat /Users/tuan/tools/flows/skills/subagent-driven-development/SKILL.md
```

Identify insertion point: Before "Dispatch First Task Agent" section

**Step 2: Add pre-execution context discovery section**

Insert before task dispatch (around line ~50):

```markdown
## Pre-Execution: Task Context Discovery (MANDATORY)

**Before dispatching first task agent, run Explore** with thoroughness: "very thorough"

Use Task tool:
```python
subagent_type = "Explore"
model = "haiku"
prompt = """
Explore codebase to gather context for [feature implementation]:
1. Find all relevant existing code (similar features, utilities, patterns)
2. Locate test files and testing patterns to follow
3. Identify configuration, dependencies, or setup required
4. Find any constraints, anti-patterns, or deprecations to avoid
5. Map component relationships and integration points

Return:
- Existing code to reference (file paths + descriptions)
- Testing patterns and locations
- Configuration/setup requirements
- Constraints and patterns to follow
- Component relationship map

Thoroughness: very thorough
"""
```

**Share findings with all task agents:**
Each task agent receives:
- Relevant Explore findings for their task
- References to existing patterns to follow
- Testing expectations based on discovered patterns

**Per-task targeted Explore (optional):**
If a task agent needs additional context, can dispatch targeted Explore with thoroughness: medium
```

**Step 3: Commit**

```bash
git add /Users/tuan/tools/flows/skills/subagent-driven-development/SKILL.md && \
  git commit -m "feat: add mandatory context discovery to subagent-driven-development (Task 9)"
```

### Task 10: Enhance handoff with modified files analysis and issue context

**Files:**
- Modify: `/Users/tuan/tools/flows/skills/handoff/SKILL.md`

**Step 1: Read current handoff skill**

```bash
cat /Users/tuan/tools/flows/skills/handoff/SKILL.md
```

Identify the existing Explore usage section (around line 78-92)

**Step 2: Expand to 3 parallel Explore agents**

Replace existing Explore section with:

```markdown
## Context Extraction: Multi-Faceted Exploration

**Dispatch 3 Explore agents IN PARALLEL** for comprehensive handoff:

**Agent 1 - Commit History (EXISTING):**

Use Task tool:
```python
subagent_type = "Explore"
model = "haiku"
prompt = """
Use git log to fetch commit history for [branch/feature].

Return: Commit SHAs, messages, authors, dates

Thoroughness: medium
"""
```

**Agent 2 - Modified Files Analysis (NEW):**

```python
subagent_type = "Explore"
model = "haiku"
prompt = """
Explore modified files to understand changes:
1. Identify all files changed in recent commits
2. Understand purpose of each modified file
3. Find related files not yet modified (potential incompleteness)
4. Locate tests covering modified code
5. Find documentation that needs updating

Return: File inventory with purpose, related files, test coverage, doc status

Thoroughness: very thorough
"""
```

**Agent 3 - Issue Context Discovery (NEW):**

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

Thoroughness: very thorough
"""
```

**Handoff document includes:**
- Git history (commits, SHAs)
- File inventory with purpose and relationships
- Test coverage assessment
- Related code not yet addressed
- Issue context from codebase
```

**Step 3: Commit**

```bash
git add /Users/tuan/tools/flows/skills/handoff/SKILL.md && \
  git commit -m "feat: enhance handoff with modified files and issue context Explore agents (Task 10)"
```

## Phase 3: Enhancement Skills

### Task 11: Enhance brainstorming with pattern discovery before proposing approaches

**Files:**
- Modify: `/Users/tuan/tools/flows/skills/brainstorming/SKILL.md`

**Step 1: Read current brainstorming skill**

```bash
cat /Users/tuan/tools/flows/skills/brainstorming/SKILL.md
```

Identify insertion point: In "Exploring approaches" section

**Step 2: Add pattern discovery before approach proposals**

Insert at beginning of "Exploring approaches" section (around line ~30):

```markdown
## Before Proposing Approaches: Pattern Discovery

**If designing NEW features, dispatch Explore agent** with thoroughness: "very thorough"

Use Task tool:
```python
subagent_type = "Explore"
model = "haiku"
prompt = """
Explore the codebase to find existing patterns relevant to [feature description].

I need you to:
1. Find similar features already implemented
2. Identify architectural patterns in use (MVC, layered, microservices, etc.)
3. Locate reusable components or utilities that could be leveraged
4. Find testing patterns and frameworks in use
5. Identify any anti-patterns or deprecated approaches to avoid

Return:
- Existing similar implementations (file paths + how they work)
- Architectural patterns observed (with examples)
- Reusable components found (file paths + purpose)
- Testing approaches in use (frameworks, patterns, coverage)
- Any patterns to avoid (with reasoning)

Thoroughness: very thorough
"""
```

**Use findings to:**
- Propose approaches that fit existing architecture
- Leverage existing components rather than reinventing
- Suggest testing strategies that match current patterns
- Avoid recommending patterns that contradict codebase conventions
```

**Step 3: Commit**

```bash
git add /Users/tuan/tools/flows/skills/brainstorming/SKILL.md && \
  git commit -m "feat: add pattern discovery before approaches in brainstorming (Task 11)"
```

### Task 12: Enhance test-driven-development with test pattern discovery

**Files:**
- Modify: `/Users/tuan/tools/flows/skills/test-driven-development/SKILL.md`

**Step 1: Read current test-driven-development skill**

```bash
cat /Users/tuan/tools/flows/skills/test-driven-development/SKILL.md
```

Identify insertion point: Before RED-GREEN-REFACTOR cycle

**Step 2: Add test pattern discovery section**

Insert before RED phase (around line ~20):

```markdown
## Before Writing Test: Test Pattern Discovery

**Dispatch Explore agent** with thoroughness: "very thorough"

Use Task tool:
```python
subagent_type = "Explore"
model = "haiku"
prompt = """
Explore to find testing patterns for [feature/component]:
1. Locate existing tests for similar features
2. Identify test framework, assertion library, mocking patterns in use
3. Find test fixtures, factories, or helpers available
4. Understand test organization (describe/it structure, naming conventions)
5. Locate test utilities or custom matchers

Return:
- Example test files to model after (file paths + structure)
- Testing tools and patterns in use
- Available test helpers/fixtures
- Naming and organization conventions
- Setup/teardown patterns

Thoroughness: very thorough
"""
```

**Write test matching discovered patterns:**
- Use same test framework structure
- Leverage existing fixtures/helpers
- Follow naming conventions
- Match assertion styles

Then proceed to RED phase (watch test fail).
```

**Step 3: Commit**

```bash
git add /Users/tuan/tools/flows/skills/test-driven-development/SKILL.md && \
  git commit -m "feat: add test pattern discovery to test-driven-development (Task 12)"
```

### Task 13: Enhance requesting-code-review with completeness verification

**Files:**
- Modify: `/Users/tuan/tools/flows/skills/requesting-code-review/SKILL.md`

**Step 1: Read current requesting-code-review skill**

```bash
cat /Users/tuan/tools/flows/skills/requesting-code-review/SKILL.md
```

Identify insertion point: Before "Dispatch code-reviewer agent" section

**Step 2: Add pre-review completeness verification**

Insert before code-reviewer dispatch (around line ~25):

```markdown
## Pre-Review: Completeness Verification

**Before requesting code-reviewer, dispatch Explore agent** with thoroughness: "very thorough"

Use Task tool:
```python
subagent_type = "Explore"
model = "haiku"
prompt = """
Explore to verify implementation completeness for [feature]:
1. Find all files that should be modified for this feature (based on similar features)
2. Locate test files that should cover this implementation
3. Identify documentation that should be updated
4. Find configuration or migration files that might need changes
5. Locate any integration points or dependent code

Return:
- Expected file modifications (based on patterns)
- Test coverage expectations
- Documentation update requirements
- Configuration/migration needs
- Integration points to verify

Compare against actual changes made.

Thoroughness: very thorough
"""
```

**Pass findings to code-reviewer agent:**
Include Explore report in review context so code-reviewer can:
- Verify all expected files were modified
- Check for missing tests
- Identify missing documentation updates
- Flag incomplete integration coverage
```

**Step 3: Commit**

```bash
git add /Users/tuan/tools/flows/skills/requesting-code-review/SKILL.md && \
  git commit -m "feat: add completeness verification to requesting-code-review (Task 13)"
```

### Task 14: Enhance defense-in-depth with validation point discovery

**Files:**
- Modify: `/Users/tuan/tools/flows/skills/defense-in-depth/SKILL.md`

**Step 1: Read current defense-in-depth skill**

```bash
cat /Users/tuan/tools/flows/skills/defense-in-depth/SKILL.md
```

Identify insertion point: Before layer implementation sections

**Step 2: Add validation point discovery for each layer**

Insert before layer descriptions (around line ~25):

```markdown
## Layer Implementation: Validation Point Discovery

**For each layer, dispatch Explore agent** with thoroughness: "very thorough"

**Layer 1 - Entry Point Discovery:**

Use Task tool:
```python
subagent_type = "Explore"
model = "haiku"
prompt = """
Explore to find all entry points for [feature/module]:
1. API endpoints, route handlers, CLI commands
2. Event handlers, message queue consumers
3. Public class methods, exported functions
4. Form inputs, user interactions

Return: All entry points with file paths and signatures

Thoroughness: very thorough
"""
```

**Layer 2 - Business Logic Discovery:**

```python
subagent_type = "Explore"
model = "haiku"
prompt = """
Explore to find business logic validation points:
1. Service methods, domain logic functions
2. State transition validations
3. Business rule enforcement locations
4. Data consistency checks

Return: Business logic locations requiring validation

Thoroughness: very thorough
"""
```

**Layer 3 - Environment Discovery:**

```python
subagent_type = "Explore"
model = "haiku"
prompt = """
Explore to find environment interaction points:
1. Database queries, ORM operations
2. External API calls, HTTP clients
3. File system operations
4. Cache access, session management

Return: All boundary points with external systems

Thoroughness: very thorough
"""
```

**Use findings to:**
- Implement validation at EVERY identified point
- Ensure no gaps in validation coverage
- Add instrumentation for debugging at key boundaries
```

**Step 3: Commit**

```bash
git add /Users/tuan/tools/flows/skills/defense-in-depth/SKILL.md && \
  git commit -m "feat: add validation point discovery to defense-in-depth (Task 14)"
```

### Task 15: Enhance finishing-a-development-branch with cleanup detection

**Files:**
- Modify: `/Users/tuan/tools/flows/skills/finishing-a-development-branch/SKILL.md`

**Step 1: Read current finishing-a-development-branch skill**

```bash
cat /Users/tuan/tools/flows/skills/finishing-a-development-branch/SKILL.md
```

Identify insertion point: Before presenting merge/PR options

**Step 2: Add pre-finish completeness check**

Insert before options presentation (around line ~30):

```markdown
## Pre-Finish: Completeness Check

**Before presenting options, dispatch Explore agent** with thoroughness: "very thorough"

Use Task tool:
```python
subagent_type = "Explore"
model = "haiku"
prompt = """
Explore to verify branch is complete:
1. Find any TODOs, FIXMEs, or temporary code added during work
2. Locate debug logging or console statements added
3. Identify commented-out code or experimental changes
4. Find any test.skip, test.only, or temporary test modifications
5. Locate documentation that needs updating based on changes

Return:
- Cleanup items needed before merging
- Temporary code to remove or explain
- Documentation gaps
- Test modifications to address

Thoroughness: very thorough
"""
```

**If cleanup found:**
Present cleanup checklist before offering merge/PR options.

**If clean:**
Proceed to merge/PR options.
```

**Step 3: Commit**

```bash
git add /Users/tuan/tools/flows/skills/finishing-a-development-branch/SKILL.md && \
  git commit -m "feat: add cleanup detection to finishing-a-development-branch (Task 15)"
```

### Task 16: Enhance verification-before-completion with command discovery

**Files:**
- Modify: `/Users/tuan/tools/flows/skills/verification-before-completion/SKILL.md`

**Step 1: Read current verification-before-completion skill**

```bash
cat /Users/tuan/tools/flows/skills/verification-before-completion/SKILL.md
```

Identify insertion point: At beginning of verification process

**Step 2: Add verification command discovery section**

Insert at beginning (around line ~15):

```markdown
## Verification Command Discovery

**Before claiming completion, dispatch Explore** with thoroughness: "medium"

Use Task tool:
```python
subagent_type = "Explore"
model = "haiku"
prompt = """
Explore to find verification commands for this project:
1. Locate test running commands (package.json scripts, Makefile, etc.)
2. Find linter/formatter commands
3. Identify build/compile commands
4. Locate any pre-commit hooks or CI checks
5. Find coverage requirements or quality gates

Return:
- Test commands to run
- Linting/formatting commands
- Build/compile commands
- Pre-commit checks
- Coverage/quality thresholds

Thoroughness: medium
"""
```

**Run all discovered verification commands:**
Evidence collected from actual command output.

**Only claim completion if all pass.**
```

**Step 3: Commit**

```bash
git add /Users/tuan/tools/flows/skills/verification-before-completion/SKILL.md && \
  git commit -m "feat: add verification command discovery to verification-before-completion (Task 16)"
```

## Phase 4: Supporting Skills

### Task 17: Enhance root-cause-tracing with call chain discovery

**Files:**
- Modify: `/Users/tuan/tools/flows/skills/root-cause-tracing/SKILL.md`

**Step 1: Read current root-cause-tracing skill**

```bash
cat /Users/tuan/tools/flows/skills/root-cause-tracing/SKILL.md
```

Identify insertion point: Before manual tracing process

**Step 2: Add tracing preparation section**

Insert before tracing steps (around line ~20):

```markdown
## Tracing Preparation: Call Chain Discovery

**Before manual tracing, dispatch Explore agent** with thoroughness: "very thorough"

Use Task tool:
```python
subagent_type = "Explore"
model = "haiku"
prompt = """
Explore to map the complete call chain for [error location]:
1. Find all callers of [function/method where error occurs]
2. Trace data flow backward: where does [problematic data] originate?
3. Identify all entry points that could reach this code path
4. Locate initialization, configuration, or setup code that affects this chain
5. Find any middleware, decorators, or interceptors in the chain

Return:
- Call chain map (from entry points to error location)
- Data origin points (where values are first set/created)
- All intermediate transformations
- Configuration/setup that affects behavior

Thoroughness: very thorough
"""
```

**Use findings to:**
- Know exact tracing path before instrumenting
- Identify likely root cause locations upfront
- Instrument all relevant points in single pass
```

**Step 3: Commit**

```bash
git add /Users/tuan/tools/flows/skills/root-cause-tracing/SKILL.md && \
  git commit -m "feat: add call chain discovery to root-cause-tracing (Task 17)"
```

### Task 18: Enhance executing-plans with plan validation

**Files:**
- Modify: `/Users/tuan/tools/flows/skills/executing-plans/SKILL.md`

**Step 1: Read current executing-plans skill**

```bash
cat /Users/tuan/tools/flows/skills/executing-plans/SKILL.md
```

Identify insertion point: After loading plan, before starting batch 1

**Step 2: Add plan context loading section**

Insert after plan load (around line ~25):

```markdown
## Pre-Execution: Plan Context Loading (MANDATORY)

**After loading plan, before starting batch 1, dispatch Explore** with thoroughness: "very thorough"

Use Task tool:
```python
subagent_type = "Explore"
model = "haiku"
prompt = """
Explore codebase to verify plan context for [feature from plan]:
1. Verify all file paths mentioned in plan exist and are current
2. Find any codebase changes since plan was written that affect tasks
3. Locate additional context not in plan (recent refactors, new patterns)
4. Identify any risks or conflicts with current codebase state
5. Find updated dependencies, configurations, or requirements

Return:
- Plan accuracy assessment (paths valid, assumptions current)
- Codebase changes affecting plan
- Additional context needed
- Risks or conflicts identified
- Updated requirements

Thoroughness: very thorough
"""
```

**If discrepancies found:**
Report to user:
"Plan is from [date]. Codebase changes detected:
- [Changes affecting plan]
- [Risks identified]

Options:
1. Update plan to reflect current codebase
2. Proceed with plan and adapt as needed
3. Cancel execution for plan revision"

**Per-batch targeted Explore (optional):**
Before each batch, can dispatch focused Explore for batch-specific context.
```

**Step 3: Commit**

```bash
git add /Users/tuan/tools/flows/skills/executing-plans/SKILL.md && \
  git commit -m "feat: add plan validation to executing-plans (Task 18)"
```

### Task 19: Enhance using-git-worktrees with structure discovery

**Files:**
- Modify: `/Users/tuan/tools/flows/skills/using-git-worktrees/SKILL.md`

**Step 1: Read current using-git-worktrees skill**

```bash
cat /Users/tuan/tools/flows/skills/using-git-worktrees/SKILL.md
```

Identify insertion point: After worktree creation

**Step 2: Add post-worktree structure discovery**

Insert after worktree creation steps (around line ~40):

```markdown
## Post-Worktree: Structure Discovery

**After creating worktree, dispatch Explore agent** with thoroughness: "very thorough"

Use Task tool:
```python
subagent_type = "Explore"
model = "haiku"
prompt = """
Explore the worktree structure at [worktree-path]:
1. Identify project structure and key directories
2. Locate build configuration, dependencies, environment setup
3. Find test setup and running instructions
4. Identify any workspace-specific configuration
5. Locate documentation for getting started

Return:
- Project structure overview
- Setup requirements (dependencies, environment)
- Test running commands
- Key entry points and documentation

Thoroughness: very thorough
"""
```

**Provide to user:**
"Worktree created at [path]. Here's the structure:
[Explore findings]

Ready to work on [feature]."
```

**Step 3: Commit**

```bash
git add /Users/tuan/tools/flows/skills/using-git-worktrees/SKILL.md && \
  git commit -m "feat: add structure discovery to using-git-worktrees (Task 19)"
```

### Task 20: Enhance testing-anti-patterns with anti-pattern detection (optional)

**Files:**
- Modify: `/Users/tuan/tools/flows/skills/testing-anti-patterns/SKILL.md`

**Step 1: Read current testing-anti-patterns skill**

```bash
cat /Users/tuan/tools/flows/skills/testing-anti-patterns/SKILL.md
```

Identify insertion point: Add as optional new section at end

**Step 2: Add optional anti-pattern detection section**

Append to end of skill:

```markdown
## Anti-Pattern Detection (Optional Enhancement)

**When user requests "check for testing anti-patterns", dispatch Explore** with thoroughness: "very thorough"

Use Task tool:
```python
subagent_type = "Explore"
model = "haiku"
prompt = """
Explore test suite to detect anti-patterns:
1. Find tests that mock everything and test no real behavior
2. Locate production code with test-only methods (testable flags, test helpers in prod)
3. Identify tests that don't verify real behavior (only check mocks were called)
4. Find over-mocked tests (mocking dependencies without understanding)
5. Locate tests that would pass even if implementation is broken

Return:
- Anti-pattern instances found (file paths, line numbers)
- Severity assessment
- Recommended fixes

Thoroughness: very thorough
"""
```

**Generate anti-pattern report with examples and fixes.**
```

**Step 3: Commit**

```bash
git add /Users/tuan/tools/flows/skills/testing-anti-patterns/SKILL.md && \
  git commit -m "feat: add optional anti-pattern detection to testing-anti-patterns (Task 20)"
```

### Task 21: Enhance writing-skills with skill ecosystem understanding

**Files:**
- Modify: `/Users/tuan/tools/flows/skills/writing-skills/SKILL.md`

**Step 1: Read current writing-skills skill**

```bash
cat /Users/tuan/tools/flows/skills/writing-skills/SKILL.md
```

Identify insertion point: Before writing new skill

**Step 2: Add skill context discovery section**

Insert before skill writing process (around line ~30):

```markdown
## Skill Context Discovery (Before Writing)

**Before writing new skill, dispatch Explore** with thoroughness: "very thorough"

Use Task tool:
```python
subagent_type = "Explore"
model = "haiku"
prompt = """
Explore existing skills to understand landscape for [proposed skill topic]:
1. Find existing skills that cover similar territory
2. Identify gaps or overlaps with proposed skill
3. Locate skills that would reference this new skill
4. Find skills this new skill would reference
5. Understand skill patterns and conventions in use

Return:
- Related existing skills (file paths + overlap analysis)
- Gap analysis (what's missing that new skill would fill)
- Integration points (which skills would interact)
- Naming and structure conventions to follow

Thoroughness: very thorough
"""
```

**Use findings to:**
- Avoid duplicating existing skills
- Fill actual gaps in skill coverage
- Design skill to integrate well with existing skills
- Follow established skill conventions
```

**Step 3: Commit**

```bash
git add /Users/tuan/tools/flows/skills/writing-skills/SKILL.md && \
  git commit -m "feat: add skill context discovery to writing-skills (Task 21)"
```

## Phase 5: Update using-flows for Auto-Discovery

### Task 22: Update using-flows with codebase research and pattern discovery triggers

**Files:**
- Modify: `/Users/tuan/tools/flows/skills/using-flows/SKILL.md`

**Step 1: Read current using-flows skill**

```bash
cat /Users/tuan/tools/flows/skills/using-flows/SKILL.md
```

Identify insertion point: After "Common Rationalizations" section

**Step 2: Add new codebase research skills discovery section**

Insert after "Common Rationalizations" section (around line ~50):

```markdown
## Discovering Codebase Research Skills

**NEW: When user mentions unfamiliar code or asks "how does X work?":**

Check if these skills apply:
- **codebase-research** - For understanding unfamiliar codebases comprehensively
- **pattern-discovery** - For finding existing patterns before implementing features

**Trigger detection patterns:**

If user says:
- "I don't know this codebase" → Recommend codebase-research
- "How does authentication work here?" → Recommend codebase-research
- "What's the pattern for API endpoints?" → Recommend pattern-discovery
- "I want to implement X like the others" → Recommend pattern-discovery
- "Show me examples of Y" → Recommend pattern-discovery
- "Where do I start?" → Recommend codebase-research

**Proactive recommendation:**
When a skill like brainstorming, writing-plans, or systematic-debugging would benefit from codebase context, proactively suggest:
"Before proceeding, would you like me to use codebase-research to understand the existing codebase structure?"
```

**Step 3: Commit**

```bash
git add /Users/tuan/tools/flows/skills/using-flows/SKILL.md && \
  git commit -m "feat: add codebase-research and pattern-discovery auto-discovery to using-flows (Task 22)"
```

## Completion

### Task 23: Create summary document of Explore integration

**Files:**
- Create: `/Users/tuan/tools/flows/docs/explore-agent-integration-summary.md`

**Step 1: Write summary document**

```markdown
# Explore Agent Integration Summary

## Overview

This document summarizes the comprehensive Explore agent integration across the flows plugin, completed on 2025-11-11.

## Philosophy

- **Aggressive Explore-first**: Use Explore for almost any codebase search, even targeted ones
- **Thoroughness bias**: Default to "very thorough", err on comprehensive side
- **Accuracy over speed**: Token savings and completeness prioritized over execution speed
- **Verification pattern**: Dispatch 2-3 additional Explores when findings contradict

## New Skills Created

1. **codebase-research** (`/Users/tuan/tools/flows/skills/codebase-research/SKILL.md`)
   - Systematic unfamiliar codebase exploration
   - 5 parallel Explore agents for architecture, implementation, testing, dev workflow, integrations
   - Auto-discovery triggers: "unfamiliar codebase", "how does X work?", "where is Y?"

2. **pattern-discovery** (`/Users/tuan/tools/flows/skills/pattern-discovery/SKILL.md`)
   - Find existing code patterns with concrete examples
   - Structured report format with file:line references and code snippets
   - Auto-discovery triggers: "how do I implement X?", "what's the pattern for Y?"

## Skills Enhanced with Explore Integration

### Phase 2: High-Impact Core (4 skills)
- **writing-plans** - Mandatory architecture discovery before task creation
- **systematic-debugging** - Multi-domain parallel exploration (error source, components, patterns)
- **subagent-driven-development** - Context discovery before dispatching task agents
- **handoff** - Enhanced with 3 parallel agents (commits, modified files, issue context)

### Phase 3: Enhancement (6 skills)
- **brainstorming** - Pattern discovery before proposing approaches
- **test-driven-development** - Test pattern discovery before writing tests
- **requesting-code-review** - Completeness verification before review
- **defense-in-depth** - Validation point discovery for all 4 layers
- **finishing-a-development-branch** - Cleanup detection before merge/PR
- **verification-before-completion** - Command discovery for project-appropriate verification

### Phase 4: Supporting (5 skills)
- **root-cause-tracing** - Call chain discovery before manual tracing
- **executing-plans** - Plan validation against current codebase state
- **using-git-worktrees** - Structure discovery after worktree creation
- **testing-anti-patterns** - Optional anti-pattern detection on demand
- **writing-skills** - Skill ecosystem understanding before creating new skills

### Phase 5: Discovery (1 skill)
- **using-flows** - Auto-discovery triggers for codebase-research and pattern-discovery

## Total Impact

- **21 existing skills** enhanced with Explore integration
- **2 new skills** enabled by Explore capabilities
- **23 total skills** now leverage Explore agent
- **Estimated 60-80% token reduction** for multi-search workflows
- **Accuracy and completeness** prioritized throughout

## Key Patterns

### Explore Invocation Pattern
```python
# Via Task tool
subagent_type = "Explore"
model = "haiku"  # Cost-effective default
prompt = """[Detailed prompt with methodology]"""
thoroughness = "very thorough"  # Default, use "medium" only if well-scoped
```

### Verification Pattern
When findings contradict or seem incomplete:
- Dispatch 2-3 additional Explore agents in parallel
- Use different search strategies, keyword variations, scopes
- Triangulate truth from multiple reports

### Integration Pattern
1. Dispatch Explore before taking action
2. Use findings as source of truth
3. Reference Explore results in subsequent steps
4. Include file:line references in all outputs

## Success Metrics

**Quality (PRIMARY):**
- ✅ Completeness: All relevant files found
- ✅ Accuracy: file:line references correct
- ✅ Consistency: Implementations match existing patterns
- ✅ Thoroughness: All variations and edge cases discovered

**Efficiency (SECONDARY):**
- Token savings: 60-80% reduction for multi-search workflows
- Context cleanliness: Isolated Explore contexts prevent pollution

## Next Steps

1. Test integration with real-world usage
2. Gather feedback on Explore prompt effectiveness
3. Refine thoroughness level defaults based on actual performance
4. Consider additional skills that could benefit from Explore
5. Monitor token usage and quality metrics

## Implementation Date

2025-11-11

## Implementation Method

flows:subagent-driven-development with code review between tasks
```

**Step 2: Commit**

```bash
git add /Users/tuan/tools/flows/docs/explore-agent-integration-summary.md && \
  git commit -m "docs: add Explore agent integration summary (Task 23)"
```

---

## Plan Complete

**Total Tasks:** 23 bite-sized tasks across 5 phases
**Estimated Time:** 2-5 minutes per task = 46-115 minutes total
**Skills Modified:** 21 existing + 2 new = 23 total
**Commits:** 23 (one per task)
**Testing Strategy:** @flows:testing-skills-with-subagents for new skills, manual validation for enhanced skills
