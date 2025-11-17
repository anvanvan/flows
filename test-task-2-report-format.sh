#!/bin/bash

# Test Task 2: Verify subagent report format is in the skill

echo "Testing Task 2: Subagent Report Format Implementation"
echo "======================================================="
echo ""

SKILL_FILE="skills/subagent-driven-development/SKILL.md"
TEST_FILE="docs/test-cases/subagent-report-format-test.md"

echo "Test 1: Check test case file exists"
if [ -f "$TEST_FILE" ]; then
    echo "✓ Test case file exists: $TEST_FILE"
else
    echo "✗ FAIL: Test case file not found: $TEST_FILE"
    exit 1
fi

echo ""
echo "Test 2: Check skill file contains 'Required Report Format' section"
if grep -q "## Required Report Format" "$SKILL_FILE"; then
    echo "✓ Skill contains 'Required Report Format' section"
else
    echo "✗ FAIL: Skill missing 'Required Report Format' section"
    exit 1
fi

echo ""
echo "Test 3: Check skill requires 'Commits Created' section"
if grep -q "## Commits Created" "$SKILL_FILE"; then
    echo "✓ Skill requires 'Commits Created' section"
else
    echo "✗ FAIL: Skill missing 'Commits Created' requirement"
    exit 1
fi

echo ""
echo "Test 4: Check skill requires 'Files Modified' section"
if grep -q "## Files Modified" "$SKILL_FILE"; then
    echo "✓ Skill requires 'Files Modified' section"
else
    echo "✗ FAIL: Skill missing 'Files Modified' requirement"
    exit 1
fi

echo ""
echo "Test 5: Check skill includes git log command for getting SHAs"
if grep -q "git log --oneline" "$SKILL_FILE"; then
    echo "✓ Skill includes git log command for getting SHAs"
else
    echo "✗ FAIL: Skill missing git log command"
    exit 1
fi

echo ""
echo "Test 6: Check skill includes example report"
if grep -q "## Implementation Summary" "$SKILL_FILE" && \
   grep -q "Implemented user authentication" "$SKILL_FILE"; then
    echo "✓ Skill includes example report"
else
    echo "✗ FAIL: Skill missing example report"
    exit 1
fi

echo ""
echo "Test 7: Check skill uses simplified Git Workflow (not the old Semantic Tracking)"
if grep -q "## Git Workflow for Parallel Safety" "$SKILL_FILE" && \
   ! grep -q "## Git Workflow with Semantic Tracking + Precise Staging" "$SKILL_FILE"; then
    echo "✓ Skill uses simplified Git Workflow for Parallel Safety"
else
    echo "✗ FAIL: Skill still uses old Git Workflow with Semantic Tracking"
    exit 1
fi

echo ""
echo "Test 8: Check prompt updated to say 'Report back with structured format below'"
if grep -q "5. Report back with structured format below" "$SKILL_FILE"; then
    echo "✓ Prompt updated to mention structured format"
else
    echo "✗ FAIL: Prompt not updated to mention structured format"
    exit 1
fi

echo ""
echo "======================================================="
echo "All tests passed! ✓"
echo ""
echo "Task 2 implementation verified:"
echo "- Test case file created with expected/invalid report examples"
echo "- Skill updated with Required Report Format section"
echo "- Skill requires Commits Created and Files Modified sections"
echo "- Skill includes git log command for extracting SHAs"
echo "- Skill includes example report"
echo "- Git workflow simplified to focus on parallel safety"
echo "- Prompt updated to mention structured format"
