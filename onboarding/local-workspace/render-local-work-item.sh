#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "usage: $0 /path/to/target-repo" >&2
  exit 1
fi

TARGET_ROOT="$(cd "$1" && pwd)"
ACTIVE="${TARGET_ROOT}/.accelerate/workflow/active-work-item.yaml"

if [ ! -f "${ACTIVE}" ]; then
  echo "missing active work item: ${ACTIVE}" >&2
  exit 1
fi

value() {
  sed -n "s/^$1:[[:space:]]*//p" "${ACTIVE}" | head -n 1
}

cat <<MD
Local Workflow Work Item

- id: $(value id)
- locator: $(value locator)
- title: $(value title)
- slug: $(value slug)
- lifecycle state: $(value lifecycle_state)
- owner: $(value owner)
- parent id: $(value parent_id)
- child ids: $(value child_ids)
- related ids: $(value related_ids)
- governing artifact: $(value governing_artifact)
- one-shot task ledger: $(value one_shot_task_ledger)
- created at: $(value created_at)
- updated at: $(value updated_at)
- closure summary: $(value closure_summary)
MD
