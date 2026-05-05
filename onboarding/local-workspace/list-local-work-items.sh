#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "usage: $0 /path/to/target-repo" >&2
  exit 1
fi

TARGET_ROOT="$(cd "$1" && pwd)"
WORKFLOW="${TARGET_ROOT}/.accelerate/workflow"
ITEMS="${WORKFLOW}/work-items.jsonl"
EVENTS="${WORKFLOW}/events.jsonl"
TOPOLOGY="${WORKFLOW}/topology.jsonl"
ACTIVE="${WORKFLOW}/active-work-item.yaml"

if [ ! -f "${ITEMS}" ]; then
  echo "missing local work items log: ${ITEMS}" >&2
  exit 1
fi

active_id="none"
if [ -f "${ACTIVE}" ]; then
  active_id="$(sed -n 's/^id:[[:space:]]*//p' "${ACTIVE}" | head -n 1)"
fi

printf 'Local Work Items\n'
printf 'active_work_item_id: %s\n\n' "${active_id:-none}"
if [ ! -s "${ITEMS}" ]; then
  printf 'none\n'
  exit 0
fi

python3 - "${ITEMS}" "${EVENTS}" "${TOPOLOGY}" <<'PY'
import json
import os
import sys

items_path, events_path, topology_path = sys.argv[1:]
items = {}
order = []

def read_jsonl(path):
    if not os.path.exists(path):
        return
    with open(path) as handle:
        for raw in handle:
            raw = raw.strip()
            if not raw:
                continue
            yield json.loads(raw)

for data in read_jsonl(items_path) or []:
    if data.get("event") != "work_item_created":
        continue
    item_id = data.get("id")
    if not item_id:
        continue
    if item_id not in items:
        order.append(item_id)
    items[item_id] = {
        "id": item_id,
        "locator": data.get("locator") or f"local:{item_id}",
        "state": data.get("state") or "planned",
        "slug": data.get("slug") or item_id.lower(),
        "title": data.get("title") or data.get("slug") or item_id,
        "parent_id": data.get("parent_id") or "none",
        "child_ids": [],
        "related_ids": [],
        "one_shot_task_ledger": data.get("one_shot_task_ledger") or "none",
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

for item_id in order:
    data = items[item_id]
    print(f"- {item_id} | {data.get('locator','local:'+item_id)} | {data.get('state','unknown')} | {data.get('slug','unknown')} | {data.get('title','')}")
PY
