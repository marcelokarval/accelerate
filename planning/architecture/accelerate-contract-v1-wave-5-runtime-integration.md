# Accelerate Contract V1 Wave 5 Runtime Integration Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Integrate Contract V1 optionally with project-local `.accelerate/`, workflow/runtime adapters, provider issue and pull-request readback, and generated global runtime deployment without weakening repository authority or binding core to Linear.

**Architecture:** Core emits and consumes backend-neutral packets; optional project-local state is installed through an explicit adapter and capability selection. Provider adapters normalize read-only issue/PR snapshots into one contract, while the global runtime remains a reproducible generated export checked for drift against repository source.

**Tech Stack:** Bash adapters, Python 3 standard-library normalization/validation, YAML capability manifests, JSON/JSONL runtime state, Git/GitHub CLI where selected, existing Linear helper surfaces where selected.

---

## Wave Packet

- Wave ID: `ACV1-W5`
- Class/mode: `orchestrated-nontrivial / wave`
- Dependencies: `ACV1-W3-009` and `ACV1-W4-008` are accepted and merged with fresh post-merge proof.
- Frozen denominator: `W5-C01` through `W5-C12`.
- Entry packet: `.accelerate/workflow/active/accelerate-contract-v1-wave-5-entry.json`.
  Its top-level `run_key` is written exactly once as
  `<UTC-YYYYMMDDTHHMMSSZ>-<lowercase-UUID>` and is immutable for the wave.
- Initialization anchor:
  `planning/evidence/contract-v1-wave-5-run-key-initialization.json`. This fixed
  repo-local receipt is independently opened and never discovered solely through
  packet data.
- Initialization intent:
  `planning/evidence/contract-v1-wave-5-run-key-initialization-intent.json`.
  Under exclusive lock
  `.accelerate/locks/contract-v1-wave-5-run-key.lock`, this fixed immutable
  O_EXCL record is persisted before packet or final-anchor publication and is the
  sole recovery source for the proposed key and exact packet bytes.
- Coverage threshold: `12/12`; every capability is mandatory, and each selected
  adapter path must pass supported, unavailable, malformed, stale, and
  unsupported-contract-version tests where applicable.
- Non-goals: mandatory `.accelerate/` installation, remote provider writes, auto-closing issues/PRs, a provider SDK, user-home catalog authority, or Linear as a permanent/default core backend.
- Stop conditions: a no-workspace repository is mutated; provider data bypasses normalization; issue/PR read failure is reported as success; Linear terminology enters core schema; generated global runtime differs from source; export reads doctrine from user home.
- Commit posture: examples are task-scoped implementation checkpoints only; no commit is authorized during the current planning task.

## Authority And Selection Rules

- Governing source is this repository: `SKILL.md`, `core/`, `adapters/`, `onboarding/`, `planning/`, `skills/`, and registered references.
- `.accelerate/` is optional runtime instance state. Absence must remain a valid `not-installed` outcome for read-only/conversational work.
- `global-runtime/accelerate/` and user-home installations are generated deployment outputs. They never feed doctrine back into source.
- Workflow providers are sibling adapters selected by declared capabilities. `local`, `github-pr`, `github-issues`, and `linear` are provider IDs, not core lifecycle concepts.
- Linear remains optional and replaceable. No core file may require a Linear issue ID, team, workspace, MCP tool, or status vocabulary.
- Issue and PR readback is read-only in this wave. Writes require a later separately approved capability and remote-write registry entry.

## Target Files

