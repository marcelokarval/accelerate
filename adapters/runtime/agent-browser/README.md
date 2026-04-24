# Agent Browser Runtime Adapter

## Purpose

This adapter specifies how an `agent-browser`-style CLI browser runtime can fit
inside `accelerate`.

The goal is to preserve the high operational capability seen in GLM / Z.ai
browser agents while keeping local proof ordering, session safety, and evidence
ownership explicit.

## Role

`agent-browser` is an optional browser automation adapter.

It may support:

- opening pages
- accessibility or semantic snapshots
- click, type, fill, select, hover, scroll, and key operations
- screenshots and full-page screenshots
- video recording
- PDF capture
- upload flows
- waits and runtime assertions
- tab, window, frame, and dialog handling
- JavaScript evaluation
- network route observation or mocking
- cookie, localStorage, sessionStorage, and browser state save/load

It does not replace:

- Chrome DevTools as first browser truth when flow truth is unstable
- Playwright as persistent regression proof after the scenario stabilizes
- the master orchestrator as owner of closure

## Proof Ordering

Use this adapter inside the existing proof stack:

```text
implementation proof
  -> backend / frontend QA
  -> Chrome DevTools browser truth
  -> optional agent-browser repeatable browser operations
  -> Playwright persistent regression
  -> forensic closure
```

When the flow is not understood, start with Chrome DevTools.

When the flow is understood but needs faster repeated interactive operation,
`agent-browser` can provide a high-capability runtime lane.

When the scenario must survive future regressions, persist it in Playwright.

## Evidence Shape

An `agent-browser` proof packet should include:

- target URL or route family
- authentication/session posture
- capability used
- snapshot or semantic reference
- screenshot/video/PDF artifact when relevant
- console or network observations when relevant
- operation sequence summary
- failures found
- residual gaps
- whether the result should become Playwright coverage

## Bounded Visual Proof Recipe

Use this adapter for repeatable browser operations only after the target surface
and session posture are bounded.

Representative command flow:

```bash
agent-browser open <url>
agent-browser snapshot -i
agent-browser errors
agent-browser console
agent-browser set viewport 1440 1000
agent-browser screenshot .tmp/browser-proof-desktop.png --full
agent-browser set viewport 375 812
agent-browser screenshot .tmp/browser-proof-mobile.png --full
```

For interaction proof, re-snapshot after navigation or state changes:

```bash
agent-browser snapshot -i
agent-browser click @e1
agent-browser wait --load networkidle
agent-browser snapshot -i
agent-browser screenshot .tmp/browser-proof-after-action.png --full
```

For design-system or premium UI work, pair these captures with the Design
Implementation Proof Gate. The adapter captures evidence; the gate decides
whether the evidence is sufficient.

## Required Bounds Before Use

Before running this adapter, state:

- target route or route family
- session posture
- allowed viewports
- allowed interactions
- whether screenshots may include user data
- where captures will be stored, usually project-root `.tmp/`
- whether cookie/storage/state commands are prohibited or explicitly allowed

## Session Safety

Browser state access is privileged.

The adapter must distinguish:

- unauthenticated browsing
- seeded test session
- authenticated local session
- production-like session
- unknown session

Do not dump or persist cookies, tokens, localStorage, or sessionStorage unless
the proof explicitly requires it and the scope is safe.

For design proof, default to screenshots, semantic snapshots, console/errors,
and explicit user-path actions. Treat cookie, storage, network mock, and JS eval
commands as elevated operations requiring a stated reason.

State save/load must state:

- what state is saved
- where it is saved
- why it is needed
- whether it contains credentials or user data
- when it should be deleted

## Network And JS Boundaries

Network interception and JavaScript evaluation are high-power features.

Use them for:

- observing runtime failures
- proving frontend state
- mocking known backend conditions in local QA
- reproducing browser-only defects

Do not use them to hide backend defects, bypass product flow, or create closure
evidence that a real user path would not support.

## Active Observer Compatibility

This adapter can power future scheduled browser observers, but only under a
separate observer lane with:

- route allowlist
- runtime budget
- no silent mutation
- explicit severity taxonomy
- issue or executive artifact registration
- clear proof packet output

The adapter is the capability provider. The observer lane owns scheduling and
triage policy.

## Failure Modes

Name these failures explicitly:

- `browser-truth-inversion`
  - adapter automation is treated as truth before Chrome DevTools or equivalent
    interactive discovery stabilizes the flow
- `state-leak-risk`
  - cookies, tokens, storage, or session state are captured without a bounded
    reason and deletion posture
- `automation-as-closure`
  - a scripted pass is used to close a product or UX issue without forensic
    review
- `unbounded-visual-sweep`
  - the adapter browses routes or captures states outside the declared allowlist
- `screenshot-without-comparison`
  - screenshots exist but are not compared against the active visual authority
- `mocked-reality-closure`
  - network or JS manipulation hides the real behavior under review
- `observer-without-registration`
  - scheduled browser findings mutate work or conclusions without issue,
    planning, or executive registration

## Future Agent Fit

When `*.toml` agents exist, this adapter is a natural capability surface for a
bounded `runtime-proof-auditor` or `ui-polishing-observer`.

It must not become a root agent.

The root still owns:

- route selection
- proof intensity
- escalation
- issue topology
- closure authority
