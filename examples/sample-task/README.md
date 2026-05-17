# Worked Example: Add `last_login_at` to `/users/me`

This directory contains a complete, archived task workspace as it would look after closure. It illustrates the Solo Kanban artifact contract for a typical **Standard tier** task — small enough to read in one sitting, real enough to show how risk profile flows through the pipeline.

## The Task

> Backend frontend pair-up has been blocked by missing "last seen" data on user profile pages. Add a `last_login_at` timestamp to the `GET /users/me` REST response, populated from an existing column. No new column, no migration.

## Risk Profile

```
Risk: C R
```

- **C** — contract change to the `/users/me` REST response.
- **R** — runtime impact, needs a deploy for clients to see the field.
- No `S` (auth path unchanged), no `M` (no schema change or backfill), no `X` (single service).

**Tier:** `Standard` (1-2 of `{C, X, R}`, no `S` / `M`).

## Pipeline That Was Run

```text
start-task -> research -> spec -> plan -> implement -> write-tests -> testing -> deploy -> finalize
```

`deep-review` was **not triggered** — no `S`, no `M`, not pre-release, fewer than 3 signals, diff under the 200-line threshold, no `C+X` combination, and no novel pattern. The Spec records this as `not applicable`.

## Files In This Workspace

| File | Role |
|---|---|
| `requirements.md` | Problem framing, success criteria, Risk Profile. |
| `research.md` | Light research (level 2): existing timestamp field patterns. |
| `Spec.md` | Target design, contract change, deep-review decision. |
| `tasks.md` | Implementation checklist with verification commands. All boxes ticked. |
| `DONE-entry.md` | The one-paragraph entry that landed in the project's `DONE.md`. |

## How To Read This

Start with `requirements.md` to see the entry point. Then `research.md` resolves the one unknown ("are there existing timestamp patterns?"). `Spec.md` translates that into a concrete API change. `tasks.md` is the implementation checklist that drove the work. `DONE-entry.md` is the compact closure record.

This is **not** a template. The templates live in `templates/task/` and `templates/planning/`. This is a worked artifact — what those templates look like once they have content.
