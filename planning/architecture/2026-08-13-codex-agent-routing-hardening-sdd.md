# Codex Agent Routing Hardening SDD

## Status

- ID: `SDD-CODEX-AGENT-ROUTING-001`
- Status: `accepted`
- Mode: `standard`
- State: `generation 11 closed / Plane FINISH readback observed`
- Owner: `codex3-specification-lane`
- Author: `codex3_sdd_red`
- Accepted by: `accelerate-root`
- Acceptance basis: the root froze the seven-item denominator and exact order in
  the bounded CODEX-3 assignment before this artifact was written.
- Date: 2026-08-13
- Governing issue: `CODEX-3`
- Related ADR: `2026-08-13-codex-agent-routing-hardening-adr.md`
- Related Test Design:
  `../testing/2026-08-13-codex-agent-routing-hardening-test-design.md`
- Related TDD receipt:
  `../testing/2026-08-13-codex-agent-routing-hardening-tdd-receipt.md`
- Related traceability:
  `../specification/2026-08-13-codex-agent-routing-hardening-traceability.md`
- Related task breakdown:
  `../execution/2026-08-13-codex-agent-routing-hardening-task-breakdown.md`
- Engineering Artifact Manifest:
  `../specification/2026-08-13-codex-agent-routing-hardening-manifest.json`
- Independent review and root forensic receipt:
  `../evidence/dated-proof-appendix/codex-agent-routing-hardening-independent-review-2026-08-13.md`

## Classification

This is a multi-file workflow/governance correction with durable runtime
routing decisions and two new specialist routes. The deterministic minimum is
`standard`: it changes no product UI, provider state, authorization boundary,
credential, irreversible migration, or independently deployable runtime.
Discovery of any such trigger reopens this SDD at the higher required mode.

## Problem And Observed Baseline

The current control plane is structurally strong but internally inconsistent:

1. the visible `skill-catalog-router` points at a frozen historical catalog
   outside the repository authority;
2. Spawn Packets list skill IDs without the exact file path or content hash the
   child must load;
3. raw catalog profiles duplicate the logical specialist profiles and inherit
   implicit model/effort defaults;
4. `data-db` and `integrations-ops` exist only as catalog groups, not callable
   logical agents;
5. capability matrix, ontology, pool, selection policy, compatibility map, and
   skill envelopes do not describe the same family set;
6. read-only reviewer templates use `draft`, `edit`, or `write` language without
   an operational artifact-delivery boundary;
7. `spawn_packet_limit` is validated as a literal but is not consumed by the
   renderer.

The pre-change command `bash tests/codex-agent-routing-hardening.sh` observed all
seven stable cases RED at 2026-08-13T09:03:01-04:00. That generation 0 baseline
remains historical evidence. The complete receipt is
`planning/evidence/dated-proof-appendix/codex-agent-routing-hardening-red-2026-08-13.md`.

## Current Reentry State

