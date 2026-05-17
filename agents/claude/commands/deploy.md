---
description: Optional project-specific deployment or runtime verification step.
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

# Deploy

Run only when the task affects runtime behavior and the repository has a deployment or smoke-test process.

## Steps

1. Confirm testing passed.
2. Read local deployment instructions.
3. Confirm target environment with the user if it is not obvious.
4. Run the repository's approved deployment or smoke-test command.
5. Verify the changed behavior in the target environment.
6. Record rollout, verification, and rollback notes in `tasks.md`.

## Stop Conditions

Stop before production-impacting actions unless repository policy or the user explicitly authorizes them.

## Output

Report target, command, result, smoke verification, rollback note, and next command.
