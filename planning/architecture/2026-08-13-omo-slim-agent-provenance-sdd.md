# OMO-Slim Agent Provenance SDD

## Status

- ID: `SDD-OMO-SLIM-AGENT-PROVENANCE-001`
- Mode: `standard`
- Status: `accepted`
- Governing issue: `CODEX-5`
- Owner: `accelerate-root`
- Author: `user-request`
- Accepted by: `accelerate-root`
- Date: 2026-08-13

## Objective

Make the relationship between every governed Codex logical agent and the
current OMO-Slim built-in role model explicit without turning donor personas
into local authority.

## Authority And Scope

The machine authority is
`adapters/runtime/codex/logical-agent-topology.toml`. The repo-owned `AGENTS.md`
provides the development view; `~/.codex/AGENTS.md` carries the deployed global
summary. Both point back to the TOML. The OMO-Slim repository is supporting
provenance only; local Accelerate doctrine remains authoritative.

Included:

- one primary OMO-Slim role for each logical agent;
- zero or more secondary roles whose behavior is partially absorbed;
- an exact equivalence kind and short adaptation note;
- validation of the approved role set and exact per-agent mapping;
- global runtime reconciliation after the topology digest changes.

Excluded:

- donor prompts, hooks, wrappers, council runtime, or wildcard grants;
- changes to models, skills, MCPs, permissions, write modes, or closure
  authority;
- claims of process, filesystem, tool, MCP, or credential isolation.

## Requirements

- `REQ-OMO-001`: all eight logical agents declare complete OMO-Slim
  provenance.
- `REQ-OMO-002`: only current built-in role names are accepted.
- `REQ-OMO-003`: the exact approved mapping is fail-closed and no standalone
  donor agent is implied.
- `REQ-OMO-004`: repo and global `AGENTS.md` expose a compact human view and
  identify the TOML as machine authority.
- `REQ-OMO-005`: topology, installation, mirror, and fresh runtime proof remain
  green.

## Approved Mapping

| Codex agent | Primary OMO-Slim role | Secondary/absorbed roles | Equivalence |
| --- | --- | --- | --- |
| `orchestrator` | `orchestrator` | `council` | `adapted-absorbed` |
| `python-backend` | `fixer` | none | `adapted-specialized` |
| `nextjs-frontend` | `fixer` | `designer` | `adapted-partial` |
| `research` | `librarian` | `explorer` | `adapted-composite` |
| `reviewer` | `oracle` | `council` | `adapted-composite` |
| `qa` | `observer` | `oracle` | `adapted-partial` |
| `data-db` | `fixer` | none | `adapted-specialized` |
| `integrations-ops` | `fixer` | none | `adapted-specialized` |

`designer`, `observer`, and `council` are not promoted as standalone local
agents: their useful behavior is bounded inside frontend, QA, reviewer, and
root orchestration respectively.

For `qa`, `observer` provenance applies only to read-only visual and media
evidence inspection. Broader QA, runtime and browser proof remain Codex-native.

## Dispositions

- ADR: consolidated here because provenance adds no new runtime boundary.
- Product/UI design: not applicable because no product interface changes.
- Test Design: separate at
  `planning/testing/2026-08-13-omo-slim-agent-provenance-test-design.md`.
- Agents: consolidated here and enforced in the topology validator.
- Rollout: governed global sync after local proof.
- Rollback: existing schema-4 runtime sync receipt and rollback contract.
- Observability: focused test, topology/install gates, mirror, fresh runtime,
  and Plane lifecycle readback.
- Governing docs: `AGENTS.md` is required and the TOML remains machine
  authority.

## Tasks And Traceability

| Task | Requirements | Planned proof |
| --- | --- | --- |
| `T1` semantic baseline | `REQ-OMO-001..003` | `tests/codex-logical-agent-topology.sh` observed RED |
| `T2` topology and validator | `REQ-OMO-001..003` | focused valid and invalid fixtures |
| `T3` AGENTS view | `REQ-OMO-004` | exact table/pointer assertions |
| `T4` rollout and proof | `REQ-OMO-005` | install, mirror, fresh root plus seven |

## Future Change Boundary

Native Codex custom roles are a separate potential evolution. They require a
new SDD because they change the physical spawn binding and may duplicate or
supersede the current assignment-driven collaboration policy.
