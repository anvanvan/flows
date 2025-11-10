#!/bin/bash
# Automated setup for flows plugin git stage-lines prerequisites

set -e

echo "=========================================="
echo "Flows Plugin Setup"
echo "=========================================="
echo ""

# Check if patchutils is installed
echo "Checking for patchutils/filterdiff..."
if ! command -v filterdiff &> /dev/null; then
    echo "❌ filterdiff not found"
    echo "📦 Installing patchutils via brew..."

    if ! command -v brew &> /dev/null; then
        echo "❌ Error: Homebrew is not installed"
        echo "   Please install Homebrew first: https://brew.sh"
        exit 1
    fi

    brew install patchutils
    echo "✓ patchutils installed"
else
    echo "✓ filterdiff found at $(which filterdiff)"
fi

echo ""

# Check if git aliases already exist
echo "Configuring git aliases..."

existing_stage=$(git config --global --get alias.stage-lines 2>/dev/null || echo "")
existing_unstage=$(git config --global --get alias.unstage-lines 2>/dev/null || echo "")

if [ -n "$existing_stage" ] || [ -n "$existing_unstage" ]; then
    echo "⚠️  Git aliases already exist:"
    [ -n "$existing_stage" ] && echo "   - stage-lines: $existing_stage"
    [ -n "$existing_unstage" ] && echo "   - unstage-lines: $existing_unstage"
    echo ""
    read -p "Overwrite existing aliases? (y/N): " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Skipping alias configuration"
        exit 0
    fi
fi

# Configure the aliases
git config --global alias.stage-lines '!f() {
  # Handle parameter patterns
  if [ -z "$2" ]; then
    file="$1"
    lines=""
  else
    lines="$1"
    file="$2"
  fi

  # Check if file is tracked
  if git ls-files --error-unmatch "$file" 2>/dev/null; then
    # Tracked file: require line ranges
    if [ -z "$lines" ]; then
      echo "Error: Please specify line ranges (e.g., 1-5,8,10-12)" >&2
      echo "Usage: git stage-lines <lines> <file>" >&2
      echo "       git stage-lines <untracked-file>" >&2
      return 1
    fi
    # Use filterdiff for line-level staging
    git diff "$file" | filterdiff --lines="$lines" | git apply --cached --unidiff-zero
  else
    # Untracked file: stage entire file
    git add "$file"
  fi
}; f'

git config --global alias.unstage-lines '!f() {
  # Handle parameter patterns
  if [ -z "$2" ]; then
    file="$1"
    lines=""
  else
    lines="$1"
    file="$2"
  fi

  # Check if file is newly added
  if git diff --cached --diff-filter=A --name-only | grep -qx "$file"; then
    # Newly added file: remove from index, make untracked
    git rm --cached "$file"
  else
    # Partial staged changes: require line ranges
    if [ -z "$lines" ]; then
      echo "Error: Please specify line ranges (e.g., 1-5,8,10-12)" >&2
      echo "Usage: git unstage-lines <lines> <file>" >&2
      echo "       git unstage-lines <newly-added-file>" >&2
      return 1
    fi
    # Use filterdiff reverse for line-level unstaging
    git diff --cached "$file" | filterdiff --lines="$lines" | git apply --cached --unidiff-zero --reverse
  fi
}; f'

echo "✓ Git aliases configured"
echo ""

# Verify setup
echo "Verifying setup..."
if git config --global --get alias.stage-lines &> /dev/null && \
   git config --global --get alias.unstage-lines &> /dev/null; then
    echo "✓ Setup complete!"
    echo ""
    echo "You can now use:"
    echo "  git stage-lines 10-25 path/to/file"
    echo "  git unstage-lines 15-20 path/to/file"
else
    echo "❌ Setup verification failed"
    exit 1
fi

echo ""
echo "=========================================="
