# Concurrent Code Review Test Suite

This document contains test scenarios for verifying the concurrent-safe code review implementation.

## Test 1: Basic Sequential Review (Baseline)

**Scenario:**
1. Task subagent creates 2 commits
2. No concurrent work happens
3. Code reviewer reviews the commits

**Setup:**
```bash
# Create test branch
git checkout -b test-sequential-review

# Make changes and commit
echo "function test() { return 42; }" > src/test.js
git add src/test.js
git commit -m "feat: add test function"

echo "test('basic', () => { assert(test() === 42); });" > tests/test.test.js
git add tests/test.test.js
git commit -m "test: add test for test function"

# Get commit SHAs
git log --oneline -n 2
```

**Expected subagent report:**
```
## Commits Created
- <SHA2> (test: add test for test function)
- <SHA1> (feat: add test function)

## Files Modified
- src/test.js (created)
- tests/test.test.js (created)
```

**Expected code reviewer behavior:**
- Safety checks: ✓ All commits exist
- Safety checks: ✓ No concurrent modifications
- Safety checks: ✓ No uncommitted changes
- Status: Safe to proceed with review
- Reviews both commits successfully

**Verification:**
Working tree unchanged, HEAD unchanged, review completed

---

## Test 2: Benign Concurrent Modification

**Scenario:**
1. Task subagent creates commits modifying `auth.js` lines 10-25
2. Concurrent work creates commit modifying `auth.js` lines 100-120
3. Code reviewer detects concurrent change but classifies as benign

**Setup:**
```bash
git checkout -b test-benign-concurrent

# Task work
cat > src/auth.js <<EOF
// Lines 1-9: existing code
function authenticate(user, pass) {
  // Lines 10-25: task's changes
  if (!user || !pass) {
    throw new Error('Missing credentials');
  }
  return validateCredentials(user, pass);
}
// Lines 26-99: existing code
function helper() {
  // Lines 100-120: will be modified by concurrent work
  return 'helper';
}
EOF

git add src/auth.js
TASK_SHA=$(git commit -m "feat: add authentication validation" | grep -o '[a-f0-9]\{40\}')

# Concurrent work (modify different section)
sed -i '' 's/helper/utilityHelper/g' src/auth.js
git add src/auth.js
git commit -m "refactor: rename helper to utilityHelper"
```

**Expected code reviewer behavior:**
- Safety checks: ✓ All commits exist
- Safety checks: Concurrent changes detected in `src/auth.js`
  - Task modified lines: 10-25
  - Concurrent modified lines: 100-120
  - Classification: BENIGN (no overlap, sufficient distance)
- Note in review: "Concurrent changes detected (non-conflicting)"
- Status: Safe to proceed with review
- Reviews task's commit successfully

**Verification:**
- Code reviewer reports concurrent modification
- Classified as benign
- Review completes
- No Critical issues raised

---

## Test 3: Real Concurrent Conflict

**Scenario:**
1. Task subagent creates commit modifying `auth.js` lines 10-25
2. Concurrent work creates commit modifying `auth.js` lines 15-30
3. Code reviewer detects overlapping changes and flags as REAL CONFLICT

**Setup:**
```bash
git checkout -b test-conflict

# Task work
cat > src/auth.js <<EOF
function authenticate(user, pass) {
  // Lines 10-25: task's changes
  if (!user || !pass) {
    throw new Error('Missing credentials');
  }
  // Lines 20-25: overlap zone
  return validateCredentials(user, pass);
}
EOF

git add src/auth.js
TASK_SHA=$(git commit -m "feat: add authentication validation" | grep -o '[a-f0-9]\{40\}')

# Concurrent work (modify overlapping section, lines 15-30)
cat > src/auth.js <<EOF
function authenticate(user, pass) {
  if (!user || !pass) {
    throw new Error('Missing credentials');
  }
  // Lines 15-30: concurrent changes (overlaps with task's 20-25)
  const validated = validateCredentials(user, pass);
  logAuthAttempt(user);
  return validated;
}
EOF

git add src/auth.js
git commit -m "feat: add auth attempt logging"
```

**Expected code reviewer behavior:**
- Safety checks: ✓ All commits exist
- Safety checks: Concurrent changes detected in `src/auth.js`
  - Task modified lines: 10-25
  - Concurrent modified lines: 15-30
  - Overlapping range: 15-25
  - Classification: REAL CONFLICT
