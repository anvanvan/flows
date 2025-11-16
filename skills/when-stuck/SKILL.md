---
name: when-stuck
description: Use when stuck and unsure which problem-solving technique to apply - diagnostic dispatch tool that routes to appropriate problem-solving technique based on symptoms
---

# When Stuck - Problem-Solving Dispatcher

## Overview

This skill serves as a diagnostic tool for identifying the appropriate problem-solving technique based on your specific type of challenge.

**Core principle:** "Match stuck-symptom to technique"

## When to Use

Deploy this skill when:
- Stuck and unsure which technique applies
- Multiple approaches seem viable
- Previous attempts have failed
- Need systematic problem-solving approach

## Dispatch Matrix

### Symptom → Technique Mapping

| You're Stuck Because... | Use This Technique | Location |
|------------------------|-------------------|----------|
| Code too complex with multiple implementations | Simplification Cascades | See below |
| Conventional solutions falling short | Collision Zone Thinking | See below |
| Same problems recurring across domains | Meta-Pattern Recognition | See below |
| Limited by assumptions | Inversion Exercise | See below |
| Works locally but not at scale | Scale Game | See below |
| Code behaves unexpectedly | @flows:systematic-debugging | `skills/systematic-debugging/` |
| Can't understand existing code | @flows:codebase-research | `skills/codebase-research/` |
| Unsure how to implement | @flows:pattern-discovery | `skills/pattern-discovery/` |

## Embedded Techniques

### Simplification Cascades

**When:** Complexity spiraling with multiple implementations

**Process:**
1. Strip to absolute minimum that still demonstrates issue
2. Add back one element at a time
3. Identify exact point where complexity breaks
4. Refactor at that boundary

### Collision Zone Thinking

**When:** Conventional solutions fall short

**Process:**
1. List all constraints explicitly
2. Identify which constraints conflict
3. Question if all constraints are real
4. Find the "collision zone" where tradeoffs live
5. Make explicit decision about tradeoffs

### Meta-Pattern Recognition

**When:** Recurring issues across domains

**Process:**
1. Abstract problem to its essence
2. Find similar problems in other domains
3. Identify the meta-pattern
4. Apply proven solutions from other domains

### Inversion Exercise

**When:** Limited by current assumptions

**Process:**
1. List current assumptions
2. Invert each assumption
3. Explore what becomes possible
4. Cherry-pick valuable inversions

### Scale Game

**When:** Solution works small but fails large

**Process:**
1. 10x the scale - what breaks?
2. 100x the scale - what's impossible?
3. 1000x the scale - what assumptions fail?
4. Design for the breaking points

## Combination Strategies

Some problems require multiple techniques:

1. **Complex Legacy Code:**
   - Start: @flows:codebase-research
   - Then: Simplification Cascades
   - Finally: @flows:characterization-testing

2. **Performance at Scale:**
   - Start: Scale Game
   - Then: Meta-Pattern Recognition
   - Finally: Collision Zone Thinking

3. **Architectural Decisions:**
   - Start: @flows:knowledge-lineages
   - Then: Inversion Exercise
   - Finally: @flows:brainstorming

## Visual Dispatch Guide

```
                    STUCK?
                      |
        /-------------|-------------\
        |                           |
    Can't Understand           Can't Solve
         |                          |
    /----|----\              /------|------\
    |         |              |             |
  Code     Pattern       Complex      Unexpected
    |         |              |             |
Research  Discovery    Simplification  Debugging
```

## Integration Points

This skill dispatches to:
- @flows:systematic-debugging
- @flows:codebase-research
- @flows:pattern-discovery
- @flows:characterization-testing
- @flows:brainstorming
- @flows:knowledge-lineages

## Next Steps

After identifying technique:
1. Load the recommended skill
2. Read its methodology completely
3. Apply step-by-step
4. If unsuccessful, return here for alternative approach
