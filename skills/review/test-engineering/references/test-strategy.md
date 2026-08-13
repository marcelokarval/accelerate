# Test Strategy

## Lowest Effective Level

Choose the first level that proves the affected behavior without mocking away
the risk:

1. pure/unit for deterministic local behavior;
2. component/module for boundary collaboration;
3. integration/contract for database, queue, filesystem, or provider behavior;
4. API/interface for transport, schema, auth, and compatibility;
5. browser/runtime for DOM, network, accessibility, rendering, or user flow;
6. persistent end-to-end only after browser truth is stable.

Use multiple levels only when each proves a different risk.

## Required Dimensions

| Dimension | Question |
| --- | --- |
| happy | Does intended behavior work? |
| negative | Does invalid or hostile input fail safely? |
| boundary | What happens at empty, minimum, maximum, duplicate, and transition edges? |
| permission / ownership | Can the wrong actor observe or mutate state? |
| concurrency / idempotency | Do retries or simultaneous operations corrupt outcomes? |
| failure / recovery | Are partial failure, retry, rollback, and cleanup correct? |
| fixtures / data | Are fixtures representative, isolated, and deterministic? |
| observability | Can proof and failures be correlated? |
| nonfunctional | Which security, accessibility, compatibility, performance, or resilience risks apply? |

Every dimension needs `required` or `not-applicable` plus a substantive reason.

## Contract Selection

- feature: observed Red -> Green -> Refactor;
- bug: observed failing reproduction -> correction -> regression proof;
- refactor: characterization baseline -> unchanged behavior proof;
- docs/config/workflow: semantic validator -> correction -> validator proof;
- migration: forward, rollback, compatibility, and data-integrity proof;
- security: safe negative proof at the trust boundary;
- browser UI: browser truth before persistent automation;
- provider integration: contract, idempotency, failure, and readback proof.
