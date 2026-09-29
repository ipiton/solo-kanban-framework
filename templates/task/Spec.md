---
id: <TASK-ID>
slug: <slug>
stream: <stream>
type: <bug|feature|refactor|tech-debt|docs|hotfix>
status: draft
created_at: <YYYY-MM-DD>
updated_at: <YYYY-MM-DD>
based_on:
  - requirements.md
  # - research.md
---

# Specification: <Task Title>

**Version:** 1.0  
**Status:** Draft

## Summary

<1-2 sentences: what changes and why.>

## Requirements Coverage

| Requirement / Criterion | Covered by |
|---|---|
| <criterion> | <section, component, or test plan> |

## Current State

- **Code:** <existing files, components, endpoints, or not applicable>
- **Data:** <tables/models or not applicable>
- **Tests:** <existing tests or not found>
- **Docs:** <relevant docs or not applicable>

## Design Premises

<!-- Statements about REALITY the target design depends on: data distribution, consumers of a
     structure, event frequency, behavior of adjacent services. Not "what we will build", but
     "what must be true, or the design does not work". An empty table is allowed only for docs-only
     tasks. See docs/artifact-contract.md `Design Premises`. -->

| Premise | Confirmed by | Class | If wrong |
|---|---|---|---|
| <statement about data, consumers, frequency> | <measurement, file:line, grep, production log> | measured / call-path-traced / code-read / assumed | <what breaks> |

- **measured** — a number from production or the database, with the sampling window; raw data in `evidence/`
- **call-path-traced** — all consumers found by searching the whole repository, not one service
- **code-read** — derived from reading code; weak for claims about runtime behavior
- **assumed** — not checked; must also appear in `Open Questions` or `Rollout / Rollback` as a risk

## Target Design

<Short explanation of the target solution. It should be explainable in 5-7 sentences.>

## API Contracts

<!-- Delete this section only when not applicable. -->

### <METHOD> <path>

- **Auth:** <public/user/admin/internal>
- **Ownership:** <rule or not applicable>
- **Request:** `<type or JSON shape>`
- **Response:** `<type or JSON shape>`
- **Errors:** <400/401/403/404/409/500 behavior>

## Data Model / Migrations

<!-- Delete this section only when not applicable. -->

### Table: <name>

| Column | Type | Constraints | Notes |
|---|---|---|---|
| <column> | <type> | <constraints> | <notes> |

- **Migration:** yes/no
- **Rollback / forward-fix:** <strategy>

## Component Architecture

- `path/to/file` - <purpose/change>

## Security Design

- [ ] Ownership validation required or explicitly not applicable
- [ ] Input validation defined
- [ ] Sensitive data not logged
- [ ] Rate limiting considered
- [ ] Auth/RBAC path defined

## Invariants

- [ ] <what must not break>
- [ ] <backward compatibility, idempotency, or fallback rule>

## Edge Cases

1. <scenario> -> <expected behavior>

## Impact Analysis

- **Affected modules:** <list>
- **Breaking changes:** none / <description>
- **New dependencies:** none / <description>
- **Risks:** <risk + mitigation>

## Rollout / Rollback

- **Rollout:** <steps or not applicable>
- **Rollback:** <steps or not applicable>
- **Feature flag:** <flag or not applicable>

## Observability

- **Logs:** <new/changed logs or not applicable>
- **Metrics:** <metrics or not applicable>
- **Alerts:** <alerts or not applicable>

## Deep Review

<!-- See docs/workflow.md `Deep Review` for trigger and output rules. When it runs, it goes after
     implement and before write-tests; the verdict lands in tasks/<slug>/review-verdict.json. -->

- **Mandatory triggers present:** <list of `S` / `M` / pre-release / 3+ signals, or "none">
- **Discretionary triggers present:** <list of large-diff / `C+X` / novel-pattern / author-doubt, or "none">
- **Decision:** <"required" | "recommended, will run" | "recommended, skipped (reason: ...)" | "not applicable">

## Open Questions

- [ ] <question or none>
