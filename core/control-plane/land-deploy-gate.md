# Land Deploy Gate

Land/deploy is separate from ship readiness. It requires a concrete provider
adapter and explicit production-risk approval when production state may change.

## Required Inputs

- ship readiness packet
- provider adapter contract
- CI/check status when provider supports it
- deploy target
- canary or production verification plan
- rollback or investigate path

## Rule

Core docs may define this gate, but executable land/deploy behavior belongs in
workflow/runtime adapters.
