# MCP Server Usage Guide

This reference describes commonly used MCP servers and how to use them effectively within the `/dev-*` workflow.

## Context7 — Library Documentation

**What it does**: Retrieves up-to-date documentation and code examples for libraries and frameworks.

**When to use**: Whenever you need documentation for a library, framework, or specification. Prefer this over web search for technical docs.

**How to use**:
1. First resolve the library ID: use `resolve-library-id` with the library name
2. Then query docs: use `query-docs` with the resolved ID and your question

**Common library IDs**:
- React: `/websites/react_dev`
- TypeScript: `/websites/typescriptlang_org`
- Conventional Commits: `/websites/conventionalcommits_en_v1_0_0`
- C4 Model: `/websites/c4model`

**Best practice**: Always resolve the library ID first — don't guess. Library IDs can change.

---

## GitHub — Repository Management

**What it does**: Interacts with GitHub repositories, PRs, issues, branches, and code.

**When to use**:
- Searching for repositories or code across GitHub
- Reading files from remote repos
- Creating/managing pull requests
- Creating/managing issues
- Viewing branches, commits, and tags

**Common operations in the /dev-* workflow**:
- **Discovery**: Search for repos, read remote code, explore organization repositories
- **Architecture**: Read code from repos you don't have cloned locally
- **Planning**: Check existing PRs/issues, verify branch state
- **Implementation**: Create branches, PRs, push code, manage reviews

---

## Atlassian — Confluence & Jira

**What it does**: Interacts with Confluence pages and Jira tickets.

**When to use**:
- Looking up product requirements in Confluence
- Creating/updating Jira tickets during planning
- Checking ticket status during implementation
- Finding existing documentation or specifications

**Common operations in the /dev-* workflow**:
- **Discovery**: Look up product specs, feature requirements, existing documentation
- **Planning**: Create Jira tickets, set story points, link dependencies
- **Implementation**: Update ticket status, add comments, link PRs
- **Meeting**: Reference tickets discussed, update action items

---

## General Best Practices

1. **Prefer Context7 over web search** for library/framework documentation
2. **Use GitHub MCP for remote repos** — don't assume everything is cloned locally
3. **Check Atlassian for product context** — Confluence often has requirements and specs that inform discovery
4. **MCP servers are optional** — the workflow works without them, but they enhance discovery, planning, and implementation
5. **Check what's available** — run `/dev-setup` to see which MCP servers are detected