Generation 1 implemented the seven original cases and observed a narrow local
GREEN. Independent review then invalidated that proof as current acceptance
evidence because the oracle missed five defects. Generation 2 corrected those
defects, observed focused and full-suite GREEN, installed the repo-owned runtime
through a schema-4 transactional receipt, and proved all eight contexts in fresh
Codex processes. A second independent review of that frozen generation 2
snapshot then rejected closure after finding two additional P1 recovery and
ownership defects. Generation 3 corrected both findings in order, observed
same-generation focused, affected, full-suite, mirror and fresh-process runtime
proof, and installed the corrected repo source through a new schema-4 receipt.
Final independent review rejected generation 3 closure with three further
ownership, permission and cooperative-concurrency defects. Correction generation
4 corrected all three findings in order and observed same-generation focused,
full-suite, sync/mirror and fresh-runtime proof. Independent review nevertheless
failed generation 4 closure with three further lock-ownership, validation-order
and ownership-receipt defects. Correction generation 5 then observed honest
RED/GREEN, focused/full proof, transactional sync/mirror and fresh runtime proof.
Final independent review nevertheless failed
generation 5 closure on a third-OFD ownership oracle defect. Correction
generation 6 corrected the oracle and observed same-generation lock/affected,
full-suite, sync/mirror and fresh-runtime proof. Final independent review then
failed generation 6 closure on `G7-F1`: a supported standalone logical reinstall
after sync rewrites only the logical ownership receipt, changes its
`installed_digest`, and invalidates the schema-4 rollback. Correction generation
7 corrected the finding and observed same-generation affected/full-suite,
sync/mirror and fresh-runtime proof. Final independent review then failed
generation 7 closure with two transactional gaps: `G8-F1` P2 permits the logical
fast path outside CODEX_HOME rollback/backup history, and `G8-F2` can partially
mutate profiles before a receipt replacement fails. Correction generation 8
fixed both and was reproved, but final review then failed closure on `G9-F1`:
within CODEX_HOME/backups, the logical fast path accepts a receipt-updated
renamed backup and mode `0666`, unlike catalog exact-identity validation.
Correction generation 9 was reproved, but independent review failed closure on
three catalog transactional/identity findings. Correction generation 10 was
reproved and later accepted as the implementation generation; generation 9
proof/runtime are stale history. Generation 11 then reconciled documentary
truth and recovered external runtime drift before final review and Plane closure.

| Finding | Severity | Observed RED condition | Generation 2 disposition |
| --- | --- | --- | --- |
| `G2-F1` | P1 | managed catalog/index divergence broke the `research` Spawn Packet | corrected and reproved: 112 managed routes equal 112 indexed routes; all seven specialist packets render |
| `G2-F2` | P1 | standalone catalog reinstall deleted logical-owned `data-db` and `integrations-ops` profiles | corrected and reproved by catalog-after-logical reinstall and idempotency test |
| `G2-F3` | P1 | `build_index.py --write` followed an escaping `index.tsv` symlink | corrected and reproved with destination/parent symlink and atomic-replace fixtures |
| `G2-F4` | P1 | a rollback receipt depended on future/current topology and failed after drift | corrected and reproved with schema-4 generation snapshots and rollback-after-drift fixture |
| `G2-F5` | P2 | `rollback_command` was not validated exactly | corrected and reproved with exact-argv validation and tampering rejection |

The generation 2 runtime installation is preserved as historical evidence.
Generation 3 was transactionally synced through a schema-4 receipt containing
112 packages and 16 runtime files, mirror parity passed, and a fresh Codex
runtime proof passed. At that historical checkpoint the final clean runtime
rerun was still pending; later generations superseded it, and generation 11
mirror, fresh-runtime, review and Plane closure proofs are now authoritative.

| Finding | Severity | Independent-review RED condition | Generation 3 disposition |
| --- | --- | --- | --- |
| `G3-F1` | P1 | rollback can overwrite or delete a target that changed before its recorded preflight | corrected and reproved: receipt targets are preflighted against the installed generation and rollback aborts before mutation on pre-existing drift |
| `G3-F2` | P1 | catalog evolution can leave a stale profile with logical-agent ownership that a later catalog reinstall would retire | corrected and reproved: catalog reconciliation preserves existing logical-agent-owned profiles across catalog evolution; retirement belongs to the logical-agent owner or an explicit migration |

The prior documentary contradiction between `pre-code`, current RED-only
traceability, and a generation 1 GREEN receipt was corrected by generation 2.
Generation 1 and generation 2 receipts remain preserved as stale history; the
generation 3 receipt is preserved as stale history after final review.

| Finding | Severity | Final generation 3 review failure | Generation 4 disposition |
| --- | --- | --- | --- |
| `G4-F1` | P1 | logical ownership laundering: shape plus mtime accepted backdated, tampered `data-db` content and preserved/relabelled it as logical-owned | corrected and reproved with a digest-bound logical ownership receipt |
| `G4-F2` | P2 | installed runtime configs may retain mode `0664` instead of `0600` | corrected and reproved with exact `0600` on base and seven logical profiles and `0700` on backup directories |
| `G4-F3` | P2 | cooperative TOCTOU remains between preflight/classification and mutation | corrected and reproved with one shared cooperative single-writer lock across governed mutators |

