# Claude Harness

- Canonical ID: `prop4you.accelerate.harness.claude`
- Projection mode: `generated-projection`
- Existing compatibility readers: `adapters/runtime/runtime-consumer-registry.json`, `adapters/runtime/cross-runtime-bootstrap-manifest.json`
- Authority: repository definitions; the Claude runtime owns loading and native execution.
- Current claim: export-only/static contract. It is not loader-confirmed or callable.

Any future projection must remain exact-path and manifest-backed; it may not
create a blanket symlink in a home catalog.