| Action | Exact file | Responsibility |
| --- | --- | --- |
| Create | `scripts/contract-v1-run-key.py` | Initialize the Wave 5 entry packet `run_key` once; load/validate it read-only thereafter. |
| Create | `core/contracts/v1/schemas/run-key-initialization-intent.schema.json` | Closed immutable pre-publication intent contract. |
| Create | `core/contracts/v1/schemas/run-key-initialization-receipt.schema.json` | Closed immutable anchor receipt contract. |
| Create | `planning/evidence/contract-v1-wave-5-run-key-initialization-intent.json` | Fixed O_EXCL initialization intent generated before packet publication. |
| Create | `planning/evidence/contract-v1-wave-5-run-key-initialization.json` | Fixed O_EXCL initialization anchor generated once for Wave 5. |
| Create | `tests/contract-v1-run-key.sh` | Missing/duplicate/invalid/mutated packet/receipt and read-only loader tests. |
| Create | `tests/fixtures/contract-v1-run-key/valid/initialization-intent.json` | Valid persisted intent with canonical packet bytes/digest and expected final packet mode. |
| Create | `tests/fixtures/contract-v1-run-key/valid/initialization-receipt.json` | Valid intent/packet/anchor comparison fixture. |
| Create | `tests/fixtures/contract-v1-run-key/valid/crash-after-intent.json` | Recovery resumes packet/anchor publication from existing intent. |
| Create | `tests/fixtures/contract-v1-run-key/valid/crash-after-packet.json` | Recovery verifies exact fully sealed/fsynced packet bytes/digest/mode and creates anchor without packet mutation. |
| Create | `tests/fixtures/contract-v1-run-key/valid/crash-after-anchor.json` | Recovery validates fully sealed packet mode/bindings and returns read-only idempotent success with bytes, modes, and mtimes unchanged. |
| Create | `tests/fixtures/contract-v1-run-key/invalid/valid-format-key-mutation.json` | Alternate valid-format key must fail anchor comparison. |
| Create | `tests/fixtures/contract-v1-run-key/invalid/receipt-pointer-mutation.json` | Alternate valid repo-relative anchor pointer must fail. |
| Create | `tests/fixtures/contract-v1-run-key/invalid/packet-digest-mutation.json` | Alternate valid-format packet digest must fail recomputation. |
| Create | `tests/fixtures/contract-v1-run-key/invalid/receipt-overwrite.json` | Pre-existing fixed anchor must block initialization. |
| Create | `tests/fixtures/contract-v1-run-key/invalid/intent-packet-mismatch.json` | Existing intent and packet bytes/digests disagree. |
| Create | `tests/fixtures/contract-v1-run-key/invalid/intent-anchor-mismatch.json` | Existing intent, packet, and anchor do not bind one identity. |
| Create | `tests/fixtures/contract-v1-run-key/invalid/downstream-artifact-before-anchor.json` | Recovery fails when downstream run artifacts precede final anchor. |
| Create | `tests/fixtures/contract-v1-run-key/invalid/intent-tamper.json` | Immutable intent field/content mutation fails closed. |
| Create | `core/runtime-packets/schemas/workflow-readback-v1.schema.json` | Backend-neutral issue/PR/readback packet. |
| Create | `adapters/workflow/readback-contract-v1.md` | Provider normalization, freshness, failure, and no-write rules. |
| Create | `scripts/normalize-workflow-readback.py` | Normalize local/GitHub/Linear fixture or command output. |
| Create | `onboarding/local-workspace/integrate-contract-v1.sh` | Explicit `--check`, `--install`, and `--upgrade` optional integration entrypoint. |
| Modify | `onboarding/local-workspace/bootstrap-or-reentry.sh` | Discover Contract V1 integration without forcing installation. |
| Modify | `onboarding/local-workspace/emit-v2.sh` | Materialize Contract V1 runtime files only on explicit install/upgrade. |
| Modify | `onboarding/local-workspace/validate-v2.sh` | Validate installed contract version and adapter selections. |
| Modify | `onboarding/local-workspace/read-workflow-capabilities.sh` | Expose issue/PR readback capability without provider preference. |
| Modify | `onboarding/local-workspace/select-workflow-capability.sh` | Select by capability/status, not adapter name ordering. |
| Modify | `onboarding/local-workspace/read-local-handoff.sh` | Include normalized readback freshness and explicit gaps. |
| Modify | `onboarding/local-workspace/read-github-pr-adapter.sh` | Emit raw bounded input for normalizer; preserve current safety checks. |
| Modify | `onboarding/local-workspace/read-linear-adapter.sh` | Emit raw bounded input for normalizer; remain optional. |
| Modify | `adapters/workflow/local/capabilities.yaml` | Declare local issue readback and explicit PR gap/substitute. |
| Modify | `adapters/workflow/github-pr/capabilities.yaml` | Declare issue/PR readback truth and commands honestly. |
| Modify | `adapters/workflow/github-issues/capabilities.yaml` | Declare issue readback and linked PR behavior. |
| Modify | `adapters/workflow/linear/capabilities.yaml` | Declare optional issue readback and explicit PR linkage/gap. |
| Create | `adapters/runtime/accelerate-contract-v1/capabilities.yaml` | Runtime adapter manifest for optional project-local Contract V1 integration. |
| Create | `adapters/runtime/accelerate-contract-v1/README.md` | Runtime adapter boundaries, install modes, and authority statement. |
| Create | `adapters/runtime/accelerate-contract-v1/installation-manifest.schema.json` | Project-local managed files, predecessor version, backup, and restore contract. |
| Create | `onboarding/local-workspace/restore-contract-v1.sh` | Explicit-root atomic project-local restore and readback. |
| Create | `adapters/runtime/codex/contract-extension.yaml` | Repo-owned Codex extension gate registration. |
| Create | `adapters/runtime/opencode/contract-extension.yaml` | Repo-owned OpenCode extension registration. |
| Create | `adapters/runtime/claude/contract-extension.yaml` | Repo-owned Claude extension registration. |
| Create | `adapters/runtime/hermes/contract-extension.yaml` | Repo-owned optional Hermes interoperability registration. |
| Create | `adapters/workflow/local/contract-extension.yaml` | Repo-owned local workflow extension registration. |
| Modify | `core/contracts/v1/extension-registry.yaml` | Register the five repo-owned extension manifests. |
| Modify | `adapters/runtime/codex/capabilities.yaml` | Declare Contract v1 support/conformance. |
| Modify | `adapters/runtime/opencode/capabilities.yaml` | Declare Contract v1 support/conformance. |
| Modify | `adapters/runtime/claude/capabilities.yaml` | Declare Contract v1 support/conformance. |
| Modify | `adapters/runtime/hermes/capabilities.yaml` | Declare optional Contract v1 interoperability. |
| Modify | `adapters/runtime/python-uv/capabilities.yaml` | Declare supported Contract versions. |
| Modify | `adapters/runtime/node/capabilities.yaml` | Declare supported Contract versions. |
| Modify | `adapters/runtime/browser/capabilities.yaml` | Declare supported Contract versions. |
| Modify | `adapters/runtime/agent-browser/capabilities.yaml` | Declare supported Contract versions. |
| Modify | `adapters/runtime/physical-agent/capabilities.yaml` | Declare supported Contract versions. |
| Modify | `adapters/runtime/locale-pack-parity/capabilities.yaml` | Declare supported Contract versions. |
| Modify | `adapters/runtime/web-content-reader/capabilities.yaml` | Declare supported Contract versions. |
| Modify | `adapters/runtime/tailwind/capabilities.yaml` | Declare supported Contract versions. |
| Modify | `adapters/runtime/document-export/capabilities.yaml` | Declare supported Contract versions. |
| Modify | `adapters/runtime/model-voice/capabilities.yaml` | Declare supported Contract versions. |
| Modify | `adapters/runtime/chrome-devtools/capabilities.yaml` | Declare supported Contract versions. |
| Modify | `adapters/runtime/playwright/capabilities.yaml` | Declare supported Contract versions. |
| Modify | `adapters/runtime/proof-fixtures/capabilities.yaml` | Own common adapter conformance fixtures. |
| Create | `tests/contract-v1-extension-registry.sh` | Red-first extension registration and source-authority tests. |
| Create | `tests/contract-v1-adapter-conformance.sh` | Supported-version and adapter conformance tests. |
| Create | `scripts/migrate-accelerate-contract-v1.py` | Dry-run-first bounded legacy-to-v1 migration tool. |
| Create | `tests/contract-v1-migration.sh` | Valid, lossy, dual-write, version-bound, and no-mutation tests. |
| Create | `tests/contract-v1-closure-cutover.sh` | Consumer-boundary authoritative cutover tests. |
| Create | `scripts/export-global-runtime.py` | Deterministic source-to-`global-runtime/accelerate/` export. |
| Create | `scripts/snapshot-global-runtime.py` | Write-once prior-byte snapshot and digest validation before replacement. |
| Create | `scripts/restore-global-runtime.py` | Manifest-bound disposable prior-release restore and verification. |
| Create | `scripts/validate-historical-runtime.py` | Manifest-bound historical-byte validator that never compares current source. |
| Create | `scripts/demote-accelerate-contract-v1.py` | Demote only manifest-listed canonical source/registry/selection slices and emit a receipt. |
| Create | `scripts/validate-runtime-package.py` | Explicit-root generated package validator. |
| Modify | `scripts/sync-skills-to-global.sh` | Delegate repository export generation; optional user-home deploy remains outward-only. |
| Modify | `scripts/check-global-skill-mirror.sh` | Run source/export manifest and byte-drift checks. |
| Create | `global-runtime/accelerate/export-manifest.json` | Generated file list, modes, digests, source revision, and authority marker. |
| Modify | `global-runtime/accelerate/evals/evals.json` | Generated projection of the accepted repository eval corpus. |
| Create | `planning/evidence/dated-proof-appendix/accelerate-contract-v1-prior-release-backup-${RUN_KEY}.json` | Typed prior-release identity, source-demotion set, digests, retention owner/expiry, and restore receipts. |
| Create | `planning/evidence/dated-proof-appendix/accelerate-contract-v1-prior-runtime-${RUN_KEY}/` | Write-once prior bytes, inventory, and aggregate digest. |
| Create | `docs/reference/accelerate-contract-v1.md` | Public V1 status, authority, lifecycle, migration, and rollback reference. |
| Create | `docs/reference/accelerate-contract-v1-vocabulary.md` | Public class, mode, and outcome catalog. |
| Create | `docs/reference/accelerate-contract-v1-gates.md` | Public gate catalog. |
| Create | `docs/reference/accelerate-contract-v1-evidence.md` | Public evidence and closure catalog. |
| Create | `docs/reference/accelerate-contract-v1-runtime-catalog.md` | Public adapter/provider capability inventory. |
| Create | `planning/evidence/dated-proof-appendix/accelerate-contract-v1-final-review-${RUN_KEY}.md` | Final forensic reconciliation and closure evidence. |
| Modify | `README.md` | Public Contract V1 navigation and status. |
| Modify | `core/control-plane/README.md` | Canonical contract and public reference navigation. |
| Create | `tests/fixtures/workflow-readback/` | Local, GitHub, Linear, malformed, unavailable, and stale fixtures. |
| Create | `tests/fixtures/contract-v1-adapters/` | Extension, conformance, and Hermes interoperability fixtures. |
| Create | `tests/fixtures/contract-v1-migration/` | Valid legacy inputs, exact v1 outputs, and blocking fixtures. |
| Create | `tests/fixtures/contract-v1-closure-cutover/` | Early-close, provider-mismatch, partial-publication, and predecessor-path fixtures. |
| Create | `tests/contract-v1-runtime-integration.sh` | Optional install/reentry/no-install and adapter selection tests. |
| Create | `tests/workflow-readback-v1.sh` | Provider normalization, issue/PR, freshness, and failure tests. |
| Create | `tests/global-runtime-export-v1.sh` | Determinism, authority, user-home isolation, and drift tests. |
| Create | `tests/global-runtime-snapshot-v1.sh` | Snapshot-before-replace, payload tamper, and host-backup tests. |
| Create | `tests/contract-v1-source-demotion.sh` | Canonical predecessor demotion, receipt, regeneration, and parity-order tests. |
| Create | `scripts/verify-contract-v1-rollback-lanes.sh` | Operational ordered fail-fast workspace/source/history/host rollback verifier. |
| Create | `tests/contract-v1-rollback-lanes.sh` | Safe non-mutating fixture wrapper; no args equals `--self-test`. |
| Create | `tests/runtime-package-validator.sh` | Explicit-root generated package and manifest tests. |
| Modify | `tests/workflow-backend-neutrality.sh` | Reject new Linear/provider coupling in core and generic scripts. |
| Modify | `tests/ci-contract.sh` | Require all Wave 5 integration/export tests. |

## Readback Packet

The normalized packet is provider-neutral and supports issue-only, PR-only, both, or neither with explicit gaps:

```json
{
  "schema_version": 1,
  "adapter": "local|github-pr|github-issues|linear",
  "capability": "workflow-readback",
  "status": "available|partial|unavailable|stale|malformed",
  "read_at": "<RFC3339 UTC>",
  "source_revision": "<revision-or-none>",
  "work_item": {
    "id": "<stable-id>",
    "url": "<url-or-local-locator>",
    "state": "<backend-neutral lifecycle>",
    "title": "<text>",
    "owner": "<owner-or-none>"
  },
  "change_request": {
    "id": "<stable-id-or-none>",
    "url": "<url-or-none>",
    "state": "open|merged|closed|none",
    "head_revision": "<revision-or-none>",
    "merge_revision": "<revision-or-none>"
  },
  "gaps": ["<explicit unsupported or unreadable field>"],
  "raw_digest": "sha256:<64-hex>"
}
```

Provider fields not available are `null` plus a gap label, never fabricated. Freshness TTL and source identity are adapter inputs; a stale successful read is `stale`, not `available`.

### ACV1-W5-001: Freeze Integration/Provider/Export Denominator And Entry Proof

**Depends on:** `ACV1-W3-009`, `ACV1-W4-008`

