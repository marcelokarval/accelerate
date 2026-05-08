# Skill Export Proof — 2026-05-08

## Scope

RC9 proves a repo-local source -> generated export artifact path without making
user-home runtime catalogs or generated bundles authoritative.

RC15 extends the same boundary to a temp/approved generated host-runtime target:
the proof copies only from repo-generated output, refuses user-home runtime
catalogs, records host drift status, and removes/restores the generated host copy
with rollback/cleanup proof. The generated host target remains a deployment proof
artifact, not source authority.

## Command

```bash
scripts/export-skill-proof.sh --output /tmp/accelerate-rc9-skill-export-proof --selected prompt-hardening,verification-before-completion --check-drift
```

Stale export verification command:

```bash
scripts/export-skill-proof.sh --output /tmp/accelerate-rc9-skill-export-proof --verify-existing --check-drift
```

Temp/approved generated host-runtime proof command:

```bash
scripts/export-skill-proof.sh --output /tmp/accelerate-rc15-skill-host-proof --selected prompt-hardening,verification-before-completion --host-runtime-target /tmp/accelerate-approved-generated-host-runtime --approve-generated-host-target --cleanup-host-target --check-drift
```

Contract test:

```bash
bash tests/skill-export-proof.sh
```

## Provenance Summary

- artifact_type: `accelerate-generated-skill-export-proof`
- authority: repo-local source only; generated export is not source truth
- source_root: `/home/marcelo-karval/Backup/Projetos/accelerate`
- source_commit: `11116d0d035c30ec351169b81a66c5f35bbcd77b`
- source_tree: `90e334ef0d9f4ff0fae3742942dffe403553cf15`
- selected_skill_set:
  - `prompt-hardening`
  - `verification-before-completion`
- generated_target: `/tmp/accelerate-rc15-skill-host-proof/generated-skill-export`
- generated_boundary: deployment/runtime export artifact; not governing documentation
- user_home_catalogs_authoritative: `false`
- forbidden authority examples:
  - `~/.claude/skills`
  - `~/.codex/skills`
  - `~/.agents/skills`
- included_file_count: `7`
- drift_detected: `false`
- note: `source_commit`/`source_tree` identify the Git HEAD used by the proof;
  the generated provenance also records dirty shared-worktree status for
  uncommitted RC13..RC17 cycle edits.

## Included Source Files

| Source | Export path | SHA-256 |
| --- | --- | --- |
| `SKILL.md` | `root/SKILL.md` | `a0701a9a78b82097fc085dddf1a0f1eb170fb10b54ec04d9b9c10b1505c461a0` |
| `README.md` | `root/README.md` | `82f208af10382ca13117fb7d9874f633527b51909bb116af045d9e56c514fdaf` |
| `skills/_registry/manifest.md` | `registry/manifest.md` | `32a3602aa67f9b4674d65bb607468ebc78ecdcbe87aed723e244b82cd19829c1` |
| `skills/root/prompt-hardening/SKILL.md` | `skills/prompt-hardening/SKILL.md` | `41c5df7897271e154a079ef7f5002cee0367e4049acdbd811af06cb5ecd2a5d5` |
| `skills/root/prompt-hardening/metadata.yaml` | `skills/prompt-hardening/metadata.yaml` | `795066dd4338854f97480de799de2ec249224f737eb1f285dcc9ff3ddd278ef0` |
| `skills/root/verification-before-completion/SKILL.md` | `skills/verification-before-completion/SKILL.md` | `182d47e087fb008ebffbd9341b28876b650504bd495fc1f399ddff3b4acf9eaa` |
| `skills/root/verification-before-completion/metadata.yaml` | `skills/verification-before-completion/metadata.yaml` | `08e783659cb4b790cc80fc88cafcd74ec4fd52014ab523fd794474cd98b9387a` |

## Drift Detection Result

`drift_detected: false` for the generated proof bundle. The contract test also
injects a stale edit into the generated export and verifies that
`--verify-existing --check-drift` fails with `content differs from repo source`.

## RC15 Host Runtime Boundary Result

The host proof is intentionally limited to an explicitly approved generated temp
target:

- artifact_type: `accelerate-generated-host-runtime-export-proof`
- authority: repo-local source only; generated host target is not source truth
- approved_generated_host_target: `true`
- temporary_or_generated_target_only: `true`
- host_drift_detected: `false`
- cleanup_requested: `true`
- cleanup_action: `removed generated host target`
- target_exists_after_cleanup: `false`
- user_home_catalogs_authoritative: `false`

The contract also proves two negative host boundaries:

1. `--host-runtime-target` fails unless paired with
   `--approve-generated-host-target`.
2. A simulated `HOME/.codex/skills/...` target is refused, without touching real
   `~/.codex/skills`, `~/.claude/skills`, or `~/.agents/skills`.

## Boundary / Residual

This proof promotes only the repo-local generated proof path and temp/approved
generated host-runtime boundary. It does not prove a real user-home host runtime
install, does not write to `~/.codex/skills`, `~/.claude/skills`, or
`~/.agents/skills`, and does not make generated output source authority. Real
host runtime export remains planned until an explicitly approved non-user-home
target is generated, verified, drift-checked, and cleaned up under the same
provenance/drift/rollback contract.
