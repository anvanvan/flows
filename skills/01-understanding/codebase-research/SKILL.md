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

**CRITICAL:** Do NOT create temporary files (/tmp, docs/, etc).
Aggregate all findings in memory and return complete report in your final message.
All results must appear in function_results - no file creation.

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

**Consuming Agent 1 Results:**

After Task tool returns, Agent 1's complete architecture report appears in function_results.

**Read and extract:**
- Project Overview → Use for "Executive Summary" in synthesis
- Directory Structure → Use for "Architecture Overview" section
- Entry Points → List with file:line in "Architecture Overview"
- Architectural Patterns → Document in "Architecture Overview"
- Module Organization → Explain in "Architecture Overview"

**No parsing needed** - findings are narrative report matching the requested structure.

**Agent 2 - Core Implementation & Data Flow:**

```python
# Invoke Task tool with:
subagent_type = "Explore"
model = "haiku"
prompt = """
Explore core features and trace data flow.

**CRITICAL:** Do NOT create temporary files (/tmp, docs/, etc).
Aggregate all findings in memory and return complete report in your final message.
All results must appear in function_results - no file creation.

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

**Consuming Agent 2 Results:**

After Task tool returns, Agent 2's implementation and data flow report appears in function_results.

**Read and extract:**
- Feature Inventory → Use for "Key Features" section in synthesis
- Implementation Details → List with file:line in "Key Features"
- Data Flow Diagrams → Copy to "Data Flow" section
- Business Logic Locations → Reference in "Key Features"
- Key Workflows → Document in synthesis

**No parsing needed** - consume narrative report directly.

**Agent 3 - Testing & Quality Infrastructure:**

```python
# Invoke Task tool with:
subagent_type = "Explore"
model = "haiku"
prompt = """
Explore testing infrastructure as it exists.

**CRITICAL:** Do NOT create temporary files (/tmp, docs/, etc).
Aggregate all findings in memory and return complete report in your final message.
All results must appear in function_results - no file creation.

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

**Consuming Agent 3 Results:**

**Read and extract:**
- Test Organization → Use for "Testing Approach" section
- Testing Tools → List frameworks and helpers in synthesis
- Test Patterns → Provide examples in "Testing Approach"
- CI/CD Setup → Document in "Testing Approach" or separate section

**Agent 4 - Development Workflow & Configuration:**

```python
# Invoke Task tool with:
subagent_type = "Explore"
model = "haiku"
prompt = """
Explore development setup and configuration.

**CRITICAL:** Do NOT create temporary files (/tmp, docs/, etc).
Aggregate all findings in memory and return complete report in your final message.
All results must appear in function_results - no file creation.

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

**Consuming Agent 4 Results:**

**Read and extract:**
- Setup Instructions → Use for "Development Workflow" section
- Configuration Files → List with file:line in "Configuration"
- Dev Commands → Provide exact commands in "Development Workflow"
- Documentation Locations → Reference in synthesis

**Agent 5 - Integration Points & Dependencies:**

```python
# Invoke Task tool with:
subagent_type = "Explore"
model = "haiku"
prompt = """
Explore integrations and external dependencies.

**CRITICAL:** Do NOT create temporary files (/tmp, docs/, etc).
Aggregate all findings in memory and return complete report in your final message.
All results must appear in function_results - no file creation.

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

**Consuming Agent 5 Results:**

**Read and extract:**
- External Services → Use for "Integration Points" section
- Database → Document connection and query patterns
- Third-Party Dependencies → List major libraries in synthesis
- Auth Implementation → Explain in "Integration Points"

**Verification Pattern:**
If findings from different agents contradict, dispatch 2-3 additional targeted Explore agents with different search strategies to triangulate truth.

### Phase 2: Synthesis & Onboarding Report

**Synthesize all Explore findings into structured onboarding document:**

**Source of content:** Each section populated from corresponding Agent's function_results:
- Architecture Overview ← Agent 1 results
- Key Features & Data Flow ← Agent 2 results
- Testing Approach ← Agent 3 results
- Development Workflow & Configuration ← Agent 4 results
- Integration Points ← Agent 5 results

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

## Phase 4: Deep Archaeological Investigation (Optional)

**When understanding WHY code exists or evolved this way:**

Use these techniques from knowledge-lineages skill to trace historical context.

**Decision Archaeology:**

```python
# Invoke Task tool with:
subagent_type = "Explore"
model = "haiku"
prompt = """
Explore historical context and decision-making.

**CRITICAL:** Do NOT create temporary files (/tmp, docs/, etc).
Aggregate all findings in memory and return complete report in your final message.
All results must appear in function_results - no file creation.

**Methodology:**
1. Search git log for when key patterns were introduced
2. Find Architecture Decision Records (ADRs) or design docs
3. Locate issue/PR discussions about design choices
4. Trace documentation evolution through git history
5. Find comments explaining "why" in code

**Git Commands to Use:**
- git log -S "pattern" --all (find when pattern introduced)
- git log -p --follow [file] (trace file evolution)
- git log --diff-filter=D --summary (find deleted code)
- git blame -w -C -C -C [file] (historical context)

**Report Structure:**
- Key Decisions: when made, who made them, why
- Alternatives Considered: from PR/issue discussions
- Evolution Timeline: how approach changed over time
- Deleted/Abandoned Approaches: what was tried and removed
- Context Preserved: comments explaining rationale

Thoroughness: very thorough
"""
```

**Consuming Archaeological Results:**

After Task tool returns, historical context report appears in function_results.

**Read and extract:**
- Key Decisions → Understand why current architecture exists
- Alternatives Considered → Learn what was rejected and why
- Evolution Timeline → See how code evolved to current state
- Deleted/Abandoned Approaches → Avoid repeating past mistakes
- Context Preserved → Find wisdom in comments and docs

**Use for:**
- Understanding constraints that shaped current design
- Avoiding proposals that were already tried and failed
- Recognizing when conditions have changed enough to revisit old ideas
- Documenting rationale for future maintainers

**When to Use Archaeological Investigation:**
- Before proposing major architectural changes
- When encountering seemingly irrational design choices
- When team members say "we tried that before"
- When considering reverting to older approaches
- When new team members question established patterns

## Key Principle

**Act as documentarian, not consultant.** Report what exists with precise file:line references, concrete code snippets, and data flow diagrams. Do not suggest improvements unless explicitly requested.
