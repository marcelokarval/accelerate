# Workflow Adapter Capability Schema V2

## Purpose

Capability manifests state what a workflow adapter can safely do today. They are
truth manifests, not aspiration lists. A capability may be `native` only when the
repository has a concrete command surface and proof appropriate to that command.
Unproven remote writes remain `planned`, `blocked`, or `substitute`.

## File

Each adapter declares capabilities in:

```text
adapters/workflow/<adapter>/capabilities.yaml
```

## Required top-level fields

- `schema_version`: `2`
- `adapter`: directory-matching adapter id
- `status`: `implemented`, `planned`, or `blocked`
- `runtime_truth`: `local`, `remote`, `hybrid`, or `none`
- `substitute_evidence`: local fallback path or `none`

## Required capabilities

Every manifest must declare these exact capability keys:

- `read_lookup`
- `create_update`
- `review_artifact_attachment`
- `rehydration`
- `write_recovery`
- `closure_comment`
- `status_transition`
- `production_merge_land_gate`

Allowed capability values:

- `native`: implemented directly against the provider or local workflow truth.
- `linked`: provider-linked but completed by another governed surface.
- `substitute`: local Accelerate substitute evidence is the honest runtime path.
- `planned`: intended but not implemented/proven.
- `blocked`: cannot run until an explicit blocker is removed.
- `none`: intentionally unsupported.

## Required command/proof fields

Each capability must also declare:

- `<capability>_command`: repo-relative executable helper path or `none`.
- `<capability>_proof`: proof label/path, `local-substitute`, `dry-run-only`,
  `planned`, `blocked`, or `none`.

Rules:

1. `native`, `linked`, and `substitute` capabilities must not have an empty
   command/proof field.
2. `native` remote write capabilities require a registered command in
   `adapters/workflow/remote-write-registry.yaml` and non-`none` proof before an
   adapter can be `implemented`.
3. `planned`, `blocked`, and `none` capabilities must not claim live proof. Use
   `planned`, `blocked`, `dry-run-only`, or `none`.
4. Local substitute capabilities may use `.accelerate/workflow/` and proof value
   `local-substitute`.
5. GitHub PR create/update, closure comments, and production merge/land stay
   `planned` until live opt-in proof exists.

## Selection summary

`onboarding/local-workspace/read-workflow-capabilities.sh` prints the manifest
summary for one adapter. `onboarding/local-workspace/select-workflow-capability.sh`
selects one capability and fails closed when the adapter or capability is absent.
