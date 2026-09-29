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
3. agent policies (`docs/agent-policies.md` or local equivalent);
4. artifact contract (`docs/artifact-contract.md` or local equivalent);
5. planning files (`NEXT.md`, `DONE.md`, `BUGS.md`, `TECH-DEBT.md`, `BACKLOG.md`, `ROADMAP.md`, `DECISIONS.md`);
6. current task workspace under `tasks/<slug>/`.

## Core Rules

- Keep WIP within the limit in `NEXT.md` § Flow Rules, default 2.
- Check the owner inbox (`Blocked-by:`, `Waiting-on:`, `Trigger:` markers) before selecting work.
- Prefer vertical slices.
- Keep planning state git-visible.
- Classify the **Risk Profile** before selecting pipeline steps. Pipeline tier (Lightweight / Standard / Full) is selected from risk signals, not from time estimate. See `docs/workflow.md` `Step Matrix`.
- Do not silently widen scope. If risk signals are discovered mid-task, update `requirements.md` Risk Profile before continuing.
- Do not hide failing gates. A gate that could not read its input is not a passing gate.
- Keep planning files live: delete closed entries instead of commenting them out.
- Read `DONE.md` and `DECISIONS.md` together with their monthly archives.
- Delegate wide searches to read-only sub-agents; use `grep` for exact tokens.
- Do not work on the integration branch unless explicitly allowed.
- Respect existing repository patterns and validation commands.

## Workspace Contract

Active task workspace:

- `tasks/<slug>/requirements.md` — includes Risk Profile
- `tasks/<slug>/research.md` when research level requires it
- `tasks/<slug>/Spec.md` for Standard and Full tier tasks (skip for Lightweight)
- `tasks/<slug>/tasks.md` before implementation
- `tasks/<slug>/review-findings.md` and `review-verdict.json` when `deep-review` runs (mandatory for Full tier with `S` / `M` / pre-release)
- `tasks/<slug>/evidence/` when a premise is `measured`

Completed task workspace:

- `tasks/archive/<slug>/`

## Planning Roles

- `NEXT.md` = Queue and WIP
- `DONE.md` = completed slices
- `BUGS.md` = broken behavior (a security gap is a bug)
- `TECH-DEBT.md` = working but risky implementation, plus bundles
- `BACKLOG.md` = future work
- `DECISIONS.md` = durable decisions (current month; past months in `archive/`)
