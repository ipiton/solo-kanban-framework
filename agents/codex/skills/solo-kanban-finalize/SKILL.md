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

Default behavior runs both phases.

### Phase 1: Documentation

Update documentation, changelog, release notes, or knowledge artifacts affected by the task. Record skipped docs checks with reasons.

### Phase 2: Closure

1. Confirm success criteria.
2. Confirm checks passed or skipped checks have explicit reasons.
3. Confirm the **Deep Review gate** if mandatory triggers apply (any `S`, any `M`, pre-release, or 3+ signals). `tasks/<slug>/review-findings.md` must exist; blockers must be resolved; majors must be resolved or deferred with a recorded follow-up.
4. Move follow-ups from research, review, and testing into `BUGS.md`, `TECH-DEBT.md`, or `BACKLOG.md`.
5. Add outcome to `DONE.md`.
6. Remove task from WIP in `NEXT.md`.
7. Move `tasks/<slug>/` to `tasks/archive/<slug>/` (include `review-findings.md` if present).
8. Commit closure changes when repository policy expects it.

## Merge

Confirm the working tree is clean, the task is finalized, and the branch is up to date with the integration branch. Merge using repository policy. Stop on unsafe conflicts.
