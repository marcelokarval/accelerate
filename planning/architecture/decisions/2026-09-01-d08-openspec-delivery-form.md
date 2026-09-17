# D08 — OpenSpec delivery form

## Disposition

- **Disposition ID:** `CODEX-17-D08-OPENSPEC-DELIVERY-2026-09-01`
- **Status:** `proposed-for-root-acceptance`
- **Owner:** architecture owner
- **Author:** Codex delegated architecture specialist (`/root/phase1_d08_openspec_delivery`)
- **Date:** 2026-09-01
- **Scope:** Phase-1 fixture-only OpenSpec adapter spike; no installation, promotion, runtime enablement, schema implementation, or lifecycle change is authorized by this disposition.
- **Proposal authority:** `planning/architecture/2026-09-01-accelerate-portable-agent-fabric-openspec-design.md`
- **Proposal SHA-256:** `79473c41e77c626a0c849d0ff385be7c140e7f66cfbf047e55ba5ccfe05cd067`

## Decision

Adopt **one externally pinned OpenSpec Core CLI, invoked only through a repo-owned JSON adapter in an isolated Phase-1 fixture tool root**. The adapter, not the executable, is the integration boundary. It resolves the exact package/version/provenance receipt, supplies a minimal child-process environment, uses only supported JSON-mode commands, validates the JSON envelope against repo-owned fixtures, and records a non-secret receipt.

The initial candidate is `@fission-ai/openspec@1.11.0`, whose official GitHub tag `v1.11.0` resolves to commit `a0ddb60d040c61f4907436a9d91310934b1dda63`. This is a candidate identity, not an instruction to install it. An authorized Phase-1 implementation must independently resolve the registry tarball integrity and package metadata, capture them with the tag/commit, and reject any disagreement.

No application dependency, embedded/library import, vendored fork, OpenSpec Plus runtime dependency, global install, or WebUI follows from D08. `latest`, `main`, `master`, and an updater-selected version are explicitly not stable release authority.

## Options considered

| Form | Disposition | Rationale |
| --- | --- | --- |
| Pinned external CLI behind repo-owned JSON adapter | **Adopt** | Keeps OpenSpec as a replaceable artifact engine; localizes process, provenance, schema, output, and cleanup controls in the repository adapter. |
| Embedded/library integration | Reject for Phase 1 | Expands the process API into the application dependency graph and couples Core internals, Node/runtime compatibility, and upgrade behavior before the adapter contract is proven. Reconsider only after the CLI contract proves insufficient and a separate ADR names a stable public library API. |
| Vendored fork | Reject | Creates an unmaintained security/update and license-provenance fork while delivering no Phase-1 fixture benefit. A future fork requires an independent operator-approved compatibility/security and maintenance decision. |
| OpenSpec Plus as runtime dependency | Reject | The inspected Plus source is doctrine/skills, not a release-qualified runtime contract; its inspected commit has no observed published tag in the official tags listing. Importing it would turn mutable prompt/process material into executable authority. |

## Core and Plus disposition

### OpenSpec Core

- **Adopt:** change-scoped filesystem artifacts, custom schema/template capability, and JSON-capable CLI surfaces for status, instructions, validation, schema discovery, and read-only archive inputs.
- **Adapt:** structural validation is planning evidence only; archive is a separately gated history operation and cannot close a canonical work item; Core status/checkboxes remain projections and never delivery truth.
- **Reject:** interactive/human output as an adapter API, implicit global installation, `openspec update` as a release-selection mechanism, and any claim that Core owns execution state, dispatch, review, or closure.

### OpenSpec Plus

- **Adopt as ideas only:** five-lens discovery, What-before-How, testable scenarios, alternatives, vertical slices, bounded apply/review thinking, and pause/resume.
- **Adapt:** express compatible ideas as Accelerate-owned hardened packets, schemas, validators, and bounded root-controlled loops; do not copy upstream prompts or make Plus a governing authority.
- **Reject:** a Plus package/runtime dependency, giant embedded prompts, moving-main update/install practice, copy/overwrite installation, universal strict TDD, reviewer self-correction, and any automatic completion/closure reading.

This Core/Plus mapping is a design decision. The conclusion that the Plus commit is unsuitable as a stable runtime package is an **inference** from its official repository state at the access date, not a claim that Plus has no value or can never publish a qualifying immutable release.

## Delivery and invocation contract

