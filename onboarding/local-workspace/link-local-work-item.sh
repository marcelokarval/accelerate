#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 1 ]; then
  echo "usage: $0 /path/to/target-repo [--parent ID] [--child ID] [--related ID] [--task-ledger path]" >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_ROOT="$(cd "$1" && pwd)"
shift
WORKFLOW="${TARGET_ROOT}/.accelerate/workflow"
ACTIVE="${WORKFLOW}/active-work-item.yaml"

if [ ! -f "${ACTIVE}" ]; then
  echo "missing active work item: ${ACTIVE}" >&2
  exit 1
fi

active_id="$(sed -n 's/^id:[[:space:]]*//p' "${ACTIVE}" | head -n 1)"
if [ -z "${active_id}" ] || [ "${active_id}" = "none" ]; then
  echo "no active local work item" >&2
  exit 1
fi

parent_id=""
child_id=""
related_id=""
task_ledger=""

while [ "$#" -gt 0 ]; do
  case "$1" in
    --parent)
      parent_id="${2:-}"
      shift 2
      ;;
    --child)
      child_id="${2:-}"
      shift 2
      ;;
    --related)
      related_id="${2:-}"
      shift 2
      ;;
    --task-ledger)
      task_ledger="${2:-}"
      shift 2
      ;;
    *)
      echo "unknown option: $1" >&2
      exit 1
      ;;
  esac
done

validate_id() {
  local label="$1"
  local value="$2"
  if [ -z "${value}" ]; then
    echo "${label} requires a value" >&2
    exit 1
  fi
  case "${value}" in
    LWI-[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9]) ;;
    *)
      echo "invalid ${label}: ${value}" >&2
      exit 1
      ;;
  esac
}

list_value() {
  local key="$1"
  sed -n "s/^${key}:[[:space:]]*//p" "${ACTIVE}" | head -n 1
}

append_list_item() {
  local key="$1"
  local value="$2"
  local current
  current="$(list_value "${key}")"
  case "${current}" in
    *"${value}"*)
      return
      ;;
    ""|[])
      perl -0pi -e "s#^${key}:.*#${key}: [${value}]#m" "${ACTIVE}"
      ;;
    *)
      current="${current%]}"
      perl -0pi -e "s#^${key}:.*#${key}: ${current}, ${value}]#m" "${ACTIVE}"
      ;;
  esac
}

STAMP="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

if [ -n "${parent_id}" ]; then
  validate_id "parent id" "${parent_id}"
  perl -0pi -e "s/^parent_id:.*/parent_id: ${parent_id}/m; s/^updated_at:.*/updated_at: ${STAMP}/m" "${ACTIVE}"
  printf '{"event":"work_item_parent_linked","id":"%s","parent_id":"%s","at":"%s"}\n' "${active_id}" "${parent_id}" "${STAMP}" >> "${WORKFLOW}/topology.jsonl"
fi

if [ -n "${child_id}" ]; then
  validate_id "child id" "${child_id}"
  append_list_item "child_ids" "${child_id}"
  perl -0pi -e "s/^updated_at:.*/updated_at: ${STAMP}/m" "${ACTIVE}"
  printf '{"event":"work_item_child_linked","id":"%s","child_id":"%s","at":"%s"}\n' "${active_id}" "${child_id}" "${STAMP}" >> "${WORKFLOW}/topology.jsonl"
fi

if [ -n "${related_id}" ]; then
  validate_id "related id" "${related_id}"
  append_list_item "related_ids" "${related_id}"
  perl -0pi -e "s/^updated_at:.*/updated_at: ${STAMP}/m" "${ACTIVE}"
  printf '{"event":"work_item_related_linked","id":"%s","related_id":"%s","at":"%s"}\n' "${active_id}" "${related_id}" "${STAMP}" >> "${WORKFLOW}/topology.jsonl"
fi

if [ -n "${task_ledger}" ]; then
  case "${task_ledger}" in
    .accelerate/*|planning/*)
      ;;
    *)
      echo "task ledger must be a repo-local .accelerate/ or planning/ path: ${task_ledger}" >&2
      exit 1
      ;;
  esac
  perl -0pi -e "s#^one_shot_task_ledger:.*#one_shot_task_ledger: ${task_ledger}#m; s/^updated_at:.*/updated_at: ${STAMP}/m" "${ACTIVE}"
  printf '{"event":"work_item_task_ledger_linked","id":"%s","task_ledger":"%s","at":"%s"}\n' "${active_id}" "${task_ledger}" "${STAMP}" >> "${WORKFLOW}/topology.jsonl"
fi

bash "${SCRIPT_DIR}/append-timeline.sh" "${TARGET_ROOT}" "local_work_item_topology_linked" "Updated topology for ${active_id}" "info" "link-local-work-item.sh" >/dev/null

echo "updated local work item topology for ${active_id}"
