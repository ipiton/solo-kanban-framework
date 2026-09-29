---
name: solo-kanban-planning
description: Use for Solo Kanban discovery and design steps: start-task, research, spec, plan-task, and plan-improve.
---

# Solo Kanban Planning

Use with `solo-kanban-core`.

## Steps Covered

- `start-task`
- `research [--grounded]`
- `spec`
- `plan-task [--parallel]`
- `plan-improve`

## Start Task

1. Read planning state, WIP, and the owner inbox. An unblocked owner action outranks Queue position 1.
2. Select from Queue or use the user's explicit task. A `*-BUNDLE` slug starts its members as phases of one task.
3. Check duplicates in active and archived task workspaces and in the closure journal with its archives.
4. Move task to WIP and commit the claim on the integration branch (planning files only). Delete the Queue line.
5. Create branch or worktree if repository policy expects it.
6. Create `tasks/<slug>/requirements.md` from template.
7. Classify the **Risk Profile**: signals from `{C, S, M, X, R}` and derived tier `{Lightweight, Standard, Full}`. See `docs/workflow.md` `Step Matrix`.
8. Decide research level. Research triggers overlap with risk signals — one or more signals usually implies level 2 or 3.

## Research

Research triggers: external integration, multiple options, security, performance, infrastructure, data migration, or uncertainty. These overlap with risk signals; a task with any `S` / `M` signal almost always needs at least level 2 research.

Use `--grounded` when claims must be evidence-backed. Separate facts, assumptions, and open questions.

When a wrong choice is expensive, generate options with independent read-only agents, one lens each (`minimal-diff`, `reuse-first`, `reversibility`, `operational`). Merge them yourself; record convergence as an observation, not a confirmation.

Store raw measured data in `tasks/<slug>/evidence/`.

Output: mini section in requirements, light `research.md`, or full `research.md`.

## Spec

Required for Standard and Full tier tasks. Start with **Design Premises**: statements about reality the design depends on, each classed `measured` / `call-path-traced` / `code-read` / `assumed`; every `assumed` premise also goes to Open Questions or Rollout / Rollback. Then capture target design, contracts, data changes, security, invariants, edge cases, impact, rollout/rollback, observability, **deep review decision**, and open questions.

In the Deep Review section, record mandatory triggers (`S`, `M`, pre-release, 3+ signals) and discretionary triggers (large diff without S/M, `C+X`, novel pattern, author doubt). Decision must be one of: `required` / `recommended, will run` / `recommended, skipped (reason: ...)` / `not applicable`.

If spec work reveals new signals, update `requirements.md` Risk Profile before continuing — tier may escalate.

## Plan Task

Create `tasks.md` with phases, numbered steps, touched files, verification commands, dependencies, tests, docs, and Definition of Done. Every step gets a `verify:` command. Do not prescribe test-first modes; put test steps in a phase after implementation.

Use `--parallel` only when write scopes are disjoint and each lane can be verified independently.

## Plan Improve

Refine the existing plan without resetting completed work. Preserve completed items, split vague steps, add missing verification, and record why the plan changed.
