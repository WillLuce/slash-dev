---
description: Work on the slash-dev plugin itself
---

# Meta Mode

When this command is invoked:

## Context

You are now working on the **slash-dev plugin itself**. The working codebase is `${CLAUDE_PLUGIN_ROOT}`.

## Plugin Structure Awareness

Read the plugin structure to understand what you're working with:

```
${CLAUDE_PLUGIN_ROOT}/
├── .claude-plugin/plugin.json    # Manifest (name, version, description)
├── .releaserc                    # semantic-release config
├── commands/                     # User-invoked /dev:* commands
│   ├── dev-configure.md
│   ├── dev-discovery.md
│   ├── dev-architecture.md
│   ├── dev-plan.md
│   ├── dev-implement.md
│   ├── dev-meeting.md
│   ├── dev-explain.md
│   ├── dev-update.md
│   └── dev-meta.md (this file)
├── skills/
│   └── dev-workflow/
│       ├── SKILL.md              # Shared bootstrap logic
│       └── references/           # Lazy-loaded reference docs
│           ├── implementation-standards.md
│           ├── c4-diagramming.md
│           ├── ticket-creation.md
│           └── mcp-guide.md
├── agents/
│   ├── code-explorer.md          # Codebase analysis agent
│   └── code-reviewer.md          # Code review agent
└── scripts/
    └── list-projects.sh          # Helper for project picker
```

## Component Patterns

When modifying the plugin, follow these patterns:

**Commands** (`commands/*.md`):
- Frontmatter: `description`, optional `argument-hint`
- Bootstrap via `${CLAUDE_PLUGIN_ROOT}/skills/dev-workflow/SKILL.md`
- Define persona, focus areas, boundaries
- Reference other plugin files via `${CLAUDE_PLUGIN_ROOT}/...`

**Skill** (`skills/dev-workflow/SKILL.md`):
- Shared logic all commands depend on
- Config loading, project resolution, context gathering
- Changes here affect ALL commands

**References** (`skills/dev-workflow/references/*.md`):
- Lazy-loaded knowledge modules
- Referenced by commands/skill when needed
- Don't auto-load — commands pull them in explicitly

**Agents** (`agents/*.md`):
- Frontmatter: `name`, `description`, `tools`, `model`
- Run on Sonnet for speed/cost
- Autonomous — they do their job and return results
- Keep tool lists minimal for the task

## Versioning

This plugin uses semantic versioning driven by conventional commits:
- `feat:` — minor version bump
- `fix:` — patch version bump
- `BREAKING CHANGE:` — major version bump

The `.releaserc` configures semantic-release for GitHub releases.

## Mode Instructions

You're now in META MODE. This is freeform — no three-phase pattern required.

**What you can do:**
- Read and modify any plugin file
- Add new commands, agents, or references
- Update the skill logic
- Fix bugs in existing commands
- Improve documentation
- Update the manifest version

**Guidelines:**
- Follow conventional commits for all changes
- Test changes by thinking through how they'd execute
- Keep the plugin self-contained (no external dependencies beyond Claude Code)
- Reference files via `${CLAUDE_PLUGIN_ROOT}` — never hardcode user paths
- Consider how changes affect ALL commands (especially skill changes)

What would you like to work on?
