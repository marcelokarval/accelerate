#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 2 ]; then
  echo "usage: $0 /path/to/target-repo <local-work-item-id>" >&2
  exit 1
fi

TARGET_ROOT="$(cd "$1" && pwd)"
ID="$2"
WORKFLOW="${TARGET_ROOT}/.accelerate/workflow"
ITEMS="${WORKFLOW}/work-items.jsonl"
EVENTS="${WORKFLOW}/events.jsonl"
TOPOLOGY="${WORKFLOW}/topology.jsonl"
ACTIVE="${WORKFLOW}/active-work-item.yaml"
ADAPTER="${WORKFLOW}/adapter.yaml"

if [ ! -f "${ITEMS}" ]; then
  echo "missing local work items log: ${ITEMS}" >&2
  exit 1
fi

STAMP="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
python3 - "${ITEMS}" "${EVENTS}" "${TOPOLOGY}" "${ACTIVE}" "${ID}" "${STAMP}" <<'PY'
import json
import os
import sys

items_path, events_path, topology_path, active_path, target_id, stamp = sys.argv[1:]
items = {}

def read_jsonl(path):
    if not os.path.exists(path):
        return
    with open(path) as handle:
        for raw in handle:
            raw = raw.strip()
            if not raw:
                continue
            yield json.loads(raw)

def list_yaml(values):
    if not values:
        return "[]"
    return "[" + ", ".join(values) + "]"

for data in read_jsonl(items_path) or []:
    if data.get("event") != "work_item_created":
        continue
    item_id = data.get("id")
    if not item_id:
        continue
    items[item_id] = {
        "id": item_id,
        "locator": data.get("locator") or f"local:{item_id}",
        "title": data.get("title") or data.get("slug") or item_id,
        "slug": data.get("slug") or item_id.lower(),
        "state": data.get("state") or "planned",
        "owner": data.get("owner") or "local",
        "parent_id": data.get("parent_id") or "none",
        "related_ids": [],
        "child_ids": [],
        "labels": [],
        "governing_artifact": data.get("governing_artifact") or ".accelerate/planning/current-plan.md",
        "one_shot_task_ledger": data.get("one_shot_task_ledger") or "none",
        "created_at": data.get("at") or stamp,
        "updated_at": data.get("at") or stamp,
        "closure_summary": data.get("closure_summary") or "none",
    }

for data in read_jsonl(events_path) or []:
    item_id = data.get("id")
    if item_id not in items:
        continue
    if data.get("event") == "work_item_transitioned":
        state = data.get("state")
        if state:
            items[item_id]["state"] = state
        items[item_id]["updated_at"] = data.get("at") or items[item_id]["updated_at"]
        if state == "done" and data.get("summary"):
            items[item_id]["closure_summary"] = data.get("summary")

for data in read_jsonl(topology_path) or []:
    item_id = data.get("id")
    if item_id not in items:
        continue
    event = data.get("event")
    if event == "work_item_parent_linked" and data.get("parent_id"):
        items[item_id]["parent_id"] = data["parent_id"]
    elif event == "work_item_child_linked" and data.get("child_id"):
        if data["child_id"] not in items[item_id]["child_ids"]:
            items[item_id]["child_ids"].append(data["child_id"])
    elif event == "work_item_related_linked" and data.get("related_id"):
        if data["related_id"] not in items[item_id]["related_ids"]:
            items[item_id]["related_ids"].append(data["related_id"])
    elif event == "work_item_task_ledger_linked" and data.get("task_ledger"):
        items[item_id]["one_shot_task_ledger"] = data["task_ledger"]

selected = items.get(target_id)
if selected is None:
    print(f"local work item not found: {target_id}", file=sys.stderr)
    raise SystemExit(1)

with open(active_path, "w") as handle:
    handle.write("schema_version: 1\n")
    handle.write(f"id: {target_id}\n")
    handle.write(f"locator: {selected['locator']}\n")
    handle.write(f"title: {selected['title']}\n")
    handle.write(f"slug: {selected['slug']}\n")
    handle.write(f"lifecycle_state: {selected['state']}\n")
    handle.write(f"owner: {selected['owner']}\n")
    handle.write(f"parent_id: {selected['parent_id']}\n")
    handle.write(f"related_ids: {list_yaml(selected['related_ids'])}\n")
    handle.write(f"child_ids: {list_yaml(selected['child_ids'])}\n")
    handle.write(f"labels: {list_yaml(selected['labels'])}\n")
    handle.write(f"governing_artifact: {selected['governing_artifact']}\n")
    handle.write(f"one_shot_task_ledger: {selected['one_shot_task_ledger']}\n")
    handle.write(f"created_at: {selected['created_at']}\n")
    handle.write(f"updated_at: {stamp}\n")
    handle.write(f"closure_summary: {selected['closure_summary']}\n")
PY

perl -0pi -e "s/^active_work_item_id:.*/active_work_item_id: ${ID}/m; s/^active_work_item_locator:.*/active_work_item_locator: local:${ID}/m; s/^last_updated:.*/last_updated: $(date +%F)/m" "${ADAPTER}"
printf '{"event_id":"event-%s-select","event":"work_item_selected","id":"%s","state":"selected","summary":"selected active local work item","at":"%s"}\n' "$(date +%Y%m%d%H%M%S)" "${ID}" "${STAMP}" >> "${WORKFLOW}/events.jsonl"
echo "selected local work item ${ID}"
