# Artifact Contract

This contract defines the files Solo Kanban expects. Paths are examples; projects may place planning files elsewhere if agent instructions point to the chosen locations.

**Status:** canonical  
**Version:** 1.1  
**Last reviewed:** 2026-09-29  
**Next review:** quarterly, or ad hoc when workflow phases, templates, or artifact fields change.  
**Update policy:** update body content in place for template or workflow changes; treat the bug vs tech-debt boundary as a stable policy that should change only with deliberate review.

## Source Of Truth Layers

| Layer | Example path | Role |
|---|---|---|
| Policy | `docs/workflow.md` | State machine, gates, stop conditions |
| Agent policies | `docs/agent-policies.md` | Refactoring, retries, boundaries, discovery cost, enforcement |
| Artifact contract | `docs/artifact-contract.md` | File formats and required sections |
| Templates | `tasks/templates/*.md` | Copyable task workspace templates |
| State | `docs/planning/*.md` | Queue, WIP, done log, bugs, debt, backlog, decisions |
| Workspace | `tasks/<slug>/*.md` | Scope, research, spec, implementation checklist |

If a command and a template disagree: the workflow policy wins for transitions, this contract for formats, and the template for the concrete skeleton.

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
| `requirements.md` | always | Problem, user value, scope, success criteria, non-goals, Risk Profile |
| `research.md` | research level 2 or 3 | Facts, options, decision, spec inputs |
| `Spec.md` or `spec.md` | Standard and Full tier | Design premises, target design, contracts, risks, rollout, validation |
| `tasks.md` | before implementation | Concrete implementation checklist with verification |
| `review-findings.md` | when `deep-review` runs | Findings with severity and disposition |
| `review-verdict.json` | when `deep-review` runs | Machine-readable gate for `write-tests` |
| `evidence/` | when a premise is `measured` | Data that cannot be re-obtained from the repository |

Completed task workspaces move to `tasks/archive/<slug>/`, including review artifacts and `evidence/`.

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

Old task folders do not need a mass rewrite. Bring an artifact to the current format the next time you change it.

## `requirements.md`

Purpose: capture what problem is being solved and how success will be checked.

Required sections:

1. `Problem Framing`
2. `Risk Profile`
3. `User Stories`
4. `Success Criteria`
5. `Non-Goals`
6. `Constraints`
7. `Discovery Notes`
8. `Research (mini)` only for level 1 research

Success criteria should be checkboxes. Non-goals are required because they prevent scope expansion.

## `research.md`

Purpose: answer unknowns that block a safe design decision.

Full research sections:

1. `TL;DR`
2. `Questions`
3. `Findings`
4. `Options` — with a `Generation:` line: `single-pass` or `parallel (<lenses>)`
5. `Decision`
6. `Spec Inputs`
7. `References`

Findings should be facts with references to code, docs, issues, specs, or external sources. Options should be viable choices, not strawman alternatives. When options were generated in parallel, record convergence as an observation ("2/3 lenses converged on A"), not as confirmation.

## `Spec.md`

Purpose: define the target design before implementation.

Required sections for non-trivial code tasks:

1. `Summary`
2. `Requirements Coverage`
3. `Current State`
4. `Design Premises`
5. `Target Design`
6. `API Contracts`, if applicable
7. `Data Model / Migrations`, if applicable
8. `Component Architecture`
9. `Security Design`
10. `Invariants`
11. `Edge Cases`
12. `Impact Analysis`
13. `Rollout / Rollback`
14. `Observability`
15. `Deep Review`
16. `Open Questions`

### Design Premises

Statements about **reality** that the target design depends on: data distribution, number of consumers of a structure, event frequency, behavior of an adjacent service. Not "what we will build", but "what must be true, or the design does not work".

The difference from `Open Questions`: there, the author knows what they do not know. Here, the author believes something is known but may never have checked it. That is where the expensive defects hide.

| Premise | Confirmed by | Class | If wrong |
|---|---|---|---|
| <statement about data, consumers, frequency> | <measurement, file:line, grep, production log> | `measured` / `call-path-traced` / `code-read` / `assumed` | <what breaks> |

The class vocabulary is closed:

- **`measured`** — a number from production or the database, with the sampling window. Store the raw data in `evidence/`.
- **`call-path-traced`** — all consumers were found by searching the **whole** repository, not one service.
- **`code-read`** — derived from reading code. A weak class for claims about runtime behavior.
- **`assumed`** — not checked. Every `assumed` premise must also appear in `Open Questions` or in `Rollout / Rollback` as a risk with a rollback plan.

Allowed spellings are qualifications and revisions of these four, for example `measured (window 07-12…08-04)`, `code-read + measured`, `~~assumed~~ → measured`, or `~~measured~~ → refuted`. A class column that names none of the four is a format error; if you can, check it with a script rather than by eye.

