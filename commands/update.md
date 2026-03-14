---
description: Update the slash-dev plugin to the latest version
---

# Update Mode

When this command is invoked:

## Pre-Update Checks

1. Read `${CLAUDE_PLUGIN_ROOT}/config.local.json` to confirm setup exists
2. If config does NOT exist:
   - Output: "No configuration found. Run /dev:configure first."
   - STOP execution
3. Store a copy of current config values in memory for comparison

## Update Plugin

1. Run `git -C ${CLAUDE_PLUGIN_ROOT} pull origin main`
2. If pull fails:
   - Check for local modifications: `git -C ${CLAUDE_PLUGIN_ROOT} status`
   - Report the issue and suggest resolution
   - STOP execution

## Post-Update Checks

### Config Schema Migration

1. Read `${CLAUDE_PLUGIN_ROOT}/config.local.json` again
2. Compare the `version` field against what the new plugin expects
3. If the schema has changed:
   - Report what changed
   - Migrate config automatically if possible
   - Ask the user to confirm any destructive changes

### Report Changes

1. Show what changed: `git -C ${CLAUDE_PLUGIN_ROOT} log --oneline HEAD@{1}..HEAD`
2. Categorize changes:
   - **New commands**: any new files in `commands/`
   - **Updated commands**: modified files in `commands/`
   - **New agents**: any new files in `agents/`
   - **Updated references**: modified files in `skills/dev-workflow/references/`

### Restart Warning

If any of the following changed, warn the user:
- `hooks/hooks.json` — hooks require a Claude Code restart
- Agent definitions — agent changes take effect on next spawn
- `skills/dev-workflow/SKILL.md` — skill changes take effect on next command invocation

## Completion Output

```
Updated slash-dev to v${version}.

Changes:
  ${summary of changes}

${restart warning if applicable}
```
