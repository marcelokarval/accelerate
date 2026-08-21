#!/usr/bin/env bash
set -euo pipefail

# Opt-in release canary. It never touches this repository or global runtime.
# The parser is an evidence classifier, not a runtime write firewall.
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
parser="$ROOT/scripts/validate-codex-v2-delegation-transcript.py"
mode="dry-run"
model="gpt-5.6-sol"
effort="medium"
expected_route="orchestrated"
config_override="model_reasoning_effort=\"medium\""

usage() { printf 'usage: %s [--dry-run|--execute] [--root sol|terra|luna]\n' "${0##*/}"; }
emit_harness_receipt() {
  python3 -c 'import json,sys; print(json.dumps({"harness_receipt": {"requested_by_harness": {"model": sys.argv[1], "reasoning_effort": sys.argv[2]}, "raw_jsonl_sha256": sys.argv[3], "verdict": json.loads(sys.argv[4])}}, sort_keys=True))' "$1" "$2" "$3" "$4"
}
receipt_self_test=false
while (($#)); do
  case "$1" in
    --dry-run) mode="dry-run" ;;
    --execute) mode="execute" ;;
    --receipt-self-test) receipt_self_test=true ;;
    --root)
      shift; case "${1:-}" in
        sol) model="gpt-5.6-sol"; effort="medium" ;;
        terra) model="gpt-5.6-terra"; effort="medium" ;;
        luna) model="gpt-5.6-luna"; effort="low"; expected_route="luna-leaf" ;;
        *) usage >&2; exit 2 ;;
      esac ;;
    -h|--help) usage; exit 0 ;;
    *) usage >&2; exit 2 ;;
  esac
  shift
done

if [ "$receipt_self_test" = true ]; then
  emit_harness_receipt gpt-5.6-luna low "0000000000000000000000000000000000000000000000000000000000000000" '{"status":"passed"}'
  exit 0
fi

command -v codex >/dev/null || { printf 'canary preflight failed: codex unavailable\n' >&2; exit 1; }
[ -x "$parser" ] || { printf 'canary preflight failed: parser unavailable\n' >&2; exit 1; }
help_output="$(codex exec --help)"
for flag in --json --ephemeral --sandbox; do
  grep -Fq -- "$flag" <<<"$help_output" || { printf 'canary preflight failed: codex exec lacks %s\n' "$flag" >&2; exit 1; }
done
grep -Eq '(^|[[:space:]])-c,|--config' <<<"$help_output" || { printf 'canary preflight failed: codex exec lacks -c/--config\n' >&2; exit 1; }
config_override="model_reasoning_effort=\"$effort\""
printf 'canary preflight passed: requested_model=%s requested_effort=%s config_override=%s expected_route=%s mode=%s evidence_tier=live\n' "$model" "$effort" "$config_override" "$expected_route" "$mode"

if [ "$mode" = "dry-run" ]; then
  printf 'dry-run only: no Codex execution, repository, or global runtime mutation occurred\n'
  exit 0
fi
[ "${CODEX_V2_DELEGATION_CANARY_RELEASE:-}" = "1" ] || {
  printf 'canary blocked: set CODEX_V2_DELEGATION_CANARY_RELEASE=1 for an authorized release run\n' >&2
  exit 1
}

stage="$(mktemp -d)"
trap 'rm -rf "$stage"' EXIT
raw="$stage/codex-exec.jsonl"
if [ "$expected_route" = "luna-leaf" ]; then
  printf '%s\n' 'This is a disposable workspace. The requested route is leaf-only: reopen this work to a collaborative root and do not mutate any file.' \
    | codex exec --json --ephemeral --sandbox workspace-write -C "$stage" -m "$model" -c "$config_override" - >"$raw"
  verdict="$(python3 "$parser" --tier live --expected-route luna-leaf --requested-root-model "$model" --requested-root-effort "$effort" "$raw")"
  [ ! -e "$stage/canary/executor-artifact.txt" ] && [ ! -e "$stage/canary/reviewer-evidence.txt" ] \
    || { printf 'Luna leaf canary failed: implementation artifact exists\n' >&2; exit 1; }
else
  printf '%s\n' 'This is a disposable workspace. Route is orchestrated and ready. Acceptance requires child-owned files canary/executor-artifact.txt and canary/reviewer-evidence.txt, each verified before completion. Keep all mutation inside this workspace.' \
    | codex exec --json --ephemeral --sandbox workspace-write -C "$stage" -m "$model" -c "$config_override" - >"$raw"
  verdict="$(python3 "$parser" --tier live --expected-route orchestrated --requested-root-model "$model" --requested-root-effort "$effort" --task-scope 'canary/executor-artifact.txt' --task-scope 'canary/reviewer-evidence.txt' "$raw")"
  [ -f "$stage/canary/executor-artifact.txt" ] || { printf 'live canary failed: executor artifact missing\n' >&2; exit 1; }
  [ -f "$stage/canary/reviewer-evidence.txt" ] || { printf 'live canary failed: reviewer evidence artifact missing\n' >&2; exit 1; }
fi
raw_sha256="$(sha256sum "$raw" | awk '{print $1}')"
emit_harness_receipt "$model" "$effort" "$raw_sha256" "$verdict"
printf 'live canary passed: raw tool-envelope dispatch evidence and disposable artifact checks only\n'
