#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT}"

fail() {
  printf 'workflow-adapter-contract failed: %s\n' "$1" >&2
  exit 1
}

require_file() {
  local path="$1"
  [ -f "${path}" ] || fail "missing required file: ${path}"
}

yaml_value() {
  local path="$1"
  local key="$2"
  sed -n "s/^${key}:[[:space:]]*//p" "${path}" | head -n 1
}

require_key() {
  local path="$1"
  local key="$2"
  [ -n "$(yaml_value "${path}" "${key}")" ] || fail "missing key ${key} in ${path}"
}

require_enum() {
  local path="$1"
  local key="$2"
  shift 2
  local actual
  actual="$(yaml_value "${path}" "${key}")"
  for allowed in "$@"; do
    [ "${actual}" = "${allowed}" ] && return
  done
  fail "unexpected value for ${key} in ${path}: ${actual}"
}

require_file "adapters/workflow/adapter-contract.md"
require_file "adapters/workflow/local/README.md"
require_file "adapters/workflow/local/capabilities.yaml"

required_keys=(
  schema_version
  adapter
  status
  identity
  work_item_create
  work_item_lookup
  work_item_update
  lifecycle_transition
  topology
  review_attachment
  closure_attachment
  metadata_rehydration
  failure_recovery
  external_api
  substitute_evidence
  runtime_truth
)

for manifest in adapters/workflow/*/capabilities.yaml; do
  [ -f "${manifest}" ] || continue
  for key in "${required_keys[@]}"; do
    require_key "${manifest}" "${key}"
  done

  require_enum "${manifest}" "schema_version" "1"
  require_enum "${manifest}" "status" "implemented" "planned" "blocked"
  for capability in \
    identity \
    work_item_create \
    work_item_lookup \
    work_item_update \
    lifecycle_transition \
    topology \
    review_attachment \
    closure_attachment \
    metadata_rehydration \
    failure_recovery \
    external_api; do
    require_enum "${manifest}" "${capability}" "native" "linked" "substitute" "planned" "blocked" "none"
  done
  require_enum "${manifest}" "runtime_truth" "local" "remote" "hybrid" "none"

  adapter="$(yaml_value "${manifest}" "adapter")"
  dir_adapter="$(basename "$(dirname "${manifest}")")"
  [ "${adapter}" = "${dir_adapter}" ] || fail "adapter key ${adapter} does not match directory ${dir_adapter}"

  status="$(yaml_value "${manifest}" "status")"
  if [ "${status}" = "implemented" ]; then
    for required_capability in \
      identity \
      lifecycle_transition \
      topology \
      review_attachment \
      closure_attachment \
      metadata_rehydration \
      failure_recovery; do
      value="$(yaml_value "${manifest}" "${required_capability}")"
      [ "${value}" != "none" ] || fail "implemented adapter ${adapter} has no ${required_capability} support"
    done
  fi

  if [ "${adapter}" = "local" ]; then
    require_enum "${manifest}" "external_api" "none"
    require_enum "${manifest}" "runtime_truth" "local"
    [ "$(yaml_value "${manifest}" "substitute_evidence")" = ".accelerate/workflow/" ] || fail "local adapter substitute_evidence must be .accelerate/workflow/"
  fi

  if [ "${adapter}" != "local" ] && [ "${status}" = "implemented" ]; then
    external_api="$(yaml_value "${manifest}" "external_api")"
    [ "${external_api}" = "native" ] || fail "implemented remote adapter ${adapter} must have native external_api support"
  fi

  if [ "${adapter}" = "linear" ]; then
    require_file "adapters/workflow/linear/operational-contract.md"
    require_file "onboarding/local-workspace/probe-linear-adapter.sh"
    require_file "onboarding/local-workspace/read-linear-adapter.sh"
    require_file "onboarding/local-workspace/attach-linear-artifact.sh"
    require_file "onboarding/local-workspace/read-linear-mcp-adapter.sh"
    require_file "onboarding/local-workspace/create-linear-mcp-issue.sh"
    require_file "onboarding/local-workspace/attach-linear-mcp-artifact.sh"
    require_file "onboarding/local-workspace/write-linear-mcp-recovery.sh"
    runtime_truth="$(yaml_value "${manifest}" "runtime_truth")"
    [ "${runtime_truth}" = "remote" ] || fail "linear adapter runtime_truth must be remote"
    if [ "${status}" = "implemented" ]; then
      [ "$(yaml_value "${manifest}" "mcp_live_read_result")" = "passed" ] || fail "linear implemented adapter requires MCP read proof"
      [ "$(yaml_value "${manifest}" "mcp_live_write_result")" = "passed" ] || fail "linear implemented adapter requires MCP write proof"
    fi
  fi

  if [ "${adapter}" = "github-pr" ]; then
    require_file "onboarding/local-workspace/probe-github-pr-adapter.sh"
    require_file "onboarding/local-workspace/read-github-pr-adapter.sh"
    require_file "onboarding/local-workspace/attach-github-pr-artifact.sh"
    require_file "onboarding/local-workspace/create-github-pr-adapter.sh"
    require_file "onboarding/local-workspace/rehydrate-github-pr-adapter.sh"
    require_file "onboarding/local-workspace/write-github-pr-recovery.sh"
    require_file "onboarding/local-workspace/check-ship-readiness.sh"
    require_file "onboarding/local-workspace/land-github-pr.sh"
    runtime_truth="$(yaml_value "${manifest}" "runtime_truth")"
    [ "${runtime_truth}" = "remote" ] || fail "github-pr adapter runtime_truth must be remote"
    if [ "${status}" = "implemented" ]; then
      [ "$(yaml_value "${manifest}" "live_read_result")" = "passed" ] || fail "github-pr implemented adapter requires live read proof"
      [ "$(yaml_value "${manifest}" "live_attachment_result")" = "passed" ] || fail "github-pr implemented adapter requires live attachment proof"
    fi
  fi
done

echo "workflow adapter contract tests passed"
