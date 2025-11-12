# Task 5: Agent Description Concurrent-Safety Test

## Purpose
Verify that the code-reviewer agent description properly mentions concurrent-safety and includes appropriate guidance for handling concurrent conflicts.

## Test Cases

### Test 1: Frontmatter Description Mentions Concurrent-Safety

**Requirement:** The agent description field should mention concurrent-safety.

**Test:**
```bash
grep -n "Concurrent-safe" agents/code-reviewer.md
```

**Expected:** Line 3 contains "Concurrent-safe: uses commit-SHA-list approach to avoid conflicts with parallel work"

### Test 2: Concurrent Execution Safety Section Exists

**Requirement:** There should be a section explaining concurrent execution safety after the main role description.

**Test:**
```bash
grep -A 2 "Concurrent Execution Safety" agents/code-reviewer.md
```

**Expected:**
- Mentions "concurrent environment"
- Mentions "read-only git operations"
- Mentions "explicit commit SHAs"
- Mentions "detect and report concurrent modifications"

### Test 3: Concurrent Conflicts Marked as Critical Issues

**Requirement:** The "Issue Identification and Recommendations" section should state that concurrent conflicts are ALWAYS Critical.

**Test:**
```bash
grep -A 5 "Issue Identification and Recommendations" agents/code-reviewer.md | grep -i "concurrent"
```

**Expected:** Line contains "Concurrent modification conflicts are ALWAYS Critical issues"

### Test 4: Communication Protocol Handles Concurrent Conflicts

**Requirement:** The "Communication Protocol" section should mention handling concurrent conflicts first.

**Test:**
```bash
grep -A 5 "Communication Protocol" agents/code-reviewer.md | head -2
```

**Expected:** First bullet point mentions "concurrent modification conflicts, STOP and report immediately"

## Verification Script

```bash
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
    fi
    if grep -A 3 "Concurrent Execution Safety:" agents/code-reviewer.md | grep -q "explicit commit SHAs"; then
        echo "✓ PASS: Mentions explicit commit SHAs"
    else
        echo "✗ FAIL: Doesn't mention explicit commit SHAs"
    fi
else
    echo "✗ FAIL: 'Concurrent Execution Safety:' section not found"
fi
echo

# Test 3
echo "Test 3: Concurrent conflicts marked as Critical"
if grep -A 5 "Issue Identification and Recommendations" agents/code-reviewer.md | grep -q "Concurrent modification conflicts are ALWAYS Critical"; then
    echo "✓ PASS: Concurrent conflicts marked as ALWAYS Critical"
else
    echo "✗ FAIL: Concurrent conflicts not marked as ALWAYS Critical"
fi
echo

# Test 4
echo "Test 4: Communication protocol handles concurrent conflicts"
if grep -A 1 "Communication Protocol" agents/code-reviewer.md | grep -q "concurrent modification conflicts, STOP"; then
    echo "✓ PASS: First protocol item handles concurrent conflicts"
else
    echo "✗ FAIL: First protocol item doesn't handle concurrent conflicts"
fi
echo

echo "=========================================="
echo "Test suite completed"
```

## Expected Results

All 4 tests should pass:
- ✓ Test 1: Frontmatter mentions concurrent-safety
- ✓ Test 2: Concurrent Execution Safety section exists with key phrases
- ✓ Test 3: Concurrent conflicts marked as Critical
- ✓ Test 4: Communication protocol handles concurrent conflicts first
