# Claude Command Adapter Notes

Solo Kanban commands are workflow verbs, not mandatory tooling. Implement them in your AI environment however you prefer.

Recommended command semantics:

| Command | Purpose |
|---|---|
| `/start-task` | Select or create a task, move it into WIP, create `tasks/<slug>/requirements.md`, create a branch. |
| `/research` | Resolve bounded unknowns and produce `research.md` when required. |
| `/spec` | Produce the target design and validation contract. |
| `/plan` | Produce a concrete implementation checklist. |
| `/implement` | Execute the checklist with scoped diffs. |
| `/write-tests` | Add or update tests for changed behavior. |
| `/testing` | Run checks and record skipped validation. |
| `/write-doc` | Update docs affected by behavior, contracts, or process. |
| `/end-task` | Finalize, capture follow-ups, archive workspace. |
| `/merge-to-main` | Merge and update `DONE.md` / `NEXT.md`. |

Keep project-specific deploy, release, Kubernetes, memory, or analytics commands outside the core command set.
