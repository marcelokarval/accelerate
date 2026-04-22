# Root Skills Structure Implementation Result

Date: 2026-04-22

## Scope

Implemented the first executable slice of the autocontained Accelerate
dependency curation plan.

This slice does not claim full autocontainment. It establishes the root
`skills/` source-of-truth structure, promotes the existing governed
design-system skills into that structure, and adds validation/sync mechanics.

## Changes

Created root skill source:

- `skills/README.md`
- `skills/_registry/README.md`
- `skills/_registry/manifest.md`
- `skills/_registry/provenance.md`
- `skills/_registry/sync-policy.md`
- `skills/design-system/README.md`
- `skills/design-system/extract-html-design-system-v2/SKILL.md`
- `skills/design-system/extract-html-design-system-v2/metadata.yaml`
- `skills/design-system/apply-design-system-contract/SKILL.md`
- `skills/design-system/apply-design-system-contract/metadata.yaml`

Promoted P0 imported baselines:

- `skills/root/prompt-hardening/SKILL.md`
- `skills/root/prompt-hardening/metadata.yaml`
- `skills/root/verification-before-completion/SKILL.md`
- `skills/root/verification-before-completion/metadata.yaml`
- `skills/review/product-runtime-review/SKILL.md`
- `skills/review/product-runtime-review/metadata.yaml`
- `skills/review/systematic-debugging/SKILL.md`
- `skills/review/systematic-debugging/metadata.yaml`
- `skills/review/architecture/SKILL.md`
- `skills/review/architecture/metadata.yaml`
- `skills/governance/governance-audit/SKILL.md`
- `skills/governance/governance-audit/metadata.yaml`

Added tooling:

- `scripts/validate-skill-registry.sh`
- `scripts/sync-skills-to-global.sh`

Updated transitional docs:

- `docs/codex-skill-seeds/README.md`
- `docs/codex-skill-seeds/skills/README.md`
- `docs/codex-skill-seeds/skill-dependency-manifest.md`
- `planning/executive/autocontained-accelerate-dependency-curation-plan.md`

Removed the deprecated UI-library references from governed Accelerate
documentation.

## Verification

Commands passed:

- `bash scripts/validate-skill-registry.sh`
- `bash scripts/sync-skills-to-global.sh`
- repo skill-to-global mirror comparison for all local `SKILL.md` and
  `metadata.yaml` files
- `cmp skills/design-system/extract-html-design-system-v2/SKILL.md /home/marcelo-karval/.codex/skills/extract-html-design-system-v2/SKILL.md`
- `cmp skills/design-system/apply-design-system-contract/SKILL.md /home/marcelo-karval/.codex/skills/apply-design-system-contract/SKILL.md`
- `cmp skills/design-system/extract-html-design-system-v2/metadata.yaml /home/marcelo-karval/.codex/skills/extract-html-design-system-v2/metadata.yaml`
- `cmp skills/design-system/apply-design-system-contract/metadata.yaml /home/marcelo-karval/.codex/skills/apply-design-system-contract/metadata.yaml`
- repository-wide deprecated UI-library search
  - returned no matches
- `git diff --check`

## Result

Root `skills/` is now the active authoring structure for governed Accelerate
skills.

`docs/codex-skill-seeds/` remains a transitional/historical bridge only.

The two existing design-system skills are now local-authoritative and mirrored
to `~/.codex/skills/`.

The first six P0 root/review/governance skills were rewritten from imported
baselines into standalone Accelerate skills, registered as `local-authoritative`,
and mirrored to `~/.codex/skills/`.

The second security/frontend/workflow wave was rewritten into standalone
Accelerate skills, registered as `local-authoritative`, and mirrored to
`~/.codex/skills/`.

The third frontend/backend support wave was rewritten into standalone
Accelerate skills, registered as `local-authoritative`, and mirrored to
`~/.codex/skills/`.

The fourth backend/runtime/security support wave is now local-authoritative:

- `django-pro`
- `django-vite-integration`
- `inertia-patterns`
- `inertia-shared-props`
- `python-pro`
- `celery-tasks`
- `adversarial-security-review`
- `untrusted-ingress-hardening`

The fifth governance/data/legacy wave is now local-authoritative:

- `api-surface-governance`
- `dependency-governance`
- `validation-governance`
- `database-design`
- `database-architect`
- `postgresql`
- `postgres-best-practices`
- `sql-optimization-patterns`
- `legacy-first-protocol`
- `legacy-transplant`

The sixth workflow/runtime closure wave is now local-authoritative:

- `planning-with-files`
- `requesting-code-review`
- `linear-pm`
- `linear-progress-reporter`
- `linear-workflow-orchestrator`
- `github-issues`
- `github-pr-workflow`
- `github-code-review`
- `dogfood`
- `inertia-runtime-persistence-audit`

The seventh runtime/tooling and frontend-support wave is now
local-authoritative:

- `github-auth`
- `github-repo-management`
- `react-best-practices`
- `tailwind-patterns`
- `frontend-chunk-ownership-audit`
- `figma-node-fidelity`
- `bash-linux`
- `native-mcp`
- `mcporter`
- `codebase-inspection`

The eighth review/delegation/skill-governance/domain wave is now
local-authoritative:

- `code-audit`
- `component-extraction`
- `subagent-governance`
- `parallel-agents`
- `codex-skill-promotion-protocol`
- `skill-developer`
- `writing-skills`
- `financial-source-truth`
- `payment-integration`
- `stripe-integration`

The final profile/packaging wave added:

- `nextjs-app-router-patterns`
- `using-superpowers` replacement audit
- `accelerate` root skill packaging decision
- role-only dependency resolution into concrete backend/frontend/workflow/
  runtime/domain bundles
- local Playwright persistent-regression scenario and proof packet fixtures
- local validation bundles for `profiles/django-inertia-react/` and
  `profiles/nextjs-tailwind/`
- generated mirror drift check script: `scripts/check-global-skill-mirror.sh`
- domain eval fixtures for `financial-source-truth`, `payment-integration`, and
  `stripe-integration`
- final global-only audit recorded in
  `planning/executive/final-global-only-audit-result.md`

## Remaining Work

Continue the P0 promotion queue:

1. stale transition docs pruning after commit
2. optional CI wiring for the mirror check
