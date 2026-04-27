#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 3 ]; then
  echo "usage: $0 /path/to/target-repo <slug> <title>" >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_ROOT="$(cd "$1" && pwd)"
SLUG="$2"
shift 2
TITLE="$*"
WORKFLOW="${TARGET_ROOT}/.accelerate/workflow"

case "${SLUG}" in
  *[!a-z0-9-]*|""|-*)
    echo "invalid slug: ${SLUG}. use lowercase kebab-case" >&2
    exit 1
    ;;
esac

bash "${SCRIPT_DIR}/init-local-workflow.sh" "${TARGET_ROOT}" >/dev/null

DATE="$(date +%Y%m%d)"
STAMP="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
COUNT="$(wc -l < "${WORKFLOW}/work-items.jsonl" | tr -d ' ')"
NUMBER="$((COUNT + 1))"
ID="LWI-${DATE}-$(printf '%03d' "${NUMBER}")"
LOCATOR="local:${ID}"
EVENT_ID="event-${DATE}-$(printf '%03d' "${NUMBER}")-created"

cat > "${WORKFLOW}/active-work-item.yaml" <<YAML
schema_version: 1
id: ${ID}
locator: ${LOCATOR}
title: ${TITLE}
slug: ${SLUG}
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

perl -0pi -e "s/^active_work_item_id:.*/active_work_item_id: ${ID}/m; s/^active_work_item_locator:.*/active_work_item_locator: ${LOCATOR}/m; s/^last_event_id:.*/last_event_id: ${EVENT_ID}/m; s/^last_updated:.*/last_updated: $(date +%F)/m" "${WORKFLOW}/adapter.yaml"

printf '{"event":"work_item_created","id":"%s","locator":"%s","slug":"%s","title":"%s","state":"planned","at":"%s"}\n' "${ID}" "${LOCATOR}" "${SLUG}" "${TITLE}" "${STAMP}" >> "${WORKFLOW}/work-items.jsonl"
printf '{"event_id":"%s","event":"work_item_created","id":"%s","state":"planned","summary":"%s","at":"%s"}\n' "${EVENT_ID}" "${ID}" "${TITLE}" "${STAMP}" >> "${WORKFLOW}/events.jsonl"

bash "${SCRIPT_DIR}/append-timeline.sh" "${TARGET_ROOT}" "local_work_item_created" "${ID} ${TITLE}" "info" "create-local-work-item.sh" >/dev/null

echo "created local work item ${ID} (${LOCATOR})"
