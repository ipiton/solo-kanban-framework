# Solo Kanban Workflow

This document defines the default Solo Kanban pipeline. Projects can adapt the commands and validation checks, but should keep the state model and artifacts stable.

**Version:** 1.0

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

Pipeline selection is driven by **tier**, derived from the task's Risk Profile. See `Step Matrix` below for tier rules and `docs/method.md` for the lightweight and sub-lightweight paths.

### Lightweight Tier

```text
implement -> testing -> finalize -> merge
```

Use only when Risk Profile is `none`. `requirements.md` is the single workspace artifact; no `research.md`, `Spec.md`, or `tasks.md` is required unless the change spans multiple files in non-trivial ways.

### Standard Tier

```text
start-task -> research -> spec -> plan -> implement -> write-tests -> testing -> finalize -> merge
```

Add `deploy` before `finalize` when the `R` signal is present. Research may be level 1 (mini section in requirements) when only one signal is present and findings are obvious.

### Full Tier

```text
start-task -> research -> spec -> plan -> implement -> write-tests -> testing -> deep-review -> finalize -> merge
```

Add `deploy` before `finalize` when the `R` signal is present. `deep-review` is mandatory; `finalize` cannot pass without recorded findings.

### Vertical Slicing

A task estimated above two days should be split into vertical slices regardless of tier. Each slice gets its own workspace and passes the pipeline for its own tier — a Full-tier task with three slices is three slices each going through the Full pipeline, not one bundle.

## Step Matrix

Solo Kanban selects required steps from a task's **risk profile**, not from a time estimate. Time estimates lie, especially with AI agents: a 30-minute change in auth code has different stakes than a 4-hour mechanical rename.

### Risk Signals

Each task is profiled against five binary signals:

| Signal | Code | Examples |
|---|---|---|
| Contract change | `C` | Public API, JSON wire format, DB schema, IPC, exported function signature, event payload |
| Security or permissions | `S` | Auth, RBAC, ownership checks, PII handling, secrets, supply chain |
| Migration or data integrity | `M` | Destructive migration, backfill, irreversible op, data loss potential |
| Cross-domain | `X` | Spans more than one service, screen, package, or architectural boundary |
| Runtime impact | `R` | Behavior change requiring production deploy, observability changes, performance-sensitive path |

Record the profile in `requirements.md` as a single line, for example `Risk: C R` or `Risk: none`. Adding new signals later is allowed; remove a signal only after explicit reassessment.

### Tiers

| Tier | Trigger | Required Pipeline |
|---|---|---|
| **Lightweight** | No signals. Typo, comment, dead-code removal, mechanical rename with type checks. | `implement -> testing -> finalize` |
| **Standard** | One or two signals from `{C, X, R}` only. No `S` or `M`. | `start-task -> research -> spec -> plan -> implement -> write-tests -> testing -> finalize` (add `deploy` when `R`) |
| **Full** | Any `S` or any `M`. Or three or more signals total. Or diff above approximately 200 changed lines. | `start-task -> research -> spec -> plan -> implement -> write-tests -> testing -> deep-review -> finalize` (add `deploy` when `R`) |

`S` and `M` always escalate to **Full** regardless of other signals. The reasoning is asymmetric blast radius: a security regression or a bad migration cannot be cheaply undone, while a contract change or a runtime tweak usually can.

### Type Is Secondary

The earlier `bug / feature / refactor / tech-debt / docs` axis is preserved for queueing, labeling, and reporting. It does not select required steps. A `tech-debt` task that touches migration logic is **Full**; a `feature` that adds a private internal helper is **Lightweight**.

### Size Is Scheduling, Not Gating

The classic `Small / Medium / Large` axis stays useful for *scheduling* and *slicing*: a task that cannot complete in one or two days should be split into vertical slices. It does not select required steps. A large mechanical rename can be **Lightweight**; a one-line ownership check can be **Full**.

### Examples

