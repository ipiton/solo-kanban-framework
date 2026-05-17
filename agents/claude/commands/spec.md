---
description: Write the Solo Kanban technical specification for a task.
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

# Spec

Create the target design before implementation.

**Input:** `$ARGUMENTS` optional task slug.

## Context

Read `requirements.md`, `research.md` if present, workflow policy, artifact contract, and relevant code/docs.

## Steps

1. Confirm `requirements.md` exists.
2. Confirm research is complete or explicitly not required.
3. Create `Spec.md` from the task template.
4. Capture requirements coverage, current state, target design, contracts, data changes, component architecture, security, invariants, edge cases, impact, rollout/rollback, observability, and open questions.
5. Keep the solution explainable in 5-7 sentences.
6. Mark non-applicable sections explicitly instead of leaving ambiguity.

## Stop Conditions

Stop and ask if the task implies an API, data, security, or cross-system change that was not in requirements.

## Output

Write `tasks/<slug>/Spec.md` and summarize key decisions, risks, and next command.
