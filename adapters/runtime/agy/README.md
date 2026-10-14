# Antigravity CLI entry plugin

This directory is the source-owned, self-contained Accelerate entry plugin for
Antigravity CLI 1.3.3. It bundles a selectable primary agent, the progressive
Accelerate skill, lifecycle hooks, the pure classifier, and the scripts needed
to produce session-bound routing receipts. It does not bundle or absorb ASDS.

The bundle follows the native AGY plugin layout and validates through the
official CLI:

```sh
agy plugin validate adapters/runtime/agy
```

Source validation proves that AGY accepts the manifest, skill, agent, and hooks.
It does not construct the custom-agent executor and therefore does not prove
that every named tool exists in the runtime registry. Earlier AGY 1.3.2 live resolution
showed that `list_permissions` is unknown and `multi_replace_file_content` is a
deprecated empty component; neither is declared by this agent.

## Invocation and literal prompt preservation

Select the entry agent independently from the prompt. Do not prepend its system
instructions to the user's text:

```sh
agy --agent accelerate-entry --print "$PROMPT" --sandbox \
  --model gemini-3.1-pro-high --mode accept-edits --print-timeout 30m
```

`--agent accelerate-entry` selects the system contract; `$PROMPT` remains the
literal user prompt. Installing or enabling the plugin does not silently replace
the default agent. A caller that omits `--agent` has not proved entry enforcement.

## Enforcement flow

1. `PreInvocation` creates mode-`0700` state under
   `~/.gemini/antigravity-cli/accelerate-entry-state/<conversation-id>` and
   injects the short classifier protocol. The nonce and receipts do not live in
   the workspace or model-visible artifact directory.
2. Before a receipt, `PreToolUse` recognizes only the exact source-owned
   classifier carrier. It decodes, validates, and classifies inside the hook,
   atomically writes the receipt, and intentionally returns `deny` for the
   carrier with a structured `classification completed` context encoded in the
   documented `reason` field. The shell never
   executes the marker, no `PostToolUse` is needed, and a same-token retry reads
   back the existing result without rewriting it.
   If the decoded value is an object but its model-produced envelope is missing
   fields or uses free text/wrong shapes, the hook normalizes it conservatively
   to engineering with an explicit inspect gap. Signed warning codes describe
   the normalization without copying request text, and the returned context
   supplies exact signal/gap schemas plus a valid ASDS example. Ambiguous
   envelopes can never select `direct` or `asds`; invalid base64, non-JSON, and
   non-object values remain denied without a receipt.
3. The in-hook classifier calls the vendored byte-identical `core/entry.py` and
   `core/routing.py`, then writes an HMAC-protected receipt bound to conversation
   ID, canonical artifact and transcript paths, workspace paths, current
   classification invocation as audit metadata, the last
   `USER_EXPLICIT`/`USER_INPUT` entry, observation, classifier hashes, route,
   and a one-hour lifetime. A new user turn invalidates the old receipt;
   another model invocation continuing that same turn does not.
   A first-pass `direct` engineering assessment is reduced to `inspect` until a
   successful current-turn workspace read is host-recorded; the next observation
   and receipt bind that inspection digest before direct work can be admitted.
4. `PreToolUse` applies the selected route. `PostToolUse` appends completed
   inspect reads to a closed, HMAC-bound collection without erasing the read-only
   route. Up to 32 reads may collect bounded facts; mutation and delegation remain
   denied until a bound reclassification replaces the inspect receipt after
   relevant evidence exists. When inspection finds one delivered or safely
   repairable ASDS lineage, that denial includes a short opaque
   `accelerate-entry continue <TOKEN>` capability. The private HMAC-bound carrier
   preserves the originally signed observation and fixes its inspect receipt,
   complete inspection ledger, lineage and user turn; it is atomically consumed
   once, so replay, tampering, turn changes, or later drift cannot create
   authority. `Stop` records termination and requests at most one
   bounded continuation for missing classification or evidence-backed
   reclassification; a second Stop terminates with the same deterministic next
   action instead of looping. If private state cannot be validated, `Stop`
   terminates immediately and requires a fresh `PreInvocation`; it never emits
   an uncounted continuation that stable corruption could repeat forever.

For an observation with `explicit_asds: true`, `requested_product: planning`,
and `inspect` in `operations`, the inspect route is additionally phased and
host-directed. The classification context publishes an
`accelerate-agy-canonical-asds-inspection/1` object with exact
`requiredTargets` and `nextAllowedCalls`. Existing root `AGENTS.md`, the exact
`.asds/accelerate-handoff-capability.json`, and the bounded
`openspec/changes` directory listing must be observed before package selection.
Only exact `view_file`, `list_dir`, and bounded `find_by_name` calls published in
that object are admitted; arbitrary docs/tasks, grep, traversal, symlink aliases,
and extra arguments do not enter the inspection ledger.

