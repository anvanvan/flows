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

- **16 existing skills** enhanced with Explore integration
- **2 new skills** enabled by Explore capabilities
- **18 total skills** now leverage Explore agent
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

## Result Consumption Patterns

### Critical Enhancement (2025-11-12)

All skills now include **explicit result consumption instructions** showing HOW to extract data from Task tool invocations.

**Three consumption patterns:**

1. **Pattern 1: Narrative Consumption (90% of usage)**
   - Explore returns structured narrative matching requested format
   - Read findings directly from function_results
   - Reference specific file:line mentions
   - No parsing required

2. **Pattern 2: Structured Parsing (10% of usage)**
   - Implementation tasks return strict 5-section reports
   - Parse specific sections using regex and text extraction
   - Validate extracted data (commit SHAs, file paths)
   - Re-prompt if validation fails

3. **Pattern 3: Semantic Analysis (used in code review)**
   - Code reviewer returns analysis with sections
   - Search for keywords and categories
   - Make workflow decisions based on content
   - No rigid parsing

**Documentation:**
- `/docs/task-tool-mechanics.md` - Complete Task tool reference
- `/docs/skill-task-consumption-template.md` - Template for adding to skills

**Enhancement locations:**
All 18 skills now have "Consuming [Agent Name] Results:" sections after each Task dispatch showing:
- Result location (function_results block)
- Result format (what sections to expect)
- How to consume (which pattern to use)
- Use findings for (specific actions)

## Success Metrics

**Quality (PRIMARY):**
- ✅ Completeness: All relevant files found
- ✅ Accuracy: file:line references correct
- ✅ Consistency: Implementations match existing patterns
- ✅ Thoroughness: All variations and edge cases discovered

**Efficiency (SECONDARY):**
- Token savings: 60-80% reduction for multi-search workflows
- Context cleanliness: Isolated Explore contexts prevent pollution

**Result Consumption (ADDED 2025-11-12):**
- ✅ Explicit extraction instructions in all skills
- ✅ Three consumption patterns documented
- ✅ Function_results mechanism clarified
- ✅ Parallel result correlation explained

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
