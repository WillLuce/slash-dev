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
1. Read `projects_dir` from config
2. Run this exact command to list projects:
   ```bash
   bash ${CLAUDE_PLUGIN_ROOT}/scripts/list-projects.sh
   ```
3. Present the results via `AskUserQuestion`:
   - Each project as an option
   - Final option: "Other / Create new project"
4. If user selects an existing project: set `projectName` and `projectPath` accordingly
5. If user selects "Other / Create new project":
   - Ask for project name
   - If a project with that name exists, use it
   - Otherwise proceed to Project Initialization

## Project Initialization

Only runs for new projects (typically from `/dev:discovery`).

1. Create project directory: `mkdir -p ${projectPath}`
2. Create `project.json`:
   ```json
   {
     "name": "${projectName}",
     "description": "${user-provided description}",
     "created": "${current date YYYY-MM-DD}",
     "last_activity": "${current date YYYY-MM-DD}",
     "tags": []
   }
   ```
3. Create the phase document appropriate to the command (template defined in each command)

## Session Start

After project resolution, update `last_activity` in `project.json` to today's date.

## Path Setup

After project resolution, define these standard paths:

1. `discoveryPath` = `${projectPath}/00-discovery.md`
2. `architecturePath` = `${projectPath}/01-architecture.md`
3. `planPath` = `${projectPath}/02-plan.md`
4. `meetingsPath` = `${projectPath}/meetings`
5. `changelogPath` = `${projectPath}/CHANGELOG.md`
6. `contextExcludedPath` = `${projectPath}/context-excluded`

## Context Gathering

Do not auto-load phase documents during bootstrap. After project resolution, check which paths exist and output a summary:

```
Available context:
  [check] Discovery docs          (if discoveryPath exists)
  [check] Architecture docs       (if architecturePath exists)
  [check] Implementation plan     (if planPath exists)
  [check] Meeting notes           (if meetingsPath has files)
```

Only show lines for docs that exist. Load documents when the user or the command's workflow calls for them.

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

Each invocation starts fresh. Do not attempt to resume or continue from a previous session. After loading context, proceed directly into the command's defined workflow.
