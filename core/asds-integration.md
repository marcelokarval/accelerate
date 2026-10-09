# Accelerate before ASDS — integration v1

## Ownership

Accelerate owns entry classification and initial preparation. ASDS owns only the
planning lifecycle it accepts: elaboration, specs, task decomposition, planning
review, persistence and planning return. It does not implement future tasks.
The harness executes tools and enforces permissions. Neither product can grant
permissions on behalf of the user or override project/system instructions.

Conversation bypasses engineering workflows even inside an initialized project.
Trivial engineering proceeds directly with relevant verification. Sensitive,
irreversible, materially uncertain or dependent-outcome engineering is forwarded to ASDS for planning; a short
request or small diff is not evidence of low risk. Explicit ASDS requests route
to ASDS even when small. No setup, issue or artifact is created by classification.

## Handoff

Use the structured handoff validated by `core/routing.py`: objective, intended project,
scope, constraints, risk observations, existing authorization/refusal records and
relevant context references. Preserve the user's language. Unknown target or
missing facts remain unknown; clarify only when they block the next step. Do not
turn classification into a duplicate specification or plan.

Authorization records report previously expressed decisions and their scope.
Validation proves structure only, not provenance, current permission or consent.
The consumer must consult the session and harness authority. Silence is never
permission. Refused OpenSpec initialization does not mean the task is refused.

ASDS decides whether to initialize/use OpenSpec and which planning depth is
appropriate. It consumes existing permissions and project configuration without
repeated setup questions. This document does not modify ASDS implementation or
promise an ASDS receiver for Accelerate's reference JSON format.

Discovery limits travel in the existing `constraints` and `references` fields;
no new handoff field is required. Accelerate identifies the intended project and
necessary sources. Unrelated logs, sibling projects and evaluation evidence are
not task context merely because they are readable. ASDS preserves these limits
after acceptance and evaluates any concretely justified expansion itself.

## Continuation and return

Once ASDS accepts planning, follow its planning progress and state. Do not run Accelerate's
classifier again on every planning subtask, create another task graph, mandate a
second review, or reopen completed approvals. A materially changed goal, target,
risk or permission requires reassessment of the affected work, not an automatic
restart. Preserve accepted work and relevant evidence on resumption.

ASDS returns planning outcome, evidence references, remaining planning work and
limitations, then releases ownership. If implementation was originally requested,
the caller selects its consumer; ASDS planning delivery does not fulfill it.
Accelerate may present that result in the user's language, attributing it to the
workflow. Presentation does not constitute another acceptance/closure gate.
A returned claim is not proof of live runtime health or deployment.

## Availability

If ASDS cannot be loaded through the actual harness, report that fact. Continue
independent read-only discovery when useful. Do not silently run the old
Accelerate orchestrator, invent an ASDS result, initialize OpenSpec, or downgrade
risky work to trivial. A user-selected alternative workflow must be explicit.
Conversation and genuinely trivial work do not depend on ASDS availability.

## Optional technical resources

Specialist skills may contribute design, security, stack expertise and checks.
They cannot transfer lifecycle ownership back to Accelerate. Legacy words such
as root, mandatory, Done and orchestrated inside optional v0 procedures apply
only to their historical workflow; they impose no default 1.x obligation.
Project-specific requirements remain binding regardless of this retirement.

## Compatibility and scope

The v1 structured routing API is additive tooling for adapters; agent/harness
behavior follows `SKILL.md`. ASDS runs independently and no dependency is copied
into Accelerate. Existing source-only adapters are not certified deployments.
No automated host installation, migration, backup or worktree creation belongs
to classification or handoff.
