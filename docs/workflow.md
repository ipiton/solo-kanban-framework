# Solo Kanban Workflow

This document defines the default Solo Kanban pipeline. Projects can adapt the commands and validation checks, but should keep the state model and artifacts stable.

**Version:** 3.0

## State Machine

Solo Kanban uses a four-phase pipeline:

```text
QUEUE
  -> DISCOVERY: start-task -> research [--grounded]
  -> DESIGN: spec -> plan [--parallel] -> [plan-improve]
  -> EXECUTION: implement -> write-tests -> [testing] -> [deep-review] -> [deploy]
  -> CLOSURE: finalize -> merge
  -> DONE
```

Core workflow verbs:

| Kind | Verbs |
|---|---|
| Core | `start-task`, `research`, `spec`, `plan`, `implement`, `write-tests`, `testing`, `finalize`, `merge` |
| Conditional | `deep-review`, `deploy` |
| Utility | `plan-improve`, `qa-check` |
| Mode flags | `research --grounded`, `plan --parallel` |

`finalize` consolidates the former documentation and close steps. It has two logical phases: Phase 1 updates docs and knowledge artifacts; Phase 2 closes the task, captures follow-ups, archives the workspace, and prepares the merge.

## States

| State | Source of truth | Transition |
|---|---|---|
| `queued` | `NEXT.md` Queue | Start task |
| `active` | `NEXT.md` WIP plus `tasks/<slug>/` | Work through pipeline |
| `blocked` | `NEXT.md` WIP with blocker note | Unblock or replace |
| `done` | archived workspace plus `DONE.md` entry | Merge/finalize |

## Default Pipeline

### Non-docs Tasks

```text
start-task -> research -> spec -> plan -> implement -> write-tests -> testing -> finalize -> merge
```

Use this for features, bugs, refactors, integrations, data changes, security changes, or runtime behavior changes.

### Docs-Only Small Tasks

```text
start-task -> research-mini -> implement -> testing -> finalize --phase=docs-only -> merge
```

Use this only when the task changes documentation without changing process, code contracts, architecture, runtime behavior, or generated artifacts.

### Large Tasks

A task estimated above two days should be split into vertical slices. Each slice gets its own task workspace and passes the normal pipeline.

## Step Matrix

| Type / Size | Small (<1d) | Medium (1-2d) | Large (>2d) |
|---|---|---|---|
| `bug` | research -> spec -> plan -> implement -> testing -> finalize | research -> spec -> plan -> implement -> write-tests -> testing -> finalize | research -> spec -> plan -> implement -> write-tests -> testing -> deep-review -> deploy -> finalize |
| `feature` | research -> spec -> plan -> implement -> write-tests -> testing -> finalize | research -> spec -> plan -> implement -> write-tests -> testing -> deploy -> finalize | research -> spec -> plan -> implement -> write-tests -> testing -> deep-review -> deploy -> finalize |
| `refactor` | research -> spec -> plan -> implement -> testing -> finalize | research -> spec -> plan -> implement -> write-tests -> testing -> finalize | research -> spec -> plan -> implement -> write-tests -> testing -> deep-review -> finalize |
| `tech-debt` | research -> spec -> plan -> implement -> testing -> finalize | research -> spec -> plan -> implement -> testing -> finalize | research -> spec -> plan -> implement -> testing -> deep-review -> finalize |
| `docs` | research -> implement -> testing -> finalize --phase=docs-only | research -> plan -> implement -> testing -> finalize | research -> plan -> implement -> testing -> finalize |

Projects can make `deep-review` and `deploy` conditional on risk. A typical `deep-review` trigger is a large diff, security-sensitive work, pre-release review, or a change spanning multiple domains. Deploy remains conditional on whether the slice affects runtime systems.

## Research Policy

Research answers questions that cannot be safely decided from memory.

| Trigger | Examples |
|---|---|
| External integration | OAuth provider, payment API, storage SDK |
| Multiple viable options | REST vs async queue, rewrite vs adapter |
| Security or permissions | Auth, RBAC, ownership, PII |
| Performance uncertainty | Cache, batch job, SLO-sensitive path |
| Infrastructure or deployment | Helm, Kubernetes, CI/CD, release process |
| Data or migration risk | Schema change, backfill, destructive migration |
| Subjective uncertainty | The right approach is not obvious |

Research levels:

| Level | Condition | Artifact | Limit |
|---|---|---|---|
| 0 | No trigger | none | n/a |
| 1 | One obvious trigger | mini section in `requirements.md` | 5 lines |
| 2 | One or two triggers needing digging | `research.md` from light template | 30 lines |
| 3 | Three or more triggers, or high-risk combination | full `research.md` | 120 lines |

If research exceeds the limit, split the task or move into specification.

`research --grounded` is a stricter mode for uncertainty-sensitive tasks. In grounded mode, claims should be tied to code, docs, logs, specs, or cited external sources; guesses should be labeled as open questions.

## Plan Iteration

`plan --parallel` can be used when independent work can safely happen in separate worktrees or agent lanes. Only use it when write scopes are disjoint and verification can be run per lane.

`plan-improve` updates an existing `tasks.md` without resetting the task. Use it when implementation or review reveals that the plan needs better sequencing, clearer verification, or narrower steps.

## Per-Step Gates

| Gate | When | Expected check |
|---|---|---|
| Branch/workspace exists | after start | branch is not the main integration branch; `tasks/<slug>/requirements.md` exists |
| Requirements exist | before spec | problem, scope, success criteria, non-goals are defined |
| Research complete | before spec | open unknowns are resolved or explicitly carried forward |
| Spec approved | before plan | target design, risks, contracts, and validation are defined |
| Plan exists | before implementation | checklist has concrete steps and verification commands |
| Tests/checks pass | before finalize Phase 2 | strongest practical checks for changed files pass |
| Docs updated | during finalize Phase 1 | public or internal docs match changed behavior |
| Planning updated | during finalize/merge | `NEXT.md`, `DONE.md`, and follow-up files reflect reality |

`qa-check` is a read-only utility for verifying the Definition of Done. It should report pass, warn, or fail per item without mutating task state.

## Deep Review

`deep-review` is a conditional multi-perspective review step. Use it when normal testing is not enough to evaluate risk:

- large diffs, for example more than about 200 changed lines;
- security, auth, permissions, privacy, or data integrity changes;
- pre-release review;
- changes spanning multiple modules, services, screens, or architectural boundaries.

Record actionable findings in the task workspace and move remaining follow-ups into `BUGS.md`, `TECH-DEBT.md`, or `BACKLOG.md` during `finalize`.

## Definition Of Done

A task is done when:

1. Success criteria in `requirements.md` are satisfied or explicitly descoped.
2. Spec decisions are implemented or deviations are recorded.
3. Tests and project checks pass, or skipped checks have a concrete reason.
4. Documentation is updated when behavior, contracts, or process changed.
5. Follow-ups are recorded in `BUGS.md`, `TECH-DEBT.md`, or `BACKLOG.md`.
6. The task workspace is archived.
7. The integration branch has a clear `DONE.md` entry.

`finalize` should deduplicate expensive documentation or knowledge-index checks when both docs and closure phases run in one invocation.

## Stop Conditions

Stop and ask for direction when:

- requirements are ambiguous enough to change the solution;
- a task is too large and needs slicing;
- a quality gate fails repeatedly;
- a security, data, or API contract change was not in scope;
- merge conflicts cannot be resolved safely;
- a required external tool is unavailable after a reasonable fallback.
