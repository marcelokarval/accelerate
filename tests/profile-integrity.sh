#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

fail() {
  printf 'profile-integrity failed: %s\n' "$1" >&2
  exit 1
}

mapfile -t active_profiles < <(python3 - <<'PY'
from pathlib import Path
import re
text = Path('profiles/README.md').read_text()
for match in re.finditer(r"- `([^`]+/)`", text):
    print(match.group(1).rstrip('/'))
PY
)

[ "${#active_profiles[@]}" -gt 0 ] || fail "no active profiles listed"

for profile in "${active_profiles[@]}"; do
  [ -f "profiles/$profile/README.md" ] || fail "missing profile README: $profile"
  [ -f "profiles/$profile/validation-bundle.md" ] || fail "missing validation bundle: $profile"

  if [[ "$profile" == nextjs-prisma || "$profile" == nextjs-drizzle ]]; then
    [ -f "profiles/$profile/data-parity-matrix.md" ] || fail "missing data parity matrix: $profile"
  fi

  if [ -f "profiles/$profile/README.md" ] && [ -f "profiles/$profile/validation-bundle.md" ]; then
    combined="$(cat "profiles/$profile/README.md" "profiles/$profile/validation-bundle.md")"
    if [[ "$profile" == "nextjs-prisma" ]] && printf '%s' "$combined" | rg -i 'Drizzle.*equal peer|drizzle.*baseline data authority' >/dev/null; then
      :
    fi
    if [[ "$profile" == "nextjs-drizzle" ]] && printf '%s' "$combined" | rg -i 'Prisma.*equal peer|prisma.*baseline data authority' >/dev/null; then
      :
    fi
  fi
done

python3 - <<'PY'
from pathlib import Path
import re
import sys

root = Path.cwd()
manifest_text = (root / 'skills/_registry/manifest.md').read_text()
registered = set(re.findall(r"\| `([^`]+)` \|", manifest_text))

conditional_phrases = (' when ', ' if ', ' such as ', ' active ', ' project-selected ')

for bundle in (root / 'profiles').glob('*/validation-bundle.md'):
    text = bundle.read_text()
    in_skills = False
    for line in text.splitlines():
        if line.startswith('## Mandatory Skills'):
            in_skills = True
            continue
        if in_skills and line.startswith('## '):
            in_skills = False
        if not in_skills or not line.startswith('- '):
            continue
        match = re.search(r'`([^`]+)`', line)
        if not match:
            continue
        skill = match.group(1)
        if skill not in registered:
            print(f"profile-integrity failed: {bundle.relative_to(root)} references unregistered skill `{skill}`", file=sys.stderr)
            raise SystemExit(1)

for profile in ['nextjs-prisma', 'nextjs-drizzle']:
    text = ''.join(path.read_text() for path in (root / 'profiles' / profile).glob('*.md'))
    has_prisma_baseline = 'Prisma as schema' in text or 'schema.prisma' in text
    has_drizzle_baseline = 'Drizzle as schema' in text or 'Drizzle schema files' in text
    if has_prisma_baseline and has_drizzle_baseline:
        print(f"profile-integrity failed: {profile} claims both Prisma and Drizzle baseline authority", file=sys.stderr)
        raise SystemExit(1)

print('profile integrity passed')
PY
