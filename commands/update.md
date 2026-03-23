---
description: Check for updates and see what's new in slash-dev
---

# Update Mode

When this command is invoked:

## Check Current Version

1. Read `${CLAUDE_PLUGIN_ROOT}/.claude-plugin/plugin.json` and extract the current `version`

## Check for Updates

1. Get the latest release from GitHub: `gh release view --repo WillLuce/slash-dev --json tagName,body`
2. Compare the latest release tag against the current version
3. If they match:
   - Output:
     ```
     slash-dev v${version} — you're up to date.
     ```
   - Show the release notes for the current version
   - STOP execution

## Show What's Available

If there's a newer release:

1. Present a summary:
   ```
   Update available for slash-dev

   Current: v${current_version}
   Latest:  v${latest_version}

   ${release notes body}
   ```

2. Tell the user how to update:
   ```
   To update, run:
     /plugin update dev@slash-dev

   Then reload:
     /reload-plugins
   ```

## Show Recent History

If the user asks for more history: `gh release list --repo WillLuce/slash-dev --limit 5`
