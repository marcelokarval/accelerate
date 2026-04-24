# Chrome DevTools Adapter

## Purpose

This adapter documents the browser-truth runtime layer.

## Role

This adapter owns the first interactive browser-truth pass for runtime-sensitive
UI work.

It should define:

- browser truth capture posture
- intensity declaration
- evidence expectations
- failure handling

It does not replace:

- frontend type/lint/build proof
- optional `agent-browser` repeatable operations after the flow is bounded
- Playwright persistent regression after the scenario is stable
- root closure authority

## When To Use

Use Chrome DevTools or an equivalent interactive browser tool when:

- a changed surface must be inspected in the real browser
- design-system or premium UI fidelity is closure-relevant
- the user path is not stable enough for Playwright persistence
- console/runtime errors may affect perceived correctness
- responsive or theme behavior needs visual inspection

## Browser Truth Recipe

For design implementation proof, capture the smallest honest sequence:

1. open the target route or state
2. wait until loading indicators settle or record why they do not
3. inspect console errors and runtime warnings
4. inspect network failures when visible behavior depends on data
5. capture desktop viewport evidence
6. capture mobile/narrow viewport evidence when layout or premium quality is in
   scope
7. inspect changed interactive states such as hover, focus, open, selected,
   disabled, loading, error, empty, and success when relevant
8. compare the rendered result against the active authority:
   - design-system showcase
   - design-system contract
   - premium direction HTML
   - approved wireframe or ASCII composition
9. register in-scope defects instead of burying them in prose
10. after fixes, recapture the corrected state

## Evidence Packet

Use this shape when Chrome DevTools is the browser-truth source:

```text
Chrome DevTools Browser Truth Packet

- target route / state:
- browser/runtime:
- auth/session posture:
- proof intensity: sampled | targeted | broad sweep | full route-family audit
- viewport coverage:
- state coverage:
- console/errors:
- network observations:
- visual authority compared:
- captures:
- defects opened:
- corrected-state captures:
- residual gaps:
- should persist to Playwright: yes | no | later
```

## Failure Modes

Name these explicitly:

- `console-error-ignored`
  - runtime errors are visible but closure proceeds without disposition
- `single-viewport-closure`
  - responsive or premium UI work closes from one viewport without exception
- `state-blind-proof`
  - changed interactive states are not inspected
- `pre-fix-proof`
  - screenshots or observations still show the pre-correction state
- `artifactless-visual-claim`
  - the branch claims design compliance without comparing against the active
    visual authority
