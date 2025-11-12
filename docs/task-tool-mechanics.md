# Task Tool Mechanics

## Overview

The Task tool dispatches specialized subagents (Explore, general-purpose, code-reviewer, etc.) and returns their results in the function result block.

## How Task Tool Returns Results

When you invoke the Task tool, results are returned in the function_results block that follows your invocation.

**Example invocation:**
```
Invoke Task tool with prompt:
"Explore the codebase to find authentication patterns.
Return: file paths, implementation details, and testing approaches."
```

**Result location:**
The subagent's complete output appears in the function_results block.

**Result format:**
- Plain text narrative (Explore agents)
- Structured sections (if you specified return format in prompt)
- Full conversation output (what the subagent returned)

## Key Principle

**Results are in function_results, not in files the subagent created.**

**IMPORTANT:** Explore agents should NOT create temporary files. Instead:
- Aggregate all findings in memory during exploration
- Consolidate results into structured narrative
- Return complete report in final message (appears in function_results)
- No /tmp files, no docs/ files - results go to function_results only

**For main agent consuming results:**
- Read from function_results block (not files)
- The Task tool captures subagent output automatically
- Ignore any files subagents may have created
