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

# Plan Task

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
5. Give every step a `verify:` command — the oracle that the step is done — and `depends:` when order matters. Do not prescribe test-first modes: test files are written in `write-tests`, after the review verdict.
6. Include docs, tests, and finalization tasks. Put test steps in their own phase after implementation.
7. If `--parallel`, define disjoint write scopes and separate verification per lane.

## Output

Write or update `tasks/<slug>/tasks.md`.

Stop if the task is larger than two days and not sliced.
