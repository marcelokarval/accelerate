#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VALIDATOR="${ROOT}/onboarding/local-workspace/validate-github-pr-response.sh"

success='{"number":12,"url":"https://github.com/example/repo/pull/12","state":"OPEN","headRefName":"feature/ready","baseRefName":"main","title":"Ready PR","statusCheckRollup":[]}'
printf '%s' "${success}" | "${VALIDATOR}" "feature/ready" | rg -Fq "12" || {
  echo "github pr parser did not return PR number" >&2
  exit 1
}

if printf '%s' "${success}" | "${VALIDATOR}" "feature/wrong" >/dev/null 2>&1; then
  echo "github pr parser accepted wrong branch" >&2
  exit 1
fi

if printf '%s' '{"errors":[{"message":"bad"}]}' | "${VALIDATOR}" "feature/ready" >/dev/null 2>&1; then
  echo "github pr parser accepted errors" >&2
  exit 1
fi

if printf '%s' '{"number":12,"url":"https://github.com/example/repo/pull/12","state":"OPEN","headRefName":"feature/ready","baseRefName":"main","title":"Ready PR","statusCheckRollup":{}}' | "${VALIDATOR}" "feature/ready" >/dev/null 2>&1; then
  echo "github pr parser accepted non-list status checks" >&2
  exit 1
fi

if printf '%s' '{"number":12,"url":"https://example.com/pr/12","state":"OPEN","headRefName":"feature/ready","baseRefName":"main","title":"Ready PR"}' | "${VALIDATOR}" "feature/ready" >/dev/null 2>&1; then
  echo "github pr parser accepted non-GitHub URL" >&2
  exit 1
fi

printf 'github pr helper parse tests passed\n'
