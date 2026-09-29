---
description: Add or update tests for changed Solo Kanban task behavior.
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Bash
user-invocable: true
---

# Write Tests

Add or update tests for the behavior changed by the active task.

## Steps

1. If `deep-review` ran or is required, confirm `tasks/<slug>/review-verdict.json` has `"gate": "pass"` for the current branch. Stop otherwise — `fix_required` goes back to fixing and re-review; `blocked` needs a new review run.
2. Read requirements, spec, tasks, review findings, and current diff.
3. Map success criteria, invariants, and deferred behavioral review findings to tests.
4. Add focused tests near the changed code using project conventions.
5. Avoid tautological tests that only verify mocks or implementation details.
6. Run targeted tests.
7. Update `tasks.md` with test status.

## Output

Report tests added/changed, commands run, and remaining coverage gaps.
