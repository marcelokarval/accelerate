# Control Plane Org Map

Use this module when `accelerate` must reason about the macro operating shape
of the governed Codex-agent ecosystem, not just about individual families.

The point is not to mirror Paperclip titles one-for-one.

The point is to make explicit which macro functions the root must perform
before any global agent exists in `~/.codex/agents/*.toml`.

## Core Rule

`accelerate` is the control plane.

The future global agents are subordinate execution or review units.

The root must therefore think like a staffed delivery organization before that
organization exists as runtime roles.

## Macro Shape

```text
accelerate root
├── executive routing
├── technical decomposition
├── lifecycle governance
├── design-contract governance
├── proof governance
├── trust governance
└── integration + forensic closure
```

## Functional Equivalents

### Root executive router

Paperclip equivalent:

- `CEO`

`accelerate` equivalent:

- root classifier
- `Master Integrator`
- branch router

Responsibilities:

- classify the run
- decide whether the work remains root-owned
- decide whether issue topology must split
- decide staffing and delegation budget
- retain final integration and closure authority

### Technical governor

Paperclip equivalent:

- `CTO`

`accelerate` equivalent:

- `Implementation Designer`
- `django-inertia-technical-planner`
- `Governance Auditor` when decomposition must stay constitutional

Responsibilities:

- decompose non-trivial technical work
- decide slice boundaries and execution order
- repair bad packet shape before execution
- return to the root when staffing or hierarchy must change

### Lifecycle governor

Paperclip equivalent:

- `ProductManager`

`accelerate` equivalent:

- `Specification PM`
- `Product Planner`
- `lifecycle-product-manager`

Responsibilities:

- clarify issue shape
- tighten acceptance and non-goals
- decide parent/child hygiene
- keep the execution package lifecycle-clean before implementation starts

### Design-contract governor

Paperclip equivalent:

- `ProductDesigner`

`accelerate` equivalent:

- root-owned `Wireframe / Design Contract Extractor`
- design-contract lane under explicit root posture

Responsibilities:

- convert vague interface intent into bounded design contract
- decide when UI uncertainty blocks clean implementation
- return to lifecycle or technical lanes when acceptance or feasibility changes

### Proof governor

Paperclip equivalent:

- `QALead`

`accelerate` equivalent:

- root-owned proof lane
- `Runtime/Product Reviewer`
- `Browser-Proof Auditor`
- review-stack orchestration owned by the root

Responsibilities:

- decide which proof layers are required
- enforce proof ordering
- return weak implementation claims back to the owning lane
- block closure when evidence is weak or missing

### Trust governor

Paperclip equivalent:

- `TrustLead`

`accelerate` equivalent:

- root-owned trust lane
- `Security Reviewer`
- `Anti-Abuse Reviewer`

Responsibilities:

- decide when a slice is trust-sensitive
- open hostile-path review
- block closure when trust posture is weak
- return the slice to implementation or lifecycle when remediation changes the
  request shape

### Forensic closer

Paperclip equivalent:

- `ClosureForensicReviewer`

`accelerate` equivalent:

- root-owned `Closure / Forensic Reviewer`
- root closure mode

Responsibilities:

- perform requested-vs-implemented revalidation
- check residual drift
- prevent "almost done" from becoming `Done`

## Relationship To Families

The family layer answers:

- which bounded role fits the slice?

The control-plane org layer answers:

- who should even think about the slice?
- who owns the next decision?
- which lane must be open before a family is selected?

Do not confuse these two layers.
