# Capability Skill Seed Registry

This register is the versioned-source inventory for global capability skills.
Each entry is exported only after source validation, remains on-demand, and
must not preload in Codex or Hermes.

| Skill | Category | Source placement | Runtime placement |
| --- | --- | --- | --- |
| `nx-nestjs-monorepo-operations` | Nx/NestJS commercial monorepo operations | `../nx-nestjs-monorepo-operations/` | on-demand; not preload |
| `governed-us-lead-data-acquisition` | US lead-data acquisition governance | `../governed-us-lead-data-acquisition/` | on-demand; not preload |
| `docker-compose-deployment-operations` | Docker Compose deployment operations | `../docker-compose-deployment-operations/` | on-demand; not preload |
| `chatwoot-conversational-channel-operations` | Chatwoot conversational-channel operations | `../chatwoot-conversational-channel-operations/` | on-demand; not preload |
| `hermes-core-change-governance` | Hermes core, gateway, plugin, and PostgreSQL change placement | `../hermes-core-change-governance/` | on-demand; not preload |

These packages are distinct from root `skills/`, which continues to own the
standalone Accelerate product surface.
