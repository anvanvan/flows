#!/usr/bin/env bash
# SessionStart hook for flows plugin

set -euo pipefail

# Determine plugin root directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
PLUGIN_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Check if legacy skills directory exists and build warning
warning_message=""
legacy_skills_dir="${HOME}/.config/flows/skills"
if [ -d "$legacy_skills_dir" ]; then
    warning_message="\n\n<important-reminder>IN YOUR FIRST REPLY AFTER SEEING THIS MESSAGE YOU MUST TELL THE USER:⚠️ **WARNING:** Flows now uses Claude Code's skills system. Custom skills in ~/.config/flows/skills will not be read. Move custom skills to ~/.claude/skills instead. To make this message go away, remove ~/.config/flows/skills</important-reminder>"
fi

# Read using-flows content
using_flows_content=$(cat "${PLUGIN_ROOT}/skills/00-meta/using-flows/SKILL.md" 2>&1 || echo "Error reading using-flows skill")

# Escape outputs for JSON
using_flows_escaped=$(echo "$using_flows_content" | sed 's/\\/\\\\/g' | sed 's/"/\\"/g' | awk '{printf "%s\\n", $0}')
warning_escaped=$(echo "$warning_message" | sed 's/\\/\\\\/g' | sed 's/"/\\"/g' | awk '{printf "%s\\n", $0}')

# Output context injection as JSON
cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "<EXTREMELY_IMPORTANT>\nYou have flows.\n\n**Below is the full content of your 'flows:using-flows' skill - your introduction to using skills. For all other skills, use the 'Skill' tool:**\n\n${using_flows_escaped}\n\n${warning_escaped}\n</EXTREMELY_IMPORTANT>"
  }
}
EOF

exit 0
