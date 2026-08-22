#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

bash "$ROOT/scripts/validate-skill-registry.sh"
bash "$ROOT/tests/codex-skill-catalog-truth.sh"
pytest -q "$ROOT/tests/test_install_operational_skills.py"

for runtime in opencode agents codex hermes; do
  python3 "$ROOT/scripts/install-operational-skills.py" \
    --runtime "$runtime" --home "$tmp" --apply >/dev/null
  python3 "$ROOT/scripts/install-operational-skills.py" \
    --runtime "$runtime" --home "$tmp" >/dev/null
done

python3 - "$ROOT" "$tmp" <<'PY'
import importlib.util
import json
import pathlib
import sys

root, home = map(pathlib.Path, sys.argv[1:])
script = root / "scripts/install-operational-skills.py"
spec = importlib.util.spec_from_file_location("installer", script)
module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)
skills, targets = module.load_registry()
for runtime, suffix in targets.items():
    for name, source in skills.items():
        destination = home / suffix / name
        marker = json.loads((destination / module.MARKER).read_text())
        expected = module.tree_digest(source)
        assert marker["runtime"] == runtime
        assert marker["source_digest"] == expected
        assert module.tree_digest(destination) == expected
PY

printf 'operational skill projection truth passed\n'
