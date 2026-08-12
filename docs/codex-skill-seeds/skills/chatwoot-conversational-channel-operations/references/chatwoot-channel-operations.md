# Chatwoot Channel Operations Checklist

## Ingress and Idempotency

- Treat Chatwoot webhooks as untrusted until the configured authentication or
  signature mechanism is validated for the installed integration.
- Define a stable event identity from the provider payload and persist a
  deduplication record before performing a side effect.
- Acknowledge only valid events quickly; enqueue durable work and make consumer
  handling idempotent.

## Delivery and Failure

- Model inbound acceptance, queued, submitted, delivered, failed, and unknown
  separately. Only a delivery signal may be presented as delivered.
- Classify failures as retryable or permanent. Use bounded retries with jitter
  where supported and send exhausted or ambiguous cases to a DLQ with a named
  recovery owner.
- Preserve enough correlation data to investigate an event without logging full
  message bodies, contact identifiers, access tokens, or credentials.

## Human and Privacy Controls

- Check opt-out and suppression before automated outbound sends. Preserve a
  durable opt-out decision across retries and enrichment.
- Define when automation pauses, what transcript/context the human receives,
  who owns the conversation, and when automation can resume.
- Use Chatwoot for the WhatsApp adapter. WhatsApp Web, Baileys, browser
  automation, and alternative providers are out of scope.
