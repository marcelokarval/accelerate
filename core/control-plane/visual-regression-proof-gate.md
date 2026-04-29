# Visual Regression Proof Gate

## Purpose

Use this gate when a branch mutates user-facing UI, theme tokens, layout, design
system application, or premium direction implementation.

The gate exists because browser proof can technically pass while the interface is
visually broken. Console silence, HTTP success, and a generated screenshot are
not enough.

## Rule

UI closure requires a human-readable before/after visual comparison packet.

Do not close UI work with only:

- route opened
- console had no new errors
- screenshot path exists
- tests passed

The proof must state what changed visually, what was compared, what regressions
were found, and whether the corrected state was reproved.

## Activation

Activate this gate when any of these are true:

- UI implementation or styling changed
- design-system artifacts drive mutation
- theme tokens, shell, cards, lists, tables, forms, modals, or navigation changed
- browser proof is used as part of review or closure
- a screenshot is captured to support a UI claim
- a user reports visual drift after functional proof passed

## Required Visual Proof Packet

```text
Visual Regression Proof Packet

- target surface / route:
- mutation summary:
- before screenshot(s):
- after screenshot(s):
- viewport(s):
- active theme / mode:
- baseline expectation:
- visual findings:
- density check:
- alignment check:
- overflow / clipping check:
- virtualized-list height check, if relevant:
- domain-copy check:
- component-style-authority check:
- defects found:
- corrected-state screenshot(s):
- verdict: pass | fail | blocked
- residual drift:
```

## Required Checks

At minimum, inspect and report:

- layout stability: no overlap, unintended stacking, clipping, or scroll traps
- density: operational lists/tables still support scanning
- alignment: row content, headings, actions, and numeric columns align as intended
- typography hierarchy: labels do not drown primary content
- domain semantics: copy does not explain obvious state or misname objects
- interaction affordance: CTA/action treatment matches actual behavior
- theme fit: changed surfaces still match the active theme direction
- component authority: fixes happen at the right source layer, not via brittle
  global selectors when component source is available

## Closure Blockers

Do not close when:

- no before/after comparison was made for a visual mutation
- screenshots exist but visual findings are not written down
- browser proof only reports console/network status for UI work
- a list/table/card surface changed without density and alignment review
- a virtualized row changed without checking its real height against row config
- obvious domain-copy noise remains in the UI
- fixed visual defects lack corrected screenshot proof

## Failure Labels

Use these labels before inventing new ones:

- `visual-proof-console-only`
- `screenshot-without-findings`
- `virtualized-row-overlap`
- `operational-density-regression`
- `accidental-centering`
- `domain-copy-noise`
- `style-authority-bypass`
- `corrected-state-not-reproved`