**Files:**
- Create: `scripts/contract-v1-run-key.py`
- Create: `core/contracts/v1/schemas/run-key-initialization-intent.schema.json`
- Create: `core/contracts/v1/schemas/run-key-initialization-receipt.schema.json`
- Create: `planning/evidence/contract-v1-wave-5-run-key-initialization-intent.json` (write-once execution evidence)
- Create: `planning/evidence/contract-v1-wave-5-run-key-initialization.json` (write-once execution evidence)
- Create: `tests/contract-v1-run-key.sh`
- Create: `tests/fixtures/contract-v1-run-key/valid/initialization-intent.json`
- Create: `tests/fixtures/contract-v1-run-key/valid/initialization-receipt.json`
- Create: `tests/fixtures/contract-v1-run-key/valid/crash-after-intent.json`
- Create: `tests/fixtures/contract-v1-run-key/valid/crash-after-packet.json`
- Create: `tests/fixtures/contract-v1-run-key/valid/crash-after-anchor.json`
- Create: `tests/fixtures/contract-v1-run-key/invalid/valid-format-key-mutation.json`
- Create: `tests/fixtures/contract-v1-run-key/invalid/receipt-pointer-mutation.json`
- Create: `tests/fixtures/contract-v1-run-key/invalid/packet-digest-mutation.json`
- Create: `tests/fixtures/contract-v1-run-key/invalid/receipt-overwrite.json`
- Create: `tests/fixtures/contract-v1-run-key/invalid/intent-packet-mismatch.json`
- Create: `tests/fixtures/contract-v1-run-key/invalid/intent-anchor-mismatch.json`
- Create: `tests/fixtures/contract-v1-run-key/invalid/downstream-artifact-before-anchor.json`
- Create: `tests/fixtures/contract-v1-run-key/invalid/intent-tamper.json`
- Runtime state: `.accelerate/workflow/active/accelerate-contract-v1-wave-5-entry.json`
- Runtime lock: `.accelerate/locks/contract-v1-wave-5-run-key.lock`

- [ ] Verify Wave 3 and Wave 4 closure packets, source revisions, corpus denominator, and canonical source-package checks.
- [ ] Run `bash tests/all.sh`.

Expected: exit `0`; final line `all tests passed`.

- [ ] Freeze `W5-C01` through `W5-C12`, four integration scenarios (no
`.accelerate/`, installed local-only, GitHub issue/PR readback, and Linear issue
readback with no native PR authority), extension/conformance and closure-cutover
negative matrices, source allowlist, count, and digest.
- [ ] Capture current generated runtime manifest/digests and confirm the export source set contains no path under `$HOME`, `~/.claude`, `~/.codex`, or `~/.agents`.
- [ ] Freeze the prior accepted release reference and retention owner before any
generated-runtime mutation. All export/mirror proof commands must pass
`--package-root global-runtime/accelerate` or
`--package-root /tmp/accelerate-contract-v1-host`; no proof command may use a
default target.
- [ ] **Red:** Create `tests/contract-v1-run-key.sh`. Require `--initialize` to
  acquire the fixed exclusive lock and follow intent -> packet -> final anchor.
  Add crash injection after intent fsync, after fully sealed packet publication,
  final-mode application, and fsync, and after final-anchor publication/fsync.
  A locked retry must reuse the intent's exact key, packet bytes, and expected
  packet mode, complete only missing matching stages, and return read-only
  idempotent success when all three already match. The crash-after-anchor fixture
  records and compares intent/packet/anchor bytes, modes, and mtimes across retry.
  Reject anchor-without-intent,
  packet-key-without-intent, intent/packet/anchor mismatch or tamper, any new key
  generation during recovery, and downstream keyed artifacts before final
  anchor. Require `--load` to compare all three records and reject valid-format
  key, pointer, or digest mutation.
- [ ] Run `bash tests/contract-v1-run-key.sh`; expect non-zero with
  `run key helper missing`.
- [ ] **Green:** Implement `scripts/contract-v1-run-key.py`. `--initialize`
  opens `.accelerate/locks/contract-v1-wave-5-run-key.lock` and holds an
  exclusive lock through state inspection and completion. Only when intent and
  anchor are absent and the packet is uninitialized may it generate one key matching
  `^[0-9]{8}T[0-9]{6}Z-[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$`
  and build the exact canonical packet bytes with top-level `run_key` and fixed
  `run_key_initialization_receipt` pointer while preserving all other fields.
- [ ] **Green, stage 1:** O_EXCL-create/fsync/chmod-read-only the fixed intent
  `planning/evidence/contract-v1-wave-5-run-key-initialization-intent.json`
  before packet mutation. Its closed exact fields are `packet_id`, `packet_path`,
  `proposed_run_key`, `preinitialization_packet_digest`, `expected_packet_mode`
  (the canonical four-digit octal string `0444`),
  `canonical_packet_bytes_base64`, `canonical_packet_digest`, `creator`,
  `tool_version`, `created_at`, and `creation_proof` for exclusive create/fsync.
  Fsync the parent directory. Never overwrite or regenerate this intent.
- [ ] **Green, stage 2:** Decode and digest-check the intent's canonical bytes,
  atomically publish exactly those bytes to the packet, apply the intent's final
  `expected_packet_mode`, verify the packet is fully sealed at that mode, and
  fsync the packet plus parent directory. No reserialization, fresh key
  generation, or later packet write/chmod/seal is allowed.
- [ ] **Green, stage 3:** Validate intent and the already sealed packet bytes,
  digest, key, pointer, and mode, then O_EXCL-create the
  fixed final anchor `planning/evidence/contract-v1-wave-5-run-key-initialization.json`
  at its final immutable mode from them. Its closed exact fields are
  `intent_path`, `intent_digest`, `packet_id`, `packet_path`,
  `original_run_key`, `packet_digest`, `packet_mode`, `creator`, `tool_version`,
  `created_at`, and `creation_proof: {method:
  "O_CREAT|O_EXCL", exclusive_create: true, packet_replace: "atomic", fsync:
  true}`. Fsync the anchor and its parent directory; this final-anchor publication
  is the last durable initialization operation. Never overwrite or repair
  intent/anchor, and never write, chmod, or seal the packet after anchor creation.
- [ ] **Green, locked recovery:** If intent exists, never generate a key. Validate
  its schema, immutable mode, fixed path, canonical bytes/digest, and creator/tool
  metadata. With no anchor, permit only: unchanged preinitialization packet ->
  publish intent bytes; or byte-identical canonical packet -> create anchor.
  Before either resume, reject any `${proposed_run_key}` downstream export,
  backup, rollback, or final-review artifact outside intent/packet/anchor. If
  intent, canonical packet, final packet mode, and anchor all match, return
  idempotent success without any write, chmod, seal, or timestamp change. Any
  other presence, bytes, digest, pointer, identity, mode, or stage combination
  fails closed.
- [ ] **Green:** `--load` takes the same lock, resolves fixed intent and anchor
  independently from `--root`, validates both schemas/immutable modes, and
  compares intent canonical bytes/digest/expected mode, final packet
  bytes/digest/pointer/key/mode, and anchor intent/packet/mode bindings. Any
  mismatch fails; `--load` performs no write or metadata mutation and prints only
  the anchored key.
- [ ] Initialize exactly once:
  `python3 scripts/contract-v1-run-key.py --root . --packet .accelerate/workflow/active/accelerate-contract-v1-wave-5-entry.json --initialize`.
- [ ] Every later run-scoped command must load and validate, never generate or
  recompute: `RUN_KEY="$(python3 scripts/contract-v1-run-key.py --root . --packet .accelerate/workflow/active/accelerate-contract-v1-wave-5-entry.json --load)"`.
- [ ] Re-run `bash tests/contract-v1-run-key.sh`; expect
  `contract v1 run key tests passed`; all three crash points recover with the
  original key, exact bytes, and final packet mode; post-anchor retry is
  validation-only and idempotent with bytes, modes, and mtimes unchanged;
  repeated loads change no content or metadata; and all
  mismatch/tamper/downstream fixtures fail stably.

## Chunk 1: Optional Local Runtime Integration

### ACV1-W5-002: Define Optional Runtime Adapter, Read-Only Check, And Explicit Atomic Install/Upgrade

**Depends on:** `ACV1-W5-001`

**Files:**
- Create: `adapters/runtime/accelerate-contract-v1/capabilities.yaml`
- Create: `adapters/runtime/accelerate-contract-v1/README.md`
- Create: `adapters/runtime/accelerate-contract-v1/installation-manifest.schema.json`
- Create: `adapters/runtime/codex/contract-extension.yaml`
- Create: `adapters/runtime/opencode/contract-extension.yaml`
- Create: `adapters/runtime/claude/contract-extension.yaml`
- Create: `adapters/runtime/hermes/contract-extension.yaml`
- Create: `adapters/workflow/local/contract-extension.yaml`
- Modify: `core/contracts/v1/extension-registry.yaml`
- Modify: `adapters/runtime/codex/capabilities.yaml`
- Modify: `adapters/runtime/opencode/capabilities.yaml`
- Modify: `adapters/runtime/claude/capabilities.yaml`
- Modify: `adapters/runtime/hermes/capabilities.yaml`
- Create: `onboarding/local-workspace/integrate-contract-v1.sh`
- Create: `onboarding/local-workspace/restore-contract-v1.sh`
- Create: `tests/contract-v1-runtime-integration.sh`
- Create: `tests/fixtures/contract-v1-runtime-integration/predecessor-installation.json`
- Create: `tests/fixtures/contract-v1-runtime-integration/invalid-installation-digest.json`
- Create: `tests/fixtures/contract-v1-runtime-integration/rollback-readback.json`
- Create: `tests/contract-v1-extension-registry.sh`
- Create: `tests/fixtures/contract-v1-adapters/extensions/invalid-core-namespace.yaml`
- Create: `tests/fixtures/contract-v1-adapters/extensions/invalid-external-authority.yaml`
- Create: `tests/fixtures/contract-v1-adapters/extensions/missing-supported-version.yaml`

