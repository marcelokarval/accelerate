#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

catalog="adapters/runtime/codex/skill-catalog-manifest.toml"
topology="adapters/runtime/codex/logical-agent-topology.toml"
sandbox="$(mktemp -d)"
trap 'rm -rf "$sandbox"' EXIT

snapshot_home() {
  local home="$1" output="$2"
  python3 - "$home" "$output" <<'PY'
import hashlib
import json
import os
import stat
import sys
from pathlib import Path

home = Path(sys.argv[1])
state = []
for path in sorted(home.rglob("*")):
    relative = path.relative_to(home)
    if relative == Path(".codex-runtime-mutation.lock"):
        continue
    metadata = path.lstat()
    entry = {"path": str(relative), "mode": stat.S_IMODE(metadata.st_mode)}
    if stat.S_ISREG(metadata.st_mode):
        entry["kind"] = "file"
        entry["sha256"] = hashlib.sha256(path.read_bytes()).hexdigest()
    elif stat.S_ISDIR(metadata.st_mode):
        entry["kind"] = "directory"
    elif stat.S_ISLNK(metadata.st_mode):
        entry["kind"] = "symlink"
        entry["target"] = os.readlink(path)
    else:
        entry["kind"] = "other"
    state.append(entry)
Path(sys.argv[2]).write_text(json.dumps(state, sort_keys=True, separators=(",", ":")) + "\n")
PY
}

old_logical_catalog="$sandbox/old-logical-catalog.toml"
raw_alias_catalog="$sandbox/raw-alias-catalog.toml"
python3 - "$catalog" "$old_logical_catalog" "$raw_alias_catalog" <<'PY'
import sys
from pathlib import Path

source = Path(sys.argv[1]).read_text()
old_logical = source.replace(
    '  "database-architect", "database-design", "drizzle-patterns",\n',
    '  "database-design", "drizzle-patterns",\n',
    1,
)
old_logical = old_logical.replace("runtime_skill_count = 131", "runtime_skill_count = 130", 1)
if old_logical == source:
    raise SystemExit("fixture setup failed: data-db catalog member was not removed")
Path(sys.argv[2]).write_text(old_logical)

raw_alias = source.replace(
    'id = "django-backend"\nsource = "r0"\nclassification = "specialist"\nprofile = "django-backend"\npublic_profile = false\nenabled_by_default = false\n',
    'id = "django-backend"\nsource = "r0"\nclassification = "on-demand"\nprofile = "django-backend"\npublic_profile = true\nenabled_by_default = false\nrecovery_route = "skill-catalog-router"\n',
    1,
)
if raw_alias == source:
    raise SystemExit("fixture setup failed: django raw alias was not made public")
Path(sys.argv[3]).write_text(raw_alias)
PY

seed_catalog_owned_raw_alias() {
  local target_home="$1"
  python3 scripts/install-codex-skill-catalog.py "$raw_alias_catalog" \
    --codex-home "$target_home" \
    --logical-topology "$topology" >/dev/null
}

# G10-F1 RED: inject a late failure only at catalog receipt publication. Every
# prior governed byte and mode, the old receipt, and the absence of transaction
# temp/backup residue must survive exactly.
publication_home="$sandbox/publication-home"
python3 scripts/install-codex-skill-catalog.py "$catalog" \
  --codex-home "$publication_home" --logical-topology "$topology" >/dev/null
printf '\n# force catalog reconciliation before late publication failure\n' \
  >>"$publication_home/config.toml"
chmod 0640 "$publication_home/config.toml"
publication_fault="$sandbox/publication-fault"
mkdir "$publication_fault"
cat >"$publication_fault/sitecustomize.py" <<'PY'
import os

original_replace = os.replace
target = os.environ.get("CODEX_TEST_FAIL_REPLACE_TARGET")

def fail_catalog_receipt_publication(source, destination, *args, **kwargs):
    if target is not None and os.fspath(destination) == target:
        raise OSError("injected catalog receipt publication failure")
    return original_replace(source, destination, *args, **kwargs)