An empty premises table is acceptable only for docs-only tasks.

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
- [ ] **1.1** Add ownership filter to `ListDocuments` <!-- verify: go vet ./internal/documents/... -->
```

Supported metadata keys:

| Key | Meaning |
|---|---|
| `verify` | command or manual check for the step; the oracle that the step is done, ideally under 60 seconds |
| `depends` | prerequisite step ids |

Wave markers (`> **Wave 1** - independent steps`) are allowed only when the steps are truly independent and do not write the same files.

The `mode: tdd | contract-first` key from 1.0 is removed. Test files are written in `write-tests`, after the review verdict; a per-step mode that prescribes writing a test first contradicts that order. Test steps may still appear in `tasks.md` — they are executed in `write-tests`.

## `review-verdict.json`

Written by `deep-review`, read by `write-tests` and `qa-check`.

```json
{
  "gate": "pass",
  "reason": null,
  "branch": "feature/billing-checkout-s1",
  "commit": "3f2c1ab",
  "reviewed_at": "2026-09-29",
  "findings": { "blocker": 0, "major": 1, "minor": 3, "nit": 2 },
  "open": { "blocker": 0, "major_without_disposition": 0 }
}
```

| Field | Values |
|---|---|
| `gate` | `pass` \| `fix_required` \| `blocked` |
| `reason` | `null` for `pass`; for `blocked`, one of `degenerate_review` or `tree_mismatch`; free text for `fix_required` |
| `branch`, `commit` | the tree that was reviewed; a verdict for another tree does not unlock this one |

Produce the verdict with a script when possible, so the rule for `pass` lives in one place and the exit code mirrors the gate.

## Planning Files

Planning files do not replace task workspaces. They route and summarize work.

| File | Stores | Does not store |
|---|---|---|
| `NEXT.md` | Queue, WIP, and the flow rules (WIP limit, replenishment, balance) | Full specifications; history of closed items |
| `DONE.md` | Closed slices and outcomes of the **current month** | Unfinished plans; past months (they are in `archive/`) |
| `BUGS.md` | Broken behavior | Ideas or maintainability concerns |
| `TECH-DEBT.md` | Working but risky implementation | Reproducible defects |
| `BACKLOG.md` | Future ideas | Urgent bugs |
| `DECISIONS.md` | Durable decisions and trade-offs of the **current month** | Daily notes; past months (they are in `archive/`) |
| `ROADMAP.md` | Strategic streams | Task-level checklists |

### Bug Versus Tech Debt

- **Bug** — the code breaks a contract it promises: a security policy (a private endpoint open without auth), an ownership filter (other users' data leaks), a schema constraint that blocks a legitimate case, a test suite or CI that does not do its job, failing tests. The symptom reads as "this must not happen".
- **Tech debt** — the code works to its contract, but the implementation is costly: a god object, duplication, missing tests for working code, a fat interface, a missing metric. The symptom reads as "it works, but it hurts to maintain".
- **Boundary:** a security gap is a bug even if no exploit was observed — the promised "private" or "owned" contract is broken. Skipped tests with a TODO are a bug. A missing test for working code is tech debt.

### Entry Format

`BUGS.md` and `TECH-DEBT.md` share one entry format:

```markdown
### [priority][area][estimate] SLUG

- **Title:** short title
- **Problem:** what is broken or costly
- **Impact:** who or what is affected
- **Fix:** likely direction
- **Refs:** code, issue, task, or review links
- **Status:** open | in-progress | blocked
```

Keep the slug greppable: one entry, one heading.

### Live State: Remove, Don't Comment Out

When an entry is closed or withdrawn, **delete its line**. The account of what happened lives in `DONE.md`; the history lives in git.

Do not wrap closed entries in HTML comments. A comment is not an archive: comments accumulate into most of the file's weight, readers and scripts still pay for them, and line-based parsers that do not strip comments see dead entries as live ones.

A comment in a planning file has three different roles; the rule covers only the first:

| Role | Example | What to do |
|---|---|---|
| Archive of a removed entry | closed queue item, recalculated balance, claim note | delete the line; the account goes to `DONE.md` |
| Functional anchor | start/end markers a command uses to cut a section | never touch — it is markup, not text |
| Evidence of a lesson | "previous wording kept so the lesson is not lost" | keep only if the lesson is not already recorded in `DONE.md` |

Do not do a large cleanup inside a merge commit — including the sync merge at the end of `finalize`. Merge first, taking the full version of the planning file, then apply the cleanup as a separate commit on the task branch, so the truncation is visible in ordinary history.

### Journal Rotation

`DONE.md` and `DECISIONS.md` keep only the **current month**. When the month changes, move past entries to `archive/DONE-YYYY-MM.md` and `archive/DECISIONS-YYYY-MM.md`; collapse past years into one file per year. Add a line to the table of contents at the top of `DONE.md`.

- **Give rotation an owner and a trigger**, for example the weekly or monthly review. Unowned rotation silently falls months behind.
- **Split by the date of each entry, not by line ranges.** Months in a decisions journal are not contiguous in practice; a "first N lines are live" cut takes other months with it, and the loss is silent.
- **Read journals through one accessor, not by path.** Anything that asks "was this slug closed?" must search the current file **and** all archives. After a rotation empties `DONE.md`, a check that reads only that file returns a false "not found" — and a gate built on it turns green while its real violations remain. A small script that takes a journal kind (`closures`, `decisions`, `bugs`, …) and distinguishes "not found" from "could not read" by exit code is enough.
- Do not narrow a consumer's window to "the last N archives". Reading the full history is cheap.

### Bundles

When several small `TECH-DEBT.md` or `BUGS.md` entries touch the same subsystem (the same files), group them into a **bundle**: one claimable parent that carries the batch. One pipeline pass — one branch, one `testing`, one `finalize` — instead of N separate claims that each reload the subsystem context.

Format, in a `## Bundles` section of `TECH-DEBT.md`:

