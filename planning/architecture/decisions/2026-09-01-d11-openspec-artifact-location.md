# D11 — Governed OpenSpec artifact location and cleanup policy

- Status: `proposed-for-root-acceptance`
- Disposition ID: `D11-openspec-artifact-location-v1`
- Date: 2026-09-01
- Author: Codex delegated architecture owner (`/root/phase1_d11_artifact_location`)
- Governing proposal: `planning/architecture/2026-09-01-accelerate-portable-agent-fabric-openspec-design.md`
- Governing proposal SHA-256: `79473c41e77c626a0c849d0ff385be7c140e7f66cfbf047e55ba5ccfe05cd067`
- Decision scope: Phase 1 fixture-only adapter spike and the location rules that
  later adoption must retain. This is not implementation, installation,
  promotion, lifecycle mutation, or WebUI authorization.

## Context and authority

OpenSpec owns structured specification artifacts only. `planning/` is the
repository-native artifact layer; Accelerate root owns classification, gates,
evidence acceptance, and closure; `canonical_work_item_binding` owns the
lifecycle (Plane when Karval `policy_mode=required`). A directory must not
make a second writer or silently promote an OpenSpec checkbox, archive, or UI
view into lifecycle authority.

The existing local-workspace contract makes `.accelerate/` a schema-governed
project-local control surface and explicitly reserves `.tmp/` for temporary
captures, traces, logs, and scratch. It does not currently allow a
`.accelerate/specification/` directory. This decision therefore does not add
one by implication.

## Decision

`<project_root>/planning` is the explicit OpenSpec CLI project/store root.
Its upstream child is exactly `<project_root>/planning/openspec`, which is the
sole canonical repository-relative root for Accelerate-governed OpenSpec
artifacts. The Phase-1 fixture equivalent is exactly
`<isolated-test-root>/planning/openspec`. This is a planning sublayer, not a
new work tracker or a runtime store.

```text
planning/openspec/
├── README.md                         # future routing/read contract
├── changes/<change-id>/              # active, versioned spec artifacts
├── specs/<domain-or-capability>/     # accepted reusable specifications
├── bindings/<change-id>.json         # immutable binding metadata/projection
├── evidence/<change-id>/<digest>/    # durable, redacted structural evidence
└── archive/<YYYY>/<change-id>/<digest>/
                                      # immutable terminal artifact snapshot
```

The tree is a future allowlist, not a claim that any listed file or fixture
exists now. The Phase-1 spike may materialize only its explicitly approved
fixture subset in an isolated test root and may not create a live artifact
there without its later implementation gate.

### Exact ownership and locations

| Class | Canonical location | Writer and reader rule | Version control |
| --- | --- | --- | --- |
| OpenSpec change/spec/delta artifacts | `planning/openspec/changes/` and `planning/openspec/specs/` | The selected OpenSpec adapter is the only artifact writer; root/reviewers/WebUI read. | Tracked, no secrets. |
| Canonical-binding metadata | `planning/openspec/bindings/` | Adapter writes an immutable projection containing locator, revision, digest and URL where available. It is never a lifecycle peer or writable Plane substitute. | Tracked. |
| Structural validation/archive evidence | `planning/openspec/evidence/` and `planning/openspec/archive/` | Producer appends candidate-bound redacted evidence; verifier acceptance is separate. Archive creation requires the governed archive operation. | Tracked. |
| Adapter source, schemas and deterministic helpers | `adapters/specification/openspec/` and `schemas/accelerate-governed/` | Repository source is authoritative; it locates and validates artifacts but does not make them lifecycle truth. | Tracked. |
| Test fixtures | `tests/fixtures/openspec/` (positive and `invalid/` negative cases) | Test-only inputs/expected readbacks; never an operational project root. | Tracked. |
| Test receipt fixtures that are shared with the proposal's target layout | `fixtures/openspec/` only if Phase implementation establishes that root and its validator reader | Must be byte-stable and named by contract version. No duplicate copy in `tests/fixtures/openspec/`; one path is selected by the implementing ADR. | Tracked. |
| Local workspace status/projection | Existing allowed `.accelerate/` fields only, by pointer/digest to `planning/openspec/` | Read-only derived local status; no OpenSpec source, change, archive, cache, lock, or evidence payload lives here. A new directory needs a local-workspace contract and allowlist change first. | Existing explicit allowlist/ignore policy. |
| Disposable tool state | `<isolated-test-root>/.tmp/openspec/` | Test/adapter process only; never a canonical reader. A redirected local-store registry may point here only for the active fixture run. | Ignored and removed by owner. |
| Long-lived operational state, leases, locks, caches, logs, sockets, clones, downloaded packages | D01-owned `.accelerate/gauntlet/` only if D01 is accepted and its allowlist/contract is implemented | D01 owns mutable CAS state; it does not own or duplicate OpenSpec canonical bytes. Before D01 acceptance, Phase 1 has no durable operational-state authorization. | D01-controlled class; ignored/generated unless D01 explicitly makes a named, non-secret control file tracked. |

