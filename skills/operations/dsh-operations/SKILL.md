---
name: dsh-operations
description: Use for DeepSeek Harness installation, upgrades, presets, service health, skill discovery, session proof, local patches, or rollback. Do not use for ordinary application coding inside a DSH session.
metadata:
  category: operations
  origin: accelerate-local-authoritative
---
# DSH Operations

Operate the local DeepSeek Harness deployment without replacing Accelerate's
classification role.

## Boundaries

- Repository authority: the Accelerate repository and the pinned DSH checkout.
- Runtime state: `~/.dsh`; never treat it as policy authority.
- Current release: `dsh-v0.1.1-rc.2` at commit
  `b150a551b8d465e31e418e1b2eaf5e79bbb7d28e`.
- Service: `deepseek-harness.service`, LAN port `3080`.
- LAN mode has no authentication. Do not widen exposure or print `~/.dsh/env`.

## Required Flow

1. Read `references/runbook.md` for the exact operation.
2. Inspect service, checkout, preset, and managed-marker state without secrets.
3. Dry-run every governed installer before applying.
4. Preserve the documented local patches during upgrades.
5. Use fresh disposable sessions for prompt/catalog proof.
6. Record the backup path and verify rollback before closure.

The `code-orchestrated` preset is a compact entrypoint. It loads Accelerate;
it does not duplicate the full workflow. Initial enforcement is
`prompt-enforced` and observable, not mechanical.

Stop if the pinned version, managed markers, runtime loader, or live readback
disagrees with the runbook.
