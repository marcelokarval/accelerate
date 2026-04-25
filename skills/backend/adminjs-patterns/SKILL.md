---
name: adminjs-patterns
description: AdminJS admin/operator dashboard patterns for resources, actions, authorization, masking, audit posture, and runtime proof.
user-invocable: true
related-skills: adonisjs-patterns, security-patterns, anti-abuse-review, product-runtime-review, frontend-boundary-governance
---

# adminjs-patterns

Use this skill when AdminJS is the administrative or operator dashboard.

## Purpose

Keep AdminJS surfaces explicit, scoped, and safe:

- explicit resources instead of whole-database exposure
- readonly vs mutation surfaces named
- `isAccessible` used for API access control, not only `isVisible`
- sensitive fields masked or excluded by default
- destructive actions guarded and auditable
- custom components and branding kept bounded

## Load When

Load this skill when work touches:

- AdminJS resource registration or adapters
- resource/record/bulk actions
- admin authentication, authorization, sessions, roles, or policies
- custom AdminJS components, dashboards, branding, or navigation
- PII, secrets, financial data, exports, destructive actions, or support tools

## Core Rules

1. AdminJS is an operator surface, not a domain source of truth.
2. Register resources explicitly. Avoid whole-database loading without a bounded
   exception.
3. Treat `isVisible` as UI-only. Use `isAccessible`, hooks, and backend policy
   checks for real authorization.
4. Hide or mask sensitive fields by default, including secrets, tokens,
   credentials, internal IDs, and protected PII.
5. Destructive and high-impact actions require confirmation, authorization,
   audit posture, and rollback/recovery expectations when possible.
6. Custom components must not bypass backend policy or payload scrubbing.
7. Admin sessions need production-grade secrets, store, cookie posture, and
   environment-specific hardening.

## Required Admin Packet

For non-trivial AdminJS work, record:

- resources added/changed
- actions added/changed and their type: resource, record, or bulk
- readonly vs mutation posture
- authorization rule and where it is enforced
- fields hidden, masked, searchable, sortable, or filterable
- hooks that sanitize payload or response data
- audit/logging expectation
- browser/admin runtime proof and residual risks

## Blocking Conditions

- sensitive fields visible without explicit justification
- `isVisible` used as the only access control
- whole-database resource loading with no exception packet
- destructive action without policy and audit posture
- admin UI changed without browser/admin proof