| Finding | Severity | Final generation 6 review failure | Generation 7 required correction |
| --- | --- | --- | --- |
| `G7-F1` | P1 | sync followed by a supported standalone logical reinstall rewrites only the logical receipt, changes its `installed_digest`, and makes the schema-4 rollback invalid | corrected and reproved: canonical configs, modes, ownership, and hashes take a byte-idempotent fast path that preserves rollback validity, while real changes still update the affected config and receipt |

| Order | Finding | Severity | Final generation 7 review failure | Generation 8 required correction |
| --- | --- | --- | --- | --- |
| 1 | `G8-F1` | P2 | logical fast path accepts state outside CODEX_HOME rollback/backup history | corrected and reproved: fast path is contained to state covered by CODEX_HOME rollback/backup history |
| 2 | `G8-F2` | P1 | a receipt path that is a directory plus real drift permits partial profile mutation before final receipt replace fails | corrected and reproved after `G8-F1`: receipt destination is preflighted before mutation and publication remains late/transactional |

| Finding | Severity | Final generation 8 review failure | Generation 9 required correction |
| --- | --- | --- | --- |
| `G9-F1` | P2 | within CODEX_HOME/backups, a renamed backup path reflected in the logical receipt plus mode `0666` is accepted by the logical fast path, unlike catalog exact-identity validation | corrected and reproved: target-bound exact backup identity plus mode `0600` across validators; rename/swap/suffix/hardlink/symlink/missing/outside adversarial matrix passes |

| Order | Finding | Severity | Final generation 9 review failure | Generation 10 required correction |
| --- | --- | --- | --- | --- |
| 1 | `G10-F1` | P1 | catalog receipt late-publication failure leaves temp plus backup artifacts and restores the target with mode drift | corrected and GREEN: transactional rollback/cleanup restores exact prior target and removes artifacts |
| 2 | `G10-F2` | P2 | catalog no-op accepts a hardlinked receipt with `nlink=2` | corrected and GREEN: regular, non-symlink, `nlink=1`, correct owner and mode `0600` |
| 3 | `G10-F3` | P2 | catalog accepts a logical receipt whose declared `rollback_directory` differs from the actual backup parent, while logical rejects it | corrected and GREEN: one declared rollback-directory identity across validators |

| Finding | Severity | Generation 11 contract-review condition | Disposition |
| --- | --- | --- | --- |
| `G11-F1` | P2 | governing dashboard, traceability and ledger were stale or contradictory after G10 | documentary correction/proof `11/11`; static JSON/YAML/link/whitespace proof passed |
| `G11-F2` | P1 closure blocker | external post-G10-sync drift changed `~/.codex/config.toml` to `model_reasoning_effort=low` while topology requires `medium`; mirror root plus seven failed | recovered by governed G11 resync; root model Sol/effort `medium`, mirror and fresh root plus seven pass |

The generation 4 runtime remains installed, but its runtime proof is not closure
evidence for generation 5.

| Order | Finding | Severity | Final generation 4 review failure | Generation 5 disposition |
| --- | --- | --- | --- | --- |
| 1 | `G5-F1` | P1 | an inherited file descriptor points to the exact lock inode but does not prove the process holds `flock` ownership | corrected and reproved by proving held lock ownership |
| 2 | `G5-F2` | P1 | rollback performs material receipt validation before acquiring the shared lock | corrected and reproved by acquiring before decisive validation and holding through mutation |
| 3 | `G5-F3` | P2 | combined sync leaves standalone ownership receipts stale or absent: logical receipt schema 1/mode `0664`, catalog receipt absent, while runtime configs and sync receipt are `0600` | corrected and reproved with transactional catalog/logical schema-2 mode-0600 ownership receipts and rollback |

The generation 5 runtime remains installed as historical runtime evidence, not
as generation 6 closure evidence.

