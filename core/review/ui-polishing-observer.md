# UI Polishing Observer

## Purpose

Use this lane for active visual and product-surface improvement loops.

It translates the GLM / Z.ai polishing-agent idea into local `accelerate`
governance: high-frequency observation and sharp UI bug hunting are valuable,
but they must not become silent mutation, unbounded browsing, or vague visual
opinion.

## Scope

This lane applies to:

- product-critical surfaces
- premium interface surfaces
- conversion-sensitive pages
- authenticated dashboards with high perceived-quality requirements
- cross-component UI consistency audits
- recurring browser-polishing loops

It should not be mandatory for ordinary backend work or low-risk internal
pages.

## Observer Model

The observer may be human-run, agent-run, or scheduled in the future.

Safe loop:

```text
surface allowlist
  -> browser observation
  -> visual / UX / consistency scan
  -> severity classification
  -> issue or executive finding
  -> bounded implementation
  -> browser proof
  -> persistent regression only when stable
```

Observation is not mutation.

When observation happens inside an active design-system or premium UI slice, its
findings feed:

- `defect-ledger.md`
- `active-correction-loop.md`
- `../control-plane/design-implementation-proof-gate.md`

The observer does not replace implementation proof and does not own root
closure.

## Cross-Component Audit Checklist

Inspect:

- component reuse and duplicate markup
- tokenized class composition
- shared variants and utility centralization
- cross-view visual consistency
- theme harmony
- typography hierarchy
- spacing rhythm
- z-index, overlays, modals, popovers, and collision risks
- responsive expansion and mobile compression
- empty, loading, error, and disabled states
- navigation consistency
- data integrity and stale UI assumptions
- keyboard navigation and focus visibility
- contrast and perceived affordance

## Severity

Use severity to avoid turning every visual preference into a blocker.

- `P0`
  - broken core task, inaccessible critical action, destructive confusion,
    auth/billing/conversion blocker
- `P1`
  - serious visual/UX defect on product-critical or premium surface,
    misleading hierarchy, CTA dilution, blocking responsive issue
- `P2`
  - inconsistency, polish issue, duplicate pattern, weak empty/loading/error
    state, localized component drift
- `P3`
  - minor refinement or aesthetic improvement with low product impact

Only `P0` and selected `P1` findings block closure by default.

## Evidence Packet

Leave:

- surface or route family
- observer mode
- browser/runtime used
- viewport coverage
- state coverage
- findings by severity
- screenshots or references when useful
- implementation recommendation
- proof needed before closure
- whether Playwright persistence is justified

## Relationship To Premium Interface

`premium-interface-production.md` owns visual direction and premium composition.

This lane owns recurring inspection and cross-component polish.

If the page is structurally weak, re-enter premium/product-critical framing
instead of applying cosmetic fixes.

## Relationship To Browser Proof

Use Chrome DevTools first when the runtime truth is unstable.

An `agent-browser` adapter may power fast repeated observation once the target
surface and session posture are bounded.

Playwright persistence comes after stable browser truth.

For design-system or premium UI application, browser proof should also satisfy
the Design Implementation Proof Gate's viewport/state coverage and corrected
state requirements.

## Scheduled Operation Guardrails

Future scheduled observers require:

- route allowlist
- environment declaration
- session posture declaration
- runtime budget
- output destination
- no silent mutation
- no unrestricted cookie/storage capture
- issue or executive artifact registration
- throttling to avoid noisy churn

Scheduled polishing without registration is a workflow failure.

## Failure Modes

Name these failures explicitly:

- `polish-without-product-job`
  - visual tweaks happen without knowing the job of the screen
- `silent-observer-mutation`
  - scheduled or agent observation changes code or doctrine without issue /
    planning registration
- `cosmetic-fix-over-structure`
  - cosmetic changes hide a hierarchy, CTA, or flow problem
- `component-drift`
  - local UI improvements diverge from shared primitives and tokens
- `responsive-blind-spot`
  - desktop pass hides mobile or narrow viewport failure
- `browser-proof-collapse`
  - observation, proof, and persistent regression are compressed into one
    vague statement

## Future Agent Fit

When `*.toml` agents exist, this lane is a natural recurring agent family.

Candidate bounded agent:

- `ui-polishing-observer`

Allowed responsibility:

- observe
- classify
- propose
- register findings
- verify bounded fixes

Disallowed responsibility:

- root closure
- unbounded mutation
- production session scraping
- doctrine promotion without approval
