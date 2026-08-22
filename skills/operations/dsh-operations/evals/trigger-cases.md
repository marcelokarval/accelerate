# DSH Operations Trigger Cases

## should trigger

- prompt: Upgrade the pinned DSH release and preserve the LAN patches.
  expected: dsh-operations
- prompt: Diagnose why Code Orchestrated cannot load Accelerate in a new session.
  expected: dsh-operations
- prompt: Prove the DeepSeek Harness service and skill catalog after restart.
  expected: dsh-operations

## should not trigger

- prompt: Implement a Django endpoint while using DSH as the chat client.
  expected: no-trigger
- prompt: Change OmniRouter's coding pool priority.
  expected: no-trigger
