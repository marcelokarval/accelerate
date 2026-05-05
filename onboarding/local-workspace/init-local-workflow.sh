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

if [ ! -f "${WORKFLOW}/active-work-item.yaml" ] || grep -q '^id:[[:space:]]*none$' "${WORKFLOW}/active-work-item.yaml"; then
  STAMP="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  BOOTSTRAP_ID="LWI-$(date +%Y%m%d)-000"
  cat > "${WORKFLOW}/active-work-item.yaml" <<YAML
schema_version: 1
id: ${BOOTSTRAP_ID}
locator: local:${BOOTSTRAP_ID}
title: Local workspace bootstrap
slug: local-workspace-bootstrap
lifecycle_state: planned
owner: local
parent_id: none
related_ids: []
child_ids: []
labels: []
governing_artifact: .accelerate/planning/current-plan.md
one_shot_task_ledger: none
created_at: ${STAMP}
updated_at: ${STAMP}
closure_summary: none
YAML
fi

touch "${WORKFLOW}/work-items.jsonl"
touch "${WORKFLOW}/events.jsonl"
touch "${WORKFLOW}/topology.jsonl"

if [ -f "${WORKFLOW}/active-work-item.yaml" ]; then
  active_id="$(sed -n 's/^id:[[:space:]]*//p' "${WORKFLOW}/active-work-item.yaml" | head -n 1)"
  active_locator="$(sed -n 's/^locator:[[:space:]]*//p' "${WORKFLOW}/active-work-item.yaml" | head -n 1)"
  if [ -n "${active_id}" ] && [ "${active_id}" != "none" ]; then
    perl -0pi -e "s/^active_work_item_id:.*/active_work_item_id: ${active_id}/m; s/^active_work_item_locator:.*/active_work_item_locator: ${active_locator}/m; s/^last_updated:.*/last_updated: $(date +%F)/m" "${WORKFLOW}/adapter.yaml"
  fi
fi

echo "local workflow adapter initialized at ${WORKFLOW}"
