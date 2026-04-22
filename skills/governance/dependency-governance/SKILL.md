---
name: dependency-governance
description: Codex-native dependency governance. Use when adding, keeping, removing, or questioning frameworks or libraries, especially when legacy precedent, overlap, banned-for-new-code dependencies, or stack ambiguity is involved.
---

# dependency-governance

Use this skill when dependency role or legitimacy is under review.

## Classification Model

Judge dependencies as:

- official
- allowed-exception
- legacy-reference
- deprecating
- banned-for-new-code

## Current High-Signal Calls

- Official stack dependencies are declared by the active stack profile.
- Legacy dependencies are reference material, not automatic approval.
- Deprecated or banned dependencies must not re-enter through copy/paste.
- Validation libraries are helpers unless the active architecture explicitly
  makes them canonical contract authorities.

## Review Questions

- Does this dependency duplicate official stack behavior?
- Is it being kept because of real need or legacy inertia?
- Is its role explicit and allowed?
