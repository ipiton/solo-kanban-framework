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

1. Read requirements, spec, tasks, and current diff.
2. Map success criteria and invariants to tests.
3. Add focused tests near the changed code using project conventions.
4. Avoid tautological tests that only verify mocks or implementation details.
5. Run targeted tests.
6. Update `tasks.md` with test status.

## Output

Report tests added/changed, commands run, and remaining coverage gaps.
