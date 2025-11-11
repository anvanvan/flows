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
