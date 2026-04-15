# Root vs Agent Authority Boundary

Use this module to keep future bounded agents from behaving like
mini-orchestrators.

## Core Rule

The root owns orchestration authority.

Bounded agents own bounded execution or bounded review authority only.

## Root Authority

The root may:

- classify the run
- harden the prompt
- decide issue topology
- choose staffing and delegation budget
- open and close lanes
- enter root closure mode
- perform final integrated review
- decide final closure

## Bounded Agent Authority

A future bounded agent may:

- accept a bounded slice
- mutate only within its write scope
- run required validations
- perform self-review and self-forensic review
- return evidence in the required packet shape

## Bounded Agent Prohibitions

A future bounded agent must not, by default:

- decompose the work further
- change issue topology
- restaff the run
- claim final closure authority
- silently expand scope

## Accelerate-In-Agent Rule

Bounded agents may still carry `accelerate` as local execution discipline.

Inside bounded sessions, `accelerate` means:

- bounded classification of the assigned slice
- visible runtime state
- honest verification

It does not mean:

- executive routing
- issue topology control
- staffing authority
- closure authority
