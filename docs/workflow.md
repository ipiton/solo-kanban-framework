# Solo Kanban Workflow

This document defines the default Solo Kanban pipeline. Projects can adapt the commands and validation checks, but should keep the state model and artifacts stable.

## State Machine

```text
QUEUE -> START -> RESEARCH -> SPEC -> PLAN -> IMPLEMENT -> WRITE-TESTS -> TESTING -> WRITE-DOC -> END-TASK -> MERGE -> DONE
              \                         \                         /
               \                         ---- optional by task ----
                ---- docs-only lightweight path -------------------
```

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
start-task -> research -> spec -> plan -> implement -> write-tests -> testing -> write-doc -> end-task -> merge
```

Use this for features, bugs, refactors, integrations, data changes, security changes, or runtime behavior changes.

### Docs-Only Small Tasks

```text
start-task -> research-mini -> implement -> testing -> write-doc -> end-task -> merge
```

Use this only when the task changes documentation without changing process, code contracts, architecture, runtime behavior, or generated artifacts.

### Large Tasks

A task estimated above two days should be split into vertical slices. Each slice gets its own task workspace and passes the normal pipeline.

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

## Per-Step Gates

| Gate | When | Expected check |
|---|---|---|
| Branch/workspace exists | after start | branch is not the main integration branch; `tasks/<slug>/requirements.md` exists |
| Requirements exist | before spec | problem, scope, success criteria, non-goals are defined |
| Research complete | before spec | open unknowns are resolved or explicitly carried forward |
| Spec approved | before plan | target design, risks, contracts, and validation are defined |
| Plan exists | before implementation | checklist has concrete steps and verification commands |
| Tests/checks pass | before close | strongest practical checks for changed files pass |
| Docs updated | before close | public or internal docs match changed behavior |
| Planning updated | during close/merge | `NEXT.md`, `DONE.md`, and follow-up files reflect reality |

## Definition Of Done

A task is done when:

1. Success criteria in `requirements.md` are satisfied or explicitly descoped.
2. Spec decisions are implemented or deviations are recorded.
3. Tests and project checks pass, or skipped checks have a concrete reason.
4. Documentation is updated when behavior, contracts, or process changed.
5. Follow-ups are recorded in `BUGS.md`, `TECH-DEBT.md`, or `BACKLOG.md`.
6. The task workspace is archived.
7. The integration branch has a clear `DONE.md` entry.

## Stop Conditions

Stop and ask for direction when:

- requirements are ambiguous enough to change the solution;
- a task is too large and needs slicing;
- a quality gate fails repeatedly;
- a security, data, or API contract change was not in scope;
- merge conflicts cannot be resolved safely;
- a required external tool is unavailable after a reasonable fallback.
