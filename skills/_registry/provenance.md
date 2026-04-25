# Skill Provenance Policy

Each skill should declare provenance because standalone `accelerate` contains a
mix of native, adapted, and externally sourced skills.

## Statuses

| Status | Meaning |
| --- | --- |
| `native` | Authored for standalone `accelerate`. |
| `adapted-from-runtime` | Imported from a runtime/user-home catalog and rewritten for local doctrine. |
| `adapted-from-external` | Sourced from internet or third-party material and normalized into the Accelerate contract. |
| `vendor-reference` | Kept as reference material only, not mandatory runtime law. |
| `overlay-only` | Project/domain-specific and not allowed to become universal core law without promotion. |

## Required Metadata

Each skill directory should include `metadata.yaml` with:

- `name`
- `category`
- `status`
- `source`
- `owner`
- `runtime_export`
- `local_native_owner`
- `adaptation_policy`
- `last_reviewed`

## Rule

Do not treat externally sourced material as authoritative until it has been
adapted, reviewed, and registered.
