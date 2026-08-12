---
name: chatwoot-conversational-channel-operations
description: Operate Chatwoot conversational channels safely and reliably. Use for Chatwoot WhatsApp webhook ingestion, event handling, outbound delivery, queues, retries, dead-letter handling, opt-out, PII, delivery state, and human handoff; Chatwoot is the required WhatsApp adapter and WhatsApp Web, Baileys, and other providers are out of scope.
---

# Chatwoot Conversational Channel Operations

Use Chatwoot as the required WhatsApp adapter. Read
[`references/chatwoot-channel-operations.md`](references/chatwoot-channel-operations.md)
before changing webhook, queue, delivery, consent, or handoff behavior.

## Workflow

1. Identify the Chatwoot account, inbox, event type, event identity, trust
   boundary, and desired user-visible outcome.
2. Authenticate and validate the webhook before processing it. Persist a stable
   event identity and deduplicate before side effects.
3. Acknowledge valid webhooks quickly, enqueue durable work, and process it
   idempotently. Define bounded retries, retry classification, and a DLQ with a
   recovery owner.
4. Model acceptance, queueing, provider submission, and user delivery as
   distinct states. Do not present acceptance as delivery.
5. Apply opt-out and suppression before automated outbound action. Minimize
   PII in logs, events, analytics, and support views.
6. Define a human handoff trigger, ownership transfer, transcript context, and
   automation pause/resume behavior.

## Guardrails

- Do not use WhatsApp Web, Baileys, browser automation, or another messaging
  provider as a substitute for Chatwoot.
- Do not acknowledge an unauthenticated or malformed webhook as processed.
- Do not retry permanent validation, policy, or opt-out failures indefinitely.
- Do not expose message bodies, contact identifiers, tokens, or credentials in
  logs or handoff artifacts.

## Output Contract

Report webhook validation, event identity and deduplication, queue/retry/DLQ
policy, delivery-state model, opt-out/PII controls, human-handoff behavior,
and monitoring evidence.

## Resources

- [`references/chatwoot-channel-operations.md`](references/chatwoot-channel-operations.md):
  event, queue, delivery, privacy, and handoff checklist.
- `evals/evals.json`: trigger and output checks.
