# Accelerate repository instructions

Accelerate 1.x is the portable entry classifier and preparation layer before
spec-driven-superpowers (ASDS). This repository owns Accelerate, not ASDS.

## Authority and responsibilities

Read `SKILL.md` and `core/asds-integration.md`. These define current behavior.
Accelerate identifies intent, project, scope, constraints, risk and existing
permissions. Conversation and bounded low-risk work proceed directly. Other
engineering work that needs planning is handed to ASDS, which owns specification,
task decomposition, planning review, persistence and planning delivery. ASDS does
not implement future tasks; the caller selects a consumer after planning returns.

Do not reactivate the v0 orchestration procedure through a specialist skill,
legacy reference, runtime profile, workspace helper or generated projection.
ASDS is an independent dependency, not imported or absorbed into this repo.
System/developer/user instructions and applicable project rules remain binding.

## Work on this repository

Use proportional engineering and the user's authorized scope. No automatic
issue, `.accelerate/`, OpenSpec initialization, subagent count or worktree is
required by Accelerate. Existing authorizations must not be requested again.
Delegate when useful and supported; do not fabricate unavailable capabilities.
Do not install software, alter user-home exports or create backup/parallel
runtime copies as a side effect of source development or a release.

## Source and reusable capabilities

`core/routing.py` implements structured routing and handoff validation;
`SKILL.md` describes how an agent supplies the observations. The classifier is
not an LLM, permission authority, sandbox or ASDS execution engine.
`global-runtime/accelerate/` and runtime adapters distribute the entry behavior.
Specialist `skills/`, profiles, validators and optional tooling may be selected
for their bounded technical function. They never regain ownership of ASDS work.
Existing v0 workflow references are historical/optional material; their global
mandatory gates are superseded by the 1.x integration contract.

## Validation and release

Run `bash tests/all.sh` and `git diff --check` before publication. Report actual
results and runtime limits; source tests do not prove a live harness deployment.
Follow `docs/releases.md`: version branch, issue/milestone, reviewed PR, passing
CI, merge to main, immutable matching tag and GitHub release. `VERSION` is the
version authority. Never rewrite an existing release tag.
