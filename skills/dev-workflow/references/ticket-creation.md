# Ticket Creation Reference

This reference guides Jira ticket creation during `/dev:plan`. Conventions here are a starting point — they will evolve as the workflow is used.

## When to Create Tickets

- After the implementation plan is solid and the user confirms they're ready
- Each ticket should represent a coherent unit of work that results in one PR
- The plan's implementation order should map to ticket dependencies

## Ticket Structure

Each ticket should include:

### Title
Clear, concise description of what the ticket delivers.
- Good: "Add event listener for application approval notifications"
- Bad: "Backend changes" or "Step 3 of the plan"

### Description
- **Context**: Brief reference to the project and what phase of work this represents
- **What**: Specific changes to make
- **Where**: Repository and file paths
- **Acceptance Criteria**: What "done" looks like
- **Dependencies**: Other tickets that must complete first

### Labels/Tags
- Use project-relevant labels
- Tag with the repository name if multi-repo project

## Jira Integration

Use the Atlassian MCP server to create tickets:
- Create in the appropriate Jira project
- Set story points if the team uses them
- Link tickets that depend on each other
- Add tickets to the current sprint if applicable

## Linking Back to Plan

After creating tickets:
1. Update the plan's "Tickets" section with ticket IDs and links
2. Map each plan step to its corresponding ticket
3. Note any tickets that span multiple plan steps or vice versa

## Notes

- Ticket conventions vary by team and organization
- This reference provides defaults — the user's preferences take priority
- If Jira MCP is not available, tickets can be created manually and referenced in the plan