- [ ] **Red:** In temporary repositories, test `--check` with no `.accelerate/`, explicit `--install`, repeated install, unsupported newer local version, and `--upgrade` from the supported predecessor. Before either mutating mode, require creation of a write-once `.accelerate/status/contract-v1-predecessor/<installation-id>/` backup, complete managed-path/mode/digest inventory validation, refusal to overwrite an existing backup ID, and proof that no installation manifest or managed file changes before backup validation succeeds.
- [ ] **Red:** Test project-local rollback with an explicit project root,
installation manifest, predecessor version, backup digest, atomic restore failure
injection, and post-restore readback. Reject use of the generated-runtime
snapshot/restore tool as workspace evidence.
- [ ] **Red:** Before creating manifests, require all five exact SDD
`contract-extension.yaml` paths, Codex gate IDs, owning adapter, trigger,
evidence capabilities, allowed skips, dependencies, risk escalation, and
`supported_contract_versions: [1]`. Reject `core.*` extension IDs, external or
user-home authority, and unsupported versions.
- [ ] Run `bash tests/contract-v1-extension-registry.sh` before creating any
manifest.

Expected: non-zero with
`missing adapters/runtime/codex/contract-extension.yaml`; no manifest or
registry mutation exists yet.
- [ ] Require `--check` to be read-only and return structured status `not-installed` with exit `0`; only `--install`/`--upgrade` may mutate.
- [ ] Run `bash tests/contract-v1-runtime-integration.sh`.

Expected: non-zero with `integration entrypoint missing`.

- [ ] **Green:** Add capability manifest and integration script. Require explicit
project root and refuse symlink/path escape. For each install/upgrade, first
create the write-once predecessor backup at the generated installation ID,
inventory every managed path/mode/digest, fsync and validate that inventory, and
refuse an existing destination. Only after that validation may the script stage
`.accelerate/status/contract-v1-installation.json` with installed/source and
predecessor versions, managed file digests, backup locator/digest, owner, and
backup validation receipt together with all managed replacements, then publish
the manifest and managed files as one atomic transaction.
- [ ] **Green:** Implement `restore-contract-v1.sh` to validate the explicit
project root plus installation manifest, stage the predecessor backup, verify
version/digests, atomically restore only managed `.accelerate/` files, and read
back the predecessor version/state before success.
- [ ] **Green:** Create the five source-owned extension manifests, register them
in `core/contracts/v1/extension-registry.yaml`, and add supported-version
declarations to the four host capability manifests. These are repository files,
not external runtime mutations; Hermes remains optional and cannot be authority.
- [ ] Run `bash tests/contract-v1-runtime-integration.sh`.

- [ ] Run `bash tests/contract-v1-extension-registry.sh`.

Expected: no-install fixture has an unchanged tree; install/upgrade fixtures
prove backup-before-manifest-before-mutation ordering; incomplete/tampered or
existing-destination backups fail with no mutation; second install is
idempotent; project-local rollback/readback reports the predecessor inventory
and a workspace-only receipt; all five extension manifests pass.

- [ ] Commit checkpoint: `feat(runtime): add optional contract v1 integration`.

### ACV1-W5-003: Wire Bootstrap, Materialization, Validation, And Reentry

**Depends on:** `ACV1-W5-002`

**Files:**
- Modify: `onboarding/local-workspace/bootstrap-or-reentry.sh`
- Modify: `onboarding/local-workspace/emit-v2.sh`
- Modify: `onboarding/local-workspace/validate-v2.sh`
- Modify: `onboarding/local-workspace/read-local-handoff.sh`
- Modify: `onboarding/local-workspace/check-evidence-gate.sh`
- Modify: `onboarding/local-workspace/prepare-closure.sh`
- Modify: `onboarding/local-workspace/v2-materialization-contract.md`
- Modify: `tests/contract-v1-runtime-integration.sh`

- [ ] **Red:** Test classifications `not-installed`, `reusable`, `light-reentry`, `upgrade-required`, and `unsupported-newer-version`. Ensure read-only/conversational classification never auto-installs.
- [ ] **Green:** Route installation to `integrate-contract-v1.sh`; preserve
existing V2 state; add only Contract V1-owned files; render normalized
adapter/readback status and gaps. Add disabled compatibility hooks for the Wave
3 evidence/closure library, but keep authoritative closure on the predecessor
path until `ACV1-W5-007` passes adapter/export/rollback/forensic preflight.
- [ ] Run the focused test.

Expected: all five classifications match; no unrelated `.accelerate/` file changes.

- [ ] Commit checkpoint: `feat(runtime): wire contract v1 local reentry`.

## Chunk 2: Workflow And Runtime Adapter Readback

### ACV1-W5-004: Define And Normalize Backend-Neutral Workflow Readback

**Depends on:** `ACV1-W5-003`

**Files:**
- Create: `core/runtime-packets/schemas/workflow-readback-v1.schema.json`
- Create: `adapters/workflow/readback-contract-v1.md`
- Create: `scripts/normalize-workflow-readback.py`
- Create: `tests/fixtures/workflow-readback/local-valid.json`
- Create: `tests/fixtures/workflow-readback/github-valid.json`
- Create: `tests/fixtures/workflow-readback/linear-valid.json`
- Create: `tests/fixtures/workflow-readback/missing-id.json`
- Create: `tests/fixtures/workflow-readback/fabricated-pr.json`
- Create: `tests/fixtures/workflow-readback/unmapped-state.json`
- Create: `tests/fixtures/workflow-readback/malformed.json`
- Create: `tests/fixtures/workflow-readback/api-error.json`
- Create: `tests/fixtures/workflow-readback/auth-error.json`
- Create: `tests/fixtures/workflow-readback/rate-limit.json`
- Create: `tests/fixtures/workflow-readback/stale.json`
- Create: `tests/workflow-readback-v1.sh`

- [ ] **Red:** Add valid local/GitHub/Linear fixtures and invalid missing-ID, fabricated-PR, unmapped-state, malformed JSON, API-error, auth-error, rate-limit, and stale fixtures.
- [ ] Run `bash tests/workflow-readback-v1.sh`.

Expected: non-zero with `workflow readback normalizer missing`.

- [ ] **Green:** Normalize fixture/stdin input with explicit `--adapter`, `--read-at`, and `--ttl-seconds`. Map provider state through adapter-owned maps; never put provider status names in the core enum.
- [ ] Exit `0` for `available`/honest `partial`, `1` for `unavailable`/`stale`, and `2` for malformed or contract-invalid input.
- [ ] Run the focused test.

Expected: providers produce the same packet shape; Linear fixture has an explicit PR gap; error fixtures never report `available`.

- [ ] Commit checkpoint: `feat(workflow): normalize issue and pr readback`.

### ACV1-W5-005: Select Workflow Adapters By Capability And Freshness

**Depends on:** `ACV1-W5-004`

- [ ] Confirm proposed decision `ACV1-D016` is human-accepted before implementing
migration behavior; otherwise this task remains blocked after its red fixtures.

**Files:**
- Modify: `onboarding/local-workspace/read-workflow-capabilities.sh`
- Modify: `onboarding/local-workspace/select-workflow-capability.sh`
- Modify: `onboarding/local-workspace/read-github-pr-adapter.sh`
- Modify: `onboarding/local-workspace/read-linear-adapter.sh`
- Modify: `adapters/workflow/local/capabilities.yaml`
- Modify: `adapters/workflow/github-pr/capabilities.yaml`
- Modify: `adapters/workflow/github-issues/capabilities.yaml`
- Modify: `adapters/workflow/linear/capabilities.yaml`
- Modify: `adapters/runtime/python-uv/capabilities.yaml`
- Modify: `adapters/runtime/node/capabilities.yaml`
- Modify: `adapters/runtime/browser/capabilities.yaml`
- Modify: `adapters/runtime/agent-browser/capabilities.yaml`
- Modify: `adapters/runtime/physical-agent/capabilities.yaml`
- Modify: `adapters/runtime/locale-pack-parity/capabilities.yaml`
- Modify: `adapters/runtime/web-content-reader/capabilities.yaml`
- Modify: `adapters/runtime/tailwind/capabilities.yaml`
- Modify: `adapters/runtime/document-export/capabilities.yaml`
- Modify: `adapters/runtime/model-voice/capabilities.yaml`
- Modify: `adapters/runtime/chrome-devtools/capabilities.yaml`
- Modify: `adapters/runtime/playwright/capabilities.yaml`
- Modify: `adapters/runtime/proof-fixtures/capabilities.yaml`
- Modify: `tests/workflow-readback-v1.sh`
- Create: `tests/contract-v1-adapter-conformance.sh`
- Create: `tests/fixtures/contract-v1-adapters/conformance/valid.json`
- Create: `tests/fixtures/contract-v1-adapters/conformance/missing-supported-version.json`
- Create: `tests/fixtures/contract-v1-adapters/conformance/unsupported-version.json`
- Create: `tests/fixtures/contract-v1-adapters/hermes/valid.json`
- Create: `tests/fixtures/contract-v1-adapters/hermes/invalid-external-authority.json`
- Create: `tests/fixtures/contract-v1-adapters/hermes/unsupported-version.json`
- Create: `scripts/migrate-accelerate-contract-v1.py`
- Create: `tests/contract-v1-migration.sh`
- Create: `tests/fixtures/contract-v1-migration/valid/legacy-wave-gated.json`
- Create: `tests/fixtures/contract-v1-migration/valid/legacy-closure-packet.json`
- Create: `tests/fixtures/contract-v1-migration/expected/wave-v1.json`
- Create: `tests/fixtures/contract-v1-migration/expected/closure-v1.json`
- Create: `tests/fixtures/contract-v1-migration/invalid/lossy-conversion.json`
- Create: `tests/fixtures/contract-v1-migration/invalid/dual-write.json`
- Create: `tests/fixtures/contract-v1-migration/invalid/unsupported-version.json`

