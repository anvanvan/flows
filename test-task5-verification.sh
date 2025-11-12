#!/bin/bash

echo "Running Task 5 Agent Description Tests..."
echo "=========================================="
echo

# Test 1
echo "Test 1: Frontmatter mentions concurrent-safety"
if grep -q "Concurrent-safe:" agents/code-reviewer.md; then
    echo "✓ PASS: Found 'Concurrent-safe:' in description"
else
    echo "✗ FAIL: 'Concurrent-safe:' not found in description"
    exit 1
fi
echo

# Test 2
echo "Test 2: Concurrent Execution Safety section exists"
if grep -q "Concurrent Execution Safety:" agents/code-reviewer.md; then
    echo "✓ PASS: Found 'Concurrent Execution Safety:' section"
    # Check for key phrases
    if grep -A 3 "Concurrent Execution Safety:" agents/code-reviewer.md | grep -q "read-only git operations"; then
        echo "✓ PASS: Mentions read-only git operations"
    else
        echo "✗ FAIL: Doesn't mention read-only git operations"
        exit 1
    fi
    if grep -A 3 "Concurrent Execution Safety:" agents/code-reviewer.md | grep -q "explicit commit SHAs"; then
        echo "✓ PASS: Mentions explicit commit SHAs"
    else
        echo "✗ FAIL: Doesn't mention explicit commit SHAs"
        exit 1
    fi
    if grep -A 3 "Concurrent Execution Safety:" agents/code-reviewer.md | grep -q "detect and report concurrent modifications"; then
        echo "✓ PASS: Mentions detect and report concurrent modifications"
    else
        echo "✗ FAIL: Doesn't mention detect and report concurrent modifications"
        exit 1
    fi
else
    echo "✗ FAIL: 'Concurrent Execution Safety:' section not found"
    exit 1
fi
echo

# Test 3
echo "Test 3: Concurrent conflicts marked as Critical"
if grep -A 5 "Issue Identification and Recommendations" agents/code-reviewer.md | grep -q "Concurrent modification conflicts are ALWAYS Critical"; then
    echo "✓ PASS: Concurrent conflicts marked as ALWAYS Critical"
else
    echo "✗ FAIL: Concurrent conflicts not marked as ALWAYS Critical"
    exit 1
fi
echo

# Test 4
echo "Test 4: Communication protocol handles concurrent conflicts"
if grep -A 1 "Communication Protocol" agents/code-reviewer.md | grep -q "concurrent modification conflicts, STOP"; then
    echo "✓ PASS: First protocol item handles concurrent conflicts"
else
    echo "✗ FAIL: First protocol item doesn't handle concurrent conflicts"
    exit 1
fi
echo

echo "=========================================="
echo "All tests PASSED!"
echo
