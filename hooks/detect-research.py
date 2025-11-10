#!/usr/bin/env python3
import json
import sys

try:
    input_data = json.load(sys.stdin)
except json.JSONDecodeError:
    sys.exit(1)

prompt = input_data.get("prompt", "").lower()

# Detect research-related keywords
research_keywords = [
    "research online",
    "web search",
    "search the web",
    "look up online",
    "find information about",
    "search for information",
    "look online",
    "find online",
    "@agent-web-search-researcher",
    "@agent-web-researcher"
]

if any(keyword in prompt for keyword in research_keywords):
    output = {
        "hookSpecificOutput": {
            "hookEventName": "UserPromptSubmit",
            "additionalContext": (
                "The user has expressed a desire to invoke the agent 'web-researcher'. "
                "Please invoke the agent appropriately using the Task tool with "
                "subagent_type=web-researcher, passing in the required context to it."
            )
        }
    }
    print(json.dumps(output))

sys.exit(0)
