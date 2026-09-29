# Solo Kanban

[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Version](https://img.shields.io/badge/version-1.1.0-green.svg)](CHANGELOG.md)
[![Status](https://img.shields.io/badge/status-public%20release-brightgreen.svg)](#status)

Solo Kanban is a git-native delivery framework for solo developers working with AI coding agents.

It keeps product intent, technical scope, implementation steps, validation, and closure evidence in versioned files rather than in chat history or a private task tracker.

## Why This Exists

Classic Kanban is useful for visualizing work, but it is usually under-specified for a single developer who delegates implementation to AI agents. Solo Kanban adds the missing contract:

- a tiny planning system that lives in the repository;
- one active task workspace per slice;
- explicit discovery, design, execution, and closure gates;
- WIP limits that prevent context drift;
- archived task evidence for future agents and humans.

The result is a lightweight process that gives AI agents enough structure to execute safely without turning solo work into heavyweight project management.

## Core Ideas

- **Git-visible state:** planning files, task artifacts, and decisions are committed with the code.
- **Small, explicit WIP:** one primary task plus one urgent fix by default; the limit lives in one place, `NEXT.md`.
- **Vertical slices:** any task larger than two days is split into mergeable increments.
- **Research before certainty:** risky or ambiguous work gets a bounded research artifact before implementation.
- **Specification before code:** non-trivial code changes get a short technical spec that starts with its **design premises** — what must be true about reality, and how each claim was confirmed.
- **Quality gates:** every transition has a validation expectation; the important ones sit on the seam (a hook, a check) rather than in prose.
- **Review before tests:** an independent review runs after implementation and before tests are written, and its verdict is a file that gates the next step.
- **Archive on close:** completed workspaces move to `tasks/archive/<slug>/`.

## Pipeline

```mermaid
flowchart LR
    A(start-task) --> B(research) --> C(spec) --> D(plan-task)
    D --> E(implement) --> F(write-tests) --> G(testing)
    G --> J(finalize) --> K(merge)
    E -.->|Full tier| H(deep-review) -.->|verdict: pass| F
    G -.->|R signal| I(deploy) -.-> J

    style H stroke-dasharray: 5 5
    style I stroke-dasharray: 5 5
```

The actual pipeline for a task is selected by its **tier**, derived from a Risk Profile of five signals: contract change (`C`), security (`S`), migration (`M`), cross-domain (`X`), runtime impact (`R`). See [`docs/workflow.md`](docs/workflow.md) `Step Matrix` for the full rules.

| Tier | Trigger | Pipeline |
|---|---|---|
| **Lightweight** | No signals | `implement → testing → finalize` |
| **Standard** | 1-2 of `{C, X, R}` only | full pipeline above, `deep-review` skipped |
| **Full** | any `S` / `M`, 3+ signals, or large diff | full pipeline above with `deep-review` mandatory between `implement` and `write-tests` |

`finalize` combines documentation updates and task closure on the task branch — docs, follow-ups, `DONE.md` / `NEXT.md`, archive movement, and a final sync with the integration branch. `merge` is pure mechanics and writes no planning files.

A complete worked example — every artifact filled in for one real task — lives in [`examples/sample-task/`](examples/sample-task/).

## Repository Layout

```text
solo-kanban/
  docs/                  Method, workflow, agent policies, artifact contract, agent guidance
  templates/planning/    NEXT, DONE, BUGS, TECH-DEBT, BACKLOG, DECISIONS, ROADMAP
  templates/task/        requirements, research, spec, implementation checklist
  agents/claude/commands Claude command files for the workflow verbs
  agents/codex/skills    Codex skills for core/planning/delivery/finalize
  examples/minimal/      Minimal project layout
```

## Quick Start

1. Copy `templates/planning/*.md` into your project planning directory, for example `docs/planning/`.
2. Copy `templates/task/*.md` into `tasks/templates/`.
3. Add the workflow summary from `docs/workflow.md` and the rules from `docs/agent-policies.md` to your repository agent instructions.
4. Optional: copy `agents/claude/commands/*.md` into your Claude commands directory.
5. Optional: copy `agents/codex/skills/*` into your Codex skills directory.
6. For every task, classify the Risk Profile and create `tasks/<slug>/` from the task templates. Trivial sub-lightweight changes (comments, formatting, obvious typos) may skip the workspace and live as a one-line `DONE.md` entry plus the commit.
7. Keep `NEXT.md` and `DONE.md` as the source of truth for work state.

A minimal project layout looks like this:

```text
your-repo/
  docs/planning/NEXT.md
  docs/planning/DONE.md
  docs/planning/BUGS.md
  docs/planning/TECH-DEBT.md
  docs/planning/BACKLOG.md
  docs/planning/DECISIONS.md
  docs/planning/archive/         # past months of DONE.md and DECISIONS.md
  tasks/templates/*.md
  tasks/<active-task>/*.md
  tasks/archive/<closed-task>/*.md
```

## Documentation

- `docs/method.md` explains the operating model.
- `docs/workflow.md` defines the pipeline and gates.
- `docs/agent-policies.md` defines refactoring, retry, agent boundary, discovery cost, and enforcement policies.
- `docs/artifact-contract.md` defines the file formats.
- `docs/ai-agent-playbook.md` explains how AI agents should use the framework.
- `agents/claude/commands/*.md` contains Claude command adapters.
- `agents/codex/skills/*/SKILL.md` contains Codex skill adapters.

## Status

Version 1.1.0 — review moved before tests with a file-based verdict, design premises in the spec, and a set of planning and agent policies proven in daily use since 1.0. See [CHANGELOG.md](CHANGELOG.md). The framework intentionally avoids project-specific deployment, infrastructure, database, or application rules. Add local rules in your own repository on top of this baseline.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for how to propose changes, report friction, or add adapters for other agents. By participating you agree to the [Code of Conduct](CODE_OF_CONDUCT.md).

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for release notes.

## License

[MIT](LICENSE) © 2026 Vitaliy Semenov.
