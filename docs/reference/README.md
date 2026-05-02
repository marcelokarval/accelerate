# Reference Artifacts

This directory may contain local design-system or runtime reference artifacts.

Current inventory:

- `design-system.html`: sample/reference HTML artifact.

Expected generated design-system package shape may include additional files such
as:

- `design-system.contract.md`
- `design-system.theme.css`
- `design-system.premium-theme.css`
- `design-system.premium-direction.md`
- `design-system.slop-audit.md`

Those files are required only when a concrete extraction or premium package has
been generated for a target project. Their mention in doctrine describes the
required package shape, not proof that this repository root currently has an
active generated package.
