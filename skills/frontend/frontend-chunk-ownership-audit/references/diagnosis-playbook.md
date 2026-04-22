# Diagnosis Playbook

## Goal

Turn an alarming bundle edge into a bounded explanation with evidence.

## Questions to Answer

1. Is this edge visible in the built graph only, or also in source imports?
2. Which modules are being claimed by the wrong chunk owner?
3. Is the bad owner a feature chunk, a barrel, or a coarse shared bucket?
4. What is the smallest ownership correction that removes the edge?

## Evidence Sequence

1. Build the frontend.
2. Generate the bundle inventory or inspect the manifest.
3. Capture the suspicious edges and chunk sizes.
4. Search source imports for the same feature-to-feature relationship.
5. Inspect `manualChunks` or equivalent ownership rules.
6. Inspect barrels and "shared" folders that sit on the path.

## Typical Root Causes

- broad barrel imports
- "shared" modules that really belong to one feature
- generic chunk rules that capture too much
- route contracts and validators living under a feature surface
- third-party heavy dependencies leaking through an unrelated entrypoint

## Typical Fixes

### Neutral Shared Ownership

Use when multiple features genuinely need the same contracts or primitives.

Examples:

- routes
- validators
- setup status helpers
- logger and lightweight UI primitives

### Bounded Feature Ownership

Use when a module sits in a shared path but semantically belongs to one
feature.

Examples:

- billing-only modal infrastructure
- lead-finder-only save-search dialog

### Barrel Retirement

Use when the real problem is that the import path is broader than the call site
needs.

Fix:

- replace barrel imports with file-level imports

## Review Checklist

- Did the edge disappear from the generated graph?
- Did the chunk size move in the expected direction?
- Did a new neutral chunk stay bounded, or did it become a new dumping ground?
- Did dynamic imports and route-level code splitting remain intact?
- Is any residual edge explicitly tracked as follow-up?
