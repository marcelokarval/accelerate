# Skill Registry

The registry makes skill ownership explicit.

Use it to answer:

- which skills are locally owned
- whether any mandatory skill still remains external
- where a skill came from
- whether a skill is mandatory runtime law or an optional overlay
- how root `skills/` may be exported to an optional runtime target

Primary files:

- `manifest.md`
- `provenance.md`
- `sync-policy.md`
- `quality-skill-reviewed-snapshot.json`: fixed recursive file and SHA256
  fingerprints for the nine independently reviewed quality packages. This is
  package-integrity evidence, not proof of LLM behavior; intentional package
  changes require independent review before updating the repo-owned snapshot.
