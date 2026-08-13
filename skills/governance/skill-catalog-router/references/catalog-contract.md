# Catalog Contract

## Authority

The source set is the repository's regular `skills/*/*/SKILL.md` files plus
`global-runtime/accelerate/SKILL.md`. Runtime paths are deployment targets; the
corresponding source file supplies the expected bytes and SHA-256.

## Index Row

Each tab-separated row contains exactly:

1. unique skill ID;
2. repository-relative source `SKILL.md` path;
3. absolute expected runtime `SKILL.md` path;
4. lowercase SHA-256 of the source bytes;
5. normalized frontmatter description.

Rows are sorted by skill ID. Descriptions contain neither tabs nor newlines.

## Failure Rules

Generation and checking fail when:

- a source path escapes the repository after symlink resolution;
- a skill ID is empty, disagrees with its directory, or is duplicated;
- a source file is missing or not regular;
- an indexed source path, runtime path, digest, or description is stale;
- the index has a missing, additional, malformed, or duplicate row.

Runtime resolution additionally fails when the deployed file is absent,
unreadable, outside its expected runtime root, or does not match the indexed
digest. No fallback catalog is authorized.