No symlink, copy, mirror, staging tree, or alternate OpenSpec store may duplicate
canonical artifact bytes. A redirected local-store registry is a disposable,
run-scoped pointer to the already-selected canonical root or fixture root; it
is never a reader/writer authority, retention surface, fallback root, or an
artifact source. It must be removed with its fixture receipt.

`planning/evidence/dated-proof-appendix/` remains the location for a durable
run-level receipt that covers multiple artifacts or a decision, while
`planning/openspec/evidence/` is only artifact-bound structural evidence. The
same bytes must not be maintained in both; the former references the latter by
locator and digest when both are needed.

## Rejected alternatives

| Option | Disposition | Reason |
| --- | --- | --- |
| Root `openspec/` | Rejected as canonical | It follows upstream convention but competes with this repository's native `planning/` artifact router and makes an unqualified root a tempting tool/UI discovery authority. It may not be created as a compatibility duplicate. |
| `planning/openspec/` | Selected | It keeps specifications beside other planning artifacts, preserves one planning owner, makes review and retention visible, and does not change lifecycle authority. |
| `.accelerate/openspec/` or `.accelerate/specification/openspec/` | Rejected as canonical | `.accelerate/` is local project control state, has a finite directory allowlist, and its ignored/generated surfaces are unsuitable for source artifacts or permanent evidence. It may carry only an allowed, digest-bound read-only pointer. |
| External workspace, user-home, XDG directory, tool default, or WebUI registry | Rejected as canonical | These are machine-local, weakly reviewable, may expose other projects, and defeat repository retention/rollback. They may be disposable staging only under the discovery and cleanup rules below. |

## Discovery, containment, and WebUI boundary

1. An adapter receives an explicit `project_root`; it MUST NOT infer a root
   from the current directory, a parent walk, a WebUI registration, `$HOME`,
   XDG state, or an upstream default.
2. Before any filesystem operation, it canonicalizes the explicitly configured
   `project_root` using descriptor-based, no-follow traversal where the
   platform supports it, verifies it against the deployment/project-root
   allowlist, and opens `<project_root>/planning` as the OpenSpec CLI
   project/store root. Its only canonical upstream child is
   `<project_root>/planning/openspec`; a CLI parent walk, current-directory
   inference, alternate `--store`/`--project` root, or redirected registry
   cannot substitute for it. `change-id` and child path components are
   closed-schema identifiers, never untrusted path fragments.
3. It rejects absolute paths, `..`, encoded traversal, empty components,
   alternate separators, a missing root, any symlink in the governed ancestor
   chain, and a resolved path outside the allowlisted root. It opens children
   relative to the verified directory descriptor with no-follow semantics and
   rechecks device/inode ancestry immediately before read, write, rename, and
   archive commit. A mismatch is `REJECTED`/`UNKNOWN`, leaves no advance, and
   creates a cleanup/recovery receipt; it never retries against a replacement
   path.
4. The phase-specific adapter must use atomic create/rename within the same
   verified filesystem and record pre/post digest plus source descriptor
   identity. A cross-device move, link swap, descriptor race, copy/mirror
   attempt, or ambiguous result is a failed transaction: quarantine only the
   adapter-owned disposable scratch path, preserve evidence, and block advance.
5. OpenSpec WebUI, if ever deployed, receives only explicit allowlisted project
   roots and is read/observe-only through the enforcing proxy/backend policy.
   It reads `planning/openspec/`; it cannot register arbitrary roots, browse
   `.accelerate/`, write artifacts, mutate bindings, or treat its view as
   approval. Until the later WebUI gates are accepted, no WebUI process or
   reader is authorized.

## Immutability, archive, retention, rollback, and cleanup

