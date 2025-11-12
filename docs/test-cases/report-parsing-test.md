# Report Parsing Test Cases

## Valid Report

Input:
```
## Implementation Summary
Added feature X

## Testing
5 tests, all passing

## Commits Created
- a1b2c3d (feat: add feature X)
- f6e5d4c (test: add tests)

## Files Modified
- src/feature.js (created)
- tests/feature.test.js (created)

## Issues Encountered
None
```

Expected extraction:
- COMMIT_SHAS: ["a1b2c3d", "f6e5d4c"]
- FILES_MODIFIED: ["src/feature.js", "tests/feature.test.js"]

## Edge Cases

**Short SHAs (7 chars):**
```
## Commits Created
- a1b2c3d (message)
```
Accept: Yes (git supports short SHAs)

**Full SHAs (40 chars):**
```
## Commits Created
- a1b2c3d4e5f6789012345678901234567890 (message)
```
Accept: Yes

**With "commit" prefix:**
```
## Commits Created
- commit a1b2c3d (message)
```
Extract: "a1b2c3d" (strip "commit" prefix)

**Missing Commits Created section:**
Error: "Report missing 'Commits Created' section. Please add your commit SHAs."

**Missing Files Modified section:**
Error: "Report missing 'Files Modified' section. Please list all files you changed."

**Malformed SHA (not hex):**
```
## Commits Created
- xyz123 (message)
```
Warning: "SHA 'xyz123' appears invalid (not hexadecimal). Proceeding anyway, will fail in safety check."