1. **Resolver:** a repo-owned adapter accepts a declared candidate tuple: package name, exact semver, official release/tag locator, commit SHA, registry tarball URL/integrity, license identifier, and adapter/fixture compatibility profile. Missing, non-immutable, or mismatched fields fail closed before spawn.
2. **Tool location:** any authorized Phase-1 installation is confined to a disposable, test-owned tool prefix and an independently disposable fixture workspace. It must not modify the repository's production dependency manifests, global Node prefix, user configuration, or active runtime path.
3. **Canonical root, store, and invocation:** the upstream OpenSpec project/store root is exactly `<project_root>/planning`; its upstream-required child `openspec/` is therefore exactly the D11 canonical location `<project_root>/planning/openspec/`. The Phase-1 fixture equivalent is exactly `<isolated-test-root>/planning/openspec/`. No symlink, copy, mirror, second staging tree, or second location authority is permitted. The adapter uses an explicit executable path and explicit `cwd=<project_root>/planning` (or the matching isolated test root); it never depends on shell lookup or parent-directory discovery. Where the pinned CLI command supports `--store <id>`, any store registry/configuration is redirected into the disposable HOME/XDG root and the registered id must bind this same planning root. A command without applicable `--store` must retain the explicit planning `cwd` and must never parent-walk outside the previously verified root. This precise `cwd`/store mapping is an **inference** from the pinned CLI's documented project-root and optional-store interfaces, selected to satisfy the repository's D11 single-location authority; it is not an upstream promise that OpenSpec itself enforces D11.
4. **JSON boundary:** stdout is one bounded JSON payload and is schema-validated before use; stderr is diagnostic-only and separately size-capped. Empty stdout, non-JSON stdout, trailing non-whitespace protocol contamination, wrong top-level type, missing required fields, or an output shape outside the fixture compatibility profile is `JSON_PROTOCOL_INVALID`.
5. **Process boundary:** use no shell interpolation, an argument vector, a dedicated working directory, explicit `cwd`, and a new process group. Default timeout is 30 seconds for status/instructions/schema inspection and 120 seconds for validation; the adapter kills the process group on timeout and records timeout class, exit/signal, command class, and redacted diagnostics. Any future change to these bounds needs fixture coverage and adapter review.
6. **Environment and secrets:** begin from an allowlisted environment, not the parent environment. Permit only locale, `HOME`/XDG paths redirected into the disposable test root, a restricted `PATH` containing the resolved tool, `OPENSPEC_TELEMETRY=0`, `DO_NOT_TRACK=1`, and explicitly required non-secret runtime variables. Do not pass provider credentials, GitHub tokens, package-manager auth, agent credentials, proxy credentials, or arbitrary `OPENSPEC_*` values beyond the named telemetry control. Receipts record variable names and redacted state, never values.
7. **Filesystem/network:** Phase 1 permits only its declared fixture root and adapter-owned temporary/log roots. Network is needed only for a separately authorized one-time resolution/staging step; fixture execution and CI use an already verified local artifact and do not contact registries, GitHub, telemetry, update endpoints, or external stores. Any attempted outbound telemetry despite `OPENSPEC_TELEMETRY=0` and `DO_NOT_TRACK=1` is a `POLICY_VIOLATION` and rejects the run.

## Failure taxonomy and recovery

| Class | Meaning | Required result |
| --- | --- | --- |
| `RESOLUTION_UNAVAILABLE` | official tag, commit, package metadata, or integrity cannot be read | no staging; retain prior receipt |
| `PROVENANCE_MISMATCH` | tag, commit, tarball, package name/version, license, or digest conflicts | quarantine candidate; no invocation |
| `RUNTIME_INCOMPATIBLE` | Node/platform/executable probe disagrees with the candidate compatibility profile | no retry except one evidence-backed corrected runtime probe |
| `SPAWN_FAILED` / `TIMEOUT` / `SIGNALLED` | process cannot start, exceeds limit, or terminates abnormally | preserve redacted diagnostics; clean test roots; no inferred result |
| `JSON_PROTOCOL_INVALID` | stdout is not the fixture-approved JSON protocol | reject result; retain raw bounded diagnostics as evidence |
| `CLI_SEMANTIC_FAILURE` | valid JSON/exit status reports a validation, status, or instruction failure | map to planning failure; never reinterpret as acceptance |
| `WORKSPACE_ESCAPE` / `POLICY_VIOLATION` | path, environment, network, or destructive-command boundary is crossed | terminate/quarantine; block the spike and require security review |
| `FIXTURE_DRIFT` | output shape or behavior differs from pinned compatibility fixtures | block upgrade/promotion; update only through a new compatibility receipt |
| `CLEANUP_INCOMPLETE` | fixture prefix, process group, or temporary state cannot be proven removed | mark run incomplete; do not reuse the root |

The adapter must make partial effects explicit. It never retries a mutating command automatically, never calls archive in Phase 1 except inside an isolated fixture explicitly designed for it, and never turns a successful CLI exit into execution, review, tracker, or closure authority.

## Compatibility, upgrade, rollback, and offline CI

