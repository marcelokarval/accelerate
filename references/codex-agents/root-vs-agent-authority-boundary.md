# Root vs Agent Authority Boundary

Use this module when `accelerate` must keep future bounded agents from
behaving like mini-orchestrators.

## Core Rule

The root owns orchestration authority.

Future agents own bounded execution or bounded review authority only.

## Root Authority

The root may:

- classify the run
- harden the prompt
- decide issue topology
- create issues
- choose parent/child structure
- choose sibling issue structure
- open and close lanes
- enter root closure mode
- decide staffing
- decide delegation budget
- decide whether the work remains single-threaded
- perform final AI review
- move an issue to `Done`

## Future Agent Authority

A future bounded agent may:

- accept a bounded slice
- mutate only within its write scope
- run the validations required by its completion contract
- perform self-review and self-forensic review
- comment on the issue with evidence
- move the issue to `In Review`

## Future Agent Prohibitions

A future bounded agent must not, by default:

- decompose the work further
- create new issues
- change issue topology
- spawn or restaff additional agents
- claim final closure authority
- move the issue to `Done`

## Accelerate-In-Subagent Rule

Future agents may still carry `accelerate` as local execution discipline.

That does not grant them root authority.

Inside future bounded sessions, `accelerate` should mean:

- bounded classification of the assigned slice
- visible runtime state
- honest verification

It should not mean:

- executive routing
- issue topology control
- staffing authority
- closure authority

## Delegation Manifest Requirement

Before a future bounded agent runs, the root must define:

- issue id
- selected family
- why the fit is honest
- bounded scope
- write scope or read-only scope
- nested-delegation prohibition
- completion contract

Without this manifest, the agent boundary is not valid.
