---
description: Implement a Solo Kanban task from its checklist.
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

# Implement

Implement the active task from `tasks.md`.

## Context

Read requirements, research, spec, and tasks before editing code.

## Steps

1. Confirm the current branch and dirty worktree.
2. Work through `tasks.md` in order.
3. Keep diffs scoped to the active task.
4. Prefer existing project patterns.
5. Update checklist status as steps are completed or blocked.
6. Run step-level verification where practical.
7. Record deviations from `Spec.md` in `tasks.md` or `Spec.md`.

## Stop Conditions

Stop if scope expands, requirements are unclear, repeated checks fail, or the implementation requires unplanned security/data/API changes.

## Output

Summarize changed files, completed checklist items, verification run, and next command.
