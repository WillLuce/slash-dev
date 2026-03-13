---
description: Configure your /dev-* workflow preferences
argument-hint: [reconfigure]
---

# Setup Mode

When this command is invoked:

## Check for Existing Configuration

1. Read `${CLAUDE_PLUGIN_ROOT}/config.local.json`
2. If the file EXISTS:
   - Display current configuration
   - If argument is "reconfigure", proceed to Configuration Prompts
   - Otherwise, output:
     ```
     Configuration already exists.

     Run /dev-setup reconfigure to update your settings.
     ```
   - STOP execution

## Configuration Prompts

Use `AskUserQuestion` to gather preferences:

### 1. Projects Directory

Ask: "Where should project documentation be stored?"

- Default: `~/Developer/dev-projects`
- This is where all `/dev-*` project folders will live
- Validate the path is writable (create it if it doesn't exist)

### 2. Code Directories

Ask: "Where are your code repositories? (comma-separated for multiple)"

- Default: `~/Developer`
- These help Claude find relevant codebases during discovery
- Optional — can be left empty and configured later

## Write Configuration

Create `${CLAUDE_PLUGIN_ROOT}/config.local.json`:

```json
{
  "version": "3.0",
  "projects_dir": "${user-provided absolute path}",
  "code_dirs": ["${user-provided paths}"],
  "created_at": "${current ISO 8601 timestamp}",
  "updated_at": "${current ISO 8601 timestamp}"
}
```

**Path handling**:
- Expand `~` to the user's home directory
- Convert relative paths to absolute
- Validate all paths are accessible

## Create Projects Directory

```bash
mkdir -p ${projects_dir}
```

## MCP Server Detection

After configuration, scan for installed MCP servers and report:

1. Check for commonly useful MCP servers:
   - **Context7** — library documentation lookups (replaces web search for docs)
   - **GitHub** — repository management, PR/issue workflows
   - **Atlassian** — Confluence/Jira integration for ticket creation and product context
   - **Slack** — team communication

2. Output what's available:
   ```
   Detected MCP servers:
     [check] Context7 — library documentation
     [check] GitHub — repository and PR management
     [x] Atlassian — not detected (optional: Jira ticket creation)
   ```

3. For any servers not detected, briefly mention what they enable in the workflow.

## Completion Output

```
Setup complete!

  Projects directory: ${projects_dir}
  Code directories: ${code_dirs}
  Configuration: ${CLAUDE_PLUGIN_ROOT}/config.local.json

Next steps:
  /dev-explain        — learn the workflow
  /dev-discovery <name> — start a new project
```

## Notes

- Configuration is stored inside the plugin directory and is gitignored
- Each user creates their own config via `/dev-setup` — no shared paths
- Config file uses `${CLAUDE_PLUGIN_ROOT}` for portability
- Run `/dev-setup reconfigure` to change settings at any time
