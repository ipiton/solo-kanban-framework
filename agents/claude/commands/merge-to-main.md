---
description: Merge a finalized Solo Kanban task into the integration branch.
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

# Merge To Main

Merge a finalized task branch into the integration branch.

## Steps

1. Confirm the current branch is not the integration branch.
2. Confirm the working tree is clean.
3. Confirm `finalize` has run and the workspace is archived.
4. Sync with the integration branch.
5. Merge using repository policy.
6. Resolve conflicts only when safe and obvious; otherwise stop.
7. Confirm `DONE.md` and `NEXT.md` reflect the task state.
8. Run post-merge checks required by the repository.

## Output

Report merge target, result, checks, and any follow-up risk.
