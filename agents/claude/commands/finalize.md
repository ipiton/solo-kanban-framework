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

Finalize task documentation and closure. Everything here happens **on the task branch**; `merge` only moves the result.

**Input:** `$ARGUMENTS`
- optional slug;
- optional `--phase=docs-only`;
- optional `--phase=closure-only`.

## Phase 1: Documentation

Skip only with `--phase=closure-only`.

1. Read changed files and task artifacts.
2. Update docs affected by behavior, contracts, setup, architecture, or process.
3. Update changelog or release notes if the repository uses them.
4. If anything now waits on the owner, put an owner inbox marker (`Blocked-by:`, `Waiting-on:`, `Trigger:`) in its planning entry — a note in chat is lost with the session.
5. Record docs checks or skipped reasons.

## Phase 2: Closure

Skip only with `--phase=docs-only`.

1. Confirm success criteria and Definition of Done.
2. Confirm tests/checks passed or skipped checks have explicit reasons. Do not re-run a gate that `testing` already passed on the same commit.
3. Confirm the **Deep Review gate** when deep-review ran or was required (any `S`, any `M`, pre-release, or 3+ signals per `requirements.md` Risk Profile): `tasks/<slug>/review-verdict.json` has `"gate": "pass"`. Stop if missing — do not auto-skip the gate.
4. Confirm every `assumed` design premise in `Spec.md` is resolved or carried as a risk.
5. Move review, testing, and research follow-ups into `BUGS.md`, `TECH-DEBT.md`, or `BACKLOG.md`. For a bundle, delete the parent and all member entries.
6. Add a compact outcome to `DONE.md` (current month section).
7. Delete the task's WIP line from `NEXT.md` — do not comment it out. Update `ROADMAP.md` if a milestone moved.
8. Move `tasks/<slug>/` to `tasks/archive/<slug>/`, including `review-findings.md`, `review-verdict.json`, and `evidence/`.
9. Commit closure changes.
10. Sync the task branch with the integration branch as the **last** step, so `merge` has nothing to decide. Resolve planning-file conflicts by keeping both sides' live entries; verify by comparing the sets of slugs on both sides against the result. Do a large planning cleanup as a separate commit on the task branch after the sync commit, never inside it.

## Output

Report docs changed, checks status, follow-ups captured, owner inbox markers set, archive path, sync result, and readiness for `merge`.
