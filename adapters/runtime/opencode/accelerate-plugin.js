/**
 * Accelerate v1 entry routing for OpenCode.
 *
 * This prompt adapter does not execute ASDS, enforce permissions, or rewrite
 * user content. The available skill and harness determine effective behavior.
 */
import { randomUUID } from 'node:crypto';

const PART_PREFIX = 'part_acc_v1_';
const ENTRY_PROMPT = `<ACCELERATE_ENTRY_ROUTING version="1.0.0">
Use the available Accelerate skill to classify and prepare this request.
Conversation: answer directly. Trivial bounded low-risk work: execute directly
with relevant verification, without ASDS or mandatory workflow artifacts.
Non-trivial work: hand objective, project, scope, constraints, risks, existing
authorizations, and useful evidence to spec-driven-superpowers (ASDS).
ASDS owns activation depth, specification, planning, execution, delegation,
review, integration, and completion. Do not impose duplicate Accelerate issue,
workspace, dispatch, planning, or closure gates. ASDS is independently usable.
Preserve ASDS ownership during follow-ups and do not reroute assigned workers.
If ASDS is unavailable, report the limitation; do not claim it was loaded or
silently restore legacy orchestration. The harness owns tools and permissions.
This injection provides routing instructions, not proof of runtime enforcement.
</ACCELERATE_ENTRY_ROUTING>`;

/** Return routing hooks for a root conversation, preserving all original text. */
export const AcceleratePlugin = async (context = {}) => ({
  'experimental.chat.messages.transform': async (_input, output) => {
    if (!Array.isArray(output?.messages)) return;
    const firstUser = output.messages.find(message => message.info?.role === 'user');
    if (!Array.isArray(firstUser?.parts)) return;

    const role = String(context.role || context.persona || process.env.ACCELERATE_ROLE || '').toLowerCase();
    const title = context.sessionTitle || firstUser.info.sessionTitle || '';
    const workflowOwner = String(context.workflowOwner || firstUser.info.workflowOwner || '').toLowerCase();
    if (role.includes('worker') || /\[W-[a-zA-Z0-9_-]+\]/i.test(title)) return;
    if (workflowOwner === 'asds' || workflowOwner === 'spec-driven-superpowers') return;

    // Only our generated part is an idempotency marker; user text is untouched.
    if (firstUser.parts.some(part => part?.type === 'text'
      && typeof part.id === 'string' && part.id.startsWith(PART_PREFIX)
      && part.text === ENTRY_PROMPT)) return;

    firstUser.parts.unshift({
      id: `${PART_PREFIX}${randomUUID().replace(/-/g, '')}`,
      type: 'text',
      text: ENTRY_PROMPT,
    });
  },
});

export default AcceleratePlugin;
