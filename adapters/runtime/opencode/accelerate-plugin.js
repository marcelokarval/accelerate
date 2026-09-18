/**
 * Accelerate Sovereign Control Plane Plugin for OpenCode
 *
 * Injects canonical Accelerate governance context (v0.3.0) into OpenCode sessions,
 * establishes orchestrator root laws, deprecates Superpowers 1% unconditional trigger,
 * enforces Zero-Waste pipeline discipline, and suppresses residual Superpowers injections.
 */

const ACCELERATE_CONTROL_PLANE_HEADER = '<ACCELERATE_SOVEREIGN_CONTROL_PLANE>';
const ACCELERATE_CONTROL_PLANE_FOOTER = '</ACCELERATE_SOVEREIGN_CONTROL_PLANE>';

const ACCELERATE_INJECTION_BODY = `${ACCELERATE_CONTROL_PLANE_HEADER}
# ACCELERATE SOVEREIGN CONTROL PLANE (v0.3.0)
Root Orchestrator Law & Zero-Waste Pipeline Enforced

[ORCH] -> Root orchestrator holds sovereign authority: classification, prompt hardening,
routing, delegation, proof ordering, and forensic closure.

1. SUPERPOWERS DEPRECATION & NATIVE ABSORPTION:
   - The external "1% skill trigger" rule from Superpowers is OFFICIALLY DEPRECATED and SUPERSEDED.
   - Spec-Driven Development (SDD) is absorbed natively as One-Shot Protocol & Architecture Specs.
   - Brainstorming is absorbed natively as Prompt Hardening & Semantic Implication Gate (Stage A/B).
   - Never yield root control to external process loops or unconditional skill traps.

2. ZERO-WASTE PIPELINE & DELEGATION CONVENTION:
   - Bounded task executors must be dispatched with clear scope, success criteria, and stop rules.
   - When communicating or tracking delegated work across workers, enforce the canonical convention:
     \`[ORCH] -> [W-<num>] <icon>\` (e.g. \`[ORCH] -> [W-1] ⚡\`, \`[ORCH] -> [W-2] 🔍\`).
   - Sisyphus / Root Orchestrator does not execute task-owned slices assigned to workers.
   - Workers never inherit root closure authority; only Root declares Done.

3. PROOF & CLOSURE DISCIPLINE:
   - Proof stack order: 1. Implementation Proof -> 2. QA Proof -> 3. Browser/Runtime Truth -> 4. Persistent Regression -> 5. Forensic Closure.
   - No evidence = Not complete.
${ACCELERATE_CONTROL_PLANE_FOOTER}`;

// Regex to detect and strip residual Superpowers injection
const SUPERPOWERS_RESIDUAL_REGEX = /<EXTREMELY_IMPORTANT>[\s\S]*?You have superpowers[\s\S]*?<\/EXTREMELY_IMPORTANT>\s*/gi;

export const AcceleratePlugin = async (_context) => {
  return {
    /**
     * Hook: experimental.chat.messages.transform
     * Fires on every agent step when messages are loaded/transformed.
     */
    'experimental.chat.messages.transform': async (_input, output) => {
      if (!output || !Array.isArray(output.messages) || !output.messages.length) {
        return;
      }

      // 1. Active suppression of any residual Superpowers prompt blocks across all messages
      for (const msg of output.messages) {
        if (Array.isArray(msg.parts)) {
          for (const part of msg.parts) {
            if (part && part.type === 'text' && typeof part.text === 'string') {
              if (SUPERPOWERS_RESIDUAL_REGEX.test(part.text)) {
                part.text = part.text.replace(SUPERPOWERS_RESIDUAL_REGEX, '').trim();
              }
            }
          }
        }
      }

      const firstUser = output.messages.find(m => m.info && m.info.role === 'user');
      if (!firstUser || !Array.isArray(firstUser.parts) || !firstUser.parts.length) {
        return;
      }

      // 2. Idempotency guard: do not inject if Accelerate control plane is already present
      const alreadyInjected = firstUser.parts.some(
        p => p && p.type === 'text' && typeof p.text === 'string' && p.text.includes(ACCELERATE_CONTROL_PLANE_HEADER)
      );
      if (alreadyInjected) {
        return;
      }

      // 3. Inject Accelerate Sovereign Control Plane block at top of the first user message
      const refPart = firstUser.parts[0];
      firstUser.parts.unshift({
        ...refPart,
        type: 'text',
        text: ACCELERATE_INJECTION_BODY
      });
    }
  };
};

export default AcceleratePlugin;
