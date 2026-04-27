#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 2 ]; then
  echo "usage: $0 /path/to/target-repo title" >&2
  exit 1
fi

root="$(cd "$1" && pwd)"
title="$2"
slug="$(printf '%s' "${title}" | tr '[:upper:]' '[:lower:]' | tr -c 'a-z0-9' '-' | sed 's/--*/-/g; s/^-//; s/-$//')"
mkdir -p "${root}/.accelerate/status/checkpoints"
out="${root}/.accelerate/status/checkpoints/$(date -u +%Y%m%dT%H%M%SZ)-${slug}.md"
branch="$(git -C "${root}" branch --show-current 2>/dev/null || echo unknown)"
cat > "${out}" <<MD
# Context Checkpoint

- timestamp: $(date -u +%Y-%m-%dT%H:%M:%SZ)
- branch: ${branch}
- active work item: .accelerate/workflow/active-work-item.yaml
- current phase: unknown
- source request: ${title}
- governing plan: .accelerate/planning/current-plan.md
- task ledger: .accelerate/planning/task-ledger.md
- files changed summary: see git status
- decisions made: none recorded
- blockers: none recorded
- remaining work: review checkpoint manually
- proof captured: see evidence registry
- proof required: see readiness dashboard
- unsafe assumptions: none recorded
- next recommended action: restore and inspect active artifacts
MD
printf '%s\n' "${out#${root}/}"
