#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-.}"

required_files=(
  "README.md"
  "docs/method.md"
  "docs/workflow.md"
  "docs/artifact-contract.md"
  "docs/ai-agent-playbook.md"
  "agents/claude/commands/start-task.md"
  "agents/claude/commands/research.md"
  "agents/claude/commands/spec.md"
  "agents/claude/commands/plan.md"
  "agents/claude/commands/plan-improve.md"
  "agents/claude/commands/implement.md"
  "agents/claude/commands/write-tests.md"
  "agents/claude/commands/testing.md"
  "agents/claude/commands/deep-review.md"
  "agents/claude/commands/deploy.md"
  "agents/claude/commands/qa-check.md"
  "agents/claude/commands/finalize.md"
  "agents/claude/commands/merge-to-main.md"
  "agents/codex/skills/solo-kanban-core/SKILL.md"
  "agents/codex/skills/solo-kanban-planning/SKILL.md"
  "agents/codex/skills/solo-kanban-delivery/SKILL.md"
  "agents/codex/skills/solo-kanban-finalize/SKILL.md"
  "templates/planning/NEXT.md"
  "templates/planning/DONE.md"
  "templates/planning/BUGS.md"
  "templates/planning/TECH-DEBT.md"
  "templates/planning/BACKLOG.md"
  "templates/planning/DECISIONS.md"
  "templates/planning/ROADMAP.md"
  "templates/task/requirements.md"
  "templates/task/research-light.md"
  "templates/task/research.md"
  "templates/task/Spec.md"
  "templates/task/tasks.md"
)

for file in "${required_files[@]}"; do
  if [[ ! -f "$ROOT/$file" ]]; then
    echo "missing required file: $file" >&2
    exit 1
  fi
done

for file in "$ROOT"/agents/claude/commands/*.md; do
  [[ "$(basename "$file")" == "README.md" ]] && continue
  first_line="$(sed -n '1p' "$file")"
  if [[ "$first_line" != "---" ]]; then
    echo "Claude command missing YAML frontmatter: $file" >&2
    exit 1
  fi
done

for file in "$ROOT"/agents/codex/skills/*/SKILL.md; do
  first_line="$(sed -n '1p' "$file")"
  if [[ "$first_line" != "---" ]]; then
    echo "Codex skill missing YAML frontmatter: $file" >&2
    exit 1
  fi
done

for file in "$ROOT"/templates/task/*.md; do
  first_line="$(sed -n '1p' "$file")"
  if [[ "$first_line" != "---" ]]; then
    echo "task template missing YAML frontmatter: $file" >&2
    exit 1
  fi
done

forbidden='docs/06-planning|memory-bank|Croqui|Skalds|kubectl|helmfile|Huma|NATS|Paddle|k3d|sema-prod'
if grep -RInE "$forbidden" "$ROOT/README.md" "$ROOT/docs" "$ROOT/templates" "$ROOT/agents" "$ROOT/examples"; then
  echo "found project-specific reference in framework core" >&2
  exit 1
fi

echo "solo-kanban validation passed"
