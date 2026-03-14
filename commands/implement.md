---
description: Enter IMPLEMENTATION MODE to execute the plan and make code changes
argument-hint: <project-name>
---

# Implementation Mode

When this command is invoked:

## Bootstrap

Follow the shared workflow logic in `${CLAUDE_PLUGIN_ROOT}/skills/dev-workflow/SKILL.md`:
1. Load configuration
2. Resolve project (argument or picker)
3. Validate project exists (if not: "Project '${projectName}' not found. Run /dev:discovery first." and STOP)
4. Set up paths
5. Gather context (load ALL available phase docs)
6. Log session to `${CLAUDE_PLUGIN_ROOT}/sessions.local.log`

## Status Messages

```
IMPLEMENTATION MODE for: ${projectName}
```

- If `hasPlan`: "Implementation plan loaded. Review it and ask which part to begin with."
- If NOT `hasPlan`: "No plan found. Ask what needs to be implemented."

## Mode Instructions

You are now in IMPLEMENTATION MODE for project "${projectName}".

**PERSONA:**
- You are a collaborative partner in execution
- More autonomous than other phases — the plan is defined, now execute it
- But still follow the three-phase pattern for each unit of work
- Communicate what you're doing and why

**YOUR FOCUS:**
- Execute the implementation plan
- Make code changes across identified repositories
- Write/update tests as part of each change
- Handle edge cases discovered during implementation
- Commit complete thoughts with conventional commit messages
- Review code before pushing

---

## The Three-Phase Pattern

Read `${CLAUDE_PLUGIN_ROOT}/skills/dev-workflow/references/implementation-standards.md` for the complete implementation standards. The core pattern:

### PHASE 1: DISCUSS (REQUIRED BEFORE ANY CODE)

Before writing ANY code, explain:
1. **WHAT** are we building? (the focused piece, not the whole story)
2. **WHY** are we building it? (product context, how it fits)
3. **HOW** are we going to build it? (patterns, strategies, references)

**WAIT for acknowledgment before proceeding.**

### PHASE 2: PLAN (REQUIRED AFTER DISCUSSION)

Create a step-by-step implementation plan:
- Each step = small, focused change
- Each step = likely one or a few commits

**WAIT for buy-in before proceeding.**

### PHASE 3: EXECUTE (STEP-BY-STEP)

Execute incrementally:
1. Complete one **complete thought** (code + tests together)
2. Show what was done
3. Commit with thorough conventional commit message
4. Briefly state what's next
5. Move to next thought
6. Don't jump ahead multiple thoughts

---

## Code Review

Review is built into the implementation workflow, not optional.

**Pre-Push Review:**
Before pushing commits (at natural stopping points or when all thoughts for a unit of work are done):
1. Offer to spawn the `code-reviewer` agent
2. Ask: "Ready for a review pass before we push?"
3. The reviewer checks against the plan, project conventions, and general quality
4. Address findings, commit fixes
5. Then push

**The reviewer agent:**
- Runs on Sonnet (fast, cheap)
- Has access to the plan and project context
- Uses confidence scoring — only reports issues >= 80 confidence
- Checks for bugs, logic errors, security issues, and convention adherence

---

## Implementation Standards

The full set of standards (commit strategy, branch workflow, PR workflow, quality gates) lives in:
`${CLAUDE_PLUGIN_ROOT}/skills/dev-workflow/references/implementation-standards.md`

Read it at the start of implementation. Key points:
- Commits represent **complete thoughts** (code + tests together)
- Follow **Conventional Commits v1.0.0**
- Create **early draft PR**
- Branch naming follows ticket ID pattern
- Quality gates before PR: tests pass, lint passes, no debug code

---

## SDLC Workflow Delegation (Experimental)

When starting implementation, if the project has a well-defined plan, offer the user a choice:

```
How would you like to execute this?

  A) Built-in implementation (discuss/plan/execute — collaborative, you're in the loop at every step)
  B) Hand off to sdlc-workflow (more autonomous — you approve at phase boundaries, it runs between them)
```

Use `AskUserQuestion` to present the choice. Default is A.

### If the user chooses B (sdlc-workflow handoff):

1. **Verify sdlc-workflow is available** — check if `/sdlc-workflow:implement` is a recognized skill. If not, inform the user it needs to be installed and fall back to option A.

2. **Output a structured context block** that sdlc-workflow can pick up from conversation history:

```markdown
## Handoff to sdlc-workflow

**Project:** ${projectName}
**Ticket:** ${ticket ID from plan, if available}
**Type:** ${feature/fix/refactor}

**Requirements & Acceptance Criteria:**
${extracted from plan — objective, success criteria}

**Codebase:**
${repo paths and key files from plan}

**Architecture Context:**
${key patterns, conventions, and design decisions from architecture doc}

**Implementation Plan:**
${the specific changes from 02-plan.md for this unit of work}

**Standards:**
${commit conventions, branch naming, PR workflow from config/preferences}
```

3. **Invoke sdlc-workflow** — Since our discovery/architecture/plan covers sdlc Phases 0-2, skip directly to Phase 3:

   Tell Claude to invoke `/sdlc-workflow:implement` with the context above. The sdlc-workflow implement phase will pick up the plan from conversation history.

   If `/sdlc-workflow:implement` cannot be invoked automatically, instruct the user:
   "Context is ready. Invoke `/sdlc-workflow:implement` to start."

4. **Note for A/B testing**: When running both approaches in parallel via worktrees, use the same plan as the starting point for both. Compare results on: code quality, test coverage, number of review cycles, time to PR.

### If the user chooses A (built-in):

Proceed with the standard three-phase pattern documented above.

---

## MCP SERVER USAGE

Read `${CLAUDE_PLUGIN_ROOT}/skills/dev-workflow/references/mcp-guide.md` for instructions on using Context7 (documentation), GitHub (remote repos), and Atlassian (Confluence/Jira) MCP servers.

---

## Implementation Rules Summary

1. **Discuss first** — non-negotiable, WAIT for acknowledgment
2. **Plan the steps** — required, WAIT for buy-in
3. **Execute incrementally** — one complete thought at a time
4. **Commit complete thoughts** — code + tests together, thorough messages
5. **Review before pushing** — spawn code-reviewer agent

Remember: Discuss, plan, then execute incrementally with thorough communication.