For each completed inspect read, the private ledger records the canonical
governed workspace path and a digest of the observed file or bounded directory
listing. Every retained entry is revalidated and the whole collection is bound
to the session seed; malformed, stale, replayed or MAC-invalid state fails
closed. Generic lineage discovery considers all valid retained reads, so a later
irrelevant read cannot erase earlier package evidence. The explicit ASDS planning
protocol is stricter: existence or uniqueness never selects a package. The agent
must actually read both `planning-manifest.json` and `tasks.md` for the one direct
child candidate. Zero or multiple direct-child packages, unsafe inventory, and
relevance ambiguity remain blocked for user resolution rather than being guessed.
Other inspect routes may still associate a package through an observed package
path or task `write`/`resources` linkage; ambiguity, unsafe paths and symlinks
remain denied.
Only then may reclassification scan at most 128 direct children of
`openspec/changes/`. A prior package is lineage only when exactly one package
links that governed path from task `write`/`resources`, carries the ASDS-owned
`planning-manifest.json` delivery authority, and passes closed delivery, reference
hash, PASS review, matched readback, no-blocker, and no-execution checks. Both
documented `asds.planning-return/1` and `/2` variants are accepted; destination
locators must be relative, canonical, and resolve to the package inside the
workspace. For a reference with `role: index`, the digest uses ASDS's conservative
index projection: only `[ ]`, `[x]`, or `[X]` state on task-shaped entries is
normalized. Title, link, text, order, blockquotes, fenced content, frontmatter,
HTML-bearing documents, and non-task checkboxes remain byte-sensitive. The resulting
route is `asds` with `next_action=handoff`, never model-derived
`continue_asds`; the private receipt retains only canonical package ID, path, revision,
and aggregate digest. Invalid, drifted, symlinked, unlinked, or multiple package
evidence normally remains `inspect`. One narrow recovery exists: when the
structured observation already requests ASDS/planning, the capability is valid,
and exactly one safely located package links the governed path but fails delivery
integrity, the hook may issue a signed repair handoff. The private receipt binds
the canonical absolute path; the model-visible handoff contains only a derived
`openspec/changes/<packageId>` relative path, directory-derived ID, and a fixed repair reason. It
excludes the package's untrusted revision, digest, review and readback claims.
Unsafe paths, symlinks, ambiguous/multiple matches, invalid capability, and
non-ASDS observations remain blocked.

Dispatch also requires an ASDS-owned project-local identity capability at
`.asds/accelerate-handoff-capability.json` with schema
`asds.accelerate-handoff-capability/1`, exact `typeName`, nonempty `asdsVersion`,
`planningOnly: true`, `writesApplicationCode: false`,
`futureTaskExecution: false`, and a safe `agentRelativePath` whose current bytes
match `agentSha256`. The accepted key set is exact. It mirrors the ASDS source
contract documented in
`skills/spec-driven-superpowers/references/adapters/antigravity.md` and tested by
`tests/agy-agent.test.js`; those source paths are provenance, not a runtime
dependency. Accelerate
consumes this marker but does not create, install, or own it. Its absence,
ambiguity, linked path, agent drift, or marker drift blocks promotion and dispatch.
The current ASDS project AGY profile publishes this marker together with its
manifest-bound coordinator. A future host-owned active coordinator-acceptance
receipt is still required before `continue_asds` can exist.

For an admitted ASDS route the hook returns the exact canonical handoff Prompt
in the classifier reason and signs its SHA-256 in the receipt. For delivered
lineage the Prompt embeds the current literal user request as JSON plus package
ID, derived project-relative path, revision, and digest. For repair it embeds the literal
request and locator only, instructing ASDS to validate and republish planning
state without application writes. Package IDs and revisions use a bounded
lowercase ASCII locator grammar. The prompt declares that only
`currentUserRequest` carries instructions; every lineage/repair value is inert
data. Absolute workspace/package paths never enter the model-visible prompt.
`invoke_subagent` is admitted only for one exact
`TypeName: spec-driven-superpowers`, `Role: planner`, and byte-identical Prompt;
extra text, changed locators, or implementation wording are denied. AGY 1.3.3
may add only its native outer `toolAction` and `toolSummary` string metadata,
plus optional outer `Model: "inherit"`. Its coordinator item may likewise carry
only redundant `Model: "inherit"` and `Workspace: "inherit"`; literal paths,
URIs, aliases, other models, and other types are denied, so these fields cannot
select a provider or workspace. The outer text fields are bounded and all native
metadata is non-authoritative. Missing
`Subagents`, unknown/confusable outer keys, nested values, wrong types and
oversized metadata fail closed before the exact inner item is considered.

