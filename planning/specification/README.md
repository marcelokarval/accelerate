# Specification Lifecycle

The Specification Lifecycle is the pre-implementation process for every
mutation. `SDD` means only **Software Design Document**; it is one design
artifact inside this lifecycle, not another name for the process.

The root owns mode selection, design acceptance, implementation entry, and any
exception. A bounded specification writer may draft artifacts and traceability,
but cannot accept its own design or close the governing issue.

## Canonical Manifest

Every mutation materializes an Engineering Artifact Manifest from
`engineering-artifact-manifest-template.json`. The JSON manifest is the
machine-readable index for:

- mutation classification and the selected SDD mode;
- accepted or implementing design authority;
- every artifact disposition and its reason;
- `REQ -> task -> test or exception -> proof` traceability;
- the separate Test Design and TDD Receipt locators;
- correction and proof generations.

Validate it before implementation:

```bash
python3 scripts/validate-engineering-artifact-manifest.py path/to/manifest.json --stage implementation
```

The validator is fail-closed. It does not infer missing fields from Markdown,
timestamps, issue state, or operator commentary.

## Proportional Modes

| Mode | Minimum materialization | Typical boundary |
| --- | --- | --- |
| `micro` | non-empty Spec Capsule plus manifest | known, low-risk, reversible mutation |
| `standard` | accepted delta SDD plus manifest | bounded change with material design or governance choices |
| `hierarchical` | accepted root SDD plus explicit child dispositions | cross-surface or multi-lane work |
| `critical` | accepted SDD plus separate ADR, threat model, Test Design, and rollback artifacts | auth, ownership, billing, secrets, sensitive data, or irreversible work |

Mutation may never use mode `none`. A higher mode may be chosen when evidence
justifies it; a lower mode may not override deterministic risk triggers.

## Lifecycle States

`draft` is authoring state only. Implementation authority must be `accepted` or
`implementing`. `superseded` preserves history and never authorizes new work.

Each run records dispositions for ADR, DESIGN, Test Design, agents, rollout,
rollback, observability, and AGENTS/docs. `consolidated`, `not-applicable`, and
`deferred` require a substantive reason. `separate` and `existing` also require
a locator. Critical mode additionally requires a separate threat model.

## Artifact Boundaries

- `spec-capsule-template.md`: compact semantic SDD for micro mutation.
- `../architecture/delta-sdd-template.md`: standard change design.
- `../architecture/sdd-template.md`: root design for hierarchical or critical work.
- `../architecture/adr-template.md`: durable decision and consequences.
- `../design/design-disposition-template.md`: DESIGN requirement or explicit disposition.
- `../testing/test-design-template.md`: pre-code test strategy, distinct from execution receipts.
- `../testing/tdd-receipt-template.md`: observed baseline, implementation, correction, and reproof history.
- `traceability-template.md`: canonical requirement chain and freshness rules.

Source Verification is evidence gathering about external material. It informs a
specification but is not a design authority, SDD mode, or proof of implementation.
