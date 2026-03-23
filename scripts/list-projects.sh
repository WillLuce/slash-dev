#!/bin/bash
# Lists recent projects for the dev-workflow project picker.
# Excludes "slash-dev", filters to last 3 months, returns up to 3 sorted by last_activity desc.
# Output: one line per project: "name — description"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLUGIN_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CONFIG_FILE="${PLUGIN_ROOT}/config.local.json"

if [ ! -f "$CONFIG_FILE" ]; then
  echo "Configuration not found. Run /dev:configure first."
  exit 1
fi

PROJECTS_DIR=$(grep -o '"projects_dir"[[:space:]]*:[[:space:]]*"[^"]*"' "$CONFIG_FILE" | sed 's/.*: *"\(.*\)"/\1/')

if [ ! -d "$PROJECTS_DIR" ]; then
  echo "Projects directory not found: $PROJECTS_DIR"
  exit 1
fi

python3 -c "
import json, os, sys
from datetime import datetime, timedelta

cutoff = (datetime.now() - timedelta(days=90)).strftime('%Y-%m-%d')
projects_dir = sys.argv[1]
projects = []

for name in sorted(os.listdir(projects_dir)):
    pf = os.path.join(projects_dir, name, 'project.json')
    if not os.path.isfile(pf) or name == 'slash-dev':
        continue
    with open(pf) as f:
        d = json.load(f)
    la = d.get('last_activity', d.get('created', '2000-01-01'))
    if la >= cutoff:
        projects.append((la, d.get('name', name), d.get('description', '')))

projects.sort(reverse=True)
for la, n, desc in projects[:3]:
    print(f'{n} — {desc}')
" "$PROJECTS_DIR"
