---
name: knowledge-lineages
description: Use when questioning existing approaches or proposing new ones - traces historical context of current approaches to avoid repeating past mistakes and rediscover abandoned solutions
---

# Tracing Knowledge Lineages

## Overview

Before judging current approaches or proposing new ones, trace their lineage to understand the historical context.

**Core principle:** "Before judging current approaches or proposing new ones, trace their lineage."

## When to Use

Apply this skill when:
- Questioning why existing approaches are used
- Considering abandoning current methods
- Evaluating ideas that might be historical revivals
- Declaring something a best practice
- Finding "the old way was obviously wrong" without context

## The Investigation Process

### Phase 1: Decision Archaeology

Search for when and why decisions were made:
- Architecture decision records (ADRs)
- Git history and blame annotations
- Issue/PR discussions
- Documentation evolution
- Team knowledge interviews

**Key questions:**
- When was this approach adopted?
- What problem was it solving?
- What alternatives were considered?
- Who made the decision and why?

### Phase 2: Failed Attempt Analysis

When hearing "we tried X and it didn't work":
- What was the specific context?
- What was the exact failure mode?
- Have conditions changed since then?
- Was the implementation flawed or the idea itself?

### Phase 3: Revival Detection

Identify whether "new" approaches existed previously:
- Search codebase history for similar patterns
- Check deprecated documentation
- Look for removed features in changelogs
- Understand what caused earlier decline
- Assess if resurrection conditions now exist

### Phase 4: Paradigm Shift Mapping

Document transitions between major approaches:
- What was gained in the transition?
- What was lost or sacrificed?
- What lessons were preserved?
- What knowledge was forgotten?

## Search Strategies

**Git Archaeology:**
```bash
# Find when a pattern was introduced
git log -S "pattern" --all

# See evolution of a specific file
git log -p --follow path/to/file

# Find deleted code
git log --diff-filter=D --summary

# Blame with historical context
git blame -w -C -C -C file
```

**Documentation Mining:**
- README history
- CHANGELOG entries
- Migration guides
- Deprecation notices

**Discussion Archaeology:**
- GitHub/GitLab issues
- Pull request conversations
- Slack/Discord archives
- Meeting notes

## Red Flags Indicating Ignorance of History

- "Let's rewrite this" without understanding complexity
- "The old way was obviously wrong" without context
- Dismissing approaches solely for being old
- Adopting approaches solely for being new
- "Nobody remembers why we do this" → investigate!

## When History Can Be Overridden

Valid reasons to change despite history:
1. Context fundamentally changed (new requirements, tools, constraints)
2. Critical lessons were learned that invalidate past reasoning
3. Original reasoning was flawed (now provable)

**Always document why you're overriding history.**

## Integration with Other Skills

**Complements:**
- `codebase-research` - Understand current state before tracing history
- `pattern-discovery` - Find patterns that have historical significance
- `systematic-debugging` - Historical context reveals root causes

## Output Template

When completing knowledge lineage tracing:

```markdown
## Knowledge Lineage Report: [Topic]

### Current Approach
- What: [Current implementation]
- Since: [When adopted]
- Why: [Original reasoning]

### Historical Approaches
1. [Approach 1]: [Years used]
   - Why adopted: [Reasoning]
   - Why abandoned: [Specific issues]
   - Lessons learned: [Key takeaways]

### Failed Attempts
- [Approach X]: [When tried]
  - Failure mode: [Specific issues]
  - Context then: [Conditions]
  - Context now: [What changed]

### Recommendation
Based on historical analysis: [Continue/Modify/Replace]
Reasoning: [Why history supports this]
```
