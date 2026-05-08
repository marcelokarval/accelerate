#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT}"

fail() {
  printf 'dogfood-workspace-contract failed: %s\n' "$1" >&2
  exit 1
}

required_files=(
  ".accelerate/README.md"
  ".accelerate/.gitignore"
  ".accelerate/workflow/active-work-item.yaml"
  ".accelerate/review/README.md"
  ".accelerate/status/readiness-dashboard.yaml"
)

for path in "${required_files[@]}"; do
  [ -f "${path}" ] || fail "missing ${path}"
done

for marker in \
  "planning/executive/2026-05-08-recursive-cycle-13-17-executive-plan.md" \
  "planning/executive/2026-05-08-recursive-cycle-13-17-task-ledger.md" \
  "root orchestrator" \
  "bounded subagent" \
  "generated/private" \
  "no secrets"; do
  grep -R --line-number --fixed-strings "${marker}" .accelerate >/dev/null || fail "missing marker ${marker}"
done

secret_regex='(sk_live|sk_test|pk_live|xox[baprs]-|ghp_[A-Za-z0-9_]+|github_pat_|LINEAR_API_KEY|Authorization: Bearer|BEGIN (RSA|OPENSSH|EC|DSA) PRIVATE KEY)'
tracked_dogfood_files=()
while IFS= read -r -d '' path; do
  tracked_dogfood_files+=("${path}")
done < <(git ls-files -z .accelerate)
if [ "${#tracked_dogfood_files[@]}" -gt 0 ] && grep -E --line-number "${secret_regex}" "${tracked_dogfood_files[@]}" >/tmp/accelerate-dogfood-secret-scan.out 2>/dev/null; then
  cat /tmp/accelerate-dogfood-secret-scan.out >&2
  fail "committed dogfood workspace contains a secret-like marker"
fi
rm -f /tmp/accelerate-dogfood-secret-scan.out

for generated_path in \
  ".accelerate/review/browser-proof.json" \
  ".accelerate/review/browser-proof.png" \
  ".accelerate/workflow/provider-response.jsonl" \
  ".accelerate/status/generated/private-proof.json"; do
  git check-ignore -q "${generated_path}" || fail "generated/private path is not ignored: ${generated_path}"
done

for committed_path in "${required_files[@]}"; do
  if git check-ignore -q "${committed_path}"; then
    fail "required committed dogfood path is ignored: ${committed_path}"
  fi
done

printf 'dogfood workspace contract passed\n'