An observation whose `operations` includes `inspect` cannot hand off merely
because `explicit_asds` is true. It remains on the read-only inspect route until
current-turn evidence is recorded and an exact host-issued continuation is
consumed. That continuation preserves the signed observation and must bind one validated delivered lineage or safe repair
locator; it cannot produce a null-lineage handoff. An ASDS observation that does
not request inspection retains the intentional new-package handoff with null
lineage.

The parent handoff is one-use. Successful parent `PostToolUse` creates a private,
HMAC-bound terminal return state before later receipt or inspection-ledger
revalidation. Every subsequent tool, message, delegation, read, or classifier
carrier is denied with one unequivocal `end_response` context; `Stop` allows
termination without continuation or retry. This prevents a child planning write
from turning the parent's earlier inspection digest into a reclassification
loop. For a repair locator, the hook may later expose a host-owned readback only
when the manifest bytes are unchanged and the candidate plus every reference
match the pre-dispatch reviewed inventory under the same index canonicalization.
It creates no revision and does not fabricate a review. Otherwise the readback
remains null while the terminal state still applies.

The spawned coordinator is admitted without reclassifying its initial
`SYSTEM_MESSAGE` only through a host-owned transfer chain. The child UUID,
agent type, planner role, spawn step and workspace must match one unique native
descriptor under the parent brain. One unique native child message must bind
sender, recipient, byte-exact canonical Prompt and the exact
`invoke_subagent` arguments to the same parent step. The parent private HMAC
seed/receipt, one-use coordinator reservation and successful same-turn
`PostToolUse` record must all remain current. Regular-file type, owner, mode,
link count, path components, closed schemas, TTL and replay checks are
revalidated before each child tool. A private HMAC claim is created atomically
and the child receives the neutral `admitted_asds_coordinator_child` route;
unqualified payload fields such as `parentConversationId`, `agentName`,
`callerContext` or `result` convey no authority. Initial descriptor/message or
parent-Post races produce a deterministic retry denial. Arbitrary
`SYSTEM_MESSAGE` sessions remain blocked. The initial transcript wrapper is
reconstructed byte-for-byte from the already validated native message timestamp
normalized to its AGY-rendered UTC-second form, sender, exact high priority and
content; its `created_at` must identify that same second. Changed wording,
ordering or extra text is rejected. A descriptor is considered before any
apparent `USER_INPUT`, so transcript substitution cannot promote a child into a
root session. The native message inventory and exact initial wrapper remain
revalidated; later unbound system/user messages invalidate admission.

The admitted child is planning-only at the hook boundary. Native reads remain
workspace-bound. Writes are limited to the closed ASDS/OpenSpec artifact grammar
inside the package locator frozen by delivered lineage or repair. Without such a
locator, a first write may atomically claim only a new canonical
`openspec/changes/<safe-id>` package; an existing package can be claimed only
after a successful read identifies it as the unique safe package. Application,
repository-control and sibling-package writes, permission expansion, messages,
subagent management, browser/MCP and unknown tools are denied. `run_command`
also remains denied because the installed ASDS capability currently publishes no
closed host-enforced planning-validator command template. The original parent
package digest is checked before transfer; after the HMAC claim, package bytes
may change transactionally while the parent turn, capability, prompt, descriptor,
native message, transcript, reservation and successful dispatch remain bound.
Arbitrary nested delegation and the still-unqualified independent-review dispatch
remain denied.

| Route | Tool admission |
| --- | --- |
| `conversation` | No post-classification tools |
| `ask` | No post-classification tools; ask in the response |
| `inspect` | Workspace-bound read-only tools, bounded to 32 successful reads; after evidence identifies ASDS lineage, only the short host-issued, HMAC-bound, one-use continuation may apply the preserved signed observation |
| `asds` | Requires current project-local ASDS capability; workspace-bound read-only discovery and exactly one `invoke_subagent` item with the signed byte-exact TypeName/Role/Prompt handoff; delivered lineage uses `handoff`, while `continue_asds` remains unavailable without a future host-owned acceptance receipt; the entry agent never persists planning or application code |
| `direct` | Available only after current-turn inspect evidence and reclassification; bounded file tools and a narrow submitted-command grammar; agent/orchestration CLIs, explicit network clients/targets, shell control, scheduling, and permission expansion are rejected before execution |

