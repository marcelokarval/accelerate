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
- runtime binding requires actual proof and cleanup/idle-agent handling;
- this repository does not claim an autonomous runtime from this pointer.