- Status: **SAFETY CHECK FAILED**
- Report: "Concurrent modification conflict detected in src/auth.js"
- Includes both diffs in report
- Stops review, asks user how to proceed

**Verification:**
- Code reviewer STOPS immediately
- Reports Critical issue
- Shows both diffs
- Does not complete review
- No working tree modifications

---

## Test 4: Missing Commit (Amended/Rebased)

**Scenario:**
1. Task subagent creates commit ABC
2. Commit gets amended to ABC' before review
3. Code reviewer can't find ABC, reports error

**Setup:**
```bash
git checkout -b test-missing-commit

# Task work
echo "function test() { return 42; }" > src/test.js
git add src/test.js
ORIGINAL_SHA=$(git commit -m "feat: add test function" | grep -o '[a-f0-9]\{40\}')

# Amend the commit (simulates rebase/amend)
echo "// Added comment" >> src/test.js
git add src/test.js
git commit --amend --no-edit
NEW_SHA=$(git rev-parse HEAD)

# Code reviewer tries to review ORIGINAL_SHA (which no longer exists)
```

**Subagent reports SHA:** $ORIGINAL_SHA

**Expected code reviewer behavior:**
- Safety checks: Try to verify commit $ORIGINAL_SHA
- Run: `git cat-file -t $ORIGINAL_SHA`
- Result: Error "Not a valid object name"
- Status: **SAFETY CHECK FAILED**
- Report: "Commit $ORIGINAL_SHA not found - may have been amended or rebased"
- Includes current HEAD: $NEW_SHA
- Includes recent commits: `git log --oneline -5`
- Stops review, asks user to investigate

**Verification:**
- Code reviewer STOPS immediately
- Reports missing commit error
- Provides diagnostic info
- Does not complete review
- No working tree modifications

---

## Test 5: Uncommitted Changes

**Scenario:**
1. Task subagent creates commit modifying `auth.js`
2. Task subagent makes additional changes to `auth.js` but forgets to commit
3. Code reviewer detects uncommitted changes

**Setup:**
```bash
git checkout -b test-uncommitted

# Task work (committed)
echo "function authenticate() { return true; }" > src/auth.js
git add src/auth.js
TASK_SHA=$(git commit -m "feat: add authentication" | grep -o '[a-f0-9]\{40\}')

# Task work (uncommitted - forgot to commit)
echo "function logout() { return false; }" >> src/auth.js

# Code reviewer runs
```

**Expected code reviewer behavior:**
- Safety checks: ✓ All commits exist
- Safety checks: ✓ No concurrent modifications (HEAD = TASK_SHA)
- Safety checks: Check for uncommitted changes in `src/auth.js`
  - Run: `git diff src/auth.js`
  - Result: Shows uncommitted changes
- Status: Uncommitted changes detected
- Flags as **Important issue** in review:
  ```
  Important: Uncommitted changes in src/auth.js
  - File: src/auth.js:+logout function
  - Issue: Task made changes but didn't commit them
  - Why it matters: Changes aren't versioned, could be lost
  - Fix: Commit all task changes
  ```
- Continues with review (not Critical, but Important)

**Verification:**
- Code reviewer completes review
- Important issue raised about uncommitted changes
- No working tree modifications
- Uncommitted changes still present

---

## Test 6: Multiple Parallel Task Subagents

**Scenario:**
1. Task subagent A modifying `auth.js`, commits
2. Task subagent B modifying `db.js`, commits (parallel)
3. Task subagent C modifying `routes.js`, commits (parallel)
4. Code reviewer A reviews A's commits (should not see B or C's work)
5. Code reviewer B reviews B's commits (should not see A or C's work)
6. Code reviewer C reviews C's commits (should not see A or B's work)

**Setup:**
```bash
git checkout -b test-parallel-tasks

# Task A
echo "auth content" > src/auth.js
git add src/auth.js
SHA_A=$(git commit -m "feat: add auth" | grep -o '[a-f0-9]\{40\}')

# Task B (parallel)
echo "db content" > src/db.js
git add src/db.js
SHA_B=$(git commit -m "feat: add db" | grep -o '[a-f0-9]\{40\}')

# Task C (parallel)
echo "routes content" > src/routes.js
git add src/routes.js
SHA_C=$(git commit -m "feat: add routes" | grep -o '[a-f0-9]\{40\}')
```

**Expected behavior:**