| Finding | Severity | Final generation 5 review failure | Generation 6 disposition |
| --- | --- | --- | --- |
| `G6-F1` | P1 | third-OFD contention was mistaken for inherited-FD ownership: all four mutators accepted unlocked inherited OFD-B while legitimate OFD-A held the lock | corrected and reproved with direct nonblocking `flock` on inherited FD across all four mutators and exact three-state fixtures |

## Authority Set

Governing authorities:

- `AGENTS.md` and the root `SKILL.md`;
- `adapters/runtime/codex/skill-catalog-manifest.toml`;
- `adapters/runtime/codex/logical-agent-topology.toml`;
- `adapters/runtime/codex-collaboration/role-policy.json`;
- `agents/base-agent-contract.md` and `agents/doctrine/`;
- the governed Plane readback for `CODEX-3`.

Supporting evidence:

- current repository validators and tests;
- current global runtime files only as deployment/readback evidence;
- the dated RED receipt linked above.

Forbidden authorities:

- `/home/marcelo-karval/.codex/skill-catalog-h55-20260730`;
- `~/.codex/skills` as an authoring source;
- generated profile files as source truth;
- a specialist's private transcript or self-acceptance;
- static configuration as proof of native spawn injection or isolation.

## Desired Operating Model

```text
repo-owned manifest + repo-owned skill packages
  -> current deterministic router index
  -> compact root discovery
  -> logical agent selection
  -> Spawn Packet(skill, absolute runtime path, SHA256)
  -> child loads exactly those files
  -> bounded return packet
  -> root integration, review-of-review, runtime sync/readback, closure
```

The catalog group remains the skill bundle definition. A logical agent is the
only launchable specialist identity for groups that have a logical binding.
`on-demand` and `superpowers-on-demand` remain explicit recovery profiles, not
specialist aliases.

## Frozen Correction Denominator And Requirements

The implementation order is normative. `T1` through `T7` are the complete
correction denominator; setup, proof, runtime sync, and closure gates do not add
hidden correction items.

### `REQ-ROUTER-001` / `T1`

Import `skill-catalog-router` into
`skills/governance/skill-catalog-router/`, register it as repo-owned, and build
its compact index from every current governed `managed-global` source. Manifest
and index identifiers must have exact parity. Its check mode must fail on a
missing, stale, duplicate, path-escaping, or hash-mismatched entry. Its writer
must reject a symlink destination or symlinked parent, create a sibling regular
temporary file, and replace the index atomically. Neither the skill nor its
one-hop resources may name the historical `h55` catalog.

### `REQ-SPAWN-002` / `T2`

Every assignment skill in a rendered Spawn Packet must have exactly one stable
record with this machine-readable shape:

```text
skill=<identifier>; path=<absolute-existing-SKILL.md>; sha256=<64-lowercase-hex>;
```

The set must equal `logical_agent.required_skills ∪ profile.skill_allowlist`.
The digest is SHA-256 over the exact bytes at `path`; missing, unreadable,
duplicate, symlink-escaping, or mismatched routes fail closed before output.
The contract must render successfully for every logical specialist, including
`research`; proving only one representative agent is insufficient.

### `REQ-ALIASES-003` / `T3`

Catalog rendering and installation must expose only `on-demand` and
`superpowers-on-demand`. Raw profiles for `django-backend`,
`next-react-frontend`, `catalog-librarian`, `governance-review`,
`product-browser-qa`, `data-db`, and `integrations-ops` must not be materialized
by the catalog installer. A transactional install removes stale generated raw
aliases while preserving their recoverable backup; the logical-agent installer
may then materialize the logical identities. A standalone catalog reinstall
must preserve profiles owned by the logical topology and every existing target
whose content digest is bound to a valid logical-agent ownership receipt across
catalog evolution. Shape, provenance text and mtime are insufficient ownership
evidence. Retirement belongs to the logical-agent owner or an explicit
migration. Catalog reinstall remains idempotent after logical-agent installation.

### `REQ-ROUTES-004` / `T4`

Add bounded logical agents named `data-db` and `integrations-ops`:

