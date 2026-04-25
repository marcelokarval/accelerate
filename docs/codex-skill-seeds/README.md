# Codex Skill Seeds

This directory is the historical migration record for governed Codex skills
used by standalone `accelerate`.

The accepted target structure is now implemented as the root-level `skills/`
directory. This `docs/codex-skill-seeds/` layer remains as audit trail for the
transition from global-only skills to self-contained local runtime skills.

## Files

| Path | Role |
| --- | --- |
| `skill-dependency-manifest.md` | Compact migration audit and pointers to active registry truth. |
| `skills/` | Historical transition index; full duplicated skill bodies were removed after root `skills/` became active. |

## Rule

Do not add a new mandatory skill reference to `core/`, `agents/`, `adapters/`,
`profiles/`, `references/`, or root docs without updating
`skill-dependency-manifest.md`.

The active state is:

- root `skills/` is source of truth
- runtime exports are optional generated deployment artifacts
- required runtime behavior does not depend on global-only skill bodies

Full pre-compaction inventories remain available through git history.
