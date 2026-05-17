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

Use `research --grounded` when the user needs evidence-only verification. In this mode, separate facts from assumptions and attach each meaningful claim to code, docs, logs, specs, or cited sources.

## Planning Mode

Use `plan` to turn requirements, research, and spec decisions into concrete implementation steps. Each step should be small enough to verify.

Use `plan --parallel` only when independent lanes have disjoint write scopes and can be verified separately.

Use `plan-improve` when the existing plan needs better ordering, narrower steps, or clearer verification after implementation, testing, or review feedback.

## Implementation Mode

Implement from `tasks.md`. If the plan is wrong, update it with the reason instead of improvising silently.

For risky work, use small commits and run checks between phases.

## Testing Mode

Run the strongest practical checks for the changed area. If full checks are too expensive or unavailable, run targeted checks and report the gap.

Never present skipped tests as passing tests.

Use `qa-check` for read-only Definition of Done verification. It should report status per item and avoid mutating planning state.

## Finalize Mode

`finalize` replaces separate documentation and close commands. Treat it as two phases:

1. Phase 1: update docs, changelog, release notes, or knowledge artifacts affected by the task.
2. Phase 2: close the task, capture follow-ups, archive the workspace, and prepare merge.

Before finalizing a task:

1. Confirm success criteria.
2. Confirm checks and skipped-check reasons.
3. Move follow-ups into `BUGS.md`, `TECH-DEBT.md`, or `BACKLOG.md`.
4. Update documentation when behavior or process changed.
5. Archive the task workspace.
6. Add a compact `DONE.md` outcome.

## Stop Conditions

Stop and ask the user when requirements are unclear, the task needs slicing, security or data risk appears outside scope, repeated validation fails, or merge conflicts require product judgment.
