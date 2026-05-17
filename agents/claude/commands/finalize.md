---
description: Finalize a Solo Kanban task with documentation and closure phases.
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

# Finalize

Finalize task documentation and closure.

**Input:** `$ARGUMENTS`
- optional slug;
- optional `--phase=docs-only`;
- optional `--phase=closure-only`.

## Phase 1: Documentation

Skip only with `--phase=closure-only`.

1. Read changed files and task artifacts.
2. Update docs affected by behavior, contracts, setup, architecture, or process.
3. Update changelog or release notes if the repository uses them.
4. Record docs checks or skipped reasons.

## Phase 2: Closure

Skip only with `--phase=docs-only`.

1. Confirm success criteria and Definition of Done.
2. Confirm tests/checks passed or skipped checks have explicit reasons.
3. Confirm the **Deep Review gate** if mandatory triggers apply (any `S`, any `M`, pre-release, or 3+ signals per `requirements.md` Risk Profile). `tasks/<slug>/review-findings.md` must exist with blockers resolved and majors resolved or explicitly deferred. Stop if missing — do not auto-skip the gate.
4. Move review, testing, and research follow-ups into `BUGS.md`, `TECH-DEBT.md`, or `BACKLOG.md`.
5. Add a compact outcome to `DONE.md`.
6. Remove the task from WIP in `NEXT.md`.
7. Move `tasks/<slug>/` to `tasks/archive/<slug>/` (preserve `review-findings.md` in the archive).
8. Commit closure changes if repository policy expects it.

## Output

Report docs changed, checks status, follow-ups captured, archive path, and readiness for merge.