os.replace = fail_catalog_receipt_publication
PY
snapshot_home "$publication_home" "$sandbox/g10-f1-before.json"
if PYTHONPATH="$publication_fault" \
  CODEX_TEST_FAIL_REPLACE_TARGET="$publication_home/skill-catalog-install-receipt.json" \
  python3 scripts/install-codex-skill-catalog.py "$catalog" \
    --codex-home "$publication_home" --logical-topology "$topology" \
    >"$sandbox/g10-f1.out" 2>&1; then
  printf 'catalog installer ownership failed: injected receipt publication failure was accepted\n' >&2
  exit 1
fi
snapshot_home "$publication_home" "$sandbox/g10-f1-after.json"
cmp -s "$sandbox/g10-f1-before.json" "$sandbox/g10-f1-after.json" || {
  printf 'catalog installer ownership failed: late receipt publication failure caused partial mutation or residue\n' >&2
  exit 1
}

# G10-F2 RED: a receipt is an ownership authority and cannot have a second
# hardlink identity, even when its bytes and mode are otherwise current.
catalog_receipt_hardlink_home="$sandbox/catalog-receipt-hardlink-home"
python3 scripts/install-codex-skill-catalog.py "$catalog" \
  --codex-home "$catalog_receipt_hardlink_home" --logical-topology "$topology" >/dev/null
ln "$catalog_receipt_hardlink_home/skill-catalog-install-receipt.json" \
  "$sandbox/catalog-receipt-hardlink-peer.json"
snapshot_home "$catalog_receipt_hardlink_home" "$sandbox/g10-f2-catalog-before.json"
if python3 scripts/install-codex-skill-catalog.py "$catalog" \
  --codex-home "$catalog_receipt_hardlink_home" --logical-topology "$topology" \
  >"$sandbox/g10-f2-catalog.out" 2>&1; then
  printf 'catalog installer ownership failed: hardlinked catalog receipt was accepted\n' >&2
  exit 1
fi
snapshot_home "$catalog_receipt_hardlink_home" "$sandbox/g10-f2-catalog-after.json"
cmp -s "$sandbox/g10-f2-catalog-before.json" "$sandbox/g10-f2-catalog-after.json" || {
  printf 'catalog installer ownership failed: hardlinked catalog receipt rejection mutated state\n' >&2
  exit 1
}

# G10-F3 RED: the declared rollback directory is the unique history container.
# Backups cannot remain in one transaction directory while the receipt points
# at another otherwise-valid sibling below CODEX_HOME/backups.
logical_rollback_identity_home="$sandbox/logical-rollback-identity-home"
python3 scripts/install-codex-skill-catalog.py "$catalog" \
  --codex-home "$logical_rollback_identity_home" --logical-topology "$topology" >/dev/null
python3 scripts/install-codex-logical-agents.py "$topology" "$catalog" \
  --codex-home "$logical_rollback_identity_home" >/dev/null
alternate_rollback="$logical_rollback_identity_home/backups/logical-agents-alternate"
mkdir "$alternate_rollback"
chmod 0700 "$alternate_rollback"
python3 - "$logical_rollback_identity_home/logical-agent-install-receipt.json" \
  "$alternate_rollback" <<'PY'
import json
import sys
from pathlib import Path

path = Path(sys.argv[1])
receipt = json.loads(path.read_text())
if not any(entry.get("backup") for entry in receipt["installed"]):
    raise SystemExit("G10-F3 fixture lacks logical backup history")
receipt["rollback_directory"] = str(Path(sys.argv[2]).resolve())
path.write_text(json.dumps(receipt, indent=2, sort_keys=True) + "\n")
PY
snapshot_home "$logical_rollback_identity_home" "$sandbox/g10-f3-before.json"
if python3 scripts/install-codex-skill-catalog.py "$catalog" \
  --codex-home "$logical_rollback_identity_home" --logical-topology "$topology" \
  >"$sandbox/g10-f3-catalog.out" 2>&1; then
  printf 'catalog installer ownership failed: mismatched logical rollback directory was accepted\n' >&2
  exit 1
