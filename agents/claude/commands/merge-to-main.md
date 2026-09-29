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

This step is **mechanics only**. `finalize` has already written `DONE.md`, `NEXT.md`, and the archive move on the task branch and synced it with the integration branch. `merge` writes no planning files, so it can be run by a cheaper model or a script.

## Steps

1. Confirm the current branch is not the integration branch.
2. Confirm the working tree is clean.
3. Confirm `finalize` has run and the workspace is archived.
4. Sync with the integration branch.
5. Merge using repository policy.
6. Resolve conflicts only when safe and obvious; otherwise stop.
7. Push, and delete the task branch (and worktree) according to repository policy.
8. Run post-merge steps required by the repository, such as rebuilding a docs search index on the merged integration branch. A failure there is reported, not a reason to revert the merge.

## Output

Report merge target, result, checks, and any follow-up risk.
