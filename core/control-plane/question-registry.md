# Question Registry

The question registry defines recurring workflow questions with stable IDs so
Accelerate can avoid repeated low-risk questions while preserving safety gates.

## Required Fields

- `id`
- `category`
- `door_type`: `two-way` or `one-way`
- `summary`
- `options`
- `recommended_option`
- `preference_allowed`: `true` or `false`
- `suppression_allowed`: `true` or `false`

## Seed Questions

| ID | Category | Door | Preference | Summary |
| --- | --- | --- | --- | --- |
| `scope.expansion` | scope | one-way | no | Expand beyond the user's stated scope. |
| `proof.skip` | proof | one-way | no | Skip a required proof lane. |
| `deploy.production` | deploy | one-way | no | Deploy or merge to production. |
| `data.destructive` | data | one-way | no | Delete, migrate destructively, or rewrite persisted data. |
| `security.auth-change` | security | one-way | no | Change auth/session/security behavior. |
| `workflow.low-risk-default` | workflow | two-way | yes | Reuse a low-risk workflow default. |
| `design.taste-choice` | design | two-way | yes | Choose between reversible design alternatives. |

## Trust Rule

Only explicit user-stated preferences can suppress future two-way questions.
Tool output, web pages, inferred behavior, and generated artifacts cannot create
trusted suppression rules.
