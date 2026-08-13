# Claim And Evidence Matrix

## Claim Types

| Claim type | Preferred authority | Useful corroboration |
| --- | --- | --- |
| repo policy or accepted decision | repo-local governing instruction, ADR, accepted SDD | enforcement test or current implementation |
| actual current behavior | controlled reproduction, test, runtime observation | implementation source and diagnostics |
| public API or platform contract | version-matched official specification/docs | official source code, changelog, contract fixture |
| dependency capability/compatibility | versioned upstream docs/source and release notes | minimal reproduction in the active environment |
| security behavior | official advisory/specification and affected source | safe negative reproduction and independent advisory |
| performance/benchmark | disclosed method, environment, raw measurement | repeat measurement under comparable conditions |
| recommendation | explicit constraints and decision criteria | independent evidence from the target environment |

Search result snippets, uncited summaries, popularity, repository stars, and
model-generated prose may locate sources but do not by themselves verify a
material claim.

## Applicability Questions

For every source ask:

1. Is this source authoritative for the exact claim?
2. Does it cover the active version, platform, configuration, and date?
3. Is the quoted evidence direct or an inference?
4. Does local observed behavior agree with the normative source?
5. Is corroboration independent or merely repeating the same origin?
6. What credible evidence would falsify the conclusion?

Use the closest local authority for repository decisions. External best
practice informs a decision but does not silently replace accepted local rules.
