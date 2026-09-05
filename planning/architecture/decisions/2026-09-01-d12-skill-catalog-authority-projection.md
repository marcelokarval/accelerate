# D12 — Skill Catalog Authority and Projection

- Status: accepted architecture; no operational promotion authorized
- Date: 2026-09-01
- Decision owner: operator-approved Accelerate architecture
- Governing proposal: `planning/architecture/2026-09-01-accelerate-portable-agent-fabric-openspec-design.md`
- Governing proposal SHA-256: `79473c41e77c626a0c849d0ff385be7c140e7f66cfbf047e55ba5ccfe05cd067`

## Decision

The Accelerate repository is the authoring authority for governed catalog
definitions. `~/.agents` is an installed/discovery catalog only. It can expose
a projection of an approved repository artifact, but it is never a source of
truth and cannot prove that an artifact loaded, is callable, or is authorized.

Each harness selects exactly one declared projection mode:
`native-direct`, exact-path `symlink`, `generated-projection`, or
`api-projection`. A projection records its canonical source and digest, target
or provider identity, owner, rollback route, and the lifecycle receipt needed
to advance. This decision is implemented declaratively by `catalog/` and
`adapters/runtime/catalog-projection-contract.md`.

## Canaries and authority boundaries

Every harness requires its own fresh canary before a later lifecycle claim:

| Harness | Projection | Required canary / authority |
| --- | --- | --- |
| Codex | native-direct | native loader and bounded callability receipt |
| Claude | generated-projection | renderer/readback, then runtime loader receipt |
| Hermes | generated-projection | generated projection readback and Hermes runtime/provider receipt |
| Paperclip | api-projection | official Paperclip API readback plus scoped authorization |
| DeepSeek Harness | native-direct | native process, model, and callability receipt |
| OpenCode | native-direct | native loader/callability receipt |
| OpenHands | generated-projection | renderer/readback and native child-loader receipt |

Paperclip's live authority is its official API. Direct database mutation and
copied-credential HTTP are prohibited fallbacks. A Paperclip task projection
does not supersede the separately governed Plane work-item lifecycle.

## Constraints and migration

No blanket home-directory symlink is legal. A symlink may only be an
allowlisted, exact target with a source digest, target owner, loader proof, and
recoverable rollback. Migration is shadow-first: render or register the
candidate without replacing the active projection, validate the harness canary,
then obtain separate operator authority for any cutover. Rollback restores the
last verified projection or removes the candidate projection; it never changes
the repository source by inference from installed state.

There is no current promotion, cutover, installation, symlink creation,
provider call, or removal authorized by this decision.

## Consequences

The current runtime consumer and bootstrap registries remain compatibility
readers, not catalog-authoring surfaces. A conflict between a declared catalog
entry and an existing runtime registry blocks projection and is reported; it is
not corrected by silently changing either authority.
