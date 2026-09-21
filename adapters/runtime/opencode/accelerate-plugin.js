/**
 * Accelerate Sovereign Control Plane Plugin for OpenCode
 *
 * Injects canonical Accelerate governance context (v0.3.0) into OpenCode sessions,
 * establishes orchestrator root laws or atomic worker laws, deprecates Superpowers 1% unconditional trigger,
 * enforces Zero-Waste pipeline discipline, and surgically suppresses residual Superpowers injections.
 */

import crypto from 'crypto';

const ACCELERATE_CONTROL_PLANE_HEADER = '<ACCELERATE_SOVEREIGN_CONTROL_PLANE>';
const ACCELERATE_CONTROL_PLANE_FOOTER = '</ACCELERATE_SOVEREIGN_CONTROL_PLANE>';

const CANONICAL_VERSION_TAG = '# ACCELERATE SOVEREIGN CONTROL PLANE (v0.3.0)';
const CANONICAL_WORKER_VERSION_TAG = '# ACCELERATE ATOMIC WORKER LAW (v1.1)';

const ACCELERATE_MASTER_INJECTION_BODY = `${ACCELERATE_CONTROL_PLANE_HEADER}
${CANONICAL_VERSION_TAG}
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

const ACCELERATE_WORKER_INJECTION_BODY = `${ACCELERATE_CONTROL_PLANE_HEADER}
${CANONICAL_WORKER_VERSION_TAG}
Atomic Task Worker Persona Constraints & Zero-Recursion Enforced

[WORKER] -> Atomic Worker operates under strictly bounded task authority in an isolated Git Worktree.

1. STRICT TEST-DRIVEN DEVELOPMENT (THE IRON LAW):
   - NO production code may be written without a failing test first (RED -> GREEN -> REFACTOR).
   - Real local runtime validation, never mock away real behavior.

2. SCOPE BOUNDARY & ANTI-RECURSION:
   - Touch ONLY files declared in assigned task contract.
   - Zero scope leakage outside declared contract files.
   - Anti-Recursion: Never re-orchestrate or spawn child worker sessions. Focus exclusively on assigned task.

3. INDEPENDENT REVIEW & COMPLETION REPORT:
   - Perform clean forensic self-review of git diff.
   - Return Worker Completion Report adhering to schema. Never merge to master.
${ACCELERATE_CONTROL_PLANE_FOOTER}`;

/**
 * Surgical Superpowers Suppression Regex:
 * Targets only actual bootstrap system injections that mandate compulsory 1% invocation or skill traps.
 * Preserves user discussions, documentation, and source code.
 */
const SUPERPOWERS_BOOTSTRAP_INJECTION_REGEX = /<EXTREMELY_IMPORTANT>\s*You have superpowers[\s\S]*?(?:1%\s*of\s*(?:the\s*)?time|always\s+invoke\s+skills|automatically\s+invoke\s+skill)[\s\S]*?<\/EXTREMELY_IMPORTANT>\s*/gi;

/**
 * Checks if a text part is an authentic canonical envelope.
 */
function isCanonicalEnvelope(text, role) {
  if (!text || typeof text !== 'string') return false;
  if (!text.includes(ACCELERATE_CONTROL_PLANE_HEADER) || !text.includes(ACCELERATE_CONTROL_PLANE_FOOTER)) {
    return false;
  }
  if (role === 'worker' || role === 'acc-worker') {
    return text.includes(CANONICAL_WORKER_VERSION_TAG) || text.includes(CANONICAL_VERSION_TAG);
  }
  return text.includes(CANONICAL_VERSION_TAG);
}

/**
 * Sanitizes fake or spoofed envelopes from a text string.
 */
function sanitizeSpoofedEnvelopes(text) {
  if (!text || typeof text !== 'string') return text;
  if (!text.includes(ACCELERATE_CONTROL_PLANE_HEADER)) return text;

  // Replace spoofed or incomplete envelopes that lack the canonical version header
  const envelopeRegex = /<ACCELERATE_SOVEREIGN_CONTROL_PLANE>([\s\S]*?)<\/ACCELERATE_SOVEREIGN_CONTROL_PLANE>/gi;
  return text.replace(envelopeRegex, (match, innerContent) => {
    if (innerContent.includes(CANONICAL_VERSION_TAG) || innerContent.includes(CANONICAL_WORKER_VERSION_TAG)) {
      return match;
    }
    // Neutralize spoofing by disarming tags
    return `[SANITIZED_SPOOFED_ENVELOPE: ${innerContent.trim()}]`;
  });
}

export const AcceleratePlugin = async (context = {}) => {
  return {
    /**
     * Hook: experimental.chat.messages.transform
     * Fires on every agent step when messages are loaded/transformed.
     */
    'experimental.chat.messages.transform': async (_input, output) => {
      if (!output || !Array.isArray(output.messages) || !output.messages.length) {
        return;
      }

      // Determine role from plugin context, environment, or metadata
      const envRole = process.env.ACCELERATE_ROLE || '';
      const declaredRole = (context.role || context.persona || envRole || '').toLowerCase();
      const isWorker = declaredRole.includes('worker') || declaredRole === 'acc-worker';

      // 1. Surgical suppression of residual Superpowers prompt blocks across all messages
      for (const msg of output.messages) {
        if (Array.isArray(msg.parts)) {
          for (const part of msg.parts) {
            if (part && part.type === 'text' && typeof part.text === 'string') {
              if (SUPERPOWERS_BOOTSTRAP_INJECTION_REGEX.test(part.text)) {
                part.text = part.text.replace(SUPERPOWERS_BOOTSTRAP_INJECTION_REGEX, '').trim();
              }
              // Neutralize spoofed control plane envelopes
              part.text = sanitizeSpoofedEnvelopes(part.text);
            }
          }
        }
      }

      const firstUser = output.messages.find(m => m.info && m.info.role === 'user');
      if (!firstUser || !Array.isArray(firstUser.parts) || !firstUser.parts.length) {
        return;
      }

      // Check session title / metadata if present in firstUser or context
      const sessionTitle = context.sessionTitle || (firstUser.info && firstUser.info.sessionTitle) || '';
      const effectiveIsWorker = isWorker || /\[W-[a-zA-Z0-9_-]+\]/i.test(sessionTitle);

      // 2. Structured canonical envelope validation (avoid naive substring presence)
      const hasCanonicalEnvelope = firstUser.parts.some(
        p => p && p.type === 'text' && isCanonicalEnvelope(p.text, effectiveIsWorker ? 'worker' : 'master')
      );

      if (hasCanonicalEnvelope) {
        return;
      }

      // 3. Inject appropriate canonical envelope with guaranteed unique ID
      const injectionBody = effectiveIsWorker
        ? ACCELERATE_WORKER_INJECTION_BODY
        : ACCELERATE_MASTER_INJECTION_BODY;

      const uniquePartId = `part_acc_${crypto.randomUUID ? crypto.randomUUID().replace(/-/g, '').slice(0, 12) : Date.now().toString(36)}`;

      firstUser.parts.unshift({
        id: uniquePartId,
        type: 'text',
        text: injectionBody
      });
    }
  };
};

export default AcceleratePlugin;
