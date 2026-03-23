# Ticket Creation Reference

Tickets are the primary deliverable of `/dev:plan`. Each ticket is a self-contained work unit structured for handoff to an autonomous coding agent (OMOA/OpenCode) with zero ambiguity.

The solution map (`02-plan.md`) is the narrative. Tickets are the work.

## When to Create Tickets

- After the solution map is solid and the user confirms they're ready
- Each ticket = one coherent unit of work = one PR
- The plan's sequencing should map to ticket dependencies

## Ticket Structure

Every ticket must include these sections. An autonomous agent receiving this ticket should be able to start work without asking questions.

### Title
Action-oriented, specific to what the ticket delivers. Check `config.local.json` for `preferences.tickets.title_conventions` — follow the team's naming patterns for epics vs stories.

### Description

Use this template for the Jira description:

```
## Context
[1-2 sentences: what project this is part of, where this ticket fits in the sequence]

Reference: [link to solution map or confluence page if applicable]

## Scope
**Repository**: [repo name]
**Path**: [absolute path to repo on disk]
**Files/components affected**:
- `path/to/file.ts` — [what changes and why]
- `path/to/other.ts` — [what changes and why]
- `path/to/file.test.ts` — [test additions/changes]

## Acceptance Criteria
- [ ] [Specific, testable criterion]
- [ ] [Another criterion]
- [ ] Tests pass (unit + integration as applicable)
- [ ] No regressions in [related area]

## Constraints
- **Tech stack**: [relevant frameworks, languages, versions]
- **Patterns to follow**: [existing patterns in the codebase to match]
- **Things to avoid**: [anti-patterns, approaches explicitly rejected]
- **Performance**: [any perf requirements or budgets]

## Context Pointers
Documents the agent should read before starting:
- [path to discovery doc or relevant section]
- [path to architecture doc or relevant section]
- [path to existing code that demonstrates the pattern]
- [link to relevant API docs or specs]

## Dependencies
- **Blocked by**: [ticket IDs that must complete first, if any]
- **Blocks**: [ticket IDs that depend on this, if any]
```

## Team-Specific Conventions

Check `${CLAUDE_PLUGIN_ROOT}/config.local.json` for a `preferences.tickets` section. If it contains team-specific fields (e.g., `jira_project`, `issue_type`, `default_fields`), apply those when creating tickets. This allows team conventions to stay out of version control.

## Creating Tickets via Atlassian MCP

Use the Atlassian MCP server:
1. Create the ticket in the appropriate Jira project
2. Set story points if the team uses them
3. Link dependent tickets using `createIssueLink` (blocks/is-blocked-by)
4. Add to current sprint if applicable

### After Creation
1. Update the plan's Tickets table with the ticket ID and title
2. Confirm with the user: "[N] tickets created in [PROJECT]. Review them?"

## If Atlassian MCP Is Not Available

Write tickets as markdown in `${projectPath}/tickets/` — one file per ticket using the same structure. The user can transfer them to Jira manually.

## Notes

- Ticket conventions vary by team — the user's preferences from `/dev:configure` take priority
- The scope section is critical: an autonomous agent uses it to know exactly which files to touch
- Context pointers prevent the agent from needing to rediscover what slash-dev already found
- Keep tickets focused: if a work unit touches more than ~5 files, consider splitting it
