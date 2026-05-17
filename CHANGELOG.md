# Changelog

All notable changes to Solo Kanban are documented here. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the project follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html) at the artifact-contract level.

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
