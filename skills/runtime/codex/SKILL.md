---
name: codex
description: Use when a task concerns Codex configuration, profiles, global environment capabilities, capability-backed provider selection, fresh-process runtime proof, or troubleshooting why a configured Codex tool is unavailable.
---

# Codex

Use this skill for Codex-owned runtime and configuration decisions. Keep the
Accelerate repository as skill authority and treat `~/.codex/` as the deployed,
host-specific runtime.

## Core Rules

1. Inspect current configuration instead of relying on an older session's
   cached startup state.
2. When a task names an external provider, database, local infrastructure
   service, credential-backed CLI, or MCP, consult the machine catalog at
   `~/.codex/capabilities/environment-capabilities.json` before choosing a path.
3. Treat ENV presence as `defined`, never as proof of registration,
   materialization, authentication, authorization, reachability, health, or
   callability.
4. Respect each system's source of truth, preferred access, policy state, and
   forbidden fallbacks. Do not substitute a familiar local file or database.
5. Never print or persist environment values. Report names, aggregate state,
   policy, and non-reversible fingerprints only when necessary.
6. Prove a usability claim in a fresh process through the governed access path.

## Capability Preflight

Read [environment capability preflight](references/environment-capability-preflight.md)
when ENV-backed capability or provider selection matters. Validate the host
catalog without exposing values:

```bash
python3 scripts/validate_environment_capabilities.py \
  "${CODEX_HOME:-$HOME/.codex}/capabilities/environment-capabilities.json"
```

Fail closed when the catalog is missing, malformed, stale relative to the task,
or contradicts a requested access path. A disabled capability remains disabled
even when credentials are defined.

## Runtime Proof

Separate these claims:

- configuration exists;
- dependency or executable is materialized;
- process initializes;
- tool or provider action is callable;
- credentials authenticate;
- requested operation is authorized.

Use the smallest read-only fresh-process probe that proves the needed claim.
Require explicit authorization and applicable governance before a live write.

## Boundaries

- Plane remains governed-MCP-only.
- ManyChat remains disabled until the global policy changes.
- PostgreSQL is the Hermes state authority; do not search for or select SQLite
  as an alternative.
- Host-specific catalog data and ENV names stay in `~/.codex`; do not copy the
  full catalog into this repository.
- Use `native-mcp` for MCP transport and lifecycle diagnosis and
  `playwright-patterns` for browser runtimes.

## Verification

This skill is working correctly when catalog validation is redacted, provider
selection follows the declared authority, disabled/fallback paths fail closed,
and usability claims cite a fresh governed probe.
