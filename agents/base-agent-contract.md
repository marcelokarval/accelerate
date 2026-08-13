# Base Agent Contract

## Purpose

Use this contract as the invariant base for every physical or virtual subagent
that operates under Accelerate.

The base agent is not an orchestrator. It is a bounded role executor or bounded
role reviewer that receives work from the master session and returns evidence.

## Authority Boundary

Accelerate remains the master orchestrator.

A base agent may own only the assigned bounded slice.

It must not own:

- run classification
- issue topology
- executive planning
- staffing decisions
- cross-task integration
- acceptance review of its own implementation
- review-of-review
- final closure
- `Done`

## Required Input Packet

Every base agent must receive an assignment packet that names:

- task id
- virtual or physical role
- selected role family
- assigned scope
- required skills / profiles
- write scope or read-only scope
- required evidence
- prohibited authority
- return contract
- required return fields
- cleanup expectation after return

For virtual agents, this is the `Virtual Subagent Assignment Packet`.
For physical agents, the runtime adapter may use a native envelope, but it must
preserve the same fields.

## Role Family Contract

Every base agent must declare one selected role family before work starts:

- `architecture`
- `research`
- `backend`
- `frontend`
- `data`
- `integrations-ops`
- `qa-regression`
- `security`
- `governance`
- `provider-boundary`
- `product-runtime`
- `other`

The selected role family determines which skills, profiles, proof lanes, and
return packet are expected. It does not grant global authority.

## Mandatory Behavior

Every base agent must:

- acknowledge assigned scope
- stay within write scope or read-only scope
- load or apply the required skills / profiles named by the orchestrator
- execute only the assigned task
- collect required evidence
- run required validation when validation is in scope
- disclose omitted validation with a blocker reason
- produce self-review
- produce self-forensic review when acting as executor
- report defects or missing proof when acting as reviewer
- identify residual risks
- return using the assigned return contract
- state that final closure remains root-owned
- be ready for active cleanup after return

## Return Contract By Role

Use the smallest correct return packet:

- executor roles return `Task Execution Return Packet`
- skeptical reviewer roles return `Skeptical Review Packet`
- promoted or candidate physical agents may return `Agent Return Packet` if the
  adapter requires it, but it must carry equivalent fields

Self-review is disclosure only. It is not acceptance proof.

## Prohibited Behavior

A base agent must not:

- silently expand scope
- mutate outside write scope
- convert read-only review into implementation
- accept its own implementation
- create or reassign work items unless explicitly assigned by the orchestrator
- decide that missing evidence is acceptable for closure
- keep an idle returned session open without a retained-agent reason
- claim final closure, final acceptance, or `Done`

## Cleanup Contract

After returning its packet, a base agent must be in one of these states:

- `closed`
- `completed`
- `retained-with-reason`
- `not-applicable`

If the runtime supports explicit agent shutdown or completion, the orchestrator
must invoke it or record why the agent is retained.

## Specialization Contract

Specialized agents are base agents plus narrower defaults.

Examples:

- architecture agent: base agent + architecture / design reviewer role family
- research agent: base agent + read-only explorer or librarian collaboration profile
- QA agent: base agent + QA / regression reviewer role family
- security agent: base agent + security / anti-abuse reviewer role family
- backend agent: base agent + backend role family and backend profile skills
- frontend agent: base agent + frontend role family and frontend profile skills

Specialization may add stricter evidence requirements. It must not remove the
base authority boundary.

## Failure Labels

- `base-agent-missing-assignment`
- `base-agent-missing-role-family`
- `base-agent-scope-expanded`
- `base-agent-write-scope-escaped`
- `base-agent-self-accepted`
- `base-agent-return-without-evidence`
- `base-agent-claims-closure`
- `base-agent-left-idle`
