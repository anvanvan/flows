#!/bin/bash
# Verification script for Task 3 implementation

set -e

echo "=== Task 3 Verification ==="
echo

# Check 1: Test case file exists
echo "✓ Check 1: Test case file exists"
if [ -f "docs/test-cases/report-parsing-test.md" ]; then
    echo "  PASS: report-parsing-test.md exists"
else
    echo "  FAIL: report-parsing-test.md missing"
    exit 1
fi
echo

# Check 2: Test case contains required sections
echo "✓ Check 2: Test case contains required sections"
required_sections=("Valid Report" "Edge Cases" "Short SHAs" "Full SHAs" "Missing Commits Created section" "Missing Files Modified section")
for section in "${required_sections[@]}"; do
    if grep -q "$section" docs/test-cases/report-parsing-test.md; then
        echo "  PASS: Found section '$section'"
    else
        echo "  FAIL: Missing section '$section'"
        exit 1
    fi
done
echo

# Check 3: SKILL.md no longer uses BASE_SHA/HEAD_SHA
echo "✓ Check 3: SKILL.md no longer uses BASE_SHA/HEAD_SHA"
if ! grep -q "BASE_SHA\|HEAD_SHA" skills/subagent-driven-development/SKILL.md; then
    echo "  PASS: No BASE_SHA or HEAD_SHA found"
else
    echo "  FAIL: Still contains BASE_SHA or HEAD_SHA"
    grep -n "BASE_SHA\|HEAD_SHA" skills/subagent-driven-development/SKILL.md
    exit 1
fi
echo

# Check 4: SKILL.md uses COMMIT_SHAS and FILES_MODIFIED
echo "✓ Check 4: SKILL.md uses COMMIT_SHAS and FILES_MODIFIED"
if grep -q "COMMIT_SHAS:" skills/subagent-driven-development/SKILL.md && \
   grep -q "FILES_MODIFIED:" skills/subagent-driven-development/SKILL.md; then
    echo "  PASS: Found COMMIT_SHAS and FILES_MODIFIED"
else
    echo "  FAIL: Missing COMMIT_SHAS or FILES_MODIFIED"
    exit 1
fi
echo

# Check 5: Parsing logic present
echo "✓ Check 5: Parsing logic present"
parsing_sections=("Parse subagent report" "Extract commit SHAs" "Extract files modified" "Validate extracted data")
for section in "${parsing_sections[@]}"; do
    if grep -q "$section" skills/subagent-driven-development/SKILL.md; then
        echo "  PASS: Found '$section'"
    else
        echo "  FAIL: Missing '$section'"
        exit 1
    fi
done
echo

# Check 6: Safety check failure handling present
echo "✓ Check 6: Safety check failure handling present"
safety_sections=("Handle safety check failures" "Concurrent modification conflict" "Commit not found" "Uncommitted changes")
for section in "${safety_sections[@]}"; do
    if grep -q "$section" skills/subagent-driven-development/SKILL.md; then
        echo "  PASS: Found '$section'"
    else
        echo "  FAIL: Missing '$section'"
        exit 1
    fi
done
echo

# Check 7: User decision prompts present
echo "✓ Check 7: User decision prompts present"
if grep -q "Options:" skills/subagent-driven-development/SKILL.md && \
   grep -q "What would you like to do?" skills/subagent-driven-development/SKILL.md; then
    echo "  PASS: Found user decision prompts"
else
    echo "  FAIL: Missing user decision prompts"
    exit 1
fi
echo

# Check 8: Commit exists
echo "✓ Check 8: Commit exists"
if git log --oneline -1 | grep -q "feat: add report parsing and concurrent-safe review invocation"; then
    echo "  PASS: Commit found"
    git log --oneline -1
else
    echo "  FAIL: Expected commit not found"
    exit 1
fi
echo

echo "=== All Checks Passed ==="
echo
echo "Task 3 implementation verified successfully!"
