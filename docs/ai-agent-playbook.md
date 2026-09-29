# AI Agent Playbook

Solo Kanban works best when AI agents treat repository artifacts as the source of truth and chat as an execution channel.

## Priority Order

1. Current user instruction.
2. Repository-specific agent instructions.
3. Solo Kanban workflow, agent policies, and artifact contract.
4. General coding style preferences.

If these conflict, obey the more specific and safer instruction.

## Before Coding

1. Read local repository instructions.
2. Read `NEXT.md`, the owner inbox, and the active task workspace.
3. Read `requirements.md` (including its **Risk Profile**), `research.md`, `Spec.md`, and `tasks.md` when they exist.
4. Confirm the task's tier (`Lightweight` / `Standard` / `Full`) from the Risk Profile in `requirements.md`. The tier selects the required pipeline — see `docs/workflow.md` `Step Matrix`.
5. Inspect current code before proposing changes. Delegate wide searches to a read-only sub-agent — see `docs/agent-policies.md` § Discovery Cost.
6. State assumptions when scope is ambiguous.
7. If new risk signals appear mid-task (security implication, migration need, cross-domain reach), update the Risk Profile in `requirements.md` before continuing — the tier may escalate.

## During Work

- Keep diffs scoped to the active task.
- Do not silently widen scope.
- Do not revert unrelated user changes.
- Prefer existing project patterns over new abstractions.
- Validate at system boundaries: user input, external services, auth, permissions, data migrations.
- Update `tasks.md` as work progresses.
- Record deviations from `Spec.md` where they happen.
- Classify a failure before retrying it — see `docs/agent-policies.md` § Retry Policy.

## Research Mode

Use research when the task has external dependencies, multiple viable approaches, security implications, performance uncertainty, infrastructure risk, migration risk, or clear uncertainty.

Research output should include:

- the questions asked;
- facts discovered;
- options considered, and how they were generated;
- the chosen decision;
- inputs that must appear in the spec.

Use `research --grounded` when the user needs evidence-only verification. In this mode, separate facts from assumptions and attach each meaningful claim to code, docs, logs, specs, or cited sources.

When a wrong choice is expensive, generate options with independent read-only agents, one lens each (`minimal-diff`, `reuse-first`, `reversibility`, `operational`). Merge them yourself, and record convergence as data, not as proof.

Store data that cannot be re-obtained from the repository in `tasks/<slug>/evidence/`.

## Spec Mode

Before the target design, write the **Design Premises**: what must be true about reality for the design to work, and how each claim was confirmed (`measured`, `call-path-traced`, `code-read`, or `assumed`). Do not upgrade a class you did not earn — reading code is not a measurement. Every `assumed` premise also goes into `Open Questions` or `Rollout / Rollback`.

## Planning Mode

Use `plan-task` to turn requirements, research, and spec decisions into concrete implementation steps. Each step should be small enough to verify and carry its own `verify:` command.

Use `plan-task --parallel` only when independent lanes have disjoint write scopes and can be verified separately.

Use `plan-improve` when the existing plan needs better ordering, narrower steps, or clearer verification after implementation, testing, or review feedback.

## Implementation Mode

Implement from `tasks.md`. If the plan is wrong, update it with the reason instead of improvising silently.

For each step: write the code, run the step's `verify:` command, re-read the change against the rules, fix what you find. Do not write test files in `implement` — they are written in `write-tests`, after the review verdict.

For risky work, use small commits and run checks between phases. For refactors, follow `docs/agent-policies.md` § Refactoring Policy.

## Review Mode

`deep-review` runs **after `implement` and before `write-tests`**, once every implementation step in `tasks.md` is checked.

It is **mandatory** when any `S` or any `M` signal is present, for any pre-release review, or when three or more risk signals apply. It is **discretionary** for large diffs (>~200 LOC) without `S` / `M`, for combined `C+X` signals, for novel patterns, or when the author has reasoned doubt. When discretionary, a skip must be recorded with a reason.

Treat self-audit by the implementer as additive, not substitutive — for mandatory triggers, an independent perspective is required. Check the Spec's Design Premises against the code and history, not only the code against the spec.

Classify each finding by **severity** (`blocker | major | minor | nit`) and **disposition** (`fix-here | defer-bug | defer-tech-debt | defer-backlog | reject`). Record findings in `tasks/<slug>/review-findings.md` and the verdict in `tasks/<slug>/review-verdict.json`. Produce the verdict from the tree of the branch under review.

## Testing Mode

`write-tests` starts only when the verdict is `pass` (or when no deep-review was required). Map success criteria and invariants to tests; avoid tests that only confirm mocks.

`testing` runs the strongest practical checks for the changed area. If full checks are too expensive or unavailable, run targeted checks and report the gap. Behavioral findings deferred from review are confirmed or refuted here.

Never present skipped tests as passing tests.

Use `qa-check` for read-only Definition of Done verification. It should report status per item and avoid mutating planning state.

## Finalize Mode

`finalize` replaces separate documentation and close commands. Treat it as two phases, both on the task branch:

1. Phase 1: update docs, changelog, release notes, or knowledge artifacts affected by the task; set owner inbox markers for anything that now waits on the owner.
2. Phase 2: close the task, capture follow-ups, write `DONE.md` and `NEXT.md`, archive the workspace, and sync with the integration branch as the last step.

Before finalizing a task:

1. Confirm success criteria.
2. Confirm checks and skipped-check reasons.
3. Confirm the review verdict is `pass` when deep-review ran.
4. Move follow-ups into `BUGS.md`, `TECH-DEBT.md`, or `BACKLOG.md`.
5. Update documentation when behavior or process changed.
6. Archive the task workspace, including review artifacts and `evidence/`.
7. Add a compact `DONE.md` outcome; delete the WIP line from `NEXT.md` rather than commenting it out.

`merge` is mechanical: merge, push, delete the branch. It writes no planning files and can be handed to a cheaper model or a script.

## Stop Conditions

Stop and ask the user when requirements are unclear, the task needs slicing, security or data risk appears outside scope, a gate fails twice in a row, or merge conflicts require product judgment.

If the owner needs to do something, do not just say so in chat — put a marker in the planning entry so the owner inbox shows it.