```markdown
### AREA-CLEANUP-BUNDLE

- [high][Platform][~1d] AREA-CLEANUP-BUNDLE
- **Combined verify:** <one command; exit 0 means the whole batch is done>
- **Members (ordered):**
  - [ ] MEMBER-SLUG-ONE
  - [ ] MEMBER-SLUG-TWO
```

- Full `Problem` / `Fix` / `Refs` stay in the members' own entries; the parent does not duplicate them.
- The parent's priority is the maximum of its members.
- Only the bundle slug goes into the `NEXT.md` Queue. `start-task` creates one branch and one `tasks.md` whose phases are the members, each with its own `verify`.
- On closure, delete the parent and all member entries, and write one `DONE.md` line listing the closed slugs.
- A member can still be taken alone — a bundle is a context optimization, not a lock. Remove it from the parent's list if you do.

### Owner Inbox

Everything waiting for the **owner's** action — not the agent's — is a view over marker lines, not a separate file. Entries stay in their source file; the inbox is a grep.

An entry is an owner action item if at least one marker is present:

| Marker | Where | Example |
|---|---|---|
| `Trigger: owner ready` | tail of a Queue or backlog entry | `Trigger: owner ready.` |
| `Blocked-by: <external party>` | own line in the entry | `Blocked-by: payment provider approval` |
| estimate contains `owner action` | entry heading | `[low][Ops][~10min owner action] SLUG` |
| `Status: blocked` with a blocker outside the agent's reach | contract field | `Status: blocked` |
| `Waiting-on: <event or date>` | own line in the entry | `Waiting-on: production data, check 2026-10-15` |

`Waiting-on:` is the opposite of a blocker on the "whose hands" axis: the obligation is alive, but the owner cannot unblock it by acting. List it, but do not count it as an unblocked item.

The marker must stand in its position — in the heading's bracket prefix or at the start of its own line. A marker buried in prose is invisible to the detector; keep one detection script, not three copies of a grep.

Lifecycle:

| Event | Action |
|---|---|
| A task needs owner action | add a marker, at the latest in `finalize` Phase 1 |
| A task is deferred on the owner or a third party | move it to `BACKLOG.md` with `Blocked-by:` and `Status: blocked` |
| The owner acted | re-claim with `start-task`, or run `finalize` if the action was the closure |
| More than 5 unblocked items | stop pulling new roadmap work until the inbox is back to 5 or fewer |
| An item waits more than 14 days | the periodic review re-decides it: keep waiting, drop, or escalate |

Read the inbox at `start-task` before choosing from the Queue — an unblocked owner action blocks someone else's downstream work — and in the periodic review.

## Completion Rules

The default pipeline tail is:

```text
finalize -> merge -> done
```

`finalize` has two logical phases:

| Phase | Purpose |
|---|---|
| Phase 1: docs | update documentation, release notes, knowledge artifacts, or project docs affected by the task; set owner inbox markers |
| Phase 2: closure | confirm checks, capture follow-ups, write `DONE.md` / `NEXT.md` / `ROADMAP.md`, archive the workspace, sync with the integration branch |

Before `finalize` Phase 1:

- `tasks.md` reflects real progress.
- Deviations from `Spec.md` are recorded in `Spec.md` or `tasks.md`.
- Verification from the Definition of Done is complete, or skipped checks have explicit reasons.
- Follow-ups from research, review, and testing are moved to `BUGS.md`, `TECH-DEBT.md`, or `BACKLOG.md`.

During `finalize` Phase 2, on the task branch:

- `DONE.md` receives a compact outcome.
- `NEXT.md` is cleared of the completed WIP task.
- `tasks/<slug>/` moves to `tasks/archive/<slug>/`.
- The branch is synced with the integration branch as the last step.

Before `merge`:

- closure has run on the task branch;
- the branch is up to date with the integration branch;
- quality gates have passed or the remaining risk is explicitly accepted.

`merge` writes no planning files.

**Invariant worth checking by script:** if a slug appears in the closure journal (current file plus archives), its workspace must be in `tasks/archive/<slug>/`, not in `tasks/<slug>/`. A violation means closure skipped the archive move.