Active change artifacts are revisioned and may only change through a
candidate-bound successor operation. Superseded active revisions remain
readable through their recorded lineage until the governed archive transaction
commits. Archive is a copy/verify/finalize operation into
`planning/openspec/archive/<YYYY>/<change-id>/<content-digest>/`; it must
include manifest, source revision, binding projection, validation result,
evidence locators/digests, archive timestamp, and retention owner. Archive
content is immutable: no in-place edit, deletion, rebinding, or automatic
closure. A correction creates a successor outside the archived snapshot.

The future archive receipt sets `retain_until` and a named retention owner;
until D01 selects durable-store/backup policy, the minimum is repository
history plus a candidate-bound rollback receipt. If D01 and D11 are accepted
together, D01 owns mutable `.accelerate/gauntlet/` CAS state and D11 owns
tracked OpenSpec artifacts under `planning/openspec/`; neither may store
duplicate canonical bytes, fall back to the other's root, or promote its
projection to the other's authority. Rollback restores only a verified prior
active artifact from its archive or predecessor, verifies digest/binding/readback,
and creates a successor. It never overwrites an archive, mutates D01 CAS state,
or rolls back Plane/canonical lifecycle state. Readers must resolve an artifact
by explicit locator plus digest; they must reject an archive that is incomplete,
altered, outside the root, or mismatched to the current binding.

Every fixture or later adapter operation owns its scratch path, process, lock,
and generated output. Normal cleanup removes only paths created under its
unique `<isolated-test-root>/.tmp/openspec/<run-id>/` after receipt capture.
The cleanup receipt records root realpath, run id, owner, created-path
allowlist, pre/post inventory digest, process/socket status, retained evidence
locators, action (`removed|quarantined|none`), and residue reason. It must not
delete a pre-existing path or any unverified symlink target.

On crash, timeout, interrupted cleanup, ambiguous outcome, or retained
diagnostic material, the next run discovers only its own run-id directory,
revalidates containment, marks the run `UNKNOWN`, preserves it by atomic
quarantine inside that same isolated root, and emits a crash-residue receipt.
It may clean only after ownership and inventory match. Unknown or foreign
residue is never removed automatically and blocks the affected fixture/lane
until an operator disposition. No crash residue is a canonical artifact,
evidence acceptance, or archive input.

## Required fixture intent for later implementation

No fixture is claimed to exist. Before Phase 1 exit, the implementing owner
must add positive fixtures proving: exact store-root mapping from
`<project_root>/planning` to its sole `<project_root>/planning/openspec` child;
creation and validation in the exact disposable equivalent
`<isolated-test-root>/planning/openspec`; tracked canonical artifact selection;
archive immutability/readback; digest-bound local projection; and normal
cleanup with no process or scratch residue.

Negative fixtures must prove denial, no outside-root open/write, no lifecycle
advance, and an appropriate receipt for: omitted/not-allowlisted root;
parent-walk/current-directory inference; an alternate CLI project/store root
or redirected registry; root `openspec/` presented as canonical;
`.accelerate/` or external/user-home artifact presented as canonical; a
symlink/copy/mirror/staging duplicate; absolute/`..`/encoded traversal;
symlinked ancestor or child; descriptor-swap TOCTOU; cross-device archive;
stale or changed binding digest; incomplete/tampered archive; attempted
in-place archive edit/delete; duplicate evidence payload; cleanup of
foreign/pre-existing path; crash residue with unknown ownership; and WebUI
project/root/method/write attempts. The positive and negative fixtures must
remain separate from any real project root and contain no credentials, provider
responses, or live Plane mutation.

## Acceptance conditions and residuals

This disposition satisfies the *policy* part of D11 only after root acceptance
and a later implementation supplies a location/cleanup receipt demonstrating
the declared containment, archive/readback, positive/negative fixtures, and
cleanup outcomes. It does not satisfy D01 retention/backup selection, D02
binding backend behavior, D05/D09 WebUI authorization, or any Phase exit on
its own.

Cross-decision binding: D11 resolves the CLI/store root and upstream child
layout now: the CLI operates from `<project_root>/planning` and its only
artifact child is `openspec/`, with the exact fixture equivalent stated above.
D08 retains authority solely over immutable release provenance and the precise
safe invocation details. D08 may not introduce compatibility staging, copying,
mirroring, symlinking, an alternate store root, or a different artifact
location; any such change needs a successor D11 disposition.

## Recommendation

Accept `D11-openspec-artifact-location-v1` as the Phase-1/2 location policy,
then keep Phase 1 limited to fixture-only isolated roots until its adapter,
schema, containment tests, archive/rollback and cleanup receipts are reviewed.
