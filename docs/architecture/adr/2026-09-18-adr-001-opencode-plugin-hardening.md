# ADR 001: OpenCode Plugin Hardening, Envelope Provenance & Role Sandboxing

- **Status**: ACCEPTED
- **Date**: 2026-09-18
- **Deciders**: Platform Architecture, Security Engineering, Core Platform Team
- **Context**: Accelerate Cycle v0.3.2 Consolidation

---

## 1. Context and Problem Statement

Accelerate relies on an OpenCode plugin hook system (`experimental.chat.messages.transform`) to sanitize contextual prompts, suppress conflicting superpower prompts, enforce operational invariants, and govern task delegation. In cycle v0.3.1:
1. Regex-based prompt cleaning was prone to ReDoS and stripped legitimate user code blocks (e.g. documentation on prompt engineering or code containing XML-like tags).
2. Deeply nested quotes and multiline fences caused premature token termination.
3. Execution receipts lacked provenance verification, leaving the system vulnerable to hallucinated or fabricated task completion reports.
4. Workers lacked strict role sandboxing at the tool registry layer, creating risk of recursive worker spawning.

---

## 2. Considered Options

1. **Option 1: Status Quo with Tuned Regexes**
   - *Pros*: Minimal code changes.
   - *Cons*: Inherently fragile, cannot handle recursive markdown fences, high risk of false-positive stripping and ReDoS.

2. **Option 2: Complete External Proxy Architecture**
   - *Pros*: Completely decouples prompt transformation from OpenCode process.
   - *Cons*: Adds network latency, complicates local setup, breaks offline portability.

3. **Option 3: Delimited Token & AST-Based Transformer with Canonical Envelope Hashing & Role-Based Tool Scoping (Selected)**
   - *Pros*: Deterministic syntax awareness, zero false positives on legitimate code, cryptographic authenticity for receipts, strict role-based tool whitelisting.
   - *Cons*: Requires formal schema definition and migration of existing transformation functions.

---

## 3. Decision Outcome

We choose **Option 3**: Delimited Token & AST-Based Transformer with Canonical Envelope Hashing and Role-Based Tool Scoping.

### Key Architectural Pillars:

### 3.1 AST & Delimited Token Parsing
- Superpowers prompt artifacts MUST be isolated using explicit, uniquely generated session-boundary fences or parsed into an Abstract Syntax Tree (AST) representation of markdown blocks.
- Unstructured global regex matches (`/<!-- superpowers -->[\s\S]*?<!-- \/superpowers -->/g`) are banned. Instead, strict state-machine parsers scan tokens and preserve all code blocks (fenced with ``` or ~~~) regardless of text contents.

### 3.2 Canonical Envelope Hash Verification
- Every delegated payload and completion report is serialized using RFC 8785 (JSON Canonicalization Scheme - JCS).
- A SHA-256 hash is computed over the canonical envelope:
  $$\text{Hash} = \text{SHA-256}(\text{JCS}(\text{Payload}))$$
- Handshake receipts carry this hash. State machines in Master Orchestrator, Git fan-in routines, and Plane sync adapters refuse to process any transition lacking a verifiable matching hash.

### 3.3 Role-Based Tool Governance
Tool registration and dispatch resolution implement role-based whitelisting via persona inspection:
- `persona: acc-master`:
  - Allowed: `acc_dispatch_worker`, `acc_dispatch_wave`, `acc_fanin_worker`, `acc_execute_plane_sync`, `todowrite`, etc.
  - Denied: Local file mutation tools (`write`, `edit`) on application directories.
- `persona: acc-worker`:
  - Allowed: `read`, `write`, `edit`, `bash` (in worktree), `todowrite`, `lsp_*`.
  - Denied: `acc_dispatch_worker`, `acc_dispatch_wave`, `acc_execute_plane_sync`.
- `persona: subagent` (Explore/Librarian):
  - Allowed: `read`, `grep`, `glob`, read-only LSP, context tools.
  - Denied: All mutations, all dispatch tools.

---

## 4. Consequences and Invariants

### Positive:
- Total resilience against prompt truncation caused by nested quotes.
- Safe suppression of unwanted system prompt bloat without collateral destruction of user source code.
- Cryptographic prevention of spoofed receipts.
- Immune to recursive orchestration loops.

### Negative / Trade-offs:
- Minor parsing latency overhead (measured < 2ms for typical prompt contexts).
- Requires canonical serialization library (`canonicalize` / `fast-json-stable-stringify`).

### Invariants:
- All transform pipelines must be idempotent: $T(T(M)) == T(M)$.
- Non-text message parts must remain immutable during text transformations.
