#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 2 ]; then
  echo "usage: $0 /path/to/target-repo <planned|ready|in_progress|review|closure|done|blocked|cancelled> [summary]" >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_ROOT="$(cd "$1" && pwd)"
STATE="$2"
SUMMARY="${3:-transitioned local work item}"
WORKFLOW="${TARGET_ROOT}/.accelerate/workflow"
ACTIVE="${WORKFLOW}/active-work-item.yaml"

case "${STATE}" in
  planned|ready|in_progress|review|closure|done|blocked|cancelled)
    ;;
  *)
    echo "invalid lifecycle state: ${STATE}" >&2
    exit 1
    ;;
esac

if [ ! -f "${ACTIVE}" ]; then
  echo "missing active work item: ${ACTIVE}" >&2
  exit 1
fi

ID="$(sed -n 's/^id:[[:space:]]*//p' "${ACTIVE}" | head -n 1)"
if [ -z "${ID}" ] || [ "${ID}" = "none" ]; then
  echo "no active local work item" >&2
  exit 1
fi

STAMP="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
EVENT_ID="event-$(date +%Y%m%d%H%M%S)-${STATE}"

perl -0pi -e "s/^lifecycle_state:.*/lifecycle_state: ${STATE}/m; s/^updated_at:.*/updated_at: ${STAMP}/m" "${ACTIVE}"
if [ "${STATE}" = "done" ]; then
  perl -0pi -e "s/^closure_summary:.*/closure_summary: ${SUMMARY}/m" "${ACTIVE}"
fi
perl -0pi -e "s/^last_event_id:.*/last_event_id: ${EVENT_ID}/m; s/^last_updated:.*/last_updated: $(date +%F)/m" "${WORKFLOW}/adapter.yaml"

printf '{"event_id":"%s","event":"work_item_transitioned","id":"%s","state":"%s","summary":"%s","at":"%s"}\n' "${EVENT_ID}" "${ID}" "${STATE}" "${SUMMARY}" "${STAMP}" >> "${WORKFLOW}/events.jsonl"
bash "${SCRIPT_DIR}/append-timeline.sh" "${TARGET_ROOT}" "local_work_item_transitioned" "${ID} -> ${STATE}: ${SUMMARY}" "info" "transition-local-work-item.sh" >/dev/null

echo "transitioned ${ID} to ${STATE}"