The receipt proves only that structured classification executed against a local
session seed. It cannot prove that the model extracted the right observations,
that the user authorized an action, that ASDS accepted a handoff, or that a
software correction works.
Unknown state files, stale or cross-session receipts, changed classifier hashes,
invalid paths, and internal `PreToolUse` errors produce a protocol-valid denial.
A textual claim that classification ran, or receipt-shaped text without the
HMAC state held outside the workspace, is not a receipt.

AGY 1.3.3 preserves the observed `artifactDirectoryPath` contract as the exact
`~/.gemini/antigravity-cli/brain/<conversation-id>` root. The accepted
`transcriptPath` identifiers are limited to that conversation's compact or full
JSONL log, or `~/.gemini/antigravity-cli/conversations/<conversation-id>.db`.
Regardless of the identifier, current-turn binding is always read from the
derived compact `.system_generated/logs/transcript.jsonl`; cross-conversation,
arbitrary, or symlinked identifiers fail closed.

## Official install, update, and uninstall

The lifecycle helper is preview-first. It invokes only AGY's official
`plugin validate`, `plugin install`, and `plugin uninstall` operations on apply;
it never copies a parallel runtime or creates a backup.

Fresh install preview and apply:

```sh
python3 -I -B scripts/manage-agy-plugin.py --operation install
python3 -I -B scripts/manage-agy-plugin.py --operation install --apply \
  --expect-plan-sha256 APPROVED_PLAN_SHA256
```

Update and uninstall require the exact currently installed tree hash reported by
the diagnostic:

```sh
python3 -I -B scripts/manage-agy-plugin.py --operation update \
  --expect-installed-tree-sha256 CURRENT_TREE_SHA256
python3 -I -B scripts/manage-agy-plugin.py --operation uninstall \
  --expect-installed-tree-sha256 CURRENT_TREE_SHA256
```

Repeat the approved command with `--apply --expect-plan-sha256 ...`. AGY 1.3.3
has no observed atomic update command, so update validates the source and then
runs official uninstall/install. A crash between those commands can leave the
plugin absent. The helper reports this instead of maintaining an unofficial
backup or staging runtime.

Successful installation reads back every file under the official AGY 1.3.3
location `~/.gemini/config/plugins/accelerate-entry`, verifies exactly one
matching `source: antigravity` record in `import_manifest.json`, and verifies
the boolean enablement in `config.json`. Update preserves `enabled: false`.
Successful uninstall verifies tree and registry absence. The helper binds the
resolved executable identity, bytes, and exact `1.3.3` version during preview,
then revalidates them and the installed tree immediately before mutation.

### Required post-install executor smoke

After an authorized official install, run a fresh, bounded session that selects
the agent explicitly:

```sh
agy --agent accelerate-entry --sandbox --print-timeout 2m \
  --print "Responda apenas ok depois de aplicar a classificação de entrada."
```

A successful response proves that AGY constructed the custom-agent executor and
ran its hooks. This smoke creates a normal AGY conversation and may use the
configured model/provider, so it is a post-install runtime check, not a source
test and not part of this repository-only change. A provider/authentication
failure after executor construction is separate evidence; any
`failed to construct executor`, `unknown component`, or `empty component` message
is a plugin/runtime failure and blocks promotion.

## Hash-bound migration from the loose adapter

The supported global plugin location is
`~/.gemini/config/plugins/accelerate-entry`. Previous loose adapters may have
left non-plugin skills at `~/.gemini/antigravity-cli/skills/accelerate/SKILL.md`
or `~/.gemini/config/skills/accelerate/SKILL.md`, plus a managed block in
`~/.gemini/GEMINI.md`. When any exists, plugin installation refuses cleanup
until the operator supplies the exact reported hashes:

```sh
python3 -I -B scripts/manage-agy-plugin.py --operation install \
  --cleanup-native-loose-skill-sha256 CURRENT_NATIVE_SKILL_SHA256 \
  --cleanup-config-loose-skill-sha256 CURRENT_CONFIG_SKILL_SHA256 \
  --cleanup-loose-rule-sha256 CURRENT_MANAGED_BLOCK_SHA256
```

Cleanup occurs only after official installation and exact plugin-tree readback.
The loose skill is deleted only if its bytes still match. Only the exact managed
rule block is removed; owner bytes and file mode are preserved. Empty leaf skill
directories are removed, but parent configuration trees and unrelated files are
never deleted. No backup is retained. The old `scripts/install-agy-entry.py`
remains only for recognizing and auditing legacy loose state; it is not the
installation method for this plugin.

## Tests

```sh
python3 -m pytest -q tests/test_agy_plugin.py
python3 -m pytest -q tests/test_agy_entry_install.py
```

