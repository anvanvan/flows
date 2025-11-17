#!/bin/bash

# Test script for unstage-lines alias
# Tests: newly-added files, partially staged files, error handling

TEST_DIR="/tmp/test-unstage-lines-$$"
PASS_COUNT=0
FAIL_COUNT=0

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "======================================"
echo "Testing unstage-lines Git Alias"
echo "======================================"
echo ""

# Setup test repository
setup_test_repo() {
    echo "Setting up test repository at $TEST_DIR..."
    rm -rf "$TEST_DIR"
    mkdir -p "$TEST_DIR"
    cd "$TEST_DIR"
    git init -q
    git config user.name "Test User"
    git config user.email "test@example.com"

    # Create initial commit
    echo "Initial content" > existing.txt
    git add existing.txt
    git commit -q -m "Initial commit"
    echo ""
}

# Cleanup
cleanup() {
    echo ""
    echo "Cleaning up test repository..."
    cd /
    rm -rf "$TEST_DIR"
}

# Test result reporting
pass_test() {
    echo -e "${GREEN}✓ PASS:${NC} $1"
    ((PASS_COUNT++))
}

fail_test() {
    echo -e "${RED}✗ FAIL:${NC} $1"
    echo -e "  ${RED}Error:${NC} $2"
    ((FAIL_COUNT++))
}

info() {
    echo -e "${YELLOW}→${NC} $1"
}

# Test 1: Unstage newly-added file (should remove from index, make untracked)
test_unstage_newly_added_file() {
    echo "======================================"
    echo "Test 1: Unstage Newly-Added File"
    echo "======================================"

    # Create and add a new file
    echo "New file content" > newfile.txt
    git add newfile.txt

    info "Created and staged newfile.txt"

    # Verify it's staged
    if git diff --cached --name-only | grep -q "newfile.txt"; then
        info "Confirmed: newfile.txt is staged"
    else
        fail_test "newfile.txt should be staged" "File not found in staged changes"
        return
    fi

    # Unstage it
    info "Running: git unstage-lines newfile.txt"
    output=$(git unstage-lines newfile.txt 2>&1)
    exit_code=$?

    if [ $exit_code -eq 0 ]; then
        # Check that it's now untracked
        if git ls-files --error-unmatch newfile.txt 2>/dev/null; then
            fail_test "Unstage newly-added file" "File is still tracked, should be untracked"
        else
            # Verify file still exists on disk
            if [ -f newfile.txt ]; then
                pass_test "Unstage newly-added file (removed from index, kept on disk)"
            else
                fail_test "Unstage newly-added file" "File was deleted from disk"
            fi
        fi
    else
        fail_test "Unstage newly-added file" "Command failed with exit code $exit_code: $output"
    fi

    # Cleanup for next test
    rm -f newfile.txt
    echo ""
}

# Test 2: Error handling when line ranges missing for partially staged file
test_error_handling_missing_lines() {
    echo "======================================"
    echo "Test 2: Error Handling - Missing Line Ranges"
    echo "======================================"

    # Create a file with content, commit it, then modify it
    cat > testfile.txt <<'EOF'
Line 1
Line 2
Line 3
Line 4
Line 5
EOF
    git add testfile.txt
    git commit -q -m "Add testfile"

    info "Created and committed testfile.txt"

    # Modify the file
    echo "Line 6" >> testfile.txt
    echo "Line 7" >> testfile.txt

    info "Added lines 6-7 to testfile.txt"

    # Partially stage it using git add -p simulation (just add the whole file for now)
    git add testfile.txt

    info "Staged changes to testfile.txt"

    # Now unstage one line to create a partial staging scenario
    # Since we can't easily create partial staging without working filterdiff,
    # we'll test the error handling by trying to unstage without line numbers
    # after restoring to a state where the file has unstaged changes

    # Reset to have unstaged changes
    git reset HEAD testfile.txt >/dev/null 2>&1

    # Stage just one line manually by creating a partial staged state
    # Add the file completely first
    git add testfile.txt

    # Create an unstaged change
    echo "Line 8" >> testfile.txt

    info "Created mixed staged/unstaged state"

    # Try to unstage without specifying line ranges
    info "Running: git unstage-lines testfile.txt (should fail)"
    output=$(git unstage-lines testfile.txt 2>&1)
    exit_code=$?

    # This should fail because the file is not "newly added" (it exists in HEAD)
    # and we didn't provide line ranges
    if [ $exit_code -ne 0 ]; then
        if echo "$output" | grep -q "Error: Please specify line ranges"; then
            info "Got expected error message"
            if echo "$output" | grep -q "Usage: git unstage-lines <lines> <file>"; then
                pass_test "Error handling when line ranges missing (shows helpful error)"
            else
                fail_test "Error handling" "Error message missing usage instructions"
                echo "  Actual output: $output"
            fi
        else
            fail_test "Error handling" "Wrong error message. Got: $output"
        fi
    else
        fail_test "Error handling" "Should have failed but succeeded"
    fi

    echo ""
}

