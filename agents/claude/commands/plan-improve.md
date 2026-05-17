---
description: Improve an existing Solo Kanban implementation plan without resetting task state.
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Bash
user-invocable: true
---

# Plan Improve

Refine `tasks.md` after implementation, review, or testing reveals a better sequence.

## Steps

1. Read current `tasks.md`, requirements, spec, and any review/test output.
2. Preserve completed checklist items.
3. Split vague or risky steps into smaller verifiable steps.
4. Add missing verification commands.
5. Record why the plan changed.
6. Do not rewrite the task scope unless requirements changed.

## Output

Update `tasks.md` with a tighter plan and summarize the diff.
