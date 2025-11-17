#!/bin/bash
# Test Task 1: Verify task-tool-mechanics.md foundation document

set -e

echo "=== Task 1 Verification Tests ==="
echo ""

# Test 1: File exists
echo "Test 1: Verify file exists..."
if [ -f "/Users/tuan/tools/flows/docs/task-tool-mechanics.md" ]; then
    echo "✓ PASS: task-tool-mechanics.md exists"
else
    echo "✗ FAIL: task-tool-mechanics.md not found"
    exit 1
fi

# Test 2: File has required sections
echo ""
echo "Test 2: Verify required sections exist..."
required_sections=(
    "# Task Tool Mechanics"
    "## Overview"
    "## How Task Tool Returns Results"
    "## Key Principle"
)

for section in "${required_sections[@]}"; do
    if grep -q "$section" /Users/tuan/tools/flows/docs/task-tool-mechanics.md; then
        echo "✓ PASS: Found section: $section"
    else
        echo "✗ FAIL: Missing section: $section"
        exit 1
    fi
done

# Test 3: File contains critical anti-file-creation instruction
echo ""
echo "Test 3: Verify critical instruction about not creating files..."
if grep -q "Explore agents should NOT create temporary files" /Users/tuan/tools/flows/docs/task-tool-mechanics.md; then
    echo "✓ PASS: Contains instruction to NOT create temporary files"
else
    echo "✗ FAIL: Missing critical instruction about file creation"
    exit 1
fi

# Test 4: File explains function_results mechanism
echo ""
echo "Test 4: Verify function_results mechanism is explained..."
if grep -q "function_results block" /Users/tuan/tools/flows/docs/task-tool-mechanics.md; then
    echo "✓ PASS: Explains function_results block mechanism"
else
    echo "✗ FAIL: Missing function_results explanation"
    exit 1
fi

# Test 5: File has example invocation
echo ""
echo "Test 5: Verify example invocation exists..."
if grep -q "Example invocation:" /Users/tuan/tools/flows/docs/task-tool-mechanics.md; then
    echo "✓ PASS: Contains example invocation"
else
    echo "✗ FAIL: Missing example invocation"
    exit 1
fi

# Test 6: File explains result format
echo ""
echo "Test 6: Verify result format is documented..."
if grep -q "Result format:" /Users/tuan/tools/flows/docs/task-tool-mechanics.md; then
    echo "✓ PASS: Documents result format"
else
    echo "✗ FAIL: Missing result format documentation"
    exit 1
fi

# Test 7: Commit exists
echo ""
echo "Test 7: Verify commit was created..."
if git log --oneline -1 | grep -q "docs: create Task tool mechanics foundation (Task 1)"; then
    echo "✓ PASS: Commit created with correct message"
else
    echo "✗ FAIL: Commit not found or incorrect message"
    exit 1
fi

# Test 8: File is tracked by git
echo ""
echo "Test 8: Verify file is tracked by git..."
if git ls-files --error-unmatch docs/task-tool-mechanics.md > /dev/null 2>&1; then
    echo "✓ PASS: File is tracked by git"
else
    echo "✗ FAIL: File is not tracked by git"
    exit 1
fi

echo ""
echo "=== All tests passed! ==="
echo ""
echo "Summary:"
echo "- Foundation document created: ✓"
echo "- All required sections present: ✓"
echo "- Critical instructions included: ✓"
echo "- Committed to git: ✓"