The compatibility window is exactly one approved Core candidate tuple plus one adapter/fixture profile at a time. There is no semver-range acceptance and no forward-compatibility presumption. Phase 1 proves only the pinned candidate's selected JSON contracts against positive and negative fixtures; it does not certify all OpenSpec commands, future patch versions, or runtime environments.

An upgrade is a new candidate, not an in-place update: resolve a new immutable official tag and commit; verify package integrity/license/runtime compatibility; run the complete fixture matrix in a fresh tool root; compare JSON envelopes and behavior to the current profile; issue a new provenance/compatibility receipt; then obtain the separately required promotion authority. `--latest`, `openspec update`, and a moving branch cannot select that candidate.

Rollback selects the previous accepted candidate tuple and prior adapter/fixture profile, recreates a clean isolated tool root from its recorded artifact, and reruns its smoke fixtures. The new root is quarantined for evidence and only removed after cleanup proof. D08 does not authorize rollback against any shared, global, or production installation because it authorizes none.

Offline CI receives the previously verified exact artifact from a controlled local cache or fixture artifact store, verifies the recorded digest/integrity before use, disables outbound traffic by policy, and runs only fixture workspaces. Cache absence, digest mismatch, or an attempted network resolution is a blocked/offline failure, not permission to fetch `latest`.

## Licensing and provenance

At the pinned Core tag, the official repository reports MIT. The inspected Plus repository also reports MIT, but Plus is not delivered as code or a runtime dependency by this decision. The Phase-1 provenance receipt must retain official immutable locators, access date, package/version/commit/integrity values, SPDX license identifier, applicable notice text/source, and whether any copyrighted upstream expression was copied. This D08 proposes independent implementation and no such copying. License status must be re-read at every new candidate; an upstream repository's current default-branch license page does not substitute for candidate-version evidence.

## Evidence basis

All external sources below were accessed 2026-09-01 and are primary official GitHub sources. They establish upstream facts only; repository-local architecture remains the governing authority for this disposition.

| Claim | Official stable locator | Verdict |
| --- | --- | --- |
| Core tag identity and commit | [Fission-AI/OpenSpec tag v1.11.0](https://github.com/Fission-AI/OpenSpec/tree/a0ddb60d040c61f4907436a9d91310934b1dda63) | Verified: official tag ref resolved to the stated commit. |
| Core CLI JSON-capable command and store boundary | [Core CLI reference at pinned commit](https://github.com/Fission-AI/OpenSpec/blob/a0ddb60d040c61f4907436a9d91310934b1dda63/docs/cli.md) | Verified: documented agent-compatible commands expose `--json`, and documented store-capable commands accept `--store <id>`; the D11 `planning/openspec/` mapping is explicitly labelled inference above. |
| Core candidate license | [Core LICENSE at pinned commit](https://github.com/Fission-AI/OpenSpec/blob/a0ddb60d040c61f4907436a9d91310934b1dda63/LICENSE) | Verified: MIT. |
| Plus inspected source/version | [Plus VERSION at inspected commit](https://github.com/sudokar/openspec-plus/blob/7358841abdade7629a7b6bcb3fc02bc760e064f9/VERSION) and [Plus skills at that commit](https://github.com/sudokar/openspec-plus/tree/7358841abdade7629a7b6bcb3fc02bc760e064f9/skills) | Verified for the frozen source snapshot; no runtime adoption follows. |
| Plus candidate license | [Plus LICENSE at inspected commit](https://github.com/sudokar/openspec-plus/blob/7358841abdade7629a7b6bcb3fc02bc760e064f9/LICENSE) | Verified: MIT. |

Local authorities applied: the immutable proposal (digest above), `AGENTS.md`, `adapters/runtime/adapter-contract.md`, `adapters/runtime/adapter-registry-contract.md`, and `adapters/workflow/adapter-contract.md`. In particular, they require capability-first, evidence-producing adapters that fail closed and do not claim root closure or fake runtime truth.

## Consequences and acceptance boundary

If accepted, D08 satisfies only the Phase-1 **delivery-form/provenance** prerequisite. D01 remains independently required. D11 remains independently authoritative until its own ADR is accepted; once D08 and D11 are both accepted, there is no unresolved artifact-location choice: the only permitted OpenSpec root is `<project_root>/planning` and the only permitted upstream child is `<project_root>/planning/openspec/` (with the stated isolated-test equivalent). All Phase-1 implementation, installation, fixture mutation, acceptance, promotion, deployment, runtime enablement, and tracker closure remain subject to their own authorization and proof gates.

**Recommendation to root:** accept this disposition as the narrow Phase-1 delivery constraint: pinned Core CLI plus repo-owned JSON adapter plus fixture-only isolation; retain Plus as credited/adapted doctrine only. Do not authorize package installation from this document. Before Phase-1 execution, require the candidate provenance tuple, D01/D11 dispositions, a written implementation plan, and an issue/bootstrap gate.
