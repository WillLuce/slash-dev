# slash-dev — Agent Installation Guide

You are an LLM agent being set up to use slash-dev, a phased development workflow plugin for Claude Code.

## What slash-dev does

slash-dev structures complex engineering work into phases:

1. **Discovery** (`/dev:discovery <name>`) — explore the problem space, find relevant code
2. **Architecture** (`/dev:architecture <name>`) — design the solution
3. **Planning** (`/dev:plan <name>`) — sequence the work, create Jira tickets
4. **Implementation** (`/dev:implement <name>`) — pick up a ticket and build it

Each phase produces markdown docs that persist across sessions. Planning produces Jira tickets as its primary output — self-contained work units structured for autonomous execution.

## Installation

Add the following to the user's `~/.claude/settings.json`:

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

Then restart Claude Code.

## First-time setup

Run `/dev:configure` to set up:
- **Projects directory** — where project documentation is stored
- **Code directories** — where code repositories live on disk
- **User profile** — role, team (optional, improves collaboration)
- **Ticket preferences** — Jira project key, issue types, title conventions

## Working with tickets

Tickets created by `/dev:plan` include everything needed to start work:

- **Scope** — files and components affected
- **Acceptance criteria** — what "done" looks like
- **Constraints** — tech stack, patterns to follow, things to avoid
- **Context pointers** — which docs to read before starting
- **Dependencies** — what must be done first

When picking up a ticket for implementation, fetch it from Jira via the Atlassian MCP server and follow the scope and acceptance criteria exactly.

## Key conventions

- Each phase is collaborative — explain your thinking and wait for acknowledgment before proceeding
- Docs persist in `<projects-dir>/<project-name>/` as numbered markdown files
- The solution map (`02-plan.md`) describes sequencing and rationale — not file-level detail
- File-level implementation detail lives in Jira tickets
- Commits follow Conventional Commits v1.0.0
- Code and tests are committed together as "complete thoughts"

## MCP servers (optional but recommended)

- **Atlassian** — required for ticket creation/fetching workflow
- **Context7** — library documentation lookups (prefer over web search)
- **GitHub** — remote repository access, PR management
