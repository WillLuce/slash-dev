#!/bin/bash
# Helper script for listing available projects
# Used by the project picker in the dev-workflow skill

CONFIG_FILE="${CLAUDE_PLUGIN_ROOT}/config.local.json"

if [ ! -f "$CONFIG_FILE" ]; then
  echo "Configuration not found. Run /dev:configure first."
  exit 1
fi

# Extract projects_dir from config (basic JSON parsing)
PROJECTS_DIR=$(grep -o '"projects_dir"[[:space:]]*:[[:space:]]*"[^"]*"' "$CONFIG_FILE" | sed 's/.*: *"\(.*\)"/\1/')

if [ ! -d "$PROJECTS_DIR" ]; then
  echo "Projects directory not found: $PROJECTS_DIR"
  exit 1
fi

# List projects with their metadata
for project_dir in "$PROJECTS_DIR"/*/; do
  if [ -f "${project_dir}project.json" ]; then
    echo "${project_dir}project.json"
  fi
done
