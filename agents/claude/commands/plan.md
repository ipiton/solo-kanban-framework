---
description: Create a Solo Kanban implementation checklist.
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Bash
  - AskUserQuestion
user-invocable: true
---

# Plan

Turn requirements, research, and spec into a concrete implementation checklist.

**Input:** `$ARGUMENTS`
- optional slug;
- optional `--parallel` when independent write scopes can be split.

## Context

Read `requirements.md`, `research.md` if present, `Spec.md` when required, workflow policy, artifact contract, and `tasks/templates/tasks.md`.

## Steps

1. Confirm prerequisites: requirements, research decision, and spec for non-docs tasks.
2. Identify touched files and verification commands.
3. Split work into phases that produce verifiable progress.
4. Use numbered checklist items such as `1.1`, `1.2`.
5. Add inline metadata for `verify`, `depends`, and `mode` when useful.
6. Include docs, tests, and finalization tasks.
7. If `--parallel`, define disjoint write scopes and separate verification per lane.

## Output

Write or update `tasks/<slug>/tasks.md`.

Stop if the task is larger than two days and not sliced.
