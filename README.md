# Flows

## Prerequisites

This fork uses `git stage-lines` and `git unstage-lines` for granular staging control, which is essential for parallel agent workflows. These are custom git aliases that require setup.

### Quick Setup (Recommended)

Run the automated setup script:

```bash
bash ~/tools/flows/setup.sh
```

This will install `patchutils` (if needed) and configure the git aliases automatically.

### Manual Setup

If you prefer to set up manually:

#### 1. Install patchutils

```bash
brew install patchutils
```

This provides the `filterdiff` command used by the git aliases.

#### 2. Configure git aliases

Add these aliases to your global git configuration:

```bash
git config --global alias.stage-lines '!f() {
  # Handle parameter patterns
  if [ -z "$2" ]; then
    file="$1"
    lines=""
  else
    lines="$1"
    file="$2"
  fi

  # Check if file is tracked
  if git ls-files --error-unmatch "$file" 2>/dev/null; then
    # Tracked file: require line ranges
    if [ -z "$lines" ]; then
      echo "Error: Please specify line ranges (e.g., 1-5,8,10-12)" >&2
      echo "Usage: git stage-lines <lines> <file>" >&2
      echo "       git stage-lines <untracked-file>" >&2
      return 1
    fi
    # Use filterdiff for line-level staging
    git diff "$file" | filterdiff --lines="$lines" | git apply --cached --unidiff-zero
  else
    # Untracked file: stage entire file
    git add "$file"
  fi
}; f'

git config --global alias.unstage-lines '!f() {
  # Handle parameter patterns
  if [ -z "$2" ]; then
    file="$1"
    lines=""
  else
    lines="$1"
    file="$2"
  fi

  # Check if file is newly added
  if git diff --cached --diff-filter=A --name-only | grep -qx "$file"; then
    # Newly added file: remove from index, make untracked
    git rm --cached "$file"
  else
    # Partial staged changes: require line ranges
    if [ -z "$lines" ]; then
      echo "Error: Please specify line ranges (e.g., 1-5,8,10-12)" >&2
      echo "Usage: git unstage-lines <lines> <file>" >&2
      echo "       git unstage-lines <newly-added-file>" >&2
      return 1
    fi
    # Use filterdiff reverse for line-level unstaging
    git diff --cached "$file" | filterdiff --lines="$lines" | git apply --cached --unidiff-zero --reverse
  fi
}; f'
```

#### 3. Verify setup

Check that aliases are configured:

```bash
git config --global --get-regexp "alias\.(stage-lines|unstage-lines)"
```

You should see output showing the configured aliases (formatting may vary).

### Usage

The commands automatically detect file state and apply the appropriate staging behavior:

**For tracked files with changes** (requires line ranges):
```bash
# Stage specific lines from a tracked file
git stage-lines 10-25 path/to/file.py

# Unstage specific lines from staged changes
git unstage-lines 15-20 path/to/file.py
```

**For untracked or newly-added files** (line ranges optional):
```bash
# Stage an entire untracked file
git stage-lines new-file.js

# Unstage a newly-added file (makes it untracked again)
git unstage-lines new-file.js
```

The commands detect whether a file is tracked or untracked and automatically use the appropriate staging method. For tracked files, line ranges are required to enable granular control. For untracked files, the entire file is staged.

This allows multiple parallel agents to work on the same files and stage only their specific changes without conflicts.

## Web-Researcher Agent

Flows includes an intelligent web research agent that automatically activates when you need current external information.

### Automatic Triggering

The agent activates when you mention research keywords:
- "research online..."
- "web search for..."
- "search the web..."
- "look up online..."
- "find information about..."
- "@agent-web-researcher"

### Manual Invocation

Explicitly invoke the agent in any context:
```
@agent-web-researcher find the latest Next.js 14 app router patterns
```

### Research Capabilities

The web-researcher agent:
- Searches official documentation and authoritative sources
- Fetches and analyzes current API specifications
- Finds real-world examples and GitHub repositories
- Verifies version-specific information
- Provides sourced summaries with direct links

### Use Cases

- **Debugging**: Research unfamiliar error messages and platform issues
- **Design**: Compare frameworks and find modern best practices
- **Planning**: Verify API syntax and integration patterns
- **Reviews**: Validate technical claims with authoritative sources
- **Skills**: Source current documentation for reference skills

The agent is integrated throughout flows skills with strategic invocation points in debugging, brainstorming, planning, and skill-creation workflows.

## Concurrent-Safe Code Review

Flows includes a concurrent-safe code review system designed for environments where multiple agents or humans work simultaneously.

### The Problem

Traditional code review systems use git ranges (BASE_SHA..HEAD_SHA) which can cause data loss when multiple agents or humans work in parallel.

### The Solution

The commit-SHA-list approach enables safe concurrent execution:
- Task subagents report exact commit SHAs they created
- Code reviewer uses read-only git operations (never checkout/reset)
- Detects concurrent modifications to same files
- Classifies conflicts as real (stop) or benign (continue)
- Fails loudly on conflicts instead of silently corrupting

### Features

