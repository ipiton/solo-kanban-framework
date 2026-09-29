# Solo Kanban Workflow

This document defines the default Solo Kanban pipeline. Projects can adapt the commands and validation checks, but should keep the state model and artifacts stable.

**Version:** 1.1

Operational policies that apply across steps (refactoring, retries, agent boundaries, discovery cost, enforcement) live in [`agent-policies.md`](agent-policies.md).

## State Machine

Solo Kanban uses a four-phase pipeline:

```text
QUEUE
  -> DISCOVERY: start-task -> research [--grounded]
  -> DESIGN: spec -> plan-task [--parallel] -> [plan-improve]
  -> EXECUTION: implement -> [deep-review] -> write-tests -> testing -> [deploy]
  -> CLOSURE: finalize -> merge
  -> DONE
```

Core workflow verbs:

| Kind | Verbs |
|---|---|
| Core | `start-task`, `research`, `spec`, `plan-task`, `implement`, `write-tests`, `testing`, `finalize`, `merge` |
| Conditional | `deep-review`, `deploy` |
| Utility | `plan-improve`, `qa-check` |
| Mode flags | `research --grounded`, `plan-task --parallel` |

`plan-task` was called `plan` in 1.0. It was renamed because `/plan` collides with a built-in command in Claude Code.

