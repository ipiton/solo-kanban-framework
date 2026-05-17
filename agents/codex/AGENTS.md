# Solo Kanban Agent Instructions

Use these instructions as a starting point for repositories that adopt Solo Kanban.

For a fuller Codex integration, copy the skill folders from `agents/codex/skills/*` into the repository's Codex skills location and keep this file as the lightweight baseline.

## Workflow

- Read repository instructions before coding.
- Read planning state before selecting or changing work.
- Use `NEXT.md` as the source of truth for Queue and WIP.
- Use `tasks/<slug>/` as the source of truth for active task scope.
- Keep WIP at one primary task plus one urgent fix at most.
- Do not work directly on the main integration branch unless explicitly asked.

Pipeline is selected by **tier** (derived from the Risk Profile in `requirements.md`). See `docs/workflow.md` `Step Matrix` for full rules.

```text
Lightweight: implement -> testing -> finalize
Standard:    start-task -> research -> spec -> plan -> implement -> write-tests -> testing -> finalize
Full:        start-task -> research -> spec -> plan -> implement -> write-tests -> testing -> deep-review -> finalize
```

Add `deploy` before `finalize` when the `R` signal is present. `deep-review` is mandatory for any `S`, any `M`, pre-release, or 3+ signals.

Use `research --grounded` for evidence-only uncertainty checks. Use `plan --parallel` only when write scopes are disjoint. Use `plan-improve` to refine an existing implementation checklist without restarting the task. Use `qa-check` for read-only Definition of Done verification.

## Task Artifacts

Expected active workspace:

- `tasks/<slug>/requirements.md` — includes the Risk Profile
- `tasks/<slug>/research.md` when research level requires it
- `tasks/<slug>/Spec.md` for Standard and Full tier tasks
- `tasks/<slug>/tasks.md` before implementation
- `tasks/<slug>/review-findings.md` when `deep-review` runs

Completed workspaces move to `tasks/archive/<slug>/`.

## Before Implementation

1. Confirm requirements, success criteria, non-goals, and constraints.
2. Check whether research is required.
3. Confirm or write the spec when the task changes runtime behavior, contracts, data, security, or integration boundaries.
4. Create or update the implementation checklist.

## Validation

Run the strongest practical checks for changed code. Report skipped checks with reasons.

## Finalize

`finalize` has two phases:

1. Update documentation or knowledge artifacts affected by the task.
2. Capture follow-ups, archive `tasks/<slug>/`, update planning state, and prepare merge.

## Final Response

Summarize:

- what changed;
- how it was verified;
- risks, skipped checks, or follow-ups.
