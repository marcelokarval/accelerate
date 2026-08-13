# Host Export Contract

Host exports are generated outward from this repository. They are deployment
artifacts, not governing authority. If a generated export diverges from the
repository source, the repository source wins.

## Schema

Every host export must include this manifest shape:

```yaml
schema_version: 1
export_identity: accelerate-runtime-host-export
source_repository: accelerate
source_artifacts:
  - adapters/runtime/<host>/capabilities.yaml
target_host: <host>
target_path: <path>
generated_files:
  - <path>
authority: generated-export; repository remains source of truth
privacy_classification: public-repo-derived
suppressed_capabilities:
  - <capability|none>
rewritten_tools:
  - <tool-or-substitution|none>
validation_command: <command>
```

## Required Fields

- `schema_version`
- `export_identity`
- `source_repository`
- `source_artifacts`
- `target_host`
- `target_path`
- `generated_files`
- `authority`
- `privacy_classification`
- `suppressed_capabilities`
- `rewritten_tools`
- `validation_command`

## Enforcement Rules

1. Source artifacts must be repo-local paths.
2. Target host names may contain only lowercase letters, digits, and hyphens.
3. Relative target paths must stay under this repository; `..` path traversal is
   blocked.
4. Generated files must state they are generated outward only and not canonical
   doctrine.
5. Exports may describe planned or blocked runtime capabilities, but they must
   not claim promoted agents or implemented behavior without the source manifest
   saying so.
6. Validation must be explicit and runnable by a later operator.
7. A Codex catalog export may declare the two recovery profiles and logical
   specialist profiles, but it must not export internal raw catalog aliases.
   It must state that these are additive `-p` configuration layers, not technical
   skill/MCP/credential isolation or physical-agent promotion.

## Relationship To Agent Promotion

Host export can package runtime-host instructions or adapter manifests, but it
cannot promote, install, or create real physical agents. Agent install/export and
promotion states are governed by
[`agents/promotion/install-export-contract.md`](../../agents/promotion/install-export-contract.md).

## Failure Labels

- `host-export-schema-missing-field`
- `host-export-path-traversal`
- `host-export-authority-overclaim`
- `host-export-unknown-host`
- `host-export-missing-validation-command`
