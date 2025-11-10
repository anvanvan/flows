# Web Researcher Agent - Manual Test Plan

## Overview
This document outlines the manual testing required for the web-researcher agent integration with the flows plugin.

## Important Note
Steps 1-7 require manual testing in Claude Code and cannot be automated.

## Test Checklist

- [ ] Plugin installation successful
- [ ] Hook triggers on research keywords
- [ ] Manual @agent invocation works
- [ ] Agent appears in /context output

## Manual Test Steps

### Step 1: Check current plugin installation
Run:
```bash
grep -A 3 "flows" ~/.claude/settings.json
```
Expected: Shows flows plugin enabled (if already installed)

### Step 2: Reinstall flows plugin to pick up changes
In Claude Code, run:
```
/plugin reinstall flows@flows
```
Expected: "Successfully reinstalled flows"

### Step 3: Restart Claude Code
Exit and restart Claude Code application

Expected: Clean restart with flows loaded

### Step 4: Test automatic hook triggering
In a new Claude Code session, type:
```
research online the latest Claude Code plugin development best practices
```
Expected: System reminder about invoking web-researcher agent appears

### Step 5: Test manual agent invocation
Type:
```
@agent-web-researcher find the current syntax for git stage-lines in patchutils
```
Expected: Web-researcher agent activates and performs search

### Step 6: Verify agent is available in context
Run:
```
/context
```
Expected: Shows "web-researcher (Plugin)" in custom agents list

### Step 7: Test hook keyword variations
Try different trigger phrases:
- "web search for React 19 features"
- "look up online TypeScript 5.3 changes"
- "find information about Rust async patterns"

Expected: Each triggers the web-researcher agent

## Test Results
**Status:** PENDING - Manual testing has not been executed yet.

This section will be updated once manual testing is completed with:
- Actual results for each checklist item
- Any issues or blockers encountered
- Screenshots or output examples where relevant