| Agent | Role family | Catalog group | Profile | Model / effort | Write boundary |
| --- | --- | --- | --- | --- | --- |
| `data-db` | `data` | `data-db` | `implementation` | Terra / medium | bounded write; no external write or closure |
| `integrations-ops` | `integrations-ops` | `integrations-ops` | `implementation` | Terra / medium | bounded write; no external write or closure |

Each has a non-empty minimal required-skill subset of its group and an explicit
role-policy binding. Logical configuration is routing metadata, not a claim of
process, MCP, credential, tool, or filesystem isolation.

### `REQ-DOCTRINE-005` / `T5`

Reconcile the capability matrix, ontology, pool, selection policy,
role-family compatibility map, and skill envelopes around one explicit family
set that includes:

- `specification-engineer`;
- `code-quality-reviewer`;
- `test-engineer`;
- `web-performance-auditor`;
- `data-database-specialist`;
- `integrations-ops-specialist`.

The two new normalized role families must map to their concrete specialists.
Candidate/promotion language must match across all doctrine surfaces.

### `REQ-READONLY-006` / `T6`

`specification-review`, `test-strategy`, and `governance-audit` remain
read-only profiles. Their templates must state all three rules explicitly:

- workspace mutation is forbidden in the read-only profile;
- proposed artifact or patch content is delivered only in the return packet;
- persistence requires a separate bounded executor assignment.

`Draft`, `edit`, or `write` may describe returned content or the separate
executor only; it may not imply mutation by the reviewer.

### `REQ-LIMIT-007` / `T7`

Retain and enforce `spawn_packet_limit` as a positive configurable line limit.
Both validator and renderer consume the value. The renderer must either emit a
complete packet at or below the limit or fail closed; it must never truncate a
skill route, hash, authority boundary, proof obligation, or return contract.

## Invariants

- root remains the only issue topology, external-write, integration,
  review-of-review, and closure authority;
- no implementation step writes to `~/.codex`; runtime sync happens only after
  repo tests and independent review;
- no raw alias selects a specialist with implicit model or effort;
- exact paths and hashes are evidence of loaded bytes, not host enforcement;
- catalog and logical-agent installers remain transactional and idempotent;
- one failed correction stops later deployment but does not erase prior RED or
  test evidence.

## Rollout And Rollback

Rollout follows `T1 -> T2 -> T3 -> T4 -> T5 -> T6 -> T7`, with the focused test
rerun after each affected slice. After full repo GREEN, the root performs one
transactional repo-to-global sync, verifies source/mirror parity, starts a fresh
writable Codex process, proves root plus all logical profiles, and records
readback. Restart/runtime proof cannot be inferred from local tests.

Rollback uses the installers' bounded backup receipts. Each receipt must capture
its exact package/profile denominator and source generation so later source or
topology drift cannot invalidate the rollback. The recorded `rollback_command`
must equal the governed rollback script plus the exact receipt path. Restore
only files replaced by the CODEX-3 sync. Before changing any target, rollback
must verify that its current state still equals the installed state captured in
the receipt, including the expected absence of a target created by the sync. A
pre-existing post-sync change detected by that preflight aborts the whole
rollback before mutation instead of being overwritten or deleted. A shared
cooperative single-writer lock must also close the classify/preflight-to-mutate
window across installers, sync and rollback. After a successful rollback,
revalidate the previous
global catalog and keep the issue open with the failed generation recorded. No
broad user-home reset is authorized.

## Artifact Dispositions

| Surface | Disposition | Reason / locator |
| --- | --- | --- |
| ADR | separate | Durable decisions about routing authority, aliases, read-only delivery, and packet-limit semantics live in the related ADR. |
| Product/UI DESIGN | not applicable | No product UI, interaction, or visual hierarchy changes. |
| Test Design | separate | Seven independently named semantic cases have distinct failure oracles. |
| Agent contract/staffing | consolidated | This SDD defines the two logical agents and doctrine reconciliation; root owns staffing. |
| Rollout | consolidated | Ordered local proof, transactional sync, fresh process, and readback are specified above. |
| Rollback | consolidated | Bounded installer receipts and no broad reset are specified above. |
| Observability | consolidated | Named cases, exact commands, hashes, correction/proof generations, and runtime readback expose state. |
| Governing AGENTS/docs | required | Existing agent doctrine and runtime adapter docs must be updated consistently; bootstrap authority is preserved. |

