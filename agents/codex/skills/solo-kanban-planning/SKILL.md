---
name: solo-kanban-planning
description: Use for Solo Kanban discovery and design steps: start-task, research, spec, plan, and plan-improve.
---

# Solo Kanban Planning

Use with `solo-kanban-core`.

## Steps Covered

- `start-task`
- `research [--grounded]`
- `spec`
- `plan [--parallel]`
- `plan-improve`

## Start Task

1. Read planning state and WIP.
2. Select from Queue or use the user's explicit task.
3. Check duplicates in active and archived task workspaces.
4. Move task to WIP.
5. Create branch if repository policy expects it.
6. Create `tasks/<slug>/requirements.md` from template.
7. Decide research level.

## Research

Research triggers: external integration, multiple options, security, performance, infrastructure, data migration, or uncertainty.

Use `--grounded` when claims must be evidence-backed. Separate facts, assumptions, and open questions.

Output: mini section in requirements, light `research.md`, or full `research.md`.

## Spec

Required for non-trivial non-docs tasks. Capture target design, contracts, data changes, security, invariants, edge cases, impact, rollout/rollback, observability, and open questions.

## Plan

Create `tasks.md` with phases, numbered steps, touched files, verification commands, dependencies, tests, docs, and Definition of Done.

Use `--parallel` only when write scopes are disjoint and each lane can be verified independently.

## Plan Improve

Refine the existing plan without resetting completed work. Preserve completed items, split vague steps, add missing verification, and record why the plan changed.
