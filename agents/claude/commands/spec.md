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

1. Confirm `requirements.md` exists and has a recorded **Risk Profile**.
2. Confirm research is complete or explicitly not required.
3. Create `Spec.md` from the task template.
4. Write **Design Premises** before the target design: statements about reality the design depends on, each with how it was confirmed and a class from the closed vocabulary `measured` / `call-path-traced` / `code-read` / `assumed`. Search the whole repository before claiming `call-path-traced`; do not call reading code a measurement. Copy every `assumed` premise into `Open Questions` or `Rollout / Rollback` as a risk.
5. Capture requirements coverage, current state, target design, contracts, data changes, component architecture, security, invariants, edge cases, impact, rollout/rollback, observability, **deep review**, and open questions.
6. In the `Deep Review` section, classify triggers against `docs/workflow.md`:
   - mandatory if any `S`, any `M`, pre-release, or 3+ signals;
   - discretionary if large diff (>~200 LOC) without S/M, combined `C+X`, novel pattern, or author doubt;
   - record the decision: `required` / `recommended, will run` / `recommended, skipped (reason: ...)` / `not applicable`.
7. If spec work reveals new risk signals not present in `requirements.md`, update the Risk Profile there before continuing — tier may escalate.
8. Keep the solution explainable in 5-7 sentences.
9. Mark non-applicable sections explicitly instead of leaving ambiguity.

## Stop Conditions

Stop and ask if:

- the task implies an API, data, security, or cross-system change that was not in requirements;
- a premise the design cannot survive without is `assumed` and cheap to check — check it now instead of carrying it;
- the risk profile escalates from `Standard` to `Full` after spec work — confirm with the user before committing to the heavier pipeline.

## Output

Write `tasks/<slug>/Spec.md` and summarize key decisions, risks, and next command.
