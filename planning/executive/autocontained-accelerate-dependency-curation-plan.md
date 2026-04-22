# Autocontained Accelerate Dependency Curation Plan

## Status

This plan is now compacted because the migration it described has landed.

Current operating truth:

- root `SKILL.md` is the root-native Accelerate entrypoint
- root `skills/` is the authoring source for governed reusable skills
- `~/.codex/skills/` is a generated runtime mirror
- `docs/codex-skill-seeds/` is historical migration context only
- profile validation lives under `profiles/*/validation-bundle.md`
- persistent E2E fixtures live under `adapters/runtime/playwright/`
- domain eval fixtures live under the relevant `skills/data/*/evals/`

## Active Authorities

| Concern | Authority |
| --- | --- |
| Skill registry | `skills/_registry/manifest.md` |
| Skill sync policy | `skills/_registry/sync-policy.md` |
| Migration audit | `docs/codex-skill-seeds/skill-dependency-manifest.md` |
| Final global-only audit | `planning/executive/final-global-only-audit-result.md` |
| Root packaging decision | `planning/executive/accelerate-root-skill-packaging-decision.md` |
| Implementation result | `planning/executive/root-skills-structure-implementation-result.md` |

## Completed Migration

The completed migration established:

- 73 governed local skill bodies under root `skills/`
- repo-first sync into `~/.codex/skills/`
- validation scripts for registry and mirror drift
- design-system extraction and application skills
- backend, frontend, data, governance, review, runtime, security, workflow, and
  legacy skill categories
- Playwright scenario/proof fixtures
- Django/Inertia and Next/Tailwind validation bundles
- finance/payment/Stripe eval fixtures
- explicit replacement of `using-superpowers`
- explicit root-native exception for `accelerate`
- no blocking mandatory `global-only` governed skill

## Validation

Use:

```bash
bash scripts/validate-skill-registry.sh
bash scripts/check-global-skill-mirror.sh
git diff --check
```

## Remaining Work

Remaining work is no longer migration blocking:

- wire `scripts/check-global-skill-mirror.sh` into CI if this repository adopts
  a CI workflow
- expand eval fixtures as real failures appear
- keep `docs/codex-skill-seeds/` compact and non-authoritative
- continue pruning duplicated reference files only when a native home is already
  stronger

## Historical Note

Earlier revisions of this plan contained the full inventory, wave sequencing,
and global-only dependency tables. That detail is preserved in git history and
was intentionally removed from the live file to avoid stale operational truth.
