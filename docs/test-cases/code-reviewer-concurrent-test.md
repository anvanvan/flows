# Code Reviewer Concurrent Safety Test

## Scenario
1. Task subagent creates commits ABC, DEF
2. Concurrent work creates commit GHI touching same file
3. Code reviewer should detect concurrent modification

## Expected Behavior
- Safety checks verify ABC, DEF exist
- Detect GHI modified same file as ABC/DEF
- Classify as real conflict or benign
- Report in Safety Check Results section

## Test Data
- COMMIT_SHAS: ["abc123", "def456"]
- FILES_MODIFIED: ["src/auth.js", "tests/auth.test.js"]
- Concurrent commit: ghi789 modified src/auth.js line 50
- Task commits: modified src/auth.js lines 10-20