fi
snapshot_home "$logical_rollback_identity_home" "$sandbox/g10-f3-after.json"
cmp -s "$sandbox/g10-f3-before.json" "$sandbox/g10-f3-after.json" || {
  printf 'catalog installer ownership failed: rollback identity rejection mutated state\n' >&2
  exit 1
}

# Invalid governing input must be rejected before touching the target home.
invalid_topology="$sandbox/invalid-topology.toml"
cp "$topology" "$invalid_topology"
sed -i 's/topology_identity = "codex-logical-agent-topology"/topology_identity = "invalid"/' "$invalid_topology"
invalid_home="$sandbox/invalid-home"
mkdir "$invalid_home"
printf '# must survive rejected topology\n' >"$invalid_home/config.toml"
if python3 scripts/install-codex-skill-catalog.py "$catalog" \
  --codex-home "$invalid_home" \
  --logical-topology "$invalid_topology" >/dev/null 2>&1; then
  printf 'catalog installer ownership failed: invalid logical topology was accepted\n' >&2
  exit 1
fi
cmp -s "$invalid_home/config.toml" <(printf '# must survive rejected topology\n') || {
  printf 'catalog installer ownership failed: rejected topology mutated Codex home\n' >&2
  exit 1
}

# An unproven hidden profile is ambiguous: it must fail before any catalog file
# or receipt is installed, and the candidate must remain byte-identical.
ambiguous_home="$sandbox/ambiguous-home"
mkdir "$ambiguous_home"
printf '# ambiguous config sentinel\n' >"$ambiguous_home/config.toml"
printf '# unproven profile payload\n' >"$ambiguous_home/django-backend.config.toml"
cp "$ambiguous_home/config.toml" "$sandbox/ambiguous-config.before"
cp "$ambiguous_home/django-backend.config.toml" "$sandbox/ambiguous-profile.before"
if python3 scripts/install-codex-skill-catalog.py "$catalog" \
  --codex-home "$ambiguous_home" \
  --logical-topology "$topology" >/dev/null 2>&1; then
  printf 'catalog installer ownership failed: ambiguous hidden profile was accepted\n' >&2
  exit 1
fi
cmp -s "$sandbox/ambiguous-config.before" "$ambiguous_home/config.toml" || {
  printf 'catalog installer ownership failed: ambiguous rejection mutated config.toml\n' >&2
  exit 1
}
cmp -s "$sandbox/ambiguous-profile.before" "$ambiguous_home/django-backend.config.toml" || {
  printf 'catalog installer ownership failed: ambiguous rejection mutated the profile\n' >&2
  exit 1
}
for unexpected in on-demand.config.toml superpowers-on-demand.config.toml skill-catalog-install-receipt.json; do
  if [ -e "$ambiguous_home/$unexpected" ]; then
    printf 'catalog installer ownership failed: ambiguous rejection created %s\n' "$unexpected" >&2
    exit 1
  fi
done

# A profile previously rendered and receipted by the catalog is proven raw
# catalog ownership and may be retired when the profile becomes internal.
raw_home="$sandbox/raw-home"
seed_catalog_owned_raw_alias "$raw_home"
test -f "$raw_home/django-backend.config.toml"
python3 scripts/install-codex-skill-catalog.py "$catalog" \
  --codex-home "$raw_home" \
  --logical-topology "$topology" >/dev/null
if [ -e "$raw_home/django-backend.config.toml" ]; then
  printf 'catalog installer ownership failed: proven raw alias survived retirement\n' >&2
  exit 1
fi
python3 - "$raw_home/skill-catalog-install-receipt.json" <<'PY'
import json
import sys
from pathlib import Path

receipt = json.loads(Path(sys.argv[1]).read_text())
if receipt.get("schema_version") != 2:
    raise SystemExit("catalog installer ownership failed: receipt schema is not v2")