- **Safety Checks**: Verify commits exist, detect concurrent modifications, check for uncommitted changes
- **Conflict Classification**: Distinguishes real conflicts from benign concurrent changes
- **Read-Only Operations**: No working tree modifications during review
- **Clear Reporting**: Explicit safety check results and conflict details

For details, see [Concurrent-Safe Code Review](docs/concurrent-safe-code-review.md).

A comprehensive skills library of proven techniques, patterns, and workflows for AI coding assistants.

## What You Get

- **Testing Skills** - TDD, async testing, anti-patterns
- **Debugging Skills** - Systematic debugging, root cause tracing, verification
- **Collaboration Skills** - Brainstorming, planning, code review, parallel agents
- **Development Skills** - Git worktrees, finishing branches, subagent workflows
- **Meta Skills** - Creating, testing, and sharing skills

Plus:
- **Slash Commands** - `/flows:brainstorm`, `/flows:write-plan`, `/flows:execute-plan`
- **Automatic Integration** - Skills activate automatically when relevant
- **Consistent Workflows** - Systematic approaches to common engineering tasks

## Learn More

Read the introduction: [Flows for Claude Code](https://blog.fsck.com/2025/10/09/superpowers/)

## Installation

### Claude Code (via Plugin Marketplace)

In Claude Code, register the marketplace first:

```bash
/plugin marketplace add ~/tools/flows
```

Then install the plugin from this marketplace:

```bash
/plugin install flows@flows
```

### Verify Installation

Check that commands appear:

```bash
/help
```

```
# Should see:
# /flows:brainstorm - Interactive design refinement
# /flows:write-plan - Create implementation plan
# /flows:execute-plan - Execute plan in batches
```

### Codex (Experimental)

**Note:** Codex support is experimental and may require refinement based on user feedback.

Tell Codex to fetch https://raw.githubusercontent.com/anvanvan/flows/refs/heads/main/.codex/INSTALL.md and follow the instructions.

## Quick Start

### Using Slash Commands

**Brainstorm a design:**
```
/flows:brainstorm
```

**Create an implementation plan:**
```
/flows:write-plan
```

**Execute the plan:**
```
/flows:execute-plan
```

### Automatic Skill Activation

Skills activate automatically when relevant. For example:
- `test-driven-development` activates when implementing features
- `systematic-debugging` activates when debugging issues
- `verification-before-completion` activates before claiming work is done

## What's Inside

### Skills Library

**Testing** (`skills/testing/`)
- **test-driven-development** - RED-GREEN-REFACTOR cycle
- **condition-based-waiting** - Async test patterns
- **testing-anti-patterns** - Common pitfalls to avoid

**Debugging** (`skills/debugging/`)
- **systematic-debugging** - 4-phase root cause process
- **root-cause-tracing** - Find the real problem
- **verification-before-completion** - Ensure it's actually fixed
- **defense-in-depth** - Multiple validation layers

**Collaboration** (`skills/collaboration/`)
- **brainstorming** - Socratic design refinement
- **writing-plans** - Detailed implementation plans
- **executing-plans** - Batch execution with checkpoints
- **dispatching-parallel-agents** - Concurrent subagent workflows
- **requesting-code-review** - Pre-review checklist
- **receiving-code-review** - Responding to feedback
- **using-git-worktrees** - Parallel development branches
- **finishing-a-development-branch** - Merge/PR decision workflow
- **subagent-driven-development** - Fast iteration with quality gates

**Meta** (`skills/meta/`)
- **writing-skills** - Create new skills following best practices
- **sharing-skills** - Contribute skills back via branch and PR
- **testing-skills-with-subagents** - Validate skill quality
- **using-flows** - Introduction to the skills system

### Commands

All commands are thin wrappers that activate the corresponding skill:

- **brainstorm.md** - Activates the `brainstorming` skill
- **write-plan.md** - Activates the `writing-plans` skill
- **execute-plan.md** - Activates the `executing-plans` skill

## How It Works

1. **SessionStart Hook** - Loads the `using-flows` skill at session start
2. **Skills System** - Uses Claude Code's first-party skills system
3. **Automatic Discovery** - Claude finds and uses relevant skills for your task
4. **Mandatory Workflows** - When a skill exists for your task, using it becomes required

## Philosophy

- **Test-Driven Development** - Write tests first, always
- **Systematic over ad-hoc** - Process over guessing
- **Complexity reduction** - Simplicity as primary goal
- **Evidence over claims** - Verify before declaring success
- **Domain over implementation** - Work at problem level, not solution level

## Contributing

Skills live directly in this repository. To contribute:

1. Fork the repository
2. Create a branch for your skill
3. Follow the `writing-skills` skill for creating new skills
4. Use the `testing-skills-with-subagents` skill to validate quality
5. Submit a PR

See `skills/meta/writing-skills/SKILL.md` for the complete guide.

## Updating

Skills update automatically when you update the plugin:

```bash
/plugin update superpowers
```

## License

MIT License - see LICENSE file for details

## Support

- **Issues**: https://github.com/anvanvan/flows/issues
- **Marketplace**: https://github.com/obra/flows
