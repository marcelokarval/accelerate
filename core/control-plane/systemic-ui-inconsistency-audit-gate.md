# Systemic UI Inconsistency Audit Gate

## Purpose

Use this gate when the user asks for a broad, route-family-level audit and
correction loop across UI, data truth, modals, popups, viewports, dashboards, and
industry-standard visual/product inconsistencies.

This is stronger than ordinary browser proof. It is not just "open a few routes
and check console". It is a systemic inconsistency hunt with correction loops.

## Rule

When this gate is active, the run must first create an inventory and audit matrix
before claiming implementation readiness.

The audit must cover, as applicable:

- route inventory
- modal/dialog/sheet/popover/dropdown inventory
- hard-coded values and mock/demo/sample/fake data candidates
- values displayed without backend/database connection proof
- missing information and empty/unavailable states
- desktop/tablet/mobile viewport behavior
- visual hierarchy and organization across analogous pages/components
- dashboard professionalism and market-standard anti-patterns
- AI smell / AI-template indicators in color, type, spacing, composition, copy,
  dashboard patterns, decorative effects, and generic card grids
- rich wireframe proposals for screens where strategic improvement is requested
- defects found by browser proof, visual proof, QA, and code search

## Activation

Activate this gate when the request includes broad language such as:

- all routes
- all windows, modals, popups, dialogs, sheets, or similar surfaces
- hard-coded values
- values not connected to the database
- missing information
- visual inconsistency across desktop/tablet/mobile or many viewports
- dashboard premium/professional standard
- industry-standard wrong patterns
- AI smell, de-AI, anti-template, or generic AI-made visual/product patterns
- wireframes, screen sketches, or rich improvement concepts for each page/screen
- use browser proof and loop until corrected

If the same request also asks for one-shot implementation with looped
correction, activate `Execution-To-Spec Loop Gate` too.

## Required Audit Matrix

Before correction, create or emit a matrix with at least:

```text
Systemic UI Inconsistency Audit Matrix

- route / surface:
- surface type: <page|modal|sheet|popover|dropdown|dashboard|table|list|form>
- viewport(s): <desktop|tablet|mobile|not-tested>
- data truth: <backend-backed|hard-coded|mock/demo|unknown|not-applicable>
- missing-info state: <ok|missing|unclear|not-applicable>
- visual organization: <consistent|inconsistent|broken|unknown>
- analogous surfaces compared:
- AI smell indicators:
- strategic improvement proposal:
- wireframe required/provided:
- browser evidence:
- code evidence:
- defect id(s):
- severity:
- correction status:
- reproof evidence:
```

## Discovery Requirements

The first loop must discover both runtime surfaces and source candidates.

Use source search for patterns such as:

- `mock`, `placeholder`, `TODO`, `FIXME`, `demo`, `sample`, `fake`, `lorem`
- hard-coded arrays and constants that feed UI lists or metrics
- `Math.random`, generated values, static KPI values, static percentages
- modal/dialog/sheet/popover/dropdown/command/menu components
- route/page files and route registries

Use UI/product review for patterns such as:

- generic AI dashboard card grids with weak hierarchy
- indiscriminate gradients, glow, blur, glass, or decorative haze
- over-rounded or over-spaced layouts that reduce operational density
- same-weight cards where only one or two facts matter
- vague SaaS copy, filler labels, redundant labels, and non-domain wording
- charts, KPIs, and badges without product meaning or data-truth proof
- typography/color choices that look template-generated rather than domain-led

Source search is not enough. Browser proof must validate runtime surfaces and
viewports when the local app is available.

## Viewport Requirements

For visual inconsistency claims, inspect at least:

- desktop wide
- tablet or medium breakpoint
- mobile narrow

Reduce this matrix only with an explicit bounded exception.

## Correction Loop

Each defect must be dispositioned:

- fix now
- defer with reason
- out of scope
- blocked by missing runtime/data/credential
- false positive after source/runtime reconciliation

Every `fix now` defect requires fresh proof. For UI defects, fresh proof means
corrected browser screenshot or equivalent visual comparison, not only tests.

## Wireframe Requirement

When the user asks for wireframes, do not skip directly from findings to code.

For each affected screen or screen family, provide a rich wireframe or equivalent
structure proposal before implementation. The wireframe must name:

- information hierarchy
- primary action and secondary actions
- data regions and empty/error states
- viewport behavior
- which AI-smell or market anti-pattern it removes

Wireframes may be grouped by analogous screen family when the same structure is
intentionally reused.

## Closure Blockers

Do not close when:

- no route/surface inventory exists
- modals/popups/sheets were requested but not inventoried
- hard-coded or mock-data search was skipped
- database/data-truth claims were made without source or runtime evidence
- viewport claims were made from desktop-only screenshots
- AI smell was requested but not assessed
- wireframes were requested but not produced or grouped with justification
- browser proof did not feed the correction loop
- defects were fixed without corrected-state proof
- final summary lacks unresolved defects and residual scope gaps

## Failure Labels

- `systemic-audit-without-inventory`
- `modal-surface-blind-spot`
- `hard-coded-data-untriaged`
- `database-truth-unproven`
- `desktop-only-responsive-claim`
- `analogous-surface-drift`
- `dashboard-professionalism-gap`
- `ai-smell-untriaged`
- `wireframe-skipped-before-implementation`
- `broad-audit-claimed-from-sample`
