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

## Minimum Visible Runtime Truth

When the gate is relevant, runtime packets should show:

- `.accelerate=<present|absent|n/a>`
- local workspace action
- onboarding status
- reentry status
- drift status
- governing local artifact when one exists

## Implementation Surface

Current pre-agents implementation lives in:

- `../onboarding/local-workspace/emit-v2.sh`
- `../onboarding/local-workspace/detect-signals.sh`
- `../onboarding/local-workspace/classify-project.sh`
- `../onboarding/local-workspace/bootstrap-or-reentry.sh`
- `../onboarding/local-workspace/validate-v2.sh`
