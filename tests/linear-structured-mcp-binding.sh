#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "${TMP}"' EXIT
mkdir -p "${TMP}/.accelerate/status" "${TMP}/docs"
printf '# Public proof\n' >"${TMP}/docs/proof.md"
cat >"${TMP}/.accelerate/status/privacy-map.yaml" <<'YAML'
artifacts:
  - path: docs/proof.md
    class: public-artifact
    export: approved
YAML

read_script="${ROOT}/onboarding/local-workspace/read-linear-mcp-adapter.sh"
create_script="${ROOT}/onboarding/local-workspace/create-linear-mcp-issue.sh"
attach_script="${ROOT}/onboarding/local-workspace/attach-linear-mcp-artifact.sh"
closure_script="${ROOT}/onboarding/local-workspace/comment-linear-mcp-closure.sh"
status_script="${ROOT}/onboarding/local-workspace/update-linear-mcp-status.sh"
registry="${ROOT}/adapters/workflow/remote-write-registry.yaml"

assert_json_fields() {
  local file="$1"
  shift
  python3 - "${file}" "$@" <<'PY'
import json, sys
path = sys.argv[1]
checks = sys.argv[2:]
if len(checks) % 3:
    print("checks must be field/operator/value triples", file=sys.stderr)
    raise SystemExit(1)
with open(path, encoding="utf-8") as fh:
    rows = [json.loads(line) for line in fh if line.strip()]
if not rows:
    print(f"no JSONL rows in {path}", file=sys.stderr)
    raise SystemExit(1)
row = rows[-1]
for field, operator, expected_raw in zip(checks[0::3], checks[1::3], checks[2::3]):
    actual = row.get(field)
    if expected_raw == "false":
        expected = False
    elif expected_raw == "true":
        expected = True
    else:
        expected = expected_raw
    if operator != "eq" or actual != expected:
        print(
            f"JSON assertion failed for {path}: {field} {operator} {expected!r}; actual={actual!r}; row={row!r}",
            file=sys.stderr,
        )
        raise SystemExit(1)
PY
}

# Dry-run emits and persists structured JSONL with remote_calls:false.
"${read_script}" "${TMP}" LIN-123 .accelerate/workflow/read.jsonl --dry-run >/dev/null
assert_json_fields "${TMP}/.accelerate/workflow/read.jsonl" remote_calls eq false operation eq read-issue transport eq graphql
"${create_script}" "${TMP}" TEAM none none "Dry run issue" .accelerate/workflow/create.jsonl --dry-run >/dev/null
assert_json_fields "${TMP}/.accelerate/workflow/create.jsonl" remote_calls eq false operation eq create-issue binding eq linear-mcp-structured-non-llm
"${attach_script}" "${TMP}" LIN-123 docs/proof.md "Dry run comment" .accelerate/workflow/comment.jsonl --dry-run >/dev/null
assert_json_fields "${TMP}/.accelerate/workflow/comment.jsonl" remote_calls eq false operation eq comment-artifact artifact eq docs/proof.md
"${closure_script}" "${TMP}" LIN-123 "Dry run closure" .accelerate/workflow/closure.jsonl --dry-run >/dev/null
assert_json_fields "${TMP}/.accelerate/workflow/closure.jsonl" remote_calls eq false operation eq closure-comment binding eq linear-mcp-structured-non-llm
"${status_script}" "${TMP}" LIN-123 status_fixture .accelerate/workflow/status.jsonl --dry-run >/dev/null
assert_json_fields "${TMP}/.accelerate/workflow/status.jsonl" remote_calls eq false operation eq status-transition status eq status_fixture

# Live mode requires LINEAR_API_KEY before remote work.
if env -u LINEAR_API_KEY "${read_script}" "${TMP}" LIN-123 .accelerate/workflow/live-read.jsonl >/tmp/linear-read.err 2>&1; then
  echo "read helper succeeded without LINEAR_API_KEY" >&2
  exit 1
fi
grep -Fq 'LINEAR_API_KEY is not set' /tmp/linear-read.err
if env -u LINEAR_API_KEY "${create_script}" "${TMP}" TEAM none none "Live issue" .accelerate/workflow/live-create.jsonl >/tmp/linear-create.err 2>&1; then
  echo "create helper succeeded without LINEAR_API_KEY" >&2
  exit 1
