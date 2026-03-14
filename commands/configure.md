---
description: Configure your /dev:* workflow preferences and personal style
argument-hint: [reconfigure]
---

# Setup Mode

When this command is invoked:

## Check for Existing Configuration

1. Read `${CLAUDE_PLUGIN_ROOT}/config.local.json`
2. If the file EXISTS:
   - Display current configuration summary
   - If argument is "reconfigure", proceed to Configuration Prompts
   - Otherwise, output:
     ```
     Configuration already exists.

     Run /dev:configure reconfigure to update your settings.
     ```
   - STOP execution

## Configuration Prompts

### Welcome Message

If this is a first-time setup, open with:

```
Welcome to slash-dev — phased development workflow for Claude Code.

Setup can handle as much or as little as you'd like. The minimum I need
is a directory for your project docs, but this is also where you'd come
to configure your preferences — commit conventions, ticket system, PR
workflow, implementation style, and more.

Let's start with the essentials.
```

If this is a reconfiguration, open with:

```
Reconfiguring slash-dev. I'll walk through your current settings —
skip anything you want to keep, update what you'd like to change.
```

### Required: Projects Directory

Ask: "Where should project documentation be stored?"

- Default: `~/Developer/dev-projects`
- This is where all `/dev:*` project folders will live
- Validate the path is writable (create it if it doesn't exist)

### Required: Code Directories

Ask: "Where are your code repositories? (comma-separated for multiple)"

- Default: `~/Developer`
- These help Claude find relevant codebases during discovery
- Optional — can be left empty and configured later

### About You

Right after the essentials, transition into learning about the user:

```
Great — that's all I need to find things. Now, tell me a little about
yourself so I can tailor how we work together. This helps me calibrate
the depth of explanations, the conventions I follow, and how I
collaborate with you.

Feel free to share as much or as little as you'd like — or skip this
entirely.
```

Then ask conversationally (not as a rigid form):
- What's your role? (engineer, lead, architect, student, etc.)
- What team or organization are you part of?
- What kind of work do you primarily do? (backend, frontend, infra, full-stack, etc.)
- How experienced are you with the codebases you'll be working in?
- Anything else that would help me work with you better?

Let the user respond naturally — they might give one sentence or a paragraph. Extract what's relevant and store in config as `user`.

If they want to skip: "No problem. You can always come back to this with `/dev:configure reconfigure`."

### Invitation to Configure Workflow Preferences

After the about-you section (or skip), offer the remaining preferences:

```
That's the essentials covered. I can also learn about your workflow
preferences so implementation mode fits your style. Want to set up
any of these now?

  - Commit conventions (message format, branch naming)
  - Ticket system (Jira, GitHub Issues, etc.)
  - PR workflow (merge strategy, review preferences)
  - Implementation style (testing approach, code review priorities)

You can configure any of these later with /dev:configure reconfigure.
```

Use `AskUserQuestion` to let them pick which categories to configure, with a "Skip for now" option.

### Optional: Commit Conventions

If selected:
- Commit message format (conventional commits is the default — do they use it?)
- Branch naming pattern (e.g., `[TICKET-ID]-short-description`)
- Any commit rules (no co-author tags, specific scopes, etc.)

Store in config as `preferences.commits`.

### Optional: Ticket System

If selected:
- Which system? (Jira, GitHub Issues, Linear, none)
- Default project/board
- Any naming or formatting conventions

Store in config as `preferences.tickets`.

### Optional: PR Workflow

If selected:
- Merge strategy (squash and merge, merge commit, rebase)
- PR title format
- Draft PR preference (early draft or wait until ready?)
- Review requirements

Store in config as `preferences.pr`.

### Optional: Implementation Style

If selected:
- Testing approach (TDD, test-adjacent, test-after?)
- Code review priorities (what matters most to them?)
- Quality gates they enforce

Store in config as `preferences.implementation`.

## Write Configuration

Create `${CLAUDE_PLUGIN_ROOT}/config.local.json`:

```json
{
  "version": "3.0",
  "projects_dir": "${absolute path}",
  "code_dirs": ["${paths}"],
  "user": {
    "role": "${if provided}",
    "team": "${if provided}"
  },
  "preferences": {
    "commits": {
      "format": "conventional",
      "branch_pattern": "[TICKET-ID]-short-description",
      "rules": []
    },
    "tickets": {
      "system": "jira",
      "default_project": "${if provided}"
    },
    "pr": {
      "merge_strategy": "squash",
      "draft_early": true,
      "title_format": "conventional"
    },
    "implementation": {
      "testing": "test-adjacent",
      "review_priorities": []
    }
  },
  "created_at": "${ISO 8601}",
  "updated_at": "${ISO 8601}"
}
```

Only include sections the user actually configured. Don't write empty placeholder objects for skipped categories.

**Path handling**:
- Expand `~` to the user's home directory
- Convert relative paths to absolute
- Validate all paths are accessible

## Generate Reference Files

After writing config, update the reference files to reflect the user's preferences:

- `${CLAUDE_PLUGIN_ROOT}/skills/dev-workflow/references/implementation-standards.md` — adjust commit format, branch naming, merge strategy, testing approach, quality gates based on what was configured
- `${CLAUDE_PLUGIN_ROOT}/skills/dev-workflow/references/ticket-creation.md` — adjust ticket system, project, conventions based on what was configured

Only modify sections relevant to what the user configured. Leave defaults in place for anything they skipped.

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
  Preferences: ${summary of what was configured vs defaults}
  Configuration: ${CLAUDE_PLUGIN_ROOT}/config.local.json

Next steps:
  /dev:explain          — learn the workflow
  /dev:discovery <name> — start a new project
  /dev:configure reconfigure — update preferences anytime
```

## Notes

- Configuration is stored inside the plugin directory and is gitignored
- Each user creates their own config — no shared paths
- Preferences populate the reference files so implementation commands use the user's style
- Run `/dev:configure reconfigure` anytime to add or change preferences
- Skipped preferences use sensible defaults — the workflow works without them