retired = {entry.get("profile"): entry for entry in receipt.get("retired_profiles", [])}
entry = retired.get("django-backend")
if not entry or entry.get("previous_owner") != "catalog" or len(entry.get("sha256", "")) != 64:
    raise SystemExit("catalog installer ownership failed: raw retirement lacks explicit provenance")
PY

# A catalog receipt does not authorize changed bytes. Digest drift makes the
# target ambiguous and must fail before replacing any installed catalog file.
tampered_home="$sandbox/tampered-home"
seed_catalog_owned_raw_alias "$tampered_home"
printf '# post-receipt mutation\n' >>"$tampered_home/django-backend.config.toml"
cp "$tampered_home/config.toml" "$sandbox/tampered-config.before"
cp "$tampered_home/django-backend.config.toml" "$sandbox/tampered-profile.before"
if python3 scripts/install-codex-skill-catalog.py "$catalog" \
  --codex-home "$tampered_home" \
  --logical-topology "$topology" >/dev/null 2>&1; then
  printf 'catalog installer ownership failed: changed catalog-owned content was accepted\n' >&2
  exit 1
fi
cmp -s "$sandbox/tampered-config.before" "$tampered_home/config.toml" || {
  printf 'catalog installer ownership failed: changed-content rejection mutated config.toml\n' >&2
  exit 1
}
cmp -s "$sandbox/tampered-profile.before" "$tampered_home/django-backend.config.toml" || {
  printf 'catalog installer ownership failed: changed-content rejection mutated profile\n' >&2
  exit 1
}

# Receipt targets are data, not authority. A path-escaping provenance claim is
# rejected before any target mutation, even when the candidate digest matches.
escape_home="$sandbox/escape-home"
seed_catalog_owned_raw_alias "$escape_home"
cp "$escape_home/config.toml" "$sandbox/escape-config.before"
cp "$escape_home/django-backend.config.toml" "$sandbox/escape-profile.before"
python3 - "$escape_home/skill-catalog-install-receipt.json" "$sandbox/outside.config.toml" <<'PY'
import json
import sys
from pathlib import Path

receipt_path = Path(sys.argv[1])
receipt = json.loads(receipt_path.read_text())
for entry in receipt["profile_ownership"]:
    if entry["profile"] == "django-backend":
        entry["target"] = str(Path(sys.argv[2]).resolve())
        break
else:
    raise SystemExit("fixture setup failed: django ownership record is missing")
receipt_path.write_text(json.dumps(receipt, indent=2, sort_keys=True) + "\n")
PY
if python3 scripts/install-codex-skill-catalog.py "$catalog" \
  --codex-home "$escape_home" \
  --logical-topology "$topology" >/dev/null 2>&1; then
  printf 'catalog installer ownership failed: path-escaping provenance was accepted\n' >&2
  exit 1
fi
cmp -s "$sandbox/escape-config.before" "$escape_home/config.toml" || {
  printf 'catalog installer ownership failed: escaped receipt rejection mutated config.toml\n' >&2
  exit 1
}
cmp -s "$sandbox/escape-profile.before" "$escape_home/django-backend.config.toml" || {
  printf 'catalog installer ownership failed: escaped receipt rejection mutated profile\n' >&2
  exit 1
}

# G4-F1: shape plus a backdated mtime is not ownership. A logical receipt must
# bind the exact installed profile bytes, so an injected path cannot be
# preserved and re-receipted by a later standalone catalog install.
forged_logical_home="$sandbox/forged-logical-home"
python3 scripts/install-codex-skill-catalog.py "$catalog" \
  --codex-home "$forged_logical_home" \
  --logical-topology "$topology" >/dev/null
python3 scripts/install-codex-logical-agents.py "$topology" "$catalog" \
  --codex-home "$forged_logical_home" >/dev/null
python3 - "$forged_logical_home/data-db.config.toml" \
  "$forged_logical_home/logical-agent-install-receipt.json" <<'PY'
import os
import sys
from pathlib import Path

