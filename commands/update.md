---
description: Check for updates and see what's new in slash-dev
---

# Update Mode

When this command is invoked:

## Check Current Version

1. Read `${CLAUDE_PLUGIN_ROOT}/.claude-plugin/plugin.json` and extract the current `version`
2. Store the current commit hash: `git -C ${CLAUDE_PLUGIN_ROOT} rev-parse HEAD`

## Check for Updates

1. Fetch latest from remote: `git -C ${CLAUDE_PLUGIN_ROOT} fetch origin main`
2. Compare local and remote: `git -C ${CLAUDE_PLUGIN_ROOT} rev-list HEAD..origin/main --count`
3. If count is 0:
   - Output:
     ```
     slash-dev v${version} — you're up to date.
     ```
   - Then show the latest release notes (see "Show What's New" below)
   - STOP execution

## Show What's Coming

If there are updates available, show what's in them BEFORE pulling:

1. Get the commit log: `git -C ${CLAUDE_PLUGIN_ROOT} log --oneline HEAD..origin/main`
2. Get the latest release info from GitHub: `gh release view --repo WillLuce/slash-dev`
3. Present a summary:
   ```
   Updates available for slash-dev (current: v${current_version})

   Latest release: v${latest_tag}
   ${release notes body}

   Commits since your version:
     ${commit log}
   ```
4. Ask: "Want to update?"

## Apply Update

If the user confirms:

1. Check for local modifications: `git -C ${CLAUDE_PLUGIN_ROOT} status --porcelain`
2. If there are local changes:
   - Warn: "You have local changes in the plugin directory. These may conflict with the update."
   - List the changed files
   - Ask how to proceed (stash, abort, force)
3. Pull: `git -C ${CLAUDE_PLUGIN_ROOT} pull origin main`
4. Read the new version from `plugin.json`

## Post-Update Report

After pulling, categorize what changed:

1. Diff the old and new commits: `git -C ${CLAUDE_PLUGIN_ROOT} diff --name-status ${old_hash}..HEAD`
2. Group changes:
   - **New commands**: added files in `commands/`
   - **Updated commands**: modified files in `commands/`
   - **New/updated agents**: changes in `agents/`
   - **Updated skill logic**: changes to `skills/dev-workflow/SKILL.md`
   - **Updated references**: changes in `skills/dev-workflow/references/`
3. Output:
   ```
   Updated to v${new_version}

   What changed:
     ${categorized summary}
   ```

### Restart Warning

If any of the following changed, warn the user:
- `hooks/hooks.json` — requires Claude Code restart
- Agent definitions — take effect on next agent spawn
- `skills/dev-workflow/SKILL.md` — takes effect on next command invocation
- Recommend `/reload-plugins` to pick up command and reference changes immediately

## Show What's New

When the user is already up to date, or after an update completes, offer to show recent release history:

1. Get latest release: `gh release view --repo WillLuce/slash-dev`
2. Display the release notes in a readable format
3. If the user wants more history: `gh release list --repo WillLuce/slash-dev --limit 5`