## Readiness And Reentry

The design remains accepted. Documentary and runtime correction/proof generation
is `11/11`, and current GREEN is true; independent reviews and root forensic passed.
The generation 0 RED, generation 1 narrow GREEN, and generation 2 focused/full,
sync, and fresh-process proof remain preserved history. `G3-F1` and `G3-F2`
have honest generation 3 RED/GREEN history; focused `7/7`, affected suites, the
final full repository rerun, transactional generation 3 sync, mirror parity and
fresh runtime proof were observed. Final review nevertheless failed closure on
`G4-F1` through `G4-F3`. Generation 4 honest RED/GREEN, focused/final full-suite,
transactional sync, mirror parity and fresh runtime proof remain stale history
after final review failed closure on `G5-F1` through `G5-F3`. Generation 5 has
honest RED/GREEN, focused and final full-suite PASS, transactional sync/mirror,
schema-2 mode-0600 ownership receipts, and fresh root plus seven-specialist
runtime proof. Independent review, root review-of-review, forensic closure and
governed Plane evidence/readback were pending when final review failed closure
on `G6-F1`. Generation 5 is now stale history. Generation 6 has honest RED/GREEN,
lock/affected and full-suite PASS, transactional sync/mirror, schema-2 receipts
and fresh root plus seven-specialist runtime proof, but final independent review
failed closure on `G7-F1`. Generations 1 through 6 are stale history. Generation
7 corrected the standalone logical install path so a canonical reinstall is
byte-idempotent across configs and the ownership receipt, preserves schema-4
rollback validity, and still updates both config and receipt for real changes.
Affected/full-suite proof, transactional resync/mirror and fresh root plus seven-
specialist runtime proof passed, but final review failed closure on `G8-F1` and
`G8-F2`. Generations 1 through 7 are stale history. Generation 8 first contained
the logical fast path to CODEX_HOME rollback/backup history, then preflighted
the receipt destination before any profile mutation and retained late
transactional publication. Focused/affected/full proof, transactional resync/
mirror and fresh root plus seven-specialist runtime proof passed. Independent
review confirmed the G8 fixes but failed closure on `G9-F1`. Generations 1
through 8 are stale history. Generation 9 aligned logical and catalog validators
on target-bound exact backup identity and mode `0600`; the rename/swap/suffix/
hardlink/symlink/missing/outside matrix passed. Focused, catalog, quality,
lifecycle, full-suite, transactional sync/mirror and fresh root plus seven-
specialist runtime proof passed. Concurrent `playwright-patterns` source/runtime
content was preserved byte-exact and the 112-route index regenerated.
Independent review then failed generation 9 closure on `G10-F1` through
`G10-F3`. Generations 1 through 9 are stale history. Generation 10 must correct
them in exact order: transactional rollback/cleanup, exact receipt identity,
then unique rollback-directory identity. Three separate REDs and GREEN were
observed, followed by focused/affected/full, sync/mirror and fresh root plus
seven-specialist runtime proof. G11 corrected stale governing documents and
passed static proof, but an independent runtime reviewer observed external
post-sync drift: root config effort `low` conflicts with topology `medium`, and
mirror root plus seven fails. G10 implementation proof remains accepted; its
runtime receipt is historical/stale. Governed G11 resync restored root Sol/
`medium`; mirror and fresh root plus seven passed. Two independent reviewers
returned `ACCEPTED` with zero P0-P3 findings; root review-of-review and forensic
closure passed. Plane REVIEW, Done, FINISH and final provider readback passed.
The lock
coordinates governed cooperative mutators only; non-cooperating same-user
filesystem writes and cryptographic authenticity remain outside the guarantee,
and no universal linearizability is claimed. Reopen this SDD again if a route
source, role family, launchable profile, packet record, limit strategy, write
boundary, global sync behavior, or proof obligation changes.
