---
name: using-flows
description: Use when starting any conversation - establishes mandatory workflows for finding and using skills, including using Skill tool before announcing usage, following brainstorming before coding, and creating TodoWrite todos for checklists
---

<EXTREMELY-IMPORTANT>
If you think there is even a 1% chance a skill might apply to what you are doing, you ABSOLUTELY MUST read the skill.

IF A SKILL APPLIES TO YOUR TASK, YOU DO NOT HAVE A CHOICE. YOU MUST USE IT.

This is not negotiable. This is not optional. You cannot rationalize your way out of this.
</EXTREMELY-IMPORTANT>

# Getting Started with Skills

## MANDATORY FIRST RESPONSE PROTOCOL

Before responding to ANY user message, you MUST complete this checklist:

1. ☐ List available skills in your mind
2. ☐ Ask yourself: "Does ANY skill match this request?"
3. ☐ If yes → Use the Skill tool to read and run the skill file
4. ☐ Announce which skill you're using
5. ☐ Follow the skill exactly

**Responding WITHOUT completing this checklist = automatic failure.**

## Critical Rules

1. **Follow mandatory workflows.** Brainstorming before coding. Check for relevant skills before ANY task.

2. Execute skills with the Skill tool

## Common Rationalizations That Mean You're About To Fail

If you catch yourself thinking ANY of these thoughts, STOP. You are rationalizing. Check for and use the skill.

- "This is just a simple question" → WRONG. Questions are tasks. Check for skills.
- "I can check git/files quickly" → WRONG. Files don't have conversation context. Check for skills.
- "Let me gather information first" → WRONG. Skills tell you HOW to gather information. Check for skills.
- "This doesn't need a formal skill" → WRONG. If a skill exists for it, use it.
- "I remember this skill" → WRONG. Skills evolve. Run the current version.
- "This doesn't count as a task" → WRONG. If you're taking action, it's a task. Check for skills.
- "The skill is overkill for this" → WRONG. Skills exist because simple things become complex. Use it.
- "I'll just do this one thing first" → WRONG. Check for skills BEFORE doing anything.

**Why:** Skills document proven techniques that save time and prevent mistakes. Not using available skills means repeating solved problems and making known errors.

If a skill for your task exists, you must use it or you will fail at your task.

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

## When to Invoke Web-Researcher Agent

**INVOKE WEB-RESEARCHER when you need:**

**Current External Information:**
- API documentation (current version, not training data)
- Library usage patterns released after training cutoff
- Modern framework best practices
- Package installation procedures
- Version compatibility matrices

**Technical Verification:**
- Verify claims in code review feedback
- Check error messages against current tool versions
- Confirm platform-specific behaviors
- Validate security recommendations

**Research and Comparison:**
- Compare libraries/frameworks for brainstorming
- Find reference implementations
- Gather benchmark/performance data
- Understand community adoption patterns

**Documentation Sources:**
- Official documentation sites
- Example repositories on GitHub
- GitHub issues for known problems
- Stack Overflow solutions
- Changelogs and migration guides

**DO NOT invoke web-researcher for:**
- Information in existing codebase files
- Patterns documented in skills
- General programming knowledge in training data
- Questions answerable from local context

## Skills with Checklists

If a skill has a checklist, YOU MUST create TodoWrite todos for EACH item.

**Don't:**
- Work through checklist mentally
- Skip creating todos "to save time"
- Batch multiple items into one todo
- Mark complete without doing them

**Why:** Checklists without TodoWrite tracking = steps get skipped. Every time. The overhead of TodoWrite is tiny compared to the cost of missing steps.

## Announcing Skill Usage

Before using a skill, announce that you are using it.
"I'm using [Skill Name] to [what you're doing]."

**Examples:**
- "I'm using the brainstorming skill to refine your idea into a design."
- "I'm using the test-driven-development skill to implement this feature."

**Why:** Transparency helps your human partner understand your process and catch errors early. It also confirms you actually read the skill.

# About these skills

**Many skills contain rigid rules (TDD, debugging, verification).** Follow them exactly. Don't adapt away the discipline.

**Some skills are flexible patterns (architecture, naming).** Adapt core principles to your context.

The skill itself tells you which type it is.

## Instructions ≠ Permission to Skip Workflows

Your human partner's specific instructions describe WHAT to do, not HOW.

"Add X", "Fix Y" = the goal, NOT permission to skip brainstorming, TDD, or RED-GREEN-REFACTOR.

**Red flags:** "Instruction was specific" • "Seems simple" • "Workflow is overkill"

**Why:** Specific instructions mean clear requirements, which is when workflows matter MOST. Skipping process on "simple" tasks is how simple tasks become complex problems.

## Summary

**Starting any task:**
1. If relevant skill exists → Use the skill
3. Announce you're using it
4. Follow what it says

**Skill has checklist?** TodoWrite for every item.

**Finding a relevant skill = mandatory to read and use it. Not optional.**
