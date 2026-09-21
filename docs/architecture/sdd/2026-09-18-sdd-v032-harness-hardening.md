# SDD: Accelerate v0.3.2 Harness Hardening & OpenCode Integration

- **Document ID**: SDD-ACC-032
- **Date**: 2026-09-18
- **Status**: APPROVED
- **Target Cycle**: v0.3.2
- **Author**: Platform Architecture & Systems Engineering (W-CONTRACT)

---

## 1. System Overview and Architecture

The Accelerate v0.3.2 harness acts as the runtime policy and message sanitization layer between the OpenCode agent engine, the language model API, and local workspace execution environments.

```
       ┌────────────────────────────────────────────────────────┐
       │                   OpenCode Agent Host                  │
       └───────────────────────────┬────────────────────────────┘
                                   │ Chat Turn / Tool Dispatch
                                   ▼
       ┌────────────────────────────────────────────────────────┐
       │          Accelerate Hardening Plugin Layer             │
       │                                                        │
       │  ┌─────────────────────────┐ ┌───────────────────────┐ │
       │  │ AST / Delimited Parser  │ │ Envelope Hash Guard   │ │
       │  └────────────┬────────────┘ └───────────┬───────────┘ │
       │               │                          │             │
       │  ┌────────────▼────────────┐ ┌───────────▼───────────┐ │
       │  │ Message Transformer     │ │ Role & Scope Enforcer │ │
       │  │ (experimental.chat.*)   │ │ (Persona RBAC)        │ │
       │  └─────────────────────────┘ └───────────────────────┘ │
       └───────────────────────────┬────────────────────────────┘
                                   │
               ┌───────────────────┴───────────────────┐
               ▼                                       ▼
    ┌──────────────────────┐                ┌──────────────────────┐
    │ Master Orchestrator  │                │    Atomic Worker     │
    │  (Zero-Mutation)     │                │   (Isolated WT)      │
    └──────────────────────┘                └──────────────────────┘
```

---

## 2. Component Specifications

### 2.1 Message Transform Pipeline (`MessageTransformer`)
Implements OpenCode's `experimental.chat.messages.transform` hook.

#### Interface:
```typescript
export interface MessagePart {
  id: string;
  type: 'text' | 'image' | 'tool_use' | 'tool_result' | 'thinking';
  content?: string;
  data?: Record<string, unknown>;
  metadata?: Record<string, unknown>;
}

export interface ChatMessage {
  id: string;
  role: 'user' | 'assistant' | 'system';
  parts: MessagePart[];
}

export interface TransformContext {
  sessionId: string;
  persona: 'acc-master' | 'acc-worker' | 'subagent';
  modelId: string;
}

export type MessageTransformHook = (
  messages: ChatMessage[],
  context: TransformContext
) => Promise<ChatMessage[]>;
```

#### Transformation Rules:
1. **Quotation & Codeblock Preservation**:
   - Tokenize text part into fenced code blocks (AST nodes) vs. conversational prose.
   - Code blocks are marked immutable; no suppression rules apply inside fenced blocks.
2. **Superpowers Prompt Artifact Stripping**:
   - Only matching system prompts outside code blocks bounded by exact semantic tokens `<!-- BEGIN_SUPERPOWERS_PROMPT -->` and `<!-- END_SUPERPOWERS_PROMPT -->` are excised.
3. **Multi-Part Passthrough**:
   - Parts with `type != 'text'` pass through the pipeline without structural modification or type casting.

### 2.2 Envelope Hash Verifier (`ProvenanceGuard`)
Calculates and verifies deterministic SHA-256 signatures across worker and transition boundaries.

#### Algorithm:
1. Normalize payload using RFC 8785 JSON Canonicalization Scheme (JCS).
2. Hash normalized UTF-8 byte stream using SHA-256:
   $$\text{digest} = \text{hex}(\text{sha256}(\text{JCS}(P)))$$
3. Match against header or envelope attribute `provenance_hash`.
4. If invalid: Raise `ProvenanceTamperingError` and halt pipeline.

### 2.3 Role & Scope Enforcer (`PersonaRBAC`)
Intercepts tool call registrations and invocations.

#### Enforcement Matrix:

| Tool Name / Category | Master Orchestrator (`acc-master`) | Atomic Worker (`acc-worker`) | Subagents (Read-Only) |
|---|---|---|---|
| `acc_dispatch_worker` | **ALLOW** | **DENY (BLOCKED)** | **DENY (BLOCKED)** |
| `acc_dispatch_wave` | **ALLOW** | **DENY (BLOCKED)** | **DENY (BLOCKED)** |
| `acc_fanin_worker` | **ALLOW** | **DENY (BLOCKED)** | **DENY (BLOCKED)** |
| `acc_execute_plane_sync`| **ALLOW** | **DENY (BLOCKED)** | **DENY (BLOCKED)** |
| `write` / `edit` (App) | **DENY (Zero-Mutation)** | **ALLOW (Worktree Only)**| **DENY (BLOCKED)** |
| `bash` (Test Runner) | **ALLOW (Read-Only/Audit)**| **ALLOW (Worktree Only)**| **DENY (BLOCKED)** |
| `read` / `glob` / `grep`| **ALLOW** | **ALLOW** | **ALLOW** |

---

## 3. State Transition Matrix & Error Handling

### 3.1 Lifecycle Transitions

```
[INIT] ──► [PARSED] ──► [SANITY_CHECK] ──► [ENVELOPE_VERIFIED] ──► [TRANSFORMED] ──► [DISPATCHED]
   │          │                │                     │                   │
   ▼          ▼                ▼                     ▼                   ▼
[ABORT:    [ABORT:         [ABORT:               [ABORT:             [ABORT:
Syntax]    Format]         Unauth Role]          Bad Hash]           Plugin Failure]
```

### 3.2 Error Handlers
- `ProvenanceVerificationException`: Emits audit log to `.accelerate/audit.log` and marks task status as `FAILED_SECURITY_CHECK`.
- `ParserFenceException`: Falls back safely to raw text without stripping; alerts telemetry of unparseable markdown structure.
- `RoleViolationException`: Intercepts tool call before execution and returns structured refusal JSON to the model: `{"error": "FORBIDDEN_ROLE_ACTION", "role": "acc-worker", "tool": "acc_dispatch_worker"}`.
