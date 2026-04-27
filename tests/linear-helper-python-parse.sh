#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

success='{"data":{"issue":{"id":"uuid-1","identifier":"P4Y-123","project":{"name":"Prop4You"},"assignee":{"email":"marcelokarval@gmail.com"}}}}'
printf '%s' "${success}" | LINEAR_EXPECTED_PROJECT="Prop4You" LINEAR_EXPECTED_ASSIGNEE_EMAIL="marcelokarval@gmail.com" "${ROOT}/onboarding/local-workspace/validate-linear-issue-response.sh" "P4Y-123" | grep -Fq "uuid-1" || {
  echo "linear issue parser did not return uuid" >&2
  exit 1
}

if printf '%s' "${success}" | LINEAR_EXPECTED_PROJECT="Wrong" "${ROOT}/onboarding/local-workspace/validate-linear-issue-response.sh" "P4Y-123" >/dev/null 2>&1; then
  echo "linear issue parser accepted wrong project" >&2
  exit 1
fi

if printf '%s' '{"errors":[{"message":"bad"}]}' | "${ROOT}/onboarding/local-workspace/validate-linear-issue-response.sh" "P4Y-123" >/dev/null 2>&1; then
  echo "linear issue parser accepted GraphQL errors" >&2
  exit 1
fi

printf '%s' '{"data":{"commentCreate":{"success":true,"comment":{"id":"c1","url":"https://linear.app/c1"}}}}' | "${ROOT}/onboarding/local-workspace/validate-linear-comment-response.sh" >/dev/null || {
  echo "linear comment parser rejected success" >&2
  exit 1
}

if printf '%s' '{"data":{"commentCreate":{"success":false}}}' | "${ROOT}/onboarding/local-workspace/validate-linear-comment-response.sh" >/dev/null 2>&1; then
  echo "linear comment parser accepted failed mutation" >&2
  exit 1
fi

echo "linear helper python parse tests passed"
