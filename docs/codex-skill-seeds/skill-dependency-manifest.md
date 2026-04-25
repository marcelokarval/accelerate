# Accelerate Skill Dependency Manifest

This file is now a compact migration audit.

The active skill registry lives in:

- `../../skills/_registry/manifest.md`

The root skill packaging decision lives in:

- `../../planning/executive/accelerate-root-skill-packaging-decision.md`

The final global-only audit lives in:

- `../../planning/executive/final-global-only-audit-result.md`

## Current State

| Class | Status |
| --- | --- |
| Root `accelerate` | `root-native exception`; root `SKILL.md` is authoritative and is not duplicated under `skills/root/accelerate/`. |
| Governed reusable skills | `local-authoritative` under root `skills/`. |
| Runtime export | optional generated deployment artifact, never source authority. |
| `using-superpowers` | intentionally replaced by root `accelerate`; not promoted. |
| Former `role-only` phrases | resolved into concrete backend/frontend/workflow/runtime/domain bundles. |
| Persistent E2E proof | resolved through `adapters/runtime/playwright/` fixtures plus runtime proof skills. |

## Active Local Skill Count

Root `skills/` currently owns 75 governed reusable skill bodies.

Validate with:

```bash
bash scripts/validate-skill-registry.sh
bash scripts/check-global-skill-mirror.sh
```

## Historical Note

Earlier revisions of this file contained the full global-only inventory used to
drive the migration. That long inventory is preserved in git history. It is no
longer kept inline because it duplicated current registry truth and made this
transition layer look authoritative.
