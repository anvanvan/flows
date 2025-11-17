# Git Stage-Lines: Adoption Plan for Untracked Files Support

## Overview

This plan outlines the tasks needed to adopt the new git stage-lines and unstage-lines implementations (from `2025-11-10-git-stage-lines-untracked-files-design.md`) across the flows repository.

## Prerequisites

- The implementation from `2025-11-10-git-stage-lines-untracked-files-design.md` is complete
- The new alias code has been tested and validated
- Developer has the new aliases configured locally for testing

## Tasks

### 1. Update setup.sh Configuration

**Objective:** Replace old alias definitions with new implementations that support untracked files.

**Changes needed:**
- Locate the current `git config --global alias.stage-lines` command in setup.sh
- Replace with the new implementation from design doc (lines 59-84)
- Locate the current `git config --global alias.unstage-lines` command
- Replace with the new implementation from design doc (lines 90-115)
- Ensure aliases are properly escaped for shell script usage

**Verification:**
- The setup.sh already has verification logic that runs test commands
- Keep simple verification that confirms aliases are installed
- Functional testing is covered by the implementation plan

**Notes:**
- Users who have already run the old setup.sh will have old aliases
- Running setup.sh again with `--global` will overwrite them automatically
- No migration needed - the new aliases are backwards compatible

**Deliverable:** Updated setup.sh with new alias code and working verification

---

### 2. Update README.md

**Objective:** Update user-facing documentation to explain new behavior.

**Changes needed:**
- Update the usage examples section to show both patterns:
  - `git stage-lines 10-20 file.js` (tracked files with line ranges)
  - `git stage-lines untracked-file.js` (untracked files, no line ranges)
- Add brief explanation (1-2 sentences) of automatic file state detection
- Update symmetric unstage-lines examples similarly
- Ensure the "why it matters" section still accurately reflects the workflow

**Key messaging:**
- Line ranges are required for tracked files
- Line ranges are optional (ignored) for untracked files
- The command automatically detects which case applies

**Deliverable:** README.md clearly explains when line ranges are required vs optional

---

### 3. Update RELEASE-NOTES.md

**Objective:** Document the enhancement in release notes.

**Changes needed:**
- Add entry for untracked file support enhancement
- Note that it's backwards-compatible (existing usage still works)
- Mention that setup.sh has been updated with new implementation

**Deliverable:** RELEASE-NOTES.md documents the enhancement

---

### 4. Update skills/writing-plans/SKILL.md

**Objective:** Ensure skill examples demonstrate correct usage patterns.

**Current state:**
- Line 85 shows: `git stage-lines tests/path/test.py src/path/file.py`
- This doesn't show line ranges, which would only work for untracked files

**Changes needed:**
- Update example to show line ranges explicitly: `git stage-lines 1-50 tests/path/test.py`
- Or add a note explaining when line ranges are optional
- Ensure the example matches typical TDD workflow scenarios (staging new test files vs staging changes to existing files)

**Deliverable:** Example accurately demonstrates the new usage pattern in TDD context

---

### 5. Update skills/sharing-skills/SKILL.md

**Objective:** Clarify skill contribution workflow examples.

**Current state:**
- Lines 65 and 120 show: `git stage-lines skills/your-skill-name/`
- This works for new untracked skill directories

**Changes needed:**
- Clarify this is the shorthand for untracked files/directories
- Or show line ranges if demonstrating modifications to existing skills
- Ensure examples match actual workflow scenarios

**Deliverable:** Examples match real usage patterns for contributing skills

---

### 6. End-to-End Verification

**Objective:** Ensure adoption is complete and functional.

**Setup.sh verification:**
1. Test setup.sh in a clean environment (or with aliases removed temporarily)
2. Run `./setup.sh` and confirm it installs patchutils and configures aliases
3. Verify installed aliases match new implementation: `git config --global alias.stage-lines`
4. Run verification commands from setup.sh to confirm they work

**Manual smoke test:**
Create a test directory and verify:
- Staging untracked file without line ranges works
- Staging tracked file with line ranges works
- Unstaging newly-added file works
- Unstaging partial changes with line ranges works
- Error messages are helpful when line ranges are missing for tracked files

**Deliverable:**
- Confidence that setup.sh installs working aliases
- Documentation accurately reflects actual behavior
- Skills examples demonstrate valid usage patterns

---

### 7. Final Commit

**Commit all changes together:**
```bash
git add setup.sh README.md RELEASE-NOTES.md skills/writing-plans/SKILL.md skills/sharing-skills/SKILL.md
git commit -m "feat: adopt git stage-lines untracked file support

Updates setup.sh, documentation, and skill examples to use the new
git stage-lines and unstage-lines implementations that automatically
handle both tracked and untracked files.

Implements adoption plan from docs/plans/2025-11-10-git-stage-lines-adoption-plan.md
Based on design from docs/plans/2025-11-10-git-stage-lines-untracked-files-design.md"
```

## Success Criteria

- [ ] setup.sh installs the new aliases correctly
- [ ] README.md clearly explains both usage patterns
- [ ] RELEASE-NOTES.md documents the enhancement
- [ ] Skill examples are accurate and helpful
- [ ] End-to-end verification passes
- [ ] All changes committed and documented