**Child slice: Provider And Capability Selection**

- **Owner role:** workflow capability selection engineer.
- **Owned exact surfaces:** `onboarding/local-workspace/read-workflow-capabilities.sh`,
  `onboarding/local-workspace/select-workflow-capability.sh`,
  `onboarding/local-workspace/read-github-pr-adapter.sh`,
  `onboarding/local-workspace/read-linear-adapter.sh`,
  `tests/workflow-readback-v1.sh`, and
  `tests/workflow-backend-neutrality.sh`.
- [ ] **Red:** Test absent/present adapters, equal-capability ambiguity, Linear
  issue plus GitHub PR ownership, bounded output, timeout/error propagation,
  digesting, and no writes. Run both focused tests; expect stable failure on
  implicit first-provider selection.
- [ ] **Green:** Filter by identity, capability, status, version, freshness, and
  explicit project choice; keep provider readers as raw acquisition adapters.
- [ ] **Proof:** Run both focused tests; expect no provider preference or write.
- **Rollback checkpoint:** restore only selection/readback declarations and mark
  the regressed capability blocked; never silently select a sibling.
- **Commit boundary:** one task-scoped bounded `ACV1-W5-005` child-slice commit,
  keeping selection tests and implementation inseparable; no commit is currently
  authorized.

**Child slice: Version And Adapter Conformance**

- **Owner role:** adapter compatibility engineer.
- **Owned exact surfaces:** `adapters/workflow/local/capabilities.yaml`,
  `adapters/workflow/github-pr/capabilities.yaml`,
  `adapters/workflow/github-issues/capabilities.yaml`,
  `adapters/workflow/linear/capabilities.yaml`,
  `adapters/runtime/python-uv/capabilities.yaml`,
  `adapters/runtime/node/capabilities.yaml`,
  `adapters/runtime/browser/capabilities.yaml`,
  `adapters/runtime/agent-browser/capabilities.yaml`,
  `adapters/runtime/physical-agent/capabilities.yaml`,
  `adapters/runtime/locale-pack-parity/capabilities.yaml`,
  `adapters/runtime/web-content-reader/capabilities.yaml`,
  `adapters/runtime/tailwind/capabilities.yaml`,
  `adapters/runtime/document-export/capabilities.yaml`,
  `adapters/runtime/model-voice/capabilities.yaml`,
  `adapters/runtime/chrome-devtools/capabilities.yaml`,
  `adapters/runtime/playwright/capabilities.yaml`,
  `adapters/runtime/proof-fixtures/capabilities.yaml`,
  `tests/contract-v1-adapter-conformance.sh`,
  `tests/fixtures/contract-v1-adapters/conformance/valid.json`,
  `tests/fixtures/contract-v1-adapters/conformance/missing-supported-version.json`,
  and `tests/fixtures/contract-v1-adapters/conformance/unsupported-version.json`.
- [ ] **Red:** Inventory every repo-owned capability manifest and require a
  supported or explicit unsupported version declaration. Run
  `bash tests/contract-v1-adapter-conformance.sh` before manifest changes; expect
  a stable missing-version failure.
- [ ] **Green:** Add version bounds and common fixture-driven conformance; reject
  mismatch before adapter selection without live-provider execution.
- [ ] **Proof:** Run adapter conformance plus extension registry tests; expect all
  positive/negative version cases to pass for their declared labels.
- **Rollback checkpoint:** revert only version/conformance changes as a unit and
  block adapters whose prior declarations cannot prove Contract v1 support.
- **Commit boundary:** one task-scoped bounded `ACV1-W5-005` child-slice commit,
  keeping conformance test, fixtures, and declarations inseparable.

**Child slice: Hermes Interoperability**

- **Owner role:** Hermes interoperability maintainer.
- **Owned exact surfaces:**
  `tests/fixtures/contract-v1-adapters/hermes/valid.json`,
  `tests/fixtures/contract-v1-adapters/hermes/invalid-external-authority.json`,
  and `tests/fixtures/contract-v1-adapters/hermes/unsupported-version.json`.
  Read/test predecessor-owned `adapters/runtime/hermes/capabilities.yaml`,
  `adapters/runtime/hermes/contract-extension.yaml`, and the parameterized
  `tests/contract-v1-adapter-conformance.sh`; do not duplicate their create owner.
- [ ] **Red:** Run `bash tests/contract-v1-adapter-conformance.sh --hermes` before
  interoperability handling; require rejection of Hermes home paths, schema IDs,
  runtime assumptions, authority claims, and unsupported versions.
- [ ] **Green:** Implement fixture-only optional translation against repository
  Contract v1; never invoke or mutate an external Hermes installation.
- [ ] **Proof:** Re-run the Hermes-focused conformance mode; valid translation
  passes and authority/version attacks fail for stable labels.
- **Rollback checkpoint:** disable only Hermes capability/translation and retain
  fixtures/findings; core and sibling adapters remain unchanged.
- **Commit boundary:** one task-scoped bounded `ACV1-W5-005` child-slice commit,
  keeping Hermes fixtures and conformance delta inseparable.

**Child slice: Legacy Migration**

- **Owner role:** migration engineer.
- **Owned exact surfaces:** `scripts/migrate-accelerate-contract-v1.py`,
  `tests/contract-v1-migration.sh`,
  `tests/fixtures/contract-v1-migration/valid/legacy-wave-gated.json`,
  `tests/fixtures/contract-v1-migration/valid/legacy-closure-packet.json`,
  `tests/fixtures/contract-v1-migration/expected/wave-v1.json`,
  `tests/fixtures/contract-v1-migration/expected/closure-v1.json`,
  `tests/fixtures/contract-v1-migration/invalid/lossy-conversion.json`,
  `tests/fixtures/contract-v1-migration/invalid/dual-write.json`, and
  `tests/fixtures/contract-v1-migration/invalid/unsupported-version.json`.
- [ ] Confirm proposed decision `ACV1-D016` is accepted before Green.
- [ ] **Red:** Test two valid legacy inputs and exact outputs, default no-write
  dry-run, explicit `--apply --output`, bounds `unversioned|0 -> 1`, and reject
  newer/unknown versions, lossy conversion, source/output aliasing, and dual
  write. Run the migration test before tool creation; expect stable missing-tool
  failure and byte-identical inputs.
- [ ] **Green:** Implement deterministic offline conversion/reporting. Apply
  requires a new contained output; validate v1 output and keep legacy read-only.
- [ ] **Refactor:** Reuse canonical parsing/version/serialization/validation from
  `scripts/accelerate_contract/`; preserve stable 0/1/2 exits.
- [ ] **Proof:** Run valid dry-runs and all blockers twice; exact outputs match and
  no legacy/unrelated file changes.
- **Rollback checkpoint:** disable migration, preserve legacy and accepted v1
  outputs separately, remove only recorded unaccepted output, and never resume
  dual write.
- **Commit boundary:** one task-scoped bounded `ACV1-W5-005` child-slice commit,
  keeping tool, tests, and all fixtures inseparable.

## Chunk 3: Generated Global Runtime And Drift

### ACV1-W5-006: Generate Global Runtime Deterministically From Source

**Depends on:** `ACV1-W4-005`, `ACV1-W5-005`

**Files:**
- Create: `scripts/export-global-runtime.py`
- Create: `scripts/snapshot-global-runtime.py`
- Create: `scripts/restore-global-runtime.py`
- Create: `scripts/validate-historical-runtime.py`
- Create: `scripts/demote-accelerate-contract-v1.py`
- Create: `scripts/validate-runtime-package.py`
- Create: `global-runtime/accelerate/export-manifest.json`
- Modify: `global-runtime/accelerate/evals/evals.json`
- Create: `planning/evidence/dated-proof-appendix/accelerate-contract-v1-prior-release-backup-${RUN_KEY}.json`
- Create: `planning/evidence/dated-proof-appendix/accelerate-contract-v1-prior-runtime-${RUN_KEY}/` (write-once execution evidence)
- Modify: `scripts/sync-skills-to-global.sh`
- Create: `tests/global-runtime-export-v1.sh`
- Create: `tests/global-runtime-snapshot-v1.sh`
- Create: `tests/contract-v1-source-demotion.sh`
- Create: `scripts/verify-contract-v1-rollback-lanes.sh`
- Create: `tests/contract-v1-rollback-lanes.sh`
- Create: `tests/runtime-package-validator.sh`

