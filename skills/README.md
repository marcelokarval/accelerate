# Accelerate Skills

This directory is the repo-owned authoring source for standalone `accelerate`
skills.

Global runtime copies under `~/.codex/skills/` are deployment mirrors, not the
source of truth.

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

Do not add new global-only governed skills.
