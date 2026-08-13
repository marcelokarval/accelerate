# CODEX-3 Agent Routing Hardening RED Receipt

## Receipt

- Proof status: `observed-red`
- Governing issue: `CODEX-3`
- Observed at: `2026-08-13T09:03:01-04:00`
- Repository commit before CODEX-3 implementation:
  `7cb65f1b16b2fe8d84c379cf5a7069263d8afef2`
- Test: `tests/codex-agent-routing-hardening.sh`
- Test SHA-256:
  `7745f3f5e362fe5cd64f2c9447057f8a9ace9c508add9e78edad6120590fe107`
- Command: `bash tests/codex-agent-routing-hardening.sh`
- Exit status: `1`
- Aggregate: `pass=0 red=7 total=7`
- Correction generation: `0`
- Proof generation: `0`

## Stable Requirement And Case Evidence

| Requirement | Case | Observed failure |
| --- | --- | --- |
| `REQ-ROUTER-001` | `CASE-ROUTER-001` | repo-owned `skills/governance/skill-catalog-router/SKILL.md` is missing |
| `REQ-SPAWN-002` | `CASE-SPAWN-002` | expected five Python-backend assignment routes; no `skill/path/sha256` records were emitted |
| `REQ-ALIASES-003` | `CASE-ALIASES-003` | seven raw specialist profiles remain in catalog profile listing |
| `REQ-ROUTES-004` | `CASE-ROUTES-004` | logical agent `data-db` is missing; execution stopped before the second route could pass |
| `REQ-DOCTRINE-005` | `CASE-DOCTRINE-005` | capability/ontology/pool/selection/envelope surfaces do not share the accepted six-family set |
| `REQ-READONLY-006` | `CASE-READONLY-006` | specification reviewer lacks forbidden-mutation, return-only, and separate-executor wording |
| `REQ-LIMIT-007` | `CASE-LIMIT-007` | topology validator rejects a valid positive limit `8`, proving the value is a hard-coded literal rather than an operational renderer contract |

## Harness Correction

The first candidate run exposed a test-harness defect: the limit case did not
propagate the packet renderer's non-zero exit and was falsely labelled PASS.
The harness was corrected before this receipt, rerun, and hashed. The discarded
output is not TDD evidence. The accepted second run produced all seven REDs for
the intended missing behavior, without syntax errors and without writing to the
real `~/.codex` runtime.

## Raw Result

```text
RED  CASE-ROUTER-001 - router is repo-owned and indexes current governed sources
RED  CASE-SPAWN-002 - spawn packet carries existing absolute skill paths and exact SHA256 values
RED  CASE-ALIASES-003 - raw catalog aliases are hidden and stale generated aliases are removed
RED  CASE-ROUTES-004 - data-db and integrations-ops are explicit bounded logical agents
RED  CASE-DOCTRINE-005 - ontology, pool, selection, compatibility and envelopes share one family set
RED  CASE-READONLY-006 - read-only reviewers return artifacts without ambiguous workspace edits
RED  CASE-LIMIT-007 - spawn_packet_limit is consumed as an operational rendering limit
codex agent routing hardening: pass=0 red=7 total=7
```

No GREEN, implementation, runtime-sync, or completion claim is made here.
