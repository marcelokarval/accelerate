# Repo-Managed Skill Seeds

This directory is the versioned source for global capability skills. Each
package is authored and validated here before equivalent copies are exported to
the Codex on-demand catalog and to `~/.hermes/skills`.

It is intentionally separate from `../../../skills/`, which remains the
standalone `accelerate` product surface and control-plane skill source.

Capability skills are not mandatory branch-routing law. They must remain
on-demand and must not preload into Codex or Hermes session startup.

Register every package in:

- `_registry/manifest.md`

## Current Capability Packages

The package register is deliberately compact. See
[`_registry/manifest.md`](./_registry/manifest.md) for placement and category.

## Operating Rule

Do not add capability packages to a runtime preload list. A runtime may expose
them through an on-demand catalog, but activation requires the task to match
the package trigger.

When a capability must become standalone Accelerate branch-routing or proof
law, model that separately beneath root `skills/` and the relevant control
plane; do not silently repurpose a global capability package.
