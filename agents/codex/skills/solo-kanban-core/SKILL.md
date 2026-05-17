---
name: solo-kanban-core
description: Use for any Solo Kanban task to load repository planning state, WIP limits, task workspace conventions, source-of-truth ordering, and guardrails.
---

# Solo Kanban Core

Use this skill before any Solo Kanban workflow step.

## Source Of Truth

Read in this order:

1. local repository instructions (`AGENTS.md`, `CLAUDE.md`, README, or equivalent);
2. workflow policy (`docs/workflow.md` or local equivalent);
3. artifact contract (`docs/artifact-contract.md` or local equivalent);
4. planning files (`NEXT.md`, `DONE.md`, `BUGS.md`, `TECH-DEBT.md`, `BACKLOG.md`, `ROADMAP.md`, `DECISIONS.md`);
5. current task workspace under `tasks/<slug>/`.

## Core Rules

- Keep WIP within the repository limit, default 2.
- Prefer vertical slices.
- Keep planning state git-visible.
- Classify the **Risk Profile** before selecting pipeline steps. Pipeline tier (Lightweight / Standard / Full) is selected from risk signals, not from time estimate. See `docs/workflow.md` `Step Matrix`.
- Do not silently widen scope. If risk signals are discovered mid-task, update `requirements.md` Risk Profile before continuing.
- Do not hide failing gates.
- Do not work on the integration branch unless explicitly allowed.
- Respect existing repository patterns and validation commands.

## Workspace Contract

Active task workspace:

- `tasks/<slug>/requirements.md` — includes Risk Profile
- `tasks/<slug>/research.md` when research level requires it
- `tasks/<slug>/Spec.md` for Standard and Full tier tasks (skip for Lightweight)
- `tasks/<slug>/tasks.md` before implementation
- `tasks/<slug>/review-findings.md` when `deep-review` runs (mandatory for Full tier with `S` / `M` / pre-release)

Completed task workspace:

- `tasks/archive/<slug>/`

## Planning Roles

- `NEXT.md` = Queue and WIP
- `DONE.md` = completed slices
- `BUGS.md` = broken behavior
- `TECH-DEBT.md` = working but risky implementation
- `BACKLOG.md` = future work
- `DECISIONS.md` = durable decisions
