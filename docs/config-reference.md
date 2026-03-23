# config.local.json Reference

This file lives at `${CLAUDE_PLUGIN_ROOT}/config.local.json`. It is created by `/dev:configure` and is gitignored — each developer has their own.

## Schema

```json
{
  "version": "3.0",
  "projects_dir": "/absolute/path/to/projects",
  "code_dirs": ["/absolute/path/to/code"],
  "user": { ... },
  "preferences": {
    "tickets": { ... },
    "commits": { ... },
    "pr": { ... },
    "implementation": { ... }
  },
  "created_at": "ISO 8601",
  "updated_at": "ISO 8601"
}
```

## Top-Level Fields

| Field | Required | Description |
|-------|----------|-------------|
| `version` | Yes | Config schema version. Currently `"3.0"`. |
| `projects_dir` | Yes | Absolute path to the directory where project docs are stored. Each project gets a subdirectory here. |
| `code_dirs` | No | Array of absolute paths where code repositories live. Used by discovery to locate repos. |
| `created_at` | Yes | ISO 8601 timestamp of when the config was created. |
| `updated_at` | Yes | ISO 8601 timestamp of last config update. |

## `user`

Information about the developer. Used to tailor collaboration style.

| Field | Description |
|-------|-------------|
| `role` | Job title or role (e.g., "Senior Software Engineer II") |
| `team` | Team name (e.g., "Customer Solutions & Delivery (CSD)") |
| `organization` | Organization name |
| `description` | Brief description of what the developer does |

## `preferences.tickets`

Controls how `/dev:plan` creates Jira tickets. Read by `ticket-creation.md`.

| Field | Description | Example |
|-------|-------------|---------|
| `system` | Ticket system. Currently only `"jira"` is supported. | `"jira"` |
| `jira_project` | Jira project key. Tickets are created in this project. | `"CSD"` |
| `jira_board` | Jira board ID. Used for sprint assignment. | `1854` |
| `default_issue_type` | Default issue type for new tickets. | `"Story"` |
| `team_field` | Jira custom field ID for the team field, if your org uses one. | `"customfield_10001"` |
| `confluence_space` | Confluence space key for team documentation. | `"CSDC"` |
| `hierarchy` | Plain-language description of the ticket hierarchy your team uses. | `"Epics contain Stories. No sub-tasks."` |
| `title_conventions` | Object mapping issue types to title patterns. | See below. |

### `title_conventions`

Describes how ticket titles should be formatted, keyed by issue type (lowercase).

```json
{
  "epics": "[Partner/Feature] Short description",
  "stories": "Descriptive deliverable"
}
```

These patterns are referenced by `ticket-creation.md` when creating tickets. They should reflect your team's actual conventions — check existing tickets in your Jira project for examples.

## `preferences.commits`

Controls commit message format and branch naming during `/dev:implement`.

| Field | Description | Example |
|-------|-------------|---------|
| `format` | Commit message format. | `"conventional"` |
| `branch_pattern` | Branch naming pattern. `[TICKET-ID]` is replaced with the Jira ticket key. | `"[TICKET-ID]-short-description"` |
| `rules` | Array of additional commit rules (e.g., "no co-author tags"). | `[]` |

## `preferences.pr`

Controls PR creation during `/dev:implement`.

| Field | Description | Example |
|-------|-------------|---------|
| `merge_strategy` | How PRs are merged. | `"squash"` |
| `draft_early` | Whether to create draft PRs early. | `true` |
| `title_format` | PR title format convention. | `"conventional"` |

## `preferences.implementation`

Controls implementation workflow behavior.

| Field | Description | Example |
|-------|-------------|---------|
| `testing` | Testing approach. | `"test-adjacent"` |
| `review_priorities` | Array of things the reviewer should focus on. | `[]` |

## What reads what

| Consumer | Config fields used |
|----------|-------------------|
| **SKILL.md** (bootstrap) | `projects_dir`, `code_dirs` |
| **ticket-creation.md** | `preferences.tickets.*` |
| **implementation-standards.md** | `preferences.commits`, `preferences.pr`, `preferences.implementation` |
| **configure.md** | Writes all fields |
| **All commands** | `user` (for collaboration style) |

## Notes

- Only include sections the developer actually configured. Don't write empty placeholder objects for skipped categories.
- Paths must be absolute. `/dev:configure` expands `~` and converts relative paths.
- This file is never committed. Team-specific conventions (like Jira project key and title patterns) stay local to each developer.
