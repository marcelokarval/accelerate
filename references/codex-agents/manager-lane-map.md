# Manager Lane Map

Use this module when `accelerate` must reason in terms of lane governors rather
than future runtime workers.

The lane governors are not yet `*.toml` roles.

They are root-owned managerial functions that steer staffing, proof, trust, and
return routing.

## Manager Lane Pool

### `executive routing lane`

Owner:

- `accelerate` root

Responsibilities:

- intake classification
- top-level staffing and delegation budget
- lane opening order
- final closure authority

### `technical lane governor`

Owner:

- `Implementation Designer`
- `Governance Auditor` when constitutional pressure is active

Responsibilities:

- technical decomposition
- boundary shaping
- execution sequence
- correction of invalid technical slice shapes

### `lifecycle lane governor`

Owner:

- `Specification PM`
- `Product Planner`

Responsibilities:

- issue hygiene
- acceptance clarity
- parent/child structure
- reentry into parent when scope truth changes

### `design-contract lane governor`

Owner:

- root-owned `Wireframe / Design Contract Extractor`

Responsibilities:

- interface ambiguity reduction
- design artifact escalation
- contract return to technical or lifecycle lanes

### `proof lane governor`

Owner:

- root-owned proof stack

Responsibilities:

- decide proof layers
- enforce proof ordering
- classify proof weakness
- block closure on insufficient evidence

### `trust lane governor`

Owner:

- root-owned trust stack

Responsibilities:

- open hostile-path review
- decide if trust review is blocking
- return the slice when remediation changes the implementation path

## Lane Types

### Manager lanes

These decide, route, and block.

They do not primarily mutate code.

### Specialist lanes

These produce bounded implementation or review output.

They return to a manager lane or to the root.

### Root-owned lanes

These stay with `accelerate` unless explicit governance later extracts them:

- executive routing
- design-contract governance
- proof governance
- trust governance
- forensic closure

## Mapping To Existing Families

| Manager lane | Typical bounded family partner |
| --- | --- |
| technical lane governor | `django-inertia-technical-planner`, `django-domain-implementer`, `django-inertia-contract-integrator` |
| lifecycle lane governor | `lifecycle-product-manager` |
| design-contract lane governor | `inertia-react-ui-implementer` when contract is stable |
| proof lane governor | `runtime-proof-auditor` |
| trust lane governor | `trust-anti-abuse-reviewer` |

## Core Rule

Do not let a bounded family silently become a manager lane.

The family may execute or audit a slice.

The lane governor decides what that slice means for the system.
