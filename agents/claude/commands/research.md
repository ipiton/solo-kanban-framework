---
description: Produce bounded Solo Kanban research for an active task.
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Bash
  - AskUserQuestion
user-invocable: true
---

# Research

Resolve bounded unknowns before design.

**Input:** `$ARGUMENTS`
- optional slug;
- optional `--grounded` for evidence-only verification.

## Context

Read `requirements.md`, existing `research.md` if any, workflow policy, artifact contract, and relevant code/docs.

## Steps

1. Identify research triggers: external integration, multiple options, security, performance, infrastructure, data migration, or uncertainty.
2. Select research level: mini, light, or full.
3. In `--grounded` mode, attach every meaningful claim to a source: code, docs, logs, specs, issues, or cited external links.
4. Gather only enough evidence to answer the task questions.
5. Compare viable options, not strawman options.
6. Record the decision and the spec inputs.
7. Write `research.md` for light/full research, or add `Research (mini)` to `requirements.md`.

## Output

Produce or update the research artifact with:

- TL;DR;
- questions;
- findings;
- options;
- decision;
- spec inputs;
- references.

If research exceeds the limit, stop and recommend splitting the task or moving detail into `Spec.md`.
