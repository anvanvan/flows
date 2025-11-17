#!/bin/bash

# Test Task 7: Final Verification and Documentation
# Verifies that user-facing documentation is complete and consistent

echo "=== Task 7: Documentation Verification ==="
echo

# Test 1: Verify new documentation file exists
echo "Test 1: Check docs/concurrent-safe-code-review.md exists"
if [ -f docs/concurrent-safe-code-review.md ]; then
    echo "✓ Documentation file exists"
else
    echo "✗ FAIL: Documentation file not found"
    exit 1
fi
echo

# Test 2: Verify README has link to new documentation
echo "Test 2: Check README.md has link to concurrent-safe-code-review.md"
if grep -q "Concurrent-Safe Code Review" README.md && grep -q "docs/concurrent-safe-code-review.md" README.md; then
    echo "✓ README contains link to documentation"
else
    echo "✗ FAIL: README missing link"
    exit 1
fi
echo

# Test 3: Verify documentation has required sections
echo "Test 3: Check documentation has all required sections"
required_sections=(
    "The Problem"
    "The Solution"
    "How It Works"
    "Conflict Classification"
    "Edge Cases"
    "Benefits"
    "Usage"
    "Testing"
    "Limitations"
)

all_found=true
for section in "${required_sections[@]}"; do
    if grep -q "## $section" docs/concurrent-safe-code-review.md; then
        echo "  ✓ Section found: $section"
    else
        echo "  ✗ Missing section: $section"
        all_found=false
    fi
done

if [ "$all_found" = false ]; then
    echo "✗ FAIL: Some required sections missing"
    exit 1
fi
echo

# Test 4: Verify no references to deprecated BASE_SHA/HEAD_SHA in new docs
echo "Test 4: Check no deprecated BASE_SHA/HEAD_SHA usage (except as examples of what NOT to do)"
if grep -E "BASE_SHA|HEAD_SHA" docs/concurrent-safe-code-review.md | grep -v "deprecated" | grep -v "Do NOT use" | grep -v "BASE_SHA..HEAD_SHA"; then
    echo "✗ FAIL: Found non-deprecated references to BASE_SHA/HEAD_SHA"
    exit 1
else
    echo "✓ No improper BASE_SHA/HEAD_SHA references"
fi
echo

# Test 5: Verify documentation mentions COMMIT_SHAS and FILES_MODIFIED
echo "Test 5: Check documentation uses COMMIT_SHAS and FILES_MODIFIED terminology"
if grep -q "COMMIT_SHAS" docs/concurrent-safe-code-review.md && grep -q "FILES_MODIFIED" docs/concurrent-safe-code-review.md; then
    echo "✓ Uses correct terminology (COMMIT_SHAS, FILES_MODIFIED)"
else
    echo "✗ FAIL: Missing COMMIT_SHAS or FILES_MODIFIED terminology"
    exit 1
fi
echo

# Test 6: Verify documentation emphasizes read-only operations
echo "Test 6: Check documentation emphasizes read-only operations"
if grep -q "read-only" docs/concurrent-safe-code-review.md || grep -q "Read-Only" docs/concurrent-safe-code-review.md; then
    echo "✓ Mentions read-only operations"
else
    echo "✗ FAIL: Doesn't emphasize read-only operations"
    exit 1
fi
echo

# Test 7: Verify documentation links to test suite
echo "Test 7: Check documentation links to test suite"
if grep -q "concurrent-code-review-test-suite.md" docs/concurrent-safe-code-review.md; then
    echo "✓ Links to test suite"
else
    echo "✗ FAIL: Missing link to test suite"
    exit 1
fi
echo

# Test 8: Verify test suite exists
echo "Test 8: Check test suite exists"
if [ -f docs/test-cases/concurrent-code-review-test-suite.md ]; then
    echo "✓ Test suite exists"
else
    echo "✗ FAIL: Test suite not found"
    exit 1
fi
echo

# Test 9: Verify key files mention concurrent-safety
echo "Test 9: Check key files mention concurrent-safety concepts"
files_to_check=(
    "skills/requesting-code-review/code-reviewer.md"
    "skills/requesting-code-review/SKILL.md"
    "agents/code-reviewer.md"
)

all_mention=true
for file in "${files_to_check[@]}"; do
    if grep -qi "concurrent\|safety\|read-only" "$file"; then
        echo "  ✓ $file mentions concurrent-safety concepts"
    else
        echo "  ✗ $file doesn't mention concurrent-safety"
        all_mention=false
    fi
done

if [ "$all_mention" = false ]; then
    echo "✗ FAIL: Some files don't mention concurrent-safety"
    exit 1
fi
echo

# Test 10: Verify BASE_SHA/HEAD_SHA is properly deprecated in SKILL.md
echo "Test 10: Check BASE_SHA/HEAD_SHA is marked as deprecated"
if grep -q "BASE_SHA/HEAD_SHA.*deprecated" skills/requesting-code-review/SKILL.md; then
    echo "✓ BASE_SHA/HEAD_SHA properly marked as deprecated"
else
    echo "✗ FAIL: BASE_SHA/HEAD_SHA not marked as deprecated"
    exit 1
fi
echo

echo "=== All Tests Passed ==="
echo
echo "Summary:"
echo "- User-facing documentation created: docs/concurrent-safe-code-review.md"
echo "- README updated with link to new documentation"
echo "- All required sections present"
echo "- Uses correct terminology (COMMIT_SHAS, FILES_MODIFIED)"
echo "- Emphasizes read-only operations"
echo "- Links to comprehensive test suite"
echo "- All key files mention concurrent-safety"
echo "- Deprecated approach properly marked"