**Reviewer A (reviews SHA_A):**
- Reviews only commit SHA_A
- Sees only `src/auth.js` changes
- Does not see B or C's work in the diff
- Safety checks pass (no concurrent mods to auth.js)

**Reviewer B (reviews SHA_B):**
- Reviews only commit SHA_B
- Sees only `src/db.js` changes
- Detects concurrent modifications: YES (A and C's commits happened)
- Checks if concurrent work touched `src/db.js`: NO
- Safety checks pass (no concurrent mods to db.js)

**Reviewer C (reviews SHA_C):**
- Reviews only commit SHA_C
- Sees only `src/routes.js` changes
- Detects concurrent modifications: YES (A and B's commits happened)
- Checks if concurrent work touched `src/routes.js`: NO
- Safety checks pass (no concurrent mods to routes.js)

**Verification:**
- All three reviewers complete successfully
- Each reviews only their task's commits
- No interference between reviews
- No working tree modifications by any reviewer

---

## Test 7: File Deleted by Concurrent Work

**Scenario:**
1. Task subagent modifies `temp.js`
2. Concurrent work deletes `temp.js`
3. Code reviewer detects file deletion

**Setup:**
```bash
git checkout -b test-file-deleted

# Task work
echo "temp content" > src/temp.js
git add src/temp.js
TASK_SHA=$(git commit -m "feat: add temp feature" | grep -o '[a-f0-9]\{40\}')

# Concurrent work deletes the file
git rm src/temp.js
git commit -m "refactor: remove temp feature"
```

**Expected code reviewer behavior:**
- Safety checks: ✓ All commits exist
- Safety checks: Check concurrent modifications to `src/temp.js`
  - Run: `git diff $TASK_SHA HEAD -- src/temp.js`
  - Result: Entire file deleted
- Status: **SAFETY CHECK FAILED** or **Critical Issue**
- Report: "File src/temp.js deleted by concurrent work - task's changes lost"
- Stops review, asks user how to proceed

**Verification:**
- Code reviewer detects deletion
- Reports as Critical issue
- Provides details about deletion
- No working tree modifications

---

## Test 8: File Renamed by Concurrent Work

**Scenario:**
1. Task subagent modifies `auth.js`
2. Concurrent work renames `auth.js` to `authentication.js`
3. Code reviewer detects file rename

**Setup:**
```bash
git checkout -b test-file-renamed

# Task work
echo "auth content" > src/auth.js
git add src/auth.js
TASK_SHA=$(git commit -m "feat: add auth logic" | grep -o '[a-f0-9]\{40\}')

# Concurrent work renames the file
git mv src/auth.js src/authentication.js
git commit -m "refactor: rename auth.js to authentication.js"
```

**Expected code reviewer behavior:**
- Safety checks: ✓ All commits exist
- Safety checks: Check concurrent modifications to `src/auth.js`
  - Run: `git diff $TASK_SHA HEAD -- src/auth.js`
  - Result: File deleted (renamed)
  - Optional: Run `git log --follow -- src/auth.js` to detect rename
- Status: **Important Issue** (not Critical, but needs attention)
- Report: "File src/auth.js renamed to src/authentication.js - manual verification needed"
- Continues review but flags the rename

**Verification:**
- Code reviewer detects rename (or deletion)
- Reports as Important issue
- Suggests manual verification
- Review may continue or stop depending on implementation

---

## Running the Tests

**Manual verification:**
1. Create test branches for each scenario
2. Follow setup steps
3. Dispatch code-reviewer with test data
4. Verify expected behavior matches actual behavior
5. Document any discrepancies

**Automated verification (future):**
Create shell script that:
1. Sets up each test scenario
2. Invokes code-reviewer
3. Parses output
4. Asserts expected behavior
5. Reports PASS/FAIL for each test

---

## Success Criteria

All tests pass if:
- ✓ Sequential review works (baseline)
- ✓ Benign concurrent changes noted but don't block review
- ✓ Real conflicts detected and block review
- ✓ Missing commits detected and reported
- ✓ Uncommitted changes flagged as Important
- ✓ Parallel reviews don't interfere with each other
- ✓ File deletions detected
- ✓ File renames detected (or flagged as deletion)
- ✓ No working tree modifications in any scenario
- ✓ All git operations are read-only

---

## Regression Testing

After any changes to code-reviewer template or subagent-driven-development:
1. Re-run all 8 test scenarios
2. Verify behavior matches expected
3. Update tests if behavior intentionally changed
4. Document any new edge cases discovered
