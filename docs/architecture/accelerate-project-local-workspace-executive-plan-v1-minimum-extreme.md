# `.accelerate/` Executive Plan V1: Minimum Extreme

## Purpose

Define the absolute minimum project-local installation of `accelerate`.

This version exists to answer one question:

- what is the smallest persistent local footprint that still gives `accelerate`
  a truthful per-project anchor?

## Intended Use

Use `V1` when:

- the project is extremely early
- adoption friction must be close to zero
- the team only wants minimal persisted state at first
- the main need is to know whether onboarding happened and what the current
  local posture is

Do not use `V1` as the long-term preferred model if the repo is already doing
real planning and repeated execution under `accelerate`.

## Scope

`V1` persists only:

- whether the project was onboarded
- the current stage of local `accelerate` installation
- the current high-level posture of workflow/profile/runtime/agents

## Target Shape

```text
.accelerate/
├── README.md
└── state.yaml
```

## Required Files

### `.accelerate/README.md`

Human-facing explanation of:

- what this folder is
- what is authoritative here
- what is not authoritative here
- what later sessions should read first

### `.accelerate/state.yaml`

Machine- and human-readable local state summary.

Minimum suggested schema:

```yaml
schema_version: 1
accelerate_stage: standalone-pre-agents
project_onboarded: true
installation_mode: greenfield|adoption
repo_maturity: empty|early|existing|mature
onboarding_status: not_started|in_progress|partially_stabilized|completed
reentry_status: clean|light_reentry|partial_reonboarding|structural_reonboarding
workflow_backend: none-yet|github|github-projects|linear|jira|notion
active_profile: unknown|django-inertia-react|nextjs-tailwind|nextjs-prisma|nextjs-drizzle|nextjs-adonis-adminjs
agent_mode: root-only|agent-eligible
last_bootstrap_update: YYYY-MM-DD
```

## Benefits

- almost no setup cost
- extremely easy to explain and audit
- enough state for a future session to know whether onboarding already exists
- safe starting point for repos that are still deciding whether deeper local
  persistence is worth it

## Limitations

`V1` does not persist:

- discovery details
- onboarding decisions in detail
- executive plan artifacts
- local agent candidates or gaps
- execution handoff artifacts

This means `V1` is good as a floor, but weak for sustained project continuity.

## Lifecycle Rule

If the project starts using:

- repeated executive plans
- repeated onboarding adjustments
- local agent-gap reasoning

then `V1` should be upgraded to `V2`.

## Autonomy Rule

`accelerate` may create and update `V1` autonomously when:

- onboarding is clearly real
- enough factual signals exist to fill `state.yaml`
- no deeper plan artifacts have been produced yet

## Success Criteria

`V1` is successful when a fresh session can answer quickly:

- has this project already been onboarded?
- what is the current local stage?
- what is the current workflow backend posture?
- are we still root-only?
