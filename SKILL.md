---
name: accelerate
description: Classify requests and prepare context. Handle conversation and trivial work directly; hand non-trivial work to spec-driven-superpowers (ASDS), which owns its process.
metadata:
  category: routing
  origin: standalone-native-router
---
# Accelerate

Accelerate is the entry layer before spec-driven-superpowers (ASDS). It identifies
intent, project, constraints, and risk, then selects the owner of the work. It
neither absorbs ASDS nor runs a second planning and acceptance process around it.

## Responsibilities

| Responsibility | Owner |
| --- | --- |
| Understand the request, preserve language and existing authorization, classify and prepare context | Accelerate |
| Respond to conversation and execute trivial bounded work with relevant verification | Accelerate |
| Decide whether and how to activate a structured workflow after handoff | ASDS |
| Specification, planning, task dependencies, execution strategy, review, integration and completion of accepted work | ASDS |
| Tools, actual permissions and execution isolation | Host harness |
| Domain knowledge and technical guidance | Relevant reusable skills |

The repository owns Accelerate's routing contract. ASDS owns its own workflow;
it is an independent dependency, not imported doctrine that Accelerate overrides.
Generated runtime projections must reproduce this division. Historical workflow
material in this repository is reference material, not automatically active
policy. Project instructions and the user's actual authorization still apply.

## Entry and Routing

1. Read the request and available context; preserve the user's language.
2. Identify the intended project only when the task needs one. Do not create
   folders, issues, specifications or configuration merely because this skill is
   globally available.
3. Identify ambiguity, affected surfaces, sensitive effects and existing
   constraints. Ask only about missing information needed to proceed. Do not
   create a detailed plan or repeat approvals before handing off.
4. Choose one route using [the routing matrix](core/control-plane/branch-enforcement-matrix.md):
   - **conversation**: respond directly; no engineering workflow;
   - **direct**: trivial, understood, bounded, reversible, low-risk work;
   - **asds**: non-trivial work or an explicit request to use ASDS.
5. Execute the direct route with proportionate verification, or pass the context
   to ASDS and transfer process ownership. Report actual results and limitations.

Apply [the entry rubric](core/entry-rubric.md) before choosing a route. Classify
the requested action, not topic words. Inspect/edit/test are operations for one
outcome, not dependent deliverables. Require evidence and a concrete consequence
for material risk. Length, file count and routine verification do not imply
complexity. A one-line access-policy change can still be non-trivial.

Resolve only entry-blocking gaps: inspect available facts, ask for a missing user
choice, or carry design decisions to ASDS when the route is already clear.
Hardening preserves objective, target, constraints, uncertainty and prior decisions;
it does not create a plan, mandatory artifact or another approval round.

## Handoff to ASDS

Pass the objective, intended project, scope, constraints, identified risks,
references, and existing authorization decisions with their source. Preserve
refusals and scope limits as well as approvals. Missing authorization stays
missing; silence, availability of a tool, routing, and elapsed time do not grant it.

ASDS decides activation and workflow depth. Handoff does not automatically
initialize `openspec/`, create an issue, allocate agents, or start mutations.
Accelerate does not force `.accelerate/`, a second task graph, a review cycle,
or approval after ASDS has completed the work. Relevant project requirements
remain applicable regardless of which component conducts the task.

If ASDS is unavailable, report that fact. Continue independent conversation or
read-only discovery where useful; do not claim ASDS ran or silently replace it
with Accelerate's historical orchestrator. A different execution workflow needs
an explicit user choice. Do not reclassify risky work as trivial to bypass the
missing dependency.

For resumed work, reuse the existing ASDS state and authorization context. Do
not restart planning or route an ASDS-owned task back through Accelerate.

## Technical Skills and Evidence

Use specialized skills only when they help the current task. Loading a technical
skill does not load Accelerate's historical issue, workspace, delegation or
closure requirements. ASDS selects useful technical guidance for its own tasks;
the harness enforces execution permissions.

For direct work, run relevant checks and report what they establish. For ASDS
work, present the result, evidence and unresolved limitations returned by ASDS
without treating an unverified claim as observed execution or opening a second
acceptance process.

## Executable Contract

[`core/entry.py`](core/entry.py) applies the evidence-labelled rubric and returns
respond, inspect, ask, execute_direct, handoff or continue_asds. It preserves
ASDS ownership during continuation. [`core/routing.py`](core/routing.py) classifies explicit structured observations
and validates the handoff fields. It performs no model inference, installation,
filesystem mutation, ASDS invocation or authorization enforcement. A host adapter
must supply observations and deliver accepted handoffs; this module alone does
not demonstrate runtime integration.

Run `python3 -m unittest discover -s tests -p 'test_routing.py'` to verify routing,
malformed inputs, preserved authorization decisions and absence of implicit
workflow activation.
