# Browser-Proof Artifact Hardening Executive Plan

## Purpose

Close the Accelerate proof gap where `browser_proof=present` or
`design_implementation_proof=present` can pass closure with a weak or junk
artifact that merely exists.

The target is not to automate browser capture inside Accelerate yet. The target
is to enforce that submitted proof artifacts contain the minimum packet markers
needed for a fresh reviewer to verify screenshot-backed browser proof and visual
analysis.

## Gap

Existing doctrine correctly says browser proof is not a screenshot-only claim and
that design implementation proof must compare runtime output against active
visual artifacts. Existing local workspace gates only check status values and
artifact existence.

That means closure can be fooled by:

- an empty `browser_proof_artifact`
- a generic prose file with no `Browser-Proof Packet`
- a proof artifact with no screenshot/capture path
- a proof artifact with no viewport/state coverage
- a design proof artifact with no artifact comparison result
- a design proof artifact marked present while browser proof is not present

## Selected Approach

Implement content validation inside
`onboarding/local-workspace/check-evidence-artifacts.sh`, because that script
already owns the artifact gate.

Also add a small cross-lane closure rule in
`onboarding/local-workspace/check-evidence-gate.sh`: if
`design_implementation_proof=present`, then `browser_proof` must also be
`present`.

## Enforcement Contract

When `browser_proof=present`, the artifact must contain:

- `Browser-Proof Packet`
- `- surface / route family:`
- `- runtime target:`
- `- browser tool:`
- `- intensity:`
- `- viewport coverage:`
- `- state coverage:`
- `- console/runtime errors:`
- `- network/server truth:`
- `- screenshots/captures:`
- `- residual route-family gaps:`
- `- readiness impact:`

For `closure-ready`, readiness impact must be `supports-closure`.

When `design_implementation_proof=present`, the artifact must contain:

- `Design Implementation Proof Packet`
- `- target surface:`
- `- contract authority:`
- `- source visual evidence:`
- `- rollout / task driver:`
- `- owner layer:`
- `- component mapping:`
- `- viewport coverage:`
- `- state coverage:`
- `- runtime adapter used:`
- `- captures:`
- `- artifact comparison result:`
- `- residual drift:`
- `- promotion posture:`

For `closure-ready`, design implementation proof must show:

- `- artifact comparison result: aligned`
- `- residual drift: none`
- `- promotion posture: promotable`

## Non-Goals

- Do not require Accelerate to launch a browser in this slice.
- Do not require image analysis automation in this slice.
- Do not make browser proof mandatory for non-UI work beyond existing closure
  status rules.
- Do not add a new schema version unless existing registry fields cannot carry
  the enforcement.

## Proof Plan

1. Add tests showing junk browser proof and junk design proof currently pass.
2. Implement marker/content validation.
3. Update fixtures so legitimate closure proof packets pass.
4. Validate local workspace proof gates and broader doctrine/profile gates.
5. Record side-by-side review, defects, corrections, and reproof in the ledger.

## Closure Criteria

- Weak `browser_proof_artifact` blocks closure.
- Weak `design_implementation_proof_artifact` blocks closure.
- Design implementation proof cannot be closure-present while browser proof is
  not present.
- Valid minimal browser/design proof packets pass closure.
- Existing doctrine, profile, registry, and whitespace checks pass.
