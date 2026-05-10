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

For tiny docs edits or mechanical cleanup, use a lightweight path: requirements, implementation, validation, documentation, close. Keep the artifacts short, but do not hide skipped checks.
