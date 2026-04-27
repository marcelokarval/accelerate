#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "usage: $0 /path/to/target-repo" >&2
  exit 1
fi

TARGET_ROOT="$(cd "$1" && pwd)"
WORKSPACE="${TARGET_ROOT}/.accelerate"
WORKFLOW="${WORKSPACE}/workflow"

if [ ! -d "${WORKSPACE}" ]; then
  echo "missing .accelerate workspace: ${WORKSPACE}" >&2
  exit 1
fi

mkdir -p "${WORKFLOW}"

if [ ! -f "${WORKFLOW}/README.md" ]; then
  cat > "${WORKFLOW}/README.md" <<'MD'
# Local Accelerate Workflow

This directory stores local workflow adapter truth for the governed repository.
MD
fi

if [ ! -f "${WORKFLOW}/adapter.yaml" ]; then
  cat > "${WORKFLOW}/adapter.yaml" <<YAML
schema_version: 1
adapter: local
adapter_status: initialized
active_work_item_id: none
active_work_item_locator: none
last_event_id: none
last_updated: $(date +%F)
YAML
fi

if [ ! -f "${WORKFLOW}/active-work-item.yaml" ]; then
  cat > "${WORKFLOW}/active-work-item.yaml" <<'YAML'
schema_version: 1
id: none
locator: none
title: none
slug: none
lifecycle_state: none
owner: local
parent_id: none
labels: []
governing_artifact: .accelerate/planning/current-plan.md
created_at: none
updated_at: none
closure_summary: none
YAML
fi

touch "${WORKFLOW}/work-items.jsonl"
touch "${WORKFLOW}/events.jsonl"
touch "${WORKFLOW}/topology.jsonl"

echo "local workflow adapter initialized at ${WORKFLOW}"
