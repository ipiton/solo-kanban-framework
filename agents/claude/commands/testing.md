---
description: Run quality gates and record Solo Kanban verification evidence.
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Bash
user-invocable: true
---

# Testing

Run the strongest practical checks for the active task.

## Steps

1. Read `tasks.md`, `Spec.md`, and current diff.
2. Choose checks based on changed files: unit tests, type checks, lint, build, integration tests, docs checks, or project quality gates.
3. Run targeted checks first if full checks are expensive.
4. Run full project checks when risk or repository policy requires it.
5. Record failed checks and fixes.
6. Create or update `tasks/<slug>/review-findings.md` for non-blocking findings.
7. Mark skipped checks with explicit reasons.

## Output

Report pass/fail per check, fixes applied, skipped checks, and whether `deep-review` is needed.
