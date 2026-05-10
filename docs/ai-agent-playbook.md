# AI Agent Playbook

Solo Kanban works best when AI agents treat repository artifacts as the source of truth and chat as an execution channel.

## Priority Order

1. Current user instruction.
2. Repository-specific agent instructions.
3. Solo Kanban workflow and artifact contract.
4. General coding style preferences.

If these conflict, obey the more specific and safer instruction.

## Before Coding

1. Read local repository instructions.
2. Read `NEXT.md` and the active task workspace.
3. Read `requirements.md`, `research.md`, `Spec.md`, and `tasks.md` when they exist.
4. Inspect current code before proposing changes.
5. State assumptions when scope is ambiguous.

## During Work

- Keep diffs scoped to the active task.
- Do not silently widen scope.
- Do not revert unrelated user changes.
- Prefer existing project patterns over new abstractions.
- Validate at system boundaries: user input, external services, auth, permissions, data migrations.
- Update `tasks.md` as work progresses.
- Record deviations from `Spec.md` where they happen.

## Research Mode

Use research when the task has external dependencies, multiple viable approaches, security implications, performance uncertainty, infrastructure risk, migration risk, or clear uncertainty.

Research output should include:

- the questions asked;
- facts discovered;
- options considered;
- the chosen decision;
- inputs that must appear in the spec.

## Implementation Mode

Implement from `tasks.md`. If the plan is wrong, update it with the reason instead of improvising silently.

For risky work, use small commits and run checks between phases.

## Testing Mode

Run the strongest practical checks for the changed area. If full checks are too expensive or unavailable, run targeted checks and report the gap.

Never present skipped tests as passing tests.

## Closing Mode

Before closing a task:

1. Confirm success criteria.
2. Confirm checks and skipped-check reasons.
3. Move follow-ups into `BUGS.md`, `TECH-DEBT.md`, or `BACKLOG.md`.
4. Update documentation when behavior or process changed.
5. Archive the task workspace.
6. Add a compact `DONE.md` outcome.

## Stop Conditions

Stop and ask the user when requirements are unclear, the task needs slicing, security or data risk appears outside scope, repeated validation fails, or merge conflicts require product judgment.
