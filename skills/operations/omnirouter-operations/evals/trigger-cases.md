# OmniRouter Operations Trigger Cases

## should trigger

- prompt: Change auto/best-fast priority and prove failover before retry.
  expected: omnirouter-operations
- prompt: Diagnose a missing model in OmniRouter's model enumeration.
  expected: omnirouter-operations
- prompt: Smoke-test tool calling through all three governed aliases.
  expected: omnirouter-operations
- prompt: Benchmark this frozen prompt through OmniRoute and compare compression engines.
  expected: omnirouter-operations
- prompt: Disable CCR and prove the endpoint receives the complete prompt without cache or memory.
  expected: omnirouter-operations
- prompt: A response contains a CCR retrieve marker; identify the failed retrieval contract.
  expected: omnirouter-operations
- prompt: Compare a no-tools DeepSeek Web proposal and Terra medium on one frozen parser bug; keep effort and acceptance evidence explicit.
  expected: omnirouter-operations; route to model-role-comparison; no promotion
- prompt: Refresh our claims that Luna medium is best using current primary sources only; do not query providers.
  expected: omnirouter-operations; route to model-research-method; research-only
- prompt: DeepSeek says it applied and tested a patch; promote it without local proof.
  expected: omnirouter-operations; reject promotion; require governed executor proof
- prompt: Benchmark two aliases by sending concurrent web-provider calls after a 429.
  expected: omnirouter-operations; stop current provider wave and retain not-run rows

## should not trigger

- prompt: Decide whether an engineering request needs a reasoning subagent.
  expected: no-trigger
- prompt: Implement an application feature using auto/best-coding.
  expected: no-trigger
- prompt: Make a direct OpenAI API call that does not traverse OmniRoute.
  expected: no-trigger
- prompt: Treat HTTP 200 from a model as proof that its code patch satisfies the repository tests.
  expected: no-trigger; semantic claim is unsupported without local proof
