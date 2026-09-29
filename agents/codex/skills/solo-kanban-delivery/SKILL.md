---
name: solo-kanban-delivery
description: Use for Solo Kanban execution steps: implement, write-tests, testing, deep-review, deploy, and qa-check.
---

# Solo Kanban Delivery

Use with `solo-kanban-core`.

## Steps Covered

- `implement`
- `deep-review`
- `write-tests`
- `testing`
- `deploy`
- `qa-check`

## Implement

Read requirements, research, spec, and tasks first. Implement from `tasks.md`, keep diffs scoped, run each step's `verify:` command, update checklist status, and record deviations from the spec. Do not write test files here. For refactors, change no behavior and keep one change type per branch.

## Write Tests

Start only when `tasks/<slug>/review-verdict.json` says `"gate": "pass"` for the current branch, or when deep-review was not required. Map success criteria, invariants, and deferred behavioral review findings to tests. Add focused tests using repository conventions. Avoid tests that only confirm mocks or implementation details.

## Testing

Run the strongest practical checks for changed files. Report skipped checks with reasons. Confirm or refute behavioral findings that deep-review deferred to testing. After two failures in a row, stop and diagnose.

## Deep Review

Independent review pass **after implement, before write-tests**, once every implementation step is checked. Testing checks that code matches the spec; deep review checks that the spec matches reality — Design Premises, git history, domain checklists — so the implementer's blind spots are not also the test suite's.

**Mandatory** (write-tests blocked until the verdict is `pass`):
- `S` signal: security, auth, permissions, privacy, PII;
- `M` signal: migration, backfill, data integrity, irreversible op;
- pre-release for any externally visible release;
- 3+ risk signals in any combination.

**Discretionary** (skip allowed with recorded reason):
- diff above ~200 LOC without S/M;
- combined `C+X`;
- novel pattern or first-time library use;
- author's reasoned doubt.

Pick review lenses from the present signals: `S` → auth/secrets/input validation, `M` → migration safety/reversibility, `C` → wire format/version compat, `X` → cross-boundary invariants, `R` → observability/rollout. Always include correctness, tests adequacy, and maintainability.

Classify each finding by **severity** (`blocker` | `major` | `minor` | `nit`) and **disposition** (`fix-here` | `defer-bug` | `defer-tech-debt` | `defer-backlog` | `reject`). Record in `tasks/<slug>/review-findings.md`, and write `tasks/<slug>/review-verdict.json` with `gate` = `pass` | `fix_required` | `blocked` plus the reviewed branch and commit. Run it from the reviewed branch's tree. `blocked` means either a degenerate review (re-run with an independent reviewer) or a verdict for the wrong tree (re-run from the right tree) — never "clean". Self-audit by the implementer is additive, not substitutive — for mandatory triggers, an independent perspective is required.

## Deploy

Only when runtime verification is required. Follow local repository deployment policy, confirm target environment when needed, record rollout and rollback notes.

## QA Check

Read-only Definition of Done verification. Report pass, warn, or fail per item and recommend the next command.
