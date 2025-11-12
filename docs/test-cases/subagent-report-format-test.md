# Subagent Report Format Test

## Expected Report Structure

```
## Implementation Summary
Implemented user authentication with JWT tokens. Created login/logout endpoints.

## Testing
Wrote 8 tests covering:
- Valid login (200 response)
- Invalid credentials (401)
- Token expiry (401)
- Logout (clears session)

All tests passing (8/8).

## Commits Created
- a1b2c3d4e5f6 (feat: add auth endpoints and JWT middleware)
- f6e5d4c3b2a1 (test: add auth integration tests)

## Files Modified
- src/auth/login.js (created)
- src/auth/middleware.js (created)
- src/routes.js (modified, added auth routes)
- tests/auth.test.js (created)

## Issues Encountered
None. Implementation followed plan exactly.
```

## Invalid Reports (should be detected and fixed)

**Missing commit SHAs:**
```
## Implementation Summary
[content]

## Testing
[content]

## Files Modified
[list]
```
Should prompt: "Please add 'Commits Created' section with your commit SHAs"

**Malformed SHA:**
```
## Commits Created
- commit abc123 (message)
- def456
```
Should accept both formats (with or without "commit" prefix and message)
