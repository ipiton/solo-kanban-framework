---
id: <TASK-ID>
slug: <slug>
stream: <stream>
type: <bug|feature|refactor|tech-debt|docs|hotfix>
priority: <critical|high|medium|low>
status: active
created_at: <YYYY-MM-DD>
updated_at: <YYYY-MM-DD>
---

# Requirements: <Task Title>

## Problem Framing

- **Symptom:** <what the user, operator, or developer sees>
- **Root Cause:** <hypothesis, if known>
- **Why Now:** <why this matters now>
- **How We Measure:** <specific check or success metric>

## Risk Profile

<!-- See docs/workflow.md `Step Matrix` for signal definitions and tier rules. -->

- **Signals:** `<space-separated subset of C S M X R, or "none">`
  - `C` contract change (API, schema, wire, IPC, exported signature)
  - `S` security, auth, permissions, PII
  - `M` migration, backfill, data integrity, irreversible op
  - `X` cross-domain (more than one service, screen, package, boundary)
  - `R` runtime impact (production deploy, observability, perf-sensitive path)
- **Tier:** <Lightweight | Standard | Full>
- **Notes:** <optional 1-2 lines justifying the choice if non-obvious>

## User Stories

1. As a <role>, I want <action> so that <benefit>.

## Success Criteria

- [ ] <verifiable criterion 1>
- [ ] <verifiable criterion 2>

## Non-Goals

- <what this task explicitly does not do>

## Constraints

- **Scope:** <change boundary>
- **Security:** <auth, ownership, PII, or not applicable>
- **Compatibility:** <backward compatibility, migrations, rollout, or not applicable>

## Discovery Notes

- Similar tasks: <path or not found>
- Relevant patterns: <path or not found>
- Open unknowns: <list or none>

<!-- Optional for Research Level 1 only.
## Research (mini)

- Source: <path/link>
- Key finding: <1-3 bullets>
- Decision: <chosen direction>
-->
