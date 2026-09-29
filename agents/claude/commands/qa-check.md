---
description: Read-only Definition of Done verification for Solo Kanban tasks.
allowed-tools:
  - Read
  - Glob
  - Grep
  - Bash
user-invocable: true
---

# QA Check

Read-only verification of readiness. Do not mutate files.

## Steps

1. Detect active task from branch, WIP, or `$ARGUMENTS`.
2. Read requirements, research, spec, tasks, test output, review findings, and `review-verdict.json`.
3. Check each Definition of Done item, including: the verdict is `pass` and matches the current branch when deep-review ran (report `n/a` when it was not required); every `assumed` design premise is resolved or carried as a risk.
4. Report each item as `PASS`, `WARN`, or `FAIL`.
5. Identify missing evidence and recommended next command.

## Output

Return a concise readiness report. `FAIL` means do not finalize yet.
