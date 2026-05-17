# Agent Adapters

This directory contains generic AI-agent adapters for Solo Kanban.

- `claude/commands/*.md` contains Claude command files for the workflow verbs.
- `codex/AGENTS.md` contains a lightweight Codex starter instruction file.
- `codex/skills/*/SKILL.md` contains Codex skills for the core, planning, delivery, and finalization phases.

Copy and adapt these inside a real repository. Repository-specific engineering rules should live beside the project, not in this framework core.

Recommended layering:

1. Keep the Solo Kanban method and artifacts stable.
2. Add repository-specific engineering rules locally.
3. Add tool-specific commands or skills from this directory.
4. Keep deployment, infrastructure, and product-specific rules outside the core framework.
