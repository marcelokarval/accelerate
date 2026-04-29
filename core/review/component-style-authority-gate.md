# Component Style Authority Gate

## Purpose

Use this gate when visual defects are corrected in a codebase where component
source is available.

It prevents fragile global CSS selectors from becoming the default way to fix a
specific component that should instead own its own styling contract.

## Rule

If the component source is in scope and editable, fix the component or its owned
variant API before using brittle global selectors.

## Prefer

- component props or variant classes
- shared primitive variants
- feature-local visual variants
- token values at the owning theme layer
- semantic utility classes owned by the component family

## Avoid

- `[class*="..."]` selectors to target one component instance
- page-level overrides for shared component defects
- global theme selectors that depend on incidental class strings
- masking a bad component default with one-off CSS

## Allowed Exceptions

Global overrides are acceptable when:

- the component source is external and cannot be edited
- the override is a documented compatibility shim
- the selector targets a stable data attribute or public API
- the branch records why the owner layer cannot be changed

## Acceptance Standard

The branch can answer:

- which layer owns the visual defect
- why the chosen fix belongs there
- whether a brittle global selector was avoided or explicitly justified
- what screenshot proves the corrected component state
