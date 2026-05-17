# Solo Kanban Method

Solo Kanban is a delivery system for one developer, often working with one or more AI agents. It keeps the useful part of Kanban, a visible flow of work, and adds the explicit contracts that AI-assisted development needs.

## Problem

Solo work often loses state in chat, terminal scrollback, local notes, and half-finished branches. AI agents amplify this problem because they can move quickly while forgetting why a task exists, which files are in scope, what has already been tried, or what must be verified before merge.

Solo Kanban solves this by making work state a repository artifact.

## Principles

### One Focus

Keep WIP at one primary task. A second slot is reserved for an urgent fix only. More parallel work creates stale context and ambiguous ownership.

### Everything Important Is Versioned

Planning files, task requirements, research, specs, implementation checklists, decisions, and closure summaries live in git. Chat can help produce them, but chat is not the source of truth.

### Vertical Slices

A task that cannot be completed and merged in one or two days should be split. Each slice should produce a useful, reviewable, revertible outcome.

### Bounded Research

Research is not a rabbit hole. It answers specific unknowns, compares real options, records the decision, and feeds the spec. If research grows too large, it is probably a specification or a separate discovery task.

### Specification Before Code

For non-trivial changes, write the target design before implementation. The spec should be short enough to read, but precise enough to catch API, data, security, rollout, and observability risks.

### Gates Over Trust

Do not rely on an agent saying work is done. Completion requires checks: tests, build, lint, documentation updates, planning updates, and explicit notes for skipped validation.

### Archive Evidence

When a task closes, keep its workspace in `tasks/archive/<slug>/`. Future agents can inspect the reasoning, scope, and validation without reconstructing the work from commits alone.

## Planning Files

Solo Kanban uses small markdown files instead of a task tracker:

| File | Role |
|---|---|
| `NEXT.md` | Queue and WIP. The current source of truth for what is next and active. |
| `DONE.md` | Closed slices and verified outcomes. |
| `BUGS.md` | Broken behavior that violates an expected contract. |
| `TECH-DEBT.md` | Working behavior with poor structure, risk, or maintainability cost. |
| `BACKLOG.md` | Ideas and future product or engineering work. |
| `DECISIONS.md` | Meaningful decisions with context and trade-offs. |
| `ROADMAP.md` | Strategic direction and larger streams. |

## Bug Versus Tech Debt

A bug means the system violates its contract: incorrect behavior, failing tests, permission leaks, broken builds, or missing required behavior.

Tech debt means the system works, but the implementation creates maintainability risk: duplication, missing tests for working code, weak observability, large files, unclear ownership, or fragile abstractions.

## When To Use Less Process

Solo Kanban scales down. The fewer risk signals, the lighter the path. See `docs/workflow.md` `Step Matrix` for the signal definitions and tier rules.

### Lightweight Tasks

Tasks with no risk signals — typo fixes, comment edits, dead-code removal, mechanical renames with type-checker coverage, addition of an internal private helper — use the lightweight path:

- `requirements.md` only — Problem Framing, Success Criteria, Risk Profile = `none`. Non-Goals optional.
- No `research.md`, no `Spec.md`, no `tasks.md` unless the change spans multiple files in non-trivial ways.
- Pipeline: `implement -> testing -> finalize`.
- `finalize` Phase 1 (docs) is usually skipped explicitly with a recorded reason.

The lightweight path still keeps artifacts git-visible — it shortens them, it does not hide skipped checks.

### Sub-Lightweight Path

For changes that affect only comments, formatting, or trivially obvious typos, with zero risk of breaking the build:

- No `tasks/<slug>/` workspace.
- A one-line entry in `DONE.md` is sufficient.
- The commit message is the artifact.

This path applies only when all of these hold:

- the change cannot break any test or runtime behavior;
- the diff is small enough to review in seconds;
- no contract, schema, security, migration, observability, or cross-domain implication exists.

If any of the above is unclear, the task is at least Lightweight tier — create the workspace.

## When NOT To Use Solo Kanban

Solo Kanban is designed for one developer working with AI agents on a software product they own. It is the wrong tool for:

- **Team-scale coordination.** More than one human developer making concurrent changes needs an issue tracker with notifications, named ownership, code review SLAs, and "who is doing what right now" visibility across people. Planning files do not replace those.
- **Non-engineering work.** Marketing, sales, hiring, or strategy backlogs lack the artifact contract that makes Solo Kanban useful. Use a generic task tool.
- **Pure exploration without deliverables.** R&D where the output is "what did we learn" and there is no merge target. Use a research log or notebook.
- **One-off scripts that will not be touched again.** A throwaway data fix, a one-time backfill, a notebook converted to code. Run it, archive the file, do not create a workspace.
- **Real-time incident response.** During a live incident the priority is restoring service. Capture the postmortem with Solo Kanban *after*; do not slow down recovery with workspace creation.

If most of the work falls into these categories, Solo Kanban is the wrong tool. If only some does, treat them as exceptions, not as the workflow.
