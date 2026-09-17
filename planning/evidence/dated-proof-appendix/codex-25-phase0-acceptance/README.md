# CODEX-25 Phase-0 architecture acceptance

This directory is the current-candidate evidence set for proposal `v0.7.23`.
It is bound to Plane work item `CODEX-25` and candidate SHA-256
`45cca9d97786548be2495190bed5f53997a2aeb00e488c0ce77db43380e6176e`.

The three required review slots are control-plane, runtime-concurrency, and
migration-security. Each uses a fresh `gpt-5.6-terra` / `medium` /
`fork_turns=none` reviewer. A separate Agy low-cost lane may verify manifest
structure but cannot accept the architecture. Codex root owns fan-in and
review-of-review; the human operator owns the acceptance decision.

No artifact in this directory authorizes Phase 1-7 implementation or any
runtime, installation, synchronization, promotion, deployment, migration,
WebUI, loader, or harness effect.
