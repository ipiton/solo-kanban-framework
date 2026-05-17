---
description: Conditional multi-perspective review for high-risk Solo Kanban changes.
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Bash
  - Task
user-invocable: true
---

# Deep Review

Run a deeper review when normal testing is not enough.

Use for:

- large diffs, roughly over 200 changed lines;
- security, auth, permissions, privacy, or data integrity changes;
- pre-release review;
- changes spanning several domains or architectural boundaries.

## Steps

1. Read requirements, research, spec, tasks, test results, and current diff.
2. Define review lenses relevant to the task, such as correctness, security, data, UX, performance, operations, maintainability, or tests.
3. Review only the task scope.
4. Classify findings as `FIX`, `DEFER`, or `NOTE`.
5. Fix blocking `FIX` findings or stop with a clear blocker.
6. Record non-blocking findings in `tasks/<slug>/review-findings.md`.
7. Move follow-ups into planning files during `finalize`.

## Output

Provide a findings summary with file references, severity, recommended action, and verification impact.
