---
name: playwright-patterns
description: Local Playwright proof guidance for persistent regression in Accelerate, preserving browser-truth-first ordering and covering selectors, auth state, fixtures, traces, retries, network evidence, and flake triage.
user-invocable: true
related-skills: dogfood, product-runtime-review, systematic-debugging
---

# playwright-patterns

Use this skill when a flow is ready to be preserved as persistent Playwright
regression proof.

## Core Rules

1. Browser truth comes first. Playwright persists known behavior; it does not
   replace exploratory browser proof.
2. Every scenario must name its source browser-proof packet or mark the lane
   `out of order`.
3. Prefer user-facing locators and stable app-owned selectors over brittle DOM
   structure.
4. Auth state, fixtures, setup, and teardown must be explicit.
5. Failed or flaky tests need trace/screenshot/network evidence before closure.

## Proof Checklist

- scenario class: smoke, regression, persistence, route-family, or project-owned
  extension
- source browser-proof packet
- exact command and project/package path
- fixture and auth-state setup
- selectors and assertions worth preserving
- screenshot/trace/network artifact when failures or runtime-sensitive flows are
  involved
- flake classification and rerun policy

## Failure Modes

- writing Playwright before understanding the flow in a browser
- asserting implementation details instead of user-visible behavior
- hiding auth/session setup in global state
- closing with "Playwright passed" and no proof packet
- rerunning flaky tests until green without classifying the failure
