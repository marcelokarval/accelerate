# Local Workspace Entry Gate

This file is the supporting reference version of the native local-workspace
gate.

Primary authority lives in:

- `../core/control-plane/local-workspace-entry-gate.md`

Use this reference file when:

- a global runtime skill bundle needs a portable copy of the gate
- inherited doctrine is being compared against the native control-plane layer
- the active run is about runtime-mirror parity rather than native-layer edits

## Rule

When a governed target repository is in scope, root classification must decide
local workspace state before deeper branch execution.

The gate outcome must be one of:

- `no local workspace required yet`
- `first local install required`
- `existing local workspace can be reused`
- `light reentry required`
- `partial reonboarding required`
- `structural reonboarding required`

## Ordering

The local-workspace gate resolves before:

- issue bootstrap
- product/spec planning gates
- delegated execution
- mutation-bearing bounded work inside the governed target repo

When `.accelerate/` already exists, the preferred compact reentry read is:

- `review/handoff-summary.md`
- otherwise `read-local-handoff.sh`

## Minimum Visible Runtime Truth

When the gate is relevant, runtime packets should show:

- `.accelerate=<present|absent|n/a>`
- local workspace action
- readiness dashboard status when present
- timeline continuity when present
- durable learning registration posture when present
- onboarding status
- reentry status
- drift status
- governing local artifact when one exists

## Implementation Surface And Runtime Boundary

The local-workspace implementation is owned by the standalone Accelerate
source repository. The installed runtime skill intentionally does not contain
an `onboarding/` implementation tree. Never derive a local-workspace command
from this reference's parent directory or from the installed skill directory.

Resolve an allowlisted source-owned command through the portable resolver:

```bash
skill_root="${ACCELERATE_SKILL_ROOT:-${CODEX_HOME:-$HOME/.codex}/skills/accelerate}"
tool="$(python3 "$skill_root/scripts/resolve-local-workspace-tool.py" emit-v2.sh)"
"$tool" /path/to/target-repo adoption
```

The separately installed
`assets/local-workspace-source-trust.json` is the authority for accepted source
roots, origins, and immutable Git commits. `--source-root` and
`ACCELERATE_SOURCE_ROOT` may select only an entry already present in that
manifest; they cannot introduce trust. Without either selector, the resolver
uses the manifest entries directly. It never trusts the current repository or
its parents implicitly, and it expands `${USER_HOME}` from the operating-system
account rather than caller-controlled `HOME`.

The resolver requires the exact manifest-pinned checkout root, commit and Git
origin, plus `AGENTS.md`, the expected skill identity files, and an allowlisted
executable regular file. The complete tool path must have no symlinked
component, and the tool bytes and executable mode must match the pinned `HEAD`.
Unsupported tool names are rejected.

Supported entry tools are:

- `emit-v2.sh`
- `detect-signals.sh`
- `classify-project.sh`
- `bootstrap-or-reentry.sh`
- `validate-v2.sh`

If resolution fails, report `Accelerate source checkout unavailable` and stop
that bootstrap path. Do not label the failure as a sandbox denial, guess a
user-home path, or call a nonexistent path under `~/.codex/skills`.
