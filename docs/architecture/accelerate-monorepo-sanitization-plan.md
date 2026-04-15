# Accelerate Monorepo Sanitization Plan

Date: 2026-04-15
Stage: standalone extraction / monorepo cleanup
Status: execution-approved

## Objective

Remove `accelerate` as a living documentation center from the old Prop4You
monorepo while preserving:

- raw provenance in the standalone `accelerate` repository
- minimal integration breadcrumbs in the old monorepo
- a clean editorial boundary between product docs and external workflow tooling

## Accepted Direction

The standalone `accelerate` repository is now the canonical home for:

- root skill and runtime doctrine
- inherited `references/`
- `codex-agents` governance material
- platform architecture and onboarding docs

The old monorepo should keep only:

- short integration-facing references when still useful
- historical records that are truly about the old project rather than the
  `accelerate` product

## Surfaces To Sanitize

### 1. Sandbox seed tree

Old location:

- `docs/codex-skill-seeds/skills/accelerate/`

Treatment:

- copy into ignored raw backup inside the standalone repo
- replace with a short tombstone README in the old monorepo
- remove the rest of the old sandbox tree

### 2. Old technical architecture docs

Primary files:

- `docs/architecture/accelerate-control-plane.md`
- `docs/architecture/accelerate-branch-enforcement-matrix.md`
- `docs/architecture/accelerate-workflow-change-approval-gate.md`
- `docs/architecture/accelerate-adjacent-skill-trigger-audit.md`
- `docs/architecture/workflow-execution-chain-manifest.md`

Treatment:

- copy to ignored raw backup
- remove from the old monorepo
- leave a compact integration doc in the old monorepo when still useful

### 3. Docusaurus public docs polluted by accelerate product content

Primary files:

- `frontends/docusaurus/docs/ai/accelerate-operational-model.md`
- `frontends/docusaurus/docs/ai/accelerate-based-codex-agents.md`

Treatment:

- copy to ignored raw backup
- remove from the old docs app
- remove from sidebars and central navigation

### 4. Old monorepo index surfaces

Primary files:

- `docs/README.md`
- `frontends/docusaurus/sidebars.ts`

Treatment:

- remove long-form `accelerate` entries from central navigation
- leave at most one short integration pointer

## Backup Policy

Raw extraction backup is stored under:

- `.backups/prop4you-accelerate-sandbox/2026-04-15/`

This backup is:

- ignored by git
- not canonical doctrine
- not a living source of truth
- kept only for provenance and forensic recovery

## Execution Sequence

1. Create plan artifact and ignored backup root in the standalone repo.
2. Snapshot old monorepo surfaces into the ignored backup tree.
3. Create tombstone/integration docs for the old monorepo.
4. Remove the old sandbox tree and long-form accelerate docs from the
   monorepo.
5. Desindex the old docs hub and Docusaurus sidebar.
6. Audit residual references that still point to the removed surfaces.
7. Report residuals that intentionally remain as historical records or
   lightweight integration references.

## Success Criteria

- standalone `accelerate` remains fully self-sufficient
- old monorepo no longer hosts a living `accelerate` sandbox
- old monorepo no longer presents `accelerate` as a core editorial topic
- backup provenance exists locally in the standalone repo and stays ignored
- remaining mentions of `accelerate` in the old monorepo are short, local, and
  integration-oriented rather than product-defining
