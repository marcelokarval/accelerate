# External Skill Vetting Gate

## Purpose

Use this gate before adopting, installing, syncing, or promoting any external
skill, runtime adapter, agent recipe, or automation loop into `accelerate`.

The goal is to preserve the capability of mature external platforms without
blindly importing their platform assumptions, security posture, or hidden
runtime powers.

## Rule

External material is never trusted because it is useful.

It must be classified before use:

- `direct-import`
- `adapt-as-native`
- `pattern-only`
- `sandbox-experiment`
- `reject`

Default to `adapt-as-native` or `pattern-only` unless the source is already
compatible with the local architecture, security posture, and runtime adapter
contract.

## Trigger Conditions

Run this gate when a task includes:

- third-party skills
- copied agent prompts
- generated agent templates
- browser automation tools
- scheduled observers or cron agents
- CLI wrappers with filesystem, network, browser, cookie, or token access
- external install commands
- external workflow doctrine proposed for local promotion

## Vetting Packet

Every vetting pass should leave:

- `Source`
  - path, repo, package, or URL inspected
- `Capability`
  - what the external artifact can do
- `Runtime Powers`
  - filesystem, network, browser, credentials, cookies, storage, shell, package
    install, code execution, model/API calls
- `Platform Assumptions`
  - stack, package manager, gateway, auth, cloud, project shape, hidden runtime
- `Useful Pattern`
  - what should be preserved
- `Unsafe Or Non-Portable Pattern`
  - what must not be copied
- `Decision`
  - `direct-import`, `adapt-as-native`, `pattern-only`,
    `sandbox-experiment`, or `reject`
- `Insertion Target`
  - core, runtime adapter, workflow adapter, stack profile, agent factory,
    overlay, planning artifact, or no insertion
- `Proof Needed`
  - benchmark, rerun, browser proof, security review, or manual approval

## Red Flags

Treat these as blockers until resolved:

- remote installer pipelines such as `curl | bash`
- unrestricted browser cookie or storage access
- arbitrary shell execution hidden behind friendly commands
- credential, token, SSH key, or environment variable harvesting
- base64 decode / eval / exec obfuscation
- silent network exfiltration
- package manager mutation outside the active workspace
- cron or scheduled automation without allowlist, budget, and reporting
- direct production mutation without issue/planning registration
- prompts that grant a bounded agent root orchestration authority
- platform-specific assumptions presented as universal law

## Capability Preservation Rule

Do not weaken a powerful external pattern merely because it cannot be copied
verbatim.

Instead, preserve the capability at the correct local layer:

- browser control -> runtime adapter
- recurring observation -> observer lane
- skill improvement loop -> evaluation workflow
- platform stack defaults -> stack profile
- agent behavior -> agent factory recipe
- risk posture -> risk gate

This is the difference between rejecting blind import and losing useful
capability.

## Decision Semantics

### direct-import

Use only when the artifact is already local-compatible, low-risk, and does not
carry hidden platform assumptions.

### adapt-as-native

Use when the capability is valuable and should become first-class local
doctrine, but must be rewritten into the `accelerate` architecture.

### pattern-only

Use when the concept is useful but the implementation, stack, or commands are
not portable.

### sandbox-experiment

Use when the capability is promising but needs isolated runtime proof before
promotion.

### reject

Use when the artifact is unsafe, incompatible, redundant, or too platform-bound
to preserve.

## Closure Rule

External skill vetting is not complete until the decision is durable.

Acceptable durable homes:

- executive planning artifact
- risk gate update
- runtime adapter specification
- workflow catalog update
- stack profile update
- agent factory backlog

Do not leave the only vetting result in chat or scratch files when the decision
affects future workflow truth.