- [ ] **Red:** Export twice into separate explicit temporary roots and require
identical lists, bytes, modes, and manifest digests. Test generated eval
projection and package validation. Add prior-release manifest/restore failures
for bad release, source, backup, file, mode, and manifest digests, missing
retention owner/expiry, and any implicit `$HOME` target.
- [ ] **Red:** Require a write-once snapshot of every current
`global-runtime/accelerate/` byte before the first replacement. Test missing
payload, changed byte/mode, digest mismatch, snapshot overwrite, manifest created
before snapshot validation, host deployment without explicit backup target,
backup-manifest overwrite, and missing host deployment/rollback receipt.
- [ ] **Red:** Require source-first repository rollback. Test that direct snapshot
restore to `global-runtime/accelerate/` is rejected; source demotion fails for an
unlisted or dirty/unowned path; regeneration cannot start before a validated
source-demotion receipt; and normal mirror parity cannot validate historical
bytes against current source. Require historical restore only under `/tmp` and
only through the manifest-bound historical validator.
- [ ] **Red:** Create `tests/contract-v1-rollback-lanes.sh` as a non-mutating
fixture wrapper. No arguments and `--self-test` must execute the same safe tests;
reject operational target arguments. Use isolated temporary fixture commands to
test the future verifier's workspace, source-demotion/regenerated-export,
disposable historical, then optional host order. Inject one failure per lane and
require immediate stop, preservation of completed receipts, and absence of every
later lane receipt. Require distinct `${RUN_KEY}`-namespaced receipt/status
files and an explicit `not-triggered` host status when host deployment was not
triggered.
- [ ] Run `bash tests/global-runtime-export-v1.sh`.
- [ ] Run `bash tests/global-runtime-snapshot-v1.sh`.
- [ ] Run `bash tests/contract-v1-source-demotion.sh`.
- [ ] Run `bash tests/contract-v1-rollback-lanes.sh`; expect non-zero with
`operational rollback verifier missing` before its script exists. Run again with
`--self-test` and require the same status/output.

Expected: non-zero with `global runtime exporter missing`,
`prior runtime snapshotter missing`, `source demotion tool missing`, and
`operational rollback verifier missing` from their respective focused suites.

- [ ] **Green, before any replacement:** Load the persisted key and run
`RUN_KEY="$(python3 scripts/contract-v1-run-key.py --root . --packet .accelerate/workflow/active/accelerate-contract-v1-wave-5-entry.json --load)" && python3 scripts/snapshot-global-runtime.py --source-root global-runtime/accelerate --evidence-root "planning/evidence/dated-proof-appendix/accelerate-contract-v1-prior-runtime-${RUN_KEY}" --snapshot`.
The evidence root contains write-once `payload/`, relative path/mode/digest
inventory, source revision, aggregate digest, owner, and timestamp; refuse an
existing destination.
- [ ] Validate the immutable snapshot with
`RUN_KEY="$(python3 scripts/contract-v1-run-key.py --root . --packet .accelerate/workflow/active/accelerate-contract-v1-wave-5-entry.json --load)" && python3 scripts/snapshot-global-runtime.py --evidence-root "planning/evidence/dated-proof-appendix/accelerate-contract-v1-prior-runtime-${RUN_KEY}" --check`.
- [ ] Only after snapshot validation, write the typed prior-release manifest against
`core/contracts/v1/schemas/release-backup-manifest.schema.json`. It records
prior Git revision, canonical package digest, export-manifest digest, every
relative path/digest/mode, immutable snapshot locator/aggregate digest, restore
tool version, retention owner, `retain_until`, and the exact bounded canonical
source/extension-registry/adapter-selection commit set required for predecessor
demotion.
- [ ] **Green:** Implement `demote-accelerate-contract-v1.py` to validate that
manifest-listed bounded set, reject unowned overlap, apply only the accepted
predecessor transition, and emit a source-demotion receipt before export.
Implement `validate-historical-runtime.py` to compare only the restored `/tmp`
tree against the typed prior-release manifest/snapshot identity and to reject
the repository export path.
- [ ] **Green:** Implement `scripts/verify-contract-v1-rollback-lanes.sh` with
`set -euo pipefail` as the operational aggregate. Require explicit
`--root`, `--entry-packet`, workspace/source/history targets, receipt root, and either
explicit host target/backup or `--host-not-triggered`. Load and anchor-validate
the run key, derive all run-scoped artifact/receipt paths from it, never call a
clock or UUID generator, run the four lanes in order, validate each receipt/status
before advancing, and stop on the first failure. Keep individual commands below
for diagnosis.
- [ ] **Green:** Complete the test wrapper so no-arg behavior is byte-for-byte
equivalent to `--self-test`, uses only temporary fixtures/stubs, proves the
operational script is not invoked against real targets, and leaves repository,
workspace, generated export, and host state unchanged.
- [ ] **Green:** Export only an explicit repository-relative allowlist, including
the accepted eval projection. Require `--source-root` and `--package-root`;
normalize metadata, exclude wall-clock time from content digests, stage,
validate, and only then atomically replace the explicit repository export.
- [ ] `sync-skills-to-global.sh` may optionally deploy only with explicit
`--package-root` and `--backup-root`; it snapshots the managed host target before
replacement, writes and validates a target-bound backup manifest without
overwriting an existing backup, emits a distinct deployment/rollback receipt,
never reads user-home files as source, and has no default target.
- [ ] Run the focused test.

Expected: deterministic exports match and user-home isolation tests pass.

- [ ] Run the exact disposable restore drill:

`RUN_KEY="$(python3 scripts/contract-v1-run-key.py --root . --packet .accelerate/workflow/active/accelerate-contract-v1-wave-5-entry.json --load)" && python3 scripts/restore-global-runtime.py --manifest "planning/evidence/dated-proof-appendix/accelerate-contract-v1-prior-release-backup-${RUN_KEY}.json" --snapshot-root "planning/evidence/dated-proof-appendix/accelerate-contract-v1-prior-runtime-${RUN_KEY}" --package-root /tmp/accelerate-contract-v1-historical-restore --restore --atomic`

`RUN_KEY="$(python3 scripts/contract-v1-run-key.py --root . --packet .accelerate/workflow/active/accelerate-contract-v1-wave-5-entry.json --load)" && python3 scripts/validate-historical-runtime.py --manifest "planning/evidence/dated-proof-appendix/accelerate-contract-v1-prior-release-backup-${RUN_KEY}.json" --snapshot-root "planning/evidence/dated-proof-appendix/accelerate-contract-v1-prior-runtime-${RUN_KEY}" --package-root /tmp/accelerate-contract-v1-historical-restore --receipt "/tmp/accelerate-contract-v1-historical-restore-receipt-${RUN_KEY}.json" --check`

Expected: restored list/digests/modes and manifest identity equal the typed prior
release; no current-source mirror check runs; cleanup ownership remains with the
release tooling owner named in the manifest.

- [ ] Prove optional host deployment and rollback in disposable targets:

`RUN_KEY="$(python3 scripts/contract-v1-run-key.py --root . --packet .accelerate/workflow/active/accelerate-contract-v1-wave-5-entry.json --load)" && bash scripts/sync-skills-to-global.sh --source-root global-runtime/accelerate --package-root /tmp/accelerate-contract-v1-host --backup-root /tmp/accelerate-contract-v1-host-backup --receipt "/tmp/accelerate-contract-v1-host-deployment-receipt-${RUN_KEY}.json" --atomic`

`RUN_KEY="$(python3 scripts/contract-v1-run-key.py --root . --packet .accelerate/workflow/active/accelerate-contract-v1-wave-5-entry.json --load)" && bash scripts/sync-skills-to-global.sh --source-root /tmp/accelerate-contract-v1-host-backup --package-root /tmp/accelerate-contract-v1-host --backup-root /tmp/accelerate-contract-v1-host-rollback-backup --receipt "/tmp/accelerate-contract-v1-host-rollback-receipt-${RUN_KEY}.json" --atomic`

`python3 scripts/validate-runtime-package.py --package-root /tmp/accelerate-contract-v1-host --check`

Expected: host target returns to its exact prior bytes/modes; no repository or
project-local `.accelerate/` state is used as host rollback proof.
- [ ] Run the Green operational aggregate with explicit disposable workspace/source/history
and host targets. Expected: four ordered lane statuses, four distinct receipts,
the same loaded `run_key` in every record, and final marker
`contract v1 rollback lanes passed`.
- [ ] Run `bash tests/contract-v1-rollback-lanes.sh` and
`bash tests/contract-v1-rollback-lanes.sh --self-test`; require identical safe
results and unchanged non-temporary state.

- [ ] Commit later as the complete `ACV1-W5-006` task-scoped slice, including
the snapshotter, exporter, restorer, generated-package validator, all focused
tests including the safe rollback wrapper, operational aggregate,
source-demotion and historical validators, sync changes, immutable
snapshot evidence, generated eval/export manifest, and typed prior-release
backup manifest. Inspect
the staged list first; no commit is currently authorized.

### ACV1-W5-007: Enforce Drift, Cut Over Closure, And Integrate CI

**Depends on:** `ACV1-W5-006`

