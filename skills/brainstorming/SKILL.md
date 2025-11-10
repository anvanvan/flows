---
name: brainstorming
description: Use when creating or developing, before writing code or implementation plans - refines rough ideas into fully-formed designs through collaborative questioning, alternative exploration, and incremental validation. Don't use during clear 'mechanical' processes
---

# Brainstorming Ideas Into Designs

## Overview

Help turn ideas into fully formed designs and specs through natural collaborative dialogue.

Start by understanding the current project context, then ask questions one at a time to refine the idea. Once you understand what you're building, present the design in small sections (200-300 words), checking after each section whether it looks right so far.

## The Process

**Understanding the idea:**
- Check out the current project state first (files, docs, recent commits)
- **INVOKE WEB-RESEARCHER WHEN USER MENTIONS:**
  - Specific frameworks/libraries you're unfamiliar with
  - "Modern" or "current best practices" in a domain
  - Comparison requests between tools/approaches
  - Integration patterns with external services
  - Industry standards or conventions
  - Search for: architecture patterns, API capabilities, community best practices, migration guides
- Ask questions one at a time to refine the idea
- Prefer multiple choice questions when possible, but open-ended is fine too
- Only one question per message - if a topic needs more exploration, break it into multiple questions
- Focus on understanding: purpose, constraints, success criteria

**Exploring approaches:**
- **CONSIDER WEB-RESEARCHER BEFORE PROPOSING** if approaches involve:
  - Libraries/tools released after training cutoff
  - Framework-specific patterns you're uncertain about
  - Performance/scalability characteristics needed
  - Community adoption/maturity assessment
  - Known issues or limitations
  - Search for: comparison articles, benchmark data, production case studies, GitHub stars/issues
- Propose 2-3 different approaches with trade-offs
- Present options conversationally with your recommendation and reasoning
- Lead with your recommended option and explain why

**Presenting the design:**
- Once you believe you understand what you're building, present the design
- Break it into sections of 200-300 words
- Ask after each section whether it looks right so far
- Cover: architecture, components, data flow, error handling, testing
- Be ready to go back and clarify if something doesn't make sense

## After the Design

Once the user validates the final design section, present next steps using AskUserQuestion:

**Use AskUserQuestion with these options:**
- Question: "The design is complete! What would you like to do next?"
- Header: "Next steps"
- multiSelect: false
- Options:
  1. **"Create detailed implementation plan"**
     - Description: "Use flows:writing-plans to break this design into specific implementation tasks"
  2. **"Implement with subagent-driven-development"**
     - Description: "Start implementation now using fresh agents per task with code review between tasks"
  3. **"Other"** (auto-provided)
     - User can provide free text like "I have more feedback about the design..."

**Handling the user's choice:**

- **If "Create detailed implementation plan"**: Use flows:writing-plans skill immediately with the design context
- **If "Implement with subagent-driven-development"**: Use flows:subagent-driven-development skill to begin implementation
- **If "Other" (more feedback)**: Return to the design discussion, ask clarifying questions, and update the relevant sections

**Documentation:**
- Design documents are optional - user can request separately if needed
- The conversation history contains the complete design context for planning or implementation

## Key Principles

- **One question at a time** - Don't overwhelm with multiple questions
- **Multiple choice preferred** - Easier to answer than open-ended when possible
- **YAGNI ruthlessly** - Remove unnecessary features from all designs
- **Explore alternatives** - Always propose 2-3 approaches before settling
- **Incremental validation** - Present design in sections, validate each
- **Be flexible** - Go back and clarify when something doesn't make sense
