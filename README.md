# slash-dev

Phased development workflow for Claude Code. Structured SDLC phases with persistent project memory, collaborative personas, and built-in code review.

## What It Does

slash-dev manages complex engineering projects through distinct phases:

- **Discovery** — understand the problem, find relevant code, explore solution directions
- **Architecture** — design the solution with C4 diagrams and component definitions
- **Planning** — break architecture into implementable work, create tickets, specify repo changes
- **Implementation** — execute the plan with discuss/plan/execute pattern and built-in code review
- **Meetings** — capture notes with full project context awareness

Each phase produces persistent markdown docs that serve as project memory across sessions.

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/williamluce/slash-dev.git
   ```

2. Install as a Claude Code plugin (add to your Claude Code plugin configuration)

3. Run setup:
   ```
   /dev-setup
   ```
   This configures where your project docs and code repos live. Configuration is stored locally and gitignored.

## Commands

| Command | Purpose |
|---------|---------|
| `/dev-setup` | Configure workspace paths and detect MCP servers |
| `/dev-discovery <name>` | Start or resume project discovery |
| `/dev-architecture <name>` | Design the solution architecture |
| `/dev-plan <name>` | Plan implementation and create tickets |
| `/dev-implement <name>` | Execute the plan with built-in review |
| `/dev-meeting <name>` | Capture meeting notes with project context |
| `/dev-explain [command]` | Learn the workflow or get help on a specific command |
| `/dev-update` | Pull latest plugin version |
| `/dev-meta` | Work on the slash-dev plugin itself |

All commands support a project picker — omit the project name to choose from existing projects.

## Project Structure

Each project creates this structure in your configured projects directory:

```
<project-name>/
├── project.json          # Metadata (name, status, tags)
├── 00-discovery.md       # Problem definition and exploration
├── 01-architecture.md    # Solution design
├── 02-plan.md            # Implementation plan
├── CHANGELOG.md          # Back-propagation log
├── meetings/             # Meeting notes by date
└── context-excluded/     # Scratch files (never auto-loaded)
```

## Philosophy

- **Phased over monolithic** — distinct phases prevent mixing exploration with execution
- **Collaborative over autonomous** — Claude is a thought partner, not an autopilot
- **Persistent over ephemeral** — everything is saved to markdown, survives sessions
- **Resumable over fresh start** — pick up where you left off in any phase

## Implementation Standards

The plugin ships with default implementation standards (commit strategy, three-phase pattern, quality gates) that can be customized in `skills/dev-workflow/references/implementation-standards.md`.

## MCP Server Support

slash-dev works best with these MCP servers (all optional):
- **Context7** — library documentation lookups
- **GitHub** — repository and PR management
- **Atlassian** — Jira ticket creation and Confluence integration

Run `/dev-setup` to see which servers are detected.

## Contributing

This plugin uses conventional commits and semantic-release:
- `feat:` — new features (minor version bump)
- `fix:` — bug fixes (patch version bump)
- `BREAKING CHANGE:` — breaking changes (major version bump)

Use `/dev-meta` to work on the plugin with full context awareness.

## License

MIT
