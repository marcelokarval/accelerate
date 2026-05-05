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

json_escape() {
  printf '%s' "$1" | perl -MJSON::PP -0777 -ne 'print encode_json($_)' | sed 's/^"//; s/"$//'
}

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

CURRENT_STATE="$(sed -n 's/^lifecycle_state:[[:space:]]*//p' "${ACTIVE}" | head -n 1)"
CURRENT_STATE="${CURRENT_STATE:-none}"

allowed_transition() {
  local from="$1"
  local to="$2"
  case "${from}->${to}" in
    none-\>planned|planned-\>ready|planned-\>in_progress|planned-\>review|planned-\>closure|planned-\>blocked|planned-\>cancelled|\
    ready-\>in_progress|ready-\>review|ready-\>closure|ready-\>blocked|ready-\>cancelled|\
    in_progress-\>review|in_progress-\>closure|in_progress-\>done|in_progress-\>blocked|in_progress-\>cancelled|\
    review-\>in_progress|review-\>closure|review-\>done|review-\>blocked|review-\>cancelled|\
    closure-\>review|closure-\>done|closure-\>blocked|closure-\>cancelled|\
    blocked-\>planned|blocked-\>ready|blocked-\>in_progress|blocked-\>review|blocked-\>closure|blocked-\>cancelled|\
    done-\>done|cancelled-\>cancelled)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

if ! allowed_transition "${CURRENT_STATE}" "${STATE}"; then
  echo "invalid lifecycle transition: ${CURRENT_STATE} -> ${STATE}" >&2
  echo "allowed policy: planned may enter ready/in_progress/review/closure/blocked/cancelled; done requires in_progress, review, or closure proof posture" >&2
  exit 1
fi

if [ "${STATE}" = "done" ] && [ "${CURRENT_STATE}" != "done" ]; then
  CLOSURE_PACKET="${TARGET_ROOT}/.accelerate/review/closure-packet.md"
  if ! bash "${SCRIPT_DIR}/check-evidence-gate.sh" "${TARGET_ROOT}" closure-ready >/dev/null; then
    echo "done transition requires closure-ready evidence gate" >&2
    exit 1
  fi
  if [ ! -f "${CLOSURE_PACKET}" ]; then
    echo "done transition requires closure packet: .accelerate/review/closure-packet.md" >&2
    exit 1
  fi
  if ! rg -F -- "Closure Packet" "${CLOSURE_PACKET}" >/dev/null; then
    echo "done transition requires valid closure packet marker" >&2
    exit 1
  fi
fi

STAMP="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
EVENT_ID="event-$(date +%Y%m%d%H%M%S)-${STATE}"

perl -0pi -e "s/^lifecycle_state:.*/lifecycle_state: ${STATE}/m; s/^updated_at:.*/updated_at: ${STAMP}/m" "${ACTIVE}"
if [ "${STATE}" = "done" ]; then
  perl -0pi -e "s/^closure_summary:.*/closure_summary: ${SUMMARY}/m" "${ACTIVE}"
fi
perl -0pi -e "s/^last_event_id:.*/last_event_id: ${EVENT_ID}/m; s/^last_updated:.*/last_updated: $(date +%F)/m" "${WORKFLOW}/adapter.yaml"

printf '{"event_id":"%s","event":"work_item_transitioned","id":"%s","state":"%s","summary":"%s","at":"%s"}\n' "${EVENT_ID}" "${ID}" "${STATE}" "$(json_escape "${SUMMARY}")" "${STAMP}" >> "${WORKFLOW}/events.jsonl"
bash "${SCRIPT_DIR}/append-timeline.sh" "${TARGET_ROOT}" "local_work_item_transitioned" "${ID} -> ${STATE}: ${SUMMARY}" "info" "transition-local-work-item.sh" >/dev/null

echo "transitioned ${ID} to ${STATE}"