fi
grep -Fq 'LINEAR_API_KEY is not set' /tmp/linear-create.err
if env -u LINEAR_API_KEY "${attach_script}" "${TMP}" LIN-123 docs/proof.md "Live comment" .accelerate/workflow/live-comment.jsonl >/tmp/linear-comment.err 2>&1; then
  echo "attach helper succeeded without LINEAR_API_KEY" >&2
  exit 1
fi
grep -Fq 'LINEAR_API_KEY is not set' /tmp/linear-comment.err
if env -u LINEAR_API_KEY "${closure_script}" "${TMP}" LIN-123 "Live closure" .accelerate/workflow/live-closure.jsonl >/tmp/linear-closure.err 2>&1; then
  echo "closure helper succeeded without LINEAR_API_KEY" >&2
  exit 1
fi
grep -Fq 'LINEAR_API_KEY is not set' /tmp/linear-closure.err
if env -u LINEAR_API_KEY "${status_script}" "${TMP}" LIN-123 status_fixture .accelerate/workflow/live-status.jsonl >/tmp/linear-status.err 2>&1; then
  echo "status helper succeeded without LINEAR_API_KEY" >&2
  exit 1
fi
grep -Fq 'LINEAR_API_KEY is not set' /tmp/linear-status.err

# Path safety: outputs must be relative and under .accelerate/workflow; artifacts cannot escape.
if "${read_script}" "${TMP}" LIN-123 /tmp/escape.jsonl --dry-run >/dev/null 2>&1; then
  echo "read helper accepted absolute output path" >&2
  exit 1
fi
if "${create_script}" "${TMP}" TEAM none none "Bad path" workflow/create.jsonl --dry-run >/dev/null 2>&1; then
  echo "create helper accepted output outside .accelerate/workflow" >&2
  exit 1
fi
if "${attach_script}" "${TMP}" LIN-123 ../secret.md "Bad artifact" .accelerate/workflow/bad.jsonl --dry-run >/dev/null 2>&1; then
  echo "attach helper accepted escaping artifact path" >&2
  exit 1
fi
if "${closure_script}" "${TMP}" LIN-123 "Bad path" workflow/closure.jsonl --dry-run >/dev/null 2>&1; then
  echo "closure helper accepted output outside .accelerate/workflow" >&2
  exit 1
fi
if "${status_script}" "${TMP}" LIN-123 status_fixture /tmp/status.jsonl --dry-run >/dev/null 2>&1; then
  echo "status helper accepted absolute output path" >&2
  exit 1
fi
ln -s /tmp/linear-symlink-escape.jsonl "${TMP}/.accelerate/workflow/symlink.jsonl"
if "${read_script}" "${TMP}" LIN-123 .accelerate/workflow/symlink.jsonl --dry-run >/dev/null 2>&1; then
  echo "read helper accepted symlink output path" >&2
  exit 1
fi

# Registry honesty: structured_write is yes only with planned status and no live proof claim for new MCP writes.
python3 - "${registry}" <<'PY'
import sys
text = open(sys.argv[1], encoding="utf-8").read()
for item in ("linear-mcp-create", "linear-mcp-comment-artifact", "linear-mcp-closure-comment", "linear-mcp-status-transition"):
    marker = f"  - id: {item}\n"
    start = text.index(marker)
    end = text.find("\n  - id:", start + len(marker))
    block = text[start:] if end == -1 else text[start:end]
    required = ["status: planned", "requires_opt_in: LINEAR_API_KEY", "live_proof: none", "structured_write: yes", "structured_binding: graphql-over-curl-non-llm"]
    missing = [entry for entry in required if entry not in block]
    if missing:
        print(f"{item} missing registry honesty fields: {missing}\n{block}", file=sys.stderr)
        raise SystemExit(1)
    if "status: available" in block:
        print(f"{item} was optimistically promoted", file=sys.stderr)
        raise SystemExit(1)
PY

# No LLM-host/opencode dependency remains in the structured MCP helper path.
if grep -R -E 'opencode|LLM host|LLM-host' \
  "${read_script}" "${create_script}" "${attach_script}" "${closure_script}" "${status_script}" >/tmp/linear-llm-grep.out; then
  cat /tmp/linear-llm-grep.out >&2
  exit 1
fi

echo "linear structured mcp binding tests passed"
