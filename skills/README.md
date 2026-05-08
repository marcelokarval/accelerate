# Accelerate Skills

This directory is the repo-owned authoring source for standalone `accelerate`
skills.

Runtime copies outside this repository are optional deployment exports, not the
source of truth and not required for local governance. The operational sync
policy is governed by
[`../core/control-plane/skill-sync-topology.md`](../core/control-plane/skill-sync-topology.md).

## Structure

| Directory | Role |
| --- | --- |
| `_registry/` | Manifest, provenance policy, and sync policy. |
| `root/` | Root orchestration, prompt hardening, and closure gates. |
| `workflow/` | Issue, planning, progress, and adapter workflow skills. |
| `review/` | Product, architecture, governance, code review, and forensic review skills. |
| `frontend/` | Frontend stack, component, i18n, TypeScript, and design-system skills. |
| `backend/` | Django, Inertia, Python, testing, and task skills. |
| `security/` | Security, anti-abuse, adversarial, and ingress skills. |
| `data/` | Database, SQL, financial, payment, and provider-state skills. |
| `runtime/` | Browser proof, Playwright, shell, MCP, and inspection skills. |
| `governance/` | Dependency, API, stack, promotion, and external-skill vetting skills. |
| `design-system/` | Design-system extraction and application skills. |
| `legacy/` | Legacy consultation and migration skills. |
| `overlays/` | Project/domain overlays that must not become universal core law. |

## Rule

Every mandatory skill referenced by `SKILL.md`, `core/`, `agents/`, `adapters/`,
`profiles/`, or `references/` must either exist here or be listed as a
temporary migration gap in `_registry/manifest.md`.

Do not add new global-only governed skills. If a user-home skill is useful,
import, adapt, register, and enforce it here first. user-home catalogs remain non-authoritative even when `scripts/sync-skills-to-global.sh` or
`scripts/export-skill-proof.sh` generates deployment copies.

## Generated Export Proof

RC9 adds a reproducible proof-only export path:

```bash
scripts/export-skill-proof.sh --output /tmp/accelerate-skill-export-proof --selected prompt-hardening,verification-before-completion --check-drift
bash tests/skill-export-proof.sh
```

The generated bundle records `source_commit`, `source_tree`, selected skills,
included file hashes, generated target, and drift result in `provenance.json` and
`drift-report.json`. Those generated files are deployment/proof artifacts only;
do not copy them back into repo-local source authority or treat a host runtime
catalog as the governing skill registry.
