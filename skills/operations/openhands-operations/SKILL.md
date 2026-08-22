---
name: openhands-operations
description: Use for OpenHands Agent Canvas lifecycle, Agent Profiles, governed skills, MCP health, runtime truth, safe restart, or rollback. Do not claim native child dispatch without fresh binding proof.
metadata:
  category: operations
  origin: accelerate-local-authoritative
---
# OpenHands Operations

Operate the local OpenHands Agent Canvas deployment while preserving its
current fail-closed capability boundary.

## Boundaries

- Service: `openhands-agent-canvas.service`.
- Governed skills project into `~/.agents/skills` but remain repository-owned.
- Agent Profiles are launch configurations, not proof of callable children.
- Current child dispatch status is `prompt-contract-only` with bindings
  unavailable. Do not report native child execution as supported.

## Required Flow

1. Read `references/runbook.md`.
2. Inspect version, service, profile, MCP, and managed-marker state safely.
3. Dry-run repository materializers before mutation.
4. Restart only through the supported user service.
5. Prove skill discovery and MCP health in a fresh disposable session.
6. Preserve a rollback artifact and report unsupported behavior explicitly.

Never print `.env`, provider credentials, conversation payloads, or opaque
runtime settings. If the live runtime disagrees with documentation, runtime
readback wins for current status and repository policy remains normative.
