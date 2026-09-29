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

1. Read the owner inbox (marker lines `Blocked-by:`, `Waiting-on:`, `Trigger:` across planning files). If an owner action is unblocked, report it first — it outranks Queue position 1. More than 5 unblocked items: do not pull new roadmap work.
2. Select the task from Queue, or use the explicit task from `$ARGUMENTS`. A bundle slug (`*-BUNDLE`) starts the whole batch: its members become the phases of one `tasks.md`.
3. Check WIP against the limit in `NEXT.md` § Flow Rules. If WIP is already at the limit, stop and ask which task should be paused or finished.
4. Detect duplicates in `tasks/`, `tasks/archive/`, and the closure journal including its monthly archives, by slug, task id, and similar wording.
5. Determine `slug`, `stream`, `type`, `priority`, and branch prefix.
6. Move the task into WIP in `NEXT.md` and commit this claim on the integration branch — it is the only direct write to that branch in the pipeline, planning files only. Delete the Queue line; do not comment it out.
7. Create or switch to a task branch (or worktree) unless the user explicitly asked to stay on the current branch.
8. Create `tasks/<slug>/requirements.md` from the template.
9. Fill requirements with problem framing, user stories, success criteria, non-goals, constraints, and discovery notes.
10. Classify the **Risk Profile** in `requirements.md`:
   - Mark signals from `{C, S, M, X, R}` or `none` (see `docs/workflow.md` `Step Matrix` for signal definitions).
   - Derive **Tier**: `Lightweight` (zero signals) / `Standard` (1-2 of C/X/R only) / `Full` (any S, any M, or 3+ signals).
   - If uncertain, ask the user before guessing — the tier determines the required pipeline.
11. Decide research level using workflow triggers. Research triggers and risk signals overlap; one or more risk signals usually implies research level 2 or 3.

## Output

Report:

- owner inbox status;
- selected task and source;
- WIP status;
- branch;
- workspace path;
- **risk profile** (signals + tier);
- research level and next command (derived from tier per `Step Matrix`).

Stop if requirements are unclear enough to change the solution, or if the risk profile cannot be determined from current information.
