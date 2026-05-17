---
description: Start or select a Solo Kanban task and create its workspace.
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Bash
  - AskUserQuestion
user-invocable: true
---

# Start Task

Start working on a task in the Solo Kanban system.

**Input:** `$ARGUMENTS`
- empty or `next`: select the next task from `NEXT.md`
- slug or description: start that task explicitly

## Context

Read:

1. repository instructions (`AGENTS.md`, `CLAUDE.md`, or equivalent);
2. `docs/workflow.md` or the local workflow policy;
3. `docs/artifact-contract.md` or the local artifact contract;
4. planning files, especially `NEXT.md`, `DONE.md`, `BUGS.md`, `TECH-DEBT.md`, `BACKLOG.md`, and `ROADMAP.md`;
5. `tasks/templates/requirements.md`.

## Steps

1. Select the task from Queue, or use the explicit task from `$ARGUMENTS`.
2. Check WIP. If WIP is already at the repository limit, stop and ask which task should be paused or finished.
3. Detect duplicates in `tasks/` and `tasks/archive/` by slug, task id, and similar wording.
4. Determine `slug`, `stream`, `type`, `priority`, and branch prefix.
5. Move the task into WIP in `NEXT.md`.
6. Create `tasks/<slug>/requirements.md` from the template.
7. Create or switch to a task branch unless the user explicitly asked to stay on the current branch.
8. Fill requirements with problem framing, user stories, success criteria, non-goals, constraints, and discovery notes.
9. Decide research level using workflow triggers.

## Output

Report:

- selected task and source;
- WIP status;
- branch;
- workspace path;
- research level and next command.

Stop if requirements are unclear enough to change the solution.
