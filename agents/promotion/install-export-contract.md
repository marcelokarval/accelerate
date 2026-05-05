# Agent Install / Export Contract

## Purpose

This contract defines the boundary between agent doctrine, candidate templates,
runtime bindings, installed host copies, generated exports, and promoted agents.

It is intentionally conservative for the standalone pre-agents phase: this
repository may define templates and promotion gates, but it must not imply that
real physical agents have been implemented, installed, exported, or promoted.

## Agent State Model

Every agent-like artifact must declare exactly one lifecycle state:

| State | Meaning | Authority |
| --- | --- | --- |
| `doctrine-only` | Architecture, policy, or explanatory material about agents. | Governs concepts only; not executable. |
| `template-only` | A reusable agent shape under `agents/templates/`. | Not a runtime agent. |
| `candidate-defined` | A template has a readiness packet and bounded task class. | Candidate only; no install or delegation guarantee. |
| `contract-approved` | Root approved the candidate contract and authority boundary. | Still not runnable without runtime binding. |
| `runtime-adapter-bound` | A concrete implemented runtime adapter can start, collect, and clean up the agent. | Runtime binding exists; not promoted yet. |
| `installed` | A host-local copy or config exists at a target runtime path. | Host deployment fact only; does not create authority. |
| `exported` | A generated outward bundle/manifest was produced from this repo. | Generated copy only; never canonical doctrine. |
| `empirically-replayed` | Bounded replay proved scope, return packet, fallback, and cleanup behavior. | Evidence for promotion review. |
| `promoted` | Root accepted the replayed, runtime-bound agent for governed use. | Usable only within its approved role and adapter contract. |
| `rolled-back` | Prior install/export/promotion was revoked or superseded. | Must name rollback reason and surviving fallback. |

The states are not aliases. In particular, `installed` and `exported` are not
synonyms for `promoted`.

## Install Contract

An install record must name:

- agent identity
- source artifact path
- source repository commit or explicit `unknown` when not available
- target host
- target path
- runtime adapter path
- authority state before install
- authority state after install
- privacy classification
- exported files or installed files
- validation command
- rollback command or manual rollback steps
- fallback mode when the install is unavailable

Install is blocked when:

- runtime adapter status is `planned` or `not-implemented-yet`
- source artifact is only `doctrine-only` without a template or contract
- target path escapes the requested export/install root
- privacy classification is missing
- rollback is missing
- the record claims installation equals promotion

## Export Contract

A host export record must name:

- export identity
- source repository
- source artifacts
- target host
- target path
- generated files
- authority statement: `generated-export; repository remains source of truth`
- privacy classification
- suppressed capabilities
- rewritten tools or host-specific substitutions
- validation command
- schema version

Export is blocked when:

- any source artifact is outside this repository
- target path traversal is requested
- generated output claims to be authoritative
- exported output is not authority; generated copy only
- privacy classification is missing
- validation command is missing

## Promotion Contract Link

Promotion still requires the template readiness and promotion contracts:

- [template-promotion-readiness.md](./template-promotion-readiness.md)
- [promotion-contract.md](./promotion-contract.md)
- [execution-contract.md](./execution-contract.md)
- [return-contract.md](./return-contract.md)

No generated host export, installed copy, or physical-agent adapter document can
bypass empirical replay or root final approval.

## Rollback Contract

Rollback records must name:

- previous state
- rollback target state
- reason
- affected host/export/install paths
- cleanup proof or retained-with-reason proof
- fallback execution mode
- root review owner

## Failure Labels

- `agent-install-treated-as-promotion`
- `agent-export-treated-as-authority`
- `agent-promoted-without-runtime-binding`
- `agent-installed-without-rollback`
- `agent-export-missing-privacy-classification`
- `agent-export-path-traversal`
