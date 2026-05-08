# Skill Export Proof — 2026-05-08

## Scope

RC9 proves a repo-local source -> generated export artifact path without making
user-home runtime catalogs or generated bundles authoritative.

## Command

```bash
scripts/export-skill-proof.sh --output /tmp/accelerate-rc9-skill-export-proof --selected prompt-hardening,verification-before-completion --check-drift
```

Stale export verification command:

```bash
scripts/export-skill-proof.sh --output /tmp/accelerate-rc9-skill-export-proof --verify-existing --check-drift
```

Contract test:

```bash
bash tests/skill-export-proof.sh
```

## Provenance Summary

- artifact_type: `accelerate-generated-skill-export-proof`
- authority: repo-local source only; generated export is not source truth
- source_root: `/home/marcelo-karval/Backup/Projetos/accelerate`
- source_commit: `86036a60679cd36aa9a228078885c33c0b2b7c9a`
- source_tree: `98058542a84effe5e0e6d607169625a19c6376c1`
- selected_skill_set:
  - `prompt-hardening`
  - `verification-before-completion`
- generated_target: `/tmp/accelerate-rc9-skill-export-proof/generated-skill-export`
- generated_boundary: deployment/runtime export artifact; not governing documentation
- user_home_catalogs_authoritative: `false`
- forbidden authority examples:
  - `~/.claude/skills`
  - `~/.codex/skills`
  - `~/.agents/skills`
- included_file_count: `7`
- drift_detected: `false`

## Included Source Files

| Source | Export path | SHA-256 |
| --- | --- | --- |
| `SKILL.md` | `root/SKILL.md` | `a0701a9a78b82097fc085dddf1a0f1eb170fb10b54ec04d9b9c10b1505c461a0` |
| `README.md` | `root/README.md` | `82f208af10382ca13117fb7d9874f633527b51909bb116af045d9e56c514fdaf` |
| `skills/_registry/manifest.md` | `registry/manifest.md` | `7bfdfd984c42239fd841c378737db5609eef871419a6ee496a5deac5d4bdd577` |
| `skills/root/prompt-hardening/SKILL.md` | `skills/prompt-hardening/SKILL.md` | `41c5df7897271e154a079ef7f5002cee0367e4049acdbd811af06cb5ecd2a5d5` |
| `skills/root/prompt-hardening/metadata.yaml` | `skills/prompt-hardening/metadata.yaml` | `795066dd4338854f97480de799de2ec249224f737eb1f285dcc9ff3ddd278ef0` |
| `skills/root/verification-before-completion/SKILL.md` | `skills/verification-before-completion/SKILL.md` | `182d47e087fb008ebffbd9341b28876b650504bd495fc1f399ddff3b4acf9eaa` |
| `skills/root/verification-before-completion/metadata.yaml` | `skills/verification-before-completion/metadata.yaml` | `08e783659cb4b790cc80fc88cafcd74ec4fd52014ab523fd794474cd98b9387a` |

## Drift Detection Result

`drift_detected: false` for the generated proof bundle. The contract test also
injects a stale edit into the generated export and verifies that
`--verify-existing --check-drift` fails with `content differs from repo source`.

## Boundary / Residual

This proof promotes only the repo-local generated proof path. It does not prove a
host runtime install, does not write to `~/.codex/skills`, `~/.claude/skills`, or
`~/.agents/skills`, and does not make generated output source authority. Host
runtime export remains planned until an explicitly approved target is generated,
verified, and cleaned up under the same provenance/drift contract.
