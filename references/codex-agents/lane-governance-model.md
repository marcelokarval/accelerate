# Lane Governance Model

Use this module when `accelerate` must decide which lane opens, what that lane
owns, and when the lane becomes blocking.

## Core Rule

Lanes are opened by the root because the root has identified the dominant class
of decision pressure.

Lanes are not just labels.

They carry:

- a decision owner
- a blocker profile
- a return path
- a release condition

## Lane Catalog

### Technical lane

Open when:

- decomposition is the real problem
- slice boundaries are unclear
- backend/frontend coupling is driving the risk

Owns:

- decomposition
- execution order
- technical packet repair

Blocks when:

- slice boundaries are invalid
- staffing would create structural drift

### Lifecycle lane

Open when:

- acceptance is weak
- issue shape is wrong
- parent/child truth is unstable

Owns:

- issue topology
- acceptance and non-goals
- lifecycle reentry

Blocks when:

- implementation-ready issue shape does not exist
- child set or parent linkage is invalid

### Design-contract lane

Open when:

- UI uncertainty is structural, not cosmetic
- technical execution is blocked by missing interface contract

Owns:

- interface contract clarification
- escalation to design artifact discipline
- root-owned design-contract judgment

Blocks when:

- implementation would otherwise invent UX truth

### Proof lane

Open when:

- user-facing or runtime-sensitive change needs independent evidence
- backend or frontend claims are not sufficient

Owns:

- proof ordering
- evidence sufficiency
- classification of weak proof

Blocks when:

- mandatory proof is absent
- the wrong proof tier was used

### Trust lane

Open when:

- hostile-path or misuse risk is material
- auth, billing, export, deletion, upload, recovery, list/search, settings, or
  similar surfaces are involved

Owns:

- threat/misuse review
- trust blocker decision

Blocks when:

- abuse or security posture remains materially weak

### Root closure mode

Open when:

- the slice is at closure candidate stage

Owns:

- requested-vs-implemented revalidation
- residual drift classification
- final root-owned closure judgment

Blocks when:

- the work is partial, drifted, stale, or closure-evidence is weak

## Lane Ordering

Preferred macro order:

1. lifecycle
2. technical
3. design-contract when needed
4. execution
5. proof
6. trust when applicable
7. root closure mode

Trust may open before proof if the dominant risk is hostile-path safety.

## Return Rule

Every bounded execution or review slice must return to:

- its lane governor
- or directly to the root if the lane is root-owned

Do not treat the last writer as the next decision owner.