**Files:**
- Modify: `scripts/check-global-skill-mirror.sh`
- Modify: `tests/global-runtime-export-v1.sh`
- Modify: `tests/workflow-backend-neutrality.sh`
- Modify: `tests/ci-contract.sh`
- Create: `onboarding/local-workspace/close-evidence-transaction.sh`
- Modify: `onboarding/local-workspace/check-evidence-gate.sh`
- Modify: `onboarding/local-workspace/prepare-closure.sh`
- Modify: `onboarding/local-workspace/emit-v2.sh`
- Modify: `onboarding/local-workspace/validate-v2.sh`
- Modify: `onboarding/local-workspace/v2-materialization-contract.md`
- Modify: `tests/contract-v1-runtime-integration.sh`
- Create: `tests/contract-v1-closure-cutover.sh`
- Create: `tests/fixtures/contract-v1-closure-cutover/valid-logical-commit.json`
- Create: `tests/fixtures/contract-v1-closure-cutover/early-closed.json`
- Create: `tests/fixtures/contract-v1-closure-cutover/provider-readback-mismatch.json`
- Create: `tests/fixtures/contract-v1-closure-cutover/partial-publication.json`
- Create: `tests/fixtures/contract-v1-closure-cutover/predecessor-path-retained.json`

- [ ] **Red:** Mutate, delete, add, chmod, and authority-overclaim one generated file in isolated fixtures. Test stale source revision metadata separately from byte drift.
- [ ] **Red before consumer wiring:** At the actual
`prepare-closure.sh`/`close-evidence-transaction.sh` boundary, prove that an
early observable local `closed`, provider readback mismatch, partial publication
of terminal state/receipt/report/provider state, and continued availability of
the predecessor closure-success path all fail. Run
`bash tests/contract-v1-closure-cutover.sh`; expect non-zero because the new
consumer boundary is not wired yet.
- [ ] **Green:** Require explicit `--source-root` and `--package-root`; regenerate
the active source into `/tmp/accelerate-contract-v1-export-check`, validate it,
and compare `--source-root .` against
`--package-root global-runtime/accelerate`. Report stable categories `missing`, `extra`,
`content-drift`, `mode-drift`, `manifest-drift`, and `authority-overclaim`.
- [ ] Run adapter/readback, export/package, disposable historical restore, and
source-demotion ordering tests plus forensic `--catalog`/`--checklist` preflight.
Only after all pass, wire the Wave
3 prepared `closing` transaction as the authoritative local closure path.
Publish `closed`, final receipt/report, and provider-confirmed readback in one
logical commit; no observer may see closed local state first.
- [ ] Re-run `bash tests/contract-v1-closure-cutover.sh`; expect all four negative
fixtures to fail for their declared labels, the predecessor success path to be
unreachable, and the valid logical-commit fixture to pass.
- [ ] Add CI contract requirements for runtime integration, workflow readback,
backend neutrality, extension registry, adapter conformance, closure cutover,
migration, run-key integrity, snapshot, source demotion, rollback aggregation,
historical validation, export, runtime package, authority, and link integrity
tests. CI and `tests/all.sh` auto-discover only the safe no-arg
`tests/contract-v1-rollback-lanes.sh`; they never invoke the operational verifier
without the explicit V-079 targets.
- [ ] Run `bash scripts/check-global-skill-mirror.sh --source-root . --package-root global-runtime/accelerate`.

Expected: exit `0` and `global runtime export matches repository source`.

- [ ] Commit later as the complete `ACV1-W5-007` task-scoped cutover/CI slice;
include every closure adapter/test and drift/CI output listed above. No commit is
currently authorized.

### ACV1-W5-008: Publish Public V1 Catalogs And Runtime Inventory

**Depends on:** `ACV1-W5-003`, `ACV1-W5-004`, `ACV1-W5-005`, `ACV1-W5-007`

**Files:**
- Create: `docs/reference/accelerate-contract-v1.md`
- Create: `docs/reference/accelerate-contract-v1-vocabulary.md`
- Create: `docs/reference/accelerate-contract-v1-gates.md`
- Create: `docs/reference/accelerate-contract-v1-evidence.md`
- Create: `docs/reference/accelerate-contract-v1-runtime-catalog.md`
- Modify: `README.md`
- Modify: `core/control-plane/README.md`

- [ ] **Red:** Add documentation-snippet assertions for V1 version/status,
authority, vocabularies, lifecycle/closure, all five extension manifests,
supported contract versions, conformance status, Hermes interoperability limits,
adapter/provider capabilities, migration/deprecation, rollback, and examples.
- [ ] Run `bash tests/doc-snippet-integrity.sh`.

Expected: non-zero because the public V1 catalogs and navigation are absent.

- [ ] **Green:** Publish the five catalogs and minimal navigation. Match accepted
source exactly; inventory extensions, supported versions, conformance proof, and
Hermes gaps; state source/generated boundaries and optional provider status;
include no private path, secret, external dependency, or unsupported claim.
- [ ] Validate every example against the accepted Contract V1 validators.
- [ ] Run `bash tests/doc-snippet-integrity.sh`, `bash tests/markdown-link-integrity.sh`, and `bash tests/doctrine-integrity.sh`.

Expected: all three exit `0`; public terms and examples match accepted contract data.

- [ ] Commit checkpoint: `docs(contract-v1): publish public v1 catalogs`.

Rollback demotes V1 publication/status while retaining internal evidence and removes no navigation unless the complete prior navigation is restored.

### ACV1-W5-009: Run Final Forensic Validation And Close Contract V1

**Depends on:** `ACV1-W5-002`, `ACV1-W5-003`, `ACV1-W5-004`, `ACV1-W5-005`, `ACV1-W5-006`, `ACV1-W5-007`, `ACV1-W5-008`

**Files:**
- Create: `planning/evidence/dated-proof-appendix/accelerate-contract-v1-final-review-${RUN_KEY}.md`
- Modify: `planning/executive/accelerate-contract-v1-review-index.md`
- Modify: `planning/executive/accelerate-contract-v1-validation-checklist.md`
- Evidence: all Waves 0-5 packets and proof, read-only except final approval/closure fields

- [ ] Load and validate the persisted key before resolving final evidence paths:
`RUN_KEY="$(python3 scripts/contract-v1-run-key.py --root . --packet .accelerate/workflow/active/accelerate-contract-v1-wave-5-entry.json --load)"`. Do not generate or recompute it.
- [ ] Run `python3 -m py_compile scripts/normalize-workflow-readback.py scripts/export-global-runtime.py`.

Expected: exit `0` and no output.

- [ ] Run `bash tests/contract-v1-runtime-integration.sh`.

Expected: exit `0`; final line `contract v1 runtime integration tests passed`.

- [ ] Run `bash tests/workflow-readback-v1.sh` and `bash tests/workflow-backend-neutrality.sh`.

Expected: both exit `0`; local, GitHub, and Linear fixtures normalize without provider coupling.

- [ ] Run `bash tests/contract-v1-extension-registry.sh`,
`bash tests/contract-v1-adapter-conformance.sh`, and
`bash tests/contract-v1-migration.sh`, then
`bash tests/contract-v1-closure-cutover.sh`.

Expected: five exact extension paths register, all adapters declare version
bounds and pass conformance, migration remains dry-run-first/lossless/no-dual-
write, Hermes remains optional/non-authoritative, and cutover negatives fail for
their declared reason.

- [ ] Run `bash tests/global-runtime-snapshot-v1.sh`,
`bash tests/contract-v1-source-demotion.sh`,
`bash tests/contract-v1-run-key.sh`,
`bash tests/contract-v1-rollback-lanes.sh`,
`bash tests/global-runtime-export-v1.sh`,
`bash tests/runtime-package-validator.sh`, and
`bash scripts/check-global-skill-mirror.sh --source-root . --package-root global-runtime/accelerate`.

Expected: deterministic export, valid package, and zero drift.

- [ ] Run `bash tests/authority-set-gate.sh` and `bash tests/markdown-link-integrity.sh`.

Expected: repository authority and all repository-local links pass.

- [ ] Run `bash tests/all.sh` and `git diff --check`.

Expected: final line `all tests passed`; diff check has no output.

- [ ] In disposable repositories, capture typed proof for no-install, explicit install, local-only readback, GitHub issue/PR, Linear issue with PR gap, unavailable provider, stale readback, deterministic export, and injected drift detection.
- [ ] Run `python3 scripts/validate-accelerate-contract-v1-forensic.py --catalog planning/executive/accelerate-contract-v1-task-catalog.md`.
- [ ] Run `python3 scripts/validate-accelerate-contract-v1-forensic.py --checklist planning/executive/accelerate-contract-v1-validation-checklist.md`.
- [ ] After human approval fields and fresh proof are present, run
`python3 scripts/validate-accelerate-contract-v1-forensic.py --final`.

Expected: requested/promised/implemented reconciliation and all 45 catalog tasks report complete with per-wave capability coverage.

- [ ] Re-run all three exact rollback lanes: project-local installation-manifest
restore/readback; canonical source demotion followed by regenerated repository
export and normal parity; and optional host backup restore/readback. Also rerun
the separate manifest-bound historical-byte drill under `/tmp`. Verify distinct
workspace, source-demotion/export, historical-drill, and host receipts/status;
reject cross-lane proof.
- [ ] Run the aggregate proof for final rollback evidence; use the individual
commands below only to diagnose a failed lane.
- [ ] Have an independent forensic reviewer audit bounded commits/staged scope, rollback rehearsal, incident correction, source/runtime parity, user-home mutation, public catalogs, and every prior Wave Closure Packet; no critical/high/open blocker or unexplained residual may remain.
- [ ] Capture post-merge proof against the merge commit and run the Wave 3 cleanup/transactional closure path.

