# Claude Command Adapter Notes

Solo Kanban commands are workflow verbs, not mandatory tooling. Implement them in your AI environment however you prefer.

Recommended command semantics:

| Command | Purpose |
|---|---|
| `/start-task` | Select or create a task, move it into WIP, create `tasks/<slug>/requirements.md`, create a branch. |
| `/research [--grounded]` | Resolve bounded unknowns and produce `research.md` when required. Grounded mode requires evidence-backed claims. |
| `/spec` | Produce the target design and validation contract. |
| `/plan [--parallel]` | Produce a concrete implementation checklist. Parallel mode is for disjoint write scopes. |
| `/plan-improve` | Improve an existing `tasks.md` without restarting the task. |
| `/implement` | Execute the checklist with scoped diffs. |
| `/write-tests` | Add or update tests for changed behavior. |
| `/testing` | Run checks and record skipped validation. |
| `/deep-review` | Conditional multi-perspective review for large, sensitive, pre-release, or multi-domain changes. |
| `/deploy` | Optional project-specific runtime deployment or release verification for slices that need it. |
| `/qa-check` | Read-only Definition of Done verification. |
| `/finalize` | Update docs, capture follow-ups, archive workspace, and prepare merge. |
| `/merge-to-main` | Merge and update `DONE.md` / `NEXT.md`. |

Keep project-specific release, infrastructure, memory, or analytics commands outside the core command set.
