# SDD Mode Gate

## Rule

Every mutation selects exactly one proportional Software Design Document mode:
`micro`, `standard`, `hierarchical`, or `critical`; mutation mode `none` is
forbidden.

## Deterministic Selection

| Mode | Required materialization | Minimum trigger |
| --- | --- | --- |
| `micro` | non-empty Spec Capsule and manifest | known, low-risk, reversible single-surface mutation |
| `standard` | accepted delta SDD and manifest | architecture, governance, workflow, living-doc, migration, UI, security, or integration design |
| `hierarchical` | accepted root SDD with explicit child dispositions | cross-surface/control-plane, multi-issue/lane, runtime topology, or agent promotion |
| `critical` | accepted SDD plus separate ADR, threat model, Test Design, and rollback | auth, authorization, ownership, permissions, billing, finance, secrets, sensitive data, or irreversible behavior |

Use the highest mode required by any trigger. An operator may raise the mode
with a recorded reason; an override cannot lower it. Under-classification and
underclassification are blocking defects, not proportionality judgments.

`direct-fast-path` is an execution route, not an SDD mode. A trivial mutation
still uses micro semantic SDD and the Issue Bootstrap Gate. Auth, billing,
permissions, sensitive data, migrations, secrets, irreversible calls, and
runtime truth are already ineligible for direct-fast-path and must be classified
at their required higher mode.

## Authority State

`draft` supports authoring only. `accepted` authorizes entry; `implementing`
preserves that authority during execution. `superseded` preserves history and
cannot authorize new implementation.

## Proof

The Engineering Artifact Manifest records triggers, selected mode, SDD state,
and any upward override. The deterministic manifest validator fails closed on
mode `none`, mismatched modes, and under-classification.
