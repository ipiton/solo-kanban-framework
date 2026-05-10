---
id: <TASK-ID>
slug: <slug>
stream: <stream>
type: <bug|feature|refactor|tech-debt|docs|hotfix>
status: active
created_at: <YYYY-MM-DD>
updated_at: <YYYY-MM-DD>
based_on:
  - requirements.md
  # - research.md
  # - Spec.md
---

# Implementation Plan: <Task Title>

**Based on:** requirements.md / research.md / Spec.md  
**Date:** <YYYY-MM-DD>

## Touched Files

- `path/to/file` - <what changes>
- `path/to/test` - <what is tested>

## Phase 1: <name>

> **Wave 1** - independent steps

- [ ] **1.1** <concrete action> <!-- mode: tdd | verify: <command or manual check> -->
- [ ] **1.2** <concrete action> <!-- verify: <command or manual check> -->

> **Wave 2** - depends on Wave 1

- [ ] **1.3** <concrete action> <!-- depends: 1.1, 1.2 | mode: contract-first | verify: <command or manual check> -->

**Phase verification:** <command or manual check>

## Phase 2: <name>

- [ ] **2.1** <concrete action> <!-- verify: <command or manual check> -->

**Phase verification:** <command or manual check>

## Definition of Done

- [ ] All steps are complete or explicitly marked blocked/skipped
- [ ] Success criteria from `requirements.md` are covered
- [ ] Contracts from `Spec.md` are implemented or deviations are recorded
- [ ] Tests for changed behavior are added or updated
- [ ] Phase checks pass
- [ ] Docs/planning are updated if behavior, contracts, or process changed