## Rollout

1. Ship read-only `--check` and schemas first; no project receives `.accelerate/` changes.
2. Enable explicit install/upgrade in disposable fixtures and dogfood repositories.
3. Register the five source-owned extensions and prove supported-version adapter
   conformance plus optional Hermes fixture interoperability.
4. Enable local adapter readback, then GitHub, then optional Linear; each requires fresh provider fixtures.
5. Snapshot and validate immutable prior `global-runtime/accelerate/` bytes,
   create the bound prior-release manifest, then generate/replace the repository
   export without user-home deployment. Keep that snapshot for disposable
   historical validation only; canonical source remains rollback authority.
6. Prove rollback restore and run closure-cutover tests red before wiring, then
   remove the predecessor success path and enable authoritative v1 closure.
7. Enable optional outward deployment only after export/package/drift checks.
8. Publish catalogs and run final forensics; selected provider availability is
   blocking only when declared runtime truth.

## Rollback

**Primary fail-fast proof**

Run the owned aggregate for closure proof. It loads and validates the stored key
internally, stops on the first failed lane, and writes `${RUN_KEY}`-namespaced
status/receipt files under the explicit receipt root:

`bash scripts/verify-contract-v1-rollback-lanes.sh --root . --entry-packet .accelerate/workflow/active/accelerate-contract-v1-wave-5-entry.json --project-root /tmp/accelerate-contract-v1-project --source-root /tmp/accelerate-contract-v1-source-rollback --historical-root /tmp/accelerate-contract-v1-historical-restore --host-target /tmp/accelerate-contract-v1-host --host-backup /tmp/accelerate-contract-v1-host-backup --receipt-root /tmp/accelerate-contract-v1-rollback-lanes`

The lane commands below remain diagnostic commands, not substitutes for the
aggregate closure proof.

**Project-local `.accelerate/` integration rollback**

Use only the installation manifest and predecessor backup produced for that
explicit project. Never use `restore-global-runtime.py` or repository export
evidence to claim workspace restoration.

`RUN_KEY="$(python3 scripts/contract-v1-run-key.py --root . --packet .accelerate/workflow/active/accelerate-contract-v1-wave-5-entry.json --load)" && bash onboarding/local-workspace/restore-contract-v1.sh --project-root /tmp/accelerate-contract-v1-project --installation-manifest /tmp/accelerate-contract-v1-project/.accelerate/status/contract-v1-installation.json --predecessor-version legacy-v2 --restore --readback`

`RUN_KEY="$(python3 scripts/contract-v1-run-key.py --root . --packet .accelerate/workflow/active/accelerate-contract-v1-wave-5-entry.json --load)" && bash tests/contract-v1-runtime-integration.sh --rollback-readback --project-root /tmp/accelerate-contract-v1-project`

Expected: manifest and backup digests validate, managed files restore atomically,
unrelated `.accelerate/` state is unchanged, and readback reports predecessor
version `legacy-v2` plus a distinct
`.accelerate/status/contract-v1-rollback-receipt.json`. Retain installation and
write-once backup evidence.

**Repository source/generated-export rollback**

The typed prior-release manifest identifies the accepted predecessor and exact
bounded canonical source, extension-registry, and adapter-selection set. Actual
rollback must demote those repository authorities first, then regenerate:

`RUN_KEY="$(python3 scripts/contract-v1-run-key.py --root . --packet .accelerate/workflow/active/accelerate-contract-v1-wave-5-entry.json --load)" && python3 scripts/demote-accelerate-contract-v1.py --manifest "planning/evidence/dated-proof-appendix/accelerate-contract-v1-prior-release-backup-${RUN_KEY}.json" --root . --apply --receipt "planning/evidence/dated-proof-appendix/accelerate-contract-v1-source-demotion-receipt-${RUN_KEY}.json"`

`RUN_KEY="$(python3 scripts/contract-v1-run-key.py --root . --packet .accelerate/workflow/active/accelerate-contract-v1-wave-5-entry.json --load)" && python3 scripts/export-global-runtime.py --source-root . --package-root global-runtime/accelerate --atomic && python3 scripts/validate-runtime-package.py --package-root global-runtime/accelerate --check && bash scripts/check-global-skill-mirror.sh --source-root . --package-root global-runtime/accelerate`

Expected: the demotion receipt names only manifest-listed bounded changes; the
regenerated export matches the now-active predecessor source. Normal parity is
for this regenerated package only.

Historical-byte restoration is a separate disposable drill and must never
target `global-runtime/accelerate/`:

`RUN_KEY="$(python3 scripts/contract-v1-run-key.py --root . --packet .accelerate/workflow/active/accelerate-contract-v1-wave-5-entry.json --load)" && python3 scripts/restore-global-runtime.py --manifest "planning/evidence/dated-proof-appendix/accelerate-contract-v1-prior-release-backup-${RUN_KEY}.json" --snapshot-root "planning/evidence/dated-proof-appendix/accelerate-contract-v1-prior-runtime-${RUN_KEY}" --package-root /tmp/accelerate-contract-v1-historical-restore --restore --atomic && python3 scripts/validate-historical-runtime.py --manifest "planning/evidence/dated-proof-appendix/accelerate-contract-v1-prior-release-backup-${RUN_KEY}.json" --snapshot-root "planning/evidence/dated-proof-appendix/accelerate-contract-v1-prior-runtime-${RUN_KEY}" --package-root /tmp/accelerate-contract-v1-historical-restore --receipt "/tmp/accelerate-contract-v1-historical-restore-receipt-${RUN_KEY}.json" --check`

Never run current-source mirror parity against historical bytes.

**Optional host-deployment rollback**

Only a host backup captured for the explicit managed target may restore it:

`RUN_KEY="$(python3 scripts/contract-v1-run-key.py --root . --packet .accelerate/workflow/active/accelerate-contract-v1-wave-5-entry.json --load)" && bash scripts/sync-skills-to-global.sh --source-root /tmp/accelerate-contract-v1-host-backup --package-root /tmp/accelerate-contract-v1-host --backup-root /tmp/accelerate-contract-v1-host-rollback-backup --receipt "/tmp/accelerate-contract-v1-host-rollback-receipt-${RUN_KEY}.json" --atomic`

`python3 scripts/validate-runtime-package.py --package-root /tmp/accelerate-contract-v1-host --check`

Expected: the disposable host target returns to its predeployment digest and
mode inventory. This proof says nothing about repository export or workspace
state.

If a provider reader regresses, mark only that capability blocked and fall back
only to an explicitly selected sibling. Linear removal disables its adapter and
selection record without core migration.

## Exit Gate And Acceptance

| ID | Acceptance capability | Required evidence |
| --- | --- | --- |
| `W5-C01` | Optional integration, install, and workspace restore | `--check` is read-only; install/upgrade and manifest-bound predecessor restore/readback are explicit, atomic, idempotent, and proven in disposable project roots. |
| `W5-C02` | Backend-neutral readback contract | Core issue/PR packets remain provider-neutral with explicit gaps. |
| `W5-C03` | Provider behavior and failure honesty | Local/GitHub/Linear success, unavailable, auth/API/rate-limit/malformed/stale paths are truthful. |
| `W5-C04` | Identity and capability selection | Selection uses identity, capability, status, freshness, and explicit ambiguity resolution. |
| `W5-C05` | Supported versions, migration, and adapter conformance | Every adapter declares bounds; dry-run-first legacy migration blocks lossy/dual-write conversion; common positive/negative fixtures pass. |
| `W5-C06` | Extension and Hermes interoperability | Five source-owned extension manifests register correctly; Hermes translates optionally and never becomes authority. |
| `W5-C07` | Anchored run identity, prior-byte snapshot, and deterministic export | The fixed lock protects O_EXCL intent -> exact fully sealed/fsynced packet -> O_EXCL final anchor; intent binds expected packet mode/bytes/digest, anchor fsync is the last durable initialization operation, completed recovery is read-only/idempotent, and every load validates all three records including packet mode. |
| `W5-C08` | Drift and generated-boundary enforcement | Missing/extra/content/mode/manifest/authority drift blocks; user home never supplies source. |
| `W5-C09` | Authoritative closure cutover | Red-first consumer tests reject early close, provider mismatch, partial publish, and predecessor-path retention. |
| `W5-C10` | Operational fail-fast rollback verifier | The owned operational script runs workspace, source-demotion/regenerated repository export, disposable historical validation, then optional host in order; it stops on first failure and preserves distinct keyed receipts/status, while the auto-discovered wrapper remains non-mutating. |
| `W5-C11` | Public catalogs | Published vocabulary, gates, evidence, extensions, adapters, migration, and examples match accepted source. |
| `W5-C12` | Final forensic closure | All 45 tasks, 12 Wave 5 capabilities, prior waves, approvals, post-merge proof, and logical terminal commit reconcile. |

- [ ] Generate the Wave Closure Packet from the frozen twelve-capability denominator.
- [ ] Exit only at `12/12`, all scenario/provider/extension/conformance/cutover
negative paths passing, no generated drift, no unclassified adapter gap, fresh
post-merge evidence present, rollback restore proven, public catalogs validated,
and final forensic transactional closure committed.
