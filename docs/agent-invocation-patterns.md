# Agent Invocation Patterns

## Overview

This document explains when and how to invoke agents in the flows plugin. Agents can be triggered through multiple mechanisms, and understanding which to use improves efficiency and integration.

---

## Agent Types

### 1. Explore Agent
- **Type:** `subagent_type = "Explore"`
- **Model:** haiku (cost-effective)
- **Purpose:** Codebase exploration, architecture discovery, pattern finding
- **Invocation:** Task tool only (programmatic)

### 2. Code-Reviewer Agent
- **Type:** `flows:code-reviewer`
- **Model:** sonnet
- **Purpose:** Review implementations against requirements
- **Invocation:** Task tool only (via requesting-code-review skill)

### 3. Web-Researcher Agent
- **Type:** `flows:web-researcher` or `@agent-web-researcher`
- **Model:** sonnet
- **Purpose:** Research current docs, APIs, best practices
- **Invocation:** Hook-based (automatic) or manual

### 4. General-Purpose Agent
- **Type:** `subagent_type = "general-purpose"`
- **Purpose:** Task implementation, issue fixing
- **Invocation:** Task tool (via subagent-driven-development)

---

## Invocation Mechanisms

### Hook-Based Invocation (Automatic)

**When it triggers:**
- SessionStart hook: Injects using-flows skill automatically
- UserPromptSubmit hook: Detects research keywords and suggests web-researcher

**Keywords that trigger web-researcher:**
- "research online..."
- "web search for..."
- "search the web..."
- "look up online..."
- "find information about..."

**Advantages:**
- Zero manual effort
- Consistent triggering
- Contextual awareness

**When to use:**
- Let hooks handle SessionStart (using-flows) automatically
- Let hooks detect research needs when user asks questions

**Example:**
```
User: "Look up the latest React 18 hooks API"
Hook: Auto-triggers web-researcher agent
```

---

### Manual Invocation (Explicit)

**Syntax:** `@agent-<agent-name>`

**When to use:**
- Override hook behavior (force web-researcher when keywords don't match)
- Explicit control over timing
- User specifically requests agent by name

**Example:**
```markdown
Use @agent-web-researcher to verify the current Vite configuration syntax
```

**Advantages:**
- Precise control
- Clear intent in documentation
- Works when hooks don't trigger

---

### Task Tool Invocation (Programmatic)

**Syntax:**
```python
Task tool:
  subagent_type = "Explore"  # or "general-purpose", "flows:code-reviewer"
  model = "haiku"             # or "sonnet"
  prompt = "..."
```

**When to use:**
- Within skills that need to dispatch agents
- Parallel agent execution
- Structured result consumption

**Examples:**

**Explore Agent:**
```python
subagent_type = "Explore"
model = "haiku"
prompt = """
Explore codebase architecture...

**CRITICAL:** Do NOT create temporary files (/tmp, docs/, etc).
Aggregate all findings in memory and return complete report in your final message.
All results must appear in function_results - no file creation.

Thoroughness: very thorough
"""
```

**Code-Reviewer Agent:**
```python
subagent_type = "flows:code-reviewer"
model = "sonnet"
prompt = "[Full review specification from requesting-code-review/code-reviewer.md]"
```

**Advantages:**
- Programmatic control
- Result consumption patterns (function_results)
- Parallel dispatch support

---

## Decision Matrix: Which Invocation to Use

| Scenario | Use This | Why |
|----------|----------|-----|
| Need using-flows at session start | Hook-based (automatic) | SessionStart hook handles it |
| User asks to research something | Hook-based (automatic) | UserPromptSubmit hook detects keywords |
| Forcing web research without triggers | Manual (@agent-web-researcher) | Override hook behavior |
| Within skill: need Explore agent | Task tool (programmatic) | Structured result consumption |
| Within skill: need code review | Task tool (flows:code-reviewer) | Programmatic dispatch |
| Parallel agent execution | Task tool (programmatic) | Multiple Task calls in sequence |

---

## Result Consumption Patterns

See `/Users/tuan/tools/flows/docs/task-tool-mechanics.md` for full details.

**Pattern 1: Narrative (Explore agents)**
- Read function_results directly as narrative report
- Extract sections matching requested structure
- 90% of agent invocations

**Pattern 2: Structured Parsing (Implementation agents)**
- Parse specific fields from function_results
- Extract commit SHAs, file paths, issue descriptions
- Validate extracted data

**Pattern 3: Parallel Dispatch (Multiple agents)**
- Correlate results by dispatch order
- Synthesize findings from multiple agents
- Used in codebase-research, handoff, systematic-debugging

---

## Best Practices

1. **Let hooks work first** - Don't manually invoke agents that hooks handle automatically
2. **Use Task tool in skills** - For programmatic control and result consumption
3. **Verify thoroughness level** - "very thorough" vs "medium" affects depth
4. **Always consume from function_results** - Never create /tmp files
5. **Parallel when possible** - Dispatch 3-5 Explore agents in parallel for speed
6. **Single agent in_progress** - Only one Task tool invocation should be in_progress at a time in TodoWrite

---

## Examples from Skills

**Codebase Research (5 parallel Explore agents):**
```python
# Agent 1 - Architecture
subagent_type = "Explore"
model = "haiku"
prompt = "Explore architecture..."

# Agent 2 - Implementation
subagent_type = "Explore"
model = "haiku"
prompt = "Explore core features..."

# ... (3 more agents)
```

**Requesting Code Review (Code-Reviewer agent):**
```python
subagent_type = "flows:code-reviewer"
model = "sonnet"
prompt = "[Full specification from code-reviewer.md template]"
```

**Web Research (Manual invocation in brainstorming):**
```markdown
Before proposing approaches, use @agent-web-researcher to verify:
- Current framework best practices
- API syntax and examples
- Integration patterns
```

---

## Integration with Skills

**Skills that auto-invoke agents:**
- using-flows (injected via SessionStart hook)
- All skills with Explore dispatches (16 total)
- requesting-code-review (code-reviewer agent)
- brainstorming (optional web-researcher)
- writing-plans (optional web-researcher)

**See also:**
- `/Users/tuan/tools/flows/docs/task-tool-mechanics.md` - Result consumption patterns
- `/Users/tuan/tools/flows/agents/code-reviewer.md` - Code reviewer specification
- `/Users/tuan/tools/flows/agents/web-researcher.md` - Web researcher specification