# Test 3: Symmetry - stage untracked, then unstage back to untracked
test_symmetry_untracked() {
    echo "======================================"
    echo "Test 3: Symmetry - Untracked → Staged → Untracked"
    echo "======================================"

    # Create untracked file
    echo "Symmetry test content" > symmetric.txt
    info "Created untracked file: symmetric.txt"

    # Verify it's untracked
    if git ls-files --error-unmatch symmetric.txt 2>/dev/null; then
        fail_test "Symmetry test - setup" "File should be untracked initially"
        rm -f symmetric.txt
        return
    fi

    # Stage it
    info "Running: git stage-lines symmetric.txt"
    output=$(git stage-lines symmetric.txt 2>&1)
    exit_code=$?

    if [ $exit_code -ne 0 ]; then
        fail_test "Symmetry test - stage" "Failed to stage untracked file: $output"
        rm -f symmetric.txt
        return
    fi

    # Verify it's staged
    if git diff --cached --name-only | grep -q "symmetric.txt"; then
        info "Confirmed: symmetric.txt is now staged"
    else
        fail_test "Symmetry test - stage" "File not found in staged changes"
        rm -f symmetric.txt
        return
    fi

    # Unstage it
    info "Running: git unstage-lines symmetric.txt"
    output=$(git unstage-lines symmetric.txt 2>&1)
    exit_code=$?

    if [ $exit_code -eq 0 ]; then
        # Verify it's untracked again
        if git ls-files --error-unmatch symmetric.txt 2>/dev/null; then
            fail_test "Symmetry test" "File should be untracked after unstage"
        else
            # Verify file still exists on disk
            if [ -f symmetric.txt ]; then
                pass_test "Symmetry test (untracked → staged → untracked)"
            else
                fail_test "Symmetry test" "File was deleted from disk"
            fi
        fi
    else
        fail_test "Symmetry test - unstage" "Failed to unstage: $output"
    fi

    # Cleanup
    rm -f symmetric.txt
    echo ""
}

# Test 4: Newly-added file detection (file staged but not in HEAD)
test_newly_added_detection() {
    echo "======================================"
    echo "Test 4: Newly-Added File Detection"
    echo "======================================"

    # Create and stage a new file
    echo "Brand new file" > brandnew.txt
    git add brandnew.txt

    info "Created and staged brandnew.txt (not in HEAD)"

    # Verify it's detected as newly-added
    if git diff --cached --diff-filter=A --name-only | grep -qx "brandnew.txt"; then
        info "Confirmed: detected as newly-added file"

        # Now unstage it
        info "Running: git unstage-lines brandnew.txt"
        output=$(git unstage-lines brandnew.txt 2>&1)
        exit_code=$?

        if [ $exit_code -eq 0 ]; then
            # Should be untracked now
            if git ls-files --error-unmatch brandnew.txt 2>/dev/null; then
                fail_test "Newly-added file detection" "File should be untracked after unstage"
            else
                if [ -f brandnew.txt ]; then
                    pass_test "Newly-added file detection and unstaging"
                else
                    fail_test "Newly-added file detection" "File was deleted from disk"
                fi
            fi
        else
            fail_test "Newly-added file detection" "Unstage command failed: $output"
        fi
    else
        fail_test "Newly-added file detection" "File not detected as newly-added"
    fi

    # Cleanup
    rm -f brandnew.txt
    echo ""
}

# Run all tests
run_all_tests() {
    setup_test_repo

    test_unstage_newly_added_file
    test_error_handling_missing_lines
    test_symmetry_untracked
    test_newly_added_detection

    cleanup
}

# Execute tests
run_all_tests

# Final summary
echo "======================================"
echo "Test Summary"
echo "======================================"
echo -e "${GREEN}Passed:${NC} $PASS_COUNT"
echo -e "${RED}Failed:${NC} $FAIL_COUNT"
echo ""

if [ $FAIL_COUNT -eq 0 ]; then
    echo -e "${GREEN}All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}Some tests failed!${NC}"
    exit 1
fi
