# Suite Health

Assess the suite as a proof system, not only a pass count.

## Inspect

- determinism across repeated runs where flake risk exists;
- isolation from execution order, wall clock, network, and shared mutable state;
- fixture clarity, cleanup, and production representativeness;
- meaningful assertions on behavior rather than implementation details;
- runtime, memory, parallelism, and timeout changes;
- skipped, quarantined, retried, or expected-failure cases;
- baseline failures versus failures introduced by the candidate;
- traceability to active requirements and latest correction generation.

## Finding Conditions

Report a finding when the suite passes while the required oracle is absent,
when a failure is hidden by retry or skip behavior, or when the proof cannot be
reproduced from its command and fixture contract.

## Return

Record commands, environment assumptions, exit status, case counts, changed
suite behavior, flaky evidence, skipped cases, and residual gaps. Do not claim
health from coverage percentage alone.
