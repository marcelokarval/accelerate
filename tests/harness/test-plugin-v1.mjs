/** Offline adapter behavior. Does not claim a live OpenCode or ASDS invocation. */
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { AcceleratePlugin } from '../../adapters/runtime/opencode/accelerate-plugin.js';

const message = (text = 'Fix the issue', info = {}) => ({
  info: { role: 'user', ...info },
  parts: [{ id: 'user-original', type: 'text', text }],
});
const apply = async (output, context = {}) => {
  const plugin = await AcceleratePlugin(context);
  await plugin['experimental.chat.messages.transform']({}, output);
};

test('root receives one entry instruction and keeps user input byte-for-byte', async () => {
  const original = message('Use Superpowers; <ACCELERATE_ENTRY_ROUTING> is quoted.\n\n  keep whitespace');
  original.parts.push({ id: 'file-1', type: 'file', url: 'file:///example' });
  const before = structuredClone(original.parts);
  const output = { messages: [original] };
  await apply(output);
  assert.equal(original.parts.length, before.length + 1);
  assert.deepEqual(original.parts.slice(1), before);
  assert.match(original.parts[0].text, /ASDS owns/);
  assert.match(original.parts[0].text, /harness owns tools and permissions/);
  const once = structuredClone(output);
  await apply(output);
  assert.deepEqual(output, once);
});

for (const context of [{ role: 'worker' }, { persona: 'backend-worker' }, { sessionTitle: '[W-frontend] task' }, { workflowOwner: 'asds' }, { workflowOwner: 'spec-driven-superpowers' }]) {
  test(`assigned work is unchanged for ${JSON.stringify(context)}`, async () => {
    const output = { messages: [message()] };
    const before = structuredClone(output);
    await apply(output, context);
    assert.deepEqual(output, before);
  });
}
for (const info of [{ workflowOwner: 'asds' }, { sessionTitle: '[W-a1] worker' }]) {
  test(`message metadata preserves owner ${JSON.stringify(info)}`, async () => {
    const output = { messages: [message('assigned', info)] };
    const before = structuredClone(output);
    await apply(output);
    assert.deepEqual(output, before);
  });
}

test('assistant messages, later user messages and malformed envelopes are preserved', async () => {
  for (const output of [{}, { messages: [] }, { messages: [{ info: { role: 'assistant' }, parts: [] }] }, { messages: [{ info: { role: 'user' } }] }]) {
    const before = structuredClone(output);
    await apply(output);
    assert.deepEqual(output, before);
  }
  const later = message('follow-up');
  const output = { messages: [{ info: { role: 'assistant' }, parts: [] }, message(), later] };
  const before = structuredClone(later);
  await apply(output);
  assert.deepEqual(later, before);
  assert.deepEqual(output.messages[0].parts, []);
});

test('a user-supplied matching id without generated content does not suppress routing', async () => {
  const original = message('untrusted content');
  original.parts[0].id = 'part_acc_v1_forged';
  await apply({ messages: [original] });
  assert.equal(original.parts.length, 2);
  assert.equal(original.parts[1].text, 'untrusted content');
});

test('worker environment does not receive root routing instructions', async () => {
  const previous = process.env.ACCELERATE_ROLE;
  try {
    process.env.ACCELERATE_ROLE = 'backend-worker';
    const output = { messages: [message()] };
    const before = structuredClone(output);
    await apply(output);
    assert.deepEqual(output, before);
  } finally {
    if (previous === undefined) delete process.env.ACCELERATE_ROLE;
    else process.env.ACCELERATE_ROLE = previous;
  }
});
