# Codex Skill Seeds

This directory is the versioned source for global capability skills used by
Codex and Hermes. It preserves the source package before it is exported to an
on-demand runtime catalog.

The root-level `skills/` directory remains the standalone `accelerate` product
surface. It owns the self-contained Accelerate workflow skills; this directory
owns only portfolio capability skills that are intentionally duplicated into
the global runtime catalogs.

## Files

| Path | Role |
| --- | --- |
| `skill-dependency-manifest.md` | Compact migration audit and pointers to standalone Accelerate registry truth. |
| `skills/` | Versioned source packages and registry for global capability skills. |

## Rule

Do not add a new global capability skill without registering it under
`skills/_registry/manifest.md`. Source packages are validated here before
export to Codex and Hermes.

The export policy is:

- capability packages are versioned source here;
- exported copies are equivalent runtime deployments, never authoring sources;
- every capability package is on-demand and must not preload at session start;
- standalone Accelerate workflow skills continue to be maintained at root
  `skills/`.
