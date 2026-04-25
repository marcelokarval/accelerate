# Artifact Sufficiency Check

## Purpose

Artifact Sufficiency Check decides whether the available artifacts are strong
enough to drive implementation, review, audit, or closure.

It prevents treating prose, screenshots, plans, generated packets, or external
captures as sufficient when the active branch needs executable proof or richer
source truth.

## When Required

Use this check when branch behavior depends on:

- PRD, SDD, issue body, task breakdown, or execution plan
- design-system artifacts, visual references, screenshots, or Figma/HTML capture
- attack packets, hostile-path notes, or source observation packets
- browser proof, route maps, or persistent regression scenarios
- locale packs, API contracts, schemas, migrations, or query-shape evidence
- public docs/navigation/discoverability changes
- realistic data requirements for product or UI proof

## Sufficiency Test

An artifact is sufficient only when it is:

- local or explicitly imported into local authority
- current enough for the decision being made
- specific about affected surfaces
- complete enough to derive acceptance criteria
- paired with proof expectations for closure
- traceable to a branch, issue, profile, adapter, or core doctrine owner

## Artifact Classes

### Planning artifacts

Must define scope, acceptance criteria, dependencies, gates, and evidence.

### Design artifacts

Must include token/component/layout/state rules and implementation constraints,
not only visual aspiration.

### Runtime proof artifacts

Must include command/browser/runtime evidence, timestamp or run context when
relevant, and residual risks.

### Source observation artifacts

Must include source URL or origin, final URL when redirected, capture time,
trust limits, retention posture, and downstream-use boundaries.

## Blocking Conditions

Do not proceed when:

- a generated artifact is treated as source truth without owner review
- an artifact lacks acceptance criteria for the branch being executed
- design work lacks implementable token/component/layout/state rules
- browser/runtime claims rely only on static inspection
- realistic data is necessary but fixtures/examples are absent
- docs/navigation changed but public/sidebar discoverability was not considered

## Closure Rule

Closure must say which artifacts drove the work and why they were sufficient. If
an artifact was insufficient, closure must either include the repair or record a
bounded residual blocker.
