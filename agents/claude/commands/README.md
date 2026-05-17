# Claude Command Adapters

Solo Kanban commands are workflow verbs. This directory contains generic Claude command files that can be copied into a repository and adapted to local paths, branch policy, and validation commands.

Command files:

| File | Purpose |
|---|---|
| `start-task.md` | Select or create a task, move it into WIP, create `tasks/<slug>/requirements.md`, create a branch. |
| `research.md` | Resolve bounded unknowns and produce `research.md` when required. Supports `--grounded`. |
| `spec.md` | Produce the target design and validation contract. |
| `plan.md` | Produce a concrete implementation checklist. Supports `--parallel`. |
| `plan-improve.md` | Improve an existing `tasks.md` without restarting the task. |
| `implement.md` | Execute the checklist with scoped diffs. |
| `write-tests.md` | Add or update tests for changed behavior. |
| `testing.md` | Run checks and record skipped validation. |
| `deep-review.md` | Conditional multi-perspective review for large, sensitive, pre-release, or multi-domain changes. |
| `deploy.md` | Optional project-specific runtime deployment or release verification for slices that need it. |
| `qa-check.md` | Read-only Definition of Done verification. |
| `finalize.md` | Update docs, capture follow-ups, archive workspace, and prepare merge. |
| `merge-to-main.md` | Merge and update `DONE.md` / `NEXT.md`. |

Keep project-specific release, infrastructure, memory, or analytics commands outside the core command set.
