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
