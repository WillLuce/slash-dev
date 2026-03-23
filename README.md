# slash-dev

Phased development workflow for Claude Code. Structured SDLC phases with persistent project memory, collaborative personas, and ticket-driven execution.

## What It Does

slash-dev manages complex engineering projects through distinct phases:

- **Discovery** — understand the problem, find relevant code, explore solution directions
- **Architecture** — design the solution with component definitions, data flow, and C4 diagrams
- **Planning** — sequence the work, make execution decisions, create Jira tickets
- **Implementation** — pick up a ticket and build it with discuss/plan/execute and built-in code review
- **Meetings** — capture notes with full project context awareness

Each phase produces persistent markdown docs that serve as project memory across sessions. Planning produces Jira tickets as its primary output — self-contained work units that any developer (or autonomous agent) can pick up and execute.

## Installation

### For Humans

1. Add the plugin to your Claude Code settings (`~/.claude/settings.json`):
   ```json
   {
     "enabledPlugins": {
       "dev@slash-dev": true
     },
     "extraKnownMarketplaces": {
       "slash-dev": {
         "source": {
           "source": "github",
           "repo": "WillLuce/slash-dev"
         }
       }
     }
   }
   ```

2. Restart Claude Code, then run setup:
   ```
   /dev:configure
   ```
   This configures where your project docs and code repos live, learns about your role and team, and optionally sets up commit conventions, ticket system preferences, and PR workflow.

3. Learn the workflow:
   ```
   /dev:explain
   ```

### For LLM Agents

Fetch the installation guide and follow it:

```
curl -s https://raw.githubusercontent.com/WillLuce/slash-dev/main/docs/agent-install.md
```

## Commands

| Command | Purpose |
|---------|---------|
| `/dev:configure` | Configure workspace paths, preferences, and detect MCP servers |
| `/dev:discovery <name>` | Start or resume project discovery |
| `/dev:architecture <name>` | Design the solution architecture |
| `/dev:plan <name>` | Sequence work and create Jira tickets |
| `/dev:implement <name>` | Pick up a ticket and build it with built-in review |
| `/dev:meeting <name>` | Capture meeting notes with project context |
| `/dev:explain [command]` | Learn the workflow or get help on a specific command |
| `/dev:update` | Pull latest plugin version |
| `/dev:meta` | Work on the slash-dev plugin itself |

All commands support a project picker — omit the project name to choose from recent projects.

## How It Works

### Maps and Tickets

slash-dev produces two kinds of artifacts:

- **Maps** (markdown docs) — capture understanding, design, and rationale. These live in the project directory and persist across sessions.
- **Tickets** (Jira stories) — define discrete, executable work units. These live in Jira and are queried on demand via Atlassian MCP.

The **solution map** (`02-plan.md`) connects the two. It describes the sequencing logic — what order to build things and why — and maintains an index of ticket IDs. It does not duplicate ticket detail.

### Ticket Structure

Tickets created by `/dev:plan` are structured for zero-ambiguity handoff:

- **Scope** — files and components affected
- **Acceptance criteria** — what "done" looks like
- **Constraints** — tech stack, patterns to follow, things to avoid
- **Context pointers** — which docs to read before starting
- **Dependencies** — what must be done first

This structure means any developer picking up a ticket — whether a teammate, an autonomous coding agent, or future-you — can start work without asking questions.

## Project Structure

```
<project-name>/
├── project.json          # Metadata (name, description, last_activity)
├── 00-discovery.md       # Problem definition and exploration
├── 01-architecture.md    # Solution design and component architecture
├── 02-plan.md            # Solution map (sequencing, decisions, ticket index)
├── CHANGELOG.md          # Back-propagation log
├── meetings/             # Meeting notes by date
└── context-excluded/     # Scratch files (never auto-loaded)
```

Tickets live in Jira, not in the project directory.

## Philosophy

- **Phased over monolithic** — distinct phases prevent mixing exploration with execution
- **Collaborative over autonomous** — Claude is a thought partner, not an autopilot
- **Persistent over ephemeral** — everything is saved to markdown, survives sessions
- **Maps and tickets** — docs capture rationale, tickets capture work units
- **Ticket-ready output** — planning produces work that anyone can pick up and execute

## MCP Server Support

slash-dev works best with these MCP servers (all optional):

- **Context7** — library documentation lookups
- **GitHub** — repository and PR management
- **Atlassian** — Jira ticket creation and Confluence integration (required for ticket workflow)

Run `/dev:configure` to see which servers are detected.

## Configuration

`/dev:configure` stores settings in `config.local.json` inside the plugin directory (gitignored). This includes:

- **Projects directory** — where project docs live
- **Code directories** — where your repos are, for discovery
- **User profile** — role, team, org (tailors collaboration style)
- **Ticket preferences** — Jira project, issue types, title conventions (team-specific, not checked in)
- **Commit/PR conventions** — message format, branch naming, merge strategy

See [`docs/config-reference.md`](docs/config-reference.md) for the full schema, field descriptions, and which parts of the system read which config values.

## Contributing

This plugin uses conventional commits and semantic-release:
- `feat:` — new features (minor version bump)
- `fix:` — bug fixes (patch version bump)
- `BREAKING CHANGE:` — breaking changes (major version bump)

Use `/dev:meta` to work on the plugin with full context awareness.

## License

MIT
