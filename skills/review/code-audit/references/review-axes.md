# Review Axes

Review axes are independent lenses. A change can pass one and fail another.
Record an evidence-backed disposition for every applicable axis.

## 1. Correctness

- Compare requested, specified, and implemented behavior.
- Exercise happy, negative, boundary, error, and state-transition paths.
- Look for lost updates, invalid state, partial failure, and stale assumptions.

## 2. Legibility

- Check naming, locality, control flow, and whether intent is visible.
- Prefer the smallest legible solution that preserves required guards.
- Treat size and complexity metrics as signals, never automatic findings.

## 3. Architecture

- Check ownership, dependency direction, boundaries, and source-of-truth rules.
- Verify durable decisions, migrations, compatibility, and rollback contracts.
- Judge against repo-local architecture rather than universal folder rules.

## 4. Security

- Identify trust boundaries, untrusted inputs, authorization, and secret paths.
- Check exploitability, abuse variants, supply-chain provenance, and failure mode.
- Require negative proof for corrected security-sensitive behavior.

## 5. Performance

- Check algorithmic cost, I/O/query shape, resource lifetime, and hot paths.
- Label every metric by source; do not report unmeasured opportunity as a
  measured regression.
- Avoid universal thresholds without product or repository authority.

## 6. Tests

- Check traceability, lowest effective level, negative coverage, and fixtures.
- Distinguish test presence from meaningful behavioral proof.
- Check suite health, determinism, isolation, and baseline comparison.

## 7. Verification Story

- Reconcile commands, exit status, logs, screenshots/traces, and proof locators.
- Distinguish planned, observed-red, corrected, re-proved, and stale evidence.
- State what remains unverified and who owns final acceptance.

## Disposition Shape

For each axis record:

- status: `pass`, `finding`, `not-applicable`, or `blocked`;
- evidence or substantive reason;
- related finding IDs;
- residual risk.
