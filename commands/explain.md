---
description: Understand the /dev:* workflow and phased development approach
argument-hint: [specific-command]
---

# Dev Workflow Guide

When this command is invoked:

## Purpose

This command explains the `/dev:*` phased development workflow, helping you understand:
- The philosophy behind each mode
- When to use each command
- How the project structure supports collaborative development
- How planning produces Jira tickets for autonomous or collaborative execution
- Best practices for working through complex projects

## Mode Selection

If the user provided an argument (specific command name):
- Provide detailed explanation of that specific command
- Show examples of when to use it
- Explain its inputs/outputs and relationship to other modes

If no argument provided:
- Present the full workflow overview FIRST — walk the user through the philosophy, the phases, the project structure, and the common workflows before asking questions
- After the overview, transition to interactive Q&A
- Help the user understand which mode they should use for their current task

**Important**: Lead with substance. Don't just ask what the user wants to know — explain the workflow thoroughly first. The user came here to learn, so teach them. Then open the floor.

---

## The /dev:* Workflow Philosophy

### Core Principles

**Phased Over Monolithic**
Complex engineering work benefits from distinct phases: understanding the problem (discovery), designing the solution (architecture), planning the execution (planning), and building (implementation). Trying to do all phases simultaneously leads to confusion and rework.

**Collaborative Over Autonomous**
Claude is positioned as a thought partner, not an autopilot. Each mode emphasizes back-and-forth conversation, asking questions, and waiting for guidance rather than charging ahead with assumptions.

**Persistent Over Ephemeral**
Everything is saved to markdown files in a structured project directory. This creates a knowledge base that persists across sessions, can be reviewed by teammates, and serves as documentation of both the problem and solution.

**Maps and Tickets**
The workflow produces two kinds of artifacts: *maps* (markdown docs that capture understanding, design, and rationale) and *tickets* (Jira stories that define discrete work units). Maps stay in the project directory. Tickets live in Jira. The plan connects the two — it's the sequencing logic that explains why tickets are ordered the way they are.

**Ticket-Ready Output**
Planning mode produces Jira tickets structured for handoff to any developer — human or autonomous agent. Each ticket includes scope, acceptance criteria, constraints, context pointers, and dependencies. A developer picking up a ticket should be able to start work without asking questions.

---

## Available Commands

### /dev:configure
**Purpose**: Configure your /dev:* workflow preferences (run this first!)

**When to use**:
- First time setting up the /dev:* workflow
- When you want to change where projects are stored
- When moving to a new machine

**What it does**:
- Asks where you want to store project documentation
- Asks where your code repositories are located
- Learns about you (role, team) to tailor collaboration
- Optionally configures commit conventions, ticket system, PR workflow
- Detects installed MCP servers
- Stores configuration in `${CLAUDE_PLUGIN_ROOT}/config.local.json`

---

### /dev:discovery <project-name>
**Purpose**: Collaboratively explore and define the problem space for a project.

**When to use**:
- Starting a new feature or bug fix
- Investigating an unfamiliar codebase
- Refining a product request into a technical problem definition

**What it produces**: `00-discovery.md` — problem context, affected repos, key files, entry points, dependencies, scope assessment, and solution direction.

**Key behavior**: Collaborative exploration. Claude asks questions and follows the user's lead. Does not jump to solutions prematurely.

---

### /dev:architecture <project-name>
**Purpose**: Design the solution — components, data flow, interfaces, technical decisions.

**When to use**:
- After discovery, when the problem is well-defined
- When you need to design component structure, data flows, and integration points
- To create C4 diagrams for the solution

**What it produces**: `01-architecture.md` — solution design, component architecture, data flow, integration points, design decisions and rationale.

**Key behavior**: Collaborative design. Formalizes the solution direction from discovery into precise architectural decisions. Supports C4 diagramming.

---

### /dev:plan <project-name>
**Purpose**: Sequence the work and produce Jira tickets.

**When to use**:
- After architecture is designed
- When you need to break work into ordered, executable units
- To create tickets that can be picked up by any developer

**What it produces**:
- `02-plan.md` — the solution map: sequencing logic, decision log, constraints and risks, ticket index
- **Jira tickets** (via Atlassian MCP) — the actual work units, each structured with scope, acceptance criteria, constraints, context pointers, and dependencies

**Key behavior**: The plan is a map, not a manifest. Architecture describes the components. The plan describes the order you build them and why. File-level implementation detail lives in the Jira tickets, not the plan.

**The plan and tickets are separate concerns.** You can read the plan to understand the approach without loading every ticket. Ticket detail lives in Jira and is queried on demand.

---

### /dev:implement <project-name>
**Purpose**: Execute the work — pick up a ticket, build it, review it, ship it.

**When to use**:
- After planning is complete and tickets exist
- When ready to write/modify code

