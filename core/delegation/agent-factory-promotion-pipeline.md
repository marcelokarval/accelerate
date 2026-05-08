# Agent Factory Promotion Pipeline Pointer

Authoritative pipeline: [`../control-plane/agent-factory-promotion-pipeline.md`](../control-plane/agent-factory-promotion-pipeline.md).

This delegation pointer exists so subagent/task-routing docs can find the agent
factory promotion criteria without duplicating authority.

Key constraints:

- candidate roles require bounded intake before use;
- skill envelopes must come from repo-local skill authority;
- proof replay must include requested-vs-implemented and self-forensic review;
- the RC10 bounded proof-auditor replay is fixture-scoped evidence only, linked
  from `agents/promotion/bounded-proof-auditor-replay.md` and
  `planning/evidence/dated-proof-appendix/agent-factory-replay-2026-05-08.md`;
- runtime binding requires actual proof plus invocation boundary, lifecycle
  monitor, idle detection, cleanup, demotion route, and root acceptance;
- this repository does not claim an autonomous runtime from this pointer.

RC16 note: `bounded-proof-auditor` has runtime-bound candidate criteria and
positive/negative fixture coverage only. It remains `proof-replay` until an
actual runtime adapter invokes it, monitors lifecycle/idle state, cleans owned
state, proves demotion, and receives root acceptance with proof locators.
