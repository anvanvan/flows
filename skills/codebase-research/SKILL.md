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
