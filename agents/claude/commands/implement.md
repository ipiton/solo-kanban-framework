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
2. Work through `tasks.md` in order. For each step: write the code, run its `verify:` command, re-read the change against the rules, fix what you find.
3. Keep diffs scoped to the active task.
4. Prefer existing project patterns.
5. Update checklist status as steps are completed or blocked.
6. Run step-level verification where practical.
7. Record deviations from `Spec.md` in `tasks.md` or `Spec.md`.
8. Do not write test files here. They are written in `write-tests`, after `deep-review` returns `pass` (or when no deep-review is required). If the repository enforces the verdict with a hook, a test write here will be refused.
9. For refactors, follow `docs/agent-policies.md` § Refactoring Policy: no behavior change, one change type per branch, small commits.

## Stop Conditions

Stop if scope expands, requirements are unclear, repeated checks fail, or the implementation requires unplanned security/data/API changes.

## Output

Summarize changed files, completed checklist items, verification run, and next command: `deep-review` when required by the tier or chosen as discretionary, otherwise `write-tests`.
