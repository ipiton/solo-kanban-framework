# Artifact Contract

This contract defines the files Solo Kanban expects. Paths are examples; projects may place planning files elsewhere if agent instructions point to the chosen locations.

**Status:** canonical  
**Last reviewed:** 2026-05-17  
**Next review:** quarterly, or ad hoc when workflow phases, templates, or artifact fields change.  
**Update policy:** update body content in place for template or workflow changes; treat the bug vs tech-debt boundary as a stable policy that should change only with deliberate review.

## Source Of Truth Layers

| Layer | Example path | Role |
|---|---|---|
| Policy | `docs/workflow.md` | State machine, gates, stop conditions |
| Artifact contract | `docs/artifact-contract.md` | File formats and required sections |
| Templates | `tasks/templates/*.md` | Copyable task workspace templates |
| State | `docs/planning/*.md` | Queue, WIP, done log, bugs, debt, backlog, decisions |
| Workspace | `tasks/<slug>/*.md` | Scope, research, spec, implementation checklist |

## Terms

| Term | Format | Example |
|---|---|---|
| `id` | uppercase identifier, optional | `BILLING-CHECKOUT-S1` |
| `slug` | lowercase kebab-case | `billing-checkout-s1` |
| `stream` | project-defined area | `Platform`, `UX`, `Docs` |
| `type` | `bug`, `feature`, `refactor`, `tech-debt`, `docs`, `hotfix` | `feature` |
| `priority` | `critical`, `high`, `medium`, `low` | `high` |
| `status` | `draft`, `active`, `blocked`, `ready`, `complete`, `archived` | `active` |

## Task Workspace

Each active task lives in `tasks/<slug>/`.

| File | Required when | Purpose |
|---|---|---|
| `requirements.md` | always | Problem, user value, scope, success criteria, non-goals |
| `research.md` | research level 2 or 3 | Facts, options, decision, spec inputs |
| `Spec.md` or `spec.md` | non-trivial non-docs tasks | Target design, contracts, risks, rollout, validation |
| `tasks.md` | before implementation | Concrete implementation checklist with verification |

Completed task workspaces move to `tasks/archive/<slug>/`.

## Frontmatter

Task artifacts should start with YAML frontmatter:

```yaml
---
id: <TASK-ID>
slug: <slug>
stream: <stream>
type: <bug|feature|refactor|tech-debt|docs|hotfix>
priority: <critical|high|medium|low>
status: <draft|active|blocked|ready|complete|archived>
created_at: YYYY-MM-DD
updated_at: YYYY-MM-DD
---
```

Optional fields:

```yaml
owner: <person-or-agent>
branch: <branch-name>
based_on:
  - requirements.md
  - research.md
```

## `requirements.md`

Purpose: capture what problem is being solved and how success will be checked.

Required sections:

1. `Problem Framing`
2. `User Stories`
3. `Success Criteria`
4. `Non-Goals`
5. `Constraints`
6. `Discovery Notes`
7. `Research (mini)` only for level 1 research

Success criteria should be checkboxes. Non-goals are required because they prevent scope expansion.

## `research.md`

Purpose: answer unknowns that block a safe design decision.

Full research sections:

1. `TL;DR`
2. `Questions`
3. `Findings`
4. `Options`
5. `Decision`
6. `Spec Inputs`
7. `References`

Findings should be facts with references to code, docs, issues, specs, or external sources. Options should be viable choices, not strawman alternatives.

## `Spec.md`

Purpose: define the target design before implementation.

Required sections for non-trivial code tasks:

1. `Summary`
2. `Requirements Coverage`
3. `Current State`
4. `Target Design`
5. `API Contracts`, if applicable
6. `Data Model / Migrations`, if applicable
7. `Component Architecture`
8. `Security Design`
9. `Invariants`
10. `Edge Cases`
11. `Impact Analysis`
12. `Rollout / Rollback`
13. `Observability`
14. `Open Questions`

## `tasks.md`

Purpose: give the implementer a concrete, verifiable checklist.

Required sections:

1. `Touched Files`
2. `Phase N`
3. numbered checklist steps such as `1.1`, `1.2`
4. phase verification command or manual check
5. `Definition of Done`

Each step should include verification metadata when practical:

```markdown
- [ ] **1.1** Add ownership filter test <!-- mode: tdd | verify: go test -run TestOwnership ./path/... -->
```

Supported metadata keys:

| Key | Meaning |
|---|---|
| `verify` | command or manual check for the step |
| `depends` | prerequisite step ids |
| `mode` | `tdd`, `contract-first`, `default`, or project-defined mode |

## Planning Files

Planning files do not replace task workspaces. They route and summarize work.

| File | Stores | Does not store |
|---|---|---|
| `NEXT.md` | Queue and WIP | Full specifications |
| `DONE.md` | Closed slices and outcomes | Unfinished plans |
| `BUGS.md` | Broken behavior | Ideas or maintainability concerns |
| `TECH-DEBT.md` | Working but risky implementation | Reproducible defects |
| `BACKLOG.md` | Future ideas | Urgent bugs |
| `DECISIONS.md` | Durable decisions and trade-offs | Daily notes |
| `ROADMAP.md` | Strategic streams | Task-level checklists |

## Completion Rules

The default pipeline tail is:

```text
finalize -> merge -> done
```

`finalize` has two logical phases:

| Phase | Purpose |
|---|---|
| Phase 1: docs | update documentation, release notes, knowledge artifacts, or project docs affected by the task |
| Phase 2: closure | confirm checks, capture follow-ups, archive the workspace, and prepare the merge |

Before `finalize` Phase 1:

- `tasks.md` reflects real progress.
- Deviations from `Spec.md` are recorded in `Spec.md` or `tasks.md`.
- Verification from the Definition of Done is complete, or skipped checks have explicit reasons.
- Follow-ups from research, review, and testing are moved to `BUGS.md`, `TECH-DEBT.md`, or `BACKLOG.md`.

During `finalize` Phase 2:

- `DONE.md` receives a compact outcome.
- `NEXT.md` is cleared of the completed WIP task.
- `tasks/<slug>/` moves to `tasks/archive/<slug>/`.

Before `merge`:

- closure has run;
- the branch is up to date with the integration branch;
- quality gates have passed or the remaining risk is explicitly accepted.