`finalize` consolidates the former documentation and close steps. It has two logical phases: Phase 1 updates docs and knowledge artifacts; Phase 2 closes the task, captures follow-ups, archives the workspace, and writes the closure records. `merge` is pure mechanics — see [Closure Model](#closure-model).

## States

| State | Source of truth | Transition |
|---|---|---|
| `queued` | `NEXT.md` Queue | Start task |
| `active` | `NEXT.md` WIP plus `tasks/<slug>/` | Work through pipeline |
| `blocked` | `NEXT.md` WIP with blocker note | Unblock or replace |
| `done` | archived workspace plus `DONE.md` entry, both on the task branch | Merge |
| `merged` | task branch merged into the integration branch and deleted | — |

## Default Pipeline

Pipeline selection is driven by **tier**, derived from the task's Risk Profile. See `Step Matrix` below for tier rules and `docs/method.md` for the lightweight and sub-lightweight paths.

### Lightweight Tier

```text
implement -> testing -> finalize -> merge
```

Use only when Risk Profile is `none`. `requirements.md` is the single workspace artifact; no `research.md`, `Spec.md`, or `tasks.md` is required unless the change spans multiple files in non-trivial ways.

### Standard Tier

```text
start-task -> research -> spec -> plan-task -> implement -> write-tests -> testing -> finalize -> merge
```

Add `deploy` before `finalize` when the `R` signal is present. Research may be level 1 (mini section in requirements) when only one signal is present and findings are obvious. When a discretionary `deep-review` runs, it takes the same slot as in Full tier: after `implement`, before `write-tests`.

### Full Tier

```text
start-task -> research -> spec -> plan-task -> implement -> deep-review -> write-tests -> testing -> finalize -> merge
```

Add `deploy` before `finalize` when the `R` signal is present. `deep-review` is mandatory, and `write-tests` does not start until its verdict is `pass`.

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
| **Standard** | One or two signals from `{C, X, R}` only. No `S` or `M`. | `start-task -> research -> spec -> plan-task -> implement -> write-tests -> testing -> finalize` (add `deploy` when `R`) |
| **Full** | Any `S` or any `M`. Or three or more signals total. Or diff above approximately 200 changed lines. | `start-task -> research -> spec -> plan-task -> implement -> deep-review -> write-tests -> testing -> finalize` (add `deploy` when `R`) |

`S` and `M` always escalate to **Full** regardless of other signals. The reasoning is asymmetric blast radius: a security regression or a bad migration cannot be cheaply undone, while a contract change or a runtime tweak usually can.

### Type Is Secondary

The `bug / feature / refactor / tech-debt / docs` axis is preserved for queueing, labeling, and reporting. It does not select required steps. A `tech-debt` task that touches migration logic is **Full**; a `feature` that adds a private internal helper is **Lightweight**.

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

### Parallel Options

When a wrong choice would be expensive (level 3 research, security or data decisions, cross-service integration, or a decision that costs more to roll back than to build), generate options with several independent agents instead of one pass. Each agent receives the same findings and one **lens**, and does not see the others' output:

| Lens | Question the agent answers |
|---|---|
| `minimal-diff` | What is the smallest change that satisfies the requirements? |
| `reuse-first` | Is there a working donor pattern in the repository for this class of problem? |
| `reversibility` | What is cheapest to roll back, and what happens on a partial failure midway? |
| `operational` | What does it cost to run: observability, diagnosis, who learns about a failure and how? |

`minimal-diff` and `reuse-first` often collapse into one answer in a mature repository — the smallest change *is* the donor. If the donor is obvious up front, replace one of them with `operational`.

The main session merges the options, not an agent. Convergence is data, not confirmation: record "3/3 lenses converged on A" as a fact, and read full convergence as "the solution space is narrow", not as proof that A is right. The most valuable output is often a lens's objection rather than its option. Option generators should run without write access.

### Evidence

`tasks/<slug>/evidence/` holds only what cannot be re-obtained from the repository: live measurements, production responses, excerpts of external pages, evaluation output. Create it only when `research.md` or the Spec's Design Premises contain a `measured` premise. Do not copy repository files into it — git already holds them.

## Plan Iteration

`plan-task --parallel` can be used when independent work can safely happen in separate worktrees or agent lanes. Only use it when write scopes are disjoint and verification can be run per lane.

`plan-improve` updates an existing `tasks.md` without resetting the task. Use it when implementation or review reveals that the plan needs better sequencing, clearer verification, or narrower steps.

## Per-Step Gates

| Gate | When | Expected check |
|---|---|---|
| Branch/workspace exists | after start | branch is not the main integration branch; `tasks/<slug>/requirements.md` exists |
| Requirements exist | before spec | problem, scope, success criteria, non-goals are defined |
| Research complete | before spec | open unknowns are resolved or explicitly carried forward |
| Spec approved | before plan-task | target design, design premises, risks, contracts, and validation are defined |
| Plan exists | before implementation | checklist has concrete steps and verification commands |
| Review verdict `pass` | before write-tests, when deep-review runs | `tasks/<slug>/review-verdict.json` has `"gate": "pass"` for the current branch |
| Tests/checks pass | before finalize Phase 2 | strongest practical checks for changed files pass |
| Docs updated | during finalize Phase 1 | public or internal docs match changed behavior |
| Planning updated | during finalize Phase 2 | `NEXT.md`, `DONE.md`, and follow-up files reflect reality on the task branch |
| Up to date | end of finalize | task branch contains the latest integration branch |

`qa-check` is a read-only utility for verifying the Definition of Done. It should report pass, warn, or fail per item without mutating task state.

## Deep Review

`deep-review` is an independent multi-perspective review pass. It exists because the author and the tests they wrote share the same mental model: testing checks that code matches the spec and that the pieces are consistent; tests written under a wrong premise confirm it instead of refuting it. Deep review brings an anchor from outside the artifact: the Spec's Design Premises, git history of the touched code, and domain checklists built from past incidents.

### Position: After Implement, Before Write-Tests

`deep-review` is a separate step, not a part of `testing`.

- **Why before `write-tests`:** a design defect found after tests exist forces rewriting both the code and the tests written for it.
- **Maturity threshold:** all implementation steps in `tasks.md` are checked. Reviewing half-built code produces findings that go stale with the code.
- **What to expect at this position:** normative and design findings — ownership, fail-open paths, layering, wrong premises. Behavioral findings that need a run to confirm are deferred to `testing`, where runs exist.

### Mandatory Triggers

`deep-review` is **required** when any of these are present:

- `S` signal: security, auth, permissions, privacy, or PII;
- `M` signal: migration, backfill, data integrity, or any irreversible operation;
- pre-release review for any externally visible release;
- three or more risk signals in any combination (Full tier by signal count).

### Discretionary Triggers

`deep-review` is **recommended** when any of these are present, but may be skipped with a recorded reason:

- diff exceeds approximately 200 changed lines without `S` or `M` signals;
- combined `C` and `X` signals (contract change across boundaries);
- novel pattern, first-time use of a library or framework, or first-of-its-kind change in the codebase;
- the author has reasoned doubt about a non-obvious decision.

When skipped, record the skip and reason in `tasks.md` or `Spec.md` so future readers see the deliberate choice.

### Outputs

A `deep-review` run records two artifacts:

1. `tasks/<slug>/review-findings.md` — human-readable findings, each with a location, **severity** (`blocker | major | minor | nit`), and **disposition** (`fix-here | defer-bug | defer-tech-debt | defer-backlog | reject`), plus a skip register for discretionary triggers consciously not run.
2. `tasks/<slug>/review-verdict.json` — the machine-readable verdict that gates the next step. See `docs/artifact-contract.md` for its schema.

### The Verdict Is An Artifact, Not A Line In A Report

The verdict takes one of three values:

| `gate` | Meaning | Next action |
|---|---|---|
| `pass` | no open `blocker`; every `major` fixed or deferred with a follow-up | proceed to `write-tests` |
| `fix_required` | open `blocker`, or `major` without disposition | fix, then re-run the review |
| `blocked` | the review itself cannot be trusted | see below |

`blocked` has two different causes with opposite remedies:

| Cause | What happened | Remedy |
|---|---|---|
| Degenerate review | reviewer is the author, the run crashed or timed out, or it returned nothing usable | re-run with a guaranteed independent reviewer |
| Wrong tree | the verdict was produced for a different branch or commit than the one being tested | re-run from the tree of the branch under review — not from the main checkout, which is where the mismatch comes from |

Neither outcome means "the code is clean".

Record the branch and commit in the verdict. A verdict for another tree must not unlock tests for this one.

The strongest form of this gate is mechanical: a pre-write hook or pre-commit check that refuses test files while the verdict is not `pass`. A rule that lives only in a command file is the weakest enforcement level — see `agent-policies.md` § Enforcement Hierarchy.

### A Step That Writes Tests Needs A Verdict Producer

If your repository enforces the verdict mechanically, every pipeline that runs `write-tests` behind the gate must also run `deep-review`: a step that is conditional on the tests cannot be *more* optional than the tests themselves, or the agent following the pipeline hits a refusal it cannot resolve. The opposite combination — mandatory review, optional tests — is legitimate. Without mechanical enforcement, Standard tier keeps `write-tests` without a review.

### Anti-Pattern: Self-Audit As Substitute

A self-review pass by the implementer at the end of `implement` is useful — it catches incidental green paths, missing edges, and dead code — but it is *additive*, not *substitutive*. The same mind that wrote the code cannot reliably challenge the assumption it is built on. Mandatory triggers exist precisely for the cases where that shared assumption has the highest cost.

## Closure Model

Closure records are written on the **task branch**, not directly on the integration branch.

```text
claim:     start-task   -> NEXT.md WIP entry, committed on the integration branch (the only direct write)
close:     finalize     -> DONE.md, NEXT.md, ROADMAP.md, archive move, all on the task branch
           finalize     -> sync the task branch with the integration branch as its last step
merge:     merge        -> mechanical: merge, push, delete branch; writes no planning files
```

Why: with worktrees, several tasks are in flight at once. Planning edits made during a task belong to that task and should arrive in the integration branch with its merge, where they can be reviewed and reverted together. The claim is the exception because other sessions must see the WIP slot is taken before the branch merges.

Because `merge` only moves commits, it can be run by a cheaper model or a script. Keep judgment — what goes into `DONE.md`, which follow-ups to open — in `finalize`.

## Definition Of Done

A task is done when:

1. Success criteria in `requirements.md` are satisfied or explicitly descoped.
2. Spec decisions are implemented or deviations are recorded *(Standard and Full tier only)*.
3. Every `assumed` design premise is resolved, or carried as a risk in `Open Questions` or `Rollout / Rollback` *(Standard and Full tier only)*.
4. Deep review verdict is `pass` *(when deep-review ran)*.
5. Tests and project checks pass, or skipped checks have a concrete reason.
6. Documentation is updated when behavior, contracts, or process changed.
7. Follow-ups are recorded in `BUGS.md`, `TECH-DEBT.md`, or `BACKLOG.md`.
8. The task workspace is archived *(skip for sub-lightweight tasks that did not create a workspace)*.
9. `DONE.md` has a clear entry and `NEXT.md` no longer lists the task in WIP, on the task branch.

`finalize` should deduplicate expensive documentation or knowledge-index checks when both docs and closure phases run in one invocation. Rebuilding a search index over docs belongs after the merge, on the integration branch, so that it indexes what actually landed.

## Stop Conditions

Stop and ask for direction when:

- requirements are ambiguous enough to change the solution;
- a task is too large and needs slicing;
- a quality gate fails twice in a row — diagnose instead of retrying;
- a security, data, or API contract change was not in scope;
- merge conflicts cannot be resolved safely;
- a required external tool is unavailable after a reasonable fallback.

Stop conditions describe when the **agent** waits for the owner. When the **owner** has to act, the item goes to the owner inbox — see `docs/artifact-contract.md` § Owner Inbox.
