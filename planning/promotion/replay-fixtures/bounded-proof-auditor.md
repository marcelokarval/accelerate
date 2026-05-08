# Bounded Proof Auditor Replay Fixture

- template path: `agents/promotion/bounded-proof-auditor-replay.md`
- base contract reference: `agents/base-agent-contract.md`
- promotion readiness packet reference: `planning/promotion/template-promotion-readiness-packet.md`
- selected role family: `governance-reviewer`
- compatible capability family: `proof-auditor`
- assignment received: review bounded implementation packets for proof honesty, requested-vs-implemented coverage, residuals, cleanup, and forbidden optimistic status language
- return contract expected: `Subagent Return Packet` with requested-vs-implemented, validation output, self-review, self-forensic review, defects/residuals, and recommendation
- prohibited authority checked: final closure, `Done`, issue topology, nested delegation, provider writes, user-home skill authority, autonomous runtime availability
- residual risk required: yes
- cleanup expectation checked: complete
- runtime-bound checklist: invocation boundary, lifecycle monitor, idle detection,
  cleanup, demotion route, and root acceptance are present as criteria only
- root review-of-review required: yes
- positive fixture expected result: `accept-for-root-review` only when proof locators, validation output, residuals, demotion rules, and scope boundaries are present
- lifecycle positive fixture: accepts only a packet that records start/progress or
  equivalent monitor evidence, completion/timeout, no idle orphan, cleanup result,
  demotion route, and root acceptance pending
- lifecycle negative fixture: `block-and-demote` when `runtime-bound` or
  `available` is claimed without invocation/lifecycle/idle/cleanup proof, or when
  transcript/cache/temp/process cleanup is unaccounted
- negative fixture expected result: `block-and-demote` when autonomous runtime, generated-source authority, user-home authority, unsupported runtime-bound availability, missing cleanup, or final closure is claimed without proof
- demotion rule: demote to `blocked` if negative fixture claims are accepted, skill envelope is non-local, cleanup is missing, lifecycle/idle monitoring is missing, or root rejects proof
- promotion state: proof-replay only for this fixture; template-only until runtime binding and replay evidence exist
