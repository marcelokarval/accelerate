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
- root review-of-review required: yes
- positive fixture expected result: `accept-for-root-review` only when proof locators, validation output, residuals, demotion rules, and scope boundaries are present
- negative fixture expected result: `block-and-demote` when autonomous runtime, generated-source authority, user-home authority, or final closure is claimed without proof
- demotion rule: demote to `blocked` if negative fixture claims are accepted, skill envelope is non-local, cleanup is missing, or root rejects proof
- promotion state: proof-replay only for this fixture; template-only until runtime binding and replay evidence exist
