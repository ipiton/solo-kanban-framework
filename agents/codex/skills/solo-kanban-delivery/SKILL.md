---
name: solo-kanban-delivery
description: Use for Solo Kanban execution steps: implement, write-tests, testing, deep-review, deploy, and qa-check.
---

# Solo Kanban Delivery

Use with `solo-kanban-core`.

## Steps Covered

- `implement`
- `write-tests`
- `testing`
- `deep-review`
- `deploy`
- `qa-check`

## Implement

Read requirements, research, spec, and tasks first. Implement from `tasks.md`, keep diffs scoped, update checklist status, and record deviations from the spec.

## Write Tests

Map success criteria and invariants to tests. Add focused tests using repository conventions. Avoid tests that only confirm mocks or implementation details.

## Testing

Run the strongest practical checks for changed files. Report skipped checks with reasons. Record non-blocking findings in `tasks/<slug>/review-findings.md`.

## Deep Review

Use when diff is large, security-sensitive, pre-release, or multi-domain. Classify findings as fix, defer, or note. Fix blockers before finalize.

## Deploy

Only when runtime verification is required. Follow local repository deployment policy, confirm target environment when needed, record rollout and rollback notes.

## QA Check

Read-only Definition of Done verification. Report pass, warn, or fail per item and recommend the next command.
