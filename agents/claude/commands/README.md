# Claude Command Adapters

Solo Kanban commands are workflow verbs. This directory contains generic Claude command files that can be copied into a repository and adapted to local paths, branch policy, and validation commands.

Command files:

| File | Purpose |
|---|---|
| `start-task.md` | Check the owner inbox, select or create a task, claim it in WIP, create `tasks/<slug>/requirements.md`, create a branch. |
| `research.md` | Resolve bounded unknowns and produce `research.md` when required. Supports `--grounded` and parallel option generation by lenses. |
| `spec.md` | Produce design premises, the target design, and the validation contract. |
| `plan-task.md` | Produce a concrete implementation checklist. Supports `--parallel`. Named `plan` in 1.0; renamed to avoid the built-in `/plan`. |
| `plan-improve.md` | Improve an existing `tasks.md` without restarting the task. |
| `implement.md` | Execute the checklist with scoped diffs. Writes no test files. |
| `write-tests.md` | Add or update tests for changed behavior, after a `pass` review verdict when deep-review applies. |
| `testing.md` | Run checks and record skipped validation. |
| `deep-review.md` | Independent review after `implement`, before `write-tests`; writes `review-findings.md` and `review-verdict.json`. Mandatory for `S` / `M` / pre-release / 3+ signals; discretionary for large diff, `C+X`, novel pattern, or author doubt. |
| `deploy.md` | Optional project-specific runtime deployment or release verification for slices that need it. |
| `qa-check.md` | Read-only Definition of Done verification. |
| `finalize.md` | On the task branch: update docs, capture follow-ups, write `DONE.md` / `NEXT.md`, archive the workspace, sync with the integration branch. |
| `merge-to-main.md` | Mechanical merge, push, and branch cleanup. Writes no planning files. |

Keep project-specific release, infrastructure, memory, or analytics commands outside the core command set.
