---
name: solo-kanban-finalize
description: Use for Solo Kanban closure steps: finalize and merge-to-main, including docs updates, follow-up capture, archive movement, and merge readiness.
---

# Solo Kanban Finalize

Use with `solo-kanban-core`.

## Steps Covered

- `finalize [--phase=docs-only|--phase=closure-only]`
- `merge-to-main`

## Finalize

Default behavior runs both phases, on the task branch.

### Phase 1: Documentation

Update documentation, changelog, release notes, or knowledge artifacts affected by the task. Put owner inbox markers on anything that now waits on the owner. Record skipped docs checks with reasons.

### Phase 2: Closure

1. Confirm success criteria.
2. Confirm checks passed or skipped checks have explicit reasons.
3. Confirm the **Deep Review gate** when deep-review ran or was required (any `S`, any `M`, pre-release, or 3+ signals): `tasks/<slug>/review-verdict.json` says `"gate": "pass"`.
4. Confirm every `assumed` design premise is resolved or carried as a risk.
5. Move follow-ups from research, review, and testing into `BUGS.md`, `TECH-DEBT.md`, or `BACKLOG.md`. For a bundle, delete the parent and all member entries.
6. Add outcome to `DONE.md` (current month section).
7. Delete the task's WIP line from `NEXT.md` (do not comment it out). Update `ROADMAP.md` if a milestone moved.
8. Move `tasks/<slug>/` to `tasks/archive/<slug>/`, including review artifacts and `evidence/`.
9. Commit closure changes.
10. Sync the task branch with the integration branch as the last step. In planning-file conflicts keep both sides' live entries and compare slug sets against the result; do a large planning cleanup as a separate commit on the task branch after the sync commit, never inside it.

## Merge

Mechanics only: confirm the working tree is clean, the task is finalized, and the branch is up to date with the integration branch. Merge, push, and delete the branch using repository policy. Write no planning files. Stop on unsafe conflicts.