**What it does**:
- Selects a Jira ticket to work on (user specifies or picks from the plan's ticket list)
- Fetches ticket details from Jira (scope, acceptance criteria, constraints)
- Loads the solution map for architectural context
- Follows the three-phase pattern: Discuss (WAIT) -> Plan steps (WAIT) -> Execute incrementally
- Commits complete thoughts (code + tests together)
- Runs code review before pushing
- Updates ticket status in Jira

**Key behavior**: Works from the ticket, not the plan. The ticket defines *what* to build. The solution map provides *why* context. More autonomous than other phases, but still follows discuss/plan/execute.

---

### /dev:meeting <project-name>
**Purpose**: Capture meeting notes with full project context awareness.

**When to use**:
- During project meetings or design discussions
- When you need help connecting discussion to existing project docs

**What it produces**: `meetings/YYYY-MM-DD.md` — attendees, discussion topics, decisions, action items, follow-up questions.

**Key behavior**: Supportive observer. Surfaces relevant context when topics align with docs. Stays quiet during basic note-taking. Summarizes at meeting end and suggests doc updates.

---

### /dev:meta
**Purpose**: Work on the slash-dev plugin itself.

**When to use**:
- When contributing to or modifying the slash-dev plugin
- For dogfooding — using the tool to improve itself

---

### /dev:update
**Purpose**: Pull the latest version of the slash-dev plugin.

**When to use**:
- When a new version has been released
- To check for updates

---

## Project Structure

When you run `/dev:discovery <project-name>`, this structure is created:

```
<projects-dir>/<project-name>/
├── project.json              # Metadata (name, description, last_activity)
├── 00-discovery.md           # Problem definition and exploration
├── 01-architecture.md        # Solution design
├── 02-plan.md                # Solution map (sequencing, decisions, ticket index)
├── CHANGELOG.md              # Back-propagation log (not auto-loaded)
├── meetings/                 # Meeting notes
│   ├── 2026-01-13.md
│   └── ...
└── context-excluded/         # Scratch files (never auto-loaded)
```

Tickets live in Jira, not in the project directory. The plan's Tickets table is an index linking to Jira.

---

## Common Workflows

### First Time Setup
1. `/dev:configure` — configure your workspace (only needed once)

### New Feature (Full Workflow)
1. `/dev:discovery feature-name` — explore relevant code, define the problem
2. `/dev:architecture feature-name` — design the solution
3. `/dev:plan feature-name` — sequence the work, create Jira tickets
4. `/dev:implement feature-name` — pick up tickets and build

### Simple Bug Fix
1. `/dev:discovery bug-name` — find where the bug is
2. `/dev:implement bug-name` — fix it (skip architecture/planning for simple fixes)

### Design Discussion
1. `/dev:discovery project-name` — initial exploration
2. `/dev:meeting project-name` — capture design discussion
3. `/dev:architecture project-name` — formalize decisions from meeting

### Investigation (No Implementation)
1. `/dev:discovery investigation-name` — find relevant code
2. `/dev:architecture investigation-name` — document how it works
3. (Stop here — no plan or implementation needed)

---

## Sharing With Your Team

The slash-dev plugin is distributed via GitHub. Each developer:
1. Installs the plugin in Claude Code
2. Runs `/dev:configure` to configure their own paths and preferences
3. Uses the same `/dev:*` commands, configured for their machine

Project docs can be committed to git so team members can review and resume each other's work. Team-specific ticket conventions (Jira project, title patterns, hierarchy) live in each developer's `config.local.json` — not checked in.

---

## Interactive Q&A

You are now in EXPLAIN MODE. The user can ask questions like:

- "Which mode should I use for X?"
- "What's the difference between the plan and the architecture?"
- "What goes in a ticket vs the plan?"
- "Can I skip planning and go straight to implementation?"
- "How do I resume work from last week?"
- "How do I share this with my team?"

**Your role**:
- Answer questions clearly and helpfully
- Use examples from the documentation above
- Help the user understand which mode fits their current need
- Explain the "why" behind the workflow design
- Be conversational, not prescriptive

**Key messages to emphasize**:
- **Collaborative, not autonomous**: Each mode expects interaction, not fire-and-forget
- **Maps and tickets**: Docs capture understanding and rationale. Tickets capture work units.
- **Phased thinking**: Understanding before designing, designing before planning, planning before implementing
- **Flexible**: You can skip phases for simple tasks or revisit earlier phases

---

**IMPORTANT — Presentation Order:**

When no specific command is requested, present the content in this order:
1. Open with a brief welcome: what slash-dev is and what it's for
2. Walk through the philosophy (phased, collaborative, persistent, maps and tickets)
3. Explain each command with its purpose and when to use it
4. Show the project structure
5. Walk through 2-3 common workflows as concrete examples
6. THEN transition: "That's the overview. What questions do you have, or would you like to dive deeper into any of these?"

Do NOT skip to Q&A. The user is here to learn the system.