| Task | Profile | Tier |
|---|---|---|
| Rename internal variable across 40 files | none | Lightweight |
| Add new field to public REST response | `C R` | Standard |
| Add ownership check to existing endpoint | `S R` | Full (S forces Full) |
| Backfill `created_at` for legacy rows | `M R` | Full (M forces Full) |
| Add new screen consuming existing API in one service | `R` | Standard |
| Refactor module boundary between two services | `C X` | Standard, escalates to Full if diff exceeds the size threshold |
| Update phrasing in user-facing error messages | `R` | Standard |

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
| Deep review complete | before finalize Phase 2, when mandatory triggers apply | findings recorded; blockers resolved; majors resolved or deferred with follow-ups |
| Docs updated | during finalize Phase 1 | public or internal docs match changed behavior |
| Planning updated | during finalize/merge | `NEXT.md`, `DONE.md`, and follow-up files reflect reality |

`qa-check` is a read-only utility for verifying the Definition of Done. It should report pass, warn, or fail per item without mutating task state.

## Deep Review

`deep-review` is an independent multi-perspective review pass. It exists because the author and the tests they wrote share the same mental model: testing checks that code matches the spec; deep review checks that the spec matches reality and that the implementer's blind spots are not also the test suite's blind spots.

### Mandatory Triggers

`deep-review` is **required** when any of these are present:

- `S` signal: security, auth, permissions, privacy, or PII;
- `M` signal: migration, backfill, data integrity, or any irreversible operation;
- pre-release review for any externally visible release;
- three or more risk signals in any combination (Full tier by signal count).

For mandatory cases, `finalize` cannot proceed until findings are recorded in the task workspace.

### Discretionary Triggers

`deep-review` is **recommended** when any of these are present, but may be skipped with a recorded reason:

- diff exceeds approximately 200 changed lines without `S` or `M` signals;
- combined `C` and `X` signals (contract change across boundaries);
- novel pattern, first-time use of a library or framework, or first-of-its-kind change in the codebase;
- the author has reasoned doubt about a non-obvious decision.

When skipped, record the skip and reason in `tasks.md` or `Spec.md` so future readers see the deliberate choice.

### Outputs

A `deep-review` run records:

1. **Findings** — actionable items, each linked to a file and line.
2. **Severity** — `blocker`, `major`, `minor`, or `nit`.
3. **Disposition** — fixed in this task, deferred to `BUGS.md`, deferred to `TECH-DEBT.md`, or rejected with reason.
4. **Skip register** — discretionary triggers consciously not run, with reason.

Blockers must be resolved before `finalize`. Majors should be resolved or explicitly deferred with a recorded follow-up. Minors and nits are at the author's discretion.

### Anti-Pattern: Self-Audit As Substitute

A self-review pass by the implementer at the end of `write-tests` or `implement` is useful — it catches incidental green tests, missing edges, and dead code — but it is *additive*, not *substitutive*. The same mind that wrote the code and tests cannot reliably challenge the assumption both of them share. Mandatory triggers exist precisely for the cases where that shared assumption has the highest cost.

## Definition Of Done

A task is done when:

1. Success criteria in `requirements.md` are satisfied or explicitly descoped.
2. Spec decisions are implemented or deviations are recorded *(Standard and Full tier only)*.
3. Tests and project checks pass, or skipped checks have a concrete reason.
4. Deep review findings are recorded and blockers resolved *(when mandatory triggers apply)*.
5. Documentation is updated when behavior, contracts, or process changed.
6. Follow-ups are recorded in `BUGS.md`, `TECH-DEBT.md`, or `BACKLOG.md`.
7. The task workspace is archived *(skip for sub-lightweight tasks that did not create a workspace)*.
8. The integration branch has a clear `DONE.md` entry.

`finalize` should deduplicate expensive documentation or knowledge-index checks when both docs and closure phases run in one invocation.

## Stop Conditions

Stop and ask for direction when:

- requirements are ambiguous enough to change the solution;
- a task is too large and needs slicing;
- a quality gate fails repeatedly;
- a security, data, or API contract change was not in scope;
- merge conflicts cannot be resolved safely;
- a required external tool is unavailable after a reasonable fallback.