The adversarial tests use temporary homes and artifact directories. They cover
the first tool, immediate prompt injection, internal hook errors and invalid
stdin, cross-session/stale/tampered receipts, traversal and symlinks, route
permissions, inspect reclassification, Stop behavior, official lifecycle
readback, and hash-bound loose cleanup.

## Real AGY 1.3.3 limits

- The entry hook can qualify and dispatch the byte-exact top-level ASDS
  coordinator handoff. It cannot qualify ASDS's nested independent-review
  dispatch on AGY 1.3.3. The installed 1.3.3 binary's protobuf surface contains
  `agentName`, `parentConversationId`, `callerContext`, `rootConversationId`,
  `PostToolUse.toolCall`, `PostToolUse.result`, and shallow pre-tool overwrite.
  Its embedded official lifecycle-hooks guide still documents neither nested
  caller fields nor post-tool result bytes, however, and binary reflection alone
  does not establish their trust semantics, command-hook delivery, or a canonical
  reviewer-response encoding. Hooks are
  also separate short-lived processes, while the ASDS authority and freshness
  contract is process-local and one-use. The hook verifies the ASDS v3 install
  manifest, reviewer, protocol module, static dispatch contract, and request
  wire envelope when such a call is observed, then denies it. It never emits a
  synthetic `agy-host-hook` receipt. Independent planning review therefore
  remains blocked until AGY exposes a host API that can attest the caller and
  bind the exact response. ASDS's explicit `runtimeHostStatus: unavailable`
  discovery fact is consumed as a denial condition, never as authority.

- Official hook documentation specifies hook JSON contracts but not a guarantee
  that a crashed, timed-out, or invalid-stdout hook denies the pending tool. The
  script converts its own `PreToolUse` errors to a valid `deny`; process death
  remains host behavior and cannot honestly be called fail-closed without a live
  runtime qualification.
- `PostToolUse` runs after the action. The AGY 1.3.3 embedded guide supplies only
  the step index and error, while the compiled protobuf also has `toolCall` and
  `result`; until live command-hook qualification proves their delivery and
  encoding, the hook can bind only
  session, turn, and step. If the host returns `toolCall`, its `{name,args}`
  projection must match the admitted call. The implementation also keeps an
  internal, unit-tested submitted-versus-expected projection for a possible
  shallow argument overwrite. AGY 1.3.3's embedded guide documents that overwrite
  as a supported shallow top-level merge, but no live end-to-end qualification
  is claimed and the classifier does not use or depend on overwrite. The hook
  cannot undo an effect or independently prove which arguments ran when the
  PostTool call payload is absent.
- `run_command` is admitted only for a conservative submitted-command grammar
  of test runners and read-only Git inspection. Shell control, substitution,
  redirection, backgrounding, explicit network clients/targets, AGY/agent CLIs,
  dangerous flags, tilde/globs, traversal, symlinks, and external or protected
  executable/argument paths are
  rejected syntactically. Pytest, npm, Node and similar runners execute
  workspace-controlled code that can have arbitrary semantics; this parser is
  not process or network containment. The AGY sandbox and host permissions remain
  the security boundary.
- The AGY tool and argument names are version-sensitive. Unknown tools are denied,
  but a future protocol needs new qualification before this adapter is promoted.
- `Stop` asks for only one continuation because AGY itself bounds repeated stop
  blocking. It records missing classification but cannot guarantee the model will
  produce a receipt before the host ultimately terminates. State/path exceptions
  emit protocol-valid `allow` with exit zero to terminate instead of requesting
  an uncounted continuation; repeated delivery or enforcement of that decision
  remains host behavior and is not a hard guarantee.
- The ASDS route recognizes only the exact native coordinator TypeName. The
  entry agent does not infer coordinator acceptance from a dispatch and cannot
  write planning state; the coordinator exclusively owns acceptance and
  persistence. Package manifests and capability markers are ASDS-owned design inputs;
  Accelerate validates but never manufactures them. Availability, semantic
  review quality, active coordinator acceptance, and planning semantics remain
  separate evidence.
- Hook commands use `python3 -I -B`, so `PYTHONPATH`, user site packages, and
  bytecode writes are suppressed. The `python3` executable itself is still
  resolved by AGY through the host `PATH`; plugin install does not bind that
  interpreter.

Protocol references used for this adapter are the official [plugins](https://antigravity.google/docs/plugins?tab=cli),
[custom agents](https://antigravity.google/docs/subagents?tab=cli), and
[lifecycle hooks](https://antigravity.google/docs/hooks?tab=cli) documentation,
plus the customization guides and protobuf surface embedded in the installed AGY 1.3.3 runtime.
