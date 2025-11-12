#!/bin/bash
# Test script for Task 8: Verify systematic-debugging skill has multi-domain exploration

set -e

SKILL_FILE="/Users/tuan/tools/flows/skills/systematic-debugging/SKILL.md"

echo "Testing Task 8: systematic-debugging enhancement with multi-domain exploration"
echo "=============================================================================="
echo ""

# Test 1: Check if Step 1 Multi-Domain Exploration exists
echo "Test 1: Checking for 'Step 1: Multi-Domain Exploration (MANDATORY)' section..."
if grep -q "#### Step 1: Multi-Domain Exploration (MANDATORY)" "$SKILL_FILE"; then
    echo "✓ PASS: Step 1 section header found"
else
    echo "✗ FAIL: Step 1 section header not found"
    exit 1
fi

# Test 2: Check for Agent 1 - Error Source Discovery
echo "Test 2: Checking for Agent 1 - Error Source Discovery..."
if grep -q "Agent 1 - Error Source Discovery:" "$SKILL_FILE"; then
    echo "✓ PASS: Agent 1 section found"
else
    echo "✗ FAIL: Agent 1 section not found"
    exit 1
fi

# Test 3: Check for Agent 2 - Related Component Discovery
echo "Test 3: Checking for Agent 2 - Related Component Discovery..."
if grep -q "Agent 2 - Related Component Discovery:" "$SKILL_FILE"; then
    echo "✓ PASS: Agent 2 section found"
else
    echo "✗ FAIL: Agent 2 section not found"
    exit 1
fi

# Test 4: Check for Agent 3 - Pattern & History Discovery
echo "Test 4: Checking for Agent 3 - Pattern & History Discovery..."
if grep -q "Agent 3 - Pattern & History Discovery (Optional):" "$SKILL_FILE"; then
    echo "✓ PASS: Agent 3 section found"
else
    echo "✗ FAIL: Agent 3 section not found"
    exit 1
fi

# Test 5: Check for Explore agent configuration (subagent_type = "Explore")
echo "Test 5: Checking for Explore agent configuration..."
if grep -q 'subagent_type = "Explore"' "$SKILL_FILE"; then
    echo "✓ PASS: Explore subagent_type found"
else
    echo "✗ FAIL: Explore subagent_type not found"
    exit 1
fi

# Test 6: Check for thoroughness configuration
echo "Test 6: Checking for thoroughness configuration..."
if grep -q "Thoroughness: very thorough" "$SKILL_FILE"; then
    echo "✓ PASS: Thoroughness configuration found"
else
    echo "✗ FAIL: Thoroughness configuration not found"
    exit 1
fi

# Test 7: Check for verification pattern
echo "Test 7: Checking for verification pattern..."
if grep -q "Verification pattern:" "$SKILL_FILE"; then
    echo "✓ PASS: Verification pattern found"
else
    echo "✗ FAIL: Verification pattern not found"
    exit 1
fi

# Test 8: Check for "Use findings for" section
echo "Test 8: Checking for 'Use findings for' guidance..."
if grep -q "Use findings for:" "$SKILL_FILE"; then
    echo "✓ PASS: 'Use findings for' section found"
else
    echo "✗ FAIL: 'Use findings for' section not found"
    exit 1
fi

# Test 9: Verify correct numbering of subsequent steps (2-6)
echo "Test 9: Checking correct numbering of Phase 1 steps..."
if grep -q "2. \*\*Read Error Messages Carefully\*\*" "$SKILL_FILE" && \
   grep -q "3. \*\*Reproduce Consistently\*\*" "$SKILL_FILE" && \
   grep -q "4. \*\*Check Recent Changes\*\*" "$SKILL_FILE" && \
   grep -q "5. \*\*Gather Evidence in Multi-Component Systems\*\*" "$SKILL_FILE" && \
   grep -q "6. \*\*Trace Data Flow\*\*" "$SKILL_FILE"; then
    echo "✓ PASS: All steps correctly numbered (2-6)"
else
    echo "✗ FAIL: Step numbering incorrect"
    exit 1
fi

# Test 10: Check for parallel dispatch instruction
echo "Test 10: Checking for parallel dispatch instruction..."
if grep -q "Dispatch 2-3 Explore agents IN PARALLEL" "$SKILL_FILE"; then
    echo "✓ PASS: Parallel dispatch instruction found"
else
    echo "✗ FAIL: Parallel dispatch instruction not found"
    exit 1
fi

echo ""
echo "=============================================================================="
echo "All tests passed! ✓"
echo "Task 8 implementation verified successfully."
