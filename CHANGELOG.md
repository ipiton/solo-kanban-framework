# Changelog

All notable changes to Solo Kanban are documented here. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the project follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html) at the artifact-contract level.

## [1.1.0] - 2026-09-29

Four months of daily use of the framework, folded back into the public baseline. The risk-driven Step Matrix from 1.0 is unchanged; the order inside the execution phase, the spec, the closure model, and the planning rules are what moved.

### Added

- **Design Premises** section in `Spec.md`: statements about reality the design depends on, each with a confirmation class from a closed vocabulary — `measured`, `call-path-traced`, `code-read`, `assumed`. Every `assumed` premise must also appear in `Open Questions` or `Rollout / Rollback`.
- **Review verdict artifact** `tasks/<slug>/review-verdict.json` with `gate: pass | fix_required | blocked`, the reviewed branch and commit, and two distinct `blocked` causes (degenerate review, wrong tree) with opposite remedies. Schema in `docs/artifact-contract.md`.
- **Evidence folder** `tasks/<slug>/evidence/` for data that cannot be re-obtained from the repository; created only for `measured` premises.
- **Parallel option generation** in research: independent read-only agents, one lens each (`minimal-diff`, `reuse-first`, `reversibility`, `operational`), with convergence recorded as an observation. `Generation:` line in the research template.
- **`docs/agent-policies.md`**: Refactoring Policy, Retry Policy, Agent Boundaries, Discovery Cost and session boundaries, Enforcement Hierarchy, and routing of findings.
- **Planning rules** in `docs/artifact-contract.md`: live state (delete closed entries, do not comment them out), monthly rotation of `DONE.md` and `DECISIONS.md` into `archive/` with a single accessor that reads archives too, bundles of small debt entries, an operational bug vs tech-debt criterion, and the **owner inbox** — marker lines (`Blocked-by:`, `Waiting-on:`, `Trigger:`) collected by a grep, with a stop rule above 5 unblocked items.
- **Flow Rules** section in the `NEXT.md` template as the single place for the WIP limit, replenishment, and balance rules.
- `Bundles` section and bundle format in the `TECH-DEBT.md` template.

### Changed

- **`deep-review` runs after `implement` and before `write-tests`**, not after `testing`. A design defect found after tests exist costs a rewrite of both. `write-tests` starts only on a `pass` verdict. `testing` confirms the behavioral findings review deferred to it.
- **`plan` renamed to `plan-task`** (command file `agents/claude/commands/plan-task.md`), because `/plan` collides with a built-in Claude Code command.
- **Closure model:** `finalize` writes `DONE.md`, `NEXT.md`, and `ROADMAP.md` and moves the archive **on the task branch**, then syncs with the integration branch as its last step. `merge` is mechanical and writes no planning files. The claim at `start-task` is the only direct write to the integration branch.
- `implement` writes no test files; each step is closed by its `verify:` command.
- WIP limit is no longer fixed at 2 in the method; the default stays 2 and the number lives in `NEXT.md` § Flow Rules.
- `start-task` reads the owner inbox first and checks duplicates against the closure journal including its archives.
- `BUGS.md` / `TECH-DEBT.md` statuses: `open | in-progress | blocked` (closed entries are deleted).
- Definition of Done gains: `assumed` premises resolved or carried as risks; review verdict `pass` when review ran; closure records on the task branch.
- All Claude commands, Codex skills, the Codex `AGENTS.md`, and the worked example updated to match.

### Removed

- The `mode: tdd | contract-first` step metadata in `tasks.md`. Prescribing a test first contradicts the review-before-tests order; the step's `verify:` command is its oracle.

### Upgrading From 1.0

1. Rename your `plan` command to `plan-task` and update references.
2. Move `deep-review` in your agent instructions to sit between `implement` and `write-tests`; have it write `review-verdict.json`.
3. Add `Design Premises` to your `tasks/templates/Spec.md`; old specs are updated the next time they are edited.
4. Drop `mode:` from your `tasks.md` template.
5. Add a `## Flow Rules` section to `NEXT.md` and move the WIP limit there.
6. Move `DONE.md` / `DECISIONS.md` entries older than the current month into `archive/`, and point every script that searches them at the archives as well.
7. Optionally, enforce the verdict with a hook that refuses test files until `gate: pass`.

## [1.0.0] - 2026-05-17

First public release of Solo Kanban. The framework was extracted from an internal product workflow and re-shaped around explicit risk classification.

### Added

- **Risk-driven Step Matrix.** Tasks are profiled against five binary signals — `C` (contract), `S` (security), `M` (migration), `X` (cross-domain), `R` (runtime impact) — and routed to one of three tiers (`Lightweight`, `Standard`, `Full`). Time estimates are used for scheduling and slicing, not for gating.
- **Mandatory Deep Review.** Any `S`, any `M`, pre-release, or three or more signals force `deep-review` with recorded findings before `finalize`. Discretionary triggers (large diff, `C+X`, novel pattern, author doubt) may be skipped with a recorded reason.
- **Severity and disposition schema.** Findings carry `blocker | major | minor | nit` severity and `fix-here | defer-bug | defer-tech-debt | defer-backlog | reject` disposition. Output schema in `agents/claude/commands/deep-review.md`.
- **Lightweight and sub-lightweight paths.** Zero-signal tasks run `implement -> testing -> finalize` with a minimal workspace; trivial mechanical edits skip the workspace entirely and live as a one-line `DONE.md` entry plus the commit.
- **"When NOT To Use Solo Kanban".** Explicit non-fit cases: team-scale coordination, non-engineering backlogs, pure exploration, throwaway scripts, real-time incident response.
- **Anti-pattern: self-audit as substitute.** Self-review by the implementer is additive, not substitutive. Documented in `docs/workflow.md` and the deep-review command.
- **Risk Profile field** in `templates/task/requirements.md`.
- **Deep Review decision** in `templates/task/Spec.md`.
- **Tier-aware Definition of Done** in `docs/workflow.md`.

### Changed

- `Default Pipeline` in `docs/workflow.md` is now expressed per tier instead of by type-and-size axes.
- `Step Matrix` replaced its `Small / Medium / Large` axis with risk-based tiers. The `bug / feature / refactor / tech-debt / docs` axis is preserved for queueing and labeling only.
- All Claude commands (`start-task`, `spec`, `deep-review`, `finalize`) and all Codex skills (`core`, `planning`, `delivery`, `finalize`) updated to reference the new policy.

### Removed

- Time-based `Small (<1d) / Medium (1-2d) / Large (>2d)` cells from `Step Matrix`. Time estimates remain useful for slicing but no longer select required steps.
