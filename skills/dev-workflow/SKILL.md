---
name: dev-workflow
description: This skill provides shared workflow logic for the /dev:* phased development commands. It handles configuration loading, project resolution, context gathering, project initialization, and back-propagation rules. Referenced by all /dev:* commands — do not trigger independently.
---

# Dev Workflow — Shared Logic

This skill is referenced by `/dev:*` commands. It is not invoked directly.

## Configuration Loading

1. Read `${CLAUDE_PLUGIN_ROOT}/config.local.json`
2. If the file does NOT exist:
   - Output:
     ```
     Configuration not found.

     Run /dev:configure to set up your workspace.
     ```
   - STOP execution
3. If the file DOES exist:
   - Extract `projects_dir` value
   - Extract `code_dirs` value (optional)

## Project Resolution

If the command was invoked WITH a project name argument:
1. Set `projectName` to the argument (join multiple words with hyphens)
2. Set `projectPath` to `${projects_dir}/${projectName}`
3. Check if `projectPath` exists
4. If it does NOT exist AND the command is `/dev:discovery`:
   - This is a new project — proceed to Project Initialization
5. If it does NOT exist AND the command is NOT `/dev:discovery`:
   - Output: "Project '${projectName}' not found. Run /dev:discovery first."
   - STOP execution

If the command was invoked WITHOUT a project name argument:
1. Read the session history from `${CLAUDE_PLUGIN_ROOT}/sessions.local.log`
2. Check if there is a recent session entry (the last line in the log)
3. If a recent session exists, ask the user:
   - "Last time you were in **[command]** mode on **[project]**. Continue with that project, or switch?"
   - Use `AskUserQuestion` with options:
     - "Continue with [project]"
     - "Switch project"
4. If the user wants to continue: set `projectName` and `projectPath` accordingly
5. If the user wants to switch (or no session history):
   - Read `projects_dir` from config
   - Scan subdirectories for `project.json` files
   - Present all projects via `AskUserQuestion`:
     - Each existing project as an option: "[name] — [description]"
     - Final option: "Create new project"
   - If user selects an existing project: set `projectName` and `projectPath` accordingly
   - If user selects "Create new project":
     - Ask for project name
     - Ask for a brief description
     - Proceed to Project Initialization

## Project Initialization

Only runs for new projects (typically from `/dev:discovery`).

1. Create project directory: `mkdir -p ${projectPath}`
2. Create `project.json`:
   ```json
   {
     "name": "${projectName}",
     "description": "${user-provided description}",
     "created": "${current date YYYY-MM-DD}",
     "tags": []
   }
   ```
3. Create the phase document appropriate to the command (template defined in each command)

## Path Setup

After project resolution, define these standard paths:

1. `discoveryPath` = `${projectPath}/00-discovery.md`
2. `architecturePath` = `${projectPath}/01-architecture.md`
3. `planPath` = `${projectPath}/02-plan.md`
4. `meetingsPath` = `${projectPath}/meetings`
5. `changelogPath` = `${projectPath}/CHANGELOG.md`
6. `contextExcludedPath` = `${projectPath}/context-excluded`

## Context Gathering

### Always Auto-Load
Read these files if they exist:
- `project.json` — project metadata
- `${discoveryPath}` — problem definition, exploration findings, solution direction
- `${architecturePath}` — component design, C4 diagrams, data flows
- `${planPath}` — implementation steps, repo/file specs, tickets

### Offer On Request
Check if these exist and mention their availability:
- `${meetingsPath}` — if directory has files, output: "Meeting notes available. Want me to load any?"

### Never Auto-Load
Do not load or mention unless the user explicitly asks:
- `${changelogPath}` — back-propagation history (grows over time)
- `${contextExcludedPath}` — scratch files, references

## Context Status Output

After loading context, output:

```
Available context:
  [check] Discovery docs          (if discoveryPath exists)
  [check] Architecture docs       (if architecturePath exists)
  [check] Implementation plan     (if planPath exists)
  [check] Meeting notes           (if meetingsPath has files)
```

Only show lines for docs that exist.

## Session Logging

After project resolution, append a line to `${CLAUDE_PLUGIN_ROOT}/sessions.local.log`:

```
${YYYY-MM-DD HH:MM} ${projectName} ${command}
```

Where `${command}` is the phase name: `discovery`, `architecture`, `plan`, `implement`, `meeting`, `meta`, etc.

This file is gitignored (`*.local.*`) and stays on the user's machine. It powers the "continue or switch?" prompt and provides a history of how the user has been working across all projects.

## Back-Propagation Rules

When any command updates a phase document that belongs to an earlier phase (e.g., updating discovery while in implementation mode):

1. Make the update to the earlier document
2. Append an entry to `${changelogPath}` (create the file if it doesn't exist):
   ```markdown
   ## ${current date YYYY-MM-DD}
   **Updated**: ${filename}
   **Trigger**: ${brief description of what prompted the change}
   **Summary**: ${what was changed and why}
   ```
3. Inform the user: "Updated ${filename} and logged the change."

## Resumption Behavior

When a command loads an existing phase document:
1. Read the document
2. Provide a brief summary of the current state
3. Ask how the user wants to continue

This applies to all phase commands — discovery, architecture, planning, implementation.
