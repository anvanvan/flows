#!/bin/bash
# Test script for Task 9: Verify subagent-driven-development skill has context discovery

set -e

SKILL_FILE="/Users/tuan/tools/flows/skills/subagent-driven-development/SKILL.md"

echo "Testing Task 9: subagent-driven-development enhancement with context discovery"
echo "=============================================================================="
echo ""

# Test 1: Check if Pre-Execution: Task Context Discovery section exists
echo "Test 1: Checking for 'Pre-Execution: Task Context Discovery (MANDATORY)' section..."
if grep -q "## Pre-Execution: Task Context Discovery (MANDATORY)" "$SKILL_FILE"; then
    echo "✓ PASS: Pre-Execution section header found"
else
    echo "✗ FAIL: Pre-Execution section header not found"
    exit 1
fi

# Test 2: Check for "Before dispatching first task agent" instruction
echo "Test 2: Checking for dispatch instruction..."
if grep -q "Before dispatching first task agent, run Explore" "$SKILL_FILE"; then
    echo "✓ PASS: Dispatch instruction found"
else
    echo "✗ FAIL: Dispatch instruction not found"
    exit 1
fi

# Test 3: Check for Explore agent configuration (subagent_type = "Explore")
echo "Test 3: Checking for Explore agent configuration..."
if grep -q 'subagent_type = "Explore"' "$SKILL_FILE"; then
    echo "✓ PASS: Explore subagent_type found"
else
    echo "✗ FAIL: Explore subagent_type not found"
    exit 1
fi

# Test 4: Check for model = "haiku"
echo "Test 4: Checking for haiku model configuration..."
if grep -q 'model = "haiku"' "$SKILL_FILE"; then
    echo "✓ PASS: Haiku model configuration found"
else
    echo "✗ FAIL: Haiku model configuration not found"
    exit 1
fi

# Test 5: Check for thoroughness configuration
echo "Test 5: Checking for thoroughness configuration..."
if grep -q "Thoroughness: very thorough" "$SKILL_FILE"; then
    echo "✓ PASS: Thoroughness configuration found"
else
    echo "✗ FAIL: Thoroughness configuration not found"
    exit 1
fi

# Test 6: Check for exploration methodology items
echo "Test 6: Checking for exploration methodology (5 key items)..."
if grep -q "1. Find all relevant existing code (similar features, utilities, patterns)" "$SKILL_FILE" && \
   grep -q "2. Locate test files and testing patterns to follow" "$SKILL_FILE" && \
   grep -q "3. Identify configuration, dependencies, or setup required" "$SKILL_FILE" && \
   grep -q "4. Find any constraints, anti-patterns, or deprecations to avoid" "$SKILL_FILE" && \
   grep -q "5. Map component relationships and integration points" "$SKILL_FILE"; then
    echo "✓ PASS: All 5 exploration methodology items found"
else
    echo "✗ FAIL: Exploration methodology items incomplete"
    exit 1
fi

# Test 7: Check for "Share findings with all task agents" section
echo "Test 7: Checking for findings sharing guidance..."
if grep -q "Share findings with all task agents:" "$SKILL_FILE"; then
    echo "✓ PASS: Findings sharing section found"
else
    echo "✗ FAIL: Findings sharing section not found"
    exit 1
fi

# Test 8: Check for "Per-task targeted Explore (optional)" section
echo "Test 8: Checking for per-task Explore option..."
if grep -q "Per-task targeted Explore (optional):" "$SKILL_FILE"; then
    echo "✓ PASS: Per-task Explore option found"
else
    echo "✗ FAIL: Per-task Explore option not found"
    exit 1
fi

# Test 9: Check that section is placed before "Execute Task with Subagent"
echo "Test 9: Checking correct placement before Execute Task section..."
if grep -B 5 "### 2. Execute Task with Subagent" "$SKILL_FILE" | grep -q "Per-task targeted Explore (optional)"; then
    echo "✓ PASS: Pre-Execution section correctly placed before Execute Task"
else
    echo "✗ FAIL: Section placement incorrect"
    exit 1
fi

# Test 10: Verify Return items are specified
echo "Test 10: Checking for Return section with expected items..."
if grep -q "Return:" "$SKILL_FILE" && \
   grep -q "Existing code to reference" "$SKILL_FILE" && \
   grep -q "Testing patterns and locations" "$SKILL_FILE" && \
   grep -q "Configuration/setup requirements" "$SKILL_FILE" && \
   grep -q "Constraints and patterns to follow" "$SKILL_FILE" && \
   grep -q "Component relationship map" "$SKILL_FILE"; then
    echo "✓ PASS: All Return items found"
else
    echo "✗ FAIL: Return items incomplete"
    exit 1
fi

echo ""
echo "=============================================================================="
echo "All tests passed! ✓"
echo "Task 9 implementation verified successfully."