target = Path(sys.argv[1])
receipt = Path(sys.argv[2])
body = target.read_text()
governed = '/home/marcelo-karval/.codex/skills/database-architect/SKILL.md'
outside = '/tmp/outside-governed-catalog/SKILL.md'
if governed not in body:
    raise SystemExit("fixture setup failed: governed data skill path is missing")
target.write_text(body.replace(governed, outside, 1))
backdated = max(1, receipt.stat().st_mtime_ns - 10_000_000)
os.utime(target, ns=(backdated, backdated))
PY
for artifact in config.toml on-demand.config.toml superpowers-on-demand.config.toml \
  data-db.config.toml skill-catalog-install-receipt.json logical-agent-install-receipt.json; do
  cp "$forged_logical_home/$artifact" "$sandbox/forged-$artifact.before"
done
if python3 scripts/install-codex-skill-catalog.py "$catalog" \
  --codex-home "$forged_logical_home" \
  --logical-topology "$topology" >/dev/null 2>&1; then
  printf 'catalog installer ownership failed: tampered backdated logical profile was accepted\n' >&2
  exit 1
fi
for artifact in config.toml on-demand.config.toml superpowers-on-demand.config.toml \
  data-db.config.toml skill-catalog-install-receipt.json logical-agent-install-receipt.json; do
  cmp -s "$sandbox/forged-$artifact.before" "$forged_logical_home/$artifact" || {
    printf 'catalog installer ownership failed: forged logical rejection mutated %s\n' "$artifact" >&2
    exit 1
  }
done

logical_receipt_escape_home="$sandbox/logical-receipt-escape-home"
python3 scripts/install-codex-skill-catalog.py "$catalog" \
  --codex-home "$logical_receipt_escape_home" \
  --logical-topology "$topology" >/dev/null
python3 scripts/install-codex-logical-agents.py "$topology" "$catalog" \
  --codex-home "$logical_receipt_escape_home" >/dev/null
python3 - "$logical_receipt_escape_home/logical-agent-install-receipt.json" <<'PY'
import json
import sys
from pathlib import Path

path = Path(sys.argv[1])
receipt = json.loads(path.read_text())
for entry in receipt["installed"]:
    if entry["agent"] == "data-db":
        entry["target"] = "/tmp/outside-governed-catalog/data-db.config.toml"
        break
else:
    raise SystemExit("fixture setup failed: data-db logical receipt entry is missing")
path.write_text(json.dumps(receipt, indent=2, sort_keys=True) + "\n")
PY
for artifact in config.toml data-db.config.toml logical-agent-install-receipt.json; do
  cp "$logical_receipt_escape_home/$artifact" "$sandbox/logical-escape-$artifact.before"
done
if python3 scripts/install-codex-skill-catalog.py "$catalog" \
  --codex-home "$logical_receipt_escape_home" \
  --logical-topology "$topology" >/dev/null 2>&1; then
  printf 'catalog installer ownership failed: escaping logical receipt target was accepted\n' >&2
  exit 1
fi
for artifact in config.toml data-db.config.toml logical-agent-install-receipt.json; do
  cmp -s "$sandbox/logical-escape-$artifact.before" "$logical_receipt_escape_home/$artifact" || {
    printf 'catalog installer ownership failed: logical receipt rejection mutated %s\n' "$artifact" >&2
    exit 1
  }
done

# A profile installed by the logical installer under an older catalog remains
# logical-owned even though its bytes are stale under the new catalog. The
# catalog checker accepts ownership, the logical checker reports staleness, and
# the logical installer performs the upgrade.
logical_home="$sandbox/logical-home"
python3 scripts/install-codex-skill-catalog.py "$old_logical_catalog" \
  --codex-home "$logical_home" \
  --logical-topology "$topology" >/dev/null
python3 scripts/install-codex-logical-agents.py "$topology" "$old_logical_catalog" \
  --codex-home "$logical_home" >/dev/null
