# Contributing to Solo Kanban

Solo Kanban is a small, opinionated framework. Contributions are welcome, but the bar is "does this improve the workflow for a solo developer working with AI agents" — not "this would be useful for my team-of-twelve at FAANG".

## Ways To Contribute

- **Report friction.** Open an issue describing the workflow situation where the current rules failed or felt heavy. Concrete examples beat abstract critiques.
- **Propose tier or signal rules.** If a real task exposed a gap in the `C / S / M / X / R` taxonomy or the `Lightweight / Standard / Full` tier mapping, file an issue with the task you ran into.
- **Improve docs.** Clarity fixes, broken examples, missing edge cases. PRs welcome.
- **Add adapter for another agent.** Cursor, Aider, or other agents — follow the structure of `agents/claude/commands/` or `agents/codex/skills/` and keep parity with the policy in `docs/workflow.md`.

## Scope Of Changes

Solo Kanban tries to stay deliberately small. PRs that expand surface area should justify the addition against:

- Does it solve a recurring problem, or a one-off?
- Can it be expressed inside the existing artifact contract?
- Does it survive the "single solo dev with AI agents" smell test?

PRs that add team-coordination features, complex tooling, or new mandatory artifacts are likely to be declined or scoped down.

## PR Conventions

- Conventional commits (`feat:`, `fix:`, `docs:`, `refactor:`).
- Update `CHANGELOG.md` under `## [Unreleased]` for any user-visible change.
- Keep diffs scoped — one logical change per PR.
- If you change `docs/workflow.md`, `docs/method.md`, `docs/artifact-contract.md`, or any template, ensure the adapter files in `agents/` stay in sync.

## Code of Conduct

By participating you agree to abide by the [Code of Conduct](CODE_OF_CONDUCT.md).
