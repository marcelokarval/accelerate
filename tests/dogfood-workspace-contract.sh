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
  ".accelerate/state.yaml"
  ".accelerate/workflow/README.md"
  ".accelerate/workflow/adapter.yaml"
  ".accelerate/workflow/active-work-item.yaml"
  ".accelerate/review/README.md"
  ".accelerate/status/readiness-dashboard.yaml"
)

for path in "${required_files[@]}"; do
  [ -f "${path}" ] || fail "missing ${path}"
  git ls-files --error-unmatch "${path}" >/dev/null 2>&1 || fail "required dogfood path is not tracked: ${path}"
done

bash onboarding/local-workspace/validate-dogfood-v2-subset.sh .

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

for lifecycle_file in \
  ".accelerate/state.yaml" \
  ".accelerate/status/readiness-dashboard.yaml" \
  ".accelerate/workflow/adapter.yaml" \
  ".accelerate/workflow/active-work-item.yaml"; do
  grep --line-number --fixed-strings "accepted" "${lifecycle_file}" >/dev/null || fail "dogfood lifecycle is not accepted in ${lifecycle_file}"
done

if grep -R --line-number -E '^status:[[:space:]]*active$' .accelerate/state.yaml .accelerate/status/readiness-dashboard.yaml .accelerate/workflow >/tmp/accelerate-dogfood-active-status.out 2>/dev/null; then
  cat /tmp/accelerate-dogfood-active-status.out >&2
  fail "accepted dogfood cycle drifted back to active status"
fi
rm -f /tmp/accelerate-dogfood-active-status.out

printf 'dogfood workspace contract passed\n'
