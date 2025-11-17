#!/bin/bash
# Test script for Task 4: Update Requesting-Code-Review Skill Documentation

set -e

SKILL_FILE="skills/requesting-code-review/SKILL.md"
PASS_COUNT=0
FAIL_COUNT=0

echo "Testing Task 4: Update Requesting-Code-Review Skill Documentation"
echo "=================================================================="
echo ""

# Helper functions
pass() {
    echo "✓ PASS: $1"
    PASS_COUNT=$((PASS_COUNT + 1))
}

fail() {
    echo "✗ FAIL: $1"
    FAIL_COUNT=$((FAIL_COUNT + 1))
}

# Test 1: COMMIT_SHAS is mentioned (replacing BASE_SHA/HEAD_SHA)
echo "Test 1: COMMIT_SHAS placeholder is documented"
if grep -q "COMMIT_SHAS" "$SKILL_FILE"; then
    COUNT=$(grep -c "COMMIT_SHAS" "$SKILL_FILE")
    if [ "$COUNT" -ge 2 ]; then
        pass "COMMIT_SHAS mentioned $COUNT times"
    else
        fail "COMMIT_SHAS only mentioned $COUNT time (expected 2+)"
    fi
else
    fail "COMMIT_SHAS not found in documentation"
fi

# Test 2: FILES_MODIFIED is mentioned
echo "Test 2: FILES_MODIFIED placeholder is documented"
if grep -q "FILES_MODIFIED" "$SKILL_FILE"; then
    COUNT=$(grep -c "FILES_MODIFIED" "$SKILL_FILE")
    if [ "$COUNT" -ge 2 ]; then
        pass "FILES_MODIFIED mentioned $COUNT times"
    else
        fail "FILES_MODIFIED only mentioned $COUNT time (expected 2+)"
    fi
else
    fail "FILES_MODIFIED not found in documentation"
fi

# Test 3: BASE_SHA/HEAD_SHA deprecated warning exists
echo "Test 3: BASE_SHA/HEAD_SHA marked as deprecated"
if grep -q "BASE_SHA/HEAD_SHA approach (deprecated" "$SKILL_FILE"; then
    pass "BASE_SHA/HEAD_SHA marked as deprecated"
else
    fail "BASE_SHA/HEAD_SHA deprecation warning not found"
fi

# Test 4: Concurrent Execution Safety section exists
echo "Test 4: Concurrent Execution Safety section exists"
if grep -q "## Concurrent Execution Safety" "$SKILL_FILE"; then
    pass "Concurrent Execution Safety section exists"
else
    fail "Concurrent Execution Safety section not found"
fi

# Test 5: Read-only operations mentioned
echo "Test 5: Read-only operations documented"
if grep -q "Read-only operations" "$SKILL_FILE"; then
    pass "Read-only operations mentioned"
else
    fail "Read-only operations not documented"
fi

# Test 6: Concurrent conflict handling documented
echo "Test 6: Concurrent conflict handling documented"
if grep -q "If concurrent conflict detected:" "$SKILL_FILE"; then
    pass "Concurrent conflict handling section exists"
else
    fail "Concurrent conflict handling not documented"
fi

# Test 7: Example shows new format (COMMIT_SHAS instead of BASE_SHA/HEAD_SHA)
echo "Test 7: Example uses new format"
if grep -A 30 "## Example" "$SKILL_FILE" | grep -q "COMMIT_SHAS:"; then
    pass "Example shows COMMIT_SHAS format"
else
    fail "Example does not show COMMIT_SHAS format"
fi

# Test 8: Example shows FILES_MODIFIED
echo "Test 8: Example shows FILES_MODIFIED"
if grep -A 30 "## Example" "$SKILL_FILE" | grep -q "FILES_MODIFIED:"; then
    pass "Example shows FILES_MODIFIED format"
else
    fail "Example does not show FILES_MODIFIED format"
fi

# Test 9: Example shows safety check results
echo "Test 9: Example includes safety check results"
if grep -A 40 "## Example" "$SKILL_FILE" | grep -q "Safety Check Results"; then
    pass "Example includes safety check results"
else
    fail "Example does not include safety check results"
fi

# Test 10: Conflict examples provided (real conflict vs benign)
echo "Test 10: Conflict classification examples exist"
if grep -q "REAL CONFLICT" "$SKILL_FILE" && grep -q "BENIGN" "$SKILL_FILE"; then
    pass "Both real conflict and benign examples provided"
else
    fail "Conflict classification examples not found"
fi

# Test 11: Red Flags section updated
echo "Test 11: Red Flags section mentions concurrent conflicts"
if grep -A 10 "## Red Flags" "$SKILL_FILE" | grep -q "concurrent conflict"; then
    pass "Red Flags section mentions concurrent conflicts"
else
    fail "Red Flags section doesn't mention concurrent conflicts"
fi

# Test 12: Instructions for getting commit SHAs
echo "Test 12: Instructions for getting commit SHAs exist"
if grep -q "git log --oneline" "$SKILL_FILE"; then
    pass "Instructions for getting commit SHAs exist"
else
    fail "Instructions for getting commit SHAs not found"
fi

# Test 13: Instructions for getting files modified
echo "Test 13: Instructions for getting files modified exist"
if grep -q "git diff --name-only" "$SKILL_FILE"; then
    pass "Instructions for getting files modified exist"
else
    fail "Instructions for getting files modified not found"
fi

# Summary
echo ""
echo "=================================================================="
echo "Test Results: $PASS_COUNT passed, $FAIL_COUNT failed"
echo "=================================================================="

if [ "$FAIL_COUNT" -eq 0 ]; then
    echo "✓ All tests passed!"
    exit 0
else
    echo "✗ Some tests failed"
    exit 1
fi