cp "$logical_home/data-db.config.toml" "$sandbox/data-db.old-logical"

python3 scripts/install-codex-skill-catalog.py "$catalog" \
  --codex-home "$logical_home" \
  --logical-topology "$topology" >/dev/null
cmp -s "$sandbox/data-db.old-logical" "$logical_home/data-db.config.toml" || {
  printf 'catalog installer ownership failed: stale logical-owned profile was changed\n' >&2
  exit 1
}
python3 scripts/check-codex-skill-catalog-install.py "$catalog" \
  --codex-home "$logical_home" \
  --logical-topology "$topology" >/dev/null
if python3 scripts/check-codex-logical-agent-install.py "$topology" "$catalog" \
  --codex-home "$logical_home" --agent data-db >/dev/null 2>&1; then
  printf 'catalog installer ownership failed: logical checker accepted stale profile\n' >&2
  exit 1
fi

python3 scripts/install-codex-logical-agents.py "$topology" "$catalog" \
  --codex-home "$logical_home" >/dev/null
if cmp -s "$sandbox/data-db.old-logical" "$logical_home/data-db.config.toml"; then
  printf 'catalog installer ownership failed: logical installer did not upgrade stale profile\n' >&2
  exit 1
fi
python3 scripts/check-codex-logical-agent-install.py "$topology" "$catalog" \
  --codex-home "$logical_home" --agent data-db >/dev/null

for artifact in config.toml on-demand.config.toml superpowers-on-demand.config.toml data-db.config.toml integrations-ops.config.toml; do
  cp "$logical_home/$artifact" "$sandbox/$artifact.before"
done
python3 scripts/install-codex-skill-catalog.py "$catalog" \
  --codex-home "$logical_home" \
  --logical-topology "$topology" >/dev/null
python3 scripts/install-codex-skill-catalog.py "$catalog" \
  --codex-home "$logical_home" \
  --logical-topology "$topology" >/dev/null
for artifact in config.toml on-demand.config.toml superpowers-on-demand.config.toml data-db.config.toml integrations-ops.config.toml; do
  cmp -s "$sandbox/$artifact.before" "$logical_home/$artifact" || {
    printf 'catalog installer ownership failed: repeated install drifted %s\n' "$artifact" >&2
    exit 1
  }
done

python3 - "$logical_home/skill-catalog-install-receipt.json" "$topology" "$logical_home" <<'PY'
import hashlib
import json
import sys
from pathlib import Path

receipt = json.loads(Path(sys.argv[1]).read_text())
topology = Path(sys.argv[2])
home = Path(sys.argv[3]).resolve()
if receipt.get("schema_version") != 2:
    raise SystemExit("catalog installer ownership failed: final receipt schema is not v2")
if receipt.get("logical_topology_sha256") != hashlib.sha256(topology.read_bytes()).hexdigest():
    raise SystemExit("catalog installer ownership failed: receipt topology digest is stale")
expected_preserved = ["data-db", "integrations-ops"]
if receipt.get("preserved_logical_profiles") != expected_preserved:
    raise SystemExit(
        "catalog installer ownership failed: receipt omitted logical ownership "
        f"{receipt.get('preserved_logical_profiles')!r}"
    )
ownership = {entry["profile"]: entry for entry in receipt.get("profile_ownership", [])}
for profile in expected_preserved:
    entry = ownership.get(profile)
    expected_target = home / f"{profile}.config.toml"
    if not entry or entry.get("owner") != "logical" or Path(entry.get("target", "")) != expected_target:
        raise SystemExit(f"catalog installer ownership failed: explicit logical owner missing for {profile}")
    if len(entry.get("sha256", "")) != 64:
        raise SystemExit(f"catalog installer ownership failed: profile digest missing for {profile}")
retired = {entry.get("profile") for entry in receipt.get("retired_profiles", [])}
if retired & set(expected_preserved):
    raise SystemExit("catalog installer ownership failed: receipt retired a logical-owned target")
PY

printf 'codex skill catalog installer ownership passed\n'
