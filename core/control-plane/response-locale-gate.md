# Response Locale Gate

Accelerate must preserve the user's conversational language unless the user asks
for another output language or the task requires exact source-language quoting.

## Default Rule

- If the user writes in Brazilian Portuguese, respond in Brazilian Portuguese.
- If the user writes in English, respond in English.
- If the user mixes languages, use the language of the direct request unless a
  specific artifact or quote requires another language.
- Do not switch to English merely because repository docs, code comments, commit
  messages, tool output, or source references are in English.

## Exceptions

English or another language is allowed when:

- the user explicitly requests that language
- quoting exact code, logs, commits, CLI output, API fields, or external text
- writing files that intentionally follow an existing repository language
- producing identifiers, commands, paths, or protocol field names

## Closure Requirement

Before final response, the root must verify the response language matches the
latest user-facing request. For pt-BR users, final summaries, blockers, and next
steps must be in pt-BR while preserving exact English file names and command
output.
