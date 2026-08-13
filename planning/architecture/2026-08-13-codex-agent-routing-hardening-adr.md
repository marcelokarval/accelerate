# ADR-CODEX-002: Use Repo-Owned Routes And One Launchable Specialist Identity

## Status

- Decision ID: `ADR-CODEX-002`
- Status: `accepted`
- Date: 2026-08-13
- Owner: `accelerate-root`
- Governing issue: `CODEX-3`
- Related SDD: `2026-08-13-codex-agent-routing-hardening-sdd.md`
- Supersedes: the operational use of the frozen `skill-catalog-h55-20260730`
  router snapshot and duplicate raw specialist profile aliases.

## Context

The root is compact by design and discovers specialist skills on demand. That
model becomes unsafe when the router indexes historical bytes, a child receives
only unqualified skill names, or the same skill bundle is launchable through a
raw catalog alias and a separately governed logical agent.

The topology also declares a packet limit that is not a rendering control, and
read-only specialists use language that can be mistaken for write authority.
These are one architectural consistency problem: routing metadata, effective
bytes, launch identity, and authority must agree before delegation.

## Decision

1. The repository owns `skill-catalog-router`, its generator, and its compact
   current index. The global package is only a generated mirror.
2. Spawn Packets identify every assignment skill by ID, absolute runtime
   `SKILL.md` path, and SHA-256 of the exact file bytes. Resolution fails closed.
3. A specialist catalog group with a logical-agent binding has one launchable
   identity: the logical agent. The catalog installer exposes only the two
   recovery profiles `on-demand` and `superpowers-on-demand` and removes stale
   raw generated aliases transactionally.
4. `data-db` and `integrations-ops` become explicit Terra/medium bounded-write
   logical agents with normalized role families `data` and `integrations-ops`.
5. Concrete capabilities `data-database-specialist` and
   `integrations-ops-specialist`, plus the four existing quality candidates,
   are first-class in ontology, pooling, selection, compatibility, and envelope
   doctrine.
6. A read-only specialist may compose proposed content only in its return
   packet. Persisting that content is a different bounded executor assignment.
7. Keep `spawn_packet_limit`, make it a positive configurable integer, and have
   the renderer enforce it without semantic truncation.

## Consequences

Positive:

- children receive reproducible skill routes instead of ambiguous names;
- router discovery follows current repo authority rather than a frozen home
  snapshot;
- specialist model, effort, write mode, and return contract have one launch
  identity;
- data and integration work gain honest bounded owners;
- read-only and executor authority are mechanically distinguishable;
- packet size becomes an operational constraint with a real oracle.

Costs:

- route indexes and global mirrors must be regenerated when governed skill
  bytes change;
- packet rendering performs path containment and hashing work;
- installer migration must distinguish generated stale aliases from unrelated
  user configuration;
- doctrine validators and tests must evolve with the family denominator.

## Rejected Alternatives

- Keep the frozen catalog and merely rename it `current`: rejected because the
  bytes and descriptions already drift from governed runtime truth.
- Put every skill in the root prompt: rejected because it recreates context
  pressure and defeats progressive disclosure.
- Keep raw aliases as convenience shortcuts: rejected because they bypass the
  logical model/effort/authority contract.
- Claim that native spawn injects a logical profile: rejected because current
  binding passes model, effort, and assignment text; the profile is routing
  metadata, not host enforcement.
- Remove the line limit: rejected because compact observable handoff remains a
  useful invariant and can be enforced without truncating semantics.
- Let a read-only reviewer write when the requested file is documentation or a
  test: rejected because content type does not change authority; a separate
  executor preserves review independence.

## Verification

The focused semantic oracle is
`bash tests/codex-agent-routing-hardening.sh`. Full acceptance additionally
requires affected existing suites, `bash tests/all.sh`, source/global parity,
fresh-process logical-profile turns, independent review, and root
review-of-review at the current correction generation.
